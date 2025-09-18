Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BF49CAC59F
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 02:43:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54C3F280007; Wed, 17 Sep 2025 22:43:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FCD08E006B; Wed, 17 Sep 2025 22:43:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4122A280007; Wed, 17 Sep 2025 22:43:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2BF008E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:43:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F060C0450
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 02:43:51 +0000 (UTC)
X-FDA: 83900825862.21.5C5151D
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id B9A1240002
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 02:43:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VJFqxKmm;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758163430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hI0IJw0Wjez1WxyWFmZyWVXd+7wN4CQqoOTQh/J70mY=;
	b=Y+hW3cUW0qVQ9ru2Row10fzrc+cdn1LnMbhbvqxtaUTf7kOdIGGi5SUdKDJHsa9J5P6L3b
	qLEb0OEQbDVRV8zCIfrWMEWxQDc0Qq5a7G1xsKU0cpW5Wy0c5ZQvIKi3GMFoz6XUCHSYSG
	VoJNX0h77bn1ENC0FMN0E/UCz9nQGOk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758163430; a=rsa-sha256;
	cv=none;
	b=WJgvLAXoxiTwLhDDpbJ2NvejsGmNZvy96T6vJkOX0gQ5Md0TqGJR45WL0mI3PzdNrMVlcY
	/iV4/x6hqorgiClo3igrL2IRUiL7Oc2eCYmNX1q5cCXLNk7f+3npUZBGe0iXK+3VE/sWL0
	hBCvEVo+2NgALaaTWxlqNLs4xfFQh84=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VJFqxKmm;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <71d3ec0b-1b91-49f7-b973-6ec8882dd02d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758163426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hI0IJw0Wjez1WxyWFmZyWVXd+7wN4CQqoOTQh/J70mY=;
	b=VJFqxKmmVe5s2Sd6wvuQStIArfzjFaX0aJ9uz2TPSqjmPYK85oIrR5TYnsew7H/TWnWJFz
	hk2rvyO9jXKgEahh9gc8MnooUUUHIY/HVVPpVPvreJDvCy4n6vZ2U4scbHimXkZIXVW1BN
	fLIuQIgqE6ZEdvKOFWvFPWeXcK72Wns=
Date: Thu, 18 Sep 2025 10:43:33 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v6] memcg: Don't wait writeback completion when release
 memcg.
Content-Language: en-US
To: Julian Sun <sunjunchao@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, jack@suse.cz, tj@kernel.org,
 muchun.song@linux.dev, venkat88@linux.ibm.com, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 Masami Hiramatsu <mhiramat@kernel.org>
References: <20250917212959.355656-1-sunjunchao@bytedance.com>
 <20250917152155.5a8ddb3e4ff813289ea0b4c9@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20250917152155.5a8ddb3e4ff813289ea0b4c9@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B9A1240002
X-Stat-Signature: 4q9wm989zx1pasp8eeqxurfpmmy6xqi1
X-Rspam-User: 
X-HE-Tag: 1758163429-983583
X-HE-Meta: U2FsdGVkX1+oAKT3wIHnmxsa0OL3nE/dXKphNZOgFguZK+3P1MR9WTpdDKiOdbYQdn6WWI3q55PnsR7I6x7nWnvYNUI2VElShLUXnwSXYfUeXKudZltSzNXbZ5UhcNlXmhRpscjjggofYdYRwy7x2l2DABud9GJls+0cCjY/pVdC73iUG6nHgUrv0nJCWJuIeY/xnGDD9WgziTRLQvl/RU234JVUIXGi6XI05dEcUy72U5Zeb7NVBxPND1x5agpcgkZqQgmty2TH7wGUmbl2UcDg48ddNIsFTtMXf85etZ1omY6pp/nxwsc/McNst6YaAE69TK6QdGYJWFkG/exJfYQzIws+rJojuioCmAJqkVCdsQg1JlpW8OsjDe5N+u+g45z5hTlU7xAEh3S4a/k21NWw8KQFe2UZO/m5/r+ioV/zAibQQhGXqdTkYyeupiy+Ih/uHX8tDpsDZmg+d+4wuCmRcG2lAyY9gyoCNDK+OoQJwozXW7I7+u+4fvvoFvBAe9+ao4j/NvYnz4sbXQg7auivrfjlfz1tMyDK0fNZznm3Sp8l53+Tw14j9IQYNcFv973qxZAY90T16u/ArrByZXADwr6Z3fB2a9einPLlIITx7P3G/DClOEUPUBDuuz2XKKaFpHbXFrQJRw7a34EcyXd72EoVTUZ7E23Z50MwRSiOnU6QXgbs/ap3o07CRmfpjOj3r8NhtzvcDc3N7daAk/ATQbu08sJHpI6LRTogIZ8Vily/8AZPxt/Xsb7jQ6Al515MiK8IYLG+AJUBxYn5Bclco49DAyMsy16qndPozgSLGh9z7UgAliC5XmhqIAI1eNYTvjbODqNVj8N74fWg19jwanH/FYnWEzV+ljaBkNsNaOE3GF8DXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey Julian,

On 2025/9/18 06:21, Andrew Morton wrote:
> On Thu, 18 Sep 2025 05:29:59 +0800 Julian Sun <sunjunchao@bytedance.com> wrote:
> 
>> Recently, we encountered the following hung task:
>>
>> INFO: task kworker/4:1:1334558 blocked for more than 1720 seconds.
>> [Wed Jul 30 17:47:45 2025] Workqueue: cgroup_destroy css_free_rwork_fn
>>
>> ...
>>
>> The direct cause is that memcg spends a long time waiting for dirty page
>> writeback of foreign memcgs during release.
>>
>> The root causes are:
>>      a. The wb may have multiple writeback tasks, containing millions
>>         of dirty pages, as shown below:
>>
>>>>> for work in list_for_each_entry("struct wb_writeback_work", \
>> 				    wb.work_list.address_of_(), "list"):
>> ...     print(work.nr_pages, work.reason, hex(work))
>> ...
>> 900628  WB_REASON_FOREIGN_FLUSH 0xffff969e8d956b40
>> 1116521 WB_REASON_FOREIGN_FLUSH 0xffff9698332a9540
>>
>> ...
>>
> 
> I don't think it's particularly harmful that a dedicated worker thread
> has to wait for a long time in this fashion.  It doesn't have anything
> else to do (does it?) and a blocked kernel thread is cheap.

Looking at wb_wait_for_completion(), one could introduce a new helper that
internally uses wait_event_timeout() in a loop. Something like:

void wb_wait_for_completion_with_timeout(struct wb_completion *done)
{
	atomic_dec(&done->cnt);
	while (atomic_read(&done->cnt))
         	wait_event_timeout(*done->waitq, !atomic_read(&done->cnt), 
timeout);
}

With this, the detector should no longer complain for that specific case :)

> 
>> 3085016 WB_REASON_FOREIGN_FLUSH 0xffff969f0455e000
>> 3035712 WB_REASON_FOREIGN_FLUSH 0xffff969d9bbf4b00
>>
>>      b. The writeback might severely throttled by wbt, with a speed
>>         possibly less than 100kb/s, leading to a very long writeback time.
>>
>> ...
>>
>>   include/linux/memcontrol.h | 14 +++++++++-
>>   mm/memcontrol.c            | 57 ++++++++++++++++++++++++++++++++------
>>   2 files changed, 62 insertions(+), 9 deletions(-)
> 
> Seems we're adding a bunch of tricky code to fix a non-problem which
> the hung-task detector undesirably reports.
> 
> Would a better fix be to simply suppress the warning?
> 
> I don't think we presently have a touch_hung_task_detector() (do we?)
> but it's presumably pretty simple.  And maybe
> touch_softlockup_watchdog) should be taught to call that
> touch_hung_task_dectector().

Yes, introducing a touch_hung_task_detector() and having other tasks
periodically call it for the blocked worker seems like a much cleaner
approach to suppress the warning, IMHO.

> 
> Another approach might be to set some flag in the task_struct
> instructing the hung task detector to ignore this thread.

Alternatively, the idea of setting a flag for the worker to explicitly
ignore certain tasks by the detector is also interesting, especially if the
worker's blocked state is expected and benign ;)

Well, happy to help explore either of these paths if you'd like to go 
further
with them ;P

Cheers,
Lance


