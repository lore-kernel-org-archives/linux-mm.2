Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18550CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 03:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 630A78E0034; Thu, 16 Oct 2025 23:46:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 592C48E0002; Thu, 16 Oct 2025 23:46:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45AE68E0034; Thu, 16 Oct 2025 23:46:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 304B28E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 23:46:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B11B21A01FD
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 03:46:33 +0000 (UTC)
X-FDA: 84006219066.14.CCEF2C2
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1D910100005
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 03:46:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=4buTEpGP;
	spf=none (imf14.hostedemail.com: domain of BATV+4b0bb848bbbfa73029ae+8090+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4b0bb848bbbfa73029ae+8090+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760672792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YKsfrgXDaorO3CUsvOJQhLL7y61inEH+Bd5/BDdkvPw=;
	b=eBROcV4CTFAmFwffeXb0kaanMCtllaGh8zI34VVT4QdT51ikhQ3od+3YMyqlr7a5qXOhUu
	gdVKZ/8sAvJRK0pYZkgm7WndpJRBZ85ejtHHv78onmga3WwhomDFvXLXGLCjhJVPr1L4L/
	oWgfyBYUUZsiHEBiFK6AVNPwVPfbkWc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760672792; a=rsa-sha256;
	cv=none;
	b=BCds4g6Op204xNl1n5xDi5YMrgmhJUDEX2dCPMaAUJcrJ2sEd1RfeJtYKXxoWNOKzKa9RA
	BkxiCXM1gMTnAYhJR4do1q0pPpVL2z4p7HrwgWz8DEabv8PdB/bqIqWoG87FSsl8xNhcDn
	th3dVm5UEJqCgkSGjRsncloQ+huemvY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=4buTEpGP;
	spf=none (imf14.hostedemail.com: domain of BATV+4b0bb848bbbfa73029ae+8090+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4b0bb848bbbfa73029ae+8090+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YKsfrgXDaorO3CUsvOJQhLL7y61inEH+Bd5/BDdkvPw=; b=4buTEpGPEo6NSTYStECW27un8S
	6A0/K7zKACjM+GCGgU3G0n7fF8aoL6jLPYrGKWyhfsEdwRPbZttIM5EfuGRiHfVEHdiFGuNwuG7KI
	pM1VLyvQoTkuD31kkEu+ChXPzhHmsOSISP/MS4snVyI4TmqgkIWQKyHElWw6A0MJ/b0bHnjAndVVl
	XHEBxKjfjohYKpWejuBcyvUyp5ALvzpOEzc7HRp3xhVLblq6HJC0YSCQRMLNsGsWDCO26nafq2BJ4
	iUvEv+9UBhqe99Q4dpLUHwn9/mofAsN75USNw8x3dk7K3B7G7dmSnzXVGrTUbk5OobQ6fv18pDnHu
	7WFgEYrw==;
Received: from 5-226-109-134.static.ip.netia.com.pl ([5.226.109.134] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9bQE-00000006Tyi-1K4F;
	Fri, 17 Oct 2025 03:46:30 +0000
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
Date: Fri, 17 Oct 2025 05:45:48 +0200
Message-ID: <20251017034611.651385-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017034611.651385-1-hch@lst.de>
References: <20251017034611.651385-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam05
X-Stat-Signature: c5431rm1776gd6qridji43grzd9jyj6k
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D910100005
X-HE-Tag: 1760672791-926859
X-HE-Meta: U2FsdGVkX19O7Gyu/FoHZcaX/fx4A1XTCRcLeG2MbyKqdoWKA1I5XUppT3PWomc9uQpakKh7JcUAlZw9Z+d6eTWdYTXflYJkOi6Di4vinEKoMoWca6OOrQWBwt8yulPKLg8vBWS1DQgbsM0f6m/d5pWZ9ny8ip1EMalCDKoo8Kjl5C8hVuPZawnKPSn9dUDC20sl1Jc8TfBlP6BNmrXyeBZ9+DzC9wgQqtO+66SVrwhPT/5JqMM3glVeqfSW7hY1kZz1tl8QpevxjFqo74DfReR7yOo74084BE2LFt3Qm+wjdnnzi5kXUM4jkjylh2tzyM81+Rw8SN91+jrtvYOlwbrQOpdvx8X1npT0quT81hR05M23yIW3dY+yiqILG4Ujze+HX+4YZhx7AzoI/Fx9zmX3ABd0QTqTfa556AvYBnRamnlw8ER4XobDYGVRNoDEAcvmS2Td4+XJNckamIpnGc1ZyIij6CE+xtqdiaheK+tM+02JEG8Sya3bd5HjINGjb4w9P4dDLoP8RZHcSZEA5DdjHHKDLJoDzvScMFhFmFAgO/7depJaUxwE4LgQY1HAV25Uu4JRgDMHvTkv1qyyoOWOjUYH33vHtO77xzwk/tBf7FuNXk3yRFRmSKIV7QtA0XQ2vfUFuUgvjLY01ZAtnPp1NwCHigtg+JMt0QVrKX1rAo4z9+06OZYKSwQjsXqon5eHuU0YCR+6dVHFOxEnwzOrL8f56W9jUbBLKYJ29TZEjFaOijxuZfi8a3bWV87+Vqf8YfYYtw5G80O0GFlGIKTyh4HVPXG+eonwpvIHZnJxQDWT6aGRC/Mh2qdGhtcaN/aGMkLJEXpejBvQ9ZOwKeVF93Wm3ma447Y4lQSKibp6EFb6fgBUprkFgdKo5TvZxydE3pi/fgmgZTDrWoAespo/W1AgcR0bYsZVBhCOc7287o8snM5l5v9Zz7pa8em4S5jzpL+1QXdxKQSqw3C
 GsNd6736
 UveNqrMYibtByJpBDAlKRkviF7NfdZDmwBXi4wKdlHJHMB16gJPIZt/aNkifvlvE37JlviSmQe04HwLinKCugpShjShqF65Du/PvZ1oNsUMMuAyppbh+seWSG0zxZK/wetuSGOp19lmioPnqp7BnduXXI6vwCtoVn2iifdM0XwkVHQ9qK3puIRjTtOwrJ4wcHWAj9AhHEIywEORA3yBVI5nUpmu3Ghg85GrN5LPLdyJcy8rF/n7nmcNftLoJyUrJXPBEOXGbojPBsBZ4g4/N1RB4hmNCKSs98N8jxQca8s26XBhKxPeWBacV/8PPWA2ag8Nv6LF/iwCY+g+KvZ3Z0I2dtOwTVQdQKeNhbTJ+pt0PzCexfYzHYpR2ycbWeQIcFTwKp0CaGasqKc2wGgKSBekDHxyIhbpC/VKPP0TeZO6DLJAXUmpjWL0bFUVJ+aZjE1kUxGlUafPlbAS5JClXt+jovEGqJx0kFZdPKmMufk+CPmXigg6CI8gfqyPVpxp9U79p0esDGYgVWXh7eBymrAmROfawAl7iQg0EPA6b1lmGTk9D7qahmldYpNou2MU5jqc5PVl2zCSW8wxX05oEganLlwcQ+blaG42ON7LvgZVIwiY8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The relatively low minimal writeback size of 4MiB means that written back
inodes on rotational media are switched a lot.  Besides introducing
additional seeks, this also can lead to extreme file fragmentation on
zoned devices when a lot of files are cached relative to the available
writeback bandwidth.

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
index c895146c1444..ae6f37c6eaa4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1583,6 +1583,7 @@ struct super_block {
 
 	spinlock_t		s_inode_wblist_lock;
 	struct list_head	s_inodes_wb;	/* writeback inodes */
+	long			s_min_writeback_pages;
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


