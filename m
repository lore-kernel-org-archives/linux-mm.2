Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C50C2CC6B01
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 05:00:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33DB36B0089; Thu,  2 Apr 2026 01:00:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 316216B008C; Thu,  2 Apr 2026 01:00:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22BB36B0092; Thu,  2 Apr 2026 01:00:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 104C16B0089
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:00:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 93B818B96D
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 05:00:30 +0000 (UTC)
X-FDA: 84612415020.13.D5EC00A
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2846580008
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 05:00:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ZqUll3G9;
	spf=pass (imf30.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775106028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DuS59itpNZ6p8un83i/I/bgKIezxGQ4yoKFLnfZOn7U=;
	b=I5q5aJDPyRz2kUqZILF6bOffKxu68SZzuTxYnNwf+EbcV155+Sf03eBAGAYlJJrifLBrxl
	9imFo64yfdtABuA49BuWftDYSzWqZ21GjuwkHc2la0BuKrSS+JQ0jdtVKoSiFAnfib+Yv7
	1qfE3DStCh44cv3HGscO9gHviggoTbI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775106028; a=rsa-sha256;
	cv=none;
	b=0IcsMKl07eKuEaczHpoK5iIoww5cxjD+Vj6gxBtHP/vU9cruOumWq9rchd5AffrOdjQlVb
	Y72ebYxPnI3CIjhzLlxkZHdjEE5YxTVy8dW0f7GbvZiklnGdiUyzgcR3C+g69rGJYAhkXQ
	r+998cXYQ4iX0EWFMLCDvmvI37AWn28=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ZqUll3G9;
	spf=pass (imf30.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 631HVxme3226794;
	Thu, 2 Apr 2026 04:59:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=DuS59i
	tpNZ6p8un83i/I/bgKIezxGQ4yoKFLnfZOn7U=; b=ZqUll3G9t+c7aTqEwb0kWT
	xET5F+t3tcMYIk4lAYFykE0Dm+wOxMFGAEeec4fo3Vl2Howz/FdOvKAuxRyK8Uzf
	RyMDdxrrI5Tanjf3mh+jyxI59Ie82dD/rYx77IXAl2tSOgcJmfnolKU3kxsuiDEC
	4DtyYFG8Mo50wwFzacJ8UGxS81noPTx+Ee6ly06jdu7xW6Vf8k1fRZRi46TfDMWA
	gERKazoiKkeTzFBUq547ZYJNkIlVbMZfxK5YcIdcBIaNH8cWaPftgfTW5Z9kzCF3
	XKdh/jl/VSepIQe7B+lQlXTuZjnNFBi94xtVcrF9KSqluPduhHxf7YkPoKMXXkVw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d65dcjh1h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Apr 2026 04:59:47 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6321Pqbm008717;
	Thu, 2 Apr 2026 04:59:46 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4d6v11rfy8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Apr 2026 04:59:46 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6324xkkm21758648
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 2 Apr 2026 04:59:46 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3A8D95805A;
	Thu,  2 Apr 2026 04:59:46 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EF0E35805C;
	Thu,  2 Apr 2026 04:59:40 +0000 (GMT)
Received: from [9.39.16.6] (unknown [9.39.16.6])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  2 Apr 2026 04:59:40 +0000 (GMT)
Message-ID: <c571bb69-82f2-4346-9f99-6a7258e28a27@linux.ibm.com>
Date: Thu, 2 Apr 2026 10:29:39 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] memory tiering: Do not allow promotion if
 NUMA_BALANCING_MEMORY_TIERING is disabled
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
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
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <87wlyqt52m.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=RsjI7SmK c=1 sm=1 tr=0 ts=69cdf7c4 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=PC59MWEQhskA4QNmMdsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 1A7z-MPneXxD6XHBHI5OhlkXscWO5Q20
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAyMDAzOSBTYWx0ZWRfX6J8GcRq8Wny0
 XGC05xrpTSMlK5wFLEh44QRmTqIL76OtJygtCRc0xVI/V0CjpFmYTV3HVXIuLomQtgfcxY2lFKG
 iWxMACBz6f1J127/lORiCfSKakkk1zf7mTN1Q9CHMlMZSbM9AssQxVVLvcMl+b5DqMI3M+zPwq+
 T6+xbIvN+2TdIAspZdXKQblxitWlrVtVpH8qrDJhfecZSNrQHvFKFUaEnThw/GGcvp/jqOVoFRG
 3cj1j6lIVcYTFqZoJgY7XATxnlwn8/5pFiVFl0cTNpPO7l+AtFxNOCrRgsZtZP4ZTU5ZPK/HWNP
 ooB0hcLJxvoNvrLRucZIsEdpH/9Hd2kKFHzcdk1aS6lqKqcIuCn4X5VlTv5xuUa6bKadVBIB2sy
 Zj9hBPM+IoVWErNpj3fvTr2Nek8deH2cltOvTIrK+uSKqUsR/Mb9cqfgcWEAlfT16WJfSiLK8yn
 6tMqyH/+yWhxKkZUBOw==
X-Proofpoint-ORIG-GUID: shFjkzBAttWQwC56Nx4fJRpExUVSVbAF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_01,2026-04-01_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 malwarescore=0 spamscore=0 clxscore=1015 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2604020039
X-Rspamd-Queue-Id: 2846580008
X-Stat-Signature: d7x9cymjj3ttp3enb1wys4hstu4uu1tg
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775106027-327898
X-HE-Meta: U2FsdGVkX18YULyc0UkrJeb4U2IWIWr7hNMgVVfbRDdS+t97agrwwlA+EelS4+Z8cl61jKW1Syoj/hKfHvMb8J2cbNmpX5Ry/BIA6RYHNJoamfGNEZuv3rvTz30dtSXEMF0zWFfaRIdWMqIBs0cQdEsWz95W5ZBHVvesfim/UwpyeXItVlWWErn+SvhVpBEN40V4hwMTbVHsB/FMs3cIG1x+vsKcMPcEdpyweO64fA1kCB5jnGkm/HOhxp/EgEcxv31cy/w+ipLV0+yUeEjXxzXbRl23bhompHDTL1CA9D3spahHROBn3VOVZ/w6lOp9TQqrx45s77GzT14sVcR0teum+wDIkZ6BfauC/K0nLBaGo6x7RDOtwnEpVDi7V8h3WPs/QR1VIHZrupLVkaF5xNtnK+QiX9ikgY9jiD3XkURxrzGqxo/X/LKdwAPj0ccqXb7ta2cPjlp1tv1kO3XycYlBJPdqg/EFwQrTvquhk9HM8p6ldLMB8M0gSDJxB+7Gq9V935c7+vF2niWOB60VCB6GjYyyRvWQq3uP+i62CQR5hDyWA2hsh964FfpFGBMQ+M5JobVSrNTmWynYxFIJYeHh1DY4PZL7Z+/lIkJr7Rt2Jpy9xj6UAWmrDEE9LHqbCQ+wBv1b59RAM00LmG1jcYkQdOC5pPw3252BjHJkCuymWcYqgDiVhigJQsdF2cz/8gslczeWe/l9KPrDlG4gkWdiZNXV2UL44ZdrgnYprVNHcJCHIUiGJHhCOoxBbtrUAgrKSyTrsbbqnxwGFsCe1HopW8ft/37W96z1Wc7W7zasR3Yr1Q6qEX1SBg5XaM8nP+bmVFLMjgy8zl968Cz7/881ahbstCSlDSAzmqPcn54+p1z6ndkQ2XEC17EgusOk8X9RZgmNdhz9ZjZE0kMxEP8g/VQiLf1N6dcm9z6KXHPqPSffvUvQGfogfKj2zerOZpcRkV0dp0SelrMt8vC
 /dAT32Fm
 99Aud5rdx9JLiq/KJgBw9AtKnJ9EpNHexJe3O7sGm0v4PlwSj7RdHOvxrEiS6DnIjat7keT2npZLjOJoCxC9INRwTFMc4vsCcrZ6VcN6aU1cX0voza/RyZabCPC13zyN5a34zUYR2FCdVIjv4wIRm5Zo/ynFWiD06h9bv8fXLdzF/4yCkwwvwibV/PwfCVWM85hpZoq959sJaCpX2qIslxWa6B4fv3S4rgiY0x4RDpIfHpIV5EdJDjnkhvfEd97M2CiL5ol9SFHeQMgUUUf3yBFHWjPBvDbpVJokTcNpM5QMF8thXEyybCiB+b7M7Y5ufj/Mcr6rp5pJhLQy44wsUVhCZL/MGw1BC/OsbW//oPZBWRYYEip4TW+HgX8KGF1yvpXfrXhbSR0vDPPvlT/rfF0s0ySoyUeWEFnMqHYrMbGhERDdjdVjdGonMek3x21ijG4levddFfp3y3l7QkJ3UlY90If2bAEWprnWty0NPV5Ff4WI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi

On 4/2/26 8:57 AM, Huang, Ying wrote:
> Donet Tom <donettom@linux.ibm.com> writes:
>
>> In the current implementation, if NUMA_BALANCING_MEMORY_TIERING is
>> disabled and the pages are on the lower tier, the pages may still be
>> promoted.
>>
>> This happens because task_numa_work() updates the last_cpupid field to
>> record the last access time only when NUMA_BALANCING_MEMORY_TIERING is
>> enabled and the folio is on the lower tier. If
>> NUMA_BALANCING_MEMORY_TIERING is disabled, the last_cpupid field
>> can retains a valid last CPU id.
>>
>> In should_numa_migrate_memory(), the decision checks whether
>> NUMA_BALANCING_MEMORY_TIERING is disabled, the folio is on the lower
>> tier, and last_cpupid is invalid. However, the last_cpupid can be
>> valid when NUMA_BALANCING_MEMORY_TIERING is disabled, the condition
>> evaluates to false and migration is allowed.
>>
>> This patch prevents promotion when NUMA_BALANCING_MEMORY_TIERING is
>> disabled and the folio is on the lower tier.
>>
>> Behavior before this change:
>> ============================
>>    - If NUMA_BALANCING_NORMAL is enabled, migration occurs between
>>      nodes within the same memory tier, and promotion from lower
>>      tier to higher tier may also happen.
>>
>>    - If NUMA_BALANCING_MEMORY_TIERING is enabled, promotion from
>>      lower tier to higher tier nodes is allowed.
>>
>> Behavior after this change:
>> ===========================
>>    - If NUMA_BALANCING_NORMAL is enabled, migration will occur only
>>      between nodes within the same memory tier.
>>
>>    - If NUMA_BALANCING_MEMORY_TIERING is enabled, promotion from lower
>>      tier to higher tier nodes will be allowed.
>>
>>    - If both NUMA_BALANCING_MEMORY_TIERING and NUMA_BALANCING_NORMAL are
>>      enabled, both migration (same tier) and promotion (cross tier) are
>>      allowed.
>>
>> Fixes: 33024536bafd ("memory tiering: hot page selection with hint page fault latency")
>> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>> ---
>> v1 -> v2
>> ========
>> 1. Dropped changes in task_numa_fault() since the original changes
>>     already handle runtime disabling of NUMA_BALANCING_MEMORY_TIERING.
>>
>> v1 -> https://lore.kernel.org/all/20260320092251.1290207-1-donettom@linux.ibm.com/
>> ---
>>   kernel/sched/fair.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index bf948db905ed..4b43809a3fb1 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -2024,8 +2024,12 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
>>   	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
>>   	last_cpupid = folio_xchg_last_cpupid(folio, this_cpupid);
>>   
>> +	/*
>> +	 * Do not allow promotion if NUMA_BALANCING_MEMORY_TIERING is disabled
>> +	 * and the pages are on the lower tier.
>> +	 */
>>   	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
>> -	    !node_is_toptier(src_nid) && !cpupid_valid(last_cpupid))
>> +	    !node_is_toptier(src_nid))
>>   		return false;
>>   
>>   	/*
> No.  Even if NUMA_BALANCING_MEMORY_TIERING is disabled, we should still
> allow migrate pages from lower tier to higher tier via
> NUMA_BALANCING_NORMAL.  If we have precious DDR, why waste it?  This
> follows the semantics of NUMA_BALANCING_NORMAL before introducing
> NUMA_BALANCING_MEMORY_TIERING.

Thank you for the review comments.

One thing I am trying to understand is that page promotion
appears to happen regardless of whether
NUMA_BALANCING_MEMORY_TIERING is enabled or disabled. In that
case, what is the specific role of
NUMA_BALANCING_MEMORY_TIERING? Do we get better performance
when it is enabled?

My initial understanding was that disabling
NUMA_BALANCING_MEMORY_TIERING could be used to turn off
promotion. However, it seems that currently we cannot control
promotion independently. If NUMA_BALANCING_NORMAL is disabled,
neither migration nor promotion happens, and if it is enabled,
both migration and promotion can occur.

I was under the impression that:
- NUMA_BALANCING_NORMAL would handle migration within the same tier,
- NUMA_BALANCING_MEMORY_TIERING would handle promotion across tiers,
- and enabling both would allow both migration and promotion.

This would provide more fine-grained control. Is my
understanding correct, or am I missing something here?


>
> ---
> Best Regards,
> Huang, Ying

