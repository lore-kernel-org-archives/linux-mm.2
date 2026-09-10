Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66CF0C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:08:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 631366B008C; Thu, 10 Sep 2026 10:08:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E3456B0092; Thu, 10 Sep 2026 10:08:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D3C36B0093; Thu, 10 Sep 2026 10:08:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 284906B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:08:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 88AA4804F8
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:08:49 +0000 (UTC)
X-FDA: 85198033578.24.1B9705C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id AEE2A8000B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:08:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VFZ2JYMd;
	spf=pass (imf30.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789049327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nalOjChM3Z2tQgZpilNTEMr06+mMo1Js7KUd8Ng5L/A=;
	b=g4lf5SVmMM8ek7tUmOBgh5MqiYRRERRA04UJc2G7cZ20VIXDSfzQkD0Q9s9AX3df9rYcnK
	oFinVWWwSyye87sLZhhLacj3k9uCUHEaYTFdvLJgwEtxWBFoGSrzWv/jRUxGVGffwml2fG
	8pNxW1fDFg3PjX/ZRpOe2JGkXTctxHk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789049327;
	b=69oPrg1L5NHMQHjQyev3UZTzmAuJE7lIlnhqRSUGo/0lzKFdJaP3qzxJCrS9SQsCvHLIOJ
	KyrxdofH8mG5SZvql8NcmJ2NVQnmFSaaSPmRbnfwqecDCtEQRxZvWuGfDPnzUL6qqcjvN6
	6fyJUwkIQyRDdPwQLDeM7UJnVw8J0WM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VFZ2JYMd;
	spf=pass (imf30.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A01460200
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D544D1F00899
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049326;
	bh=nalOjChM3Z2tQgZpilNTEMr06+mMo1Js7KUd8Ng5L/A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VFZ2JYMdHmA4+G1bGiXklCchhEAxK1BZ5FSNLI1MhzMklu4JMeSM12iMzlP2MBBm1
	 Phlt1fDVXt/TW07R4RMX2h7CXQjtZ+ONRDGD2UXxG9WvLrSqqhJj8WBGb0aNmIcsPa
	 0ZQXU5ujzYOR92KnwHC7/iIOzaMuVpJ2iyAnf/8I71b5Y0gFUY2E5pzZiGSz2tW+IC
	 J5P9GUNYj27yqnkFeIQgHPmsYNUsRyIknzmn7PHTfyBG1gX3hnWkb0aR9oFIHqAS8i
	 Tzm1/xJAF/Ic73Ps5d6urEQN0GRWLA/H9qvL1Af/UJNzzDr1Jpr1dsG7tbzzAKECvv
	 7Yo2KTQxgXnAw==
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f9f0b1fso350017066b.2
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:08:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByVT14ezoXpZ5OCXlmPX2USdokclgFBqdvq+RatdW50S/bvHd8A8uLtUXKzBuHrEuoyWFzCFdLw9Q==@kvack.org
X-Gm-Message-State: AFuF++mtBPYr1atB2cdVYErfSRklqYsJoye1FwVsypfTPjubz1avQ7Ho
	6SGgZof2NXPQAF0QQsxD6GKJZxsl4NL8e3iED03VluNCJrqZ/iDP6lW7sCPBLFh6eutXj0l9Npw
	zBhvqB3tS0A1Le1z1frtDmt/QEqufBho=
X-Received: by 2002:a17:907:a893:b0:c25:5114:c832 with SMTP id
 a640c23a62f3a-c292adecc24mr945550266b.3.1789049325716; Thu, 10 Sep 2026
 07:08:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260910123544.818146-1-wangkefeng.wang@huawei.com> <20260910123544.818146-2-wangkefeng.wang@huawei.com>
In-Reply-To: <20260910123544.818146-2-wangkefeng.wang@huawei.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 10 Sep 2026 07:08:34 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOaG_vtGT3D7zgNJv7S9ZS6bQc0H31Mj5MzGvYfp=HagQ@mail.gmail.com>
X-Gm-Features: AcwNN1WWm3X2S9OKaXerxq87cgIQjLgi2Xe25Rw5L40gYYzC1J9xgAL7hgkwHLI
Message-ID: <CAO9r8zOaG_vtGT3D7zgNJv7S9ZS6bQc0H31Mj5MzGvYfp=HagQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] mm: zswap: convert zswap_invalidate() to take a range
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Chengming Zhou <chengming.zhou@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: kfiq5b41iwx5y1jo9qecmeoq9c9er97k
X-Rspamd-Queue-Id: AEE2A8000B
X-HE-Tag: 1789049327-762862
X-HE-Meta: U2FsdGVkX19vFeC38wNbMmDqnF8fDm8pi6FlQoYCfj8YbR5P/7YKunbhd73wDRmdkrNKyYa4s3oKM9LN4+UJH5N68A/jX2oUgGuRTIe6rmWvDHsbu2uWsMXMwBl7bXSuXvVOCZReo7GdBhgKrMLAxLmD6JabkrFMgjyUMcY+l5L2e8GF2SR4AyyVkI7qrIT0Z6ca/PObVTVDjU1cIzHsou0yWbtS+tS1lSJ6EgK+vTYGPHAcqNeRFdbA+bqhO2MTpITMJoZq5wg7xAYYB5YQ6wx1owzvTMWmBaa2qbSC3foFTK/oFju4NrYJ/pE7/OyuVGpDrT3Z/neP4P2lvSFsWnCOBnMGUH9iQXmSW4X8qaTfr5yDyCifjcO8mRNQaOSYkKsFgXwpJcs2yCG9r0RbIuvEuerFXkHiZsGCsGEq5d6io/lp6QicMzC2vc26Y0E3BEXCblrPYFgXqta9PUnqgYGax9/Wd2N+yAQynJhQ7CbejmpYlobNNk1Qo3AIUlEsoVYBOlOFFuVROf2zWCoOfZBg0I4vjtohFMYUQkDBkxJAQ90TgGZXhLdIMGOyH7tHDh3PZ4XsRrki7/bYj9f6LH205q0mw7NlbcEl0quIn7Qk7k1JQn/zB2Xmn96RlY0ahtx8+wXS7OhGiwm8Z6JFop1r5meOhVwIm3SfxC3aRLMLulIDHrFxPMBYPV1Y/ClJs3yKBwvZXdb/gs/MWR7069Cu89jCXnhtXiJiKDO6GSnAfND9HK96U1LIK2KBSEKr+PmSuPQe88DIGwXggERAQQmEmVonJPnc4ACJpZcKj9ShqqcadzZD6joA0XB1WlBXfaa8cUxDR+pmZFQP4icfY6MT/K67c5V4wOinXEDRQR9Ys6Y6fxrkFdD7m1Pqtb+0Wmx2nJlDWUGFy7I3F0c0aPoAJ4fniiz4QnXO3dsTnlGu2DXWXlcYRwZNBZVyGvgT3JbiAFfiZoKXB8Ms8q5
 8X+JNjZo
 TW0KOL+2lvTHBxbzj/cSwM7nwMA2tw0i78qYINnTSTQjGdFG0fQzlxF9q23gkI1r7JtIAjA6J9ghiJG3DnGuK7LVRJF+8iF8ObFVI0s3vCAu0Ux/470GBkfpGAavzgWxk3Io7HeG+BKqiBIVYHZJIUkEGpJTbxTE6yShnSmYna7Gi9PtSiyZhLqZyth5ErNxEyeF6HbYxUYySr4mVQCqNTWlOyWcg/4s0z6rXLoncJnLvbmYmG4V79V3uS1fg3u1PJ0HNcyNJP/qsygm3CAOXRHWKIgH0mJPsyxu/VcEM6cRxBzvcqxk/PP53Pirxkns1bowJZ4Wpk773eSCxrjl6ffActeFY5QNU99Q8GKltCEhvBwAbLX2GsE7+CfPG7TSGHQQUDmxEXfSNkCgdLoKllLbrwLCnhke+g7iWVjlWVRR3M9wpZWsCFgGonQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 5:36=E2=80=AFAM Kefeng Wang <wangkefeng.wang@huawei=
.com> wrote:
>
> zswap_invalidate() takes a swp_entry_t only to unpack it right back
> into type and offset, and both callers already have those values in
> hand. Pass type, offset, and nr_entries directly so swap_range_free()
> can invalidate an entire range in one call instead of looping in the
> caller.
>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Acked-by: Yosry Ahmed <yosry@kernel.org>

> ---
>  include/linux/zswap.h |  8 ++++++--
>  mm/swapfile.c         |  4 +---
>  mm/zswap.c            | 29 +++++++++++++++++++----------
>  3 files changed, 26 insertions(+), 15 deletions(-)
>
> diff --git a/include/linux/zswap.h b/include/linux/zswap.h
> index 30c193a1207e..df6cafbe95dc 100644
> --- a/include/linux/zswap.h
> +++ b/include/linux/zswap.h
> @@ -27,7 +27,7 @@ struct zswap_lruvec_state {
>  unsigned long zswap_total_pages(void);
>  bool zswap_store(struct folio *folio);
>  int zswap_load(struct folio *folio);
> -void zswap_invalidate(swp_entry_t swp);
> +void zswap_invalidate(int type, pgoff_t offset, unsigned long nr_entries=
);
>  int zswap_swapon(int type, unsigned long nr_pages);
>  void zswap_swapoff(int type);
>  void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg);
> @@ -49,7 +49,11 @@ static inline int zswap_load(struct folio *folio)
>         return -ENOENT;
>  }
>
> -static inline void zswap_invalidate(swp_entry_t swp) {}
> +static inline void zswap_invalidate(int type, pgoff_t offset,
> +               unsigned long nr_entries)
> +{
> +}
> +
>  static inline int zswap_swapon(int type, unsigned long nr_pages)
>  {
>         return 0;
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 05d3408396f9..891379c95a01 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1316,10 +1316,8 @@ static void swap_range_free(struct swap_info_struc=
t *si, unsigned long offset,
>  {
>         unsigned long end =3D offset + nr_entries - 1;
>         void (*swap_slot_free_notify)(struct block_device *, unsigned lon=
g);
> -       unsigned int i;
>
> -       for (i =3D 0; i < nr_entries; i++)
> -               zswap_invalidate(swp_entry(si->type, offset + i));
> +       zswap_invalidate(si->type, offset, nr_entries);
>
>         if (si->flags & SWP_BLKDEV)
>                 swap_slot_free_notify =3D
> diff --git a/mm/zswap.c b/mm/zswap.c
> index a12b6452a225..79a66093d7ec 100644
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
> @@ -1659,18 +1664,22 @@ int zswap_load(struct folio *folio)
>         return 0;
>  }
>
> -void zswap_invalidate(swp_entry_t swp)
> +void zswap_invalidate(int type, pgoff_t offset, unsigned long nr_entries=
)
>  {
> -       pgoff_t offset =3D swp_offset(swp);
> -       struct xarray *tree =3D swap_zswap_tree(swp);
>         struct zswap_entry *entry;
> +       struct xarray *tree;
> +       unsigned long i;
>
> -       if (xa_empty(tree))
> -               return;
> +       for (i =3D 0; i < nr_entries; i++) {
> +               tree =3D zswap_tree(type, offset + i);
>
> -       entry =3D xa_erase(tree, offset);
> -       if (entry)
> -               zswap_entry_free(entry);
> +               if (xa_empty(tree))
> +                       continue;
> +
> +               entry =3D xa_erase(tree, offset + i);
> +               if (entry)
> +                       zswap_entry_free(entry);
> +       }
>  }
>
>  int zswap_swapon(int type, unsigned long nr_pages)
> --
> 2.55.0
>
>

