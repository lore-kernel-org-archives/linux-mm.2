Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE4E2D35165
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 16:29:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 407D56B0005; Wed,  1 Apr 2026 12:29:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B8D76B0088; Wed,  1 Apr 2026 12:29:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CE576B0089; Wed,  1 Apr 2026 12:29:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C37E6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 12:29:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B04731408D2
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 16:29:11 +0000 (UTC)
X-FDA: 84610521702.02.C47A3BF
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9A7052000A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 16:29:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AphRW5s8;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AphRW5s8;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775060950; a=rsa-sha256;
	cv=none;
	b=GoklqZ5bQmsPcrISYbctyAudBqyyZuVa7hqttHVfZeLEiCBWnxM470PYrGmmaXMxWIZN4S
	hgReZlaGbymv9lsiNfeYVMLj2a6eT3qLEP6xXHty4uzsPnNEPyknHuzeflYoyLG+kZ5gxs
	0CUKGW9YNGoIH+ZTVfry9IqDkv1Q+QQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775060950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/F3w2zUvV0WycgwDhHoSaMjFosjjuSB+DlsqHi2/eOc=;
	b=zvK3+qQbhnfTnOHxpDxmT0HNsRwFVNb1pQE8Vdg9RwuSg/KKycxQj7cp5cN3qcyhiPvmVP
	gMgibb1qZF3oMEBYGCvIJGYmxFUqmS8V6uY0vkCj8RrJwRVdq6N1JuqKaS1lDv4BnM2zUU
	/2GKeVNGw8s/W5OC+Qvhc+NdSKgU6O0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775060947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/F3w2zUvV0WycgwDhHoSaMjFosjjuSB+DlsqHi2/eOc=;
	b=AphRW5s823Zt1SPOwvVYdbtW6LttToaWtO2AN2frz4rLWfPyyHug5O+hnPkvXhOD8CPzo6
	8lNWuXBjQ72MNyRKBZjfDs4ntgLVMHBIDo21zNiAynwjm9jgi8aCnjafdsKl1XQ7iCxgjw
	YY7AB2ceRqb25ejRGdxqMzm3SCJfvy8=
From: Usama Arif <usama.arif@linux.dev>
To: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	richard.weiyang@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kartikey406@gmail.com,
	syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH mm-unstable 1/1] mm: fix deferred split queue races during migration
Date: Wed,  1 Apr 2026 09:28:53 -0700
Message-ID: <20260401162855.146945-1-usama.arif@linux.dev>
In-Reply-To: <20260401131032.13011-1-lance.yang@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9A7052000A
X-Stat-Signature: whtryssx1j4s3ocq5q8ikwm4mwrrmdb8
X-Rspam-User: 
X-HE-Tag: 1775060949-645464
X-HE-Meta: U2FsdGVkX1/GYk7aBg6GUn6fDcJSf9wU8170o6AZNLB4/2xkTNDqQcmaex6IX25oLL9lupzIcjhfhDh1UC0x6LW+GtRk6HkEWRIVrGI2QT0l75yFN9sz57p6A/qZPQ5pL81VyGM0/Ti4CaEue2XzyG0HO7RiccwDtCNzw+FTw6hYz7I4aphGhS52H22w0FnqpAXqq7XtTXTyHyL4KWrHDV+CrygAa5GSEFjCnMpYaij14JNN1sa42nX8Za02+MZOVKyqcErZx0Yqzw148gBsg9q1oJrNLqioDHH1xig9wnHtogwNpW81kbk2tTvIkGhe/hj5jmkdnQci2QVlOTaw5p5eiVYICddEahh/cH/rj8kRfjJoRB/BSP8mC5/apJiGePWvutdAQSPFYDMWFRTBkFqK3btUIM+46HbcEvoksHnEbc7HONCVtmKVY0wYoFxTtKrGHyR8VXNAIaPb5q5f3u0rqCwKfHMjZnX3r5F1Wo964V5drNWy35+96MBaTBHdYC3Ky+73MlY8FMP8pzWRaedEo/sVMIuaMmp/QxTYM8qsbjPyKOYavLD238+iey/jcLR1nQ7xZUGer1TIbAQZH34RCJkeDJCr4Ys0vBWUMI8sfHsfRhYpUzzChOG1gVVyUnsAMsatS00yiUlI6iKZwtYRORDMrT1/qzSO/SQy/r7joH1pw9LElYE3Jm9uG2iqodpu0JQN4vGv3+X4W0/X+L6TuCgjY1Nf6ZqhSzzyWUz5XRrYo+Ugoq+/YKgukIMbpdY/wM0kqpgD+JqZU0FcPqzEpNotQqaptCQuLEiFLMee7EiDxUtBh5qcMAVy1qP9OzQuj3VXAt77IW55yFNgjURjSlFgFnX37cb2D4B127ntpHELGKWyH7kNDgHxV/WliQ5Oe8Z0Uu2f4mTcovp3AVckzrZ2gaTB1unwS7cO8VmHB9+BP12JMfEj5AerhiHMk3RdpD7EJYrEPGxwrJS
 n+9WlSu+
 YcycgCmYkhAnM05tBa4Dc7ASashjMKDnQon0nQG/9jq+AVSfRyBMV/iEtGboCYEYpshrAy6hwdZS6JSTjgP/mSe3twgRWN6bBsS3hN8NO9i70WIgonJ4FYCk6ztqiTUCe0IxwIwB/G0SsK3ECI1JsR2BkQq7dDtqtqubXpzPXCKo+L/VKujPX/OfXsrgvSgDT4NterToei4g+22lA5eX0iH0SmpBB+NwOYmjZNBEJkTjdZtdhNvdtbt81aLb0sajTnkgFbJRNIxJkeRpY7A5FVDBTyb0t5eVL+pc5YFCHU/Zl5Xnyt9oxXHfLRvRMu6+W5RkNKYj5GQsA9VukCZ2uj3sFx2QWE4rg91ZIZzI9wa1LVebQIVUsyoIo1Jz075SFCZDxr6/3UttB7ZQirLrdccmhVw6dKvnJq65PINLK+MWQ0oN25ksKc04b+fy1BtDkV9+m283YoTmYruA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  1 Apr 2026 21:10:32 +0800 Lance Yang <lance.yang@linux.dev> wrote:

> From: Lance Yang <lance.yang@linux.dev>
> 
> migrate_folio_move() records the deferred split queue state from src and
> replays it on dst. Replaying it after remove_migration_ptes(src, dst, 0)
> makes dst visible before it is requeued, so a concurrent rmap-removal path
> can mark dst partially mapped and trip the WARN in deferred_split_folio().
> 
> Move the requeue before remove_migration_ptes() so dst is back on the
> deferred split queue before it becomes visible again.
> 
> Because migration still holds dst locked at that point, teach
> deferred_split_scan() to requeue a folio when folio_trylock() fails.
> Otherwise a fully mapped underused folio can be dequeued by the shrinker
> and silently lost from split_queue.
> 
> Link: https://syzkaller.appspot.com/bug?extid=a7067a757858ac8eb085
> Fixes: 8a8ca142a488 ("mm: migrate: requeue destination folio on deferred split queue")
> Reported-by: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/linux-mm/69ccb65b.050a0220.183828.003a.GAE@google.com/
> Cc: <stable@vger.kernel.org>
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
> 
> [ Backport note ]
> This patch is a follow-up fix for 8a8ca142a488 ("mm: migrate: requeue
> destination folio on deferred split queue"), which is currently only in
> mm-stable, and should be backported together with it.
> 
> Credit for this fix goes to David, thanks!
> 
>  mm/huge_memory.c | 12 +++++++-----
>  mm/migrate.c     | 18 +++++++++---------
>  2 files changed, 16 insertions(+), 14 deletions(-)
> 


Thanks for the fix! And sorry for introducing the bug in
migrate_folio_move() :)

So I am happy with the migrate_folio_move() change, it makes sense.

The goto next if folio is locked in deferred_split_scan() was actually
on purpose. The reasoning was that if the folio is locked, we consider
it as in use by someone and therefore we shouldnt split it. Eventhough
thp_underused() does a zero-filled check, the whole point of the shrinker
was to split THPs that are "not in use", and in my mind, locked folio
is a folio in use. So not sure about that change..


> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index ff9a42abd1b6..ac6d823e351f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4558,7 +4558,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>  				goto next;
>  		}
>  		if (!folio_trylock(folio))
> -			goto next;
> +			goto requeue;
>  		if (!split_folio(folio)) {
>  			did_split = true;
>  			if (underused)
> @@ -4569,11 +4569,13 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>  next:
>  		if (did_split || !folio_test_partially_mapped(folio))
>  			continue;
> +requeue:
>  		/*
> -		 * Only add back to the queue if folio is partially mapped.
> -		 * If thp_underused returns false, or if split_folio fails
> -		 * in the case it was underused, then consider it used and
> -		 * don't add it back to split_queue.
> +		 * Add back partially mapped folios, or underused folios
> +		 * that we could not lock this round.  If thp_underused()
> +		 * returns false, or if split_folio() succeeds, or if
> +		 * split_folio() fails in the case it was underused, then
> +		 * consider it used and don't add it back to split_queue.
>  		 */
>  		fqueue = folio_split_queue_lock_irqsave(folio, &flags);
>  		if (list_empty(&folio->_deferred_list)) {
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 05cb408846f2..8a64291ab5b4 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1385,6 +1385,15 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>  	if (rc)
>  		goto out;
>  
> +	/*
> +	 * Requeue the destination folio on the deferred split queue if
> +	 * the source was on the queue.  The source is unqueued in
> +	 * __folio_migrate_mapping(), so we recorded the state from
> +	 * before move_to_new_folio().
> +	 */
> +	if (src_deferred_split)
> +		deferred_split_folio(dst, src_partially_mapped);
> +
>  	/*
>  	 * When successful, push dst to LRU immediately: so that if it
>  	 * turns out to be an mlocked page, remove_migration_ptes() will
> @@ -1401,15 +1410,6 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>  	if (old_page_state & PAGE_WAS_MAPPED)
>  		remove_migration_ptes(src, dst, 0);
>  
> -	/*
> -	 * Requeue the destination folio on the deferred split queue if
> -	 * the source was on the queue.  The source is unqueued in
> -	 * __folio_migrate_mapping(), so we recorded the state from
> -	 * before move_to_new_folio().
> -	 */
> -	if (src_deferred_split)
> -		deferred_split_folio(dst, src_partially_mapped);
> -
>  out_unlock_both:
>  	folio_unlock(dst);
>  	folio_set_owner_migrate_reason(dst, reason);
> -- 
> 2.49.0
> 
> 

