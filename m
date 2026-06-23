Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 091CECD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 13:23:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DED296B008A; Tue, 23 Jun 2026 09:23:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA0CD6B008C; Tue, 23 Jun 2026 09:23:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C65886B0092; Tue, 23 Jun 2026 09:23:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8F78D6B008A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:23:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0C0FDA044E
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:23:14 +0000 (UTC)
X-FDA: 84911243508.11.D7C636E
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0469D80004
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:23:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=c3JvS0Md;
	spf=pass (imf30.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782220992;
	b=tpoRJca86y6JQInN9b8Mi8nzVmYAbtITz/0wmcgVkuLJeWdmsMkNGOJrkOlQIiUqAXRtiW
	IC8KIgHdkg6MK0EieVkJrWmI5NTHl6dP2eKeGwF4m0uNMwKG8CNomjYKlvsW9BiX17nccf
	BWWzprhIuasLQIRBXWI3l4Uni66CuZI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782220992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QloDB+XeabkMLlJLsdcpDwsjdd7YtMclccAzwToO5bM=;
	b=RsDawZGjXWkKrJqUzSrS01370cAoTJEGp0oeIY5qbrusQLm+yoanfvaYm71i2fdseWMmwq
	nBOrccTg4GHg6kaf0l/UZB3qmENLm3XgWnncX6wei7VFpVhx7HqUoBGLGK8HVgnss64K/y
	sv1WDG2/m29EeX5gYutvHSOY3oDdHIs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=c3JvS0Md;
	spf=pass (imf30.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-6a11ee16bafso101304eaf.0
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782220991; x=1782825791; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QloDB+XeabkMLlJLsdcpDwsjdd7YtMclccAzwToO5bM=;
        b=c3JvS0MdvSZ/6TdTXoVttAlrl7hti7ivSZWJUP8Kb3hhnoWLDTz81fz5lSlR0jxDHL
         JiqkGe78CrjFuqgLXI9BNOQcHnvMED1cfFlCcKIlPM7xDWDtGl6XoQCD3fr7nxvAPpCm
         Ntgpkbh76s3hHQ/kPCN4yf8n8azQBMn0g21vCN6hA9XLIvlX7LxxnNpbsuycCiPV1fvZ
         hQLloqufV5w65kdE7FSK6LRh6v0lxl/gMfaov2iV3cT9OI71LUmQG3P6oSbnx7C6OyNB
         P/U5/BwfQ4Z9+9+EHrcT3x8Kr5XRy/ys8Am2JdBTMyN4qtOec4WMJ+hHTiBoA47Auj00
         LJdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782220991; x=1782825791;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QloDB+XeabkMLlJLsdcpDwsjdd7YtMclccAzwToO5bM=;
        b=Nooii6XwKTEQSVnqfhk8rO11YjFUm8zyyUO7fentvIH9HO8bak3DLJZhYp14c24HU8
         KjHe0bdH9E7/8wS+MQV3GCFObVP/X5yAFapRp0QqozmbNH2dL4wPtcoOfQFlnsgpf2Qu
         iVdKEKTcyPbZ+pwfk4vocCchqR8Pemz+V/NiwWjPcklC54/F+MT1gVKVae/MjeiDvCzF
         16vzOImw89mz/3msaNjL0BzqozwK/rj85IC33pRiW4O5p12q9CPSB9jQ4x2WxagT4dOH
         dzys4S/v1LKI+J6KtBOv95XTvVfcbSSSxD2ep7tJnTxiGomeiPnsvkArQgH83I75zbhf
         4gyA==
X-Forwarded-Encrypted: i=1; AFNElJ+XE02fJnVn4SHeoIpGykrHkAspDfkSH0t1XDUFOsKHHRL0qv5S6hNKltCVe2+5L4diuSIqVje//w==@kvack.org
X-Gm-Message-State: AOJu0YxLHhXzatboHvGsW+Btt9ROFwp7uEihN4tR4N9ax2w7cZRl80Qz
	JGNeUKdg0n/EebXg1QYzMWQc4gR8IpdnSVpVesx3w8YV0a8+hV0kvGQ5
X-Gm-Gg: AfdE7cl7J0zGAnzsFob5CMEDMF9NQzcJOBzBj4/lpoA2senAn6LjrkQlE20QsnEsVkL
	awEyH9sOEVw/d2GWnC8Wpnm9ybB1R9+WvgtRgF6HLxI3GjF6XigupvKokZU2AmfTFqAbRR9C8XQ
	now9ebvsoLlyVJArXZB9Kp4SEYOtkX/ot6RZLo4DmwY5SOOE0LB4RKIVgX3iRkOp+DiTuVP5UTP
	CUTyPW3BKSDQXkHK81JugTt4XTuux1N79jAf/nnMcNi55EeOYfWza1YyiqowVP9KqNd9EmZdvyB
	pqInKRyADOWUl+9yNeOrCDH8Xy2VDmjbpq+UTY72agYeITg7rVyRkDUb3T0a7if59LN+DH2VazN
	8kLoZG8WYQKcFz6bqdr323e1CQBdgcdJkll8CL/1XFay7vjErtn44g2BjXMDbCO6YEaOaVC/UrJ
	5Q2XalkeWDaxI5BGuHSgKj1PejqdWSkDhb
X-Received: by 2002:a05:6820:4b01:b0:69e:ab0:3f4e with SMTP id 006d021491bc7-6a0d8d1b549mr15833025eaf.46.1782220990771;
        Tue, 23 Jun 2026 06:23:10 -0700 (PDT)
Received: from [10.125.192.89] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4472f0475e3sm8211821fac.16.2026.06.23.06.23.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2026 06:23:10 -0700 (PDT)
Message-ID: <d0f05c35-457a-4b2c-6faa-7a83d4bdec01@gmail.com>
Date: Tue, 23 Jun 2026 21:22:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v4 1/5] mm/zswap: Extend shrink_memcg() writeback
 capability
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
References: <20260618044857.69439-1-jiahao.kernel@gmail.com>
 <20260618044857.69439-2-jiahao.kernel@gmail.com>
 <ajnB8IZrFZwbIr9P@google.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <ajnB8IZrFZwbIr9P@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qj6jpkkjb7hhyjcwohjj8cbkiz5zwhjb
X-Rspamd-Queue-Id: 0469D80004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782220991-750025
X-HE-Meta: U2FsdGVkX196+AOwPArQ6i24Asi6fv1TEZ6lL71QCbXCy7/3C30FpNYpgwqMhPqAVI26qNiGznxRfwzAfbrmrVVuMsL8ZTJ2nJpM3OmauPL3CGl5VjC1Y26zq6PhfwD8c64Ix7Hq9vTcBl0nddzofuv5X8zKruY4p6E8ZUrPF1q6YBcOsg2Je7jXjYt51PyeuJUch3PryPnWoX2VFB16LbXoTVft0CnE8GwCVnQ1hKMUDFDm7HeZL9CluxBpB9+q7E8yC4mk1jyCLh8jAsVWpdPfp9KCbyMZu/GUAXBtfPbh1x1gXlAJVQ98Nb0s3qSqwPVX0Y2OcceDh067/EpWWbqKZRpMrKoKwSyK7jv9ocJJWvMSyGe4cesqXAFLaIC72ogdsUciSIMtf9FijqgDDaPhxi4wwQKdCe7Qo17nhPdeVLhXqiNFAiJVLwxJeSmJsINX0gxWIQhwh2pkyOpzMekye7zSdIIyiv57jpcheFdoPLRe5IIcGTPIBq+lirAB2YOV6s9/RA1KKl8SJvxOa3VmSQlemlWI2Qgyt2FiGBCpcsqGXXPSV8Ca1p/53HHiGsNTYfkImVLWhqWaeO8BEfhz4sRM+AHMXF0IEryEzqHnlrGXzzfAOk67AKWV7kN+iRxgAK6EAE+QmD6aQoy9J3CrGutm7+2alCuGZLT0Rpo/iO4fAglVnS7WlahPvcf9yFDBi6cvkTHulRVQi42zTxk8vFLG3z65CZL1vN0zEmP1n64fnL2FpnG4em05g0gdj09h3mFNt6vAuxeAW2Ez5oaSR3yyujjIKdiwQ6v4QRQWH5RGzM+ndpYMZ0GE3uRsr5WMt8fwMnnL1yQowlCy3cvrxG9ciiWX8NxBa1X3zoPky8cE9AdjOXrPcF50UyIWABt4I2gH5hkMHBI6nUP8nAccjH+ULK2ynx4h4PkZrLY1ObgglFtJXWD/dW3rSJC9NFoTfm4BQkrvQ2cZnTJ
 RJHLujOD
 h0smyMDQN4XvZ4x64sGLQv0D2umWLH/6pSsuASQXkaPih6picyQ5QVrMM0dk0481SJzs4Vc3aUGXrf4GHr03LtRneCsEggp6aybT4Y8Qlib7k4J2fkoFcF6ig6+8L11MX2OEcxTM+e9yEx+uuYfVeC83e8cdpKKH++pAe9BlTMXaTITYvuOG80jI8eJbJNMjjXLK9W2pJNszd0E0Wi2oIW1pyZa+P8utzTalXWCZNpMy+PMzPssE2i/VyfKDC3AdpQhcYUmub76CvpyuFlqcTS9qs6JRxLtURnnho8yk/5U7rn3YYj9IF339lHTookNcH3052QLcJDU3asW9F1bwtmaqbD6Vmv/JgYtE1uBd/R3cYJ+weybO/lqQpidi0/f3I85uWO4iDseBov4GJ4VEevL49EYd8aOUoQKeS52Nv2rIf9UjOhWjSHwInekq7Ue4RT/3Mi0W5WRb5vJcAFd/lSnx7oyliq4nG6O4UUrkSBDcpzGS22OKmmbgiP9gFFdyPuOszrwGxkYZf980fMQFvwC/7qLTmnbp5iE6J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/23 07:33, Yosry Ahmed wrote:
> On Thu, Jun 18, 2026 at 12:48:53PM +0800, Hao Jia wrote:
>> From: Hao Jia <jiahao1@lixiang.com>
>>
>> diff --git a/mm/zswap.c b/mm/zswap.c
>> index 761cd699e0a3..d7d031dee4cd 100644
>> --- a/mm/zswap.c
>> +++ b/mm/zswap.c
>> @@ -160,6 +160,11 @@ struct zswap_pool {
>>   	char tfm_name[CRYPTO_MAX_ALG_NAME];
>>   };
>>   
>> +struct zswap_shrink_walk_arg {
>> +	unsigned long bytes_written;
>> +	bool encountered_page_in_swapcache;
>> +};
>> +
>>   /* Global LRU lists shared by all zswap pools. */
>>   static struct list_lru zswap_list_lru;
>>   
>> @@ -1089,8 +1094,9 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
>>   				       void *arg)
>>   {
>>   	struct zswap_entry *entry = container_of(item, struct zswap_entry, lru);
>> -	bool *encountered_page_in_swapcache = (bool *)arg;
>> +	struct zswap_shrink_walk_arg *walk_arg = arg;
>>   	swp_entry_t swpentry;
>> +	unsigned int length;
>>   	enum lru_status ret = LRU_REMOVED_RETRY;
>>   	int writeback_result;
>>   
>> @@ -1135,8 +1141,13 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
>>   	 * Once the lru lock is dropped, the entry might get freed. The
>>   	 * swpentry is copied to the stack, and entry isn't deref'd again
>>   	 * until the entry is verified to still be alive in the tree.
>> +	 *
>> +	 * entry->length is also copied while the lock is held, because
>> +	 * zswap_writeback_entry() frees the entry on success and we still
>> +	 * need its compressed size to account for writeback.
> 
> Hmm that's unnecessary, just update "The swpentry is copied to the
> stack.." above to "Copy neded fields to the stack.." or something.

I'll do this, thanks.

> 
>>   	 */
>>   	swpentry = entry->swpentry;
>> +	length = entry->length;
>>   
>>   	/*
>>   	 * It's safe to drop the lock here because we return either
>> @@ -1155,12 +1166,13 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
>>   		 * into the warmer region. We should terminate shrinking (if we're in the dynamic
>>   		 * shrinker context).
>>   		 */
>> -		if (writeback_result == -EEXIST && encountered_page_in_swapcache) {
>> +		if (writeback_result == -EEXIST) {
>>   			ret = LRU_STOP;
>> -			*encountered_page_in_swapcache = true;
>> +			walk_arg->encountered_page_in_swapcache = true;
>>   		}
>>   	} else {
>>   		zswap_written_back_pages++;
>> +		walk_arg->bytes_written += length;
>>   	}
>>   
>>   	return ret;
>> @@ -1169,8 +1181,11 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
>>   static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
>>   		struct shrink_control *sc)
>>   {
>> +	struct zswap_shrink_walk_arg walk_arg = {
>> +		.bytes_written = 0,
>> +		.encountered_page_in_swapcache = false,
>> +	};
>>   	unsigned long shrink_ret;
>> -	bool encountered_page_in_swapcache = false;
>>   
>>   	if (!zswap_shrinker_enabled ||
>>   			!mem_cgroup_zswap_writeback_enabled(sc->memcg)) {
>> @@ -1179,9 +1194,9 @@ static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
>>   	}
>>   
>>   	shrink_ret = list_lru_shrink_walk(&zswap_list_lru, sc, &shrink_memcg_cb,
>> -		&encountered_page_in_swapcache);
>> +		&walk_arg);
>>   
>> -	if (encountered_page_in_swapcache)
>> +	if (walk_arg.encountered_page_in_swapcache)
>>   		return SHRINK_STOP;
>>   
>>   	return shrink_ret ? shrink_ret : SHRINK_STOP;
>> @@ -1275,10 +1290,32 @@ static struct shrinker *zswap_alloc_shrinker(void)
>>   	return shrinker;
>>   }
>>   
>> -static int shrink_memcg(struct mem_cgroup *memcg)
>> -{
>> -	int nid, shrunk = 0, scanned = 0;
>> +/*
>> + * The maximum acceptable scan cost factor for writing back
>> + * PAGE_SIZE bytes of compressed data.
>> + */
>> +#define ZSWAP_WB_SCAN_FACTOR	16UL
>> +#define NR_ZSWAP_WB_BATCH	64UL
>>   
>> +/*
>> + * Iterate over the per-node zswap LRUs of @memcg in batches, writing back
>> + * up to @nr_to_writeback * PAGE_SIZE bytes of compressed data.
>> + *
>> + * Return: The number of bytes written back, or -ENOENT if @memcg has
>> + * writeback disabled, is a zombie cgroup, or has empty zswap LRUs.
>> + */
>> +static long shrink_memcg(struct mem_cgroup *memcg,
>> +			 unsigned long nr_to_writeback)
> 
> 
> Is nr_to_writeback supposed to be the number of pages we want to
> writeback (regardless of their compressed size), or the compressed bytes
> we want to writeback divided by PAGE_SIZE?
> 
> The way it's being used below seems like it's the latter, but the batch
> size should be in terms of scanned pages (i.e. uncompressed pages). So
> this is confusing.
> 
> The zswap_store() path expects to reclaim one uncompressed page, but
> this will reclaim PAGE_SIZE worth of compressed memory when passing 1
> IIUC (actually maybe more, see below).
> 
>> +{
>> +	struct zswap_shrink_walk_arg walk_arg = {
>> +		.bytes_written = 0,
>> +		.encountered_page_in_swapcache = false,
>> +	};
>> +	u64 bytes_to_writeback = nr_to_writeback << PAGE_SHIFT;
>> +	bool memcg_list_is_empty = true;
>> +	int nid;
>> +
>> +	/* Memcg with zswap writeback disabled are not candidates. */
> 
> The comment is unnecessary here, it should be obvious.

I'll do this, thanks.
> 
>>   	if (!mem_cgroup_zswap_writeback_enabled(memcg))
>>   		return -ENOENT;
>>   
>> @@ -1290,24 +1327,65 @@ static int shrink_memcg(struct mem_cgroup *memcg)
>>   		return -ENOENT;
>>   
>>   	for_each_node_state(nid, N_NORMAL_MEMORY) {
>> -		unsigned long nr_to_walk = 1;
>> +		unsigned long nr_to_scan, nr_scanned = 0;
>> +		unsigned long remain;
>> +		walk_arg.encountered_page_in_swapcache = false;
>> +		/*
>> +		 * Cap by LRU length: bounds rewalks when referenced
>> +		 * entries keep rotating to the tail.
>> +		 */
>> +		nr_to_scan = list_lru_count_one(&zswap_list_lru, nid, memcg);
>> +		if (!nr_to_scan)
>> +			continue;
> 
> Hmm generally if we are running out of pages to scan then we should scan
> the rotated entries, and reclaim them on the second pass, right? So this
> should be working as intended. But I guess this doesn't work well when
> iterating multiple memcgs, as we don't want to drain referenced entries
> in one memcg before reclaiming already rotated entries on another.
> 
> So I think the assumption here is that the caller will retry if needed,
> handling balancing scanning between multiple memcgs if needed. Maybe we
> should document this in the function doc above? We should explain that
> referenced entries will be rotated but not reclaimed as part of the same
> call.
> 
>> +		memcg_list_is_empty = false;
>> +
>> +		/*
>> +		 * Cap by SCAN_FACTOR * remain budget: bounds scan cost
>> +		 * to the remaining writeback budget.
>> +		 */
>> +		remain = DIV_ROUND_UP(bytes_to_writeback - walk_arg.bytes_written, PAGE_SIZE);
>> +		nr_to_scan = min(nr_to_scan,
>> +				 remain * ZSWAP_WB_SCAN_FACTOR);
> 
> For the zswap_store() path bytes_to_writeback=PAGE_SIZE, so remain will
> initially be 1. But then we multiply by this factor and now to scan 16
> pages? Also, where did this factor and equation come from?
> 
> We'll also loop over nodes, so we may end up scanning 32 or more pages
> depending on the number of nodes in the system.
> 
> If this is just a heuristic, we should really just start simple and add
> heuristics later as needed. The caller should probably pass in the
> number of pages to scan (i.e. uncompressed pages), and leave it to the
> caller to decide when to retry if the actual memory savings are
> realized.
> 
>>   
>> -		shrunk += list_lru_walk_one(&zswap_list_lru, nid, memcg,
>> -					    &shrink_memcg_cb, NULL, &nr_to_walk);
>> -		scanned += 1 - nr_to_walk;
>> +		while (nr_scanned < nr_to_scan) {
>> +			unsigned long nr_to_walk = min(NR_ZSWAP_WB_BATCH,
>> +						       nr_to_scan - nr_scanned);
>> +
>> +			/*
>> +			 * Account for the committed budget rather than the walker's
>> +			 * actual delta. If the list is emptied concurrently, the
>> +			 * walker visits nothing and nr_scanned would never advance.
>> +			 */
>> +			nr_scanned += nr_to_walk;
>> +
>> +			list_lru_walk_one(&zswap_list_lru, nid, memcg,
>> +					  &shrink_memcg_cb,
>> +					  &walk_arg,
>> +					  &nr_to_walk);
>> +
>> +			if (walk_arg.bytes_written >= bytes_to_writeback)
>> +				return walk_arg.bytes_written;
>> +
>> +			if (walk_arg.encountered_page_in_swapcache)
>> +				break;
>> +
>> +			cond_resched();
>> +		}
> 
> If the caller is expected to have a retry loop anyway, should we
> simplify this and just scan each per-node LRU once?
> 
> We should also probably bail early if the number of scanned pages has
> already been reached? Currently shrink_memcg() scans one page at a time,
> so if it scans a bit more to balance between the nodes it's probably
> fine.
> 
> But with batching, we could end up scanning hundres of extra pages just
> to balance between all nodes. Is node imbalance a real issue?
> 

My initial thought was that if cold memory is evenly distributed across 
nodes and we are doing a large writeback, it would be better to balance 
the zswap entry writeback across all nodes rather than just draining 
node 0 first. However, since we currently lack a proper metric to 
represent hot/cold memory (such as age-based tracking), doing this 
probably doesn't make much sense right now.

So, perhaps we want something like this? Please correct me if I'm wrong.

static long shrink_memcg(struct mem_cgroup *memcg,
        unsigned long nr_to_scan)
{
   struct zswap_shrink_walk_arg walk_arg = {
     .bytes_written = 0,
     .encountered_page_in_swapcache = false,
   };
   unsigned long nr_remaining = nr_to_scan;
   bool memcg_list_is_empty = true;
   int nid;

   if (!mem_cgroup_zswap_writeback_enabled(memcg))
     return -ENOENT;

   if (memcg && !mem_cgroup_online(memcg))
     return -ENOENT;

   for_each_node_state(nid, N_NORMAL_MEMORY) {
     unsigned long nr_to_walk;

     /*
      * Cap the per-node scan by the current LRU length. A referenced
      * entry is only rotated to the tail (second chance) and may be
      * revisited within a single walk; without this cap those rotated
      * entries could drain the shared scan budget on one node.
      */
     nr_to_walk = min(nr_remaining,
          list_lru_count_one(&zswap_list_lru, nid, memcg));
     if (!nr_to_walk)
       continue;
     memcg_list_is_empty = false;

     nr_remaining -= nr_to_walk;
     list_lru_walk_one(&zswap_list_lru, nid, memcg,
           &shrink_memcg_cb, &walk_arg, &nr_to_walk);
     /* Return the unused share of the budget to the pool. */
     nr_remaining += nr_to_walk;

     /* Bail out once the whole scan budget has been spent. */
     if (!nr_remaining)
       break;

     cond_resched();
   }

   if (memcg_list_is_empty)
     return -ENOENT;

   return walk_arg.bytes_written;
}

Thanks,
Hao

