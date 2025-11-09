Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84269CCFA13
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 00:36:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A46E8E000A; Sat,  8 Nov 2025 19:36:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67BF68E0003; Sat,  8 Nov 2025 19:36:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 591E18E000A; Sat,  8 Nov 2025 19:36:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44AE68E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 19:36:27 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 778AF13BD75
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 00:36:26 +0000 (UTC)
X-FDA: 84089202372.02.800C7A5
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf07.hostedemail.com (Postfix) with ESMTP id 182AD40008
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 00:36:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="MTnMu/8A";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf07.hostedemail.com: domain of japo@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=japo@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762648584; a=rsa-sha256;
	cv=none;
	b=GpkHU7v9jwIj0yweOE71PlzkuOjPQJIuZ25duxyL+JZRmifUIzVsamr3q5eLiIwkAaTHHr
	FOhU9tcXdgO6wI4TYvjMdcVpXtC0BKK/dKh6glPdPvZRESycTR/pRxozsLohaQQUD5EJM3
	YREmWG4aGcZpz7zn9DqoCsoM2ZWtSag=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="MTnMu/8A";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf07.hostedemail.com: domain of japo@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=japo@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762648584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C9g28iKd9GEEBKsPMgyqPsMIFKJGryqMtKFGw9hYR8o=;
	b=ccdgCoyPyh2MsBg3drxkFYeWPOu3HIfd4NpzJAKbbFue+kAcTn9ObSrX4gxivqBGmSg9xP
	SMVJ0jkyPK4pAqhmIcOPnc7EUCVuV2iumcEDCoKasAplhC6+CYbIe24l6nlG8IHW4ZQzHg
	7Q8CVHTniP/vsyn29yeu4Ka6fc89tws=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A90NKMP032066;
	Sun, 9 Nov 2025 00:36:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=C9g28iKd9GEEBKsPM
	gyqPsMIFKJGryqMtKFGw9hYR8o=; b=MTnMu/8ABAXg/m2/jlvr6e4NtbQfOtIgl
	xsZXD7uz5EFcl9m8ULFODxbC9eWTc5+3iPG+P/uQ8Z34rGDb1886yi1Ls+d8ISGM
	CsbUmQocRpG9ra8xmkEm/0Mhb2a5YRhAKAXlxJ6EvaXtcNDrIfKbYur+ZvQ8Awoh
	gqHnQiRQNxtY/KJG5z6hVZrkSYwcxOvIDK4Y3xvs3ZIgm5WvlZMJjtcjXCnOOXZ1
	Isfg96aCFghgIKl4rSHu9IvIDV9uIkbcpfvk7ANuYWnHHn25gdqjTmNiTogtF8U6
	jQtRBdnCyRt9wiGUkayMjQUTDk91yrBA6whl/7bYnqNZk8gtfgdzg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wc6tyfh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 09 Nov 2025 00:36:17 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8J0MGG012891;
	Sun, 9 Nov 2025 00:36:16 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a5y82gnv5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 09 Nov 2025 00:36:16 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A90aEDK51183938
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 9 Nov 2025 00:36:14 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CA15720043;
	Sun,  9 Nov 2025 00:36:14 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A6FAE20040;
	Sun,  9 Nov 2025 00:36:14 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sun,  9 Nov 2025 00:36:14 +0000 (GMT)
From: Jan Polensky <japo@linux.ibm.com>
To: catalin.marinas@arm.com
Cc: akpm@linux-foundation.org, david@redhat.com,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        will@kernel.org
Subject: [PATCH] mm/huge_memory: restrict __GFP_ZEROTAGS to HW tagging architectures
Date: Sun,  9 Nov 2025 01:36:13 +0100
Message-ID: <20251109003613.1461433-1-japo@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251031170133.280742-1-catalin.marinas@arm.com>
References: <20251031170133.280742-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAxOCBTYWx0ZWRfX4HQTAfYveTrz
 1GSXPLohTujNaxU6vabzpGMtuLy257+bS3xVUvxiFfUfDZbotVOwGVAPoiojhEPwzadJXVneGpL
 c4QWlNCEyPy4IUY6PXlMVi4nkRjjSw+PIS2gCXB1/IG8fAkxkH6D/8aHLR/4aYx7JjFsz9hHNHB
 d/RW+cn4nYCG+BJbH4E5Wj1yu4a9r+dpPCMNulF8ZUVgD8meTCbX+JbdG6Qafrg6URtPuKr72vC
 LYpr/L3nOYj01hODmr24m+7Inf+UjX7x9htx/+Sdf/5jyffYbfecGZIy8cF0vok5RnYO1dUZ+OD
 sf8JDMlrrqcs7+4OcWKEZnzGLgfL1LpsF/pJhzsCSBMRTHH9zMRVywtlbEyrgZg/El9atEqFxge
 dQ7WLMH4k6iZofdU1PRt82efdoSYDg==
X-Authority-Analysis: v=2.4 cv=GcEaXAXL c=1 sm=1 tr=0 ts=690fe201 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7CQSdrXTAAAA:8
 a=VnNF1IyMAAAA:8 a=u5nbTVsyuFLneL7zQ6YA:9 a=a-qgeE7W1pNrGK8U0ZQC:22
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: 5yCytclTpiR2Si3mIT-NROSF3tV4cD0w
X-Proofpoint-ORIG-GUID: 5yCytclTpiR2Si3mIT-NROSF3tV4cD0w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-08_07,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 bulkscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080018
X-Rspamd-Queue-Id: 182AD40008
X-Rspamd-Server: rspam07
X-Stat-Signature: 3yp8w577knsedmjikmis75ka75ngpnyp
X-Rspam-User: 
X-HE-Tag: 1762648583-743701
X-HE-Meta: U2FsdGVkX1+Y/S5EKHKRX8MyvXMyax++XfDYMkGJK6xW3WBA3MGbLedtJjJ4kqubxBRGLZMukP5qnzxMDxPhqq645PwMFRjlrfEikOrcoc+Nx8Bd9zZjPsVHPDSuhMYNckqwQW5gZ3a62zZAMqtO9TxCu2blP/OReu5zIQX0/RuAs4sgYHQUuW4uq0FwvvvJQ8/zN3lSmF42zBNuEEj+3WaaFt5PGLMd7ODwHC2HfoGPMi66GcVSN4KTEqyEReBsUsOaLxvTlT6TMRZYWdz3Yt4r045KE1jQ4eNt+UBAJaQpLAieeQiTqcbIAwQnNBCQuHgE7Kr0bMuBXc3lUGSTTzGDDHgynrQyGQC4NnLRiP4M0ssK+vOmm82w1qvZwp4sM8eJ1/rS1cH9u1Dy8fHv9WhgL3MckJvxr38sVUzLKpq/MpDc1vub+wjnKJ7FZ7QshrgPuSTqAK20id6U5c24DNekUvv3uImeIABrHc+jqM4VlZxAwS7dA0EVWgC2Vu4PzBJ8ulkIE4Lp5dBAAVwdp/Dh7n0wTjG91LwpSsEDDiRJaTu7S7bnFOO/Wi6KH/MTy0XjJpndaNIK8rzBkxjDEGbTPQg98r3BMhg3F4MS0E/VehPvQ2ingvN2UknpHWzs9YH58wh+XaPLDzdYge0TzYWdFZumuYq26e1dIQXafs/6ieg1aPc7I2qS7DbjSuT8TnVt2e1zuU8LIeL9fN5gY6ezpfvupxEVjItbSIyrX/j8h7tu1BBSTC2763vkJRSc2SysYj7y95LPdpglNoBgjXUVS19UELF806DsbHTjvT3al1PWLXA5pcgCfzKHUsWV+JM0S3BgN4wbyn3zMN1Sfi2SOEaBIUB5Aag6RD7wmVNIz9SsDKMP8Vgrnm2el/hqoyjgE7XPh5g3GW7HjF2gwuUEJSXX+bvfdpV8iVjz8tjgsjKg61b1L2Z1GQTbItSSrMy80Bvq3GAenarmHMy
 wjr7juMR
 LuFONZm83mKrN+0QBKwWbkkqnUeKOgKt/lhd1q39Ys+4/lVz9hPN6p2SuTzlEH6wYZvVwiCUAyo/L1N11qO+vof4Xyqotyfc07iUU8Oo8o2vIQE2tWJu91Hbmtlrh1CdxFB6RsBqsu6BcDD8rf2Wk+NlYMpTq9pWOBRIx0XcrpnEX5LVGoewjpcO2mOu9ArwQbpsKe3DSmMt8OkbXBbbHiGmlsTy0GNu3S+TB42j9G3+bXbVs2rrqGybkN6lji/cauw/xNhy+2m7J7EjkbtytlyABzjg3JUliDaDWIGLPybZjxXIJhNaE5EylZQh6+/hSajPZ/7s+PIE4yFl4IS/RPvjm22ua2mGFkNJVmu/uqC9PpVA0TV5YYBhOfX40g965UmS8d05K47ReUpx8lLT7CDXWpaR8/3nZyl6otCQconx9CSGvgxrlQiZuNDnb4/qNieWGbN2QqwKWYCc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The previous change added __GFP_ZEROTAGS when allocating the huge zero
folio to ensure tag initialization for arm64 with MTE enabled. However,
on s390 this flag is unnecessary and triggers a regression
(observed as a crash during repeated 'dnf makecache').

Restrict the use of __GFP_ZEROTAGS to architectures that support
hardware memory tagging (currently arm64 with MTE or KASAN HW tags).
This avoids unintended side effects on other platforms.

Fixes: 1579227fe0f0 ("mm/huge_memory: initialise the tags of the huge zero folio")
Link: https://lore.kernel.org/r/20251031170133.280742-1-catalin.marinas@arm.com
Signed-off-by: Jan Polensky <japo@linux.ibm.com>
---
 mm/huge_memory.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index aae283b00857..0c1794656d7a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -209,14 +209,15 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,

 static bool get_huge_zero_folio(void)
 {
+	gfp_t gfp = (GFP_TRANSHUGE | __GFP_ZERO) & ~__GFP_MOVABLE;
 	struct folio *zero_folio;
 retry:
 	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
 		return true;
-
-	zero_folio = folio_alloc((GFP_TRANSHUGE | __GFP_ZERO | __GFP_ZEROTAGS) &
-				 ~__GFP_MOVABLE,
-			HPAGE_PMD_ORDER);
+#if IS_ENABLED(CONFIG_KASAN_HW_TAGS) || IS_ENABLED(CONFIG_ARM64_MTE)
+	gfp |= __GFP_ZEROTAGS;
+#endif
+	zero_folio = folio_alloc(gfp, HPAGE_PMD_ORDER);
 	if (!zero_folio) {
 		count_vm_event(THP_ZERO_PAGE_ALLOC_FAILED);
 		return false;
--
2.48.1


