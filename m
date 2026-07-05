Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0E13C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 20:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A0ED6B00A4; Sun,  5 Jul 2026 16:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 777C66B00A1; Sun,  5 Jul 2026 16:57:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68E116B00A4; Sun,  5 Jul 2026 16:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 324556B00A1
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:57:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B37F1A01D7
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:57:56 +0000 (UTC)
X-FDA: 84955934952.01.CAB0A04
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id EA9EE20002
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:57:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GQAI4ROA;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783285075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kxd4/9TvByhr/rgk5a0bpEO5crurTcFohmlFktpxcC4=;
	b=osiO63IxXKB3V+th+kr/iuZ0Hx4op4P+faMxHyHC12HHPNr9htGOI+YhjifZ58y6qt1lvF
	dDKl+z/SvBq1ywMH2l0Js9S078yXsxbPo49Uk+eE1rcKpInQc8KUnrXKAGUhusMvnYRNBQ
	h4zoc08f5WsAsOoF0ydMQbs2GrZ6bWY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GQAI4ROA;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783285075;
	b=QOm4t7hrMzcy7OKEmydbNa1dKq06kUbA8xyDYYp+xAPL6WkvwC1SMTATPFX3dZfEG7eIpJ
	EQvHo3HqPKzTx/svW4YS35ZZGkxqX6GI6xCvp9TvVxkJF400x3Xd5x/uHhOM2bjoSP0JdK
	7AExmoZLEq5fij2R00JjsrbCMOAIaj8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 544E443C19;
	Sun,  5 Jul 2026 20:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3531F00A3A;
	Sun,  5 Jul 2026 20:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783285074;
	bh=kxd4/9TvByhr/rgk5a0bpEO5crurTcFohmlFktpxcC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GQAI4ROAjA71sUSmR/akrtuf+fPsxQHduGEIUvugrwRgbjiakZj9NZmgqslxjmNZz
	 ZgK0N/6FbFl04/fLaOweJN7VEy96aos6B3ZtYqI0htRhbNvE2Pfrbdc7ynOdjw7Llp
	 OBur9DnwZ/fD5X6im47r2Gb2+D/gHgGcP7lWEm2dW9efDlAY+Yvv8KXegFBfWYrg0x
	 qMtBJHBD7tvCBP6nVHczC8SnHjLpGpYg7Bd9qFSvneyhLzKscxrx/zPHFERpNY5FRQ
	 61F0PjPy0ePsyXAQ8nrS1TBpbRyxBhagUKeepAu6mLNuto+C2JcUvQr1QGUo/KAMT6
	 pWDwlkvCc5AwA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 03/16] mm/damon/paddr: set samples in apply_probes() if requested
Date: Sun,  5 Jul 2026 13:57:25 -0700
Message-ID: <20260705205743.98656-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705205743.98656-1-sj@kernel.org>
References: <20260705205743.98656-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EA9EE20002
X-Stat-Signature: cdfxtimbw5pypzq5j1xwytwxfkskuzaq
X-HE-Tag: 1783285074-573119
X-HE-Meta: U2FsdGVkX18onGlmDEzNHRFu2c3urONBUG+0VGLIOl3aCjggt5ua6ZbQC3h1N6UMhCdIy9M8piy6e6fUiQ8CVTp8hZYgC64ZZWARfH7hFBxnOs2m6FtOCgi7FL2PHs6/wTdsLNl0mI8nYDQqCb+l14sOYQ/5sca6Few/XFKwxZy9/a1pmNiz5yCL28V0wx926BewX/21dP9wamm+SnZ9Il4ibx1jiWtVom/jt7a38MvXtOAd1MsMk05tYqZDPjriD6XIuXpv8eQVs1kNVaCBo6WlqcZ3pjBHTaBVc5fdMwOXfckXIAUyGSRfVrP/4PRbbPPOkWZLFAeujMpXjvomi+Mf/GkqwbSUuRfkFpolEdsV2shEShv4sI7E2uLZ3rdfOxIZIRkEVeyp86BJPC1WvBEDgbhxJrlqXAW5dCto6W6GaeKfSlL/KKM+cU0vPeAd0gaT/xLfLvqifNQ6YtrOkSn5zNwjEOYzxoyW2m1eduvzpfN/cZ5tPugLNvlY6nQntFzJnSHkOhpWbsCaJYewFBwtf0H031NFJksoryxwC+fgBcT1JN8G1t0i1eKljCbyy9gY8fLKErBqCH9Go/U3MhmaVuqcdgac0aZdlONoO5yMPrns1Eln6ocqqiFuaG+1BogOuRnoxCaAfux2U0pjhmaTM0qQiwfaJXOrK6HX132OlhA00UjgLm2iIRb4I+pNUZw9t8nT/FTqQtiQ+VYfuvzz1oRj8I3Yp+MAHHhD+lMPfl6CHzcWxD7O2sbVIjtEdSvrx4eJGqvrmsAStZAe6YuoNtke890thrzNfj0XTguzYSK9Jb4jFb9Ho8oa3W+NesaH19TbPS3//JsadbcD1cuVz0i1iGxATkBjMZzl//g3BLMH7gOGPhx2tgje/6sGH/DY4mz52wlXiRP/zXDBYhST91zxnpLPRfayei0XVLzzHA57GHcrDzPeDhqXLlOygRz61u48BZpKdwOeP8D
 RDSzCEId
 HfHIob3F+ocET4P2XZMctVlvH9iGByoYdVtAdVtSAJDZP4/7e5LyQ+p0Ix3XCJuy+HOjIXJ+ptQmt5jCzoNXExLqoNvusmyx2KvHHmwub1Ij7JbaiPNUTPfDwy34CE5l2n0QCAN6h+2Am1E7I+8LlUtXZaZ4KE2VAOpnrpMvHX1udEBAVUql2fNttOAkSY1ZDCx2ssSpoUY5jvCPaFTlMoHZyqLAxaufStflwSiyLSfh9+PYGnCWD9i+fUOSOW9921e7XzeYoEdbPuTFaHy4UPSc/kg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

apply_probe() callback implementation in DAMON_PADDR is ignoring
set_samples parameter.  Respect it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index b13bf7c6eade3..ff4fcca949660 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -178,6 +178,10 @@ static void damon_pa_apply_probes(struct damon_ctx *ctx, bool set_samples)
 			phys_addr_t pa;
 			struct folio *folio;
 
+			if (set_samples)
+				r->sampling_addr = damon_rand(ctx, r->ar.start,
+						r->ar.end);
+
 			pa = damon_pa_phys_addr(r->sampling_addr,
 					ctx->addr_unit);
 			folio = damon_get_folio(PHYS_PFN(pa));
-- 
2.47.3

