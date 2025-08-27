Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93AB0CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 18:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D71308E0002; Wed, 27 Aug 2025 14:03:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D47D08E0001; Wed, 27 Aug 2025 14:03:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5DF38E0002; Wed, 27 Aug 2025 14:03:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B152C8E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:03:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 25BCDC07C6
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:03:17 +0000 (UTC)
X-FDA: 83823309234.08.07A759C
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf03.hostedemail.com (Postfix) with ESMTP id 738372000B
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:03:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=J7BOgCDj;
	spf=pass (imf03.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756317794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1J0MvSsUJQ2pO/UpEiL7JA+uW/madGANFHbtRodsiak=;
	b=HJK89tu+qahsBWIsQPCA9zFknbzJc3a1ooXBSkqEccadu4hGWaN1cBGVKRZ7zrti+zhU4t
	dzuxHa+7op8yrfnnsCjC5oyGaiE28nyY5b2f5wksQXnS35uZBNN965BB715r7lqDCHxzIA
	DHH0PcMPfBZ8sP6zveRpP15KVG9mfzM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756317794; a=rsa-sha256;
	cv=none;
	b=1dy3dcS0JqYnjYDQq7z+baZZ27pOju7f5qO5NrtDFPye5wu8TTcFwsWq0JDG3vqsv8uuP6
	e8+zGkryYnyidrV01gLsQ0d31zlhoTTHXvxGtk+dXIHIbkfWBr51+Y8m+mp42l2lRMKGlC
	6PE2NCot2WzG84Aol9/zIGzgXIuxO20=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=J7BOgCDj;
	spf=pass (imf03.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57RHF5Ce023477;
	Wed, 27 Aug 2025 18:03:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=1J0MvS
	sUJQ2pO/UpEiL7JA+uW/madGANFHbtRodsiak=; b=J7BOgCDjhuv02yZt+7zzfD
	NcbwZPEhBNgCdjBg6obTXSw6vSon3UKM6RkgY4+LhlFOsC11r/KOLjm7rDzIGO2O
	oII9xCB2VwOwYTe5r4hN6XpE1/Ttn+jkaZFGiAKyiPvRAa3AUMHECpRV0jrSVdbe
	nZ1a9FpXYowgjBnjNs2/4xtTiI+ffOaUmCL238W5gGuuQ9TWoQasNtLy99hoRyGU
	bdJUIynGj368gNUES/utSDmQm3HA0tPP6QAe28uMV3g3NSbMgjZR37+89eZLnM7/
	OyG2I+Ll/zoXP0Gd51WgBEuMkDlELbfX8zEMkqrWO5qEaXYwLgr0/VQmJ25buPEg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q5avnj5b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 Aug 2025 18:03:12 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57RI1wM8010440;
	Wed, 27 Aug 2025 18:03:12 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q5avnj55-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 Aug 2025 18:03:12 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57RHNVnR017989;
	Wed, 27 Aug 2025 18:03:11 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 48qtp3gvxr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 Aug 2025 18:03:10 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57RI3AsD11796752
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 18:03:10 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E28EB5805D;
	Wed, 27 Aug 2025 18:03:09 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E545658043;
	Wed, 27 Aug 2025 18:03:06 +0000 (GMT)
Received: from [9.124.214.234] (unknown [9.124.214.234])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 27 Aug 2025 18:03:06 +0000 (GMT)
Message-ID: <f850ea7f-d2dc-4cc9-83ba-871d19311fa8@linux.ibm.com>
Date: Wed, 27 Aug 2025 23:33:05 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/ksm: Reset KSM counters in mm_struct during fork
To: David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Wei Yang <richard.weiyang@gmail.com>,
        Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <2e662107e01417bf9af23bc7f52863cd538419be.1756211338.git.donettom@linux.ibm.com>
 <59fef25c-6559-4fb3-8810-c2a7dd36b95a@redhat.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <59fef25c-6559-4fb3-8810-c2a7dd36b95a@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8Fa1NHI_Oki9TJYL05TZ0jLzTna4d_S5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAyMSBTYWx0ZWRfX1oh/PFuI1Lqq
 pZQ3mrxntSRXmSLKA7TeHRFQ2N6v0l4pvmouXrf1QyhmmorclGj+8hZ3JcoqC3FGuU9bSxcKePW
 fYwuGN57JIq0MIlVVemLGs9HTjeCIGClRXBZ3gP3+qUFME7RXmDh82Ci94xGZ/aDuHQO5d/1XJK
 nOWvG83Ehyt5Os2IF2l5tRew+UJINdx/5rHiIvxi5U3QkrndMcLy42IewIk9x7nAUXAEwwJdESy
 VKTDf44WukR34h8CUfAfaQ/JR1UynsVKaZBU7LcEuU7shOy9fA2QSB5IT0FN6vddj+oAdAk8ToZ
 UJbaIR/fzVsG2QPhMF8ahXfU3V/h8hQbShWhzLXY1wIKkSst72xQgy1rCRt/HS8IHalFFur2OOc
 iIGXRj7N
X-Proofpoint-ORIG-GUID: iUe8y2EGS-BpnmODYpNQsowK0dTTA5XC
X-Authority-Analysis: v=2.4 cv=SNNCVPvH c=1 sm=1 tr=0 ts=68af4860 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=RZE5Jt-HtoTff_lTyEUA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-27_04,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 suspectscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508230021
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 738372000B
X-Stat-Signature: ep34xozwsxy5n9yndiyza9fmjhmknnjm
X-HE-Tag: 1756317794-765663
X-HE-Meta: U2FsdGVkX1/43glFlQ+iyu83WrnRnl40xBixNf/oFnAHEyuwbJM0GUCMxL+Y6ydgG4zEc3YHfRPS3c2ChKGEseaJVg24xAfIAP7qQQFOz3876W0+K28kp9AnBCpVieBmo4MQGT7IoJdD4LGfyjr27N3S88XtxMCML9Dq8SiZBEbTzq8Gz0qLRX02a9y7bgM/j+QHiSkgotd+J6QRQFmalyET1AQkZe/0hoxqD5s+0rL2Zrv9AxfbpdM3dVSZ/rJqLarD8AhNv+CzuZLlgJyYQ+99snEb0bKF/+BVl2q7Skj79C/p397uXxZEv/n3ix1SDvtnx65wyRfOYpnIOVC5kOJXrsxzofzphH4j2a9r2QIGWL5Fw6YKv7YIImbyVzWyU8Okc340BfJlDK1GqjpRDrq2l1LsyUANT3LAw1An3W+AB17orwptHEzYvotzzQ6zdtb9ieoPQkCtIg+93gW+7yFMI+4i6zIqL8dfPO2n8lTy7v6e2wKS4o50LfPORHURKgtoYYFPaugJM5b5D3Cfp57SGixKKrUrUpdGtmrJOOawpUN7Y1BM56++iMaM2uTd/3Z4b1Gxo6LwVk1GR6NXHm7C+9REMvYpNSFcjWa2Vd3VdX8ZsL4Q9h9DUUNma241w7y4EZAaA+LO5frfLSEFcKl5HFxuBT6KqhH7Q0UKOnnlBogPGUFWkBUc6pAUDCQ5H0Wo9yJYDswUHJzrm+LtOo+ErWXZ+Jj3ddDyidFzflZn93ePojmgQzcgLvkHFAcdnR1rtsRG7g7q7zafrAdOHWA0ycfMMcybtyciyS+zbN6XO6nKLsfkzz+UmfKA7h6Vs9PVoyXslNekANDvoJsdPi+bnUn+FBilXGSUC1b0qj0Hx8SzmByaQpNpZgfEy7DZz/7tBXiJHACXiUIVwl+Hzvm7BAX8gK1+dcpXG1tLnr3jSQ13hlF4y4LzIMqmBnT8nqrrCk8Sf+wlqmBz4L2
 v7QHXaOS
 Qpym+z5wuRH7qTvfngxSOaWkGnT9Bm5AHBZ9uRUznfTOMOhKLuKqwYy/LbEG7c5JiNvX1X17VVODdtk27f2DBryqHcslAdWVfFo4n4PbUKPzEn247ptRRfEAdiIS+QuPS0CfV0KxhFybH5vHwdngeP84BCcRKIuQLvh63+mhFb+2J95IM6YRHf9RcY0KeOywxoPjogXFH6VvwQX3487mdnPxebf6C1I2ShYhT365wd3rr9JHATT/qchtr/dQSxH6m7FUa78YBPAGUy/Y5/WrhtaMhmwnTtcipLVYSJhJ03rdbgMGacmvDePSz2hYvHxMiqp7rhbPoq5twvH5Q1+V+7R1hsYFwy70x7qcKTZ2Iy9PeIm2J+Jz8PN4RUqb0hEx0rivTSvT9KvBT2bxwipogjuRllaLnjhJlgHz60XbZNnapJ40+Rq2e0IC7I2CfQ4jPO3/GXoS+hMn/zRD7HfvCDXeBP0wrElYbQh1p2kPUS6o9mcsGayqpYLVk9jDv8HFqISV6o6JKayfl7FQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/26/25 6:49 PM, David Hildenbrand wrote:
> On 26.08.25 14:49, Donet Tom wrote:
>> Currently, the KSM-related counters in `mm_struct` such as
>> `ksm_merging_pages`, `ksm_rmap_items`, and `ksm_zero_pages` are
>> inherited by the child process during fork. This results in
>> incorrect accounting, since the child has not performed any
>> KSM page merging.
>
> So, the situation is that our child process maps these pages, but it 
> does not have any stable rmap items corresponding to these pages.


Yes


>
> rmap_walk_ksm() spells that case out.
>
> Can you clarify that in the description here, and how both stats 
> correspond to rmap items?


Sure I will add it in next version.


>
> What is the effective result of this misacounting? I assume only a 
> higher number than expected.
>

Yes the number will be higher than expected.


>
>
>>
>> To fix this, reset these counters to 0 in the newly created
>> `mm_struct` during fork. This ensures that KSM statistics
>> remain accurate and only reflect the activity of each process.
>>
>
> Fixes? CC stable?


I will add it in next version.


>
>> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>> ---
>>   include/linux/ksm.h | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/ksm.h b/include/linux/ksm.h
>> index 22e67ca7cba3..61b8892c632b 100644
>> --- a/include/linux/ksm.h
>> +++ b/include/linux/ksm.h
>> @@ -56,8 +56,12 @@ static inline long mm_ksm_zero_pages(struct 
>> mm_struct *mm)
>>   static inline void ksm_fork(struct mm_struct *mm, struct mm_struct 
>> *oldmm)
>>   {
>>       /* Adding mm to ksm is best effort on fork. */
>> -    if (mm_flags_test(MMF_VM_MERGEABLE, oldmm))
>> +    if (mm_flags_test(MMF_VM_MERGEABLE, oldmm)) {
>> +        mm->ksm_merging_pages = 0;
>> +        mm->ksm_rmap_items = 0;
>> +        atomic_long_set(&mm->ksm_zero_pages, 0);
>>           __ksm_enter(mm);
>> +    }
>>   }
>>     static inline int ksm_execve(struct mm_struct *mm)
>
>

