Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97969C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:49:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 090A56B00A5; Mon, 29 Jun 2026 21:49:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0406F6B00A7; Mon, 29 Jun 2026 21:49:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E99C46B00A9; Mon, 29 Jun 2026 21:49:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B0E216B00A5
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:49:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 647491C2751
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:49:27 +0000 (UTC)
X-FDA: 84934896774.10.BCB3E9B
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf10.hostedemail.com (Postfix) with ESMTP id 80C89C0005
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:49:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XkfiXeCm;
	spf=pass (imf10.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782784165;
	b=mx/DhGRKnm0PYodB/mHv5WE0ol7Dvmz2J5uxmfb90RL1CmAcfNLZ5sbVxh8KDjelB7O0m3
	bDJbnrqMZl+vVzELRy2rMV+lqz4ahYNvrlpcLNOyji9lrb88Nb+n2qJhzNOQUuXNj8zrWf
	FoBuGcGKQlmeIHoPmWmXfVG2LDoH1gw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782784165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kGzb5I99oVjrLBb+VIXHECds+0MQ3SMiFwp7W65djH8=;
	b=aCZxSduPvvWfppw/3ZalxjfaQnhAET7VpHPcwS7FiEEUoWc69Kd0QFeHZ/2JnBjZ/7kx1m
	/+WT7ghRTUAX4V+0DRB2RALTlb/0+4hN4qlJCQg6KnZ8QKqfHgO3Fq/B3MZJnaT7SBW52p
	J0NDM2ItRnVDw9ddj+L9e3DhMDyZafM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XkfiXeCm;
	spf=pass (imf10.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38005a36edbso966483a91.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782784164; x=1783388964; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kGzb5I99oVjrLBb+VIXHECds+0MQ3SMiFwp7W65djH8=;
        b=XkfiXeCmytyqjosPouFcLQ+z+j4s1fP+vrBhKuxX4PChs8ro5RfEqt6fCn/D53L4IA
         7d7RyN8lrGZ4ywtVumupw+/9ja8rzbKFdBpxnylZIoS8ocQ/NGiPExSxnQ7T2dS+WoFI
         xszgyNLovMwypISpCIqlvlCtEIK5+8gaQdyopY0hlB/PA2CIZnRafB7O+QievIiMDJUh
         HPasjrEdTqsTtwMGbduCDqGJfUJM3CTRL5meNvX7c1jThJ8LwCow479yq4ZSHvDGWxeD
         RDT5x5BshlmTgykvn/AiCQTdMLqtT6MfL+C0IpqyZMcCDNsS6XxPBnWi/YfFv4Gwcx8l
         Qq6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782784164; x=1783388964;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kGzb5I99oVjrLBb+VIXHECds+0MQ3SMiFwp7W65djH8=;
        b=J6mB+7SfTrhpQuU7m4o/arEruq5eTlngB6vEqm3jKcy+tEDV4lZDmQwntJbAz2NQQo
         YmRYuzD6TxOqwYr4X633vRXAQzeKoSFFXPdJlUzlmh5ZqiycWs5/5ZpB5JKqAlCwDmEY
         3sG1OUwGZO75f49H1hheRHN/GIVixlSjT8aF9K8Ms0fJUOZDWCqKZUZp+4YZ6Wgcd4TU
         S7W6uez/cGuK+/JA+9Q7hivGE7sBPUbWCvT/G1N/b1fZTyIXj61bnug8XCSy3b/3eOgH
         87GB9vCkfnT/h0M50DSq6QIPAT5lDc4P3CIJ8yrzDOAMuGt364nN2WzeX4rfrR0YuVnQ
         uyHg==
X-Forwarded-Encrypted: i=1; AHgh+RpubYqtemjMIBRw5+5G4ryjLmRU+2SUsyAW4IvTr2LTpQWQep+Px9L30a/cGnriHf4XW6rEAoZMXQ==@kvack.org
X-Gm-Message-State: AOJu0YzvLaSNpgNoF3aU9rZ6fIWXAb5UA3lJpbRce0euYJylXFOOHVBU
	YZFq6WQhIXIhqggYIRhdB9h9h3G8tOmooqf+MP2YGz8ww7P1aJJO8+6f
X-Gm-Gg: AfdE7cklcwcVAZeHWpnEQ87+J3vZA+8y64fQmw5dnCIac4zTn7Hgv/3sPtClXivatcn
	lAVBAY+VIgGl433xMMlzK27JqQau79yNOlU1l23AP2KZCX6BF7hNbcnjZN+09FTn1bRKH9xyo4x
	luNIwkuKgNEGU+W6FWHic7FpUiMNUBIVq3cKdLsMJ9aTzKrsOa4rQIRCZ9eHvdBLWWZcwrQBQJa
	rMPFJIYv9CqB/CnwppbFDWQOrEyrGFgvaSdFBklnLMYuRBptXzcu6ecFDZcuQ2a7KvhhjABYWLZ
	LiDKO7BPzIGwye5Dd0XglfySEuCzilcemwm5zjM/TZBx6nNvfGzdiHo11Wy6O3jDRndRQ+lecHr
	rdS4ziwihrBg5AhcNO0fEWjfMkQfKVAGNUUtB1gag4SzzDiDwQzQPjISip3QprTQc1iAZ48IFJQ
	J/IaCKf3Y5tmMq1EL1EXLdV/cFQuwNitze
X-Received: by 2002:a17:90b:1d4c:b0:37f:db06:229c with SMTP id 98e67ed59e1d1-380527a8520mr1156642a91.22.1782784164449;
        Mon, 29 Jun 2026 18:49:24 -0700 (PDT)
Received: from [10.125.192.77] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38052737fbesm673824a91.0.2026.06.29.18.49.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2026 18:49:23 -0700 (PDT)
Message-ID: <cbbdf506-b67d-193c-2c94-bacf828d559f@gmail.com>
Date: Tue, 30 Jun 2026 09:49:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v5 4/6] mm/zswap: Implement proactive writeback
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
References: <20260629112032.20423-1-jiahao.kernel@gmail.com>
 <20260629112032.20423-5-jiahao.kernel@gmail.com>
 <akMJ8UfeZXrVe5LN@google.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <akMJ8UfeZXrVe5LN@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1r53d4kani71tpd6ampmrgas3f69dtjb
X-Rspamd-Queue-Id: 80C89C0005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782784165-586384
X-HE-Meta: U2FsdGVkX18/AzIM/KMhShnyUcBHc91T09kK7KkXQ4ofsyYCNaOdrYRtrATO6bNOoZ2TIRj/pD6z0Qebj807HAY9wxTf7BCmeIMSNPpFsptCKZ4YgEELEysnyi275jjw4i2mTi9y+gVMMzXNaET+16WgsxiJd+X8TejuSXZAjP4c6Q6QVndZr8NRc6Bf/1OSoDF2BJJakyHBbPPvQhf8MHtGs7kz0MPLGa5IvPNZCXdBNBkEwKeqs3fCLi4DB9SCAZH5Pq3GmyoiU5rBJAJi5KydZf0qLBvJ7TNJqQhR++zNyG5voAzKODrqPemBfsiqIJ/bBNEK0v+e+8hvczfbBm64w0NlQoET8IH2CEFdAX2qis5e874HR7rqPiE4lEdq9QCbTaNffZ6G82M2IouiZgo+1xb41iFX2sT7gvy/UVtkdrCRsU2cs7aWJEdkwdSgr7dylKL/6WKgcQYQxY96+6ogwRgePCahV3VpcifcOjA2njWm8O+j4bASlFGuy44sQizQiwcPvUa41ji3avbuEy/itDQQHX8hjMPiRMlN/ujXJTwC4bwYmgP5IdfMn53TFJWsGdRCYg9OEV4wnrUnd4d1LPvOJMa8LmkMQTvjOZiaKERxQ9hYoZTiYrxlpEoTweTzsOP2FJ1xf2Xsz0quh0IPQtKGz3AdJ/rNnBC1EK6dL1/MBtURmxNFrx9gAMfx+PGRbfTQUZbRkMl/4WUGPJHzXT0KxIKSSeXF2h/6ZW5xvFT+t7BYpnuDYHH6LWcJmSyl9kRNYrU8K52etiB54J8kYRdBQ/mtGzhHyinPTxby1mzwpzbYzbewjB7yo37wpiUedeIvoCvjtpRpdkBpxZgJk5EwuRAeYbX3Xybo170JXLAJG6jdr7YUm9ULz/s1BB96ScxmsyeiDb0k9LCHE6pocYkVy3OmkCY5PWEA3qSd29zNWebffdRNlfyVmc2Uoa8jaVCFGFpYWTUd89F
 iCRqQEV9
 3feHdEvTGlIf2OiszGe3lJkA1o+KpzwzkbcFRR1pu18nbzBCUQiDaMvNH0QQ8m3SwNGK0wEwI9gtQHdfGvQcIPwkwyIYpcc+xDfakK/vEtfCA1J0StbzC1ifJ/nMQ7RWHurBxeAI8/AYorvTSGY1+NNgnPktiBdg6HbI154SeCv4EsXbgZ1ykorMOl2LyNJMoEZATtxXMPlB9QFgkbOIMTzUdtu5kXa08cp1XA596/WJpdBu2C8+N+NfWxvtHNcyDJK97E9BJOpg+9xFItz7jJ5k+PrHPzuqFh7Hfc5Q5QvZ2yX5XLihea/cYzaOtmJWozvopi4eop3GS+u+GnwKsE1yb8dLe1j5lFdFBOlAY7Unht3eRKQdyNUQtZrDguH03NhEoNuCKhVEyhRKGjxHdwUUl+I8fM132X/JSyTe9PAXTwmQ2X/NKM+3WfsFKC9BUVf7s/4guvm5o/HnwrWhLK08PKYbnIwg05l06xNgj5YC/73HKlM2dQV4unYaira/21J6DSTirknPYxBVtnrj5am5PXiupu+GxK0S0HyydCVXRD99XQk6K+EfE8fpfoooC0yHU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/30 08:15, Yosry Ahmed wrote:
> On Mon, Jun 29, 2026 at 07:20:30PM +0800, Hao Jia wrote:
>> From: Hao Jia <jiahao1@lixiang.com>
>>
>> Zswap currently writes back pages to backing swap reactively, triggered
>> either by the shrinker or when the pool reaches its size limit. There is
>> no mechanism to control the amount of writeback for a specific memory
>> cgroup. However, users may want to proactively write back zswap pages,
>> e.g., to free up memory for other applications or to prepare for
>> memory-intensive workloads.
>>
>> Introduce a "source=" key to the memory.reclaim cgroup interface,
>> currently accepting the single value "zswap". When set to "zswap", it
>> bypasses standard memory reclaim and exclusively performs proactive
>> zswap writeback up to the requested budget. If omitted, the default
>> reclaim behavior remains unchanged.
>>
>> Example usage:
>>    # Write back 10MB of compressed data from zswap to the backing swap
>>    echo "10M source=zswap" > memory.reclaim
>>
>> Note that the actual amount of compressed data written back may be less
>> than requested due to the zswap second-chance algorithm: referenced
>> entries are rotated on the LRU on the first encounter and only written
>> back on a second pass. If fewer bytes are written back than requested,
>> -EAGAIN is returned, matching the existing memory.reclaim semantics.
>>
>> Internally, extend user_proactive_reclaim() to parse the new "source="
>> key and invoke the dedicated handler zswap_proactive_writeback() when it
>> is set to "zswap". This handler walks the target memcg subtree in a
>> round-robin fashion and drains each memcg's per-node zswap LRUs through
>> shrink_memcg(), accumulating the compressed bytes written back until the
>> requested budget is met.
>>
>> Suggested-by: Yosry Ahmed <yosry@kernel.org>
>> Suggested-by: Nhat Pham <nphamcs@gmail.com>
>> Signed-off-by: Hao Jia <jiahao1@lixiang.com>
>> ---
> 
> Before going through more versions we need to figure out if this will
> pivot to be a proactive demotion interfcae for swap tiering.
> 

Yes. Should I drop patches 4-6 in the next version and wait for swap 
tiering to be finalized?
We can try to get the non-memcg parts (patches 1-3) merged upstream 
first. This would also give them plenty of time to bake and catch any 
potential regressions. Thoughts?


>> @@ -7869,9 +7872,12 @@ int user_proactive_reclaim(char *buf,
>>   	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
>>   	unsigned long nr_to_reclaim, nr_reclaimed = 0;
>>   	int swappiness = -1;
>> +	bool zswap_writeback_only = false;
>>   	char *old_buf, *start;
>> +	char source[16];
>>   	substring_t args[MAX_OPT_ARGS];
>>   	gfp_t gfp_mask = GFP_KERNEL;
>> +	u64 nr_bytes;
>>   
>>   	if (!buf || (!memcg && !pgdat) || (memcg && pgdat))
>>   		return -EINVAL;
>> @@ -7879,7 +7885,8 @@ int user_proactive_reclaim(char *buf,
>>   	buf = strstrip(buf);
>>   
>>   	old_buf = buf;
>> -	nr_to_reclaim = memparse(buf, &buf) / PAGE_SIZE;
>> +	nr_bytes = memparse(buf, &buf);
>> +	nr_to_reclaim = nr_bytes / PAGE_SIZE;
> 
> Nit: if we keep this as part of memory.reclaim, we probably want to
> choose clearer names (e.g. pages_to_reclaim and bytes_to_reclaim).

Will do.
> 
>>   	if (buf == old_buf)
>>   		return -EINVAL;
>>   
>> @@ -7899,11 +7906,26 @@ int user_proactive_reclaim(char *buf,
>>   		case MEMORY_RECLAIM_SWAPPINESS_MAX:
>>   			swappiness = SWAPPINESS_ANON_ONLY;
>>   			break;
>> +		case MEMORY_RECLAIM_SOURCE:
>> +			if (match_strlcpy(source, &args[0], sizeof(source)) >= sizeof(source))
>> +				return -EINVAL;
>> +			/* Only zswap is supported as a reclaim source for now. */
>> +			if (strcmp(source, "zswap"))
>> +				return -EINVAL;
>> +			zswap_writeback_only = true;
>> +			break;
>>   		default:
>>   			return -EINVAL;
>>   		}
>>   	}
>>   
>> +	if (zswap_writeback_only) {
>> +		/* source=zswap and swappiness are mutually exclusive. */
>> +		if (swappiness != -1)
>> +			return -EINVAL;
>> +		return zswap_proactive_writeback(memcg, nr_bytes);
>> +	}
>> +
>>   	while (nr_reclaimed < nr_to_reclaim) {
>>   		/* Will converge on zero, but reclaim enforces a minimum */
>>   		unsigned long batch_size = (nr_to_reclaim - nr_reclaimed) / 4;
>> diff --git a/mm/zswap.c b/mm/zswap.c
>> index ba01bf0e44e9..9cda96f05508 100644
>> --- a/mm/zswap.c
>> +++ b/mm/zswap.c
>> @@ -1713,6 +1713,56 @@ int zswap_load(struct folio *folio)
>>   	return 0;
>>   }
>>   
>> +int zswap_proactive_writeback(struct mem_cgroup *memcg, u64 bytes_to_writeback)
>> +{
>> +	struct zswap_shrink_state s = {};
>> +	struct mem_cgroup *iter = NULL;
>> +	u64 bytes_written = 0;
>> +	int ret = 0;
>> +
>> +	if (!memcg)
>> +		return -EINVAL;
> 
> Can this ever happen? It would be a bug in the caller.

IIRC，Writing the following to the NUMA node sysfs entry triggers this 
check:
echo "10M source=zswap" > /sys/devices/system/node/nodeN/reclaim

> 
>> +	if (!mem_cgroup_zswap_writeback_enabled(memcg))
>> +		return -EINVAL;
>> +	if (!bytes_to_writeback)
>> +		return 0;
> 
> Do we need this? I think the loop will just never enter and
> mem_cgroup_iter_break() will do nothing.

Will do.
> 
>> +
>> +	while (bytes_written < bytes_to_writeback) {
>> +		long shrunk;
>> +
>> +		cond_resched();
>> +
>> +		if (signal_pending(current)) {
>> +			ret = -EINTR;
>> +			break;
>> +		}
>> +
>> +		/*
>> +		 * Use a local iterator to walk the memcg and its online descendants
>> +		 * in a round-robin manner. Upon exiting the loop, mem_cgroup_iter_break()
>> +		 * must be called to drop the iterator reference.
>> +		 */
>> +		do {
>> +			iter = mem_cgroup_iter(memcg, iter, NULL);
>> +		} while (iter && !mem_cgroup_tryget_online(iter));
>> +
>> +		shrunk = zswap_shrink_one_memcg(iter, &s);
>> +		if (shrunk > 0)
>> +			bytes_written += shrunk;
>> +
>> +		/* drop the extra reference taken by mem_cgroup_tryget_online() */
>> +		mem_cgroup_put(iter);
> 
> 
> Can we just use mem_cgroup_online() instead since mem_cgroup_iter()
> already graps a ref?
> 
Will do.

Thanks,
Hao

