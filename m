Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 741ADC87FCC
	for <linux-mm@archiver.kernel.org>; Sun, 27 Jul 2025 20:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D5546B0096; Sun, 27 Jul 2025 16:18:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6366F6B0098; Sun, 27 Jul 2025 16:18:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B0926B0099; Sun, 27 Jul 2025 16:18:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3BED76B0096
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 16:18:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 10ACE160C54
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 20:18:27 +0000 (UTC)
X-FDA: 83711157054.05.4A81123
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6D52A40008
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 20:18:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aT6BXn3T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753647505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2kHDN4kYNl6USmgXqL5PJr9STAxKXmuW+g6zq07fD6s=;
	b=FIje8l2KoiNKHddfk5zqI4OYRK9FcWry7CuNX/6iaeRZWrMh4YOZZ0m7xawMENXmmycYOl
	ZOjNC7LpT2TCKsTDHJnpv84Ye+axRUrVt3u0N2T6jZKHF76GpndgsT3T7rR1W73uXLxZpV
	RAArA+XRFpZlMhH9zT/YS1LiN/eifLk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753647505; a=rsa-sha256;
	cv=none;
	b=p5KlJJcuxai7Hrcmu3zInEbXNHRCMUB9fkInyhLZ8q7MF+uwTemNBiyXr6pdz7R0/AqFoQ
	DueY7gTw1sg8fmZPGUWKmhgEopKMLcYYHxHuW0idjWPvO40MkaLD9W1QVf9qYKUS0sqUlQ
	gt2dNB6HlXems2cLHtSAhhq93HUzh7Y=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aT6BXn3T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 054BC601D4;
	Sun, 27 Jul 2025 20:18:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825EFC4CEEF;
	Sun, 27 Jul 2025 20:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753647504;
	bh=7vfSMEb8duHJazLWTg6Sxiv7QWIEANLC0eGbGwST1R8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aT6BXn3T2PxJzZMoAqtXevwqwvD0Gyq31K8qSyDJpYsJ/9k045auIsH81m+Pq3I0T
	 mGDqfFVI8xSzlY1lokpeUO5BQNWc9vO+D1ePRLAw+YRQMZS+Gryv0WDUhsMLM1ZXJ1
	 Fj3/cF6XKn2aVnVameShRV0FG8QojWhHIWn93EWjpmBcWs0w+ndHpcsainsJsai+OS
	 306+GMjumFB/NtmIfSt2NL6fWtMaus7wszDlQeCzUc20CXMiufGzwpF+4GcO/ZSCX6
	 hQ7VvcqfHOg3+VaL1C/J4QiEgG+P3EKoB/OMPNQyST4hu3eK0US4L1lEi/9aJ7BoR/
	 tTmaJkiTB9ugg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC v2 6/7] mm/damon: implement paddr_fault operations set
Date: Sun, 27 Jul 2025 13:18:12 -0700
Message-Id: <20250727201813.53858-7-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250727201813.53858-1-sj@kernel.org>
References: <20250727201813.53858-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3dm3k9dz7b9bozsy8ccmyjc3ohzse5yu
X-Rspamd-Queue-Id: 6D52A40008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753647505-546736
X-HE-Meta: U2FsdGVkX18r6hcn8UixzD2wPI2NFUNOVtmO9TZPC+D9jsWWeI9YcMjyDSfxciIWXd7KLNfAnrfsGjzhjosc6C4jaQefHWKzcUUWr8phUuC4J4AasF3vk6UeB8r1OoBGM8sDFU7Mk8T9xbDgZTJ7Oy4HhFpqd2cUYhc1eweU4FuTXomDbqM5oQlW44tS+Y96LVD8IyZGdwVKPPaSbn6d+MmfeWAdBLcsRvC7mgdFgQylJAEiNTURjERCaa3X1L7b8d7fTn8yiMHgfVXMm7roFfDE3I1owd/YWyiV5/B5jMltPilP2yuyeLFctMrciKaLmxIIlXbzUBuz4k56HJ+6Ncw4gOKPMdom8jxokcZpSg9mDBND3qFn3KXD8gugrox98eBhk92r/4cUl8XQP9WVBfWQGl9eHsg9YzAjX8rAyeOwsv/kxS/2EuLll6WMoZ10I9RY/IVnHGE2vw0ewEN+tj+aUbPg/IeDMX+ClAAOGRcN3EcD8bcYUk9a3oRb3BEXMtJU3uDc3ETJPDlcyo29sEePkAhNcD3ar4UuaWaCAgJgjHfUXOAAi4b8EW7C+PTRR96VN5qOpUiVb9E5NiPbSbykydsE/k0uGgXsjp/Uu9GY2OWOOkYiVQpbJQo6FNSwzjVEDW3pu6Wk+ahbLtOyG8eHo5IExQSpvhGkrP2OO0GYtVbFRY32pfZXn09zKdirUB6dnGOjWC7UhPaF/z5AeKDn8KctWCoKEza6oxALorljD1TG+C4PLuy0mCJrjMqKuhA6KC49MMaJMoAEhqeoGSDNDeW88csuH3edo2Hb+lisKhXhvye2tbucfZePymugXTkznPON42AiXvSJ5uevEPzXw0a5I4elkqZ6dNCmr8xE5CNgzvTedXdD8uCipVogzStdfSwl+FcMy/PhGQTmXnthriQPJVX+r0lDdnhW7Ed8TL39/AX0vXVrBVUNfsxtmtA4zzyXPgOzi3S+9Jg
 Drsha041
 4Wk+YfNUpjeRUsyTY7j0leV6k4r8GbsRIvicMZYG2zG1NfxSpmtDsrcJQsxvHgYxYwWjY3aIDhpRAeSXxHLe+vxVUT8ikO/Ez4NUN32s5QOCWEvNL5nhUwDCncDS9BhSQYBJe6sdXdVWSOr/795fKq4101gHzIAyPCQkrSVYXiebj9okq2Nn7dYLaIlyuYuschlJhcFcKsfWSTjykhqdvDeVW7Mj5Sy9PvwPQiRVUOxY9qECmmT/g8Z0QbMi3B1x297Iy9Xov24pUkSYmBrA6TUcLHOR4VYdnxPLTbEQVHYF+v+FiqUXmhOtpuCiYKsWBzQAWaKp/5q9y8UsUfzCyb58i0g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement an example damon_report_access() based DAMON operations set,
paddr_fault.  It monitors the physical address space accesses, same to
paddr.  Only one difference is that it uses page faults as its access
information source, using damon_report_access() and MM_CP_DAMON based
mechanisms.

This is not to be merged into the mainline as-is, but only for giving an
example of how damon_report_access() based operation sets can be
implemented and extended.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  3 ++
 mm/damon/paddr.c      | 77 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 79 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 8ec49beac573..c35ed89371d0 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -574,12 +574,15 @@ struct damos {
  * @DAMON_OPS_FVADDR:	Monitoring operations for only fixed ranges of virtual
  *			address spaces
  * @DAMON_OPS_PADDR:	Monitoring operations for the physical address space
+ * @DAMON_OPS_PADDR_FULAT:	Monitoring operations for the physical address
+ *				space, using page faults as the source
  * @NR_DAMON_OPS:	Number of monitoring operations implementations
  */
 enum damon_ops_id {
 	DAMON_OPS_VADDR,
 	DAMON_OPS_FVADDR,
 	DAMON_OPS_PADDR,
+	DAMON_OPS_PADDR_FAULT,
 	NR_DAMON_OPS,
 };
 
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 53a55c5114fb..68c309ad1aa4 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -14,6 +14,7 @@
 #include <linux/swap.h>
 #include <linux/memory-tiers.h>
 #include <linux/mm_inline.h>
+#include <asm/tlb.h>
 
 #include "../internal.h"
 #include "ops-common.h"
@@ -97,6 +98,65 @@ static unsigned int damon_pa_check_accesses(struct damon_ctx *ctx)
 	return max_nr_accesses;
 }
 
+static bool damon_pa_fault_change_protection_one(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long addr, void *arg)
+{
+	/* todo: batch or remove tlb flushing */
+	struct mmu_gather tlb;
+
+	if (!vma_is_accessible(vma))
+		return true;
+
+	tlb_gather_mmu(&tlb, vma->vm_mm);
+
+	change_protection(&tlb, vma, addr, addr + PAGE_SIZE, MM_CP_DAMON);
+
+	tlb_finish_mmu(&tlb);
+	return true;
+}
+
+static void damon_pa_fault_change_protection(unsigned long paddr)
+{
+	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
+	struct rmap_walk_control rwc = {
+		.rmap_one = damon_pa_fault_change_protection_one,
+		.anon_lock = folio_lock_anon_vma_read,
+	};
+	bool need_lock;
+
+	if (!folio)
+		return;
+	if (!folio_mapped(folio) || !folio_raw_mapping(folio))
+		return;
+
+	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
+	if (need_lock && !folio_trylock(folio))
+		return;
+
+	rmap_walk(folio, &rwc);
+
+	if (need_lock)
+		folio_unlock(folio);
+}
+
+static void __damon_pa_fault_prepare_access_check(struct damon_region *r)
+{
+	r->sampling_addr = damon_rand(r->ar.start, r->ar.end);
+
+	damon_pa_fault_change_protection(r->sampling_addr);
+}
+
+static void damon_pa_fault_prepare_access_checks(struct damon_ctx *ctx)
+{
+	struct damon_target *t;
+	struct damon_region *r;
+
+	damon_for_each_target(t, ctx) {
+		damon_for_each_region(r, t)
+			__damon_pa_fault_prepare_access_check(r);
+	}
+}
+
 /*
  * damos_pa_filter_out - Return true if the page should be filtered out.
  */
@@ -355,8 +415,23 @@ static int __init damon_pa_initcall(void)
 		.apply_scheme = damon_pa_apply_scheme,
 		.get_scheme_score = damon_pa_scheme_score,
 	};
+	struct damon_operations fault_ops = {
+		.id = DAMON_OPS_PADDR_FAULT,
+		.init = NULL,
+		.update = NULL,
+		.prepare_access_checks = damon_pa_fault_prepare_access_checks,
+		.check_accesses = NULL,
+		.target_valid = NULL,
+		.cleanup = NULL,
+		.apply_scheme = damon_pa_apply_scheme,
+		.get_scheme_score = damon_pa_scheme_score,
+	};
+	int err;
 
-	return damon_register_ops(&ops);
+	err = damon_register_ops(&ops);
+	if (err)
+		return err;
+	return damon_register_ops(&fault_ops);
 };
 
 subsys_initcall(damon_pa_initcall);
-- 
2.39.5

