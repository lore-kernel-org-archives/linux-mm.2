Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91A01E63F08
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 19:07:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 657946B008A; Sun, 15 Feb 2026 14:06:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62FCE6B008C; Sun, 15 Feb 2026 14:06:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52E306B0092; Sun, 15 Feb 2026 14:06:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2A54E6B008A
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 14:06:34 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5517ABC90E
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 19:00:49 +0000 (UTC)
X-FDA: 84447607818.23.CF90562
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 66BB7C0011
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 19:00:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="JRJX/rgq";
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771182047;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ABMqAPq7AJ4PCsRDhodHRlgWZzJzznaaZpYQv0sMGgU=;
	b=DxEbwGSkGHtmyTn7vjXhyZhedrT/TY0Kg4xtwkV4IQh6mCKRIvH3/EYma91cgsMPdOvYhu
	NTRuPFbYNFLgcupFkGJ/AZhRlqBG6bhm/R+plC7/H2FRZy9xNuDz+ArXnQYKTDe74U1oFf
	OkZd7wg5zHdieVSv3tKB+UAlhbisa6U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="JRJX/rgq";
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771182047; a=rsa-sha256;
	cv=none;
	b=lN/RQ8VxIKzBH1Tr33ZTupL4uURvLGRgz6TEV2rrJjD5C9OvCx9Q9CLKqd9R5+yNmBGW5J
	8A9XfDgh8syH23OCgB0KypmyHnWFyAA90NWhmLz7AHquiVIyOZOozPFF56CLtehk0cAUDa
	t76ho8JEOaxo+MmJglTbgTC0cjHwIds=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ABDA061331;
	Sun, 15 Feb 2026 19:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 335EFC2BCB1;
	Sun, 15 Feb 2026 19:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771182046;
	bh=wYTnJaBMBsMKTzzb60ulEhgq9fyH+kQ0QpPvYbf16Uw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=JRJX/rgq6MIlxGPmiGkU7l62fhE+zV4C7kMpZKFL+TpQoL+BSrdCUMmDtrFU2S+gK
	 m0p1RMCkGkbqZcV+pfmgh8ALLUG7g7AiyxQwp0oBZpa1UCkN624cNarRqoaEklndrB
	 dAGF7YqjKoi/Ntm66Sx4J7OvxMXZB5anBHCGO4MBBpRU/CxXUDPiShZH1MVcpwbaA8
	 eLLR9DNK4G1JmXs/Bg2K4KtwCftXB5tPZznMJkhiw7kQ8K8j3mjXSnMAOuN4fn0lgo
	 wgL3DH/8xZtrLjXa34GgVP11Agtf1BV8Wi3JSi+3Oo46lz2jixOK6hfcViKtUgZod/
	 pz8dnxaWTlUCw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2103CE63F08;
	Sun, 15 Feb 2026 19:00:46 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 16 Feb 2026 03:00:27 +0800
Subject: [PATCH v3 3/3] mm, swap: merge common convention and simplify
 allocation helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-hibernate-perf-v3-3-74e025091145@tencent.com>
References: <20260216-hibernate-perf-v3-0-74e025091145@tencent.com>
In-Reply-To: <20260216-hibernate-perf-v3-0-74e025091145@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Carsten Grohmann <mail@carstengrohmann.de>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, 
 "open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, 
 Carsten Grohmann <carstengrohmann@gmx.de>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771182044; l=2624;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=l6JMKyznXv7F/U7uxICNhzFyjw8qBx6KKx0n+2vekQ4=;
 b=sKhh/YKyxlJMwOjmKcgVwcMjFOKElcHZFjBnSNbb504y4+zD57nffhL0T4FZ7GzMEpV5Yxxsh
 yzIfZ8b685RDNlsDQpp54AYE4JVMm8yao6S3CSzFm7RT/IqRLvGfxDN
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 66BB7C0011
X-Stat-Signature: dqpsjc9gyyabsbxzaaf3iysienpbwqxt
X-Rspam-User: 
X-HE-Tag: 1771182047-549749
X-HE-Meta: U2FsdGVkX1/4Wn2HbuwD5xIKL1M3ivUq7AUY6YReND7ZyUAs5WwnEzGRx4O2JQtHCp0L9fU52I8wh9zqeCerzirCw486cgWHsa759Y+w8ala7nAO3cbrBAOO7PsTfG4b4dgawzF1Ow3bK4yUJHQjvKYza5rP/fejjfY6ZXa+AGgouT8hioug30aMyoDn1uOJm37mPRhVF59YF1bknvikn74y79pAQINwv3Ya1IPoVg+nIjEKeus2fj9AJF3mOGe8BSV44KKUINJfesKPmdlLKLUCvyNrwrjnghYFqQK4pxwzKIYjvQeFRqPlh+eDHsRRs45rQTNegJn5GnjYMZzjgwmKv+pWRDd08G6RMnEA9XzGsh19Xai3n7ed/HWpMD2voc50ojMCNfZhb8pIF4mLJ4W2EVwfnMU1BCXCYTse8eWHMSokhwtXHk8+sH+OC+pB/rbhyEfPpQ9iMt/lmGQyR+JHNKRhBeP9Lpo3V4WSLV6OslFUtVhg+BHq7exBxiTZGlDL01VIbVp3FZ7ggPMbqx8qCD3woTInyHfGfMTzuhZ3T5axUMQ+GQRRoNZd+h9aLi6HHmXGG3riKl7iUxDP1hvvf389zTUqHkKUi0nKUb7GRqSqD/HJzh71XKZkzXhAC5R5hGFdywYe5MEbhFXdD1b/KKAKXZ9abLLHqqAZnEuublogBGXsSlcythu+9P4DVrSaFmRJpqe/dYGANDX+xS+ecdk+PTGJgG5MwKXzEPLFKC7s0GhWaZYWPR9hajIwj90XSEonabK/bFU+Mwtjbf8muTNLZv58Qbar6hr59T8qQVsxeTEho41egWjQCO28vfoMWPYXcnrUTgXP6/vj1pzcHJV6IsJG5CaMfoWxZh/LKEVBde0xrpPlM6IiiRTWZbIS7/lHgx5vg0BmSKKGvChOy6pad+bBZEG4JWTFD1gSGbvL4/fGM0HyIHy/1tqH8IWZNg+9mO0V9IEFU8H
 SnwDAo9l
 fVwzZ8+jBWgLJ4k/1NE5pSbmRKd2DFzyMqQMzK7u5Pvhhru/wboCYq9eSc35XBOVlLMfCLOdRR1qfnDVNU2PRRMHqPPzLLHhjQRHCNwHOVKEYWPMMD6ug72arNjYFTRyPPY/t6xyZOFofE1v6RnNfX67UFJ+MJqmkNwNDWTQG0bxokeGIkEDtwFz/+/v7pJ4rkHLL6AXRronHyJ6og6uzqy71im7+Tt5tU2dYJwzU1RFNznB4cDJAG2o9JZMRh4O/kJmY9Ss4ODPsVTt9dEM6uf5fExz0jxE2n7r6kk8IecqCrVE6fMsDws0HUZ07YdVhLmT/MkH+L9EI8YPaEMMXM8EfNozq3m6N+GvnfGROVamelagYQSgGeZnXxQ==
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

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 0d1b17c99221..68dbbbd0dd24 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -923,11 +923,14 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
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
@@ -1060,14 +1063,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
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
@@ -1332,14 +1328,7 @@ static bool swap_alloc_fast(struct folio *folio)
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
@@ -1945,10 +1934,7 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 		pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
 		if (pcp_si == si && pcp_offset) {
 			ci = swap_cluster_lock(si, pcp_offset);
-			if (cluster_is_usable(ci, 0))
-				offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
-			else
-				swap_cluster_unlock(ci);
+			offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
 		}
 		if (!offset)
 			offset = cluster_alloc_swap_entry(si, NULL);

-- 
2.52.0



