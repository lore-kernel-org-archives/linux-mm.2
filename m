Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B559CCD4F27
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:09:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C51A08E0009; Wed, 12 Nov 2025 19:09:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8DB88E000F; Wed, 12 Nov 2025 19:09:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 946B28E0011; Wed, 12 Nov 2025 19:09:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CF968E0009
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:09:40 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 36E6513B9EC
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:09:40 +0000 (UTC)
X-FDA: 84103650120.08.204B662
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9A70A14000A
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:09:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=H8FNNgr+;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762992578; a=rsa-sha256;
	cv=none;
	b=TBw/YLJC45BDlhGYz98KjZ+UTJxO48P6Y1ZnnI5iWoHpNLRFern45uLmqRYWJ++sfXq32K
	8O/hp4TcceLRE1XD3KuEZOse8RDVLrFuZh2fHqPWUaaHTkvI754RDEbzdhICF+/ZROrEi1
	4EzEgfjjw2Y71pn2KyP1W8VoN4fQATU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=H8FNNgr+;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762992578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sc/kRw94YXpZ4S+oCdRqxdYA0RV/OiQatEvBHMPr30A=;
	b=0+strGO1j3BmhynDqJVKub8O2NPPIXoLJaKwIrUGBytYD2ZQN8+8ftvFwrfFRurEYqTdC4
	msYdOG0y66L80ODQ5wAjkdB5aA7HOvCRTAe1M/V7szYx5Vv2NPuFnW59JxKALjfXQuigkq
	5lwo3UeooshHl1FGv+Gbb2HOIushmik=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=sc/kRw94YXpZ4S+oCdRqxdYA0RV/OiQatEvBHMPr30A=; b=H8FNNgr+oRIanasd5fks71b04f
	6KjQojcQb0DFAu/IANQJDEBLz6cpsW+Tw3XsswpNk4rqN/eTQvPp0OxxWeYXsby8lddbAO1oOiuCi
	9TTA6nhlbN0bFVrHudcqsUS0IhB15hZBT7Dgeef3NR4ZyjSfDjwMENfXwp5VkiGigmEB5PSC3F8k2
	hLe9I35RZ5JwztfPnqleqyn2txxkatOYv/ci8Yw9ulnxyXlI41jwEmU6m8G6wzix/gfJtC+e2mOaL
	LlduQQzP5hAQrF1VKN/w8ekloKzISyTUl670taf93/Yaq+t74dUsn9uombw/4PDbP6cxp2stYm/mZ
	rLIti+5A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJKu7-00000006fP8-2eem;
	Thu, 13 Nov 2025 00:09:35 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH v4 13/16] usercopy: Remove folio references from check_heap_object()
Date: Thu, 13 Nov 2025 00:09:27 +0000
Message-ID: <20251113000932.1589073-14-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251113000932.1589073-1-willy@infradead.org>
References: <20251113000932.1589073-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9A70A14000A
X-Stat-Signature: ob7wbkywqr4i9nhyjodtogy8i1k9zdgn
X-HE-Tag: 1762992578-834550
X-HE-Meta: U2FsdGVkX19f5f5xUDNeBZs3VxMvS5XPlP1JaTnpiNyhCny440W85l2NTeXPYzwlIfsjMHzCrygWLEUei2ZPc0i6i1kReRzHZAVeU4MLPZrUErju2q/CSn4EowjHCNmz/ntdl4t5rkWN3J+hknVpBlklw1hE+NyHC/LDL29K+kgisybyM8XZijfDQqlJgHRYfDnE6oU48QBMU/0fCT/7xLzHHwGeut7k/4ktS6yZtFdAgXYSRYNBkaZsq9lDKA9xOcwc7dBVWfF8PFB7HUsh47hmVnyr3uUUd53R+1Zx4GWj/RHfHgON/Mk70RiBdDrR/7+wIi6j2Chu0cM1K7HS88DK+GZIWAjj3T7/C5zHG+PG2hsOetV2MI/lWCxyieIb/pvjhA+QtlAjLE630jjz++hVFFLEFV75WhxM4a3HZl/4/2FQAm6QOeTRLzLLUiMJ4onso5Er3Jb2Se8oHy+i/IkMHDV86k8XbwtnHcxA9QRSKFQvltiBmzwNwsQXvlhFZqOkzNK0vjrl/I8JEgUSrwyN+tLLGk2nDx9OfCxBSV3dwkMWTyiudJyzuYpKO041/+6UtntOaQn494e5fjl3EV7V9EzC3rQMuebQh8HMJFZcYroAHQJjiWGVuHtwbqGxCd3d+8xMgnEMXO7SncV7B3Lvy0qTScXJZm7uVQscD5A2pdEmbdNGEP4v3BhXwFmFUKhN+2zb1cL+KFaJM+snJ8pOYm8prTVpXiS0kzLEFDvYraxPAw2iZDqhqJX8DwU/xq1bt/V5aLw1mHVrW+gx1nXqsN0bcAaJ93rDaC5myEjqRcLNyHZwsA9S1gTgd5XrN0seCxf0UAvGyJBJvRCWA5Pjnhn/UFWkaNwKZ3LSopmYBbIsqWHwOg1/izn8oJZZCWaHH00E46Z4NtUFi0mni8v2uToq8x7hldKDnk8sB3cABUG5ou5p/AKpzwLRucKhKswX8rrbmr0RKIU4Oc2
 Cq/vd1YE
 VEx9o4OhFzp4KhlepX3BGDN6gAwYTuuvXuI74uodZ/QyNAxpCDiyzHTY+veTZGNf0sOPInOx5YJzDtoA6zFiOuolQ1SSXdJaWE0PTH09xWAJs8oOkhJK7Y6Mv8gIvRsFzvwUN5he7PFVk0xD8ULchfdXbjkZv+a2QyZw7amUwoYYZ4MxaKask8OKUMAZf5EaWWqANaTutTFpicExvuhbl1ycU2zmNJ3+yLMwK3nqFBgMmISBtelqk2RU6mAtUo/4qrL7VKvA3yCVroyzOKFqx4sReYCKAomO2qGDlP8PgOWlsPJUYRh62NMHsyg6GcK16kx1OBnBphtlQjv7ot22mbBy/Izb6j+jVDps8TQ0Tp9MT9x8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use page_slab() instead of virt_to_folio() followed by folio_slab().
We do end up calling compound_head() twice for non-slab copies, but that
will not be a problem once we allocate memdescs separately.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Kees Cook <kees@kernel.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-hardening@vger.kernel.org
---
 mm/usercopy.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/mm/usercopy.c b/mm/usercopy.c
index dbdcc43964fb..5de7a518b1b1 100644
--- a/mm/usercopy.c
+++ b/mm/usercopy.c
@@ -164,7 +164,8 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
 {
 	unsigned long addr = (unsigned long)ptr;
 	unsigned long offset;
-	struct folio *folio;
+	struct page *page;
+	struct slab *slab;
 
 	if (is_kmap_addr(ptr)) {
 		offset = offset_in_page(ptr);
@@ -189,16 +190,23 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
 	if (!virt_addr_valid(ptr))
 		return;
 
-	folio = virt_to_folio(ptr);
-
-	if (folio_test_slab(folio)) {
+	page = virt_to_page(ptr);
+	slab = page_slab(page);
+	if (slab) {
 		/* Check slab allocator for flags and size. */
-		__check_heap_object(ptr, n, folio_slab(folio), to_user);
-	} else if (folio_test_large(folio)) {
-		offset = ptr - folio_address(folio);
-		if (n > folio_size(folio) - offset)
+		__check_heap_object(ptr, n, slab, to_user);
+	} else if (PageCompound(page)) {
+		page = compound_head(page);
+		offset = ptr - page_address(page);
+		if (n > page_size(page) - offset)
 			usercopy_abort("page alloc", NULL, to_user, offset, n);
 	}
+
+	/*
+	 * We cannot check non-compound pages.  They might be part of
+	 * a large allocation, in which case crossing a page boundary
+	 * is fine.
+	 */
 }
 
 DEFINE_STATIC_KEY_MAYBE_RO(CONFIG_HARDENED_USERCOPY_DEFAULT_ON,
-- 
2.47.2


