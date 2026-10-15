Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54B14CC6B1C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 03:42:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 158A16B0088; Wed, 14 Oct 2026 23:42:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10AE16B008A; Wed, 14 Oct 2026 23:42:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3B2F6B008C; Wed, 14 Oct 2026 23:42:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D50076B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 23:42:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 57CBFA85CD
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 03:42:32 +0000 (UTC)
X-FDA: 85323463344.25.0335506
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4C4A940004
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 03:42:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=a4qzHdzJ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf12.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792035750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=18g34PysGbh5XHdISii7T815efgfUCVrzKpp9lKPQHQ=;
	b=HETkGRCiYk/YK+A10XPGy3KbNFJYObbd6mZw3jJXJVqi1U6jTirTm7gW7mpVM6bBIKQqVl
	rHbklqSj2rv+y9h2DxQKnmsBoqkqCpeifMaZm22/vVIcw975eCPTCjYTRUQMm0TSVFV1yt
	JhQWRFXQhjiI4t5Su9LhdmKfI2EsLTs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=a4qzHdzJ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf12.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792035750;
	b=3HYYwjgu4kQGIMoGsgVirTMgtDr2w/xGGfdbL2+BI+9r81yMy8kGDmwrmyTZK2oRHojOM/
	VP6ZfoOQgo9XRZvqjeKk6mOuOXfuoCh9Zs87KBdeLJr9wA9Dn5th1l7FQt/b4WZ5zNv6tK
	SHSpXxLa/njzSKRCqq/9/f3iv8RYtb0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792035737; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=18g34PysGbh5XHdISii7T815efgfUCVrzKpp9lKPQHQ=;
 b=a4qzHdzJzwSU4RNzZZTWTpnjQiz55jgr+5VWbz7fivEVDT1rBuc6khUdLFCbF55lx05SIc
 3UEUAi0hEtppmsSxwRaNA2JNGmyPGWJ7QERlBZIVDbjC+0NQtBD9Bw1xzjD4km4Qfglj3n
 KXO4T+Bo4R57nExxL1d5hSpVEgOeMSos1Ir5wGcU9r59DTL1uMZf0XuOgYWG7cU2mSaWVV
 QWnls9oaxwlSYiZsddmjolHoKZkDjDISS/44ve9sFsJS8asbQNuUCnJ07h4omYju492GgF
 DtDLsJ8AOeAdTr5Dc+I/UlRNDEJhyOx2MLiA/8Y8QSQgeC5lYkUEkfFXfo+XbQ==
Date: Thu, 15 Oct 2026 11:41:51 +0800
Message-Id: <359a4776-6737-43b3-8c26-77b2d3bae081@bytedance.com>
User-Agent: Mozilla Thunderbird
To: "Gregory Price" <gourry@gourry.net>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>, 
	<joshua.hahnjy@gmail.com>, <ziy@nvidia.com>, <mingo@redhat.com>, 
	<peterz@infradead.org>, <mgorman@suse.de>, <riel@redhat.com>, 
	<juri.lelli@redhat.com>, <vincent.guittot@linaro.org>, 
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>, 
	<vschneid@redhat.com>, <kprateek.nayak@amd.com>, 
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
In-Reply-To: <as98SA5yfBaeI4oj@gourry-fedora-PF4VCD3F>
Subject: Re: [PATCH 1/6] sched/numa: clear fault locality state on execve
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26ad04b97+2adc9e+kvack.org+lizhe.67@bytedance.com>
References: <20261014094347.99157-1-lizhe.67@bytedance.com> <20261014094347.99157-2-lizhe.67@bytedance.com> <as98SA5yfBaeI4oj@gourry-fedora-PF4VCD3F>
X-Stat-Signature: 3sortij5fnb9dqk94pxnfb3tdkpkr6ga
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C4A940004
X-Rspamd-Server: rspam08
X-HE-Tag: 1792035749-793359
X-HE-Meta: U2FsdGVkX18YTmUiZWNSOupaV5kPiN8INSxH8aMKujrsWpkyJnicTMcs351o77F0Mnq0zlg6DCcM3xujjpUg53DpQYrzwaX8kmecP5fqFp/VFbn+2EgA8P9A5UZn/TaNR0zWpOx0V0zUj0x2SlHET4JvpJbq2OV+umRYbjDP4/AlvNuKRBxFUcRm6rllqUkaxVS3ifukTGMOZg6Ds9pt3EBcjROuN60OC1n6+cOaNZ1q8rxK22WACA+SyXki0lD3/YNHZMOJhZiADFGpkTOQ0o6ByytiNLHKWESQv/Ad7TUiVFy2+M7VJbOW3FC8LGP/uci8QCdh/g8/P4QnQ7ygBO9yuDJ4FzITEAuJt++mxO9PYx88o17bkzQIyaBgECKrflyJu/Lez7iJfRodLgz2nbhILV1ydjt2bLhF9FcbypuEHk2VQNKm44pkr4yizy+c/dkcVvVkejCDCrppnP++c3T9X/aWQP4Eja90O2Lze23FWQteu7oLLLTt49QCLhkxkpfliANTgW+QIG7/ZxoeVV9EODCdGP2gGm9w74jNA9BJ6+fTnG4gxwJnjudyvhm/7RrLZqmCYLQM56+YtBuPin5H4GETS6vfJW1AAczotaCsRybipysHeKvnCJI6uEoeDrG3ulhoR+ARZV4ifFGZsOzVAfujIiv9tnMT4QLK3rEKwdk0s7jj6qEgHgyiXPLnBq1tBQoh/yZFLZsF1CbynTcQHKjTc98wKf2PG/qwoWaTtya+1ozc3RRRmVtQsDRKOITZMql6o5NiEHh6HXssefIadAL4YSEzon4Ow5K6V8TGkE9/Q9HHULE58s/anfZ1F1kbqpqaham2riV3gGEjsulwE2EwGy7bcsh6geYUSSLs9vPbA3QbsC5pT26rWdW+T3ySWEDej+t5cXzowJUTycWZeZr1bz53/e24aGz+zDhBo8nDoL5Rp/tZf3V5QdLBMc63P/0MkhGcN1CzMw0
 atG1Dykt
 tYTH8VOLSRB/Sx2in+AdvJ5IcFnrITQZS9UIYLF3ZcRpjbOeo49B/HgmPbMj03HoPQXt8V9AIj2jzaCpjCkVyJhKbM9UlR2VpmSeC6OooihXqj3MUatPrVL4E+OG4LnJsgeBVaq+ppRiYxID5q7GzTyv9iz50pCrFjWu1+06TFZ1h6Hh1qfdaS9d2OyQFZ7pxZZEUHOEjqWwKaDUgl3apiMuaWXY5JUSRwcUdILgU0ZPJRfiBQOi1dqTTUSofy1jSLGb80G0nTdY4AbloJ3zgztMGfD/JAl/rqdfV2JrY/OTWX3o5y22YppnHkEM9I1C2Y5Fbmu+KvCq1OmRIH3m8WQJip4szM87gJezeOabOQ1OjM2DoO2zm79yKsRAGp6PhQfVt3fkgutT1Fgdq/KP7nqMLg+W7ie26f/rFDG+C7NugLddJCFZOHHiS7fovXEOYXiQ7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/26 9:02 PM, Gregory Price wrote:
> On Wed, Oct 14, 2026 at 05:43:42PM +0800, Li Zhe wrote:
>> task_numa_free(p, false) is used by execve() to reset NUMA balancing
>> state without freeing p->numa_faults, because concurrent readers may
>> still observe the task.
>>
> Is a process that exec()'s going to run long enough to actually collect
> any real numa fault data?
>
>> the retained p->numa_faults array, but leaves the current-window buffer
>> half and p->numa_faults_locality unchanged. Those are also NUMA fault
>> feedback consumed by task_numa_placement() and update_task_scan_period(),
>> so a newly executed image can inherit stale fault feedback from the old
>> image.
> I'm not sure this actually corrects much unless you have a long running
> program that eventually exec()'s - and even then it seems like this all
> self-corrects within a couple seconds.
>
> Do you have some clear reproduction that makes an obvious wrong effect,
> or was this just some static analysis?
>
> It's "not wrong", but I'm trying to understand what impact this actually
> has.


This was found by code inspection, but it is related to the same class of
stale numa_faults_locality problem Eric fixed for update_task_scan_period():

https://lore.kernel.org/all/OS7PR01MB139144C7E07C97B3F3B47016796D52@OS7PR01MB13914.jpnprd01.prod.outlook.com/

That patch clears locality feedback after the scan-period update, so stale
locality and migration-failure information does not affect later scan-period
decisions. This patch handles another reset boundary: execve() already calls
task_numa_free(p, false) to reset NUMA balancing state for the new 
image, but
that path leaves the current-window counters and numa_faults_locality 
behind.

So a newly exec'ed image can consume locality or migration-failure feedback
from the old image during its first placement update. I agree that the 
impact
is likely transient, especially once Eric's fix is present. The intent 
here is
to make the execve reset path complete, rather than to claim a severe 
runtime
bug.

Thanks,
Zhe


>
>> The non-final path clears p->total_numa_faults and the averaged half of
>>
>> Clear the whole retained p->numa_faults array and p->numa_faults_locality
>> together in the non-final reset path.
>>
>> Fixes: 04bb2f947505 ("sched/numa: Adjust scan rate in task_numa_placement")
>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>> ---
>>   kernel/sched/fair.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 57360f5cdde4..1053437933ee 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -4177,8 +4177,9 @@ void task_numa_free(struct task_struct *p, bool final)
>>   		kfree(numa_faults);
>>   	} else {
>>   		p->total_numa_faults = 0;
>> -		for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++)
>> -			numa_faults[i] = 0;
>> +		memset(p->numa_faults_locality, 0, sizeof(p->numa_faults_locality));
>> +		memset(numa_faults, 0, sizeof(*numa_faults) *
>> +		       NR_NUMA_HINT_FAULT_BUCKETS * nr_node_ids);
>>   	}
>>   }
>>   
>> -- 
>> 2.20.1

