Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07EC2CA0FED
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 02:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A9508E0001; Fri,  5 Sep 2025 22:12:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 480896B0011; Fri,  5 Sep 2025 22:12:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BEE58E0001; Fri,  5 Sep 2025 22:12:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B0A26B0010
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 22:12:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A4D2185E8F
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 02:12:21 +0000 (UTC)
X-FDA: 83857200882.15.F2BBABA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id CD5AF20006
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 02:12:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YpX8BKBo;
	spf=pass (imf13.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757124739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=36oQw6gIXvOv75bE9Zt4Cs6dZCV4z3nLjhFydy2MTvM=;
	b=QLvjMtTHMms3zz8DbQx8ye7fCSNYFapu/XnJgR3ef94EB/oE+QIk/dxj5JoUEBfpXDpyuD
	0ro4zYjVtSttMOHks6VfA1O+b65X2vn3BZJspC7R8YdZytrv/cWBRFXzy7yOMYOsmUAdFc
	ypeHwE/syZZTXvf7A/IxzTEuBoy2iSU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YpX8BKBo;
	spf=pass (imf13.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757124739; a=rsa-sha256;
	cv=none;
	b=XcnFrHzGEUYhA0g/tAnxHJ9c0x/9rm8jmlLK+Q1GuSeH1vuZbWC7aQEccvaiGVTjMhe3JM
	daRJj9golwOYq5Sie3+1wXzF25go4RkTiYlwRlqJ5VjfqXopxazmCGQZFPaWCDdYLDVCAH
	djHEQgg2J5KS97WoJj4Uq1uJ+9p8eT8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F1798602AA
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 02:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C66EC4CEF1
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 02:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757124738;
	bh=yML2qgT+qxBmlSd/IZdm7TNlpAMRVBX1yWUFsXuETco=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=YpX8BKBoOp9qHx+Gji1p6dbvNZ2tTGH50T0TdZp5S7TOZ2DERWwYhco9fbAVHscPO
	 29mEruYFE3Vu4JsPH/yvK0jDmQ74drXQD+gcQWW/hFFB6SLoO5KBYC9or/t6ebPyMj
	 MV6H9cp2/auZ1YM4PD3fv/MGU6SLh7Db/GhHHSgNWPBEUqqm6bWXa8ho+RsWxLqs1f
	 6TJPQsZDSAuc1Xd2DanpaSqq//jbuP7MuUKPVmiaPhde+z0nbuNvZzd+Ta9BAB/od4
	 6KPclfUL2IKfN976oxRb/ahGKXtEaNRcOSNSNB1uMUwaTVsnNXOicVV0REoZ558BLc
	 AGbjBkrtXSP2g==
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45dd9d72f61so33125e9.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 19:12:18 -0700 (PDT)
X-Gm-Message-State: AOJu0YyvoS6cYP5aY0wwkHVd8Xvsy523OPNp5R4Ytu0nh+a3lSgM9OGb
	cilDbqdQ3F+ob/+IVHUpzFQJKi5kvWhZOlJdcbhABb3VKUxNBRoz7r9rWecp7HCBHWs40bTlqHt
	KK+5OMxOd67cbqgQdYipU44RE+WNOliaFQdyEfCJ8
X-Google-Smtp-Source: AGHT+IHKT6GE2df18G/b/qZaSo1a90rXDasB7VtwNKZ1fV2iHfqLus/pUkJM1UPUZUqxY/NljemSK47uT4nMbvBRAso=
X-Received: by 2002:a05:600c:34cb:b0:45c:b678:296 with SMTP id
 5b1f17b1804b1-45dde17c034mr425685e9.5.1757124737301; Fri, 05 Sep 2025
 19:12:17 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-6-ryncsn@gmail.com>
In-Reply-To: <20250905191357.78298-6-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 5 Sep 2025 19:12:06 -0700
X-Gmail-Original-Message-ID: <CAF8kJuM1Qjq2QjX-=XiUZ3EATPcX8wY0_COdce+Zf8nb=1v8Aw@mail.gmail.com>
X-Gm-Features: Ac12FXxhZJcLtO8jUl865bVVKEgfpFIwarkLqkM1zXOafPNb9tKeXQh2_BzYo_c
Message-ID: <CAF8kJuM1Qjq2QjX-=XiUZ3EATPcX8wY0_COdce+Zf8nb=1v8Aw@mail.gmail.com>
Subject: Re: [PATCH v2 05/15] mm, swap: always lock and check the swap cache
 folio before use
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CD5AF20006
X-Stat-Signature: ftdcft1c3b78qfgeqnyjfe4xfi1853b9
X-Rspam-User: 
X-HE-Tag: 1757124739-941635
X-HE-Meta: U2FsdGVkX1+1F5oRvSuESc+P5yEQyuCWQtCT+qVmYc2vNs4vn1RZtVaAMfytM6LICKE0h8f0mbOWOxUdUdNzt0Z67Ye1cP74ggkUzsRssAoO3YXd+f4SQ4T4Dbg2nuXhU6e4A/ZoLTg8VuAgV1E7o12ydt+REksmwfR4nVgkGjDzvpmORz9W+6Mpnlny7EKhjXXBAjWSIODM15kZbfoM11B6HPmy8jfXHEqJPXtCRhU565tg13/BrMHKtvr1A6tVV0Wtj64PKwAb79gd8zpEFd5nNCHlM+iWnlC6urDEkgYKUB/oXUCrzzV4R2lUCNmBo0cD2C8p1va9v0851h93dORMaWFJb4zXRnu6bAO7I4stVcPI7R8DDjB/SPAKSiydOjD9W6W01Ns/2VFTnKLBechsewUFAu6WGmKIGjSEObWjYPe61hCtg2DbMk3BB0NBo/VpPjS1S6jU/1Wgny2l5F+PkEj8z7H+WHvb9MPK81vhEtaAUbbNiAE5A2wjRRSNbe5IE0JIPTAjd84O+1x1BauA2ndzz9/Zzve7bIl853Qs2bFU5s8cQN69dDfa3p2/4YFLsWt6U2zGXfDLwrBTEzVXNXg1tRJbY8uV+TpD5ZSND20IOe46ecY4S9Suyk0C1fShYvWfYCUE/WQF5uklT1TjeROtWy36UX+MpZKmQ9Z+5IM2TIM+KiYoo+uA68cfr5EJ2pzmo/3I+LY0RbecNz06AO7GEEGuJvpytArpmMcdQu2Kr5lVaxTOv60d0uEJQjasEU9YJJDuWZGYbBHseCy2ypITRpgKtjuE3cytx+FvQ95SK/c3ztIdIj6qjpN4xh/6vnIiCDI0zmtd6aEVrBUReK2DSMPowtt5Oz/dYRH1QkdWCB0HjblmWhTSkpNHMFXtecw4phfR4Qei3yU8NI6q5OrRw5G0BMjCgez2k9cyz96SVBRk+eY7jwSngKyfyVfVWQhuVnuJOrDC0PQ
 QuZT8bXO
 7H+r41B4W9Rf3zPhvh80A46ujovgHASoTDjqk5vc/vsP6QVfm9eJ+ZVQa8GeqMEBGIzZ9VpFGdqiFg/eVWd3Tzy1/K+lexWPj/U1FLU6aBM1eIEyojcDhLuMw/7nyMRDu7vqqH0VZMFRH5e3UUZdtZzbX6a1yXaT5dPrljkdUUYYMG2ik0FR4fVPQLohbUAlpb57fuoKjxDRH4LDsgLGApcu6gtjxCHjPU5pXnMetmi5MCI2Mud7YJ4WmMvqnys9X9+7CFwXFf76BFBFA05vnt29HP1bEU7PuhY2Cgup+l9gKTynLE3GI1O3e5ARP261tnTTzHtk0Csy2HKdv8N4nJe5ak+lRZ9PJ/xp5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks correct to me.

Acked-by: Chris Li <chrisl@kernel.org>

With some nitpick follows,

On Fri, Sep 5, 2025 at 12:14=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> Swap cache lookup only increases the reference count of the returned
> folio. That's not enough to ensure a folio is stable in the swap
> cache, so the folio could be removed from the swap cache at any
> time. The caller should always lock and check the folio before using it.
>
> We have just documented this in kerneldoc, now introduce a helper for swa=
p
> cache folio verification with proper sanity checks.
>
> Also, sanitize a few current users to use this convention and the new
> helper for easier debugging. They were not having observable problems
> yet, only trivial issues like wasted CPU cycles on swapoff or
> reclaiming. They would fail in some other way, but it is still better to
> always follow this convention to make things robust and make later
> commits easier to do.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/memory.c     |  3 +--
>  mm/swap.h       | 24 ++++++++++++++++++++++++
>  mm/swap_state.c |  7 +++++--
>  mm/swapfile.c   | 10 +++++++---
>  4 files changed, 37 insertions(+), 7 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 94a5928e8ace..5808c4ef21b3 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4748,8 +4748,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>                  * swapcache, we need to check that the page's swap has n=
ot
>                  * changed.
>                  */
> -               if (unlikely(!folio_test_swapcache(folio) ||
> -                            page_swap_entry(page).val !=3D entry.val))
> +               if (unlikely(!folio_matches_swap_entry(folio, entry)))
>                         goto out_page;
>
>                 if (unlikely(PageHWPoison(page))) {
> diff --git a/mm/swap.h b/mm/swap.h
> index efb6d7ff9f30..a69e18b12b45 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -52,6 +52,25 @@ static inline pgoff_t swap_cache_index(swp_entry_t ent=
ry)
>         return swp_offset(entry) & SWAP_ADDRESS_SPACE_MASK;
>  }
>
> +/**
> + * folio_matches_swap_entry - Check if a folio matches a given swap entr=
y.
> + * @folio: The folio.
> + * @entry: The swap entry to check against.
> + *
> + * Context: The caller should have the folio locked to ensure it's stabl=
e
> + * and nothing will move it in or out of the swap cache.
> + * Return: true or false.
> + */
> +static inline bool folio_matches_swap_entry(const struct folio *folio,
> +                                           swp_entry_t entry)
> +{
> +       VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> +       if (!folio_test_swapcache(folio))
> +               return false;
> +       VM_WARN_ON_ONCE_FOLIO(!IS_ALIGNED(folio->swap.val, folio_nr_pages=
(folio)), folio);

You should cache the folio->swap.val into a local register value.
Because WARN_ON_ONCE I think the compiler has no choice but to load it
twice? Haven't verified it myself.

There is no downside in compiler point of view using more local
variables, the compiler generates an internal version of the local
variable equivalent anyway.

> +       return folio->swap.val =3D=3D round_down(entry.val, folio_nr_page=
s(folio));

Same for folio_nr_pages(folio), you should cache it. The function will
look less busy.

Chris

> +}
> +
>  void show_swap_cache_info(void);
>  void *get_shadow_from_swap_cache(swp_entry_t entry);
>  int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
> @@ -144,6 +163,11 @@ static inline pgoff_t swap_cache_index(swp_entry_t e=
ntry)
>         return 0;
>  }
>
> +static inline bool folio_matches_swap_entry(const struct folio *folio, s=
wp_entry_t entry)
> +{
> +       return false;
> +}
> +
>  static inline void show_swap_cache_info(void)
>  {
>  }
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 68ec531d0f2b..9225d6b695ad 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -79,7 +79,7 @@ void show_swap_cache_info(void)
>   * with reference count or locks.
>   * Return: Returns the found folio on success, NULL otherwise. The calle=
r
>   * must lock and check if the folio still matches the swap entry before
> - * use.
> + * use (e.g. with folio_matches_swap_entry).
>   */
>  struct folio *swap_cache_get_folio(swp_entry_t entry)
>  {
> @@ -346,7 +346,10 @@ struct folio *__read_swap_cache_async(swp_entry_t en=
try, gfp_t gfp_mask,
>         for (;;) {
>                 int err;
>
> -               /* Check the swap cache in case the folio is already ther=
e */
> +               /*
> +                * Check the swap cache first, if a cached folio is found=
,
> +                * return it unlocked. The caller will lock and check it.
> +                */
>                 folio =3D swap_cache_get_folio(entry);
>                 if (folio)
>                         goto got_folio;
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 4c63fc62f4cb..1bd90f17440f 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -240,14 +240,12 @@ static int __try_to_reclaim_swap(struct swap_info_s=
truct *si,
>          * Offset could point to the middle of a large folio, or folio
>          * may no longer point to the expected offset before it's locked.
>          */
> -       if (offset < swp_offset(folio->swap) ||
> -           offset >=3D swp_offset(folio->swap) + nr_pages) {
> +       if (!folio_matches_swap_entry(folio, entry)) {
>                 folio_unlock(folio);
>                 folio_put(folio);
>                 goto again;
>         }
>         offset =3D swp_offset(folio->swap);
> -
>         need_reclaim =3D ((flags & TTRS_ANYWAY) ||
>                         ((flags & TTRS_UNMAPPED) && !folio_mapped(folio))=
 ||
>                         ((flags & TTRS_FULL) && mem_cgroup_swap_full(foli=
o)));
> @@ -2150,6 +2148,12 @@ static int unuse_pte_range(struct vm_area_struct *=
vma, pmd_t *pmd,
>                 }
>
>                 folio_lock(folio);
> +               if (!folio_matches_swap_entry(folio, entry)) {
> +                       folio_unlock(folio);
> +                       folio_put(folio);
> +                       continue;
> +               }
> +
>                 folio_wait_writeback(folio);
>                 ret =3D unuse_pte(vma, pmd, addr, entry, folio);
>                 if (ret < 0) {
> --
> 2.51.0
>
>

