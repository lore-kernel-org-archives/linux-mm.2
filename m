Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1630FFEA80A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 05:24:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 414946B0005; Wed, 25 Mar 2026 01:24:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5076B0089; Wed, 25 Mar 2026 01:24:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B4256B008A; Wed, 25 Mar 2026 01:24:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 16F406B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 01:24:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A7FAD1606FC
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:24:13 +0000 (UTC)
X-FDA: 84583444386.15.65AA87F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3158C100005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:24:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LGgSD4R6;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774416251; a=rsa-sha256;
	cv=none;
	b=eYClTX7To63eJDsckA01pgnRHctlf9fM6FQOQIFVpFMBu4m7e1OdWpaNm8pLYnRFykd5q9
	T7KognwqLdDRqcxe+AhOF6Le70OghUTI4fHxLEt86YFC9b0/jfryTRG0/kzYMLtRXb4K3z
	tryyZsYJVjIVRC/JCAf3N2tM5NpaUzA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LGgSD4R6;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774416251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=6zkFOY/CuqW+Rj0vk+tXC4jnRaEY53MLFoCHgXb2Pbs=;
	b=ZUsluD+YxqyDbIitvTDiGpXIau3mfanM5yLUU3D5OkiXWdybNQSVvdAmmKpSJ5xU1tDuo0
	RMkFwvgSV+WQDnA7ApMplZzSIJMu03OBNlwdUN4II4xnoDOBTegHWzA4eE2PxrNafwEj/Q
	5b8I734Akc/NGWtpDGhiPNfzIfWdUf4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774416252; x=1805952252;
  h=date:from:to:cc:subject:message-id;
  bh=DQrJC7dyBQ9LgVoCAfL8W6FvWRvjfLA74pprv2ClgI4=;
  b=LGgSD4R6NVoP3PnwJ79M4bBR4mamVnkvJZoKPncbGOFbFaXg1zkSBeNg
   a6BsfP5JDJIzaI3IgW/yHsocLWIby7mpSUXA+7d2BUo0TmpiW/gW4a8QV
   ysQVm0UjWJiKCAy6UqP6NQiRZSF6KiZs47WmjBjuC6RVane6yG/AkCjzV
   OPl2oJRJ1PG1t0G42Di3AysYcOUrms2z8QtkqOB5TrK4DvvFLxy8L/lVH
   67Nlh9HtHbZ66Q7Evjx1QwCBGhaRaAEmQUHANjxLFdvv5YRa33I6LKq6L
   SmuesVxrHPT4SI3g+uJWJPIshbjCvfc5G+OkRR7VtdGrUrK3iqloIsEBo
   Q==;
X-CSE-ConnectionGUID: M/iQ6XW3R5mB5XfEMQ3HPw==
X-CSE-MsgGUID: HPEWUAiJSNKIxcZrTKmsHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="75333112"
X-IronPort-AV: E=Sophos;i="6.23,139,1770624000"; 
   d="scan'208";a="75333112"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 22:24:10 -0700
X-CSE-ConnectionGUID: 7cdP0t8cRjO0giEige8+mA==
X-CSE-MsgGUID: +cdNCMBXQUS9SH1SIz5a+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,139,1770624000"; 
   d="scan'208";a="226211092"
Received: from lkp-server01.sh.intel.com (HELO 3905d212be1b) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 24 Mar 2026 22:24:07 -0700
Received: from kbuild by 3905d212be1b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w5Giq-000000006Ej-3sFb;
	Wed, 25 Mar 2026 05:24:04 +0000
Date: Wed, 25 Mar 2026 13:23:37 +0800
From: kernel test robot <lkp@intel.com>
To: Chengkaitao <chengkaitao@kylinos.cn>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-stable 72/140] arch/sparc/mm/init_64.c:2582:16:
 error: call to undeclared function 'vmemmap_pgd_populate'; ISO C99 and later
 do not support implicit function declarations
Message-ID: <202603251338.grra8xt7-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: bqh5cbdmipihib13bnke7atqjixspaob
X-Rspamd-Queue-Id: 3158C100005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774416250-124037
X-HE-Meta: U2FsdGVkX1+J35Ui1KxFsYk79RlObgyEHINnOj6HlYD3aMGnbl6Cp8teuWtXzP7tAAPKQ5zwUbBQ4a+BMIz6l732AqZ109/6FbzCLqUkytA/BaEYFSoaHttDIXGkJ0h1ZinRgSIAar8yEJKKquo2hRxkhnmqvtpt9fVahJrEjpzNbVHU/A9khXRj9J5JZnQHW2kWKmkrYiHCjfRQKkHA3hrdYvo9+KZSeTNWzIDOsgIK06zpEFq2Ws7cmhPFLlLleLZ+xAupYCN+fRrdaBmhO5cIFse/+57FVeUrHTzwogUEdGmszNLzDrsqDcblYUof7Ksh2BQFI2P2UNI97fZB10IK0JTXeJ6W+zUf+Vw4XNXkXV1f4VmNVRx7hvC5UBFHl2SKJvfG4CEmXboWlWbD3tCrJ9pt8/inWB6Ldo60d5c2QC14wZFK4dQWFDDUx1zDWT3/NKRcCtYvsoijDmmR4+H805AqdSk7q3qbZStHdOGXoYQwf50+VUFytw19lkBheRR7Tl7dYt30+hJnSp3jAI+5snHgrhEl6EpsdVEUsPMHKq+9zndYQ8+cKUwQkacExEm1PBtE6mG7DV7Pdhs0SudQ2/owUbD1xkQWrCOBB2OCCzsPC1x51YTdAloQctf5apSG8MxZZU8fh+hUGBkz1koe+xf6WldUER8MizQb2vPwLb/UWVC8c+/Pqzxo5RFLPk6dagyAKCZaiNcQKTQykHSb8zmhaA8nANn45OBAS26FbNstu4lI1AEcaa+LiNsAVuO9tcLu6cI1gRJkhZxUIQOp36tX6QdMnRzNzx65hoFSF+JrsPV5fdJcZvSe9NJF7PvLHS0GJfV+SFaf3ubdAY3yNA9F9sTmlo4/Bj9T2w6DwoCYNmb104rjbos98YoU5oS3OSjmp6xGShiGVfW6EWeL5QFFotOeXZZssYuUGhSu3YH5uFcncItSDryxpf7HZXijYOiQP/uIRCaF3Pt
 xBoKx8MH
 PBdIVkc2enjtKLPcCG1zxv9s7hwPUZ4RPJWaiVYy+zHr3hFow410ziPOPwaTUjSsdB4L7bGgRl5DoT429mbAjclfRKHwR5YbVCSPoTCTKg0uu2yk1uJoLf9SCia+L23wxcKiWz055Fd7Jr/oxlx4TBeMmFXIpzsg1EnT3PQuCuwCD2Oysdshvo8LjY284OCtNb4aHkO9AGTSK9Xffl/D58kHV0YtKYiMGdTCaMlfmQW+YgIe8cibvLJj716+loW3ff8fY31eK2e7mv8JKbfruCnvl+CYdnk2yqWkZi60/v5OVWHDcfbS1/n3aDd76fl2EhakNxoIhKWHtX0Teytf6T6l3GWbjJmhqnYohvtaVTcSZjntmV2B+EG8BJLVGpvy35uC6PVUhz6qvYtyj5lboadzC4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-stable
head:   e393ce79b3cf63c2810be882eb6e531a54f520f4
commit: e504282091c8e4dc4f945c89d9b44ac2e0bfe504 [72/140] mm: convert vmemmap_p?d_populate() to static functions
config: sparc64-randconfig-002-20260325 (https://download.01.org/0day-ci/archive/20260325/202603251338.grra8xt7-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 054e11d1a17e5ba88bb1a8ef32fad3346e80b186)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260325/202603251338.grra8xt7-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603251338.grra8xt7-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/sparc/mm/init_64.c:2582:16: error: call to undeclared function 'vmemmap_pgd_populate'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    2582 |                 pgd_t *pgd = vmemmap_pgd_populate(vstart, node);
         |                              ^
   arch/sparc/mm/init_64.c:2582:16: note: did you mean 'vmemmap_populate'?
   arch/sparc/mm/init_64.c:2565:15: note: 'vmemmap_populate' declared here
    2565 | int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
         |               ^
>> arch/sparc/mm/init_64.c:2582:10: error: incompatible integer to pointer conversion initializing 'pgd_t *' with an expression of type 'int' [-Wint-conversion]
    2582 |                 pgd_t *pgd = vmemmap_pgd_populate(vstart, node);
         |                        ^     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> arch/sparc/mm/init_64.c:2591:9: error: call to undeclared function 'vmemmap_p4d_populate'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    2591 |                 p4d = vmemmap_p4d_populate(pgd, vstart, node);
         |                       ^
>> arch/sparc/mm/init_64.c:2591:7: error: incompatible integer to pointer conversion assigning to 'p4d_t *' from 'int' [-Wint-conversion]
    2591 |                 p4d = vmemmap_p4d_populate(pgd, vstart, node);
         |                     ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> arch/sparc/mm/init_64.c:2595:9: error: call to undeclared function 'vmemmap_pud_populate'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    2595 |                 pud = vmemmap_pud_populate(p4d, vstart, node);
         |                       ^
>> arch/sparc/mm/init_64.c:2595:7: error: incompatible integer to pointer conversion assigning to 'pud_t *' from 'int' [-Wint-conversion]
    2595 |                 pud = vmemmap_pud_populate(p4d, vstart, node);
         |                     ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   6 errors generated.


vim +/vmemmap_pgd_populate +2582 arch/sparc/mm/init_64.c

c4bce90ea2069e5 arch/sparc64/mm/init.c  David S. Miller   2006-02-11  2563  
46644c2477c5890 arch/sparc64/mm/init.c  David Miller      2007-10-16  2564  #ifdef CONFIG_SPARSEMEM_VMEMMAP
0aad818b2de455f arch/sparc/mm/init_64.c Johannes Weiner   2013-04-29 @2565  int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
7b73d978a5d0d2a arch/sparc/mm/init_64.c Christoph Hellwig 2017-12-29  2566  			       int node, struct vmem_altmap *altmap)
46644c2477c5890 arch/sparc64/mm/init.c  David Miller      2007-10-16  2567  {
46644c2477c5890 arch/sparc64/mm/init.c  David Miller      2007-10-16  2568  	unsigned long pte_base;
46644c2477c5890 arch/sparc64/mm/init.c  David Miller      2007-10-16  2569  
46644c2477c5890 arch/sparc64/mm/init.c  David Miller      2007-10-16  2570  	pte_base = (_PAGE_VALID | _PAGE_SZ4MB_4U |
46644c2477c5890 arch/sparc64/mm/init.c  David Miller      2007-10-16  2571  		    _PAGE_CP_4U | _PAGE_CV_4U |
46644c2477c5890 arch/sparc64/mm/init.c  David Miller      2007-10-16  2572  		    _PAGE_P_4U | _PAGE_W_4U);
46644c2477c5890 arch/sparc64/mm/init.c  David Miller      2007-10-16  2573  	if (tlb_type == hypervisor)
46644c2477c5890 arch/sparc64/mm/init.c  David Miller      2007-10-16  2574  		pte_base = (_PAGE_VALID | _PAGE_SZ4MB_4V |
494e5b6faeda1d1 arch/sparc/mm/init_64.c Khalid Aziz       2015-05-27  2575  			    page_cache4v_flag | _PAGE_P_4V | _PAGE_W_4V);
46644c2477c5890 arch/sparc64/mm/init.c  David Miller      2007-10-16  2576  
c06240c7f5c39c8 arch/sparc/mm/init_64.c David S. Miller   2014-09-24  2577  	pte_base |= _PAGE_PMD_HUGE;
46644c2477c5890 arch/sparc64/mm/init.c  David Miller      2007-10-16  2578  
c06240c7f5c39c8 arch/sparc/mm/init_64.c David S. Miller   2014-09-24  2579  	vstart = vstart & PMD_MASK;
c06240c7f5c39c8 arch/sparc/mm/init_64.c David S. Miller   2014-09-24  2580  	vend = ALIGN(vend, PMD_SIZE);
c06240c7f5c39c8 arch/sparc/mm/init_64.c David S. Miller   2014-09-24  2581  	for (; vstart < vend; vstart += PMD_SIZE) {
df8ee578894ebb5 arch/sparc/mm/init_64.c Pavel Tatashin    2017-11-15 @2582  		pgd_t *pgd = vmemmap_pgd_populate(vstart, node);
c06240c7f5c39c8 arch/sparc/mm/init_64.c David S. Miller   2014-09-24  2583  		unsigned long pte;
5637bc504834045 arch/sparc/mm/init_64.c Mike Rapoport     2019-11-24  2584  		p4d_t *p4d;
c06240c7f5c39c8 arch/sparc/mm/init_64.c David S. Miller   2014-09-24  2585  		pud_t *pud;
c06240c7f5c39c8 arch/sparc/mm/init_64.c David S. Miller   2014-09-24  2586  		pmd_t *pmd;
46644c2477c5890 arch/sparc64/mm/init.c  David Miller      2007-10-16  2587  
df8ee578894ebb5 arch/sparc/mm/init_64.c Pavel Tatashin    2017-11-15  2588  		if (!pgd)
c06240c7f5c39c8 arch/sparc/mm/init_64.c David S. Miller   2014-09-24  2589  			return -ENOMEM;
c06240c7f5c39c8 arch/sparc/mm/init_64.c David S. Miller   2014-09-24  2590  
5637bc504834045 arch/sparc/mm/init_64.c Mike Rapoport     2019-11-24 @2591  		p4d = vmemmap_p4d_populate(pgd, vstart, node);
5637bc504834045 arch/sparc/mm/init_64.c Mike Rapoport     2019-11-24  2592  		if (!p4d)
5637bc504834045 arch/sparc/mm/init_64.c Mike Rapoport     2019-11-24  2593  			return -ENOMEM;
5637bc504834045 arch/sparc/mm/init_64.c Mike Rapoport     2019-11-24  2594  
5637bc504834045 arch/sparc/mm/init_64.c Mike Rapoport     2019-11-24 @2595  		pud = vmemmap_pud_populate(p4d, vstart, node);
df8ee578894ebb5 arch/sparc/mm/init_64.c Pavel Tatashin    2017-11-15  2596  		if (!pud)
c06240c7f5c39c8 arch/sparc/mm/init_64.c David S. Miller   2014-09-24  2597  			return -ENOMEM;
c06240c7f5c39c8 arch/sparc/mm/init_64.c David S. Miller   2014-09-24  2598  
c06240c7f5c39c8 arch/sparc/mm/init_64.c David S. Miller   2014-09-24  2599  		pmd = pmd_offset(pud, vstart);
c06240c7f5c39c8 arch/sparc/mm/init_64.c David S. Miller   2014-09-24  2600  		pte = pmd_val(*pmd);
c06240c7f5c39c8 arch/sparc/mm/init_64.c David S. Miller   2014-09-24  2601  		if (!(pte & _PAGE_VALID)) {
c06240c7f5c39c8 arch/sparc/mm/init_64.c David S. Miller   2014-09-24  2602  			void *block = vmemmap_alloc_block(PMD_SIZE, node);
c06240c7f5c39c8 arch/sparc/mm/init_64.c David S. Miller   2014-09-24  2603  
c06240c7f5c39c8 arch/sparc/mm/init_64.c David S. Miller   2014-09-24  2604  			if (!block)
c06240c7f5c39c8 arch/sparc/mm/init_64.c David S. Miller   2014-09-24  2605  				return -ENOMEM;
c06240c7f5c39c8 arch/sparc/mm/init_64.c David S. Miller   2014-09-24  2606  
c06240c7f5c39c8 arch/sparc/mm/init_64.c David S. Miller   2014-09-24  2607  			pmd_val(*pmd) = pte_base | __pa(block);
46644c2477c5890 arch/sparc64/mm/init.c  David Miller      2007-10-16  2608  		}
46644c2477c5890 arch/sparc64/mm/init.c  David Miller      2007-10-16  2609  	}
2856cc2e4d0852c arch/sparc/mm/init_64.c David S. Miller   2012-08-15  2610  
c06240c7f5c39c8 arch/sparc/mm/init_64.c David S. Miller   2014-09-24  2611  	return 0;
2856cc2e4d0852c arch/sparc/mm/init_64.c David S. Miller   2012-08-15  2612  }
46644c2477c5890 arch/sparc64/mm/init.c  David Miller      2007-10-16  2613  #endif /* CONFIG_SPARSEMEM_VMEMMAP */
46644c2477c5890 arch/sparc64/mm/init.c  David Miller      2007-10-16  2614  

:::::: The code at line 2582 was first introduced by commit
:::::: df8ee578894ebb591c2995cce422e6189c8bb757 sparc64: simplify vmemmap_populate

:::::: TO: Pavel Tatashin <pasha.tatashin@oracle.com>
:::::: CC: Linus Torvalds <torvalds@linux-foundation.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

