Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DFDFC54EFC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 18:13:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 511966B0099; Mon, 27 Jul 2026 14:13:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49B1F6B009B; Mon, 27 Jul 2026 14:13:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C6846B009D; Mon, 27 Jul 2026 14:13:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0194F6B0099
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:13:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7FC04160171
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:13:22 +0000 (UTC)
X-FDA: 85035353844.06.214F7C3
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id F13994000D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:13:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=L1Nqw1rx;
	spf=pass (imf11.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785176000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xPkMEYO9mjH/Ia6rRtWcuKRSGQrQUxUN5Ze4piyRhiI=;
	b=j+00XHhQFzN2dFP+JKLwJF98Lo2LMbbohFMCa9w6bBqBCwsn+Y7VFx8rgCIIDM4pOyJPLi
	5ns42xptBi5UY4GMzKAJAEkjLwAcmTcfbX7Buh0VV1jCHD6tL3wgtffZAGi+2tEcA0pnyC
	D0MXepaYdU79fddLIKZbp/tUkEq87BI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785176000;
	b=xDWzO67yS8jF7iZOgsnZnYV1hFBfN/TKQqAA8RSuFWQa46l0fHHmxM1U+F7CpXuu6bhrrx
	IPx3+gR9E0KtqH2FS/tzCRYafRu4KeQUIP1JNMjIee29VbjuGo/tpeqKbJrTfgnMzMhVwO
	o2ojvWitonTLZIy9XGPCgqYLDM6FnbI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=L1Nqw1rx;
	spf=pass (imf11.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=xPkMEYO9mjH/Ia6rRtWcuKRSGQrQUxUN5Ze4piyRhiI=; b=L1Nqw1rxqQyjj0xAVqNl1RwtwY
	DG2KSR0EC8Dd7SteWpX/cZYbjTbtBSfRy2+8WrzsjjJFPf11irByaegrgsvGgIDAEOQEx/QfTcbXZ
	/RJpqAYODJxuPNuKk7gILzVrleqEbOmWOl5/vXxnTA58hX6kSD4PV0SPmIZh5r1r0reexVgnM6AVg
	JPsnAHRgDdviEnyJsgidw7BDq1mZpxToG8PFxwrN/StwuqLpgLFgiokOc54x7I6Cwo4jGBMimXhyA
	+mn9VyxAuxwxPncSqfqPAdJ7WOYM/msxvObwSfik+/24fvs3ZQ0ju81K1wEZa/L+51LIpASHqCQFj
	VMWFYHVA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woPpA-0000000BD7c-2ikx;
	Mon, 27 Jul 2026 18:13:12 +0000
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
	Jiaqi Yan <jiaqiyan@google.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 08/12] filemap: Add hwpoison handling to filemap_read()
Date: Mon, 27 Jul 2026 19:13:04 +0100
Message-ID: <20260727181310.2671972-9-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260727181310.2671972-1-willy@infradead.org>
References: <20260727181310.2671972-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F13994000D
X-Stat-Signature: frssrf9w46wqe9m6gbf591bmofj91ki1
X-Rspam-User: 
X-HE-Tag: 1785176000-768727
X-HE-Meta: U2FsdGVkX1/qrEUyL61J+/KRxFD1mFnK4/lmsQfSniCjfLT4kU+LWM0++3ephdG4MC40PYifrt4saYWIPViLzZdol0Yc+tBpRR6Bwq7AkwXD1WxQz4eLFGsoscsGxct6NBiHzModbLkge3wGu6v6grHlUmASD+ePJP8Rbi4pvO4cMY3Ip4D+dNAaIfmLM1ZwQg9XQlih8Zvw8hqFS9t8b2qb324OjLm9bDyKBnYITpKYHpo5NuCFQkvTgtZPtkkyfODEj8gN2Mm6hd4DBv5QAErFsTmE6N6mW/VVPeCWlifofEiLPM4G846JFLWCHQxrdCJhSfE+3qxFcz2mtlRHF4Spj/LPzmuI+6Mg3CJeZlzG1KqMgSFFSR2UbA/8HfJsrNcmhSiENpS1yW1Vs1Y4spKlKeQ0pFSNKA2wejQH1cHfnn/CyfV9GwJEWERk5qRk6lh/06oPB+LkMwXlVlJmMVuSMvU6adovbpz4cDywnylAIegmc9ba3z+EWQEYW7oYZLfX+/a/k57WcJmLVBkJt+H8XCjulryWnl9+LuLQDSE7fP7G9PxS32vR41kiSHMemj6ZJ9RYFcxLwTMFuAZaB3lipnJV6hTY3Dn9IG4Sj/FaDDyz6UJS94g0HzWT9XIKTvUWMxUn0nE7iXCdGgUJMcDJ6xgqU+lpLj/vm+/ufX4A6JhOjGHblpErLdqV4HBD4y5p522lLCL4/Ymdwo/NhICvl7VezXosnENdVaY3gwysfkqBrs2hrnARk3vhK0s0C9fUEQmmCOTTImWJhl8Jx7ZVDMDiNYJsnvazdRhPXCxboxpY2spcTc3qfkUnx1hDaSNKHgCYY5idseJ9fA6fscoB2jy5xGq9HAOt317ipEKFw1ZYBfZnW/NVcEdF1Y0nGGmgl4z5t/eSPIcNuSejrqUM67pYKQ6awDaRNy26rZHAQdwUEyMTFb34uvY91gCVQvdx+XbG71gsgAyVmDe
 jSOqLbm5
 rx5r64j8WMsa3A0ykZfA/TsSsBT9GsFMm4vnjeEGj7I3H3F6+xSV8rbJB2A/zEiWYElSej0jCVjNdsAbiNw7i1Ah0Us3GAybAQAFvrwKCAuk9bWab9J8gT97uiYuWF8rjKohpDVVus+zbPpaosHTI66x9jtTIZBOgxV/PVNvjVh9X51S0nR4UryCJkW9FYxsyWxqoeWN9rhgSi9ZAIAddvI76S6OKSE0ufA6zMd1SNNv62Eou5Q94neIOeSEbTvkJsMltViY/Jt0Oj6/zoz+K/e8Hn1eCeiWT4NKrgekPUMhVw19A4lK86dcs8D8NsLvduj4u0LcBtXfdK1aRrWYWmFTLn4z0MKCen8F5sMQGI6zFOvavKZMUJlyf56eMcjq1K+cK7qeDlyLPdA+ldvtPIhpcpA==
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
 include/linux/hugetlb.h    |  2 --
 include/linux/page-flags.h | 11 +++++++++++
 mm/filemap.c               | 33 +++++++++++++++++++++++++++++++--
 3 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 325f0404a7eb..1878642e75ec 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1069,8 +1069,6 @@ void hugetlb_register_node(struct node *node);
 void hugetlb_unregister_node(struct node *node);
 #endif
 
-bool hugetlb_page_hwpoison(const struct folio *folio, const struct page *page);
-
 static inline unsigned long huge_page_mask_align(struct file *file)
 {
 	return PAGE_MASK & ~huge_page_mask(hstate_file(file));
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index ee026ba9b0b5..07cc7854b2de 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1094,6 +1094,7 @@ static inline bool PageHuge(const struct page *page)
 	return folio_test_hugetlb(page_folio(page));
 }
 
+bool hugetlb_page_hwpoison(const struct folio *folio, const struct page *page);
 bool hugetlb_unref_page_hwpoison(const struct page *page);
 
 /*
@@ -1115,6 +1116,16 @@ static inline bool is_page_hwpoison(const struct page *page)
 	return PageHWPoison(page);
 }
 
+static inline bool is_ref_page_hwpoison(const struct folio *folio,
+		const struct page *page)
+{
+	if (PageHWPoison(page))
+		return true;
+	if (folio_test_hugetlb(folio))
+		return hugetlb_page_hwpoison(folio, page);
+	return false;
+}
+
 static inline bool folio_has_hwpoisoned_page(const struct folio *folio)
 {
 	return PageHWPoison(&folio->page) ||
diff --git a/mm/filemap.c b/mm/filemap.c
index 58eb9d240643..26a5f18121f9 100644
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
+	if (is_ref_page_hwpoison(folio, page))
+		return 0;
+
+	/* Safe to read the remaining bytes in this page. */
+	safe_bytes = PAGE_SIZE - (offset % PAGE_SIZE);
+	page++;
+
+	/* Check each remaining page as long as we are not done yet. */
+	for (; safe_bytes < bytes; safe_bytes += PAGE_SIZE, page++)
+		if (is_ref_page_hwpoison(folio, page))
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


