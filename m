Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3B9BC4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:09:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23B756B00C2; Tue, 14 Jul 2026 14:09:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EEC06B00CF; Tue, 14 Jul 2026 14:09:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EADA6B00C2; Tue, 14 Jul 2026 14:09:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CA48F6B00C2
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:09:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B279CA04B6
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:09:04 +0000 (UTC)
X-FDA: 84988168608.16.0ACA741
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8C881140011
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:09:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YguRKqYc;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784052542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D4UHE2aMrlLfsSQ1GFII5ZbKd0oEikGw4iB1n/r35n0=;
	b=H9l35yLRMfIj8Mkll7dlk48Frgaaf8qG/GmwdpZMw8xIn/L+oI1O2i1RKGfi4ZIMWw876K
	Z9hjxlKYn5ZIn3Zm42ifGFjVdFzlCD2XfY8NlB+bjo4GEfvC+VICj9VUiz8BP8CZK1WdN9
	qZcMYBytGEA7MMz+HTJV7EcoWeZQLNc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YguRKqYc;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784052542;
	b=YrK0l6Bs6ezA4lkO0bInHJZxQNTtoKS0J+fSspkKJti8V3X0iuPZ2Vp0jUcQAI41gc1lFJ
	hy+i33sau4j7CMUwPjzjgdHItSLI3FJ3AZvC2WnBMla4L9prAtf5UdRgNevXl0iSsL8WJ9
	ZQ1RyNs5YknnCieVVGZr6jEEyBFwC18=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=D4UHE2aMrlLfsSQ1GFII5ZbKd0oEikGw4iB1n/r35n0=; b=YguRKqYcBeI4mb+IQtO1ZyWKgS
	AEnA1FUinKY1oH1LZUw7+KMV+1Ou8btsXg4UFOaDVzzT9/GsrVbjBXXA+UOl5LZILkMvJOpyHpU9e
	/auHMO+rXhh6zuteCoVK2gjZW6Cl16zXQgrewyKgo5NCuvuzXVy+7kzQbVbLFghpHGc+qk30OUtVL
	QAa5xcAV6xJwnGUmS9qwOMuxTrYolzZUfHiPA+grMddntZ/1PdddieJR2/c93xuv6KcTH4R6mLmW2
	N759uc2hL6fS+tY7S9VY/qaY7dU1j8v8t7F1ZCxPJX794VD+XrXuWT7TVxbJ8IiZMLtOHeAgG0JvJ
	FqD+L3ZQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjhYh-0000000Fega-0iHa;
	Tue, 14 Jul 2026 18:08:43 +0000
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
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v3 5/9] filemap: Add hwpoison handling to filemap_read()
Date: Tue, 14 Jul 2026 19:08:35 +0100
Message-ID: <20260714180840.3731244-6-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260714180840.3731244-1-willy@infradead.org>
References: <20260714180840.3731244-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6u7bmii8th1jqj8zrtw7adxmyu8mgyiy
X-Rspamd-Queue-Id: 8C881140011
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784052542-475903
X-HE-Meta: U2FsdGVkX18EQubfM+M3LH5JGBi0xjV14QGTOXAfN8Rpi+fl+QbVYpNFFhZtW00szwAsVn92VPpU6RWy5beh7uY875nLwFymzhP4hjqKBm2pXye1Vi+ocwHbdo/g+AGxxRSjRvD9sdk2aoAoRVaLBSEkFANqVSg115K3ox/O1Sd0qVpn0Ywf7SB4fNTrbHENgM60kqTTm+Rn+mMoq6ojFgzEGNMpgwQa6D3q0sOugWxMFAcGR7dHPcIPqFsDsNDsReHPPwiiwAn5pZkCE+FKUfxkASIIGcCN9cgXAfsm82QyVYopnWXlYb1OTSNKDCmOVr0GMJ41XbK4dFdtSpjqmvLJvx+JzYQ40X7CrDGZD42zU/ryNxMSwMZxPNZdXRu0WyWskxxlMp14Ta7thcmW0FwR6WEp31KTDJaNz7mmK4eFvWkW/nGAe5Oms8De1Fz44oSvRIwLk8t/CTArjECZGltRLUee/4g7hG09SF4oI/+Wmx+xbrTyy/54CTq2M+Gm4+eVWqpYrC5tXShoEFZcdClfehLxkCxuiNPuVpNiYZf7zHpWMu5Ie0FcRoc8p2jiNpYkYCRwR9inv2VZuxfbFo7SnhoJkqAZMEmgarlXA7TBnTCOPz7mDtkQnDiXUMHvKrEoHsyqhnIxaaLDcxfUipCqtzjkEBfBZrXOkt6jCShU2LpnhCLpCGr5GR9i+7Wyb0/48RHVjngM5wI1pZ4eNv/xY+CDwJX6UFy0ViQi6bBmF5xRLWBWmtkKkZg8ZI5eaDZb/Xh/dsO9spZWMZt6JIYFjW5U5zVmvQfj6xmcFh9LzTUIVM4XHj2vjRiw8sOP1U8KnCBBUdXHniCCYRjP4hgS5P2SLa6S8t0ekX+KQdpB0+bd3VvcAklzzRXGnb1Mnm5Oo6sYXhtndScYyn9swO8ETEDBZ8QCgmMT1ETUHtCY+ew05iTh+SKl8ymJbJW9eOe/GQFOSDSE+ER+9Co
 4C6Psa+i
 LTbQyURlHKxQbLlQlbxzwzGDk41HzOS9Pp91+X7gGqAtAznqd59C6sGEugbseqgItR7sa2b0IBQEOgyXe361qLLHU+gwAldF7CDD5WtykwoC+fxvgvFfIhtjUrygxL75Z9LQo2u+nOxvBPjxfEBheqjHXH6jznODcZ36zWefR5pqdwxrEAZMRRi+wd+idTilQUb13pV9/lGcfh51J/buyCFcrYPT7b0nml64P3hs/AN/8GovEuFIGLzHiZKgPigB9YfOkwtkGJjYnVAYv4I2+nUvbWKZ7ei3Tt2133L7a7zGZ8ZZh+CDaal5ywdRioNz+Vo65jstQLW4Ksx2sO+qISYG4v2si9vyvXI5XzgdE5AeT0SjRdr2qFBB1s/BQ8ir08l1WVBozjY8bHHo=
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

Signed-off-by: Jane Chu <jane.chu@oracle.com>
Co-developed-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Matthew Wilcox <willy@infradead.org>
---
 mm/filemap.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 58eb9d240643..0f3ada4d8cff 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2483,6 +2483,8 @@ static void filemap_get_read_batch(struct address_space *mapping,
 
 		if (!folio_batch_add(fbatch, folio))
 			break;
+		if (folio_has_hwpoisoned_page(folio))
+			break;
 		if (!folio_test_uptodate(folio))
 			break;
 		if (folio_test_readahead(folio))
@@ -2749,6 +2751,29 @@ static inline bool pos_same_folio(loff_t pos1, loff_t pos2, struct folio *folio)
 	return (pos1 >> shift == pos2 >> shift);
 }
 
+static size_t adjust_range_hwpoison(const struct folio *folio, size_t offset,
+		size_t bytes)
+{
+	const struct page *page = folio_page(folio, offset / PAGE_SIZE);
+	size_t safe_bytes;
+
+	if (!folio_has_hwpoisoned_page(folio))
+		return bytes;
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
@@ -2862,14 +2887,18 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 			if (writably_mapped)
 				flush_dcache_folio(folio);
 
-			copied = copy_folio_to_iter(folio, offset, bytes, iter);
+			copied = adjust_range_hwpoison(folio, offset, bytes);
+			if (copied < bytes)
+				error = -EIO;
+			copied = copy_folio_to_iter(folio, offset, copied, iter);
 
 			already_read += copied;
 			iocb->ki_pos += copied;
 			last_pos = iocb->ki_pos;
 
 			if (copied < bytes) {
-				error = -EFAULT;
+				if (!error)
+					error = -EFAULT;
 				break;
 			}
 		}
-- 
2.47.3


