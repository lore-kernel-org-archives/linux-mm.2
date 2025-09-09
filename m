Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A83DCAC589
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:14:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47C506B0024; Tue,  9 Sep 2025 05:14:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 405B96B0026; Tue,  9 Sep 2025 05:14:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A6776B0027; Tue,  9 Sep 2025 05:14:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 13E836B0024
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:14:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CA90016044B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:14:38 +0000 (UTC)
X-FDA: 83869151436.02.D0D34FD
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6AD58100009
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:14:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fy8+zmj7;
	spf=pass (imf14.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757409276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P+NIAqh7BQDBsDClODo0VaBIBEnvSbDD2W3PNG4jHlw=;
	b=izwJaoWjk7iBSy/UBGYvl1mSAGuAILfuDE/Gf4JvevzQYPlRbF9+jMPHPHvsAwY7en1EvD
	W2n0PpFKmrYEKdgs6sIW47scgZ8/nG+omZONOA3sBVtCKFY2GftqyNbBmf/h+2acbW6767
	077AEJORz30FPeIvgmwXdSE73bis/Bw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757409276; a=rsa-sha256;
	cv=none;
	b=QYwypIRRUDdjUo9YGYaIwLa0ZToC7Cl75QfvcJN9z84IUisrHwTWHOo/CMrKlkEMA8l2I7
	fafPuxiW6n0AkX87Om4jfk07HDK0Yxpfy1RyBe2WGJu4JlRAtw5sEcnugvfiM59ahxjhCv
	lDpuYXkuKQXjLfsB4v8ITB+F4QbOaAQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fy8+zmj7;
	spf=pass (imf14.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5895hAAW009402;
	Tue, 9 Sep 2025 09:14:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=P+NIAqh7BQDBsDClO
	Do0VaBIBEnvSbDD2W3PNG4jHlw=; b=fy8+zmj7OYChfQ7oEsTm0SJJ+Ai2e8dsc
	UEZU8geyP1smsFjVRgbufWylkKlymbTHLApF68erqdd5T264P7Nc49DGK4vTlSgr
	mzw7xokYjbxJYOy09maqKnhdHUpdRD0gIUlTYS1yxtNtE+BmzdVmIsuKLqt8IB+H
	7qqU7EhC6k7dpJ4QtmyC7V3S2xv0Sq1MXTkU4qn/tHF51vCgwkae4lEUOVgb9R2A
	jmHLE1RBJcJ1b3kgjoWx6Ccjx3jSZvg7c8tZH3SHsDdFf2nIau6kcKUtCjtnc8BK
	1/TEhqK7hIXdCOnrqIb86TfMwTZxlg176/7WtbWuFugS4uh8/tbog==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cff6sev-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 09:14:30 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5897Dfce017163;
	Tue, 9 Sep 2025 09:14:29 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4911gma56v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 09:14:29 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5899ESgZ14615108
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Sep 2025 09:14:29 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9262D5805E;
	Tue,  9 Sep 2025 09:14:28 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9D2EC58055;
	Tue,  9 Sep 2025 09:14:23 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com.com (unknown [9.36.2.198])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Sep 2025 09:14:23 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pasha.tatashin@soleen.com, sweettea-kernel@dorminy.me,
        nicholas@linux.ibm.com, christophe.leroy@csgroup.eu,
        alexghiti@rivosinc.com
Subject: [PATCH v17 01/12] arm64/mm: Add addr parameter to __set_ptes_anysz()
Date: Tue,  9 Sep 2025 19:13:24 +1000
Message-ID: <20250909091335.183439-2-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250909091335.183439-1-ajd@linux.ibm.com>
References: <20250909091335.183439-1-ajd@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rlllSEL0_SKfb2EiawCib1MctDRZod1E
X-Proofpoint-GUID: rlllSEL0_SKfb2EiawCib1MctDRZod1E
X-Authority-Analysis: v=2.4 cv=EYDIQOmC c=1 sm=1 tr=0 ts=68bfeff6 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=iO9NmEFvf90wNdx_zysA:9
 a=0bXxn9q0MV6snEgNplNhOjQmxlI=:19
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAyMCBTYWx0ZWRfXzPoJMPDc2YxT
 DRqKzgS87MSSwxjI4tkXiUN6HU8UknDU5cve2xbf1jeNY6MiciQUEQyy9u3KVcCurDA6KWNoPaC
 oCdfMCnK+3lbiBdXXeO6o9Dtja11uY8iLVwcHp4rGJKZnpcx+bkLqQlfAINtWhr8fF6FlxblYyX
 /+B7ql/oFL2/wSF9gKxCKaMe0vvEDW4rhFuePhfYlaHjKtYM9jlbVRlGmAxTR/j4bgIIu4/yX3H
 PbKaESYzJXkDFRUJdBtj7eRdsZjsSmZsDKNXzzcx+9VanA2wNRiseLEZV/E4oJp/4nfFBYnMFkj
 wg1G0jPXwNJbCMLh0pFefKyLwq9DCPPjOU4Ou+qGsrfszbmDrC2UgcREPUFYc+jUdrEVfs9gE5y
 Zm314ODy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 suspectscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060020
X-Stat-Signature: u5uiab8krsrwuqc4ibfkauegxkcj3z1e
X-Rspam-User: 
X-Rspamd-Queue-Id: 6AD58100009
X-Rspamd-Server: rspam10
X-HE-Tag: 1757409276-579694
X-HE-Meta: U2FsdGVkX1+wiz5pKTKUnbsmh0pPyiG/ACANu8KgT+rYBxrHOUTkNZ9nfg9EgnMa2V9yYnKJxWWRd2Nm/RB8hOaLMSJUbW1f1O8Ppfx4lARfAnei25TDw5FMPUjnfGHC+TYFAW/s/Khhr1dSe4B3/d4g96DYLiHmfpAyqL8gsitHUd8DDvJ44jDqb+k1nMOytAHggFImqTUmTqW0zlEWPhdvfPzfrrkwzj/9awVFePMerpIiPBzwTbQLANLiU/2n4+lcBRXf5CukqKUwe8Du0z2IlMrjoqBkkpS6ge5xl02lqhK7PM2sFTaJPybVJYs5wAP3ahfrTwe4yRFrgUjmXpY4tfkfM9b+YeMeuAbyE4HNvZOqWbsU9PMKrNPQijmES06LYznTJU6NrtHrxrsUydqMht4+queK9ppuujTrhnHxD/45Rn4+FyqklxZbsgW+1uZNFYFacoEOL7TN13Lr/vo8AkGVOGHYbmszgtWm3EmghA5ZPVLlP8VUtzde1wRnlvCXT0FLnvQShQYf9Fv02zoDbFSkUy+W0bo9Ee2XjMelyxwqA0TKCswZNBxQD3qIyuMEN7Rqjbs8HdOrQ4pIbZTW2boCi5TNUQ8tGRBUBoRKp/w3TBXWtSMos/T6WvFK2icfR/zyaFQTEDbzf7d2Qf0RtErPrHx2RTGdFHGSjDpfcL9xxdOBtAhY8JHtVHXNFK1qX6LolzPxK4Rh1a4dZoL3Z7NPhPVVthulwt1lDtWDKh5OWj4eCoR0XiDKHpA0eWVFYXP22bPYsNIy1R110IXOe4MY5u9GYsCbTppxCMOi/pm7Uq6nXmBWSS/EOdFW+mTVkRlpmM1L2Egp5d91KdT3wNvdvxtHHbs1E/58P+er1IfH6s0niRiabuapMrBQuxhKiU6oYsb+j2YYn5EqlufZH3MRERDqusIAL+um00HipNkge1lqfNddziTcHpCI5Gzw0FbAuU2aPFhpBTO
 LdUqhpKY
 gD36jNzlE8T0wHgmo3rGYBvhcXlKZpKAYmefT7YVYIkwTxVnX9T8CPwaz8w54/FpVmATMUw5fRPezIvkCCvIMNe+6dLQBEGY0UmhIffXg7ubApqhrcCo+3Vx+4PCuJc3bjzs7E4QM6jJVKEl/9QzR8R62w5hvAaelCKeutzs9Wum7THQa+eMIZxyqjRB/qc/WDLTW4mi304GfCK1gCHZzmMxLkUUeMXs85KQurJCFuu5iAUZiMTS9KKJbK2cg7H47KekrhIL4Q3RNPIPW/0bn+N/+XBb8arfLp94YRgoM9q1Tjn2RfRWyb7UhXz3U0noMlP6Vio4iT1SIS/byVH0pK26tiigjME6GBDLFWFwpy1kGPsNEFhni57C1qsnzOLY5wIcj7gp7qMcRYJIvu8AC1gAmiwd8dtjF1ni/3u/wbkU/r/E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To provide support for page table check on powerpc, we need to reinstate the
address parameter in several functions, including
page_table_check_{ptes,pmds,puds}_set().

In preparation for this, add the addr parameter to arm64's __set_ptes_anysz()
and change its callsites accordingly.

Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
---
v15: new patch
v16: rebase
---
 arch/arm64/include/asm/pgtable.h | 19 ++++++++-----------
 arch/arm64/mm/hugetlbpage.c      | 10 +++++-----
 2 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index abd2dee416b3..ed644be48d87 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -698,8 +698,8 @@ static inline pgprot_t pud_pgprot(pud_t pud)
 	return __pgprot(pud_val(pfn_pud(pfn, __pgprot(0))) ^ pud_val(pud));
 }
 
-static inline void __set_ptes_anysz(struct mm_struct *mm, pte_t *ptep,
-				    pte_t pte, unsigned int nr,
+static inline void __set_ptes_anysz(struct mm_struct *mm, unsigned long addr,
+				    pte_t *ptep, pte_t pte, unsigned int nr,
 				    unsigned long pgsize)
 {
 	unsigned long stride = pgsize >> PAGE_SHIFT;
@@ -734,26 +734,23 @@ static inline void __set_ptes_anysz(struct mm_struct *mm, pte_t *ptep,
 	__set_pte_complete(pte);
 }
 
-static inline void __set_ptes(struct mm_struct *mm,
-			      unsigned long __always_unused addr,
+static inline void __set_ptes(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep, pte_t pte, unsigned int nr)
 {
-	__set_ptes_anysz(mm, ptep, pte, nr, PAGE_SIZE);
+	__set_ptes_anysz(mm, addr, ptep, pte, nr, PAGE_SIZE);
 }
 
-static inline void __set_pmds(struct mm_struct *mm,
-			      unsigned long __always_unused addr,
+static inline void __set_pmds(struct mm_struct *mm, unsigned long addr,
 			      pmd_t *pmdp, pmd_t pmd, unsigned int nr)
 {
-	__set_ptes_anysz(mm, (pte_t *)pmdp, pmd_pte(pmd), nr, PMD_SIZE);
+	__set_ptes_anysz(mm, addr, (pte_t *)pmdp, pmd_pte(pmd), nr, PMD_SIZE);
 }
 #define set_pmd_at(mm, addr, pmdp, pmd) __set_pmds(mm, addr, pmdp, pmd, 1)
 
-static inline void __set_puds(struct mm_struct *mm,
-			      unsigned long __always_unused addr,
+static inline void __set_puds(struct mm_struct *mm, unsigned long addr,
 			      pud_t *pudp, pud_t pud, unsigned int nr)
 {
-	__set_ptes_anysz(mm, (pte_t *)pudp, pud_pte(pud), nr, PUD_SIZE);
+	__set_ptes_anysz(mm, addr, (pte_t *)pudp, pud_pte(pud), nr, PUD_SIZE);
 }
 #define set_pud_at(mm, addr, pudp, pud) __set_puds(mm, addr, pudp, pud, 1)
 
diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 1d90a7e75333..1003b5020752 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -225,8 +225,8 @@ void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
 	ncontig = num_contig_ptes(sz, &pgsize);
 
 	if (!pte_present(pte)) {
-		for (i = 0; i < ncontig; i++, ptep++)
-			__set_ptes_anysz(mm, ptep, pte, 1, pgsize);
+		for (i = 0; i < ncontig; i++, ptep++, addr += pgsize)
+			__set_ptes_anysz(mm, addr, ptep, pte, 1, pgsize);
 		return;
 	}
 
@@ -234,7 +234,7 @@ void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
 	if (pte_cont(pte) && pte_valid(__ptep_get(ptep)))
 		clear_flush(mm, addr, ptep, pgsize, ncontig);
 
-	__set_ptes_anysz(mm, ptep, pte, ncontig, pgsize);
+	__set_ptes_anysz(mm, addr, ptep, pte, ncontig, pgsize);
 }
 
 pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
@@ -449,7 +449,7 @@ int huge_ptep_set_access_flags(struct vm_area_struct *vma,
 	if (pte_young(orig_pte))
 		pte = pte_mkyoung(pte);
 
-	__set_ptes_anysz(mm, ptep, pte, ncontig, pgsize);
+	__set_ptes_anysz(mm, addr, ptep, pte, ncontig, pgsize);
 	return 1;
 }
 
@@ -473,7 +473,7 @@ void huge_ptep_set_wrprotect(struct mm_struct *mm,
 	pte = get_clear_contig_flush(mm, addr, ptep, pgsize, ncontig);
 	pte = pte_wrprotect(pte);
 
-	__set_ptes_anysz(mm, ptep, pte, ncontig, pgsize);
+	__set_ptes_anysz(mm, addr, ptep, pte, ncontig, pgsize);
 }
 
 pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
-- 
2.51.0


