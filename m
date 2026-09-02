Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B427FC61DD3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 00:27:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 781866B0092; Tue,  1 Sep 2026 20:27:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 758686B0095; Tue,  1 Sep 2026 20:27:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 620EB6B0098; Tue,  1 Sep 2026 20:27:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 401336B0095
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:27:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6E346160563
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:27:36 +0000 (UTC)
X-FDA: 85166933712.22.87C90BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id D9F6E40006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:27:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bqyf63ol;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788308854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dPYnDusm6ZlAINNm2dD6FV62eCx2pxNkpvN0aJrj8uI=;
	b=iJXHq/dMAfzB0EPjlFcNN0pcd09dcBqZU7yOq6f5jJ8eA8oqyeTwfZe6a7sHTKZUPXJk3K
	19v5TaHJ26yDXlg+mam5Q0B+wk+vqKlHTt1gV2fktuRpJa2JEqd2AMqZOcqHMjRYu2bxF+
	+wvO77laIN2IxeVbaJ+q8ydi+sau80w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bqyf63ol;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788308854;
	b=CnV2lFt6fS+T67lSXvokce5aoPr9+RU3W0Lde7bZBvHpi0OpblrPwGpuHDDYoJrhqZgyIt
	5qitqqM+jgic8Ii/scPgKmmFDq4WfdXQL7WivuOaMVD2YOCNA13ORVNYizLuG1Mf0EntcI
	6OWyuJrJxbqDa78jcpENY/eS8En5Sqw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 734FD600D4;
	Wed,  2 Sep 2026 00:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E916E1F00A3A;
	Wed,  2 Sep 2026 00:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788308854;
	bh=dPYnDusm6ZlAINNm2dD6FV62eCx2pxNkpvN0aJrj8uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bqyf63oliUzCdLSCa2ShHyBHxtNTT/sxl0PpKRYUg0wgdCm+1RksqmlFUexq4GXUF
	 sX0oaDNLD8cyUfONL3G62kOpS1QRAB4Y8xSj/ZLMh9X6K8b7PoPpgoSKWB9OkjNmfh
	 2p+nSviFi+R1qQBPfHzy9bMl7t+S+BWcahgF8O6yxb6s9mEsUp0ORv7HpriEBrIAzM
	 MTmyd7Dx/zbTHGFecODtxBiKRaW4xovLK0r7jjzLjV5cmaOvtEZ60ZaNgFIF882pu9
	 9W/gOC7hyqT9D58C/CiPhF2EWdYh99cCrBuKoBu+Jv2pTwLqw8uCgmaTu62x2LO9TN
	 NkUfnM38685mA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/4] mm/damon/sysfs: set next refresh jiffies per sysfs context
Date: Tue,  1 Sep 2026 17:27:23 -0700
Message-ID: <20260902002725.108635-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902002725.108635-1-sj@kernel.org>
References: <20260902002725.108635-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: bxe69j3ynkpagzn756z1uztcfka5pyxw
X-Rspamd-Queue-Id: D9F6E40006
X-HE-Tag: 1788308854-781111
X-HE-Meta: U2FsdGVkX18qRN16/XF+s7GOd8ZT0qwliRIOSAJsE8N8Am9GkN/Ru5UT8v2v2epv3FEwsSXqWPsBQ6X5gp+bZ/5CyzjxxNDh6xO/0mPL1rOSBC73ORSI78ym/8GF9G9taDXw56wW9LCb10af8eKQAl4kIdF8/O3by/WeAbq+n6NFADcp+orVBizBrbK0PTlFXXEWFPF+uXh9mlsfn2ks94gGHyAJZmPJI2dJuyTjPpcOLB/BJ67RwM3Nv8wuTVUvzqHywtrsZSz8R7EceDSS2jBYThYmyXcudtQX5wVU4ZXVQnMRk4b8ajmVsW4NUXmP/D7ILeaCp0es4PMiqqqpscJWwrllx6FJ4w9sT0k83unSo/rNZLG11Ztlm/8d+VZntP6He7vMl4gzybqoHAdyt4thJUcvOVwAEcRqhxwhG424DB0Rs6gpNP9MMaVHMxLhnreRWbIEN2eSHBgkyIVbcsqvvTm7q3/dDjqYqqIvRvYUq0oHSEpVFbMV02P8UAOSRytMOBKsVXLvDXt+qyvrExmhxyKEvy74D7pLDAlVxUOG21Qv4e/SofUF8E+61y3QcukPG08aMwwUVmVKUBGhUZLCwTyNHZ0q4bfmPwfI8xZDSzB5UU1jXGrtQOtP+PGMeKVc2SlSxKvi9AYX0t58cgiyxP89L0BZiLUhnYm2UMXjVhXp42EQvtFY++/JG6j5PtavoXyKTXzEk0STO/PqqpG+neOZR5TO5dR9ZzYFOh4PIa9cw6bre4cbzF1Qk8gbN7kCOb5ioCapfNmjirhEDh1Fhph13FMxHHU9Dc/wKk3ttzPC8lCI9cEfZIUTAgvP+fDKbjwTj/gtqsYviNiPKetxG19sX2IgIHcXf44+GFh+GJcOr1/j2+yUhpL6mCILz1Fb6dLvioFwZO5gv+MGRi6fJCW4FI6BQWJ9D7TKTEY974prx1tXXm6LNhsYfwa/s6RtRB2FcFWBF9z4SC1
 GGBxI8Y8
 Xaqrtx/VctSTJ+8Y8MlVNq4l/jni0TC5X8Uv1VkWwDRgAfLs13ruvxvDCktuWN1eT7RrrW95DoTLvfGZfCT6Pm6hD5TDTAMshxtgQyjXbbOuy2JmA1jorrBqcHx7dHYy/jFHbw5aDehFeXmiA6dDi1XAk1SXCA+MD2KIe8Vi1E1DImsX4VdbO0Kpw1PFy7yzUr+vr0z6Xle5HqNzcOfzArHOVQGluz95T6KxmmjXXarN4XWA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When 'refresh_ms' is set, DAMON sysfs interface periodically updates
auto-tuned parameters and DAMOS stats.  The timestamp for the next
refresh is initialized when a DAMON context starts, and updated in its
damon_call() callback function.  That is, each DAMON context updates it.
However, the timestamp is a global variable that is shared with all the
contexts.  When there are multiple DAMON contexts having different
refresh_ms, the update frequency will be changed, depending on the order
of the contexts.  When there are multiple kdamonds, it will be even more
chaotic.  Fix the problem by having the timestamp per each context.

The user impact is not very critical.  It does not leak, corrupt or
crash.  The update will not be faster or slower than the lowest and
largest refresh_ms values of the contexts, respectively.  The user can
also manually ask the updates on demand using kdamond state commands.
That said, clearly this is a bug and can easily be reproduced.

Fixes: 9fd7bb5083d1 ("mm/damon/sysfs: change next_update_jiffies to a global variable")
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 3c81b4c91ac0d..dcb739ce0a729 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1788,6 +1788,7 @@ struct damon_sysfs_kdamond {
 	struct damon_sysfs_contexts *contexts;
 	struct damon_ctx *damon_ctx;
 	unsigned int refresh_ms;
+	unsigned long next_refresh_jiffies;
 };
 
 static struct damon_sysfs_kdamond *damon_sysfs_kdamond_alloc(void)
@@ -2213,17 +2214,15 @@ static struct damon_ctx *damon_sysfs_build_ctx(
 	return ctx;
 }
 
-static unsigned long damon_sysfs_next_update_jiffies;
-
 static int damon_sysfs_repeat_call_fn(void *data)
 {
 	struct damon_sysfs_kdamond *sysfs_kdamond = data;
 
 	if (!sysfs_kdamond->refresh_ms)
 		return 0;
-	if (time_before(jiffies, damon_sysfs_next_update_jiffies))
+	if (time_before(jiffies, sysfs_kdamond->next_refresh_jiffies))
 		return 0;
-	damon_sysfs_next_update_jiffies = jiffies +
+	sysfs_kdamond->next_refresh_jiffies = jiffies +
 		msecs_to_jiffies(sysfs_kdamond->refresh_ms);
 
 	if (!mutex_trylock(&damon_sysfs_lock))
@@ -2271,8 +2270,8 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 	}
 	kdamond->damon_ctx = ctx;
 
-	damon_sysfs_next_update_jiffies =
-		jiffies + msecs_to_jiffies(kdamond->refresh_ms);
+	kdamond->next_refresh_jiffies = jiffies +
+		msecs_to_jiffies(kdamond->refresh_ms);
 
 	repeat_call_control->fn = damon_sysfs_repeat_call_fn;
 	repeat_call_control->data = kdamond;
-- 
2.47.3

