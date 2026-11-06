Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8649606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 20:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=TlwOujbp
Received: by kanga.kvack.org (Postfix)
	id D2AAA6B05B9; Fri,  6 Nov 2026 15:46:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D026F6B05BA; Fri,  6 Nov 2026 15:46:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C188B6B05BB; Fri,  6 Nov 2026 15:46:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 905296B05B9
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:46:48 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2E003C01B6
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:46:48 +0000 (UTC)
X-FDA: 85405878096.13.69A4A0D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf19.hostedemail.com (Postfix) with ESMTP id 78A361A000D
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:46:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TlwOujbp;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793998006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=jIADSJVPuQfL5gsl75hN5umXlpPdcC0mAOe4mGJ7x+I=;
	b=UXUpFVmp5FchWJvSZWfP2vVgjk7jPccvzIwQJJ9T3ewP9ROkTvYEnt6JweP6V3QMMKYkwT
	nRz0WfbF2g7nu2L4N+Ku7Gt0x9QTuYcSU7NQBVu5ys5jZBm42DxnPFe5xe1irpLoKpXl7c
	s9KHj2oMjUjVTqrl75NGErA4n2lWk70=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TlwOujbp;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793998006;
	b=Wk1I8FrSOd8QXtWGmvOXLFuXQ1rvjZswFo+voBrUwNMI+K6VIf9ybMXycZQa3N6oQ/MDrf
	pgbW93ZPZNwnRIOJuiff5mu1HpSFFoEefAG48PEkhU2BpkhkP23mf0A+VJkW8bBKG+Tvnv
	rmrK0S2pbf6jrjnScnRQwP1+8MQjMe4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793998005; x=1825534005;
  h=date:from:to:cc:subject:message-id;
  bh=Sn7im5GOD3/X9wwaDEsBsmyh+uQ16veT7IBG7auDrGY=;
  b=TlwOujbp+d5hR5nziJFpovgE8YD+5VkzBwg25Qvah7d+d5cwlzVV4xcr
   4eY1Aoe1x7bk8ni4B2h851pw9TngITh7MdR2+TR43cTRDKgy0xRo3sgO9
   6i8Jb6Xxp744TZTjyEzHrw82Gbwyovu/U47z9yXQbTkJREjP35ANBe+I0
   FnjDKTlre9a9zgSwGLh87XdkjuKN/p2I9GI3SP+alk/e6pHhHJyxViA1S
   4TUXLLcGLeA4EumqxwyAptgfrCo439I5Tgu/7TBSC39NuiM0YMsKGDdzm
   xPXN4bJ/zEAH3TvmYbkoxKem3gBd6bj1Ov4OVtiKxd9Debt+yjhWLJ3a1
   w==;
X-CSE-ConnectionGUID: EtHzWORpTHW1Rxf0JYtugQ==
X-CSE-MsgGUID: bqpT6iM8Qa+1JofxNm1sEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11958"; a="2814872"
X-IronPort-AV: E=Sophos;i="6.27,199,1787036400"; 
   d="scan'208";a="2814872"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 12:46:44 -0800
X-CSE-ConnectionGUID: RmYHFKgPTAK/HmYv62iIjA==
X-CSE-MsgGUID: K015T0MIQVeqNBldG5g6hQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,199,1787036400"; 
   d="scan'208";a="7259002"
Received: from igk-lkp-server01.igk.intel.com (HELO 58ca8a381a5c) ([10.211.93.152])
  by orviesa005.jf.intel.com with ESMTP; 06 Nov 2026 12:46:42 -0800
Received: from kbuild by 58ca8a381a5c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xPQpb-00000000AM7-2c1b;
	Fri, 06 Nov 2026 20:46:39 +0000
Date: Fri, 06 Nov 2026 21:46:08 +0100
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>
Subject: [akpm-mm:mm-unstable 225/232]
 include/linux/alloc_tag.h:159:24: error: duplicate 'inline' declaration
 specifier
Message-ID: <202611062117.gKtstiMc-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: z6gbgzfk4hr57jmx53ny5e14to886gzt
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 78A361A000D
X-HE-Tag: 1793998005-748320
X-HE-Meta: U2FsdGVkX19nPRarRJAEDblid6Z1una2aFXx5rt8d218MoFFZIiE6M+bXilA8MXC9T5spn1ua+r5r9S594YUppuXVXzOMv/4kzVsXJ96T09UCQLlNNo1uyR789Vb25wP2hav+aOqS4fnCz5hpGWGZrk296UbLTHkoeg8NxmauBUQZxu5gqQaHCFWjbzI2sndY3ZZ9OW/qPjdC9zMqfPE8b7RyVsjZNg5g09WPu8ducNjN/fSz4Qdts7Y5YAEfMdVKFjQVHkQhIMWcVr/yO32FmvJEqKxMXUnTuR8DabCvnZk+2scWv/Bsuh+QR/ixOKc/UYsKG7SpVA5F689k0VSrZN7tnYaq3VH5C9Wa+Zup9e93GYAQpH0AT3EWbuh5Ev6Ki5MepNlWQ7gclyq5f7Ak4atcPbohWo9x7FZduHqNrweKQZxFgkOhgzvHbKhqc0tXy+vCOIPP1bb9DzM322i4AtrM0s9LiC7SKe/ss5VS7o9vyRQfafmvKwM4fDNMsiJd4Z9NLnyjgwojX9lurvA3AbJROovTM5xt/WkgodjUfoTOXBEhb8nBgAo26C0kRV5h4wOAWHasKgeKfictbrBWnQsfU97Xp6b1HiAOiI/5zqCWsKkJVueHCtjtDuEnCS2/yni2x7Gx6g37pYZjuMxyn2e1dSfEtnKY+8RMbcBJwfDlxrTWLfXUChtyVXNwtc5X73u5wVUG/WCpCulcI0nv8zCoPiD9D5kLYp/IM08JjkG7J1oNH7sjhTaTCyuemOv7VYinZ7xv2eyEKmzAFqm5Jz77D/X5rmAtrUPe6o/By15mIkph2yEmrCTJyyYp8i/bAgdHGNKCh4qP0em6mz1L7fvzZ72IWpYle1S7Ez8SCKqyKw9zdv2zZIBqAAOym7RHddwonfzWlliDEPKZEGbUS27yH1zCgb18lvzT4Lp/HLsW7cIXfX/wFX3FPjCNrzVk5QwRzk0A4I/Pc0UE0M
 at/6fHj/
 bpyhqmEK8QHU45E5wnU+mlOnlXXWoELIXMaD1UNzoDL/gZTbJmX2RZPYzbN2InQbbbc/335yh2RGMge/yqymdxWoU1YgPp46fAzPcRsdjGIUmG2BhZiSVcq5syBFGRzqv9tIjJjvJlBaufBZHywILSx7ikmB6zLEEcRpcJwCemcgG5X4EJI8JCI/logTdtUOunezKcAO+tRCKJxPDzVuQGJB7NYAWABi6mQvTdJJr/klnKSGsZTZsUWcvpzhu1NTIIBGLSdkvtCTJUn2s3cdliKU0/6PvAYDgVHM40R/xtCGnSpfvIsCU+EtnR+bESX8HBssA4DGZOCA4qlU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   a3d27154a205f6b32000e7e2734b2a6a4d22c65b
commit: cb335644ac2611749ab17d3eb6f29c8f77450fa6 [225/232] alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix
config: x86_64-allmodconfig (https://download.01.org/0day-ci/archive/20261106/202611062117.gKtstiMc-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
rustc: rustc 1.96.0 (ac68faa20 2026-05-25)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261106/202611062117.gKtstiMc-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611062117.gKtstiMc-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from arch/x86/kernel/asm-offsets.c:9:
   In file included from include/linux/crypto.h:18:
   In file included from include/linux/slab.h:17:
   In file included from include/linux/gfp.h:7:
   In file included from include/linux/mmzone.h:22:
   In file included from include/linux/mm_types.h:16:
   In file included from include/linux/uprobes.h:18:
   In file included from include/linux/timer.h:6:
   In file included from include/linux/ktime.h:25:
   In file included from include/linux/jiffies.h:10:
   In file included from include/linux/time.h:60:
   In file included from include/linux/time32.h:13:
   In file included from include/linux/timex.h:67:
   In file included from arch/x86/include/asm/timex.h:6:
   In file included from arch/x86/include/asm/tsc.h:11:
   In file included from arch/x86/include/asm/msr.h:16:
   In file included from include/linux/percpu.h:5:
>> include/linux/alloc_tag.h:159:24: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
     159 | static __always_inline inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
         |                        ^
   include/linux/compiler_types.h:235:16: note: expanded from macro 'inline'
     235 | #define inline inline __gnu_inline __inline_maybe_unused notrace
         |                ^
   1 warning generated.
--
>> clang diag: include/linux/compiler_types.h:235:16: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
--
   In file included from lib/test_bitops.c:10:
   In file included from include/linux/module.h:13:
   In file included from include/linux/stat.h:19:
   In file included from include/linux/time.h:60:
   In file included from include/linux/time32.h:13:
   In file included from include/linux/timex.h:67:
   In file included from arch/x86/include/asm/timex.h:6:
   In file included from arch/x86/include/asm/tsc.h:11:
   In file included from arch/x86/include/asm/msr.h:16:
   In file included from include/linux/percpu.h:5:
>> include/linux/alloc_tag.h:159:24: error: duplicate 'inline' declaration specifier [-Werror,-Wduplicate-decl-specifier]
     159 | static __always_inline inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
         |                        ^
   include/linux/compiler_types.h:235:16: note: expanded from macro 'inline'
     235 | #define inline inline __gnu_inline __inline_maybe_unused notrace
         |                ^
   1 error generated.
--
   In file included from lib/tests/stackinit_kunit.c:14:
   In file included from include/kunit/test.h:24:
   In file included from include/linux/module.h:13:
   In file included from include/linux/stat.h:19:
   In file included from include/linux/time.h:60:
   In file included from include/linux/time32.h:13:
   In file included from include/linux/timex.h:67:
   In file included from arch/x86/include/asm/timex.h:6:
   In file included from arch/x86/include/asm/tsc.h:11:
   In file included from arch/x86/include/asm/msr.h:16:
   In file included from include/linux/percpu.h:5:
>> include/linux/alloc_tag.h:159:24: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
     159 | static __always_inline inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
         |                        ^
   include/linux/compiler_types.h:235:16: note: expanded from macro 'inline'
     235 | #define inline inline __gnu_inline __inline_maybe_unused notrace
         |                ^
   lib/tests/stackinit_kunit.c:448:1: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     448 | DEFINE_UNION_INITIALIZER_TESTS(static, INSTRUMENTED_PASS);
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:428:3: note: expanded from macro 'DEFINE_UNION_INITIALIZER_TESTS'
     428 |                 DEFINE_UNION_TESTS(base ## _ ## all, xfail)
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:431:3: note: expanded from macro 'DEFINE_UNION_TESTS'
     431 |                 DEFINE_UNION_TEST(same_sizes, init, xfail);     \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:410:3: note: expanded from macro 'DEFINE_UNION_TEST'
     410 |                 DEFINE_TEST(name ## _ ## init,                  \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     411 |                             union test_ ## name, STRUCT, init,  \
         |                             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     412 |                             xfail)
         |                             ~~~~~~
   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   <scratch space>:189:1: note: expanded from here
     189 | INIT_STRUCT_static_all
         | ^
   lib/tests/stackinit_kunit.c:137:8: note: expanded from macro 'INIT_STRUCT_static_all'
     137 |                                         = __static_all
         |                                           ^~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:118:8: note: expanded from macro '__static_all'
     118 |                                           .two = 0,                     \
         |                                           ^~~~~~~~
   lib/tests/stackinit_kunit.c:448:1: note: previous initialization is here
     448 | DEFINE_UNION_INITIALIZER_TESTS(static, INSTRUMENTED_PASS);
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:428:3: note: expanded from macro 'DEFINE_UNION_INITIALIZER_TESTS'
     428 |                 DEFINE_UNION_TESTS(base ## _ ## all, xfail)
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:431:3: note: expanded from macro 'DEFINE_UNION_TESTS'
     431 |                 DEFINE_UNION_TEST(same_sizes, init, xfail);     \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:410:3: note: expanded from macro 'DEFINE_UNION_TEST'
     410 |                 DEFINE_TEST(name ## _ ## init,                  \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     411 |                             union test_ ## name, STRUCT, init,  \
         |                             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     412 |                             xfail)
         |                             ~~~~~~
   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   <scratch space>:189:1: note: expanded from here
     189 | INIT_STRUCT_static_all
         | ^
   lib/tests/stackinit_kunit.c:137:8: note: expanded from macro 'INIT_STRUCT_static_all'
     137 |                                         = __static_all
         |                                           ^~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:117:33: note: expanded from macro '__static_all'
     117 | #define __static_all                    { .one = 0,                     \
         |                                                  ^
   lib/tests/stackinit_kunit.c:448:1: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     448 | DEFINE_UNION_INITIALIZER_TESTS(static, INSTRUMENTED_PASS);
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:428:3: note: expanded from macro 'DEFINE_UNION_INITIALIZER_TESTS'
     428 |                 DEFINE_UNION_TESTS(base ## _ ## all, xfail)
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:431:3: note: expanded from macro 'DEFINE_UNION_TESTS'
     431 |                 DEFINE_UNION_TEST(same_sizes, init, xfail);     \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:410:3: note: expanded from macro 'DEFINE_UNION_TEST'
     410 |                 DEFINE_TEST(name ## _ ## init,                  \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     411 |                             union test_ ## name, STRUCT, init,  \
         |                             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     412 |                             xfail)
         |                             ~~~~~~
   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   <scratch space>:189:1: note: expanded from here
     189 | INIT_STRUCT_static_all
         | ^
   lib/tests/stackinit_kunit.c:137:8: note: expanded from macro 'INIT_STRUCT_static_all'
     137 |                                         = __static_all
         |                                           ^~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:119:8: note: expanded from macro '__static_all'
     119 |                                           .three = 0,                   \
         |                                           ^~~~~~~~~~
   lib/tests/stackinit_kunit.c:448:1: note: previous initialization is here
     448 | DEFINE_UNION_INITIALIZER_TESTS(static, INSTRUMENTED_PASS);
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:428:3: note: expanded from macro 'DEFINE_UNION_INITIALIZER_TESTS'
     428 |                 DEFINE_UNION_TESTS(base ## _ ## all, xfail)
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:431:3: note: expanded from macro 'DEFINE_UNION_TESTS'
     431 |                 DEFINE_UNION_TEST(same_sizes, init, xfail);     \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   lib/tests/stackinit_kunit.c:410:3: note: expanded from macro 'DEFINE_UNION_TEST'
     410 |                 DEFINE_TEST(name ## _ ## init,                  \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     411 |                             union test_ ## name, STRUCT, init,  \
         |                             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     412 |                             xfail)
         |                             ~~~~~~
   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
--
   In file included from tests/stackinit_kunit.c:14:
   In file included from include/kunit/test.h:24:
   In file included from include/linux/module.h:13:
   In file included from include/linux/stat.h:19:
   In file included from include/linux/time.h:60:
   In file included from include/linux/time32.h:13:
   In file included from include/linux/timex.h:67:
   In file included from arch/x86/include/asm/timex.h:6:
   In file included from arch/x86/include/asm/tsc.h:11:
   In file included from arch/x86/include/asm/msr.h:16:
   In file included from include/linux/percpu.h:5:
>> include/linux/alloc_tag.h:159:24: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
     159 | static __always_inline inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
         |                        ^
   include/linux/compiler_types.h:235:16: note: expanded from macro 'inline'
     235 | #define inline inline __gnu_inline __inline_maybe_unused notrace
         |                ^
   tests/stackinit_kunit.c:448:1: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     448 | DEFINE_UNION_INITIALIZER_TESTS(static, INSTRUMENTED_PASS);
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tests/stackinit_kunit.c:428:3: note: expanded from macro 'DEFINE_UNION_INITIALIZER_TESTS'
     428 |                 DEFINE_UNION_TESTS(base ## _ ## all, xfail)
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tests/stackinit_kunit.c:431:3: note: expanded from macro 'DEFINE_UNION_TESTS'
     431 |                 DEFINE_UNION_TEST(same_sizes, init, xfail);     \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tests/stackinit_kunit.c:410:3: note: expanded from macro 'DEFINE_UNION_TEST'
     410 |                 DEFINE_TEST(name ## _ ## init,                  \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     411 |                             union test_ ## name, STRUCT, init,  \
         |                             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     412 |                             xfail)
         |                             ~~~~~~
   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   <scratch space>:65:1: note: expanded from here
      65 | INIT_STRUCT_static_all
         | ^
   tests/stackinit_kunit.c:137:8: note: expanded from macro 'INIT_STRUCT_static_all'
     137 |                                         = __static_all
         |                                           ^~~~~~~~~~~~
   tests/stackinit_kunit.c:118:8: note: expanded from macro '__static_all'
     118 |                                           .two = 0,                     \
         |                                           ^~~~~~~~
   tests/stackinit_kunit.c:448:1: note: previous initialization is here
     448 | DEFINE_UNION_INITIALIZER_TESTS(static, INSTRUMENTED_PASS);
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tests/stackinit_kunit.c:428:3: note: expanded from macro 'DEFINE_UNION_INITIALIZER_TESTS'
     428 |                 DEFINE_UNION_TESTS(base ## _ ## all, xfail)
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tests/stackinit_kunit.c:431:3: note: expanded from macro 'DEFINE_UNION_TESTS'
     431 |                 DEFINE_UNION_TEST(same_sizes, init, xfail);     \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tests/stackinit_kunit.c:410:3: note: expanded from macro 'DEFINE_UNION_TEST'
     410 |                 DEFINE_TEST(name ## _ ## init,                  \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     411 |                             union test_ ## name, STRUCT, init,  \
         |                             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     412 |                             xfail)
         |                             ~~~~~~
   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   <scratch space>:65:1: note: expanded from here
      65 | INIT_STRUCT_static_all
         | ^
   tests/stackinit_kunit.c:137:8: note: expanded from macro 'INIT_STRUCT_static_all'
     137 |                                         = __static_all
         |                                           ^~~~~~~~~~~~
   tests/stackinit_kunit.c:117:33: note: expanded from macro '__static_all'
     117 | #define __static_all                    { .one = 0,                     \
         |                                                  ^
   tests/stackinit_kunit.c:448:1: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     448 | DEFINE_UNION_INITIALIZER_TESTS(static, INSTRUMENTED_PASS);
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tests/stackinit_kunit.c:428:3: note: expanded from macro 'DEFINE_UNION_INITIALIZER_TESTS'
     428 |                 DEFINE_UNION_TESTS(base ## _ ## all, xfail)
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tests/stackinit_kunit.c:431:3: note: expanded from macro 'DEFINE_UNION_TESTS'
     431 |                 DEFINE_UNION_TEST(same_sizes, init, xfail);     \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tests/stackinit_kunit.c:410:3: note: expanded from macro 'DEFINE_UNION_TEST'
     410 |                 DEFINE_TEST(name ## _ ## init,                  \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     411 |                             union test_ ## name, STRUCT, init,  \
         |                             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     412 |                             xfail)
         |                             ~~~~~~
   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   <scratch space>:65:1: note: expanded from here
      65 | INIT_STRUCT_static_all
         | ^
   tests/stackinit_kunit.c:137:8: note: expanded from macro 'INIT_STRUCT_static_all'
     137 |                                         = __static_all
         |                                           ^~~~~~~~~~~~
   tests/stackinit_kunit.c:119:8: note: expanded from macro '__static_all'
     119 |                                           .three = 0,                   \
         |                                           ^~~~~~~~~~
   tests/stackinit_kunit.c:448:1: note: previous initialization is here
     448 | DEFINE_UNION_INITIALIZER_TESTS(static, INSTRUMENTED_PASS);
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tests/stackinit_kunit.c:428:3: note: expanded from macro 'DEFINE_UNION_INITIALIZER_TESTS'
     428 |                 DEFINE_UNION_TESTS(base ## _ ## all, xfail)
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tests/stackinit_kunit.c:431:3: note: expanded from macro 'DEFINE_UNION_TESTS'
     431 |                 DEFINE_UNION_TEST(same_sizes, init, xfail);     \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   tests/stackinit_kunit.c:410:3: note: expanded from macro 'DEFINE_UNION_TEST'
     410 |                 DEFINE_TEST(name ## _ ## init,                  \
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     411 |                             union test_ ## name, STRUCT, init,  \
         |                             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     412 |                             xfail)
         |                             ~~~~~~
   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
--
   In file included from arch/x86/kernel/asm-offsets.c:9:
   In file included from include/linux/crypto.h:18:
   In file included from include/linux/slab.h:17:
   In file included from include/linux/gfp.h:7:
   In file included from include/linux/mmzone.h:22:
   In file included from include/linux/mm_types.h:16:
   In file included from include/linux/uprobes.h:18:
   In file included from include/linux/timer.h:6:
   In file included from include/linux/ktime.h:25:
   In file included from include/linux/jiffies.h:10:
   In file included from include/linux/time.h:60:
   In file included from include/linux/time32.h:13:
   In file included from include/linux/timex.h:67:
   In file included from arch/x86/include/asm/timex.h:6:
   In file included from arch/x86/include/asm/tsc.h:11:
   In file included from arch/x86/include/asm/msr.h:16:
   In file included from include/linux/percpu.h:5:
>> include/linux/alloc_tag.h:159:24: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
     159 | static __always_inline inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
         |                        ^
   include/linux/compiler_types.h:235:16: note: expanded from macro 'inline'
     235 | #define inline inline __gnu_inline __inline_maybe_unused notrace
         |                ^
   1 warning generated.
   In file included from kernel/sched/rq-offsets.c:5:
   In file included from kernel/sched/sched.h:8:
   In file included from include/linux/prandom.h:13:
   In file included from include/linux/percpu.h:5:
>> include/linux/alloc_tag.h:159:24: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
     159 | static __always_inline inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
         |                        ^
   include/linux/compiler_types.h:235:16: note: expanded from macro 'inline'
     235 | #define inline inline __gnu_inline __inline_maybe_unused notrace
         |                ^
   1 warning generated.
   In file included from rust/helpers/helpers.c:43:
   In file included from rust/helpers/auxiliary.c:3:
   In file included from include/linux/auxiliary_bus.h:11:
   In file included from include/linux/device.h:16:
   In file included from include/linux/energy_model.h:7:
   In file included from include/linux/kobject.h:20:
   In file included from include/linux/sysfs.h:16:
   In file included from include/linux/kernfs.h:12:
   In file included from include/linux/idr.h:15:
   In file included from include/linux/radix-tree.h:16:
   In file included from include/linux/percpu.h:5:
>> include/linux/alloc_tag.h:159:24: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
     159 | static __always_inline inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
         |                        ^
   include/linux/compiler_types.h:235:16: note: expanded from macro 'inline'
     235 | #define inline inline __gnu_inline __inline_maybe_unused notrace
         |                ^
   In file included from rust/helpers/helpers.c:43:
   In file included from rust/helpers/auxiliary.c:3:
   In file included from include/linux/auxiliary_bus.h:11:
   In file included from include/linux/device.h:16:
   In file included from include/linux/energy_model.h:7:
   In file included from include/linux/kobject.h:20:
   In file included from include/linux/sysfs.h:16:
   In file included from include/linux/kernfs.h:12:
   In file included from include/linux/idr.h:15:
   In file included from include/linux/radix-tree.h:16:
   In file included from include/linux/percpu.h:5:
>> include/linux/alloc_tag.h:159:24: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
     159 | static __always_inline inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
         |                        ^
   include/linux/compiler_types.h:235:16: note: expanded from macro 'inline'
     235 | #define inline inline __gnu_inline __inline_maybe_unused notrace
         |                ^
>> clang diag: include/linux/compiler_types.h:235:16: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
>> clang diag: include/linux/compiler_types.h:235:16: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
>> clang diag: include/linux/compiler_types.h:235:16: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
   1 warning generated.
   1 warning generated.


vim +/inline +159 include/linux/alloc_tag.h

   158	
 > 159	static __always_inline inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
   160	{
   161		return !!(atomic_read(&tag->ct.flags) & CODETAG_FLAG_TRACE_ON);
   162	}
   163	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

