Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EAAAC5AE49
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 14:46:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 936206B00A5; Mon, 10 Aug 2026 10:46:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E6CF6B00A9; Mon, 10 Aug 2026 10:46:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D5CF6B00AD; Mon, 10 Aug 2026 10:46:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56E4C6B00A5
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:46:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D0AA1140140
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:46:04 +0000 (UTC)
X-FDA: 85085634648.16.A21FABD
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5C200100009
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:45:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ZjlpOaxc;
	spf=none (imf14.hostedemail.com: domain of BATV+e92feb25c851dffaa619+8387+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e92feb25c851dffaa619+8387+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786373160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Lmb88p+cpryq5HXWLXRKXYmtZimwxaBhgeOhNY3PzE=;
	b=mnZQEZpeU57CPmEp7SELvSHbcvrMAPRq/2OnZ62/rLE769mO/T04ou3LFgunw05xqHiYRm
	PHGSdiouk7tjz8E2EIJHTxwlp2EB/DgPnOZ0FTzwMxbtXWQZJk03QoxNL24hvfoNqtjDRa
	JOlgQnjcI3R/k5dvF8JynO5flUmWWQg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ZjlpOaxc;
	spf=none (imf14.hostedemail.com: domain of BATV+e92feb25c851dffaa619+8387+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e92feb25c851dffaa619+8387+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786373160;
	b=6+Kkyz49GqYTus1XwGGZmRqE1qF5uEPgJ+aJKIANKlprwz6PuFlKKIjm6nPBUIFbvT2jFt
	xoBgX76PLIL4PJjC4LIM1Z6yJyjwz3CvdAd8BPD//NZHPbf3c9JmS/pZdLmosSUEQkRoxJ
	cX0PwHhhg5Ec1ow4CgZyJRnqtzDbklE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=1Lmb88p+cpryq5HXWLXRKXYmtZimwxaBhgeOhNY3PzE=; b=ZjlpOaxcjkG2f9OfkwELBNEzTf
	ggKbF5B/67GpDWQrfUEvvWOm6N35oevLeRO+6030iJHPj2PMWXpaVJNv2DIyP+hoYeHLmSGhctapb
	XIWAc93R4BkxMMeHs/qT7cJ04hcrL1srn8hMzvbpo27fVKLTPh9o17t71xQv1LzenM628CCqDIVCM
	0PPEM3Fzl2tBQIgkvF7VFgp+VT6O6s/c5dYBFz1uP5ISwD07DTcy8DmnF5TwTbrxwV4pvYGuhKH0v
	XX+DTw51mufx9Ucgtu6kXV8a8QyxeZIQAMXvdBM9tD4QHFcET45iUo8jbR02cL5G8JYBbwoWtRyNV
	sLfeSgLw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtRFt-0000000C3l2-13Nj;
	Mon, 10 Aug 2026 14:45:35 +0000
Date: Mon, 10 Aug 2026 07:45:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>, Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Hillf Danton <hdanton@sina.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-erofs@lists.ozlabs.org,
	Christoph Hellwig <hch@lst.de>
Subject: RWF_DONTCACHE regression fix for xfs
Message-ID: <annkDbhXBEeMoNVT@infradead.org>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: 3nq1dgux3hf6hc48ehxduk7keghispzn
X-Rspamd-Queue-Id: 5C200100009
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786373158-543831
X-HE-Meta: U2FsdGVkX18P+z9zrsDET72+xxrYnsvJ6vWQmHbg/VW0GBY2cGj0rwIW1BsHPFK7UqdR8KVf2kcd002FmpTVh2jhXq9eHnj/Is/8d5+W8jIC4/Pne7dg8BTalmuiB2cncRLRwvzx/lNjwfv35WVjx4kmiVxV5C4GXJzbVnu8pgi5d4qgRW4EwEF4VUWyWzHFr1si7HfMixmjl74mKz/agQ2q3pCf8HA8mAeHD2Qe63B5FYKgpMx9gnaDbGOJGqgB3PklR72cVaWFQGpxSBKupl/JiSQI21k/YKxSRmcvQrCPnL5hZwLv1Nj6CmtoZmg1FroR7Gd9gkysfKvIVj5xMF0d09gxfJhiwyqcxCl83TO7bVOZadQQ8qxofr06tUDIUZyE/nIJe/DexXYd5WepnDC6SYKpUfqv6mIFW+pt2MZ2Qf7Ae1T5ZsSLeAa7QjzrjZi5L8R45ty9lQRMVsozr6q4zEH77F968BWLA7HaceTjdPEUBCCYa4HfGXZo9e6v0C3ZLB3m6+8EL6sAjy5gjSX1YDKHoNSF9XCXFQbwpONHo0wgB+OTKEoagwdsfbIoyTv2Jng1N9l3eQTnmQFCR4OXH+a8KSSfHCAHHIR+QoCQO2l1D3ZVZKckjNZKYunrf4GFIjDqDnjLIdpf5BKmN147ewF1Wl0dlYzSKs7fu5tTtxNpDfm6I9Dsg9pn/1iONWaAw/+qglBPiuRE9q7c6GwTRjTcyZSPRUn9MmuCcDlPGFeats+SMwGLZwJKFYErBkMa/a96xFh9jt2/e6GUy9T8Yw0WhfvFhCDC8+h/Q1ci6eJU6Csuxwr0tBBUc0g1axS7EYynSs0XX+E4ibf0xELS+AmeRDyn4KLIZQVqkbRHGDsmvH+xYn+4FHhtSlnFsC/TfrFA1XaB1iNVexSOD75XO3kz8T3eS99Zbm/kfq0cKWcnvg7Znql+PSJ/rNoYrAbYF3qdfc6a0VyVCRV
 3oXJ5H3P
 EsdEJwG+2y8GJk1VyQ1kWWCnpiOPMsoyhUlEm9iyO+4nw9kBfOKjwPnmBbCS5I/lt7b4tj9Dx5qj92qSeXhK4Ed+mnycBUW9wUmSSLVswT5brFcWHwAXZbsFkeUZwLAARFa/vBmkBwTvSV64AK+PYO4u8gaxCU+3L+cmx/t/LF9XYd/YHiKZ+rjL67q6NhWFR8ULFxF9zZCbOT798QNmzYyeaq/SAyy5fLQa4re8Cz/xw5+3deQRE2rr97lQE5a67CTkXyQutKuKIV/0pIN9QJYPYUin3qbmc/uvMfFkAmptvvJCqjtLKOLILe7kSzWauHF/B+iPlMRSRARdInGTyVOk3FCfiNXuOQZRPLGP8L8JwtXu030uRd0QoZb1ITInGHvExx+fLVZeC8zd+Qi9sV4YZOmjb+E36LJb4csDr9MLzX81FlXCuZgK8G7U8GNyAJKMHql05TVsPa0dV3hQK3uMMNh4iJyO54VdFVf03CnllD/cwU9aeElnxhzrB1F47yBxIbGoH+8wDDPs03MFOZDEqXblnNLoHxQt5wMG43UZu28T6PuGOqDbebMuDWCGR/4m0g1Eqh4qxWbzAuc2tINOyJoPxxGXbGeDyZJE4QLNBOI8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Below is Tal's suggested fixup for xfs with the whitespace damage fixeѕ.
It should probably be attributed to Tal instead.  Can you handled it
from here and send it to Jens with your signoff/authorship to avoid
the performance regression in XFS?

From: Christoph Hellwig <hch@lst.de>
Subject: xfs: avoid double deferrals for RWF_DONTCACHE writes

XFS already defers some writes to a workqueue when transactions are
needed to process the I/O completion.  Disable the block layer bio
task completion in this case to avoid a major performance drop.

Fixes: efbde6f9f449 ("iomap: use BIO_COMPLETE_IN_TASK for dropbehind writeback")
---
 fs/xfs/xfs_aops.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index f73e26d9c9f9..059846a8d65c 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -372,10 +372,14 @@ xfs_writeback_submit(
 	}
 
 	/*
-	 * Send ioends that might require a transaction to the completion wq.
+	 * Send ioends that might require a transaction to the completion wq,
+	 * and disable the block layer task completion for them as there is no
+	 * need to defer twice.
 	 */
-	if (xfs_ioend_needs_wq_completion(ioend))
+	if (xfs_ioend_needs_wq_completion(ioend)) {
 		ioend->io_bio.bi_end_io = xfs_end_bio;
+		bio_clear_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
+	}
 
 	return iomap_ioend_writeback_submit(wpc, error);
 }
@@ -481,7 +485,14 @@ xfs_zoned_writeback_submit(
 {
 	struct iomap_ioend		*ioend = wpc->wb_ctx;
 
+	/*
+	 * Defer all completions to our workqueue as all zoned writes require a
+	 * transaction to be persisted.  This also means we never need the block
+	 * layer in-task completion for a task context.
+	 */
 	ioend->io_bio.bi_end_io = xfs_end_bio;
+	bio_clear_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
+
 	if (error) {
 		ioend->io_bio.bi_status = errno_to_blk_status(error);
 		bio_endio(&ioend->io_bio);
-- 
2.53.0


