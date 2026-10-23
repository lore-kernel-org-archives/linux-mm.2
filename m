Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B837606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 02:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WKPlSc4e
Received: by kanga.kvack.org (Postfix)
	id D9E5F6B0325; Thu, 22 Oct 2026 22:46:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8F916B0329; Thu, 22 Oct 2026 22:46:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FA196B0329; Thu, 22 Oct 2026 22:45:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F5726B0325
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:45:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C01D1A01A3
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:45:57 +0000 (UTC)
X-FDA: 85352351154.01.28FADC8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1EB611C0009
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:45:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WKPlSc4e;
	spf=pass (imf21.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792723556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FJcW7KrcbrxzeDpcYuSEOOuTzC9YVEEotXFe5+tYCuw=;
	b=LO5drHEJe/cVEpjxIQXp8kPhDFA2zbWyFeqfg9wVIZAtSBXRDWFUG0lix2tCLYoCMvyUq2
	rYvhrkcyIMUs37njRzTp7dLG4IccoBpzre/nDNyqcaKaAGG0JD/+dhz8Q4UD9Qse4yB2o8
	xmuJl9NNMc3GR5hri8d/27vDFyv+EEs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792723556;
	b=0pggyR2UH/6iwGmVArSgUd/8XBGgLD8RBWJPxpsy9ukGZVedpJIH3k5nafg0qkMr4nnYbs
	7mpB25Yw3mXeY0V6vptzOtdGcKsWqz+ZB92uo7W9LFIxExHnyuUE0zUUM4mDijotxMtlgO
	tdgHisQSt6CWOGrxxxPcJ10YjUeV1EE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WKPlSc4e;
	spf=pass (imf21.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A04A43EB6;
	Fri, 23 Oct 2026 02:45:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088FD1F01828;
	Fri, 23 Oct 2026 02:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792723555;
	bh=FJcW7KrcbrxzeDpcYuSEOOuTzC9YVEEotXFe5+tYCuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WKPlSc4eioB0oO3aBYZ34PcGIQYEKGjZPiCkmZXHv0ybz0jpmEUuR3XoYr2iluB3/
	 xpWsohlCYSIuZuJJ60AwyyLO/vlOVrHugMBonjkv+8u9y7o84ecGANPK8r9zEgkWG/
	 YkT8DJyRRDNCVuHZuIFHqoTeZ7IpurQKnCLem/22qTeiSAHCVRL8wHJmskNh71qzz+
	 hB4wKkHPX9fIaOHvOlVl9hU7KU/2WKFfamVZ2KcuHE+71TAgVURbzJq/AtDcu1Do3j
	 dT/c7AQonI7+AlDhZ6t0Gibipt29hWGfnIoSk+InLrQptQrn9niZhUcnIeB/GJZPjH
	 ANRPELDTH4Z7w==
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
	Jonathan Corbet <corbet@lwn.net>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v8 4/7] mm: add folio_mark_dropbehind() to mark a folio dropbehind and account it
Date: Thu, 22 Oct 2026 22:45:45 -0400
Message-ID: <20261023024548.71123-5-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261023024548.71123-1-snitzer@kernel.org>
References: <20261023024548.71123-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1EB611C0009
X-Stat-Signature: yxu8cs91tkgfr5u4nmtucp6q3agbe7uh
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792723555-984333
X-HE-Meta: U2FsdGVkX1943yCM6bJBbHI+DtlWptaqYWvolqQ8qPgg1pZDuoqbsJ/Pnx3kqUujXKyIWtGunlYwo4ON4AZsVEO5YzOT1BTxRK9ERHrJSBD6XXIwGGnCNgB2vqg62tBp316NLCtKxKfdsR9Ls/QAjD3L22O2AaXo6Uj7rreMy15yd4+sPcp/am4N16yjUYWDQqakQgrKyLtuqkSOBocfYCGLbrcAeCxvwnsxLwp1RTnMszb9lGD2w6EHrhd7CI7qkiI0M2Xh+nnKnhBLe9k+1iQS3K0cQ+jrSa5Y+wwsBxkh5mB7L0CAtBz1ukhKzVVDA1QVngVF7svdYfL+Q+fnHWImPfsdEf5MR1p9iOUnq+5JC0hk/EK27naH0fuxJbX0mTDMu3gVU1coBuzOqcGVtntv2Rj67a3MSICczImrUiVLXKbrIo0JRr9Adx0alQJViHHk9P11p1ju+qhxN7KOM2MC3UlMNBjFu+VYX4F4hwYLAF+JhP8rTIKitUTJEqiWocoky9t1nHDhIbLXnW6Ya/EHJnLg5Rvbqwsl8ZUDGKgarHZkBN4nronkV0aex7CN8OJrImvbTm2aAvop5tHeod7lOlEvK3/Dc34q4WslyXkwEABUfk81TeUgjtG5qcNUaFaEKA/0rJSsEZiQCpZ5yHVGEZ5LuDymKB8miZTudRAn9NT8M1EegqhD/YRKMzKbypUdSNPXyiOOSyX1grV3wecRKDU7l5JsHCDeo+Z9VJIEuUgfBa+FzagZ/8u8GiDFPUW+nWZD7LZz1xRjoXNKIyKcvpbsqgEy9fNznSNH/lVJqByhASWVTlEpHxdsPGUs58osBNnnEoxNZErG8KgOYOPYfDCoNGiWhhAPLVDGYr5u1hvsYGHUs3cUm3aDiW/lMaGYAHRlP4atpFe/BaB6cGqh3MbxBukx26XKRk5UlfZAIIji0xKnnjkCz2mEuYKkQpZHKfXBLWCY2V0Fs/C
 t6l5w5HX
 9WLl3P5ya/M/a7aDKED4pKyJZtWtDeVWd38EmSjCV4KFGfcZJWDh8oSBGr+176s1IirS1tOBa1uaHp6yuv17hBB+w2XYdL2L3DY93bfb8L7BB50ncf+vaPdspZHmDNBRQXOzlzj/L3DcJS1Ck29TGEZakGAB0Z+W6cgac8jWi2X8pY7Ht/x/1rcx3lVf3wHLvUR7NpfMNjIJeA9pEHOx8Ra4kPQ4xxLEpoo0NxDjlarH9XqBrdtzvbLC8PaFTfKl083STbom/bwKxUltgJ+fzbYT/yTm8oQBIkmRSh1QFRB+WQ87nIHByVdMVM/Aoj2qtCM47YvyoJx9WNOGh38wdpZXRmGRrC+IfYyzPvcHWyMiMhMw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
__filemap_get_folio_mpol(): with the folio locked, mark it and, if it
has been counted as dirty, add it to WB_DONTCACHE_DIRTY.  PG_dirty is
not the test for that: filemap_dirty_folio() sets it before
folio_account_dirtied() counts the folio, under the i_pages lock and
without the folio lock, so a folio marked between the two would be
counted twice.  folio_account_dirtied() sets the folio's dirty tag in
the same i_pages section that counts it, and every path that uncounts a
dirty folio holds the folio lock, so set the flag and test the dirty tag
under the i_pages lock: a dirtier not yet counting the folio finds the
flag set and counts it itself.  Under that lock the wb is inode_to_wb(),
as in folio_account_dirtied().  A concurrent lookup without
FGP_DONTCACHE that clears the flag again subtracts what this added.

The name follows folio_set_dirty() and folio_mark_dirty(): the first
only sets PG_dirty, the second also accounts the dirty folio.
folio_set_dropbehind() likewise only sets PG_dropbehind, and
folio_mark_dropbehind() also accounts it in WB_DONTCACHE_DIRTY.

A later commit uses it in NFSD to drop a page shared by two misaligned
WRITEs once both have written it.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 include/linux/pagemap.h |  1 +
 mm/filemap.c            | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 0adfa6605653..3012bd95812a 100644
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
index 1cc28224d547..0c76ee5750b3 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1644,6 +1644,45 @@ void folio_end_dropbehind(struct folio *folio)
 }
 EXPORT_SYMBOL_GPL(folio_end_dropbehind);
 
+/**
+ * folio_mark_dropbehind - mark an existing folio dropbehind
+ * @folio: the folio, locked by the caller
+ *
+ * Mark @folio so that the writeback that cleans it drops it.  A folio
+ * already counted as dirty is added to WB_DONTCACHE_DIRTY, as
+ * folio_account_dirtied() would have added it had it been marked when
+ * dirtied, so that the clean that subtracts it leaves the counter balanced.
+ *
+ * folio_account_dirtied() counts a folio under the i_pages lock, in the
+ * section that sets its dirty tag, after PG_dirty has been set without the
+ * folio lock, and every path that uncounts a dirty folio holds the folio
+ * lock.  So with the folio locked and the i_pages lock held, the dirty tag,
+ * not PG_dirty, says whether the folio has been counted: a dirtier past
+ * folio_test_set_dirty() but not yet counting finds the flag set and adds
+ * the folio itself.
+ */
+void folio_mark_dropbehind(struct folio *folio)
+{
+	struct address_space *mapping = folio->mapping;
+	unsigned long flags;
+
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+
+	if (folio_test_dropbehind(folio))
+		return;
+	if (!mapping || !mapping_can_writeback(mapping)) {
+		folio_set_dropbehind(folio);
+		return;
+	}
+	xa_lock_irqsave(&mapping->i_pages, flags);
+	folio_set_dropbehind(folio);
+	if (xa_get_mark(&mapping->i_pages, folio->index, PAGECACHE_TAG_DIRTY))
+		wb_stat_mod(inode_to_wb(mapping->host), WB_DONTCACHE_DIRTY,
+			    folio_nr_pages(folio));
+	xa_unlock_irqrestore(&mapping->i_pages, flags);
+}
+EXPORT_SYMBOL_GPL(folio_mark_dropbehind);
+
 /**
  * folio_end_writeback_no_dropbehind - End writeback against a folio.
  * @folio: The folio.
-- 
2.52.0


