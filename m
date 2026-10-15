Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10603CCA462
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 23:33:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACD016B00A0; Thu, 15 Oct 2026 19:33:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7E746B00A1; Thu, 15 Oct 2026 19:33:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9940B6B00A2; Thu, 15 Oct 2026 19:33:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 63DF56B00A0
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:33:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CD323120233
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:33:21 +0000 (UTC)
X-FDA: 85326464202.27.C35DB09
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3F97E180005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:33:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nzbWYI9v;
	spf=pass (imf06.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792107200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S7mWB/HkMvRX+27OJfDRqz0u/1c8hcSR7gHODYE36DU=;
	b=w8mA1odYNXwUH3QYT09KY0aAIugGCljtSwB7wWOxrrxLsTHqDy4uuhFj7yjECWzRgVzzUe
	0lowJIycHEo4+9EecyZZXyTIoNHs9qCJEtyDiFbU3zrfZwv1YfpJOFWJ39Thvz6RoJAGg4
	dy0eonS/fdj2tiKvCwvGmfjDxDWJhAg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792107200;
	b=dZI3qUEUoo4n/2Q8S6+5F+7mJEw4Uq/50hawfGkOip1mOubba2kHIsxbWmO/D7IudoZilu
	wzDmO9TvCY/sDGAhTTaXkXOuc3wdvQKeqFiQVNvx+yyLur1stnKm+r0wirvdkr7h1JhnzO
	VWr5ghCBjcImAKaAuUZcAlocPYwRow0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nzbWYI9v;
	spf=pass (imf06.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D535860A82;
	Thu, 15 Oct 2026 23:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DAAE1F000C5;
	Thu, 15 Oct 2026 23:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792107199;
	bh=S7mWB/HkMvRX+27OJfDRqz0u/1c8hcSR7gHODYE36DU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nzbWYI9vKI/tTDUA+H9ofYVeqMcDs9WFXnQxapTZvclGE1hgFml0C4R4jzSpqtKJr
	 4MdQr23HDPHbhPWfOHlpbdkMSfvFW7U7dp2+f+CTrwfw+d+oDEwbQizRruYkFAAI9N
	 L++c8R1O3e4tn4B4d3jkdkEIaq9SlIY9iWicWz52cw1yOyoCe0rzoOifjvAs9tqDLg
	 i7+DCKlkiAafmVZ6c5zcMCHLYwdyxgovbSaDz1YshG92cMXd42jSmBeqSqNpd+WYWV
	 H6h3HVHc637r1NlyaS3HfK5DcRfID+ZcMUio7YjcEJ3XvpvyVzb1GdLt45UNs15Gum
	 7NUjIRr94h+lg==
From: Mike Snitzer <snitzer@kernel.org>
To: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>
Cc: linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Matthew Wilcox <willy@infradead.org>,
	linux-mm@kvack.org
Subject: [PATCH v4 07/10] mm: add folio_mark_dropbehind() to mark a folio dropbehind and account it
Date: Thu, 15 Oct 2026 19:33:06 -0400
Message-ID: <20261015233309.42999-8-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261015233309.42999-1-snitzer@kernel.org>
References: <20261015233309.42999-1-snitzer@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3F97E180005
X-Stat-Signature: 9uh3oirfj5bih56mgdyfsrdze6y9jfkc
X-HE-Tag: 1792107200-462795
X-HE-Meta: U2FsdGVkX1+RGATlTJVCUeEOZndlbCHdWHwrTzvbsTiOJh8AX+iSw6b1L+KTfQD7Ath/CfDbIgDdHe14P/i+xPCJeZ6REiWrd4N0g5b3Y8Yj4kzVI8wddrVwp6q3MTCrMmgoedlLAa/ITj3rA2sul7AgLGzwz2fSV962++m2lw789PnOZZa+EDO4c8UU5fIAupUAi3y06yZca5Bcq3ntkED/Wk/HFxcoDZEGqNfFyrwQOspw2PoYsxJKCURJXBU29oaVvGF5L0B/its1lrnti5Mvdp3kSIEdS3TlceD5YgwwKTcn9W98aFSsBM2j8cWZd/RsiF70beqjtnXy6pANhN2DFMP6fOma4jBbscTsTQLwqdqH/+6tF0OBtQWK/WNwJDQnzGKXsDx925Q2j/ai+RL46nhlv7UkdfhWsMGTKnvU2RBUjmr+RvY5iauejbEdx12UX+gmzXS36qAI4piLGVSGwES0Z4JsC/Q5LpLnjgmdd/Abk/SpivI0ArCQqj9rPjNaH5uOw3A8qlV4zBzt1dqi1QutU7RsmtNodf8yrsQM/IPTOff9Cm7M5K2CtZ5q/0NCRbDEXjn8dvwxv208j68R8bwG7GVupO/vqj4EkOhyPVn+9Y27lByUk5a/fkW5+3zWNqImF6OHZJDr7wXv2Dn7o10/vyoh/XDENlr3eqlEsbEoz+KxXsg9B5ioDWyqo1YO21D4i8SYKBqK+30o1rVsg/CJy2AdhdCg51i7grJrxTJIlebDJ2O0Wxuj86lnys7kB9TnmTmEzjHlExw0XHH4tRgoWHiuC/MZsVFk4idTUbBinRRDHGfwUUkBv5qZe3JIpfD/avX4Z5R240g3LRc5dCxmE1HthcEYQ7W7Kgt+yjLuYegxXGdG94w/26mc6MQSWTL8jJfOhGYgsDV5LYRqt7eo8qNTjd/5Plh8XhFEg/BuwU894uGCt+181phCr9hPozXVZtgFv+bvPzL
 UNTGy2Lr
 oEWnAFk6PxFmWMvexsajj2dtRe15+2Lzgm+aBYvF6aN4oWTbOoyf7mYKAsEgksOxqK3CxnOGi7S0ZevzDRTBRDtR5qKkzFPGxgXBxdkwlg15MoLb1HI7bmB2PDpL32UgNpBZ5Ez5UBzjfFipkRd/yjKSr8NphUDG5Q7PiCErnZKfL18JTFsIhEFieKFXxGQtQnZYJQcbL9YK1h6VoC6NWDgBoJ85UPJGyvFJBjWe1zPRbJ8R4CUxe2JFt++EMM7XSGsYRWwCH6e/K2lvMndqfxmJoI4HJ2fmCWX1YSfl5yXrbDMIMwCYP/tr7kKlS5EiPv5s6ggcK5KLCPmu21HRx0Gyz9yWJR5qg8C7MPtUOtQQMOnjryTFbYm0xj5aSJjGGak5c2cQBnI7g7HVp6rKESsNUPktxphU924AhGD8pZDLMq7kIcxPf+nnKbkrwA12FUFigYfztr+SF85vHcR9Jr3tdALzeg25q/93U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A folio allocated by an RWF_DONTCACHE write is marked dropbehind before
it is dirtied, so folio_account_dirtied() adds it to WB_DONTCACHE_DIRTY
and folio_clear_dirty_for_io() or folio_account_cleaned() subtracts it
when it is cleaned.  Nothing marks a folio that already exists.  A
caller that sets PG_dropbehind on a folio that is already dirty
unbalances the counter: the clean subtracts what was never added, and
once the counter goes negative, wb_stat_sum() reads it as zero and the
DONTCACHE writeback kick stops writing anything back for every writer
on that bdi_writeback.

Add folio_mark_dropbehind(), the inverse of the clear in
__filemap_get_folio_mpol(): with the folio locked, mark it and, if it is
dirty, add it to WB_DONTCACHE_DIRTY.  The folio lock orders this
against dirtying and against folio_clear_dirty_for_io().  A concurrent
lookup without FGP_DONTCACHE that clears the flag again subtracts what
this added.

The name follows folio_set_dirty() and folio_mark_dirty(): the first
only sets PG_dirty, the second also accounts the dirty folio.
folio_set_dropbehind() likewise only sets PG_dropbehind, and
folio_mark_dropbehind() also accounts it in WB_DONTCACHE_DIRTY.

A later commit uses it in NFSD to drop a page shared by two misaligned
WRITEs once both have written it.

Cc: Jeff Layton <jlayton@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: linux-mm@kvack.org
Assisted-by: LLM
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 include/linux/pagemap.h |  1 +
 mm/filemap.c            | 31 +++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 0adfa6605653d..3012bd95812a1 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1310,6 +1310,7 @@ void end_page_writeback(struct page *page);
 void folio_end_writeback(struct folio *folio);
 void folio_end_writeback_no_dropbehind(struct folio *folio);
 void folio_end_dropbehind(struct folio *folio);
+void folio_mark_dropbehind(struct folio *folio);
 void folio_wait_stable(struct folio *folio);
 void __folio_mark_dirty(struct folio *folio, struct address_space *, int warn);
 void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb);
diff --git a/mm/filemap.c b/mm/filemap.c
index 00fd89cf6f550..ed7e4dbea653f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1644,6 +1644,37 @@ void folio_end_dropbehind(struct folio *folio)
 }
 EXPORT_SYMBOL_GPL(folio_end_dropbehind);
 
+/**
+ * folio_mark_dropbehind - mark an existing folio dropbehind
+ * @folio: the folio, locked by the caller
+ *
+ * Mark @folio so that the writeback that cleans it drops it.  A folio that
+ * is already dirty is added to WB_DONTCACHE_DIRTY, as folio_account_dirtied()
+ * would have added it had it been marked when dirtied, so that the clean
+ * that subtracts it leaves the counter balanced.
+ */
+void folio_mark_dropbehind(struct folio *folio)
+{
+	struct address_space *mapping = folio->mapping;
+
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+
+	if (folio_test_dropbehind(folio))
+		return;
+	folio_set_dropbehind(folio);
+	if (mapping && folio_test_dirty(folio) &&
+	    mapping_can_writeback(mapping)) {
+		struct inode *inode = mapping->host;
+		struct bdi_writeback *wb;
+		struct wb_lock_cookie cookie = {};
+
+		wb = unlocked_inode_to_wb_begin(inode, &cookie);
+		wb_stat_mod(wb, WB_DONTCACHE_DIRTY, folio_nr_pages(folio));
+		unlocked_inode_to_wb_end(inode, &cookie);
+	}
+}
+EXPORT_SYMBOL_GPL(folio_mark_dropbehind);
+
 /**
  * folio_end_writeback_no_dropbehind - End writeback against a folio.
  * @folio: The folio.
-- 
2.52.0


