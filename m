Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B929E9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 07:00:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82C156B0088; Thu, 19 Feb 2026 02:00:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D96A6B0089; Thu, 19 Feb 2026 02:00:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BB686B008A; Thu, 19 Feb 2026 02:00:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 597666B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:00:21 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 105551A0491
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:00:21 +0000 (UTC)
X-FDA: 84460307442.17.E722FC3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 15CB3100003
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:00:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MoACWPYB;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771484419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eJKl5QFt79TYtIEmB3ZSF1r7zVS4s3rTZoN9aScxyPk=;
	b=8StX2bWOX1KHIGmzf77Yvm1FtC5hTDfQ4pkx7tiAjSKazqcB7lRlX9z502wlhYjdqkJ4Hp
	E9gT2wmsC+jOuGpafxinZa+xiCAR5toNpJ9LFbjXzJ5hQErcBMXOVxA6YRBiwiiO3E0k5H
	MZ7E5ubb7tWnpGK3HMZAL8dqw6PxKLw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MoACWPYB;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771484419; a=rsa-sha256;
	cv=none;
	b=sieFUitAdU4XqYRoBUr3DgHYW6c3q4bfmMHaqSFexwd9kUSiB4JExE0Mj6chwRDvDDzY0B
	kTojrQ+Ow3iYqIWzLTELt+M5UqFIm1uKO1Al6RWpOGkPD5RvC1hKNhixOXfLzVmPp4+WZi
	Lt9c+Kd8uRF3otLu9jII0u3qbKa7mv0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E831E442D2
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B157FC2BCB2
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771484417;
	bh=j2BgW9/oHmFyIKNKI50Q/cqMDJ+EmPe7VweoRym+X/8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=MoACWPYBxiuflZX9jTdpuV4ZqNMVy8buKVgNztWskpax2P+6n9/38DKQddlrmAXmJ
	 fMSq+r0slFXlqBlLFIE0u5Nrk5e1zh9Tn+W91xCRYvXKeCkjpWIFRcFl1mnFgL9ihp
	 A/RyKjzQ7C68V/pq+CHA8rywjH67j37BtmqfGZ0sv/mzA2LFCSz3EnM6ymaFqxxqXg
	 AhD1+Gldu01VY1UfqRRsmxxwkgLAT1tfdU035VLjXVAavKwuSmMlbXeFFSus+NQXkt
	 +ZSXN0pDb4kJNyYbG2x+miTqpDzYRKuXKICOPF5m7hZhip7gZF9meuVDuAypR2aIJX
	 mZv6JevF2O1yA==
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-649df393c04so486622d50.1
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 23:00:17 -0800 (PST)
X-Gm-Message-State: AOJu0YxSsXO+IKC/doUMtu1omR6JJNKr0BTsiVdtCsMKlKeLSdGVKu09
	oBwhy+QcFaqunChPhfBIx63g6BFr1QZq7CIKHXR1h2SP+RvQ1WJOpFWtUVf6PTWkvXNZPs9eoDD
	d6B3aALj231/FpD/LKUVI+haoff436XL73YeRgWj3Wg==
X-Received: by 2002:a05:690e:bcc:b0:641:f5bc:69a2 with SMTP id
 956f58d0204a3-64c556ca20amr2926387d50.80.1771484416792; Wed, 18 Feb 2026
 23:00:16 -0800 (PST)
MIME-Version: 1.0
References: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com> <20260218-swap-table-p3-v3-6-f4e34be021a7@tencent.com>
In-Reply-To: <20260218-swap-table-p3-v3-6-f4e34be021a7@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 18 Feb 2026 23:00:03 -0800
X-Gmail-Original-Message-ID: <CACePvbUpCXTzNUFw1sHRao+pDZDhN9N7YUowwFQ_gOLihZx8+g@mail.gmail.com>
X-Gm-Features: AZwV_Qj5GfGHeLD9NbyNrrUGBnhtinfPIMmqDXadiUoa9zQV8aQnwKY147Ikr_I
Message-ID: <CACePvbUpCXTzNUFw1sHRao+pDZDhN9N7YUowwFQ_gOLihZx8+g@mail.gmail.com>
Subject: Re: [PATCH v3 06/12] mm, swap: implement helpers for reserving data
 in the swap table
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 15CB3100003
X-Stat-Signature: qhhcu6ts7qyw5hejabaz35i1kh34nc6z
X-HE-Tag: 1771484418-156800
X-HE-Meta: U2FsdGVkX19iVW9jNCVjkwJjtJi9fSdm61YYyP6bdd/wB0lizZLJeUVm1vApQCFinmI2wnK6dwehqKrP/0BvyPqSHnfbJZV4I/zcvsP9ij2mjL12I4+lsChHFMfbxlyZ3Mnt3nbYtpMFoy5CkIc/BbaDOx4d1V6m+kDqIF7R3azGLshjvKRXBLrpAChDDi6DqNS6tFWm6NRG3qNs6NzOgcKxc7pnNaPl9mT/15lySZuJaZNf1NKgAWTlKZVXm1G998FtTpkj0F7NF3EuuM11B0oBGzaVWL4SesCZShl3tknMg5Dze2fbdkf+SN9kgobbFQ0l+SoW9qEnQDebWy7+GFfLZAu7m3LnkIq9zOWW704jzwreyDZmWl2KXbK8/0+cEunmIxUgLjLBI7zQsFvSirJrPrCE+mjBpujHoiMZ9x4VTrhFT4E0xQQ727F6D6C1iHYuhwkoQHQan6wWzOUI+/B/FAJyvwKqnuLBlrXsP9cKqDiMqTMy9LWnyWVvrhzAPb+eNjHJBRMuRFiiPJbR2CZ0pj4Sdvy5UqMMvDKZHTWBIKX2fNKshFPRWT20oPjIsS2XbyZnn4E3Xjd2kfH9+3KVviLSvTIwA8Hg3SaRn0H9vWvdmTNGe0KWVZqMQURg+gM9bvkbElDJKhP8zjmWD+wbLVgzzRbSp12W3wuih22TKWSjGM8SXVKNQ+dym3a0uWLCN8htBcjJOaFM+yewtDCPIFoALBRQAnDnoUuuBOJDorqOJscQ5Htkb0Q1hsyYj8Okyss+io++2r4javhQpdt+T29temqDlxD7iB9fNDA4LOt/1PrdfrEg9zoL/3OTBDh0BImy4EJCgBP/Y3kVUYcvDWF9ck0GF+xxZVB+3509K54JPrr9/RINwoi68kQgYVPF7Vj/wv3/gvNDcfOQUrUOvtZe+3NkwnTaPJHSk8G7vIQNN9V8UnPt26i/jFul82S/A1yu6e/MYSPaXwz
 H9lgU7WZ
 yZDzhKxzM6V+X8GViyAaYRtnz4Jwjq4p72i6e7a00uRChaqATWCvXKOGlO2Nc30vmRhOkuBnIB4GxskBR2eSF0GCGbJkPNwi2dHhZK+rUTByOZyrDfUk6boAlb4upfpqx2Mdawx2AIgEe2NtTdXx+6ZJGU7OVlQMVGa0HuWoNj9BaxbjKgaf4+QfJB0GksVETV3hEnUsS4QW8FvEoccGbaB6n3HSrD23d5WFCLc3BmLLBk7/7cj194BaFmxdC3g0VfRE+JfSYdb/JC/eSZKZh85vd2yeiSzYx7D4Z42X73MX0N1gGzVb8mYqitc0Er4MLKc0vAkxLWCxsRGI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 12:06=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> To prepare for using the swap table as the unified swap layer, introduce
> macros and helpers for storing multiple kinds of data in a swap table
> entry.
>
> From now on, we are storing PFN in the swap table to make space for
> extra counting bits (SWAP_COUNT). Shadows are still stored as they are,
> as the SWAP_COUNT is not used yet.
>
> Also, rename shadow_swp_to_tb to shadow_to_swp_tb. That's a spelling
> error, not really worth a separate fix.
>
> No behaviour change yet, just prepare the API.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

> ---
>  mm/swap_state.c |   6 +--
>  mm/swap_table.h | 131 ++++++++++++++++++++++++++++++++++++++++++++++++++=
+-----
>  2 files changed, 124 insertions(+), 13 deletions(-)
>
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 6d0eef7470be..e213ee35c1d2 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -148,7 +148,7 @@ void __swap_cache_add_folio(struct swap_cluster_info =
*ci,
>         VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
>         VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
>
> -       new_tb =3D folio_to_swp_tb(folio);
> +       new_tb =3D folio_to_swp_tb(folio, 0);
>         ci_start =3D swp_cluster_offset(entry);
>         ci_off =3D ci_start;
>         ci_end =3D ci_start + nr_pages;
> @@ -249,7 +249,7 @@ void __swap_cache_del_folio(struct swap_cluster_info =
*ci, struct folio *folio,
>         VM_WARN_ON_ONCE_FOLIO(folio_test_writeback(folio), folio);
>
>         si =3D __swap_entry_to_info(entry);
> -       new_tb =3D shadow_swp_to_tb(shadow);
> +       new_tb =3D shadow_to_swp_tb(shadow, 0);
>         ci_start =3D swp_cluster_offset(entry);
>         ci_end =3D ci_start + nr_pages;
>         ci_off =3D ci_start;
> @@ -331,7 +331,7 @@ void __swap_cache_replace_folio(struct swap_cluster_i=
nfo *ci,
>         VM_WARN_ON_ONCE(!entry.val);
>
>         /* Swap cache still stores N entries instead of a high-order entr=
y */
> -       new_tb =3D folio_to_swp_tb(new);
> +       new_tb =3D folio_to_swp_tb(new, 0);
>         do {
>                 old_tb =3D __swap_table_xchg(ci, ci_off, new_tb);
>                 WARN_ON_ONCE(!swp_tb_is_folio(old_tb) || swp_tb_to_folio(=
old_tb) !=3D old);
> diff --git a/mm/swap_table.h b/mm/swap_table.h
> index 10e11d1f3b04..10762ac5f4f5 100644
> --- a/mm/swap_table.h
> +++ b/mm/swap_table.h
> @@ -12,17 +12,72 @@ struct swap_table {
>  };
>
>  #define SWP_TABLE_USE_PAGE (sizeof(struct swap_table) =3D=3D PAGE_SIZE)
> -#define SWP_TB_COUNT_BITS              4
>
>  /*
>   * A swap table entry represents the status of a swap slot on a swap
>   * (physical or virtual) device. The swap table in each cluster is a
>   * 1:1 map of the swap slots in this cluster.
>   *
> - * Each swap table entry could be a pointer (folio), a XA_VALUE
> - * (shadow), or NULL.
> + * Swap table entry type and bits layouts:
> + *
> + * NULL:     |---------------- 0 ---------------| - Free slot
> + * Shadow:   | SWAP_COUNT |---- SHADOW_VAL ---|1| - Swapped out slot
> + * PFN:      | SWAP_COUNT |------ PFN -------|10| - Cached slot
> + * Pointer:  |----------- Pointer ----------|100| - (Unused)
> + * Bad:      |------------- 1 -------------|1000| - Bad slot
> + *
> + * SWAP_COUNT is `SWP_TB_COUNT_BITS` long, each entry is an atomic long.
> + *
> + * Usages:
> + *
> + * - NULL: Swap slot is unused, could be allocated.
> + *
> + * - Shadow: Swap slot is used and not cached (usually swapped out). It =
reuses
> + *   the XA_VALUE format to be compatible with working set shadows. SHAD=
OW_VAL
> + *   part might be all 0 if the working shadow info is absent. In such a=
 case,
> + *   we still want to keep the shadow format as a placeholder.
> + *
> + *   Memcg ID is embedded in SHADOW_VAL.
> + *
> + * - PFN: Swap slot is in use, and cached. Memcg info is recorded on the=
 page
> + *   struct.
> + *
> + * - Pointer: Unused yet. `0b100` is reserved for potential pointer usag=
e
> + *   because only the lower three bits can be used as a marker for 8 byt=
es
> + *   aligned pointers.
> + *
> + * - Bad: Swap slot is reserved, protects swap header or holes on swap d=
evices.
>   */
>
> +#if defined(MAX_POSSIBLE_PHYSMEM_BITS)
> +#define SWAP_CACHE_PFN_BITS (MAX_POSSIBLE_PHYSMEM_BITS - PAGE_SHIFT)
> +#elif defined(MAX_PHYSMEM_BITS)
> +#define SWAP_CACHE_PFN_BITS (MAX_PHYSMEM_BITS - PAGE_SHIFT)
> +#else
> +#define SWAP_CACHE_PFN_BITS (BITS_PER_LONG - PAGE_SHIFT)
> +#endif
> +
> +/* NULL Entry, all 0 */
> +#define SWP_TB_NULL            0UL
> +
> +/* Swapped out: shadow */
> +#define SWP_TB_SHADOW_MARK     0b1UL
> +
> +/* Cached: PFN */
> +#define SWP_TB_PFN_BITS                (SWAP_CACHE_PFN_BITS + SWP_TB_PFN=
_MARK_BITS)
> +#define SWP_TB_PFN_MARK                0b10UL
> +#define SWP_TB_PFN_MARK_BITS   2
> +#define SWP_TB_PFN_MARK_MASK   (BIT(SWP_TB_PFN_MARK_BITS) - 1)
> +
> +/* SWAP_COUNT part for PFN or shadow, the width can be shrunk or extende=
d */
> +#define SWP_TB_COUNT_BITS      min(4, BITS_PER_LONG - SWP_TB_PFN_BITS)
> +#define SWP_TB_COUNT_MASK      (~((~0UL) >> SWP_TB_COUNT_BITS))
> +#define SWP_TB_COUNT_SHIFT     (BITS_PER_LONG - SWP_TB_COUNT_BITS)
> +#define SWP_TB_COUNT_MAX       ((1 << SWP_TB_COUNT_BITS) - 1)
> +
> +/* Bad slot: ends with 0b1000 and rests of bits are all 1 */
> +#define SWP_TB_BAD             ((~0UL) << 3)
> +
>  /* Macro for shadow offset calculation */
>  #define SWAP_COUNT_SHIFT       SWP_TB_COUNT_BITS
>
> @@ -35,18 +90,47 @@ static inline unsigned long null_to_swp_tb(void)
>         return 0;
>  }
>
> -static inline unsigned long folio_to_swp_tb(struct folio *folio)
> +static inline unsigned long __count_to_swp_tb(unsigned char count)
>  {
> +       /*
> +        * At least three values are needed to distinguish free (0),
> +        * used (count > 0 && count < SWP_TB_COUNT_MAX), and
> +        * overflow (count =3D=3D SWP_TB_COUNT_MAX).
> +        */
> +       BUILD_BUG_ON(SWP_TB_COUNT_MAX < 2 || SWP_TB_COUNT_BITS < 2);
> +       VM_WARN_ON(count > SWP_TB_COUNT_MAX);
> +       return ((unsigned long)count) << SWP_TB_COUNT_SHIFT;
> +}
> +
> +static inline unsigned long pfn_to_swp_tb(unsigned long pfn, unsigned in=
t count)
> +{
> +       unsigned long swp_tb;
> +
>         BUILD_BUG_ON(sizeof(unsigned long) !=3D sizeof(void *));
> -       return (unsigned long)folio;
> +       BUILD_BUG_ON(SWAP_CACHE_PFN_BITS >
> +                    (BITS_PER_LONG - SWP_TB_PFN_MARK_BITS - SWP_TB_COUNT=
_BITS));
> +
> +       swp_tb =3D (pfn << SWP_TB_PFN_MARK_BITS) | SWP_TB_PFN_MARK;
> +       VM_WARN_ON_ONCE(swp_tb & SWP_TB_COUNT_MASK);
> +
> +       return swp_tb | __count_to_swp_tb(count);
> +}
> +
> +static inline unsigned long folio_to_swp_tb(struct folio *folio, unsigne=
d int count)
> +{
> +       return pfn_to_swp_tb(folio_pfn(folio), count);
>  }
>
> -static inline unsigned long shadow_swp_to_tb(void *shadow)
> +static inline unsigned long shadow_to_swp_tb(void *shadow, unsigned int =
count)
>  {
>         BUILD_BUG_ON((BITS_PER_XA_VALUE + 1) !=3D
>                      BITS_PER_BYTE * sizeof(unsigned long));
> +       BUILD_BUG_ON((unsigned long)xa_mk_value(0) !=3D SWP_TB_SHADOW_MAR=
K);
> +
>         VM_WARN_ON_ONCE(shadow && !xa_is_value(shadow));
> -       return (unsigned long)shadow;
> +       VM_WARN_ON_ONCE(shadow && ((unsigned long)shadow & SWP_TB_COUNT_M=
ASK));
> +
> +       return (unsigned long)shadow | __count_to_swp_tb(count) | SWP_TB_=
SHADOW_MARK;
>  }
>
>  /*
> @@ -59,7 +143,7 @@ static inline bool swp_tb_is_null(unsigned long swp_tb=
)
>
>  static inline bool swp_tb_is_folio(unsigned long swp_tb)
>  {
> -       return !xa_is_value((void *)swp_tb) && !swp_tb_is_null(swp_tb);
> +       return ((swp_tb & SWP_TB_PFN_MARK_MASK) =3D=3D SWP_TB_PFN_MARK);
>  }
>
>  static inline bool swp_tb_is_shadow(unsigned long swp_tb)
> @@ -67,19 +151,44 @@ static inline bool swp_tb_is_shadow(unsigned long sw=
p_tb)
>         return xa_is_value((void *)swp_tb);
>  }
>
> +static inline bool swp_tb_is_bad(unsigned long swp_tb)
> +{
> +       return swp_tb =3D=3D SWP_TB_BAD;
> +}
> +
> +static inline bool swp_tb_is_countable(unsigned long swp_tb)
> +{
> +       return (swp_tb_is_shadow(swp_tb) || swp_tb_is_folio(swp_tb) ||
> +               swp_tb_is_null(swp_tb));
> +}
> +
>  /*
>   * Helpers for retrieving info from swap table.
>   */
>  static inline struct folio *swp_tb_to_folio(unsigned long swp_tb)
>  {
>         VM_WARN_ON(!swp_tb_is_folio(swp_tb));
> -       return (void *)swp_tb;
> +       return pfn_folio((swp_tb & ~SWP_TB_COUNT_MASK) >> SWP_TB_PFN_MARK=
_BITS);
>  }
>
>  static inline void *swp_tb_to_shadow(unsigned long swp_tb)
>  {
>         VM_WARN_ON(!swp_tb_is_shadow(swp_tb));
> -       return (void *)swp_tb;
> +       /* No shift needed, xa_value is stored as it is in the lower bits=
. */
> +       return (void *)(swp_tb & ~SWP_TB_COUNT_MASK);
> +}
> +
> +static inline unsigned char __swp_tb_get_count(unsigned long swp_tb)
> +{
> +       VM_WARN_ON(!swp_tb_is_countable(swp_tb));
> +       return ((swp_tb & SWP_TB_COUNT_MASK) >> SWP_TB_COUNT_SHIFT);
> +}
> +
> +static inline int swp_tb_get_count(unsigned long swp_tb)
> +{
> +       if (swp_tb_is_countable(swp_tb))
> +               return __swp_tb_get_count(swp_tb);
> +       return -EINVAL;
>  }
>
>  /*
> @@ -124,6 +233,8 @@ static inline unsigned long swap_table_get(struct swa=
p_cluster_info *ci,
>         atomic_long_t *table;
>         unsigned long swp_tb;
>
> +       VM_WARN_ON_ONCE(off >=3D SWAPFILE_CLUSTER);
> +
>         rcu_read_lock();
>         table =3D rcu_dereference(ci->table);
>         swp_tb =3D table ? atomic_long_read(&table[off]) : null_to_swp_tb=
();
>
> --
> 2.52.0
>
>

