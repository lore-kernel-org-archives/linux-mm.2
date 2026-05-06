Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58F38CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 13:51:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A763C6B0088; Wed,  6 May 2026 09:51:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4E446B008C; Wed,  6 May 2026 09:51:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 963F96B0092; Wed,  6 May 2026 09:51:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8502E6B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:51:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2340E16025F
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:51:29 +0000 (UTC)
X-FDA: 84737132298.08.53A9F80
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id CB3AB40014
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:51:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Iwx5xamB;
	spf=pass (imf17.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778075487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GQza1Qz8jw2j9t4AApvNzSPjGA6SIdtXnSNRCIchmd4=;
	b=bZXbKkDB6uLPFOY2upRPmF67hMfLLhhafGAXU/sKx3CNqZCHPI3BxffEWGUKMEUoGI8/tx
	fkD/Ec1aLkCW98WVC/AK9udg2/v8fZZTGCvxdIMe+blAUDnmT2qN9ElAFbp/k2X3LIyP/L
	Cfer58mfn8i+OVFS2no80ZzwStlAZmg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Iwx5xamB;
	spf=pass (imf17.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778075487; a=rsa-sha256;
	cv=none;
	b=S3FX4ubzW0jqQiDbSmGQ90rumvZApBYvNiyZKzIaaYS5kEjyUHpz/ME3Di4brstAyfLILr
	YAgzaPrLcoHU98j31tt3ZJNqoAG6GgPLjI4/ZYf0hNS02+k7eFoOnbg3yV39Pp8uMTFa3/
	+dVSO974MJ4fWV5oNIomPHPv/A8/U3Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B3A0403BF
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614CDC2BCF6
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778075485;
	bh=/b0ojsBTR2WCYdLbzi4IPCJCWiUyBjUlEcAnhywbuVM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Iwx5xamBl1Qo/aHl/mN4MipNkk1xMJJqIo9TMK+cVhWIx5ThOt9m2yCE0w70ziSZy
	 Xy+G1h6NCVkG4GoasHcv/uckciH6dbkuyIdy2vErZ+G8Vpr9trVxfhx/zcKc8A7nvx
	 rXXTb7M7psZG6XnJGVPsgHLTIbjodDp0ASdPSeMPliHe2pAll9pZ7cyMfLGnbvJzHa
	 mwoYzOoe4X5N0XD6txT4QHOn9WkACCe639JCMLRDlbRHD0v2cGZaiXepQHHj8IoifS
	 hKzXpfe/82IuuV11DdrHhauUICgW95CmGPR5UDoifaxHg19RQV4c6W9N123yBiWTWS
	 HDy+7WBYrZg7Q==
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-65c7efdb7d8so585701d50.3
        for <linux-mm@kvack.org>; Wed, 06 May 2026 06:51:25 -0700 (PDT)
X-Gm-Message-State: AOJu0Yw0fs90DdQyiJrnM113LWg9EUlqimF+TAV/QINLWTXSqQ+y7uSy
	AQGX5uNirLfO1MfRHJxmfzdxuBpSQJNbN1VhCuojrhH97B7HXljwMdSX0RbxskzMQ7wFFAAjI9s
	HbEILggWc21mTtxbREM4/gb9otY4VxsLu2fOCe5RvtQ==
X-Received: by 2002:a05:690e:1688:b0:651:be8b:e87e with SMTP id
 956f58d0204a3-65c799989cemr4054814d50.34.1778075484164; Wed, 06 May 2026
 06:51:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com> <20260421-swap-table-p4-v3-1-2f23759a76bc@tencent.com>
In-Reply-To: <20260421-swap-table-p4-v3-1-2f23759a76bc@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 6 May 2026 15:51:13 +0200
X-Gmail-Original-Message-ID: <CACePvbVNwaU=609oJmAwqxse4WTApj30rU9hB_ym=FLjKMk2PA@mail.gmail.com>
X-Gm-Features: AVHnY4LxL-hGZWVHlEcA-yXqssU0AutiMmJTiSAT10lVjcLbKfjQy6tcLKL8zss
Message-ID: <CACePvbVNwaU=609oJmAwqxse4WTApj30rU9hB_ym=FLjKMk2PA@mail.gmail.com>
Subject: Re: [PATCH v3 01/12] mm, swap: simplify swap cache allocation helper
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CB3AB40014
X-Stat-Signature: jnt51zixe69hynzwa4oynewfpxedndcs
X-HE-Tag: 1778075486-548847
X-HE-Meta: U2FsdGVkX19vejmBQmS4utsP4njqKyO0pD2Qq76kN3WkegE81VDgnWFeI9B1w8gMr4uvpvLDCwa/5rbKCnpo8SU2Q9Pz/ArYPFnIhAApzfX6NE1vWqKN87v1OKbQo3bDSjl4s8KzHURalni/wbJ0jZwZyxeesY411ICx3rSigDW7H4qyjhCPfri+VsdsXhyDFZpfuaFg6dfqPc4qO39S/tOGN2XY1TdJyfoGf/6P7o3eHeXqhA4hGK21NlWI5kYrFgSo2JWGOiP4cLlz1/pxCDJunipuix3Z8XS7BhddRFl6iue6WynXKag2taqfPZYPd8Ba+g8cGjkEkosHBuErywQE44OkeFJqNOb7ZpCHKuCR8G5q6EcyxYvvkRtOzaIHWwXevTQgBA3t+w8NwxC/K/zjn1CTvHSPv4t5DJ3syl14vIlL5aNktg20f3TsTI6WIRXhRNRUncwvm9rbvRgOUYh5bs74vZevAsrrBnT+wpRy4RXIZzIB2GS22V8Qd52whgn6rN08rIimdbADrDwt6p+9dBU2w2TNTxA8budLO7hd1D8IdLoB3R3Am9IqSAq6kMCNQ/dHKzl2QXOpscleynz81awsrXCe2qaNztAM/1nMm+XwsiIK/cHj9WKy5Y+ioFjNyMzMsxfNLEwt423SjL4vMSob5E+1OjVvdfTFNQeq9iTp6P9S82elclb/CxueqkWPZ63/m/MtbqRLeLsdhr0ZqnAiOEGBh6VYIfXl4eZrptPax/KTcOWwjOHh4lj73EA9UAQN0EbESMEv5dA8yZYGj9XybwZYRiLD2K1uE+oecZ55X2Br+9JkbqrgNnHICQWytDJHC189lSohr9Bkb9R8oxnspOu4vBK0u8xLckKxBwKsN7XS3YLoNtIGUK3tw0m2MY/1IVqIZafLQhGEl5xwwiETICB4+VjMex9izTxBYWB5/hNGQH8q65UGk8vbnrzGz/Tq4ITiOrJKOOk
 EvBv9eoJ
 vILC8seXCmBMt+mNKFVVbmanYQDHn5HFXCVSXmNHh1mgD1ruxLt3YjsL2um95cfAy/vHuiVF6BxgSiLnw+mNWEWEo1vR+enfhtGWZmAai67M5tgZ9a71O8BhQmbrsD0ZsAv8MtPsb0dGBec+7lLzONSt/FO/V6tJmORXRR5aHc9pz/8AWT9iFSE9ZulBXZ2uXk8QsIZ83LZAtFLb0ydWOUiuRZE1bD6M+8V1vD1kr8bXsX13oeXWCNRa3DTY+KjVG3lYLhgnT0s73PsZH3Fmkpjisqpr7aE8Ssf+78umDEEbsxp5suEf3sQdrMb5SAD5nb5FHZPN/Grsy4v4vufJ5jK/oeJSdVfTOyDUglNVgIjnXtZnnvI1mxuHzVOwoGfZnNxzQoF818qZMLs0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 8:16=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Instead of trying to return the existing folio if the entry is already
> cached, simply return an error code if the allocation fails and drop the

Nitpick: Spell out which function changes the return type here. It is
__swap_cache_prepare_and_add()

> output argument. And introduce proper wrappers that handle the

Nitpick: Spell out the helper function. It is swap_cache_read_folio().
> allocation failure in different ways.

>
> For async swapin and readahead, the caller only wants to ensure that a
> swap-in read is issued when the allocation succeeded. And for zswap swap
> out, the caller will abort if the allocation failed because the entry is
> gone or cached already.

Should you add no functional change expected?

>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Very nice clean ups. I like it. Here are some nitpicks; feel free to
ignore them.

Acked-by: Chris Li <chrisl@kerel.org>

> ---
>  mm/swap.h       |   3 +-
>  mm/swap_state.c | 180 +++++++++++++++++++++++++++++---------------------=
------
>  mm/zswap.c      |  23 +++-----
>  3 files changed, 103 insertions(+), 103 deletions(-)
>
> diff --git a/mm/swap.h b/mm/swap.h
> index a77016f2423b..ad8b17a93758 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -281,8 +281,7 @@ struct folio *swap_cache_get_folio(swp_entry_t entry)=
;
>  void *swap_cache_get_shadow(swp_entry_t entry);
>  void swap_cache_del_folio(struct folio *folio);
>  struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_flags,
> -                                    struct mempolicy *mpol, pgoff_t ilx,
> -                                    bool *alloced);
> +                                    struct mempolicy *mpol, pgoff_t ilx)=
;
>  /* Below helpers require the caller to lock and pass in the swap cluster=
. */
>  void __swap_cache_add_folio(struct swap_cluster_info *ci,
>                             struct folio *folio, swp_entry_t entry);
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 1415a5c54a43..204a9499d50c 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -459,54 +459,38 @@ void swap_update_readahead(struct folio *folio, str=
uct vm_area_struct *vma,
>   * All swap slots covered by the folio must have a non-zero swap count.
>   *
>   * Context: Caller must protect the swap device with reference count or =
locks.
> - * Return: Returns the folio being added on success. Returns the existin=
g folio
> - * if @entry is already cached. Returns NULL if raced with swapin or swa=
poff.
> + * Return: 0 if success, error code if failed.
>   */
> -static struct folio *__swap_cache_prepare_and_add(swp_entry_t entry,
> -                                                 struct folio *folio,
> -                                                 gfp_t gfp, bool charged=
)
> +static int __swap_cache_prepare_and_add(swp_entry_t entry,
> +                                       struct folio *folio,
> +                                       gfp_t gfp, bool charged)
>  {
> -       struct folio *swapcache =3D NULL;
>         void *shadow;
>         int ret;
>
>         __folio_set_locked(folio);
>         __folio_set_swapbacked(folio);
>
> -       if (!charged && mem_cgroup_swapin_charge_folio(folio, NULL, gfp, =
entry))
> +       if (!charged && mem_cgroup_swapin_charge_folio(folio, NULL, gfp, =
entry)) {
> +               ret =3D -ENOMEM;
>                 goto failed;
> -
> -       for (;;) {
> -               ret =3D swap_cache_add_folio(folio, entry, &shadow);
> -               if (!ret)
> -                       break;
> -
> -               /*
> -                * Large order allocation needs special handling on
> -                * race: if a smaller folio exists in cache, swapin needs
> -                * to fallback to order 0, and doing a swap cache lookup
> -                * might return a folio that is irrelevant to the faultin=
g
> -                * entry because @entry is aligned down. Just return NULL=
.
> -                */
> -               if (ret !=3D -EEXIST || folio_test_large(folio))
> -                       goto failed;
> -
> -               swapcache =3D swap_cache_get_folio(entry);
> -               if (swapcache)
> -                       goto failed;
>         }
>
> +       ret =3D swap_cache_add_folio(folio, entry, &shadow);
> +       if (ret)
> +               goto failed;
> +
>         memcg1_swapin(entry, folio_nr_pages(folio));
>         if (shadow)
>                 workingset_refault(folio, shadow);
>
>         /* Caller will initiate read into locked folio */
>         folio_add_lru(folio);
> -       return folio;
> +       return 0;
>
>  failed:
>         folio_unlock(folio);
> -       return swapcache;
> +       return ret;
>  }
>
>  /**
> @@ -515,7 +499,6 @@ static struct folio *__swap_cache_prepare_and_add(swp=
_entry_t entry,
>   * @gfp_mask: memory allocation flags
>   * @mpol: NUMA memory allocation policy to be applied
>   * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
> - * @new_page_allocated: sets true if allocation happened, false otherwis=
e
>   *
>   * Allocate a folio in the swap cache for one swap slot, typically befor=
e
>   * doing IO (e.g. swap in or zswap writeback). The swap slot indicated b=
y
> @@ -523,18 +506,40 @@ static struct folio *__swap_cache_prepare_and_add(s=
wp_entry_t entry,
>   * Currently only supports order 0.
>   *
>   * Context: Caller must protect the swap device with reference count or =
locks.
> - * Return: Returns the existing folio if @entry is cached already. Retur=
ns
> - * NULL if failed due to -ENOMEM or @entry have a swap count < 1.
> + * Return: Returns the folio if allocation succeeded and folio is added =
to
> + * swap cache. Returns error code if allocation failed due to race.
>   */
>  struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
> -                                    struct mempolicy *mpol, pgoff_t ilx,
> -                                    bool *new_page_allocated)
> +                                    struct mempolicy *mpol, pgoff_t ilx)
> +{
> +       int ret;

Nitpick: Suggest renaming it to "err" to make it obvious that it is an
int type for the error code. Because this function previously returned
a folio pointer, I have to remind myself that it is an int type not a
folio.

> +       struct folio *folio;
> +
> +       /* Allocate a new folio to be added into the swap cache. */
> +       folio =3D folio_alloc_mpol(gfp_mask, 0, mpol, ilx, numa_node_id()=
);
> +       if (!folio)
> +               return ERR_PTR(-ENOMEM);
> +
> +       /*
> +        * Try to add the new folio to the swap cache. It returns
> +        * -EEXIST if the entry is already cached.
> +        */
> +       ret =3D __swap_cache_prepare_and_add(entry, folio, gfp_mask, fals=
e);
> +       if (ret) {
> +               folio_put(folio);
> +               return ERR_PTR(ret);
> +       }
> +
> +       return folio;
> +}
> +
> +static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
> +                                          struct mempolicy *mpol, pgoff_=
t ilx,
> +                                          struct swap_iocb **plug, bool =
readahead)
>  {
>         struct swap_info_struct *si =3D __swap_entry_to_info(entry);
>         struct folio *folio;
> -       struct folio *result =3D NULL;
>
> -       *new_page_allocated =3D false;
>         /* Check the swap cache again for readahead path. */
>         folio =3D swap_cache_get_folio(entry);
>         if (folio)
> @@ -544,17 +549,24 @@ struct folio *swap_cache_alloc_folio(swp_entry_t en=
try, gfp_t gfp_mask,
>         if (!swap_entry_swapped(si, entry))
>                 return NULL;
>
> -       /* Allocate a new folio to be added into the swap cache. */
> -       folio =3D folio_alloc_mpol(gfp_mask, 0, mpol, ilx, numa_node_id()=
);
> -       if (!folio)
> +       do {
> +               folio =3D swap_cache_get_folio(entry);
> +               if (folio)
> +                       return folio;
> +
> +               folio =3D swap_cache_alloc_folio(entry, gfp, mpol, ilx);
> +       } while (IS_ERR(folio) && PTR_ERR(folio) =3D=3D -EEXIST);

Nitpick: IS_ERR() only checks that the pointer is in the error code
range. If the pointer is -EEXIST, it will always be in the error code
range. I think the "IS_ERR(folio)" test can be dropped.

Chris

