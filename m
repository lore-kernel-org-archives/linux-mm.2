Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D7B1FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 08:45:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 721916B008A; Wed, 29 Apr 2026 04:45:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D26C6B008C; Wed, 29 Apr 2026 04:45:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E8AB6B0092; Wed, 29 Apr 2026 04:45:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F9D56B008A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:45:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0ABE916082B
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:45:15 +0000 (UTC)
X-FDA: 84710959032.21.C4442DC
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6B0D44000A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:45:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=GcziRz1q;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf01.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777452313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n0D3U/J7t15YRpcKF2MF4gghBNWJACV1fjDZAGFeZbM=;
	b=rHdO1t02O+ulv3HfgJC/SCLcJLchPQ6gIA8A3HvGaVNGYVpULzVaLilP//ZJ0P8rzX0bQ7
	t5A2aw9kNce4CNXofR7FrVZRFk30BMYX9vWCmCs1f9XxQqCR846vJZRz9RzepOzKWCHqID
	xRtsSqwfJrPBftQD2+sxLjU7odFx7XE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777452313; a=rsa-sha256;
	cv=none;
	b=aApUCRgLPKt3ySYJLe0Mma1T92Soydwz8HrbHNvrru4dUVspRGk1XCY0IN+wzBLr+vhiKT
	h+ijy5I/0Tw1IzmWx9mAW7dfiI+mlMH1TwwLp0/FeahCILL0hhq46J98sCE/sbB/qfY+H0
	xkKJK9bOMHR9FuQPnqwZH1zuHekN6w4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=GcziRz1q;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf01.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63T8BVxR2955054;
	Wed, 29 Apr 2026 08:45:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=n0D3U/J7t15YRpcKF2MF4gghBNWJAC
	V1fjDZAGFeZbM=; b=GcziRz1qUnKgslNZ/9v1khNBbvBMP53V4FKLKlcNE6MrIw
	x1GO+1N6oPmNOZvLw2J6MY7U79NbiYRpAa4njTXxg7dpp7G2YWs3gz0jHhU084/K
	S3ZN2aIv9RuA1BtcdhIcYhmc9Js+Z4s8kH++kwPir46cLuteUWnOhr81xZAhQZzJ
	iQZi3QFbp9nSajPoZlsVjFuPOvOGfElpXqbIQaX2//PMsmkK8dXNiF9hh/74iJB0
	Y05iJIhlvCvmN2N8XexTcFn2aR6C80zrqSdrmKxLudiQT47QBMgpyvUjHoWJN3tp
	nyCND96dRnbdEjLACVHiL8Q8YiszcDEYdaD9bClQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4drn44spd0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Apr 2026 08:45:08 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63T8cpO1013916;
	Wed, 29 Apr 2026 08:45:06 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ds8avwmkv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Apr 2026 08:45:06 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63T8j2Y242008908
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Apr 2026 08:45:03 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DEBCE20040;
	Wed, 29 Apr 2026 08:45:02 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 283CB20049;
	Wed, 29 Apr 2026 08:45:02 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.87.137.131])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 29 Apr 2026 08:45:02 +0000 (GMT)
Date: Wed, 29 Apr 2026 10:45:00 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/6] s390/mm: Batch PTE updates in lazy MMU mode
Message-ID: <ea51a969-f658-45d3-8b04-11bb4990b617-agordeev@linux.ibm.com>
References: <cover.1776264097.git.agordeev@linux.ibm.com>
 <924c91e711e8b16470eb2af7e31d0b6ffcf2940c.1776264097.git.agordeev@linux.ibm.com>
 <20260423122824.10371E07-hca@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423122824.10371E07-hca@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tUpbnWu9ai9c41_KVdJNahHjQn5z7oOQ
X-Authority-Analysis: v=2.4 cv=Ft81OWrq c=1 sm=1 tr=0 ts=69f1c514 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=nl70jLaCi0zengCn-PYA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: tUpbnWu9ai9c41_KVdJNahHjQn5z7oOQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI5MDA4MiBTYWx0ZWRfX4iXlBQ9L4TSY
 HhPMY7UhZ2R1n/voAZW4ZdeQDFQ/lf5iDAtr0Bt0NQ90HIxgi46cTjTSbxdEk13zMySl8PyaHFx
 qHTF2ysp+XB2nx1ECy764XpH/N0QhIRgtrFmzS8c1qWyMZUdQ3R5vg40G2J8HB/X49ZzhS3mc1f
 LZYf7OPmuRBjlUXtKg4FUBMHc17IusaxW+BLeaZvkhESBmFtznashHAOAxim+YPtFkTVzIRQ8+p
 SaeZ98jHdhahWEYnTuh0KHC22/c8qfFWQK6u1T2Dhm1+gtm6GAq9dDRke/qyWSrINOQfsn9vX0b
 cWuqQE6H2SN1I/yEMQSe8rNjFKys33zRim5WKdsBiK/R25JwsgJNywQOhSXwLUpzrwrS6ay8z2v
 vZi6/Oeh9GkrOHpso+Ls+7omGID93iRDTkmgzIpnZ+dL2OdCzIy5kfDhfjkto7jlaMMjm03xChB
 bSauzcyb8XQzkyGrYmw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_05,2026-04-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0
 clxscore=1015 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604290082
X-Rspam-User: 
X-Rspamd-Queue-Id: 6B0D44000A
X-Rspamd-Server: rspam04
X-Stat-Signature: 7krf1t79f9xgtkmpu3149jnug3fjb53o
X-HE-Tag: 1777452313-586168
X-HE-Meta: U2FsdGVkX1+ZqY7EDRF3yADKdFfBHWxz8Fkqp/4LkdPlqJ5OgEFSJvom6J5k+9GLLIy0Kbv5FsJQdCTl3tfKQ/xFp7ofgCPYJQtvnCiRNSonc7bUtObnkuzK/UMhnqB6tZr5TmeNh8GxflSsfszxYqtr9SOtm4gofP9j8nu2XwMplRY5KkdHNqLipnGp+SS1zjlzA3uMHjkt0w+c+oiju0l/vt174qbU1iyxmp7YtOmhVh5evo+NVSsi6nqMHbwLVQ7CCwRqX4k7ro54M9IHdWPOSblA9xwkJsK/lJhc4LCQ/MLvf+i/yG8yJhnqmcq8AhZuzrI1sXWyC6pzIgq8NTBEsUD66SZyjhLyc5SUyQlEJe3/eeVTnS4mMHCl108S5suz2+zp7K9HA4JvkRBuw/spXFBkRQXVc4iFZ1UxuoMencXHozZE7nn+DVfxP9m5QgT901ArMT56Mk1E8lGXkZghlpPk3UN4WGxT9EInvYUzmmSl4U9gH6FzGsFewL5cKVg5mKrAsv5SBvIknnVid7d+yLLxuRqNZa5yqxXHIN2SvpfIFpch7OSALJYoNfgBPphLMWiYjsfbGxp8n8c/Re+ITNZCkCM0g0ZxNUhDKGnrk/T3t5VSwIej+x5cpIpqEV6ofpYJwlGHII7WUYnOsFy7oNm2/r4m6QoOnUPEWaJV9vLNCWbRsqrnpy9YrK5mXZS/szzSTxSe+FRzwQTJ5FA7Z3GZY/V1q+GPLhPghbmK8GWQNBTIzIcZ3TRXDfjQsDPZx3RbgpwRvx4FR0x9qVw8UjoB7fqr6j+tvy8KCGKr1S+Ka57xrjK6pG6dB5qiXfGcWsCcEyntMEOQ7tVDTj8VrQD3E686ewGOJOcmf95ts8nZEAUu0RyGVrQAui7dP31Qx3R+E2cg8LSUNfsGLYwm+UPsOjUqfOopPo51DfIovX+DLH67WjmarEWZV+oqzSCeLXtFaNfV+7Vxx0i
 U15ebfDf
 86oEiAvnFfEWirdiVdPydmcGZI/tNZERqg6cbaL8bBIy7P11J2syqMTbT3SMFc2pMtt1Q3iuxjPOx1dphjd5/Njt9eAQspxyIxhwuSFUrvaqjTJZ3BFvp2gCUciHHYxf5oLaFl9bMVWO2HWwjZqzcs2lgxWXAkPacXJ29f21fe1gfCcDM73K1cpvh9iMH50X8MFHSzpbY3yOL9kbJoVNS+InzYuFBryDHXwc0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 02:28:24PM +0200, Heiko Carstens wrote:
> > With this change, the system calls do:
> > 
> >     lazy_mmu_mode_enable_pte()
> >     ...
> >     <store new PTE values in the per-CPU cache>
> >     ...
> >     lazy_mmu_mode_disable()	// apply cache with one multi-IPTE
> 
> I think what is not necessarily immediately obvious: this approach must assure
> that within such a lazy mmu section there is not a single occurrence of code
> which doesn't use the above mentioned modified primitives to dereference page
> table entry pointers.

So ideally I would do something like __private for pte_t, but I did not
manage to circumvent sparse false positives neither with a scalar pte_t,
nor with a struct. It is as well-known sparse limitation, if I am not
mistaken.

> Directly dereferencing such pointers would bypass the cache and lead to
> incorrect results. Therefore we do need some mechanism which makes sure this
> cannot happen. Preferebly that would happen at compile time with static code
> analysis. Alternatively your Kasan implementation would be helpful to find
> something like that after-the-fact.

So it appears the only solution ;(

> However in any case we need something to address this problem.

Thanks!

