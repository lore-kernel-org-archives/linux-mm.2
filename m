Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94DD7CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 06:41:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA1518E0003; Fri,  7 Nov 2025 01:41:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2B0E8E0002; Fri,  7 Nov 2025 01:41:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B411C8E0003; Fri,  7 Nov 2025 01:41:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A3C4C8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 01:41:35 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 36A3F588EA
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 06:41:35 +0000 (UTC)
X-FDA: 84082864950.25.9589CFC
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf10.hostedemail.com (Postfix) with ESMTP id AB007C0005
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 06:41:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RxGX48Cm;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762497693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xRWYTILqG8LMnvyFfHYVWRrcjOpnBFKXzOGTUrz8/2Y=;
	b=sbeniZeq6BTpa1P6TJVQdJej+9xCpR1SbCRe2tN/BJCpJjteh5mT+MPJswZad02vS25Wci
	YaFS3SKc00mIUINnoYVBB58pHq4kryThgCQBcprwpeHU+CpxaABwla2xV+cHKgd1rBNf9y
	Qap9uMWbtUqyaZM8QeabJz0ZgNbQ+1Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RxGX48Cm;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762497693; a=rsa-sha256;
	cv=none;
	b=F/FM5doKXkQV/UQ0FBK68zkNot2p2TSiJ3onYcZRHOHhC8IwJKvTEelveIuPwzuLORjw8D
	6/Np495SONHuUOgvR1YwTn2PTlrofHnTGz7K8YB5ze8lYuoHuRpVdoQ1kA+cVp/abUVmM3
	KKHa/2bDdJDLWF3Kvgy2yTlBKSZ1+4M=
Message-ID: <366385a3-ed0e-440b-a08b-9cf14165ee8f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762497687;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xRWYTILqG8LMnvyFfHYVWRrcjOpnBFKXzOGTUrz8/2Y=;
	b=RxGX48Cmlw64YK5Ash4JRiXe2KJcl8QsfvG5d0NVo2Whq/SC69I/M24gsIFV+OyovHivHT
	fTnAopzzhAy5DrElU2jfYVcKVMstboD4H8pUwQmskXdksEHwaodJwlSKF0dLe8EisvS2Ee
	ZMiH38qPA510qUuKZEL+BJcBoOGrICI=
Date: Fri, 7 Nov 2025 14:41:13 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 04/26] mm: vmscan: refactor move_folios_to_lru()
To: Harry Yoo <harry.yoo@oracle.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 linux-rt-devel@lists.linux.dev
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <97ea4728568459f501ddcab6c378c29064630bb9.1761658310.git.zhengqi.arch@bytedance.com>
 <aQ1_f_6KPRZknUGS@harry>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aQ1_f_6KPRZknUGS@harry>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AB007C0005
X-Stat-Signature: in7hqofah66p6nw8c7gocoecjai5kso6
X-Rspam-User: 
X-HE-Tag: 1762497691-792852
X-HE-Meta: U2FsdGVkX1+5Szp7wp2oHcH4u7rIHc1ArPY1mBeQk3eKglNsCcYsUnpxjBX9pWfmX9VwxcwNHWBfHdbYo7GnIfr0DXHoWlq1p7Uwa0/VYRg0csxbvj0B1fF+NoxFpvAzXS2RulCE3LAU+TmNrjDwT3b1qWooGfrO3udrfmG8Y2egTr8jUafx/4749+V446OatMAYS+4ZbmtXPbzH2zTFTFEiVV0GCQqCmzOZ6I3JE6BOfhF8VUNXbrg6OwsB5B5zAQrMZsm0GqmL8DTCEuip9SOm6/MuY4JP8t9U3Nlu9LprsfgxaUpzodefu0C7ma2lEWSENu0en64ZN7loLf2+Yop+leJ4OZ1YzXIr3yyix5lvgKnymdiHrksa22Hb4OQyZRofMEHClh7/wlU093SXM3xqp2FF5IikcJtE2VFZ465yWsv4pzK3jtw4MyOqho5/NS/Lu8ezWxc41WzLTDycUBKpYzVlzNV7jjykBZXEofNe/3pJ8nuOsUoxmUf091snY3au9Vf5GHUPfgZUhabvRuCPxtVJhXB8s/pKz08Q/v/IpEFqT3ShnqDVTtvkw+e3J9DedUmlISUleYr5lnrCTdNiG09vJ8EZqFH27z0diidxfrLxPNhtF8d4fs+D+vvBIn8IswOB6xGBgvPzqUMcOi4xxTgOOq3LOxTYwodAqfq1eHEfh4Y3tlXNeoi3e2mjqVDJKb5PkHBBSMzjPthbzp75kKGnGx3062sblTMAj5XeHK4rzieLuguO8KBbOs4pvzy1bKy+nJ1vKr02ZSqBv8QtYrLcXMxU4xs/uDoyvsveIj5PW6O+JqajTdwZW/Tx2JVd8JUkfy9z1UEGA6gB6dqmiL6H8lY6071irQJuENIgQ2iyREDLymHows+dqHmoxlC8DCnoyHWknyC2lXJioRB7MFeZrYstgTmXIajpcxIbBdihnfgMoB3SGicUzE8tI1fTnwLVkHmAsPmtNF6
 xx81RuRz
 yAFf99oNo14Xv8VJllsdLtnz1iBaTKiN11rKZGhDl+TLTDpHX+cqfSNkPq/CDl60ZEYkmML3TKl98uLl3PaGgqG6Abcf0rNoWrLFoJJQbYaezRgfebWbr4cg/o6Q8oex8kYnL1pE3UguMRcjQjvluak6j2fU3iCYc82M1dsRgtugpQ100KjniIGUUtlyqNNmGnfCITw2nx1vsf2HJ4CrkfsfpQSul0uEjMlaEOEENMae5SRrpZQAz90stMHh6mmXMJaOpH68y5yS20NOKDclVKyuOMr4Q/WKgKgbLq49wOxhYqr0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry,

On 11/7/25 1:11 PM, Harry Yoo wrote:
> On Tue, Oct 28, 2025 at 09:58:17PM +0800, Qi Zheng wrote:
>> From: Muchun Song <songmuchun@bytedance.com>
>>
>> In a subsequent patch, we'll reparent the LRU folios. The folios that are
>> moved to the appropriate LRU list can undergo reparenting during the
>> move_folios_to_lru() process. Hence, it's incorrect for the caller to hold
>> a lruvec lock. Instead, we should utilize the more general interface of
>> folio_lruvec_relock_irq() to obtain the correct lruvec lock.
>>
>> This patch involves only code refactoring and doesn't introduce any
>> functional changes.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   mm/vmscan.c | 46 +++++++++++++++++++++++-----------------------
>>   1 file changed, 23 insertions(+), 23 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 3a1044ce30f1e..660cd40cfddd4 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -2016,9 +2016,9 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>>   	nr_reclaimed = shrink_folio_list(&folio_list, pgdat, sc, &stat, false,
>>   					 lruvec_memcg(lruvec));
>>   
>> -	spin_lock_irq(&lruvec->lru_lock);
>> -	move_folios_to_lru(lruvec, &folio_list);
>> +	move_folios_to_lru(&folio_list);
>>   
>> +	spin_lock_irq(&lruvec->lru_lock);
>>   	__mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
>>   					stat.nr_demoted);
> 
> Maybe I'm missing something or just confused for now, but let me ask...
> 
> How do we make sure the lruvec (and the mem_cgroup containing the
> lruvec) did not disappear (due to offlining) after move_folios_to_lru()?

We obtained lruvec through the following method:

memcg = mem_cgroup_iter(target_memcg, NULL, partial);
do {
     struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);

     shrink_lruvec(lruvec, sc);
     --> shrink_inactive_list
} while ((memcg = mem_cgroup_iter(target_memcg, memcg, partial)));

The mem_cgroup_iter() will hold the refcount of this memcg, so IIUC,
the memcg will not disappear at this time.

> 
>>   	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
>> @@ -2166,11 +2166,10 @@ static void shrink_active_list(unsigned long nr_to_scan,
>>   	/*
>>   	 * Move folios back to the lru list.
>>   	 */
>> -	spin_lock_irq(&lruvec->lru_lock);
>> -
>> -	nr_activate = move_folios_to_lru(lruvec, &l_active);
>> -	nr_deactivate = move_folios_to_lru(lruvec, &l_inactive);
>> +	nr_activate = move_folios_to_lru(&l_active);
>> +	nr_deactivate = move_folios_to_lru(&l_inactive);
>>   
>> +	spin_lock_irq(&lruvec->lru_lock);
>>   	__count_vm_events(PGDEACTIVATE, nr_deactivate);
>>   	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
>>   
>> @@ -4735,14 +4734,15 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>   			set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_active));
>>   	}
>>   
>> -	spin_lock_irq(&lruvec->lru_lock);
>> -
>> -	move_folios_to_lru(lruvec, &list);
>> +	move_folios_to_lru(&list);
>>   
>> +	local_irq_disable();
>>   	walk = current->reclaim_state->mm_walk;
>>   	if (walk && walk->batched) {
>>   		walk->lruvec = lruvec;
>> +		spin_lock(&lruvec->lru_lock);
>>   		reset_batch_size(walk);
>> +		spin_unlock(&lruvec->lru_lock);
>>   	}
> 
> Cc'ing RT folks as they may not want to disable IRQ on PREEMPT_RT.
> 
> IIRC there has been some effort in MM to reduce the scope of
> IRQ-disabled section in MM when PREEMPT_RT config was added to the
> mainline. spin_lock_irq() doesn't disable IRQ on PREEMPT_RT.

Thanks for this information.

> 
> Also, this will break RT according to Documentation/locking/locktypes.rst:
>> The changes in spinlock_t and rwlock_t semantics on PREEMPT_RT kernels
>> have a few implications. For example, on a non-PREEMPT_RT kernel
>> the following code sequence works as expected:
>>
>> local_irq_disable();
>> spin_lock(&lock);
>>
>> and is fully equivalent to:
>>
>> spin_lock_irq(&lock);
>> Same applies to rwlock_t and the _irqsave() suffix variants.
>>
>> On PREEMPT_RT kernel this code sequence breaks because RT-mutex requires
>> a fully preemptible context. Instead, use spin_lock_irq() or
>> spin_lock_irqsave() and their unlock counterparts.
>>
>> In cases where the interrupt disabling and locking must remain separate,
>> PREEMPT_RT offers a local_lock mechanism. Acquiring the local_lock pins
>> the task to a CPU, allowing things like per-CPU interrupt disabled locks
>> to be acquired. However, this approach should be used only where absolutely
>> necessary.

But how do we determine if it's necessary?

Thanks,
Qi

> 


