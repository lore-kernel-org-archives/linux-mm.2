Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BA75CAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:15:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E69A7280002; Tue,  9 Sep 2025 05:15:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF26D940007; Tue,  9 Sep 2025 05:15:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE248280002; Tue,  9 Sep 2025 05:15:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B7B38940007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:15:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 885931603DD
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:15:38 +0000 (UTC)
X-FDA: 83869153956.01.B51519D
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5B0514000A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:15:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ocmyOY+8;
	spf=pass (imf12.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757409336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8lpZ7Kcjm736hRttCDDPd8Oh+DFxjiym2RbVj81INmM=;
	b=l4wuPxKAkG/Bkb3L633Uy7ZqGCjeXxDJU39yNhyowDGmQg0q+X/SZmhsf77KMbt8U1/me5
	A4Y7qpybJ0E1S9kmLy1yF0Z8EJf7G2DHUljEnodiuL5lQorUlkNIl/wvPiS2l0gTaJ+SJu
	988sxojJCbl6DL9Ac3WqSsLKVIX1p+M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ocmyOY+8;
	spf=pass (imf12.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757409336; a=rsa-sha256;
	cv=none;
	b=TRt1dsgNdD/AiWctDAF8Sw4KOKDYjQS4mjP/jYlx1fhGEj+g0C6lSdcSE1tgqpJwdb9wsX
	Yi7dc12fjR91Cb09VYANxW1q1kMeC5lyfiVSF/GTQq1JcVoAa++ZoqojfqgiG7KFNLx3dQ
	cM+zEgamKtYeIVOrxpMk1zybSPH0kJM=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58990div031661;
	Tue, 9 Sep 2025 09:15:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=8lpZ7Kcjm736hRttC
	DDPd8Oh+DFxjiym2RbVj81INmM=; b=ocmyOY+81FEpgusNJXMxmGzziiAMZU2w8
	JSX1isTopHv9NlD59UxHu/ctRCubyO2slf6T345AZI8ofUGk7NZepHEOfjS4X4bG
	SIQeD+FCUaSW/+EWOO4gWR+M3tEsnoysTxlxYo9+0o7g/6/dMkds73O6ZTaLERBL
	4IUNFDC0uFjdgfsLoJDfpdOyYJXQ9zKB9YH70IuMI+6cV7sNDcL24z6W47r3QJkV
	Y2IVnR6DAGbp2uLUwfTT9LXBTK+T4CQAgb80RQG5bTw8XCS/SxFvJzDaUF+FZ2ZW
	vNZPj8td04UZtGyBECIXZsJTmnDy7UN9QlPsZyFLQJbHv3nbm/cIw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490acqxn9d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 09:15:29 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5897G6Bj017219;
	Tue, 9 Sep 2025 09:15:28 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4911gma5ct-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 09:15:28 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5899FSfl29950484
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Sep 2025 09:15:28 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E41E158043;
	Tue,  9 Sep 2025 09:15:27 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BDA8858060;
	Tue,  9 Sep 2025 09:15:22 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com.com (unknown [9.36.2.198])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Sep 2025 09:15:22 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pasha.tatashin@soleen.com, sweettea-kernel@dorminy.me,
        nicholas@linux.ibm.com, christophe.leroy@csgroup.eu,
        alexghiti@rivosinc.com, Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH v17 11/12] powerpc: mm: Use set_pte_at_unchecked() for internal usages
Date: Tue,  9 Sep 2025 19:13:34 +1000
Message-ID: <20250909091335.183439-12-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250909091335.183439-1-ajd@linux.ibm.com>
References: <20250909091335.183439-1-ajd@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 63LcHXFzzkovazD-aRXH5GGwkMQxYNTi
X-Authority-Analysis: v=2.4 cv=Mp1S63ae c=1 sm=1 tr=0 ts=68bff031 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=aG8EAFyCJnWj3sFUJ80A:9
X-Proofpoint-ORIG-GUID: 63LcHXFzzkovazD-aRXH5GGwkMQxYNTi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAwMCBTYWx0ZWRfXx1Yd4G+KdQRj
 o6pEaUCIlr5tzQVwA/upa5zjgdcR62dV5MKecMSPwt6wdSHHMJ6TlCyZp9Qp9rTmvX3PuIvVUnN
 Ut60YYspVxOcHFsvQ+5gpDG6P/rUg8a2d0jFB0oUtvxEKbhH184fsxqaAGF4Y0qG+Y5LZzn9D0D
 kDyyQ661GmDBN4Ot3Hb0V5OAd7iYh1oJA2uK7w/+BeXTq7ZgKIZ3tI/eArVWoS9sFR9SHJgPZAe
 AYaPYh3pD0uTOBBCyNJfXTo75FFVDFhirFFMm20IqEPVf1W2MfEKBbPapX62BQ8XiD0E6fy2uaq
 zbUHupzDOfL3VHXfBqfm0k1yDBG28ei44lWzOdkG58B2WAnjLgo0pljlyf8hbN/UrA8gv83Fhsm
 8pdUzHZX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 clxscore=1015 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060000
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5B0514000A
X-Stat-Signature: jw8qsr5upfcgii77jyzdcjkg953zczi7
X-HE-Tag: 1757409336-756543
X-HE-Meta: U2FsdGVkX1+Ed6apSKORGxs+laQoNDpCeycxk0iGF8j0luGJuF/5ugg8hYhfDKY33TsPuEFmAKIImVkqqg0xGnmmnXT2imEsx37tHCa6W7bIgvRhqaRjV6GNFDdsP+8GQYg4dOPa0dtyLHjh2DyN+mWyldPCyEeIaALJ519FimJ+PS25fMno3mRBxj+sFpvJR339zjXsEorGckHLUE6f3KrIJiTRAkAvlredGDwYa4ve8lKrxx0gyZOWMaNUInxUWDbsSSmtUfwbanBQw/mp9wFBX1+9pmsEPVERBabj/ziLPxZcLKfvUNGREdjneH1m7PZXp6iOcruPFOX4D1wFeP3yeR0QQMk9uZ63zH4R+Zxv58oAkZWqyBBIaBNmQ4IVpqO77d7ZQZYDscELXLFlZcvQbynYRVJ3NduCkOzaMe3eo8+//VnINwbkg+PWTLkmcAQShDmhgnCB8ZwvmmFtoszHJvILR9/45To6FtdmLIVtM/xhYdY2CJ3wPdc8Ho2Lnq4D8GBkx1LlNhdRLUWnEueUYaqOcab97aRUWfB4a4VLbrxeOk/s5XGR5PhqQio/m2PFKB/rZJqEvOReFAPbTi5BxGEVYGDLjW2wlk04qa2Ghqsxr/zJXmFrI0VqsKf35x9zc1uCK+LXsWoBY5SsNFPVrzt8AmGeNQJg5Zg5Af0AcZKw2AQSamgUvTwfimNpiTw9z5cYFBH68bAHzoq1SHBK0nqvJp8QJF0t/nKgzOyPo1XbMsDw5Ye7uQj/TilDUUoZ/NmLJh5cjTXwCfQqDrlsHTsKXx4ki01ajzwSC6x3oVuNTAFFicWuJpjPkgm7rkWD0+Q3p+J1uaBuuY46V5tiVDeisxGeyhMb1KQ8taymPjr5bw0wn3UbfRuyqwtWJlfqIUxAUaWQl29zOs0vG/Ct+/wkbWX0cHN0LvZ5dMYSMoBZuTKLjrPQw2FSOG1a0qZm5EGzKhrxjsUzIdm
 G/6Nbvny
 mFGL1K2Ri9elVTFHFoVcy+lvrV/tdqq4IGIXY935fYWVw3fOX4AIn6RXnPivTf5jazBOU6Xp/+7X2Sz8nsBUpXVYENamgx7ZaGXtw0yGDgKgXcE/DqfRDyWyOVL0o9NWv6JI5vrUFr0Fzo655MfEZAw2w5PYBJNt9WJf8GBHjpuql22rb3M6qWTWL5maOkY9D3dTxJuo4o244eQFeBDldIUUUwNYolRC84GG/JYOe9jgv6TSsIb9cDyO75gDHeui1gUZOZiFpn9+HKQNWGDCJ3BNvYD6Uxierp6WXjQ9EL34AxNKeshWJZVs+3KCnalwNXU83t0Elg3uuUMUvOwR7PSZ4HSvhvC3fvf/6557E4BMfDRo9Thj3tkGdEw==
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
index fa43f663e615..3983efb365cc 100644
--- a/arch/powerpc/include/asm/pgtable.h
+++ b/arch/powerpc/include/asm/pgtable.h
@@ -34,6 +34,8 @@ struct mm_struct;
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
index 73977dbabcf2..b2541bf33d01 100644
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
index 56d7e8960e77..7b69cd16e011 100644
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
2.51.0


