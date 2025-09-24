Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03296CAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 12:38:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 593148E000C; Wed, 24 Sep 2025 08:38:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 569E78E0001; Wed, 24 Sep 2025 08:38:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 458B98E000C; Wed, 24 Sep 2025 08:38:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D07D8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:38:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5181C041D
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:38:46 +0000 (UTC)
X-FDA: 83924097852.18.45354CA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 77A28180004
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:38:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZShnzjuv;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758717524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aPF6Jvl0Op5T7a596f1x716IHLymgMCe8uM8IFM2SCQ=;
	b=LGj4iTFYYL1/B8RO1MABdiE8hlgXP6uVJpAWWI24G4kTlZLb2Xkl0ZDLldlsldwbNXI0vU
	v34X/T4T/YFJVFBuRl7ZeiLMtZnvtFL6Mc+uSueDB8nqfhhn64FOpeE+jnQ36X+QHp4EST
	QqxgzKObXefR2C1M5JnfGqv/WQ0sA7w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758717524; a=rsa-sha256;
	cv=none;
	b=6YzgXrIf0zFf0ey6PRyftVvViZxSqdKLnzohAuvUiKwPz7iQRIO9ESgx6U0KmJ404wkh4a
	/xgx9YKA3usXVXewGKa7O65d+QrzQXzFERmFJPXfoPsNPOKUOKiJ43hgmQzHzm+4AMp5jM
	nyvGiKGMbATDhRcQlGDyXy1TeM2Y3Uc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZShnzjuv;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758717523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aPF6Jvl0Op5T7a596f1x716IHLymgMCe8uM8IFM2SCQ=;
	b=ZShnzjuvndEzIbuPFBQRHzZo7tqGw0XzVnZpMEt9n6U5iurYvtT7TSq2GEDztGb2AqM4YF
	LzbVftl0LTaQ2qzhDblD03eVxLfoljC08rniAdDLt3G/fJAWha7VzuvJvmrGB9pTma/GuU
	ZiHJQQBmIUT7rPobWc2mKhxdPef/yNI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-x_e3PMxxOyGX58SXD1BTVw-1; Wed, 24 Sep 2025 08:38:42 -0400
X-MC-Unique: x_e3PMxxOyGX58SXD1BTVw-1
X-Mimecast-MFC-AGG-ID: x_e3PMxxOyGX58SXD1BTVw_1758717520
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46b303f6c9cso29302015e9.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:38:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758717520; x=1759322320;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aPF6Jvl0Op5T7a596f1x716IHLymgMCe8uM8IFM2SCQ=;
        b=A7jySToB/mbkbxgxAguNGnVsFmGxCJq5GHesDTdEX45b5e1lY35tVfcZbod2Yh4Lvt
         5X4SB5gYXbt7605C9o5N+pVXqDSAKHBaS3JXhF45Po2iKPLfiU9/rSMQsA/hFuskD3gi
         svH4ATDHKdllHMh0hy4VsmdSxIyCtgYRpj0S77uaOnYABdURg/mkULF8NBR2ez8BzGM9
         gNRP0OhtBPE8CCfjr9pC9+fINkzoGFIl3Pkg01T3y6pfAcrdV2Ju0K6FEf1A24tZo+N1
         vp1o3nMgWjgtIN9RwN2uvUD8ydv0k0TrOxlsUnvRxByuCs9tpJyDc7YGatz/U40T5fJ2
         qzOw==
X-Gm-Message-State: AOJu0YzbWu3SnupB7Y9w/RVuqTFJs47dpTD91YMzShzpW/C0o1Dpt1mH
	4r8u5vuAc4LRX1pqk9eQc22pvfkKQIXdzspNxfR36sucuXdzW36XGCLhreOIptmCqGseYMbyvEq
	QuCX/DjMZTcXQwqFDa4uQqOgODHCMS8HOTG32MlzdotEEcltOJTtn
X-Gm-Gg: ASbGncsS+9bIxzb6DtNiNc0uEb/E3/GiHjIe7w9ZngM4U5AN6OBcdHVerF1OyPKplKa
	2zFqc5+eG9wmjFOx6ziMAZtR58AY7ou0sPCifTfOIrm9rgnIRY5fsxSct15KUjVzA3y+T9CQ2W+
	DWKMg6oLFk8FUE8pEg8VOIbz0NMIkvpu4Ps4TD5gGam1B+BIv1SlQxxPigy2qy7qkMRxZoQeFLe
	sMebuOxG4+YAQVD5lINK9Ey8i/OhvStkE3bfOZTZf6WQAT39B+B9OIRcUA0b3rg4gTtMH3PPFaq
	6dJ5ePesPh0r9SaTALHD6wXx3L8wbjc86xAMqWouvPXgvEe4mrvwWJWWm7vqZo6C/tN2AhmESxF
	9dj5+LJ/3XGLk4fZ83xreKJ4MiETMjkYU0DFjHjHIDPG3zSKTGKmSKEsF6iKIDCOQkQ==
X-Received: by 2002:a05:600c:1d02:b0:45d:d2d2:f081 with SMTP id 5b1f17b1804b1-46e1dab45bemr71219445e9.20.1758717520172;
        Wed, 24 Sep 2025 05:38:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHoOcDJrZXb/FAj2GHp5vwDQ3FVAghlcebAFZ1Ij8pdYpyP5A1mb01GFXI6T1WFSkm200TrjA==
X-Received: by 2002:a05:600c:1d02:b0:45d:d2d2:f081 with SMTP id 5b1f17b1804b1-46e1dab45bemr71219115e9.20.1758717519643;
        Wed, 24 Sep 2025 05:38:39 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e1ce10bacsm40101155e9.0.2025.09.24.05.38.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 05:38:39 -0700 (PDT)
Message-ID: <b041b58d-b0e4-4a01-a459-5449c232c437@redhat.com>
Date: Wed, 24 Sep 2025 14:38:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm: thp: reparent the split queue during memcg
 offline
To: Qi Zheng <zhengqi.arch@bytedance.com>, hannes@cmpxchg.org,
 hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, harry.yoo@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <cover.1758618527.git.zhengqi.arch@bytedance.com>
 <55370bda7b2df617033ac12116c1712144bb7591.1758618527.git.zhengqi.arch@bytedance.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <55370bda7b2df617033ac12116c1712144bb7591.1758618527.git.zhengqi.arch@bytedance.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VoCa7gcuBKpD-PpYmMjgs0JREUApcandJtfbWPlFsb8_1758717520
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 77A28180004
X-Stat-Signature: gmjmrn6dkumcih5i8fot4hdwg655mze4
X-Rspam-User: 
X-HE-Tag: 1758717524-853483
X-HE-Meta: U2FsdGVkX18kLKZIKhSnlEwhbRBrpB6vdoJ4oRK2sjG36DuIYn+ZNXMgo5+yIDoRHGnbZsvDj3wFmqW6gFLwY4Zb3baeO9S3jGDid7UDCl1NiWbjDm2/ZHXE85w9VsASvOT+EJnhM6xWMe8yu+o/4VxKXNhSFso8yG7C8UNSIg+h0GsT2NU7nFl6827M3SnH8u5SFhYIyRz36dIm+DKFYfzbhfaBriE8E/anjDaT4sbtvR1D6bzed5IQFzypT1xldVMOTMOifMvM5t+2zQonavo65bbqYclnTihaPa9v+QjICL0UVcgy7yQCngSY+xtnTiqrR3+QA4NiPv05V38Ewxb68WiNuBVbgRBbXIEphfwnr5v0CV1kEJh7dzakXnbisHCcv6ucqGumAWMdB3To3sBJ6oQ4K5KT62VJPtHEXXJCR1E5x4SGHgsgbdkhje6nLlCp2wxTBFAsrXgd3qYy5w7YgKpSgQ2OJGTeK8jwsvdJ3fV2lgpTcreHKoQ0ni/n8Mo7cR9KJcwlq6efvxCft2dmNLoV7DSwvisabS050VN194BZStjuREm71uyKoy8oLgxZQKR1V9OPFyFN3MqLV1pOkSMjD2hPb4PECkkYUPfJG8Eau9J5W4rHABcUq61uWu/Boumml+thU3Uy8DQ0pFXGfPrVmo2eWUTf//Z9Px2P0YBCjf3cg6VZms41qocwS6xhMEbv1/0WiSgbnip3Jz9y1Qkz7FoEgRR5GLtByHFSNzfhSMOLibRGaJVuPyKZin+5+7OiNt+OcFacUMsh7P9V44ehILFotPa/2+sGPVrXM0olv4lZ8zXD+ZS2d1cP/218SuU261U2In8z82ZtRofQs2yMMhEz5nhpzCfUJKWvQWwqXfjGirDEkPptpk2J9UuL3BsFpBriaFJp8mhCqOhubdFeAFlPRm1Kwi5SU+SChLTUE1AR81kSiwbxMHdmQeQVuxsSTJUjZaFkKuR
 ea0KI83s
 ieyAQvWAiSI6tFRpa9ezAuOBPoXYUlQU2/uXmXHbPYhqdJyz5KHhFZR7af2NCYeyTCWEoM56DYbAYShiBvcpu4fjqnw4lXd53tRy/xjjSVb9Ss/DgWeo/UBgdBLX5PGwy5vqQ5M4yOW4J4mByOCaMl2mtlPBW/5fb3Y9FsRgNvq9/DsV39CrNwC7ctrPuYRmncs3aXFw2mYyANz/hOYjSvYtgvfOMgBxq6fdl/eLcW13+IiuwqlJgi88hfIq2pAHonkCFhopUqFWUxXZzQhwsc5gGcpBT45urEVUYaM6ndlcgZ3ybXrD4g/1yny0gr4t73K/+4J1qNTZXjoQXLjs+rs+/xV4Un3pw2vnBpDy5DOwdUWGLT7g67JY88ZsuBGwLoq4pTl1HctzEgo2/pns5IKq/4ViyPxqI54EBGo0lyTuiobMAMs5lyUYXwew9F/hOf3Y6vSZcMYgyrUML/SaE5Ar/0rzDSzwdeimp3bRI/PBghw+aw9qKU/TPnyPLO+aJ8nmDfj1I0o3D0HNc1/u/qjTqs6Vl8xjtme7aCowrzRXtQUYxKT92QmbyNHS90587R3Q/x32/H/QGgRk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.09.25 11:16, Qi Zheng wrote:
> In the future, we will reparent LRU folios during memcg offline to
> eliminate dying memory cgroups, which requires reparenting the split queue
> to its parent.
> 
> Similar to list_lru, the split queue is relatively independent and does
> not need to be reparented along with objcg and LRU folios (holding
> objcg lock and lru lock). So let's apply the same mechanism as list_lru
> to reparent the split queue separately when memcg is offine.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>   include/linux/huge_mm.h |  2 ++
>   include/linux/mmzone.h  |  1 +
>   mm/huge_memory.c        | 39 +++++++++++++++++++++++++++++++++++++++
>   mm/memcontrol.c         |  1 +
>   mm/mm_init.c            |  1 +
>   5 files changed, 44 insertions(+)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index f327d62fc9852..a0d4b751974d2 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -417,6 +417,7 @@ static inline int split_huge_page(struct page *page)
>   	return split_huge_page_to_list_to_order(page, NULL, ret);
>   }
>   void deferred_split_folio(struct folio *folio, bool partially_mapped);
> +void reparent_deferred_split_queue(struct mem_cgroup *memcg);
>   
>   void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
>   		unsigned long address, bool freeze);
> @@ -611,6 +612,7 @@ static inline int try_folio_split(struct folio *folio, struct page *page,
>   }
>   
>   static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
> +static inline void reparent_deferred_split_queue(struct mem_cgroup *memcg) {}
>   #define split_huge_pmd(__vma, __pmd, __address)	\
>   	do { } while (0)
>   
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 7fb7331c57250..f3eb81fee056a 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1346,6 +1346,7 @@ struct deferred_split {
>   	spinlock_t split_queue_lock;
>   	struct list_head split_queue;
>   	unsigned long split_queue_len;
> +	bool is_dying;

It's a bit weird to query whether the "struct deferred_split" is dying. 
Shouldn't this be a memcg property? (and in particular, not exist for 
the pglist_data part where it might not make sense at all?).

>   };
>   #endif
>   
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 48b51e6230a67..de7806f759cba 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1094,9 +1094,15 @@ static struct deferred_split *folio_split_queue_lock(struct folio *folio)
>   	struct deferred_split *queue;
>   
>   	memcg = folio_memcg(folio);
> +retry:
>   	queue = memcg ? &memcg->deferred_split_queue :
>   			&NODE_DATA(folio_nid(folio))->deferred_split_queue;
>   	spin_lock(&queue->split_queue_lock);
> +	if (unlikely(queue->is_dying == true)) {

if (unlikely(queue->is_dying))

> +		spin_unlock(&queue->split_queue_lock);
> +		memcg = parent_mem_cgroup(memcg);
> +		goto retry;
> +	}
>   
>   	return queue;
>   }
> @@ -1108,9 +1114,15 @@ folio_split_queue_lock_irqsave(struct folio *folio, unsigned long *flags)
>   	struct deferred_split *queue;
>   
>   	memcg = folio_memcg(folio);
> +retry:
>   	queue = memcg ? &memcg->deferred_split_queue :
>   			&NODE_DATA(folio_nid(folio))->deferred_split_queue;
>   	spin_lock_irqsave(&queue->split_queue_lock, *flags);
> +	if (unlikely(queue->is_dying == true)) {

if (unlikely(queue->is_dying))

> +		spin_unlock_irqrestore(&queue->split_queue_lock, *flags);
> +		memcg = parent_mem_cgroup(memcg);
> +		goto retry;
> +	}
>   
>   	return queue;
>   }

Nothing else jumped at me, but I am not a memcg expert :)

-- 
Cheers

David / dhildenb


