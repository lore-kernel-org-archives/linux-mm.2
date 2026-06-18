Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53063CD98F6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 14:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D2B36B0093; Thu, 18 Jun 2026 10:47:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8805D6B0096; Thu, 18 Jun 2026 10:47:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C3FD6B0095; Thu, 18 Jun 2026 10:47:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0EE366B0092
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:47:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9610F1C0046
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:47:40 +0000 (UTC)
X-FDA: 84893312280.16.267B7B6
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf21.hostedemail.com (Postfix) with ESMTP id 071BA1C000F
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:47:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="aT/yJkgO";
	spf=pass (imf21.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781794058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LAK2IHF6PKDSnIzALihkJANyZ/PnGgqfXG2+DPEBHp8=;
	b=PlkGjvnMkKRKlrRGA2JCH/V8Rgo3na4Xos/Y9ofDUIuGgUfxKiSBUg5w9bkLA1ER3RQtAk
	r9XcZqCicURX88/PccCYsDu8SJEAN/0osxYsiKTs03mF5bobkAssMllC1sFD1pwzpOl7Ox
	viYM6AgRGgcZeOkUP42INk6P8+F522I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781794058;
	b=FicvVc2i8vehB+td6w14BjT8XRjGrRpG6j81404uH+FBVpdvvQziLIe/5T9JdMbmBdqDuS
	6gPghcH2U6wew1BDNFKpwcUV9idoHgcsVQU93TbMoK8QTneWXxrzE7Vu9lgfV1innLaTCI
	Li2VG9bmY/YO4+/bMJjoyw0tqr02aNA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="aT/yJkgO";
	spf=pass (imf21.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65IEILf83825434;
	Thu, 18 Jun 2026 14:47:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=LAK2IHF6PKDSnIzAL
	ihkJANyZ/PnGgqfXG2+DPEBHp8=; b=aT/yJkgOfpTD1aLXnUx6vmnLpUSYX5Z0v
	EPS/G9kPjz3mqg6bHxe0mdEDr2DFTJ95z8n2dm03nqYSOhAtbU9eM1aRlqDOYoYM
	i6W9R3n/m8BtVrKt8wVDbvhX3deMdKlFfg40L6V3swU0RxO/tl7OoZwb2xgecIx5
	DoZGQR3PVatZODLQTIWgFXfeFAySezBRTIbeezvZ1Rc7ORpfb+G3zxwqamMvNdZz
	f80Jvrd3h1VJoMGsPNI84F+nk6nqV75ZZ6KRQWNESLj+Reze22HqH41Hzr0ylc9q
	ExnO63Kvdm6zx1KHcGK5qq3V71P/z8x8ov4HSAHepOBL732AFJYlA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4euequ8pdu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jun 2026 14:47:34 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65IEYanJ003024;
	Thu, 18 Jun 2026 14:47:33 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ev172c7gb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jun 2026 14:47:32 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65IElTsd37749162
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jun 2026 14:47:29 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1F57C20043;
	Thu, 18 Jun 2026 14:47:29 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E135A20040;
	Thu, 18 Jun 2026 14:47:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 18 Jun 2026 14:47:28 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id C6223E072E; Thu, 18 Jun 2026 16:47:28 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Kevin Brodsky <kevin.brodsky@arm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH -next v4 1/4] mm: Make lazy MMU mode context-aware
Date: Thu, 18 Jun 2026 16:47:25 +0200
Message-ID: <74ca0412fd60e2de2186c9712081565e3bcc07e6.1781789772.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1781789772.git.agordeev@linux.ibm.com>
References: <cover.1781789772.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE4MDEzMyBTYWx0ZWRfX906mdp4LFcyZ
 XALah7dPlmPTGDG4AnQ3MeACLgEZswVsMPeUC3aKSDdIKWNwVc8h+ItItSWfErVTW8hv/Pa+XkD
 c1SCF0FVPB6xBix4vTionI71iE6XpTU=
X-Proofpoint-ORIG-GUID: _FZ_I7H9sZ5womZl-KJn01rGWAFFxasl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE4MDEzMyBTYWx0ZWRfX0AB/2Lq69Eek
 CWV6ZStzX4ne/9Md1vwCjA1GC3I3EQfAAXSc0EammjZ1Pk2uSA+w5/27bB19/pX1y3gx6/jL9F2
 QfHAPAtZODfuzaMkvlJIfXccaloMIFhSEARxE5SWh9L4NQHEKboE1Z77Y+sCXW7mc1EioiXoGNs
 oY/s04nIAAUS6jqpYUl7DrrcPciM05+s2RiP2yd838TPYSngCjQgFYK3T77L3nMvt+tvrBZdP49
 5KLNfNmno6I2juKfOHDlsX57UdQPmTslF++YKFjew6kdiAjYYieyhWJJs5OIuDfro6xGegYzqCU
 vFxjnbH2dojuw8Wm0YquHnYaxI8+HNWYN2gDgRZBdxPgt3GRBo1FtdJXfn1aqOy8mHCP0ycqwWB
 9HaerLONiAjpW2MNwh+3sMJZhvi4FFyMUkC4urQHa6LvLocn5D0FDF19XFiotZ69iu/fOfTyuL6
 oEmcLlVN3d7I8WEZYSA==
X-Proofpoint-GUID: _FZ_I7H9sZ5womZl-KJn01rGWAFFxasl
X-Authority-Analysis: v=2.4 cv=L9gtheT8 c=1 sm=1 tr=0 ts=6a340506 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=7CQSdrXTAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=ovIRSG1zLJ1dbapjHkcA:9 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-18_02,2026-06-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 malwarescore=0 clxscore=1015 adultscore=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606180133
X-Rspamd-Queue-Id: 071BA1C000F
X-Stat-Signature: dkt7b41cy5pzdxby6r1fs1hm7esj47ti
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781794057-99997
X-HE-Meta: U2FsdGVkX19Ixf66kpUm2bTyatMpOE4xGTiLuHYgUMmpL88n97PH315IeHzJSjx+dlO/6kJgWztLmsbCDbI3O2m16qPd7uvd81bD3kbZvbts/h9t3IOhl2eeZJ5LItHW3vJvfMTzonR+h7MYn0LhZu+hP8EXCRKRik7AiUXcgjfdsXH1BPzvnHyE7Pzftm99emLKc0/5eV2IWzzo5RyYG1hyuiKbLEEPomHBApU6hDOeD/ybBteCM3KR6tQ2psnnGRASx05USGownzQmWdOzZQlYT5h76JLuK3HsdGuRzL/OXA2A1B+Xn4tTHO8IJbkag5ZICi/vf2GtWqkNJioJuvjxRikKW9/PoVcFDyzdvvGUG403YKJzeqv2JFlLuvk2i9OUJTEyTf83h6nukuNqKxSe71ueKPbH5CPcXnaTFZfqdgcFhC5RfzbI1l6JgqvMLrQi2OtLudHJ7gEZbhUS1kLeWuuozVWHYrwS7mNRbx2O90cg6k9Yz24XC2ALr7UZy1fFXq5JQEVhg8LXvbJgoRENojdrA0Io9fo7eIxw5PenmrDfm8ADoQDz5Plmgja7kR++ntBwxOTtgllaJDjbIBA6bjFSRGrYnK7NJEb6cg2kgHkmVDw/e/zkKzu8Xo/TMfSmuzEk2MeY5oDmZ+729uPO3okL63If0IPoJ6OmSe6i1DVwW5UDDwDuXI0BOX1Fm1MXe1Q6B3yvT3ACppDnrC/49zfKEvm/HW5aARGsDIDrU9Pal0rxylo5pYB8ZhdJKxeHYSmLvKF3XHHp43X1UE9OInZmmJaLU/OlfkzAWt4V/Wvvq+am0jbzvBLwzr7jaQxIGlf+jbHaDmIwPJXwk7tud0+var69EXEn2Jk2+gc+IhA8Zx+zhbwvzknolFRasE+r8UKnN/sGZ04BFzWlu/3XsJm1n+FhC8ALOXBjomUaxzoZzSAF7K/1YIX7Wg5Nf740CJgFvLSiI+DHGoi
 bVcy1LV7
 8Rj2IWIqDIv50XVDsby6Rs211T//VFLa9wDYytJMIToNAsIVTM4J3WrxYQFieiUtvL0X/R0ym/PrNjPQcVgxwSqQ7CjKrBzuV3a64Oiw+NgSyjkCfUbYZf1Jtcji4Ht9jUiEkjfD3I3xPiVLffDXg/tYN1OUSayy4AS0X0PgeRpk/aBMamsDcxxULIRYQ2v4qSJbRP4SI+RMv/28MaP/vbujLNxKg+R97bAMklgFUIdw+9u5EFeqnmPV8THo69OTL7dNmNt/nQj95LE7MdrFqYBYHH5zLh/+hG9U0
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
index d32408f7cd5e..750f6095147f 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2842,7 +2842,7 @@ static int pagemap_scan_pmd_entry(pmd_t *pmd, unsig=
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
index cd9bb077072c..c14bd5d1828e 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -453,7 +453,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *p=
md,
 	if (!start_pte)
 		return 0;
 	flush_tlb_batched_pending(mm);
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_with_ptes(mm, addr, end, start_pte);
 	for (; addr < end; pte +=3D nr, addr +=3D nr * PAGE_SIZE) {
 		nr =3D 1;
 		ptent =3D ptep_get(pte);
@@ -508,7 +508,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *p=
md,
 				if (!start_pte)
 					break;
 				flush_tlb_batched_pending(mm);
-				lazy_mmu_mode_enable();
+				lazy_mmu_mode_enable_with_ptes(mm, addr, end, start_pte);
 				if (!err)
 					nr =3D 0;
 				continue;
@@ -675,7 +675,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigne=
d long addr,
 	if (!start_pte)
 		return 0;
 	flush_tlb_batched_pending(mm);
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_with_ptes(mm, addr, end, start_pte);
 	for (; addr !=3D end; pte +=3D nr, addr +=3D PAGE_SIZE * nr) {
 		nr =3D 1;
 		ptent =3D ptep_get(pte);
@@ -735,7 +735,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigne=
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
index ff338c2abe92..ee1770ff4a64 100644
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
index 1afca3568b9b..b5ed2b05771f 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -108,7 +108,7 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long a=
ddr, unsigned long end,
 	if (!pte)
 		return -ENOMEM;
=20
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_with_ptes(&init_mm, addr, end, pte);
=20
 	do {
 		if (unlikely(!pte_none(ptep_get(pte)))) {
@@ -371,7 +371,7 @@ static void vunmap_pte_range(pmd_t *pmd, unsigned lon=
g addr, unsigned long end,
 	unsigned long size =3D PAGE_SIZE;
=20
 	pte =3D pte_offset_kernel(pmd, addr);
-	lazy_mmu_mode_enable();
+	lazy_mmu_mode_enable_with_ptes(&init_mm, addr, end, pte);
=20
 	do {
 #ifdef CONFIG_HUGETLB_PAGE
@@ -538,7 +538,7 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned =
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


