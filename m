Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41793CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 09:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61D526B0088; Thu, 14 May 2026 05:34:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CE846B008A; Thu, 14 May 2026 05:34:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E5146B008C; Thu, 14 May 2026 05:34:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DFF26B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:34:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D0B7D1A0534
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:34:56 +0000 (UTC)
X-FDA: 84765516192.23.5F5A505
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 40F4D2000A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:34:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FLrzU2sl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778751295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TbagNuO2dMHV8XMaZ1yhcjek3KQjn0Z+demDQEWq0RQ=;
	b=00KPdBV6lNnAU97pA1y/MOZSuCf0+91RrESf4DkYPGXyuOj26wOKULZlhwOSrgBJfv0l36
	okoRBRULU0y5KSHe8s4zPKzfFvrLZyINX82I1nxBDo3zYFidxAVJQ0NIIp2Aah17jb8J8R
	Vi+KZD5k8MOgkmA1m6eCE4W7wdxZX0Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778751295; a=rsa-sha256;
	cv=none;
	b=ARa1ldYZ3BT8qQQ6keMk2fwZaDQeLNWE0Sa96LGA01Ukmyhesa+iTSs38o1+JiBvI7KFQE
	w3hNi/d3zKdonIZlP1dnhkDXHxri5wYVPuH771O9NwAdZMGK965VXZKwS37UA7/68b3v4M
	CcGCzRxdtUcm1br38dziqGeCnY3fu9Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FLrzU2sl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 94FF560008;
	Thu, 14 May 2026 09:34:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D4DC2BCB3;
	Thu, 14 May 2026 09:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778751294;
	bh=Vfnc6YuxQlJxA6PY7X5ZFvM4hXTzk0D7LNw7UTsZT84=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FLrzU2sls1DQa8YN5s+ZKV70CwHVPGPLTjHOSFGUDOT/wO0P+LwknuxAgoOrg2DlO
	 vL+4z6KmIKpr3UsLUkRbIMYvYSRBSpjbnmIkppNe4ug68np2qYpAUej/mxebagdsMx
	 Araz5iwT+CiCFWnMEMrC5tkVSn85Zt9kypfjbLaT+iBnOd5j6O8rSeJsnPMBviFxms
	 /eyDJ2wvZgl2REilyQ0PVT2MLXvdZv/bq4xJtSBLNP4VLTKTKZue/rJGDWS3h/sKLS
	 3HIv2O/ywKPp0QTX1wuxe9hY3ZEEzqgxcwNJ9d9X/c1cWg2Ww3bw1z6vg24jeOK14X
	 PQlDgYorYjceQ==
Date: Thu, 14 May 2026 10:34:49 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-unstable 25/274] mm/hugetlb.c:7281:3: error: call to
 undeclared function '__huge_pmd_unshare'; ISO C99 and later do not support
 implicit function declarations
Message-ID: <agWXJeWRb6olB6fi@lucifer>
References: <202605141638.b5ZBd6IF-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202605141638.b5ZBd6IF-lkp@intel.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 40F4D2000A
X-Rspamd-Server: rspam04
X-Stat-Signature: 18f5iyh6fzjjzruuh1t46ukdtb9h9ruc
X-HE-Tag: 1778751295-795921
X-HE-Meta: U2FsdGVkX1+kLUYRd2tQjprCsaHbwGb6WNtx1GaMWXWlGlRuOPjSPNhEQMP22V7fz/hryWkw8E8bMvZqvHZqbHGxE8E5WtaJNVZR4GUUPPACsRHXDz7tOlVGHFSV/YBdi7WHmacbTfDkeZ5AE3Dj+RUgkyc2cB/Ll+Y25eschhAlU525lN2izuD06SaXluGGSVtfYBEeH3jAcla4lNcFrNEK1B+NNUy832qJ43j/mJ19bkYlSfs3OYBAvSHj8TFfxbZ4RjjXVyJ2FBA/Lv6V9ToZrxJobAPAniVGsVzuppXKliOpF6PsXyz0NCgj+bcHeK5jMg+7RD/5npDlNQuQreH1UI1bC+ugwE4tmnmKTuw8VPbVTLMq5jtgw7kqpD9PWZRpli/CSulUr9W6AL9h8s0EZ49Igb9infSWujSe5Zn8gghl4pwYq5LA/uSQ/aLiZctSta/GNpo2bIBTIzDs2F3o4I7XemHoJTMv7W5YmHmdBSlVlvZTGTLQ9w2lBypiPx+IJwUm3/7FAuXV6YoyLczUVlbEPtgvwaA+NPx1PhEw5D40SEaDtEVR8XWPXDKaK5zMcoDV1/ksyZHe/7JQ8ldOpOKqXF3RgDp8vqlbucOiUi6zH4rpAygX2+2vCzNbPCM5xonytYXmFkT4TC0w9TWVe16RIwifVwpm9s+5Dl1aW0zxVkY3eqpOH4TtI4Yj2iTMkc4MoLYssQn4mJIPhYItj35mB75agbzHw2vIJIU2zFpoU5C/aNKR5/yefuBROp+FUrqq9xiKT6Hf+hBhxenDSgsSOJN1HqQGeBQqSNa5IIBsnKNuLeG+MTWiTs8oJqZGXwtt3K4wMvsw9oYkbT1rPOnDYnAZWUE7nhatG/nasC4AZVQ1jJ1GRSZimKlhF+Ww6EU8hVEHRirDmbBWs9kVD//i7ZBgUNP6BE+a1zNPltue6HbaiKFWb9ivHrVKDt9Iu2uL4bQN6+KvcB6
 SVQKzacN
 3UebeB30F/IpJRxdHrtve/MBLf8NFJcPYMWosRqn0DI2/tE+buO5xzt1pz49FHMLcUev4DJHMhGlrOFaNurpMwbMnHnpo8VhtPvrMhD1dWwzM4Q2bLZfyJF1m93DhOuqENMWe8xvTEKa5BXJub0AWxmyXPhNCrb1xhBIXo9T3o2fH46Wm/EER8CcVxohYissTs8i/wr76UvKmysIpBVyVji9zgsELrcnaD3Z1T4IYxoSalMWro6ZK3YG1dBTjyksY4pWCejxAard+qjoIPD3dm/X1/I2bf0KwzpnFgBh3Wo4kn2I9I6VRnaZOn3Lx2cCmmGMmyH97KgOS6OyQ/CrNUvOxIYI7A5feTS6lFbWgeaDrNpMwzDd+vuZg8TipmdeBAkP0EFuo7mp2tm4E09blU/maGXkK1IKPLS2wKiZbCXgk1cVCAswFQDsBsPNrYyQmJNi0n31WHTcmmbI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 04:37:45PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   444fc9435e57157fcf30fc99aee44997f3458641
> commit: 2bb8fe16f7bf4487248c9ff847fcf189c45b9508 [25/274] mm/hugetlb: avoid false positive lockdep assertion
> config: powerpc64-randconfig-001-20260514 (https://download.01.org/0day-ci/archive/20260514/202605141638.b5ZBd6IF-lkp@intel.com/config)
> compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 5bac06718f502014fade905512f1d26d578a18f3)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260514/202605141638.b5ZBd6IF-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202605141638.b5ZBd6IF-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
> >> mm/hugetlb.c:7281:3: error: call to undeclared function '__huge_pmd_unshare'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>     7281 |                 __huge_pmd_unshare(&tlb, vma, address, ptep, take_locks);
>          |                 ^
>    mm/hugetlb.c:7281:3: note: did you mean 'huge_pmd_unshare'?
>    mm/hugetlb.c:6973:5: note: 'huge_pmd_unshare' declared here
>     6973 | int huge_pmd_unshare(struct mmu_gather *tlb, struct vm_area_struct *vma,
>          |     ^
>    1 error generated.

Yup, I missed the !CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING case, sending a fix.

Cheers, Lorenzo

>
>
> vim +/__huge_pmd_unshare +7281 mm/hugetlb.c
>
>   7233
>   7234	/*
>   7235	 * If @take_locks is false, the caller must ensure that no concurrent page table
>   7236	 * access can happen (except for gup_fast() and hardware page walks).
>   7237	 * If @take_locks is true, we take the hugetlb VMA lock (to lock out things like
>   7238	 * concurrent page fault handling) and the file rmap lock.
>   7239	 */
>   7240	static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
>   7241					   unsigned long start,
>   7242					   unsigned long end,
>   7243					   bool take_locks)
>   7244	{
>   7245		struct hstate *h = hstate_vma(vma);
>   7246		unsigned long sz = huge_page_size(h);
>   7247		struct mm_struct *mm = vma->vm_mm;
>   7248		struct mmu_notifier_range range;
>   7249		struct mmu_gather tlb;
>   7250		unsigned long address;
>   7251		spinlock_t *ptl;
>   7252		pte_t *ptep;
>   7253
>   7254		if (!(vma->vm_flags & VM_MAYSHARE))
>   7255			return;
>   7256
>   7257		if (start >= end)
>   7258			return;
>   7259
>   7260		flush_cache_range(vma, start, end);
>   7261		tlb_gather_mmu_vma(&tlb, vma);
>   7262
>   7263		/*
>   7264		 * No need to call adjust_range_if_pmd_sharing_possible(), because
>   7265		 * we have already done the PUD_SIZE alignment.
>   7266		 */
>   7267		mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
>   7268					start, end);
>   7269		mmu_notifier_invalidate_range_start(&range);
>   7270		if (take_locks) {
>   7271			hugetlb_vma_lock_write(vma);
>   7272			i_mmap_lock_write(vma->vm_file->f_mapping);
>   7273		} else {
>   7274			i_mmap_assert_write_locked(vma->vm_file->f_mapping);
>   7275		}
>   7276		for (address = start; address < end; address += PUD_SIZE) {
>   7277			ptep = hugetlb_walk(vma, address, sz);
>   7278			if (!ptep)
>   7279				continue;
>   7280			ptl = huge_pte_lock(h, mm, ptep);
> > 7281			__huge_pmd_unshare(&tlb, vma, address, ptep, take_locks);
>   7282			spin_unlock(ptl);
>   7283		}
>   7284		huge_pmd_unshare_flush(&tlb, vma);
>   7285		if (take_locks) {
>   7286			i_mmap_unlock_write(vma->vm_file->f_mapping);
>   7287			hugetlb_vma_unlock_write(vma);
>   7288		}
>   7289		/*
>   7290		 * No need to call mmu_notifier_arch_invalidate_secondary_tlbs(), see
>   7291		 * Documentation/mm/mmu_notifier.rst.
>   7292		 */
>   7293		mmu_notifier_invalidate_range_end(&range);
>   7294		tlb_finish_mmu(&tlb);
>   7295	}
>   7296
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

