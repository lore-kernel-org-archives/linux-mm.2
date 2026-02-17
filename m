Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7177CE9A03E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 20:06:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3AE76B0089; Tue, 17 Feb 2026 15:06:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B78B6B0095; Tue, 17 Feb 2026 15:06:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FA236B008C; Tue, 17 Feb 2026 15:06:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 693A66B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:06:52 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 313961B4538
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:06:52 +0000 (UTC)
X-FDA: 84455031864.29.9C7B3DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2AF96180006
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JWvha88M;
	spf=pass (imf24.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771358810;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EWp6Y5M+vWCDDpXjKXL6gDiov3290zIxsWXLEdTp1cQ=;
	b=YhD3XLCG4nOyA0R/TyD74HTL2EILXrmDyPx6u3FQwz19HgAHjJTlm67SuuJfBaWgXgav7f
	TfZutXExsh3nRTSt+JZF/DlQfGqPZAaW+y3rwnmJF0TeEUkcBqicWMlDfqXTEAblrZtQkf
	woz/QccxFWzpdE0wZOp7KoTWJJjSkuQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JWvha88M;
	spf=pass (imf24.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771358810; a=rsa-sha256;
	cv=none;
	b=44HE56Nt0OwjFliN9sl0UbT6vZp1AYRwgOo7ZTu3A8tfjSXbzJ6+0ZuUcYii64HjsOgIjw
	73qTWjH4AOb7bzl6IRvhxqzpgjObeO7vAjhUuC1Vpatog/ds3XrSB1Mvee+7z5vqndvWWx
	pBjRlE+yMM5RtxwOUSNBXldvGSsOFPY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3972B444B9;
	Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 141EAC19425;
	Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771358809;
	bh=RyDzMAmfxfcPT8sKIGfF1K+4m/6TkMreqQ4aKJizUJY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=JWvha88MtRSN3jLGNG877Qt8+GHLuwstLqe2oMJrlp/3ENBnr+HOodK3xaE3rY6j4
	 1q+XUt9/bKP8iorcbrcuLO/GhdOj0oRazTPduR37S8qRejkL4vuoPPpmdzlg/Ds61T
	 hP1tc0busK6vVtT32l2JWbouuKA94p6awizwvqGwcpsTLHYQUWp5rMzy4C7ooUBvW2
	 tAvCYLW1ch7gMOG+ED7EEFAgq0F0Reu33Ynx194KWtiI9y/MLaBk5AckZPIHgM7jWB
	 74mUs/yZJI8zkMA+LrN+K7l0pSuWCa2ZBB4BvQKeooWgiLZcYw5bxTlctg8iDyZfOr
	 DpCnDw7tSCXTQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06117E9A040;
	Tue, 17 Feb 2026 20:06:49 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 18 Feb 2026 04:06:29 +0800
Subject: [PATCH v3 04/12] mm, swap: consolidate bad slots setup and make it
 more robust
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260218-swap-table-p3-v3-4-f4e34be021a7@tencent.com>
References: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com>
In-Reply-To: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771358806; l=4411;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=dTxwU7HNi4RjZm8BIg4m/tk9gYStmKjj5MiTeMIyv7o=;
 b=X0FBoaZxzsjFgaOx7GXTnkZmNCoBeOVc8rrBdBmxLga4IAkX6V3jxFmOmyvmmFpMTcvJKdXBw
 Yoz2wOXCe4kDldrwEgD0/8IdRNTGJgxl5dcBRLKsDyf9zXElv8040Od
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 2AF96180006
X-Rspamd-Server: rspam02
X-Stat-Signature: 1zwwt3y6kazstb6nq9ac4usx7txbo3ng
X-HE-Tag: 1771358809-344844
X-HE-Meta: U2FsdGVkX18ktmG0FC/KCwXO1kWYxoYk0XOZ+vZL4gUy2HG4NDeiv120W7fE2c1b7EVpCnzpmPJf3n1VA/zD/6lXk3VEaIKX8/DW8OYVMhYdeKf7yt1Oa5FNqqz9crdNh3jTDkif9bZKH7OxfZdV3NmGy2VVA3zkL37FijkwSDhcVjYMkDkAb1KbLE0higap2tYQs9SYONobrntd9k1zyO7/atM39nvk7HgqN6hDliodjR0qjWqmosQFygu/T0ykm9VEiAL7Oc7MH9bDlD22G9Hg6fEs5CTwQBxpuv5Vc9lelVBND/ji2XlV4fZnK+Hhr38jqNSUpCY0d5IHqbyrwlqa+Ix+Sonq+ipHUB6+Cdsy2pYnygV1do/KQRXJphEBmaKy4A54o7Xs4bC6jdmCXhQFE/2+CVErV6cl/NtDQ2wEc2sXpWKfK7JxUTmOh4G3lOSp245kwh33s9Bmnbbzx1O9S5MPnTfQlNa/o3yOpnau/pr9ZJPm4Tz6f7D+jxuUVpxc5Hjhh5Jtxdal2mCYpjsfl0YAea6h3DMf1DjoyqqrdWX7xVQJmw21tQ+HxX0B+Jn9oZDVIZm/baQqzNrhC2bwnLQxEm2YTmpjjU4X4FL2ig+pKeTAqDr6b+2pZT226YMmqOMTnr+8bcLfmhbowsE3qmkgdc7shjF3lsHnOaonRjNE/0DXtBRSwFjpowH/T058sNKLS4t2bZmel+Qg0glPzfWImwUZzDA7YnWAskiZVK+mzC3fkQKpLSiSWULsMCpxWaBVXKEjBOVyKY0TURISS+j/nUSTxNfHcRuhusny2xHHLXTlQ30e+tPKgVRgJFQWq7VqZB+FsJhinE5nDALSjaJhHDrQv51J2qzSTQkmgsGXiHJSvpGqmofIz1KeGo/HSAdZmfifj60I8/vkiQZpUPY+JgreSuq1zgcqKUdmpuzml0jCNcCfNJbXJ0h0dMyb1Fvbuca57FZcxpZ
 sv8X/2AV
 tAsyuc4iifj29TINcdI7CMX2uix5U/Z46QDZ0CaDh2Px1xZFFGEbOkPcxeIomTAfOIdjVXqaL7HM9jk0oSGZPUxA5j9TzFVpSkRCp+lkXFG2lYTU/nBp6VNQOgcYBEfNsdi5DKM+iEzHORLKxXcXJlF1qfZL04SsKcYpBAkkhva92kHwWEWT2pFlmFlQFaPGYLcJaVqHE0/1JXEwl/6IJCjRyOy7TH3Fe+8VswpmIL4UoAg2wnTSNshO8a6H6dV175EfyNpnG27TtygYum42iaIQz+eL6jBCOHHmAcBQmWn1jl+3QML71LSAoSpwqK9wqQfBW6j4dhpky6E0xjx2O6Bs2WItIQUMhu+BkDecQFZ2fSJIOrsNnmxkfgQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

In preparation for using the swap table to track bad slots directly,
move the bad slot setup to one place, set up the swap_map mark, and
cluster counter update together.

While at it, provide more informative logs and a more robust fallback if
any bad slot info looks incorrect.

Fixes a potential issue that a malformed swap file may cause the cluster
to be unusable upon swapon, and provides a more verbose warning on a
malformed swap file

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 68 +++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 38 insertions(+), 30 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index fb0d48681c48..91c1fa804185 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -743,13 +743,37 @@ static void relocate_cluster(struct swap_info_struct *si,
  * slot. The cluster will not be added to the free cluster list, and its
  * usage counter will be increased by 1. Only used for initialization.
  */
-static int swap_cluster_setup_bad_slot(struct swap_cluster_info *cluster_info,
-				       unsigned long offset)
+static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
+				       struct swap_cluster_info *cluster_info,
+				       unsigned int offset, bool mask)
 {
 	unsigned long idx = offset / SWAPFILE_CLUSTER;
 	struct swap_table *table;
 	struct swap_cluster_info *ci;
 
+	/* si->max may got shrunk by swap swap_activate() */
+	if (offset >= si->max && !mask) {
+		pr_debug("Ignoring bad slot %u (max: %u)\n", offset, si->max);
+		return 0;
+	}
+	/*
+	 * Account it, skip header slot: si->pages is initiated as
+	 * si->max - 1. Also skip the masking of last cluster,
+	 * si->pages doesn't include that part.
+	 */
+	if (offset && !mask)
+		si->pages -= 1;
+	if (!si->pages) {
+		pr_warn("Empty swap-file\n");
+		return -EINVAL;
+	}
+	/* Check for duplicated bad swap slots. */
+	if (si->swap_map[offset]) {
+		pr_warn("Duplicated bad slot offset %d\n", offset);
+		return -EINVAL;
+	}
+
+	si->swap_map[offset] = SWAP_MAP_BAD;
 	ci = cluster_info + idx;
 	if (!ci->table) {
 		table = swap_table_alloc(GFP_KERNEL);
@@ -3227,30 +3251,12 @@ static int setup_swap_map(struct swap_info_struct *si,
 			  union swap_header *swap_header,
 			  unsigned long maxpages)
 {
-	unsigned long i;
 	unsigned char *swap_map;
 
 	swap_map = vzalloc(maxpages);
 	si->swap_map = swap_map;
 	if (!swap_map)
 		return -ENOMEM;
-
-	swap_map[0] = SWAP_MAP_BAD; /* omit header page */
-	for (i = 0; i < swap_header->info.nr_badpages; i++) {
-		unsigned int page_nr = swap_header->info.badpages[i];
-		if (page_nr == 0 || page_nr > swap_header->info.last_page)
-			return -EINVAL;
-		if (page_nr < maxpages) {
-			swap_map[page_nr] = SWAP_MAP_BAD;
-			si->pages--;
-		}
-	}
-
-	if (!si->pages) {
-		pr_warn("Empty swap-file\n");
-		return -EINVAL;
-	}
-
 	return 0;
 }
 
@@ -3281,26 +3287,28 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	}
 
 	/*
-	 * Mark unusable pages as unavailable. The clusters aren't
-	 * marked free yet, so no list operations are involved yet.
-	 *
-	 * See setup_swap_map(): header page, bad pages,
-	 * and the EOF part of the last cluster.
+	 * Mark unusable pages (header page, bad pages, and the EOF part of
+	 * the last cluster) as unavailable. The clusters aren't marked free
+	 * yet, so no list operations are involved yet.
 	 */
-	err = swap_cluster_setup_bad_slot(cluster_info, 0);
+	err = swap_cluster_setup_bad_slot(si, cluster_info, 0, false);
 	if (err)
 		goto err;
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
 		unsigned int page_nr = swap_header->info.badpages[i];
 
-		if (page_nr >= maxpages)
-			continue;
-		err = swap_cluster_setup_bad_slot(cluster_info, page_nr);
+		if (!page_nr || page_nr > swap_header->info.last_page) {
+			pr_warn("Bad slot offset is out of border: %d (last_page: %d)\n",
+				page_nr, swap_header->info.last_page);
+			err = -EINVAL;
+			goto err;
+		}
+		err = swap_cluster_setup_bad_slot(si, cluster_info, page_nr, false);
 		if (err)
 			goto err;
 	}
 	for (i = maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i++) {
-		err = swap_cluster_setup_bad_slot(cluster_info, i);
+		err = swap_cluster_setup_bad_slot(si, cluster_info, i, true);
 		if (err)
 			goto err;
 	}

-- 
2.52.0



