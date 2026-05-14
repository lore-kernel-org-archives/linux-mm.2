Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D572CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 07:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EC326B008C; Thu, 14 May 2026 03:05:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49D456B0092; Thu, 14 May 2026 03:05:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B2BE6B0093; Thu, 14 May 2026 03:05:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D5EA6B008C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 03:05:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BD6BE4054D
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:05:00 +0000 (UTC)
X-FDA: 84765138360.15.5B1BBF1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1ED204000C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:04:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HCjfbXbE;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778742299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=pkA6kIbaOS9SA0pUIesgfSHcagenitoY1yNn/rdzd2M=;
	b=8PEP/Wf+mFn1imOmSK9JmJVPfYeqXkFiadc4mv8NehWI7Q9NAbfJ8fIdzaNA3FID4TcbTI
	L4gef3UjmGWSjOZX0yiyGkQUWlO1ermHzmy7x3cRXdNSVwYPhnqodU6uK+PfA1aVrssZba
	meEAcHBQ91ZnWKVPqZRo8p+ODI+kldg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778742299; a=rsa-sha256;
	cv=none;
	b=aykAcMmOrP9z8foFUk6UkzXrftpxD775iB5Q0oZ4NysIwnskn9aTqXWQUYnTIB4joNwK+4
	WITQIYSa5WyqU3r5wyLYwyccM4PvTDE0vsGwWR03d/B24O3lPKhQzYEsyiOiXxYPpgt2FT
	O/CpNNhs8CNyqy/3kZMJnFsIuAZb1S8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HCjfbXbE;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778742298; x=1810278298;
  h=date:from:to:cc:subject:message-id;
  bh=411Jnboet/QWwFehuAV9G/2CgnoSE5wfC1lKddwf7fo=;
  b=HCjfbXbER4jD0kNK+RXoTJSFxm2ipgvxQc4KCMirsQnJFYE/V+kHnqN3
   k2V8vqKHhNG/NUN1sePVykVCVwdnlgs/0ItgKdg2aJFOsgzcETzccbI9u
   t7ieTXvOGwCSnsXoJ2QcL6fq0VIj9Adgm8v76pjQ0tqVbLn7u6O3gPwt4
   gNGjoxeOhxqjlTnz5V0hwyQWjMfszkPJeCi16pa7HiShmLnF0ExdCW5Ca
   GZUJ+VV4cFwJknnt1K2SeuizPHjNSE0ZgpaeQSib0/yQet07pDZBtNnOq
   g0ADBoWpLbp39166rzUZdBazyuZOPqbUfMZdHVAxLtmRDZFT4z48YMqUj
   A==;
X-CSE-ConnectionGUID: kxk072EvQee4WHDLOLTmvQ==
X-CSE-MsgGUID: qAlDrOqYRM+SCY7wOdQJ+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11785"; a="105138343"
X-IronPort-AV: E=Sophos;i="6.23,234,1770624000"; 
   d="scan'208";a="105138343"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 00:04:57 -0700
X-CSE-ConnectionGUID: 0vgEPVR7SyW52BTDJXweJQ==
X-CSE-MsgGUID: XNi7siZmSrSH1y2uJpTQ7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,234,1770624000"; 
   d="scan'208";a="235656562"
Received: from igk-lkp-server01.igk.intel.com (HELO bdf09bfdbd5f) ([10.211.93.152])
  by fmviesa008.fm.intel.com with ESMTP; 14 May 2026 00:04:55 -0700
Received: from kbuild by bdf09bfdbd5f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wNQ7o-000000008ln-2Z4L;
	Thu, 14 May 2026 07:04:52 +0000
Date: Thu, 14 May 2026 09:04:19 +0200
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-unstable 25/274] mm/hugetlb.c:7281:17: error:
 implicit declaration of function '__huge_pmd_unshare'; did you mean
 'huge_pmd_unshare'?
Message-ID: <202605140938.6Mcv6k8i-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1ED204000C
X-Stat-Signature: kd7ydqwqb19ndwr3usqk134syexizi39
X-Rspam-User: 
X-HE-Tag: 1778742297-569940
X-HE-Meta: U2FsdGVkX185eEyXeRliDU3okS7P3CjzhMRuE1vlc7QdM8qFeQ97JK3GIdTRclzBx7NlJ/y1yoi7ej8hyv9ruiTbdn5RGtkhFOWxeiARVzRi0wpayPEToeXKTarWgc7ygBX/vjtaOATZgyv/XWbupNBgJpbmnkctdnA3YLOtFr+ckDBDrGw8MApTSU/xhpUNJELnXQToQ4rfi2x+sX+rams3P9H+xzefcvAKz13I8X0aeBMp/8wHfXBrBXFbL49Ct0H2MtCCyYUbNL6p0L13Jdo2mluYc4z4J2sltMMGljSld+M2FUzuP1Z+SX/NvNqqEM6chM4uBTVHls/ecwCE4b42jjrrMvkFauZJZ3QrWfYei28fWvSMd7l1ohiiMAR2+Zwzz1TDfCu+T5WY+O3fcLfyR4G50++2KILXTdEDvwZ8YMhcOl5MV871F9rU7Yxj0zjk+w+QqqmWqHXPWr12Sax4Gy37G3ycDoxb90+9ZeJH0ZkF9eA8bV1RIyD1gvx0BRQQMNJ+qgibR+hxSXZwSJW6qm3K0MOJt+W+kZ5mb3+lV81uNj0pXMyUrjcCncPu1arOJscU8v+1SOtdZSAIEW7gZH3DGoHYJJZpsLPogwqXI9ISdvLfkYNvYIB9MR2IMgIAxgOxh/+0xvODa6q/U2nCezZy8R0zG4hcxLHlCjnwzBl3t2kUkPe2UtjM8ByUCsIbb7+a8QLu7vEF2jLcyeAUfVp6bmiS+6BXmj7dp+MeZ+F1dDvIBEpmMY3lzdTiuiL39tZ2voWHdug9Bvu8zmtkp0vGUeEEtu0QYmDOIHJuTNataCwEqJvFPyYVWiCIERSRLTJvYs4BBxgaW1EZX85YPLbWRa0YuRyT3cfce/RvnObCwrsPdcebrbTO9P4651fAY62Br5It320jA1bWWk3Wt9HPH9Co3jwzN2nTiufEk1R8JsM9c4JtoWeMIfkEneymPt2Vo3M0mj0H3q+
 /5FNfdde
 DuPPOIDc27ci8AH1iHOfx6R3vkoOc7cJ+/R524rGK6jwHRE6TZch9BbT0uAtmQhtlW97U8nJpaHS8j2wvmKH1Y7R48I/MdhzkXhcehrBy0k0f2rvAupqP7hDOF7p4wZr+BAqaBDqqSG/z5lCW6GWiP8eAxEOd/JgRWZCX0BfdccLMnYeLQeMd4ykqWp0KeUcxornuwPvABdrAedLzWL7kGdElqWXQPpzBUgpTFdo6Hj5ziyhH8Lp2i3AMaflrqwsfppeeC9TznUNpxsj4vKUxZZ/kuT+/4XK7OpkCTQZHKjo3FK8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   444fc9435e57157fcf30fc99aee44997f3458641
commit: 2bb8fe16f7bf4487248c9ff847fcf189c45b9508 [25/274] mm/hugetlb: avoid false positive lockdep assertion
config: s390-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260514/202605140938.6Mcv6k8i-lkp@intel.com/config)
compiler: s390x-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260514/202605140938.6Mcv6k8i-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605140938.6Mcv6k8i-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/hugetlb.c: In function 'hugetlb_unshare_pmds':
>> mm/hugetlb.c:7281:17: error: implicit declaration of function '__huge_pmd_unshare'; did you mean 'huge_pmd_unshare'? [-Wimplicit-function-declaration]
    7281 |                 __huge_pmd_unshare(&tlb, vma, address, ptep, take_locks);
         |                 ^~~~~~~~~~~~~~~~~~
         |                 huge_pmd_unshare


vim +7281 mm/hugetlb.c

  7233	
  7234	/*
  7235	 * If @take_locks is false, the caller must ensure that no concurrent page table
  7236	 * access can happen (except for gup_fast() and hardware page walks).
  7237	 * If @take_locks is true, we take the hugetlb VMA lock (to lock out things like
  7238	 * concurrent page fault handling) and the file rmap lock.
  7239	 */
  7240	static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
  7241					   unsigned long start,
  7242					   unsigned long end,
  7243					   bool take_locks)
  7244	{
  7245		struct hstate *h = hstate_vma(vma);
  7246		unsigned long sz = huge_page_size(h);
  7247		struct mm_struct *mm = vma->vm_mm;
  7248		struct mmu_notifier_range range;
  7249		struct mmu_gather tlb;
  7250		unsigned long address;
  7251		spinlock_t *ptl;
  7252		pte_t *ptep;
  7253	
  7254		if (!(vma->vm_flags & VM_MAYSHARE))
  7255			return;
  7256	
  7257		if (start >= end)
  7258			return;
  7259	
  7260		flush_cache_range(vma, start, end);
  7261		tlb_gather_mmu_vma(&tlb, vma);
  7262	
  7263		/*
  7264		 * No need to call adjust_range_if_pmd_sharing_possible(), because
  7265		 * we have already done the PUD_SIZE alignment.
  7266		 */
  7267		mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
  7268					start, end);
  7269		mmu_notifier_invalidate_range_start(&range);
  7270		if (take_locks) {
  7271			hugetlb_vma_lock_write(vma);
  7272			i_mmap_lock_write(vma->vm_file->f_mapping);
  7273		} else {
  7274			i_mmap_assert_write_locked(vma->vm_file->f_mapping);
  7275		}
  7276		for (address = start; address < end; address += PUD_SIZE) {
  7277			ptep = hugetlb_walk(vma, address, sz);
  7278			if (!ptep)
  7279				continue;
  7280			ptl = huge_pte_lock(h, mm, ptep);
> 7281			__huge_pmd_unshare(&tlb, vma, address, ptep, take_locks);
  7282			spin_unlock(ptl);
  7283		}
  7284		huge_pmd_unshare_flush(&tlb, vma);
  7285		if (take_locks) {
  7286			i_mmap_unlock_write(vma->vm_file->f_mapping);
  7287			hugetlb_vma_unlock_write(vma);
  7288		}
  7289		/*
  7290		 * No need to call mmu_notifier_arch_invalidate_secondary_tlbs(), see
  7291		 * Documentation/mm/mmu_notifier.rst.
  7292		 */
  7293		mmu_notifier_invalidate_range_end(&range);
  7294		tlb_finish_mmu(&tlb);
  7295	}
  7296	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

