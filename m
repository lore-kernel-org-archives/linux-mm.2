Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 274E8CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 19:35:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 216696B00A3; Fri, 19 Jun 2026 15:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C6EA6B00A4; Fri, 19 Jun 2026 15:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DD7F6B00A5; Fri, 19 Jun 2026 15:34:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D2A686B00A3
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:34:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C526166A82
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:46 +0000 (UTC)
X-FDA: 84897664572.06.2BB162D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id A5CC32000F
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b9PKAF4z;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781897684;
	b=I1ATTMJXFyuQiCnmQaXWUphkGuXDfnSXGnH73wvYEHL7rtC63vV1gTMSI8XDnFCIrcyq/S
	jPX5dKoiGHtw00MqYMARs0Wi3Wxwrr+8A0r5eCaBU/rb4j5XAplZfUneVfkzAJEurKbj8S
	fzZq2GAccGxHrZeD1aoQ58bhlFOE+D8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b9PKAF4z;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781897684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mj0WGbOgmW24rBedByuWyQfl2j0/cU9b+G44I09HpLc=;
	b=STzhwks9T8B2h+hHmaNMAQZtHdAjcXHplTJV1T5ZY1EeKGxSJtDQLZg4LXpRxy+d7Ww5Tx
	YeHrVAldC+4iBfdW7cr7oFboeZkZf1/74YtiogWOQHlHWm/mgCsCWOfHpXjnBoEMFD75xO
	KvfwCiNEZ0PM+pMPhi5sm66Z7DQZKyw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 058A740D67;
	Fri, 19 Jun 2026 19:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0331F00A3D;
	Fri, 19 Jun 2026 19:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781897683;
	bh=Mj0WGbOgmW24rBedByuWyQfl2j0/cU9b+G44I09HpLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b9PKAF4zEoqNsBbqOMqLn6VEvkGq+pyOY+0V/lEGTXhoofxVS5wFTR/lAyQIoohew
	 jzQKCOhleBfcyiZeJOBxZx3t0g2IMJJEYX9f28XoCBL/5WGhKrIkRL/2LTsg7l6N/v
	 OWdDCzIkP4QIVGZuDFQhOdDpalUEPF7RO+FkK9iGIr1MnOMEC4KdoDaIUWcKzftY9Q
	 cGeIsI0WZWFVfV9scjXpfhTNGKOY6Cy2u+K51r5zGs9PNB4LgnDEnRjmu2U1j60Knv
	 EDdJy7d5r667Skm2KKzVlIVvfGlSVdKyF/Kc9eMMJappjIBqUYDaflGWoGjr3CXA5A
	 SDkMnZHhArPTQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 11/13] mm/damon/core: remove nr_accesses_bp setups and updates
Date: Fri, 19 Jun 2026 12:33:56 -0700
Message-ID: <20260619193415.73833-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619193415.73833-1-sj@kernel.org>
References: <20260619193415.73833-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A5CC32000F
X-Stat-Signature: oxsm36jdy46ryeg7issskjb5oay3wmce
X-HE-Tag: 1781897684-237426
X-HE-Meta: U2FsdGVkX1+dD32FOWkL+3HNEo3FGzk+c0wibcmUoKBY01UiqaSHcA7fQDF422PdNKaJbtTdZnIbSS0pA+MZRUCywXskgPZeu0Kn79AWsRSS0AAZ8kFMmkZqNEfyClpIfyTF+x/R2cspy1X3PPfjOCC/u9Qr9nk96XnNxqLqlkjyRd8HfPGh4Bns3AkLIiCS3Vrq76pGs1ND1bzA90Oi5CG23Mg40QwC2BBzwaIZZnmrkjjgUVsEaCAbhdHg9O3wJu+ZA9fJbcyO66XEqD7AFcwqt8SegWdhV2pQ/Z9NwfvqWixXAG+fnIgcwDrBKCFPJkKPy2u6Bvub+/JEtulhC/Fff9v3DzB4OWtqgXn0vru6kiAQIiYZ2GbcxUBMDOxLKFG6HQR0ro/fAxpi/Qj6vYEGPvkbYZDLD/MUecme1AlZFvwCoG3TQcLaTWPGTm5dGkXoePvw4mmnGo5qNaARxmoxa2W+gz55n4eIQw+EN+KMphD9im3beCDvnsKLrquFNV/j0CJzIcRRWxOyeYog43ZCknQ/LIrfqm0HKbmZWJQPzcpkGBKMONI3iAOWJANPNMs4yWniukTBVoRTUo52AfLtYR7P7FjVgSW42AdEIPiyKRD5d5IvJb5g655NWYVI/5wRbWFWkxiYHqExzI6hxO/JbGvgaAedVLaSWaqgmjRw4a8jFI/UFrltO8KInPVq7aUOX/a+zwe06Chf1xKKi2Zgq+nxv+MVB9dlN0ThOtQS0llZsnU8H7zTComxs+QjnJmgX1jnljlMpl16iTCmzciNysiG7ygWtv2QIWKvGa4MlnPpa3wgsvzb+xceomb54NuDJs0GI8BwxVLMxu62G06ouMqsJKcSbsR8WGJnh/kF+ORZECgjILySt7WxGHRpy2t9glKyfWZRXTiRQh2YGp+5IJALD5afR6Be9QDBkbklPqpke1wkoM227FwL5b83UAcFIjIMgkri2VxOsPj
 HFj2WqNj
 jkrQfubcGE2blVxsdFyUbJAadfrLwBvFjRuRn/Rwm1XIOhm+VZGLrnWAlk28HqE5rUrGXYohOEt7s/99fuaIrDTrmO2Wq+ChYhJwYvkiZAowO2BkMxgkxRwOlOJuqsHHJuvCvK8j05IY5sZwvsW3KrEx46h1bJB4dTSd0R8VhhBl5GS7FUKVnqYHgCBW6wVWawx0gFtO4kSHtshcfXOJoEz0Tg7QBZBoWFRbKAPWCQR0BM6f9qRZ/TByh5j+1l9HdC9S3OVYEYS4Dws6wFnxGgU+jRA==
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
 mm/damon/core.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f2db39aa34f4c..eb129e3f7029d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -294,7 +294,6 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 	region->ar.start = start;
 	region->ar.end = end;
 	region->nr_accesses = 0;
-	region->nr_accesses_bp = 0;
 	for (i = 0; i < DAMON_MAX_PROBES; i++)
 		region->probe_hits[i] = 0;
 	INIT_LIST_HEAD(&region->list);
@@ -869,7 +868,6 @@ static void damon_update_monitoring_result(struct damon_region *r,
 	if (!aggregating) {
 		r->nr_accesses = damon_nr_accesses_for_new_attrs(
 				r->nr_accesses, old_attrs, new_attrs);
-		r->nr_accesses_bp = r->nr_accesses * 10000;
 	} else {
 		/*
 		 * if this is called in the middle of the aggregation, reset
@@ -879,7 +877,6 @@ static void damon_update_monitoring_result(struct damon_region *r,
 		 */
 		r->last_nr_accesses = damon_nr_accesses_for_new_attrs(
 				r->last_nr_accesses, old_attrs, new_attrs);
-		r->nr_accesses_bp = r->last_nr_accesses * 10000;
 		r->nr_accesses = 0;
 	}
 	r->age = damon_age_for_new_attrs(r->age, old_attrs, new_attrs);
@@ -3096,7 +3093,6 @@ static void damon_merge_two_regions(struct damon_target *t,
 
 	l->nr_accesses = (l->nr_accesses * sz_l + r->nr_accesses * sz_r) /
 			(sz_l + sz_r);
-	l->nr_accesses_bp = l->nr_accesses * 10000;
 	l->age = (l->age * sz_l + r->age * sz_r) / (sz_l + sz_r);
 	l->ar.end = r->ar.end;
 	/* todo: do this for only installed probes */
@@ -3208,7 +3204,6 @@ static void damon_split_region_at(struct damon_target *t,
 
 	new->age = r->age;
 	new->last_nr_accesses = r->last_nr_accesses;
-	new->nr_accesses_bp = r->nr_accesses_bp;
 	new->nr_accesses = r->nr_accesses;
 	/* todo: do this for only installed probes */
 	memcpy(new->probe_hits, r->probe_hits, sizeof(r->probe_hits));
@@ -3777,18 +3772,6 @@ static unsigned int damon_moving_sum(unsigned int mvsum, unsigned int nomvsum,
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

