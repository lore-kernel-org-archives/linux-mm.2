Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4215CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:11:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 725296B008A; Mon, 22 Jun 2026 10:10:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FCBB6B008C; Mon, 22 Jun 2026 10:10:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6128D6B0092; Mon, 22 Jun 2026 10:10:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 295146B008A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:10:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9CB13A014B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:10:45 +0000 (UTC)
X-FDA: 84907734450.06.60B3677
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id E76AB180004
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:10:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K0TLhcOz;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782137444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SJM/0XTBV4bkcxgnv4dRGM4IPEuvuQll1XDjuKhJgOk=;
	b=ugfZ6zLSufo++3MVRpRXGPyoDgX+59w65zHyOZf/yGt33lrwCj5cbJzW5YV73+4Q6rpURA
	DW4tZZSLe4esieyNJzD4LiXXWij0TwtuJpH31tlRir+PPDbfI09qn7M6DBRxnfRumiFmwd
	5L7f0g2QFRb4K3PFcQXwtxbpcECL3hU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K0TLhcOz;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782137444;
	b=EPUXpLSuQaeac3tJtKPFOAjIprZzIErFoNcuZIT3f9A6QeqWE58kDwE8MfYFafRC5OyqDf
	9LFLUVkemER6DF75lSfpeWNJ77TwItCqIZr7Ddk8Fs684JULasvRPtAWxquM6hzs7/BCtQ
	JwHT2iSnRCDxdJ5vwXgfXpxKd9jiAjU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 33FE342CE9;
	Mon, 22 Jun 2026 14:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC161F00A3F;
	Mon, 22 Jun 2026 14:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782137443;
	bh=SJM/0XTBV4bkcxgnv4dRGM4IPEuvuQll1XDjuKhJgOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K0TLhcOz0QO6auoiihEfednChAH/dux6kSknrgWaApka8AHQo/V47SKGdJX74O/5r
	 Sm7Mv6gRnBzZNO9VsQCcCA4tx9Aqrdv+C6qYbpfoQUBn7BoY468r+nLCdbCT3lz0B7
	 GAUcTMMN36GRH4DdjuUt7sgMsTi8S/sFkAwLDO3mOH+W5mZW7Looh6rPPFhQnGL8Pz
	 /gdlmRALZsu5ssDCtcoFoEo1Hd3pgWBaRG9JhJSndAjIJvEXy/QLTOy52EHbZt/MD+
	 yseAOINCiRNPyITvIlHjOrakbtPosUlZufzVa94DdAv2O20sQIa+Sy+9EzuboJDJLn
	 M4w+/W3uTidlA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 3 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 2/2] mm/damon/ops-common: prevent >DAMON_MAX_SUBSCORE freq_subscore
Date: Mon, 22 Jun 2026 07:10:25 -0700
Message-ID: <20260622141027.29145-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260622141027.29145-1-sj@kernel.org>
References: <20260622141027.29145-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E76AB180004
X-Rspam-User: 
X-Stat-Signature: k3ncyq98ot3i959ss7eas1fehbgm3pa8
X-HE-Tag: 1782137443-387363
X-HE-Meta: U2FsdGVkX18Gd0X3iYo/xLYtfTjJZvzkVMr9U8m1sJOIyz1xzw1UyN/sRDCSkJRTQ7iMAzM9yACEGN3uAi+laprrOnu4yI8nbxggAsRoYzU+/dAYeRMYPcFAeUF8KMvmc26FxooIXvZdgLtOluCeJHs3NA73gWN4MbKVLCs8V8GhBiv4qB8sIKwROf5zyYjxXmXw5xZJTD40+tAxkWY5RcoufZ4BhY4ByFgBcMkr7N9pGqH2OtBprb7asc8EJR7WLPBgzAP96G+bRBSwgMkpMFPTu5Y2BDpw+NgAwxKGxqbk2tgQRLsQogH8+1Gaf1QByFqcRRh8WENyvx/yJiiI5ZYwukxm69jGM5FAKOK3xK6O2mXrS8iXy+WeAGN4uWzEbuxKBLLx9D8Mhoe6uZtPraANJ6dZDSHRstfZzKivtGlRpmEENCEk+RIYk4DshqFcAiFB6SD8RciIpgknWWKlARAGpIaNTkwKRVTfm8ssJt0Q1ODtcZmGs78KaKaiXGR5TcYxJDmLFyA4ZF9ZkNwRcbiPgh/VyhlquiyJq9L2JCxIe9BrKYqnonrKYi6v9mfsI+2F0Li2my0GfmZ9sQAytUB1buOnRS2E5ZxJ/xr0J7OGJwEMFmgnYK3D6FZw8zp74FR+YiWPq4oFW/0BvNKfHDxus7+YNI+9kriBdwQoNrVbpE3CO0w2/C0Tfly9adBxnhmDsgUp9l6Lfhs9YU8ZAu5jQ380ioRdoMAzaZuZp/LBywiH//va4n+PW3piHGfAbmXQGqZjuvfcD4XeSI1LNUxwK5gdIWStd3tJIC0LJsirwODHi0+kf7XcMY5iC4yvjVCEA6tUfy2j2qaHZMsVCdKTdUycvOFOS3rbZsc8NavlBx2dw+acTZeAx1ZQpixufU691e0iNg7f2Z0j6EGeyG9z2vxwS2vrI5fGyUYmykPhRYeDhB+tFg8f8w1dw23rzGTFse7NLfNkoeSPlyv
 9/NKMPjH
 +vBbFMZsLLPffHqdZFtwOg7MhDAHoQeigg5exOCE2iiWiky4E9izqIYcPE5hx0LDkUvfxAzmvLe9NHqhuM56ajUeCME9VYp1RiGsY0BI3hd8zhZb+0bpwvmDgCMR5WXyXa1gRXpcDpRdepmTv4VVRCtXsFOz8US2qQ7VWJuocA8yCQ0QbCFSy6IjIYuZ4iLEHAJwBBAXQuxq4lV0vMbOhj5ciheX7sCbakH9mqqR2HUONpeSr0yjZegf0205vTrAh4CM78VUZac/pnUi2v0KIIBS7oA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a zero sampling interval and a zero aggregation interval are
online-committed, damon_max_nr_accesses() will return 1 right after the
update.  damon_update_monitoring_results() skips updating nr_accesses of
regions for zero intervals, though.  As a result, some regions could
have nr_acceses values that are larger than damon_max_nr_accesses() for
the remaining aggregation window.  Note that the remaining aggregation
window will be quite short.  It is just the remaining execution of the
kdamond_fn() main loop body, since the aggregation interval is zero.

If damon_hot_score() is called during the remaining aggregation window,
the function can calculate freq_subscore that is larger than
DAMON_MAX_SUBSCORE.  Depending on the score weights and age/size scores,
damon_hot_score() can now return a score that is higher than
DAMOS_MAX_SCORE.

damos_adjust_quota(), which is an indirect caller of damon_hot_score()
uses the score as an index to regions_score_histogram array.  The
array's size is set to only DAMOS_MAX_SCORE + 1.  As a result, an
out-of-bound array access can happen.

The issue is expected to happen only rarely in the real world.  After
all, zero aggregation interval is not supposed to be common.  Also, the
online commit of zero intervals should be made on exactly when the DAMOS
scheme will be triggered.  I was unable to trigger this on my own.
Nonetheless, it is possible in theory and the consequence is bad.

Fix the problem by applying an upper bound of the freq_subscore.  This
is a short term fix.  In the long term,
damon_update_monitoring_results() should be modified to update all
monitoring results even in case of zero aggregation interval.  Add that
as a TODO.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260621175849.91990-1-sj@kernel.org

Fixes: 2f5bef5a590b ("mm/damon/core: update monitoring results for new monitoring attributes")
Cc: <stable@vger.kernel.org> # 6.3.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/ops-common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 5c93ef2bb8a97..8d516851a69e4 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -115,6 +115,9 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 
 	freq_subscore = r->nr_accesses * DAMON_MAX_SUBSCORE /
 		damon_max_nr_accesses(&c->attrs);
+	/* TODO: update monitoring results always to avoid this. */
+	if (freq_subscore > DAMON_MAX_SUBSCORE)
+		freq_subscore = DAMON_MAX_SUBSCORE;
 
 	age_in_sec = (unsigned long)r->age * c->attrs.aggr_interval / 1000000;
 	if (age_in_sec)
-- 
2.47.3

