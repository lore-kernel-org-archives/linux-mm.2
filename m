Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B30E1D6E2BD
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 17:10:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD1CE6B0089; Thu, 18 Dec 2025 12:10:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA5EA6B008C; Thu, 18 Dec 2025 12:10:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2EFC6B0093; Thu, 18 Dec 2025 12:10:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 92D536B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:10:16 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2809412915
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:10:16 +0000 (UTC)
X-FDA: 84233230032.25.9BF406C
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf28.hostedemail.com (Postfix) with ESMTP id BFBB3C000C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:10:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="f7LT/bCY";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf28.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766077813; a=rsa-sha256;
	cv=none;
	b=2E/1ZxpooqK62iFJBxpTwrvSoThnV4IEHDQkUDYz5ohApoEJwCm0M/qpGtGFIzm2P5twjX
	HkCFgGNANeKk1KualeoVPlLHP0RILISGDkRzqD+hOrWsMZZQ6mTmgnJ2BhT5bqzFjExYU2
	WINWvy07HANCzr3640YHoP1vLH0x7ok=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="f7LT/bCY";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf28.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766077813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=own5/WUxkJ7uUm7nDnOfa3J9RGTcbUFWeyg//NbZZm8=;
	b=bAJ3e6YqWBJMD+EDwdt6MGZQMCNXeoOeeH6+oqVXwsMSeDmiv04Gp313C0dY75zflzJ4JC
	GaBwctg5Eki5ZMJ422CV0nNSdz+JTcatq5B9LztRYlB6WrBiv47kQw/JfuyyqxvJNCRULk
	0RP/Y0cjkPINRi5z4rZsmITN3FhM1pQ=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIEQY12032421;
	Thu, 18 Dec 2025 17:10:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=own5/W
	UxkJ7uUm7nDnOfa3J9RGTcbUFWeyg//NbZZm8=; b=f7LT/bCYuTb2RsBrMKjwiN
	puc/TVz7zgjtBIu7K2Jh3vboqdjgu+EjGFEp9iHywQkgZ1W77p5c4HNDYFqPv24X
	+3/a1AFNJHLqUZWY5KGyqfxbm8WgJUxrD9LOiTFiUXwnlg5yZ+jSytS6ze+1grVB
	zuglpqOuyt5g5L+lH8HJIfdnWYJV496Sjyxm9lhl9CGu1Si7ciODRA9iwzrN0Zo0
	VEJBmnuxaMAnHt10nhmUXSpQG+S4Z/Pn0pmYmOmmujt//XePRZPgnkTqkTr+dU6s
	G4fyLmx0+bZQC5ph31JPAz5tmH8hYHhXX7dz8YDhTFo2nX2+dw9+4b16sxbG/koA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0wjqb7n3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:10:08 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5BIH9vtj032577;
	Thu, 18 Dec 2025 17:10:07 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0wjqb7my-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:10:07 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIElrQu014318;
	Thu, 18 Dec 2025 17:10:06 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4b1mpk99ea-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:10:06 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BIHA5fa27001514
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 17:10:05 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A3A995805A;
	Thu, 18 Dec 2025 17:10:05 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 247805803F;
	Thu, 18 Dec 2025 17:09:59 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (unknown [9.36.16.51])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Dec 2025 17:09:58 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
Date: Fri, 19 Dec 2025 04:09:34 +1100
Subject: [PATCH v18 02/12] arm64/mm: Add addr parameter to
 __ptep_get_and_clear_anysz()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251219-pgtable_check_v18rebase-v18-2-755bc151a50b@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEzMDAwMSBTYWx0ZWRfXz2BXSIdKVlKv
 ph9tKMbKKWgYJVE+YjwoQH0CGqLmECCZuiPUxLGsr8MwdqdkA8rTAYBjfJDSxUZgPcTSCkUlPmI
 lrD6On7m+7WClXQRr/QUvAS/AzaiFk738mzAq/MNE/QEAnrWFN4IQoh1mvzN4XNh3o4psowF+En
 o0SQzcV9ma2BDAxdicQfTUQGAux5hiGzwXObHpGF8UM3KhQfN+zZgaP/NrE9mEbV0DiYOkOW3tK
 bBiaxKSJ6vzSdQE2xqk+F9uEh72/Gm3JHQPPBq2cFFMeZ1tf0Q7Nb8tIWKREu7hUFh7vd1SwFTy
 oWjCzTFJUjN9/O7DRNd5Joq7acw0Lp4Wj6opSl+Hg2U4+4RPUbO3qsVVpbqQUl9a8KF2auN2tw5
 Um4BFfMgWrVAulVcQVsHYjJfsF86JQ==
X-Proofpoint-GUID: E5wcBm6o_TA3p2uE06S9hUaC0FTJM0c3
X-Proofpoint-ORIG-GUID: Gme6pxPtjG-OXJ3yR_iw4NEDBblaNn5Y
X-Authority-Analysis: v=2.4 cv=Kq5AGGWN c=1 sm=1 tr=0 ts=69443570 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=4PT1ayd0SIKHQ98-h3UA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-18_02,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 impostorscore=0 clxscore=1011 spamscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 phishscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2512130001
X-Rspamd-Queue-Id: BFBB3C000C
X-Stat-Signature: ai7k7416oxmhidnjq4hmzyi4xoxrq4qh
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766077813-385050
X-HE-Meta: U2FsdGVkX19eGgshnxyI9I3toEL9xDxMp6FWjml3ZW9DeL2G7NH30YB50k58aF6awrUaWQyFFfJAJ5NJywEW1MjLV7i02UdPF85zwOAxasRB4LaTpblZ0tToywKaQVwNtLn/2LL+6GCBGlFqVoZ2UXWsOX4wvrd5rXuaVEnl31/DvQ19Fz1mwKheYxtYWiFgz1me35ADFVZdHRZzXbmiw33qYtY5xOdhD/WvLD5ynoG2h79lWv9CUOeUezJ2JqEFB2zltXgZhdNTtoVUy1JeMivCnOg/RoqcLdZg+72JErmNA9IU7j7D6TYyO5ruWTZnzoCqaxIpkoVpPfo+7P+XQ8yDgvYWmTNCw07ElFlt0qSAGNVBaU1oiW0u2/NoYY71FLU/RLrYz+es/htZXx41pxUD9m7ZrlpGRWCa9QwuQMoTIZAFdv8NSr6bkqwUiaqMq7sPDNDfZQ4aSXCtDghJuPLi6hhVA3P1//HeG9dgcYN8gfvLibcf1mHXHqIWE8GerhLIjrn2KY623e+USWNob1/FVaIf2hscNc+y8le9fZu5TXAzG7lraibaCZfb/u+jau5OM11RdUS+mEQL29r8fr1ONG8RUZv1w6jlG2txbwIbZ0hLzn6WaeqBPmGwCtrz0mIl0MntIMMj3skwffOhQNYRSmUcyrRRCR0UkIwU1i4bhmWSmqkxcy+cBzdKftnMw1WpRPI/cqTPaAM6xTnT891WJPe+JmScTnKq0pI8+W/3ew8Iw19/8yuUJRxmrv0qx9P4ZqK6mHvc7jZXmNGL3XLauvpOxLrpC4+d2EvyxQa0X7DAVv+RWq5wcMDkfUWn9uBNOXt3/8xTiVItRMKExar7g+2UJuDp+PguXZndGacoMXppKdWdblqsaa8Y030srYy1EMd/F7lr5gUOXOfE8gz0aafBQEYsRyNRnnJlZ1g/PfYaaQL8mFRN7ekgSQ2BTHkw+P5NRxqLZvbpehd
 P69VBGUW
 4tYTpWCdFg9ZPYmSaaiFLHX2BwF5921F86K9xBEoITqHavleEdVpI7CWQa9vy2lCARnBPlrriquFkS4t+4LYIafyNKsrJbRlWka+pucv5MiVPyJGzGTp4YMCcSGtKploMt2zALSPs0DxgxzA1j3/wsP4q2+Zb73OOUYxhlKpJJ6W7uQXezgepZKV2qImSkDFEq3y15W2CksD2PqbqmcBMKEz/Kbv+xgi28Zyhx7/ATzR7KkRu+lCHg0IXOT9Nfj8MFvnJxAGqivaowXcwLx1zu88G7v+df0OgTuyvGRg+Jk5o7cwxR1zRpAV6M81S+VCnKzcEC94WzMCGP2Ob/dHLQ88qoj6dH4Ol3T/26zRANm4CoF8RujkGll3lGdQXuWLdVorKUOBslZj/pT+Xl5x+GwJgccmPE7u3IZQGihdDg4nRaAsEbi2wj6WRpw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To provide support for page table check on powerpc, we need to reinstate the
address parameter in several functions, including
page_table_check_{pte,pmd,pud}_clear().

In preparation for this, add the addr parameter to arm64's
__ptep_get_and_clear_anysz() and change its callsites accordingly.

Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
---
v15: new patch
---
 arch/arm64/include/asm/pgtable.h | 5 +++--
 arch/arm64/mm/hugetlbpage.c      | 7 ++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 52f3ea07427cef399e68bea0dbab39d03ea83060..29f7ae7011a820687f5b1e2fdc782eb37f85fc1b 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1332,6 +1332,7 @@ static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */
 
 static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
+					       unsigned long address,
 					       pte_t *ptep,
 					       unsigned long pgsize)
 {
@@ -1359,7 +1360,7 @@ static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
 static inline pte_t __ptep_get_and_clear(struct mm_struct *mm,
 				       unsigned long address, pte_t *ptep)
 {
-	return __ptep_get_and_clear_anysz(mm, ptep, PAGE_SIZE);
+	return __ptep_get_and_clear_anysz(mm, address, ptep, PAGE_SIZE);
 }
 
 static inline void __clear_full_ptes(struct mm_struct *mm, unsigned long addr,
@@ -1398,7 +1399,7 @@ static inline pte_t __get_and_clear_full_ptes(struct mm_struct *mm,
 static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 					    unsigned long address, pmd_t *pmdp)
 {
-	return pte_pmd(__ptep_get_and_clear_anysz(mm, (pte_t *)pmdp, PMD_SIZE));
+	return pte_pmd(__ptep_get_and_clear_anysz(mm, address, (pte_t *)pmdp, PMD_SIZE));
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 1003b502075208d4252c27ffdacb1aaf4928639b..bcc28031eb7aa4ba175b5552f5449e69c6af5e61 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -159,11 +159,12 @@ static pte_t get_clear_contig(struct mm_struct *mm,
 	pte_t pte, tmp_pte;
 	bool present;
 
-	pte = __ptep_get_and_clear_anysz(mm, ptep, pgsize);
+	pte = __ptep_get_and_clear_anysz(mm, addr, ptep, pgsize);
 	present = pte_present(pte);
 	while (--ncontig) {
 		ptep++;
-		tmp_pte = __ptep_get_and_clear_anysz(mm, ptep, pgsize);
+		addr += pgsize;
+		tmp_pte = __ptep_get_and_clear_anysz(mm, addr, ptep, pgsize);
 		if (present) {
 			if (pte_dirty(tmp_pte))
 				pte = pte_mkdirty(pte);
@@ -207,7 +208,7 @@ static void clear_flush(struct mm_struct *mm,
 	unsigned long i, saddr = addr;
 
 	for (i = 0; i < ncontig; i++, addr += pgsize, ptep++)
-		__ptep_get_and_clear_anysz(mm, ptep, pgsize);
+		__ptep_get_and_clear_anysz(mm, addr, ptep, pgsize);
 
 	if (mm == &init_mm)
 		flush_tlb_kernel_range(saddr, addr);

-- 
2.52.0


