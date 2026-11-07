Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52EAC606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 23:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U6wL5V0D
Received: by kanga.kvack.org (Postfix)
	id 6DB4C6B05B0; Sat,  7 Nov 2026 18:51:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 674E26B05B1; Sat,  7 Nov 2026 18:51:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 589D96B05B2; Sat,  7 Nov 2026 18:51:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 294996B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 18:51:49 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B16D8A7FC3
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 23:51:48 +0000 (UTC)
X-FDA: 85409973096.02.1D10FDF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1232A180006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 23:51:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U6wL5V0D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794095507;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K0ntOgTxKwfnjgz9ueZ1U0o9Ee+0pV7D2zvWAxAaUHU=;
	b=xsjQnhEqFUgmxHvO5spovVqgqGYVhHxnZUGf48w/NytEZBpfzKj1PXBbAmvtssZUC4R39w
	NzEMb9r++B4WMFbTTqsB4RDMafQeXnbVnEuLQIV3RhB+pech6GG0xjCPwdUjlH1UNCOop5
	Q2pqTz77hMBmzc1Z+2OKt5HhCKZI7Os=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U6wL5V0D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794095507;
	b=ahhj8InbJSReuGK713tTLPAoJ7zXRgZz1WdfOJwXeEDP2jnzRjwFZFsvzcYzxx09isii3G
	Od72j3zs/OoGgr6XfEd4VeoM+2Yqsm8u4YHdP659apXuENmcIbtgnCc5nCW/xSegC7FeKQ
	4Pc6kQmBs0PA7vZVJT7lMS1FEixJtmk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6784761120;
	Sat,  7 Nov 2026 23:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61EF1F0089F;
	Sat,  7 Nov 2026 23:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794095506;
	bh=K0ntOgTxKwfnjgz9ueZ1U0o9Ee+0pV7D2zvWAxAaUHU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U6wL5V0DcCzpAiF5gp97ZStZk5Q6x65MWRq+u1CMrgOsCY0SAxpXXXN8E60zryzrF
	 bOboO6MrG65Vpw7vpejDEvoQkm/st3ffipQFzITKXEiNsfRG6LPbWv3mFTR4BT874J
	 YdpZ4ZtKrdvJcOisGxKStajTTel/6xQKHcEw+TidJ9k4RWTy/IIdO3g8rTCPzS5erp
	 u6grRS8LtRPAssu2U6bCtAsow0dpxY40u/wQA2fRv6OaJc/K1bL/8SPDRhofl605/z
	 N8hc2rN1HLXQARiSIa9NXosgaNKtKml19QjeekOQb91RnvpO5Ksu4vQWUS4jlox1R9
	 T1aJMhkYL0GaQ==
Message-ID: <sashiko-outbox-203403@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] mm/khugepaged: check for empty PTE tables before
 retracting
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?RGF2aWQgSGlsZGVuYnJhbmQgKEFybSk=?= <david@kernel.org>, "Jonathan
 Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Jann Horn" <jannh@google.com>, "Pedro Falcato" <pfalcato@suse.de>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Peter Xu" <peterx@redhat.com>, "Steven Rostedt" <rostedt@goodmis.org>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Zi
 Yan" <ziy@nvidia.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Axel
 Rasmussen" <axelrasmussen@google.com>
Cc: linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org
In-Reply-To: <20261107-b4-uffd_marker_loss-v1-2-82926b22704c@kernel.org>
References: <20261107-b4-uffd_marker_loss-v1-0-82926b22704c@kernel.org>
 <20261107-b4-uffd_marker_loss-v1-2-82926b22704c@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 23:51:44 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1232A180006
X-Stat-Signature: ekk5167oaxjmkkybnhho34shdm6ttusq
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794095506-763132
X-HE-Meta: U2FsdGVkX1/kDEptop+fPkBSIwEBVEJlo7KeSm2HbN6G3kLiy2ySn1z9+sl3nfPzM6hcVl1NZSpXAToPALlBaMZt7RK618YmAzXbjvEqHFCMeDSgNSZHX6MPmbJH/PKG7I9M2PwM+YDPU1xaGcGQlKgquwKDKYXMud3ctAN0eMSPjqCvJIFs5zuFhanRipaITMXm1nswW1eKIT38Hz83q42fG+RN62/A7F6NY4nTXbOAtmTtN6/p0wBaYBbc4SdI20gwpuGAi9KGSJ9s8GNBiKpvSmpbtuyPljPs4KVeg5w/eu8QmceT/aDk7YJWCAUfvdD3Y7Mp9kUCOyoRGBhHX/SauXKkDytA/d/eAq+Fqr0gkeThYlLjDgpQaUonX4n2ee9tSRVeCbzNDcrtolIibUEeWiD2WDLmqFQHmfPP/Co1G+326MWrKygjJCEgcJda69ctOg+dHsbeXLEsnRvkUZrGmejeTl/HZY3cmrlWzQQJ8K9N0faLgHN2AfEdQfDJ7FbQ6yx4SceewCnMkaozvMC9gdMMKNQWufNFY/6ETSRgRiilt1BmkeDcYYjdaDfEqPxM17mveSEuVuFdLr247jec3G6cgY8eWRzzzIzONRXmi4roTI1UVE+/lBhbRECXmXymUQB5ml58j9/AGFZuagMgU0ZHyfAv08bVjMRxUJNRAXQuaQe4rR0zSA0IrpVGU9Cs/G/DRZEZ9JvR9ijslDn21t8Qn7IaAv8DwJsaZCEEs5GzIi8DdhNm7b/PN5XtOufCGOFS3SZiFRTDwfZomJMpB1R/LvOdTFBZq2rYkW1zdLXXz368dcn9iDPocVLqkPABNQpMAKN4WcujkInncvyqcX7vLRvEQhhI0lpgB87Owecsr8X5zW06UgY5mNVnLI/oN8zVbfZVoSVfSikNpI5DmQMr2mOdLW5UiWTg8njsRb8WOk3R+Ex+oGm2kjlKFqGDCAbAqz+LdnKtew2
 QiSfLFTx
 ZZGH2/syxYNAJLvCZZ1oo5C2OcoEf8xOjDzEff2rXvlfO8uU6SIODJKQRIKf27GLTqUlCqjDPsKP2gqPsSwWJ87B3hLihVq+UlVDqVAuiQ6aVDZ4cvKMg9ludPQaknXjK62EsZ2oVf4kzJx3nqF40hC2gST5eBWR+xfl43tlS4HwF2N/u4Qcc2hwdvvlFRIQSHxcIkSrFx6wxvYJ/KTopi/gQCOjNfK4oDaNH9BWU3oZ8gzDU7nvxPMNL2xPnBihRDCQECa7dVvsBGK8rsGkK3q1SOLGBvHe9yY6wxes9MN7FYp5uw4zsGJgtb1LCq6bcb1eJGJBXMcLS5ZLPGFJ5QEz/Y9schBmxeiSxPADjJ2xVYl8UoG02jcopsgsCdMbQ+XnV9tPSjmAeBp9+vpHIF6rgJZYy4SPX1Nj2qcETEiTmcoclrap6rLY+pAOsmXq9lyTOrhfr28kgzJekIFMgaxLZkjNpplr0w5KumFqSbLzuCCjTk6GmwjESWadz2FhDV/di+yLVSXUtpuRxVeIuwFvhBSXKK19SwcYsCrcIIJo4zhBAGu0ru5FG1n3UkQC54oYp+ZMQL6SgF3QP26fwdHLyh3cIVFUjJxpT7EPnwT2FlI/mVsxoYbsTEw3DkfAQHP0n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] mm/khugepaged: race between retract_page_tables() and
  copy_page_range()
- [Medium] mm/khugepaged: retract_page_tables() breaks uffd RWP on file
  and shmem VMAs
--

commit 15ea4d4b6e2586260561871f9acd4c3bff3278ec
Author: David Hildenbrand (Arm) <david@kernel.org>

mm/khugepaged: check for empty PTE tables before retracting

This commit replaces the VMA flag checks in retract_page_tables() with a
scan under the PTE lock to verify that the PTE table is empty before
retracting it.

> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 2a5ee8fc42335..f39ea3d076554 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
[ ... ]
> @@ -2081,48 +2082,6 @@ void collapse_pte_mapped_thp(struct mm_struct *mm,=
 unsigned long addr,
>  	try_collapse_pte_mapped_thp(mm, addr, install_pmd);
>  }
> =20
> -/* Can we retract page tables for this file-backed VMA? */
> -static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)
> -{
> -	/*
> -	 * Check vma->anon_vma to exclude MAP_PRIVATE mappings that
> -	 * got written to. These VMAs are likely not worth removing
> -	 * page tables from, as PMD-mapping is likely to be split later.
> -	 *
> -	 * Can't use vma_has_anon_rmap() here as the VMA may be stabilised
> -	 * by the file rmap lock.
> -	 */
> -	if (READ_ONCE(vma->anon_vma))
> -		return false;
> -
> -	/*
> -	 * When a vma is registered with uffd-wp or RWP, we cannot recycle
> -	 * the page table because there may be pte markers installed.
> -	 * VM_UFFD_RWP ranges similarly rely on per-PTE uffd state
> -	 * and cannot be recycled to a shared PMD. Other vmas can still
> -	 * have the same file mapped hugely, but skip this one: it will
> -	 * always be mapped in small page size for these registrations.
> -	 */
> -	if (userfaultfd_protected(vma))
> -		return false;
> -
> -	/*
> -	 * Preserve guard and poison markers when retracting page tables.
> -	 *
> -	 * These flags are set atomically on marker installation under mmap/VMA
> -	 * read lock, and here we may not hold any VMA or mmap lock at all.
> -	 *
> -	 * This is therefore serialised on the PTE page table lock, which is
> -	 * obtained on marker installation after the flag is set, so this
> -	 * check being performed under this lock excludes races.
> -	 */
> -	if (vma_test_atomic_flag(vma, VMA_MAYBE_GUARD_BIT) ||
> -	    vma_test_atomic_flag(vma, VMA_MAYBE_UFFD_POISON_BIT))
> -		return false;
> -
> -	return true;
> -}
> -
>  static void retract_page_tables(struct address_space *mapping, pgoff_t p=
goff)
>  {
>  	struct vm_area_struct *vma;
> @@ -2133,10 +2092,18 @@ static void retract_page_tables(struct address_sp=
ace *mapping, pgoff_t pgoff)
>  		struct mm_struct *mm;
>  		unsigned long addr;
>  		pmd_t *pmd, pgt_pmd;
> -		spinlock_t *pml;
> -		spinlock_t *ptl;
> +		pte_t *pte;
> +		spinlock_t *pml =3D NULL, *ptl;
>  		bool success =3D false;
> =20
> +		/*
> +		 * Skip private mappings that have been written to: we'll likely
> +		 * split them as soon as we CoW later. Use READ_ONCE() because
> +		 * we are neither holding the VMA lock nor the mmap_lock.
> +		 */
> +		if (READ_ONCE(vma->anon_vma))
> +			continue;

[Severity: Medium]
Can removing the VM_COPY_ON_FORK flag checks here cause retract_page_tables=
()
to race with copy_page_range() during fork()?

In dup_mmap(), the child VMA is linked into mapping->i_mmap and
i_mmap_unlock_write(mapping) is dropped before copy_page_range() runs.
vma_needs_copy() copies page tables not only when vma_has_anon_rmap() is se=
t,
but also when VM_COPY_ON_FORK flags (VM_MAYBE_GUARD, VM_MAYBE_UFFD_POISON,
VM_UFFD_WP, or VM_UFFD_RWP) are set on a file or shmem VMA whose anon_vma is
still NULL.

mm/memory.c:copy_pte_range() {
	/*
	 * copy_pmd_range()'s prior pmd_none_or_clear_bad(src_pmd), and the
	 * error handling here, assume that exclusive mmap_lock on dst and src
	 * protects anon from unexpected THP transitions; with shmem and file
	 * protected by mmap_lock-less collapse skipping areas with an anon rmap
	 * (whereas vma_needs_copy() skips areas without one).  A rework
	 * can remove such assumptions later, but this is good enough for now.
	 */
	dst_pte =3D pte_alloc_map_lock(dst_mm, dst_pmd, addr, &dst_ptl);
	if (!dst_pte) {
		ret =3D -ENOMEM;
		goto out;
	}
}

Because retract_page_tables() no longer skips VMAs with VM_COPY_ON_FORK fla=
gs
set, it can retract the newly allocated empty dst_pmd in the child between
__pte_alloc() and pte_offset_map_lock() (or across cond_resched() before a
non-empty PTE is copied):

CPU0                                      CPU1
dup_mmap()
  mapping_rmap_tree_insert_after(dst_vma, ...)
  i_mmap_unlock_write(mapping)
  copy_page_range(dst_vma, src_vma)
    ...
    copy_pte_range()
      pte_alloc_map_lock(dst_mm, dst_pmd, ...)
        __pte_alloc(dst_mm, dst_pmd)
                                          collapse_file()
                                            retract_page_tables()
                                              pte_table_empty(pte) =3D=3D t=
rue
                                              pmdp_collapse_flush(..., dst_=
pmd)
        pte_offset_map_lock(dst_mm, dst_pmd, ...)
          --> returns NULL
      ret =3D -ENOMEM;  <-- fork() fails spuriously

On the parent side, retracting an empty src_pmd concurrently with
copy_pmd_range() can also clear *src_pmd between pmd_none(*src_pmd) and
pmd_bad(*src_pmd) inside pmd_none_or_clear_bad(src_pmd), triggering a false
pmd_clear_bad() report.

> +
>  		addr =3D vma->vm_start +
>  			((pgoff - vma_start_pgoff(vma)) << PAGE_SHIFT);
>  		if (addr & ~HPAGE_PMD_MASK ||
> @@ -2150,52 +2117,48 @@ static void retract_page_tables(struct address_sp=
ace *mapping, pgoff_t pgoff)
>  		if (collapse_test_exit(mm))
>  			continue;
> =20
> -		if (!file_backed_vma_is_retractable(vma))
> -			continue;
> -
>  		/* PTEs were notified when unmapped; but now for the PMD? */
>  		mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
>  					addr, addr + HPAGE_PMD_SIZE);
>  		mmu_notifier_invalidate_range_start(&range);
> =20
> -		pml =3D pmd_lock(mm, pmd);
[ ... ]
> +		pte =3D pte_offset_map_lock(mm, pmd, addr, &ptl);
> +		if (!pte)
> +			goto unlock;
> =20
>  		/*
> -		 * Huge page lock is still held, so normally the page table must
> -		 * remain empty; and we have already skipped vmas with an anon
> -		 * rmap and userfaultfd_wp() vmas.  But since the mmap_lock is not
> -		 * held, it is still possible for a racing userfaultfd_ioctl() or
> -		 * madvise() to have inserted ptes or markers.  Now that we hold
> -		 * ptlock, repeating the retractable checks protects us from
> -		 * races against the prior checks.
> +		 * The folio lock prevents file faults from modifying the
> +		 * page table, but other things (userfaultfd, CoW, guard
> +		 * markers) could have modified the page table until we lock it
> +		 * and check.
>  		 */
> -		if (likely(file_backed_vma_is_retractable(vma))) {
> -			pgt_pmd =3D pmdp_collapse_flush(vma, addr, pmd);
> -			pmdp_get_lockless_sync();
> -			success =3D true;
> -		}
> +		if (!pte_table_empty(pte))
> +			goto unlock;

[Severity: Medium]
Does checking pte_table_empty() instead of userfaultfd_protected(vma) break
userfaultfd RWP (and WP) on file and shmem VMAs?

Unlike VM_UFFD_WP on write-protected PTEs, try_to_unmap_one() does not
install PTE markers for VM_UFFD_RWP (or for VM_UFFD_WP PTEs that are not
currently write-protected) when collapse_file() unmaps the small folios.
pte_table_empty(pte) is then true and retract_page_tables() clears the PMD =
to
pmd_none, even though try_collapse_pte_mapped_thp() still refuses
userfaultfd_protected(vma).

Once the PMD is pmd_none, the next fault in finish_fault() installs a huge
PMD before checking userfaultfd_armed(vma):

mm/memory.c:finish_fault() {
	if (pmd_none(*vmf->pmd)) {
		if (!needs_fallback && folio_test_pmd_mappable(folio)) {
			ret =3D do_set_pmd(vmf, folio, page);
			if (ret !=3D VM_FAULT_FALLBACK)
				return ret;
		}
    ...
	/* Using per-page fault to maintain the uffd semantics */
	if (unlikely(userfaultfd_armed(vma)) || unlikely(needs_fallback)) {
		nr_pages =3D 1;
}

When userspace later issues UFFDIO_RWPROTECT on that file or shmem VMA,
change_pmd_range() sees pgtable_split_needed() is true and calls
__split_huge_pmd(), which zaps the file huge PMD back to pmd_none without
populating a PTE table (since pgtable_populate_needed() is false for
MM_CP_UFFD_RWP), so RWP protection is lost and subsequent accesses fault the
unprotected huge PMD back in without delivering RWP faults.  Installing a
huge PMD also causes PAGEMAP_SCAN to report all 512 pages as accessed or
written after a single 4KB page fault.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107-b4-uffd_ma=
rker_loss-v1-0-82926b22704c@kernel.org?part=3D2

