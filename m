Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 032791073CBA
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 13:20:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44C326B008C; Wed,  8 Apr 2026 09:20:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 423706B0092; Wed,  8 Apr 2026 09:20:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 339ED6B0093; Wed,  8 Apr 2026 09:20:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 22A6F6B008C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:20:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB0A6C0127
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:20:47 +0000 (UTC)
X-FDA: 84635448534.21.2C4F674
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf13.hostedemail.com (Postfix) with ESMTP id 348D52000E
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:20:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PXMTi0Op;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf13.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775654445; a=rsa-sha256;
	cv=none;
	b=4R4kfFHFvKOR65GRWR3xaUNmG4LlsSbPb2SnnoydU22/azSHJ0tEIe8kbn1H0rTCv0Mje9
	oaD7QmtcoXROLRR9B/geVBDkvHaHZJNb1fW97i0bcCtHeWtUvOaCoGqhB1me+ZWTD/dbdI
	6OjVUAQCaC/4Si+6KmDFxVeXCaT8A/8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=PXMTi0Op;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf13.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775654445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e8bPcvcIzJyK6kRZL9kR/A30X7jPJf4QySAPTCL+Ea4=;
	b=Lm5lVaBAf4uPx5coCNiqVKaJc0n8r4Rxp0eI7IScNDeB6a4qByIwEDV02O0o3lR9Z6tGl+
	1pXGu+a+BRcFZLxDJM/jMISv7QHSVbuUvUmjO7PEKjDi6nzdGtnZCfvxDbqBrIo1mqmEOn
	uRgrtNry8XXmX9AcW3lcN9CX3mNFhV0=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63859rto2316389;
	Wed, 8 Apr 2026 13:20:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=e8bPcv
	cIzJyK6kRZL9kR/A30X7jPJf4QySAPTCL+Ea4=; b=PXMTi0OpDIjipFjxtn8Pet
	1mYJagV4mtL66p3ugHphoNzeAtxBpNx9DWeEjQze7c7562DkGnXueysL/NE1f8gQ
	/AyxtzDQiwsbf0CTfQoK2cQUeAnnWYx43YguCkKu/oVa4ygXYe4WFCkAqdZ+xig6
	hkKSRfx5MEOGPu2LsSuEEYH+LkjrYU3NISenIcbqRV2t/cuCI8kVfGWK/Op853ph
	xD+75ioefZQdn+VBLCJj/n/8UNl425Md1RLXkxxIOlDeuXxSlZM1GNyryl8BUalQ
	lV/UJLkM7t3nX8bvEPlhrW3sTj8+YB4aw+Obu248Qnho4iGMPy+eaooERnxVelbw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2g05tb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Apr 2026 13:20:35 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 638BXJ0K030068;
	Wed, 8 Apr 2026 13:20:33 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dcme7fh7a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Apr 2026 13:20:33 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 638DKXBB23986772
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Apr 2026 13:20:33 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2C80D58051;
	Wed,  8 Apr 2026 13:20:33 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A77325805C;
	Wed,  8 Apr 2026 13:20:29 +0000 (GMT)
Received: from [9.123.6.34] (unknown [9.123.6.34])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Apr 2026 13:20:29 +0000 (GMT)
Message-ID: <bd78aaa2-888e-4c27-964b-09f085161224@linux.ibm.com>
Date: Wed, 8 Apr 2026 18:50:28 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] memory tiering: Do not allow promotion if
 NUMA_BALANCING_MEMORY_TIERING is disabled
To: "Huang, Ying" <ying.huang@linux.alibaba.com>,
        David Hildenbrand <david@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ritesh Harjani
 <ritesh.list@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ying Huang <huang.ying.caritas@gmail.com>,
        Juri Lelli
 <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>
References: <20260323094849.3903-1-donettom@linux.ibm.com>
 <87wlyqt52m.fsf@DESKTOP-5N7EMDA>
 <c571bb69-82f2-4346-9f99-6a7258e28a27@linux.ibm.com>
 <87o6k1ubg4.fsf@DESKTOP-5N7EMDA>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <87o6k1ubg4.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=FKArAeos c=1 sm=1 tr=0 ts=69d65623 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=ESUxZHs4Y10jlcsJB78A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 0YSAus8SWVZUsOOaeqGHqnSDuLoSa6s2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDEyMyBTYWx0ZWRfX8Q7MjT3ImqcR
 /AvitQjN05HE28yFkuJMuQVxau6Ga3LG3HEq2SV5DNALsgKbKU+PKbr9we+eB8wrzpTpBkzklZ+
 iuPXmbnf9N5k8biAot994LG5SusA118y9fh0gfHilJUDfTqgv1XGcgmWQr7lQomAbNrUkLDA8ib
 UNemUtRncH/mGl3+jbYklNj7JSGlL1x0R4XG04j3LZnAOtK7SeOOCN1cJvxsYNb5qvABCrsmhrJ
 A1MfhBlfJsLWyFi00Xe/WZJZjF+b1pSwGmC1VV9/RXglvplkn5zf+aRocepQkgmjGjgbz8mL4U6
 tVmah5FHq3kbHYAalrFCnYsonxAbKwZIHA8omQoZdgYWoJ86qcDRjkWswD0cWeMWIEPFZJybViN
 Cy1QEKtIC9wgcN1xhj5zj23ypa7tGrxdZTqcjqxnIYupkv6LcVJWf8WNQg5g7aDIKgCxm4lhCTa
 5K8eN5Jr1I8DqOPWR2w==
X-Proofpoint-GUID: -xFPlurDSO7vd31GKPP8HsOJ3b5MGvyk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-08_04,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 adultscore=0 bulkscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604080123
X-Rspamd-Queue-Id: 348D52000E
X-Stat-Signature: ysztt83mr5qbafujudx9fppr8sdpup6h
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775654445-699851
X-HE-Meta: U2FsdGVkX19tt6P7kP0ond/k9Pk5HRbOZ5x/01N8hw5NKAm1pM81tVBf/AUDmIfME2U2PoI9s42h5IDVymZOg3dPjYu4Lr6f5/yeV1EybUIzu684/sz+7e20Aue6D57iR5Mk+4NrLQroB9FsN+OWrlppw7uBlK4whMpWCHxBSrOPInW/Lev47s5XjcgsCS7NmVpwWROj+zsXtYz8Qc8hONXjb2+A0daZ38LTGXF5q+dzQjs4Q6wCvSw6QA4hASIssQphn5ujydwkABc1jhgh8e44UCpcMleAwxZ6hFmJluOm/HtVSmbypjUQ5T+ol/XX9bPsKatb5C4quwfxpFAEX2wCHVhtUTosHcaUMOshspfYufbKXOhWqR2iij+iMZTuuzAUkKoXHjQaQADrxPHOYx1ChBgwDraBRUzStsfWcfB9NQJAOfOB51a7OQtaHq4XC886eKGucgPNvBWyESOC8BqFLNBdESmdFhL7VNTSy8fKxwjiQ9V6kQiQ75bOJqcBceIEsKhIEwNGjI/5QLwgFggiOccOfNGRy270CID3F81WbO2U6QH8OQGsXrTii5uFoLYCVBPRZSDLr82+j+LaFb0qiSaMIYoXe5BSA/S9s3K9rmd6ARNYWW7YRSB01PEw81QJyz0MgU9IeD29zoPTZv1g4hCZOZK34yZqtpxTEFm3KNlpzNsLCziRcrU4t58d/jI7QzeflbRxB70gadCwfwJvC9KDV/nX+gFStwWOJaek3J9oXCVDqwJiT/9alIt3bDR0b7VNZTroZHplfVJBHDx5D8NztSWVt3etqCgsm5j81Ik+jRdsYyMdgHS7RxoQc8hHf5qLx2toTgQkw4QmWz47d9mAnIsYey8cap/FHkqwuwq0sHHLGxVhGPY4D1/9u+B6CSdKJeaDRa3AoMkBolyD6ibhodgvAyGjxVdSBqahJKAcw5cEx5LPnuQv1IDnsvN4H4rYvK/Sj9hcNPU
 o+n5jh1p
 guBHuBFdln0fU3DyYG7Ur49EMTNThybHL2m9d7ek5QA6ezcONpz3htXN1lhOZS07kDBqc8GHTFhZTf8qgwRmkZx/ATpfMnJQKTNbS5+2g2fNgFMTI5BlFV23xfqWnLMTIGBpQsVExUTGy6ziRD7diaeG8v4CUxuHr2AL+EhCbRqxO/CKLO7K/Nb4OBGZwXaqliNmHDSmo0NJkcfLsT+JM3547iA0Q35hIjrS0byTTxeB5ZdTw5fR9rIP1rpXyqY5FRR8bnW0MRXLLptyqmwkg4gbfNUXGySS2Op6D8eczfVm/jMOCM7mWr1JQKwEYmswUnpzFCcXHxV4zFFbxwhjTxFaEN4e4SESLSlShDlOUqMTqrChrB2ZFFQQG5oz8q2iiP5lt0xCy6yw5Uu0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 4/2/26 11:54 AM, Huang, Ying wrote:
> Donet Tom <donettom@linux.ibm.com> writes:
>
>> Hi
> Hi, Donet,
>
>> On 4/2/26 8:57 AM, Huang, Ying wrote:
>>> Donet Tom <donettom@linux.ibm.com> writes:
>>>
>>>> In the current implementation, if NUMA_BALANCING_MEMORY_TIERING is
>>>> disabled and the pages are on the lower tier, the pages may still be
>>>> promoted.
>>>>
>>>> This happens because task_numa_work() updates the last_cpupid field to
>>>> record the last access time only when NUMA_BALANCING_MEMORY_TIERING is
>>>> enabled and the folio is on the lower tier. If
>>>> NUMA_BALANCING_MEMORY_TIERING is disabled, the last_cpupid field
>>>> can retains a valid last CPU id.
>>>>
>>>> In should_numa_migrate_memory(), the decision checks whether
>>>> NUMA_BALANCING_MEMORY_TIERING is disabled, the folio is on the lower
>>>> tier, and last_cpupid is invalid. However, the last_cpupid can be
>>>> valid when NUMA_BALANCING_MEMORY_TIERING is disabled, the condition
>>>> evaluates to false and migration is allowed.
>>>>
>>>> This patch prevents promotion when NUMA_BALANCING_MEMORY_TIERING is
>>>> disabled and the folio is on the lower tier.
>>>>
>>>> Behavior before this change:
>>>> ============================
>>>>     - If NUMA_BALANCING_NORMAL is enabled, migration occurs between
>>>>       nodes within the same memory tier, and promotion from lower
>>>>       tier to higher tier may also happen.
>>>>
>>>>     - If NUMA_BALANCING_MEMORY_TIERING is enabled, promotion from
>>>>       lower tier to higher tier nodes is allowed.
>>>>
>>>> Behavior after this change:
>>>> ===========================
>>>>     - If NUMA_BALANCING_NORMAL is enabled, migration will occur only
>>>>       between nodes within the same memory tier.
>>>>
>>>>     - If NUMA_BALANCING_MEMORY_TIERING is enabled, promotion from lower
>>>>       tier to higher tier nodes will be allowed.
>>>>
>>>>     - If both NUMA_BALANCING_MEMORY_TIERING and NUMA_BALANCING_NORMAL are
>>>>       enabled, both migration (same tier) and promotion (cross tier) are
>>>>       allowed.
>>>>
>>>> Fixes: 33024536bafd ("memory tiering: hot page selection with hint page fault latency")
>>>> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>>>> ---
>>>> v1 -> v2
>>>> ========
>>>> 1. Dropped changes in task_numa_fault() since the original changes
>>>>      already handle runtime disabling of NUMA_BALANCING_MEMORY_TIERING.
>>>>
>>>> v1 -> https://lore.kernel.org/all/20260320092251.1290207-1-donettom@linux.ibm.com/
>>>> ---
>>>>    kernel/sched/fair.c | 6 +++++-
>>>>    1 file changed, 5 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>>> index bf948db905ed..4b43809a3fb1 100644
>>>> --- a/kernel/sched/fair.c
>>>> +++ b/kernel/sched/fair.c
>>>> @@ -2024,8 +2024,12 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
>>>>    	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
>>>>    	last_cpupid = folio_xchg_last_cpupid(folio, this_cpupid);
>>>>    +	/*
>>>> +	 * Do not allow promotion if NUMA_BALANCING_MEMORY_TIERING is disabled
>>>> +	 * and the pages are on the lower tier.
>>>> +	 */
>>>>    	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
>>>> -	    !node_is_toptier(src_nid) && !cpupid_valid(last_cpupid))
>>>> +	    !node_is_toptier(src_nid))
>>>>    		return false;
>>>>      	/*
>>> No.  Even if NUMA_BALANCING_MEMORY_TIERING is disabled, we should still
>>> allow migrate pages from lower tier to higher tier via
>>> NUMA_BALANCING_NORMAL.  If we have precious DDR, why waste it?  This
>>> follows the semantics of NUMA_BALANCING_NORMAL before introducing
>>> NUMA_BALANCING_MEMORY_TIERING.
>> Thank you for the review comments.
>>
>> One thing I am trying to understand is that page promotion
>> appears to happen regardless of whether
>> NUMA_BALANCING_MEMORY_TIERING is enabled or disabled. In that
>> case, what is the specific role of
>> NUMA_BALANCING_MEMORY_TIERING? Do we get better performance
>> when it is enabled?
> You can search NUMA_BALANCING_MEMORY_TIERING to find out what it does.
> We can get better performance as the original commit message says.
>
> When NUMA_BALANCING_MEMORY_TIERING is introduced, we didn't change the
> original behavior of NUMA_BALANCING_MEMORY_NORMAL because we had no good
> reason to do that.  In fact, you change its behavior, so you should
> provide some supporting data or bug report to justify the change.
>
>> My initial understanding was that disabling
>> NUMA_BALANCING_MEMORY_TIERING could be used to turn off
>> promotion. However, it seems that currently we cannot control
>> promotion independently. If NUMA_BALANCING_NORMAL is disabled,
>> neither migration nor promotion happens, and if it is enabled,
>> both migration and promotion can occur.
>>
>> I was under the impression that:
>> - NUMA_BALANCING_NORMAL would handle migration within the same tier,
>> - NUMA_BALANCING_MEMORY_TIERING would handle promotion across tiers,
>> - and enabling both would allow both migration and promotion.
>>
>> This would provide more fine-grained control. Is my
>> understanding correct, or am I missing something here?
> You can change this, if you have some supporting data or bug report.


Thanks for the clarification. I was running some experiments where I 
only required migration, not promotion. However, I observed that 
promotion was still occurring even when NUMA_BALANCING_MEMORY_TIERING 
was disabled, which led me to believe it might be a bug, so I reported it.

As I understand it, enabling both NUMA_BALANCING_MEMORY_TIERING and 
NUMA_BALANCING_NORMAL results in both promotion and migration. Given 
this, do you see any concerns with modifying the behavior of 
NUMA_BALANCING_NORMAL?

With this patch, we would have better control over enabling and 
disabling promotion independently. I would appreciate your thoughts on this.


-Donet

>
> ---
> Best Regards,
> Huang, Ying

