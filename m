Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B882CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 07:56:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 804708E0006; Mon, 22 Sep 2025 03:56:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DB908E0001; Mon, 22 Sep 2025 03:56:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F0FB8E0006; Mon, 22 Sep 2025 03:56:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5C5098E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 03:56:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC70F86B66
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 07:56:12 +0000 (UTC)
X-FDA: 83916128184.05.802CF66
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id 037DD8000C
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 07:56:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=E208M1RQ;
	spf=pass (imf30.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758527771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fOLEn6wbExiWX7ZHkvEGaEspEQHvpxYxacH64/69EaI=;
	b=34zqJM0LcIA2QiRjyytE36Sp8wgk/pOJZjV1Aik6KbDzJ8/eMpu8ZEdcNcyhYD/U4ziVE+
	MUcz9UE0Wgg87gQa2ZvTbcf3TjUxnbAvWfQaX16wn0pKfmiNAymJjDd4CP8xoITdvOwXz1
	4tU6y3pUUOOi9DIcNVqTVFhDzzk4bGk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758527771; a=rsa-sha256;
	cv=none;
	b=0EaaVx0+UQcC4ZMxh4T2s+37IU0s3rjgbzKQhJaCiisqV1ziRhHxiWjofXV8EQsLZciJKa
	GqctcQUBayIrjmY0IxXG9kk/MmPUT2fLkdbqCMP6bdPJ6rxDxhT1jmJ+UJKw8Mm5ucXDxm
	GGbFRM8Gt5YyunNrLNBRVUmulLBvPzA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=E208M1RQ;
	spf=pass (imf30.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-77ee6e252e5so2212048b3a.2
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 00:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758527770; x=1759132570; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fOLEn6wbExiWX7ZHkvEGaEspEQHvpxYxacH64/69EaI=;
        b=E208M1RQO7z8asgmXmh7SnfGIfwwgJf+b2lCk8JsCK+3qZc41yeaMELd3If4fELIdo
         ylDS6LI5/D0sdZPaYoTi6Hf7vCg7sPizESnABHGKEflkhGxUlrwwqgbjF8bcJrJmE5g7
         l1UpyQ2cLC68lSIOWU6Ys2JXWldNZdLwxUdDfLlHD4qV/sayldM/L55u2J89G2q+dp6s
         pe6NfGHWOtYwQEiidz4YYMUhHLM53fP3hGU1gcfGiroP59ntOavsOBjYFtURh2H1PU/O
         ueWUbhnHwg0e9gjpMYaYnvsdpRxddS3k0yKLhNgfVDCmUvjKLL2jzYexae5Byb5toJtY
         1rNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758527770; x=1759132570;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fOLEn6wbExiWX7ZHkvEGaEspEQHvpxYxacH64/69EaI=;
        b=aOs0wNIjMQGM1rHvzLPyLJyb40ovvlycP4BJ9sZk5ycFmBr/p5SebGZG7w2gZ3iUkT
         SimJRAiQ64F96ZBLS3iMa9s2LQJwiMdloGNDFKdOVTvx7IrISJofxgub8c6DVz4aqWIO
         dYdEdB6bq4Jxu/WosdNgy8FfNO+bDaB+c658NYAYve7nRB74qNkg8iCADqSeeil3lqCa
         eNwazhTcIoxtH23QLWZEXmdA1fhStuCxzAELaP/PT5I1vO4DJf87xZaH+qDj4elIHzLJ
         KaR4rY9zXk/clq3JZygz00h4aW5EW5MEQmq45G0LWgPTm7ObKTaYSbtlSYBCwtg8OKlQ
         MfxQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXtZ0J2iagLPA6vktdLdPB9OoVNsXEdYaKV2AK9eh3zLcrrHHbWjr2OfU3KnPuUUjb0h+GyvIZJA==@kvack.org
X-Gm-Message-State: AOJu0YyNRvoGBJUqk9z9t7oPoxEjoYlf73nLLgf9YcT4scdIdXCCUoxD
	wOF2GQYKEZy0qXjAx1Nc5JcD6U+a0qO/Hk3ZoS9hVeAUgY9BGDDDL56IvQ3NNkUljSE=
X-Gm-Gg: ASbGncuLs47j42jv4ztcSda8SVNU2OOr5jD2r/DJUphpfcSJCIHO80ep1qy2zobYG2B
	opS25LJ7pexElM7LS1Q+S8pT9QQc8xcCqP04zMHyE1ZH8O7wcXSfYbTKK2MEVpKn+2wRFFLPJed
	eUG7XCFG/W9Eqo6EhurlmaSP66dFgrg3qvI3SFkaVxJBlAIatguB7ur5ubAygpLmC3z2DGC8it/
	SwQk0jZJN3P1f0BuwAvJEmBX4M/t6oZingnGlnV6mDOj4hWk77diGJv0lyPPtpzY1MwtoeHlNkR
	cKA0TmMlBMO9gRv3VGLJ6gK41mJWpETeKaD7H6drA5U/GYbmv/uQcvRwC5hnN0JDSAcr8U6lDng
	Q/2WFZ3mf0LW1waq08U6G/1RxqRpXDcEiSnOiOcAYtAk0WxKVWwE=
X-Google-Smtp-Source: AGHT+IEWHzTu8qZR9GiLSVFONI5X3EclZtypFRTqQ5ScW2UO6ECeFRJ94ii2oT0N3yQZaQcdiH589Q==
X-Received: by 2002:a05:6a21:6d9d:b0:266:1f27:a01e with SMTP id adf61e73a8af0-2926f79d201mr16735986637.39.1758527769805;
        Mon, 22 Sep 2025 00:56:09 -0700 (PDT)
Received: from [100.82.90.25] ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77e5f867d30sm9103152b3a.38.2025.09.22.00.56.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 00:56:09 -0700 (PDT)
Message-ID: <28f36249-f064-4d32-9d8a-ba03db5b491c@bytedance.com>
Date: Mon, 22 Sep 2025 15:56:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm: thp: introduce folio_split_queue_lock and its
 variants
To: Zi Yan <ziy@nvidia.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@redhat.com, lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>
References: <cover.1758253018.git.zhengqi.arch@bytedance.com>
 <eb072e71cc39a0ea915347f39f2af29d2e82897f.1758253018.git.zhengqi.arch@bytedance.com>
 <E62A91B2-4221-43B2-9C17-1E48AA5D5544@nvidia.com>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <E62A91B2-4221-43B2-9C17-1E48AA5D5544@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 037DD8000C
X-Stat-Signature: wiisfyry9oeceoo5tuj7mga8qruygaqj
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758527770-664396
X-HE-Meta: U2FsdGVkX1/E/VcmkUv5z1NxvrdZKhhHV9panUwREehS7oSLM11oDtmF7Tdjtet27xjIwquC604zcsibT9gS8wB+fSsiE2V3dMgCXe/bSlgWk2ns81YtLfNQUAt3D1eglVodc+4cr+vn/w8KSRQfUpM5kLdIYIVMIDHdqVfhhS/jjFWB1xTYZTdrkVAMN+t2xVFJq1UusLut3FVKIswLc2xk0Q/U/ZfAnBiSE/Rd7wfzqboS7HUDg+43PW7CESkYhwl+AOwqzcjrkWwl3OPGDt7GxRxZZ5xtfUDvWY7g6D6Y/gsEPeBeFfCoH69ep7XREGi7W4qmPz9xCz0FfjeY7lEXiaRNhupewZ37gHEGOgojQVVKUkAww1geWR9XddqXa7Av6A11QcZ8rQo62xHT0h94E6JzIU9ic8abAiP9DVrDCx8TNZoYjEzfNfrZVTxF0DgNQ8EpUJXrowzXg7RhG/dTMJFPAqxVpxYx7ijweMGi7VzNSQ6K+q/X5hXLLOcFfp2kObIeyq3vUiCPq/Zfh9vrSXW9o9MnHavDb5Yfnnvb2rijGwhlTl+ZbpeflkHBdZtalQ9S8+AlZvRv1006ScL1pSGuf/wGykSJZg5Lgo2UbZk1Hu3f78ZqiszJ6vu9iHG+CUcgM9yCGdDh+osCbq84GpmUk4Bh8XAP8JFdkItdDenfQzxr4PTPWyIbTyvCcpVvK+ksJQdFQOSDUsSm5Em7Ydl9RFunDsf08sNKKE5B6sAVVI2xuYFVo0xDwdHIsXQi9opW2It/9fmfAIPj2rx5LdGZH+Zofm6/VlrnJHtOF00+HyYaCub6d8CvXfYLkRFYknPh/RxFIKANEXU7obfRlSND06fC/JYMRCcBI32HFA00AYeb3Id/o+lQBcelDMawoAmTAc9fwz1/UsITGiTR1O6sJ778OJDOk2wor1uElWi43rY87jGfIaEsA2VQkMrv1ouahzqW7p1RjH5
 Nf3NqXfv
 J05y7NqKlYb31Nr/5y8+5i9MBazlTHYRCELltM+azypws6r00dqt4/Ceo6LMDkRu5tk9/T/4TbnKkVaGAHDmZSEFApJIbFU7TgMfiOW4qTgVPpiNxk8SpF7zI3wr9wb0NhBgzsGZlwyf8nC611+SVHAsTaGWzTTyTvqwXueQ532x4fYJUcACbhuUI0yMjrNZ1YZWSqMhZfO5CNrdArtlcFsZeeMQ3F3IJ0V3McchrWdV/lEPLjmmbRS4PeFGBSlOpC2s/By3I9doVqY0Plc9RyfF/zVK1fVyGxDT8ueWNxhgRxdXRjzkudDNru+21NwMU6bw2h/zq7muNa1vlt+4Q7UnzGy4KFdR71TXStEVncJaNWnMihLZJ4IQukppkpU2z89/LvGmWWu6jHt0zBNWsBn6MheD3tTkcFQdctgoCkB5X9AjSQiUmynmYizDt4UbZvH0Ius9klV1ttYY7Jstpv5L1PYP2p/vVZwjEgtQsd+zHbMc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Zi,

On 9/19/25 11:39 PM, Zi Yan wrote:
> On 18 Sep 2025, at 23:46, Qi Zheng wrote:
> 
>> From: Muchun Song <songmuchun@bytedance.com>
>>
>> In future memcg removal, the binding between a folio and a memcg may
>> change, making the split lock within the memcg unstable when held.
>>
>> A new approach is required to reparent the split queue to its parent. This
>> patch starts introducing a unified way to acquire the split lock for
>> future work.
>>
>> It's a code-only refactoring with no functional changes.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   include/linux/memcontrol.h | 10 +++++
>>   mm/huge_memory.c           | 89 ++++++++++++++++++++++++++------------
>>   2 files changed, 71 insertions(+), 28 deletions(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index 16fe0306e50ea..99876af13c315 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -1662,6 +1662,11 @@ int alloc_shrinker_info(struct mem_cgroup *memcg);
>>   void free_shrinker_info(struct mem_cgroup *memcg);
>>   void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
>>   void reparent_shrinker_deferred(struct mem_cgroup *memcg);
>> +
>> +static inline int shrinker_id(struct shrinker *shrinker)
>> +{
>> +	return shrinker->id;
>> +}
>>   #else
>>   #define mem_cgroup_sockets_enabled 0
>>
>> @@ -1693,6 +1698,11 @@ static inline void set_shrinker_bit(struct mem_cgroup *memcg,
>>   				    int nid, int shrinker_id)
>>   {
>>   }
>> +
>> +static inline int shrinker_id(struct shrinker *shrinker)
>> +{
>> +	return -1;
>> +}
>>   #endif
>>
>>   #ifdef CONFIG_MEMCG
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 582628ddf3f33..d34516a22f5bb 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -1078,26 +1078,62 @@ pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma)
>>
>>   #ifdef CONFIG_MEMCG
>>   static inline
>> -struct deferred_split *get_deferred_split_queue(struct folio *folio)
>> +struct mem_cgroup *folio_split_queue_memcg(struct folio *folio,
>> +					   struct deferred_split *queue)
>>   {
>> -	struct mem_cgroup *memcg = folio_memcg(folio);
>> -	struct pglist_data *pgdat = NODE_DATA(folio_nid(folio));
>> -
>> -	if (memcg)
>> -		return &memcg->deferred_split_queue;
>> -	else
>> -		return &pgdat->deferred_split_queue;
>> +	if (mem_cgroup_disabled())
>> +		return NULL;
>> +	if (&NODE_DATA(folio_nid(folio))->deferred_split_queue == queue)
>> +		return NULL;
>> +	return container_of(queue, struct mem_cgroup, deferred_split_queue);
>>   }
>>   #else
>>   static inline
>> -struct deferred_split *get_deferred_split_queue(struct folio *folio)
>> +struct mem_cgroup *folio_split_queue_memcg(struct folio *folio,
>> +					   struct deferred_split *queue)
>>   {
>> -	struct pglist_data *pgdat = NODE_DATA(folio_nid(folio));
>> -
>> -	return &pgdat->deferred_split_queue;
>> +	return NULL;
>>   }
>>   #endif
>>
>> +static struct deferred_split *folio_split_queue_lock(struct folio *folio)
>> +{
>> +	struct mem_cgroup *memcg;
>> +	struct deferred_split *queue;
>> +
>> +	memcg = folio_memcg(folio);
>> +	queue = memcg ? &memcg->deferred_split_queue :
>> +			&NODE_DATA(folio_nid(folio))->deferred_split_queue;
>> +	spin_lock(&queue->split_queue_lock);
>> +
>> +	return queue;
>> +}
>> +
>> +static struct deferred_split *
>> +folio_split_queue_lock_irqsave(struct folio *folio, unsigned long *flags)
>> +{
>> +	struct mem_cgroup *memcg;
>> +	struct deferred_split *queue;
>> +
>> +	memcg = folio_memcg(folio);
>> +	queue = memcg ? &memcg->deferred_split_queue :
>> +			&NODE_DATA(folio_nid(folio))->deferred_split_queue;
>> +	spin_lock_irqsave(&queue->split_queue_lock, *flags);
>> +
>> +	return queue;
>> +}
> 
> A helper function to get queue from a folio would get rid of duplicated
> code in the two functions above. Hmm, that is the deleted
> get_deferred_split_queue(). So probably retain it.

After PATCH #4, we may retry after getting parent memcg in the above
functions. so we may not need to retrieve get_deferred_split_queue().

> 
> Otherwise, LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks!

> 
> Best Regards,
> Yan, Zi


