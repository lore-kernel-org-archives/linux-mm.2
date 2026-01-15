Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 811E9D41149
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8F666B0093; Thu, 15 Jan 2026 04:32:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E67356B0095; Thu, 15 Jan 2026 04:32:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D73146B0099; Thu, 15 Jan 2026 04:32:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C72676B0093
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:32:31 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 64A87B78CE
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:32:31 +0000 (UTC)
X-FDA: 84333682902.12.BBE4FC1
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf29.hostedemail.com (Postfix) with ESMTP id 32020120004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:32:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GcsVSwgK;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768469549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+iUgOjFTTbfQE7v33IT3NHTL6I0hG/q7V1catUOwvKs=;
	b=p0sW+mB3IF9gmUQ/3X9Aqh2v4/m7Lai5RsLylBs1WtD/DAGu/jYnh9w+K3Mb7qjFTDfBRp
	krdxrvOz0hQ2syEZFGxaAm89fuVnz241jTCoYBMCRqZargRPPJ5ijYyPpJ8k/0h2Q02XG+
	4kDA/xs4LP/xYJjuA+bEn8y+pQAIiWE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GcsVSwgK;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768469549; a=rsa-sha256;
	cv=none;
	b=4ConrjqnyA4E+TbVERjgmtMmsM42Kzmq/vg9aEpadSP8NsD9y7dUQCegOIf1+xVkxSjnQs
	7UQZBE1zrlXl9ev/VS2n5GV0EinrYUQNtINoIWyoRFubLQ4n17RSsnyRzrpjdCAfhqPGIt
	oWukf5yJ6f8+fh1H47y+BLEjGzWQyTU=
Message-ID: <01395cef-a258-412d-b9d2-0f61283d4578@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768469543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+iUgOjFTTbfQE7v33IT3NHTL6I0hG/q7V1catUOwvKs=;
	b=GcsVSwgKXy4alPkRnDgg2qI+A++Z9txlnnBJi5pNZvhr78GeYOahv8qeXEbWbZJduOSwno
	an4CS+iaHDlSLa+i0No+4LXxYeBiUG9Mft5PAKZf+xMcRu7x58EWOcGJUxmHDCgojiuhaa
	NSpEeJKKKZ1z7HE4mnkjjvrLz/ebCRY=
Date: Thu, 15 Jan 2026 17:31:51 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 23/30] mm: do not open-code lruvec lock
To: Baoquan He <bhe@redhat.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <33fef62fd821f669fcdc999e54c4035a4e91b47d.1768389889.git.zhengqi.arch@bytedance.com>
 <aWiy0mDN0Ed9mLiG@MiWiFi-R3L-srv>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aWiy0mDN0Ed9mLiG@MiWiFi-R3L-srv>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 32020120004
X-Stat-Signature: xd7zthng6c3kig46jo3pbceidk5t8fme
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768469548-374284
X-HE-Meta: U2FsdGVkX1+3ki+VzSjmUlFc9XMe7kJl7lnBfidCk+pW/kLjmd/XdzqTezppA5/+R05EnMO/B0wPevbtyOTeyphMXPmYx+sJzhdXekyeTu5Dxc7URggbCsAZnko6d1RvO5zS5+43laA4m3z4iI1nr5MU7/yNexI/so+o5AuKw5fK46AVYtWrEDj0cwPcnEUwty8bqrgjAz0tj94wpmf4FWnmIAR8G6B4Is2wvedn554r9+dTxJADO2AiIVJhkJooSJY2E7no+Mnep8dk8/oprIAk1ywIzKevR1eE0jJK+3dEzffhx9ektyNx3kphX1X+Poiai1XlLNgxU7NliFT8Ych89n+cF+4QCWhnK8U0Tr3EwA5Hxq6WGTA43f1Wx9SKxlXHiSSQQoa7xqYa/aNSRBhyUmUDj+mZVZAS87sjjAHrK/P9By5keXQCANssJ0nQff5mVszqywa60c3at7hIKmRSVUmLpU1D5tTiSn/fPrEjkzgrr6neLoSOlTyu1N6IA+Drkl3hD8hJpzrpoLsIu3Lh6Ibq6Cw3zYZg/8GTVwiX+XImnvvo+KbM7eMlNiwUxks9jBGvvHHBjyxT57bg/tkOYIzRmM57KXPGPzoYPFwjTFKsSt0kBib1wZTp2pxkFVx/85sOTZEWKf5gsAyN1tEkY6Eod/pDrJe4tgnIaObkwyAqZTtqzb4C1La1one4GgTxnh/xlCsgeAWrUiL+e9RTQ6RS9d4W+slzLJ5ehgecTJFWCwEsE/q1yz4IgnrPwTWGz4Hp2qLvrsFZXWWI9hfXw6GAzDvxO0oGN+0u9lGQRE4r5kD4P8MvmS7zTTIQkHDOa7ZYnCnFQUUJlUMPgEDCfUB63C3Aic91tiKbqwb/neK06arIt+xmgMarRR71P+MgFXsDuJ76PxC43hUINKKye1r/Lz9W2PdCZCrV+42dmQhe7/OC9+1hH/pbNZSzhQZmzYUuK60U/Yn5oTa
 XDrr7p1r
 HeZkzR5H4vO+erzSpOj79aCK5LDp73sEDTNaWM9DcQNdf0SX9XNDl1Knbcme79zvdIsy780KxkCVIoTyHvw4I/dr6106x77UjPQj9RI9SxfX8kIMC4tHLLl3eMYijFe2M+oTJFQnz/zOqS0HTmZfQUQ+nQgQ9Qj9xfCcgrt9P9vMc30jtMCKBO9rc+cRUSbCGtiz6m2F+uciZWb1zWP+TeVVReyJB5DyftqP6QN9rgsbioQ0voa6vd6sK37WyZ9cphGbVNfrrXgQzQ/M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/15/26 5:26 PM, Baoquan He wrote:
> On 01/14/26 at 07:32pm, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Now we have lruvec_unlock(), lruvec_unlock_irq() and
>> lruvec_unlock_irqrestore(), but not the paired lruvec_lock(),
>                                    ~~ typo, 'no'?
>> lruvec_lock_irq() and lruvec_lock_irqsave().
>>
>> There is currently no use case for lruvec_lock_irqsave(), so only
>> introduce lruvec_lock() and lruvec_lock_irq(), and change all open-code
> 
>    I didn't see lruvec_lock() is introduced in this patch, do I miss
>    anthing?

I forgot to update commit message when I deleted lruvec_lock(), will
modify it in the next version.

Thanks!

> 
>> places to use these helper function. This looks cleaner and prepares for
>> reparenting LRU pages, preventing user from missing RCU lock calls due to
>> open-code lruvec lock.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   include/linux/memcontrol.h |  5 +++++
>>   mm/vmscan.c                | 38 +++++++++++++++++++-------------------
>>   2 files changed, 24 insertions(+), 19 deletions(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index f1556759d0d3f..4b6f20dc694ba 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -1499,6 +1499,11 @@ static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
>>   	return mem_cgroup_lruvec(memcg, lruvec_pgdat(lruvec));
>>   }
>>   
>> +static inline void lruvec_lock_irq(struct lruvec *lruvec)
>> +{
>> +	spin_lock_irq(&lruvec->lru_lock);
>> +}
>> +
>>   static inline void lruvec_unlock(struct lruvec *lruvec)
>>   {
>>   	spin_unlock(&lruvec->lru_lock);
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index f206d4dac9e77..c48ff6e05e004 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -2020,7 +2020,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>>   
>>   	lru_add_drain();
>>   
>> -	spin_lock_irq(&lruvec->lru_lock);
>> +	lruvec_lock_irq(lruvec);
>>   
>>   	nr_taken = isolate_lru_folios(nr_to_scan, lruvec, &folio_list,
>>   				     &nr_scanned, sc, lru);
>> @@ -2032,7 +2032,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>>   	count_memcg_events(lruvec_memcg(lruvec), item, nr_scanned);
>>   	__count_vm_events(PGSCAN_ANON + file, nr_scanned);
>>   
>> -	spin_unlock_irq(&lruvec->lru_lock);
>> +	lruvec_unlock_irq(lruvec);
>>   
>>   	if (nr_taken == 0)
>>   		return 0;
>> @@ -2051,7 +2051,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>>   	count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
>>   	count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
>>   
>> -	spin_lock_irq(&lruvec->lru_lock);
>> +	lruvec_lock_irq(lruvec);
>>   	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
>>   					nr_scanned - nr_reclaimed);
>>   
>> @@ -2130,7 +2130,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
>>   
>>   	lru_add_drain();
>>   
>> -	spin_lock_irq(&lruvec->lru_lock);
>> +	lruvec_lock_irq(lruvec);
>>   
>>   	nr_taken = isolate_lru_folios(nr_to_scan, lruvec, &l_hold,
>>   				     &nr_scanned, sc, lru);
>> @@ -2141,7 +2141,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
>>   		__count_vm_events(PGREFILL, nr_scanned);
>>   	count_memcg_events(lruvec_memcg(lruvec), PGREFILL, nr_scanned);
>>   
>> -	spin_unlock_irq(&lruvec->lru_lock);
>> +	lruvec_unlock_irq(lruvec);
>>   
>>   	while (!list_empty(&l_hold)) {
>>   		struct folio *folio;
>> @@ -2197,7 +2197,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
>>   	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
>>   	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
>>   
>> -	spin_lock_irq(&lruvec->lru_lock);
>> +	lruvec_lock_irq(lruvec);
>>   	lru_note_cost_unlock_irq(lruvec, file, 0, nr_rotated);
>>   	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
>>   			nr_deactivate, nr_rotated, sc->priority, file);
>> @@ -3832,9 +3832,9 @@ static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
>>   		}
>>   
>>   		if (walk->batched) {
>> -			spin_lock_irq(&lruvec->lru_lock);
>> +			lruvec_lock_irq(lruvec);
>>   			reset_batch_size(walk);
>> -			spin_unlock_irq(&lruvec->lru_lock);
>> +			lruvec_unlock_irq(lruvec);
>>   		}
>>   
>>   		cond_resched();
>> @@ -3993,7 +3993,7 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
>>   	if (seq < READ_ONCE(lrugen->max_seq))
>>   		return false;
>>   
>> -	spin_lock_irq(&lruvec->lru_lock);
>> +	lruvec_lock_irq(lruvec);
>>   
>>   	VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
>>   
>> @@ -4008,7 +4008,7 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
>>   		if (inc_min_seq(lruvec, type, swappiness))
>>   			continue;
>>   
>> -		spin_unlock_irq(&lruvec->lru_lock);
>> +		lruvec_unlock_irq(lruvec);
>>   		cond_resched();
>>   		goto restart;
>>   	}
>> @@ -4043,7 +4043,7 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
>>   	/* make sure preceding modifications appear */
>>   	smp_store_release(&lrugen->max_seq, lrugen->max_seq + 1);
>>   unlock:
>> -	spin_unlock_irq(&lruvec->lru_lock);
>> +	lruvec_unlock_irq(lruvec);
>>   
>>   	return success;
>>   }
>> @@ -4739,7 +4739,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>   	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>>   	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>>   
>> -	spin_lock_irq(&lruvec->lru_lock);
>> +	lruvec_lock_irq(lruvec);
>>   
>>   	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness, &type, &list);
>>   
>> @@ -4748,7 +4748,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>   	if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_GENS > lrugen->max_seq)
>>   		scanned = 0;
>>   
>> -	spin_unlock_irq(&lruvec->lru_lock);
>> +	lruvec_unlock_irq(lruvec);
>>   
>>   	if (list_empty(&list))
>>   		return scanned;
>> @@ -4786,9 +4786,9 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>   	walk = current->reclaim_state->mm_walk;
>>   	if (walk && walk->batched) {
>>   		walk->lruvec = lruvec;
>> -		spin_lock_irq(&lruvec->lru_lock);
>> +		lruvec_lock_irq(lruvec);
>>   		reset_batch_size(walk);
>> -		spin_unlock_irq(&lruvec->lru_lock);
>> +		lruvec_unlock_irq(lruvec);
>>   	}
>>   
>>   	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
>> @@ -5226,7 +5226,7 @@ static void lru_gen_change_state(bool enabled)
>>   		for_each_node(nid) {
>>   			struct lruvec *lruvec = get_lruvec(memcg, nid);
>>   
>> -			spin_lock_irq(&lruvec->lru_lock);
>> +			lruvec_lock_irq(lruvec);
>>   
>>   			VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
>>   			VM_WARN_ON_ONCE(!state_is_valid(lruvec));
>> @@ -5234,12 +5234,12 @@ static void lru_gen_change_state(bool enabled)
>>   			lruvec->lrugen.enabled = enabled;
>>   
>>   			while (!(enabled ? fill_evictable(lruvec) : drain_evictable(lruvec))) {
>> -				spin_unlock_irq(&lruvec->lru_lock);
>> +				lruvec_unlock_irq(lruvec);
>>   				cond_resched();
>> -				spin_lock_irq(&lruvec->lru_lock);
>> +				lruvec_lock_irq(lruvec);
>>   			}
>>   
>> -			spin_unlock_irq(&lruvec->lru_lock);
>> +			lruvec_unlock_irq(lruvec);
>>   		}
>>   
>>   		cond_resched();
>> -- 
>> 2.20.1
>>
>>
> 


