Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04EF5C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 07:11:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 560438E00EA; Tue, 12 Aug 2025 03:11:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5107B8E00E4; Tue, 12 Aug 2025 03:11:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FF758E00EA; Tue, 12 Aug 2025 03:11:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 18C6D8E00E4
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 03:11:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D3ACF160202
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 07:11:02 +0000 (UTC)
X-FDA: 83767233564.11.B1B761C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id F1BAF120015
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 07:11:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B1F9CQbC;
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754982661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQEhq3aQgQMuPCAliNiWwfXto5x3fpk0NM1RGKSP5+c=;
	b=FQPC5dWkpcRHvi3+XAHlY08B42Qk2MRh3PCaP0sb8eNJ7OrGFc18JNfzNc5G7jj+baIlcW
	7vzlucDK6iYMIERWf2qB/M/cm4JoboNE2ciPO3qyZZ+90L0PuSV+xo0v5CO8AQsCZWStRD
	zpbLAvVfW4HQoy7dMTiDRKF4dUKI98o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B1F9CQbC;
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754982661; a=rsa-sha256;
	cv=none;
	b=h8fAVdRoCkaX5nGDMbULcvK48RJ0kI0FA9HuNrBnGHPC6hFS6VdvzmhMPqUNZv7Mg+vLqP
	Adep1DAEs9pEpO29jbP5tz9vTcTZ5u2tnTXmbDiz5drQYx5fVeuZYs9tb07vaoBWMxYftY
	7264IXSqkHM8lNo2qFRzXepM99bnEsM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9257F4430D;
	Tue, 12 Aug 2025 07:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F009C4CEF1;
	Tue, 12 Aug 2025 07:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754982659;
	bh=RS8ZN6qEMRelHHf535daIqnnsWW0kEy9YMRdf1YF2MA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=B1F9CQbCHkCn4lgH11d1sPnMtbwfOGvwAeb8STBmGAEOHN9jQk/cx3veSoweGRUKu
	 Yu4hTUW3pCVUFSUA4gvugi/5BQ0lKjKmbGEOd4mLjudgwFGme0N4RjLYjbLuwo0SUs
	 8zLRYBDigLRNWSMVhQJ13HKLu/e/jkO+Ikba3l1AD0DXuCL7wmWbDFuCDAluqPExbh
	 dyws2ecYH9ucj2kApdv5b71we6VM8Ig5PGo3ZXlYGVERsrxi+t/ySzNgMnJiql1kNx
	 9Y0k4p1la+tCuYoVOMaBhUDUup6ShXrnztAkhuU+jsOlfpu1TJGKeDhVhTUDmJ1M62
	 YvpRi/7FybdCA==
From: Chris Li <chrisl@kernel.org>
Date: Tue, 12 Aug 2025 00:10:58 -0700
Subject: [PATCH v3 1/2] mm/swapfile.c: introduce function
 alloc_swap_scan_list()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250812-swap-scan-list-v3-1-6d73504d267b@kernel.org>
References: <20250812-swap-scan-list-v3-0-6d73504d267b@kernel.org>
In-Reply-To: <20250812-swap-scan-list-v3-0-6d73504d267b@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, 
 "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: F1BAF120015
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 6i6acknr9j8rqt74s1sewuuu6fxi8zt7
X-HE-Tag: 1754982660-716326
X-HE-Meta: U2FsdGVkX1/umFc+eK+7nXeUvE49QPdcWyLOJJmpd3tyesswIqPZ8zNc3yBf/rtN4vOgHpkFn2I7oMyaRDTuonYA6kSiZDc+gdKXxx9HLLtXnmtuj+2viAr2SaR96CDUCrfVE/Pug05gBiIZ5cwyP+Voj0a4YJsvUrq57tW8RwDPfAj6ciW66W5sjc6CFBkafqZGsR/M9rHwpl8t6wzEyfKJMXn+xevRmUbWN+IXRAx5Y2jmMPFJz3xUeb/M9Uw0/uiJVsM9CU9sJD6GtuyohLDcYrE703qZqSWimyaSPvPnffI3QF76WkEjd/7dS2VtEe6ABabdupKo8XIG2qk9p8NNmsygd+RrOmfSnU4ffb5wWSSPrrx6sr3xkAblOuKUmVBN9bJUNmZQFBf8+vdkTAM8c9QOzlyVk1FiE3kombC478eXCawByODSQPPtm394vF5U/17KSUDkDY8FkUL61fHRPjMe2T7uhhGOWCQbg+J30/kEYzvB1ZbAZLttx67FGMo+dplHGXztPt3Kt8IHBMiVWrhMHX3rA1R5iq7yL3ZFUjLv8gcEXsOHtwc5HiFx6nsxr3Gg+63GF5u7/HbIAbHyuV24E925gy+0b5T9320ovAPFNm7ub4XT8JMbYda5GOmmfJVcnc1BW8LthrLOHRpX0yHvWoqyyhwAu8JbdokZH44IGNMCdGMFIgVmoQyqvPbQ09KBRuXFJWJQK5hE4R9DAZrJwIG9+ofG+pdPLSfoQGvqu17Oqu8EbQ7rj44luMvOfPk7VYnkeV6qcAnqm/4bB7Ui9R6y66R2MCFgnGfdONZY1Pr7fd37D+H6ubdK69vfiqWMrXzHcjfrJiw3RPs6oPb8A4XOvE0cfwdnI793X4ls48McQaI/Th0Iwm3lMW2B6uy6QqHaucSMDnuQUrFk+Z9i8vr0sgD6cxWAuIOpGKqKaOsz7OEQ9dGEZEd0NDjoG+HIXz/o4mnqLp3
 oUklhsvW
 GGZrQxddiiDXHTFK+LNJSuhYA4fhVe6NgLtwGgQfvJFu3mfSIxBcJl29n7pZNDuC3aLpzEdtsWUoU87SQ6vn3WgK6OZrvm+syE5jnzWgfsypeQI9E1tDQYZUcVtXilH10ZjSICQSveXcB0b7jGWMCDYxJtOUepLzEjXQCVbaRo6hHPfdffJVTOnxeLhlIRLig5Z2qapifH56I607viIpb07sCMkVkwQJ8UoSEO+IbpnabCzPLWlZVsdUHsN3iU0kD48F/9bYln0ayucx6HwVERJzPI0+BoVmk/2hVGgMysDDfVZM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_swap_scan_list() will scan the whole list or the first cluster.

This reduces the repeat patterns of isolating a cluster then scanning that
cluster. As a result, cluster_alloc_swap_entry() is shorter and shallower.

No functional change.

Signed-off-by: Chris Li <chrisl@kernel.org>
---
 mm/swapfile.c | 86 ++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 47 insertions(+), 39 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4a0cf4fb348d..a7ffabbe65ef 100644
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
+					     order, usage, true);
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
+					     usage, false);
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

-- 
2.43.0


