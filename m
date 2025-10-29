Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 517DFCCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 10:45:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 866518E0064; Wed, 29 Oct 2025 06:45:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 817028E0045; Wed, 29 Oct 2025 06:45:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 753D78E0064; Wed, 29 Oct 2025 06:45:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 635168E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:45:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F073C1406E0
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:45:12 +0000 (UTC)
X-FDA: 84050819664.11.A239530
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf06.hostedemail.com (Postfix) with ESMTP id 84D64180007
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:45:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=hkg7jyim;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf06.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761734710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sq01EnGDr5eRCz4SpQ+rNxwk3z5KS5ccSc1QrsKlxS4=;
	b=7HCaLhrU3Rz3eJdndSZHgfT0eIvJJP1zyehV/In7CN/jl2oALxdlM6oo1siT+mxr7U1iEu
	+CFlGjZ4Juq6UNbIFYcO4dy09JfXNURExZ6h7BllIWX1HCxXYlxRPoxRHIgIwr35ibD3QR
	Ipm/UCmej/ce6k/QbGX2JQ95N5/Ywno=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=hkg7jyim;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf06.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761734710; a=rsa-sha256;
	cv=none;
	b=hw9xB6vkMfjiGEcxSqOsfL4fejdjuv9YP4sV0Hso+BoBDcsKFoy0iOkVvPjI8dC7wB2/wv
	4B6Sn+hXLI6dDXXoKbNNo/FQrqBcZ91WerAMXZBM+qIexl988ZPCWu8/oeIbiXaEebO0/P
	b2y1uJP/yHgnQ6AaRB07iD4bTcVLfnY=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59SJm4AZ025616;
	Wed, 29 Oct 2025 10:45:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Sq01EnGDr5eRCz4SpQ+rNxwk3z5KS5
	ccSc1QrsKlxS4=; b=hkg7jyimsLURQSpMM1215mCSiTHh0UNvum49WScyfsDD6F
	jAqa+YLBFIWU39YlhOCubwTLXp21pAXKeYSFxrS2HXwm36AzCf53OKva2relivFZ
	LAeymFFzpRwZ63xisNbj5iGmDsqwwzWDbrEuJDUAiPxPWT+MGylWJ+dp+a3CO3gt
	QmGJ2mUEGbKiP6IJs44hlRQyHMlU+F1XwJtIGR1nFlONacWP91QUl1sqKW6URFU2
	LTtTDixsvg3kjHbYn4fDtd1/pVW9nuMEUoa+tOiQhMguPTlT8kccaZAhkI7Jegr/
	vPIRIwwVdclI+AlJdbBqxts0vv47O9MBbUVjgx1g==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a34acjt5m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Oct 2025 10:45:04 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59T9spqn030714;
	Wed, 29 Oct 2025 10:45:03 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a33wwjwfa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Oct 2025 10:45:03 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59TAixiw62718458
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Oct 2025 10:44:59 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 471A520043;
	Wed, 29 Oct 2025 10:44:59 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D50B82004B;
	Wed, 29 Oct 2025 10:44:58 +0000 (GMT)
Received: from osiris (unknown [9.155.211.25])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 29 Oct 2025 10:44:58 +0000 (GMT)
Date: Wed, 29 Oct 2025 11:44:57 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: Luiz Capitulino <luizcap@redhat.com>, borntraeger@linux.ibm.com,
        joao.m.martins@oracle.com, mike.kravetz@oracle.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        osalvador@suse.de, akpm@linux-foundation.org, aneesh.kumar@kernel.org
Subject: Re: [PATCH v2] s390: fix HugeTLB vmemmap optimization crash
Message-ID: <20251029104457.8393B96-hca@linux.ibm.com>
References: <20251028211533.47694-1-luizcap@redhat.com>
 <6bbdf4ce-10e3-429b-89fc-ef000f118fec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bbdf4ce-10e3-429b-89fc-ef000f118fec@redhat.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=XbuEDY55 c=1 sm=1 tr=0 ts=6901f031 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=YKqhbZKFatMI8GZplqcA:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: fi9EDziNPk_O6GlKsGKU2u_puYD54L1c
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI4MDE2NiBTYWx0ZWRfX+h5nDC3eaDb+
 BpIao59i4TxtCLpFhzaG2LAsa2cGIwnZkc5HPZnmF0IpcH8ECdLjR4oUozrdVw0mX3qbcGrA5t5
 hf/n957YgLAmy2JYZBHXxQsFcDG9PkENvmCazjfAVXqBhEdUbBcR/DDwssgIeepn4cQpM3bumZT
 oWpeCGfx1TRSKT17GfSRAnH25bMU1kpxVBDbl5FnTLEbApeWspbAyyXF26yiV4JoUVV8wkvwQ/A
 7dEmEIFLAXxQ2oHYB7poY+3qZa77DDF4kw56whpoRvv1CkcQqp6BjiRfQdsm+QJ/GRvvbd+6Fq1
 xL4mp5q7roW5W24mcK9Udnz1X658IuveAv542bvgDaKpCtwdOLVB425ojnkXfe45BwtPNfSkKnf
 PmCGxR1EERI5sNCFvkfr+V528JUKbw==
X-Proofpoint-GUID: fi9EDziNPk_O6GlKsGKU2u_puYD54L1c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-29_04,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 suspectscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2510280166
X-Rspam-User: 
X-Rspamd-Queue-Id: 84D64180007
X-Rspamd-Server: rspam03
X-Stat-Signature: cq1mhxc7itpgp1bq1ftuimx88jmx1gia
X-HE-Tag: 1761734710-14358
X-HE-Meta: U2FsdGVkX1/FNFlQ6QvjMdgKse+FZvZou7k+U56gXBGS5Tfy1clx8B2Wbt4FRt1PDUOWHeBibu7kBVCeqXTDGKceVdqIk6iHct4RMyJR0mDE/q/OClBH3zL2iQVoEIU4bXDn65OHRnH6VfTTRxRiZUi5WBgzzq/CXf3DxyVYLfrb4A/8SGlxR/dBlbue0mJHtO/+RBztc+ruzlb0xNjk2eiEi6uZYPmkP0HIItLLErezIbCQv8j1mJJwMp1F8pdbLAORhsSCQ4xmPomM5WLJezf/R1CLGzI6BeZ/2xxd20d4IiPnRnWccFqpRmcpvo6GJ6BWyPjh36da86tFpGf4RPjOt+IiFtRikQBONFGjCt8RXJbW0HsFZLarY1Ds4ANz/V/KTtFdqRSiSQJmjnK0E6O7jmRtxt55BJ9HyX0BBocRs2OMlGV5UpQlV/kNnRMJmN3t1a9GzpuzTzh4cSuaC/dT8ydUnDLl4+FkQaeFvNKGdqelTIca7ipXS/E2bCF2StEa7FVwz0kuS6TxZPraVmoyBXNIiSMNrU51WTRFjsgAdFhGiDDmAlKDQRQPpbw8ZlBslFkSpHroi9nHdj0xz7trAKPldHFbpxyTpwees4nNYazUneDR+rONOxddUN+03skhul6jcVUnkbzKioDfNFUojHd1YdVBpplv2kWeleQPpYAPR7d6Fx9KBqqurO1IdwPxNmSPWnWTtNDQTQE9IJ2LfuHXYvERBt2Y+OavpogVLZPQgf37k9iHQbUanOhj2DexUnp08XaSKL1Ar3VJnf5fnkzXTxE0SwoNq4z/zW5wVS/JqAyCyW0eBN3K3DQXpgMm46EXkG30iZ95qQHMyfWw0/z7SG4VDnLAGCEf0FNMcqOmpr9J03t7sIt8LdlwRJq9ywur735JK7PKKBi6iIgSnptfmjOUOeV4BsrroPuEcsddocl0LWMQYb4SZR2BSch9C6jBNGoibaiR9cK
 DcwAdVnO
 h1jTxsSF5kdOl4GwCBcMEKD2PojikZAoAreS6q4kvlDGWyjQ1H51hepSXS9uULbrWQfGmgfhxmH4+5+zQ80b2Y7jFwOti+Hr4UMaQIyFq1kSy6d99euGLBSaJXsXdj7e3kNZgClxiaZmeDXbSx4i+j3irETGXaTWyG5jgdrDtNy6wrRIYSDS6qcz+IOQIW9gNGX5DQ+D1sIRrfl36GJQAY2jdAm4PpvvRY/YlAV7V8Dlw1CO9XPCc7N8zBA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 10:57:15AM +0100, David Hildenbrand wrote:
> On 28.10.25 22:15, Luiz Capitulino wrote:
> > A reproducible crash occurs when enabling HugeTLB vmemmap optimization (HVO)
> > on s390. The crash and the proposed fix were worked on an s390 KVM guest
> > running on an older hypervisor, as I don't have access to an LPAR. However,
> > the same issue should occur on bare-metal.
...
> > This commit fixes this by implementing flush_tlb_all() on s390 as an
> > alias to __tlb_flush_global(). This should cause a flush on all TLB
> > entries on all CPUs as expected by the flush_tlb_all() semantics.
> > 
> > Fixes: f13b83fdd996 ("hugetlb: batch TLB flushes when freeing vmemmap")
> > Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> > ---
> 
> Nice finding!
> 
> Makes me wonder whether the default flush_tlb_all() should actually map to a
> BUILD_BUG(), such that we don't silently not-flush on archs that don't
> implement it.

Which default flush_tlb_all()? :)

There was a no-op implementation for s390, and besides drivers/xen/balloon.c
there is only mm/hugetlb_vmemmap.c in common code which makes use of this. To
me it looks like both call sites only need to flush TLB entries of the kernel
address space. So I'd rather prefer if flush_tlb_all() would die instead.

But I'm also wondering about the correctness of the whole thing even with this
patch. If I'm not mistaken then vmemmap_split_pmd() changes an active pmd
entry of the kernel mapping. That is: an active leaf entry (aka large page) is
changed to an active entry pointing to a page table.

Changing active entries without the detour over an invalid entry or using
proper instructions like crdte or cspg is not allowed on s390. This was solved
for other parts that change active entries of the kernel mapping in an
architecture compliant way for s390 (see arch/s390/mm/pageattr.c).

Am I missing something?

Gerald, since you enabled the corresponding Kconfig option for s390: is there
any reason why this should work in an architecture compliant way?

