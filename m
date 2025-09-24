Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE465CAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 10:06:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48C398E0015; Wed, 24 Sep 2025 06:06:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 463E38E0001; Wed, 24 Sep 2025 06:06:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32BFE8E0015; Wed, 24 Sep 2025 06:06:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1CDBD8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 06:06:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D87B614078B
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:06:28 +0000 (UTC)
X-FDA: 83923714056.29.EE99726
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id DE37A16000C
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:06:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hIlxiOeT;
	spf=pass (imf08.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758708387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EfE2mgVlyr7iNmaZ4vQXyrWE/ZvZPrZL7XGUEK7ATPc=;
	b=qhE/zP0vwdfu8ogweYpa+dy3jZCGZcHSVepbwY6aRGpuK23gfw/zUnqfZmp85VnAMkaXuj
	At7kcQYh2tVoi/+sURfdRGAiamEv7LBZOssOCbrdR4qMLj50npKphp0vqxt0zDCuauglWL
	59XWLLHZbHfbXQtGSKYcWdvMax2K/oE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hIlxiOeT;
	spf=pass (imf08.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758708387; a=rsa-sha256;
	cv=none;
	b=Jf7e5BrhGALI3nawYjo4tpLd7sQkRFCu1lQdgVOCVZsZP56hiK30jJoHnxSVMKlS6npuSu
	ED3xtbDtCBhqLKkmk2Dvz33yBc75cT6JBLwe/GHlaePgtwViXG9jahBta6aGxqi4cT47Qw
	oO6wULKllnSIN0gfnzFahdykYevusts=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-780292fcf62so296467b3a.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 03:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758708386; x=1759313186; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EfE2mgVlyr7iNmaZ4vQXyrWE/ZvZPrZL7XGUEK7ATPc=;
        b=hIlxiOeTWwOj20rM4LH8M2+AAUgzFtHLMGfxQQ6wXMW2Ii6z22q1/7hhivDDmtrRfF
         M3D2aqleNv1JuXXYGdYMxCy1rUd1NMkNTOeR59awp+kPfRqPmk9jsDe6JZ2FmrJ1ioOL
         XQizazOo5O6bViR6EdjQ9ctE9vqvUH0/EXvLbq4XxiNAWSeElvFWlSIZRykgGrcTEMSD
         +Iaj0Cu6QCcFlCcUA1brxhF6yN97GoBUniJXoZ0zgLA1ORIrZN2RjfXaQ50PsdR9Fs9d
         y5dUPwR9NKTXaoboX1NevSrFJiXWFfdt1lQDwlf1suVQAsiDJA6tanh8ouV3bykopdVT
         BdPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758708386; x=1759313186;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EfE2mgVlyr7iNmaZ4vQXyrWE/ZvZPrZL7XGUEK7ATPc=;
        b=FgZgLbiumfVqfVmdiGXsNo60w7XbD9zc1EDPTSVo7Gnwi7y8s4iQGepvuszSC5t2Cc
         vH+7ZJfP+mfb3ZuXfmCP1IZ8XVHcjLdn3Ul8RbzCJUGvOKozkTzRr2OY+v8wbmQnuWC5
         aZ4OEKlBOOLJ6Qv1ytJmKXaGfpj2amuvTRAIpVPjpYqQyB6ODTauZJH9ar8P4I/GEr1i
         4omHBMHFsHEIuGXl3jaRytOUbdNoABy1yndallRdYcCLhW/zTiAFZYhtAXb2Iahd+za+
         88kGgvjXEDUd/y3L/mjCNbJXgi8v/XJtImJ8WC0oMl5iQEO7rhGWdVC1cbg/SOwc75Wc
         THRw==
X-Forwarded-Encrypted: i=1; AJvYcCUcI1m77xprlPmdDD9CIqF/yEB/zK996mKgGCOYDZ8PPNN6kTBY9FXSwTzKGg/uKDYeSaIoEi8Tkg==@kvack.org
X-Gm-Message-State: AOJu0YxR54YyaE9nOSH0rnIXuHVyAqXVQau0xVLIyM1X2853AnW7x2Mh
	I+ftnuMxtX+RZ9HzPLdf/UgETtKDDBk06+SeFct7NdOJGI2G1rVGRYExjH0yuq1E6C4=
X-Gm-Gg: ASbGncub0V5hOwloHrIvi00+nXRgV5/AymW+ZySx/nYroIcIuHOcPFfE3tPmU0tQHt9
	CGSe6vDStJn0W1pQxBYV83hYQk/7nrghUejKi98MsgtdfoRVvnWYKChbPbWpjuSm0vzEZz0KufG
	hFLChGZYz0uyRDxbnDL7BNthPfqK/TGhJxH2vfTa/iL5Jo28NfQuEgLzIJo9X7vfqKCNdTREGLr
	IR6JkYhCso8LYrjllE9iddNxVegJTFl8Q6VtulK9DJbLVhk8KUpbGEtOKIaSyevIcC+co4/JKD/
	K/YwYQzvypojCyAY9PUj5YzIdQ36WRlCptm/nbTgaNoQHoR7rOLqrDTfUoR8xT5GpMv83SJUpqb
	GH5tmzuREs2KqTgeoE3GJ8LVX7fISs6eig3DUQoMh8jG2W5NQfEOh54qH3yiyFFOz62qv
X-Google-Smtp-Source: AGHT+IFhsnsZYVlejzedhp8ryD+eY+C2FjhYDyPffnI2uMukcLjw9DOqyDy7/D84SWZQ/6CRngyUhw==
X-Received: by 2002:a05:6a00:1990:b0:77f:1a7e:7bc0 with SMTP id d2e1a72fcca58-77f53acfa71mr6945066b3a.31.1758708385394;
        Wed, 24 Sep 2025 03:06:25 -0700 (PDT)
Received: from [100.82.90.25] ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77f0da43089sm13920289b3a.90.2025.09.24.03.06.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 03:06:24 -0700 (PDT)
Message-ID: <72d23e4d-6c59-4adf-86ba-aa3ae8566bde@bytedance.com>
Date: Wed, 24 Sep 2025 18:06:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm: thp: reparent the split queue during memcg
 offline
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 shakeel.butt@linux.dev, muchun.song@linux.dev, david@redhat.com,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <cover.1758618527.git.zhengqi.arch@bytedance.com>
 <55370bda7b2df617033ac12116c1712144bb7591.1758618527.git.zhengqi.arch@bytedance.com>
 <7ia4bjn06w62.fsf@castle.c.googlers.com>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <7ia4bjn06w62.fsf@castle.c.googlers.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DE37A16000C
X-Stat-Signature: bnf4usy1fhcgtw9om41s6cpmdewos5ax
X-HE-Tag: 1758708386-317849
X-HE-Meta: U2FsdGVkX19KQ+zJtZf1aY8oeA372oDMXWhBkUmkW3kYqDcaKoN/CujGEqtUPmln7M8tf8MkZhgvt/mta0sczsaEMDyaXiY2PsA4yKynwzPbH8bLRxnIsNI35sciFDViuv80P/+E7FuT4apZkcx/3dmAvYjjehaGppywpqlTtLNjBU7GzIFvOzLPDM1qcG+rSwKJI1/JTsSMBSM/435kqw2BPPm9BtdsJdpm5K1pMEytcMncNRXh7d/KpCJxcjraRvI4zIh/nsmgHjqS0FrlNWgL7ysmD2aJ/Z5ckPvIVbEM2ogSvvSwcPCV2ztCbir/xh+RywH9QboD1N8s2FgwDM+QUPa83RYjVl8r1uorgfKzmneQKc0U3s2jwN0on4i22snjNTIc/rI0Vsv6foAnRPZcvIuMyqzKnd5D825jzePPaS81eMN6kbFTuc/pgNkQj/qO44deyCqoeF4XYvIvzGiEATt5KYlcaqhqVZq7TmvGU3uO2G0bxhgIYuVWPN7bJA3FCsBkPsv9Ibo4IHWxvbH9WkNWvQ7ca0ZFoTO6p513TT47DFHMAjKktR01//TOSfHKRgKm04dRPCGYM3tLw8i2lg6ysFdAjNT7WRloYroD09vWVnL9V3pZJZXtM/LIG17YZNsetC472VMtDRBmNnbRyGDIyQ8U0BcIMoJJiYwqWlbVMdTa0pnIZhwxNrdJlddrpYhLbBuJq0QSPuAfIUxKY83tuVMR/jnudpXJaumYtWyJMH7kRKhRzlr0VLXV1NhGWTdQPiTuvRbNTv4JH6XP7oI2ta2NbfXNN6QnVwPOnw59+JthvxTTvVij7+oCuh5+eD2Ox3AQlugyDrjDL7ibXD796p9lyuL1Yj0xZOw1/fteL303FB2wSYiOVggamVzyd2HeCwDQljZbfBFn0AvYLvyqHC0AD0XcwTSkiB6H3/58zihYstXypwEpUdCz+SFkfaArnw95SIngtIs
 dBASrTED
 DVZd9B6kBA793ksrhdZoiaLhrMmpD76wVH6Nurml+ncr41smOD+AwyO5l4MkrqoXgjqt2lYn60tLuVhMaPkb6qzHi6XeXqbaob3py2VtSc2+lGwID481SYwzO6zvr3eYvvftcVJ8P4vulWdk1r4XeFA3XNKn06rfhvwSrdpaPPhWurPr6i1wWu30qQdSp7dqH9o9eIohGCu8g8Ec8LCLZ3sn9u5JrpfyY8+i5bFlLltchnyRWYWxWCO9Dnf5LKqnXWz7zChleOn91yR5RHybPioyEpwRmGBwveBuj9lsB8eMy8pWLjZVjyIBQ+8avIC09Pkg4tk87zr7JApfrNvouw2xjA16ip7UQL12YLQyl3jcIEHYhwHeV/0iPX2d2owqXMGh32KGI6Ra+LgA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Roman,

On 9/24/25 5:23 PM, Roman Gushchin wrote:
> Qi Zheng <zhengqi.arch@bytedance.com> writes:
> 
>> In the future, we will reparent LRU folios during memcg offline to
>> eliminate dying memory cgroups, which requires reparenting the split queue
>> to its parent.
> 
> Nit: commit logs should really focus on the actual change, not the future
> plans.

Got it.

> 
>>
>> Similar to list_lru, the split queue is relatively independent and does
>> not need to be reparented along with objcg and LRU folios (holding
>> objcg lock and lru lock). So let's apply the same mechanism as list_lru
>> to reparent the split queue separately when memcg is offine.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   include/linux/huge_mm.h |  2 ++
>>   include/linux/mmzone.h  |  1 +
>>   mm/huge_memory.c        | 39 +++++++++++++++++++++++++++++++++++++++
>>   mm/memcontrol.c         |  1 +
>>   mm/mm_init.c            |  1 +
>>   5 files changed, 44 insertions(+)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index f327d62fc9852..a0d4b751974d2 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -417,6 +417,7 @@ static inline int split_huge_page(struct page *page)
>>   	return split_huge_page_to_list_to_order(page, NULL, ret);
>>   }
>>   void deferred_split_folio(struct folio *folio, bool partially_mapped);
>> +void reparent_deferred_split_queue(struct mem_cgroup *memcg);
>>   
>>   void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
>>   		unsigned long address, bool freeze);
>> @@ -611,6 +612,7 @@ static inline int try_folio_split(struct folio *folio, struct page *page,
>>   }
>>   
>>   static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
>> +static inline void reparent_deferred_split_queue(struct mem_cgroup *memcg) {}
>>   #define split_huge_pmd(__vma, __pmd, __address)	\
>>   	do { } while (0)
>>   
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index 7fb7331c57250..f3eb81fee056a 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -1346,6 +1346,7 @@ struct deferred_split {
>>   	spinlock_t split_queue_lock;
>>   	struct list_head split_queue;
>>   	unsigned long split_queue_len;
>> +	bool is_dying;
>>   };
>>   #endif
>>   
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 48b51e6230a67..de7806f759cba 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -1094,9 +1094,15 @@ static struct deferred_split *folio_split_queue_lock(struct folio *folio)
>>   	struct deferred_split *queue;
>>   
>>   	memcg = folio_memcg(folio);
>> +retry:
>>   	queue = memcg ? &memcg->deferred_split_queue :
>>   			&NODE_DATA(folio_nid(folio))->deferred_split_queue;
>>   	spin_lock(&queue->split_queue_lock);
>> +	if (unlikely(queue->is_dying == true)) {
>> +		spin_unlock(&queue->split_queue_lock);
>> +		memcg = parent_mem_cgroup(memcg);
>> +		goto retry;
>> +	}
>>   
>>   	return queue;
>>   }
>> @@ -1108,9 +1114,15 @@ folio_split_queue_lock_irqsave(struct folio *folio, unsigned long *flags)
>>   	struct deferred_split *queue;
>>   
>>   	memcg = folio_memcg(folio);
>> +retry:
>>   	queue = memcg ? &memcg->deferred_split_queue :
>>   			&NODE_DATA(folio_nid(folio))->deferred_split_queue;
>>   	spin_lock_irqsave(&queue->split_queue_lock, *flags);
>> +	if (unlikely(queue->is_dying == true)) {
>> +		spin_unlock_irqrestore(&queue->split_queue_lock, *flags);
>> +		memcg = parent_mem_cgroup(memcg);
>> +		goto retry;
>> +	}
>>   
>>   	return queue;
>>   }
>> @@ -4284,6 +4296,33 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>>   	return split;
>>   }
>>   
>> +void reparent_deferred_split_queue(struct mem_cgroup *memcg)
>> +{
>> +	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
>> +	struct deferred_split *ds_queue = &memcg->deferred_split_queue;
>> +	struct deferred_split *parent_ds_queue = &parent->deferred_split_queue;
>> +	int nid;
>> +
>> +	spin_lock_irq(&ds_queue->split_queue_lock);
>> +	spin_lock_nested(&parent_ds_queue->split_queue_lock, SINGLE_DEPTH_NESTING);
>> +
>> +	if (!ds_queue->split_queue_len)
>> +		goto unlock;
>> +
>> +	list_splice_tail_init(&ds_queue->split_queue, &parent_ds_queue->split_queue);
>> +	parent_ds_queue->split_queue_len += ds_queue->split_queue_len;
>> +	ds_queue->split_queue_len = 0;
>> +	/* Mark the ds_queue dead */
>> +	ds_queue->is_dying = true;
>> +
>> +	for_each_node(nid)
>> +		set_shrinker_bit(parent, nid, shrinker_id(deferred_split_shrinker));
> 
> Does this loop need to be under locks?

I think it is not necessary, but the loop overhead should not be high.

> 
>> +
>> +unlock:
>> +	spin_unlock(&parent_ds_queue->split_queue_lock);
>> +	spin_unlock_irq(&ds_queue->split_queue_lock);
>> +}
>> +
>>   #ifdef CONFIG_DEBUG_FS
>>   static void split_huge_pages_all(void)
>>   {
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index e090f29eb03bd..d03da72e7585d 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -3887,6 +3887,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
>>   	zswap_memcg_offline_cleanup(memcg);
>>   
>>   	memcg_offline_kmem(memcg);
>> +	reparent_deferred_split_queue(memcg);
>>   	reparent_shrinker_deferred(memcg);
> 
> I guess the naming can be a bit more consistent here :)

Do you mean to change them all to:

memcg_offline_xxx()

or

reparent_xxx() ?

Thanks,
Qi

> 
> Thanks!


