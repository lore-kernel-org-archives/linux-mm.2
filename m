Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 724A2CCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:42:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC8C08E0016; Fri,  3 Oct 2025 09:42:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A79C68E0005; Fri,  3 Oct 2025 09:42:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CCC78E0016; Fri,  3 Oct 2025 09:42:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6AB588E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:42:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20918BB7CD
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:42:47 +0000 (UTC)
X-FDA: 83956918374.27.093C32B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 52658140007
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:42:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JXFjWAXu;
	spf=pass (imf09.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759498965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Et0fA0J3PfpZu5gQ7GEVQDl1tjZdPv5uyoClL2a5pp8=;
	b=GJU7U4e0y+s6bLXYiq5/sYk9ZKcHJqnwz++XIyIaqKwDNbevI0M14BxkC0d7/bZNe4oaPQ
	dLbQblfjoTB3y8a0Cai7Mc5LrpcvnsZ5MB8tcGQzStGW+aMC7F9z4zfpqJww1QRg1r67G8
	AsF2pWjwCDKehKhTi0U0Su9mMit//7k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JXFjWAXu;
	spf=pass (imf09.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759498965; a=rsa-sha256;
	cv=none;
	b=AdSVM+5Xlo3m3ZbfY++SywTRnURTA3r+wX0tu89C5ThkpI0fnhs10D+G2HfiAHb7iGvgoS
	gg9dXXkk+SUfdkMc2YyRby0ZdvX6qtuaO+zH9SRcXqAXxzb7YABau6H86xw9OvFrI6WHr8
	h2xXHLm2ylGWecZf5reIe4dYtjuIty0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759498964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Et0fA0J3PfpZu5gQ7GEVQDl1tjZdPv5uyoClL2a5pp8=;
	b=JXFjWAXuGMvrhu3ckkGsPGH/B8G17zj/0NPbeVGlYGVU6jRDVpNYww3imeZYsgS4mxze5F
	BWFhKwvq5j/aLE+7fm9qVBU8JeaUsJEvkxM8gpQNiU+MPeDxr+ueIwqm2ngYLwksM5+Kqi
	JKSAj7DGlm/s0SVKdmx9QtTSBEtaABE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-124-5mfxIH3IPau_TswXy9ppLQ-1; Fri,
 03 Oct 2025 09:42:39 -0400
X-MC-Unique: 5mfxIH3IPau_TswXy9ppLQ-1
X-Mimecast-MFC-AGG-ID: 5mfxIH3IPau_TswXy9ppLQ_1759498957
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B8CFA180057E;
	Fri,  3 Oct 2025 13:42:37 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.54])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5E9B519560B1;
	Fri,  3 Oct 2025 13:42:36 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	hch@infradead.org,
	djwong@kernel.org,
	willy@infradead.org,
	brauner@kernel.org
Subject: [PATCH v5 3/7] iomap: optional zero range dirty folio processing
Date: Fri,  3 Oct 2025 09:46:37 -0400
Message-ID: <20251003134642.604736-4-bfoster@redhat.com>
In-Reply-To: <20251003134642.604736-1-bfoster@redhat.com>
References: <20251003134642.604736-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 52658140007
X-Stat-Signature: corkc81dxxtw7gnimhut55ra146uctay
X-HE-Tag: 1759498965-838126
X-HE-Meta: U2FsdGVkX19sB4mrhH6aAxkzsBSWLsuPuLhYAy0zklZLITGDEISDueLZ3gRsybdOPt8/5MRAAI1Cgek4/eBlNxhMlHYRx3nwM2CrpIo8r1utLOKWg6u0I3dADDNZyXLhe5pKcm3x7/XpULHOeBfQpx+pY8/ECibhk0c1ca3cceBqGdTu6nX0Bi7dhCV7BY83pCq4ifcWZj/by1aB2oYmEao4gGe3U2kFO2YNoF7/WMivh18hW5p7nxroxdiHFCAuM1EIVjPoY/UL2rB4Mg7u79Q+JjvvRE3B2BSzR+Kgh65W2jOkC73poQhbslqglj1K9sRfvD4acT6ui2p6owpBMmxjqxAvnYAo9rrK9wABAA90gUK8QzQAWQDgXbsch4ZSDVSM/QFUBo1ZjSsAdF1x0fs+kR3OtbzugbiyiOlYzucv3i9+B9GHvwU9rgCJDXvGnyDruZMkNfVHRIxl5iT5T80QmdpZ0ZzdLEbB7hIpwgnEiLsjEEJKnE+BTegj6YV2f+ujepEpSvNRyQp3tVQwK2yoiVl7TIgo4UTZlXZu4LtqGVCGVlAQKdoq/XXpgyBMv5g9xyyxBGp1SyJ6ZBZdz4yED6NITZvKOhH/jvgXCGOsgZLvAZH4BhOztNuhtGoVR18oez81c0Qdhz/BSjkJvkKjXH3WH939AcKUq2dfZMrlZ7QP4LksCWtxaWibZgmzmA2RyeapaA9++UjVXI5qzKuhsq8cWZhjw5d1Yd9qOU1pfxMK3Jl1vB7jZbjHNd7rdyfHbMMD2bAcAnKXXIzXMHl3YQkKZb8ibia9LNiE+M9QZP90RuZwzdxNWho/mcLSWgH8A90Iy37vx14TTp0BIvdgbLcMO/Z3uKzVkGuiSJnFO+a8Kbq4LGkMAs7FuWylCRW/UCnieBIOhvjQPjQ4Dtoux28IbAvUDlGsyVYPDYpeyub6Y/M4picg6m0wOHfVdRg6sY89K5aIqMoLwyF
 pkzlIv9H
 OtLCAtyfP55ZbfZ4GK6I90tOwIK5XkwiwOhvm6GqChXIP8n0jZ4zjF6QkZCDzx45PKjiw346XS5dYrAQvA8L2Hr/lNcfLj9D04kKYEm2GcDH0Wu/adkpk0jnZCuhYpcut8XzMeaqjGE5FhAp5qcfqxiQb0XmzDGu2Zsi8mkFlwzy7ZTSod8SB+QowVDitM1AyBvodkk41TejE/vIFC9yYpzBWsocM8/occEe7uoEwCYHUUinaTfujbiFjyspfRFuobeEZrSc9Ww1uEjNeoCSgUr1vPplp/k3Q45sQJYQ34ZVF76bKqc+CgVKlOYMQT+RQC55tkf/vlWfZojmyZ8CasIsxy28d/tEsqdzD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only way zero range can currently process unwritten mappings
with dirty pagecache is to check whether the range is dirty before
mapping lookup and then flush when at least one underlying mapping
is unwritten. This ordering is required to prevent iomap lookup from
racing with folio writeback and reclaim.

Since zero range can skip ranges of unwritten mappings that are
clean in cache, this operation can be improved by allowing the
filesystem to provide a set of dirty folios that require zeroing. In
turn, rather than flush or iterate file offsets, zero range can
iterate on folios in the batch and advance over clean or uncached
ranges in between.

Add a folio_batch in struct iomap and provide a helper for
filesystems to populate the batch at lookup time. Update the folio
lookup path to return the next folio in the batch, if provided, and
advance the iter if the folio starts beyond the current offset.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/iomap/buffered-io.c | 89 +++++++++++++++++++++++++++++++++++++++---
 fs/iomap/iter.c        |  6 +++
 include/linux/iomap.h  |  4 ++
 3 files changed, 94 insertions(+), 5 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 211644774bb8..a830ae5f5ac7 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -761,6 +761,28 @@ static struct folio *__iomap_get_folio(struct iomap_iter *iter,
 	if (!mapping_large_folio_support(iter->inode->i_mapping))
 		len = min_t(size_t, len, PAGE_SIZE - offset_in_page(pos));
 
+	if (iter->fbatch) {
+		struct folio *folio = folio_batch_next(iter->fbatch);
+
+		if (!folio)
+			return NULL;
+
+		/*
+		 * The folio mapping generally shouldn't have changed based on
+		 * fs locks, but be consistent with filemap lookup and retry
+		 * the iter if it does.
+		 */
+		folio_lock(folio);
+		if (unlikely(folio->mapping != iter->inode->i_mapping)) {
+			iter->iomap.flags |= IOMAP_F_STALE;
+			folio_unlock(folio);
+			return NULL;
+		}
+
+		folio_get(folio);
+		return folio;
+	}
+
 	if (write_ops && write_ops->get_folio)
 		return write_ops->get_folio(iter, pos, len);
 	return iomap_get_folio(iter, pos, len);
@@ -821,6 +843,8 @@ static int iomap_write_begin(struct iomap_iter *iter,
 	int status = 0;
 
 	len = min_not_zero(len, *plen);
+	*foliop = NULL;
+	*plen = 0;
 
 	if (fatal_signal_pending(current))
 		return -EINTR;
@@ -829,6 +853,15 @@ static int iomap_write_begin(struct iomap_iter *iter,
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
 
+	/*
+	 * No folio means we're done with a batch. We still have range to
+	 * process so return and let the caller iterate and refill the batch.
+	 */
+	if (!folio) {
+		WARN_ON_ONCE(!iter->fbatch);
+		return 0;
+	}
+
 	/*
 	 * Now we have a locked folio, before we do anything with it we need to
 	 * check that the iomap we have cached is not stale. The inode extent
@@ -849,6 +882,21 @@ static int iomap_write_begin(struct iomap_iter *iter,
 		}
 	}
 
+	/*
+	 * The folios in a batch may not be contiguous. If we've skipped
+	 * forward, advance the iter to the pos of the current folio. If the
+	 * folio starts beyond the end of the mapping, it may have been trimmed
+	 * since the lookup for whatever reason. Return a NULL folio to
+	 * terminate the op.
+	 */
+	if (folio_pos(folio) > iter->pos) {
+		len = min_t(u64, folio_pos(folio) - iter->pos,
+				 iomap_length(iter));
+		status = iomap_iter_advance(iter, &len);
+		if (status || !len)
+			goto out_unlock;
+	}
+
 	pos = iomap_trim_folio_range(iter, folio, poffset, &len);
 
 	if (srcmap->type == IOMAP_INLINE)
@@ -1395,6 +1443,12 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
 		if (iter->iomap.flags & IOMAP_F_STALE)
 			break;
 
+		/* a NULL folio means we're done with a folio batch */
+		if (!folio) {
+			status = iomap_iter_advance_full(iter);
+			break;
+		}
+
 		/* warn about zeroing folios beyond eof that won't write back */
 		WARN_ON_ONCE(folio_pos(folio) > iter->inode->i_size);
 
@@ -1419,6 +1473,26 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
 	return status;
 }
 
+loff_t
+iomap_fill_dirty_folios(
+	struct iomap_iter	*iter,
+	loff_t			offset,
+	loff_t			length)
+{
+	struct address_space	*mapping = iter->inode->i_mapping;
+	pgoff_t			start = offset >> PAGE_SHIFT;
+	pgoff_t			end = (offset + length - 1) >> PAGE_SHIFT;
+
+	iter->fbatch = kmalloc(sizeof(struct folio_batch), GFP_KERNEL);
+	if (!iter->fbatch)
+		return offset + length;
+	folio_batch_init(iter->fbatch);
+
+	filemap_get_folios_dirty(mapping, &start, end, iter->fbatch);
+	return (start << PAGE_SHIFT);
+}
+EXPORT_SYMBOL_GPL(iomap_fill_dirty_folios);
+
 int
 iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
 		const struct iomap_ops *ops,
@@ -1448,7 +1522,7 @@ iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
 	 * flushing on partial eof zeroing, special case it to zero the
 	 * unaligned start portion if already dirty in pagecache.
 	 */
-	if (off &&
+	if (!iter.fbatch && off &&
 	    filemap_range_needs_writeback(mapping, pos, pos + plen - 1)) {
 		iter.len = plen;
 		while ((ret = iomap_iter(&iter, ops)) > 0)
@@ -1465,13 +1539,18 @@ iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
 	 * if dirty and the fs returns a mapping that might convert on
 	 * writeback.
 	 */
-	range_dirty = filemap_range_needs_writeback(inode->i_mapping,
-					iter.pos, iter.pos + iter.len - 1);
+	range_dirty = filemap_range_needs_writeback(mapping, iter.pos,
+					iter.pos + iter.len - 1);
 	while ((ret = iomap_iter(&iter, ops)) > 0) {
 		const struct iomap *srcmap = iomap_iter_srcmap(&iter);
 
-		if (srcmap->type == IOMAP_HOLE ||
-		    srcmap->type == IOMAP_UNWRITTEN) {
+		if (WARN_ON_ONCE(iter.fbatch &&
+				 srcmap->type != IOMAP_UNWRITTEN))
+			return -EIO;
+
+		if (!iter.fbatch &&
+		    (srcmap->type == IOMAP_HOLE ||
+		     srcmap->type == IOMAP_UNWRITTEN)) {
 			s64 status;
 
 			if (range_dirty) {
diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index cef77ca0c20b..66ca12aac57d 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -8,6 +8,12 @@
 
 static inline void iomap_iter_reset_iomap(struct iomap_iter *iter)
 {
+	if (iter->fbatch) {
+		folio_batch_release(iter->fbatch);
+		kfree(iter->fbatch);
+		iter->fbatch = NULL;
+	}
+
 	iter->status = 0;
 	memset(&iter->iomap, 0, sizeof(iter->iomap));
 	memset(&iter->srcmap, 0, sizeof(iter->srcmap));
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 73dceabc21c8..cd0f573156d6 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -9,6 +9,7 @@
 #include <linux/types.h>
 #include <linux/mm_types.h>
 #include <linux/blkdev.h>
+#include <linux/pagevec.h>
 
 struct address_space;
 struct fiemap_extent_info;
@@ -241,6 +242,7 @@ struct iomap_iter {
 	unsigned flags;
 	struct iomap iomap;
 	struct iomap srcmap;
+	struct folio_batch *fbatch;
 	void *private;
 };
 
@@ -349,6 +351,8 @@ bool iomap_dirty_folio(struct address_space *mapping, struct folio *folio);
 int iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
 		const struct iomap_ops *ops,
 		const struct iomap_write_ops *write_ops);
+loff_t iomap_fill_dirty_folios(struct iomap_iter *iter, loff_t offset,
+		loff_t length);
 int iomap_zero_range(struct inode *inode, loff_t pos, loff_t len,
 		bool *did_zero, const struct iomap_ops *ops,
 		const struct iomap_write_ops *write_ops, void *private);
-- 
2.51.0


