Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2677BCD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 21:06:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 581046B008A; Mon,  8 Jun 2026 17:06:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 558A66B0092; Mon,  8 Jun 2026 17:06:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46EE36B0093; Mon,  8 Jun 2026 17:06:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1FA796B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:06:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DC7271C1230
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:06:24 +0000 (UTC)
X-FDA: 84857978688.13.9766EEB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id 646AEC000F
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:06:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OMslnKvm;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf28.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780952783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nIKZ5rJR78Kn2rpf1TUpOelTrfrESbwwBnKGcUB/zAA=;
	b=Tgul0x/ROLdFy2H5DLo448XTyPVUH/ST4rw58xbT6sfdAzwX0phMjMPH2+krb+mBihkJcM
	BaMS+mU7U5nQxFs7WEEI8kZn5EJmtxEBJKcR4CiVECNQUKLgHnA/eGbc16vH9wyxrg8jME
	KEB1jEXkzTIXt/H2uNXrKs4n2hqrKmo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OMslnKvm;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf28.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780952783;
	b=bgzK0coDsYo7Ra3HDq7lASe1yLtO6vnXkFdtZfT98v4n/nkEDEo/+ku+9kvo6Dy97V2OAm
	ReiA9uebhxXnGvFNurg/yBtQ4WnuPHj1urAL00drWWH6saM37GnoFnXrZgHBJsMM3rYrFn
	UWv9PIL2KNQ32Gi1tJOVQ31maufpSRQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=nIKZ5rJR78Kn2rpf1TUpOelTrfrESbwwBnKGcUB/zAA=; b=OMslnKvmAjDoKlhg6em2dj99WB
	AJXmAgy+mGNeh2s7JVGXQvRFFCHQFMXXWWYH8sU/FeR/uHsl4L36Q7ZYCIs8g0etBqKBYcC+vx8uC
	PdwTVUuTCZRIfnKw0HMeTvQFrcYeaXrpiqKE6aepLDP87VqZDY1WLRGdFNTvFNnvDF2sqMRKDYK+J
	xQMPQzjy539OKdwdHNTRo6U5dH1NI9V9CwRl9QwLhJkff2+uw6tKQ3meIt3ybwSWPRfLnfaVDxgz6
	um5VWIY3BhkaqpQX3NPuhTVV0EbFLM6k8kvcUGJtrifaxj322jiGDKzLMbCPSkOhVtTAklRh2nE5K
	lFQWOvVw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWhAq-0000000EQBK-2RU9;
	Mon, 08 Jun 2026 21:06:20 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 3/6] ntfs: Use zero_user_segment() in handle_bounds_compressed_page()
Date: Mon,  8 Jun 2026 22:06:13 +0100
Message-ID: <20260608210618.3437216-4-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260608210618.3437216-1-willy@infradead.org>
References: <20260608210618.3437216-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 646AEC000F
X-Rspam-User: 
X-Stat-Signature: 7kdm9hjd7yniiyu5myhztsr6jzsxifkc
X-Rspamd-Server: rspam09
X-HE-Tag: 1780952782-461043
X-HE-Meta: U2FsdGVkX1/GGFqOuJqZpVi+7j3SF9eWf2en3yRxCn08VpC6lczlupWvDc09we7SWE0O0yuZFvxrMmtr0Yhoh3sWllR/M8NKdtnBnsFW1QHvD20QMoKTm7oGSOfYsHb7bdb3sHMAvFPys4e6gyihpRoN4fl15n3RKbff/6Cwvw/UJ5WEY44i69lM+VZLxaDO4ob0oIudVAps49sl6a9grnppb9Ije6S5Z9GQHvYzlE07Tsqt/SCqrCADw5rmp4MicX01tMlf1DdEzrskB68IqDKzOtofZ9AlxL85V+G7zuSBTs8fc9UKC7wUBMnQWgzmV03f6Y0JdKNDxo1zV+SnhdOmZk0kUNMgA4DiV/UBJbhAfs8SXSBIl9jsvZ7D9/4WXdHiGAkZ5q4QXRqK+xEaot9FmQydlqRraLzgD2G6ZIFSne4F6n9/KHLMACGb1nss6FmLSZJ5dHyCFl268XBHlT4zSZNClZ2IyZ+Q+/VNgc7+6iL0nqnipmUZz3Ul3lOQTDF0JZ64ERtp1C9lhV7ToeIcwB0M6MP0tjLZ+CWIBdUHUqx4aEl+mMfOv6r/SBLPjIWe6N7xEDH3AaaPvLkiqGkBP0SISQBlhIqGJZ38aZe9/5VuuanwezdaMXbkp75EmAV6p/GykXRXFAH9LerGMDnlzoGM6QDNGxvYSqDTUIT8obfQtel+0GDOKJkt6PHIiGzJD0jpL43J0oUME2Ke/2UlQSel5HB0yVVtEy1PC0e3d1dBP5LM4d98HCOtMsYbclRK5juzQ9ZBG4zj/yc5dnWN6hD2rvJNl35wD49g66OwZ6c8ZPlRCSIc1dIByDNU3nkXCNzu5p9NZqjpQc/3nJ8NUGiMjnfrwl33M8S/FaA6JgI0wT1IKBNoPMAVoI1SOp8NjFfH3vYy8t7VQo6kOdswte/5n8SjNqk+veOqNi+ia2EzCBf4sSOCNME+hd7/XzmLzGAoBsGIITeE1r3
 3mYCH8o0
 Mx1M8vwAJ17my5kfW2sflMklTrXJeDb9Q2Wps4FWSP5ogWWbkF/EfoPUKNOhTcEufq9xZMR9XzOTL20bjNHfKzBVKX0PG8aihVU6m0nb33/Lbki8AaEo6ZwuqDmFfxL6NCMkoi0RmIBsSDC+8sdChXh+3exj0qeKDlDHPWh6WzZ40VGYl13Nx2vcy2DE+zRNUueA5HZgkZFJy5wXDXl5M13A71uO0DUMqOvhJVjRM00eT+84ILFo8DEDUONI44nvqH6L41ovHvoDarO7Putd6ad1/GDDHoqHwz9RTQint8a/ndhx4WS9heuSbr8fIvrRAS09t2u0nRG1KofnKufEBsbuZrQ4EETYhCURHlzJ7awY+qJQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This fixes handle_bounds_compressed_page() on highmem memory
as page_address() does not work on memory which has been kmap_local(),
only on kmap() memory.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ntfs/compress.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
index b279f38636d6..89067fecf5a0 100644
--- a/fs/ntfs/compress.c
+++ b/fs/ntfs/compress.c
@@ -108,16 +108,16 @@ static inline void handle_bounds_compressed_page(struct page *page,
 	loff_t pos = page_offset(page);
 
 	if ((pos >= initialized_size) && (initialized_size < i_size)) {
-		u8 *kp = page_address(page);
-		unsigned int kp_ofs;
+		size_t offset;
 
 		ntfs_debug("Zeroing page region outside initialized size.");
-		if (pos >= initialized_size) {
-			clear_page(kp);
-			return;
-		}
-		kp_ofs = initialized_size & ~PAGE_MASK;
-		memset(kp + kp_ofs, 0, PAGE_SIZE - kp_ofs);
+		if (pos >= initialized_size)
+			offset = 0;
+		else
+			offset = offset_in_page(initialized_size);
+		zero_user_segment(page, offset, PAGE_SIZE);
+	} else {
+		flush_dcache_page(page);
 	}
 }
 
@@ -222,7 +222,6 @@ static int ntfs_decompress(struct page *dest_pages[], int completed_pages[],
 				 */
 				handle_bounds_compressed_page(dp, i_size,
 						initialized_size);
-				flush_dcache_page(dp);
 				kunmap_local(page_address(dp));
 				SetPageUptodate(dp);
 				unlock_page(dp);
@@ -758,7 +757,6 @@ int ntfs_read_compressed_block(struct folio *folio)
 				 */
 				handle_bounds_compressed_page(page, i_size,
 						initialized_size);
-				flush_dcache_page(page);
 				kunmap_local(page_address(page));
 				SetPageUptodate(page);
 				unlock_page(page);
-- 
2.47.3


