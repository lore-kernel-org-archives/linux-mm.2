Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6715CAC58D
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:15:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 764818E001D; Tue,  9 Sep 2025 05:15:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ED326B00B3; Tue,  9 Sep 2025 05:15:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 567E38E001D; Tue,  9 Sep 2025 05:15:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 310896B0007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:15:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F1B7313AFB3
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:15:24 +0000 (UTC)
X-FDA: 83869153368.06.5D9F8AD
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf02.hostedemail.com (Postfix) with ESMTP id C0E3880008
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:15:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=SBJsXly+;
	spf=pass (imf02.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757409322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dmxWxoN1Q18ZYHji6RqAjuCQGOl4Ppungs5wn/Igdb0=;
	b=qCMO08TW9WzJGFoPHC0G/340f2dpmhSEWWlx16FP5k20/xMzFZroawMzuxzUCQvo9gWaK/
	widUI7OBaBV6cgecmzLJVMCgQB42LRJgYYIBkHAe+aoaNOT1X8U/7W5B9HCtE7Yy1T6bZk
	I5xzXhzRa+dDZw4+OxFZBh9OIXqKo0o=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=SBJsXly+;
	spf=pass (imf02.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757409322; a=rsa-sha256;
	cv=none;
	b=IBDxa6YT6XBF2FgmpXiqJ2xVZbh8krZlnrSlDVyH3BigS/aXDSG9INdWCbSDFEd2Zmak9l
	+oJNSbjk8Kz7bQ8hiJCY1resS2gDfUfgVwFYUuaB3SJRS6qFCKGQJbQD8gwaGBIAZG93f+
	rk5sknoXwhV2P8ylPZIcxesljvcyiJM=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588M2Q5G032212;
	Tue, 9 Sep 2025 09:15:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=dmxWxoN1Q18ZYHji6
	RqAjuCQGOl4Ppungs5wn/Igdb0=; b=SBJsXly+usyHQwDCZihXYjFSNqJGm8fhO
	ZBjNrx4OIsrKdno0XVdtfTKpjudyiI+AWs89QxDrmlu2uUlFcMICe4WbSLTujJ9C
	ONaF6OrWxnjRVZtZXX6y3gKmlDBa9+AviIyCh42eIXu1XoR6P+VQhxwf3e1vY6tw
	MwaE/ia1t0m9A1XvdSauNZx9500F2M2gEAss7VAlSSdwV90xAcTNx9ZB2Zv5b+wU
	akhu+BKRxVBLuFtw8x/JDbXRTTFXc0lJ48+sLuyZbAwrKDXx5ENcnUs1xAKfZrOr
	fPb+ySYNK8c/jUoRl2bSsTDXRbYcC3d9QxED7/xZEk76Nq6LGD4Bw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490bcspgxn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 09:15:17 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5897G6Bd017219;
	Tue, 9 Sep 2025 09:15:16 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4911gma5b9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 09:15:16 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5899FGDR27525880
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Sep 2025 09:15:16 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0339B58043;
	Tue,  9 Sep 2025 09:15:16 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A73165805E;
	Tue,  9 Sep 2025 09:15:10 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com.com (unknown [9.36.2.198])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Sep 2025 09:15:10 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pasha.tatashin@soleen.com, sweettea-kernel@dorminy.me,
        nicholas@linux.ibm.com, christophe.leroy@csgroup.eu,
        alexghiti@rivosinc.com, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH v17 09/12] mm: Provide address parameter to p{te,md,ud}_user_accessible_page()
Date: Tue,  9 Sep 2025 19:13:32 +1000
Message-ID: <20250909091335.183439-10-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250909091335.183439-1-ajd@linux.ibm.com>
References: <20250909091335.183439-1-ajd@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAxMCBTYWx0ZWRfX8q3lUViPBIJp
 T8bZiNm9fkO6S4vS33XsYR9E2h2iAaQ81+oKkKOjfjAf7i7w5FgIYl/WlLraNJLKHntPmfKnjb7
 4s4d6i2Xw121XN51MFyOSWTjNXAmqMeH9Xz13xaptR6PmUo+AKPElH6FIsonMlNaUtCulo09Haq
 wDW00VZ8upQ/PsehAS3H3SRglwJxPd1q2bcJYTmVB6yy8EzguALR4aGh+1Jju8/RuDxwjK0NUcQ
 zmLP789NH2FuCByAfYrg3VLpwPlp1H3y5y0CRzM6vdIIP17owLlbHJAIlYqxdenrl1rYN3ihzDO
 Pw9EgwGjnajKZBiEz77g7dTi8aR1PMU9kmmpFe2AiLv4XtcJMfcDGnUc1dFrMl3Y1Crr7X5kva9
 zABGmK8p
X-Authority-Analysis: v=2.4 cv=SKNCVPvH c=1 sm=1 tr=0 ts=68bff025 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=7ipKWUHlAAAA:8 a=VwQbUJbxAAAA:8
 a=h0uksLzaAAAA:8 a=d4W435LUNj674h-W_cUA:9 a=gpc5p9EgBqZVLdJeV_V1:22
 a=MSi_79tMYmZZG2gvAgS0:22
X-Proofpoint-GUID: kLI6QkR3Yke0PKD0f89T97rM3QrfNq3g
X-Proofpoint-ORIG-GUID: kLI6QkR3Yke0PKD0f89T97rM3QrfNq3g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060010
X-Rspamd-Queue-Id: C0E3880008
X-Stat-Signature: 9pry3ye8kkdp3fmrxto55aafuy9fsjxp
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757409322-623979
X-HE-Meta: U2FsdGVkX19/7A1ZFyfDuHdHJkZOnuGjSmbLGZm8ii00lcbjbmD2OhO/kWaR2QT6zeKkMErDL6tQXXGUwBiQsVeG6sOlFKmMD3VI1svz48kTEA3Omr0XUE9O7L6elCTT0thHsg52ptSqN4cVXfg+bx8gbLPB5KCDXpaRXrT5LdgRGwji/lE/H162vel7ZwlikRfrLU2HlfZc8sPdOcajowpZyitQxGEOkL7yD4rcnom4MbEbCwzS7XGPc/NtXRqfW1fyrSLX/vY5su7vkd9IMsPqWbQXb5NfomSyNUfd0TrsFqybUO9PKNhDExIDBSvD29GQo9aGzReln1ma2OjRi0GLD9E1AzChdL6Qoiomx2fs3DjFkkvUb8di+QCRLYPWDSM1YYPXEghwrKZwREDLUY6dglFcJ/R5VlD1JshXgxwxXFRtrPmIq8ziJqCbAHWjygLex2V7zBqAL6dgOImQRuU4o7bzt/vOIt5mpZODuQOlGWMKbotHWYSg0fIxexashO1ZLqKkv7rgxQJ8TzQmip9HFMd5rCA1ymnYUyPqBsG2/oZpRJqKJYxl4i8WxaXdnutS8zVDCHsy8ivfWEKqefkbt1lzII2cRrcpZ7Zkf9bndlHAz6XqbX02viCK8BOYzl/5rvZ3TcPLuLrrEncRj3eXJh8nPvdcX0UvlqhvI8L2ypHHQkqrMmS1JMroB59siuhetdmd3C5WRujgciyB5y0VvKkxC9W/ZrzQYBqdQV6CXJvVQ/pAeooLk0tALVFx/0Am1sbyvkgq43SdU9Ij9wDXWr3+ubesk3hJRYp5gtdwxYpIlj5RN09VCAhS7dM8zsmnKdh63sJ+dskcxcO4OXMN+ubSPfzX5rUcqBIN1ti6crHEw9aXR7/p9MDYUmnrqQ4LfIkvQfGx10AWmmXmuSyJ3OPrU6VijX8v2Eag0Tu3OTVPl3gCzqAJxz0yXOBnfpazn1OUrdgoHTnCqfs
 Clf7s4GN
 hYsr35zJitfIY7JVXuKzVVjTfy5r/OjReza3qjwcxgS8OlHF5Rg2UuoXv4UR2/IRWafT+t+JXv88FhAL3hZgWTeD8cQoL4OjvuKo5Ra48s3jxxg0szWboXs3v7InPYa69Comqfq4rTAYKS6F6smmG6xxrQST0IExlyFKoCavpv3rvqLp6xZP7MnAfBRf6U5C1k6LrsL8Aqd1xuPpOspRhIqbedO1uHJ23nsLyJaPjkI/SBjpyToQwliT1K2wDvz4KRwoRgeS2JTJj9ECUjhMTqusTQdc/dXktUEqO9SW0umt51PO5DKR7qi+l2v8vDezaH9WUWFTc7CqQ++obAl6h/iG0Ou22t85JmX4BoE5AkgLcbEuZ1JSPHgJ/EBS1bEjJw3Lw9vTo45JeZJI/Ni5UwHo+IqdDqNWxKC451FBc7HXhkC6KuS3uBRDCKDL1p5KnoPDWau8t+caW+M1bHpUhWKJt9JZdKWAYB3XR6LfKtEsbqkt+bSjWANDp573f4Mq+R7Jfgqi9fn8Fg2U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rohan McLure <rmclure@linux.ibm.com>

On several powerpc platforms, a page table entry may not imply whether
the relevant mapping is for userspace or kernelspace. Instead, such
platforms infer this by the address which is being accessed.

Add an additional address argument to each of these routines in order to
provide support for page table check on powerpc.

[ajd@linux.ibm.com: rebase on arm64 changes]
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Ingo Molnar <mingo@kernel.org>  # x86
Acked-by: Alexandre Ghiti <alexghiti@rivosinc.com> # riscv
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
---
v15: rebase
---
 arch/arm64/include/asm/pgtable.h |  6 +++---
 arch/riscv/include/asm/pgtable.h |  6 +++---
 arch/x86/include/asm/pgtable.h   |  6 +++---
 mm/page_table_check.c            | 12 ++++++------
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 2203ebac81d9..254265e9a423 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1290,17 +1290,17 @@ static inline int pmdp_set_access_flags(struct vm_area_struct *vma,
 #endif
 
 #ifdef CONFIG_PAGE_TABLE_CHECK
-static inline bool pte_user_accessible_page(pte_t pte)
+static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
 {
 	return pte_valid(pte) && (pte_user(pte) || pte_user_exec(pte));
 }
 
-static inline bool pmd_user_accessible_page(pmd_t pmd)
+static inline bool pmd_user_accessible_page(pmd_t pmd, unsigned long addr)
 {
 	return pmd_valid(pmd) && !pmd_table(pmd) && (pmd_user(pmd) || pmd_user_exec(pmd));
 }
 
-static inline bool pud_user_accessible_page(pud_t pud)
+static inline bool pud_user_accessible_page(pud_t pud, unsigned long addr)
 {
 	return pud_valid(pud) && !pud_table(pud) && (pud_user(pud) || pud_user_exec(pud));
 }
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 65e8bc4ce45e..507afb8e8ce6 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -817,17 +817,17 @@ static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
 }
 
 #ifdef CONFIG_PAGE_TABLE_CHECK
-static inline bool pte_user_accessible_page(pte_t pte)
+static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
 {
 	return pte_present(pte) && pte_user(pte);
 }
 
-static inline bool pmd_user_accessible_page(pmd_t pmd)
+static inline bool pmd_user_accessible_page(pmd_t pmd, unsigned long addr)
 {
 	return pmd_leaf(pmd) && pmd_user(pmd);
 }
 
-static inline bool pud_user_accessible_page(pud_t pud)
+static inline bool pud_user_accessible_page(pud_t pud, unsigned long addr)
 {
 	return pud_leaf(pud) && pud_user(pud);
 }
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 63350b76c0c6..b977cebb5f44 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1679,17 +1679,17 @@ static inline bool arch_has_hw_nonleaf_pmd_young(void)
 #endif
 
 #ifdef CONFIG_PAGE_TABLE_CHECK
-static inline bool pte_user_accessible_page(pte_t pte)
+static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
 {
 	return (pte_val(pte) & _PAGE_PRESENT) && (pte_val(pte) & _PAGE_USER);
 }
 
-static inline bool pmd_user_accessible_page(pmd_t pmd)
+static inline bool pmd_user_accessible_page(pmd_t pmd, unsigned long addr)
 {
 	return pmd_leaf(pmd) && (pmd_val(pmd) & _PAGE_PRESENT) && (pmd_val(pmd) & _PAGE_USER);
 }
 
-static inline bool pud_user_accessible_page(pud_t pud)
+static inline bool pud_user_accessible_page(pud_t pud, unsigned long addr)
 {
 	return pud_leaf(pud) && (pud_val(pud) & _PAGE_PRESENT) && (pud_val(pud) & _PAGE_USER);
 }
diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index 1c33439b9c0b..abc2232ceb39 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -151,7 +151,7 @@ void __page_table_check_pte_clear(struct mm_struct *mm, unsigned long addr,
 	if (&init_mm == mm)
 		return;
 
-	if (pte_user_accessible_page(pte)) {
+	if (pte_user_accessible_page(pte, addr)) {
 		page_table_check_clear(pte_pfn(pte), PAGE_SIZE >> PAGE_SHIFT);
 	}
 }
@@ -163,7 +163,7 @@ void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
 	if (&init_mm == mm)
 		return;
 
-	if (pmd_user_accessible_page(pmd)) {
+	if (pmd_user_accessible_page(pmd, addr)) {
 		page_table_check_clear(pmd_pfn(pmd), PMD_SIZE >> PAGE_SHIFT);
 	}
 }
@@ -175,7 +175,7 @@ void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
 	if (&init_mm == mm)
 		return;
 
-	if (pud_user_accessible_page(pud)) {
+	if (pud_user_accessible_page(pud, addr)) {
 		page_table_check_clear(pud_pfn(pud), PUD_SIZE >> PAGE_SHIFT);
 	}
 }
@@ -208,7 +208,7 @@ void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
 
 	for (i = 0; i < nr; i++)
 		__page_table_check_pte_clear(mm, addr + PAGE_SIZE * i, ptep_get(ptep + i));
-	if (pte_user_accessible_page(pte))
+	if (pte_user_accessible_page(pte, addr))
 		page_table_check_set(pte_pfn(pte), nr, pte_write(pte));
 }
 EXPORT_SYMBOL(__page_table_check_ptes_set);
@@ -234,7 +234,7 @@ void __page_table_check_pmds_set(struct mm_struct *mm, unsigned long addr,
 
 	for (i = 0; i < nr; i++)
 		__page_table_check_pmd_clear(mm, addr + PMD_SIZE * i, *(pmdp + i));
-	if (pmd_user_accessible_page(pmd))
+	if (pmd_user_accessible_page(pmd, addr))
 		page_table_check_set(pmd_pfn(pmd), stride * nr, pmd_write(pmd));
 }
 EXPORT_SYMBOL(__page_table_check_pmds_set);
@@ -250,7 +250,7 @@ void __page_table_check_puds_set(struct mm_struct *mm, unsigned long addr,
 
 	for (i = 0; i < nr; i++)
 		__page_table_check_pud_clear(mm, addr + PUD_SIZE * i, *(pudp + i));
-	if (pud_user_accessible_page(pud))
+	if (pud_user_accessible_page(pud, addr))
 		page_table_check_set(pud_pfn(pud), stride * nr, pud_write(pud));
 }
 EXPORT_SYMBOL(__page_table_check_puds_set);
-- 
2.51.0


