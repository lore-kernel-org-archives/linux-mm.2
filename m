Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01302F43834
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 15:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F3526B0095; Wed, 15 Apr 2026 11:01:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77CFE6B0096; Wed, 15 Apr 2026 11:01:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690686B0098; Wed, 15 Apr 2026 11:01:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52E5F6B0095
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:01:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 06BC458F70
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:01:37 +0000 (UTC)
X-FDA: 84661104234.29.989207C
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5CB15140008
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:01:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=mvnz2kFy;
	spf=pass (imf09.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776265294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LnOx6TfWB1doFFKKaKIdZnUpoNRwbMjABw+/0zF8g58=;
	b=gdfPBSGpfXtbwJPKhss0NWJsIxSdwcHsLmHLh62ub2hnEf/TzFl2PXjTSEFSA1y1AHyC8+
	iSOXV94j17RagX02+B3s3pBc1QoyZzMpEyZjvYoc+4wyLKrUYkV3p1YDep8DpL1atsOrD3
	fyskYqVPkWSoNybHgSzUtZ+4FZyAolE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=mvnz2kFy;
	spf=pass (imf09.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776265294; a=rsa-sha256;
	cv=none;
	b=DUhn//x0fwPzwHJ3ibFUFCcc2SwtrHzp/oJX9KZAPza9MfQ8kmMZ/4IYt2eeZnP0BmWPJE
	OTkGJBgGXBhRnPIu3whMITFBcBiwkyMw+zMRWHK/S7Gvo7A7mKL4rsdl4fw+8afk66Fgja
	BW94Xe8iAoJBuVRG8psBT55gYzU0Vzw=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63F3MaTK1833234;
	Wed, 15 Apr 2026 15:01:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=LnOx6TfWB1doFFKKa
	KIdZnUpoNRwbMjABw+/0zF8g58=; b=mvnz2kFywB+csh4he9f/nMQLB/Wh//OJX
	vqypFj+fOY0pYgw7KhPMKMXvKhOM/JhGRrrH3WgwLqNnDPCqaKOFemb2SADEkA76
	ruRIzhg+CIlKQaZRTPj1KPX+VKeG2YYu8w/9vy614pKhxhAt1enwxm8BakJezc4H
	QkCuJF1FO8FqpFb3AIoNVSaLNtchMDRHw6wxfAciiGUAgGmwjpr4pgzLmsW4pd0X
	KBRWW2t5OLLlOstN7t8D/TPL72NUsTPOpWvWidfjE/ZXlYkpQZHStWa3GGJQx0I0
	zyLXv19x0S1Aqc81OScgniqozZipzHjOUWahoRwDjgeAaFPai1WKw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89rgqs9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Apr 2026 15:01:30 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63FCqCUZ003557;
	Wed, 15 Apr 2026 15:01:28 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dg1mneq12-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Apr 2026 15:01:28 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63FF1P8E40632644
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Apr 2026 15:01:25 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1D78A2004B;
	Wed, 15 Apr 2026 15:01:25 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E489C20040;
	Wed, 15 Apr 2026 15:01:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 15 Apr 2026 15:01:24 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id CEC1EE07B5; Wed, 15 Apr 2026 17:01:24 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/6] mm: Make lazy MMU mode context-aware
Date: Wed, 15 Apr 2026 17:01:19 +0200
Message-ID: <8809412aaed8a515fe2e149c822543d640060936.1776264097.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1776264097.git.agordeev@linux.ibm.com>
References: <cover.1776264097.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE1MDEzNyBTYWx0ZWRfX3wWVSdDKqG1B
 oEWUGg3PU8V4+AFXBwfJ/MZFtF+768g6MAeR0ROjvQ6Y9pPrVR1BaFU5fq9a4VwDRxiGnnCru/8
 e8La4cBITuXGh8KDWq3cdFezST+rQI7B7xXvRuUkKzGZGSndjt9GAIpoYPcapnQXGqFVDYwfJkm
 ktdBoFQey94LAgSaQcxoh+zFyegUyI1F+MenkZygiDY53jAXs5+zh1YJqxmrwwaC9EG3bmLh2Ub
 1GfFRnAtEhO1WbtFps3dCqwQ2FTttVUl1fVLJuafJvBHgZtzygPLmUidSJs+XPTX4O0tF5AUkdR
 OMTcwzTSVutRrtxo6OzRUjeWdSC4Vkr0sh2uJa1on5j2ZaZKVE3Fxt1yo4oWgT/1OdIlqNjoTYT
 FAMvaFQ9XZSthNXhCbHU5+JFJeqvC0W6NXWDOdXO/DB/Su21qMNlQialqZ4ps27piZuc6eKZS2r
 MBRV9jubdO89+nC9H8g==
X-Proofpoint-ORIG-GUID: DkrC0IBN6hDSfi6y8Px-Wy9BVEzm5lua
X-Proofpoint-GUID: DkrC0IBN6hDSfi6y8Px-Wy9BVEzm5lua
X-Authority-Analysis: v=2.4 cv=fYidDUQF c=1 sm=1 tr=0 ts=69dfa84a cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=ovIRSG1zLJ1dbapjHkcA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-15_01,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 clxscore=1015 malwarescore=0 phishscore=0
 bulkscore=0 priorityscore=1501 spamscore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604150137
X-Rspamd-Queue-Id: 5CB15140008
X-Stat-Signature: q1ynq5kx86p4ka6nq6ina4p3jagm5fcf
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1776265294-705502
X-HE-Meta: U2FsdGVkX19DcpjyqUOl891PRrH2zmJ4ixLHMMUXCqqz/UolXFkvV8I5qE5f0LBM1S+gtTSvqanzSE3dchFKxiw0lY1fdxv8a+SEBZOCNL0+k69T0SyxNA6tyo2CouNB2BuiSZWtzhTAlXDbFCIZmTVv6KXz7dHKGg4x2g1nInjgFR4keu1h41gKohSpOmYWcs1R5lNzX6tRMfvYgMvTmxxayHJBv0x/ICcKkNuYGSEjD2HReiJ7RnFMo37v4EhWzPaYpJERnn946hcO9s/qN3VKxhM+B4J0DZorKaYd+vSkAQKVcHfLtDWhL0vbsXP8BmECnWDGKdF2esm6F3i6qXBLXro9FARnHUrfl2ZBK8qLiSuXXOcJWlfEJdLKLra+p9vraoFh0HN/9sHYLSzQuzZp2VtRqZ6fz3Kx0ulzaThdvQG5JtTdVwdLuoqRbhLlfvkRQPqFd8n1XSnh8Y+cNm7YLgGkJVkq0M+/gUrH3NPY+qmpHCX43KBMtgLoutjyxOo1XC2nvKSkAQXOOWUPxzcEev1A8kdy8W+LfM67r2Csds2ov01JpdaV8Va0ptDLE2Cn8YGg8AtzlIPEnaW9TTnnLobo06P070Gt2zt7cJsyhDvPWtMYAqHGnY4nabYJr7CsjSye7qGp4k55S76ha0AyvbplkxiltjknqrzXtHIR2Qt41hohLSf3ZlcmpwEtS+VbNiSmiAVstm6+wLLIUERXI1s1jk1aEBMgsuXpyEw54yf6dk8kTq0S1zoCw54UKIeTTHEMZqcDeN7licl09cD6MTG2dYICIwrrBK8kQY57Sx7FZaUQK7FKHY8tvBj4e1estUXBNSVGOWBmP1DBvJLXWIjObg9Z43aB9wnkqjdQnObhBl4Dqzdjlq73Yj68rh96rE6LooDhEbtH6njmBHLEDq1SRhq8BeZSW42xWTjBHr8OAoXX2Xkj3RNhwNgP7Bi6801qg/TXNUHXwxQ
 FHBa0R7d
 i9bKtZErIWTY2OvkbmG9gYeBz3vaqfrR1Sm2vHCc+i6FXFaBhALxbB40zYYYQkVz0i2rysc917SVBRaOGao3zTDlMAJWgOrnFL4M0LdoM3m74lZOLILn2JxDiSug2o5AENPk5u2+o2XwDbqyzC+as3TrZrPn9f9Bksmbx7FrCDZid1LCGDeozIhp+k/bN5G5a+0SrMNERFPBSBju0HFaWUXk5D5WCEKDn5kyuCoYs77IChWk=
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

Introduce lazy_mmu_mode_enable_for_pte_range(), which is provided
with the process address space and the page table being operated on.
This information is required to enable s390-specific optimizations.

The function takes parameters that are typically passed to page-
table level walkers, which implies that the span of PTE entries
never crosses a page table boundary.

Architectures that do not require such information simply do not
need to define the lazy_mmu_mode_enable_for_pte_range() callback.

Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
---
 fs/proc/task_mmu.c      |  2 +-
 include/linux/pgtable.h | 47 +++++++++++++++++++++++++++++++++++++++++
 mm/madvise.c            |  8 +++----
 mm/memory.c             |  8 +++----
 mm/mprotect.c           |  2 +-
 mm/mremap.c             |  2 +-
 mm/vmalloc.c            |  6 +++---
 7 files changed, 61 insertions(+), 14 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e091931d7ca1..799db0d7ec8b 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2752,7 +2752,7 @@ static int pagemap_scan_pmd_entry(pmd_t *pmd, unsig=
ned long start,
 		return 0;
 	}
=20
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_for_pte_range(vma->vm_mm, start, end, start_pte);
=20
 	if ((p->arg.flags & PM_SCAN_WP_MATCHING) && !p->vec_out) {
 		/* Fast path for performing exclusive WP */
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index a50df42a893f..9ff7b78d65b1 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -271,6 +271,51 @@ static inline void lazy_mmu_mode_enable(void)
 		arch_enter_lazy_mmu_mode();
 }
=20
+#ifndef arch_enter_lazy_mmu_mode_for_pte_range
+static inline void arch_enter_lazy_mmu_mode_for_pte_range(struct mm_stru=
ct *mm,
+		unsigned long addr, unsigned long end, pte_t *ptep)
+{
+	arch_enter_lazy_mmu_mode();
+}
+#endif
+
+/**
+ * lazy_mmu_mode_enable_for_pte_range() - Enable the lazy MMU mode with =
a speedup hint.
+ * @mm: Address space the pages are mapped into.
+ * @addr: Start address of the range.
+ * @end: End address of the range.
+ * @ptep: Page table pointer for the first entry.
+ *
+ * Enters a new lazy MMU mode section; if the mode was not already enabl=
ed,
+ * enables it and calls arch_enter_lazy_mmu_mode_for_pte_range().
+ *
+ * PTEs that fall within the specified range might observe update speedu=
ps.
+ * The PTE range must belong to the specified memory space and not cross
+ * a page table boundary.
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
+static inline void lazy_mmu_mode_enable_for_pte_range(struct mm_struct *=
mm,
+		unsigned long addr, unsigned long end, pte_t *ptep)
+{
+	struct lazy_mmu_state *state =3D &current->lazy_mmu_state;
+
+	if (in_interrupt() || state->pause_count > 0)
+		return;
+
+	VM_WARN_ON_ONCE(state->enable_count =3D=3D U8_MAX);
+
+	if (state->enable_count++ =3D=3D 0)
+		arch_enter_lazy_mmu_mode_for_pte_range(mm, addr, end, ptep);
+}
+
 /**
  * lazy_mmu_mode_disable() - Disable the lazy MMU mode.
  *
@@ -353,6 +398,8 @@ static inline void lazy_mmu_mode_resume(void)
 }
 #else
 static inline void lazy_mmu_mode_enable(void) {}
+static inline void lazy_mmu_mode_enable_for_pte_range(struct mm_struct *=
mm,
+		unsigned long addr, unsigned long end, pte_t *ptep) {}
 static inline void lazy_mmu_mode_disable(void) {}
 static inline void lazy_mmu_mode_pause(void) {}
 static inline void lazy_mmu_mode_resume(void) {}
diff --git a/mm/madvise.c b/mm/madvise.c
index dbb69400786d..7faac3a627ff 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -451,7 +451,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *p=
md,
 	if (!start_pte)
 		return 0;
 	flush_tlb_batched_pending(mm);
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_for_pte_range(mm, addr, end, start_pte);
 	for (; addr < end; pte +=3D nr, addr +=3D nr * PAGE_SIZE) {
 		nr =3D 1;
 		ptent =3D ptep_get(pte);
@@ -506,7 +506,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *p=
md,
 				if (!start_pte)
 					break;
 				flush_tlb_batched_pending(mm);
-				lazy_mmu_mode_enable();
+				lazy_mmu_mode_enable_for_pte_range(mm, addr, end, start_pte);
 				if (!err)
 					nr =3D 0;
 				continue;
@@ -673,7 +673,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigne=
d long addr,
 	if (!start_pte)
 		return 0;
 	flush_tlb_batched_pending(mm);
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_for_pte_range(mm, addr, end, start_pte);
 	for (; addr !=3D end; pte +=3D nr, addr +=3D PAGE_SIZE * nr) {
 		nr =3D 1;
 		ptent =3D ptep_get(pte);
@@ -733,7 +733,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigne=
d long addr,
 				if (!start_pte)
 					break;
 				flush_tlb_batched_pending(mm);
-				lazy_mmu_mode_enable();
+				lazy_mmu_mode_enable_for_pte_range(mm, addr, end, pte);
 				if (!err)
 					nr =3D 0;
 				continue;
diff --git a/mm/memory.c b/mm/memory.c
index c65e82c86fed..4c0f266df92a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1269,7 +1269,7 @@ copy_pte_range(struct vm_area_struct *dst_vma, stru=
ct vm_area_struct *src_vma,
 	spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
 	orig_src_pte =3D src_pte;
 	orig_dst_pte =3D dst_pte;
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_for_pte_range(src_mm, addr, end, src_pte);
=20
 	do {
 		nr =3D 1;
@@ -1917,7 +1917,7 @@ static unsigned long zap_pte_range(struct mmu_gathe=
r *tlb,
 		return addr;
=20
 	flush_tlb_batched_pending(mm);
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_for_pte_range(mm, addr, end, start_pte);
 	do {
 		bool any_skipped =3D false;
=20
@@ -2875,7 +2875,7 @@ static int remap_pte_range(struct mm_struct *mm, pm=
d_t *pmd,
 	mapped_pte =3D pte =3D pte_alloc_map_lock(mm, pmd, addr, &ptl);
 	if (!pte)
 		return -ENOMEM;
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_for_pte_range(mm, addr, end, mapped_pte);
 	do {
 		BUG_ON(!pte_none(ptep_get(pte)));
 		if (!pfn_modify_allowed(pfn, prot)) {
@@ -3235,7 +3235,7 @@ static int apply_to_pte_range(struct mm_struct *mm,=
 pmd_t *pmd,
 			return -EINVAL;
 	}
=20
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_for_pte_range(mm, addr, end, mapped_pte);
=20
 	if (fn) {
 		do {
diff --git a/mm/mprotect.c b/mm/mprotect.c
index c0571445bef7..a7bfb4516dc5 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -233,7 +233,7 @@ static long change_pte_range(struct mmu_gather *tlb,
 		is_private_single_threaded =3D vma_is_single_threaded_private(vma);
=20
 	flush_tlb_batched_pending(vma->vm_mm);
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_for_pte_range(vma->vm_mm, addr, end, pte);
 	do {
 		nr_ptes =3D 1;
 		oldpte =3D ptep_get(pte);
diff --git a/mm/mremap.c b/mm/mremap.c
index 2be876a70cc0..16320242da51 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -260,7 +260,7 @@ static int move_ptes(struct pagetable_move_control *p=
mc,
 	if (new_ptl !=3D old_ptl)
 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
 	flush_tlb_batched_pending(vma->vm_mm);
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_for_pte_range(mm, old_addr, old_end, old_ptep);
=20
 	for (; old_addr < old_end; old_ptep +=3D nr_ptes, old_addr +=3D nr_ptes=
 * PAGE_SIZE,
 		new_ptep +=3D nr_ptes, new_addr +=3D nr_ptes * PAGE_SIZE) {
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 61caa55a4402..35a23044a969 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -108,7 +108,7 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long a=
ddr, unsigned long end,
 	if (!pte)
 		return -ENOMEM;
=20
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_for_pte_range(&init_mm, addr, end, pte);
=20
 	do {
 		if (unlikely(!pte_none(ptep_get(pte)))) {
@@ -371,7 +371,7 @@ static void vunmap_pte_range(pmd_t *pmd, unsigned lon=
g addr, unsigned long end,
 	unsigned long size =3D PAGE_SIZE;
=20
 	pte =3D pte_offset_kernel(pmd, addr);
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_for_pte_range(&init_mm, addr, end, pte);
=20
 	do {
 #ifdef CONFIG_HUGETLB_PAGE
@@ -538,7 +538,7 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned =
long addr,
 	if (!pte)
 		return -ENOMEM;
=20
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_for_pte_range(&init_mm, addr, end, pte);
=20
 	do {
 		struct page *page =3D pages[*nr];
--=20
2.51.0


