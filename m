Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08565FF60E9
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 08:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1597C6B008C; Tue, 31 Mar 2026 04:34:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 130CB6B0095; Tue, 31 Mar 2026 04:34:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06ED76B0096; Tue, 31 Mar 2026 04:34:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EBC976B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:34:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B6B01E15DF
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:34:01 +0000 (UTC)
X-FDA: 84605695482.20.395A0F2
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0A10BA0002
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:33:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WWRZgfiw;
	spf=pass (imf25.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774946040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gV3wC6wNUStVNDdA5/n0gORLQ4zEznxAC2xRqMLlVrs=;
	b=CTFawdnyqtaY6AZLFYPG1sPmXm09Kvz7MzB67p05V9qv220FM5BIpdvxG5aEK7EaZrkJ3o
	wDmmgqP7nD8qHvDsCoRczOuC6sMtb+gSmhPYJCEdIQoRPVzxEjPcCbryveFxhcolHNYhcy
	e9j3o3Hl9gRacEwfv4PY4gnVZjN5mNE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WWRZgfiw;
	spf=pass (imf25.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774946040; a=rsa-sha256;
	cv=none;
	b=5477cVO3Au3iXas9t/2lA7Sk9KVilBZ9THEAEWcSLfAcCQ64wFFrI06EGcuVkcsoAISPUJ
	5MjUfpsgSMN9DgDHpyYvsjPam/j2jLLTFM+G2c2ZkVvI3H0Iv7YSkboHcIHfCIEsNfSbSh
	1xjNziPDDyP+XxySaCVWYoCPOciLQBs=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774946034; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=gV3wC6wNUStVNDdA5/n0gORLQ4zEznxAC2xRqMLlVrs=;
	b=WWRZgfiwiqRjclerUERliR7mwE/dSO5QHGggzczBW8KExil8TUtOYinZCZrz9ylg1JbKsyvJOlc4rZ9AsTFwKQAY6tR++Il19mN9KUaDR86n9CcBQFTNnwQ7jUc1ntdZ2C/bLtellDWsJIPStKl6zUK6zwQH+zde7mogmPURSt0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X03p4SA_1774946009;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X03p4SA_1774946009 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 31 Mar 2026 16:33:52 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Donet Tom <donettom@linux.ibm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Ingo Molnar <mingo@redhat.com>,  Peter
 Zijlstra <peterz@infradead.org>,  Ritesh Harjani <ritesh.list@gmail.com>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  Baolin Wang
 <baolin.wang@linux.alibaba.com>,  Ying Huang
 <huang.ying.caritas@gmail.com>,  Juri Lelli <juri.lelli@redhat.com>,  Mel
 Gorman <mgorman@suse.de>,  Vincent Guittot <vincent.guittot@linaro.org>,
  Dietmar Eggemann <dietmar.eggemann@arm.com>,  Steven Rostedt
 <rostedt@goodmis.org>
Subject: Re: [PATCH] sched/numa, mm: Skip page promotion if cpu pid is valid
In-Reply-To: <2b8f30a6-a8d1-4ea5-8078-5eec399c8609@linux.ibm.com> (Donet Tom's
	message of "Sat, 28 Mar 2026 00:24:13 +0530")
References: <20260326071216.11883-1-donettom@linux.ibm.com>
	<f41ab7cb-4430-4338-8812-eb6aa98e9bf9@kernel.org>
	<2b8f30a6-a8d1-4ea5-8078-5eec399c8609@linux.ibm.com>
Date: Tue, 31 Mar 2026 16:33:30 +0800
Message-ID: <87cy0kpfdx.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A10BA0002
X-Stat-Signature: 9khcus8dsdjqegnn7rxreatqq7tk1a36
X-Rspamd-Server: rspam06
X-HE-Tag: 1774946037-102225
X-HE-Meta: U2FsdGVkX18Qjum4dKszuW1k/ObqsWgSpblxSIeKMKqf+tDlBEf9fqQyxd/Zrm+5k7tv3g183qxuhBZRyh+lQ0cKz9PjHp+/DE8xjQZCDeCqhxIPd9dwb/4OTGyb9n9f3AS+B0wtjQdj+dIWcnoIyiWz4t5sSRa23FAE+BZJ375CoZHizrKcvfacaBu24zJYRmN3Xf6bnp8jyIAXP6lnCl34sirup5GTazxuaYIkd9+lOTHYOgeztQ5OVcGjTHzSINSTH+LMC3CMoy2gKbTlwoWjTNpM/GUJ/qMJB01EtshIDID8i7X4AqKhznbzZKHbUOyYwkmLckBzsqMrhLHKGGdPBAWj1V3HK+N2KYttcS62iR4/oomG7YQWDPhTEKN6/mnhXwP7FoQflEq5O6DXhgevWM60nj76i4hPBqrr7CPefmhaRTseZ8MPvc+7g1ULMDvnuve2HIulvGiJj13a84usZqTl6k/6kttDuCq/bnEN+ZnNMiLVZp/IRy+Zhzv9BDtoSC+he/ePtHiKc8bn/8qOGD3HmCEstO6Wda6JQeRXvOX8pfbk5WKAkFevszWcHDBTuOe8iJ/MZFfvEgnnZXGFezTp5KFLm3FaaYv54fJM/JrEmMHxAkhekTCeCVxy461AHy8SZNKB8VnxtyJG6637KInL/bjHVhZjmmLPyIyZjfNCF1vdhL9shjebiQWD85wZN5xUGeJK2hXWyUCkMBxquN0b6DqgkKOuTnUlOy7qzSa8aLnPiGX1HedYalk9FRybzzKrLEdjb1jy+ODjlEfTB816y3IhToop4xOFb93LcXtiURmRkg0CtzNzF6WW4yXc+lPz7UTiTkUoRdL5/nnyzyhxkZVoFb31yIKDeu6JvwO+dl+1LqBs3IOaS6AfGJ1zb7M+KzGhUvoRwQ8kIUTgOk4g3XUVxYzG9nRTeLAUFhwcwA9aYj9P8IfcDSpycwL3N2MD4BXfHPBmAAS
 8xOBfyY/
 WaToBfQB4t2Qe02C1mk5nsyMfBmMqyEgnhoCI0Zqc0yke20TyTjca20dzj17vmp2JeKnBG7D96fs44QHhFvCyWOPPmelBkmOWJWypMVzYc/zHaaPLuYTO8AMhnTHMwcz7f20N71Ypxs33mmZ19MZwMDLPKLPP6IXwgtuQTXlo+dxiRyDlaVVjjKEjqqtPLBXiC1i7vbQG37OJWISButaSsHthjfDHiLX1i4QmoaUCf/NutWC7jJRQjXvmSDo+Ag0nKiQVAGy8lNT0y6CsMW62ztQvfm3DkAyA90xleLxsvJGPSOrSqiTPuO+02eALGL9RC84Gx6QwfK+TuleUAPWhzrEX0i4JtgjGF2Di3ewmAX8sk94ioAp//KLTKNsOMeXGAsyqsv08Fguqeqs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Donet,

Donet Tom <donettom@linux.ibm.com> writes:

> On 3/26/26 3:59 PM, David Hildenbrand (Arm) wrote:
>> On 3/26/26 08:12, Donet Tom wrote:
>>> If memory tiering is disabled, cpupid of slow memory pages may
>>> contain a valid CPU and PID. If tiering is enabled at runtime,
>>> there is a chance that in should_numa_migrate_memory(), this
>>> valid CPU/PID is treated as a last access timestamp, leading
>>> to unnecessary promotion.
>> Is that measurable? Should we at least have a Fixes: ?
>>
>>> Prevent this by skipping promotion when cpupid is valid.
>>>
>>> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>>> ---
>>>   kernel/sched/fair.c | 7 +++++++
>>>   1 file changed, 7 insertions(+)
>>>
>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>> index 4b43809a3fb1..f5830a5a94d5 100644
>>> --- a/kernel/sched/fair.c
>>> +++ b/kernel/sched/fair.c
>>> @@ -2001,6 +2001,13 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
>>>   		unsigned int latency, th, def_th;
>>>   		long nr = folio_nr_pages(folio);
>>>   
>> /*
>>   * When ...
>>
>>> +		/* When tiering is enabled at runtime, last_cpupid may
>>> +		 * hold a valid cpupid instead of an access timestamp.
>>> +		 * If so, skip page promotion.
>>> +		 */
>>> +		if (cpupid_valid(folio_last_cpupid(folio)))
>>> +			return false;
>>> +
>> IIUC, as timestamp we use jiffies_to_msecs(). So, soon after bootup,
>> we would no longer get false positives for cpupid_valid().
>> I suppose overflows are not a problem, correct?
>
> Thank you, David, for guiding me in the right direction.
>
> I initially thought that overflows would not occur, and therefore
> cpupid_valid() would not produce false positives. However,
> after looking into it further, it appears that overflow can
> happen when storing the access time.
>
> The last_cpupid field is used to store the last access time.
> From the code, it appears that 21 bits are used for this
> (#define LAST_CPUPID_SHIFT (LAST__PID_SHIFT + LAST__CPU_SHIFT)).
>
> With 21 bits, the maximum value that can be stored is

It can be less than 21 bits, if CONFIG_NR_CPUS is small.

	DEFINE(NR_CPUS_BITS, order_base_2(CONFIG_NR_CPUS));

> 2097151ms (35Hrs) . If the access time exceeds this
> range, it can overflow, which may lead to cpupid_valid()
> returning false positives.
>
> I think we need a reliable way to determine cpupid_valid() that
> does not produce false positives.

Yes.  IMHO, false positives is unavoidable.  So, the patch fixes a
temporal performance issue at the cost of a longstanding performance
issue.  Right?

---
Best Regards,
Huang, Ying

>
>>
>> So what we're saying is that folio_use_access_time()==true does not
>> imply that there is actually a valid time in there.
>>
>> In numa_migrate_check() we could still use the valid cpuid I guess and
>> make that code a bit clearer?
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 631205a384e1..ba68933a9e4a 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -6119,10 +6119,9 @@ int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
>>           * For memory tiering mode, cpupid of slow memory page is used
>>           * to record page access time.  So use default value.
>>           */
>> -       if (folio_use_access_time(folio))
>> +       *last_cpupid = folio_last_cpupid(folio);
>> +       if (!cpupid_valid(*last_cpupid))
>>                  *last_cpupid = (-1 & LAST_CPUPID_MASK);
>> -       else
>> -               *last_cpupid = folio_last_cpupid(folio);
>>            /* Record the current PID accessing VMA */
>>          vma_set_access_pid_bit(vma);
>>
>>
>> The change itself here looks reasonable to me.
>>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>

