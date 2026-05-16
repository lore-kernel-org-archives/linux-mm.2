Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EDCCCD4F49
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:38:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC57A6B00A3; Sat, 16 May 2026 14:37:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A747D6B00A7; Sat, 16 May 2026 14:37:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9164B6B00A4; Sat, 16 May 2026 14:37:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A0DF6B00A3
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:37:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3F4A1160591
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:32 +0000 (UTC)
X-FDA: 84774141144.24.A75E32D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id AC614120009
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TOKV989N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956650; a=rsa-sha256;
	cv=none;
	b=0mfpO5NLcc5zey+z4zh9zmUWbEPjJUisg0ICM+YStQGKk+HDmY5diLivMuQuhRpdaGhO7r
	EMXz78Pk89ZXtQRDaNwyFk+KBTK/vyYFlDcsmgLuVWXoNdKmR3bhmhh4Tdas+t48QvHAjJ
	l2IbzWEXOyh3Rpla4B/7LBQqw5QxES4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TOKV989N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dfeLI6eA+QztdUCed5CniFz5Ha6ETjsGIUVU5D978wM=;
	b=XdBppkzwGT04ShiUFbGXTWpGvX8WbxMvr+OUOBRYr/gX85deyUmCLWhojSQwiIKj43JW+4
	21ZlcjpkQELhccJJSkJggrWsMFV7iEO2rhdbGwFYjBrnbwa69MXTLRUB87Xgg0sDhU11JU
	KrpgPEAkpWkMmjFsq41d8j8iTCrhuhw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A40E94023A;
	Sat, 16 May 2026 18:37:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3707AC19425;
	Sat, 16 May 2026 18:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956649;
	bh=YQ/bQKvFB6FRBUR2JrGvHQEa09kCyYCD7LjEDEyXhiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TOKV989ND2cKNdGxP5PDsmVUlhDxYOfvNwWeKyweVV/m1LOK2+iouQjtCeLZcTL9u
	 ckuzNLAI+z6eKtXX1s6ATxZwKdlzfq0zOs5whRXO7SHV1q9+aNHd5U5Xeny3VLLYLt
	 1Y+QpEATiGsLtsCp1aSnFTRvP7qRrhnI260X+/s6MlMuZP4s+NFRkWGpO0chmYfWN3
	 FSCONfhKCZh+OLLo+EczCkZODe+PESe+HJS/QIdMj5E8UVUiNU3eADWgALGR8bpHKH
	 d2QeoUMjkVFe1gVy9ti1oI9p1xwZXWhylxFGMXGfa/Ue8+D4A1nYjjT0A/3SqtVTpH
	 KWNN7xmbPbBWA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 14/28] mm/damon/sysfs: setup probes on DAMON core API parameters
Date: Sat, 16 May 2026 11:36:55 -0700
Message-ID: <20260516183712.81393-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: <20260516183712.81393-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5wf6yspmeppu5jeqycmq1npzswi4wcwz
X-Rspam-User: 
X-Rspamd-Queue-Id: AC614120009
X-Rspamd-Server: rspam07
X-HE-Tag: 1778956650-387535
X-HE-Meta: U2FsdGVkX19NLrjzgjRBf+BcHhRRe/g3DIVrdibOmLsp6s4AGxNuwmiHiLBWWMeJTQ5EpuNvwH9lgRC5WSJ4FnlghUYLEH4AJKPCNK6myP4Kt6fhiNGrKUWWC9KQPT9HUc/1Yf4Po4jHX4hH+khDNAczkB+LhfvC5xB9velgrRnqYNUhuLQ1iPE/w3m295JT6lJhgmGd3zYZS+m0vtW5mP7/VrVf1TbuAKtfIqd0N2u2uq2G+GVdBugTQ25nsfNvIfD9nkRhPtL/WfmjFwrhsvxlfJRkcN2lTe0QQ/9vW/IcIpGfsd+fOBpqcGJn9nvHWgbV33kwSlAuSFXhPe4ELyPVy3RL2xOq3cewx9KL/P/6b3bnGTENzntErawMtcDQ+EdE0xpOuXRI17zvYygzJp6LTtHVPq7s7pxFee3NC89SrQ9behb/NraU6FGu0KMVXs2DBRprh2W82qGi+v+gTWAvs6zmy/rSbjfo/L4tK8b5Ig2MqqxyeSIvTEKM/NPbYtFHSnqxFpSOIEFN6nyTIaexYzNv7zHQorAeEOOj2uKNfph4QQx9w+0pNO2sJhJvfFkZRq460yt3nN72O5Y3Ucdyk+wCAcM7sOiPwdyxSmUEXI5PKnkAEIQh2fVzeJJsN9N/q4hQAmzbYdD6aVk0jcPuMnyvSIO9vnh4hhLJxeaPXdPz0SinpElCVYPNauaiJ1rtWaxhL7erU9l61SUx8F/ShneMJ99Pv6PSzUNFNWiYWJbcRc4Jn52C+5w6MRtPqcB6TaEwvmxiUmkcHrZxg/6Eqn3lJSD87WKwmitBzKj9TPyDimgezQkUlvzOEdNm2XvfAX66cYSWTDdnMeq0NNg1s/N1uNLh+MkFdAZI/zvCKpVZFj3iqfmWV5SaJZpiR7jgj0479PeSJhbh5/Vb5fF6JtTJpBwDkfwyo7WWJPVb9DGCSSKl22qNi5PCMS5lsmP30/4+34SgXrct6AK
 I76+/upM
 un5mDXTkjk+ORQc6L4NK7rzco4DK/Yq6Qx94ACxiy3owUn2sS0OciCaAHCC0xnc3cwQ2PQB/cvpisZB3UiOIhWcADnQ6gssjtJbZEscYv9jEcZcpJ3HWjte0gSxc4oE0H+gnoZrsRaF/jAZsvP99q01h1BoAuILi1V3nu8drJ9K6gCZec6k0BU3NZHMUtPx8zSDrsH0rHn+9eS3yX4C087kv78/yar9mgNj0O5yxGPoZAgrs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add user-installed data probes to DAMON core API parameters, so that
user inputs for data probes are passed to DAMON core.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 35a4fa5c530f5..f1b7d79386866 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1825,6 +1825,40 @@ static int damon_sysfs_set_attrs(struct damon_ctx *ctx,
 	return damon_set_attrs(ctx, &attrs);
 }
 
+static int damon_sysfs_set_probes(struct damon_ctx *ctx,
+		struct damon_sysfs_probes *sys_probes)
+{
+	int i;
+
+	for (i = 0; i < sys_probes->nr; i++) {
+		struct damon_sysfs_filters *sys_filters =
+			sys_probes->probes_arr[i]->filters;
+		struct damon_probe *c;
+		int j;
+
+		if (!sys_filters)
+			continue;
+		c = damon_new_probe();
+		if (!c)
+			return -ENOMEM;
+		damon_add_probe(ctx, c);
+
+		for (j = 0; j < sys_filters->nr; j++) {
+			struct damon_sysfs_filter *sys_filter =
+				sys_filters->filters_arr[j];
+			struct damon_filter *filter;
+
+			filter = damon_new_filter(sys_filter->type,
+					sys_filter->matching,
+					sys_filter->allow);
+			if (!filter)
+				return -ENOMEM;
+			damon_add_filter(c, filter);
+		}
+	}
+	return 0;
+}
+
 static int damon_sysfs_set_regions(struct damon_target *t,
 		struct damon_sysfs_regions *sysfs_regions,
 		unsigned long min_region_sz)
@@ -1936,6 +1970,9 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 		ctx->min_region_sz = max(
 				DAMON_MIN_REGION_SZ / sys_ctx->addr_unit, 1);
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
+	if (err)
+		return err;
+	err = damon_sysfs_set_probes(ctx, sys_ctx->attrs->probes);
 	if (err)
 		return err;
 	err = damon_sysfs_add_targets(ctx, sys_ctx->targets);
-- 
2.47.3

