Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93B0BD1036F
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 02:45:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF79A6B0006; Tue, 25 Nov 2025 21:45:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCEBA6B0008; Tue, 25 Nov 2025 21:45:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0BA76B000C; Tue, 25 Nov 2025 21:45:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AFB216B0006
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 21:45:24 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3435D1A17D3
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 02:45:24 +0000 (UTC)
X-FDA: 84151216968.27.B8AD735
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id 32939140004
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 02:45:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EinoyG3g;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764125122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WR/tG/fXd1FIx5kgs0c7mUUaG40bMBvPGKIqdKa16DI=;
	b=wMIwSdLJaHX2HA9zY68n6rfss3T3fhjC/gBysCn2qZEXDqSfcgYveNuuxnTOW4GoyC0zLd
	CEJGJmVAPYgsx4fkBmLMUJ5F+cuppHW754ksb5o2iai+l0VkOFwf9c3BdUZulc0rxxkJf/
	du4pyF6s0w3uBBVvqOkzWgU+aqnkiYc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EinoyG3g;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764125122; a=rsa-sha256;
	cv=none;
	b=kuZmU5yIiEhFYMFXt+QtOLRG/5RS9ujnqqAoeIfUvL7FoY320boVtyMjOf/d6a7uSSKgbV
	zW/l5esC+VWnzbxvp10crhYXNhiCYRRHplxrNW8tWs7P+y8gwe4ajX8CtXa5W4xrPc31Za
	WzF/Ebg29mdUOcdJ+glnz5FXGSApFZU=
Message-ID: <f208ee30-c0b1-426b-b5e6-5ab358877ad4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764125119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WR/tG/fXd1FIx5kgs0c7mUUaG40bMBvPGKIqdKa16DI=;
	b=EinoyG3gLBkrH9Rc9OfSH7oVgLRpr9vJlvoqwGPC96MiTQv8DiMdvSshDddppOpgPVRSof
	O1xmrW+BPJqmU93kJgVFre4hks7hQuEGXqOtUNImUjjXEFf+Ph+KS/VJhsjQPWS/C2jBlF
	cMncr+rrLcPXKJ1MwN+BIbvIJ9P4uMg=
Date: Wed, 26 Nov 2025 10:44:05 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 23/26] mm: vmscan: prepare for reparenting MGLRU folios
To: Harry Yoo <harry.yoo@oracle.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <cdcedd284f5706c557bb6f53858b8c2ac2815ecb.1761658311.git.zhengqi.arch@bytedance.com>
 <aSV9ANXym0UDhE2j@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aSV9ANXym0UDhE2j@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 32939140004
X-Rspamd-Server: rspam02
X-Stat-Signature: eyqdxte1ucd6osk47b61i7wn1kt5d33x
X-Rspam-User: 
X-HE-Tag: 1764125121-26468
X-HE-Meta: U2FsdGVkX19eEvp7ga77AmWYndzFVz4DQ2vzq6ZFyxeEhjzbnLg1Rw7mwvGLGOboBnBC5cqH3+WL11vC8wFW9VopOqcDU2o5kJrH359dGgCJM4wkTcOWbCqM6ivHCBYv1gtoL9ehwNjHh1TsPbGcTdsNBsaIq6ZnyrgqN0L06flhLWG+HiGa7TbnxJW5d/BdEY8sSZns+RKzzHs1//G1V7TssRcWsBWakmeNEeXw1/3lwDJByK+vJy1jkuPtzdch6EQJr6qkSQui7ZyJGLgsugqUEQE4AgDZ7eX8P1wZo3B98R78AfS5/D+215PUqLHEdVQlomIhaBTywlaneLzr6u/I7nojiaM+72JoUtu3gpzwownlhm79FcdxAIHXZ/lGA7TAgs/VP1IFD5RARwANMF6RqQRBLpcR7FftJXzU5CDwBbtF3BglSwtJY+gSQf4SdIOIDecMoB/JKiKQ01lKhjj50elK/mGdCA6s0Ts/oBbTQ56TaVWBOH1v99DHDSEqYEK4khTctHsLrcmFJH43wAmTC2848TtnMcoXpC67sWV8tpiBc2fDU1BlTt8QC+aDlShJxAr+TnZ7o8RuGatbu54+VDA/Jxkv45SzztD9lRsm3eFmZdNAFiSU1V3wFFCE/hL3TKQPJUjtMCU2RrPbeq4+jTpNh8GX2JEt/lwFVWQVngct+wp1pkZIGLb2ZeH3aSzaJ/NGiPqdkDNKGIELb9sod/tRRjSbBiyMxIVcefRPhf/W1nNlKQDCyqULIAtO73wcdXRjBCVwtqHsG2BK4m6rRkJEYfIwsTnvrhc9YEISyV2Urr6ckntFFIFElVIoNli58OtfhVDrEsBQQtkkT3sMafP8QlkOX+8rtxtJoL+/NxW2BZjoUzlRrD2i0dBiYA5KZko6eiW9vhdxoU3bL9gn4e9rr1JoJcX42m87e44YGKL6lKSWcg7wZPEiPYn53DIFpgd8psNHWBlARBV
 1Gff3VY9
 KMkMloaZZcM7ZUCDMXNctTogPrif4VTo2NIcEsnWdQVQkHmyl0nJCZdNX2+Rasx5Hrqdz10a07z3YZZvMpUpFqFommb5pbQNqZ09P0qBTvFEafKBBorcX92ATxLFFupqRO7fpb6BTRxnqKEVL7Rm4fq14kFObM2fRt++i2ibGxAGHBcWe+7zQBaNpMvD8Mp+knv8xznTaysHi/zlnLIdEW64kWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/25/25 5:55 PM, Harry Yoo wrote:
> On Tue, Oct 28, 2025 at 09:58:36PM +0800, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Similar to traditional LRU folios, in order to solve the dying memcg
>> problem, we also need to reparenting MGLRU folios to the parent memcg when
>> memcg offline.
>>
>> However, there are the following challenges:
>>
>> 1. Each lruvec has between MIN_NR_GENS and MAX_NR_GENS generations, the
>>     number of generations of the parent and child memcg may be different,
>>     so we cannot simply transfer MGLRU folios in the child memcg to the
>>     parent memcg as we did for traditional LRU folios.
>> 2. The generation information is stored in folio->flags, but we cannot
>>     traverse these folios while holding the lru lock, otherwise it may
>>     cause softlockup.
>> 3. In walk_update_folio(), the gen of folio and corresponding lru size
>>     may be updated, but the folio is not immediately moved to the
>>     corresponding lru list. Therefore, there may be folios of different
>>     generations on an LRU list.
>> 4. In lru_gen_del_folio(), the generation to which the folio belongs is
>>     found based on the generation information in folio->flags, and the
>>     corresponding LRU size will be updated. Therefore, we need to update
>>     the lru size correctly during reparenting, otherwise the lru size may
>>     be updated incorrectly in lru_gen_del_folio().
>>
>> Finally, this patch chose a compromise method, which is to splice the lru
>> list in the child memcg to the lru list of the same generation in the
>> parent memcg during reparenting. And in order to ensure that the parent
>> memcg has the same generation, we need to increase the generations in the
>> parent memcg to the MAX_NR_GENS before reparenting.
>>
>> Of course, the same generation has different meanings in the parent and
>> child memcg, this will cause confusion in the hot and cold information of
>> folios. But other than that, this method is simple enough, the lru size
>> is correct, and there is no need to consider some concurrency issues (such
>> as lru_gen_del_folio()).
>>
>> To prepare for the above work, this commit implements the specific
>> functions, which will be used during reparenting.
>>
>> Suggested-by: Harry Yoo <harry.yoo@oracle.com>
>> Suggested-by: Imran Khan <imran.f.khan@oracle.com>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   include/linux/mmzone.h | 16 ++++++++
>>   mm/vmscan.c            | 86 ++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 102 insertions(+)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 7aa8e1472d10d..3ee7fb96b8aeb 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -4468,6 +4468,92 @@ void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
>>   		lru_gen_rotate_memcg(lruvec, MEMCG_LRU_HEAD);
>>   }
>>   
>> +bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg)
>> +{
>> +	int nid;
>> +
>> +	for_each_node(nid) {
>> +		struct lruvec *lruvec = get_lruvec(memcg, nid);
>> +		int type;
>> +
>> +		for (type = 0; type < ANON_AND_FILE; type++) {
>> +			if (get_nr_gens(lruvec, type) != MAX_NR_GENS)
>> +				return false;
>> +		}
>> +	}
>> +
>> +	return true;
>> +}
>> +
>> +/*
>> + * We need to ensure that the folios of child memcg can be reparented to the
>> + * same gen of the parent memcg, so the gens of the parent memcg needed be
>> + * incremented to the MAX_NR_GENS before reparenting.
>> + */
>> +void max_lru_gen_memcg(struct mem_cgroup *memcg)
>> +{
>> +	int nid;
>> +
>> +	for_each_node(nid) {
>> +		struct lruvec *lruvec = get_lruvec(memcg, nid);
>> +		int type;
>> +
>> +		for (type = 0; type < ANON_AND_FILE; type++) {
>> +			while (get_nr_gens(lruvec, type) < MAX_NR_GENS) {
>> +				DEFINE_MAX_SEQ(lruvec);
>> +
>> +				inc_max_seq(lruvec, max_seq, mem_cgroup_swappiness(memcg));
>> +				cond_resched();
>> +			}
> 
> To best of my knowledge this looks functionally correct.
> 
>> +		}
>> +	}
>> +}
>> +
>> +static void __lru_gen_reparent_memcg(struct lruvec *src_lruvec, struct lruvec *dst_lruvec,
>> +				     int zone, int type)
>> +{
>> +	struct lru_gen_folio *src_lrugen, *dst_lrugen;
>> +	enum lru_list lru = type * LRU_INACTIVE_FILE;
>> +	int i;
>> +
>> +	src_lrugen = &src_lruvec->lrugen;
>> +	dst_lrugen = &dst_lruvec->lrugen;
>> +
>> +	for (i = 0; i < get_nr_gens(src_lruvec, type); i++) {
>> +		int gen = lru_gen_from_seq(src_lrugen->max_seq - i);
>> +		int nr_pages = src_lrugen->nr_pages[gen][type][zone];
> 
> nr_pages should be long type since nothing prevents us from reparenting
> more than 2 billions of pages :)

Right. The lru_gen_folio.nr_pages is long type, I don't know how I ended
up writing it as an int type.

Will fix it in the next version.

> 
> Otherwise looks correct to me.

Thanks!

> 


