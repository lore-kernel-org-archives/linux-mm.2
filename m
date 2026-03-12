Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3657106ACEF
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 22:46:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBD676B00CE; Thu, 12 Mar 2026 18:46:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E74696B00CF; Thu, 12 Mar 2026 18:46:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8DD46B00D0; Thu, 12 Mar 2026 18:46:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C51F56B00CE
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 18:46:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6FAF61C44E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 22:46:40 +0000 (UTC)
X-FDA: 84538896960.14.E8861CC
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf30.hostedemail.com (Postfix) with ESMTP id 170AD80009
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 22:46:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=d5n+sU79;
	spf=pass (imf30.hostedemail.com: domain of gor@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=gor@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773355598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D8zOmmY8eeeaXFLebTpNVG/LsQlaEOKJAHWnrIeNJVA=;
	b=jfdBparFZZIR8A1xEUKXExUxdNUxr3kmmvgX0hMpakq//oypwTKDtWmAMBqvK/KHibngcg
	l8r4D6t/Pqxlr1eUsEXAUz4YWSW3Kx/fwMk5Hy2F+Jaf+BdNYAFnBmDVJzmwrb6FKpGDXW
	q4SM+RlqfQIuxiYhethiNVyDDjZVv0U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=d5n+sU79;
	spf=pass (imf30.hostedemail.com: domain of gor@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=gor@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773355598; a=rsa-sha256;
	cv=none;
	b=LKNLK9HRCi0MruulQ/vqFqF1cNusk23gfz7aRF3Xgsb1fCfN9kRfr5fDpImJixa/S/MC7g
	cRTdRql1znx3SSXhQlC2W427/vX6Eawqi7ziUkHajLbwbKnjcW6AnUt3uhA8k/Sr0n1kRs
	KSUF4zMpjF2UwGajTd4QR/5JE87VrUs=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62CDgn1g2259751;
	Thu, 12 Mar 2026 22:46:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=D8zOmmY8eeeaXFLebTpNVG/LsQlaEO
	KJAHWnrIeNJVA=; b=d5n+sU79eoOn9F5TNsG+WjiggtWrEcbsRVXkeBYiV5vWYm
	ivMwqxRtuuKxHBJLTmN0R/EqcQKgePNMaxtoFO/195J0uARNgOoPFezHGAkG79Gb
	tnIL4WjD+hjdGThr2+ba0V1/7vl0opoBJ8EpxzsOcustk/WNZ9IiGR5jekM04X2M
	X3SY1v3FwdqCrjDcUcaePqQc6Uy9a6NrXfEvRVJp3bjvg5L4B6paFgbVwJSrz05M
	wFsopL+3T8BfZuZN/7q/6aPP6SOL9qSDoFDPzWQDVaNcRJ/y/UFkdI4+tt9KHvUd
	Fw9mNp3mxrlnWGv8acyW3h8aS65PyJpXirrQulfA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh92d53m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 22:46:29 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62CITFZx025686;
	Thu, 12 Mar 2026 22:46:28 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cuha8capw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 22:46:28 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62CMkPHL16449894
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 22:46:25 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0B0192004F;
	Thu, 12 Mar 2026 22:46:25 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 279A32004E;
	Thu, 12 Mar 2026 22:46:24 +0000 (GMT)
Received: from localhost (unknown [9.111.83.60])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 12 Mar 2026 22:46:24 +0000 (GMT)
Date: Thu, 12 Mar 2026 23:46:22 +0100
From: Vasily Gorbik <gor@linux.ibm.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, x86@kernel.org
Subject: Re: mm/pgtable: Support for page table check on s390
Message-ID: <ttbt5xa@ub.hpns>
References: <cover.1772812343.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1772812343.git.agordeev@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XSb0EpCLqP-VvERd6yxhMyLpIuUmwWro
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDE4MSBTYWx0ZWRfX1dmLEh8veiIG
 JPH+TX+SKowHwqfzMq52we/QWAIDL+ZWYZX2jNbNGdZowW55EvpX8g/DRRACVzpVxsDhn+zENCd
 kt+vKYAw/S0oFGmt301uYKsD8hvRqZ8fzz7zhkSDwM+JaLyyhRiAgeGOnJ3hPl8tMmJ3cimrUTc
 QxD42P4vOhD0rEmJgmsyoBM6UnZ2cuDggfUF1CvtrrM+0LTZMLXqib5gODqi8G5g5/v7TOrtO19
 BcefUJ3xyGScJjhjkOzB/bUvD0msMt3gV9bVz0N7NvXQvpjkMyIFQG1IzgLmoPzrwhMTNoxMVFn
 Y0+8Amm8ExMPHkvoKIs8uraV6X8nzMyL0sT+rQUB8TJBgiVffvSrLfCwlAF1YfotN+3Js3OLFLS
 gs6mYwnnXZwsfG731r2xvnOUuIsc631T935DNRics0rmn4wCRiCXWx3KSKEofuyW7vZfthOAG16
 0tM/zg+0I6iru1bvr5w==
X-Proofpoint-GUID: XSb0EpCLqP-VvERd6yxhMyLpIuUmwWro
X-Authority-Analysis: v=2.4 cv=XNk9iAhE c=1 sm=1 tr=0 ts=69b34245 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=euGEXw6tGDjZIu8w7pwA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-12_03,2026-03-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603120181
X-Rspamd-Queue-Id: 170AD80009
X-Stat-Signature: r4uucetrwyru4bczo9tqiinby5hncig4
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773355597-543767
X-HE-Meta: U2FsdGVkX19lG3J4ECXn7frLz7f7Kuk74dOYZAU5btp+LIJ8WeqD+FV6nWmOoGc4buWmZUh9PwM8xRaM2O8oA5cAB8fSX1UZowEC1VWzohdWq4IWHj1Y3Phnz2v4voaU2v4rMV27F+P1x4E1baHtWGG/M0Wi6PxGZ425CHskHAZXU7/HwVBNz3TxdRQhwZqpI59J4+nYag+gTcnJIhtZnrOsemvJ/Ry31pvvlC39hjHOkoJVlFyfzJdcZWYZmPodMMcvk1DuDhPPdF16B4sjgDhpomMJ1aaS6iuY1hOShzVkVnGIHLtRh6CFv5zKaZ6rZScCDFovKLDxKmCV9q5Tuif7ANx8tD4J2xDt6r3gAfolOjrX/THJcJVnZX6Wwq1YjyFVGGjc/IH4zh+O/0sWz3o0eLOCzFF94qEb1dXekZAzIfsqZLAeRkS40GibvbDnrV9vBpqrGcrXAS7RJEQ/0rAr3K3Kw2T23zJIk4F8F6i/6miW/2+iOHOJAY2Nd4c9IQ0Y5SzGPD4TPzaAagFDLNbbvIEfE6q6ii060ZaDjtjHbkU259J+pmGClwqkyQ/q+D31prVnF6kfQ0YUCJ9m3ZwFZ4CFBWFnye1lkgiwIyOYILwQiD46wd6PrPTZ6fvSYypptdUGis0s+LXTv4Ob2lBIwwfqNNb/BWnaLpNs5S4emsRc55Q6TF4XThTFyoddcr+CQ0ORL+/xlBAuVk6J1qAsrbqDkJeaoPoLsEnc4ERuBjezC7Wg+B41EeNTi7VoTXt3cXf+znZ2TPVemSGuG0A1YFGNvhFOyoTLCkBNlmgbtObKLbfU/gLqCHpRY7cRZb7rg5JBSDlbH5fi+ZDVyUREYbDBhdt74/wMGcZ5syYgTqiD7SozXHni0XXz1yxAnelKk9/H4SIxF6UktBj0TFoGC0rq+rOiDE6kBvbCjmK7H4D21C5ZmZ1hLI0WEXBpP0rtsPV4O0/3DN3x2gr
 hKv5my1o
 omGXMSKnqESh9wB/lciSlXmCdr758285Miip2iaTmSSNQ3/ZUdx60ZcSD4HuH06yRYmOZwHkzQSjWCtH5wrA8P89GRyOoGSYoFSFjP4H1gtYw1ieJId5AKOOCDnsUrurqXaapdh2c5mJg6pHFwAWRl45BeZ7bonvkEgzyr4Jsjn77fxDR4TSaD4r79EDBUC4BGkzMqUUHovtkFq/kaJ2+T53yz9q3Gk2HODOf7xMjEBuhbLGHTdyfl0FFeFiIqhoeHZWuETaQmz1ilgL8xf3sNWqlh9fKOqo8PMVYGii3L6tHa9k8h6WrkA2VFJQ/pLF1Dk/j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 05:16:29PM +0100, Alexander Gordeev wrote:
> Hi All,
> 
> In v7.0-rc1 page table check support for PPC was added, which
> conflicted with this series v1. Thus the only change in v2 is
> PPC headers update, which still is NOP for non-s390.
> 
> I only did compile test for PPC.
> 
> Thanks!
> 
> Alexander Gordeev (2):
>   s390/pgtable: Use set_pmd_bit() to invalidate PMD entry
>   s390: Enable page table check for debug_defconfig
> 
> Tobias Huschle (2):
>   mm/page_table_check: Pass mm_struct to pxx_user_accessible_page()
>   s390/pgtable: Add s390 support for page table check
> 
>  arch/arm64/include/asm/pgtable.h             |  6 +-
>  arch/powerpc/include/asm/book3s/32/pgtable.h |  2 +-
>  arch/powerpc/include/asm/book3s/64/pgtable.h | 10 ++--
>  arch/powerpc/include/asm/nohash/pgtable.h    |  2 +-
>  arch/powerpc/include/asm/pgtable.h           |  4 +-
>  arch/riscv/include/asm/pgtable.h             |  6 +-
>  arch/s390/Kconfig                            |  1 +
>  arch/s390/configs/debug_defconfig            |  2 +
>  arch/s390/include/asm/pgtable.h              | 60 +++++++++++++++++---
>  arch/x86/include/asm/pgtable.h               |  6 +-
>  mm/page_table_check.c                        | 15 ++---
>  11 files changed, 80 insertions(+), 34 deletions(-)

Applied to the s390 tree, thank you!

