Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A7EFC5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 03:08:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19A2E6B008A; Tue, 18 Aug 2026 23:08:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 149E76B008C; Tue, 18 Aug 2026 23:08:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0872F6B0095; Tue, 18 Aug 2026 23:08:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D2DD96B008A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 23:08:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5ED17A03E2
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:08:27 +0000 (UTC)
X-FDA: 85116535854.01.E5A62AA
Received: from mta1.migadu.com (out-216.mta1.migadu.com [95.215.58.216])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3B674100009
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:08:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fFQ4ly0E;
	spf=pass (imf05.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.216 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787108905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1PLqwH+pRc4V/+v0YoUGMSqF0/0UHRZfN4gb6Q8yd6s=;
	b=euRPpk7W7ZpNkaXNeXJGATpHn0NYKpuL5/8bNER6IDtPQes0P2+MwkwzDxEapYvBKUoord
	RHt3Y4apbd8o1WGO13Bjjaz5+gVKVLlgDloX+HAXGYyjePfWBvd71TWnJBz1xjwQ9yQQDV
	fv0bR22GtwSfSXof7SrfFKh4R1+hsMc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fFQ4ly0E;
	spf=pass (imf05.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.216 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787108905;
	b=OsavH/Wyd5SmwSrrd7I2cDGFVAgiPThenOY7YiYVPWrnI+2neKQsiSxd5p7lvZLLdHIMhx
	YCYQtgNCV8Ad4sCxvt8QU4tJqMp5sQpDhBMYCdXuECWwM3DCM3hmAsacHhxLOFrDVB0Cg5
	X1SyGsCRt49WyMGbp3FMYrf9zoV119M=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=R9RPGX4W2sdBcGuw43AbX2HspDw/jr2m/4vM7rUIR8A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787108902; v=1; x=1787713702;
 b=fFQ4ly0EECinPEQPKHFAsHVJHxOXnQrGluH4aOPmgo75c54QJxuVY7VQMteQ4qu8RDiXyAmg
 cbDv06006mJNyXOq4cKZcPEiCzWQ2yFKVQai1Jk7BhHUN1Qja4R8yF8nC4A1Dh6oATf6t6FcdYq
 E8FswRXEwdRyQA8NRBWWeiHw=
X-Envelope-To: linux-mm@kvack.org
Received: from [192.168.111.29] (223.70.160.239)
	by smtp.migadu.com with ESMTPS id 96bebe67628b13f6;
	Wed, 19 Aug 2026 03:08:12 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <56052cbe-463d-4dbd-aa43-11f66232680c@linux.dev>
Date: Wed, 19 Aug 2026 11:08:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/oom_kill: simplify remaining RCU sections with
 scoped_guard(rcu)
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>,
 David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260813092933.562028-1-ye.liu@linux.dev>
 <an2tQ90mloFCU9T0@tiehlicka>
Content-Language: en-US
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <an2tQ90mloFCU9T0@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ze4n3t3gh8ggdoagfdisgfsiaghpfyon
X-Rspamd-Queue-Id: 3B674100009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787108905-341550
X-HE-Meta: U2FsdGVkX1/YnrPWTm+mulcb1mSGbwxAPzMX2zZW0fwb2LbcSa/2WQA9JeCU7oMdceav1Z+IuTxFLg0Z0Qjg7eIXG8oEMMy1UuO67DHN+jaeOTQ2mGoR/0b9788AQfe02HvCrNopkMMzXijnMy63GnIS9v2efaplFb+BVITi1RXejOhD84j7YW3AoFnlpgWlyV3CZsPCRAUnPDHp0X6JiKKXzT6Rfl22wpYj2lytancACU+fXZkWIX+JWSG99a9ccLMBrHkzZxEBGViCRjLaMIQK/xbH9Ar/2cLcGrRjA2vHEjCT0DbgY2fwaI8OdPNbKJVyl7WJtnwT9dJx2MczclQ80iw6UQMuxX8G6ZwuKhFTBcPHsKa7466FBdGG+1PbD400vKRQ0D690FRbFgobH3pym33XuRDRedMOXD5vv67xhx+9U9KOr4XkdZF+yTEP12EZF1UVej4UOu9/hC65G0OlNFpsEgb4fD4snz174c7ry02c2W1qJBlDxJWrRH7NaxajvKc88Y62nmZ3TWKH3z9ZI6onpB2dI8JzHg01QKMn98+uW5hjsaIh32fNJKsWy917oXvdf5hu+mVtRux/UKz/tdBjcJ1oMQ++nWOscT4t/aGV+vvVavL0ibV51ifevtvXjwbhAPoPEXK57PA5ggXgdKRAppd+tGIHJ2yl0mrPjcCgs/WehgEzQwvtB/eWN5qwrOUX9wkMCrx93FWCNjXMksLxGJmTl31feoOP81AUkfPa+r7AOQRtnDS0w63CDg7xEob40SjenKlizW+OsJ+e6hyIaiCEDkjCRz9KEffr1AB/ZlldGyO9rQnScAMbjCmN00Eu8JEbaI5CR6uNHgMhBKbTJ3ElWjJjjbvonNwpPcVeBrUOQ5s1pdgkKXo9Tj9dMsSC2w2XxovZg7wxhnNW5uE+NQCMSELHMtRPsmn0jSh0mTB5zILytcw+9BZOHG/j7zh538t94Jc0iRI
 +XJIGcPB
 Imh8q8KnP+Gow0CEalf1KmEyTzD/Oleo07Y3651u/P/zWFmR0swhhVCX0hx54jD2mBH5uMUePRHWgxKV3zMLh6kQT61DY5PwvtDugIdGqw8oOv3VkgZBm2tJmsmygbqoxVH17InOmlLuLoAZU3zKoaPCn5hJvZVvpQkMPtK6iyYVMBiz69KJBkZ6vJp7AtYp3NztGayDezTjJsnCTkPPtzIf49TUXmuZIDqmEOjlEMvGHfy9d2AXbiLKsX+uk828CKEJqsUuA8+s13T0LIg1dbctqYFYnsrbN0M9gLcc+xw5x78cI6l9svUANnWFUg5LPludx7UgbCBYutrg8n8ZRypVw9cxNn2Sw4cLqF/jyQ0bByiSd1M7cW5TncMrAfn2w7X/deDAnHhS41l+tuTII6I0lyD46LTLpdjS3KI+NyuT4Qr8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/8/13 19:40, Michal Hocko 写道:
> On Thu 13-08-26 17:29:32, Ye Liu wrote:
>> From: Ye Liu <liuye@kylinos.cn>
>>
>> Replace the remaining manual rcu_read_lock()/rcu_read_unlock() pairs
>> in oom_cpuset_eligible(), select_bad_process(), dump_tasks(),
>> task_will_free_mem(), and __oom_kill_process() with scoped_guard(rcu)
>> for consistency and simpler control flow.  scoped_guard(rcu) limits
>> the RCU critical section to the loop body rather than the entire
>> remaining function scope, making the protected region explicit and
>> safer for future changes.
>>
>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> 
> It almost looks like for_each_thread and for_each_process could gain an
> rcu varian that would do the rcu thing internally. Have you considered
> that? I am pretty sure there will be more cases like these.
> 
Adding RCU versions of for_each_thread and for_each_process 
(for_each_thread_rcu and for_each_process_rcu) would be useful. 
I also have some simplified code to go with them. 
I'll send a patchset later. Thanks.

> Anyway
> Acked-by: Michal Hocko <mhocko@suse.com>
> Thanks
> 
>> ---
>> v2:
>>  - Use scoped_guard instead of guard.
>>  - Link：https://lore.kernel.org/all/20260813032634.344946-1-ye.liu@linux.dev/
>>
>>  mm/oom_kill.c | 124 +++++++++++++++++++++++++-------------------------
>>  1 file changed, 62 insertions(+), 62 deletions(-)
>>
>> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
>> index 5f372f6e26fa..0e8982e5be51 100644
>> --- a/mm/oom_kill.c
>> +++ b/mm/oom_kill.c
>> @@ -94,27 +94,27 @@ static bool oom_cpuset_eligible(struct task_struct *start,
>>  	bool ret = false;
>>  	const nodemask_t *mask = oc->nodemask;
>>  
>> -	rcu_read_lock();
>> -	for_each_thread(start, tsk) {
>> -		if (mask) {
>> -			/*
>> -			 * If this is a mempolicy constrained oom, tsk's
>> -			 * cpuset is irrelevant.  Only return true if its
>> -			 * mempolicy intersects current, otherwise it may be
>> -			 * needlessly killed.
>> -			 */
>> -			ret = mempolicy_in_oom_domain(tsk, mask);
>> -		} else {
>> -			/*
>> -			 * This is not a mempolicy constrained oom, so only
>> -			 * check the mems of tsk's cpuset.
>> -			 */
>> -			ret = cpuset_mems_allowed_intersects(current, tsk);
>> +	scoped_guard(rcu) {
>> +		for_each_thread(start, tsk) {
>> +			if (mask) {
>> +				/*
>> +				 * If this is a mempolicy constrained oom, tsk's
>> +				 * cpuset is irrelevant.  Only return true if its
>> +				 * mempolicy intersects current, otherwise it may be
>> +				 * needlessly killed.
>> +				 */
>> +				ret = mempolicy_in_oom_domain(tsk, mask);
>> +			} else {
>> +				/*
>> +				 * This is not a mempolicy constrained oom, so only
>> +				 * check the mems of tsk's cpuset.
>> +				 */
>> +				ret = cpuset_mems_allowed_intersects(current, tsk);
>> +			}
>> +			if (ret)
>> +				break;
>>  		}
>> -		if (ret)
>> -			break;
>>  	}
>> -	rcu_read_unlock();
>>  
>>  	return ret;
>>  }
>> @@ -368,11 +368,11 @@ static void select_bad_process(struct oom_control *oc)
>>  	else {
>>  		struct task_struct *p;
>>  
>> -		rcu_read_lock();
>> -		for_each_process(p)
>> -			if (oom_evaluate_task(p, oc))
>> -				break;
>> -		rcu_read_unlock();
>> +		scoped_guard(rcu) {
>> +			for_each_process(p)
>> +				if (oom_evaluate_task(p, oc))
>> +					break;
>> +		}
>>  	}
>>  }
>>  
>> @@ -430,14 +430,14 @@ static void dump_tasks(struct oom_control *oc)
>>  		struct task_struct *p;
>>  		int i = 0;
>>  
>> -		rcu_read_lock();
>> -		for_each_process(p) {
>> -			/* Avoid potential softlockup warning */
>> -			if ((++i & 1023) == 0)
>> -				touch_softlockup_watchdog();
>> -			dump_task(p, oc);
>> +		scoped_guard(rcu) {
>> +			for_each_process(p) {
>> +				/* Avoid potential softlockup warning */
>> +				if ((++i & 1023) == 0)
>> +					touch_softlockup_watchdog();
>> +				dump_task(p, oc);
>> +			}
>>  		}
>> -		rcu_read_unlock();
>>  	}
>>  }
>>  
>> @@ -894,17 +894,17 @@ static bool task_will_free_mem(struct task_struct *task)
>>  	 * are dying as well to make sure that a) nobody pins its mm and
>>  	 * b) the task is also reapable by the oom reaper.
>>  	 */
>> -	rcu_read_lock();
>> -	for_each_process(p) {
>> -		if (!process_shares_mm(p, mm))
>> -			continue;
>> -		if (same_thread_group(task, p))
>> -			continue;
>> -		ret = __task_will_free_mem(p);
>> -		if (!ret)
>> -			break;
>> +	scoped_guard(rcu) {
>> +		for_each_process(p) {
>> +			if (!process_shares_mm(p, mm))
>> +				continue;
>> +			if (same_thread_group(task, p))
>> +				continue;
>> +			ret = __task_will_free_mem(p);
>> +			if (!ret)
>> +				break;
>> +		}
>>  	}
>> -	rcu_read_unlock();
>>  
>>  	return ret;
>>  }
>> @@ -960,29 +960,29 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
>>  	 * That thread will now get access to memory reserves since it has a
>>  	 * pending fatal signal.
>>  	 */
>> -	rcu_read_lock();
>> -	for_each_process(p) {
>> -		if (!process_shares_mm(p, mm))
>> -			continue;
>> -		if (same_thread_group(p, victim))
>> -			continue;
>> -		if (is_global_init(p)) {
>> -			can_oom_reap = false;
>> -			mm_flags_set(MMF_OOM_SKIP, mm);
>> -			pr_info("oom killer %d (%s) has mm pinned by %d (%s)\n",
>> -					task_pid_nr(victim), victim->comm,
>> -					task_pid_nr(p), p->comm);
>> -			continue;
>> +	scoped_guard(rcu) {
>> +		for_each_process(p) {
>> +			if (!process_shares_mm(p, mm))
>> +				continue;
>> +			if (same_thread_group(p, victim))
>> +				continue;
>> +			if (is_global_init(p)) {
>> +				can_oom_reap = false;
>> +				mm_flags_set(MMF_OOM_SKIP, mm);
>> +				pr_info("oom killer %d (%s) has mm pinned by %d (%s)\n",
>> +						task_pid_nr(victim), victim->comm,
>> +						task_pid_nr(p), p->comm);
>> +				continue;
>> +			}
>> +			/*
>> +			 * No kthread_use_mm() user needs to read from the userspace so
>> +			 * we are ok to reap it.
>> +			 */
>> +			if (unlikely(p->flags & PF_KTHREAD))
>> +				continue;
>> +			do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_TGID);
>>  		}
>> -		/*
>> -		 * No kthread_use_mm() user needs to read from the userspace so
>> -		 * we are ok to reap it.
>> -		 */
>> -		if (unlikely(p->flags & PF_KTHREAD))
>> -			continue;
>> -		do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_TGID);
>>  	}
>> -	rcu_read_unlock();
>>  
>>  	if (can_oom_reap)
>>  		queue_oom_reaper(victim);
>> -- 
>> 2.25.1
> 

-- 
Thanks,
Ye Liu


