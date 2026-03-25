Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54D15106B537
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 13:21:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81A8A6B0005; Wed, 25 Mar 2026 09:21:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CB716B0089; Wed, 25 Mar 2026 09:21:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E0C16B008C; Wed, 25 Mar 2026 09:21:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5B9926B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:21:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 089B3140785
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:21:15 +0000 (UTC)
X-FDA: 84584646510.13.83A608A
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1B46140005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:21:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RbiSAeA5;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774444873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kHYq33BwlOn3JWruElGpijmEDuNRAICkAUC/xOuQnSc=;
	b=8N7xxrLri0WcGIVU+Z6DpOaYV3THyDMJsE5ZhP2VXEv9u7L5AVzUMaMcYZr3P8JzJbAGUx
	WLjRZNMLkqp00+4a9iNVmLnlr2lgXt1+Aza5jnvu4cIzHvSDhUmE4TAqgkT3BUI0ekBmpc
	0MBMFcIbHYyABBxYdERP71d6uxvk5Jk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774444873; a=rsa-sha256;
	cv=none;
	b=bc3eh5EJ8MhecSBEV2AGwP3/cLrKQJ9QB0VaGSkSwV2VIFfHU6BEPn/cDZ+Cv/IhmesB1+
	/Pi5d9gGWwnbprPi/wSsShBLbbHlX6Papc2b0JDT9GFAxpDggIUNxpSVRaB592o5tSXXa7
	UoS3HJP7SgC2d3+zqwcui+3NyxlsFG0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RbiSAeA5;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774444857; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=kHYq33BwlOn3JWruElGpijmEDuNRAICkAUC/xOuQnSc=;
	b=RbiSAeA5l2NgfSXPAv5TwnwF7o6VP/gc6piCSll+k/BvHMpsXrqelszbFouNXMUm3O634pvo8WxsUfUq8XgatxHAfRNHFlIQW6LJoj2zzHUMuMUOZ/WCm8FRNnl6KnBUzq1KpP4BiPsr18PjS9qqpQYyKRQSOEcS+9YC7M1jeIY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X.ht-0i_1774444855;
Received: from 30.42.98.36(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.ht-0i_1774444855 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 25 Mar 2026 21:20:55 +0800
Message-ID: <f3d680da-7480-4d05-ac44-e669e0914a32@linux.alibaba.com>
Date: Wed, 25 Mar 2026 21:20:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: vmscan: fix dirty folios throttling on cgroup v1
 for MGLRU
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org,
 mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 baohua@kernel.org, kasong@tencent.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
References: <bf40a20cd93b6c21f10db95657928fdae185e843.1774438978.git.baolin.wang@linux.alibaba.com>
 <acPOn07xah2eh0WU@KASONG-MC4>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <acPOn07xah2eh0WU@KASONG-MC4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1B46140005
X-Stat-Signature: 4zt1x8b59tpgf4nw96epsk4mxm3cbcne
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774444868-571208
X-HE-Meta: U2FsdGVkX180Zf23wB8mJvqAd1LkZAEAgqO5hw68eP4OE+aq5NW/+G1+EvN2k34Pt0nGuBAl20EWHJeb0MRhrgUCrCn5JkF7K9mzW7OOjzieinH3vs4U2oZymnmTYnfP7KUD9x+8ZlfdFjtg5VfneazvyV6Ve3KvNJsffp9mmkA7FYYZkuBVWeEsJSWiQNHTiQuKz3gVIY3EWZJDU+HtrGUhOKUjcAFfJpO8Gz5397EkbwV4i+QGJQbPKnCV/zoeuzJvKOQk11/oSyfFPBMWmKHcJvbSkEmQp4K3gPKzy1FSxDeTxqAlvsP4DNCRYsPGYc+nXHwc08p6CkL7ROFu3BUh7jOo1CHyPPXVz9ra2E/tSu7QDru3Iv7epcj98NsCa4wj8uwxk2FpWFdee1++5xJ917sAn02qPONkZR4M6EaCVKV+C61DZbjMzdsBhL3C2mBHlgMS81s45UYOfPHbZRp4E4vrod5WcU1/OMa9sNaAtAMnx1cJpbbcF1QDoGODwoVzvZW+H3IzyJv6VHaIbGJfiHhAi7CfGs7JiiSKaXJ6dFbKMgCB8naoF5i9U3aK6e6WbqVB7JiATj1csVvH4xgDjlzZaE/DAhEXvGpRB3W7tlgAJqf00b9zJsRBrfUC014xRjtYefW6ka2fdQGL2P9atyHrAMiXGZVmIAi139LlcJA/B/Kng/h8K/7ZhRm6rQsNTTUka6GVqbfPxx4p4EmpaFcM8SL55yJuIiYX+H+3r5RJBeVeFVQgiWDBe5y7JaQP/gATlqVstjd5+FOf3Hh1o8bx/O03kfSAJJC3ISYq0fZ5csOxVA9xePUCUsJv4FtSo0munW2QkPSdJCanq+Zb2cJcJR45IGHib6JXmn87pwTLYo23QdvkbhJ3V6HyOZR/NwZURvqYSHeQ+wtrM7my3MIFJPlP5B6leq0+EiPFJuVui6TYc6+NUK9F5qoSIMNmELEKVASEBYacR9R
 mY8/h0Vc
 iGtoE3s1KDny0maUSvFNI5HSPNRd+qFDmz5HFqL/1y//CeWs9jTdWBg7m1gqky6UzqTM2spgj4KY2Sf5ElYWoRDO6y4Ktk9ApvjTgPwkkgpDeef1mNzxYuR/0Qcol5XA0Tw2huiGaT5TEvo74NAlTqjh5EXIRwkZ6sNnpIt4lk17mDgvWdknp5v2wQYyU/GCf3sXphEQR2MgBvll89b/G7MxqcvwNVUF2o6SUt456J5c0zLnSvCc4q3BwgeLYPRKe+kuwQPXsO1U9o4k+yry9nyl1SkFk2OAeG0a3hTdYybg/M3yqI/57eZMBQeGMDGgBj2tydTPW419W8gHBv83BkfvB2DmIQLBjQe1D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

On 3/25/26 8:07 PM, Kairui Song wrote:
> On Wed, Mar 25, 2026 at 07:50:40PM +0800, Baolin Wang wrote:
>> The balance_dirty_pages() won't do the dirty folios throttling on cgroupv1.
>> See commit 9badce000e2c ("cgroup, writeback: don't enable cgroup writeback
>> on traditional hierarchies").
>>
>> Moreover, after commit 6b0dfabb3555 ("fs: Remove aops->writepage"), we no
>> longer attempt to write back filesystem folios through reclaim.
>>
>> On large memory systems, the flusher may not be able to write back quickly
>> enough. Consequently, MGLRU will encounter many folios that are already
>> under writeback. Since we cannot reclaim these dirty folios, the system
>> may run out of memory and trigger the OOM killer.
>>
>> Hence, for cgroup v1, let's throttle reclaim after waking up the flusher,
>> which is similar to commit 81a70c21d917 ("mm/cgroup/reclaim: fix dirty
>> pages throttling on cgroup v1"), to avoid unnecessary OOM.
>>
>> The following test program can easily reproduce the OOM issue. With this patch
>> applied, the test passes successfully.
>>
>> $mkdir /sys/fs/cgroup/memory/test
>> $echo 256M > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
>> $echo $$ > /sys/fs/cgroup/memory/test/cgroup.procs
>> $dd if=/dev/zero of=/mnt/data.bin bs=1M count=800
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   mm/vmscan.c | 13 ++++++++++++-
>>   1 file changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 33287ba4a500..a9648269fae8 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -5036,9 +5036,20 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>>   	 * If too many file cache in the coldest generation can't be evicted
>>   	 * due to being dirty, wake up the flusher.
>>   	 */
>> -	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken)
>> +	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken) {
>> +		struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>> +
>>   		wakeup_flusher_threads(WB_REASON_VMSCAN);
>>   
>> +		/*
>> +		 * For cgroupv1 dirty throttling is achieved by waking up
>> +		 * the kernel flusher here and later waiting on folios
>> +		 * which are in writeback to finish (see shrink_folio_list()).
>> +		 */
>> +		if (!writeback_throttling_sane(sc))
>> +			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
>> +	}
>> +
>>   	/* whether this lruvec should be rotated */
>>   	return nr_to_scan < 0;
>>   }
> 
> Hi Baolin
> 
> Interesting I want to fix this too, after or with:
> https://lore.kernel.org/linux-mm/20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com/

Thanks for taking a look.

> 
> With current fix you posted, MGLRU's dirty throttling is still
> a bit different from active / inactive LRU. In fact MGLRU
> treat dirty folios quite differently causing many other issues too,
> e.g. it's much more likely for dirty folios to stuck at the tail
> for MGLRU so simply apply the throttling could cause too
> aggressive throttling. Or batch is too large to trigger the
> throttling.

Thanks for sharing this.

> So I'm planning to add below patch to V2 of that series (also this
> is suggested by Ridong), how do you think? There are several
> other throttling things to be fixed too, more than just the
> V1 support. I can have your suggested-by too.

But I still think this fix deserves its own commit, because this is 
indeed fixing a real issue that I ran into. Even if the throttling isn't 
perfect for cgroup v1, it aligns with the legacy-LRU behavior and is 
essential to avoid premature OOMs firstly. MGLRU dirty folio handling 
improvement can be done as a separate optimization in your series.

Anyway, let's also wait for more feedback from others.

> commit e9fc6fe9c1236f7f70eeb45d9c47c56125d14013
> Author: Kairui Song <kasong@tencent.com>
> Date:   Tue Mar 24 19:45:26 2026 +0800
> 
>      mm/vmscan: unify writeback reclaim statistic and throttling
>      
>      Currently MGLRU and non-MGLRU handles the reclaim statistic and
>      writeback handling, especially throttling differently. For MGLRU the
>      throttling part is basically ignore.
>      
>      Let just unify this part so both setup will have the same behavior.
>      
>      Signed-off-by: Kairui Song <kasong@tencent.com>
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index bdf611544880..fcb91a644277 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1943,6 +1943,44 @@ static int current_may_throttle(void)
>   	return !(current->flags & PF_LOCAL_THROTTLE);
>   }
>   
> +static void handle_reclaim_writeback(unsigned long nr_taken,
> +				     struct pglist_data *pgdat,
> +				     struct scan_control *sc,
> +				     struct reclaim_stat *stat)
> +{
> +	/*
> +	 * If dirty folios are scanned that are not queued for IO, it
> +	 * implies that flushers are not doing their job. This can
> +	 * happen when memory pressure pushes dirty folios to the end of
> +	 * the LRU before the dirty limits are breached and the dirty
> +	 * data has expired. It can also happen when the proportion of
> +	 * dirty folios grows not through writes but through memory
> +	 * pressure reclaiming all the clean cache. And in some cases,
> +	 * the flushers simply cannot keep up with the allocation
> +	 * rate. Nudge the flusher threads in case they are asleep.
> +	 */
> +	if (stat->nr_unqueued_dirty == nr_taken && nr_taken) {
> +		wakeup_flusher_threads(WB_REASON_VMSCAN);
> +		/*
> +		 * For cgroupv1 dirty throttling is achieved by waking up
> +		 * the kernel flusher here and later waiting on folios
> +		 * which are in writeback to finish (see shrink_folio_list()).
> +		 *
> +		 * Flusher may not be able to issue writeback quickly
> +		 * enough for cgroupv1 writeback throttling to work
> +		 * on a large system.
> +		 */
> +		if (!writeback_throttling_sane(sc))
> +			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
> +	}
> +
> +	sc->nr.dirty += stat->nr_dirty;
> +	sc->nr.congested += stat->nr_congested;
> +	sc->nr.writeback += stat->nr_writeback;
> +	sc->nr.immediate += stat->nr_immediate;
> +	sc->nr.taken += nr_taken;
> +}
> +
>   /*
>    * shrink_inactive_list() is a helper for shrink_node().  It returns the number
>    * of reclaimed pages
> @@ -2006,39 +2044,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>   	lruvec_lock_irq(lruvec);
>   	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
>   					nr_scanned - nr_reclaimed);
> -
> -	/*
> -	 * If dirty folios are scanned that are not queued for IO, it
> -	 * implies that flushers are not doing their job. This can
> -	 * happen when memory pressure pushes dirty folios to the end of
> -	 * the LRU before the dirty limits are breached and the dirty
> -	 * data has expired. It can also happen when the proportion of
> -	 * dirty folios grows not through writes but through memory
> -	 * pressure reclaiming all the clean cache. And in some cases,
> -	 * the flushers simply cannot keep up with the allocation
> -	 * rate. Nudge the flusher threads in case they are asleep.
> -	 */
> -	if (stat.nr_unqueued_dirty == nr_taken) {
> -		wakeup_flusher_threads(WB_REASON_VMSCAN);
> -		/*
> -		 * For cgroupv1 dirty throttling is achieved by waking up
> -		 * the kernel flusher here and later waiting on folios
> -		 * which are in writeback to finish (see shrink_folio_list()).
> -		 *
> -		 * Flusher may not be able to issue writeback quickly
> -		 * enough for cgroupv1 writeback throttling to work
> -		 * on a large system.
> -		 */
> -		if (!writeback_throttling_sane(sc))
> -			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
> -	}
> -
> -	sc->nr.dirty += stat.nr_dirty;
> -	sc->nr.congested += stat.nr_congested;
> -	sc->nr.writeback += stat.nr_writeback;
> -	sc->nr.immediate += stat.nr_immediate;
> -	sc->nr.taken += nr_taken;
> -
> +	handle_reclaim_writeback(nr_taken, pgdat, sc, &stat);
>   	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
>   			nr_scanned, nr_reclaimed, &stat, sc->priority, file);
>   	return nr_reclaimed;
> @@ -4848,17 +4854,11 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   retry:
>   	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false, memcg);
>   	sc->nr_reclaimed += reclaimed;
> +	handle_reclaim_writeback(isolated, pgdat, sc, &stat);
>   	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
>   			type_scanned, reclaimed, &stat, sc->priority,
>   			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
>   
> -	/*
> -	 * If too many file cache in the coldest generation can't be evicted
> -	 * due to being dirty, wake up the flusher.
> -	 */
> -	if (stat.nr_unqueued_dirty == isolated)
> -		wakeup_flusher_threads(WB_REASON_VMSCAN);
> -
>   	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
>   		DEFINE_MIN_SEQ(lruvec);
>   
> @@ -4901,6 +4901,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   
>   	if (!list_empty(&list)) {
>   		skip_retry = true;
> +		isolated = 0;
>   		goto retry;
>   	}


