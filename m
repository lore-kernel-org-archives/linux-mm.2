Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BC8BFF60EE
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CC5F6B008C; Tue, 31 Mar 2026 05:03:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A33A6B0095; Tue, 31 Mar 2026 05:03:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 492156B0096; Tue, 31 Mar 2026 05:03:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 33D816B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:03:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E7A1FE1651
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:03:42 +0000 (UTC)
X-FDA: 84605770284.18.76ABE8F
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6568E140006
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:03:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=sWl7DdLn;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf26.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774947820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=syTSe4ROpksrczlRw3ujnaPgLF6ZrMM0eH/jY+IKP1o=;
	b=F306POnI78CnYEo1+WW5LGG6Ak9xEXzbOr7azyFMEp8NvjJTDYymjgeYZBz0tQByPrUxig
	kqILrbLG3W7LkZGIXumKzHilUWp2AjB/4smRMSKfRbBb0H8HstcG0ENEsG3H8mOurBKUhb
	LHQabFNNbstOq9DrKbEvOYV7LII0B7w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774947820; a=rsa-sha256;
	cv=none;
	b=7SMyUToRefCBmakM9ZPAwgjeB+5l5Ri+9pwgts+7deDl29zKaEp2mZTpzlDm8Bh6lybRNJ
	jt/xzq+fdMrUF92u8ZQdjtBHvLpgOeOgDp/7G8cOydJXDDi6oUJstcGhY7nEqtoO8t1IAA
	2zPGCHSDD9pu5A1gAZfousLn5x22yPg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=sWl7DdLn;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf26.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62V0F6Yu3415434;
	Tue, 31 Mar 2026 09:03:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=syTSe4
	ROpksrczlRw3ujnaPgLF6ZrMM0eH/jY+IKP1o=; b=sWl7DdLnwzGSQUcQbeXj99
	dHtXMFjgYtoG3pvTdqr+HwZNFIPpRks3aZch5MZwd+tweJUOACzMVbJa1GUdEDk2
	ceuGRauBmwuFFfltH3h0HyilFF00yxWYm4okTuM8WO/v8y/FqzRmgisnPDPNSymb
	ZwcchT7v2WLntVM4pFz9EOa5eXIpABv5vfyyG1ycLUiqvb6mreyC7pgJPrl6OxF+
	qVBb1maisklso3qp9N/6kdhHVaAzje8QsKj8tSQgC1zDhc5rsxl2Uz86dE+hWYhV
	PbATKEGeBr9uerbBDCzMWsrPH5xpYcSZMjfggWAmk/xF+xT/5dpLcgQaBxmE9eXQ
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d66q32e1k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 31 Mar 2026 09:03:18 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62V8AiF4031552;
	Tue, 31 Mar 2026 09:03:17 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4d6uhjr4pk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 31 Mar 2026 09:03:17 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62V93G3v25887340
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 31 Mar 2026 09:03:17 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A491E58082;
	Tue, 31 Mar 2026 09:03:16 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 13FFB58073;
	Tue, 31 Mar 2026 09:03:12 +0000 (GMT)
Received: from [9.39.16.245] (unknown [9.39.16.245])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 31 Mar 2026 09:03:11 +0000 (GMT)
Message-ID: <eb9d54b5-6fe0-45b6-9a8d-aa117ccd3c0e@linux.ibm.com>
Date: Tue, 31 Mar 2026 14:33:10 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] sched/numa, mm: Skip page promotion if cpu pid is valid
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ritesh Harjani
 <ritesh.list@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ying Huang <huang.ying.caritas@gmail.com>,
        Juri Lelli
 <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>
References: <20260326071216.11883-1-donettom@linux.ibm.com>
 <f41ab7cb-4430-4338-8812-eb6aa98e9bf9@kernel.org>
 <2b8f30a6-a8d1-4ea5-8078-5eec399c8609@linux.ibm.com>
 <87cy0kpfdx.fsf@DESKTOP-5N7EMDA>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <87cy0kpfdx.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: gMEEXDHzztlSNOMxb83DKfhFJQCxGrfY
X-Authority-Analysis: v=2.4 cv=frzRpV4f c=1 sm=1 tr=0 ts=69cb8dd7 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=mOz9gw589m8ysdXsvZAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: vPv_gbVf7b_5wOiwgaP8bEk5mP2Aj9MV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzMxMDA4MyBTYWx0ZWRfX2OOxc/BSF5WE
 tz3Hx8MVwv0MSHgYYCGXPIRNKO1W6nfmtp1VzZjG8vy4C6F1LSgtpFCfrVyMURa7u5aBnqz00lv
 cR7B28p8cL4m+kvl+JlniHXkatZULMvIgIP+6fPUlj5KUfnD67/NWS3PFllV1l6WyyOTq/hy4Lu
 eHbKOARLHKe6XRJDC5TlVX6JPogprEEx4IegDw9R8j0/1mK0GIwlgry+VcPM3S4+dlB/HOChKEo
 XyYCv82qBCZ3qN3h0K6TAFoaajig6NSlamSuo9QP3Uwx+LtSuJ5Z4wNe8t9Soorb5zRgxVHFSPs
 FDvJesN/NkQwwqS0NZG0BBNYMMANAEinOn+HaWVd6JpGFR3ElVBQvVjsTfkBK8xv2MEkqWDY9Zh
 qd+s0tpKKdhoOn9qtzPgwcuMouu2/zOyzsnNGxwcsf/6kJc7G+eK1GOQri8IpsZfPb8Y9dtazDW
 AMSiPr7D5qNRlmtRuAQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-31_02,2026-03-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603310083
X-Rspamd-Queue-Id: 6568E140006
X-Stat-Signature: ooxzfiz6aiaaqbhijujjzkie67e6a7xs
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774947820-240891
X-HE-Meta: U2FsdGVkX1+y3zkp0/saOFoa/0S7Ee+wxTCPDLRlRKgmj+Rt/Tl/i7xADkmdCpLXqyFEzx7ulCjcFBXf0d6R7Iaso8SxXEDAgh/gqQgXkvshDOynkboD7/Mnwsyxw2NVgdt39ULjBGxk4G/pu4BPM6BKAwcNsQ2/Ogajy19BaN08LIvTkNRxbsLMqnghWCaGfND/NIjgmKvmaBSGtyaUKX4MxyZVy0JsnzFu2IdRU74kxNr7HbIO8pvGqr73FlD0DMJ1/ym/3SzWVjq4DMjZ6xdUhQ+tZBBHuNnlbli6IQllEsV0lS+LdGGEGPqp+KvXyfy7hktWqetZ0Q5Q9jYs/7CKmYAFmt3Sob5T3SXbLiExr9SQaIS35CAr9TMyi+2kY0VhxDZhHj5N+eRndhVqXMyy4byid3aQ7k4ELuN21iGakyXuigkR+WEBycFbRBak6uZdiu5cIBoOHwyJBuo6qYZYaKS0o8tdJz7VsG4GY8yuZ/ekBSM33HwRYHqgX5kLGw8+XYlYtupFQMe2fv5dpJKjLFNduBmvEP49ZGi2G4qnVnQXp3qLd1eK/dqiniboXhhNHK8B6IuS70eVMUV5pIWEd24R+EFAOFiDX31iFX13Q0yqeM7XRjTxTbIiOBWvfQRms9imrhCJlxcF+afQ0yX11lP3B+Yg00BhLdxmIJ5YHhSdda0yTbC+iDr2SzUz32LbqcoFzcNqeQHdbimoirEwEii2WRPraIGLfKRCYCsziBPPAJJ8JBqc0ct2bT+GwAFWv+o7b6WApYLYIjRl2NIYb65GkiZBFMgYpLQieG+OTlXvryc5xwpG30hiGJMsrbBeGvRaMIRlWI4GTC/VELi15GlgNSx4jaKWHYXYLcLEdOMl/bdUc+m8Bjcm/J/FOeerh2QlzyxDj2c59/L3Xqqf0tm4LkFI+lbtfeLmeVv9LngwjaBXj7/1LozaHMo7SzaOp67zvOBz28CcGlz
 mTeL1J7w
 BE6WNYeU/MQoNTjCi/wVcilebH0Tz/QEFMMzROdwGziQNsjefUrAcpRJIkiiSY2+tyZ0PlsJLznJtRjYwtTjtczeYfve8XOgFSNelsrs5Vx73zACUmpj1nTb4LzVir2aysU/yc7AQHpIMzpdaDiOk9OPMxhWK4G1DxhAFEjxUIfMhnUeen6vn7fQtS+lnU4Hznz1U2w9U0jD3gv+Gadmc84zfHNZGuDkua3Rdu37OUrjXT3Urh+euvUJZ5+c/LZZVJ5JGFWvEFFRlR7hkbhPu/EdsWa7FxBIFXjmO1t0xKu856XcQB2yA2od3YnyughKw+4bUw3r8Vs9yGfazGICWSxD7yPyBbXfK6Mx2kpDkFXwKOVD+nVnM9MiGboHpCCsb9Wu40YVD6WmqWMjiXvt6RqeuSNW5wu/L5dWV5ikYsjuXw9aV3Tv/OgzX2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi

On 3/31/26 2:03 PM, Huang, Ying wrote:
> Hi, Donet,
>
> Donet Tom <donettom@linux.ibm.com> writes:
>
>> On 3/26/26 3:59 PM, David Hildenbrand (Arm) wrote:
>>> On 3/26/26 08:12, Donet Tom wrote:
>>>> If memory tiering is disabled, cpupid of slow memory pages may
>>>> contain a valid CPU and PID. If tiering is enabled at runtime,
>>>> there is a chance that in should_numa_migrate_memory(), this
>>>> valid CPU/PID is treated as a last access timestamp, leading
>>>> to unnecessary promotion.
>>> Is that measurable? Should we at least have a Fixes: ?
>>>
>>>> Prevent this by skipping promotion when cpupid is valid.
>>>>
>>>> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>>>> ---
>>>>    kernel/sched/fair.c | 7 +++++++
>>>>    1 file changed, 7 insertions(+)
>>>>
>>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>>> index 4b43809a3fb1..f5830a5a94d5 100644
>>>> --- a/kernel/sched/fair.c
>>>> +++ b/kernel/sched/fair.c
>>>> @@ -2001,6 +2001,13 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
>>>>    		unsigned int latency, th, def_th;
>>>>    		long nr = folio_nr_pages(folio);
>>>>    
>>> /*
>>>    * When ...
>>>
>>>> +		/* When tiering is enabled at runtime, last_cpupid may
>>>> +		 * hold a valid cpupid instead of an access timestamp.
>>>> +		 * If so, skip page promotion.
>>>> +		 */
>>>> +		if (cpupid_valid(folio_last_cpupid(folio)))
>>>> +			return false;
>>>> +
>>> IIUC, as timestamp we use jiffies_to_msecs(). So, soon after bootup,
>>> we would no longer get false positives for cpupid_valid().
>>> I suppose overflows are not a problem, correct?
>> Thank you, David, for guiding me in the right direction.
>>
>> I initially thought that overflows would not occur, and therefore
>> cpupid_valid() would not produce false positives. However,
>> after looking into it further, it appears that overflow can
>> happen when storing the access time.
>>
>> The last_cpupid field is used to store the last access time.
>>  From the code, it appears that 21 bits are used for this
>> (#define LAST_CPUPID_SHIFT (LAST__PID_SHIFT + LAST__CPU_SHIFT)).
>>
>> With 21 bits, the maximum value that can be stored is
> It can be less than 21 bits, if CONFIG_NR_CPUS is small.
>
> 	DEFINE(NR_CPUS_BITS, order_base_2(CONFIG_NR_CPUS));
>
>> 2097151ms (35Hrs) . If the access time exceeds this
>> range, it can overflow, which may lead to cpupid_valid()
>> returning false positives.
>>
>> I think we need a reliable way to determine cpupid_valid() that
>> does not produce false positives.
> Yes.  IMHO, false positives is unavoidable.  So, the patch fixes a
> temporal performance issue at the cost of a longstanding performance
> issue.  Right?


I was trying to fix a functional issue. When memory tiering is

enabled at runtime, treating last_cpupid as access time is incorrect, right?

-Donet


> ---
> Best Regards,
> Huang, Ying
>
>>> So what we're saying is that folio_use_access_time()==true does not
>>> imply that there is actually a valid time in there.
>>>
>>> In numa_migrate_check() we could still use the valid cpuid I guess and
>>> make that code a bit clearer?
>>>
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index 631205a384e1..ba68933a9e4a 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -6119,10 +6119,9 @@ int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
>>>            * For memory tiering mode, cpupid of slow memory page is used
>>>            * to record page access time.  So use default value.
>>>            */
>>> -       if (folio_use_access_time(folio))
>>> +       *last_cpupid = folio_last_cpupid(folio);
>>> +       if (!cpupid_valid(*last_cpupid))
>>>                   *last_cpupid = (-1 & LAST_CPUPID_MASK);
>>> -       else
>>> -               *last_cpupid = folio_last_cpupid(folio);
>>>             /* Record the current PID accessing VMA */
>>>           vma_set_access_pid_bit(vma);
>>>
>>>
>>> The change itself here looks reasonable to me.
>>>
>>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>>

