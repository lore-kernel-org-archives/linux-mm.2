Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83817606A32D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 21:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aUSE2kt3
Received: by kanga.kvack.org (Postfix)
	id D9E6D6B05C0; Tue,  3 Nov 2026 16:18:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D77786B05C1; Tue,  3 Nov 2026 16:18:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB2CC6B05C2; Tue,  3 Nov 2026 16:18:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E3956B05C0
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:18:03 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 158A2A806B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:18:03 +0000 (UTC)
X-FDA: 85395070446.25.2D6A398
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6E21540002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:18:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aUSE2kt3;
	spf=pass (imf12.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793740681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DI89KFBg08cV0NMoZcQe793KHlTmMZi7dlrFBwSyZaw=;
	b=wlpsVOhy0Q+v0qYrVei0Qr6Awcc3QU+y6rfiBImeZBOL8jSuJfdP9wnoCHhOYKr7FoA3iR
	SL8YrXhqhRJ19cGpWsvPg0hBqrRNBvlN8RNhPrF0+91QHK0qp/f2a+1fpWZg8UmrES0C/y
	k8s2Gf0VZos1KfBUnFJ8vZb+y0NzMxk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aUSE2kt3;
	spf=pass (imf12.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793740681;
	b=cgP2dN2hIHWQ8coFwyXLe6S5S78+PNYwQRsnVVJWg5zo8VUUhGvJXWUds37Dq/x26aQIZl
	xoXTuQuvrz3dSM5iJT8sM2p10AEHz7zy4ZO1Gdo2nt1EdVYKcjEy8fAPKuAGDs+9NcGs1P
	XRlc1s4iiEOyveJdIhNLz8/TKg41By0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BDC3F40F42;
	Tue,  3 Nov 2026 21:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738351F00A1A;
	Tue,  3 Nov 2026 21:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793740680;
	bh=DI89KFBg08cV0NMoZcQe793KHlTmMZi7dlrFBwSyZaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aUSE2kt3f6UaFdPxcLV4ZJIDjVzGjYBMNsGVkFaf1jo9LkWqkjrz4yl4GpX3IBkTw
	 zIG7m/fXJrWMSoMHe9SSopQykRMeM6LMaz55t+/MiJj59pPWz5CaTQEEj4XQ4bpziT
	 F+/t8qLzhHwcFXI8UlXRZhEFGmUFPGd+rLAGri/sx+ni91puKPc3WwkuMoaG1Rrwt0
	 RdtCnNy0Wj8Lnmw/tsSI5hd+T40vgO/UWTIKJ78LTF2A/YP0dCnbkWkLSBKJkuXv8/
	 /5dmqlkK76mQyL7x72g9ixA1r8WLpTD3pq2tzfCeFl5gr6iwl3abwQbWHWcBz2wFSK
	 oZOpn5JeHMc2g==
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
Subject: [PATCH v10 4/7] mm: add folio_mark_dropbehind() to mark a folio dropbehind and account it
Date: Tue,  3 Nov 2026 16:17:51 -0500
Message-ID: <20261103211754.35352-5-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261103211754.35352-1-snitzer@kernel.org>
References: <20261103211754.35352-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ddgp7ii44m478kdt8rcqfryzmdnda8po
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6E21540002
X-HE-Tag: 1793740681-823318
X-HE-Meta: U2FsdGVkX19fgN1FscTXbQ2T9305S9Yr3MqEuY/tZ81As/OgM0Vry/UzXDe+yfo2BsS7vf4OfWLno+NP7/n+U6h7aGt9diraEj6g8UP2ngLlcWJrTPaD4T5xgiT41gXo2JUpV/cDFOKbbaEMliLtJ5j6lOofdK6cunCo2yCAfjXvfYGYu6aarGllpmA86fEa7wP3muS4i7fwnumtkKm6fQ1/4GxQLlM/jVNPnA2/7BC6Lh05x5bhbCBAks0NsH2/JovxDIfuJuU3ZFjbZJiZg/fetmT37PuQgZwH1ry+ibI+dwyT6e5yWGmVV4r28TxEHdJnMTJh2WiDW2cLgwcrfQgdSbuLmgmy4LarKowg2SWXwIBfJGs5cMm8AfNeZ3P+dFwZ9mcGgWvhdy0zQGFgMk9suY3GvudSeLMRTMVpL/hsZRNqlUTq8dELJgngb0CnjNTP/nuRxJhBjqwWDcamppK/cJaZp7t7AuEyeL6IZAqBcKfSRIF+q3ADge8fXNuthNbWCxPmXA4q45e+8rAfyZpus3DGClMpF59p9dW1JerTmFbwIStdvl/l+pNDmEFYdzXICR/w1E4tq4l/5T3ZJUPpThLR9gNcFtHuSgWBdyotE4PZpOn6mk10Twl/JpsYIiGAUdrXq+/o4YGPsxu9KeWClwI5QRiQ6HYV1DC2PdMudtudf8HSQPdKLjFvmzV4Bh0bf4TvD041dLn6yDw2jB8eidtJkirzhVtiWoAJ9yCrRTpc273+LlqvpJm/Gef/WcmA0AmPhKR9p5qgiznBnDMoiWwz75u+CH97XNxa+oH77DhZf6/DUisY9SS88/iaHYxgtX03V/KdLioBuDppnciJ5gZuU0LcADnysK1PZy3PpcfhtX0mx38DAoCmc2gbt1TKFQxbRMKfS0znz6X+fHCXmdTBsOPqP9+9fx3fXsmeh0/h1LDJaIFjbBPtHVhtTfeqYL6OhN+1Pvks/j2
 hRxK4mpx
 2HGLLKr4fZQUPgpIN8IoTs2HQ9PI9hfr8ZzNuMlIWGujH78aFXJN+B6nrX31KoONPYrq5nv0oSNFSBIBhXXOWMsU1Jq0hfD5MyORtUdgpUjAtlRUwBkUvgL9WnOq6++2GycWRoGf3Tm7930mmslEYVvL7vN9LB/ECjICHbmSA7mU0DqnfHpJZytXu3Kc3NNMAbkKBtgUMYJk3RSeva+dfKIwQgJVKJczuGWnnIiT0sJS1PgUll6J6rJQaLrDtwNZXNZYaxVx3bOxNykHF2cg9PRo0VDSikKA2LO01jHD6vtF+h/MEumTDJTNEH+TJ4gwidlNwRrcttYIutyfXNChqONLIj30hol5ETBaG1RJ+mZ0AnWA=
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

The name follows folio_set_dirty() and folio_mark_dirty(): the set
variant only sets the flag, the mark variant also accounts for it.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---

Notes:
    Notes on questions from earlier reviews, with the code that answers each:
    
    - Counting rule.  The same rule as filemap_clear_dropbehind() in
      2/7: folio_mark_dropbehind() counts the folio only when
      folio_test_dirty() and PAGECACHE_TAG_DIRTY are both true.  The
      test runs under the folio lock (VM_WARN_ON_ONCE_FOLIO checks it)
      and the i_pages lock.  A stale tag on a clean folio adds no count.
    - Double count.  A folio that has PG_dropbehind returns at the first
      test, before it changes the count.
    - No writeback.  A mapping without writeback gets only the flag.
      folio_account_dirtied() does not count such a folio either
      (mapping_can_writeback()).
    - Known window.  As in 2/7: a stale tag together with an unlocked
      dirtier that has set PG_dirty but not yet taken the i_pages lock
      can make this count a folio that the dirtier then counts again.
      Only the counter is affected.

 include/linux/pagemap.h |  1 +
 mm/filemap.c            | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

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
index 3a13289c07dc4..5134227ba3a23 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1643,6 +1643,38 @@ void folio_end_dropbehind(struct folio *folio)
 }
 EXPORT_SYMBOL_GPL(folio_end_dropbehind);
 
+/**
+ * folio_mark_dropbehind - mark an existing folio dropbehind
+ * @folio: the folio, locked by the caller
+ *
+ * Mark @folio so that the writeback that cleans it drops it.  If the folio
+ * is already counted as dirty, which with the i_pages lock held means both
+ * PG_dirty and the dirty tag are set, add it to WB_DONTCACHE_DIRTY so that
+ * the clean that subtracts it leaves the counter balanced.
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


