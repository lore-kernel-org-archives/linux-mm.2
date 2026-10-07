Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5781CA5FFF
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 11:42:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD8AC6B00A0; Wed,  7 Oct 2026 07:42:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D96026B00A5; Wed,  7 Oct 2026 07:42:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB0DB6B00A3; Wed,  7 Oct 2026 07:42:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 727316B00A1
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 07:42:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EA1D2A6190
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:42:13 +0000 (UTC)
X-FDA: 85295641746.14.9FB0E39
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7B578A0006
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:42:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=j6DTbbDY;
	spf=pass (imf15.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791373331;
	b=WXia0NXjC6+X0ZfHiZU3TCp+BujDhyD7UsI6urClWZFLXmhhBkpgmuoFH72ByTXTWfjfbS
	3bscRmxem2V64kiwN52v0B5Gdxna0AFgtxGi31Fcg2tm2n/T2WuRZXnrnOQPLXetxe40aR
	ZoXaZxuvWXuJhQkAAMfsTKLmchW0sCs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=j6DTbbDY;
	spf=pass (imf15.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791373331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I8VPEZS8Gbj1n0xd6hdZbSRznW/0HD/bcZqxSwMDDN4=;
	b=rIlw7tnHDUgQ2Wif8MHPW0VBAGkBKackapQnQ0pZ4APHt4RwegJyXYA7qM4P3u94MaGMTp
	+MTjnpfnLLsHSRhWKVFj/yXFv8osWWN58n/av153OGfZrTQj2FofFb3xBEbu7UJdFoIn7g
	qdLBpJbI3ld35/LnH0S8lD8H8AkL1ng=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 697BaBJA597602;
	Wed, 7 Oct 2026 11:42:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=I8VPEZS8Gbj1n0xd6
	hdZbSRznW/0HD/bcZqxSwMDDN4=; b=j6DTbbDYLe61BbViYVwh8a7dAUXO2WXUv
	0xjQFpMrumlFWoKAv1vwD8BAavi6edZWXt/gO6RTboNy9GKTGcteXXHbF2UzKbeX
	+AwMmb6Hrp8zuJV25qBrV5npki9NO+3YyjEmhltFlmEEYeSYbRTOGxDgzvoXnXXD
	ZUMoS5bVc187RlPggDKjrfexIblhh1/B8xq7u1QNt2wBOCdSxR12oxjGHbjGqsY/
	ZypWs1RKaIIHNRQGESMi4/2sXjPJSUgEyMv8KgOTAlKC10Q4wi36QFMFdzI3dKVA
	CzL7E0hf9Y7DVPfMe2BZZMie2hMjcmGSAwBbmSHtlOiiNJCv9UvAA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h2scrn5kt-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 07 Oct 2026 11:42:04 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 697BWiEY1789962;
	Wed, 7 Oct 2026 11:42:03 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h58d5jmhy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Oct 2026 11:42:03 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 697Bfxbn30343856
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 7 Oct 2026 11:41:59 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 795482004E;
	Wed,  7 Oct 2026 11:41:59 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 220FE2005A;
	Wed,  7 Oct 2026 11:41:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed,  7 Oct 2026 11:41:59 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 9283C160B2E; Wed, 07 Oct 2026 13:41:58 +0200 (CEST)
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
Subject: [PATCH v8 12/15] mm: Make lazy MMU mode context-aware
Date: Wed,  7 Oct 2026 13:41:55 +0200
Message-ID: <c82c8f523790d431c5eb46f8fda49609458d05dd.1791365932.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791365932.git.agordeev@linux.ibm.com>
References: <cover.1791365932.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfX+l/wPkjB3gIW
 ohWHtFMFCgZWjP8FuLjXBeJ8FOh5u8FyORei1N26b04LOxYMMtN063eBfXW9mU1VV4YYaL8ez2B
 Gj08nhzUSw/Pej4Hx44Uff3ppj6JG5c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfX+jRPTUyg9fwL
 S8BP3dS9+sf0larAZiDJQWKZUQ1vODtrlc5JXYGNi/6XLdDkI+tmlX2AmTsT3QNwh8/7llKzeFx
 hVOgYbrDnHSfke0KGxGH7dKB+XIjc+IKbS61gpBfS2TdEroUsSa5PuhXgkGnEOxv+OgT6yKut6B
 0rRAtY6ss+JZ374R64D33A5P9RppcIxpWEtG7sSlWatfZFptJ3yo5Rm2U1Lki7MevlK/PR/uvMt
 8nvL+a1QL3kzU0URU70F1mfoYTDKtu+EpC4pOJTTSADfpMaPjTDw2XMSC9i05sxzQJFbYKU8TF3
 PrCrsXGe18yKHQOxN4GVOBVDJ4dgUnNkgm6j5aXB9HDllho8FBp7sRrOFWTIEOyiQYZS84j7QhI
 b/i+2Fhmu18ZjCP+xSROdwgYQy18DovRVmJA/1WkggDZc00BaBmGqvPxsZWSmDj8b/vxrrSSROP
 JqAY+3Iesb0P4kLl7Iw==
X-Proofpoint-GUID: CU20SDHePfJsawMGZjUhkg1AcFMwDHLp
X-Proofpoint-ORIG-GUID: BDwgPoLQv2ssjy7sBLT0DXf_aAapUuIJ
X-Authority-Analysis: v=2.4 cv=B7osQ+tM c=1 sm=1 tr=0 ts=6ac6300c cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=7CQSdrXTAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=Yo8-fGXS6AlSV94Q614A:9 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_04,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 malwarescore=0 impostorscore=0 phishscore=0
 clxscore=1015 spamscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610070046
X-Stat-Signature: wn9uccarrswodubmemcx58g1nci1tr76
X-Rspamd-Queue-Id: 7B578A0006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791373331-150101
X-HE-Meta: U2FsdGVkX1/WBsJfRomNm/evUxIUmaIQVSBX6LcA27oG0Mqw2hOlhEAtT4XIPfNS6cXhNubUXR4vLXGITC5PDmPMDQLpP7D4A6rdaF7pSaxziorWohDXrUPEIKN4uQjekagXVVEEaZyr3BvQ/phOGdfzPnjHHxLZKKEFUi06UIP78sf0a0hf5X+o6/MaK4Sz6jy2NCiKk1Vb5ANmuIlM+7cv7EEf+ZGNXC0scKpEDbkD9MQ7KF0UgED/BkvgM/P61ciSt+Sz3DQc31BTflicZPPqqw6VBrAQkclsmVA1Py//Uysz+vmy9Ylsi75hPW2TTUpxIq+ovJweBoZ3JDVf5txb0CrCmAFNS8gWpJY6ot9+cuqGBU6vcyJuCwCnH/Fy+k3XUtWFc00zDjMvoN7eNJzZ8P7PU2RzpQOhw3rXWvZ7ZEfzQmhJ6FMN4IBtPb+Se60qaPDY0/LQ9w5tm0yAsX0Ml0QTnHy0mWB9dgA8SpDhLZ00DMhWTQmSDwjUp9LJN3DQRqpT3/3OBcIfPX3w5ATE/J3+VMXyIkV+BBMDZhVPFZjyI0WSKdsDrhuJJLPD1mhWMde8dEPv1E1s0dx3rcw9DHHpSCTslsUFny4wJrviQ+rCkhv62i++DeWd3QthSSzUvusKz9GJXx4Ijax70x6KRQexdFcN5hlNc0Jrw8yQXuGzLjqCLtIubNq/+RLxbw7BxWb4ctA7IKk0cifWUFLbosYAdls2aqzmAmwwZIr9g9XHJxZqU2lvjUN5NRXAN3+Hp7vhu11XkuOxgQ7MGVoqhTqxgIER46NxZLMLHQlCZjhtQpNiK94Zm2qQcCR2UVqQl8OSHYKHfA7OTDLHGZz+XBzDExyvW9c/V4VSB/tVxUgzOAKGl5uyuqnckxlTYtp5QU1MIqX5Gc2Q+PW2IG8NJHC917NKapf9IiDVMjCqhWekmPDOnpZonsBEUHdj3bL4NUVRfadDV5iTRVO
 KT6Z2Bl4
 KNg/KA0HnDfIGgAmrdgsUgbFCpICjnibLpjrGHckYyHA33uHJ6TZCnqJso3LnhOiGS2emD0JYAxQ+rozW98tZdzMbePw2h8RcVYvPUxedQJKYutk7RSKsPoPLNvE07dtrtuulNuvrOGPBpobf11IqAQDEn/oaGUtfyqfgnj+3UfJclIg9hSUYBL5h4SgeZlBWbkz6uT+svD6AUOOYFXtAWc6qWrelPnxG6vznCq6FDw5nWtR3Uiasm9CsbnHAgrv9P18McqG+CM4Bv90yx4gISnnh3QbBELRVjGdCIYO9dQSl6AUPo5rMw2s7kLRTGqyAERNLk16FKLvi2TE2n5NClV4reTVvGThmwJetfjv4O1B8UFM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lazy MMU mode is assumed to be context-independent, in the sense
that it does not need any additional information while operating.
However, the s390 architecture benefits from knowing the exact
page table entries being modified.

Introduce lazy_mmu_mode_enable_with_ptes(), which is provided with
the process address space and the page table being operated on.
This information is required to enable s390-specific optimizations.

The function takes parameters that are typically passed to page-
table level walkers, which implies that the span of PTE entries
never crosses a page table boundary.

Architectures that do not require such information simply do not
need to define the lazy_mmu_mode_enable_with_ptes() callback.

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
---
 fs/proc/task_mmu.c      |  2 +-
 include/linux/pgtable.h | 46 +++++++++++++++++++++++++++++++++++++++++
 mm/madvise.c            |  8 +++----
 mm/memory.c             |  8 +++----
 mm/mprotect.c           |  2 +-
 mm/mremap.c             |  2 +-
 mm/vmalloc.c            |  6 +++---
 7 files changed, 60 insertions(+), 14 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 2b5af72bbe45..3ae43f4e78b2 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2884,7 +2884,7 @@ static int pagemap_scan_pmd_entry(pmd_t *pmd, unsig=
ned long start,
 		return 0;
 	}
=20
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_with_ptes(vma->vm_mm, start, end, start_pte);
=20
 	if ((p->arg.flags & PM_SCAN_WP_MATCHING) && !p->vec_out) {
 		/* Fast path for performing exclusive WP */
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 1768421755a9..1e6240269d4f 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -272,6 +272,50 @@ static inline void lazy_mmu_mode_enable(void)
 		arch_enter_lazy_mmu_mode();
 }
=20
+#ifndef arch_enter_lazy_mmu_mode_with_ptes
+static inline void arch_enter_lazy_mmu_mode_with_ptes(struct mm_struct *=
mm,
+		unsigned long addr, unsigned long end, hw_pte_t *ptep)
+{
+	arch_enter_lazy_mmu_mode();
+}
+#endif
+
+/**
+ * lazy_mmu_mode_enable_with_ptes() - Enable the lazy MMU mode with a sp=
eedup hint.
+ * @mm: Address space the pages are mapped into.
+ * @addr: Start address of the range.
+ * @end: End address of the range.
+ * @ptep: Page table pointer for the first entry.
+ *
+ * Enters a new lazy MMU mode section; if the mode was not already enabl=
ed,
+ * enables it and calls arch_enter_lazy_mmu_mode_with_ptes().
+ *
+ * PTEs that fall within the specified range might observe update speedu=
ps.
+ * The PTEs must belong to the specified address space and be in the sam=
e PMD.
+ *
+ * There are no requirements on the order or range completeness of PTE
+ * updates for the specified range.
+ *
+ * Must be paired with a call to lazy_mmu_mode_disable().
+ *
+ * Has no effect if called:
+ * - While paused - see lazy_mmu_mode_pause()
+ * - In interrupt context
+ */
+static inline void lazy_mmu_mode_enable_with_ptes(struct mm_struct *mm,
+		unsigned long addr, unsigned long end, hw_pte_t *ptep)
+{
+	struct lazy_mmu_state *state =3D &current->lazy_mmu_state;
+
+	if (in_interrupt() || state->pause_count > 0)
+		return;
+
+	VM_WARN_ON_ONCE(state->enable_count =3D=3D U8_MAX);
+
+	if (state->enable_count++ =3D=3D 0)
+		arch_enter_lazy_mmu_mode_with_ptes(mm, addr, end, ptep);
+}
+
 /**
  * lazy_mmu_mode_disable() - Disable the lazy MMU mode.
  *
@@ -388,6 +432,8 @@ static inline void lazy_mmu_mode_resume(void)
 }
 #else
 static inline void lazy_mmu_mode_enable(void) {}
+static inline void lazy_mmu_mode_enable_with_ptes(struct mm_struct *mm,
+		unsigned long addr, unsigned long end, hw_pte_t *ptep) {}
 static inline void lazy_mmu_mode_disable(void) {}
 static inline void lazy_mmu_mode_pause(void) {}
 static inline void lazy_mmu_mode_resume(void) {}
diff --git a/mm/madvise.c b/mm/madvise.c
index 40ce0d5940ef..12830d445499 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -462,7 +462,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *p=
md,
 	if (!start_pte)
 		return 0;
 	flush_tlb_batched_pending(mm);
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_with_ptes(mm, addr, end, start_pte);
 	for (; addr < end; pte +=3D nr, addr +=3D nr * PAGE_SIZE) {
 		nr =3D 1;
 		ptent =3D ptep_get(pte);
@@ -517,7 +517,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *p=
md,
 				if (!start_pte)
 					break;
 				flush_tlb_batched_pending(mm);
-				lazy_mmu_mode_enable();
+				lazy_mmu_mode_enable_with_ptes(mm, addr, end, start_pte);
 				if (!err)
 					nr =3D 0;
 				continue;
@@ -685,7 +685,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigne=
d long addr,
 	if (!start_pte)
 		return 0;
 	flush_tlb_batched_pending(mm);
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_with_ptes(mm, addr, end, start_pte);
 	for (; addr !=3D end; pte +=3D nr, addr +=3D PAGE_SIZE * nr) {
 		nr =3D 1;
 		ptent =3D ptep_get(pte);
@@ -745,7 +745,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigne=
d long addr,
 				if (!start_pte)
 					break;
 				flush_tlb_batched_pending(mm);
-				lazy_mmu_mode_enable();
+				lazy_mmu_mode_enable_with_ptes(mm, addr, end, start_pte);
 				if (!err)
 					nr =3D 0;
 				continue;
diff --git a/mm/memory.c b/mm/memory.c
index 48d6ca89b0fe..69a81e867083 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1354,7 +1354,7 @@ copy_pte_range(struct vm_area_struct *dst_vma, stru=
ct vm_area_struct *src_vma,
 	spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
 	orig_src_pte =3D src_pte;
 	orig_dst_pte =3D dst_pte;
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_with_ptes(src_mm, addr, end, src_pte);
=20
 	do {
 		nr =3D 1;
@@ -2053,7 +2053,7 @@ static unsigned long zap_pte_range(struct mmu_gathe=
r *tlb,
 		return addr;
=20
 	flush_tlb_batched_pending(mm);
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_with_ptes(mm, addr, end, start_pte);
 	do {
 		bool any_skipped =3D false;
=20
@@ -3051,7 +3051,7 @@ static int remap_pte_range(struct mm_struct *mm, pm=
d_t *pmd,
 	mapped_pte =3D pte =3D pte_alloc_map_lock(mm, pmd, addr, &ptl);
 	if (!pte)
 		return -ENOMEM;
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_with_ptes(mm, addr, end, mapped_pte);
 	do {
 		BUG_ON(!pte_none(ptep_get(pte)));
 		if (!pfn_modify_allowed(pfn, prot)) {
@@ -3463,7 +3463,7 @@ static int apply_to_pte_range(struct mm_struct *mm,=
 pmd_t *pmd,
 			return -EINVAL;
 	}
=20
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_with_ptes(mm, addr, end, mapped_pte);
=20
 	if (fn) {
 		do {
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 1d23475e0bb7..6bb112ba1b91 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -351,7 +351,7 @@ static long change_pte_range(struct mmu_gather *tlb,
 		is_private_single_threaded =3D vma_is_single_threaded_private(vma);
=20
 	flush_tlb_batched_pending(vma->vm_mm);
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_with_ptes(vma->vm_mm, addr, end, pte);
 	do {
 		nr_ptes =3D 1;
 		oldpte =3D ptep_get(pte);
diff --git a/mm/mremap.c b/mm/mremap.c
index 5272cea12f80..6a19393759de 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -260,7 +260,7 @@ static int move_ptes(struct pagetable_move_control *p=
mc,
 	if (new_ptl !=3D old_ptl)
 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
 	flush_tlb_batched_pending(vma->vm_mm);
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_with_ptes(mm, old_addr, old_end, old_ptep);
=20
 	for (; old_addr < old_end; old_ptep +=3D nr_ptes, old_addr +=3D nr_ptes=
 * PAGE_SIZE,
 		new_ptep +=3D nr_ptes, new_addr +=3D nr_ptes * PAGE_SIZE) {
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 4f97f99c340e..978029669cf4 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -110,7 +110,7 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long a=
ddr, unsigned long end,
 	if (!pte)
 		return -ENOMEM;
=20
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_with_ptes(&init_mm, addr, end, pte);
=20
 	do {
 		if (unlikely(!pte_none(ptep_get(pte)))) {
@@ -394,7 +394,7 @@ static void vunmap_pte_range(pmd_t *pmd, unsigned lon=
g addr, unsigned long end,
 	unsigned long size =3D PAGE_SIZE;
=20
 	pte =3D pte_offset_kernel(pmd, addr);
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_with_ptes(&init_mm, addr, end, pte);
=20
 	do {
 #ifdef CONFIG_HUGETLB_PAGE
@@ -561,7 +561,7 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned =
long addr,
 	if (!pte)
 		return -ENOMEM;
=20
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_with_ptes(&init_mm, addr, end, pte);
=20
 	do {
 		struct page *page =3D pages[*nr];
--=20
2.53.0


