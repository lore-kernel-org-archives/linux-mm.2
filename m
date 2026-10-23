Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0A1B606A322
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 02:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dOpjgkUW
Received: by kanga.kvack.org (Postfix)
	id E04176B0321; Thu, 22 Oct 2026 22:45:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D94356B0323; Thu, 22 Oct 2026 22:45:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE0FF6B0325; Thu, 22 Oct 2026 22:45:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 845426B0321
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:45:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 091F6160179
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:45:55 +0000 (UTC)
X-FDA: 85352351070.08.183688B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6EB4180005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:45:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dOpjgkUW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792723553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ab6Sr4GaaDc43At8JZYtLZu8p9QZmk29CqcWKokueoc=;
	b=P6OSZn5+z2mLla9U2u4s7Lb0ocNDnx29xK2kcWwj4/TL2aY6+bIyjdjHmtaX0JPyizWz0w
	wCd94EQv5j3/IODoYKdCkN8APmzYSSTAvO+ciTvFplt0wszFFlsFVzGphU/M+JoilF4tQR
	syqnhG1CoDhVNEhp/aB/IJl6g+8M2r8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dOpjgkUW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792723553;
	b=lsMY4dnFVkjY9FjAWGal5ZRx396xaXbSzjGSB7QRhHY2PAy//oWzJkkqYXIvYMdz/A6guz
	SyrYj9ngdXc3uOUkePkAJgIpzoWIE7ghuK8awoAEhlg8pDz1ZuUiXc8aWB+EK0BRr2Dho+
	quuwoSptmTLxA7rNueVFI6GDhsRRsM4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 096C563E72;
	Fri, 23 Oct 2026 02:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5EB1F01825;
	Fri, 23 Oct 2026 02:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792723552;
	bh=ab6Sr4GaaDc43At8JZYtLZu8p9QZmk29CqcWKokueoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dOpjgkUWNv20BI+9ztAAZyN/3F0qcT/fj1FYbSwljuQfllhjwb7cy+ADNwZQsmhAF
	 4BqdGvJ39s+oqiITxKh7kYGLqz97oaLBy5Efn9CWDPXpuVPI3rNwG5nZLmTBP22wNv
	 6R9BLFB5kSoZpQ9CS+XcSJ9Q0bTeyw+l1HFiD4dgF+JCzc1ThhDHCn3oxYg1zHmfop
	 olh4Lp43lWPRbyRmCPbpV9JfCi0/ESNhA11Sn9iIl+MpSKv42px00dLB4iT8tqCkR6
	 EMsBxnid6MLwquOyKxHnxaUKXwzJEhzdioiWeHb1nuxFpdhovjaUCEnBWWtixU7NbQ
	 7erpFEFNNTbLQ==
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
Subject: [PATCH v8 2/7] mm: take a folio off WB_DONTCACHE_DIRTY only if it was counted there
Date: Thu, 22 Oct 2026 22:45:43 -0400
Message-ID: <20261023024548.71123-3-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261023024548.71123-1-snitzer@kernel.org>
References: <20261023024548.71123-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6EB4180005
X-Stat-Signature: 88u85ztfpuqebb1ofreo7hko9ef6d71a
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792723553-805716
X-HE-Meta: U2FsdGVkX18AbSFvBWWVNd4a3Ki4+QP4zKRb48MUiKlRQKtDlMRpt3EWekL20Dq+92CGrLZB8HiHZ0BnJeeD79jiPKNPHpN+3qwOaFb8JH3kK/UVT9fp0IZ6NDBvGoHh+iZr0hNtuniZ8RO1VFPjiJ+WIZAvipZonveV8fdXWURj/dUE4V5iCYu9n/2PL2iTo9TXl043jd3dz9IUGxAEkMW+miRZR+hJXu4fHNqf3MrIRoZ/83bIu246cF14YOLDM/+0p5kROlv1Af6zBXN6SlKhyZdKfz04ITPR/3W5GcZaxzd3+TN/DB802CYN7Ik96IQjLk/BYT0FZFz8XPSNZvEY3Tl964NYANTcPm+2BQemq3q77xdamu3YKcfaqefwnhRzF2cVIUY1EHKOW1/f4eM/UWnFdH4PTgW3UCdlioq+M5RKymo9zZQt/wWcHCWUk4se0ck/PFNvTWqrZ7dATjD9I1cog/74rIH+pzENwo4sY2Qrh2hqMdOvk31uLuAzY3WFAHriWqGWz7QnlkNdNJZ6aLsZqLVjHFasGw9r31K3S3vDvcZn1KpULLzIARGLxiKy3uJrxC3kBGxEqkRLtMnBCf2ZqvTpXuCnySqlVruIx56KGIya3n4rAGk/1tTJ1Rz+o48JhvnlAqgHWGZWgdgU4oqrlJDxNgqMBFr/83lex6BNikplBkBk1LSQt7l9uw0sG9vX0gWAymPQI4ObADL9QVioYZr+0MMV4/BHAW8sboHZTd7g5vTBebF18KxLxp4brYKPNMUZYnktLynsGc9PyHAi8tbt0KOccyFZW4lobY0DzBgnWfqB1rb93xgrbxV+bapyOzC22+d/Y3FG1yMfR6TV7hR/STTF+m6ZY3ikzJvWtMMBoESMFpOY3spi5FFWXvkQvV9RSlVF6wPyAShwVkJDvsbL5YRd0woYBlrvliUaCPB4aypewQu0OLD/arwPj7IByyCaiA4yZib
 +sc3TScE
 MlutlOVsR3lNFcWdNpgbw2Q9SHDztmhhz1qPXkb45OpNoynDZNOtj75a/yZe8UNJgQ6JAMNFJl2Up3xGtUgT8pmLHMLQntdZzJdZDwuv3ho794+QpeNv4U7XtvokWzhNJJO7KLCdIrmUCnk8KLCsJZXbhmNn5rcuT/WVKyt8tH2W4JMowHoBRKckp2gC8/ly3XIzYTa6riyf2ZL7CHPtakpWS98jMWuiyQwiLrKNlhP3QTWUyhdWFQiIbESP3PvclOE9enp0V2vRcpk07qH7/n/NBC3CnKkExs9Qf7aIeFkrLwHYdv+4xnJKcEY7KyxCMSegw2gYS56WEbE3iO4OrzHAZ+F5gNvv7GmgUxPPA+H4eRdJggbgUgANi+YXkeb0pHnde
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A cached lookup in __filemap_get_folio_mpol() that finds a folio marked
dropbehind clears the flag, and subtracts the folio from
WB_DONTCACHE_DIRTY if PG_dirty is set.  But filemap_dirty_folio() sets
PG_dirty before folio_account_dirtied() counts the folio, under the
i_pages lock and without the folio lock.  A lookup between the two
subtracts a folio that was never added, and folio_account_dirtied(),
finding the flag clear, does not add it either, so the counter the
DONTCACHE writeback kick reads falls short and can go negative.  A
lookup without FGP_LOCK also races with the paths that uncount a dirty
folio, which hold the folio lock: folio_clear_dirty_for_io() clears
PG_dirty and then tests the flag, so a lookup between the two leaves
the folio counted with no one to uncount it.

Every path that uncounts a dirty folio holds the folio lock, and
folio_account_dirtied() sets the folio's dirty tag in the same i_pages
section that counts it.  So clear the flag with the folio locked,
taking the lock with a trylock for a lookup without FGP_LOCK, and test
the dirty tag rather than PG_dirty under the i_pages lock: the folio
is uncounted only if it was counted.  Under that lock the wb is
inode_to_wb(), as in folio_account_dirtied() and inode_do_switch_wbs(),
which moves the counter by the same tag.  A lookup that finds the
folio locked by another task leaves the flag set, as it would have
been without the lookup.

Fixes: 88d6f128d06d ("mm: track DONTCACHE dirty pages per bdi_writeback")
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 mm/filemap.c | 54 +++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 41 insertions(+), 13 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 00fd89cf6f55..1cc28224d547 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1927,6 +1927,45 @@ void *filemap_get_entry(struct address_space *mapping, pgoff_t index)
 	return folio;
 }
 
+/*
+ * Clear the uncached flag of a folio a cached lookup found, and take the
+ * folio off WB_DONTCACHE_DIRTY if it is counted there.
+ *
+ * folio_account_dirtied() counts a dropbehind folio under the i_pages lock,
+ * in the section that sets its dirty tag, after PG_dirty has been set
+ * without the folio lock, and every path that uncounts a dirty folio holds
+ * the folio lock.  So with the folio locked and the i_pages lock held, the
+ * dirty tag, not PG_dirty, says whether the folio is counted: a dirtier past
+ * folio_test_set_dirty() but not yet counting finds the flag clear and does
+ * not count it.  A folio another task has locked keeps the flag, as it
+ * would have had this lookup not run.
+ */
+static void filemap_clear_dropbehind(struct address_space *mapping,
+				     struct folio *folio, bool locked)
+{
+	unsigned long flags;
+
+	if (!locked) {
+		if (!folio_trylock(folio))
+			return;
+		if (unlikely(folio->mapping != mapping))
+			goto out;
+	}
+	if (!mapping_can_writeback(mapping)) {
+		folio_clear_dropbehind(folio);
+		goto out;
+	}
+	xa_lock_irqsave(&mapping->i_pages, flags);
+	if (folio_test_clear_dropbehind(folio) &&
+	    xa_get_mark(&mapping->i_pages, folio->index, PAGECACHE_TAG_DIRTY))
+		wb_stat_mod(inode_to_wb(mapping->host), WB_DONTCACHE_DIRTY,
+			    -folio_nr_pages(folio));
+	xa_unlock_irqrestore(&mapping->i_pages, flags);
+out:
+	if (!locked)
+		folio_unlock(folio);
+}
+
 /**
  * __filemap_get_folio_mpol - Find and get a reference to a folio.
  * @mapping: The address_space to search.
@@ -2058,19 +2097,8 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 	if (!folio)
 		return ERR_PTR(-ENOENT);
 	/* not an uncached lookup, clear uncached if set */
-	if (!(fgp_flags & FGP_DONTCACHE) && folio_test_clear_dropbehind(folio)) {
-		if (folio_test_dirty(folio) &&
-		    mapping_can_writeback(mapping)) {
-			struct inode *inode = mapping->host;
-			struct bdi_writeback *wb;
-			struct wb_lock_cookie cookie = {};
-			long nr = folio_nr_pages(folio);
-
-			wb = unlocked_inode_to_wb_begin(inode, &cookie);
-			wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
-			unlocked_inode_to_wb_end(inode, &cookie);
-		}
-	}
+	if (!(fgp_flags & FGP_DONTCACHE) && folio_test_dropbehind(folio))
+		filemap_clear_dropbehind(mapping, folio, fgp_flags & FGP_LOCK);
 	return folio;
 }
 EXPORT_SYMBOL(__filemap_get_folio_mpol);
-- 
2.52.0


