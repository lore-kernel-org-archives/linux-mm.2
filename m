Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2E65C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:48:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF4FC6B0159; Mon, 13 Jul 2026 12:48:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECCA16B015A; Mon, 13 Jul 2026 12:48:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBCA56B015C; Mon, 13 Jul 2026 12:48:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A00B36B0159
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:48:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ED904C06B8
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:18:38 +0000 (UTC)
X-FDA: 84983959116.29.79F48AE
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8D886A0007
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:18:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=IAu7vwxn;
	spf=pass (imf25.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783952316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2vl0RvV9NekKqP5eY/XJThSoFdB3ZQjbMNiVfPbkbRs=;
	b=323vC6xOD+D5uHPG9LoianYjPN/NsnKMUTdecGAtpiWIsfy34oA3IRxLc3gQJif12D29n4
	GNKdvhIgkQ9Q2/TwtEAsAw4KCdvdK8ggYvcslDY4ZWm4vOzrN1cz7OxDXIriXAVPr1TrOf
	yTDCrCpicvTuizv4gaKU0z5WlZk6FFo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=IAu7vwxn;
	spf=pass (imf25.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783952316;
	b=8diG9GtJz2q2iJ9X+q7+kCt9SBFbJrE4WhIkCoSYJd4dkvyw2lK0DdYD/SKCpyNYt8yt5c
	JO1/e6jZ80sLSFL6y/uYiCOw9QNqqXljEuWZm6CeT11gUJstph8Uc2DrqFzbE05R4mZtNO
	9JvrZEsUIyqNVXxHAEd6umvuI1B9BWA=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66DCCxJ02433473;
	Mon, 13 Jul 2026 14:18:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=2vl0RvV9NekKqP5eY
	/XJThSoFdB3ZQjbMNiVfPbkbRs=; b=IAu7vwxnbvNMLA1uCK0ng2nE5kW1Wq+lH
	1gfKv45Ewei+jomoTIIRuR9zlJxwXQTg3Z7rV0o1MJPhPQ0nl69UEtNKII/DtbV6
	tsW1YQeBudDwLqM23/CCfihj3C3SXh/B1ZZJL472HehTPm2O+zIBMWsu/fef+RMW
	bq6MX9xZZxpt1wVSbY8/kiUrQuxiqhu7BtU7RxZDeJ6V6eKUEcTAeYFi6hIJ+ovj
	3NqtTvS3L2p1Z8KJvHq40fWECkehsHmTcm+rskSJ/vWtZmxfiRmZ6Xd4dNEutGYZ
	asKWQiyOwZA1CxLieP9c5VQJa8ffLSophYbuS+19uwexq4XYWYOBg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fbegbgrkj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jul 2026 14:18:32 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66DE4iUU025308;
	Mon, 13 Jul 2026 14:18:32 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fc2uxwr3e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jul 2026 14:18:31 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66DEISpd14418342
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jul 2026 14:18:28 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 393182004D;
	Mon, 13 Jul 2026 14:18:28 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 13E9320043;
	Mon, 13 Jul 2026 14:18:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 13 Jul 2026 14:18:28 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id F27DD162522; Mon, 13 Jul 2026 16:18:27 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v5 3/4] mm/kasan: Introduce helpers for lazy MMU mode sanitizer
Date: Mon, 13 Jul 2026 16:18:26 +0200
Message-ID: <38a663eeccd060d961990baf65338e2f2550e580.1783945507.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1783945507.git.agordeev@linux.ibm.com>
References: <cover.1783945507.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=fOcJG5ae c=1 sm=1 tr=0 ts=6a54f3b9 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=iFyILk1haAFnC_s91q8A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDE0OCBTYWx0ZWRfXy1I9EchAqqyO
 dXL8Pnx9oOjgJN/nfv563MDUqGvPiSRS+wsivCrOONCRp5LF4Wmhao9QoGBvrmws4VeUaGvfQ+t
 8IEN1s2ncYpk9NV0roZqtfbTPZ/A9w2vMw4v+FUkwBzgrsTOqqnYMtenhKtnE8VbQ7+2FaPYSwt
 vR5YRrQvblKdKbvQK2pQvKcMTeAWpLtFxLlL5bMiEq19uexQ80E0sW6oK/038XoWzqht/ayBtPs
 5fqxSr5vdpf8auvOq8OeAfc8lXHp6T7N71cqs0QDh3+RP4MmDFQuv61Hc2YAq8lIs7ZGi6XZYFu
 Y7oCIYYWkPp2b50gNY6c9X9ihTDboG3EQ2pGxtO673U0BPSZrNTkvW+BdcTAqcoeDAsZbXGyoWj
 XV2MXJAr+sP2/OXiSHL+YcCAcqLiGQFgUDgXpItrgSe9iIsD1DcK3uPSpWxWU+Jwck2KdDXYDvM
 gx6L3TOMbS7ZiRzCnYg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDE0OCBTYWx0ZWRfX2MXCilhzZkG5
 0oHQF+aUOwwDmM7CK39kg+KtMEilOiDOb+lySdlR+A+AqGFsfZlnH/iFRgY/wWGIHjvHFVsTq0S
 mhq/Be1YZHBMCU0lxhcfUEbbaHX1VxQ=
X-Proofpoint-GUID: fbeKGc689gDMosGxsekWQ_xt2MkGAW4U
X-Proofpoint-ORIG-GUID: vqO7vk9TXadg0UNw7zBHzra_XtR5hBsV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_03,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 impostorscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607130148
X-Stat-Signature: 5d95z8tkt7nfzm4zwwqk7sx8ye64pz65
X-Rspamd-Queue-Id: 8D886A0007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783952316-360185
X-HE-Meta: U2FsdGVkX18BEaJ3uFPvsNicK47gSE5HfU1SIfyKLQu3yLgn8Wl2t6lzg3gd43Gc39T7r5lHzne2fcQ4DR8DwMzRZyhAiRUKv19+2fTWzSRtDg0+/eL0TUyGSucu6lA2/EGbbB2Llzse/T3mp2QzypARFwjSxdZNx7t8NNl8KCjcE2eg30jz59Cl4KNzojmMaFt+lQCC0NuUYxs0PjY4FFhQn36V0teZWfwJumLG0cGM0wbfEmjr6xTCX3NhmkmmanrIqy7OlJ+K25RdamGQLcERAvXMpOIqBmsBumjBX6QwoFR+STROGFnVyU3LqUyRMXP5rI2br+N5+DEZz3bAzMCmCP9Vub0P5mOEQGWpM/4BR2SaMwKUFxc2+ZgGEU/ntKdPt7/qxR2+9Bq4j+Q/Mk+CXnMRIuT8OmTaqTJqSWxApigKEmtld3Fjva/cGJIXwKU9bJvk49Gil3WJHtAkNn03P18AQXFJTYPiI8hOYqPGWdvUzkX3bqVMsnPr8vBgvYr0fpkfd34MzLHiM/WNq6eIZlrlLoHfAizZvHrH7Ec1k19LkArw19BP3OA+ri52I2631FEUXonclW93Exjk2tyjD2AhvWYbke4U1mtw7CwGTt1mVB0bhaCsIVbSm4VpAvU3rLPPG7cnw+ph4p2hIeO7823bCJMBVmGv2rtTqGH7/R72rNDOKWTvNMzwY+VPnpfN4QfXNmPOPdf0BqBOWYnAoHGoV6QDnc8d7qHzrwNOuC2zYthILOeMwz0+GdByyW3BTcsc2/jP5MVMCJPz2lqZ0q9kSfuvTLTY+478i0qB5Yp5FnnsC+ttZiFV6F7aVgYoF+gcj0N396baVtLBhBSi5emwdS1tOsSw7i70GAlSjxg/vv7KZowwFCsabZA+44edUjbzrs7epHunPeWTzuEvc9F2OWAZg59TJvQfzY5T80lQDVL3/8mL3GHAUGkyD/zCfO7r2PzibW3+UjY
 d0a4Et1S
 hKeIV93bWdi92lg/6hoQcpuYxR+jDqOHaOJ8jRucJVJs+ZGrP5GvsZ7vSdNGG+rSkyhbr8lEUFrpU5d8yNav7JBvMJkxo8arueoYBNreA/RfuBqx96pxH+jSIneY7YE/JQk0gwEFZYxbGw+sdg4mZUNr2AwLKjz3JAFtKvfvYU1ZOISUwWEmC4dQHL0HG/8zRhs+aBg+ubYTfLNdwYK77VuUfvehRGxes097cAfppldFAZwEkFAIEOYFduGz/CaL+OJPT2mAgubb4eayoY2jCCuBu1da7XAirHraDn3nR8JxW1crWwE4iIZDfG1WuECOpOI2G9io7TewJR6TKRrqxM9msXrrg3EtOpVps/bYjYXBUe8BdpcS4BaQWHg==
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
 include/linux/kasan.h     | 16 ++++++++++++++++
 mm/kasan/common.c         | 10 ++++++++++
 mm/kasan/kasan.h          |  2 ++
 mm/kasan/report_generic.c |  3 +++
 4 files changed, 31 insertions(+)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index bf233bde68c7..deadf566b84a 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -134,6 +134,20 @@ static __always_inline void kasan_poison_slab(struct=
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
@@ -414,6 +428,8 @@ static inline bool kasan_unpoison_pages(struct page *=
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
index b7d05c2a6d93..cbf68680614e 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -163,6 +163,16 @@ void __kasan_poison_slab(struct slab *slab)
 		     KASAN_SLAB_REDZONE, false);
 }
=20
+void __kasan_poison_pte(pte_t *pte, int nr)
+{
+	kasan_poison(pte, sizeof(*pte) * nr, KASAN_LAZY_MMU_PTE, false);
+}
+
+void __kasan_unpoison_pte(pte_t *pte, int nr)
+{
+	kasan_unpoison(pte, sizeof(*pte) * nr, false);
+}
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


