Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02DF1D5C0C0
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 08:02:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 429156B00A3; Tue, 16 Dec 2025 03:01:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4113D6B00A5; Tue, 16 Dec 2025 03:01:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26B5B6B00A6; Tue, 16 Dec 2025 03:01:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 04F946B00A3
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:01:58 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A7EE6B9DB0
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:01:57 +0000 (UTC)
X-FDA: 84224590674.13.972FDD0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id E9684180019
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:01:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gfRsIXAj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765872116; a=rsa-sha256;
	cv=none;
	b=iu7q6eJZ0uNtsac5DI83QveYTXyLFvnR3iXrvHeW5TW64FFDHuI/lNACmh1s93sGfSlUFf
	vyXT+jceQEmFSgmmjv+05e0sE9BuSegzZ8vTPak03/qK3aPjlG8Q1mhQJkvBJvnUytk+wB
	twmHgdGCOolb1l20st7Y7IjjgrCbmUc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gfRsIXAj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765872116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=na8gXAEAxNsMKiq+dCLmUr1MCP0q/SyJVeDbs7bdHN4=;
	b=5RDqwOSXHhcbvA3G0HUjUlOo5nZ61umV+mzIoGZdfY7akXSz7F9Vt0powLjZRPlaLzyvX2
	jnkifgSPIzsPaq/i443E8mCyHDuoehdA9jG3yaOTv1cNdf4HlEy7N3saTMdvvQnuTRp3Ij
	z1VUaPtbTSBtrVXiGBm7Sb+yS9xc/nw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C93243E59;
	Tue, 16 Dec 2025 08:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079CBC4CEF1;
	Tue, 16 Dec 2025 08:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765872115;
	bh=MUTEKMjwMQrPcHqNBgdPYYcf5dYcs6y7OQyOyiiLOLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gfRsIXAjQLY8IWW5+ZPMlEDxMgvzZhQYGXNtIlKrS0zjcik3mY0694lsIOPczk77+
	 rETP1V1kQdquYP+X7d2xVBiutGayjtXH5iaeYOL4LxLVOSHLLZEe4aQwyuHu0Vph5G
	 +R9zp/vC9U5pxzjGZ/OwHEoNFKwNcf/WXqVT/OHCOp3iIwUzn3/9cq3WOHqCJgDbtz
	 cSlrXe7BnthQsy1nE1l1H672yCkBggMoFbV1g94E741igyUoCmuSTiEgF39vLoenrA
	 VH1EqG36TRdbB5f1ZMm+0aKllIPbS8EN/TlSGwo4UaVdpHoYCJQTVZ9Jx5O3ClMKYx
	 S8s2G3UaNiaHQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 07/12] mm/damon/core: implement max_nr_snapshots
Date: Tue, 16 Dec 2025 00:01:20 -0800
Message-ID: <20251216080128.42991-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251216080128.42991-1-sj@kernel.org>
References: <20251216080128.42991-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E9684180019
X-Rspamd-Server: rspam03
X-Stat-Signature: ugrexcxekscb5iafxjer8hxekmm3myt8
X-Rspam-User: 
X-HE-Tag: 1765872115-199732
X-HE-Meta: U2FsdGVkX19TNPnyU8SyG5URJvlBZNpibm/FoG7u6Nh6dhLFPJ45vseQTxVRuJTm8BN3Iedg3r+CA6H19/0R3cdV1GEjJbbN2pT2bfqDgyLF6hUGkOpoFZl8ZyFK0omDBUOs1W0d7cf0Yo+lH88HgcYjk2oz5Oe3cyPg0E+H1qHUrO4FLSL25dCJ059nwuDfd9VDCmcEyDTqR/PmZeVuVcwN0BHxwKahv2n/0UbWDqVM7eNef3/kRXsDZjP1QPkG+F6SAUmRaCb1DfUI4Kww95IzcMPmqv2fkQDJwjNhxV1awjsufY/05ZYZicPkEV34LzIkkdiXKNUGaFuwb7r66wNoQhUHXdmOpWm2S8hAhyiMsBqGDsFVPg50OJ/69Ys6Hgok7UyW+14rS6u2Gwjqh/xI+HvPm1J1lc7aD+xQhC9GDVQn4Lt2o+18yRRWBDtoeBe6xEJKBl/eco+z1103V47CDORbZ9/VX/yGA5/MfQC2l5/Twri7Cp36ccQYMlWbgO5mqSuB8Ieb723vtoKgQycDPrbu+53L04rRova+QZZON26gUUDcTjFlRxDbZlr9znrCZN3SgQQgK7xIsI3mNrE4Yf72L342psU7x3iADXRVpRWd9IkWZMSnj8BQ3PIVucIEQjeuL8JA9BaL/3uoPdTiI+0M3lfK58tIufTvfkMYLWFNKuuQnuziwnBau1TyJsi93v6E8gf871vwKFCJwretKwQ+Wxy72cWX/jwLfEi/hHZHsEu/xGTHHRhm8CiyFTEvCiG8T4YnwpG0nB8oZk6oRW4pXfftl2ymEKjqw/8TFwV988aiUl+jmkajYdlPGOdJGCx+qkrett68aT5JFpi7kIEtldUHFTdYv71oVqJjMNlT94tXfEmiuUJNzDpQagVcFWEkYE41Gvx7TdvOOlb0fZttZBvkEqSSArcJbCnIvZgyFdBjOmnoyP+HQLytlhtIsh6soDqdXfKBlqb
 y+rIhE5L
 /Q+mXNvSsgjrMzSB0Zx/MhmHHirtBQ3lf85txZY90h6OdziWXb+xIn8SLzFrQaLJ75Im2aVgto1wQVI53mShTa7gTFlNA3x+q57vyzKlxojCR50dt3pbP1BW6tYCZA0ReFsUVXYgBDFfYIOMKQBhKsVfDN0cJ6E5ydUwADta7IqjsRro1yvVGS5xe1YZ04KC59oR9JxczZ2FA94NxzgBctfa5RGF4o0zw8KP3aIuNtb71o1wIxZpFLtcjy+9oU8r+7LuWJv11KQM0YHE8cLVpTgqBRA==
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
index 6f3328b29a65..8908aec6670f 100644
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

