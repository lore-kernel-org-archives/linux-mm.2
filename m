Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71511C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 18:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF7396B00A9; Thu, 20 Aug 2026 14:55:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C814C6B00AC; Thu, 20 Aug 2026 14:55:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99A206B00AB; Thu, 20 Aug 2026 14:55:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C2856B00A2
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:55:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 840C41A0285
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:33 +0000 (UTC)
X-FDA: 85122551346.09.55F75F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8E1202000D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cx1vGRL8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787252131;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KEhBeWEtgE1/q9fIGnyyc27x5LcaHTjyYD57ISbczVM=;
	b=RF61gRVnsEMuokvE2UUvLwwyWW9iMZVWgOIcdKOOgYBfjq87DYU/xjygu2N+rSjPc1SgOV
	1v1i5kJf4ts/ddNo/I65jCP2NfQencJUK4xtqymbH7iRKN52pd7724axtQ+J2YUt+JUrZK
	9LE3ga4PZ54BGylR36oUY+rFoYfcTE4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cx1vGRL8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787252131;
	b=Ig2Tc99HSrPLKiBGViJoLp2le6AvNvBOS7vUvbzAEY3zS1Xfd7Hb1IvBMMcjKfvS43aPeL
	qr4+XM76XYHv1Ja5j1ZnOVdE6uFpnD59zphmm3NUeAx6Ipo94bUlVx8f8puWEcp8h8Rwcs
	bivOiSYMzpoUYG+Xbk50H74l1w82pVc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DA89244F2A;
	Thu, 20 Aug 2026 18:55:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BBAE1C2BCFC;
	Thu, 20 Aug 2026 18:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787252128;
	bh=57wY1JKmm5GvWQDkOulo9aLZpUhYxYqy/jAD/p/XA+Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Cx1vGRL8tqiZln75bx1A6wQ0a58ahsbe7w8B1a1F//uvW41pqpy+cUACDh2U7VSa+
	 vAJSewArCM+XRKn+68JDn9ivj/n+XDhu8LQXWvbx+ajbyklUwu/x8VjsHGwn5XBUom
	 0LoCBRkFauwH2h5UY5muEfViUwMvK2JTdB9CLsLdJ13w6uluoMjYNupYp5+SxJ6mJj
	 o+Z2yj1T49AWcvxPRi7LutHb0CwqyqLt5RAO3beszVZMTukq8JhnoW9AT3LZHOM+v7
	 gxXaRaxlq9OFcrC7+wnjUm05fymGZP5SmW3UJ04in2d1CpOU9aZVKiw5gkJZql/gwY
	 X8ZAB7XaiZ5Uw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A133C5DF85;
	Thu, 20 Aug 2026 18:55:28 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 21 Aug 2026 02:55:21 +0800
Subject: [PATCH v3 08/18] mm/huge_memory: move unmap and remap into the
 split helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-swap-thp-cleanup-v3-8-9b43f5163238@tencent.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
In-Reply-To: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
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
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787252124; l=5602;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=oK2L5X8TGo6Z9/D2DTTdT9kf2V7+XELqp768EPNH+Os=;
 b=NW83Br76VciZusNk7gBmN0sIfGfz7EYPOIlFZ/0vBbR8o2Z+dT/rEoXSEgTcUW1EV0alnfXpa
 R7TPmBJFr/4AKAu8u6ypiQtxg3fwt114rgDRr3thuMdJCJipxsdoW9p
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: 1qrtpp5ncsqqme31p6agx84shndd7n49
X-Rspamd-Queue-Id: 8E1202000D
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787252131-596838
X-HE-Meta: U2FsdGVkX1/aH2KLSBTif2K+GCa2ugcBy8au0Er3J8cS6x2eO0yzgK0gSnWRk4uSc3FJJai4m6VuqlXFR5FFnMNlfmtOuJvsa00ELzIYfCJnvkwZdSCbR2vWBwcRL0UKBzPtfp30zkgrgv4tDrG1dEcRh0GUrDpRfRCewDaQJTXsy8eM4ZZiyKuUSPTCInN5NUMZGI1CnqQNcmflEUnCm3SxtCqItVrbD3JEb6qLyn/v2RQsYf75OBzHGaknk71dThhueYjScyc+w1hz1fgCXoePI4uNEYX/QalWPEWk5DaKELf5U6U4lgBylPahHMVCjn6nHnOW2gPVbrGFnHl/r75u9R8MXrX7sDqYSYnaOc1um8Egsdu0sdU6AW57IDwEczVxpVNDaH7a98ryKAbIZkOZRudMKxHwI4AqWhr0llMA7Ft/0sdMqnvc7Bfq3AYcEfhfqd5hcEAjSmVLFsu1SD/jZWK4fpgxcejs8TXI5KrsDlEa4JCuGEj+ydQ5QQx63Dqhrss+DgMxAk4Y0loXRwr+MoQijLb/deujVTHhpsi2kOmDe3Omzyh2NOAsJdg3N5o59Br52PDJsVtme/nVXKyYFMohqsGBSOSWNeD6WQIriBvpNuoTxBbZDMsV/uC9NgSZvdOCi/6VAGugDVGzGP+dfWclFVNn9qdVJzIVV3USU9IyaHxh5LlaXWcEQV+1o/5toInY+6WwWnYe3QPx3IsBRu9kThzoKVMnH9pxz6NlWMVtXzap3gY1NHiR+ow7xH/TvQJsuibk6SgtdQrL+Pxvvp8XyIRZtyqlzJpK4QU4FYysJoDNtgHtpuy0Km2BlL4J3lghnGh+5hdwamRf9OlDCHzAE9KM+20MoE5swPZa/ytEonK13C7aKXc4txmunMaCocyyiNTOdOL+rwJca3uXDKijwBtZx0xKJ360A8ulDaA5w5fgaM6dTIOM8obrVlu1UtKW7UA5X4DcMAp
 k92lr4ol
 lfl/Jhr3Ldp/DEkI7n7pBR0UPueaezx1xY7lZ+pHXB3zyM1NSj2eezVA6W7UW/5h1lsO8HLhwJBVDwF0RgGYdBVDLrj0IiwXzGu1e11flmvynMTBKMnUJFnbZzh2eaKV6Uh1aqC+EpzfPO1/OZ5sRk5903+zI3A79meovBVmFIlIxBsv5SJDgScG/R42XFDi1HP7wY/baLHt6NTUgNSv8J5rIRyyN9G5BkCsynk+vRkvS3Wwx45jocMMm2hj4trt+6fmEhZYGAZEhKMT1DOO4zj9S+1EYJJF8u9WSglVdWIMjSJ77sa90aNPfqdd40FNDEla8OadDS7FGjxDccnXiUeaZW7ukB8QPtPns33N9Tm3f+YhOXUI6eQhq0iRw0GlSsA41lreGnFxA6y/KuZSr4R+s2bFEVnviz29rc5nt8bpGuWQhAtW+PdF1pOsIyYiKp3yqZNb8j0fnpJ4pB9aeK1XG/UMeTtXzswA4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

To prepare for further cleanup, move the unmap/remap handling from
__folio_split() into the split helpers.  Only anon folios need to
be remapped, so remap_page() is now only called for anon splits and
the anon check in remap_page() is redundant and can be removed.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 58 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 27 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 01c8cf428595..af9c2edd1fba 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3589,9 +3589,6 @@ static void remap_page(struct folio *folio, unsigned long nr, int flags)
 {
 	int i = 0;
 
-	/* If unmap_folio() uses try_to_migrate() on file, remove this check */
-	if (!folio_test_anon(folio))
-		return;
 	for (;;) {
 		remove_migration_ptes(folio, folio, TTU_RMAP_LOCKED | flags);
 		i += folio_nr_pages(folio);
@@ -3933,19 +3930,23 @@ static unsigned int folio_cache_ref_count(const struct folio *folio)
 	return folio_nr_pages(folio);
 }
 
-static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int new_order,
-					      struct page *split_at, bool do_lru,
-					      struct list_head *list, enum split_type split_type)
+static int __folio_split_unmap_and_freeze_anon(struct folio *folio, unsigned int new_order,
+					       struct page *split_at, bool do_lru, bool unmap,
+					       struct list_head *list, enum split_type split_type)
 {
 	struct folio *end_folio = folio_next(folio);
 	struct swap_cluster_info *ci = NULL;
 	struct folio *new_folio, *next;
 	int old_order = folio_order(folio);
+	enum ttu_flags ttu_flags = 0;
 	struct list_lru_one *lru;
 	struct lruvec *lruvec;
 	bool dequeue_deferred;
 	int ret = 0;
 
+	if (unmap)
+		unmap_folio(folio);
+
 	local_irq_disable();
 
 	/*
@@ -3970,8 +3971,8 @@ static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int
 			list_lru_unlock(lru);
 			rcu_read_unlock();
 		}
-		local_irq_enable();
-		return -EAGAIN;
+		ret = -EAGAIN;
+		goto out_no_split;
 	}
 
 	if (dequeue_deferred) {
@@ -4021,15 +4022,21 @@ static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int
 		lruvec_unlock(lruvec);
 	if (ci)
 		swap_cluster_unlock(ci);
+out_no_split:
 	local_irq_enable();
+	if (unmap) {
+		if (!ret && !folio_is_device_private(folio))
+			ttu_flags = TTU_USE_SHARED_ZEROPAGE;
+		remap_page(folio, 1 << old_order, ttu_flags);
+	}
 
 	return ret;
 }
 
-static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int new_order,
-					      struct page *split_at, struct xa_state *xas,
-					      struct address_space *mapping, bool do_lru,
-					      struct list_head *list, enum split_type split_type)
+static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int new_order,
+					       struct page *split_at, struct xa_state *xas,
+					       struct address_space *mapping, bool do_lru,
+					       struct list_head *list, enum split_type split_type)
 {
 	struct folio *end_folio = folio_next(folio);
 	struct folio *new_folio, *next;
@@ -4049,6 +4056,8 @@ static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int
 	if (shmem_mapping(mapping))
 		end = shmem_fallocend(mapping->host, end);
 
+	unmap_folio(folio);
+
 	xas_lock_irq(xas);
 
 	/*
@@ -4133,8 +4142,11 @@ static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int
 
 	if (do_lru)
 		lruvec_unlock(lruvec);
-
 fail:
+	/*
+	 * If we want to use try_to_migrate() on file in unmap_folio,
+	 * remember to add remap_page() and adapt it.
+	 */
 	xas_unlock_irq(xas);
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
@@ -4174,7 +4186,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	struct anon_vma *anon_vma = NULL;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
-	enum ttu_flags ttu_flags = 0;
 	int ret;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
@@ -4262,21 +4273,14 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		goto out_unlock;
 	}
 
-	unmap_folio(folio);
-
 	if (!is_anon) {
-		ret = __folio_freeze_split_unmapped_file(folio, new_order, split_at, &xas, mapping,
-							 true, list, split_type);
+		ret = __folio_split_unmap_and_freeze_file(folio, new_order, split_at, &xas, mapping,
+							  true, list, split_type);
 	} else {
-		ret = __folio_freeze_split_unmapped_anon(folio, new_order, split_at, true,
-							 list, split_type);
+		ret = __folio_split_unmap_and_freeze_anon(folio, new_order, split_at, true,
+							  true, list, split_type);
 	}
 
-	if (!ret && is_anon && !folio_is_device_private(folio))
-		ttu_flags = TTU_USE_SHARED_ZEROPAGE;
-
-	remap_page(folio, 1 << old_order, ttu_flags);
-
 	/*
 	 * Drop the mapping while the inode is still pinned. @folio stays
 	 * locked and present in the page cache until the loop below, so
@@ -4359,8 +4363,8 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
 		return -EAGAIN;
 
-	return __folio_freeze_split_unmapped_anon(folio, new_order, &folio->page,
-						  false, NULL, SPLIT_TYPE_UNIFORM);
+	return __folio_split_unmap_and_freeze_anon(folio, new_order, &folio->page, false,
+						   false, NULL, SPLIT_TYPE_UNIFORM);
 }
 
 /*

-- 
2.55.0



