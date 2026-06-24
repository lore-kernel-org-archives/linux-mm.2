Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB241CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 07:12:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 923CC6B0088; Wed, 24 Jun 2026 03:12:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D4386B008A; Wed, 24 Jun 2026 03:12:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C3DD6B008C; Wed, 24 Jun 2026 03:12:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4FA556B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 03:12:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D7D921C52AA
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:12:35 +0000 (UTC)
X-FDA: 84913938270.01.EA8401E
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf12.hostedemail.com (Postfix) with ESMTP id 19C5A40007
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:12:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pScYdSzc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782285154;
	b=iY77ciM3TC8CX/74M82keDxNDrKpMeftMGCOtJ1Q3trK4FV4Ewq3Lj41oZ2YGzzomCbhjO
	5G/alY79mVRkTPZmncJL2b8y12CJSjTOknFTqKKohKwNv95Q1tlAHwjR0dT2ravTI0AdzQ
	JbWkuetE+a9XnUi05TnL6onvNswjgfU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782285154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3DE60QhT/9TIkbnwdBa1IYV0upZCsNlOd11TX3mGeBc=;
	b=auhGtbgeoFcDllz6G4hwM/OPwgsigJhFQ1j77cNiljfNCe1hxBR2kvF89K9U3kGUR93qRx
	Lss5W5XkmBLpi0DnQ94Gm/psQZ1bsuhGrwzBwjo4U0jLUB2A4oujhApQ86+mRnvtuxU3tX
	S8p2XDlUqrNd9tsH0YAunt/l91GZmLU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pScYdSzc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
Message-ID: <1d638906-6d64-4e57-a181-4b77683652b5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782285148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DE60QhT/9TIkbnwdBa1IYV0upZCsNlOd11TX3mGeBc=;
	b=pScYdSzcoIw3LlQrsqm+dUGApjLrnkhSSXhR1XjT1wGHtRCn/M2UQoPA4bLfm86WJM8meV
	1R2FvGl5DomnILpB8yR1P7mDDh7+OGUJzF0fF/Zz/aWq4vuHcahfQuJU9xVagqILwo7kJJ
	UmAflc10g9+6wE4vQbEC0rBAQaPpjAg=
Date: Wed, 24 Jun 2026 15:11:56 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm: mglru: fix stale batch updates after memcg
 reparenting
To: Harry Yoo <harry@kernel.org>, akpm@linux-foundation.org,
 david@kernel.org, kasong@tencent.com, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, muchun.song@linux.dev,
 peiyang_he@smail.nju.edu.cn, mhocko@kernel.org, roman.gushchin@linux.dev,
 ljs@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
References: <20260623024237.45990-1-qi.zheng@linux.dev>
 <e74b0808-3bcc-414d-a037-41e479210cc0@kernel.org>
 <d97128c0-7d89-4b5c-b891-84f9af702fee@linux.dev>
 <8a76aefd-629c-41f3-b365-aefd4cc1411e@kernel.org>
 <7946da94-dc1d-4cf2-986e-466c378665b6@linux.dev>
 <dfe5d773-2992-448b-a6cb-ef633714a08f@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <dfe5d773-2992-448b-a6cb-ef633714a08f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 19C5A40007
X-Stat-Signature: r8zbfmqwp67m5aufjyx6nkhqm41wpemj
X-HE-Tag: 1782285151-529282
X-HE-Meta: U2FsdGVkX185/KOtBB58u4F0Y3FxmHgLpUBaQQZw4zjoE2sS/VpHOkdxda/W6pm+R4k9l3u00BOhmbVznTJozaICtG4sgNr5gfMFKZchWsiiNUW9MJU5iFsrnYNmaQYabqpuR8UWMVCrHaOGQ5ylt6UlpYv573Zsut1PXpGzKZ3lo4U5jYfHHJHH55c40JIdCsPe7G/IdFdkV2qifqT8PVBu4EJAL+02YEXJbDmz8X4W2UAHdMqNFxm9F2TN0IPieBt9K7n7hwFo2ul96kXyGd/185HPtnr1HP4hdqIf1LuKZWzfq+XNoZ/6WkcjMcJ7fA+H7i13JbyLD9x72RLvc4aq0foMZ9Ks0KpauuDRqjLW+2jclAA7r72K88b29V4fnwo59ZqbbYEZPfFqSrTj82JjwS++8uHZjwlFOUgUQO8QArZEstyAKLKW96jPoKpEvLXBv0Y6vMAUAbXsZN3oCYhilHkQNer24ak0UTsK0hED/J0ST8KE/IcuHxgWIyPgkZ6FzWx6JAe6YQKiYcxeDhfdsPZi3NFdpqv4Hy83fQUCgFoGReJ1JKgLEB+k15mc2y6UVRczhIE2DVLolqItxBlz7DLyOZVt2lpIbTEqsZiy3K+BP0qyVI13cYaVNAH5pt+fIxvpZuxHUHst/j/LhcW8LpvpSK5TBW20VpmPAkzCzJHrY52W8zFbOclw2dKuMxMycrFkubMM07Z7khHgAR5xC5+Pe0ooOkz5RLacAf40yxTsxDq0j9b6K7xHQxHBCnL9sTPMe52w29hr5qA5hfcYO7qo9cl8JxKxjJ9SBI6cPObNoe5MxkCxg5sI5siw7cl/Irwtl+MwY+MPOQVw8p2YOag0vbYPv0xUQxZdaQadL1IbhqU/nUSKEGzYpJJmuIp6+ScW1trAeBikzb1g+b8YU/UteBYqfW9QfETrsfrzpPYSueFJ1vlcmWEMzkTOjDlKUMoMF1n7cyYdl4V
 961eW7lk
 Z8VNmqQs6H6qCYSvPwV+QyZCIlN2RnJXI6bL3fm4oT9pE+aajMQIksK1KsPy5scOCmxYWXPM7GE8rB+kq06GLCXtLNbB3TFJ9tIjaaO77bHgqUPR7EBVlr1BI/545dw4IFUH7AMzIQmHnsHmUsHUhMF0LqlCGlOa24bUnjHBmIP0B0No3Qw0mDK3isQICsaI8grZQp2utipqP6ORa28/aTqzvjY6psEVI8kI/A3DNEdlQqUs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry,

On 6/24/26 12:29 PM, Harry Yoo wrote:
> 
> 
> On 6/23/26 6:14 PM, Qi Zheng wrote:
>> Hi Harry,
>>
>> On 6/23/26 4:18 PM, Harry Yoo wrote:
>>> On 6/23/26 4:16 PM, Qi Zheng wrote:
>>>> Hi Harry,
>>>
>>> Hi Qi!
>>>
>>>> On 6/23/26 2:17 PM, Harry Yoo wrote:
>>>>> On 6/23/26 11:42 AM, Qi Zheng wrote:
>>>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>>>
>>>>>> The mglru page table walker batches per-generation size deltas in
>>>>>> walk->nr_pages while walking page tables without holding the lruvec
>>>>>> lock.
>>>>>> The reset_batch_size() later folds those deltas into walk->lruvec
>>>>>> under
>>>>>> the lruvec lock.
>>>>>
>>>>> Ouch.
>>>>>
>>>>> IIRC the user-visible impact of underestimated nr_pages in MGLRU
>>>>> was premature OOMs because MGLRU does not try to reclaim memory when
>>>>> nr_pages reaches zero, but there are still more pages.
>>>>>
>>>>> Perhaps worth mentioning in the changelog?
>>>>
>>>> Maybe this should be placed before "To fix it...".
>>>
>>> Thanks!
>>>
>>>>>> The page table walker can run concurrently with the memcg reparenting
>>>>>> path
>>>>>> as follows:
>>>>>>
>>>>>> CPU0                           CPU1
>>>>>> ====                           ====
>>>>>>
>>>>>> walk_mm
>>>>>> --> walk_page_range
>>>>>>        --> update_batch_size
>>>>>>            --> walk->nr_pages += delta
>>>>>>
>>>>>>                                  mem_cgroup_css_offline
>>>>>>                                  --> memcg_reparent_objcgs
>>>>>>                                      --> lock lruvec
>>>>>>                                          lru_gen_reparent_memcg
>>>>>>                                          --> reparent child folios to
>>>>>> parent
>>>>>>                                          unlock lruvec
>>>>>>
>>>>>>        lock lruvec
>>>>>>        reset_batch_size
>>>>>>        --> child lrugen->nr_pages += delta
>>>>>
>>>>> The problem here is that, while grabbing a reference to memcg
>>>>> (via mem_cgroup_iter(), for example) makes sure that the memcg is not
>>>>> freed, it does not prevent offlining happening, and reset_batch_size()
>>>>> doesn't check whether the lruvec has been reparented, or the lruvec
>>>>> is going to be reparented.
>>>>>
>>>>>> This will trigger the following warning in lru_gen_exit_memcg():
>>>>>>
>>>>>>       VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
>>>>>>                      sizeof(lruvec->lrugen.nr_pages)));
>>>>>>
>>>>>> To fix it, add lrugen->reparented to remember the new owner of a
>>>>>> reparented lruvec, and make reset_batch_size() charge pending
>>>>>> deltas to
>>>>>> that owner.
>>>>>
>>>>> Could you please explain why it is unavoidable to introduce the new
>>>>> field and why checking whether the cgroup is dying (and charging deltas
>>>>> to non-dying parent) doesn't work?
>>>>
>>>> Peiyang tried doing this [1], but it doesn't work because
>>>> ss->css_offline() is called before clearing the CSS_ONLINE flag.
>>>
>>> Right.
>>>
>>>> I also considered using mem_cgroup_tryget_online(), but that only
>>>> prevent
>>>> the memcg from being freed. It's doesn't prevent the offlining.
>>>
>>> Right.
>>>
>>> I think checking CSS_DYING under RCU and grabbing the lruvec
>>> of the first non-dying memcg should work (this pattern is already
>>> used where we use RCU to guarantee memcgs are not freed).
>>>
>>> If we do not observe CSS_DYING flag, it is safe to charge deltas
>>> to the lruvec because RCU guarantees that reparenting cannot happen
>>> under us.
>>>
>>> If we do observe CSS_DYING, we can walk up the hierarchy and charge
>>> deltas to the first non-dying memcg.
>>
>> Checking CSS_DYING looks feasible, but the rcu lock alone cannot prevent
>> reparenting. We should recheck CSS_DYING after acquiring the lruvec
>> lock, otherwise we might run into the following race:
> 
> Haha, actually, I was thinking of checking CSS_DYING under both RCU and
> lruvec lock. (because that's the pattern)
> 
>>    CPU0 reset_batch_size              CPU1 memcg teardown
>>    =====================              ==================
>>
>>    read !CSS_DYING
>>
>>                                       set CSS_DYING
> 
> Oh, I thought the entire critical section is covered by RCU.
> (I see lock_batch_lruvec() you suggested below doesn't do that)
> 
> Isn't RCU enough to prevent reparenting because RCU guarantees that
> all readers who read !CSS_DYING complete before reparenting?

Oh, I think you are right.

I forgot that offlining is executed in the rcu work context.

Let's walk through this again:

cgroup_destroy_locked
--> kill_css_sync
     --> css->flags |= CSS_DYING;                    1)
     kill_css_finish
     --> css_killed_ref_fn
         --> css_killed_work_fn  <-- RCU work !!     2)
             --> offline_css
                 --> reparent memcg

So while holding the rcu lock, if CSS_DYING is not observed,
css_killed_work_fn() will not be called until rcu_read_unlock().

So lock_batch_lruvec() can be implemented like this:

#ifdef CONFIG_MEMCG
static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
{
	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
	struct mem_cgroup *memcg = lruvec_memcg(lruvec);

	rcu_read_lock();

	/*
	 * The memcg can be NULL when the memory controller is disabled.
	 * Otherwise, the caller keeps the memcg owning @lruvec alive.
	 */
	if (!memcg || !css_is_dying(&memcg->css))
		goto lock;

	do {
		memcg = parent_mem_cgroup(memcg);
	} while (memcg && css_is_dying(&memcg->css));
	lruvec = mem_cgroup_lruvec(memcg, pgdat);

lock:
	spin_lock_irq(&lruvec->lru_lock);

	return lruvec;
}
#else
static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
{
	lruvec_lock_irq(lruvec);

	return lruvec;
}
#endif

Does this make sense?

Thanks,
Qi

> 
> Now I'm confused. Is it strictly required to check CSS_DYING under
> lruvec lock? CSS_DYING is updated outside the lruvec lock anyway?
> 
>>                                       memcg_reparent_objcgs()
>>                                       lock child lruvec
>>                                       move child to parent
>>                                       zero child nr_pages
>>                                       unlock child lruvec
>>
>>    lock child lruvec
>>    charge stale delta to child
>>
>> So it seems lock_batch_lruvec() should be implemented like this:
>>
>> static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
>> {
>>      struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>>
>>      rcu_read_lock();
>> retry:
>>      while (memcg && css_is_dying(&memcg->css))
>>          memcg = parent_mem_cgroup(memcg);
> 
> Isn't this loop unnecessary as spin_lock_irq() -> check CSS_DYING ->
> goto retry does the same thing? (of course, we need to fetch the parent
> memcg before retry then...)
> 
>>      lruvec = mem_cgroup_lruvec(memcg, pgdat);
>>      spin_lock_irq(&lruvec->lru_lock);
>>      if (memcg && unlikely(css_is_dying(&memcg->css))) {
>>          spin_unlock_irq(&lruvec->lru_lock);
>>          goto retry;
>>      }
>>
>>      rcu_read_unlock();
>>
>>      return lruvec;
>> }
> 
> Thanks!
> 


