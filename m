Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9452CA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 07:03:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA4D56B008C; Tue,  6 Oct 2026 03:03:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB7286B009D; Tue,  6 Oct 2026 03:03:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7E446B0092; Tue,  6 Oct 2026 03:03:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 784696B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 03:03:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 006391C1BDF
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 07:03:21 +0000 (UTC)
X-FDA: 85291310202.26.6BFD575
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0D77120003
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 07:03:19 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WRHVCplf;
	spf=pass (imf31.hostedemail.com: domain of devnull+michael.reeves077.gmail.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+michael.reeves077.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791270200;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=09pNJLDdyxZY7hIUzbsHU8itqxVgbdY+tOnkIBcHKTI=;
	b=QOQROAOy6tZtCLrbOxERcoIuOZALoxSTImxAmLp6jUTqK92JWz03dgGiPupiuw07ZVm+vF
	PgAAlSyT1O1qDxw3JdUopBnKxvuvF0PGbdFkncRL77CUEY3ra6W7ws5n87mNEPyMB5px1F
	MyJw3Oz+UkjpcG7p+AqBoQMqlmte7tg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WRHVCplf;
	spf=pass (imf31.hostedemail.com: domain of devnull+michael.reeves077.gmail.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+michael.reeves077.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791270200;
	b=7uS5UF2Jawh+B4O/q54EWxRze8xkHqAAS5WXskq4UCLjkZ68oWu7jAN73XJcGWaHZk16Oh
	s4oiLGadi9MITeIM4Ax+HdJfs2xheQowkPn3f3up9KndkyFeKPJmRSjsOE4J8eePSHP4ze
	l5ya5BfTsADJjz4Lt0SXrAwaGwLPfrc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 61EFE60142;
	Tue,  6 Oct 2026 07:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1F6DC4AF61;
	Tue,  6 Oct 2026 07:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791270199;
	bh=cyIjSgiZBCj6qCcFCL7fETCO1R7toajPATwE4IXsxhw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=WRHVCplf0RtJE5iq+RnT2aalRiuBACxZU2ZPiZNV4dltLlIVgmxhz2f9gQ7zd9iEp
	 bkTfkBt3MwI/c4Lv7aMlGlN7AFsIWVXU+wkAE4+ERxZRVZD9wMLfdv0EPAnPdtLz5Q
	 rgh+m+1UPhWMBA64vK0EJ3ywfTFLce0wtlYY8qiCdmeJQ7Lv8S3OKl1QjS9Z+K3hjf
	 ZFu/0i1azpBzc/W16AIBMzIw6ob9IWatXio+Nltcdbh5qXisyUgR2K752dllJ6mupW
	 ZY2vXhnH33hF+iGMB50LIBOuULgD8z1DK7qPHkLgk6WPfJPBoAqmWTNLulfVTAsgfW
	 jV2gPQrOZGwDA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2805CA5FED;
	Tue,  6 Oct 2026 07:03:18 +0000 (UTC)
From: Michael Reeves via B4 Relay <devnull+michael.reeves077.gmail.com@kernel.org>
Date: Tue, 06 Oct 2026 18:03:15 +1100
Subject: [PATCH v3 1/2] regmap: Remove debugfs before cache teardown
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261006-regcache-lifecycle-submit-v3-1-37bdd82fd47c@gmail.com>
References: <20261006-regcache-lifecycle-submit-v3-0-37bdd82fd47c@gmail.com>
In-Reply-To: <20261006-regcache-lifecycle-submit-v3-0-37bdd82fd47c@gmail.com>
To: Mark Brown <broonie@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, linux-kernel@vger.kernel.org, 
 driver-core@lists.linux.dev, maple-tree@lists.infradead.org, 
 asahi@lists.linux.dev, linux-mm@kvack.org, 
 Michael Reeves <michael.reeves077@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791270197; l=2394;
 i=michael.reeves077@gmail.com; s=fedora-20260918;
 h=from:subject:message-id;
 bh=zFAOzXLct8D+NOZeYw7b3fI/ausJUSmG186K8w5WDHA=;
 b=VG8lSoGwLN4wbL7/VfkD0KRIMazF1RCvOO959lmDM+49vcgPxdzSDnJxUquAxrHKVHfvTmkFG
 2T35AAhmJPNCmPKmopDCx18FC7Wex1MAsgMXon+PsqxqAX7TBAjVHU9
X-Developer-Key: i=michael.reeves077@gmail.com; a=ed25519;
 pk=VJ0TvyQ9TvfzYZa908YSE9kpkjFLLD5luv0bERu+boc=
X-Endpoint-Received: by B4 Relay for
 michael.reeves077@gmail.com/fedora-20260918 with auth_id=1035
X-Original-From: Michael Reeves <michael.reeves077@gmail.com>
Reply-To: michael.reeves077@gmail.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0D77120003
X-Rspam-User: 
X-Stat-Signature: 1crbp6isieeus4zjtjebqh9conru1c5c
X-HE-Tag: 1791270199-729454
X-HE-Meta: U2FsdGVkX1+9HiEHIIMNrQVF4sye91NTER6FgJGlpnOzwqwhsa1tvawv2ErvEr43RSDjeiZDJw21dKHcAxNyceS2yUY4WyXDjqGvlWw1UtXsN9ae6jyPyvKlky4UCZN6KfKB+TUXdakJ6IbhjwPOk9GLLOaz1Ibo9lxeAHXOTvzjdtXkn7LcWVMmm+A0XaD3ixP9WWLRa0RCyKWt2t8bOJzsfBAPK7biLcd9yyDnpsusS97QRtexkwtivIFdC/Q/xID1I53LHjbrO5GW6R81L2jD9Nso+MAAxCDmLkEYJLrl8FEoagLxBiGw/q3q057rLWevSc5n1Y9XqLUl/ReB2kVk6d4Bg5URWchBazrgU0QRyXPPkN4qn14nb0TNxnoH8AIh84PLMPS3eSulKFyLV6ch6j/pW/Zxn6+Ug6SYlJ0V0r7955R3Gsh+yt2a+EDtcaZo1mLj0Elj+k0LpCa3KI3KzgcEJciriMrLkbCqpjA+vGudlhe+kd0F44S3jsMgkCmb5S78ozUbb0Crz1mbzABtAa1n9kpR77n3TVnn8Pp1tQz4hVOUhhV5IDZkOEIWtju+AUR6Jb4uo4plVqGoQ3wwXsqqqjb4wB3a5LIbJhlEVNtelc3pD30xpiose0C8jpfDgjFh1SOVtq1QRTT2irrTqpFGSckNtw5W2Z5c/W9FQHa66gtsrOSxaDfUoMsH04q8/GhLb/Q+u+z5yY6cCzn5mxRbNywStKUbbwopxf9he0k7HpO+Fthbak6yviSNNq6Bp/nDSH29e6ZanHpJGDZx5qUW2flloY8DprGOIHl7bLjrKW9nZSbHjsM+0FZyPZ2hsbj/+ffevDex5mEzRmqyKY0w/DbTU5EINddoJm/5hwfwOhilU4x6Km2DUpOFDlgxB2jTmpFD9zIJRcntL7weeOtpkSJ1KlQZaytmLLGp1SGFXBJVvATHL73+TBQXhMBkWMq9GVRZR+L6G/Y
 cH9hYNbw
 zDunsXV8+emFfhx4zHWtWqwG99tzrRJ8I9t7HyEFMxnQDkFyzUIZPYlPZeXKz8DZdJyLH9QPogVKWXsTJ+kJ4GDq+HwoRdRWe5a6M608pMAVbdHnaJHTAJ3oH1RQvd8Ce8ab3TVJ2kwsq+m6UeG9tcd8OF6KnIUB6vXlY+YaCkPuGtTY8umeiTsg/+38vBcNRKdN4Gv2o2G/35ytZHgjaVbdbuojJYATcNlPKGrKw3FPuPBksHWPlH0T3nySEQ3+RdybIkK5IpFl04WatubnMO0JHC+ku7qlJ+1YaU7bagdVVJiN1DDQTufPtu442fo4Qi2IxQpXImjpUODWfzOgHaKduPS4Qy1t+Yxdznvp14aGnEz6s6KdgrN4WO81Qc6ceKv27RSLAK9s4QVHgF1PaIm58eS4NhOJ86Lv96bqNyNGkQXiKzjO1HpR+pb+Cl7I1BDQwkJds/nfdAaAC4ldWDYGvHP8wFFuYU63ipZRsc4JmUe/OsX+KZWK/Xb9HUlHgQdB+EGvI4B/R8QNY6PKOyG+WZ6MQdCrwz1Xr67UumRC9YBs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Michael Reeves <michael.reeves077@gmail.com>

regmap_exit() and regmap_reinit_cache() destroy the register cache before
removing debugfs. A concurrent debugfs cache operation can therefore
access cache state after the backend exit callback starts freeing it.

Remove debugfs before cache teardown, and clear the debugfs pointer after
removal. During cache reinitialization, recreate debugfs only after the
new cache initializes successfully.

Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
---
 drivers/base/regmap/regmap-debugfs.c |  1 +
 drivers/base/regmap/regmap.c         | 15 +++++++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 18f1c60749..9a09df2ba8 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -664,6 +664,7 @@ void regmap_debugfs_exit(struct regmap *map)
 {
 	if (map->debugfs) {
 		debugfs_remove_recursive(map->debugfs);
+		map->debugfs = NULL;
 		mutex_lock(&map->cache_lock);
 		regmap_debugfs_free_dump_cache(map);
 		mutex_unlock(&map->cache_lock);
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index e6e022b026..8e50a05ff0 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1422,8 +1422,8 @@ int regmap_reinit_cache(struct regmap *map, const struct regmap_config *config)
 {
 	int ret;
 
-	regcache_exit(map);
 	regmap_debugfs_exit(map);
+	regcache_exit(map);
 
 	map->max_register = config->max_register;
 	map->max_register_is_set = map->max_register ?: config->max_register_is_0;
@@ -1440,12 +1440,16 @@ int regmap_reinit_cache(struct regmap *map, const struct regmap_config *config)
 	if (ret)
 		return ret;
 
-	regmap_debugfs_init(map);
-
 	map->cache_bypass = false;
 	map->cache_only = false;
 
-	return regcache_init(map, config);
+	ret = regcache_init(map, config);
+	if (ret)
+		return ret;
+
+	regmap_debugfs_init(map);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(regmap_reinit_cache);
 
@@ -1459,9 +1463,8 @@ void regmap_exit(struct regmap *map)
 	struct regmap_async *async;
 
 	regmap_detach_dev(map->dev, map);
-	regcache_exit(map);
-
 	regmap_debugfs_exit(map);
+	regcache_exit(map);
 	regmap_range_exit(map);
 	if (map->bus && map->bus->free_context)
 		map->bus->free_context(map->bus_context);

-- 
2.55.0



