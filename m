Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CB71CD98EE
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 05:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EE5C6B00A9; Wed, 17 Jun 2026 01:35:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09A836B00AB; Wed, 17 Jun 2026 01:35:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7BF36B00AC; Wed, 17 Jun 2026 01:35:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A9DFA6B00A9
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 01:35:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1242140339
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:35:03 +0000 (UTC)
X-FDA: 84888290886.11.B613CBF
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf05.hostedemail.com (Postfix) with ESMTP id 57FE1100004
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:35:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf05.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781674501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4zrTWEdgqBVmzKwLStMvRGRjsRSCL0X2KZkpJNjxLrM=;
	b=Tae0uq5nzte6IHGJa7w9rYY4erFVt6umeBW+Xn4vEHr11tfOfzRv2YvTOHjhYP7MkVly+u
	f6NfRxESzt8SYRnRiWcWlR0sJou6xU3Aza0gsEgOh32jBb77irqFnjO2gYj5baLCcBMCuT
	syzuVWo/2N9jFNhcvDBSxK3vxboai7Q=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf05.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781674501;
	b=CbJsjMIXPEKcVuKyezkwRlJ694XAkKohjhfnK5E0ZQCuVgGgmEctNOMbSgqEJzqkrlmuS3
	t0jTUamotZk6R/ytr6uPBx4poHiDyqOoFSG8mm1Iel3a5ka51SO+lsFmP2EnV3cNebNEEg
	u7hQLOMRsQsfaFNfhOXSvlftFaE546g=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 17 Jun 2026 14:34:58 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	yosry@kernel.org,
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	hyungjun.cho@lge.com,
	mkoutny@suse.com,
	baver.bae@lge.com,
	matia.kim@lge.com
Subject: [PATCH v8 4/4] mm: swap: filter swap allocation by memcg tier mask
Date: Wed, 17 Jun 2026 14:34:47 +0900
Message-Id: <20260617053447.2831896-5-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260617053447.2831896-1-youngjun.park@lge.com>
References: <20260617053447.2831896-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 1r5iy7zgroegq85qckh4941siwnu69ox
X-Rspamd-Queue-Id: 57FE1100004
X-HE-Tag: 1781674500-253755
X-HE-Meta: U2FsdGVkX18ZScB+m6/WH0pnIZ3olTaJoFKlcmGeY8OllqKEYWD/7x2aGy3OJcrEtA/TOvh4nxiFN0b9Yi8++S3r2aIDRIYwR+C0Wr6RQ1PvfibmtfUDgO5X8f5cBIAdIh9uM4T14nTW5iVXG/hu7jaY7wthIZCNEznw9yESbdN5ExjT6tx9xjsnKTy6g4iPIyoTlj3WgAFy8FZ3iymZPBlDKjDtyHTXAR3wcbfFSHI7rHzJ/4mQ5oNwYe34TxXG19B/4b65TzYlMIjxmSXI0dAJTVkPWQLL/Inp+KZ7wv5Hg+egaLcO6j8lw3JJry71rXFi81GSLNp2MThFfVllZ2g+Uu0bkcqvyLKW9mXiJd2QR9sRiOHktEjmw5SXgqAoL3ucqNrGCvrBENOlpwDurnR1BEJx2DDurjSN30vAZVZBmTYFwRrNeUZXVdlTT1lyu8AwPv3aooALUPQX++X7wKj7I5rmS4ZmmnH9CvCbSl0p4uYaBnqBrkjT4vMKhFrgKp1vekO7nafHnBohKBWUFntgBepDb1V81+W0APLOZ5gzCLvspzvI/5I+yxeA+5dtX3SCrYmvpayqPUYFHPtO+Xjg363OboH9EPh36mulYwVZAxW43NBokJfVSAmhADoRz6xjAgg9EzKZR9Po3thmmqz4PWd1pdG0DhD5rAE1K3E7qUUo9eGllVLnKOHBDCXLsfaqUkYVq/uE+x+aMh672P48JagmaxwsotiRB4pt3CbmfOX3APzDA2DcMvm0tmIiZGd3QkgR8LDIa02BaVb1uyqBZ4kuoLGqMCgm0+YMn1tSNRCp4qRmEKLnkWZ8mftw4i4F240IynoBnVD48R7kvXChfQPcT2VxAFavwaKe7xYiiDRo0nNW6C3zhD0l3W3D5tTTZBCSS60JIUdyC+obsRzGUN45+KSsW+eBSmZttweCSnQClUAjLBJtwp+trgjtlOcF5ZfXry6nrNC8V3L
 RKsJLtqC
 d2nBXrZysAPXVMrHqIh/Brf+IWFzmv8PHzcq/Vx2r23X3y7yb4NFYkaAmHxqaj8gVgu08of9fcvMXpolLaMLzvdYNdi6whvmrWFC6/DwMIZa8T0jPvIH0m+73ER+LbUe5oDEBD7RzH3mWnEPNzllCwiUX3cJCPIUZWNvK+XwFKbD0iBeAGQ6P4AYFEeGUqNJLDtd7GpECSm8oOr4=
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

 - When non-rotational devices are distributed across multiple
   tiers, and different memcgs are configured to use those
   distinct tiers, they may constantly overwrite the shared
   percpu swap cache. This cache thrashing leads to frequent
   fast path misses.

 - Combined with the above issue, if same-priority devices exist
   among them, a percpu cache miss (overwritten by another memcg)
   forces the allocator to round-robin to the next device
   prematurely, even if the current cluster is not fully
   exhausted.

These edge cases do not affect the primary use case of
directing swap traffic per cgroup. Further optimization is
planned for future work.

Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Signed-off-by: Youngjun Park <youngjun.park@lge.com>

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 9a86ebe992f4..1a2d29735b71 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1365,14 +1365,18 @@ static bool swap_alloc_fast(struct folio *folio)
 	struct swap_cluster_info *ci;
 	struct swap_info_struct *si;
 	unsigned int offset;
+	int mask = folio_tier_effective_mask(folio);
 
 	/*
 	 * Once allocated, swap_info_struct will never be completely freed,
 	 * so checking it's liveness by get_swap_device_info is enough.
 	 */
 	si = this_cpu_read(percpu_swap_cluster.si[order]);
+	if (!si || !swap_tiers_mask_test(si->tier_mask, mask))
+		return false;
+
 	offset = this_cpu_read(percpu_swap_cluster.offset[order]);
-	if (!si || !offset || !get_swap_device_info(si))
+	if (!offset || !get_swap_device_info(si))
 		return false;
 
 	ci = swap_cluster_lock(si, offset);
@@ -1392,10 +1396,14 @@ static bool swap_alloc_fast(struct folio *folio)
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


