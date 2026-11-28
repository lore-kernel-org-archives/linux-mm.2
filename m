Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CEC1606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 01:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XH0k4BS5
Received: by kanga.kvack.org (Postfix)
	id E19E36B05B8; Fri, 27 Nov 2026 20:00:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF0716B05B9; Fri, 27 Nov 2026 20:00:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2DBE6B05BA; Fri, 27 Nov 2026 20:00:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A60236B05B8
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:00:21 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A2DC280590
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 01:00:20 +0000 (UTC)
X-FDA: 85482721800.18.60E3F1C
Received: from mta1.migadu.com (out-31.mta1.migadu.com [95.215.58.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 586BF14000C
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 01:00:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XH0k4BS5;
	spf=pass (imf23.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.31 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795827618;
	b=RoGct/+RL+AGmJSOwkS2iz/c99P2WDWnIK/dk2G0csiEz9Q5tkxP6wDf8lOzvoCcyapkx/
	U3eMvhdcN5W8uPZTqkd/4ZI/tYfrwWz57/yF+/zzdey3G9WG7iM3n4H8JshlON5Mr+0bAR
	sBcaBSc5wTEC9/bzqzfEVbPHN+jr1y0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795827618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mqx3dGzZDtWqr5igOUi74Egvf7mE8f1iQgIUJSdsnkE=;
	b=ydZYQJD4aoaOsAk+3GP+qU9y8orhAJ0UV8ayM9ARs8lA6mSIe6+K4z4BrKe9K+v4duDxLq
	gDpjJ28qbHiHboVYrMB4jEKj4czCpfnlphnPqC/2iB8nIuqy1bTnHjQsZOdHWSJWiznBFf
	Ay77gV6teUv+6jWbHaxcrTbRx1sY18Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XH0k4BS5;
	spf=pass (imf23.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.31 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RKnRcOIcGyS7Q4fYmPPx3vmwgt3xMD+hw2zryeREoW8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795827614; v=1; x=1796432414;
 b=XH0k4BS56q72ELa8Ps5FckyqvAuqzJ7Krc7PUMdFV3zPi5m72OtQTV/x6s2i7DmJ6xGBaddT
 iDbmyDcOfE/YqozMEqZQ1FYLiHjm0Rj3EAMpMJcQ3keyOyrBQTpRsOoGZYohCNEhJ80w76YRybw
 kvwbqlI5U8Dl1CkiAcPKzyP4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b2ab50d9f812f444;
	Sat, 28 Nov 2026 01:00:11 +0000
X-Mizu-Trace-ID: b2ab50d9f812f444
X-Migadu-Flow: FLOW_OUT
Message-ID: <42195463-c50b-4f80-ad2c-ecc106e4c2ae@linux.dev>
Date: Sat, 28 Nov 2026 09:00:03 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] mm/mglru: shorten the lru_lock hold time in
 scan_folios()
To: Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <kasong@tencent.com>, David Hildenbrand <david@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Barry Song <baohua@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 "open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261127060315.1119672-1-ridong.chen@linux.dev>
 <awnYv_mxag0b6Dny@KASONG-MC4>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <awnYv_mxag0b6Dny@KASONG-MC4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 586BF14000C
X-Rspam-User:
X-Stat-Signature: 9nexbkbphieuqeq5d8eexhrs34i5rrgp
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795827618-204566
X-HE-Meta: U2FsdGVkX1+/3z6kB7D1N54SaWlzLBxFJ4P3+LSxet31DsajVD2LgztcK4emJSOSeCd0I+WhJ5np8aZgLE4hice8FVWprXL2p/QTqnnLiE6qAVHDwCKD5mngI4HB2NZr5+0IfE7JlbrO2xrUUy2gi+SZGrun4EM9FuX3PtZBkha63SQjlRZkuoFduTU99oP/NFLbnVr9015d0cmfLTn96sFfYcJRfF5ySAVErpINaEXRhm+oDVll/FkHZOVkO3NnTy68XdCOWkH25oyzbnfZpOm45apjT6BAQwg6KJIHeNfkdMx94aNb2wuvG2vzJ8moOPk4MpbTWD+LFr6g4seoEUJfj/SRK1yXCgGLIz7GFU2QKcxRtFFpXkke6OJJMdTf0enViZJwsKJHL2GoluEXxUzgRGYs5HbeYDVan/LIanTOpkQ7JIaY6GKRQnbX1zJ2FsQGuq9ENVeWFdlXvk3fwGhoNGb63lHLl6V+t4F0J9UhIr6w5AznNb81Zc//DHO7MEBOhIbAmuXAu3NwHee/BUPe808nydPI3XVa7DaMS448RmtiIkO09O0kFLfqHqDJqeiHrikHQYdWLksE5y9HQ6XnR2o7f/zKat6OwLGn8gjXVKuXuDM19f5SjqolSpw4PMgBSYgvOkZxF98jpdfiDvYw4MGDUqFtHMzH1q5KyYDClPnT/uEqHxvVtGmznk5X8HlvG+nnOYmems2V2t8iST3y47HyhTSHehLZjIz5LIK2ORrzGmRfmviOuyyNFCWYSU9qvad5FrcRqZrywg6/fmllbYZMjW202xqvzFUIyS1gmPoipHfpbQeNB/oFqXTl6yfTo/n4gNstNqZcxtJ793iSX1pKDgeV5pRfbQ4oi6TNwmp1NKD/4mfzpkixokaFcNuR2+Il5SXdDwXyqblyD1OxdaUCTMGsRu53kXxBbBq80Pv7TS26oiXMKfCAoIDnF2djsftsagP6ygC/j5o
 CZQMlcEo
 SXFRrE5X6gHhZEvSlJpVvFjdOrX7ykmM79DasqC/70fJ+mctjJfR5Zvpg8Pt3n2MNzNEzDH+18Cu0Lbgd/O7ls4SE5SGEgvjd0044Sj5fKyh6wOKbP4ZJAuhPrUZZEPtmPFg3MwVjBLcmdUj9YGLVICWnxtz0M9HmvJVTDsLkqRoFyGMhBL21pIVItfTBdCKmCLV1WJ6jRTXHrS0R/8CADtbqNA53jaXVW/+4xGLWtGSiMRrLsp/3rHiEIoLDGau8+VAM/h5V1yrzuC/Zb34uVJFyt002icE9LRHO3iFzKpd7B97ro1/F7PhMA7reYjKTJIYIGbreF9bo2yJ7KUemkxMFQ2svaA0J00UuxliSAgee5940lc1cE99h/OfFg0NwsVAdnThiWWe1E1oI49u/HIKxZU7yXrRKvygSQQOngoN6vs0VWVWlZYvPekjtTssJTAoLMoksnuCPXUWJd5kLxAzMbbv5Qtd9PD77G0BPzEs70+l1PaT+wZ8sNMLbSv/Fu9OkhjVNNkbHiGrKjpIa/eaF1r25N5n+0Ee9dRUUnYvDbYHyjr+FDtpmd47z4E2q/Zufsl0R9nYEirCKk9lsLmyxhTs9WofO1tPcsFYBSxq2msXJnXnGm19kHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/28/2026 3:34 AM, Kairui Song wrote:
> On Fri, Nov 27, 2026 at 02:03:13PM +0800, Ridong Chen wrote:
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> When many CPUs reclaim from the same lruvec, they spend most of their
>> time spinning on lru_lock, and the time scan_folios() holds the lock
>> limits reclaim throughput. With 24 threads refaulting file pages in one
>> memcg, about 40% of all cycles went to waiting for lru_lock here.
>>
>> This series takes per-folio work out of that critical section, along
>> the lines of what isolate_lru_folios() already does for the classical
>> LRU:
>>
>> 1. Update the node, memcg and zone LRU sizes once per zone instead of
>>     once per isolated folio.
>>
>> 2. Prefetch the previous folio, so the cache miss on its flags and list
>>     pointers is not taken while holding the lock.
>>
>> Tested on an i7-13700HX (8P+8E, 24 threads), turbo off and the
>> performance governor. 24 files of 128MiB on ext4 on brd, all threads
>> in one memcg with memory.max=1G, random 4K pread(), so nearly every
>> read refaults and every thread ends up in direct reclaim. Reads per
>> second per CPU, mean of 2 runs, with and without each patch in one
>> kernel and the runs interleaved:
>>
>>    CPUs      base    patch 1   patch 2   both
>>       1    426681     -0.4%     -0.2%    +0.3%
>>       2    387442     +0.7%     +1.2%    +1.4%
>>       4    360312     +1.0%     +1.5%    +2.1%
>>       8    314549     +2.5%     +2.5%    +3.3%
>>      12    235058     +3.2%     +4.3%    +5.6%
>>      16    184086     +9.4%     +9.2%   +11.2%
>>      24    124478    +15.5%    +16.5%   +21.6%
>>
>> The gain grows with the number of CPUs reclaiming from one lruvec;
>> with a few CPUs there is little contention and no measurable change.
>>
>> Ridong Chen (2):
>>    mm/mglru: update LRU sizes once per zone when isolating folios
>>    mm/mglru: prefetch the previous folio in scan_folios()
>>
>>   include/linux/mm_inline.h | 26 ++++++++++++++++++++++++--
>>   mm/vmscan.c               | 18 +++++++++++++++---
>>   2 files changed, 39 insertions(+), 5 deletions(-)
> 
> Hi Ridong
> 
> I have a different approach proposed about two years ago:
> 
> https://lore.kernel.org/all/20240123184552.59758-1-ryncsn@gmail.com/
> 
> I hesitated to push that as the end to end gain was not
> that large (5-10%) fio and it makes the code too complex.
> But I think that one may work very well for microbench.
> 
> I tried to resurrect that 2 weeks ago, but realized it's not
> the best time at the moment, there are too many things in flight
> for MGLRU:
> 
> https://github.com/ryncsn/linux/commits/b4/mglru-isolation/
> 
> Perhaps we can discuss and see if using a "batch struct" could
> fit better later? It should also unify the aging batch too.

Hi Kairui,

Thanks for the pointers.

I'm fine with handling the batching together with your batch struct
work later, and happy to fold the nr_taken[] part of patch 1 into it
when the time comes.

Patch 2 (prefetch) is independent of that, though. It is the
one-liner Chris suggested for your v3 1/3, which he said he would ack
if resent on its own [1]; the inc_min_seq() half of it has since been
done by commit 5d3664f070f0 ("mm/mglru: move folios from oldest gen to
second-oldest gen from head to tail"). It is a no-op on archs without
prefetch, the same thing isolate_lru_folios() already does for the
classical LRU, and it gave +16.5% alone with 24 CPUs in my test.

Would you be OK with taking the prefetch patch now, with batching left
for later? I can resend it as a standalone patch.

-- 
Best regards
Ridong


