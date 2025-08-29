Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBB74CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 19:30:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 026E86B002F; Fri, 29 Aug 2025 15:30:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F19996B0031; Fri, 29 Aug 2025 15:30:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2F406B0032; Fri, 29 Aug 2025 15:30:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CC9E66B002F
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:30:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8066813AA5D
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:30:33 +0000 (UTC)
X-FDA: 83830786746.25.BBAA41C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id DB62E120003
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:30:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Ps7QbriA
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756495832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=osdzSxIWtQ5R+/TP73f72qmBeFLO1eh8iPkLRsYtKa8=;
	b=4bbq6fOZzueOP25edaCz3nLsJehyJZ+9Foehj+xMQ5F1A565GJf+DIJl8is2jRBH1j65R6
	FZX1h+AMzO9Ihac64k5JYLnecLykUOcd72e0B+zv3vODeUVbLqDeClNLb21hkK/l7UVPvb
	f0djpFuVjy3R5hM4TOFUTsD+L/gyGfo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Ps7QbriA;
	spf=none (imf29.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756495832; a=rsa-sha256;
	cv=none;
	b=BiOse9PLQxwYWZ1zarggVrrP3shxL/oC5UDSdHYCVV5GASOUzeKtiXeQVtZwPcAipEfA/D
	Chzhvb1zh6CkabNEblpmtohLWKSYjxzz+YlMB4wQADv9Ix6sP67NwYNQUnZYcOSQgMa62u
	M3iuOit1eFi+U1QQmzrMRWZVVZEvfRY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=osdzSxIWtQ5R+/TP73f72qmBeFLO1eh8iPkLRsYtKa8=; b=Ps7QbriAwoetDrQkyFIyw3Izun
	fo+73TsizVH+8GzYiyFhV2zZwNVVRLPwNMt8NQ2hEGjqaMULe+Fpa18eMJSH5L0Fd+mAU+2WAGZAh
	nFWgcbkf4QpIP5yucDoF3EtwrY+yZGwOt9dZMXF8yzAqu0L8ze/Z660a0I9qu1kkAqFBAN0lt12gd
	xAXo+dzYTKwvIKACpePCBnz7eI/4Q639xjsKD6D9PgE8lTIFvF7SriiyODGAcrsdpRhRnHNEKNxh6
	vnyJSGOsWZvmIJS1afAICgp2p273jHrTxNZKx4JZdgH5lWayVzYvyvinDyhAQVrcdhtS3I520+PtA
	goM/em3w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1us1K6-0000000EFvz-2wiM;
	Fri, 29 Aug 2025 15:47:30 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH 02/22] slab: Remove unnecessary test from alloc_single_from_partial()
Date: Fri, 29 Aug 2025 16:47:06 +0100
Message-ID: <20250829154728.3397606-3-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829154728.3397606-1-willy@infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3kysfj9jojwyqhatdp9xx8q1gnecumbk
X-Rspam-User: 
X-Rspamd-Queue-Id: DB62E120003
X-Rspamd-Server: rspam01
X-HE-Tag: 1756495831-801030
X-HE-Meta: U2FsdGVkX195rmEmoU4UFgtt0pDoHmSADzGhRXhNQBd6PA947X37dcw6+V5MpkGW241VBjRCBjc5KMMYDtnE7HmLR/ug2unIMq4wjJyWaO+1dsCk0OpETb0STKkWUrpL+5rWr93H8HzoQHeqbRwYUel8lMqbX92FDJuD72Pf/sgSfUd9LYUcKjws12JxHjIUzCk8Z0BhrVSasU+8y+cKTNu9LGXDpB9dEE+OkP5I7GWh/AKaTKtLYTkUCvmdoJsE1+rwJnSSASOLsHkz58VY4az+RLnYGrH1el3fxR646r5sJOfoBznBLZWI+JFSsGaFH8ixUZQMt88lUUeVFZ36u2Ki4D4942KRrfeJwa2kHfJRTxortr4/I/1Fj/9+s4EQJz+FMPJxnPIWc7f1jzWedn7F3o29fw4nUwsd7q/66WURpkn1HC1rbd0VIdvGycF8ahfzNSFc43aLie+NV+1TDAERJZSNo9yXXrh3GvUhB738Z+wt/bUYMLzfbxMhq9HtXqOsUHOgOWNQHhWaAb9KEUAuI4MAIYjlRxnGKtS1Uyl8JQza9RAYLuTvFvqYO7FfysEB2zUxgrcB3MPDg7yu2XMnpVU8A72jHxaRjSgStJhGjwzNkUmy6iTXBJSVT/AJgfbtuEp9MGxFqlg1VmiiU+SjSfLQyJM9R+cDV64EjKND+3C/f3gxOdu7zaw1ZMpK+lM8HpGDsf02Px20X+n5uH43l72Ax1461t7vQQowOhZ2630TSlO3tX1um9LS+KjOxkQEHXTHf1k5tJ9Ovw+sOPTDukXAbYNgdY36zyobFE7jBI8yIotGmUpzAHw4xIOfcBsHcOC9pwp9yXmQwUHy7BA8/qPCZsxhNP+NC95aZ9M80KTRmdfm5LNdZOYp+dom7D0/oI/NgzlOZEe9kHGcfC69BoqKuIIlfDkCcy3rigJ+EpmrMpMW6+N2YqVwkxGcIodaYqGy4ldJTt9Yk+d
 RxdD9oBS
 4zbsinXA/M3J1Mh2QdZc1jVmzyivz1viFOsyv65VtY6BtGvp/nEEkHjZN9wPz2gZiC9a2qpZgidLvoSL1ROC2eyJxJMcna0I+9kxhmVJ8gSg53tmqKoklTrvgit7CFI/15RdH8SM7L10FEQK3hfkNt99rABnPoSv5nqghLyj6nORO48cprb1Q0NOYxlEOGBnugFJBoUWS9H1+43oLXR+FFaVzT6BSLI/9W0Z7TNJPqj00KunKemK/M9M4QqjPzTtzkQdKX802N/qf//o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We know this is a slab because we already modified slab->inuse
just two lines earlier.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index f737b85a326f..8fde324cd308 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3318,8 +3318,7 @@ static void *alloc_single_from_partial(struct kmem_cache *s,
 	slab->inuse++;
 
 	if (!alloc_debug_processing(s, slab, object, orig_size)) {
-		if (folio_test_slab(slab_folio(slab)))
-			remove_partial(n, slab);
+		remove_partial(n, slab);
 		return NULL;
 	}
 
-- 
2.47.2


