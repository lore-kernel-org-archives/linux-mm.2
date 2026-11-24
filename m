Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26C4F606A33E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qzey5u8c
Received: by kanga.kvack.org (Postfix)
	id BEC246B076F; Tue, 24 Nov 2026 10:36:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9D2C6B0771; Tue, 24 Nov 2026 10:36:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD94D6B0772; Tue, 24 Nov 2026 10:36:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C4EC6B076F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:36:57 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1F1731A0BCF
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:57 +0000 (UTC)
X-FDA: 85470415674.15.AF22D37
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9000E1A000A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qzey5u8c;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534615;
	b=ONfml+NW4OKCzJVX3lVThQnDOImy6RqrXlVAAv8DlUeqBr6APaRITOsylwWO2n1cOgCE9a
	wHiW5d4OJZGWyQqCqvswKDXKo0X2BN8QVhZ53ToAKrpWPtWEGmk88VhSnQmc4xKPB4V0qN
	hmy/vDNZ3PfoSOwykg6hGrQgayaTEZU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kn32Anyj7C2dLxq5vqYUn8DgCRQ5YH6k1PpdHy0AroY=;
	b=Qnr6DjH7bmAC6Ar0cAgmXTrBmt7NdDzcChpY5DcJl33RqJA4zmPO2t2xLmo9qdXvpPPSC5
	J0nxDfUaD0n4NRjkra7rvm5mEggABT7ZTxQJFqPJ+ikYS1hRBQtRjv/uKVdunGy8eVKp4E
	dfKPFdugew+JEdrW7K5IqqXv8LDdt3w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qzey5u8c;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F4146271B;
	Tue, 24 Nov 2026 15:36:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862B91F000F0;
	Tue, 24 Nov 2026 15:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534614;
	bh=Kn32Anyj7C2dLxq5vqYUn8DgCRQ5YH6k1PpdHy0AroY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qzey5u8cmOaUuvB2QIkVTr1HgFa2g2DdZyJdljzMJZQdes3DmE+1eVmflsmxIW05C
	 eV86IYjzBLAuWeMBHoyM0VFRSpUCGrWChQTVbvEzvNp4vqsGEK+iJkh7Cu+29IBmxM
	 caK6GinYWWPS1o6BQIoUJffqkhxY1RQBRpimKxPeG1354oOzOdHJ9B7OLeZNNjNset
	 NWjsyVWFz7/s4XBubE7ikJMIWV/BJ2crltNh1BD4Elr+lCslcUX477O/kwSZNs0DlD
	 uOoLDfssnmltUtiBNTaT/KDrTR/kBt7OA5bxoaA8eVUUfL1kP90APHUVYok7dWEvwJ
	 V6KC8dWeSDthQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Lian Wang <lianux.mm@gmail.com>
Subject: [PATCH v2 14/27] mm/damon/paddr: support REPORT_MADE type probe filter
Date: Tue, 24 Nov 2026 07:36:20 -0800
Message-ID: <20261124153636.91854-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153636.91854-1-sj@kernel.org>
References: <20261124153636.91854-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9000E1A000A
X-Stat-Signature: asrw5c8mrhgk9669ok49o54uiggrt6ye
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795534615-368723
X-HE-Meta: U2FsdGVkX1+4CwRIdeDu8PIK3Qpofo8iq66+domBXkBK/LNFnNHBpKlkEzQxgPQP1V5Pd8OyPtB0U/iQ7yW1maHTuFp1qTnQXBghyKOmMcRzEhYjELqimb8M9XOx3y8INLMVwWL4Y8f5yi8BI+9d/6Kbn5JExaMS20HteWJKPz7aYuzpj8lRUs5Pj2zncCYBf2vaoCum7KQKKhnfH9tPByLDCO0qZfkCoTYS6cwQwC7u3z9EvRiZW+ZUKV7SFyudP6Sz2EbBHjToHS0eyyEp/bAx5URZBx4Yo8Z1mP/meOT2hsitDQd927Dtr1RKGmuqdDifno59C3Yk25X4dzkT+m70UbHd+8oBbFDbIoBQ5wpPZhdu6vDpVhXcvRRFxbvOnNDwSvyB1YsD5KZgrpC4o9frK4lxwZ2TIBSdjfREAcDKg2eFiVmb0HHLHJ3Vr02rZskFiYT0bhJ0aeAqPbnrvzHwCTIJLibeXqDS0Tqw4PUghjgK835RWS/Z8pL5+x4y+W2KcC0GerUAf5zjpZNYwZcYWKl0GVY8QJG4UIOLfSjQlO6nKXF7Wk6hMu7yc+h9+CYKCt7GtxC50F8CDNHTScYLdPZKHDLgZ6z5dsB0FrRg/xzYAwb47tJRA2GJzZAGnuVWSuVfAHi2stlm9vL7tO8aDwf/I0rn0JdKGjgs016XCHWzh0gQyslpIUCS5k4WTeY1mzl3MMgpBltVQCWzAS+jTWITu8I5EjrY+Z4wODUB+BEMW4Ehk5o+alTiZE99JN6vYcP6es5kCx7dy5A76hSmGo8qJpfvE/zD1vM8pcP8MwdSTxerwM981sqoQdlyeVsdbn2y5fkOEm8HRgRN56bJcFgjS4ASEQ4ao8wOa6gLp1Uzslcr6DNJjM52J5kVH2EVdNrgLtlEdtPZ6EgQTG5IVz+TTAvRarFEjR3H9+nEBwEWfRYjjptNX36ggvZZIfUpTp5EMrt1H+QcgVE
 hcyeake4
 N/t4NwZS5SpfEox0iy00FUN6egv+WKAClM4CAeIUUONwMZWErbzWkKpvM7MtobiC82+0fEVyZW99cl6HYHFpH0ZudBT0oHLt/YCnLzHLF7/GCkBQ9q1xqtyXhQ8pvyIlF9d5Y44iW5ted3uva1hyL278hBmlBVTy4AoBuGrf4ydm/v4623BlnvdFFUPXSGFwJc/hn0MzVztnUC+FfZHiNQSCizM7gcbdq3j3bCohPAymhi9YjBcqNHJugztW2zkDM10mY+wNz5tMKLnkHNz6AVTvfvtntajCb0CCHf+wdbDei1JP12QmAX+1wRRmNvsCNPW4Y8PIPBqIWWxDK1hzJXet/4gYszBrjpw7BZpVx2HOLQ0oU6+JhGaaxYrsLKchUI683f/WErf6oT94E86us5Lu/LFlhsnMIhUgWoWFX3wnI+YuhrXgFNiHYgRhdO/p2jPXDwAg2T5qznzaijck5KkXwlSd0/3K3Q9iJd9IELk+PPimww5qHvAyQ31XMzMSwZm9U04yXcGt4GAWMtBR0nqNef0N9jwJLvS5MNyyDd5tJ4Ubsbdts4rfN0fshyJV1BND6mHAUvksD9o8tsndrYFTAWrpJzxsj+9Ak
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a support of DAMON_FILTER_TYPE_REPORT_MADE type probe filter to the
physical address space operation set.  Use the DAMON core API function,
damon_report_exist() for the core report search functionality.  Set the
time range as the last sampling interval.  Pass damon_ctx to the filter
matching function for getting the sampling interval.

Tested-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 411e1d557ba3f..70e8687dd1f66 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -140,9 +140,10 @@ static void damon_pa_prep_probes(struct damon_ctx *ctx, bool set_samples)
 }
 
 static bool damon_pa_filter_match(struct damon_filter *filter,
-		struct folio *folio)
+		struct folio *folio, phys_addr_t pa, struct damon_ctx *ctx)
 {
 	bool matched = false;
+	struct damon_addr_range addr_range;
 
 	switch (filter->type) {
 	case DAMON_FILTER_TYPE_PGIDLE_UNSET:
@@ -157,19 +158,27 @@ static bool damon_pa_filter_match(struct damon_filter *filter,
 		else
 			matched = damon_folio_young(folio) == false;
 		break;
+	case DAMON_FILTER_TYPE_REPORT_MADE:
+		addr_range.start = damon_pa_core_addr(pa, ctx->addr_unit);
+		addr_range.end = addr_range.start + 1;
+		matched = damon_report_exist(filter->report_type, &addr_range,
+				jiffies -
+				usecs_to_jiffies(ctx->attrs.sample_interval));
+		break;
 	default:
 		return damon_ops_filter_match(filter, folio);
 	}
 	return matched == filter->matching;
 }
 
-static bool damon_pa_filter_pass(struct folio *folio, struct damon_probe *p)
+static bool damon_pa_filter_pass(struct folio *folio, struct damon_probe *p,
+		phys_addr_t pa, struct damon_ctx *ctx)
 {
 	struct damon_filter *f;
 	bool pass = true;
 
 	damon_for_each_filter(f, p) {
-		if (damon_pa_filter_match(f, folio)) {
+		if (damon_pa_filter_match(f, folio, pa, ctx)) {
 			pass = f->allow;
 			break;
 		}
@@ -199,7 +208,7 @@ static unsigned int damon_pa_apply_probes(struct damon_ctx *ctx,
 					ctx->addr_unit);
 			folio = damon_get_folio(PHYS_PFN(pa));
 			damon_for_each_probe(p, ctx) {
-				if (damon_pa_filter_pass(folio, p))
+				if (damon_pa_filter_pass(folio, p, pa, ctx))
 					r->probe_hits[i]++;
 				i++;
 			}
-- 
2.47.3

