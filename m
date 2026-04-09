Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62A89F31E5A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 16:03:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD6766B0095; Thu,  9 Apr 2026 12:03:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BADB86B0096; Thu,  9 Apr 2026 12:03:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEAFA6B0098; Thu,  9 Apr 2026 12:03:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A1FC96B0095
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:03:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 551FD1608B0
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:03:32 +0000 (UTC)
X-FDA: 84639487464.28.F00459B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2A6781A001A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:03:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=QOyc9qzH;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf19.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775750608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yHuKf2R6hPmZq/lyD6SwLuCsBOBwB+98uzk4f/Q1h8o=;
	b=oeURdq26nc03+MVjBFTngJHjz6V/wH8JaKEDULik7OXRZMIv4HleOM8bu3PZw4sdHuJAP6
	97lHhUE0DFwg7ATT9u8m+yGPiTut4zSyc4eZ3ip5/7AsHuNy2SvtWLw07De6WFmQKqALy4
	m57nfSD8o8uk8U78b3B+cn0tevKNF64=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775750608; a=rsa-sha256;
	cv=none;
	b=k3Wr5G61QEDN4m7TP7q1WBm/b9yE++uUrLO1EbMp1HKSIPF+CqwzPX6mCkMRdnd3arlAq2
	JUr5Q6SA8o6NhdxDOJETszLPlUzMCmiyAOUfTpkJx/D3IPBeqoHJocRUfjoP0/P4PML3yV
	R+bLMWyHK53AD4Ri2gFxqr/DuqQL2to=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=QOyc9qzH;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf19.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yHuKf2R6hPmZq/lyD6SwLuCsBOBwB+98uzk4f/Q1h8o=; b=QOyc9qzH2e75thhQkjHTN1KHVi
	mKc0XxeymZyrfDuiMIl8i00TLzDpGYoEidfZSzOMCAIxYaNH2irye5JqXRGrjvf3WIwgjpTy/8UdI
	eBL32Q43vpGGLs7SzgCgBw5NoF3CEU3TbR6S5QjxIp8a3gZschRvaYiiPnsKTi1xdgXYyo4WYAYRX
	z4chf+j6oy+HGPNb5W0OvIXyNbtKuQ8IFLKRYyUibu2Lyitc8+hDNihpmoEvBMgK62a3Td7tmWeka
	hqOv15xslwvIdXpycxdFt+0ZJliRCFo/Q+o1cCLeSMAF2C44AGdsicdwnNocbnFl+mR87GWVvC/pM
	gz9/jcAA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wArqh-0000000At4a-0TzF;
	Thu, 09 Apr 2026 16:03:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/8] block: enable RWF_DONTCACHE for block devices
Date: Thu,  9 Apr 2026 18:02:16 +0200
Message-ID: <20260409160243.1008358-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409160243.1008358-1-hch@lst.de>
References: <20260409160243.1008358-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 2A6781A001A
X-Stat-Signature: ujgquo1g4cfxfucsfn4shay5k6mjwjj9
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775750604-384401
X-HE-Meta: U2FsdGVkX19GePkad7wnelV4Ixuv00Hu2CJfOGnOnLmiCtvv2zIQHzvKap+XHMR2fx77M6CTzRLc5rft9jkLtDq395ms7WR7GRBDIobbnITyuSUjsmAfUbW0lByYYn1txIXz942TMdCllfavULqkBz3HdSoJBzZk8r9LohHu0CIBmUP79bPYLv2pJV+7Dvdo78krLUcROmpzD0n4qo9ZIU1Yn8v2OS+TrsHhRVaM7jPz2bOVXiUiUr/d3wTLdyBDW3QmlWBQWE28KzNeoZiF7iQ8aL7rqn/bsEA7+x3xtRVZisY5OyY6/ln5LhcXFuvvxOQ8OVUj/vcPNZcbQTPLImgBV6qKWnv8V6S3iQIv+DJ3JQ+ZvD0djkOLKaKmq1avkk06QNagU0A1bEx8W5ke+Ans0IY1TWAubE8tsdXPfaqEKR5G1ryGcHIwJSG/8H4oonJOCNQwNcyohP/1ApmBsQg5YQUFYWFOO2o7u8kMBQUG2QEA5heiW+l8/OQAHPidafE9peH0zOXm8AwYsx2EX2vGVMMEDhndzaiaoeMCy5uIO0Ug3sRGwzFmiqMpTSQMyc/6YIYYqKDhFXS2t7z+F4YVpsltncQH0MLMFB7y4MYiwcaUNf+73S+FuJDOHWhHk9wDJa+niwdbHM8TXVE+vfj1nvEuWOWQoAIZnv+CYQS9+OdAvywRRzx0JV715WlUG9y1LIzyeM2WhkqnjZQO9rCh4vI7UpbqQfgVwB+G/W0XS7AsCLAaGnw8HYChThJ/sPjP4SBmLiWphiL5z8WtOqe/GatG4gqFDUdzKkdXOKLl5Pmsrdm7cRDSZET04DtEPY0eEVXdoUSN2d0gdihT7zQ0PG33Ut9C2OGJt8A9Gpq7/fn40W1kXOO56PcQ6B7CAA7WB8CHEF6oxnVtzE8SCT/6TtGWfC6fiLFsNt/weJqjm74i62QQUKMqi8+NKSey16RgGte6u0Cwi1iCRxM
 QpMVbnzz
 zMi3w4amHuazAKcemzLkW7ZCy9jhKaodVbJT8ECNrB3/QZH6+zX7ur2ubDoTtXkJgeeZ/dCArFW0gUIDEiiv8KdelirQ2newq/ypzQvU0apak3ZanXGoVfGsN0ETZnlJGcEJmHMMQD5QITmOFRNq+dyW6rCOVgdqz1xJwv+2T4UoMdHeZ+QDrS36tyskJSjqhyaEoXpdDYUpyWffjLGnN1LA10o3416UNKmJ7QQvO4j186pZDA5OIR7psRe2p7ad8iBVZJ+4lCcGF7qaadvdJsl2qWiJGgf5vTMfc5VZe1AsD1F5qzwNh+ocqQzc5c+c+1g9c8Sjz7J2jWpJuAXN16Bxp/HeRNWPioNQUdxdYum2LdNgGBWJQk/Dkh/3GCUyQAmg6Qh7WxshUxmEK5buWdJl8bk6pf8/XUZ24O7qThqWuSdSeuOwGSaoe7MGUNcHgaTUqi0ed6RDMI/C7NdL/c5XcEZ+1YTcvwAVPPmUKdBWNcEKEMvhddTK24JVjzEQkHKvnnn2GuZbLcHU/zriYszOsu2f6eRFsrHOYLCFQico6ML6VRvrgDyL8Gmq0kD+/vTmtgm0lVfm1A3GmmA3Ylvam2PL37L8phCkO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Tal Zussman <tz2294@columbia.edu>

Block device buffered reads and writes already pass through
filemap_read() and iomap_file_buffered_write() respectively, both of
which handle IOCB_DONTCACHE. Enable RWF_DONTCACHE for block device files
by setting FOP_DONTCACHE in def_blk_fops.

For CONFIG_BUFFER_HEAD=y paths, add block_write_begin_iocb() which
threads the kiocb through so that buffer_head-based I/O can use
DONTCACHE behavior. The existing block_write_begin() is preserved as a
wrapper that passes a NULL iocb. Set BIO_COMPLETE_IN_TASK in
submit_bh_wbc() when the folio has dropbehind so that buffer_head
writeback completions get deferred to task context.

CONFIG_BUFFER_HEAD=n paths are handled by the previously added iomap
BIO_COMPLETE_IN_TASK support.

This support is useful for databases that operate on raw block devices,
among other userspace applications.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 block/fops.c                |  5 +++--
 fs/buffer.c                 | 22 +++++++++++++++++++---
 include/linux/buffer_head.h |  3 +++
 3 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index bb6642b45937..31b073181d87 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -504,7 +504,8 @@ static int blkdev_write_begin(const struct kiocb *iocb,
 			      unsigned len, struct folio **foliop,
 			      void **fsdata)
 {
-	return block_write_begin(mapping, pos, len, foliop, blkdev_get_block);
+	return block_write_begin_iocb(iocb, mapping, pos, len, foliop,
+				     blkdev_get_block);
 }
 
 static int blkdev_write_end(const struct kiocb *iocb,
@@ -966,7 +967,7 @@ const struct file_operations def_blk_fops = {
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= blkdev_fallocate,
 	.uring_cmd	= blkdev_uring_cmd,
-	.fop_flags	= FOP_BUFFER_RASYNC,
+	.fop_flags	= FOP_BUFFER_RASYNC | FOP_DONTCACHE,
 };
 
 static __init int blkdev_init(void)
diff --git a/fs/buffer.c b/fs/buffer.c
index d6e062c42a8d..289ab33fe3fd 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2131,14 +2131,19 @@ EXPORT_SYMBOL(block_commit_write);
  *
  * The filesystem needs to handle block truncation upon failure.
  */
-int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
+int block_write_begin_iocb(const struct kiocb *iocb,
+		struct address_space *mapping, loff_t pos, unsigned len,
 		struct folio **foliop, get_block_t *get_block)
 {
 	pgoff_t index = pos >> PAGE_SHIFT;
+	fgf_t fgp_flags = FGP_WRITEBEGIN;
 	struct folio *folio;
 	int status;
 
-	folio = __filemap_get_folio(mapping, index, FGP_WRITEBEGIN,
+	if (iocb && iocb->ki_flags & IOCB_DONTCACHE)
+		fgp_flags |= FGP_DONTCACHE;
+
+	folio = __filemap_get_folio(mapping, index, fgp_flags,
 			mapping_gfp_mask(mapping));
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
@@ -2153,6 +2158,13 @@ int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
 	*foliop = folio;
 	return status;
 }
+
+int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
+		struct folio **foliop, get_block_t *get_block)
+{
+	return block_write_begin_iocb(NULL, mapping, pos, len, foliop,
+				      get_block);
+}
 EXPORT_SYMBOL(block_write_begin);
 
 int block_write_end(loff_t pos, unsigned len, unsigned copied,
@@ -2481,7 +2493,8 @@ int cont_write_begin(const struct kiocb *iocb, struct address_space *mapping,
 		(*bytes)++;
 	}
 
-	return block_write_begin(mapping, pos, len, foliop, get_block);
+	return block_write_begin_iocb(iocb, mapping, pos, len, foliop,
+				     get_block);
 }
 EXPORT_SYMBOL(cont_write_begin);
 
@@ -2711,6 +2724,9 @@ static void submit_bh_wbc(blk_opf_t opf, struct buffer_head *bh,
 	if (IS_ENABLED(CONFIG_FS_ENCRYPTION))
 		buffer_set_crypto_ctx(bio, bh, GFP_NOIO);
 
+	if (folio_test_dropbehind(bh->b_folio))
+		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
+
 	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio->bi_write_hint = write_hint;
 
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index e4939e33b4b5..4ce50882d621 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -260,6 +260,9 @@ int block_read_full_folio(struct folio *, get_block_t *);
 bool block_is_partially_uptodate(struct folio *, size_t from, size_t count);
 int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
 		struct folio **foliop, get_block_t *get_block);
+int block_write_begin_iocb(const struct kiocb *iocb,
+		struct address_space *mapping, loff_t pos, unsigned len,
+		struct folio **foliop, get_block_t *get_block);
 int __block_write_begin(struct folio *folio, loff_t pos, unsigned len,
 		get_block_t *get_block);
 int block_write_end(loff_t pos, unsigned len, unsigned copied, struct folio *);
-- 
2.47.3


