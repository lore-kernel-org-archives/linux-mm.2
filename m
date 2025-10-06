Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2AECCCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 23:16:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A2B28E0008; Mon,  6 Oct 2025 19:16:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 179E98E0002; Mon,  6 Oct 2025 19:16:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B6E68E0008; Mon,  6 Oct 2025 19:16:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EDCB38E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 19:16:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8CB3C14078E
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 23:16:36 +0000 (UTC)
X-FDA: 83969250792.12.5FEBB4E
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id 881B18000F
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 23:16:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nF+BhiMO;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759792594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YAQqFRBgLjNWMysHHUTdJ9birnJGsiwpBAJwhsVCFOg=;
	b=QvxKU8Py4GlmuXNki0DsWq/0gKYOkk+RwXxjISyfJB6OeYjqlhV1G2ReRD4iNoun8eE2Er
	GN3xRegWfnuvaCB2aRLb8zcqL6rgTBA5e2A16O9uK1BXNEb54gEQOS/rrin4bTHUThlSpg
	01zFYcV2MpYLqGDJVIHUaY4hNmYiokU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nF+BhiMO;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759792594; a=rsa-sha256;
	cv=none;
	b=O+zyctBi0jORH86Z+QL0jnJ0iHFixmPR82FBWs5s8W+04+E5FM3h5ERpbe1XddW8jP+NJz
	425hxjU+RFjQywYMgqYJlHos1aC6FxrN8Mf5DFw5TBgUxfuhr9AuO2whrfO2s76nqkcdzh
	PvjV2ivuNgxuUmdbyUbhWyP4k6yED5o=
Date: Mon, 6 Oct 2025 16:16:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759792592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YAQqFRBgLjNWMysHHUTdJ9birnJGsiwpBAJwhsVCFOg=;
	b=nF+BhiMOqJadidPnvsG16Wzer5kVYzDfO7ORmBZTFX9lkhuTKv4g3I2r2j5XzU/XsPVsd4
	wV6tZYU3bCeNpCCTY7mVL/D1/ty6zvNghVe48V8Do81JIFyAa8Ub/YRpYyCEdkJw4fcWiP
	IuzUXSZ9JV214J+uFpsku/o1xXlL1qE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@redhat.com, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v4 3/4] mm: thp: use folio_batch to handle THP splitting
 in deferred_split_scan()
Message-ID: <x4d36plhxcbyp76q4gmesktnnh7yi7bfifx3amk3fwx2moqkk6@77umpnw6rkg3>
References: <cover.1759510072.git.zhengqi.arch@bytedance.com>
 <304df1ad1e8180e102c4d6931733bcc77774eb9e.1759510072.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <304df1ad1e8180e102c4d6931733bcc77774eb9e.1759510072.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 881B18000F
X-Stat-Signature: zbajuwhbpaugxdqr4odrk8xts74jc3yt
X-Rspam-User: 
X-HE-Tag: 1759792594-6533
X-HE-Meta: U2FsdGVkX18yzjniG5QHk1+CGn/WdJXFKCV8MGHdVEMPHA+NFPqpN1qn+DMENfWfLjUmsngbR78D98rB/eJp8VnVMfMJ3LZdCdNJXZz0Z1g4WOWfTCsPTAcWUgdyF0QOYK71LdYR6ornL1mz75RukLoh1oWsXVXVeUN/P83ggSTTUKk/z3ABEgIwfeQLZSlThSn7AG9e/80z3S58yaxwCaHSr20sNbBgf/VPFxH/3nJfZiAEZQpMZE7PSXBffZXdI8DcVddt7SG09CkGrQV0nwPPFnKDPiEYTpUkVIxvrrmkAMe/bPMvbSlRylS3t6DIgKfDDakYgnVghEaJg/Q7tRAeiELLiHrY1dK8affW6g1wimaKKteo+3Ge7WRTMbhimm/xun9u0cEVMjSfwdcDxKGrzutRxS6IaMkyfI73GT12CJuUc2jkxBaQbcNRGQARhPnn7e1smpc8wlHXf/2i6Z1/fdKlAbzjUML2L2EHLOWoo+LzApvF4N2B0yVQ8onYfTe8xxRm7SSrLfskPAiHHFji21o3xEQF+mm7Eiagjk/DKpwCvDHDW9iBwbNiPKTAG1S1ni7ok8moYXRj7YsLJVPNZ0fXRb9SQOwMplaVoaU5D9xXBO0akWMZG2yyD/8YEiLFed7+SvY/lBY4Dy2HFYJ09Z95w1YOhVyjme+sPNUgNj/ABsyzGwL8p2iYcJWuXKCFt8uiXnGfA3iBANH3tK9zxtagH2FwINYPI8WWzsAwSFTzzW/ECuo/SwYN7vlAM/YBhWEpXJfHj+7NGRRMM1i8/+y6RVxMlx4ufJNiF47ahvn8BVK1zC9o/rQUPkc7/9atROeOVEXlKAkjB8yQytKp3hLMSPl7ab5IoEyb7IRgcScxqkiHAn+8qPJyf8W7cAqLz5Sj4s/ojrcVkpmCRh71uDOCKQgAInvbvpEuvUE76Xg43urSyMB+hGvSY1P6YURdDHYdRsGmrgYtoKc
 LdwvTRZw
 yNuwvVzV+Bjxe++hHdlcAMiZ0NXMuavGBRB6iF5S3hN3Xu7fxjfZqJqF81r+hpIWbON+0a8mWGFQ9VtmvUwDpDYUuSDVVZjf7waCBZnDRL4YZ6sYbfHgTnLgNMdVnW0iXxyltddQW3w2Fs62F+HDYkG14heXSkMdVRX0NlJAGt7cxQvsytESAl8+bce2/9dOOwYhjs4lX4DiP+O1TtDvub88Baqw/o7FrqHzqqzX5jsEUIWZ95Pp0ucNqTcP8LAx+X1I9hD18mf09sewjuCuVgk2Aql6fE6ECMCRNeRhBxebUSn5NBmcaVYj2JsMfj40Dj2ME52H/+frgIVg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 04, 2025 at 12:53:17AM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> The maintenance of the folio->_deferred_list is intricate because it's
> reused in a local list.
> 
> Here are some peculiarities:
> 
>    1) When a folio is removed from its split queue and added to a local
>       on-stack list in deferred_split_scan(), the ->split_queue_len isn't
>       updated, leading to an inconsistency between it and the actual
>       number of folios in the split queue.
> 
>    2) When the folio is split via split_folio() later, it's removed from
>       the local list while holding the split queue lock. At this time,
>       this lock protects the local list, not the split queue.

I think the above text needs some massaging. Rather than saying lock
protects the local list, I think, it would be better to say that the
lock is not needed as it is not protecting anything.

> 
>    3) To handle the race condition with a third-party freeing or migrating
>       the preceding folio, we must ensure there's always one safe (with
>       raised refcount) folio before by delaying its folio_put(). More
>       details can be found in commit e66f3185fa04 ("mm/thp: fix deferred
>       split queue not partially_mapped"). It's rather tricky.
> 
> We can use the folio_batch infrastructure to handle this clearly. In this
> case, ->split_queue_len will be consistent with the real number of folios
> in the split queue. If list_empty(&folio->_deferred_list) returns false,
> it's clear the folio must be in its split queue (not in a local list
> anymore).
> 
> In the future, we will reparent LRU folios during memcg offline to
> eliminate dying memory cgroups, which requires reparenting the split queue
> to its parent first. So this patch prepares for using
> folio_split_queue_lock_irqsave() as the memcg may change then.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand <david@redhat.com>

One nit below.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

> ---
>  mm/huge_memory.c | 85 ++++++++++++++++++++++--------------------------
>  1 file changed, 39 insertions(+), 46 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 134666503440d..59ddebc9f3232 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3782,21 +3782,22 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  		struct lruvec *lruvec;
>  		int expected_refs;
>  
> -		if (folio_order(folio) > 1 &&
> -		    !list_empty(&folio->_deferred_list)) {
> -			ds_queue->split_queue_len--;
> +		if (folio_order(folio) > 1) {
> +			if (!list_empty(&folio->_deferred_list)) {
> +				ds_queue->split_queue_len--;
> +				/*
> +				 * Reinitialize page_deferred_list after removing the
> +				 * page from the split_queue, otherwise a subsequent
> +				 * split will see list corruption when checking the
> +				 * page_deferred_list.
> +				 */
> +				list_del_init(&folio->_deferred_list);
> +			}
>  			if (folio_test_partially_mapped(folio)) {
>  				folio_clear_partially_mapped(folio);
>  				mod_mthp_stat(folio_order(folio),
>  					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>  			}
> -			/*
> -			 * Reinitialize page_deferred_list after removing the
> -			 * page from the split_queue, otherwise a subsequent
> -			 * split will see list corruption when checking the
> -			 * page_deferred_list.
> -			 */
> -			list_del_init(&folio->_deferred_list);
>  		}
>  		split_queue_unlock(ds_queue);
>  		if (mapping) {
> @@ -4185,35 +4186,40 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>  {
>  	struct deferred_split *ds_queue;
>  	unsigned long flags;
> -	LIST_HEAD(list);
> -	struct folio *folio, *next, *prev = NULL;
> -	int split = 0, removed = 0;
> +	struct folio *folio, *next;
> +	int split = 0, i;
> +	struct folio_batch fbatch;
>  
> +	folio_batch_init(&fbatch);
> +
> +retry:
>  	ds_queue = split_queue_lock_irqsave(sc->nid, sc->memcg, &flags);
>  	/* Take pin on all head pages to avoid freeing them under us */
>  	list_for_each_entry_safe(folio, next, &ds_queue->split_queue,
>  							_deferred_list) {
>  		if (folio_try_get(folio)) {
> -			list_move(&folio->_deferred_list, &list);
> -		} else {
> +			folio_batch_add(&fbatch, folio);
> +		} else if (folio_test_partially_mapped(folio)) {
>  			/* We lost race with folio_put() */
> -			if (folio_test_partially_mapped(folio)) {
> -				folio_clear_partially_mapped(folio);
> -				mod_mthp_stat(folio_order(folio),
> -					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> -			}
> -			list_del_init(&folio->_deferred_list);
> -			ds_queue->split_queue_len--;
> +			folio_clear_partially_mapped(folio);
> +			mod_mthp_stat(folio_order(folio),
> +				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>  		}
> +		list_del_init(&folio->_deferred_list);
> +		ds_queue->split_queue_len--;
>  		if (!--sc->nr_to_scan)
>  			break;
> +		if (!folio_batch_space(&fbatch))
> +			break;
>  	}
>  	split_queue_unlock_irqrestore(ds_queue, flags);
>  
> -	list_for_each_entry_safe(folio, next, &list, _deferred_list) {
> +	for (i = 0; i < folio_batch_count(&fbatch); i++) {
>  		bool did_split = false;
>  		bool underused = false;
> +		struct deferred_split *fqueue;
>  
> +		folio = fbatch.folios[i];
>  		if (!folio_test_partially_mapped(folio)) {
>  			/*
>  			 * See try_to_map_unused_to_zeropage(): we cannot
> @@ -4236,38 +4242,25 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>  		}
>  		folio_unlock(folio);
>  next:
> +		if (did_split || !folio_test_partially_mapped(folio))
> +			continue;
>  		/*
> -		 * split_folio() removes folio from list on success.
>  		 * Only add back to the queue if folio is partially mapped.
>  		 * If thp_underused returns false, or if split_folio fails
>  		 * in the case it was underused, then consider it used and
>  		 * don't add it back to split_queue.
>  		 */
> -		if (did_split) {
> -			; /* folio already removed from list */
> -		} else if (!folio_test_partially_mapped(folio)) {
> -			list_del_init(&folio->_deferred_list);
> -			removed++;
> -		} else {
> -			/*
> -			 * That unlocked list_del_init() above would be unsafe,
> -			 * unless its folio is separated from any earlier folios
> -			 * left on the list (which may be concurrently unqueued)
> -			 * by one safe folio with refcount still raised.
> -			 */
> -			swap(folio, prev);
> +		fqueue = folio_split_queue_lock_irqsave(folio, &flags);
> +		if (list_empty(&folio->_deferred_list)) {
> +			list_add_tail(&folio->_deferred_list, &fqueue->split_queue);
> +			fqueue->split_queue_len++;
>  		}
> -		if (folio)
> -			folio_put(folio);
> +		split_queue_unlock_irqrestore(fqueue, flags);

Is it possible to move this lock/list_add/unlock code chunk out of loop
and before the folios_put(). I think it would be possible if you tag the
corresponding index or have a separate bool array. It is also reasonable
to claim that the contention of this lock is not a concern for now.

>  	}
> +	folios_put(&fbatch);
>  
> -	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
> -	list_splice_tail(&list, &ds_queue->split_queue);
> -	ds_queue->split_queue_len -= removed;
> -	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
> -
> -	if (prev)
> -		folio_put(prev);
> +	if (sc->nr_to_scan)
> +		goto retry;
>  
>  	/*
>  	 * Stop shrinker if we didn't split any page, but the queue is empty.
> -- 
> 2.20.1
> 

