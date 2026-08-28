Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72F4AC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 18:37:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D7B96B009D; Fri, 28 Aug 2026 14:37:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8605E6B009E; Fri, 28 Aug 2026 14:37:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DA056B009F; Fri, 28 Aug 2026 14:37:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 491066B009D
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:37:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 167A81403F0
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:37:02 +0000 (UTC)
X-FDA: 85151535084.27.2FF9537
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 83EEE18000F
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:37:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j9FMR5Jn;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787942220;
	b=jC4HlSNhxnrn3kxb4p0YykedjKnISYVn+843iTRL40yYO/lNQVCaQkGODUIcvCjeJ0bWbL
	AGwUqS6O6lIhfjBb66JAcRXtTb/XZuke2NOX6vQ8kLjBXuqyrN9fUIHsnEG9OHiw5St/Qs
	pAUcxFINtKcXQXWdqrtbU3hzQdZScwc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j9FMR5Jn;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787942220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9nWd2JiHbGpFxdKtIgR1/mA2jBP+r1D6KF4ucSMyulY=;
	b=FnYgLsyQDK8o3r3LHIKCK0j8oMpsk60R1XexggfbryZu8ATgkEPom0xr4lK3ySPwN9nQiW
	J3jGQHPfifnGOcK2YAaS5G5lq23rcEN2WNev/6Iy5mi4KcSLzvB3/k/sRrheXhAFwtOTBu
	7hp1WEW1TYxveGy2xOSwhYHIt88gQyk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2295860212;
	Fri, 28 Aug 2026 18:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949BC1F00AC4;
	Fri, 28 Aug 2026 18:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787942219;
	bh=9nWd2JiHbGpFxdKtIgR1/mA2jBP+r1D6KF4ucSMyulY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j9FMR5JnmSH7efPrQrLnpZLbc7Yz1AcigZ2oXDJSOH7R3q+6I7rgrm+O0sLvmBJK8
	 xZf8nG4qvXcOnt+j9VyThzjR9Sfe3zfany2jSS/bQRGk1Rr/6KjiU0F8H06/dTsaff
	 D2XKwF71uHMP5vP2RsodJkj97KtLehKD5EUkQDx5qRFZcxQJlgmYpmSv4Z1t7DDOLd
	 uM4q1bVIScrAheTmJpDfRBCKmyWltOYiXf2K77JvOG+WoAsNObZLOQifqSFck50JXP
	 MrkarOd6d6n+JAFTYqptHsuEHsamarp6wWpKvoYtcBSbiamIrOvZH8V2T/3pmMuVBI
	 8/uwDVYOpXdVg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 4/4] mm/damon/sysfs: set next refresh jiffies per sysfs context
Date: Fri, 28 Aug 2026 11:36:48 -0700
Message-ID: <20260828183649.71192-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260828183649.71192-1-sj@kernel.org>
References: <20260828183649.71192-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 83EEE18000F
X-Stat-Signature: 8wq6njjtuibsds1a44dztzzuktko31p3
X-HE-Tag: 1787942220-59788
X-HE-Meta: U2FsdGVkX18XRMupxGFFwT1wHZuWorf3pp2m13QsMYErdn5tUqa1qwEgmK9etgi0OBM2SPMrRBIgo5Wtm+jAnEBtbcrUqJgroMLLuET7K5+QF2LDKBV2Xk65eWlhXoMfgYLhU9lscwxiLDQH8IgQYLlfWl676pcfdixbq60SzR1+2Qicmi4SIijo06RLeUuxSzDAbnnlla1BRYGbNoPYzDviCAntsziMhcoVwwypOy5TJ+wvPoUCjkA1vNbay0iewKWb82fXgeIAl9Z8Yj7E1gbcXQeyBedZPqLoYk3wKBg+XOys19JW9erbGhb6YEVd3RaaTdXKFlyRUiDUvlR1NsBPqzPFB/koRQu6E2zWpF3e1ss24TaH7kOT831U5n2A8e1AQcYTAbxC7awLFQgrsLn3qiHFB89yyq/m+sWN1vngTvQ3atdxJq04V7rMwMWvAPT+Bs0R+oDQOnFKzcdZH6+iMTn/A+OqhwpHJwPve7oQgc9kHBeRPeH5o9FqP1rXA7ZxjKt2c6wnhNgg8Wl0b9SW5LYKqwv+5bYpgnQOC/N2HD45jgSJGAbOpwT2uZiYxK4ird7lJJ+D71iGKIU/tj2ruz9teMivJ8RGn1OT40q3X+ye9YZwaO1HaJaNHV5Qx08h2rGvmm7gBq4B/wpg9OAPMo2rQPDt07P6ybl6IGWSQWHchYbrcDDh0aB/CpCHrYpS9gXY7GaZck1R/svyvKjweA0ogRDbYdLU9nNIyi0kasuB2RVYSjHdDlPX+nDNueB94Dfuq2w8pcsitRJbbpED7EsTILngqWHzLu+yzNd6l1zPV/42RWwxbEJ6OnZGhOXomyXISfi2BSwDOO1GTJuynl0o7XeFxJLVYWkUyY70WOsPSTVaLCjEH8fKkSQxkEUZ6tXJ74vVpigiGrjpwesim+9mLZ+HuB69EDIEPrL3pPQsDOhYFsFrh91h7uXQNV8LwYQLYwgu094EY47
 Y2Ijlv8L
 iK8Mc9KMlztIOKflpr244v5ftZ0nFtu/U0OnNLpAP1rO4Zckxhq6v2KLc19nGh3a5DhsAVJ+e4T4LVbTkh9GW2rDRBUJPEJMHUJ7guLeI5RGP6ahx67H6+U52KOnELty9A4Y831iMhJhiCGInCCNyBk2H360RpCAKfyZ/nS56lN56M8BrmcfPO2poh945yE6+Qv+CUdI7nXL+lOv2f43XEnelFlNAoxBNtcJR2AfzqH34OY8=
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
index e3858ffab4b22..f05b256c90ee7 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1789,6 +1789,7 @@ struct damon_sysfs_kdamond {
 	struct damon_sysfs_contexts *contexts;
 	struct damon_ctx *damon_ctx;
 	unsigned int refresh_ms;
+	unsigned long next_refresh_jiffies;
 };
 
 static struct damon_sysfs_kdamond *damon_sysfs_kdamond_alloc(void)
@@ -2215,17 +2216,15 @@ static struct damon_ctx *damon_sysfs_build_ctx(
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
@@ -2273,8 +2272,8 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
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

