Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1F49C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 05:28:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E746D6B0096; Tue, 28 Jul 2026 01:28:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E257B6B0098; Tue, 28 Jul 2026 01:28:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D62CF6B0099; Tue, 28 Jul 2026 01:28:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5A046B0096
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:28:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1E5C21602EF
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:28:19 +0000 (UTC)
X-FDA: 85037054718.22.A7D1D38
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8D7BAC0002
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:28:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C7X2J0Dh;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785216497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aBR1l4Zj0+i023n+HnH64fP1p7WsoVeRpc+Aylgoc74=;
	b=wM6LI0UrwxFNOOkmFSSbqw5qe+fSmaQ8mwva4y78Ch4IvfqE+gjCFU9tzS5k5qJFKGavZp
	J9wCkzuvL9GcQC35dxBlvA+unGXjay9HfVW/O7seVf/Q6ut8qI254J6vkgImfHB+2QnT/R
	YXmEs4UjJznk3OF1k4Sf+USp373tWls=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785216497;
	b=5XD2om3JvIrlBHxlVybuGQJJF0WvNa83TUsoz+A9YbagYNUo4mF3pPWfBo1CFRe3rLVFGg
	WJLHJ4Awam/PErad7sISRc7lIn9Wt8p/eO/Wgsr9Oi3pGqwaqq9/izz38K1gQ66NVCXSJN
	agVBJ4CuNf6cXK8vG8z02SjK035gmsE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C7X2J0Dh;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3080A60A67;
	Tue, 28 Jul 2026 05:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D851F00AC4;
	Tue, 28 Jul 2026 05:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785216496;
	bh=aBR1l4Zj0+i023n+HnH64fP1p7WsoVeRpc+Aylgoc74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C7X2J0DhOnfEw52l3ItT+sy4tCQecZ9jUNbSz0uS4JvDnbZejgQ/f8BOcMp3iknJL
	 vOrIozcx+8laxAA0T4YfLbWeFzShipAWwlRNlnZDBKdNElGulHXSBQHTWqReXuCAy6
	 bGxgVviE/FagYfD/3Vu3lBf/S/KBNId2i6qNMG9PtWTxOW4GBtIFOoNP83EyADrcpS
	 hgqRuJE08yp1hOY6Pm2yLk8mQUQxi7e43SxPxSL9Se/4vYkCMHqmb532Dee0ukuRQd
	 DvLd1cCb3iPjPDcmshF0bRtp9GOawv/n0sXJpOAHx4gwlSSivqVr50os00C6Q/d7rc
	 Hvc97VpO4unGA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 03/10] mm/damon/vaddr: remove a debug message
Date: Mon, 27 Jul 2026 22:28:02 -0700
Message-ID: <20260728052811.192712-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728052811.192712-1-sj@kernel.org>
References: <20260728052811.192712-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8D7BAC0002
X-Stat-Signature: hnhyzcx757gkso1gew1185zy1qhe917j
X-Rspam-User: 
X-HE-Tag: 1785216497-184977
X-HE-Meta: U2FsdGVkX18RuylvqgOdsEp5EvarSLmVtMROO0Zy1dwG2hISYSWknjD12POUzsPi31sVD3+8d6O5upXy7IyvHfmautoD4ruL0ymEz2QPQj9q3/BJXEBmZQe9ei1hXitNNNYgvrngbPrAeplztk6ld6ein/1r31svIOcnih4wfJFcIx3LtPo1l+PtfjtRC+EzIBAvnR0dSlbs0yK1Ph9jhyb5pd5b6trrAFgxJB6d1cY8KOe77f5auMXDsdfyx2fgaBQIhck0qgiFl7VWGd4G4UMKJabt7qvA4xBJK2Frw/qHh/WGs3TPoAUMsSkZ/02RhF6bQEotV5573tvdcikBDOF61b8XOrIuj4a9wadyUvF+Atlne7CA1pY+ciAf02j10yHyXKqQu9Y9pxT+d0+IEfZU6vHXuo0Gm1FCNpBldiRWyCnoIGFY2mlJfSo0wKA/Q3bttlasiyFjYXUtUs6syWT6duUrVgkcdImjG4Uvu0e822XWZbuWys7CO6SIewNernn/kkndD8Q7+NzeKiLu5szEz3pWEaYNti2fpQ9smIzUCeipAk3xkq8WIvScr/n+upP7DQx712iUXzqj5GuuBvbY0HVtB/cmFcoXD9j/bd3sXRvIA1HYyVgL74Cy9tGRu/UuKwt6cgwWtmW5jj+jsy0oR8oGVxD+7hQBn+0ToKFFgUhhtb+tcH+8JaPzuS0wtcReJHRVn0TXr9pm39GEAgufWYAfh0JxbUOD3ig8d+9cSaTZQuTuSm+dk788i8a7nne0N0s6GeG4CMinuLD23D+BPhTUjhGJAJxLlsXchmoCqSsThNy4dJAsTFyWlMmQraWWyxaW0uZmVkOxGdSpF54v4qDsaI2Vd+T0DnvOpHxoa+afI3HT89n/74iWDp6eQcwoccuWliHOUrmrgLMVxFCRZIsqjxyXrnCuzs2dvL9nNqOs8QUCMimM2+lCw09td1rkJQ7CxRZfEvAbWYu
 0E9PWNQv
 GYAW2KWWMgmjZ1uWEe+Vh6l3Er+duFel2Hm7x6DPqDDikJSDhuet55NkSbyEBRGxJxutuWs5w2esBMVUYnpYjMpqki1zKgaG10wBulbbibD5Bpoc8pMzGZBaYRgkbHg8PSF8g4TjbsCPdUXhgOpiUgsWDWuB13lHx7yPkuRe8T8t78wB66qvT5M4GlcVRV6HK3nPbJ5OfQFs2HqO4Uh8U6VJPj6/PU7c081gnjfZCvTvGOps=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is a debug message in the DAMON virtual address space operation
set.  It has not really been used in a meaningful way for the last few
years, though.  Remove it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 0648400b2d65b..95899b217b2af 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -192,19 +192,10 @@ static int damon_va_three_regions(struct damon_target *t,
 static void __damon_va_init_regions(struct damon_ctx *ctx,
 				     struct damon_target *t)
 {
-	struct damon_target *ti;
 	struct damon_addr_range regions[3];
-	int tidx = 0;
 
-	if (damon_va_three_regions(t, regions)) {
-		damon_for_each_target(ti, ctx) {
-			if (ti == t)
-				break;
-			tidx++;
-		}
-		pr_debug("Failed to get three regions of %dth target\n", tidx);
+	if (damon_va_three_regions(t, regions))
 		return;
-	}
 
 	damon_set_regions(t, regions, 3, DAMON_MIN_REGION_SZ);
 }
-- 
2.47.3

