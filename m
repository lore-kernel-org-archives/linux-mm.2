Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07C26CD4F48
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE28D6B0095; Sat, 16 May 2026 14:37:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E94806B0096; Sat, 16 May 2026 14:37:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C71276B0098; Sat, 16 May 2026 14:37:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A72476B0095
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:37:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 66AE2C1AD0
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:29 +0000 (UTC)
X-FDA: 84774141018.12.A5D820C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id DB8A6160006
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ahYiYfUu;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kEdc4gL6MaOKRPuEpw+WL8Iup4Mv2cKE7erBkSSO4qI=;
	b=l2gN+SoisKWK5jSgZIhlLvfxrdufTZwN6ISvsJxrIi/l7VB3Yg/DrRh7pOBjcmACMjNYi+
	vN2kqbl8/DvPuUNZTfE51beqQZPgWxHgJTIvQmN8ROx60KWAXlKxMB0m2bPvTDz9Gt+m+Q
	Famk/dgpwLPsXS9umk9/j8krykUOpFw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ahYiYfUu;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956647; a=rsa-sha256;
	cv=none;
	b=UgEAGESy8jcF5UhIlbq+AyP69mRhj9NOXKceUvdVZDqzvdEBysm/T/dxatIsnNDxLwiyMP
	Pz6jx/i9e+K4L8xzTw2Y3lKS9rq/ZUn4inHPVSpm86+UdPL1kImoZXPHisS7hlX+tDo3El
	q/NtAmQoiYGeGItEjALir+7S5Bpu6FE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 31DD16020E;
	Sat, 16 May 2026 18:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B051BC2BCB8;
	Sat, 16 May 2026 18:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956646;
	bh=uClJ0L17ynWbY4YuI5snfXPDwvcqzODKDGDtrjyzs6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ahYiYfUuE7c1uPb7cCFrsijDXb3+lORDe/eBd6SqLA9iZ7SWMSdssqv2TfKfQjxh2
	 JBiUBXvOuPpqpJ+2AzsaGURyx2GxQmjr9rB9QSxnEW0TQtnge/IkuSDprJcjrv98+Q
	 iSagIWedjuRRSsgAB1+QX2xvYH0wDdRRlisv8cBkJkcGtib+aG+lTg2/v+XtP1PuFe
	 yHrlgI9gIT5QGOo4u3i/mne/7Dfjq/me4uTjgSqXQE3SVcAdIMK7tsmTFpjvlbrki4
	 w2K5+/kzBYsjUwby0GwIGxn7OUByOyIUNd78wEyL3tQV/CRf0yanjIx3o9v1cxvtUQ
	 fjxww7q58P2BA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 07/28] mm/damon/core: do data attributes monitoring
Date: Sat, 16 May 2026 11:36:48 -0700
Message-ID: <20260516183712.81393-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: <20260516183712.81393-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DB8A6160006
X-Rspamd-Server: rspam06
X-Stat-Signature: c8iymxjuxn6dtn1sz6wzayq3kpu8z7s4
X-HE-Tag: 1778956647-103425
X-HE-Meta: U2FsdGVkX1+nr5mR5SuMIFmQ8bXoGQxuzXVFwDNwQo+foyC7E/bqHWZu4doeU2+uf2So3j2kkaZliBMLkXXPCVLUx3vFX6PT45cdhQTUOUaOfiZq2FrcTKVNwt7oyWgNXjCndVkQjzBiIAvdLM8kg/V9pku13uDOd8mNoAgd6sjhYjHowBPF/hymsKK8qTRYNDzjRIItuKXukJ7k4tBCER++FBLqkuqNOcft0wrjGwzErY99bbDzbMvekQpk5uvn0WzLJH+IF0FcV+uzctJAvBt9Kyz2wdQ4yTOOAEll5B0lvKYfeEuOLPDdupYoHYqnPJYujSSvn3g2Jw6qC0aSpzJBs7xb3xksTToCn+P1Rf2sTIZz16Htg/AXmQdKbhDk57ZYpEiHmPMXWp9dXtj/Um1sqBNtrJ4+lmJQHFM41hXUyyaUYjYcXyKyRsZM5QNgOIggHtfUADCsL+unfKeu/7pj0jx+3KUirAlUPi2SZ4uvDF7zO3KDmSEvmOFrauYU6nb6ULGRreI1C7iOcTOsBRPB8e5D45bP/YGrLEWX1AbkqHqMG46WMlwUNsYJZsLpbj9ec1JF+oi3ldJjJAnAvaKSZ006X0VIPMUT3Fh2EdmwsZTsEmyx62Q1TL4Ti5vNQAOYnV8DGgOwtoPosDpZga/69g4l5FKVzCMXu9wsYbRJQG/ZSbzMd20UqCUMVbYt0FoSyP+8+SFsxPPqIyambvm7PLovijLUjl9mI6kz8PIZUKfOekf6jDzFVD5GpoQo2yjh24O8wQp8hSVZ5iQW+ymtJvcbPh52ojTPGgyNCkHEvp1WuuwQgOH9bXp93U4sinXuKh9Eyxs7rukS1zBcsyj2zCM7IHdu3Scp6v0ZAR5a8K3foCLjwQEf56d8eWyBb2Km3uWY5rp9wD7SzkKYvURdS+V/M8RLPtui/qltFg78CMIv2XUe4AKqrA9UNKhSIdQL0XlyuD8TiXjoqMJ
 aT0rdbrq
 Rt7YRTVYTWINPBFgJLR8mQXnbwJrqEwmqA6N3Y1IM0PwtYDdeetST5gCNqF85e7DJV+fWGD2bjMMV3Y9ArkHzI/DwdNQ8jwxKyNyj4L2WpQIQaUONcjhReZBcJ+bZzOtAo+BXIlFxpS2z1VO/7nXRBzubhWfYQ2DOhR9ywTd4EkmudZkUrZ7NU4/d7JJeMDXLe/Dzf5VtOY3ZMjv/NlIU3JdSw3WjWeuvrGgC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the data attributes monitoring execution.  Update kdamond to
invoke the probes application callback, and reset the aggregated number
of per-region per-probe positive samples for every aggregation interval.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index e5667660b4cd9..dde3c8d8fef89 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1886,10 +1886,14 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 		struct damon_region *r;
 
 		damon_for_each_region(r, t) {
+			int i;
+
 			trace_damon_aggregated(ti, r, damon_nr_regions(t));
 			damon_warn_fix_nr_accesses_corruption(r);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
+			for (i = 0; i < DAMON_MAX_PROBES; i++)
+				r->probe_hits[i] = 0;
 			damon_verify_reset_aggregated(r, c);
 		}
 		ti++;
@@ -3179,6 +3183,8 @@ static int kdamond_fn(void *data)
 
 		if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
+		if (ctx->ops.apply_probes)
+			ctx->ops.apply_probes(ctx);
 
 		if (time_after_eq(ctx->passed_sample_intervals,
 					next_aggregation_sis)) {
-- 
2.47.3

