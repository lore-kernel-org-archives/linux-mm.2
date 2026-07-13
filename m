Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F156AC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:26:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 599BF6B00F7; Mon, 13 Jul 2026 12:26:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 524646B00F9; Mon, 13 Jul 2026 12:26:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 411AE6B00FC; Mon, 13 Jul 2026 12:26:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E584E6B00F7
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:26:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 641F01A018F
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:58:49 +0000 (UTC)
X-FDA: 84983909178.11.8643046
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id D6E021C000C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:58:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hQhsi6oB;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951127;
	b=eOB4EnQMM4ZxDuYCeQP12cGEfe3L0uJZhbaVSDCoke8q7ACDt5jfqkNBqOtNhuMeQ7Ci+i
	DnDnXe/D+7oKYYNK7f7eJiS4wzeV21srTB9bJof7YfciGZ41ZzgP3IN9SMwsm/nUSkIv20
	Jt8Jcrt+osHKdC8wYIdmzph4sDRgIMw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hQhsi6oB;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dZ7Hztpv9AG3ym6rD1iyRftJCr5BqjDTKMYF5vaHn/Y=;
	b=SSGsTqxWbYmbcb4nCV1xyL49LkvOkArq95+y3FkDwZWiSTl5wL0e7cNLVVpSvoXmXZJIxF
	d91RqBah7YjtgBo0V/osbL1b3pmEcsZWzFsCLaKDY1qFSr613d9j6ydZiIkffJqo/DlrF7
	rpoWgnqBzXJz7mVGnw3LZ7eZ8zJ7IMs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 735B8600FC;
	Mon, 13 Jul 2026 13:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36F11F00A3F;
	Mon, 13 Jul 2026 13:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783951127;
	bh=dZ7Hztpv9AG3ym6rD1iyRftJCr5BqjDTKMYF5vaHn/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hQhsi6oB6Dqy2UhzZgl0R7wMwFYoC01nOavo2Gn4P+0kq0kD3Hm545yLLe0+Uqr9+
	 +YgeckSbvOCmw+JICQvQotz/sNpn3oMsz1QqQSCtrX3MUr4nqLFGA82HkQuhIg6iLl
	 zdC1W79HSej4vTNr4wI6ayYd886K+14GcnmxMxQmJBBHYK55SJ1laUK6bUiIDtrJjP
	 HAL8ysVALSqofM0x8r2eZmtB/JTUnV+A0ELxHYbOuLUwMWL6Oc7teoFydLg13VhiOX
	 STDoK6mftNt7g6Rvf/LlFXfMwuSZNbNbNfVVm/Y2pUnvc1poIMN62fESq3zzZl+Qzt
	 SCgZE6BrNge/A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Fernand Sieber <sieberf@amazon.com>,
	Leonard Foerster <foersleo@amazon.de>,
	SeongJae Park <sjpark@amazon.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 3/5] mm/damon/vaddr: drop last same folio access check optimization
Date: Mon, 13 Jul 2026 06:58:34 -0700
Message-ID: <20260713135838.32730-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260713135838.32730-1-sj@kernel.org>
References: <20260713135838.32730-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D6E021C000C
X-Stat-Signature: htsbgs7uysmshxprdouj9eqza5p7u8og
X-HE-Tag: 1783951127-45385
X-HE-Meta: U2FsdGVkX19CcawfcbsbMJr5DBd8lve9mKmgjJRPvPap3GILCDvC2YvAGj0/ooAf5TIOoDwMBLAq9gpt1Rzky9Al7d/yUAPK7qj+7WQQlbyxL2leWVNOsBPk1X68q5p65KEtQNAvebljiVZ/O7iA0gVlbMLyQZxki2/assrScLUoTcaUEcCYCsmMBslZpBNP5SHsGaEAbN7+zzVvtQ/uAvEfm3z790VF9nsMQO//j9HvkB7+1DQSgCvKFmoYaTaY3yrzdhPLxB4GDJS+n35M2wa7IqXft2wou456F3IbUKCysZXZ+a4Bjn3l3l+3iFbRb8evXjZKDM5EnVp7eaGMSMOiM5bTQH2wu2uiG3lLx9+TsYG67tkBebwt4b9sVqYjlJu35Av5Zr8bTTU7rWlRP0tk+KzH1niOWvvy/7T4BfFlRUf9HydLc9Z3+r3AT2Kl7oY1GGj3K0IbgdBjtDXtym4mMu6doX1dmNJjEx8ASFAqmSaWUZi/0IuEs+hjmqL1FwhmEJPJFfWP97Iz09QTIHNzCuHxv1ByVamsnnWouGv345j2nvDxxrslxKTZzmW4UtKDpxuk7Yqd7GZwUFcK2b9dde88SKbwINlywdDljCUdJmpqEDXTh8QYMrld4fqVhTmpj3rXUTuayxMjneMoDefN3LMqzyAQ5jS8oZrWLqmFQt//4wtlPmaG5vLd47mWWSqC0O+acYw8VVQiHi2zkhVFgNFOZvw9/b+X97d7dPo+l8Z1E77PegTgDPQTnBalJ46CAatm6Cwkqy2GIqkW3AZQj8ltX/+HVrpARIB4zj49s/txqN1+lN6AP/kdFG137g8OMOiyHRsZtdFBkRDFTpKrLAFM4VhyQz39qt0SFl45UEyEqJ/1HkRGw3T6fR7Yd5c1epXDVqQEuEN2TeoQiZREnXX4CgOPPJfubnLJQGyqao9PQJbIdvsy1i9pUGiri09F9cJyB6oFwd+idTl
 CThk+E9Y
 7Wdp3XaZHLTZeQAol0hWl4reHR0uuwoZ6x/O/nteVLkP6v6uf0EMIct0OvI/LGVV2YN93JYhQZ3WtyNUiM3frzNwuOvsHgT3e6/3irXg6P9Nz7HbiWe+JFX/rPUyxdxa67WRA7xteAyCvrWU7V26G73YUSAT361vTIJvY9xR4ZTbDEZjSZPb7f3J75IsbVOjKewg9jrrCczW48C/dT+YYK85frj7bpDv/ZgtzxjsfTjno2q8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The optimization can race when multiple kdamonds are running.
Meanwhile, the impact of the optimization is quite doubtful.  Just
remove it.

The user impact of the issue should be quite trivial.  After all, the
race can happen only when the user intentionally setup DAMON in the way.
Even if it happens, it would be rare and only degrade the best-effort
monitoring results.  No critical consequences like kernel panic or
memory corruption happen.

The race possibility was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260621204050.10993-1-sj@kernel.org

Fixes: 3f49584b262c ("mm/damon: implement primitives for the virtual memory address spaces")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 33 ++++++---------------------------
 1 file changed, 6 insertions(+), 27 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index d10b8042adb5b..d487b7a4a1042 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -383,8 +383,6 @@ static void damon_va_prepare_access_checks(struct damon_ctx *ctx)
 }
 
 struct damon_young_walk_private {
-	/* size of the folio for the access checked virtual memory address */
-	unsigned long *folio_sz;
 	bool young;
 };
 
@@ -411,7 +409,6 @@ static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
 					mmu_notifier_test_young(walk->mm,
 						addr))
 			priv->young = true;
-		*priv->folio_sz = HPAGE_PMD_SIZE;
 huge_out:
 		spin_unlock(ptl);
 		return 0;
@@ -430,7 +427,6 @@ static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
 	if (pte_young(ptent) || !folio_test_idle(folio) ||
 			mmu_notifier_test_young(walk->mm, addr))
 		priv->young = true;
-	*priv->folio_sz = folio_size(folio);
 out:
 	pte_unmap_unlock(pte, ptl);
 	return 0;
@@ -458,7 +454,6 @@ static int damon_young_hugetlb_entry(pte_t *pte, unsigned long hmask,
 	if (pte_young(entry) || !folio_test_idle(folio) ||
 	    mmu_notifier_test_young(walk->mm, addr))
 		priv->young = true;
-	*priv->folio_sz = huge_page_size(h);
 
 	folio_put(folio);
 
@@ -470,11 +465,9 @@ static int damon_young_hugetlb_entry(pte_t *pte, unsigned long hmask,
 #define damon_young_hugetlb_entry NULL
 #endif /* CONFIG_HUGETLB_PAGE */
 
-static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
-		unsigned long *folio_sz)
+static bool damon_va_young(struct mm_struct *mm, unsigned long addr)
 {
 	struct damon_young_walk_private arg = {
-		.folio_sz = folio_sz,
 		.young = false,
 	};
 
@@ -494,28 +487,17 @@ static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
  * r	the region to be checked
  */
 static void __damon_va_check_access(struct mm_struct *mm,
-				struct damon_region *r, bool same_target)
+				struct damon_region *r)
 {
-	static unsigned long last_addr;
-	static unsigned long last_folio_sz = PAGE_SIZE;
-	static bool last_accessed;
+	bool accessed;
 
 	if (!mm) {
 		damon_update_region_access_rate(r, false);
 		return;
 	}
 
-	/* If the region is in the last checked page, reuse the result */
-	if (same_target && (ALIGN_DOWN(last_addr, last_folio_sz) ==
-				ALIGN_DOWN(r->sampling_addr, last_folio_sz))) {
-		damon_update_region_access_rate(r, last_accessed);
-		return;
-	}
-
-	last_accessed = damon_va_young(mm, r->sampling_addr, &last_folio_sz);
-	damon_update_region_access_rate(r, last_accessed);
-
-	last_addr = r->sampling_addr;
+	accessed = damon_va_young(mm, r->sampling_addr);
+	damon_update_region_access_rate(r, accessed);
 }
 
 static unsigned int damon_va_check_accesses(struct damon_ctx *ctx)
@@ -524,15 +506,12 @@ static unsigned int damon_va_check_accesses(struct damon_ctx *ctx)
 	struct mm_struct *mm;
 	struct damon_region *r;
 	unsigned int max_nr_accesses = 0;
-	bool same_target;
 
 	damon_for_each_target(t, ctx) {
 		mm = damon_get_mm(t);
-		same_target = false;
 		damon_for_each_region(r, t) {
-			__damon_va_check_access(mm, r, same_target);
+			__damon_va_check_access(mm, r);
 			max_nr_accesses = max(r->nr_accesses, max_nr_accesses);
-			same_target = true;
 		}
 		if (mm)
 			mmput(mm);
-- 
2.47.3

