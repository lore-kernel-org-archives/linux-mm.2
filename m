Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6628CC982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 10:30:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7985F6B0093; Thu, 17 Sep 2026 06:30:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 749466B0095; Thu, 17 Sep 2026 06:30:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 638C86B0096; Thu, 17 Sep 2026 06:30:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 428966B0093
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:30:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C5A89402CF
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:30:15 +0000 (UTC)
X-FDA: 85222884390.10.85F984B
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4E49F1A0006
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:30:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UB9Mez9w;
	spf=pass (imf19.hostedemail.com: domain of sourabhjain@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sourabhjain@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789641013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XN7HVKJtZSz9og9g+wQh8pvmMxNLYZqB67Fm0+hPgCU=;
	b=MhrTd4m7lhNk+NJwuBAUf0cl7ap7nIg12pd6Xm4HCWlAYQnznk+MU0BpN9kZVBI3iktCMP
	4hl5dDbN8u9L7eE5Iv+nyAZTrjuL5DYweXvO+smg8Z7zwCRciReHsyOIPevSYcIPT7ggGw
	/mTNODcl2jlPnOGJEIZVPcXiQDLfYgo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UB9Mez9w;
	spf=pass (imf19.hostedemail.com: domain of sourabhjain@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sourabhjain@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789641013;
	b=IIXKwoiBQMZ3Po5ci4WlvIOmsMvd++UAwwrn7yQXMNVj77INIAZsuAprIcTP/G1o8Qsv8q
	MTj6oZELPzV5A0GhZB+GSeTex0MSF7F4HCS0PWZi8uadZprqNqil8y8BHWPoeYD6vyvtUJ
	BLlZNFNXKMfAnoztmL/KqWoQhge52cU=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68HA1WAt2205751;
	Thu, 17 Sep 2026 10:30:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=XN7HVK
	JtZSz9og9g+wQh8pvmMxNLYZqB67Fm0+hPgCU=; b=UB9Mez9wgVSbLLKt3nltTd
	vtWJrzs/AuV45Uzot7sxzc1qmKE+lAdXWb6/26MjpQ2MzFMQYUFwNiCcrmnwFbQM
	OdmTnlT97yhxQ3H++Hsy5tLzCAmoIZv9eAm88A8AeRT2SlletdMjMNXJ8yl52Xi1
	HSxzQ4jqR0uguGl6A2Y4E5exPMKTv7DBrnIbJSR6/BWdD03fY7cvMYy/SSFD7QHp
	avn1SZmOx7Wdn0OQoZT/uWrDUOsAw1ba3ZqzOmslUig7AOYS1tKLCTcOSTN0vxSK
	rL1NPHU9r2fsc25hFWkn9mR0MxKoauyMW76MlrcEEOzPO1wYKmu8NO+8HocspmRw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxf59sxr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 17 Sep 2026 10:30:06 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68H9aHRR2962374;
	Thu, 17 Sep 2026 10:30:05 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gra3ys076-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Sep 2026 10:30:05 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68HAU3uk27066644
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Sep 2026 10:30:04 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CF06120043;
	Thu, 17 Sep 2026 10:30:03 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7B06D20040;
	Thu, 17 Sep 2026 10:30:01 +0000 (GMT)
Received: from [9.123.14.142] (unknown [9.123.14.142])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 17 Sep 2026 10:30:01 +0000 (GMT)
Message-ID: <0969ede4-f617-4e24-b32e-c5e30a96880e@linux.ibm.com>
Date: Thu, 17 Sep 2026 16:00:00 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] liveupdate: kho: calculate per-node scratch sizes
 before allocation
From: Sourabh Jain <sourabhjain@linux.ibm.com>
To: George Guo <dongtai.guo@linux.dev>, rppt@kernel.org,
        pasha.tatashin@soleen.com, pratyush@kernel.org
Cc: graf@amazon.com, changyuanl@google.com, akpm@linux-foundation.org,
        chenhuacai@kernel.org, liukexin@kylinos.cn, guodongtai@kylinos.cn,
        kexec@lists.infradead.org, linux-mm@kvack.org,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260904025101.9959-1-dongtai.guo@linux.dev>
 <616daf17-4598-4a30-8574-16480dfc23cb@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <616daf17-4598-4a30-8574-16480dfc23cb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: 9kBhWDxzKEIXlqR8yCNcou2mv5J-iLVE
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDEzOCBTYWx0ZWRfX4nKOPkxkEHZH
 cbCPACV+Q8ZXOWnkBfLFBFAxfYGC1ICYywpk1xHZ/vR2wqH24j28Z0hv59KXNH1ertcNpZrOoAP
 RkbmX9iLganfS9LSwe6XEBF1JghRDjU=
X-Authority-Analysis: v=2.4 cv=cvgOAF4i c=1 sm=1 tr=0 ts=6aabc12f cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=cCf1g51oGTkv6yQ4Xg8A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 7mAPHVSLg7bMiEO_a2HtaZ1DTH2y0rqY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDEzOCBTYWx0ZWRfX0dWwNtLff6Nh
 om5qwwSOmvYF+uPvh6/PaymH9q1jXDuH+lhv2Nj53RPQD7rdRzsUyd1gPXc969endwNVdYP9MoH
 qRk+kAIWZItfE4mkjTIP3rqbY0EP9jjimL5rCNIR2/FzURYQxPddaBMmTqi9wKwcpGgIfFxB/oa
 126tMjZeRxzYkQn92G4VtAzYneIuki5Bi8FSedBsVNrP+MMfgiL5oKK6WgP4qCLM+xz8yhpd/XT
 ebOMfU0Q4szU/8gLUbBKFzdM/rKC6pFz/lADmhFUHRnRNQuWvEcQxK6wyyAoo/U8vQNsCovNUdg
 iLK8mmYCK+1D+jqofmDho1GiWqbE00z8ZFaGjTxo73mEIG5BCSwD5un0/skSzzFdODU8/3q6+sG
 K7gOvmqOZrXjZwZ8iPmr4/0pXwKjFFXLh1cmyyniGzfAXyheqUmqJx5/gzB0w2SJ26vcYHDBKKK
 FzkHdK8lP3zsXbuwTLA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-17_02,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609170138
X-Rspam-User: 
X-Stat-Signature: 3sw3xieiiqzaak8nuucj99ka9n6f5h7z
X-Rspamd-Queue-Id: 4E49F1A0006
X-Rspamd-Server: rspam07
X-HE-Tag: 1789641013-823023
X-HE-Meta: U2FsdGVkX1/eff5OLhvJrN3vdoVpa2xVrK10OEPmqsnuYceWu3n69KjatUVNvOE6dol1x6w4jlA3cTRKa+3xBWXutqqydgwEPKX3Y9lUmn0s0C4XQsjdrpVS/4UtEJjduW6C3jsdwSU6i+Iasr7+G/+dTIq1N6OGLOS6wxSGdHDQ8NxHGWoazeBnzVl+zHpcqBRi472Seqj0jDaL2rT3HbHUE/0OI3Lh3+1EDrnUNRIQDQ9VEAj/xI1oRe+z9D31VZYxFHicaCuT63ulZrZplQjYXQ+nVwvq6WRFPXDFJa0rM5KnSPtCeeTyq2YYUkV+mR4q0el/dWnKYjV4coxTrRuVepFZGTc311A//ESfKoOLhMZb9VYOxdHF0u+7BBtH7w7iaw1x3VF8sfsq3cCc4z14s0e33z7gxopWX2fQ9Hmc0ZbW9yv6r8kuzEMU2vxNPZC0kGIyT/TCq7sBiqkXM9FptYr7D9w6t4jNsOpQKo1ni+TyIqKuVKAhNsDXuBGGiEBu4C0pdwJBQUU6d2SsJpgbrwTKNHPSuv7UzSqwNGVbATH+WAPpTu4T0mrDzRL2yh2XOJajiKVLJ/sI1aAHSsiFj/Z2Z1Uh5QUWlhIRbQ14t8vgoY2uaXx9sKSOLgtQN+J+iE/Xyt6UKVsDF+hhGhRIrzpcO1tpl0KDk5QQI2I4ZrbemrPv9RotF0f1Bu/uPe+kWetLnZoB31YkMlCfrmauNliWic2guQ45aEUgIb6EAoE8zRX0t1x9QqSK8056db/yzB3SW3bFMQCbTzOf7hWdswHATop7fR3G+PYaPgyvsgZ3BCE5QIcMRd9NAuyyTJA7NsCRLDV4h2P1PRPdD7JThV1wgw2RsH/ORkTDLpTt6YZvIuU5ohvh25VFJ4JG3jJRHoO9HUaw46ekFXdgjzMA9vQnws+tccYRZF66X7sakjmbvmeC1eWCEW1sf/cf7Runo11MAkNCEPs6YaX
 hKxa+Jzk
 bz2NG95aN5ijaaHM5wZRkffsoFFv6PfuyLBbgfsRBV8orGT2YvRLhtlUhlas9N86TUO27oo3s2od3YneVQRlo8C37QJRqY0JL+alXr17qyQFwT/gGVJiRTEgdQn8reX6B3MyeLMOVQFI/WFrOcAKunTPZIXGgxbO1mqVl1eHFLUzL0u4ptcY4/ayJRHsa8qHpG1ZCLLGRZtxzzncmdZIoSEbsXpKWJUQHVAM18lU36UMC7lfYmrkoEWU72JBAIpw6iDSeQENQILYJRmGRpN0e4SxArWT4c/1PDlGvGxzlavpD7dhIV1Cd5QkALEYyiNptCA/zMUpNBpzKR8D77L0LQk8xhzfc/BNkZIhk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello George,

On 12/09/26 12:03, Sourabh Jain wrote:
> Hello George,
>
> On 04/09/26 08:21, George Guo wrote:
>> From: George Guo <guodongtai@kylinos.cn>
>>
>> The default percentage-based policy sizes scratch areas from the current
>> kernel's MEMBLOCK_RSRV_KERN footprint. This is a reasonable heuristic 
>> for
>> predicting the early memory demand of the next kernel.
>>
>> scratch_size_update() calculates the lowmem and global sizes before 
>> either
>> area is allocated. However, kho_reserve_scratch() calculates each 
>> per-node
>> size only after allocating the lowmem and global areas. Since memblock
>> allocations are marked MEMBLOCK_RSRV_KERN, the per-node calculation
>> includes those newly allocated scratch areas and scales them again.
>
> I may be missing something here, but doesn't 
> memblock_reserved_kern_size()
> check the node ID of the region before checking the region flag 
> (MEMBLOCK_RSRV_KERN)?
>
> Code snippet from memblock_reserved_kern_size()
> ```
> if (nid == memblock_get_region_node(r) || !numa_valid_node(nid))
>     if (r->flags & MEMBLOCK_RSRV_KERN)
>         total += size;
> ```
>
> For a valid nid, my understanding is that the global and lowmem scratch
> areas should not be counted because they are allocated with NUMA_NO_NODE
> (-1). So, ideally, these regions should be excluded when calculating the
> reserved memory for a specific node ID.
>
> Based on this, I am not sure that marking the lowmem and global areas as
> MEMBLOCK_RSRV_KERN is what causes the per-node size calculation to be
> inflated. I am looking into the code further to better understand the
> actual cause of the issue that this patch is trying to address.

I added some prints in kho_reserve_scratch() and found that the per-node 
size
calculation is not impacted by the lowmem and global scratch memory 
allocations.

KHO: Before low and global scratch allocations
KHO: low size = 899 KB
KHO: global size = 137 MB
KHO: Per node 2 = 80 MB

KHO: After low and global scratch allocations
KHO: low size = 312195 KB
KHO: global size = 441 MB
KHO: Per node 2 = 80 MB

KHO: After per node allocation
KHO: low size = 394115 KB
KHO: global size = 521 MB
KHO: Per node 2 = 240 MB

I only had one NUMA node (nid=2), and the per-NUMA
allocation before and after the lowmem and global scratch
memory allocations remained the same at 80 MB.

The experiment was done on the PowerPC architecture.

I am wondering how the per-NUMA allocation in your setup is
getting inflated due to the lowmem and global scratch memory
reservations.

Feel free to use the change below to print the similar states
in your setup.

index 9260e601c..b5bd9617b 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -670,6 +670,24 @@ static phys_addr_t __init scratch_size_node(int nid)
         return round_up(size, SCRATCH_ALIGNMENT_BYTES);
  }

+static void __init scratch_size_print(char *s)
+{
+       int nid;
+       phys_addr_t size;
+
+       pr_info("%s\n", s);
+       size = memblock_reserved_kern_size(ARCH_LOW_ADDRESS_LIMIT, 
NUMA_NO_NODE);
+       pr_info("low size = %llu KB\n", (unsigned long long)(size >> 10));
+
+       size = memblock_reserved_kern_size(MEMBLOCK_ALLOC_ANYWHERE, 
NUMA_NO_NODE);
+       pr_info("global size = %llu MB\n", (unsigned long long)(size >> 
20));
+
+       for_each_node_state(nid, N_MEMORY) {
+               size = scratch_size_node(nid);
+               pr_info("Per node %d = %llu MB\n", nid, (unsigned long 
long)(size >> 20));
+       }
+}
+
  /**
   * kho_reserve_scratch - Reserve a contiguous chunk of memory for kexec
   *
@@ -698,6 +716,7 @@ static void __init kho_reserve_scratch(void)
                 goto err_disable_kho;
         }

+       scratch_size_print("Before low and global scratch allocations");
         /*
          * reserve scratch area in low memory for lowmem allocations in the
          * next kernel
@@ -730,6 +749,8 @@ static void __init kho_reserve_scratch(void)
          * Loop over nodes that have both memory and are online. Skip
          * memoryless nodes, as we can not allocate scratch areas there.
          */
+
+       scratch_size_print("After low and global scratch allocations");
         for_each_node_state(nid, N_MEMORY) {
                 size = scratch_size_node(nid);
                 addr = memblock_alloc_range_nid(size, 
SCRATCH_ALIGNMENT_BYTES,
@@ -744,6 +765,7 @@ static void __init kho_reserve_scratch(void)
                 kho_scratch[i].size = size;
                 i++;
         }
+       scratch_size_print("After per node allocation");

         return;


>
> With that said, I wonder if this fix might be more of a stop-gap 
> solution.
> As mentioned above, since NUMA_NO_NODE (-1) is used for the lowmem and
> global allocations, my understanding is that these areas ideally should
> not be included when calculating the size for a specific node ID.
>
> I could be missing something in my understanding, so I would appreciate
> your thoughts on these observations.
>
> - Sourabh Jain
>
>> Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation 
>> helpers")
>> Reported-by: Kexin Liu <liukexin@kylinos.cn>
>> Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
>> Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
>> Signed-off-by: George Guo <guodongtai@kylinos.cn>
>> ---
>>   kernel/liveupdate/kexec_handover.c | 13 ++++++++++++-
>>   1 file changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/liveupdate/kexec_handover.c 
>> b/kernel/liveupdate/kexec_handover.c
>> index 7c4d86daf86d..39f489a258d9 100644
>> --- a/kernel/liveupdate/kexec_handover.c
>> +++ b/kernel/liveupdate/kexec_handover.c
>> @@ -847,6 +847,17 @@ static void __init kho_reserve_scratch(void)
>>           goto err_disable_kho;
>>       }
>>   +    /*
>> +     * Calculate the per-node sizes before reserving any scratch areas.
>> +     * memblock allocations are marked MEMBLOCK_RSRV_KERN, so 
>> calculating
>> +     * them later would count the lowmem and global scratch areas as 
>> kernel
>> +     * allocations and scale them again.
>> +     */
>> +    i = 2;
>> +    for_each_node_state(nid, N_MEMORY)
>> +        kho_scratch[i++].size = scratch_size_node(nid);
>> +    i = 0;
>> +
>>       /*
>>        * reserve scratch area in low memory for lowmem allocations in 
>> the
>>        * next kernel
>> @@ -880,7 +891,7 @@ static void __init kho_reserve_scratch(void)
>>        * memoryless nodes, as we can not allocate scratch areas there.
>>        */
>>       for_each_node_state(nid, N_MEMORY) {
>> -        size = scratch_size_node(nid);
>> +        size = kho_scratch[i].size;
>>           addr = memblock_alloc_range_nid(size, SCRATCH_ALIGNMENT_BYTES,
>>                           0, MEMBLOCK_ALLOC_ACCESSIBLE,
>>                           nid, true);
>


