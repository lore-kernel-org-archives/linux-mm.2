Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6456C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE76A6B0092; Wed, 26 Aug 2026 05:06:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A98696B0095; Wed, 26 Aug 2026 05:06:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D7A86B0099; Wed, 26 Aug 2026 05:06:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 776356B0092
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:06:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 68DDA1402E0
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:06:26 +0000 (UTC)
X-FDA: 85142839572.11.FDFB1BD
Received: from mta1.migadu.com (out-83.mta1.migadu.com [95.215.58.83])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5BA9840004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:06:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WpSMDVtg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.83 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q5aS4fmmLVZ79k6nj24B6cmOptFGMWzUz8GrVbnoz2g=;
	b=qbFE3QKqlcOgvA8e8KgGz1cZOPp7AfZSrTt9HCMnrZrg591CFl3nkzF/QMUSI3XR/3AlJE
	WCoPkNneU1Ub+8a2jwjAg8yRyQyeN1NsIAFuKJySgQ2l9OP9bFmuysKy2oQb3i24sAd1vJ
	7W5se2VNEH2rwNYL+PHqQVWvSAmPDFM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WpSMDVtg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.83 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735184;
	b=rrkcZLaD+m87LybK/9p7oNOGQfbID3NC5U2NuQQhjHcJUNnXWIPCDD+YRWAYs6Heq6p/Lq
	0rDDl/F/ymQpTl4Mj6Ej4wTbYrFWK4x9mBKM4vR3BIHUFa8bxyCY7Lt9/mOesw0UYcnq9O
	aiD0Nw58suAHntC5HfFvXR0chCE0bbw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6qfHuU2CPeFQ/FpwTQILkdqooY7I0WFuJOzbL3HiHGw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787735183; v=1; x=1788339983;
 b=WpSMDVtgX8+yriZAVhEDemGgZ+KlqBl+3mi6YvysMWM3nYb8kC21FFes5S/an2W693emHyGn
 36Zoxdaj6madOT3DNPzlj5lTmMVe7of8x+AVObHY2SZkIpXty+D5HBoEtTkE92iT0NYJUaFyi06
 w1RKjBCFF5xaGVO2rBgJkLs8=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (223.70.159.239)
	by mta12.migadu.com with ESMTPS id be78230b644cb2df;
	Wed, 26 Aug 2026 09:06:22 +0000
X-Mizu-Trace-ID: be78230b644cb2df
X-Migadu-Flow: FLOW_OUT
Date: Wed, 26 Aug 2026 17:06:20 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com, chenridong@xiaomi.com,
	david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com,
	lianux.mm@gmail.com, linux-kernel@vger.kernel.org, ljs@kernel.org,
	lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, stevensd@chromium.org,
	wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com,
	zhangbo56@xiaomi.com
Subject: Re: [PATCH 5/6] mm/mglru: move folios from oldest gen to
 second-oldest gen from head to tail
Message-ID: <ao6sjHs0zaQtVp_u@fedora>
References: <20260821102538.22642-1-baohua@kernel.org>
 <20260821102538.22642-6-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821102538.22642-6-baohua@kernel.org>
X-Stat-Signature: y7e6sdm54hmzjk56n1buky91y8tseniy
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5BA9840004
X-Rspam-User: 
X-HE-Tag: 1787735184-548288
X-HE-Meta: U2FsdGVkX18cHrdkYMX6QtxVruOw8a7H4Jdm/8brkr7ib2gWuZpUgcHaKSgwCP4TSApwr76XT36p3UerBfvlDj9eNdloXtmo4clJXUxtrqhfvEpwiykn/H6uDkE/or0gx05cr+aAFW+IcESplN55dWGO3nAFKr4WwX4k5vCCYStW+Gh1SAU5czx3i8RGef5mJV7LK41LOSoVb/ugyOvv5ePKM1gmSyEZWRfJqCNv0QBsmfKAHnuL/avYECqcSGBSjC8MXbKYoeQ+5yNHF0sv6eHS2JfLvLKXfO9WybI+qSOL6EQihStT/kvUQiFndac9V9YdF1528eQASlUdv29X4QwBd/v88QTGoPSKNPUTU43S7JUp/AuRnrBvmjRpjJ7hwj6bJvRvighbJhqmg0xPg37aFBbB5s/ZHFLl+QDMGI5oJNNhmYztedHkTp9SlXOQy6DoOWtS9viB+YLvMESEhvVulz+mC75RljpoZxAJQVSKdww5CpVPf+7rlzLOQQOVRKsMlo9Lv6uYO2EHXgBTOrR7qUcIOLXR5fh4uVhU5AlwbgSZJzpl4PJMIsNAFeCRUZexQR/jyXld2CEf+WD8YD71IsP3ndxH7L/SZhigXmkbELb+TILKmjBcAwOyXIr/7RRgNAbC9guiLIi+/jNSwshs2fkxQUXUzkmpapr8W9MOVYyXzPRHyWqqZkyAHKdgYyTSsZ0fvCoNUdO9H8kCZn+9vQbOvupk5RgcU1p8H5k8FkOkUtAv/JPDaQ0ZEumV9dyfXaB8c2qOyMHykFt1jy7j6S4EWurDUpFiTFEqlYjdaGidU/+z2nIzGCo5T+lBU1t9iA0MU8OxJDxAfuxQYFRLjRluHedbGc6DRXU2FpM/72KRak++0qkDPsuJSK8wGer4jXxNjg3E5+zbAVQlVcdL9T69YHa0iSiqr0+GCDJ57dikue1OHlS4Nm7E0VymH+YXsMixd4JrI8ximBp
 j5jFoouW
 JNmovfc2gJPy2uRbgXPBYrUi4vO03OedHj9F1OHTmidG9uW2/bLk8XKxnnQTcjUsMGRLTL2fKKmJEMya9swbmSkKD3dR0+sb3b0uD7rQCj2ZRTUNe1LRw/RxpvMmAvSspifavsaa7/mVIANi66xxbpB0kdMp3vqSSxcSlTqlJXTGIbUuWaKKOgbyvjPs/CIp4zU8SdL5jZ8bOe3a3Z59p+9HhtwFi2LA917D/dSP+WR10Q0rvCNhsakgyQ1awMmNZogSTdt8+xTpeLvFWXORRQvULmiK2lGpgzVGoP2Lsq796GRH2+blNSwti14Nkg7zySMZ3kh1qmP/ttiAcixTF6/VFSHiJbTRI2/3z13UVEO7T5YFGZJ7nXx1jc/U/q7VjS9qfQwJTdMT7GjmV542fkOAKgtR4KwL55dZN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/21/26 at 06:25pm, Barry Song (Xiaomi) wrote:
> For reclamation, it makes sense to reclaim folios from tail to
> head, as folios near the head are relatively hot. However, when
> moving folios from the oldest generation to the second-oldest
> generation, using the tail-to-head order would effectively cause
> a cold/hot inversion.

This is great, do we need do the similar thing on scan_folios()?
While it's not relevant to this patch.

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 7bd01875fade..2fd82b2ca4d1 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -191,8 +191,20 @@ struct scan_control {
>  			prefetchw(&prev->_field);			\
>  		}							\
>  	} while (0)
> +#define prefetchw_next_lru_folio(_folio, _base, _field)			\
> +	do {								\
> +		if ((_folio)->lru.next != _base) {			\
> +			struct folio *next;				\
> +									\
> +			next = list_entry((_folio)->lru.next,		\
> +					struct folio, lru);		\
> +			prefetchw(&next->_field);			\
> +		}							\
> +	} while (0)
> +
>  #else
>  #define prefetchw_prev_lru_folio(_folio, _base, _field) do { } while (0)
> +#define prefetchw_next_lru_folio(_folio, _base, _field) do { } while (0)
>  #endif
>  
>  /*
> @@ -3932,9 +3944,10 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>  	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
>  		struct list_head *head = &lrugen->folios[old_gen][type][zone];
>  		unsigned long protected[MAX_NR_TIERS] = {}, delta = 0;
> +		struct list_head *pos = head->next;
>  
> -		while (!list_empty(head)) {
> -			struct folio *folio = lru_to_folio(head);
> +		while (pos != head) {
> +			struct folio *folio = list_entry(pos, struct folio, lru);
>  			long nr_pages = folio_nr_pages(folio);
>  			int refs = folio_lru_refs(folio);
>  			bool workingset = folio_test_workingset(folio);
> @@ -3945,6 +3958,8 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>  			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
>  			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
>  
> +			prefetchw_next_lru_folio(folio, head, flags);
> +			pos = pos->next;
>  			new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
>  			if (gen_increased) {
>  				delta += nr_pages;
> -- 
> 2.34.1
> 

