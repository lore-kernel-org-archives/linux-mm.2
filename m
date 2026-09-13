Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA99BC88E63
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 17:17:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B19F6B00A3; Sun, 13 Sep 2026 13:17:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 262756B00A4; Sun, 13 Sep 2026 13:17:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19EE76B00A5; Sun, 13 Sep 2026 13:17:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7BEC6B00A3
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 13:17:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A80DE4088D
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:17:17 +0000 (UTC)
X-FDA: 85209394914.29.B9704C4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1C47820003
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:17:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M4JVabPr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789319836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hAIupWOiZk1Nz5VeipyYWCDtbEHKa9N+XsP7giaox3I=;
	b=XNxUAMwdhBxidrHRHUMkIgwhKJeowTCp9eiz4ogC89IegKUfi6sdd2izr0xnwMEZGsvF8I
	bcqKn0LtOQ8/PwagjWrLcuhnbIaooxJ13g0YWm7VQzouzo5LLjDAP5DZYO1QSntK4nZINg
	1eAMY2lBg+5zquZzQzujwjv6gmeAVYw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789319836;
	b=G5TFAXuwvAJu1+xgmODGVLquKvvWID0K2jQTAQPTu/i3cL7Xc6qo7GmTR8IGA2rUWZ6i+y
	dmE8ppEVTz8SpDnicn5emSkEB+36y2ag84/UtaMeXS3Eq0GivFrFwuCbKfZIINx6fOzQ+0
	yf3ySeK66Nhuh9GqkpwMY8aRTuM3G7k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M4JVabPr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD72D60E96;
	Sun, 13 Sep 2026 17:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3108F1F00899;
	Sun, 13 Sep 2026 17:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789319835;
	bh=hAIupWOiZk1Nz5VeipyYWCDtbEHKa9N+XsP7giaox3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M4JVabPr5tlEOIeYIplnfYT0Jag0gmzQIJfF7+bhSEhJBzdlSiVJ5AIOObS7DEA2U
	 Yi+Od02z8zbTQYmRUu0zi3Bg8x4hvohK8dJbPx95zCKSiMVQFiXTipmQginA7IFj9U
	 mho/tBP8zswcf81rltqN8mN8kOKnPH3DAOHylzBiIHsmX5xo3MhvZx269rJ3SbHiYj
	 DaGUef5aQCdfamdWKcth/YDiYtgDx4jo6puUf417+W/6KfzZxDGNJe15HDuDRAagK4
	 mOb/iNTAeGek/ZYHTo9WlI+uS4n/mmpFV9VguPlO6DceJBx0exlxB6ByhImS3OvgoU
	 D/6IdS/x2OvMA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 2/8] mm/damon/sysfs-schemes: read sysfs_filter->sz_range only once
Date: Sun, 13 Sep 2026 10:16:59 -0700
Message-ID: <20260913171706.103052-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260913171706.103052-1-sj@kernel.org>
References: <20260913171706.103052-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1C47820003
X-Stat-Signature: fg4pech5m4jxjarnrtg41eistq5poznm
X-HE-Tag: 1789319835-198107
X-HE-Meta: U2FsdGVkX18GEefPCYcOWjftaZanyMpUYGSwPvrjNjXIQk1xakAZGHLZtXscud3L1GIS07lD5cPjqBLqHOZd6r5siW4jHS8ShVFGzKbAIDxXL9uAK4dvWPQwIzhy7OYmrovJgj6yRT9k1sthAuEiV+sr/7wpXh7AAAS96cRUwUE6MN3X4I7oUHdOtMe/lktmKhNPsqYNXtRXt/G3D7j9DGk/yEtkTl8XGpORPOTRtdmh8QFoiCe1n2uEElBDav6vSRhGqyQFpJLx9cSvqA/evQ3WLiMAIgMa8vImrkPVUks4TBkwKI89jxi1pzSbQffpjj3CMJ+fNGbEbVrtLDBSWNzVDNwHubd2q0usnO8cezXl96HthQkznXDYzXyPWbqAkcvIIEMIqDpWPS+eLoNzpcxxQI0WZkm9otG9ZK3qHJHcuk4YXORU1JgACtO2Xvlzk6UNrctp6NMKHNRmtpEbCEQxxSUv8r8srpAtpwjShEsJs+akayCGwcONi5IxLE5jiulxjl4i+uJH1ee9ZAZdJgiwcTWwadKhC7faoUGblfOa7Vtbewu3shqTafQdt8EHJG4et2SiRp8mvi7a9XaA84HNs23t931iwVQ/CjolJv8uwLi6EKviHtOmKZdjFd5y4XOb0gLSIr6lX+mb+56b3J7CIxiZVDapBCNdFEtGgtHdRWEWRjVQiUMkwmd+Rl/sGzssma+b1wDwwM71n3hdo6vmvl8M5+YQU2o0y2VNyB4ZbytZX2T96iQ9ekoeVOLhgzWciUKVV7GhLU8l1oGykxa5ZbJC5TUW6WilAMQdt32iD6FL81+3T7vOwzQYmYRejIfRNfmMu8pJkCjpka6iYi9lRyvHlc7VaTH27E4oIYBRdy4rJICvXRi1xNUNLcouEeSrPd3LNNwY99hmg5wHCdTwv3hDRdDuCxaxcy61aht3VcavmPaQueTYqhdWqDmd47JG3eNU6mOcWc3vGY0
 Gkl+7MlC
 JgGsjEUBnXMGVEMVvrOvT82SAUYDSQfNSnpqMxwVcm1qPOGttx8Y7bZ0/kadro721Lv2Wg/EhOBKQpognQIKbd2B79+Wq9asQVmzrfVf9j9wVVWOoVRTRl4odRLvQ32IXk3Wp8ssGmCVr6fcSvZPHNZcWgzioBczEGKeuqcDwRK+M64vPgjRf5JA6CMU7X+zSFHDr9S0ikHr/ywNJsXgupIJcZhlCah/fKmECou5DDRBlFWv458FiPwxp9+GEANF3Y7aEZOr278OEBgSkATnKjqedfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface reads the user-provided size range arguments for
hugepage_size type DAMOS filter twice.  Once for validation, and once
again for assignments to the variable that will be passed to the core
layer.  If the user updates the arguments in parallel, an invalid size
range could be passed to the core layer.  Avoid it by doing the
assignments first, and then validating the assigned variables before
passing those to the core layer.

User impact of the bug should be trivial.  From the core layer's
perspective, the invalid size range is not really invalid.  It just
works as having a weird size range.  No critical issues such as a crash
or a leak could happen.  And sane users ain't do such parallel arguments
update anyway.  If they do, such racy behavior is arguably somewhat
expected and deserved.  That said, there is no reason to keep such
races.

Fixes: ea1f204ba29a ("mm/damon/sysfs-schemes: add files for setting damos_filter->sz_range")
Cc: <stable@vger.kernel.org> # 6.15.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 3c1c1cb387fec..8c8ab82c8facc 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2840,13 +2840,12 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 		} else if (filter->type == DAMOS_FILTER_TYPE_TARGET) {
 			filter->target_idx = sysfs_filter->target_idx;
 		} else if (filter->type == DAMOS_FILTER_TYPE_HUGEPAGE_SIZE) {
-			if (sysfs_filter->range_min >
-					sysfs_filter->range_max) {
+			filter->sz_range.min = sysfs_filter->range_min;
+			filter->sz_range.max = sysfs_filter->range_max;
+			if (filter->range_min > filter->range_max) {
 				damos_destroy_filter(filter);
 				return -EINVAL;
 			}
-			filter->sz_range.min = sysfs_filter->range_min;
-			filter->sz_range.max = sysfs_filter->range_max;
 		} else if (filter->type == DAMOS_FILTER_TYPE_PROBE_HITS_WSUM) {
 			filter->range_min = sysfs_filter->range_min;
 			filter->range_max = sysfs_filter->range_max;
-- 
2.47.3

