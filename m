Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0E0EC4450B
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 03:10:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 978966B008C; Tue, 14 Jul 2026 23:10:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 928EA6B0093; Tue, 14 Jul 2026 23:10:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83F516B0095; Tue, 14 Jul 2026 23:10:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2FA0B6B008C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 23:10:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3B1141A05B3
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:10:15 +0000 (UTC)
X-FDA: 84989532390.15.455D74C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8C810180003
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:10:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EJVol9+h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784085013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q9KjTQrAluw9j+QP6j3O8xbCeroVnCVq06v65dUktLw=;
	b=iQ38xaCmzHk6iq34d9A+akv6b3/0QmcqoaVYgXnub3aUmt8tpyDhbV7wljBKjid7wy16HW
	Kt90RyhQhyH8ARCDlUjQzGd/8Ym4FIxDwq8YmoqwqHtFmPqBafUEkfWXMK2LqsI30t1Yep
	GUMozVzT8XIFMtayb2x9g5Qg+y4n5uY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EJVol9+h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784085013;
	b=QkCUuKuAI8m+MgfODUCg3qLasPbmPTykn+V/tlGNH/XEiD72B1WNHYwPBiPA2DB73mlpb8
	jG348rZdMVsj2Fd0S5B4SCd7OtkLAKX8ilEy5PVhh8Zu9QSijWXtMKYYgRmzeUV9d5tdPd
	dwb48xFb74npfPWqxGv29D7xSGfWEcY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BD3F41E89;
	Wed, 15 Jul 2026 03:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227411F00A3D;
	Wed, 15 Jul 2026 03:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784085012;
	bh=Q9KjTQrAluw9j+QP6j3O8xbCeroVnCVq06v65dUktLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EJVol9+hnUXr2MkTGjNeeTnr9zgtGiH5lhzdGvYd5zJCaySf6cSWxfS2J3u35p82W
	 aN7k6jW22+/k8MA0TjfYViaGj0UAvcbe6CKpmzA1dp9E3K6YhK2ZdiYbQ0X7OM0XuI
	 dl/ev0OzfVJ8SUjSrzFznTDRFzs+1NpfgomlPcRCKQO/u+Dh8IWCUwhA5ueQLIzG6L
	 5paLEU0Opf1bam6u3Q2eugM68ni7424Ag6gCP5C41ySgpo22WQZ3rGKa8y344o1L8Y
	 xvkVkSdvWNiU52kuxdqXM20DRFUDW71jWFix1mRQCU7heAgrJ2k910rqfYpb0g9ee5
	 cDRNSdDPvfA/Q==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1.1 1/6] mm/damon/core: avoid infinite kdamond_merge_regions() internal loop
Date: Tue, 14 Jul 2026 20:09:56 -0700
Message-ID: <20260715031002.108504-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260715031002.108504-1-sj@kernel.org>
References: <20260715031002.108504-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jg9oac7ibjaim181osr5duqabafhznqi
X-Rspamd-Queue-Id: 8C810180003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784085013-472736
X-HE-Meta: U2FsdGVkX1+SM2cGRZCHZnTdo7Ze+yIWbzFbFIRs9eYYRyEoSE/Hl/ocE0pjcbEvn8wUMVP+kzCcZNOZ4nnr1GsMXRl0UGyReQpuXz9kwcS74QYug94hNvOxGVT+JQ8Dp7Tn6c5OhvXS+r0S0q9a45SQkVzskQDDNpl8L730sOoUfllPxxN9PaLj/P+k0PGkCvzb9pWyAnluUBu4iktfLX+XohzDo2qr+01LeCJHstpuXz4xIW4n75nOU0ElrA108As2Ga7TCQfACC6d1oi2YVfoN/jT1N1JqNWumVUnTqpek3jj32FtQauNZQayk6IEqBizG3H3paAJT00f3zsd9uutwfev2Qd9zVck93YNbtKV9j2nurFBk8yHXD91Rq1SbF50yQMNQ4q0yeqiGBgiFKvuE2Aq8JbsqSapYKSBZFhwwfWJ2JB/6N9sO2TjskCcus6hmVtY0ApPIfNjWb4LGA3kpDU1UV9oXvgwQiOZf8W3fBKtkQHbD/ZW6VyhSw5LIy2qeepyDrYZYx9KgSTrlifRHbA1ZA2EMvBioLlmCybI168ltZmzL/7nWol5KgMm1zOKRRo1yW/Y7qsxa2hfy/nrigpotQYlr5Bx6mcK4ciSCstPLhwq15vy3s0Hud22HlZKnxndJ6Yx87dzBg9J/Gqt0O+1+paSggPDubwaWuZTjxC99XMfcfNIdZCSPQBLGqdNL5XAEhFUX70tNIpT35kElA54w+YqrnvP6hTJCMXA7vq3e2KZNdkdcvmtDWzhJm61u2TaN94+4Qf27MBl7CB7FssD52JXmYtOflqEZl8Qfh8LSYk1FY6WhacIEKC+lZ34Y3PmdXgoE5XvdqbhQtNXj3ZFEY2PQ2ugCcKBfPqQ2GXUaVt7peywO77dV/vDJX38u301RQih/2SQ8jz5yl7Wfu9rv1eS18JYSi0azb/6mDxLGdQoRuJaZ8qr+lrM1h1dp6GEiLDY1ZDIlxA
 MeA6JG9J
 fJ9n11WeHr88lYpsYcIyiwwzlpNGEoOi+rqPiQhU9sdrA6GfN5VkxF3k8RlZk7UCOGsFrDXpD3yBzMbZjvTWOPjtD4n8MVFKykp5EwcZ8PvEadDUxnJwmE0XivVrv7YUsfl1EiTL+kduoaWm153Qp4Fg3ytw3ltfd2NPupWVBT0AbAqKb81eTAcElAgNxTzeY012tLbx9XP6A33db2+LK9MnKMRB77uw3XtW39wUpDkLavjcLF2TLVLK+hXi8JyYj7sjn1fHgx62aHK/H4PC6wIWS8A==
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

