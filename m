Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E451C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 07:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26D8E6B0093; Fri,  8 Aug 2025 03:48:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2177B6B0095; Fri,  8 Aug 2025 03:48:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1068B6B0096; Fri,  8 Aug 2025 03:48:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F03756B0093
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 03:48:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B18F11775B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:48:25 +0000 (UTC)
X-FDA: 83752812570.22.4BE6F2A
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf18.hostedemail.com (Postfix) with ESMTP id E209F1C000C
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:48:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DKmjlGP4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of chrisl@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754639303; a=rsa-sha256;
	cv=none;
	b=UCyU7rcjfE0rdFvwJcB1DWW+uuS2iSS1ipoR48Ic7Q18rr2dXd2joDTrdOq0tv39HqdlQs
	5Sa1r8b2LQgCqyK/qbG+sQx3Ku/c2qzmFebZvci+lNX+zlaQ97d3tb8H0+1jv7xCFM4pUW
	SzugMNYmO7Ibch2JwWcKO1OjC66pxCo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DKmjlGP4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of chrisl@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754639303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hO8wXyP2SvDmKZlOFr7nvKpnoyrKp7m9+JT2eu+lX6s=;
	b=GkQLUu8iMsMCPFkIcpjM9aO3NgLtiNlPWLgx3+USz/Z/8WHKTJs+DDRj3VIRnTYcHzfPCf
	YdvsNsWjkIBUV+5ndYbdyF+UR0bE6PXLWvTzaFVkajMmGBdh/C7Wc+sUYkLrfjdtQErVNj
	vVcpXERDuFDF0tTpHOVYls0qlhwUl7E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 27DF6A55813;
	Fri,  8 Aug 2025 07:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80CB1C4CEED;
	Fri,  8 Aug 2025 07:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754639302;
	bh=BZTS7frkKfJe2pCWHUR6QsakG7KU7hU/moSvHgaur8c=;
	h=From:Date:Subject:To:Cc:From;
	b=DKmjlGP4PMaY9KwqezPx/6JgMyFPINxmOPo89ZH3FEh8W2kzW9iHe5AE8IBbhHnwY
	 LgjcDN1pRkJaKpEH+vpGOzfwgp+3Ei2UI6meqfVBY6sfLGH064+dS4RLxZjHF6J4Zt
	 M9DnV38O61FK9gLNJnj5oSF3kzGs8/W/CGdH7B2DJIwM/QBBYDn5F/z4dqjp5E/17S
	 p8HXM586tUa9DWMqV5Wsj97I1hMDZyi5XnMRVU1bhZfAbJiNFKK4lDZZQ0wp/U+upY
	 1CKvQchEAlhY4KTIwEGb8AllGWjFbFIP54Ke7olLshkj14lcFBiBaY8ntGJ5Ajk+01
	 dbWE2P3f08aog==
From: Chris Li <chrisl@kernel.org>
Date: Fri, 08 Aug 2025 00:48:19 -0700
Subject: [PATCH v2] mm/swapfile.c: introduce function
 alloc_swap_scan_list()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250808-swap-scan-list-v2-1-d50e4758ecee@kernel.org>
X-B4-Tracking: v=1; b=H4sIAMKrlWgC/3WMQQ6CMBBFr0Jm7ZgyFAOuvIdhUWCAiaQlraka0
 rtb2bt8P/+9HQJ74QDXYgfPUYI4m4FOBQyLsTOjjJmBFNWqURcML7NhGIzFVcITqW9arjTpXhn
 I0uZ5kvcRvHeZl3xy/nP0Y/lb/6ZiiSWaemIa20orQ7cHe8vr2fkZupTSFxKlv9KtAAAA
To: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, 
 "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>
X-Mailer: b4 0.13.0
X-Stat-Signature: r6cago3txunsgramxe31gwru8t4zoqdm
X-Rspam-User: 
X-Rspamd-Queue-Id: E209F1C000C
X-Rspamd-Server: rspam02
X-HE-Tag: 1754639303-542276
X-HE-Meta: U2FsdGVkX1+BdfaGWQrVLZt6erNQ86Z5lHWjKtH1AmV2X+ZyNoERXPCkrQ1hHWA5wBolSUp8iunYEaBRIOTuwW2C91x3WFHResah5lD7ZJwvo8VaSFRbIm80vQHYxi5Upit65n63hTrC/sw0/jJzvLk4Z2zYFLBdVA8le06fKBMG7DoIh4SIgcNC9iOyLDL8vs3NXmdY5jsFuqi1S1XSbHe00W2UkjNmuemaABii/l5C5t3SV97bDmNNI0dyTy5s59wGkwYnAYOqgaCOKe1s3tQcaJMvL0vA0kBsvm7Z6ufXQJoCfHM4FFsmlMd6lJ4GSFkoalCJ3rbCwi3TFY1ltlU/P0xMYluPjYt4LRblty3KceQX7TEo73emJDYa5KoAyOaHA7XsS8RtpLvDI4O1HVftzkc4j9wjzirzK8c1jluAvRiRpZitWcIHwkZ20fovE7eog5EWwkik6XzkvoG4rl8L67GbvtK4eQNKB2flrqKfRInXxg9olryjX8K3GsoK3oV3byhHz/qmF3P3ggJigv0HOO1PH9w0F6rHOA62ANemj+4f1vVvWiZTtPdpuij3TqFfYIEhqKHH+9B2L2qZJMtzrRWGr7nzWZElzsXxAI0D/vpiOSu26OK7q3vLCOdogRCAs+iP3tkICOfkx7jtsfn61nVgEkE2wUWGWZiwLwmyXQGmDG9qwYjhEJgWtN660l/RL8B+u67bM7vSnys+5xB8IqDhXJBV3s5CwFmi3mhyVBm7SC5BFGU8szbAnjteJ7BlKkGa/tJVi51LPzOEn3LHc5QjCG6Rc8mR6jpRu4aCsu8WLISW9hnSxAOEHKVgy5DxbU9b2eg4kEjO3UW8ij9tly08QyCOAIgRo7j0nFdjr8wm+am6mKMtCFCEg6y7QH+xYarP0VnzQf36nTz4EGiz7yEHHvOGebjFgGMiMddvFSYo+f0nt3b0mxT7uXTyVeBfXL/vNddKP1lTyjI
 bH9GfKWR
 yi6sYBl+bzjq60SpaIBCxHRZYwVA6+vcnd8qDnwz/PoqNGk7/X4Rg2dKFLphpG/URqGcH+oVqrMZ9WWNwthYHJI1lg4dALwwszFUr7IIopy9ywHqxzlxVRJKlzaJQI0+1N6xKHQ9bTcLoHiGWc+9Ny4PP0KFHOlcPNgJs8CQCirT/in3MO9ZChUSJk4U+pk+ck2CoUFtcx5TYBln0Hs13KL7CVaFhgY11XUOouPhw1CjzQcxRNKaa5/h4MtIWD+pgzvTlinwyoc46Vqrr6qFdiTpmeLHFAKpi++7M49lA7GtN+bTc8qczlDd8Fg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This the alloc_swap_scan_list() will scan the whole list or the first
cluster.

This reduces the repeat patterns of isolating a cluster then scanning
that cluster. As a result, cluster_alloc_swap_entry() is shorter and shallower.

No functional change.

Signed-off-by: Chris Li <chrisl@kernel.org>
---
This patch goes on top of Kairui's swap improve cluster scan series:
https://lore.kernel.org/linux-mm/20250806161748.76651-1-ryncsn@gmail.com/
---
Changes in v2:
- Adjust change base on Andrew's feedback on int type and break out of
  loop.
- Link to v1: https://lore.kernel.org/r/20250806-swap-scan-list-v1-1-a5fe2d9340a2@kernel.org
---
 mm/swapfile.c | 86 ++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 47 insertions(+), 39 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4a0cf4fb348d..f26678d68874 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -820,6 +820,29 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 	return found;
 }
 
+static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
+					 struct list_head *list,
+					 unsigned int order,
+					 unsigned char usage,
+					 bool scan_all)
+{
+	unsigned int found = SWAP_ENTRY_INVALID;
+
+	do {
+		struct swap_cluster_info *ci = isolate_lock_cluster(si, list);
+		unsigned long offset;
+
+		if (!ci)
+			break;
+		offset = cluster_offset(si, ci);
+		found = alloc_swap_scan_cluster(si, ci, offset, order, usage);
+		if (found)
+			break;
+	} while (scan_all);
+
+	return found;
+}
+
 static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 {
 	long to_scan = 1;
@@ -913,32 +936,24 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 	 * to spread out the writes.
 	 */
 	if (si->flags & SWP_PAGE_DISCARD) {
-		ci = isolate_lock_cluster(si, &si->free_clusters);
-		if (ci) {
-			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
-							order, usage);
-			if (found)
-				goto done;
-		}
+		found = alloc_swap_scan_list(si, &si->free_clusters, order, usage,
+					     false);
+		if (found)
+			goto done;
 	}
 
 	if (order < PMD_ORDER) {
-		while ((ci = isolate_lock_cluster(si, &si->nonfull_clusters[order]))) {
-			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
-							order, usage);
-			if (found)
-				goto done;
-		}
+		found = alloc_swap_scan_list(si, &si->nonfull_clusters[order],
+					     order, usage, 0);
+		if (found)
+			goto done;
 	}
 
 	if (!(si->flags & SWP_PAGE_DISCARD)) {
-		ci = isolate_lock_cluster(si, &si->free_clusters);
-		if (ci) {
-			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
-							order, usage);
-			if (found)
-				goto done;
-		}
+		found = alloc_swap_scan_list(si, &si->free_clusters, order, usage,
+					     false);
+		if (found)
+			goto done;
 	}
 
 	/* Try reclaim full clusters if free and nonfull lists are drained */
@@ -952,13 +967,10 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 		 * failure is not critical. Scanning one cluster still
 		 * keeps the list rotated and reclaimed (for HAS_CACHE).
 		 */
-		ci = isolate_lock_cluster(si, &si->frag_clusters[order]);
-		if (ci) {
-			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
-							order, usage);
-			if (found)
-				goto done;
-		}
+		found = alloc_swap_scan_list(si, &si->frag_clusters[order], order,
+					     usage, true);
+		if (found)
+			goto done;
 	}
 
 	/*
@@ -977,19 +989,15 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 		 * Clusters here have at least one usable slots and can't fail order 0
 		 * allocation, but reclaim may drop si->lock and race with another user.
 		 */
-		while ((ci = isolate_lock_cluster(si, &si->frag_clusters[o]))) {
-			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
-							0, usage);
-			if (found)
-				goto done;
-		}
+		found = alloc_swap_scan_list(si, &si->frag_clusters[o],
+					     0, usage, true);
+		if (found)
+			goto done;
 
-		while ((ci = isolate_lock_cluster(si, &si->nonfull_clusters[o]))) {
-			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
-							0, usage);
-			if (found)
-				goto done;
-		}
+		found = alloc_swap_scan_list(si, &si->nonfull_clusters[o],
+					     0, usage, true);
+		if (found)
+			goto done;
 	}
 done:
 	if (!(si->flags & SWP_SOLIDSTATE))

---
base-commit: f89484324d5876ee10765fa61da0332899fa1a6a
change-id: 20250806-swap-scan-list-2b89e3424b0a

Best regards,
-- 
Chris Li <chrisl@kernel.org>


