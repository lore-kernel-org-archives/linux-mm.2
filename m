Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF764C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 01:52:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C39D6B00A0; Mon, 13 Jul 2026 21:52:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39A1D6B00A1; Mon, 13 Jul 2026 21:52:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D8956B00A2; Mon, 13 Jul 2026 21:52:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBEAA6B00A0
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:52:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A8BA80206
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:52:13 +0000 (UTC)
X-FDA: 84985706946.29.441C00F
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf23.hostedemail.com (Postfix) with ESMTP id BE96C140004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:52:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U08nGuag;
	spf=pass (imf23.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783993931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zi8sMOqCJW2NCRhuASX5GgkHm8VKvEUdMiR4+SQo7LU=;
	b=38F6VlqH8Bo/HwghDV/tY3tCJLCSkce+8FtoQ3hg9bwoJ7HnolECjsrljl2RfgmSX3zChC
	DE1epccYiu/tNLjWreH9I+HyQLH8Czi9cpIT1cYnzkWMa2hdUpB9WjEPrm/tYqyL+K1c4e
	1ByTFWvbgctfrSV+vJd2RYGphiZUfHE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U08nGuag;
	spf=pass (imf23.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783993931;
	b=ud8LUFUV/TOMDB5vcKidFp47xvMbUbybWbFAZON0eXIamfY6HpljyaX8CLlgicSfUiNhRe
	5aHh2YTu2I0tkgO3/2zeiBjJWwq12fvkbuK8ZYNkuv0tocq8XwvNxUpd6a8S3lS774R/Mu
	cO5PIctbkgRsHcM4RKxY/CCGrpimhEs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783993930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zi8sMOqCJW2NCRhuASX5GgkHm8VKvEUdMiR4+SQo7LU=;
	b=U08nGuagzbVhLLarcP6Ht3kvNTZeXYqu3T5PvbGybt6QkW43Jh4P2dRv0/rY/wJErmKNrS
	pNZXrhPoV3IehqV6DD/WE8oX+Gf8zyotNtcam06UrfbSuj04VyD/ZiMMyC19BYOCtvHb1H
	G+APLQqEcI61CRRjWSjiJmTtRPeT/Z4=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 8/9] mm/page_owner: clamp skip_buddy_pages() PFN advance at MAX_ORDER_NR_PAGES boundary
Date: Tue, 14 Jul 2026 09:51:07 +0800
Message-ID: <20260714015117.78351-9-ye.liu@linux.dev>
In-Reply-To: <20260714015117.78351-1-ye.liu@linux.dev>
References: <20260714015117.78351-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BE96C140004
X-Stat-Signature: xad1rbj9rx18izjeph1gbu41giwwxgf1
X-HE-Tag: 1783993931-485767
X-HE-Meta: U2FsdGVkX193h3+bnFXlKRDFaMSmcNDlPudCJegc2i/vdKlIr3q+S9l/M8/6MLuBCcTEQIbRbFCYmbnIexXrCxLSOvCZutHZRrhTzeVw3AecuaCzLr4cEqNrrNxVtuKX6huO48nc6TLjDM1YNsPqPqAbrcBwNfG19TuLMZRX69OvtdqVPr7ET87U2q0ScmfH08WjXeNM86RtLZUWRE/yABDI8xv9JXG7o+0nMhIo0kzU8P5pBedqnJYqCBGqkv12eRgiaYJjNmJfUqLhhhwMjEvSH7uERTJTTNY5sL5SMpmgrlcImnJUhPQRrROv7Z0ngBcRJiWROjT3T+oVU6xj4WsudDJZxQDUaomt1iesrHR5KxmcIcYAbg2l7U6BCcML0qBLmS3I+YH48OUFsgDR18rWJto/o519IBpFHYE1zu+tcQWyC4+3U6gQGJj9KMPGl2deqvtsPLp12WnClsVkJjwAE35QQSO7ixcsf2dsnq8KpnuP7ek3Hwvbw/EPCKw23PABVvO0nSir49FiLlZTgm4ktLFihFQfYw8+15nRi9bS8nSYIOsZBzo6ke7Gox13cbyFSubJu0vqYg2Q+K6tzdFonVcBnkS64oyHpUznWrdHOvz0FzPcjmh9w+QEb1hLHQ111F8Zy6QeTyN9TsQM4o54HM/hFr1o+rSlgI3Caghv9g48CQlw4GrLjNq9jsuDnYTFC/sMVghu1KERnlymC2SXKSgMOYrURPKsiEnKGzgmDQV75xxY1F4VH6QSFlwXcuV8+XldvWNP0kv6zFcjVqs5MaGEM0ZqqzScW1ZwIKJ6W+qtb10HUTTlxuzgW8Il+aHZsVdcVCk87g8CCF3RdyZc+fhsz1s1gWL0AX8zh+l3Oc1WGUwvGo1jdWIIOLSUQxGi4+kTOB/BwPRVAdx+hrfrNNPMPJAXX2td7KSTOIuzMA49va35soe9qP4IyT8r9speQD8YTUP4oqkcB43
 VMPsEO+K
 RW3/hG86faE33twsBTibXlNgNqs2GVJv+DcVmUYcD+dWu6xgA/aqolv7YXZYsl5NqR9uMsZzRHPCmxTWaC35GIoSkkk68gb2+qo2WTSQfgAghjerlLXhnNk0GsVz9iJO/1ndRTmd0ujMCXPbufNgdVuAPb3g3u/PakAoXF3OmcWdBh3WjW657XXVohzxAGKmozQu3+XDnD74piIlDVwYRgMMaZofU8Ajtc8J0pc5VYip4+huZQYgAqlT6LOfFGONb3o41TnFwkWiOvB/zsQElvZxpud0IeSMxzy/Bcrl0svLKXx8=
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
1024 pages when a bogus order would otherwise push past the boundary.

Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
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


