Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 174E2CA5FFC
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 11:42:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D7046B0095; Wed,  7 Oct 2026 07:42:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1610A6B0096; Wed,  7 Oct 2026 07:42:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07D846B0098; Wed,  7 Oct 2026 07:42:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC3286B0095
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 07:42:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 577451401AE
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:42:11 +0000 (UTC)
X-FDA: 85295641662.05.22EBFFB
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf27.hostedemail.com (Postfix) with ESMTP id E806240002
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:42:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Pa08uGVV;
	spf=pass (imf27.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791373329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=utiFsN1G7ZKnL1J/VAz4Xwn+3Jw/a7oG34qw4D3r6aQ=;
	b=ocxtkc9VkKUUK5dP/1zqX0kpaHf71d7IAD7NNWZ26NITzo/1Fh6g3C+XRPEbIlXkv3Djxw
	yGiccPjMZf04poPw93lHYjXtCBPXJBfM80NG7l8Dk6RUGtiQiwC5CXYcpJeN2rCCkAdZpp
	JW6YSrT73DeTeYHLlQxAQ9S8+CDZg34=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Pa08uGVV;
	spf=pass (imf27.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791373329;
	b=6nfgDKR5RC91Nsbf+gY8n3ECuzQASswiQnsZ4nZzyeOnfSKIxtAexZLW3j94Hzv6l4zhzb
	y14iem3jQT1MHdx47S01kTGSBbYFABkUlaxM7LZPNWQ3SsxIDjTb8kYDLD7CyBvpd9GBQi
	0KZYYPOhBdrpRakE2AT7LhiR7n52qhk=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 697BZScl2463039;
	Wed, 7 Oct 2026 11:42:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=utiFsN1G7ZKnL1J/V
	Az4Xwn+3Jw/a7oG34qw4D3r6aQ=; b=Pa08uGVV9QuJSvxXwr0AvlzsCcv8ZRX/E
	qR333Xewl/dRFBVAu7a3/117cFbSPjReCeHhWxLh3JdLBso4LFRFad7mC+cCfnnw
	e02V/tTjCzZRJG2MEGOAB2gr4p0anJVSsmoXc3IsWNj7Fteuog/v1JYuwXe1KL3w
	363GacB+rLYtjBfIDo0NVUafJxNi+4P49wExecJodC/t2/HtHmRWZRJ8LCoauz/w
	rgTgACLl/JFmWn/gx/seiTjpKrXgw7K4ACsKb3Qw3c9Oj+V1IULh04QJYJXsCNip
	r5Z/9gV9TsLm0Mwxpehtix4E8vLZHPTBkybhrMgYn3QzUrqyHmPMw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h2s74w8c2-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 07 Oct 2026 11:42:04 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 697BX7nn1852610;
	Wed, 7 Oct 2026 11:42:03 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h3dhgxaue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Oct 2026 11:42:02 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 697Bfx796619448
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 7 Oct 2026 11:41:59 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F26992004D;
	Wed,  7 Oct 2026 11:41:58 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A659920049;
	Wed,  7 Oct 2026 11:41:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed,  7 Oct 2026 11:41:58 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 8213B16096B; Wed, 07 Oct 2026 13:41:58 +0200 (CEST)
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
Subject: [PATCH v8 04/15] mm: convert PTE table entries in ptep_get()
Date: Wed,  7 Oct 2026 13:41:47 +0200
Message-ID: <edaee657070484a21e96f315c374ccc4d8922936.1791365932.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791365932.git.agordeev@linux.ibm.com>
References: <cover.1791365932.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: pyMhgOO0v4VOCAydqbCm361HgIudXaK4
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfX746I6PsUZf6m
 2KOHP1izwyd3Twp1WG5Gdqp9uWUpoxNGb9pNRaGXndxQN1kl11mP+OT06Xx+ZKhiJLN+jRYi/it
 EqpFmj+o8oGofctWkdhHka8gpsx+XpQ=
X-Proofpoint-GUID: DPZO_1nAXLrxW5zj_E8Vg6VFQ0Zlpp4O
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfX+VVGuGhQD3aI
 kECgZ0qTFliNsk7gq2E3XP+in4f+/4fs6hwB2TLkjYo3t813wgwjW+G5jlRb0uLr/vsunCg+W0k
 h7VIW85e10pokcOICbP0ffr+fIrAbyzWBiAkaEeArpEODJgfrYajMps2ete9qvdD2uGBiBTrGcu
 hABd/wFU3rMlIxKXYMBQeJH0+1n4zqLuRA8ZOvedxXtXBLyVNu5flMqQgAXZaBJjda2EbYANQL9
 2Ub1tMqsUxMeYnX1cEkDROM577lmvqO6vdrM1vJp3nJDO2hrCKD8rKDeU5YQbyA3w6OhTLBIdWF
 d34AwHydekZaDoKi55fTpHbhft65m6M6TFrzLiVs539Vy1UprXOeGedgRBHB7D417NqLbxw3Ehu
 WvG4mCcG1g8UwIqkp+GhXcLuyO3nLQlfZlyfqSQb5OR30MFjcmZjKJotvCcn+n2eaUntwW81s3+
 3EmmoBrjn76SguQw5Aw==
X-Authority-Analysis: v=2.4 cv=fM2sTpae c=1 sm=1 tr=0 ts=6ac6300c cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=7CQSdrXTAAAA:8 a=2R5SyWd6415lt-ZHj5AA:9
 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_04,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610070046
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E806240002
X-Rspam-User: 
X-Stat-Signature: nq58j5iq1nuezu57f1sjnzco1nz9cddb
X-HE-Tag: 1791373328-380001
X-HE-Meta: U2FsdGVkX18QsnSEDQGiaxQGm8QuQO1fkAM84fHrY1/vrgG5OBimsf6PRj0hcmjYdQGBfbEHJlZ6h527pOV2jxjmjPovFVYOEgP5V0BBJ53dkwqyMUBUL2uwVghxGG8MjRhV0Oq+knSBRdQVRwfw53wBsX7WkoyXExo+ugT5nWwTZCEpcZT0lNgpay4oCG7TrMPEqa+F3lTxP/a6RgRWKf9ZH+Km30egteQ9o4vxMbsXKB+1C+gSSpLGSN6MgdymYZv4xpo4KTospKW4TME//eoftxF3UefPACxo702flLFn7V2f2+4t/awqmMj94Smyg3qRYRhV/IHf7RPvDSMMubVEZiARhwEXJ/3PcmgpFq0QdIe/Z6C/531qfJ4/xvuq1Ace+fAPUFMBMQXQTHT8XEqmr9jRkm3YQ9acEGtigwcnZ3zyaik6XxRGa/S85a9j6So+9YxoWSiszWSM6FTd9FGBkd9V4RLPYNUHfXCLwtIrcFUbzxtZTogvk5zcGppTfi4ORVQBmWpr6zLQTuTAFIX6T8vDuV/P+5tz4CHHHrKPv2ehxSS/noG8x48Vfa23POpDwJQlWttPNrzGfzuqo5KTwbJ5bRCxWRX9yKgsouBOwZbKuF7KN652GQnjyLlF/Az7FoBcY6W9nG2kf8llNQjKTf5u9BBCXmwYL9croSD2LRvu+7ZwDaVw0yRSE/ZMogLJ3kNC8vu2V4UEcJa+TM2iRl+UR8OVLjsKEP9u0xD686DaE4L9NJeIHHIxnxDlJbrx6WirlmQFgrvdiRr99yBiNBTwaaWrXju+c6iFmH76c6mw417SP48UDzN5as4bDXDv5zTrtUe8ixmmWTE9f22LUh5txgGdG/UyMjyIhthjUY4L2Wy4wwp9+BZh1QKfcBC3RcZjL86KgV6vt+2GeAxzqYzOAnd31qu5NzVGFORaTZVEz2ZTPsZawBgxz9bt3IoCfYJKU/KWglUfWwA
 1r7uuSjG
 nE4PFXQoMyf8SOmWdLiyM9hX5ug4oIe3ozEXVCz7adIv30mqRjiTaRTLpImK0hxWZ5ouyx6+C32Mv5vqG/jrkn7CVtWFRhptlZsNTm1FF/qKsDV+o/MaZG0SmMKfKSPEcVLVSEzi73XvV0QsvQXzEeDiF/jNzbI3doVOKi//yGD8mLEOzjmfT+JvasNRD2kR9ly0ruUWa1KcN1pA6cj3qL/zzFopxrbrIuTP+JU/4IqIvEWAxENZN7cIG2hGYBebLvbWHksgtyYhthqn+jfzr1t328kC937ZGwa3fb7LRaGlVxCqL4bxsA0hX27I9wNr7AtatA9dGeCPKwoUeHlQWClmXjz1eH+aCNWLTdCNg5oOIvWw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muhammad Usama Anjum <usama.anjum@arm.com>

ptep_get() now accepts a pointer to hw_pte_t storage but must continue to
return a software PTE value. Add __pte_from_hw for both generic hw_pte_t
definitions. Read the hw_pte_t table element atomically before converting
it to pte_t.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 include/linux/pgtable.h       | 2 +-
 include/linux/pgtable_types.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index dad80d264aac..1768421755a9 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -493,7 +493,7 @@ static inline int pudp_set_access_flags(struct vm_are=
a_struct *vma,
 #ifndef ptep_get
 static inline pte_t ptep_get(hw_pte_t *ptep)
 {
-	return READ_ONCE(*ptep);
+	return __pte_from_hw(READ_ONCE(*ptep));
 }
 #endif
=20
diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.=
h
index 07da05d375c2..d6c5a7548550 100644
--- a/include/linux/pgtable_types.h
+++ b/include/linux/pgtable_types.h
@@ -8,8 +8,10 @@
=20
 #ifdef CONFIG_ARCH_HAS_HW_PTE_T
 typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
+#define __pte_from_hw(pte)	((pte).__pte)
 #else
 #define hw_pte_t pte_t
+#define __pte_from_hw(pte)	(pte)
 #endif
=20
 #endif /* !__ASSEMBLY__ */
--=20
2.53.0


