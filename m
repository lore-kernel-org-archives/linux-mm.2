Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E7C9FD5326
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 09:45:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DED2D6B00A8; Fri, 27 Feb 2026 04:45:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D03FE6B00A7; Fri, 27 Feb 2026 04:45:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B94FC6B00A8; Fri, 27 Feb 2026 04:45:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A827E6B00A6
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 04:45:07 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 701471B760D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:45:07 +0000 (UTC)
X-FDA: 84489753054.04.316CCC4
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf13.hostedemail.com (Postfix) with ESMTP id 41D5120003
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:45:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="V97Tih/e";
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772185504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gb3TnxdXPB7NGEqIRzrILLzcA1IoPG9elueOZ+c741Q=;
	b=Xxiwmq7tGz1nYPexa4hl8fzQ7KDxh1IUfo9k95LpAFJvCX9M7oXzIIeTic0hSqewFBL48V
	JK9DgS+KP1j86cV8EhrDf+4F7xCUF1hOClxoxR8h+YuzHLZrgMp0tBG0qp0UiKnn+uBZji
	vARQ5zUalOK9HiYH/Bg+Dq/SqAPz898=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="V97Tih/e";
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772185504; a=rsa-sha256;
	cv=none;
	b=EHWL4ckxHsTs5CjjTRpiUDtDFpHkj+pwVsFY3BVP4RLKbo1J95JHDfrxwzMxFU54GS8eGn
	HdmLSjSP5wKmMYKE09b39HToKmUbIzrWmAeceZxYVbwVR1UeS78IVaQMo73ToSmt7nDwAu
	QyU/t5sq9XPNHg2SOQUZR9FDIxQLxCo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772185494; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Gb3TnxdXPB7NGEqIRzrILLzcA1IoPG9elueOZ+c741Q=;
	b=V97Tih/eQwSj3+d2+OLUmryZWzdz+3x3Qb/NCLGBeY6TrWixwRsRC2VYvS+C+NjsQbo3DP1arrRte4imGAtB2g+RyORsMyB4O8qdUsScwo9Mla3n8MxEoUnajHqMexVtmDg/SFYW52N/J9N3aLqw8/dn9MCoPCr7+1Mc0lawuOU=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wztvd08_1772185492 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 27 Feb 2026 17:44:53 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	lorenzo.stoakes@oracle.com,
	ryan.roberts@arm.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	willy@infradead.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/6] mm: rename ptep/pmdp_clear_young_notify() to ptep/pmdp_test_and_clear_young_notify()
Date: Fri, 27 Feb 2026 17:44:36 +0800
Message-ID: <283d103c5131e32879bd847263c93b768df64d15.1772185080.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1772185080.git.baolin.wang@linux.alibaba.com>
References: <cover.1772185080.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cd6kmauj453egbfkj9pyphuwn94eu1d6
X-Rspam-User: 
X-Rspamd-Queue-Id: 41D5120003
X-Rspamd-Server: rspam04
X-HE-Tag: 1772185500-348393
X-HE-Meta: U2FsdGVkX18cy2zc9IWvwyeZodFvKXwumqVmIs5vw9p6Ui9qYkVmwzlGVGYsF7jIlTTEsYiRbfwkuNH5VcVm5jzzcvhnpnJkaSRt/suwCb6jZC4zvKtBTjsCFeytmepibmuZ+kHrc+NoA77aZ7i9J0kfu3yD7l91ZSuCR7dUcOZSVbH9xBquRsDvqNkug+QQQwrm+xk/2Rn2WWO2dH48ZriaVtC+5SdY84YFUTLk81vQtB/wSJpGjzOf7S4zn4O9/PCy+bHGmnHhNX4yRwttwn/mm/S8ZHNjOvAKL52Ypxw+VxYnWFrFe4Dhou16Jzz4s6GFHlEAz9HGILQN1FqxDDNmS7s1Wq5A/rKtVDlV5G2CaAYdzUaix9cfqEJZoJFDGNRytVDGv2f56uPb0Rp/LT7ZL2iPf53Keqnw5mn7YHAmBCdziLeXSvH6JJyY7r38gIZoDNtHGjJ2mgbFk2IK0EPf4wuvYaLwVtBeyaUM1ZFEauwfzfP80lXjPFgXxVDxZE7+0i/6B4c4yeNfZkSCIHxNDqfpc1P1jRHJ68UsHeZUeblML594Nsyn5i9CtstI9dbcXxmuWTqKU10EO7g3Puc5/U9JoWFPPM3wdqFcH8k4Zc5tPlj12U13pwlAM1XgQvuTjw57MtgFR/1niKrI9JMaEAaaHsy8WVDUUhCaQO8xCGN2mtKO6xRT3jytZtbmDt6rvTMUGBUiogpjgzVdYH/sXTalApqi7rI9LQ2cxg5gh+A/zXp6tiUPLc38S2dWz6OtQ2xL+CsF3Nt2cONqOpo24fugNNovKvo7qYidepSi8InWjf6BAM8dZmsm7WwUbo1wWIS8avtDCgpWBdx7WrWtdf2A6z2UbUW/08eqhsHfoCaaD9NF9Su/wLJmLBex9vZD7mxsG55HEhe8O2HcFDCTLLIeWSKcZup54D7VzDiW0k0TdvgyDoVZXSQOXfl3hmtV4gSilJzyyVQzKDE
 /RSXW4lN
 YyjnC+alE2zbQaPzS8hsqgQCwqBdbyC16K9iRaLin2Nlcfa5sx3hgjicRDDWZ4jg/VQw/eIJPYoBerSwWJQcOJChAIhlmiMLXDhq4m5SJeBWDB4Ggv+nuzUYSh1fGyNEsjf0R9neI7z0a95RF/NtYC3NXqmGMbI+G1i0JY4hNovVGzqEIrtAxjdA3v1XxJpbCU4LYk6WmKgOg0dm8el8gUf/lHv/aOhOR4p98WsyXd03J6qNVQKi+UXyCqyY780nXJ/nxImQl7mJR7wNaXr2GiVLADxNhHzxZB1TdvGDu/o9LYzbeA8ZOBvx6hWgFp8hq9L/t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rename ptep/pmdp_clear_young_notify() to ptep/pmdp_test_and_clear_young_notify()
to make the function names consistent.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/internal.h | 8 ++++----
 mm/vmscan.c   | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index f27cdad98c1e..af04b177f21f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1814,7 +1814,7 @@ static inline int pmdp_clear_flush_young_notify(struct vm_area_struct *vma,
 	return young;
 }
 
-static inline int ptep_clear_young_notify(struct vm_area_struct *vma,
+static inline int ptep_test_and_clear_young_notify(struct vm_area_struct *vma,
 		unsigned long addr, pte_t *ptep)
 {
 	int young;
@@ -1824,7 +1824,7 @@ static inline int ptep_clear_young_notify(struct vm_area_struct *vma,
 	return young;
 }
 
-static inline int pmdp_clear_young_notify(struct vm_area_struct *vma,
+static inline int pmdp_test_and_clear_young_notify(struct vm_area_struct *vma,
 		unsigned long addr, pmd_t *pmdp)
 {
 	int young;
@@ -1838,8 +1838,8 @@ static inline int pmdp_clear_young_notify(struct vm_area_struct *vma,
 
 #define clear_flush_young_ptes_notify	clear_flush_young_ptes
 #define pmdp_clear_flush_young_notify	pmdp_clear_flush_young
-#define ptep_clear_young_notify	ptep_test_and_clear_young
-#define pmdp_clear_young_notify	pmdp_test_and_clear_young
+#define ptep_test_and_clear_young_notify	ptep_test_and_clear_young
+#define pmdp_test_and_clear_young_notify	pmdp_test_and_clear_young
 
 #endif /* CONFIG_MMU_NOTIFIER */
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6c94e4ecebb2..0a5622420987 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3508,7 +3508,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		if (!folio)
 			continue;
 
-		if (!ptep_clear_young_notify(args->vma, addr, pte + i))
+		if (!ptep_test_and_clear_young_notify(args->vma, addr, pte + i))
 			continue;
 
 		if (last != folio) {
@@ -3599,7 +3599,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 		if (!folio)
 			goto next;
 
-		if (!pmdp_clear_young_notify(vma, addr, pmd + i))
+		if (!pmdp_test_and_clear_young_notify(vma, addr, pmd + i))
 			goto next;
 
 		if (last != folio) {
@@ -4189,7 +4189,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	lockdep_assert_held(pvmw->ptl);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
 
-	if (!ptep_clear_young_notify(vma, addr, pte))
+	if (!ptep_test_and_clear_young_notify(vma, addr, pte))
 		return false;
 
 	if (spin_is_contended(pvmw->ptl))
@@ -4241,7 +4241,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 		if (!folio)
 			continue;
 
-		if (!ptep_clear_young_notify(vma, addr, pte + i))
+		if (!ptep_test_and_clear_young_notify(vma, addr, pte + i))
 			continue;
 
 		if (last != folio) {
-- 
2.47.3


