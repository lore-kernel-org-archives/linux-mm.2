Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD97BC5AD7B
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 03:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 535706B0092; Mon, 10 Aug 2026 23:07:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50D266B0093; Mon, 10 Aug 2026 23:07:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D52B6B0095; Mon, 10 Aug 2026 23:07:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 050466B0092
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:07:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 564A0C02ED
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:07:25 +0000 (UTC)
X-FDA: 85087502850.09.4EBD9B7
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf20.hostedemail.com (Postfix) with ESMTP id CC8A41C000B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:07:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=cfi4HImM;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786417643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3RZbPAYAvl32QwZ/NBytlP1RvgJPCM8BP5+kfIW6nbE=;
	b=NTAkfM43KFyh4xmQSTR4xXYRholmkk+UoFpwRLp9UCWVk8UCkdA6KFkljnb6OdCCF1l8pt
	9AunPuiQmvX/V5TVGG7BNBJJ2OEd4ObekbckRoQGJbHOCqRyC8JB7Iwi0MFjc5kK5ueZ2D
	QfljlM3w0jIL6IkWp44c8npjs7otzzk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=cfi4HImM;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786417643;
	b=Yijy0+3kIeUlPtwb1R35zjL8wwRUos9v5SNZqczaDImUQ6PgDoTir0Trndcxs6PEuyHtQE
	xvf4fb2+gRzgD1d4oCqPVqSwZgZUPZNgLc9vh+IKnbTRkDwGTP2pC61FI+tEC5C4f7+uyC
	NYCiWBcqdlr0UGAsY1rdCAkB1b2p8/s=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3RZbPAYAvl32QwZ/NBytlP1RvgJPCM8BP5+kfIW6nbE=; b=cfi4HImMhV4qUUW5bIGJpJ4mnR
	1PShb1UDO+ftIPtt6/K82ZZU3h6dbBWlKUKmBcLeJEUes3hkHsg7lKqdRz+5TCrs2jD/3MxpW6f7p
	8wuKx3bFxJqDgVTIcaZbSJFT3/SuX2lT1sET1WOh0FQWmitcQqj+STzd8xwbPk5qLNPVIYXDPdoUn
	JELJvxGnXpEnyq2xGcROLAMLyppdays83XuaOfcoAxw1ahS73RLe1j2k4rlUTiGUYf6zusRVCPaOY
	AH8W6UKFdm8zcZi0wVJujTMMpjcU/t59Qv0RW9ilGCWLqPlOQQhNUh3XmhaJsJTDJ+sU8bULblfFO
	xys5upwQ==;
Received: from [96.67.55.146] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wtcb6-000000007kZ-2X8W;
	Mon, 10 Aug 2026 22:52:12 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 3/8] mm/gup: split follow_page_pte_commit() out of follow_page_pte()
Date: Mon, 10 Aug 2026 22:51:52 -0400
Message-ID: <20260811025157.1632867-4-riel@surriel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811025157.1632867-1-riel@surriel.com>
References: <20260811025157.1632867-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CC8A41C000B
X-Stat-Signature: wn7emx4ca73myyzj9s79xes4keewpeka
X-Rspam-User: 
X-HE-Tag: 1786417643-435620
X-HE-Meta: U2FsdGVkX19ezLGiulzf6zU7a6KrhZgpsxKt2VX7ExOWAYsgo2pbEIVW71wFRa9EqQKoxYnWJHpRAsW6y68+3ieLM4aL28R+1eTZQgGb9WURp4+EBpryefW7Km4KPWvhA9p64ZXaUfDwX4SjOTEJY0JLHomCH3uXx4JElWK5wV5LaDAq9fHJkOalnbIFv81mrPc+UAYdft7n/l9ZTIiW7LmN2f7MlXGynfGYCjCU8K5NicpBP6883pdmd9+Lpq2dqRy+50eaHzCarc1LTYsZsjo+0b9ySbS0ii7GbGwt63u97EyBU8/NpLert9mdKMt9vSa3HyGx1s8q4/P9HwycB07VdIJFArN0IDWjmkXK8Thvy9UAxR4Kmsv+1H3+sGmfoY3xXy833Rpr5+rlGkG5WkIXodDjikZ7hn0N+ouV8JMnqUM/fwVeJy5glgYZXmcInX2vJsOa8siCFShl3nOsDQ8KIFlwhWBP8d5SPYPxGU8q5tXV8nMLffwCKygbv5h7XdLxklkUHsdLpm055CtUcGui0hJU6ahbHCGRbSWQIdwl+J0xnlsCpvuRycg5l8gQ+ZW/iglPpnWwEvECckTuBqWzk4CjKehsrsVmMPCnT7GRz8RC2ega+9eBoNA0OzjvnIgN8xWmGfVgYHA9/1ntyNPd4KENCoFqeKv2K8jHxyFHVCpACpiK8xJ2fSHO8aAqUV7nc9KadGvyN+f5o7V68mx3DvK0SqByYXJS1NBzD5qJTo5pJqLr7nOpwsRfWKDPKHoDMWeEI80uAcPdqALJ+spDFsn2l4RPsgNke4B8wXtWByGdT0rQt0kjdaP0vDTVV7xBNmM9kojr3IDMDLaQxd+5fzN7sqb8c1PHMWouRimefcVU7mGj3m7TURI8StolQRi/W6P41BRjwieDcM62Mietmj9bP8VTOBaHnnDohzsPeCJPtAfnUH9bnyqppXo+tH24uxW4mPz9dEDxlTs
 sMiESYyk
 l2EeC0R3ZAEEZwNUlllocmD4EYeFYwXvp9iE+Qjca36P9yKXtG0J1PP/AhgYI82KGpf5sc68wIWgppPUlu/7hPjTU3Ae5GQPZNPz6NtmsFIQ+LQHCqN98s0IUwAoawp82yNe8j1dccfxEzpRsAzNNNIXNcIrHbNHQgzK5J0EbNTqm/KTf/uH0xDPx6oHbdlocUn39UdfYnhGWti63wz27hkC820q4WAqroamK1ITLQynwLArJZMp1PEhCMGsOyM9+LPngAmdjtjZLjWfD3VHT6rkHKEki7/z9cY8LQWf8ca0gxcx5WC0hLyRCn1viY5ro3tt++YOP9yM29Plt3hW1IvQJgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

follow_page_pte() does two things once it has resolved a present PTE
to a page: run the per-PTE safety checks (write-fault, unshare), then
commit to that page: grab a ref, fault it in if pinning, mark it
dirty/accessed, and hand it back to the caller.

Split the second part into its own follow_page_pte_commit(), unchanged
except for taking its inputs as parameters instead of local variables,
so the checks and the commit can be applied at different granularities.

No functional changes intended.

Suggested-by: David Hildenbrand <david@kernel.org>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 78 +++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 49 insertions(+), 29 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index e4e6d0993424..b755ceaac0f5 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -822,6 +822,52 @@ static inline bool can_follow_write_pte(pte_t pte, struct page *page,
 	return !userfaultfd_pte_wp(vma, pte);
 }
 
+/*
+ * The caller has already run every per-PTE safety check (present,
+ * write-fault, gup_must_unshare()) on the PTE, so this only does the
+ * per-folio work: the refcount grab, the FOLL_PIN accessibility fault-in,
+ * dirty/accessed marking, and the array fill with the cache flush.
+ */
+static long follow_page_pte_commit(struct vm_area_struct *vma,
+		unsigned long address, struct folio *folio, struct page *page,
+		pte_t pte, unsigned int flags, struct page **pages)
+{
+	long ret;
+
+	/* try_grab_folio() does nothing unless FOLL_GET or FOLL_PIN is set. */
+	ret = try_grab_folio(folio, 1, flags);
+	if (unlikely(ret))
+		return ret;
+
+	/*
+	 * We need to make the page accessible if and only if we are going
+	 * to access its content (the FOLL_PIN case).  Please see
+	 * Documentation/core-api/pin_user_pages.rst for details.
+	 */
+	if (flags & FOLL_PIN) {
+		ret = arch_make_folio_accessible(folio);
+		if (ret) {
+			gup_put_folio(folio, 1, flags);
+			return ret;
+		}
+	}
+	if (flags & FOLL_TOUCH) {
+		if ((flags & FOLL_WRITE) &&
+		    !pte_dirty(pte) && !folio_test_dirty(folio))
+			folio_mark_dirty(folio);
+		/*
+		 * pte_mkyoung() would be more correct here, but atomic care
+		 * is needed to avoid losing the dirty bit: it is easier to use
+		 * folio_mark_accessed().
+		 */
+		folio_mark_accessed(folio);
+	}
+
+	gup_fill_pages(vma, address, page, 1, pages);
+
+	return 0;
+}
+
 static long follow_page_pte(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmd, unsigned int flags,
 		struct page **pages)
@@ -877,36 +923,10 @@ static long follow_page_pte(struct vm_area_struct *vma,
 	VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
 			     !PageAnonExclusive(page), page);
 
-	/* try_grab_folio() does nothing unless FOLL_GET or FOLL_PIN is set. */
-	ret = try_grab_folio(folio, 1, flags);
-	if (unlikely(ret))
+	ret = follow_page_pte_commit(vma, address, folio, page, pte, flags,
+				     pages);
+	if (ret)
 		goto out;
-
-	/*
-	 * We need to make the page accessible if and only if we are going
-	 * to access its content (the FOLL_PIN case).  Please see
-	 * Documentation/core-api/pin_user_pages.rst for details.
-	 */
-	if (flags & FOLL_PIN) {
-		ret = arch_make_folio_accessible(folio);
-		if (ret) {
-			gup_put_folio(folio, 1, flags);
-			goto out;
-		}
-	}
-	if (flags & FOLL_TOUCH) {
-		if ((flags & FOLL_WRITE) &&
-		    !pte_dirty(pte) && !folio_test_dirty(folio))
-			folio_mark_dirty(folio);
-		/*
-		 * pte_mkyoung() would be more correct here, but atomic care
-		 * is needed to avoid losing the dirty bit: it is easier to use
-		 * folio_mark_accessed().
-		 */
-		folio_mark_accessed(folio);
-	}
-
-	gup_fill_pages(vma, address, page, 1, pages);
 	ret = 1;
 out:
 	pte_unmap_unlock(ptep, ptl);
-- 
2.55.0


