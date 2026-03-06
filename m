Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D325F01828
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 11:51:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7F616B0092; Fri,  6 Mar 2026 06:51:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3FBF6B0093; Fri,  6 Mar 2026 06:51:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C83246B0095; Fri,  6 Mar 2026 06:51:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BA8696B0092
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:51:13 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6A2A9160319
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:51:13 +0000 (UTC)
X-FDA: 84515472426.15.423E8DC
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf13.hostedemail.com (Postfix) with ESMTP id AF18720006
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:51:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772797871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tRryoNWHbDmWo07p6jg9/dMBlY5zaIRR554kEcFC/KQ=;
	b=BNY4OsdhWs+R1bWwBtmAll1VUCiLmUsPuRvHci+CqsJHlONX5mIOo7UYv2kyt5F7fyhvvJ
	LzV05puZ4sp4mxu5kW4Mh7Mg4GksLC67kCDSGQBeow/AbryVYKbdW+YN+/4HNpoDj0KCEH
	2mOM6zeLC3F5uCkt0ZUw5LepJtsZRbk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772797871; a=rsa-sha256;
	cv=none;
	b=aWS9sfCosaNaMSoXrR47dnUYJsED9/9as6efAeUB9TDnOO6o/9Z72veSDR1YP4Pq8D5Gcg
	ThwEo7j6u51GyRheqDqcgUWUm+tDDwYzPEpxpAO9NpMXpBEy6DjmNDrpp1dN8sl40OkBp0
	fzgw6LvgzBMLvdSV7Pt1LG1s6TQyqG8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH 1/2] mm/swap: fix missing locks in swap_reclaim_work()
Date: Fri,  6 Mar 2026 19:50:36 +0800
Message-ID: <02f5912caa6c427705bf8da43497801caf3b102f.1772797581.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1772797581.git.zhuhui@kylinos.cn>
References: <cover.1772797581.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AF18720006
X-Stat-Signature: womskeorwj9hq3rkaj1p3nz3cx9ohbm8
X-Rspam-User: 
X-HE-Tag: 1772797871-163996
X-HE-Meta: U2FsdGVkX1+9I0NdYn4sYytRBGMbvZTOcD0Dh2Kjm7pqDP4GMYurPn0PgkT2cqxGjH93BydGYccd5ritaZ+bwfCTp5RRSo5aHLn+BQ8+OYzKn5Nq/rwqLpkT9/SMBKLpVgr+pUxMyvzgvSCUhgo27q1OfsUIxwJwYPiHCXOE1hVXK+q8uSbz0hR3ZiWbMoTao8gz4mVQUUSumW/mFbz9/NqOVVHKMsFpXqfd80d42djx+1eMKTe6w67tONASnnXLVYYILTBUmUnxqvyRizoccGSehAgvW9Rjz0YMDJp2nLaWmEtArGnINWmG2bFxN3xro2Fp3+MoveUk2Iaq7OZshJfOzP/NoMfsFXzA7j97L9wmkBsJgMEw6JrqtRm7XQ3EsU8F7gYtfVDoBd417Ra2PFJZHETpeigZIE4lPU/rnEhwYEw84GJ0ss/z83LSblbXQFEifBbLFGkvZ7CeHyBgwcEWJ6y1t8JQdBQTIYwRdnnV4TC/xuwbVDALHmndhiU5Lf8D7+ntDwA29NniOht2skv9dbD/O5GhFZmaeWAhhctqQnyFuZCDxPwCegIUoiNfcLUZ2Qo3AQ9OxSpMLrm0tC3ZP5bLbGrAzXY+SqOXZe0hnqm79yNgMQq5NtiP3cM8DsfT0Xvsu226uYRYcwfogPRwJjYAMWYLaqRbiQ66f82MCrUdEzmFE5pe1tZI6fScwDQ0mVeubkUlgDamHmy3Z1y6dxtxpOYjyL9FHhFD5YeOAdMYfLewhd8OeMvmJEq1BnYgGqQD7RxHtb+5wujEmeYLWT/hh8fWMvwuiv6xXwX/SEVi1H1dS6aLvS3tFSXMMV0bIbfPljewth1FA7WMMldeab+QvBGcmlcfH3pRjVN83Qqykri1D5OyzORZrl0lMl1tao79CYSZK98LybIV6zHW4nrdyyDKE/SjWTeC18uSBx3O4fDzOOOyg5Jh6J9hlqhjH5h8GDzM1zL108A
 K+zPmTLJ
 rgOothP4txe83CDam34uInX4eJoDCy9bvyvBh5iS78M6+gW/Y1oLrndcP8cal3E6D/nD3dJTHYyNMTmDjBgtXtx+quVevXn0PjURDtpbgxdUWdTc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

swap_cluster_alloc_table() assumes that the caller holds the following
locks:
ci->lock
percpu_swap_cluster.lock
si->global_cluster_lock (required for non-SWP_SOLIDSTATE devices)

There are five call paths leading to swap_cluster_alloc_table():
swap_alloc_hibernation_slot->cluster_alloc_swap_entry
->alloc_swap_scan_list->isolate_lock_cluster->swap_cluster_alloc_table

swap_alloc_slow->cluster_alloc_swap_entry->alloc_swap_scan_list
->isolate_lock_cluster->swap_cluster_alloc_table

swap_alloc_hibernation_slot->cluster_alloc_swap_entry
->swap_reclaim_full_clusters->isolate_lock_cluster
->swap_cluster_alloc_table

swap_alloc_slow->cluster_alloc_swap_entry->swap_reclaim_full_clusters
->isolate_lock_cluster->swap_cluster_alloc_table

swap_reclaim_work->swap_reclaim_full_clusters->isolate_lock_cluster
->swap_cluster_alloc_table

Other paths correctly acquire the necessary locks before calling
swap_cluster_alloc_table().
But the swap_reclaim_work() path fails to acquire
percpu_swap_cluster.lock and, for non-SWP_SOLIDSTATE devices,
si->global_cluster_lock.

This patch fixes the issue by ensuring swap_reclaim_work() properly
acquires the required locks before proceeding with the swap cluster
allocation.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/swapfile.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 94af29d1de88..2e8717f84ba3 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1031,7 +1031,15 @@ static void swap_reclaim_work(struct work_struct *work)
 
 	si = container_of(work, struct swap_info_struct, reclaim_work);
 
+	local_lock(&percpu_swap_cluster.lock);
+	if (!(si->flags & SWP_SOLIDSTATE))
+		spin_lock(&si->global_cluster_lock);
+
 	swap_reclaim_full_clusters(si, true);
+
+	if (!(si->flags & SWP_SOLIDSTATE))
+		spin_unlock(&si->global_cluster_lock);
+	local_unlock(&percpu_swap_cluster.lock);
 }
 
 /*
-- 
2.43.0


