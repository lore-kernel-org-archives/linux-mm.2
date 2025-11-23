Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA866CFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 18:44:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FBBA6B007B; Sun, 23 Nov 2025 13:43:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A9E26B008A; Sun, 23 Nov 2025 13:43:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18D8F6B0093; Sun, 23 Nov 2025 13:43:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F31D66B007B
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 13:43:49 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BF09156241
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:49 +0000 (UTC)
X-FDA: 84142745778.19.31EA331
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0ACEE160005
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:43:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nFbyDXWf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763923428; a=rsa-sha256;
	cv=none;
	b=z1OkMZ4oggzVWm/GWqkmAJvg7eonk4v3KJtdGBaBYIHeVswjARDZm5rO32ddE5pQz0b4sc
	phfPRKrj4TVCCx38qkJ5aqKwopHvS5ScWfbftKCX0/8+edr9UcFeV/iSVeSP/qHe8o8nYV
	3Rr/L0Rei0NsOKUev6j4RzKE3TB8slM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nFbyDXWf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763923428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GqarwDtp4htPUl/eC7pvnD1zKvnJHDIZoQCInDcT3T4=;
	b=M2k50sS//QuPhbuf4iQy1q+WT3GuxLhGNRdavZ7752Bm4lsVWy3lSdaBYOEg9yuxbZzx+w
	IRKdEZr0Q+hOy6T+mO8PIbaIv5kVpb2pVW9WQP+/3bms8VlJ3Ta5r7f7YohMGWy0rOv+zl
	9HF/BwKl+nKV4uHKUSfIndh0zonJlgM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F28944214;
	Sun, 23 Nov 2025 18:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5155AC16AAE;
	Sun, 23 Nov 2025 18:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763923426;
	bh=+PG482StoL/pY9Nmw7mtPv/d1GxHurtk722prWLmX44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nFbyDXWfQDCIBVZS6Wz1iiSWM8Bt7727WKNonqal+RCrAnXjIk6b9S+LnsPdqmXCc
	 pQa8L1UxoNUY+2fgFLTPXswxycWOqPmQbJl+Atyd1HWi/ycJaB659b96vzV9R/bTeO
	 kjBUJaXSDpE5F94qZWPxiVka8LJZUeBK1/y4rtVmKRsNw2NIxdgdU2hoZ3xqQypkJ6
	 LRDqKh75fYq2dZhIaIsK10Fhaos9L6Sz98Q1OS25PUU3D1qAAGR0nIAH8mRCwwEVXF
	 5EZmetyeh2Ix3Es4+cHqaEHCGWjaC44VHmxsstDIJtgBRpdlVxalq+WjTHgCTpYs2w
	 T+1sF7hgMa42Q==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 07/12] mm/damon/core: implement max_nr_snapshots
Date: Sun, 23 Nov 2025 10:43:21 -0800
Message-ID: <20251123184329.85287-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251123184329.85287-1-sj@kernel.org>
References: <20251123184329.85287-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0ACEE160005
X-Rspamd-Server: rspam07
X-Stat-Signature: 6szxpx9ffmw1da7r5581tjahpgx76xth
X-Rspam-User: 
X-HE-Tag: 1763923427-675822
X-HE-Meta: U2FsdGVkX199iBZ1h9hcM7AUcCXBXyGv+6VVynbmZMsOHyt4eyUd710jEmREwrlyw9q9TnOfd79T7zh0+23khu8MS6VMUe7oKiWUOfpHPP0qZ790pK9Mo0fX2/6iOR8DW2uoUFHohWFltDCV/ZXa5Livro4hjA1jTynNLA6ucr8R0fRIPBJHDvdKczwH05QFuaKPuoOyoIyND/puXVk7MvbpUXpmdXRN1LEOUOdqc0QiLc97nvJmd34sGV0eisx93XlalTdFyVPpCG6wt5JaXAu9ksQY1jJMly8Je3gvKNUf6Q2/kcJCfC7raWNjhQESRdmAviJbIpNqnjVuI2UVyqwyv8BjIjx1UhrbQQCZS76T28dvqQohbY+9TqCrMyBGEgpOsh68Og7lTtm+El3Ss/Qjcp8Wl8LRKplXGgPXyQtftxOA3xyiKp6DFzDWouLHn/HHMRxxPxs17hYbHVWE9iLBIprflUaxl5g9h30FmxGFv0kS/yrvqfAzE9tfFAjNrn22Yi2l2jTs4d+soVCxxlewf0V6DLZAtG0A5onAgyUq3a1jAfj8YmCztgDAKyn8BgUwxSbWtn1bpVsjZjVtmaYVGkcETNDiAqVdHOqCrBjwkks6c3MYIMwRyuFtGQyxPLvtJ6UhQvturWdVBhaIuGyKgV4okleIEbVQMQlmSWOXsE6i+zXXsR2/dRHU4lPa1TP48E0/9XR4jYgi6zkco3fKF9bB2uFpzfcFCiewMerVUoAmRsOlHmEqchy9ysBjWrUIrbzjehboG3M8MyLoUpO8pU4vUS0+evC2t/thDWGS5EWMyy5kLdQOPvdDVbhB4HYjWnP9BWDgREusfFkMxt2jN0a1GAbbx2ZzFnfZM49F6rwx5sxSLObqPvIbNBqrW7qKo4Mtaoj9C299XW793mEdtlCgdlZmIRioNMo7XkI7Yip6X5QpY2weGEHtBDQvP2gko1ppxpBsh54tZ6z
 THQKnXXC
 vl2z8JvYfB4S5B8oxh4uioueT8pLFWy+z/DPNYgu7CK3J6MUn4/boddH/1ER6+AoJBfZkTqhz3igUfDL9oxMturyfea9xO3fCdkvndRaJUG7hj8T7TL2dymjjeiqr8AB1cOPrdb78TNKvH8cKdwMrw6gk08WDU8HVWwW+YbASTQQD0vVacXsQrJlfs9kETbtuVJ2PW1L78hAd2ds2knGgNuiRVKkE4tfJlbJm0wEZc2hruYI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are DAMOS use cases that require user-space centric control of its
activation and deactivation.  Having the control plane on the
user-space, or using DAMOS as a way for monitoring results collection
are such examples.

DAMON parameters online commit, DAMOS quotas and watermarks can be
useful for this purpose.  However, those features work only at the
sub-DAMON-snapshot level.  In some use cases, the DAMON-snapshot level
control is required.  For example, in DAMOS-based monitoring results
collection use case, the user online-installs a DAMOS scheme with
DAMOS_STAT action, wait it be applied to whole regions of a single
DAMON-snapshot, retrieves the stats and tried regions information, and
online-uninstall the scheme.  It is efficient to ensure the lifetime of
the scheme as no more no less one snapshot consumption.

To support such use cases, introduce a new DAMOS core API per-scheme
parameter, namely max_nr_snapshots.  As the name implies, it is the
upper limit of nr_snapshots, which is a DAMOS stat that represents the
number of DAMON-snapshots that the scheme has fully applied.  If the
limit is set with a non-zero value and nr_snapshots reaches or exceeds
the limit, the scheme is deactivated.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  5 +++++
 mm/damon/core.c       | 11 ++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 43dfbfe2292f..a67292a2f09d 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -499,6 +499,7 @@ struct damos_migrate_dests {
  * @ops_filters:	ops layer handling &struct damos_filter objects list.
  * @last_applied:	Last @action applied ops-managing entity.
  * @stat:		Statistics of this scheme.
+ * @max_nr_snapshots:	Upper limit of nr_snapshots stat.
  * @list:		List head for siblings.
  *
  * For each @apply_interval_us, DAMON finds regions which fit in the
@@ -533,6 +534,9 @@ struct damos_migrate_dests {
  * finished.
  *
  * After applying the &action to each region, &stat is updated.
+ *
+ * If &max_nr_snapshots is set as non-zero and &stat.nr_snapshots be same to or
+ * greater than it, the scheme is deactivated.
  */
 struct damos {
 	struct damos_access_pattern pattern;
@@ -567,6 +571,7 @@ struct damos {
 	struct list_head ops_filters;
 	void *last_applied;
 	struct damos_stat stat;
+	unsigned long max_nr_snapshots;
 	struct list_head list;
 };
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index af922d5e500c..36313cd1ff1c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -401,6 +401,7 @@ struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
 	INIT_LIST_HEAD(&scheme->core_filters);
 	INIT_LIST_HEAD(&scheme->ops_filters);
 	scheme->stat = (struct damos_stat){};
+	scheme->max_nr_snapshots = 0;
 	INIT_LIST_HEAD(&scheme->list);
 
 	scheme->quota = *(damos_quota_init(quota));
@@ -1078,7 +1079,11 @@ static int damos_commit(struct damos *dst, struct damos *src)
 		return err;
 
 	err = damos_commit_filters(dst, src);
-	return err;
+	if (err)
+		return err;
+
+	dst->max_nr_snapshots = src->max_nr_snapshots;
+	return 0;
 }
 
 static int damon_commit_schemes(struct damon_ctx *dst, struct damon_ctx *src)
@@ -1955,6 +1960,10 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 		if (damos_skip_charged_region(t, &r, s, c->min_sz_region))
 			continue;
 
+		if (s->max_nr_snapshots &&
+				s->max_nr_snapshots <= s->stat.nr_snapshots)
+			continue;
+
 		if (damos_valid_target(c, t, r, s))
 			damos_apply_scheme(c, t, r, s);
 
-- 
2.47.3

