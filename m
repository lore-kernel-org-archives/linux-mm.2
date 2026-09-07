Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F635C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 18:13:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86F716B00A4; Mon,  7 Sep 2026 14:12:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 780806B00A1; Mon,  7 Sep 2026 14:12:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 473A46B00A2; Mon,  7 Sep 2026 14:12:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 178AD6B00A0
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:12:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A15D160266
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:21 +0000 (UTC)
X-FDA: 85187760882.08.18DD656
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 800E0C000F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kLQ/9gyb";
	spf=pass (imf10.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788804739;
	b=ICg5HBi4qdUSUQMgR6PnKi+PmrIzI9lpvzvdZLDxrfFg6eRTpDJPZRcofkSLdjp9/d5FjV
	QacsKijPyCm0Zjfb8EviXW2YIhSMYodKbDN5HRsq2jofiD3MX5kUj60d/sFuv29AsMH5bq
	zYkjLOop2LmCRJcbaRFdQ1jaCKJe2NA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788804739;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eEPdqV+CdkDucBzALf7Kj9NoutWt1knDBX08AoJmDt0=;
	b=iteeTwPBODue4cWDH7OOrQe99gI0kOoNkbCjrKUCOErDqPcQSsWXL7HpiFKuNAl5/CHy1s
	9U4GdMPzugSrMItmHpFGd8Vw6rB7TrRv1TSFrOwia6WJMBgeyHwCI4Mm7Yu7GNBIY7hJyX
	KUFfC4iAiNNdRHfMgHVCsbmlkkhPeNc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kLQ/9gyb";
	spf=pass (imf10.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D34CE43750;
	Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B5B3CC2BCFF;
	Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788804736;
	bh=I+u+i0OhFDYXj2sOqSO0jh8o9wLuzioiM46T0DNhMxY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=kLQ/9gybOIgpNAOdvEuIotJ4XzANmeSDRFv8eKBkyPd0ogwiXBS9Uw4jmdo8RuAZC
	 GEa1E+xXHN9R4e3eFXi7o9oxGoMjoct9ExxILR6s2SnV8l5SdB9rUyhEY/XPDFFDub
	 wOOaaGoXLVdZMXu69XIP7cXEWRUxTX3i+KT3GFYmdHrdkcjiu5rTQLdbcFQOscDdBo
	 d1eVgN0C+YwFgwhusBYTyDmA4Mq2mjZbVJDrfYNDrCxWWJrJ9PiZa9BaBU1y7uub+V
	 ypYy+YtLF96QNViswrOaqiyOoBpHqkjtJB1tak8phhbBbthpDb8PkAlVJcHsWFKdwi
	 AHVPg1HrVXYiw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0640C79F9F;
	Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 08 Sep 2026 02:12:15 +0800
Subject: [PATCH v4 11/17] mm/huge_memory: move filemap management into the
 file split helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-swap-thp-cleanup-v4-11-b532a3f20e71@tencent.com>
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
In-Reply-To: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788804732; l=6255;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=vVlYGjPyxYAYmn821pQL1VWkwmnGIaxktKpsOp5j70I=;
 b=h4Qkg+uChtRz/caeznumouNlo2l0UEj+Q2LMUaWSS9ZV0h+sAcMuQo9rAMjROhgWQJgv8Dp/G
 RKH9/kdQNRXCl9ekDK+BxBA1TodPkFP8OKVALZoBywEdV1SKjNB9iXm
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 800E0C000F
X-Stat-Signature: wzxoeous8mt8thcts4wy3sarifm7zycw
X-HE-Tag: 1788804739-768668
X-HE-Meta: U2FsdGVkX19elamQIfIsp+eN23Bs8IySmmsVLDWsO4Q6m8ljDnvx8InEo1GVhjl/3QhxV4EjtzIyxqXB58sADK12HHwOZ/m8T7+ZAxM8dpRs5TymNjh67jVddT+m5c3WAAmVpCNZWNmFbfgxliGGIoOu6TFdZGdxqPvx5vkE9k7JgJ1ieOu/T3jwYEPvF6DqEOpwF2Rdt7/bYEQAUU0Db77tKXoFG7Pec6XBcX5ZG/ZpoCUeULgM+dCmu94FhKdmXsDfOmK/oDRoDrKhs1ndfIFCB4rykDNr9li6hHxFjUg34lR4xzK+iuvXpef0kJsO0SnAG9uFQvNyiexI54117S/JNHztFtEI9lpI4gJFlr+5G9I/rVpmscn/r4jCh1qEcAoSThMRJmDti8qcILf25P8f51p4qnyTrCgfBa+XNmpbO5Vh1R6OlPp6Z5WSCSd6+OKQAhNTsnwRy+pPbJZir/QjQsAp4lid0QYVSGEthipFHrlnFtgnj2+Lxqz8v706awew9vwzeOFckYlYjdNlXZUsWshnUdN3Q/7S8aaVPIDvEpC0C6w+Iv/bhuFzBjtrOcg579z1npJch3gx9DU2R7UTu1Yb8Pbl3EQh09GK6g1/uzpVURGdvmLKditA6q85/TlfaPKeyBQmpqgl0cyIHEwP8bkX+/c4OuS5XHI1AgsoTuyVjbWHhtMTB04di60aBTQTmg7Cke1UnanPhJE4s6wRGKlsh9tX0EufHgBFfBG2kzUOdT8Zw1Zx/qO1zyYM8xBtGRj2iCGOuw9ZwVchbeMAolpfnbNdgVBEF4j/ovLtcgimd3x3grnkuJLNVc7g6ALlexuhXqQW0WEtxaYs/4zjTWJhMLeNqtP5PgS/lB/cNthk3jkOIiZR9detbuDMjSG6FdEs8vpFDI6D0KkdqrPczOtAT33+IKH/fW00amvVJT/o9diV4zHz1Jrz1JWNoYDoDsqRc/fHbVq5fI8
 4G9ihQw6
 CL7boy+0anFcawb47/Yl2ZUPgh7UkXezjRCXR2GoybU9eQG3FqgmjiUChsAEt78oVPIVBgIeDG0pJlXq1hi02FMGrLqQwkQEWLKFIF77QvEEjS8svWOE7BV9LdwUGhosbHxQ62Y4t40LYbI/vmH/3Esx1j42dsYsc3WSMoy7BXjMSzHJSIxFIRlFpcAOwg8vYdwkelx2W5H4yn8OKaFoED7vwkPLoko4ehQJTfoRxV4V/aBxyEDON02krYN0EyRTmHsOcK2+amxx0X5dUkOICaTDssdyrjg9K7FMPUhaujw5GFO7czHcB/4GymHCyM+HukoETnBVriAWB8NHR1kqO9A6Q3+VXmvmtQsaHAvNCr2QyLFHZiLyj609hRSZKPTojzNyetcDxa0bsM5xSFV6HBgEoR3tD61zG4NEsgimJAezS/r0UIIYHZ9pR4iwgdIN8ZS1gJSSOJFQDg0o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Only file split needs the filemap and xarray handling and related
variables.  Move them out of __folio_split() into the file helper so
the helper is self-contained, and simplify the parameters.

No functional change.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 102 ++++++++++++++++++++++++-------------------------------
 1 file changed, 44 insertions(+), 58 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 17bd2c053210..c4910c0b6018 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4087,16 +4087,42 @@ static int __folio_freeze_split_anon(struct folio *folio,
 
 static int __folio_freeze_split_file(struct folio *folio,
 		unsigned int new_order, struct page *split_at,
-		struct xa_state *xas, struct address_space *mapping,
 		bool do_lru, struct list_head *list,
 		enum split_type split_type)
 {
+	struct address_space *mapping = folio->mapping;
+	XA_STATE(xas, &mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
+	unsigned int min_order;
 	struct lruvec *lruvec;
 	pgoff_t end;
-	int ret;
+	gfp_t gfp;
+	int ret = 0;
+
+	min_order = mapping_min_folio_order(mapping);
+	if (new_order < min_order)
+		return -EINVAL;
+
+	gfp = current_gfp_context(mapping_gfp_mask(mapping) & GFP_RECLAIM_MASK);
+	if (!filemap_release_folio(folio, gfp))
+		return -EBUSY;
+
+	mapping_set_update(&xas, mapping);
+
+	if (split_type == SPLIT_TYPE_UNIFORM) {
+		int old_order = folio_order(folio);
+
+		xas_set_order(&xas, folio->index, new_order);
+		xas_split_alloc(&xas, folio, old_order, gfp);
+		if (xas_error(&xas)) {
+			ret = xas_error(&xas);
+			goto fail_free;
+		}
+	}
+
+	i_mmap_lock_read(mapping);
 
 	/* Currently device private folios can only back anonymous memory. */
 	VM_WARN_ON_ONCE_FOLIO(folio_is_device_private(folio), folio);
@@ -4114,15 +4140,15 @@ static int __folio_freeze_split_file(struct folio *folio,
 
 	ret = unmap_folio(folio);
 	if (ret)
-		return ret;
+		goto fail_mmap_unlock;
 
-	xas_lock_irq(xas);
+	xas_lock_irq(&xas);
 
 	/*
 	 * Check if the folio is present in page cache.
 	 * We assume all tail are present too, if folio is there.
 	 */
-	if (xas_load(xas) != folio) {
+	if (xas_load(&xas) != folio) {
 		ret = -EAGAIN;
 		goto fail;
 	}
@@ -4149,7 +4175,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 	if (do_lru)
 		lruvec = folio_lruvec_lock(folio);
 
-	ret = __split_frozen_folio(folio, new_order, split_at, xas,
+	ret = __split_frozen_folio(folio, new_order, split_at, &xas,
 				   mapping, split_type);
 
 	/*
@@ -4205,9 +4231,19 @@ static int __folio_freeze_split_file(struct folio *folio,
 	 * If we want to use try_to_migrate() on file in unmap_folio,
 	 * remember to add remap_folio() and adapt it.
 	 */
-	xas_unlock_irq(xas);
+	xas_unlock_irq(&xas);
+fail_mmap_unlock:
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
+	/*
+	 * Drop the mapping while the inode is still pinned. @folio stays
+	 * locked and present in the page cache, so eviction cannot free
+	 * the inode yet, nothing past this point may touch the inode or
+	 * the mapping.
+	 */
+	i_mmap_unlock_read(mapping);
+fail_free:
+	xas_destroy(&xas);
 	return ret;
 }
 
@@ -4236,11 +4272,9 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct page *lock_at,
 		struct list_head *list, enum split_type split_type)
 {
-	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
 	bool is_anon = folio_test_anon(folio);
 	struct mem_cgroup *memcg, *old_memcg;
-	struct address_space *mapping = NULL;
 	struct anon_vma *anon_vma = NULL;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
@@ -4287,60 +4321,15 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			goto out;
 		}
 		anon_vma_lock_write(anon_vma);
-		mapping = NULL;
-	} else {
-		unsigned int min_order;
-		gfp_t gfp;
-
-		mapping = folio->mapping;
-		min_order = mapping_min_folio_order(mapping);
-		if (new_order < min_order) {
-			ret = -EINVAL;
-			goto out;
-		}
-
-		gfp = current_gfp_context(mapping_gfp_mask(mapping) &
-							GFP_RECLAIM_MASK);
-
-		if (!filemap_release_folio(folio, gfp)) {
-			ret = -EBUSY;
-			goto out;
-		}
-
-		mapping_set_update(&xas, mapping);
-
-		if (split_type == SPLIT_TYPE_UNIFORM) {
-			xas_set_order(&xas, folio->index, new_order);
-			xas_split_alloc(&xas, folio, old_order, gfp);
-			if (xas_error(&xas)) {
-				ret = xas_error(&xas);
-				goto out;
-			}
-		}
-
-		anon_vma = NULL;
-		i_mmap_lock_read(mapping);
 	}
 
 	if (is_anon)
 		ret = __folio_freeze_split_anon(folio, new_order, split_at,
 						true, list, split_type);
 	else
-		ret = __folio_freeze_split_file(folio, new_order, split_at, &xas, mapping,
+		ret = __folio_freeze_split_file(folio, new_order, split_at,
 						true, list, split_type);
 
-	/*
-	 * Drop the mapping while the inode is still pinned. @folio stays
-	 * locked and present in the page cache until the loop below, so
-	 * eviction cannot free the inode yet; @lock_at is not enough, it may
-	 * be a tail beyond EOF that the split already dropped from the page
-	 * cache. Nothing past this point may touch the inode or the mapping.
-	 */
-	if (mapping) {
-		i_mmap_unlock_read(mapping);
-		mapping = NULL;
-	}
-
 	/*
 	 * Unlock all after-split folios except the one containing
 	 * @lock_at page. If @folio is not split, it will be kept locked.
@@ -4364,14 +4353,11 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		anon_vma_unlock_write(anon_vma);
 		put_anon_vma(anon_vma);
 	}
-	if (mapping)
-		i_mmap_unlock_read(mapping);
 out:
 	/* restore to caller's old_memcg */
 	set_active_memcg(old_memcg);
 	mem_cgroup_put(memcg);
 out_no_memcg:
-	xas_destroy(&xas);
 	if (is_pmd_order(old_order))
 		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
 	count_mthp_stat(old_order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);

-- 
2.55.0



