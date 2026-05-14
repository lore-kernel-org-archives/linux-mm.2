Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5632CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 07:31:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCA2E6B008A; Thu, 14 May 2026 03:31:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7BA16B008C; Thu, 14 May 2026 03:31:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8E8E6B0092; Thu, 14 May 2026 03:31:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B68A06B008A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 03:31:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4DD3C1C015C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:31:54 +0000 (UTC)
X-FDA: 84765206148.02.81A9FB6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6098DA0010
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:31:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="JsIdo/I5";
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778743912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tyfkllIH7LbPEtK8MWnkwyscNpfQO/0uH0s/H/KC8vk=;
	b=1fiTygbsukiQKEc0uUmVjfxX38UqyQeqoL85I2UJGM/Pq6BeK0lscQ67yfMi55X19J7rNU
	N9EhViUREtuauh2o3PaKD/JwOg2eu5mFvupNe0C6WzDJLB4XjLDbDmrYCcOmE+Z9MU1ovB
	AljxZIIeG/QB+ZLHvOa8Fnd5YO7iTIQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="JsIdo/I5";
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778743912; a=rsa-sha256;
	cv=none;
	b=fNgPcUvhyujTiahe32iEpELZaX3CiCX6SbMqUae0vBVlDxQQx+yOoB3QcUegqrDTlHLYze
	LMeygu8Ye06vuf8fXVpt2UNIC30dZ5cOwywAz90Rzw8Hmcr+H0NKtVx6CJzTrI0Is1wfaH
	qmfgzkZGHfRVTPafBJdbfTuBeOHJfes=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3ED2A4372F;
	Thu, 14 May 2026 07:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9191BC2BCB7;
	Thu, 14 May 2026 07:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778743911;
	bh=Ay5uhoOGOYpltka+aAhsUFibbeXpCTRdpo6QYpLTuJk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JsIdo/I5ob6nIZBCV0Nm0QvFRM7GAjZO6cce/dPC6LHVDh3BcmlKrraHqin4HjgxI
	 IL6P7Dgja8fqyb2B5K0+BSNARhjIWtqRcZ9ZAR7c+YIw4YgKZIrW1ToLL3FIQ6igIg
	 WnQFsWl/w+rIMlfLVUbVCT4X2ftfwu+NPs9ZMC/A7p4FJO5zooRyG8FZ+zq87V+1+X
	 O5Wqf35X/x2T316C3nKImY1vE+4NHf6I4b/UBY+IqZGOYM5JZrwKtQx/8k62mjWebt
	 pAdMzKN7BTLZbI0AzfT9eJmXX3oXOSh0ZNnKp7Qyk+wgGEwPvZnqMmZnfko2hdepbL
	 DGZI47eZsn4/Q==
Date: Thu, 14 May 2026 08:31:46 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Linux Memory Management List <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-unstable 25/274] mm/hugetlb.c:7281:17: error:
 implicit declaration of function '__huge_pmd_unshare'; did you mean
 'huge_pmd_unshare'?
Message-ID: <agV6PCWZGvwNWutl@lucifer>
References: <202605140938.6Mcv6k8i-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202605140938.6Mcv6k8i-lkp@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6098DA0010
X-Stat-Signature: 1iu5c3zjxhe9ummznbsp9z9nnkksjqhk
X-HE-Tag: 1778743912-80881
X-HE-Meta: U2FsdGVkX1+lTjt9xheI9OikGZHTW3XzPZQAYNbW1mxl8HTevJ5I0IdYPn5vJYhkdK+avRiU02jBRTMwRXwASgaVtCc0FdfqF1NKbZyt46QxswTBSXy9BEDbHbE455xh/oL9W1vFOmQ+zimOljDdYy9lCVdytDyOobfQunwtjm+pht6F6AXBaa5GGS9hAVAo1CsyretY84HvnOh57DAi6z/FcWAqf1FjQI4lC0ksE10vw2/qHtjbiiYd6snDAWsOMFeU+mHVXTALzeLdbrBUDYYkmM1IFTREnsL+OACk1gkL0y2nDKP5T1uMrV0CCuivFep65hgjWo3pu3fZWkmcReN2zTqAIVHx75ijYeqhdoT6nJWHRTpx2dE5tHMJ/jIW4iJbW8uZqU99ovUhxJ81tLthdxepuFGe7ojudbfLhBPWg+hXOnXyUUBJZmSrwOx54OndEzTurDXrgCRiSk/Iaq/kx70hoCqCNAk/d3gfb0/myd6Z/sSuXUv+NrNhy5O9aeY8K0TzKvyliK/7J5lIDOqS0EJBRlMwh5S/LlsSyh4H7TWdsL2Dw+mufhAqmKwNKo4k+QfTFgEZVzWYsEJoMYagzdV3H1XWdaz8xiFZK8lXmea0Ig3U5jmJfcS6IplbZnCItYH4xsgZ+U/LhA7ijodZbvuyfsyPjmoJjy2AWVKusUaF1ZMxdjfoqMGciktnnFvYkzWj6gO+iV2qT2U2DcJBjZd9Z+AloGlwCKwRe497ROs9QL8afGwPzVrRYfLlGKKdBRUUvJfN9/mrC0nkBO1hAtfUSjXD0gcU1DkuOEHZpBJczP8JVuIZBcCNGEDCf1Lp7ruyY9oU+qpMGcCJQdpKXfBAYU/naYaCoYET4XOTwnkvz/Ge5mKpaOUDZMyPv3itpzp7jfSGV6GDQlFTSxtOla6aAoNUEVv+CxNsGTACl2Mze1eET+MfYZbgSpN4Qp9Vh24fIXARaPn9zsy
 anMpeeU9
 I4nFOHXMuuNIuNoLxYMPaDVJsEa77a583hRt6DEjfk3ETpWzI8HoU2zZtDOrokY+Ke5ORJld9d7+E9lxsLsgQOCWwjrLkDobBZumE7Xe1k9wJ0kolC6c9qeDEm6sf+53u1uMUWTWnpHh3ByVGupz3NrRjzYNmrxlAvIlX0nqf4ilF4Fd/UirdhO6gmzKDqAh3CnZWhW/RkgmhlW8C0RAtGPgeKntCMjZOLgx/Qq8Bh9CGiTs7+MqAkPeakZxJqQpNnpCCTz9226sZ9+vlahus7ox6/Rezo+zuvkUFqBvk0sFBqPxJf01V2MRfv9+kwhWQPXLO3jJQgsSqsfISod/SWXPT4+MgrhO3iXQxiEzEhGp5cU9R6NX4pTprVBzdxcsBEMkIPRI3YXBg+pUtyPy30BS7SWF4m+92d3nncS58wo98SMhOBLWeLiir1Th5G0jRNOnaqMJ7Zx5EjWRIFzF/M9Iltg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 09:04:19AM +0200, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   444fc9435e57157fcf30fc99aee44997f3458641
> commit: 2bb8fe16f7bf4487248c9ff847fcf189c45b9508 [25/274] mm/hugetlb: avoid false positive lockdep assertion
> config: s390-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260514/202605140938.6Mcv6k8i-lkp@intel.com/config)
> compiler: s390x-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260514/202605140938.6Mcv6k8i-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202605140938.6Mcv6k8i-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
>    mm/hugetlb.c: In function 'hugetlb_unshare_pmds':
> >> mm/hugetlb.c:7281:17: error: implicit declaration of function '__huge_pmd_unshare'; did you mean 'huge_pmd_unshare'? [-Wimplicit-function-declaration]
>     7281 |                 __huge_pmd_unshare(&tlb, vma, address, ptep, take_locks);
>          |                 ^~~~~~~~~~~~~~~~~~
>          |                 huge_pmd_unshare
>

Ack, missed the !CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING case. Will send
a patch for this :)

Cheers, Lorenzo

>
> vim +7281 mm/hugetlb.c
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

