Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69AFBC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 06:28:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 092F2900041; Wed, 13 Aug 2025 02:28:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01A288E01B6; Wed, 13 Aug 2025 02:28:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E24C9900041; Wed, 13 Aug 2025 02:28:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D01098E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:28:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 855251A027C
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:28:15 +0000 (UTC)
X-FDA: 83770754550.09.AD5B1C3
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1D5F540005
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:28:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=LQ7YkoUl;
	spf=pass (imf12.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755066493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/g6kMnd9VlSEFG+9+pA2DC35UOWvtzDmUcNCP71hMuM=;
	b=JBbetjKBcI+cOqHlzmn73PCKKdfsTP9EECkvaGca5jALVKns5+koo07p2XS6E6PQV4efQj
	L9YLEW/SSZpol/8kihHX9z3/aQlkWlSs4W9qDaGpYM/OeY5b00RkvQLVchkbObP4e5rwO3
	12TdsFVa+jgNlBbRIaJSpmJJmPe4Kk8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=LQ7YkoUl;
	spf=pass (imf12.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755066493; a=rsa-sha256;
	cv=none;
	b=z3zVwMD8W99Tx3g5Gkk8cFSPVbapEdBKe2l6pP7qD3XhMd7ADNIlX2lB8uYmWlpRr0jRdA
	F8YQArf1UQ+r89Z/fwnh+mK63pOU/DRlA9smHeCbiyfSS5cDZqyJv6G2Z9f1iYNwoYNFtM
	umx63MQIb2FLQrphM/HdEGSUDbSFqyA=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57CNQEPM015967;
	Wed, 13 Aug 2025 06:28:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=/g6kMnd9VlSEFG+9+
	pA2DC35UOWvtzDmUcNCP71hMuM=; b=LQ7YkoUl2KNWOrGYvJm7WP6V5c8T3sWOi
	uYynaXBOEPs3smOZz0a6DVKeO4tJMqmQcdSgJMnoCFbN5r4+Lkfrl6N9/e3VIKKb
	dlQDWZ6bNVmpVIVECqISLuPrGzbY8GCJ4onuPeJL60zI3yYDLc8A9paAbbvpnz4h
	eAkxIpVleXK3CwWOwDGqtfdSqyBJUPH6DX1xKH0r0EdBxchMFSDBKCTawR8JXANg
	xk883PVNvtNWCTzEL5jflSCoC4yiWU3S2Z8dPQR4MePfgeT5o5YDOHu3cml6CQrh
	6hAkFL9QhSYgDjx160uFHmn3s51qvJUncpM03yvZiufPQ7QU5QF4w==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dx14jvp5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 06:28:07 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57D1ew9v010824;
	Wed, 13 Aug 2025 06:28:06 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 48egnup7q9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 06:28:06 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57D6S5K125100852
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 06:28:05 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4511458059;
	Wed, 13 Aug 2025 06:28:05 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5390158058;
	Wed, 13 Aug 2025 06:27:59 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com.com (unknown [9.36.10.70])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Aug 2025 06:27:58 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pasha.tatashin@soleen.com, sweettea-kernel@dorminy.me,
        nicholas@linux.ibm.com, christophe.leroy@csgroup.eu,
        Rohan McLure <rmclure@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH v16 12/13] powerpc: mm: Use set_pte_at_unchecked() for internal usages
Date: Wed, 13 Aug 2025 16:26:13 +1000
Message-ID: <20250813062614.51759-13-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250813062614.51759-1-ajd@linux.ibm.com>
References: <20250813062614.51759-1-ajd@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rqUBxPOu36iDwos4bh3fv826WxLCDkT8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIyNCBTYWx0ZWRfX3mF2m1it+9T/
 4veE5T4RO95vQp8Mxd4c6hNjDlPUIWA6Xh+Q6vt1Yhgrd9zZqgtD1cCakYT5+1x+/My2NkiPjpw
 bP2LYW5yTC/jyuwm5a3dL8v/6r8FWlXZ/CQzpOTPUWd8AeUsFQdkT1K5CfBn0nSCSUKKZO9oPsb
 72+M9sucPofAe0fpnY85Ct+XiHL2vPWF6yFH7mcOoC5R7OHGiolTWY8BzKOAjmLpGugKrkXzQjn
 FWhrBgqBPd/PsdZlHTTfn8MnBCAuM2kP2AuNZsJu3GxmtzUysKCeDy7mOBr0qSeXYPPtb5KM/hw
 J7770KQAjxadl4SoFPoOVmegDW6hL9EwiCpwe1TpLDifcqSZ+/WSI74JukkZzCu/SycTIHdCV9q
 81v4kBe5
X-Proofpoint-GUID: rqUBxPOu36iDwos4bh3fv826WxLCDkT8
X-Authority-Analysis: v=2.4 cv=fLg53Yae c=1 sm=1 tr=0 ts=689c3077 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=aG8EAFyCJnWj3sFUJ80A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_08,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508120224
X-Rspamd-Queue-Id: 1D5F540005
X-Rspam-User: 
X-Stat-Signature: tkwmmzrnerx73hma4xp5azahwmrd5o96
X-Rspamd-Server: rspam09
X-HE-Tag: 1755066492-205189
X-HE-Meta: U2FsdGVkX19jc0zZsMSs/yQihq4BbiTZqnxOTciA6rNuNdW4m0Dc+TSQ5JZNwvADLYdCKzFX2g78NaztlTGF0Xxbg81Aa4TQSCVo7nhUSW0mES/MUibBLjqsP80+RGWzYbctvfP2gUcIGxygcopN0gOzzAhb20TH+h0Cxu4crx+kDBIyLooTmIOiR6RuDpYDms8I+d17xRyJ8TbQEuWhYbDNjb+Fq5NBH0PpYt4gs0ppZh0zwIMAoNMt1bypJ9BXP8vcIm3S4dazYt9DJaLW2UVpNtMcCqfpwpUM6LbMphVfTQGQaygVC8csbQUEJC4Madw9GBR+S4g+I73nTmUvDn+p5LknigbkKXQphSJ6pimMp8SeBezOFRhEFsIgoeXvR+GJMIoo2FNskb5Ruysn5yKSCBnFa/x8nUA6UUcQ2g1fsrC7csXXE1+HSBCt3KlKU+FX2qYDK/A25vQ/x2BN5w6gCtPqJcP3tv7Z1dy2zp3IeusU++z4QY8cmGDn111LC2hlgse6tVz4oC9XA3DgPuamZyVzUKanUZWmz+kxfVQc0ROP4Uk9Szg2pOVMCzdUKQR9TgaLvB+3JOhRfqJ7NP+VFpNlEeKZ4fuQM3dGWJelcpdjfDfMukQnkfaOq9OkIHXHUDJoUzZPXPcpaQRvmMuD8ZCAwhQiK6bjoCq8siIVNwb9j0TQI9qIaNrrR/Vpr5gZ8N1dju1pPUnLuXuTGYzZdx0c/TarV2rl96A5bG8xEbuRnlFwuYZgLXeoRq30/egEhrRFyhqNsdoioQYr/+5nLQWAc/eDttCbYJtoeSzj0wmbqgxPzGuCihd6jcQoDUlxW4Gy0PUT16pZa5/HtuQ70yM9arvT3p0Hq3UhVOyA+1yLwKyJVnCw+dZamxN8qvWxZol3wH/mBNoA7v4vyMQeGS9IEpjmmQkqaS6N8ykQyK7BrZ+GE5aczpZHO1hnf7ywSJOHSJmdivybYGg
 XcjxsGQL
 hFRB5AjBlSgqOPwDu06uYNWlKXobIwToDANA15ptqqGdT9xLXHLx5R7IpdBbjAwQj/ySgYBfg/z2J77r5cdC3cctcO5KXB70060f7lNB4QQjmI7XMy8S4xOwJR1tmWurPUvkVDitd4K+cYXH3FXYDKzuIy42yR64xYSL6tNm3AdUiUbN5zqRNhllC456CfaNwbZsmpBewGTIxqbNPbTKG9VRhk2FrHekcbw7E24skQMksNlI+IR5K8hcpz0fHCvQiJ7O6EExd6hlPZ5ljU0GeIDTUqXw5MrPge35CSblGY3HMXeYlMXhKrIfthUtS9BMUU+qAuGDVZGORrzpB6zyKIR1KGWHkrJ+abGwKLB72PzFt0/VKQajcK4OG0g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rohan McLure <rmclure@linux.ibm.com>

In the new set_ptes() API, set_pte_at() (a special case of set_ptes())
is intended to be instrumented by the page table check facility. There
are however several other routines that constitute the API for setting
page table entries, including set_pmd_at() among others. Such routines
are themselves implemented in terms of set_ptes_at().

A future patch providing support for page table checking on powerpc
must take care to avoid duplicate calls to
page_table_check_p{te,md,ud}_set(). Allow for assignment of pte entries
without instrumentation through the set_pte_at_unchecked() routine
introduced in this patch.

Cause API-facing routines that call set_pte_at() to instead call
set_pte_at_unchecked(), which will remain uninstrumented by page
table check. set_ptes() is itself implemented by calls to
__set_pte_at(), so this eliminates redundant code.

[ajd@linux.ibm.com: don't change to unchecked for early boot/kernel mappings]
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Acked-by: Madhavan Srinivasan <maddy@linux.ibm.com>
---
v13: don't use the unchecked version for early-boot kernel mappings (Pasha)
---
 arch/powerpc/include/asm/pgtable.h       | 2 ++
 arch/powerpc/mm/book3s64/pgtable.c       | 6 +++---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 6 +++---
 arch/powerpc/mm/pgtable.c                | 8 ++++++++
 4 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
index d0938e9c33fb..4fe970992147 100644
--- a/arch/powerpc/include/asm/pgtable.h
+++ b/arch/powerpc/include/asm/pgtable.h
@@ -46,6 +46,8 @@ struct mm_struct;
 void set_ptes(struct mm_struct *mm, unsigned long addr, pte_t *ptep,
 		pte_t pte, unsigned int nr);
 #define set_ptes set_ptes
+void set_pte_at_unchecked(struct mm_struct *mm, unsigned long addr,
+			  pte_t *ptep, pte_t pte);
 #define update_mmu_cache(vma, addr, ptep) \
 	update_mmu_cache_range(NULL, vma, addr, ptep, 1)
 
diff --git a/arch/powerpc/mm/book3s64/pgtable.c b/arch/powerpc/mm/book3s64/pgtable.c
index c9431ae7f78a..ff0c5a1988f8 100644
--- a/arch/powerpc/mm/book3s64/pgtable.c
+++ b/arch/powerpc/mm/book3s64/pgtable.c
@@ -127,7 +127,7 @@ void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 	WARN_ON(!(pmd_leaf(pmd)));
 #endif
 	trace_hugepage_set_pmd(addr, pmd_val(pmd));
-	return set_pte_at(mm, addr, pmdp_ptep(pmdp), pmd_pte(pmd));
+	return set_pte_at_unchecked(mm, addr, pmdp_ptep(pmdp), pmd_pte(pmd));
 }
 
 void set_pud_at(struct mm_struct *mm, unsigned long addr,
@@ -144,7 +144,7 @@ void set_pud_at(struct mm_struct *mm, unsigned long addr,
 	WARN_ON(!(pud_leaf(pud)));
 #endif
 	trace_hugepage_set_pud(addr, pud_val(pud));
-	return set_pte_at(mm, addr, pudp_ptep(pudp), pud_pte(pud));
+	return set_pte_at_unchecked(mm, addr, pudp_ptep(pudp), pud_pte(pud));
 }
 
 static void do_serialize(void *arg)
@@ -549,7 +549,7 @@ void ptep_modify_prot_commit(struct vm_area_struct *vma, unsigned long addr,
 	if (radix_enabled())
 		return radix__ptep_modify_prot_commit(vma, addr,
 						      ptep, old_pte, pte);
-	set_pte_at(vma->vm_mm, addr, ptep, pte);
+	set_pte_at_unchecked(vma->vm_mm, addr, ptep, pte);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index be523e5fe9c5..8c3b0f1750e4 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1606,7 +1606,7 @@ void radix__ptep_modify_prot_commit(struct vm_area_struct *vma,
 	    (atomic_read(&mm->context.copros) > 0))
 		radix__flush_tlb_page(vma, addr);
 
-	set_pte_at(mm, addr, ptep, pte);
+	set_pte_at_unchecked(mm, addr, ptep, pte);
 }
 
 int pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot)
@@ -1617,7 +1617,7 @@ int pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot)
 	if (!radix_enabled())
 		return 0;
 
-	set_pte_at(&init_mm, 0 /* radix unused */, ptep, new_pud);
+	set_pte_at_unchecked(&init_mm, 0 /* radix unused */, ptep, new_pud);
 
 	return 1;
 }
@@ -1664,7 +1664,7 @@ int pmd_set_huge(pmd_t *pmd, phys_addr_t addr, pgprot_t prot)
 	if (!radix_enabled())
 		return 0;
 
-	set_pte_at(&init_mm, 0 /* radix unused */, ptep, new_pmd);
+	set_pte_at_unchecked(&init_mm, 0 /* radix unused */, ptep, new_pmd);
 
 	return 1;
 }
diff --git a/arch/powerpc/mm/pgtable.c b/arch/powerpc/mm/pgtable.c
index dfaa9fd86f7e..bf90becb6cd6 100644
--- a/arch/powerpc/mm/pgtable.c
+++ b/arch/powerpc/mm/pgtable.c
@@ -224,6 +224,14 @@ void set_ptes(struct mm_struct *mm, unsigned long addr, pte_t *ptep,
 	}
 }
 
+void set_pte_at_unchecked(struct mm_struct *mm, unsigned long addr,
+			  pte_t *ptep, pte_t pte)
+{
+	VM_WARN_ON(pte_hw_valid(*ptep) && !pte_protnone(*ptep));
+	pte = set_pte_filter(pte, addr);
+	__set_pte_at(mm, addr, ptep, pte, 0);
+}
+
 void unmap_kernel_page(unsigned long va)
 {
 	pmd_t *pmdp = pmd_off_k(va);
-- 
2.50.1


