Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7E07CCF9E9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 20:45:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 316138E0111; Fri, 24 Oct 2025 16:44:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29DC88E010F; Fri, 24 Oct 2025 16:44:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 167EB8E0111; Fri, 24 Oct 2025 16:44:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E81F18E010F
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:44:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BA79F1A0F9A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:56 +0000 (UTC)
X-FDA: 84034186992.17.9A7C4AB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 28989180002
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=LjuPZKmX
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761338695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R4X+zR6lI45/5rlDTAA9+2xaBiKCA51RZ3jUb4Z0J6s=;
	b=02hYyAWTQY4oEdzUgTY5WiZj9l22l7yWszKc9QYa86Qu122wcJgJhX7M/S36ngd5PghePB
	ECfhlZqKFZf/mCz1GoA0A99GKCZV6hecPUZc9AFP4Sv9EKRGLz3gpzAtui9tLggVn38GaU
	Oy3X/+UgTw4Tu+cnLHcJP+F9zNFeF+s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=LjuPZKmX;
	dmarc=none;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761338695; a=rsa-sha256;
	cv=none;
	b=ZUVanHEG3QUCM8XtcIXNHde+bjK1V6m1J36ZsOTn0v/Q08/EKCm0XdwQBhTFeJxqDkpDFS
	8hpuV8nxVT+KODfgT6vQM6qH6LDquZWFi6MyVcfgPO9XA4heF/mrKcH3ikR48zFyNddSDH
	SVUQnxL/lrFjLBvvY15oW6vZw7+909I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=R4X+zR6lI45/5rlDTAA9+2xaBiKCA51RZ3jUb4Z0J6s=; b=LjuPZKmXHDzItVMa7IYVZRTeVq
	d9uYe9y28gPN8iCyBVME9O/twfcYLkJPpT+nYMYHwPeC7A2FblaHhc4LGarHF5vNFsVZLuEzt1tCL
	WOrUiXZsYQErWX6VHAxmIsGZP3aSmiutLy26R88zbb7ZspuW6KQj/43YKUNd5zU5SIKY6XC5N1RER
	9GsUpw4IHLFIoX7KiHqWHwHlCDbAmRngXMdVoI5TEckyBJlKkYgAFmqdTNubtRpfcqfrlGCqo4krf
	Afk7wW70dlNfYLXXv1YQR6lUlO6Ofk4CFpUEyqGaKjAYUgbw/4K5CTLEP1fpkElZRS1Bp2dmzKTVf
	27a5Z/bw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCOeN-0000000AKRr-3cBG;
	Fri, 24 Oct 2025 20:44:39 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v3 06/17] slab: Remove folio references from free_large_kmalloc()
Date: Fri, 24 Oct 2025 21:44:21 +0100
Message-ID: <20251024204434.2461319-7-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024204434.2461319-1-willy@infradead.org>
References: <20251024204434.2461319-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 28989180002
X-Rspamd-Server: rspam03
X-Stat-Signature: u4ro7u8jkouquuko1qrcuq4w3r5nwt6q
X-HE-Tag: 1761338694-183930
X-HE-Meta: U2FsdGVkX1+l4pCNYnCfLw6lO5GGlLLl/ZN82XrDkluiFbSn/rCYYoS1maTefI3xZNVrJUNf49hOLRTM91rtD8ldG/FA2y3DHdiNWjf0zmUoVaatmiFY5WhbB2Cw7niKu3u2kfDL/b8EhoyPVVhM88GIknzLC9crwKbzwS5IXigSowIFHyBTXqrG3M3KdTaRJd/G1JzzokzW2fWM/Tn+bAMbBoBftlgwIZwTDshhDo3LLseVzsDlzeNOHf1Is8tTfZGGpx/z8cCZFeQ2Fh2E0LS3il98qINLLeRhLQZHwy6nucCHMPL6R/2rRm23MEVsIqd9TLFKOyy5XSe86FUih6AacGsoJjC1a2SUUu077ppZCUeUZ4UuQiZrv9zS2zY5Nda3u4cqefakhKNJxt7xrPcD963LC4Qc/gXUjOIGRa2PhwfxjmfNZwV4O+9qnOZemQxCDFCNDl06ubUQhrNKURpUUp855LuK4D8JuT2N92iD3rzfXqY//zVP3bfH5cidJ3vO0ycSMfO4RwnGYl/ewvC73FCfY3zWSATafztKTUq3kqAhZkJ1+bbegDk5sUUfN69P7+V5EFc6fk0IktZgndqlDL9rDO9/Q5AU2wI2D14OROp0aN3qcWS/1Jf5OiOg32B6PYL04IOV7UGJPHllLDhWm6AK78BhHSPJBRzzhX9EpEiBOcd2wdPvTjoz0S6VU13xhFwUPZA8jiqUtwDN+TBd7+ejNPH0fo5hb8zsuKxxc57CMo2vUFqUFGTvSU5HHbM7Q4FCU0ZoeQQce/ia0b4L74u2Q2Xmemtv9ciC4UpurtG35KBlP9qJsC6NSEd9Ts/EA8CZXIQz1df5zwSwsJAL55/QxDjUCtX0q2xttN6pwrGBiHTt1Lesonk8ouMkHCE8rF6kDHLuYNScmhF19o1q9ZYxzrVXTBxbFag86brCYZaYWdPThPqd22mFk0obHc8VoFPF/09bhmM0Y1L
 UrHADzTy
 wJIptNI80xutGLglB+iKyBw6LguU1rPPcUR2hcrMbpxlC5L7Qo1urD+5iv2UiFTBBea+l6JhaUJBfsCDKjVSxdhZ5vzoYuz1ewcRFo3qAdBAUChZKOiY49M+whI1MlVzbOGcNJtF3NlaGWiCKEn6J1DHVKZH8WHKjktKVWWWoDuo8oiP87mAlgMRbWPNFtBs3RHsDrB9vpSZZJbIhUpz/Bs1ppfQO8IXe0D/bOBeU9f8jDDo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's no need to use folio APIs here; just use a page directly.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 8bf7d818d13b..561944d39be9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6734,12 +6734,12 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
-static void free_large_kmalloc(struct folio *folio, void *object)
+static void free_large_kmalloc(struct page *page, void *object)
 {
-	unsigned int order = folio_order(folio);
+	unsigned int order = compound_order(page);
 
-	if (WARN_ON_ONCE(!folio_test_large_kmalloc(folio))) {
-		dump_page(&folio->page, "Not a kmalloc allocation");
+	if (WARN_ON_ONCE(!PageLargeKmalloc(page))) {
+		dump_page(page, "Not a kmalloc allocation");
 		return;
 	}
 
@@ -6750,10 +6750,10 @@ static void free_large_kmalloc(struct folio *folio, void *object)
 	kasan_kfree_large(object);
 	kmsan_kfree_large(object);
 
-	lruvec_stat_mod_folio(folio, NR_SLAB_UNRECLAIMABLE_B,
+	mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
 			      -(PAGE_SIZE << order));
-	__folio_clear_large_kmalloc(folio);
-	free_frozen_pages(&folio->page, order);
+	__ClearPageLargeKmalloc(page);
+	free_frozen_pages(page, order);
 }
 
 /*
@@ -6781,7 +6781,7 @@ void kvfree_rcu_cb(struct rcu_head *head)
 		 * consider folio order
 		 */
 		obj = (void *) PAGE_ALIGN_DOWN((unsigned long)obj);
-		free_large_kmalloc(folio, obj);
+		free_large_kmalloc(&folio->page, obj);
 		return;
 	}
 
@@ -6821,7 +6821,7 @@ void kfree(const void *object)
 
 	folio = virt_to_folio(object);
 	if (unlikely(!folio_test_slab(folio))) {
-		free_large_kmalloc(folio, (void *)object);
+		free_large_kmalloc(&folio->page, (void *)object);
 		return;
 	}
 
@@ -7252,7 +7252,7 @@ int build_detached_freelist(struct kmem_cache *s, size_t size,
 	if (!s) {
 		/* Handle kalloc'ed objects */
 		if (unlikely(!folio_test_slab(folio))) {
-			free_large_kmalloc(folio, object);
+			free_large_kmalloc(&folio->page, object);
 			df->slab = NULL;
 			return size;
 		}
-- 
2.47.2


