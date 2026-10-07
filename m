Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47F2ECA5FF1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 11:42:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41F356B009D; Wed,  7 Oct 2026 07:42:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B1686B00A1; Wed,  7 Oct 2026 07:42:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5C66B009D; Wed,  7 Oct 2026 07:42:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B48596B009F
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 07:42:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44448C0198
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:42:13 +0000 (UTC)
X-FDA: 85295641746.14.6C877D7
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf13.hostedemail.com (Postfix) with ESMTP id DD3C120005
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:42:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=dVA68+tU;
	spf=pass (imf13.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791373331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LENXcUhtNjTRcUvlC4i+bIRx00OSk2JxzpFUTOM/Jic=;
	b=ioVehLSf8y034QN476IWSGpCIsckePHlUbnP+LYUXEduMcWVzpkjIO5tSBRQfVguvTUv4I
	+hwid2azYXE6Y+QOuMptmyWGaHwR+Nk5p2RQZ6Ve4yrET9Q9ly2BNeHZX/dhncSoeHyY11
	8GlvflNEhWAGaOKwkWQ4TqWAvKtCuiQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=dVA68+tU;
	spf=pass (imf13.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791373331;
	b=CQx0eqSwA7Jms2CxPAwg0olO+WyWhnR8ipaz00pElXZb4Pc1uUMLYq68vd93vYo3oOi2uK
	BS/ncV+t7MizTC7rzVHBAR8XXclLBRC/8tlNsaOewAxAeKdArNr9P2MkqaNy6/KSuEDRI+
	U7noL+y3vUv4sfNbgV1zfuzpYFT9KxA=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 697BZwxA597192;
	Wed, 7 Oct 2026 11:42:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=LENXcUhtNjTRcUvlC
	4i+bIRx00OSk2JxzpFUTOM/Jic=; b=dVA68+tUQppiVzNffU2oqfB08m16MixeB
	RlOa5Ms8tM9dfqNt26yZQ+b8c8VMtBaZrYV/vSj5qVLb4o3gUa2+QC0jlu5rdBg0
	3+OWGI6HJMD7L3/Eiyr1kmBuwoetqcKQUDsN07j738C3yrsy/1bBxkAdnEUV8svp
	rt4KSv8zVDjOLr77MfCqxaw5pD0ZunE7Y+yvcRvTWzSmd9x2kY5O2gWjOHDsOTxV
	lRzykbTBO9g4gEywdHFDihYE1qc1a4cnkVVOjvPJmPNPpzFWjt0FGVSu/bg7PFi7
	aNGXOpCslqGXAsPMAp4D5RgK6f0Kv73oqXnpjlfr1C5P/lTJjSdag==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h2scrn5kq-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 07 Oct 2026 11:42:04 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 697BWmPU1789976;
	Wed, 7 Oct 2026 11:42:03 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h58d5jmhx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Oct 2026 11:42:03 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 697BfxGN35127770
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 7 Oct 2026 11:41:59 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5AC302004D;
	Wed,  7 Oct 2026 11:41:59 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 116252004E;
	Wed,  7 Oct 2026 11:41:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed,  7 Oct 2026 11:41:59 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 89F1F1609B4; Wed, 07 Oct 2026 13:41:58 +0200 (CEST)
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
Subject: [PATCH v8 08/15] drm/i915: use hw_pte_t for PTE range callbacks
Date: Wed,  7 Oct 2026 13:41:51 +0200
Message-ID: <fec82d136996345f5937cc3a8fac951fdc2ba2f0.1791365932.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791365932.git.agordeev@linux.ibm.com>
References: <cover.1791365932.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfXyy3E+t6pM3Zw
 E4RKZ6W9Vz+LgTLcJcj+Xw6HNuJ5WgJquVE6UnPW+GkFtIzyuNwH/HUSxkOfkPLTab8+htUsMv7
 aDEjW6y2Q+n+ugj6HNRATShLOfX4Ygc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfX8N8fkP/4i3KV
 dTgP+/oV/CeYw/3O9gvGgHpjzOjxUzHMoUklra8YP19PY5b5Vd/IdkYrlfOOa6d7MWtxZGJr6Ol
 eni1W05m05OlhIOx3tZLVtcB3hfFpN7AX8IFJBcvwZvLG82BIlr/EOiaaRIGUm4eNtAP2xmVEaR
 XSQQcb0XMQoQH8mPqPh47qteUYAGWghd7GH2ymGcSjIuK17eOIsjnBszmGahnFV276GsEnqf+gf
 Rgub9aDVyowCkmT4YTjYzVCIUJ+QW/sKkPji6q7K60F5BjGocMvqB4rqIWynkdTeevnk9aXSFcd
 5FETSJbTganoNAykilh8mCfA70mMFSpMOKpotd4l4cj0gFe1766R0Xc+3JrvY3Jq8NjQjS3qUPw
 kl+tlt7ybpWjYkYVmK0Nbwvphe4oRgkOyTGrJwfV6EHLkxnLrvs1onTLFegJKYkejKWOspyM6po
 M/yvfwZigTiFAEc5vsA==
X-Proofpoint-GUID: cI8WzYm86iYgzZtGvHYBajDSbKBmdn_H
X-Proofpoint-ORIG-GUID: 6s5fZS3ntdQw-LkPSoqhoh7y4N7vzvjU
X-Authority-Analysis: v=2.4 cv=B7osQ+tM c=1 sm=1 tr=0 ts=6ac6300c cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=7CQSdrXTAAAA:8 a=irxyurOfxv8hHXk4GvsA:9
 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_04,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 malwarescore=0 impostorscore=0 phishscore=0
 clxscore=1015 spamscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610070046
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DD3C120005
X-Stat-Signature: k5sn8ygza6iwd9cyojapc9dmqy6hdc48
X-HE-Tag: 1791373330-794150
X-HE-Meta: U2FsdGVkX1/cK/JlgmkRKmiM7k4DX1hEZwDQmB3XzmVVBZ59S1QlS/xw7vBdVEHv0h2UtrTyqCwnYN4n9yM16LQ9pJnu4cuhqJPawNZTiUqd9eFimeEXej6Oz2P+pxbaUog9AzUpAOlQYR0hIUPbFjJ8v4AQuTNj5/6wkWOVLl3d0+RvXuq/u/ImzWcAeivc92F0lK+i/JTELOh5Ye+IWSuif5m/IaAhuO+fRifQ32kfMPMNx1iydRbDWVaipUF4/PAY/wEOOiuZ1lG1z1ZNLGEGCC8JRAUNmNppI6i1RqKV9XqrjkIxxvlbEg7gqzeHEVPZJlCbxyb2Dz0/ZOpH5sYdSmUdo5WnQKWSRdnWPvgw3idKi+KRzYgmGG4b/zpEh17Z05v5H7ulyEjbod/ZGqFNOzDHT93k0Ajl+SQoQD6PaT6nT7hB8zwlBjk05VZC9FAXd1AlfucVr/3G1vs6yVUVZ1HECyg0S2Wedq3iki3qXFzXSVt58BVJ5SAoRCKN4WsOL8x58ShxI4X/Q5Cl5NJjw2MmK5H6P9+rKJG3JaOoKMlqgp+/dTrcA4QKJTC+GMT8pcIN56vmDNCBoe969fO3IyzqWGglwpEp8tktaAQbCm4iGzesUsP+duvWW25zSSra5pBu4Dd7BRMrVhni5aW6aGPAgTXNZRkFGxWgPh26/swTxBz3cpSLPFKDtgatqIBEoTjYZS2ZsWdogFN14uizK3R1VH5xL+ovQP080YRysQm2nWDLW1tIY0SDU2Kz5Cq0lX1NwXw9vCunBjnDi0KwUZLrkdkHu9icn1JzZjsCkLyvD56WcgjCUFYQGl+oTz0UcqCpeerlv0kIBdGRTNA8GNC/c6KUxSefMQux1PuDqD5i5wOLlrhPDHmlyjBT2JrqgrAW9bgKkTAR6hnO87Bb9nx0kAbYpAo/NnJYmmsR5c0uScvZd0CQ93HNB8ODEE/pwzvqr1MkFTSShdN
 VcT3VqF5
 wMPUaskTmKAoJx6cLj0C7cKWMNkTjbcHRqrbyVob7WgvBa0VR6t3xYsptdvSE8Gjcl9K1aD4OStK8xrIUEsmREfrwMjMOiEAff+0sPc18YHj2CyUHsMzQpY8yiLo5TmoSXQdItH01G9fvVK4s8YR6KXXrIYm7sQIOul8Kh8Lj8ZGzA5Dj0pTGokPz//1iLKTAkI+sVXovulPeLX6tI4wCo+AOW48yr8/8PgVEWxBoJzKFEQwUZNU237WJBMVaJqpW05Y8VDRXiIqn1Kj2uWHV/JiXu+UNjTZBcudRSKmqEgmpJPBGacfLHAMZuIgQwUgWgRPhfwH2kqlf9wRsKeMwqlY5j8ANTIVhzYGTK/zUdilCheE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muhammad Usama Anjum <usama.anjum@arm.com>

apply_to_page_range() now passes PTE table storage to its callback as
hw_pte_t *. Update the i915 remap and selftest callbacks to match the new
type.

Continue to use ptep_get() for software PTE values and set_pte_at() for
updates.
The type remains an alias of pte_t on x86 until that architecture opts in=
.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c | 4 ++--
 drivers/gpu/drm/i915/i915_mm.c                     | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c b/drivers=
/gpu/drm/i915/gem/selftests/i915_gem_mman.c
index d01acfb7d93d..056faf4a3618 100644
--- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
@@ -1690,7 +1690,7 @@ static int igt_mmap_gpu(void *arg)
 	return 0;
 }
=20
-static int check_present_pte(pte_t *pte, unsigned long addr, void *data)
+static int check_present_pte(hw_pte_t *pte, unsigned long addr, void *da=
ta)
 {
 	pte_t ptent =3D ptep_get(pte);
=20
@@ -1703,7 +1703,7 @@ static int check_present_pte(pte_t *pte, unsigned l=
ong addr, void *data)
 	return 0;
 }
=20
-static int check_absent_pte(pte_t *pte, unsigned long addr, void *data)
+static int check_absent_pte(hw_pte_t *pte, unsigned long addr, void *dat=
a)
 {
 	pte_t ptent =3D ptep_get(pte);
=20
diff --git a/drivers/gpu/drm/i915/i915_mm.c b/drivers/gpu/drm/i915/i915_m=
m.c
index fd89e7c7d8d6..aab88e8edf94 100644
--- a/drivers/gpu/drm/i915/i915_mm.c
+++ b/drivers/gpu/drm/i915/i915_mm.c
@@ -48,7 +48,7 @@ static inline unsigned long sgt_pfn(const struct remap_=
pfn *r)
 		return r->sgt.pfn + (r->sgt.curr >> PAGE_SHIFT);
 }
=20
-static int remap_sg(pte_t *pte, unsigned long addr, void *data)
+static int remap_sg(hw_pte_t *pte, unsigned long addr, void *data)
 {
 	struct remap_pfn *r =3D data;
=20
@@ -70,7 +70,7 @@ static int remap_sg(pte_t *pte, unsigned long addr, voi=
d *data)
 #define EXPECTED_FLAGS (VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP)
=20
 #if IS_ENABLED(CONFIG_X86)
-static int remap_pfn(pte_t *pte, unsigned long addr, void *data)
+static int remap_pfn(hw_pte_t *pte, unsigned long addr, void *data)
 {
 	struct remap_pfn *r =3D data;
=20
--=20
2.53.0


