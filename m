Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 417A2FF60FF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 10:01:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8E996B00AD; Tue, 31 Mar 2026 06:01:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A65A36B00AE; Tue, 31 Mar 2026 06:01:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97BD06B00AF; Tue, 31 Mar 2026 06:01:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 83C2E6B00AD
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:01:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4FFA713BECB
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:01:15 +0000 (UTC)
X-FDA: 84605915310.23.07EE359
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf14.hostedemail.com (Postfix) with ESMTP id C7C7410000E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:01:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=hcdgPHMY;
	spf=pass (imf14.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774951272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cfp9sj8bzWBMlYeri8cK26Hxagi+Z/bHu6P5bCVBtAk=;
	b=V/wgRIYOglE2v0PkWGAVNBGgivqQRMwayaL2jj3eFuyRXbY0gxt9rSAO3nJh718AGdCPVP
	vrE2YJE+w3CoX/4o8Jsx/57+Q9RpJbIg8h506hVSYdaGJGYfisz/pAwbopVOYTYm3RSYu6
	mlQaASSeQlGIEdSHEYg6Yeoih25TSnM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=hcdgPHMY;
	spf=pass (imf14.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774951272; a=rsa-sha256;
	cv=none;
	b=3aW2aYGJWldRYF+LEs+SvNXiKTCO+2vcl3idlnVlqUVTjqXDF03oZKmIWs1+lbhjVbHWSd
	LLa1qyFefwmgmcBcXAHRIxppXV59WlINkvC6RLWFtqGSyR3vaZlGHizg4pYRJ1rV299UPS
	eXn6AVc9uH1hOfMx49Q0FAJjq0y0eTs=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62V7nwQS057294;
	Tue, 31 Mar 2026 10:00:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Cfp9sj
	8bzWBMlYeri8cK26Hxagi+Z/bHu6P5bCVBtAk=; b=hcdgPHMYDIupXlIGZmIdar
	5I/NCSHQASaxK9JkG4NCSHwsfkZ1Ao/GQFTdG4KbucKglM4vgJqsL6dmsaul3QHb
	6xP9g6LFtSqcSeGKPbdX4NX1gbE0tzeyMik5TaKcQQ5iGXt923tkmf+cFHHraTg2
	c9ld0G8IU1U90PSUl3G1BY89FqVh0yssrODKc3ja2mPaOe3hNpRkO/TxFDfVl6F4
	oX1ScU7a0zYsRkZ3YR3IjQACZoOhLmhieMS0lIibOC4Wei8zvx+DnWOJSF6smTrr
	MuC9YZNy0p2ZYT7W4+bhkcABOzpcQPm4ADYHOZTJkEuM99h2VTpNAZr7VDO+7QJg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d65dca7ef-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 31 Mar 2026 10:00:58 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62V7qX5E030952;
	Tue, 31 Mar 2026 10:00:58 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4d6uhjr9yk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 31 Mar 2026 10:00:58 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62VA0v4U28115548
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 31 Mar 2026 10:00:57 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9757858057;
	Tue, 31 Mar 2026 10:00:57 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C4B3B58063;
	Tue, 31 Mar 2026 10:00:52 +0000 (GMT)
Received: from [9.39.16.245] (unknown [9.39.16.245])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 31 Mar 2026 10:00:52 +0000 (GMT)
Message-ID: <207228fb-a4ee-460d-98e5-589187968b97@linux.ibm.com>
Date: Tue, 31 Mar 2026 15:30:51 +0530
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
 <eb9d54b5-6fe0-45b6-9a8d-aa117ccd3c0e@linux.ibm.com>
 <875x6cpddd.fsf@DESKTOP-5N7EMDA>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <875x6cpddd.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=RsjI7SmK c=1 sm=1 tr=0 ts=69cb9b5b cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=wirRZfjEyRCDJu0qy4UA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: wkBRYBN92QUNJAcDZjrV2VwhL-rXr_A1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzMxMDA5NCBTYWx0ZWRfXys+ZPnaAfCCw
 pPVt76hIttmE1P78GFSTpZrzV4b5QNIMkbTJryLngcWTadnKywEPXZG3Ez2ifWxDyJ0VvKykrNI
 eS8H4vs4ZFr+egR4UOuunsNwLuYOY/n6pbX4mOngOwGmbXPluxXHXrrt7UVpbUe4lXPe3ep7jq3
 BZYKTaW3Z9br5/09J+jxUL8pQ70W4jK8ntZbIf0WWGbxJepVEAADgwasC1y2aIDKjNiq8z0ExAR
 GjM3NQ3ZvQL9lR2vedH7OUDJgJDGJK9OoFkpgVG5TXqe3sf9K2twEHyFY8vjdAdrcgYATHp6fHJ
 obnriFpiqAzxrIzsHrBj5mkvillu9PKtHUpc5DsMSNRHqzoCHBe0m9M5dg5ba7qKb1osO0nG5z2
 mT/DgfRmLxOf8Z3ZW52Z1slgbp3+JesLdPeSpBzwlit0Bsll0T1Q7d5PP6q0WUgD+QlTi1NoTYM
 7V2HZWvnXIrmur1nX/A==
X-Proofpoint-ORIG-GUID: ub8R7S2hHL24WwRtIqsPlwgRs8Aoal_U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-31_02,2026-03-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 malwarescore=0 spamscore=0 clxscore=1015 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603310094
X-Rspam-User: 
X-Rspamd-Queue-Id: C7C7410000E
X-Stat-Signature: hk34ykssmzjm3hbb3qgmh9w8ij5eriey
X-Rspamd-Server: rspam06
X-HE-Tag: 1774951272-873343
X-HE-Meta: U2FsdGVkX1/gOlXI3GzF6z8kOlM3FsHBpvpPk7DLLhLdfzvm8UtwyJnk2LHGwR4Mdw7oG3puNRVwM26j350ocGNlVgRUrkwx7B07TMzXA0OsTdKKgCqgQ+GeQzkRKCnlEo0CKVVKd1gbNo2bn9cPnPtoZamiQ1JpZUlBKr90+YWiKXIeGB3q7zdZ3X2sQfFyjsHsHFbgk/6a8U9IqVnkMB110HBsZwDIe2/gR+lBRP4Wn3KT6COBhgFpsD8A88ygpNicogJbQG2gPBgjYIpJcxps7V1gSIJoECdJKTsWA2wFKcxqYQCxj2723HaOQo4fl71OlockznWvKET5pQUg3h8bgopbMP4qk+JOKSTBwlaB7hWmNbmqno1GDGAhgJdfll+ot47VkylAzxgdyP+LFZRBGQ/udebWteHkhMZfmkPTBromrPH+oFwquvB2Oeg8lbZrqaUkfCipgbED3ZIkHRsmdWDcewiucRNh/PSXmOdSaIIOnl3rw5VP1fqZskIuVbJbMrThXePs5NdP8dWHsyIGw4zlMDaSB69jS1VV+25ymNC5qtZ2vF1tR+gYENwdb57/guMQLt5CWc88Pm+GsetlNnchEuWGGmgXt7UgpLsZPRdIadbW1Qp5UfWwfQVuqb1zMvzKOZXVLS463Ulr647tG0M0hfUZ/77L8J65D41v028pBgfinPZE2ma4m5riExexzpTb/167NgJr/iChYaiJRURpOjf10oomHcRASWNE+Mu7ysoREO5gTJT7+j+Sy+nA6xP7zWNcT4S8qAEmoIzmIX0v21afMYTrb+LdHf87F4xrB9MKpGNQxequcM5qGzE3vzl0wLxa65mDedHpKbYn2R89j3CdpVGNdffnxPHpkx7BYOldJKylBwpMtHP3zBZqk3EgsKL8PfaLQsZ7nj7M+dxBdrT43ieLaf83Z2XNJIBf2LCDwBvi1vHoX2ZflF+AtsAJdZcCvs9CG0F
 wkhPvRd8
 E65d1tOWBCfV3N2nJnyzyupZfJjGK195ag9VC2f7jPle2F4gx7Ue9QG+HPfSnRnjJIAoV1jO1SniEGJYj4VPsQk8hp4iN0BSd/3Fdh1EvkJw/o27UBDy4I7ONXbosTvrlt+qy+Xl2ravmTtZakevVOX81/8AfSqUH0FZYXrMNST3pFvq45yCMKJdh4CmkvqjVS2BqRsAZOPB4EXJOhrF+vCAxU2K3alsnogrxtuBzSpmwaBtZBq9Ei5yFdgG89YVyzR7P2Uqj7nacNqZ14lmG7vlIDwjP9sSTQGl9eLCuHGRDzs5OA/ZF3fWV5yjwSWrfYapKwS98XbnvAHVI1YpY9stPZfTvorJ39i7ZZMa6QszU9IJkchHEXafRAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 3/31/26 2:47 PM, Huang, Ying wrote:
> Donet Tom <donettom@linux.ibm.com> writes:
>
>> Hi
>>
>> On 3/31/26 2:03 PM, Huang, Ying wrote:
>>> Hi, Donet,
>>>
>>> Donet Tom <donettom@linux.ibm.com> writes:
>>>
>>>> On 3/26/26 3:59 PM, David Hildenbrand (Arm) wrote:
>>>>> On 3/26/26 08:12, Donet Tom wrote:
>>>>>> If memory tiering is disabled, cpupid of slow memory pages may
>>>>>> contain a valid CPU and PID. If tiering is enabled at runtime,
>>>>>> there is a chance that in should_numa_migrate_memory(), this
>>>>>> valid CPU/PID is treated as a last access timestamp, leading
>>>>>> to unnecessary promotion.
>>>>> Is that measurable? Should we at least have a Fixes: ?
>>>>>
>>>>>> Prevent this by skipping promotion when cpupid is valid.
>>>>>>
>>>>>> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>>>>>> ---
>>>>>>     kernel/sched/fair.c | 7 +++++++
>>>>>>     1 file changed, 7 insertions(+)
>>>>>>
>>>>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>>>>> index 4b43809a3fb1..f5830a5a94d5 100644
>>>>>> --- a/kernel/sched/fair.c
>>>>>> +++ b/kernel/sched/fair.c
>>>>>> @@ -2001,6 +2001,13 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
>>>>>>     		unsigned int latency, th, def_th;
>>>>>>     		long nr = folio_nr_pages(folio);
>>>>>>     
>>>>> /*
>>>>>     * When ...
>>>>>
>>>>>> +		/* When tiering is enabled at runtime, last_cpupid may
>>>>>> +		 * hold a valid cpupid instead of an access timestamp.
>>>>>> +		 * If so, skip page promotion.
>>>>>> +		 */
>>>>>> +		if (cpupid_valid(folio_last_cpupid(folio)))
>>>>>> +			return false;
>>>>>> +
>>>>> IIUC, as timestamp we use jiffies_to_msecs(). So, soon after bootup,
>>>>> we would no longer get false positives for cpupid_valid().
>>>>> I suppose overflows are not a problem, correct?
>>>> Thank you, David, for guiding me in the right direction.
>>>>
>>>> I initially thought that overflows would not occur, and therefore
>>>> cpupid_valid() would not produce false positives. However,
>>>> after looking into it further, it appears that overflow can
>>>> happen when storing the access time.
>>>>
>>>> The last_cpupid field is used to store the last access time.
>>>>   From the code, it appears that 21 bits are used for this
>>>> (#define LAST_CPUPID_SHIFT (LAST__PID_SHIFT + LAST__CPU_SHIFT)).
>>>>
>>>> With 21 bits, the maximum value that can be stored is
>>> It can be less than 21 bits, if CONFIG_NR_CPUS is small.
>>>
>>> 	DEFINE(NR_CPUS_BITS, order_base_2(CONFIG_NR_CPUS));
>>>
>>>> 2097151ms (35Hrs) . If the access time exceeds this
>>>> range, it can overflow, which may lead to cpupid_valid()
>>>> returning false positives.
>>>>
>>>> I think we need a reliable way to determine cpupid_valid() that
>>>> does not produce false positives.
>>> Yes.  IMHO, false positives is unavoidable.  So, the patch fixes a
>>> temporal performance issue at the cost of a longstanding performance
>>> issue.  Right?
>>
>> I was trying to fix a functional issue. When memory tiering is
>>
>> enabled at runtime, treating last_cpupid as access time is incorrect, right?
> I don't think that it's a functional issue.  It has only performance
> impact.  Did you find any functionality bug?
>

Thank you for the confirmation. I thought this was a functional issue. 
In that case, we can drop this patch.

-Donet


>
> ---
> Best Regards,
> Huang, Ying

