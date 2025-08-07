Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C70C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 14:43:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65C538E0007; Thu,  7 Aug 2025 10:43:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60BD78E0009; Thu,  7 Aug 2025 10:43:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 485BD8E0007; Thu,  7 Aug 2025 10:43:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 262928E0009
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 10:43:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F19F41A0DE7
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:43:36 +0000 (UTC)
X-FDA: 83750230032.26.4CAC00B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3B29180002
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:43:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="X+P/I072";
	spf=pass (imf30.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754577815; a=rsa-sha256;
	cv=none;
	b=aunnyFvKwjdPWMrXLMq5EzvxYbgRF2VtHw7bj7LcAgzVZdVHSDgZGOcFShN5kQlyYz3XPu
	fPtsd1o3YkFEq4OvxjaYiQBqTk4yJsoMM0Z6KhK8m7jwqsPgK3/fHH3tS8/GmuveMB1jK6
	tDXaU6VJfAuZHN3Y7dCUFr96s4bX5+I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="X+P/I072";
	spf=pass (imf30.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754577815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qY7biOZG7+PCCaiuNAC9zxegZq8x+2X/aJDQ6Va10fU=;
	b=8XRl9l85fwCp2/d8hE6P0AEpgTYmBqRg+5CWCQQJkyFqMJIZzk3CnuhorhRNd2QuWknFIV
	Jo9myV5ocjbHS6yyrRJQ9vIMymVNT4CERbObcdUIBM/tsHEMgHT7ybVN4zrD2KhMdSWxP9
	j4TlPLO6s5KEyn4pbPbzE3Cii+elnR0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754577814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qY7biOZG7+PCCaiuNAC9zxegZq8x+2X/aJDQ6Va10fU=;
	b=X+P/I0724IgwseJxwmGTjGjfqgoIJ2ayEsmnzvtTad7VLiV0buGAGlvhDRg/aKMllzfVpG
	M5HUX9cU594fr0xzDWX1ejSYSpuAvjLFoZWWQCz5EruDUdMFCdNtWAT+04kbMkE8ZeQBMt
	ewpDruf2fzl8Sn9ipMIm1HJFlQpAsAA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-593-vlBoCs35OIuMC2q-41lKzw-1; Thu,
 07 Aug 2025 10:43:29 -0400
X-MC-Unique: vlBoCs35OIuMC2q-41lKzw-1
X-Mimecast-MFC-AGG-ID: vlBoCs35OIuMC2q-41lKzw_1754577807
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 262E9180035D;
	Thu,  7 Aug 2025 14:43:27 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.68])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D2E71180035C;
	Thu,  7 Aug 2025 14:43:25 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	hch@infradead.org,
	djwong@kernel.org,
	willy@infradead.org
Subject: [PATCH v4 3/7] iomap: optional zero range dirty folio processing
Date: Thu,  7 Aug 2025 10:47:06 -0400
Message-ID: <20250807144711.564137-4-bfoster@redhat.com>
In-Reply-To: <20250807144711.564137-1-bfoster@redhat.com>
References: <20250807144711.564137-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3B29180002
X-Stat-Signature: sffu6ujzqk6damf4bb1k1nu4qpa1j7k1
X-HE-Tag: 1754577815-545748
X-HE-Meta: U2FsdGVkX1/9PqyftPpcHx+ziIj8Sw7ZrdKC3bj4qybiZvylgMxC5yq2RzPf5fVpgF6Irb0AaukXYGALAWim9ShSDLGrEtHFXhCPOEuVKTcfLe/Vdi58qmUgrHZxE+2SgCzPheeavVe73vqNXX8LTaCAnO1gDR6cbo/E3a9f9+YqUIJXxxY2Tv+wuWkeadSY17J5dHMpMfcZhrMDDoru+WvttlsbKFv9vuzn2oJg2L9iNxOaz+qGOpfn2tIczD38U3GsAROS7CtLktuJCDQfilrWwuN0HR2Z7XmExhdCaakK9UTE8pODqrbzAEhCaPwSn87s8UP9vegXjis7xL1MuH2v5i1Od9Pi0orCmfp1a6GLcrbVj3uCsdt44vsHzngaHPbVS3Pd0cWZ3vYaPPYUJAr5ZnNj3PSVzEXlXZx/3d1CBKkDt6rDncNrHbNh0H/IMCci86wwfEMNCgs5hl2y23ze6TRdvjbf01dXz1xUeTlsQVBNh8ay2AB9ilumuKpGxd15J1PYzaHBl+tB5RWJ3mgZxGP4IUvGJp2h040xO25LfWl3qny+YMbt2lzt/dU552ZTYFAsszNQJTAYxs5GjHYw8jTJ6h1sv+KyUHxUeprrM7wxdQfMJ6a++WDQS/F4/q0NQu018UCwI5pOIaQUyLJxR/b3I3dwEvDB5r+lrTZe1dLC47O4bY4xWV52a4R6dLr0djX8Sd3t4ypnj5C7SYXI7EEd4L5hb/RUbtQ1WwJl+n4BFlPWD7uU5t/d+AMagaJqmXJ4lBE2JkHli7v3x/1R1E95wVa6Vu8dcUWFsJsdNxAu7xnnYoUXJ8xEajv3OfPuQ1/Xstit8Y2/M4mzLNryStUO0zbr148CFFHygN/9FEX4YsmMLjwo5q6+VGQQDk538rhiZPLBHTLPQizfFGgpKKDahG/+Spl2IIfpaQk9hxBhyzw0Bk+IP+eizeLJuSI+3C+/Jn4wYUNoce+
 9Jf4FL+V
 Wq4euyHQxW3izs8GUp14cUavat/vEwA1JXxjg2YHeTVmNeJrbtSJHXkPxMEX3TGUNnqopIvhX4h7V7bEjDwHn3u7aQO/B+LPZHBXp7UVu8y5tgwCMs0Fwog7eze/5Z0RdkdsP1mYtqCZn4QZi6Ud/qWBHF7xDulQwYM6xu8pdhYuh4ATOyfKuphdd6XU8KwW5KKTXk3VPKIfs/34tEAQoXLs91SG8pdccQ5hEpwo9ZfIyB1i3eNusZMXHvGfnHu546R3RqWVJu5E03AafRRjBtuQ2xQcFVEooIOspK4bnFwRG189qAZ8BZH+PiapgJMXXKXMT6/lREH0M9Y90S/wkNdGUFJGAj4yR+QIG
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
index 01721f10cf6e..a08a341c6f5b 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -758,6 +758,28 @@ static struct folio *__iomap_get_folio(struct iomap_iter *iter,
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
@@ -818,6 +840,8 @@ static int iomap_write_begin(struct iomap_iter *iter,
 	int status = 0;
 
 	len = min_not_zero(len, *plen);
+	*foliop = NULL;
+	*plen = 0;
 
 	if (fatal_signal_pending(current))
 		return -EINTR;
@@ -826,6 +850,15 @@ static int iomap_write_begin(struct iomap_iter *iter,
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
@@ -846,6 +879,21 @@ static int iomap_write_begin(struct iomap_iter *iter,
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
@@ -1390,6 +1438,12 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
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
 
@@ -1411,6 +1465,26 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
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
@@ -1440,7 +1514,7 @@ iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
 	 * flushing on partial eof zeroing, special case it to zero the
 	 * unaligned start portion if already dirty in pagecache.
 	 */
-	if (off &&
+	if (!iter.fbatch && off &&
 	    filemap_range_needs_writeback(mapping, pos, pos + plen - 1)) {
 		iter.len = plen;
 		while ((ret = iomap_iter(&iter, ops)) > 0)
@@ -1457,13 +1531,18 @@ iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
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
2.50.1


