Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBC72D6E2BD
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 17:11:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F6906B00A4; Thu, 18 Dec 2025 12:11:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D52D6B00A5; Thu, 18 Dec 2025 12:11:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E0F26B00A6; Thu, 18 Dec 2025 12:11:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1CCC66B00A4
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:11:19 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BFC9AB63B3
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:11:18 +0000 (UTC)
X-FDA: 84233232636.05.B1CA2F9
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5825720010
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:11:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=BAtA8hst;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf13.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766077876; a=rsa-sha256;
	cv=none;
	b=abFCS23eycW+Jv3GgTgRi0wrfQr4CaemSj+ESHlggL9CrHFKX1HbPE1nvluJ+CT8B9CC1N
	i00Eq/KGrhcaRrkKfAVk784Et3Ur8HGsHHA1V4x7tZbfGRDMErU3uqsn0h9YjxLflMv159
	WJVOE3SjTxSssfmvZflrNo+C03IK9Hs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=BAtA8hst;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf13.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766077876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWoSo1eEUGDSVrfx/RVD+AA0KOYlwKtsf+dOKVvgUjY=;
	b=K7+Cm2vuwjsFRlX2XULO/RCkVbvLoU383X9+8Jur8MUPEBrxpvn2Uo3gpXcIsdtWbwY4cC
	Jgrnk3rvJNuop6/pj8NkKV5TRNCbwaOj0dNjqTUGWYtAl2zKD8wh49HFpdPilHRVuzNlkZ
	SGrxtXPRKvMg+L5hmp9aZd4JAjrCf88=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIEZNPe030256;
	Thu, 18 Dec 2025 17:11:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=HWoSo1
	eEUGDSVrfx/RVD+AA0KOYlwKtsf+dOKVvgUjY=; b=BAtA8hstEV+vhLnEeZtm5C
	cumh0zYIFPPX7q5JRUaMApFmWtgmFYYcX37tzM49kwJrJMHj6bRR1y9uHY04FEdp
	dimAvAoUeUTmYR0xWGsy0keXd0aF6VhRcJH/HxwGl7LeJWh7CIg7nefLAb4CyMHH
	3XfUcBBsIlV0FzXMIKgfvZWW++0Oz5j+oNlJyzWYFVyzLHuYCn9rwKZixcIPfdDc
	FaDbS8X7TrmdKRmXQ6xmGKiyOwgQYjRGxyuzIrwgJKovKc0uPTEiQZIK65Uy7Qin
	YPjMqwSwHUW6f741g/VJkj/BfsU01NoWc1cjiQqpULUr0VEd7qvhGlU8gg9iWH2A
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0yt1tvae-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:11:08 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5BIGsabe010964;
	Thu, 18 Dec 2025 17:11:08 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0yt1tvac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:11:08 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIGexh5012806;
	Thu, 18 Dec 2025 17:11:07 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4b1juyhqxc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:11:07 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BIHB56W12976720
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 17:11:06 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D9CE458056;
	Thu, 18 Dec 2025 17:11:05 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CA9305803F;
	Thu, 18 Dec 2025 17:10:58 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (unknown [9.36.16.51])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Dec 2025 17:10:58 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
Date: Fri, 19 Dec 2025 04:09:42 +1100
Subject: [PATCH v18 10/12] powerpc/mm: Implement *_user_accessible_page()
 for ptes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251219-pgtable_check_v18rebase-v18-10-755bc151a50b@linux.ibm.com>
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
X-Proofpoint-GUID: DI82VlKJCDmN1Pd4VpqGnuQlvP3qGltY
X-Proofpoint-ORIG-GUID: r_gWxBg_IDqgKdohby3DDkIG-C4KF7Pp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEzMDAyMyBTYWx0ZWRfX0L6BzOFOvPkV
 pUcjgPm04/hQlmp9r+tqBO7ugQwhcatqTUtFl+aTeQdk3yNfO+6sxXLmigbUlp0rr+C1ZT06/fU
 PltWgHhDAbjNOShp126JpSRadKmjQIexb61YQS30wrzuKuVRIrDTZLqS7UP1ypk6eFeeyBbDMRB
 JDgQXwMQUFmG4j/B37ub+goon3C4nTBCK6n6hDqzSVk9/STEktNfCJ9kCuRPYuIRp7Wi6jhlr8e
 iclP0EU0IIkMijaM00RNgsNdjmejnG2MTV8idNS4Aw1cpe6YAdFvE2VFYBc8I4YwnQdu1oAqTeA
 6GYMRKQydRMpm/87juq75wjE5caTrypRHd2oMs4jh2UhoXG2RRGiVtoK+Ha/7gazu6RckexubBj
 sWMNW6VXdcbAucslSkKz6fwgD5xyUA==
X-Authority-Analysis: v=2.4 cv=L/MQguT8 c=1 sm=1 tr=0 ts=694435ac cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=7ipKWUHlAAAA:8 a=wHxssy8_SbW45gVFdfIA:9 a=QEXdDO2ut3YA:10
 a=gpc5p9EgBqZVLdJeV_V1:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-18_02,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2512130023
X-Rspamd-Queue-Id: 5825720010
X-Stat-Signature: fso4xtbmxxdhysjs4b87c4gfw4867ta3
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766077876-159109
X-HE-Meta: U2FsdGVkX1+dEWDh945s91c6ZeweDT1wB4rW4a5+77dxg4wWR4befx9LiaFxMaOjjatAylyQrhSriByGrSE/kBZdUFcod4occOVaVipBHGsgFP5bYilueNuddFjh+7eZY9W7Lw/XviUDZQ6x0Hv6RDrvCStWLm5st5vJAuYUDFH9vHV8TLLqQz5YvNdQHvrffJ/0+J69xLITQqswn23plIf8RravzhiESLNSf6X6JuIODve3H3BLphkNM/jMZJOzQ+5LoMIoM6+baOesobVJT20sZ2D0+jOwulZ6fb6A293qDIEuJvdCnVKyrjQyNk0s3IdgLzeq4d+E/605u8ZQmXm3xlgpu/6SRQelZNUw0nemuuZTq2wNRNb7qKrpgiDtNhwPnnfvls62i7SDDQq7im9A4xHKUURpBDGY0FNNLkARQ6ZgTZsrE+dVbfN3noKtiMwqLt8O3bjREvBU2mOs7VKcLcbXRR3ItTipoqqQaywWxXHK7EN4qJ0Tr/xeqj5KD/wjP8cCqZNT+uRrzeux//h3vh0j9iHNoqTWqvWsPX5wyL/rNeeMgSbbvT4/Ztu9l6oqrwZboypA7R8MmliWGsRm9ILuGg67AHqaIM9w6X/NhmoJ2roNw4X8e4MG0olWl7KQQV0HFtwFQ1CldOOCG8Hs5RpeJ7lgRc8a6XrxzT0auCp/PHHUUzzXv4eie71ExsiAXHpJaANu4XznL5kYSwNz+KcdIR9mQHBKVQ2EkGUEPx8bnQGeZI/YeH+4baH4cZZDbwm8q+z/WZYIF35YJN0a+gG8Cc9oqAUEUe06Cg/xDn2tSNBz2+3iLlPEYx94CSwnPtcunQ1CL+Y/t3HWiTnfjUbBhV9hNqOyCHBJWQlWZgNhhlKxjPoh0o+lXqY6Eh4qEhN8MxmHQ69NDfH/o9K9h3bJ9RsHe/kqwOWAf+Vhhv9weNJFnWoAfvncl4oC8aDnQsUqAP7Jip0EuN3
 dduVfVVz
 wbUOisgs2CyVdW/7cuQ6MkwOjTVhfDOORfijpUpzjvFcxeiC5M2XHo5+yjnKm2zPe5ilkfweGldVwHzHOvimYi6+q5e1xLE0wE2sBYHqaZN3s10IhU3JOlpMkw7OQQuyzdwqyCB3byv3NU0xDxW5yG+5Kq/tqx8bLlSDCrGcB9vyAYzMGGksZ0hedLBAlxxidkqVXdaPrFqJ8RxXspEnAOZP1kD1vPaBs284ZZnB6n4AXxvvinlAW1RlLQeN+yQmAwQva4xaR9gXPpTFFfI+kYfU88AXrPupEWmlnCPsCz/IEso+r1eHm6ZW7FzNixiZRAGGTAZTtuV0D68+0IzrR2MAuxlsc/HrznWKJT+2lXUKU/Ds=
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

[ajd@linux.ibm.com: rebase and clean up]
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Acked-by: Madhavan Srinivasan <maddy@linux.ibm.com>
---
v18: move the definitions of p{m,u}d_user_accessible_page() to be next to
     p{m,u}d_access_permitted()
---
 arch/powerpc/include/asm/book3s/32/pgtable.h |  5 +++++
 arch/powerpc/include/asm/book3s/64/pgtable.h | 17 +++++++++++++++++
 arch/powerpc/include/asm/nohash/pgtable.h    |  5 +++++
 arch/powerpc/include/asm/pgtable.h           |  8 ++++++++
 4 files changed, 35 insertions(+)

diff --git a/arch/powerpc/include/asm/book3s/32/pgtable.h b/arch/powerpc/include/asm/book3s/32/pgtable.h
index 87dcca962be7864be3da1e7aad0992d2bc4581cf..2edca1068b6f31e64ddc4f39f594bb3ac27a8435 100644
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
index aac8ce30cd3b39ae184a69879a57ce8d6698fff5..2d69a827594f3c8593283fa11acd4750577e71a7 100644
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
@@ -909,6 +914,12 @@ static inline bool pud_access_permitted(pud_t pud, bool write)
 	return pte_access_permitted(pud_pte(pud), write);
 }
 
+#define pud_user_accessible_page pud_user_accessible_page
+static inline bool pud_user_accessible_page(pud_t pud, unsigned long addr)
+{
+	return pud_leaf(pud) && pte_user_accessible_page(pud_pte(pud), addr);
+}
+
 #define __p4d_raw(x)	((p4d_t) { __pgd_raw(x) })
 static inline __be64 p4d_raw(p4d_t x)
 {
@@ -1074,6 +1085,12 @@ static inline bool pmd_access_permitted(pmd_t pmd, bool write)
 	return pte_access_permitted(pmd_pte(pmd), write);
 }
 
+#define pmd_user_accessible_page pmd_user_accessible_page
+static inline bool pmd_user_accessible_page(pmd_t pmd, unsigned long addr)
+{
+	return pmd_leaf(pmd) && pte_user_accessible_page(pmd_pte(pmd), addr);
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern pmd_t pfn_pmd(unsigned long pfn, pgprot_t pgprot);
 extern pud_t pfn_pud(unsigned long pfn, pgprot_t pgprot);
diff --git a/arch/powerpc/include/asm/nohash/pgtable.h b/arch/powerpc/include/asm/nohash/pgtable.h
index 5af168b7f292415c5896a5c63bd78641d9a2c2a6..9bf3e40f27b645da660cbeeb561f08eeef180b1b 100644
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
index 17fd7ff6e535b6d2b320fc8c292b7eb964fa0ef2..859cdbaa54a7fa159d5bbd4653f7871381f4910f 100644
--- a/arch/powerpc/include/asm/pgtable.h
+++ b/arch/powerpc/include/asm/pgtable.h
@@ -202,6 +202,14 @@ static inline bool arch_supports_memmap_on_memory(unsigned long vmemmap_size)
 
 #endif /* CONFIG_PPC64 */
 
+#ifndef pmd_user_accessible_page
+#define pmd_user_accessible_page(pmd, addr)	false
+#endif
+
+#ifndef pud_user_accessible_page
+#define pud_user_accessible_page(pud, addr)	false
+#endif
+
 #endif /* __ASSEMBLER__ */
 
 #endif /* _ASM_POWERPC_PGTABLE_H */

-- 
2.52.0


