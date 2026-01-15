Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48765D3CCB3
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 06:13:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB5E46B0088; Thu, 15 Jan 2026 01:13:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A62E36B0089; Thu, 15 Jan 2026 01:13:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 943DF6B008A; Thu, 15 Jan 2026 01:13:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 84ACB6B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 01:13:45 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EEF62C0332
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 06:13:44 +0000 (UTC)
X-FDA: 84333181968.18.5A62361
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7FEC4C0008
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 06:13:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="ifeEmi/X";
	spf=pass (imf10.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768457622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gFjWdO1Kr7nTH1rvXfR75t9SJ08y/Dca1mE8vULWp3A=;
	b=tg0/EoHNDrPbQyqc+j+JUICySknIqaHfdVgaxTnFESXHFPI3pN4awSKSGXq7jX9YZmQEGl
	/v3sJqB/ePzFhmQmK1Bu2UwfXCqVWLtYOVZa25iWhm7hXm3X1jPI2B86PmpH/wo8/hZMSY
	AzpRIbqw//F3k0XRhM7YOqSzgD0ObuE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768457622; a=rsa-sha256;
	cv=none;
	b=JkDoxmFQVrEHb6IEUJNDnckPIf7Q+jJP39s4jN2UOlDFLxF55x1CHVXe06mJuR92kvZkDk
	uKKU9KWOqrhLimKG4Ab3x8XNwGJPCVBmbYoi9fNkAtBOkqb4euIkHRCqBIw5O5DWB8sbKx
	Eh+6eu1iwn0OYqNJOb9wZuh4cwPlQik=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="ifeEmi/X";
	spf=pass (imf10.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60F0GKV4004876;
	Thu, 15 Jan 2026 06:13:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=gFjWdO
	1Kr7nTH1rvXfR75t9SJ08y/Dca1mE8vULWp3A=; b=ifeEmi/XL7ojfXZkMHcjw5
	2XT3BUZIK+ze+KC6Dgtm0PFYhYa5rdZNPSG5rlppZoKqAcfp/tzCSuq5nD5bsr15
	vekI1/9vh208hoezzbOp+AnDzJ85eFOzAsWDkO/GLz2W070bQ5sL1XsfaQfVMPcm
	uyyQSEY8nJiGP4A2kvfsJ293a0IThT44VrmuFMdPhJkX/UJbQ/JPIc6MuptSHm3o
	8wuioXgC1oe0K+rDQi4HP4CW1QbR8Itc1HnfWeI3s4kM8yryz8OtjekqyCl9yOQS
	yPhckJj60F+C+R44/GrM1TeqYYAm1Sdgo6xtwsVZOwfZTtbIaRwuuGJenKr+DvsQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bkedt4mck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 06:13:36 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60F64Wro029529;
	Thu, 15 Jan 2026 06:13:36 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bkedt4mcg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 06:13:35 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60F4icPp030146;
	Thu, 15 Jan 2026 06:13:35 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bm3ajx75t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 06:13:35 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60F6DF1Y11207328
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 06:13:15 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3DAA15805A;
	Thu, 15 Jan 2026 06:13:33 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EDC9E5803F;
	Thu, 15 Jan 2026 06:13:27 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (unknown [9.90.171.232])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 15 Jan 2026 06:13:27 +0000 (GMT)
Message-ID: <cc97397d3c75d796ee71081cc842c867a62ce39a.camel@linux.ibm.com>
Subject: Re: [PATCH v18 00/12] Support page table check on PowerPC
From: Andrew Donnellan <ajd@linux.ibm.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
        Pasha Tatashin
	 <pasha.tatashin@soleen.com>
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        Andrew Morton	
 <akpm@linux-foundation.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>, Rohan McLure <rmclure@nvidia.com>,
        Alexandre Ghiti <alex@ghiti.fr>, x86@kernel.org,
        Nicholas Miehlbradt
 <nicholas@linux.ibm.com>,
        Sweet Tea Dorminy	 <sweettea-kernel@dorminy.me>,
        Andrew Donnellan <andrew+kernel@donnellan.id.au>,
        Srish Srinivasan
 <ssrish@linux.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org
Date: Thu, 15 Jan 2026 17:13:26 +1100
In-Reply-To: <b6c39059-faed-41a8-80b2-addaa229c143@kernel.org>
References: 
	<20251219-pgtable_check_v18rebase-v18-0-755bc151a50b@linux.ibm.com>
	 <CA+CK2bBjoQmheEstv1MacGev_srdx=m5v=hwxdyfAKogbpG3FA@mail.gmail.com>
	 <bf0def77b07a34c00928cedb46030ea17be4fceb.camel@linux.ibm.com>
	 <b6c39059-faed-41a8-80b2-addaa229c143@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDAzNSBTYWx0ZWRfX53I7DiMu6h3z
 raXZ/+frnSM8CMCW6s6EycApm3s6hEGJYKo4nVxjhzW2dpvC/SLuvXwOt2bFBxnDU2o8HyeArEP
 KgqH3dyQwLP6m+aU6EMMPgT7xOMlk4XQygjZ3zRSFtE5O3/2hzrHiyzeLjD6xCJngU5YVP1Y2DT
 M4oOYAvD+GbWzvH+yn69QZZex6VaPw03MenupSF6+0KKMyiJMfTGamOtrUz5U5OeL4yE7ACOpax
 1V8Bm9LBMmtQsGTbCTGGGhgIOoJlbp/8o+p+pCMkCtiFQ4KW0rqOTgOdVYjIRjzAS2GCYw4Xb2T
 dYscTh1Jr06MtPwi5UgOTV/7Za1UdB4jl0ciUkhgXmHH2jej+be2xLWsydOaEreH/y8qTjgm1Hd
 6XW+9NYpu5bD/aXhf59z6H/VZnDjoETDJhvhkp2Y6kFxg5AC1B5HfLqjKMyh6ewlpPtTA2XNRZp
 JF93iBCdf7rwfjpdlhg==
X-Proofpoint-GUID: fME1BWB4YoztfUCI-TzSeij8lia_ZbwX
X-Authority-Analysis: v=2.4 cv=WLJyn3sR c=1 sm=1 tr=0 ts=69688590 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=U6BpzXCMtsgkVx3qoqkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: e7mbieSo6rWsEOFCa9zukzvR3P93ImOy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_01,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 malwarescore=0 phishscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2512120000
 definitions=main-2601150035
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7FEC4C0008
X-Rspam-User: 
X-Stat-Signature: ixtdiwxkb5mqmxtzjghspofeebra814z
X-HE-Tag: 1768457622-788105
X-HE-Meta: U2FsdGVkX18HMTs4fSCuT33c5TjaJ7hnAd7xN+hFDUIZrP3Ee4V0kh9YaiJ0nuYlRSdOFw9kN7Rkq9ksHdgqq6aeTWVehjjP94y3bOfFlVyjDC/OTKWd8EtH9TgLfq07kBGWTneHZqzuaYdZmWj5HyAk/Jf+tkDRA4jdPMGDo52xllXyTokoEiju5irDa0vwdai5FpVqyP1z0vGDk0zOhA08fLh2OtWqfBGbxA3Nsw8n5YsOVwSv8mYYzR9pCmGROCm/ZXm0r2JyuGPxT5j0J7Up8o819gqs/udMSWGIlNotKhX9CrZ2di14RuNHCPqBKQgH8Gf9hiu+GiV7oYaa+TTzxae7m521jP63DCa7GX8eDHEW6WoDl/BHmuf/ZCyOolLCrXziMswzMbYA0S8XB6UKLyfoj6wKcjT+evfYJJmQ8i6SUZTgPORnH1mB9EEbLRWvPcsjW8TiAgynaYVGM1cSOqQ+qlDk4GMVNMj8Xx+2QS2w0U0cKjfQQOx9poNHFf79MFNXPHzUkZ7tC7uQf9m6okBB6NIj59hm7JMH1Cway5/iVccuf7EqfcSDx0Sh9PpAQpJsR76zrcTe8GLFVBZAdMh4dfwV9WYI2Bwfeyb9kvlfVtiMJFpQGqyS6JyQTRuawu3vUmXjsR5WY2VZYbO5rj0Lz908lRLz5DFnFDuteWFGrp73P/238yjSAWcstNBz+WfuQUk3/Cx9djILnkj5S7f0w/no5XusfMmizsCoceyaTQCzl3otkw+QwVn9Y8Yvxy38LlZVumOytRF3dIaC4DhXjp+uXb/8Yrnrbvf6eTBjaRfEVdusoX23/fORsoSmg7UuV7hVleRqSfMGxbXoGa/pp3BnzY5XviklPTeX+a9XBBNJZWT3NNjyUINHvDrq3k7bgTBagzV5cm+k31cMRPsQEJtZZ0YXd0U4At1hBcI8oU0G1/c5vKAzKhnYvDRg1WQQUhWm+BNm8ZK
 lzwgBgZy
 EjsgaMPwEBpCyk8MjnGQv71vjdj72Wd8Qr1tmbBXBPkazjFdA5hRo6J0lBm8CqJ5VXZ2JTsNaXaAkqECnRnMkasFZ5kzqqULN1h4gu7cfRNOT4zTCkowyV3o7XymBrXMzhad7+n3gcn0slYmjeIHitsM0DBhew06o1AhQHDktRaPweCAuQ9SqXMtufxHKpUN/Z6S2M8wrdUc4jYLXr/uEj03jDjWSGHWeQwpdwBMekq/4nqp+znqMJcrbvj/j1o9bySDZvQGqFsr7TTmdCWyffwJxabc0xBuZnPDf8W29RTtJQ7JtAu1dM3XL6IEkCo4XyKDoBZHenq0FPBgDWj91OBsz7ep5JQlY0ipiG9JSN7jy/bVwgZ3sq1Pawd6wAvAhTmtT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-01-14 at 10:34 +0100, Christophe Leroy (CS GROUP) wrote:
> What is the merge plan ? I see all powerpc commits are acked by Maddy,=
=20
> will the series be merged by Andrew into the mm tree ?

This is what I was expecting - this revision is rebased on mm-new as it sto=
od
around when I sent it.

--=20
Andrew Donnellan    OzLabs, ADL Canberra
ajd@linux.ibm.com   IBM Australia Limited

