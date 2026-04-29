Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84560FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 05:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E31766B008C; Wed, 29 Apr 2026 01:25:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBB596B0092; Wed, 29 Apr 2026 01:25:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C82BF6B0093; Wed, 29 Apr 2026 01:25:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B11496B008C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 01:25:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CA1E114165D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 05:17:30 +0000 (UTC)
X-FDA: 84710435460.21.623998F
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4BB60A0008
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 05:17:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="iIH/qVre";
	spf=pass (imf15.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777439848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UUspB+lESn2oCZh2aN+BsumVLW77Ncgq+i+bTh0emak=;
	b=gPF4NThVXD8cqWu4jOQRw877jDbq10rCEEo6JZzfd4drUcJzK5pvjHmrvX+5KsPXO8FXEP
	2WPqwpeSDkKYV1QedBZI6kXeo/khbW91kMd671uPBzSQd6QwANL3cVRwMngfb4fNOlZbsQ
	jnAquelK82CDCr0MTom5a12iNYNybT4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777439848; a=rsa-sha256;
	cv=none;
	b=dooScvK86BPZPzCpsxMQndY19nWrs1VXfv3M8tm4SHjNZqqg7/XGrn8KUcctmCcanvUkNv
	AXr72I2RqMKQ0cPhE8InjzHbUiMdKNg1fT0IX8fF5lwiNnM5k67tMXNZCebE/Jpz2E/pS2
	IIeJhaGT+DusdOf0nnzT1oRuJfxM1EA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="iIH/qVre";
	spf=pass (imf15.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63SIQPfu2931477;
	Wed, 29 Apr 2026 05:17:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=UUspB+lESn2oCZh2aN+BsumVLW77Nc
	gq+i+bTh0emak=; b=iIH/qVreUHXN8uZfx1p5v+TpkbgQHBSDwvKO4dO2Ojp3rA
	bPdGOP8eFXpmv/xpW/nidEgNIOHX+0RaAW7W4hSYEc4pKouvtIUHCTB4mUCe/2vX
	56t6cBFqukAQyLwUiyugHpd0zJ82i9wxVWtLAcQnTv8yzXgX6XRyZ3edWj6XsqAC
	E6XdKj9VdNgadncX4f/E1cSNfa0752iSp5jO+Xi4yzs44qxvaFmPvpMNtcQgV3VL
	l7KE+or5wxAXC9TgPNAH5oMLv1qz2hOFF8hWDtdkxqM4wEp6TYO54P1iOmnHtKwO
	lBNiJXIyTfJGgC7OEw0Sc3VNTRdD2cXlWI12OsaQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4drn44ry9y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Apr 2026 05:17:21 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63T58k7H019335;
	Wed, 29 Apr 2026 05:17:20 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ds8xk4xjg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Apr 2026 05:17:20 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63T5HGeF31261020
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Apr 2026 05:17:17 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CFEDF2004F;
	Wed, 29 Apr 2026 05:17:16 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2F11D2004B;
	Wed, 29 Apr 2026 05:17:16 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.87.137.131])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 29 Apr 2026 05:17:16 +0000 (GMT)
Date: Wed, 29 Apr 2026 07:17:14 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH v2] mm/gup: cleanup pgtable entry accessors
Message-ID: <3faf45f0-30f5-4a11-850e-3e5ed7668c72-agordeev@linux.ibm.com>
References: <20260421051754.1691221-1-agordeev@linux.ibm.com>
 <5f45cc59-d71f-409c-8cfb-6eba23b0a447@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f45cc59-d71f-409c-8cfb-6eba23b0a447@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -jsekM2twbOwTE1FFA270frnhpVV5cIB
X-Authority-Analysis: v=2.4 cv=Ft81OWrq c=1 sm=1 tr=0 ts=69f19461 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=MZt8_KVsnJdHBUldAIAA:9
 a=CjuIK1q_8ugA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-GUID: -jsekM2twbOwTE1FFA270frnhpVV5cIB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI5MDA0MyBTYWx0ZWRfX7t7mFOM7Kse7
 YWScEjxMJiIMja7fgwtbQizA1HCX1GaR+8WaaDtXna1NOxK4feoijHVQSB4cQpi1V2q4tb7BoKZ
 HBQvwT3gSIEWVHiklMC0/2BgRSBBpBoY/jQR9XktMnm93Qd4Tj+okplZ0rssJZ8/jqFeviPBSfv
 j66Z/IQDGjJYAONW7P5NH9QyCo12BzhKLVeDIl1NsqyRv6IUJKY4W+tvI7r1i4xzXujsiCd7i+B
 V+2lFXo0PGzzSGauGGoU+8zum1aY23qBZtNgWSVRWjwqTT+i6agPKYoGJrE+C7EFJVqlTO91C4F
 6jBTGzf4vWvy2rrU2uZ6NM61W8UwsUCezdEPVpOPGTSkPdBvp7zX76OfdizJQ8vTrx8b5s6FCBC
 ioH4adaBJTgGsbqaRkl3K9qqFcvyX6qAQJL3ES3IZrzy4bjKv8y7W5sCJaiwJo/enasbGsMrFbh
 amK1KYxC4BgIeXrlUDw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_05,2026-04-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0
 clxscore=1015 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604290043
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4BB60A0008
X-Stat-Signature: jebwr18suionazjzakppts3um37aw41o
X-Rspam-User: 
X-HE-Tag: 1777439848-45972
X-HE-Meta: U2FsdGVkX1+uDCPVQMdyTFEzLjMPxwRHfd0I2yh1ox5R1d+icRKlXHVRMmjvvKUEjcfi9IsVQwvQdOBlvthddPZYswe9YufAk2zdpLEE7EY2x9i2thjACI//mF4lG7w4WA4GJoQweaDdSTsBglhIvztWJJDnI/XVjnHiWj+WW6i7Fd04sBu03mFSUZXSQkej71yz1bhG55arMbOVwTT4Kdm40iuK2BEj27mynACfD/laYDSuzUhgBH+ARlAinFejSSr0TZx76Dd2XBcKAd2cEuHUt4sk18GCqyVZTZO51t+HDM0pRua0KshLL+k6RK2NqknzWGO7PBg/cq+dWgcFOU0ppeYyku4pIEWSR/MxTzGv6m9PCKjQLuP30Sw1hBKKDqs4WuVj3DN5nfd5xDAp6EZUDiWcqLdJezp/vVJ5XOkOQrFLMSwgpSCsXq1yx0kiVLjVh/Bjs5CAYh2Cn3ILjgHLe3/ydU3/essDjhVBifGg8u+7yX9lL3jdKOd7pi3jmYRt9cuZezMTDC3YjTSZsfEqugybp8Y1foE9XucKmsisAPsOnp+/mJZJohVTUbXi4IYFA+z7x/6dF2UzPnoqO1raH/EMwiry3AhpHGi0jM11+j9GZ+HpI7VgsKp+tjW8ISTOJ8NbLlb4DmeTD+Cl+r8H4o9agjKgEtt0i53UExTk+Gh5grVv9zja+tU0gyoPDRmiOaxJ5tKwmfNk65FU0YtWC2TqR5p7hhgtghW2EjFcCSTxpHYfYGpznz6pQbRSFyrIaMxqRtj5rETzdGJVB49bDMsH9Ib7KJNj8ra53yo+ammC6rLRpwQUNFTQnzZY0pgUvT+945y/r2qNnoTJqv4PlvkxeAW+CsRDF8QqYDyguchcDMwHukPe/P+GtpVlm+CifJ9w6Z3VZ4eTssITBPLT17UjR8ROIYRkYnCNygZ+CV7u5erxJYAS+mIgB+XxWVDUA8dVmZDXmcTYFlB
 jcIF20qo
 Atq+3hmwq4swQ/TEGJRcHKAeJqgC+/dpIjUd4ZInc59WIr7hO6znwPXx7mmEaHlbBa3VeGY/w7vPpw8+h7yXz8Teqp/a1x0rFktGsk1Fy4GvT1TkkBLPYcRdss2SfdEupAd5WIHcP835oLN2miZdiVS0GGK0dY1p3kiT4mittYkiE3/WQj6xOSJzQU7OdHq71CafqULBCd2lAgPsvHdiQ11SzQ4rcitkZRkRZzLZaOzCQrD5gEUR/6sp1xQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 09:45:59PM +0200, David Hildenbrand (Arm) wrote:
> In general, LGTM.
> 
> I do wonder, though, if we want to switch to pte_same/pmd_same/pud_same while at it?

I thought about that too, but decided to keep it focused on direct
dereferences (as it fixes a real issue with the pte kasan sanitizer).

I can send updated patch or a follow-up patch - as you prefer. But
if you like the follow-up I would suggest to un-squash the original
series to get it in three logical steps: 1 - pXdp_get() fix, 2 -
lockless access fix, 3 - pXd_same() cleanup.

> -- 
> Cheers,
> 
> David

Thanks!

