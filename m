Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E0FE606A32E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=V7EuX4Ny
Received: by kanga.kvack.org (Postfix)
	id D23E66B0663; Thu, 12 Nov 2026 22:22:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAE056B0664; Thu, 12 Nov 2026 22:22:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9F6B6B0665; Thu, 12 Nov 2026 22:22:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 97F5C6B0663
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:22:36 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9659BA014A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:22:35 +0000 (UTC)
X-FDA: 85428648270.18.522DB41
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf01.hostedemail.com (Postfix) with ESMTP id 82EEB40006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:22:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=V7EuX4Ny;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794540153;
	b=i0k/sxpKCmi4I+jQVTpkK+WMqEW92SFJf+8IpH6tF/uZbzw8fS2RLWvNFmzxdNRGY2DNWM
	3fz41cAhmbid3eExh2I9B096dLqrl2MqvHJG380sHokLoQx30lMOKXXV9ENvmSeFsE/XMZ
	2bvzQQ26CnMhYdVUeRDZI9ixrgD2c/s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794540153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aKPg/C+iEjXAyA26yNMVbAy4RFLh/YULbk2Iqfm+Dhw=;
	b=hfMf5xXalitKdAaxezYXdgYg19BrEFMoDUgu4ZQ09/oVLnRbgIe9VMsN/lEGwHRCO1howi
	dCb1jelpAJucDqALRwsej7OJz201jRhRFX73X5THEOX+GtrNQUpyivYHp+iA+ghRcc7iTv
	Nah7pNB1XR3Ip+Y31P6U/nPuahgv2Rk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=V7EuX4Ny;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794540149; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=aKPg/C+iEjXAyA26yNMVbAy4RFLh/YULbk2Iqfm+Dhw=;
	b=V7EuX4NyVki8rWtz3DZkz0FnltMeff9N87p2nCNi2n0kcfPtOM8HvQo2i3JB7KiETZsE/GwdEAIUZlvR4G58uhXsDN0HkOZYd1ySftL6CWTIE5bnRFJjPSmIzNmqxNgkgWMTRtJJjdGdo3LC7oFnoUvuV29qR5OtJ2a9FvT5uT8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XEdjdNz_1794540146;
Received: from 30.74.144.124(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEdjdNz_1794540146 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 13 Nov 2026 11:22:27 +0800
Message-ID: <920ed3c0-42ee-4268-b8ac-45981645ae4b@linux.alibaba.com>
Date: Fri, 13 Nov 2026 11:22:25 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/mglru: yield the lru_lock earlier in
 fill/drain_evictable()
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
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
 <1c6137c0-297a-4993-b386-6e8a1824d8dc@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <1c6137c0-297a-4993-b386-6e8a1824d8dc@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 82EEB40006
X-Rspamd-Server: rspam12
X-Stat-Signature: auz6jpzangmngtudit8569hskmewg4cz
X-Rspam-User:
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794540152-564876
X-HE-Meta: U2FsdGVkX1/Z99/fh/HS+suJmnBSgs1iSrxpmUSPlGGkf5lKl9kk5AuvRrOs598MLIyjRVUymGgwEJUd66gBcu3EIawksgLHvwUKW4Wbd3hJwqWt+g7AGdqs5cHeHp1ZNqju6vJTPMMzzsetiWQZoU439GmsOBV+70c2i34iT2Wfwm4/lI+IPlr5MC/I5RDBp3KfnWrwPjGsP3FzMIyDNoW+eqJwJGcQ6ZkSsqCbH6DoRbvmG/NlWkr24uiYMzR+wCx6nDSX8gj/4qt2EysSUs07E+V39Xmg17DG5y5QeJya2OrNOtADFxLjWZ3oVglC1o8Uk5J14yFMyBYeq8U5SlShbSUnNzZ4z0bhIeDHQeX6U26UgsvF65sWdKzrm5wJhI+1LcBvEsKLAxvnzkqiLLspevcjarb6MPRSVvjKenZChEPGwaQF5a1Zn1NYsOJBHqfD0fmqTRxwfhZQSYgqiE4189Xz1voW+oYo5bF1/VL/MUeuqjDykXskmhUAj5N3hESV+rG5fbDWdBDNyXNu7s4xMK41wn6fxZuWMzfe88RQuMPFCtMfp5DT2J3dQ6j9XI8Xk15/5ngFH0uqOKHre3EzkaiJtgNhoB72qXcvodmzZ3AXcrLsfO1SdQ5ve4NnWerWx7tldQVIb4WHO8vGQZ3jo+f8xlE8LDJym4EH3KHw59LZbplUsT6x3uC/ZbL3kes96VxO9eNKja5vah/OnM99sv9N+5/TJBzZiNb2wBllWo4ONMb2M4uE9/BThXTqKpZ4eJzMOSsqAiOwEnCiw7hknyFwX+aGRUaohiywpfkrJltwXN7ZkXXx7V2/n+A3goELvi3YEqQeA3BSwS13Le0KAmSDTBJSvpMFuFQUfdD7mSsgGOy4okHi6AmpyKW3GwN3CdNy0DHZZXS64VINNbPg4uWSRKHEt1SxSFtkLt3unPOCF0ZgWqWgzNG0t6nGtlKlNX28hamIRUUhRPa
 RzinlAAh
 OnDxI9zaJaR0M44H9wwKyCldMQI5AH3B0S3IC2Knt6Seg71ZCsOdggjNwx4UkrIUTuptl8m6IStVY2Oekted3wp8J9r5PTWW+paMkuYXaudIIIAnfU0FFKkU4bv7navCe9ZiHvnAac+uW9YqwWoUnEGyyc4qUSOdWM/epNW2W4KUKDTnyezZRt7isgDReusWxeF4qbye3gw3xiI9Upf8F8dZOSd3wXw8fU00JLByIXDUoMzzRs3cjIskSJxP/Hk75Iq4Mh54HoRLMqb7xLcIMmjy0tjTHd8REtLUCvDB0WYulHWeiqdTEo11p2iDI5pfLQPLl0FfR9ZY3GZU75+KYOQ/Qd+7dCeVm3BdWNvAyO/9UBSSNoIc52LPIIrkjE0Ok4sG+ZYGXW3YgIZqqpC3rgUDE8/awLEJ2znWq5Q2pR5piNFRDuNIaYaQIwklrURZ2kSbKl9uMjnvJKJpGCx7nrUWlbV6K2v3wq36L9ZbCSo9ZxFRbFF82CGPiseiemmDGVwy/YWNZaQfv9ej0WuRFbOsWBjFY+N3dOzPVBkxFupyWVNB4TLV+kA1YFrDbajLcy09C8BKltZglMUA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/13/26 11:08 AM, Hui Zhu wrote:
> 
> 2026/11/13 10:50, Baolin Wang :
>>
>>
>> On 11/13/26 10:01 AM, Hui Zhu wrote:
>>> From: Hui Zhu <zhuhui@kylinos.cn>
>>>
>>> lru_gen_change_state() migrates folios in batches of up to
>>> MAX_LRU_BATCH (4096) folios under lruvec_lock_irq().  A full batch
>>> keeps local interrupts off for up to about a millisecond, and CPUs
>>> contending for the same lru_lock spin with interrupts disabled for
>>> that long.
>>>
>>> The caller already reschedules between batches, but a batch itself
>>> only ends after 4096 folios.  Stop it early when a resched is
>>> pending, or when the lock has waiters and the current hold has moved
>>> at least MIN_LRU_BATCH folios; the caller restarts where it left off.
>>> TIF_NEED_RESCHED can still be set with interrupts off: a remote
>>> resched_curr() sets it directly in the target's thread_info. The
>>> minimum batch avoids lock bouncing under sustained contention, while
>>> a waiter now waits ~15us instead of ~1ms.
>>>
>>> This follows lru_gen_look_around() in this file, security/keys/gc.c
>>> and jbd2_log_do_checkpoint(), and commit 6e9be217a3ce ("mm/mglru:
>>> use a smaller batch for reclaim").
>>>
>>> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
>>> ---
>>> Changlog:
>>> v2:
>>> Also yield on lock contention after a minimum batch (Kairui Song).
>>>
>>>   mm/vmscan.c | 10 ++++++++--
>>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index 6a1af9b92349..c1231925159f 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -5533,7 +5533,10 @@ static bool fill_evictable(struct lruvec *lruvec)
>>>               success = lru_gen_add_folio(lruvec, folio, !active);
>>>               VM_WARN_ON_ONCE(!success);
>>>   -            if (!--remaining)
>>> +            /* stop early to shorten the irq-off section */
>>> +            if (!--remaining || need_resched() ||
>>> +                (MAX_LRU_BATCH - remaining >= MIN_LRU_BATCH &&
>>> +                 spin_is_contended(&lruvec->lru_lock)))
>>>                   return false;
>>
>> IIUC, Kairui's point[1] is to just drop the 'MAX_LRU_BATCH - remaining 
>> >= MIN_LRU_BATCH' condition, no?
>>
>> if (!--remaining || need_resched() || spin_is_contended(&lruvec- 
>> >lru_lock))
>>
>> [1] https://lore.kernel.org/all/ 
>> CAMgjq7CUMuNSdCXZ7_kDdo9+0BFvPNHuO=mq=ct_Q5YUyyckvQ@mail.gmail.com/
> 
> Not quite.  [1] was about the extra `moved` counter in the version
> discussed on the v1 thread; Kairui was fine with the rest.  Since
> `remaining` counts down from MAX_LRU_BATCH and one call is exactly one
> lock hold, `MAX_LRU_BATCH - remaining` is the number of folios moved
> in the current hold, so the condition is just `moved >= MIN_LRU_BATCH`
> without the extra variable.

If so, why not just set:

int remaining = MIN_LRU_BATCH;
?

> The minimum-batch test itself is a response to Michal's lock bouncing
> concern [2].  Without it, under sustained contention the loop could
> yield after every single folio: each yield costs an unlock, a requeue
> and a restart (microseconds), while one folio move costs a few hundred
> nanoseconds, so the migration could slow down by tens of times, with
> cgroup_lock and cpus_read_lock held throughout.  With it, each hold
> moves at least MIN_LRU_BATCH (64) folios, i.e. does ~15us of work
> before it may hand the lock over, while a waiter still waits only
> ~15us instead of the ~1ms of a full MAX_LRU_BATCH batch.

fill_evictable()/drain_evictable() are really cold paths, I really don't 
see any practical impact from this. At least we (Alibaba) won't be 
dynamically switching MGLRU state in practice.

