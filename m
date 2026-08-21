Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0260C5DF81
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 03:10:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A535F6B009F; Thu, 20 Aug 2026 23:10:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A04066B00A1; Thu, 20 Aug 2026 23:10:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 919206B00A2; Thu, 20 Aug 2026 23:10:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 609BE6B009F
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 23:10:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB8388034B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:10:42 +0000 (UTC)
X-FDA: 85123799124.09.47A9644
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf28.hostedemail.com (Postfix) with ESMTP id 67A25C0007
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:10:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="UIi/vboS";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=xiqi2@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787281840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8AI6HtS4dpJQMurnjr+nnabNMTygY+5X/n1MvHLYWlw=;
	b=msCZ4+QigSYyGVZTsU0p6AofV930pBN49rMsbiW9ZRYaP0caTN/REQoU97ORw0Q1GEW2ZI
	sSyldMoehS+Du0t7QloHzW9ZlEq5iJX/fNaIAKsV60sS0fFtUlYErcgHRUx/tOhOS4d2wA
	/EgvR4Lb/6aNIjgub5yl5tC+h4WhC34=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="UIi/vboS";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=xiqi2@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787281840;
	b=wtJPX4pNKVlt2cqHvSOKU/mLKbSz/sLsurOMIdTisW9mHHRFso1DKjDNJ497lNXWfsWN/a
	qpKp5BwjUJ+Y0kbYYl/9P89KcJ6vacixTfsP58OlnqZ7i62f5a3hKT2dUi8T9IMQUFNxPT
	Dm/511uUVQjeGC/UXuxtmne8I3o+3yA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=8AI6HtS4dpJQMurnjr+nnabNMTygY+5X/n1MvHLYWlw=;
	b=UIi/vboSFvm2pmSm3LPibvuS9suMUUMLbN9DCgMbUvYFFG/N2c4ASDVDgEx8wjLoNFHtXzw7R
	84FgB0BXXsVYLwR9DA+K849n5TWnZ/mEFtYR/EI3UOgQjJ2TupE8hSSEmWvaT4bS518Gwnb8Cck
	+ARQLexmqe9Xlotnanlhb84=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hR4ms73lLz1T4MQ;
	Fri, 21 Aug 2026 11:00:29 +0800 (CST)
Received: from kwepemo200010.china.huawei.com (unknown [7.202.195.178])
	by mail.maildlp.com (Postfix) with ESMTPS id C6E63203C1;
	Fri, 21 Aug 2026 11:10:32 +0800 (CST)
Received: from huawei.com (10.44.142.85) by kwepemo200010.china.huawei.com
 (7.202.195.178) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 21 Aug
 2026 11:10:32 +0800
From: Qi Xi <xiqi2@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
	<vbabka@kernel.org>
CC: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner
	<hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <sunnanyong@huawei.com>,
	<wangkefeng.wang@huawei.com>, <xiqi2@huawei.com>
Subject: [PATCH v2 2/2] mm/page_isolation: guard compound_order() against racing
Date: Fri, 21 Aug 2026 10:55:01 +0800
Message-ID: <20260821025501.2752563-3-xiqi2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260821025501.2752563-1-xiqi2@huawei.com>
References: <20260821025501.2752563-1-xiqi2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.44.142.85]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemo200010.china.huawei.com (7.202.195.178)
X-Rspam-User: 
X-Rspamd-Queue-Id: 67A25C0007
X-Rspamd-Server: rspam07
X-Stat-Signature: ruc3e1m59dbqygrrcdjz4gu9ukeunuhe
X-HE-Tag: 1787281840-394853
X-HE-Meta: U2FsdGVkX1/e9RIAFouzMIAoDfeTte1HSsY0301v3Sva+fwMgEoJ9liU3xw7mYp5snBOYOk8yshcTRDNb+yOauTCJ28qqEASp1A0bknEUlQSKTV4N+tGAiqhpMLuMBye6pNDqXL6hyx6UpjMIYeuMRH0k4Dgz6h4+wQ6FPRPu260Pzcgo6X1pZXJikKx5kw6JAHmK4AW2pSjLfkoXTTs4Q50uhqhOFdNAHIZku41Rjk2qIf2yOCBkKWzz6kpSQwL8yjAHzFpeGBA7aOguQH13zji9vgY+U4Te2+JtfwB+MaSx/kG3KIOWJiQjabB4eoCQp3PrblOZFTSzPL0vhQG/KP1j6ST6hjHyaz9qxzssm0AXWESnAbrEXFrPCjhpsr0wkJX/x7A5WdHe3dWPYuwx6nS1HnqpGh8mzLEeA/e1qxKZbnWOF8cPFZCQL1D4Xd/hcb1QSS7jRyIfmFM6wojQp+oTgniRJ0ba6eF7dUfUmCnpAVviFVWz2CID5a6vsnoOqySRmbXnFPvhvK+5bAgehAY2U/yc6adXrdRt4IpCAnESE/Ezu/7hKiYDGxU+KVPHzrR09ByQ5PIcuOXS6doD3+2uHQR0wdf7YPtzix4K9lgEW8NzW/lE1x8EYM4wwxAT6TIczEg+YF40ibZHHSfXjW6tbhOsJAaf2Y+mNzGkVUuYoLZRsWqWqcDCO9J+/ZJ2KUaSGT7wXt40dSA5ITvaOu1fo7SF9LKrdiEDFbRQyDY9H7pt1GsVgPMchfjwzZiN0NPc2873qE/g2WrnPXAwAX+rUoXn3DM0qogvKlUAlJ3iyX8FqgxyGpKMrSevYlq5u9bdP+toxDzf9Trxaumjdj0HLBL2p4nWP1JDhk5NrmDrQ57IxVs6g5o9PmVc2qPi5/f2YRbrPzRwlUPMPdYt9Mj8eMPdVa7aeFnxaHVugPTbvFPWZY6knXSgfz3IXC9zwaL33695BEOd+IrxBp
 5Pu/AN7D
 BB5ihs3I6OIP3nPXXxzXTkaaBMgdyQcJCc6H1tDpisQomgN7P0hvUXduiuQj6VZeI0VIZ3dL6z1lqmtBj1p6cflpk3bKSpKRmfoWuslL5gWYZ8RJ93xCYDZxNrdPkS/NAM4qRCSDQ9BqNs7tclRTgKdfOYRNObFJnt8HW5XI5a1UwwHSeYj5Yi1AI5zeYq12WlgEZIpEY3uK1pg0DoxZjIyh50iMc3R5v8j8fh+3AhYxU8ZdnhotpDDhzTCavWCEAZPpEPeIttFAXY8M/XnT1A7Nmm38TMKtM9WeiAG0nqKBPxb89laOLyJMzYAxY5aq4dMh+PVdLYtbNCVXjoF0maILLbAtFUcldCBEfb5J86OiIPafS2aW5d14Y2VutOEjj7b7a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The PageCompound branch reads compound_head() without holding a reference.
A racing split or free can cause compound_head() to return a stale pointer,
and compound_nr() reads the order from that stale head, leading to
out-of-range shifts and making the skip distance meaningless.

Read the order explicitly with compound_order() and validate it is within
MAX_FOLIO_ORDER before shifting. Also verify the derived head_pfn against
the legitimate pfn: the head must not be past pfn, must be aligned to
nr_pages, and pfn must fall within the compound page. Bail out with
-EBUSY if any check fails.

Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock granularity")
Cc: stable@vger.kernel.org
Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Qi Xi <xiqi2@huawei.com>
---
 mm/page_isolation.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index f2b648a68531..9cf7f92011bd 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -414,10 +414,28 @@ static int isolate_single_pageblock(unsigned long boundary_pfn,
 		if (PageCompound(page)) {
 			struct page *head = compound_head(page);
 			unsigned long head_pfn = page_to_pfn(head);
-			unsigned long nr_pages = compound_nr(head);
+			unsigned int order = compound_order(head);
+			unsigned long nr_pages;
+
+			/* compound_order() is racy. Cap it at MAX_FOLIO_ORDER. */
+			if (order > MAX_FOLIO_ORDER)
+				goto failed;
+
+			nr_pages = 1UL << order;
+
+			/*
+			 * compound_head() is also racy, so the derived head_pfn
+			 * needs additional checks to make sure it is valid.
+			 * Otherwise, just fail the check. pfn comes from
+			 * __first_valid_page() as a legitimate PFN, so use it to
+			 * check head_pfn.
+			 */
+			if (head_pfn > pfn || !IS_ALIGNED(head_pfn, nr_pages) ||
+			    pfn - head_pfn >= nr_pages)
+				goto failed;
 
 			if (head_pfn + nr_pages <= boundary_pfn ||
-			    PageHuge(page)) {
+			    PageHuge(head)) {
 				pfn = head_pfn + nr_pages;
 				continue;
 			}
-- 
2.33.0


