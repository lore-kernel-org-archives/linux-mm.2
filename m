Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02331CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 11:55:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5031D8E0017; Wed, 10 Sep 2025 07:55:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DAFF8E0016; Wed, 10 Sep 2025 07:55:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 417548E0017; Wed, 10 Sep 2025 07:55:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C1388E0016
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 07:55:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E1266160869
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:55:19 +0000 (UTC)
X-FDA: 83873185158.25.7499D67
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4BB0B180003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:55:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZqPvCqRi
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757505317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jsdwP8oAFO1NFnewF1gHhlCMyHlIdIQP0/1rR5dbpRc=;
	b=tFns/KpVDwXesIB4u4SDaRYXb50aB56TGa+9sLuAB8PAN3Ke+rC4IFj3uPP8GE/ioYlUzw
	KRzQ4sL1RHHPyaXKdK3BM6jM5lKSAgIz4DUy5MzCoBT6tgGI30HJ0s0UeOF7dhZluHCtRr
	yB/5LmTABSdDhKDIoWGw2H7mBcFDNF4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757505317; a=rsa-sha256;
	cv=none;
	b=mULw2hAiR6bJKqaHl1xEl3TbGnKJL+pm5YAZFOTsRiw4rxX4VHvL9lKmunJHinFpglkCqU
	McDaN4JjNWC3z8yRXSwQEJj/IzbE32Cfh+5/aRQC766dWIIDpqaPKGjbYShzP1dPdgvWgv
	Ev7ZT+uKALD6YHsWtm516/PiLDwp9qo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZqPvCqRi;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=jsdwP8oAFO1NFnewF1gHhlCMyHlIdIQP0/1rR5dbpRc=; b=ZqPvCqRizjXCsI+rGv2CIModO7
	3gegvnzJdduaFZ67HktaCgSLqiAwg57o/4Y1vho/CSv0aavo9N2GReZZuUIS4Q3sE4z9/hwpSPd8O
	It2EBwzgKy9J61bF5NUEYfpLgnU1Dc12wOxsrX8Qx1nwwOjZMFsOQosuvtwEO+UU1oFEy5eqznm25
	+FIbYZFt3JxtdO1jqaYYcCpjStYy7GUdKkiTQtBKwiFySwCZsfaKFilqpSmtqstsKgAhkknehWBUS
	1O4c7PtKE4BTk4ZdYZUvE1jvWd+WC/Q0cZN0yh0oQms0ye0jll+/k5fjYMeLK2FxNhxUgzOVWapB6
	S5OkoXew==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwJPq-00000008MFG-0DaC;
	Wed, 10 Sep 2025 11:55:10 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v2 13/22] slab: Remove folio references from kvfree()
Date: Wed, 10 Sep 2025 12:54:55 +0100
Message-ID: <20250910115507.1991829-14-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910115507.1991829-1-willy@infradead.org>
References: <20250910115507.1991829-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4BB0B180003
X-Stat-Signature: 363qkcspzsopwbnwdao4e9g8h9towq5y
X-Rspam-User: 
X-HE-Tag: 1757505317-515760
X-HE-Meta: U2FsdGVkX1+t6dmup2kCONhDQk/oA+S6i0trwziXRWCt6Hi9qVoGb+VgvIK27WAyXPQyncGILtQgliI7BuG8hLhuDOTuu7L3gpcfww4le9sZTKrpjJIWVGYrm2JSKyA3TvC0+yrFUNAmSq0tE/nZxkJDAnqcGVoPQlOQWXZ9/IPIXP4Vq5JTNBmehSyZK1Us1Jjt5HvZrNJ6RXV3ZBn14vC1LKMwTNoatljWVPDSMXDRl8cNTMdba4zJkiEv/gN9kGo3/2r+Kl5e+9Ty1QrGO0bCgyYxbN8Fimz5GOciQ2BdhT14HYAjiAiCXZBJVr5VVivyeuKqASq/Ta0TjuWiB9B2BJCklAHi26XyLVDJT3CKZXMGIn6e9yl7t+0ecY8wSEKQdPd1mCoppCrAKXFMvI7dRPSiDW6DnW1jiAXcA2VgWBSQp9f1G/KQZ2CIz4InHSimFm5q8pof8w/T6x8mPWHGQ4BuWqHrO+UVZyn1mMs75qnF/F8bv3/JuWPcSqMDmS2SRAMbdy2zhfxrhJpXRdRCFDqeS2APdlM9FogEwisdBjnn8FlVIfdev8v4jBWZIqWDTd2PF3REKWUJ6igXWmVPRmmjxDzew8Gn0gXFPbd0iaq68q9IMQpyqRAM5dP1xtag5rkZzoopp/y/rbzLHNDYjyCI1rWcSQ2pGijewRzcn1ZPyhHEjc2uohX8lhzql0p1UvPSDxo6MbatprkdYTTmX/e/cLKgvf10J6k7Io3qb0rgAFtC1QHYAUUQ2hPb+FVlL3Ww9tABrF7WoCi/eIu91XNWMaTRbrsUry0udXch35eJWejh4v9SuZx0+cGfBGxnOuY4lOWOZM75SBdB8YdJG+HxJosmj6aeB8zw57jOMnmHK566Nn2UjI2e651s5CyvEdLbYBnhyTrBQ6Lxj7aOPoLVRCMSAFF50q0KM1gHcTjc0spSqvnvELPz9S/L+I3fVDsh0xAmbA33Ggd
 ygT05wIv
 7ADdWXmODq+mwXqT2N8eupkT+X/s4nrt9hRBlq8zBzQE6iG5h8h/yk9CeKVTufs1DlYav2N3K63WboU1G2KnsgE8SNlPv2XRVZKkF5+gAjqxAEhyUHvKoyWq4G+uUwNWoqPioMr9GzJzoDRnmeVtF5AybBQ==
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
index 547ef6ef4373..a06a86074170 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6298,7 +6298,7 @@ void kvfree_rcu_cb(struct rcu_head *head)
  */
 void kfree(const void *object)
 {
-	struct folio *folio;
+	struct page *page;
 	struct slab *slab;
 	struct kmem_cache *s;
 	void *x = (void *)object;
@@ -6308,13 +6308,13 @@ void kfree(const void *object)
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


