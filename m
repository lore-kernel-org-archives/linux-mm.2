Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9A90C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 18:20:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B3606B0088; Sun, 20 Sep 2026 14:20:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83DED6B008A; Sun, 20 Sep 2026 14:20:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DF106B008C; Sun, 20 Sep 2026 14:20:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 454DF6B0088
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 14:20:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 42798140492
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 18:20:24 +0000 (UTC)
X-FDA: 85234955568.04.A234BC3
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf03.hostedemail.com (Postfix) with ESMTP id ECC2F20009
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 18:20:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=LarCZc8w;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf03.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789928422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gSQm+/rR3pASi/0SUNxB8Qq8vPENv6CpvH7QrG78q0g=;
	b=oMui/5a4fPUUGSu70T5rLKrdaZZs9HeGKDxJFLqOHF41zB311NmyvlHrdyDQ+Kt2p2rFak
	8oaLMn+r0yt89oWnT7+/EkG/kUgdh9bSeeVKWvruIhsGoB7k9UXTHDVvOEwGGwjQnnicrR
	TKP2BQqF88WzD5m627Tfir+IJOpc19U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789928422;
	b=i7fFzMxJ7HpRZHa/1F2lacsTeHl7pU1IdK1wIrEKZNNtrlShVGBQPcYns+jF89PQk9L5WZ
	sT4zqqlz/8C7X3P9bZjzDJZ3oD/TUA8ElKAro4Cn6mjWJCEpF5nfpF7+zSHu82yZTu0HIp
	3snHBSZNTKOsHAcdrfrH4AY1x0vzEh4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=LarCZc8w;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf03.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68KFaVga1879573;
	Sun, 20 Sep 2026 18:20:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=gSQm+/rR3pASi/0SUNxB8Qq8vPENv6
	CpvH7QrG78q0g=; b=LarCZc8wstRTyvaeeF0Rh0VILzD9xcn8lLzVEPYcumq6/i
	V0b5uoLVESOv2NgUqkllClbCi9DrFyM1i581tho1hnhoPvU4azjnnnXFc2byI1ay
	wdEVzxvcNP7uAp/i57Do9wFrke/FCkzCrkrzUPen2oxu905L/K4XjCbMMsAj8c6s
	8bLjZxEynWwCp+fn0za6GdSG3Ob0dcoXZLZ6/+aeyIfj4ALkb8JD0q+igTBp8yD5
	UW8FBUwbqW4g8fnv8AYHIA/OsJDZ+dONpb7fCJfrQbCa84ZX0UN5Yd0XAnBx3s0S
	yvFsjk71Kvr7BarwSN1MVEDN4Tpga1GqnwchMt7Q==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gskgq54t1-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 20 Sep 2026 18:20:18 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68KFHX4j4109026;
	Sun, 20 Sep 2026 18:20:17 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gt4qq2fq8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 20 Sep 2026 18:20:17 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68KIKDtI37093870
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 20 Sep 2026 18:20:13 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C42BF20043;
	Sun, 20 Sep 2026 18:20:13 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6130020040;
	Sun, 20 Sep 2026 18:20:13 +0000 (GMT)
Received: from osiris (unknown [9.87.137.215])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Sun, 20 Sep 2026 18:20:13 +0000 (GMT)
Date: Sun, 20 Sep 2026 20:20:11 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 00/13] s390/cio: replace page allocator calls with
 k[mz]alloc()
Message-ID: <20260920182011.18515Dfc-hca@linux.ibm.com>
References: <20260916-s390-cio-ready-v3-0-39e4894637d6@kernel.org>
 <20260916130613.15587F91-hca@linux.ibm.com>
 <bf57f67e-4a51-407a-b869-b9d78a9875b4@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf57f67e-4a51-407a-b869-b9d78a9875b4@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=G+OJgNk5 c=1 sm=1 tr=0 ts=6ab023e2 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=iTZJ_rmbzj6-XQSVU9QA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIwMDI2NSBTYWx0ZWRfX6ARKW8NV9hd6
 BVG1Idc8lZzxNnuVj3XxjILfISXO+yn8R8T/PqpYBX3RDAEoY/VhOv2xLFGvSB6RtC8UK8ZXihW
 jI9v8zwB6DbaYjwWkRI9l4Qo7Xs6VvqGmz8MhD0tWM0/8AcxzG7osvsPao2FMjq0RNu3H0fmP3P
 qnZwEZ7KTx1skXIMbcx4xqy7sOFiMR4Rvmab5SEwlmo7wFrfrcBP8rv4LMUtmZ4qZvXMEzKbzTv
 Mhwu3C8BdA1SktJaMOusCZ9FTgHdnUistRtb82gBIGj8krMdu/U3lKhkTOuxxKujmYmJPTR5P0y
 KNEATWMsgnksIGRS5M657qGFTQNnHlZc54gL7BsgZRWA+NI8F8IOxH7UanwALSvZ/kzq4X/o4J5
 XLlTy5bccwoMLKJ3BBj0BlR0G9l7bLUApBWNYgrYZySDAFNQ7gGOK+sKsCrjmFM2plGEuXSg7Gw
 uA+sSkepdPLZw00i+Dg==
X-Proofpoint-ORIG-GUID: A898qOlsBDd8jU1o4XP8_XhYfDoXwp73
X-Proofpoint-GUID: A898qOlsBDd8jU1o4XP8_XhYfDoXwp73
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIwMDI2NSBTYWx0ZWRfXzn4lTBGwUaX/
 nTH6fCleWHQK3oHHVrj/QUyaeYVykEhfTJgZRTaZow3yzUC7hyXbSFPRSxJ6JAfD0gyw5DRpFah
 7Q/ct+MvIIRil+Vi2BfaGerox59rezE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-20_05,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 priorityscore=1501 clxscore=1015 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609200265
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: ECC2F20009
X-Stat-Signature: xh3hm6nd1wrbgytism5gskmkypxop8ck
X-HE-Tag: 1789928421-54521
X-HE-Meta: U2FsdGVkX18H50yesCd5jISJTZg+iTqo4zU31eZGmq+Qz3IlDhOgK4YuODEce0Gd9/ONf6169c5vFlE/GtyCauJIW6WbfQMUz7FY+dfVuqO6Btnaa1PbH/o0Tj7Xpz8tR2i4pNZj0bXn82zTlsHJ8gFNMmdJKCukEXC1kSOACAHL57+EF+geaFCAGpbfhKgXkNALb7150q8tBeXR5s5M7nQ6BIaDrBMyYerHCpEP+ppEJyM+OTbSTURfQenCRONlLU47mrBXmCsxlx+7F4cYP2iDt2jLQ/3lY5nOt/Yzo2f0CRqRE61BF/PK950IYfBtIfnRkbbvZOpO769DIP4EtyukCKbblub5bQ82+Fy58edzNTnMdStS/gPvxr1AI5VGtjhYoSme2xh55uOkj46VrmM0YOoRqBosF4r6BJ/GQO8RChpCNlH7IzSi6Hg3033ej1DfiuM7xWzPVFafUjsomRfjpmw+4mgaM2eOkYNOh4Mc0H1lzp7SgaVOkmgOXbV0WsCv52XI3UwbmEuaD5H6JkOsv9McyDQZtm3h103jqyb/9b5Iag60Vfqt1Kff3042vsnSCufwG6nd5ArrYd3VovkNajfJ3JaTlwzuDetmkt8+KrjM7v0wXyKFXtErpKJ4aIzB1XkPVnZHDSjUriTWnbOdr+7tscqSyrZH5NtGDwnnE21yHS6VAP7Y2a2tp41RCJaZDruEKf+TjFW5T3QSgeHIOg8Q/YlqZE0M75mgqi/u3TkcsbOaRHWd6jTCnzI3ZEC0ZsqmZ+hkOLFGolT8G9+lRG8T+PSpnBmh576jrkRz8ScruhKc/2ea2BFG6YdM3aX/UnowDEclIn6YeTMo1QorB2viHVs5hOyJmoXQ0YnW7TqmUclhoQH6wzWvAEcJ0Jc5FOE2XIdzgRP8zpDBYqp4THan6Q7vQyPLd0fUfQ9qntxqej+rDWl61Hy8at53ptJsfQochf/UwcFRNDc
 l7YXJ/B0
 AbE/12vmXGyY79DDxYKdSpuII2H9Ol3F7NN2nob1JY2QB7E9+xjLVVLfTQt6J5djRMD3pX3dAU9thBO8xD/adzCSYgLqVvoqsB6sZUi+Xfsb9UgkEhWU+/j9qzrMNPlidJhpMaEyO3L+/wG1wQgJJCnnZKoV7JLuBH5Cfyh6Cd4pOxr2Gnj0ZaK9EcbEA2c0uVFAKgVFeo60w6EMpmswCJcV+h69qM/G5k9cqpZx83ZSjZuOb9GzdURYExbaSfUiBiLs1lwQiSKqr/9IZlW/XZXvY4Kcgzi/jR8TD9Ms0FEUOHyVUztrND4J3X/yzWbkU8hcE/LBi1xeykS4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 06:23:00PM +0200, Peter Oberparleiter wrote:
> On 16.09.2026 15:06, Heiko Carstens wrote:
> > On Wed, Sep 16, 2026 at 03:03:07PM +0300, Mike Rapoport (Microsoft) wrote:
> >> Mike Rapoport (Microsoft) (13):
> >>       s390/chsc: Use kzalloc() for CUBs
> >>       s390/chsc: Use kzalloc() for the SEI work area
> >>       s390/chsc_sch: Use kzalloc() for CHSC requests
> >>       s390/chsc_sch: Use __free(kfree) for synchronous CHSC requests
> >>       s390/cio: Use kzalloc() for CHSC work areas
> >>       s390/cmf: Use kmalloc() for the CMB area
> >>       s390/idals: Use kmalloc() for IDAL data buffers
> >>       s390/qdio_main: Use kzalloc() for the IRQ structure
> >>       s390/qdio_main: Use kzalloc() for the QDR
> >>       s390/qdio_setup: Use kzalloc() for QDIO buffers
> >>       s390/qdio_setup: Use kmalloc() for the storage list
> >>       s390/qdio_setup: Use kmalloc() for the SSQD request
> >>       s390/scm: Use kmalloc() for SCM information
> >>
> >>  arch/s390/include/asm/idals.h   |   9 +-
> >>  drivers/s390/cio/chsc.c         |  20 +--
> >>  drivers/s390/cio/chsc_sch.c     | 300 ++++++++++++++--------------------------
> >>  drivers/s390/cio/cmf.c          |  11 +-
> >>  drivers/s390/cio/qdio.h         |   2 +-
> >>  drivers/s390/cio/qdio_main.c    |  23 ++-
> >>  drivers/s390/cio/qdio_setup.c   |  14 +-
> >>  drivers/s390/cio/qdio_thinint.c |   2 +-
> >>  drivers/s390/cio/scm.c          |   7 +-
> >>  9 files changed, 150 insertions(+), 238 deletions(-)
> > 
> > As far as I am concerned:
> > Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
> > 
> > Waiting for IO folks before applying. Thanks!
> 
> Looks good to me! For the full series:
> 
> Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>

Series applied, thanks!

