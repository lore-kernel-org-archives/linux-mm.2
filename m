Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A14DCD5BB4
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 14:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC76A6B00A0; Fri, 22 May 2026 10:29:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C77A16B00A2; Fri, 22 May 2026 10:29:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8E506B00A3; Fri, 22 May 2026 10:29:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9A8E6B00A0
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:29:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A22190CEC
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:29:28 +0000 (UTC)
X-FDA: 84795288816.22.FB86472
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id AD332C000E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:29:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GHrHvjki;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779460166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DWn7bS7xQYbcdkvCx3KblzCl0rPLM9h158TSPP8Tg54=;
	b=nkGHaSZ1pBDSDr6SOJMDKwGTB+Vbm2EUoPL9e/sQv+hxP2pH4CkoUA9orHITUocXwTD8YC
	b7q//PnSin74aePI7K2VOVUdDQEYaddzmjTJbEuqKzKIh8awkKDS+PASf/4FV7cKa3Nlqd
	MQm0nLprJVdkIBux61l2qUTbWWuhgpM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GHrHvjki;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779460166; a=rsa-sha256;
	cv=none;
	b=ZIDPLxD3f2UAbokXgYxHtv9ymhCCNneQlo7NhXqR3rTPO4D8wWFiZfVTOztaLlYyn7LC7n
	oAnEGCJAeDEFEVDSiwBn0nTfB2od0lsqkCtJiULWHUKAEbc8YjZ9rU8QOiVMcfAJ8NvaQA
	FWPqcBSYyUzhNLVf0KeoECnYS8g+LcY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1ECCA60138;
	Fri, 22 May 2026 14:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640F91F000E9;
	Fri, 22 May 2026 14:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779460165;
	bh=DWn7bS7xQYbcdkvCx3KblzCl0rPLM9h158TSPP8Tg54=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GHrHvjkiOmkRZM9ixd9uwv8EEG1pY16+fep9NZw9mKUJtjMy/tJTqexCiVmlyqVpJ
	 hKUiXINzAjfxl3vmuWJb0IJBtAREvJBZMMXWWE5kdkFN2Qf1rNCXKHBrXMr100Z4jF
	 WcXHxSJ0n/HBPwl81gvcqZEvs2oE8WX7utBEuaoS7WC4frd94zrZS/fx/32cdrgxrv
	 GuWhtBdBtWA/iO5lXji/YY/QHWjfG+8IzUFxTXGTA4VQtCB26+4ioRue6iCg6NINNu
	 PgKehxzIO5MSYAESXCTinNAkVyU1+BMerH7EaDc7+/MjTQQJ6pWziQOb8Nl6Q9pmn+
	 TcmtcRTs6QTlQ==
Date: Fri, 22 May 2026 15:29:21 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: mm/mprotect.c:700:43: sparse: sparse: cast to non-scalar
Message-ID: <ahBoIhjy7tCbwjIA@lucifer>
References: <202605161217.1mPJ49Gv-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202605161217.1mPJ49Gv-lkp@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AD332C000E
X-Stat-Signature: wb9yd17x7x8oi97jutxceecuf8gh1dna
X-HE-Tag: 1779460166-729226
X-HE-Meta: U2FsdGVkX18m3+QX2LWdUZb3BrHBZ8rsfVJ2uT5ryqFPVdUEcZVArSKaMuvMEH12/pDGUvObstAreoh+kpEDfGsonPposZadfHXGhxImPQmhX1Gl1X5lQvQaAcK8+oPJ/e9Yxg0kJXtR9K6VQjIr6YSsTFfmtT1pgbQmSQ2pDP78JK1W/8Y28freD6WRhPiqn+pZON35Qje/+EtbitKzXU/xY8qid5RlNEYWwegg9zbmY2fbWFgyIbPjuNgGdXpjVZb3GqABr1sG1sMSVQkkOeDj4iz6cIuyb3/du+aNChdU64YcOqHEwXX1pnEJFoCbdpi8weNVv3QjxknRir5UJH00qINLXXic7EmLIDmmvlq72jq1auq5F6A8m949UjwwSxdxEkF2FolQxVRH7E8OIdGXeVDpyRvIZYnUFeZHcOqZW0UU/fWadxQeuQE3X79h2u4lCMwJfNZ8ul81mLPBnuVSw4DpXo7I1cce3DWSl8rhqHbjLl3ZVe1QyVVpjA12FURpTwcitTcw8CCkwB18yVjuleT+lPt1ZQa752JB4eF5/ZOOwgnmPOrAR5bhFYab7zCmO9TaecBDpm30etelHQajdPsMBO65tiY9yGxe7AimtEMurKjMPOaTvOzRyrCkYZH60xe9InSuOqfjSC6D0a0srJGslFsdopxe1hANw1vAfROPAByFgz4voUj54DNjgcCcSWgG8ZgPL8ppUfXPLIocJm4u2AXtykiz6xNK7ro7QLsNDFPfh5uSsCJL3k1wD3z7GC4ZknwGSvmjCngq9huf6P0G8ob31RutJTBIZi6o2sgPqdcHTDbZ1mtqBrSfJ9mlhgM/EQzDIyx5YPBfyEZN6r82OCkht5c+EKA0ofHNp1zbNt/B1JPG3gqvFJqVtW7W/2JcLPnjcfQIviA7C+1DQChTu6wJ9OfDj34E1U+VlRqZ0jGyFGD+CTFb49zbUUCQVw2wOdGMO77jDsV
 s00qUIoG
 ykCCrGmOYbgXaCNXWeHg34ITpEUYrUThCJN+ZDbsfQvyUegfAWM4VW/h2hypxkQB7xBfOjLlQwVXB7VIsBFQmxX+yLVCcK+JAfyPd9FMlvvudim7Hz+khGzDrLx/KfX3gIn9KpdaqJYb58bChbVKqQrH40Zm+6ra+fsCmzMEWRzKeFBErC8zPCw3r9VKTo83lq3ZTgeC7T6WHxyxV9KTxopCAc7ip4zgnvFKkjlxq8ZzRxrGJsRscFoE7EL+mdSkDfX+XbpGtqJUryAIDMSPIpy31w2lW+Pq/fVLgyUyIpkj3BCmGSSRNIyIE6Jwrh1qsQdaHc5QFy0J0aFYZNrT2US1L3YibROd62FmE+Fe/mpvI5YrA6B11PrmYleyaD9uMbDTO0jYrl+23+xrJwdu0wyCYkyjDjgDul+Gm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 16, 2026 at 12:25:57PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   d458a240344c4369bf6f3da203f2779515177738
> commit: 3a6455d56bd7c4cfb1ea35ddae052943065e338e mm: convert do_brk_flags() to use vma_flags_t
> date:   6 weeks ago
> config: alpha-randconfig-r121-20260516 (https://download.01.org/0day-ci/archive/20260516/202605161217.1mPJ49Gv-lkp@intel.com/config)
> compiler: alpha-linux-gcc (GCC) 15.2.0
> sparse: v0.6.5-rc1
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260516/202605161217.1mPJ49Gv-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Fixes: 3a6455d56bd7 ("mm: convert do_brk_flags() to use vma_flags_t")
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202605161217.1mPJ49Gv-lkp@intel.com/
>
> sparse warnings: (new ones prefixed by >>)
> >> mm/mprotect.c:700:43: sparse: sparse: cast to non-scalar
> >> mm/mprotect.c:700:43: sparse: sparse: cast from non-scalar
>    mm/mprotect.c: note: in included file (through include/linux/mm.h, include/linux/pagewalk.h):
>    include/linux/pgtable.h:461:16: sparse: sparse: cast to non-scalar
>    include/linux/pgtable.h:461:16: sparse: sparse: cast from non-scalar
>    include/linux/pgtable.h:461:16: sparse: sparse: cast to non-scalar
>    include/linux/pgtable.h:461:16: sparse: sparse: cast from non-scalar
>    include/linux/pgtable.h:461:16: sparse: sparse: cast to non-scalar
>    include/linux/pgtable.h:461:16: sparse: sparse: cast from non-scalar
>    include/linux/pgtable.h:461:16: sparse: sparse: cast to non-scalar
>    include/linux/pgtable.h:461:16: sparse: sparse: cast from non-scalar
>    include/linux/pgtable.h:475:16: sparse: sparse: cast to non-scalar
>    include/linux/pgtable.h:475:16: sparse: sparse: cast from non-scalar
>    include/linux/pgtable.h:468:16: sparse: sparse: cast to non-scalar
>    include/linux/pgtable.h:468:16: sparse: sparse: cast from non-scalar
>    include/linux/pgtable.h:461:16: sparse: sparse: cast to non-scalar
>    include/linux/pgtable.h:461:16: sparse: sparse: cast from non-scalar
>    include/linux/pgtable.h:461:16: sparse: sparse: cast to non-scalar
>    include/linux/pgtable.h:461:16: sparse: sparse: cast from non-scalar
>
> vim +700 mm/mprotect.c
>
>    693
>    694	int
>    695	mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
>    696		       struct vm_area_struct *vma, struct vm_area_struct **pprev,
>    697		       unsigned long start, unsigned long end, vm_flags_t newflags)
>    698	{
>    699		struct mm_struct *mm = vma->vm_mm;
>  > 700		const vma_flags_t old_vma_flags = READ_ONCE(vma->flags);

I think we can tolerate this, presumably because we're READ_ONCE()'ing, I don't
think it's helpful necessarily to cast away the sparse stuff here.

Cheers, Lorenzo

>    701		vma_flags_t new_vma_flags = legacy_to_vma_flags(newflags);
>    702		long nrpages = (end - start) >> PAGE_SHIFT;
>    703		unsigned int mm_cp_flags = 0;
>    704		unsigned long charged = 0;
>    705		int error;
>    706
>    707		if (vma_is_sealed(vma))
>    708			return -EPERM;
>    709
>    710		if (vma_flags_same_pair(&old_vma_flags, &new_vma_flags)) {
>    711			*pprev = vma;
>    712			return 0;
>    713		}
>    714
>    715		/*
>    716		 * Do PROT_NONE PFN permission checks here when we can still
>    717		 * bail out without undoing a lot of state. This is a rather
>    718		 * uncommon case, so doesn't need to be very optimized.
>    719		 */
>    720		if (arch_has_pfn_modify_check() &&
>    721		    vma_flags_test_any(&old_vma_flags, VMA_PFNMAP_BIT,
>    722				       VMA_MIXEDMAP_BIT) &&
>    723		    !vma_flags_test_any_mask(&new_vma_flags, VMA_ACCESS_FLAGS)) {
>    724			pgprot_t new_pgprot = vm_get_page_prot(newflags);
>    725
>    726			error = walk_page_range(current->mm, start, end,
>    727					&prot_none_walk_ops, &new_pgprot);
>    728			if (error)
>    729				return error;
>    730		}
>    731
>    732		/*
>    733		 * If we make a private mapping writable we increase our commit;
>    734		 * but (without finer accounting) cannot reduce our commit if we
>    735		 * make it unwritable again except in the anonymous case where no
>    736		 * anon_vma has yet to be assigned.
>    737		 *
>    738		 * hugetlb mapping were accounted for even if read-only so there is
>    739		 * no need to account for them here.
>    740		 */
>    741		if (vma_flags_test(&new_vma_flags, VMA_WRITE_BIT)) {
>    742			/* Check space limits when area turns into data. */
>    743			if (!may_expand_vm(mm, &new_vma_flags, nrpages) &&
>    744			    may_expand_vm(mm, &old_vma_flags, nrpages))
>    745				return -ENOMEM;
>    746			if (!vma_flags_test_any(&old_vma_flags,
>    747					VMA_ACCOUNT_BIT, VMA_WRITE_BIT, VMA_HUGETLB_BIT,
>    748					VMA_SHARED_BIT, VMA_NORESERVE_BIT)) {
>    749				charged = nrpages;
>    750				if (security_vm_enough_memory_mm(mm, charged))
>    751					return -ENOMEM;
>    752				vma_flags_set(&new_vma_flags, VMA_ACCOUNT_BIT);
>    753			}
>    754		} else if (vma_flags_test(&old_vma_flags, VMA_ACCOUNT_BIT) &&
>    755			   vma_is_anonymous(vma) && !vma->anon_vma) {
>    756			vma_flags_clear(&new_vma_flags, VMA_ACCOUNT_BIT);
>    757		}
>    758
>    759		newflags = vma_flags_to_legacy(new_vma_flags);
>    760		vma = vma_modify_flags(vmi, *pprev, vma, start, end, &newflags);
>    761		if (IS_ERR(vma)) {
>    762			error = PTR_ERR(vma);
>    763			goto fail;
>    764		}
>    765		new_vma_flags = legacy_to_vma_flags(newflags);
>    766
>    767		*pprev = vma;
>    768
>    769		/*
>    770		 * vm_flags and vm_page_prot are protected by the mmap_lock
>    771		 * held in write mode.
>    772		 */
>    773		vma_start_write(vma);
>    774		vm_flags_reset_once(vma, newflags);
>    775		if (vma_wants_manual_pte_write_upgrade(vma))
>    776			mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
>    777		vma_set_page_prot(vma);
>    778
>    779		change_protection(tlb, vma, start, end, mm_cp_flags);
>    780
>    781		if (vma_flags_test(&old_vma_flags, VMA_ACCOUNT_BIT) &&
>    782		    !vma_flags_test(&new_vma_flags, VMA_ACCOUNT_BIT))
>    783			vm_unacct_memory(nrpages);
>    784
>    785		/*
>    786		 * Private VM_LOCKED VMA becoming writable: trigger COW to avoid major
>    787		 * fault on access.
>    788		 */
>    789		if (vma_flags_test(&new_vma_flags, VMA_WRITE_BIT)) {
>    790			const vma_flags_t mask =
>    791				vma_flags_and(&old_vma_flags, VMA_WRITE_BIT,
>    792					      VMA_SHARED_BIT, VMA_LOCKED_BIT);
>    793
>    794			if (vma_flags_same(&mask, VMA_LOCKED_BIT))
>    795				populate_vma_page_range(vma, start, end, NULL);
>    796		}
>    797
>    798		vm_stat_account(mm, vma_flags_to_legacy(old_vma_flags), -nrpages);
>    799		vm_stat_account(mm, newflags, nrpages);
>    800		perf_event_mmap(vma);
>    801		return 0;
>    802
>    803	fail:
>    804		vm_unacct_memory(charged);
>    805		return error;
>    806	}
>    807
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

