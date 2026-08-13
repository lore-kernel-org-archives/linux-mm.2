Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B230C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:51:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBCDF6B0464; Thu, 13 Aug 2026 05:51:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6D716B0465; Thu, 13 Aug 2026 05:51:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAD986B0466; Thu, 13 Aug 2026 05:51:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A508D6B0464
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:51:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 17EA5405A3
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:51:41 +0000 (UTC)
X-FDA: 85095779202.06.A173114
Received: from mta1.migadu.com (out-166.mta1.migadu.com [95.215.58.166])
	by imf14.hostedemail.com (Postfix) with ESMTP id 07E8B100008
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:51:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lSBuLdhP;
	spf=pass (imf14.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.166 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786614699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NEGOaQxjuPQ+kTArNBfyYbtFtUuQWnXuyW3dSComQQ4=;
	b=n8ClcylsB/hnVCEmYVYC193v1Fa0jCdCWt5mPHhUaKr/qSHjoyA6CVaoqZbhu2vlRIXp6W
	/tAhoiiMFE6uFPlcI8KZOWLj9fI0eQZN3Rexi5S6qn4wNXCqPDcgxfKSoQzwPim0s9r9ab
	kSw+Gez3nHmc8D/q8QpH8VCU/vvo+xQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lSBuLdhP;
	spf=pass (imf14.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.166 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786614699;
	b=fJk+MBQ0cmwrMPpmVJwes0H4qqr7tK3plLAItCvqDAnZmny28S4Y/OKxdomS81u52aUwu+
	MP3RUSqu3Xq6ktFll+PHA0owb/FTfC4Uvjxz6RmuGYIu9GgWcU5CTv/hHWdaF/ogOGFwV2
	soCvZ7HDtX/PgHteoWCuCdjneC+U45E=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=8rC0bQOD3kg50nWnBkgYGoITLbGcqBiHy42iACXOCI8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786614693; v=1; x=1787219493;
 b=lSBuLdhPrkOVEtkaJ0vTyiGt0C9Zyd0elw+o1UUC4J+kFgYAPU+MlNgYUkhj64A0CtnSYi5E
 LzDFefO/gvZeWYf5bB4WhQFFbiDIbGxDSF6c521+0YEsqJuV5jkStWrpl7SN84JMrSRbKA29JB8
 c+91ofvgKUSyZ7wY0gmVIiTY=
X-Envelope-To: linux-mm@kvack.org
Received: from [192.168.111.29] (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 433ca169b7a1f501;
	Thu, 13 Aug 2026 09:51:33 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <ce245833-025b-497a-8a73-9862d033d48a@linux.dev>
Date: Thu, 13 Aug 2026 17:51:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/oom_kill: simplify remaining RCU sections with
 guard(rcu)
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>,
 David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260813032634.344946-1-ye.liu@linux.dev>
 <an2FHDjYy2IFEKsr@tiehlicka>
Content-Language: en-US
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <an2FHDjYy2IFEKsr@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 07E8B100008
X-Stat-Signature: t7n9nwxmsha4s1h8mccsm8zn7wyx3ib8
X-Rspam-User: 
X-HE-Tag: 1786614695-783553
X-HE-Meta: U2FsdGVkX1/idUGeWKUqmkXEoeEzC5y0iFJM4PQNn5W5EXaDgekBeBWmmRB3+N4ham9an9HXIYbw2xyHo8NosIlwoitSTeoI+woYPSOzpn/iWrSC/ozPWCn823neO0G0miVxrNlwRdsImj+2IMhnVAtwg4+wL8mNXQOmelAlsCKgdx7U1KA/Lq9fHdA84uHjkv9ez+RiejSpNuryRSWHp/y6Gc+KO4NiqWwO5cWSUGdITisaqhKncYbf3hbdsJcaKuzUhITopNUwk4ZMSm/cAN6Ktmk7G5QDEydTugyLfYswxluBExP+Rz2rn043BeB/6rTeE2WAnuDKenbNnBPc6JiuBjujLLe2wha4sLcyjjTJdrORi6sbXY+euYIoFFY11RjybHcAOsqQ0GLWli9MsJerk4hiEO+CBU+F1fewoZ8e6qoATU0vl9IMIjYQnhDc3bmg69x4DYz/BTTDzdP6+Rxeb3ZJWPF2vF1NeJrXpnTaVB8/KoFscyeLfWFkVm+zt9nuos+qxh6pz27sV1v31GgL1lb3iGSFLvAoLHkhC0ZSRyBaKoyh3GB8kDqALSWKjBgHJB9hT2ssBiu70lSZXr4KFp6ivJG1ks93YisuDzHI9orFAP5gOSW2Ay8PN34JnDO/RKf6+3mmHloz7vuAMJ9lj2BZ36h0wVqhDnxPBkNyxdALCcBXgZlNTUlhK3u3WiQYakCy2FOyRuNKRkQjOrBO1leotxSGnQ5U3ZBRcjKjohWG7ainCXj+D4krBjL05Vb8Sa57wW1cI5+NnXSZ/BsZGHs3skpDSp8JpNVZ0y4RAcePFv7JgoLbPLHjMnCG1SuTiDDA81oPDxXMYcHn2pVTeOzhaKjU2BlajuQkBMdF0gqKggpXPJ0AhZsWdx7Y9HDpqCxxliEr/n7MgPA1aPcwY6xwDK+rM5Pktwr9wmo8U3UzgLEhonREiUbvQk1t14M6QvHTqQnuqEed6LX
 fFRwgp1g
 175EgyPjX/Ik3ehUAqZxWWDL930e/oi1f7dCfoO8C6MGrKPvm+UC3NzXn9GG2Q0B6QzqaGXSxd/ZS7r4dbyqYMZUxWRveINh5A474x3sCIvOZ6Ncm+BZYpldEGMMX46V8pstvwbdRSeaGVini6GtTHPYuvUtl/huZZ56+VapIk7GXWVLYOHd0Xe9FlMCq73+pD7sgFa+tVtLp+HlyMU/pn+ASTvuVV3bnZo8Z2lvGf5cs00hkEKoddzrnucrK7+ohw4YaGEUcLgv0AgkcL6Q2qmAYOeN96PK7QOb9pDd+AkckjkwoyFZuQ2Ln3lkVP+N1tHyK6Tcwej6BS9goGBpax4f2tSDJYMAqEQgE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/8/13 16:49, Michal Hocko 写道:
> On Thu 13-08-26 11:26:33, Ye Liu wrote:
>> From: Ye Liu <liuye@kylinos.cn>
>>
>> Replace the remaining manual rcu_read_lock()/rcu_read_unlock() pairs
>> in oom_cpuset_eligible(), select_bad_process(), dump_tasks(),
>> task_will_free_mem(), and __oom_kill_process() with guard(rcu)() for
>> consistency and simpler control flow.
> 
> Could you use scoped_guard instead? While all these functions do not
> perform anything pas the for loop this might change in the future and I
> find it more obvious what the actual scope for the RCU is rather than
> the full function one.
>>
Thanks for the suggestion, I've updated to V2.
>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>> ---
>>  mm/oom_kill.c | 15 +++++----------
>>  1 file changed, 5 insertions(+), 10 deletions(-)
>>
>> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
>> index 4b5c70aaece4..8bbb5ca00bb6 100644
>> --- a/mm/oom_kill.c
>> +++ b/mm/oom_kill.c
>> @@ -94,7 +94,7 @@ static bool oom_cpuset_eligible(struct task_struct *start,
>>  	bool ret = false;
>>  	const nodemask_t *mask = oc->nodemask;
>>  
>> -	rcu_read_lock();
>> +	guard(rcu)();
>>  	for_each_thread(start, tsk) {
>>  		if (mask) {
>>  			/*
>> @@ -114,7 +114,6 @@ static bool oom_cpuset_eligible(struct task_struct *start,
>>  		if (ret)
>>  			break;
>>  	}
>> -	rcu_read_unlock();
>>  
>>  	return ret;
>>  }
>> @@ -368,11 +367,10 @@ static void select_bad_process(struct oom_control *oc)
>>  	else {
>>  		struct task_struct *p;
>>  
>> -		rcu_read_lock();
>> +		guard(rcu)();
>>  		for_each_process(p)
>>  			if (oom_evaluate_task(p, oc))
>>  				break;
>> -		rcu_read_unlock();
>>  	}
>>  }
>>  
>> @@ -430,14 +428,13 @@ static void dump_tasks(struct oom_control *oc)
>>  		struct task_struct *p;
>>  		int i = 0;
>>  
>> -		rcu_read_lock();
>> +		guard(rcu)();
>>  		for_each_process(p) {
>>  			/* Avoid potential softlockup warning */
>>  			if ((++i & 1023) == 0)
>>  				touch_softlockup_watchdog();
>>  			dump_task(p, oc);
>>  		}
>> -		rcu_read_unlock();
>>  	}
>>  }
>>  
>> @@ -894,7 +891,7 @@ static bool task_will_free_mem(struct task_struct *task)
>>  	 * are dying as well to make sure that a) nobody pins its mm and
>>  	 * b) the task is also reapable by the oom reaper.
>>  	 */
>> -	rcu_read_lock();
>> +	guard(rcu)();
>>  	for_each_process(p) {
>>  		if (!process_shares_mm(p, mm))
>>  			continue;
>> @@ -904,7 +901,6 @@ static bool task_will_free_mem(struct task_struct *task)
>>  		if (!ret)
>>  			break;
>>  	}
>> -	rcu_read_unlock();
>>  
>>  	return ret;
>>  }
>> @@ -960,7 +956,7 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
>>  	 * That thread will now get access to memory reserves since it has a
>>  	 * pending fatal signal.
>>  	 */
>> -	rcu_read_lock();
>> +	guard(rcu)();
>>  	for_each_process(p) {
>>  		if (!process_shares_mm(p, mm))
>>  			continue;
>> @@ -982,7 +978,6 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
>>  			continue;
>>  		do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_TGID);
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


