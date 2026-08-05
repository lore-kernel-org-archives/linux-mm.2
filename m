Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66B95C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 21:06:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E26436B0092; Wed,  5 Aug 2026 17:06:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFE0B6B008A; Wed,  5 Aug 2026 17:06:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D14386B0095; Wed,  5 Aug 2026 17:06:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 81CDD6B008A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 17:06:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF6CC160541
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:06:08 +0000 (UTC)
X-FDA: 85068448416.16.BFB2662
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf31.hostedemail.com (Postfix) with ESMTP id D800520009
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:06:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=CVP0WX+7;
	spf=pass (imf31.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785963967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wPoLwfxpD0/mP+aXVR5LQ+tyRiyYjrC0j5PqOyNKK8s=;
	b=H6AJBsJ5OnB0rVa26xZfplvZzq03KRIIaAyfO6RElcfJmXdFq70eJYqBpVYe8T6KJSkuK4
	jBBviFwf/F0Eh8f/n/XN6QaTwZm8kvKKoMWPR/g+N9Aw4i8kDCjxZpbqOndYWLcwmEOvun
	197z6+jJTAGxRa2YfAcpl8J26BR460s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785963967;
	b=etTCpXneqBLCaKxHYtG9Fr85XFYS7WFSM0upHGxFp9FImePVjXBeQpbwBgVr9PA8w3i4pc
	8tYZqxEjr4CrQWHfoZFHRovr553G/i1a53+Yhtk/oeGc5KVSH3v5Ts8V0s66iMtiwhTLX+
	MN0R2bZMPOCmoCXGWmiE7RxVgRaUtz0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=CVP0WX+7;
	spf=pass (imf31.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=wPoLwfxpD0/mP+aXVR5LQ+tyRiyYjrC0j5PqOyNKK8s=; b=CVP0WX+74gl0CBJ2T+7ghCelPf
	r4pNbtymw2yD+cxVrOwJJDeFsgQXaus4rSref8c66kFDGvlUSVr8kuiDPyGYb0H5HHMI0RMy2KbBF
	ePDeFLCUuv1g2cUKabJAjddaHQlti6n2qqyI/o8JG196tTBt2shzQH8btLdjDXlc8R5Rwyth6i7Gf
	X5Z4B6vSssfjZvnobsT1N4WLXLAlhdrkQbxlv844cUHg6lYh1m/sQBDTtJ2HC+PlPGKuL2aR0ZcZR
	stRrgFAPZzlBcaIicAhqK9P4DNPizMjy+Vx8DY5TtbTf+do+KY9W1SwEa+mhBxbW9AdM1kxO0nOiy
	M43pFoYg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrioK-00000004h6P-1oEk;
	Wed, 05 Aug 2026 21:06:00 +0000
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
Subject: [PATCH v9 11/15] filemap: Add hwpoison handling to filemap_read()
Date: Wed,  5 Aug 2026 22:05:51 +0100
Message-ID: <20260805210557.1118966-12-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260805210557.1118966-1-willy@infradead.org>
References: <20260805210557.1118966-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: naewmyxh4zknujktex59f34k7nxripkp
X-Rspamd-Queue-Id: D800520009
X-HE-Tag: 1785963966-717848
X-HE-Meta: U2FsdGVkX1/MZS3+zvqk4ksRNOqWAVzs4syYm6+8kVQV6sxGQrSAuQ0GEOpGo2UY21smHf6IGU/Xyg+Q6/qET76kyET3i3sFufnWex8ioAva2LvbIZj6A/UvPzf7XzxyuETP9RhKpPrwoVoIFMVBsFONoK1RAfTe4u8Xyg8WdkWl61QqRX/dOaPE9N0enJ2H6BXZbMoLsqb4YuvR+xzCTeFRMVjpXU/iVZv34/EBM4ElB+2twsESWHtP9A/4x2FyFtT0Xk+bImei1hd9VtH+GI0bhlDBAWhyYqFRtAiN/SdFBMpM9TSB4ijwIvCs2aj2LgiImV7CMnDMmc2QSpqmqnSu2x9hdZnB/n24Xaaoyrms8DjyM6jRgGQRcdFGf6DWt+Rj/KQCQ6UMnKQ2y8qsjd9TLDg1mXH98hFp2a2GW/VRcvWVmNrUbYqNAE3nHnHiAGmQyH0CmHspMa+op4sQ98l5xxZwh+1B4ZZitQiJDRSmfHZTKMdgpOyNwFpV+LgsvsUTfaiNV0HwEbsD6pK8/5Bk0axIqL3i7XN0UROwV9CLGaIufirWgUu+KuTDmoqV5EYWCkFlmaaVSP/V63rFAOBFpBhEvgQYOH2IJciM6BWgCpmVtw7i/ncppTakWQNWkKvQz9Sv9rudtcSw520vxXA+bwQ95BqbTDqYeIre+FRHEVOUhipGXohRAJROy87gSI7vNNoMRkPTzrSPoWmUykmZUzh9NRFXfsuVmya/moBjKkmZR70EHJKN6AM8yVum0f8eD9zADldL221fK90+RaeUISg+qnscdQfcq1yvJy+Hfd4j5xzATSkB6zZAYR0iOkKaqVn9aBL80fnbvqeSzdF7q4Dy2fkC+b8AJI/AtuE7ltgLAhS6Faqh7asa5gqS0+vpCGDZUNNXPdRZDbH8PnwczcQgI+EwhniE4N9lLvrMt3CJTteda+m0lErPS80NtAWRHgGhBQTMklM1Eoa
 sfuzRSJ9
 Bb31PstwmTMgn+N2YEjqzl3J+A2gzpjUV29i3tiuXAv1F1Vlwjlbo9VmsXFp07KCiSY8SuMqihhaROH5wVvbqnt4d/q4NIiYraLuiBPW9+D/QburV98qkrwR3VW4VfzVnZtXHXCq7+RuYYqxo1nsBZBsbEG2af4ytzSxertQzr8SsPVKl6VLTmxF0dy1IpW1w5Emf0hfzdWc2MuL3HceIUV2Li4M0NV6sz+LbOl3lmmVmiaT6AqOlSkl7c1QRpGXNYCJbPTufL6Lk4zwLTNyMCuKkIQIe8NF8htMreMpRW1zuQte58hd7qpJ3ViveykZgKD1wpJZrnGzeOtUqNeXwgSaqqhGwqxmu7DW3qYvSh6rh19gQ8mZKLNlbSTiJ9Uz3BbJmSCrwZ7MajyKyeH3zd+FZBw==
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
index ec604cee8d22..639c0a772856 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1088,8 +1088,6 @@ void hugetlb_register_node(struct node *node);
 void hugetlb_unregister_node(struct node *node);
 #endif
 
-bool hugetlb_page_hwpoison(const struct folio *folio, const struct page *page);
-
 static inline unsigned long huge_page_mask_align(struct file *file)
 {
 	return PAGE_MASK & ~huge_page_mask(hstate_file(file));
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 5d01e5b28d0f..f75d66c42509 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1095,6 +1095,7 @@ static inline bool PageHuge(const struct page *page)
 	return folio_test_hugetlb(page_folio(page));
 }
 
+bool hugetlb_page_hwpoison(const struct folio *folio, const struct page *page);
 bool hugetlb_unref_page_hwpoison(const struct page *page);
 
 /*
@@ -1116,6 +1117,16 @@ static inline bool is_page_hwpoison(const struct page *page)
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


