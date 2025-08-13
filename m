Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D79C1C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 06:28:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76E8B900040; Wed, 13 Aug 2025 02:28:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71EC28E01B6; Wed, 13 Aug 2025 02:28:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E715900040; Wed, 13 Aug 2025 02:28:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 490C18E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:28:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0F76414027E
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:28:09 +0000 (UTC)
X-FDA: 83770754298.21.509FC75
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf05.hostedemail.com (Postfix) with ESMTP id AE75910000B
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:28:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=eupqUGza;
	spf=pass (imf05.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755066486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eiXaxF/2FesV3QwgvKJIyZZY1xNNOwJjwTbuT5306No=;
	b=Phxj2RE6PGJMCnw6WrIKEIy5i+VT44hVbtJiYwplHB67AeY3PTOeuMxvNrQIvatOydmPpp
	7DYPWBP4w7iCIP9N1VuHJ3VMxrife1F/NmXin8zcDZNIINAFIpGog6hS3ogZ2rz0UNEl6J
	VtRghOG8FfhK97nUjdX0tR7aMuiyzNM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=eupqUGza;
	spf=pass (imf05.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755066486; a=rsa-sha256;
	cv=none;
	b=vn6TiniozA+1rvXsrI/5h7QZZl5+DAdTapqC8VEIF5Hd7Re+xTg0o4ybMyS43yfCR/mgL7
	TTMQIrbT+ETghU6BzrQLdK/6t1RXj2eyGzZM2xjQ8Y6h2KiIWKa9rCmkajcVVuJykeQsKw
	mheJgaNur6b3VpbjPOM2JzyeFLUBwOU=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57CNQDmt015942;
	Wed, 13 Aug 2025 06:28:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=eiXaxF/2FesV3Qwgv
	KJIyZZY1xNNOwJjwTbuT5306No=; b=eupqUGzaOe0LROPmZ8pBHXZ1fPIeEjKKY
	vW5P/PnB8912HzOj1dGjiQC4Q7xtTlKhuerXQO7YQIiaOH/JbTpH2tR9amAbnoa8
	6ALA5NK4kzTRygXfsH1BCNLab6+i0RU/pAGDYfH8mS3O+oWlO4MkbkVnH9Z4p4ZM
	KhP48LlsZmLWQvQsKu3F0d1JGgJsP+aOUdQdauK79150p+pmj0vcIMG/yqiGDi/1
	UlTLORRgo7Iw8l7Z7c3bbhjEwM1DlOo2AEHjlDNxLBKvrpQ5uHg6Nq0hEBRv92Ln
	DzL5HX8zQQhGNFFVkKADiUW/zM8IVnvqT5WCucnMZEKXY67RCxueg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dx14jvny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 06:28:01 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57D2DcFW026275;
	Wed, 13 Aug 2025 06:28:00 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48eh2165ab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 06:28:00 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57D6Rw8k30605842
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 06:27:58 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8874C5805F;
	Wed, 13 Aug 2025 06:27:58 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A779F58059;
	Wed, 13 Aug 2025 06:27:52 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com.com (unknown [9.36.10.70])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Aug 2025 06:27:52 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pasha.tatashin@soleen.com, sweettea-kernel@dorminy.me,
        nicholas@linux.ibm.com, christophe.leroy@csgroup.eu,
        Rohan McLure <rmclure@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH v16 11/13] powerpc: mm: Implement *_user_accessible_page() for ptes
Date: Wed, 13 Aug 2025 16:26:12 +1000
Message-ID: <20250813062614.51759-12-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250813062614.51759-1-ajd@linux.ibm.com>
References: <20250813062614.51759-1-ajd@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vwi9nY3EkfENzDbblq-1gKe2rkFchBw5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIyNCBTYWx0ZWRfX43G1C/hRaikI
 C+ganIrle+xEXUSw66+k17xT19f5rdO2ycX73H2pCk7z78Q0MTK198EKCwGJkTFYPllgwdblZi4
 Q/cy+RgfCiUbLpaUvMTb7etE7dXtvMH0B8gVJ4ufp/xkHSz1RyiBnG1VVOPeXlxS+Gux9SCOec9
 OiM+vZPh98e5HIPAh8nn7b3QdFzoH+XAgVKwpA5M0iO3xKNBoU0ozoeCXIqZYcap3JAdV/0xxsi
 rjPNkIg31q0trK//SegfMUbC0s6T4j5Gce7ht0CMSfpwmGa3xw8rdJLFBL8jY/ErhgryUeSUNe0
 GktLbr5wfdXPgFCQ1AXoCTuWfJ70mwnjeIyt59aqlDVmI+ACqlXmoars9VPvEvjGSI6gYAmy9U2
 VtbjNmy9
X-Proofpoint-GUID: vwi9nY3EkfENzDbblq-1gKe2rkFchBw5
X-Authority-Analysis: v=2.4 cv=fLg53Yae c=1 sm=1 tr=0 ts=689c3071 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=7ipKWUHlAAAA:8 a=a65a1E2n8xkc5m_RgcEA:9
 a=gpc5p9EgBqZVLdJeV_V1:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_08,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508120224
X-Stat-Signature: haym857hc14z7wkh4ixzt1bt3s1sij3q
X-Rspam-User: 
X-Rspamd-Queue-Id: AE75910000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1755066486-420793
X-HE-Meta: U2FsdGVkX1/hLS9LzHdEpNS6heUZFgfxTFh5IKIzGzdcZ7obI9T8iUvnt/5yh6tFhhW03PM+r4SxP/B7rYxCy6Qq+TZha44grsLI+wUKZIGRwgCNrPpSyimek2LpEtkLGStytcM81WfY8xZ+mhDz/WUeinhsA0yO3PVPIrhsVXn+/lxDgCPDdy23CbWmfCmcolY7w05AQag2yhYMXTzxxEBsE/W+4gif6pBTa8nfgYMpeYotIFBuDeTFiZnZUiTi6tyDhUWuFq0uNBU4niLhCYDepr89AbuZnhEBrBANZhJ/RAggxPz7cbwTuVlPWYwn1TdrCtH/X0sfta7IIrWqB9v1B03M2UMMWXBLsQ2WEHnnXBlQpZhLP9udWsNQSWHH95Y5UiF0taGT3+w6Juk0MXhhSiA7IdxR3ooz06D7IG9969spEBGS++mr35nBOAutazX1c4eOvUYq+1g94+TrdCjcEcLdHwdaPGa7N0yR7epBOiwPLhqz6GxldrjFJAorMBuOsqvtYxi7CfnuUjZqu9x0mA+xR2mkFIcOU7AjrWbalrN5JJ2+LhhTbCk4SLikxUjPJmRWjCUA6BK9k8x8JXBL3Aw8A4WflkTPG9SB9i1TLCf9NSkfhLASQA2ecwrcmNTwdQAc2s0BWRo5Th8UxotykSBHnelQpXKEA1m2qmwB0M8AE9GeMrSb3QsYnHZCTApgmTTxkee1nEdDjJqtYDz6CVbZTimDncs375wBEzoJoF9ZFcWHLzYMesJSfDOfz1lV/E8DzpDsgtvGVm4WLFDX+nC4VEQx2+vviTDQn8VdEmS0cpyL+Wg5qJU+5vW3LFcn6sQM5JA8S9hP4ajhQlc99RybBWl/CRgwB+e/ReyQzsqaU72mao1WiS4X5zBDCxh6aaw/RUQN5iR7VPfmJpe1ALba2noPHpajsAimqtzV551a7hti44O+e5gJwap+1Gr6Kh6/k6gTGrCcUAs
 NRj+mZu/
 rtDzDeLhZ5sx07ZX/rd7WhIXmj7bbN+r0ZS2W1sjVFAnzDShsX0YBN4jndXlJ67P1HabFw5lZXCSbXTwUF848A2ZxarUy0ZYJ8GKUxTHbMHL39bu+EgXpAD/yuWviVphtFsruJEf7LoXD1ANrYtmd/SIJszPFfE6vmVxV5CF6oIdSIws2xeCx0o6i7S0HDenpvRyxpY0Qd+XLi7Xv+gFJ428yQQB7LF8h+MwwwO/BN6r5to14+07k2oCPWq6ZnheA+r/MpuGQB+rZHery6bfO5rXRfvHQAb8noAOVqFQMBNEK2lQpHaNJqR/a4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rohan McLure <rmclure@linux.ibm.com>

Page table checking depends on architectures providing an
implementation of p{te,md,ud}_user_accessible_page. With
refactorisations made on powerpc/mm, the pte_access_permitted() and
similar methods verify whether a userland page is accessible with the
required permissions.

Since page table checking is the only user of
p{te,md,ud}_user_accessible_page(), implement these for all platforms,
using some of the same preliminary checks taken by pte_access_permitted()
on that platform.

Since commit 8e9bd41e4ce1 ("powerpc/nohash: Replace pte_user() by pte_read()")
pte_user() is no longer required to be present on all platforms as it
may be equivalent to or implied by pte_read(). Hence implementations of
pte_user_accessible_page() are specialised.

[ajd@linux.ibm.com: rebase and fix commit message]
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Acked-by: Madhavan Srinivasan <maddy@linux.ibm.com>
---
 arch/powerpc/include/asm/book3s/32/pgtable.h |  5 +++++
 arch/powerpc/include/asm/book3s/64/pgtable.h | 17 +++++++++++++++++
 arch/powerpc/include/asm/nohash/pgtable.h    |  5 +++++
 arch/powerpc/include/asm/pgtable.h           |  8 ++++++++
 4 files changed, 35 insertions(+)

diff --git a/arch/powerpc/include/asm/book3s/32/pgtable.h b/arch/powerpc/include/asm/book3s/32/pgtable.h
index 92d21c6faf1e..b225967f85ea 100644
--- a/arch/powerpc/include/asm/book3s/32/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/32/pgtable.h
@@ -437,6 +437,11 @@ static inline bool pte_access_permitted(pte_t pte, bool write)
 	return true;
 }
 
+static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
+{
+	return pte_present(pte) && !is_kernel_addr(addr);
+}
+
 /* Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
  *
diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index c19800365315..48f3a41317dd 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -539,6 +539,11 @@ static inline bool pte_access_permitted(pte_t pte, bool write)
 	return arch_pte_access_permitted(pte_val(pte), write, 0);
 }
 
+static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
+{
+	return pte_present(pte) && pte_user(pte);
+}
+
 /*
  * Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
@@ -1381,5 +1386,17 @@ static inline bool is_pte_rw_upgrade(unsigned long old_val, unsigned long new_va
 	return false;
 }
 
+#define pmd_user_accessible_page pmd_user_accessible_page
+static inline bool pmd_user_accessible_page(pmd_t pmd, unsigned long addr)
+{
+	return pmd_leaf(pmd) && pte_user_accessible_page(pmd_pte(pmd), addr);
+}
+
+#define pud_user_accessible_page pud_user_accessible_page
+static inline bool pud_user_accessible_page(pud_t pud, unsigned long addr)
+{
+	return pud_leaf(pud) && pte_user_accessible_page(pud_pte(pud), addr);
+}
+
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_POWERPC_BOOK3S_64_PGTABLE_H_ */
diff --git a/arch/powerpc/include/asm/nohash/pgtable.h b/arch/powerpc/include/asm/nohash/pgtable.h
index 7d6b9e5b286e..a8bc4f24beb1 100644
--- a/arch/powerpc/include/asm/nohash/pgtable.h
+++ b/arch/powerpc/include/asm/nohash/pgtable.h
@@ -243,6 +243,11 @@ static inline bool pte_access_permitted(pte_t pte, bool write)
 	return true;
 }
 
+static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
+{
+	return pte_present(pte) && !is_kernel_addr(addr);
+}
+
 /* Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
  *
diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
index 0f73a9ade0ed..d0938e9c33fb 100644
--- a/arch/powerpc/include/asm/pgtable.h
+++ b/arch/powerpc/include/asm/pgtable.h
@@ -223,6 +223,14 @@ static inline int pud_pfn(pud_t pud)
 }
 #endif
 
+#ifndef pmd_user_accessible_page
+#define pmd_user_accessible_page(pmd, addr)	false
+#endif
+
+#ifndef pud_user_accessible_page
+#define pud_user_accessible_page(pud, addr)	false
+#endif
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_POWERPC_PGTABLE_H */
-- 
2.50.1


