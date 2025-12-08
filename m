Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B64FFD2CE17
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 03:11:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BC9E6B0007; Sun,  7 Dec 2025 22:11:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26CE76B0008; Sun,  7 Dec 2025 22:11:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 135D76B000A; Sun,  7 Dec 2025 22:11:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0360D6B0007
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 22:11:38 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CCA7D16038D
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 03:11:37 +0000 (UTC)
X-FDA: 84194828634.12.5E11ED3
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf04.hostedemail.com (Postfix) with ESMTP id F278E40002
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 03:11:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=fb.com header.s=s2048-2025-q2 header.b=hqaPaYjA;
	spf=pass (imf04.hostedemail.com: domain of "prvs=84371f8181=amastro@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=84371f8181=amastro@meta.com";
	dmarc=pass (policy=reject) header.from=fb.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765163496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vd6Iz1i7itJ92zcgMPFF3i5AUH9Px70FcbBba7Gfk6M=;
	b=eCqSUUWS+QfPgKg1L0c+CCKl0vYReODVfIaQ645rBGR5qJJYjxbRuE2CHJjqA6QTfD5XRm
	GoRnsdn4aF+DNOPtfNNzrQ8Ji3wIRLVpSy2vJQOEKdz2Xq8xy5WxTAl6pdtXhPsii/Dt2B
	LN6AJYAONuKRHD331W80qYhiyHsCs5w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765163496; a=rsa-sha256;
	cv=none;
	b=tBeWSd5462GaBB6j5JMnzImu3/xL/XtaXRmSDZmSffHHtp1OS2vXN1MOsM/sWtTBbruirw
	UjgoLheyGD9ZmqPSp8FsPqpjjRFWoDJD1AgVwyoueaFrUB0xj3PZvI1diwDVeLAfj8bzB7
	x+oYGsbQWEO5RXP4Pv7Ck3HtFiTCHck=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=fb.com header.s=s2048-2025-q2 header.b=hqaPaYjA;
	spf=pass (imf04.hostedemail.com: domain of "prvs=84371f8181=amastro@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=84371f8181=amastro@meta.com";
	dmarc=pass (policy=reject) header.from=fb.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B7NFkRA217946;
	Sun, 7 Dec 2025 19:11:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=Vd6Iz1i7itJ92zcgMPFF
	3i5AUH9Px70FcbBba7Gfk6M=; b=hqaPaYjAlt9ijhOTPQmQOTzQj2qeNXJost3q
	DWaewwUgsDwIXC70YkMc5vZywxyQN0xQD86SElBn4yASIJ8WF57OIOUvVH6QJ1x7
	Vl/SDrGoD9IngZwCcS6Cxxp52ACtYW2WQHLtPAxnhgaw/m/kY2LlZc25fgks8YR3
	gm/RDHmQ9Su5vI0mbZJ5ilGszdfwRPGbEjiCZDJaueckzMrSPUoh7902mxi6pj7o
	+MBNXQEodgp/gc9RrzVNUlj4+pbHwGAtx+FTgBk2jnvau3lpocBy5nOEL981sz+g
	JJI3ORqZpPjkk0q04u0KWOfhzWkMdvj+vFAJ52/rP5VMe5aiFA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4avhd5784v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 07 Dec 2025 19:11:32 -0800 (PST)
Received: from devgpu015.cco6.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Mon, 8 Dec 2025 03:11:30 +0000
Date: Sun, 7 Dec 2025 19:11:25 -0800
From: Alex Mastro <amastro@fb.com>
To: Peter Xu <peterx@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
        Nico Pache
	<npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
        David Hildenbrand
	<david@redhat.com>,
        Alex Williamson <alex@shazbot.org>, Zhi Wang
	<zhiw@nvidia.com>,
        David Laight <david.laight.linux@gmail.com>,
        Yi Liu
	<yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
        Kevin Tian
	<kevin.tian@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 4/4] vfio-pci: Best-effort huge pfnmaps with
 !MAP_FIXED mappings
Message-ID: <aTZB3VFArpJJMKMN@devgpu015.cco6.facebook.com>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-5-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251204151003.171039-5-peterx@redhat.com>
X-Originating-IP: [2620:10d:c0a8:1b::30]
X-Authority-Analysis: v=2.4 cv=ZIPaWH7b c=1 sm=1 tr=0 ts=693641e4 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=kj9zAlcOel0A:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=cCa_CVtDXYSc011Sr6sA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: i1OkR2zPIMdJjvRRdpVqF_xjZi1juKv5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA4MDAyNSBTYWx0ZWRfX5nK+Tc/ZJJsi
 QhadGeGPvSVp4T22yoZpnRWgwVPvXIObvTMLv/q5HpmzEZ9aAbwzhIqHBWCp/QIGaBmDfuJref1
 M6e9US7i0Zap/5ba16bT8drdORPBRsp/ijkfkWcc5kVe+sQuSyp7A2LKKuSfwpcSCuVawQq5MCa
 cwnUKALCjyJ+dSlOXUDnI0/jANwfFjarErArnOQO+TLf/kOmDc7ARoHladPfiZz9rdvpcCR0lGM
 lvnPrmVJVz7jIL8OOrcfy903DNdunbEWn4fshx8Rmr/ZQElJ2wr4+QiixNQwJlbQizQVabQdg64
 giEypRJBLACssjRlqeyqwLJxcAO8c5eg5pui/UiNtIPW1Cq0pRmmM5URPCRLBA+7C8j680Pqthb
 GPfaVMG4dr5wOYy0nxktuOJmRrneUQ==
X-Proofpoint-ORIG-GUID: i1OkR2zPIMdJjvRRdpVqF_xjZi1juKv5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-06_02,2025-12-04_04,2025-10-01_01
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F278E40002
X-Stat-Signature: 8njr9x7gshh7qr9qo4fporrwi8txwfbg
X-Rspam-User: 
X-HE-Tag: 1765163495-394229
X-HE-Meta: U2FsdGVkX19aJKFy42/c2lJL5x3zS96tnLlvh8I5st26Y37czn1S0uUaZ3VO94bpSHqj3AatFc33AHsb43ncT7rUuJq5SNubvMxndIMPe3Jb8Cvnuxl1l2BxO+LOCKSdEB+JtIiuAf0P24Qm6pNdwdBLYZTyBylVTthgINOxdj+mjGiyfbjcueQebGHPhR1/BthBysE+ePRgnCMD0nfdKLeqrE85Axgd5Qc2hR4zk7AeVaaD6HyPuGlKkUwNFHoS2R8r3plbS1qpVAg5IF8jcSEf+UmwRmK0Z8OqDFXtd1n3JL4nJQivHMwWyRdMjQKb8rv6QYaRgGBlqskPCm/549WTYPUIC415ybfuyuN0sYrDsWRxyGvC1duyUF3yxJ2B2MQwzWECPuDzp1GYrZ5z6Da6yGthqe+7ByMPHvkB8eJ4WF+/gz91gMOEZ4FRkJHteuKaWaG9p/vgI1W5w5GdZ6zuhwNy9jFjemCL74LwHKpLS4eBtGNwu4z+W+1WdMHBzQ72wfsXDnMkTCkzgqq44nJa6mneGCs202JYC1KC7Q1pk6r3iLBYigHWFBig5Ec1aJJvoZswSV1v14Pi09yqyJIxlbJt3GnESOirDJClIZKqmpOe+FH2sPvXLGlvl4kB9V01yFEWncc+pFDL6EZavtl5JNeIcQ96HmjKemDOR1SMKnWJgc6Bc2d1Vpv12rq9XiFNQD+f5ZNLiQzIpMs7xRrRGaLPbovmlt9fpBvb63K05IADlNhevCiJUMn9SVnBkvsy+YtpbLlL7xVYCvEZWUMHhSgROXwSQfAzyt/QsJUST2CYqpYyDeKR6N/mmD4wpXN45ZxmdSIEK4+cucdjDOOmOavWYWWZmewxkbwxSGEcIo4TrDhlnou3BmEjaiVt8brwZVAbxaCzpKS3zmDJLV80splt7HxBCTyOhCrA9zOPp0pfvRAsQDHKem+txNnqEcz3moEceSufwjE2jNo
 Ic8EBpjd
 j4x1OlKp+Ks6uouYX+a3S/MssStAuNAciss/dMr0pTWkGaDJYYj6bpmskGE0s9/nePt34ezzCnZvV8xfeXHI12DJ7KpnnwzRTT7FOTSvvj2e3WPYbsfBIpofe3FTnPkmK4c/6Ku1aNJweh6bzqNASutvDDgvlYEBjyueZy26z8WrDIpBuWsw/Y4vDP6PaJ9iRu9LHNy2SE+zdnD71Yxp3I+vZD0HzPjfklqkqM9qBnZ6wY27OcUL+gcOokwP6hcR0UtQN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 04, 2025 at 10:10:03AM -0500, Peter Xu wrote:
> To achieve that, a custom vfio_device's get_mapping_hint() for vfio-pci
> devices is needed.

nit get_mapping_order() 

