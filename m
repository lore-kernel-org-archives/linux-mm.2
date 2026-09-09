Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54F4AC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 15:56:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 530506B0092; Wed,  9 Sep 2026 11:56:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5001A6B00A3; Wed,  9 Sep 2026 11:56:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 418986B00A4; Wed,  9 Sep 2026 11:56:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1390D6B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:56:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B1CA040268
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:56:09 +0000 (UTC)
X-FDA: 85194675258.20.4F2A561
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3935CA0004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:56:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FMssZj3I;
	spf=pass (imf25.hostedemail.com: domain of rnsastry@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=rnsastry@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788969367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sce/uztndfW37P8gMF0nv16T+Mi/jlJMpTVKgOTFgZ8=;
	b=B4EkSq6F2ltAgV0a3fIGBDjprlnwS1KdKFFLATpUCRu2eIg+aU00rvnldUPfe4/gE7c3/3
	BIGxb5z5xd0jqtQq1NKl3KbXsrfW4LtXAOVM3XgimTbrFTWDmZW17kffnlXob+ZT41KJE7
	LbgrIU57w4KPImvGD1/zPkHA/9cKzo8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FMssZj3I;
	spf=pass (imf25.hostedemail.com: domain of rnsastry@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=rnsastry@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788969367;
	b=vzkfVcVA+tfn5WdLdV/ERkzR6kiNtLczSVVFh8sCSwDaU2leTljqjDlmQPeOAsI4yppKQJ
	arV1T2d5wYVFX/Y4QMm7O38f8ncXmosUMH78OHKSnYNm1C4fN7lLrTY3WLVJxmWPK4PTOa
	FNwUGnM3+kmvJ9pRjO/Tr262v4jwx5U=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689B1X1I1930784;
	Wed, 9 Sep 2026 15:55:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Sce/uz
	tndfW37P8gMF0nv16T+Mi/jlJMpTVKgOTFgZ8=; b=FMssZj3IdgEr2/3P4E5aFT
	G/jY2NoyLN15GmeQGIPLXl42wf0vweP3NURUSD4zuolrtYCselLgmA78PMhoirxg
	C7SbXE3z8lHF1krIOuKM4PPfFf98LVIzwK5lnCh5k8IduJ8+RLDyG5yIAXpWdVSA
	BiYCPnjjgr4XWNqPl2l52MLk6A/89kmgVbaIazSJisYjkKu5Wj7RpbRPmiv290DZ
	X5nIZRAd3soSWdaC9PhjqCZBC5j7bPN/ocYVusWolfL/Vri2JTYEeIxc1DOybeKV
	JImraHUIfMzhcwnd9HGkL9137qoOhUzv7sz/6Yo3DcPPnFc8kk/kryWA63dTkhnQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbqk6w0t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 15:55:58 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 689FfELl030398;
	Wed, 9 Sep 2026 15:55:57 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ggwdqk9fw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 15:55:57 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 689FttaS50266558
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 9 Sep 2026 15:55:55 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C91912004D;
	Wed,  9 Sep 2026 15:55:55 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D123D20043;
	Wed,  9 Sep 2026 15:55:45 +0000 (GMT)
Received: from [9.61.255.18] (unknown [9.61.255.18])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  9 Sep 2026 15:55:45 +0000 (GMT)
Message-ID: <1aa7922b-b4df-41cb-ae68-b30911d79fc6@linux.ibm.com>
Date: Wed, 9 Sep 2026 21:25:41 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/22] coredump: pin the protocol struct sizes
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>,
        Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Omar Sandoval <osandov@osandov.com>, Jacob Lalonde <jalalonde@fb.com>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
References: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
 <20260820-work-coredump-sparse-v2-7-ba32dd718c51@kernel.org>
Content-Language: en-US
From: R Nageswara Sastry <rnsastry@linux.ibm.com>
In-Reply-To: <20260820-work-coredump-sparse-v2-7-ba32dd718c51@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: jfK6QYX9rSz6AehGyXgypsfX2jEJ0xhI
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDE3MyBTYWx0ZWRfX7eAvsE81oftc
 zK6QGa5PMW9YkjCKbKX6bnd4WQe1Dfgd/KBuLDH6DSybe0Jitudak0US/Q35TpvkAOqdqS2hjs/
 7Hf+CR4Po8sth87TH3OciUQCexanZHA=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDE3MyBTYWx0ZWRfX5Jc2pZn8f4jG
 OYsJftEzQC+7CqQ2Vz6n/5+oOo2Yp6E8xNL31UjT6JONSsP5Z53VtL3hxPmfp+ERmiSilRI8WqA
 rSDypCf1bZZnjqmuWUdh/oRC+J5S7FKMcqoPNr+IeX2eu+aHlnh4GPIscQBxr9taZhDXlna9XNc
 EYMUHZ9F4k0rEbqCTk6aMB0/P1j1sbbv05Qa/DMCEjWrVmrLyjUO7IjMxVERw/hPqCriJKFy1qA
 oLKSnR9TvfD2iYXLwr5g4Iz/vn1GM3AwynlO4U1AhehL/Q2W1b+BBdzIkxM4RsJAmUydLXZBJ9W
 n7ckitFWYUOPG4+sR2YyQbDQUUSuCrWqqzWKQSj982t68HCtaTlzkSnAEg4hBijCw8MZ0oSHEQR
 TrA+rsICd7jKHEJi9PRodAFNzffsYmd65Sfg418aTtcu3q2wIJicVA3ix6YhcLEFtRXAiYFaXwK
 W18BlXYHdm8Fhw+T8Jw==
X-Authority-Analysis: v=2.4 cv=JaKMa0KV c=1 sm=1 tr=0 ts=6aa1818f cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=NJxpvL3WiEoOf_JFIIQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 08QPXMT9X_k5Ehc6UCPAmMY1r5Km4PMe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090173
X-Rspam-User: 
X-Stat-Signature: a43ziun6qqeka8fttnp4tkdk9ymsisob
X-Rspamd-Queue-Id: 3935CA0004
X-Rspamd-Server: rspam07
X-HE-Tag: 1788969366-598704
X-HE-Meta: U2FsdGVkX1+xFLI5xYNzCyzU73WA7bUmeiTZhK/+QkVjW40JOH7kIzqxqMtNXMuRdPan0VVpK7LV2H+sjtMcX2dcACp2yaSJiQRWclf4vrXNtLeOfSlUFukSX3VYzHqXdu63qFYVDkPLr3K7liAyySnV6DSvLph5fRm5fNKPng+I0qL2+nYapnyFXEyJuVu7Q/WytUYPDyUBzLmies5zzAZK4QyREjV0Np037n8Lxsvf1U8Ot0MsuQk+EDOnhobw6DW4gqak8RupMjaold/te2ZZidPBkp84Td+STyZrrOkOdiQ2GJbhX61uHV7CMMFUac5Hq/T5q8BT1UiEuyziu/2QYRzP2Sbwbqt5rsSgFAXppoxX/JFwVE2f9gmvcf/ORA4NQlL9SxYJmb9HUneJwyXp1PZtbVDyip5YqWijRFuUh/It3/fc7vWRMR6DSOKrCCTXRGX020O9AJh6yXlWjZjVAph6xNMy+4K2zD9MAgQ02qksj6AKYqbCZRZQX/aVNTwHN2K6U8+w41zW4TCA50ywXCa8TdB2/3wQBJ67BCc3eLJ+1LsFebMbmv9tuRWJnKZ7w3AI7bBW4IOJYGBEOo5x9PU/Gk4wOjmfkM+MiIjTdxdJpEnXC/RzrKecKPpffXKfPinDohtO8bLJ15sz8iEbhJGdT3p/FrRG3Nt96dMDLbNLqAVlrFQyhkK+pEjlncThZ8ygbkE3kb3DubWuSijxFirH7vAFE02AuqqdlTTL7HjBxg+SxioAbmJLd5rUb9ECmwQpkd7bsw+7s0IIu2fIEKY9upCQCRS7kV73qakcsLk592I4cDhPTBaSHEw7u6EzDDDiZlOlWmugyMQlTJmiAR6deTRcss9SZfdG3SfC8wifwEEg8yoAvjiHQlfr7ouFzjUao6PulrRM+47/rr7E+fVNB42lTg/5vg6HiqoBRHqVY5g6dQlUDvDsCgRWlcrOv4s9qnvvjlB/qcq
 TuZ/kNSh
 99EZznRIjlTsELBspY70RtKQ786Sd1Uq1swZBbu8/5/bdeH9ob9ww6uYb9FQHm4eq/jWKI0Iltti27ER48nbWbG3akAQNGR79MCLjqwMzwDZHsTuaPd0jea4WX6eqGpK5blXzq5a3MvFCHgNPf5VLgkgbfutmq/FLfRhXisCwn6T1tkHuodMbEMoV/YU0DoVQwDABXyKubdhXcg/Dgy799U9rN2r+53ZtjTZW1j5SGck3DktB/TWAPG1lJU/4+9QMq/CoYcNFvh2yJSy/m7KKHSBUKVHedvP+rVhFfAuZv14rdc5wxMGGfMnyygNbSQ+kB+RDUD6mwogYYxx9SKz07Qdmw4iduwh7eHiGbGDWrkkGTHxYYNsNHCBL8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 20.08.2026 4:39 AM, Christian Brauner wrote:
> COREDUMP_REQ_SIZE_VER0 and COREDUMP_ACK_SIZE_VER0 define the initial
> struct sizes.
>
> Assert that both published sizes still match their structs. While at it
> fix some issues with docs.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>

System: ppc64le LPAR (IBM POWER), Linux 7.3-rc2
> ---
>   fs/coredump.c                 | 2 ++
>   include/uapi/linux/coredump.h | 4 ++--
>   2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/coredump.c b/fs/coredump.c
> index 24a6405ea242..c696b46c97ff 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -759,6 +759,8 @@ static inline bool coredump_sock_send(struct file *file, struct coredump_req *re
>   	return ret == sizeof(*req);
>   }
>   
> +static_assert(sizeof(struct coredump_req) == COREDUMP_REQ_SIZE_VER0);
> +static_assert(sizeof(struct coredump_ack) == COREDUMP_ACK_SIZE_VER0);
>   static_assert(sizeof(enum coredump_mark) == sizeof(__u32));
>   
>   static inline bool coredump_sock_mark(struct file *file, enum coredump_mark mark)
> diff --git a/include/uapi/linux/coredump.h b/include/uapi/linux/coredump.h
> index dc3789b78af0..662e0468da6e 100644
> --- a/include/uapi/linux/coredump.h
> +++ b/include/uapi/linux/coredump.h
> @@ -30,11 +30,11 @@ enum {
>    * member is set to the size of struct coredump_req and provides a hint
>    * to userspace how much data can be read. Userspace may use MSG_PEEK to
>    * peek the size of struct coredump_req and then choose to consume it in
> - * one go. Userspace may also simply read a COREDUMP_ACK_SIZE_VER0
> + * one go. Userspace may also simply read a COREDUMP_REQ_SIZE_VER0
>    * request. If the size the kernel sends is larger userspace simply
>    * discards any remaining data.
>    *
> - * The coredump_req->mask member is set to the currently know features.
> + * The coredump_req->mask member is set to the currently known features.
>    * Userspace may only set coredump_ack->mask to the bits raised by the
>    * kernel in coredump_req->mask.
>    *
>
-- 
Thanks and Regards
R.Nageswara Sastry


