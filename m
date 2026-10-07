Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E719CA5FF1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 11:42:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6EDF6B009E; Wed,  7 Oct 2026 07:42:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E387A6B00A2; Wed,  7 Oct 2026 07:42:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE8D16B009E; Wed,  7 Oct 2026 07:42:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8D7E36B009D
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 07:42:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0EB2A1201B9
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:42:13 +0000 (UTC)
X-FDA: 85295641746.26.97DCB1E
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf14.hostedemail.com (Postfix) with ESMTP id A159D100006
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:42:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=kVAmyLdG;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf14.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791373330;
	b=xYiNZMe4Igm7nQ1EQzTwzNK/y2bB5Cwbkv2uM+dfAi7p5ZTMm7ohdtB1df8c3Zg9gB9zPu
	AGg1UTI67dhThsjepm2dUY05RngP4F0M6a+sCNhyzSRdf2NcYPDY+c2Ey1RSnqYwahSCM0
	B55Xdgy+KSAvjTggrkBfEnDs1J7KaYo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=kVAmyLdG;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf14.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791373330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EBKhH4DjM2gVSO1d+cytd22TCiZ2Y2ktqC3xv9BFUuI=;
	b=DcHFHXkHtY/jVL18R0+o7eQWyBmeX0WpDFj74aSfxVNpJ55Zg0Yn6mDhsunYS4Wo8hbDel
	w7lfuMtE9YcwIlGbrOWGt+gdENZFCGngq6hALpm0WLpYxTqUumA+clhfpy7j1R1cvgTi7D
	2ZZewk8NXMkZL0Srodr8oSxmvSA9EgY=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 697BZM6w2462975;
	Wed, 7 Oct 2026 11:42:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=EBKhH4DjM2gVSO1d+
	cytd22TCiZ2Y2ktqC3xv9BFUuI=; b=kVAmyLdG83Pu1cLLnUxHeSZ28Zd0VHBhV
	Hx+gISUroCN5r1JSK3dTi26uj+o3aAvvedTaMEFaDmzMT/SiM/UJNdMmOa1z/Zca
	EijNbssx/JeEW+Em5dU5/UYuSMoD3oA2ts11LLnFMlbec6KTG5t/2QcjDixRVe9T
	mFjaJ28WWCq5uB2na9fdteqQBHUq2l93792wG/YsBoSSbWVpBhwcpUB8amWEiC02
	pQWMyil94wyWF1Z0Y4R7VnpzzP6aosdK+6r2oQw7l1/7+kqvt0JP+YYMtNxvYXC5
	r+TVwC6aQk4+D01L2fSW4nSRGF8YE7P07CakA4tbE6m0diLlzkc4Q==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h2s74w8c5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 07 Oct 2026 11:42:04 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 697BWftC1841550;
	Wed, 7 Oct 2026 11:42:03 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h5a6dj8w3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Oct 2026 11:42:03 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 697BfxAg48759108
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 7 Oct 2026 11:41:59 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4899B20040;
	Wed,  7 Oct 2026 11:41:59 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 061ED2004B;
	Wed,  7 Oct 2026 11:41:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed,  7 Oct 2026 11:41:58 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 83FA41609A0; Wed, 07 Oct 2026 13:41:58 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com
Subject: [PATCH v8 05/15] mm: convert PTE table entry to pte
Date: Wed,  7 Oct 2026 13:41:48 +0200
Message-ID: <4151437659f71c16a136c5be941bbb44d46e6dec.1791365932.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791365932.git.agordeev@linux.ibm.com>
References: <cover.1791365932.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: pD1re0KzzLGd5F_2IemxmUT-8jK_GUOV
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfX2jmGVpxiSLV9
 QrRp+/srHX64L80HKWDUWzNhG/sji91LO3sAaYX04/DY9T/MBEVCamiv4QcbJKK+lnQ8ikT5EWl
 a92+awAq84dlzBfKkBHq3IgcqjZ5n+g=
X-Proofpoint-GUID: 2y9IoJKPKDxvlevesMlylT9_w6B09v2R
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfX0KyoLrgdfzK+
 raNDizk6OLCmAO95wzipKommWJqKKeJM2YWQXrIQpgSBZ5585hJ6TOzH2pChNJxp3r/S37gYgDX
 LEQ9QeLCbJo6re+160wPjiBQOnfW3+kzpJpGXlXHztAsd1yEw3DxxammHBgOgeuCECdRX0/sjgc
 i9d2NutWlUD5C7ifcbhlIH6TvcLI/M9ZTQFMr2SvaQzNZy6FXgRc8msJCAzyuwCBY9aK39YWmrY
 VDxfuGvkIEfUYhzpJKbDUQOtKdpxAauq9hNOox04ufIBBrJtm/15RVUs+vmJVVQXHvHIJ7S3fpX
 Kn1LZpI1ZqlPJtlerKWrDdiDN62CR7nenW7C/wOSpPm7F72nWERcDcT4/IgMzlYP96d7zgZOiaX
 8Cbjka6xAZ3Zpx/lSjdePtbu6C74bfh5HE7k8omkv8QxlkEY6vNB5l/WJcfAljDAbRLZrL1gmEB
 9/c89ct37II0RBz1uZw==
X-Authority-Analysis: v=2.4 cv=fM2sTpae c=1 sm=1 tr=0 ts=6ac6300d cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=7CQSdrXTAAAA:8 a=o7zO94P2ADgDUaN7wBQA:9
 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_04,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610070046
X-Stat-Signature: 4h9xomd8i7s6oyc76uej16a5ru51dedu
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A159D100006
X-HE-Tag: 1791373330-653630
X-HE-Meta: U2FsdGVkX1+B9iH8Hsd9uVcqH+uoL93y0x+mn+SzJRgMQAJYlBZ62gem7x+X5sPUVeDJpmfkELDrFnqmsmUL0E3dZvpP3ffndzOl1RsNa8QZ2cfrnuDlUdkaZr5/0KEW4lnESQHFsw6lrLmluA+X1YvVlsKS8j3g5MDCPzuX4fYzb0w9lG457B/NgM+eJHD44804Ud8jOZVcuD4kztAPR0y330rEbStHbif1jr38Zh2XeFk2HUuaL8b/l5L8pflnktAC4uPZYPp7mfLW5PmkwFhvbuM1ULXqCpaCEI8hqnm8GNXQzPh1d37pQBn00NEbbAaE8VNZJaTI7synVXiK63CFfZvxqMmgurXNQ3UcVj+on2DEmUM4FxxEYNVfNSWN8z8b+SJnJc6CNSoIP2uaP/4Kq+qnJKf2BqJ944SqePvHQ4iNLT6j/MOv/DMQIjCoxbkPYQguV1h2PA80t671ThTXPv2sloFw0ksVrpEWfLTrr0Ch+DSmugWXxv8m5MayglEvLuOXR5USO+MvaYMTMi3qvtjcve5zXa0dbPrGOAL+Reu6fdDwwXQANWaDVkmI5FP4vNKv/hoN9nz5DVLwv3tDrioC+cCtr33PUmMJF1X0ASXaKRGGBZaob/OpD/1RLY3LG0EnEXZDsJGs9WifiHafO4C7/T/USmoEYdPLSfnEetipasZ5ToLqMwo8OJMy1g9Fv8asBSn7xOJTKq5dG0oBHBW6hz8qNCBtCIYaScSM8SsG2Ak1JNjOoVbGeIHZ/vI9cnRrRZFYYhJdbC+y1mep7MNmjtCx3ZO6XKe0E+Oeb99v6m3YOFK+SVhaLL//53TALa5BMnpuHEtQA4/h2DGsYaoeYmkScXyEevChlsO1FjKaBYb980DYrEwpKSOptAB8se+4qczBexyl8SDwxCYDJPh6vpV2BIr/Vvi6E9SQYc1uW7oRFGhr4oFlGvT+pJnygvCTI04rVGn/ri1
 vONQF3HQ
 v/Dd6ueY+h9tkyEYHPH1zE/OPfpHSWDDkMH2dIQPyq++yaaEpN7JPIpnJoT5cLO2FsOslhOwUA7vvkW8MmecL/O6daa3rPhPJxu+SurUjtCIb413+P5N0QCBEME4dDdS2MrYNx7MRtj66kSQmxRVOOG2l4809uX9nlbubboxuh8KOjDclmN/OzF8nrUWDpBJhzWK8gWniSfEsDO+8f4InXATyO4dwG1M51uq8l2HqpKIU7HEjLb9s+q1fLe4ZhMYvSY5x1Mz9XszDEx6coPX5qfG8D9xf85ysoCwH/Tge1UvoHnfppqQHMcCTsT0fmWy1SCi4uqp//uNTkItotbhTc1MKMXSyLng3pqtE6NChyGVC5arrBO+pjuIxJbfiPgS8hNVXg7Yd21hzu89ZxHuMOqTTVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muhammad Usama Anjum <usama.anjum@arm.com>

The non-MMU stub receives hw_pte_t but returns a software PTE value. It
has no attached PTE that requires ptep_get(), so convert only the stored
entry through __pte_from_hw().

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 include/linux/hugetlb.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index bc0b9c65aa1d..be31fcf93654 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1283,7 +1283,8 @@ static inline pte_t huge_ptep_clear_flush(struct vm=
_area_struct *vma,
 #ifdef CONFIG_MMU
 	return ptep_get(ptep);
 #else
-	return *ptep;
+	/* No attached PTE that requires ptep_get(). */
+	return __pte_from_hw(*ptep);
 #endif
 }
=20
--=20
2.53.0


