Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2111CCAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 06:12:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 661F38E0006; Thu, 25 Sep 2025 02:12:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 611948E0001; Thu, 25 Sep 2025 02:12:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 500638E0006; Thu, 25 Sep 2025 02:12:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3799A8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 02:12:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E1F94B8788
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 06:12:07 +0000 (UTC)
X-FDA: 83926752294.20.9A9717F
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf25.hostedemail.com (Postfix) with ESMTP id 33591A000A
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 06:12:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="f+bF60/a";
	spf=pass (imf25.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758780726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qBnESjrn7YE3VD1R8wLTisr50tXYLyvlq0Q7unAi83o=;
	b=v2p+V2RcfLr8YCpyW92+4JBZKXwD+L7tB0hg1O4evoYjywZNd9pLzDVsC+/6O270lilLgp
	WF/XlmV4g93YwoZNngRFd75h3sFYyogucbhJ0Y445N3x86LTHStCLmYPydDQZIDzxzDgxA
	KiXMdOJ1tBGX5OQ+XWWw5ZY3W+R5114=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758780726; a=rsa-sha256;
	cv=none;
	b=uTOq6vk0Bve5NU3NRgGQq57QJlPyRguiuyA8KiVyu8aEYx7DCGUSa8ujKlrethCBLsXzpO
	A5yP5ZIXchhbR7iW5F/d8i4IVYt3QJl96g1XuJ5AUj5nhbuh2/tZ2dvnvP8TTxjK4VdBS4
	915p8UwA9YXFM+SXWbxQHcdWu+5nh+E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="f+bF60/a";
	spf=pass (imf25.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b49c1c130c9so446142a12.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 23:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758780723; x=1759385523; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qBnESjrn7YE3VD1R8wLTisr50tXYLyvlq0Q7unAi83o=;
        b=f+bF60/aHVNe5g556K7QdOqv6B4lejOQ61rwzENzC8WPeEj98CVr1CcbbQ3086w5O0
         VkqGLo3mSmxLI1OqSxvdCKa0ANHwTde91nipdQ15R/mq44GNUAKpDaMlUhQ5L2KdajOb
         M71mEpnr5U7ZTv6Bo8O3wCZ1nYw+w8yF9tQKdqR0lCuHQYQx5BzH+OFiX+x93Jvyr3I0
         FBQlTl5R3HkL+8FFvjIaXYduy+lTmeymYbsQ2HoLKYTvYeK5ZTLpEGgMNtpKPegMCJsM
         yOflrn6D7pqy8JoxaSfGnjiKl9EJi1fPnbdZy78ZUoAnyWI8D4aLm4ze85Ryf0DI0GDv
         l3HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758780723; x=1759385523;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qBnESjrn7YE3VD1R8wLTisr50tXYLyvlq0Q7unAi83o=;
        b=HdR5DdfNRTFgIeXcqdtXWrFKDY2JSbTbeilZuYb1aK2QyCHFi/Dh/LmJ/BbP4FlavF
         2HTSrC64GpMrRI+TAOrSfe8NyTCtMxbMfSbW0zllpF7SjtCh61pBoYE0eqYiyYp0Gdmz
         +ujTQaMkjlyR7fUSXVB4q7gt4+uuHIg07c82p6WvLdh2eT8rnM1KCeilEYbEg9uBiSh3
         Xb+kNCQVIDgzY6NXQucW2ijxGqP4H0pwnQMgz3BZmvlUR7yQfHHcel4FB9VoTIBrXhVe
         xEPHMonv83m1776z6EOzcJmeB79jjhbSt5kLCVFOYuxVQ1X/wBU3vijIV25pohqeULwl
         lAaQ==
X-Gm-Message-State: AOJu0Yz3Lgm6mjGG1jAgsI0n2nCp5kUVijygXeDCIWuQ8HY0QbvVE+AW
	u9MENhl5JDGOWQBYQzCi3T/NfiCBuURurB69H4unJnLbpd4bFZcVFejf70RI4dKYThM=
X-Gm-Gg: ASbGncvyjW8fFIX+jVezR5gS6HovtE3ts8mo7g1Es9Va0DdZErWGE/cItv9EI3XDIhv
	LjHDl1/frkdOglxdak3KQPjvIQfCzxw/aDwKEkuQ0/oFQEunfWZ//PZt2ocT46JVkrxMdmJIRmm
	SzQdIf85WJvdL05++Gj5oj7qQZT8zIHyjh9+8zfRsmOm5NopcVboHCgy2mfndlzQ/ULaeROKlNL
	lfSWzmYCLFtru7Rc967yERZXRrNmWSF+OLnT8hv/1aJzctZ8gWRU+3CBwjrw7hGvpqBg0kpbnUI
	IjKWp4tCFzRcYymvEHvYbL/cR1AWzZc9R4H3dD0dpz7CiT6G0fYlcyd0fCceY/xup/xRr1jj/pk
	opWS1cgFmGBHGG7j5TZJRmzmbBfdVf/mwTk+zwGb1v1XH/l1cu87P1t/p7rZnFDDEwezO
X-Google-Smtp-Source: AGHT+IFX3HNUWNSQugBFP4TDu56vU0SUrsp6NGoojXzrA0bsnO/JcgP+qt+1DH5//CMoXoVaCTunhQ==
X-Received: by 2002:a17:902:f602:b0:275:b1cf:6dd9 with SMTP id d9443c01a7336-27ed4a608c8mr25539195ad.52.1758780722685;
        Wed, 24 Sep 2025 23:12:02 -0700 (PDT)
Received: from [100.82.90.25] ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66d2ffdsm12803605ad.18.2025.09.24.23.11.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 23:12:02 -0700 (PDT)
Message-ID: <46da5d33-20d5-4b32-bca5-466474424178@bytedance.com>
Date: Thu, 25 Sep 2025 14:11:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm: thp: reparent the split queue during memcg
 offline
To: David Hildenbrand <david@redhat.com>, hannes@cmpxchg.org,
 hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, harry.yoo@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <cover.1758618527.git.zhengqi.arch@bytedance.com>
 <55370bda7b2df617033ac12116c1712144bb7591.1758618527.git.zhengqi.arch@bytedance.com>
 <b041b58d-b0e4-4a01-a459-5449c232c437@redhat.com>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <b041b58d-b0e4-4a01-a459-5449c232c437@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: px6uzdoizu89rgx4w8y19j73o66w9ya7
X-Rspamd-Queue-Id: 33591A000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758780723-400417
X-HE-Meta: U2FsdGVkX1/dutBSVTFQsxuheimKMd1hwga7fsub+BiKIC51q+RvMk0jS8KKO+vmUJoX9apUn48dGYSo5lz2QPYBIL4FOHbh4pt0QiwNYIORTFJuYTUk4W6vXkRqOvfEagQbrLG0BUKgQobVE7Bzg9q298mqUc5BJtjw5VqadBiwRZSQj8wbTkTOhieDI2X5kl6ICgZ68ev/lqlv2la1dUJIp/EDrAlmuOQ8rjiCve1BIK+UFlUYskSbIpEePoFlzzoxwtUVEUUs9IqYN08MANENDj1oXgnIhwQwcA3Nnqv4OziQE3weGm8XNsAnqqO0M89u4uDmrK0ufs04lPBrMs5qeG/kac7mXm4Q1LR0+RRXyd+kKyIyjV2mTaudSfkXWu5SoZfmZVfIeOQIFZmhZDazN6tXKUz3ZxfPDIeCAre9hs+K8fncOfj4VprgUJfeFlcP3EDq2grVAgVbPzRLx4X0efXTKgvvNxn5rxy6rtBFqu+5aVfmBleNbTCNj6om17JWQY84lQKqGRmG7jnHUJ13NgcQ5HOnwClCCh/pxAkGaZ5cLTwomxJBf3h5eikHlc4gXtCWeYH2VuUDuscfzAC3soP/TpVygjeolTsqKO8CDsslIKzJr6IJ9+o+7XgGfh11IkCrLKl8qtyCnTlD//injZJlPQ4PLDN3t8achhxFT/oZUJi1gA72K7B5748GDA6uTh0VDkwK29HWNW5O/qiNsR8sgMsShkyRLc5lLZ7aBDJzg33IDnQ/HY6+d0j55yrytrahXX3SApx3j71kT6CC4Zo2QwRFwSTOGnGuN6wbLOpRj2EOo1knAmUOL9XnbN7CiPylNrMoVXoaJ8MfFn5UVz10Hx15LDUljeCWTLPw8i6JgGwrVXzOXdI40/y/B+1laoPz1jv/eIFF0lhAmdz4++w+gD8vn+CAEH19/PKK6hd8lnc266PNvgGVLwtgHq3MjuhUP6QQmBDsTnn
 43pfiJgQ
 YG6dOPigXkaFkroDtbRa4/hKVbEcWJv1pSiBut5QGf3f2xpacbpBObi28lieA8BZ9/R3H9ksbCRWgYVZlUSeD/TkgKXyfmdzIC97MIAKm3NYt7vC6wvVNf7mrwgXGZrTz9Jr6ZQVUIDF7Bp4pB2eDYtxucEnTaPKJHvUCGLi4tLQp0SYCUYyJtVYhCX9WU0xifnbEoYRiLaesmKgrxzCzAWl95XNq4+XVy+pVobvDU/qhBLfWj3xWToet0Sr6sjrNRkqDMJt6GIv4va3PDVe2BQMUsfOs30bZKccWw1eTSgo7McOCmxHG2GC+EsGCBJuPxpLwE1Y3f6eYey1pB8AbrObp5bQYONsfof8Fbb3sPmG0IbnwLviUg7cQ7CmHSOlew+DQ+jT3m1o6kR8Nw1KagQUCs737oMPDM0ok
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On 9/24/25 8:38 PM, David Hildenbrand wrote:
> On 23.09.25 11:16, Qi Zheng wrote:
>> In the future, we will reparent LRU folios during memcg offline to
>> eliminate dying memory cgroups, which requires reparenting the split 
>> queue
>> to its parent.
>>
>> Similar to list_lru, the split queue is relatively independent and does
>> not need to be reparented along with objcg and LRU folios (holding
>> objcg lock and lru lock). So let's apply the same mechanism as list_lru
>> to reparent the split queue separately when memcg is offine.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   include/linux/huge_mm.h |  2 ++
>>   include/linux/mmzone.h  |  1 +
>>   mm/huge_memory.c        | 39 +++++++++++++++++++++++++++++++++++++++
>>   mm/memcontrol.c         |  1 +
>>   mm/mm_init.c            |  1 +
>>   5 files changed, 44 insertions(+)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index f327d62fc9852..a0d4b751974d2 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -417,6 +417,7 @@ static inline int split_huge_page(struct page *page)
>>       return split_huge_page_to_list_to_order(page, NULL, ret);
>>   }
>>   void deferred_split_folio(struct folio *folio, bool partially_mapped);
>> +void reparent_deferred_split_queue(struct mem_cgroup *memcg);
>>   void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
>>           unsigned long address, bool freeze);
>> @@ -611,6 +612,7 @@ static inline int try_folio_split(struct folio 
>> *folio, struct page *page,
>>   }
>>   static inline void deferred_split_folio(struct folio *folio, bool 
>> partially_mapped) {}
>> +static inline void reparent_deferred_split_queue(struct mem_cgroup 
>> *memcg) {}
>>   #define split_huge_pmd(__vma, __pmd, __address)    \
>>       do { } while (0)
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index 7fb7331c57250..f3eb81fee056a 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -1346,6 +1346,7 @@ struct deferred_split {
>>       spinlock_t split_queue_lock;
>>       struct list_head split_queue;
>>       unsigned long split_queue_len;
>> +    bool is_dying;
> 
> It's a bit weird to query whether the "struct deferred_split" is dying. 
> Shouldn't this be a memcg property? (and in particular, not exist for 

There is indeed a CSS_DYING flag. But we must modify 'is_dying' under
the protection of the split_queue_lock, otherwise the folio may be added
back to the deferred_split of child memcg.

> the pglist_data part where it might not make sense at all?).

Maybe:

#ifdef CONFIG_MEMCG
     bool is_dying;
#endif

> 
>>   };
>>   #endif
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 48b51e6230a67..de7806f759cba 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -1094,9 +1094,15 @@ static struct deferred_split 
>> *folio_split_queue_lock(struct folio *folio)
>>       struct deferred_split *queue;
>>       memcg = folio_memcg(folio);
>> +retry:
>>       queue = memcg ? &memcg->deferred_split_queue :
>>               &NODE_DATA(folio_nid(folio))->deferred_split_queue;
>>       spin_lock(&queue->split_queue_lock);
>> +    if (unlikely(queue->is_dying == true)) {
> 
> if (unlikely(queue->is_dying))

Will do.

> 
>> +        spin_unlock(&queue->split_queue_lock);
>> +        memcg = parent_mem_cgroup(memcg);
>> +        goto retry;
>> +    }
>>       return queue;
>>   }
>> @@ -1108,9 +1114,15 @@ folio_split_queue_lock_irqsave(struct folio 
>> *folio, unsigned long *flags)
>>       struct deferred_split *queue;
>>       memcg = folio_memcg(folio);
>> +retry:
>>       queue = memcg ? &memcg->deferred_split_queue :
>>               &NODE_DATA(folio_nid(folio))->deferred_split_queue;
>>       spin_lock_irqsave(&queue->split_queue_lock, *flags);
>> +    if (unlikely(queue->is_dying == true)) {
> 
> if (unlikely(queue->is_dying))

Will do.

> 
>> +        spin_unlock_irqrestore(&queue->split_queue_lock, *flags);
>> +        memcg = parent_mem_cgroup(memcg);
>> +        goto retry;
>> +    }
>>       return queue;
>>   }
> 
> Nothing else jumped at me, but I am not a memcg expert :)

Thanks,
Qi

> 


