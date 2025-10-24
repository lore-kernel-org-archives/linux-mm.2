Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD15BCCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 08:05:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11D878E0052; Fri, 24 Oct 2025 04:05:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CB618E0042; Fri, 24 Oct 2025 04:05:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED5CB8E0052; Fri, 24 Oct 2025 04:05:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D89F98E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 04:05:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 86A15140D92
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:05:34 +0000 (UTC)
X-FDA: 84032273388.11.5C11765
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id D2C56140011
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:05:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Nxh2wQrT;
	spf=none (imf09.hostedemail.com: domain of BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761293132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HFCXEpMyRERJ1MwMepDPNZBfWFxG38qqyTmW2WIeDn0=;
	b=dgXk4O73xJ/elQkIwBLKbJtAhaRvOgDD8wD2m3cIg7GC6tbFPAy03jj5qwI0mVFjXCtXRx
	lgFkZgMp0u5x+KORfP8F5HBmnfg49TJcjNg8tNKKiWlLhpHpPG1IeuTH/qxKbJszjEeIoz
	meq4X/4spA5vnHm0b2yv/Ql4yI6txdI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Nxh2wQrT;
	spf=none (imf09.hostedemail.com: domain of BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+aa390122061dbb70398c+8097+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761293132; a=rsa-sha256;
	cv=none;
	b=6mdzWBhuErh0FaBJHXYukBl05D4wQcAvMIlmavsu5lGyev9MwaHjYZ4CWE5F6l59Jd3XaX
	UeNX+cQn0cWMNgDck/beHc+dHyXBwzck8gNHbNXjTHpJn4jV+M7sDDHMcnR+7aJcTXnb3m
	Ob0s28EB8JGwuiZjedJfQPxRI7pIfF0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HFCXEpMyRERJ1MwMepDPNZBfWFxG38qqyTmW2WIeDn0=; b=Nxh2wQrTuIGOrxqNCnyp2wy2Hl
	0l9Fn3i4pvhqkLFHCBGaZyx+R5NE8QCsHdx2u7jBc2WWrh3bxd7IlKjw85/WT1zBvnMFhjKcvLsz1
	BlyxxMrMZCYOs2Jn/47etrVAFg1tFIntSLJkUWkVImXeD1YQYRNBDGu5hv6zdkiSmzlPz140HumRF
	M8LMux2RQVIMwF6FzOrNv0CigcxyLuCzykGDfvvd0fCpOTEZ74w3TG15jmh/ZmKjeroUnswjBbTkK
	aBXKOnCox1hlR+VYel+THQRRtZpRFtZKXsqzMawvTaVF6pMNc3c4pUpxifmpWyq0yZXScNiMq+MIB
	maD1NM5w==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCCng-00000008cCC-0IyG;
	Fri, 24 Oct 2025 08:05:28 +0000
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
	linux-mm@kvack.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 05/10] btrfs: push struct writeback_control into start_delalloc_inodes
Date: Fri, 24 Oct 2025 10:04:16 +0200
Message-ID: <20251024080431.324236-6-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251024080431.324236-1-hch@lst.de>
References: <20251024080431.324236-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: 9bf85chzx39ibj9ogpjw9abw86aia6hi
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D2C56140011
X-HE-Tag: 1761293132-248236
X-HE-Meta: U2FsdGVkX19+iULziWl1HP85SV4QJMB5olFNimYbmRiA1GBmsUvCHN8Pd35YLnmo3x19Hbl3S8SdLYWnzNa7dgBmpS9fQrOCslJxeByNWPQCnEueZr+4Mwc5n65nxPNCrYR7WnGUwp3V1yjnykqKXPy+bSNYHwYnBv7GgcjyEx3o6+iNEaQTDfbLcnqQauREa1AdcsY2u6k4oWKW3dweer7cPwW3BTRaD/fAqny7XU79l5H+Vba6+4Z0twAEAAmjn/tbSLTLXKYxS4fs06RAUGBsrecBSnsaQ46Uwn1dtpdNcsNQC4VER3HHVHo8KKVHDivBpYO6LOFaiQojXuiW7n0DG7VLq83o4N3dHexaUq0hPnBq85SPyqSFzCTRDPCuhM3T3h1vLl3KSBwIAv4rpD1GMvwSgjyL4ELRPVkQF/94L9BCWm9/AIdYjVwgj+3y0bw+oNqRVeVtdNfEFh7zgCICYrGV6L3kQEdYppXWMN8qUhGYH+O1hnfk1l48Hy7EMVFZMbha1mGEbpBfAC92fO283xKp+aZqKYkVs9bDKih9BvJ2n41sm8nj8zmt2Q9rCYimn4/DsGxmSmIoyRAe/sY4cTQwJAuga6EtbcYp05tbbdlvy5CVH3NeFLbUUlZHRL3p6gUDSKDQhIFQZfOqoyWsC97nAWjWgLh+Uetdg3gwef593B8e9Wmy6HJ3OCKMHG3BpzTe0tCNQJgdR0kjMS+yigzndVleQTM7IpfyaDWVqVuYYs1no49hiZEGQayEX8aBEOwJVKFUgn+HVRSlfe7LpkIw0MqOl92c0sHfEILYJ2Bskf3l7M05fUzDuFXOi0c3lM4+ieRAB6P6wFHNusAIUL/WotLtkWp2/nzgdQRRxfWY2PtjwPa7O4O7Hil4PHrWn8AQzxjf+KKTrbdl731KwL/NRrHRv+e5vpoShLtGwzOiA2PXgr9N0OMSyFeZxNEf0D84LKYo9Q1x6ug
 VGkKoeoR
 EGSeD8jTBQlfS08ixsQqAL8O0+U2xKw4QF1jQPjSl6tb0/FazO8cPeF7CYfFFgy8w5eCCUOwpsUxd5M7zjfJWrEbDrnVELTERvnxL2pHg9ZQL+2Ria6ZlKUB+BQtUHsumACuxW0TAgkY1Rgi/qoMkv3h4bKdb5XcJyg420/Mz/WnDhxn4tYGWwcPITDgSkpwGZIeZoRdjU6WzVFR2mpwynW/pNRJsGqdICN7zsiALYv8He0csnhrNpzmsssZIwOrBShDjtRApHZUXi8fNdSIr/mcEE08+7A8sG7C2Fb4s8Bnxr84Wyl0meSqpGTStZZhrbXktc3T8Z3jLeYJJtaZM2fxrLDiVwMpElpi3Lr6tNxnlW21C2S3t4pzV3tqtw2wxT7TAtMIdy6qBjlhXvq1raZWcxwyVy7bIl/3IVQ1jOcFDs8fB/IWZCQlz78awOIsa1zkNMfqYfoVQ2IkVOv2zXD6yeNKNN/3S15Rtt/HG53A1UQZ/BEY5ANPNDgoTJ3uQuEKKkQOC7mWYrbqUUiLXWF354R2avUTymKuKXkNd9ziMwJecqqeBzglqp4HAsi/SnT7CMFQIGwAK+DUa8uIC553ynQe9w49HK4hZAPhC1oq6c0LIajC3dIIDfJegJ1u1s9WlW5cySBH432dxI0jV/oYcLXHHHZ4w6F+te18OwbEOen6A3zib9S45qg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for changing the filemap_fdatawrite_wbc API to not expose
the writeback_control to the callers, push the wbc declaration next to
the filemap_fdatawrite_wbc call and just pass the nr_to_write value to
start_delalloc_inodes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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


