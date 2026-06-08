Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82290CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 21:06:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0C526B0092; Mon,  8 Jun 2026 17:06:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D96056B0095; Mon,  8 Jun 2026 17:06:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C105A6B0096; Mon,  8 Jun 2026 17:06:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A873D6B0092
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:06:26 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6EC9D1402FA
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:06:26 +0000 (UTC)
X-FDA: 84857978772.27.843D818
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id A85291C0009
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:06:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XDm86ncH;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf18.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780952784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bpCN61J5lII0MiD6qqFT91HWJ8XVANmnLIHdvgttKXk=;
	b=LiDd/xdK2isXWTuIjK7Av6A40935ZTZMZsHSthXMuxjr05ASgNSaYsu2M7S2FRSsZ4Qyyf
	MyroD9zlUv2XLwzh7fJTsqfr27OqbSos+fuKo5k2oO5rA/KWryh6KZq7Wia+tHHm+TyX+7
	twzB1LoJnVxlC0y4k63AuNY06mOKK3A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XDm86ncH;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf18.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780952784;
	b=13BzyQsUb3o+Q7n7ng59CXCRfV9+XDfTQdZOl+SZ6Cl+qnBW3n1cXrK0u7zzVojBiLbGdI
	Q5y91wbKdHCHQmuPwxn8oyEByO9GJoC9tZKvcGjZBoVxJEk6XswyO2i21ke9b1sllkWQZa
	PhwT8eDDP3D62DqCkWEym+Z52jvnBUg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=bpCN61J5lII0MiD6qqFT91HWJ8XVANmnLIHdvgttKXk=; b=XDm86ncHSIbY6RyiBvgtOYzEVk
	uMIuqwiMquT4N/f2w/+XRUoCL2CIn4o/kGQ49Itu0h+JdBFb5/zhnUf+moTEoVn6JbnBxorZYn+Kq
	SIhrFbn+4klySjlNuLrmw5uUTfzeMIoonDNH9qok68CHCVzZOM8UOSP4DUH8ohF77WLRe1kIpVumb
	w2y0Xoc5uFQZuLRFzvs9luc5GJKTEggYLy/aFSsLlLL9hqwSymi/chK49qJ1hRjmTVqQyUFuOpHAp
	Ua4qp+U9rg62AdNdk1fln050nTxnWF6dCX8apYzL9tpfdurCKIJFBWJYPw5QdPqDpDWlfDgKpIn8V
	3IJHK/Ag==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWhAq-0000000EQBA-1FXn;
	Mon, 08 Jun 2026 21:06:20 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 1/6] ntfs: Inline zero_partial_compressed_page()
Date: Mon,  8 Jun 2026 22:06:11 +0100
Message-ID: <20260608210618.3437216-2-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260608210618.3437216-1-willy@infradead.org>
References: <20260608210618.3437216-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A85291C0009
X-Stat-Signature: igtz3n4uwtqerjfg4px4dyzsqf5upo7y
X-HE-Tag: 1780952784-40913
X-HE-Meta: U2FsdGVkX19M/s0DAUEHfgJLfTHYJumTbL3kJbkBqkvJ0ZqDRo6QhS6UIIXvF1nDsBHS3efjUyPqTzGeKXvQBi11R8c7fM5z1PH6G0ZQSbrqd3plYUuBWyz4ZPUD6Bd8H30FXYb3j5QxoNbigeyjKiy/kiaGk42Vg8pTcI2gomi0iVA0yjIXx06u9ZNm73dHi3a7eScG9lnHHg1DJf9OU8qynnHak1lXaMkCFmidXxjkkIv6p0533DzcsvdAKQ6m3jtVuK5KY3k27GyGMhm5dsVH7zn/PjhszT8NPYR4ZtHfQ1eHALlihdxD8tJXWaUuhjE34er1bwULELoEBZ6qjHAto6xWfUKZqFpzD8tfWwz8Vf1OtKTZlBYFQ5IwDcylO25V+nsaza7hY3p9QfSCGQpXdh/D0hHbVV6UPj45sv/H+nR/iesHWHvmHeA6eI/pGPtiEDYghvb5E5ZyyEgsYnhOpCwZbS11s+dQA3FO9GdBaBOB2Yp2/UejHcZVjefRUjNIXxf96omlKPhVzPaKqhY2zhOOvfIeDxhFAeVSEScyVv+2egIySkioggenPWxibwcVNFDjwPbt/SXYZESGxXl63mrgak9acNDJoVV4s+bGyL4iph8O1muAADE/CL52JAFf5MmednZc2LbM8e/k+394e/yycWNV8K6i6mEx3JPaf0i6bzZLX28I6AfKkBf6sRsGIKOZcFdcTeJRosHe8dcnGz542qZowg3ClXLYjSk2s+4schYqjO2KTfO1vfGFgFzx4sbwwSFzncvwfxM4iEacbATwehimDCnuZwOz+q0jcyFOrJzARE+VCLVajSsBuor5VG6YQf5+hiZufakOClz9kugi0rSC9xsrEQQfK3/ufzONiYZtM4hmLq1VOG97NILtg4r57tTb32MGoutxN/5OkVgER6tfk2CG+rfKFjK7bPQdV90hUWVI6HcEbv7WuDiwxEApZRkZU8iQAlP
 6OPe/VB/
 uqDuTnP3r1TrVVbluYhKe8ra0CaPYZHgZaOuuGZnYC/cwDNItSR/SfmQvSvyrs5S1AmHTkMHI8chM5kcn7PGIORVc+wVmSat62F//+CKzDnKk1pMJYsRcwGDpPABmzFH2I09DqwHLf5oXQAJh+uGbOywLVVvi/QPRLq0WTwsNzq4X54pd+XFoc0bB3DHsANEV0H3ifraUkHNDwm6c3qgz9jDWXlgF9enl8ir9CqKjbwVNm9LoNdunhd+QJ+JSX0xtwJolhFeb8BZOywsPOa8sFaI20WU7QE0fKHOMIM86y6teEhWxcr9NRgPp1Y83XyJj/1y3fkSXJRSkDAW7DCfOy6LwaPo/Eliw3IjV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zero_partial_compressed_page() has one caller and the next commit
will make changes to it that make it inelegant to split across two
functions.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ntfs/compress.c | 34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
index 76bd806b41ed..c904858dff3d 100644
--- a/fs/ntfs/compress.c
+++ b/fs/ntfs/compress.c
@@ -96,26 +96,6 @@ void free_compression_buffers(void)
 	mutex_unlock(&ntfs_cb_lock);
 }
 
-/*
- * zero_partial_compressed_page - zero out of bounds compressed page region
- * @page: page to zero
- * @initialized_size: initialized size of the attribute
- */
-static void zero_partial_compressed_page(struct page *page,
-		const s64 initialized_size)
-{
-	u8 *kp = page_address(page);
-	unsigned int kp_ofs;
-
-	ntfs_debug("Zeroing page region outside initialized size.");
-	if (((s64)page->__folio_index << PAGE_SHIFT) >= initialized_size) {
-		clear_page(kp);
-		return;
-	}
-	kp_ofs = initialized_size & ~PAGE_MASK;
-	memset(kp + kp_ofs, 0, PAGE_SIZE - kp_ofs);
-}
-
 /*
  * handle_bounds_compressed_page - test for&handle out of bounds compressed page
  * @page: page to check and handle
@@ -126,8 +106,18 @@ static inline void handle_bounds_compressed_page(struct page *page,
 		const loff_t i_size, const s64 initialized_size)
 {
 	if ((page->__folio_index >= (initialized_size >> PAGE_SHIFT)) &&
-			(initialized_size < i_size))
-		zero_partial_compressed_page(page, initialized_size);
+			(initialized_size < i_size)) {
+		u8 *kp = page_address(page);
+		unsigned int kp_ofs;
+
+		ntfs_debug("Zeroing page region outside initialized size.");
+		if (((s64)page->__folio_index << PAGE_SHIFT) >= initialized_size) {
+			clear_page(kp);
+			return;
+		}
+		kp_ofs = initialized_size & ~PAGE_MASK;
+		memset(kp + kp_ofs, 0, PAGE_SIZE - kp_ofs);
+	}
 }
 
 /*
-- 
2.47.3


