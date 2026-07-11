Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7F81C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 18:04:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66EF86B0088; Sat, 11 Jul 2026 14:04:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6466D6B008A; Sat, 11 Jul 2026 14:04:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55BD26B008C; Sat, 11 Jul 2026 14:04:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31C126B008A
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 14:04:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B3EC61A07B2
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 18:04:22 +0000 (UTC)
X-FDA: 84977270364.15.C28FB8F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 05700100004
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 18:04:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZM7JMyvK;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783793061;
	b=TqiPZHV9Nl+K3qksMrFL25oRRrPzfeW3Fwuy+U0z6I0ObLPnZqBLs9Re+lyiPICDQJS4zr
	mezLzqXZgE4mVDldsjq/X1eXDK0cIb9SD+HbwLZVBqfby7ehBAp8DayRWW3PiiNtczGZYZ
	KbDX31I9aLRaaqu+d34ONaK1cvWZFsg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZM7JMyvK;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783793061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q9KjTQrAluw9j+QP6j3O8xbCeroVnCVq06v65dUktLw=;
	b=r7OevblAM72G+mhN2z+uNaKfIK0W0dpgB7b9CI86F0GLxfMY2VDz2Kwzb4Y9ncOnUD9ioS
	oredayhB1KS0fVSV6QZRnSZ14P8fFfi7PpHHNnvR9oFkC28qcPCTbMziX0DNW6kAwKEuqM
	ol6ScdiM5uvTRcIHEftHe/YqhoItdf8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2AAA543749;
	Sat, 11 Jul 2026 18:04:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D021F000E9;
	Sat, 11 Jul 2026 18:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783793060;
	bh=Q9KjTQrAluw9j+QP6j3O8xbCeroVnCVq06v65dUktLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZM7JMyvKDar39MxAxv9gEXqrrpdcMhCd0EaxaHFtTiOxwPWfh9E8aGiJ/Zw1mE65n
	 emJa9iHLBdDxaY3ZQwrs26X/ipMp+fiCY8QS9w56DtrrZVpFwjofAUN+FpytNFDXnp
	 aGklVVK7h5VtCqPemCJ5Jxgp1ygBuhPifJhNsvkeERtbspZeclMmU5W4X+bdLREpIm
	 KBAsjy6by68i1W6n5VtA1+8Y3eYoT8wmov3iLMtQX0pxutZo5+nTB8RAclaEsHZpK0
	 smYc+dxIOBy7zZOSiUNAwQLPQ+QmlH6kliZeYGU7XpMSvAs3Fw/AloPX8VwwjInK9a
	 BVFTK/0Rdbbsg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"# 6 . 10 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/5] mm/damon/core: avoid infinite kdamond_merge_regions() internal loop
Date: Sat, 11 Jul 2026 11:04:04 -0700
Message-ID: <20260711180409.82093-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260711180409.82093-1-sj@kernel.org>
References: <20260711180409.82093-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 05700100004
X-Stat-Signature: aqw5g98jr1gjugrx3yhspj48j1chr3ba
X-HE-Tag: 1783793060-524765
X-HE-Meta: U2FsdGVkX19y3JcUGh6TXpnX9+qCU5Rr5ocfGHpqGSK1oMj2CZ/CwzxR6g0sY236GkM4EWrGZewg3K94FiPT0ZfJ8YgVALfqE1fP8Y8AQT3vLTVW85yCUy1RmkJfLfqY7Vd+nIviLwYCtbQ/mERgzw2pgGPe/BBquO8j1vzZXFhEfxJaaZH7iKfJ52AyZAHEgfFA0BmvQxvKcUgkId43vkDWIjl0Q0AzNkIJCl2H3/lPmGKCLMXfCjCzHDqiEBNNlEr74nSnrfD0IPrc5qsye68zwfcErQc3Y3pLreC8tJBv74F0VohPW2L+aSj9WpSMbEVQMPnLvnFGdD8PkCBZqpRLu+yvv+RtVaBPXe6H+XSM08jRKVM0R9vZ4LbTsdinXzpW004IOM+YkWxhcTv33fc8lutND2kryktxLixsFLtZS75fsjr6jkWHZaBBmZVij1pSGMoGCoFpe2w6AsJ/hSojf8zuuLYTHJwL5xc3SU3EqOTNzIGhPeLKTSASAzAZtTgbQbkRS/OAcwiGHiXzKjZnyA0jt2hAou1JYEqqeA+378PUfTVsu2Wz7YHuRlH/PxaSqiEDhWoNse7UGL77colL1GvjauKT65hIIRKHfaailMVKhqs8L3U8+IXQat1AWbaLqTMZ81N72hvWfScaTfCh1wb6wNngu/chLhsbT/8gc09VwFl4Eca9g9ghhvICBJyHEnVcy8Tf0x75tKtBvA+aJdg71r2+ALFBfSKdmBFdHCqwmF4AZTbyu55DWJRgABzE0LuEewIXDo/7T38DpgR1HxTO5YnK5mCOUwAaX06mZlE8lk+7lfTccGy+mxo8pHQZmJangTY1XvfT8hyFUs1PXK8pU+lA7bK1UcxZ6mX/Hl4WUUiSVSghPgWUcNmzc5hqPBWvED30s3Z2x10NY1jkequSJABZlEWR0Rx8R4z7lEJ/fFdAPdY/Acfde7FlKMqH/MWY+JFsVhz12cX
 ryYkLIAP
 ykaeVvyZWy4ZAzaxoS29RxCEnsKu0L1DCu9eH/bZyEqMJke4mLVmvzxQ26IxJfzzhrYoAbif3vgq8/DlFGfAkHnPB1cLjjK3fwXM+62KQWEE10vB4YtodG2UXKErievQ3tzExxVIKA/piKIdO2jyuU6k1PAcNWVq9ZluSGYUOQOrzlieY+TwcbRHGJGBoEJwV6OnywYxRW/QzQZPHiHIshb/qavj0mzumX58w7Xoh/VMHymsIJm7wJP87YOhCoQy9s+sXKQIqDH7U7aYtQ3KmrRiTcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Due to online parameter update like events, the number of DAMON regions
could be higher than the user-set upper limit.  kdamond_merge_regions()
repeats merge regions until the number meets the limit, while doubling
the merge threshold up to the theoretical maximum threshold.  It is
tried only up to the theoretical maximum threshold because even the
aggressive merging can fail from reducing the number of regions under
the user-defined upper limit.  For example, there could be many
user-defined non-contiguous regions that cannot be merged.

The threshold based loop break condition is evaluated by comparing the
threshold for the next merging try against the theoretical maximum
threshold.  If max_thres is larger than UINT_MAX / 2, doubling the
threshold could make it overflow, and bypass the loop break condition.
In the case, if the number of regions cannot be reduced under the upper
limit like explained above, the loop will run infinitely.

Prevent the case by doing the break condition check before doubling the
threshold.  Also, prevent the threshold exceeding the maximum threshold,
as it could overflow and apply the wrong merge threshold.

This issue is unlikely to occur in real world, since having the
max_thres higher than UINT_MAX / 2 require unrealistically large
aggregation intervals compared to the sampling interval.  Also, it
requires an unrealistically large number of uncontiguous regions setup.
Nonetheless, the consequence is bad and the fix is simple.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260709145425.96247-1-sj@kernel.org

Fixes: 310d6c15e910 ("mm/damon/core: merge regions aggressively when max_nr_regions is unmet")
Cc: <stable@vger.kernel.org> # 6.10.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 6c4215cc809ec..603b102ff80f9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3372,7 +3372,7 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
 
 	max_thres = c->attrs.aggr_interval /
 		(c->attrs.sample_interval ?  c->attrs.sample_interval : 1);
-	do {
+	while (true) {
 		nr_regions = 0;
 		damon_for_each_target(t, c) {
 			damon_merge_regions_of(t, threshold, sz_limit, c,
@@ -3380,9 +3380,14 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
 			nr_regions += damon_nr_regions(t);
 		}
 		count_age = false;
-		threshold = max(1, threshold * 2);
-	} while (nr_regions > c->attrs.max_nr_regions &&
-			threshold / 2 < max_thres);
+		if (nr_regions <= c->attrs.max_nr_regions ||
+				max_thres <= threshold)
+			break;
+		if (threshold < max_thres / 2)
+			threshold = max(1, threshold * 2);
+		else
+			threshold = max_thres;
+	}
 }
 
 #ifdef CONFIG_DAMON_DEBUG_SANITY
-- 
2.47.3

