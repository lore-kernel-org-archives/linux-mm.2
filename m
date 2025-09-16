Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B70FCAC597
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 03:35:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BF498E0019; Mon, 15 Sep 2025 23:35:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22BF08E0001; Mon, 15 Sep 2025 23:35:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 125618E0019; Mon, 15 Sep 2025 23:35:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F117C8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:35:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B705016077A
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:35:21 +0000 (UTC)
X-FDA: 83893698042.19.22D7EE4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0C0021A0005
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:35:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZgVIllP7;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757993720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e71WtFl7Ehk4InYXu/NHsVZIarG0vc1r96SKwDDBc/s=;
	b=kf2QRpW4P/fjpbHYTHWV74OFFIwarh6nwBVZ87v0ESHxLyBBsaCowFUpTvNteWCG01CBdp
	vgUcIVKNaBNcqr5aOTHgO5JJ2eRUv8CF6/WOTLLwGMKFfbMEqayj/SwIQfPUYrmyFIjE8n
	WrXxUH6zrSRRnJb+8QDrh0PWIddkQ4U=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZgVIllP7;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757993720; a=rsa-sha256;
	cv=none;
	b=78ZjGWQoZDQlJ7uRCNqZXXzHPFIk5tzl1PgBqspKD0UDK+ztk9oos+aJD+wkWb0ARiOIy/
	QHPHWiub4jaRdSZOs6hLryRhs4oY4nf5/bxdaesxPe0Mf4qYz8gq+C6Vgisy7Syr8vHeX+
	rqQipE/l82MYp/PEy1rMk7tR0PXNnkk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2612644A68;
	Tue, 16 Sep 2025 03:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D41C4CEF9;
	Tue, 16 Sep 2025 03:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757993719;
	bh=yq6FzsyzX8HDFFWIsvaokYnQzl9M5W1Jr+HzsSN6nWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZgVIllP7jG1t5xaNp6Ej7+6h6D0S3fE4uC/XLFrEWCBoHupYxjo9jV8rDMtz0S3LQ
	 nSZfP4F1iftVGRQFLXoEfzfEu6hrCwigUaTVghy+Uh2475SNcT6Vc+ZaBN19ZR1F7q
	 EH9fdMvVUtRXl8y01N9V8dL0SoALaK3UjU3OBTnN4dA7SiZvo/f6g4ZUOpWgRx8HZO
	 j4gSlqY+X6drLgbfTvW7KyNnpbH/6dU1S6yy16KXPRd92YW5bNuTuSRb95+gx1XoQh
	 xIcz6dCNGllxAKbbucMBlLLCZTKCiaAsrI0OouakMAihQ0vW/nF68rW7qsF81YRvP4
	 kWSCCN3mKRzzw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/7] mm/damon/stat: use damon_initialized()
Date: Mon, 15 Sep 2025 20:35:06 -0700
Message-Id: <20250916033511.116366-3-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250916033511.116366-1-sj@kernel.org>
References: <20250916033511.116366-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 34n7rxgrkqcffddyuzdrgkynsjqhcyr6
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C0021A0005
X-Rspamd-Server: rspam04
X-HE-Tag: 1757993719-837879
X-HE-Meta: U2FsdGVkX19O5XRaIMrow2gWMg7adiXEn5GfdKcdpzc7aYkAs0AodsiqeA1KDd2W6sgOchngqxfgfmcw0SRrKGouTQoQcP9JIbSZYPFfkrTz9BOI2qtsgQXv6zPUcsJxjJAZhgwxhz301E45Ae7EjnG+D6P1C9hZi7hL+FwRJVLTnvAKDQ34kkbCcY0yvHIwKEU1oRtAKnnTDyfFaCvAP7yUgUWVkj7rwqvrYu/OE7tec41iI0/SsEfkj/KoOVYYsbgXsfb3AZjc97FJwkiAv1fiTgR8sCOnaM+32jZTlD9F2ZoUYaDBYHyHahYK1iXpDuODEK45+S7JxgNKwcC7RGQOyFoUIiF/hTsNV3drxHNqziEl9CZJT41XOQxfk1eIgkOro+k1C66mrPfVoQll3i5REf2sgsiCmduXX9uqb2Cl1m711TSqbNk+1KEIunCZp12Qkw7mPemIWx0FIVENJu0Fc4Z7OJmAAOZsDDxQ3s6gW9Rvdje0zGgrbYImY+TizdXMXRx4E7PunbcUYPNEjnvY/OJdvWkrAUvL5+2vE9G7eJx+vTZXTIw3PvNxAGTnETLkOcXvU+yNtnIPt0LllqXEKhigeNoQGMvU1syCuIdjgcdEJwSNh5EE7HIjsLyvU/1V6/idw2wAwrf8yN8EvGj0CWQX02gcm3gU836sOYeIxUj53HDLf4Wy0D6rw98j6tsWQvO8i3Hc4OjdMmYhWtNWRQLNuchzSK2Ryvr/NertGpzDDN98Nn3xNJZgiQUy7w40wzx59ny8a45tiibjMyx8gDxNywzhmIoJH7S4/jdkFdJkEQ7ohPZ0M9Z88rHqyCZMcR3wI99cSbegsR86jI62OFCOKUlne3WAs3XGYruzmdx4T++zmjO8fFkEBGFomV1VKJqbweNBGQqmsqefn3nbFO1ZWTgzHhoYgAU/lu4UpJyhV5rwGNdCdY+yOcmg2CG8zZaxyyo5IbS1EWP
 Pd9a+HV9
 E+r01dySsGN/8Ja0eDVvYUJ7Z1EBJZ2avbdZfjqOvDWvHdEEizj12sNaooj5Hh863WEcsvsZuf0hzMdmy5fuilMZ5ZvrRfWrRZO8OesbLEo5/7+79HnO9Z1GHZB+DA1EwM5nrtiYKMo+SkSCGw5oyVX5jj/SIym6okFChPb5fbO9zDOXhU27qGGGUSI13Vi0P6t4f3/vlaWV/dV0u/DXmEqkgLJJGKkKHl9GzbGo6sJ9AEv0Qm5i3Fj4LbfwqpyDNaVDgyeZYrrK+jd3GjcAQLs3ogQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_STAT is assuming DAMON is ready to use in module_init time, and
uses its own hack to see if it is the time.  Use damon_initialized(),
which is a way for seeing if DAMON is ready to be used that is more
reliable and better to maintain instead of the hack.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/stat.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index 87bcd8866d4b..c4fbd8cfa5eb 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -214,8 +214,6 @@ static void damon_stat_stop(void)
 	damon_destroy_ctx(damon_stat_context);
 }
 
-static bool damon_stat_init_called;
-
 static int damon_stat_enabled_store(
 		const char *val, const struct kernel_param *kp)
 {
@@ -229,7 +227,7 @@ static int damon_stat_enabled_store(
 	if (is_enabled == enabled)
 		return 0;
 
-	if (!damon_stat_init_called)
+	if (!damon_initialized())
 		/*
 		 * probably called from command line parsing (parse_args()).
 		 * Cannot call damon_new_ctx().  Let damon_stat_init() handle.
@@ -250,12 +248,16 @@ static int __init damon_stat_init(void)
 {
 	int err = 0;
 
-	damon_stat_init_called = true;
+	if (!damon_initialized()) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	/* probably set via command line */
 	if (enabled)
 		err = damon_stat_start();
 
+out:
 	if (err && enabled)
 		enabled = false;
 	return err;
-- 
2.39.5

