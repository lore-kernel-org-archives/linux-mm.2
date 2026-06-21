Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58E22CD98F2
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 15:58:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 903B96B00A0; Sun, 21 Jun 2026 11:57:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8675A6B00A1; Sun, 21 Jun 2026 11:57:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E0E56B00A2; Sun, 21 Jun 2026 11:57:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3FD826B00A0
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 11:57:43 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B5F3E8D735
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:42 +0000 (UTC)
X-FDA: 84904375164.21.65508CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1C6FDC0004
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bic3bOc+;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782057461;
	b=d3OqyG7Mo6fDTPGu2VJuhW7zMvR6Y+tNd2Nh7Z873n+vIeSiFqw0tr7BzanBaxqwqSOH1z
	6i/WUpOZjBYkvUX3DA9CPYvNq/vUAd2rdDjuh+hVR9WKzt9HJXFAd1oiADXA8vn1KlKPIV
	Tp6EExcAGR0LdblVe+84utTCNarqBCw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bic3bOc+;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782057461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pZ+M6B9rIjrwF8KBw1ippRvOtN9mQ1VfyOBQJ+Ky9uI=;
	b=iDIem4rCEIDJTo4B2FCnwVY/5WdZLFBhwZsMTzb/f9hBRniPCDGN+TZerFXwlb5kdnb0CP
	taVEKpXFyQfrO7tV37i75tcBF7bhRgZzslJA/C13A7uYGyqQ3xKOeQnNcaameXWh6tiUQS
	dfnAeXv3kCV/C2z6z7i3q6mE/2iVaDE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A65744529;
	Sun, 21 Jun 2026 15:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85BD1F000E9;
	Sun, 21 Jun 2026 15:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782057460;
	bh=pZ+M6B9rIjrwF8KBw1ippRvOtN9mQ1VfyOBQJ+Ky9uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bic3bOc+7MqO9Am0FvLYr3v1YRndBTbKdZxnFGv0alNSNreSH/E8jC5eKlnQYEPL1
	 XW6FGiwkz5D4WJXFtyfzGYhfT8anUc4/SNmvmuSvK5X01tzNv5pcx7WSYx++9w6Buv
	 3McFZ/ZcMddHweS0ulqgNa4lNlCuWDWlxxfBMupSaIIkKXHPqzn/tCxqoD2TfM5B4q
	 +CwQ8iNOvOuf+r14D3Ia2Yl7yTX+el2HWA+Gi82lILt87OCsF3Wmm6zgsdbDBPaNA1
	 yO77s6MchmATVf7Ck+1PG6SwP/Kc4Zji86BVT7yGpkGQE2PYotbqgK1ikTHALOTOH9
	 nHSZcfBprXaug==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 12/17] mm/damon/core: remove nr_accesses_bp setups and updates
Date: Sun, 21 Jun 2026 08:57:08 -0700
Message-ID: <20260621155715.87932-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260621155715.87932-1-sj@kernel.org>
References: <20260621155715.87932-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1C6FDC0004
X-Stat-Signature: zicnri7eds159jh7fmfxeyb4rthtynnd
X-HE-Tag: 1782057460-118206
X-HE-Meta: U2FsdGVkX188rofW8Op51X6aV0cv9YRCuzVNHHDSCDw49Jn3U4EgagxrkQtoe4lbscbJ8A5ZCsjQBjLEeQ98kDBgQuGp327KJwpLqocJhoDZo52OvBSZ/GYcWlerXFBOv0YzH/ejQjgDR1Sre+ndLlLZKm1P3j+QqwxmnFScfF3qB7sXJyJIcu51a62f1CJlj+3968LiDocr4nLKGmnqNcHK2UF+7ysfqH83nczBoV9wGBHepe3QNjke9e1i3AIFpLOoX/HE05OoSM/5ZqrIo4eJNUa5oS+tH9s6iHcbn1t7kLSprTUMmi02GWLIrjPgoskvyK8SemYMIBHFQb/jzIDLufJUIcgQEVqoGAwAH7BB9tq5TQnBi2UPfMAtD2IDZy+9KZMMbZVzDdcOmIG9DAMl89IQrdgwLq6xilfdLoFV2NBZVlVCzRM4Uv5CV/pxNzqb2DjsK69cd6yDO5xBfhGMQotKAkOI7vX7m+0ei9R0ycpIkstjL6dwnkvVsHiaTpPamX8RKBJ9WBLJSp00phM0lwZSkNF1Go9UjHHxm+eMCRzUmrxrQYSyYdw5XmLZDxTcExQyx/XI1HLypvU3RkxYYvgphrFuszQ4nUa+c30Ka0gSrHGbFmX7YbA5cDuWp6/qLkKqYm9vueldPSXrFm9Jhz5+VcwVeVLxqcA3h6VAdob8Em1WAx7+Spiurs5cNSTqMOJVAQsU0HJ9RjurVk90XEYkItw0fsDwb3sJmQy43cE7ANuD407IJ6Vqa4FX1Zn4wLwhKny+VQSOY+JaguBcjTa+rFvNseyTXiytx32uh7QGRQ3+NTsaxpohc6ozqd++EGhZViCvetEN6FppbSkF1OEsPqtIpoxSuoVJ24/uFfwhQfX57ybkXSUYPDOUybgad2PKy4OAb9NgtbDqBJpwancshSXoE1vNp2eQh7dAY7iBM9bX234VL9yAL0tVlmIuwICcStrdABsrF7f
 dku9g4QE
 nOOj2WLtMvx3MwKgtSNOl85657t/a11WtSm1T0tkYgaaRS+iYuI4e/fNh4yPaXmCCP7GolciS3udcKAFrmxnrA+gL6mWmEN6dHIhADzVe6KmM8kspsyu1yd4bbch2YwSW1X3c4W/7SQmo6lekoW75JnrbFH61QGh0q9FIxvyn7Vin2GW8fRcgmL57yvjfGtqq8RtZytZcGgm4E9URxZRlIUso3XFsCoGKfctz07FyWRgH2cNgwG/cWMC/pIu/6WnqcViMvMbpntmJzsozvNrCUbRIaQ==
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
index 76ac58bf3dff9..c3c8e83234011 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -301,7 +301,6 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 	region->ar.start = start;
 	region->ar.end = end;
 	region->nr_accesses = 0;
-	region->nr_accesses_bp = 0;
 	for (i = 0; i < DAMON_MAX_PROBES; i++)
 		region->probe_hits[i] = 0;
 	INIT_LIST_HEAD(&region->list);
@@ -875,20 +874,17 @@ static void damon_update_monitoring_result(struct damon_region *r,
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
 
@@ -3103,7 +3099,6 @@ static void damon_merge_two_regions(struct damon_target *t,
 
 	l->nr_accesses = (l->nr_accesses * sz_l + r->nr_accesses * sz_r) /
 			(sz_l + sz_r);
-	l->nr_accesses_bp = l->nr_accesses * 10000;
 	l->age = (l->age * sz_l + r->age * sz_r) / (sz_l + sz_r);
 	l->ar.end = r->ar.end;
 	/* todo: do this for only installed probes */
@@ -3215,7 +3210,6 @@ static void damon_split_region_at(struct damon_target *t,
 
 	new->age = r->age;
 	new->last_nr_accesses = r->last_nr_accesses;
-	new->nr_accesses_bp = r->nr_accesses_bp;
 	new->nr_accesses = r->nr_accesses;
 	/* todo: do this for only installed probes */
 	memcpy(new->probe_hits, r->probe_hits, sizeof(r->probe_hits));
@@ -3784,18 +3778,6 @@ static unsigned int damon_moving_sum(unsigned int mvsum, unsigned int nomvsum,
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

