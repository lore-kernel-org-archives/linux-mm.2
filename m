Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02F6C606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Xgq8tYcW
Received: by kanga.kvack.org (Postfix)
	id 1BF986B062A; Thu, 12 Nov 2026 22:08:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 196FD6B0642; Thu, 12 Nov 2026 22:08:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AD8F6B0653; Thu, 12 Nov 2026 22:08:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D553D6B062A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:08:32 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CF93114019A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:08:30 +0000 (UTC)
X-FDA: 85428612780.15.1434BF3
Received: from mta0.migadu.com (out-231.mta0.migadu.com [91.218.175.231])
	by imf12.hostedemail.com (Postfix) with ESMTP id EA76740004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:08:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Xgq8tYcW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.231 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794539308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xh12Ec73501aJdZldZTaVOfppvQ19TVeVwb3Yqc67Do=;
	b=lo/JPeGl7wV79O+CUq/IA1pf5N3Cx5/3ri0BOnzNwRcngQTR700s0JEvtqemst1vWqVHgG
	vn9dLGffkNlEc0wbY08/zCN0BKuCWoI/vwx4qjfYnm2R4pNCZBACIoFftK2/AHDv2Luewp
	Wd/4g2coGEu27LQMmqhSz8iKdKXuDVo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Xgq8tYcW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.231 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794539308;
	b=gDBfxMU55/WWXyzjo0imjh6mDGzidnqezGBNAeZdWFObaIhsbgFID4MsGGP98FPTzAQKr6
	202604zLLcmyXo0NJLFiK3oA0Uh+/4padFZFC56PhjpYUwFfh387DAqe22ipMv7cJVDsCA
	IslE7AyR9nMm8RScCkkHPy23+FexQCg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=i7wdYt1YR5CVX/6t3vNtMl/JvBAliVHJFFa19DKBkmU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794539306; v=1; x=1795144106;
 b=Xgq8tYcWRueqF4ojil24saUe27PEkfMEboQlmmXHzBbCEFdoMphPGlA7z+KF5LxNoRJ53C4I
 c7c1wCTWWNlU9bZZ/J1beBn6dPSShj3qKON2n9tIWv/bWD/o7GffX/NGF+peDJeNZruMY0E1yXJ
 UfekAJ1ZoVD0ofGejP4IHN7k=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0da06881c7ca0ca3;
	Fri, 13 Nov 2026 03:08:26 +0000
X-Mizu-Trace-ID: 0da06881c7ca0ca3
X-Migadu-Flow: FLOW_OUT
Message-ID: <1c6137c0-297a-4993-b386-6e8a1824d8dc@linux.dev>
Date: Fri, 13 Nov 2026 11:08:12 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (macOS/Intel)
Subject: Re: [PATCH v2] mm/mglru: yield the lru_lock earlier in
 fill/drain_evictable()
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
References: <20261113020132.274013-1-hui.zhu@linux.dev>
 <a72af87a-0f10-4717-9d50-2d3480c32caf@linux.alibaba.com>
Content-Language: en-US
From: Hui Zhu <hui.zhu@linux.dev>
In-Reply-To: <a72af87a-0f10-4717-9d50-2d3480c32caf@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EA76740004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3hyntzf7bjwmwda4mztyqthokksz3i9p
X-HE-Tag: 1794539307-976051
X-HE-Meta: U2FsdGVkX19UL+vL29KE2gwM2RqYKaiC77q7uoeJzIO+BEepB119q80s80xnC/tXjEVFOBRNaEUblmE4tmpepedXeIr1jFZ+9JDfC1m7E+l6r14tbw9KFBY7oZCEDnx0dq2Z5ee7CP59fRucd0OMYNJ0bSmplE4tLLluHYoYUJMY32JSEnt5tEsKyd7pld12V31sUiOABchYzbtXuWOTc4YS2G1qipJ/BrhSvS/ExJL1E/4cu0qiAuU0o6N1jNcAH8me8bqbw/HWfP5NmH/4xHZJqYxGZBkVdKMDWwuB3wWcV9q2Q40Mm8srg4/KRE9Tpm7Eexb4HTmavM7lpn9UkAqIerMt68IIn3UJJYXM1elLNODo+OoIZtRo3qVUHae68AmnZZeVy9qWtP3irEryW/wxCU1hBayuFqYffHiHpBti8X9dwMjO+hDi+9WNPhG/eyWiznvFzWvEY73S7Ym2pjeVnfvZcdk1dpNodPgus2aKSw9DXOkWCw6HvHC8yVWClO8pYDEClMpfgNi07+wihVIwBVc3K8yxr0/vTLLdusUU9DQkD1+dWcHJAKDpwjr7mCmhtQ7XSfDkfZCCMNduVkTFLeanb5HlC85cTwq9FKwM+RnqOrLZuGZ/Uc5xClhzlbtKedadxapWtACE/8ON50aOvdr9aRHj2aO4tlDeTBlOKlfbNKnKsSK9k560r9y4Pkj5oqVaEPw8FUPSDOedJfw1qOHe6G+oJDYwWmBKyBeeijZ8di8e1A2JupBFezHnQW3BzZbOlk52PD9KYJSKDotjiNocyjplP7NOFKDVN5/9D/dCunEj9vfxI/yCF8r6wq9yGpjcFRQNzxSZz+tNesibxRfGheNN+PNbxvZDvMlXb5Xmd5yCWe1UyjrbpV3WxgdtFts+K/G5bYTH+5ZVMQB5oSBD6vVkkiomkkpZ4g2hWjb1uDVC95zmAzHxqI+QtjrnioV1NBVM0BTjCPn
 78VaLojt
 dm+WuDS0ptgmZ+l7Yr0zxAfXYjRULtXKfSGTTe77n2ak9GK7vd9CVQPprxQHaYtBlXU2qFgI+cgkc138UXytFxXM33IBYnrHpaZ5Pkg7F4LWVDxuceMuB1zqvouZ/JTj28KOLXI+67tDxBYSLNg3c2qu8TlEvI/k6tOJ9ebn7bRsv/ve3B4MyfnxNw7VaazzMwOUR1NQ3nm/GpxuTlbLMh4KFfbUSK1nOLkN6a9KeSzIxpBzvcIx6tPiy9tNHLM+X1YEkFQKomTwa8n3uEHOsxxQwzxIPzkUJSz3UF0kBeLeMRxMInvXWDr9Rhg+fMFZXt3qbzpG9wfNjwfRbRZZ5vH4rKR2cNFNzUrYMgZ0T0Eh+V9hF27UWD4+CS2bKGpiEUPex9f1FGtC3QZ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


2026/11/13 10:50, Baolin Wang :
>
>
> On 11/13/26 10:01 AM, Hui Zhu wrote:
>> From: Hui Zhu <zhuhui@kylinos.cn>
>>
>> lru_gen_change_state() migrates folios in batches of up to
>> MAX_LRU_BATCH (4096) folios under lruvec_lock_irq().  A full batch
>> keeps local interrupts off for up to about a millisecond, and CPUs
>> contending for the same lru_lock spin with interrupts disabled for
>> that long.
>>
>> The caller already reschedules between batches, but a batch itself
>> only ends after 4096 folios.  Stop it early when a resched is
>> pending, or when the lock has waiters and the current hold has moved
>> at least MIN_LRU_BATCH folios; the caller restarts where it left off.
>> TIF_NEED_RESCHED can still be set with interrupts off: a remote
>> resched_curr() sets it directly in the target's thread_info. The
>> minimum batch avoids lock bouncing under sustained contention, while
>> a waiter now waits ~15us instead of ~1ms.
>>
>> This follows lru_gen_look_around() in this file, security/keys/gc.c
>> and jbd2_log_do_checkpoint(), and commit 6e9be217a3ce ("mm/mglru:
>> use a smaller batch for reclaim").
>>
>> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
>> ---
>> Changlog:
>> v2:
>> Also yield on lock contention after a minimum batch (Kairui Song).
>>
>>   mm/vmscan.c | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 6a1af9b92349..c1231925159f 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -5533,7 +5533,10 @@ static bool fill_evictable(struct lruvec *lruvec)
>>               success = lru_gen_add_folio(lruvec, folio, !active);
>>               VM_WARN_ON_ONCE(!success);
>>   -            if (!--remaining)
>> +            /* stop early to shorten the irq-off section */
>> +            if (!--remaining || need_resched() ||
>> +                (MAX_LRU_BATCH - remaining >= MIN_LRU_BATCH &&
>> +                 spin_is_contended(&lruvec->lru_lock)))
>>                   return false;
>
> IIUC, Kairui's point[1] is to just drop the 'MAX_LRU_BATCH - remaining 
> >= MIN_LRU_BATCH' condition, no?
>
> if (!--remaining || need_resched() || 
> spin_is_contended(&lruvec->lru_lock))
>
> [1] 
> https://lore.kernel.org/all/CAMgjq7CUMuNSdCXZ7_kDdo9+0BFvPNHuO=mq=ct_Q5YUyyckvQ@mail.gmail.com/ 
>

Not quite.  [1] was about the extra `moved` counter in the version
discussed on the v1 thread; Kairui was fine with the rest.  Since
`remaining` counts down from MAX_LRU_BATCH and one call is exactly one
lock hold, `MAX_LRU_BATCH - remaining` is the number of folios moved
in the current hold, so the condition is just `moved >= MIN_LRU_BATCH`
without the extra variable.

The minimum-batch test itself is a response to Michal's lock bouncing
concern [2].  Without it, under sustained contention the loop could
yield after every single folio: each yield costs an unlock, a requeue
and a restart (microseconds), while one folio move costs a few hundred
nanoseconds, so the migration could slow down by tens of times, with
cgroup_lock and cpus_read_lock held throughout.  With it, each hold
moves at least MIN_LRU_BATCH (64) folios, i.e. does ~15us of work
before it may hand the lock over, while a waiter still waits only
~15us instead of the ~1ms of a full MAX_LRU_BATCH batch.

[2] https://lore.kernel.org/all/avV0IbvSx4iuv0tF@tiehlicka/

Best,
Hui


