Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D2E3C55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 06:21:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38FD76B007B; Wed,  5 Aug 2026 02:21:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 342846B0088; Wed,  5 Aug 2026 02:21:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 230156B008A; Wed,  5 Aug 2026 02:21:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED3896B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:21:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7DB7616037A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:21:37 +0000 (UTC)
X-FDA: 85066219434.07.70A0D76
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf20.hostedemail.com (Postfix) with ESMTP id B14571C0011
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:21:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nXVcw3FI;
	spf=pass (imf20.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785910895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=90dET2o+stuXHdvr17MtJ609siDKgo9CQdU/QNgsB1k=;
	b=l2Z6gifgdmM3tFgIw/4bOY4wRKCdpTezoXhteU5OqDd8Kkkpv4Cttjg6ku82JLcwE+mPLL
	O8kNUfzsy9irv8WN+OXlwrY5P58Jx7mS+o7vrk6TjfcRZ0Nun8jIrNWD5366Z37+in8SUo
	0tVpnIoTqNlVwGcLwCM0gDiZ8a1vHsY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nXVcw3FI;
	spf=pass (imf20.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785910895;
	b=u542SPCNVC3fx99uSn/x+tkXvR7q0wBaN40vEnxsjlQ/PcxGos9dXj+C5z3eqGJwHVzcnc
	+1YFN+3JZgxinJYn0FW0qrcc07GiR02n7U+v+JktvvM6UAjXZWfoARyiDlpw/tcRfX0vzZ
	c0Q1FgiMv2zT2l0CyHmotFqdQxc7Pm4=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-84862b0d5f8so559236b3a.3
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 23:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785910894; x=1786515694; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:references:cc:to
         :from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=90dET2o+stuXHdvr17MtJ609siDKgo9CQdU/QNgsB1k=;
        b=nXVcw3FIxV5YyqhH4EohCvDVepUEZme82xSVBkpFslzDuoPGldyYLHfGxQHTuH4qZd
         kskd1tK1RMmmBzkqc5BgH7LPATldQq9HtMYCY9xWb/ydF10aBsiQl7ZL+MOaKCeE47gM
         bdwrYyEAlB08yDAVoTHHRpKzqE20hnrnb/djTfi1nuF7XUDlIyUm9ODYoNQQuURD8R9X
         /LpnH3cOJEeId9OQyI6Jn4DtZrjL9zkhD2maKzpCAT3F8ryDpM3zUxLk4qds3fQ0jPY3
         orRTMRhXFy2TGi/Sa6KspXYzzWrHlWp0j6OdDQ3TuhkoQ0tUPDEHaFz5QkAIA5mNieOv
         HsvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785910894; x=1786515694;
        h=content-transfer-encoding:content-type:in-reply-to:references:cc:to
         :from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=90dET2o+stuXHdvr17MtJ609siDKgo9CQdU/QNgsB1k=;
        b=J2LJpgALt5DcX+tSZ6cpm9BARGOpgFGBNlo0noetg0d+cY0etmehTw+TVh5rFj0fS4
         TmeNYdDH7fPDKdFGxoyFIq99a+YqrOD7+PZSi5IahGejg9LjClSdBLTyPjqx0WWwfRyT
         bmFX8ECpfVdioFB8XULGR3oCDI43oUfYPo06ZIuIr6JkhE5gOFmAlu/r1RVJRnsywzw3
         mxXUkoPMIqTuz/ll3b2DMCDT4/WbxiCF4L3Z4gO8xVALVL70GYcnsnzTMTjEsKnHcRmm
         v++DRCy8EjlUl8qTuSNxFyvdnKn/6nM8OvQvp53KeuhC7BSmQchpS3M3LdbyBUyCLcyD
         z/Vw==
X-Forwarded-Encrypted: i=1; AHgh+RpXoMSLA01VqmT6BEoJafTTpoKROePtVQCAy/Y3J6kJ6kScHASvc/jP7CDtbGPz/Y36XGsGTeBLTw==@kvack.org
X-Gm-Message-State: AOJu0Yyf+RXwwyzmfg5fxreJ6fCz0iJgjNHw+JaL5raePNdoEi3LJx4q
	SMmpWsAm4Ph1riTHSeF8ZuTdxdJt5fzMmtt+q+oE/n7C+Bnl/sQLg1Rg
X-Gm-Gg: AR+sD13E/+rIBVJ9YpO8xWEyhUbufUjwkFd54h1lF5gXTAnIrqf9f29TQ7y1k9djzPm
	YNwCGiozLE1FjN3ABOgmXLONqWsOxFTtXn8y5zAjgI1j2NhWdBaZNVj/gumMGxv4bRJK+tQ9XVq
	F6yBLfUVgZGI+CRAbe3y9xWj7ZUAGSbBH33RQVmaA9iS4CXBq/MMza2QtmTbwjd36cHcqLb+NMo
	2DvL3ilrewhOiL5qRmcWF5kRcqjzRSQl4cn3rhlhMys4iJmC5lmaZLLTlc3u1Mkd5zGQZIhR0US
	yWa/iLGkslOB9GDOi3xIt38X1W25gxuXJApjLMqMlryr+8oTftpUQ1zjkJum/zonOJQ7Gw44peB
	dpsd398XDIrhN4lxjaX88iswSnRiGKTFHGJ0JYFCGSMOTA77Ghtr67v2l/twM8Ceqxo8NDrvSXe
	fcv9gKKyX722hwZLFXLwVpIFNXhA9P7fjttLkNlLUDesibtDH/wzGdYMtAOcp6qz19INxaKcVvl
	o6TYlA+
X-Received: by 2002:a05:6a00:3a1f:b0:847:8dec:1427 with SMTP id d2e1a72fcca58-84f2dfc340bmr4646658b3a.8.1785910894366;
        Tue, 04 Aug 2026 23:21:34 -0700 (PDT)
Received: from [10.125.192.43] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f2e5139casm464939b3a.44.2026.08.04.23.21.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 23:21:33 -0700 (PDT)
Message-ID: <94d74382-2e2c-8f8e-35e6-1ecafdcc445f@gmail.com>
Date: Wed, 5 Aug 2026 14:21:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v3 2/2] mm/zswap: Support batch writeback in
 shrink_memcg()
From: Hao Jia <jiahao.kernel@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>, yosry@kernel.org, nphamcs@gmail.com
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev, jiahao1@lixiang.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mhocko@kernel.org, mkoutny@suse.com, muchun.song@linux.dev,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, stable@vger.kernel.org,
 tj@kernel.org
References: <amufiuAaZbuDdKkQ@cmpxchg.org>
 <20260731071900.38942-1-jiahao.kernel@gmail.com>
 <amy8gAN33W4QsM5R@cmpxchg.org>
 <6e16a760-d84d-98e1-433e-3233a9dd2236@gmail.com>
In-Reply-To: <6e16a760-d84d-98e1-433e-3233a9dd2236@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B14571C0011
X-Stat-Signature: ywddbh48zgj1ujwj9wdzd8u1eojd7kmy
X-HE-Tag: 1785910895-410918
X-HE-Meta: U2FsdGVkX19c5r8JyqaCEdHPprtpdDJZKez30pheZne3VHiOqWSYq0sFzSslUTxxxXCgLJep5JcsLvuaFlJi4kUIVZ3xNbsaMvaKOtg9T7rFAcNHp4WRV8NzYt815GsEOBmF8SwUkdfgcs4kfG7u9gIPrmdeFNusmVktPJ4KwmGQ7C1i0u/hNXresLqIh7nLn7ueIuuwH9VZDpiET8jcBlR/zVNBvk6apAmZTwJKLTmZ6ouP/5NLWunJMpgYLV1UV6CpwiSq6190k004E8yfsme9RYHyIND2ZWcsjoQ5hUPsxqAhABdtL+GbS/Yt3IazwD7L4qIwhizExxS5rdBJhTb++sz45ynO8ppaDQ6fkfwxLqEfNNIJTQFsQsFvF3e9DMhoYf4yAMTh83YAsXGf+UHKqoblHmbRsJ66NqfDEoBT04PO5NWfzoq6h4J2quKWkrSGi2MTJQ3OZwEy9dHg1TFkE7Oy7lv31uM0z31TowtPrvKung0bWNsXbgDeYUnSqhM1meajwZYH2bIY+yeVdd5slRFLCGsBRjSyPmf+lo2TNJKkNZpk8jynH4MMc+4FFY9T4BdIw79EhXeTw4iUpptEMX6CCLmh8+k/AcD+Nm+SXW6NOkYEmgoeBe9Xk5adfAt1M52zrYW0HTbTnRxrKsUyeWVMJOk/pjcOGpQZfXQzgy71H08PmZQvErIW+9Z06Gdv6JOC3vUpGSr/zEKatyto1hKdiPhJZmZTM7+g+uKBmgY25b6VaJXv9M3OAN8tMZmq+z8OsiR75oXR/EWPcdxWayRQM1pMl+xqhgbiz+Uf/SuHSxsmlZcVynncfRHEaUehHBv+svieQ15B+7mS1AGqu46oy/ARuv71wUMN94VCNub6N4cnfsNuto7Xa6/xHM+54i1vlS+D0MNxO5fzicZf0j5HqHQq/u+fNugw5DhAUXIX1G4K4qnCvnpij0u0kkHbQaqRrMu959a0dSd
 reQLdRvr
 EhRNpqmTySSgv0u4f2ssr6IQKcUpS45qLvZcdwGoZggokn5kX390csWAijS1dk6gDFhdOsU9wN25zwBI2ScU917y3SwuEm2OPa4CLk3z1F4Pa0jh0p8ZQa+B3N3Cc39QxwPNfnTCkx1KW5JqgJs2Pdogr1FW6hAH3IeV5pwGvtoGPJZ0NVQH1suEbrmyNF6DxU33w6yt4f/dTAhJkFNqiWI2li5ChItcRtKVH3vo8ztwfKPbYTb4uLXByKrkq6+J2AA1Wc7pq6vo8p+v14nZir+r8QKJ1qo3SL0YPLLLyF0O8PSxtYRRMeONDyLo7XnpYJtm7SpOV7aisrSNGMMqoAdJZ9/Bq1Xtoei/dABal7zfNY0UZVm/9MUEKZdFrIgChPZ9aSMvfheag47NdO8D+b7fJNmalXNpmZaiA6NgdbO2DEEoxYgeZPLEDz7ZwPbuoNM+lYhqXyR/JlTxIYf+wt380S537bz4JvviVgeE2bfelEK/luPYBlUXcq/xTDyheiSYIWKSqwzYbBnVRlQzZ+kIG8YQptdU3goHqmeEp26nH/d2Z71aTF2Kv38OAlea+3Vh6oNVlxbF4X9xrmLwBd+uO6sTA1EFZ5ndMpmWz2+GGghE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/8/1 08:31, Hao Jia wrote:
> 
> 
> On 2026/7/31 23:17, Johannes Weiner wrote:
>> On Fri, Jul 31, 2026 at 03:19:00PM +0800, Hao Jia wrote:
>>> From: Hao Jia <jiahao1@lixiang.com>
>>>
>>> Currently, shrink_memcg() writes back at most one entry per-node during
>>> its traversal. This makes shrink_worker() inefficient, as it must
>>> repeatedly re-enter shrink_memcg() to make any substantial progress.
>>> Under high memory pressure, this can cause the writeback speed to be
>>> too slow to keep up with refaults, leading to zswap store failures and
>>> forcing pages to skip zswap and go directly to disk, which results in
>>> an LRU inversion.
>>>
>>> To address this, extend shrink_memcg() and rewrite its LRU iteration 
>>> logic,
>>> enabling batch writeback for both the shrink_worker() and 
>>> zswap_store() paths.
>>> To prevent shrink unfairness across NUMA nodes caused by a shared 
>>> global scan
>>> quota, limit scanning to up to SWAP_CLUSTER_MAX pages per node and 
>>> write back
>>> any reclaimable entries found.
>>>
>>> Test Setup:
>>> - Total memory: 32 GB, 1 NUMA node.
>>> - zswap settings: accept_threshold_percent=50, shrinker_enabled=N.
>>>
>>> Test Case 1:
>>> Set max_pool_percent=1, allocate 512MB of anonymous pages, and fill them
>>> with random data (to avoid compression). Then, use cgroup memory.reclaim
>>> to force a large amount of anonymous pages into zswap. At an interval of
>>> 2ms, allocate a 4K anonymous page where the first 4 bytes are random 
>>> numbers
>>> and the rest are zeros, and then trigger reclamation of this 4K page 
>>> through
>>> cgroup memory.reclaim. When the pool threshold is reached, 
>>> shrink_memcg()
>>> will be triggered.
>>> The test data after running for 120s is as follows:
>>>                                  Baseline      Patched
>>> shrink_worker wakeups              5,363          169
>>> shrink_memcg calls            11,373,201      350,703
>>> written_back pages                40,212       40,241
>>> zswap_store calls                161,190      163,753
>>>     store succeeded (ret=1)       102,743      117,183
>>>     store rejected (ret=0)         58,447       46,570
>>>     store reject rate                ~36%        ~28%
>>> pool_limit_hit delta              55,826       33,760
>>> pswpout                           98,659       86,811
>>> pswpin                                 2            0
>>>
>>> Test Case 2:
>>> We evaluated the following two sub-configurations using stress-ng inside
>>> a cgroup capped at memory.max=1G for 120 seconds:
>>>    Test Case 2a (max_pool_percent=1): Continuously triggers the global
>>>    zswap pool limit, thereby waking up shrink_worker() to perform 
>>> asynchronous
>>>    shrinking.
>>>    Test Case 2b (zswap.max=320M, max_pool_percent=50): Continuously 
>>> triggers
>>>    the cgroup's zswap.max limit, thereby invoking synchronous shrinking.
>>> Command executed for both setups:
>>>     bash -c 'echo $$ > /sys/fs/cgroup/zswaptest/cgroup.procs ; \
>>>     exec stress-ng --vm 4 --vm-bytes 4G --vm-keep --vm-method 
>>> rand-set -t \
>>> 120s -q'
>>>
>>> Test Case 2a (max_pool_percent=1):
>>>                                  Baseline       Patched
>>> shrink_worker wakeups              5,640         1,308
>>> shrink_memcg calls             8,481,500     3,140,972
>>> written_back pages                   260       468,216
>>> zswap_store calls              2,742,756     2,011,269
>>>     store succeeded (ret=1)       934,640       947,988
>>>     store rejected (ret=0)      1,808,116     1,063,281
>>>     store reject rate                ~66%          ~52%
>>> pool_limit_hit delta           1,181,310       196,882
>>> pswpout                        1,808,376     1,531,497
>>> pswpin                         4,288,497     3,635,365
>>> Test Case 2b (zswap.max=320M, max_pool_percent=50):
>>>                                  Baseline       Patched
>>> shrink_worker wakeups                 0              0
>>> shrink_memcg calls              687,608         54,002
>>> written_back pages              639,176        846,663
>>> zswap_store calls             1,224,222      1,228,548
>>>     store succeeded (ret=1)      992,816      1,208,123
>>>     store rejected (ret=0)       231,431         20,425
>>>     store reject rate               ~19%            ~2%
>>> pool_limit_hit delta                  0              0
>>> pswpout                         870,745        867,360
>>> pswpin                        1,707,823      1,216,814
>>>
>>> Under identical workloads and runtimes, batched zswap shrinking
>>> exhibits a significant reduction in both shrink_worker() wakeups
>>> and shrink_memcg() calls. Furthermore, the sharp drop in both pswpin
>>> and zswap_store() rejections demonstrates that batching zswap shrink
>>> operations effectively mitigates zswap_store() failures caused by
>>> hitting the pool limit. This significantly prevents pages from bypassing
>>> zswap and falling back directly to disk, thereby reducing LRU inversion.
>>>
>>> Suggested-by: Yosry Ahmed <yosry@kernel.org>
>>> Acked-by: Yosry Ahmed <yosry@kernel.org>
>>> Acked-by: Nhat Pham <nphamcs@gmail.com>
>>> Signed-off-by: Hao Jia <jiahao1@lixiang.com>
>>> ---
>>>   mm/zswap.c | 30 ++++++++++++++++++++++++++++--
>>>   1 file changed, 28 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/zswap.c b/mm/zswap.c
>>> index 48fc7b575e24..d406c14925d8 100644
>>> --- a/mm/zswap.c
>>> +++ b/mm/zswap.c
>>> @@ -1275,6 +1275,21 @@ static struct shrinker 
>>> *zswap_alloc_shrinker(void)
>>>       return shrinker;
>>>   }
>>> +/*
>>> + * Scan up to SWAP_CLUSTER_MAX pages on each per-node zswap LRU of 
>>> @memcg
>>> + * and write back the reclaimable ones.
>>> + *
>>> + * Since the second-chance algorithm rotates referenced entries to the
>>> + * LRU tail, the per-node scan is capped at the current LRU length so
>>> + * each entry is scanned at most once per call. It is up to the caller
>>> + * to handle retries, deciding whether to scan another memcg to 
>>> complete
>>> + * the full iteration, or to rescan the current memcg to drain its 
>>> zswap
>>> + * entries.
>>> + *
>>> + * Return: 0 if at least one entry was written back, -EAGAIN if entries
>>> + * were scanned but none could be written back, or -ENOENT if @memcg 
>>> has
>>> + * writeback disabled, is a zombie cgroup, or has empty zswap LRUs.
>>> + */
>>>   static int shrink_memcg(struct mem_cgroup *memcg)
>>>   {
>>>       int nid, shrunk = 0, scanned = 0;
>>> @@ -1290,13 +1305,24 @@ static int shrink_memcg(struct mem_cgroup 
>>> *memcg)
>>>           return -ENOENT;
>>>       for_each_node_state(nid, N_NORMAL_MEMORY) {
>>> -        unsigned long nr_to_walk = 1;
>>> +        unsigned long nr_to_walk, node_budget;
>>> +
>>> +        /*
>>> +         * Cap the scan at the per-node LRU length so each entry is
>>> +         * scanned at most once per call.
>>> +         */
>>> +        node_budget = min(SWAP_CLUSTER_MAX,
>>> +                 list_lru_count_one(&zswap_list_lru, nid, memcg));
>>
>> AFAICS you can just do unsigned long nr_to_walk = SWAP_CLUSTER_MAX.
>>
>> __list_lru_walk_one() does a list_for_each_safe() that will exit the
>> same way whether you hit !nr_to_walk or run out of items.
> 
> Wouldn't it be better to ensure that each entry is scanned at most once 
> per call, particularly when list_lru_count_one(nid) < SWAP_CLUSTER_MAX?
> 
> On one hand, this avoids scanning the same entry multiple times within a 
> single pass. Since the second-chance algorithm rotates referenced 
> entries to the tail of the LRU, entries on nodes with a large number of 
> zswap entries require at least two shrink_memcg() calls to be written 
> back, whereas entries on nodes with fewer entries might get written back 
> in a single shrink_memcg() call instead. On the other hand, we also 
> avoid spinning repeatedly on entries that fail writeback.
> 
> Thanks,
> Hao
> 

Johannes, Yosry, Nhats, any thoughts on this?

>>
>>> +        if (!node_budget)
>>> +            continue;
>>> +        nr_to_walk = node_budget;
>>>           shrunk += list_lru_walk_one(&zswap_list_lru, nid, memcg,
>>>                           &shrink_memcg_cb, NULL, &nr_to_walk);
>>> -        scanned += 1 - nr_to_walk;
>>> +        scanned += node_budget - nr_to_walk;
>>
>> scanned += SWAP_CLUSTER_MAX - nr_to_walk;

