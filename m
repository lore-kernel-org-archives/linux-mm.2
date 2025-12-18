Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0C8ED6E2BD
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 17:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BA906B00A5; Thu, 18 Dec 2025 12:11:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18F916B00A7; Thu, 18 Dec 2025 12:11:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09AC66B00A8; Thu, 18 Dec 2025 12:11:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E874B6B00A5
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:11:23 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A4E2357EF8
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:11:23 +0000 (UTC)
X-FDA: 84233232846.29.2DAC8ED
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7C75B20003
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:11:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Hqxvb+yw;
	spf=pass (imf03.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766077881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GfwtXDCEJm8cvlfmVNc4fL2Fitd4EzM+yfjeybY/948=;
	b=C0bPXQoKQOlfj8yiWM0ffjUYYkMGMJOp2Yo5dWs13cym9ZDpONA7STkdPVHzv4dUbTpIVx
	N8P3Nh5CPXUplVoSdCznFVifleA4HD3G5qeae88zEvjLzORK2YvNf3lhw+m3P/BJZjLPU7
	i4tgEVd+HTrhYKeBT/BSpG5WcEUi9Kg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766077881; a=rsa-sha256;
	cv=none;
	b=cTRjfRIPGumlnjx0GyI+zwcbIkIacs5XPw8KhMUr2fxyoiAos+fX4JoBlK/3hM9q0b33t7
	vopNj5MzDR+LSCAUeiwUeivgbDHn5kgbYLI1sU+UVbNWqui2GMvcow9OTB2ZVrO4gkzJY3
	SDHb0fsXIPBNGCmiBZTr37V3yb48AuE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Hqxvb+yw;
	spf=pass (imf03.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIEfoMV009416;
	Thu, 18 Dec 2025 17:11:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=GfwtXD
	CEJm8cvlfmVNc4fL2Fitd4EzM+yfjeybY/948=; b=Hqxvb+ywV2tHBHPTgWmxns
	7l7FKid2EdtRutwHNyA29MPIVztScKFqZjj5qEf3DqQGXUEyi4TU5QUBSFXJTTHt
	kn5DG7WM+Hvcw77d/nUK1wKGkVB0sBhENxZrpbexsjtecKUE95uS7br3vgxQFpcf
	8w80kj0Hpi4NedOcbE2nYYPlDxQLMuEpsY/KS1Gkzp41a5MIktup2V+/wV8bk1wI
	ZXz4hbIagEs6JcY19sy2czPiuDLWopTXFaCc933tjcPRPtm9IApibXScID6k+mPl
	q+ljiZ8VCNCpHqN9Yixnhmlbi2yR5sQLVfPbGo8eIjvVb/7gUqiAAUw1/kxvja0w
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0wjqb7t1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:11:16 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5BIH2cRD017879;
	Thu, 18 Dec 2025 17:11:15 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0wjqb7sv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:11:15 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIGsMSa026753;
	Thu, 18 Dec 2025 17:11:14 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4b1jfssujg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:11:14 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BIHBDnl28967584
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 17:11:13 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 89E0258060;
	Thu, 18 Dec 2025 17:11:13 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9430B5803F;
	Thu, 18 Dec 2025 17:11:06 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (unknown [9.36.16.51])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Dec 2025 17:11:06 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
Date: Fri, 19 Dec 2025 04:09:43 +1100
Subject: [PATCH v18 11/12] powerpc/mm: Use set_pte_at_unchecked() for
 internal usages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251219-pgtable_check_v18rebase-v18-11-755bc151a50b@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEzMDAwMSBTYWx0ZWRfX7WA0zvymjrXP
 kkkyNkQMoOITPYFqQzNf60nZNHi4DxVM7xSOerwoMAigbQZT4WjTiW+xvpneVNoGDuIc8Xl9M8j
 oWblLRTwY/680juxgDDBwgKXlAsmhQMhp2TsZ1mRDNPjv9lu/Np4JRJBlx0Km2Z42lU4JWeb0wN
 kGGxJ7rhaOrgyvwzOldDPQonSKQyN6Nu9FyQMqy6l/4CcD3eV+9ZC4PjuNE679817B5xxby+FPl
 +btBqejvw25KSUPRempzqQMS7Ke8kvgTw8Ga2n0SRqxhbeqUriHqxI3sm7dtVIinUIV+S1Senzz
 KVuEIEdnZcVU4vKCHb72yrWxIEAiJzPRacLj0YTmjl4xEtqMXSYvK9TKfA5BuzD2zU2cJl7xSgE
 hQ/rEOJRhOatlgsrjrzgevjkC3Y2Lg==
X-Proofpoint-GUID: FjpAoXxzFXTmJRHeXfVAqFZig_vzMo_E
X-Proofpoint-ORIG-GUID: jusM1y8-Ly8Qd_yXg4Kunas8nxO5gDlO
X-Authority-Analysis: v=2.4 cv=Kq5AGGWN c=1 sm=1 tr=0 ts=694435b4 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=aAuIek1P640J7jK5_TAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-18_02,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 impostorscore=0 clxscore=1015 spamscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 phishscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2512130001
X-Stat-Signature: pdyqie9659467duswffonfpkypcsw6pk
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7C75B20003
X-Rspam-User: 
X-HE-Tag: 1766077881-291988
X-HE-Meta: U2FsdGVkX19F7pwKD3IEQ9WzktX3PXfsGjShATJ+s/+7aaASx3WEJi+VjY1R5vLP08MX88583FQGL4+V4Q/CMfm/EbC8QhE8cf/ka8Tzyat6WM+bJFQUZHFGGNX4TWPsGLdiIS988SBiDOle0NqgBbXXLNekho+wRsj0JevT7tMj+kOowNoQjcMPCyaNz+fiOy8dOPT4j5yK4cCcRzQniaRW2EV1mmB69Ihml5DFkCceEtXAfPgz4TQelr6mFRR0LEUtYg3/nF1xXeBdcrraWYqkHmZIs59eh6x/UWocgvJ7oLYreFJhNVrER6+Z2BexAu6djWomoENhJyMObssphpClZ6FHON3eYU1TOOWQum/C0xNTIOz3xfTsLDCTnfdb/mA3A6C++b3MbtiXXvxoMG0kmyB0F4iM5EGCDYQ2w6NuJeDd3SiyYHsPg8iBicnPWhuaXS1YRTdVwtSfS6UBV39nYYG7jgQZTyjqCAUB+8B6TlV8fSm3EyXkLpcnFGUjjM8KT1xvnkcg7piiGnWjWmlFiI3asRhvimvsBh/CfruMINpChgWjTLwosw9W/sFNpCMlUyNYC+gpCbHqZgrqP7r8tEJmx8eBv9SXPoPaDNEvOBHxtHa55ezUwEP5VGjPq5PoSSQEy/keAhTTo2fh3xdr8y3Tnt8E4smQp/XnBc7uHLMS2AwDDuxYVF42AmixviwLDvt/79A32dafLrb6TWTsHA/WM87WlL417HhDCN+ZGr5D1VdsqrRPJyDlFeo0thcE91DC9Mc13JE+z+bu/PGaG5DZvSgVYPdQfOVjtpYGwU0MrMU74rSoOmJK7EjGCQRucd6w/kYanTvenihVtrP/l1/EtusJNGE5ZaQ4/rhf2oSJ1kSJEK6Bvmt0oW/CvilujhEfQQCl5eJct4Nqr7obPoiMxRxECvrnYtJe482m6iqtA3AdMZ0TDnLfx3gqJRcWhwDay9khJw7lRS2
 ZUXTzmAM
 zO9A/OwW3Kb92a/7PTA0VFRnaywrmA0pzAiURdnZzKryKINBCBxGhEZwRkgPpj07Y/GK7FSgzsizgSpQ=
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
index 859cdbaa54a7fa159d5bbd4653f7871381f4910f..dcd3a88caaf634fef26fa57f5b8852274e0d4cb5 100644
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
index e3485db7de027cc6a20ffb5a80dbdc53261ebb3e..97db2f42ea3d3bd476d0ef03da47ff325eb73db9 100644
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
@@ -550,7 +550,7 @@ void ptep_modify_prot_commit(struct vm_area_struct *vma, unsigned long addr,
 	if (radix_enabled())
 		return radix__ptep_modify_prot_commit(vma, addr,
 						      ptep, old_pte, pte);
-	set_pte_at(vma->vm_mm, addr, ptep, pte);
+	set_pte_at_unchecked(vma->vm_mm, addr, ptep, pte);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 73977dbabcf2615252f82a09b97f719b7fe68164..b2541bf33d01cbb59562866d844354b39b14a86c 100644
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
index 56d7e8960e77d877390d6bcbf0d8a305cc222101..7b69cd16e011c31fffac2439a76ba20e00fc9a78 100644
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
2.52.0


