Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D4E81094472
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 12:16:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F9BC6B00AE; Sat, 21 Mar 2026 08:16:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AA406B00B0; Sat, 21 Mar 2026 08:16:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 698656B00B1; Sat, 21 Mar 2026 08:16:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 56B8E6B00AE
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 08:16:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F0F21592E0
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 12:16:45 +0000 (UTC)
X-FDA: 84569968770.15.1CB996E
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf10.hostedemail.com (Postfix) with ESMTP id 71CA8C000E
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 12:16:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=VpLiTuTk;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf10.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774095403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ozJ0HqaLDZv97nkwv+eSi7D5aVwxld4Ey2yfqN6yr/M=;
	b=cgmMUQOMr7Aj9H3LuvWjXNUO5GZUCvV5jD3J+hjL4D7rW7lIHdZu+GF0lsdA8mL+AZjj66
	+J45lPrfIrm5LpkmKcyfPLGgXgavsk58elG9eNqxEgHJM/Sff0qyVAktfqYeD6rmIohqqS
	uhgLK4smpQSskej5vADdRSth5A+YeAc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774095403; a=rsa-sha256;
	cv=none;
	b=4FZBgprvtDOkDmcxZ8YHp+b2xUNYcUugN02f+73eajhabY3Nry6waNTZK1vugpxwFQuZ4f
	1I1jehurQVXf6r5xvEM1afRs28gx/6Wipwm5POibwFG/79CC81EReH83XP6MOPQ5nKNF9v
	RCVEXvzIms18kozV2ncHG+0tbWcpR34=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=VpLiTuTk;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf10.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62LAtEs7730725;
	Sat, 21 Mar 2026 12:16:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ozJ0Hq
	aLDZv97nkwv+eSi7D5aVwxld4Ey2yfqN6yr/M=; b=VpLiTuTkbOsXLiDaHznhJE
	nDqanW4y+sYlme0kbTd4VMXUhF3uaG9Sl6JZ+Hk4ywwmJIusfbH9wz5D8m0lYlJj
	A9wGIRYP0ArGz6dN0fd63EbhH1vquYqVRmxOj7co8eNk6e+XdyfLutrWbuX7ewUq
	HOLOAxPkxCkuVEB2JwH92KjOfs6h4XI02p8UHyg2DTN0tRSJeLg/IQMIOb6jhUVs
	9lnRQvU/LCZMgh+70D3f2T/aJehMHszyMDI45oEgTabanwm1mUIXcfTMLhVV9x6X
	pUpAVyyZ0s8FGQVilNaNsVPRc5YjdRaioIfim4nZmuxRo0cJIx2bQyacyAJ7Ylfw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1kum8ure-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 21 Mar 2026 12:16:25 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62LA5jcJ026460;
	Sat, 21 Mar 2026 12:16:25 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cwjcykj5g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 21 Mar 2026 12:16:25 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62LCGOUj46530840
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 21 Mar 2026 12:16:24 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5EE2758058;
	Sat, 21 Mar 2026 12:16:24 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 43BAA58057;
	Sat, 21 Mar 2026 12:16:18 +0000 (GMT)
Received: from [9.39.24.104] (unknown [9.39.24.104])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 21 Mar 2026 12:16:17 +0000 (GMT)
Message-ID: <4da952b8-9aa3-4bfb-b97e-475140c8f348@linux.ibm.com>
Date: Sat, 21 Mar 2026 17:46:16 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] memory tiering: Do not allow promotion if
 NUMA_BALANCING_MEMORY_TIERING is disabled
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ritesh Harjani
 <ritesh.list@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ying Huang <huang.ying.caritas@gmail.com>,
        Juri Lelli
 <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>
References: <20260320092251.1290207-1-donettom@linux.ibm.com>
 <20260320092029.7b2e2a9f24bfd5197541223e@linux-foundation.org>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260320092029.7b2e2a9f24bfd5197541223e@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: tzBYyfZIsd4q9bXCoMGKADVa6s5KH0Xl
X-Proofpoint-ORIG-GUID: Fs8QDHZ5wmL5vg-azeDwEI8FVlTu2a92
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIxMDA5NiBTYWx0ZWRfX7PmriAC4jJdx
 VEGtWQsnQ521jKsNtt5PnjdlDRq6tngeiXV+a38SLf9z0+zRccFdM7l4RLwS0srSlLMZ3fHJTuk
 sHlZcnZfMJi3KQmmSow+WOKfbJmPzie/2oghmneHmv2E7rgKNHocPD5qPhT3JOygIXvul0wS4dp
 jL8rsaxN7o1TQQdZxuIpwt/CEFCX0dZ/i43UjLGevkQHqKl6E2NKcEj2k9pWzhjnEL6Jr5Vz0im
 5n9fzSDMmIQ5GfE2ieBQMsFAXKrh8MN3/EejTB2kf3TqalkUVyNMPRR4WRWt4IbuF5SplRR41zq
 xTyMRspdQQGEFhLcz0736gsnxa98IS289a+l5pSUYP9LaAvkH8ZVHAmiW5Y2pn1gRQQkOkwSwxx
 ClNWkzEmQ3UCRFn0w1QdAvHN4QLndNZY/RWuwNR6a21FOZrY9rkiAT0QCvyj73J0qsMg/TQqD0l
 0t/+60riuzkiJLwzkLA==
X-Authority-Analysis: v=2.4 cv=KbXfcAYD c=1 sm=1 tr=0 ts=69be8c1a cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=c92rfblmAAAA:8
 a=VnNF1IyMAAAA:8 a=wYRj8PCSQ9afYsWexm8A:9 a=QEXdDO2ut3YA:10
 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-21_04,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 malwarescore=0 adultscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603210096
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 71CA8C000E
X-Stat-Signature: yce54nbq9ssyckh55fodsaynocdeyw5r
X-Rspam-User: 
X-HE-Tag: 1774095403-965783
X-HE-Meta: U2FsdGVkX1+ERJJd53VYOHucxM+Jp2KoNqblgj9c9xu7L3cshCyrovpTpuvQB+RJOVH1kG34SBYpQJ9hXGqHr2e4hKcgXMyvzeS0GeIa3VB14o4rhJYnLcSif0rgrR8tXqdfpzhmKrhPlREv9VzFcc/ZwJbE/hkk/QLylXiVau6lhda1/VWE/95631bLXfi9oeEk6hIC6gOZwlYjTYFB72wOVLwfgK6KtDm5VrtLS/0ZtChGPk7JwIyB2gB6a7EHD3WO229az7zMxunfv01C+HsgVIo33LiQ+1m1jjnQi8vYiAZ7jyM/oFhRqG3vsMEX/cLFPrs/ib+6ZSFWVYBzPqEGxczuGVywJP7pjxK7rGHYPkrOHRxfLZpPvHPWAqRD9NhS2BqFVEKm+oX2io1SzDVlbJ/3NQWD9QiQNzAtS1WcphD3T0Y+hsYG6DTEnyM4wMa1v3MvEn9CAUE3s7eUm1AIQgmnBKq7fENn+NJ4XaIOwJ7z4O1hbKQjV3JaJ1dl1FLVXFRmTQ9WLHtW00lmlWNERkIr/wppJ04TCDTqt1vYVep31zbzYCvVRz5QhoK5D80dt7wwN0F9KgVXfM7oZQL9jKMa9WMjlGjZbNRr6xL4u2rWHlL6DW04cs7SWZwhCcIcr+EcyhCA7aiH1jDoyhtpIjKtmBBJsg4KEE/QE1GT+wJ7K++bi+IZxQ9tERDcWKlo+SjApukvkRIWwmWswiyhR/dYh85MdO+TZ7YZ5C4pZugyS69SDcBA7/nVEi8VqV4vrWyurygXmxqRPCuRCTp2JIr3sDs4SSDTfKbFKMqY3Ung9H07+d5hD7IpJWylV99nwHvtu389OLgAlu9yle3f2bj8ImbrCXb5lCPyVksZjzYvrWrA11yj+zu3wmT1yG1A2UN02IJpt43XSnqecubOCU5VWPz+/iBCcZO72L3/0o1vBWfvhAKskssvh7R4GIgf+qUoXE9thlMXFMl
 6DQhGAFB
 wYtJi5wzlpnKpi7AqjuCrW7DRgOFDchuu8+okpqalpyk3CjuDK6JpWbtppARPEC6u22OCF615IIJd8/0/GWj8Y32Z5BjY0Vm32ZFjdSQNC1oYMpY50nx0tKvltEIfd7BF6lR6NG+bt1ZCIHWynlYOzPzuzl45GFfSAljYwxo+/YWWLubd793bw2oFKQ/AgxArHc9ifk1hfp69Q0icrcSWZe1vLWCufhoewA0jHileOxra0B7syjayZ/zZzdTWQEGqCa1mcwL9mjw2HbJU1MzCAwkE43NUcpANtLpmzChPXwh2z3W6Ri6UUWIOVD5353MWGLEAGwXXOfyEdgb6YD1atuU6v5kMuOf3iDwvXb14eEDfFG3mxbeTbqyRAOPVmdPH2EDqdijxCKd/OlojGMhrtASV2nPZgnFhIIuwQzuvqj66PTE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 3/20/26 9:50 PM, Andrew Morton wrote:
> On Fri, 20 Mar 2026 14:52:51 +0530 Donet Tom <donettom@linux.ibm.com> wrote:
>
>> In the current implementation, if NUMA_BALANCING_MEMORY_TIERING is
>> disabled and the pages are on the lower tier, the pages may still be
>> promoted.
>>
>> This happens because task_numa_work() updates the last_cpupid field to
>> record the last access time only when NUMA_BALANCING_MEMORY_TIERING is
>> enabled and the folio is on the lower tier. If
>> NUMA_BALANCING_MEMORY_TIERING is disabled, the last_cpupid field
>> retains a valid last CPU id.
>>
>> In should_numa_migrate_memory(), the decision checks whether
>> NUMA_BALANCING_MEMORY_TIERING is disabled, the folio is on the lower
>> tier, and last_cpupid is invalid. However, since last_cpupid remains
>> valid when NUMA_BALANCING_MEMORY_TIERING is disabled, the condition
>> evaluates to false and migration is allowed.
>>
>> This patch prevents promotion when NUMA_BALANCING_MEMORY_TIERING is
>> disabled and the folio is on the lower tier.
> Thanks.  The AI reviewbot asked some questions:
> 	https://sashiko.dev/#/patchset/20260320092251.1290207-1-donettom@linux.ibm.com
>
AI review questions

> commit b0847daa3e0064d33d2232cba1d7607919cae7db
> Author: Donet Tom <donettom@linux.ibm.com>
> memory tiering: Do not allow promotion if NUMA_BALANCING_MEMORY_TIERING is disabled
> In the current implementation, if NUMA_BALANCING_MEMORY_TIERING is
> disabled and the pages are on the lower tier, the pages may still be
> promoted.
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -2060,6 +2060,13 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
> >  	 */
> >  	if (!node_state(dst_nid, N_MEMORY))
> >  		return false;
> > +	/*
> > +	 * Do not allow promotion if NUMA_BALANCING_MEMORY_TIERING is disabled
> > +	 * and the pages are on the lower tier.
> > +	 */
> > +	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
> > +	    !node_is_toptier(src_nid))
> > +		return false;
> Does this block all migrations originating from a lower-tier node when tiering
>
> is disabled, including valid same-tier migration between two 
> lower-tier nodes?
>
This blocks migration (promotion) from a lower tier to a higher tier 
when tiering is disabled. However, migration within the same tier will 
still be performed if NUMA_BALANCING_NORMAL is enabled.

> Conversely, since this only checks !node_is_toptier(src_nid), does it still
> allow cross-tier migration from top-tier to lower-tier nodes when tiering is
> disabled?

Migration (demotion) from a higher tier to a lower tier is not handled 
by NUMA balancing, so it will work irrespective of this setting.

> Also, because this early return is placed before folio_xchg_last_cpupid() is
> called, does it prevent lower-tier folios from overwriting their stale
> _last_cpupid timestamp with a valid CPU ID? This could permanently freeze NUMA
> access tracking for these folios and inflate private fault statistics.


No, the timestamp is only stored when NUMA_BALANCING_MEMORY_TIERING is 
enabled.


> [ ... ]
> > @@ -2094,10 +2101,6 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
> >  	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
> >  	last_cpupid = folio_xchg_last_cpupid(folio, this_cpupid);
> >  
> > -	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
> > -	    !node_is_toptier(src_nid) && !cpupid_valid(last_cpupid))
> > -		return false;
> > -
> This isn't a bug, but since the only usages of cpupid_valid() were removed
> here and in task_numa_fault(), should the definition of cpupid_valid() and its
> accompanying comments also be removed to avoid leaving dead code behind?


Yes, We can remove that. I will send a V2 with that change.


> [ ... ]
> > @@ -3312,8 +3315,7 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
> >  	 * node for memory tiering mode.
> >  	 */
> >  	if (!node_is_toptier(mem_node) &&
> > -	    (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ||
> > -	     !cpupid_valid(last_cpupid)))
> > +	    (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING))
> >  		return;
> If memory tiering is disabled at runtime, existing folios on slow nodes may
> retain an access time stored in _last_cpupid instead of a valid CPU ID.
> By removing the !cpupid_valid(last_cpupid) check, could this timestamp be
> treated as a valid CPU ID and passed into task_numa_group()?
> Inside task_numa_group(), cpupid_to_cpu(cpupid) could then extract an
> out-of-bounds CPU index, which might lead to an out-of-bounds read when
> accessing cpu_rq(cpu)->curr and cause a kernel panic.

Yes. This is also a valid point. Let me fix this and send a v2.



