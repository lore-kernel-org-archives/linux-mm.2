Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F06AC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 18:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99A416B00A9; Thu,  9 Jul 2026 14:48:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 948E76B00AB; Thu,  9 Jul 2026 14:48:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8372A6B00AC; Thu,  9 Jul 2026 14:48:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A6866B00A9
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:48:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F08BA168DC4
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:48:01 +0000 (UTC)
X-FDA: 84970122762.13.5F40E22
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6B6BC20007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:48:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=csWvlU2V;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783622880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hnmCCPOw+FiLEmua87c8Dvtylciuo3AiyETpU9dKhJ4=;
	b=Z4p/d+c5BwmvagE7pBN37GSD67xZjwNeQ4OBbLrjP0rQOtJacQnwM2iHi8PBy308tF2hza
	sMOjs/BDlNcOC2ZUUmLQ5OFBMxAhG3ajWn21Z+ge6vo7u6PQmgVpM/rlM0zYOME29nflqg
	DEZQmU7V02xzVwSMP3+f8yiTk0JJNXw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=csWvlU2V;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783622880;
	b=rr3Iw1at0XeH17B23E2sd2HxrNmQaqMEIvgbjZCQVeUNpvcOCyb4ZMMds+ue7X22jvkgi+
	BwcNiSjIwA8fjQ5bVGfT9e6h66jXcwgLCw0AQHawxfx0XDp513dAeenlghDy8BVKgehJT5
	f/V0HyM+KhuGrc+CtnInPSSMZBNkZ6M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=hnmCCPOw+FiLEmua87c8Dvtylciuo3AiyETpU9dKhJ4=; b=csWvlU2VVhkzDQpFoJPHNv39kP
	Wjnzqoe1nJ7ziaVKYukZRLzzqK8hMvv9dQ7EzlVFHsUapL7Sxw5VBr4bY6pKM7jpTxGvuai0eEuMp
	cwCI0XXkl3ievI+XhcR6+XUXf84RRJMklg98Co5mwIavcg99gLcDhgADTPwU1AM8ZdC+c8oduTMhp
	0Xn82gfQeEnLKSJlgOhnCr6TRCaDLQkjzwGX8GkPBsY/DCde31TPBVgqMK9M1TTjIka2eSGXo0RK2
	B0M1o7FeSvG3N1kCkgU9aQWqz8YcioNWoor4SopQ5FCFybZHsqdIwpkBpGdtv8hNunuvhpKHkEMJr
	wNbvcUIw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whtmh-00000005OhP-0TFr;
	Thu, 09 Jul 2026 18:47:43 +0000
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
Subject: [PATCH v2 08/10] filemap: Add hwpoison handling to filemap_read()
Date: Thu,  9 Jul 2026 19:47:36 +0100
Message-ID: <20260709184740.1286561-9-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260709184740.1286561-1-willy@infradead.org>
References: <20260709184740.1286561-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6B6BC20007
X-Stat-Signature: 34di9k8m6nnm8ksp5zz83rgbs9yhxwk4
X-Rspam-User: 
X-HE-Tag: 1783622880-240158
X-HE-Meta: U2FsdGVkX1/+OkLVnSuYkzCjPe1JSQDTlrnT1i7DSn8R6HmEAJUe4umiecoPKE4uYUAdpniC97q3NDgdphcSdy9qnk7WEjDrxqcZW04fZP5qefcxkC/DxKgp9IpB0bfv6hJkXnU3cLCGnrbSvt87W0mercWxIGym/N5Gdys1OjJZqrdqyrTmbeT6Uz+vFsf+EFcos0+QhlWFgz0p6q2x2idaJweGW7JMXkgow4XckDeWRe8Ti0k/lIU6dExawRY9NLbZUUf91F1ohsViKaxdNcmJ23/fy0NOI2/a14Y1jLnSkfjvSZEq84SNNQOaaP8LZ8oh3i5hYcXgA8FGoL6xbtDE4af3Oc65C1u8n3E5Z2G6YTByxnMym9a1gjwXMyWvxPTMavtOgbGkOh7xCSff3Jh9mto2+SJ2gfKvEu8hvz2LGyysc9gQfkfz3liSN0jutA0S+QZIxgv8Tu2xsidJsX233aUyWF+BGIwVE6jHEzEBwJj2wzmGUxfSdnDmtyxFL4DIJZ7PIToJbZfSvgsxphQtJxaTXqdZ5QkivstbkLMFDyXONxnbtOUXVEqQ96kuhQR6sKxY3NqBfNZPv6WA41W48OWXjyQSzDEXMxPtkFQhMQ85ImeuqZ97r4zPVMwDpSDWVION/iaTxN/L0/lBQLwVzk3+kslMSs3ErKih7OWjEyAzD7ByCnzpk1eYBtUUVJ5bCNmdMHpWmVn3+yUWDcIXqHzS4NSO5GOA8p7GaPehAcCmymxaRl1FJNLAx5wnRo70YDtvLlALwejp7G7Qx42XIfIaNB/U7ybwIdRtofwY8/ERiq8wYbFhMrMQAtSPxfs7frTBMT7PtdCAMNNc3Zw6ku1c+dCLEF7jSA2OPalR8TzyVJX1VH7KliAx6hMJxt1BJOnx+FQ1iTCIR2OPnw/RZLGXOkUH4Mc0ahgRFtaSGuS7w7krSZTDGjFBoxRHdsFv+ROtx+8DW9frCVt
 p/uhNlgx
 xvn8QLRG1qz3/T4Sl9budKT4thspXAU9xxIKAZJ+xJ+B+tNwYytEukUbI0/n4CadlDBnUyd4RYd+houztOZy0Ik6vtwtVqtsgSjT0aSROUVaezdnr0u3Yg1IUARvlgJXv29L58MgbUu4sXmk768D4ePuX4akJ7P2xksdXVZQJb0Bb20mJHiG1YJfdr7Q8VT6o0e6smH8C1CcLxBdg0JpD8/IerUquxEpQTHdB7Cr5gQana1xI8KqJuY2A/xVPxqnKLexroz28JCOPHcOvXLwjgiqBfLQQxOXYnpIRSnPH/qNgx0lypOSPfb1IVs+CfcnZdfZKqsxhL7cnIZgIx9FpikjxwYWELeKLw5lkATwwSXBo/bM4tS9o2jmshk4JEh93yqBrpBZFjRoMik4=
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
 mm/filemap.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 5af62e6abca5..c568d267c803 100644
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
@@ -2862,7 +2887,8 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 			if (writably_mapped)
 				flush_dcache_folio(folio);
 
-			copied = copy_folio_to_iter(folio, offset, bytes, iter);
+			copied = adjust_range_hwpoison(folio, offset, bytes);
+			copied = copy_folio_to_iter(folio, offset, copied, iter);
 
 			already_read += copied;
 			iocb->ki_pos += copied;
-- 
2.47.3


