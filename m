Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CC5F606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 06:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MaTl1+Ww
Received: by kanga.kvack.org (Postfix)
	id 690F56B05B2; Fri,  6 Nov 2026 01:24:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61AD86B05B3; Fri,  6 Nov 2026 01:24:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E2E46B05B4; Fri,  6 Nov 2026 01:24:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1A8C66B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:24:56 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1BDB3A0299
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 06:24:55 +0000 (UTC)
X-FDA: 85403706150.06.262B03A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2AF9140007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 06:24:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MaTl1+Ww;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793946293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hNhdEdbELbxYnbq7Z+uVlCghlviJuJjsxKDpjppnRdg=;
	b=vUnZIYGSaBvtPMxO2ePYycMVDz/yb69CFy5WI7XPs58YCUmW3BREJveNIJmceoCj7tnqcj
	rva4HNjYIrw1zimDP6bJLqaSDGDicEUzMgrJD19u6nW+MbumrXzzlF6NvK8q9hfD9hMiBb
	M1dWbDIjQEcpK8GLMnLfh6oqw+Z12Q4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MaTl1+Ww;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793946293;
	b=yBKKmWQ2V1Te/9nnANznVQKXh/iGq/RLUx3FfY8xEKwq1EhFnsAxvkNWpqob6ppr/AKm14
	jXgYvYomXp7aKvm6NO+Aab2m4sfRk9PjJk+qrVEBlHBGzejatBzppoo0s/QBUNmk9gvdXn
	9tVPT+dDvTy5cxdU8kZkn6gorX4MLQ4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7FAB6411EA
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 06:24:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F501F008A4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 06:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793946291;
	bh=hNhdEdbELbxYnbq7Z+uVlCghlviJuJjsxKDpjppnRdg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MaTl1+WwrS0vWZrUPOnAwM4Ajmv3xOdg4V7MhEl4HmgKLX+oOS9WwqCllQDH/js2y
	 HGQiDNgggHLFyvmSfagsvVVlZeqz7MGStzuSzVHOeoE4OjQS31fiSo8diRFsz4UwF9
	 3sK3J7h1MVgJvXGM2RLnr4mNFBxTlxiM39XsXlsUk04ReEuK/cdn5cGcYESSilupT/
	 vMVUxmzSP50WgV3sSQqgER0SCpm8zHKcmpGIfc73jXkO5LmxE3XYlr8Ufet+7Ar5rh
	 WbmFi4KDxVudDG0dYjbSybAIrfUcWEBRD/Wq94yzcvMyph5Gjvv/LkbRB0ChTn/5ZE
	 OtgX3BjOTVsSQ==
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-91e7fc8265aso4422456d6.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 22:24:51 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBz5bWJtqF+HFRAsD2zvY7zQZKwou4C4+Cg3dVraihwiusONDw1fJlphk/zlYT97vW8ouZAZGKNGkA==@kvack.org
X-Gm-Message-State: APuU4Z+fZKtnnh+7QkHzmLomuT+UIJl/kfFkuSYh4rLMV28O7uJzVXH0
	u0qGXkzEQZsUnirE/kTZa2WYaEBWPvd6WrkiWwddfN6AeWXtLF10NWqkq21l5UoRZRhPBW8PxDH
	bmLioVTBLTpJDh2e+1JP/hzQdwNeK5Ss=
X-Received: by 2002:a05:620a:1a03:b0:93f:707f:28d2 with SMTP id
 af79cd13be357-945f344cc28mr233095685a.26.1793946290734; Thu, 05 Nov 2026
 22:24:50 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <affd6da4e8d0de1424a4e0b3bafcd1324dfb6c97.1793847060.git.baolin.wang@linux.alibaba.com>
 <20261105045406.39871-1-lance.yang@linux.dev> <0ddaf336-7cb7-4e83-af2c-f60d23f7aafd@linux.dev>
 <f7bd740e-1328-473e-96f5-89658a08d514@linux.alibaba.com>
In-Reply-To: <f7bd740e-1328-473e-96f5-89658a08d514@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 6 Nov 2026 14:24:39 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zHtv7hBCaW=wdfiM7yA4OJS7pcFomSo22bEzWHizYAXQ@mail.gmail.com>
X-Gm-Features: AclHuK8sH4jIu7KkqgNySV7lEo_7cZEAX1FymEzj8OWRWHpCtROXagBOAzb0Q08
Message-ID: <CAGsJ_4zHtv7hBCaW=wdfiM7yA4OJS7pcFomSo22bEzWHizYAXQ@mail.gmail.com>
Subject: Re: [PATCH] mm: synchronize with PTE table reclaim for all folio sizes
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org, david@kernel.org, 
	ljs@kernel.org, riel@surriel.com, liam@infradead.org, vbabka@kernel.org, 
	harry@kernel.org, jannh@google.com, qi.zheng@linux.dev, pfalcato@suse.de, 
	ayushr@modal.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4qqtrjikgntdwxei9freugn479gkqw6a
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2AF9140007
X-HE-Tag: 1793946293-406461
X-HE-Meta: U2FsdGVkX186HeXKLtvNAtWHc+umipfC3RSMFVPwurVQpsY1Y07xnhNEozKgnR5HATkli/cQPgh1U5eenBeV5+AQ224CzoO0//IMVS+vmJ0/ZJRWQqFQsKouag+BkVbcUC/1wIvtxI9qM/Oxw4QKJbOVTF/WW6WP7SYCivgqIZj6H+2w/n9mSiC7x+5fFzBHQV0vrPTn9q2LVHk1/NC1aYW78HNBmkZ0dGKEGTlgSeRJHP9haIkntDr/w2oOvnsJ3w94NMsFI9KDD1J9KbdSfNmUXriz+46h8fz45RfkmPVUbXPws3NMat+LgQecfe9soz6SgCC9apXUVie9lsOoTyycbk/Y006S4nktZUbf6xIflKZ7YtH17YLv/tUCjNp0KpF3msYsi8NRUGVVGfM+6OlgEaIOkDJ+JSq1GUW60woPGIeHfbaxrURo4IaZYJ/InxRp7hhEVYnAKSGMuNc1VXb9ezbvVyo9YfI0J0lk4dmFt/Ez3zzJh+1UzcZoGL8ZqGhvWt3xshGp2+dYXFtq7pzufxY8mXqVpgIcG8ulDYjbaLZzljF2aJCMFCwEdcM+Bq2Rqgkf4NY0EGc/n1rEaeEyd/pVO98PxvVv+ljNv5oUtEKPem9d5yUjBq7HrtrwesuuAnqzVZMWKnDYdM3QtSJfOAyfqeTsV3GHafSO8EYo4JemZL7slF5ZweRWcTq8TUdK1zWA14Dvh0ys9wv8rZfsAHA4qtAKL9sLIrwlnKngBEMtgaBPw46szyPAL0yULqz2gypsPUky+OAR/znrgCMtzn30fImzMqIxYfeSI0rY/pBNp2EC19dSV2wDd1kbYFOklYM0aOeCoyjx5iIx4hQLWmFoyxjvqUr75nvzBn2TJgWkgHLIaRmzynKVNwixTw3fMnM+Cr3v4MyIrfo5dfPz734pZ3p4cD4OzlloLzvmgq6NjcsWgd1tPoyVlgZfkhAiQAKAn33VdLmG/7y
 n1CyTBbF
 1aM/NBIWKB8O9ab+KttZYCUw3zULSKKHqxTa6rSQSZtG+GSx/5usmL1imdYHFkd3nDtjwmJ0jqXz3/gMeBmOWYq4Z022i77YCQgPHufYhD1F32VuRyXJLg3GkhufNlRHIZ0Y5/H6fVAMlx7/UNLp4O6Kxi8lmXtowOYpToo6VHyVm12MXZApEQiLhNGOAggavUNyMlcv4mCkfjZ193rETWgPK2R+ebJJBg6qO6pgkGm2WltmnPETq5GNbGG37Jz80+860KTTN1UnUpfC5t5rLvP5ulv0VYiXO/FiRyiCl4B1Y4DLG4bvSPb8TbrHqz+g+Xk1H9ntGvY6bTS8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 5:00=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> CC Barry, who added the TTU_SYNC in shrink_folio_list().
>
> On 11/5/26 1:48 PM, Lance Yang wrote:
> >
> >
> > On 2026/11/5 12:54, Lance Yang wrote:
> >>
> >> On Thu, Nov 05, 2026 at 10:56:28AM +0800, Baolin Wang wrote:
> >>> Similar to commit 243cf1f67b36 ("mm: memory: fix truncation removing
> >>> mapped
> >>> folios"), the '!pmd_present()' check in page_vma_mapped_walk() can
> >>> also race
> >>> with concurrent page table reclamation via zap_empty_pte_table().
> >>
> >> Good catch!
> >>
> >>> page_vma_mapped_walk() is used by many functions including
> >>> try_to_unmap(),
> >>> try_to_migrate(), folio_mkclean(), pfn_mkclean_range(),
> >>> remove_migration_ptes(),
> >>> page_mapped_in_vma(), and mapping_wrprotect_range(). Except for
> >>> try_to_unmap()
> >>> and try_to_migrate(), the other callers do not perform post-walk
> >>> accounting
> >>> checks, so the race has no observable impact on them.
> >>>
> >>> For migration, the race can cause unnecessary retries. For reclaim vi=
a
> >>> try_to_unmap(), the race can cause failure to reclaim a folio that is=
 in
> >>> fact already unmapped (as shown below), which may lead to unexpected =
OOM
> >>> or increased refaults.
> >>>
> >>> CPU 0 (reclaim)                      CPU 1 (MADV_DONTNEED)
> >>> --------------------------------    --------------------------------
> >>> folio_lock(F)
> >>> try_to_unmap(F, TTU_SYNC)
> >>>                                     zap_pte_range(full PMD range)
> >>>                                       spin_lock(ptl)
> >>>                                       clear PTEs
> >>>                                       zap_empty_pte_table()
> >>>                                         spin_trylock(pml)
> >>>                                         pmd_clear()
> >>>                                         spin_unlock(pml)
> >>>
> >>>   page_vma_mapped_walk()
> >>>     observe !pmd_present(pmde)
> >>>     nr_pages < HPAGE_PMD_NR
> >>>     skip synchronization
> >>>     return false
> >>>
> >>> try_to_unmap() returns
> >>> folio_mapped(F) =3D=3D true
> >>> nr_unmap_fail +=3D folio_nr_pages(F)
> >>>                                     tlb_flush_mmu_tlbonly()
> >>>                                     tlb_flush_rmaps()
> >>>                                       remove F's rmaps
> >>>                                     spin_unlock(ptl)
> >>>
> >>> Commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped
> >>> folios")
> >>> has already moved the PMD clear operation (via zap_empty_pte_table())=
 to
> >>> after tlb_flush_rmaps(). Similarly, page_vma_mapped_walk() also needs=
 to
> >>> use sync_with_folio_pmd_zap() to synchronize and avoid memory orderin=
g
> >>> issues on weakly ordered CPUs.
> >>>
> >>> Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in
> >>> madvise(MADV_DONTNEED)")
> >>> Cc: stable@vger.kernel.org
> >>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> >>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> >>> ---
> >>> mm/page_vma_mapped.c | 5 +----
> >>> 1 file changed, 1 insertion(+), 4 deletions(-)
> >>>
> >>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> >>> index e6b6170c2f4f..8797467b6f0c 100644
> >>> --- a/mm/page_vma_mapped.c
> >>> +++ b/mm/page_vma_mapped.c
> >>> @@ -293,10 +293,7 @@ bool page_vma_mapped_walk(struct
> >>> page_vma_mapped_walk *pvmw)
> >>>             spin_unlock(pvmw->ptl);
> >>>             pvmw->ptl =3D NULL;
> >>>         } else if (!pmd_present(pmde)) {
> >>> -            if ((pvmw->flags & PVMW_SYNC) &&
> >>> -                thp_vma_suitable_order(vma, pvmw->address,
> >>> -                           PMD_ORDER) &&
> >>> -                (pvmw->nr_pages >=3D HPAGE_PMD_NR))
> >>> +            if (pvmw->flags & PVMW_SYNC)
> >>
> >> Right. Whether the folio can be PMD-mapped doesn't tell us whether its
> >> PTE table can be reclaimed, so those extra checks can skip
> >> synchronization
> >> that the caller explicitly asked for ;)
> >
> > Ouch ... one thing I missed ... what about order-0 reclaim?
> >
> > shrink_folio_list() only sets TTU_SYNC for large folio, so can't we sti=
ll
> > hit the same race there?
>
> Thanks Lance. But this matches the purpose of the TTU_SYNC flag, which
> is used to avoid racy checks with PVMW_SYNC. If no TTU_SYNC flag is set,
> it means the caller can tolerate some racy checks.
>
> For this case, I think we should set TTU_SYNC unconditionally in
> shrink_folio_list(). Barry, what do you think?

Baolin, thanks for reaching out to me. I added that flag
mainly for large folios.

I observed cases where PTEs for large folios are partially
cleared during certain transition states, for example, when
PTEs are cleared before being modified:

pte =3D ptep_get_and_clear();
pte modification;
set_pte_at();

In such cases, page_vma_mapped_walk() skips the empty
entries and starts from the next valid one.

This may result in partially unmapping PTEs for large folios
and trigger unexpected folio splits. At the time, I was
particularly concerned about unnecessary folio splitting,
so my focus was mainly on large folios.

However, I also noticed that a similar race can occur with
small folios. In that case, the folio may simply remain
unreclaimed by the reclamation path.

However, my main concern at the time was avoiding
unnecessary folio splits.

Your new race also seems to amplify the same situation.
However, I don't think this problem necessarily depends on
the commit you mentioned. It has been around for a long time.

If the concern is reclaim failure, I agree that there is no
fundamental difference between large folios and small folios.

Best,
Barry

