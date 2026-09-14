Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05214C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 17:17:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E2A76B00A7; Mon, 14 Sep 2026 13:16:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B2F56B00A9; Mon, 14 Sep 2026 13:16:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A17D6B00AA; Mon, 14 Sep 2026 13:16:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F02CF6B00A7
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:16:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 75F68C020C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:16:01 +0000 (UTC)
X-FDA: 85213020522.28.B484D33
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 76DCB40002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:15:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="MXkpGIf/";
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789406159;
	b=kBNmCDrNsP3wWclZtEy6D/PpXuZ5j3efhRB9kLZZSzXvj1uRq+JnMLgeS0dRoA/q5FiVdL
	zd/PczTYoZNHuPSq2YNTfD5YKKgCMgefDwP2ZFu8oG2IYHYFJxTtkc6a5UotQfXWhrY0tG
	WatBV/tJQ1zUIytjs4ViypLXZVoBnTQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="MXkpGIf/";
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789406159;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bBNJBhHogjtdOJ/XPHIINJmSsPc/CpKQDRDTHwzxNbU=;
	b=yi+PYo97F9adiwTMfrulJtIhzh5SC3f+6ZBR91IQcd+EBCW4ovYYQLabBgEKS41bcz+N7W
	tmf79mYQEqPWcaRz9sRoKhQo4T4XpdJLLPlE4tOivIu6HPe9DdfwwkDoIw28ngsaWjwjwI
	S6STNt+pZaz6IvBS3MzszYw2wwJeqOM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2286E43F61;
	Mon, 14 Sep 2026 17:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 03C31C2BCB8;
	Mon, 14 Sep 2026 17:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789406155;
	bh=R3cfJ4kOZ4vv3zzMD2cIpN4aOkeo+1QN/0BkoNF56iQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=MXkpGIf/asdckGz4DYc0+7f3hqG8QhErtqnNlrv3Ez3yCJ4+ZuDBOUpNC0Yglnagk
	 zolN3whP3Nu5P512pCfYm/ZGElayYaQnL5KcfadWbGvO0aAyt/sxhpiSrBLuNXNX5r
	 V2UkCYvAIAilJxaThvyPFRfGgEyEzTUNqKfMNz9hdkcognCLlKIOkiAl/EYlchkyzU
	 vsk+gNUjhs/0ExNAU3bH5+MrG2bW6lB0F74CVEqDJPXfuMw8eO4Pc4yOczHGXZe9oA
	 zxoc6DrqyIFew1z5pwqgVVTRPSiqcxuzbLJqsSgVglsDUq1U6ZLFvfUSu+pR/rmzCV
	 PHUjKKkgExymA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4373C88E79;
	Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 15 Sep 2026 01:14:57 +0800
Subject: [PATCH v5 16/17] mm/huge_memory: count only swap cache refs in
 anon folio split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-swap-thp-cleanup-v5-16-39878b37dfb0@tencent.com>
References: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
In-Reply-To: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789406149; l=4345;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=LOWEUGV9vnWcliQuTxGteL39iwN2Kn7ndHm2EI5yAVw=;
 b=ie6374ir/x+K25U6wjmKfoB0/V1PKSM3rsUQuIIKzzyOIKN76JGaAbZhbDmrNN8BDbQ9Moz/Y
 eHqhH95YDcTCCXWkdYuBHaiBGmnu0Q0G6fglWUZgCQqcJevhOw0Borh
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 76DCB40002
X-Stat-Signature: dbyhf3acnxnmbs977bhj8gos57opu3in
X-HE-Tag: 1789406159-353073
X-HE-Meta: U2FsdGVkX18ts8yGfv9I8Bp2JV7jBhewKTzLY6kX0qttZtbUgmqr7ejDFTfbkffOLwKeXHkJEg4QCszwLUF8em4SH4xsPqoG177czAvDLqIIaZxV9ROh7yQgUtpiXIjkif43V86m00CS7Pz4nk+YN7VYap0lXFMlWpgJUeGduN9VmgOhYZf38Q5XMxwpH/5EZzse/g+0PHKBxzNKVWztxNdRQ/D1UhMsa3BMgpcoZ3CTASRCKSYD4P9WZp0+xZRNfVC8oBT26eUmgEXvMPsD+HF/m6OLxe2Hq+mIz+YE1gsn3uZgdZ9H8B3Mv834dumAlonzB0MuhuggMyfNOd98RI29tpZMbwnUqOO9icnT0nHqA9IVkfJvKYjrqX3XbMOhpShzyHr+KBXbftsEOExqPSe+Z7dOiCyW6U0QYS3QbKWz9rC7aLPnUAlAsR81f7qFzvMqXTGYU7BcOyVPyb0DrTN4pdE2x817/+uzGhdH2QsD7sjojewoOBHlIQNaCgxiXB+A52bJ9yw6oceT98QrTHENslK7xINdSviZXVWQZEbfcY1lVqTnwnPsYLmKxKa4dCCWOWeNhVQ1ZAd2JlHpXoUVvkdXaG/OqA89K8WDKGd69xQXV8Qbhy6eNveg8x0d07SML/gerioSLryqjihXLKTP5faqblyRpRU1EGuXLFcF2Oq5yQUX5UURxwgRDHMsBqr6tvQpE4EsBTBn1Iw3cN9uBzCsK39R5Jb9+uEYWYIkScZpntNG29IdfGBn6YWuO17soMvVhHWoAVa4cxb3GqZTeLK6R2aQof9r9fODvM9Nd7WwrzFLR6izhGRVSsIrLR+rYd5Z8z9EdGDd7Ls7kY9tm2RPr6Y99fXQ2TjUAhf31lGj1Z65YT58osZWEVbSbvcAWM8+DRq7SL2MTaWJUK9rCigqPFYW/h+/7aJ7qvfT2unEoNpcrMmFfyYTAdolURhRvr3JqYq1zOvNxOa
 1OSUX544
 z9iknJTrsxuTw3NaXZGx79X8fJItXz875W6zW0plxr7dYFeAJZyDCagypwP5VxcJPSUm5T/JL+hWiDVr43+RPbzjLRgDq8s5ZCK9OnsZOlZUIMFRMk0NZd5QrirreLZ7qrplxA0E60CG0u5/KiOPs7g2K+0eWOAPzNXYpox4dCHmmKY/J69oh8YesOLcciMvFfuJJZYhSK7nRhVkFsCVNs17Dy+iTMPBB/fNH2YMJlA2ATmVUsSwz4rVUsl9KjoCDXZfwQQjxrRL/bRgqHfNDN7cvgXzFWPCERaOa8j4ZEESD+PAqDpVweeUqgHqrMJeZuMwEVw4zEen7+/t49lyZM8Hz4n6iCqMy9QxLgrHmFR90V5gZ9SxRCt/PniXhoRq4nQliTTbXLL5GfcZAD+uX+tiUlfLJS9de6h5UR8n5W1+vpfGTvmxTo795l0rr0vA7cjQB2Lv68EaNK6tGuUth8iuu0WpAUTc0J8lMawUaKlcUYEWF2hT7HAgCSIe9z1OY1g5ZDo+0Uw37pgyk1YHa8TJWg+UPn/cNVLZnfOlxU0NrV2L1ZM3cIX5G9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Only __folio_freeze_split_anon() sees anon folios and swap cache folios
now. The file split helper only handles page cache folios, which hold
exactly folio_nr_pages() references.

Rename folio_cache_ref_count() to folio_swapcache_ref_count() and drop
the anon check so the helper counts what its name says. The file split
helper now uses folio_nr_pages() directly.

No feature change.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ea8bcace028d..fc4dc3f9b563 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3994,10 +3994,10 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	return 0;
 }
 
-/* Number of folio references from the pagecache or the swapcache. */
-static unsigned int folio_cache_ref_count(const struct folio *folio)
+/* Number of folio references from the swapcache. */
+static unsigned int folio_swapcache_ref_count(const struct folio *folio)
 {
-	if (folio_test_anon(folio) && !folio_test_swapcache(folio))
+	if (!folio_test_swapcache(folio))
 		return 0;
 	return folio_nr_pages(folio);
 }
@@ -4065,7 +4065,7 @@ static int __folio_freeze_split_anon(struct folio *folio,
 
 	local_irq_disable();
 
-	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
+	if (!folio_ref_freeze(folio, folio_swapcache_ref_count(folio) + 1)) {
 		ret = -EAGAIN;
 		goto out_no_split;
 	}
@@ -4102,7 +4102,7 @@ static int __folio_freeze_split_anon(struct folio *folio,
 		next = folio_next(new_folio);
 		zone_device_private_split_cb(folio, new_folio);
 		folio_ref_unfreeze(new_folio,
-				   folio_cache_ref_count(new_folio) + 1);
+				   folio_swapcache_ref_count(new_folio) + 1);
 		if (do_lru)
 			lru_add_split_folio(folio, new_folio, lruvec, list);
 		if (ci)
@@ -4110,7 +4110,7 @@ static int __folio_freeze_split_anon(struct folio *folio,
 	}
 
 	zone_device_private_split_cb(folio, NULL);
-	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
+	folio_ref_unfreeze(folio, folio_swapcache_ref_count(folio) + 1);
 
 	if (do_lru)
 		lruvec_unlock(lruvec);
@@ -4139,6 +4139,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 	struct address_space *mapping = folio->mapping;
 	XA_STATE(xas, &mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
+	long old_nr_pages = folio_nr_pages(folio);
 	struct mem_cgroup *memcg, *old_memcg;
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
@@ -4209,22 +4210,16 @@ static int __folio_freeze_split_file(struct folio *folio,
 		goto fail;
 	}
 
-	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
+	if (!folio_ref_freeze(folio, old_nr_pages + 1)) {
 		ret = -EAGAIN;
 		goto fail;
 	}
 
-	if (folio_test_pmd_mappable(folio) &&
-	    new_order < HPAGE_PMD_ORDER) {
-		int nr = folio_nr_pages(folio);
-
-		if (folio_test_swapbacked(folio)) {
-			lruvec_stat_mod_folio(folio,
-					NR_SHMEM_THPS, -nr);
-		} else {
-			lruvec_stat_mod_folio(folio,
-					NR_FILE_THPS, -nr);
-		}
+	if (folio_test_pmd_mappable(folio) && new_order < HPAGE_PMD_ORDER) {
+		if (folio_test_swapbacked(folio))
+			lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, -old_nr_pages);
+		else
+			lruvec_stat_mod_folio(folio, NR_FILE_THPS, -old_nr_pages);
 	}
 
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
@@ -4248,7 +4243,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 		next = folio_next(new_folio);
 
 		folio_ref_unfreeze(new_folio,
-				   folio_cache_ref_count(new_folio) + 1);
+				   folio_nr_pages(new_folio) + 1);
 
 		lru_add_split_folio(folio, new_folio, lruvec, list);
 
@@ -4275,7 +4270,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 	 * Otherwise, a parallel folio_try_get() can grab @folio
 	 * and its caller can see stale page cache entries.
 	 */
-	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
+	folio_ref_unfreeze(folio, folio_nr_pages(folio) + 1);
 	lruvec_unlock(lruvec);
 fail:
 	/*

-- 
2.55.0



