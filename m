Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3930CC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:01:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 286696B0098; Thu, 10 Sep 2026 08:01:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25E256B0099; Thu, 10 Sep 2026 08:01:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17A7A6B009B; Thu, 10 Sep 2026 08:01:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E5D126B0098
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:01:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ECF32120415
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:01:15 +0000 (UTC)
X-FDA: 85197712110.25.52565D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2085AA000A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:01:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FhEat1/v";
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789041674;
	b=A/EmHM/FL3DWvBwuxDbgRZVTi5kRfXueYJYQH2J/Of6kqRoFctr3J8zmI4C640cW8lZtOv
	CAjGAvvxefIc1E42vzcoMtjqxUjKlYj6PkPwq8kWIzglxZoVCcVFsYFaSxzzHbepWcFHMI
	TyROH+RNP2eNdVxci3clot3CVASrdIs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FhEat1/v";
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789041674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gGRiP00UZ2QnxQeyHEnzHM+4PwMNnzfPUpjThhppjiI=;
	b=LlpLcMVJc8HN7F+KdDWkQKouRWfXQZdMhlu7EKDoZJ3VEwH9EfMI0Tz7G8hO3D+lUsXqbu
	u8G0Yn8hQgZqTg46eCloAn5ic6HxuJCkYiZzOjdzQ/CahEUHRMZ+kG3efC9WU0rEG18kyb
	Qzdr2ePdgvLta+M/zNVOoq3DLk6RE7g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EFCCE42AFA;
	Thu, 10 Sep 2026 12:01:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C017C1F000FF;
	Thu, 10 Sep 2026 12:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789041672;
	bh=gGRiP00UZ2QnxQeyHEnzHM+4PwMNnzfPUpjThhppjiI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FhEat1/vifu+AabmjF8NmJPEP65qR4NBg4Ky/6jU3lo17Q0Zo2BhNylfwMKgXlIDI
	 UMImBV5640D83WmIILt73l8RjBygDF6Mt7gu1/ntqS0oBR8lidQsw7r3Sj2i5WdR8V
	 INjCSwvtzlHK8kPH7G5nIBuVR3YVGY4ybJh+g5gGSFGtxyX6EYVptvqJMZZwjeQfGi
	 aeG04jNaLuKWedKy71l1HWQfVdwcFptEjzJJ89C6fdNfHpJadbzrMhFXlVUL2CJHgj
	 w8mBMnWhfb9D+zFJggWb28AQFcd5s8vG8Yuhm57TZx5ehR5Gfv4Ij2Aijxv4bMLNbQ
	 hZcM2Ic2G/G5A==
Message-ID: <ddab52d0-48c7-4d2c-b403-45f11e041654@kernel.org>
Date: Thu, 10 Sep 2026 14:01:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/26] mm/fbatch: LRU_NEXT_ACTIVATE bit to optimize
 folio_activate()
Content-Language: en-US
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Ackerley Tng <ackerleytng@google.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Binbin Wu <binbin.wu@linux.intel.com>, Christian Brauner
 <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Christoph Lameter <cl@gentwo.org>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, David Hildenbrand <david@kernel.org>,
 JP Kobryn <jp.kobryn@linux.dev>, Jan Kara <jack@suse.cz>,
 Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
 Kairui Song <ryncsn@gmail.com>, Kiryl Shutsemau <kas@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Leonardo Bras <leobras.c@gmail.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
 Matthew Wilcox <willy@infradead.org>,
 Mel Gorman <mgorman@techsingularity.net>, Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@suse.com>, Minchan Kim <minchan@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>,
 Rik van Riel <riel@surriel.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan
 <surenb@google.com>, Yang Shi <yang@os.amperecomputing.com>,
 Yu Zhao <yuzhao@google.com>, Zach O'Keefe <zokeefe@google.com>,
 Zi Yan <ziy@nvidia.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
 <c44a34f8-ea3c-48cd-27d5-02df129be685@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <c44a34f8-ea3c-48cd-27d5-02df129be685@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2085AA000A
X-Stat-Signature: d6ku7qbocjdhh1qy8pah9utzkezujphf
X-HE-Tag: 1789041673-275590
X-HE-Meta: U2FsdGVkX1+lp/7B62u9/UcL61WGDowKXN1wEjGL/7uTCm3VWB1CHC+PtBqFeNkKDtbJje5+UDTkbuZWx2nKNqnEuNEkuml2Eay4uEnxr7c7sYnJMwFHVXSGr+4fkZELhPVc8ecHBHn2wwhfqDkkplycH0H1e4ZIGFzg8nd3Pe1zelAlD8IQb65ySUCFyiyd3q6mLnnZ4eLnK82P4B5G81PQw+maY75nBxppsq0d87SdyCWCYV2ZP1qQoqsVAnSPeHiAtXrvjD0FHIaEsb4nHRsxrGGZPkO1NLeM2sqU0Q89lJlYKr3wR+iGcA5PViV7WPZo8hT/cb4pObh1GFqI1HiQmlexsZr68XijOy/xKuCtq62tJNpqKYeFoC9KmfgpxjjpMtDx7+77UkXorWGD9ti+g8BSgbeBCWEDjIdoMnueNLANqXgipH/EqYa9n58TLGdjfxpQUy8FCSp6/qpAuFl78zgdwLYrWD5FzkK3Kmzylh6gi6xG5kKTo5vs6x4jsW/7ecMVoQMKC3NEswzy1fQYn2LviRea3HinhwApRg2tDzfJAif98TCNQkTMVfT93uAfQpVxHkEg7Pw7xxCydcnFLq28YWEJlKBgD4IbFX83DlpAhn039HEiUYWbKE+hIhFvyLUs2fPTBy3PdDJNbLf3jurSc7MQWKWbhRkvX275uD+3NY1bmDSwaPcSx/nUiPlac8VNFV6Qq25py5BL0Y51kWbrVzith4wtKMaP3uEPk9SidvmRO618cLmSl/RijtrLu7zggRQb01YxNR5d2C9AHqHMBu1rnDXOaYgrQc76hQQ2lFjVEAGfx0VxDRTz2FkPTaFtf6pFd5DYDfiAgDffJd+VBnl9WtSnCHCfrnvfazo1wYK+OgjpJarySDkSeZTqqhW9jZpU05Y0BIv+OmzTnXu9LJLqUsX1bNCMAQTVvYt8ryJ+ItXp1sLseXFBFJyOMpSe/CyEZm9P8a5
 UCSZQ1V0
 x8gNpd32yoglTd73tms2wcanpQ8W0M+9kWvqchg+B9LO1LTkBYdaO7SkYr1NSDNefVm7AtlDTf/iUQhhbo7Q91GQ0RborXnwBzBbikOq3PIbIZ/ph4cI9Fzi0X5cjpg8r5tbDdAvisZR6vwsdrp8TciejsM7/JTgO/EfS4ZXje3n8gRTNjwVY4L7DxTo2L0IoPAp8uVPuJq8Y1tusj7LlUMsJDB6Aii409HP93/iu49IhdDRUgaUKxOIUzvBImDI77iOhHqty2IUXZ22E8m25WHsLGpac/awKHl9HUb7n9AmM32U/DeMuhiLG7fVxBHN80Zb9hOILpZskr2ky/MUdS87R46B8hUDzp3XffCLvP7PnZa1NfjVt4BBQylKFrV8eoEUaZG+FvzCS5s3n0m4a5gdz0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 11:55, Hugh Dickins wrote:
> Implement an equivalent to the old __lru_cache_activate_folio()
> optimization, to activate a folio recently put in the lru_add fbatch,
> without having to put it through the lru_activate fbatch too. Neither
> lruvec lock nor lru bit can guard this safely and efficiently, so resort
> to try_cmpxchg() on a further, LRU_NEXT_ACTIVATE bit in folio->lru_next.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> ---
>  include/linux/mm_inline.h |  4 ++++
>  mm/folio.c                | 23 ++++++++++++++++++++---
>  2 files changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 8420b1276535..8f5efadf9c7c 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -346,6 +346,7 @@ static inline void folio_migrate_refs(struct folio *new, const struct folio *old
>  enum {
>  	LRU_NEXT_NEVER_TAIL = 0,	/* Used by a tail's compound_head */
>  	LRU_NEXT_BATCHED = 1,		/* Not used by any aligned pointer */
> +	LRU_NEXT_ACTIVATE,
>  	NR_LRU_NEXT_FLAGS
>  };

This addition, and the comment "/* This mask will do nothing on 64-bit */"
in folio_add_lru()... does it mean that now this is breaking 32-bit? Should
we make this optimization, or perhaps all of the cpu fbatch, 64-bit only?

> @@ -358,6 +359,9 @@ bool lru_add_del_folio(struct folio *folio)
>  	if (!(lru_next & BIT(LRU_NEXT_BATCHED)))
>  		return false;
>  
> +	if (lru_next & BIT(LRU_NEXT_ACTIVATE))
> +		folio_set_active(folio);
> +
>  	WRITE_ONCE(folio->lru.next, LIST_POISON1);
>  	/* BUG_ON(folio->lru_next & BIT(LRU_NEXT_BATCHED)); */
>  
> diff --git a/mm/folio.c b/mm/folio.c
> index a18d8ef6afd5..0b75c3b69d5a 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -256,15 +256,32 @@ static void lru_activate(struct lruvec *lruvec, struct folio *folio)
>  
>  void folio_activate(struct folio *folio)
>  {
> +	unsigned long lru_next;
> +
>  	if (folio_test_active(folio) || folio_test_unevictable(folio) ||
>  	    !folio_test_lru(folio))
>  		return;
>  
>  	/*
> -	 * XXX: It is curiously difficult to recreate safely the old
> -	 * __lru_cache_activate_folio() optimization (folio_set_active()
> -	 * directly if it's on the local lru_add fbatch): revisit later.
> +	 * This optimization is intended for the common case of folio
> +	 * having been recently added to this CPU's lru_add fbatch.
> +	 * But since other CPUs can now take it at any instant (after
> +	 * a folio_test_clear_lru()), and we may be migrated to another
> +	 * CPU, it is simplest just to extend the optimization to all CPUs.
> +	 *
> +	 * folio_set_active() would be unsafe without the lruvec lock, and
> +	 * a folio_test_clear_lru() here might cause a racing drain of the
> +	 * lru_add fbatch to skip its lru_add(): so use try_cmpxchg().
>  	 */
> +	lru_next = READ_ONCE(folio->lru_next);
> +	while (lru_next & BIT(LRU_NEXT_BATCHED)) {
> +		if (lru_next & BIT(LRU_NEXT_ACTIVATE))
> +			return;
> +		if (try_cmpxchg(&folio->lru_next, &lru_next,
> +				lru_next | BIT(LRU_NEXT_ACTIVATE)))
> +			return;
> +	}
> +
>  	folio_batch_add_and_move(folio, lru_activate);
>  }
>  


