Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F8D0CDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 19:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC8586B0088; Wed, 24 Jun 2026 15:24:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D52CE6B008A; Wed, 24 Jun 2026 15:24:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1C9F6B008C; Wed, 24 Jun 2026 15:24:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B4556B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:24:48 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D59758DF3F
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:24:47 +0000 (UTC)
X-FDA: 84915783414.05.993BAA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id E050A100003
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:24:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aDbyk8rM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782329086;
	b=LyNqh2Eesd2H+qMpTCvkqV172fDJCBfMzqAggyTvvoRFXHqLzLaYS/PFXh7NMV4INcJuhc
	fU41u5qI/k5/TLVfwSh7ksF00aFCA/CsxWXIr4v4TNGaTcN672BJysV7TkM1iUC96it/NQ
	zh2pnz8L5lPb/SanQ1/cnaslKo0/DlY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782329086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d27DgNQsN+CsnP9Zk8I5Mp+avnswqCUuCjEURt6x23c=;
	b=Rq0oS9CtVzOblCHGNCpXYOuHnbCaFF7HVv5kIFabqDi8eVMsBNXhEZIutS8lQ+Sxprlqwq
	2CMMVI9YBRpq2kj16MCi5LXK6wIRF0rlQNFTXUqLD6PlT+K7WGQNq9jf7ibpeNWckr0IIe
	ap+fHPW3CsTbKdmh7TPBs+ZR8uM/Koc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aDbyk8rM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 10FE04174B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:24:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BCB1F00AC4
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782329084;
	bh=d27DgNQsN+CsnP9Zk8I5Mp+avnswqCUuCjEURt6x23c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=aDbyk8rMtarmceGCbNi6zD0fVVdav3ub46yYMunT0oBkkKKteB96Nmz2iVYyu8yPe
	 EWW30oE0JRoxcOK4eLI+ljLIA/yMQmLMHxUFHVb77jq+Z2UIh8+Gv33FHaTzGg7fKA
	 RRYyE59uU++QzkxiG5r1Qw92XJzWQY2YIhx5PoerO/D+0545WTIfY9DkPYEJEKlUFh
	 /R+dWgKaBfRaH0jai+DfGlCMgnyl0/yQSpBvnGj/zNVLOdBgpfwVLqkzFlVm75+98Q
	 bYNYubR6E+pH7l9w+8H5hLGyCW3cp+BbRKEfjbxJ2e4hMk57rMwnTqDAUwuIXCk2hj
	 EDJ6fJ9auv/6w==
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8de88d06509so2188526d6.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:24:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ro5havKizgOkfH4h362Emx9iGnqvBVPsyrWTPqZIWw35x2nHK940Yr1iC+DgMHleauGhp7SSI+0gQ==@kvack.org
X-Gm-Message-State: AOJu0Yxb0wK98AXpVh1zfc8FPmc1EFIzn3vf3G/vYT//+8Ab3phkudmd
	fhtXxWseLAHX2jtGPEeR7DRFRqUB3G3pKoBBjrVhzQF6V79C1FtxZPTWNrqm5qRhPFn8EM4uqaY
	FEvHwxw4c9MsmjYoGJy6pdRieM0QAMjM=
X-Received: by 2002:a05:6214:2f0b:b0:89c:6692:1d83 with SMTP id
 6a1803df08f44-8e63b747140mr30595736d6.3.1782329084276; Wed, 24 Jun 2026
 12:24:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260624075700.751467-1-alex@ghiti.fr>
In-Reply-To: <20260624075700.751467-1-alex@ghiti.fr>
From: Barry Song <baohua@kernel.org>
Date: Thu, 25 Jun 2026 03:24:32 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xM=WnFO-OuwVude-DQ_UkaCi_zF_bXBP9Li5+ZPNy0VQ@mail.gmail.com>
X-Gm-Features: AVVi8CexeTETlk8RBMzOXYlxK8Mur4P2kN4NGwePBFZa-lhIjuNaxGvTMMrgLpo
Message-ID: <CAGsJ_4xM=WnFO-OuwVude-DQ_UkaCi_zF_bXBP9Li5+ZPNy0VQ@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: bypass swap readahead for zswap
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, yosry@kernel.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, kasong@tencent.com, chrisl@kernel.org, usama.arif@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E050A100003
X-Rspam-User: 
X-Stat-Signature: uh48xbixrdmcdwsexa56f7wzgf81ngw1
X-HE-Tag: 1782329085-809846
X-HE-Meta: U2FsdGVkX19PWV3OkUcq5y3laPgMMT5FzQmbwt1nW4eQ22K6Tpm8djoazLlGyBVcj3R7mLnveasjzM9CdXg+rBFb634UhUjxtW0fY7HVkyyYEEJklYJM2Kjy4Q7R7SeIO3+RWeyG0A0x26CTDQ0+CeiIof27Rs0RSlTws4cXby5Cav8rlOkpkctcUaWrbk825pxad979h1S2C4MXS7MPX8gQRU7eKjvFH899HQIaXLNfK8JQsS9owQf48rO64CdWQQR8qzV+rU6HtyC0oTSP85xPTm7r7s4wkDR59iUbd4l3f8wLDbZiu2Vcr/dKPT5W7bJD4t7qntwdicIrr/TnUcFLl4i2mogVc5IfBYdowFfs0EJpIkafyUyyx6msp0a7JWfSMywiO0KeyLSl/YIj7sV9J6X3CotkmoYswREsBW/L/Y0jcR9WfKti4pFc2sI55eTPOc6ZiPX4hZPig/j5ScBIBbektGdOofMjRrEf/H6m/rTMaH52tFLJI+COaTYdlzlTzAs/4SOkvlAPoLc4oiC6uj7dzItgv4P1aOkpXPDJsYckrb7CE+vTJsGUpG1bYQbviU0RKkCv7Z9GYSll67sENoFsC8BNG9Miyma3gtiRtnREvv9yVgZirGa5ekfcxAlL8dD4JHOo20VgMhQGR5vVtgzoeYwhMDm+z2aJiNo5r/0/DKWQv68RHXcP+S6ZxnglGNId//r44R9SwdylR4bO4sdaC/YJvupiKYtEkPQNNBqKVpTvRYAOV7aVM1HICjvhslsrGSs/2C8eCjoWFpihRQvcQ7L995Ne+BMu3fjIeKT9ISAjJNgqYO0MZAG+ZTQuZajRZJbnxnk7sc7MArA1+zQJlKighWD6CRl/5gOX/I9gGZcBMFXI43093979pp4pk8SDhGwAXz4Tiyc54L7YDCDXj4RQ6L245eVmonfeQagse4USZzqd0Qx2RtzIeblZ0/Q2teEPEqih1+8
 7yy0FkKt
 c77ju8ViX9lb1swA2VprZlrJD2Xj+eckiVrz5UpDvX2gLEHDNOJabLSKhP4XgIPM76lCYokvS0r2WPBEaPBKgYV3L/n45QokDj5uZisG+2wE8ifs/18DqYqVTfxJV8FuDofeEs551YzZ2z6VEOUrrdClBtFLKWkF0UWhpdpTZv3lX9FP/NCiEz8epqbURcuuN84eTjQPF4cIPQs293Il5KgbpOHydmjEUEFWn+iW/9HF4mMMzvUTLpfpiokjR0d3/7PizUZQwHBSt4QO/ttRry2QQrDEemVdZz5qEx6NwP0lB74XwWgkifKzG2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 3:57=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> Commit 0bcac06f27d7 ("mm, swap: skip swapcache for swapin of synchronous
> device") made SWP_SYNCHRONOUS_IO devices (e.g. zram) skip swap readahead.
>
> zswap is the same kind of in-memory, synchronous backend as zram, not a
> swap device flagged SWP_SYNCHRONOUS_IO so it still goes through
> swapin_readahead().
>
> Here are the results from bypassing readahead for zswap too: it was
> measured with a kernel build (make -j16) in a memcg, zswap=3Dzstd, shrink=
er
> off, on Sapphire Rapids and 3 iterations.
>
>   768M memcg (sustained swap thrash):
>     metric                 mm-new    + bypass    delta
>     build time (s)          405.0       341.7    -15.6%
>     zswap-in (GB)            79.5        53.0     -33%
>     zswap-out (GB)          144.8       115.6     -20%
>     swap readahead (pages)  6.79M       0.45M     -93%
>     swap_ra hit (%)          72.1        89.9     +18pp
>
>   1G memcg (light pressure, build not memory-bound):
>     metric                 mm-new    + bypass    delta
>     build time (s)          177.7       176.0    ~same (no regression)
>     zswap-in (GB)            10.2         7.5     -26%
>     zswap-out (GB)           27.7        25.1      -9%
>     swap readahead (pages)  1.07M       0.08M     -93%
>     swap_ra hit (%)          68.6        87.2     +19pp
>
> The gain is from no longer prefetching pages that are pointless for an
> in-memory backend: readahead inflates anon residency and thrashes the
> page cache (file pages get evicted and re-read), lengthens each fault by
> synchronously (de)compressing a cluster of neighbours, and adds
> compression traffic when those extra pages are reclaimed.
>
> Bypassing swap readahead for zswap therefore makes sense.
>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>
> - This bypass originally comes from Usama's series that implements
>   large folio zswapin: while working on improving this series, I noticed
>   the gains I got only came from the bypass of readahead.
>
>  include/linux/zswap.h |  6 ++++++
>  mm/memory.c           |  5 +++--
>  mm/zswap.c            | 11 +++++++++++
>  3 files changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/zswap.h b/include/linux/zswap.h
> index 30c193a1207e..b6f0e6198b6f 100644
> --- a/include/linux/zswap.h
> +++ b/include/linux/zswap.h
> @@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
>  void zswap_folio_swapin(struct folio *folio);
>  bool zswap_is_enabled(void);
>  bool zswap_never_enabled(void);
> +bool zswap_present_test(swp_entry_t swp);
>  #else
>
>  struct zswap_lruvec_state {};
> @@ -69,6 +70,11 @@ static inline bool zswap_never_enabled(void)
>         return true;
>  }
>
> +static inline bool zswap_present_test(swp_entry_t swp)
> +{
> +       return false;
> +}
> +
>  #endif
>
>  #endif /* _LINUX_ZSWAP_H */
> diff --git a/mm/memory.c b/mm/memory.c
> index ff338c2abe92..5aa1ea9eb48a 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4827,8 +4827,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>         if (folio)
>                 swap_update_readahead(folio, vma, vmf->address);
>         if (!folio) {
> -               /* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devic=
es */
> -               if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
> +               /* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devic=
es and zswap */
> +               if (data_race(si->flags & SWP_SYNCHRONOUS_IO) ||
> +                   zswap_present_test(entry))
>                         folio =3D swapin_sync(entry, GFP_HIGHUSER_MOVABLE=
,
>                                             thp_swapin_suitable_orders(vm=
f) | BIT(0),
>                                             vmf, NULL, 0);

Basically, I have been seeing the same issue recently. If the
readahead swap entries are also in zswap, we end up doing the
decompression during one page fault, but then need another page fault
to fetch the page from the swap cache and install the mapping. In that
case, readahead may not be beneficial.

On the other hand, if the readahead swap entries are not in zswap, the
situation is different.

For example, suppose we fault on the swap entry for address 1 MB and
readahead brings in the entry for 1 MB + 4 KB. If both entries are in
zswap, readahead does not seem like a good trade-off. However, if the
1 MB + 4 KB entry is not in zswap and would otherwise require storage
I/O, then readahead can be beneficial.

So I implemented a rather ugly fault_around-like mechanism in
do_swap_page(). At least with page-cluster =3D=3D 1, I am seeing a
performance improvement, as the readahead folios can be mapped
directly and do not require a second page fault.

It is admittedly quite ugly and is only meant as a proof of concept :-)

Subject: [PATCH PoC] mm: enable do_swap_page fault_around

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/memory.c | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index c00a31a6d1d0..1db79f45a575 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4736,6 +4736,100 @@ static void check_swap_exclusive(struct folio
*folio, swp_entry_t entry,
         } while (--nr_pages);
 }

+static void do_swap_map_around(struct vm_fault *vmf, struct
swap_info_struct *si)
+{
+        struct vm_area_struct *vma =3D vmf->vma;
+        int nr_around =3D 1 << page_cluster;
+        unsigned long start =3D max3(vma->vm_start, vmf->address -
(nr_around - 1) * PAGE_SIZE,
+                        vmf->address & PMD_MASK);
+        unsigned long end =3D min3(vma->vm_end, vmf->address +
nr_around * PAGE_SIZE,
+                        (vmf->address & PMD_MASK) + PMD_SIZE);
+        unsigned long nr_pages =3D (end - start) >> PAGE_SHIFT;
+        unsigned long delta_pages =3D (vmf->address - start) >> PAGE_SHIFT=
;
+        pte_t *ptep =3D vmf->pte - delta_pages;
+
+        for (int i =3D 0; i < nr_pages; i++, ptep++) {
+                unsigned long address =3D start + (i << PAGE_SHIFT);
+                rmap_t rmap_flags =3D RMAP_NONE;
+                pte_t orig_pte, pte;
+                struct folio *folio;
+                struct page *page;
+                softleaf_t entry;
+                bool exclusive;
+
+                if (ptep =3D=3D vmf->pte)
+                        continue;
+                orig_pte =3D ptep_get(ptep);
+                exclusive =3D pte_swp_exclusive(orig_pte);
+                if (!exclusive)
+                        continue;
+                entry =3D softleaf_from_pte(orig_pte);
+                if (!softleaf_is_swap(entry))
+                        continue;
+                folio =3D swap_cache_get_folio(entry);
+                if (!folio)
+                        continue;
+                if (unlikely(!folio_matches_swap_entry(folio, entry)))
+                        goto skip;
+                if (folio_test_locked(folio))
+                        goto skip;
+                if (!folio_test_uptodate(folio))
+                        goto skip;
+                if (!folio_trylock(folio))
+                        goto skip;
+                if (folio_test_ksm(folio) || folio_test_large(folio) ||
+                        !folio_test_uptodate(folio))
+                        goto unlock;
+                if (exclusive && folio_test_writeback(folio) &&
+                                data_race(si->flags & SWP_STABLE_WRITES))
+                        exclusive =3D false;
+
+                arch_swap_restore(folio_swap(entry, folio), folio);
+
+                page =3D folio_page(folio, 0);
+                add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
+                add_mm_counter(vma->vm_mm, MM_SWAPENTS, -1);
+                pte =3D mk_pte(page, vma->vm_page_prot);
+                if (pte_swp_soft_dirty(orig_pte))
+                        pte =3D pte_mksoft_dirty(pte);
+                if (pte_swp_uffd_wp(orig_pte))
+                        pte =3D pte_mkuffd_wp(pte);
+
+                if (exclusive) {
+                        if ((vma->vm_flags & VM_WRITE) &&
!userfaultfd_pte_wp(vma, pte) &&
+                                        !pte_needs_soft_dirty_wp(vma, pte)=
) {
+                                pte =3D pte_mkwrite(pte, vma);
+                        }
+                        rmap_flags |=3D RMAP_EXCLUSIVE;
+                }
+                flush_icache_pages(vma, page, 1);
+
+                if (!folio_test_anon(folio)) {
+                        folio_add_new_anon_rmap(folio, vma, address,
rmap_flags);
+                        folio_put_swap(folio, NULL);
+                } else {
+                        folio_add_anon_rmap_ptes(folio, page, 1, vma, addr=
ess,
+                                        rmap_flags);
+                        folio_put_swap(folio, page);
+                }
+
+                set_ptes(vma->vm_mm, address, ptep, pte, 1);
+                arch_do_swap_page_nr(vma->vm_mm, vma, address,
+                                pte, pte, 1);
+
+                if (should_try_to_free_swap(si, folio, vma, 1, vmf->flags)=
)
+                        folio_free_swap(folio);
+                folio_unlock(folio);
+                swap_update_readahead(folio, vma, address);
+                update_mmu_cache_range(vmf, vma, address, ptep, 1);
+                continue;
+unlock:
+                folio_unlock(folio);
+skip:
+                folio_put(folio);
+        };
+}
+
 /*
  * We enter with either the VMA lock or the mmap_lock held (see
  * FAULT_FLAG_VMA_LOCK), and pte mapped but not yet locked.
@@ -5121,6 +5215,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)

         /* No need to invalidate - it was non-present before */
         update_mmu_cache_range(vmf, vma, address, ptep, nr_pages);
+        do_swap_map_around(vmf, si);
 unlock:
         if (vmf->pte)
                 pte_unmap_unlock(vmf->pte, vmf->ptl);
--=20
2.34.1

