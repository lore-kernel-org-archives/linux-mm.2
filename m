Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01AA4C5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 01:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A9876B0189; Wed, 12 Aug 2026 21:20:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9811A6B018A; Wed, 12 Aug 2026 21:20:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BFA56B018B; Wed, 12 Aug 2026 21:20:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 534976B0189
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 21:20:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8694E4055D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:20:11 +0000 (UTC)
X-FDA: 85094490222.26.BE89609
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf16.hostedemail.com (Postfix) with ESMTP id 92D7D180003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:20:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GB6v6XB0;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786584009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ED8Tp9lm2QOcPjmMOrBKPEMtsi7PWnnaCdiDcnQCvuw=;
	b=il7SWdvKJ9QAuxz/+zTqMEBRYgdFT8Fcy2lLn0lL8pY3gqHnRMB+coYK9VgH+zYWrR+gsM
	v1mCSVP2culz8NXWB6WEyBsJajwU9urKqdnOOAcNbqW7v1lyULHsXHeurbJcP+8fTr6/8J
	7dpzbugUyCmAKGpeOJkh855rDwWiYuI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GB6v6XB0;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786584009;
	b=WCFrr5fUjwlKXTQB/K3cxnGTFmSVbMAoXyMvQhlQnAH8+a/oPoufTG2xuvvCEXnjpcE4aa
	Tml7Bmvh5yH7EX8UIo775fazoyfITVh+7TrE52kV6BVOfrBSYc9tpcwHuDA5SbP0V+yAi8
	hPtN4Y2IyNsfBR231rl+4ihFfP3r/v0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786584005; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ED8Tp9lm2QOcPjmMOrBKPEMtsi7PWnnaCdiDcnQCvuw=;
	b=GB6v6XB0EZ2QWMagQIuue/Stn1GDeaXnh4T/zitrXAGkwnYbbTVZJnDPgMvudeGYBgWHPB/eriflbkPoOfscDqNixZXaQf7hlQ6o14KXB1u5TUzy0XMzClawuYwR2WesL3jsKs3S7SI+1ZhhA55nkQEfhV0aX+tr42Qfvw6G/0g=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0X8skQm4_1786584001;
Received: from 30.74.144.111(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8skQm4_1786584001 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 13 Aug 2026 09:20:01 +0800
Message-ID: <ab9cf918-862e-42b5-9435-b46f37d71928@linux.alibaba.com>
Date: Thu, 13 Aug 2026 09:20:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/mglru: fix and remove redundant unevictable folio
 handling
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Oleksandr Natalenko <oleksandr@natalenko.name>,
 Suleiman Souhlal <suleiman@google.com>,
 "Jan Alexander Steffens (heftig)" <heftig@archlinux.org>,
 Yu Zhao <yuzhao@google.com>, Steven Barrett <steven@liquorix.net>,
 Brian Geffon <bgeffon@google.com>, Kairui Song <ryncsn@gmail.com>,
 linux-kernel@vger.kernel.org
References: <20260812-mglru-mlock-fix-v2-1-a3fec5853c08@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260812-mglru-mlock-fix-v2-1-a3fec5853c08@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xzhh1sicz9ng3fexmad93msi5wkah9cu
X-Rspamd-Queue-Id: 92D7D180003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786584008-411391
X-HE-Meta: U2FsdGVkX1/rZvmB6gMmnzkMhS1sa6pMIKav3to5qvbIohx1KtDabAsPlBXSD8zc/wbR/i3vJTygBSICUoSysokXtNW3pKdNYsQn2AapOwHUPLvEx9cJbaVXDrqDDp7lY2pRUapUivnD236qiO1/1dJvxCDqxe6+0RWwPzgXTd5IBXzsPpzwK1a0vUMIBA2Cf97yRh8YDMFMMYMt5gejEwjXcQkX7HZvtawE4+lIeTjLizAHnMfiTMyiFntPvYLEO9lWhOToJyOv75qKr9eBqoII5B7VrboE2yo8/TDg17AbpvzjXpLJaO+SIChSvlrtNLYpClX5wzBUvnj6sDdtmx4lQ/4tZfvq2Z4ReLufrIfqdxgT665lk/fOcR0Iaj2BCmqneLWDF0WrfPfovxF6SBnRisPdcDTMbkGAFSpXosIopxWnK+EvQ6Pe6EpqnJ4d/LHWRzrzmpH98sR0q5ZU6qe05SGzTBb5X7UHBWf3Sj9tvQ+iBF8OQAODmTi6b3Rm4tFtnXXS6bxPC6tGDTJ+euTeUNf0mT0One33U2u+1WHkA19kOu0kzAH0Gkf3hY6CA+50ZUhWaxZu3MhoNQvCYoPfGLahzRwE1UyMmhbmrKx39MdfiiX3Yx+oMMjgPyAw+OuPtT4JoctY+tiBz5+SUOSwL53NGDLvXaJgxqv9sZpeD9VjYpbBcO8HEqgbI/ZHx52GncXySciQNzRjDGuvQgFMi/vqLHY/FE54fWDHlHQGdi98z3Zkb56wQbmZ1v3PNrhBudKJ3YgA9FBEWu93ghwNSp+S4955s/NCTvxrILFlmO6a0zedr4NVPWDl1XleLJTxnxFUEfL0zKXn5rSVUyoP3SPWuGID4Tv1waip5Ue0IqkPOV9LRk3/mczHB4nAP/ztZtstgIch06xh/h/hlyNXemd4l77h5nLywmlEHUQFp/1Rz8FrTS0+8maXJ85umrTPimK7iebxQpDyvFd
 DIpCHJTf
 0ZUx691LH/CX1HL0cF4KH+gJVrKDs8TC+vFHhuQiApbO1cSnJeHwoUj1Gzs81xO/ZQhuWZR4U5HjZTvGBH4PJrecb7MzBJYgHB7iyGXreI8xS2r+/1ERdr66ol/2Htk+TVFusaYP/KpRr53nRZCD+CgypYMx8vUzb3IQ3SXwDd8fQBT0g4P8JjJQONTeTwspgySLlmYuybn9qzieREVOOgUoGsEof9KyI2Ap5KQLKJvMEO2D0txIP8TuAmrkNR4x08QtU0LhNmBUFm6oBA91fGordnO6/jAqri8hC21chvu48vRNAX82xwRtRcElOdITJs19KHY3ZFdf+iBk71DEXvXPMqww2Fs/8m0mNLngIaR5hKjMWdFJd9pLQXWObXqfVR4DGRdq5eKzlAf+532X8UdGCOdnFRolxOEht
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/12/26 8:22 PM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> sort_folio() has a shortcut for moving folios that are no longer
> evictable but are still sitting on a generation list.  However, this
> shortcut is buggy.  It does not follow the PG_lru usage convention,
> and it has a more serious issue.
> 
> Unevictable folios are not threaded on lists[LRU_UNEVICTABLE], so that
> folio->lru can be reused to hold folio->mlock_count (see the comment in
> lruvec_init()).  Hence lruvec_add_folio() skips the list_add() for them,
> and every other place that turns a folio unevictable initialises
> mlock_count explicitly: lru_add() sets it to 0, __mlock_folio() and
> __mlock_new_folio() set it to !!folio_test_mlocked(folio).
> sort_folio() sets nothing, and the lru_gen_del_folio() right above it
> may have already poisoned folio->lru via list_del(), so mlock_count
> ends up aliasing LIST_POISON2, which reads as 0x122, i.e. 290.  The
> result is user visible.  On munlock, __munlock_folio() decrements that
> bogus count, finds it still non-zero and bails out before clearing
> PG_mlocked, so the folio remains unevictable and the Mlocked
> accounting stays inflated until the folio is freed.
> 
> The shortcut also touches the LRU flags in the wrong order.  It calls
> lru_gen_del_folio() while PG_lru is still set, so a concurrent
> folio_test_clear_lru() (e.g. compaction, folio_isolate_lru()) can
> succeed on a folio that has already been taken off the generation list,
> which may lead to unexpected behavior.
> 
> So fix it by isolating them as common folios and letting the generic
> shrink path cull them. This matches the classical LRU behavior, and
> there should be no visible effect on the generic eviction or isolation
> behavior.
> 
> There is no performance concern either, such a folio goes through this
> once, and then it is off the generation lists for good.
> 
> Fixes: ac35a4902374 ("mm: multi-gen LRU: minimal implementation")
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
> Changes in v2:
> - Proactively bypass MGLRU pid protection and lazy promotion to avoid
>    hot unevcitable folios staying on list for a long time.
> - Link to v1: https://patch.msgid.link/20260811-mglru-mlock-fix-v1-1-8b2321d0e1d3@tencent.com
> ---
>   mm/vmscan.c | 19 +++++--------------
>   1 file changed, 5 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 3194da7dcc79..ca2b926520ea 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4648,7 +4648,6 @@ void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent,
>   static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_control *sc,
>   		       int tier_idx)
>   {
> -	bool success;
>   	int gen = folio_lru_gen(folio);
>   	int type = folio_is_file_lru(folio);
>   	int zone = folio_zonenum(folio);
> @@ -4660,15 +4659,9 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
>   
>   	VM_WARN_ON_ONCE_FOLIO(gen >= MAX_NR_GENS, folio);
>   
> -	/* unevictable */
> -	if (!folio_evictable(folio)) {
> -		success = lru_gen_del_folio(lruvec, folio, true);
> -		VM_WARN_ON_ONCE_FOLIO(!success, folio);
> -		folio_set_unevictable(folio);
> -		lruvec_add_folio(lruvec, folio);
> -		__count_vm_events(UNEVICTABLE_PGCULLED, delta);
> -		return true;
> -	}
> +	/* unevictable: let it through and the generic path will cull it */
> +	if (!folio_evictable(folio))
> +		return false;

OK, returning false early in sort_folio() is better. Although I think 
mlocked folios won't stay in the LRU list for long, and 
shrink_folio_list() will also reject them anyway.

>   	/* promoted */
>   	if (gen != lru_gen_from_seq(lrugen->min_seq[type])) {
> @@ -4921,11 +4914,9 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
>   		DEFINE_MIN_SEQ(lruvec);
>   
> -		if (!folio_evictable(folio)) {
> -			list_del(&folio->lru);
> -			folio_putback_lru(folio);
> +		/* move_folios_to_lru() culls unevictable folios via folio_putback_lru() */
> +		if (!folio_evictable(folio))
>   			continue;

Yes. Still look good to me. So feel free to add:

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

