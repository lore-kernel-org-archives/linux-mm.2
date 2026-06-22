Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC54ACDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:29:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C23206B00BC; Mon, 22 Jun 2026 10:22:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFA156B00BD; Mon, 22 Jun 2026 10:22:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B11016B00BE; Mon, 22 Jun 2026 10:22:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 217A56B00BC
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:22:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 80BC7401A3
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:22:06 +0000 (UTC)
X-FDA: 84907763052.28.202289A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id EB339C0010
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:22:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gLzrbKBC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782138124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZFWaG18Q1S2T37NGDzr0/yr5IxRaKdmsNfBt6SXMm64=;
	b=clo/QrDI3aAyyoLhQpNJhY0QaMix8bdcIAvrA6V7IQNkKrZYZG10h3N6oX4JX9u3F+0tqb
	8hVPqmA70irrq08iGPlIsqbmxHz2a1MchXhv782dB7SXnFRvX8FkUzP77Lu3xobAjTxuqw
	9wA4P+7FVNRYReVjH/Q1dweHdhViMuU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gLzrbKBC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782138124;
	b=KlM5UVgLkTRuWRaNM9jgYEP1rj5c9nDKlj26wuamzHAiNO33XpCKquKWNNzwG8b9Y1fmkc
	A+9/vJDkW6Hcp/D5tYztHdlNlk6iyEFS0D50Ae2UuoOV2s4NThYvucS79nZQk/5Hx6z67p
	ceEMyfTz1e6zRvxcx9QftevKQweKB0g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8DA9F60208;
	Mon, 22 Jun 2026 14:22:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48CD1F00A3A;
	Mon, 22 Jun 2026 14:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782138124;
	bh=ZFWaG18Q1S2T37NGDzr0/yr5IxRaKdmsNfBt6SXMm64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gLzrbKBCZEQt7wyxBpv4Q96/r5dgTtOv9wq4fhy50NxZwjlFY92gv75SeROaBvwXj
	 inPw7ndaGjFDP22G+mLlJ0gbKpEtgl3XrdGESAiJhBpO6XcJtILubsitaeEaxL6wLI
	 mfpKglUHuGT/vlemS+kWO4IEC2qjNTAf9YOgjMnncul58DV9fmif1UWsKJEL7GI4bk
	 1DC06Rmj/ugzl9fRfNj75DaH6EQ4R05I/dhrw8QFVZKLmM6sVMo4uLVJccxDrRW0PQ
	 CYb+n19md7+9nx743LuLzujioJetuxLp1FFfO7SsyzmtNpR9uESs1ZyXeSxcZSMnta
	 wN7pFr5j35gsw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 13/18] mm/damon/core: remove nr_accesses_bp setups and updates
Date: Mon, 22 Jun 2026 07:21:33 -0700
Message-ID: <20260622142139.30269-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260622142139.30269-1-sj@kernel.org>
References: <20260622142139.30269-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: nbu7hpttsbw7so16stc87kqjigzom6qr
X-Rspamd-Queue-Id: EB339C0010
X-Rspamd-Server: rspam11
X-HE-Tag: 1782138124-211542
X-HE-Meta: U2FsdGVkX1/c0sT581v5bJ1i6upL7w0TIkLd1+ypa35wpTMW3maGXhWKnq+sLgSLti52eBobZOXJjBg7pyTToDVdoEH1GIlA2oB8yhOqTfttGOvqM2NXloeI9xH2p6MJm/TAY65rEap0MvgVj6qrBji9eyrSd0Gm07OPPCmvrnMR6pepoUeBRYV8RGXNbWOLUC3OViQNta6IreMGoQK8L8nWqQItdEplXb8lvZkuP+jBNqSEOkSc7nxM87iw9NQBwU9o24qnNe/IO5oiiBxkFRtYw4QycZqH4IlcSt0syR5Uz2qzB5gG7INNBWul86dQW1ojbXra9u9vXM/UOWWM7DZ/Q1nt3q5Hl/rVqbuowP9i7BfTxKi7i7iH0Con6nFryE9W0LqdU6eXxftNAb9dGQAruBsipFQo4r3gT7A6AxtbxTyYfTT3vDWo/cP73IGdaxdEOEdqDqhKQ31gWhj+tSWvl42Wsr5HBWzfbloWJmcJtBYR6AHdDb24msBnqLQ5J0nuH7Fyq6WKAqzeQPkYh02uW76C3XnUWjEXumEOY97nEndwoCHwRTxLrkbyI+iYbj4tn87xfiG6W6D6hFgfWQmUsg17sgTJYZMrAnns74Kn3dAQJlea1pgppxtEljRqNrG4KxQPE2WzR75EML89tas1B3Asp4lZmskpSWQ42A5rpGwt3J4nOu2oqrdYPopPpgn65wjkAbYnNz0nHOmINcP4r4Bem5dWU/hXWKdcOlDOiT2MVY7tKWKTr8s4NIiKfXzTNGNjp8GhzSqQcOO8NTIq6MDnvNb3+7cp9RhhLtpONmPDzlGSbZ+dMQvFYZHXZ6PG0oxTptdwnY40Y3p4J9X/LPUf45tqAAM9ZnwIVB5VFXiMHvHdiRfiYdKeh4buQiofeNurzqxNr3wK8b58J1/vDvFLolfGZynWZuMq5+mfdP89EDRiPN5+KXPo5yFZMTw2aoepvFhO6d1Y5Su
 jhTRAGZ6
 hJrIjsbNVGkyBIYsoWYO5+whP1axUALG5JqIf6MZUwXvUhrLDdLhgjVxbP1Cli4inMzTfV+RNcMVAqjihdjNxO01Dom9AE9csxBHdmxK/TvfBS7A5u0oZv7CTBzxp14xDWrIkJIgSFgxXr3WFsuLjpvAM/q+vSr+oQGRIHZ41bqdhfmkR1oknjdutSqrNaE226fFMl+OccSYJOQEqJgwdPsSGzYvxzfIBD2y48pQbmhuGbhZO4pekoyFNR9f+/AdmrZnfiRJ87gY6jFsP+t8O1tH5fg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON core sets and updates nr_accesses_bp in multiple places.  It
explains how delicate it is.  The field is no more being used for any
real purpose, and replaced by a simpler function.  Remove the setups and
updates.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 80c1b34062312..b095f053c6fa6 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -304,7 +304,6 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 	region->ar.start = start;
 	region->ar.end = end;
 	region->nr_accesses = 0;
-	region->nr_accesses_bp = 0;
 	for (i = 0; i < DAMON_MAX_PROBES; i++)
 		region->probe_hits[i] = 0;
 	INIT_LIST_HEAD(&region->list);
@@ -878,20 +877,17 @@ static void damon_update_monitoring_result(struct damon_region *r,
 {
 	r->last_nr_accesses = damon_nr_accesses_for_new_attrs(
 			r->last_nr_accesses, old_attrs, new_attrs);
-	if (!aggregating) {
+	if (!aggregating)
 		r->nr_accesses = damon_nr_accesses_for_new_attrs(
 				r->nr_accesses, old_attrs, new_attrs);
-		r->nr_accesses_bp = r->nr_accesses * 10000;
-	} else {
+	else
 		/*
 		 * if this is called in the middle of the aggregation, reset
 		 * the aggregations we made so far for this aggregation
 		 * interval.  In other words, make the status like
 		 * kdamond_reset_aggregated() is called.
 		 */
-		r->nr_accesses_bp = r->last_nr_accesses * 10000;
 		r->nr_accesses = 0;
-	}
 	r->age = damon_age_for_new_attrs(r->age, old_attrs, new_attrs);
 }
 
@@ -3106,7 +3102,6 @@ static void damon_merge_two_regions(struct damon_target *t,
 
 	l->nr_accesses = (l->nr_accesses * sz_l + r->nr_accesses * sz_r) /
 			(sz_l + sz_r);
-	l->nr_accesses_bp = l->nr_accesses * 10000;
 	l->age = (l->age * sz_l + r->age * sz_r) / (sz_l + sz_r);
 	l->ar.end = r->ar.end;
 	/* todo: do this for only installed probes */
@@ -3218,7 +3213,6 @@ static void damon_split_region_at(struct damon_target *t,
 
 	new->age = r->age;
 	new->last_nr_accesses = r->last_nr_accesses;
-	new->nr_accesses_bp = r->nr_accesses_bp;
 	new->nr_accesses = r->nr_accesses;
 	/* todo: do this for only installed probes */
 	memcpy(new->probe_hits, r->probe_hits, sizeof(r->probe_hits));
@@ -3787,18 +3781,6 @@ static unsigned int damon_moving_sum(unsigned int mvsum, unsigned int nomvsum,
 void damon_update_region_access_rate(struct damon_region *r, bool accessed,
 		struct damon_attrs *attrs)
 {
-	unsigned int len_window = 1;
-
-	/*
-	 * sample_interval can be zero, but cannot be larger than
-	 * aggr_interval, owing to validation of damon_set_attrs().
-	 */
-	if (attrs->sample_interval)
-		len_window = damon_max_nr_accesses(attrs);
-	r->nr_accesses_bp = damon_moving_sum(r->nr_accesses_bp,
-			r->last_nr_accesses * 10000, len_window,
-			accessed ? 10000 : 0);
-
 	if (accessed)
 		r->nr_accesses++;
 }
-- 
2.47.3

