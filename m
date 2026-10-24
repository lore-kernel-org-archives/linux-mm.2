Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87FC4606A334
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 22:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CuREB7IO
Received: by kanga.kvack.org (Postfix)
	id CB9276B05B1; Sat, 24 Oct 2026 18:11:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C90246B05B2; Sat, 24 Oct 2026 18:11:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCCEB6B05B3; Sat, 24 Oct 2026 18:11:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 905786B05B1
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 18:11:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0FA061C37EE
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:11:57 +0000 (UTC)
X-FDA: 85358918274.25.A847F6C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6AB24140002
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:11:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CuREB7IO;
	spf=pass (imf23.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792879915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tUgGIcvDGljs6JV92kTmhIbZKtK+itmmn1A1LPaiDgk=;
	b=qcATjghTboJxV3zdQ+vnDaFtKYxfYre6WOAksKERHWLT5BWOl+XRs4E41nExL8FJL7o99f
	dj+YW/KKA50njubgy33310tzXg3/ZYBxvqsnzfaYe3085oKLDrIVJaGf+E79pqvcY5SAh2
	M6a8fp0Z/atG206vLZf4bqO3R/YJ44M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792879915;
	b=YNUJS1PpaLhuZOGeAfwETij5n9eKyP6vzQpvhlBnAB47ZzAxBuNC/TkNRBfQbwbIfsoeBp
	5nOKs/6BirqdwoVcHyqPnUNIc1aPoePRacJ+uLv5KJGbAWX/WwB/HbDJXIRA3/nqoHUanU
	HAhchAD4LHhwRBk8EjSO8aQ7iswMd8g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CuREB7IO;
	spf=pass (imf23.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AB12942DD3;
	Sat, 24 Oct 2026 22:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58AB91F01825;
	Sat, 24 Oct 2026 22:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792879914;
	bh=tUgGIcvDGljs6JV92kTmhIbZKtK+itmmn1A1LPaiDgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CuREB7IOMN2NKpDY3nvb9Hvprvj3hmwqsWwP16ef3jlFr3t7Ur0mgRRzuskFM/06C
	 lXufNJ+/AxmsuNX9pO6POW7tgjYBTtwvuuz8GZcfhUjT3D9uIDjMXIvLv+ep+H4043
	 jH0e469PlREwwW3jh+khoWs3UwUZI/ozw2yLkjssEeNNMSb7eNIvWjtuLMDsmc8FY+
	 mFoqZRv1lSTZIEeSK0lV7n9yWlZhDch4yn20LHDBJdP4nPJOMtS5uD0jUCjTkJhQWc
	 hVG7SK9N/emvItxZBOEn7afRFx2qtePEP6IRa0Xe3cKvhRRz0+YIGxB2hS3Rdgbbfy
	 kkm7MGxyCcnng==
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
Subject: [PATCH v9 1/6] mm: take a folio off WB_DONTCACHE_DIRTY only if it was counted there
Date: Sat, 24 Oct 2026 18:11:47 -0400
Message-ID: <20261024221152.6965-2-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261024221152.6965-1-snitzer@kernel.org>
References: <20261024221152.6965-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6AB24140002
X-Stat-Signature: y3gdoouftusff4tww9tu79ahzs3yeebe
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792879915-343830
X-HE-Meta: U2FsdGVkX1+iBCBy0f44HhFVI8dz+/SgMEp5AY4HEIod08tecFMfcaCa0+hS0XUqyxCTsv95TvRgiIgfu/3OZrVMNvXz95aVqoY4+E7n+2Dnp9lqCBFu5ewcxy7Jylk2a5bnCZFpsjxvNpAjZ32nXRHbMUjp4rTuyzVH3FNNR3IqQo3BIyBqsh4rdem82P0jfHdHKzjaT5J0N2tl57oOyyBA2Mue3dOMgpCfHwgQreR00dc34BZCaCRXOXIBmqIx6iFrCn8d6NYyrtDtbLg1ILmIkkKiypH3h2MK7nk0Z5wM8hQFpNRkeklovEmt6DfeDpIHySwhYiLwQAbWklZ9fZqwY19StQng/PpUIDjnvY32BHERBT4Y8hYG98MeWN2qSVaNCGM8EjPa7zjf61eYiEnTttjRdwagyCF5BM8h8QaNm5X6et5SX0G7/tokrvgX2ixVttZfUz7E1IRbcpF6PgzSc4GXtWOIHaRRSfS/PXrrZhIlE9JczZjuabFvo75g+9xEYsgkOh9S9rlnijDyioLeGJ3bYYUNwBc6dgKypX+y9aNc4GV/Ids7zQ55OwuBDNHgE7sqc6mwxVgiZk1rvgI6FC5eUbjaIfP2As/z+7P2QBFWGnhi7RbaJA3myriuf/rWVTtOgra/Yin6DRLZniypVrhY5tXJRe2ZdLdGkqjsp98o0F2D2/FV7XzbD+zPEFazKHpMv5cY7hkuKentPtjKunAZoXHEN0gnAydpMukkgaP5Q3WHiDTAVEq7qr9qDECrYAnTp/3pkA3KedqDix3bce7m8uJYrrbVBo3+qEk894hVTbukOHOFbEQ7chT6WiW2c3ltEUU9TusNVMeJSN61/SlHcexKFRhrAt2f8mO/f1XBPhkEKbYftgfcZtB8I5cf5sLXp+TrjT8KUkhX6d951fyQ0cGTzHXVCMkUOhd8Zrc4H2+WsApUST8E83apWyaUEDY6owKI0/y0ssR
 CXAc1/ai
 wf/LKAMnTplKNmx8gP2+nkvqY+azKpelRnscySKzM7ZNfCndWq7YYR0PhdRfMjeTBgy6IB4FeGnH8mPvUujbrHUMFLzX51+yVirRNjrXYq2U5SchmvnuzriVBKivyoiUL5arTihyHGCHQV1vpKF/ilW7q+oXFMJ8OG6zdFJwNRi/WgTY5DL/T6aZr/1pSm7UbdMTlBBIOURoMpG5H9Ly1VonUfTDnQ4L17aWiXTI5cPgp4AWAcR7XXC2wT6jkqOmJp/dqeo92NqpA2Z1Sm5/MJ+0NLM/VDidEa+GGUbarNAsEs9DeGjUBN2gp1AGerA6ifUFtsSYzyHiP2WjgYmrHhfB/WXEzbxo61mRiVBeSzV6aDWJaoL9p2ybkfEROactLGgBw
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
section that counts it.  So clear the flag with the folio locked.  A
lookup without FGP_LOCK takes the lock with a trylock.  Under the
i_pages lock, test both PG_dirty and the dirty tag: the folio is
uncounted only when both are set.  Neither alone says that the folio
is counted.  A dirtier past folio_test_set_dirty() but not yet counting
has set PG_dirty, not the tag.  __folio_cancel_dirty() uncounts a folio
and clears PG_dirty, but leaves the tag until writeback or truncation
clears it.  Under that lock the wb is
inode_to_wb(), as in folio_account_dirtied() and inode_do_switch_wbs(),
which moves the counter by the same tag.  A lookup that finds the
folio locked by another task leaves the flag set, as it would have
been without the lookup.

Fixes: 88d6f128d06d ("mm: track DONTCACHE dirty pages per bdi_writeback")
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---

Notes:
    Notes on the v8 review questions, with the code that answers each:
    
    - Stale dirty tag.  __folio_cancel_dirty() clears PG_dirty and
      uncounts the folio in folio_account_cleaned(), but leaves
      PAGECACHE_TAG_DIRTY set.  filemap_clear_dropbehind() uncounts only
      when folio_test_dirty() and the tag are both true, so a stale tag
      does not uncount twice.
    - Locks.  filemap_clear_dropbehind() holds the folio lock (FGP_LOCK,
      or folio_trylock() and a check of folio->mapping) and the i_pages
      lock.  __folio_mark_dirty() counts in folio_account_dirtied() and
      sets the tag under the i_pages lock.  The uncount paths
      (__folio_cancel_dirty(), folio_clear_dirty_for_io(),
      filemap_unaccount_folio(), the folio split) hold the folio lock.
      inode_do_switch_wbs() moves the count under the i_pages lock.
      inode_to_wb() accepts the i_pages lock in its lockdep check.
    - Trylock failure.  The folio keeps PG_dropbehind, as if the lookup
      did not occur.  The count does not change.

 mm/filemap.c | 57 ++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 44 insertions(+), 13 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 00fd89cf6f550..5176c4125a4db 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1927,6 +1927,48 @@ void *filemap_get_entry(struct address_space *mapping, pgoff_t index)
 	return folio;
 }
 
+/*
+ * Clear the uncached flag of a folio a cached lookup found, and take the
+ * folio off WB_DONTCACHE_DIRTY if it is counted there.
+ *
+ * folio_account_dirtied() counts a dropbehind folio under the i_pages lock,
+ * in the section that sets its dirty tag, after PG_dirty has been set
+ * without the folio lock.  Every path that uncounts a dirty folio holds the
+ * folio lock.  So with the folio locked and the i_pages lock held, the folio
+ * is counted when both PG_dirty and the dirty tag are set.  PG_dirty alone
+ * is not enough: a dirtier past folio_test_set_dirty() but not yet counting
+ * finds the flag clear and does not count the folio.  The tag alone is not
+ * enough either: __folio_cancel_dirty() uncounts a folio and clears
+ * PG_dirty, but leaves the tag until writeback or truncation clears it.  A
+ * folio another task has locked keeps the flag, as it would have had this
+ * lookup not run.
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
+	if (folio_test_clear_dropbehind(folio) && folio_test_dirty(folio) &&
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
@@ -2058,19 +2100,8 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
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


