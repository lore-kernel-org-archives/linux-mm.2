Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93C65CD4F26
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:09:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3519B8E000F; Wed, 12 Nov 2025 19:09:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3291B8E0012; Wed, 12 Nov 2025 19:09:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 265998E000F; Wed, 12 Nov 2025 19:09:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0FEC88E0012
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:09:41 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C6246140775
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:09:40 +0000 (UTC)
X-FDA: 84103650120.03.C62E827
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2374A40005
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:09:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=GHmtUzxl;
	spf=none (imf12.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762992579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NtrdOVTvytdbzLtTPBJPfuXb/Jjppd9vDCLKsL+xbiQ=;
	b=0qHxqBmBRl3Jx6tIiX3h9tTblAwiFmzTCdpLRMCR1UewGHSsUphsLUMvtX8XEmr8dyLQ7p
	aTR0U1CQssAuRcWRWfc7Zb2tNnAmAHso79Nu+/n/mIpg3jahVcwG+i4ZjuJfb2PXdqGsRY
	VszIr/Z9vOashh6Ngzdib8Q9+kjBDR8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=GHmtUzxl;
	spf=none (imf12.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762992579; a=rsa-sha256;
	cv=none;
	b=8pEZsobA4o4rV6wMJ6VosNT5VHELk4zOzW5thY0eCLyJ9qRw48PzsGYnSbCsLTOkCP77l+
	k9nIN+XPHJkAT9O/wi+T/xvgp0JbhePqf7PFD4tvzjXFCyEAXrU0WJSzHQmmBfrNX+8CNH
	+dR6WfKW+dEGVG9l4g9QFy0rEZey4lI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=NtrdOVTvytdbzLtTPBJPfuXb/Jjppd9vDCLKsL+xbiQ=; b=GHmtUzxlQN7gXEDL0MrkkTkzNq
	wckPjajDG5oknUCDUq9xStdoemNwExaIgjDpENpfBV12lZ3HqJ2cOoDxXUOewg52vIclpMyyYkaoJ
	F8TW0+LpVNrvatq1qV+LhBDHN9OplCsWwsr+7fwK0f9Snv1Q/6rLKxuTKJzt8kj8JrAY8cyCRyJVM
	hzHbVv2jYLVz8bqH1SgTgDwN/mF4axeCQW9cC8BESLVjYhv3+gUNhQdQBlkcKd8XozrcU14vfz/CM
	aH5KBaVX9GHIIaGJOAsM4q9TAqSbVrT2lB4prtpDUkmT9La48dEsWKPHxwe/nUZBrkAEnIOfgIGuv
	0yaKG+pA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJKu7-00000006fPJ-3pLc;
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
	David Hildenbrand <david@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev <kasan-dev@googlegroups.com>
Subject: [PATCH v4 15/16] kasan: Remove references to folio in __kasan_mempool_poison_object()
Date: Thu, 13 Nov 2025 00:09:29 +0000
Message-ID: <20251113000932.1589073-16-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251113000932.1589073-1-willy@infradead.org>
References: <20251113000932.1589073-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2374A40005
X-Stat-Signature: y66o5jgqt6zbyy8hjtpq581jbpnf8r66
X-Rspam-User: 
X-HE-Tag: 1762992578-753051
X-HE-Meta: U2FsdGVkX18jdNwqTdMGkfUhWrauwEO9ciy3wcBvuquYNm6rt/1xIqDa3pO99knHCxrqicKgoqCrG0csqF9RWvikno8zKLp1idUdhlzEvZsu2sQYpCuql/lXkknhrvNcO3us2r0lKD84g3gWJZqh3D4A1izLW3vkpvhbyTWCivAOBXBrAWb8h6PYU73wNX83X+aJiWZLQvdMZb7d1pX9PPUok3bhLv7KgzEtOoc0yAjj/IpSuDpidCMw5wu2uvbel+ZhffROiov61Xd54y0GpPzXN4mSDOC3GAsEVEX21lscD/5asLpV4+GgUJruRtq5qV6dJa7/XyoWLf5UCieffzItaEOh8QbCWASeGv21KVl/bSteVb2z1pLniz1iFKoxFeJl+/L33WSD71HzJegQT3cZs8UF6BSR7kKq+pl86F0xcyxwgZ7eX225L+ZwL9tnK/NdSbg9t/oFfRTIJYcl+raqeHx4cd6qRXEWm0WxInUyzz+fHAshFgB9h5upx2S7+q8T5bpdSbdmtamAdmnhJP0R4S5lHJjB5xWG9Tduh5PX9t53RmhjZu+rOmX9Z0e6m17ibMiQI3i1Sg6VvzT6HlXbpqY/byLthqtDiIjNvLIpnrx3N1V950pnThpAOX4CZMV7Pn6HkuI7VCG1X+Md9jUCPSjzr1QWkdefqGUi66HqeommjYDRnrdsuXQFLk8mTr9ZvHzvhPdBHReFAWMgYj7FFzqD91yXwlnyVgQ4wkJSGaqKulpH3OXarTQlJVw8ArhDd4k7AJxHvAz3ZPvcCbrfrSvVzZ0/leSw8AGI4Fre+Qy0iKHvWfTnC8X71+eDnOIMH9kJgeasc1fHK+huXnvYx1sNu0AE1pkoW6OkYiOj6lrtF1iYolrxwWvOroMV9e+6eXGaUTIE/IR6r67jQCB83YBUyntITtZO3eT528Hvx8uk4jka7pcockXZcWnubV6QesZV+pJr+DAIz9X
 3JoRNGaW
 BHWLrAj7g1JR/uq1EmK9al2inxdKuZPD2HkzbTzAEBW1QV9QaL1vVPQoAk5gP8wzYZ0l+klB8srO6cekgYXwEr+iqczFpHyBagWGjTNY4gCwTUQcNuPbXHjCjF6MEl4PW+Y/RELO2Z9ao/7rWYS68MWwdK0etNRyRQHCtHfnnkEgtT3rBxBGAiG9OrKP8ZERmlU7XUT33+rdbg9RsnpCZH3ePV6iS1DpuVz4Bjf1vDD1cCn1dZugeBjPH3HQHZ1sURYps6tLsYMscfaL7xYpgTIQi35y+IrzujfCUpvyfhfzD8rXPKisg2nMlt1JW5Cr5yecqvhZs4DyAxNOG0BlynWvHNK5FXisM1JGaPKTQbMpsuVvuAn/dMNQaqj9ZDy2RqJ7pntBvGf99kHURJ1OAH5pahZRTccY8e7OUUeLCjNuzdvGR5Bl2tkGJ6/nnN7VK4i4NPRqiMACLL1+UszzpVSmk46N2ZN4+t8CCb/ArXIHBMdbuf5qTrzBSCQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for splitting struct slab from struct page and struct
folio, remove mentions of struct folio from this function.  There is a
mild improvement for large kmalloc objects as we will avoid calling
compound_head() for them.  We can discard the comment as using
PageLargeKmalloc() rather than !folio_test_slab() makes it obvious.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: kasan-dev <kasan-dev@googlegroups.com>
---
 mm/kasan/common.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index 22e5d67ff064..1d27f1bd260b 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -517,24 +517,20 @@ void __kasan_mempool_unpoison_pages(struct page *page, unsigned int order,
 
 bool __kasan_mempool_poison_object(void *ptr, unsigned long ip)
 {
-	struct folio *folio = virt_to_folio(ptr);
+	struct page *page = virt_to_page(ptr);
 	struct slab *slab;
 
-	/*
-	 * This function can be called for large kmalloc allocation that get
-	 * their memory from page_alloc. Thus, the folio might not be a slab.
-	 */
-	if (unlikely(!folio_test_slab(folio))) {
+	if (unlikely(PageLargeKmalloc(page))) {
 		if (check_page_allocation(ptr, ip))
 			return false;
-		kasan_poison(ptr, folio_size(folio), KASAN_PAGE_FREE, false);
+		kasan_poison(ptr, page_size(page), KASAN_PAGE_FREE, false);
 		return true;
 	}
 
 	if (is_kfence_address(ptr))
 		return true;
 
-	slab = folio_slab(folio);
+	slab = page_slab(page);
 
 	if (check_slab_allocation(slab->slab_cache, ptr, ip))
 		return false;
-- 
2.47.2


