Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95DAAC624DA
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 18:30:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84A3A6B009B; Thu,  3 Sep 2026 14:30:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FA696B009D; Thu,  3 Sep 2026 14:30:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674236B009E; Thu,  3 Sep 2026 14:30:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2411D6B009B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:30:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B227D1A0584
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 18:30:00 +0000 (UTC)
X-FDA: 85173290160.16.621E394
Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	by imf22.hostedemail.com (Postfix) with ESMTP id B329AC000B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 18:29:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="P CGah2g";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=mqQeKYgE;
	spf=pass (imf22.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788460198;
	b=v5ERGxWTqa+mHQaLwcZ3h1n99r8HAfpFOXqEcvC211HoEsdmYqM8DyHwhKRQyAH68q4hHS
	3n0pRUMUdsqHDsrpYmltbQ9AJ/gxLrDqqk/PG9ctHkZzLO0tdFSNHq5TFBPOhtWj33FqFp
	4j/oF06cTMTwzvBS6UmpJiGi8qRbDIQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788460198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l6U5JT6Kk2/xs1EJ8XhRce8llmfDGx2KTryruEjZgvk=;
	b=8N9I2dLHWyIFMbQL5wO/ZyAHL/Jomh+Zw8+AGgdU1Btr7v98mTynpQB0T1t9QMmidcYOwT
	LPGQ4Jw/xqijNh5LHdupAz0fwqaLycE0g/NswNvHBARj1+MDQy9whO5Q5kPbMnt5Da3nsa
	v2/ZJW3QZe/17PbGhq1g0oZM2IG2ZlI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="P CGah2g";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=mqQeKYgE;
	spf=pass (imf22.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.phl.internal (Postfix) with ESMTP id 47A8613801C9;
	Thu,  3 Sep 2026 14:29:58 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 03 Sep 2026 14:29:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788460198; x=
	1788467398; bh=l6U5JT6Kk2/xs1EJ8XhRce8llmfDGx2KTryruEjZgvk=; b=P
	CGah2gWTAOY3yv9onzlevaf6PtRIBJ9KvNO1H4h/R0CAu5V6o573OecJUZW1hu50
	OcmQbEEBiUm3A95KwPzs+qFC+qc0sLn9LyR/Cf8f+pvXz1W5077bFvLSFYz0iHes
	h3VeE+9hOMYTTukruZdGnajEF1rEAnh2I9G3mNOzCXhbZVEnP8dx0VRV18hTi457
	tSTXD693EWCrTXyZG8w3a+YJ4Oks4aVp4y2h/7DqGcLCHWEBoh88TTzikvGkRoP5
	htQGU7HY0nCHLtpnfcfcjv+7tdKKmaZB+puK5Hm7Xw42kXoV5iU+toStgRhIsvNj
	xZCfPWW4Ub5+o4KhpHoVg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788460198; x=1788467398; bh=l
	6U5JT6Kk2/xs1EJ8XhRce8llmfDGx2KTryruEjZgvk=; b=mqQeKYgEAME01DRGP
	c/4LZYMnGGlrYHdQXWflNww59PC4u8jo0l8zi85PR/DAwDBpzoT1UaxU1Xv5M5F9
	vGfOPVdGmRY0Zpn4ZAAnw+p/iSs8DUSejpEgl9RfarDJZboK2qoPGz1L7rA2W9Yk
	r/PceP3oNQWKpy1uKFhsZau2Q3ZPpvEMGsvdEYdbHbldnirD5VKCfYHN8yyPWyA3
	i5h9AewDwpdj/vYmcZwQfp6QOSW6rdaooaOKKiBJybJZIYe45AK4m7Mi/V6Rg44l
	ubJ1xF4tMXkJ6pVf/7Q04ynsSjc7DWDvTCE3CBVvYYN5z0hyRuYZRTCvxgoI9YZh
	e6e/A==
X-ME-Sender: <xms:pbyZaoRUCYH2PUUjjqJtWAh_uOO-I_rVSclY6p7fZrOEJwoXWMOK9g>
    <xme:pbyZam1LSJxdLeG8m4H9735RrL4DxIdClB-0Th7_MrJMa9jd1Ux2pXzzXwWvR5Lou
    TQN_c2NnjPGewb6sH2Mb4W3ZFycQ1wJsILlaw9Zez2MNnNgWrXLt3Td>
X-ME-Received: <xmr:pbyZaozgj8PBbF-nn7R25JcfLCPGz4JsKjz0RlbFBRWv12J62Y85yEx0lto>
X-ME-Proxy-Cause: dmFkZTFt7tpQ23d6ma5ZKwjaUeV/XmiCXSwfUJTD/UMTaTx+tQ6P98fG4/H3PFA7hJFxaU
    SY7i6N6X86D7HaHpdbLHvMivEhulOmq3NoSfdg1pBrJA6v+lfq2ALheALUZjz6o7Nf8BIz
    DWIHLTWCbkC3w9bMwM7vsWb978omVdOmMplVzO2fLHjMRy1E/CxFkmf+2uWv7frAXfMOWG
    H/vdAXIPTaxMrzbmklMnL5PmRnZSJQIp5M1ihNDwszNqcLBuKJXCEkMPvIWqkfKnePof3W
    BlQ363pN/8dtwFHD474IAw0kAsBZ9JYvF7V9lEJnX7ro/M4XAHwxRodQrXyCYUn1NLN+Ds
    vTSbwwlQXD/Xc/IRcU3516zJNmer5W7iJlak/JBkZGlLVXh5Jz1RDWZJv/HmQhCZSFe6/+
    LFT/aJzbopf1p7NE1DGDPW43exOhHSL2cH4V3IRUOv3StBhh/IZwpAlWaVz/iAgnjLIo3w
    ASK19DmhYX/RmFv3Osm2M4Ssd32+t4yegh9IdZHWic5Dxo0QmUYnp7ikHtJMkkfzVZTIW4
    QEexuTLPtB9MjxXyNFFVeKtVwKxsm7kXcZEh75wncogm4njYAvO9anhmQGa6ywTuDI5cTg
    /2HiBPo8JwB+W+Rw+qVIlUFyQdOeeenoeStd8WAmWkEgqh6whFzfNtMu6ruw
X-ME-Proxy: <xmx:pbyZapup6kMrevu5uz00sBXrWWMm0MRdVTxYqeFQPuchma-oHVMgFg>
    <xmx:pbyZaqQ0gKJQTo8-LJ3yvXIwiXEBeMbLhdnYZGFPBXijjmMPna7VEQ>
    <xmx:pbyZaoJaVom8vs6iatKmyuwuSQiZdhyvFOBDgHY9d28AG5cKHSR5Ag>
    <xmx:pbyZaqCtsWX4IOtptiXBCouIP--7hhUUNuUaMQvVkKAzFdUfI0VqNA>
    <xmx:pryZajmWbjgqzCdK0tFJm5QriJiY3WuHLeA3st8pXKkxXWDyw21JoxkW>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Sep 2026 14:29:57 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Jann Horn <jannh@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Usama Arif <usama.arif@linux.dev>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [RFC PATCH 4/5] iomap: narrow page_mkwrite() dirtying to the faulting page
Date: Thu,  3 Sep 2026 19:29:42 +0100
Message-ID: <20260903182943.662461-5-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903182943.662461-1-kirill@shutemov.name>
References: <20260903182943.662461-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B329AC000B
X-Stat-Signature: raenonbytt6iuzddc69pcb33fqapkmsc
X-HE-Tag: 1788460198-409521
X-HE-Meta: U2FsdGVkX19Z09+5FqUhNprd5M29ngc2AXhGgj8u7jCu0QpBCQrU5+sPLe2DBOnrrpj6ocWxwn2MNR3rPlhik96WDMhE41UCljT0nfFYAc7PuUYjOZltzUY2s45ReI6+ZmdV8xiKH/pXovIz+msAxwkQMWG1Yqy91mGHvENaauXM1+zXBpe8zHfICbG5eS1bVRq0zMLosKZHT7NbuMfmUAwcK/+MkzubuH4kswxuu9VfTvmXsOo3z2+V4ZE/cXU5X9wGgJ9GVRGuybzIoyqBMsVI3SyNhZoVbtuW0a/Y4fqsJMvN6HI2ex3sqap9jBlHNxc3h1m/zQ/lYNWfzmHs7sXQsHGporYmIN6sAPim18OOCzofpwarZROWc5DagVrV/hTk8/Jmu/R2Uc/o/L9CT6d4BCdvMyhgINoBR2sqaQux/7Rs70dWEbuSBI+FXrJ4TOKnFN6Xf/8IExMk63Cp0uvpUsWUS+6DvzVVCZLKaNF6F5pLuVr1MfjwJvE0laaBWYREeVPoQDsTMpBU33D3G1LZvNb5I6nPkszp694wjBEW8c41UP++lqR2vPLeuqVzaGxjgJ1B/wVbIbaGsy536RALHaSBJHpPq9Hei3RERsQaNvltkugxkwwJbvlGswBLt7P40Fk1u4FH/3E5FSTwNU84mbFNWk0YIJK09fENGQCj/uivow1FovcLu8akE+qfH0p7YeNVP7eGzV5LbQ77SrSQrmpQBaMrm/48ZILv/crh0uPEuJ+Yq01QDo/3oNnMV3+XE74QUEqoMSYEfm9KlJVcI1lwChd5yPrA0Einj1nSP7cnVKNT1lJo+C2nbnPCJaoCfkI6Ixjcrp0zBGxhS6gs7/ZWSKp6tR5tg+6MOhOPdKQGtTYeClcWPWOiUAtAeAXJ/aLzMhweclCXYtVDL1iafqm8M5zoxjCczIATZh/axFlFx2aTTMn8hlUcCGu4PbsYALBWaMTiCmuaWcX
 cdz8Ywun
 b35WoCfcZa1GQciAvMXIZxvW5MFDXekvoBUW9HvjdPJTexdpaRjAfENx71FD2C5CTWou0cL9YaKDImm1UkG4SZnqUy68F1F69/waIU4y+z7VvpPGRq5DikCovlsBvGWwR9QOw3rYOoyLRf23kbtUVdt4MxGUyVWOLUbqonVCtpBro753uXfm4LmcwnXycQLzRcDm0rOW6iMH2dlksSHFr6yOQZe6PICMVNtV9vaQ5v+pD2NYB7itvt9wOE6lFjA89nuG0Q37xUQyCl4ZKHHUeje4Sf3C119BXB6tAeM/OPwnpS7FZ4/XCS8IwB5WD75TmWgnPcx7axeuasXjWehTcfA67H2L1Bulbu0sEozojzRvk81Twq4sX/taOVKCbc+YSeklQAtFcKExN4MctKQrAwJziQcvPEWI02jg8M/jjmJXKDqbFKDTGN2BmPVdJOyMcCU6Xt0d0CiJGzTvQ2OpI33C1nHYHGzUgKr4hF+QB/b/UrW1aCQX8nY7vvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

iomap already tracks dirty state per block and iomap_writeback_folio()
already walks the bitmap and submits only the dirty ranges. The
buffered write path sets just the range it copied. Only the mmap path
sets everything, because iomap_dirty_folio() covers the whole folio.

Add iomap_dirty_folio_range() for the new a_ops->dirty_folio_range(),
and have iomap_page_mkwrite() dirty just the page the fault was for.
Blocks are still allocated for the whole folio; only the dirty range
narrows.

iomap_dirty_folio() becomes a call to it covering the whole folio.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 fs/iomap/buffered-io.c | 37 ++++++++++++++++++++++++++++---------
 include/linux/iomap.h  |  2 ++
 2 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 0a5ebfda90f1..8d8a8acab01a 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -847,14 +847,18 @@ void iomap_invalidate_folio(struct folio *folio, size_t offset, size_t len)
 }
 EXPORT_SYMBOL_GPL(iomap_invalidate_folio);
 
+bool iomap_dirty_folio_range(struct address_space *mapping, struct folio *folio,
+		size_t off, size_t len)
+{
+	ifs_alloc(mapping->host, folio, 0);
+	iomap_set_range_dirty(folio, off, len);
+	return filemap_dirty_folio(mapping, folio);
+}
+EXPORT_SYMBOL_GPL(iomap_dirty_folio_range);
+
 bool iomap_dirty_folio(struct address_space *mapping, struct folio *folio)
 {
-	struct inode *inode = mapping->host;
-	size_t len = folio_size(folio);
-
-	ifs_alloc(inode, folio, 0);
-	iomap_set_range_dirty(folio, 0, len);
-	return filemap_dirty_folio(mapping, folio);
+	return iomap_dirty_folio_range(mapping, folio, 0, folio_size(folio));
 }
 EXPORT_SYMBOL_GPL(iomap_dirty_folio);
 
@@ -1804,7 +1808,7 @@ iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
 EXPORT_SYMBOL_GPL(iomap_truncate_page);
 
 static int iomap_folio_mkwrite_iter(struct iomap_iter *iter,
-		struct folio *folio)
+		struct folio *folio, size_t dirty_off, size_t dirty_len)
 {
 	loff_t length = iomap_length(iter);
 	int ret;
@@ -1817,7 +1821,7 @@ static int iomap_folio_mkwrite_iter(struct iomap_iter *iter,
 		block_commit_write(folio, 0, length);
 	} else {
 		WARN_ON_ONCE(!folio_test_uptodate(folio));
-		folio_mark_dirty(folio);
+		folio_mark_dirty_range(folio, dirty_off, dirty_len);
 	}
 
 	return iomap_iter_advance(iter, length);
@@ -1832,6 +1836,7 @@ vm_fault_t iomap_page_mkwrite(struct vm_fault *vmf, const struct iomap_ops *ops,
 		.private	= private,
 	};
 	struct folio *folio = page_folio(vmf->page);
+	size_t dirty_off, dirty_len;
 	ssize_t ret;
 
 	folio_lock(folio);
@@ -1840,8 +1845,22 @@ vm_fault_t iomap_page_mkwrite(struct vm_fault *vmf, const struct iomap_ops *ops,
 		goto out_unlock;
 	iter.pos = folio_pos(folio);
 	iter.len = ret;
+
+	/*
+	 * Blocks are still allocated for the whole folio, but only the page
+	 * the fault was for has been written, so that is all that has to be
+	 * written back.  A racing truncate can leave that page beyond i_size,
+	 * and then there is nothing to dirty.
+	 */
+	dirty_off = folio_page_idx(folio, vmf->page) << PAGE_SHIFT;
+	if (dirty_off < ret)
+		dirty_len = min_t(size_t, PAGE_SIZE, ret - dirty_off);
+	else
+		dirty_len = 0;
+
 	while ((ret = iomap_iter(&iter, ops)) > 0)
-		iter.status = iomap_folio_mkwrite_iter(&iter, folio);
+		iter.status = iomap_folio_mkwrite_iter(&iter, folio,
+						       dirty_off, dirty_len);
 
 	if (ret < 0)
 		goto out_unlock;
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index bc7ae6327dbf..3cf2ac751409 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -443,6 +443,8 @@ struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len);
 bool iomap_release_folio(struct folio *folio, gfp_t gfp_flags);
 void iomap_invalidate_folio(struct folio *folio, size_t offset, size_t len);
 bool iomap_dirty_folio(struct address_space *mapping, struct folio *folio);
+bool iomap_dirty_folio_range(struct address_space *mapping, struct folio *folio,
+		size_t off, size_t len);
 void iomap_folio_mark_uptodate(struct folio *folio);
 int iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
 		const struct iomap_ops *ops,
-- 
2.54.0


