Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B15FD4335B
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 00:49:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD6276B0005; Thu, 11 Dec 2025 19:49:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7F616B0006; Thu, 11 Dec 2025 19:49:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6E926B0007; Thu, 11 Dec 2025 19:49:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F2BA6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 19:49:07 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0FB1A134D35
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 00:49:07 +0000 (UTC)
X-FDA: 84208984734.12.C02B5B2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf14.hostedemail.com (Postfix) with ESMTP id 36411100006
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 00:49:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="k/xuhmZd";
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765500545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jeva+36fJ5P0pjrBn18SToG5hocs24JqlFJeTx/gCRc=;
	b=o2DdLmdisVmDw1QjrcujD25L1R/fG5UlDXpjMdWEoP+YJW5KSQHOAn9VR+jB52bS/Zcaup
	8omOwoMaX0yZhhfSEiS2QxjyHM0Zx6MyyyP2OYVQSOoftPDzDBVCG4Ujjdu+xJOTFyHiJA
	bRp4yJ5RoA/MaeMdjJpfJ2iqfI3LxI8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="k/xuhmZd";
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765500545; a=rsa-sha256;
	cv=none;
	b=dbXoFEsNxYBmAMscWbphELuJ2+RBdEZLRe3Sa+2kusNuKA2ojwe7vZIkNIay4ibddA8Uwn
	tH87fyf+CKjG8K+lZiIccyV11xwi7s0MA3qazYyOJoXRKkmi6VYsaf9A6OKAqoq5/9B2Sd
	hAZdpObzIJ4NkXhBU5VNS/cSa1splL8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765500544; x=1797036544;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hAe6AAOvyOebdWwsY5kojqH4D7Nkm+axQcV4KqQWf/I=;
  b=k/xuhmZdjKRbPMawnL/S10mKrB3zU/EGiuKCK+px0WLjFbJjeVF7B8xT
   Af1C5VxqXDS4HdQj46fimFL4FWDXJgbqb9NbHAA5Cw3idmOvcU/sfXj8W
   4JBPHz4y5m5803SjCyn6JsBJ5ln+nWU6A5J3mio2n8KSEnXaDOs1Rydiy
   WfM88691i8HH+Akfxc1BOJwNAexrEbAky+xC3hLpHm/19jE8I8swcXQlJ
   YP9/kyz1NOAfqfo7zDablD0H/Ht1Wjr0v90ol76Fl8fqCyeFiltQYg8bD
   FmToGPStyIUQpAbACYZcAgWAFIawKEarez59CCN6YnrUFAJ5grgvrbcFE
   Q==;
X-CSE-ConnectionGUID: uPOOtPH1Q1O9QSMeCd5+Gw==
X-CSE-MsgGUID: aBIPBLz1TjG2ySVphCq8kQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="78114224"
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="78114224"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 16:49:02 -0800
X-CSE-ConnectionGUID: 31ljWDxmTvqtOvYRtR4LDQ==
X-CSE-MsgGUID: 9vwaFrSoRJqSM2OGFXVN6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="197756649"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 11 Dec 2025 16:48:59 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vTrL7-000000005Fl-1fJF;
	Fri, 12 Dec 2025 00:48:57 +0000
Date: Fri, 12 Dec 2025 08:48:24 +0800
From: kernel test robot <lkp@intel.com>
To: Samuel Holland <samuel.holland@sifive.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, Ryan Roberts <ryan.roberts@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Gavin Shan <gshan@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: Re: [PATCH 1/2] mm/debug_vm_pgtable: Use set_pXd() to write page
 tables
Message-ID: <202512120808.akRJJMa7-lkp@intel.com>
References: <20251211081117.1126521-2-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251211081117.1126521-2-samuel.holland@sifive.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 36411100006
X-Stat-Signature: qm5npsf95h7np4nxxbfqjycxe9nbetzc
X-Rspam-User: 
X-HE-Tag: 1765500543-645101
X-HE-Meta: U2FsdGVkX18cvPYT/Ob2J+6g8H5PThry52ysONh4K2RDOAu4o8zb15jiliLCMePSYAzNganRjZOIY/Dnygyt5IKTGs4Bid7F4sN8CFVfNrqKA4Pg8zCfsLOci2cmZloAmHfjmogoegPhiAeBZ+Nu/aplaZdvDptrquvKwKpd0k16vbW8hKUo7Z7GG3FGjUG1zhmM15r1wBHwBjjcsxyAxMoHYPBmPEFl0GhF4Qa87ZG3rNHz0ODde2LNMqjlXntnFhFWk0iJM/2OzZiGEmMwDogc0LJXk0hSfL9LYCi5VVpPKpuT5w6x9+0NvoYHKHwYv/8XqaOfp8Ln/A6w7NoJ/1DYGhSiuilniiw7enfHA9L61RAfov4LocFiOFozr+usrp2I5NVfMCuBuSQN2LID6KpHwICVvjFHuBJEGJHn4iQ9YRr3HzBzCdUspHq6ydEM1bdqTObGAQnaW0e+Eh2/j6o3yaGTjDgrHEIK0DTX4iWjsq0p/CRBsNz4lQCQjKZN/M0kxfVqdnebJydVqqg4iFQvZ6unUPQBfofz+EZupIXFpBihqLdk0dyQQDysUuHC2xH6NpLAct1k3d8NCSrqnO+ZxZZl2bvqYIrDVjqNbQreznuRlsqepCgfboJkft2J76FoBvXXm+1dPMxXUmCvxhZ+Zfckad4glGMhnRv2MJsc/x8lqTulvcY0XsZ0ep6uqmWYj12nsCYW50yRDbcyWPCNvZBLaxZSOLvwslgfFo6+HnurP9sKhh/wDreYk4hNJgjaXN5rB5PCK39lOg110Z/hXser33MYegzUtQ80SFdc2DszNBniWxIz1iqNoPMRs1mJ6w8ZVYBvwddtdmtnHsG6uczX+MueQDUAlcPYs55pCe6PaHVJCMjIYxBWJkdMh43nP+mk/INamcub27VisB5ZVpO89aamwb333Kkzs1IkeT0RPnc1BlDM/4fxqw3SaoGK9Miwh7nTlN+H0Dv
 bg7NUIhL
 qmxrb/a2Vt8DvnVOiggP6EUs6F4k/HabUV9V9cKs4mxqyeh4R2HcW/7p6e9WDpcey92dVJNo7vPFX31titmuUofxHGrP2r1B1vfFkQOGVtyCvZUsPznoPYmIsu+qJn+nW6AeBCiNJgms8rPo2iB+bmg5yqeROZvryNYKyO9TwM+HDWXpOtiy5igyON6Z94Z7orxi5YII4R43If/qYDVex+6UXJ0xmbcex9KqY60hp74k5YA1ghRl+XVpLATmaS3LZIEyD0FuHdkYrdf829dt2b4uY/Y8NFRu1Tu6D+r9RZBa2RaK/q5tkbSIvZBMoMAcm61tmxMCKdvW4NpEQL8UcwH2KtJCvtDVoKWZ3ty6TRnzutyM3MCLMwUsGTDMCwGq7YOANQXXzFCkho8HhTpGk4npJ8oxX4XVxzDLkElGKUzSbNKqCeODqi8zgVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Samuel,

kernel test robot noticed the following build errors:

[auto build test ERROR on d358e5254674b70f34c847715ca509e46eb81e6f]

url:    https://github.com/intel-lab-lkp/linux/commits/Samuel-Holland/mm-debug_vm_pgtable-Use-set_pXd-to-write-page-tables/20251211-161254
base:   d358e5254674b70f34c847715ca509e46eb81e6f
patch link:    https://lore.kernel.org/r/20251211081117.1126521-2-samuel.holland%40sifive.com
patch subject: [PATCH 1/2] mm/debug_vm_pgtable: Use set_pXd() to write page tables
config: powerpc64-randconfig-r054-20251212 (https://download.01.org/0day-ci/archive/20251212/202512120808.akRJJMa7-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251212/202512120808.akRJJMa7-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512120808.akRJJMa7-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/debug_vm_pgtable.c: In function 'pmd_huge_tests':
>> mm/debug_vm_pgtable.c:448:2: error: implicit declaration of function 'set_pmd'; did you mean 'set_pgd'? [-Werror=implicit-function-declaration]
     448 |  set_pmd(args->pmdp, __pmd(0));
         |  ^~~~~~~
         |  set_pgd
   mm/debug_vm_pgtable.c: In function 'pud_huge_tests':
>> mm/debug_vm_pgtable.c:468:2: error: implicit declaration of function 'set_pud'; did you mean 'set_pgd'? [-Werror=implicit-function-declaration]
     468 |  set_pud(args->pudp, __pud(0));
         |  ^~~~~~~
         |  set_pgd
   cc1: some warnings being treated as errors

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for CAN_DEV
   Depends on [n]: NETDEVICES [=n] && CAN [=y]
   Selected by [y]:
   - CAN [=y] && NET [=y]


vim +448 mm/debug_vm_pgtable.c

   433	
   434	#ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
   435	static void __init pmd_huge_tests(struct pgtable_debug_args *args)
   436	{
   437		pmd_t pmd;
   438	
   439		if (!arch_vmap_pmd_supported(args->page_prot) ||
   440		    args->fixed_alignment < PMD_SIZE)
   441			return;
   442	
   443		pr_debug("Validating PMD huge\n");
   444		/*
   445		 * X86 defined pmd_set_huge() verifies that the given
   446		 * PMD is not a populated non-leaf entry.
   447		 */
 > 448		set_pmd(args->pmdp, __pmd(0));
   449		WARN_ON(!pmd_set_huge(args->pmdp, __pfn_to_phys(args->fixed_pmd_pfn), args->page_prot));
   450		WARN_ON(!pmd_clear_huge(args->pmdp));
   451		pmd = pmdp_get(args->pmdp);
   452		WARN_ON(!pmd_none(pmd));
   453	}
   454	
   455	static void __init pud_huge_tests(struct pgtable_debug_args *args)
   456	{
   457		pud_t pud;
   458	
   459		if (!arch_vmap_pud_supported(args->page_prot) ||
   460		    args->fixed_alignment < PUD_SIZE)
   461			return;
   462	
   463		pr_debug("Validating PUD huge\n");
   464		/*
   465		 * X86 defined pud_set_huge() verifies that the given
   466		 * PUD is not a populated non-leaf entry.
   467		 */
 > 468		set_pud(args->pudp, __pud(0));
   469		WARN_ON(!pud_set_huge(args->pudp, __pfn_to_phys(args->fixed_pud_pfn), args->page_prot));
   470		WARN_ON(!pud_clear_huge(args->pudp));
   471		pud = pudp_get(args->pudp);
   472		WARN_ON(!pud_none(pud));
   473	}
   474	#else /* !CONFIG_HAVE_ARCH_HUGE_VMAP */
   475	static void __init pmd_huge_tests(struct pgtable_debug_args *args) { }
   476	static void __init pud_huge_tests(struct pgtable_debug_args *args) { }
   477	#endif /* CONFIG_HAVE_ARCH_HUGE_VMAP */
   478	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

