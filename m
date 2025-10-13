Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF0EACCD187
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 02:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B50F8E000A; Sun, 12 Oct 2025 22:58:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38C878E0002; Sun, 12 Oct 2025 22:58:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C9118E000A; Sun, 12 Oct 2025 22:58:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1AA598E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 22:58:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DDD2C1191D4
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:58:57 +0000 (UTC)
X-FDA: 83991583914.30.C5664F0
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id 50A4D100011
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:58:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=IGISrT4A;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf05.hostedemail.com: domain of BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760324336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z4Pvwj709tUIujzcrgBwlwYYOtJwMTZtthARYMcLmnU=;
	b=gGIrM2AFn7In1WF0WibDtlHKzXpn7d0DLIEFUcyooDxJhzCbBGH/KiC+9lzEpkvBMbDp5t
	YoI8WSzZWxyewilvmeW4luCGx8OqHQarLsMKIXY0gtfNAXC9dxndvlfAaJckXVfba0frWA
	ddxiliqe8lqY9AFZM/QqWsLOlqEoyAY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760324336; a=rsa-sha256;
	cv=none;
	b=Re7h+zcrFuQCd2gy4H6wDt0cBQCidy4TyTSJPtYukaQHtRotLxXobfFtaopVPuNHHXY/Or
	WlU9wU6s/SBVs2seoM0QlAMsoII0kUSXm5dISOJ65ks5LBj6Mz2fBhihAJUEHWYn5nlq+z
	SfTpHMHVGWS7ZfTX28jHRuMuhm4tIcg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=IGISrT4A;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf05.hostedemail.com: domain of BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Z4Pvwj709tUIujzcrgBwlwYYOtJwMTZtthARYMcLmnU=; b=IGISrT4A0zRp9+72rVC63vG+be
	MeouiH2AEc+hK7VS+eL1rgjzwyHPvzKg4hX/NWwh6A8jTl/bqkfGVgAywt5EKWplmYrMYmzbSYOhQ
	rbt2127+Op8UfselRfLJauGl3NMOwkPdvohF3jws5kPXlzjAxqy06JT2PkQhSmATn5ZOy4U8EAvu/
	DJFH+eQvhZ8geZEyeDO10vAxVXO2XELnDebigYpYzwYF/viNaVIPhk43fsHoXpKP6p2Zsx8iPT6Pn
	y0HQEISCdiFCziTkwVsQTfBW9DTOT6qKRyBMbUAa12/U4J94pmOhlG8Hqq4v64CjUC4iC33ck1vS7
	te4NMnvQ==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88lv-0000000C8D8-0VSF;
	Mon, 13 Oct 2025 02:58:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jan Kara <jack@suse.cz>,
	linux-block@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net,
	ocfs2-devel@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 05/10] btrfs: push struct writeback_control into start_delalloc_inodes
Date: Mon, 13 Oct 2025 11:58:00 +0900
Message-ID: <20251013025808.4111128-6-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013025808.4111128-1-hch@lst.de>
References: <20251013025808.4111128-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: 50A4D100011
X-Rspamd-Server: rspam02
X-Stat-Signature: tabwj17dnxu7gpn3t7z44b6waar9qhxc
X-HE-Tag: 1760324336-845881
X-HE-Meta: U2FsdGVkX1+fLhewr1/jES4OOZv6e6nIB2RMdC3Rvg9RGwhO2PNURq6AM+V2Q5P4h6vF7eT4RcRFSGBtA2jkXB41dI1lfMS6cO5jY3Uxk9BA6fz6TuAoCdvEiSpJhJf06BK4n9OeNYefUhTQatGIITiCixpAEzvRMaykIUr+21soa+7EMVYtTflqR8HwOyLagJ0xoV8/X7uyChF8Q5qE2QdqoHcBBfGZTucznX+BF9awcI3SeaNMzeQETrrcs/Qw5dRZShqrSCtLe3D4/B94p6v9gqhZdtsH63p9MkAexEokb+9HAPzTzugQvZ0kNUOVujHmiAStikrt6Jgx1Sqt3sMMQNt7a+84PA26h0SV7U6/xhZ+Ckmr8ZjxWwixB5IZMvd5vlfZy+CmVdfxzx2canBzhcbWjsKau3y2T1hyCZcU6qRVfwp3vUsxG04yKqJfwzliDEG/bRbBUMPtPfmER2nyy5tLz1+aUM+oeQcAX9hUCuPmVb8HM7P11J4YAALTgnzsfqrsJmVVRUoFZ3qzmN7UV0pKM9xA9LJctrGwZGPdSQJsrVRHXiV96oFrXq9ZHoRzVdMNQHRhVy9me+PM6C6FiOaliXb273Y8LP3iX5+1w6eci8IZHQzuhsTpFgkr7pXmMaP+Roa6DjULl41Cav+FTnAEUQcAReeYGjU7TpoVuMqanqrYHp/G+uD8+q1eLea18MsN4HVvZW8AllARsl2ZurCEJ//ukyYACwTOvlWU36oUIWkcQ3OBLVNyggrXVtdfZXjBzO4rhdPBvM67W7poiaLCkrQswa09OJkl0N4tZCrHaxTB5I7R044+M284QqjLPZl5dJyWuIR93BspTHrEFZkasvwYXV0bmsi8EqOkdZ2cNPrFat2CULz04YYoYawoZ5IB/Omuy5UQd8nRDIdL2TfenZQe1PPn4yCPaiDAJIvtpgUPJHx2lYCBs/vdnIVc4Iow3nShnaq8kqY
 InWVEGA8
 UFtK/VBykuXbj0mTuMgCSXTt8fFFvQ8ZqhW7oJeJY3DY8miPD0R5BzSuyExVjyGIiYUCusxkVZ1z1N6yzuc1jfKkb9ASEo4/YPVY59PQF5CzYAvz5NPP/Lbi5pSOe9MPqWYrH2qp86TzB7jP9U5R5juVdLjEEJ1Iky9uKok+eESOoG0SADQCmJefAGJgsV0K6LPurcjVSWbqi8ED4gNLu05xQSabpEWuDJzptsnuYcP/ExO4M6L+Pg1B1uhJrxkujmdyxXCsa5tS5/pQ52yhbVc5Av1wtZbk81DweXJLLC9kVv+G7D/VhL+8bPXw5AS+9ycJGI43NZWl+J2f7szXlQBIPazPYLJwIkOO3GN69zndpm81MPmK6O/JkwAOnttexlbox7IRNbyxtNOz27yz6CnkXBh0/YiA/CZXC6Yn0kUU9O1E8tRoFX/TzQoRgvE1XlHt+VVrqKsS6bE6zF5EiCKUsvicPziDDsiVj1tqggkQMtjqv5UZ8HJmUOUjNZpcOdy82P4G8g9dEEedq+ZTsgYeNUSWO5y2yV3nUAGlYXhqqJOCHWEwm/sJaFWI7507AaWiE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for changing the filemap_fdatawrite_wbc API to not expose
the writeback_control to the callers, push the wbc declaration next to
the filemap_fdatawrite_wbc call and just pass thr nr_to_write value to
start_delalloc_inodes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/inode.c | 51 ++++++++++++++++++++----------------------------
 1 file changed, 21 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9edb78fc57fc..b97d6c1f7772 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8709,15 +8709,13 @@ static struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode
  * some fairly slow code that needs optimization. This walks the list
  * of all the inodes with pending delalloc and forces them to disk.
  */
-static int start_delalloc_inodes(struct btrfs_root *root,
-				 struct writeback_control *wbc, bool snapshot,
-				 bool in_reclaim_context)
+static int start_delalloc_inodes(struct btrfs_root *root, long *nr_to_write,
+				 bool snapshot, bool in_reclaim_context)
 {
 	struct btrfs_delalloc_work *work, *next;
 	LIST_HEAD(works);
 	LIST_HEAD(splice);
 	int ret = 0;
-	bool full_flush = wbc->nr_to_write == LONG_MAX;
 
 	mutex_lock(&root->delalloc_mutex);
 	spin_lock(&root->delalloc_lock);
@@ -8743,7 +8741,7 @@ static int start_delalloc_inodes(struct btrfs_root *root,
 
 		if (snapshot)
 			set_bit(BTRFS_INODE_SNAPSHOT_FLUSH, &inode->runtime_flags);
-		if (full_flush) {
+		if (nr_to_write == NULL) {
 			work = btrfs_alloc_delalloc_work(tmp_inode);
 			if (!work) {
 				iput(tmp_inode);
@@ -8754,9 +8752,20 @@ static int start_delalloc_inodes(struct btrfs_root *root,
 			btrfs_queue_work(root->fs_info->flush_workers,
 					 &work->work);
 		} else {
-			ret = filemap_fdatawrite_wbc(tmp_inode->i_mapping, wbc);
+			struct writeback_control wbc = {
+				.nr_to_write = *nr_to_write,
+				.sync_mode = WB_SYNC_NONE,
+				.range_start = 0,
+				.range_end = LLONG_MAX,
+			};
+
+			ret = filemap_fdatawrite_wbc(tmp_inode->i_mapping,
+					&wbc);
 			btrfs_add_delayed_iput(inode);
-			if (ret || wbc->nr_to_write <= 0)
+
+			if (*nr_to_write != LONG_MAX)
+				*nr_to_write = wbc.nr_to_write;
+			if (ret || *nr_to_write <= 0)
 				goto out;
 		}
 		cond_resched();
@@ -8782,29 +8791,17 @@ static int start_delalloc_inodes(struct btrfs_root *root,
 
 int btrfs_start_delalloc_snapshot(struct btrfs_root *root, bool in_reclaim_context)
 {
-	struct writeback_control wbc = {
-		.nr_to_write = LONG_MAX,
-		.sync_mode = WB_SYNC_NONE,
-		.range_start = 0,
-		.range_end = LLONG_MAX,
-	};
 	struct btrfs_fs_info *fs_info = root->fs_info;
 
 	if (BTRFS_FS_ERROR(fs_info))
 		return -EROFS;
-
-	return start_delalloc_inodes(root, &wbc, true, in_reclaim_context);
+	return start_delalloc_inodes(root, NULL, true, in_reclaim_context);
 }
 
 int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, long nr,
 			       bool in_reclaim_context)
 {
-	struct writeback_control wbc = {
-		.nr_to_write = nr,
-		.sync_mode = WB_SYNC_NONE,
-		.range_start = 0,
-		.range_end = LLONG_MAX,
-	};
+	long *nr_to_write = nr == LONG_MAX ? NULL : &nr;
 	struct btrfs_root *root;
 	LIST_HEAD(splice);
 	int ret;
@@ -8816,13 +8813,6 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, long nr,
 	spin_lock(&fs_info->delalloc_root_lock);
 	list_splice_init(&fs_info->delalloc_roots, &splice);
 	while (!list_empty(&splice)) {
-		/*
-		 * Reset nr_to_write here so we know that we're doing a full
-		 * flush.
-		 */
-		if (nr == LONG_MAX)
-			wbc.nr_to_write = LONG_MAX;
-
 		root = list_first_entry(&splice, struct btrfs_root,
 					delalloc_root);
 		root = btrfs_grab_root(root);
@@ -8831,9 +8821,10 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, long nr,
 			       &fs_info->delalloc_roots);
 		spin_unlock(&fs_info->delalloc_root_lock);
 
-		ret = start_delalloc_inodes(root, &wbc, false, in_reclaim_context);
+		ret = start_delalloc_inodes(root, nr_to_write, false,
+				in_reclaim_context);
 		btrfs_put_root(root);
-		if (ret < 0 || wbc.nr_to_write <= 0)
+		if (ret < 0 || nr <= 0)
 			goto out;
 		spin_lock(&fs_info->delalloc_root_lock);
 	}
-- 
2.47.3


