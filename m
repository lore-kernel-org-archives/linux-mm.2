Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13E2DC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:06:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFE846B00A2; Thu,  9 Jul 2026 10:06:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B62166B00A4; Thu,  9 Jul 2026 10:06:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DADC6B00A3; Thu,  9 Jul 2026 10:06:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 656CE6B00A2
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:06:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8E975120140
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:10 +0000 (UTC)
X-FDA: 84969412500.24.41B88E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id E7ED2A0003
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vmg0eQ78;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783605968;
	b=OpRCiE33VIiB3aIixXksTU6piXbLSpbQlthAvwoaHPPS9VhEBtOy6HK8E0MiMJqgWBuRtN
	FVb1SNd208NgqBhd973FdGZATzrdl6FEcqnWoXO6+GmDQ/NwKOTXoviFo3R1IM1cB3kG+g
	TpJYbfNUwloqukbpexEOBahGMuQCtgs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vmg0eQ78;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783605968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uIok4qBZQSpg60ailXO0bOCkjI7Xk9a+1vq0pYdirF4=;
	b=n/tzzpnRrFY6TJFExdXMz6bmy+gf991/iDULcC5fGbPqmcHkvcvh3d33Yn9+3w4eA1vLgv
	gTiS5MyfKSfOiglNy+pKuwb6gfQZ7/rkp3d/yfnrM/N7YqFmq9V0taomjK502ps5XAo29w
	qhoDJ/O9jUKXh+r8XKed43NZMbSQE9Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B96C061386;
	Thu,  9 Jul 2026 14:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFD71F00A3E;
	Thu,  9 Jul 2026 14:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783605968;
	bh=uIok4qBZQSpg60ailXO0bOCkjI7Xk9a+1vq0pYdirF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vmg0eQ784RNQy4F1LMVusNPLwtOeDD5MkHC4mmvzhsAgcOyLihdCuXxPmt2E0ckLa
	 0ndiwRvYu9X9JlRCsaXND48MjjOPKb+STLe1BEzhGtbHlyUF2H5f5t40J/fH0GHGsy
	 pcgudqt4GPeiweZZtbJaW0HCt5mhOs1aiG8StOdwI4BoMywMlHZrwvcBRDN2MjVGHr
	 nVzej4uJCZa3FOXCb7aHwDhTkXNbf4kQ4EguxX1zXZXpWk/SwqLNS1qbSMpVQCou93
	 OyE0QlyP8ybncx1kQVFep7YDYCiAltT2ZkbI16U1dv1vEaGdgcypwMv9Eo6QxixZhe
	 HJhTgPhKLJLwA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 14/19] mm/damon/core: get merge threshold from probe hits when weights are set
Date: Thu,  9 Jul 2026 07:05:52 -0700
Message-ID: <20260709140600.90950-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260709140600.90950-1-sj@kernel.org>
References: <20260709140600.90950-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E7ED2A0003
X-Rspam-User: 
X-Stat-Signature: p6zioy1bcruw9z9raxe1e4h9qry1tfse
X-Rspamd-Server: rspam03
X-HE-Tag: 1783605968-35312
X-HE-Meta: U2FsdGVkX1/a1zQ/FB2QeXYqTyU8PqFXigRuWPKrChmLoD3DnvRJ3ch8tQ1G4dhehXFzdYW8gPOa64L93fbKTshy+S8+pMnm8hENj6VlN6ql/w4PokTUMz/RNGPlJyScI2DHxbymOGoA3k+YD5nnpCKidj3yg+Q7c1LuwcpZN1nbb03UGeC0Iervd0DWIA2eb4NYJyi8gAWTQbV8E4JiITxvVn3a8o4iRZaJiYgwp4xTeDf+sYpS1sqn3KYzHhXuDqq5Tl42Muz41jW4B/uRS+LV3qV7ej5YZyZ4Qe6fkzKI6iaZYcSXAif8Otd2zx4c4IoGWcU6eKgWmX1yMy5FJNoHiNSs9EHHbD3R1vMzgWf3p8c/4WQsQYUT/8ltASc/aZpd4VleKPQJYo2G01fRo83uB/W3pk/xpn24a2p5CpWFyADknXuePOz78iquDXDufN3YaLp5w0Xd6cRNIzYHMN7uBfESW73FEzkH3el5ySYtZiqqRmYyrtpaunT2JWEriwj6C7MuoLzZJOujeFDFT9eIkbWAV9am4QUF4ODvolWoZHESJYC7VuAT5k4t+fBSWFsPTWPhIahgF8L+GKrNOxsJ9iJKQDYA9Ra93XTTUFduiv2zHykfkHylaVnCY8GBqhoLDC2Na4wsKICh8vCffheBZQhI7XE59D0Hadc7ErW1Bbj6ozGWUrFzL8f/0qThnE+irdHQZvwKVCxHB4uA8Gfa9vxAdWbj5Wd1lO9C20J3EYi/VUEvg8KLvPeZNFgT6POiF2ahtH97TGQ91sc6rxrF9qhgtPM6vqpP9WLStiezYVvyjD4JlvuUNPt7frNEFi+sEj4vBphnB0EofG/9gTH09z0kDwj/jWqILsbHZdgnVYs4npFnBOKVQ/0U+2MsTCo6v7J7VQHgGgJskDmka2Ob5i/pkNTWonfH66MoxOY7NWJ93rnjC/A2OHBGOmonCftJZTzsM6g4Ljcgqkm
 pCGL8wZ4
 nLNezuuKXRxXWDifAlPGy9o7L+McVqQz0VLmqeX/QURWVjNSJT7DhkGLVndPEsr/wfO6mQLJbLtkmtOVWiveEnhucD65emdyF4OL2Vuqm7x/+Vlxnt1gf63ypr/9/nxz+jRKARS/OJp0AUD9nfB51SjWS03j2XE7E/y/sKjCRLvedm7HJ66IybiDsGhuRzDwUR0DDy8ydvrwRPTXL9DehDmL8+KrY2TItw9QxgZyDrBPlsDE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When probe weights are set, DAMON merges regions based on their probe
hits weighted sum.  But the merge threshold is calculated based on the
access frequency.  Update it to retrieve the maximum probe hits weighted
sum in the snapshot from apply_probes() ops callback, and generate the
threshold based on it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 8837b2129baa6..12c66edecd783 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3763,7 +3763,8 @@ static int kdamond_fn(void *data)
 		unsigned long next_ops_update_sis = ctx->next_ops_update_sis;
 		unsigned long sample_interval = ctx->attrs.sample_interval;
 		bool access_check_disabled = damon_has_probe_weights(ctx);
-		unsigned int max_merge_score = 0;
+		unsigned int max_merge_score = 0, max_wsum;
+		bool get_max_wsum;
 
 		if (kdamond_wait_activation(ctx))
 			break;
@@ -3776,9 +3777,18 @@ static int kdamond_fn(void *data)
 
 		if (!access_check_disabled && ctx->ops.check_accesses)
 			max_merge_score = ctx->ops.check_accesses(ctx);
-		if (ctx->ops.apply_probes)
-			ctx->ops.apply_probes(ctx, access_check_disabled,
-					false);
+		if (ctx->ops.apply_probes) {
+			if (time_after_eq(ctx->passed_sample_intervals,
+						next_aggregation_sis) &&
+					access_check_disabled)
+				get_max_wsum = true;
+			else
+				get_max_wsum = false;
+			max_wsum = ctx->ops.apply_probes(ctx,
+					access_check_disabled, get_max_wsum);
+			if (get_max_wsum)
+				max_merge_score = max_wsum;
+		}
 
 		if (time_after_eq(ctx->passed_sample_intervals,
 					next_aggregation_sis)) {
-- 
2.47.3

