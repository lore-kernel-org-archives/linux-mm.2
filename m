Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EABA2C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:32:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F195D6B00BE; Wed, 15 Jul 2026 09:32:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF02D6B00C0; Wed, 15 Jul 2026 09:32:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBA776B00C1; Wed, 15 Jul 2026 09:32:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B9B4C6B00BE
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:32:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A50E71C0027
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:22:51 +0000 (UTC)
X-FDA: 84991076142.04.E155821
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2EA661C0004
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:22:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=olB+mlG8;
	spf=pass (imf21.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784121769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LZ/C2SviyVY4H5WIesI8BfP7X/LNOC1ZDba8bhepJz0=;
	b=rP1PQq2NUjAyBkcmEANBjKBeE9BUHhTt+2bA0cU3KRuJ1rzHOinScYX25uQs78OU6LGUKB
	zn5ePlqdMerJe4HeJVFe7Ti81cYUEHGC1iZ+ZnG6lc4afJdNF5Ej6GqainYXn5t2JMmVJG
	1IMNw0tTQ+E0f3M97WJ4hO/G8VtMCSQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784121769;
	b=hAUkCFh8EYCxRF5Yw95sVw1oXwx8et0Szth/eAhPb5Vj7rR9Vv8j3izRljQXgfjZLJB9l3
	Jf9bdo1OhWQYaSBkIiD76uzyiEVc2wNa8KHiO01vtYbUkSMDb0yIc60DtOmmju0cbvw++o
	stpOzRADjyVdnN8DlaafXwTrmZQl75Q=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=olB+mlG8;
	spf=pass (imf21.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66FBfiuE075082;
	Wed, 15 Jul 2026 13:22:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=LZ/C2SviyVY4H5WIe
	sI8BfP7X/LNOC1ZDba8bhepJz0=; b=olB+mlG82agEwqz7YBUtChMsq+hqt+SQw
	t2uefipLBXY14/kQbhqEnE5fNB8zAiwIrrGe2TBlDW/MDgkdv5jFNRiYgWB6I4GC
	fCLtNwb6BSy0fe4rXvXNbvvVydgP0N2BqgEhP7LVGdqQyc9tb6BwgXvnlGaPdVrC
	b1tML4c3GYf3PkWG2fJfwafNgTNECmUT2P+veQ2e+1Ld6LY2xhJ3ydPmzOgulmxU
	Ol/p3DGkAQxOLX+sarl814tlzO2GXPWSZgHV+nddWNFzILDdIeIQtPoTySRAoebr
	vTDjRR3bCYrLgDjfLLGwVZ10WjIaTp39Wa2VuT9XJ8aXgmr51/zCg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fbegtbsbr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jul 2026 13:22:44 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66FDJbBf025130;
	Wed, 15 Jul 2026 13:22:42 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fc0hw8an1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jul 2026 13:22:42 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66FDMdkI24117690
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Jul 2026 13:22:39 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1812A20043;
	Wed, 15 Jul 2026 13:22:39 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DEE9B20040;
	Wed, 15 Jul 2026 13:22:38 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 15 Jul 2026 13:22:38 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id C67FC162688; Wed, 15 Jul 2026 15:22:38 +0200 (CEST)
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
Subject: [PATCH v6 4/4] s390/mm: Lazy MMU mode sanitizer
Date: Wed, 15 Jul 2026 15:22:38 +0200
Message-ID: <a3a32c582430b6065810025466d414aad7c0fda7.1784121418.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1784121418.git.agordeev@linux.ibm.com>
References: <cover.1784121418.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: NzwnRmpJrrt-hFlhno_51qgFNBqErqBa
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE1MDEzMSBTYWx0ZWRfX68NFAi6S/zcg
 UzWZpRSfcFOWnkA+tKIgL+8hsC9iFOl0mxI0jVU/Sj8NeDd5XERLPISiXP8dQT5JOVoBmzboGIg
 Zy9Vkxoj2Vl16Ld6/e9kfMTdlNDuuyI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE1MDEzMSBTYWx0ZWRfXz9xZeV2pgw+U
 J37NUlB/7LIPSOuILoz47iaVhqJpIGMh3zRW5D7cvkdzNI32csohwSsC9QuLgStkVfSAKCPp8hU
 LtwtTUD4+V7k3K+oh+ZLWGN6IEarSJzKkLa6h6x/F58Nm5Uyi3suTF+++bdWOsvrJIcV6JiGX/u
 fGqk6GO70J5m6+wvTTgRBiitmdvfkHYsUNDbSowhfV5PeVk3UqxI48X8lNUzMqBoljQobBF4E1O
 C0FmGCz3mias0Qt+pPraw3GCWg10wPublKEBfWJaqKSYfuyefwq8XI1YkWYQyYD9gbXaWyw1+hp
 kolHongc6zw6v9VFel6ACNcmMq6Qw9kJ/1/8Llj1+JEEAimGdfRZ691bKGKqgtEG15DyegodyLx
 KQH3JCTHnt4UxhMVug/I2iWaZ6pNJA263aSNMPAG/W+0vlth4pTHo09QssSUvyNcaymLeK1VPQZ
 kvzKlkP5xEauEPlTFiw==
X-Authority-Analysis: v=2.4 cv=IqMutr/g c=1 sm=1 tr=0 ts=6a5789a4 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=DuHJb5c9rUSq-GGRdagA:9
X-Proofpoint-GUID: rLnwT-xYCmxNLq09tf11Z8QOx2djurBF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-15_02,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 impostorscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607150131
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2EA661C0004
X-Stat-Signature: 9b1pgj59bgx8xij1js4fymugbi66k8sx
X-HE-Tag: 1784121768-5903
X-HE-Meta: U2FsdGVkX1+A7ueIVRwPC9TiBxkXkhoW68R3xB9+nhZ0f59IR1vjxSJLCRRo71h9zT9HenFoosnzViZJwwzOF5Wu64Ulp9WfCwE3oWTRuPTx+FbuW05EzXanLGZdLjCGCvWOf8AEj+zycPShsU6izMEz34DQoWJdgXkQyDKY2+SclsmApOlps3k1XfQOJlpSr838HaGBu05wDr+/EgsrFkeVJ7TOGxEofULFunJUgEoyWm8asIQ5p7zbmcX/7WoJfzLZU0yUirGcyPpQG6OGoU0aNfBwDQbFZxo10bNZyQI4+E4GTHKRMaig76dkyBshrSgQDlAWe43Nh4jMJjyEsVcKkkRGJCpTVc6WMwCMoqNlLZ22V1MmXseo1wvak2E0nvqBfohX+6yABv8+qC0mDgmrS12P21K4bqjX6voSO7B56PN310+gVLJi/bxOOFkO2P33HKR/EOgmn0x1eCDQiswca/EKryYRYvQG6+/1rCx81ABZSAg8DiaOwd9ZpKnX+N/+xF87derUAYpUWWlNDOB9e4qyU2QM09Nx9LtcNvJwhwYK84YvnCzupI7PeiodnqfNBOw8KCn7v7Wx9c8EyR1VtbJ81f4N1Y9ZvnUDcTbX7r8qqk5iJaMaq59YN1AKwVWNeawRFpkRf26+oOK/EHZB7trHIAPwpVB+cWYXyWGJK6lOnf27wk1atF52MqlQEIBzDApAYlqPsXPV/vw8x6O/b5h8zGeqERrekw4VoZPqnNmYP7qNk7yxhbbGW0HSFHTMlz+wOpZ3rJ+sMvWbRCcnt3lxwXapOEujXjTfvYwLiJdVLFpOoRX1TNcJSjEfXZ3E7Bj4gkCheJtBGqFHn61Lc8ux2pfzvHnrgtHUL+NNEAogNAR/fMnVuK6Xh+5qLyTWuS507sx8EwNwbpadpWha9y0dGueH35Ng8fy6jTe2OIVMR5HGxnrCUFsHefIuc29Y38EjcbGI89Q3zY7
 +iY1BlJw
 vsZxNAniHMlB/j1XgboT7+SIVKLD9kYtxdLc2mXzOaoyS8AFCNFUwRGcBaG+aaNUmA+pumluHSa3aJds8Mbgw2J+LXGLdpf/st+cKaEHNuTuCxWXXsj4iP2mfNsTcwUs7QmC41KmJ5DzzTcQAeVevMpIzUxr0fi2lGxuLyb25T6qPDJgsu6d4S7LGbhAlxiJmsPaa4tg08aDBD8Ml7Dxd4ZKXOrlnjVJ7Gfwqqe1d6fvAwkz64sC4oQQXnZR73wbrmrJSs13A3jvqVwiIMJqwm1TODQ==
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
index bf54202a0630..1e8a79989ed6 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1049,6 +1049,12 @@ static inline void set_pte(pte_t *ptep, pte_t pte)
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
index 79dc68bb9a53..8947e29132ca 100644
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
@@ -108,6 +113,9 @@ static void enter_ipte_range(struct mm_struct *mm,
 	range->base_addr =3D addr;
 	range->base_end =3D end;
 	range->base_pte =3D pte;
+
+	nr_ptes =3D (range->base_end - range->base_addr) / PAGE_SIZE;
+	kasan_poison_pte(range->base_pte, nr_ptes);
 }
=20
 static void leave_ipte_range(void)
@@ -115,6 +123,7 @@ static void leave_ipte_range(void)
 	pte_t *ptep, *start, *start_cache, *cache;
 	unsigned long start_addr, addr;
 	struct ipte_range *range;
+	unsigned int nr_ptes;
 	int start_idx;
=20
 	if (!test_facility(13))
@@ -151,6 +160,9 @@ static void leave_ipte_range(void)
 	range->end_pte =3D NULL;
=20
 done:
+	nr_ptes =3D (range->base_end - range->base_addr) / PAGE_SIZE;
+	kasan_unpoison_pte(range->base_pte, nr_ptes);
+
 	range->mm =3D NULL;
 	range->base_addr =3D 0;
 	range->base_end =3D 0;
@@ -230,10 +242,17 @@ static void __ipte_range_set_pte(struct ipte_range =
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


