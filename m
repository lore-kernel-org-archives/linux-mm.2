Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 961FAC982DA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 05:31:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50D2E6B00D9; Mon, 21 Sep 2026 01:31:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E28D6B00DB; Mon, 21 Sep 2026 01:31:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F75C6B00DD; Mon, 21 Sep 2026 01:31:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 19A196B00D9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 01:31:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 61E86A0559
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:31:22 +0000 (UTC)
X-FDA: 85236646404.28.56169F5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf14.hostedemail.com (Postfix) with ESMTP id D939A100006
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:31:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ITST43vd;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf14.hostedemail.com: domain of sourabhjain@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sourabhjain@linux.ibm.com
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ITST43vd;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf14.hostedemail.com: domain of sourabhjain@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sourabhjain@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789968679;
	b=dboz/Vo5TghoGNn1mSUAKyZoSjxHNQvrQQZYI3bAlkDnpKhhD/krp3Er3n8pAzCuRG34sF
	/nGY8QdKyJaReyI5k5lh2Nf0x1EQOhy50jEODRcfOUXescsqhDBa+GXA4ZF8QN87qisr08
	38HrrdHmwrc9lYULFFVB+b01et52xek=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789968679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9GfQGwi/bINbQG0lJ4TrNy13j95JizRsDT1BfgiquJ8=;
	b=EehYEkoX27Ex6nmOV8K8DACjlNB3AyKI/RxSJUAERUCjOnP4JbGay5E09N3OGN5m88y1rq
	a6vqghp4vaaKTY9SYlWWXGYeaFETeerWqRcPooSV1gk9aDGNQLVFCsvxoWJun94vzLHbeF
	MYvqj9P5r6+TnP4MQFHj5wHWpcyMTQg=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68L3aniH122829;
	Mon, 21 Sep 2026 05:31:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=9GfQGw
	i/bINbQG0lJ4TrNy13j95JizRsDT1BfgiquJ8=; b=ITST43vdOtjfRXFtREB0mH
	SwN7lMADtBCz5BoK5pNJ0SnlasjAC0yaI5C+vHARRRxkl5PBMxRkeiuHUPOEAHmB
	sr3JvM9Febhh1JiJ9vQ/tzWyZ12xnuZoyKt/pkzuGJ46zfy07IXgWqwmLjY5K8Wh
	FTsoKNV66rD+oeTFd7JfTowh+360JWlKVmbdmLZzBO9AL2EJEtNeVoxi2xl8UHbp
	Mex913+DZvP/Sx8sm4lpJ4djzHbhP9QorE2rl+jPS5sidc3KSeHdYqIOVuv9/geF
	O58d1qXHOJEv9mWkDjsEt+RLsf8lJpjhmMSUxCuQ/oR1y5jGm6WDv01ML0XDcaqA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gske16sam-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 05:31:15 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68L3XWf01596402;
	Mon, 21 Sep 2026 05:31:14 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gt7dy3p42-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 05:31:14 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68L5VCHJ50397628
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Sep 2026 05:31:12 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 78C272004D;
	Mon, 21 Sep 2026 05:31:12 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 383C820040;
	Mon, 21 Sep 2026 05:31:10 +0000 (GMT)
Received: from [9.123.14.142] (unknown [9.123.14.142])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 21 Sep 2026 05:31:10 +0000 (GMT)
Message-ID: <e0af4c02-039c-4afe-9349-cedc1bfd3cbf@linux.ibm.com>
Date: Mon, 21 Sep 2026 11:01:09 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] liveupdate: kho: calculate per-node scratch sizes
 before allocation
To: Pratyush Yadav <pratyush@kernel.org>, George Guo <dongtai.guo@linux.dev>
Cc: rppt@kernel.org, pasha.tatashin@soleen.com, graf@amazon.com,
        changyuanl@google.com, akpm@linux-foundation.org,
        chenhuacai@kernel.org, liukexin@kylinos.cn, guodongtai@kylinos.cn,
        kexec@lists.infradead.org, linux-mm@kvack.org,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260904025101.9959-1-dongtai.guo@linux.dev>
 <616daf17-4598-4a30-8574-16480dfc23cb@linux.ibm.com>
 <0969ede4-f617-4e24-b32e-c5e30a96880e@linux.ibm.com>
 <2vxz1par7amw.fsf@kernel.org>
Content-Language: en-US
From: Sourabh Jain <sourabhjain@linux.ibm.com>
In-Reply-To: <2vxz1par7amw.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: AqJVR50ALucX-AiAxwJ3x_T1MyrYMlkJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDA3MSBTYWx0ZWRfX5z9Nn1aBIyH0
 Y6FU2W/PVzqspg4B8hJHIsMSQVEWYZOQOY1cIyH3awA9iuDMuX34zyzSIKNu7ktkkqMC+KIEC92
 EE3q6l4DhW01bHHzJbyZL+wEW2Of9yXrfO2I+wu/ovX5pGSPfsDf4vvU4XSG+FSi6F+JA6mEWOz
 gHlNZQBfbRpw0vGzqV7iLvW+3x372ZLQjm6quYxfXnKEJ/L9U8q1PlxTYvF8nRzdRwLjWb9cdGY
 OBemnmF3uY9N/SYRRzGWQkbGvf75osjzocP3LDl6ZXh4GmlorhhunOTysAoFW/y8GFZatIrGaf0
 bGzS/Ty2kUJmqwMUeMdvd6BJjEP6JLMR0PQTWkYjG3WogMfWz6u5RYEalY2w/Rg/VyzcLls9WQF
 H5j3rHXNBu+4dObdijJCpfG/Sa3dATZczzcCU5N044iZh0RCavrkG934/5Vej3c8RvyL+/acDgr
 Uu96yC7qEjTuEpZ4Wqw==
X-Authority-Analysis: v=2.4 cv=O/KsLx9W c=1 sm=1 tr=0 ts=6ab0c123 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=WwVblQKFIFXS0NQbftcA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDA3MSBTYWx0ZWRfXwgZgXeLr8xU9
 FGKrxm4isb7FUHpouifOb6aBebTDrotgL9KWspbHCjq8ESbWuA9UgTuIPu3mbs6r85DhN0KIpjm
 jfTlQ6i+L1DVknYoUSUkLWaA3umbN1w=
X-Proofpoint-GUID: k_yw72S4r9Ehjcyfejr_IGUKpcpQljxG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_02,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 phishscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609210071
X-Rspam-User: 
X-Rspamd-Queue-Id: D939A100006
X-Stat-Signature: wqzemnju8ozskxharsdw9531885pzozp
X-Rspamd-Server: rspam01
X-HE-Tag: 1789968679-997418
X-HE-Meta: U2FsdGVkX19mzmc3HAkHlLkwEt4I3eOQknMdfHWArEh0hmCGJH4Q9JArJQBEOgYY4irxvHjdk53i2uEHIFX6xt92m3kby9qgkJAVsAIb/g6NKMhOdJNbJhysbk1jHkNAYqRJR4GzmdilMCJCJ840i9vzF95pJOfnKtVRXbQsdfu2qMgn/U1wj7bcme4c0HhBfycZHRzSLktwuA6N/sYJCR4+xi73qpsRTm7NH7vyuF5KfhbAldme0ByyIb6/6GpmVaxSG0d8A8LCT/VTBeA2B12RwPggs9X/iexQlFLkVYpIB2st5aVBcPbG8LS2OX28EW4RXleToNGZ12N6jw1jgvpHhivHF20WXbzITnYOKB2Cpotwq/xRJbUvyTUlU1l22oryrNvakV5NjrgFh+/zOgS5UQBFKuri87a0p5HrqU4Pbxl2qKxEPNt2GZDnPtKFDfWHz/4BByPNHBpbmSitIjI9QhFJQhVVQJaVXUL3fzIg5C/fX4MvxYqyd2r4MgV8b5thqNBEDpmF9mduCUMQv6W24tcApzmThuN/pMNCeC7wbuYLb2q2mWJdSlXbHLr6lrb0OHMcYo+WQyMn6iMyXuHgbQBGk2WQbhhgFtrzjiJPWI30uFMLuHwSDPL4gPrzBDgLZTWNzRyh47FebzKKHf9vx7M2JInUaBwQ2xjRCYS3f+CaaAfuGaGcZQEkzAIkRNZ16gnFMNv2CXeydT/Xp+X98H2Oen2bz9QQxk4G504Sg2sfJrFQGLZDVt8gMPeVWA81i9ZhCM9/QZmWN5BXcdVD3q9uohQ13IBwj6pTqIPBycZ03kaFlkkMsSNh41p+mBLh3bWiK6PBnzcbIzeh1jlhIRxLkEtr/Z18A28DC8s+Dnjme2acIeac54JrmPO7rfObavY4JYeNw6txqF834ziX4+EmTqgr9PstozVuwGAenUa41oL7ENMTvGUSj76NH+Z1qwKaK4R5ZbKjXo9
 F19gPzBq
 LAX46UXh/2sqbSknL1Oxhk0ixTzvm2zMPuw0e6o+OOsB9lHY33tQt+06VC23B+4jjiXLJhzR8BVxev7wWpAl+AjJhGxHryP4hj3IqtLUQW7Kq1BJvTjLRyoojOB6lhqj1jxJ/u2FRjxfCbGkUqJG+nLnmrwvbGxbBMy4H0VZoP0C3NTJKBNSjlQvltisG19/1pmZ6OscJ2dLgpVvEc84bZ8OIFM+hnoR/U0SQ6EiRBQSun1CaN6BQRlSuqLFy2wRNeZT9DNYt7TGAxovTmFuswAML9uIhlqjGoWEOhwIxoPRsGnaRygW5ohkO9R+PPc0Jc3ne
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/09/26 04:23, Pratyush Yadav wrote:
> On Thu, Sep 17 2026, Sourabh Jain wrote:
>
>> Hello George,
>>
>> On 12/09/26 12:03, Sourabh Jain wrote:
>>> Hello George,
>>>
>>> On 04/09/26 08:21, George Guo wrote:
>>>> From: George Guo <guodongtai@kylinos.cn>
>>>>
>>>> The default percentage-based policy sizes scratch areas from the current
>>>> kernel's MEMBLOCK_RSRV_KERN footprint. This is a reasonable heuristic for
>>>> predicting the early memory demand of the next kernel.
>>>>
>>>> scratch_size_update() calculates the lowmem and global sizes before either
>>>> area is allocated. However, kho_reserve_scratch() calculates each per-node
>>>> size only after allocating the lowmem and global areas. Since memblock
>>>> allocations are marked MEMBLOCK_RSRV_KERN, the per-node calculation
>>>> includes those newly allocated scratch areas and scales them again.
>>> I may be missing something here, but doesn't memblock_reserved_kern_size()
>>> check the node ID of the region before checking the region flag
>>> (MEMBLOCK_RSRV_KERN)?
>>>
>>> Code snippet from memblock_reserved_kern_size()
>>> ```
>>> if (nid == memblock_get_region_node(r) || !numa_valid_node(nid))
>>>      if (r->flags & MEMBLOCK_RSRV_KERN)
>>>          total += size;
>>> ```
>>>
>>> For a valid nid, my understanding is that the global and lowmem scratch
>>> areas should not be counted because they are allocated with NUMA_NO_NODE
>>> (-1). So, ideally, these regions should be excluded when calculating the
>>> reserved memory for a specific node ID.
>>>
>>> Based on this, I am not sure that marking the lowmem and global areas as
>>> MEMBLOCK_RSRV_KERN is what causes the per-node size calculation to be
>>> inflated. I am looking into the code further to better understand the
>>> actual cause of the issue that this patch is trying to address.
[...]
>> I added some prints in kho_reserve_scratch() and found that the per-node size
>> calculation is not impacted by the lowmem and global scratch memory allocations.
>>
>> KHO: Before low and global scratch allocations
>> KHO: low size = 899 KB
>> KHO: global size = 137 MB
>> KHO: Per node 2 = 80 MB
>>
>> KHO: After low and global scratch allocations
>> KHO: low size = 312195 KB
>> KHO: global size = 441 MB
>> KHO: Per node 2 = 80 MB
>>
>> KHO: After per node allocation
>> KHO: low size = 394115 KB
>> KHO: global size = 521 MB
>> KHO: Per node 2 = 240 MB
>>
>> I only had one NUMA node (nid=2), and the per-NUMA
>> allocation before and after the lowmem and global scratch
>> memory allocations remained the same at 80 MB.
>>
>> The experiment was done on the PowerPC architecture.
>>
>> I am wondering how the per-NUMA allocation in your setup is
>> getting inflated due to the lowmem and global scratch memory
>> reservations.
> I had the same question, so I asked AI. Here's what it says:
>
> --- 8< ---
>
> The bug was reported and tested using the KHO self-test runner
> (tools/testing/selftests/kho/vmtest.sh), which builds a test kernel
> using make olddefconfig with only a minimal set of CONFIG_* options.
> Crucially, CONFIG_NUMA is not enabled.
>
> When CONFIG_NUMA is disabled:
>
>      #ifndef CONFIG_NUMA
>      static inline void memblock_set_region_node(struct memblock_region *r, int nid)
>      {
>      }
>      
>      static inline int memblock_get_region_node(const struct memblock_region *r)
>      {
>          return 0;
>      }
>      #endif
>
>
> struct memblock_region does not even contain an nid member.
>
> memblock_set_region_node() is a no-op (the NUMA_NO_NODE argument is
> simply discarded), and memblock_get_region_node() is hardcoded to always
> return 0.
>
> There is only one node (nid = 0), so for_each_node_state(nid, N_MEMORY)
> loops once for nid = 0.
>
> Both memblock_phys_alloc_range() and memblock_phys_alloc() mark their
> allocations with MEMBLOCK_RSRV_KERN. Therefore, when
> scratch_size_node(0) runs after allocating the lowmem scratch buffer,
> memblock_get_region_node(r) returns 0 for that lowmem scratch buffer,
> and r->flags & MEMBLOCK_RSRV_KERN is true. As a result,
> scratch_size_node(0) counts the lowmem scratch area as part of Node 0's
> kernel footprint and scales it by scratch_scale (200%) again.

Yes, CONFIG_NUMA is the reason I didn't observe this in my setup.
With CONFIG_NUMA disabled, I can see the per-node allocation getting
inflated due to the low and global allocations.

This raises the question: do we really need per-node allocation when
CONFIG_NUMA is disabled?

For example, if a VM boots with 4G RAM, the low, global, and per-node
allocations are all the same. With KHO enabled, the kernel would then
allocate 6 times the total memblock reserved memory: twice for each of
the three components (low, global, and per-node).


> --- >8 ---
>
> I didn't look closer, but it does seem to make sense.
>
> But in practice, this problem is only on CONFIG_NUMA=n and I don't think
> in practice KHO or LUO is being used in non-NUMA systems. So while I
> think it is worth fixing, I think we should also have a test where we
> enable CONFIG_NUMA.
>
> Your system probably has CONFIG_NUMA=y and that's why you aren't able to
> reproduce this bug.
>
> I think on NUMA systems the problem is the other way round. The
> calculation for the global scratch also counts per-node allocations.
>
> So I think the proper fix for scratch sizing is what this patch does and
> then a fixup for the global scratch calculation as well.
Agree.

- Sourabh Jain

