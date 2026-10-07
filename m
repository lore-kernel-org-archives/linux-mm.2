Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6BC4CA5FF1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 12:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCE546B0088; Wed,  7 Oct 2026 08:22:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7F246B008C; Wed,  7 Oct 2026 08:22:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6DE46B0092; Wed,  7 Oct 2026 08:22:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 916E56B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 08:22:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0C9D2140194
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 12:22:32 +0000 (UTC)
X-FDA: 85295743344.21.7301BF3
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9A10018000D
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 12:22:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=M1QsRBXR;
	spf=pass (imf06.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791375749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=abX4Nq/5AyAFWdNBppfKO4gObdBOnRXbHlhnHB8IPa0=;
	b=GizMutQFC7qbI0/NqSOPTXm1RsjOpoyntC/yQMGdsmFp1DSQW72SUjjL4YkFcNGvDrJ/Ct
	YquQujEu3pcQF/j/6SBK1mJ0STx3Rp8uZtrAmusd9YtcDzI9qMB9eWELgjZjEb8osaww8t
	0dS5TKk0/04JnXUck/MtUzDexim9qb4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=M1QsRBXR;
	spf=pass (imf06.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791375749;
	b=55iuCW37H/Q/7Kfn4sCHpF6+WP+77zleeGjskHp3svUpHfS/Ejms2P6AkZH3GEC3eQsN+V
	7ywleHWeW4rBQPrQ/SVPJf1yqSYqKL+0QanPCWWzoXHnsqCeNvsOQS+KL2WPZ2YXu848GI
	XvSZLZCe4mYA/eIzTWH0+MafufdDB9o=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 697BZQNv2375606;
	Wed, 7 Oct 2026 11:42:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=abX4Nq/5AyAFWdNBp
	pfKO4gObdBOnRXbHlhnHB8IPa0=; b=M1QsRBXRYXI3PNQ3dXQyQVASCeOkwYgEM
	r5jpylwnhdNw6ri8TMUDp+xdHHyIEbE7f6+H49/nlW0VNoNJqZKHmCogepNchNLk
	jdVgX3rtvB0jZJZR38UskIoIXVzIOhLMXl8snnhNIHVQ2q3ILg4A1fv7zHX7jPx0
	9CjFP8BUmtDJWbEJoYjo8d0a92otZniOaQkrfK+l7I0j3Vbo6N6DxNtO3cOgHVch
	KSzFFbiDakeueuJa0Jbe1tPscd/H0vrWJ+docbzrY0TCH7YHgj9L9ZGPAdqOyBda
	JP0x20lHVPq48M4pSWn+nSDcWuymqz6sK4YiTLChurxqmjiRyk/bA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h2se5n55r-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 07 Oct 2026 11:42:06 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69782RdI1562407;
	Wed, 7 Oct 2026 11:42:05 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h3cdvxfh0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Oct 2026 11:42:03 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 697BfxU837355960
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 7 Oct 2026 11:41:59 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 612B320043;
	Wed,  7 Oct 2026 11:41:59 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1216E20063;
	Wed,  7 Oct 2026 11:41:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed,  7 Oct 2026 11:41:59 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 87FB41609AF; Wed, 07 Oct 2026 13:41:58 +0200 (CEST)
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
Subject: [PATCH v8 07/15] mm/kasan: use hw_pte_t for the early shadow PTE table
Date: Wed,  7 Oct 2026 13:41:50 +0200
Message-ID: <e24977fba12bae1a05e8eda80c6bebab423ae5e1.1791365932.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791365932.git.agordeev@linux.ibm.com>
References: <cover.1791365932.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfX1qYEKV7bKBha
 Z6vE427s5TOQaGNcAe02e2yRGioQ0XdpycGCtFbL7iv8DRIvqlCcWBFz4k9wTWPsbwb80mOx/xV
 8FOgX7h5x+fMcaa3oPbEEff4Zs6QiRw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfX+jK91lYLDmjG
 58/HvuoRRQ/CLPpSgaLnGza4i9FTqyeBXWg11ncIjV+f9fLtyvBW48IIZvtHtdlyL7MrGeehOk+
 zW8HNvLoJ6MYjkqUPfdnRpbhWZhIcoiKwbxYCELzHXV+UGjRJD7l76VbS1y+1fBEfbN1MgV3ytl
 pGKkRmKjSvNlmMUA++CJdD4Emj8mzY2yfDbCYXlH77kn4oTms1L58gB+dK9q2Ncp/CMzL+fNIJp
 nqVRW3go5AQ9ml3UbBHKElmnccj1TRlw509zKRB0PrkEHYLaH9cRDHOgjgS+eUPsB/6OY/MWdXl
 LAi7pRl6lCrtg4CaAz1/Gr0ndHoJ0lPkJn3YJ+JKS33o7X7qE/3YnP64qPcTYxsIOBbycWc0Z+I
 rvMSpDFmnkAZ38UlXyuEVC6Hx97fum6MEq+2FanWbn6xqZUr3xnmOgybx85e2CqhZ1sw/3BnqHm
 qcfmjBn+9SvTzXpFaNw==
X-Proofpoint-GUID: s9S2W-A6tSAdq8XGy8mTE75XRUEWIcqI
X-Authority-Analysis: v=2.4 cv=UNRIjyfy c=1 sm=1 tr=0 ts=6ac6300e cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=7CQSdrXTAAAA:8 a=AO8vZCCDSQ0loUGPtsYA:9
 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-ORIG-GUID: FN1Y3Ei1wDooguhmrQWKXB3qRV0x0tJS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_04,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610070046
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9A10018000D
X-Stat-Signature: jjh7cnsq4szor3f58fxuqeuimf7eq86z
X-HE-Tag: 1791375749-763690
X-HE-Meta: U2FsdGVkX1/MLLmWRAvrNe7k7OAfwes7sFlZtxn8h6iYhsroxwoqrjoPx7UvVSalHpSwUcd31g/ufKXewbBVPbuyKmmsD8rgvYn/db9g+av5mfQn3lZ3HjgV4ICBSz2aJ0lyXPoMlDXA+imjxJE4kWFuhMoS1yNjfhZwnuA66nwCfs+2hpmf2+FcbTlD12SF5bSRnNozjN8gg1pGf+X+15M4bKO4GHQk1g4B/7aBjLRRLLDLWRmBH56LJDtfgZROcb5VucjdVr3xXcieTICS47BRzPDhJGy3jLDsPJwMI3xjVm3iwTTzc/PCMGJ5pYhuNDpItFYped3esXKI60UMhsc1DwtOxvBN7VKUNfhEa+AIDGKFFnuhLFVcKnQD0p5pabcJed9Qgnjb246pAeRZ8h1MwkLhaGDWFIXkne3igx1ugVWU5xOw2Tfg5kX0lZM8t3eSaUMP2o3vjhpxEbjwe4sbAPeh8Pm4q6HuDrjbzeErjhwCnEY4HjgKOmou5LAw2uPwTMq8OggqrZXEaspBJY5GcXNDIOgq8czjrk1a6Od4d3NqmrLu8l6hjuS/hTnP4hGLf5MhXh2muqfimfLHI6cVk1HXR5BiTQlzVUqNZmSRPwgo8h+F0WdXDbLFux/IE32oXVMC16ph/pSyT+gLBpc5oEkwS5QWPtnsvk8RbmskRzYtFSqKbk8Sg9LK1OuPzyAX3mxJy8+5L1KdVziOty6o0zQW+lh2MIKTCjKhVXXBx/aP1bMkw5+IOffrbZbCq4+kw9RKsy+F3RK9plI3MQcBqjL0TzcaErQMCE+EKzipnF2okO7E4SBbBBTom5xV+hU7jG8IFXalB4DtmbDZz4j/ZDQPTrR7R9I89Osffm81WEMvP/LOdlTHSxngo2O3aKbPXf/2cT/DZwLzLGt3QGCORhjSTu8ovO/arcfuWFyQ2H+AyC6Cy7Cm4k4d4s1BG+ke490wyYNRubIHjpw
 TkHqkNG9
 Ew+jZ/Od9DoPT3kitX6GTjMNjORg5ZPt/0vR3+uRsfctNN79i0oP+5A3qZ5F3NnyrzEMKl8V4cpzFaC7hLudcgYCNZ7Bp9hJhPhkO8PUHzLRnQe+BDy7uqxGFSCfC0oXmqF30/kbSZ0xnLHklP36BnnfXOSFmBoIVkD8Aui6hFK15rR52WayY7D+1idfAjHMbl5i+sOzm5UGpAFxuhP8hcpJj8q+PQVnMMEzG5p28aMGuvpL73Ng5OPQ6K0xf01hSjRcTCwGL2yoOBpJktnCsT20cQvg9YdyP0gmIA+bd6Meir49AhCTI/wGwHb1HY9s4mFADBYOYTircj6+RyP2kIbuJkgrYYur4+utQPqN3RVhfo00=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muhammad Usama Anjum <usama.anjum@arm.com>

kasan_early_shadow_pte is a complete PTE table rather than a software
PTE value. Declare and define its elements as hw_pte_t so the object uses
the PTE table storage type.

Read the first element through ptep_get(), which returns the software PTE
value expected by note_page_pte(), instead of accessing hw_pte_t storage
directly. This also uses the accessor selected by the architecture.

No architecture selects ARCH_HAS_HW_PTE_T at this point, so the storage
representation remains unchanged.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 include/linux/kasan.h | 2 +-
 mm/kasan/init.c       | 2 +-
 mm/ptdump.c           | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index bf233bde68c7..ff41949c0ac0 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -51,7 +51,7 @@ typedef unsigned int __bitwise kasan_vmalloc_flags_t;
 #endif
=20
 extern unsigned char kasan_early_shadow_page[PAGE_SIZE];
-extern pte_t kasan_early_shadow_pte[MAX_PTRS_PER_PTE + PTE_HWTABLE_PTRS]=
;
+extern hw_pte_t kasan_early_shadow_pte[MAX_PTRS_PER_PTE + PTE_HWTABLE_PT=
RS];
 extern pmd_t kasan_early_shadow_pmd[MAX_PTRS_PER_PMD];
 extern pud_t kasan_early_shadow_pud[MAX_PTRS_PER_PUD];
 extern p4d_t kasan_early_shadow_p4d[MAX_PTRS_PER_P4D];
diff --git a/mm/kasan/init.c b/mm/kasan/init.c
index 30c5266eaf37..9bbc2a41d23f 100644
--- a/mm/kasan/init.c
+++ b/mm/kasan/init.c
@@ -64,7 +64,7 @@ static inline bool kasan_pmd_table(pud_t pud)
 	return false;
 }
 #endif
-pte_t kasan_early_shadow_pte[MAX_PTRS_PER_PTE + PTE_HWTABLE_PTRS]
+hw_pte_t kasan_early_shadow_pte[MAX_PTRS_PER_PTE + PTE_HWTABLE_PTRS]
 	__bss_pgtbl;
=20
 static inline bool kasan_pte_table(pmd_t pmd)
diff --git a/mm/ptdump.c b/mm/ptdump.c
index 376880071ca2..8f19f20be3c4 100644
--- a/mm/ptdump.c
+++ b/mm/ptdump.c
@@ -19,7 +19,7 @@ static inline int note_kasan_page_table(struct mm_walk =
*walk,
 {
 	struct ptdump_state *st =3D walk->private;
=20
-	st->note_page_pte(st, addr, kasan_early_shadow_pte[0]);
+	st->note_page_pte(st, addr, ptep_get(kasan_early_shadow_pte));
=20
 	walk->action =3D ACTION_CONTINUE;
=20
--=20
2.53.0


