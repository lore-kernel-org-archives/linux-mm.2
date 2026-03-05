Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14FF6EEF300
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 05:39:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7E326B0096; Thu,  5 Mar 2026 00:39:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3ED26B0098; Thu,  5 Mar 2026 00:39:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 818AD6B0088; Thu,  5 Mar 2026 00:39:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E4746B008A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 00:39:30 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1D96F1B8A4A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:39:30 +0000 (UTC)
X-FDA: 84510906900.21.1E8757F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8232620005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:39:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C4xWRRtq;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772689168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=12kCedBp+1s08TddsuklP1aRglG4XFEuibR7H1p9bMg=;
	b=ey/38QT0QszEVx5M7t3vzWiYTgUeMD4rt1PnADv/ERHE5pudZEYTYFdiL8h+qmwqoUKytn
	Y3XO1oCOtl0TB6h4PuDixbav6I00h52/EWxLjgOx7TFrQjp/FmthbaRo6sk0hTUoLzGaP4
	dHBlVPk1hiXsN4gdfLUZZAn8zs3RdpQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C4xWRRtq;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772689168; a=rsa-sha256;
	cv=none;
	b=mGTJ0ueQBnrQr1k8/rBdSojKj1pDtUbknTM61nKcbqXxtRfffVIkKg7ehJvoPJ0ek07eC8
	iL1Hr37ssMARLukT+BC+RuFmQYclBXPuc+YMhk8QvXiXHnbUUytFv/yY1mfqPqAb5FHkHY
	UQ3pRyss3ll51RuNuNvgZ9Tf4Ery1BI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1348D6183A;
	Thu,  5 Mar 2026 05:39:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F38C19423;
	Thu,  5 Mar 2026 05:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772689167;
	bh=r27GMhiObkYnb8XTcWLlOteq5MZpTGOd9BxwRdhYsfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C4xWRRtqOg/akTqggqkq/gixQ1zv0LBRIeNg/LuXjhW9SEVTzUXzgYyfEHiK9wPvA
	 MyoYMALP+2/u75UX4LTN8Yr2Z7hLBRSQMdgLgGzsqJSdPl7f6mxtWiADkFtdC7skj3
	 EK2qR/3CIW/BgZKs0nNgLs4qLsqDqftcEIXFm+RiY+gaTHHn8m0oWvmCeb/+lTn7CO
	 iVQrlYycQMcvdgCeEUn43Bb4Bj0W48KhjiwRXbzf4vw1lYwJyHHBIiPuGjEfMW3LKf
	 LCpcjA8i/fPyA8QV9XTeL3MQcXTHoHnmoO4i+cfhIItHcpWNcQeD/L7wYsJshESX6T
	 7PAiTkXSCyHNA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 5/5] mm/damon/lru_sort: respect addr_unit on default monitoring region setup
Date: Wed,  4 Mar 2026 21:39:17 -0800
Message-ID: <20260305053918.83786-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260305053918.83786-1-sj@kernel.org>
References: <20260305053918.83786-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8232620005
X-Stat-Signature: g8j7uw86gn9zpfkodror7ks5gy6o7ees
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772689168-385975
X-HE-Meta: U2FsdGVkX1+luN3OGYsaKWncKTTADkI9mXg+tr8r7u1p33+QhMBRx9Dm7UAkxFF7l26xgem0bV5RQVb9SvU2xovSmkr6k8Z3APvLRC8bwEfVT54h/cZhOomMWqttTO9P9tb8w4D530Yh5jYG3k/aCXhfS5M2rUDXa3D0mIOwz9ojEEJ7Pbtm5oh95WDpjS40zkWE/gNRQUEa/s1ql2QlaNFV7faDgXj5m2Pr+ADWuoK060tIJiRthsFwMw7WrjTJcTBLgo56DRfZiTwforaITd0AU1OLctO8mjwU5baA/jkAP69rwNGa49zea5NiWBqFCFBcAJekebWXSwEUdDqqv0zc5NrXUZ7d5m4fK/3gOyAQbuKv4Myh+j/GHbelPFa1RUStqqXxFPWVPmT9u6PmrhShgeB1f2DMrJuMQ8icGAdkByQCgk7CgECftqnqBp1RtR86ZbaoOYFFxWsCQvtF+3quuw/WBtHb1C+DsGLOFo/P+vkKxhbp+nHP2Tc5wCbMfbbjfLz52A2yjQR0njKVIwhXeneqDgZQkVrVHd9AYHDz98iyBzf5evr1yc3aW3dSI22QE1gp9rFzUbQZqCjV4inqVkX6XkLXdGhu/UeLndFwa0wcDQf37u+8iHctpg0QeHlldy9v+1+a1PyMqc4M5yndNgCb8HX9a9UAdy/y3I3V+Q2f5cDUwg79BxO6In143B9+8BGbo6ZbaOGp4R1vSeLI+DBx0HDxsjIF4yREAet59uMNB7P4MIZkWnYNo9gCDUmvtiAIC8VJa6m7zv5m05+8MSwijE7q3pK9m3QNf3/B9TSxXd5YLx+2v0vnSaqHRmt+K6x9pmYeDwtLR9QiycxeLiXAUTznOL9dxN1wWs9v/Kgz2VPrGrxIYEy/ItLGaKEHPd6xcP0tGDmGYpqdTDA4dlBhSEOODVcciAYHMvuuobNCfpW611Hw2DNVqKb94fmwjtSYyUpZsb7fiFK
 68a8f+Q5
 XJWN+nw57sJd/7M/AHlA+9yg4m8MoxYQGQLY3nlirG7UHZUlEPk8y6mNqpKByc3kwxDv1MEVwSErMy/tg2lPgoYgSdu34mwM2MbtG+lLRM84MiH/C+50OPY6tpYb2T8uwHten9x4wsuHvfsTcJZjocEV9A3vwtjFyf4n913HX20qxP/MsOwb4ftUYZiSK3R4Hpryw8AqZ8OIrs3yNHeeD4jFaYyXrf2FkVORrEJep/JqXe0/CY1ROux5RVDO53ubEUYEh9uajPF0pSuiLz6d+q9mBEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the past, damon_set_region_biggest_system_ram_default(), which is the
core function for setting the default monitoring target region of
DAMON_LRU_SORT, didn't support addr_unit.  Hence DAMON_LRU_SORT was
silently ignoring users input for addr_unit when the users don't
explicitly set the monitoring target regions, and therefore the default
target region is being used.  No real problem from the ignorancee was
reported so far.  But, the implicit rule is only making things
confusing.  Also, the default target region setup function is updated to
supports addr_unit.  Hence there is no reason to keep ignoring it.
Respect the user input addr_unit for the default target monitoring
region use case.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 133ea17e258df..554559d729760 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -291,12 +291,6 @@ static int damon_lru_sort_apply_parameters(void)
 	if (err)
 		return err;
 
-	/*
-	 * If monitor_region_start/end are unset, always silently
-	 * reset addr_unit to 1.
-	 */
-	if (!monitor_region_start && !monitor_region_end)
-		addr_unit = 1;
 	param_ctx->addr_unit = addr_unit;
 	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
-- 
2.47.3

