Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A568606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 08:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=XeN680I7
Received: by kanga.kvack.org (Postfix)
	id 2D2F66B00EF; Thu, 29 Oct 2026 04:17:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 283856B05B1; Thu, 29 Oct 2026 04:17:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 172906B05B2; Thu, 29 Oct 2026 04:17:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DCC8C6B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 04:17:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 17125160312
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 08:17:34 +0000 (UTC)
X-FDA: 85374959628.12.0CAF87C
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf14.hostedemail.com (Postfix) with ESMTP id 68C32100003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 08:17:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=XeN680I7;
	spf=pass (imf14.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793261852;
	b=PIhTujGixen7m6r44Nsy2Ho7aZgt2I73pVk602cbz90eC+4f8IW2n0aUM00Xly6FR4RWum
	LIGjVZdZELtNkxKvdS9UXaSmnimDJ53X8q/rYpS5PMqGbvF5lBwj1TAmyiugF5z8odiNuV
	BDZQiFhXunhAyp+C+uXjH1ao6J9h05o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=XeN680I7;
	spf=pass (imf14.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793261852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+a0pwiupnElVC4iJq7ApJkfigClnpAXCdq3Fy64eUq4=;
	b=hW59KT8o37Ub5uUovSlELNxriQpJp0CMrAwq2JH3P4ArN+oUDxcpHhAvYVMlAhsmfjIv6u
	AqtU3M9dDo15COqq/DEN2cdGDWgEK6me0/ajfLiwzeisRofBFDsXZNWSWixnuY4nPaY5yN
	bQPfg/2/P5t/YLQ24JMbtEDMyBedrYU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793261842; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=+a0pwiupnElVC4iJq7ApJkfigClnpAXCdq3Fy64eUq4=;
 b=XeN680I7IJlNMjMU87dIzNsxFTBBTj3N5w3g0gCwl1fJHn5Rw1SF4eOneUkqJxa/YwNwJz
 4+f8RvjasCmqzwtsuwTZZRC9OMWc7dIhcHPsbSp8/TIAJB5foGuei9CreWol+vyR+wy8Ue
 l3ESXeSgyAmWo8VZ+mK1DwmD8Xse74pPKf4vh2xt1rVEAwadtbH0A2/1hlKNqn7aYEpCGV
 jWJpN3qN6JQmUIg/eLFTNGzUe5N2RiO9xhfm8P8S+u/gyaIJIBfU+mFR0qhrhe5oq03tlr
 C+Z8B7anBTTCgC2MKqUO/dEseibVvg61SVujbN11KZ9n4hnkTnUC/bJSHksJdg==
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
To: "Bharata B Rao" <bharata@amd.com>, <akpm@linux-foundation.org>, 
	<bsegall@google.com>, <david@kernel.org>, <dietmar.eggemann@arm.com>, 
	<gourry@gourry.net>, <joshua.hahnjy@gmail.com>, <juri.lelli@redhat.com>, 
	<kprateek.nayak@amd.com>, <ljs@kernel.org>, <mgorman@suse.de>, 
	<mingo@redhat.com>, <peterz@infradead.org>, <riel@redhat.com>, 
	<rostedt@goodmis.org>, <vincent.guittot@linaro.org>, 
	<vschneid@redhat.com>, <ziy@nvidia.com>, <riel@surriel.com>
Date: Thu, 29 Oct 2026 16:16:55 +0800
References: <20261028041253.74839-1-lizhe.67@bytedance.com> <20261028041253.74839-4-lizhe.67@bytedance.com> <de52b5f1-97eb-4404-b7f1-53f0aab17fae@amd.com>
Subject: Re: [PATCH v2 3/3] sched/numa: fix scan-period adjustment for tiering-only mode
Message-Id: <b17f7fcf-0c7e-49b8-a7be-779f3c5e97d2@bytedance.com>
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <de52b5f1-97eb-4404-b7f1-53f0aab17fae@amd.com>
X-Lms-Return-Path: <lba+26ae30110+79dbb1+kvack.org+lizhe.67@bytedance.com>
Cc: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Stat-Signature: p6akeo5w5psjy8tfkwmp9qphf895yt7r
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 68C32100003
X-Rspam-User: 
X-HE-Tag: 1793261851-767341
X-HE-Meta: U2FsdGVkX18NpQCpCIAVh2VfSL812fpAgEEpeDFnF7AoLttztnWYI3bTFeSUEjLvwsuaT9OP0FWPLu/kf46SucG+RC6yigZi/1QsVXXNnIxQNLnGAV1Zdo2bQI8f/OdogEhnye1tVW7aOJLytouRFwoUWiGdVO2hb7tcTWUIRYbaie3Yq2tEiy738Cq5GWC7nQQVLS9WX/hQGuYZ9L6xDXZOGPwnN1NX+TbW5Tz5JZuXYUPZmO69C8J9dKWrpLCW+2tQiy9OeqcfY+RU5jOAPfxPne5lvITt9THH69o42tqSR6P+LjAp6z4kUx5oWpZaYwXhbQ4VMiXJmZgoYjZDG+sEU20wgLfCdU07iLbFe7gko7DQNx+DW8A0fZH/C/g1JH+U8wI2NVxQ7FBx2MrExFGEZ4d3vHIjZT4l6ddC8BbgMHh5ySrnKe57QvbfxZC5nNQHKXZmrZud9zN7DL13L/NW3/433huV/3Isdh96EVl/VywHbcsWRmy0no046m9/SPIrn1G/3f7oQt2+4ywbRLRXrSq0CL1BHoAl/aFBda0aN8t4Dt8Qags+JTmXzVq5gceo3X3JrNvhBOITHFJce0duf3PRLoHHyQqHI4spPAWDgsUi1G1G6P+pk4Q9zX9I2v5gI6Pv272b5y1oPrCfa97cIUL6NvCkwD6WKsU2j5EVGneKsIWBQ9qw1//FQCATYNlqCZfi5GESnSbfSOeDc9OTDekaTBsa4dOdQYNdXn7ssnsT1dQ1QAfGdb+hLVYTiSlBR1uyjl4uhfiWUKxM5adlYwg9nGGA1gyNrMH6xYu/DtUMuM6Qjgav+P1+xaqkt4n8KmVW5lY7WSt2TNyuQp45my6QG2c9JExBTsfgDuUs0Wk19POmZchMRCyaNyzi8dreW8dRZU96RrWHJMu0AitbaXUngp1k18nDncPUc7gAy/cBk8BFRkrvj0rzOPECvCm+PW8wArlJWv1LwGT
 1VwVBhH1
 Urw1IXzUB4MEQwAFIzHpV7u1vd0yrj9rjJV81lV+8BG2jNslEIrI7awVfvzQfjNT752m9imD91L0FxzNBnBG3y2E0jbkFd9p2FuTXjeOngS0tF0wUjLRWhlnwFkXv6ndy6FkFgUvkHAyZ8aMTdVfpBQdURzB02nOaE74XxZV3beqjTwmvGAxk1IvqPNum9OGCIf0lNgrrLPODrAljRgicRQi5oqC8/4r+yfinjQho1teOh3wihik+9jry2QatR2/yEoLRZzoD7Szrv4h0qEuKwq/OpDoHpR4YtkjTSIBtYfB41owIuhISj30U7PutwNoI4Qby58GTHrgR2jb/LQnSSiFJgiRQDgb337ZsSeUd2QFNSBlRdlwubJ6guQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 2:21 PM, Bharata B Rao wrote:
> On 28-Oct-26 9:42 AM, Li Zhe wrote:
>> When automatic NUMA balancing runs in memory-tiering-only mode, NUMA hin=
t
>> faults identify slow-memory pages that are worth promoting. They are not
>> normal task-placement feedback.
>>
>> Without separate tiering feedback, successful tiering promotions are fed
>> to update_task_scan_period() as private remote faults. That leaves
>> local =3D=3D 0 and shared =3D=3D 0, so the function hits its early slow-=
down path
>> and doubles p->numa_scan_period. Repeated promotion feedback can therefo=
re
>> drive the scan period towards the maximum.
>>
>> Track memory-tiering feedback separately from normal task-placement stat=
s.
>> Successful free-space bypass promotions are not counted as tiering scan
>> feedback because they did not pass the hotness and rate-limit checks. Co=
ld,
>> hot, and throttled feedback is generated only by the hotness/rate-limit
>> path, while migration failures slow scanning like the normal placement
>> heuristic does.
>>
>> Use the same 70% threshold style as the normal scan-period heuristic. A
>> hot-dominated window speeds scanning up, a cold-dominated window slows i=
t
>> down, and a throttled ratio of at least 30% also slows it down. If a
>> window has no tiering feedback, for example because promotions used the
>> free-space bypass, double the scan period, following the same
>> no-useful-signal slow-down direction as normal scan-period adjustment.
>>
>> Evaluate the tiering window when a scan sequence completes as well as wh=
en
>> tiering faults are reported. This lets an empty window back off the scan
>> period after qualifying tiering feedback stops.
>>
>> On a CXL system with node0 as DRAM and node3 as slow-tier memory, a
>> STREAM Triad-derived OpenMP workload was used to model a
>> bandwidth-sensitive working-set shift. It first accessed one 100G range,
>> then switched to another 100G range. The workload was first-touch placed
>> on node3 and then run from node0 with memory-tiering-only mode enabled.
>>
>> With the free-space bypass disabled, so that promotions have to pass the
>> hotness and rate-limit checks, a kernel with only the bypass control was
>> used as the no-feedback baseline. Tiering scan-period feedback improved
>> the transition window after the active range switch:
>>
>>                                no feedback       tiering feedback
>>    first 80s after switch       122.4 GB/s             129.3 GB/s  (+5.7=
%)
>>    200-240s after switch        139.9 GB/s             140.6 GB/s  (+0.5=
%)
>>
>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>> ---
>>   include/linux/sched.h                |  17 ++++
>>   include/linux/sched/numa_balancing.h |   9 +++
>>   kernel/sched/fair.c                  | 113 ++++++++++++++++++++++++++-
>>   3 files changed, 137 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 1c93da75226e..c4959747374b 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -833,6 +833,16 @@ struct task_ipi_mask {
>>   struct task_ipi_mask { };
>>   #endif
>>  =20
>> +#ifdef CONFIG_NUMA_BALANCING
>> +enum numa_tiering_fault_stats {
>> +	NUMA_TIERING_FAULT_COLD,
>> +	NUMA_TIERING_FAULT_HOT,
>> +	NUMA_TIERING_FAULT_THROTTLED,
>> +	NUMA_TIERING_FAULT_MIGRATE_FAIL,
>> +	NR_NUMA_TIERING_FAULT_STATS
>> +};
>> +#endif
>> +
>>   struct task_struct {
>>   #ifdef CONFIG_THREAD_INFO_IN_TASK
>>   	/*
>> @@ -1433,6 +1443,13 @@ struct task_struct {
>>   	 */
>>   	unsigned long			numa_faults_locality[3];
>>  =20
>> +	/*
>> +	 * Memory tiering faults are tracked separately from normal NUMA
>> +	 * placement statistics. In tiering-only mode, slow-memory hint faults
>> +	 * are used to decide promotion, not task placement.
>> +	 */
>> +	unsigned long			numa_tiering_faults[NR_NUMA_TIERING_FAULT_STATS];
>> +
>>   	unsigned long			numa_pages_migrated;
>>   #endif /* CONFIG_NUMA_BALANCING */
>>  =20
>> diff --git a/include/linux/sched/numa_balancing.h b/include/linux/sched/=
numa_balancing.h
>> index 200f50075d5c..12f31ed56d66 100644
>> --- a/include/linux/sched/numa_balancing.h
>> +++ b/include/linux/sched/numa_balancing.h
>> @@ -8,6 +8,7 @@
>>    */
>>  =20
>>   #include <linux/sched.h>
>> +#include <linux/sched/sysctl.h>
>>  =20
>>   #define TNF_MIGRATED	0x01
>>   #define TNF_NO_GROUP	0x02
>> @@ -16,6 +17,14 @@
>>   #define TNF_MIGRATE_FAIL 0x10
>>   #define TNF_ACCESS_TIME	0x20
>>  =20
>> +static inline bool numa_balancing_tiering_only(void)
>> +{
>> +	int mode =3D sysctl_numa_balancing_mode;
>> +
>> +	return (mode & NUMA_BALANCING_MEMORY_TIERING) &&
>> +	       !(mode & NUMA_BALANCING_NORMAL);
>> +}
>> +
>>   enum numa_vmaskip_reason {
>>   	NUMAB_SKIP_UNSUITABLE,
>>   	NUMAB_SKIP_SHARED_RO,
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 136207b62d87..1d9efc2b7427 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -2760,6 +2760,32 @@ static inline bool cpupid_valid(int cpupid)
>>   	return cpupid_to_cpu(cpupid) < nr_cpu_ids;
>>   }
>>  =20
>> +static void task_numa_tiering_placement(struct task_struct *p);
>> +
>> +static bool task_numa_tiering_update(struct task_struct *p)
>> +{
>> +	if (!numa_balancing_tiering_only() || !p->mm)
>> +		return false;
>> +
>> +	task_numa_tiering_placement(p);
>> +	return true;
>> +}
>> +
>> +static void task_numa_tiering_no_feedback(struct task_struct *p)
>> +{
>> +	task_numa_tiering_update(p);
>> +}
>> +
>> +static void task_numa_tiering_fault(struct task_struct *p,
>> +				    enum numa_tiering_fault_stats stat,
>> +				    unsigned long pages)
>> +{
>> +	if (!task_numa_tiering_update(p))
>> +		return;
>> +
>> +	p->numa_tiering_faults[stat] +=3D pages;
>> +}
>> +
>>   /*
>>    * For memory tiering mode, if the target fast memory node has enough =
free
>>    * pages, recently accessed slow memory pages can bypass the normal ho=
tness
>> @@ -2887,6 +2913,7 @@ bool should_numa_migrate_memory(struct task_struct=
 *p, struct folio *folio,
>>   		pgdat =3D NODE_DATA(dst_nid);
>>   		if (numa_balancing_promote_free_space_bypass &&
>>   		    pgdat_free_space_enough(pgdat)) {
>> +			task_numa_tiering_no_feedback(p);
>>   			/* workload changed, reset hot threshold */
>>   			pgdat->nbp_threshold =3D 0;
>>   			mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE_NRL, nr);
>> @@ -2899,10 +2926,18 @@ bool should_numa_migrate_memory(struct task_stru=
ct *p, struct folio *folio,
>>  =20
>>   		th =3D pgdat->nbp_threshold ? : def_th;
>>   		latency =3D numa_hint_fault_latency(folio);
>> -		if (latency >=3D th)
>> +		if (latency >=3D th) {
>> +			task_numa_tiering_fault(p, NUMA_TIERING_FAULT_COLD, nr);
>> +			return false;
>> +		}
>> +
>> +		if (numa_promotion_rate_limit(pgdat, rate_limit, nr)) {
>> +			task_numa_tiering_fault(p, NUMA_TIERING_FAULT_THROTTLED, nr);
>>   			return false;
>> +		}
>>  =20
>> -		return !numa_promotion_rate_limit(pgdat, rate_limit, nr);
>> +		task_numa_tiering_fault(p, NUMA_TIERING_FAULT_HOT, nr);
>> +		return true;
>>   	}
> I like the separation of scan-period updation of tiering mode from the re=
gular
> mode as the existing update scheme was dependent on private/shared faults=
 which
> made little sense in tiering mode.
>
> However I am not sure if you should drive the scan period updates from
> should_numa_migrate_memory(). The scan period belongs to the hint fault
> scanner. I am pulling the promotion heuristic out of
> should_numa_migrate_memory() in the pghot series. The hint fault path
> only reports an access and shared engine does the classification and
> migration for every source. The other sources may not have numa_scan_peri=
od,
> so this feedback has to stay with the hint fault path.
>
> pghot supporting multiple sources may not see the light of the day in
> near future but it is still good to keep the source specific
> aspects and promotion engine separate.


Agreed, that layering makes sense.

I am wondering whether that separation is better handled together with
the larger promotion-engine rework, though.=C2=A0 Without the shared engine=
 in
place, moving the outcome reporting out of should_numa_migrate_memory()
would add interface changes mainly for a future direction.

For this series, my goal was narrower: keep tiering-only scan-period
feedback separate from normal task-placement stats while staying close
to the current numabalance implementation.

Thanks,
Zhe

>
> Regards,
> Bharata.

