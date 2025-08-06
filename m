Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55FD7C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 17:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDF238E0003; Wed,  6 Aug 2025 13:34:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E900C8E0002; Wed,  6 Aug 2025 13:34:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCCCC8E0003; Wed,  6 Aug 2025 13:34:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CE2198E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 13:34:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 919151DCFE3
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 17:34:59 +0000 (UTC)
X-FDA: 83747033118.30.5EAB841
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf14.hostedemail.com (Postfix) with ESMTP id E5F42100004
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 17:34:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=koUIqyXf;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754501698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VWAFPcCyynAePXmu1xZ1cDsxhOtwsudGBZtgNaorGyA=;
	b=sZhb/9YCcPpvB9OD3tE42WQDKeiTvcoV6Cxp7YNGNa5l2mL7tHqV6M16yDnXbxsQ0JXQVG
	D+1UCz95FbyA3xX/IJT2ciCgGvW6Aq0G0tg1JmyNIXWOWYSGYSuuDsBGzEs00uYD+AwHDt
	u7+DrhQlr3tqcphOJcw5J/nRfyehC6E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754501698; a=rsa-sha256;
	cv=none;
	b=TGlQhCroq2U/OVJc4AH7GfSvsHIIfbQAY08KsTiGfXQbk6ZxCnp3xS6B3aODhDRV8lCcK3
	UZ43O2NJIFiyQn4Q7Rlng9Y0NfOHtV6z4RBon+ibPro0tN/yVZQrodW5eX0PIv3uIolf6o
	WN4lr9xOW7/w675T47gCImzGNUmW3v8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=koUIqyXf;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 5DD5BA56AEF;
	Wed,  6 Aug 2025 17:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F9CC4CEF9;
	Wed,  6 Aug 2025 17:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754501697;
	bh=H9iAkhsw1Agl3S7e1PFnp6CwoDmmLNQlA/6GK67NT7E=;
	h=From:Date:Subject:To:Cc:From;
	b=koUIqyXfpTa3JMKqwdtSBFa9g3iuB1UE1pCv2rSEtEobKOnH1Tsh+qDvouuej1VXc
	 K9edqcTJEjNIAe5muuXKGEbU+lzlBPKaKWkxLvnHk8ODs6CIOnaBEqDKsvbqjhqgjc
	 01pbNTpU+zSeiKm5dwLXLRaw2/GQZwrC7BWefgL1vS1637bTcdYkvS6DB7KzhaIFLR
	 Dpv355pg8HPo5fRmuRsKvtCv4z1U877sq9rTfciMGzyPMxg5DlXpS8xv/Fbav5kixS
	 rdxjJLS6f3slVY55UsXvXUPw9y2gLKiqyiigXErq3tkXf3NUDoAGV9ubun9x5WS4Q9
	 LyB8ItdL/32Sw==
From: Chris Li <chrisl@kernel.org>
Date: Wed, 06 Aug 2025 10:34:45 -0700
Subject: [PATCH] mm/swapfile.c: introduce function alloc_swap_scan_list()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250806-swap-scan-list-v1-1-a5fe2d9340a2@kernel.org>
X-B4-Tracking: v=1; b=H4sIADSSk2gC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1MDCwMz3eLyxALd4uTEPN2czOISXaMkC8tUYxMjkySDRCWgpoKi1LTMCrC
 B0bG1tQD+B9tBYAAAAA==
To: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, 
 "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E5F42100004
X-Stat-Signature: 8fd9u3j7hz7y69gnkm69u7e7xs4knnc5
X-Rspam-User: 
X-HE-Tag: 1754501697-812744
X-HE-Meta: U2FsdGVkX1/PEcT7Hbd8rZ/A0KIMsFLMyqZm1buJ18AwAFO3zsbFD+hWhztyarFAtksyWfeCgQr646JZZv0ChBgR6ICekpeB7XzDuaQQoAQYveLy/ukMliV012Zhg/Q5YxV5zV8UDFW6XFMHjKKNEtilX/ugDAp46CbYtasdFIQplGtqEIb2D4ovPEbY2YEVrT1svxIVEhzCdiZzHm2TuMRUNH5RUdxL7MeBvFKy073fA0xPKXYcjc/ZsXR5c/Xz1eajQksPsV5jb36LhYv9VAgGzuz/8fczZrJEyjCupuP4FqR+l11TAd+eqFfoAq6+rS6oxixFVhQHh388b+zpw9upCF33xaK7qWdoaQ7Mhr5VLFzXSXFUNGum3cSdeiL/wPRMG3QiZZnhYsYdMuIb8fUy4hddHOAVUbvUGUQpv84+wHFebFGCCzgmR5c8EU4aD6mD2lqDGimy9w13qJR4hZnc/dshBLM/apBQ8LPyHPIX+tbeKiVKNAJ05Pg4hblvWfIBWh85Kv2tK4yS8qm+zavvL2ZKf6heAOLc3ug042PGhpJOjvty6F5glnHx5imrxXOZKiKFXmsrzfEjn/czkfq1HgLNgCJyHXyYteW7ug836o5nmQXP0M3iAzQoJrjKS1DKrzX4a1Z18uuElajKCMVpA8Pya9L0GCKWf7HzXyOSOQT7qzol4oA+PmrBk0ufWLgqb7w9bNsFWmc2B9dFkMRXDVcP7gGeKItVlvRNjsVXKij9VE0YNtQDA6YmX/tY8S0F9qnX4dxEAnbGPxLyPJWxQj4Spdq+OJ3vnd1kREnYi0kJduJO6eOQJokDtwYl1sFeCFX6+vVGq3rxYHjVT5CMszTzvK0YoxIfpZR8IFQQN3l/reCD18RhdXfjGdwLFbdGIY3JBTN09pvSNDwJyJqvcJa6Aaz+2boFgBHPFU2nrBEqphWMVRS3HSwMauAj28tCtu8QcQk727jmWTm
 ZbvrB6sV
 yDdQuPXLzpNYBjmW5UzZiPoYluoycnMmSRSzOlXnab2wbFNYIoYaJIQx6YR0xYZv3LqtBExAC5JvEP3c+jbyTzGqmzpDaM4H3LFNx927BqL7zMRCdzTNMpfZHiMDC+EgIg8hP10bYMMuP6o9SOIdIsXXOCGSw5GbIyW7CGM+46F4QP+1jJHeGbzrmtIiA9RodMETdlRLr0uVp7jhlEypvHhJi+1Dw5tHvoOx19FkwiBpK0LPox1wVCwHc8T0f67zwiK2QVIZ4MJM/MDg2dYxuivF3Zb6fqpKBNlweX/cdx6PjM96+wkM6UAsgGA==
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
 mm/swapfile.c | 86 ++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 47 insertions(+), 39 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4a0cf4fb348d..fcb1e57d8108 100644
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
+	int found = SWAP_ENTRY_INVALID;
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
+			return found;
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


