Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17CF4C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 06:12:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F15DB6B00B8; Wed,  1 Jul 2026 02:12:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC6CB6B00B9; Wed,  1 Jul 2026 02:12:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E03686B00BA; Wed,  1 Jul 2026 02:12:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD4F86B00B8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:12:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 34606166938
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:12:05 +0000 (UTC)
X-FDA: 84939187410.12.E6D6B3D
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8C1962000A
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:12:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="tMNBUNY/";
	spf=pass (imf03.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782886323;
	b=FRK3a70cU4cCHxR1hBRP3rprHjHi4nF8cdF6EH7G/Mk1/iS3xAmS218Q21bGWpBrGutUF9
	G3DyHKhHbrRtSNfDT7wufKlU5UVM5Avvdin7rBnF/hyoTcefipyeuXn8TYuQihclLJsimk
	h1aecEfamMWwC8o6TF1ZyoU9i5x+NW4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782886323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lTQkcowF1OWStKPE9/EmsKTnQyY3/wqTTc8MI+rdV/k=;
	b=YsAPnKXuh0+QE9gB7DmR6wa1JoII1nkc5XwOuBXk/TTgs2x1u5za3WxVh+lfF5FCiZozk6
	45pAuehiwiEFUIgMpbDIFzBPH+8+itmjVuAeZr/FrS2NkHQo1b/i/QKOA1wOEVYS1rvmnP
	h5TfC0eWMV2kZM/4wb6hIH97bJfl2ZA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="tMNBUNY/";
	spf=pass (imf03.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782886322;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lTQkcowF1OWStKPE9/EmsKTnQyY3/wqTTc8MI+rdV/k=;
	b=tMNBUNY/AvzHkUNgD81qluQHRcZUruSRUzNGCdu388WfXR1ZIBv5+E5+47doBVFQma/d2A
	2I3MyuEgEZSrwpLySDV/jYmhyZfBy0zYkBDVbf1icOmHUxyDOgfP5iDsLwZQKF6Kq2snp3
	llYLi7q9UGqDJ8FGWGbmIv/ipgh439M=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 8/9] mm/page_owner: clamp skip_buddy_pages() PFN advance at MAX_ORDER_NR_PAGES boundary
Date: Wed,  1 Jul 2026 14:10:51 +0800
Message-ID: <20260701061101.344679-9-ye.liu@linux.dev>
In-Reply-To: <20260701061101.344679-1-ye.liu@linux.dev>
References: <20260701061101.344679-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: aumbuk98aatop67k8bnxmcsd33bnz3kp
X-Rspamd-Queue-Id: 8C1962000A
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782886323-249189
X-HE-Meta: U2FsdGVkX18x2UCQZWzZ2OmLsNpl+D//ozvz3X6xnll05Ecr1JolylRfBfmT1tVw91CjMaWjTfvIaHz0qoOmkhCFK74d1UtGhnwpfLYy/LIAnMnNtzHEhwrutN/+Dqt/nxWRNCSi+Vmn2aAT1mmrPUlqByawy6qJbiXmvL1fM+5ZW4hJSCnMJ4ruujFOog7D01nE8Co8+m+1DJD5x+RTNbHKT+QhSmE6Z4lJ00+Hu9Ysgr+e1ePc1UMzLrp52Hq9qkBvPUqcXu+yWXpmAVCxK3RvFlH0saLsURM8R5rknmDUuhyrLLeJce/ufyyxwUrfZOw6mrj7lho44KW4Q+MDUvLukYNCkA9PmcNWKsBSX45BU/hwRTigcm9sHaVUg+lARTpyI2+5RcJNlxKgHgTTECorJQTGIBH2Hmq13NNm2H/vSZQTPFAx4Xe8KftbPhGHJ/RwPuGnKsUMf4/pOconrHjKgfsL1hj/8NFn6m9exBWODCZDkW4fFo6D78cXG472EFWNjCey1ZxERwhmPhkzzu3ScnJCXJEdtHm85rOVF9IkhT09XkV6hwjDhj5n6SXMbWdzQTOtSBiAmptC968IDURl3mPiZqQt+qvVh2IRu2eVPLUrNo00SVROppnKvzUIP9e34cdzAUotdrk3pSWuV6ynlXPIgMzTDXV3+nY6ff72tgcG2axB2zVR+31J5VtToxDkswHYoCSdHuUb8+HrXHSZwoiVKtYsVm21EU0Lris3tiN7ijqyAzwsjXHQQVa38xJpbsirUx2eQZnnLUy0rYuvaiYIYY3anpqkLXtTH+0IXCCZ9BGurAjyw/5zhcfSXQ5a9Mz1sh3GwL87vp84aboYoiDo7QNTFVocpEIm1odgVPvpMsIIwPF3p7WjNGLeFtBQz9EE+ZtXaVMQpqLCQzJKAF5NzktuSjBCqzageAL8q67dep8JyUIaC0BjsbQN64PfQFwpS0JvDWK9RPb
 wXfvn2C4
 XBZa1N/7Vl9TaBGxYLypvgji27mxaIfe51RnJI10PaVkm6xwaTsAmhxE55OqequDr1AB2iqAMGyAuXAc2GJzHMxm9sWglFLaSPhcSMJtz0KddcnKD27sx4khs1TKfHSyZfcO6FKbRwYYT+x9EV4pXsB9x24FR95N3TCcVpn1RFqSTfrBh4WColOqzZqLcZT5xArB2RF9uCi3L7XcbihOQBaEljOkTosRw3/VCWCPzwQMGPC55o65TYkthYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The lockless buddy_order_unsafe() read can return a garbage order
value if the page is concurrently allocated between the PageBuddy
check and the private read.  If this bogus order is <= MAX_PAGE_ORDER,
skip_buddy_pages() would arbitrarily advance the PFN, potentially
jumping past a MAX_ORDER_NR_PAGES boundary whose pfn_valid() check
would have caught an offline memory section.

In read_page_owner(), which relies solely on boundary-aligned
pfn_valid() to guard pfn_to_page(), skipping the boundary could
cause pfn_to_page() to access an unmapped mem_section.

Clamp the advance so it never crosses the next MAX_ORDER_NR_PAGES
boundary.  This is safe for all three callers: the pageblock-iterating
ones already handle boundary transitions in their outer loops, and
for read_page_owner() the worst case is one extra PageBuddy check per
1024 pages for a huge buddy block straddling the boundary.

Signed-off-by: Ye Liu <ye.liu@linux.dev>
---
 mm/page_owner.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 46a933f9c229..2e3880053a34 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -428,6 +428,12 @@ void __folio_copy_owner(struct folio *newfolio, struct folio *old)
  * to skip less than the full buddy block, but that is acceptable for page owner
  * iteration purposes.
  *
+ * The lockless read of buddy_order_unsafe() can also return a garbage order if
+ * the page is concurrently allocated and PageBuddy is cleared between the check
+ * and the read. Clamp the advance at the next MAX_ORDER_NR_PAGES boundary so
+ * that a bogus order cannot carry @pfn into an unvalidated memory section,
+ * which would break callers that rely on boundary-aligned pfn_valid() checks.
+ *
  * Return: true if the page was skipped (caller should continue its loop),
  *         false if the page is not a buddy page and should be processed normally.
  */
@@ -439,8 +445,12 @@ static inline bool skip_buddy_pages(unsigned long *pfn, struct page *page)
 		return false;
 
 	order = buddy_order_unsafe(page);
-	if (order <= MAX_PAGE_ORDER)
-		*pfn += (1UL << order) - 1;
+	if (order <= MAX_PAGE_ORDER) {
+		unsigned long new_pfn = *pfn + (1UL << order);
+		unsigned long boundary = ALIGN(*pfn + 1, MAX_ORDER_NR_PAGES);
+
+		*pfn = min(new_pfn, boundary) - 1;
+	}
 
 	return true;
 }
-- 
2.43.0


