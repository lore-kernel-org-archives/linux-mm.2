Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C957606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 04:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nhlUR+Lx
Received: by kanga.kvack.org (Postfix)
	id 2E2476B00EF; Mon, 16 Nov 2026 23:54:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 292C46B05B0; Mon, 16 Nov 2026 23:54:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A9616B05B3; Mon, 16 Nov 2026 23:54:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E5A3F6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:54:37 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C250802FB
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:54:37 +0000 (UTC)
X-FDA: 85443395394.06.9CCA8F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6BBDFC0009
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:54:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nhlUR+Lx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794891275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9jwU+jRDguVi89EfWTfk/SuDfHVWfiWUZP/2wYDxr2I=;
	b=7YI/zHO7qsv7XqBX90UzcODFR2DUHymDsjT3cZhM/nehY8YK0grgm+jYGDw3F3aJvjf7dy
	nLrmB0GlJGLHRVRfGj78iyLUJRunjW7NHw+A+WMA5BAZRjB4b0/z60kTI8kBDAGgVUlqKK
	63OtusPFJZMDX/9FKrd/oNxnKE3oaTA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nhlUR+Lx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794891275;
	b=yGpoWiinWuRGjscYrsrBmwpwB75nDAARdAv+u/BNdjkE2UmkV9SQnUkewg6kiilEtMFE8h
	mbLdLo7PPth2B4DGKKxzMLXvLuUhnSIZbqhylwmKLpFz2mBvZmj40mQJHAMe+VCM5lJU/Z
	REWFFmrYH6KRkPYYPlwt2vppSOePn3g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B39BC455AF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88CB11F000D1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794891274;
	bh=9jwU+jRDguVi89EfWTfk/SuDfHVWfiWUZP/2wYDxr2I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=nhlUR+LxlNEQ5p5tQTA/Q2OEkP0Q14VWlqWpe2q8D3VSDoEE/LMIsWBdX2nEle4BI
	 2jLevCN0qWKf0HESY3GJPoNNLT52jkQX613YGnL1lklBPfC4apdkDzIYDXK7l8CK82
	 q7Bu3M+ouun926ICrtA6v5NzCPyWuOPi7FUy1GBG9qqaQEh8h3nMB3raFKuQjCJBca
	 DTebu1Ramj5WD3cu/6ZJ2SRHFVjaX3iPOvgXlbvoTFOMTjCtng5BY/WjqRCDe9Pfuf
	 WPGmJr2VmymOPLpDDqpV80dI7ZKNh7+G3VJqBOgWK7kLL3wCWcemEF7myKSlSO7cdQ
	 iEwnuYtw+797g==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-94962d80d34so190776885a.2
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:54:34 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFR8AnO6aqWZ+lXLP5BtFUeor25aTHkfoKFTztStsLZRO45964DF6Mrs0vWErM49rlKyDb6FCdEGw==@kvack.org
X-Gm-Message-State: APuU4Z9zVW6VopNJxIK11EAnv7DN7siwsLWx39TgQADQjbwJGGPuzpSy
	0kM7B4q94yPGVrhjZJ3+jQ3xx5dJyblgDbVP1jn1IAHjUJtra1nfUnXA4Doaf7ErLBFyLiEoj7r
	inaVVMCC/Y6r73GtcjTF6hEDPlbukj0U=
X-Received: by 2002:a05:620a:44c2:b0:943:f301:49b9 with SMTP id
 af79cd13be357-9494bc2b238mr2017557485a.53.1794891273791; Mon, 16 Nov 2026
 20:54:33 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <71980310d9bf1bf9733ea0e4b772635e1b2bc5c5.1794886401.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <71980310d9bf1bf9733ea0e4b772635e1b2bc5c5.1794886401.git.baolin.wang@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 17 Nov 2026 12:54:21 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wY2r=jyR64Zrx1+8ddq3PMG=k5tsdoqEHXD6oBxEF1pQ@mail.gmail.com>
X-Gm-Features: AclHuK8-OTyMITBBm6lumknloZRwvUS8D7rYd577xanULi7RlADzwuMxlOmI7lg
Message-ID: <CAGsJ_4wY2r=jyR64Zrx1+8ddq3PMG=k5tsdoqEHXD6oBxEF1pQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm: synchronize with PTE table reclaim for all folio sizes
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org, 
	jannh@google.com, lance.yang@linux.dev, qi.zheng@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6BBDFC0009
X-Stat-Signature: t5ax4goms361c7tp51hpf7y7u89u54yj
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794891275-955326
X-HE-Meta: U2FsdGVkX19xrxTtpG3rZcjpYVGGHxYv61qRn7pQtH2nFm6KHO7G2Jvi7ttQRaX3j6VWyvkvJSv/A49GFeWvl++S+uQu6yc+fKPuKoCVFUN7iB8Sz+SnM4Tc0NXzreE8xYmsxG4GHlyZIeKbcXtx+Dmr7UFlwIkE94eNGupwQt4Zr/L0XhQD/Suejc2mG9rlL+exHysQn+CA1bUh4SB5gij+MKuNv9u/wR1UW7y/ab/BYtuCUa3KO/lHwmVcvNkKl9HKImA67IJVMz84y8M7GQNZpAEAc+hiu2wIbpmFRwgCLRcDBEO9J0Ur8oECODZSQvGzNaAEUi87XFfMGQKZ3SotZeCzqCd9CQzHC9IRYfgPB2yIzgi+9QyIxNu07h0xijwNt4YNY91yb1kynuLwmrX11qE02bYU1pP/6fJ8Gl6w1Q+qi1tpRtMUO05QzqTxQoGoKDZ/27Zf+J9e2B/TP9PKQ+PBbfadKxMs0K50Mu30c/Sqndi35YVvSwc+dPFXmOxP8JD23uUVyBggCLulz6XxLFvI7JjD19kJE1aZTdPswNUKX7ktvgSVh/3Jx9YOEv88lsJnR1KzzSzaPeRr8EZ3xTSqHR81KUejY2sOf3VZaXozkvL6/0T3eu/K11EDI4U7jeXEm+U9M+xLUeOSPnpfUWyNHvUetPt0D+3CoITULuC6rCJxOvSo2czRgA2kRQjQ7qGx9x7lKqQvioakreUBhx0/QvT6H27J2DmalV0LEraIL4cQGsCK2fhVVsUG2282METDXpE34JGfR7rtoJY4CiRKaLXJfNWMGXPWP7TgFm/y+wp3Cow80KVehJmfjWNY7Q2TrTUa8jasKHemIAPK+qh8OEO2vgItBz2RoanYXzfehRlnDMS9XMxwQ1tBdoM0UOu2mBXwzHaTdr0CkRJCqaXMk4Y3Q4Tn88Htdd3OsLphMGkjxhoQkebz2NZCur7oX2oOAMZzgDFcgbF
 GwxRx93H
 UgYMvWYtXEh1Jg9yofhwqUO2s4j1IQctb3manpRwB9sSJ2AfObx3yDfUS6HL7C288Qr2gm0F0RzTLirPoMTW2KB7Tk2T1RNpdYiHS5D6Tq50LS1wAeYtyXc6UdwGhHPVtaRZ/Rio8d7OZZ4MmPe5lFjv7yEvwKQH5dT3g/2XhBqiKkPWsia2ugXxUJ6BMrF5iUoN2xcpyzu22gnVWdqWPi8DY3vQ0sY32ZcasjaTDvdRr1rq6iydCY6BkF5TfSdNa2riqogrdaJqDx7tWQ2Pb40WFhC9DnqJEo6feNoPHc6jpMD06NjwofgTROd0L15st3J/sbC1HKreInEs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 11:40=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> Similar to commit 243cf1f67b36 ("mm: memory: fix truncation removing mapp=
ed
> folios"), the '!pmd_present()' check in page_vma_mapped_walk() can also r=
ace
> with concurrent page table reclamation via zap_empty_pte_table().
>
> page_vma_mapped_walk() is used by many functions including try_to_unmap()=
,
> try_to_migrate(), folio_mkclean(), pfn_mkclean_range(), remove_migration_=
ptes(),
> page_mapped_in_vma(), and mapping_wrprotect_range(). Except for try_to_un=
map()
> and try_to_migrate(), the other callers do not perform post-walk accounti=
ng
> checks, so the race has no observable impact on them.
>
> For migration, the race can cause unnecessary retries. For reclaim via
> try_to_unmap(), the race can cause failure to reclaim a folio that is in
> fact already unmapped (as shown below), which may cause cold/hot inversio=
n
> (e.g., in MGLRU) and increase refaults. In extreme cases, failing to
> reclaim unmapped large folios could even cause OOM in theory.
>
> CPU 0 (reclaim)                      CPU 1 (MADV_DONTNEED)
> --------------------------------    --------------------------------
> folio_lock(F)
> try_to_unmap(F, TTU_SYNC)
>                                     zap_pte_range(full PMD range)
>                                       spin_lock(ptl)
>                                       clear PTEs
>                                       zap_empty_pte_table()
>                                         spin_trylock(pml)
>                                         pmd_clear()
>                                         spin_unlock(pml)
>
>   page_vma_mapped_walk()
>     observe !pmd_present(pmde)
>     nr_pages < HPAGE_PMD_NR
>     skip synchronization
>     return false
>
> try_to_unmap() returns
> folio_mapped(F) =3D=3D true
> nr_unmap_fail +=3D folio_nr_pages(F)
>                                     tlb_flush_mmu_tlbonly()
>                                     tlb_flush_rmaps()
>                                       remove F's rmaps
>                                     spin_unlock(ptl)
>
> Commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped folios")
> has already moved the PMD clear operation (via zap_empty_pte_table()) to
> after tlb_flush_rmaps(). Similarly, page_vma_mapped_walk() also needs to
> use sync_with_folio_pmd_zap() to synchronize and avoid memory ordering
> issues on weakly ordered CPUs.
>
> Regarding performance, evaluated the impact on try_to_unmap(). Mapped a f=
ile
> to generate clean large folios, then used MADV_PAGEOUT to reclaim 1G of m=
apped
> clean large folios, repeated 5 times, with no measurable performance impa=
ct.
> Before: 16.031 ms over 5 loops
> After: 16.303 ms over 5 loops
>
> While the race scenario described in the patch may theoretically affect
> performance, the actual impact in real workloads is likely limited I thin=
k.
> Anyway, will use memory barriers to sync for non PMD-sized folios in a
> follow-up.
>
> Lance also reported the possible racy check for small folios[1]. However,
> whether to set TTU_SYNC for small folios should be done in a separate pat=
ch
> (this is a pre-existing issue) with proper measurement (though it may be
> hard to measure the actual impact).
>
> [1] https://lore.kernel.org/all/0ddaf336-7cb7-4e83-af2c-f60d23f7aafd@linu=
x.dev/
> Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV=
_DONTNEED)")
> Cc: stable@vger.kernel.org
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>

Reviewed-by: Barry Song <baohua@kernel.org>

I agree we should start by respecting PVMW_SYNC in all cases,
although there are still some open questions to address.
Whether we should extend SYNC to more folios is a separate question.

