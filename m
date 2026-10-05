Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AE71CA5FF5
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 20:18:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C56D6B0088; Mon,  5 Oct 2026 16:18:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49DBB6B008C; Mon,  5 Oct 2026 16:18:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B4396B0095; Mon,  5 Oct 2026 16:18:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 125646B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 16:18:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A60B1A70C1
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 20:18:39 +0000 (UTC)
X-FDA: 85289685558.24.2E301DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id D14D840008
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 20:18:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vib4knmL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791231517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aY2j7X8wBXJnkUSvdFrO7hrVLgYV9VQvfdE75ziBQEw=;
	b=4lw3kpyEdlWS6uGPT1se3s1dIfq1RPxtiWl3OQB8PZs05uDj9JJX/Uw/pEv1ZCDHbT1ywG
	ynXoULZVz27vEHOOpFQKNmbHbqFE2NOYh0pVKsWLpb4rPo4aH43sMnYRE6qMHrsBDrZZ6x
	XBOUwfGqUFqWHinnrTDfY9JziQh83CE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vib4knmL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791231517;
	b=iqjyuuzFVh+vfBDPBs78po5Nm9pEACdHfavrhJelExgydl5ly2dcZ5j4kqHIeeLFGF43Wz
	ruaJQeZyhRevdnfb0BppCbwJELz5FRfg/YyqFGsk7ieG5ggp2I13NkVEfvnHDOMT7tjxnM
	h2Qe/wBwTdN+hWCG4NJpTT3LzOeg50U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 116B9601FB
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 20:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09BC1F008BF
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 20:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791231516;
	bh=aY2j7X8wBXJnkUSvdFrO7hrVLgYV9VQvfdE75ziBQEw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Vib4knmLGfUAovO3FFzzs1eZAaIJw1IddjkmwyiDgQB/MHE4iE7ZzjBsfBVIiC/K5
	 uMvB4Ih45YfMJ0uT7vzUqJJerb6guypqGS3ddEJXhJzj2DWye+4QxlyrAz+ooirKq0
	 9ClIlMWFiSwppQl48oAN8OghNE8n7MuDoy/U86vgMUo6V3NuvCg7JNBkrRZwrGHZMO
	 NxvI0nIcgXJttMsZAWJdscctsveqoI3CTudqUJHb0xexiuEYAeCUVdvGz49FT2OG3A
	 Jul3VE6F24zADMyXM2cmZCyEb3FkKrozHKNrGr2/Eqi26XLOGtaavDdcB7vpIsSNLW
	 TAoFKgVHPPOUw==
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a9984f9adcso3293385a12.0
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 13:18:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByxqSpxJvIqHPDNkIc8E6nup3uEgGe8yEay/PeGXtwqGRX81b+xPf9KQrk5/ReRGGWdXM85nYT9zQ==@kvack.org
X-Gm-Message-State: AFuF++msi/UZsCo+LXHWT17J0grw2gEu7VADji3PNZNR9kICZS5aMaYy
	u2pWcd51wE/R0BiCVNI6h7cnZglOy925SQujR8TJxES8LHT5eDJ1sUjx90E/kmfU3MCQtqFrwo1
	BIg5Sq81PsxV612njhAio/+Y7b9hTwuc=
X-Received: by 2002:a17:907:3f95:b0:c25:32b0:e56c with SMTP id
 a640c23a62f3a-c2e4a95e407mr977900466b.4.1791231515414; Mon, 05 Oct 2026
 13:18:35 -0700 (PDT)
MIME-Version: 1.0
References: <20261002095503.3585565-1-usama.arif@linux.dev> <20261002095503.3585565-15-usama.arif@linux.dev>
In-Reply-To: <20261002095503.3585565-15-usama.arif@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 5 Oct 2026 13:18:24 -0700
X-Gmail-Original-Message-ID: <CAO9r8zN+9F0yh0bTDsysumziGc=zgs7vZMLvt-nWPhxq36wT0Q@mail.gmail.com>
X-Gm-Features: AclHuK-vsi3EfpgIHJBHYD0tDXS4EbYOA2yKu19KkRG6I9OLgQqCV9dXUAiOl5Y
Message-ID: <CAO9r8zN+9F0yh0bTDsysumziGc=zgs7vZMLvt-nWPhxq36wT0Q@mail.gmail.com>
Subject: Re: [PATCH v8 14/30] mm: zswap: reject high-order swap cache
 allocations backed by zswap
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, chrisl@kernel.org, 
	kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org, 
	ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>, willy@infradead.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, 
	shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org, 
	dev.jain@arm.com, baolin.wang@linux.alibaba.com, 
	Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, 
	Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	nphamcs@gmail.com, shikemeng@huaweicloud.com, qi.zheng@linux.dev, 
	luizcap@redhat.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qunb7my3qm1aqpjhpsz3f648jorffmw9
X-Rspam-User: 
X-Rspamd-Queue-Id: D14D840008
X-Rspamd-Server: rspam08
X-HE-Tag: 1791231517-612732
X-HE-Meta: U2FsdGVkX19G9ga5k1uYQSXq4ySi+g4tDWGH8WyG+K0PwrLMyoo3EI/o2buAcOmG+qqJlJUcDwV9p29ZbHzvVLB7MC88PxdoHXrlOBveieYGpt0E2XIVKkAY/CS1g01mq86WT4HATRJgcw5obg2m4mzh0vG/Mtb5aPzRcVnBT3wGdmV36pvaGSWTgIG0QbjZECEB7wm8uX8h+j2Fb9y87n06+KVGnvUcfqN8RzIjFFrcbMoe4HuwyCOSd8zoB/JU43llJy8TUsrLrd1AQMvi483Vc6mNNUY9vOXufLXNZu9YPD23O2XsB04zKxPeeR+JyFZSLpXUYC7XmTP7lKkYH8F9RNDeBZKfnklsgNMnzJh2AWG/Vdl+UReyf7ONsilWUJH+4l57sQQspHylFgRnpMxraYd12ae4iqCBixvlstpFztu37uYsjtdsDHySrl9qWmYqRqjwz9PkU9zvnEBArqipYiK0JSbzCnKQKxW5dr0hXtNFw2WsrqnUz7Fefsoy4WfkrnxR7uHeeaaNut172WBp7MkR/j6nI1Ouc3lCSWeZKWdJ7SUiZ7kjdtuMK/1CsUHz2EGbU4D8lSeSJpnsBM2LNVK66CRuKxtmupk24YbSiqZrHFNaEq+zOXFN/vV+8BO0VMUQl5zFITVnHJNf1YvsYYa0W5YNp0PVmn6Q56n5x/9mPIM5HY2rdzxvme/elTHMYTbYj7au2cmJ2hYdqWX9wpuPM8nk4kCxFvv8VHvHfyJKSMDnUy//XE54EVQdTXO0JtXwnOVf+gn6Js3MaTSJUCW66pqgNeFEAJiVfIv89DmGvshTyW31MHhEOJ5mw2hqy+rFFsoqd9Pu7mkB7MEIKBQPFrUPjSVD5vL94QhzeKyMfsK5US9viNqgN7VJbCKCbaUq3cjXjXhmt86Ty5cZiTSyz64hQ3WfmIvN2UwmhaaZLJvW0Da0uqGniI63sbUQxDGPpb5x4Wplyjw
 fxDcaYjp
 Tx1uWADsb5jOSdcnJQzcXBD/NS6IrmJk353he1tE++BPeHrdK9lyhyrhehcnL9mbC8eBFckZyWr6qDdeQZxt5mLRj8EmKZNj/Zqj0bHm92F4nUXncbrGRrQub6CRch+Rc7Km45IT4sVBPcDxi3xc7C55weH4qxG1IWjO0V4npZV4nOP128fQKsfsI1FZ5i+EuMXHKQQpfOJnD1sHGl1UnRl++sh4rwpnQ/r0nlea0CCJoi9szn40u+oBlGX8BGPH9OevIJH3NyURgyrsdpdVbCxL+O1PH0qufXekw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 2, 2026 at 2:56=E2=80=AFAM Usama Arif <usama.arif@linux.dev> wr=
ote:
>
> zswap stores swapped-out pages one at a time, so a range of swap slots ca=
n
> be split between zswap entries and the backing device. A high-order
> swap-cache folio over such a range cannot be read back in one go: the dis=
k
> read would return stale or zero data for every slot zswap owns.
>
> Reject that in __swap_cache_alloc(). Do the check after the folio is in t=
he
> swap cache: from that point zswap can neither start storing nor start
> writing back any slot in the range, so the answer is stable. Callers
> already fall back to order-0, which zswap_load() handles per page.
>
> Export zswap_is_present() for the PMD-order swap-in users added later.
>
> Co-developed-by: Alexandre Ghiti <alex@ghiti.fr>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Overall looks good, but I think it can be split into 3 patches (one of
which doesn't have to be part of this series), see below.



> ---
>  include/linux/zswap.h |  6 ++++++
>  mm/swap_state.c       | 39 +++++++++++++++++++++++++--------------
>  mm/zswap.c            | 12 +++++++++---
>  3 files changed, 40 insertions(+), 17 deletions(-)
>
> diff --git a/include/linux/zswap.h b/include/linux/zswap.h
> index df6cafbe95dc0..94746fb71bb65 100644
> --- a/include/linux/zswap.h
> +++ b/include/linux/zswap.h
> @@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
>  void zswap_folio_swapin(struct folio *folio);
>  bool zswap_is_enabled(void);
>  bool zswap_never_enabled(void);
> +bool zswap_is_present(swp_entry_t entry, unsigned int nr);
>  #else
>
>  struct zswap_lruvec_state {};
> @@ -73,6 +74,11 @@ static inline bool zswap_never_enabled(void)
>         return true;
>  }
>
> +static inline bool zswap_is_present(swp_entry_t entry, unsigned int nr)
> +{
> +       return false;
> +}
> +
>  #endif
>
>  #endif /* _LINUX_ZSWAP_H */
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 625c185a1ca4d..251b48b2c60e1 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -12,6 +12,7 @@
>  #include <linux/kernel_stat.h>
>  #include <linux/mempolicy.h>
>  #include <linux/swap.h>
> +#include <linux/zswap.h>
>  #include <linux/leafops.h>
>  #include <linux/init.h>
>  #include <linux/pagemap.h>
> @@ -466,26 +467,27 @@ static struct folio *__swap_cache_alloc(struct swap=
_cluster_info *ci,
>         __swap_cache_do_add_folio(ci, folio, entry);
>         spin_unlock(&ci->lock);
>
> +       /*
> +        * Now that the folio is in the swap cache, zswap can no longer s=
tart
> +        * storing or writing back any slot in the range, so this is a st=
able
> +        * answer. Reject a high-order allocation over a range that alrea=
dy
> +        * has per-page zswap entries.
> +        */
> +       if (order && zswap_is_present(entry, nr_pages)) {
> +               err =3D -EBUSY;
> +               goto delete_folio;
> +       }
> +
>         if (mem_cgroup_swapin_charge_folio(folio, memcg_id,
>                                            vmf ? vmf->vma->vm_mm : NULL, =
gfp)) {
> -               spin_lock(&ci->lock);
> -               __swap_cache_do_del_folio(ci, folio, entry, shadow);
> -               spin_unlock(&ci->lock);
> -               folio_unlock(folio);
> -               /* nr_pages refs from swap cache, 1 from allocation */
> -               folio_put_refs(folio, nr_pages + 1);
> +               err =3D -ENOMEM;
>                 count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK_CHARGE);
> -               return ERR_PTR(-ENOMEM);
> +               goto delete_folio;
>         }
>
>         if (order > 1 && folio_memcg_alloc_deferred(folio)) {
> -               spin_lock(&ci->lock);
> -               __swap_cache_do_del_folio(ci, folio, entry, shadow);
> -               spin_unlock(&ci->lock);
> -               folio_unlock(folio);
> -               /* nr_pages refs from swap cache, 1 from allocation */
> -               folio_put_refs(folio, nr_pages + 1);
> -               return ERR_PTR(-ENOMEM);
> +               err =3D -ENOMEM;
> +               goto delete_folio;
>         }
>
>         /* memsw uncharges swap when folio is added to swap cache */
> @@ -499,6 +501,15 @@ static struct folio *__swap_cache_alloc(struct swap_=
cluster_info *ci,
>         /* Caller will initiate read into locked new_folio */
>         folio_add_lru(folio);
>         return folio;
> +
> +delete_folio:
> +       spin_lock(&ci->lock);
> +       __swap_cache_do_del_folio(ci, folio, entry, shadow);
> +       spin_unlock(&ci->lock);
> +       folio_unlock(folio);
> +       /* nr_pages refs from swap cache, 1 from allocation */
> +       folio_put_refs(folio, nr_pages + 1);
> +       return ERR_PTR(err);

Nit: You can pull the refactoring into a separate patch (as well as
most zswap changes, see below), so that this patch only has the
logical change to bail for higher orders if any entry is in zswap.

>  }
>
>  /**
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 507f2d19fd2a4..f5b5827d30084 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1587,11 +1587,14 @@ bool zswap_store(struct folio *folio)
>   * @entry: base swap entry of the range
>   * @nr: number of contiguous slots to check
>   *
> - * Context: The caller must keep the range pinned, otherwise the answer =
can
> - * change under it.
> + * Context: Unless the caller keeps the range pinned, the answer is only=
 a
> + * hint: zswap can store or write back a slot right after this returns. =
A
> + * caller that needs a stable answer must pin the range first, as
> + * __swap_cache_alloc() does by inserting the folio into the swap cache =
before
> + * asking.

I would rather avoid naming specific functions as it will go stale
quickly, and instead list the ways of "pinning" a range.

Also, generally, the changes to mm/zswap.c seem orthogonal to this
patch and can be a separate patch (which would be clearer if
__swap_cache_alloc() isn't named here).

>   * Return: true if at least one slot in the range is in zswap.
>   */
> -static bool zswap_is_present(swp_entry_t entry, unsigned int nr)
> +bool zswap_is_present(swp_entry_t entry, unsigned int nr)
>  {
>         pgoff_t offset =3D swp_offset(entry);
>         struct xarray *tree =3D swap_zswap_tree(entry);
> @@ -1605,6 +1608,9 @@ static bool zswap_is_present(swp_entry_t entry, uns=
igned int nr)
>          */
>         BUILD_BUG_ON(SWAPFILE_CLUSTER > ZSWAP_ADDRESS_SPACE_PAGES);
>
> +       if (zswap_never_enabled())
> +               return false;
> +
>         return xa_find(tree, &index, offset + nr - 1, XA_PRESENT);
>  }
>
> --
> 2.53.0-Meta
>

