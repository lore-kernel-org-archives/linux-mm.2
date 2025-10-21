Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4899CCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 08:48:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC23A8E0016; Tue, 21 Oct 2025 04:48:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C996F8E0002; Tue, 21 Oct 2025 04:48:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B88578E0016; Tue, 21 Oct 2025 04:48:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A464B8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 04:48:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3E593480CC
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:48:31 +0000 (UTC)
X-FDA: 84021495222.02.85AFAFC
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf10.hostedemail.com (Postfix) with ESMTP id F1B73C0003
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:48:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=sMUMWAXX;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf10.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761036509; a=rsa-sha256;
	cv=none;
	b=cqW5i7NrUMYWva/Kt5msPbO/eN9ohJltknZx/XmlMzOa9UTVStJCxuJuqQ0d9kb1kOqlCb
	BgWaJN3pEpj0zIgJgtcPZMyqH/8ivwlB2gtWlCRWurgp73O170uHAhrWjgDUexc/tGExiv
	kHK1EnJ1NY7o6ahF/xCfkVEO+OL28K0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=sMUMWAXX;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf10.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761036509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z7oyuGf+YmrdjdAlCdljzaOoBcmjt3nedZ0w+/dyCrI=;
	b=J2m4NN1GRHKYZCtyTyFwDscHY5NtWSQw3ueKprZQHGcVWC+k0pFjCUK5Un6CPRKMJ04zqo
	2v9yK3OpC1v5xKxmfBkguHwT0pMcmJks0xWKYfClwdcn0xLDNBVexdiZZa91MKlvqnVoiV
	0m7dGhvPwZ7Uqohd5j0kkCsja/pcJ5o=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59L5lgc1020450;
	Tue, 21 Oct 2025 08:48:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=z7oyuGf+YmrdjdAlCdljzaOoBcmjt3
	nedZ0w+/dyCrI=; b=sMUMWAXX/8sY8Do1huxbrboQr5eFVQnwPlBEki6stGqniW
	ldYu1HZKhMzVPDElU1aXezrbtB4lgLP8ckyaP/GumTFfxl2oZrCEBQQqbhm4UcN3
	LFaGusmctrYMbp18Tvh8JsC0xmCrJ3TfUinBLPP2/NsjVyMa+mFTZWpsC+CfwlMs
	w3YcPLvERjs41TDcxL8HAEhvLtHRZQFTHZCklpYDCImAxYdisewiSNb+G3gA8cOZ
	iaJresCsFCo7vBE5SNattGsJ0uX6iv7hgIYsiDjUeIsjMRQ7LRuiVVzXMd3jLuoH
	Z+0jFkX+m/p6lcWSKuc2N99ZxVl1E9s7o5IZ1p9A==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v31c4sc8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 08:48:25 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59L6CiX8014658;
	Tue, 21 Oct 2025 08:48:24 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 49vn7s22hc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 08:48:24 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59L8mMtt16974242
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 08:48:22 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 653A120043;
	Tue, 21 Oct 2025 08:48:22 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E5C9720040;
	Tue, 21 Oct 2025 08:48:21 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.111.75.81])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 21 Oct 2025 08:48:21 +0000 (GMT)
Date: Tue, 21 Oct 2025 10:48:20 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
        linux-s390@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        virtualization@lists.linux.dev
Subject: Re: [PATCH] mm: Make INVALID_PHYS_ADDR a generic macro
Message-ID: <8ef6bea9-5905-4d15-be77-f58645d967d0-agordeev@linux.ibm.com>
References: <20251021025638.2420216-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021025638.2420216-1-anshuman.khandual@arm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SFsr08sj6VOHWyp68BfmatDwsVOqiBAF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfXybe+b5Oqvt21
 7nQzCRWt0Qdz0L6NetKOeEaFWC9/bRTheXys9Jo0yPruZzS8K1X5soLFYF64NcSmqjVmSyDC5k7
 ecAg26cW+S87fUIL3yYns3aen8OVIZD9HAosIUS/itSROuTxJahgvxsQ9eTLyCOX3V+9XbM18Ux
 srZPJXF0zBCi/JPzlDtS6TSEVgZ8QMfo9UBC3MMgfAsge8DoTecVq1HmUygmZIYfkQHQ1VBWHr4
 MkNT+sO9OhvDdmRk9hEKXAmmD0Z+/PVMR94eMBvCLLoe9Pedp+1Eh5J7uwYNuoGZ8FKyYreVc7L
 MISNLC2tSYEN2woAfEBhoNkzvNR0Cg5qmF16Lu+Rj2FPXRxwP241fYzx4PO6UF+Z7hfl1eOTFgk
 OALOr+UD8heOc/vPfeqdN+n37aFx9Q==
X-Proofpoint-GUID: SFsr08sj6VOHWyp68BfmatDwsVOqiBAF
X-Authority-Analysis: v=2.4 cv=SKNPlevH c=1 sm=1 tr=0 ts=68f748d9 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=37rDS-QxAAAA:8 a=JfrnYn6hAAAA:8 a=7CQSdrXTAAAA:8
 a=VnNF1IyMAAAA:8 a=mrUCOdJJ3iSU8PumKu0A:9 a=CjuIK1q_8ugA:10
 a=k1Nq6YrhK2t884LQW06G:22 a=1CNFftbPRP8L7MoqJWF3:22 a=a-qgeE7W1pNrGK8U0ZQC:22
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_07,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 suspectscore=0 clxscore=1011 priorityscore=1501
 spamscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F1B73C0003
X-Stat-Signature: 54sjbo4titxh68e6nwjqwjoghbpxshm5
X-HE-Tag: 1761036508-901080
X-HE-Meta: U2FsdGVkX19iCrFEwM4IX+BDC7Jrm+aVQ262DHSWhD0hugPyzlacOFJzfmcKKY/r/FxrAbnqrVztxJB2y8L4UKjFUUt4nQFZ2ujs9wfLkKOjTI3u3xS2HZ94T7AX5ZOYgC4DO/sLUCq0LFNrmkGcJSOWKfyMZfPoisbGWZ5/yZYhBaOMrsi13GnyEx4LDzoirDm54Oyg9bgTlefSHfSdY0g/x9j3Hl7in0sRIILS6DCbTFALGk9Vscfibo6Wf/Rq+LaErkSMsS/WPH7h1Myavb7GQngoH/hpl8W2M8N+Am6h/x1xvqo460csWYqt3g8WEEJiZkhmjqIkdVXtlELMwvEw9cZyoDKsYAhjvebGxbXAs6B++Jau2JfvSb7OQ2k37c7kyHgqVXUYbN7DZqoYaqIukWzCr0nHzfEMfApuTBgfbD6+jhdO0ZwUBKCyWEQNZl9/pZHLfly6DB72Prw4CQXMGs72GIxFpdDUhh8hrepnnT9BcZaqm0RSisxCALiSMhwqtRaKFqFJhfIpem5Mf+g0gViFTuA6MMoEqDQGcAWivZzRQyQv7xanlz9aItae9igp2fpaCaMhaaoa8mIK1g+dIK+pn3ESg8TBjd5f3iLnweWTMwiwsvXPFRJ2q92MMoN37ACa8yTJzXzdyqVJh9N+ezsQ9zC0//aCJWnXMwa3lR08qswWN1vrV1J49LTval3OO5EulaDp2TpOkGGdV81cehcag6wIR3sfqFGhM32tMssdNrm7C73YudALiMXs2IrPFLz6Q639qX1t19QUnzZ6zoMseg4fwdehZj1nKjMZZEcu9uTy/LBTSUx4U546xelzh7/yAhU/M9PTncm/EBbE6oy49el+90hjteEmp7joa3BohFN3Q7JbEBAuD/Olyd9cPbgA/KTEvraDSdqkOramkyGi1J7XDCFiv5xAouQ8I7ikl6OE684jTV4VKt96fF4+HQjzoXmfLpRVWyl
 gQuFL8jQ
 P3qnwOED9l6GRqlkCGcISc5gvOKCRtOV7wlCy4btz9aCujyiNdrhDsE92GvwQNrP5+KX6hI9p6IzD/2NJn7T0xTIvU28AIUf6qzlk9JqnnCRAIhugIF4rdjFiqBvkvFbcTDGlCbA0bEtDJnWVlLQpnk438S804mBY7j3zgwz45/y2rR6XRlkb1sfHx68uq+on0ZSMosbRh2jB8JNp+QpdyoPBeUmiLpu17GD4b3WAo/7cmXvsl4SsKvsuZdH/znC1OTyJiVJoi0cgTA+8tEQciDWx34Q5LfaLiIggu15SEJRXxCj1EtkEqJ+G3M3BF5mOBChlP8w/hAcawYkjVKgA85Hm+jmSvBOw1ziQoehzgS4QByt+HFcWgVKSWliI8B2wu20iXK80dqjb3tFMsseEg20w6yzp28pUBVIgl0LgyUVE1zbKczQWVt0GXTshzgMsA/9j3/PzvGIdKjQ67iFHI+z4+gcGXSYANAVMPo5ohWRRelwdlJE42U9KFclrlDZTClKaARhYkocJc2ub+49qmJnAzJCjQEw2BhDnRCWWITllhgctCLegx7+haO/puBNjV3Zq+XOrjNCiSKk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 03:56:38AM +0100, Anshuman Khandual wrote:
> INVALID_PHYS_ADDR has very similar definitions across the code base. Hence
> just move that inside header <liux/mm.h> for more generic usage. Also drop
> the now redundant ones which are no longer required.
> 
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: iommu@lists.linux.dev
> Cc: linux-s390@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: virtualization@lists.linux.dev
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  arch/arm64/mm/mmu.c                  | 2 --
>  arch/s390/boot/vmem.c                | 1 -
>  drivers/vdpa/vdpa_user/iova_domain.h | 2 --
>  include/linux/mm.h                   | 2 ++
>  kernel/dma/swiotlb.c                 | 2 --
>  5 files changed, 2 insertions(+), 7 deletions(-)
...
> diff --git a/arch/s390/boot/vmem.c b/arch/s390/boot/vmem.c
> index cea3de4dce8c..fbe64ffdfb96 100644
> --- a/arch/s390/boot/vmem.c
> +++ b/arch/s390/boot/vmem.c
> @@ -16,7 +16,6 @@
>  #include "decompressor.h"
>  #include "boot.h"
>  
> -#define INVALID_PHYS_ADDR (~(phys_addr_t)0)
>  struct ctlreg __bootdata_preserved(s390_invalid_asce);
>  
>  #ifdef CONFIG_PROC_FS

Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>	# s390

Thanks!

