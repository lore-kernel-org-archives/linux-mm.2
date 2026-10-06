Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37812CA5FFC
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 06:52:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E77D26B0092; Tue,  6 Oct 2026 02:52:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E28726B0093; Tue,  6 Oct 2026 02:52:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3F366B0095; Tue,  6 Oct 2026 02:52:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3D546B0092
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 02:52:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2DA20A76D4
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:52:22 +0000 (UTC)
X-FDA: 85291282524.23.D115C28
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9AB25C0004
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:52:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FA6B6DDd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791269540;
	b=A8z8HIxnhnAFi07fB1O4ylLmAtgsnEwegXqASDXrFJKiZYjNPAgbVrgl65BtbGhjlez2mT
	tcfRAiVYk0SP5Q2ZGxF9whg4JTXEDmU/pdcJ2DVZhXw4aFhgkZTxCXIxSZhz3YnvdbvZfV
	MdkkiyZQ78GgfbVWFiJAtkoJpo+xR3c=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FA6B6DDd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791269540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rjEiceRfwihVxvjUsA6PydjZA8ZEeM2KvlKASHa3zWY=;
	b=HcBw0PZWybz7OHNgQXJfTQ/U2pQ02jiZkdgkVF6LC0naQnet0Py694kLT3gjgPMv4tOsj5
	+TpbCuljB73/+IaYQ+ACPqX4B67zgQSjzh5GeUIgPetndRqcXQgkqdTpWJ2E/l3aNCiVc0
	EIPKqCaMRRQ6bh4V4WkzBWINvwve/2Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3DAC26057A;
	Tue,  6 Oct 2026 06:52:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C761F000FF;
	Tue,  6 Oct 2026 06:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791269540;
	bh=rjEiceRfwihVxvjUsA6PydjZA8ZEeM2KvlKASHa3zWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FA6B6DDdGbXCE4uDg89PIIdqfeKxPGTGxV1RGHAlFJnKB6ymf04I3VPPi7qXxVh6b
	 74rJxhhHcb8IP5rq0ZSrk766NYCBEyRz+uYEWunjHJ+cswbrKLr3huOPg6oBMWymvO
	 s5clc2JeRA2bf2ipKRQrqZUEcADoq6o8BcjN+NLv4zw7bPwvMbNG+lx1FP5OPAWK8b
	 LpIvhNwdTh+WoPIlJ/ww5XhCiCJUcPUCmRCg7XWkR8sPSFl4eCMHRceV9UcjKasI8B
	 zmdSyavm4kMhm/OX7/TiyR3AUvW0IDpOMQezoqNL/CjW1FAAwJDVF5u9l+5Lh4Fu01
	 I+4dsu1jk6ENg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gregory Price <gourry@gourry.net>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/3] mm/damon: use damon_get_monitor_folio() for hugetlb entries
Date: Mon,  5 Oct 2026 23:52:06 -0700
Message-ID: <20261006065209.41507-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261006065209.41507-1-sj@kernel.org>
References: <20261006065209.41507-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tk9tqcfykqms1qbhqsweboo4yta69a5e
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9AB25C0004
X-HE-Tag: 1791269540-676432
X-HE-Meta: U2FsdGVkX1+ruHqiTI5xi1lu5tmpoqqeQfDaYo5KfKSge/HMtFGLvyfs4Qws/kDjSIpDglh5P6WS1KgyKGieOyyzZw5LJQkKrqhO4CNSDgfeHEpk4K/TRZB0d2N6QC5rKr0+SeQhROs2PxNVvNPcxnH6jgq3y8ELu2UsRY1WbfaD7KsvlX3eEJD3oJMD3FKhR23myj6A3JGuGPqILdLiT7fImFWSWCXNvfScAcAWFZxVBWbRr7GUfo9thgOARBfwgU+bkVKTDI6wu9LNzPu4tVGGKoIOwWAWKqLyY/xXxVecVBE/tStCLqu6Br/o3NX0tBthmjHW14Cc556TT2G6q1vux1byCzqLjaIxJgB9bT5MqS9pXChu3cVhK7bzdjIEV8njpbvJ8zR+knM+XzMg0/6ITgqtMqWAEn41GTYEewHndYB4HtlbfYxVJFRLI7oGCmqmN4/8+cBMws6+zp8l26xDxyJQsxk1+GrjvgZa0oOZDHJU59VUdHloB39sY1iOPeq4G7pSMquQtcK24eVqskEF+b1Zk+VowTBWk0kLuF8XRIzQ4r4MRYmmYPrVPqcFrwBFxr6u9ePdU1LgGSCTD4qeQ1E3fjrWvJsC6k5wohFUqLQWu1HLCDiqtwMZx7SOda9ktbXx41pM4irRoAzE+q+Cl/uBJqZCwG35aMPTPhPUH3vvk6Zmy0NZF99zAKjBEinm3bnIN3swkDOGiA1syZWqBAAQ0zK//8zQlMyzqkbd5LttSnI6m6Jd0QMFv1acRkIbWN3AtJT2+C/p3U5E+Yw17ccEy+QHtekbDkUDJOp+26sTwvSZp+TZLfFYglgKzdi6A0+uuHoP2J5YrUhQcwkXw1Y9+0+DzsY+RShsAWJdigb6Jf41KydboO7YKhHEgXSzS2vkq2Ap3Yyh5K4QXPmhQ9LRLs/rDx/miLMrMgctWfU9afkwQef758OvPvW5fPiZwGOAbQDjxPB0WIA
 LWeqEVAp
 dN5apwmTIO+jG+C4HjZBeB8Fqt+vhquywpqgPK9NLY+XuXSjUkce391m6oI1lyQd8ilLqCNkRGvJnhwFveQtaTWliBQb9JBT2IUNqGu6GI0fbGz/YDFPFnoD4clt4r/sLi3qkYIednuxeUoQxjDYFJgjKz/QyWI5zkUQHSFo/c0TLRMKHwp3TaEbt8zrNDn+Qn4VhyFEVUB/J8yHpg1NWBw+YlUd/evPEjgUFReRBR9BIrjaJ8RGWez71l5JjxWsZiuTY0aly2/ddQPT+0v/uV2xtwcRg+cNmBxn+Ge23uQXCvVR3foPCYl4WVOtWvSDQAgVjNpLJChF9WFwN6zkbikOp3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Gregory Price <gourry@gourry.net>

Hugetlb folio acquisition is open-coded in three places:
  - damon_hugetlb_mkold()
  - damon_young_hugetlb_entry()
  - damon_va_probe_hugetlb_entry()

DAMON already has damon_get_monitor_folio(), which paddr uses to
get monitored LRU and hugetlb folios and to filter them through
damon_folio_acceptable().  These paths bypass that check.

Use that helper in these paths too, so that DAMON acquires hugetlb
folios and applies its acceptance policy in one place.

No functional change intended. All callers reach these paths with a
present hugetlb PTE under the page table lock, so the folio is always
a mapped hugetlb folio and the helper always returns it.

Cc: Gregory Price <gourry@gourry.net>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20261002140727.701709-1-gourry@gourry.net
- Collect R-b: from SJ.
- Rebase to the latest mm-new.

 mm/damon/ops-common.c |  6 ++++--
 mm/damon/vaddr.c      | 10 ++++++----
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 7a7429359dc8..2f3bf86a221b 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -140,9 +140,11 @@ void damon_hugetlb_mkold(pte_t *pte, struct mm_struct *mm,
 {
 	bool referenced = false;
 	pte_t entry = huge_ptep_get(mm, addr, pte);
-	struct folio *folio = pfn_folio(pte_pfn(entry));
+	struct folio *folio;
 
-	folio_get(folio);
+	folio = damon_get_monitor_folio(pte_pfn(entry));
+	if (!folio)
+		return;
 
 	referenced = damon_hugetlb_ptep_mkold(pte, mm, vma, addr, &entry);
 	if (mmu_notifier_clear_young(mm, addr,
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index d5dde97b3cd0..b549496ea8e2 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -411,8 +411,9 @@ static int damon_young_hugetlb_entry(pte_t *pte, unsigned long hmask,
 	if (!pte_present(entry))
 		goto out;
 
-	folio = pfn_folio(pte_pfn(entry));
-	folio_get(folio);
+	folio = damon_get_monitor_folio(pte_pfn(entry));
+	if (!folio)
+		goto out;
 
 	if (pte_young(entry) || !folio_test_idle(folio) ||
 	    mmu_notifier_test_young(walk->mm, addr))
@@ -660,8 +661,9 @@ static int damon_va_probe_hugetlb_entry(pte_t *pte, unsigned long hmask,
 	if (!pte_present(entry))
 		goto out;
 
-	folio = pfn_folio(pte_pfn(entry));
-	folio_get(folio);
+	folio = damon_get_monitor_folio(pte_pfn(entry));
+	if (!folio)
+		goto out;
 	damon_va_probe_folio(priv->ctx, priv->r, folio, &entry, NULL,
 			walk->vma->vm_mm);
 	folio_put(folio);
-- 
2.47.3

