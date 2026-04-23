Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A76F8F99362
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 10:51:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17ED56B0005; Thu, 23 Apr 2026 06:51:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 155FA6B008A; Thu, 23 Apr 2026 06:51:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06C8D6B008C; Thu, 23 Apr 2026 06:51:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E89B46B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 06:51:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 93883403E0
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:51:32 +0000 (UTC)
X-FDA: 84689504424.06.B515260
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf05.hostedemail.com (Postfix) with ESMTP id 38923100006
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:51:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ac7JLZub;
	spf=pass (imf05.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776941490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XsmtxtZFdx4nlYYBj8GUQHCxAi452XGQFD1uTC6aPXM=;
	b=OpVCgZKlLHFDtVc+BDLS0Lar1IiIP8epTysvW/L/XZfDdENZXFLWgZSleS8Esh3pWo7AhT
	UllgCCqC6sqdDL06a2vH5SZFoBhcz355idHsbPd/A/Udv9kFFkiylqbn69d6xp4TvtIEbU
	dN6MJwgCYsnnQEfYLp7umW+qwk2hXl4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776941490; a=rsa-sha256;
	cv=none;
	b=eptq6spA0HnXhqWfHp1x35NjwzNjR6257CFlxD2UaSQxzpVloWf+zYNpAHf/nySKdlXQXL
	xLP/JT0UDsQHoi+Ro54miNtfelzV4oS28kZiaUTJTevCw4qCn/TVIyZsHPn6wIaKMP7YaJ
	dO3VGsfKuo3cKkmzZqdS3V2lqTDLm5c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ac7JLZub;
	spf=pass (imf05.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63N6kvgM3514986;
	Thu, 23 Apr 2026 10:51:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=XsmtxtZFdx4nlYYBj8GUQHCxAi452X
	GQFD1uTC6aPXM=; b=ac7JLZubFc7HudFhppE3umKLDUeEVRq+u5j8N3/SfUhs/X
	arfSYwTX4K15MDoQqdo+6rZnaeiBUxUAOW1Zqe6WMEMJLvMT3VIywZ2Fc8Omkdi4
	pTj+wiIYAnkKLFDFCtUngPmn+LxwsVBSfeD5bqc/N/5MoNd/lVhCLQCs/V/0/Q0v
	eGQRT1WyEgUmnSNItuniK9XnOS1EKQjXgGnYLMAlnIlA8d3HARBInC+NbFaTPtij
	Nk39olGaVTI1F1J6gHPCAD96YvKe6YdwIPxxzejinmvl/+pqHTvDnZrishygMkuZ
	FUGT/PVitQYvsoBzUb5SI+Y7JHT6dL9tyzJ6r7LQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dpeu28810-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Apr 2026 10:51:25 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63NAZVTp023346;
	Thu, 23 Apr 2026 10:51:25 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dpjkxx8sw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Apr 2026 10:51:24 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63NApLkp51184026
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Apr 2026 10:51:21 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 872DE20040;
	Thu, 23 Apr 2026 10:51:21 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 567892004B;
	Thu, 23 Apr 2026 10:51:21 +0000 (GMT)
Received: from osiris (unknown [9.52.214.206])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 23 Apr 2026 10:51:21 +0000 (GMT)
Date: Thu, 23 Apr 2026 12:51:18 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/6] s390/mm: Complete ptep_get() conversion
Message-ID: <20260423105118.10371C15-hca@linux.ibm.com>
References: <cover.1776264097.git.agordeev@linux.ibm.com>
 <7ad766612a3095c8c8d9a253ef0f484ef98196a5.1776264097.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ad766612a3095c8c8d9a253ef0f484ef98196a5.1776264097.git.agordeev@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIzMDEwNyBTYWx0ZWRfX5S+wMN54K7jB
 VFAHWoUzCfcvHKec+E6tZ3plfnkS7C7o8+GjkD8wGtefXHTuT67ooXkYnLjnybkBhRRbLXH1Hns
 rgV9GmTRfEBCPrkRrV7PgmRdQ+ncYDJpCRh+d9RZZLiGeftZmTa40cU3PxnBr8EX39rORZnbUUN
 8kM9Tec+5IdkwBynjhgA+YLcbrNmTA73o3oL2Z1OH12WzCrJAZU3VFEL/mLdmSwUqI95D+IX9a+
 VkRgZThFQzz0HdBkL+eSvdUZ74qjq+iDc6dKSbFNKYtJpqmuUCRTg1vAJIHwoW3GkWo8kjVVAyQ
 RlPKp1D9mNc0q11ddqXSccSjFvT4LcL8dEZOfzOiu5Y/LCgkgUWFjICwcJO8hoCssVfD/AXA8AO
 1WEortow8GF6DtXbT5H7BkRV+QvBqyVl2iKRDuUoB4UfyX9WYgTA265r8qguNCo4zqk8LjoeDm0
 gUkc/kx7U7Ag8a66R5g==
X-Proofpoint-ORIG-GUID: Tm9jtMLTXeV_oUVbtFqu986bLquLPsUy
X-Proofpoint-GUID: Tm9jtMLTXeV_oUVbtFqu986bLquLPsUy
X-Authority-Analysis: v=2.4 cv=XMUAjwhE c=1 sm=1 tr=0 ts=69e9f9ae cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=6BLRMVARryNAVYdsrhYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-23_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 priorityscore=1501 impostorscore=0 bulkscore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604230107
X-Stat-Signature: bkw8746a67ygb3fm94ijje8ejyou88xy
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 38923100006
X-Rspam-User: 
X-HE-Tag: 1776941490-518718
X-HE-Meta: U2FsdGVkX18DVv1pqdX59USlKM56MY8C446UtRQIuz+acxQ3dXaYCERDjlsbOPQ7CWIlda/gzTK7tcl85Q+wQFpkrv0/P7ocOrUX/j3ZP0RofuPye3pgPUh5oErZh1xJYVmQDi0NU1kVRrFEmUNiWcuw5asWXsZb3jyjr7bMQoIQwinnDSNOD0l+c1ZrRTxUGmqd7tBzqHGAlE34K0OZnCGP8ZOp8qAzbaVqzuhd0hKr245rfMl4ov+jOKVkk1iORBN1ub1wqpBHFVNL01XPSZpKGcLLUAqFKCQ0iUScERknuTuaSbPtJarGDOzT3lGx5eEMfz52bsPtBY4/KJijX3Jhbn/NuL96jCO41enpI1VHbu+0SBkklNqrEOYywWPswoIKq8dxE1Po5NV0V+QrmslKKquzu/SeEPqY1Ule4CpCUIfYfUJqqpjhv8GeN6ybEKYQzNPzVDJMBgUJoY5DJbJAyeHAz1gvU7tsqZ6lFyNOXLQKTVNcup85WKLx1R3aX4NGU5z+LCvHo9tvz5CmCDT1St+mQstWoRNBsgbknWj3SFuTRXwpMc2BUAuXmTCKb18jKgzj5G3RB9mI5RiAMb5rNnOIM4TEEmVoPc1f+4sDTKvW5DRqtZ08rYpzAQiN5gi09BnxNgSS4aOTWI5U8b2skKLdiCbvPDO4AfybIAn2QiGo5tN3qP7or+tkKrt4+AjIPNafibsWqiFwzXDqjZnZxcs05dXvZNBz8UuetrBFqde7B4G/y1VfSeBVPWRAPHka6yf4aVdF8hES7rgcwkRnTz9+8oYQlMgVB2zC+Uz5f+6hflZwH3kYdg7ADcJ9CIa4TCcFqC51C0V2L+mWUSKPPdp26DpOvbxPkLFu/3p5LlFjJ5KLZFStozyC2rcEBtkDwNaEqrJtaYBTeYbk/92cXE0EET+0OBnvG94fmlIJp10AsS9o1H5tv2AodmxE2s32ldSVmn+GzNrNN4u
 njQq4xlF
 w5OMBl4ziST3R4N3YcmS4GX+3VqfJx+X3XJZSSEC70Nk93ev5bTThCdcQvOxoT9fQnviD1dv+g1De6MOx5EHzGoypBA7ukYWZJRv6GEVozpca/Y2KOPvKhtqi4JEiE45kSDpuUXjejJIgEuI1bi2OaQzVfEQu9bb7jh7xccfr4BqwydqHbqDxh9D7DvYCkh8YX8gxmvSKv0A66JCg9BLpJ9iS/TyXVYnivtInmzgePjg2ZWEa3aJ89fUVthLejrzeMG8MDF7l48QsAAMQTxdWUSFLyM+kJIiegAlPZKG/T1WT1xRPO6VCfDtV5FnDS8jaPpO6erVhEPphao/MfwtIXvXtmqf8n/Qo8PFSmB/vMx/kOkrbUozWy5Cgt4rVqv3UDBjV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 05:01:21PM +0200, Alexander Gordeev wrote:
> Finalize commit c33c794828f2 ("mm: ptep_get() conversion") and
> replace direct page table entry dereferencing with the proper
> accessors (ptep_get(), pmdp_get(), etc.).
> 
> Override the default getter implementations even though they are
> currently identical: pud_clear(), p4d_clear(), and pgd_clear()
> require corresponding architecture-specific getters, but these
> are not yet defined. This avoids a dependency loop.
> 
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> ---
>  arch/s390/boot/vmem.c           | 32 +++++++------
>  arch/s390/include/asm/hugetlb.h |  2 +-
>  arch/s390/include/asm/pgtable.h | 60 ++++++++++++++++++------
>  arch/s390/mm/hugetlbpage.c      | 12 ++---
>  arch/s390/mm/pageattr.c         | 42 +++++++++--------
>  arch/s390/mm/vmem.c             | 82 ++++++++++++++++++---------------
>  6 files changed, 138 insertions(+), 92 deletions(-)

Was this a manual conversion, or did you use some tooling?

I'm wondering since I can spot not converted locations, e.g. one in
__kernel_map_pages().

Besides that:
Acked-by: Heiko Carstens <hca@linux.ibm.com>

