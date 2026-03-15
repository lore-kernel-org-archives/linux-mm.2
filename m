Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A082D58B0B
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 04:01:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B66026B0088; Sun, 15 Mar 2026 00:01:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE9316B0089; Sun, 15 Mar 2026 00:01:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CB6B6B008A; Sun, 15 Mar 2026 00:01:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 878B66B0088
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 00:01:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DEEE98CC50
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 04:01:55 +0000 (UTC)
X-FDA: 84546948990.30.B0A2B3D
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7B57FC000E
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 04:01:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=bbh8IHqn;
	spf=pass (imf10.hostedemail.com: domain of maddy@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=maddy@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773547313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PCPGD2zae4hTeInDIhqub/VNO35JJ2u+zu4SZpM1c+Y=;
	b=7tLELbCmise2ls8rgbROO0FzgM3ccMaip6qG+Rqe1C3VTMo6UhSCOU0XwGxjI6r+X4iy2f
	bhtnjoJbv/p4GNw1kwooFriHwE26HtbpezeZlTPORSO8ILtcWwCKk8n2lJSwuncBLZXwPz
	KKzc5Fxi8HjkDfTNqk9J7H6qZO5KLlw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=bbh8IHqn;
	spf=pass (imf10.hostedemail.com: domain of maddy@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=maddy@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773547313; a=rsa-sha256;
	cv=none;
	b=4kuEbn1T8qRCbEqrKnfXMgs1y1ghBO+7ADhZGyiWsG6o7CuLQ2zRD2khi0NiKfywvAzkIy
	EogAW2Adp2OdZ9QP0P+Rhrqpa9hWZ6EXQBZOeWfSoUZW59yC72xKWwgY5lUYt3grsHHUhR
	QHT/oIGP2twyRxh2cwlt4xoR96udP3k=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62F2SSHe2890189;
	Sun, 15 Mar 2026 04:01:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=PCPGD2
	zae4hTeInDIhqub/VNO35JJ2u+zu4SZpM1c+Y=; b=bbh8IHqncn/4VVkqHIKrmL
	C6UUIDlogCf2+1ARx+LQIHTGb0/qK+o+vRcmAlnxrprP0qFt9Rleh/+iFHrOmNSn
	Hhs/lvACta3/cAbK2IO3wj9qbPGvS8YN82/ByiHAmWa+WSoAphDpi+hmMv7KSbMo
	flrNVhrgGttwypPb8bb/9rMv+esJWNt+C2okJtpDFqn8lkeYEfyUP2yRFmr1fZXi
	KkxzPbLPyVw7aj7lWRpufQGOwXzdiM2e69OhuLqagrkkOiAoVcV06UHJFcITLZ91
	R52IYnoPu17isExtbY7euGReiDxVqLL+Ka54+UXPXokTkPJJ4JHF2IXVYzyJi1YA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cvw3hk58g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 15 Mar 2026 04:01:43 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62F2gMX4032320;
	Sun, 15 Mar 2026 04:01:42 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cwm7jg56c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 15 Mar 2026 04:01:42 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62F41deb29950270
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 15 Mar 2026 04:01:39 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 323AC2004B;
	Sun, 15 Mar 2026 04:01:39 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C972B20040;
	Sun, 15 Mar 2026 04:01:36 +0000 (GMT)
Received: from Linuxdev.ibmuc.com (unknown [9.43.97.251])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sun, 15 Mar 2026 04:01:36 +0000 (GMT)
From: Madhavan Srinivasan <maddy@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>,
        Sourabh Jain <sourabhjain@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Donet Tom <donettom@linux.ibm.com>,
        Hari Bathini <hbathini@linux.ibm.com>,
        Mahesh J Salgaonkar <mahesh@linux.ibm.com>
Subject: Re: [PATCH] powerpc/mem: Move CMA reservations to arch_mm_preinit
Date: Sun, 15 Mar 2026 09:31:35 +0530
Message-ID: <177354720777.2367911.7154288884175799421.b4-ty@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <6e532cf0db5be99afbe20eed699163d5e86cd71f.1772303986.git.ritesh.list@gmail.com>
References: <6e532cf0db5be99afbe20eed699163d5e86cd71f.1772303986.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: N2FVgG2p4Lu-WTReS9VTNJDNO-h09wpK
X-Proofpoint-ORIG-GUID: cBDUdsstWvV5-jpkXRtB8AEdX2CXlz7m
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE1MDAyNiBTYWx0ZWRfX7TVYeuLykjmI
 gcnoWNrMSsHCTjGcUGp607ywbJUCL6YseTByyZa7yYyVAbXDRZ0F/gZrJZt2QOZ3bxwpvow+w68
 5Y6vc/eDUDw0gIoe99b80+LBiTRXMTa6wXo3FKdSNdLIsVmli1FZz35+MbO+qjQRZ48oldKR+cg
 EuyBEMPDfeOBTG+lwd12UByxERh5SiDVkrI/L0Z5HJPFHPt27AkdgxGJWSRiJl8NGEkahw0EaoO
 pqQGWMEpNbq7yoVYjDhybQCI1jJeFaXwUJrQL8WeuNDqLiernqDguG7SlDH18/xM9qqkBLnQaXY
 hdep81FY3XjzAqSTrT6Sv3xpfgdKNxISXthzVypQUCBoC42KkSIugE4e7pI2ayyD3RT2DXWQKPe
 3lLY1NQ3AVVXoGzaK0gE3LAVTGXV9Ll2g/U4DQt+IVswil44Kl7mLBXVKOOxMA/F+XjU6xmlLqr
 p3se1q2VC006HC+lf/w==
X-Authority-Analysis: v=2.4 cv=Hf8ZjyE8 c=1 sm=1 tr=0 ts=69b62f28 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=vRg_hqKlNKNa9p9_vvAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-15_02,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603150026
X-Rspamd-Queue-Id: 7B57FC000E
X-Rspamd-Server: rspam07
X-Stat-Signature: xqof7i7u8quoup63dio6btegoihx76wg
X-Rspam-User: 
X-HE-Tag: 1773547313-40744
X-HE-Meta: U2FsdGVkX1+uUZXGBYwR9jaV8IIOEw1Rtn/2JOmG0dwUjiM60cqcn/9owtD2ZWPyWrpctHDuIK24jjOCmT2/gnUxfsdRT4+hlLxit4YPCvkhDlVlNgG7j1cyKt/8X+LvjdqAbabZyKPUJJDPEryarW8zldnuvokefPg5zllFWDatlyIRXLDi1A8VbZwCd+KJu5LbYfoqjPp33mjhUIl3bbAXPGyNs06NofKOuyUhJmrgSe+Z6pRV2ZnGHQwhv59/xqOlQynY8FygOyitBdkWrNiUxOpnmg/BNKnpoE2T5bKj3uKrx231Gb+PyWobS10nHx+Cm2RkoM8jAcp0OctXJaSa1uGFunrDe7w77MtoyvtHyWrlWiTDC+cnpKMJDAyIl9jUB1nhi9yqcLx4l4eq5NkQla6g48hxx7fpbS7KPiB9RKx6bThMQKKNWfQjZA71A7Hc7intJWA/WCfS8px05KoDJGbzR0vKE5s56cuQVRiu61+bIicNZGBq+xhzcog9pomSn987SBxdagYMKU/ytY2bl9zI0jVjA3Uf9Gcg52B7RrDqJUpivGlI0zGrtQ0n9BCvsLM40eqCnr/46ztYZK31FsLiSUkuxm+UYV3qmiqziRPIQauYTGKFLeBJBWw2jpxYedPfRr7uzEoe0AIEHm0sBYOn7VbIO4WjsADFKj7UYJzzX5aFKwaK/IhjvT4I/eTp5RndxHrZ5lHldtu0uh79ckAIX0rraLjRsNstqn7dnJ1mHeKVX+8RtJ1I/4ab0xuc0bI6kEU+l6jONvMWknVKIz0GZJKglIwI1w97yMhpce5yEaf3w7KW6Vu6JQ0xAT/Q1mj6BmTmQhY8lvlvt0c2gZgcyJVQqsnF/4i88Oi/Lh5Of7/J1VEmmyZSNuq08WnNGWr8ZJt6spQWVjrChk38tMN7/s56kqUI/KK6mAvwv0OQHqltLmBYk9+dZvBCsEZ9TFc4N1Nx+J8/Dsw
 l/EdYOR8
 a7af7PwWwir2XIX/LaDEqj46elh9zXlvRbfNivlo/9hVQZGBsZ8U0m0QknyEyiwMfEbV1bF/KfbPZ4TqfppKsv43zV0i//9M5uFhUAt1s2Zjk9S7IZtUE7OgmCkZ77OQLTLuCXqbkPPjdhcDN1d+rFCqw12aufHOlMk2+37D1/+KGu1IwmciSIx8paDZkJDYpRULJXpqT959ieJTLeGTrmHHOJQTbJCx+79z7l32VzMkHTaszo9E5MdQ+s7SwDbOCvBcZBDnn3lxTqmWo4BEzuK9fVWFmvJezCq9QfCa0z/we6ehIiX5VDBtM1aeZtV4QThgM4KcwFoH60WO/NDFumhavRBKmd1NYSckzeQ57rRfi6KCvr0hJ/ZfL6mAbkur19fd5KLTkYFpIzYYUQYVqrStFMRYMQpQPLGZo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 01 Mar 2026 00:17:59 +0530, Ritesh Harjani (IBM) wrote:
> commit 4267739cabb8 ("arch, mm: consolidate initialization of SPARSE memory model"),
> changed the initialization order of "pageblock_order" from...
> start_kernel()
>     - setup_arch()
>        - initmem_init()
>          - sparse_init()
>            - set_pageblock_order();  // this sets the pageblock_order
>        - xxx_cma_reserve();
> 
> [...]

Applied to powerpc/fixes.

[1/1] powerpc/mem: Move CMA reservations to arch_mm_preinit
      https://git.kernel.org/powerpc/c/0a8321dde01ffdbd9455a028194d57484def59eb

cheers

