Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AE3ACDB47C
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 01:47:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CD7D6B0093; Wed, 24 Jun 2026 21:47:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A52A6B0095; Wed, 24 Jun 2026 21:47:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 194A16B0096; Wed, 24 Jun 2026 21:47:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E8E256B0093
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:47:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 718211C32E0
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:47:25 +0000 (UTC)
X-FDA: 84916747650.20.8A693F8
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id C86BF140002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:47:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YnBqLtZF;
	spf=pass (imf09.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782352043;
	b=HTbJ8aNGkUgoNWYYwk6SG4zn/t+qOQ7MgkHBDiZf0ylWHgiy+WVIiaWSOLfLTvM8tlRkUB
	z9S/60wxr7AIDufGQVeFqwBR0ndfMFhuI/0mcdBqN68ll+2KSMeqgKGEB16KtCV2T5tPOP
	zS2X1IIOxPd5SCab5J8ftYZflqdW1hU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782352043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kGMYoZRxtZobwWw8ZM4+lFcvqKEtxP5vBoU1YuQ/GQw=;
	b=M73m+6QiDaiK7MFPbOr1YDoVp58xK6uMLNvSTVcXbnUo7PbBtwZ/o+lHFJCEgowG+xDQgW
	fRQ24eA55Mzb23up5KMEAXMDxykOiT1PXJdv1wqje7BCSU5+XiVIZJAuXtpr5B19wIM7z9
	bO9hEiEq/ln+va1COj24trWZBdGHjDk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YnBqLtZF;
	spf=pass (imf09.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782352040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kGMYoZRxtZobwWw8ZM4+lFcvqKEtxP5vBoU1YuQ/GQw=;
	b=YnBqLtZFr+2xHIbdNgTASKsn0K6uclwDgad848hoMkcp9Uz6ucLN1Au7CP7sqOn7Ln2YMT
	dz15QkLMwmy+k3OgHbtjzi5NHjg3c2h6teVBNIiL4hEUQEowvoeVFjzZO1xWERyPJW00ZR
	IqNVnw6yiM/pZkU1R+SROL/dZhBkEMA=
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
Subject: [PATCH 1/2] mm/page_owner: clamp skip_buddy_pages() PFN advance at MAX_ORDER_NR_PAGES boundary
Date: Thu, 25 Jun 2026 09:47:04 +0800
Message-ID: <20260625014708.87386-2-ye.liu@linux.dev>
In-Reply-To: <20260625014708.87386-1-ye.liu@linux.dev>
References: <20260625014708.87386-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 3jhqjm6sihhhmfukdzsgswpreyx6it7n
X-Rspam-User: 
X-Rspamd-Queue-Id: C86BF140002
X-Rspamd-Server: rspam02
X-HE-Tag: 1782352043-985764
X-HE-Meta: U2FsdGVkX1/sKLEz5iuyx/mh9obYF6KJVxmLtyq7iV/9uUJAIjN1erYvr9tIOYKl8Omo5o55gy5/vP2lt08LH8gWUwX4MNThOCJt4oK9eqe1xN5pB2WgrKnK1YD+kqe5fdyLWW7xKntRoPk5QxBeelxtnmqbTA4gK6bvvQ/aAlvMOLGs/si+IutkBaHvnu+3Wf6CXfaxVEik45kn8wcZ+1n3TMEt3MC0hc92aH/o6Qc5e5yiHlCyI55sTjKeaRdGIeLL85nx0Y/BBpHrugm6dOgpPK85t37kW+/mG+fy/SdD4KK04KKvjdcoaxHe3zSDN4/H1Z0xovhrfaKHuBsTQetGn+zrIzwc/lqtVZhLUhgwas6Eh92zNMz198oLRfHgK/oOdC5XWzF2eM5e30X+P1hR6tDZ28ECVmiqg8V7b6ClX8BcOspjsK/xidefy8H5fOuPi404fDaVlesXaW+1h5ZQjcsY2rPqw3tkY4zIG36UQ14dTvHsTNPVmxJGPe9GA124HarYlm97oaJ0bGlwpVJOJNMcBC7CHQHrX4R1k9UtbpaOAIvEmMTFh3mJV7V3hreOymdDzhK9DpazaqamiEjAR1Xoq0/YEX55m1918/K6TZQe1dFV0oVBQwdEz8pmstmFliADKOXoQviMw6Bs81EQyyO9f+//Kz/CRP2XIUHZYgZft1KbModtYbLTcm2aVHa9zQRWB8Bo+ONSgO74Lhk/bmTFeT2M5nSuyLVilEXu4tyL9KifHFqojq7Gw0D6apuNX8N6XkiMlE7KM6RjUvaherZ1Tc8eo9ucLnFYWjaE/Rx6WlaGaqs+RqQunOXU4NhCe7coVYd7fgML4mEiHY29v9+LveZLRmU3hlE/okIja8Dzj5jRPc20o6QQD8vWffs4bIMytF03E+SsHgaGbbHaccrpH+H9Gi5TZ0wGWrw6jOzcSDzFco3G4bSyV64gQBmra1ZY7ozIfIP4QWj
 8R+1GKkj
 Mxx5vAbK7kxZW5ihiTNQqtQmMR+Qq+qi5I8KsBZgeHlDAXiw7zdGlRpSPQbI69VgSNYxJ6XuXwGx61Sjy3w8i7sDGKsbzg0vTnsyJBBZ1rLeIHqGkkAY+IlnjY+ZBvYzmt9naf+WD/XemUk+35FEh27fIWQbfJc0tXyXMbLVhGHBojHPvoVEcRSw15X9f4uIDy88J8adWUebasDPDeJYoCslJfuWUqdF+/gYb84l5oyC/urPJW9hpAMvo1Q==
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
index ec9600025127..5c403bce35ce 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -435,6 +435,12 @@ void __folio_copy_owner(struct folio *newfolio, struct folio *old)
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
@@ -446,8 +452,12 @@ static inline bool skip_buddy_pages(unsigned long *pfn, struct page *page)
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


