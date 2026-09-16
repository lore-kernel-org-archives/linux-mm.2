Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9A12C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 13:06:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A65766B0092; Wed, 16 Sep 2026 09:06:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A15166B009D; Wed, 16 Sep 2026 09:06:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 905386B00A2; Wed, 16 Sep 2026 09:06:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70D506B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:06:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EC35E406EE
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:06:24 +0000 (UTC)
X-FDA: 85219649088.12.9C69194
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf31.hostedemail.com (Postfix) with ESMTP id AF38820003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:06:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=QYx6XfSc;
	spf=pass (imf31.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789563982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QNWO4sF6JJSPgCQ563b79471qNq7+Qih5/QZYS1AokE=;
	b=U9OyRznXC0nvBiC47V5re7MzD3dW0GL6Bh/yAtRveJatWMeGpi4PF7HLzy3uWB4Ot0UIjk
	a1uovYRc8XcX///cQjUgkN3yYQ+lkvNor/L5KtH7w0HGmm6+uIbQAeufknds1D0p3KRKuJ
	kd+T6oZP3b7m950gi+5I/q4wZym5Zt4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=QYx6XfSc;
	spf=pass (imf31.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789563982;
	b=qn49jVBz5vcr3h+6cJLaK+KO3SiOy8VwvFDiEc4+OxfJaeVB69jwcJLneeE/yIPuWjOt63
	MErKHcppr1cZLhsbBlnhV5irJBSvVc2TOltcnA6V3OFcwqLn1BTrzr8zwMrnydLtfL8Xuz
	eh17lRO+2SLAF8bbd7CuES75NQ1wsqk=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GCVmvC3793176;
	Wed, 16 Sep 2026 13:06:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=QNWO4sF6JJSPgCQ563b79471qNq7+Q
	ih5/QZYS1AokE=; b=QYx6XfSc3srQiZUA0BAaWTxH14xH7+An5XfuTY8pdxtjqu
	IUEiBndkQxbYGi4rVDTqMHgJ7eUUgTPnJzYMIGzE8cpO6xeIWk5UWlkzLTuEUQSj
	P7lRhObGO/FnNL5FIU9Jjf6onnQetNKy6w5XhItuYNl5+4tQ/YvRqImgMhrBQK/o
	p7BBHaGj9MX6WRVimd98xbo9HQAAV9Zp0FltQDAtb3850XbeVHKdV3lkn29VE8Ia
	UBRkcb72TIW31mP7lQzheOdp0+sOXAoLz0f1vpWFNM7XAOZULGd23AZZdZinLUBL
	2HRg4O3joIje4kzi4Z87JHWZKj4wMEwS+jrNsMHg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxcv49hg-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 13:06:19 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68GCZJW41491467;
	Wed, 16 Sep 2026 13:06:18 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gpywexefy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 13:06:18 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68GD6FEq44040464
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 13:06:15 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F0CBA2004B;
	Wed, 16 Sep 2026 13:06:14 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8E5D320040;
	Wed, 16 Sep 2026 13:06:14 +0000 (GMT)
Received: from osiris (unknown [9.111.77.138])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 16 Sep 2026 13:06:14 +0000 (GMT)
Date: Wed, 16 Sep 2026 15:06:13 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 00/13] s390/cio: replace page allocator calls with
 k[mz]alloc()
Message-ID: <20260916130613.15587F91-hca@linux.ibm.com>
References: <20260916-s390-cio-ready-v3-0-39e4894637d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916-s390-cio-ready-v3-0-39e4894637d6@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDE3NCBTYWx0ZWRfX+o2F8YeFAktz
 +yDxv5+GTeDFJLw4b36D3SahaOWlvmwAiGvmVWpq3YtVZ4Ab91rDjKsi2owL7F0cgRBE3RvCFLm
 hBX6YSEGESg15p+MADmY/mT066iypR4=
X-Proofpoint-ORIG-GUID: ntCVBk8ZFkXutvp8Zb1bdGyaY_Ijiriy
X-Proofpoint-GUID: ntCVBk8ZFkXutvp8Zb1bdGyaY_Ijiriy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDE3NCBTYWx0ZWRfX6TPOHMSh5PrQ
 kpLWSj1DtAS4wYJKW4LQKxhYjs35yDZhjcCfP/IRU6FJzfH8d7tHHeStz1cS723nLZdfH6s0S+N
 L7RqCAD4NrA0vWPwJAWSe1YxHqlN+qruoUI2KCfHWvYoM6pW01kWWZGuUdSOeY0QDr8xsX11900
 TZ5XNM7b+2i0QEr8aoiqyg+BE9VNpcw/apptpZXqZGwfj/qm0YGCQVF7iLSGhOsgbtXC7PKD3Dg
 AhWRAdOg6aLjkpcPTqa20qzPCxh8BtDZvJZRy34zmhYawlezHuBjrwHpGD2iXYdjg3d4Ao8KLwn
 DkB36jz1YogN83fwL/zSXEs8gffuOcTomsBRkGHyPAOwIkQHlpOyQpNDE7iGkS1ykNkKRpgq65P
 aFD2XvGkNTYymqroFeXIzK0oHv6o/X3L9q3CCcWtG6N/taN3FLR26PP3tpoBa0E4eL6mdg19omQ
 zPGwUMpeL/WvXfk/pcw==
X-Authority-Analysis: v=2.4 cv=F+7C5ahN c=1 sm=1 tr=0 ts=6aaa944b cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=ZIp3wtoaij0CHaT4FdYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_02,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 phishscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609160174
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AF38820003
X-Stat-Signature: 613fqbnqopte66oe6m4eakwonaj5rmpy
X-Rspam-User: 
X-HE-Tag: 1789563982-660053
X-HE-Meta: U2FsdGVkX19QB33npJhXo5U5HN/IKcsz36eDEg8a5abEULmkPoCVvjLyNn33rroxLnBWowtKTAoq+dl2S7eI4P4q4SGBhBHnPAZ7ykLE0rlchXXGbF1pjTYhEzBtrGuGEWSp2HWConTjGQCr16T3zFbNsdCK28gZk+Z/RE9CWabX+jTDbrY7lCbSQz/gsUDThDBRBQ4IhrrRcYK7zk6IvMNYRKZijmYk6HffLSzXJWrcFswTJnm6wvY83pk8pTBey3qEKPX2qu34vh+TRMic23/BDFXp2D12GS+Yxir5gc9aLt0pTsrJofLTDIS2BWmiOw7oaU9nI00UiaQk/mnyspVkjo+eOP1AFgxSZ0et6KZdrPmZGCpmzpsgNkte1Vg0uYJG6wTIi1UKTKinos16Ry7ihdQL7KKl0jx6Jksk87uUzOuwsEH36+soXzLe/atOoVqVjW6PMCg/OnPze0C4P98Zy3A/nyrTURKqfFJubNmL195gP6JaljBXb7ahmbxmP6hl39YhgYryneYfKz6uyYCFvfPDNRF+C0cU9In+9fu+aZMD94iHpBBw9AzN7AdRaaotAPCJk3SZqZVfRVYI8UKPKo9ZEjNU8uuhU6O5RovkMoNDGkOAIG3qBYQ4SKME/EWgsshnCaoMwN54ZmPYS36zJ7lBMjpZMsgVOiBMVaU0Ddz7HXPu10g9EypQViJnOsXOdQJReBVdI6WEBqK/6Zo+Cbln6Ng6tmRi8WMcCOpaO/V2egrin3kDElS6686emXUHD8iZF8zYkivg6b5N1cCOoqS7WN66b0Gvx+kINtPQCsPUBvjyw3BWEbgTBbDzLUVpTbJXZLmQv7qy4mkjrKsNmUzqFVzobX2dIxTRp/TWnrCSgPh2gOpoptwqvojHk0kuE6i6WDr33l03Vs2z8VSYcBbhiH8TAnKUx1WFD6RslV0n+IbogkBp92R0ZBuSfmnIUj4S7zI5t1er/2h
 jn3MuGtT
 OMHVDZUT5CR9lKczqmD7bA0rXMT2I/2gUFzh8svKvYxupxGxR0357MdabDC55jo0Rwtzhan1zrFSb2MdVv2gFI7XTNNzevHxb7x9793wTQXOKZ7UsH7x//eMtLOsNxuRl9wOa2FhOtad9YKnTE/F2Q3fIvDhGC9htMiQg+49YDL91p8Hi9aERJr1x7oFR2ZD1ckNh/QLeizab8Anersrdg6Gu4WKz7nHWG8Kx96PHc6uiweHEfPIjUV/xOCZQQxLIWHGQugkVv8Wrh4yEgOYn9RcYM+aOIV+UiQ7AuxVHE169RCuJ1BU42Z0SU+qWFfAHxDowyx4yCzOCSqc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 03:03:07PM +0300, Mike Rapoport (Microsoft) wrote:
> The saga continues :)
> 
> This series covers CIO, QDIO, SCM and IDAL buffer allocations.

...

> Mike Rapoport (Microsoft) (13):
>       s390/chsc: Use kzalloc() for CUBs
>       s390/chsc: Use kzalloc() for the SEI work area
>       s390/chsc_sch: Use kzalloc() for CHSC requests
>       s390/chsc_sch: Use __free(kfree) for synchronous CHSC requests
>       s390/cio: Use kzalloc() for CHSC work areas
>       s390/cmf: Use kmalloc() for the CMB area
>       s390/idals: Use kmalloc() for IDAL data buffers
>       s390/qdio_main: Use kzalloc() for the IRQ structure
>       s390/qdio_main: Use kzalloc() for the QDR
>       s390/qdio_setup: Use kzalloc() for QDIO buffers
>       s390/qdio_setup: Use kmalloc() for the storage list
>       s390/qdio_setup: Use kmalloc() for the SSQD request
>       s390/scm: Use kmalloc() for SCM information
> 
>  arch/s390/include/asm/idals.h   |   9 +-
>  drivers/s390/cio/chsc.c         |  20 +--
>  drivers/s390/cio/chsc_sch.c     | 300 ++++++++++++++--------------------------
>  drivers/s390/cio/cmf.c          |  11 +-
>  drivers/s390/cio/qdio.h         |   2 +-
>  drivers/s390/cio/qdio_main.c    |  23 ++-
>  drivers/s390/cio/qdio_setup.c   |  14 +-
>  drivers/s390/cio/qdio_thinint.c |   2 +-
>  drivers/s390/cio/scm.c          |   7 +-
>  9 files changed, 150 insertions(+), 238 deletions(-)

As far as I am concerned:
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>

Waiting for IO folks before applying. Thanks!

