Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9E40CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 19:30:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C32B6B000E; Fri, 29 Aug 2025 15:30:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09AB86B002A; Fri, 29 Aug 2025 15:30:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F19446B002F; Fri, 29 Aug 2025 15:30:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E0D596B000E
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:30:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 893E8119CF9
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:30:30 +0000 (UTC)
X-FDA: 83830786620.08.0583515
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id CF7A712000A
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:30:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qJs0fbna
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756495828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MesnM9ZamXMi8T37uC8EszxIl1xk3pSu9NxpWjKejVM=;
	b=25anc/H8dSZE9N8BysxRW8neO6J3Iey0MwI+BS6ZowiPz2Gz2DzI1ndIOwsYblrUENVKh4
	+uFBp0dYbDol2rnFEKFOGmHU2Q78g3en7v7DRPCkNqQ9Nmme5b2Zl22dFxSk8FBcMeAql2
	E+610lwudMjFMlnoTkdlros5/z5ANnA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qJs0fbna;
	spf=none (imf29.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756495828; a=rsa-sha256;
	cv=none;
	b=I9oAjAUKJ2E5jlYG2wqMX3WHvDvnRZ2IuQD4Bidvuv1XG2jkJinlSJbXUIoJVhi9vtxfRR
	pBZDf8re0pSHF6f3E4zCuurqlTsV/t6ixjJlSFUNW9fkjiOj9CmM1gVJIZAVNZbARvFWWp
	0FlpbENWH5czXdyhEwPBSoO3NXIRVVk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=MesnM9ZamXMi8T37uC8EszxIl1xk3pSu9NxpWjKejVM=; b=qJs0fbnaKOmhICfnjB6/f/MOs1
	h3zfsYxSKr46Yz6siO68BJtQJK03KRFrxEq1ZOuv02pyZMW68NghMpGot5vgtiKyifFpismBeZr7Z
	Y6zkQtpXkGK5AVT2kbf6EPAxQfa1gX92bfEWETliQFdh8Y8JDgzbUS6ckXacLrHF5AbOuyuqVj9iL
	5iwU5i00ecuZXu7Yc1+G/Gc4DMiwx1pt7ysMlCnoCZ6Yx0b5+RUXeqAOvNjna91V8uePEhSo9JTCt
	ktIxsX4nA1C7zHcthdGXmu6okgcSuxsFfsCB2Batspk8acHjXw8sBDkZMuxO901w4ag0tWi1mXQ/L
	BAxFXqQA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1us1K8-0000000EFyU-3E46;
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
Subject: [PATCH 21/22] slab: Remove references to folios from virt_to_slab()
Date: Fri, 29 Aug 2025 16:47:25 +0100
Message-ID: <20250829154728.3397606-22-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829154728.3397606-1-willy@infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CF7A712000A
X-Stat-Signature: 9boh7rya8u4hty591tnfsn94atphcgxe
X-Rspam-User: 
X-HE-Tag: 1756495828-424689
X-HE-Meta: U2FsdGVkX19mWZ2iUMbuicpYZ+ZUAmAq3haT3SGBCMWSIx+v/TITzzp13YZbG56ilE5XxqWvbYerTSJKW9ZElHlt1vmPBWK4KMGSq2ADODJAZfsrJiJRys8iAFr9sFzZroxs9TivoVGEK10UK/oeQ3Ppgzn7MOM5atycIVRo+ty/2/GAaukgZNR/mEEtozF0UHJdxylmaF94o2eJLf7Hoi6Ix+AM2Bx9THvNWl73XA6R1lLqGCbxzIHwQqCdMeEbeQhfp6p8HkhJQnKkZu9ynZKUOf0zHzgSopmJGwhsTa5j1UzU+fzugqdX3x8Hx7wt1BBZ+MNKMHRtnsafenFW3N8L+xcpJ72ZTMux9n0Y44j7Ght+eBlIvkQRW7Q7+1QKQ21lGP5DoWdOhjxprCh35IhIy4qQVCUygkKMraDL3WnaxY4JiZBUBFcQIAgfmMvBeLGHQI2xZ8jfEuOJdvajmhaKUMoCgqiIZ1i2jOYFhaM6YnH1nHddG42QoPugHmq9qQbSdD6FOULULxD2GSbgHLeVBDS1GmC36wx470UY11lAEeDnhkbPSkCd1yVQnnSgOfBmWxyXJx6S271dr6n4ZU1bft/DWMFyohZYcBidcz14FOxu4XBd0m7Yk/CR2g3gpdn0zdpWn/aqn6q0NLBNQCdxoxWkyHjwgpf6O48V0yCMg+mbhk10l8pgGeYTGgb2ubuu5SqComhJl7iqAci478kyurSs3E6c+HstVbRLiIwmD9NO07HLMiXvWFxtw9nyKGtb1J37rdMQVIhB6wISwhBAkwVXYlprOemgy2IO0pvZYvFCkSO0uNEyKHyi7AdD2hU8VJWOko57NhbLunYOoEWui1EPhB+FuZtEQb6gumayd+imhKYwxN82J8LMA/f4+4FqKQiBLe0aSTocjMC37f4qBcYz7mR6J2zznmsU2Hw0cd+iGADAVyb+a2knYznSuwVekHv62g7RbI6QTtU
 gpxdiyPr
 8LldeXpNdp6i71/wmTg4kJiICviSAh18KW/4TLdE17KwFmbwkS5os+ucAElNd+2ZBslLJIVsWprHAjZNx/roEpfCU6zcm+o0htCyCK+k8rs5qZZnc9OdY/9z6YXt1U9wtP5MQXYqOwMHJEmdlmMJKQi/XygEqbc0/CyVCsfVCO7j9xKULOk+M0h8JiSLZCRCioXEIAC96Oa9NaRJ460Pthd/f+CCCeBsKQQrahYKv8FTU8DE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use page_slab() instead of virt_to_folio() which will work
perfectly when struct slab is separated from struct folio.

This was the last user of folio_slab(), so delete it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slab.h | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index e3a85318a6e5..1b5639a148df 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -113,19 +113,6 @@ static_assert(sizeof(struct slab) <= sizeof(struct page));
 static_assert(IS_ALIGNED(offsetof(struct slab, freelist), sizeof(freelist_aba_t)));
 #endif
 
-/**
- * folio_slab - Converts from folio to slab.
- * @folio: The folio.
- *
- * Currently struct slab is a different representation of a folio where
- * folio_test_slab() is true.
- *
- * Return: The slab which contains this folio.
- */
-#define folio_slab(folio)	(_Generic((folio),			\
-	const struct folio *:	(const struct slab *)(folio),		\
-	struct folio *:		(struct slab *)(folio)))
-
 /**
  * slab_folio - The folio allocated for a slab
  * @s: The slab.
@@ -188,12 +175,7 @@ static inline pg_data_t *slab_pgdat(const struct slab *slab)
 
 static inline struct slab *virt_to_slab(const void *addr)
 {
-	struct folio *folio = virt_to_folio(addr);
-
-	if (!folio_test_slab(folio))
-		return NULL;
-
-	return folio_slab(folio);
+	return page_slab(virt_to_page(addr));
 }
 
 static inline int slab_order(const struct slab *slab)
-- 
2.47.2


