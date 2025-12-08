Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87B67D1CDC6
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 03:10:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF8FC6B0005; Sun,  7 Dec 2025 22:10:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A82BE6B0007; Sun,  7 Dec 2025 22:10:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94A7B6B0008; Sun,  7 Dec 2025 22:10:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7C7F86B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 22:10:52 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 011638A95F
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 03:10:51 +0000 (UTC)
X-FDA: 84194826744.10.52D9A75
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4F49F16000D
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 03:10:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765163450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kcrCgxmPA9ydNcR0UP4DPsgIwRElqIZMhNqoe3E5Hoc=;
	b=C0gqzk1pIGYdJZAGhTMmZyD9U3GIzfvMJ/2t7X9p2omWOL9PYoNh77S2bfaqKruKt+eKtS
	Lpdt9kLS24oTYIrvqROfh3xHYflqeJzv4P5o85/SlRbyG+VUT+7TDkYo/fv152IpjZ4VwL
	0Qo8OPydvIY3N9SgxUNw0tEWD12c1Vg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765163450; a=rsa-sha256;
	cv=none;
	b=2hN6r7hcuFtHWZIwZTPkmuN6w6FPwR37PFU1O9agiFii8od+hM6IEjy+dfDcYekqjyh7Q2
	/uM+2DSZfYeoAzZBnLYPNwBTEbWouqZXkd+HVgWGRGrs7aESt7vyaWNyJJNBtacehk8S3y
	ieF8F60jbQ7qZEZt7+JXBE2qSyKM7hY=
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dPn6Y5dK1zYQtfp
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 11:10:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D8B8D1A0B64
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 11:10:40 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgA3YZ6tQTZpBrb2Aw--.58034S2;
	Mon, 08 Dec 2025 11:10:38 +0800 (CST)
Message-ID: <c0c69863-52f8-44ed-8d85-97531caf4dea@huaweicloud.com>
Date: Mon, 8 Dec 2025 11:10:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH -next 1/2] mm/mglru: use mem_cgroup_iter for global
 reclaim
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, corbet@lwn.net, hannes@cmpxchg.org,
 roman.gushchin@linux.dev, muchun.song@linux.dev, yuzhao@google.com,
 zhengqi.arch@bytedance.com, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, lujialin4@huawei.com,
 chenridong@huawei.com
References: <20251204123124.1822965-1-chenridong@huaweicloud.com>
 <20251204123124.1822965-2-chenridong@huaweicloud.com>
 <tvrspnhlo7x7gpjc4nn7f73b2qoyphkpaxlcnnn4fsxciv6bks@3dibvbs7u5do>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <tvrspnhlo7x7gpjc4nn7f73b2qoyphkpaxlcnnn4fsxciv6bks@3dibvbs7u5do>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgA3YZ6tQTZpBrb2Aw--.58034S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGFW8uF15tFWkur1DGrW8tFb_yoW7Jry8pF
	Z3Ja4Sk3yrJr1agFnIqF4q9a4Yvw4Ikr13JryYvw1xAF9IqryFvr12krW0yrWUAry8ur1x
	XFWYvw1ru3yjyFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	s2-5UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspam-User: 
X-Stat-Signature: wc1jo1g5p49zppsk5uhnpzdntsdaho1y
X-Rspamd-Queue-Id: 4F49F16000D
X-Rspamd-Server: rspam06
X-HE-Tag: 1765163445-678146
X-HE-Meta: U2FsdGVkX1+I9ibrBsbZGnQbJT3A5lCx+oyGAnC2NWU9rN02v+mjIkumsqpgXny32s3gkXlJEZeti/9yBLibq/EtZ63dkgz5nzETwVTxkkI/iIeZgCJWYNBsEe2z10k79Eqa04PTqZt4aGnV83Exq+WseOjTub61/Y8KMKBkYDr+YducqE8DDjepWe/fb0gnOy+udu0RPDgWtPBwi9P93pYbUP4pP43dqJkpVZgpOEFXl6HlcxVoyYlHkEF5PQgssLyQomdhRHnf5SXJ1v2Nvoygya8B6ctjCHoSmfi1EBhnJHk8zToL0Vi/FBKTZJ16PVwl91p+JZRfYE/xC6rVj0jqGB6EW3CxYRmEE8Rn7ktFDb/12rV4cEkMRk7l7FkNLMobmCPnuzveRmYln5qMf3+fIaSkHUX65PT3Jp2y5YoW1MFenL/oLUfQWYS+5AsovOqwcDD/ZAnLU/pWovXHsVBuH29CgV7CFgfdIA7yS8i2nV+NSLVB0jwIISGhktipMkbJcBq4KClPGBN5x5btL4AGq/g+YFMlyKKgDvPP2Ih9fkkIcymhmF/HUPcRVPA0TntHdT2tsAgBHZZkGcm2SwJq0piwlKYALtR0daaLJAGTm2xDN2vJmV9Xr4rYxwA12Z3/274gJ+aeTq02MR+a0bhPPOzhVNQVTqHve15cjG0Bj1JxeWp+y+aCvC6FUFEJG1eVJ0dIyayo3ID51ha4ixbITm348bvkmyQXqNQOqw53dMHlHKfUxofSXEQ7lod90d64hnKoSTEVQ9b+RoOJ9z7J3W12ZKnKn1PxKBa5dDnmB1nCnypzE2R4eTaLg2aoTbaE4WVJ5FYuTlnat06Hiy6hgVG10VbRlg8EqEbtH1FUQ7gzlv+Q0obJy5YJfzSa4zMvkZOSOS35gISt3J2YHIUZPV+O1+FzW5QTELZJiPQCVor9vYLOJYo9cikpfE4H1Hc+7P184I+cw/PHxis
 HNHKJPu6
 9ME8E9y1SSRPd4T3RyLkXui1xoWCgFUkkDIIXbQBKa68Tw4ZSaPcJUK0N6XSJ7dSlJ7gNK8LvKMi01IfntpMi5drPEOu/WbwZp6uxS42Oa/3PE+RRApWKrj4Rnys3ITj0ReWv2TXwfDGGuZGX6x84xphQnpURISTGML2fO33qvLO9uRjFuCLfSxeamb+XU6BD9pej5JKwxeo4IvJdqkVExm+RlBv/YUCcGG+2Da3wKVmUVoLYfVRa8L91iwcmnibXs5DKJf+e+rO0pQkBUABXaE6vIJNK6wb28ROOyvSMnsTfoE4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/5 6:29, Shakeel Butt wrote:
> Hi Chen,
> 
> On Thu, Dec 04, 2025 at 12:31:23PM +0000, Chen Ridong wrote:
>> From: Chen Ridong <chenridong@huawei.com>
>>
>> The memcg LRU was originally introduced for global reclaim to enhance
>> scalability. However, its implementation complexity has led to performance
>> regressions when dealing with a large number of memory cgroups [1].
>>
>> As suggested by Johannes [1], this patch adopts mem_cgroup_iter with
>> cookie-based iteration for global reclaim, aligning with the approach
>> already used in shrink_node_memcgs. This simplification removes the
>> dedicated memcg LRU tracking while maintaining the core functionality.
>>
>> It performed a stress test based on Zhao Yu's methodology [2] on a
>> 1 TB, 4-node NUMA system. The results are summarized below:
>>
>> 					memcg LRU    memcg iter
>> stddev(pgsteal) / mean(pgsteal)            91.2%         75.7%
>> sum(pgsteal) / sum(requested)             216.4%        230.5%
>>
>> The new implementation demonstrates a significant improvement in
>> fairness, reducing the standard deviation relative to the mean by
>> 15.5 percentage points. While the reclaim accuracy shows a slight
>> increase in overscan (from 85086871 to 90633890, 6.5%).
>>
>> The primary benefits of this change are:
>> 1. Simplified codebase by removing custom memcg LRU infrastructure
>> 2. Improved fairness in memory reclaim across multiple cgroups
>> 3. Better performance when creating many memory cgroups
>>
>> [1] https://lore.kernel.org/r/20251126171513.GC135004@cmpxchg.org
>> [2] https://lore.kernel.org/r/20221222041905.2431096-7-yuzhao@google.com
>> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> 
> Thanks a lot of this awesome work.
> 
>> ---
>>  mm/vmscan.c | 117 ++++++++++++++++------------------------------------
>>  1 file changed, 36 insertions(+), 81 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index fddd168a9737..70b0e7e5393c 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -4895,27 +4895,14 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>>  	return nr_to_scan < 0;
>>  }
>>  
>> -static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
>> +static void shrink_one(struct lruvec *lruvec, struct scan_control *sc)
>>  {
>> -	bool success;
>>  	unsigned long scanned = sc->nr_scanned;
>>  	unsigned long reclaimed = sc->nr_reclaimed;
>> -	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>>  	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>> +	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>>  
>> -	/* lru_gen_age_node() called mem_cgroup_calculate_protection() */
>> -	if (mem_cgroup_below_min(NULL, memcg))
>> -		return MEMCG_LRU_YOUNG;
>> -
>> -	if (mem_cgroup_below_low(NULL, memcg)) {
>> -		/* see the comment on MEMCG_NR_GENS */
>> -		if (READ_ONCE(lruvec->lrugen.seg) != MEMCG_LRU_TAIL)
>> -			return MEMCG_LRU_TAIL;
>> -
>> -		memcg_memory_event(memcg, MEMCG_LOW);
>> -	}
>> -
>> -	success = try_to_shrink_lruvec(lruvec, sc);
>> +	try_to_shrink_lruvec(lruvec, sc);
>>  
>>  	shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
>>  
>> @@ -4924,86 +4911,55 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
>>  			   sc->nr_reclaimed - reclaimed);
>>  
>>  	flush_reclaim_state(sc);
> 
> Unrealted to your patch but why this flush_reclaim_state() is at
> different place from the non-MGLRU code path?
> 

Thank you Shakeel for you reply.

IIUC, I think adding flush_reclaim_state here makes sense. Currently, shrink_one is only used for
root-level reclaim in gen-LRU, and flush_reclaim_state is only relevant during root reclaim.
Flushing after each lruvec is shrunk could help the reclaim loop terminate earlier, as
sc->nr_reclaimed += current->reclaim_state->reclaimed; may reach nr_to_reclaim sooner.

That said, I'm also wondering whether we should apply flush_reclaim_state for every iteration in
non-MGLLU reclaim as well. For non-root reclaim, it should be negligible since it effectively does
nothing. But for root-level reclaim under non-MGLRU, it might similarly help stop the iteration earlier.

>> -
>> -	if (success && mem_cgroup_online(memcg))
>> -		return MEMCG_LRU_YOUNG;
>> -
>> -	if (!success && lruvec_is_sizable(lruvec, sc))
>> -		return 0;
>> -
>> -	/* one retry if offlined or too small */
>> -	return READ_ONCE(lruvec->lrugen.seg) != MEMCG_LRU_TAIL ?
>> -	       MEMCG_LRU_TAIL : MEMCG_LRU_YOUNG;
>>  }
>>  
>>  static void shrink_many(struct pglist_data *pgdat, struct scan_control *sc)
> 
> This function kind of become very similar to shrink_node_memcgs()
> function other than shrink_one vs shrink_lruvec. Can you try to combine
> them and see if it looks not-ugly? Otherwise the code looks good to me.
> 

Will try to.

-- 
Best regards,
Ridong


