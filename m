Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A895C5DF7D
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 11:33:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B04B6B0434; Mon, 17 Aug 2026 07:33:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 321E26B08A2; Mon, 17 Aug 2026 07:33:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 126D46B0546; Mon, 17 Aug 2026 07:33:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D00066B0434
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:33:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D71F140769
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:33:11 +0000 (UTC)
X-FDA: 85110550182.24.9213A08
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0A280C000A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:33:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=KTHToFiC;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf22.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786966389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jCoOcIlPM4QZnTVbE1S4wqZbwstR12KhLcPHqV9Sp1U=;
	b=oIA1E9styr4celgnEbK9nM/jT51CQLpQiXlkcZJc2DUyXmGmjNg2q6gJfhguBLTRBPW+wA
	jpxJg82MjSYzInWPL3xx4csRueOXoqSMWDIi/WtyshiHCcpUQbJAD26c90cAtvZBMPoDUs
	b7Xp4QOgBaxJLMcP63g4APuyOaK8R4M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=KTHToFiC;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf22.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786966389;
	b=o1nafd2k69teFtPIIeLIiVu+VNgag+O5vSadlPbryc5xuA+BMRG4P+u40PscH57h+O5DMh
	HL/t7FZu9dIlNxDSvdk4QzJKGCLcUasy0L+r1d3XLAfgUVctb0Ky4e5ksbfkvXRChzn2gA
	xh+pG+QFYzkqWFGPAkPNoyGmO9P9jfw=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67GLWEcj3780952;
	Mon, 17 Aug 2026 11:33:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=jCoOcIlPM4QZnTVbE
	1S4wqZbwstR12KhLcPHqV9Sp1U=; b=KTHToFiCYd4xiQmJko2La7ytq2r+UbFKx
	PqgvbOB/dhrRHa4moMw96nA8UF0eS8NQlGiQ4qtNx09/Lc2g4bMyJ5QEMuJEo0oA
	jbPtefyOq8J9sD5L4/rkgk3M7GdKVyguSZgP7WGzmTMu03xtgTQhBZFRyy63jB+/
	CjWWa/PbLNIva1eOhpMHdHFHeJ5wqXYFOULM+jFbA8yDRdp6NKS3gn65xWUTf1y0
	jxD8FaoZyVbxM7lAw4NKUUTm1FbkKFG07mKSposYseVpU4baTEddUsxII8Ae2lTT
	9/rRvVfbgrQ6NtN1cIDnln8CKJCbyLUXMP/AAAaymCCaT8GzWE5YA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2frt1m4p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 11:33:07 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67HBQWrI022977;
	Mon, 17 Aug 2026 11:33:06 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g33ejwtvp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 11:33:06 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67HBX2bZ49217894
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Aug 2026 11:33:02 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8DEC020043;
	Mon, 17 Aug 2026 11:33:02 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 637D720040;
	Mon, 17 Aug 2026 11:33:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 17 Aug 2026 11:33:02 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 4520F16158E; Mon, 17 Aug 2026 13:33:02 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com
Subject: [PATCH v7 3/4] mm/kasan: Introduce helpers for lazy MMU mode sanitizer
Date: Mon, 17 Aug 2026 13:33:01 +0200
Message-ID: <52c9be0cf71a8896a5d76c148c38fb24a2005dd9.1786956464.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1786956464.git.agordeev@linux.ibm.com>
References: <cover.1786956464.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=OfaoyBTY c=1 sm=1 tr=0 ts=6a82f173 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=IbWDVZlrxelGz4sJbtUA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDA4NyBTYWx0ZWRfX/+4fCm+gB8G5
 2RiCBOZ5NlJZvsXwGYWFydnkDo34qYfthGKQCJbUOyHaple9d98NY3YLKRwJcf8gpEWbHvnrMeH
 6JGJFsmPNeRAJne6CexoFGMml+6ch3M=
X-Proofpoint-GUID: MvG7Ke4FAqGi8_-4CsoJlgvNnyj77p6-
X-Proofpoint-ORIG-GUID: 4FUd8_M_4TIG6n8IU5tDLQ4GcyZLYqRk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDA4NyBTYWx0ZWRfX2eQZRCnxwWvx
 fnOALfM7tJTiqmdqDCg2Sh3ONESzXkCr+X1GA28FyKgpDC5mykDFi9/t/tWux/SVU0/VKfTKo/4
 hQe/fvG15tB0Y93meOzvepWHC7N4N/Pn6taHrReNlTpwQs0t414PSXNzlxqLFRr4OnLUHv6BNHd
 RBnp5EvYzvRa9EnXIBDTnBo6waavwhrorFitsQbqvyCQyJO3xAryNiRmn/7vw13gY4PhrX2D14Q
 48ACbzqux7ufXqtCg/MvzYSidJSpy/k8w2Ah9AuEW0tgKVVi0v573LgwY1FclMVYUsLKbp7XKoI
 Iptwv1An+252M8/k05KhTS3/57P6hkuM+qM7A6uaXLxiL5XRFwGO7z0mfk8HvCqL5IaE0IDbeDe
 u6bd6Z6VFaDVFKAkJkh1KCfhtl6lN+BvUQriRuelMo+le0w2E4nW6+YnDk+Zud0BG+8pWxDHJgu
 nvqBVX+EBEq+16SJyxA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-16_06,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 phishscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170087
X-Stat-Signature: sboqnogk3kbuiraoj8ommmgfrccnhacj
X-Rspamd-Queue-Id: 0A280C000A
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786966388-343459
X-HE-Meta: U2FsdGVkX1/HvwtmLLZSHKTdmCubL7wfeBAE1wSARqkGLq+h4OzPnNOnGmFvdb5P6qvY5+5p1kkXJHvfH+5uGxYCH8u8OTEf+G/mLibmcokR05xL3ixFJ00yhMJm7ujYPCAEGG8BkfnfFCZM8a8QADIpwD31g0R9xdS+SOfalhbk3gOAwqaXljo3U5982CixkeVLM1vl0G52j1cjw9rd8sDL40VqRA5isd50eI6AlF3wi9XPVWkgxgOaKwkMCBOKydI8CmNPTyQJlozr2p5MnGJe4Ltuau4DMFWk167c3B65jM8yVTNK9E38yuzmvv1b3FWpJKC2e9+zNRrEZ387/LkS6kC5PKBEJ7ie6Yryfxv5s5i1DLXLCZbNjX9G4DnfKwOkntHrYC1Pk6VOjfFZj7pNVsiF6UtHb10EcSagHQXvKJOARA+OlhHPyo/AIZVNwZDXxwX7Dz9u3WV1qRzM99z1zMRzWicS46lEP8e4MPCwIrVa1yxcSoiGuIJvIhvJvckEMJG0SWQZCbd23IdRvbn+MT1u4I1PMY98g2N9Va2+B+GUc5EC9NfEpnMUWSE4HVwCZNvDqk8yNSvx1cyfupLrfPfC0uiSO6hv4lptHBGC5+r87oZsyoPg74IAPvk/1V/O3qOeTwVqohoisCsoeH39A8gGtc2d6O8iFjb4xBHsmV/A9catgS6lAC+A/OXp5OwV7DRJkY2ziflSMpXq7iNdM0roh1SgV55J/UDW+2W0kshSGYwsRBDk70GfM0ZfrSpdTgwIaZI+A6kCwc9Hum/a0E061gFTI159cPg/Q3Ew5wfz6Wb4eEjTymQlRDYtfrWUm89UtijqJk2DKbdJb2pGkhIzQP4OI1HqTbOAeTJTz3UnxuKSDJWDPyqQ2pIk3eyUNd6jCxGhJlIN7BJeD/VTBOGyD2TSvE9rok+pXvUCmqnliYIAi0j2QEQY/8R12huGN8yPXrO85KX940K
 C5Moed7U
 xL4elqyyvQJPKy6ly4DO40iOAvHwHSjTZz6/5NkiZgrMU6prxnF4PQd3iA+ZlYcCwMVCgLCvqRfxVUiBKSW2hPeHN7TPDqrE+KqvV12OlpPg2d4+66cUmvQk/+LdSi1q1OGH+m6Yf9Gb663/QDpWVDJFyh74X4dG4ljQFCQP8lBCm8J5FApsw0Fo8eUYXcH8Jfuwng89tdNUT6j/eF52WDD8M6yld8sFResacbtilg+LiDavc7YQSZMn4c0J7DNpxdGvjEb+IILfa2P74ORf5/yjAxA==
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
index bf233bde68c7..1aa4d9dd2485 100644
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
+void __kasan_poison_pte(pte_t *pte, int nr);
+static __always_inline void kasan_poison_pte(pte_t *pte, int nr)
+{
+	if (kasan_enabled())
+		__kasan_poison_pte(pte, nr);
+}
+
+void __kasan_unpoison_pte(pte_t *pte, int nr);
+static __always_inline void kasan_unpoison_pte(pte_t *pte, int nr)
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
+static inline void kasan_poison_pte(pte_t *pte, int nr) {}
+static inline void kasan_unpoison_pte(pte_t *pte, int nr) {}
 static inline void kasan_unpoison_new_object(struct kmem_cache *cache,
 					void *object) {}
 static inline void kasan_poison_new_object(struct kmem_cache *cache,
diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index b7d05c2a6d93..94d106094989 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -163,6 +163,20 @@ void __kasan_poison_slab(struct slab *slab)
 		     KASAN_SLAB_REDZONE, false);
 }
=20
+void __kasan_poison_pte(pte_t *pte, int nr)
+{
+	if (IS_ALIGNED(sizeof(*pte), KASAN_GRANULE_SIZE))
+		kasan_poison(pte, sizeof(*pte) * nr, KASAN_LAZY_MMU_PTE, false);
+}
+EXPORT_SYMBOL_GPL(__kasan_poison_pte);
+
+void __kasan_unpoison_pte(pte_t *pte, int nr)
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


