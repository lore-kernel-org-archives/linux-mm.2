Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D83EC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:17:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3F456B00B8; Mon, 14 Sep 2026 23:17:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C16B56B00B9; Mon, 14 Sep 2026 23:17:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2D966B00BA; Mon, 14 Sep 2026 23:17:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 81C276B00B8
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:17:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DB610C0301
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:17:10 +0000 (UTC)
X-FDA: 85214535420.23.FC5635E
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2726540006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:17:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf17.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789442229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Db0/XWQYJn4IepUTSOc5vi3VxgHaf0uHzMImd8z5Ito=;
	b=dP45V5kEjVMwV3zzfmKH6i1nFW+D2zkSTpn0FF8RO635+Et8LT2WHuzj7Gk5y/RgWkOjPk
	2U7PaLtO7cX+P0Jik+G1+c1PJg7mX6BvLdKGDvp8bGkC+iY9h+axCn4P4AHE6C2dy2bAe3
	OM0M9gzGmS9PBRiHdaUlBFGB9Ec1KKE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789442229;
	b=wUs6DhOvWGrIZ26AoVox3bzulvPyHV0LsiOtFh0mvJIm59dVlyY3KMHPQLXbis+6mZGZOB
	lk28qpKTl5XQNjcvSTWZR/iffJXyLwJwyHi/CN1WPd9m0YhDm52nX2exmQUxR229UYcN7w
	TVoMaqsErNKcfMF92gl4NgCf4jLkN1k=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf17.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 15 Sep 2026 12:17:06 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Len Brown <lenb@kernel.org>,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	her0gyugyu@gmail.com,
	youngjun.park@lge.com,
	taejoon.song@lge.com
Subject: [RFC PATCH 04/10] mm, swap: skip swap cache reclaim while storage is suspended
Date: Tue, 15 Sep 2026 12:16:52 +0900
Message-Id: <20260915031658.1505680-5-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260915031658.1505680-1-youngjun.park@lge.com>
References: <20260915031658.1505680-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2726540006
X-Stat-Signature: 87r3ui18hx83hjhpfjcc7d5jhtn9m7s8
X-Rspam-User: 
X-HE-Tag: 1789442227-284300
X-HE-Meta: U2FsdGVkX19sc4EbnRvs3mTfRX5G8zYIX9AvD7MhPQMzE304auS7Z5yI/A3I/NyUvakjlLpB0R17vpZ2KUfpYLXVDDAdgenJfAkx9NyrmwGO85LexLNBMJ3fxuWJ+PmliE3MGyfiJpcnWn56ttbtKkCIhFn5dbu8KO3jdodyvN5ML59Yvs2hdO4bXxfE5zMdqjVbwcrmpQdiYcLolguU3GGWHyJ2MSHgIvQsdk17A3WuvrhcvhjHmRsIYZa2W9vm8ywVvMKF4GbYMA5INx7ux+w6ht7HYJNJMhMDXs37Rnf9FB7Z5fka7njysNyOSyaW5t6zUfW89Ah/xKDYMiKXF2vwyxkrIbBmQx8xizgTLgJaVyqCfhSD5fhDs/SFK5nTTxaHeykB6cgZeYAS+Tt47pfVD9arko9N9tU3kCHs9l2BeeHsewEXaWU6aWKcJvIkm9xu7QtsTu/ZfHtx/spf1z5kKJUBGUzg5emcx+aycvGlH6wwjJO7GTm97IiqFHraONfuzZ7A5B3v7jFhqODem/XTtneXk11OMtRxcRoatqvEkTlPDCWv1qY2UiHvAIwgBRRNaaQEn7pWPA5hVgt87T1emZ+ryjzXawwz8P3ON+8z5wuJz0dwQt1ByxNW5aTnXce9S2T6t0qNzB2pC5j3tfCrnT/U+dUEcxM9Nsbq0WRV1ug/2lzGjfkcAjUWCdKXYIEW/8FYRUgE8fMsFWFBhv4QMwyLUBDo5DaN9NnqBjbyeqdNo58UezUqpKrICQ9vP0uFspAz68NyO2Lw3ShAo1hkkE9W+3P+KhHG1EJibQQNGI/kkV/50ECJGQnN1QbJQnhE0GoGTlf+pvuwzVqiKzMsiNxgKReFXAfVGAItTYRUKzabF3wqXJsCWPV1ypLayr+Ad2Wx+VI0bepHDyyPEcTCXn3XvsuZ4Wjp3pQOk0bo6VFtdsA4xRcdAOntcI/9EAOm6pnng11DpfVDtaP
 NNSQ22QS
 oICUsCI0MkArWvkfLKkSSqzgLeCUVqNgwbUyW9skrqJKC0yX0LgYLywYmIVxN0HlkmFnD9uEGUl0rHQGG+aSTUpyl7mDQJbnJ3SXGiN4gyWFaM136AH+BvlDi1361qSv56h9NUIEyvYs0uMaBX5Ds4pqeqMpJQzdQOvwQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_swapcache_freeable() refuses every folio for as long as
pm_suspended_storage() holds, and that covers the whole window in which
the hibernation image is written.  Every reclaim attempt the allocator
makes there drops the cluster lock, looks the folio up, trylocks it and
gives up.  swap_reclaim_full_clusters() walks a whole cluster to do it.

Stop trying.  The allocator is left with the slots that are already
free, which is all reclaim could have given it anyway.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 07aefb782fbe..cf519c5569c4 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -903,7 +903,7 @@ static bool cluster_scan_range(struct swap_info_struct *si,
 		if (swp_tb_is_null(swp_tb))
 			continue;
 		if (swp_tb_is_folio(swp_tb) && !__swp_tb_get_count(swp_tb)) {
-			if (!vm_swap_full())
+			if (!vm_swap_full() || pm_suspended_storage())
 				return false;
 			*need_reclaim = true;
 			continue;
@@ -1050,6 +1050,10 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 	unsigned long swp_tb;
 	int nr_reclaim;
 
+	/* Swap cache cannot be freed while storage is suspended. */
+	if (pm_suspended_storage())
+		return;
+
 	if (force)
 		to_scan = swap_usage_in_pages(si) / SWAPFILE_CLUSTER;
 
@@ -1315,7 +1319,7 @@ static void swap_range_alloc(struct swap_info_struct *si,
 			     unsigned int nr_entries)
 {
 	if (swap_usage_add(si, nr_entries)) {
-		if (vm_swap_full())
+		if (vm_swap_full() && !pm_suspended_storage())
 			schedule_work(&si->reclaim_work);
 	}
 	atomic_long_sub(nr_entries, &nr_swap_pages);
-- 
2.48.1


