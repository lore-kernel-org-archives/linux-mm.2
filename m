Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB27FC98315
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 03:36:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 400236B00F3; Sun, 18 Jan 2026 22:36:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B70D6B00F5; Sun, 18 Jan 2026 22:36:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E3BC6B00F6; Sun, 18 Jan 2026 22:36:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1FA5A6B00F3
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 22:36:45 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB3A2C20DA
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:36:44 +0000 (UTC)
X-FDA: 84347301528.29.D8CC825
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id EFE2680004
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:36:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K4oPwNFi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768793803; a=rsa-sha256;
	cv=none;
	b=pTT5QWeZGoHG/1rPAiVf2I77gKY1jBQC+FnA+yfZlFu/fvNK3yqYNuX6nTenAarxHksIFO
	U123yY66ipBYN6U7OVETqCKKn53sNJkRCr7mpi5SpAQzltc1Z53Ss5SXL2xsrNk0+7H64F
	p6YAFk8Wbb2KeF8OnckGQuRgT4pKJ4s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K4oPwNFi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768793803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zjUkuAvDq1kbP7Yz/kqOd0wZArWceBOYUbLr4Pg1vNY=;
	b=xTdWDCMqdHvh95ZyXrrkNwCoBz+1Ewtp+mXY5RwLkC2vNdj2IDTOpC85E5sjWNt/X2YlAl
	vSjts1pSof4yi7TDE98Iq4iXGhmVr+s5jtVdNePjowmur6dqnvbrHVw/2OB5DfgmYHEwHq
	mZ18kywdfd0nS4N9SAgFU9Bqp/AeOjg=
Message-ID: <5a18658e-2076-4cbf-bc53-5b6e99c1035f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768793800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zjUkuAvDq1kbP7Yz/kqOd0wZArWceBOYUbLr4Pg1vNY=;
	b=K4oPwNFiGFyV+NJw8nAVDM3CJA8PoBCifJDZPx/uLBRBFo+8Qmj7a30s9y4H3X5t8xkNgL
	pzljrwvHFb6sOYYSokqdt4hp5Phu4hiR+XFrsv+DLJXgwdd9cw6Mw9oGdzn7lz1kWd488L
	U66g/pBHYQmdIXzkKIFueEgnOYtxk78=
Date: Mon, 19 Jan 2026 11:36:24 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 28/30 fix 1/2] mm: memcontrol: fix
 lruvec_stats->state_local reparenting
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <b11a0bde9fe18673a61a79398f226ad7cb04a894.1768389889.git.zhengqi.arch@bytedance.com>
 <e5afd1b5ae95d70f82433b9b4e13201342d16707.1768473427.git.zhengqi.arch@bytedance.com>
 <ifcth3hxyrwmmeo3nejettdtkw2ndxdjbylszmhq3vohuhsncl@k23pew6gywko>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <ifcth3hxyrwmmeo3nejettdtkw2ndxdjbylszmhq3vohuhsncl@k23pew6gywko>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EFE2680004
X-Stat-Signature: ys87qwcxbpd3jb97brb8x8tmtrx7wwq5
X-Rspam-User: 
X-HE-Tag: 1768793802-710342
X-HE-Meta: U2FsdGVkX18TPR8ZYt4mnnJ0/B3fMbniic2Jmvg4hmKaHW77l8nIMUVOVn3A4xZ0DM+VNAvq1gh/LdMRkPeWkeSXXWXejsS3CAVYuXQS0BfiF7yINpcqlJ2I+HeH4EKKgzSOqnrTWLoyvlTcWMuUVJv3qaPiRn05eLmvwQK4d+pxUl2JKemjVHpoPsa28+JjI5ebDsNY6qYdrgpYudgyr2KF/cCWTNOyFh2SYDOH3AcYakRZQ5ledphFyKAzYfjw2RmD1TuhK4xAVkhIHnHvFQPOd2e8YdUc0lgE1tdYkyWXtXGYwhdgbiw0TTCX6VwxhnHHagsFFXUeoDL2X0G9GBAHSQNrhBnywi67881eQnGiaYBK9UktRsfp1ITJXob2WEAeZ45m8q5LqOQvRelxGiqRhTfxFnJcFkqKsd2cwFNh51HvQgVDiSU3CTRS0chHmWdck9+sqaaQbFCyaN1fSdAtG9EPKF2SCrrxj1qvh2U+RnIAWZsiD7J4sOPsiMC+GnwoeqzZImjA3UM/NQ0E8Zt6ePEjWKRypRQZ0rPZqK17h/ose89hcb2uDujaLrus+wAOs7DYH6o0hNaR18PzuZoP7TU4RL09efMb5pmQ3YDjJhAn2XckgfaejcBu9e4GigQ4iJ53LY/WnEPjHeB9zCAenaqaHbUTgGADxmgAtBSg1fO4FdgqT/d/ikTdBF4f9Dx+GEJ8Tzt75nRbaZW6QFhMy/zR9x6CD31p0AV79km9V56t2jj2w3/N1o97XYznUoKnkC1KrxZZpFC75ih0JWH7eSqYZFDahzU2AY/M2xUtVK/nI4GuYN3+CI7DBpfRTK1czR4gbsE40W84aiyFcwNsdCc63Oa9vihth69QGr7/4XGdwxhRi+BmG0wxncv8VrrsR5/PeX01uU1609AqV/s41Fzh+KqyoF+n/bh7YKRckAm5ddsnyXrzjcn7Dp4RvupXFc62SgUA/JucCJZ
 NIKmDA40
 goXIhJFTW9liKr1U+7Qsk3DjNZpNWbE4F40ZIY91OgWceH/Hbg+QCir03GQpXMWlfxJtA0G4LRE28nKh8gpJicg1UUMING2Xxr0gIdvGsMj4wz/3icl9ShLtV/c+gkamTAXJUHzmHSXtuDWjM1fhSucHAA/U6H6aaLQV+1E5CAjcSeHX8O9CvpscGBXEsJwx9Zzr7cC9q//FrcctOpCJficcEuunUp2Np8Jr7Cqf9J62SAjxFkTM/dst9rSPHXiBopD2qkFzISyhzn+GN9TTT/PerkaSYjpcY0we5nA0R5WrnEOZ03CciC276j1SPQ3kjviAg/09fLYDVDZXTNJ2wJl5djfhCsadgSuCg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/18/26 11:22 AM, Shakeel Butt wrote:
> On Thu, Jan 15, 2026 at 06:41:38PM +0800, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   include/linux/memcontrol.h |  2 --
>>   mm/memcontrol-v1.c         |  8 --------
>>   mm/memcontrol-v1.h         |  5 ++++-
>>   mm/memcontrol.c            | 19 ++++++++-----------
>>   4 files changed, 12 insertions(+), 22 deletions(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index 1fe554eec1e25..e0b84b109b7ac 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -944,8 +944,6 @@ bool memcg_vm_event_item_valid(enum vm_event_item idx);
>>   unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx);
>>   unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>>   				      enum node_stat_item idx);
>> -void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>> -				       struct mem_cgroup *parent, int idx);
>>   
>>   void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
>>   void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
>> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
>> index 03b924920d6a5..daf9bad8c45ea 100644
>> --- a/mm/memcontrol-v1.c
>> +++ b/mm/memcontrol-v1.c
>> @@ -1909,14 +1909,6 @@ void reparent_memcg1_state_local(struct mem_cgroup *memcg, struct mem_cgroup *pa
>>   		reparent_memcg_state_local(memcg, parent, memcg1_stats[i]);
>>   }
>>   
>> -void reparent_memcg1_lruvec_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
>> -{
>> -	int i;
>> -
>> -	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++)
>> -		reparent_memcg_lruvec_state_local(memcg, parent, memcg1_stats[i]);
>> -}
>> -
>>   void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
>>   {
>>   	unsigned long memory, memsw;
>> diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
>> index 45528195d3578..5b1188f3d4173 100644
>> --- a/mm/memcontrol-v1.h
>> +++ b/mm/memcontrol-v1.h
>> @@ -75,7 +75,6 @@ void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
>>   
>>   void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s);
>>   void reparent_memcg1_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent);
>> -void reparent_memcg1_lruvec_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent);
>>   
>>   void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages);
>>   static inline bool memcg1_tcpmem_active(struct mem_cgroup *memcg)
>> @@ -116,6 +115,10 @@ static inline void memcg1_uncharge_batch(struct mem_cgroup *memcg,
>>   
>>   static inline void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s) {}
>>   
>> +static inline void reparent_memcg1_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
>> +{
>> +}
>> +
>>   static inline void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages) {}
>>   static inline bool memcg1_tcpmem_active(struct mem_cgroup *memcg) { return false; }
>>   static inline bool memcg1_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 7333a37830051..b7b35143d4d2d 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -225,13 +225,13 @@ static inline struct obj_cgroup *__memcg_reparent_objcgs(struct mem_cgroup *memc
>>   	return objcg;
>>   }
>>   
>> -#ifdef CONFIG_MEMCG_V1
>> +static void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>> +					      struct mem_cgroup *parent, int idx);
>>   static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force);
>>   
>>   static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
>>   {
> 
> No reparenting local stats for v2.

It seems that lruvec_stats->state_local (non-hierarchical) needs to be
relocated in both v1 and v2.

> 
>> -	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
>> -		return;
>> +	int i;
>>   
>>   	synchronize_rcu();
>>   
>> @@ -239,13 +239,10 @@ static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgr
>>   
>>   	/* The following counts are all non-hierarchical and need to be reparented. */
>>   	reparent_memcg1_state_local(memcg, parent);
>> -	reparent_memcg1_lruvec_state_local(memcg, parent);
>> -}
>> -#else
>> -static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
>> -{
>> +
>> +	for (i = 0; i < NR_LRU_LISTS; i++)
>> +		reparent_memcg_lruvec_state_local(memcg, parent, i);
>>   }
>> -#endif
>>   
>>   static inline void reparent_locks(struct mem_cgroup *memcg, struct mem_cgroup *parent)
>>   {
>> @@ -510,8 +507,8 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>>   	return x;
>>   }
>>   
>> -void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>> -				       struct mem_cgroup *parent, int idx)
>> +static void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>> +					      struct mem_cgroup *parent, int idx)
>>   {
>>   	int i = memcg_stats_index(idx);
>>   	int nid;
>> -- 
>> 2.20.1
>>


