Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B977C109B481
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 15:03:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8F2A6B0096; Tue, 31 Mar 2026 11:03:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B40436B0098; Tue, 31 Mar 2026 11:03:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A55B46B0099; Tue, 31 Mar 2026 11:03:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 94A936B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:03:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 15B0D140291
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:03:22 +0000 (UTC)
X-FDA: 84606676644.07.A284E18
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf07.hostedemail.com (Postfix) with ESMTP id 698F140017
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:03:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=QbkhjFC6;
	spf=pass (imf07.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774969399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UczSSS9CKK95FgzuEtbmjOPbGqJ97U8Cbw/iDHovot0=;
	b=P7VdIjy9OjakLac8oDgC1aAr1ZI2tu5Tq6zxKpF08eZ5ySTH2i8729aW8HTaVU+rKpSkqU
	KHH8rmHRpPtUazE9mC21/yoPA8/Ow4b2lRADuCPCbjTbl23cymfi1BJHqvVCGrzaUMDitD
	BG2MkWK5kGL1zxyttILw3fO7+tZCfYA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774969399; a=rsa-sha256;
	cv=none;
	b=BMmx36nQjeKTp4ZXcEGd/amfTxKhn9Xf/bCnrc4CPF9KYrxoegI2rE0K5IeIA73RO4oXDp
	COAJhbqPxL0rFGH33fYusZRzVHPMAkruqRXw2xQmOH66gyL3/6VI51bz0LmOxb5D7VG6Sb
	sjdyingGapaJvESIEwrrK5Y40PDPaJU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=QbkhjFC6;
	spf=pass (imf07.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62V8aN1C347700;
	Tue, 31 Mar 2026 15:03:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=UczSSS
	9CKK95FgzuEtbmjOPbGqJ97U8Cbw/iDHovot0=; b=QbkhjFC6gAr6MTt0cBIEnk
	PUgNi1PfNC4vVuJv6qtjL1P2PNxQDk54Tv19KQvlWrljI3Gp3jwOKG+X4WE6SFrU
	E9D2O3sZ6d5apVaI7pupKn+TA0Q1hwIWmzVgx1JoEfjG3r8/M985D0/qN3m4KAXw
	U96/LjBb20x49sZDu4m8k1NA/Hrp0jLNEwfwQ2vk0k4n9T1JTlzzK4FL0LI+95xD
	fsi32YMIwmDFdTYOvJDGPlF5Cno6vAJgypfdZ4dqlJqJkkwvvgVi/gkgkMAU0vXh
	NYM9cVeNJIojD4MULhN0ztYGaEIi43nVk3Hyj492MXfcP3KOrbNxS8aLb9SoicOA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d66q33wcq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 31 Mar 2026 15:03:07 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62VBLaZc006362;
	Tue, 31 Mar 2026 15:03:05 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d6spy1pqk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 31 Mar 2026 15:03:05 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62VF35Rc29884936
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 31 Mar 2026 15:03:05 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 286A358059;
	Tue, 31 Mar 2026 15:03:05 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ACD3658058;
	Tue, 31 Mar 2026 15:03:00 +0000 (GMT)
Received: from [9.39.16.245] (unknown [9.39.16.245])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 31 Mar 2026 15:03:00 +0000 (GMT)
Message-ID: <13904ac8-6608-4f03-9806-36518931eb3c@linux.ibm.com>
Date: Tue, 31 Mar 2026 20:32:59 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] sched/numa, mm: Skip page promotion if cpu pid is valid
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar
 <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ritesh Harjani <ritesh.list@gmail.com>, linux-mm@kvack.org,
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
 <7dd35e65-e0c2-423d-a82d-c9e488e85e33@kernel.org>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <7dd35e65-e0c2-423d-a82d-c9e488e85e33@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: 4-Uf4ZRh-RgSKH1svsIRljpnOZzmk9iW
X-Authority-Analysis: v=2.4 cv=frzRpV4f c=1 sm=1 tr=0 ts=69cbe22b cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=kD2cJtFTWjehufG_4jQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: m0jlVuAZezlh8X8H-qMakLj-V9ls3wOm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzMxMDE0NCBTYWx0ZWRfX25yqOX0eLUJY
 ofDEyWrj2xU0RTdJ1owbx+VIvpMf/proqVbmYzwQinydUNM15CcLczmS3VZE2hJWEtzBR4t8mnz
 yKroEdMBo8bcq7DHPJxaVFX15KIdtRq6pUtdNO4r66vxMtOJNalZtoGHWzrKA+angcy110yk2MG
 PcSvtFl5fNdtzFWwA9zwspbT7Y21wSxLQ2SaLUHmtMnOlFsJIhFIJw8lg5wtIBtoDe9xGzrGsve
 SCtX6SwWz6990dhhxiAYRIZHLvVDWjz8khUDph4H77BA6yJSMPtRs7AL+8wfSJEiUDJ7d7v11LS
 oU+KH3JDTzuVYWIqD1gUFPmoFI3kfmn/j1jx71+EE66G/T7LS82w8dTQJ2qEzz+pJRvS5ei7zHY
 p1GXJ0wAyDA2p1zce11lRHjCqyzUiomUGQM5J3Mw/KBEbjF3F8Zzyn+Z0kIMJ9mX+zQG31lyC1h
 Wp5BXHQWDdpnmyzTijw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-31_03,2026-03-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603310144
X-Rspamd-Queue-Id: 698F140017
X-Stat-Signature: kpyp37hfjp4ao9kmofhain15ira7ohh9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774969399-846705
X-HE-Meta: U2FsdGVkX18xd9YmbQWGAt92aSF3ydSx5Fgf6R0WSTCHh8a+zeXe9ljEwhuIJm0KniA5o4FGnEU/0ZAxQ5Sizx8FGCBbhCdnxrfYf9fZlzBiol2U1UvKnzfwVukS62Dc1iapX8Bs8f2Bf6vJkhMdsHYPpCL1a2DdE7SJ+wioVuHUndiVs5ocqK1TNIdLmysN+xYAvQt7p6gvk/qU2HyNVgmx4HOcCATOHE4oZ4ZVyltUZho0Ov81n0CDYWGUdjA/f+cz89a/KGkBJdTXbF/d5npjpwSJ3Wo2LksyTkP+ebw74pVOdOvclm6/ryHwwvwGQQiSyEx63dXHq34mKHoyfT3qz93jOIEsTZkpNSzTrtmYIcsiXyWfSDf9N6lyui79+1gHvydOODtYl7P2jzwYvjO5wls98CKpztaySmJxhq6K/UBzTmy22qYPSI1uBW3hL8bWntiDRMyn5Gt7nAzup+gAMFqmwglV/dP/jF2PwSUljmHEjSHNlANqBdCvMwfbLERUtAr/sxw0lM3hQiGeMczISx2askS71eYJSxcbLurS7733UX46mnUdJFN2nHd9ceaNtkt9XLF4VF4MJmS7G3QGwWT6BXV2pY9USR7NA5ojCU2bJh2oDeMMryI2n0rqn0CZqD4HpI9B5BVAfqI9uGOJbUUrOi2LqzPpy/DkoRDk4uFcN1NuXwjOXk4bb5+CmNDN0an2K//JuTayhp6rvKZhCGRAJPBGY4jW54yC+NiouryAjvwWFBKVz3upWDgYUzPlBjFm+qVdETgvHLXteMEawBCYFdlqpNoMplflccPBcTrrBUDUiQxLF/vNWKb3uIwTgE+Bb5huf2cPlRQijIULThbYYCOZQjk7jLFkrWZmC8wh0zSPNUWlIdXnCAn79H6s9Dsr1q1DWkxThPnRWNNu3kMNpQqFsBp5yoTuA6nAz14GfA1dIxR4jWyCUeb6StSTU4VyNSLrTG54zXz
 PsT4MsXR
 iBZxxZ/5fqGRSmlJwQ71gsiKMfGdyz1Am2uP+PrDlj8xDiU5ln6UMVbuleks1QaGQSYW5xztpdD3QHo5bkBxzpI5TLiTx5nj3EWVKsXxSHjHoB7qOU0RdG0FaJOkFnWaLZ7B1JEmzdW2odzRfeu7UA459Kj3DiPqH5rZn+PhXSrYL8j6LqnmQFPbK74h25HxBZ1MUxrCdUFrVBh1KkOTtWnnxIWqLESLTM8gOicPrFXBEdRszRzTfnHlYDyyark/gYlNqQNJKZ6+Wfs4+bCN1EPhVTxT1NQeMIyFxfMsxtK6ztkPM0GKNDB0W+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 3/31/26 3:34 PM, David Hildenbrand (Arm) wrote:
> On 3/31/26 10:33, Huang, Ying wrote:
>> Hi, Donet,
>>
>> Donet Tom <donettom@linux.ibm.com> writes:
>>
>>> On 3/26/26 3:59 PM, David Hildenbrand (Arm) wrote:
>>>> Is that measurable? Should we at least have a Fixes: ?
>>>>
>>>> /*
>>>>    * When ...
>>>>
>>>> IIUC, as timestamp we use jiffies_to_msecs(). So, soon after bootup,
>>>> we would no longer get false positives for cpupid_valid().
>>>> I suppose overflows are not a problem, correct?
>>> Thank you, David, for guiding me in the right direction.
>>>
>>> I initially thought that overflows would not occur, and therefore
>>> cpupid_valid() would not produce false positives. However,
>>> after looking into it further, it appears that overflow can
>>> happen when storing the access time.
>>>
>>> The last_cpupid field is used to store the last access time.
>>>  From the code, it appears that 21 bits are used for this
>>> (#define LAST_CPUPID_SHIFT (LAST__PID_SHIFT + LAST__CPU_SHIFT)).
>>>
>>> With 21 bits, the maximum value that can be stored is
>> It can be less than 21 bits, if CONFIG_NR_CPUS is small.
>>
>> 	DEFINE(NR_CPUS_BITS, order_base_2(CONFIG_NR_CPUS));
>>
>>> 2097151ms (35Hrs) . If the access time exceeds this
>>> range, it can overflow, which may lead to cpupid_valid()
>>> returning false positives.
>>>
>>> I think we need a reliable way to determine cpupid_valid() that
>>> does not produce false positives.
>> Yes.  IMHO, false positives is unavoidable.  So, the patch fixes a
>> temporal performance issue at the cost of a longstanding performance
>> issue.  Right?
>
> Could we set aside a bit to indicate "cpuid vs. time" ? We'd lose one
> bit for time, to we care?


Thank you, David, for the input. This sounds like a good idea—I'll give 
it a try.

-Donet


>
> Would make it all easier to get ...
>

