Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DCA9D5C0C0
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 08:01:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F8026B0093; Tue, 16 Dec 2025 03:01:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 054276B0096; Tue, 16 Dec 2025 03:01:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB6826B0098; Tue, 16 Dec 2025 03:01:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D127A6B0093
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:01:47 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 40D30135F2C
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:01:47 +0000 (UTC)
X-FDA: 84224590254.26.D6845AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 92DFE120014
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:01:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D6bSg4ZK;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765872105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4rEG+uTERdzZhw9uyy8FTkWJ5anvwSU/SXl3sZMIhqs=;
	b=M5lx2l8N9cRHSR9aQL017y6AXHyaee/qa6erW0Ko/MNqeka7/0/I+pI5nWVttYwcAVtYQN
	huayPFEOTSurN5o9nIDdIt9SZasKO297uF5QDh+Q6z3/f0mXDXMFHzNbfR+Hu4vCXgQ1TK
	79OIsQS78kHGFVq2jkGC/dGs7snOz00=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D6bSg4ZK;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765872105; a=rsa-sha256;
	cv=none;
	b=r/Y02kdzKhe99DOW89isvcJjG6i+2gdoOOeF4DlOzbjGoJbgkX7Ki5SMIn7seuDWzGNiuv
	OA439FwKCaZNUfio/xzY+3Pz19CeF+ltu5l52eJsuKaP9/jtkiw1Tj/jILoxfyVso4Aghw
	2RN5doi79RUiTvE4G3QdVj34PK1GOlA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 507E54428A;
	Tue, 16 Dec 2025 08:01:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2FEC19423;
	Tue, 16 Dec 2025 08:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765872104;
	bh=FHEw5hu5B8m0TfMg+08OEnZOsjSGxKvHndmP4M5Ow1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D6bSg4ZKdyQZYD8/5fdt9puKkD7nDp9CqTQM85B6Cujj2f6wuAeQamtzQ0fxuB/bK
	 Pfw5mwujN9mnggDHLTLFtyvAvCA/0bmDVgxVZYbo0V0pi2Sk8GoWmi2vPbELWzd1AZ
	 5jDqYGrCnLUKkWQ7YOlMr0CYDc1VGF1It8jJfs7EHbB4by/f222ZygFB8B+6GGfOTL
	 aFFROa5vc+sNKhHBMPZSy+l/A54w1hy8n4PeKvpa0FojLKtagGqY3ttBZrZaH85kAc
	 8SK4mEZnybP+eqNo3652hdmUnzSXo/lv2t80y37HIt4ZOcecE1AHaaWG8YhYUf8MMX
	 DNkmOeY7nMdLg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 01/12] mm/damon/core: introduce nr_snapshots damos stat
Date: Tue, 16 Dec 2025 00:01:14 -0800
Message-ID: <20251216080128.42991-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251216080128.42991-1-sj@kernel.org>
References: <20251216080128.42991-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: 1gfioygp9n69y7fq79utmfct9g6c84yb
X-Rspam-User: 
X-Rspamd-Queue-Id: 92DFE120014
X-HE-Tag: 1765872105-581234
X-HE-Meta: U2FsdGVkX1/kA8LeU/oYx2kUjen8lv4XWZNM5I4h9Gz+mQqGOjDI7lzfCgoW51cE2tQQ5PRYu7XtWewlocn1PKEZcqJi9yAK36Bl6Y6cL3la0FzfoRM/PwIBA0r6W8Ov8YC6T1kTSnO4s9FChtndhDBSx/ZsDHCw0QbIfM3Yu6yiQsef6SsG2z96dlttgd7JLqsq1aMP3A7tkTgPIgnSUYHOWpsICNJtkNi+rgUtVDY8d96s4s69Cz8VBF2IkpQMADZaQKdwtgisBWWx9jmy0LD2bIQEZv9keo8xJCuJpjZ4ui5xzrSi8QZyU7Qk3kirJN9lGKYu8oUjzLgLb9pXbnWk6GAjr3R5L+v4ClAF70QDNkuMA5PZkL94Va+MRq1O9/HSojUA30riwELkwKo7aytFXeB+GrfWqAnz+I/vFzOYsXErAT1+NCMy06YTafGmZ0q6b0LnrPeREiSzmXH1R90sZP2/NJAsWuqFtYfUQGLQ+MBevPuRDNzgev5inTtF5IfAEN7LeWuH/MGLrcpIn2JFtj2IxdlEsddAla6BvRNh9XThFgTaIrFqIhtK2gaaiwyT2TcdEAayD+y8rKhu0xgh6sc3oXpAvUa146acAOYBNilyBx92Nf+MSL96wtABJC8KGvMcw+eVMUdZrIk42rwknWZ1WdfGuxIHvMnQL/8K4hw85LhRErsk2DqD1qNQgKcpMzb4kBcSqyr7C+Pnw2qXi45GY4iYSD4RMQdNV7nqEQSyhktozq5SFK7pE/09b4Rp0ir+3bxbdO+RNXVRh9zeGq2BATvNYDs2sh5ux3R8hqkp96npuTDyiydWtoA/NoQF6kzr3axWGQzfowS28wqFFxJINA/a5m3oleEX0+HuDHp+3jMK1ONmvF7jfAiSO0hqhtIUOF+yXBepFQvtN+2AbGYGA+LThq5pCbrpVNv4Pp0b6TQDOYuNYI/GAZTTXDmH9hRtAsfoTIrm8qv
 yDDw1fo8
 07YvTofJAdgvWnmos7k3B51GbO8jAWuTMzY+1ukx14O00Hvv6fv3VEXZORvJU4HdpKa9w84jlXovm12NAQdpl0xzi9Jsp/XuI0XyZz2gjXPGD69WPa0NiDumAcZ+E5Xk1DUlUIfClF4EOJFaqjnFSKkWTIGbiNTwM+Kn+ka5pPkV4cln2u3uXhxR+s6PZ0fKd4prBizV63HDozwhu2J+OgwNSdpK+fviGEmJhPvH5eQM4b3JqTM1cMCM7o9vqEhX1Qdrn+o1VzaUbQtGn0zLhPDII/A==
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
index 53fb988b6a0d..6f3328b29a65 100644
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

