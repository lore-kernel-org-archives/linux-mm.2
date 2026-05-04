Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18EDCCD3430
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 13:21:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79AA66B008A; Mon,  4 May 2026 09:21:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 771C86B008C; Mon,  4 May 2026 09:21:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 687F76B0092; Mon,  4 May 2026 09:21:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 59D7A6B008A
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:21:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DDBF1A0196
	for <linux-mm@kvack.org>; Mon,  4 May 2026 13:21:30 +0000 (UTC)
X-FDA: 84729799140.08.8672671
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0CE1C20005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 13:21:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cmW1qlBQ;
	spf=pass (imf03.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777900889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LcBLDiEnmEUK/7A43QcReQz+8GNo3d7cig9MkZ27Z+4=;
	b=r0DA3fPnwPBfmhY3+eTDnr82NTzyKj9FXIe9OiCY+ex2gJr1fmQDUD3daTKSvQV4sNMhFQ
	SebNZbnBgR/yROElrHpq6kxrD59IiDl9Ic7BuuJMCizfwSnJTFLP39s00QEM9vnWXcKcEw
	7/OLgIZQsn27dPc34GeUpP8RH8pXmMw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cmW1qlBQ;
	spf=pass (imf03.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777900889; a=rsa-sha256;
	cv=none;
	b=1yWO0FbBIH3qu3PsIFqha474atlAkd/p5fEGbSNEUNrkM5kDulGyQHm8v+q9doIc/sLMyy
	JuzugC7HjoAWTL/xAPv7377y9hB3PSg/ns53bD5nQzYXwZQa8OgxaQo7wlr+QT8PCDQrCL
	HuoTO3XqbrP/rdbrKXnWnr7c+VDnuSA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0639C40564;
	Mon,  4 May 2026 13:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34274C4AF09;
	Mon,  4 May 2026 13:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777900887;
	bh=2aFCrdi086X8qaY+nrQYNcsSeV5HvIWfW7LHiwbQchQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=cmW1qlBQq1HOb3cm9DFTA9YWVwxGTYZ/7TDKbbF+u0tf0t0+vmPZw2hBkA+K8gxOI
	 aFjZC9Igr0Kf7wNgdzLmEu0yIwOhPPkmhQ8RFdE3H2G2BEGqdpjlihBLjHCyZz113T
	 PiFHPjWRTNQX64T+kzdNYo+BBay/WjHds/NBI2nIcopTuune73KPhKIKkdH8mnSt8/
	 mWaYsErFDGhpJx8I0j/uDTXjt6v4duueKgk3bKYpmzwD3JCDga8OjnPWjxEiVA1RkD
	 2finvn/5LM7g6+uSv+LuaUVfnrwlvhMv1DLRHIM4l+29nGQUfcQTbU6d/ysSVMKGXH
	 Ujiab4Xt/9Ikg==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 04 May 2026 15:20:49 +0200
Subject: [PATCH v5 1/2] mm: track DONTCACHE dirty pages per bdi_writeback
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260504-dontcache-v5-1-4103e58bb377@kernel.org>
References: <20260504-dontcache-v5-0-4103e58bb377@kernel.org>
In-Reply-To: <20260504-dontcache-v5-0-4103e58bb377@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
 Ritesh Harjani <ritesh.list@gmail.com>, 
 Chuck Lever <chuck.lever@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nfs@vger.kernel.org, linux-mm@kvack.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3721; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=2aFCrdi086X8qaY+nrQYNcsSeV5HvIWfW7LHiwbQchQ=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBp+J1NRZKbyI7QhGLiFF2oAvXgvp74opb+1ER2w
 V1/zzRaInuJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCafidTQAKCRAADmhBGVaC
 FVfRD/43QS9dZ/TF2zC6q4G6CqPoyA3ARP6obj1Xj+LbLpvyEmgsXxz+3d+U/FfnrA8BRHtb9QL
 qr+DcoUZk2qB+URtNgCPYPwKBDtqkgJ+SisKUHuXzqjw3qMTh6c4znnSG633tJttJopxbpR8YII
 s7t5olXjXb4eEmwPXIRAKzfrnxHBIj9WN9NZpWIKHDuQP529fBhbZEVyOnxorJuYKUebcLYerxm
 ha+rmiV4D17PNqIyUeX5rYbvKeeD3bUuXCQ1H+qI580RjMfbgUlisrWaK9vh7m+wB90snPQvcYQ
 dS9oFMbTspr49VuAUf/VEl6sFBgEllf+GwuujzQBWomgFJDCCM/xpeb1pRfc28ciMhTMzRD6lxq
 nLBiUtrwSR1UfOoruRdfA4PYDPsB6vFq5hNZMxgWhyJXgTrJhUif2Vzg+ADwlUMZfL49Xa1hYbu
 TS6q9Ph5QR+x1q7QaWGrax44oyb25sS7eRWljcso6CLFZU9EOrc6hoxEHFQyZpzVimCExJVFSkD
 BA8N0u5a9Wb27puAE8r2v0xFcGhZqf2qBiMZuTWNiiJ6csZBaeuvziWe+ESXIgabtB82LDJjkIm
 8DUcz0KpgvQYgTixhjkclRiF/6xqWnRG0G1EZ/CFfKBjt11N2Fd9F7enrpPODrT2CWcHbqoQuKr
 zLenDJ+Xa6OU7GQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: z4umfdsyp3wo9x16mqwd7ksskboqhnub
X-Rspamd-Queue-Id: 0CE1C20005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777900888-419267
X-HE-Meta: U2FsdGVkX1+7snc/iUVCOla5YHFsIY5NSVAIbbKa6w7zJOkTt11u6k2hiBVylVuu5Spiqwlnr/HskZWiBAIFMqsLBtLLN6YKKmq+ycrNU30TMHRPvubkiIIVMN81MEwGthpHJs/7yBUxHFo7zu6gDrnn0Xc5rSU2dQ9/6gzDuxMUbzmsPiyAoy7MlWBORILMULMWuVCiE3+J6T8VbMyOEhJlEq7iO+wsnrWOraRyMlvQqNbSJUnYC1z+7rndzk1OxcggbbfPcewGUuZW3iDXHZz0BfA5e1GqeAP/jEpyLHq1T7EZnS2yPAYoqIg5W8OuuhtBle78DQQmSMgXxUlmbX/XXhltl5Ohk00MfsmCqIzAjB06okWv9/WAZLQwnH4N6YhwBH7bWNQ8iUnVurmxasE9GSxgKoZWSb5RYNw6JPDomASXn7G2PZUjwh/o5N5yv3tkYKvHxHPpHTMnuLCiNIv7FzTyldIi6gcWpTns2M21eUbvGBy/sqsdHGZq+FQfy/QtFynDnGjWWquwFUCTnloQggCzQfGfCyLR75dQxZ8/DmxDDXGYrcoBQkNKVdsXDUpyYuj2PtpfMZOt2cND831xpUD0jIEjyUGpHo9MaDWrv8EG/hxUucT1OOwzcYlOmHy2T95V4aWMqHDbKdB8OzPKfHIGQMZuQ75qo2qIyXs/sozJRxsQ4e2/BoF+0dSQ0mmIfQ6PoSOCLV2Y7B1d7ZNfQQFr6VQj6sXE8A7GyUSKAGov4Y2XF6hDCDzxQd92H0jFh6uLINRQNZDArtH0eYpxnJjLAaGV3B+FkrGl5MYG1ci/5b61lW2wEGqnF64MtToLsDO73NXsp92yFSme7iR3zIW4o/2T9q/MxWnruTGsd/8RDZkNxGR1w68HpxqykOwwWoMCcNSrMHpjLx+chUzbtkG/pGe8RU1/Iq3RjZVyy2XO3EJ1ev8qQVym84AGKRLXB8Dq8HL1Cj8RACT
 JKPIeVA8
 u31KAV9dKRNjC4bP00uPYjFMi9h2OzNC2Kc3dkMybEL9T9Sgz8frtZN43f6ycXpgRtD3+xqoWGVycZVLPaavD0hDeWX/r1YgcEOEboaGYuLzBt2TlAMaM+AfusGuFcmvprmp7B8F7rj1Xhbf9CVdQeepxe2Xm5hT1TtcbbUmWH0Ykr+tIj+yPHOAnbVh1oy1o2v0xSamuGpwYxipXjFCnO7tBtdgOfgglRTnqjY4cUzFv+cnjcU/2WrjfLl3hOE5YXde48Ukb8OnyR4vk6kHJ0Ch9rkP0+Vbqm7Fejxdzo2M22Vr+w+QjvHTpmrBYI3+hGSGIHy8v786E+JsscxnWDWGTEt8O9iqd7aHeGseGTEHLoRE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a per-wb WB_DONTCACHE_DIRTY counter that tracks the number of dirty
pages with the dropbehind flag set (i.e., pages dirtied via RWF_DONTCACHE
writes).

Increment the counter alongside WB_RECLAIMABLE in folio_account_dirtied()
when the folio has the dropbehind flag set, and decrement it in
folio_clear_dirty_for_io() and folio_account_cleaned(). Also decrement it
when a non-DONTCACHE lookup clears the dropbehind flag on a dirty folio in
__filemap_get_folio_mpol(), using proper writeback domain locking.

The counter will be used by the writeback flusher to determine how many
pages to write back when expediting writeback for IOCB_DONTCACHE writes,
without flushing the entire BDI's dirty pages.

Suggested-by: Jan Kara <jack@suse.cz>
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/backing-dev-defs.h |  1 +
 mm/filemap.c                     | 13 ++++++++++++-
 mm/page-writeback.c              |  6 ++++++
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index a06b93446d10..cb660dd37286 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -33,6 +33,7 @@ enum wb_stat_item {
 	WB_WRITEBACK,
 	WB_DIRTIED,
 	WB_WRITTEN,
+	WB_DONTCACHE_DIRTY,
 	NR_WB_STAT_ITEMS
 };
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 4e636647100c..1c9c0d5f495f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2052,8 +2052,19 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 	if (!folio)
 		return ERR_PTR(-ENOENT);
 	/* not an uncached lookup, clear uncached if set */
-	if (folio_test_dropbehind(folio) && !(fgp_flags & FGP_DONTCACHE))
+	if (folio_test_dropbehind(folio) && !(fgp_flags & FGP_DONTCACHE)) {
+		if (folio_test_dirty(folio)) {
+			struct inode *inode = mapping->host;
+			struct bdi_writeback *wb;
+			struct wb_lock_cookie cookie = {};
+
+			wb = unlocked_inode_to_wb_begin(inode, &cookie);
+			wb_stat_mod(wb, WB_DONTCACHE_DIRTY,
+				    -folio_nr_pages(folio));
+			unlocked_inode_to_wb_end(inode, &cookie);
+		}
 		folio_clear_dropbehind(folio);
+	}
 	return folio;
 }
 EXPORT_SYMBOL(__filemap_get_folio_mpol);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 88cd53d4ba09..8e520717d1f6 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2630,6 +2630,8 @@ static void folio_account_dirtied(struct folio *folio,
 		wb = inode_to_wb(inode);
 
 		lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr);
+		if (folio_test_dropbehind(folio))
+			wb_stat_mod(wb, WB_DONTCACHE_DIRTY, nr);
 		__zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
 		__node_stat_mod_folio(folio, NR_DIRTIED, nr);
 		wb_stat_mod(wb, WB_RECLAIMABLE, nr);
@@ -2651,6 +2653,8 @@ void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb)
 	long nr = folio_nr_pages(folio);
 
 	lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
+	if (folio_test_dropbehind(folio))
+		wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
 	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
 	wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
 	task_io_account_cancelled_write(nr * PAGE_SIZE);
@@ -2920,6 +2924,8 @@ bool folio_clear_dirty_for_io(struct folio *folio)
 		if (folio_test_clear_dirty(folio)) {
 			long nr = folio_nr_pages(folio);
 			lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
+			if (folio_test_dropbehind(folio))
+				wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
 			zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
 			wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
 			ret = true;

-- 
2.54.0


