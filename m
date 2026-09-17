Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEB42C982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 04:05:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FF6B6B008C; Thu, 17 Sep 2026 00:05:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B0A06B0096; Thu, 17 Sep 2026 00:05:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69E966B0095; Thu, 17 Sep 2026 00:05:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A4606B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:05:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 70893120206
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:05:48 +0000 (UTC)
X-FDA: 85221915576.22.7193D4A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id D5388140004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:05:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bzPeRIQd;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789617946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D/xjDMKN2pxjPkDC8M/3Bvu7Q4EfB+XzLNhUIOrk264=;
	b=VgYTFVYzLeYnQEB9ITyWpoU3eN9asV5tpMpVtveVq3kYwyIbV1UZz2xcaIGqiYec/1kKd3
	TbBzma6ScYmBX61MolxYVwEA7LcKckqy69PRC3YeFvePiFsoF5eGdPQRJ5gGyoMOAL4sMe
	R4nZc7yqwdYQYDLJPs6HMf026p5rmRE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789617946;
	b=QnkCsHsbDnCDIw4dgdz+zmljLrH/9ndN7g9sw/ChMptESRQ4Iy34x4QXUtkh2qztsQRCzu
	OOf2ZpEFUVoKIEEnpoac0Ua8RG1sOcfDn9CTki7SKQKbhP3qESuYzAb9f9CkxS5wwKHVmo
	rh7nbue9h/Mws7N/MWNSUjD0G7DTyn8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bzPeRIQd;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 24D7C407A0;
	Thu, 17 Sep 2026 04:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B1C1F00893;
	Thu, 17 Sep 2026 04:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789617946;
	bh=D/xjDMKN2pxjPkDC8M/3Bvu7Q4EfB+XzLNhUIOrk264=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bzPeRIQdTet6vIjgw0TKaEd2PPKGqbVO5HgR63j0IO7vOgaQXJa6IxhOxtbiLjDaE
	 6d6fQ9V3myXQoQoiJsHWu/5etl4Ba5hN+tpswOdW8ohcByTXqED0efj8dyhQ+oXMdy
	 xChf8X+iYGadx5n+n88RDJJtGzIJnba/SDBzO5ttVtJp3FgkBKmqM9i0xizLBHKbWE
	 TlmJbeq2qX5n4ejwrwbGCFaoj6i1owKeiJCj1abJrdIG9sz3tabgh1SSYDH7AIzORE
	 cVW1cvyReVlDYASbq3G76ZRtohlqtnqXuXPD84gcvC++F6uEm7nsrvdjIvVvLjtos1
	 4iN3tKer6CB+A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 02/10] mm/damon/core: use abs_diff() in damon_feed_loop_next_input()
Date: Wed, 16 Sep 2026 21:05:28 -0700
Message-ID: <20260917040537.107341-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260917040537.107341-1-sj@kernel.org>
References: <20260917040537.107341-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 4tyon9sbofnwf7fk97xz9hkbjnbq5ihg
X-Rspamd-Queue-Id: D5388140004
X-HE-Tag: 1789617946-348113
X-HE-Meta: U2FsdGVkX1/trppqRDlI2qtHIMbUUZXx8DExgt6PJbRI29MJGc6jwQo5OxKPnkmg88iDkGBTQ0adDrA8wOZSN8z/UhelRYNkYdjovvQHXdO3U6/9gf52yIXcggxZzTveN6ooODH6AszvCW5iEpZ/nPkEaUWyo4IdK5UTUdUjBn4bWPbx1EIyrdLF5xC6UPOkEnvibIjoD5RC8h7ZSfvx/nE33tB9mei3bjM3r7dSyzOcWvmUkPoBsrxRd22QB7oRXolfRwWUlfrGe9GeoDOgI4sA4r6FECGBNJCNH/6ze6To5S0sn0K3l0oh51vrHCQB+GiDax6mNV9MKN9ybSKp2T0uKf1lSOdnK6AnmbqfBUHd+G/90/7j/kvODGiCoITWnVtH5SPzMx/fvXYDArQBoAiNCWkEQB7viJVbEZ6Fs18w4PV/GAxc8rXsJyXMWnAY+bFQlvjcw1ZVwIZb4C8ajWUpKqc5HXBIEntDlhH0SH38Zii1Jjpux/1LlgUxEIySzuijVy58kCgFBBWJCbLJn2plLBJVB67NK7wVKyTZPwUHckm7u7IAdem+wx6ncAbTo2uYb0/KHN4/oCbOv1igeH9OHhdqCndrR+iZiaaf9O8e7GdDIgTKozkj2wAWw4R//jIDypfEUsS6yV5J5Zhcv6Vq3cVuSKgePzmGDBBR/kOqdUR5iT+l/LwM09snKNqrBKJmwhme0BqevdDRZ7Xn/X+QZ4yPHKDG210SrvUeJqdh8fZUdjW7WC67AX3JO66U8sRRrK0CNUO3JCtQeXUPQ2iWuvYsCLWc6f+5e5wEqbyZnIgEOJ1sdw2TtdEKvOMmIcxIfeQN1YnF7UupP8ntOAXNO/EqhYuxZWpmVRwl+//yCwrYilUh3FoLOnNq0+Jgsc2FsPkrY6gSHeCQl88L/GzTgnnwFkGYEcqgp9ThigSg0IYGwCK/s3kDwpK+OXhP+jRQkL22yGJnvxcOqiC
 kKPy4mk2
 RirY5/0o2AMsfgoim6w/UENybY2YkRsv6AHQt6EX0C1k6PIcPGiLbx6NJQyzbhDW9pLPBc53BiD0oLY1wyuX2DxjYP4mZhoniQ8lrIALHDACJmxlu0KTmyJ7nAnssmzuA5I1Rr9HX1khoSOHoB5XpvhlHrbAbARg9NOR3ut5G/uijN35RHr1MfAgY3VgUxDg3ZOOrqMhw+Vr2apCwTVDT1AidZjSiCXKZQWTWSYMhW1JbrU89PM+T845x/uctVQVyfHA3pV1sqz1sSdzPn78TYTIs2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_feed_loop_next_input() is open-coding absolute diff calculation
instead of the dedicated helper, abs_diff(), for no good reason.  Use
the dedicated helper.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 707fdc82de3a5..0299729e79ed9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2927,10 +2927,7 @@ static unsigned long damon_feed_loop_next_input(unsigned long last_input,
 	if (score >= goal * 2)
 		return min_input;
 
-	if (over_achieving)
-		score_goal_diff = score - goal;
-	else
-		score_goal_diff = goal - score;
+	score_goal_diff = abs_diff(score, goal);
 
 	if (last_input < ULONG_MAX / score_goal_diff)
 		compensation = last_input * score_goal_diff / goal;
-- 
2.47.3

