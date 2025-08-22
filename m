Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E71EDCA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 21:32:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D9428E0017; Fri, 22 Aug 2025 17:32:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 389B28E000D; Fri, 22 Aug 2025 17:32:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 278968E0017; Fri, 22 Aug 2025 17:32:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 133108E000D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:32:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 829FB160379
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 21:32:12 +0000 (UTC)
X-FDA: 83805691704.04.6CEEFD0
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf05.hostedemail.com (Postfix) with ESMTP id B854B100010
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 21:32:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hP7lh31S;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755898330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xFQtOq6I8Z45oqGIVoHFyl208N3uZPSPZF/53fSrG5E=;
	b=5bIanDPzi4Or1DjNZCVn6cb6P8rPT5h5H2ZAH+/ikf5l6DgknF2HVPnmiRMoFz4YBDDQrK
	gBuplFfxNdxEBaX2XTetlhEjL0VO9oOUPYupS5qbq+ajeTATosRe1WPB9JMtRsfI8RzX93
	+02fI135XY8VRFis8redA4Q5lPuN4b8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755898330; a=rsa-sha256;
	cv=none;
	b=sSSoA5rplJTY0cVP3enr4utZVCMGtqBtTfB5O/jSAvZneZW7n8ploKqd3QNlT2FP0qWLrf
	HfG4ol1vRQhmp+JOUqK8MnmK2Vjp9tj2CUjRKdJ8TcxmXByp59AMXynehH7Ey/BjuDs0/f
	3CD+NH5MinM+vxhwxaSEu4Ib5hoWi3Y=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hP7lh31S;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755898330; x=1787434330;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Wl9kBX66Z0TKjWVUHQeTmjamBi1LEqMsL/BdZ6WQ0qc=;
  b=hP7lh31Se5/vgkExjU6UYF4Sw4ef3Q0tddbJywYJcvhvP6CwN7lZJGy3
   wEweeZpPPulWeWnBAFyAo3VX+D/U2XI8kimyNBFg1tRZCYo+fv5eZQTkU
   ntK4kmyHK/mWnmiEcDnEZOzec/hE0q0SxBq5ObsVmlQJ/Y3K6TfDJkLPh
   Vc9TIwziUPdYi7kTnHVmmXuPLMBzWyJgpkBsDca6YZkJhPU21AHTy+8hc
   MKcJNSONfefw6Uk/rYCt39ZUOO6hxOAb//X2C/ptFMHybsAtK5Pr05nME
   lQ2wzMsowzN2tZiqEydgrG0NHHWecVFptofBAT7a8OxUF3jDFSiClIbUv
   w==;
X-CSE-ConnectionGUID: 5gcY88ntTbCp3fE5BUkyVg==
X-CSE-MsgGUID: KftpcMdMTqa8zRT1I06pAw==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="58161406"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="58161406"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 14:32:09 -0700
X-CSE-ConnectionGUID: Bf7s2TwDQNuTpTP88xTo9g==
X-CSE-MsgGUID: CoOCDXvQQM60UdW/G10kZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="168032442"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa010.jf.intel.com with ESMTP; 22 Aug 2025 14:32:06 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1upZMR-000LqT-1B;
	Fri, 22 Aug 2025 21:31:54 +0000
Date: Sat, 23 Aug 2025 05:30:45 +0800
From: kernel test robot <lkp@intel.com>
To: Rohan McLure <rmclure@linux.ibm.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Andrew Donnellan <ajd@linux.ibm.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: [akpm-mm:mm-new 216/233] arch/riscv/include/asm/pgtable.h:951:36:
 error: too few arguments to function call, expected 3, have 2
Message-ID: <202508230551.qiEQu04P-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B854B100010
X-Stat-Signature: 5qqjkhdxqpgkytmbod4s6tp76rtfs5mg
X-HE-Tag: 1755898329-170583
X-HE-Meta: U2FsdGVkX19dWoA1v7OHFM38pH8l63l7Y5GHHbgnhS7BPxxkmkPBC7yA6FlADhcODKdnzBp2o2gTD1TKRJJ/mI47EpeUOys5vnnuWtbwsS0vKfm+5DvysfJULq4fRGEzICai5SBEu0KXcsw2OWH7g3GFd/qqT8Ilc5eOd+NH34ugFF7DtvblSVFUKlFLQ3JadmkDdCW/yEpahA8sjHFNaXMQAI34hQdUgLx/29pB824OWOlgv6s5pfylaiRiBGYca70gQpGd9efflJkQrSMITDjc0xXuV3kBy8z88s4nida0gW/PdGN9o6kg7gsmPVhdiSH/uJEuwOnWRyRr0ld2ehRlNebOCLOE6xWjoDcUTdlsOm894B8SB7eprh0l14/3mL9pU4vVQLGjTSq0gXJwI/WcNouRnsFT2ysTNZP+Xvfl16jxrVCXGkrB5khwjWIvIPwWE2w1n+3o0v76pLkGcVlYIRwAnMGXeb8BDgVzS1jqSQHS1PRCxlkiUe7l3Wn62TDna0qu3R2An2OqA83Xbnblb/6HPv3q9HGknOZi+z8CbgsHWCzi2umUXU8lCucu9e7OHWTqP7Yz0V/1PBPuuCOl5myAL+jMXhOYf3gle/pl6PGnLuoVeY/gbfMHiIOncdQyCrPOkdfqbss3KnTp6dDeXVEBUAchP99Pv8HztADOrGsfUjFQlwL60n1iV179YWJ3tiHmwlNbjhjXW6+nBzzUkGx7SPmyTCOOMmj5/Xa0YN2DdtTIvt/Rofi6Uoj87G4qcqAC0MCi+Ukytjtlx7+BqHwVr27hQg8gAxpBXLdMA+KdFUcmevw6yygjA9WnN82fvuB4dIUr1CJMsfM3Ovn3IE4fnYsDYooYFlKjYTsmGUfc3/ffPu9RIGB2l6Shet1kWKy/Izw2F4qVFStQFNmJ8VNfNycIAQjjOZjZ7yds7+kSp/E9QZCgFiDIrIYnN6Bmtb74WGjQOpSkaKS
 X3bCdtCk
 D5DR/+wPE0OeT4ELhGSr8VECS8BGkeZCIyzfsEr11ZmqObKDeutE9sd1HgAmXJl3isadh0XqSEvgXev98KKztqvuqghWCKbotwjy6LOfr5QGDoFNAmxjIDbqozEYBNsvuJ0JvWt4AVbarhtiZu9SNff0b7MrEJfctV2y06sbjgUxay9gWxg7aHDBjBPOcPk9z5vbs/Wp24tvKPpCUHO4jCPX6b2IVKX3ZuFdzQZkB6HSXx8oOZjFwtmcdV7h3jc2p+uTY49+Rag4RCzVgNcbltruCsYhCABUl2QO71gwV04kcVQ/CWIrDk+cEMO/4re41ARI69IAQQhH2Ltxc/jFCxrGzGWWORaCW3oOLAdLgx1ngNNbYvqTgNkxWWp2uDILXLswkhy2pDApnvATTYVNOgQcjv7uMddRpIAyCiGN/Wn4O78NcS/+l0rUFN99zrjy7y4O9sTMkKJgApZPIYanN0Ej+9REOh+KP1AjJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   a8af4c2fd982fd94fffde3c5b6b764fd20af68fe
commit: e009b0f3187482a5756ff3b015cf30277cc1cfd9 [216/233] mm/page_table_check: reinstate address parameter in [__]page_table_check_pud_clear()
config: riscv-randconfig-001-20250823 (https://download.01.org/0day-ci/archive/20250823/202508230551.qiEQu04P-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project d26ea02060b1c9db751d188b2edb0059a9eb273d)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250823/202508230551.qiEQu04P-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508230551.qiEQu04P-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/riscv/kernel/asm-offsets.c:8:
   In file included from include/linux/mm.h:31:
   In file included from include/linux/pgtable.h:6:
>> arch/riscv/include/asm/pgtable.h:951:36: error: too few arguments to function call, expected 3, have 2
     951 |         page_table_check_pud_clear(mm, pud);
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~        ^
   include/linux/page_table_check.h:128:20: note: 'page_table_check_pud_clear' declared here
     128 | static inline void page_table_check_pud_clear(struct mm_struct *mm,
         |                    ^                          ~~~~~~~~~~~~~~~~~~~~~
     129 |                                               unsigned long addr, pud_t pud)
         |                                               ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from arch/riscv/kernel/asm-offsets.c:8:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:98:11: warning: array index 3 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      98 |                 return (set->sig[3] | set->sig[2] |
         |                         ^        ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/riscv/kernel/asm-offsets.c:8:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:98:25: warning: array index 2 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      98 |                 return (set->sig[3] | set->sig[2] |
         |                                       ^        ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/riscv/kernel/asm-offsets.c:8:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:99:4: warning: array index 1 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      99 |                         set->sig[1] | set->sig[0]) == 0;
         |                         ^        ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/riscv/kernel/asm-offsets.c:8:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:101:11: warning: array index 1 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
     101 |                 return (set->sig[1] | set->sig[0]) == 0;
         |                         ^        ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/riscv/kernel/asm-offsets.c:8:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:114:11: warning: array index 3 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     114 |                 return  (set1->sig[3] == set2->sig[3]) &&
         |                          ^         ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/riscv/kernel/asm-offsets.c:8:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:114:27: warning: array index 3 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     114 |                 return  (set1->sig[3] == set2->sig[3]) &&
         |                                          ^         ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/riscv/kernel/asm-offsets.c:8:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:115:5: warning: array index 2 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     115 |                         (set1->sig[2] == set2->sig[2]) &&
         |                          ^         ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/riscv/kernel/asm-offsets.c:8:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:115:21: warning: array index 2 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     115 |                         (set1->sig[2] == set2->sig[2]) &&
         |                                          ^         ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/riscv/kernel/asm-offsets.c:8:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:116:5: warning: array index 1 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     116 |                         (set1->sig[1] == set2->sig[1]) &&
         |                          ^         ~
   include/uapi/asm-generic/signal.h:62:2: note: array 'sig' declared here
      62 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/riscv/kernel/asm-offsets.c:8:
   In file included from include/linux/mm.h:36:
   In file included from include/linux/rcuwait.h:6:


vim +951 arch/riscv/include/asm/pgtable.h

c3cc2a4a3a23faf Alexandre Ghiti 2025-03-21  944  
f2716df5ec97bde Alexandre Ghiti 2025-08-14  945  #define __HAVE_ARCH_PUDP_HUGE_GET_AND_CLEAR
f2716df5ec97bde Alexandre Ghiti 2025-08-14  946  static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
f2716df5ec97bde Alexandre Ghiti 2025-08-14  947  					    unsigned long address, pud_t *pudp)
f2716df5ec97bde Alexandre Ghiti 2025-08-14  948  {
f2716df5ec97bde Alexandre Ghiti 2025-08-14  949  	pud_t pud = __pud(atomic_long_xchg((atomic_long_t *)pudp, 0));
f2716df5ec97bde Alexandre Ghiti 2025-08-14  950  
f2716df5ec97bde Alexandre Ghiti 2025-08-14 @951  	page_table_check_pud_clear(mm, pud);
f2716df5ec97bde Alexandre Ghiti 2025-08-14  952  
f2716df5ec97bde Alexandre Ghiti 2025-08-14  953  	return pud;
f2716df5ec97bde Alexandre Ghiti 2025-08-14  954  }
f2716df5ec97bde Alexandre Ghiti 2025-08-14  955  

:::::: The code at line 951 was first introduced by commit
:::::: f2716df5ec97bde2827d917452dc4de45a6c737c riscv: use an atomic xchg in pudp_huge_get_and_clear()

:::::: TO: Alexandre Ghiti <alexghiti@rivosinc.com>
:::::: CC: Andrew Morton <akpm@linux-foundation.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

