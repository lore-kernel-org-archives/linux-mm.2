Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FA0BD7495D
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 08:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85D466B0088; Fri, 19 Dec 2025 03:21:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82B206B0089; Fri, 19 Dec 2025 03:21:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72D146B008A; Fri, 19 Dec 2025 03:21:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 61FEA6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:21:47 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 12D0E1604A2
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:21:47 +0000 (UTC)
X-FDA: 84235527054.12.E5F4B2D
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9C1AE1C0005
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:21:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=bn9DTFHu;
	spf=pass (imf20.hostedemail.com: domain of sourabhjain@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sourabhjain@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766132504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6W3plN+ebcTGX0uV6ORb8fAOAbPv8HSPi9pqpKhBUug=;
	b=UpOq0ILUAjZaLklUHKnBP6byEsvS6REFK/4jihCGQnrcPR5X5YdluJINE8CUbeoTb6rXmR
	6XEF5MCpamKL+5csrp/u+J6Ei7SBJIQC04BVsO0NVzG+yq1Qs2BGmrJUgCybc2gXUrRInK
	NLxazJZ7+UNt7DMCLHP17Lk8wudJoj4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=bn9DTFHu;
	spf=pass (imf20.hostedemail.com: domain of sourabhjain@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sourabhjain@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766132504; a=rsa-sha256;
	cv=none;
	b=Zzcuj/MMFcYYEdFiqMvVJHl54kPN3OMW21opC3PVmpy4Oa3sNMJiBL7k/StES2RNuBHhse
	ked4nZd5wAv56xStstVwnPyqy0Z5wCcbKsS6P6PSu0v6UMUDOVZincnanIcdeyOCT4GDVv
	RMLmEq05rWPImbIpIkKuMw3IQygdhiU=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIJm9uq031421;
	Fri, 19 Dec 2025 08:21:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=6W3plN
	+ebcTGX0uV6ORb8fAOAbPv8HSPi9pqpKhBUug=; b=bn9DTFHuCZGrhE2gIiGUIs
	DDTJlsrfAs4XYUikyrmKJM0tRK09osVCOWl+8ItTqIBmNLHs8n21NVx1RYY7uJr6
	MIHSSnO7cZoESYZ55UBe6zjnF4vDuzb8OAhgZAxhwQhSumSx7A8ExN0NkJYR0/ev
	AVvWgo7CLtAeBpAfaolZ+YaVSoS/vRQZVbHYvaOan2SKbR7HuVWfhfj3gT6SCq8K
	FS2HH7G77YpZ33Ax7nvyzHxTDApLc5EaPBvh2QGu5YGnS+3I3pIgu6hu97vGdniy
	gkjhtbRHMsiDw0sNcXvVmdol5jd643yMdA68mawZAmlVmkhcWH+9f/INx/DpJrag
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b4r3dje6v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Dec 2025 08:21:24 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5BJ8G9nG022763;
	Fri, 19 Dec 2025 08:21:23 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b4r3dje6s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Dec 2025 08:21:23 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BJ7o8Ws029562;
	Fri, 19 Dec 2025 08:21:22 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4b4qvqtrdv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Dec 2025 08:21:22 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BJ8LIEr30146976
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Dec 2025 08:21:18 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A94342004B;
	Fri, 19 Dec 2025 08:21:18 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C470420040;
	Fri, 19 Dec 2025 08:21:14 +0000 (GMT)
Received: from [9.124.209.192] (unknown [9.124.209.192])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 19 Dec 2025 08:21:14 +0000 (GMT)
Message-ID: <5acfcde7-0e8f-4228-8d9f-36b740900213@linux.ibm.com>
Date: Fri, 19 Dec 2025 13:51:05 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] mm/hugetlb: ignore hugepage kernel args if hugepages
 are unsupported
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov
 <bp@alien8.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Heiko Carstens <hca@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        x86@kernel.org, linux-arm64@lists.infradead.org,
        linux-riscv@lists.infradead.org
References: <20251218114154.228484-1-sourabhjain@linux.ibm.com>
 <83920c44-47f5-4a46-bfa7-76713197d7e4@kernel.org>
 <1fddcf72-26f7-4fb4-84b8-1328e486d58e@linux.ibm.com>
 <64a9ca24-2968-4532-ac04-594c340ec2a2@kernel.org>
Content-Language: en-US
From: Sourabh Jain <sourabhjain@linux.ibm.com>
In-Reply-To: <64a9ca24-2968-4532-ac04-594c340ec2a2@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VMo57LUGB5mbL-L32x592RHzO_CETbAy
X-Proofpoint-GUID: b35NuxmB0yfBlN4o5xEw0Ah1QGoT25Rc
X-Authority-Analysis: v=2.4 cv=KrZAGGWN c=1 sm=1 tr=0 ts=69450b04 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=icKp7thR8Zr7BtekdgcA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE5MDA2NyBTYWx0ZWRfX45K0c7/r6Utl
 KNKXLWfdlayLBssJjNgVj7rEPBSAevK6l/LaGoQ0M2OKhT5Qf9MlgqZGfC/OF8nWI4jvsFn1lQP
 Y1FjKKtiotAj6+SrSiT2+FmJLB8KR9khO/CWVPGQiIh8XbteCM4csCF1eNb+eKnmicpWDyTNt4r
 0/lr+1AHIzsVaZEimA7fpllXp0yY5lXI7MkrRSpPn7d9bCeMGQSsnCf3dSdDSavufzEzTbdfHcm
 ukyIRewxefX64hHILbTZT07U3yblpXnNyxZ0NJGc2CRKEL9JXZlpkw5ruePXww8vQnH47vMbhOY
 n2rMYhkujHoja5eoJ0Zb8IJnb4FhM1WEyK7wHdq8EfDWrufHxeEJuRau4OWrhgD1p54MAL5XR9L
 K3p3GYNKwEmN3/cuHCGpKGrQwzijtEyaBS/KG7EueNliCtpNZJdMNFqpQWsFyCTDFodp0uYcJu4
 ggpS+FRJEmgVlPMw/Cg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-19_02,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2512190067
X-Rspamd-Server: rspam02
X-Stat-Signature: ttrrfxnjjf8swie339sn9du7ajy359mh
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C1AE1C0005
X-HE-Tag: 1766132504-985245
X-HE-Meta: U2FsdGVkX1/R/Fsb5kF5IlHo6MG4eA9BpxQMfynGBT1CvCkjxiGUe/xs0CPnyA7FKKZPuUdtFOYPy25AMoTMnpzsDSOessc/yIAHc6lqdaN4AXZQt9op8ZBxpBj/xd/kJ/vebCXuSMnikOAzyl923Tcp8usanZf2JCisV0GacUyUz7V78RQ5nu+D67xiFonCJtZaVxXQqXxessiCAiWwbXJQuOnbXg1x7G+V6mP8ADnnznuwYIEWJC3El2V0Q6GkXGWsJqedbNB9IGNdx3YzxMM/H1vXQimpAaR8pfC068r9MNo1U44RSDoCBdLIPO6TPTfW57zHXSIFjSNcq+hkOKEkd9cW0lJL9EPEgiYlyYwyv4DQt4Xj9sRYfqyCJNB9Gb48MKjVJrwI1nM6DsfsDJrZLjPbWyHMDj5TUnSGAmym5UxVSxM1je/a/0XsNAvjt3hjoJWePrjDv8YJNnxU0ou+mHUgl6ZJ7ZJJdEcAFQ2V3vZLt+ulsN+SpWGzNh5SwOa7YbAseHADRf0xGCDHE79+Gw6hBC5gsAQH+ytqDKrxwslLC5reQdOHnFiOfGnWSGlfeHn4+LrCt+t9i36scUsxJT3S3vu9iuMLRy0CqavbTGZ7gRPY7FuAgU7MIFi09Y5jHMPk85jxGN6qrfEJWIl9MyKIPmzhu+NQAEYsEJJk9guGxbOON1KFDiE+UV3uZ0qhv7r990C3oE5W3otWqzsWzAHkeMISbC+QpY4kfUl0rGSvflmKqqnCIgd2R6AWsQ0EnVNUHboLFfUhp7+ALdyLP7B2RrxAsEGwxKpL4kvYRUgRJaRh6Vh1zzrNBzkwRTgkdHFp/lPTdkB6g/bZizJwwMMs5s/ld6JRhcFOXuqeja3Fp0KSNPQr6teqfVndw9P9UbClGBCrhyNRA/IZR9F+V0V1+MDZ4Dx3FW0x4X26jzgUz3cEVIruYp3i0SRtP2PtzaWlT+S0n+9Pfhz
 ZWm65u3g
 q+umn+Ub1O5owUqKjSnAWAjjPlbqJgIN2Nud9eiEncARfZWRRBX+sxZCuoA9qwRYAvQmzbtaWu59EiUag5NOhYA7a4A02VhyCtox70lZH/D9YQ5XgIURFBDlzp+R32WKB9+HFGzj0h1HjIGfrzDPHzCo2kkcx489TM3bZZbYbD6nLm27/UVpi3sF7pDAZPu8H2zvRCvZEL8LCW7R4Cnajv4hg4FfDlOhiZCcw07beU2JZ8QHqR1ETl5U5zGqsftf/P4/c4Ahecspv3X8uCeg5++O7EGFf4LIgLfzycnTgQ1QvMbOtOHEG0+tQjItjBmX7eSslZnx/Z1fhDDQ/6j6WFH1BM2hMsQyMVWK5u7qpuq3ZhcKdkFYfF+xde4ExbKMuPdNjiDnOmtR7ukZHwvMhK80Eg7tYozF4zVFxWy5XPXz25xibq2vfM3B1Ba1IdqUQHkCBkPqT0/H/N83Acd9hsIT4ZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 19/12/25 11:43, David Hildenbrand (Red Hat) wrote:
> On 12/18/25 14:06, Sourabh Jain wrote:
>>
>>
>> On 18/12/25 17:32, David Hildenbrand (Red Hat) wrote:
>>> On 12/18/25 12:41, Sourabh Jain wrote:
>>>> Skip processing hugepage kernel arguments (hugepagesz, hugepages, and
>>>> default_hugepagesz) when hugepages are not supported by the
>>>> architecture.
>>>>
>>>> Some architectures may need to disable hugepages based on conditions
>>>> discovered during kernel boot. The hugepages_supported() helper allows
>>>> architecture code to advertise whether hugepages are supported.
>>>>
>>>> Currently, normal hugepage allocation is guarded by
>>>> hugepages_supported(), but gigantic hugepages are allocated regardless
>>>> of this check. This causes problems on powerpc for fadump (firmware-
>>>> assisted dump).
>>>>
>>>> In the fadump (firmware-assisted dump) scenario, a production kernel
>>>> crash causes the system to boot into a special kernel whose sole
>>>> purpose is to collect the memory dump and reboot. Features such as
>>>> hugepages are not required in this environment and should be
>>>> disabled.
>>>>
>>>> For example, fadump kernel booting with the kernel arguments
>>>> default_hugepagesz=1GB hugepagesz=1GB hugepages=200 prints the
>>>> following logs:
>>>>
>>>> HugeTLB: allocating 200 of page size 1.00 GiB failed.  Only allocated
>>>> 58 hugepages.
>>>> HugeTLB support is disabled!
>>>> HugeTLB: huge pages not supported, ignoring associated command-line
>>>> parameters
>>>> hugetlbfs: disabling because there are no supported hugepage sizes
>>>>
>>>> Even though the logs say that hugetlb support is disabled, gigantic
>>>> hugepages are still getting allocated, which causes the fadump kernel
>>>> to run out of memory during boot.
>>>
>>> Yeah, that's suboptimal.
>>>
>>>>
>>>> To fix this, the gigantic hugepage allocation should come under
>>>> hugepages_supported().
>>>>
>>>> To bring gigantic hugepage allocation under hugepages_supported(), two
>>>> approaches were previously proposed:
>>>> [1] Check hugepages_supported() in the generic code before allocating
>>>> gigantic hugepages.
>>>> [2] Make arch_hugetlb_valid_size() return false for all hugetlb sizes.
>>>>
>>>> Approach [2] has two minor issues:
>>>> 1. It prints misleading logs about invalid hugepage sizes
>>>> 2. The kernel still processes hugepage kernel arguments unnecessarily
>>>>
>>>> To control gigantic hugepage allocation, it is proposed to skip
>>>> processing the hugepage kernel arguments (hugepagesz, hugepages, and
>>>> default_hugepagesz) when hugepages_support() returns false.
>>>
>>> You could briefly mention the new output here, so one has a
>>> before-after comparison.
>>
>> Here is the fadump kernel boot logs after this patch applied:
>> kernel command had: default_hugepagesz=1GB hugepagesz=1GB hugepages=200
>>
>> HugeTLB: hugepages unsupported, ignoring default_hugepagesz=1GB cmdline
>> HugeTLB: hugepages unsupported, ignoring hugepagesz=1GB cmdline
>> HugeTLB: hugepages unsupported, ignoring hugepages=200 cmdline
>> HugeTLB support is disabled!
>> hugetlbfs: disabling because there are no supported hugepage sizes
>>
>> I will wait for a day or two before sending v2 with the above logs
>> included in
>> the commit message.
>>
>>>
>>> Curious, should we at least add a Fixes: tag? Allocating memory when
>>> it's completely unusable sounds wrong.
>>
>> Not sure which commit I should use for Fixes. This issue has
>> been present for a long time, possibly since the beginning.
>
> I don't know the full history, but I would assume that support for 
> gigantic pages was added later?
>
> It would be great if you could dig a bit so we could add a Fixes:.

Sure, I will try to find it.

>
>>
>> I also noticed an interesting issue related to excessive memory
>> allocation, where the production/first kernel failed to boot.
>> While testing this patch, I configured a very high hugepages 
>> (hugepagesz=2M)
>> count, and the first kernel failed to boot as a result. I will report
>> this issue separately.
>
> I'd say that's rather expected: if you steal too much memory from the 
> kernel it will not be able to function. It's the same when using the 
> mem= parameter I would assume.
>
I reported this behavior as an issue yesterday; let's see what others 
think about it.
https://lore.kernel.org/all/cb9f3604-8a0a-478a-8bf7-2d139ccbc89d@linux.ibm.com/


Sourabh Jain


