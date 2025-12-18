Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40169D6E2B1
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 17:10:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4C746B008A; Thu, 18 Dec 2025 12:10:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3E576B0092; Thu, 18 Dec 2025 12:10:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90C8D6B008C; Thu, 18 Dec 2025 12:10:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7CD176B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:10:16 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 42875C0261
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:10:16 +0000 (UTC)
X-FDA: 84233230032.20.F952DEF
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf25.hostedemail.com (Postfix) with ESMTP id C1A90A0019
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:10:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=CVUP9NfG;
	spf=pass (imf25.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766077813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BQM9eZmp7IOxvBSs1szeSSpdJ2Vg/5tNkjU9dvqhlbU=;
	b=eRBd52ks3r5d/SNVFAQFAcWdzNgoV22AwAAjAz+XmIQvMIWDrOxly37DcYmevEUHrTe/jK
	w+TtxbUaMj0nIEEiVwv5t4Fo5o6bStZGv5APRBWE2uA03i6eWdcEo2hI3fSzRHZjy3kdw1
	ZTTjycOcLE6lMgux3uumY+gMPOcRNcc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766077813; a=rsa-sha256;
	cv=none;
	b=EFGFQQj89FkXRff/IKu2fPdubo2A4+FMNr9iYe33C8XyXx5V/sgFBxVs59Ull3D0DCqGxI
	bdvERwKvQXmT9pNpIA4VvrI+23MHjGRV8jQd/bnM9+LKvlMoU9Sy2AhUqHh18jRmx9mPP2
	2UBUiiX9QLW1LJgJCgItmzXQU8DAVMs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=CVUP9NfG;
	spf=pass (imf25.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIG1Blq011837;
	Thu, 18 Dec 2025 17:10:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=BQM9eZ
	mp7IOxvBSs1szeSSpdJ2Vg/5tNkjU9dvqhlbU=; b=CVUP9NfGyQOifJoW1MrSga
	wxeGEEL00PnIRzieFhzjaVVGu8/Y+VIGn5hERPVJbaXGcZRgPmhaF9U8o1dkd0uk
	9lz/AqPcwFePum0xEhNSRDX8vY0t9cNrJHZSI5dinzWIzSU78SIEBjqrggtNK5Hm
	i922L0kHdG+na3x525yjGEi+G+W7j29q6OpXrqg0dxlkhfV2wycG5cEhPfiK0rDQ
	M5PBQCdR9MB582D/JTpYayt3GCABHiSjhrYrFDv7aVBWSdukwl7iYxLjdYkU/0aC
	4dX1kFLCi6igIpjc5DVIHskQ633+wvP6gfBQGCMVGQnJSheYN8cQLKrSurcY6muw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0yt1tv59-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:10:02 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5BIH4oJU001320;
	Thu, 18 Dec 2025 17:10:01 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0yt1tv57-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:10:01 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIGNwHL026746;
	Thu, 18 Dec 2025 17:10:00 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4b1jfssubx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:10:00 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BIH9wMT19989202
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 17:09:58 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7D0615803F;
	Thu, 18 Dec 2025 17:09:58 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CE4DE58056;
	Thu, 18 Dec 2025 17:09:51 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (unknown [9.36.16.51])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Dec 2025 17:09:51 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
Date: Fri, 19 Dec 2025 04:09:33 +1100
Subject: [PATCH v18 01/12] arm64/mm: Add addr parameter to
 __set_ptes_anysz()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251219-pgtable_check_v18rebase-v18-1-755bc151a50b@linux.ibm.com>
References: <20251219-pgtable_check_v18rebase-v18-0-755bc151a50b@linux.ibm.com>
In-Reply-To: <20251219-pgtable_check_v18rebase-v18-0-755bc151a50b@linux.ibm.com>
To: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>, Rohan McLure <rmclure@nvidia.com>,
        Christophe Leroy <chleroy@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, x86@kernel.org,
        Nicholas Miehlbradt <nicholas@linux.ibm.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Andrew Donnellan <andrew+kernel@donnellan.id.au>,
        Srish Srinivasan <ssrish@linux.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org
X-Mailer: b4 0.14.2
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FBTOwGWFchBwemRmIEWG1lzy85XJ1ZSC
X-Proofpoint-ORIG-GUID: 4g7xWkc1F-jljt0yG9QNKRSDr-vmSUiU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEzMDAyMyBTYWx0ZWRfXxyUOycSYTLr9
 NysdLQr0iQcE5kZ6Ln+z/B4rTmpaL5sZHHlqRLDeE6fv+zhQwXsaf+OdkQZ2BdtvWwbkASbyJCS
 Nkg8+MMVGKgrTB/oytBPA0AeEkemqHz6wKUEPq9OabG2RPiX30zhLIijJkYQG2KXCWgRY4xIey+
 6QePF4ZE9nM6a4exRmf/340ACx+fWnawUwT/ECBFiJ8NLuiXWyvitMSUaEIvxwomkt+1ghnzKLL
 AEUiukrjMuOWJ1vBvInjOKF+p7BATYuVqLKVgsEmUNsnp08mR17v0Rw3KvWYyRBastGzE3obg0d
 g2CcRzMZm5AhkoNQnXR8yWeuh9pKDGwm8pjkg613GyLtVL+uQTd+CjLrpzzdxhEnjS4Tdwh4oH/
 OYVS/edQo5KqmdMGS+Wlmz9inS/mMg==
X-Authority-Analysis: v=2.4 cv=L/MQguT8 c=1 sm=1 tr=0 ts=6944356a cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=iO9NmEFvf90wNdx_zysA:9 a=0bXxn9q0MV6snEgNplNhOjQmxlI=:19
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-18_02,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 clxscore=1011 lowpriorityscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2512130023
X-Stat-Signature: c7cj8ckn6t1ye5ix1jehatte6mbntxkj
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C1A90A0019
X-Rspam-User: 
X-HE-Tag: 1766077813-464382
X-HE-Meta: U2FsdGVkX1+/Rw1mAkA9bMLfkgezOPg42SqfzQRM6o1N2RJFYOsGi5GtSBWDdgVNRTi0KzNcKV8D37PMFKKmTm1pwLzs4t//OLzR9YFnqHXi3o3G5l3TE81jPB3tV3McSyE92NtOa6Q34dKFe3n9F9y3jvDRYzyBaA+Ic0L2mtCheMiKKPoNo+9GggKNErAN0Ppe/Y+ExoaOUN8b2N4+FCuugxUilRWzsq8ld6IzJiJBj1AUmZkFdgGH2t60xZankxdCGcpYxNeKKImAf5x+yjWO9V6rTy/L2/Am7m84h9/C3wewLGZqPs/6rWa89Az0LrdN1IfTAniQ1c626Rc4WU/ZQxw6gixd/IytHaiPK0MrJd57Yr/b/oM3oXTZc9+DMlDW/5tnpWqosNKoiB0rZlzDkLB8rUnKbFUpkovcPD4cwJWu3z9t8ag6EBj+iH2IjQnK4/RBWgJNAKHW1VwHnGUksqmqB3MEmjNYEDkuIqLxKeBZTPAGlScVtrvQRwlP8mAK7y1LZzWg/uoViMzQ0OCY2K2l8DxSS9cAgk/5mUCKdEHgNg6Y/HMSrHh9nQEmr6Aod8YxKMzIsfm6FEo7Av0B0M+dqSrp+x8P9vFfSO8H4fsUJiJ5YAiZqNqIdHmRf7+Quas2evcB3eSYYptteGhw1kzTqGYExsxEYutF5I4hnLSusNt+JaujPe7ENU73caLsNFfs4ha2DLSe0g9ZOKA8F1Y0L6hMDniHqA/eoxMrSpFFNF9RV5UdxPnmdHus1OPYscEgRLYfHmhcL4YIKMRiEQ3UVRP03Wb+YdCc3r5bKQGNUuzO3YI6T/29SV9UMxDJb+nNkbcyXOiLF6DWgMqv5H8CmH+O/sAMytelJALHjSV3OxofOhioDga29yVdJl28f+XDjGrcYTd5UHvvp/lcWzYDCbxvLdT/OU3ZA/2ReGgiU+qQDIUP1pxzLedbklqOM7ewRICPlOaIvpa
 xVqaAS8A
 syJYAZ5XGKqY9psY1XtNNeZJkE3OZ18AwZsXZHnmy/cOg6bcK4tT2CSxgQu423h0fFlvaJJ5JGu4H7gouizXBshJRzuQodqBT74k+6jqRWyVd+MJmIbv98R6YivV+nbj0d8mR7cbzih0lenKu01h/x4l5C0L/f5vfGILUWnerJG/AjhC+GRDlaZCe2yY7tO7T17C6Jfno502wmZX6t3JixCcFqWO7myNRw83YtSc/f0SXx2i8YQWaxJqHYYrRQwWNXTVh1tGd+Haw2BeEX0+1bTPmZW4iTEdRcPgaDjB8jNptPUI9Aa0+XRqiTXQISBOminJQy6rLGapM4FqeIfpS/ry27Ja5IKCj4s9j/0PzS21iNAYO9/UbTkEjjr2F2JaUT85aFHUplXv1D5tOcxFh7ZWY1ABhr49E199D4QQKxwMuAJ/kmCVqtiv15MnmESEJVD8Yv82bgfHP2Kc6qp5ELQ+YBWMJMPe4NdFK
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
index 445e18e92221c98eef717888aeac71d1d6b1da06..52f3ea07427cef399e68bea0dbab39d03ea83060 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -673,8 +673,8 @@ static inline pgprot_t pud_pgprot(pud_t pud)
 	return __pgprot(pud_val(pfn_pud(pfn, __pgprot(0))) ^ pud_val(pud));
 }
 
-static inline void __set_ptes_anysz(struct mm_struct *mm, pte_t *ptep,
-				    pte_t pte, unsigned int nr,
+static inline void __set_ptes_anysz(struct mm_struct *mm, unsigned long addr,
+				    pte_t *ptep, pte_t pte, unsigned int nr,
 				    unsigned long pgsize)
 {
 	unsigned long stride = pgsize >> PAGE_SHIFT;
@@ -709,26 +709,23 @@ static inline void __set_ptes_anysz(struct mm_struct *mm, pte_t *ptep,
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
index 1d90a7e753336d86314fee0f753e8779d6a6bc12..1003b502075208d4252c27ffdacb1aaf4928639b 100644
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
2.52.0


