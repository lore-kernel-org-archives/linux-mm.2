Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96CA7D185C2
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 10:41:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E82E06B0093; Thu,  8 Jan 2026 05:41:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5A966B0095; Thu,  8 Jan 2026 05:41:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5D836B0096; Thu,  8 Jan 2026 05:41:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C72786B0093
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:41:08 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 56BBE5A01C
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:41:08 +0000 (UTC)
X-FDA: 84308454216.20.BD66774
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf30.hostedemail.com (Postfix) with ESMTP id 19F4E80004
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:41:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="aYOWi/WD";
	spf=pass (imf30.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767868866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4TTBroKnN0eLVOHeCy8YsD1wmF7ealrZ7/OBBXM8gtM=;
	b=QaZTq8U5EXatOeWYQk1FFilAJddbXs1GgnS/RG58qZBfHeUyzYvvdhBImZRNZmDCbfd6/A
	pfcMDMZmrsei5pASgJGhaZ3CB80y+6Ri8MPSQqiZFqodKey/iFXo63s6hg02Q97r7hxqUC
	tkWPIg/CGRBPaU6rEKyNdTwssN/hfUs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="aYOWi/WD";
	spf=pass (imf30.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767868866; a=rsa-sha256;
	cv=none;
	b=fZZatyTniguEoBBBq3UDBpzh4QAKBpoYuLs3VYK3rZKrnvEHiDC3W9LWwynAKG7zok64Kv
	Nlvk/+Nre6UtnXbC/3p6dYVr28k7HJyTy7b/bqS9y9FxpA8f/wQ7CsOF2OegXcOgif7vET
	szREYbaf/DnQtzAa2aPj56BaZIbYii0=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 607K106Q003588;
	Thu, 8 Jan 2026 10:40:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=4TTBroKnN0eLVOHeCy8YsD1wmF7eal
	rZ7/OBBXM8gtM=; b=aYOWi/WDbsEI6QFGhzuBiObqdHsOaTK2Kc3HcoQ+zoovzX
	2r75nvofMVCPDwbPyv5wPkaeODzKnO0wyvu+4tP59Gq+5oHSnCgONreEStsY1F09
	RHWMjyc8yvGTApGtmyD3h3ro6ZeQOnd9Ad2DcmKJ15HIY4aQ/F2tBQ++SYvryniS
	2oyA4uMNbrAYQCU41sot8qjPBl8ZbtkNlQW6pLXLE4KwKj1ro2Pj4f5Ezufwe1QL
	EAgGcv3bIthcBgnBEMak5xqMRF2eLMycOp/2vLycVyceIsQY1Vu5N522lNqwSOpk
	d/QbiOURcW0uEjCrtbktJCiAroKlkd3CjM1q17Cw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betsqdssu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Jan 2026 10:40:54 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 608AdSul025029;
	Thu, 8 Jan 2026 10:40:53 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betsqdsss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Jan 2026 10:40:53 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60871mDp019411;
	Thu, 8 Jan 2026 10:40:52 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bfg51e0yq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Jan 2026 10:40:52 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 608AenKO39321866
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 8 Jan 2026 10:40:49 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E700C20040;
	Thu,  8 Jan 2026 10:40:48 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3E21520043;
	Thu,  8 Jan 2026 10:40:48 +0000 (GMT)
Received: from osiris (unknown [9.111.54.4])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  8 Jan 2026 10:40:48 +0000 (GMT)
Date: Thu, 8 Jan 2026 11:40:46 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: will@kernel.org, aneesh.kumar@kernel.org, akpm@linux-foundation.org,
        npiggin@gmail.com, peterz@infradead.org, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
        arnd@arndb.de, linux-arch@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org,
        "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: Re: [PATCH] mm/mmu_gather: remove @delay_remap of
 __tlb_remove_page_size()
Message-ID: <20260108104046.9857B79-hca@linux.ibm.com>
References: <20251231030026.15938-1-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251231030026.15938-1-richard.weiyang@gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sCafAl5JZ-iCW3CEVShbxhFeg-5utwS-
X-Authority-Analysis: v=2.4 cv=Jvf8bc4C c=1 sm=1 tr=0 ts=695f89b6 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=BpKC6iUb4ImYL19sRPUA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: zuf_APRcevyr7dXxP5ZWDs6PkNI1Voh9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDA2OSBTYWx0ZWRfXzpscs6TxyynH
 GM7L6OI3Ws+IgqfpA+zIxpv3g0cDNmEZ/IsLExpoUxgnppjOzx6AhaVUtaAgtU8mFbPuVL+rn+4
 lrUL7rSb6nn6tSeCPET9w9tNZ8R2CTMAEA71UWmpMvWZL/2Mj1UMNshrUJH8rvDKQOcyC/DhtrU
 2uEGv2fR/6zrWtwG0ze7n83IBhVnSTYyTZNpzzScmGa36PKYWnytnvN7Qi1ZFMNySvxgGAGpUpc
 gCFJarXBC02LdthiirYxfczNrqQV9dA3ica6qPpc7Hi3hLoKDVe756pxH9KvmrMfJVSWXtSzxqK
 kpJ6N/TyFPzncHda6iQTQm+yGYWp8g7zk7GfyhNIlF+StvIRDgq5uNblcllPNRUFhBQmUWRZ7lp
 l0EN6nLKcEHmxhg9xqnRNCZKfJKz0Kii0JRPB1+ord0BAPOHGtMyIF+5Gt8VeDQMex+gmOXkayF
 TtB/BteVCNu8pUZqD2w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_02,2026-01-07_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 adultscore=0 spamscore=0 bulkscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2512120000
 definitions=main-2601080069
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 19F4E80004
X-Stat-Signature: koc97p4azrufbaaxtwd6tfyaf36qor6c
X-Rspam-User: 
X-HE-Tag: 1767868865-137436
X-HE-Meta: U2FsdGVkX18MVJFS5P22aqLOm6VcmxF6M2NU0jy6JruGeuI/UQKqDGGUw1D6wQRWFptbKe7sh1/mekleor2TpjaXKRXH9BCe4/UeYuU71yo0D5xJUPvWIX+IYBRWkdber8OPDEYVSbI8WQC9ym1mMOQL5UdWnH+w6Lvd1x6ytyR/cXW6VSrW+h3ZzxyPn7vZQEutbQFjxMe1grhJ7L/L+6X2wq0JOq6GQ1ZYiPdgppvDHxMInDxdVZxAW3Wz1oYsCRseETn6SZM6L7l25mN8b/dLTHD0dwJ0T/PrzVX5DzFkATIyScmkgsz8BkryfV8HcgInY3lNckNv0771TLGuHmOZFYQpUibJ1FXJ+4RxfhHuDFGOY2lk3b20IMsiARQapmrITnRkjstgyu3YHkWW4w1mDeqn2IuyTSOn/zebytUoZICt+8X6oBdQ80Pxr/4zBfUJ+Du8peJKDWtK2VaBGeopQCwfHniN8SdF+nAeX9LqUjIZWVEJBtKiKwjoImigicEvxCw7nGuxitlHYl5iP4qP1uzOiAKnmSEG+y5hvkfP9ISVUISd6rT0O3+bD1DLn/eUehFBJ6jQLJUHBdOxJ3o1Dj0lhm0d6vdiH/Jcoy4pcs085MNpaIgKg1wf5HqEtN9I25zsCuSO0kM6Sifa5tdpJAkb8+UJrrkh2fu5JyDX3C4r6zFtaFWNZk3A+sWRGZoZsJch1q4G5h0dXvxyE4R5iFmBFU2mCbhG1fc/VV4Cq6Hh7BWcIs19Apt662MVhlHhw8MPlFR/i9IUpAASLbg6Q5vCTAStq27vhbKQGGkLLmcUWSkjz1F3IH7dtqNCuXFW9KJ10TxwVz9foaXv7/B29RHeMad+S+uNFAQhp3ppYFh78BrHhkwijJ9B7bt42D+yFFQjKTAqshCbgen+K8/6DD2FakfeqrncSjz9+EMNF6Aw0Nb2hOzeH94bRWFM5qvK0GDgb+RzVnxwFsj
 T/OwtWS2
 bm7gIG0yz3X5xkGJtNkvOIP3AgN0g/qz/hi2deIuLkCgV5ul6dEfyKr4F8CKsY+e+ClD5MvHsyScicC95c8mmg2SoR2LZPdxQfasw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 31, 2025 at 03:00:26AM +0000, Wei Yang wrote:
> Functioin __tlb_remove_page_size() is only used in
> tlb_remove_page_size() with @delay_remap set to false and it is passed
> directly to __tlb_remove_folio_pages_size().
> 
> Remove @delay_remap of __tlb_remove_page_size() and call
> __tlb_remove_folio_pages_size() with false @delay_remap.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
> ---
>  arch/s390/include/asm/tlb.h | 6 ++----
>  include/asm-generic/tlb.h   | 5 ++---
>  mm/mmu_gather.c             | 5 ++---
>  3 files changed, 6 insertions(+), 10 deletions(-)

Acked-by: Heiko Carstens <hca@linux.ibm.com> # s390

