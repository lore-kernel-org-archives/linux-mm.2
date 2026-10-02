Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 051C5CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 12:30:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC4B86B008C; Fri,  2 Oct 2026 08:30:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9BB76B0092; Fri,  2 Oct 2026 08:30:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB13F6B0095; Fri,  2 Oct 2026 08:30:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9210A6B008C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:30:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8E22D803B8
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:30:18 +0000 (UTC)
X-FDA: 85277618916.19.EBD43FE
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf15.hostedemail.com (Postfix) with ESMTP id 43D52A000B
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:30:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=LQ5CCHzE;
	spf=pass (imf15.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790944216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IP27naQafRFCKtnaqP+3h06dyv/hh8blkMGpcdoNUOU=;
	b=hT6f4yxfnngiF5GlW+radJtcVR9RFgnNwY1atUoX7DivFaugFBsMoRAD1xfCzsQrG1a/xe
	LrNZi22Ouj0sxApdCrMD/5gqdNERbG/5my43YxanbYZckTYFged1030w3JozXivAHLwfAo
	O75nyNrN2xd67/H7YZnBVRXTa2KRN4U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=LQ5CCHzE;
	spf=pass (imf15.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790944216;
	b=o5lzP0wb9AqlMMrHlI8axT8qRFLabDT/Hm29xwOddXxHouk2DAwrgoX+XBdOB33w7mc8HO
	rZrXuzV2bEw2Lk4uPBl4LvOiKl6p4jInPYo4WDjxVUeUl+t57QbG3FihXZ37D/LUZnyNJ3
	V194bzBrInwKNFiPgqjkNvd4sCPJDP8=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 692A5qvH3160566;
	Fri, 2 Oct 2026 12:30:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=IP27naQafRFCKtnaqP+3h06dyv/hh8
	blkMGpcdoNUOU=; b=LQ5CCHzEh+C9pXlrzsU91wxcGH+5ulrz+T3oBgGeINR2v5
	PYOeg1RjGaf5tauFUaKf7k0lf+anKpKvW3S4r8PtjtCmXxwKgL4525X+j8n36LRk
	aEe1rGCfr6ugq+ta8QYc87pog0VCOzP/vRP6QGVwpWq8BvEC2NAuxPxdmCRHJgq7
	nrE4SxzXcWBPvVBdiJX7CUpresCdvvwxvX6htv3AvejyPwyvXu9CELLpJ0aF5ZIt
	K1kQP3FQ8g1xfH8ecFibkwKDFoBZmxUUuvU0xxaiIrjOEoyIy6Cw2BBFWD5iAsjs
	oCR+ITwQYhTZAiW1/lNss3OeGH9cHmH89BkOLOHg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx4feqtkd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 02 Oct 2026 12:30:14 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 692A2Tcl2335439;
	Fri, 2 Oct 2026 12:30:13 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h0xcsjreg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Oct 2026 12:30:13 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 692CU9Wf28508718
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 2 Oct 2026 12:30:09 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AF20D20043;
	Fri,  2 Oct 2026 12:30:09 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 895CE20040;
	Fri,  2 Oct 2026 12:30:09 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.224.92.206])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  2 Oct 2026 12:30:09 +0000 (GMT)
Date: Fri, 2 Oct 2026 14:30:08 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com
Subject: Re: [PATCH v7 2/4] s390/mm: Batch PTE updates in lazy MMU mode
Message-ID: <4ee1e4e6-4ecb-4fec-a481-c4f2236eb514-agordeev@linux.ibm.com>
References: <cover.1786956464.git.agordeev@linux.ibm.com>
 <d7fd78377a7278108ef501cf76571e80caef5968.1786956464.git.agordeev@linux.ibm.com>
 <20260824104048.11040Cdc-hca@linux.ibm.com>
 <b66a61a4-a532-44ba-a1c6-26f02193fb05-agordeev@linux.ibm.com>
 <20261001082143.23106A21-hca@linux.ibm.com>
 <15c64970-d54e-4b8f-96f6-50c021079a94-agordeev@linux.ibm.com>
 <20261001154117.23106Da3-hca@linux.ibm.com>
 <20261002084315.21787Ba6-hca@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002084315.21787Ba6-hca@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=FYWiV5+6 c=1 sm=1 tr=0 ts=6abfa3d6 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=bLWW0i0dwBbJnIBF-2cA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAyMDA0OCBTYWx0ZWRfX7RnYetFSSEIx
 wpqVm/IrnUEY5C2fgABcIk9Te7ob3SotikBDvg1coinJOCfv9Qfvpd8lURzGrP8WrGcYNa+j7qf
 FVGPvEwbxl2r/Q9iA6mmrjzoIhmRKmk=
X-Proofpoint-ORIG-GUID: xHiclTGYKBP7O7nDjmVOh4hlN__ELI1l
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAyMDA0OCBTYWx0ZWRfXwytMGQg8vIEM
 4yip4Bs04yYfo9INyCYwKPcTh3piGH9HIpegL9lSdM4BaKOb62tPPWSh+vdNbHdB7AL+JeQXOTL
 ZNd+XAeW7L0zc0c5EnwMYwv9OA/SOEteRm0QXv+GxoeaN8RQ5XqOD9C0NxP4iRS7BJvFQ1fiqhq
 6/+aguB8WZHSp+gsUDn3nRFhYmb1uGWA/RTxiR1oyDs1T8J7MuUI8DzF+9paUEovig7Q69KELEQ
 bzAKzyPk9IVX0+c7Kcl6QapmwqP0tcOwLHepzmsN7gWk3kSRN3WMc9iAwFyTLiFdwHa/V7yemOU
 7K/bLhEdqtuAgdJ8nHaFp3+85DI3zT0spApuzkFLqBB1knFeYOzjGSMTbxjGteFk4O2Ff8nMFc4
 VQ+AxVIKac+GwJvOOeeiaxIGCDO6RN/O9N3xi0y+MvHFP2jWIoghOj0fIyoV3QgH/8Ftmvpq8Jo
 0OcIqn6F8xa9NiDobBA==
X-Proofpoint-GUID: pWRTe5PpEKDMeNbbBBdXZ2uzDWYlbNeM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-02_03,2026-10-01_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 impostorscore=0 spamscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2610020048
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 43D52A000B
X-Stat-Signature: spseiuyu43wqt3mewhr5ebzd79q9q6ro
X-Rspam-User: 
X-HE-Tag: 1790944216-695711
X-HE-Meta: U2FsdGVkX19ok4vipAuL1xl/7ZtRlPmRc0melITkJ2H6IB8svnfvQcGyxFPzXnFM9F/CAtwcedsdqmft3sgKjPWPJKsc5quIYAdxh/PyASeChvcbPb52HVFO5Z0b5WfV5mcZ6QPCEVE7pXTQyDBEfFazC+BxqevZM9APx+CX3Y62UOhOF9pvljk0eqiiSXKfzzfUuHJP9lCUV6tUGj/U4LdMD2u/3S1jmTPRADTgOmMWyxdNOeYgcSa71So6xT6YOo+wqyPHcKGxL9TtLt/6UECxr7rOjRtW6WVz8HeoxN7x9Om4BIF5TMhL6JfS0vWqYVaSOI4fXt5f42ssbACFPri3Tt0fBVjNvupYrl/ROlLzRrcR3YfbCtlazD2LcGbXnIwgZIJ6pPLDbMV94GtkD263YY5dgOpYXbA8PbFs+wYRUpCcSxDSfAqOe1NLnbFUyl5NhIoRPxpNGEvBiZcH7Xm2JNdcDMMRqUghOL6B8OCjnwVCo9MfnG7kwwz9HNEjYkabA5XAtiK2T0aLEDwIJEuS3AIy6jVNtMho2vxHyjgKAN738gyB6pG9Ac8D/wYwu1PWbp999vdgt5LZlPeImL8KNiYjO9ptuhHARB9mVJdinhDA0QiDZNjPkJcbhVInXmSEE1LEie/MJof8xFaGPyi1LRIh1rxAHxwngzhNmVvRhlv1Dn9MXix7+vQ1Ax2vbI6aKuBLUF9GtGCZC2jmieFZOvFmOWnL7rZiIIAwoECwWYglO5lfQSdfMyAu3eP81EH3Xzz/z7941oSNVuhvz3cupEw/NqQ0kgG57kiCgNf61JeA+W1e4Qb9+vHunKCaXqnusNWrUVsiNlJHPpg6MUftW68aWAx0rTlTKx7iFhcDbcyC9043OFKfKgFosr17vvO/ZRGJmrKrwLEf7UWbkEyIwpQcDpM1zZBQ+lblWv4e0NnCsrGfIMEsL4HFbj4tgTfrV4IiOZ0iInU2FcJ
 ThkWiBvy
 4VFtz6Gq1ZO5JrXR1wUwKmPCck6Iq68y7fWBfnpVzx1Bduas2ivEa/01BRIDZ4Gk1onpFbKTCwfPI96WgImHN15328fkLaknldy3IZRLBmqHGRP28xc6U0T3TonN+XS85mJBKJvWaLNTBmsE1OUv4uAegvB1+imy2LlNDA5+H++9AmKwjqghMkuanf4ylSTeb86vldvyw0u1qjIOmJniJCLfkK2TwYDS0HxuFcCPu9en2frXE+C7jUExf/exLixBa1Awijma50U/Jq6PD7i40t1aaOQoBKIyma66URUTjYp2cDVQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 10:43:15AM +0200, Heiko Carstens wrote:
> > > Good point. But still, do you think it worth dropping the KASAN check?
> > 
> > KASAN check for lowcore? I don't think we care - this is initialized to zero
> > anyway, so what could go wrong? Also given how frequently these operations are
> > used, yes, please drop KASAN checks.
> 
> Of course you could still add an explicit KASAN/KCSAN check by adding an
> instrument_read() call (see e.g. s390's fpu-insn.h, which has plenty of them).
> 
> But why do you think that would be helpful for a lowcore field, where it is
> known that is initialized to zero? What am I missing?

Nothing. I am going to adopt all your suggestions into the new version.

Thanks!

