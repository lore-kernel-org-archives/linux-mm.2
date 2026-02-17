Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B2F7E83848
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 00:10:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEFF96B009B; Mon, 16 Feb 2026 19:10:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B591E6B009D; Mon, 16 Feb 2026 19:10:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAA006B009E; Mon, 16 Feb 2026 19:10:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 96C3E6B009B
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 19:10:12 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D2EBC459A
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 00:10:12 +0000 (UTC)
X-FDA: 84452016264.10.7622243
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2DBDEC0004
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 00:10:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf22.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771287010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JLskrKjmdRSrwnqIimlJNbTWkxF136UsVe3efIf8kmg=;
	b=5GjsDhRy9UgRfobyT98F5cjFB+mR0cdn3l12uML+ED8HKjLB2eNMCzsOJZmCeXwdH2anMx
	/ZB/P+BdtEZIKJCFndr8HC4Wha86TziZWzxCIwiNut9n/vsR6jMXg8bqCILlnrcYGNe1Os
	lyW+3eliu12e1m8BTx9KS/1LSegMuLI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf22.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771287010; a=rsa-sha256;
	cv=none;
	b=vR/+CTiHcHpW9/3m6rTcvByblXTsX19zyJIoOa63WnneMe4WEK1mZLuQPNXyMPl9Sr+cdw
	34KckxCEa8U6gQieCjtE+smWqje8aJ8gTVwDyQsGydsN8YZGBCx/tarxSSlY2ec+0NcusV
	NmolwfYLTuNbZk9FRFJKgBFc43u2MSg=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 17 Feb 2026 09:10:07 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	linux-mm@kvack.org,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	austin.kim@lge.com,
	youngjun.park@lge.com
Subject: [PATCH v4 4/4] mm: swap: filter swap allocation by memcg tier mask
Date: Tue, 17 Feb 2026 09:09:50 +0900
Message-Id: <20260217000950.4015880-5-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260217000950.4015880-1-youngjun.park@lge.com>
References: <20260217000950.4015880-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xzprwoiqwzbhenjxrmis6xyn7buhwodj
X-Rspamd-Queue-Id: 2DBDEC0004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771287009-412135
X-HE-Meta: U2FsdGVkX1+QxL0oysY3oCiakKp0RpwxkhE/5wKz6F+9uYslVUPSZZ+ujE2fFuAH7UY52uLOddIfDRf11dhvJQ9AMcDdXNrPQPTo4MCceyDp1SAYQ9RTbgFwUKbh5qzSDNmas8xj4FOPfFACX31MYMZza1y3oNw1pDJ4voHRsSTqxlEo9pVf9/Pnb/bJECeFjItlUxssYf2leeyjGsj/D68tJUsSZ55HSbrQ8RJVNHi7j1HkuATyhq566Jig2nMjn6CJG8iEJxJ41EWT3iLLqyr1DTKEbEydQnERzsOe5Kdvr/EdkDWMUYbDO5aZEk41451fMV+3VdfaFq/ri6Ly68sd/PWEZpz8SzhUDIgcUnCTVbnduc1zk2PkOuD+WqW5yjAgJd/OxI5/xGNIP4iAO5hl0aENJPNInzJH+59dtARMf0sTzPDXJk5cZrH+rLPMLd5g6Bv96h7Nge+rV5EKJpTqVkUXYwQJLgi9TDkZqUOp9TMvPyaWLNtRF75f+gt80RD98RIe5Vc+avYZIhKDyj7d9flj4Sl53TJnasl/2j4SNt59m0CjGJMNEv59YJji74JhNKOvlJfPa9q46fMrm0wSZys1PeidwyzZ4RUnWQ7bjOd3OH8880XS4mTONqknsiuf7H6UvC0fZI6CVF7+1QYjpLkrF4CTyiQNp+Z0nv3Y65oZaC1HV+tB7na1h2vHRCY7Y+a5vmfGVvFF8bl0u7W2q6HqloU80UPF7SGmfN86TQK7YdsvMzXC5xdomOHviGYiJ/ply5TU7x6uzXUGpXlTRrBv9zFZeAfr+TzF2L+CnjB2/q8xdA22Uax6wCWRQfzdjzueeVDTnrYsMPWvr/aykfbNdKUq9bXIlPwDY8WJ7DVT2sBJH95te/aB5mGllAHtyv2khCRJ+T4OqU1ia42ha/MZBY5s3bmn3LCyREUk5Hz1r3/t4HKpeMbosLIo9JvcLwLRdctPv4yyGnA
 ljNdyTh7
 k2lQs0kMKa8H22fDA64FpQd5Gw2Wi3ctHL11PaQ6jCp3MYw0QM7JD3AsJff2x2hvIr36vMHV7S/U+45goUFkQfr2jziSM3TBymCTjecvkn+8WS5WdJRZv8qo03mmgtBmGX34NwhOJYpGaRrGAEsVCvRFU+oCCcandQrkJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Apply memcg tier effective mask during swap slot allocation to
enforce per-cgroup swap tier restrictions.

In the fast path, check the percpu cached swap_info's tier_mask
against the folio's effective mask. If it does not match, fall
through to the slow path. In the slow path, skip swap devices
whose tier_mask is not covered by the folio's effective mask.

This works correctly when there is only one non-rotational
device in the system and no devices share the same priority.
However, there are known limitations:

 - When multiple non-rotational devices exist, percpu swap
   caches from different memcg contexts may reference
   mismatched tiers, causing unnecessary fast path misses.

 - When multiple non-rotational devices are assigned to
   different tiers and same-priority devices exist among
   them, cluster-based rotation may not work correctly.

These edge cases do not affect the primary use case of
directing swap traffic per cgroup. Further optimization is
planned for future work.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 2f956b6a5edc..aff5e8407691 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1321,15 +1321,22 @@ static bool swap_alloc_fast(struct folio *folio)
 	struct swap_cluster_info *ci;
 	struct swap_info_struct *si;
 	unsigned int offset;
+	int mask = folio_tier_effective_mask(folio);
 
 	/*
 	 * Once allocated, swap_info_struct will never be completely freed,
 	 * so checking it's liveness by get_swap_device_info is enough.
 	 */
 	si = this_cpu_read(percpu_swap_cluster.si[order]);
+	if (!si || !swap_tiers_mask_test(si->tier_mask, mask) ||
+		!get_swap_device_info(si))
+		return false;
+
 	offset = this_cpu_read(percpu_swap_cluster.offset[order]);
-	if (!si || !offset || !get_swap_device_info(si))
+	if (!offset) {
+		put_swap_device(si);
 		return false;
+	}
 
 	ci = swap_cluster_lock(si, offset);
 	if (cluster_is_usable(ci, order)) {
@@ -1348,10 +1355,14 @@ static bool swap_alloc_fast(struct folio *folio)
 static void swap_alloc_slow(struct folio *folio)
 {
 	struct swap_info_struct *si, *next;
+	int mask = folio_tier_effective_mask(folio);
 
 	spin_lock(&swap_avail_lock);
 start_over:
 	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
+		if (!swap_tiers_mask_test(si->tier_mask, mask))
+			continue;
+
 		/* Rotate the device and switch to a new cluster */
 		plist_requeue(&si->avail_list, &swap_avail_head);
 		spin_unlock(&swap_avail_lock);
-- 
2.34.1


