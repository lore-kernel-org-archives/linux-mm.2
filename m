Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F2B5C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 00:28:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D34F8E0008; Thu, 31 Jul 2025 20:27:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45C678E0001; Thu, 31 Jul 2025 20:27:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 176DA8E0008; Thu, 31 Jul 2025 20:27:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ECDCD8E0001
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 20:27:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF262160CF5
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:27:58 +0000 (UTC)
X-FDA: 83726301036.11.F437E26
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1EF601C000B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:27:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MN4l7KFo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754008077; a=rsa-sha256;
	cv=none;
	b=169iiFyAewRhgYjf6DLgQu7J73RzCv4DAIR6R6XYQTg2gwegt3FnKAH3KfNR6b8OnPtV6L
	qLJbqD1x+ktRF0dVWR+0/YuzSiCfQ8jrzxqxad/JH1WA/YBEQIkLm3dmvMNbVc1fa9DQHF
	G/xBBqVcudjTO+urwl98rOXqX9lMGN4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MN4l7KFo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754008077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lgsCeFlo0QeXkQOENhkfXRkOGlZ0DSVecFbnvZAG94g=;
	b=Z79DepQlmBOJOO16BtDx+T3db5zArKcmRhMEBhy1FRxykRX/k2ufP6h/WLRds6OiyCYzQj
	6Y+hnTZCcT0kcbe1u2fdEFLV1slnIeg0qrGDqm7poFvkpz14vVGlUQdboK5hEUIcsUpSUY
	xZ0xJzjTupoHQ7xb6GsFtanB6y9NuaM=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-73c17c770a7so438390b3a.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 17:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754008076; x=1754612876; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lgsCeFlo0QeXkQOENhkfXRkOGlZ0DSVecFbnvZAG94g=;
        b=MN4l7KFoJwMAZDcBJsqaccutiuZ48TQdVxU0gsa4SMIK6WmLzm1VhZlALLRVc1+bEl
         k6c+uTrXgBukRwK37Uo7SC6S5ASYoy/rLL5v9k9b9v1erG8/sE3WXVeHBDXGQRhcWsLG
         MPudlA4buWPSXtACe5NEBM08GyslMXhDrdJtexY5HsIns5Isfw8XVADawsOcWhU7LB3y
         U9SWuuz8frrhYwJnkFrF63eTkEQax3jh3oeyYTfLbzMyfcN9xzANPGXdpzUDUfR3pUXG
         nIb2XKeLz3WVt0GWcvuo9GNwb/1I9cM5I34LqUuwU1eyZ2WeQbhWCcjevh350RJDA31F
         2TOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754008076; x=1754612876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lgsCeFlo0QeXkQOENhkfXRkOGlZ0DSVecFbnvZAG94g=;
        b=PhaOfFUxfc0nIgOUs6ZiXO/7sMQ5D3S/Bt8OKt8UqbrhRKNDF2ZrlDa7JAZ/PnoEGu
         0HHMvXUxXcIZHJeNztxiHDrCcNqXz4mV0NflV46+GGU5QlNuxGob4QJUmPyTCHt/pqMg
         SMtX2hHrXKFwNzehdSoqX9KsxrRSQKnKL8hoPVL4AX7iJJ/aZjhqfp6/2fbhDls34ZpI
         CyIRLeEDol7nOGkwwP2SzLqTgkLduc4rHHeWVjfdd/iIMiMai2imtDKoub5vm1HeFZjz
         +DnpQPiP0sZcNeB/WPb1VYO8oieETTfrDIFbkVgo4yy7yu9C1xj3qGkYUCoxcGXBRrDX
         fHmA==
X-Gm-Message-State: AOJu0YzL/6mVnppvasQ+qgjWTw5f/nwFNRZxfKtvPF0KxbCSAqnovPj0
	M9PaUpC0JOBz58mJZz1wWZXgeUcYuBukgtXIeiisszqLSvTjlXRb0UU63s+D+A==
X-Gm-Gg: ASbGncvX+GVPGMCUypklS2UMDpvwtHXaxILb44A75UbDUCyLeaPmsDAgRHsbLOCCFM9
	k6Fw6Y7r0isTfM1GZl/bV7OdwKgDBsyd3sAX0qb+06E/17q9Fr52ABeOjNDIO9yptJdQUy5wtrX
	XOYE8J6b0Rumt9ddTNkQYP5D4Z5CH7EDu1U6pCrUpwtOBbsuFfqYK/B7wi1j2TUQANPyxq7ZB5B
	Xn0D6bp8wtW/M9rN0njDUIkTjBQUni7KkS5sqlPbe9vqq5WgsRKsxwMmmvjNC8dDXer3W6vNm1J
	SuyYX41gJoj+Dp6pydSphifxp70yvhbi5y5H+0JFfKgLptQmVWS3td1RvEsuX/oooHdbtNkpwK8
	+xlQRoLjsLAP6z4Lyxg==
X-Google-Smtp-Source: AGHT+IGLxXer8eATe2FRIkXxTqTr2zgcYTUHYytich2j2hXUzi91lDRvJqlblF+//rSNcukGIlDAbw==
X-Received: by 2002:a05:6a21:6d99:b0:232:1668:849f with SMTP id adf61e73a8af0-23dc0ead8femr14666806637.38.1754008075653;
        Thu, 31 Jul 2025 17:27:55 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:74::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bd9b3b3d4sm969784b3a.10.2025.07.31.17.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 17:27:55 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: linux-mm@kvack.org,
	brauner@kernel.org
Cc: willy@infradead.org,
	jack@suse.cz,
	hch@infradead.org,
	djwong@kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com
Subject: [RFC PATCH v1 10/10] iomap: add granular dirty and writeback accounting
Date: Thu, 31 Jul 2025 17:21:31 -0700
Message-ID: <20250801002131.255068-11-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250801002131.255068-1-joannelkoong@gmail.com>
References: <20250801002131.255068-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1EF601C000B
X-Stat-Signature: pq4ki1f3rzchwuqyz3e7wwz78nc4wy4h
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754008076-505910
X-HE-Meta: U2FsdGVkX1/6VYnVtEwbXgMVKA/X8v2GiURGCbpGfbZXqbj73QV0P9jkuu6JY3rZMhnbiqssPmDz3fjHcUnDIpK3KON5H3ND7b/eKUqHd1DF+7goeoEFlOxrHRQ8IfoPq+hAq7zqNT3ArBHWaT/B14nB1+ABdzV0DjzA6B/h1/EGYFz9YUKYrgSmzkMDMYmY6QxxeTq43sDhwJEdJH3v4Nize8JmnDhxNMrg4qyWXapzHd2YbccwQvEZhBIbtjerlZmseTCZbUPY0PTvpMRRtmpj1O2LCJgqokEbEtOKr+YtbUlMTGZZpkm7CtcyUeQz0p8F9zkjeY98pCG4zDm0V7/2EDtL9bSw/Mp7+hcAxZN1cC/g7x1Q75fXKwnFB69K2CnNuTyKVLFjBc4fQntLaMS1zhozQ5txzsrzvThy6IIqfpsU/HzVLuava3V4FroiHfVSwC7NVdZMdIk5LDOJWjEAkKRNzVe9YVdQBPe9rRNmCLKRSxfJ9+eGVsp1sfsz+cCUlVsyO5AvO9ega/MW2acfHZRiW48ZWR38mn0qs/WqU+ROu1zKy5bPvN01PiYKF3cBBTEeABXitrkuiK9IPBa5zswQ3TErgn/Jv6QuuhEeqNpPnKxcCAJI72nv6gpobbM1RW7TGZq4F71V4ceQQOeSDo/HOwOOvnyDcj2fQSKOVQNL5D6QvcduoBIGLvFAP/02LlflTjTWAft/jSrXbQ/RP+gN/UPstwBOuNzQm5ehj+Qv8+D95cXIfLk+QhWKZV4lD3D0y6i0KoRcdGRFE6eAe6hQ8oYJa4M4+w1uOvTdwMl9hlChkSXLh5cGSTtLkQJGDQtoEtK7DbbyJA2MvHlZIWer0aYhmE5QnkcKdNCS6ja9dBVm/FHS9AqVdpc8lzo1ViepFHIwBxkFDz6XkcLQqdrWMEwaYjWvWB5DOBfh+r9qOJX1QCqd0OSnvJWANMs0ub3puD6mO9OZ1pG
 x1sV8KA0
 aGm1BL/3s7r0t+NhuZuWp2IOpSejmZ3TpxlOhQFNDTeuujlayxfMS7AUeEmliJcSKnfs3OpyDbQQofWNWAyEdrWhgP8zTZlXumkX3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add granular dirty and writeback accounting for large folios. These
stats are used by the mm layer for dirty balancing and throttling.
Having granular dirty and writeback accounting helps prevent
over-aggressive balancing and throttling.

There are 4 places in iomap this commit affects:
a) filemap dirtying, which now calls filemap_dirty_folio_pages()
b) writeback_iter with setting the wbc->no_stats_accounting bit and
calling clear_dirty_for_io_stats()
c) starting writeback, which now calls __folio_start_writeback()
d) ending writeback, which now calls folio_end_writeback_pages()

This relies on using the ifs->state dirty bitmap to track dirty pages in
the folio. As such, this can only be utilized on filesystems where the
block size >= PAGE_SIZE.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/iomap/buffered-io.c | 136 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 128 insertions(+), 8 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index bcc6e0e5334e..626c3c8399cc 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -20,6 +20,8 @@ struct iomap_folio_state {
 	spinlock_t		state_lock;
 	unsigned int		read_bytes_pending;
 	atomic_t		write_bytes_pending;
+	/* number of pages being currently written back */
+	unsigned		nr_pages_writeback;
 
 	/*
 	 * Each block has two bits in this bitmap:
@@ -81,6 +83,25 @@ static inline bool ifs_block_is_dirty(struct folio *folio,
 	return test_bit(block + blks_per_folio, ifs->state);
 }
 
+static unsigned ifs_count_dirty_pages(struct folio *folio)
+{
+	struct iomap_folio_state *ifs = folio->private;
+	struct inode *inode = folio->mapping->host;
+	unsigned block_size = 1 << inode->i_blkbits;
+	unsigned start_blk = 0;
+	unsigned end_blk = min((unsigned)(i_size_read(inode) >> inode->i_blkbits),
+				i_blocks_per_folio(inode, folio));
+	unsigned nblks = 0;
+
+	while (start_blk < end_blk) {
+		if (ifs_block_is_dirty(folio, ifs, start_blk))
+			nblks++;
+		start_blk++;
+	}
+
+	return nblks * (block_size >> PAGE_SHIFT);
+}
+
 static unsigned ifs_find_dirty_range(struct folio *folio,
 		struct iomap_folio_state *ifs, u64 *range_start, u64 range_end)
 {
@@ -165,6 +186,63 @@ static void iomap_set_range_dirty(struct folio *folio, size_t off, size_t len)
 		ifs_set_range_dirty(folio, ifs, off, len);
 }
 
+static long iomap_get_range_newly_dirtied(struct folio *folio, loff_t pos,
+		unsigned len)
+{
+	struct iomap_folio_state *ifs = folio->private;
+	struct inode *inode = folio->mapping->host;
+	unsigned start_blk = pos >> inode->i_blkbits;
+	unsigned end_blk = min((unsigned)((pos + len - 1) >> inode->i_blkbits),
+				i_blocks_per_folio(inode, folio) - 1);
+	unsigned nblks = 0;
+	unsigned block_size = 1 << inode->i_blkbits;
+
+	while (start_blk <= end_blk) {
+		if (!ifs_block_is_dirty(folio, ifs, start_blk))
+			nblks++;
+		start_blk++;
+	}
+
+	return nblks * (block_size >> PAGE_SHIFT);
+}
+
+static bool iomap_granular_dirty_pages(struct folio *folio)
+{
+	struct iomap_folio_state *ifs = folio->private;
+	struct inode *inode;
+	unsigned block_size;
+
+	if (!ifs)
+		return false;
+
+	inode = folio->mapping->host;
+	block_size = 1 << inode->i_blkbits;
+
+	if (block_size >= PAGE_SIZE) {
+		WARN_ON(block_size & (PAGE_SIZE - 1));
+		return true;
+	}
+	return false;
+}
+
+static bool iomap_dirty_folio_range(struct address_space *mapping, struct folio *folio,
+			loff_t pos, unsigned len)
+{
+	long nr_new_dirty_pages;
+
+	if (!iomap_granular_dirty_pages(folio)) {
+		iomap_set_range_dirty(folio, pos, len);
+		return filemap_dirty_folio(mapping, folio);
+	}
+
+	nr_new_dirty_pages = iomap_get_range_newly_dirtied(folio, pos, len);
+	if (!nr_new_dirty_pages)
+		return false;
+
+	iomap_set_range_dirty(folio, pos, len);
+	return filemap_dirty_folio_pages(mapping, folio, nr_new_dirty_pages);
+}
+
 static struct iomap_folio_state *ifs_alloc(struct inode *inode,
 		struct folio *folio, unsigned int flags)
 {
@@ -661,8 +739,7 @@ bool iomap_dirty_folio(struct address_space *mapping, struct folio *folio)
 	size_t len = folio_size(folio);
 
 	ifs_alloc(inode, folio, 0);
-	iomap_set_range_dirty(folio, 0, len);
-	return filemap_dirty_folio(mapping, folio);
+	return iomap_dirty_folio_range(mapping, folio, 0, len);
 }
 EXPORT_SYMBOL_GPL(iomap_dirty_folio);
 
@@ -886,8 +963,8 @@ static bool __iomap_write_end(struct inode *inode, loff_t pos, size_t len,
 	if (unlikely(copied < len && !folio_test_uptodate(folio)))
 		return false;
 	iomap_set_range_uptodate(folio, offset_in_folio(folio, pos), len);
-	iomap_set_range_dirty(folio, offset_in_folio(folio, pos), copied);
-	filemap_dirty_folio(inode->i_mapping, folio);
+	iomap_dirty_folio_range(inode->i_mapping, folio,
+			offset_in_folio(folio, pos), copied);
 	return true;
 }
 
@@ -1560,6 +1637,29 @@ void iomap_start_folio_write(struct inode *inode, struct folio *folio,
 }
 EXPORT_SYMBOL_GPL(iomap_start_folio_write);
 
+static void iomap_folio_start_writeback(struct folio *folio)
+{
+	struct iomap_folio_state *ifs = folio->private;
+
+	if (!iomap_granular_dirty_pages(folio))
+		return folio_start_writeback(folio);
+
+	__folio_start_writeback(folio, false, ifs->nr_pages_writeback);
+}
+
+static void iomap_folio_end_writeback(struct folio *folio)
+{
+	struct iomap_folio_state *ifs = folio->private;
+	long nr_pages_writeback;
+
+	if (!iomap_granular_dirty_pages(folio))
+		return folio_end_writeback(folio);
+
+	nr_pages_writeback = ifs->nr_pages_writeback;
+	ifs->nr_pages_writeback = 0;
+	folio_end_writeback_pages(folio, nr_pages_writeback);
+}
+
 void iomap_finish_folio_write(struct inode *inode, struct folio *folio,
 		size_t len)
 {
@@ -1569,7 +1669,7 @@ void iomap_finish_folio_write(struct inode *inode, struct folio *folio,
 	WARN_ON_ONCE(ifs && atomic_read(&ifs->write_bytes_pending) <= 0);
 
 	if (!ifs || atomic_sub_and_test(len, &ifs->write_bytes_pending))
-		folio_end_writeback(folio);
+		iomap_folio_end_writeback(folio);
 }
 EXPORT_SYMBOL_GPL(iomap_finish_folio_write);
 
@@ -1657,6 +1757,21 @@ static bool iomap_writeback_handle_eof(struct folio *folio, struct inode *inode,
 	return true;
 }
 
+static void iomap_update_dirty_stats(struct folio *folio)
+{
+	struct iomap_folio_state *ifs = folio->private;
+	long nr_dirty_pages;
+
+	if (iomap_granular_dirty_pages(folio)) {
+		nr_dirty_pages = ifs_count_dirty_pages(folio);
+		ifs->nr_pages_writeback = nr_dirty_pages;
+	} else {
+		nr_dirty_pages = folio_nr_pages(folio);
+	}
+
+	clear_dirty_for_io_stats(folio, nr_dirty_pages);
+}
+
 int iomap_writeback_folio(struct iomap_writepage_ctx *wpc, struct folio *folio)
 {
 	struct iomap_folio_state *ifs = folio->private;
@@ -1674,6 +1789,8 @@ int iomap_writeback_folio(struct iomap_writepage_ctx *wpc, struct folio *folio)
 
 	trace_iomap_writeback_folio(inode, pos, folio_size(folio));
 
+	iomap_update_dirty_stats(folio);
+
 	if (!iomap_writeback_handle_eof(folio, inode, &end_pos))
 		return 0;
 	WARN_ON_ONCE(end_pos <= pos);
@@ -1681,6 +1798,7 @@ int iomap_writeback_folio(struct iomap_writepage_ctx *wpc, struct folio *folio)
 	if (i_blocks_per_folio(inode, folio) > 1) {
 		if (!ifs) {
 			ifs = ifs_alloc(inode, folio, 0);
+			ifs->nr_pages_writeback = folio_nr_pages(folio);
 			iomap_set_range_dirty(folio, 0, end_pos - pos);
 		}
 
@@ -1698,7 +1816,7 @@ int iomap_writeback_folio(struct iomap_writepage_ctx *wpc, struct folio *folio)
 	 * Set the writeback bit ASAP, as the I/O completion for the single
 	 * block per folio case happen hit as soon as we're submitting the bio.
 	 */
-	folio_start_writeback(folio);
+	iomap_folio_start_writeback(folio);
 
 	/*
 	 * Walk through the folio to find dirty areas to write back.
@@ -1731,10 +1849,10 @@ int iomap_writeback_folio(struct iomap_writepage_ctx *wpc, struct folio *folio)
 	 */
 	if (ifs) {
 		if (atomic_dec_and_test(&ifs->write_bytes_pending))
-			folio_end_writeback(folio);
+			iomap_folio_end_writeback(folio);
 	} else {
 		if (!wb_pending)
-			folio_end_writeback(folio);
+			iomap_folio_end_writeback(folio);
 	}
 	mapping_set_error(inode->i_mapping, error);
 	return error;
@@ -1756,6 +1874,8 @@ iomap_writepages(struct iomap_writepage_ctx *wpc)
 			PF_MEMALLOC))
 		return -EIO;
 
+	wpc->wbc->no_stats_accounting = true;
+
 	while ((folio = writeback_iter(mapping, wpc->wbc, folio, &error))) {
 		error = iomap_writeback_folio(wpc, folio);
 		folio_unlock(folio);
-- 
2.47.3


