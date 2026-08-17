Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A15A3C5DF7A
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 11:33:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF8C86B08A2; Mon, 17 Aug 2026 07:33:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0CFD6B08AC; Mon, 17 Aug 2026 07:33:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B86E76B08AE; Mon, 17 Aug 2026 07:33:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 745386B08A2
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:33:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 01BCD80720
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:33:12 +0000 (UTC)
X-FDA: 85110550266.03.A6401EF
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf12.hostedemail.com (Postfix) with ESMTP id 81CF14000A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:33:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=duHF3NqX;
	spf=pass (imf12.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786966390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pqm0dcxSc6epEG0/m6x+642lVxaYm7+JEs64OBL0PS4=;
	b=q04ams7tNkEDDM623gX9A6ja02DO/DpVb6ZrIsiGu6lgR9u1Eof0cFXEss7SLcxs2XnGJ/
	6sEKOt7BXTw79t8Q1fQnSmF05bN9GIUCqNssHCLk/CewrwDk56HjFQ/HSD1IbCyHBSuhEY
	dxM3wGajQ89bBOmjrdqYSzqgeWSLxs0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=duHF3NqX;
	spf=pass (imf12.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786966390;
	b=q1TCRtmF6ckdT7mkoeo0UoWlAN+41BgVzFRsa8FIuhIR0rpfOFljg/+QFDVVa3Y5K3CcXP
	WWIGqGkAht63DAHAlJh5fZY8SxmG9wYdYspiaIhNW8qe8ZjBgGz8HLTm1LrICe0tnRHzUr
	ozE3+yqbwVxGRl8ZpRRLVVRADtZuqPc=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HAx4s11866223;
	Mon, 17 Aug 2026 11:33:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=pqm0dcxSc6epEG0/m
	6x+642lVxaYm7+JEs64OBL0PS4=; b=duHF3NqXJFLMCGM27S0MG+L+XXGg6A6Gm
	8PJ0l4h0so/j4SuRJFohqXnzaknCwwP/cZZJWWC88oYKdVLY0FDFVa8nULGV68UX
	65wj94Nf2o5K+sxtvE+GlhlmFOMCZ0Bj5DD0xbjQjRtey4ivaCdhGGy3eVL8B5C9
	rPd0WRo3lNx3bZQeNE2IzTtJtpZS/vy3937uyym08tWTUICdNTdzyNeLAedcCB+b
	pTSlJiri7uE2cMgp1x0wsYKFmlKBw6NG3/z17QQzawh067iM32/5q+iaay78FVc1
	O2tQ0rlPyGJWdQdX+caFv+a4eKtdVpcHiN3bYIatbIZB1QCTMYIEA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2fsqhy0m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 11:33:07 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67HBR1PA029809;
	Mon, 17 Aug 2026 11:33:06 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g33xgwsa6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 11:33:06 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67HBX2YD49676768
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Aug 2026 11:33:02 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8E17F20043;
	Mon, 17 Aug 2026 11:33:02 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5980B20040;
	Mon, 17 Aug 2026 11:33:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 17 Aug 2026 11:33:02 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 34E54161127; Mon, 17 Aug 2026 13:33:02 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com
Subject: [PATCH v7 1/4] mm: Make lazy MMU mode context-aware
Date: Mon, 17 Aug 2026 13:32:59 +0200
Message-ID: <5ee7bee9fa47e623a8cecb11b97392d38adb843a.1786956464.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1786956464.git.agordeev@linux.ibm.com>
References: <cover.1786956464.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDA4NyBTYWx0ZWRfX3/eZHtIWFnP4
 PuCa5h6D9ZUCunAv9FKxM+CM9q2qpIdGWGZnWmFOM2Jej1YvizDaP2QMCQ3NfzzeWnqP7r4CpgG
 LFa3IElU1G8xzcbnI/i13XMolNjnYk9ZXM6zVCeM0BmfGuDcAvwNPBy2/j3YjxdIJwT7yzUHHkn
 zFmC0/WphwpKZk2YKYiSbWgTd9bYcGrKFdwXnmhubq9EC5HMzrwfdu88b48GYqS5Lz3LE1uiUfP
 la7tOAmNrUHOnu9vQjNbIVBVIrxTo7+pGKJ4+Mrk5STeQql7bMNPYsxvEYhh+c0UC1Cgsw5juDI
 e8KyQGr4rbD4khcIofqdXGhrm5cvOt8r2OfeQiLqUTyrG0iJcdjRArYiNrsrDLzFWKKA+mpUvdR
 B/r+BFYF3MejmjHFzbNkX5yQkdam4Ht3zSvaxY9GUraPfHXoWlQO270ixB2V0YWUc5ZMPkQWOuK
 mnG9ZVoRSrdyHXAjJ5w==
X-Proofpoint-ORIG-GUID: cKCGY1sMoU3W3YsUu4BiI2uzH1JgykKt
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDA4NyBTYWx0ZWRfX5G/Hkx1I1cKK
 c894Zd26/Qzn3slY4/eGZTvKvDxeP+A7fzUC1H1tsA5zHZwBmaV3zwXAU7FDXnDOuQO9C0r2t1a
 lZDC6oOZIbhZdkxI+hzduO1yefPdCZQ=
X-Authority-Analysis: v=2.4 cv=DJe/JSNb c=1 sm=1 tr=0 ts=6a82f174 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=7CQSdrXTAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=ovIRSG1zLJ1dbapjHkcA:9 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-GUID: Nv18bAn1CQOTUvcU6gV7b0OeT-NWzffM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-16_06,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 spamscore=0 clxscore=1015 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608170087
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 81CF14000A
X-Stat-Signature: to8q1dcrh3wtoxppdje6o7fw3t76z4e9
X-Rspam-User: 
X-HE-Tag: 1786966390-113906
X-HE-Meta: U2FsdGVkX185xXjYfnM5sLg1NwgHIJw4RYf7IecEb4RxFrg1vjG9ZcuvfSXe5wlPQPTABEsBFKB2rEaKCcAAuEttKW3cqNL2QW/J+H0zvRkm7WRgrxmWnvYS4DAdi6+rve73ovGQKzbR3tWtxKOENZPllp94nDeMo9q1W60xb1F9KuWQ3O44uGdbaRoMT7MWdDNUgFR0pOZNNP6kH8YSMQ1hoooE/AQBFAcS1+Zhl1P6a+Z0L1r82muDnaBsKD+NIQ059vuYFKhlKDYYhZypfi3p3UiM/QG3HjyQWLU5fTmIStnRhAwdbJhUHQBrix4k+mfqjvGG1mbuNP6y4d0QWHR0wruYtw4drBKNRj3ORdUlmr4eZnrK+habSCIyXonNUzL1qrhug9OWwuLtfK/i/1KjdFu8+0w0PV7nJrqchegtR/Y0w7TlqIIe6vryZE5ORU/PZltsdVOgOX9LmKZkN+T0NvjbGNnVQJA1ojGyBT8N4hP3PdMf+f9xHm6wno34rbJtuZ0oDGqcAAn3OWGnEAEQF7jfdsdWcRmcgayiu/VVLG3r4hirY4xk+Sz5kc+Z/LGRK87R9U3wHK79hNXZUZpCZt+/Kv0HByHFJBBfSNQ3Pj0RX52SCXp2znJHEDGlw/c3A8Xwy3N5mkpDOgr1dgqYVkiQ5sFPvsyJEBpiS6+sGG4LYI12CgqGU8lD9Lc+yNSMvS+n/YZH2zLKxg9MNBrir8dhWe9zxKdNnKioEZBj5+LFfEW4ET5dER3TP5Vm6fJV8MoqwVUfYZbRztCeTnF3y4JAmi0ReVVlOJbEOykvGAapqY18gOBmvkQD457kAv37WYbgyvMMriUpJfQm9gS+LK8Yfdj2m8ilBHV6tGr7HoUK/wQST3d74C6htfOAzCUTKWNVMrjGCcJZxHL4Hsg8DS9M8/dZjOlXmyR3EjffiMCi4e2OMOQ1WkO89FB8N7wSCk8i5YRP2K0ZNYF
 Hsd2yLWN
 1QgsLX/CG2/NIh7sYRO0xwYWMos+J7xw4rto8GV5DpUlBcjJNcmzJPj3KyYM1E2XK9jtA1ArOvVbhkKgPLy1DGYrvOP1M+FYRpwffw1ZLP6OSxjcPy58+EkgDu4/ik/QPCC4w8i6QJ2+VShZ4bLqV+BchtK625mrA7GHwD/FfEFO6DwRFUea4qXBlIGgwrJ1OnqXqfZH5QflJ2e31XSAZg7iFDfDzPI+38RzXfCWbrHwo0PNLOmbumtE/fYcoskN+igPPwNMZDM5/T5L7ct5MZMCgDv9KaHh2oi1hrp23G2Dp/UqWR0wY2yZCU1rJH7hZVf+2FXb81roSoN9ZnqqCt1b/k//4xw2XoU8hjAIm/DCg2BQ=
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
index 229d1fc3d7f1..916785c3b2e0 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2852,7 +2852,7 @@ static int pagemap_scan_pmd_entry(pmd_t *pmd, unsig=
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
index 2981e386da7b..cc85daf30739 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -271,6 +271,50 @@ static inline void lazy_mmu_mode_enable(void)
 		arch_enter_lazy_mmu_mode();
 }
=20
+#ifndef arch_enter_lazy_mmu_mode_with_ptes
+static inline void arch_enter_lazy_mmu_mode_with_ptes(struct mm_struct *=
mm,
+		unsigned long addr, unsigned long end, pte_t *ptep)
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
+		arch_enter_lazy_mmu_mode_with_ptes(mm, addr, end, ptep);
+}
+
 /**
  * lazy_mmu_mode_disable() - Disable the lazy MMU mode.
  *
@@ -387,6 +431,8 @@ static inline void lazy_mmu_mode_resume(void)
 }
 #else
 static inline void lazy_mmu_mode_enable(void) {}
+static inline void lazy_mmu_mode_enable_with_ptes(struct mm_struct *mm,
+		unsigned long addr, unsigned long end, pte_t *ptep) {}
 static inline void lazy_mmu_mode_disable(void) {}
 static inline void lazy_mmu_mode_pause(void) {}
 static inline void lazy_mmu_mode_resume(void) {}
diff --git a/mm/madvise.c b/mm/madvise.c
index 77552b03d318..4419d16b39f9 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -452,7 +452,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *p=
md,
 	if (!start_pte)
 		return 0;
 	flush_tlb_batched_pending(mm);
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_with_ptes(mm, addr, end, start_pte);
 	for (; addr < end; pte +=3D nr, addr +=3D nr * PAGE_SIZE) {
 		nr =3D 1;
 		ptent =3D ptep_get(pte);
@@ -507,7 +507,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *p=
md,
 				if (!start_pte)
 					break;
 				flush_tlb_batched_pending(mm);
-				lazy_mmu_mode_enable();
+				lazy_mmu_mode_enable_with_ptes(mm, addr, end, start_pte);
 				if (!err)
 					nr =3D 0;
 				continue;
@@ -674,7 +674,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigne=
d long addr,
 	if (!start_pte)
 		return 0;
 	flush_tlb_batched_pending(mm);
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_with_ptes(mm, addr, end, start_pte);
 	for (; addr !=3D end; pte +=3D nr, addr +=3D PAGE_SIZE * nr) {
 		nr =3D 1;
 		ptent =3D ptep_get(pte);
@@ -734,7 +734,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigne=
d long addr,
 				if (!start_pte)
 					break;
 				flush_tlb_batched_pending(mm);
-				lazy_mmu_mode_enable();
+				lazy_mmu_mode_enable_with_ptes(mm, addr, end, pte);
 				if (!err)
 					nr =3D 0;
 				continue;
diff --git a/mm/memory.c b/mm/memory.c
index 6b8280cfc1db..0cc07b043384 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1272,7 +1272,7 @@ copy_pte_range(struct vm_area_struct *dst_vma, stru=
ct vm_area_struct *src_vma,
 	spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
 	orig_src_pte =3D src_pte;
 	orig_dst_pte =3D dst_pte;
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_with_ptes(src_mm, addr, end, src_pte);
=20
 	do {
 		nr =3D 1;
@@ -1922,7 +1922,7 @@ static unsigned long zap_pte_range(struct mmu_gathe=
r *tlb,
 		return addr;
=20
 	flush_tlb_batched_pending(mm);
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_with_ptes(mm, addr, end, start_pte);
 	do {
 		bool any_skipped =3D false;
=20
@@ -2919,7 +2919,7 @@ static int remap_pte_range(struct mm_struct *mm, pm=
d_t *pmd,
 	mapped_pte =3D pte =3D pte_alloc_map_lock(mm, pmd, addr, &ptl);
 	if (!pte)
 		return -ENOMEM;
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_with_ptes(mm, addr, end, mapped_pte);
 	do {
 		BUG_ON(!pte_none(ptep_get(pte)));
 		if (!pfn_modify_allowed(pfn, prot)) {
@@ -3330,7 +3330,7 @@ static int apply_to_pte_range(struct mm_struct *mm,=
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
index 9cbf932b028c..3fc26418e837 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -337,7 +337,7 @@ static long change_pte_range(struct mmu_gather *tlb,
 		is_private_single_threaded =3D vma_is_single_threaded_private(vma);
=20
 	flush_tlb_batched_pending(vma->vm_mm);
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_with_ptes(vma->vm_mm, addr, end, pte);
 	do {
 		nr_ptes =3D 1;
 		oldpte =3D ptep_get(pte);
diff --git a/mm/mremap.c b/mm/mremap.c
index e9c8b1d05832..0dfe3de39ccc 100644
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
index f4fa227a8d7f..1c6ef8fd079e 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -109,7 +109,7 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long a=
ddr, unsigned long end,
 	if (!pte)
 		return -ENOMEM;
=20
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_with_ptes(&init_mm, addr, end, pte);
=20
 	do {
 		if (unlikely(!pte_none(ptep_get(pte)))) {
@@ -393,7 +393,7 @@ static void vunmap_pte_range(pmd_t *pmd, unsigned lon=
g addr, unsigned long end,
 	unsigned long size =3D PAGE_SIZE;
=20
 	pte =3D pte_offset_kernel(pmd, addr);
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_with_ptes(&init_mm, addr, end, pte);
=20
 	do {
 #ifdef CONFIG_HUGETLB_PAGE
@@ -560,7 +560,7 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned =
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


