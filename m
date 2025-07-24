Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34EABC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 07:37:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B22586B0207; Thu, 24 Jul 2025 03:36:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF8536B0208; Thu, 24 Jul 2025 03:36:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A34C86B0209; Thu, 24 Jul 2025 03:36:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 928BD6B0207
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 03:36:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 12CFBB82BB
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:36:59 +0000 (UTC)
X-FDA: 83698351758.05.207B1D7
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7A3E6A0003
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:36:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=r6vgAEi5;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf15.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753342617; a=rsa-sha256;
	cv=none;
	b=1vlTcoVqQ2QF//5kXNShIAPMVmzXVAA5OB9EmtJ0z0Man/sr8QGhjfWoJj/ux8WLYkO/7J
	OAI+wXCMpdBu9wjFjNE26Pr1Bbpz/JhRquXmmGUnGtmVib+XTkW5Iu8r6k8yb3QJmzyCHd
	fFU/92gc5bSXpZJxJUbw1JpDzo0kKPE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=r6vgAEi5;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf15.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753342617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P6saxIttai/NSTgVrkSSj21N3ELBMaOxdIJSLIFoS5k=;
	b=vNFQxLX4CvNK9GMk3/MVLIuAhbRm6orkM7lR15MzxIQyeJ+Y8Oxi9hPEpHQ4VeFtiB4tju
	O3pcN6BAFeB1t3SfY/7GMyX21BdwfOumYqH9Nbh7vAPKIPCQFv9MlgQ8huS+oippKbRiDJ
	pbCc0EYDGZHac3KApp7PJO4Jxe1KCpk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753342611; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=P6saxIttai/NSTgVrkSSj21N3ELBMaOxdIJSLIFoS5k=;
	b=r6vgAEi5VajCOo2tY6PDP9jQno6S17LMRkMrJhAbxPXe3uAJBpGX6pJ9gIZJ2LJfmVyoQJHQJHWzE8pc+YMr+j/lDFIS4s64bjaYiqj87yJyew+ZCJ8vU2sIBLeDFPGPR8br8yuNPLsqRmFIvR+HA57nEwAkgTuOThZo6b4AHrM=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WjlKIg3_1753342609 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 24 Jul 2025 15:36:50 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  lkp@intel.com,
  akpm@linux-foundation.org,  y-goto@fujitsu.com,  mingo@redhat.com,
  peterz@infradead.org,  juri.lelli@redhat.com,
  vincent.guittot@linaro.org,  dietmar.eggemann@arm.com,
  rostedt@goodmis.org,  mgorman@suse.de,  vschneid@redhat.com,  Li Zhijian
 <lizhijian@fujitsu.com>,  Ben Segall <bsegall@google.com>
Subject: Re: [PATCH RFC v3] mm: memory-tiering: Fix PGPROMOTE_CANDIDATE
 counting
In-Reply-To: <85d83be2-02f8-4ef6-91c7-ff920e47d834@fujitsu.com> (Shiyang
	Ruan's message of "Thu, 24 Jul 2025 10:39:40 +0800")
References: <20250722141650.1821721-1-ruansy.fnst@fujitsu.com>
	<87cy9r38ny.fsf@DESKTOP-5N7EMDA>
	<85d83be2-02f8-4ef6-91c7-ff920e47d834@fujitsu.com>
Date: Thu, 24 Jul 2025 15:36:48 +0800
Message-ID: <87wm7y3ur3.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7A3E6A0003
X-Stat-Signature: hd85dsxmsq4addwjx9xj8nfrneshsmpm
X-Rspam-User: 
X-HE-Tag: 1753342615-151642
X-HE-Meta: U2FsdGVkX1+eXE60lI06q8gLX29cu/4mgaXe6emXY6wnQsJIMkavrJ5DydiRx12HGJ7CJIuoDjBwMv8Ai0r30bd05sqLwMDEX3xrKmBJl0B4dyUfwe7RxxmLZqySRCf9UO8csQxuz6uEVCMGw8N7Qw7UI/ZTZ54sS/k9At/gnC3c4lHnioZnmgL2UeeaaF5kgWQSov7NBwjH2iDhsknxhjOSMg7zuSZMiURX34YAGEm1gO/3ccDhx/I+yflaXlODu9EK7bwOLPI5eV57VJ2o5UiSjk7Yu39cGz6GVfh4nUsmVS1vL6GuMD1EF0c32VqVWTGT2Qh9Ax5JgvoiqOjI/mhbo7gJO5Zk0oTTRFyz9ZD7Ayq0ubwrJxs8QX4nqrsy/pjFuxlJILAwniZMb73wwboqxKQLyHZun+Q2h7+DgsymjRwI2Lk40hLwpAwiw9PnIQOH9nl+lK4TQrRRzyeJy3hkfEgz9tmDHSmVqF4DNMoP7yuG2YlZ+SYk7NruoGirLECzZmhUA0/zRT11c054YI4rGHVukBfpvQCEjPn3d58ktvdQLr/myM8ha4tOOu7osbOQcpwhX51Bkkzxl05aLbu/TS3LhacCj0jhOwVHZ1LeSmTrknoYZP7wXEfEqVW0qhtgK5s7eahLJ7GgKrsEh6x23TsLg6VjGDwsSSRfYvvdDXyCOWLj+P0DT+Rig+T9lWH1E7oQ4YwSr9ASJr4rcEED/lgcup17QST7qznBcgN5j+nB/+0JZMTsG6GPrgWrsw6ihDiNFJfnZXoPN2Qg1lT4U3By2nGiDrW+/qu2aFusR0DqGP+nMBBD1eQkIkvwcpxmREU5S9Ra06YE9wRVTDdGsupp0fuAWSCGK33xq0HQHBmU8jwP+5jHOsNbK5Jw7A9/lxaCUlKe89KuMWgtvHPWWj9Bf7FfHwVfPXY43OJB1APFofWoBsXWtmSSatz8QIuoWRMHR88PZGV1QQu
 RcRc/lH4
 pQhDH9BAHz3J5t1jib94zfhaiQTnzk3wht798RI5FlfzBHl25VN1k7XGyCLzrlJo0LNzCJsDPkydtlFvkeSHbIfKKrVlsP5+1choIXg9bUdqVuNU7XCPYpeThdGdDZEplUmrlvz1JXxbtRhELb8u/NJw6CttFZlXyrm8SS6Cv/FF1s8e0msdnOy1VtQHBt0tUXMLCyLj66uP/QIZRLI9H0S7JEF4r2+CtBXkXxFOFyt4c5Hj5zK+3Jf89s1VXf4DMWDOZSI5tWl37CDBeSMTdtVgV3LWvCIh7QwldLmjHxiFtpD7yremTkqLzFhvV1kaCzcJq6IKsW77WFTZPaTZkxssJa0qLlyD12SSr0st+As8DQbSo7kD6fGbEuK9aJHvZzISLZ6a/cvR3Fe+pBJxiSl95lV3+tksZtSUcMrdrkXFBXpbtWqKmdt3e3scAbDRQEn/Dxg6univecoYzAaFAPCK8Yw4hzzbof2bxRB9thl1+Bj2+i9vDlCgHUVLQ3diozbcfyp0exaUuVUBxZ9w2yjHVV4z4YYIVVpfruuCGBQ4g1cRCBNiHoDJ3ecpWu7C7OLcKakGlmw4Acq4PoLWqhApsceDhdwPyN0aWPcTTZxgc1C0KzkgmTt+fAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shiyang Ruan <ruansy.fnst@fujitsu.com> writes:

> =E5=9C=A8 2025/7/23 11:09, Huang, Ying =E5=86=99=E9=81=93:
>> Ruan Shiyang <ruansy.fnst@fujitsu.com> writes:
>>=20
>>> From: Li Zhijian <lizhijian@fujitsu.com>
>>>
>>> =3D=3D=3D
>>> Changes since v2:
>>>    1. According to Huang's suggestion, add a new stat to not count these
>>>    pages into PGPROMOTE_CANDIDATE, to avoid changing the rate limit
>>>    mechanism.
>>> =3D=3D=3D
>> This isn't the popular place for changelog, please refer to other
>> patch
>> email.
>
> OK. I'll move this part down below.>
>>> Goto-san reported confusing pgpromote statistics where the
>>> pgpromote_success count significantly exceeded pgpromote_candidate.
>>>
>>> On a system with three nodes (nodes 0-1: DRAM 4GB, node 2: NVDIMM 4GB):
>>>   # Enable demotion only
>>>   echo 1 > /sys/kernel/mm/numa/demotion_enabled
>>>   numactl -m 0-1 memhog -r200 3500M >/dev/null &
>>>   pid=3D$!
>>>   sleep 2
>>>   numactl memhog -r100 2500M >/dev/null &
>>>   sleep 10
>>>   kill -9 $pid # terminate the 1st memhog
>>>   # Enable promotion
>>>   echo 2 > /proc/sys/kernel/numa_balancing
>>>
>>> After a few seconds, we observeed `pgpromote_candidate < pgpromote_succ=
ess`
>>> $ grep -e pgpromote /proc/vmstat
>>> pgpromote_success 2579
>>> pgpromote_candidate 0
>>>
>>> In this scenario, after terminating the first memhog, the conditions for
>>> pgdat_free_space_enough() are quickly met, and triggers promotion.
>>> However, these migrated pages are only counted for in PGPROMOTE_SUCCESS,
>>> not in PGPROMOTE_CANDIDATE.
>>>
>>> To solve this confusing statistics, introduce this
>>> PGPROMOTE_CANDIDATE_NOLIMIT to count the missed promotion pages.  And
>>> also, not counting these pages into PGPROMOTE_CANDIDATE is to avoid
>>> changing the existing algorithm or performance of the promotion rate
>>> limit.
>>>
>>> Perhaps PGPROMOTE_CANDIDATE_NOLIMIT is not well named, please comment if
>>> you have a better idea.
>> Yes.  Naming is hard.  I guess that the name comes from the
>> promotion
>> that isn't rate limited.  I have asked Deepseek that what is the good
>> abbreviation for "not rate limited".  Its answer is "NRL".  I don't know
>> whether it's good.  However, "NOT_RATE_LIMITED" appears too long.
>
> "NRL" Sounds good to me.
>
> I'm thinking another one: since it's not rate limited, it could be
> migrated quickly/fast.  How about PGPROMOTE_CANDIDATE_FAST?

This sounds good to me, Thanks!

---
Best Regards,
Huang, Ying

>
>>=20
>>>
>>>
>> The empty line is unnecessary.
>
> OK.>
>>> Cc: Huang Ying <ying.huang@linux.alibaba.com>
>> Suggested-by: Huang Ying <ying.huang@linux.alibaba.com>
>
> OK.
>
>
> --
> Thanks,
> Ruan.
>
>>=20
>>> Cc: Ingo Molnar <mingo@redhat.com>
>>> Cc: Peter Zijlstra <peterz@infradead.org>
>>> Cc: Juri Lelli <juri.lelli@redhat.com>
>>> Cc: Vincent Guittot <vincent.guittot@linaro.org>
>>> Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
>>> Cc: Steven Rostedt <rostedt@goodmis.org>
>>> Cc: Ben Segall <bsegall@google.com>
>>> Cc: Mel Gorman <mgorman@suse.de>
>>> Cc: Valentin Schneider <vschneid@redhat.com>
>>> Reported-by: Yasunori Gotou (Fujitsu) <y-goto@fujitsu.com>
>>> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
>>> Signed-off-by: Ruan Shiyang <ruansy.fnst@fujitsu.com>
>>> ---
>>>   include/linux/mmzone.h | 2 ++
>>>   kernel/sched/fair.c    | 6 ++++--
>>>   mm/vmstat.c            | 1 +
>>>   3 files changed, 7 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>>> index 283913d42d7b..6216e2eecf3b 100644
>>> --- a/include/linux/mmzone.h
>>> +++ b/include/linux/mmzone.h
>>> @@ -231,6 +231,8 @@ enum node_stat_item {
>>>   #ifdef CONFIG_NUMA_BALANCING
>>>   	PGPROMOTE_SUCCESS,	/* promote successfully */
>>>   	PGPROMOTE_CANDIDATE,	/* candidate pages to promote */
>>> +	PGPROMOTE_CANDIDATE_NOLIMIT,	/* candidate pages without considering
>>> +					 * hot threshold */
>>>   #endif
>>>   	/* PGDEMOTE_*: pages demoted */
>>>   	PGDEMOTE_KSWAPD,
>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>> index 7a14da5396fb..12dac3519c49 100644
>>> --- a/kernel/sched/fair.c
>>> +++ b/kernel/sched/fair.c
>>> @@ -1940,11 +1940,14 @@ bool should_numa_migrate_memory(struct task_str=
uct *p, struct folio *folio,
>>>   		struct pglist_data *pgdat;
>>>   		unsigned long rate_limit;
>>>   		unsigned int latency, th, def_th;
>>> +		long nr =3D folio_nr_pages(folio);
>>>     		pgdat =3D NODE_DATA(dst_nid);
>>>   		if (pgdat_free_space_enough(pgdat)) {
>>>   			/* workload changed, reset hot threshold */
>>>   			pgdat->nbp_threshold =3D 0;
>>> +			mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE_NOLIMIT,
>>> +					    nr);
>>>   			return true;
>>>   		}
>>>   @@ -1958,8 +1961,7 @@ bool should_numa_migrate_memory(struct
>>> task_struct *p, struct folio *folio,
>>>   		if (latency >=3D th)
>>>   			return false;
>>>   -		return !numa_promotion_rate_limit(pgdat, rate_limit,
>>> -						  folio_nr_pages(folio));
>>> +		return !numa_promotion_rate_limit(pgdat, rate_limit, nr);
>>>   	}
>>>     	this_cpupid =3D cpu_pid_to_cpupid(dst_cpu, current->pid);
>>> diff --git a/mm/vmstat.c b/mm/vmstat.c
>>> index a78d70ddeacd..ca44a2dd5497 100644
>>> --- a/mm/vmstat.c
>>> +++ b/mm/vmstat.c
>>> @@ -1272,6 +1272,7 @@ const char * const vmstat_text[] =3D {
>>>   #ifdef CONFIG_NUMA_BALANCING
>>>   	"pgpromote_success",
>>>   	"pgpromote_candidate",
>>> +	"pgpromote_candidate_nolimit",
>>>   #endif
>>>   	"pgdemote_kswapd",
>>>   	"pgdemote_direct",
>> ---
>> Best Regards,
>> Huang, Ying

