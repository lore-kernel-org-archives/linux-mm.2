Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41CD6CAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 09:58:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F89F8E000C; Wed, 24 Sep 2025 05:58:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A8F78E0001; Wed, 24 Sep 2025 05:58:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 897DB8E000C; Wed, 24 Sep 2025 05:58:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 755F18E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:58:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3216711AD15
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:58:52 +0000 (UTC)
X-FDA: 83923694904.17.3C8D3EB
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id 50CD41C0008
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:58:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=AN5CMiLW;
	spf=pass (imf21.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758707930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avFLT9/zrgVxo7hnCTRMxJbrYoXVl3Ka4VB6cXLWScg=;
	b=ulkxHXJ2N5ViViOHg9/m0642UafcamFKyyDAO7bLVH1TB6NCO0XgDKzAwSTFX7kmt5DxJ2
	HfgcgwO9K5O5Te41zAjmmcRU08JTjl2s31VK+Lvhd1i+zhHwHnVhQzezJ6ic1XJJRq8a9u
	FcI878UQ87a1PF/mlgnnfKFJ/fL9Y7c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758707930; a=rsa-sha256;
	cv=none;
	b=CiwHkzaxHd8BxR2x0vNJ0USN33aGoa5bmyGB+xo7t9wDm0qZFyUQtxNVL/x1FQjjprxH3u
	PfGxP12DscpftkGY4O4R/w+Obsa8dq1EUHYIdVoAF9TcNtByJxZ5G6L3bcjvrm9Ovng/lW
	X31plF46HSyX/6HX+05HydoYlGlAv58=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=AN5CMiLW;
	spf=pass (imf21.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b554bb615dcso2239854a12.1
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 02:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758707929; x=1759312729; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=avFLT9/zrgVxo7hnCTRMxJbrYoXVl3Ka4VB6cXLWScg=;
        b=AN5CMiLWTy1+qRlusbprs23xjD8cPXsj/V1xqSSobI4IvCP3W/Fo3zpGhqOQpCMr3h
         ZvSgytrE1JaZwh4+3byWhM2WlTe+y28XsxupN9BxPfI/eBKTXk6saQnExDIPozehwWmy
         Csc3de/fmWpMo8HgaagbyldC1pu4j3HUI4VisOIc0dYFjmYH07V+hCPzezRAbd3pBlx1
         f18LevFM276oIWQChkAt4S7zu4h8F8NX21CsAftYNHV0gekJ/wzBOlJltuZAARfUHUWP
         BV/9t4zYUngsJrhCVjSOMYa9QlbzIDI9+QGipp2oyoCTPktdUwogTlWbpyfiDiZ43aNn
         0ISA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758707929; x=1759312729;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=avFLT9/zrgVxo7hnCTRMxJbrYoXVl3Ka4VB6cXLWScg=;
        b=wsOsikQeP5oOIYF4wizJqAwrM5AtlPxUwqF9fEcBk8Cb4pNue9BWjknp6RmKicaaEr
         ohcyh2bpc5rPVrab2dihn09VZYrhexT36jcum9aIGVbcQwYJ2NDdecKAfH2pSaCsEEkr
         m0VNqcbPTUtIRKWsuup6PpbyofG6UU870xRVhdTK298b0+vc/LeHX/qAUQogtb64oZAG
         ORC+40UCMIBhw8GdIxMB29R9OFRPVgguC5/rKom7K/OfQ4DvEy6FJzCm1a/ddeTWxHVA
         kipq5XQZwG4BuvHPfzCZ2z065P4G7O5E0Mecd5pfKOfRCkodz4Np9iEmQYpoXPWK2KCo
         Rmfw==
X-Forwarded-Encrypted: i=1; AJvYcCVnOoIOCzvW2xVNfruwoOVul2END7w5i0KHy2zFdNxzEHl5p4JhLe5fKt9qbDrKSu5TLKotd72THQ==@kvack.org
X-Gm-Message-State: AOJu0YyA9NgBW2rqC6DKBGA6sB1tIKPjkR+0Q/BxhxyNQ/Op2Gs2oG6x
	MxBH09FwRK1NtBYaAWzYj1m/9Ni0QAxeq8GFpx6WvnJCJyHX71Y+LTv60EkQJ/xZzbo=
X-Gm-Gg: ASbGnctXoPytvNKkyuPvRwls/kB7V3n6TieP1eK396z1o5clL4XMUsfcIt6rkmD0a8d
	b14e2LISAzcUi75T30ATrlUJ9MJku5KO+gQfuU9SGxBZYIt0MpBJNP0iaiHn0FsHcehWBdNBPY4
	bgJm71u1MGtbFo8Yi8d4YaZiPkm2zQqQIYkYpUZFU0H6IevSOEooc2UrLGSEmZddthkAj6T15D6
	OLvdXptkP36Ujivt2wypa3umx6ut0KhuJReqBGN4tzkHsgwA64bYwnrzXwuin+ajG9yW9LS4UWW
	q4zQtB3bas/ottW7+ezvtbiUgO/XQh3bO0Egs9pJlgFyXDhx3Tr8q6JQXExm9ADezoEt7MWyEae
	9hMV+VaMljIXa1gbuYJcuRoQhtSjFsWx0+1x0LSsc2t8oxw6CqhyYVBGg0Q==
X-Google-Smtp-Source: AGHT+IEUbjYRQ/MBtudU8ME5ZjlRil0hIRiHs6tLk5o3IUdn5h9aQrZs1iIENTC2rBUyUMBREV5BCA==
X-Received: by 2002:a17:903:8c6:b0:269:b2e5:ee48 with SMTP id d9443c01a7336-27cc7404c14mr74664935ad.52.1758707929142;
        Wed, 24 Sep 2025 02:58:49 -0700 (PDT)
Received: from [100.82.90.25] ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269802fe096sm186571915ad.104.2025.09.24.02.58.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 02:58:48 -0700 (PDT)
Message-ID: <ed226e93-8d3c-400d-9129-ae8fee755dca@bytedance.com>
Date: Wed, 24 Sep 2025 17:58:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm: thp: reparent the split queue during memcg
 offline
To: Zi Yan <ziy@nvidia.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@redhat.com, lorenzo.stoakes@oracle.com, harry.yoo@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <cover.1758618527.git.zhengqi.arch@bytedance.com>
 <55370bda7b2df617033ac12116c1712144bb7591.1758618527.git.zhengqi.arch@bytedance.com>
 <303D9A50-FC6D-4710-8405-2283A05CD41D@nvidia.com>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <303D9A50-FC6D-4710-8405-2283A05CD41D@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 50CD41C0008
X-Stat-Signature: itzcce6b1wse1h4oidwmqkkw8nxzj55r
X-Rspam-User: 
X-HE-Tag: 1758707930-399114
X-HE-Meta: U2FsdGVkX1//HMlrs0eBX9S6E5+EEVJWQGxV6klIgKL5ov7f/YeepwK9SIbmi6CXSaK8+ELiolCwugD9YC1t1WXaqa8z1Jr4HkUe2ulrMyOyM3iLl3j2+y9xkGMp8F5dX+IT3jJ9+ectdqlV+BNobCzRiSJ/Xd+LPbyeNMq1GOO9oDMJvNLSp6R+G2A+uD//dVOPLdTeNeQyl27en+sa/i/HC8t32kJdQMncRNwx2YfrrwYZEQsLy1GfQmkmdzyl02N7vU1qmMZ3EH+PYWL5o+mZ3o3vJ1V+lrNeXBn+XhW6uRaP0okwsi9vLGC92FoTfrUDiISsgEMg3rRDXmx9aE6a0RLRWJEmj1vEbdFv+9jy/lxbJjW5VhOXHXofkywFXLJr9uqp23AjEaDony4QAnweIaKjl2W0lg9d+z5+UPLri3/SN8FpyG+YFRWnOtJyL+pUGSY9bVYaRsREVpnkh3py28G5C8WYqdWy8gYM9W0zF2wP764SEKfJ2BBMF/jnn/gnx726sKbf4ndwgXVykGOyJ35KCutupkeHqXTrPSo+Q7Wn/PWa5lG30exdqQ25XcmTqHnPdzCcrQzOYMSaNkBgFd2LKkrP/MCsX5hFk+N3sdxnI0GuGqw15B4dJVk6q+9Z6wwXlSBZmwe0QIjM7f5OFZAciug76Dws9xvFBR94UDXiaI5lZ5gC7hl4oaWXwiuX3OqoKUIcE8AFmEl0rA/3chIRyM8l4Xpw7npy5kB4fA5qD0NSeYTbqdUW5rsZltE/F+DWQJTHbacQchsUg9Go5LhGMVUMZEzGJSaXasbSRZI79tIVlbCcs5WinVQA24WRR9+ynM+0zlFWHFQWxojCHIFBs1VHuKDWvbi49ZYQABwGIqE+QbfRb5CYU73Gt5lA6W84Wf6kA8QqJPeG16j9SEszqxIUR9ydVrIl9kFDMu5Uh5qAMWHXJYYEotTFtkykv1TcUSut9cPtA3S
 NI7aZa3/
 LELVI45kvWppjtdI9iAXJEEN/mzWKltuf3nZKIxrlzfnBInOSheSuKlEvknBNsmfm3GO1xBI79P3VcW7NYmKL3nAIwR4/LkDYhgEttS74m7MmTnTOHXqxjMA5JJTNVxzPdTtueX9mKxXf97jl8RQupUg9E6fFfdUzLrdMDscEMbknT350rMF3QHzte3Z08v+oRKRP3wrULpWNtgrRA5/Ip8vPVyzHNgZLoz8RVyzeLh3wphll+QSoU45Z49WbWNVJ3fo7zww5zpVXYOIpOJgV0th+7UyMcGftWkMNkEmsYoV/VMWkFTyPPAYtoYkHCxjedCEk9Iz+p9FZt+jWjFX0POT1tUUON2/ykycQVz8noBwuuYUMiCiSzUwPDzFBeGAKLx4Eou/sOFvMFOg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/23/25 11:44 PM, Zi Yan wrote:
> On 23 Sep 2025, at 5:16, Qi Zheng wrote:
> 
>> In the future, we will reparent LRU folios during memcg offline to
>> eliminate dying memory cgroups, which requires reparenting the split queue
>> to its parent.
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
> 
> Should ds_queue still be marked as dying even if it is empty?
> Otherwise, new folios still can be added to it, based on my
> understanding of the changes to folio_split_queue_lock*().

I think you are right, will do in the next version.

Thanks,
Qi

> 
>> +
>> +	list_splice_tail_init(&ds_queue->split_queue, &parent_ds_queue->split_queue);
>> +	parent_ds_queue->split_queue_len += ds_queue->split_queue_len;
>> +	ds_queue->split_queue_len = 0;
>> +	/* Mark the ds_queue dead */
>> +	ds_queue->is_dying = true;
>> +
>> +	for_each_node(nid)
>> +		set_shrinker_bit(parent, nid, shrinker_id(deferred_split_shrinker));
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
>>   	wb_memcg_offline(memcg);
>>   	lru_gen_offline_memcg(memcg);
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index 3db2dea7db4c5..cbda5c2ee3241 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -1387,6 +1387,7 @@ static void pgdat_init_split_queue(struct pglist_data *pgdat)
>>   	spin_lock_init(&ds_queue->split_queue_lock);
>>   	INIT_LIST_HEAD(&ds_queue->split_queue);
>>   	ds_queue->split_queue_len = 0;
>> +	ds_queue->is_dying = false;
>>   }
>>   #else
>>   static void pgdat_init_split_queue(struct pglist_data *pgdat) {}
>> -- 
>> 2.20.1
> 
> 
> Best Regards,
> Yan, Zi


