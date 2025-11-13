Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68FF1CD342D
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:10:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E13028E0018; Wed, 12 Nov 2025 19:09:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3D1E8E0012; Wed, 12 Nov 2025 19:09:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB5D98E0018; Wed, 12 Nov 2025 19:09:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A47168E0012
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:09:51 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 724E41A071F
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:09:51 +0000 (UTC)
X-FDA: 84103650582.15.0184FB6
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id BF9464000F
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:09:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=TUMjbmQE;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf12.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762992589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oGWPcY7YzgOVYSmtol+axbIJS2VNJhoLH+7WfjBDhJU=;
	b=cWAswrLNl0wZ8x0YONoCWye/63aGvb9RcQKyCRbmxl6i2e76ZkOHO90zSUFOZcj41n5cQS
	YYDej5/QLj2LKqGiBiFyWFaHvBDdhLLK2d4tzXGg3a9j4MbYnBfthsMnmF3H7jkcqmWgzV
	DYHHQ/7Efe+bP8W/2VZPI02y5jtkr5s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762992589; a=rsa-sha256;
	cv=none;
	b=42f92Idp7tMEcotWJ7p+SUqAuMsPh6Gmzquc/m6KRorFcXQwzHD9bgZ5xmJ8jv13mR+yO3
	DDB01jE8oQ/nbcqHGHgm1XU8OA1MBAyfI3Qe0XNH8lUfNEmHVIkM68tfLhm0JMpGTtHH08
	pah0NBaYF+naimbnt2yaQaabSBPRRPw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=TUMjbmQE;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf12.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=oGWPcY7YzgOVYSmtol+axbIJS2VNJhoLH+7WfjBDhJU=; b=TUMjbmQEGQHKLHSiCpEQs+pIC4
	EYm0NzgACcdPosnusc3qf7H0z4FYeQkammd2K3hnx/yVMyze3uFLO96ZfCED+Uk0a67mg0sMgiwXM
	KVj6w/2U6PYwnWv8ZUMhwmDTWG6IEXG4TY5Zmjde3KAB1Vl1O7qSW8Nox6uxdSDCdFJGv4D2h8AdI
	N2QwpZ5YbACwtnJndhUGYhXo3pRfwvEhQY+bH1grgAM1UTaBjAXxre2D1XAIHGFIMSdqVQpb4lhGG
	UuOnJ9bBfyuXHc6GCRyghP97QwnbuAM7E7lC6/bz92Zg5ki/rfDfuO9Pv1n4PsG5/Jj6D1jhVNCJs
	Zyj8PgnA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJKu6-00000006fOa-3qMa;
	Thu, 13 Nov 2025 00:09:34 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v4 07/16] slab: Remove folio references from kvfree_rcu_cb()
Date: Thu, 13 Nov 2025 00:09:21 +0000
Message-ID: <20251113000932.1589073-8-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251113000932.1589073-1-willy@infradead.org>
References: <20251113000932.1589073-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w84q1ezd55r3xkbe9nho44h5i7roba6p
X-Rspam-User: 
X-Rspamd-Queue-Id: BF9464000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1762992589-243863
X-HE-Meta: U2FsdGVkX1/Q151nJhpJE6JLRUoGT6RIB40od1OkZ5eXJEL/7OVZV3ely6fJ9Xaa19QCHBSfe4iqE6YNM6KLMIMqEs3A0xZAHE7MMIrWHNneoDFbv+igi+hh4lWpX7/xFz6WIJUw3reQUmVKdt7vgmmTjy1CWy4d8gHDrFwR0f7njBUpZ1WyyXHXYBsTXpkdv5zDF2FKD2Jez34XMnlipz7nx1/h1yLAjbroZM5/pS1ZBgWqWShiXaZRLmSS+6H5ZMV2ZBB940fU7ibr6rZYEhjxszeQZVT+ssB4NrSIBgVXbHu1xG/jMzcc6WPI4GFwDpRx5b/ZbuVryqZvQuF1wjrSsKY/ib3fJmuD5JzlEr5l2++Ri65NM4c3b4Qgv9Lgq/rU6EcoV3JvN384Su3+c9JfiAwub6KUkGqS1X+zK9F4XkPWksotFfQHvx5fonfFopHPmXfiu4pd4H0t4LnXFo+MoFPvekxaWIei1wankMXMdaS0cZPlwKvk2SQ3QbwxKVujFXMHHC40LOCrTsQg3TCxOFpXZfu0oBsTgsMOpl7Vvh7s9OCu2jc+5EC3Ipir1UsRtvzsZfWcQcHNOr8mhnzza1iXK0d2WTsNTYomSGvo/Ep0wH+r5gXa3fpHtXTH4At/ibVkmz9PBwa5UC5VLplIUgxTacl5j4okhx36oaDKuPvxZLa5thzaw8hZQdSDSD5Ej/jwBh1Xr9SgiuEdLpaRjPMzyTNCDGhRvV3hbUjM2W/XiV4tbj4432U43C5g7iyHMUXgQwkeAbzI2w/SRrbyxRnf9q7Fg0bFu7J142ErNf6RSZXgPsIy0NQsavhFKgVe3acv43/Z4eXYxAGAeV4IF9xkI4sz30MM6AOUINwuDkA1Ut0ymOlYtH1BGW4tRRK02Ph/KD2itoTvQNgLVsw+f0mGiYTSElD2gOzjmtFDW7BsssqDE+MFhSQBy7VTRuic0o81dZ8ar3V2Fwo
 ZI2h44xt
 5APTEqD7rECm6eaZRshSIRGi1P0cCAPFpZaCxkseisvekrM0ea4p4GlydgZi2qZvJQclcHDKMG494QVp5o8//ABaPW5xwDnUB2lLX5MMNaIanEc0KaTz+zpz3xCu9dblH3F9LtbZ2GZO82ByjJ05SJ95NVxVVSZhp1aZkq9cD+TDSC7tjZm7zi3MQulgSnHv5kFt0zYrIDVMv4Amrf8bNymzLlw8R2MHYVDYJF+/kOa492oz0PO0atnNm5B8IyHsDiAeF1PI+ne6Orq08gktPSj/EHW7jdrDXpmeZxxJCFu0xvseM6fnBN3Mwrg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove conversions from folio to page and folio to slab.  This is
preparation for separately allocated struct slab from struct page.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 05cb7ec48f09..976e116580a6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6820,7 +6820,7 @@ static void free_large_kmalloc(struct page *page, void *object)
 void kvfree_rcu_cb(struct rcu_head *head)
 {
 	void *obj = head;
-	struct folio *folio;
+	struct page *page;
 	struct slab *slab;
 	struct kmem_cache *s;
 	void *slab_addr;
@@ -6831,20 +6831,20 @@ void kvfree_rcu_cb(struct rcu_head *head)
 		return;
 	}
 
-	folio = virt_to_folio(obj);
-	if (!folio_test_slab(folio)) {
+	page = virt_to_page(obj);
+	slab = page_slab(page);
+	if (!slab) {
 		/*
 		 * rcu_head offset can be only less than page size so no need to
-		 * consider folio order
+		 * consider allocation order
 		 */
 		obj = (void *) PAGE_ALIGN_DOWN((unsigned long)obj);
-		free_large_kmalloc(&folio->page, obj);
+		free_large_kmalloc(page, obj);
 		return;
 	}
 
-	slab = folio_slab(folio);
 	s = slab->slab_cache;
-	slab_addr = folio_address(folio);
+	slab_addr = slab_address(slab);
 
 	if (is_kfence_address(obj)) {
 		obj = kfence_object_start(obj);
-- 
2.47.2


