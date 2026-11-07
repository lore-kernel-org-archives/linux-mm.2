Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F589606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 06:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=iY6n9Y1r
Received: by kanga.kvack.org (Postfix)
	id 8C3EF6B05B0; Sat,  7 Nov 2026 01:11:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8750E6B05B1; Sat,  7 Nov 2026 01:11:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76A486B05B2; Sat,  7 Nov 2026 01:11:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B0136B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 01:11:20 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BC146A029C
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 06:11:19 +0000 (UTC)
X-FDA: 85407300678.17.364AA77
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf28.hostedemail.com (Postfix) with ESMTP id CEFC8C0005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 06:11:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iY6n9Y1r;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794031878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=9Qf1bxlJh2yR8FYAdykJlSKZ7c2wlaxQ2/wdlH/NO+M=;
	b=qpI1EWY4TujUIOTWJ1VLZjLp64HYHo38zoWSoZmU/2mMOELWQGIeRCH8knmDvv3P7M13fZ
	L4CQ1wbuiZSAn0PtRC8Bv7XpTf+fKBJ5hVFC6TWYBlvRm6WI49Hb0EM02Xl614oeJQBcHH
	YmFSp3Q+yDsYqAqDwwS6Urd4ysxiLrQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794031878;
	b=ziuc8uBA+ANTsaXIJTqjck4wGyHfhm4rMpQlazvFo1vJ/QII4ShkqsPcrQi6WsXbAWrWy5
	W1gp2boUb9We0rcyjqWe9pIquyejkgYkHZUgoEIk6ieHPIi3+cpYgD8bw83/55FvjX2ggF
	LIpAimwm5blBRFlTadbNapmvpu2hJOk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iY6n9Y1r;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794031877; x=1825567877;
  h=date:from:to:cc:subject:message-id;
  bh=Dnzi/OYZGsP9/fNjeq/k8Zqu+Z356PQDNnPgTACVjtI=;
  b=iY6n9Y1rNcU+Fm83voMNZDdcJz26ASQ0fhE1lBLJOntwU/AFQgTQNoBZ
   aaUMKhsd5YeQ4dOAGd4aIdajX7BcJa2S25C3MWDCUApOFp4XbtmayRfTJ
   bRy2GofXl114FZ6iH++IZ+50seVvZ05OOe+Et/GcCmFKtD2iD2Ni8oBv6
   Obyi8aJdJvVY4I0OgzrsRdX2n78VqYVCK3ynwQvUjLqOb8HG1L1VH5jYa
   omhjKaLq4p2IgA0OEN3qrA59x1C2FO/fB4FH67/z6zL4he0z2hST8kFKN
   KAfw64VNEG/kQOrOk4UaDYJPSjLu4yJ160tviAj4ILog3mj5ifGl1S/JU
   g==;
X-CSE-ConnectionGUID: 4jCErAJmTkeUNmtXItUO9w==
X-CSE-MsgGUID: fApJpRh4T3C3ldprp+nHQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11958"; a="2725911"
X-IronPort-AV: E=Sophos;i="6.27,199,1787036400"; 
   d="scan'208";a="2725911"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 22:11:15 -0800
X-CSE-ConnectionGUID: l2zi7AI5QmOnogDFIe7VRA==
X-CSE-MsgGUID: WRoUjUAgS3KvM+QAXO5SZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,199,1787036400"; 
   d="scan'208";a="7313686"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 06 Nov 2026 22:11:12 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xPZdt-00000000qWN-3oKh;
	Sat, 07 Nov 2026 06:11:09 +0000
Date: Sat, 07 Nov 2026 14:10:12 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>
Subject: [akpm-mm:mm-unstable 225/232]
 include/linux/alloc_tag.h:159:24: error: duplicate 'inline' declaration
 specifier
Message-ID: <202611071330.7rHbLZ6C-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: 4mjz971eytie63dtmjxoxwkfiftpg4yy
X-Rspamd-Queue-Id: CEFC8C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794031876-78269
X-HE-Meta: U2FsdGVkX1/ETwDKHi0xsHQeY4zu/JTm+5x/8rczm/cZZvhtfEX+x/7M1MdTapswAqgfjtyVP/QrcR9HNhWLqlQRmF6u2+rI/5wYR9qCEPk0viCZtL4Yah2vmi9gdAfYxQCPXcQxBhGqxGF5bSb16JgCDB+zkxqf8HgVyCdYQkggpFpezt8R42YlANaDhGfhexOSycA8tNa4p0oot7jaQK+OGiUQMNncZItynBuvM8XhQChPZEhVuAjXDSqTvbg9AmaTePF2X/KLuAUtQrvm1Fjn/wxViZhxka2KHlLVRnK1EWiTmcMSnsL7rdMqqRM7XHYiZKSqNJXtWwrNwcY+DJbgNlhmgT6keaBBqsHWw7C/ASetVIBsM+sNkLONwzc8kj1Y4rMAA0ocb05EJ4aOIdR1II8Ie+z7n7mVRGKphN4aJNHyYAHrx9qE3R8pGsIOwB95BCbSy7yloM9AbQ/UXvuZWBHFa875skvp4aLnpxLyl1sHaFoRCvatfI8g5zmzkl2wR2PNE4QXOutN7KTpoclI+9zwrlli6rNFxsNSstnx8ELiwqUEWDLO0UzeCoRpd61v37MtGhJYO81fk1c6+oIvFcSKzorwnl6F36WSF0itO8N568QHkicZJek+08E1jg4dRs5vv2jsIhdZcc6gw5gun02SovX/RL8gbPoNOlTt8agoC5eu2A+SdvjsKI68May5RU2UHbp34OFZUl0kJVnW0C2yezv7NedUcMRhAZfz6RHXLN2FyEh0c11uG/2wkseKfVNTsvcVoixOAmnsipQ1MafcAMI0sp7tYzMJcBtu20l7xWE0umOdLH7yc7EQKShzg2PNdqFOCbMgNkxM/lO24lsSrsy/WDCQEyViVy7yhvFhINkrVpjvxI2DvcAJMit1w3dZuZbzSe1Iw6kUUwJO0mPWfzNXret3JqMedr1TfuP1mhXpim76Zcu8wIB/Il+kMjXMkRUB/z8SCxx
 CXO9EUUb
 dlepMx8RBG2pUxunnCmvjerIL6BCaienfovJPEA/g+NgEdvaHk23yYdBLmr9T4UVGakpwIYTOoBaB1zyuHtiioD64eZhxcScT8CALXCx+a6kgk3WuwbNX+zVYUwmpSF64mN5rImltHy1w+iI6CR2tl/o9yu2B4RJSABQPFuSbkyY8Lob9qfm8H7CwqWfnMJ019mxmGVa4krl8LzUmxqapFKjjC5eJOwYLoVFL2Fmhc1Ek/zmhIri5ReEtwijzy8wLFGuDigDse0XWBPmXIg2sbJHeo74aZ1BEUjjJ4p8kx8NMBnXO2nt2De4zh0DqHB9zlnfIRG6Jt+nPKyI=
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
config: hexagon-allmodconfig (https://download.01.org/0day-ci/archive/20261107/202611071330.7rHbLZ6C-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project fc9576e3b179738d99c5babe5cd9d6c1f883e0db)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261107/202611071330.7rHbLZ6C-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611071330.7rHbLZ6C-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from arch/hexagon/kernel/asm-offsets.c:13:
   In file included from include/linux/compat.h:14:
   In file included from include/linux/sem.h:5:
   In file included from include/uapi/linux/sem.h:5:
   In file included from include/linux/ipc.h:7:
   In file included from include/linux/rhashtable-types.h:12:
>> include/linux/alloc_tag.h:159:24: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
     159 | static __always_inline inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
         |                        ^
   include/linux/compiler_types.h:235:16: note: expanded from macro 'inline'
     235 | #define inline inline __gnu_inline __inline_maybe_unused notrace
         |                ^
   1 warning generated.
--
   In file included from lib/test_bitops.c:10:
   In file included from include/linux/module.h:22:
   In file included from include/linux/kobject.h:20:
   In file included from include/linux/sysfs.h:16:
   In file included from include/linux/kernfs.h:12:
   In file included from include/linux/idr.h:15:
   In file included from include/linux/radix-tree.h:16:
   In file included from include/linux/percpu.h:5:
>> include/linux/alloc_tag.h:159:24: error: duplicate 'inline' declaration specifier [-Werror,-Wduplicate-decl-specifier]
     159 | static __always_inline inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
         |                        ^
   include/linux/compiler_types.h:235:16: note: expanded from macro 'inline'
     235 | #define inline inline __gnu_inline __inline_maybe_unused notrace
         |                ^
   1 error generated.
--
   In file included from drivers/accessibility/speakup/synth.c:4:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:7:
   In file included from include/linux/list_lru.h:14:
   In file included from include/linux/xarray.h:16:
   In file included from include/linux/gfp.h:7:
   In file included from include/linux/mmzone.h:22:
   In file included from include/linux/mm_types.h:19:
   In file included from include/linux/workqueue.h:9:
>> include/linux/alloc_tag.h:159:24: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
     159 | static __always_inline inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
         |                        ^
   include/linux/compiler_types.h:235:16: note: expanded from macro 'inline'
     235 | #define inline inline __gnu_inline __inline_maybe_unused notrace
         |                ^
   drivers/accessibility/speakup/synth.c:24:12: warning: variable 'module_status' set but not used [-Wunused-but-set-global]
      24 | static int module_status;
         |            ^
   2 warnings generated.
--
   In file included from drivers/accessibility/speakup/main.c:14:
   In file included from include/linux/tty.h:5:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:7:
   In file included from include/linux/list_lru.h:14:
   In file included from include/linux/xarray.h:16:
   In file included from include/linux/gfp.h:7:
   In file included from include/linux/mmzone.h:22:
   In file included from include/linux/mm_types.h:19:
   In file included from include/linux/workqueue.h:9:
>> include/linux/alloc_tag.h:159:24: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
     159 | static __always_inline inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
         |                        ^
   include/linux/compiler_types.h:235:16: note: expanded from macro 'inline'
     235 | #define inline inline __gnu_inline __inline_maybe_unused notrace
         |                ^
   drivers/accessibility/speakup/main.c:236:32: warning: variable 'keymap_flags' set but not used [-Wunused-but-set-global]
     236 | static u_char spk_close_press, keymap_flags;
         |                                ^
   drivers/accessibility/speakup/main.c:1389:15: warning: variable 'old_cursor_pos' set but not used [-Wunused-but-set-global]
    1389 | static u_long old_cursor_pos, old_cursor_x, old_cursor_y;
         |               ^
   drivers/accessibility/speakup/main.c:1389:31: warning: variable 'old_cursor_x' set but not used [-Wunused-but-set-global]
    1389 | static u_long old_cursor_pos, old_cursor_x, old_cursor_y;
         |                               ^
   drivers/accessibility/speakup/main.c:1389:45: warning: variable 'old_cursor_y' set but not used [-Wunused-but-set-global]
    1389 | static u_long old_cursor_pos, old_cursor_x, old_cursor_y;
         |                                             ^
   5 warnings generated.
--
   In file included from lib/tests/stackinit_kunit.c:14:
   In file included from include/kunit/test.h:24:
   In file included from include/linux/module.h:22:
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
   <scratch space>:177:1: note: expanded from here
     177 | INIT_STRUCT_static_all
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
   <scratch space>:177:1: note: expanded from here
     177 | INIT_STRUCT_static_all
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
   <scratch space>:177:1: note: expanded from here
     177 | INIT_STRUCT_static_all
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
   In file included from main.c:14:
   In file included from include/linux/tty.h:5:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:7:
   In file included from include/linux/list_lru.h:14:
   In file included from include/linux/xarray.h:16:
   In file included from include/linux/gfp.h:7:
   In file included from include/linux/mmzone.h:22:
   In file included from include/linux/mm_types.h:19:
   In file included from include/linux/workqueue.h:9:
>> include/linux/alloc_tag.h:159:24: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
     159 | static __always_inline inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
         |                        ^
   include/linux/compiler_types.h:235:16: note: expanded from macro 'inline'
     235 | #define inline inline __gnu_inline __inline_maybe_unused notrace
         |                ^
   main.c:236:32: warning: variable 'keymap_flags' set but not used [-Wunused-but-set-global]
     236 | static u_char spk_close_press, keymap_flags;
         |                                ^
   main.c:1389:15: warning: variable 'old_cursor_pos' set but not used [-Wunused-but-set-global]
    1389 | static u_long old_cursor_pos, old_cursor_x, old_cursor_y;
         |               ^
   main.c:1389:31: warning: variable 'old_cursor_x' set but not used [-Wunused-but-set-global]
    1389 | static u_long old_cursor_pos, old_cursor_x, old_cursor_y;
         |                               ^
   main.c:1389:45: warning: variable 'old_cursor_y' set but not used [-Wunused-but-set-global]
    1389 | static u_long old_cursor_pos, old_cursor_x, old_cursor_y;
         |                                             ^
   5 warnings generated.
--
   In file included from synth.c:4:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:7:
   In file included from include/linux/list_lru.h:14:
   In file included from include/linux/xarray.h:16:
   In file included from include/linux/gfp.h:7:
   In file included from include/linux/mmzone.h:22:
   In file included from include/linux/mm_types.h:19:
   In file included from include/linux/workqueue.h:9:
>> include/linux/alloc_tag.h:159:24: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
     159 | static __always_inline inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
         |                        ^
   include/linux/compiler_types.h:235:16: note: expanded from macro 'inline'
     235 | #define inline inline __gnu_inline __inline_maybe_unused notrace
         |                ^
   synth.c:24:12: warning: variable 'module_status' set but not used [-Wunused-but-set-global]
      24 | static int module_status;
         |            ^
   2 warnings generated.
--
   In file included from tests/stackinit_kunit.c:14:
   In file included from include/kunit/test.h:24:
   In file included from include/linux/module.h:22:
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
   <scratch space>:128:1: note: expanded from here
     128 | INIT_STRUCT_static_all
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
   <scratch space>:128:1: note: expanded from here
     128 | INIT_STRUCT_static_all
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
   <scratch space>:128:1: note: expanded from here
     128 | INIT_STRUCT_static_all
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
..


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

