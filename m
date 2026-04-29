Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EDD1FF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 22:40:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32DC66B0088; Wed, 29 Apr 2026 18:40:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B8806B008A; Wed, 29 Apr 2026 18:40:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 180106B008C; Wed, 29 Apr 2026 18:40:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F41196B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:40:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8AD4A1604ED
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 22:40:10 +0000 (UTC)
X-FDA: 84713062980.22.D6516F8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf18.hostedemail.com (Postfix) with ESMTP id D851B1C000E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 22:40:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fZFFjEak;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777502408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=10xiLG2/yAP9orfScwxbOcogIls9dHhTbDEeqHGCZwM=;
	b=089EeGMx9APSJUMATjeTdg6z7AQZe24x5wDNZr0+HIM1rnZdXRltOwjA/ow79CStOiJ6Wo
	snQcwNzUgKmYSD0Ev4dV3rhuauFt8qAVfoAp30qh78nJTx9YAxyzSEHl7mb/5x6b+NJbE0
	/qsB+lwi553n1bariXw6Kjv6L6On3Ws=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777502408; a=rsa-sha256;
	cv=none;
	b=tY2zsiaKSZS7OFh6/shHC4w/eKDB8zLU2RLxhX8PnbzkJumffCHWHTb547NXPA07IYrpzZ
	733OBXfFXUyCMf6WebqxpF6pJybQOp6pnJXJPkzwlVW550HU0/2fhDMPEnfaUuAogB5bI8
	EmMiC0N/4A/i4xr5TjN1S7Y12LMoT8g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fZFFjEak;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777502408; x=1809038408;
  h=date:from:to:cc:subject:message-id;
  bh=0he1QITSyDMsAyQOTd+y2mjHFsc1of6tuhtd6nynGcs=;
  b=fZFFjEak7gxyf0JUTn+TfcCT8BYTsxPMY5qk7hF3HRHaMoegIeKYZhVp
   xkQLxeFL+JFf5r6cggkCNbrfPt+dsRRIs+XjYpbHj/AquGSR513bak79q
   fKdtFHDBT7RAc2nC3PThkI4TT7MsTGgf5Z1t+8oPBuip4GoloDGjeSFbf
   Dzxa5ReknimnBjBiKxotMvRml6lN5v135mtEsY5JxEYLxgxxzdbyAda/o
   LYkmJmEGqT+NFKS+w56HL1n9yBoguc/BfinYxgF3/Ts92bJ9niZwCGviu
   HP2juHJRg3lcu2k2hMMvS2ylYxfqN188S071+oPT11b6UpPJaPUMiuDhg
   Q==;
X-CSE-ConnectionGUID: F2mujG9iRiWh7aFGpqn9FA==
X-CSE-MsgGUID: +yU2z0K5Swq7SjHSyMa89w==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="89135883"
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="89135883"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 15:40:06 -0700
X-CSE-ConnectionGUID: EnRuKCwVRBeIQXh63w/rNg==
X-CSE-MsgGUID: eX+9jctdRDegJvZY+osyCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="234670681"
Received: from lkp-server01.sh.intel.com (HELO aa799cca880d) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 29 Apr 2026 15:40:03 -0700
Received: from kbuild by aa799cca880d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wIDZY-00000000BbQ-3Xu8;
	Wed, 29 Apr 2026 22:40:00 +0000
Date: Thu, 30 Apr 2026 06:39:36 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>
Subject: [akpm-mm:mm-new 117/130] include/asm-generic/fixmap.h:77:2:
 error: call to undeclared function '__set_fixmap'; ISO C99 and later do not
 support implicit function declarations
Message-ID: <202604300638.A3yVzhM3-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D851B1C000E
X-Rspam-User: 
X-Stat-Signature: szgydeanx5fhtpraiiab1opc7p1xycdq
X-HE-Tag: 1777502407-190921
X-HE-Meta: U2FsdGVkX1+Jsn4kPyIi0EevVPtWqykv2/bPQaDOVuh9U3MZ7H4r4bj4M68ig4rWgX4I7ZtlkwiqREP1n4TL9CndIu/zWp6JaGYFQ3Ovcy8dxfbTcRx0kqYdYWelgN3+cAqmXq6Rs99hPdNxo4C5MnEkvZQu79Qu837575jO1r6ElNWYeq77gbH5yOCANsbdAyFkfOJHZAOwTVyRdxHHNhbrvCex4X3vwTM0ZnpsTRKwQkaVdhCFjqaMmlk8HVBujgEGaiRAt2R5lsTA/BDRE2eqdOV5sGZc9tzoB2E5VFk9KLEMA94Jft6kZQeheuO87hkncqRWTabsQ2onD/2M0cfdJ6XWTcWWwuyN4f2QqOrBYUXbIY58cYWujdKqcEr/9A4QpX9DdJGGM1cWlC86YlvVwYzmjTH6usAcwOHP1Q4mP+UtnJwBbKbRnCynOMpSoO/iSXep6XgoZZkD2TdgqHDxC5oy2KiilXU/t8G50Vch/xJDM5q58adh5HlVInEYU2p/EHK+faxj9PDqA++d4qzF1XMWDuT2jNMqXC0RJe31EJLvP56FiKTTBz1MvWDY0nhZmt5xQNn1s2MuF4eNCt1djFo+AqaaJCZyhDrMFiCmKQJDmXMsWYAWLcMAirKVHmWP/uWFgrSjqehHDUVH4xQcjM8CxX18UwDGYCjPnrISyOZqBJs6vYWdS5APx8Auh5r5ojK6v0tMkb5jSWoyMGH84LNLEF/kpgZZyec8lXFEe4saAZfNROX6UHpFhv7eBQh5u2VZHQZOahoijqiylL8Arj1ztMDaq2So8SPqQaorQXqOWktV7IRGl/AsMdkJIKJc64BnZ016qYgRqiY8xKHRDjPHTebkIVSNBLHLcQotLQk3JZ52HNm+ShuvkibjIF9QUoLTEf2YLfwX8SrZ0a6yU39jeokwm71oePhrcszXSupMXx+/auIDVN4ATAY01koAu6MNS4bEt99506w
 ref/I2i0
 P4+9r7y7myGWaJ9wlejQUbDEeE71ttzoNC68VYhTheZkTg624ZCUPPOKtKB7npWi6FDBX7h7Z+OS9gyQQoNulU4RYQbxyVsIp1gq70XjD85t6An8kfP2lTZHAZhdrhTM7xQNNVZofY6Fd26o29ZvyY+5jKkKjitXbHlRO2rsi7u4fwBAjP3UOpW43ohAe3X3SLYACzELQloNreqiS5c8tC2/BEsgKovRQfA+S/B0Xwu7FsXieVIklMJvpugdXtVy3ahfat1A52KU8JkC/Qo/gz5/H0dFrjgpneIg8wsoHngq2Elo9LrV7dLxiwD7+/GECAjM8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   0587fb0c820d86e5b77a975680d79b5176d09abb
commit: 93580c23bb3da5dd2926d6ae991ef04c2cdacaf2 [117/130] include/asm-generic/fixmap.h: reimplement nasty macros in C
config: mips-xway_defconfig (https://download.01.org/0day-ci/archive/20260430/202604300638.A3yVzhM3-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 5bac06718f502014fade905512f1d26d578a18f3)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260430/202604300638.A3yVzhM3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604300638.A3yVzhM3-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/mips/kernel/asm-offsets.c:17:
   In file included from include/linux/mm.h:31:
   In file included from include/linux/pgtable.h:6:
   In file included from arch/mips/include/asm/pgtable.h:14:
   In file included from arch/mips/include/asm/pgtable-32.h:17:
   In file included from arch/mips/include/asm/fixmap.h:70:
>> include/asm-generic/fixmap.h:77:2: error: call to undeclared function '__set_fixmap'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
      77 |         __set_fixmap(idx, phys, flags);
         |         ^
>> include/asm-generic/fixmap.h:84:40: error: use of undeclared identifier 'PAGE_KERNEL'
      84 |         return __set_fixmap_offset(idx, phys, FIXMAP_PAGE_NORMAL);
         |                                               ^~~~~~~~~~~~~~~~~~
   include/asm-generic/fixmap.h:48:28: note: expanded from macro 'FIXMAP_PAGE_NORMAL'
      48 | #define FIXMAP_PAGE_NORMAL PAGE_KERNEL
         |                            ^~~~~~~~~~~
   include/asm-generic/fixmap.h:93:2: error: call to undeclared function '__set_fixmap'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
      93 |         __set_fixmap(idx, phys, FIXMAP_PAGE_NOCACHE);
         |         ^
   include/asm-generic/fixmap.h:93:26: error: use of undeclared identifier 'PAGE_KERNEL_NOCACHE'
      93 |         __set_fixmap(idx, phys, FIXMAP_PAGE_NOCACHE);
         |                                 ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/fixmap.h:54:29: note: expanded from macro 'FIXMAP_PAGE_NOCACHE'
      54 | #define FIXMAP_PAGE_NOCACHE PAGE_KERNEL_NOCACHE
         |                             ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/fixmap.h:99:33: error: use of undeclared identifier 'PAGE_KERNEL_NOCACHE'
      99 |         __set_fixmap_offset(idx, phys, FIXMAP_PAGE_NOCACHE);
         |                                        ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/fixmap.h:54:29: note: expanded from macro 'FIXMAP_PAGE_NOCACHE'
      54 | #define FIXMAP_PAGE_NOCACHE PAGE_KERNEL_NOCACHE
         |                             ^~~~~~~~~~~~~~~~~~~
   In file included from arch/mips/kernel/asm-offsets.c:26:
   In file included from include/linux/kvm_host.h:5:
   In file included from include/linux/entry-virt.h:7:
   In file included from include/linux/syscalls.h:95:
   In file included from include/trace/syscall.h:7:
   In file included from include/linux/trace_events.h:6:
   In file included from include/linux/ring_buffer.h:7:
   include/linux/poll.h:134:27: warning: division by zero is undefined [-Wdivision-by-zero]
     134 |                 M(RDNORM) | M(RDBAND) | M(WRNORM) | M(WRBAND) |
         |                                         ^~~~~~~~~
   include/linux/poll.h:132:32: note: expanded from macro 'M'
     132 | #define M(X) (__force __poll_t)__MAP(val, POLL##X, (__force __u16)EPOLL##X)
         |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/poll.h:118:51: note: expanded from macro '__MAP'
     118 |         (from < to ? (v & from) * (to/from) : (v & from) / (from/to))
         |                                                          ^ ~~~~~~~~~
   include/linux/poll.h:134:39: warning: division by zero is undefined [-Wdivision-by-zero]
     134 |                 M(RDNORM) | M(RDBAND) | M(WRNORM) | M(WRBAND) |
         |                                                     ^~~~~~~~~
   include/linux/poll.h:132:32: note: expanded from macro 'M'
     132 | #define M(X) (__force __poll_t)__MAP(val, POLL##X, (__force __u16)EPOLL##X)
         |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/poll.h:118:51: note: expanded from macro '__MAP'
     118 |         (from < to ? (v & from) * (to/from) : (v & from) / (from/to))
         |                                                          ^ ~~~~~~~~~
   2 warnings and 5 errors generated.
   make[3]: *** [scripts/Makefile.build:184: arch/mips/kernel/asm-offsets.s] Error 1
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1371: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +/__set_fixmap +77 include/asm-generic/fixmap.h

    72	
    73	/* Return a pointer with offset calculated */
    74	static inline unsigned long
    75	__set_fixmap_offset(enum fixed_addresses idx, phys_addr_t phys, pgprot_t flags)
    76	{
  > 77		__set_fixmap(idx, phys, flags);
    78		return fix_to_virt(idx) + (phys & (PAGE_SIZE - 1));
    79	}
    80	
    81	static inline unsigned long
    82	set_fixmap_offset(enum fixed_addresses idx, phys_addr_t phys)
    83	{
  > 84		return __set_fixmap_offset(idx, phys, FIXMAP_PAGE_NORMAL);
    85	}
    86	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

