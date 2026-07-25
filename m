Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90A51C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 16:01:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 680C56B00AA; Sat, 25 Jul 2026 12:01:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 631A46B00AB; Sat, 25 Jul 2026 12:01:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5471B6B00AC; Sat, 25 Jul 2026 12:01:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 22D606B00AA
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 12:01:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E89D140314
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:01:11 +0000 (UTC)
X-FDA: 85027763142.23.48D0581
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id D7DA1C000B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:01:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="r/gDQrZr";
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784995269;
	b=Fdee6RhNMaQESlcqZbLLNO1gpqfpEjWTwfQ8yoOCrd8HUKDLUBAvOzEtVJP417Ro6+8hph
	KzrfQfuMXXLWOO9qJBfjJr0ZNDtUjxsO0f3NMOEk/mzTOwNwGhD66RMZqjfTFzAj262He8
	Js++9CKgYs7hrnvrgguL3+oMOwOWYFw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="r/gDQrZr";
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784995269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xPkMEYO9mjH/Ia6rRtWcuKRSGQrQUxUN5Ze4piyRhiI=;
	b=l6x+tEPwfrSukOws9CRPkyM/j+Gk36yh/lpc8MxeSqzDdXAUXQpn+U1AU7HDyMx13Lzhvx
	IazkTiPbakNdofdNW1qJ5qxcq73FeYb2tuBN4DyHNY83Oyfvjs+YEagVD3KS2yPobFL5Ve
	4Ap5N8qGWF1Hu3dWjbqzmxnj64w7A8c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=xPkMEYO9mjH/Ia6rRtWcuKRSGQrQUxUN5Ze4piyRhiI=; b=r/gDQrZreIDyytDBd3FdRh/3yp
	p2ZpEovIwzfbFdOpy/79/s6Jque7baGRO8LSJkEw+mRoDlyCc2wNVacuL26Nb1mts+i0mJ5YwkEfN
	PHN6+Q4wufjwsZjXxqILPbvgrlZRqAYFP1nCs8oZCo+8PM3kDeDqzeRvolqC4hvBlQRUkDxMSNL57
	x7rys1AVlpIKsG/1B5ZQtqZNQ1x/rMqO5Xx52B6Nw9CyunydfeH8vPyLAC2J/cRtaMnnAnd+js2h1
	ySST+Muii3q81M1A16Fw6JbwSCTjKVqvVTbn84YJPxEjLAIWJEqc5GJp04MfygcQUXQvWSop1Oc1X
	WkMDl5Sg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnens-00000006X7e-11Fr;
	Sat, 25 Jul 2026 16:00:44 +0000
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
Subject: [PATCH v5 08/12] filemap: Add hwpoison handling to filemap_read()
Date: Sat, 25 Jul 2026 17:00:36 +0100
Message-ID: <20260725160042.1557264-9-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260725160042.1557264-1-willy@infradead.org>
References: <20260725160042.1557264-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u9kk3wxtzkag73itp5zk8wupng7kbiq1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D7DA1C000B
X-Rspam-User: 
X-HE-Tag: 1784995269-541534
X-HE-Meta: U2FsdGVkX19eFaaq4HSUEwuj4FLzGZaQQuCbfHAAqTwDijgb+l+yCGbz+lUY+r8D2AYAw1FBJgwdLKux9kutfpkV2tNaJoVcFl8gE6AUqvm7C07D3MRy3jSduVIuWAGaM++KvD5AKuo9w2DrCC/LaOx/H//WbkDnYtG79HtxuOUz80UzVVb7mIYx7NP+6GaCSZibVOtxg6hRLaq9BJIbepAsXcKajihdMVdtVwcBFzWhpQcxwX10t5EwBFGa6Vo1EiipxsGf1gWvekCvPJ6V6fPU4LC+x/EEAcU1Ty3MTlIVgxrP5R1SLmxdJTqmaVIX2kPIwWDfRi9jG9nIeDwc4+ZDUMzi4bmo9bsBiaEEzlOp764wiZvqFAqdw3S6Re6TOR6ir5t0gkWPyGSFSnTlnOqBVHS6gTWlQooy9CUkrtkv6J/i/p7Ub1KZo6I2nAyPnBivbwO9o4zAXsibYADsPYIhJsYgMQY0NunVqIgNEblVZFNvvzfyrTuMqlOfAHGyvl+bJ65jQKbHYv6ACM5Zt6uZtB5H6iftxNHPMkarLrt2KFSLH/6e1HVsPwPaRpHsTYvmNitLKIO6tvwnz4zBazAfPwMwIQYi66GpuNaV/73voqNOd9tddPL8Fis826Bdw/qLQosa01VxVgYixS2g+ykdLd1nsHWud8fwNG389hKVgkIfrhU1gU/7Camu0+97wfaUYtPXlSSD0YSWU/aYoZospO2hor5mUJTqSXdYKFVdQ+C5mtKtT3c86HBJhriZLC17awu8RCmHcwMnd3LAQNerwEg0R507fOZis9K3Lnmjv7slQFzCZ3cbEQZE9r8CYz7EqeATC8j81y8C8ztayCI8V/Pb5ZrYkGm3wFQ/jJ7ET6XM2l75g/jkVMPmqMI76WfjD9q7cALJu47mWahxY19NPPue12gECdbek09cAOzRUfV+IPJGArxspmU35H7rbzzMomfTajzaMZfNEcM
 kFMxx3jf
 5/zzUPZp8idQUKtb5aMHij3cvPggbpeUvvlUoCxdm6twxOdcvhUNgLmCvdy81ciLujwJqVpRT2045LvY36flc0jqvgy43ogaN8weWi81qznCn+eZpfJJEHm6cK8LNx6TwRbFHkiVH9ruTIFj3ug6HsV8coq+4eXgHVa3LLE/w6OocsZsfIZ9QIVy2aPRM0duY0FNcvxuq+44IZMx/r74/kVxQGviQawKQH7ad5oZ2wf76GnjRX84M7mn5zNk+545PQBONPBjYAlYViWeNdeRGuHYgShFMvCBOHXqCHjmEcavcztEp93L3k0inoTU9jB2yLO5J1Bg1T1YNdBFK7JAjN3zYRbKvtECsanfujydsoIZuknnEssXLCu64s1h0fmJBiBmydPhgWjTB9nVsq9ThoNEVA6uG0EZd3kSjdhU9hYYvPQY=
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


