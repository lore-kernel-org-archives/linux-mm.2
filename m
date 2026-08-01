Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BC7FC5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 00:31:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D49F86B0088; Fri, 31 Jul 2026 20:31:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFBCF6B008A; Fri, 31 Jul 2026 20:31:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE9FF6B008C; Fri, 31 Jul 2026 20:31:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81CDC6B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:31:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 55130801D1
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 00:31:22 +0000 (UTC)
X-FDA: 85050821604.14.85F87DC
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id 82777A000B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 00:31:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WSSV9ceQ;
	spf=pass (imf15.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785544280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=huQxdldpqRYaZEjHQZL7Ohp7YA7LATCZJOhI6k3svOo=;
	b=nsJ3byLOOP1nVGxv3m9KhZiBwaHufYPyrl2w+qwiV06HYIJqoJFdRkN+hHfkvy0iLrtv3B
	p53FcW6pNYt/ZwRQlSCNMZ9JnLG5SuEAfy7UHkhXf+AJLiyEa8MkWXhzWpB+CxQF+OhfLf
	KaiY8aDsVXS0t/3Yu/MZFh0xFo/mzRI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785544280;
	b=1796dvkZtcRqGDuLdE6SzbuBOwTLFb1nO5xwoe0ZQACCY15/E10gwhLBrcXF4gEgsSjNaL
	VSPRLe1IbLY6sN8PHazHLatfdyTIA4/WFp1eX9GXsvN0Wk1la1mYOA56yJ9HePH92rAMBN
	qCL7zS+7giUVU/G4M0rM3mToGEEKpZ0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WSSV9ceQ;
	spf=pass (imf15.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-848479c9bd5so1392056b3a.3
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785544279; x=1786149079; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=huQxdldpqRYaZEjHQZL7Ohp7YA7LATCZJOhI6k3svOo=;
        b=WSSV9ceQuoDNNu8mvPBUAP4yuIrtgDoEZVqqhJ5a94AlEjIROpdMenKdj7y3iFJpkS
         d3ULK15xVU1XRFucsP2rG8hSVK0qeXGw+Yf/ohtTo7GfkqRViYDgSZOuGRKenQBPqDN+
         xy0Dx1nNGZYGTGSeNNEI9AX9cGWvZALEYNVmEblEd8Chh02FT1R/388Ohw9xhWm0f+Zh
         qrM5bnrXZixon4nAhtDfe/N98thUecJ6MqATdofetF3IhY9Im+IGfjmk56s+6lW7CACx
         hAc43qSENTnwMOTuxpd+s0wZj+VgQqWHn4GRvqFOHhQPT1keXyCMP8M1D8kie9ppuSMp
         jF8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785544279; x=1786149079;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=huQxdldpqRYaZEjHQZL7Ohp7YA7LATCZJOhI6k3svOo=;
        b=m0VMm87P6dsON3j2sQizY1iXw+KiBFG45EmOwEeRknUqH/kfs/IoxOTOeQLiqAg/7J
         5jG1Vv7cvLF78w5Yflb+jxSPZn2M9g4i8ivjFZiH9gRNlUopgUhmXz1FGUb+xKhy6YQR
         j3PYL/xuuK6BIY3JcIbpTUxaeM42alE326HbYDxC4amY74FrBmUm0ilnbeqGj+K/K3Hn
         PsKMPv5VxtTosGOEXQA2ua5qKOBg4rWJWnHiv6UlhrBPnrr9QDYC/PLzyaMhJKkGb0N9
         h3zLbUQ1Sg9j1YcWgDlnGubRMgvQvqW/+jJgW1EtjOc2xOwgrKbmuZVur/zRkpEawl/p
         sxlQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrn3lNxGkFhym1kM1x8nnUVtC7ctvsSYlYgzHikVVw4eQA2RRSqznPynfWOgOTt3J45s8yT26Y6ww==@kvack.org
X-Gm-Message-State: AOJu0Yxjg47v8xdZwJCXpPihbcTOX4TAVXgqt7x0yWzEVU4sHNciRbcB
	qaswevRIzVv8WN9vsneXi/zPAocDQFMbTMOHRwzAhHhmG4cZek756Drp
X-Gm-Gg: AR+sD137SPQ+lAuyUodkOnw77S1MKKlWK1VkJBH1E9SNzVQ8nuCa8x+jzhALcDzZC6I
	kst4UEXj+nfHo/PJffA0kp/8tOwvAVi1p45vOaRcEbomas9zVt4DXMCqJZRTdyqvJX+uyC4IBFQ
	876XlNZAYGWfDTlu/J6jMJPLkIR18/yhcL5VzpsB1fxmz4r+Fg/DmQ6KyHEgLCD2WXmset2bDFm
	F6qTMc3XZMbBfY51Tq+RBBztk9hno+m0Mnu+PA8m1duI++8C+HlHQft090RM1ZbRogQcg4+pBiY
	V50qa/s8Gw90yWdldO4HAz71PlhGDQqSiaNR0x8bFn3IkEul65sS4R89cqQOJosnmD3j5XoqqKk
	cvrzQsBysBEn8X8dJlx3m7AlXBZxjpuqaebYIFDQtQ/6sZaPCU6wnY/ajPLxr5oPO5L2DrprKPG
	dVsHmy6skjLI+w2nG+hL5v3TujoAL0eJeklwnJCAY0OKEADZwK8a2SMjwJcfCbZ9YX90xzaL/Li
	8f6trW051sUY3hLpiXGuVS6pbg3Wk2CWHpP+/Ww77DjBcycm4OkDhgFYrE=
X-Received: by 2002:a05:6a00:4392:b0:84e:216d:7e4e with SMTP id d2e1a72fcca58-84ee479b03amr1357914b3a.1.1785544279161;
        Fri, 31 Jul 2026 17:31:19 -0700 (PDT)
Received: from ?IPV6:2409:8a28:62b:7644:8009:eff3:7a31:a025? ([2409:8a28:62b:7644:8009:eff3:7a31:a025])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84edc4237e5sm1030113b3a.59.2026.07.31.17.31.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 17:31:18 -0700 (PDT)
Message-ID: <6e16a760-d84d-98e1-433e-3233a9dd2236@gmail.com>
Date: Sat, 1 Aug 2026 08:31:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v3 2/2] mm/zswap: Support batch writeback in
 shrink_memcg()
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev, jiahao1@lixiang.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mhocko@kernel.org, mkoutny@suse.com, muchun.song@linux.dev,
 nphamcs@gmail.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 stable@vger.kernel.org, tj@kernel.org, yosry@kernel.org
References: <amufiuAaZbuDdKkQ@cmpxchg.org>
 <20260731071900.38942-1-jiahao.kernel@gmail.com>
 <amy8gAN33W4QsM5R@cmpxchg.org>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <amy8gAN33W4QsM5R@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 82777A000B
X-Stat-Signature: ttuoid3bo8ss3xz8hxsdg5u6efm71ajy
X-Rspam-User: 
X-HE-Tag: 1785544280-508034
X-HE-Meta: U2FsdGVkX19ojnOQhe27CSapJKTfnNI176t5eX1A/Sh5WZUrf61/SvLi8NJLQA0UmcyPoDqytILUrGxceiC0l19EVYn5rbPLXiAHCubJM2WkGtxrdlx4CN+ky/AiwluBUtm+6+d5zCaVhxEFLTQ+fntLVJrXar2tl8DnHX5fwFwSyfUnCNcNCPhNYL9TyDEu+h2wmG+pVnOnVe3zOtN9V/7ZY1j9/xWxN4pmQwKseUeC7G7v79bRLAGLoHSOeXW20KdmKw6nvQtgXaytn70qpyMeomhV4gqVBoPlLQj/tgdQpX6VaTzET4qA6ioHzGy9Aofc5acYpdvVNjdkoeT660KR7Gs7cZfVu5VV3O5KG2q4Pn+t6qM3XCgMdGBE3yjQET1/eRk9QrPy+t1TPfCEAz1RgB3SVF5/aMOfhqoaztLesHRGTLdOMeNhV+OSljBfhjZSJ43ZP1eF98V0dbXWS0ngkBZFVwXZJcZFntvfVBD0brGd5DqsD2DTgmJnCaNZ2gtTM+wTxzmpNgjThFMj8Lob/tNBrzb2y5Kp4mQHFWmnXmfyYmed0B2XOIJgP6L7dHW5M33scgz5rPUPtuYai8+m06I6SDhyqGaNKIThbldDvsNQ83AM+AuYFTkwaeyEFOIgfBlMoYSC/abmqJIDdK2xxEpaFX8WNDJt8MdE4QUu/XDeS9F0em3yU68GEPtkK1xAW3MiL9edRsVfjoqEjtBT71cJjJU3bTWTTY5WWSsQbU7lV/XxZJ1EcJ5zgpqIOH+29C9xHaMa/7bRB6GV62G6BwAQpwZpWqSIyMDpZTyhZSig3nOwd1Lc8M6yEn11ypx7eBIQzW5t1kHp7bSVzNaMiqWiDeNV+hpl+ZDKDHpB9aciLgWBeMXqs8J/SAJFk2IGBrsyDE0opcvaMrVI/w+vkwIhKGqhw9qh36GOkjbvnDNFfilH5t69Hx+Tl8TVkoRCueE2v5K8apHk1Ep
 XV0EQkuU
 IG4sOdAyzFFuAUhoxRuHeHZJF5TobjcV81XA5NcoSbUrrEDmlj1JraRciwKXb+QqzAXQBDhG/YfSue6WtCuL0nJDJP2ty3JS+wzFIIWt9WeYwqJl9vw+ez1sJhwjyzCpm/BotWyryJ0nYo+9qYhSgi8PsbkK1/M7mQYUPwpoHraZZuksWwephDyLZIrB1foMrR5a/oVxZxF3r6jRRu2kzVZJcIwPMKHECHRVw67gu5sC0JeytNt+t9ahqnvz7V3BcWDA03V+BKM7N+ffzEqnOAu7l6jCyENl58eQMdNVLc48c4N7430jd5C+UQNpguH7R1qKK24lyRfmwMCWTU3teWmUB5vVtmzmWZFGKX/5JVH4K/Hfz+SGp0L3w91+1M4/XlUmCaB+WTqxEk7inF9nuAtvQy81OggzZhQY5pMCgRf4m2Np96Ix44md2N+xIXd5lWv/T1dQJjbT3MzHs47X0ViFuWWlWmZ+eW55UnHW04IH1+Rxt/2qdZXjiaznQZNxCV0+0z6Wkpz4x3fJFrN14E1xb20EoswgLvz/BBxVbmKp19MPgLuPGBtHG3Zs5jhox4bJ/1vxzcQfBgG0upU0/9VKcqSb+4jPyrK06
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/31 23:17, Johannes Weiner wrote:
> On Fri, Jul 31, 2026 at 03:19:00PM +0800, Hao Jia wrote:
>> From: Hao Jia <jiahao1@lixiang.com>
>>
>> Currently, shrink_memcg() writes back at most one entry per-node during
>> its traversal. This makes shrink_worker() inefficient, as it must
>> repeatedly re-enter shrink_memcg() to make any substantial progress.
>> Under high memory pressure, this can cause the writeback speed to be
>> too slow to keep up with refaults, leading to zswap store failures and
>> forcing pages to skip zswap and go directly to disk, which results in
>> an LRU inversion.
>>
>> To address this, extend shrink_memcg() and rewrite its LRU iteration logic,
>> enabling batch writeback for both the shrink_worker() and zswap_store() paths.
>> To prevent shrink unfairness across NUMA nodes caused by a shared global scan
>> quota, limit scanning to up to SWAP_CLUSTER_MAX pages per node and write back
>> any reclaimable entries found.
>>
>> Test Setup:
>> - Total memory: 32 GB, 1 NUMA node.
>> - zswap settings: accept_threshold_percent=50, shrinker_enabled=N.
>>
>> Test Case 1:
>> Set max_pool_percent=1, allocate 512MB of anonymous pages, and fill them
>> with random data (to avoid compression). Then, use cgroup memory.reclaim
>> to force a large amount of anonymous pages into zswap. At an interval of
>> 2ms, allocate a 4K anonymous page where the first 4 bytes are random numbers
>> and the rest are zeros, and then trigger reclamation of this 4K page through
>> cgroup memory.reclaim. When the pool threshold is reached, shrink_memcg()
>> will be triggered.
>> The test data after running for 120s is as follows:
>>                                  Baseline      Patched
>> shrink_worker wakeups              5,363          169
>> shrink_memcg calls            11,373,201      350,703
>> written_back pages                40,212       40,241
>> zswap_store calls                161,190      163,753
>>     store succeeded (ret=1)       102,743      117,183
>>     store rejected (ret=0)         58,447       46,570
>>     store reject rate                ~36%        ~28%
>> pool_limit_hit delta              55,826       33,760
>> pswpout                           98,659       86,811
>> pswpin                                 2            0
>>
>> Test Case 2:
>> We evaluated the following two sub-configurations using stress-ng inside
>> a cgroup capped at memory.max=1G for 120 seconds:
>>    Test Case 2a (max_pool_percent=1): Continuously triggers the global
>>    zswap pool limit, thereby waking up shrink_worker() to perform asynchronous
>>    shrinking.
>>    Test Case 2b (zswap.max=320M, max_pool_percent=50): Continuously triggers
>>    the cgroup's zswap.max limit, thereby invoking synchronous shrinking.
>> Command executed for both setups:
>>     bash -c 'echo $$ > /sys/fs/cgroup/zswaptest/cgroup.procs ; \
>>     exec stress-ng --vm 4 --vm-bytes 4G --vm-keep --vm-method rand-set -t \
>> 120s -q'
>>
>> Test Case 2a (max_pool_percent=1):
>>                                  Baseline       Patched
>> shrink_worker wakeups              5,640         1,308
>> shrink_memcg calls             8,481,500     3,140,972
>> written_back pages                   260       468,216
>> zswap_store calls              2,742,756     2,011,269
>>     store succeeded (ret=1)       934,640       947,988
>>     store rejected (ret=0)      1,808,116     1,063,281
>>     store reject rate                ~66%          ~52%
>> pool_limit_hit delta           1,181,310       196,882
>> pswpout                        1,808,376     1,531,497
>> pswpin                         4,288,497     3,635,365
>> Test Case 2b (zswap.max=320M, max_pool_percent=50):
>>                                  Baseline       Patched
>> shrink_worker wakeups                 0              0
>> shrink_memcg calls              687,608         54,002
>> written_back pages              639,176        846,663
>> zswap_store calls             1,224,222      1,228,548
>>     store succeeded (ret=1)      992,816      1,208,123
>>     store rejected (ret=0)       231,431         20,425
>>     store reject rate               ~19%            ~2%
>> pool_limit_hit delta                  0              0
>> pswpout                         870,745        867,360
>> pswpin                        1,707,823      1,216,814
>>
>> Under identical workloads and runtimes, batched zswap shrinking
>> exhibits a significant reduction in both shrink_worker() wakeups
>> and shrink_memcg() calls. Furthermore, the sharp drop in both pswpin
>> and zswap_store() rejections demonstrates that batching zswap shrink
>> operations effectively mitigates zswap_store() failures caused by
>> hitting the pool limit. This significantly prevents pages from bypassing
>> zswap and falling back directly to disk, thereby reducing LRU inversion.
>>
>> Suggested-by: Yosry Ahmed <yosry@kernel.org>
>> Acked-by: Yosry Ahmed <yosry@kernel.org>
>> Acked-by: Nhat Pham <nphamcs@gmail.com>
>> Signed-off-by: Hao Jia <jiahao1@lixiang.com>
>> ---
>>   mm/zswap.c | 30 ++++++++++++++++++++++++++++--
>>   1 file changed, 28 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/zswap.c b/mm/zswap.c
>> index 48fc7b575e24..d406c14925d8 100644
>> --- a/mm/zswap.c
>> +++ b/mm/zswap.c
>> @@ -1275,6 +1275,21 @@ static struct shrinker *zswap_alloc_shrinker(void)
>>   	return shrinker;
>>   }
>>   
>> +/*
>> + * Scan up to SWAP_CLUSTER_MAX pages on each per-node zswap LRU of @memcg
>> + * and write back the reclaimable ones.
>> + *
>> + * Since the second-chance algorithm rotates referenced entries to the
>> + * LRU tail, the per-node scan is capped at the current LRU length so
>> + * each entry is scanned at most once per call. It is up to the caller
>> + * to handle retries, deciding whether to scan another memcg to complete
>> + * the full iteration, or to rescan the current memcg to drain its zswap
>> + * entries.
>> + *
>> + * Return: 0 if at least one entry was written back, -EAGAIN if entries
>> + * were scanned but none could be written back, or -ENOENT if @memcg has
>> + * writeback disabled, is a zombie cgroup, or has empty zswap LRUs.
>> + */
>>   static int shrink_memcg(struct mem_cgroup *memcg)
>>   {
>>   	int nid, shrunk = 0, scanned = 0;
>> @@ -1290,13 +1305,24 @@ static int shrink_memcg(struct mem_cgroup *memcg)
>>   		return -ENOENT;
>>   
>>   	for_each_node_state(nid, N_NORMAL_MEMORY) {
>> -		unsigned long nr_to_walk = 1;
>> +		unsigned long nr_to_walk, node_budget;
>> +
>> +		/*
>> +		 * Cap the scan at the per-node LRU length so each entry is
>> +		 * scanned at most once per call.
>> +		 */
>> +		node_budget = min(SWAP_CLUSTER_MAX,
>> +			     list_lru_count_one(&zswap_list_lru, nid, memcg));
> 
> AFAICS you can just do unsigned long nr_to_walk = SWAP_CLUSTER_MAX.
> 
> __list_lru_walk_one() does a list_for_each_safe() that will exit the
> same way whether you hit !nr_to_walk or run out of items.

Wouldn't it be better to ensure that each entry is scanned at most once 
per call, particularly when list_lru_count_one(nid) < SWAP_CLUSTER_MAX?

On one hand, this avoids scanning the same entry multiple times within a 
single pass. Since the second-chance algorithm rotates referenced 
entries to the tail of the LRU, entries on nodes with a large number of 
zswap entries require at least two shrink_memcg() calls to be written 
back, whereas entries on nodes with fewer entries might get written back 
in a single shrink_memcg() call instead. On the other hand, we also 
avoid spinning repeatedly on entries that fail writeback.

Thanks,
Hao

> 
>> +		if (!node_budget)
>> +			continue;
>>   
>> +		nr_to_walk = node_budget;
>>   		shrunk += list_lru_walk_one(&zswap_list_lru, nid, memcg,
>>   					    &shrink_memcg_cb, NULL, &nr_to_walk);
>> -		scanned += 1 - nr_to_walk;
>> +		scanned += node_budget - nr_to_walk;
> 
> scanned += SWAP_CLUSTER_MAX - nr_to_walk;

