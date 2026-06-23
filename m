Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAB57CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 09:15:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 975AA6B0092; Tue, 23 Jun 2026 05:15:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94D666B0093; Tue, 23 Jun 2026 05:15:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 863306B0095; Tue, 23 Jun 2026 05:15:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DEA56B0092
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:15:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DCBEC1C5847
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:15:30 +0000 (UTC)
X-FDA: 84910619220.05.38F8288
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id CD1CC80009
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:15:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LObtBUp1;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782206128;
	b=x8ipEpwCTSoZN/w4fk3R4tKVnRhd9DLs1cbyDi/6fqBQTnYGWqJxY55PSUPa6GHff8Cmw5
	PTUxdQDfNncN0R2AkZudAcn9II9yZK26ciyQt76L6X0wDVHnC5KDcIXzbpAsznOKk0aMwt
	kVREBMB7zR3JJgw0t9p4fBSCheT9uvg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782206128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tpZginHVqkNU49eIJBOmNB7unJDksJ/MhSRIVKp8tno=;
	b=ErdRsFMwerYolnPFGIwhJ51mC7LK8707v/TTzuHfQZ0+2hbXZ157Q/Oxh7s7QAe0nFUcoj
	o77IPZh3WnS19FFti3g73h5LcCywE4kLF5ScLVtVoigq0Gy+K/4ckN2zgND5UhIKx4jTNp
	S83zuzM2Rvaec+/dqZn8hohWGhO/Bno=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LObtBUp1;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <7946da94-dc1d-4cf2-986e-466c378665b6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782206124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tpZginHVqkNU49eIJBOmNB7unJDksJ/MhSRIVKp8tno=;
	b=LObtBUp15MZd/tRyF7vr3WJJOlnw8HBAHu6hLIba57mzs7Zah7zHFXPQeIrqlzSiWm2SPx
	cRxNmiT21o/E/q/mMWXss0B5GOBio155kO+Qie4Ve7AXwTvhf7RPepF5ZGbFjhtkDD/LSQ
	W+oRfd2s5LCelV8dP+jrElKGpU8Tx4U=
Date: Tue, 23 Jun 2026 17:14:17 +0800
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <8a76aefd-629c-41f3-b365-aefd4cc1411e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 1x5n6ype7emfzrp1o7dnt16y8jihskwk
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CD1CC80009
X-HE-Tag: 1782206126-540132
X-HE-Meta: U2FsdGVkX19E5o6gvyOPv4z+ZqR1TlmnTJAfzPzVjoh/hD1liDgwxq+vdrlFGKIO8phK22KimehmN5nlxcvnxBPFOlA31pEDWq6QOa9YHv6W8KpYimjhD35B64s1ryMGej6mZDaRjn1I4Hi+0pPhxzEvxasiaCfbjidpa2ZXWgKGrc7hL6iyMLy347nkSM5UPEQonUSDca+xFqBvV2ppAZgHb+NQNEVEdVeXN1wzLr1UDiRA1rO0cdsSc64RnGVgA4yS0Qom95a41eikmCWUWAHkicaJRFVf7OOe9sIj3BWwtua2N5prz3PwHPtZWRBgAF69p6lT/cWcbd7VYUQGFy8EmrQ3Csdw+glQlvR+AQDkVbXldHPeG1fQiy4IRKzVlMiJshytNWJd5vRahRAJLVhPgO5ZafBPmHnqwEqg09MklnKj5/4fjZX3k6KnPDE+B10q4VZGrvYE1OjijQNShWMyQFf5XBPj9rJmmQJkFUZrJOFEN/F9dLPKmRXltfnxqkiPSv68bJryRDWWA3N3iowjBLUpRUmkcpRU5w55BBD61zHeyfydKxNmtc4vIAAqWopRgAR4/IO8nmG9YeJjm3icalokCK0z28AAijsUysgICT/FJx0+AId0eW0Pkbqh5DRKcoHdd/7l+aAZIpsb1SjrsapZqnU018f3s8yxAtQTrJwWAJgB6kXD2MZlQFxhV5u/ld5BeA0+itTOlAV/zuUDtKiCDpBNOplPuFU4LpM0JaUZzEINr3zl1Q4u6UcCakZDUtiT9wJ5zH7aZmcRwZi/RtASD/bCX+NIkObm83egBEMMcalgbaBqQxUeBbEWWjcNdPKxB1rUDzHQhOE5NWXxksfz2HecjAw6wI8jMYipOHgAFDatdv8m2bVGRyJE8D+FWZkLo+Ova8EJuhPjygTymuTJ4lz9deE6/BxHPwsipE8PhTznuhAAB5aCr/h2iItWXLoxiN6qRzyvdkr
 BZEuxGTo
 MSoIoCARm3zCeS6M/CeiSTb6a1RsItK5TZLiTIo5wL8fIL32iluZM9CNr4UAevrn3Mi3oX8QS/etbd+56SeOn5+F+77H4tPld/gC895bnlR13xYxEI3Ay4dkLR/ZDKD+byr+6e47sbQXrzGUdlEwDD2p2aSnR9LITeyR8WgqaVVb9PaLEBGhUDy7/dH5RBQQV2AASQbwdnrBClYYz5c3WpeOlrqTJ8NG2NiSX67yiNX8BAKc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry,

On 6/23/26 4:18 PM, Harry Yoo wrote:
> 
> 
> On 6/23/26 4:16 PM, Qi Zheng wrote:
>> Hi Harry,
> 
> Hi Qi!
> 
>> On 6/23/26 2:17 PM, Harry Yoo wrote:
>>> On 6/23/26 11:42 AM, Qi Zheng wrote:
>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>
>>>> The mglru page table walker batches per-generation size deltas in
>>>> walk->nr_pages while walking page tables without holding the lruvec
>>>> lock.
>>>> The reset_batch_size() later folds those deltas into walk->lruvec under
>>>> the lruvec lock.
>>>
>>> Ouch.
>>>
>>> IIRC the user-visible impact of underestimated nr_pages in MGLRU
>>> was premature OOMs because MGLRU does not try to reclaim memory when
>>> nr_pages reaches zero, but there are still more pages.
>>>
>>> Perhaps worth mentioning in the changelog?
>>
>> Maybe this should be placed before "To fix it...".
> 
> Thanks!
> 
>>>> The page table walker can run concurrently with the memcg reparenting
>>>> path
>>>> as follows:
>>>>
>>>> CPU0                           CPU1
>>>> ====                           ====
>>>>
>>>> walk_mm
>>>> --> walk_page_range
>>>>       --> update_batch_size
>>>>           --> walk->nr_pages += delta
>>>>
>>>>                                 mem_cgroup_css_offline
>>>>                                 --> memcg_reparent_objcgs
>>>>                                     --> lock lruvec
>>>>                                         lru_gen_reparent_memcg
>>>>                                         --> reparent child folios to
>>>> parent
>>>>                                         unlock lruvec
>>>>
>>>>       lock lruvec
>>>>       reset_batch_size
>>>>       --> child lrugen->nr_pages += delta
>>>
>>> The problem here is that, while grabbing a reference to memcg
>>> (via mem_cgroup_iter(), for example) makes sure that the memcg is not
>>> freed, it does not prevent offlining happening, and reset_batch_size()
>>> doesn't check whether the lruvec has been reparented, or the lruvec
>>> is going to be reparented.
>>>
>>>> This will trigger the following warning in lru_gen_exit_memcg():
>>>>
>>>>      VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
>>>>                     sizeof(lruvec->lrugen.nr_pages)));
>>>>
>>>> To fix it, add lrugen->reparented to remember the new owner of a
>>>> reparented lruvec, and make reset_batch_size() charge pending deltas to
>>>> that owner.
>>>
>>> Could you please explain why it is unavoidable to introduce the new
>>> field and why checking whether the cgroup is dying (and charging deltas
>>> to non-dying parent) doesn't work?
>>
>> Peiyang tried doing this [1], but it doesn't work because
>> ss->css_offline() is called before clearing the CSS_ONLINE flag.
> 
> Right.
> 
>> I also considered using mem_cgroup_tryget_online(), but that only prevent
>> the memcg from being freed. It's doesn't prevent the offlining.
> 
> Right.
> 
> I think checking CSS_DYING under RCU and grabbing the lruvec
> of the first non-dying memcg should work (this pattern is already
> used where we use RCU to guarantee memcgs are not freed).
> 
> If we do not observe CSS_DYING flag, it is safe to charge deltas
> to the lruvec because RCU guarantees that reparenting cannot happen
> under us.
> 
> If we do observe CSS_DYING, we can walk up the hierarchy and charge
> deltas to the first non-dying memcg.

Checking CSS_DYING looks feasible, but the rcu lock alone cannot prevent
reparenting. We should recheck CSS_DYING after acquiring the lruvec
lock, otherwise we might run into the following race:

   CPU0 reset_batch_size              CPU1 memcg teardown
   =====================              ==================

   read !CSS_DYING

                                      set CSS_DYING
                                      memcg_reparent_objcgs()
                                      lock child lruvec
                                      move child to parent
                                      zero child nr_pages
                                      unlock child lruvec

   lock child lruvec
   charge stale delta to child

So it seems lock_batch_lruvec() should be implemented like this:

static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
{
	struct mem_cgroup *memcg = lruvec_memcg(lruvec);

	rcu_read_lock();
retry:
	while (memcg && css_is_dying(&memcg->css))
		memcg = parent_mem_cgroup(memcg);

	lruvec = mem_cgroup_lruvec(memcg, pgdat);
	spin_lock_irq(&lruvec->lru_lock);
	if (memcg && unlikely(css_is_dying(&memcg->css))) {
		spin_unlock_irq(&lruvec->lru_lock);
		goto retry;
	}

	rcu_read_unlock();

	return lruvec;
}

This way, there is no need to add lrugen->reparented, right?

Thanks,
Qi


