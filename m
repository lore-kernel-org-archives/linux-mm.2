Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAC63C5516F
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 20:09:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D2906B00A6; Fri, 31 Jul 2026 16:08:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20DDC6B00A7; Fri, 31 Jul 2026 16:08:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D4FF6B00A9; Fri, 31 Jul 2026 16:08:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B61186B00A6
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:08:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 34D6D1A0140
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:35 +0000 (UTC)
X-FDA: 85050159390.01.0BA9948
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id A86DE1A0003
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mIvSiYGz;
	spf=pass (imf19.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785528513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZGdslWmcdmBuF2CV3KyDabUg5qle9Iq8y3ZPorByafI=;
	b=WkQ2CpcnZ0v8BhyOtJQNb1C/X1msmSXxKMY/VBHDdzyR6TH02KaSTrn+Bk7G/vNkiDYifC
	6X7xiF0DFh6lC77lrXv7AzwIMfaZChAJgt7sFcQ5ACOMx3AQai5ivAGZ8iheJcfhwMs5bx
	Nv/P3KwmoSq5G8AXVkKybPawWAonVq0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785528513;
	b=A6Ig63zZK36vsNGwi4DrqcJnSp+7Wbj6Zg1U8uLJ9kOhZh1SfRKwR1yRaljNmCy7QB3st1
	Jj00iX6zjhA+9A0uY+lL8LF/NHtVe4R/Bsj3b4RXmJIMX09z4QmXlGtmjRmQ/oFvSTQ/D0
	AdlcPK/cqDveoZjS7mYNUsmLKm2o+l8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mIvSiYGz;
	spf=pass (imf19.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=ZGdslWmcdmBuF2CV3KyDabUg5qle9Iq8y3ZPorByafI=; b=mIvSiYGzc/1KgUwxIB69+VyDT4
	KudZqpb7R4GPDMlX/N7n5ie/opzyOKvYy9jcbsk7m+OMAfGfiSJjWDYENTYL8FT9n4whydP66qIY7
	ewMWe8srR8EU+0QEtmyNekHh/ETy/jXI6PuEcBxzNVD2oHKIG5gzrYArCm6iFfYXz0VrNA4tL1Q1q
	lHpXJlSApNaA/dzGHYMOeHDbPqRWESrFSdYDzjU9b9pAGTNINbPEKZcriW8o8v+RBkXhoaitzGBgb
	UIySx2DEuyn6NfJBPUm/f/7k0CUbrKRU6QT0x7qnEJFG6APH69fVhBXW26b4iRV2OJtlItHal6CJH
	IkQ2H4Ew==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wptWW-00000002Plx-3miK;
	Fri, 31 Jul 2026 20:08:04 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: [PATCH v8 07/15] hugetlb: Move poison to pages before clearing hugetlb page type
Date: Fri, 31 Jul 2026 21:07:52 +0100
Message-ID: <20260731200802.574821-8-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260731200802.574821-1-willy@infradead.org>
References: <20260731200802.574821-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A86DE1A0003
X-Stat-Signature: su5q36nppg5hgs8sttdceo9wk5xycbod
X-Rspam-User: 
X-HE-Tag: 1785528513-209520
X-HE-Meta: U2FsdGVkX18OWltiDlgEd5Uc1BsxTa//rlZeUvTBvkwXz0zBpbTh1Woz7OARjV2i0FB/mEfji+eD/VIKnw/U0McYb4QVfGtRYPcP6I4jLikFELQVV+CukDRiS2K3O3wMUHpdSgZXZFyJF3i1tZZ5WPoouT2wb0WPBU0khDb01DzvVfitm7XJtbEspXZj5SgZ4pfGX55vdRjg5Lt9uihvqFAjURXHULi2I3mpyAZHvOedsu5S9+ML5/xCqdm5mxbydYRiSojbyaXvFNRR/tHe0u+NEIZ3z4O2QNgpMLzTiqjtQlbHQjzzVKUwseinGC1erpwVRjmPqdAB7JZ78TaNoY1FjZ3YPvm4XA35Z38d+69GfBvxN2vAuAMzuZsXZdB3TrcoPjYcXBwPlxApqgTZ8ajKOri4pptqhzylbe9D+uhhFsquc5+j+UWGVMw0cKnNT0qjCYWAU1IygP6UsIF1AN+kGuc2eSu4AhvYWrWuIwniG51tfxlBploUVTuAcpabDQGnvFK6EESCruOYw2+Vlwq+Tq1Wwq+WmAVZv3pHW6zSCbyXvz6TBvvOgEV54m0pZM5AHjOz33y0nb9RrOTmIS4dPA1FAJUM0iP2SPfh0PT+dIKTL4R6Nv9c/UgvdRckFXJ+4FqZ4pKXOzWnv5io4OH3MnA7xAmjUt/L3ueHPzzKpGQAg71Z07XXbCVmB7Q0XNQft4JRIcPtAhViZoSvXGQlIwj5XAcqftafLesKcNqCt3alwEhetu9VkB5X279xJP6gjXbgKE/wiJ14uR6/oozvDtXH6yMO1YZULQmM99okXLjSrbMAKWQNb4Dd6L58/KPSmhmrxcbFEZTNRuHrRCWU2qekcTZ6jepPy94maYBSA1szEEYpB3Hpv3hbksKAnK/GpXFZw8bLauJsfjvHY41QTOypWNvEj3PYcDpm3XQlW3mNlkcXq0dFnZ0wo3ggY0D+FID2iYGIn1keKd6
 adIfItjh
 17ZRhPbxVa8ZxIzcakRtAOcliolruZDvLITvvdYLSa24gXFXqKrviVN6tnWUCfKD6DcL9ifRRc+ptdAXMoSCWEMtayokt0OjyVIKElN8mJF59NRScYAgYOX/vtnmNeDbctr9MX7+jC6NOczDYCzKSX250pIu4Mnd9aFd34C3Qu9TPNQ8/0XBMtWv4H54ysfV7WLBr1SRRrFuXca2S5boAMZoWOs+rce7lihaT2bW18+qo9eVDOLlHiAlbZhBWhG4PLfOohDRTGHuSWqsAmhK0wXO+XFHiMRU+LskEDvQBRYt81fX9atgBSvB/21p+U8+NGYrzfNgIhOGrY7U3IuwPdIQqCE9SdMy5XTJhiO3DJ8/15OcxbV+Ie+X9/nhPlrO7kIWybRqgexwHVEsKN9WCuQ/1Fnf8fpHPCShS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For is_page_hwpoison() to be reliable, we need to set the hwpoison
flag on each page before clearing the hugetlb flag.  Introduce
folio_clear_hugetlb() to make this easier.  This does not by
itself make is_page_hwpoison() reliable; see subsequent patches.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
---
 mm/hugetlb.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index cc8d98399913..47403d02be88 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1381,6 +1381,18 @@ static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask, int
 }
 #endif
 
+static void folio_clear_hugetlb(struct folio *folio)
+{
+	/*
+	 * Move HWPoison flag to each error page
+	 * which makes any healthy pages reusable.
+	 */
+	if (unlikely(folio_test_hwpoison(folio)))
+		folio_clear_hugetlb_hwpoison(folio);
+
+	__folio_clear_hugetlb(folio);
+}
+
 /*
  * Remove hugetlb folio from lists.
  * If vmemmap exists for the folio, clear the hugetlb flag so that the
@@ -1419,7 +1431,7 @@ void remove_hugetlb_folio(struct hstate *h, struct folio *folio,
 	 * to tail struct pages.
 	 */
 	if (!folio_test_hugetlb_vmemmap_optimized(folio))
-		__folio_clear_hugetlb(folio);
+		folio_clear_hugetlb(folio);
 
 	h->nr_huge_pages--;
 	h->nr_huge_pages_node[nid]--;
@@ -1493,17 +1505,10 @@ static void __update_and_free_hugetlb_folio(struct hstate *h,
 	 */
 	if (folio_test_hugetlb(folio)) {
 		spin_lock_irq(&hugetlb_lock);
-		__folio_clear_hugetlb(folio);
+		folio_clear_hugetlb(folio);
 		spin_unlock_irq(&hugetlb_lock);
 	}
 
-	/*
-	 * Move PageHWPoison flag from head page to the raw error pages,
-	 * which makes any healthy subpages reusable.
-	 */
-	if (unlikely(folio_test_hwpoison(folio)))
-		folio_clear_hugetlb_hwpoison(folio);
-
 	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
 	if (folio_test_hugetlb_cma(folio))
 		hugetlb_cma_free_frozen_folio(folio);
@@ -1595,7 +1600,7 @@ static void bulk_vmemmap_restore_error(struct hstate *h,
 		list_for_each_entry_safe(folio, t_folio, non_hvo_folios, lru) {
 			list_del(&folio->lru);
 			spin_lock_irq(&hugetlb_lock);
-			__folio_clear_hugetlb(folio);
+			folio_clear_hugetlb(folio);
 			spin_unlock_irq(&hugetlb_lock);
 			update_and_free_hugetlb_folio(h, folio, false);
 			cond_resched();
@@ -1620,7 +1625,7 @@ static void bulk_vmemmap_restore_error(struct hstate *h,
 			} else {
 				list_del(&folio->lru);
 				spin_lock_irq(&hugetlb_lock);
-				__folio_clear_hugetlb(folio);
+				folio_clear_hugetlb(folio);
 				spin_unlock_irq(&hugetlb_lock);
 				update_and_free_hugetlb_folio(h, folio, false);
 				cond_resched();
@@ -1653,14 +1658,14 @@ static void update_and_free_pages_bulk(struct hstate *h,
 	 * should only be pages on the non_hvo_folios list.
 	 * Do note that the non_hvo_folios list could be empty.
 	 * Without HVO enabled, ret will be 0 and there is no need to call
-	 * __folio_clear_hugetlb as this was done previously.
+	 * folio_clear_hugetlb as this was done previously.
 	 */
 	VM_WARN_ON(!list_empty(folio_list));
 	VM_WARN_ON(ret < 0);
 	if (!list_empty(&non_hvo_folios) && ret) {
 		spin_lock_irq(&hugetlb_lock);
 		list_for_each_entry(folio, &non_hvo_folios, lru)
-			__folio_clear_hugetlb(folio);
+			folio_clear_hugetlb(folio);
 		spin_unlock_irq(&hugetlb_lock);
 	}
 
-- 
2.47.3


