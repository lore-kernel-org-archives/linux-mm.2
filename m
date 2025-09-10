Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B97DCCAC583
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 12:11:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1301B8E0003; Wed, 10 Sep 2025 08:11:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E0F78E0002; Wed, 10 Sep 2025 08:11:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01D9E8E0003; Wed, 10 Sep 2025 08:11:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE8D78E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:11:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7D73D5B9B8
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:11:24 +0000 (UTC)
X-FDA: 83873225688.04.F8C7EE3
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9C21F20009
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:11:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Jy59mXFh
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757506283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mGqnPhD7id+ekgFhW/HlBJ5YeFKgN7a3hdLZmGPXQVQ=;
	b=GLVEy02/pwIrOD1i0M8iLqgpAW9D3c6z1r8FZe0YIJviazt3TuL3j8DqXqkuEXirJh/OEl
	5w8B2OMHvUChMhOgYnuVfnlv5an/KJYxv9CxGsNjwzQhwuA04GmVngfXG8tOeYFxc3UMxf
	BgdJ4iUCuF4I1Ke5dAejVeEK07IeGJs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757506283; a=rsa-sha256;
	cv=none;
	b=TC8M/xI/DZvR7SGOTIyEkYZrD2kawQb9RLdeyMVLyqjqUzmshbvwX1481BInaLM0aqDl6H
	7x1yjNKzZAGp4sxfdKPGKWi/04pRjwvJ71hy7TMrNJWs3ulC3SiuXow1KODFajQepqKRDx
	/1eocnNFQg+2A1bJ+O5gdV6yBkPComk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Jy59mXFh;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=mGqnPhD7id+ekgFhW/HlBJ5YeFKgN7a3hdLZmGPXQVQ=; b=Jy59mXFh669GxIRk/sB8i5rJvS
	emnSTMMjJ+OZ0c03gEbBEcMorTCEz7hfNIeOriqSkRy28qg4UFWdl38upDPmWEm5CP5E3PKJyleLb
	8jzfyS8Gpfcl8jMZo6UllramEPETYfYghQFTQYE+dSgFt/8yBUbUItX1wvnmC6OE61+7+OEDjIjpb
	wGPEIGFzbdDHEM2mx1faSJ29dq3GxE7olEaj5VFOXeA8Lwi7p5yLoiHgGx7roO07SCgRv/PPLH9UP
	e5wu9M5evzxO2GkWJ19mA82uUJFbWhKaqY27/BEPTKn4FT2wgqU2L/Z3LZzMaa28CksvW3K+qhLV7
	4TR6Nf+w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwJPo-00000008MEO-3Q5x;
	Wed, 10 Sep 2025 11:55:08 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v2 01/22] slab: Remove unnecessary test from alloc_debug_processing()
Date: Wed, 10 Sep 2025 12:54:43 +0100
Message-ID: <20250910115507.1991829-2-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910115507.1991829-1-willy@infradead.org>
References: <20250910115507.1991829-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9C21F20009
X-Stat-Signature: drhbui3rwzdzwiyodthoqydhmgsma5zf
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757506282-560944
X-HE-Meta: U2FsdGVkX18+RP1Fj/jXF6iLrWjmvE/DOTr0jbuzD6fUc/7v33Vg68kAwe1Bp8VNufyUsKcnxeGNk7PqnbBdzgxRfeTdBf0WnhG+4NyXdA6GNuCvzxWA1mSJyTr9padtULFFnxLfzyHH8gxdylUHxGeN+Jx1cQaIFxMJeMXUGs1KBjGXcB1ycY6M4r7oXru9gGbxrKdkVZg9YIoHVjnY4Q/Y5Abs7xzJGH25eWgjjAP1AnReBUB4bY0q7R95OI0FGi6YUbuj5si260wCiD/jXQeqx7A5mwemcgAEBpMCCpMfZptr9tiaIZA2pblxhhDnI1ivJJAMPOD6I2EaOu3Cck5rREvei0KP3c0z7iyj2JP9xIhO2lxUDBHz4rFFrGz9YLfG+Pc7F5g20bfqyS2MfNZhc68VgtW7jq7fvw7nY2Q5n/F6+mXSKOLwrkBfKC7shxYYVBBkPjhpyYJUEKbDoXYfbUliv65kw7F63by3ZZMw1rHYqnQZiCKz9PUx4t+U9x0yQsjRbZuLBZ8Row+NDQdKEbMTmo2ajFJFGPDd8ujqulmXO8MPBsfZFKuW2oKffcj7SV9RcGJsrSpRGCEwDnKL2hXUIPlJqT+B1NY0SAlLLlZEs8Ypy0tsGsGPzGkDMUBBPMuCZuFL0XF4qZS+QgfdqHVZ4w4C1ZKlaXe5bT5r31XGCjdQdwbA3m0B3QPlGxptGUDet1DEVOdpOh1UzzDqax77rzFhv0Gf49wkqe1XivdfsoOFSO7nFZJ54EQJ59NleFBn5WN8sQSe4p/vpsW3E/tsfLcODlO1obM9WYnYqLe+qTLZRwcp+1wBe4YwaeV57Rzazv9/zZzvwxoZ+OO2VVY0OcIoLvNAa0Lj1a3tplhjwRy8o3M1dGPw9BrIpicbHSvNEdAXYo/aF9weWMs12YjySqxrXYcVeX929eJnMmIadKwEZygUl1vDhxW+15n5+XQNiOmxD491Z/9
 3EGKGxvR
 pyw4IBAqCYFKpPck5N9gYwFrDCHPX+TgB31HKbGViklywVHT2YOKZKxhWakYTZgO33g+bu9rIfmIB1Eby3yCDGrJDmnliIi2nKfX4ybWfJwYroYF+bzSpzu09i80Z+lQ8TvWdDczkk88t0azICgAW9O5z4+KwxR+gEPOARN6Yr6H6ySedjsjpz8i+mF+GP/NUPLQ1njtON9A64U3JLk2o1N2/+mnl8fe2WM0z5mArVM2IJk+pudRW0FNehWSqHpYiM/Mw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In alloc_debug_processing() we know that the slab pointer passed in
really is a pointer to a slab.  Both callers modify members of the slab
data structure.  So we can remove this check.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/slub.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 962110466ffc..ddf26f00b21d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1715,17 +1715,15 @@ static noinline bool alloc_debug_processing(struct kmem_cache *s,
 	return true;
 
 bad:
-	if (folio_test_slab(slab_folio(slab))) {
-		/*
-		 * If this is a slab page then lets do the best we can
-		 * to avoid issues in the future. Marking all objects
-		 * as used avoids touching the remaining objects.
-		 */
-		slab_fix(s, "Marking all objects used");
-		slab->inuse = slab->objects;
-		slab->freelist = NULL;
-		slab->frozen = 1; /* mark consistency-failed slab as frozen */
-	}
+	/*
+	 * Lets do the best we can to avoid issues in the future. Marking
+	 * all objects as used avoids touching the remaining objects.
+	 */
+	slab_fix(s, "Marking all objects used");
+	slab->inuse = slab->objects;
+	slab->freelist = NULL;
+	slab->frozen = 1; /* mark consistency-failed slab as frozen */
+
 	return false;
 }
 
-- 
2.47.2


