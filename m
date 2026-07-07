Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1945C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 18:17:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 150526B009F; Tue,  7 Jul 2026 14:17:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 101CD6B00A1; Tue,  7 Jul 2026 14:17:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 016646B00A2; Tue,  7 Jul 2026 14:17:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C2B876B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:17:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 41C2E8F16C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:17:29 +0000 (UTC)
X-FDA: 84962788218.27.85628EA
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 48CB6A0005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:17:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=I3sGXCzw;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783448247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r249gM4iXTQ6eUQ1gNaivD6JMaZ5JgFYVLW9aY5KB3A=;
	b=6s9n7zTbXNVPujcD+QB96AmlepR8YQ39DjtBUqh+F9++FFlwjL7syrmjNh8c0jiof7MQ2b
	fWlS7Zn++GDqq+pyalD8Laxhu0ThaP+5z8y8BoavFoqLEzp4IvrjJQ2fT9oMvvI/OLhx7n
	XrFOQsEfEzAfeR49UgrS1i8JvxFMyyU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=I3sGXCzw;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783448247;
	b=6lkxatmuEqddtWanqsn34naSTfYqU/vokJ3H4hSJZwKY6zi/nx9rXQpcvmFivjsa2qDcVo
	5KqUSEGU9UFe/aluUrozA1n5FEviEB6hJjMrAdIdjcPdnmixiUxB87lM2fBrXn0sFnrUT1
	rWX9QEpdMAW6KTIS6V883b9lG++zbRc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=r249gM4iXTQ6eUQ1gNaivD6JMaZ5JgFYVLW9aY5KB3A=; b=I3sGXCzwJbrMaxEYvBwQMu2Glk
	MezlbPV72lMWcY0FbOmqTeMhhj41lq3a/d/giYZ2Tt2YfDcR1jozJoCtP0qaXkldrJUvbfG7cUx7x
	Q19eM6BoHaoqe5K61jifqFXAbLIEiPn+Quoi6eXNkDi/OQy2FIwaG3xRnmV3zIf8VdTc7BYQfUi6k
	eykLBEvoE//L382RPjj/m3udsbLml4Ti32LSbqgjieXMx6G4M7TY75NsZJPKSJE18jK3MN0GXUXDj
	EsQIRjYaRqCmaLvWmQe/PQCq/uHYjOXmwQ2eT0LOwpVTTRYR/c4EuZJ6WV1w/7uxAGKoM4swiC1hY
	DTopQuqw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whAM7-00000000sBi-2jRJ;
	Tue, 07 Jul 2026 18:17:15 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 3/4] filemap: add hwpoison handling to filemap_read()
Date: Tue,  7 Jul 2026 19:17:10 +0100
Message-ID: <20260707181713.208282-4-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260707181713.208282-1-willy@infradead.org>
References: <20260707181713.208282-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 48CB6A0005
X-Stat-Signature: oy33wqirhau751xzipxrr3gx9qgc5aw5
X-HE-Tag: 1783448247-662669
X-HE-Meta: U2FsdGVkX1+udIOzw1VJeWaqit7Xe4iq9YwEc+bLMHcZ11AWOpK7So+TLa7Ek22KGmf1y9b3AejOsYrY+KkWhc/8bmVdKIvhl+hwp1dxvI7j5i+GPWTmg2SSK9M0+RuPTbe1QPo0jv/P9oj8z2ikPgpIJ0YUQpH0S8sb2uRwMTurngpm2IXwdkfcaeLT35DNTgAmf3ZxxB7b8jZjm7ZM2oJegq612GrqWPhRvDCA8cLv3o+q1bYiJIkTS7bBk+jDcqgU6c08nWN9vziPJAsoISEquIFRaKH82I2ypk3CvlOYymK8ENCadvR//38KHxXwoIW28d8pQhUSwgAqga2B95l8vPxczHYOgfUhVvPT0mFmnF4zhYDd593vu4YXpX2mowQQpnN6HY/DnJXGC5rJ/R0WLR+l8mPVLZ5TU3Vr3A5RxyL16efa2lzbyg3LNvvr8riEDMdTakM8Gv4aYyESbmLc+5D15+aGvvmXOSJ5Xyyfly++Fd2iKZh2YT21sviPlPiPXdlbdZGdiJ7ho0fbZBaHjQgo9r8VqwyXZBJO4Kq/bWwwJkcVYY4XGn0Fts6GfKwayNK2ya/p/2uPB0iG9GEZgu6ivoF2EktjEko9JW1f5yPzmuS/tXxU4cHMFI+zEkE31VN006c9m40OP5nddq3S7Acj45OwvNlmTsGWxyHZLaMEU31g9u2+S3insY+kiiMinoJR3JCyGp16I0+39v40KHX9+6UyYnG4ElolYk6MtfgKegEdLPOkL1UjDrdigBeXghA6u9njOTYwByKAqwHAyMX8vY0DtX8yUkqtPk0e01rWVjVOaNo5+mCOfUOP4y9mwbHXYXq08OEMvj1Tqg90zG4Gm8tyPmhHODCAbjoedKjbAsT9Zh/gWh+w7rvfidzgm5NJ/0pUVDZgf9ijL+XsbAKtUFWsQSO6wPrCOUc5JNo/pCc/In29rw0lBbfJXmv08tkt5YkLw/eheu4
 foCzI5fP
 OVc2+gNptu5KqUBYrNPDKIsEm6Sg2Ywf/G6DCjtd56mhZgFRNsVbHxKdhAUXdbeoWUBBQT4Mg0/cX4m1GCmkiP2twVB/5vM0LpF2Oq5Wr0aThWltDg+ZLGRmB93LPZ/hChzM+/UEAAutfveZBAX80IPCL7CgnKYBQ6ttbREhVVcN8YH6Y/xNl3eyX1e09LlnPEXIehysCrr+66jTpMnO2H2YdZ1mnjzhDs5pCj+VQ3o6cw1cEHakxynG4Yuu8B8c4tMVrupPTrpfa2Vu2m/3E2/jXI++FhKMzIQxJSwzs/2eTJxrsSsAcH94WKBJC5M+yOT/l2lm5YPbc0e7zk60KJThoJ5Jv82GrUW6nRxl5VVTiVoCkwEmAtwDaVZxe1dLnCKVU8XOAFFqoDtNnugAYXaWd2MH8QAKxAygZ6e4ar+lPT5raAoGT4qbb97B0dJlFUAFC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jane Chu <jane.chu@oracle.com>

Add hwpoison handling to filemap_read() such that .read_iter() could
make best effort copying data out of clean pages without risking
MCE in case page cache contains HWpoison.

[1] https://lore.kernel.org/linux-mm/aeZwAz6PcdlqSnJ2@casper.infradead.org/

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 mm/filemap.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index 5af62e6abca5..2b65367574be 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2483,6 +2483,8 @@ static void filemap_get_read_batch(struct address_space *mapping,
 
 		if (!folio_batch_add(fbatch, folio))
 			break;
+		if (folio_contain_hwpoisoned_page(folio))
+			break;
 		if (!folio_test_uptodate(folio))
 			break;
 		if (folio_test_readahead(folio))
@@ -2749,6 +2751,27 @@ static inline bool pos_same_folio(loff_t pos1, loff_t pos2, struct folio *folio)
 	return (pos1 >> shift == pos2 >> shift);
 }
 
+static size_t adjust_range_hwpoison(const struct folio *folio, size_t offset,
+		size_t bytes)
+{
+	const struct page *page = folio_page(folio, offset / PAGE_SIZE);
+	size_t safe_bytes;
+
+	if (is_page_hwpoison(page))
+		return 0;
+
+	/* Safe to read the remaining bytes in this page. */
+	safe_bytes = PAGE_SIZE - (offset % PAGE_SIZE);
+	page++;
+
+	/* Check each remaining page as long as we are not done yet. */
+	for (; safe_bytes < bytes; safe_bytes += PAGE_SIZE, page++)
+		if (is_page_hwpoison(page))
+			break;
+
+	return min(safe_bytes, bytes);
+}
+
 static void filemap_end_dropbehind_read(struct folio *folio)
 {
 	if (!folio_test_dropbehind(folio))
@@ -2862,6 +2885,14 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 			if (writably_mapped)
 				flush_dcache_folio(folio);
 
+			if (folio_contain_hwpoisoned_page(folio)) {
+				bytes = adjust_range_hwpoison(folio, offset, bytes);
+				if (bytes == 0) {
+					error = -EIO;
+					break;
+				}
+			}
+
 			copied = copy_folio_to_iter(folio, offset, bytes, iter);
 
 			already_read += copied;
-- 
2.47.3


