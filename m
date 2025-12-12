Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9E45D49216
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 12:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93F2E6B0005; Fri, 12 Dec 2025 07:11:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 917476B0006; Fri, 12 Dec 2025 07:11:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82D006B0007; Fri, 12 Dec 2025 07:11:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6F7B06B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 07:11:59 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 079671353A3
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 12:11:59 +0000 (UTC)
X-FDA: 84210705558.29.16326AE
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5E8ECA0008
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 12:11:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CZdvGgNw;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765541517; a=rsa-sha256;
	cv=none;
	b=JwXd8NB90KuhtPHTJyibwTUli5IAD0UPUuyHSNZGB67RB7DI5gJl+tYK68cFtq5y3SdMUE
	H4ZE/QhnwL29FYiEcl7xxuO+4Oy4b4Tq39gDGeoXLf/qH9tDTcNDO9p8G3ZYqFPBGTbY4O
	UmbasJr73xa0+Q/8OwP+Uc4a07fHz44=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CZdvGgNw;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765541517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B2beOfFYZkgJxjAzm+wuU3WHahUN/Mw/1rtla4ZQ5xM=;
	b=yaM8EdnsVhWtpl+sE07180TReWszQUM5q2z9zRDzet9pAV5ZRqjhquGJnmqwQ+o2dQXhWZ
	lKoryJuFFPt7iR+0CBIwyFxqZcoyBx7B+IQn8UohctVYYKHdqPD6wqR7UXRw3J6JwCV3/K
	G+dDDTd1f9JD+r1AIoDOMGutX3Q/02Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765541517; x=1797077517;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MDqpf9x6/zW98XOuJ4P5mSb9nLGkqLmY81X4Es6oNDM=;
  b=CZdvGgNw5qD8l9x+4CO6RYlTd8oPg+XRJmVRSOMUem4im7pbXjlWLAVQ
   St6hvr8jPIhDPlWkzLPSNI1Z4DmD6F0kKWWOEdQgyJS4dg2NdQQcDVJgD
   za+3PzOyPZRtUX+bC75pAgT2r2egdQmmQDUS6qbezOxjmWWsQQ8+IcVR7
   snrEtChh9ENkQcMamo7Jhc/K8TKQXzdeq5X7ZKdLd/hLtLeg6+kmTPhTW
   ZP6MdKaSPXhRsY/2Y3C1ftnGKGeocxQxPhpvTwl8oQSvxlGPU70F0Ovs2
   tDhQ8yX5rfzWv6i9MScds1BL5KHQeWibycwKbMZrWpFp5JvPoqZLuNxD3
   Q==;
X-CSE-ConnectionGUID: 6NKk+j2wTvKtuuaLgYk/AA==
X-CSE-MsgGUID: PaTniJIPSDG4taJaLv68uA==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="71406293"
X-IronPort-AV: E=Sophos;i="6.21,143,1763452800"; 
   d="scan'208";a="71406293"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2025 04:11:54 -0800
X-CSE-ConnectionGUID: dDrinyMNQkedM3+/Ezfhfw==
X-CSE-MsgGUID: piMLr2XxQeqmGy2iVmSqfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,143,1763452800"; 
   d="scan'208";a="197567910"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 12 Dec 2025 04:11:51 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vU1zx-0000000060r-0Qyv;
	Fri, 12 Dec 2025 12:11:49 +0000
Date: Fri, 12 Dec 2025 20:11:46 +0800
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
Message-ID: <202512121948.74kTIiJi-lkp@intel.com>
References: <20251211081117.1126521-2-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251211081117.1126521-2-samuel.holland@sifive.com>
X-Rspamd-Queue-Id: 5E8ECA0008
X-Stat-Signature: 7hwmegczmjs1mzcpjy8x5damkgmcc753
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765541516-795170
X-HE-Meta: U2FsdGVkX184DW4khOAYEPtMAGfAlvlNZi7LHrYBqggtZzYzPx5rh4/DPkLOZCNzMfF4KsuXrIgKHaN6+QF2fY/BpWo3XZU1LXyxjVJXSM25E0mVLc9320CEibYFV8m9wnR4zzn3A4aPJ3stHzE2hqPlNaTQg/BKIl0u0hpBdJXcL7TPcKe3d8Wb+45fMJhhFIMgmWOmK7pIN8C7MkV3RTjFgDjz+KfeqYLcBtB0QsL30E5OsVmSF2Dm7Db99ZS2/eX9bgusGe9+TjUy+FW/R7KXGHYbT00SWkOwV1nO5IGGQgKkxRxr7nFmlysDaFdQCo6xBHC13eZy04i5PcSkOOJsqBF7iSVcWxZnK0Huk6Ylmn5uDDK0o/ibmRhrZgA5y/b3naoHsEhLg/nyZX42PbicsSqosQxtRVEzlt9wDUnT/ad1YxxCzoLdl00953lIcclK4sli0YZJXo753It4cX7JBTfMIfoqct9jI/KKaxnzs7cHs2gBIryJL2nHPr6GvkQ6mGIvbDzV6ygHd5GmWR4oNFZf5VYZxL3arvfn2H2CXV8gVrqyawHpNU1biKs/thUEOv3EVsC61wTv/KP7d5pkuwqR0o1nY93gNEFlDzwyBqtdJ37Mhdj9k0DTukosyPXmxvszH3qMTZhGd3uAuPchl2e+I546mb9czuNFY1odBEJfqk2kEN00MQ2TaONNuZ3P4agfIv+Pur/dwtmxS9S8ItlVl1QNSlEWlvTJlzT8ZWDhfs9o/97F8reakup0yahOR3m4OduGAVuqKC7ZEazQrxK02VGAl9mDSKfcZZlui/fx7qk08wxTdjmmhF0F69tX3pdogb18pIXR4T0dLqctbmBzmKrSqNfd0GVlKH8PjbUO8aFJQHlSsldPsooeF+ir/SgPlVk9kT8XUuZgx+0JbOkAW4690VoMdaXbu/yU7nOe4WL5gKrUvCiEhQsvZ4eeIw4RD9inR7FgtDN
 KGKzcRLt
 lJotOX02rvWNOFaLPpzMeqWZ8+5hgzq0eXNb2MSlW9z2RXb/cjeEK6XPI+3/FmrxznJCSP6DvIMKTpLOIm00mQJ3R4F7EDATzSDw/hA36cEzLk/WTi5/uGFJUIjyFphzj8icNg2sccbJ+sDhnBfQk3Sc/OFrkGDTtDKbiuVDqAg2XgKOqjQBS6OO2bpv6jaWCLEc8OEYCXT1EZqqx3JJdtxp5IQROcqboOMLx4rHs0qpG7L/BeqjOP+k2VpQvC8T/N4FxZvgSlEZ+HGfPbODeos+y9o9SJYnQHZd9oEdpeK350MKH2xABJX1wqp1awsTADL2FVvz+7ubXhvEJ12QzBErY69bWBPRCUVvg7BaV1Kd9RNb6ljebB+8UdxVkiEsI3VHCWzlW4DZocZHPVCUkFp+bADso+hS+VancXjaeUMHMV5wjEiZBCH6F2w==
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
config: powerpc64-randconfig-r064-20251212 (https://download.01.org/0day-ci/archive/20251212/202512121948.74kTIiJi-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 1335a05ab8bc8339ce24be3a9da89d8c3f4e0571)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251212/202512121948.74kTIiJi-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512121948.74kTIiJi-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/debug_vm_pgtable.c:448:2: error: call to undeclared function 'set_pmd'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     448 |         set_pmd(args->pmdp, __pmd(0));
         |         ^
>> mm/debug_vm_pgtable.c:468:2: error: call to undeclared function 'set_pud'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     468 |         set_pud(args->pudp, __pud(0));
         |         ^
   2 errors generated.


vim +/set_pmd +448 mm/debug_vm_pgtable.c

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

