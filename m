Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C517CCD187
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 02:58:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 672D18E0005; Sun, 12 Oct 2025 22:58:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AE118E0002; Sun, 12 Oct 2025 22:58:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 428A78E0005; Sun, 12 Oct 2025 22:58:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 324FA8E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 22:58:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E9A241A0157
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:58:30 +0000 (UTC)
X-FDA: 83991582780.12.1623DF3
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5E617C0009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:58:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=maHSux2m;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf28.hostedemail.com: domain of BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760324309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k7kWsG81WpnYygnvfC8rInS9rSdz4W8cC7aKY0cPGLs=;
	b=BMDMWMgbl5qO3Oka2FJIjrAz4sxQFOhTAW4bE/HTDvZZhd9Ir5fufRcTtXmn/ue6b2qjtx
	Ws/tyo9ksbBdoGrtTujAjgsU/okJViyc39PBU/v+y+1LC84UMg9H4FCwP2zO4BdVjFGAQo
	dgKPiy3Pj/L1ZHX7kSOvFos4Em0cl5U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760324309; a=rsa-sha256;
	cv=none;
	b=mw4/6adQDjEsCM8XIDNs1Estj5xWu2M6A2uUHKnJnWWOiaqHU+tVGV36YlHKmJnN/VBELV
	2GBnAm6WkBbDgk8kc7ytvltciW6Qno8sAJjSIqHX6CbmhN9qdb/Oz3u+nS35MyBpqoB42D
	j57Ff1zGxlJBM/mwOKj6XEwc2IEESh8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=maHSux2m;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf28.hostedemail.com: domain of BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=k7kWsG81WpnYygnvfC8rInS9rSdz4W8cC7aKY0cPGLs=; b=maHSux2m35jlsPKGQB66zbYMn7
	kGD7mWvZJomyIRGH52uw+6DlYEBnyMX+F3wDTPNTff6hpDDwK3Rc4lMaEHjWG5lOBy5Yx6E1SVDCS
	MkGH4QSVr+7PLk5yB9Q7tBxQGJlgu708ZZlx7vL5YT7Jjn2ag5y9j6CmiOWkILQXQvaAbGrjKfOqo
	hxjDsEw7eHk+B1KQkdONUXUT0UTJliS9OiwDlZoIJguOVFdVwz8fXyUfU1CIDry0ywa4I5c0DnK+G
	sTXHVzriLK2ibD84Yz2cQxN4rUFED8OOYoxL7oV6vhWjZh8aJCGtcsgr7I/wo3qfGRS+vJOnxklgn
	HNxl422w==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88lS-0000000C869-0N1Z;
	Mon, 13 Oct 2025 02:58:22 +0000
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
Subject: [PATCH 01/10] mm: don't opencode filemap_fdatawrite_range in filemap_invalidate_inode
Date: Mon, 13 Oct 2025 11:57:56 +0900
Message-ID: <20251013025808.4111128-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013025808.4111128-1-hch@lst.de>
References: <20251013025808.4111128-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E617C0009
X-Rspamd-Server: rspam02
X-Stat-Signature: tgmpc5teidn5h63jsb3zhhzehnjpgkia
X-HE-Tag: 1760324309-125021
X-HE-Meta: U2FsdGVkX193CR0NtIykf2U1NS4eRwfdlMQ+uWRSC06PYyUhikUCALU5wm6Bw/l8slUFZBy577GRhDky4WIKg3VbjD+ZlZMr97XiOZDefpiv3LW49ybd4Q1J/WeUDuv8RdoVZOiotmZrY9fzBQIsikALWs4AadywVZAD4FyD7VaEU3V0qNpUYXjanOjCv160EhjggIw/K1m1IEpuxUs/RP9BMtnynlzZFyjILq8x+Kh7QRWesKMn6cpCmX7boqpCB0G5r0AXxPAgV+fhkfLBLf8iGPOTewdzfmADuP4SVWmJgiP0Z8gP/QwFwEZP35CnueRZf+KoQdo5qKDVQFzcPiL70YfQJ1Qg05IYrG0P74/01J4QSQD1s7lY3EMo8wXxiQ6ZRwErmRFt/VLie0M6bjMpuLyvxJDU5kex7z+RxQesx+xpDxB4vULQbjyisC3IWNV6NGiX7QHp4xacrPktxTnB62IPJmYBh79az9mGPHelgTVc5d2yJf5jXSqem8eRv4Gg3HLiDsv0z0Zs8MTZXUYfl6wANB1JuhRZ8ey3SUCHFM++24Kkr9grmgWC4UUhTWTV3n4lvzfDNaPBphgTWmEBSB0pPTNRuCUhydmPoFHPywkygbYEF/FmNk9PAOSWbxteUl7hsUjKpT63xAfJK7q2yFIMV9OIvQvuYs3qW62LFJaZmD/BpQ9v40gEZkgKfh7++U+FpOZde/AnM2u0pIOh48MUDT92IjI5zNLcLNcHB0/tPXQ70dHEiviYxXgOwFqR8q98EtWN3qNQNBwusde5zl1SCshEP3petOnqHsugqfr9CbE+gb4d+2RRPoaV0uiEyp6Q7P763RMpjQ/CWTCOVaAPGjGbQXKHtNk1slj/CQrVLy0Dj9KTMmYbuQeUM2Pg0NRxveY05SY8t8jCExq7oNlxMDb2W8f4UgfvxZXTDM9k2pq4jTKCr4yfadIAPMBUFACJLNZ9nCWRKI6
 1UcEqNiT
 e2THwD0ktx9yUwTy2u5/LKlhftpEaLzU+th9AEfcd85Jb7rwqYa7kaDrG8/EvIbAuBNVXeodOk3ABZzgXctj0tJRD7fSZVq0JXTAv7YTOBZr8qWUgBtCMoqjwZ8ZRqVSu4fGIXyX3i/yErMj7SqRBF3LxI0mPjtq+tc1BGquuq49BdaioaHJ2VixxoDW5ImO/JTOiFhptWBIFkiu4+0irrLsBzpGnqWz5GlciwG9fWWykRInYkrelsCn3i1SILV8+TdE7zeioWMU4yWYbfA9PbMhj2i1MImrOQJygFeQk0yhmOiYYmL6CcO25WOtdVfOJ4Vi+1ZHjF5XScppv1zmqp60+SeXfZ5XTBHRHIetJOUsLCE0fQv5pDIaXER2Sopj3N1GTn66fUlfDxgsfRhNCMnVnv+Ga0eZCLKdDnFr01jbgs9ZBxHmrQYR6uQIdemS9XySQo3s9VRA9BMQjI7gZzqBbt7B+Ex0l/bWrW1vj27UHsAsIUYykLlFqor/YRz4LpZhX0HUEEhta15k6XuHp4BpVhsH18ICv/R0k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use filemap_fdatawrite_range instead of opencoding the logic using
filemap_fdatawrite_wbc.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/filemap.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 13f0259d993c..99d6919af60d 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -4457,16 +4457,8 @@ int filemap_invalidate_inode(struct inode *inode, bool flush,
 	unmap_mapping_pages(mapping, first, nr, false);
 
 	/* Write back the data if we're asked to. */
-	if (flush) {
-		struct writeback_control wbc = {
-			.sync_mode	= WB_SYNC_ALL,
-			.nr_to_write	= LONG_MAX,
-			.range_start	= start,
-			.range_end	= end,
-		};
-
-		filemap_fdatawrite_wbc(mapping, &wbc);
-	}
+	if (flush)
+		filemap_fdatawrite_range(mapping, start, end);
 
 	/* Wait for writeback to complete on all folios and discard. */
 	invalidate_inode_pages2_range(mapping, start / PAGE_SIZE, end / PAGE_SIZE);
-- 
2.47.3


