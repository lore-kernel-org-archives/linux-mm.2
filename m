Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 160BC606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 08:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=UpsLjqpI
Received: by kanga.kvack.org (Postfix)
	id 40F366B05B2; Sat, 31 Oct 2026 04:36:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E64F6B05B3; Sat, 31 Oct 2026 04:36:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 325316B05B4; Sat, 31 Oct 2026 04:36:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 001436B05B2
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 04:36:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F1CA41A08AF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 08:36:54 +0000 (UTC)
X-FDA: 85382265948.26.B116B6D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf31.hostedemail.com (Postfix) with ESMTP id 727D820006
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 08:36:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UpsLjqpI;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793435813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=bJgvSlNrNKH1NoDZY0nuEfgdStiOApNnubWTBDknRnI=;
	b=ommGmaC7Dk5kc1bVxRX+LAZX+0vtOKA7tXCH/iFIAaee+0rqtJttXU81uwjtj/s8zoeza7
	EClF63ZP6TT4az4oUj7UmQS/vTHrzqJ2U4xnceI7xcXWxRY5hVqPl+om5cS30pHR0YcVyE
	GLidWkE9RZSxI04KaE88RUHyfVcHXf8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UpsLjqpI;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793435813;
	b=iKlIxcdiNJObwtDwtr1bG7iIrSTz6rhSHLSEyFJyCnL3UH8zjGHfdZTYrVOUuQ/GY2VRp2
	Sj1wSO29+y/ROaD5k7nQn39p8lxu12AL8f5YqZtQap9uPp4Hp1gv1ic1dM9f8YavUCP0Jx
	EDoCEAqoTjxLtZstHYZJIP3VLt7GELw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793435812; x=1824971812;
  h=date:from:to:cc:subject:message-id;
  bh=dtvVYbFvIDyClFn9yLxM4QhxjXgihlmypuRixwz0OHQ=;
  b=UpsLjqpIgElDIiYRJmV8wKEpxdA0T1nAvoR75vxAIiZGrxvQSMfblvd2
   FQKTYzLVhOQSeUNHSyajNRGH3A/MG02WeeaA+UOMZ6WvYs7dcWkC/Wmoy
   cgzedSobRslUK4z6E5XaYQ5yAqSzcbCf8iCI/2ICIXk9slDWU/BCORP+D
   lxwk0hrlKgmc9mOh0IUPJDEfA9+O2CST1j+eIsYxd6eGuEmKYs5toXnS8
   QHZHBsoUy6NdwnbrrSRQ2nfZ+GH8wi+Z9wiikqzemH/3WQbtLd7Ehx733
   i5pngU5uEO2V0Fpe6F+fxBaXvkr+xKllIJCnPzTgC273Y+B78uyfXLJq1
   Q==;
X-CSE-ConnectionGUID: 65N3qB8kQBiS9uBSDa3h6A==
X-CSE-MsgGUID: 2wrTlwfMQMWFTOspzA4ibQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11951"; a="2073554"
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="2073554"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2026 01:36:51 -0700
X-CSE-ConnectionGUID: mphRazFYQZepekTuwCYghA==
X-CSE-MsgGUID: q+ktFgiNTK2IKryNULnS7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="7454246"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa013.fm.intel.com with ESMTP; 31 Oct 2026 01:36:49 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xN4Zy-00000000cfc-19P3;
	Sat, 31 Oct 2026 08:36:46 +0000
Date: Sat, 31 Oct 2026 16:36:43 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 "Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: arch/riscv/include/asm/syscall_wrapper.h:35:14: warning:
 '__se_sys_userfaultfd' alias between functions of incompatible types 'long
 int(ulong,  ulong,  ulong,  ulong,  ulong,  ulong,  ulong)' {aka 'long
 int(long unsigned int,  long unsigned int,  long uns...
Message-ID: <202610311814.sISpHHXr-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 727D820006
X-Stat-Signature: i6n4mc53t1j6ys8bhkxrr5qtp7h8cr3t
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793435813-31306
X-HE-Meta: U2FsdGVkX1+biyj1S7zLuIxIbBYOthcRJJf5JlwhMkVaul7DvD7rr9xR0d5G3Y7R/1OpXuoLfquMYHEagu4T7lPsH3faKcSSNZMn3oZDK1TIArnqU6fn9jsIEr3hxsXVGE7uZkQF6VLdeHWWdT4Xac4OFpCCR5qlsnt+PKDKy7UVNuBMypegDFB+iroP5QPjW1Fvppq/dlvODLkkTboCXpGkQ4/2CXGfiR2YgrB2HZm4AJr7IEQASZKJkYo676tD6j7E9pyROeQq8Pk2TCeCS5Fxlk/DhaY5psA2uJEYlKOlIFOMmb4rX/brDEuKzGWbN7p/EooSVwcQpW0XvQH+o0V7n0mrRbSTtqwe/By/j5V/TIPtCiQA++MK1q8awjzSB1cBblUp0qYT0/zbsbnOHCDgrlfuw9lauC5BufIoshhGns1suFoyjcm/zxZNAtO3OI3SzLJyXZg+ob9O57SVtZpLcWhVop/Qvrvna8Pi9hkDGCTq5ySRVlo0SvB/YXeHdAhq1yaYUraKToXUOBY6MGD7JlA1qGqfC4mGAyuCU+s4SiF7agMy9MUO+4/aytT1P1CCgixkfUS919xCNXL7x6lh542mjiM4HZrJ1nRRGDsXaMl1Sj2XbOgnvUGVRM9db/ejmOXuv6dmSUsrHqRIdIVxmyRE1bk9br44qPiH3eglW9/OfrWsS9g3HhVjyREqTn1RlHXPR6i38p7E3gbNTcjHLVlwZjerh5Mru07XbLlf04wpNJ0ryEB7U5p5za9RwWWjfA6ryZlA9B/5uRHViWUHIQsfA2GifUrUampk5UODMpYhp53f+D64M8qEMMSjhLmyoo0J2IC1JLlV9g1IKCqm/LeLs/1JLDV6CgH7+sQu+EYx9dEEUa/T7BGBZtYFmeabSpytAEho8CcqczHgiOM1puIapwibaK+2c9cOCO68A5kaTm60gVYe/lN6v3HD6n7Rp5/zwSkyfP26j6j
 ejmxmRpf
 jmfzPmrfsSzWEumqgZHRCyc7aA8rSY3g1IUQxUQu9VOlJKIzU16OplY6CdU8o0nMhpF+Hd7VlTQdyXDgTjitBpw8dY/bLOtBYPe1Mq8EyDyQzQJNVZyyJ7H8Unvm1p6+iwMLQjwtr0mOk0+7RODhvCSe/xIEPo6+b7ZV48VUt7/yemCa+quY1/gB1LeO9AXxPnDmG6l7Uow4qAcRQtlZHvcvzYWcAURAdxkYqnFy5TKbgwOrfxONWJEUWqYBx9vOPmDDsJTZmbHDSAnH7BAEvVbJpu0+OzB8VwGFK5pyhpnb1vQE8FBIbEALDpOA4cw1XUq+gRXqGsUd563AtiXfBpXb2cFu65sSRqS9OjPQdBjQVhxL+QpOk6Zy8wErS1boMFKC1IBlZW6/NKu3Z04V8E/on9UWmn1s4e/i3sj2P0j5r63k6RAWSTxwyv7+L94pKRnp5rieBE8WTvKOEaWu4ouPoaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Hi Mike,

FYI, the error/warning still remains.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   2a500a04d6f969318c05f46aedb6e73fc1963a00
commit: 7bc5e747bba29d5b77b2278e8c696eea0c796706 userfaultfd: merge fs/userfaultfd.c into mm/userfaultfd.c
date:   5 months ago
config: riscv-randconfig-1000-20261031 (https://download.01.org/0day-ci/archive/20261031/202610311814.sISpHHXr-lkp@intel.com/config)
compiler: riscv32-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261031/202610311814.sISpHHXr-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Fixes: 7bc5e747bba2 ("userfaultfd: merge fs/userfaultfd.c into mm/userfaultfd.c")
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610311814.sISpHHXr-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/linux/compat.h:34,
                    from arch/riscv/include/asm/elf.h:12,
                    from include/linux/elf.h:6,
                    from include/linux/module.h:20,
                    from include/linux/device/driver.h:21,
                    from include/linux/device.h:32,
                    from include/linux/blk_types.h:11,
                    from include/linux/writeback.h:13,
                    from include/linux/memcontrol.h:23,
                    from include/linux/rmap.h:12,
                    from mm/userfaultfd.c:16:
>> arch/riscv/include/asm/syscall_wrapper.h:35:14: warning: '__se_sys_userfaultfd' alias between functions of incompatible types 'long int(ulong,  ulong,  ulong,  ulong,  ulong,  ulong,  ulong)' {aka 'long int(long unsigned int,  long unsigned int,  long unsigned int,  long unsigned int,  long unsigned int,  long unsigned int,  long unsigned int)'} and 'long int(long int)' [-Wattribute-alias]
     static long __se_##prefix##name(ulong, ulong, ulong, ulong, ulong, ulong,  \
                 ^~~~~
   arch/riscv/include/asm/syscall_wrapper.h:82:2: note: in expansion of macro '__SYSCALL_SE_DEFINEx'
     __SYSCALL_SE_DEFINEx(x, sys, name, __VA_ARGS__)    \
     ^~~~~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:236:2: note: in expansion of macro '__SYSCALL_DEFINEx'
     __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
     ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:225:36: note: in expansion of macro 'SYSCALL_DEFINEx'
    #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                       ^~~~~~~~~~~~~~~
   mm/userfaultfd.c:4475:1: note: in expansion of macro 'SYSCALL_DEFINE1'
    SYSCALL_DEFINE1(userfaultfd, int, flags)
    ^~~~~~~~~~~~~~~
   arch/riscv/include/asm/syscall_wrapper.h:41:14: note: aliased declaration here
     static long ___se_##prefix##name(__MAP(x,__SC_LONG,__VA_ARGS__))
                 ^~~~~~
   arch/riscv/include/asm/syscall_wrapper.h:82:2: note: in expansion of macro '__SYSCALL_SE_DEFINEx'
     __SYSCALL_SE_DEFINEx(x, sys, name, __VA_ARGS__)    \
     ^~~~~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:236:2: note: in expansion of macro '__SYSCALL_DEFINEx'
     __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
     ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:225:36: note: in expansion of macro 'SYSCALL_DEFINEx'
    #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
                                       ^~~~~~~~~~~~~~~
   mm/userfaultfd.c:4475:1: note: in expansion of macro 'SYSCALL_DEFINE1'
    SYSCALL_DEFINE1(userfaultfd, int, flags)
    ^~~~~~~~~~~~~~~


vim +35 arch/riscv/include/asm/syscall_wrapper.h

a9ad73295cc1e3a Sami Tolvanen 2024-03-11  16  
a9ad73295cc1e3a Sami Tolvanen 2024-03-11  17  #define __SYSCALL_SE_DEFINEx(x, prefix, name, ...)					\
a9ad73295cc1e3a Sami Tolvanen 2024-03-11  18  	static long __se_##prefix##name(__MAP(x,__SC_LONG,__VA_ARGS__));		\
a9ad73295cc1e3a Sami Tolvanen 2024-03-11  19  	static long __se_##prefix##name(__MAP(x,__SC_LONG,__VA_ARGS__))
a9ad73295cc1e3a Sami Tolvanen 2024-03-11  20  
08d0ce30e0e4fcb Sami Tolvanen 2023-07-10  21  #define SC_RISCV_REGS_TO_ARGS(x, ...)							\
08d0ce30e0e4fcb Sami Tolvanen 2023-07-10  22  	__MAP(x,__SC_ARGS								\
08d0ce30e0e4fcb Sami Tolvanen 2023-07-10  23  	      ,,regs->orig_a0,,regs->a1,,regs->a2					\
08d0ce30e0e4fcb Sami Tolvanen 2023-07-10  24  	      ,,regs->a3,,regs->a4,,regs->a5,,regs->a6)
08d0ce30e0e4fcb Sami Tolvanen 2023-07-10  25  
a9ad73295cc1e3a Sami Tolvanen 2024-03-11  26  #else
a9ad73295cc1e3a Sami Tolvanen 2024-03-11  27  /*
a9ad73295cc1e3a Sami Tolvanen 2024-03-11  28   * Use type aliasing to ensure registers a0-a6 are correctly passed to the syscall
a9ad73295cc1e3a Sami Tolvanen 2024-03-11  29   * implementation when >word-size arguments are used.
a9ad73295cc1e3a Sami Tolvanen 2024-03-11  30   */
a9ad73295cc1e3a Sami Tolvanen 2024-03-11  31  #define __SYSCALL_SE_DEFINEx(x, prefix, name, ...)					\
a9ad73295cc1e3a Sami Tolvanen 2024-03-11  32  	__diag_push();									\
a9ad73295cc1e3a Sami Tolvanen 2024-03-11  33  	__diag_ignore(GCC, 8, "-Wattribute-alias",					\
a9ad73295cc1e3a Sami Tolvanen 2024-03-11  34  			"Type aliasing is used to sanitize syscall arguments");		\
a9ad73295cc1e3a Sami Tolvanen 2024-03-11 @35  	static long __se_##prefix##name(ulong, ulong, ulong, ulong, ulong, ulong, 	\
a9ad73295cc1e3a Sami Tolvanen 2024-03-11  36  					ulong)						\
a9ad73295cc1e3a Sami Tolvanen 2024-03-11  37  			__attribute__((alias(__stringify(___se_##prefix##name))));	\
a9ad73295cc1e3a Sami Tolvanen 2024-03-11  38  	__diag_pop();									\
653650c468be211 Sami Tolvanen 2024-03-26  39  	static long noinline ___se_##prefix##name(__MAP(x,__SC_LONG,__VA_ARGS__))	\
653650c468be211 Sami Tolvanen 2024-03-26  40  			__used;								\
a9ad73295cc1e3a Sami Tolvanen 2024-03-11  41  	static long ___se_##prefix##name(__MAP(x,__SC_LONG,__VA_ARGS__))
a9ad73295cc1e3a Sami Tolvanen 2024-03-11  42  

:::::: The code at line 35 was first introduced by commit
:::::: a9ad73295cc1e3af0253eee7d08943b2419444c4 riscv: Fix syscall wrapper for >word-size arguments

:::::: TO: Sami Tolvanen <samitolvanen@google.com>
:::::: CC: Palmer Dabbelt <palmer@rivosinc.com>

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

