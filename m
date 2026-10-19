Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAC9D608485A
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=essh9OvE
Received: by kanga.kvack.org (Postfix)
	id F404C6B02A1; Mon, 19 Oct 2026 11:07:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F173E6B02A2; Mon, 19 Oct 2026 11:07:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E563A6B02A3; Mon, 19 Oct 2026 11:07:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4F096B02A1
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:07:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 320D98072D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:07:33 +0000 (UTC)
X-FDA: 85339704786.23.4588979
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7516C18000A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:07:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=essh9OvE;
	spf=pass (imf06.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792422451;
	b=i2bbsa6dmUM1/JDvqPUP88V2P/GitwY/cnjbnIJ7Xmn0u+QooWWpyqhJjaA6jHnTQJEzDv
	GMSkGVrJusySid81s8tphI8BxMZg39alOvBQ+OmN7TezYpnqNWiXP2eARdyxN3DvFGreBh
	K4IwPUjYOJk6yQxq/GtiXKPXoqOgFAM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=essh9OvE;
	spf=pass (imf06.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792422451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7y3NOM7xqvWmL65AFq+ZWC79CgE7opPLQwAIectARfc=;
	b=pUT7dbntv9mk21BQO9YWZmFJXaBAntDemZDOEFnyxSS8o1zGzYB4WcYSCM26a8BVMrb7lf
	GV3EuRW5/9tqtaGnbwVYOUFHVQaa9WKoTP7Winqas+Kip/L7UQ4gp5LoXB7EKNdHg5QV4y
	Nj3KLWOFFfx9cxYcpl34GhGgVx2t5ug=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B739643E45;
	Mon, 19 Oct 2026 15:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD2B1F000C4;
	Mon, 19 Oct 2026 15:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792422450;
	bh=7y3NOM7xqvWmL65AFq+ZWC79CgE7opPLQwAIectARfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=essh9OvEhCNgIzvXj70luMYDVXtcP8DELRtgMlhe1mMVJnzfaVGUkxkYbOPRmTL8D
	 OGUqMGkYVSgbRgupoV8D/5a+w+s6wsnLtP1XfgxGHzcGCXPwRTGP7YrTSTONWKRCzp
	 ImUT0DzjRA74z3ukf+xedel4OBNzDoykCxxg5TX81/qvSPy7dAPVJsQZf9W9jjMf+4
	 DvNkhL1xMliJLz9ZMTlIhD5wdz8dw2PFfkgGXfxNlfQzi/vxAO0OVYvkOFftRIQl2L
	 BV2u2yshAT72wI+uW+QCFE8gOH6AJivte2T9movH2sbplMjbA8Ah0YHlbspTiyWvPL
	 YBgF2o/in2O6w==
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
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v5 3/6] mm: add folio_mark_dropbehind() to mark a folio dropbehind and account it
Date: Mon, 19 Oct 2026 11:07:22 -0400
Message-ID: <20261019150725.1507-4-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261019150725.1507-1-snitzer@kernel.org>
References: <20261019150725.1507-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mk9zipm9g3q6wak73d4ardoyxsgysgua
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7516C18000A
X-Rspam-User: 
X-HE-Tag: 1792422451-488851
X-HE-Meta: U2FsdGVkX1+2Y2GFNEIpkb237Ov0x0oObRgAARxx//fm1yf1dwzdaF3riFZcRRNV/HagMrpEDtA0b6zs1+3Dmqd0GIGwsSgOtkGr5G22jArx1ToFi65H0rvL1eBeR4BS1XQdDFaqNr/pA/SmUWU/5oM8encookybZDzSmm415lvnb9vJ2QXH2rMdjQVgDp8RLLzZ47BG+dfTHmfXApzZyp5VvrkFgYi7nOVgQwxYEn5QB3T5hzF2gIqeCIbKGIiZdJRJEhFIcrRXLNlClKLb/tnHrMLLFSAOm3Y1TdW8x2n6jGDQ7GSABuaAwOz0Vvf31PgU7AvCaOmnHWGuTcLnN/80iVmRED83Ho3oQ+fOONsAoY7Ac+m5sH7qLAWVALRqD1D+f+TjVGiOrO9NOFzAqJLuVQdsiQS0HafB6VLMfbIqYGEvZ09I/Dpho8XSpzETRjMif85hDl2MSXVsQlNcCbPKtJfTyLWh7GsUC7CnmwOOVvpOnRfbDiL0bun+19MH9hAWpY+/Pv/VyG+jRTAfFPZw2k/JR6105EuiW83hNFWmBRDyiJzL0NerLGuklnzl82hi9BnkOSGKS/DrbGriirgTx0dqNmB/9pOYIb5atnVt8E2+tslyfhc+4ieSyiUADze+hoscjQJRzoUxsnf/MLrwXDtotyvDYms6c/IJdw+cHOrr5g0VRZqpbZgYzYpV/sWZZlJZsz57zEVZOHVxqJmR0JfVVnT30/DsT4Ho0er0PLddrP1UwH4CILNAaEod5ZI7tENELuelP6ljRMWFfNGnzldTaCivY1CzYzWHM6p5ktkdbK6brjIqHztMaIPmV2IGWzSCxC0Xzmb7NmzNgDxwOsB1nib2EiJxaXx+I+Ap4+tQIwTos+feZFsKCQJaW/iw/SDj1S+ud8R4WQljY8yWM9Mu2xOFrmz6wNjLQQyuRZ15zyZ+m3Xx4eJbHlIg60WhqMGm69L23Y0VgJV
 MNY1J1vw
 H9x1AOtvU1UQMdJALFcn2FRbTW2wAZCb7cPyn+I1jznbHg5T42enVog4Z53jjomfSJwZnc9L/9Drbrmta+T/zZ4iAI9ORdVl39qUNQXne8Rj/kTFaNBPOQjR6vKaLl+kUr1BtbhLSlayJY86eEmubse4wmL+aEusLGSyMFECe6I7+ABDJn5urm/OMg2bRwxB3vaIl+SgDEIXmXaTNtElBzEFm4IFqlCCQtyYj8RzLxW/PBpy8ytOVdXUuPLRkl9r2saZt8IQ6IvZVtKJDPRDQut5Xg+5cgUacYz4skyScN5xXnRW7LppY/+/ZE6CtztzEBtLaHC9ORoOOtNjeCRHDmDidu4yxUqazhFue4V5a4VbqZ3v/cw8aT8j3CVgB8Xoqj6oP99i1r6Cvuog2Lz7AzSIpB5Fp8q0/UjEeCmh0w0mcPjiklWPRo6VkW9ZGfVlABgJNIOkBAoI7BFHovG0XhzSj4tnyNOP6Lwg3
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
index 00fd89cf6f55..ed7e4dbea653 100644
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


