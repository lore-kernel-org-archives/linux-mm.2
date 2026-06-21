Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FB3CCD98F2
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 15:58:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0EA66B009D; Sun, 21 Jun 2026 11:57:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D720D6B009E; Sun, 21 Jun 2026 11:57:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B004E6B009F; Sun, 21 Jun 2026 11:57:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 748DB6B009D
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 11:57:38 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DCE00A047C
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:37 +0000 (UTC)
X-FDA: 84904374954.04.36F16FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 599C218000A
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ofNK3KGp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782057456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AJ3stxT6aRCI9DnbTthOdJWIipgq9UMulRZrQF4jmXo=;
	b=C/rNvve+26yKniWulUIPLJn+L/67E33Bju1Vak1hzPxUVsIz1xKrBGa5n1489jgDCjosNf
	isa9Wt3e+thZuNfZ7V5wPKaR3SCmn5/wdTzjE+qPbw/ibL8GxQj6zmZUwULDjccYEk8r0K
	vhfqmiQnw++vU6Rn0LB7s34winWYGUo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782057456;
	b=LeK2PERMjZNs2bFXfGcU4rP73IgVFxthd+kwZ+E3jOalw395t7tSwYfk9xHebH5Ux2In2d
	Urg4XeiSXHfVOHhJG2hlFvascHudNPA4DZYHKr++m+FyjHQ/QqFOhZ9wifOZl+BYFIxMBu
	M/Cuo8hnyRUIqBwtNe1BKB8b9loDm1Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ofNK3KGp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ECBD7601F7;
	Sun, 21 Jun 2026 15:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4861F00A3D;
	Sun, 21 Jun 2026 15:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782057455;
	bh=AJ3stxT6aRCI9DnbTthOdJWIipgq9UMulRZrQF4jmXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ofNK3KGpvnR/g/IGjlCw/xf1+fltfCmEYDyg1gR9MO0Q8uerA9pMgo+mZrF8h42fG
	 m0J3amdg5+uZ2hyW+W/SfhIdybyD/KdEq9n0KiToa6ywbJ+xTdk2ele5DdXeAn2+lR
	 6qRwjgV27ktCi4c07vu1mA97duK+Sbwyl4qILClctUqPzcq8RM2WRM51LBuj675IWP
	 9DXpyqsqWVM8mpqiEsH6eWLTD12ogpalhTT6QV/fXVI62mQtgHCbxzSGhL9OJHLPZo
	 54wKwEQ4e0ICU2lRBdB4SM+OYMhahRw6UaI8eCYX/4W32waXClBZOG/OZuUfCr4Tmm
	 tSEJ3nxb3npCg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 09/17] mm/damon/core: remove damon_verify_merge_regions_of()
Date: Sun, 21 Jun 2026 08:57:05 -0700
Message-ID: <20260621155715.87932-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260621155715.87932-1-sj@kernel.org>
References: <20260621155715.87932-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 599C218000A
X-Rspam-User: 
X-Stat-Signature: 7j9yt91unhy7j8tps8qdeocgwyxej6am
X-HE-Tag: 1782057456-43852
X-HE-Meta: U2FsdGVkX1+SkFJyMuiqvG5/HV+JgTjEOtx/IPcVpaBhRzzK55TM741THEhpoqfzsXfMlClSOJ48xKehlvreEKIjZo0tcS6Q7ZW0SX/fSMbFDBE7qbdXFHznV1VAI8qs95pnTbLhz26noPPnJkFNedbiKojekQKWo/SqUy/jVgvOV5shVRT2dmJA/8U3wgorqxa3p5s7Q6J6QJvt/1wpk5G+67gYgl5Xq1BtNmpFyOiQyQcjj4O+z7h7iVVushHz+vau9VI3Si6OImkQr6PWxerltN8Z9QQ+TXzZwydxki86QCHq7xRm4NcnfET+fORhDNnQOy3aCrFqlmakQXPT2/xw7FPMWuSpv4oUzf4G/XMeF80tIwLuli+z/WB/Xyur5pPZuMog43iQAjZKXQBDidwI5LaA0dpA9i5/D54BAM+XpyROI1CXuWAsf+WAN0NBWu56JTRknYmwqb+5KzkKVa2M21iy+eQJO4T6UMLQdv47HuDc7/YXioQUOFE5zO96T/PXV2MMcBf9o3LrJ0aD+ceDtQy0N8QfFBHceXmRNM9ULwySVmnWGCUXyQkjMSssPIGpAFsoqQo8PoXfLAP/Z7mn+T0SErs8lZ4piQWQ0VqEjdxgqlVC0ZH6sXHZ++ShNteEd+unhWRvDvoJckDelk8JPilW3eB9aFmwCzsCJsbtdFJ6HLVQSmTwGsy+4jf+vfdSL73PVLbB9zTp2cBzQBTJtXWZMhvRp/DTyHIo1svHfQvhxZxuuDGa09Frq/fQlJtxmp/VO6gyVnjQbJUYJfhyJkR7R+/W8TS6PlwiPHTulbhQs5mH4hPlUTLpUxW2hJnj7/miyNEQ+p80vN8Ow9XOMJB0+cFcbaRBZdCQreWxuRhzLxZLEeXww9OHgG90lee7bDTj6Ns9XjBY/PT12RpfQhZv1nn6+bp8kiA9QEFFQE62lOr9727wcIMjIvRT25Pl6nnMzRCIeRLZIXY
 h9NrQqxo
 bI07dRYUQ6CS2NnjO+J+sy7q8mc4OC+eFXa9GljVZnhFd31qU3ZkDzd78U8TY1OuQyFZGNvep0a5/VTZXfalr9shEmjvICCxPFx7RxzoDp0ks38GpZw3esoF0pe7zvvDEoYZemnvOQWItOvpNr+v49nq2VQyFcTuW4gE1twLYV/hnn2oRabDnHbAxlQZa2Xs096Se34MkcpoQdxj8W6QqvAMOvtKq7qxfvNepMesIRPx54MlexjS7B1qplXojkZnXlghjizX0j7uXdmjGVd2FIkzsIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_verify_merge_regions_of() is only for nr_accesses_bp validation.
But nr_accesses_bp is no more being used for a real purpose.  Remove the
validation.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 7bb9b3c32d6fc..76ac58bf3dff9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3114,20 +3114,6 @@ static void damon_merge_two_regions(struct damon_target *t,
 	damon_destroy_region(r, t);
 }
 
-#ifdef CONFIG_DAMON_DEBUG_SANITY
-static void damon_verify_merge_regions_of(struct damon_region *r)
-{
-	WARN_ONCE(r->nr_accesses != r->nr_accesses_bp / 10000,
-			"nr_accesses (%u) != nr_accesses_bp (%u)\n",
-			r->nr_accesses, r->nr_accesses_bp);
-}
-#else
-static void damon_verify_merge_regions_of(struct damon_region *r)
-{
-}
-#endif
-
-
 /*
  * Merge adjacent regions having similar access frequencies
  *
@@ -3141,7 +3127,6 @@ static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
 	struct damon_region *r, *prev = NULL, *next;
 
 	damon_for_each_region_safe(r, next, t) {
-		damon_verify_merge_regions_of(r);
 		if (abs(r->nr_accesses - r->last_nr_accesses) > thres)
 			r->age = 0;
 		else if ((r->nr_accesses == 0) != (r->last_nr_accesses == 0))
-- 
2.47.3

