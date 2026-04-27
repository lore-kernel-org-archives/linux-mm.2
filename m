Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0640FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:15:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4501B6B0088; Mon, 27 Apr 2026 11:15:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4272C6B0092; Mon, 27 Apr 2026 11:15:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33EF06B0093; Mon, 27 Apr 2026 11:15:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 21D926B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:15:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 61EBA1B9A05
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:12:43 +0000 (UTC)
X-FDA: 84704677806.01.F08A2DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id AD239C0011
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:12:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mn9gY+7I;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777302761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8q+5YC8ItOTSqJKu9y1lGRHtw1/rF21f+keQZeBQrXc=;
	b=rO9oeXD49smR4wuLt/tQftwH7jIoaGebg58XHNEFsMGHSNIKUD/LK2VvR4TN2NnI/C1gsk
	EfsJj2+yLEbNctF+4nhYwkr4deAHBqxKrXuggfqSSGjPR88VKZw/oX9F1jL65HNmt75B5L
	7Kgkl0peV+UFNEH3y7haLmOJNMTwQjc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mn9gY+7I;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777302761; a=rsa-sha256;
	cv=none;
	b=ALY/Qi8LyBitvvIIPqU6exI3yZXKn1IjT0mLDNz+jUkBTJMkKR7ZbyEcJfietL5QBWHd/q
	ZVdW8dUsso6zNZLqSLolotkGDOMQgrc03SUb11wRSuLTCGeCw+m00sY/2ISP7kHqZl0FdU
	Durucqa4J2U0rFFHsb8c3vHSKLgZCwE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 58C7844572;
	Mon, 27 Apr 2026 15:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125B6C19425;
	Mon, 27 Apr 2026 15:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777302760;
	bh=Apk+eXvqRSR2+iwL/Aa86zOSrOeZDT/qkO72pSDz9VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mn9gY+7I7sI26P7ezwJ2NpPolcRAG32kCfn1mjgOoxVb39gIYIj/4VVLIcj4vFJjy
	 bXHRaA3FjLPqXHZNyZiHoR+dyaiFpj4o7qlF0zaevuHjbdjHYnh5nOM5n61iauBDcG
	 yPhPh8ErL5Cxb0FgUySj5MnS0rZxpywCJBCNgJmnFfZYUHVp9uP9wNuiO0aS9ptlG8
	 fw/6hhVyU3n3DWe6bx7jkyWqSB6i4yQojLKipW9AUZnjN1ow7e3ycBX1n1JdyKXHAP
	 2jB/2g2iqtEr4nXSSKCooQXtFAcqH+RsLKkemrxRvMk9Ji1QhqMgzYqwuH1P5ESm83
	 R9WS5MJwi5eBw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 01/10] mm/damon/core: introduce damon_ctx->paused
Date: Mon, 27 Apr 2026 08:12:20 -0700
Message-ID: <20260427151231.113429-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260427151231.113429-1-sj@kernel.org>
References: <20260427151231.113429-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AD239C0011
X-Rspamd-Server: rspam06
X-Stat-Signature: dtea59kw87nc6j8mcmi7bpkyauojnzcr
X-HE-Tag: 1777302761-760487
X-HE-Meta: U2FsdGVkX18J1aIzArZ8b40SyCv3ELzkwF0XZfiJjx72hHqcQJRSLCt33YVdaFqpT/rtVsI6sx5XbirQ89YytH6CEKoKRlY83RHiKJ3wSufZLsBaakNlCIlGhYF7B6scwwqRpTtKJpQPulvJluSlUscNxmdugKa9Uab2Zf7xRdrIF0rY8VovUzKOXgLRwQ2IWSDkrFKKvrcaVuVSfP7ypdd2utiYq/tJtMiePk5Ba4tUcGPT+ANHvGS+ZqYnKi4I3MJve4yDr6SnykzFuHd4qDqIDbbZPhlUgahsVRtKw0U5AJULYM58TatwxAgYnEcVQpC3MXBecp0AzkNB5YjQCccYFjhIvcJoFE/9PkSMlxJmutiGHWhV2B29nmWGEFHedAGZl+K9ziWk5ImPnoQAfE/SLiSbVylOIj2VwHixuru6lL504JkHVLC23GjAnh4WDwLWqJ2E9nFtxO8IEKMj526B2rrZ0Hy14qWIhLLX4Wo/ZIDyjxYssEiSUh4m+K7+haKTMwlNH15TO2qxDzGcUwDsn0daZtQvy8SG6bYOcoLSFO/QsGe9VsFcl9+bBY0ME/edEfKOIaBeIpvSWBzC5kpWN49kQm88dlJVzQ/OnL1qlZsHxBotfidj8u6Go9atIQIbwhEbSgW9mFSsc/i5umV2ifkZzlpTFqx1kN4Bp6uxNHvsFZE1UekchNrden2gTHLBqEu1TRsVrRuXRO9cSxE0u/krqhEd7uY/DrYssoNZeAzq8gsLmFwO09rcBQEsdHwaZKLMaZvbtLYL4/epfYuI/ptfphJJaXTy0nnZEmvCt9kKfCsfUF6mFEGzC2S+rEjDJ6bX8pRuhhf+Fz/cgWBt5ZVf8YduDDl15hDaLAPW5/TS3j34JC8ZDo+vpfXkrDTABXSsGkEY/nxye8x+AUNb1oZbRYW4T1UyEmX1t8WMoUPL+fCl76Qm41j0RmtstQvURbgIHDECUZLnjdK
 xVev9PC5
 vUYHGQ/rwckHeAZOecoiiLaeGBkfrTmbVSo7Jdhf7Xjif1iZyfVQjlZTr26o11BIlW8oFjXChVJbnpPv8Ft8qFfyhoKTy5BnnOzJpX73nYLzEAKp4lLTilz9x6QMibbAQzucorGXRR0r68FwpwbiW1LbXCn1tU/5Urpj0Pgf2fccrAvmFguJ9j1J4vnedela0fnGO5fRBM+zt07jStDlVPwtHL8DQRSgsG0HZCIEPFo29PwwiXu54UAEcaWmQD+T13/8cxp3UD4XlP9dDcmGJ+OgM/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON supports only start and stop of the execution.  When it is
stopped, its internal data that it self-trained goes away.  It will be
useful if the execution can be paused and resumed with the previous
self-trained data.

Introduce per-context API parameter, 'paused', for the purpose.  The
parameter can be set and unset while DAMON is running and paused, using
the online parameters commit helper functions (damon_commit_ctx() and
damon_call()).  Once 'paused' is set, the kdamond_fn() main loop does
only limited works with sampling interval sleep during the works.  The
limited works include the handling of the online parameters update, so
that users can unset the 'pause' and resume the execution when they
want.  It also keep checking DAMON stop conditions and handling of it,
so that DAMON can be stopped while paused if needed.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 2 ++
 mm/damon/core.c       | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 5e2fee6f517ae..82dd43fb639ad 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -792,6 +792,7 @@ struct damon_attrs {
  * @ops:	Set of monitoring operations for given use cases.
  * @addr_unit:	Scale factor for core to ops address conversion.
  * @min_region_sz:	Minimum region size.
+ * @pause:	Pause kdamond main loop.
  * @adaptive_targets:	Head of monitoring targets (&damon_target) list.
  * @schemes:		Head of schemes (&damos) list.
  */
@@ -845,6 +846,7 @@ struct damon_ctx {
 	struct damon_operations ops;
 	unsigned long addr_unit;
 	unsigned long min_region_sz;
+	bool pause;
 
 	struct list_head adaptive_targets;
 	struct list_head schemes;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 9a4220174a61a..00ff1a1c92e73 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1368,6 +1368,7 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 		if (err)
 			return err;
 	}
+	dst->pause = src->pause;
 	dst->ops = src->ops;
 	dst->addr_unit = src->addr_unit;
 	dst->min_region_sz = src->min_region_sz;
@@ -3156,6 +3157,14 @@ static int kdamond_fn(void *data)
 		kdamond_call(ctx, false);
 		if (ctx->maybe_corrupted)
 			break;
+		while (ctx->pause) {
+			damos_walk_cancel(ctx);
+			kdamond_usleep(ctx->attrs.sample_interval);
+			/* allow caller unset pause via damon_call() */
+			kdamond_call(ctx, false);
+			if (kdamond_need_stop(ctx) || ctx->maybe_corrupted)
+				goto done;
+		}
 		if (!list_empty(&ctx->schemes))
 			kdamond_apply_schemes(ctx);
 		else
-- 
2.47.3

