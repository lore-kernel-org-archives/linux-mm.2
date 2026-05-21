Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04D53CD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 17:16:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E4536B0088; Thu, 21 May 2026 13:16:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 095D26B008A; Thu, 21 May 2026 13:16:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EED686B008C; Thu, 21 May 2026 13:16:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB0366B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:16:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9E332140716
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:16:30 +0000 (UTC)
X-FDA: 84792080940.25.3021571
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id 92EB4C0009
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:16:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=nn0RhuLt;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf22.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779383789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AsXEHk+wQ7EGCCKqWRMSIo2T9JwmFiZUhbTO9jKUkLI=;
	b=1mWPsamsx1H3068Bx/O5LGtJvgSDLMy7Jj+uQg61AE5sKXEHXLjen9biV5Ux2EFHRwAM97
	WdlpHH2ZrBuTg5bzkhsst/ylaVe1OQWrPQMN+GdT06ytQtCyYaK+efnxUiC4nvVNQ2pYng
	FItqRQvMkhe+yPAR12z/L4Hmr8Ydq1M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779383789; a=rsa-sha256;
	cv=none;
	b=wxFqoEFruq2L+NXmC4pPAawBngYyu6dssUeMQFWRKh9aI0WlCjR9iurWMjNq6ueyV6IiHQ
	77j5vYB41WMVvn87OFn5lLifQCWFB7aBU1NEt31RhGsGWEtmoFzxkQMz+NWxk39AGe2Fc6
	8ymuizldFIDJmCq1hSmK/HB2aUlgJ7g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=nn0RhuLt;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf22.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AsXEHk+wQ7EGCCKqWRMSIo2T9JwmFiZUhbTO9jKUkLI=; b=nn0RhuLtF6x1IqTDzwqxrszFR1
	S5BMrxn7FiuJefdfEamPy626eRtCy/cjSwjhhTggzIDf+vpm94pxLm6sWGVCbQbj9sX03KhxUJaNo
	xlNiurB8Vl5IvaQM4tiNAccVKVDMdlFBDk7uZ73CsiaI3LKz4t9FIBJKRoDp28GTgdP9AHy51vhVz
	oM/WJThW8mOqhG1ahrXSEpDLS+7Vo62RRPY1dK/0OwQgkZcgf34ozedDH18FjFyPf8zzEGiUXoxnW
	b1hu64aN0DCh10sgRg1uYnY/1HDPNDAv3K9gI48bZWYKcUVPqRjyzC2koJmJBwSL+F7xlapU8ln5W
	BDuucjKg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wQ70P-00000008bea-2tAW;
	Thu, 21 May 2026 17:16:21 +0000
Date: Thu, 21 May 2026 13:16:18 -0400
From: "Liam R . Howlett" <liam@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Dave Chinner <david@fromorbit.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Kairui Song <ryncsn@gmail.com>, Mikhail Zaslonko <zaslonko@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/8] mm: list_lru: lock_list_lru_of_memcg() cannot
 return NULL if !skip_empty
Message-ID: <cw6jle5lxrujsrp6c7djldwwsnwxh42avxy2j6lbpcjxhosyml@7k7clowspzx4>
References: <20260521150330.1955924-1-hannes@cmpxchg.org>
 <20260521150330.1955924-2-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521150330.1955924-2-hannes@cmpxchg.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 92EB4C0009
X-Stat-Signature: 8cwm1fhex9x7wgcsnahqb3wit7si6mfm
X-Rspam-User: 
X-HE-Tag: 1779383788-380115
X-HE-Meta: U2FsdGVkX1+c/SoN2drO6mSmDH1aAshtB9MNgAY4TeqdrL8L+culztfWH7A4oaG0p4SV4wF8apPhOF+vPBHB/5dZuA7MaoNTVWwaGvp4XSRlpaZv9WmBevBn5D1GJtWFGUTya9QNdJAShe6NntAewbhdXCSoaq02GXCI4LePdzaoGVh1Lp5aeU+QggdQ3tr/374ADpRSCxEOTx8r8rDEXn5dWNNy+a56IjJ5Y1e+G1qEajXLldPvVSKupMFMcVH+F3S/gh0PbtO08neI/0TzGVlABQHPZ3rFnPtoUn+eFDBJFTxZOJ1/0y2bYaddPLyltezJL3IbHHoWObtvXB5z8zg1HlAJgfR0xycSJ98RZpkajzh9x17KLgzXjB4KjnZyhWN4NdMZd/X9z5k080s1276/Dj36d++G56wYk2L6NravmYEjRckFF75UdsjrXFaiQSmjWvxfr6BK96+2p27ldzHUX+OqmPS/xhnrJBaBLKZnrylO8BjRv94ozR1dTn0dboKYFZCQpqMJ7w1zmbUCpAZq7qHf11SeirTp/TiQ7aNiyazbALdd51VFoL2tZLBO/L7dag0lr87qQqJlYVsHlvZT8BMHlWsgU5dPlJRsZ21BYo4d5z5QpR+wDLHWpar9MnhmIeR2cJoAENGV9DfPT5FS94bLMjAVXAMg/jsq065aAqSUk1d5Yeko3uak6s08gGOtJuImnGLakluGTHD1mMuDH0Zsib03+q2TyT2FYUaFz9iK5c5VTdq061gAARxIdHTyxYsThwPZw2pxvs0XJ3uxCBwyrTubfUmQlzywd+6hbhvoUs9VhSDg1n7P5T3T4f0xUs6npW4Uz3ks9Am8asOC0FbnG19S9roGLiUK0TiNT0s6GSBwcRfUBlYHEcD3h1hddLmGLapPtIPppPE1CWA9DqvlNsDMeMrwK88nAXCiqnyROgh/WaU/hDsPBd5R0UUxzV+SA0A3XNqYaoq
 B8MgoeFO
 htFDc/UbCt1I8HQicq5xrNtCeSqd83wqGWyLbhEHNpucQAod9s8wvlk8UkEQaCcdhAWKbsLFttxbFyDHpDdhcQACHm+HeQ7VuXjFbYqyzW2EEk1KEBC9pSy4UDuj77iH71qPui6Jxr5N84L3Bm8YFp1zFKmYC/7B7ztl1QMXEmwbQ2OsKbxzRz5lIf13ONR7SBbg4oW+K3Zlj8ar1a4HQzeEa/0q3vYcBLdATcpV00XKiDUsGNaZcSKNFf9bPWY3IAafExaeNJbfFnG+45gDfT+5WuW+ypRENqJQwljNklpWqyTKTYlo05BNTot5WInHCE8o76GhLhDe8BZ/z8I2SfAF6l0UxMpSEX9vFhApIfO1vx0itPqdC7NDhO/PCt7YxHUlrQaZw3CFDHBK0SEpVHeVgEIpKu6+JEiGc8Zt9S50vr7HZGpxMdD99pshaYLJ1XLYe4P6hx+iWhkB0qVRJCIxZCwbQ6PdU/rNpDy9+BKqFT2lSAfkPGJas9lFw5ZjWzAMb5qF2ESR2M04=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/05/21 11:02AM, Johannes Weiner wrote:
> skip_empty is only for the shrinker to abort and skip a list that's
> empty or whose cgroup is being deleted.
> 
> For list additions and deletions, the cgroup hierarchy is walked
> upwards until a valid list_lru head is found, or it will fall back to
> the node list. Acquiring the lock won't fail. Remove the NULL checks
> in those callers.
> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>

> ---
>  mm/list_lru.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index dd29bcf8eb5f..d3619961a7ac 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -165,8 +165,6 @@ bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
>  	struct list_lru_one *l;
>  
>  	l = lock_list_lru_of_memcg(lru, nid, memcg, false, false);
> -	if (!l)
> -		return false;
>  	if (list_empty(item)) {
>  		list_add_tail(item, &l->list);
>  		/* Set shrinker bit if the first element was added */
> @@ -204,9 +202,8 @@ bool list_lru_del(struct list_lru *lru, struct list_head *item, int nid,
>  {
>  	struct list_lru_node *nlru = &lru->node[nid];
>  	struct list_lru_one *l;
> +
>  	l = lock_list_lru_of_memcg(lru, nid, memcg, false, false);
> -	if (!l)
> -		return false;
>  	if (!list_empty(item)) {
>  		list_del_init(item);
>  		l->nr_items--;
> -- 
> 2.54.0
> 

