Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 703ECFF60F4
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 18:34:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D68D66B008C; Tue, 31 Mar 2026 14:34:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D19486B009E; Tue, 31 Mar 2026 14:34:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2F8F6B009F; Tue, 31 Mar 2026 14:34:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B27E96B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:34:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5411756500
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:34:48 +0000 (UTC)
X-FDA: 84607209456.28.5542EF6
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1890C14000F
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:34:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=XZVOQ50P;
	spf=pass (imf09.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774982086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kSGP0/s81dLgGLLBMYCM/i6fiwnt5b3rSO7xri9j6e8=;
	b=Mz23JZ1fbad3SGuPHp0idtDPVuPLFEE+dgxuODNEMDOCs5GSdTprce287UlaXUUyeF4rjl
	8NzsAU5zfeoipgTVRBKEo4I9QR5gfiUnBMKTOt1NikA/V1f0RKTwMWMfjhcmEYB37nZTfF
	kcLBT+eZjBg62p9Z8Wml0Cb+HqofKg8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=XZVOQ50P;
	spf=pass (imf09.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774982086; a=rsa-sha256;
	cv=none;
	b=cxSZg6vdNeeVXc77RVXKDgwUVQAp7RAV+CFhaBMr7VcYjSqRvXxwXdUSsRhja8ND9UvHmY
	H6oYFANAHx4g7gTDfnatzwoi5e5tVUiGSi0KDoeUz1l4vDoSACqvzQL2MRozQFpOwHmrXq
	Krx9A9Omr8Eg6NL1r66F/cGtKFAqIwg=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62V8hUK5216795;
	Tue, 31 Mar 2026 18:34:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=kSGP0/
	s81dLgGLLBMYCM/i6fiwnt5b3rSO7xri9j6e8=; b=XZVOQ50P6Me39hDV//3Dtt
	hosvD3usIrmmMJlMa9zxKm9z0lSD0DqM/W0lu4EWyXfAqXCrzZvCs3k31j+vzJJJ
	x5qyz4hC52wOemv1zWpsYEqxYSYPVz6KiWXto6xIyPep0sZ94x3iGO9rUQVDfe9V
	sDS4B0vDy29fgfLY1n4AgHdKC7whmMZpDqFYjIr4XommvUkSpuceyrN3ishzlDnm
	9sy7GuQbCiODXEQ1aJG7ko/sRL/mGAi4QuXohcLEd15rcKo24cBDp0rl7mUsULiI
	pb8VYfUNNOuukIFYZvwDFy/31fAiO2zHDZuzLAG29D06Mrd/xFjxskcNssAzVcdw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d66ms48xd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 31 Mar 2026 18:34:34 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62VGOBDw030952;
	Tue, 31 Mar 2026 18:34:34 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4d6uhjt807-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 31 Mar 2026 18:34:34 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62VIYXm866912764
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 31 Mar 2026 18:34:33 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4710658050;
	Tue, 31 Mar 2026 18:34:33 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D47A058045;
	Tue, 31 Mar 2026 18:34:28 +0000 (GMT)
Received: from [9.39.16.245] (unknown [9.39.16.245])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 31 Mar 2026 18:34:28 +0000 (GMT)
Message-ID: <81857888-b6aa-4f04-bfd7-e9365d62669d@linux.ibm.com>
Date: Wed, 1 Apr 2026 00:04:26 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/sparse: fix preinited section_mem_map clobbering on
 failure path
To: Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Frank van der Linden <fvdl@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, muchun.song@linux.dev
References: <20260331113724.2080833-1-songmuchun@bytedance.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20260331113724.2080833-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=J6enLQnS c=1 sm=1 tr=0 ts=69cc13bb cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=968KyxNXAAAA:8
 a=B2iOVZ4RgrPQK8wAUSEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzMxMDE3NiBTYWx0ZWRfX3IPT0D0Vpfvj
 r59Fgdk5Xh7zi+wu3KO4TsG9Uzo/Me4UlliWVQuyeNK2GzP7HYKgC8ut89bu3cCxv8WMtw9n3tr
 7691sWDWd/HO6Z4PGdb9j1KPloHbxbj27I/vmjFfahFBRkETOdYqZSZFIZDj+Jv+h9x9ugaSArQ
 GIMzzik39Zn+LWawvJd8FADztjvrszj7Ne2iUPDGu+ueaI4qxyH27WWcWWjUkiu+U/IfLVrZzN/
 f7uLTgPqBuzwzkdhygT4lj8rgc6nXs/+PA9Aev+CgvqUhQZ/PLL19n8B+jo65JnU6D5vxVa2F61
 WQ7cnXmsym9rSAk6r9EZLLSbA4kWm6cdaRl89FW9HQaIaXKI2KdTLxp4A1pZfCc/XAcR8kP+Kls
 BrT1qM0zfYh2Yng9ubJAyBUgkIT4sWUBr8e/8sfhFJeXtixYXjA7R22e0k5U5N0HFq8jwPgVrAi
 ubJgZJuLoWUgHLxq6EQ==
X-Proofpoint-GUID: ceGfuKj6JtU_viIudgnsZLLel_znQlh6
X-Proofpoint-ORIG-GUID: fnvtgq5ZdlXM3Kgq-hrrYo-gCMT4N89R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-31_04,2026-03-31_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1011 adultscore=0 priorityscore=1501 bulkscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603310176
X-Rspamd-Queue-Id: 1890C14000F
X-Stat-Signature: 9i5p84gsup31oisb7ou7c9d8yia9g6ei
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774982085-945297
X-HE-Meta: U2FsdGVkX1+eY/RwRiRo553qP5BjsynaMONcSFzSUWbtktD1OvV7CnS/kMmO50zgLxtgoxxxvNMYAteKptJXohoo6ZBNLjqaaVZTFRJwhqTV3Ug8H8EEazPMIMSz3vEM51wBGHLb7MurqljMY9r87ogauXbnlkeaifAvBPvIjHedY3Kw0z33q3wL9/aoZ74PzTayZbVA7vdnWi2QmBmLshcbFhd/BMcvszbldBzkuTXigS0Q68PDKvM3EI04OwycrEsplOn1J8xa6gpJT4kmD6VoFPBI1nGWa20SI9qd+AySpoBEO3lAL4OFzD8BRCWDtoDjTotGTGLlOV3r52rn5p4wvcCxtNaHTbFd/feAt85OEV77/NetWIy1oBxHE5Ral+r6959FjNyL3GGHilYkgfw3IfeTvGfSjkPJ6RT0S5dOWH91X15ZgXu0NrzQRMnxpsYuZbjlr3ONu6j40Rjwn7oLgNPxlX3zpAlQ05ye2PElaLjtFa9nfKBTHlkWAYJ60tR0WgysYR+347jaEPy+Q7KMscY8/2oeUNPC7cLt7UT8M3Y59sSD9y0yV3X3jI/uYgGXMcgrfMCzztQ8RV1wDZBDyNMvh7GAWGRkXXWJjhXhPrk8CEnqmqlEZ7z5x1GWlN7f2iOuhmMrqsp3C88rxaenh50wP2miCqz4sFjhzK8aNknLiiTXMb6FYLLJqY4J4rG88bC9OfLokUHuKtjgKoou87LLCzgVE1iW5c194cDKbjAHRdQ5u6C6ird6f5bYW6vchrACa+e3iKATvbVaXF7D5FY/Orl4pCvsiEJcfe5iM2LFMA1ytG4YAokt7QiORP3ls/DwC84QrdBLXwDqSYR5T/y1G44vjam4ErQPwTebVN+4sQChP+X/asVam1/HDjN/lJJKJMTKHBeZ1VuwkHPPA7MUqqmqoawUPjrbE4UT9s6VKj729dSEpXP2Dul2jMsIzXED9j06Fv4Kyv6
 WqCwMjME
 t2XI1c6S9M2qbq6KOj5/gwbHavN10lE9e97L6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Muchun

On 3/31/26 5:07 PM, Muchun Song wrote:
> sparse_init_nid() is careful to leave alone every section whose vmemmap
> has already been set up by sparse_vmemmap_init_nid_early(); it only
> clears section_mem_map for the rest:
>
>          if (!preinited_vmemmap_section(ms))
>                  ms->section_mem_map = 0;
>
> A leftover line after that conditional block
>
>          ms->section_mem_map = 0;
>
> was supposed to be deleted but was missed in the failure path, causing the
> field to be overwritten for all sections when memory allocation fails,
> effectively destroying the pre-initialization check.
>
> Drop the stray assignment so that preinited sections retain their
> already valid state.
>
> Fixes: d65917c42373 ("mm/sparse: allow for alternate vmemmap section init at boot")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   mm/sparse.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/mm/sparse.c b/mm/sparse.c
> index c2eb36bfb86d..3a14b733bf71 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -584,7 +584,6 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
>   		ms = __nr_to_section(pnum);
>   		if (!preinited_vmemmap_section(ms))
>   			ms->section_mem_map = 0;
> -		ms->section_mem_map = 0;


This looks correct to me.

I have a couple of questions:

1. As I understand, section_mem_map initially stores the nid
    during early boot, and later it stores a pointer to an
    array of struct page. In sparse_init_nid(), the struct page
    array is stored in section_mem_map via
    sparse_init_early_section(). If
    __populate_section_memmap() fails, we are  clearing the nid
    stored in section_mem_map right?

2. Another question: if sparse_init_nid() fails for some
    sections, there is no retry mechanism to add them again,
    correct?

3. when ms->section_mem_map is set to 0
    for a pre-initialized section, does it only affect the
    pre-initialization check, or could it lead to other issues?


- Donet

>   	}
>   }
>   

