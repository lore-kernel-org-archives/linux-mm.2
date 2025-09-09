Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B250CAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:15:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 038098E0015; Tue,  9 Sep 2025 05:15:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F03D26B00B3; Tue,  9 Sep 2025 05:15:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF28C8E0015; Tue,  9 Sep 2025 05:15:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C8A556B0007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:15:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EB66311A053
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:15:23 +0000 (UTC)
X-FDA: 83869153326.01.7480E30
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7B29818000C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:15:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=rG3jEanI;
	spf=pass (imf16.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757409321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1uJ0iwhU4FqgLjbCr0UKoAb4D8xXYP27h7JXHlGAl7o=;
	b=3H6G70/TySIUr9D9DW8Jb6Y0Ob6XWtLaz4ht7t1uQvcaPq8/9wqAtrSK5trXhX8hYi/mlB
	1Vv8pD2RPiztNPZCepV/O6IeD4M0RbVwgn44LEl71E2m0PmZ6Rlr++9wOnio+h0t8H7Ct/
	kTkv/TBbx6jDJQyeSFPEYOefHsVHsds=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757409321; a=rsa-sha256;
	cv=none;
	b=cfmqmNm73LNB9DaL+C9eGUj98FcGIwT/lBEtx4GRb4yqjrlqJ6vyx//Wf28kxo3YLEGcLE
	3uxObPp8PKYkeOEfK2fZZGhFaMyX1Rnpo4jbwTjzE7OPT1buVA4uN2psnoanCVdJdbifWF
	HwBDpkGExB3oPXHCHHJI0/mjbd3vGjk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=rG3jEanI;
	spf=pass (imf16.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5898vfpP008280;
	Tue, 9 Sep 2025 09:15:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=1uJ0iwhU4FqgLjbCr
	0UKoAb4D8xXYP27h7JXHlGAl7o=; b=rG3jEanI3FXY3dnkcWjCDe6COQrTLx/1S
	phmA4pmOvaIUg+05jOHQoW/mXKHp2oRpISoAmEePVADf7ycNvytEMQhhZDgaTfvG
	daXUGRO9CE2o6LqolnkDO/Eks5USjnHqnOorKLX/G8O2wKnbrkm6AHTHIHHp04Ki
	IYJnjsPLqF9RL5Y8yx5U9lXsYpqIpuVpaKOwfdTVrE2jFwmqA8BMcC6vqfRDlcNS
	QPoKa0IWgDYTeMiUGkT8Oh1rUBNstFH7H8413Pug6NA56jkD4xMlVqM+1SKGS0rx
	N5c4pzY1YfZ9eQDjLfT/vvqFgN1sFIrAm1F3yslJQRhPUHgadwfVQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490xycum5x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 09:15:11 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5897Rp9v001155;
	Tue, 9 Sep 2025 09:15:10 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 491203a26k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 09:15:10 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5899F9Ip17105516
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Sep 2025 09:15:10 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D3CA258055;
	Tue,  9 Sep 2025 09:15:09 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3457758061;
	Tue,  9 Sep 2025 09:15:04 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com.com (unknown [9.36.2.198])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Sep 2025 09:15:03 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pasha.tatashin@soleen.com, sweettea-kernel@dorminy.me,
        nicholas@linux.ibm.com, christophe.leroy@csgroup.eu,
        alexghiti@rivosinc.com, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH v17 08/12] mm/page_table_check: Reinstate address parameter in [__]page_table_check_pte_clear()
Date: Tue,  9 Sep 2025 19:13:31 +1000
Message-ID: <20250909091335.183439-9-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250909091335.183439-1-ajd@linux.ibm.com>
References: <20250909091335.183439-1-ajd@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: i-P0mBNkFrbrWx4MowX9rincM24gwjqP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDIzNSBTYWx0ZWRfX5jG7RcUpDjYe
 DTBelmUh1EIRNiIix0PGtJqmmqw3H5/SQQxGTVTgNjM3lYmQybOwujrFk9ibtU6kn67qeB/lFWL
 RkzbV1oG+9dhistyd+zNmWw6zwiC1yiDoBw2fJZH0Mt+jGYY6JzwHfxyhsehu8K6/sGI/rorQLZ
 Ks88LgkU2QN+AIsKfxNkmpci7RFC4/CNx1vZXH8UtWEUglPaexTA7rQqDeMo4HKTTYjeqwZHs0p
 r5lLW/GbEiFC3baUev9CwDpu+z2Jxtc0h+qaWGI3VJ3f8kvDvzc3rkmAY3du0xjKKnRxkxVje9Z
 TtWB2AeB6QCdeOP7gj5K9QsIeEZ4tikFOZD8KyKVy5824dLgmwLgv7l037Yb3Ar5U6XGTXwJPsW
 uR74/v1d
X-Proofpoint-GUID: i-P0mBNkFrbrWx4MowX9rincM24gwjqP
X-Authority-Analysis: v=2.4 cv=F59XdrhN c=1 sm=1 tr=0 ts=68bff01f cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=7ipKWUHlAAAA:8 a=VwQbUJbxAAAA:8
 a=h0uksLzaAAAA:8 a=brIg1AGlUOEcU9TjG_MA:9 a=gpc5p9EgBqZVLdJeV_V1:22
 a=MSi_79tMYmZZG2gvAgS0:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 clxscore=1011
 impostorscore=0 bulkscore=0 adultscore=0 spamscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509060235
X-Stat-Signature: 18nmwyp3jp8ruriss15e93djis8jumqy
X-Rspamd-Queue-Id: 7B29818000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757409321-276741
X-HE-Meta: U2FsdGVkX1+NP0hvfw/YZUQbRrNP9M8GNBrtPCWTBkj70+J7qp7Mzmy6UlwP2ZbE06n8Mzqb7PdOLvHO4h0xS00US7ksruasgf1IhoSpfCaoGVX2ZXLR4W7u1BIPdKUfiJD2M9p8CyamMkqjyLDeMQ+n3zeHEVgWhowUD0WhSjjru0aMiKpsekfnqE0B+ifdezdfazFO04V783mOdQ3gtlWZdm60/yLC5v4SkPr0ccBpPawBb2RPRNZFICyRlF6HYZ4c4ggqTzkCNJREhgBQpCSENqvIFOVT3tvqZPuqtCJn9GcJqwMhrcW5OHnwuixytOLOGvbFSU2vpXy93sUwneUHfAZAfLjWKjZ76Tq9cJUWRCqgnGXmSsk/Yz4ylBZohyMKSp3S0F6m383ZGVu9tYEucO9GTWQIcoump84QO6cEjryzVgAk22aQF0ZrJET0A07swUPqXi1Ws5Z6nQiWvUEzSSTtkAnyAXYg/q2GlB2Nfu/sngk7bD27idIpzcx/ASaywDx6asBOmBRnM1hB1h6zzGo8zIwA0o54mVqOw9V4uL/JUY/b46gAoKKsIIiE25pzgZmILskosK2NNHbeDUDkLqpn/8Yk8d+RyjYjYF9WfXKVQtejI+/xPyLgmneFErmvxCVUeAzuL/VZhL/7prmzCoYAAQftR6006KPFYg1NAegreqJriLdaUif3ZwV0Uoj+uR6h16q6OKBPgbysbwttAdAfqjFeNiMHvYjKk1CIDNzzYVxKx/PN01FnjMN3pJJbUjdSYrRbqRi0RiXfelqc4d7zmxZrhdfGgWaewReHu7y0Ur9BTwBIPv1/3pS3I0DNO0fYjQ2K0OCFRlXchWmMQuyJ317LkkOE9uY/FzsHU9X4wXHdLr6FWaoYaAOki7UpHeB3VQKqoPduoTT9cV7PcAxdt0I30uD6yKXmqYs9RAThq0UZsGMi4LfZzlQJ/ZIwV2kfXXB4ywnSMNn
 zZYj1RBs
 BTv1Ts1b3nDvW9bynsc/qUagliA5fnQX9Mw88CP32BFmbTijiej57muR7JngFVIZSj3rz5pFoGEuNCcuXvh75exms5uPGzXVPS4bFPjU8+oHa5HRrKmeshSbIJBLHGviQiZpKqbAueGTx9tk75M45jxBlLoRrkbdiLO2lRfUANxTRK++JDfb3pRDGy+OSv8wor7V3vNF9K+LzC7bNdLvMC37dz77Iw2HF6zoJgifnAH1MU78W4AGoc0aLAaEBhSgakZHFfwTwj0LpTBa78LTbS0HQy1ENkCu8uVgRyTHcDhT8DZE1hh2SHPl0pmZ2R6/aLpuCd1oKzOnFHAO/2XD/zBEn5uNWW2SWsEiAjz41/OWRMIVOHzmjlThXHDUmRx7cWNkqQ6g8Pmtttq5J1pnSs8qSIDAqpKledPTh0NlUgL/zz0mu2Rg3l3qbjGlnV70jvFZL7jmZkWMjPUe1mOfzul6ekBMPBuAFZJvWknte0lUPk4D/cPPYb0wvtfFKtIc+LDlQXOZs7hRFB2g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rohan McLure <rmclure@linux.ibm.com>

This reverts commit aa232204c468 ("mm/page_table_check: remove unused
parameter in [__]page_table_check_pte_clear").

Reinstate previously unused parameters for the purpose of supporting
powerpc platforms, as many do not encode user/kernel ownership of the
page in the pte, but instead in the address of the access.

[ajd@linux.ibm.com: rebase, fix additional occurrence and loop handling]
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Ingo Molnar <mingo@kernel.org>  # x86
Acked-by: Alexandre Ghiti <alexghiti@rivosinc.com> # riscv
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
---
v13: fix an additional occurrence
v15: rebase, fix loop handling
---
 arch/arm64/include/asm/pgtable.h |  2 +-
 arch/riscv/include/asm/pgtable.h |  2 +-
 arch/x86/include/asm/pgtable.h   |  4 ++--
 include/linux/page_table_check.h | 11 +++++++----
 include/linux/pgtable.h          |  4 ++--
 mm/page_table_check.c            |  7 ++++---
 6 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index dfcdf051b114..2203ebac81d9 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1367,7 +1367,7 @@ static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
 
 	switch (pgsize) {
 	case PAGE_SIZE:
-		page_table_check_pte_clear(mm, pte);
+		page_table_check_pte_clear(mm, address, pte);
 		break;
 	case PMD_SIZE:
 		page_table_check_pmd_clear(mm, address, pte_pmd(pte));
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index d8bf210b57aa..65e8bc4ce45e 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -591,7 +591,7 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 {
 	pte_t pte = __pte(atomic_long_xchg((atomic_long_t *)ptep, 0));
 
-	page_table_check_pte_clear(mm, pte);
+	page_table_check_pte_clear(mm, address, pte);
 
 	return pte;
 }
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index b68bea15f32d..63350b76c0c6 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1251,7 +1251,7 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
 				       pte_t *ptep)
 {
 	pte_t pte = native_ptep_get_and_clear(ptep);
-	page_table_check_pte_clear(mm, pte);
+	page_table_check_pte_clear(mm, addr, pte);
 	return pte;
 }
 
@@ -1267,7 +1267,7 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
 		 * care about updates and native needs no locking
 		 */
 		pte = native_local_ptep_get_and_clear(ptep);
-		page_table_check_pte_clear(mm, pte);
+		page_table_check_pte_clear(mm, addr, pte);
 	} else {
 		pte = ptep_get_and_clear(mm, addr, ptep);
 	}
diff --git a/include/linux/page_table_check.h b/include/linux/page_table_check.h
index 3973b69ae294..12268a32e8be 100644
--- a/include/linux/page_table_check.h
+++ b/include/linux/page_table_check.h
@@ -14,7 +14,8 @@ extern struct static_key_true page_table_check_disabled;
 extern struct page_ext_operations page_table_check_ops;
 
 void __page_table_check_zero(struct page *page, unsigned int order);
-void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte);
+void __page_table_check_pte_clear(struct mm_struct *mm, unsigned long addr,
+				  pte_t pte);
 void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
 				  pmd_t pmd);
 void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
@@ -45,12 +46,13 @@ static inline void page_table_check_free(struct page *page, unsigned int order)
 	__page_table_check_zero(page, order);
 }
 
-static inline void page_table_check_pte_clear(struct mm_struct *mm, pte_t pte)
+static inline void page_table_check_pte_clear(struct mm_struct *mm,
+					      unsigned long addr, pte_t pte)
 {
 	if (static_branch_likely(&page_table_check_disabled))
 		return;
 
-	__page_table_check_pte_clear(mm, pte);
+	__page_table_check_pte_clear(mm, addr, pte);
 }
 
 static inline void page_table_check_pmd_clear(struct mm_struct *mm,
@@ -119,7 +121,8 @@ static inline void page_table_check_free(struct page *page, unsigned int order)
 {
 }
 
-static inline void page_table_check_pte_clear(struct mm_struct *mm, pte_t pte)
+static inline void page_table_check_pte_clear(struct mm_struct *mm,
+					      unsigned long addr, pte_t pte)
 {
 }
 
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 46fe3daa4b18..e3f302ddb734 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -494,7 +494,7 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 {
 	pte_t pte = ptep_get(ptep);
 	pte_clear(mm, address, ptep);
-	page_table_check_pte_clear(mm, pte);
+	page_table_check_pte_clear(mm, address, pte);
 	return pte;
 }
 #endif
@@ -553,7 +553,7 @@ static inline void ptep_clear(struct mm_struct *mm, unsigned long addr,
 	 * No need for ptep_get_and_clear(): page table check doesn't care about
 	 * any bits that could have been set by HW concurrently.
 	 */
-	page_table_check_pte_clear(mm, pte);
+	page_table_check_pte_clear(mm, addr, pte);
 }
 
 #ifdef CONFIG_GUP_GET_PXX_LOW_HIGH
diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index e8c26b616aed..1c33439b9c0b 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -145,7 +145,8 @@ void __page_table_check_zero(struct page *page, unsigned int order)
 	rcu_read_unlock();
 }
 
-void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte)
+void __page_table_check_pte_clear(struct mm_struct *mm, unsigned long addr,
+				  pte_t pte)
 {
 	if (&init_mm == mm)
 		return;
@@ -206,7 +207,7 @@ void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
 	page_table_check_pte_flags(pte);
 
 	for (i = 0; i < nr; i++)
-		__page_table_check_pte_clear(mm, ptep_get(ptep + i));
+		__page_table_check_pte_clear(mm, addr + PAGE_SIZE * i, ptep_get(ptep + i));
 	if (pte_user_accessible_page(pte))
 		page_table_check_set(pte_pfn(pte), nr, pte_write(pte));
 }
@@ -268,7 +269,7 @@ void __page_table_check_pte_clear_range(struct mm_struct *mm,
 		if (WARN_ON(!ptep))
 			return;
 		for (i = 0; i < PTRS_PER_PTE; i++) {
-			__page_table_check_pte_clear(mm, ptep_get(ptep));
+			__page_table_check_pte_clear(mm, addr, ptep_get(ptep));
 			addr += PAGE_SIZE;
 			ptep++;
 		}
-- 
2.51.0


