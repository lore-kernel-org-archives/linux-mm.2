Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1057ACD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 11:27:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58F7B6B0093; Wed,  3 Jun 2026 07:27:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 566AC6B0095; Wed,  3 Jun 2026 07:27:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 456046B0096; Wed,  3 Jun 2026 07:27:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 36DC76B0093
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:27:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E8AC1A031B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:27:35 +0000 (UTC)
X-FDA: 84838376070.21.6CF6115
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id AF6131C0009
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:27:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k9+SutXW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780486053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bGeTlR7gBa/MmVgFAbV0MjIRnlhQQbkpnIke5FnciGo=;
	b=lbxBTgOIzKkjeCDyMa5sYtpttM5N09Fh7j80Mm6sk2ZCzF5+ggxGA5+MujiUbv+sABWWGb
	j7byeF3D29bqqSf2SpZIhkd7ktYZu1FTf9A5/chZzPkwTXZQXwOrmjpf+s4pph/d1XBrBP
	GTtMYtND3fyGLSfVAHFIXAR3n1k0ei0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k9+SutXW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780486053;
	b=oFtKmdLrvJonp8K2HsNauhHIo7GrA3Ssa2blsAOgXk0rdiLsdZquv8nHFJ2XoRADLPMe/j
	/8cXIcZsWaOXQdCpzJp5dp//IdZFhnUmSIBRZnE4kmy8ueUhLWW3aI/2Xbpw5tb4jOeWF/
	SbNaSKTtFTLiNxJate07mSCBwgLRr4E=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2bf3781ca51so42916785ad.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 04:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780486052; x=1781090852; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bGeTlR7gBa/MmVgFAbV0MjIRnlhQQbkpnIke5FnciGo=;
        b=k9+SutXWWM+8/OJ+Sfp1X25cCUA8aiPg46wHV/V2Dzq0dgiI23Tyq3qeQ3DgsOYhvn
         4u62ipCp/6r1Ar0TV906cb8aM/P/CSen5MGDSj/xPrEXcpsPMdOmkTaXnztKcnW4zmOc
         58Lwethxg7Pe97vjjuLalI1e+5ahthWD/VxKzGzO5G7BKaRfTGUIV2PItQ2GTkYar2M0
         TecLpq/tp8sQh3M6H4UdC555P3qvCbNZkp7Qk73Suex7/iupoPEqHzTofLHYYBDY6CBO
         WA1ljyZkelrbTD7nKiYSEhxqQ2PGBNtAduvv6jHodEU5QHKFax6QrgFIuxuCZlVdYbI2
         eRMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780486052; x=1781090852;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bGeTlR7gBa/MmVgFAbV0MjIRnlhQQbkpnIke5FnciGo=;
        b=V5fy9zuDsTP+4qHhmBpIyY4lRseVpb3Ij7Q+wLqQXtAGFqizmXyXuRMdNhmarlKIHP
         qkedILGsejoQIAWoHIH0x5ELGXhdquII46OCfpjBXZ5JuvnHOf7Jv+zozTTfPcJvTLsk
         C40evTHKOXCwhql4z2C5luGeRCsit5ksLZg9MWQgHig5UY3eATPVY4P9ODJ4Nv/BcrpS
         KWgnTELZ44xlKZBjCDwOj/tUEcObUlxWDr2HInsFRPumwsLKoDZdM9mfDhemN+lAq31c
         uiwXWoz861avHvdIm647kkShm6L7NrcuGSICO4M5DyczlsenXqsFV/IvwMcxmQHXhSrr
         5xZA==
X-Forwarded-Encrypted: i=1; AFNElJ+HsoY3Z1/q1znHS2GVwSdAe7GQktfFp2SOqAA7uHySkjlH/QGklPJZX8Gy/7MkeQOLS7Aupc3LKw==@kvack.org
X-Gm-Message-State: AOJu0Yw57HqNGRK6kDvxcyJceYLCWMGijBsBnzdFBoO8XyyWw6PeZjVw
	gIYKhLmnKLesqd+mYU+pqd4zQvzOwGECQxc8zvW7Mz4o3zKQDa38p8Mt
X-Gm-Gg: Acq92OGsWphW2pk3vMdVYwDotrNyH4Qy6jDQvh82YRIqi3mYCN+O2Y03C4L8Cy5xIjv
	XeBEcUz9oQXXmxZB0+vcP3AkLtpj3efLEXFJUt95yOS4n+Krrfivo+rPKPsDYUFlCtdI250FqN+
	QRWkPhuln9UMKmhBoaWboHCUONnPjsjbPEJZSdEzu4AY1ZcncGP/kis+8haTt6NtzNyUNwFDnWW
	r5qRYXWACxc/aoVEkQj+eVO66XjynMys5+dJNaQDQ4VONMelg1whMNYxLMQmjLJewyUTSNANBBm
	fw2AO3ZhShy8W+rYdZbkYfWcA52McHhUUS0Hc5gXIFMxTHBA+OF37k46KKY2havbZtyJjiyxevl
	/zKaJ4ojFGuf5rai7ti/2M4ZrsbVkV/XRRsn1/sqSUXhW3H/7QbxM+J/lbQRJsC4nDUewIRbSVh
	gataG6RwcdAsDTq/F7l+nDGL7PNs6U70KMOD60EjrbEK4XGFA7qZPTBA==
X-Received: by 2002:a17:902:f60b:b0:2bf:160f:7043 with SMTP id d9443c01a7336-2c1644b2994mr34374485ad.34.1780486052378;
        Wed, 03 Jun 2026 04:27:32 -0700 (PDT)
Received: from [10.125.192.75] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164f88473sm25004435ad.25.2026.06.03.04.27.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 04:27:31 -0700 (PDT)
Message-ID: <ea2c1323-1440-e927-f14a-0eac54a245bf@gmail.com>
Date: Wed, 3 Jun 2026 19:27:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-3-jiahao.kernel@gmail.com>
 <aho-Z6wshceTAYd9@google.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <aho-Z6wshceTAYd9@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AF6131C0009
X-Stat-Signature: a7q93zx6jyxw1u1xpkh7qa5sezqbqu1h
X-Rspam-User: 
X-HE-Tag: 1780486053-649292
X-HE-Meta: U2FsdGVkX18iN2HE2aqf/rv0dFxCH1KcOl61o2lmE8zOLWcQYLmmwW/vogdfpymt454rUx+JUleeXIenSbRkufXagbQpQf3HBAXe+yU6LslcnMVJVHZu4gXC8FCNbkvudshP45ZSDqq3HQ+RTB//Y6q+AxzlJnM4YZTVquWhYopRzucqgrdWn+78YwrTVHmqOjYjspo9cWvr123s1kVHaM07eM3emD0XGwFcSBBRHzxi91cR3Wd5TpRot++0+vndK8aVvc8Vly8lQ/MvI5yHp9eox6PoOUSBPqd7dNPEfqAgUE7ELfrYJo7U21GvHoy37fuqym5Efhy44WXB70SIflex3zqDlDvBmtLARRDYekxvn8IpHeT6VbUHZCK4E89PUin711WGGL4gp/+V8ZI1xC+abgt9gO9GoxpoxeE8pqli0L0wAEXNC+yvH93QJ22f7ziE0ruaUF1bJIpSUq2KMypwdUa6Zxacz/DR+qAbUTblOBiSi2YqtOhI8Krq3aeybYYiktbjVC4ZQ7aNHBqMR5HqXDtqeCV56ArjtBly4XaFr8jH918LyG27CQs+2ShrNTq30Co6EH2kWLHJb3o/AxdUwnQo+RyFyrMJ0TK5h2beTy7OO0tCVsr7AHs2DYHF8bFrRgCnaTGN9rAGzxbrf7sFh1nyESSZGDifsQYv4YpL6tT/2MLBWRcP+xlGTKq05QThWHJGGofrdo4tHHXfVp3benOahrzViEzyzKIHeMkksPmVnksM/LzO6n5veQ6sS/XUJTN1YjukjV+xuDJoYcDVG74y7YTq5ZFwsi6nT06F4lUe4qkpxEPHWDeKCYtkObPOgZJXs5Zvnn9Qf7qoTDuSpnyqR/JRvMYi3u3nj3q8kBMssWmGfxSkyXpqkxJ8GCvdhPbwm+aw+aZA+SMQKnt2kvytETLjN4HMlt/ykbcRy9cRA3dmJzjuZbcrFwiHap2e6MapqjK/7QuW4Vi
 HX1IoLtJ
 UNE+4W0zqlhWsEBQnsWRLAxKc7Vnfz/rmHRwimhFeriB+BSW1URd2uWvXLLQvcZtLw+fQAgYmx8/zlCBxAWFUrVCnYboC6IKUl2pcB7FChfbsfvCsMBRSMiTZCvJh92rOXqLT9jVCwsnZld3fZkozkMdP2cp9AtJZUQjfVOmcAjDDiu8ve56NPmfMz3Fk3TeuJS3fGZ1HQzo8DLpohloXkyg0VT6kxZeiEy/Mgqwv+EG2P/Qjg6BTEIVdnpFAvbvIn0NQZEqoPKywneboGtEeheq79hInlIzVK9ZmBzqOBKvkcMVFAUBEBm1fcMpk8KdKACMVaC6BEhbKSBCZVfzpw9W67b0/5Q6qdF0SpyiEN/T3fa4abLHwbLAc+t6elxfI9SJ93FWNipYmFKDQtssp8XMf+1h7BCTxNtrUYot2yHnR4z09TYEwyoDR5hLDmmAydPksmIQRkCceVTHCDH09Atm+Cgb0a32Vl4f0bzZhrELvAqbIlFfq/UkU0vTmkHaKvnUUpcvBd2XtlZf59u5wixrm11z2StdUiZyC8OBsDUuOxJ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/5/30 09:37, Yosry Ahmed wrote:
> On Tue, May 26, 2026 at 07:45:59PM +0800, Hao Jia wrote:
>> From: Hao Jia <jiahao1@lixiang.com>
>>
>> Zswap currently writes back pages to backing swap reactively, triggered
>> either by the shrinker or when the pool reaches its size limit. There is
>> no mechanism to control the amount of writeback for a specific memory
>> cgroup. However, users may want to proactively write back zswap pages,
>> e.g., to free up memory for other applications or to prepare for
>> memory-intensive workloads.
>>
>> Introduce a "zswap_writeback_only" key to the memory.reclaim cgroup
>> interface. When specified, this key bypasses standard memory reclaim
>> and exclusively performs proactive zswap writeback up to the requested
>> budget. If omitted, the default reclaim behavior remains unchanged.
>>
>> Example usage:
>>    # Write back 100MB of pages from zswap to the backing swap
>>    echo "100M zswap_writeback_only" > memory.reclaim
>>
>> Note that the actual amount written back may be less than requested due
>> to the zswap second-chance algorithm: referenced entries are rotated on
>> the LRU on the first encounter and only written back on a second pass.
>> If fewer bytes are written back than requested, -EAGAIN is returned,
>> matching the existing memory.reclaim semantics.
>>
>> Internally, extend user_proactive_reclaim() to parse the new
>> "zswap_writeback_only" token and invoke the dedicated handler. Add
>> zswap_proactive_writeback() to walk the target memcg subtree via the
>> per-memcg writeback cursor, draining per-node zswap LRUs through
>> list_lru_walk_one() with the shrink_memcg_cb() callback.
>>
>> Suggested-by: Yosry Ahmed <yosry@kernel.org>
>> Suggested-by: Nhat Pham <nphamcs@gmail.com>
>> Signed-off-by: Hao Jia <jiahao1@lixiang.com>
>> ---
>>   Documentation/admin-guide/cgroup-v2.rst |  18 +++-
>>   Documentation/admin-guide/mm/zswap.rst  |  11 +-
>>   include/linux/zswap.h                   |   7 ++
>>   mm/vmscan.c                             |  14 +++
>>   mm/zswap.c                              | 138 ++++++++++++++++++++++++
>>   5 files changed, 185 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
>> index 6efd0095ed99..6564abf0dec5 100644
>> --- a/Documentation/admin-guide/cgroup-v2.rst
>> +++ b/Documentation/admin-guide/cgroup-v2.rst
>> @@ -1425,9 +1425,10 @@ PAGE_SIZE multiple when read back.
>>   
>>   The following nested keys are defined.
>>   
>> -	  ==========            ================================
>> +	  ====================  ==================================================
>>   	  swappiness            Swappiness value to reclaim with
>> -	  ==========            ================================
>> +	  zswap_writeback_only  Only perform proactive zswap writeback
>> +	  ====================  ==================================================
>>   
>>   	Specifying a swappiness value instructs the kernel to perform
>>   	the reclaim with that swappiness value. Note that this has the
>> @@ -1437,6 +1438,19 @@ The following nested keys are defined.
>>   	The valid range for swappiness is [0-200, max], setting
>>   	swappiness=max exclusively reclaims anonymous memory.
>>   
>> +	The zswap_writeback_only key skips ordinary memory reclaim and
>> +	writes back pages from zswap to the backing swap device until
>> +	the requested amount has been written or no further candidates
>> +	are found. This is useful to proactively offload cold pages from
>> +	the zswap pool to the swap device. It is only available if
>> +	zswap writeback is enabled. zswap_writeback_only cannot be combined
>> +	with swappiness; specifying both returns -EINVAL.
>> +
>> +	Example::
>> +
>> +	  # Write back up to 100MB of pages from zswap to the backing swap
>> +	  echo "100M zswap_writeback_only" > memory.reclaim
> 
> 
> memcg folks need to chime in about the interface here. An alternative
> would be a separate interface (e.g. memory.zswap.do_writeback or
> memory.zswap.writeback.reclaim or sth).
> 
>> diff --git a/mm/zswap.c b/mm/zswap.c
>> index 73e64a635690..7bcbf788f634 100644
>> --- a/mm/zswap.c
>> +++ b/mm/zswap.c
>> @@ -1679,6 +1679,144 @@ int zswap_load(struct folio *folio)
>>   	return 0;
>>   }
>>   
>> +/*
>> + * Maximum LRU scan limit:
>> + * number of entries to scan per page of remaining budget.
>> + */
>> +#define ZSWAP_PROACTIVE_WB_SCAN_RATIO	16UL
>> +/*
>> + * Batch size for proactive writeback:
>> + * - As the per-memcg writeback target in the outer memcg loop.
>> + * - As the per-walk budget passed to list_lru_walk_one().
>> + */
>> +#define ZSWAP_PROACTIVE_WB_BATCH	128UL
>> +
>> +/*
>> + * Walk the per-node LRUs of @memcg to write back up to @nr_to_write pages.
>> + * Returns the number of pages written back, or -ENOENT if @memcg is a
>> + * zombie or has writeback disabled.
>> + */
>> +static long zswap_proactive_shrink_memcg(struct mem_cgroup *memcg,
>> +					 unsigned long nr_to_write)
>> +{
>> +	unsigned long nr_written = 0;
>> +	int nid;
>> +
>> +	if (!mem_cgroup_zswap_writeback_enabled(memcg))
>> +		return -ENOENT;
>> +
>> +	if (!mem_cgroup_online(memcg))
>> +		return -ENOENT;
>> +
>> +	for_each_node_state(nid, N_NORMAL_MEMORY) {
>> +		bool encountered_page_in_swapcache = false;
>> +		unsigned long nr_to_scan, nr_scanned = 0;
>> +
>> +		/*
>> +		 * Cap by LRU length: bounds rewalks when referenced
>> +		 * entries keep rotating to the tail.
>> +		 */
>> +		nr_to_scan = list_lru_count_one(&zswap_list_lru, nid, memcg);
>> +		if (!nr_to_scan)
>> +			continue;
>> +
>> +		/*
>> +		 * Cap by SCAN_RATIO * remaining budget: bounds scan cost
>> +		 * to the remaining writeback budget.
>> +		 */
>> +		nr_to_scan = min(nr_to_scan,
>> +				 (nr_to_write - nr_written) * ZSWAP_PROACTIVE_WB_SCAN_RATIO);
>> +
>> +		while (nr_scanned < nr_to_scan) {
>> +			unsigned long nr_to_walk = min(ZSWAP_PROACTIVE_WB_BATCH,
>> +						       nr_to_scan - nr_scanned);
>> +
>> +			if (signal_pending(current))
>> +				return nr_written;
>> +
>> +			/*
>> +			 * Account for the committed budget rather than the walker's
>> +			 * actual delta. If the list is emptied concurrently, the
>> +			 * walker visits nothing and nr_scanned would never advance.
>> +			 */
>> +			nr_scanned += nr_to_walk;
>> +
>> +			nr_written += list_lru_walk_one(&zswap_list_lru, nid, memcg,
>> +							&shrink_memcg_cb,
>> +							&encountered_page_in_swapcache,
>> +							&nr_to_walk);
>> +
>> +			if (nr_written >= nr_to_write)
>> +				return nr_written;
>> +			if (encountered_page_in_swapcache)
>> +				break;
>> +
>> +			cond_resched();
>> +		}
>> +	}
>> +
>> +	return nr_written;
>> +}
>> +
>> +int zswap_proactive_writeback(struct mem_cgroup *memcg,
>> +			      unsigned long nr_to_writeback)
>> +{
>> +	struct mem_cgroup *iter_memcg;
>> +	unsigned long nr_written = 0;
>> +	int failures = 0, attempts = 0;
>> +
>> +	if (!memcg)
>> +		return -EINVAL;
>> +	if (!nr_to_writeback)
>> +		return 0;
>> +
>> +	/*
>> +	 * Writeback will be aborted with -EAGAIN if we encounter
>> +	 * the following MAX_RECLAIM_RETRIES times:
>> +	 * - No writeback-candidate memcgs found in a subtree walk.
>> +	 * - A writeback-candidate memcg wrote back zero pages.
>> +	 */
>> +	while (nr_written < nr_to_writeback) {
>> +		unsigned long batch_size;
>> +		long shrunk;
>> +
>> +		if (signal_pending(current))
>> +			return -EINTR;
>> +
>> +		iter_memcg = zswap_mem_cgroup_iter(memcg);
>> +
>> +		if (!iter_memcg) {
>> +			/*
>> +			 * Continue without incrementing failures if we found
>> +			 * candidate memcgs in the last subtree walk.
>> +			 */
>> +			if (!attempts && ++failures == MAX_RECLAIM_RETRIES)
>> +				return -EAGAIN;
>> +			attempts = 0;
>> +			continue;
>> +		}
>> +
>> +		batch_size = min(nr_to_writeback - nr_written,
>> +				 ZSWAP_PROACTIVE_WB_BATCH);
>> +		shrunk = zswap_proactive_shrink_memcg(iter_memcg, batch_size);
>> +		mem_cgroup_put(iter_memcg);
>> +
>> +		/* Writeback-disabled or offline: skip without counting. */
>> +		if (shrunk == -ENOENT)
>> +			continue;
>> +
>> +		++attempts;
>> +		if (shrunk > 0)
>> +			nr_written += shrunk;
>> +		else if (++failures == MAX_RECLAIM_RETRIES)
>> +			return -EAGAIN;
>> +
>> +		cond_resched();
>> +	}
>> +
>> +	return 0;
>> +}
>> +
> 
> There is a lot of copy+paste from shrink_worker() and shrink_memcg()
> here. We really should be able to reuse shrink_memcg().
> 

I will do some consolidation and code reuse in the next version.

> Is the main difference that we are scanning in batches here? I think we
> can have shrink_memcg() do that too. If anything, it might make the
> shrinker more efficient. Over-reclaim is ofc a concern, and especially
> in the zswap_store() path as the overhead can be noticeable. Maybe we
> can parameterize the batch size based on the code path.
> 
> Nhat, what do you think?

Nhat, since we now have the referenced-based second chance algorithm, 
should we consider doing batch writeback for shrink_memcg() as well?

Of course, we could pass a parameter to control whether batch writeback 
is needed, so as to preserve the original behavior of shrink_memcg().

Thanks,
Hao

