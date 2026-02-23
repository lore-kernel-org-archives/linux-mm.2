Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFA12EA4FAE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 12:33:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E9BD6B0093; Mon, 23 Feb 2026 07:33:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A0D26B0095; Mon, 23 Feb 2026 07:33:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46CD46B0096; Mon, 23 Feb 2026 07:33:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E5436B0093
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:33:12 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D6FB5877FD
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:33:11 +0000 (UTC)
X-FDA: 84475661382.05.3E817F8
Received: from mail-pg1-f194.google.com (mail-pg1-f194.google.com [209.85.215.194])
	by imf23.hostedemail.com (Postfix) with ESMTP id E7403140002
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:33:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b5VtNGNX;
	spf=pass (imf23.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.215.194 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771849990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LF0oh9yEhb6fIvd4fp6llRGtP4hadGxZKoLp3XCPu6I=;
	b=p1qy3oK54IfpPS44ysnow9S7gPHBEjxtqKjKigkOszHqPQVZZ8oJ2M6Ct7pPGcF3eUx0p4
	i0rlw54GyGnWpK7yNXIk64sIxts0yqT4Un6xoYkMTyOWfR9s7FV46Rggq7r+agaq4C0Xau
	Qt4Yjq4Z7XtrIRuIX2fsGKijxGYyZ8o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771849990; a=rsa-sha256;
	cv=none;
	b=kHghAstCEUJrRLwKbly5gsbVlLCI/QuQSRlSViM5K/A487xbUwz2GnmT8wniOiTWGZYJGK
	HEBBFr8ctmfbRQIHaLqX2ajTAmYO2EiALV0GO/e5/PP+1eIjGdpTfyHhV6fe9U0XMnfSi0
	IkoLcl1tstIRXuv1PR5EsfENFCuKnPE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b5VtNGNX;
	spf=pass (imf23.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.215.194 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f194.google.com with SMTP id 41be03b00d2f7-c648bc907ebso2526889a12.3
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 04:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771849989; x=1772454789; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LF0oh9yEhb6fIvd4fp6llRGtP4hadGxZKoLp3XCPu6I=;
        b=b5VtNGNXTp268lICjdyfVkSk4oLifgpTtJcGSUCMoCDt6rstsrkDU/gTn/5NxzAV8+
         RG3ASqZqi5x2V6UCQbGxtgJ4ARazeGuPQceAzlKNhqDws8rsk/pt32p1yAs/R9/v422B
         z/Uy/cDnmkcYsNpJd5E0rIMsoK1SwuLnUVWm0/AmXQca8wGYrGYv+qqOVuaYdOJM/1fT
         YoA/tHMIHDY/iBF4uhT+q3Dn+qk5vpjRL+RAsI/8VtZLrqcdN7f0S/K8Dss+nDub+UN5
         9vJqZ25ihNxxjxNBDnJct5HEfjDTn3mR+cgSBJS+L66JQuEZTXq38m5YUvSet6XrxBCo
         cZ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771849989; x=1772454789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LF0oh9yEhb6fIvd4fp6llRGtP4hadGxZKoLp3XCPu6I=;
        b=KvGJLg8Lm++ho+YwK2S29rbcCk0x4HmxSsCOjFLih9EeioIVHate7kzCAKXRAyOjQ/
         9164BrtDFRZO5t8+w7xT375C3HKjlNMK5SZo4EgXZSezFENTcdvj0GpYeMxYlS/bXxw/
         tkcJy46tJrCGa6e1PA5qbN1/uik8CuUOIgI9kmX5TthMAQLkdh0o2pz08yoYYcXPf1lx
         /48YNICdqlwjkbVyftA1ojHXgOxlu1qTejRFKpmTplosA80Ji4U59fp0VbrZ7ffwEeve
         BJxQjUNjFzrFa6Xgbu0KP8AOKmlgWMJPHFJtbCN/c2hYjK7hlPiTrmfUQ2o/Wp2FJGD8
         kgbw==
X-Forwarded-Encrypted: i=1; AJvYcCW5eM4gk9umDvJ2zr5oJ4anmTW12CpjE1txeWpEhBUGMx4HOxKdcVR1EzSDXQxkEsZb0I5exz3bcw==@kvack.org
X-Gm-Message-State: AOJu0Yz5VIUKVUqJijQG2wPpRcPDp5qsOjCgR0262QZbzwQlmR9fYzit
	frEnsUWQFKpLUiLjAE+63IBRDzaWCE8RoXJBejBHVHSPEWka/MlQWIc=
X-Gm-Gg: AZuq6aJHesM5dG6ZQYPibCERkArJoelV5rOPL0oslZcIiTIdyIJs+16Z6goK2iq1j2R
	UsTSQ0HQ36LS7fhcwDGShXw5G9I/o1pQv7mUfUIzPXnWbT58ZxSXtWa2MKkWnAngqUZM6SyGs2L
	HqFhSJxzsfPSL42IFJU9KFQ+tsegqzemfs+Z3NsLR13DvXf6M1lGPJ1U++SC1AK1tcckW+E2r9I
	ObYR5AwLeICTlg4Id3E6NwV3gTm/HmFkqurxw+1m902x+UN4xCUGw9CSfEGorE0A+jSyRV2TSY/
	y5GNYc5ZuQ8UhlwChNuQu9762kN3BQTCYznZxh0yzXkq4GmcpXv2A438lpCaU7ar9BlqZSTFu/4
	SiNyMdsC3YLVw74YvLDO+8zdqHXvQeE4gpC4IoifVswbGajA8DhQlOvBtTwSRhEBm2whSLR6Yz6
	qyVo890USq0kIYkL6T0FlKmzNCtB/VAr/m9QqzQafiADCp
X-Received: by 2002:a05:6a20:9d90:b0:390:ca32:da2c with SMTP id adf61e73a8af0-39545ed46fdmr7373188637.24.1771849988581;
        Mon, 23 Feb 2026 04:33:08 -0800 (PST)
Received: from LAPTOP-FDBL0TVI.localdomain ([49.37.157.71])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c70b71a73e1sm7454739a12.13.2026.02.23.04.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 04:33:08 -0800 (PST)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Subject: [RFC PATCH v4 4/4] mm/damon: add PA-mode cache for eligible memory detection lag
Date: Mon, 23 Feb 2026 12:32:32 +0000
Message-ID: <20260223123232.12851-5-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260223123232.12851-1-ravis.opensrc@gmail.com>
References: <20260223123232.12851-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: cnstak8ds1whwr4gxmqzhyeri8gcs1oi
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E7403140002
X-HE-Tag: 1771849989-49553
X-HE-Meta: U2FsdGVkX1+zCMrJxwpZZUzU+mOsPXiwoTz9j/Cd2QOZatL/dhY4PqlsI78eAW6uLzGBD9cRrBGHG4PkzoqpucazRp3tmNPlxJBa5iSiQxdrNXS0i//EIiRUBzJoaei3nV1fmu5bKyWDqwxiRJvqr4QfIYHrQMMr7kyxtLL86wwNFxAnPE9/B3CERwDzswrf3DpFEmsFdBlDkgPMIqPhb9bZ3XOZnGvOCiDFNLFYVlLrB2KvbzoYIJJMEPJc1jZFHKGS47hulGlhtzqcGEvQaTVlJ68Gk5sI6JExkw8M4dK1fBApvgMqCMULYXUuGUm8XR0tzHuTKjAd2MvZvrOZS01tt/WcJK/aF3YtlLM1A/OHH11N6sZYVGxfH2RBsSJ7zZtMLO07FpNkCtpMeCDNDtaZxgHd9UeqUFb+EONHA2ixluEnfjQ/xQyKMKjUx0fZzYD4IETWzT/97R1GDcxUs1A1DqOM7pTUlZQs0N+RZg3GMHg8jDkiZj6hzQGvKEQ6fqa7IGwGUmXiyPKVUcPlU9qpyzVVIuj3rkRrRoloA1y7sHKNKPlApf0mhrSK3ZkRaWH360kEzt7u+X6594vxEJfNtOz19RweQ0i/7SqtoFvPVnFf4GRsMt+slM8uplotsoYnI149QzQnswj9kFKRaF+sCTAp2UFv1g6cKoPOyZNPn7tX7GB/VwVzu23Q7lcFhA9emhoY1AaO6qm/xOBEbcaaxBfjyf+aSO31pNOeZcq+HnzgIsgWIfpoCTZFR6qoVM07ylbdRp7HzJFV/MP4SMxOd1CQ7swe0V82lFRZpHv7k2Wt/Hb4DYtI12pImJ70FgoHHXVtltvSGeQlusT++M0atnVhUTIMXH26HAuomAmYenJPhVB8tMjt6vwpRz6JSsxb2gMUFR5OfygqOGoOvNrCJpXtAkeQbHcO7KYf7i2ee/ycrakM1FSr1hG0sH3BI08RtZbKqTfdM4ZXcKL
 CvwdcPLr
 4uj+zSmAnE04xS+X00j80NKT/IC4uCdCFPPrBgkRTVvWpgDDtddO9PbfVuS+xwlDEg+Fd7lCNU6at75/MkeTezYjLFBMdxgIrWYbkKOHMR3BsSJ99TizmJwI+V1XpP/phMzytT4W8FovcxG5vzDJ56ye3ynFg3tsqXfww0ZqOCPVbKXMci0vlUgpsbOu9+r4l5SbzHUWHtbuI2+3yuWAYuK515OeJlIEPKB5ZOkHHgkb4xz/6zXZLwgR8ZnNYYqJAPM2Mbhw4INNobmyfTfonVlORQD4yV+2WKvgneoUx8ksyst56Bn8+IvG9VGEmQi8YSNY4thGbwZlEomVkvaKku67rSPC1kJw2dij7brR7j0FZOBmiJvGnufdeoxiYoDF//uorV2yR8rzfwb9zb6/F2tvbolTQWBclRtG2z4GfPbBRjvK0p25Vb0+mTsmc6eJj/tk7W21gTUuI+Tu5pLPdvZvIE8BxxMd2tyJOsltLEeF/GyJRsqwbHCf3I1Z47x5+bS3FORb15TGrJ0E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In PA-mode, DAMON needs time to re-detect hot memory at new physical
addresses after migration. This causes the goal metrics to temporarily
show incorrect values until detection catches up.

Add an eligible cache mechanism to compensate for this detection lag:

- Track migration deltas per node using a rolling window that
  automatically expires old data
- Use direction-aware adjustment: for target nodes (receiving memory),
  use max(detected, predicted) to ensure migrated memory is counted
  even before detection catches up; for source nodes (losing memory),
  use predicted values when detection shows unreliable low values
- Maintain the zero-sum property across nodes to preserve total
  eligible memory
- Include cooldown mechanism to keep cache active while detection
  stabilizes after migration stops
- Add time-based expiry to clear stale cache data when no migration
  occurs for a configured period

The cache uses max_eligible tracking to handle detection oscillation,
prioritizing peak observed values over potentially stale snapshots.
A threshold check prevents quota oscillation when detection swings
between zero and small values.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 include/linux/damon.h    |  45 +++++
 mm/damon/core.c          | 421 +++++++++++++++++++++++++++++++++++----
 mm/damon/sysfs-schemes.c |  30 +++
 3 files changed, 460 insertions(+), 36 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 6df716533fbf..230f95910aab 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -541,6 +541,49 @@ struct damos_migrate_dests {
 	size_t nr_dests;
 };
 
+#define DAMOS_ELIGIBLE_CACHE_SLOTS	4
+#define DAMOS_ELIGIBLE_CACHE_COOLDOWN	3
+#define DAMOS_ELIGIBLE_CACHE_TIMEOUT_MS	10000	/* 10 seconds */
+
+/**
+ * struct damos_eligible_cache - Cache for bridging detection lag after migration.
+ * @base_eligible:	Snapshot of eligible_bytes_per_node at cache creation.
+ * @max_eligible:	Maximum detected eligible seen while cache active.
+ * @migration_delta:	Net bytes migrated TO each node per slot (negative = FROM).
+ * @current_slot:	Current slot index in the rolling window.
+ * @cooldown:		Intervals remaining before cache can deactivate.
+ * @active:		True if cache has recent migration data.
+ * @last_migration_jiffies: Timestamp of last migration for time-based expiry.
+ *
+ * For PA-mode migration, DAMON needs time to re-detect hot memory at new
+ * physical addresses after migration. This cache tracks recent migrations
+ * using a rolling window, allowing goal metric calculation to account for
+ * detection lag. The rolling window automatically expires old migrations
+ * after DAMOS_ELIGIBLE_CACHE_SLOTS intervals.
+ *
+ * The cache maintains zero-sum property: bytes subtracted from source node
+ * equal bytes added to target node, preserving total eligible memory.
+ *
+ * max_eligible tracks the highest detected eligible value seen while the cache
+ * is active. This provides a fallback when both base_eligible and current
+ * detection are 0 due to detection oscillation timing.
+ *
+ * Time-based expiry: The cache clears all slots and deactivates if no migration
+ * occurs for DAMOS_ELIGIBLE_CACHE_TIMEOUT_MS milliseconds. This prevents stale
+ * delta data from persisting indefinitely across test runs or after migration
+ * completes.
+ */
+struct damos_eligible_cache {
+	unsigned long base_eligible[MAX_NUMNODES];
+	unsigned long max_eligible[MAX_NUMNODES];
+	long migration_delta[DAMOS_ELIGIBLE_CACHE_SLOTS][MAX_NUMNODES];
+	unsigned int current_slot;
+	unsigned int cooldown;
+	bool active;
+	unsigned long last_migration_jiffies;
+	unsigned long timeout_ms;	/* Configurable timeout, 0 = use default */
+};
+
 /**
  * struct damos - Represents a Data Access Monitoring-based Operation Scheme.
  * @pattern:		Access pattern of target regions.
@@ -560,6 +603,7 @@ struct damos_migrate_dests {
  * @last_applied:	Last @action applied ops-managing entity.
  * @stat:		Statistics of this scheme.
  * @eligible_bytes_per_node: Scheme-eligible bytes per NUMA node.
+ * @eligible_cache:	Cache for detection lag compensation.
  * @max_nr_snapshots:	Upper limit of nr_snapshots stat.
  * @list:		List head for siblings.
  *
@@ -650,6 +694,7 @@ struct damos {
 	void *last_applied;
 	struct damos_stat stat;
 	unsigned long eligible_bytes_per_node[MAX_NUMNODES];
+	struct damos_eligible_cache eligible_cache;
 	unsigned long max_nr_snapshots;
 	struct list_head list;
 };
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3e1cb850f067..4d39b5da2865 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -488,6 +488,8 @@ struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
 	scheme->migrate_dests = (struct damos_migrate_dests){};
 	scheme->target_nid = target_nid;
 
+	memset(&scheme->eligible_cache, 0, sizeof(scheme->eligible_cache));
+
 	return scheme;
 }
 
@@ -2311,6 +2313,11 @@ static void damos_walk_cancel(struct damon_ctx *ctx)
 	mutex_unlock(&ctx->walk_control_lock);
 }
 
+/* Forward declarations for eligible cache management */
+static bool damos_scheme_uses_eligible_metrics(struct damos *s);
+static void damos_update_eligible_cache(struct damos *s, int target_nid,
+					int source_nid, unsigned long sz_applied);
+
 static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		struct damon_region *r, struct damos *s)
 {
@@ -2375,6 +2382,19 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 	if (s->action != DAMOS_STAT)
 		r->age = 0;
 
+	/*
+	 * Update eligible cache for migration actions. The source_nid is
+	 * derived from the region's physical address before migration.
+	 */
+	if (sz_applied > 0 && damos_scheme_uses_eligible_metrics(s) &&
+	    (s->action == DAMOS_MIGRATE_HOT || s->action == DAMOS_MIGRATE_COLD)) {
+		phys_addr_t paddr = (phys_addr_t)r->ar.start * c->addr_unit;
+		int source_nid = pfn_to_nid(PHYS_PFN(paddr));
+
+		damos_update_eligible_cache(s, s->target_nid, source_nid,
+					    sz_applied);
+	}
+
 update_stat:
 	damos_update_stat(s, sz, sz_applied, sz_ops_filter_passed);
 }
@@ -2530,21 +2550,7 @@ static unsigned long damos_get_node_memcg_used_bp(
 		numerator = i.totalram - used_pages;
 	return mult_frac(numerator, 10000, i.totalram);
 }
-#else
-static __kernel_ulong_t damos_get_node_mem_bp(
-		struct damos_quota_goal *goal)
-{
-	return 0;
-}
-
-static unsigned long damos_get_node_memcg_used_bp(
-		struct damos_quota_goal *goal)
-{
-	return 0;
-}
-#endif
 
-#ifdef CONFIG_NUMA
 /*
  * damos_scheme_uses_eligible_metrics() - Check if scheme uses eligible metrics.
  * @s: The scheme
@@ -2565,6 +2571,10 @@ static bool damos_scheme_uses_eligible_metrics(struct damos *s)
 	return false;
 }
 
+/* Forward declarations for cache-adjusted eligible calculations */
+static long damos_get_total_delta(struct damos *s, int nid);
+static unsigned long damos_get_effective_eligible(struct damos *s, int nid);
+
 /*
  * damos_calc_eligible_bytes_per_node() - Calculate eligible bytes per node.
  * @c: The DAMON context
@@ -2572,7 +2582,8 @@ static bool damos_scheme_uses_eligible_metrics(struct damos *s)
  *
  * Calculates scheme-eligible bytes per NUMA node based on access pattern
  * matching. A region is eligible if it matches the scheme's access pattern
- * (size, nr_accesses, age).
+ * (size, nr_accesses, age). This does NOT apply address filters - it shows
+ * all memory that matches access patterns regardless of source/target nodes.
  */
 static void damos_calc_eligible_bytes_per_node(struct damon_ctx *c,
 		struct damos *s)
@@ -2587,6 +2598,7 @@ static void damos_calc_eligible_bytes_per_node(struct damon_ctx *c,
 
 	damon_for_each_target(t, c) {
 		damon_for_each_region(r, t) {
+			/* Only check access pattern, NOT address filters */
 			if (!__damos_valid_target(r, s))
 				continue;
 			paddr = (phys_addr_t)r->ar.start * c->addr_unit;
@@ -2596,38 +2608,352 @@ static void damos_calc_eligible_bytes_per_node(struct damon_ctx *c,
 					damon_sz_region(r) * c->addr_unit;
 		}
 	}
+
+	/*
+	 * Update max_eligible tracking when cache is active. This captures
+	 * peak detection values during migration window.
+	 */
+	if (s->eligible_cache.active) {
+		for_each_online_node(nid) {
+			if (s->eligible_bytes_per_node[nid] >
+			    s->eligible_cache.max_eligible[nid])
+				s->eligible_cache.max_eligible[nid] =
+					s->eligible_bytes_per_node[nid];
+		}
+	}
+}
+
+static void damos_refresh_cache_base(struct damos *s)
+{
+	int nid;
+
+	for_each_online_node(nid) {
+		s->eligible_cache.base_eligible[nid] =
+			s->eligible_bytes_per_node[nid];
+		s->eligible_cache.max_eligible[nid] = 0;
+	}
+}
+
+static long damos_get_total_delta(struct damos *s, int nid)
+{
+	long total = 0;
+	int slot;
+
+	for (slot = 0; slot < DAMOS_ELIGIBLE_CACHE_SLOTS; slot++)
+		total += s->eligible_cache.migration_delta[slot][nid];
+
+	return total;
+}
+
+/*
+ * damos_get_effective_eligible() - Get cache-adjusted eligible bytes.
+ * @s: The scheme
+ * @nid: Node ID
+ *
+ * Returns eligible bytes adjusted for detection lag. Uses direction-aware
+ * logic: max() for nodes that received memory (target), min() for nodes
+ * that lost memory (source). This prevents both over-counting and under-
+ * counting while preserving the total across all nodes.
+ */
+static unsigned long damos_get_effective_eligible(struct damos *s, int nid)
+{
+	unsigned long detected, predicted, base;
+	long delta;
+
+	if (nid < 0 || nid >= MAX_NUMNODES)
+		return 0;
+
+	detected = s->eligible_bytes_per_node[nid];
+
+	/* Cache inactive - use detection directly */
+	if (!s->eligible_cache.active)
+		return detected;
+
+	delta = damos_get_total_delta(s, nid);
+
+	/* No migration involving this node */
+	if (delta == 0)
+		return detected;
+
+	base = s->eligible_cache.base_eligible[nid];
+
+	if (delta > 0) {
+		/* Target node: memory added, detection lagging behind reality */
+		predicted = base + delta;
+		return max(detected, predicted);
+	} else {
+		/*
+		 * Source node: memory removed, detection may show stale values.
+		 * Use base_eligible (snapshot at cache activation) for the
+		 * prediction to maintain zero-sum property with target nodes.
+		 *
+		 * Note: We intentionally do NOT use max_seen here because it
+		 * would break zero-sum. max_seen captures the highest detection
+		 * which may include memory that has since been migrated away.
+		 * Using it would prevent source reduction, making cur_value
+		 * unable to reach the goal.
+		 */
+		unsigned long removed = (unsigned long)(-delta);
+		unsigned long max_seen = s->eligible_cache.max_eligible[nid];
+
+		/*
+		 * Use base as the prediction anchor. If base is 0 (cache just
+		 * activated), fall back to detected as a reasonable starting
+		 * point.
+		 */
+		if (base == 0 && detected > 0)
+			base = detected;
+
+		predicted = (removed > base) ? 0 : base - removed;
+
+		/*
+		 * If detected is 0 or significantly below predicted, detection
+		 * is at an oscillation trough due to PA-mode sampling noise.
+		 * Trust the prediction rather than the unreliable low detected
+		 * value. Also use max_seen as a sanity check - if detected is
+		 * below max_seen but above predicted, detection is recovering
+		 * and we should trust it.
+		 */
+		if (detected == 0)
+			return predicted;
+
+		/*
+		 * If detected dropped significantly below what we've seen,
+		 * it's likely oscillation. Use predicted to smooth it out.
+		 */
+		if (max_seen > 0 && detected < max_seen / 4 && predicted > detected)
+			return predicted;
+
+		/*
+		 * If detected has grown significantly beyond base, new hot
+		 * memory has appeared since cache activation. The cache
+		 * snapshot is stale, so trust detection over the stale
+		 * prediction. This prevents grossly underestimating source
+		 * memory when the workload creates new hot regions.
+		 */
+		if (detected > base * 2)
+			return detected;
+
+		return min(detected, predicted);
+	}
+}
+
+/*
+ * damos_get_total_effective_eligible() - Sum effective eligible across nodes.
+ * @s: The scheme
+ *
+ * Used as denominator for goal metrics. Zero-sum property of cache ensures
+ * this equals the true total of hot memory.
+ */
+static unsigned long damos_get_total_effective_eligible(struct damos *s)
+{
+	unsigned long total = 0;
+	int nid;
+
+	for_each_online_node(nid)
+		total += damos_get_effective_eligible(s, nid);
+
+	return total;
 }
 
 static unsigned long damos_get_node_eligible_mem_bp(struct damos *s, int nid)
 {
-	unsigned long total_eligible = 0;
+	unsigned long total_eligible;
 	unsigned long node_eligible;
-	int n;
 
 	if (nid < 0 || nid >= MAX_NUMNODES)
 		return 0;
 
-	for_each_online_node(n)
-		total_eligible += s->eligible_bytes_per_node[n];
+	/* Use effective eligible which compensates for detection lag */
+	total_eligible = damos_get_total_effective_eligible(s);
 
+	/*
+	 * If no eligible memory anywhere, return 0. The caller
+	 * (damos_set_quota_goal_current_value) should skip updating
+	 * cur_value when total_eligible=0 to avoid incorrect adjustments.
+	 */
 	if (!total_eligible)
 		return 0;
 
-	node_eligible = s->eligible_bytes_per_node[nid];
+	node_eligible = damos_get_effective_eligible(s, nid);
 
 	return mult_frac(node_eligible, 10000, total_eligible);
 }
 
+/*
+ * damos_get_node_ineligible_mem_bp() - Get ineligible memory ratio for a node.
+ * @s: The DAMOS scheme.
+ * @nid: The NUMA node ID.
+ *
+ * Calculate what percentage of total scheme-eligible (hot) memory is NOT on
+ * the specified node. For PUSH schemes migrating from N0 to N1, this metric
+ * with nid=0 represents "what % of hot memory has been pushed away from N0".
+ * Uses cache-adjusted effective eligible bytes to compensate for detection lag.
+ *
+ * Returns: Basis points (0-10000) of total eligible memory NOT on this node.
+ *          Returns 10000 if eligible_bp=0 (all hot memory elsewhere or no data).
+ *          Note: Caller should skip using this when total_eligible=0.
+ */
 static unsigned long damos_get_node_ineligible_mem_bp(struct damos *s, int nid)
 {
 	unsigned long eligible_bp = damos_get_node_eligible_mem_bp(s, nid);
 
+	/*
+	 * When eligible_bp=0, either:
+	 * - total_eligible=0: caller should skip (detection failed)
+	 * - total_eligible>0: all hot memory is on other nodes (100% migrated)
+	 */
 	if (eligible_bp == 0)
 		return 10000;
 
 	return 10000 - eligible_bp;
 }
+
+/*
+ * damos_update_eligible_cache() - Track migration for goal metric adjustment.
+ * @s: The scheme
+ * @target_nid: Destination node
+ * @source_nid: Source node (derived from region)
+ * @sz_applied: Bytes successfully migrated
+ *
+ * Updates the rolling window cache when migration happens. The delta is
+ * zero-sum: bytes subtracted from source equal bytes added to target.
+ */
+static void damos_update_eligible_cache(struct damos *s, int target_nid,
+					int source_nid, unsigned long sz_applied)
+{
+	unsigned int slot;
+	bool was_inactive;
+
+	if (sz_applied == 0 || source_nid == target_nid)
+		return;
+
+	was_inactive = !s->eligible_cache.active;
+
+	/* First migration after cache inactive? Take fresh base snapshot */
+	if (was_inactive)
+		damos_refresh_cache_base(s);
+
+	slot = s->eligible_cache.current_slot;
+
+	/* Update migration delta (zero-sum) */
+	if (source_nid >= 0 && source_nid < MAX_NUMNODES)
+		s->eligible_cache.migration_delta[slot][source_nid] -= sz_applied;
+
+	if (target_nid >= 0 && target_nid < MAX_NUMNODES)
+		s->eligible_cache.migration_delta[slot][target_nid] += sz_applied;
+
+	s->eligible_cache.active = true;
+	/* Reset cooldown on every migration to allow detection to stabilize */
+	s->eligible_cache.cooldown = DAMOS_ELIGIBLE_CACHE_COOLDOWN;
+	/* Track timestamp for time-based expiry */
+	s->eligible_cache.last_migration_jiffies = jiffies;
+}
+
+/*
+ * damos_advance_cache_window() - Advance rolling window at interval boundary.
+ * @s: The scheme
+ *
+ * Called at end of apply interval. Advances to next slot, clearing old data.
+ * Uses time-based expiry: if no migration for the configured timeout (or
+ * default DAMOS_ELIGIBLE_CACHE_TIMEOUT_MS), clear all slots and deactivate
+ * cache to prevent stale data accumulation.
+ */
+static void damos_advance_cache_window(struct damos *s)
+{
+	unsigned int next_slot;
+	unsigned long timeout_ms;
+	int nid, slot;
+	bool has_delta = false;
+	bool timeout_expired;
+
+	if (!s->eligible_cache.active)
+		return;
+
+	/* Advance to next slot */
+	next_slot = (s->eligible_cache.current_slot + 1) % DAMOS_ELIGIBLE_CACHE_SLOTS;
+
+	/*
+	 * Time-based expiry: if no migration for timeout period, clear ALL
+	 * slots and deactivate cache. This prevents stale delta data from
+	 * persisting indefinitely when migration has stopped.
+	 *
+	 * Only check timeout when cache has been used (last_migration_jiffies != 0).
+	 * When last_migration_jiffies is 0 (initial state), the timeout check
+	 * would always be true since jiffies is typically much larger, causing
+	 * immediate cache expiry before any migration can happen.
+	 *
+	 * Use configurable timeout if set, otherwise use default.
+	 */
+	timeout_ms = s->eligible_cache.timeout_ms;
+	if (!timeout_ms)
+		timeout_ms = DAMOS_ELIGIBLE_CACHE_TIMEOUT_MS;
+
+	timeout_expired = s->eligible_cache.last_migration_jiffies &&
+			time_after(jiffies,
+			s->eligible_cache.last_migration_jiffies +
+			msecs_to_jiffies(timeout_ms));
+
+	if (timeout_expired) {
+		/* Clear all slots */
+		for (slot = 0; slot < DAMOS_ELIGIBLE_CACHE_SLOTS; slot++)
+			memset(s->eligible_cache.migration_delta[slot], 0,
+			       sizeof(s->eligible_cache.migration_delta[slot]));
+		s->eligible_cache.active = false;
+		s->eligible_cache.cooldown = 0;
+		damos_refresh_cache_base(s);
+		return;
+	}
+
+	/*
+	 * Normal operation: only clear slot when cooldown expired.
+	 * During cooldown, preserve deltas for accurate compensation
+	 * while detection stabilizes.
+	 */
+	if (s->eligible_cache.cooldown == 0) {
+		memset(s->eligible_cache.migration_delta[next_slot], 0,
+		       sizeof(s->eligible_cache.migration_delta[next_slot]));
+	}
+
+	s->eligible_cache.current_slot = next_slot;
+
+	/* Check if any delta remains in any slot */
+	for (slot = 0; slot < DAMOS_ELIGIBLE_CACHE_SLOTS && !has_delta; slot++) {
+		for_each_online_node(nid) {
+			if (s->eligible_cache.migration_delta[slot][nid] != 0) {
+				has_delta = true;
+				break;
+			}
+		}
+	}
+
+	/*
+	 * Deactivate only when no recent migrations AND cooldown expired.
+	 * Cooldown keeps cache active after migration stops, giving detection
+	 * time to stabilize at the new physical addresses.
+	 */
+	if (!has_delta) {
+		if (s->eligible_cache.cooldown > 0) {
+			s->eligible_cache.cooldown--;
+		} else {
+			s->eligible_cache.active = false;
+			damos_refresh_cache_base(s);
+		}
+	}
+}
 #else
+static __kernel_ulong_t damos_get_node_mem_bp(
+		struct damos_quota_goal *goal)
+{
+	return 0;
+}
+
+static unsigned long damos_get_node_memcg_used_bp(
+		struct damos_quota_goal *goal)
+{
+	return 0;
+}
+
 static bool damos_scheme_uses_eligible_metrics(struct damos *s)
 {
 	return false;
@@ -2647,6 +2973,15 @@ static unsigned long damos_get_node_ineligible_mem_bp(struct damos *s, int nid)
 {
 	return 0;
 }
+
+static void damos_update_eligible_cache(struct damos *s, int target_nid,
+					int source_nid, unsigned long sz_applied)
+{
+}
+
+static void damos_advance_cache_window(struct damos *s)
+{
+}
 #endif
 
 /*
@@ -2691,12 +3026,21 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal,
 		goal->current_value = damos_get_node_memcg_used_bp(goal);
 		break;
 	case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
-		goal->current_value = damos_get_node_eligible_mem_bp(s,
-				goal->nid);
-		break;
 	case DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP:
-		goal->current_value = damos_get_node_ineligible_mem_bp(s,
-				goal->nid);
+		/*
+		 * Only update cur_value when we have valid detection data.
+		 * When detection fails (total_eligible=0), keep the previous
+		 * cur_value so auto-tuning continues based on last known state
+		 * rather than making incorrect adjustments based on no data.
+		 */
+		if (damos_get_total_effective_eligible(s)) {
+			if (goal->metric == DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP)
+				goal->current_value = damos_get_node_eligible_mem_bp(
+						s, goal->nid);
+			else
+				goal->current_value = damos_get_node_ineligible_mem_bp(
+						s, goal->nid);
+		}
 		break;
 	case DAMOS_QUOTA_ACTIVE_MEM_BP:
 	case DAMOS_QUOTA_INACTIVE_MEM_BP:
@@ -2709,9 +3053,9 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal,
 }
 
 /* Return the highest score since it makes schemes least aggressive */
-static unsigned long damos_quota_score(struct damos_quota *quota)
+static unsigned long damos_quota_score(struct damos_quota *quota,
+		struct damos *s)
 {
-	struct damos *s = container_of(quota, struct damos, quota);
 	struct damos_quota_goal *goal;
 	unsigned long highest_score = 0;
 
@@ -2725,17 +3069,19 @@ static unsigned long damos_quota_score(struct damos_quota *quota)
 	return highest_score;
 }
 
-static void damos_goal_tune_esz_bp_consist(struct damos_quota *quota)
+static void damos_goal_tune_esz_bp_consist(struct damos_quota *quota,
+		struct damos *s)
 {
-	unsigned long score = damos_quota_score(quota);
+	unsigned long score = damos_quota_score(quota, s);
 
 	quota->esz_bp = damon_feed_loop_next_input(
 			max(quota->esz_bp, 10000UL), score);
 }
 
-static void damos_goal_tune_esz_bp_temporal(struct damos_quota *quota)
+static void damos_goal_tune_esz_bp_temporal(struct damos_quota *quota,
+		struct damos *s)
 {
-	unsigned long score = damos_quota_score(quota);
+	unsigned long score = damos_quota_score(quota, s);
 
 	if (score >= 10000)
 		quota->esz_bp = 0;
@@ -2748,7 +3094,8 @@ static void damos_goal_tune_esz_bp_temporal(struct damos_quota *quota)
 /*
  * Called only if quota->ms, or quota->sz are set, or quota->goals is not empty
  */
-static void damos_set_effective_quota(struct damos_quota *quota)
+static void damos_set_effective_quota(struct damos_quota *quota,
+		struct damos *s)
 {
 	unsigned long throughput;
 	unsigned long esz = ULONG_MAX;
@@ -2760,9 +3107,9 @@ static void damos_set_effective_quota(struct damos_quota *quota)
 
 	if (!list_empty(&quota->goals)) {
 		if (quota->goal_tuner == DAMOS_QUOTA_GOAL_TUNER_CONSIST)
-			damos_goal_tune_esz_bp_consist(quota);
+			damos_goal_tune_esz_bp_consist(quota, s);
 		else if (quota->goal_tuner == DAMOS_QUOTA_GOAL_TUNER_TEMPORAL)
-			damos_goal_tune_esz_bp_temporal(quota);
+			damos_goal_tune_esz_bp_temporal(quota, s);
 		esz = quota->esz_bp / 10000;
 	}
 
@@ -2815,7 +3162,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	/* First charge window */
 	if (!quota->total_charged_sz && !quota->charged_from) {
 		quota->charged_from = jiffies;
-		damos_set_effective_quota(quota);
+		damos_set_effective_quota(quota, s);
 	}
 
 	/* New charge window starts */
@@ -2833,7 +3180,9 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 		quota->charged_sz = 0;
 		if (trace_damos_esz_enabled())
 			cached_esz = quota->esz;
-		damos_set_effective_quota(quota);
+		damos_set_effective_quota(quota, s);
+		/* Advance cache window at end of apply interval */
+		damos_advance_cache_window(s);
 		if (trace_damos_esz_enabled() && quota->esz != cached_esz)
 			damos_trace_esz(c, s, quota);
 	}
diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 232b33f5cbfb..bf68c3157c19 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1501,6 +1501,7 @@ struct damon_sysfs_quotas {
 	unsigned long reset_interval_ms;
 	unsigned long effective_sz;	/* Effective size quota in bytes */
 	enum damos_quota_goal_tuner goal_tuner;
+	unsigned long effective_bytes_cache_timeout_ms;
 };
 
 static struct damon_sysfs_quotas *damon_sysfs_quotas_alloc(void)
@@ -1675,6 +1676,27 @@ static ssize_t goal_tuner_store(struct kobject *kobj,
 	return -EINVAL;
 }
 
+static ssize_t effective_bytes_cache_timeout_ms_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_quotas *quotas = container_of(kobj,
+			struct damon_sysfs_quotas, kobj);
+
+	return sysfs_emit(buf, "%lu\n", quotas->effective_bytes_cache_timeout_ms);
+}
+
+static ssize_t effective_bytes_cache_timeout_ms_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_quotas *quotas = container_of(kobj,
+			struct damon_sysfs_quotas, kobj);
+	int err = kstrtoul(buf, 0, &quotas->effective_bytes_cache_timeout_ms);
+
+	if (err)
+		return -EINVAL;
+	return count;
+}
+
 static void damon_sysfs_quotas_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_quotas, kobj));
@@ -1695,12 +1717,16 @@ static struct kobj_attribute damon_sysfs_quotas_effective_bytes_attr =
 static struct kobj_attribute damon_sysfs_quotas_goal_tuner_attr =
 		__ATTR_RW_MODE(goal_tuner, 0600);
 
+static struct kobj_attribute damon_sysfs_quotas_cache_timeout_ms_attr =
+		__ATTR_RW_MODE(effective_bytes_cache_timeout_ms, 0600);
+
 static struct attribute *damon_sysfs_quotas_attrs[] = {
 	&damon_sysfs_quotas_ms_attr.attr,
 	&damon_sysfs_quotas_sz_attr.attr,
 	&damon_sysfs_quotas_reset_interval_ms_attr.attr,
 	&damon_sysfs_quotas_effective_bytes_attr.attr,
 	&damon_sysfs_quotas_goal_tuner_attr.attr,
+	&damon_sysfs_quotas_cache_timeout_ms_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_quotas);
@@ -2822,6 +2848,10 @@ static struct damos *damon_sysfs_mk_scheme(
 	/* Set goal_tuner after damon_new_scheme() as it defaults to CONSIST */
 	scheme->quota.goal_tuner = sysfs_quotas->goal_tuner;
 
+	/* Set cache timeout, use default if 0 */
+	scheme->eligible_cache.timeout_ms =
+		sysfs_quotas->effective_bytes_cache_timeout_ms;
+
 	err = damos_sysfs_add_quota_score(sysfs_quotas->goals, &scheme->quota);
 	if (err) {
 		damon_destroy_scheme(scheme);
-- 
2.43.0


