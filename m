Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA7C0CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:25:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7668F6B00A7; Mon, 22 Jun 2026 10:22:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7176B6B00A9; Mon, 22 Jun 2026 10:22:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6550F6B00AA; Mon, 22 Jun 2026 10:22:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 33EE76B00A7
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:22:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A0B06A01B9
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:21:59 +0000 (UTC)
X-FDA: 84907762758.15.57F0BD9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 14D7B120005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:21:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kbt2lS6D;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782138118;
	b=iV5o4dnEkTy7Ksvj6uyc0WO+0pPi78Kpa+6Tc5NsTNwLunp9ko5SslKARjLpVTmPotmqgV
	U9FpDg0K26O/QWJZROxfjLJrLIh2DkhdA8bBlBzMx1aATkgatDNNCDwnYmBXzNCPU36THm
	zFH+tlDv6oYi8dkX2NhNyE6lXFp0qpQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kbt2lS6D;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782138118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZCOZ8dxBwUoJ8M+fjsYn5byv+H4mkkcZsSGYh1TwNIw=;
	b=ULG1oNlKTV+UoiEr5VAi27dm3JdKR9sZkzLruPTfyHu4ukVz/pGRJXFxKIOLePSc8jKvSx
	nLdzsNcz1LXR9iZ50F+GdhevFW6+RUQjMc6FMEOjF69gGJgBgKsMlUq2lp8/ZnlnOs7qAF
	Pf0DMRq9kGlLINweer2dE7JkaEdPnuQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5CCD044411;
	Mon, 22 Jun 2026 14:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD761F00A3A;
	Mon, 22 Jun 2026 14:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782138117;
	bh=ZCOZ8dxBwUoJ8M+fjsYn5byv+H4mkkcZsSGYh1TwNIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kbt2lS6DaQx9xowI/srvebEIIIeOqimNIqI/OXXQ7p6DXJMjnW6XW/UklKpRdtT+n
	 rISLP286YjPrG003sz3y7V4uuaVElUSbebCJLkb46iojWpPyckJ7YC5o+0VhyaY4DZ
	 h8B5Yh5Yk6TX2hfUIrO7RLlZ0U98pczrZrfAYS1XOmuSA0WL2I3Gw5Gs117JzCcZcR
	 kH7Fyhm5VyH3KrrAF+aGcLEdWpkWs1ucLPB+Ti106cRVhlyH5qwE7fjnJLPgGwgwAR
	 s6Qc6ERWLzkrNl+H5zTd6sYTb08u91RN15X8j/uK4d2GLXho1lTnLkFcuWt5uB9tPd
	 zM0Rqp/KCwtZQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 08/18] mm/damon/core: remove damon_warn_fix_nr_accesses_corruption()
Date: Mon, 22 Jun 2026 07:21:28 -0700
Message-ID: <20260622142139.30269-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260622142139.30269-1-sj@kernel.org>
References: <20260622142139.30269-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: az5p5qye14hunyujf74tg6cemhs3t6h3
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 14D7B120005
X-HE-Tag: 1782138117-74203
X-HE-Meta: U2FsdGVkX1+di4gBKvH2ms76LjNvXsoCMJ8YoIjx5NeJ6JY7VdRR9EzaYU97xK5cYsjM6Tpswvis1szt7qP0TYvQfv22ShWzye9qYIIxtD8YNs/AAn5aBDQnrHOtAw2Sp+zF4+dQ6Kpvqm8iTdK2yO+q+1Pqc6ofYU8eIDsWEan8Iz3QSjQTayXp9ThG09kPYdrM+4cAa4ye1DGXTZwa3F2nSyk1HipR5sL/kS0vxbK9drDYz/DowTFwrGQh6FA7hE5FosgKb/zG7wzGujLnbCeoKx1HSzsE5lgHXBzChVn8aI09QJBFufW3YPBGW6pbHfBDDpZ2vT5wEo3FvupKRGydyqRhX9qMo2Ti9FFpT2qecH7avuUw0P8BmjgLPN4Lll2l8nl8pJ5hkL6f9aAr5jt6ET/p59ml1jxX+UYjxSbY+esRs0glJYttbl1av/qAG/N+Y//DrKApfxlnO9j24hGagPmP1dS/mIz8s7KPg9dy661PfkxreD7QsKtgzBG5wOXkRB3umCTP024nF52QYMCGEVDspZiZNfXjswPzn46r4IR1viAnTfcNXGb+nYKht8AR/STpJN6P0r/fNL2d6K2wj84W3yyCMFRPRLa8EyW8WurFABgKLpfccqtGZffGziL0jTKTumAo946HaRe0iuJnaypuKrQACrwug3VInQ/iroI4YxDtQj8dzKlhKZx/pFLSP9Ob/6VlgZzJVRczV4DFv3lKWiD4PLq2+3S3KlZ/G/oZFeOph9D1Nc/+BF+j8xJE/myTK3Zn2t9voxStTZmIlEiDdZNP9/WtC5hkR3gaAg16MAaNUXDDNjyQdbelvWBD4N+045ZMKHtasXzd0OBOy1vxhvFy+1tnjj0R9enh5Ixm+jIz1X66NOTut21b7o6MlAI2h+RPZtahPrZURLpyl08TPkuu7FAhhWLCi1+FZRxpUIdT2R/+1vhU/4JXFXq8YlYk+Jx1xsd9im0
 xuWXshrb
 8bdPT0chVWoFA/RFpYTAiIiTApNtCjtr9IjXyW8OnvBJRsnmkxHKuv57ZqZ//akopa/b50nMfTs6rzSTBrdt1xDrSGqM/25CQLn3jZ6XyKQiSjHojTPAQR3DyIog3CSzZJAWSS1fb/oOn2fPKMhj1clWKcNxtfhMAGJC5du86aDnToooNeopcm9wV9YATBgOiAI1YAMGxy9rwxweX77hZc6Y2HYdSHdqLAfnSA2O973Nu1BG9+Ub4qewqBaGXxffj3aYFXKZhA0hm7vtZIj8T8BlmdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nr_accesses_bp is delicate.  Once it is corrupted, the consequence is
the bad madness of DAMON monitoring results.  From developments of
features of size, we historically found nr_accesses_bp can be corrupted
by complicated bugs that are not easy to debug.  Hence we added a
function for finding the corruption and fixing it right away.

There are no more uses of nr_accesses_bp.  Hence the function for
corruption detection and fix is no more needed.  Rip it out.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index ca68c4835c391..89ac5552085a8 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2002,19 +2002,6 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
 	return 0;
 }
 
-/*
- * Warn and fix corrupted ->nr_accesses[_bp] for investigations and preventing
- * the problem being propagated.
- */
-static void damon_warn_fix_nr_accesses_corruption(struct damon_region *r)
-{
-	if (r->nr_accesses_bp == r->nr_accesses * 10000)
-		return;
-	WARN_ONCE(true, "invalid nr_accesses_bp at reset: %u %u\n",
-			r->nr_accesses_bp, r->nr_accesses);
-	r->nr_accesses_bp = r->nr_accesses * 10000;
-}
-
 #ifdef CONFIG_DAMON_DEBUG_SANITY
 static void damon_verify_reset_aggregated(struct damon_region *r,
 		struct damon_ctx *c)
@@ -2056,7 +2043,6 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 			trace_damon_aggregated(ti, r, damon_nr_regions(t));
 			trace_damon_region_aggregated(ti, r,
 					damon_nr_regions(t), nr_probes);
-			damon_warn_fix_nr_accesses_corruption(r);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
 			for (i = 0; i < DAMON_MAX_PROBES; i++)
-- 
2.47.3

