Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A70ECA5FFC
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 12:24:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DF236B0092; Wed,  7 Oct 2026 08:24:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 690566B0093; Wed,  7 Oct 2026 08:24:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57ECC6B0095; Wed,  7 Oct 2026 08:24:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2613C6B0092
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 08:24:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B15E81C1822
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 12:24:32 +0000 (UTC)
X-FDA: 85295748384.14.CF07D36
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4C48414000C
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 12:24:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=hid6kEKE;
	spf=pass (imf09.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791375870;
	b=b4uBj+IZRd9jzSBT6cYlkHxxVqODyb8jzpr52RfDMKG2c6GVBBHby6GzuexXRKJyX9ef0l
	5OUCHnY4mDrn+y95g9p0Sy32K41k704aCgAOLtLHBBvJcH0bSlApBww2mXJppkPEVY6rTe
	S2ED7O78jY2CR5J3kVbEEmt0bc8Mqf4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=hid6kEKE;
	spf=pass (imf09.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791375870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pHHS2HD7Q+CA5JLyhpuDDHMaGA+EpDcZ9dD6ersRSjk=;
	b=rn3sol3TN9+tR9jA8vNnTeHogSwHp272hUM3JO6bu+GpxWgBsR8Dc9HBOPO/cJbfKkN2+1
	x8lnbZDfH1X5Dskz7Zzb6fakd9/16TAqxi4dujERvgHIREB33HWl47qUeCs+amoTH6pD66
	N3ACsGuOMnMXk4lVIcsKl4BsO7YVQ2Y=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 697BZQNt2375606;
	Wed, 7 Oct 2026 11:42:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=pHHS2HD7Q+CA5JLyh
	puDDHMaGA+EpDcZ9dD6ersRSjk=; b=hid6kEKE+VYi0aUX1UbXahSwKC8KhmYL5
	+Ikws6ctuSDPnfjlHB8K5krdwBGH220p+QifHzsHjrO/s/izITQBFDV+2/8mYG0p
	7nppRb6c7AhlnmJ09nYKRuVsRRCRPyGRk6KWUTFuZjvHNyMnLY48l2dEEIpZSWbj
	imVF/LBWWEigLUZbtmzYv92gwjPVr+JzJrixXhMLkr4nMJdL2sUI/ovBY039vDXQ
	gp3egTADOlAAd8dln/t6d+tEm6wcIddNoCLPM+sbMbqOL8RJwXZtiQLt9izcsOXu
	wj4IORSwmAwsRwXYzkWIfrawaxIHtMfnd4pO2iCrdXK5w6u5iI7bQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h2se5n55c-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 07 Oct 2026 11:42:04 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 697BWf0h1841543;
	Wed, 7 Oct 2026 11:42:03 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h5a6dj8w1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Oct 2026 11:42:03 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 697BfxsC6619452
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 7 Oct 2026 11:41:59 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7E2772004F;
	Wed,  7 Oct 2026 11:41:59 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2D98020040;
	Wed,  7 Oct 2026 11:41:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed,  7 Oct 2026 11:41:59 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 96E63160B43; Wed, 07 Oct 2026 13:41:58 +0200 (CEST)
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
Subject: [PATCH v8 14/15] mm/kasan: Introduce helpers for lazy MMU mode sanitizer
Date: Wed,  7 Oct 2026 13:41:57 +0200
Message-ID: <e42d9f02ec1f8478a50fce424b95d0e7ff6a359f.1791365932.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791365932.git.agordeev@linux.ibm.com>
References: <cover.1791365932.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfX5DPD1vMEIRzd
 xleVCrHSsImUVSa9k8+U0VNhK6NPZ4rkedvwRN+pHGmVxse85mJThumaN735FZQ7qT+ZLwoW7Gv
 lMQezcdm0GX0Rr+40UeLZMYz0OG7Wjs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfX7g2X1iUGlT58
 qoF4bC6WFYXBZ9MVGwR7Pf5b2cTZiR08BPqu1ISG5mhomOu15rPA61t7AFAxvef2tBggMTl7U/L
 G3va4UQIxlb6J7zIR7zRzrYd3OwyvaC/6bM5yPlAkKc9gFNMzKeeatuVkwgWaz7Yv8XuvMZk5FA
 SpJy6eje6TISppIe276PGJ8Ik+QNlq19GHXhc4o77ZcoAeXMqJ1bREhgD6F9YL+gE/ZBEI4WaF0
 QYeFhaRABOMEJA0rqjEFHQ9YEjHl172hGhHOE3IfyVoXl+RpJYRsivy3QSn+96F0fzafgx+PgwJ
 eq5G0EB1bBEdP71UuonqU8soJz3Z26sMWYFy/rpiIpZPpMOqCHDiCPZ8zJP9b2SzXpYNbUTFeRd
 LyBl2WjC6/Nk/j+0TPaoSxEqbfdKhE0KZIeaRAdj0owYPBtSOvVCx8+plUOjRCKDZV5mLWxi1jz
 Bhf/XJvsIMWV1oplDRw==
X-Proofpoint-GUID: Dicociyuch-2AgzrCM5waLHvo_mDtbuk
X-Authority-Analysis: v=2.4 cv=UNRIjyfy c=1 sm=1 tr=0 ts=6ac6300c cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=bocLCBUijn_7D3B78osA:9
X-Proofpoint-ORIG-GUID: ReRFxk3b6iDzlnLcBGQVeXTs5QFTGZJn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_04,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610070046
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4C48414000C
X-Stat-Signature: ey7793c5u59nddd81893dxn33kni7fhk
X-HE-Tag: 1791375870-165692
X-HE-Meta: U2FsdGVkX180WILK1shS7HmWMCR0BB+GnCgUPeLpM2Fsl3MxdIAs+xYrKqZrcT8VuEGYdD6c66C3tIMZ0GM9P6u02ajdH5k76EHG6ard0GJygW1eQwaDJnxAz+RqEP0q44YvpOQWINbhx8AnXXHp7ZZgYJMA1U74WNfEGa3Bao3tFraiSp/9M/KhcjfYMJC7VXO5AbxDTmEl6UQR2ZhwrwDlKz/R5ANKdZmorcvz2Zt7CYPOPj1zOtgshPKlSeg70LVIPueRPv7jOIS5c1/+gmQPjeu7Sb0sczPFQBB8kmDV07LBv6K5STQBUiB3D+vAAZA+H3TG2fH9pen7s4Q74imxnbLYiOZ1aorwccMtAo+yQrhw6EhJxd0GkEV6Y/jFPqkijo/DCsYInvv0CfqSuOTGtH2+ojvvP5QSxUgt+/WPF3QgEkRYTgj4PQmqydpz55DlvMWPtDe/th/Qdo2oSCTmwq8LFQQfaPbkX6g2Cu6/8d+Z6GdehpHGF2mGtlc9kjfMRTIeuoh/UDV/YOwMSZcQARDmUevX8EYLsL3Duj0ScoBZRNzzax5Zkr8dPjwJ7OspJ3UIV4/VkjQw3Fa7EM9VqT1TqZUu66s6Ia2sdqJb/9FSTYtJDhUxiBsc7PzHUYfX29LWX37rdAXWC/tXYHdpuTW1XAzyfyqgyEd6y4IAfqPc15a1KYqS58NA0zlIbxjwCxl9WEMgKUBpxq3jmjQ5PB3Ka1sYdUvN8JzIzzsLf4VIiX1nZ9wWSpQpx3GPrCMm8jBA6iZj5cXKb4U3uHgR+nkR45mbRcuJSv+ph44TB27M1dCIWsYF4Xc0EiC+qkEcfQKxUGL/orGAGaWQOHgUyzHbyK+YPZtqA8QQ+80TQNcAMPvx3TshgBpC15FkEK960LCTiVlhQbjsotvErAjyws/+qg4HpYixH6GMZdmhoVglcrDNbW+olwbB3JRtKlE/DclKQw6KC1vY64m
 JkcKCbZG
 1gl++9EIYxdkSGdOGdIaaE8gogQQ5e/EHkCB0jerAswS0GhLC7T/3PDakKF3puSdbtCAS8rOBYWhISZhXPIq0HGqCXqEA8FiJoXV1oo99+fABribJNaJ6mGo6CLyTg5OCbVwGH3OmYg0t4P1ckAD/7mEb+F8zDGZAeGQf4oFFCydefOp8FWhjarw+hmdzHBKxIvOiFX8y5qiCo1fXzbGOoHf2gwh0QFnOnIbxRDQH2MESTxG6EPa7RTO8XJvBzA/W9LLf/lvw6VnDTzGKc0YPts1O+R/o7sSZtrWchB0LCyxbKSrIB8l8hDFxFeJZYjqlaC9pq3vRu8HivT7quX8YT0jZvVjtqVLhu0NyfAPb4GkWBRdvXzNfY57Z8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide helpers that allow architectures implement
illegitimate PTE direct accesses while the lazy MMU
mode is enabled, such as:

	pte_t pte =3D *ptep;
	*ptep =3D pte;

By contrast, these would have to be:

	pte_t pte =3D ptep_get(ptep);
	set_pte(ptep, pte);

The direct PTE accesses pose a real issue on s390.

Suggested-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
---
 include/linux/kasan.h     | 19 +++++++++++++++++--
 mm/kasan/common.c         | 14 ++++++++++++++
 mm/kasan/kasan.h          |  2 ++
 mm/kasan/report_generic.c |  3 +++
 4 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index ff41949c0ac0..01f710f03114 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -6,6 +6,7 @@
 #include <linux/kasan-enabled.h>
 #include <linux/kasan-tags.h>
 #include <linux/kernel.h>
+#include <linux/pgtable.h>
 #include <linux/static_key.h>
 #include <linux/types.h>
=20
@@ -35,8 +36,6 @@ typedef unsigned int __bitwise kasan_vmalloc_flags_t;
=20
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
=20
-#include <linux/pgtable.h>
-
 /* Software KASAN implementations use shadow memory. */
=20
 #ifdef CONFIG_KASAN_SW_TAGS
@@ -134,6 +133,20 @@ static __always_inline void kasan_poison_slab(struct=
 slab *slab)
 		__kasan_poison_slab(slab);
 }
=20
+void __kasan_poison_pte(hw_pte_t *pte, int nr);
+static __always_inline void kasan_poison_pte(hw_pte_t *pte, int nr)
+{
+	if (kasan_enabled())
+		__kasan_poison_pte(pte, nr);
+}
+
+void __kasan_unpoison_pte(hw_pte_t *pte, int nr);
+static __always_inline void kasan_unpoison_pte(hw_pte_t *pte, int nr)
+{
+	if (kasan_enabled())
+		__kasan_unpoison_pte(pte, nr);
+}
+
 void __kasan_unpoison_new_object(struct kmem_cache *cache, void *object)=
;
 /**
  * kasan_unpoison_new_object - Temporarily unpoison a new slab object.
@@ -414,6 +427,8 @@ static inline bool kasan_unpoison_pages(struct page *=
page, unsigned int order,
 	return false;
 }
 static inline void kasan_poison_slab(struct slab *slab) {}
+static inline void kasan_poison_pte(hw_pte_t *pte, int nr) {}
+static inline void kasan_unpoison_pte(hw_pte_t *pte, int nr) {}
 static inline void kasan_unpoison_new_object(struct kmem_cache *cache,
 					void *object) {}
 static inline void kasan_poison_new_object(struct kmem_cache *cache,
diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index 7d21c4db68d2..f3cbbeb8ad0e 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -174,6 +174,20 @@ void __kasan_poison_slab(struct slab *slab)
 		     KASAN_SLAB_REDZONE, false);
 }
=20
+void __kasan_poison_pte(hw_pte_t *pte, int nr)
+{
+	if (IS_ALIGNED(sizeof(*pte), KASAN_GRANULE_SIZE))
+		kasan_poison(pte, sizeof(*pte) * nr, KASAN_LAZY_MMU_PTE, false);
+}
+EXPORT_SYMBOL_GPL(__kasan_poison_pte);
+
+void __kasan_unpoison_pte(hw_pte_t *pte, int nr)
+{
+	if (IS_ALIGNED(sizeof(*pte), KASAN_GRANULE_SIZE))
+		kasan_unpoison(pte, sizeof(*pte) * nr, false);
+}
+EXPORT_SYMBOL_GPL(__kasan_unpoison_pte);
+
 void __kasan_unpoison_new_object(struct kmem_cache *cache, void *object)
 {
 	kasan_unpoison(object, cache->object_size, false);
diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
index fc9169a54766..1a2d18cdb21d 100644
--- a/mm/kasan/kasan.h
+++ b/mm/kasan/kasan.h
@@ -144,12 +144,14 @@ static inline bool kasan_requires_meta(void)
 #define KASAN_PAGE_REDZONE	0xFE  /* redzone for kmalloc_large allocation=
 */
 #define KASAN_SLAB_REDZONE	0xFC  /* redzone for slab object */
 #define KASAN_SLAB_FREE		0xFB  /* freed slab object */
+#define KASAN_LAZY_MMU_PTE	0xFD  /* direct pte access in lazy mmu mode *=
/
 #define KASAN_VMALLOC_INVALID	0xF8  /* inaccessible space in vmap area *=
/
 #else
 #define KASAN_PAGE_FREE		KASAN_TAG_INVALID
 #define KASAN_PAGE_REDZONE	KASAN_TAG_INVALID
 #define KASAN_SLAB_REDZONE	KASAN_TAG_INVALID
 #define KASAN_SLAB_FREE		KASAN_TAG_INVALID
+#define KASAN_LAZY_MMU_PTE	KASAN_TAG_INVALID
 #define KASAN_VMALLOC_INVALID	KASAN_TAG_INVALID /* only used for SW_TAGS=
 */
 #endif
=20
diff --git a/mm/kasan/report_generic.c b/mm/kasan/report_generic.c
index f5b8e37b3805..489d4a8d6902 100644
--- a/mm/kasan/report_generic.c
+++ b/mm/kasan/report_generic.c
@@ -113,6 +113,9 @@ static const char *get_shadow_bug_type(struct kasan_r=
eport_info *info)
 	case KASAN_SLAB_FREE_META:
 		bug_type =3D "slab-use-after-free";
 		break;
+	case KASAN_LAZY_MMU_PTE:
+		bug_type =3D "lazy-mmu-pte-access";
+		break;
 	case KASAN_ALLOCA_LEFT:
 	case KASAN_ALLOCA_RIGHT:
 		bug_type =3D "alloca-out-of-bounds";
--=20
2.53.0


