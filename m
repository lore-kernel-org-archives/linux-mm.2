Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96C83D6E2C7
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 17:11:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 087B46B009D; Thu, 18 Dec 2025 12:11:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0245A6B009E; Thu, 18 Dec 2025 12:11:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E68AD6B009F; Thu, 18 Dec 2025 12:11:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D7CC66B009D
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:11:01 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A8854160283
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:11:01 +0000 (UTC)
X-FDA: 84233231922.12.A93EA59
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf01.hostedemail.com (Postfix) with ESMTP id 39AA740017
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:10:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="gkHape/f";
	spf=pass (imf01.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766077859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H/w/fSn72/VmP53WNGDX6nGiFGwqFhlL7pz/p8V4Uk8=;
	b=dr1w2c2gtOQaJykU4Fq3//BOwXqE3/8j1wlgeDZlS+bl/L+JOe+/5voyGBVYBwgdRieHAP
	ZnLAkhPBTWeN9aBhqHLLX4ymZhpXkCo1j2Asrf6puggF5mpkjYkS1/SqeTETeKER8CWN6p
	bmsr4FADL/E94+xJXMQQ4o6g3S/IeKA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="gkHape/f";
	spf=pass (imf01.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766077859; a=rsa-sha256;
	cv=none;
	b=BwW/uZPvsCci0IgBKFJoA3oD6inFfQT0bVe+mwJP1oYU4jo7xQ6JwCwvQDVR6ftZ8ZFQWk
	0lY9s2db+bc96gO3O0C/doE8KlDIHM7eariYYew8kkRgeoxIRI8m/SBIKIqLdkpA5Oryqn
	vCsOIYI5GQyV8FeA206/lYjXhL+qLQc=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIAUOgf021603;
	Thu, 18 Dec 2025 17:10:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=H/w/fS
	n72/VmP53WNGDX6nGiFGwqFhlL7pz/p8V4Uk8=; b=gkHape/f8wlm87feHs36tA
	FzlUXzj4I+j7dwjLx7Kctvv6FaKnrKutG++pWdo19+zWS1R3UTREdJv6mzwtrGlu
	S/SGqh3w6LDhT/cmWFMX1TSMwBh+8rKMnNhln/+NBltrUeuiRTRX81nSY44EHcYF
	/F27At6cog89OIFiSpgeA6FB7RWXAfhrjNIt5L1JtXYv5kpGLDTJUhAhWUISgBqJ
	gWyoGyZ20GE/Ndj08lJ0ZBPGi9mY6K2T+bbYoxud+0uUQhDdGL9jnfiXXiKM+q0L
	c5LdHq2lNBIsGW+wmdrKJ376tThPO0rDbMaKamIW6D5wECk1iOA4hpZ+ifyw0+FQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0wjqb7rf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:10:54 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5BIHAr7C002024;
	Thu, 18 Dec 2025 17:10:53 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0wjqb7rc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:10:53 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIG7F5P005674;
	Thu, 18 Dec 2025 17:10:52 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4b1tgp87cb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:10:52 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BIHAoMw21365448
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 17:10:50 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 736095805A;
	Thu, 18 Dec 2025 17:10:50 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 29AE858063;
	Thu, 18 Dec 2025 17:10:44 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (unknown [9.36.16.51])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Dec 2025 17:10:43 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
Date: Fri, 19 Dec 2025 04:09:40 +1100
Subject: [PATCH v18 08/12] mm/page_table_check: Reinstate address parameter
 in [__]page_table_check_pte_clear()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251219-pgtable_check_v18rebase-v18-8-755bc151a50b@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEzMDAwMSBTYWx0ZWRfXyW/AHu/sJjPm
 b95QWXHVntQ+5Qp4i7lInwLggP+sFMm+Sh/Tv6w4gw0GJTAqCr8QHLHeXEk0VGTGvS38qP/so7h
 xCP9f/1sIGQFPiFvM/Frm/cgYnxEeGCfwV0KNp9HRB7lFhbjgiBulZQYbcFJhxkGetl+13z0EuE
 JsXZPH9juzkLygRRR+WnRh08uM2+oIhZhZmgdkOe/c9jmX1TEFoLJCRbnF6kL/V9AZuQTUl+oP9
 CPJjcqIpX7EM+bL2t0lBIWrDA7WSp0FQVCvpy7ritINWcAIHnoD6Nu8H/NQTmDdl1WcQAv7buKH
 FD1ORS2ONPw9iBSyWfQAiRDLMfyVxFcJSVkRZIAAroivJ9eCyXxhLWzkjZ3LE3/Rzmr66zyBZF2
 D/E8nsr7PfKp83KFl2MJTAvpbkPVZw==
X-Proofpoint-GUID: 5Yp_muOMmFYPg8SoPPTo8b4fMYAx304e
X-Proofpoint-ORIG-GUID: kUFzuvcp4Yqhwu3JiKAwrki2bEfwTDz2
X-Authority-Analysis: v=2.4 cv=Kq5AGGWN c=1 sm=1 tr=0 ts=6944359e cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=7ipKWUHlAAAA:8 a=VwQbUJbxAAAA:8 a=h0uksLzaAAAA:8
 a=PxBa0D0WfF5aqmTnE1kA:9 a=QEXdDO2ut3YA:10 a=gpc5p9EgBqZVLdJeV_V1:22
 a=MSi_79tMYmZZG2gvAgS0:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-18_02,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 impostorscore=0 clxscore=1015 spamscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 phishscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2512130001
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 39AA740017
X-Stat-Signature: h141111wqapdnd9emom9u8jfp31cwuzn
X-HE-Tag: 1766077859-677383
X-HE-Meta: U2FsdGVkX1+zIrI32P2DBKxpF3Gru1PjRUvrmdG6DyfJdmToJWJxMRblwo2XAoSW+inXtZM/wuPx+/DlbVP7AbMwQwU1y/KvUreIll3mSfK9/vtlHyFoOMR3SNTdf781zNPRHO7yvMuR7O9+o96uxdFwUlSUtILQEFw3F0Kc5WAYG+jeywIz5+SHV0STNl9V8MbykjwYhbSZHsSdxz6MBTPkCmnae4h9L7D5zkPzJFfZ1Y0l/RCTFb8AcDDCTdaEnxN1kc3JIGQEyqjeI0DhFL1CoyudMYI5TUa+9Tg1IevxPO6cQB3H0e6hRDpWrpxLA6VQe4Kh9lV0Qz/WExxlScBQASfGoh9Mq6nFruAZxkXixqj0IqTFngc3PWg5BCcCfgt5Lryw3tlRUzkgi8wLDY+Bqhyzz4JR338OB0DZhsAJPB84SobN14XQgKjf78FGZT/AXmcM82YxwZrO9QBW9XLD9VcIT/RIK7f/Nkq3OMYMKXCGVC0Uktltt0SrsU1c0OG7TDXoduOplF8wXTauV2nsOI5M2eKEZ55l6WMPN2pWvv1UzGyrRaHwhDxKZmL4B9+rgn8WLt24zAXb84VVliK+p/1hwDmx71QPMOX3KX8T2K7eoK4WF7UoVn/8BXe817GHvPhOhZkcalRN0Mx1K5sZaUU8Z8rg82ieZrtPf8XVtWKoqCTQ4CgyIID24rl0mHrLUW+9wvt73PPE3SoKpMwOGA69q7DLqLSATZVvwytQMGri2ReR5lpuzEmBpCCZk5P4WqY4P636ousNFvUpr0BJNjN0hGeoqX/Y53aDyqXdfFeqISxMQ+RwdaO0YvdLRZvX5rhun62IoRXPqrnsQCYtHj8k1vRx1F0/b4q+Vv0r81bFa7mcumL6ztVHLTjRn+r5NnkY0azkkUA4xxFdehmyC5x+xqFzijgVoZzM1THTKr/5gqFPt4kQpZgiQzQX978C5EW11WP5DzvCqWe
 MkCHH4Vw
 MElRT3426tPDlWTxQ6KFRzsC7WMDi++5lHOmBfljxxHeEEN+n97TTD7w6zvk1mV7guOXkG1kFKZHxIOzdEdDcTR+E+paUl8GH4SXgJY7RBbY71VM6ZLJ3rLGdCaCmxECxwExjs4jdobSFN17jDHrdCzlnHdZPULIukOlJL2RdHVKGf1OAzq4AX3sM9VcuyxGA9xgK4lnd23hKqqsOOcVMakj+k8WCcnNqr1wX9XfcDBj1JaKwejSjJ6uzcKck81nqrJeAth9kqpZ75qQQD+hzENkOQ+ycd0RMRwpp7hosu5gNhe6VFnPOCubrQf2n6fuId8wvKORgPgStKFxdiwCCRAByHHoVqOl9m/s3fnIKHO1U7l5vnECsrH98eI4gHtClsNrXCCG5MZw9YbXfc/hkQUlGnCSb3bsEKbDTh3rIakW1a50I9iHJ7BTeJRYy2v2YNivazXULkOn1DimPKiup3d6w9F1iPwA+5x5XhwNsjwM/4egmehqIJmf7Pe73KpwWxZwgCAjKbVIS37Boc51hnz6StJBpH1fM4VFLKLx5Tb7D4aM0/6DX5WBksSrvE59bnJmU
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
index 5abad90913eb8b0a3aa867cd5a66107bbf96e177..ce64c560e284e1c2ff9d698cf868070ed58ba045 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1342,7 +1342,7 @@ static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
 
 	switch (pgsize) {
 	case PAGE_SIZE:
-		page_table_check_pte_clear(mm, pte);
+		page_table_check_pte_clear(mm, address, pte);
 		break;
 	case PMD_SIZE:
 		page_table_check_pmd_clear(mm, address, pte_pmd(pte));
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index f179970fe47d333565a9199e0991e806aed44346..9af5bfc780800fe2f974daa5329277c46877f848 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -662,7 +662,7 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 {
 	pte_t pte = __pte(atomic_long_xchg((atomic_long_t *)ptep, 0));
 
-	page_table_check_pte_clear(mm, pte);
+	page_table_check_pte_clear(mm, address, pte);
 
 	return pte;
 }
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 5a2b2d3a80d83d8eff2c1a6f69df3e80590c684a..6ec6cf7ad2d4d92da7d3396bc96a5b5902e81576 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1252,7 +1252,7 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
 				       pte_t *ptep)
 {
 	pte_t pte = native_ptep_get_and_clear(ptep);
-	page_table_check_pte_clear(mm, pte);
+	page_table_check_pte_clear(mm, addr, pte);
 	return pte;
 }
 
@@ -1268,7 +1268,7 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
 		 * care about updates and native needs no locking
 		 */
 		pte = native_local_ptep_get_and_clear(ptep);
-		page_table_check_pte_clear(mm, pte);
+		page_table_check_pte_clear(mm, addr, pte);
 	} else {
 		pte = ptep_get_and_clear(mm, addr, ptep);
 	}
diff --git a/include/linux/page_table_check.h b/include/linux/page_table_check.h
index 3973b69ae294e501a9c6c3140bc462d6d9b7d203..12268a32e8be151f66f2787ce87096f10d4fa744 100644
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
index 2d1f7369624c504b531beb8965e7352770a5f4bc..827dca25c0bc77025653f31075ed6913355bda08 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -634,7 +634,7 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 {
 	pte_t pte = ptep_get(ptep);
 	pte_clear(mm, address, ptep);
-	page_table_check_pte_clear(mm, pte);
+	page_table_check_pte_clear(mm, address, pte);
 	return pte;
 }
 #endif
@@ -693,7 +693,7 @@ static inline void ptep_clear(struct mm_struct *mm, unsigned long addr,
 	 * No need for ptep_get_and_clear(): page table check doesn't care about
 	 * any bits that could have been set by HW concurrently.
 	 */
-	page_table_check_pte_clear(mm, pte);
+	page_table_check_pte_clear(mm, addr, pte);
 }
 
 #ifdef CONFIG_GUP_GET_PXX_LOW_HIGH
diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index e8280b0b6dda97ee68bb52593df454665bac9acf..de9e54bd27e6f2bce68304a0b3e99b139f33c313 100644
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
@@ -209,7 +210,7 @@ void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
 	page_table_check_pte_flags(pte);
 
 	for (i = 0; i < nr; i++)
-		__page_table_check_pte_clear(mm, ptep_get(ptep + i));
+		__page_table_check_pte_clear(mm, addr + PAGE_SIZE * i, ptep_get(ptep + i));
 	if (pte_user_accessible_page(pte))
 		page_table_check_set(pte_pfn(pte), nr, pte_write(pte));
 }
@@ -275,7 +276,7 @@ void __page_table_check_pte_clear_range(struct mm_struct *mm,
 		if (WARN_ON(!ptep))
 			return;
 		for (i = 0; i < PTRS_PER_PTE; i++) {
-			__page_table_check_pte_clear(mm, ptep_get(ptep));
+			__page_table_check_pte_clear(mm, addr, ptep_get(ptep));
 			addr += PAGE_SIZE;
 			ptep++;
 		}

-- 
2.52.0


