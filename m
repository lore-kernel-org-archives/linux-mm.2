Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEC90606A89B
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 19:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VF+IHUbS
Received: by kanga.kvack.org (Postfix)
	id 58BA86B05C5; Thu, 12 Nov 2026 14:09:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 562A06B05C7; Thu, 12 Nov 2026 14:09:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 451A16B05C8; Thu, 12 Nov 2026 14:09:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C4EE6B05C5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:09:24 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 96D27808AA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:09:23 +0000 (UTC)
X-FDA: 85427405406.01.84B395C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 01E70180009
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:09:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VF+IHUbS;
	spf=pass (imf16.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794510562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wPQ8Y1tJWbMJwqCQRFYzmTJx7xn37wY+MUSLgJe0EEA=;
	b=EGpAW/SMn7dcd4td7VTfVT+zHI95RmlJrYZlDbKIpGaiWGDRDLBdq1rDJ4OBf30fRerJ2e
	0JjiL+elpvl29QDgUh8/RD52ZMxhfhtb2pjoWqMeGZnKESICY40SFumZ7ElD6n3ILNusCN
	i/lgzOs08JBtxcMxYuvLAt08WaHA9yo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794510562;
	b=KZiS5NQZzKw6SUGH7RWVInMYgRS0HJIRyXZb/QGrH/oRbjnq23oCyW9WXFSSLEoldG5axt
	Sfi7c+YODLyswLNAtaCj4PYcPK8AODKvKfcbGn9tHUN/uYzOE738KYaXf5wyL4RGFNVdos
	h2ecprxMTYkpVC7q5/HrvHxrj4CYDVA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VF+IHUbS;
	spf=pass (imf16.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D719459E7;
	Thu, 12 Nov 2026 19:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9721F000D4;
	Thu, 12 Nov 2026 19:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794510561;
	bh=wPQ8Y1tJWbMJwqCQRFYzmTJx7xn37wY+MUSLgJe0EEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VF+IHUbScSaLRVacGJckMquVnUyYPaCb/piZVssWyyDGWspFF6vPzpYTnxW8MVLea
	 Qc2eSaEmNkF4oO/zzuVs0PMaP5ZLFLDq9WOO+tsOgVrjtGE3Bue7U+wmnzhixVarZJ
	 kGabJeo5njfhO1zwzt97lpVXtMS0H5SEgmH/3LzguT/oaI53FY4/SHoGaUTSmNhIVH
	 rYayNhFbjql5VaCq0nZ+0In1jfVwONKG5v/Q5Nnf7VvqSyCTNbuTuUc2SBllP+AqWG
	 bWqwTApZ6E6vpU7+iy56QRNFpFRHRLOy50lBkzXpJ+9rmIR1VvbSGZsf0hzDqk4N+L
	 6KFAK7AV5cKfA==
From: Mike Snitzer <snitzer@kernel.org>
To: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: Mike Snitzer <snitzer@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	linux-nfs@vger.kernel.org
Subject: [PATCH v12 4/7] mm: add folio_mark_dropbehind() to mark a folio dropbehind and account it
Date: Thu, 12 Nov 2026 14:09:07 -0500
Message-ID: <20261112190911.84702-5-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261112190911.84702-1-snitzer@kernel.org>
References: <20261112190911.84702-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 88jo8qqjy5w3j3xzrusatz66kj493mab
X-Rspamd-Queue-Id: 01E70180009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794510561-118127
X-HE-Meta: U2FsdGVkX18gtu+M8sJDntdCwma/WRXWZEeVIhzrTgoDMhtIP9uUMgBp/2s7xgnKHGx9vJxaAHcjPoWbKZaKEa7Fw7wud/DOzU1nXiTxKBSPD/4OYLCRD63Xs1c5IPbZR8qrOHmS/YXT22g5m2ohEgRvPPRwXgVgH4WUkpKxETC+8eE45kCWClb3pHanQ1G8Hx+L2OW6rjSKGNZBzBlpZpxY1xK5zRoUAE/uQt8+xHoMEOCX3b3ZW1CTrFOjvh7KNspvSpRLA8sXtWmel6jM9JaqlmDm2PS0vb30jj+Y7MsZAE1Gv+xna1SsHtpiV29cJsN9R6socIUwyX0al3xZjP/6XQTsAnHoypVnvi8Okj3c6kPLve3Ry0D4AVQn5t+P/lIewQmUbRidO2M/X3g/d3TF8Rh1Qw/bATCrtmHlYv/TDQeCzT/S1s5BAKtq1zf48ixxFzfNcXXQ48lkJl4F1gPgzZ0vFI8CLnEgGy10b23Vtbv4YhnBtYSbOYQIZjF02pi/O/RX0/5guAuj2aj8X8n0cb8q/7/Kf9K7O0i1saavOzKrhG1L2fU22Tozl5hReEyZkDCusN5fG9n7GzfSCJXk65llTh3Y+ImynWLnvzNJJRaA6qVJ7DZU9bVyLDoZUIBoaAmRAyBf88Boram3On+O8+S/4eUcXJC7fz+rd57baDozyPuH/LdAb1icln8X/2vIB9ARAy9tYCijOZgEXo0pB+0iaT2cP8LR+tE4kMXonsF0rxw1kBPtCWiHPd238oyLt/CX1AxMgxzAzI36hEI4isAF+1LDZ+LBBi7MvywxErM00WOocyWFHshNKRuN2H8rnf2BxGqVDX0ktQKNPSyk6BFiTsH9Enpld4FwyB7mnTaQAGdeZikcZTxrsxgtW8AFXCtstKQ3MQNNWfvm/NFJSbv4kxE3OzekXnO+1JEfXl3mwityzxKdILwYSBmvS82kzAGTvwwhepm59QF
 9n9LCUyp
 WtantQnur32dgXGeMpHOFThHkmjA9L92Biqi5agd2WqB5eLjRaxBNN+YM3CTdqD63IpO97OEVT3M71uWaInr4aLLhcjdBY9nkpBFwLoYSIqxaU4K3n/oRPNoPlfFUvjN9EYtV6ShCWB79i39qtNzx2fVCnSpCyzjT4p4zif2i4sYXjd+WhoczFawc6DU5M8+Tm4PFX/flp0A9FmGqHkhTAlUMm8ytjgIEkH7WUEynoWrB8WYiGA6RBXliuQ+Dm3tkMpZYEXZx6mL4XfiE61yUMWLBfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

WB_DONTCACHE_DIRTY counts the dirty folios that are marked dropbehind.
When a dropbehind folio is dirtied, folio_account_dirtied() adds it to
the counter.  When the folio is cleaned, folio_clear_dirty_for_io() or
folio_account_cleaned() subtracts it again.  This balances only if the
folio is marked before it is dirtied, as it is for the folios that an
RWF_DONTCACHE write creates.

To prepare for NFSD to mark a folio dropbehind once both writes that
share it have written their parts, handle a folio that is already dirty
when it is marked.  folio_set_dropbehind() only sets the flag.  With it,
the clean would subtract the folio from WB_DONTCACHE_DIRTY although it
was never added, and the counter would go negative.

Add folio_mark_dropbehind(), the inverse of filemap_clear_dropbehind().
With the folio locked, it sets PG_dropbehind.  Under the i_pages lock,
it adds the folio to WB_DONTCACHE_DIRTY if both PG_dirty and the dirty
tag are set.  A dirtier that has set PG_dirty but not yet counted the
folio finds the flag set and counts the folio itself.

Leave a mapped folio unmarked.  Through its page table, a mapped folio
can be dirtied without the folio lock: zap_present_folio_ptes() sets
PG_dirty before the folio is counted.  __folio_cancel_dirty() can leave
a stale dirty tag on a folio.  Then PG_dirty and the tag are both set in
that window, and the folio would be counted twice.  The folio lock keeps
an unmapped folio unmapped.  The dirtiers of an unmapped folio hold the
folio lock, except mark_buffer_dirty() on a file system with buffer
heads.  filemap_end_dropbehind() does not drop a mapped folio either, so
nothing is lost.

The name follows folio_set_dirty() and folio_mark_dirty(): the set
variant only sets the flag, the mark variant also accounts for it.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 include/linux/pagemap.h |  1 +
 mm/filemap.c            | 42 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 73af18a373670..3f5295d6fd73b 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1306,6 +1306,7 @@ void end_page_writeback(struct page *page);
 void folio_end_writeback(struct folio *folio);
 void folio_end_writeback_no_dropbehind(struct folio *folio);
 void folio_end_dropbehind(struct folio *folio);
+void folio_mark_dropbehind(struct folio *folio);
 void folio_wait_stable(struct folio *folio);
 void __folio_mark_dirty(struct folio *folio, struct address_space *, int warn);
 void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb);
diff --git a/mm/filemap.c b/mm/filemap.c
index 98ce955404127..196c385f29801 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1654,6 +1654,48 @@ void folio_end_dropbehind(struct folio *folio)
 }
 EXPORT_SYMBOL_GPL(folio_end_dropbehind);
 
+/**
+ * folio_mark_dropbehind - mark an existing folio dropbehind
+ * @folio: the folio, locked by the caller
+ *
+ * Mark @folio so that the writeback that cleans it drops it.  If the folio
+ * is already counted as dirty, which with the i_pages lock held means both
+ * PG_dirty and the dirty tag are set, add it to WB_DONTCACHE_DIRTY so that
+ * the clean that subtracts it leaves the counter balanced.  A mapped folio
+ * is left unmarked.
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
+	/*
+	 * Through its page table, a mapped folio can be dirtied without the
+	 * folio lock, and PG_dirty set before the folio is counted: with a
+	 * stale dirty tag it would be counted twice.  The folio lock keeps
+	 * an unmapped folio unmapped.  filemap_end_dropbehind() does not drop
+	 * a mapped folio either.
+	 */
+	if (folio_mapped(folio))
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


