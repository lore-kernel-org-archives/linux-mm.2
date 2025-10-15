Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC783CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 06:27:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FDCF8E0017; Wed, 15 Oct 2025 02:27:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ACDF8E0003; Wed, 15 Oct 2025 02:27:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29DF88E0017; Wed, 15 Oct 2025 02:27:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 14EE48E0003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:27:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CDF2588B80
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:27:46 +0000 (UTC)
X-FDA: 83999367732.08.92769C7
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3276E10000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:27:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Wywt7O17;
	spf=none (imf14.hostedemail.com: domain of BATV+bc6a97f86abb080b148e+8088+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+bc6a97f86abb080b148e+8088+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760509665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7iayGlxTwU1u6RavvnSiJV2FXvgUFDsMlYmxUt8f3P4=;
	b=aDz//Mj5uvSOMh32EvBSLDX75EQuqoSOAfeO9HHIoNjHEYvdAsE5811HeazgcL4ELfNJST
	jIltiGdO1/L3Egr7gVKYscIyobQx1EzKDSkWpAT3CdSvs9MIvnyQ93MXyu2+sn0zNRX6m9
	C2hcpJlt5oHjtZcIdvYWMQoclceJw3U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Wywt7O17;
	spf=none (imf14.hostedemail.com: domain of BATV+bc6a97f86abb080b148e+8088+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+bc6a97f86abb080b148e+8088+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760509665; a=rsa-sha256;
	cv=none;
	b=Q1gno12Q35x9dHFgX6V6SCD5ZitI6ACqRgaif6mzh42sfksLRQt7ujAdE0LxqCLFEevXCm
	MgZyTAppRjWkDWdCTlD9mZOJNu1bEm3ImipCMbkEdoG/SIYjZzlsuKbyr8g21hCl+dMIHL
	7bm78AlqVwK8NCnntw2RhVmBVjamDaQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7iayGlxTwU1u6RavvnSiJV2FXvgUFDsMlYmxUt8f3P4=; b=Wywt7O1716ikFY3yhECA7UY99U
	5gK/PD1cG5eM+txjD5ECR2AKa0neB7kPMd1PqDCHSLPbWvRSHdt1I+ZHuFKPmGHH/GBhyTUtdIXLQ
	wyIkRykfAesxR+9xr14doBNVSqIxfFeQJnl/gycwz0DGCND9nriajVZ5fCfyO7ea12JnGOylh//AS
	vFBXeWj3Ny7GOamybCG+lmHKEs4qv8P8QA8E3t0t98/G2pXLgGVJJGH7qAzlxJ3eqLHXdMuwgQuK1
	X+iEoWP9X7HyPCPjuPYcYfN0Kcdt7/2EkR8kQFm9dE3MKYaH7hGS6/ggKpP/9Uj9YKQWQyNIemF8w
	qoIEg9cQ==;
Received: from [38.87.93.141] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v8uz7-00000000bDY-42Gs;
	Wed, 15 Oct 2025 06:27:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	willy@infradead.org,
	dlemoal@kernel.org,
	hans.holmberg@wdc.com,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] writeback: allow the file system to override MIN_WRITEBACK_PAGES
Date: Wed, 15 Oct 2025 15:27:15 +0900
Message-ID: <20251015062728.60104-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251015062728.60104-1-hch@lst.de>
References: <20251015062728.60104-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: n7mcwtp51jroe9twn9t4ba5y58466h56
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3276E10000C
X-HE-Tag: 1760509665-585336
X-HE-Meta: U2FsdGVkX1+bZv/Ll7AvalTeQ0EokFOiH8IHUoT80f/c/YO6KBoZTLhCuqzqX1I1EFSxO336RErbff/yH/jFmQ1grtx2ceINMwt0Q65alFtXPPhvKz9r2OMMPxxgQszAzaxc2UWNWxsypbh7dDiXe/1Wg9bVxZ0eGGIvwJWGRcLZwK/EPRtkseU/crSuEbJ8n4e18Y8t/3vYxOs1O4VYGepWv29Vba6ipMdk3FMJia09AIrEZn4O5zjy6FNRbcyWQfdcHoLBcm5glOPIX7AqdVaS39ZQkp5QAVXOGLUzxIM1Q/UtKG3xBzHkpDw+u1yDzVin9KV01x2ILTemoKDOidwC+tVINMPr6TPeENG9ucshiOqhyrSHliSisuO93AUCRNB70NlXD/gnlhbof7heWe26lgZh4JVcB3G4P1AmHYwqrAh2l1aErZbRr2l/r5AhjxASFknfC6NGlqp9tzrWkpR/5/kJyj6eIyYaZItD0Ze+9blLEObUvkQUqpydn9T6fBof2ioPivAtNcEVPi0rccsU9pHNV1tp6ArNOvrDtl8EMivNEBax4ywRB7d8YwLjL7oqVfwJMStGDA8qjuZ/JOmiZVdSL3U5jzLVezTZbYBaoYzTXuDnrezroTKSLR2+F8MZoDTctYgbJOZ+bcCuVEwrmLvt42vafTlNMNBKewKdo6oK78Ox0rODpPwSEruXEq/rnJAJQXB8y1iU8VDkjrNhuqmGyNg2OS0vZmrECtUek3EFCjroGOS6/YApRdvBDziJy7VUNgYGa40QqhbYUAdO8Sh8zgTM9CdBOJT2k/yXiNDRJvSU7uWRXszgqQsrYXtGAacvRiX9vdoJlh7M3gv6R+G+ltEFeR2ysQDIZx3XOUpD/JnNsnrsRUnRpUt+78lZ1e512iI40lR3RBJQ8GErAYuigk5kx1oiK7fRmiHC/9EmMGRoF0hN71ldiqvEYNBn10H7xYfBloJstn+
 EwSnqQLV
 b8K+d9bitmXx9gmaLThQZKCIYQnxHxUZSgBVlYiUXT61rXxfIVnUV//UvYtBuKNybIfG6dSzCDYD/s2kZwTLj8f9CDLVQ+YOwv+Y1Dg7gW8gTDGU8na85heU8lzBkDda+nmXqFpBWU2VH4ffAWuoKo+i9jyIzx5+wkCNlB0QNIG8Q0nZLQ1kd8LUtf9TidzfELaW0hTOsCNqrHhIqpa+DnDceX/MGB/AYwsCZZDeMB9b2MBm2a+HF5HFAdWnr0Rcccw6v5Rhg0hxjhliCpcCHJAuacVR1pHjcjixG+kJpFZ/HZsG2oh6XotLR03HvIRKquRxZMaYEkS7x2xuO8/u5q3uC3w74UN1rDROjQbTyeSWAQjuO8ROqpvwrfLsU0BWayE7wFhMasoVioNCtdE3J6RrzZMu+4L/DNmY1hUd/hYp5bD8YqsM6RWd3wq4tZ3n5IS9gVlmWesJP9Adnh2AN4JrUK3O4XslRu6Pbtye6GQAi3GDLwx8wtI/LIAbuRlgYsMRxt29dITd4B2G9zQl+qmo9aVwyw06+IWHVogm6LdlemWPxkyKxp9NfVf4xFihPIjqrt6Xa9NPqlqCOuTWhlwMLBQ4xBoKNTKIdt8LIPnEwsa8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The relatively low minimal writeback size of 4MiB leads means that
written back inodes on rotational media are switched a lot.  Besides
introducing additional seeks, this also can lead to extreme file
fragmentation on zoned devices when a lot of files are cached relative
to the available writeback bandwidth.

Add a superblock field that allows the file system to override the
default size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/fs-writeback.c         | 14 +++++---------
 fs/super.c                |  1 +
 include/linux/fs.h        |  1 +
 include/linux/writeback.h |  5 +++++
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 11fd08a0efb8..6d50b02cdab6 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -31,11 +31,6 @@
 #include <linux/memcontrol.h>
 #include "internal.h"
 
-/*
- * 4MB minimal write chunk size
- */
-#define MIN_WRITEBACK_PAGES	(4096UL >> (PAGE_SHIFT - 10))
-
 /*
  * Passed into wb_writeback(), essentially a subset of writeback_control
  */
@@ -1874,8 +1869,8 @@ static int writeback_single_inode(struct inode *inode,
 	return ret;
 }
 
-static long writeback_chunk_size(struct bdi_writeback *wb,
-				 struct wb_writeback_work *work)
+static long writeback_chunk_size(struct super_block *sb,
+		struct bdi_writeback *wb, struct wb_writeback_work *work)
 {
 	long pages;
 
@@ -1898,7 +1893,8 @@ static long writeback_chunk_size(struct bdi_writeback *wb,
 	pages = min(wb->avg_write_bandwidth / 2,
 		    global_wb_domain.dirty_limit / DIRTY_SCOPE);
 	pages = min(pages, work->nr_pages);
-	return round_down(pages + MIN_WRITEBACK_PAGES, MIN_WRITEBACK_PAGES);
+	return round_down(pages + sb->s_min_writeback_pages,
+			sb->s_min_writeback_pages);
 }
 
 /*
@@ -2000,7 +1996,7 @@ static long writeback_sb_inodes(struct super_block *sb,
 		inode->i_state |= I_SYNC;
 		wbc_attach_and_unlock_inode(&wbc, inode);
 
-		write_chunk = writeback_chunk_size(wb, work);
+		write_chunk = writeback_chunk_size(inode->i_sb, wb, work);
 		wbc.nr_to_write = write_chunk;
 		wbc.pages_skipped = 0;
 
diff --git a/fs/super.c b/fs/super.c
index 5bab94fb7e03..599c1d2641fe 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -389,6 +389,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
 		goto fail;
 	if (list_lru_init_memcg(&s->s_inode_lru, s->s_shrink))
 		goto fail;
+	s->s_min_writeback_pages = MIN_WRITEBACK_PAGES;
 	return s;
 
 fail:
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c895146c1444..23f1f10646b7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1583,6 +1583,7 @@ struct super_block {
 
 	spinlock_t		s_inode_wblist_lock;
 	struct list_head	s_inodes_wb;	/* writeback inodes */
+	unsigned int		s_min_writeback_pages;
 } __randomize_layout;
 
 static inline struct user_namespace *i_user_ns(const struct inode *inode)
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 22dd4adc5667..49e1dd96f43e 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -374,4 +374,9 @@ bool redirty_page_for_writepage(struct writeback_control *, struct page *);
 void sb_mark_inode_writeback(struct inode *inode);
 void sb_clear_inode_writeback(struct inode *inode);
 
+/*
+ * 4MB minimal write chunk size
+ */
+#define MIN_WRITEBACK_PAGES	(4096UL >> (PAGE_SHIFT - 10))
+
 #endif		/* WRITEBACK_H */
-- 
2.47.3


