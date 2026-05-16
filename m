Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFC75CD4851
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 04:26:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BE8A6B0088; Sat, 16 May 2026 00:26:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 048376B008A; Sat, 16 May 2026 00:26:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E506B6B008C; Sat, 16 May 2026 00:26:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFFEF6B0088
	for <linux-mm@kvack.org>; Sat, 16 May 2026 00:26:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 620A08C78C
	for <linux-mm@kvack.org>; Sat, 16 May 2026 04:26:21 +0000 (UTC)
X-FDA: 84771996162.05.A64A79E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf24.hostedemail.com (Postfix) with ESMTP id D2787180008
	for <linux-mm@kvack.org>; Sat, 16 May 2026 04:26:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VQeBfkGb;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778905579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=hChbLNpXXbL7KblH8RGadHGAAlPTeY27fEnDix1RnL0=;
	b=UVGbK9oYR58zlI0kcoCr8q81jLLcOwp6YWRG2LVt7+FviXUfqO0DCZG62fDaVJqwmns9cN
	azymkZbtUtIep00F6JoZmL/Rc9X8lpxovXHBuGZHY90O51Qv4TL/RMEH4W6eK4wPEq2z/8
	O4iVL4LYU9qu84mfzfqtXMJ3p2cesOE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VQeBfkGb;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778905579; a=rsa-sha256;
	cv=none;
	b=6WP+DiV4CsNHgGOKPMf4srwnbhygwn1DbOkktmX+1USKgy9NL0qn3RM/JSORQPMF1jicG2
	vwUYBRMz2JmdDQhM8g7Ybirb1DXYnOCuIPWUknFNr2YEgTiGugYhjQSWQcRJFnTELVk4P1
	Dq5EnoYi+omtOvNDbbAMX2NYpy0mG3s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778905579; x=1810441579;
  h=date:from:to:cc:subject:message-id;
  bh=qMJi6v37aK/OO0QRNAzlJodrsIikX+9b/6TiOy0sAJw=;
  b=VQeBfkGbCVtQRKinSzqR8kyCg4LHYOSf0p17aG8xdFlSNXE1Zo/QopDh
   iL2mJTyHRCCg5Sjd3oZf9UE5BBj6vKCkY2uFlj6kBCJJXBzA3MjFz5vW5
   oQBqjhz66rXLS+n/x6oNVpu2wKOLVvigNhskwijUaZhFTFSx/xiiWyfUk
   R0+qneju8hBiDJv/4MbeCP60OtMeTW0/fqkqAijIiLtFvmUmlFRbzQv0q
   0YJCZPoFfL0OM2dg3uKqiOIHrG77JrchHqDeauFc2YK1dg9QYjUTrdek2
   9Az6+9ejK82+6IlhXyNX4v3nsPOT9VOYUcEiwfCxl37r1slGJOeZ2KXJ4
   Q==;
X-CSE-ConnectionGUID: Dqvm8ZmdQGW/h9y+ohuqHA==
X-CSE-MsgGUID: 4iTgzp2DRV2g1ZVtmAIYMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11787"; a="78993523"
X-IronPort-AV: E=Sophos;i="6.23,237,1770624000"; 
   d="scan'208";a="78993523"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2026 21:26:17 -0700
X-CSE-ConnectionGUID: WE6vCy1ASbms2Ux26ERpTw==
X-CSE-MsgGUID: KgOCFBY4Qratm65j557zlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,237,1770624000"; 
   d="scan'208";a="232499702"
Received: from lkp-server01.sh.intel.com (HELO d94e5e629b2d) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 15 May 2026 21:26:15 -0700
Received: from kbuild by d94e5e629b2d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wO6bM-000000000TD-40H6;
	Sat, 16 May 2026 04:26:12 +0000
Date: Sat, 16 May 2026 12:25:57 +0800
From: kernel test robot <lkp@intel.com>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: mm/mprotect.c:700:43: sparse: sparse: cast to non-scalar
Message-ID: <202605161217.1mPJ49Gv-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: k6o47mr7mtey6tgbtwg1qdf14ac94ukn
X-Rspamd-Queue-Id: D2787180008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778905578-684122
X-HE-Meta: U2FsdGVkX1+MSm7hVDR8pI9uknWlczY3AsxnozaEacbAS/stUym7mPxRHVXkj1jXOMSmUs06nIVteMh7lU5fcI94CDi4vKY1ZW6+iTbSJVYtuGG0UoHzcuKtDYL83CqWzUr1ARvD8aMCYWGHRrJpL6HAjKdIdADwmAdcdqE5lDZ0yPurtaQOw4F7RDt6sWPOIKTj8rFwJjixjF6mYPmuIqOj9z/dRod0IrpA8gI8vkjKDN/vHOVbmrtOO0Qi/WL02rTtO2D2vdvVY7hSDJ760HP/abGcOF2VJdBd2d7kEBVgu1LEPZYfJXPDsMpuOGgkYGAvrsn/DhObOh/VKR218teTTfXs4yzPzZRYwRrCa1mer8oRWVPwNd1I2K18Ljrsot+7ebj1oETHy5wJecEMWp6dsjXQwi9sZAOX+zNKA4sV8rmgLj8Pi4QfmGUl5ENkq3pNlzSomDws/M9Y3DPxjCZeovxJK+m3B8adS7hnbLMEBH+YYoiVzU66OhtCbAzm9xXaGMQzp31LPfIx0KR4pO0eZ/kgayRVmbvHtqZh7dkO2QqeBXjxMz1LkY1HdYlKkY3/a9lqNX2q5MWoDV/WU6U++iO+pq3+I9GzZ+TwcqaqfIpLhT9bI/ePoauuqZJR8KEH+DltwqqvLZbcReJiv2cn4gr235ILnMU7s7Ow6GASPNw7hQonYJx8mBJ+NwOwRupsVJJsIh160bil/SrAvrWg644TsWJBzDKX+bISsr1fs3ai08PxPyEO7ARJuhqCUqrjk+oMdsebDA4WoL3TLM3gycDVFwSHwP4/c/mW/BNVFSo0f6E6z7H61GtBoD6oLG7mKhWUw8nNkXOpvsG+nmpQQFwih88zIR8GttlCcxYVHexuLMEUONOzePFhO2Tltwt/WYDdkXOKHezLZuvhOsXRMyGvIT16IrUgbLAFWbhEPM/Nz3Pyr6QyHLm+T9sUlfKXcgR8F232Z7ng+/D
 7P8EaEux
 Ys0VHZnd0yllwQdKbDQxcTMwjnQSNqDXSgf2MuvNmp7Q4jTjM3MPFuZSk6y9Ct8liIF2ULn575BeMA+V0fgrWEOhcJIgrg2HLG1JLQzBWvR0bIptY7shlSTekpTWJ7pSZZxnnsyvuo2nLpjoKk00MSSQT2T6zrAyssnVKuC5qPu9E+BE28NV5JuGZQm3Ljah8zo7LrsDnNUONGFfasy041Fv+6OxtcRMw8mHAngay6jRtHwC/vdScy6KJ2uoWRiz9cS3lyC56OAwWr47kPZMPsVrFuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   d458a240344c4369bf6f3da203f2779515177738
commit: 3a6455d56bd7c4cfb1ea35ddae052943065e338e mm: convert do_brk_flags() to use vma_flags_t
date:   6 weeks ago
config: alpha-randconfig-r121-20260516 (https://download.01.org/0day-ci/archive/20260516/202605161217.1mPJ49Gv-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 15.2.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260516/202605161217.1mPJ49Gv-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Fixes: 3a6455d56bd7 ("mm: convert do_brk_flags() to use vma_flags_t")
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605161217.1mPJ49Gv-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> mm/mprotect.c:700:43: sparse: sparse: cast to non-scalar
>> mm/mprotect.c:700:43: sparse: sparse: cast from non-scalar
   mm/mprotect.c: note: in included file (through include/linux/mm.h, include/linux/pagewalk.h):
   include/linux/pgtable.h:461:16: sparse: sparse: cast to non-scalar
   include/linux/pgtable.h:461:16: sparse: sparse: cast from non-scalar
   include/linux/pgtable.h:461:16: sparse: sparse: cast to non-scalar
   include/linux/pgtable.h:461:16: sparse: sparse: cast from non-scalar
   include/linux/pgtable.h:461:16: sparse: sparse: cast to non-scalar
   include/linux/pgtable.h:461:16: sparse: sparse: cast from non-scalar
   include/linux/pgtable.h:461:16: sparse: sparse: cast to non-scalar
   include/linux/pgtable.h:461:16: sparse: sparse: cast from non-scalar
   include/linux/pgtable.h:475:16: sparse: sparse: cast to non-scalar
   include/linux/pgtable.h:475:16: sparse: sparse: cast from non-scalar
   include/linux/pgtable.h:468:16: sparse: sparse: cast to non-scalar
   include/linux/pgtable.h:468:16: sparse: sparse: cast from non-scalar
   include/linux/pgtable.h:461:16: sparse: sparse: cast to non-scalar
   include/linux/pgtable.h:461:16: sparse: sparse: cast from non-scalar
   include/linux/pgtable.h:461:16: sparse: sparse: cast to non-scalar
   include/linux/pgtable.h:461:16: sparse: sparse: cast from non-scalar

vim +700 mm/mprotect.c

   693	
   694	int
   695	mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
   696		       struct vm_area_struct *vma, struct vm_area_struct **pprev,
   697		       unsigned long start, unsigned long end, vm_flags_t newflags)
   698	{
   699		struct mm_struct *mm = vma->vm_mm;
 > 700		const vma_flags_t old_vma_flags = READ_ONCE(vma->flags);
   701		vma_flags_t new_vma_flags = legacy_to_vma_flags(newflags);
   702		long nrpages = (end - start) >> PAGE_SHIFT;
   703		unsigned int mm_cp_flags = 0;
   704		unsigned long charged = 0;
   705		int error;
   706	
   707		if (vma_is_sealed(vma))
   708			return -EPERM;
   709	
   710		if (vma_flags_same_pair(&old_vma_flags, &new_vma_flags)) {
   711			*pprev = vma;
   712			return 0;
   713		}
   714	
   715		/*
   716		 * Do PROT_NONE PFN permission checks here when we can still
   717		 * bail out without undoing a lot of state. This is a rather
   718		 * uncommon case, so doesn't need to be very optimized.
   719		 */
   720		if (arch_has_pfn_modify_check() &&
   721		    vma_flags_test_any(&old_vma_flags, VMA_PFNMAP_BIT,
   722				       VMA_MIXEDMAP_BIT) &&
   723		    !vma_flags_test_any_mask(&new_vma_flags, VMA_ACCESS_FLAGS)) {
   724			pgprot_t new_pgprot = vm_get_page_prot(newflags);
   725	
   726			error = walk_page_range(current->mm, start, end,
   727					&prot_none_walk_ops, &new_pgprot);
   728			if (error)
   729				return error;
   730		}
   731	
   732		/*
   733		 * If we make a private mapping writable we increase our commit;
   734		 * but (without finer accounting) cannot reduce our commit if we
   735		 * make it unwritable again except in the anonymous case where no
   736		 * anon_vma has yet to be assigned.
   737		 *
   738		 * hugetlb mapping were accounted for even if read-only so there is
   739		 * no need to account for them here.
   740		 */
   741		if (vma_flags_test(&new_vma_flags, VMA_WRITE_BIT)) {
   742			/* Check space limits when area turns into data. */
   743			if (!may_expand_vm(mm, &new_vma_flags, nrpages) &&
   744			    may_expand_vm(mm, &old_vma_flags, nrpages))
   745				return -ENOMEM;
   746			if (!vma_flags_test_any(&old_vma_flags,
   747					VMA_ACCOUNT_BIT, VMA_WRITE_BIT, VMA_HUGETLB_BIT,
   748					VMA_SHARED_BIT, VMA_NORESERVE_BIT)) {
   749				charged = nrpages;
   750				if (security_vm_enough_memory_mm(mm, charged))
   751					return -ENOMEM;
   752				vma_flags_set(&new_vma_flags, VMA_ACCOUNT_BIT);
   753			}
   754		} else if (vma_flags_test(&old_vma_flags, VMA_ACCOUNT_BIT) &&
   755			   vma_is_anonymous(vma) && !vma->anon_vma) {
   756			vma_flags_clear(&new_vma_flags, VMA_ACCOUNT_BIT);
   757		}
   758	
   759		newflags = vma_flags_to_legacy(new_vma_flags);
   760		vma = vma_modify_flags(vmi, *pprev, vma, start, end, &newflags);
   761		if (IS_ERR(vma)) {
   762			error = PTR_ERR(vma);
   763			goto fail;
   764		}
   765		new_vma_flags = legacy_to_vma_flags(newflags);
   766	
   767		*pprev = vma;
   768	
   769		/*
   770		 * vm_flags and vm_page_prot are protected by the mmap_lock
   771		 * held in write mode.
   772		 */
   773		vma_start_write(vma);
   774		vm_flags_reset_once(vma, newflags);
   775		if (vma_wants_manual_pte_write_upgrade(vma))
   776			mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
   777		vma_set_page_prot(vma);
   778	
   779		change_protection(tlb, vma, start, end, mm_cp_flags);
   780	
   781		if (vma_flags_test(&old_vma_flags, VMA_ACCOUNT_BIT) &&
   782		    !vma_flags_test(&new_vma_flags, VMA_ACCOUNT_BIT))
   783			vm_unacct_memory(nrpages);
   784	
   785		/*
   786		 * Private VM_LOCKED VMA becoming writable: trigger COW to avoid major
   787		 * fault on access.
   788		 */
   789		if (vma_flags_test(&new_vma_flags, VMA_WRITE_BIT)) {
   790			const vma_flags_t mask =
   791				vma_flags_and(&old_vma_flags, VMA_WRITE_BIT,
   792					      VMA_SHARED_BIT, VMA_LOCKED_BIT);
   793	
   794			if (vma_flags_same(&mask, VMA_LOCKED_BIT))
   795				populate_vma_page_range(vma, start, end, NULL);
   796		}
   797	
   798		vm_stat_account(mm, vma_flags_to_legacy(old_vma_flags), -nrpages);
   799		vm_stat_account(mm, newflags, nrpages);
   800		perf_event_mmap(vma);
   801		return 0;
   802	
   803	fail:
   804		vm_unacct_memory(charged);
   805		return error;
   806	}
   807	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

