Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B01031088E76
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 05:22:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A8746B03ED; Thu, 19 Mar 2026 01:22:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 863E46B03F1; Thu, 19 Mar 2026 01:22:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B5D96B03F2; Thu, 19 Mar 2026 01:22:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 42BED6B03ED
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:22:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8577516030B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:22:12 +0000 (UTC)
X-FDA: 84561666504.10.7279027
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id CC63A100002
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:22:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HP+831u3;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773897730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mB4UoVanGjJ0b6Z/rtgw22+7a2ViKkbvDoer3Kj9isQ=;
	b=kEVVqKdzJ1UYFBPfHRdZfL5E+at2B2OhWzEDleBxa9g99lwZA1ZOJelqkyvS1dHaG2Zl/k
	COr88j607RGObMqOU/zt/5q/kuwK2yMbj7Sth6aPi2djXK2kJCL6wljes4ZG0fEEI8DVul
	slL6ceqpgnKSs/82iiw7YfM5QB2je2k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773897730; a=rsa-sha256;
	cv=none;
	b=CNMf2xU+puYWw6S0lePBXu1eJleVGcoIycAkaqUY4UolU7Xd5xdF86PS/tZcfbtVKimJc7
	5pljBhqbSq3rG7Hu6Z7LQZCh94UQBUuLfXecXa9xzaOSLhEiTwABAblWuwQVRZhe6dlQfA
	LfLx92o0UPPf7d73e0BDAsZPnHdCs3I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HP+831u3;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 343D844707
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF939C2BCAF;
	Thu, 19 Mar 2026 05:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773897729;
	bh=TJXeffpmshBn5e3s77gk9ewA/YmV5afqYkZ0L4RsmNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HP+831u3C18QuYGn+8t3T5P3MI5t8JSc7dy5v6wh8t5I2JM7wDsvYJtcnd2CG4WXb
	 Si2jJfp7u2Y0Ucbusoj+kXFBgx5w9aRc/CP/EMtLepFRkYcs9AsXfu5r4OX6ZxFul6
	 IL23kIeOz4DJRkZSsOFTisjdFe4/Ny9iC35R4nPcr+2yQ2CQsR4IgVZ7Mz5pg/taUs
	 jBz5XHpoCVL4py3uf4nX+TCbB5O6G3GK7TcWKZBfBsDXhMWeS+O38lNSfvADomo/DN
	 fizmoAkzJfawSrgRSVLM9PWp0Zfx3FDRVfDfsyUXH0PadUzjhDVz6RQZ/JpbOpxhCU
	 AdPVJbxg5atgw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 07/10] selftests/damon/_damon_sysfs: support pause file staging
Date: Wed, 18 Mar 2026 22:21:50 -0700
Message-ID: <20260319052157.99433-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319052157.99433-1-sj@kernel.org>
References: <20260319052157.99433-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 5emqqjf6ib16usw1pixzyghqfr9ek11h
X-Rspamd-Queue-Id: CC63A100002
X-Rspamd-Server: rspam03
X-HE-Tag: 1773897730-145021
X-HE-Meta: U2FsdGVkX18/+PgT2BrwRxjfZs8WzWwCFgxnHvlFqMgg4Ylk7rZ9J5LRuD82454nHFCgD/FahBoCZ2OfiCo9SsBdiyLVXp3LrBn3b/eOJD8zB/eaXbHSZJp7nR28CDtcXlEkCrVLVV/ipuLB4pjK6pCy4nnLvBUDkDBk1rBuDz9Uz1Q+DeuXZFHVxw4AXsmXBVW1tUJgPy8r7VN7tNMjD92jilncgENcXOoUwMVLdWpnGYLRKDu3h6diR6EJh3ACUyK4nf9o/8cdg7wtuBMIuIgKeTpX4xb8PpluZUaJaDiIoU2S6CSxKH0ROyFUit1j6H3+0xyVyEQg6ax4R6AwZL0rGkLgpvJ0EhTcpbKhCcL9so8b56iEQBnGKFu0QnhBGiMnv0y7QF7UtgDQiI0f7hA8UdqQvEJtcKGuWLW4jg6tO/UgIU2fGMt1fK5KMUrFR0rKuT8FTB8nX1iwDFbaXU/yWtn4tBZSGhaDol05q+9yMcC1G5NdImUeFdHeKPiGTX2WAYbpwwZEsj/H6OSNve+LssbVQvTdnBpWZk6+Y76vYcJ5Geo4awiXymgvLa0OkpafOYas15IiZWvLplrBbrNkaNVZJfKJC+ppyPhNc9rKLExd23OoE5R61Kc43j1m8t6ixHNDakC3l+v/I0BNqjLGrUXCIqef7kcKZIpy7jbJ0yZysH6bq2Ah5aAFDeyqxhCOq3/BfUsWkxB14qjV4UY4Un6PIOBE7HVPwfe4BDP3Uqw/FGDuegPWzdu25nLWSpLKECRXDZasAauJTFw0ui6fEHzKbdW6uZoZQBD0qMTYDKHifK35Ly21WBzceE+e/DnWpEdvsQhZuaZJOmZzXyduHLNope4ZD7uF5dHIZJRTjKwYWrkwj9ELX66rN90t6E40Cyf+WU4iAqLJWuMr3VtolRUmwDy5zKA1IX96vVKkGoMzlOTqiE+Du9jiu3qyKfT4ulDPqUh91A7oTZ8
 KRIMGcJJ
 H2E8eokxRhePzPxh84lZNUAbtuXcwkfCNzgQqyJ6d/6bR36Ti8J6oJRJOYSWkD0oSk6XLCddp0jHyjSOOwLp3swBA6q8xC4bObREEicS498TWVnO6RI+6Sm4yS/akXKmKCAeA4SstRqvjw363Lnw7Ij01l90soHpbD+BuULtKnS7h+54nOIFCpPoHAHRX0IJPupihhdKE2UyNpw4IOfcK5lmar6jRdm0BGLV3j4RjVUiVgDg01wGoZ+TenOgYsrYJHYuvR93BiBDx0QN2AqKtfrsBvRG97WPZiEdn1zUgBxJbMXvToyKrr07uBqdM0XZbau/EWRDiAp4zScG/mfDLXIqYZnn8mgaSP8u9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON test-purpose sysfs interface control Python module, _damon_sysfs,
is not supporting the newly added pause file.  Add the support of the
file, for future test and use of the feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/_damon_sysfs.py | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index 2b4df655d9fd0..120b96ecbd741 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -604,10 +604,11 @@ class DamonCtx:
     targets = None
     schemes = None
     kdamond = None
+    pause = None
     idx = None
 
     def __init__(self, ops='paddr', monitoring_attrs=DamonAttrs(), targets=[],
-            schemes=[]):
+            schemes=[], pause=False):
         self.ops = ops
         self.monitoring_attrs = monitoring_attrs
         self.monitoring_attrs.context = self
@@ -622,6 +623,8 @@ class DamonCtx:
             scheme.idx = idx
             scheme.context = self
 
+        self.pause=pause
+
     def sysfs_dir(self):
         return os.path.join(self.kdamond.sysfs_dir(), 'contexts',
                 '%d' % self.idx)
@@ -662,6 +665,11 @@ class DamonCtx:
             err = scheme.stage()
             if err is not None:
                 return err
+
+        err = write_file(os.path.join(self.sysfs_dir(), 'pause'), self.pause)
+        if err is not None:
+            return err
+
         return None
 
 class Kdamond:
-- 
2.47.3

