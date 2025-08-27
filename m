Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F42FCA0FF0
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 02:48:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 892276B032A; Tue, 26 Aug 2025 22:48:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8436B6B032B; Tue, 26 Aug 2025 22:48:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 758AC6B032C; Tue, 26 Aug 2025 22:48:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E01B6B032A
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 22:48:02 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0A995C03F8
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:48:02 +0000 (UTC)
X-FDA: 83821002804.26.9F7AD29
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id E515C18000C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:47:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cc8zFOFv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756262880; a=rsa-sha256;
	cv=none;
	b=txIev3iL+M4LqGA0gYl3+qKG82cX45a1dVzfRFPSfBuGyx7ecHQ8cUbbA63lfIXlGL/bRX
	N6SqnfDrG430xlxptHReV5+S3X9lwg6ZtcH1+jYRSHB82AmYNhQWwX8QxpgixFIiMaxZ5y
	QDrGwG016EnG5xegkKGXmpHlYdTbjnU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cc8zFOFv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756262880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I76gEfT0vC7XzIvQogV/waPr344cXgMsQn8Rv8gELC8=;
	b=0Xv20mwTo2/+pWvnhIthruTKNWy6++2uCNYZV5H4tw+dpeVF2jpbvj5q207cIvt4+sRB3W
	I4fFz20QIe55+iwCkZTBkPTszgn0wj7+l0W6nyv4mk5PtWnGJa/s1w1yd1MbWEzEc8EcuH
	whF4IrIEMMRRgY/gWm9Dqrckv1gGwgk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CDA5144736
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92C8C4CEF1
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756262878;
	bh=GrwN25eB0KFg43gPYkUqpluofgoZAoPRo7Lv1Jd72F8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=cc8zFOFvKbiCniHTMMm5GfLSYf+SuATUlzktDSyWu8c8Rj1ETWtJixTa2A2niDWbc
	 +kHrmPt//LD0VwnqwydgAE1GULcthQBhQTVYEI6lTKCtZ4CRXEpW/cdtuJJx+W804d
	 ZvuvWbHbrPtIoRBg1gR0mr09xTMnabQXjv0SGekc5wYgeU6wtwpGg5bjU5Q9RJCJ+f
	 qLFO8eRb5/hFCweWcuFSLhCVoyqQFslxeGzVWFNn9Sqzz3bKPAi9/ARaSSZewqGWji
	 f1dt7ax43JyYi+NLkRX83lIv45Cq9FuAlrw39VleIyTfxa+Sv4HdoyyenMwSJgRcAn
	 u+7TbInjxXbjg==
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-71d60504788so51910767b3.2
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:47:58 -0700 (PDT)
X-Gm-Message-State: AOJu0YzmBeMnmF1+mqCuMR0QFBgDzQngRugLLCNzcpQzIjvo1bQ95Li6
	Zr4/1R0/WG72hFPReXa/eY4Bi+4S4goxjztPzehbW9ttOxVP/RqpJqxn0I5sDXfCiTvPbBWx9wa
	DoVwO8Vv5n4+d65FrCPRIJbSLJKvmnzrC2kbpLk9/QA==
X-Google-Smtp-Source: AGHT+IHM8BrI74GSxqebOX50Y/7nr6GxJ/jkXJXQQyDqXvJ48FghX20hBVx7wtHew1PNlE1cBUFOhUhThC4/NYWUR9A=
X-Received: by 2002:a05:690c:23c5:b0:71f:b944:1014 with SMTP id
 00721157ae682-71fdc55c89bmr209837347b3.47.1756262877687; Tue, 26 Aug 2025
 19:47:57 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-2-ryncsn@gmail.com>
In-Reply-To: <20250822192023.13477-2-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 26 Aug 2025 19:47:46 -0700
X-Gmail-Original-Message-ID: <CACePvbW_tkBAhj6-kQzyU2Jh-1dDy63Qc4K3RFyyA4=yt-_D5Q@mail.gmail.com>
X-Gm-Features: Ac12FXz8Zw2WT3PGI6TAf4cgSdIR-9iu0BN8H1078fGam8YLly_6W3MLV3qnIDc
Message-ID: <CACePvbW_tkBAhj6-kQzyU2Jh-1dDy63Qc4K3RFyyA4=yt-_D5Q@mail.gmail.com>
Subject: Re: [PATCH 1/9] mm, swap: use unified helper for swap cache look up
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: E515C18000C
X-Stat-Signature: y5xhag9d4cbudubck43i8w3nihu3a3ga
X-HE-Tag: 1756262879-187634
X-HE-Meta: U2FsdGVkX18XEoqIB2ftnidQ3Xx+A9Gj4v1ZrvsHXTfVn75klcPDUzGXw4WsA6pj55aQg1maJvDoBU1D/hPGURGia3ftpIuis48rWe9FfMfuegHxt1x8fzPOKiV2vaI+4ixhAqW4sfyhdH8zvfg9btirOiVQ2DUA1ckfjG7sWQzQ/m8nPdXaK1P6DivbC6vvmPY++SDZPQEqadAyqzcbO09APe4+uy4qQJnUtwlyPeGI5t1IOuCzou8gQQZvk94QJoTxTgNlW5X7/ZeYzkF65FHghyJ8ieUQFj41/wpHqJiBmjSWJ/HnrrrTEoy3Ws7e/wlx0JMpwZNDZXOaBipsMVoTaSOCsoK1QyvoMD9QH0WWrHSTAr+cCienAHo1rPeCAmuu7hPbnjGeNrD16VVYNNFe2osjBzujlTVCohso0HGZT27zdwlHdv8wanpiuAndydH2wdATpb5BcpjM2tdIPjJdybTLSnZnyJxj6pQJDOEgf2PoTJSr0LC+HXYF0whi/rOXKw3M9TlD8zTSe/W5jTwf4tfbTJzL9yRbfF0h0byL4OL+CNI3Ea6RrKORsCfgkgexuRAUpcOmdt9MoH7UhM+R+Yvt0JKhxVMUQ+wCQ1K3N9odIDyaYfKM1kZpD0LxaLTiCeVnRmMX2CCZaFn2AfmAh/LOz0KsCITlyXwPt5uY6YvOP6Kufst4FyO0gOBdUJiyY1uVDXtIQa6yR4qsCXCHhkL1RjpHins8MbiYUbmAZoSlm8q/yxYbqKyUxn3VtummaZ54oen/sYnRhhk5W9dJwu0fdwn7RfK26UyKitWoj6Sbn62Sc1oLALStWyLo3NpV6OtiqYRYjpcaAvvQx4zygrwUlLF+J1Me1Cofn75NlFAlOLySziZLoGGMLtsO7/8h4il8su/i1jytfPYbVqW4wybYCmEDYcS27kDW5TuuSGUmJ6hbwGWuiKkibexcKVUHi3w1d+lZJxuw0HG
 KLWPbRHP
 R1RTyO32rWRLVpysNNmmu/vRCYFQKXqffcijifFRJ9rFueCWulbIUrDVAuf4kmVPu12uDysGkns4N5s0C3a3RHOv9IK287XxagkwNsv0+Itn9w07ud695Iu1/F+6/hqEMzzFA8qWh3ISr5fiZKyhb5aM3ZeglRTwHhGBD9xeS+cX0HMZprj9mwv2MbhpEQ7m+VR4HIEu105Nf24TAKAVMumrNllC4Nm57Xy4Ck0cCOu0TXIljizaBuVBMn11n1McVcDhhycPq8Hrnd4vGmdL5aF+eTDm8yY6DDJFxOna/FMicGjpfRvWoi5Ftb+UXrVnJldNS02SM0GP7ptvZLNvYz/HJo39WhGuPAmj9FhRDDrSbW5g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

This commit message can use some improvement, I feel the part I am
interested in, what changed is buried in a lot of detail.

The background is that swap_cache_get_folio() used to do readahead
update as well. It has VMA as part of the argument. However, the
hibernation usage does not map swap entry to VMA. It was forced to
call filemap_get_entry() on swap cache instead, due to no VMA.

So the TL; DR; of what this patch does:

Split the swap readahead outside of swap_cache_get_folio(), so that
the hibernation non VMA usage can reuse swap_cache_get_folio()  as
well. No more  calling filemap_get_entry() on swap cache due to lack
of VMA.

The code itself looks fine. It has gone through some rounds of
feedback from me already. We can always update the commit message on
the next iteration.

Acked-by: Chris Li <chrisl@kernel.org>

Chris


On Fri, Aug 22, 2025 at 12:20=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> From: Kairui Song <kasong@tencent.com>
>
> Always use swap_cache_get_folio for swap cache folio look up. The reason
> we are not using it in all places is that it also updates the readahead
> info, and some callsites want to avoid that.
>
> So decouple readahead update with swap cache lookup into a standalone
> helper, let the caller call the readahead update helper if that's
> needed. And convert all swap cache lookups to use swap_cache_get_folio.
>
> After this commit, there are only three special cases for accessing swap
> cache space now: huge memory splitting, migration and shmem replacing,
> because they need to lock the Xarray. Following commits will wrap their
I commonly saw using xarray or XArray.
> accesses to the swap cache too with special helpers.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/memory.c      |  6 ++-
>  mm/mincore.c     |  3 +-
>  mm/shmem.c       |  4 +-
>  mm/swap.h        | 13 +++++--
>  mm/swap_state.c  | 99 +++++++++++++++++++++++-------------------------
>  mm/swapfile.c    | 11 +++---
>  mm/userfaultfd.c |  5 +--
>  7 files changed, 72 insertions(+), 69 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index d9de6c056179..10ef528a5f44 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4660,9 +4660,11 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>         if (unlikely(!si))
>                 goto out;
>
> -       folio =3D swap_cache_get_folio(entry, vma, vmf->address);
> -       if (folio)
> +       folio =3D swap_cache_get_folio(entry);
> +       if (folio) {
> +               swap_update_readahead(folio, vma, vmf->address);
>                 page =3D folio_file_page(folio, swp_offset(entry));
> +       }
>         swapcache =3D folio;
>
>         if (!folio) {
> diff --git a/mm/mincore.c b/mm/mincore.c
> index 2f3e1816a30d..8ec4719370e1 100644
> --- a/mm/mincore.c
> +++ b/mm/mincore.c
> @@ -76,8 +76,7 @@ static unsigned char mincore_swap(swp_entry_t entry, bo=
ol shmem)
>                 if (!si)
>                         return 0;
>         }
> -       folio =3D filemap_get_entry(swap_address_space(entry),
> -                                 swap_cache_index(entry));
> +       folio =3D swap_cache_get_folio(entry);
>         if (shmem)
>                 put_swap_device(si);
>         /* The swap cache space contains either folio, shadow or NULL */
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 13cc51df3893..e9d0d2784cd5 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2354,7 +2354,7 @@ static int shmem_swapin_folio(struct inode *inode, =
pgoff_t index,
>         }
>
>         /* Look it up and read it in.. */
> -       folio =3D swap_cache_get_folio(swap, NULL, 0);
> +       folio =3D swap_cache_get_folio(swap);
>         if (!folio) {
>                 if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
>                         /* Direct swapin skipping swap cache & readahead =
*/
> @@ -2379,6 +2379,8 @@ static int shmem_swapin_folio(struct inode *inode, =
pgoff_t index,
>                         count_vm_event(PGMAJFAULT);
>                         count_memcg_event_mm(fault_mm, PGMAJFAULT);
>                 }
> +       } else {
> +               swap_update_readahead(folio, NULL, 0);
>         }
>
>         if (order > folio_order(folio)) {
> diff --git a/mm/swap.h b/mm/swap.h
> index 1ae44d4193b1..efb6d7ff9f30 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -62,8 +62,7 @@ void delete_from_swap_cache(struct folio *folio);
>  void clear_shadow_from_swap_cache(int type, unsigned long begin,
>                                   unsigned long end);
>  void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int=
 nr);
> -struct folio *swap_cache_get_folio(swp_entry_t entry,
> -               struct vm_area_struct *vma, unsigned long addr);
> +struct folio *swap_cache_get_folio(swp_entry_t entry);
>  struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>                 struct vm_area_struct *vma, unsigned long addr,
>                 struct swap_iocb **plug);
> @@ -74,6 +73,8 @@ struct folio *swap_cluster_readahead(swp_entry_t entry,=
 gfp_t flag,
>                 struct mempolicy *mpol, pgoff_t ilx);
>  struct folio *swapin_readahead(swp_entry_t entry, gfp_t flag,
>                 struct vm_fault *vmf);
> +void swap_update_readahead(struct folio *folio, struct vm_area_struct *v=
ma,
> +                          unsigned long addr);
>
>  static inline unsigned int folio_swap_flags(struct folio *folio)
>  {
> @@ -159,6 +160,11 @@ static inline struct folio *swapin_readahead(swp_ent=
ry_t swp, gfp_t gfp_mask,
>         return NULL;
>  }
>
> +static inline void swap_update_readahead(struct folio *folio,
> +               struct vm_area_struct *vma, unsigned long addr)
> +{
> +}
> +
>  static inline int swap_writeout(struct folio *folio,
>                 struct swap_iocb **swap_plug)
>  {
> @@ -169,8 +175,7 @@ static inline void swapcache_clear(struct swap_info_s=
truct *si, swp_entry_t entr
>  {
>  }
>
> -static inline struct folio *swap_cache_get_folio(swp_entry_t entry,
> -               struct vm_area_struct *vma, unsigned long addr)
> +static inline struct folio *swap_cache_get_folio(swp_entry_t entry)
>  {
>         return NULL;
>  }
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 99513b74b5d8..ff9eb761a103 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -69,6 +69,21 @@ void show_swap_cache_info(void)
>         printk("Total swap =3D %lukB\n", K(total_swap_pages));
>  }
>
> +/*
> + * Lookup a swap entry in the swap cache. A found folio will be returned
> + * unlocked and with its refcount incremented.
> + *
> + * Caller must lock the swap device or hold a reference to keep it valid=
.
> + */
> +struct folio *swap_cache_get_folio(swp_entry_t entry)
> +{
> +       struct folio *folio =3D filemap_get_folio(swap_address_space(entr=
y),
> +                                               swap_cache_index(entry));
> +       if (!IS_ERR(folio))
> +               return folio;
> +       return NULL;
> +}
> +
>  void *get_shadow_from_swap_cache(swp_entry_t entry)
>  {
>         struct address_space *address_space =3D swap_address_space(entry)=
;
> @@ -273,54 +288,40 @@ static inline bool swap_use_vma_readahead(void)
>  }
>
>  /*
> - * Lookup a swap entry in the swap cache. A found folio will be returned
> - * unlocked and with its refcount incremented - we rely on the kernel
> - * lock getting page table operations atomic even if we drop the folio
> - * lock before returning.
> - *
> - * Caller must lock the swap device or hold a reference to keep it valid=
.
> + * Update the readahead statistics of a vma or globally.
>   */
> -struct folio *swap_cache_get_folio(swp_entry_t entry,
> -               struct vm_area_struct *vma, unsigned long addr)
> +void swap_update_readahead(struct folio *folio,
> +                          struct vm_area_struct *vma,
> +                          unsigned long addr)
>  {
> -       struct folio *folio;
> -
> -       folio =3D filemap_get_folio(swap_address_space(entry), swap_cache=
_index(entry));
> -       if (!IS_ERR(folio)) {
> -               bool vma_ra =3D swap_use_vma_readahead();
> -               bool readahead;
> +       bool readahead, vma_ra =3D swap_use_vma_readahead();
>
> -               /*
> -                * At the moment, we don't support PG_readahead for anon =
THP
> -                * so let's bail out rather than confusing the readahead =
stat.
> -                */
> -               if (unlikely(folio_test_large(folio)))
> -                       return folio;
> -
> -               readahead =3D folio_test_clear_readahead(folio);
> -               if (vma && vma_ra) {
> -                       unsigned long ra_val;
> -                       int win, hits;
> -
> -                       ra_val =3D GET_SWAP_RA_VAL(vma);
> -                       win =3D SWAP_RA_WIN(ra_val);
> -                       hits =3D SWAP_RA_HITS(ra_val);
> -                       if (readahead)
> -                               hits =3D min_t(int, hits + 1, SWAP_RA_HIT=
S_MAX);
> -                       atomic_long_set(&vma->swap_readahead_info,
> -                                       SWAP_RA_VAL(addr, win, hits));
> -               }
> -
> -               if (readahead) {
> -                       count_vm_event(SWAP_RA_HIT);
> -                       if (!vma || !vma_ra)
> -                               atomic_inc(&swapin_readahead_hits);
> -               }
> -       } else {
> -               folio =3D NULL;
> +       /*
> +        * At the moment, we don't support PG_readahead for anon THP
> +        * so let's bail out rather than confusing the readahead stat.
> +        */
> +       if (unlikely(folio_test_large(folio)))
> +               return;
> +
> +       readahead =3D folio_test_clear_readahead(folio);
> +       if (vma && vma_ra) {
> +               unsigned long ra_val;
> +               int win, hits;
> +
> +               ra_val =3D GET_SWAP_RA_VAL(vma);
> +               win =3D SWAP_RA_WIN(ra_val);
> +               hits =3D SWAP_RA_HITS(ra_val);
> +               if (readahead)
> +                       hits =3D min_t(int, hits + 1, SWAP_RA_HITS_MAX);
> +               atomic_long_set(&vma->swap_readahead_info,
> +                               SWAP_RA_VAL(addr, win, hits));
>         }
>
> -       return folio;
> +       if (readahead) {
> +               count_vm_event(SWAP_RA_HIT);
> +               if (!vma || !vma_ra)
> +                       atomic_inc(&swapin_readahead_hits);
> +       }
>  }
>
>  struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
> @@ -336,14 +337,10 @@ struct folio *__read_swap_cache_async(swp_entry_t e=
ntry, gfp_t gfp_mask,
>         *new_page_allocated =3D false;
>         for (;;) {
>                 int err;
> -               /*
> -                * First check the swap cache.  Since this is normally
> -                * called after swap_cache_get_folio() failed, re-calling
> -                * that would confuse statistics.
> -                */
> -               folio =3D filemap_get_folio(swap_address_space(entry),
> -                                         swap_cache_index(entry));
> -               if (!IS_ERR(folio))
> +
> +               /* Check the swap cache in case the folio is already ther=
e */
> +               folio =3D swap_cache_get_folio(entry);
> +               if (folio)
>                         goto got_folio;
>
>                 /*
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index a7ffabbe65ef..4b8ab2cb49ca 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -213,15 +213,14 @@ static int __try_to_reclaim_swap(struct swap_info_s=
truct *si,
>                                  unsigned long offset, unsigned long flag=
s)
>  {
>         swp_entry_t entry =3D swp_entry(si->type, offset);
> -       struct address_space *address_space =3D swap_address_space(entry)=
;
>         struct swap_cluster_info *ci;
>         struct folio *folio;
>         int ret, nr_pages;
>         bool need_reclaim;
>
>  again:
> -       folio =3D filemap_get_folio(address_space, swap_cache_index(entry=
));
> -       if (IS_ERR(folio))
> +       folio =3D swap_cache_get_folio(entry);
> +       if (!folio)
>                 return 0;
>
>         nr_pages =3D folio_nr_pages(folio);
> @@ -2131,7 +2130,7 @@ static int unuse_pte_range(struct vm_area_struct *v=
ma, pmd_t *pmd,
>                 pte_unmap(pte);
>                 pte =3D NULL;
>
> -               folio =3D swap_cache_get_folio(entry, vma, addr);
> +               folio =3D swap_cache_get_folio(entry);
>                 if (!folio) {
>                         struct vm_fault vmf =3D {
>                                 .vma =3D vma,
> @@ -2357,8 +2356,8 @@ static int try_to_unuse(unsigned int type)
>                (i =3D find_next_to_unuse(si, i)) !=3D 0) {
>
>                 entry =3D swp_entry(type, i);
> -               folio =3D filemap_get_folio(swap_address_space(entry), sw=
ap_cache_index(entry));
> -               if (IS_ERR(folio))
> +               folio =3D swap_cache_get_folio(entry);
> +               if (!folio)
>                         continue;
>
>                 /*
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 50aaa8dcd24c..af61b95c89e4 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1489,9 +1489,8 @@ static long move_pages_ptes(struct mm_struct *mm, p=
md_t *dst_pmd, pmd_t *src_pmd
>                  * separately to allow proper handling.
>                  */
>                 if (!src_folio)
> -                       folio =3D filemap_get_folio(swap_address_space(en=
try),
> -                                       swap_cache_index(entry));
> -               if (!IS_ERR_OR_NULL(folio)) {
> +                       folio =3D swap_cache_get_folio(entry);
> +               if (folio) {
>                         if (folio_test_large(folio)) {
>                                 ret =3D -EBUSY;
>                                 folio_put(folio);
> --
> 2.51.0
>

