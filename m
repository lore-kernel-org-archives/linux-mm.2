Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 933EECA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:15:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E91EC8E0020; Tue,  9 Sep 2025 05:15:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1C358E0001; Tue,  9 Sep 2025 05:15:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBB5D280003; Tue,  9 Sep 2025 05:15:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B3AEB940007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:15:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 807621A0454
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:15:44 +0000 (UTC)
X-FDA: 83869154208.06.73D61B0
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf09.hostedemail.com (Postfix) with ESMTP id 40072140012
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:15:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=QqHmGcJX;
	spf=pass (imf09.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757409342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o+xg4rR7RFeVcfxmQkeGwAVcJgo8bMOvgRBpGG/pn/s=;
	b=PTCWriE/dWypYuRFKJMqIZPKrEB+YJHcCBTyBN7RmPw5Eq2hosjU+xrMYVNrfy47MZ4E1q
	/bMo8Ry18sCq3o6uoEZ85sLya66y3S9H+hg+LqD8dL/mU3lH3hepiMWzIN4s9l2N5Lq8tn
	ml+fhkhfZJxTySjeoCp8vD0DkKKQrQE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757409342; a=rsa-sha256;
	cv=none;
	b=59RUP67NKz/h3szYsI1aG1Nc0CY1rVZi1K4J0F1vcIIe3ILX34AdnqCzdoxf4yVAAsBLoH
	a322Ti9Zxq1uT04i+ywDd9QDmzxDCVf5+l+8q+dWbOUy7sltPG+P+Ua+IIxORzo/HZSB9M
	cwO9gXo0n4EZVxnTeE2cvyXtmyF7a8o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=QqHmGcJX;
	spf=pass (imf09.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5897e93g018353;
	Tue, 9 Sep 2025 09:15:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=o+xg4rR7RFeVcfxmQ
	keGwAVcJgo8bMOvgRBpGG/pn/s=; b=QqHmGcJXo8OFORcG2gXeR2vL9l07bTuFs
	p2RB7khJoGRF9KfDFFkaZBgwhlSNIl59+Bl5t9oSruzeICcKCBdOswO3hQrTcTwo
	I6+UxjWOEM52W4Cq5ixEf+6KITVg5Wlq3gd7VULtmzUMxwznB4bQ6490HhvXXekL
	YU8ZWs0tZh7A7zCnVdY40R+TtSHT5hNGEW1wybtG7vNL0V7JsDZwZaplINQ+tUZm
	GMF2f1D1ufEo1vkz8InLn4lrFshZgxXcWLnCpGrF5ePCCJfW2C4XVXTEMpxbN5zX
	qGqe5kvELyhCkqFPFkH1ofYDw1Wcklx2U7EDsk5tjNlUhhJBj6iVg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490bcspgyu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 09:15:36 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5897Rmvu001177;
	Tue, 9 Sep 2025 09:15:35 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 491203a28n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 09:15:35 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5899FYk918809422
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Sep 2025 09:15:34 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E37C258059;
	Tue,  9 Sep 2025 09:15:33 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 93D2558043;
	Tue,  9 Sep 2025 09:15:28 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com.com (unknown [9.36.2.198])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Sep 2025 09:15:28 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pasha.tatashin@soleen.com, sweettea-kernel@dorminy.me,
        nicholas@linux.ibm.com, christophe.leroy@csgroup.eu,
        alexghiti@rivosinc.com, Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH v17 12/12] powerpc: mm: Support page table check
Date: Tue,  9 Sep 2025 19:13:35 +1000
Message-ID: <20250909091335.183439-13-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250909091335.183439-1-ajd@linux.ibm.com>
References: <20250909091335.183439-1-ajd@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAxMCBTYWx0ZWRfXytjtFwclqjtx
 M4+43InvuwYkhxqrewXM+ALU39LB36Cm+ycBhP5b8l0YsXZAQyuPPsNHpxDvhBr4TduJGSE2RRI
 NX012L9q9+Vfx/HVZgth1CVGAW65e7t+VEJ+rTz6U7xzcV+/Db1Z1FGHKzJZtZHhFCOD6GVMZ02
 GF2oAAsIE14kg43rUGrPv/n3GgAEkKsEwg8vw1sH4VzkuNJWVyhsWh7azAcluazRITm/a0FHTJc
 RIBv0znMYyh2BbDx4s0fU0fcWJscpaVd2O6q6UgNc89ChWqH+49/HaCJJdoiMcchFCJ4kbsg7kC
 x/e7YXLpmOGUafHe1J3GWMi5OZFzzK519nb/VxmkIrcKJgWtyrOAebKAJHL8vpGoyxN/ZZYW0in
 hIq9pS9E
X-Authority-Analysis: v=2.4 cv=SKNCVPvH c=1 sm=1 tr=0 ts=68bff038 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=1UX6Do5GAAAA:8 a=7ipKWUHlAAAA:8
 a=X4bsUGyFbWMdYzZSxZoA:9 a=Et2XPkok5AAZYJIKzHr1:22 a=gpc5p9EgBqZVLdJeV_V1:22
X-Proofpoint-GUID: cgZTVoeKCNURSAMO7cwcrX9K7CSmvmhB
X-Proofpoint-ORIG-GUID: cgZTVoeKCNURSAMO7cwcrX9K7CSmvmhB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060010
X-Rspamd-Queue-Id: 40072140012
X-Stat-Signature: ke9zfsbkogre77k9yfp8gtsa7dosj4dq
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757409342-449163
X-HE-Meta: U2FsdGVkX18R1zHzThBmpKJaGCgcjSe89r6loVo29WC9ZqWBjALz0G/6rnbWOFqZzU0B/0YiDwttivaX+E3fpDR+ZyHskZb9FuhZl7VjhWLep7I78GMmxVyqxIw/ukdlFYT0hDCWTfMpQl1hmh4xf5kHIdlXP5OTTRdldnX809APMA9GPdGIUudkuwmOH0XKE2zRXcd8Xsy67M+rKZWiVcoLn7itYNlAVEri7hPzIYN1S2J4f6kPR2788OyKmIDZ5o/tVxK15015h54t3mAJCa2z9E4N52l7DKWMc6mR68Vof+d0KVP0bgOIdkT8Ufg5uuYcGsbEAjjpNO7G9kAjVbGMjw9WLdHGSVDSYaO1kO/TMI/O7NLABylBwCXpwmZKd8tCDXd5lMif2daDJnOzRzc9JOb20tkBtrhujrdQLpjQycwPZHhsZvBY7lU3Hq4XSQtVzZxUS3eZvjlw9hS+k/ia7awcN6xvSJrpM8S90us9Nver22Ou3dSA8ByWKB1lMs0LyFNGYm4JnmSnpXo3IXCWeGRPke1nmv0cyv//DNSa8GMdOxSC0/n8cNVhXZWM94nq3FnEoJUn1Fxq8iiK4zK5KA4fjiXYiwCF22p1BiSGdXlas9Vr4K8LqE7DQZd8+b7PL/1HJTiV2GaAR60lnPcU3CV38SXaOsG8VwTscADw3E+EJeRVGRSO9AEGOzJGFdHcOtWZleDkzuluiBObRf58UIjaImJWRLALBK/7YRURa1iLJRI3GVW7LdPfpBkloa6D9y4IHxZs/tZvdP5qcm+m3UgAZP2WLlLCwYVRtH6t1gD0bb4+CHUlF4MiuEhruDfOhTEVBJOQEzUILVSu6cNI5p8E5YfrxmzIxLKTPk6wR/wjke07JojuZVrYfPo4yFmzaOt6uoEe6QhBMNKweG80rSxFh5MoIFdRtuwp/FifHzNpPu8/pydbDbKg4JyeUWPNABl1TdnTVaXYDZR
 tGChmLAd
 bDm9M/6ua0k7Daw0VBlFT6rJJGAebBkseOur3qnWGT0bbXEChAOLjfwlAzZLAZw5/lbsSTwalF+HUfXvLKLXY4xwYzDE6Wh/rRIXwy+Fho1fUFQCBlrifk/gfu+DaKY0Cucs9Fa4cJFshsGf2wTO4DjVrqFLIVgv+TQHL2Nz2LZBZRjMgK5bpZNGbiURkAHHx96cJJUFalgFx6VVO24l2te8Q9+Q61uPcb4CuAbbkt5U33+uTqa5sa+NqfUS7/CgvBtEStCMxA+NNR9NEZNPKPECbtQghsKNpEQ6U4HNg1AUkMIlbUi7xlgda5RSKOx6RuPACrQCZpdiSIuNmSPzsh9tIrKoRZgotc+BOV76dw4a361lBXHxKNPdj6Q2EbMh7L3z6iYmuD4AMrGdey8uFXI7XB2+82eEa0JWr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rohan McLure <rmclure@linux.ibm.com>

On creation and clearing of a page table mapping, instrument such calls
by invoking page_table_check_pte_set and page_table_check_pte_clear
respectively. These calls serve as a sanity check against illegal
mappings.

Enable ARCH_SUPPORTS_PAGE_TABLE_CHECK for all platforms.

See also:

riscv support in commit 3fee229a8eb9 ("riscv/mm: enable
ARCH_SUPPORTS_PAGE_TABLE_CHECK")
arm64 in commit 42b2547137f5 ("arm64/mm: enable
ARCH_SUPPORTS_PAGE_TABLE_CHECK")
x86_64 in commit d283d422c6c4 ("x86: mm: add x86_64 support for page table
check")

[ajd@linux.ibm.com: rebase]
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Acked-by: Madhavan Srinivasan <maddy@linux.ibm.com>
---
 arch/powerpc/Kconfig                         |  1 +
 arch/powerpc/include/asm/book3s/32/pgtable.h |  7 ++-
 arch/powerpc/include/asm/book3s/64/pgtable.h | 45 +++++++++++++++-----
 arch/powerpc/include/asm/nohash/pgtable.h    |  8 +++-
 arch/powerpc/mm/book3s64/hash_pgtable.c      |  4 ++
 arch/powerpc/mm/book3s64/pgtable.c           | 11 +++--
 arch/powerpc/mm/book3s64/radix_pgtable.c     |  3 ++
 arch/powerpc/mm/pgtable.c                    |  4 ++
 8 files changed, 68 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 4730c676b6bf..0d3e26a6c308 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -171,6 +171,7 @@ config PPC
 	select ARCH_STACKWALK
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC	if PPC_BOOK3S || PPC_8xx
+	select ARCH_SUPPORTS_PAGE_TABLE_CHECK
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF		if PPC64
 	select ARCH_USE_MEMTEST
diff --git a/arch/powerpc/include/asm/book3s/32/pgtable.h b/arch/powerpc/include/asm/book3s/32/pgtable.h
index b225967f85ea..68864a71ca5f 100644
--- a/arch/powerpc/include/asm/book3s/32/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/32/pgtable.h
@@ -202,6 +202,7 @@ void unmap_kernel_page(unsigned long va);
 #ifndef __ASSEMBLY__
 #include <linux/sched.h>
 #include <linux/threads.h>
+#include <linux/page_table_check.h>
 
 /* Bits to mask out from a PGD to get to the PUD page */
 #define PGD_MASKED_BITS		0
@@ -315,7 +316,11 @@ static inline int __ptep_test_and_clear_young(struct mm_struct *mm,
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
 				       pte_t *ptep)
 {
-	return __pte(pte_update(mm, addr, ptep, ~_PAGE_HASHPTE, 0, 0));
+	pte_t old_pte = __pte(pte_update(mm, addr, ptep, ~_PAGE_HASHPTE, 0, 0));
+
+	page_table_check_pte_clear(mm, addr, old_pte);
+
+	return old_pte;
 }
 
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index 48f3a41317dd..81c220bcbd26 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -144,6 +144,8 @@
 #define PAGE_KERNEL_ROX	__pgprot(_PAGE_BASE | _PAGE_KERNEL_ROX)
 
 #ifndef __ASSEMBLY__
+#include <linux/page_table_check.h>
+
 /*
  * page table defines
  */
@@ -416,8 +418,11 @@ static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 				       unsigned long addr, pte_t *ptep)
 {
-	unsigned long old = pte_update(mm, addr, ptep, ~0UL, 0, 0);
-	return __pte(old);
+	pte_t old_pte = __pte(pte_update(mm, addr, ptep, ~0UL, 0, 0));
+
+	page_table_check_pte_clear(mm, addr, old_pte);
+
+	return old_pte;
 }
 
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR_FULL
@@ -426,11 +431,16 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
 					    pte_t *ptep, int full)
 {
 	if (full && radix_enabled()) {
+		pte_t old_pte;
+
 		/*
 		 * We know that this is a full mm pte clear and
 		 * hence can be sure there is no parallel set_pte.
 		 */
-		return radix__ptep_get_and_clear_full(mm, addr, ptep, full);
+		old_pte = radix__ptep_get_and_clear_full(mm, addr, ptep, full);
+		page_table_check_pte_clear(mm, addr, old_pte);
+
+		return old_pte;
 	}
 	return ptep_get_and_clear(mm, addr, ptep);
 }
@@ -1289,19 +1299,34 @@ extern int pudp_test_and_clear_young(struct vm_area_struct *vma,
 static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 					    unsigned long addr, pmd_t *pmdp)
 {
-	if (radix_enabled())
-		return radix__pmdp_huge_get_and_clear(mm, addr, pmdp);
-	return hash__pmdp_huge_get_and_clear(mm, addr, pmdp);
+	pmd_t old_pmd;
+
+	if (radix_enabled()) {
+		old_pmd = radix__pmdp_huge_get_and_clear(mm, addr, pmdp);
+	} else {
+		old_pmd = hash__pmdp_huge_get_and_clear(mm, addr, pmdp);
+	}
+
+	page_table_check_pmd_clear(mm, addr, old_pmd);
+
+	return old_pmd;
 }
 
 #define __HAVE_ARCH_PUDP_HUGE_GET_AND_CLEAR
 static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
 					    unsigned long addr, pud_t *pudp)
 {
-	if (radix_enabled())
-		return radix__pudp_huge_get_and_clear(mm, addr, pudp);
-	BUG();
-	return *pudp;
+	pud_t old_pud;
+
+	if (radix_enabled()) {
+		old_pud = radix__pudp_huge_get_and_clear(mm, addr, pudp);
+	} else {
+		BUG();
+	}
+
+	page_table_check_pud_clear(mm, addr, old_pud);
+
+	return old_pud;
 }
 
 static inline pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
diff --git a/arch/powerpc/include/asm/nohash/pgtable.h b/arch/powerpc/include/asm/nohash/pgtable.h
index a8bc4f24beb1..3a6630dca615 100644
--- a/arch/powerpc/include/asm/nohash/pgtable.h
+++ b/arch/powerpc/include/asm/nohash/pgtable.h
@@ -29,6 +29,8 @@ static inline pte_basic_t pte_update(struct mm_struct *mm, unsigned long addr, p
 
 #ifndef __ASSEMBLY__
 
+#include <linux/page_table_check.h>
+
 extern int icache_44x_need_flush;
 
 #ifndef pte_huge_size
@@ -122,7 +124,11 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr,
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
 				       pte_t *ptep)
 {
-	return __pte(pte_update(mm, addr, ptep, ~0UL, 0, 0));
+	pte_t old_pte = __pte(pte_update(mm, addr, ptep, ~0UL, 0, 0));
+
+	page_table_check_pte_clear(mm, addr, old_pte);
+
+	return old_pte;
 }
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 
diff --git a/arch/powerpc/mm/book3s64/hash_pgtable.c b/arch/powerpc/mm/book3s64/hash_pgtable.c
index 82d31177630b..ac2a24d15d2e 100644
--- a/arch/powerpc/mm/book3s64/hash_pgtable.c
+++ b/arch/powerpc/mm/book3s64/hash_pgtable.c
@@ -8,6 +8,7 @@
 #include <linux/sched.h>
 #include <linux/mm_types.h>
 #include <linux/mm.h>
+#include <linux/page_table_check.h>
 #include <linux/stop_machine.h>
 
 #include <asm/sections.h>
@@ -230,6 +231,9 @@ pmd_t hash__pmdp_collapse_flush(struct vm_area_struct *vma, unsigned long addres
 
 	pmd = *pmdp;
 	pmd_clear(pmdp);
+
+	page_table_check_pmd_clear(vma->vm_mm, address, pmd);
+
 	/*
 	 * Wait for all pending hash_page to finish. This is needed
 	 * in case of subpage collapse. When we collapse normal pages
diff --git a/arch/powerpc/mm/book3s64/pgtable.c b/arch/powerpc/mm/book3s64/pgtable.c
index ff0c5a1988f8..8be06a3cfcbc 100644
--- a/arch/powerpc/mm/book3s64/pgtable.c
+++ b/arch/powerpc/mm/book3s64/pgtable.c
@@ -10,6 +10,7 @@
 #include <linux/pkeys.h>
 #include <linux/debugfs.h>
 #include <linux/proc_fs.h>
+#include <linux/page_table_check.h>
 
 #include <asm/pgalloc.h>
 #include <asm/tlb.h>
@@ -127,6 +128,7 @@ void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 	WARN_ON(!(pmd_leaf(pmd)));
 #endif
 	trace_hugepage_set_pmd(addr, pmd_val(pmd));
+	page_table_check_pmd_set(mm, addr, pmdp, pmd);
 	return set_pte_at_unchecked(mm, addr, pmdp_ptep(pmdp), pmd_pte(pmd));
 }
 
@@ -144,6 +146,7 @@ void set_pud_at(struct mm_struct *mm, unsigned long addr,
 	WARN_ON(!(pud_leaf(pud)));
 #endif
 	trace_hugepage_set_pud(addr, pud_val(pud));
+	page_table_check_pud_set(mm, addr, pudp, pud);
 	return set_pte_at_unchecked(mm, addr, pudp_ptep(pudp), pud_pte(pud));
 }
 
@@ -179,12 +182,14 @@ void serialize_against_pte_lookup(struct mm_struct *mm)
 pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
 		     pmd_t *pmdp)
 {
-	unsigned long old_pmd;
+	pmd_t old_pmd;
 
 	VM_WARN_ON_ONCE(!pmd_present(*pmdp));
-	old_pmd = pmd_hugepage_update(vma->vm_mm, address, pmdp, _PAGE_PRESENT, _PAGE_INVALID);
+	old_pmd = __pmd(pmd_hugepage_update(vma->vm_mm, address, pmdp, _PAGE_PRESENT, _PAGE_INVALID));
 	flush_pmd_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
-	return __pmd(old_pmd);
+	page_table_check_pmd_clear(vma->vm_mm, address, old_pmd);
+
+	return old_pmd;
 }
 
 pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index b2541bf33d01..10aced261cff 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -14,6 +14,7 @@
 #include <linux/of.h>
 #include <linux/of_fdt.h>
 #include <linux/mm.h>
+#include <linux/page_table_check.h>
 #include <linux/hugetlb.h>
 #include <linux/string_helpers.h>
 #include <linux/memory.h>
@@ -1474,6 +1475,8 @@ pmd_t radix__pmdp_collapse_flush(struct vm_area_struct *vma, unsigned long addre
 	pmd = *pmdp;
 	pmd_clear(pmdp);
 
+	page_table_check_pmd_clear(vma->vm_mm, address, pmd);
+
 	radix__flush_tlb_collapsed_pmd(vma->vm_mm, address);
 
 	return pmd;
diff --git a/arch/powerpc/mm/pgtable.c b/arch/powerpc/mm/pgtable.c
index 7b69cd16e011..a9be337be3e4 100644
--- a/arch/powerpc/mm/pgtable.c
+++ b/arch/powerpc/mm/pgtable.c
@@ -22,6 +22,7 @@
 #include <linux/mm.h>
 #include <linux/percpu.h>
 #include <linux/hardirq.h>
+#include <linux/page_table_check.h>
 #include <linux/hugetlb.h>
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
@@ -206,6 +207,9 @@ void set_ptes(struct mm_struct *mm, unsigned long addr, pte_t *ptep,
 	 * and not hw_valid ptes. Hence there is no translation cache flush
 	 * involved that need to be batched.
 	 */
+
+	page_table_check_ptes_set(mm, addr, ptep, pte, nr);
+
 	for (;;) {
 
 		/*
-- 
2.51.0


