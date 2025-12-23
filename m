Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B63F1E6B25F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 05:48:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 018BD6B008A; Tue, 23 Dec 2025 00:48:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F25FD6B008C; Tue, 23 Dec 2025 00:48:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE6876B0092; Tue, 23 Dec 2025 00:48:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA9626B008A
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 00:48:54 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6B3511604B3
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 05:48:54 +0000 (UTC)
X-FDA: 84249656988.22.BC1867E
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6826240015
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 05:48:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lccI3o52;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766468932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+a78DMtklkrNbj5wKq84JjELX4bL639or56rrqyDL8M=;
	b=IepXfv7hT7jXM+BxdIs2n8Ad9tQz6E+GReRHCGFRHVyltmeA5+a0QRIzLvgpm6A2Gn4tDA
	RDRxYRVUiB+aSkaa0YJmpoC2uWA6ajk4Zo6VVsY/c6zJOnhdHIOgRMHT6pdLZmfos8xKcc
	dcRzmkjjc7Oc0eEXpA1saQCUzR5jBpw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lccI3o52;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766468932; a=rsa-sha256;
	cv=none;
	b=ddvluLfZN7//Y1cRUSTQSOvAtSEVwuFiTM9UgYMu93o4Uk3mimM9gZmr/oTN9GqTvP1QND
	jMhWio9UjT+WEdDHKeJp0rtKJgG+hyMdMfD1fMjFJeHX9P1saHxlwoG+svyF1jI/IJdrUA
	MNUxsP0lZXHz3GvwMe3av8W4UxDkwKw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766468929; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=+a78DMtklkrNbj5wKq84JjELX4bL639or56rrqyDL8M=;
	b=lccI3o52wq33fTkG6PUxq+hAgd5UzvDf6wJxQy6PMOK+O7RchlrQNVMUGnZFMEpyK/PKoA5Uxv2bwiaxuuLFaVo0kH1gY4D/USksoLiah5Yn5aeoMep+ZGTJsA9w34MNFegvzfj7Pfg9Mt4kRy8lp7PAQXvHV/oeU1kMa8UIhr0=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WvWWGsJ_1766468926 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 23 Dec 2025 13:48:47 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: lorenzo.stoakes@oracle.com,
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
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/5] arm64: mm: factor out the address and ptep alignment into a new helper
Date: Tue, 23 Dec 2025 13:48:36 +0800
Message-ID: <47e29030347c23ffce238ff5ed752da01a8cc7cb.1766455378.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <cover.1766455377.git.baolin.wang@linux.alibaba.com>
References: <cover.1766455377.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6826240015
X-Stat-Signature: 4n6ez8c6enqhmyzm1zhmqhdechgnxqmi
X-Rspam-User: 
X-HE-Tag: 1766468932-440847
X-HE-Meta: U2FsdGVkX18QZL4bNpoxzXR85NjE88Ynj3LFSoob0f5GyToD9NtEM4TYMIJZaQySqjNyOWD5FTbFrkqu0vjFK3dtKrECpnnKWClFr7hv0Ti0BP8cFmBOZ6hWhN9NEGNcOj3QMSIrCjrxUT8UJ7Vn9U01JzvMBqZqIsboSk7zPhFlwlm+lUI+LpL/SGm1M5HkOv/ykujZSvfrQo4lpK8DWRJhbWRN4Ebbt8a/cBQGZCfrkH67r9VZGuc2fwFDgBXq9f5y30Szqkjoh2Mj3YlT01AlhaZQh4FkFtzmxCO5jnNSDtkxCwrPAFog9vdljSIDY1O2vBixeYMzae2niXGBJzlsuSHCsNSqMoZqaT5xkkJDbvw5XE+7PTf0eXhYfwiIie9PQNY+48Iha44+rlQPt1PFHo0dNQQE8oHTaPWVCYDgiW6U1r6SlDESJpqwzxBWo/R2sDFFF+RPIHS+wkCwkzoWhpgynS81jZf9uKnKrSc/vaM0bbZvAO9ktBvSwYuozE9ete+wWwvPRaZJNiQnyNLtvzBaINhw8bY99i6o4q8ZHIgS6e38ksQC2g70TcqgPIIQmtj9iGfut/YSPkrghPZqUDsGl5WG6F8/h/7A9l2ZLswc2pcF/CtO4p6nOLontCvwA5hykwoGhx+aj614aEzwFG1G4idET3HCIhQkZFO/UrOQU+omCMkQP1LjALwwomyHFQxGkw2+69v7DzibT1RBDje/61PAN9tGEWNtuP8jxJTdyLiHkkjjUQ6ERGul8ONl6EGCBVICzsAmy0MECF51dtH9BEnRVln8vZM713qvGIYsEQH2CytOmq0r071FcuQSKOxgSgAZB2GFUVl0BIf4tdX0Qa+P/JNAjr85eBK0MwqaIAN3607oPNY3EBYHMzca5haPai+trsib0RPZ6nq41iSYjKULfBnzvNRh7BuJTL5h20Dnt26pJrvlLz3/FN+k4BbWNRgo/gB0g8L
 QljHuZ5e
 IIA2uZUhohfYe/vBv+EFPtGBMINCLxL1fOTG/4sHkGkXh6D9gQe0BzsDvUCZDplqkml3LksTccFQ+U8ALAI6Srebdng7k9T1V9rLZhB8dzCnWICm7zlRRHjJ6mO6IQAgrC2ik9M4QHgQnCPsg7EnHfeTwsCzFMNOgro4mVSPLlQVwrXxnuiFeSM4K8d0h8auw1rzliAwK0hb1XseC+KeX598tT8Coj1LPjz93049/30GhorOPwszMbypf2UB+9BX2lqPa6fuhI0+o3uNRiRzgWg2xPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Factor out the contpte block's address and ptep alignment into a new helper,
and will be reused in the following patch.

No functional changes.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 arch/arm64/mm/contpte.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
index 589bcf878938..e4ddeb46f25d 100644
--- a/arch/arm64/mm/contpte.c
+++ b/arch/arm64/mm/contpte.c
@@ -26,6 +26,26 @@ static inline pte_t *contpte_align_down(pte_t *ptep)
 	return PTR_ALIGN_DOWN(ptep, sizeof(*ptep) * CONT_PTES);
 }
 
+static inline pte_t *contpte_align_addr_ptep(unsigned long *start,
+					     unsigned long *end, pte_t *ptep,
+					     unsigned int nr)
+{
+	/*
+	 * Note: caller must ensure these nr PTEs are consecutive (present)
+	 * PTEs that map consecutive pages of the same large folio within a
+	 * single VMA and a single page table.
+	 */
+	if (pte_cont(__ptep_get(ptep + nr - 1)))
+		*end = ALIGN(*end, CONT_PTE_SIZE);
+
+	if (pte_cont(__ptep_get(ptep))) {
+		*start = ALIGN_DOWN(*start, CONT_PTE_SIZE);
+		ptep = contpte_align_down(ptep);
+	}
+
+	return ptep;
+}
+
 static void contpte_try_unfold_partial(struct mm_struct *mm, unsigned long addr,
 					pte_t *ptep, unsigned int nr)
 {
@@ -569,14 +589,7 @@ void contpte_clear_young_dirty_ptes(struct vm_area_struct *vma,
 	unsigned long start = addr;
 	unsigned long end = start + nr * PAGE_SIZE;
 
-	if (pte_cont(__ptep_get(ptep + nr - 1)))
-		end = ALIGN(end, CONT_PTE_SIZE);
-
-	if (pte_cont(__ptep_get(ptep))) {
-		start = ALIGN_DOWN(start, CONT_PTE_SIZE);
-		ptep = contpte_align_down(ptep);
-	}
-
+	ptep = contpte_align_addr_ptep(&start, &end, ptep, nr);
 	__clear_young_dirty_ptes(vma, start, ptep, (end - start) / PAGE_SIZE, flags);
 }
 EXPORT_SYMBOL_GPL(contpte_clear_young_dirty_ptes);
-- 
2.47.3


