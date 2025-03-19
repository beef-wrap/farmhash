using System;
using System.Collections;
using System.Diagnostics;
using System.IO;
using System.Interop;
using System.Text;

using static farmhash.farmhash;

namespace example;

static class Program
{
	static int Main(params String[] args)
	{
		let hash32 = farmhash32("test", 4);
		Debug.WriteLine($"hash32: {hash32}");

		let hash32seeded = farmhash32_with_seed("test", 4, 1);
		Debug.WriteLine($"hash32seeded: {hash32seeded}");

		let hash64 = farmhash64("test", 4);
		Debug.WriteLine($"hash64: {hash64}");

		let hash64seeded = farmhash64_with_seed("test", 4, 1);
		Debug.WriteLine($"hash64seeded: {hash64seeded}");

		return 0;
	}
}