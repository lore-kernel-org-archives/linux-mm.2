Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C33EEF99362
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 10:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10DC96B0005; Thu, 23 Apr 2026 06:54:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BE986B008A; Thu, 23 Apr 2026 06:54:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEF526B008C; Thu, 23 Apr 2026 06:54:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DE4526B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 06:54:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9304E1B838A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:54:23 +0000 (UTC)
X-FDA: 84689511606.01.66CDA8E
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2EBE91C0006
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:54:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=KIZHBZAX;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf20.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776941661; a=rsa-sha256;
	cv=none;
	b=EQ3BnSh0za0szziXmqiK9/+7gQA2OHe8/tPVj0ms85drvlsUheU5GYNfADM81FO7p72Jiv
	CDakCIYTJ6MkTS2Bh/Sx+YwNTkLgE06/29G1JsnKNLUQbhW9Wx6EVJWae/qu+d2oeIwZnQ
	BIqYGIcXM+A2qXVzu++/mtolDAo9zzY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=KIZHBZAX;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf20.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776941661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hPfzzLEnCkfwTfx2ZbFAbPEPqrheLL97qiHOGhGTitI=;
	b=z+fg0Gws9hN04IedoyYA6393rM8N8TwoeBfCfSBIx4PcP9RMB3lOkliG/PtwlVUpVy99+2
	/mAYJ3RdJeaZG6D20XwZn4bXuPij/g7VZBVKp7RTxfmEjKa+JxiNI3+P08m9eC1S5XXCvT
	fbEn6ljaEKMcI8nHp2SqrNNI3xgLXoc=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63N6wv603229030;
	Thu, 23 Apr 2026 10:54:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=hPfzzL
	EnCkfwTfx2ZbFAbPEPqrheLL97qiHOGhGTitI=; b=KIZHBZAX5F6DP77sMLvNux
	FZl39+tfKMVUGd4MOPNxcFlmh3lMzCcEiXY7GQJA24uKavOpJtR86lXSr2V2ajF+
	uW3OyBeFmFw9Ukm3sO4JG2Bfk02ksmABl23Xpc4dPyPnTpYh0ka3Lbh3JHb4d/Ny
	X9R3a3V7EY0V3OFaHmuoBTE6RobIuvuaGXgvDN4WZCOcPr9isTH6wOGF9rh/xh8X
	oyb3oB8VSXP7J4leHBJOv+AMa1o2pJgvt/kvLhaQ1aclk8/rnY+paiL+KRKLrwKS
	PsSLswecLgeQpd5KCcLE96doqla6hbqm2GvZGxZZm0fPIT3IccLCuHPQsmg3hChg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dpeu287sx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Apr 2026 10:54:17 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63NAZOVw011202;
	Thu, 23 Apr 2026 10:54:16 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dpjky699k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Apr 2026 10:54:15 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63NAsCMp31588740
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Apr 2026 10:54:12 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1B82F20040;
	Thu, 23 Apr 2026 10:54:12 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E5FA22004E;
	Thu, 23 Apr 2026 10:54:11 +0000 (GMT)
Received: from osiris (unknown [9.52.214.206])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 23 Apr 2026 10:54:11 +0000 (GMT)
Date: Thu, 23 Apr 2026 12:54:09 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/6] s390/mm: Make PTC and UV call order consistent
Message-ID: <20260423105409.10371Da2-hca@linux.ibm.com>
References: <cover.1776264097.git.agordeev@linux.ibm.com>
 <7b0e73e3c6f4000f9bf7cb161d8ca9a9f2312d70.1776264097.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b0e73e3c6f4000f9bf7cb161d8ca9a9f2312d70.1776264097.git.agordeev@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GLLWoXTr8z_IeoG4--Vv7oyWzsfXxGBf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIzMDEwNyBTYWx0ZWRfXwT8Lczbqy7xY
 OGvraXKfJPG7z9DAO+DoJqu8R0ugjPMYivAs1rA3UYYx55v7PmVxQ4f/WNsz57v2P/YNXhjN58L
 fRx2y/+gsCFjyC3pRWtjiCn6z6gnvMH4Ko0/YUZut+N61esL8qRYtZTer1zyVqjO05jcupUwijF
 YNNJYYqs2WuI4RMWJrCxrycaQCoYPKFqNhnlHD3x5rCVCNWKw/PnrYcc4QtnLsPZBaBGX1Xj7QQ
 Kbgn6iH0ky8G/nobsYG2jgib55Bu7uSazMiUZQb6niXRRltdhBsDPifZCNc2IGjbQVLvLBU4Sv2
 D94XV6tzXEmdgz3Wf2O2+wFpf3LOCmWTS6mJpSPj/ywxPxbw6cnsalqMckvLhzoigVSRZ3TTikM
 hy8/VAdlowWqZbU023IkR+NiwJtpY4h5/SyTmkB6teCY8RmHH6gSKjOzdNpF8cGm8gECSzGEhuC
 p1QS+tnHnKw2fTOCuiQ==
X-Authority-Analysis: v=2.4 cv=C8LZDwP+ c=1 sm=1 tr=0 ts=69e9fa59 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=E1xz_aSQ8MwAHGTOyykA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: GLLWoXTr8z_IeoG4--Vv7oyWzsfXxGBf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-23_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 impostorscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604230107
X-Rspamd-Queue-Id: 2EBE91C0006
X-Rspamd-Server: rspam12
X-Stat-Signature: ujyidi1awyfbs67muz6iubo7naummwcb
X-Rspam-User: 
X-HE-Tag: 1776941660-391302
X-HE-Meta: U2FsdGVkX185X+qodDPSoBLtWh11vdGvudjfV4F93W2gcmTV7JB4uRsMEmtCVhRJXfLu5Q04T6Kaw+t+rs+48iE3vBxpFIUV3UFzDCj9zV3rzw3/mXRaP4iNLoN2NaHr0yyMqLeHH2zrfIXPQf9rATdMqqPIeE7mgVcDpaTDdK42D8xUre7lu2jSWkn02xfefqzZA4KKDCKFArt3g7Aaqp0ezsDIJr8w0mvLqC3QiBnz5h/mFp/NqVmja2CYhuU6Q7BjtaYSaOe4y/jRdFgVNUMiFgkjWQV+i4fP7omHniQxgn8zEXQj80sNWZq8pV+MCdcndrAm9JFUL7jdmCXTTo7AiqoXDMAEGAfU8Tukw1zTiZRiPkwKLvcz1D7JmoZ+kCguomsQBMQlOvXMEE6TmpuQXg/GmQQLN9LXfPwF0Y19R2mHgv3if9WgQD3ZqfAIYt3IEtcsEI8LQWFINxDKdXKn8kRrPRUbxoeztkLWC+u8C0ok4DewMySwXs5E5FExNn20pPs6z/YqyhsPvwf47gdccIfdrvyvpItYct1HLAO1fwLe10G3ONbwlN+PbD1kp2DonNuPjBrBeu3OT60JCR3/4ahpz5ryH27l2cUAX7PQeTDfgDOXsOfrO3hcAG/h9mlNYtJC5Lh9Be2jApBAYsWt/zBxrS5e0zAaenBHDCHQsDZZoR2+6Te4WgoMFSTX5F2h82Dysp5e7s+UZH6in36FNilRrS0X8l1I0CotKHIXEMw0kZ8qzi7bnkgQ/dbgMdLnJgw8WjThkqWWG4JZnX8IAytYHrOAT4NHk9twx9WxOdCvOO5qp/pbbIiNKBIGtxVzRmx1fbz/qbxSCMdvSt5PlvBuKVrST4TOd4PZn1pL2XPFoQXOOx82AAq7PHttHkHn377SWORMGW9l4iNt6AIl/Xcic9w9gU8cJgx/f7Wun4xclQ0idn0CY/q8aUPuiOyN8h039TWlifpP9nb
 kG8+W7QY
 rUV1KU6/ro3/JqdxbyAhKRCeG0vLAAPJBG0XOlGrV8Vw3pHqnXh3Wh6tHQBNthCP0PiZu8rPSbOnFhYxTVyXjEfS6fzMx3EXYDmtrpvvZac1PD8VbDdNs6gE5FoDc7jzY+yqFpwPinTBSqUsy8++1+Yw9bT9hUBDOFeop7npG0NEf1S3cu56SNgNAlI4VaXcFCroWODfn4ZldgSqOM1R0X7ZLrA1nFBCfwgn7gpfeb+cTknEx5BTttpCCqXiua9Lb5cIiZlU8wP5XeHE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 05:01:22PM +0200, Alexander Gordeev wrote:
> In various code paths, page_table_check_pte_clear() is called
> before converting a secure page, while in others it is called
> after. Make this consistent and always perform the conversion
> after the PTC hook has been called. Also make all conversion‑
> eligibility condition checks look the same, and rework the one
> in ptep_get_and_clear_full() slightly.
> 
> Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> ---
>  arch/s390/include/asm/pgtable.h | 39 +++++++++++++++------------------
>  1 file changed, 18 insertions(+), 21 deletions(-)

Why is this required for this series? It is anything but obvious to
me. If it is required please add some reasoning e.g. in the cover
letter or to the above changelog.

