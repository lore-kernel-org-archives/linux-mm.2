Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14787CA5FFC
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 11:42:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72E816B0092; Wed,  7 Oct 2026 07:42:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B8786B0095; Wed,  7 Oct 2026 07:42:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ACB56B0096; Wed,  7 Oct 2026 07:42:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 324AF6B0092
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 07:42:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A1A5480191
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:42:10 +0000 (UTC)
X-FDA: 85295641620.16.2E98166
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5A4EB120006
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:42:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="DCp/+WT0";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf29.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791373328;
	b=b9MKUArej60Db0sHd3stptKZnfCJU4lfnFMmMZRotMSHq+a3jiTC+wCgBgPvYuRioXx0lj
	M8OQM9fW126A3QaS5Y5VBFyFvNUG1rLxwYA+IO+oW6TKOMuoKRuin6mGA0wNpN0TuAuMih
	Wn2albPsH118iwtQL92UOXeEfp27cBc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="DCp/+WT0";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf29.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791373328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=shJyOauKOOBD/H0U0v7hc/PsPoSiyL2m4TXWHyz9T1s=;
	b=8ATvVr85lLKGzNEty/nlL0EDaMYFLpdpn9v3XWbYYkGQHL43vs2eeBeYGaSdJVP2TzsNF4
	oRQqjg1PUt44GbTf1GXPSTphPtldonzsRksRKla/2xenhvHhy25ihwSYENyx5KFL9NGbDL
	szDvDSBcGIA6D4Oe82sUdSe+iDNTVfY=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 697BZhOS2259707;
	Wed, 7 Oct 2026 11:42:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=shJyOauKOOBD/H0U0
	v7hc/PsPoSiyL2m4TXWHyz9T1s=; b=DCp/+WT0k+2dvh47jrkFNOnToC2XdO5yG
	NqFX5lNmluW4hnRjoX/oDW2ksGyxGyYFko6JYZToOk3zEzJZiarI3KcX/kRCES91
	QJsd279KaMIJXyCDhzRGLsdJUHtSf3Oed/siVpB3tjJWjzR5afE26QGeRDgj11DL
	NlaDAJ/WMJfXogdff2qwJGa5ojr6W5Znho98jKGUZbmp1pkNhMgJjGT/AJx4BsE8
	AooLayOIvChuQMz3fJ+S1rJQtZJ3mcN1b060OwQ1wHJc7HbpnGzyLTkLIGA1z15E
	6d09Ag8URq7mXzMc2oGZv9MryBlXcjuWHACcOB1G7z50vgfWt9zpw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h2q4jvmbq-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 07 Oct 2026 11:42:04 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69782TKV1562417;
	Wed, 7 Oct 2026 11:42:03 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h3cdvxfh1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Oct 2026 11:42:03 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 697BfxlR48759110
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 7 Oct 2026 11:41:59 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 98F5020040;
	Wed,  7 Oct 2026 11:41:59 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5625520063;
	Wed,  7 Oct 2026 11:41:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed,  7 Oct 2026 11:41:59 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 99253160B5C; Wed, 07 Oct 2026 13:41:58 +0200 (CEST)
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
Subject: [PATCH v8 15/15] s390/mm: Lazy MMU mode sanitizer
Date: Wed,  7 Oct 2026 13:41:58 +0200
Message-ID: <1890ee88ced60e0d03d88e681b7e6dde6a6158fa.1791365932.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791365932.git.agordeev@linux.ibm.com>
References: <cover.1791365932.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: gcCe8F3CQ5BCZYsIAkt8nvvQAh87lCOb
X-Proofpoint-GUID: ZhGgR0h0gzeUPkR7w8xgqgrq71GTCE_W
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfX2yDlotAE55ev
 Koli4pRdmy8NExpXmDPFt2mBOi89UIWyl6LTixPxnLHU2b7yjeSbZWgw9Krgack4yJqW9rPypkl
 Q2T2E5Y38Fd/keU9WhSWketmZ5RJzgo=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfX6LcQRnfiB2Q8
 SiN0S//pA4DUcuKYAicXzk6Kc6YCJXL9rLaw2I5Z36fQrR2Bxbpy/5hULWW9ovj+y8hIFUFSxYQ
 qithfL9FiM+ca0cj6gFa4t+S3ebjAy2TyWvT3x5z+Fvi3CnCRczowSumBVMf/iAozgP+CamDQ3J
 yVOlpjw8cdLznaqJdT37l83Y5yS2Xr/a7fvOBw4v0YRdBJGjgveOKIvpmPW8Z2PHCXOrBP7j0Qr
 HFAgMwsMmKLLZMUkC1/uBsW6afu3BbSXNNSdPx2a2k8NDWE8X/xlqPe5vnUxUXigDhZo+zLXc2f
 snko2x/URfphXnGpuk3sBz/p4CAB61jlIn28UunVhpP8dws1TaBCOzhZBsABpVjT3n9Xf3o+vnv
 osOE/Vp1H1I5+N+0rXqBUznKzcURLQ3vuYA3FY4N/5fwthoiVOZMj9tFINKAc3Mbk96Ieypt8cI
 uNQJhDqV/qAXNxLOQFw==
X-Authority-Analysis: v=2.4 cv=eYeo7LEH c=1 sm=1 tr=0 ts=6ac6300c cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=DuHJb5c9rUSq-GGRdagA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_04,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0 clxscore=1015
 spamscore=0 malwarescore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610070046
X-Stat-Signature: tiup9j8skjnoutbmc1zcnxh8fqz4iq81
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5A4EB120006
X-HE-Tag: 1791373328-316281
X-HE-Meta: U2FsdGVkX18LJPFTZCLcGFI3+YKzNV8R2iN9s3Z2u3+B0dEOF7qTmBiPBIbIJZ6WLT4Ryaid+o151S5Zru7GvtbAhL7fe42HjRK1elMQIrEw0FggMX1/NPPaDruOa2F8jYn9TqYKf9s/JvJ5Ur400+5Pn8MI8M2Lszkd8LzS7A9c1IcqIbJJNyZpVi+sqrk91Zly+g/NWhtzdmA8ClKdGXeernRR+I8ECRKpQylN/3mNv6BFAJrUZAAfGn73EQHEPX1qfHuoJ4lWFlnSDVo1T9a9fiKDPmF7TRpfvUxk0EBZoNpa2APTBCQMHpXTwhSKHarF+TJOmonOWreZ5cJ4jJIP3wUnqDcPU8R9U99nN+Hjh87lUxPfCPRP9PEcSqC02t+brn3ea/Tz0VxJNk3s9mVPFcbRD303NOG3nKoCmIv/WZv1ta8gLGCdgqbJ/8+wMUNJ/tj8aZgb+vWaY81n/WTidwv3aRLbWwH/9CQfjMeD8QDMZXxYPCtQl/WCb+EUY9f6/Zc2AfgsZi8QSji1LQWKKAkJE7oYPTJvOJpETTTZm5D77IRaFeDGCutjxuODC8uJwuu7ObHXnhV80jOcU5uEqqWbk21MdI746DKBGvQiav3tbMzeyWmSOUQTAOnhfUPxwpgVpl2YahU/Qbd0z0zr1c22xmbFf1dSMvEeLvBMPMeVv3tiyzZYlt9tVuAiU2C0fIBHXv8dbjnmDf6DcCnFf5YnY7yIVi8ftSO5xmYq/9fGUSGYUX1Rg7x1xmgzaP18U8dKpMPs7CnFFMGRZHrq0axGIsQfiAjkEChd5xjV7EiZbnWw2GGwrBuIkRjpSLT8rhVpzT2GBCl3dcL102MLxZ+7EUYwHASa6a9i7tycP4lrYHCmjNfHWJSapr/OooRCarKjiq+wABgas+xeVDTZXdvvkIwsBcjWuaezoMeYTzyynfGOZRQ7gDbp2xaMbChtvIpOQ4E8RQOpmdr
 ySlNCBT2
 6dXD+MbKrxsf3s0Ou1TJi1H/4SKkmPaNEUP/oArjEm/lub8VcfzgzBlpV+V/xZBQeFfyfEruy88KyVDvmmm0QiDgbEKCJXoRu5nWktpNTIpZ3ApFmd1Br2Qv7rBTU/5w2CtSd6OmfMdHWIz5xTFua1eI262ApwBUFvSmgK43kydXsjrjGpEh59Ly9IO1JMzYqiCf48zVbIq/cumYotA+m9Vt/9BOhX9rRuoH0R5ogzUuxi3M0mD3HNcTgo+11ZGL3pGifdRUmELr/9pmWGSQ6/O1bGQ==
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
index decce76fac74..47f0adfc1029 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1063,6 +1063,12 @@ static inline void set_pte(hw_pte_t *ptep, pte_t p=
te)
 		__set_pte(ptep, pte);
 }
=20
+#define ptep_get_lockless ptep_get_lockless
+static inline __no_sanitize_address pte_t ptep_get_lockless(hw_pte_t *pt=
ep)
+{
+	return __pte_from_hw(READ_ONCE(*ptep));
+}
+
 static inline pte_t __ptep_get(hw_pte_t *ptep)
 {
 	return __pte_from_hw(READ_ONCE(*ptep));
diff --git a/arch/s390/mm/lazy_mmu.c b/arch/s390/mm/lazy_mmu.c
index 8c1a62f23736..e29afa081061 100644
--- a/arch/s390/mm/lazy_mmu.c
+++ b/arch/s390/mm/lazy_mmu.c
@@ -65,10 +65,13 @@ static int invalidate_pte_range(struct mm_struct *mm,=
 unsigned long addr,
 }
=20
 static void set_pte_range(struct mm_struct *mm, unsigned long addr,
-			  hw_pte_t *ptep, hw_pte_t *end, pte_t *cache)
+			  hw_pte_t *start, hw_pte_t *end, pte_t *cache)
 {
-	int i, nr_ptes;
+	int nr_ptes, nr_total =3D end - start;
+	hw_pte_t *ptep =3D start;
+	int i;
=20
+	kasan_unpoison_pte(start, nr_total);
 	while (ptep < end) {
 		nr_ptes =3D invalidate_pte_range(mm, addr, ptep, end);
=20
@@ -79,6 +82,7 @@ static void set_pte_range(struct mm_struct *mm, unsigne=
d long addr,
=20
 		addr +=3D nr_ptes * PAGE_SIZE;
 	}
+	kasan_poison_pte(start, nr_total);
 }
=20
 static void enter_ipte_norange(void)
@@ -98,6 +102,7 @@ static void enter_ipte_range(struct mm_struct *mm,
 			     unsigned long addr, unsigned long end, hw_pte_t *pte)
 {
 	struct ipte_range *range;
+	unsigned int nr_ptes;
=20
 	if (!static_branch_likely(&lazy_mmu_enabled))
 		return;
@@ -116,6 +121,9 @@ static void enter_ipte_range(struct mm_struct *mm,
 	range->base_end =3D end;
 	range->base_pte =3D pte;
=20
+	nr_ptes =3D (range->base_end - range->base_addr) / PAGE_SIZE;
+	kasan_poison_pte(range->base_pte, nr_ptes);
+
 	local_bh_enable();
 }
=20
@@ -125,6 +133,7 @@ static void leave_ipte_range(void)
 	pte_t *start_cache, *cache;
 	hw_pte_t *ptep, *start;
 	struct ipte_range *range;
+	unsigned int nr_ptes;
 	int start_idx;
=20
 	if (!static_branch_likely(&lazy_mmu_enabled))
@@ -163,6 +172,9 @@ static void leave_ipte_range(void)
 	range->end_pte =3D NULL;
=20
 done:
+	nr_ptes =3D (range->base_end - range->base_addr) / PAGE_SIZE;
+	kasan_unpoison_pte(range->base_pte, nr_ptes);
+
 	range->mm =3D NULL;
 	range->base_addr =3D 0;
 	range->base_end =3D 0;
@@ -244,10 +256,17 @@ static void __ipte_range_set_pte(struct ipte_range =
*range, hw_pte_t *ptep, pte_t
 static pte_t __ipte_range_ptep_get(struct ipte_range *range, hw_pte_t *p=
tep)
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


