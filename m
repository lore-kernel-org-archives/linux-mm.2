Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEF88CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 20:56:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D24216B00C6; Tue, 16 Jun 2026 16:56:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFB846B00C7; Tue, 16 Jun 2026 16:56:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C125C6B00C8; Tue, 16 Jun 2026 16:56:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88ABF6B00C6
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:56:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BEEC41655EB
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:56:57 +0000 (UTC)
X-FDA: 84886985274.30.7CAB7C0
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5D8BF4000B
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:56:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=oCoxpoX5;
	spf=pass (imf07.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781643415;
	b=BkCLUbni2Q4ZUnNmfSG6LeRS3ZDcvBvaNKp+RiytwpilmSAyhgwg5hU6cMt4G3G6n7Y014
	WM9270OWEXA2AYZBTlWdQlIefC5DHs28KIxXsHKiZhscZB06q/WJK9JKNIFWXpa1wMcSlN
	4bBi/uKEm46A1s7mn9RurMlt40r8OEc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=oCoxpoX5;
	spf=pass (imf07.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781643415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S+RYyodoiEOwvmJG/H2wYuH2wgz201TLMBhdk5m93Lk=;
	b=NjgK7nJWYzmaJYX2G3CzdHYtWCkn6UycgnMqHFjcEc19ZjMFxP73LjJ67+muW//2WIHVyB
	9tgBdKpPhwxxQYNu3WzNlPQPQGJKR5nveClbA6P7Addsr6AOcaT/Ex2/O5g9o6clZ23ICd
	Eeygl/YSuk+xpg83C4Fbdz7U+gMrQBU=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65GAIZ6D1135440;
	Tue, 16 Jun 2026 12:40:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=S+RYyodoiEOwvmJG/
	H2wYuH2wgz201TLMBhdk5m93Lk=; b=oCoxpoX59P92YvK79RTZMYpthmeejPN0X
	aO7DmnbIuD7XpA55DtKIkTxiCfom317xbF8eWLe/oVP76OYHPLmWr2pPtY1HO56U
	mtlmM/w9/Q5MnmiV5ZXKkJYymdb5whtpqyX/eGEoW6DE2j5KFTUW0GvW2B2SybNp
	j3jkX95BsYBojzNmuaCFThKSu8ESlMMzEUnyTXLAMYQWAt/Yso4R/2DerrHOBarz
	35wxtJvzeL0yiGuGufdQ+WBezuTpysRrEdG8LPv5+DFTHV5fvoLM1EMTZJpVGo8D
	B427pDyRGTPe3PrJ7BVIS0l3v4tTrDr6+HnJEbqPuueCrzGDGVGKQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4es1u0n49t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jun 2026 12:40:44 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65GCYfUu012946;
	Tue, 16 Jun 2026 12:40:43 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4eshhq3g56-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jun 2026 12:40:43 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65GCeeVP49807624
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jun 2026 12:40:40 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EEFF12004D;
	Tue, 16 Jun 2026 12:40:39 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D71DB2004B;
	Tue, 16 Jun 2026 12:40:39 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue, 16 Jun 2026 12:40:39 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 91FF6E0E22; Tue, 16 Jun 2026 14:40:39 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Kevin Brodsky <kevin.brodsky@arm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v3 7/7] s390/mm: Lazy MMU mode sanitizer
Date: Tue, 16 Jun 2026 14:40:39 +0200
Message-ID: <acd583d5f511732e71a58f251946672633494462.1781611976.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1781611976.git.agordeev@linux.ibm.com>
References: <cover.1781611976.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: plqkqvHnvkamyE4tfbtUq-q5Y-lDPAF9
X-Authority-Analysis: v=2.4 cv=XdK5Co55 c=1 sm=1 tr=0 ts=6a31444c cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=DuHJb5c9rUSq-GGRdagA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDEyNSBTYWx0ZWRfX6m3FmX6pAI7x
 PSot/bPU7kdQjSqBGg1WqAAlJq4aal10WFtZPKEa8sxGgcgXxZ6Rm1tha3P7wCyWKJZlb7MSnbp
 IC9V2k39SzVtnonkq2e1t17uCtAHzy5B0ZJ6DigcbMPNU/hWIRcXZrzkL/MVYxJpthB6/W7mLVO
 1lcLnUoCMHuZYJRU3lBnsrfYTtJ9mXIZmeceTKyWsdQtY25tdJOyfYIeA7VFF63vXquvnFVzQkL
 +wL48wWJAsd4CnzdNgydS/HIz22hYGpaqen27+NQA2GokQLvHE1RHVwgeMx0t5pljZ7TLfgqYbv
 1KtNlp34oX3l+1aOGTeBFTeJZU9QaKyAQe8TleiquzFCHtXsnzdNpIKu3a4c5HdxiF4sRLsIsET
 WCH/EI45pIgYm9fWPP/80w4ENbiLxm7iPlR+y5eh5wo92+gvJanhUSX3+5M5qhfRJ9OsIh/Wu53
 avFGXaFnEQ/CN2gYJpA==
X-Proofpoint-ORIG-GUID: plqkqvHnvkamyE4tfbtUq-q5Y-lDPAF9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDEyNSBTYWx0ZWRfX1ghW6ZRPp8Cl
 rSbM1Ljx0rwYHghF1+O5r2j3EYXl/NFEAWo1YXiyu/tVpgCJOwtpAgLzvJN2JJ6SH0DiLhpxoz/
 cJB+Yoj1RxAgLIP/mIcFrNXEIJDrD60=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-16_03,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 clxscore=1011 bulkscore=0 malwarescore=0
 spamscore=0 phishscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606160125
X-Rspamd-Queue-Id: 5D8BF4000B
X-Stat-Signature: 5bsz3oxt78a5pcrhbwicfqyosrye7bfh
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781643415-229992
X-HE-Meta: U2FsdGVkX1+3CrAYLt1QK4lDpOWtlLGVm1ty/JWwtX8PJsoTIcb2BcDXtZGGYkpM4fPbCxG4MacJ81uwl4HV8BmHj9J2mAziqjPj5s85TTT1Ll8EeFLl6KQlEEd6yAjYRSvM/TAuoO1Cv0ODF6QrE3KAw8Hp4rEKuNygG+n/TsiCpIVNNgx8onKdp7Gm6WJWsP6pNHmF4yfwLWlj3IVTjAq3A8qOMmZf8lGhaX06oe+YPMlYlyvRyP8BugkwQ1KrDGBTkxk17/L0YFwTEF9BHCAk8+1N5L1af03XE7wh33n+ZxACcTThca4rjS1MVzyqG2JgKmmxN8rfzTH1tJkWtdVR9NnnyCsejLIVKvoF6jgBsZM4gPVqucz5QOv3kRebA4jVPDZjVA+eW+16a8g0KzkPF3Ka6H6GTjjfUl4tgcKID7vWSwELZ8IBw2TTvFC0UxubfREmV4VL+/MqHK/Tfue5T4E90whIzN/slVrSu+mlZGSxzxqXsmwP5qhBTyYMtRolHPKsWZPPaxFWQvz0yBxSQgI6nk8T9CD/SWnobg/OGd3YRkXlBIFC4tA35Bu7o88YKcAHtu9X62TFLzabKB5bhaCBiL6FrcXPKTJiAzvYuHbJdi6NXRWGe4rw8HBBC9OcdMGF78lxaCEjyYHVq0fJcs99lpFAdoHfLKyGMZ2IN67p7u9cQCGgKxZsKgqaMd9u5bwmbxH/YruZ0qloVNwtwdyelu+Sj9E6aJ96pHDri6ZFWlm1rBW5+kcaYdiHPyaIw7wZ0gi0ltVm4uB7G2ndeKm375vSV5FsfpF3TFv7iPm60Kjxwrf0hsCRHNzAzZKn4gDWn2a7PaSl3te9206oZWvWN04fbmhyCmRWm/GX7S0UXpfpfVon69F+/R6LJTKTB+4NxgBq9CNIkm70Ri9BpCQ1JOKQ0MQvu2BLH2ioSHtVg4mDnfWy+v7dU668FzMQ0awWLBi8IIj9TXT
 z7g7+fFi
 DFKDD+8ii6L0Ora7ePz55jPtNNXopllq99rXGaUcO7MS6jgF2nuThykDuiCeWrTaW+CzOE/58pGD7ryphgv+k2VjSLMyBqiiYUGr4Sl0ickqG+lAYIot8IUku+PfJGftZeK/n6abjQf/kZgsDY1khUwCVo3ZVo3sre8z5n6SIKnleklDMcNn75nGRz99Oo1tIQ5/dQ/i1sS1vkjQsGcfJkaPX6eWutDMF9XVqY4C8oe7eIrz4HdzWwaNoGUycv+uNJ2x2GUsKkdPyoAfVlOsyMjQ/V0nF/SPVLLdPGz3NkX3YWp4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Detect PTE entries access in lazy MMU mode by means other
than set_pte() and ptep_get() primitives, which would be
a read hazard.

The access to kasan shadow memory from ptep_get_lockless()
mistakenly hits invalid access in case a concurrent lazy
MMU access to the same PTE is happening. To avoid that
disable instrumentation for ptep_get_lockless() altogether.

Suggested-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
---
 arch/s390/include/asm/pgtable.h |  6 ++++++
 arch/s390/mm/lazy_mmu.c         | 27 +++++++++++++++++++++++----
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgta=
ble.h
index 2b6659d61fa5..a93e7e786457 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1047,6 +1047,12 @@ static inline void set_pte(pte_t *ptep, pte_t pte)
 		__set_pte(ptep, pte);
 }
=20
+#define ptep_get_lockless ptep_get_lockless
+static inline __no_sanitize_address pte_t ptep_get_lockless(pte_t *ptep)
+{
+	return READ_ONCE(*ptep);
+}
+
 static inline pte_t __ptep_get(pte_t *ptep)
 {
 	return READ_ONCE(*ptep);
diff --git a/arch/s390/mm/lazy_mmu.c b/arch/s390/mm/lazy_mmu.c
index d75b93d9b0de..ee2385897bc7 100644
--- a/arch/s390/mm/lazy_mmu.c
+++ b/arch/s390/mm/lazy_mmu.c
@@ -63,10 +63,13 @@ static int invalidate_pte_range(struct mm_struct *mm,=
 unsigned long addr,
 }
=20
 static void set_pte_range(struct mm_struct *mm, unsigned long addr,
-			  pte_t *ptep, pte_t *end, pte_t *cache)
+			  pte_t *start, pte_t *end, pte_t *cache)
 {
-	int i, nr_ptes;
+	int nr_ptes, nr_total =3D end - start;
+	pte_t *ptep =3D start;
+	int i;
=20
+	kasan_unpoison_pte(start, nr_total);
 	while (ptep < end) {
 		nr_ptes =3D invalidate_pte_range(mm, addr, ptep, end);
=20
@@ -77,6 +80,7 @@ static void set_pte_range(struct mm_struct *mm, unsigne=
d long addr,
=20
 		addr +=3D nr_ptes * PAGE_SIZE;
 	}
+	kasan_poison_pte(start, nr_total);
 }
=20
 static void enter_ipte_norange(void)
@@ -94,6 +98,7 @@ static void enter_ipte_range(struct mm_struct *mm,
 			     unsigned long addr, unsigned long end, pte_t *pte)
 {
 	struct ipte_range *range;
+	unsigned int nr_ptes;
=20
 	if (!test_facility(13))
 		return;
@@ -105,6 +110,9 @@ static void enter_ipte_range(struct mm_struct *mm,
 	range->base_addr =3D addr;
 	range->base_end =3D end;
 	range->base_pte =3D pte;
+
+	nr_ptes =3D (range->base_end - range->base_addr) / PAGE_SIZE;
+	kasan_poison_pte(range->base_pte, nr_ptes);
 }
=20
 static void leave_ipte_range(void)
@@ -112,6 +120,7 @@ static void leave_ipte_range(void)
 	pte_t *ptep, *start, *start_cache, *cache;
 	unsigned long start_addr, addr;
 	struct ipte_range *range;
+	unsigned int nr_ptes;
 	int start_idx;
=20
 	if (!test_facility(13))
@@ -148,6 +157,9 @@ static void leave_ipte_range(void)
 	range->end_pte =3D NULL;
=20
 done:
+	nr_ptes =3D (range->base_end - range->base_addr) / PAGE_SIZE;
+	kasan_unpoison_pte(range->base_pte, nr_ptes);
+
 	range->mm =3D NULL;
 	range->base_addr =3D 0;
 	range->base_end =3D 0;
@@ -227,10 +239,17 @@ static void __ipte_range_set_pte(struct ipte_range =
*range, pte_t *ptep, pte_t pt
 static pte_t __ipte_range_ptep_get(struct ipte_range *range, pte_t *ptep=
)
 {
 	unsigned int idx =3D ptep - range->base_pte;
+	pte_t pte;
=20
 	lockdep_assert_preemption_disabled();
-	if (pte_val(range->cache[idx]) =3D=3D PTE_POISON)
-		return __ptep_get(ptep);
+	if (pte_val(range->cache[idx]) =3D=3D PTE_POISON) {
+		kasan_unpoison_pte(ptep, 1);
+		pte =3D __ptep_get(ptep);
+		kasan_poison_pte(ptep, 1);
+
+		return pte;
+	}
+
 	return range->cache[idx];
 }
=20
--=20
2.53.0


