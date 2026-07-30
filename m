Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16E16C54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDE1E6B00A9; Thu, 30 Jul 2026 05:46:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C64576B00AA; Thu, 30 Jul 2026 05:46:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B073B6B00AB; Thu, 30 Jul 2026 05:46:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84C426B00A9
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:46:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0A715808AE
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:46:34 +0000 (UTC)
X-FDA: 85044963108.21.5663DC4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 332974000D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:46:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GpV0cWpm;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785404792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g8AiR/1XyZ9CQ13tHIFNDOmay6cQWJq+i2qChc+R7Sc=;
	b=wIdMHYh/jDgRhJtcfNF0QW2VkuduyrBtAhQimk7g4A77Jk7Njlaf1lwMXFVffy82xo1pu+
	a7GsjpInH8cy7aDZUtVK3kk3b6xvW7I+hEFIa3oUOObGEFEotg5dnzLecGaxItAIlpAnTN
	BvI/pZRNjprgLhBvuaA7SEGh3p7nX/0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785404792;
	b=NpiIR4lb1//vv3MI+7cuzRyQLfy0dXNHkXEFeV6oEI3zzjwEacXYCvYLXJRFTqF/WaWVwz
	cnEnl4YkcIUnEJ7Tiyte2PV9JhmPdC1Aompvvpvzja5ArsntTjuzoPGgpQiUeWr3qDHXeI
	nuOyDPCcRsA+aPr0PJxjAndFsM1B+XQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GpV0cWpm;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2194F1BCB;
	Thu, 30 Jul 2026 02:46:27 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E9FF93F763;
	Thu, 30 Jul 2026 02:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785404791; bh=DjUOW0zVrgN7JSpC1d7mjvM7Fa6QjKLs5lqVmwJfo1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GpV0cWpmZh+N2ZqJm5YQ5U07NZv8m5wcyBqdsAJKyXjSpzJI0DaxGGLo0pFr9pHXb
	 e5TLWHFOsF0vxtuZf+l2mb320LGBNZtCz3DsXo8ArLYBS9arryJ237B9PLCsQMRR1x
	 uvprB4/+uBnAS57/tlV78ERGV2sqn3A4Qx+GRnII=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v4 3/5] mm/rmap: refactor some code around lazyfree folio unmapping
Date: Thu, 30 Jul 2026 09:45:54 +0000
Message-ID: <20260730094559.418003-4-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260730094559.418003-1-dev.jain@arm.com>
References: <20260730094559.418003-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 332974000D
X-Stat-Signature: e1w1fygjs8bagms3honnnhyteixqk79z
X-Rspam-User: 
X-HE-Tag: 1785404792-540358
X-HE-Meta: U2FsdGVkX1//WbnJQaj4ys7ElGgIptC18MQH5YLT7BQRfcG9lPn9jhjG8Hy2iRh7LOqFJvTc3DClrV/QN9BV5+SVko0vCzJ6lAr4hXdBgMdm5IVquelri7lnz/EG6zRGTZZo8reLdhg+RA7t8D1k6Q9LU24s2RzUCZrHgOurC7pr9NFDPvPqx60Ztsb9mmOGk726fEmukVghGVTGx+HA/q1/o6Rik+Bq8rmUJP47v76YI98oCSS9946v2SNdRdHOeAdbQGcDQKr3edPbjBkGc+9magpycf1f9rgd+tmG99OS3rtgBCb9WI3l28qlqsaIuh5/LpzKBh6H2zKGZeimug/3l67W7UGZQr7OHwQdZmmXFqYtQyltaNe181cfjgqPUt0LmGmgyy/hGEzZW7XYNj8ruEHiYEGgTkzxCglTsZ12XVS+Jq4HppcM1DOHyhmOjrT/l/1rofidc1kpkLtKykMDQTCO497xxQx3WfgFCLjXt6co+jsoFPsX0BffvAF0wgS1MkgyNZYa8HZUCk6eojZ8AFF0GAutyxt+X9/CsjLEQ2xDntQ01b3tai32n6Waz68KbTxBpEqMTS2RHrq2mmHBYhB/aBAveiQMw2TNWOGQjztT1cszY2WjvT+QJo3AQpMMldxw3ZF0vvf7SOB9W1RG9G1zSVBnveOQ9rZWYI1HA2vieyYnvVWx6hLqqB5CMGvsmUlTi9xbBTc9ojiQY6pUhgvozqqjr0hq6YiVgRdgNdgdLjfQ3wum3skBL7D/PboJ3GSR5gy4SztkUZRDpjl32Qx3gOdlkmb7+Um/OfM2+4qltTtU/2zmNZaWn434yMldNsuZ3AZbwEhpQXUnV9LwQklXm4HqICXS+oHYQ/X1SMZ6hyROtx5z3HzAQgTocZgTYw5U/kfitJgSH1Q/lcBslG6XYI7hIQnT92ls9A3dpZJLv12GbGPFpf+No02k/wGFMi3PqOHqfD3wwIX
 Zi9F0DvW
 I/T/TfR1B8scVrvigx3lRsKFicX0UixrAP3nYG80dlhCSD6KUrDeMZeKYd75TqBcLd6IaUUBQoCbDz0ydAXYZTEjnq3q/S7vMXcPC3FV1QBbR4b0ipKmbpdXZnfLVUXIhqTPGXYaVw0rH3phPk024sFd7VrlP9d6RSFDmpCLFV5kjFXLXVPQS8sw8YbZIBg3UMj2JPjdmq/QBt8n7Zk/s+/G03yXyFZ8QvXbDcWAyR5pnb2fjlMeC0JVl7oZsUsgJdU3xvxuIQkEm8P4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For lazyfree folio unmapping, after clearing the ptes we must abort the
operation if the folio got dirtied or it has unexpected references.

Refactor this logic into a function which will return whether we need
to abort or not.

If we abort, we restore the ptes and bail out of try_to_unmap_one.
Otherwise adjust the rss stats of the mm and jump to a label.

Also rename that label from "discard" to "finish_unmap"; the former
is appropriate in the lazyfree context, but the code following the label
is executed for other successful unmap code paths too, so 'discard' does
not sound correct for them.

No functional change intended.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 87 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 48 insertions(+), 39 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 9cb496d7b375..dd1309d72e37 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2068,6 +2068,50 @@ static bool try_to_unmap_poisoned_hugetlb_one(struct folio *folio,
 	return ret;
 }
 
+static bool ttu_anon_lazyfree_folio(struct vm_area_struct *vma,
+		struct folio *folio, unsigned long nr_pages)
+{
+	int ref_count, map_count;
+
+	/*
+	 * Synchronize with gup_pte_range():
+	 * - clear PTE; barrier; read refcount
+	 * - inc refcount; barrier; read PTE
+	 */
+	smp_mb();
+
+	ref_count = folio_ref_count(folio);
+	map_count = folio_mapcount(folio);
+
+	/*
+	 * Order reads for page refcount and dirty flag
+	 * (see comments in __remove_mapping()).
+	 */
+	smp_rmb();
+
+	if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
+		/*
+		 * redirtied either using the page table or a previously
+		 * obtained GUP reference.
+		 */
+		folio_set_swapbacked(folio);
+		return false;
+	}
+
+	/*
+	 * Additional references could be due to GUP or speculative lookups.
+	 * GUP users must mark the folio dirty if there was a modification.
+	 * This folio cannot be reclaimed right now either way, so act just
+	 * like nothing happened. We'll come back here later and detect if the
+	 * folio was dirtied when the additional reference is gone.
+	 */
+	if (ref_count != 1 + map_count)
+		return false;
+
+	add_mm_counter(vma->vm_mm, MM_ANONPAGES, -nr_pages);
+	return true;
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -2261,47 +2305,12 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
 			/* MADV_FREE page check */
 			if (!folio_test_swapbacked(folio)) {
-				int ref_count, map_count;
-
-				/*
-				 * Synchronize with gup_pte_range():
-				 * - clear PTE; barrier; read refcount
-				 * - inc refcount; barrier; read PTE
-				 */
-				smp_mb();
-
-				ref_count = folio_ref_count(folio);
-				map_count = folio_mapcount(folio);
-
-				/*
-				 * Order reads for page refcount and dirty flag
-				 * (see comments in __remove_mapping()).
-				 */
-				smp_rmb();
-
-				if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
-					/*
-					 * redirtied either using the page table or a previously
-					 * obtained GUP reference.
-					 */
-					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
-					folio_set_swapbacked(folio);
-					goto walk_abort;
-				} else if (ref_count != 1 + map_count) {
-					/*
-					 * Additional reference. Could be a GUP reference or any
-					 * speculative reference. GUP users must mark the folio
-					 * dirty if there was a modification. This folio cannot be
-					 * reclaimed right now either way, so act just like nothing
-					 * happened.
-					 * We'll come back here later and detect if the folio was
-					 * dirtied when the additional reference is gone.
-					 */
+				if (!ttu_anon_lazyfree_folio(vma, folio,
+							     nr_pages)) {
 					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
 					goto walk_abort;
 				}
-				add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
-				goto discard;
+				goto finish_unmap;
 			}
 
 			if (folio_dup_swap(folio, subpage) < 0) {
@@ -2359,7 +2368,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
 		}
-discard:
+finish_unmap:
 		folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_drain_local();
-- 
2.43.0


