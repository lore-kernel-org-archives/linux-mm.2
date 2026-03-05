Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1F52EEF30A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 06:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05E916B0089; Thu,  5 Mar 2026 01:54:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00C326B008C; Thu,  5 Mar 2026 01:54:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E234F6B0092; Thu,  5 Mar 2026 01:54:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CCB8C6B0089
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 01:54:23 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 76A581608AE
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:54:23 +0000 (UTC)
X-FDA: 84511095606.14.EBC2EA6
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0AC871C0014
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:54:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Lb8mSwG0;
	spf=pass (imf18.hostedemail.com: domain of venkat88@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=venkat88@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772693661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IqkJ2SnGytr5NhIc5m1uD9NLdn1cuaxB3p1uelmS6og=;
	b=fj+HTyOVopkRINSSOlHc30XWEL0/GaWuOJOhEwXDDVAPg9JyTLk4XnMd/l5u7dkzhSrDLG
	Yv6zcyrKrXYmvp1WqvGAFiFedhvCbLNWzy8bH2SI4nc/23fUb444yNFT8dyK9qmgz1tmb5
	ouKV3KPlTPJrQO0H/YDiDSkuF+DNWaM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Lb8mSwG0;
	spf=pass (imf18.hostedemail.com: domain of venkat88@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=venkat88@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772693661; a=rsa-sha256;
	cv=none;
	b=MxLUBz+RoEYpS4SACofux6fV0BjkiDNiCs+55fId2+KBjMzMtigh6O3wLe8PaO0uFgwary
	MzcNi6yuWn+jVCAEjnp/pUlbEZ5e57LwXt1AEkfd+bGsIsf0bbUSsjFrZoVaJT5MyOeaNV
	hnKkem1GQSKDs4nFPRDyMueP5zeXV5o=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6254XZ632072521;
	Thu, 5 Mar 2026 06:54:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=IqkJ2S
	nGytr5NhIc5m1uD9NLdn1cuaxB3p1uelmS6og=; b=Lb8mSwG0hv/tOw4e4N0X15
	t91VEISBErkjRnHriB0P9LSLmAxsaKrlVHW2Gs08AFEjPWNYm7een830K+D1ZC0P
	/1pT2C9zyPoTXonRw7QHSxMJsGphdEA9oWhMn0AoV4uwythI9Em5Tuip/glSxrfc
	RquTeEHQkZhaVoMylvKd/d9/VWG6PDg3pKOGgY/Z8BZWM8psodRtfk8Cztx/fSKE
	xAn+FcorZgYdtZ5So7JEksJYGhf6fjp/4nACcc8B5TUdHAeD/BZG/CMyZFFnsFvO
	2C4gBxkXbNh4bt9IxG2sD/TcbXpAN+tTtzXe19zM7BVUf5Io8b1c7L/fQBiLJv7A
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ckskc21h9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Mar 2026 06:54:15 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6256m368008796;
	Thu, 5 Mar 2026 06:54:15 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cmdd1hpke-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Mar 2026 06:54:15 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6256sERl44171634
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 5 Mar 2026 06:54:14 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F09415805D;
	Thu,  5 Mar 2026 06:54:13 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 81D5458060;
	Thu,  5 Mar 2026 06:54:09 +0000 (GMT)
Received: from [9.61.242.165] (unknown [9.61.242.165])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  5 Mar 2026 06:54:09 +0000 (GMT)
Message-ID: <41f1c856-2c41-4d11-96e6-079d95d8efbb@linux.ibm.com>
Date: Thu, 5 Mar 2026 12:24:08 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: change stride type from unsigned short to
 unsigned int
Content-Language: en-GB
To: Harry Yoo <harry.yoo@oracle.com>, vbabka@suse.cz,
        akpm@linux-foundation.org
Cc: cgroups@vger.kernel.org, cl@gentwo.org, hannes@cmpxchg.org,
        hao.li@linux.dev, linux-mm@kvack.org, mhocko@kernel.org,
        muchun.song@linux.dev, rientjes@google.com, roman.gushchin@linux.dev,
        shakeel.butt@linux.dev, surenb@google.com, pfalcato@suse.de
References: <20260303135722.2680521-1-harry.yoo@oracle.com>
From: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
In-Reply-To: <20260303135722.2680521-1-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: HFkeM0vPrecV2G65vZG5gISihM6chEbD
X-Authority-Analysis: v=2.4 cv=b66/I9Gx c=1 sm=1 tr=0 ts=69a92898 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=yPCof4ZbAAAA:8 a=ZXp7wYQzh5jS1JEQpmwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA1MDA1MCBTYWx0ZWRfX+Z2K5HmLzXaC
 F02tV8z29yBlj5PhSJE5KfpeOnNmlb7i382qXDKASr1rjExM7TymMQtS3qjgrvS6HVIhXP81Eqw
 5B+UqgBIkHqGf9OMkiImul/ibT/LxQS9g72Nvaeks+ASDGFU9HVxqDXFDEZZ12QA6L7KwyNyKDw
 ks2hdxYNhl3OT4YdaZAVzLxZWQryUr8FAe5u1z7mnQues1H0r+omsFymy8iwy+m/M4KlZlf+7kS
 ATh4+cK58Le6Qmb77BInOt7sV8MvPpqvWlXHjv+rNsrI+I4MFqPJkc2DNbLGIJTM/DAoZNJj202
 lyZDja4znVtsk69Iudp5YnIxwpI2BgaoCUhKlpiZ0073s/FpWThJR7C+5l6evlJ8b7wPZShLPAh
 LVqd5LMjZQ0XO5PPqgAWXSG2AjLMcW/AxKV49anckXUOTit00TzjKFg5M7lbswWaVvY9RoUFCeQ
 lwZzMTbOQbjRFi2eo/Q==
X-Proofpoint-GUID: 62c-SeErd2EMGGc8_z-jTovrtdJ-cWjz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-05_01,2026-03-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 clxscore=1011 adultscore=0
 bulkscore=0 impostorscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603050050
X-Rspamd-Queue-Id: 0AC871C0014
X-Stat-Signature: 4ywfeo5d3sxejsm48x8sy486nbrh8pk1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772693660-167209
X-HE-Meta: U2FsdGVkX1+N6ebe3e2EbBzK/LVLRfAc95ktOwP0/Zw6WsBDpWEyQPQRh6CiECKrvYw6AB98gCxl1WCoH88F0OS3WZdIMAV93RzNIGQVM8EOaMaQfRwCe3B3tf8sxAJVbbUaKXSr5AYS1Xm9KwrBbnRV8o++G5w5nJgg2adp9ewmbfBx1R/eVfaeWoFzO9iPzIL8hnO0AfSh7Zz0rUwpi0cczZ1X/NeF0c3BXGrowaEr60laYMrleD1Aao2ktCiINnXJ9vOqA/88LIeNjQfRzT57osqITe9ZK0CHunZGNXOOtazZMPZpz6tQ8iISt9TpbYIAvdUMWoStTKEB8aDMPw0FvTMYr6SN9KY48+FsNRiXQOG2AwPU+X98GgAan48dIPco83AzUYTlF/JiikTR1egvpaPRpv6OKyX8PrsRVNC/qCkOaKT8pT30ETX338EhVIcAPJ7A5uuh7a20vPfo1bX4Zp2o0GgBcIrXBmEc3K2JXIuyosK6EXLdjV5X4I4KgHVAzokVtBsta+BoDA9G0Pp8EyrHkYC4x2f1zjCSJLeqVD3PUnVQDynXanFw1X1yd+HuEGVvkwRkRAym4hcefQIe2YWn3WKwf3wPqjUqUHAR5PLtDcWTm5mAA+OvDIR5pllE79Qe3uGjJLW6BYU2RWx4H4ijG15E7CM0Xv78E+vxcwFbKt59ZBan/AG2mT1F2gNANXDZcwvEBor5iKREYPCeZMLt7KO29vHRKuN00e0YLks2pyD2eLWePXWRGeXY0MikCtSFJQWfGG5whWF+uTX5Cy8tHZe9aVe8qeDmw1AndinWzSJi23lpVMvjzeyq7eRQLJHNoujzD4ANkxNdLMggZDf1p5T41yjqqE7l11bHIZUCsd7juBVXU+5jbc56HVIURWxv85eNGCR3nNKX438ZaHpJ2/d9wfE9wQIC3JdZBsWopkdrtZ9Akv2b1BrYbMqrGoOTK+y0kzXOJxk
 vWcdS/DG
 MkUwclf1cgSy/IFG0HQTz60GtxrbEPFXxYf5VczcDsTkp65kqVKbKmp+YpYRM6IQWluaugwxXBdtvuG0MGj+O7YqQHltzCOg1J91rWf9X85jnGizFhAaoTMz7W8V0debvuLeEHSmYStddIimEPJunTFrY/ujmbQIypMnqqdBc4rpJgGVVNjgiB8wjmkcIgNDVM1EeddD8+tVa11//1YMKntAx/ieqxFJvFyC0oEPRHtdF/VP9mX+s/4cOl4cyD0H3T0Snuf+TtpedFL99eBHvsD/e7AMNBh3hTSB7mnalU2Hj0Xvg5ipEyDvWGsxgYFbnyTfW5iYAugI5VeTu/zpdUpO6hFvCE4yPoyvyTTdTJHIQEW1/6ezuBr8g6cSYzisaQKg5HTNnqcE/0VM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 03/03/26 7:27 pm, Harry Yoo wrote:
> Commit 7a8e71bc619d ("mm/slab: use stride to access slabobj_ext")
> defined the type of slab->stride as unsigned short, because the author
> initially planned to store stride within the lower 16 bits of the
> page_type field, but later stored it in unused bits in the counters
> field instead.
>
> However, the idea of having only 2-byte stride turned out to be a
> serious mistake. On systems with 64k pages, order-1 pages are 128k,
> which is larger than USHRT_MAX. It triggers a debug warning because
> s->size is 128k while stride, truncated to 2 bytes, becomes zero:
>
>    ------------[ cut here ]------------
>    Warning! stride (0) != s->size (131072)
>    WARNING: mm/slub.c:2231 at alloc_slab_obj_exts_early.constprop.0+0x524/0x534, CPU#6: systemd-sysctl/307
>    Modules linked in:
>    CPU: 6 UID: 0 PID: 307 Comm: systemd-sysctl Not tainted 7.0.0-rc1+ #6 PREEMPTLAZY
>    Hardware name: IBM,9009-22A POWER9 (architected) 0x4e0202 0xf000005 of:IBM,FW950.E0 (VL950_179) hv:phyp pSeries
>    NIP:  c0000000008a9ac0 LR: c0000000008a9abc CTR: 0000000000000000
>    REGS: c0000000141f7390 TRAP: 0700   Not tainted  (7.0.0-rc1+)
>    MSR:  8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 28004400  XER: 00000005
>    CFAR: c000000000279318 IRQMASK: 0
>    GPR00: c0000000008a9abc c0000000141f7630 c00000000252a300 c00000001427b200
>    GPR04: 0000000000000004 0000000000000000 c000000000278fd0 0000000000000000
>    GPR08: fffffffffffe0000 0000000000000000 0000000000000000 0000000022004400
>    GPR12: c000000000f644b0 c000000017ff8f00 0000000000000000 0000000000000000
>    GPR16: 0000000000000000 c0000000141f7aa0 0000000000000000 c0000000141f7a88
>    GPR20: 0000000000000000 0000000000400cc0 ffffffffffffffff c00000001427b180
>    GPR24: 0000000000000004 00000000000c0cc0 c000000004e89a20 c00000005de90011
>    GPR28: 0000000000010010 c00000005df00000 c000000006017f80 c00c000000177a00
>    NIP [c0000000008a9ac0] alloc_slab_obj_exts_early.constprop.0+0x524/0x534
>    LR [c0000000008a9abc] alloc_slab_obj_exts_early.constprop.0+0x520/0x534
>    Call Trace:
>    [c0000000141f7630] [c0000000008a9abc] alloc_slab_obj_exts_early.constprop.0+0x520/0x534 (unreliable)
>    [c0000000141f76c0] [c0000000008aafbc] allocate_slab+0x154/0x94c
>    [c0000000141f7760] [c0000000008b41c0] refill_objects+0x124/0x16c
>    [c0000000141f77c0] [c0000000008b4be0] __pcs_replace_empty_main+0x2b0/0x444
>    [c0000000141f7810] [c0000000008b9600] __kvmalloc_node_noprof+0x840/0x914
>    [c0000000141f7900] [c000000000a3dd40] seq_read_iter+0x60c/0xb00
>    [c0000000141f7a10] [c000000000b36b24] proc_reg_read_iter+0x154/0x1fc
>    [c0000000141f7a50] [c0000000009cee7c] vfs_read+0x39c/0x4e4
>    [c0000000141f7b30] [c0000000009d0214] ksys_read+0x9c/0x180
>    [c0000000141f7b90] [c00000000003a8d0] system_call_exception+0x1e0/0x4b0
>    [c0000000141f7e50] [c00000000000d05c] system_call_vectored_common+0x15c/0x2ec
>
> This leads to slab_obj_ext() returning the first slabobj_ext or all
> objects and confuses the reference counting of object cgroups [1] and
> memory (un)charging for memory cgroups [2].
>
> Fortunately, the counters field has 32 unused bits instead of 16
> on 64-bit CPUs, which is wide enough to hold any value of s->size.
> Change the type to unsigned int.
>
> Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> Closes: https://lore.kernel.org/lkml/ca241daa-e7e7-4604-a48d-de91ec9184a5@linux.ibm.com [1]
> Closes: https://lore.kernel.org/all/ddff7c7d-c0c3-4780-808f-9a83268bbf0c@linux.ibm.com [2]
> Fixes: 7a8e71bc619d ("mm/slab: use stride to access slabobj_ext")
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>
> Hi Venkat, could you please test this on top of 7.0-rc2 (instead of
> 7.0-rc1) and see if the bugs [1] [2] are reproduced on your machine?


Hello Harry,

Apologizes for delayed response, I was out sick.

I have tested this patch on top of 7.0-rc2, and confirm, this patch 
fixes both the reported issue.


Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>


Regards,

Venkat.


>
> I reproduced a debug warning on a ppc machine and fixed it.
> The bugs are expected to be resolved by this fix.
>
> p.s. After more debugging, I saw stride appeared as 0 even on the CPU
> that wrote it, which likely rules out a memory ordering issue...
> and I discovered this while decoding ppc assembly suspecting memory
> corruption or a compiler bug, which came down to:
>    
>      "Hmm... why is the size truncated to 2 bytes?... OH WAIT!"
>
>   mm/slab.h | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/mm/slab.h b/mm/slab.h
> index f6ef862b60ef..e9ab292acd22 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -59,7 +59,7 @@ struct freelist_counters {
>   					 * to save memory. In case ->stride field is not available,
>   					 * such optimizations are disabled.
>   					 */
> -					unsigned short stride;
> +					unsigned int stride;
>   #endif
>   				};
>   			};
> @@ -559,20 +559,20 @@ static inline void put_slab_obj_exts(unsigned long obj_exts)
>   }
>   
>   #ifdef CONFIG_64BIT
> -static inline void slab_set_stride(struct slab *slab, unsigned short stride)
> +static inline void slab_set_stride(struct slab *slab, unsigned int stride)
>   {
>   	slab->stride = stride;
>   }
> -static inline unsigned short slab_get_stride(struct slab *slab)
> +static inline unsigned int slab_get_stride(struct slab *slab)
>   {
>   	return slab->stride;
>   }
>   #else
> -static inline void slab_set_stride(struct slab *slab, unsigned short stride)
> +static inline void slab_set_stride(struct slab *slab, unsigned int stride)
>   {
>   	VM_WARN_ON_ONCE(stride != sizeof(struct slabobj_ext));
>   }
> -static inline unsigned short slab_get_stride(struct slab *slab)
> +static inline unsigned int slab_get_stride(struct slab *slab)
>   {
>   	return sizeof(struct slabobj_ext);
>   }

