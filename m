Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C793CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 19:50:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02B8E6B000E; Fri, 29 Aug 2025 15:50:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1E5B6B0028; Fri, 29 Aug 2025 15:50:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E33DF6B002A; Fri, 29 Aug 2025 15:50:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CDAA36B000E
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:50:30 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6EB135BAFD
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:50:30 +0000 (UTC)
X-FDA: 83830837020.29.49C0D8C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id BDCC7C0005
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:50:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="lK/tRESA"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756497028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H28jUpz4ljbzmZpnbAdtYKm+Ln1ENVUchh1XCG9sT2o=;
	b=wI5GKkLNRqkE3c+jONgtPZLXRruZFKVZ9hzxFTsD6H/8EF0A7jGUD6EVM+ZoNgGfnO3fvy
	GgDU2utYmo8tq0F5cUvOIrOhJYMqlksQASTET4H0Ng0hD4YAwnW9YFKKdWiVqXU1Zmg9Mt
	s6NnSH/RHBacyRXrQYDgEVViE+oFupM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756497028; a=rsa-sha256;
	cv=none;
	b=bbj9z5Yr+b07ronillMXkGsZfiigrGV91ghp1cAuJucifNoJGKrgWWTzypy9YeufLho3+n
	odymGnjg2S0CmsCRs9Fl4TdMrXb6W6+hrPZu8OOGRuqRF42pBB6lqqmFgugOJRon7//7ez
	5HIg2Rd7sBqa7/Ic1u7zOqWyVJUKyBc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="lK/tRESA";
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=H28jUpz4ljbzmZpnbAdtYKm+Ln1ENVUchh1XCG9sT2o=; b=lK/tRESAB0eRe1/AdGvmI1T7cQ
	eC4AOsJrzhW4gTgXq8SBO+hGbpfAGWRN81uGix4YFZOPT8/GtsK+Qb0hlj8pdTfnFNB+VNqF1AOES
	gWst6RkyxCwLRu0byWFmV/hv2Hs8ypfx4BDUX1R0qo01jTD9KJhxrnf6p1x4Uzdh/RTDZ/NaEyE4F
	SxPO95ogSQspqr2cin7zPHHPwnfl1Nd1WEw3kWwJ9zhSyvkyL3tPFzo4S7ohj7nuKPMARQyyC6qSe
	/Y9fYvQpFwywVo4eioydVzfe9lkiuDn4NPdZ1EGMVRL6nshWC7z8dz3+LgW0uRfBDDiU2pIpbCXGZ
	Q/4b7tjg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1us1K6-0000000EFwB-4AKS;
	Fri, 29 Aug 2025 15:47:31 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH 03/22] slab: Remove dead code in check_slab()
Date: Fri, 29 Aug 2025 16:47:07 +0100
Message-ID: <20250829154728.3397606-4-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829154728.3397606-1-willy@infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BDCC7C0005
X-Stat-Signature: fpc77jtymcwqfg4756h37frj6bfx1zht
X-Rspam-User: 
X-HE-Tag: 1756497028-152781
X-HE-Meta: U2FsdGVkX1+Fyb7ZSlWzWi7yuTaRTxXgaOagDWBmmetbdRDlBT8dN6FNDVbWus07p2UOUryF3a+wvOKOus0frTXFK0NL44BUkmFCXhfIvqZySYqLWbLxwVWANlA9F56dJVZh2qfdpD0W2Sbqy3m9yHzB0lu5MXWdkjr6eN+8gVYTUBvg00Q+y/4PWbgXbaNodLcdFje56sgneU31VzFJ+8/JYtry/3Y5NGaEb+rxJmjaHx8QgXvjZdNLfNqmvzJTL7Kwvcxu5mWrasFns5PjzZWmcI1ZdojIGozvvRnmxhXKO437UCVgjen0Q+8TzopqNeo8/YVxHX5mj8SRanzLRrUn2fmRpjLXtw4Qbgb5pBniimVu4KXytFh9DGRyGGdpygfqGVKuD3YyOOAZWynecLY/eh+MDoFR2MQcDX0cio4EmQY5p2cbNWaJS9Cf+FeAoEGuAPxTdIjTYQFScM3X9D9yIj50pYV9wQ8ssDvFS2KNm5+xY0iUj3rfwvikJ8fev8mydCK+n5ELWKq6DQ5qToFMqCjqb1VD+qC/k75L9H8+GbSeajsfuYLX9L4CtiiJu5lalMl0nRroH40kOks0iTKOlLPwoWLiZZQF5ikp/B2jrqJjzJMQBoGUFxdktWQQGIxsnMlCL6TcCa4QORj+uHH61pmqjtTW73663bKmCsKMAdlQ85rZARXweQrKkcJ6D4W1KBsF5sfnXyGAOleADQ9Dr4ir9eK1q20/NuhMX9TeyzqDV9TtjNtodn8cHUgXldyjy/RXcJ5kPR/mIgRhonYjR0oUNrrWp6hSM0aH7k7DaVfOAmizXnadiPlacF4A1QxEIHKLY/bKi6np+i+NmhvKm/bQvLbkvV6QyeO4bKoJ8/KwjshAzmab6RHb4BCaWARQ+WFr4s3xeaAkFB/pGP7HjQANV6IuDT3gGMQIrdUekp/HK699lcSPAqtKbE7UWNxXnC3vD6O6B+TES/X
 atZaIP6c
 lwiv+7XYFBe02GGEc/sIyqEXq9xGls6VLqyuc8XtNfDZLDw7hqqyzieGezM1K+ZTYmVnojWEec9q469EhuxwZrHxeYAVvdL79gHtJL1PRSTrDizCBAc2rZ4KwdppeSBvQ3ZUQBf73+WZvb/PD6vpLJAkbGI8TwfGEegxQPild0eVe4u8i8jYRUb0QWGKj7DiXV63+fayogBQXQzMejLi9K387zep+EafzjyzzVkrwiRxFTI4hHJqbQQrXBTpoBvc8ZjDsLjq9m2AL3Ow=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We already know the slab passed in is a valid slab.  This looks like a
sensible check, but all callers assume or check that the page belongs
to slab.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 8fde324cd308..6b0ce2677d32 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1510,11 +1510,6 @@ static int check_slab(struct kmem_cache *s, struct slab *slab)
 {
 	int maxobj;
 
-	if (!folio_test_slab(slab_folio(slab))) {
-		slab_err(s, slab, "Not a valid slab page");
-		return 0;
-	}
-
 	maxobj = order_objects(slab_order(slab), s->size);
 	if (slab->objects > maxobj) {
 		slab_err(s, slab, "objects %u > max %u",
-- 
2.47.2


