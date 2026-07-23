Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77C36C531D2
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 14:31:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFD936B009E; Thu, 23 Jul 2026 10:31:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED5E16B009F; Thu, 23 Jul 2026 10:31:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEB586B00A0; Thu, 23 Jul 2026 10:31:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B28446B009E
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:31:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 43091A11DC
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:31:07 +0000 (UTC)
X-FDA: 85020278574.09.2BB029F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6948F40004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:31:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=X7AVy4yI;
	spf=pass (imf11.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784817065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jYJQliqoe5FXAAEp+LNJ75n90/jM8Bh37f1cAqWc1do=;
	b=InvmUV2njgzGJSNd6n28zZh+n9KC89h87u/gOvregaGTkFOoX7XtyCUYm0BArIpxJhOrgv
	bB9e7UNAM7b2fB0IAn/bX+J6zJHrXpiz2Jf5HNH5uJsvJlxiR5Dv1ADK/icxVXOA2tNOjt
	hCvosAJz8oONhRT1w71D1o6R64j9cFY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=X7AVy4yI;
	spf=pass (imf11.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784817065;
	b=vFDuuoYrEtHOeiWtfELEmMf7ClHN1f6yg74A1J/L5a76Gt5U5H+/2IlefjtDts9h/65qgk
	vDUrz3LRYe0RFMbcXnYYs9kijjOcUoP+3+1FGCFby04O6bpkn2fFA43gSKYpMIFp5yONfG
	PxTlA0qeT5q5hep/4KLkqlp6Qzu8wh0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=jYJQliqoe5FXAAEp+LNJ75n90/jM8Bh37f1cAqWc1do=; b=X7AVy4yIYbVX5/Su/4Nxj8YDd4
	7661m6OenYvx/qBG0vqckmW9Y0ekJ6rvhnUH5iVOfwq3meCGxiWwIHtiT+X83q6Ubr1aATA0AGpui
	Mp8EwFtsmXtfXmcIWaRJYH2fNs3mK/z1hOaZHXhG67htw+uTA7EIyLaEtNOFrUFvWqlwSjquJ4VoV
	2mOpQYSv1rw0bfNuluxtbcaa6a9QpwgPWoYZSQnV3fKGcy5xs9wgeN17XGQ3FohmiDvotY5VGjGhq
	ZEQ8aDE6ZVw27rgrPvagczGj+JJPEazKXA/meZq+N42U3oImLZgzfUUpPlYN3tiUl5qSGe4ED/XTE
	X2dooNkw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmuRZ-00000000ji7-1tuQ;
	Thu, 23 Jul 2026 14:30:37 +0000
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
Subject: [PATCH v4 10/14] filemap: Add hwpoison handling to filemap_read()
Date: Thu, 23 Jul 2026 15:30:27 +0100
Message-ID: <20260723143034.175661-11-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260723143034.175661-1-willy@infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6948F40004
X-Stat-Signature: x5yd3er5emh5a77dpoybuf4sy9cxxsur
X-HE-Tag: 1784817065-297410
X-HE-Meta: U2FsdGVkX1/7JVsU3mlBJlYnFkmbASvDXd2YnT23mR6nbiypjKUwlfZr3qPjzntU8qsJ0KS2ts7wXUMHbHQT+5DVBBb7CHIh79ZFp/JxmGeA+MS3qyNuX825g9Loo3dpbjm10UfpICXlpwRcjYXHnJXAWcGhJ+7vMu8GLwbg/iHGxyImPZScV3uoabRFo8djFEtH3tKF9D5yalw7YmL/sL/4YCoDnAe+JEeHuTPF3jraBbqVzlvMfKckDSToMCLK9GADZyIq3T2XObvqe504dYkSdSqWKGb14HX0ZBzVhT1+wQYzXr489vlD4dl3db/EncHNvN5EotC9Pa/TqOdrBfliK0kqEd4UBPT/PJLCNlWxiV8/KnYAjcg/m31BTGD9nQGJYHad+Ve83MWuclzmvwPzMWM8uaB2vJQZm0MSxxSz9+qcn2r8mJPJyWZmNd06LMuEWne91N/ZrssAIcnRdygu8VaGPP96zhlhlPIzpPodsskeO8Ix/CuxKLUYR28VJRhTGd213LHerlTqBp7m0n2M1RcYkDInlVHDf5ZFxyFaLMrzMpKQboHUYv+2pJ9lJ5q8R9ITQweAG+L45K2e2LJ99FQAdEice7IEN/qryNk9N4oTc+jXDy78kOU+URWShj0qP4VmA6H8oDA4xxcvLqOrvGgouVwyv962tGA6g6zb/sp5eSn228FQy+Ey360xJD6nanozYd7YejFVuLCzAVItxJzDSTU8TQVyIh+Rfj7woIiBiFC+gzlB5N1pTLrERla+9D/g0WK6HuQxepOAHyCyZwdCS1ACzYFxASUsvyOT/Cqh7XilUJZgOHNULBDJOSiDtq4/yTVjR8xCcGsuDM22rbONCko3ww1dK59EOu0n6YEgJKWb1VGkka9KkVSGMMmouNuMnwuxtvaoJp0LxwkqdcXCkQVEL+e1O0XPdBKwgdurfkxcUEw5M6qDMml0D6C4dU0r5nj/XLMnApu
 KsAWLNUc
 sOWc+07g3P3Oie4mJKE34EVz1xH2uceKu339ZA8r4zcXEy1KG7tYdV6UfDmga+xBEMp5yrURQMu6dsW2A51joVx8h4/unSpWoGwJc8CvuviERc9fU4VdjD2YF4sPle3oENjpA4uNBseo1G64EULwoAtbhqknEfxHLgLyO4EnoziQTImnUSh2sSnwb/P4428f4IphyCBEt5hoCXDedhtjY6d7Fh56YZaJ2n0AM+r1AxXLWnumbc20pajpyhvQp6Oc1DTknj4b5z3NxGqGDNRbdPtoanbw+HcakgOaayIgh071Sn01sVfIN3VA1vXyh2jIVXoD2nJra2MUO/TTWSw+yJlfoAlde/6tvn7AtyANW7rCR+txIqcKiIS6nBQxdRnwEoL9ZFIJot5m4rMAN3OM23M2H3Q==
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
index 9cde74320e48..b146c5228741 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1090,6 +1090,7 @@ static inline bool PageHuge(const struct page *page)
 	return folio_test_hugetlb(page_folio(page));
 }
 
+bool hugetlb_page_hwpoison(const struct folio *folio, const struct page *page);
 bool hugetlb_unref_page_hwpoison(const struct page *page);
 
 /*
@@ -1111,6 +1112,16 @@ static inline bool is_page_hwpoison(const struct page *page)
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


