Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A770FF887E
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 00:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACEC16B0088; Wed, 29 Apr 2026 20:50:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7EDF6B008A; Wed, 29 Apr 2026 20:50:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 993C66B008C; Wed, 29 Apr 2026 20:50:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 867D86B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 20:50:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 175821204AA
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 00:50:23 +0000 (UTC)
X-FDA: 84713391126.17.E369B8E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7BD8B100006
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 00:50:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=n6TFgCOV;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777510221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=TabeIQY03uDQDluyOxuALro6ql9MuOwLS1uHGSWQiLs=;
	b=v758P10lMeKp9ylpR4yoxVUVVMa5jRdolKaV6q0UBM++Sw4PsY/yeW2JKCwTYuMrRuAzTt
	ootOiAUw7vfWjoFjXWeup4k5cciwz55njsJ0WTrkOVboJXhPk1qhJ6L+yOEA+PVuWTw+1G
	n2LqL63UM3WXkzr0icD4zOB2JlYqKio=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=n6TFgCOV;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777510221; a=rsa-sha256;
	cv=none;
	b=wC8a+tULpgSy+dpGns0jWVTNrEvs8aFIGZnujbXhmxd8kwvpuyCZ3lA3A5nxQar6WwJcGq
	o/2SH/RtLB/yd4EJLerKBJk2jC9UoWkE08RDUdwQ6/XfnRhFUEOzOVuI6aZiP/S8f7qoe5
	rWQmg15wsXFLvY8YuUK68wnC0spqNDc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777510221; x=1809046221;
  h=date:from:to:cc:subject:message-id;
  bh=aXMoOusuOALMbE7e+GfRyfXXPBz0mQyjAv7jzLYb5Aw=;
  b=n6TFgCOVphZN7cRUHP19nrYlStElJjQOySyMSTB6wxIgiU/XKL3PVply
   n6wt9SFJhcnYAWHPxf6sC5S60u02shYR5+ZASESfolbGegkNmwsYRdPhY
   tNfhg705bUrqj/a7yOi79Jm1RVZ5cESgm+5w7uetNCx3/MDStK3/inoZv
   zpld9A/F81GLgh/GbHXKdm8AuFhXN4uGIFB3pFVIOtzkNQy3S50fFENaI
   8D3SIqe5DXAcl0vLHEaEtxWMtNy6OcHC9Fko1G6wVAHKdLBmsmO8gQfl4
   YL3i/ZZEaGj3qan0NYJRUhQVpP3TWsHshnTRIADd/W1EeGopHa9rpFY4K
   g==;
X-CSE-ConnectionGUID: LrBkxTeFQd6pkEq0FKGn8Q==
X-CSE-MsgGUID: QDIF1FCVT0WZVrCr+m5wYA==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="78163732"
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="78163732"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 17:50:20 -0700
X-CSE-ConnectionGUID: Ymoo+HEGRp6RIjwsZKlkNQ==
X-CSE-MsgGUID: O3ibbaMHTua6OklscrygaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="233379037"
Received: from lkp-server01.sh.intel.com (HELO aa799cca880d) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 29 Apr 2026 17:50:17 -0700
Received: from kbuild by aa799cca880d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wIFba-00000000Bje-12LN;
	Thu, 30 Apr 2026 00:50:14 +0000
Date: Thu, 30 Apr 2026 08:49:15 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>
Subject: [akpm-mm:mm-new 117/130] arch/riscv/mm/init.c:116:22:
 warning: implicit conversion from 'unsigned long long' to 'u32' (aka
 'unsigned int') changes value from 1099511627776 to 0
Message-ID: <202604300817.QeXlZapz-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7BD8B100006
X-Rspam-User: 
X-Stat-Signature: 6i833cnjsdzngw4897s91a5hxnczscj4
X-HE-Tag: 1777510220-530139
X-HE-Meta: U2FsdGVkX18/n+f64uKB689kUMoGihHlyNvl55EfcONHuWxjjGzLBQRek1AH1FsRpJRCwOJHIHGy7M+7MLR3yoiYL0ou2jm2UnrNtkQBo5jcYp18UFfpD07K76Gv1/J2Cebdg/9S6PDnxKXMiHMdwFoMWFa/MzvmWAdLWtYty/JqOyIgqXMppArDvuDGekP1AanL4WDhFy+PJzKlBTmq8hyVSlfsr7g3lDCadtfNFq2hJPJ6sCemEw3Rtg3GVyq6EfQ7EBgUT2OoVfgdfqwcb1QDmZgSkY+2+mP6HBXGrXC8Jk3J24ZxK6C8bEUyfSYBdpySHouwg1P5fD1H8TEETps/3XAp6X5rBMAB94PwzyqS8rSbu1AkrtBhwo1BvxvGgPfaqPC9aj31FwMXLLnPLPh7X3l7w+RVDyO91+KZdI0MKXVnJE+6fkadVjj6ysk1m/jZNtKCu5j8OED2otM+IWQX7+k1ZjSZ9CG2EJCJ5t/6VCODyUZmhiAWdyULaiKEzCZy5PPIfKSlVypZdEfv3zWPC22IEswngnxsyud3M6pXngPBj0nRDlP+n5xxNRtzLwkysExs+Gsj56UPbT97MohciZKuq0fNn3+DJkKlAkN3PkGm6xYg6IJEl3q2vDxN1ieJ1usfNHVuhO8Cet0taXIyMm10DeLeInH6Lb0SMUs2j8/SU5TjSEmBgGTJ/r3oOX1LbjRbFeF/m2TTWsK8ECjRKGyoBMQtDafRn/xBQ9McZJDd9PZMTThuFnFOPtb4+z9xYcaeoDF4A0wsGofzZG7i7H4oO8Kv7y2TOCrENvgRJ9OIQKYYgCMG5M482rQHbu2eQ7U2zRlOCpP2qcV+hS1ukUd78ZsnrQbvkItZ5XJGExrDplEIvBe0jJcq4GUsSNVYjFjgemf2Kzct9x/sIulitdMQoUewpiSH8cmpBlcqDMpEqttZ/fLVy9xJ11mbjfiSq//z16GcLfx/N3U
 ft7WTzyc
 vEqpGHtXLZtS2Ql0o5+6A+AD1WQlS0HfouKZYNWnCGPzOqX7QjLhLFGlhLcdCuxLS7C6bbGM7BTAhm0zfUb1jWKa2SSn3/ttnxRe4S3vaO8PdNPzp7b9MgqgcN0Ac3CYOrrNDLhnr2QEU5146XNTqCISr+UU959G6yneVXAc4ZlCXCtaWB7p/9Otfiat55QH7eUD7ZtTzJUDeaQUO3gy5l+8t3Y31LcrvUfkHNuX7f1RNQ6riRLG8IUOxN0jeCslZ4aka+vj78MMJpOLhoha7tHOnAZAR/bDVHRMJCm+d3oi5eaBUvrBzNbql3K94XCTcnZHb+IvRI6mRe1bBCsunj1KV1V+UN+pMaLBJoKE4J78TCz0Ggo+QXDJ3BDnCG7IcpK2vPQoBrhjVSD8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   0587fb0c820d86e5b77a975680d79b5176d09abb
commit: 93580c23bb3da5dd2926d6ae991ef04c2cdacaf2 [117/130] include/asm-generic/fixmap.h: reimplement nasty macros in C
config: riscv-allyesconfig (https://download.01.org/0day-ci/archive/20260430/202604300817.QeXlZapz-lkp@intel.com/config)
compiler: clang version 16.0.6 (https://github.com/llvm/llvm-project 7cbf1a2591520c2491aa35339f227775f4d3adf6)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260430/202604300817.QeXlZapz-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604300817.QeXlZapz-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/riscv/mm/init.c:27:
   In file included from arch/riscv/include/asm/fixmap.h:64:
   include/asm-generic/fixmap.h:93:26: error: use of undeclared identifier 'PAGE_KERNEL_NOCACHE'
           __set_fixmap(idx, phys, FIXMAP_PAGE_NOCACHE);
                                   ^
   include/asm-generic/fixmap.h:54:29: note: expanded from macro 'FIXMAP_PAGE_NOCACHE'
   #define FIXMAP_PAGE_NOCACHE PAGE_KERNEL_NOCACHE
                               ^
   include/asm-generic/fixmap.h:99:33: error: use of undeclared identifier 'PAGE_KERNEL_NOCACHE'
           __set_fixmap_offset(idx, phys, FIXMAP_PAGE_NOCACHE);
                                          ^
   include/asm-generic/fixmap.h:54:29: note: expanded from macro 'FIXMAP_PAGE_NOCACHE'
   #define FIXMAP_PAGE_NOCACHE PAGE_KERNEL_NOCACHE
                               ^
>> arch/riscv/mm/init.c:116:22: warning: implicit conversion from 'unsigned long long' to 'u32' (aka 'unsigned int') changes value from 1099511627776 to 0 [-Wconstant-conversion]
                      (((t) - (b)) >> LOG2_SZ_1T));
                                      ^~~~~~~~~~
   include/linux/printk.h:574:36: note: expanded from macro 'pr_notice'
           printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
                                             ^~~~~~~~~~~
   include/linux/printk.h:511:60: note: expanded from macro 'printk'
   #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
                                                              ^~~~~~~~~~~
   include/linux/printk.h:483:19: note: expanded from macro 'printk_index_wrap'
                   _p_func(_fmt, ##__VA_ARGS__);                           \
                                   ^~~~~~~~~~~
   note: (skipping 3 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/uapi/linux/const.h:20:20: note: expanded from macro '__AC'
   #define __AC(X,Y)       (X##Y)
                            ^~~~
   <scratch space>:6:1: note: expanded from here
   0x10000000000ULL
   ^~~~~~~~~~~~~~~~
   include/linux/log2.h:162:14: note: expanded from macro 'ilog2'
           __ilog2_u32(n) :                \
           ~~~~~~~~~~~ ^
   arch/riscv/mm/init.c:126:43: warning: implicit conversion from 'unsigned long long' to 'u32' (aka 'unsigned int') changes value from 1099511627776 to 0 [-Wconstant-conversion]
           if (IS_ENABLED(CONFIG_64BIT) && (diff >> LOG2_SZ_1T) >= 10)
                                                    ^~~~~~~~~~
   arch/riscv/mm/init.c:92:27: note: expanded from macro 'LOG2_SZ_1T'
   #define LOG2_SZ_1T  ilog2(SZ_1T)
                       ~~~~~~^~~~~~
   include/linux/sizes.h:63:18: note: expanded from macro 'SZ_1T'
   #define SZ_1T                           _AC(0x10000000000, ULL)
                                           ^~~~~~~~~~~~~~~~~~~~~~~
   include/uapi/linux/const.h:21:18: note: expanded from macro '_AC'
   #define _AC(X,Y)        __AC(X,Y)
                           ^~~~~~~~~
   include/uapi/linux/const.h:20:20: note: expanded from macro '__AC'
   #define __AC(X,Y)       (X##Y)
                            ^~~~
   <scratch space>:11:1: note: expanded from here
   0x10000000000ULL
   ^~~~~~~~~~~~~~~~
   include/linux/log2.h:162:14: note: expanded from macro 'ilog2'
           __ilog2_u32(n) :                \
           ~~~~~~~~~~~ ^
   arch/riscv/mm/init.c:245:49: warning: implicit conversion from 'unsigned long long' to 'u32' (aka 'unsigned int') changes value from 17179869184 to 0 [-Wconstant-conversion]
                   vmemmap_start_pfn = round_down(phys_ram_base, VMEMMAP_ADDR_ALIGN) >> PAGE_SHIFT;
                                                                 ^~~~~~~~~~~~~~~~~~
   arch/riscv/mm/init.c:67:9: note: expanded from macro 'VMEMMAP_ADDR_ALIGN'
                                       MAX_FOLIO_VMEMMAP_ALIGN)
                                       ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/mmzone.h:108:3: note: expanded from macro 'MAX_FOLIO_VMEMMAP_ALIGN'
            MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
            ^~~~~~~~~~~~~~~~~~
   include/linux/mmzone.h:97:36: note: expanded from macro 'MAX_FOLIO_NR_PAGES'
   #define MAX_FOLIO_NR_PAGES      (1UL << MAX_FOLIO_ORDER)
                                           ^~~~~~~~~~~~~~~
   note: (skipping 8 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/minmax.h:92:28: note: expanded from macro '__careful_cmp_once'
           auto ux = (x); auto uy = (y);                   \
                                     ^
   include/linux/math.h:35:50: note: expanded from macro 'round_down'
   #define round_down(x, y) ((x) & ~__round_mask(x, y))
                                                    ^
   include/linux/math.h:15:46: note: expanded from macro '__round_mask'
   #define __round_mask(x, y) ((__typeof__(x))((y)-1))
                                                ^
   3 warnings and 2 errors generated.


vim +116 arch/riscv/mm/init.c

26b8f69edda85a Alexandre Ghiti 2021-12-06  111  
26b8f69edda85a Alexandre Ghiti 2021-12-06  112  #ifdef CONFIG_64BIT
26b8f69edda85a Alexandre Ghiti 2021-12-06  113  static inline void print_mlt(char *name, unsigned long b, unsigned long t)
26b8f69edda85a Alexandre Ghiti 2021-12-06  114  {
26b8f69edda85a Alexandre Ghiti 2021-12-06  115  	pr_notice("%12s : 0x%08lx - 0x%08lx   (%4ld TB)\n", name, b, t,
26b8f69edda85a Alexandre Ghiti 2021-12-06 @116  		   (((t) - (b)) >> LOG2_SZ_1T));
26b8f69edda85a Alexandre Ghiti 2021-12-06  117  }
26b8f69edda85a Alexandre Ghiti 2021-12-06  118  #else
26b8f69edda85a Alexandre Ghiti 2021-12-06  119  #define print_mlt(n, b, t) do {} while (0)
26b8f69edda85a Alexandre Ghiti 2021-12-06  120  #endif
26b8f69edda85a Alexandre Ghiti 2021-12-06  121  

:::::: The code at line 116 was first introduced by commit
:::::: 26b8f69edda85a7942fa580360690c2d5c74f765 riscv: Improve virtual kernel memory layout dump

:::::: TO: Alexandre Ghiti <alexandre.ghiti@canonical.com>
:::::: CC: Palmer Dabbelt <palmer@rivosinc.com>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

