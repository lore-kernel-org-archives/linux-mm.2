Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9508ECA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 16:10:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E131C6B0028; Fri, 29 Aug 2025 12:10:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9CF66B0029; Fri, 29 Aug 2025 12:10:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB2606B002A; Fri, 29 Aug 2025 12:10:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B2B6F6B0028
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 12:10:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 59D5B13A97F
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:10:30 +0000 (UTC)
X-FDA: 83830282620.30.D675617
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id 839A9100014
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:10:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=d8RdTRM6
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756483828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JIPbI76p5MUIqTqNFGh+r3XZjiLM7PeHUw07nQ8t10I=;
	b=YDkSoWlkR6TnYXQ4UH+DES9TOlsOgn1fN7EOUXqLxCruJdV79YPnb1Xkqgi1B3oD/q2ZrK
	cwnKdyNx64NsY1Kwgi1VjrBJkygTOxgcCtRzsbasogiIufKHYSCtWjWjL9FwcT3zlzs2vM
	bPBBeczlVjC3jbR86otMFzJ32lTbmTA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=d8RdTRM6;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756483828; a=rsa-sha256;
	cv=none;
	b=7h72JkQgr9/3JJ8Xwvs4Mhn8KIYv1w6QvUCgd4brxjDNHQl3j20PGyAVwdJvKRAcgaaQJC
	LWnMQKmtKpvGY6KnJQh0XYtz6QXlnelxRs4ccCLOiXqd2Oe0+nFyVG/ac/2hBp72LiMxuc
	N/STmyKw3FTzz7ihDguc+02zHUo+qm8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=JIPbI76p5MUIqTqNFGh+r3XZjiLM7PeHUw07nQ8t10I=; b=d8RdTRM6Nh+Fix7TxfHTlsefAb
	Gj3bNx+CIJqwslKPJ0PtLc25RCbDBhzK2coM0BHP5SdKe6ZjEMrlcpEDUfRsLQi3aCullCnBZsG8M
	fmOMmxkv7XjwDvdxDBEWDV9Ox87im9NNivGIK5VW9rWa2HWMmso7lBjcoJ8ixepk4+vPrRYDkF3Tj
	kXKip+oH0fXp9qAjoksCXCHkfwcug+9Y3gQvH94ovwExE6YHhwZjftQt41Y5AcYFMgPs+pw7N5/ji
	4nOlHt/jicF39NhL6Js1VtFysT7usrCr/l5UlN9VW5ZNSzkuory1eC915AmKwM88xbIIl6woNcLlH
	7iJmnBwA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1us1K8-0000000EFxC-0GfT;
	Fri, 29 Aug 2025 15:47:32 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH 13/22] slab: Remove folio references from kvfree()
Date: Fri, 29 Aug 2025 16:47:17 +0100
Message-ID: <20250829154728.3397606-14-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829154728.3397606-1-willy@infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hpohiapzwc4bctixbtndugqijrf9aish
X-Rspam-User: 
X-Rspamd-Queue-Id: 839A9100014
X-Rspamd-Server: rspam01
X-HE-Tag: 1756483828-646400
X-HE-Meta: U2FsdGVkX1+d+ldzZNPMyTjHiepvPnLaRB8dYtLJQ86VjPNeNG56sc3kpNOQ683g3hPg/N/y3C7e0LJDNFeYia/+q9FfzGvzd+F9dN7uE/HulOQ5hN4kbwFxxUL4av2EPRr1pIZYOk1ErOPWUm7Ym3Uc4JryY/0VLtVRpYet1hjVT567VIqTeuy4EwpNj1HzoJNGkGE6vfy2RmiR7ULGnn7lXL+yZ2yQVFd+W7o3zhT/lSb3MoQOx3kJfuvRA/QOlX/2Ck0unUqhYO3n67F/YBLEW5LmtuhViN8uFbk1MxCS9tE+dr1kw/xCPZlBSbtl8AYF6rc150tAnFypwC7TidSPrL1LXP+CZeGT0HD/o254Wu6sdqd1jXouGNSIuHJ8mIKNz3744s/K7mKLyYmgPzLgewSE4GoXqx1lgBdI5UJ2MeO5CgDTD80CkrXTy/QhMPrSbKwNVwkl2PfLJhYukW9qfdBajVJf8xQBxqaFymvabHuQ3yR+hZ0helhO72PlQri7nEEKjVYhSiOf90k2XHcF9611iludX2BbahtdXAclzOwdRYxIWK5OJ0OYXyHmvPyM+Xuf+rLPEsM6ulKC8aYwVBIo4tGfdf8OSW242deebkXLL+bG9aTVa06my8OpfNMvfR2/dCgxK6iYMVdHgFGhsitDfwwBJMD86vwjrwoVnvkZK6ycB/BlYZdNSWfFkohE1oPjU6jooI8PTAU7Qe6e2pEH7LKe37BpBfObE+nyBhqNcQsAce8rcpLSetsXr9rd2zwOntqAm/WF2HBMFUk2RwvJ1UupUYb1/PLmI5grNacCMRJuvGHwIxOpPK8bvt7zwgjMcPd/sQwL+Hc9I9/ssaL1d1ebpzcFtfrh+wXAYbx/XrkfxiJ4k63LCLUzdmaqJcEhUKbaydCgX51kt3Bl4yHfpl5syQvRiben/y+v0IfIKlPNdUwOkTDPfcS2MMfDC9nbQkHS9A22YkX
 +vGl8te4
 SlEPkLbW1cEeuitKc9lORFKSS8Qo07xD0By47qHT+h+aOrk8JzXfcgrSTyA4MEol0PktWUrp7v7aSJua8u2Sho4Xm52jQxcNCnq7ri714vlGKJuufIS11FFmOBtLFmQ4ctkwFHXdshWYCTxA+ZgmaOsF7qA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As with memcg_slab_post_charge(), we save a call to compound_head()
for large kmallocs.  This has a slight change of behaviour in that
non-vmalloc, non-slab, non-kmalloc pointers will now cause a NULL
pointer dereference rather than a warning.  We could add that back if
really needed.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b344cb0ee381..e471716cbde3 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6270,7 +6270,7 @@ void kvfree_rcu_cb(struct rcu_head *head)
  */
 void kfree(const void *object)
 {
-	struct folio *folio;
+	struct page *page;
 	struct slab *slab;
 	struct kmem_cache *s;
 	void *x = (void *)object;
@@ -6280,13 +6280,13 @@ void kfree(const void *object)
 	if (unlikely(ZERO_OR_NULL_PTR(object)))
 		return;
 
-	folio = virt_to_folio(object);
-	if (unlikely(!folio_test_slab(folio))) {
-		free_large_kmalloc(&folio->page, (void *)object);
+	page = virt_to_page(object);
+	if (unlikely(PageLargeKmalloc(page))) {
+		free_large_kmalloc(page, (void *)object);
 		return;
 	}
 
-	slab = folio_slab(folio);
+	slab = page_slab(page);
 	s = slab->slab_cache;
 	slab_free(s, slab, x, _RET_IP_);
 }
-- 
2.47.2


