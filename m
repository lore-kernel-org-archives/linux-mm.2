Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2654C55838
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FB446B0093; Mon,  3 Aug 2026 09:46:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55C606B009F; Mon,  3 Aug 2026 09:46:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 361896B0093; Mon,  3 Aug 2026 09:46:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E59976B0095
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:46:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6B7811A0729
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:46:57 +0000 (UTC)
X-FDA: 85060084074.27.80CC524
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id D403640008
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:46:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UtLiJMjP;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785764815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KZNY1MD6P0OCjtAb6cuHefbevIrlOVJqJGEJAaJiWKI=;
	b=N8MK2G13XKnu5CuOEZptQlqZkOse5eOfSGYu5ODMtC0f+M8cotDky5/R/o+3u+zFHffdOd
	d8fWjh77FW38PPGXp5KE8HIuXSC3O+5ri0166JU1lQhF9baw76p3vM8jyMY19KNVdTXYh/
	kxfo0z2opn7Y9O+63cbvTJghISNWj2s=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UtLiJMjP;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785764815;
	b=tdjpuXtFX+aWrXrAhUtWdb4ZRIqfSHPbopu2Mx8yfa+kIY6Xz3EFemaT8YTt7Fofr42k8T
	jDSF9gRpqutrgFpCDSdtrZ3LHsq1vzf8xdxsSGAmLrlfTNZlToMRPdb3WwG/sXv5nSNc/A
	x8N24sKgVlPagw9gMJMJLjS9O0vY64g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 704CA60AA3;
	Mon,  3 Aug 2026 13:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F8F1F00A3D;
	Mon,  3 Aug 2026 13:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785764815;
	bh=KZNY1MD6P0OCjtAb6cuHefbevIrlOVJqJGEJAaJiWKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UtLiJMjPFYh82D0ZcUpbJO8m7vG45NurdccoSqF8tLAeGDMrpFVqwLgvKfMo5mPBM
	 1A/vIMEgVaklPo/HQsr7cr+4GJaep+hkLzWJTkQHkowTG9svjcLIxmy8YdUvriAuiV
	 +JbFbq6JwEH6aQexXArZ/1tIKmFGfBSb7dCJJjeonQiVRqE4lFzU/8Sz+HhYKzvqE+
	 ITAYn/0sITU47MIQ7FZT39wF0zCOHN1dwA/tLLKIF0VqesGIaAUrnwLdqE0E+j8t+V
	 DxRYUEq7FOHpz3sRS79YPczyP7HXPXEAVuGchOHnyKArSj5nfuZeKb8tCOr4uMfTzu
	 QnaR8LQeuTS1w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Liew Rui Yan <aethernet65535@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/2] mm/damon/lru_sort: skip damon_call() if ctx has not started
Date: Mon,  3 Aug 2026 06:46:45 -0700
Message-ID: <20260803134646.16640-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260803134646.16640-1-sj@kernel.org>
References: <20260803134646.16640-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D403640008
X-Rspam-User: 
X-Stat-Signature: ruxzpib3rpph7zruo9386njjtwwht7wa
X-Rspamd-Server: rspam04
X-HE-Tag: 1785764815-543594
X-HE-Meta: U2FsdGVkX19G6t6hON7ZRRaiVQfUg3wrnYlX833jB1QGiBCfrpBV7yUpUa77/Q8tlk8gMr1IOuHxzlWjiZ3GjzoyXO7RJG1wzvhosyEHGsUD7O4TU13O2uAOD5+XnyYrgTbVpW/95trYZjAEzJuIuyYf9u2QtiY7gQm9WGUWbBm0Kja25npJMda+tZbatkKBMf0QC0ywDh5ZvM7sn++xi/mAmJY7nSCcCxj4WA3Na71HniBn9KP9FS9sFHZZ/+NnPegl+1TSYh4jdAk8k5ve14TuhFY5AkyBtrzxU/u4tw/Iy8/HOLUI74q2CIbdf/JFZOAbcQTc8DrUCm7qvrWk2/KE6KAEvDERhyFYPlC0ARwJCjmfBnuQd5GPUOIVrLhYtOAK3XVTx0EQEz2G2Bw9DYdMCKZxNanSpOn0eC+DtbLKPxLcaWna9Ip2CdcyBui4ZoSRLmBSVenCa4R1dMPiIwmVYD/V/R6rRcYlQqK7PAkJhbXrRrGAtlEIL54uZcHFRYDALUBIAp7sVuxbvI6fFcfZJwJ+pQd/Rb3ZhabEmWbw8m3OZhKIzzLVotRFu/vrqLIZkx71E8pbT85+ZBejxpySRjMi4gJ4VsDZQpeDIRDrHuS37Rdmw1yO+uUlqyaAOTgoqgaBiJcl4tvu70oXdZBYihx65sXMyS2pVGS26WPKOEu0dgMBOg7/l5rFlWcKQbb4Bg9Es/qI6IVv32AhpuXT/4a9PKEx4BtZ28zk3mAdMZakZyF/R+S9r+/Jqw2+mcSShKk2TCCt1UHGytk6O9IjbeMzoyKdauCgxj5QS7Ji7KoXbDlyY0KdJFDzzYDIjwpJsOa81QGcjeVGgk4JyFICGev68hFHOVpWL9yVzOelBj8dMQh2Cu0bpJAgJuXgOk3W3/aVZ6Vs8gljE5M4J3w84LfErE85chqAPYaf1BY8cFy8qq6n63S0uv5arLQf+yIRFkQjFLEM3iaX6iQ
 CmzoCWTm
 mnr8B9Cv6MU6MxsbE/GFkMagXtsQAlIRj0pRXXv/4AcZ8NGKbE4T2a9yelVdnO2qATbq8p3fo2sG29QJ/2BUjRrVZolGYiyKPl3HmcTCGecXwQCS9aKH0m5kAwJWv5RMkZvfNAi/bIWpv3Vbseh5QdDk9LJd05GQXl52QJL/upvrwPIRhEHZN27AJbxvl7V3qVf7NY1sqHskNAbv8ATh7xwnNTgvAgv0dreh1WnZM1emNRuj6lGQaOqd0eQzi1K2XNNAPs3mr/pGQyblIBoFHGJq3Sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_LRU_SORT calls damon_call() for commit_inputs parameter user input
if the DAMON context is initialized.  The context could be initialized,
but not yet successfully started.  In the case, damon_call() could
indefinitely hang.  Read the comment on damon_call() for more detail.
Fix the problem by memorizing if the DAMON context has ever successfully
started, and skip damon_call() if it has not.

This issue can easily be reproduced by writing Y to the commit_inputs
parameter file on a system that DAMON_LRU_SORT has not turned on before.

Fixes: de3c60e1c831 ("mm/damon: add synchronous commit for commit_inputs")
Cc: <stable@vger.kernel.org> # 7.2.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 3920d5042f109..bd847829a9907 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -346,6 +346,8 @@ static int damon_lru_sort_commit_inputs_fn(void *arg)
 	return damon_lru_sort_apply_parameters();
 }
 
+static bool damon_lru_sort_damon_has_started;
+
 static int damon_lru_sort_commit_inputs_store(const char *val,
 					      const struct kernel_param *kp)
 {
@@ -366,11 +368,8 @@ static int damon_lru_sort_commit_inputs_store(const char *val,
 	if (!commit_inputs_request)
 		return 0;
 
-	/*
-	 * Skip damon_call() if ctx is not initialized to avoid
-	 * NULL pointer dereference.
-	 */
-	if (!ctx)
+	/* Skip damon_call() if ctx has not successfully started. */
+	if (!damon_lru_sort_damon_has_started)
 		return -EINVAL;
 
 	err = damon_call(ctx, &control);
@@ -423,6 +422,8 @@ static int damon_lru_sort_turn(bool on)
 	err = damon_start(&ctx, 1, true);
 	if (err)
 		return err;
+	if (!damon_lru_sort_damon_has_started)
+		damon_lru_sort_damon_has_started = true;
 	return damon_call(ctx, &call_control);
 }
 
-- 
2.47.3

