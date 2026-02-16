Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DD6BE81A28
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 14:58:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62D386B0088; Mon, 16 Feb 2026 09:58:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ED776B008A; Mon, 16 Feb 2026 09:58:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49B536B0093; Mon, 16 Feb 2026 09:58:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32F656B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 09:58:11 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E0D48160BB7
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 14:58:10 +0000 (UTC)
X-FDA: 84450625140.24.67AD5B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id D726AC0004
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 14:58:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LZ1MWcoW;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771253889;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wwpaBbNw6+uFjgEJADWbePxf6zlQS8jilq/2G9lZBzk=;
	b=Gcklt4357nUdubAFsdMpiIzc4mMOEN58bHzYP4mzwgfLxsyN3YOGtMkvmC9kbnw5OmK5cb
	Q18dKkUmpLtepv/x2p4dc05+kdeuGLfYCd1eLqImpmN+FQiGfu43KWaBqbZINEJSk9RCtJ
	9OLp4lGO7cLz+LoI4jjh7JFK0yNoiLo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LZ1MWcoW;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771253889; a=rsa-sha256;
	cv=none;
	b=3n3USWCAJfLhTRB2hctPn2wmdDpsQoC0EBqnjFtZIYWntNq95HMeFyEWq99mhhWijE3rEB
	2/T/pyw4AE0MViX86/Rt6dj7rNnmbEazTO/FPgfOsfCvJ79SEehbZKhOVbl/Gg3AoIJCwM
	C5C5G5P9nvNwz4wWg4gG/F8mUp3Jo3c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F208D44515;
	Mon, 16 Feb 2026 14:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D3A96C116C6;
	Mon, 16 Feb 2026 14:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771253887;
	bh=WYW37/BfhOOjNfUbgzmr0b/6G+uzVVZ+LippTRuq7l8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=LZ1MWcoWLWOo8VNMgjp1CUNUSjNO4mLPJIUXIY8WVZaRAj37yWd0ELYIErKcDYEGk
	 IAH/orXK8IXxhlwbISW5/F32Eu0hHlaPuSqT/UvEmVsd9CE8IbrIukvAtPvNYaBSJT
	 yFlvY2UG9iEqFlyfgSDHnNFeqo3++trMu5VLTeLSmTsurpfXTQ1SBPf8ka7E2obJwh
	 vCL+VBaDdNCQBZJlR62n3Q60pILX9xDKk+ZZibBuN5GRNbWS2WGwQXvh4y+QwbfofO
	 Dn0yMujM3OXGbRxR4jJAn//kSgQoBunG3uCASyEjzYlBc97WMEl9FSzrmowsQxi9fB
	 8vQSsgsLWnXuA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C15F2E81A32;
	Mon, 16 Feb 2026 14:58:07 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 16 Feb 2026 22:58:04 +0800
Subject: [PATCH v4 3/3] mm, swap: merge common convention and simplify
 allocation helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-hibernate-perf-v4-3-1ba9f0bf1ec9@tencent.com>
References: <20260216-hibernate-perf-v4-0-1ba9f0bf1ec9@tencent.com>
In-Reply-To: <20260216-hibernate-perf-v4-0-1ba9f0bf1ec9@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Carsten Grohmann <mail@carstengrohmann.de>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, 
 "open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, 
 Carsten Grohmann <carstengrohmann@gmx.de>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771253885; l=4406;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=XE85Cs7eMoW2MzbPsMRN8glTTJ2qQfea8kHvJhs9XRM=;
 b=XjOjKB6C9RKF289BaDOi2fed12TaT5b+w77m1kwzOZ5PBWUKf9cA9Lwh5/Vmc8idUkOkv49cW
 CGGS8aMFVcQCG2luwdfgnGmOyIk+xyV50eFl6DypcOEVr3JsMK69xGJ
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D726AC0004
X-Stat-Signature: nh3madijwnew3f7cx3p8n3nk9na8ye8m
X-Rspam-User: 
X-HE-Tag: 1771253888-699851
X-HE-Meta: U2FsdGVkX1+jxcty8iG2vIZGNRR7JzTaDHY+YpKBw2MZ1I1daJZSjI3O369vPsC4xQ92WP6E37upQTna9Z+zkaUTSoDT2So+IlgIwEZEu7L7bo8vfZw13G6qkIFQ+ojVLDGv3BEq0Nqbl7nN30Wx/lsSjrHZ/TIfr0SdPkwDl505EJ1GGwHX96ZXB5rRdfQC+BWr/mbstBIjScVAihnNXEKrXOqdH6UvvQYicuX/Ub1D+W1j1nvK63Jauc3LKVa1URui0q4c1nKQVT2ezdPsOMF6Xshd3fJ0xdvluwdH1O/VV8i5tCPCX8bAQKePrh6D+NAUld9oj1KiDPcX1e/LA9iYuRNqqZxdIbMvZTht6no5Il28gkH2CWREwW2gjnNA+uM/bSDbOuDCUkXrDb8ZJ0YBWbHrKdcuR39Mit9B6DZ7H87obx4f3G78PMpq4TPp83BIEc5ViGekE5fkcm4m08QfbQDyIHo2MTk7KLoMmkKkoGbsPbyhKVs87PCGAngcAUVn1ukdGh5XvUt7Xy5nHqSq30ItsUre/1Jtdgi6WiYhWNhZEmaJ7kmtEKQ1FgzDZzJRpY4u1zr0DNmb7NCmiPQY55W4jW+OAT0zeT0o59URAQEPejCjnQu/USTLDXTqjaNBA1nEwH2+4Wr1xAnMYw5ga6wS/smGfkrvUzRCEuJQINaRv++YcyePS4WJtNJTFbr6Y/dEFhjqR5cIPcH3wFVJujD0uaSoLpYCUYel8i2TMDMDGJFDtf1aAcL+lsiemnzTO+0bH8o4BvA1aAZgU1WGZM9Vl/B6FM9vYyyNeGvK0GHjkDuG0j66PCLsUc3Dee18ZS+EHzo2Rql0F1AK8Ve3JP/65AjtRGbNZJiBEQz68SG9ZUnf/p3zNLlUOh8xfoPdqB6XSKo+IphlHpFm+uvVzq2/RLl10IWgAUfStyLtLhGpEgp7KxrsBcXnwpHqGu8JeG15m6Poo2fB8pq
 B9ByGHs6
 cIXgFXx7q+Exjx3JV27BdFma8SsvFDRFRT33iyvtyHFwQoHpWbrJdwjDXt8+UVGDTl26mB9JGRGbITdkDGNsk6MNlxAJxPF5HeoNK/o7BidNRMJw5bKp5nToshu3ylNrZcnwAb8VPV5ouUkhgLA1qqJYZk4ScqhanX+/L52sXbJmIg1hNp4jV6wvHrasHOwaWwxXwmvPQsDdlBD4UptSTTELj5oi4/ZbuZCjU8puEYXbfzILWRjavnSEj4F4s8nlx9cR9UIkydTJ466te813eS/oDMaxG6jIaLyoLDbhTFaE2Pv7suJ+5kac5JKC95qchHZhKIcuuPTJZKVrhXYkMV5YnQlh4aWCnLLzdWjPWZzRuGrbonn0spApYrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Almost all callers of the cluster scan helper require the: lock -> check
usefulness/emptiness check -> allocate -> unlock routine. So merge them
into the same helper to simplify the code.

While at it, add some kerneldoc too.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 54 +++++++++++++++++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 23 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index ea63885f344a..a6276c5ead8e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -910,7 +910,21 @@ static bool cluster_alloc_range(struct swap_info_struct *si,
 	return true;
 }
 
-/* Try use a new cluster for current CPU and allocate from it. */
+/*
+ * alloc_swap_scan_cluster - Scan and allocate swap entries from one cluster.
+ * @si: the swap device of the cluster.
+ * @ci: the cluster, must be locked.
+ * @folio: the folio to allocate for, could be NULL.
+ * @offset: scan start offset, must be a swap device offset pointing inside @ci.
+ *
+ * Scan the swap slots inside @ci, starting from @offset, and allocate
+ * contiguous entries that point to these slots. If @folio is not NULL, folio
+ * size number of entries are allocated, and the starting entry is stored to
+ * folio->swap. If @folio is NULL, one entry will be allocated and passed to
+ * the caller as the return value. In both cases, the offset is returned.
+ *
+ * This helper also updates the percpu cached cluster.
+ */
 static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 					    struct swap_cluster_info *ci,
 					    struct folio *folio, unsigned long offset)
@@ -923,11 +937,14 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 	bool need_reclaim, ret, usable;
 
 	lockdep_assert_held(&ci->lock);
-	VM_WARN_ON(!cluster_is_usable(ci, order));
 
-	if (end < nr_pages || ci->count + nr_pages > SWAPFILE_CLUSTER)
+	if (!cluster_is_usable(ci, order) || end < nr_pages ||
+	    ci->count + nr_pages > SWAPFILE_CLUSTER)
 		goto out;
 
+	if (cluster_is_empty(ci))
+		offset = cluster_offset(si, ci);
+
 	for (end -= nr_pages; offset <= end; offset += nr_pages) {
 		need_reclaim = false;
 		if (!cluster_scan_range(si, ci, offset, nr_pages, &need_reclaim))
@@ -951,6 +968,14 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 		break;
 	}
 out:
+	/*
+	 * Whether the allocation succeeded or failed, relocate the cluster
+	 * and update percpu offset cache. On success this is necessary to
+	 * mark the cluster as cached fast path. On failure, this invalidates
+	 * the percpu cache to indicate an allocation failure and next scan
+	 * should use a new cluster, and move the failed cluster to where it
+	 * should be.
+	 */
 	relocate_cluster(si, ci);
 	swap_cluster_unlock(ci);
 	if (si->flags & SWP_SOLIDSTATE) {
@@ -1060,14 +1085,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 			goto new_cluster;
 
 		ci = swap_cluster_lock(si, offset);
-		/* Cluster could have been used by another order */
-		if (cluster_is_usable(ci, order)) {
-			if (cluster_is_empty(ci))
-				offset = cluster_offset(si, ci);
-			found = alloc_swap_scan_cluster(si, ci, folio, offset);
-		} else {
-			swap_cluster_unlock(ci);
-		}
+		found = alloc_swap_scan_cluster(si, ci, folio, offset);
 		if (found)
 			goto done;
 	}
@@ -1332,14 +1350,7 @@ static bool swap_alloc_fast(struct folio *folio)
 		return false;
 
 	ci = swap_cluster_lock(si, offset);
-	if (cluster_is_usable(ci, order)) {
-		if (cluster_is_empty(ci))
-			offset = cluster_offset(si, ci);
-		alloc_swap_scan_cluster(si, ci, folio, offset);
-	} else {
-		swap_cluster_unlock(ci);
-	}
-
+	alloc_swap_scan_cluster(si, ci, folio, offset);
 	put_swap_device(si);
 	return folio_test_swapcache(folio);
 }
@@ -1943,10 +1954,7 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 	pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
 	if (pcp_si == si && pcp_offset) {
 		ci = swap_cluster_lock(si, pcp_offset);
-		if (cluster_is_usable(ci, 0))
-			offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
-		else
-			swap_cluster_unlock(ci);
+		offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
 	}
 	if (offset == SWAP_ENTRY_INVALID)
 		offset = cluster_alloc_swap_entry(si, NULL);

-- 
2.52.0



