Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65DA6CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 14:59:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B871B6B00A4; Tue,  9 Sep 2025 10:59:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B37756B00A5; Tue,  9 Sep 2025 10:59:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A26BD6B00A6; Tue,  9 Sep 2025 10:59:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8B64B6B00A4
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:59:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 28CE6869DE
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:59:12 +0000 (UTC)
X-FDA: 83870019744.17.3C2DF0E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id E6D824000C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:59:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PrXgAtEA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=flq8Xk8i;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gsYCtBKS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="9/CO1aeY";
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757429950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lnmhDFmtTUNklZKT/bYXY+FmLkPcZdd1+5x3c6aX6AQ=;
	b=ybD5epciexn2ncFP7hf22jyPmbFDUlcFJre9eBl52D6ZKCFV6zgoINtIj7vsbZN5UMMDbG
	LYHhdKMlqR1/KUKOgmTVAnGxrHSVyLKzMPEkXJhfGUdNRtQFLepiXp+ARSDodgfdqozcnr
	LJFHyDi45ie0YlRE8mrHb09V3nKrFck=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PrXgAtEA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=flq8Xk8i;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gsYCtBKS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="9/CO1aeY";
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757429950; a=rsa-sha256;
	cv=none;
	b=2cQXlBNUhzSPzt7qJGJesO7bA9BY1AgTPvNwpvL436Cc9RQ+jhkndxbqyL3Icst8kGK22i
	bFBp1Dib4W1+Wkfw7yWNmWOp6j406h4nt9Z5dHCNth4b/+pfBtpTZAjJaYmMcahqT4XrcG
	7CgD8mEW0DmeWT3qqAEkfa/SyEe1NOU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DF23129968;
	Tue,  9 Sep 2025 14:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757429948; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=lnmhDFmtTUNklZKT/bYXY+FmLkPcZdd1+5x3c6aX6AQ=;
	b=PrXgAtEAzSYtfqggMOBLcb66fXiCXG/4InJmPSzvu8JNN4FBMp5QJX87Vkmiyl09Xsna6s
	s9ubkRW8M/BsVKc+ieIXbOoXdcTD9uMdErO4t/oX3OQLcpOzmuvtQJ3MhKy+2/j4U5/eHP
	9XO5HPKCcvfsJONSQRHvDdNKd54HfXU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757429948;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=lnmhDFmtTUNklZKT/bYXY+FmLkPcZdd1+5x3c6aX6AQ=;
	b=flq8Xk8imKLid5PFSCp9aezXvwRdua8+Sw7vGt9cP4O1siAcoOYpRT+euO8JTA5pVvu6NL
	MNK+NDSnAMZ/G0BA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757429947; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=lnmhDFmtTUNklZKT/bYXY+FmLkPcZdd1+5x3c6aX6AQ=;
	b=gsYCtBKSWWno2wNT6L/s6XYzU3dPGTqJcUZlIEaG8I4m3FEUkATMI5+fSqS7fXvEXPJRq6
	jtEm/Tx9R4f6GXTeTzHiFVZFZIl5S/y0o/YFJXV4YtUV6bvBy1pXXbm6wr2X9/sqm2unmT
	n98gxz92/4jn+zE2itAwskHaRRZedfw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757429947;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=lnmhDFmtTUNklZKT/bYXY+FmLkPcZdd1+5x3c6aX6AQ=;
	b=9/CO1aeY4F7D1VsH9KipkP0hoWiZgaDjX+DHHBW49rKyKbzsKdyxeBVe8AvoL7s+kS4UiR
	YOwPiqLyhbT6TlAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CC2E61388C;
	Tue,  9 Sep 2025 14:59:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /kJ+MbtAwGhyfAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 09 Sep 2025 14:59:07 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 85909A0A2D; Tue,  9 Sep 2025 16:59:07 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>,
	"Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2] readahead: Add trace points
Date: Tue,  9 Sep 2025 16:58:50 +0200
Message-ID: <20250909145849.5090-2-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6249; i=jack@suse.cz; h=from:subject; bh=hD1kfrGcVCzDZQIqP0Yp7aWTNgu351fNfU/0J6KfY9I=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBowECpU3aXE6Sd1IwPZLCHlVPvAWxwL7n3gxv+d qaX7h2xpLuJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaMBAqQAKCRCcnaoHP2RA 2fI/CAC6/M28K6eSp9AL4fHjXwojLDQU4T7Ta+vb0Q5BsyCPRpp5KQhI9lHbzUHxmIF8RZdAoxV qZWMMR9gk/roKK7i5FMLeqfrgAFID5dti6i7mytgbuNr57NbupmwxsUmsQiKKDVLCRG1CrU4ups e3FaRKwt2Oe4c3PMXeeexWPBbBjN0Nl84nd/Ack5XifX3QB0SJklikBFWAHEN1SNNB7sg4cumRj UsTo4Y+2oXhspVevBUMphBITAID1IwVhrbbCniEMJP+HMe5IlnadVUroYgEeYD7CrKakDeEZl4j mbl8T3P5faCKTdSrLtyG0tmmAGI0brjM1kkKrOGp1XfafSRU
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E6D824000C
X-Stat-Signature: q5wkt47wxxfjtw9jaifbc8qsre7i1f55
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757429949-999937
X-HE-Meta: U2FsdGVkX1/LkB4wCEEloJQcekQneHGCYyfNZHCtN3lHZxFcXHmgZhSXcf51kH7pBN+0VZP5es892I8uf1XugQHYHZqoTggdsF4c5vxccS/H2Pe16E7nMrC7nCqNKSiCKq8GnVnZowF7e0GT9OBPOfYX+p0E33uNTiVjmf/2Ex3K10uja7ZsR5NfTQfcJo+EWx5d0Cc0OOn061/QP3cwdo6By6U6Av2DeJ03ej1fMZ8L3h1arCU64YT+g0IyU6r8/wj8S+56Fy66Ie0D1q3/l/h/9TX3ABpb705HD9mzDdQwt4+0j1i1AsrhRHpu9fm11ZywcP/m14SY4Hj/17hVedYg6XXuzBjor5OjLDmD9y7cAVeA/58x4X3FkVHjdpnGUUnr9dwxk1vZhtgfW4vYqtYp6+MdmE5bvF22MRERxdZ5gfVAX8csJdhdhL73N4a8Qob8WZ1VtYMT3WIxpAze2vBNVRa20+JAaAnU7E30d4OHjDjUr7liBTzWV2id0WMATLZWGziAAU+TR38bKAsrcyWjJP65bpub8XLqgNQxLcgwWBPN2EioV0cxd98vgpvshiiZyAkzJgXhVW1hRMsAxMvpJPsUs/Kor4sRFTVm+PagFdt7DIgVrvLtexqHqlfc57gWmKkKrX5UHa0uV8xW/9Rq0jKwousad3zKHOHWV7ku61Csxc/b0+6z2c58Keh7ZOWIkmuUeEjvRzgxgW9QTPkTEXtrD1D1HKPjqfJAqsbHJqJObkDlXrkCjhoSkHBEa2dGhm3pUf+GlSi+hQEVvjefVA9Hx+6ekJsWXp7xEux1nnbqByJym1rEawGxQgioMPtWmlOqDbSpaCWZ9WO3arcPEWrnFXqJ/ZCmVz2cD2/OI66Ry9xyMNAqrEa7VRhaO+4s+E9C8qqWqHFOvfJt28PlPV/HXhKcVoi3Up8joqeU/KyhkSgUGhIVno7UIa+FZQoIHwQXaG9zLoESkJT
 OX2YTzcX
 maQC+YTJ0Zqh0PcYKjRQ1rqQBI+pJgqClTwBl166ETYjLpg3yaxelLwGEo26slzluxNxxOchoh06S/BoNBPpONgCNCETt6OJqtTEqACOcQUoDiCtcSApwdZ1fQ+xwBj2RfaPWOydcZcaftGRIPpPq8KFufR/J1GJEPisUDBGLpW4uzHLdoy14G9vbQwl1uCmkLN6WzKzDuXZeI7/FK1gVjMhZ1PsxqYMCf7p8rBqJAKKjwZ0S+3W6AVX5WwaD2jiAjPSLIC1ype4FMT7EHb/G+kSozw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a couple of trace points to make debugging readahead logic easier.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/trace/events/readahead.h | 132 +++++++++++++++++++++++++++++++
 mm/readahead.c                   |   8 ++
 2 files changed, 140 insertions(+)
 create mode 100644 include/trace/events/readahead.h

Changes since v1:
- moved tracepoint from do_page_cache_ra() to page_cache_ra_unbounded() as
  that is a more standard function.

diff --git a/include/trace/events/readahead.h b/include/trace/events/readahead.h
new file mode 100644
index 000000000000..0997ac5eceab
--- /dev/null
+++ b/include/trace/events/readahead.h
@@ -0,0 +1,132 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM readahead
+
+#if !defined(_TRACE_FILEMAP_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_READAHEAD_H
+
+#include <linux/types.h>
+#include <linux/tracepoint.h>
+#include <linux/mm.h>
+#include <linux/fs.h>
+#include <linux/pagemap.h>
+
+TRACE_EVENT(page_cache_ra_unbounded,
+	TP_PROTO(struct inode *inode, pgoff_t index, unsigned long nr_to_read,
+		 unsigned long lookahead_size),
+
+	TP_ARGS(inode, index, nr_to_read, lookahead_size),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, i_ino)
+		__field(dev_t, s_dev)
+		__field(pgoff_t, index)
+		__field(unsigned long, nr_to_read)
+		__field(unsigned long, lookahead_size)
+	),
+
+	TP_fast_assign(
+		__entry->i_ino = inode->i_ino;
+		__entry->s_dev = inode->i_sb->s_dev;
+		__entry->index = index;
+		__entry->nr_to_read = nr_to_read;
+		__entry->lookahead_size = lookahead_size;
+	),
+
+	TP_printk(
+		"dev=%d:%d ino=%lx index=%lu nr_to_read=%lu lookahead_size=%lu",
+		MAJOR(__entry->s_dev), MINOR(__entry->s_dev), __entry->i_ino,
+		__entry->index, __entry->nr_to_read, __entry->lookahead_size
+	)
+);
+
+TRACE_EVENT(page_cache_ra_order,
+	TP_PROTO(struct inode *inode, pgoff_t index, struct file_ra_state *ra),
+
+	TP_ARGS(inode, index, ra),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, i_ino)
+		__field(dev_t, s_dev)
+		__field(pgoff_t, index)
+		__field(unsigned int, order)
+		__field(unsigned int, size)
+		__field(unsigned int, async_size)
+		__field(unsigned int, ra_pages)
+	),
+
+	TP_fast_assign(
+		__entry->i_ino = inode->i_ino;
+		__entry->s_dev = inode->i_sb->s_dev;
+		__entry->index = index;
+		__entry->order = ra->order;
+		__entry->size = ra->size;
+		__entry->async_size = ra->async_size;
+		__entry->ra_pages = ra->ra_pages;
+	),
+
+	TP_printk(
+		"dev=%d:%d ino=%lx index=%lu order=%u size=%u async_size=%u ra_pages=%u",
+		MAJOR(__entry->s_dev), MINOR(__entry->s_dev), __entry->i_ino,
+		__entry->index, __entry->order, __entry->size,
+		__entry->async_size, __entry->ra_pages
+	)
+);
+
+DECLARE_EVENT_CLASS(page_cache_ra_op,
+	TP_PROTO(struct inode *inode, pgoff_t index, struct file_ra_state *ra,
+		 unsigned long req_count),
+
+	TP_ARGS(inode, index, ra, req_count),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, i_ino)
+		__field(dev_t, s_dev)
+		__field(pgoff_t, index)
+		__field(unsigned int, order)
+		__field(unsigned int, size)
+		__field(unsigned int, async_size)
+		__field(unsigned int, ra_pages)
+		__field(unsigned int, mmap_miss)
+		__field(loff_t, prev_pos)
+		__field(unsigned long, req_count)
+	),
+
+	TP_fast_assign(
+		__entry->i_ino = inode->i_ino;
+		__entry->s_dev = inode->i_sb->s_dev;
+		__entry->index = index;
+		__entry->order = ra->order;
+		__entry->size = ra->size;
+		__entry->async_size = ra->async_size;
+		__entry->ra_pages = ra->ra_pages;
+		__entry->mmap_miss = ra->mmap_miss;
+		__entry->prev_pos = ra->prev_pos;
+		__entry->req_count = req_count;
+	),
+
+	TP_printk(
+		"dev=%d:%d ino=%lx index=%lu req_count=%lu order=%u size=%u async_size=%u ra_pages=%u mmap_miss=%u prev_pos=%lld",
+		MAJOR(__entry->s_dev), MINOR(__entry->s_dev), __entry->i_ino,
+		__entry->index, __entry->req_count, __entry->order,
+		__entry->size, __entry->async_size, __entry->ra_pages,
+		__entry->mmap_miss, __entry->prev_pos
+	)
+);
+
+DEFINE_EVENT(page_cache_ra_op, page_cache_sync_ra,
+	TP_PROTO(struct inode *inode, pgoff_t index, struct file_ra_state *ra,
+		 unsigned long req_count),
+	TP_ARGS(inode, index, ra, req_count)
+);
+
+DEFINE_EVENT(page_cache_ra_op, page_cache_async_ra,
+	TP_PROTO(struct inode *inode, pgoff_t index, struct file_ra_state *ra,
+		 unsigned long req_count),
+	TP_ARGS(inode, index, ra, req_count)
+);
+
+#endif /* _TRACE_FILEMAP_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/mm/readahead.c b/mm/readahead.c
index 406756d34309..3a4b5d58eeb6 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -129,6 +129,9 @@
 #include <linux/fadvise.h>
 #include <linux/sched/mm.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/readahead.h>
+
 #include "internal.h"
 
 /*
@@ -225,6 +228,8 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
 	 */
 	unsigned int nofs = memalloc_nofs_save();
 
+	trace_page_cache_ra_unbounded(mapping->host, index, nr_to_read,
+				      lookahead_size);
 	filemap_invalidate_lock_shared(mapping);
 	index = mapping_align_index(mapping, index);
 
@@ -470,6 +475,7 @@ void page_cache_ra_order(struct readahead_control *ractl,
 	gfp_t gfp = readahead_gfp_mask(mapping);
 	unsigned int new_order = ra->order;
 
+	trace_page_cache_ra_order(mapping->host, start, ra);
 	if (!mapping_large_folio_support(mapping)) {
 		ra->order = 0;
 		goto fallback;
@@ -554,6 +560,7 @@ void page_cache_sync_ra(struct readahead_control *ractl,
 	unsigned long max_pages, contig_count;
 	pgoff_t prev_index, miss;
 
+	trace_page_cache_sync_ra(ractl->mapping->host, index, ra, req_count);
 	/*
 	 * Even if readahead is disabled, issue this request as readahead
 	 * as we'll need it to satisfy the requested range. The forced
@@ -638,6 +645,7 @@ void page_cache_async_ra(struct readahead_control *ractl,
 	if (folio_test_writeback(folio))
 		return;
 
+	trace_page_cache_async_ra(ractl->mapping->host, index, ra, req_count);
 	folio_clear_readahead(folio);
 
 	if (blk_cgroup_congested())
-- 
2.51.0


