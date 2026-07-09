Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C218C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 18:48:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F16656B009F; Thu,  9 Jul 2026 14:47:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E786A6B00A1; Thu,  9 Jul 2026 14:47:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB74A6B00A2; Thu,  9 Jul 2026 14:47:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A4A8E6B009F
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:47:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 30938C16C9
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:47:54 +0000 (UTC)
X-FDA: 84970122468.01.8E19BAC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 12BAC180004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:47:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MtyA5ZeV;
	spf=pass (imf16.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783622872;
	b=nRRAqKHqLLG47Lk8s34eeuRrQcWQ+lk7eQoUo1yuOhcUoLM0Qih84iLxy6/2mCiE7dMBKX
	DpUvCq++3IuR1R22GVMTVjrGGmhmu1eP/XCN66UUkoMVo9hX8XypTM64mnLQtYp8/s1BZO
	LeneAXZenPsEvc6jDF39FUQEyYDaT4g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MtyA5ZeV;
	spf=pass (imf16.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783622872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XL9R1G3dyEaarb6lw/J5PyiVcp4sbNIv8CdXMAaDtfk=;
	b=ZU11o0T7zG46J5A8xs9qeuL+Ky+JsgT2vTvWuumeoup+WAo7tvMWe4LTzt6U1gSeu8ON4X
	VMvGygXlr55OIl8D3NDM89ay7MJzxh/KNMiruA+6ZqOoOj/87MRuXjTx+1fH0p/fboWe1/
	3QffbqjRPUMWAlh7sJFh9+TcC8lg6WU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=XL9R1G3dyEaarb6lw/J5PyiVcp4sbNIv8CdXMAaDtfk=; b=MtyA5ZeVXBoOI9psFl/B6HoT/N
	V01G58BuNmT8GstWVG1FiMNABoQol2IzmRPjkGijyG8Lm3fko6OZIeiSvHRklLpQNr37tgXpRdnA4
	b+Zy16wA1dpzOswIq4OZ1wBMAuV53brj/gSlxHZWgXdtmqLBLGOl45XulW/IlWimg/Sl9B6lpANr4
	3ds6DlXcaCTRml1eITRAeCSzg/Zh7piv9JImW6YReDeiGGpIeJLLzboH288qk+pKzIsPJsIVDgSQG
	HULkwx79D2q9XdIumJ76OW/tDTn8l4oFeikaxUTN073NQ5tNBln6Q9Lr+nYMx39JlpvxL6lwM87DQ
	+o52shXg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whtmg-00000005OhL-3lje;
	Thu, 09 Jul 2026 18:47:42 +0000
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
	Christian Brauner <christian@brauner.io>
Subject: [PATCH v2 06/10] memory-failure: Prevent UAF in raw_hwp_page list
Date: Thu,  9 Jul 2026 19:47:34 +0100
Message-ID: <20260709184740.1286561-7-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260709184740.1286561-1-willy@infradead.org>
References: <20260709184740.1286561-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 12BAC180004
X-Stat-Signature: gyogzu63jo6a7wqn939ttu5magfsawzd
X-HE-Tag: 1783622871-664406
X-HE-Meta: U2FsdGVkX1+ogGHmH7kd+0kO7rsgt+2zFWUm9UyCfOhBT3EviT15ped+RJejEi6KCedCAWv42nudfZocmJfe9txz/3TEqJb0/z4JGX1IX3ZGWDeV/uHBVTogo6jw7MZVUr+w1WPznadE8mWJkNeIDYwd8JK+9N9kJO+FVaiThr7rHEghl+REYb9coQY5nTjPBC2Ufoa7dIdXxbVK+V/HvtVFstMOWZl24NXgmKGncOThriy4MGvS5VVrLjUyMCob1k6wu+10DJRLKAb2pDmi+Tx2blGsTUhSuPFK4I9bF5MglFFKlj7uascs5v6/rzwrJ5h3fiNZqqJXI8/GsiMhLWZQGeyXZuYZAoGwtixbBMSv1Nz/rMRiUiXnBR05Di7gqAAHlaxtH8h9xoJDr0gbXMESvCewSNYu9JCFqL7gVZEbwwiRgwCnNWX3JPpjBNoZPieVqaCmzcsNBr9UhJys46TwpI2xo8is+vJdIkKUuGUH46CTtDaRdCOAurbDXOhJ84QZeVxe1/jW6GsgXS3J/nOMFxKYAOKbye2+bLuULJygZX/hQhTZqjQRrvcza/wm0IzcVcpIKwBidHhxgJOZQaQH+pJi+FgfLxUHSRmBXwP42qZrmQ9VJmUZTGsZvXXPXMJvgEgq2iQ8y1eXI/oEHTJvX++tdAxry+5AsaViBW+C3HKupmtiyURa7b+WunaIXxVsISmvdI0V26HgF71NBgaN5an+0NYkt7+IA8JwoJcm+WvtHqu83CV8s3HZHmYy9Buwq3gUsfM53Lk3LRZy/5+kbIVKO4ASODHxC2v795xcf8bXa0OXW8QWtGgfNc0rucTs+/jSojvEON27EgaQetqmOgtDePHY4uLOQA26x4rL4pxF5CqJG+2N0AbuVgPR9wlKScKdXZmw9DWB7sGFuJBx1CZBqhSCgGihv+Qu6rdGLrsmtn8DVi7xJH6uspUYK0W23I986Z2ztlFqKcw
 SUdGtFCS
 7/A1wrpMjXn7SNFdXIVXelpzQBXim6ItRZ2lFwDzUhkBE1Ps4O+mp9ilSFig4rXtg9L0uSnToqqc+rgYxFgkTmFvy46o7barh8QbccaWn/puSbTMKSF+8fZ4xHnClc6ExsrBx9oFR+zQyCDx+hyTx5REE8E0jGNPBfspCA3LO7g49b8aPA4nHARFXTwp8Oq53PKVzECi7kyi8TnRb8lCPhYknCHd2juFxIUWJZ8q0o4j7BGtiL2S8ii5Hil3uJyAgEa5ZFQeqqhfE6+gS+0DePASEM3UbKNkHbRgKqTB+E87p5eX2kfQqEhj5CBVoM51BCZpfRwbD/g9Jxw/wHOkppD1k4Zq1UBz1TtJHc4zldWrV+5Z9b2GMJWbcJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Most accesses to the raw_hwp_page list are protected by mf_mutex.
However, the call to folio_clear_hugetlb_hwpoison() in mm/hugetlb.c
does not.  This is probably OK today as this is in the freeing path and
I think all current calls to is_raw_hwpoison_page_in_hugepage() hold a
reference to the folio.  However, the next patch will call this function
without holding a reference on the folio, which will expose this race.

Rename the current folio_clear_hugetlb_hwpoison() to
__folio_clear_hugetlb_hwpoison() and wrap it with a new
folio_clear_hugetlb_hwpoison() for the benefit of external callers.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/memory-failure.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 53063e2a1f97..353288cce1b2 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1935,7 +1935,7 @@ static unsigned long folio_free_raw_hwp(struct folio *folio, bool move_flag)
 	return __folio_free_raw_hwp(folio, move_flag);
 }
 
-void folio_clear_hugetlb_hwpoison(struct folio *folio)
+static void __folio_clear_hugetlb_hwpoison(struct folio *folio)
 {
 	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
 		return;
@@ -1945,6 +1945,13 @@ void folio_clear_hugetlb_hwpoison(struct folio *folio)
 	folio_free_raw_hwp(folio, true);
 }
 
+void folio_clear_hugetlb_hwpoison(struct folio *folio)
+{
+	mutex_lock(&mf_mutex);
+	__folio_clear_hugetlb_hwpoison(folio);
+	mutex_unlock(&mf_mutex);
+}
+
 static int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 				 bool *migratable_cleared)
 {
@@ -2051,7 +2058,7 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags)
 	folio_lock(folio);
 
 	if (hwpoison_filter(p)) {
-		folio_clear_hugetlb_hwpoison(folio);
+		__folio_clear_hugetlb_hwpoison(folio);
 		if (migratable_cleared)
 			folio_set_hugetlb_migratable(folio);
 		folio_unlock(folio);
-- 
2.47.3


