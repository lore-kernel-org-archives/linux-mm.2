Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F49CC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:44:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C5B26B00BE; Mon, 13 Jul 2026 12:44:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59D4E6B00BF; Mon, 13 Jul 2026 12:44:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B3916B0153; Mon, 13 Jul 2026 12:44:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DD586B00BE
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:44:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4FA0B140199
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:18:42 +0000 (UTC)
X-FDA: 84983959284.24.5918ACD
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf29.hostedemail.com (Postfix) with ESMTP id DF5BF120008
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:18:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=HKJKa+3s;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf29.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783952320;
	b=2YJT1s0NCZsArFTB5dbaAZo6AgDwNgUgtQt1/aXwmFSFJwp/1LKfkEfK1BOsNQs7ZMNztX
	LnT9LtgyLyjZ13OtwLSdp5MOVu0o48pzZd4B24BYRXVV5rH3nKNUzCf6eSzdCeGzf2nsMw
	qDWSmatl72EwIrtGGj/4lwGs1w+kUOI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=HKJKa+3s;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf29.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783952320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pDZ/IcHYMn20WyBXPqVl9fp/FWltDktN8L55+mUzKok=;
	b=T5oArFCgzJHXNXyHnd0ApqFWEzLVrYGIrGXKoMzP2BiWSIpRleo+hAlYL9BHCr8n1bRvqB
	RkKbWGW7fO75xOM2GAbtRLFMSM148UiNQTLRUJIHMbxc3ATs2boMvXBWy62lvAUOZBmog9
	hUBwzCOQElGzQ/jWjZWYS9B9zThVVH4=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66DCCuNx2436841;
	Mon, 13 Jul 2026 14:18:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=pDZ/IcHYMn20WyBXP
	qVl9fp/FWltDktN8L55+mUzKok=; b=HKJKa+3spMIxI9+GZgOFvYDJmjXV7iB7i
	sQBhoQmqJgAOhD0+LvlNhAJdPDKbvEcYsHF2KUIlgcz2RmOBd21erqFLdrRypC6c
	ZM1GjdS6buT03+6RMRBEtHrCFLybwcT/XCOkspTJTgE2vNdGwWejssSevy3QrRtU
	3GO5+UPKNzb370Ik+Ex6quh1hwRkRRoXGg3MddtoCK+wHCXrWoGQRO/XT9YhM6tl
	gS+d+M29bSM4MQWQLQr0neu2Ac3hfcJGIPDHVUayOe76T5VLDtWWlonXIvuvRzjJ
	AD8bRqUlrRfaKAHwKYppSYIbbuLtxgn+PCBi5zkpmeMmurl4X4dhA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fbepx92f6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jul 2026 14:18:33 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66DE4dnX027039;
	Mon, 13 Jul 2026 14:18:32 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fc0hvx4te-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jul 2026 14:18:32 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66DEISee29164032
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jul 2026 14:18:28 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3C1292004E;
	Mon, 13 Jul 2026 14:18:28 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 165772004B;
	Mon, 13 Jul 2026 14:18:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 13 Jul 2026 14:18:28 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 00C3D162533; Mon, 13 Jul 2026 16:18:28 +0200 (CEST)
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
Subject: [PATCH v5 4/4] s390/mm: Lazy MMU mode sanitizer
Date: Mon, 13 Jul 2026 16:18:27 +0200
Message-ID: <7a4eea996903a1d0e94c81a3ea09ce361ac7b7e0.1783945507.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1783945507.git.agordeev@linux.ibm.com>
References: <cover.1783945507.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: 633p1VA7coOOqTUUask6iYHUstJbU1_D
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDE0OCBTYWx0ZWRfX43d7QLE8fPi3
 zhv3Zz9/HGflsMaoO067z5mvTuQw0khh5BIgUoW9Jt0yu2ZTdutBRythBdBVH1Z3rqyH38GeVqP
 n/W1VW9xGiJzwbArOKFJpCTknLiKjhI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDE0OCBTYWx0ZWRfXxIRttI6sbL7b
 ignxajvNQRWzT3vbz+whUvPbasEmCSDCmb6gL3bjqnCg4SqmT3Ih5etzMWfHcWQOzT8wZ55L+Ql
 sSeYHJ3tTy/VPVyL65CBNhfNDxM+AlE32zoOrWVJcaIlTapI/omXAH7sJ3FTC1UBx/NFawQIjNd
 20biXa6FtxjWBlKlPuPKdPbRlmy4Gpw8+3HK1Zzn43ZfXMcbQGfSKF7vdCe1A0i5VFWF/A9KeAu
 npFhkmncG8uwy7KBLNfzdCvOp1aYPwudHJjCXY4F7S64YFaYYxMYD4Rbmsmz0M3kXS+/8FOZh+5
 eGem2GayzSsUkoqjxtfyOZdbjzT2qZzOcwmNpnjb2BDTCg4l5glgawg8L//+fK/x5mmsnkDJ8X5
 eJXeXvxDT8ytu6tuhF4xn0diiCwzySz6ENn9AZ5GoZj1kJkKLjXMENpk0Np6xXung1NDWWufk7x
 kyydm6DZ5v4YloS/qcQ==
X-Authority-Analysis: v=2.4 cv=XbS5Co55 c=1 sm=1 tr=0 ts=6a54f3b9 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=DuHJb5c9rUSq-GGRdagA:9
X-Proofpoint-ORIG-GUID: YKOXfjdNcAVcGH6vFzn23ijE2euu_JXk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_03,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607130148
X-Rspamd-Queue-Id: DF5BF120008
X-Rspam-User: 
X-Stat-Signature: 4t7mxcpq9q7odb9sgbxcchmhjranep7t
X-Rspamd-Server: rspam03
X-HE-Tag: 1783952319-446364
X-HE-Meta: U2FsdGVkX1+3UxazNAjEnlRw54bbKaQb261laR61qp8v6YmN552Wi2lXCyL/dwlnAjDe9BPFzEVfFe1jmT6zItJOh33tYM1jn2+LEOUinPNUzoi5fxC9o8gCr5HcICT6YrvAQLQclMbA5QBseEV+RD7Dvu6+o/MjQHbJ2mhTkvkGFM0linedQKEl9eQXlojIwXTM/6n50bBoEoJ5KBMMZzeFmUZGqKoGp5BbeyAJ2K2l29Rn3jKoufTt1k/gRCZBF3ceYaa7tUnRq2MF7eHQbfjoK58N1tf7aPEbQds48lNnfhNVXte1ZcudPX9tt+DNQLDnEM+HGHgyjmSd/Z9bE5CdK6MFskue/gSu5cVbVYJ9xypFg1xNAF6fU/EWQr6bHgXFo9oZ+OuwR/zJpSJ7N+XvFoo4LV29WgGCHpyY84AjNMVaAb/5lFCwBiy5HLnk7sC+P/QkBbDjFb4mn4c/RPOSTK2ZCaU8J4An0fyFm3T1bjtHFD//uTLZTRCYH6pzfeIu/T2Fkv96EZf12nCVMDroDWigTVn6NZqMXYcLEitTuSmyu7tWupycKqOANl98qiLGnlGNbgFykMG2NQOSOnWyoZPWLTKJcL0Sa47gog4/uMHEm50mOD/tjxjbUbrjimMVyRqia5nHUOpkCjloOhBSbRDVNymk53nKBDwRcVgYEHcqdC9XVQMlS5vrSfk/gb64Tf8YdD1367z+ylxnTr0M32LbiGt1c1OZKkFQDwgHFX7RtQqQZceqj/bk4WA9GlSY8JZCSoaNJca9yuQB/7jiK4WOwmE/PpN1isPEINl1/bcZSsGItyO9+khiZ2l8To2Wr4AgWcyTqJvkq0/DgcZUQrc0T8fs366D2lBYt7O+FBlkHHC2vO8l5P9JCaJIK5yszPTMdq5htXreyJy8u0/chKlkvZrBiBo+cIYsPNFNtGsL4CQ4jO55jkUGIfFHLX5G8f5RQgbDpSTF2tM
 5sKSIzKa
 nu4qtTuj069zNkLSvgH/H9NeTAC6LgQAhOLPpsRPL1Yj+rkAcTh6lFtfv3Dg/yysVVEs5aceu5VbjhP2ukyeLpBQBkeYt160UM/cgkGzTkNlw1Gr072ztmUCHz2ET2NvIL+0CtL/oJUCCr2GSaLNVXi8yzu7UFp7kAURU/HLnKbqh+NMd01I742sw2KW4ys6t2G/h+B/WM3XkqPN8k36jsdlkgzDDUIgk+IlA4IZ3gW+MQ+I6K+seYwbIe/12R1fxBBijQ7B2B1iFPQj35pmUsEIRVw==
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
index 9c8ff55cb535..19b5b4277efc 100644
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


