Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E163C982D6
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 14:22:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 089666B0096; Thu, 17 Sep 2026 10:22:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EABA36B009D; Thu, 17 Sep 2026 10:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4B126B0096; Thu, 17 Sep 2026 10:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B0F6B6B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:22:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 76691160396
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:22:21 +0000 (UTC)
X-FDA: 85223469282.20.CB6E19E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id E85C140012
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:22:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZUgJetET;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789654939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vxln5uIYrxZ1tEvbRFMph3C1mcNz38/PEev4DXMWOvI=;
	b=HD4nB7g7b4LOuoCjK5AuEg7vGoFrvmlso+WrSNSqjlVeJrNsWG7nD6tH+SktpaklkN9tWC
	aRJH9dkJ5awO2vGwXJCskALHevJjAFgGTn1Pxh3WTAVelDhy3Ad5SHBaXTNzGEHrKsArwe
	mu7pKGtYRmQFBzRoDM8RQQQXIZze5A0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZUgJetET;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789654939;
	b=WDS9/3V1HyHMipJDt5D/CdsN9ZQKulavutuqrnXJOzuhJQIjMHqx0naEW4lWCX8xI1X9FB
	keECuYymNma1rn9cOWQCWlhkCdbqpMrx1FUUY98PMFGyjDoU+k3ZLSOIF5x8JPoVJFEiuN
	4myQda2vLz5bgxAfTZj3jBcAO03LzsA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8AA3E60216;
	Thu, 17 Sep 2026 14:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC631F00899;
	Thu, 17 Sep 2026 14:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789654939;
	bh=vxln5uIYrxZ1tEvbRFMph3C1mcNz38/PEev4DXMWOvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZUgJetETiqQ9ixDcx09zjkVJR5sv9CPI1MJByv+mOw/peXroSGR/wPBdPWuj0ZuCa
	 nm5n7ZclnKrkoI19TmdxYZwTP82kcp4Du8CvA7w+89hewHb7qlL8+Nt24lL6Bnbnh3
	 phtJB9QedHCryfeHu0gb6kllUio3zj8Fga/iZnZYFr3Q80Thru/81Z+YPO4pZQB965
	 7PNtOwMZUEnuPzSjhPtfx4a6lHpwRI+mlPuyi6hX79cRrLSLA3PgZaX73SkYGfWWTS
	 fG6+6lQqKthCa9wMuJUPr3lMF+4Svxsq36CFawLgBZ1BDmr9fI4wCu8A7RALuq1BzW
	 lCvRURuVrqKsw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 02/10] mm/damon/core: use abs_diff() in damon_feed_loop_next_input()
Date: Thu, 17 Sep 2026 07:22:00 -0700
Message-ID: <20260917142210.90829-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260917142210.90829-1-sj@kernel.org>
References: <20260917142210.90829-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E85C140012
X-Stat-Signature: 63s16h78bg8jaaed6jgzg9go7drqfa1e
X-Rspam-User: 
X-HE-Tag: 1789654939-330484
X-HE-Meta: U2FsdGVkX18U9J8wtow2TtyZAJVkObLWcPiK4iNoUhhJvqQJmWUiU5Vo+htAFzmAgR7621E0hKT8LvZTo7hYAnJnmziwIFw9CgXbBmLzjUJHMm7GFAWJKXTUDqB7jNdv29DHoiyB5+XAUHymAWQMlbNYMKdxodBI/3p9IiYaJ8z7We5faOapNK4H+Nvu1H6jyFG44dMximV4DsdScczd8rsTHFTB1UwdzBFqJUrWfj9qQYUPYBcJ8fLDrYlScPZfl6fB2Q+PscGU6MNQIYYe7gNeBxfAqzs68Ek2Zs/GxUC5ahdQu/i3FumGm86Q/IuMBbkqTKoKT6+msT4lxV18k8MVDkeaPwr0LJvRuLhfbSjY1o00xBO/kZNKVZMZtcw+BYJtnTo9hTj96gI/q1x4mwE0A/lKhh2MRTmUErRfqo1kPqKFEmAeJ+s6EO9IqcnToKrSz+kGkNDRKn54rBvU3JwrydJMmbR9WyM9YzJ7j53XfBteRn5/BmmroHjqWQK8A00/9jLFzFZ89x0WUUaeid7b79oIfDCSg9mKUckVGtFaNUp0YonSL3KMc8E5yG9/EI35TYffs9L1leoj4Xo5ChNRyzNUpufyR2IiwDfhxUGfhOVlIKUcK8CBJpoLdNqNvguzT12SUABuUZgJKp9yWZ83jowahJetEXl7DQ/FLNtihXFyy/8HZpvHOdjlSD+XKO9JU664tph+/dTFDOCqGK0wyF5OyozaW8EWoHAVv8Cx7MsLZeNpQo0/JNm5FuDy34QRFhrIJYD/ApXMeag8zNR3jEfnFmmtSivYKi+1z5wQ6dmaulZi+6OaT0xTgWVrRacknDTxGUnp3q3TmfjvDMnG3j+UZGpDP4TqrCZ4D7OsoaipQluZAENjN+A+ud/97pSwnZiTVMUmEoQtRAKVGav7dn5A8TMlWu+2Jp5lwmIscn4t+ud+1YwooABF7i6tY2qKGAGVzE22c6jJ0mT
 8fcAg3PU
 G3pscs/R4oU3umy0nGFR9DXqtkqOyUkcAXnP7lBEo4h9ZR0JEnUZDOYj4Ft8qfcae3gWRk89k5wXbhmjk+uo8hJaukgJJPBOCTSdbirtFLICRPgvXC/Nef7aQHSxxQJpxOY1/oWCSTIej9q2xLWIxzbaS+I3SrQailniAJGyqRZrJbWcr4eKtnDVxVU4vGR53lkjLvdE6B1+pgP3Njr3x7QHJShxQ0FHZbAP+IhJXTdenNttJl1X64x9rJZOq9UGsu7a7lKKsuEJErrrF8pkrdcbA8A==
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
index 444c97c184027..de46072dc1a2f 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2926,10 +2926,7 @@ static unsigned long damon_feed_loop_next_input(unsigned long last_input,
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

