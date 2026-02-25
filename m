Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 510C4EFD210
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 09:14:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F9E96B00CE; Wed, 25 Feb 2026 04:14:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77D9D6B00CF; Wed, 25 Feb 2026 04:14:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 654FA6B00D1; Wed, 25 Feb 2026 04:14:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E6AA6B00CE
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 04:14:41 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E0EB81C2ED
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:14:40 +0000 (UTC)
X-FDA: 84482418720.19.C2D1A28
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6244E180003
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:14:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=DMeXPNVJ;
	spf=pass (imf06.hostedemail.com: domain of venkat88@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=venkat88@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772010878; a=rsa-sha256;
	cv=none;
	b=E9CPjTa/ONd9ekkhaS0rei1n26I5NDyZT/RLQwrIaLLJtN71zkm0372YhiY3BxVZrMoVUK
	Odut4uwUdB4Dm8h3FfkNgdiOJ0vlBvXVICw3dtRzEV8edLbolyNumZTtN+3yVTTQLmsmbr
	vZNMhZ+kiWby4uOEnOiSxhMDmiDrtd0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=DMeXPNVJ;
	spf=pass (imf06.hostedemail.com: domain of venkat88@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=venkat88@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772010878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qm3zRWf7FXHZ3PWwM1vuxpueRYbxSMDKvASENPHBNrg=;
	b=HiG37lIqaRUiSy9xgdFwr4KYtgrytJTJUaKlrk8FEeW4UiP7t2MzsMfgBPeqC0+OIJhjdn
	bYXpIryL0sWRItuGlYKTFgY8vNCRkpxEeXBkLSx4bpEIf6xJgV3Nq0I65BB4x2sjEb65Mq
	wEe1qWLV2aCQo/iwVexZsOTbwmuL3Os=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OJTZCS1879767;
	Wed, 25 Feb 2026 09:14:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Qm3zRW
	f7FXHZ3PWwM1vuxpueRYbxSMDKvASENPHBNrg=; b=DMeXPNVJbQt85WBJhThrMc
	xXR4BlN1U8BQQQFS19xvPOwukG8hSAlM1KPp0lYomMzSK+9LVccxXL04rSRdBeXO
	n9aN+0faZGtjK1tFeGO4VDMChA5QlD8Lz1Dp9wC8JNiUs1IYUxRWN5pbnryUkBEz
	MT7fDOB7dSdJYK+sdh7goW1rQBFvRfESoexd+ktUBM6OPqVflqODpk5czGMMl2Up
	qymznejnCNSHWFBp7qvNCtzMGXTUq+4N0Zjn6N9N9+hZId8RYhEIzXZKPqr8Upj2
	FtR9q9lhqF2K437644E4yGNSxE7nOFeIu87HARlhE4kwgGHF0FLFnBtAMEmuyILw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf34c6tgt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Feb 2026 09:14:33 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61P7hCxY001653;
	Wed, 25 Feb 2026 09:14:32 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cfr1n4nhc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Feb 2026 09:14:32 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61P9EVRS17433272
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 09:14:32 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DFA9558052;
	Wed, 25 Feb 2026 09:14:31 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B60758056;
	Wed, 25 Feb 2026 09:14:27 +0000 (GMT)
Received: from [9.109.248.127] (unknown [9.109.248.127])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 25 Feb 2026 09:14:27 +0000 (GMT)
Message-ID: <84492f08-04c2-485c-9a18-cdafd5a9c3e5@linux.ibm.com>
Date: Wed, 25 Feb 2026 14:44:24 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: initialize slab->stride early to avoid memory
 ordering issues
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter
 <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>,
        Suren Baghdasaryan <surenb@google.com>,
        Shakeel Butt
 <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        cgroups@vger.kernel.org, linux-mm@kvack.org
References: <20260223075809.19265-1-harry.yoo@oracle.com>
 <2d106583-4ec6-4da0-87ea-4ecad893b24f@linux.ibm.com>
 <aZ2Gwie5dpXotxWc@hyeyoo>
Content-Language: en-GB
From: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
In-Reply-To: <aZ2Gwie5dpXotxWc@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDA4OSBTYWx0ZWRfX+krDo4RDgKdb
 SB/fcBcdwgVQA90A2mfw8YUJ0UzXpYyZRP0U+UxiKpHy7yMftBmDU5HErkwadv/SgH7ESdwKN1G
 rTwVSgTGAzS+kW645Y4zv8hfwCMySVIRAuFbjO50YBjg3x8ixxkylm85cWfaJu5RibXQ5j0DFIE
 3VARzEk7tb5ocVPEMPLP/HcP5nhxK8O+WeL+O9EP1ZEXFHKZFKYhi1JMl8wUrHUep7JD9mjqVj3
 jJdHCSzqu6yKYrHUq31YFdj53ZM3ARhYjr0Anl58myJSCtcThIBk9kav/GONxJ04Ew3f71w3h6T
 AtE1ieiQyQAdV8G6ya+Z5rxGU9ba6eLZ0JKBcNok/cdsVIClCyzk5WHGBXv0X7D/GYdDvaMHcCA
 q5KYNFKqKKhgBPB4uRIge++9cKbXB422ijyWNN8CPS+RbnLCTJ1Al3YwJ1lfs2qNt0cIiZ4Urmi
 4fusAsELnfV4Amg4mhg==
X-Proofpoint-ORIG-GUID: S5laykw_LH9AfdhDpzLDtY82s3ZNgtqJ
X-Authority-Analysis: v=2.4 cv=F9lat6hN c=1 sm=1 tr=0 ts=699ebd79 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=yPCof4ZbAAAA:8 a=Uv5aZE12QK5TszxNbi4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: tqe1vJgN43gb2ZvQrZbTIl8i_YUBt-Oz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_03,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 bulkscore=0 adultscore=0 spamscore=0
 clxscore=1015 suspectscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602250089
X-Rspamd-Queue-Id: 6244E180003
X-Stat-Signature: rzj5kkzdg57n5wnsgjezchwbpwuu5iew
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772010878-337671
X-HE-Meta: U2FsdGVkX1/8CuZXT5Wvy98p1P+jp577oVzike0j8xhjopCfjbIBaCivu93i/RVr1HgjtYxQshkSja3EPvdIBcqOlM+L/VNWGK+cHQOTJxazFm2kgkITSihnI7LXN16bCBHEIrytro6ea+t3KIxkJFmluIBAyg2DHrO3+Bev9iKQQUkwqGUynQ/OokX50kzqiCajNgOsJNCtBHRj6B1isx0Ri9Wgv/f0aN35X7/OP/jgFocHxfzlz9vFPDXabxQIyUeiUhgiFpgNQL1jSXXsmpsa49wB9uzhe1ZY95HBQZ4n0Qp0NSSMahqmVs4QTmfGN79AQdVUPAdauRee/j0Z7vTdUjebzNLkdEvCaLLoFnoe7vM0jfvaBkX93zsAAbwR57HshnBvwKdE0Eb5E5oT5p6sqxATNbQ7oxiBCImYRzkvZOloQPyl/3cEAWzD25yXw9W0o6IB4gauQmx9Qfhc0X7ws+VEpcmxzKB4a1KqJoWJoE05BOxHkCkjj+R8DISCuJaLuALeUpRtSsy3Zzu3BbTN9bMK0i91tsCQZShpO32Oa44CTEGeBB1SOVxEjp3LOKiGwDemYoL7DLBiSzXKdSGbnTQ71cz+BnLrd8IqruMDyc0phrLhREe4FZyIohowc86qScfDsvtTyWCA9qr2eq5WsEwh4TBhJE8tM5JSiDM0QEFYuZATzlgu7HPnAPZ21TdU9moSLCsBmdccT2ILKhYIfMeMlr/evUQI5yDVKGE9KyWyDZWbVKCW1aoXvUIXrROFykKif9QSh9pbp29u9SUI1d9jq0wYmTFGCbVprb9i0OjZ51JB/jUYq11zJRreNxPCcXM1ocZq9a2qvIv5j3sOcRQxfL1pHZWxsHaxMzi44jO05TjQZA09KNkU1ONKAV5cvnevRGJ9sI8fNwakxs4Na5pmCHWCWCYoWppxI1Rm8i/VCv2BJz/cywWWUWPJR6ZED8/OftZ/HgLcQhy
 VTA3Yt2u
 bli6lGSkXW80EqLodKTlFjTrr4p6MVQMhctz/BiWnTGiegKYOo5t9uAgP8ACe5l6yOsXsBnMBQmiAyTReQaVn51C6ey80aCMjmanobkdhRQlqdhXlpXOCWV3ORLGyve+Guuc1/UJWNT8RoebsMxObL0T7LFoMWAC4sOwLIKWL8FjLkJzCl5emhjRyHEsIw5NRdGogQ06D2FD7E93vqsneit0z+MhtcJTJ3xCl2o7kcAG56GvhvQAOA9znD5IlIZ6Fx6fvFN0aMvoKX+5DUW3dlApiZcF7OBNFbYGDoyd5Pdt1I6w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 24/02/26 4:40 pm, Harry Yoo wrote:
> On Tue, Feb 24, 2026 at 02:34:41PM +0530, Venkat Rao Bagalkote wrote:
>> On 23/02/26 1:28 pm, Harry Yoo wrote:
>>> When alloc_slab_obj_exts() is called later in time (instead of at slab
>>> allocation & initialization step), slab->stride and slab->obj_exts are
>>> set when the slab is already accessible by multiple CPUs.
>>>
>>> The current implementation does not enforce memory ordering between
>>> slab->stride and slab->obj_exts. However, for correctness, slab->stride
>>> must be visible before slab->obj_exts, otherwise concurrent readers
>>> may observe slab->obj_exts as non-zero while stride is still stale,
>>> leading to incorrect reference counting of object cgroups.
>>>
>>> There has been a bug report [1] that showed symptoms of incorrect
>>> reference counting of object cgroups, which could be triggered by
>>> this memory ordering issue.
>>>
>>> Fix this by unconditionally initializing slab->stride in
>>> alloc_slab_obj_exts_early(), before the need_slab_obj_exts() check.
>>> In case of SLAB_OBJ_EXT_IN_OBJ, it is overridden in the same function.
>>>
>>> This ensures stride is set before the slab becomes visible to
>>> other CPUs via the per-node partial slab list (protected by spinlock
>>> with acquire/release semantics), preventing them from observing
>>> inconsistent stride value.
>>>
>>> Thanks to Shakeel Butt for pointing out this issue [2].
>>>
>>> Fixes: 7a8e71bc619d ("mm/slab: use stride to access slabobj_ext")
>>> Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
>>> Closes: https://lore.kernel.org/lkml/ca241daa-e7e7-4604-a48d-de91ec9184a5@linux.ibm.com
>>> Link: https://lore.kernel.org/linux-mm/aZu9G9mVIVzSm6Ft@hyeyoo
>>> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
>>> ---
>>>
>>> I tested this patch, but I could not confirm that this actually fixes
>>> the issue reported by [1]. It would be nice if Venkat could help
>>> confirm; but perhaps it's challenging to reliably reproduce...
>>
>> Thanks for the patch. I did ran the complete test suite, and unfortunately
>> issue is reproducing.
> Oops, thanks for confirming that it's still reproduced!
> That's really helpful.
>
> Perhaps I should start considering cases where it's not a memory
> ordering issue, but let's check one more thing before moving on.
> could you please test if it still reproduces with the following patch?
>
> If it's still reproducible, it should not be due to the memory ordering
> issue between obj_exts and stride.
>
> ---8<---
> From: Harry Yoo <harry.yoo@oracle.com>
> Date: Mon, 23 Feb 2026 16:58:09 +0900
> Subject: mm/slab: enforce slab->stride -> slab->obj_exts ordering
>
> I tried to avoid unnecessary memory barriers for efficiency,
> but the original bug is still reproducible.
>
> Probably I missed a case where an object is allocated on a CPU
> and then freed on a different CPU without involving spinlock.
>
> I'm not sure if I did not cover edge cases or if it's caused by
> something other than memory ordering issue.
>
> Anyway, let's find out by introducing heavy memory barriers!
>
> Always ensure that updates to stride is visible before obj_exts.
>
> ---
>   mm/slab.h |  1 +
>   mm/slub.c | 10 +++++++---
>   2 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/mm/slab.h b/mm/slab.h
> index 71c7261bf822..aacdd9f4e509 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -565,6 +565,7 @@ static inline void slab_set_stride(struct slab *slab, unsigned short stride)
>   }
>   static inline unsigned short slab_get_stride(struct slab *slab)
>   {
> +	smp_rmb();
>   	return slab->stride;
>   }
>   #else
> diff --git a/mm/slub.c b/mm/slub.c
> index 862642c165ed..c7c8b660a994 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2196,7 +2196,6 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>   retry:
>   	old_exts = READ_ONCE(slab->obj_exts);
>   	handle_failed_objexts_alloc(old_exts, vec, objects);
> -	slab_set_stride(slab, sizeof(struct slabobj_ext));
>
>   	if (new_slab) {
>   		/*
> @@ -2272,6 +2271,10 @@ static void alloc_slab_obj_exts_early(struct kmem_cache *s, struct slab *slab)
>   	void *addr;
>   	unsigned long obj_exts;
>
> +	slab_set_stride(slab, sizeof(struct slabobj_ext));
> +	/* pairs with smp_rmb() in slab_get_stride() */
> +	smp_wmb();
> +
>   	if (!need_slab_obj_exts(s))
>   		return;
>
> @@ -2288,7 +2291,6 @@ static void alloc_slab_obj_exts_early(struct kmem_cache *s, struct slab *slab)
>   		obj_exts |= MEMCG_DATA_OBJEXTS;
>   #endif
>   		slab->obj_exts = obj_exts;
> -		slab_set_stride(slab, sizeof(struct slabobj_ext));
>   	} else if (s->flags & SLAB_OBJ_EXT_IN_OBJ) {
>   		unsigned int offset = obj_exts_offset_in_object(s);
>
> @@ -2305,8 +2307,10 @@ static void alloc_slab_obj_exts_early(struct kmem_cache *s, struct slab *slab)
>   #ifdef CONFIG_MEMCG
>   		obj_exts |= MEMCG_DATA_OBJEXTS;
>   #endif
> -		slab->obj_exts = obj_exts;
>   		slab_set_stride(slab, s->size);
> +		/* pairs with smp_rmb() in slab_get_stride() */
> +		smp_wmb();
> +		slab->obj_exts = obj_exts;
>   	}
>   }
>
> --
> 2.43.0
>

With this patch, issue is not reproduced. So looks good.


Regards,

Venkat.


