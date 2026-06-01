Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5247CD6E61
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 19:26:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E9536B04AB; Mon,  1 Jun 2026 15:26:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44C0B6B04AD; Mon,  1 Jun 2026 15:26:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 389D16B04AE; Mon,  1 Jun 2026 15:26:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24D556B04AB
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:26:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD415C207F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 19:26:34 +0000 (UTC)
X-FDA: 84832325508.07.E1D37F7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1251B20002
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 19:26:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DpG1jwm2;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780341993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HuAHwFgxQTl/6u/qT6//YvieKzXrnJyvSaoUGnMavJo=;
	b=wUTNws6SanslLnYCQRZDsNSRrC75cq0TopRt9wTJ1EbuRgZi0pXc+y1mmgbM3OFlPOb3Pn
	PappnIvgDXR8a7ZxKQKNlU44b8yPSGvTujjr6K6XB9Kkno2QA/Zzua21jYmCpNKHO6zCTl
	v0Uun1Q0GCGqBIVpdEq4V4wieMkhcbI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DpG1jwm2;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780341993;
	b=u3t6yt2oR4WfTf/QxBoIm6dxsNZznovv+Q2pJ5VuPJ4kF2FOfklj9/f6YZb/aNXUdPNDqO
	oyEpgpjga4KXphvDputv90QF924gZVmxh4Uei4jbyzTTMQJmQpOvo76JtqXAJATD3wNofJ
	3nTuKowsjKvyJ13ki2FR9tb3YxCD/w8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=HuAHwFgxQTl/6u/qT6//YvieKzXrnJyvSaoUGnMavJo=; b=DpG1jwm2UYMqqHqXLHMEKJ5M4b
	wwlvLajwdRr2b1i8oK2RYr6lfgH3sbxBVgHtCeGNaEenq4xz8rdDes15Tst8xrV25t+7aMHBWbxTG
	OnvOU6c3JPKgx3fql1s3iT5wlzulqA3jM7ByKV9r7a5U6vLxhaJSZUdK013rpUBhbVJLX4hQI4kJD
	ri0XZmBDGdHxycjTF5b7CzbASEpFOmu4KtJAQmhf3Eq1nqdw5Sw7Z5MbJZ882jEG2v6qH1jQwCAA1
	Swd6yC7+cF+/JF/nWE1syl0Cy8cfq4FNudpg+V2Soytrvahj4IVWPdxYOlhfXW1XDKp9jLXd0OiEf
	iHwIfF5Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wU8HM-00000000dEY-0Bv4;
	Mon, 01 Jun 2026 19:26:28 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@lst.de>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/3] ntfs: Remove references to page->__folio_index
Date: Mon,  1 Jun 2026 20:26:21 +0100
Message-ID: <20260601192626.150804-3-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260601192626.150804-1-willy@infradead.org>
References: <20260601192626.150804-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1251B20002
X-Stat-Signature: otp3gxabbs8kog8o9wtd9k5d7tk9r8x3
X-HE-Tag: 1780341992-623400
X-HE-Meta: U2FsdGVkX19Zsg8zZRVP5SlHUHxA+iFxYgf2nMc/BIhU2bGBOUUVbcSJoHhVrzkYrEDWl92xw7UgR2jAYl8P1he1uBb+xiiXs3K4Q9jy+yK69jBLTf63szvYMW/aTIFRCOjTfXMi4EI6ckcRfFlNUCiboJUjRfMZrpbg7QQ9uouMixJHhnY7J4YsbClrjq8aB7w5WT0yJfC2VZgdmFgmP3F41veuW01T+VX74scj14CJkQfT87mVrQCTvUDsxlnNabdrLO19xSEKwUTT2BrlwN6Gt+Padd3onglrcYGnJ04GXMQ0XiGG99rYwm8A59u0lgFkalxh7HTY2MtbQj45mO2WuldkGoEKEN+z2kDRZ568ZnA0Tf2WCh1siN5kxc/C/amFElWFYCwpAFaJSZhxH2/HE806G+jdeofIo4CeoXwvPyzD+e1Pz+3nx2ysTg6JA5gDtOHyeXC24mMxCIfTRz4UKgD0IYSCW1TwSSGUJae1PzqF3URopbPBsix+bBwGL68OlpP2EWCaQscbT8zwS8FWuxQbNxin7Iuch+KpoJm4KQFxt+XxYMwKCWT9CPQ2cG838qQbkFc/VdA1Ev5+TfX7YCu3+2LP8WZBKcHiKy8E0eOSRQLIscHwakJraUyBt6nbwvT5A8fVcpz48JnVx2+yvmQTvy2cLRdd0Eq9P321VxsnFccTEX/qlRfKKLnXBgyP2YSDOKBrjsuXwTFYlxzmXck2cjz9jnQWPM7Lxj873tvjDoHWgqC6HpgQjImJ+vvrXxV/ykaRTqBw7xCYmNC61OAoEz6bL7N5e0JR6LISfnWNfMriOJQysvZ/nar+eyCGCE93hYywUN60fRq9BQaYT/xXHG7emHVbLV2krrUJ0+fgfCNHq+U7FTlbStEEy3FZWVjMMJvAkCUtyq5EziXSR39HxAmJvEGI1pFfEKHp0bjlpraRZXQ88bRzGP62txG8n9SLZB4zAnPoYRP
 IXAG/rU/
 eBRoyAJX5TP9KMtIliCj64ZgAIDEC5FpohrA7Z2i99/eoP89tgEOsuzjR6kAJAdM6wQZddOnggTAIyjV6jHGfaEbMnIHgeBc2Z1b4z1KA1L+qFjV3KQ103As2KguyQWo8MX9HCxPe1BeCzxylhWb+RYPHPxb0HV71X4oT0n8OZcJPmZynhvq9QzH9lOv50nt8RRlNPpapMgzJ26rJ/d5wGxzSF/J2ccs0IU/ckZZalVFITDi5SBD4lXGB4VfyASQwSctLdEyAMuMCIsVdSxpZus/dOvRbst+n3OODswuIdrO4LTtZP9kyJE5w6xjAApY5LBfXKNCxQCxbq1CK/RsELM1x9utyHEfEenD2FUy7GEDuXO2RPCCpwrr0CaizEQp3ywJk4h0OhsbRf4GeNfmLecnwpndunILE2Nc0sDHjOf0q8eOJYk7LedIngxEOcJ+8WIUZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pages don't have indexes, folios have indexes.  Correct this in
ntfs_read_compressed_block() and also remove a use of page->mapping
while I'm in here.  Also convert the calls to unlock_page() and
flush_dcache_page().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Fixes: 495e90fa3348 (ntfs: update attrib operations)
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ntfs/compress.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
index 143f362a42f5..096e00b967d7 100644
--- a/fs/ntfs/compress.c
+++ b/fs/ntfs/compress.c
@@ -456,14 +456,14 @@ int ntfs_read_compressed_block(struct folio *folio)
 	struct page *page = &folio->page;
 	loff_t i_size;
 	s64 initialized_size;
-	struct address_space *mapping = page->mapping;
+	struct address_space *mapping = folio->mapping;
 	struct ntfs_inode *ni = NTFS_I(mapping->host);
 	struct ntfs_volume *vol = ni->vol;
 	struct super_block *sb = vol->sb;
 	struct runlist_element *rl;
 	unsigned long flags;
 	u8 *cb, *cb_pos, *cb_end;
-	unsigned long offset, index = page->__folio_index;
+	unsigned long offset, index = folio->index;
 	u32 cb_size = ni->itype.compressed.block_size;
 	u64 cb_size_mask = cb_size - 1UL;
 	s64 vcn;
@@ -812,14 +812,16 @@ int ntfs_read_compressed_block(struct folio *folio)
 	for (cur_page = 0; cur_page < max_page; cur_page++) {
 		page = pages[cur_page];
 		if (page) {
+			struct folio *folio = page_folio(page);
+
 			ntfs_error(vol->sb,
 				"Still have pages left! Terminating them with extreme prejudice.  Inode 0x%llx, page index 0x%lx.",
-				ni->mft_no, page->__folio_index);
-			flush_dcache_page(page);
+				ni->mft_no, folio->index);
+			flush_dcache_folio(folio);
 			kunmap_local(page_address(page));
-			unlock_page(page);
+			folio_unlock(folio);
 			if (cur_page != xpage)
-				put_page(page);
+				folio_put(folio);
 			pages[cur_page] = NULL;
 		}
 	}
-- 
2.47.3


