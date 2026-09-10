Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C223C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 10:26:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2750A6B0092; Thu, 10 Sep 2026 06:26:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2254B6B0093; Thu, 10 Sep 2026 06:26:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 114156B009B; Thu, 10 Sep 2026 06:26:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DF2DA6B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:26:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C5D0A04D4
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:26:47 +0000 (UTC)
X-FDA: 85197474054.28.B66EE10
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 93AB5140008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:26:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UMkwwheO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789036005;
	b=bzYpKZIIPBScZEvX1wMcz3PqBRSX789BeznNAqkD0CLeHW9vXoc7C4u+5InFnZ6BksrDHT
	5g3SzIa01OiA0uK0Gk+vdNTcYVmSUPRdVs4tYP/kihLpZT/1vY5pRqhPQRJ/creD8r0xft
	enqouZVhKgm7uuJVnoyGghANzSi53v4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UMkwwheO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789036005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DT5UfZsIsx+FkEJ4a4b5UteE31Gu0sGDdcOKTLS/7TY=;
	b=lIdcos302DKXGbI9e+fp+8FTHInUuwsdsnvDO9jvMAWrtXCkLlBnYRGSogQvfhSVOkATJx
	OEm+KlJHUWGRRdlKvRA9CiBoOGdIUGybOtC640oFeDEIVBXZNG5GhjGsFOkCUEHJWn4P1i
	ATNFyzY+YLg/wkRzQ3lHLZpsjECyYe4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D6CB60204
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:26:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 042231F0089D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789036004;
	bh=DT5UfZsIsx+FkEJ4a4b5UteE31Gu0sGDdcOKTLS/7TY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=UMkwwheOSxfsgB+2pwkb/FKbjrd/3fOSXwaMdvKXkooqrLwPV/RwcZ3p1UdEk1e8D
	 jzPOfkmVcZtp1p8CLDVhpOb5Lwfv8jLWGhamPvyqzEZyFiE2XyyMSy4AotzGN4Jjh7
	 v53dKtW4hawvCE8obnBAI/b6pU7C/p+SfSfpaV0q47ev4mQmzI2TrKKjHX4bknP4Rq
	 bP89ribbR+OL4oS6NayrV9r9DigUNNEWCVfggE9Idjw2W28NQN2uo84njhgiilRuG7
	 duPhwxFwQf3psnNdysG+UIpywYKQCTiAwCZ+JnPCA17bpEw848Rrf/5FeUtH8RpKO5
	 YypU0GRLqL9iA==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c2544ff970dso1047313266b.2
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:26:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzfD6n81bdXfyf3+ShvYQf4C6OnTpxMMpaz96Sd8Xi2pPg32MJCDHwQjOwca3yvd/qlRhLZaJFkcQ==@kvack.org
X-Gm-Message-State: AFuF++nj78USNBXqt1nU//kmtyLYoc91hKyIoo6L5k2czUmLs8qDPC5r
	ZIpxHRF9foetnwg+hg+TJ6622R4PmfnhmzXecgHD1BXzMLYwmwLyYdii5t2dinZIv2//w2xxTNi
	BuI0MKk1eHWjmjehCmDrcZvV2vf7K7Dw=
X-Received: by 2002:a17:907:1c22:b0:c26:1649:47a8 with SMTP id
 a640c23a62f3a-c26164956d1mr1492741366b.30.1789036002867; Thu, 10 Sep 2026
 03:26:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260910095449.715183-1-wangkefeng.wang@huawei.com> <20260910095449.715183-2-wangkefeng.wang@huawei.com>
In-Reply-To: <20260910095449.715183-2-wangkefeng.wang@huawei.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 10 Sep 2026 03:26:31 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMV4VrjdgwvEYX1oVGmOZOvLnKgk=1pWntrZONeea1+Pw@mail.gmail.com>
X-Gm-Features: AcwNN1Uppy8p7EXaP6t7dNjcw5vdnjFOv-8ZypbVBnCBcynvBZuxhgtOTcEqS7s
Message-ID: <CAO9r8zMV4VrjdgwvEYX1oVGmOZOvLnKgk=1pWntrZONeea1+Pw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] mm: zswap: pass type and offset to
 zswap_invalidate() directly
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Chengming Zhou <chengming.zhou@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 93AB5140008
X-Stat-Signature: yhjk9pouzfj4qowmq1r4ej3jd9zs5j96
X-HE-Tag: 1789036005-700951
X-HE-Meta: U2FsdGVkX19rzCmNCX9ud6gTisStHsVS7W9ISnlC6piR1KNemNRjSRDrQH/1s2zM6qOpXAVhAEZTN7nRz3O4BcZfVFZkPkO8POv6elRcdJxIhAVXGR+CR8k61DoPQgUlRgLNkLdZwb9r7WQPCUwalfmuITB5gnyKokRpFxL/ngSZDJvb7/XjYu8jQzuGiyRRMQKGdnDF3hC/IfnGkQXzLcIHGErhGYtR996WykX0KEbKsZ6k9VG9cGxNLTBXG0apGxOhT4jNWdEC+drKq9E7RyE22HG3Ee+pwLE9hlDeMm+HFnQ5rtBj20X4r1CUrks2tTGRGxx1ShWorGtWl4o188NRmgNgyirkHEq1xajyuQUZhfabvww4YCpnHEmMTNNy1QuvFWFJ5zxW7CqpkZ/1kuNqXsjvRVXHeua0sgmpRE5q9r5tVpmJ6R4nfip/ZCmYRzZ9rBZ6FLzonVWqtTTYXEEVWd+DGkRg928fAF9WqfWiwc2lPZSo5OrbEUMswDoiO7kAFvg4oo/HDnHhJ21MDkHkFAvlIJpE/bGsqDwgv2usWfKloi+kMmXF1KBii3PxTQbxf3+gP3KedJAvIZ0mbnOSXqFTvTxgohUNLvh5jpIL921kbvRHo9gt6rn1d/ZSTypUFfjhwB6O0tGI084o+myO47GuRS7CXAVvmPOwQwCCoY+vqE6SicjJlm72qHqFQT0Jkv22OTDcL4p6kCCj/wadN46C7G/D/9D34eJR95NUHhoDoQXR9kQGAYJ4Oged7NeK3R2GNauFvj9hawVhRnJ4BrAE5DWI0ibzGw7OCuxqX0JfPcVt195h7ohzXzwjUsptjQCSlxDXyHUOJpoqNR9IYUGCIcfaHsJxudTjimAw8ynNUWLSnfrF7mlI9KDFH63W/0fpFw8Sm7MQ01xj/PCOKWa4kcc1EuSH6w0+2q69Fuswpd4IdcP0CSIYRByVkW1Ps2GxE3jSAV6xLka
 4dSCG/za
 wSL68Vz5TvaczuPhjo4+zNX+25zXEKsLPL6l16Jt6HZXj+VKgxURLrUvjQgR20iVLeQcWbEspSSBK5hU+A4h1GeR2Q6NrI4PsfiktQ2NTp/pbzL1m0myUfchpkClivmkX7r9Td/UH9HxUz+duhfE548bGfZq5pY8z6EwmShAbv0Y7fIO+TMxz3RlnyEXbMy225gkDgfLWu09CSgmSRbiSw66a0Hxq4hNNcAvSQfFVA9/CWyI35Kj18OA5XmsAT/P8ZDHt32E9+4Z16BqWrpSGaApTr/All8MU7T05XGVNqIKsGv1nhusCngA09dSTHcItgwClnRrbhv31MNP1kKHw+BnV7VLhc+4gm3LwU4AYhKg4QNGFeMCVV9soriB2Gjz54vmq4YEv0lNNlyj4miUaKlKhojAbtrisu2MEy7+pZyz9stevezLj9owGsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 2:55=E2=80=AFAM Kefeng Wang <wangkefeng.wang@huawei=
.com> wrote:
>
> zswap_invalidate() takes a swp_entry_t only to unpack it right back
> into type and offset.  Both callers already have those values, so
> pass them directly and drop the swp_entry()/swp_type()/swp_offset()
> round-trip.
>

Suggested-by: Johannes Weiner <hannes@cmpxchg.org> ?

> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Acked-by: Yosry Ahmed <yosry@kernel.org>

> ---
>  include/linux/zswap.h |  4 ++--
>  mm/swapfile.c         |  2 +-
>  mm/zswap.c            | 14 +++++++++-----
>  3 files changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/zswap.h b/include/linux/zswap.h
> index 30c193a1207e..463bdee5c1e1 100644
> --- a/include/linux/zswap.h
> +++ b/include/linux/zswap.h
> @@ -27,7 +27,7 @@ struct zswap_lruvec_state {
>  unsigned long zswap_total_pages(void);
>  bool zswap_store(struct folio *folio);
>  int zswap_load(struct folio *folio);
> -void zswap_invalidate(swp_entry_t swp);
> +void zswap_invalidate(int type, pgoff_t offset);
>  int zswap_swapon(int type, unsigned long nr_pages);
>  void zswap_swapoff(int type);
>  void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg);
> @@ -49,7 +49,7 @@ static inline int zswap_load(struct folio *folio)
>         return -ENOENT;
>  }
>
> -static inline void zswap_invalidate(swp_entry_t swp) {}
> +static inline void zswap_invalidate(int type, pgoff_t offset) {}
>  static inline int zswap_swapon(int type, unsigned long nr_pages)
>  {
>         return 0;
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 05d3408396f9..ba71905e4d46 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1319,7 +1319,7 @@ static void swap_range_free(struct swap_info_struct=
 *si, unsigned long offset,
>         unsigned int i;
>
>         for (i =3D 0; i < nr_entries; i++)
> -               zswap_invalidate(swp_entry(si->type, offset + i));
> +               zswap_invalidate(si->type, offset + i);
>
>         if (si->flags & SWP_BLKDEV)
>                 swap_slot_free_notify =3D
> diff --git a/mm/zswap.c b/mm/zswap.c
> index a12b6452a225..420c405d0402 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -228,10 +228,15 @@ static bool zswap_has_pool;
>  /* One swap address space for each 64M swap space */
>  #define ZSWAP_ADDRESS_SPACE_SHIFT 14
>  #define ZSWAP_ADDRESS_SPACE_PAGES (1 << ZSWAP_ADDRESS_SPACE_SHIFT)
> +
> +static inline struct xarray *zswap_tree(int type, pgoff_t offset)
> +{
> +       return &zswap_trees[type][offset >> ZSWAP_ADDRESS_SPACE_SHIFT];
> +}
> +
>  static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
>  {
> -       return &zswap_trees[swp_type(swp)][swp_offset(swp)
> -               >> ZSWAP_ADDRESS_SPACE_SHIFT];
> +       return zswap_tree(swp_type(swp), swp_offset(swp));
>  }
>
>  #define zswap_pool_debug(msg, p)                       \
> @@ -1659,10 +1664,9 @@ int zswap_load(struct folio *folio)
>         return 0;
>  }
>
> -void zswap_invalidate(swp_entry_t swp)
> +void zswap_invalidate(int type, pgoff_t offset)
>  {
> -       pgoff_t offset =3D swp_offset(swp);
> -       struct xarray *tree =3D swap_zswap_tree(swp);
> +       struct xarray *tree =3D zswap_tree(type, offset);
>         struct zswap_entry *entry;
>
>         if (xa_empty(tree))
> --
> 2.55.0
>
>

