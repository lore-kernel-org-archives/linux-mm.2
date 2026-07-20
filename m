Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BC39C44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 375FC6B0088; Mon, 20 Jul 2026 05:12:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34D9F6B008A; Mon, 20 Jul 2026 05:12:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 263E56B008C; Mon, 20 Jul 2026 05:12:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0359B6B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:12:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7E8A914071F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:12:02 +0000 (UTC)
X-FDA: 85008588084.08.8DB619E
Received: from lgeamrelo11.lge.com (lgeamrelo11.lge.com [156.147.23.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6C6D740005
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:11:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.51 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784538720;
	b=I63rtx+/lQQeYNU+MmJKbywCHQmooy4SvFIa8iecVeoQC1hNpuE7gNhWQHWU5Pb1xL2tNf
	ZlOUXPzep3TP10kHUKcljstJpvSeo3HNKPlYhDGALZqesChdtT0WQ0fSkKTYpoIjhboAnr
	M9oQBDuynJfL7wF3UefcZZrQwNmjwbE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.51 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784538720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PnmzFgZfhE1Jp7fyBRSesXFLlfdtMYnvxjhosjCEu4c=;
	b=NutTv6pn+QPjFhX0fw+Yohwcm9W9GuS4GkycV6WNozjqkFE/7Fu+ZTVbNW9WUxb0mmeZ9o
	0F3Ub9q9LYtygVhIbAPcEPgB6nemXy8kt3cJqwJtdV/Xa4Rzcqeo2Hd7Cf7EShgjoqvprn
	yDDGd+YS0wGLRDQhwMPu8us5xl4wW+Y=
Received: from unknown (HELO lgeamrelo01.lge.com) (156.147.1.125)
	by 156.147.23.51 with ESMTP; 20 Jul 2026 18:11:54 +0900
X-Original-SENDERIP: 156.147.1.125
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.125 with ESMTP; 20 Jul 2026 18:11:54 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Mon, 20 Jul 2026 18:11:54 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: chrisl@kernel.org, kasong@tencent.com, nphamcs@gmail.com,
	baoquan.he@linux.dev, baohua@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mm, swap: Fix potential NULL dereference when trying
 a sleep table allocation
Message-ID: <al3mWmCN3lNv8jMu@yjaykim-PowerEdge-T330>
References: <20260720071342.50742-1-shikemeng@huaweicloud.com>
 <20260720071342.50742-2-shikemeng@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260720071342.50742-2-shikemeng@huaweicloud.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6C6D740005
X-Stat-Signature: osaw8t4qpmskxqiakcn67srtjs57x1ut
X-HE-Tag: 1784538719-648944
X-HE-Meta: U2FsdGVkX1++pVOAxXKUo519Sssrjv3DoTgzCASnGzq62RrSRkhV27x9bKe6tNfhxIYdLdFBhgjtsGcg/KYjNrxdVb/rVsYLNQyDZCFKhiAHWEw8FTTJDY+nv8pKMVFSmE5sqZAJeCVvq8V/xB/YdCKPUw6YXzgyx/zsUpNPvoyVcezni9b+Eidkm2bTZrrkNeNKkXyHSpm4diI4L0G0qvzHxfAudJsJHL+HK9PZDXqfppQNb/S4OLMLFbm8WPL7fQ3/N5IQPd4B09WIAMykZ4nF1Acg8pr6199lTSPmiHH+dlP6u4FVpBWjdVuPwNjqBAdKdauBpFhhyHg884KtyW7trZOpr26fv0SdaPQZIyrebCsd5zBjVFIw98s8aWKEnMHRIZIQThVIs2NgYRfsVdc7RoprEK8DEGT7jV69Jo2Q53FsUKGY30B9ksQqIQYawXEbWKS2EHN3/QeXBAjQY0EpsClabA6q9KcA3R+vN9TsWdS6PCHAZmEbII0TaWPzV+KiqnkPHVvfwV5towQdSUS0u1cScs9doV3rpUCz8UhEVilSKfzTOhUtIrfuLePevQ3Mz0GlWk37xHDHu9SZL73kQjHyiY+UxDaE0CgtSVj0PT3lsTzm6z0d0vDcfFV4B0jPRSshAtx3CE4pCq2cUsO+mgJbHVURk6iuxa44mOft2KfFgJL4gMbpMtsgRo+JYhOaU/zqOroSXrv75RDkBvAOdGjmp2IjR9RZblUODQXRuLI8EJZs31W2hK1lbE2WolWfYYU6dG8fTV/6PBhI5GLVeOd+6aGCVLoDc9NqdXiLODIfgUM0YcF+MjeDtAy/9E/Vps7wEXGTKA87Ic/Lcy6UbANTKXjzbhJPehXmZ6J+/7YaJeXpphFgucBbG7yZOjBN7iDVHntWlIm7Z1iijTu1ZTwGNSZOCJdHsiLkMGXjMzqJC4rCSMhKhG9VzGnsosRvD5NxoOTSpDj9w2Z
 B0Tw2wWi
 5KVi2lbGn97xwifsO60QESNmchPsJIjMtbAlMcq4GLwiOTsuOqpUYRlZk8+88rPwR8DPzkTK74MfDeYnM9SsUIUNokqKW6Lxu5vFOWK/ttVyfY7AbDMgWdisT/afnNZ4Ue4bjlYUBCR0mCvO/EgjsEyTPHZc0KXz5rXTGkX/+fMk3TXKN+gMVIEzqwtkrI+0czfGQiuuMrNhIzqLGf/xSmn3iWG9Ta/2i8377kQw1cU5JRqU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 03:13:39PM +0800, Kemeng Shi wrote:

Hello Kemeng Shi,

Good catch!

it indeed looks like a possible race condition 
(though I haven't verified it at runtime either).

> The root cause of this issue is because multi-tables are updated in non
> atomic context. To be more specific, the issue could be triggerred as
> following:

Here the cluster is isolated (CLUSTER_FLAG_NONE).

> swap_alloc_fast         swap_cluster_populate()
>                          /* Try a sleep allocation */
>                          spin_unlock(&ci->lock);

And from here, the table becomes visible,

>                          swap_cluster_alloc_table()
>                           rcu_assign_pointer(ci->table, table);

All entry on this cluster is freed(e.g process dead) , 
so this might be the free cluster.

>  ci = swap_cluster_lock(si, offset)
>  cluster_is_usable(ci, order）

Since it's a normal cluster (CLUSTER_FLAG_NONE) and the table exists,
it passes here...

>   if (!cluster_table_is_alloced(ci)) // ok 
>  alloc_swap_scan_cluster()
>   cluster_scan_range()
>    __swap_table_get()
> 
>                           /* free table when more table allocation fails */
>                           ci->memcg_table = kzalloc_obj(*ci->memcg_table,
>                                                         gfp);
>                           if (!ci->memcg_table)
>                            swap_cluster_free_table()

Nullified

>                             rcu_assign_pointer(ci->table, NULL);

Now it happens.

>     table = rcu_dereference_check(ci->table, lockdep_is_held(&ci->lock));
>      atomic_long_read(&table[off]); // NULL dereference
> 
> Fix the issue by updating allocated tables in atomic context.
> 
> Fixes: 2fe7a6f5024b8 ("mm/memcg, swap: store cgroup id in cluster table directly")
> Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
> ---
>  mm/swapfile.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 615d90867111..d29062d9c3cd 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -490,6 +490,20 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
>  	return 0;
>  }
>  
> +static void swap_cluster_copy_table(struct swap_cluster_info *d_ci,
> +				    struct swap_cluster_info *s_ci)
> +{
> +	rcu_assign_pointer(d_ci->table, rcu_access_pointer(s_ci->table));
> +
> +#ifdef CONFIG_MEMCG
> +	d_ci->memcg_table = s_ci->memcg_table;
> +#endif
> +
> +#if !SWAP_TABLE_HAS_ZEROFLAG
> +	d_ci->zero_bitmap = s_ci->zero_bitmap;
> +#endif
> +}
> +
>  /*
>   * Sanity check to ensure nothing leaked, and the specified range is empty.
>   * One special case is that bad slots can't be freed, so check the number of
> @@ -527,6 +541,7 @@ static struct swap_cluster_info *
>  swap_cluster_populate(struct swap_info_struct *si,
>  			 struct swap_cluster_info *ci)
>  {
> +	struct swap_cluster_info tmp_ci;
>  	int ret;

IMHO, How about resolving everything inside swap_cluster_alloc_table() instead?

We could consider the following two things.

- Assign the table at the very end inside swap_cluster_alloc_table().
- Handle the table freeing properly if subsequent allocations fail.

Rather than allocating a temp_ci (which adds special handling
for this case), wouldn't it be better to maintain the original intention
of the swap_cluster_alloc_table() function?

Although this is not a hot path and table allocation will usually succeed with
the ATOMIC allocator, this approach would also save the memcpy overhead
and stack memory usage.

(Another option might be checking memcg_table and zero_bitmap inside
cluster_table_is_alloced(). However, I personally dislike this idea as
it might introduce side effects regarding its coverage.)

Your current approach is also a good direction, but please review this
idea as well :)

Thanks,
Youngjun

