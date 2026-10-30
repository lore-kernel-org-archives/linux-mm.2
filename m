Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35100606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 06:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=sSFuNCOW
Received: by kanga.kvack.org (Postfix)
	id 356546B00EF; Fri, 30 Oct 2026 02:43:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DFEE6B05B1; Fri, 30 Oct 2026 02:43:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 180EE6B05B2; Fri, 30 Oct 2026 02:43:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D33A06B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:43:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8CA52C05D2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:43:20 +0000 (UTC)
X-FDA: 85378350960.17.BAB6078
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf05.hostedemail.com (Postfix) with ESMTP id 25F40100008
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:43:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=sSFuNCOW;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf05.hostedemail.com: domain of pavrampu@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=pavrampu@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793342598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hIwzN1VD+MlgWfbSxJH1ZurLgAkXSRL2fnVECdsL6A0=;
	b=WY/mHvQpA9VpeuD1mJDoZ+CVubhcV0wn8n6FmnBEbWL0qGBmf67fPEFfkgXSs3QBZc0U3K
	a+kOf0/YvysR6Z7n0sQNR5rPd6whWgflhUptZunSH1cO08oggqt9v1d22FwJEEGnUm2aU0
	z5juLvHFtXqA8cI2lFQoQtMKkEuYUOU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=sSFuNCOW;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf05.hostedemail.com: domain of pavrampu@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=pavrampu@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793342598;
	b=vqXzDCQHgHHYHvPJpmU5j2bek2KJP2IidM2h/pItpIqSAc81UrZG2E+/K3iwmIUgfsSH38
	1BZNz88yD+dkL1iqw01kndoxubdQnHt2Wf3Ep2DGkCYImer5ahKnUQEig8UNrsmC3MYnL/
	WnEnkkB9qwRTpPjjTGKG7qWl8HRsOIM=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69U5ES8B2234483;
	Fri, 30 Oct 2026 06:42:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=hIwzN1
	VD+MlgWfbSxJH1ZurLgAkXSRL2fnVECdsL6A0=; b=sSFuNCOWlQzNQ7eAUWtllA
	pHK4RSokkSlkektuik/fRwtZtEx/b1KTGn8UQkn4sgyyBeMgri3lFgwzoA4Efdky
	YzqEqF1xkf+KrtkgkO5yTDC0pbcKaQl9iFXbDXgRQ3o4K88I/iRTaBly0UrVXdS7
	v74CsQZT3uge8+C7LIBNDxgutvzLbdhtvGBG1X1n1OzIxp/FYkFj23K/jkFIk5aH
	HgyBHoAHLAQKvsGOcH7kh6uUkXWAvbbzB0vqem6eph8UwFDr/UTNqRR8cgd5Ps3G
	dcgZ0fapyDmbFLgoDp/yi17NUvPVeK1s9lFcTufVaMZi4YZUoMtg9d9EgYX5iRNg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hmeay1etd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 30 Oct 2026 06:42:36 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69U5JtDD104250;
	Fri, 30 Oct 2026 06:42:35 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hm6pbbcb1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 30 Oct 2026 06:42:35 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69U6gX5r26280676
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Oct 2026 06:42:33 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 46A815805C;
	Fri, 30 Oct 2026 06:42:33 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B412258058;
	Fri, 30 Oct 2026 06:42:31 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 30 Oct 2026 06:42:31 +0000 (GMT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Fri, 30 Oct 2026 12:12:31 +0530
From: pavrampu <pavrampu@linux.ibm.com>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Ritesh Harjani <ritesh.list@gmail.com>,
        Madhavan Srinivasan
 <maddy@linux.ibm.com>,
        Mike Rapoport <rppt@kernel.org>, David Hildenbrand
 <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael
 Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <chleroy@kernel.org>,
        Venkat Rao Bagalkote
 <venkat88@linux.ibm.com>,
        Shrikanth Hegde <sshegde@linux.ibm.com>,
        "Aneesh
 Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Muchun Song
 <muchun.song@linux.dev>, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] powerpc/mm: fix uninitialized ZONE_DEVICE struct pages
 with PMDs
In-Reply-To: <20261029063601.1961415-1-songmuchun@bytedance.com>
References: <20261029063601.1961415-1-songmuchun@bytedance.com>
Message-ID: <0c6e6f2d4d1ba63d3a2dfe4f6a74f635@linux.ibm.com>
X-Sender: pavrampu@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDAyNCBTYWx0ZWRfX3TjynaPh/m1d
 C5d17a5ldBUW7S8axUgi1YPl2E7U6/Jr8kNreZM4j4MCI2vvOrD49R7rXZjXdVx5ADulbe/rCqQ
 EYlaX9alN5o2bau92Qk/06yStUlkhm298f6DVBs/uZtTjCGvtoK/hklqv/Y75eWCNfjBsMcy78M
 KMmMwU/RgJSeyKbdFC+qxEw6VY1MPtXWGfZ0AFsxsX/UXYFL7XhEilYYXecisoWj9VDdCAHOi4J
 Qh+C8FmSpmPpQElpCqRXlAdbRTJksKHn/QwOaUbTLiLkRYZ+2atP1R4DMsqVZfnbra0n005XeqM
 FavFvKSohweOr0WLO2edtgdArlz2/1o2lc7J3MZVVO4lbcqNTQ+MjPSTacufu9baMY8QX6MiS05
 ZkdCD4+zIVlYgqI2tKhilGDfqK88Q5LsorczItDBYmty974D4SnbpqfDlRMJ5RLVH6lHk514ZnE
 YDHj83hFTfXimxLi0Bg==
X-Authority-Analysis: v=2.4 cv=WJHqzXsR c=1 sm=1 tr=0 ts=6ae43c5c cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=968KyxNXAAAA:8 a=ip6gSEBRpE_VUvMp_JUA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: AV6LDUAcbGXRLzgtnqeYeg_spQeOoosM
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDAyNCBTYWx0ZWRfXzjy3pofCqvwS
 TA9emy/M+bszomQLhe+va6cJtXc2mdXkV3KD0R1+IsJ+/quDbrzIx+E0LXMO+P+uXioWel8PzfK
 Xa7+IMUaogtIFx8ziA12ihCBNOqyXZw=
X-Proofpoint-GUID: xTXGbjELI330Ar8hX1GZpOXE87DcdQr-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 spamscore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 impostorscore=0 malwarescore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610300024
X-Rspamd-Queue-Id: 25F40100008
X-Stat-Signature: dzojn1ndacf5k9gew7eyeb4bzinucsq1
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793342597-375085
X-HE-Meta: U2FsdGVkX1+30TjbAB9X+kPseCgCXg8Eb+MPxJ8/jZIHYgcKOljR017abbMF6aCv+4sKrOjICEuhTGGUMxu26mvr1EnxEbDiE5cksNOYELO/jFNV/6suhTxGggLoLua/EJBcrlyapB4c+U+YGcUnEPhLN2eRkhWuxUwJ4h7JkhthfkphWo7YCPQv3IvTTHLIiEZPuAHJBBSHB9xOEdp3Npck/LP5TCvOlFVgXfdb7ezNFSJqoJK/ug5rt+zChx4zqXtR3lYRqN+ik8WpprKB1aIcTrUOOu3uRaBEgS2bbf5ruZDhefuMIwiIu77rsUTWjyR2tk+w1oirWgbIavb6QkQfgBPXGSjKgJBZrNc4+NYdsA/JRvnDIea4DOiLtkuLUTZEeV/UrPiCM0QKwxSIzv7ezqPoeZmzsRqoov06KSOcRKYihytg/PnTNgy6RR+Sew2a9QllP5lm/o8yUB5n2lS2E8F6jRMJPF+YWbeevNRRTA5iGrE5cp7gYDuntTYkmZLCqUvwZALg2SnXk0bFct6r9yGZ7thHuS+But8QvSwEGAdCKkXbDo0RQr3D03otH4AqRidmxZW2/Vq/HcO0O4N8rRbs4V4s9FRxVP6plX5So9AH4D3vFksH5N/IX4z73Uke71gkSs6btU9QlpFN9UpaC5Gels1bai84JPkbgShMXwzKXuhcLAT1w9p0Z2oqFyYbjOuuGFFEU5ZH+c9UToOhTIrwE4CL2sadqGvI1DUkklMoTzJqCtHknmkx1BqUCOkDFapW1VNc3T7Ynj8CiMTuy/M6AmsDeuUA6g22TZqTRdB5gRiuA9gDeLpCKKMiTpoa1PCR5Cm45ew4Ej+wLIyyMCN/+00bhKEWd3neilf2Db/NDVFWhQhUNSK1iJR5O7+nPRrgDcAaDjDXnvcjhuGZkmxozWEkK4O9DCx+AEtm7BZAX32uCWFBO4JzAPN9bPudTAic3g/wCe965iT
 buUg7wVO
 05vtaL/Z9HSjFmP8HfoX0Uuojle+lsUiUAhMHEy5xastTApqpwH2A3UlEWoVEEWQ9U4SAr3o0ptczJDkcu7/5RVB5hmDMbqZHAvU4bSieWmCCSHmE4kWwklga4WqU2Kvea+xYqYZdg9/Wipxsy42oQ1RcesecyXzzkw5w4RTIZ93onjpEypIuNHYvxcm2FfTbItBDdf6xd2R80DlWdlL4wu8dkYJDhBE2qffkR8iZf9VzNPJj4PTL4OHR3FfzqFVrw//IlozaADVlNBnVtmJYsLG87HH83FuUPUoV4klfnKT6Hy//oEnDBwt0hUclKA6+65mgBawaRyOWxOfFNGz0BR6JkPTaxF5IGIuvdF7/vyoFjBvcxA2LSkc46ihyPH0xgotA7lrZy9GQ2BRgvgqQckvpwDDW3RoGJaXO7BayRgQumHxPo4qKhqjViA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-29 12:06, Muchun Song wrote:
> PowerPC radix vmemmap population can reuse an existing PMD mapping 
> while
> populating a device DAX range whose section is marked as HVO-enabled. 
> The
> reused mapping is an ordinary vmemmap mapping: the redundant tail 
> struct
> pages are not remapped to the shared tail page.
> 
> Leaving the section marked as HVO-enabled makes later ZONE_DEVICE
> initialization treat the range as optimized and initialize only the 
> struct
> pages that would be backed by a real HVO mapping. The remaining tail 
> struct
> pages can then be left uninitialized even though they are still used as
> metadata for the device DAX compound page.
> 
> This first triggers a zone mismatch warning in __init_single_page(), 
> then
> faults while initializing the pageblock flags:
> 
>   WARNING: mm/mm_init.c:600 at __init_single_page+0xd0/0xf4
>   Call Trace:
>     memmap_init_zone_device+0x164/0x430
>     memremap_pages+0x43c/0x93c
>     devm_memremap_pages+0x3c/0xa4
>     dev_dax_probe+0x264/0x3d0
>     dax_bus_probe+0x140/0x1c8
> 
>   BUG: Kernel NULL pointer dereference on read at 0x00001400
>     __set_pfnblock_flags_mask.constprop.0+0x34/0x160
>     memmap_init_zone_device+0x358/0x430
> 
> On kernels without these initialization-time diagnostics, the
> uninitialized metadata remains latent. When userspace later maps and
> accesses the affected device DAX range, the kernel operates on those 
> struct
> pages and panics at that point instead of during device initialization.
> 
> The Fixes target predates the section-based vmemmap optimization
> infrastructure, so older kernels do not have section state that can be
> marked non-HVO. Backports to such kernels need to handle the PMD-reuse 
> case
> in powerpc radix code directly, for example by initializing the tail 
> struct
> pages that core ZONE_DEVICE initialization would otherwise skip.
> 
> Mark the section as non-HVO when reusing an existing PMD mapping, so 
> the
> section's HVO state matches the actual vmemmap layout and all required
> struct pages are initialized.
> 
> Fixes: f2b79c0d7968 ("powerpc/book3s64/radix: add support for vmemmap
> optimization for radix")
> Cc: stable@vger.kernel.org
> Reported-by: Pavithra <pavrampu@linux.ibm.com>
> Closes:
> https://lore.kernel.org/r/97f85592bb78a273be8519e6897e7f9b9bd31469.1793070429.git.ritesh.list@gmail.com
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---
>  arch/powerpc/mm/book3s64/radix_pgtable.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c
> b/arch/powerpc/mm/book3s64/radix_pgtable.c
> index 44868b62b14e..4f75f10ed68f 100644
> --- a/arch/powerpc/mm/book3s64/radix_pgtable.c
> +++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
> @@ -1261,7 +1261,16 @@ int __meminit
> vmemmap_populate_compound_pages(unsigned long start_pfn,
>  			return -ENOMEM;
> 
>  		if (pmd_leaf(READ_ONCE(*pmd))) {
> -			/* existing huge mapping. Skip the range */
> +			unsigned long addr_pfn = page_to_pfn((struct page *)addr);
> +			struct mem_section *ms = __pfn_to_section(addr_pfn);
> +
> +			/*
> +			 * Existing PMD mappings can cover the edges of a valid
> +			 * HVO populate range. They are ordinary vmemmap mappings,
> +			 * so the current section must not be treated as HVO-backed
> +			 * when its struct pages are initialized later.
> +			 */
> +			section_set_compound_order(ms, 0);
>  			next = pmd_addr_end(addr, end);
>  			continue;
>  		}
> 
> base-commit: d865f2677c44cb2171b833d6775cf692756fa8be

Tested on IBM Power10 (ppc64le), kernel v7.3

Tested-by: Pavithra Prakash <pavrampu@linux.ibm.com>

