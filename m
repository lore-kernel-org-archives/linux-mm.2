Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 625E4606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 22:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FM6OzY+4
Received: by kanga.kvack.org (Postfix)
	id 9E6986B05B2; Sat, 24 Oct 2026 18:12:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AD3E6B05B6; Sat, 24 Oct 2026 18:12:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C1636B05B2; Sat, 24 Oct 2026 18:12:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5CD656B05B3
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 18:12:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D7F544049E
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:11:59 +0000 (UTC)
X-FDA: 85358918358.06.A9C7624
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 51392100003
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:11:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FM6OzY+4;
	spf=pass (imf14.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792879918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tg09X6titA7IGP1wR7K2/LkATJk9RajWO5q1G+Mz+ok=;
	b=fHFgfONyujf8199ErfHs5EwDJyHtOqje/dTUTAn4WLSOc9UTJNK6F+AObdF9xscNiWJ1Mi
	GmXWe7KYflMyYdM6r2st2KmYdBRu7UF/mftumlvVwsEWRVHzRr7x/e0e8jv1EIoAKaX3EA
	TG5nhvrGt1wCySb70Easi+EPTsdasiA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792879918;
	b=WmLU96z/F8G+9Cj33slQkuNQ+E1UeXRTm44+YdCNt1OM0NZlKLIJizdwVLxlq5aY5onO3p
	JMFJN3ubDWnsdK90FDGDzAdp4blmrkykslH4bReqW2KUmvRuVgdCJLe6EvpaocNBQAf+MO
	qtLFXtf3Okgpnm8qPUzEnL3FLzSl9sY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FM6OzY+4;
	spf=pass (imf14.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3FDF1600D4;
	Sat, 24 Oct 2026 22:11:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FEF1F01825;
	Sat, 24 Oct 2026 22:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792879917;
	bh=Tg09X6titA7IGP1wR7K2/LkATJk9RajWO5q1G+Mz+ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FM6OzY+4R5MRFe4kccmBrjSptjtO2q6yIh7M18lDvED4ncBUN3HO6pmiT//00Sej1
	 X9hv+Qsi1D2URlzZ5QLGcU5CJPNDwsnBy+Vmge/Ck7+hIGyyf4wlr4Qgaiay1dng5X
	 VxBBUvDJ5Fu9/R1XWoDR9LTv74L1IFMydFREoztbs1z6quf1rH9Tjnncz1z6Angf4l
	 Ng4MzZMZtg1TWjiA4XYVRjy38ySUy/ZNtscey+JUvKZAG9s42ZkJ39q2aQ0PM6ItVi
	 ILoVHvgyY6UyXq2iOk2GzH79g9cid0x+1wUznYGdMO4MHL+UE+d8H5NK2EHOUbPczW
	 tugql5zuCH8Ww==
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
Subject: [PATCH v9 3/6] mm: add folio_mark_dropbehind() to mark a folio dropbehind and account it
Date: Sat, 24 Oct 2026 18:11:49 -0400
Message-ID: <20261024221152.6965-4-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261024221152.6965-1-snitzer@kernel.org>
References: <20261024221152.6965-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 51392100003
X-Stat-Signature: xb1ekkeda9ygsji4g1x761xuxghxtmj7
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792879918-278448
X-HE-Meta: U2FsdGVkX19SqmFarV9RSAfuHh1ooVVJKaDWtv8P2gh4EA8qV8rSKl3adHXKaCWlWc8q2xzn3bvNcbrGI4uCvssk9H0Rd4ZX1CgkzkZ9WcL+lozxZIW4hTzt8s16I6KXMm1zF+byimzGsaT1nAcHMsaXElhxIwihJkCECmGOX2DferUasv1vB/aYGIp1Mr72W0/z9JJZsJ4zHVpmBdQFiHt+GWyhPylRjOK/5nTSsoKo1MffsdzaqAgSi6+LH4HyHtvxjfrw7M0UVh8md5y4XJytZ0JvwOhmOa5UU0MSf/d1ohFpqgFkcg+yeQXS9UnYhraEKnQu18conGhISYac61oH8R9BIBhMEJvy+L4J5YZ1Cg2UnCzT+Nu1/D1JL+0eaEE4jAc6Hojv4DTOIs4UMvgiJm4f0sFjwEn2c6N6WxqiSekttD65p9CA2F0Q9B3YN9Asz6SvPmn7AbaKi/x7LNs3/P/Rb9xyLeGVoXAWKFC7Ljy8C7OFu9pcqAm7lv7e0awDLLDRpVdvgrAKdayeEvbngJ0w/b98xQ6sVRlxUXTFQBBHeT2VESc6noLFMsiSdBoZemwMwFq34hLr/gFT2MZFxckHWI15KB3kF5/VWPBN6ae/G/9LXMD34UWCjnnpElSot+AoWnPIhvX9EGOlYiyFCyT3THKvVtd/T+RgwdtrbwQu8Lp2KUOYnnOgJXWidsdDcgwb283LRBK34LP6F8AKkK3wVEN58jLZlFVyMo0kEvFeeqAesK4QPM+00RZ4Lxfzq1A+QjGvOsP+8HdGk4kOa0w6mhrB+krx1CLTuNvA0JGwTMOLtvFnFl67VTYQ8ONxX1UIXa6UNBwfZAEiMyPHtZCshLlt9E9ZnlkM94ru90jUu0KiP3U9p6Klj1iax15HgCQhVmeRh9UBc860L+WR/LisZHzZkgpz3whaIlk35rPIZXShrmjEm+Nqgx3ZMSxij2D81Nu7EHgRhAk
 Z2eDTMRj
 +pBHpl0GLKQrqFjyjiWfc1RKIxQaAvLHFGTjFeRFlhz9mDcukJ88Y3ENu1IqMhq79q3tCFRjL0LBbdPCdV4c+T+SwOIcU6IIGQ49TomcRzt2J2+hDzxE/dL4oZ1WPu+SIsP5fpUc3UDgptvb8o1jEgMY5Bq5YmdGC715nF2Ab0QeB/e061f1hE6fy2OqdOrYJLmZfjdMNzwHYhDDEL3uQhgkZNbAMvDRxylGihvpgddvbznCucmAxxX0vgiOFwZu6e9pD0nPdh0dLhr5l+srv2YbO2jsAGwylSBOECGfHLLi0QaLqbXOdCkCCK9+6bOUehK35yiMODNNjmFvyc3DYWR6eL23BafkZN7svfeTrQQ7b8KA=
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
has been counted as dirty, add it to WB_DONTCACHE_DIRTY.  Neither
PG_dirty nor the dirty tag alone says that the folio is counted.
filemap_dirty_folio() sets PG_dirty before folio_account_dirtied()
counts the folio, under the i_pages lock and without the folio lock.  A
folio marked between the two would be counted twice.
__folio_cancel_dirty() uncounts a folio and clears PG_dirty, but leaves
the tag until writeback or truncation clears it.  A folio marked with
that stale tag would be counted and never uncounted.
folio_account_dirtied() sets the tag in the same i_pages section that
counts the folio, and every path that uncounts a dirty folio holds the
folio lock.  So set the flag and test both under the i_pages lock, and
count the folio only when both are set.  A dirtier not yet counting the
folio finds the flag set and counts it itself.  Under that lock the wb
is inode_to_wb(),
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

Notes:
    Notes on the v8 review questions, with the code that answers each:
    
    - Counting rule.  The same rule as filemap_clear_dropbehind() in
      1/6:  folio_mark_dropbehind() counts the folio only when
      folio_test_dirty() and PAGECACHE_TAG_DIRTY are both true.  The
      test is under the folio lock (VM_WARN_ON_ONCE_FOLIO checks it) and
      the i_pages lock.  A stale tag on a clean folio does not add a
      count.
    - Double count.  A folio that has PG_dropbehind returns at the first
      test, before it changes the count.
    - No writeback.  A mapping without writeback gets only the flag.
      folio_account_dirtied() does not count such a folio either
      (mapping_can_writeback()).

 include/linux/pagemap.h |  1 +
 mm/filemap.c            | 42 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

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
index 5176c4125a4db..d0e4d1788fd40 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1644,6 +1644,48 @@ void folio_end_dropbehind(struct folio *folio)
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
+ * folio lock.  Every path that uncounts a dirty folio holds the folio lock.
+ * So with the folio locked and the i_pages lock held, the folio is counted
+ * when both PG_dirty and the dirty tag are set.  PG_dirty alone is not
+ * enough: a dirtier past folio_test_set_dirty() but not yet counting finds
+ * the flag set and adds the folio itself.  The tag alone is not enough
+ * either: __folio_cancel_dirty() uncounts a folio and clears PG_dirty, but
+ * leaves the tag until writeback or truncation clears it.
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
+	if (folio_test_dirty(folio) &&
+	    xa_get_mark(&mapping->i_pages, folio->index, PAGECACHE_TAG_DIRTY))
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


