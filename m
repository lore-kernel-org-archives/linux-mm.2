Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E47110F2865
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 18:54:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D7136B008C; Fri, 27 Mar 2026 14:54:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AEFA6B0095; Fri, 27 Mar 2026 14:54:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69D2F6B0096; Fri, 27 Mar 2026 14:54:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5887E6B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:54:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D5B1D14126F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 18:54:39 +0000 (UTC)
X-FDA: 84592744278.25.F35ABC2
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5767C4000B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 18:54:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=VlwS5Xz1;
	spf=pass (imf07.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774637677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TlW9BNNRrexZjfCFbEEazoVNUBAQydVdjXTuEnMtgLs=;
	b=HCwSNFclDSXWR1cdgmftK/ua9oBQyOoRX+TYIfAAODg6DUU3F83+3Xi3Ck1sYhpTlNGGjD
	ClJkvIBqxmGQtUFpVKnKCUpFpiWUuU06fprym/npafo2AX9rLvppmLRUIsow5RZTXNtvIs
	dGaLtcGg20xApaTEGxOy3YSUtbtSeFg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=VlwS5Xz1;
	spf=pass (imf07.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774637677; a=rsa-sha256;
	cv=none;
	b=uiRYhp1QXlOMYYwwbzx+I6712aaO1nW/NRwHTE23mMsTP5yA1l1N1lmpBDLXV7eygjDKBY
	qiIYZQaKTAlLXAngWrS/mPv4n8hys95CgrwlA6YauNuGLOROD4KIEQ2NLlZiStwbj8xZoG
	xMOXvhvgoXw960woJsi7jsP/V3kbXiw=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62RAKCmi3275715;
	Fri, 27 Mar 2026 18:54:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=TlW9BN
	NRrexZjfCFbEEazoVNUBAQydVdjXTuEnMtgLs=; b=VlwS5Xz1eb1XJB5F1ypZ0J
	9A1jl/b8Q23mq/zP467Sgxa8SYnVxeS6EGGYVDhD4ne0KjjGBft3ZwxQiCsosjUp
	jkWCuRDEdBEqgs+F/9O5Zn6WUzXTrP6Lf70weMyzXLKR070e1WLkRejgtDl1vwGF
	RgFqiOJ/lBksQWBkFKYywInxaq+yKv+nl2IeS5/bfiEcnriAY4y1aZRVroQrKm+Y
	tUQvW4/uO7AsZZyYYTBC9SkOCvXcq9W0S5gP5RcpGinPpz1yZwuF9odd/KyS3uQu
	YdU+WYZkb+S46HMDLIkUcbUVqiaMAfBAVMwCB4nbwS9WHRWZ+12NbBoUIAwJRYbg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1kxqus7f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 18:54:22 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62RGAsfU012203;
	Fri, 27 Mar 2026 18:54:21 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4d27vkgmen-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 18:54:21 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62RIsKpS22479412
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 18:54:20 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5C49B58059;
	Fri, 27 Mar 2026 18:54:20 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9C94358043;
	Fri, 27 Mar 2026 18:54:15 +0000 (GMT)
Received: from [9.39.31.223] (unknown [9.39.31.223])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Mar 2026 18:54:15 +0000 (GMT)
Message-ID: <2b8f30a6-a8d1-4ea5-8078-5eec399c8609@linux.ibm.com>
Date: Sat, 28 Mar 2026 00:24:13 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] sched/numa, mm: Skip page promotion if cpu pid is valid
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, linux-mm@kvack.org,
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
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <f41ab7cb-4430-4338-8812-eb6aa98e9bf9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: pdv13f44JNz3stscr6j05sOF31-2DWb9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI3MDEzMSBTYWx0ZWRfX2/IxKQ9ywZxb
 6o8XoOI0Z83QeKc4khNcjLT2lRbR0EUv9ahso6ncL388JkD/vfqbM3NPD050/A188WTWRw1+egW
 0RS/eQa6vwOMYS16v2Ob5cO7sK0THeBY0EwUjMHVlz3eYCJusGWg6MUTPdsCdYxAPbu9h8wCxCw
 ZaxrzRK8WspjmnptyPWR571pfocGgCFUOgZGcYMc2NVxO+FkFIimFQRq+8wRw0emfRD8ZPFn8x8
 QpSgP8Fx4kWv3qLl92gTAU+smFGqlhtB/vmVIUbUV0G5v9ur4gCgclUv9EzeU3yxb23JcY93w87
 QOer/ZEaqwh1XS8qnwyERZD9WkRH/6RiYnBIFLupzaLwkgjYPUmnav9rZMkTggJILaHGXQdTZLB
 5+z6x9oeJU5X+qOoaxG/YZ5uoyf/4Tipe1tOnHrJmW/2HFWjZt4RS65K9PxfQfIZMPpB39Nh19W
 pS75i5gHk3elfQqo5WQ==
X-Authority-Analysis: v=2.4 cv=bLEb4f+Z c=1 sm=1 tr=0 ts=69c6d25e cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=ZNc9nmATnA53SlO39hEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: ccn_TVv-MI4uN9Z2uHN8TvsWLjm1Z48f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-27_01,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 clxscore=1015 phishscore=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603270131
X-Rspam-User: 
X-Rspamd-Queue-Id: 5767C4000B
X-Stat-Signature: 4o4rmimgidgj6w1r1ajgpioqjtndyqji
X-Rspamd-Server: rspam06
X-HE-Tag: 1774637677-792625
X-HE-Meta: U2FsdGVkX18i/Efm1cqxCUV4m15/28tMM3MuZKGdtDoqv6l5yBHe7KP4kXpDjtAAxUlaUzZ9KA6MgtvC41ClhUxVQwHuDrlSCknPhA3z9EG+bWhXL4HyKk+h3Ztlxj+j1BDyZmUylN5Yig0j1j3UHyjjTDFEkZi8V57tIMZXWX6Zip2/VBxSy4TGVrVotoRHixm2uNOmc2k6PDoFPmJ2bp/NuyfBJdqEpDJOabX+3Xt34rxT0x++5bnW7JFGNB2zeRZmUhyOAomoZTxzhOg7JFbciCxvdCULWtr210F5Typ5SY4EWDrGQwxsJLzWMb8ekQTyoSx5Qykp3nKeefKQcKZNm+1HQqDIiAzOvfQEp9ZhpBqJdJB6rqKAX4F5lC8HolNYIAm7CELyAmIoZbg3WxmRHw6KdxQJBCIq5+5y5j/xZC/WLNM6atzkB5fX2PKmFGaTbTeA+jPtWnhI0nzKZJhZ63fIAXt/yLAlbIiZjZFMCYUTMiMtJYU0tw6CehSnBlM3nIg2m9cOnEd5JZ10OM7mKHOGQhp+Jj6xP66hUZyXHy8mxeTxzs8KgkVKs1hdWc28i7O0B+KG93Y1zEThPeKpd4bc2UrFbNO5sExxW0eEziw3JJ2Ybmp+H1NRdaMSMjIYFPxdHxdVHC4Pvyd+Ow5NfnoPK0TNOKyYsxrxGb3u/Ae6qaGb1EaOMRua1EDR1VikaUkO6dsWq64utmYH0aWpIpqczVeEtkVyctv8fvl5higxDNo95GN7HRnaCn4Y6irD/ohbdd+wK3AF1AZU0P69hIQ5eYGOzV8FuPvfbgt0AOsNwGb+3y0c/R+cHtsznz2Lf6XM5nGmGKO+R3rrJgCi1OjEvN9D5+FobxjcYOqycvhCvWjPtTeDqRSEktq7iKmxsokWwhEZkubHJ7G5hfBfKxWkJPWKJlxw/8AVrFrRM9b52hRHDA5fYUyxM1pxWDDw2eegNKLWFqinUUu
 N//5ENGh
 KdaN8msdHqQUegjOzNw558/sn5O2SluB/8L35cYtS7ANWDX28ZkNro8xSo+fWbo9TbEt+Nih9fulXZzQK4jHhhPlOJQBZGpnLj7/WR9WzrSwnD52AFGF5t5XWNLX6wgpu/DjyO7eBMTNt6qQuqOE1GsrF6MCVu3R3dkWkYSQ5CBvG49J0O0EWDgUq9ss9IX6AJTW64ICdWog/AWmKB+NcsNgaIoRPTRtoZGGOCDZoDCMZd6phDS6pF3OvgdV562MHxc3G7kdKr3WToTB8o03bpZwtW8vwbaavSbnXHwa/11h6wCC8CzoZPaFSj6vGk7z2420EHvA9x02ybtmytFkxqSH+m72YcJnrbHN/itv0nBbbTTW8+a4MtxQ2qImMuTPwk0SGFW8N9BeWrYCST9p7L2O6HgrckAfdfootlLFurM84+Lk3oACQpc9FKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 3/26/26 3:59 PM, David Hildenbrand (Arm) wrote:
> On 3/26/26 08:12, Donet Tom wrote:
>> If memory tiering is disabled, cpupid of slow memory pages may
>> contain a valid CPU and PID. If tiering is enabled at runtime,
>> there is a chance that in should_numa_migrate_memory(), this
>> valid CPU/PID is treated as a last access timestamp, leading
>> to unnecessary promotion.
> Is that measurable? Should we at least have a Fixes: ?
>
>> Prevent this by skipping promotion when cpupid is valid.
>>
>> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>> ---
>>   kernel/sched/fair.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 4b43809a3fb1..f5830a5a94d5 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -2001,6 +2001,13 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
>>   		unsigned int latency, th, def_th;
>>   		long nr = folio_nr_pages(folio);
>>   
> /*
>   * When ...
>
>> +		/* When tiering is enabled at runtime, last_cpupid may
>> +		 * hold a valid cpupid instead of an access timestamp.
>> +		 * If so, skip page promotion.
>> +		 */
>> +		if (cpupid_valid(folio_last_cpupid(folio)))
>> +			return false;
>> +
> IIUC, as timestamp we use jiffies_to_msecs(). So, soon after bootup,
> we would no longer get false positives for cpupid_valid().
> I suppose overflows are not a problem, correct?

Thank you, David, for guiding me in the right direction.

I initially thought that overflows would not occur, and therefore
cpupid_valid() would not produce false positives. However,
after looking into it further, it appears that overflow can
happen when storing the access time.

The last_cpupid field is used to store the last access time.
 From the code, it appears that 21 bits are used for this
(#define LAST_CPUPID_SHIFT (LAST__PID_SHIFT + LAST__CPU_SHIFT)).

With 21 bits, the maximum value that can be stored is
2097151ms (35Hrs) . If the access time exceeds this
range, it can overflow, which may lead to cpupid_valid()
returning false positives.

I think we need a reliable way to determine cpupid_valid() that
does not produce false positives.

-Donet


>
> So what we're saying is that folio_use_access_time()==true does not
> imply that there is actually a valid time in there.
>
> In numa_migrate_check() we could still use the valid cpuid I guess and
> make that code a bit clearer?
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 631205a384e1..ba68933a9e4a 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -6119,10 +6119,9 @@ int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
>           * For memory tiering mode, cpupid of slow memory page is used
>           * to record page access time.  So use default value.
>           */
> -       if (folio_use_access_time(folio))
> +       *last_cpupid = folio_last_cpupid(folio);
> +       if (!cpupid_valid(*last_cpupid))
>                  *last_cpupid = (-1 & LAST_CPUPID_MASK);
> -       else
> -               *last_cpupid = folio_last_cpupid(folio);
>   
>          /* Record the current PID accessing VMA */
>          vma_set_access_pid_bit(vma);
>
>
> The change itself here looks reasonable to me.
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>

