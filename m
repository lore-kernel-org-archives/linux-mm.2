Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB078CCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 23:40:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 299398E0010; Tue,  7 Oct 2025 19:40:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 270F18E0005; Tue,  7 Oct 2025 19:40:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AF248E0010; Tue,  7 Oct 2025 19:40:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D74B8E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 19:40:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D04D3119AEE
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 23:40:53 +0000 (UTC)
X-FDA: 83972940786.28.3E55753
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1ABD240004
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 23:40:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ik2GK1eK;
	spf=pass (imf04.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759880452; a=rsa-sha256;
	cv=none;
	b=Yi7NmWIIu37LtZJh68d8UYm/zUe0aeepdfyC6gYEzhalFPJaR5pMMWOLe0I/5NtdSLUHWV
	nCY5wZUjKKCkXED7POVZiJUvc+2mhkiTDKKaMJbZxZqwNGgPyZfS/pVbXpgCXvOA61emab
	iK6EJ4kBRhBY/SW/8z4GCWul5rAQrh8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ik2GK1eK;
	spf=pass (imf04.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759880452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E6OD1bQXaicr9WCwyTV1JRRGSFUf3V7VjtgLaaXPLUQ=;
	b=IT74Szjz8zmqLl9j5Baa/puGwiuAXyejgQUJkOGGtfB4nH4PBOM62i3UavO3pwxEoHGjqg
	mO7nhi/qOiAqdaKpSN4IWrHedXIef6NGkp+Gx2MnsXV7Bt4HHjIcNL+Z1KxD3Rh5diNmZf
	TUUEMvYsIIYHClhZm6yOW5G+mxeHzNw=
Date: Tue, 7 Oct 2025 23:40:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759880450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E6OD1bQXaicr9WCwyTV1JRRGSFUf3V7VjtgLaaXPLUQ=;
	b=ik2GK1eKqJ/QpncSodtUJDqaZ1CxjtRJZpZXNofmS05mT7WKjS1TA1XtUWKRbME70i+3CT
	0BQj1BKgoLhhfoYfbSr8rpw2TuWe4dMMZU+rRfsbTNoEQEqAdNNVJyu6SRXzy0zJoHlFOf
	gITYeZiFDARdwU/DvrwJixjCfb1CJhw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, cgroups@vger.kernel.org, kernel-team@meta.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/4] mm/zswap: fix typos: s/zwap/zswap/
Message-ID: <k7suwksw5kvivopboym4zny3u7rqwq3gw6rvlrcrydo7kiadvg@gumequ2fft7h>
References: <20251003203851.43128-1-sj@kernel.org>
 <20251003203851.43128-3-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251003203851.43128-3-sj@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: hexqbumyzwyjdhinosj5dcpgykhryo9r
X-Rspamd-Queue-Id: 1ABD240004
X-Rspamd-Server: rspam09
X-HE-Tag: 1759880451-680230
X-HE-Meta: U2FsdGVkX18ro1Um6CtUg4Jqd1XmnLwWFj1f/ICgcUV8J6hnuUWn032R+WvShSYhcvvJHiJ8A3XdO9IFUsaKOLjysueLVmyoBy1poSehsDzXz5+Uawr3KdsXzn0J5OHJdPQJIqeO+62TYGjM/knjOdjHeLubgyAfYJ8H3TB3Gs2eW4uJrpWmjRMz9q8w4abeehfae+xcdSJS2kc6cPjnshWuCvwteW8W6khlqFflp/rnNxRQ9KgYG3NLAEYy+fa15sclbyRwCSzJ8jM5Bb127QobaTNv85MkGPVzalwu5nrztpNIhKwM+UNbxsFQZ/sVYwZai4FBAdvOKO2e0GdSQeYW/ZUqEsx4fG9WNdXp68Mai/IcWxbO08LOsZMME8P+IwmNbcz0Ryt6yOweqRLg0uGJPnNwobF+dgTXiU1NLkZSLlGJLrUhKmxPPD2m1zZpZGw/TkqkLJDDktZ/sPB65E6X6RBqSOBRPWXN2aX2MpjN91FstL2kXjXrWDfOTt2PR9HLFf8IubEQ2n+XqRaYUbknLSlcsu17uxqJL535gwQ7f6v/dG3lw3d0UI04BQWTvxh2Hg3D2eFO8NJM+tyNf4yAeQFp/4E/31FTkyEptbynJeolySJDAi6p8qK7d+HGiKBs8JdgOrmpCJfq17G6ugev9iGrTbhbWem9ojnHQ5ExnDvqaIFw4/JrNIYORB2AMPqj5nkx5W892c7wlKcFXjJZXOi8AToqoa+NKLCN7HAl6rrk96VY8DU3ei3DQk1jagMAlPNl3l6M/Qfu7QDj+zRA54aBwOq2DVY2rtFjtIJKBwGChfwkY7F68Cu3UpSGTKy9IaZzQx/4jlUjdHu6FGexAfljz4fJXdImdhh1obOfdT4G2brQ9mOxQCO2nP96ws+eLadz7IYhZHWJJPVvbTgdp/SdWt69EIMepnaMoeAck3LjvGMCkb9qWJ3pT78p89YMYQoQ+eNoHWlYeCZ
 vMeeo+sY
 pdDXBvEsyck1FmMrengVWSeGXN0R8oxJ8rI0b8et0rcnEeTOzJAtRDmhjobBJi1opvGw1AjJS15Kdw+8blAQClPlbSmVg8AdMOhZNPw2p5DJx78yiHZK4Q7RDSpO8DNcRcssomIw6Ww96Hs2hvJqMhIkQKv2PmAvrHuXdoluU8htQE7QBh2m+W+maNbe3qILBBCGnjBukXE89znDQkB0SvmhJ2UrvX7fjJV7lyzJzwrQmqKw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 01:38:49PM -0700, SeongJae Park wrote:
> As the subject says.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>

Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  mm/memcontrol.c | 2 +-
>  mm/zswap.c      | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 69c970554e85..74b1bc2252b6 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5421,7 +5421,7 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
>   * @size: size of compressed object
>   *
>   * This forces the charge after obj_cgroup_may_zswap() allowed
> - * compression and storage in zwap for this cgroup to go ahead.
> + * compression and storage in zswap for this cgroup to go ahead.
>   */
>  void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
>  {
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 80619c8589a7..f6b1c8832a4f 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -879,7 +879,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
>  	 * acomp instance, then get those requests done simultaneously. but in this
>  	 * case, zswap actually does store and load page by page, there is no
>  	 * existing method to send the second page before the first page is done
> -	 * in one thread doing zwap.
> +	 * in one thread doing zswap.
>  	 * but in different threads running on different cpu, we have different
>  	 * acomp instance, so multiple threads can do (de)compression in parallel.
>  	 */
> @@ -1128,7 +1128,7 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
>  	 *
>  	 * 1. We extract the swp_entry_t to the stack, allowing
>  	 *    zswap_writeback_entry() to pin the swap entry and
> -	 *    then validate the zwap entry against that swap entry's
> +	 *    then validate the zswap entry against that swap entry's
>  	 *    tree using pointer value comparison. Only when that
>  	 *    is successful can the entry be dereferenced.
>  	 *
> -- 
> 2.39.5

