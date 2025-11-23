Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0AAACFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 18:43:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 119B06B0031; Sun, 23 Nov 2025 13:43:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CA256B002E; Sun, 23 Nov 2025 13:43:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9B056B0062; Sun, 23 Nov 2025 13:43:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ADAFA6B002E
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 13:43:47 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7A804C0163
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:47 +0000 (UTC)
X-FDA: 84142745694.13.6FD3032
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id C9F8A80012
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IU6+gD7Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763923425; a=rsa-sha256;
	cv=none;
	b=MvLgU27c0QS7cFWVeZ0c37cfh48MNADS5JeC/SV6iFbq5DYE9iYRYRw0vqKGC/OoQEcN6M
	yM+hvD+qYEH9WANzo+NOdmE1tFeZ19ummp5somBDMsqhrltVxECsTiJ2khuilCZHXYuJIf
	P1lFmyu8A/y27CCLC21Nax42/YitC84=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IU6+gD7Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763923425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GVaYk1cLWxGxn1VA80zTKDuoVfFfzUW8rpTRq3ikC7Q=;
	b=XDNioth09Psa/YuVnUGqmbWNOzF3Jm0P/zjo2Bu+ZwGpQKKjRq1vkdYb5g/6lLVjVpW1z7
	WLk87SDWkoh9Op2GumDWobQtlvhOKqFfI/emdaSCd/Ye4xfszsfsMiXFOrCIft1d3hZ3Cx
	6wKhmpVDuWfMoPKAtxrk6aDidG135rw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 966BE43F59;
	Sun, 23 Nov 2025 18:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3AAC116B1;
	Sun, 23 Nov 2025 18:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763923424;
	bh=DsxYSEC5PojLKtzUcVWfJP4PrbIxS3wEgw82HduLlh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IU6+gD7YXQfcvijugVPLPyX91rd/tCz+0r9sjh8I9R0rZ+PIg3vvv5UW0t2YJuiS9
	 xX0l74rBA+UnNVi1rjLP70NC+TaHrLQUDTLEdglLywJTIHOwthI9hJSpCC5NrUTJKj
	 QWFKDeo6HjSAiZ1QFcUaW1kaRnNfCQlZeP+30MABLps4JvO9+ULktFV2ytU8XHMYkA
	 /dLQy5xWgP/68YR8t0ofedEixkTwUMRxMlkYJCOTF1hyezxgF7A7krZP/fhX9fDjv1
	 AsEK31T0s9bCKuiBKxqj3o8PzTWpc/xG0WXnYWSqensu/GPF7bLNm7YnUulzwFepuO
	 ucx7eZmvYpf+A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 01/12] mm/damon/core: introduce nr_snapshots damos stat
Date: Sun, 23 Nov 2025 10:43:15 -0800
Message-ID: <20251123184329.85287-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251123184329.85287-1-sj@kernel.org>
References: <20251123184329.85287-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C9F8A80012
X-Stat-Signature: drpqeen5a3rqc1ehr9nq9cpfdgoauz8g
X-Rspam-User: 
X-HE-Tag: 1763923425-891507
X-HE-Meta: U2FsdGVkX1/R73QirOgAKhVu+wy6utzhc/jRrr9gc4lh78jEVqH54vpKafjqikwUUBat/oojSsGRnGEb8VWnMmqmEbj9X7fbx+4J12kpQLh+HqSb/bqMKaKkELg6I66A+wd33PgRzM7hGyOCiQbqe8qesK7iFRJbYMia/Tg9usH+zmhN0Kuero9I1/tgcXdfSnBtPlfrcGgFdrdhABYX7UXqAwelgXCvffTjWmdku0gqxYNlWYQy70vf5x18wNl1lHkqRaw1n/d5pOfj7d1amjgtI4dFpfTHqYletDgwdIS/7gwB6VaAxXK1RNoJ1T6dcG6sZppog/BHY3P/ApYYt0gRHSmy6ZIsyX4dB1F831vpY36bfdy3WgltK34uuEvI9/Y3xEVBuEEdYjGDvGdrs65GgCDRH9TO0euH60C8OxLSUdMKGHO2aBBSfiZL1lftvv115VhXk4EzDx/uMVqHL0as6Ww94lagYn3jbuA0oPMgY1of7g0N5VoD1cbK5tor7kqG8BMdKXShGG+O7JNKgbFy/JhcBuQhzHm2T+oDxS5ArraSsUxM5uEk1cR7wotCjb4Ubh+rOp34BOdMd7mJATffFyEmm3HdF/bYuFC7kTZEQUJLl5e1u6ncWoa2qgo7+0sYMfaFvaIzTZA+3DCd5Hiw07Dpq6T/Dp7yPqJzPsjCw+KSXSmHBanSsTRZUdf2cTXn+zts+pntjjtOt5H3vKiEa88meFb4h2EL+J/c9ULTjO+mI0Xh9GAVw1zEiI1YX0CR7w/sSh8EkJ6TCilOqw+OHlu7GNKMtB5MWMgWAQ+61oX0uRWYexXNH6Oas76wc3JJMb7ZMetWM4TenwgFq/IxGKyAxWWJRyUaACiZbQZdoRD8hnyvUzlwZ0FSkrd9hSyQnO4F2THgs/uTsKAxmo23KrrdZH+R0Cu/JaBWp70NboqMuicAJafGcjtvA9IiuYQgiKpcm9TU2WSBFhT
 W+UlDuiD
 ItRMtJxUCYGTVHwyKVo732t784rG+ZDDm+r5kfmzgOq0ftydxpJUo4fORB/rxr1D8WvzlxRCAcdcBb/Txe9F63AjG6Xz1mcR2hVb3DfzbFZWmhfUX/I6WQk1GB63KQjIf32xZeBHrI5UBlmcCzhtTHiRB8Er31+TivFGIj51gqXO0l9SLEMcw0pNn6+cXu1Gs3aSBdvIRxDwPzFHFePEnOriuHucxn/Cdri8LUq+84pQhtmZx+TzH1GQctHeeHLmc1QRxa73qmMM9RzGPxFuBodysCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON generates monitoring results snapshots for every sampling
interval.  DAMOS applies given schemes on the regions of the snapshots,
for every apply interval of the scheme.

DAMOS stat informs a given scheme has tried to how many memory entities
and applied, in the region and byte level.  In some use cases including
user-space oriented tuning and investigations, it is useful to know that
in the DAMON-snapshot level.  Introduce a new stat, namely nr_snapshots
for DAMON core API callers.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  3 +++
 mm/damon/core.c       | 13 ++++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 3813373a9200..1d8a1515e75a 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -330,6 +330,8 @@ struct damos_watermarks {
  * @sz_ops_filter_passed:
  *		Total bytes that passed ops layer-handled DAMOS filters.
  * @qt_exceeds: Total number of times the quota of the scheme has exceeded.
+ * @nr_snapshots:
+ *		Total number of DAMON snapshots that the scheme has tried.
  *
  * "Tried an action to a region" in this context means the DAMOS core logic
  * determined the region as eligible to apply the action.  The access pattern
@@ -355,6 +357,7 @@ struct damos_stat {
 	unsigned long sz_applied;
 	unsigned long sz_ops_filter_passed;
 	unsigned long qt_exceeds;
+	unsigned long nr_snapshots;
 };
 
 /**
diff --git a/mm/damon/core.c b/mm/damon/core.c
index f9fc0375890a..af922d5e500c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -157,6 +157,12 @@ void damon_destroy_region(struct damon_region *r, struct damon_target *t)
 	damon_free_region(r);
 }
 
+static bool damon_is_last_region(struct damon_region *r,
+		struct damon_target *t)
+{
+	return list_is_last(&t->regions_list, &r->list);
+}
+
 /*
  * Check whether a region is intersecting an address range
  *
@@ -1949,10 +1955,11 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 		if (damos_skip_charged_region(t, &r, s, c->min_sz_region))
 			continue;
 
-		if (!damos_valid_target(c, t, r, s))
-			continue;
+		if (damos_valid_target(c, t, r, s))
+			damos_apply_scheme(c, t, r, s);
 
-		damos_apply_scheme(c, t, r, s);
+		if (damon_is_last_region(r, t))
+			s->stat.nr_snapshots++;
 	}
 }
 
-- 
2.47.3

