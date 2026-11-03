Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B4C4606A31B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 21:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T0o7vKa+
Received: by kanga.kvack.org (Postfix)
	id 44F2C6B05BE; Tue,  3 Nov 2026 16:18:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427CE6B05BF; Tue,  3 Nov 2026 16:18:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 364D76B05C0; Tue,  3 Nov 2026 16:18:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EB9926B05BE
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:18:00 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6B509C0584
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:18:00 +0000 (UTC)
X-FDA: 85395070320.03.7067ECA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id D07F840005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:17:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T0o7vKa+;
	spf=pass (imf01.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793740678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gVJkWNRH/ZOu7EDyRusj1WUhQq2Egy1weSR/EP5J5Ds=;
	b=QRHc2KUMfrbiGbLQFm2GVCWhHDR3IJZ5hXNkUeXqalMwVLildtT+Zee3ae+Dvn9Sh0Vtdm
	7u20Lx1Qf74PUJdvume5UDsFM2ML6yWTgF+TgTjZR27EVNNWFs1Iyy0LLyPx269xLoemQd
	kezJ2MIfZmjYPNZDOZAR16ljQbDBeYQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793740678;
	b=z4lTppTGaoK/ZPGs7OUpPazv3aEgEIqcXfym5ZX6wQ38VUwz4ElQaRTY2pnl1er47px92p
	/tv49gSY9ZC8KZKFh8ALnJvhAPFp7V0LynC9f9xNNtpQXdZzLAhIw3Uc+g6cPcoDbNAimi
	KjHCL9KW+Nry17MLESoODTz39Mwa0/c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T0o7vKa+;
	spf=pass (imf01.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E62460136;
	Tue,  3 Nov 2026 21:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA2E1F000C1;
	Tue,  3 Nov 2026 21:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793740678;
	bh=gVJkWNRH/ZOu7EDyRusj1WUhQq2Egy1weSR/EP5J5Ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T0o7vKa+UViT2kW4nUff14L2tAlAy17Fk4EuqAbYYcAsmVvxZLyN+Tkx2kcVu6m5G
	 7VCiLUxxVY46mpw99qJct2peaQJ3tRJNVG/bmhc3/7y2d7/3dMxh+wR9iTyDBRe2k6
	 /koNMdftwLAgxjQVmjsnBR/velQhVyfN94fsYFwJsq07a4zY0cYyeyhcrgB+VZcnwn
	 AmEhTDdoajDx9TMTa1ssvcBgFCdCHSbQP4KxrrwxCTMxN11VZRH05KU58aibY4pwd/
	 zxxfslS6AQ0mlkro4y8K5T+lUztrdHX3R9an1nLwvt0i7YnWwa1tWvV6G5HjuKkR/H
	 5xDQEcyHtw7Uw==
From: Mike Snitzer <snitzer@kernel.org>
To: Matthew Wilcox <willy@infradead.org>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Cc: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v10 2/7] mm: take a folio off WB_DONTCACHE_DIRTY only if it was counted there
Date: Tue,  3 Nov 2026 16:17:49 -0500
Message-ID: <20261103211754.35352-3-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261103211754.35352-1-snitzer@kernel.org>
References: <20261103211754.35352-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ajtwq3fo7tdfmh791cz9755yykwhbh55
X-Rspamd-Queue-Id: D07F840005
X-Rspam-User: 
X-HE-Tag: 1793740678-972002
X-HE-Meta: U2FsdGVkX185/1JFGOiOQy7KBZYOtPeCy83B7yqYcPAlMec5WmmKi+2GddYnKrm+IfZlaOgSq4RVgdRFtReGQUXAzvteUODPaUx9wpp+Cii7sZWyDyd415xj/xPKxeJYIk91wjKFNdOjmtIyd5rqOWEXo4ySgFOfW2swpG5G7Yt50SKljE8KByRr0U6t6BuLjVJqwJd5h40zZ8G+nzx27z28lYE+dS4p++peYfELmOz0iHxMGAi9lG/kXhbEVLSJrFVqr/HVz76efR/yM5GHO92EbHdJ92yVf9TIVK8e9OVvLNsf+y3KfHeWaNbvb7TSQxJDSOQcKpK/e/IhQUWlrRQwdz2lkvmDV0Mk6Gwu6Q5Sp7RUs2bqGWNOfySevMJRN8YFsjyzaEzbK7adV+Hw5Kt9R2DgoP/uwdVjhFJtrrnMpYgcsIa1g/MB2fDJ4dbybUAE/BfMGOLKEOiWSVR10GSHZeIWoOeHGUyxRAxg9f5mroC3BU4+FTIDMtuBns6m4wCdAPhB8mM0ibXN+H2HULaiDThjGQcyggDamZrFUOtoAB71T/mrT41oFXJ8FxWNC3ykoYEz0WiTFqGS8NfpXrNS2/y4kU+mUzX23HjjyAoSz7oJuKm/n4wiuYEF24CKlevj8Aa/fFoJFDfHJGlbjdDOPviFm/P4BgaTg80BJ11B7rYrGCcRbEMuaAvQKUOs682qbqkSXYokv5E6pZmTaIUZJOBJFmuzi/11fo43pJTavdn9lqljc4piW6QWt5VryFMzbbOtKPJp8o7os4Lah7zSUrAONfGwLhLj80OOd3STtPJXrs5mRpf8YNVzsEUELo6g7OnjodF3Hys1s6peB7zoneCWBxlVLRy0WEZ/gXyNpYdJuNyBBF2IVTTBiZKti+hy2ezX3jUOBzPXZ2a8WNnHiDGKj7EEwLSHBZXoEC1PY4LowbXRk/hTOiQBINEeaIHpLP9H4BRKUEHPa+P
 9hoerFY3
 AbzfuULFjvaF9WDL82CbOuHnkt2xVTCUlbOGBTUnoHoQkqb44qLL95iMu8n4RFbwYEXtQVq/r6Kssd8brlKNuCJY2WrQOGARC3OCwLUNTTexTI2ddWPJHFfVmTbsDTIdWAqbVq3nDIEWfDxwSYEAxJKH3kUAqjMQlWMOqqW02EJTdkBEFerzyidB5SeJEp9pgRGx9Comq9io+gRxHOqU0VuP8h07w5aleJown3t4nmx9idg2CQxw7pHU+FLQL3YmHedzR+CTZ6MG9of8hKuSKeYYQ/HI4HREaGx4KcXIny0bCfJElR25VkQSzw9tVkNCHfqIHwscLWXPofuvRLnd97Hkbd9x/uKEanWGJuTnCznCBsWzDgPfE8Sj0SMllhnz7zOhr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A cached lookup that finds a dropbehind folio clears the flag and
subtracts the folio from WB_DONTCACHE_DIRTY if PG_dirty is set.  That
test races with the dirtying of the folio.  filemap_dirty_folio() sets
PG_dirty before folio_account_dirtied() counts the folio, so a lookup in
between subtracts a folio that was never added.  The lookup also does
not hold the folio lock.  Every other path that subtracts a dirty folio
from the counter holds it, so the lookup can subtract the folio a second
time.  Either way the counter drifts, and once it is negative the
DONTCACHE writeback kick writes nothing.

Fix this by having filemap_clear_dropbehind() clear the uncached flag of
a folio that a cached lookup found, and take the folio off
WB_DONTCACHE_DIRTY if it is counted there.  With the folio locked and
the i_pages lock held, the folio is counted if both PG_dirty and the
dirty tag are set.  A folio that another task has locked keeps the
flag.

Fixes: 88d6f128d06d ("mm: track DONTCACHE dirty pages per bdi_writeback")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---

Notes:
    Notes on questions from earlier reviews, with the code that answers each:
    
    - Stale dirty tag.  __folio_cancel_dirty() clears PG_dirty and takes
      the folio off the counter in folio_account_cleaned(), but leaves
      PAGECACHE_TAG_DIRTY set.  filemap_clear_dropbehind() subtracts the
      folio only when folio_test_dirty() and the tag are both true, so a
      stale tag does not subtract it a second time.
    - Locks.  filemap_clear_dropbehind() holds the folio lock (FGP_LOCK,
      or folio_trylock() and a check of folio->mapping) and the i_pages
      lock.  __folio_mark_dirty() counts the folio in
      folio_account_dirtied() and sets the tag under the i_pages lock.
      The paths that subtract a dirty folio (__folio_cancel_dirty(),
      folio_clear_dirty_for_io(), filemap_unaccount_folio(), the folio
      split) hold the folio lock.  inode_do_switch_wbs() moves the count
      under the i_pages lock.  inode_to_wb() accepts the i_pages lock in
      its lockdep check.
    - Trylock failure.  The folio keeps PG_dropbehind, as if the lookup
      did not occur.  The count does not change.
    - Known window.  A folio can be clean with a stale tag (for example
      after iomap_writeback_handle_eof() skips a folio beyond EOF), and
      an unlocked dirtier can set PG_dirty before it takes the i_pages
      lock.  A lookup between the two sees both bits and subtracts a
      folio that is not counted yet.  The two states look the same in
      these bits.  Only the counter, and so the size of a DONTCACHE
      writeback kick, is affected; data and page state are not.

 mm/filemap.c | 42 ++++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index c75f49563b74b..3a13289c07dc4 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1945,22 +1945,36 @@ void *filemap_get_entry(struct address_space *mapping, pgoff_t index)
 	return folio;
 }
 
-/* Clear the uncached flag of a folio that a cached lookup found. */
+/*
+ * Clear the uncached flag of a folio that a cached lookup found, and take the
+ * folio off WB_DONTCACHE_DIRTY if it is counted there.  With the folio locked
+ * and the i_pages lock held, the folio is counted if both PG_dirty and the
+ * dirty tag are set.  A folio that another task has locked keeps the flag.
+ */
 static void filemap_clear_dropbehind(struct address_space *mapping,
-				     struct folio *folio)
+				     struct folio *folio, bool locked)
 {
-	if (!folio_test_clear_dropbehind(folio))
-		return;
-	if (folio_test_dirty(folio) && mapping_can_writeback(mapping)) {
-		struct inode *inode = mapping->host;
-		struct bdi_writeback *wb;
-		struct wb_lock_cookie cookie = {};
-		long nr = folio_nr_pages(folio);
+	unsigned long flags;
 
-		wb = unlocked_inode_to_wb_begin(inode, &cookie);
-		wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
-		unlocked_inode_to_wb_end(inode, &cookie);
+	if (!locked) {
+		if (!folio_trylock(folio))
+			return;
+		if (unlikely(folio->mapping != mapping))
+			goto out;
 	}
+	if (!mapping_can_writeback(mapping)) {
+		folio_clear_dropbehind(folio);
+		goto out;
+	}
+	xa_lock_irqsave(&mapping->i_pages, flags);
+	if (folio_test_clear_dropbehind(folio) && folio_test_dirty(folio) &&
+	    xa_get_mark(&mapping->i_pages, folio->index, PAGECACHE_TAG_DIRTY))
+		wb_stat_mod(inode_to_wb(mapping->host), WB_DONTCACHE_DIRTY,
+			    -folio_nr_pages(folio));
+	xa_unlock_irqrestore(&mapping->i_pages, flags);
+out:
+	if (!locked)
+		folio_unlock(folio);
 }
 
 /**
@@ -2094,8 +2108,8 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 	if (!folio)
 		return ERR_PTR(-ENOENT);
 	/* not an uncached lookup, clear uncached if set */
-	if (!(fgp_flags & FGP_DONTCACHE))
-		filemap_clear_dropbehind(mapping, folio);
+	if (!(fgp_flags & FGP_DONTCACHE) && folio_test_dropbehind(folio))
+		filemap_clear_dropbehind(mapping, folio, fgp_flags & FGP_LOCK);
 	return folio;
 }
 EXPORT_SYMBOL(__filemap_get_folio_mpol);
-- 
2.52.0


