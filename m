Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C4EBC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 04:06:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11DE56B009D; Thu, 17 Sep 2026 00:05:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 007FC6B009B; Thu, 17 Sep 2026 00:05:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEA1A6B009E; Thu, 17 Sep 2026 00:05:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B22CB6B0099
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:05:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A8F13C01F5
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:05:49 +0000 (UTC)
X-FDA: 85221915618.21.6AE9496
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 15FD7100007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:05:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eVJlBFLu;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789617948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3HzbqHqjQymjaA7BsBDU1/xd02tq5ixlWdlSiDNtUtY=;
	b=GW5J3tJo9Z1bqnt9IKCgeKtNTtYdftecUh1BzKoL/MU4FAz37VqynY7Rbtvv6HSwEIqRa/
	yO5tCvBgk8TBa76XH152fah5JWYeK9o5KE//N1wTvDmg2igF9cQi+UNCNc6uuPL526QmOG
	uxYLsMgxOY3uJhYTdXBhQosPDVrGsvk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eVJlBFLu;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789617948;
	b=UVwshPjFeD3GHSuy8VSdeuz95I1EI92Q+QK9nGYjuIceHMncn2+VwEkbPQICQzl6km/LLx
	5rz2N/Fj/Pe3IrLesy7EZhJLR87/gtm2gzYp5NkfgNYhXi5b2gJrjW/xlf8SIAKYzvNzf0
	iHSAprvNSKlRZjFRQ9PkAWJs6hYJNrE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 61D7744773;
	Thu, 17 Sep 2026 04:05:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204D71F000FF;
	Thu, 17 Sep 2026 04:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789617947;
	bh=3HzbqHqjQymjaA7BsBDU1/xd02tq5ixlWdlSiDNtUtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eVJlBFLuAAEcE0McA4H2A92moJphJQNyCLtRJOYqmffUyhdzTDtPz7AZYB3R4kvC1
	 VV5/cE5e2xkL+odrzu3tuJrCLgimM6mOCCZ1rqp7plBxPXC1GrN8a/YQEWLjqBwqU/
	 Tn1Sm0drOOrkqUO+dhSvHfnqdPNMMrR0whTPqnkAJzgYa1nEW+GdHt3Gb8cpSqJp9S
	 vOfNdgrXvPy9Rtv1W8hrLqZwmxZHypptUhbe3Mx+6dpSYeNUOg2cxXx+9p8dAxKPPC
	 /dqx9dDWBGV4XC/bvLjTCDGfP/xz2FUkDXx1PWB/Q8UzTGTTL7c4MKnlSwgcQLTnFq
	 t2uWbKUmxBxOA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 06/10] mm/damon/paddr: remove pa parameter from damon_pa_filter_pass()
Date: Wed, 16 Sep 2026 21:05:32 -0700
Message-ID: <20260917040537.107341-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260917040537.107341-1-sj@kernel.org>
References: <20260917040537.107341-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: yggc3ijko1nnkyagsegrbuted918jnkg
X-Rspamd-Queue-Id: 15FD7100007
X-Rspamd-Server: rspam07
X-HE-Tag: 1789617947-839563
X-HE-Meta: U2FsdGVkX187HcT6whfWuaSn6ISXexhMtqxAM0r8R5YPWa7adNCF2Y/d9U8oLfQf0pkpjGnj1ZXGuXSEFG0q2k3gFiyaaDBtHTfodXUqmXREMrLjhHAz5qNae3r585Cz3Retds4NCN5RV16S225h508vvZNvgBtv+tymsoms3qrPnHifENQPCPBrd6SRXL+YMH8g3elF7Bl75hc9BfWXsKnNcivC16DrwWeiasoiy8L52Enj4KbAz4J/EqOSARRkhjZ+ewrAodOf2Roq2l5JKMHuz7xyaZa1OzcO5h8xU4KQcgNhwWqSSM2oAtywo+WtQPjUQPBwaxhgVJzSHfM/Qq2gkl0I6HFvCcAyXAmU37Zyr8A4jYDgMsem7ERL/vrKJxn6IvlHnyuulWdse3pZXKunYJ7WLfL6qI5jeLhurE0rQMHBIZV3zVlAO8D0NQk/XTsXa6rcn7q3xZmPQCX65OhfmB4BYGWHu00bAq2SFPVM4w3IBhxnOpC080kjIyHMwwHBRtLXMrTH6iB5KCxCy5JlbWbZ5S4mstb3PhCGNU5tsEC2sA3irM2XVs5JF4ynsTDYQ2Iwx+CkMW8/eG5FVHwKP3un5kZn7TDe7tFnH8z5JCQ+2VEZFboOn+pFaIA4hn1zCWKaL26qJLBzQ+4ACPJqHYfcZP0C6+Y3wiWdvaOnqeKpK06JK2FlUnvweF/yDHSANlDxgBD0CFySJ8QSCS55quSq5b0ZIQQdDDfLO+C+8FGVybIMhO0ptaqeKMSlWVua0yRTovP1oykvxV5TUJwVJq8r5PZRoWMTwMvmCvFd+vg83jOxNcxRTIkdQVuBijDaQZet3mWILtUF2303T8VbjFin1irQoUMppMbInY5l0tyG6nW37ID9iWz6AVVpe3NtWuLB+U3Tz5Lf0xbVpV3w0PEm99S/iauJmaOm+VRDtwyiyI4wI8CaNLvIh8KwBBGci06qiXdDP1b1yGU
 I0JdJ/xS
 y4H+kRmeNYFpkR3H4tPDtx/dcrGhI8wAtXMinKW/oxk9OqafSHfKHHooCpXcwPgfqUWFRkozzONiw/s/J5KPqTBGZT6CjMlcpZfFSP3VSKNJIYw3M28lC6ThepFXvy7GefU9Fsx0Inkeu9ZfA0Tt+sbvQpV1hIEqLqvz3gpLRE9zmH6C/xX+cyzcv4jIck4JTc+jJdLtDXHkWIODeMSLZFq12kP8tcUyhW42Kns0rbaOm0SaAsjwYtr0XAB/H1NT0AhVaMLMWURc175zrN6ZACga4Og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_pa_filter_pass() receives the 'pa' parameter, but doesn't use it.
Remove the parameter from the function signature.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5abfabaa339e0..2cfdc356b4157 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -163,8 +163,7 @@ static bool damon_pa_filter_match(struct damon_filter *filter,
 	return matched == filter->matching;
 }
 
-static bool damon_pa_filter_pass(phys_addr_t pa, struct folio *folio,
-		struct damon_probe *p)
+static bool damon_pa_filter_pass(struct folio *folio, struct damon_probe *p)
 {
 	struct damon_filter *f;
 	bool pass = true;
@@ -200,7 +199,7 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 					ctx->addr_unit);
 			folio = damon_get_folio(PHYS_PFN(pa));
 			damon_for_each_probe(p, ctx) {
-				if (damon_pa_filter_pass(pa, folio, p))
+				if (damon_pa_filter_pass(folio, p))
 					r->probe_hits[i]++;
 				i++;
 			}
-- 
2.47.3

