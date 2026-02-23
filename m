Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3D91EA4FB7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 12:32:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FA2A6B0088; Mon, 23 Feb 2026 07:32:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17DA66B0089; Mon, 23 Feb 2026 07:32:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05F496B008A; Mon, 23 Feb 2026 07:32:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E38386B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:32:41 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2DCB0C01BB
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:32:41 +0000 (UTC)
X-FDA: 84475660122.20.C1D910C
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf06.hostedemail.com (Postfix) with ESMTP id D54DA180008
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:32:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=I55Cmioe;
	spf=pass (imf06.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771849958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rkuh8RE1SaYB5ngAVCW7AE/3ekpYQtmDHEks3VzHXyY=;
	b=HGozEN2+LXot/mLruFdPHonDAQ5wxH/RH5CK/Kn8tU5xP09XGiT/9ryzT0CT51igV4157P
	0PSFjK0lY/oXOwQL5gQbtyUqn5epDjL4KnVdtHbNgnkcw+x/hzHGR6q2g089etdrhz7RRV
	e+h/qlB5Ek24SVm/VAlkEMjfPEQlMMo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=I55Cmioe;
	spf=pass (imf06.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771849958; a=rsa-sha256;
	cv=none;
	b=L0yVPS04bR7suqv30RQ+vQ/RUE5RBH5RWReaDS3AoEsIjjROXPT53GTq6y+DwH2vY2up0T
	l+2CiyJRl7E8YlgJ3Zhs5HJ4VACfIRQXAdU51KDqzP6tn/XKBcPV8gEz1WwbjXpK04xM1K
	tpFt00b325cStfMAh79TBHx8NPJvIiY=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61N1F8vE2962734;
	Mon, 23 Feb 2026 11:53:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=rkuh8RE1SaYB5ngAV
	CW7AE/3ekpYQtmDHEks3VzHXyY=; b=I55CmioejpT6bkGdnsKvpl7K/BUjYZDy4
	3pIr1yLzBd9JiCSbDbST/Ec9TRNItgTD9pUmD+C5Zv1Xd//jiqR5Sk/B2dE1RwYL
	AATB5GnG6pXHa9kYl8EL+cFKQa4/EWR9vgd1SimWBdQoK2matflxO0lbBrD0fKR5
	gZ8jwq0AsUnMmJ+qqrtf4vcEN7zQaNtlZ21JZ/3WT67KN1Vcoqzm2Yzi5qnlZC6w
	neicizMdfM/QggAYJy4jdWsbRe4BSOu/RIOFyYwy70M2Dqmp9NY0Knxpy4GDdYyA
	MALJANSNhseMmAQ58hSoti0FrJXgfB3W6HKk7bU3AlCGJdUN8qWtA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf24g6qap-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Feb 2026 11:53:19 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61NBDPWt030385;
	Mon, 23 Feb 2026 11:53:18 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cfrhk4gru-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Feb 2026 11:53:18 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61NBrGs731129866
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Feb 2026 11:53:16 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 83CA52004D;
	Mon, 23 Feb 2026 11:53:16 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5FF3320043;
	Mon, 23 Feb 2026 11:53:16 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 23 Feb 2026 11:53:16 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 3FCCCE0B55; Mon, 23 Feb 2026 12:53:16 +0100 (CET)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org
Subject: [PATCH 1/4] mm/page_table_check: Pass mm_struct to pxx_user_accessible_page()
Date: Mon, 23 Feb 2026 12:53:13 +0100
Message-ID: <68c2f6df2955033cbf1ccbd2b5c2816e72ac345c.1771845678.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1771845678.git.agordeev@linux.ibm.com>
References: <cover.1771845678.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=TNRIilla c=1 sm=1 tr=0 ts=699c3faf cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=pGY3QCu7MjYVx_q7SwQA:9
X-Proofpoint-GUID: CSTS6ZcxiwQHiHahNP_pkftR7dwc7dEB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIzMDA5OSBTYWx0ZWRfX8meC9A58lixm
 XJ917+b0HnNVBM6bs3817+Qsqyx/N/+QJam8EoRkcPnVMeL53kLDYsNIJGlRpaPY20AkebPPBLd
 Vmh5Ap68PCfldNzudENvaBcEBwboC2H9yra5pxDgiZ6jenFaogRJKWRxfSBEETkzhkL6wSEr5yP
 /4sV3+CnMKF2KXlgZPkd+ThcEtB8xTTujY7veaeDFO47sWKXZouZ/L3W3h7Tu53u36Tr5gfG9+o
 8yxMMiqttTxxsE/mOQGbWS5zcRPP9aooSrCVszcaftwHkkbToDFa81/r1OqJFn8gWkPZ3qIWg5k
 ScgqmcFLp8VJvHsz7j38ekPqdpY8FfUPOuTctCk/cwXlW6hRvi87xoh5BU43423SuId3uyuiTPB
 8MF/vGmvA/clufMlgabcPWZUqIMRBEgz+6aF8egY2PPhI2h4jivcgWDo27VUyDhfec4Excg9vMQ
 kG2EYG1Iv+dXDVjf97A==
X-Proofpoint-ORIG-GUID: CSTS6ZcxiwQHiHahNP_pkftR7dwc7dEB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-23_02,2026-02-20_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602230099
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: D54DA180008
X-Stat-Signature: mohjswqxkmdihjsyrp4573srrjh8kmjn
X-HE-Tag: 1771849958-560500
X-HE-Meta: U2FsdGVkX19JpYPxmTi4jPyEhjtnAS/Kp1e1fYFUk+Y4uBqszAxqkE2WBp15PErWUL5OQNXTqYUTrANMwnuwv+dXWsPhRVSpGD8a/1D8tBcIAQpYiN71h7Fjtp5EieL9J0DLxjd10jwYOlzrJd9UISpfVk6iq5S/l204fvVsBuRpcQkntrjxSD2ElG48k0PxVne6wtbht54EnB3HnVbWSq8K+1tLwWc3yNylaTRaawZwti93tQ4JUAHHcQBaA6M9IdtFCItqlKjikTnCafJQxfiHgzgbj5LmokUOphZF+lFfIFkzSW5sA6Gyf4IaJgfsvRskjMPm+7TA5x3ofweyMi3fPAWkXeMYBZf/blt8IW7mrs03fsSUKpuYZFXrIicb03uhXa6gLc/3LHVaUMOG4vPx7viXRqZSi5AuiWXREd9z9Xs5Mhb/UNkHVvI0jSsL+ZfY8WjNpXgv046nOZQkj7WQ507rV8G424qw21KlIGKJ9VGOdtzDmXs4aJOE2C0o7CAyD3IENP0tv+kmHzoqrr4yrDC4HHk9Jrx5/0glRJJLPvB7xTsw57ZmjTfXT+EdQ9osYK8RqVMI3EdmT82UVj3cSSC2VZ7R7daoBv/HUb+Gv9upvHnt7oWNbY0rSbJ6Og4PAuxOudpuuuvSU0ADqXR6G9W2Z9BrtDvH2cgbkKWRwNskuDFXm/V69ZjUoGTSkkJyCvz/Y7AhO4hYrtuzQAItFSotLRdkuDHGGJOUdtGbWkQgifS5goLYuwV7mmMHtB75gmTdyzJiDIEMeuyoT5ADAIlUgE4ZAAvibdvalvb9fynqmHOIr3ZC0fXgEzTy8h1Kge4g3dDYSmY2XIdRKAshBciSzy3l37uEUJarIFwrGcfcZuJjyXEXIuJeEowUd4NqPgHp5/uPNSHYG6fHHz6GHdtlUpNGV5wT9ISytUpKSnIPyFO79YuXLZ7ye7LcbqaaZeF3WWLfuFdj4rx
 cuue2HFZ
 34Ekt6wKBu+zLyLToeOpUzjmcyGNUgu/X+UaaZVhUXaNyv7EWx+FS7Bf9uB0ThehINB/TT84kLOxd1Zdu7I+QkHGcnfl/T9gaQ4KN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Tobias Huschle <huschle@linux.ibm.com>

Unlike other architectures, s390 does not have means to
distinguish kernel vs user page table entries - neither
an entry itself, nor the address could be used for that.
It is only the mm_struct that indicates whether an entry
in question is mapped to a user space. So pass mm_struct
to pxx_user_accessible_page() callbacks.

[agordeev@linux.ibm.com: rephrased commit message, removed braces]

Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Tobias Huschle <huschle@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
---
 arch/arm64/include/asm/pgtable.h |  6 +++---
 arch/riscv/include/asm/pgtable.h |  6 +++---
 arch/x86/include/asm/pgtable.h   |  6 +++---
 mm/page_table_check.c            | 15 ++++++---------
 4 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pg=
table.h
index b3e58735c49b..ccf0e0638767 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1263,17 +1263,17 @@ static inline int pmdp_set_access_flags(struct vm=
_area_struct *vma,
 #endif
=20
 #ifdef CONFIG_PAGE_TABLE_CHECK
-static inline bool pte_user_accessible_page(pte_t pte, unsigned long add=
r)
+static inline bool pte_user_accessible_page(struct mm_struct *mm, unsign=
ed long addr, pte_t pte)
 {
 	return pte_valid(pte) && (pte_user(pte) || pte_user_exec(pte));
 }
=20
-static inline bool pmd_user_accessible_page(pmd_t pmd, unsigned long add=
r)
+static inline bool pmd_user_accessible_page(struct mm_struct *mm, unsign=
ed long addr, pmd_t pmd)
 {
 	return pmd_valid(pmd) && !pmd_table(pmd) && (pmd_user(pmd) || pmd_user_=
exec(pmd));
 }
=20
-static inline bool pud_user_accessible_page(pud_t pud, unsigned long add=
r)
+static inline bool pud_user_accessible_page(struct mm_struct *mm, unsign=
ed long addr, pud_t pud)
 {
 	return pud_valid(pud) && !pud_table(pud) && (pud_user(pud) || pud_user_=
exec(pud));
 }
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pg=
table.h
index 08d1ca047104..affe46cf3bc5 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -984,17 +984,17 @@ static inline void set_pud_at(struct mm_struct *mm,=
 unsigned long addr,
 }
=20
 #ifdef CONFIG_PAGE_TABLE_CHECK
-static inline bool pte_user_accessible_page(pte_t pte, unsigned long add=
r)
+static inline bool pte_user_accessible_page(struct mm_struct *mm, unsign=
ed long addr, pte_t pte)
 {
 	return pte_present(pte) && pte_user(pte);
 }
=20
-static inline bool pmd_user_accessible_page(pmd_t pmd, unsigned long add=
r)
+static inline bool pmd_user_accessible_page(struct mm_struct *mm, unsign=
ed long addr, pmd_t pmd)
 {
 	return pmd_leaf(pmd) && pmd_user(pmd);
 }
=20
-static inline bool pud_user_accessible_page(pud_t pud, unsigned long add=
r)
+static inline bool pud_user_accessible_page(struct mm_struct *mm, unsign=
ed long addr, pud_t pud)
 {
 	return pud_leaf(pud) && pud_user(pud);
 }
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtabl=
e.h
index 1662c5a8f445..f9353d5c7464 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1680,17 +1680,17 @@ static inline bool arch_has_hw_nonleaf_pmd_young(=
void)
 #endif
=20
 #ifdef CONFIG_PAGE_TABLE_CHECK
-static inline bool pte_user_accessible_page(pte_t pte, unsigned long add=
r)
+static inline bool pte_user_accessible_page(struct mm_struct *mm, unsign=
ed long addr, pte_t pte)
 {
 	return (pte_val(pte) & _PAGE_PRESENT) && (pte_val(pte) & _PAGE_USER);
 }
=20
-static inline bool pmd_user_accessible_page(pmd_t pmd, unsigned long add=
r)
+static inline bool pmd_user_accessible_page(struct mm_struct *mm, unsign=
ed long addr, pmd_t pmd)
 {
 	return pmd_leaf(pmd) && (pmd_val(pmd) & _PAGE_PRESENT) && (pmd_val(pmd)=
 & _PAGE_USER);
 }
=20
-static inline bool pud_user_accessible_page(pud_t pud, unsigned long add=
r)
+static inline bool pud_user_accessible_page(struct mm_struct *mm, unsign=
ed long addr, pud_t pud)
 {
 	return pud_leaf(pud) && (pud_val(pud) & _PAGE_PRESENT) && (pud_val(pud)=
 & _PAGE_USER);
 }
diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index 2708c2b3ac1f..53a8997ec043 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -151,9 +151,8 @@ void __page_table_check_pte_clear(struct mm_struct *m=
m, unsigned long addr,
 	if (&init_mm =3D=3D mm)
 		return;
=20
-	if (pte_user_accessible_page(pte, addr)) {
+	if (pte_user_accessible_page(mm, addr, pte))
 		page_table_check_clear(pte_pfn(pte), PAGE_SIZE >> PAGE_SHIFT);
-	}
 }
 EXPORT_SYMBOL(__page_table_check_pte_clear);
=20
@@ -163,9 +162,8 @@ void __page_table_check_pmd_clear(struct mm_struct *m=
m, unsigned long addr,
 	if (&init_mm =3D=3D mm)
 		return;
=20
-	if (pmd_user_accessible_page(pmd, addr)) {
+	if (pmd_user_accessible_page(mm, addr, pmd))
 		page_table_check_clear(pmd_pfn(pmd), PMD_SIZE >> PAGE_SHIFT);
-	}
 }
 EXPORT_SYMBOL(__page_table_check_pmd_clear);
=20
@@ -175,9 +173,8 @@ void __page_table_check_pud_clear(struct mm_struct *m=
m, unsigned long addr,
 	if (&init_mm =3D=3D mm)
 		return;
=20
-	if (pud_user_accessible_page(pud, addr)) {
+	if (pud_user_accessible_page(mm, addr, pud))
 		page_table_check_clear(pud_pfn(pud), PUD_SIZE >> PAGE_SHIFT);
-	}
 }
 EXPORT_SYMBOL(__page_table_check_pud_clear);
=20
@@ -211,7 +208,7 @@ void __page_table_check_ptes_set(struct mm_struct *mm=
, unsigned long addr,
=20
 	for (i =3D 0; i < nr; i++)
 		__page_table_check_pte_clear(mm, addr + PAGE_SIZE * i, ptep_get(ptep +=
 i));
-	if (pte_user_accessible_page(pte, addr))
+	if (pte_user_accessible_page(mm, addr, pte))
 		page_table_check_set(pte_pfn(pte), nr, pte_write(pte));
 }
 EXPORT_SYMBOL(__page_table_check_ptes_set);
@@ -241,7 +238,7 @@ void __page_table_check_pmds_set(struct mm_struct *mm=
, unsigned long addr,
=20
 	for (i =3D 0; i < nr; i++)
 		__page_table_check_pmd_clear(mm, addr + PMD_SIZE * i, *(pmdp + i));
-	if (pmd_user_accessible_page(pmd, addr))
+	if (pmd_user_accessible_page(mm, addr, pmd))
 		page_table_check_set(pmd_pfn(pmd), stride * nr, pmd_write(pmd));
 }
 EXPORT_SYMBOL(__page_table_check_pmds_set);
@@ -257,7 +254,7 @@ void __page_table_check_puds_set(struct mm_struct *mm=
, unsigned long addr,
=20
 	for (i =3D 0; i < nr; i++)
 		__page_table_check_pud_clear(mm, addr + PUD_SIZE * i, *(pudp + i));
-	if (pud_user_accessible_page(pud, addr))
+	if (pud_user_accessible_page(mm, addr, pud))
 		page_table_check_set(pud_pfn(pud), stride * nr, pud_write(pud));
 }
 EXPORT_SYMBOL(__page_table_check_puds_set);
--=20
2.51.0


