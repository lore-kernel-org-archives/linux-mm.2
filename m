Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6394AC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 01:47:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD2006B0092; Thu, 27 Aug 2026 21:47:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5D906B0095; Thu, 27 Aug 2026 21:47:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A23756B0098; Thu, 27 Aug 2026 21:47:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40F576B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 21:47:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6DE7CA3881
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:47:11 +0000 (UTC)
X-FDA: 85148990262.29.4C7D4BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id DC94EC0009
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:47:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dtbX8mVL;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787881629;
	b=prj7b78jO54bLXOkusDylt7O20TM75flVN4kLtra6dvOV0FHiD96C7nWdjnMSG+rBgQX3N
	hzOnuo9JUr2BVz7MbOxGF4q6VjCmqME/UQ6i6oYHrh+Snje8hmAuTUV7Q2+gph4ZMPNypn
	UM9YWDW1tSLwB0BGLQmtRhHt1gqFmgQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787881629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9nWd2JiHbGpFxdKtIgR1/mA2jBP+r1D6KF4ucSMyulY=;
	b=p9sn7SP2ztHNii/Np0IzUgnjn26MoK88tkMnckxJldO1qMOqAtMSyDiQpaPtgM2Kn2E4nC
	OD+pPwxnGtkmd8BMsYqtoqgTcL1AuYZlgI/IOzU7NnNXpn5pLOs/uc4wtlvTShGaxWR0BC
	5Wg8xrh39lLX2FjuqPVRzBLwhBmHDFg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dtbX8mVL;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5995E601FA;
	Fri, 28 Aug 2026 01:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1101F00AC4;
	Fri, 28 Aug 2026 01:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787881629;
	bh=9nWd2JiHbGpFxdKtIgR1/mA2jBP+r1D6KF4ucSMyulY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dtbX8mVLoREWGaHmBM5m9kXliDsh2AQfn0hrzWT7rWHB/eaufkaZ43YdaBE5485NG
	 qMUCaHb0VIsQUV5/EfZdhs25mD+BsRV0UyBoYHNBAyzu0KrQkWdogw8wF/puukDrDd
	 BT3HFeCdQ97JhybLUtgPXRR55Jrav7TuPg7gGKmxukLTLgA321GvoZQRVNPmoXJfqc
	 g89xd3XGWdfQvhoOp7ENaxFZDliNMY2sqMSNtgZMozkfskvuRXe83gB2jeQyFPLLyR
	 5LrwkykKG96zwmt1q3iBUqlPekmRTXzAhNkjdKNnDlUJa5iUPIf0I0c1SS2qvnv6/O
	 79c9OP49m95zA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 4/4] mm/damon/sysfs: set next refresh jiffies per sysfs context
Date: Thu, 27 Aug 2026 18:46:58 -0700
Message-ID: <20260828014659.121058-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260828014659.121058-1-sj@kernel.org>
References: <20260828014659.121058-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DC94EC0009
X-Stat-Signature: qb13da5tshpmwhfc1d8wzwnd6w181rm3
X-HE-Tag: 1787881629-393331
X-HE-Meta: U2FsdGVkX1+bUf3JDFE8aYF5ku4o8S5S0qUbX0BfHRw85UVs9XGC20STQandBwmGlitakHRUusk+O5VLVw2TXXUGIsVsKoouA1ey1e+T66oomlbhLuXD1+4K+6Jzx4MCc/FDalJTatqc1po70Wyf1QmBUQsEmI6OwmIPPUqLiQOkcY1aY9tWy0SXUysPwmFH69Xh43h3me+FDyJYkdenibG8o38seVFZPJxEdeZaNr81lfkm4wslz3IBZpqYKn0D/v6iCEEy7ZNw+5+jZmcGE9l06LN0ouTr7B7Ev5E+loi1aTJ6eBEmH8fxZXU29+EllgSP36DZsHSE+mN5OzJ6cItgBYnAagDXckJKje5a67Yc72D1B7k1oP8rdiyvR3WCxHN4fZWF4zNcYVgcQd1vlUHwng/QDM8lT68Gu5eb7ZrE7Hw6uXkKaqczK9dWJlAdUyQHcKUYwpBdhJ11/RDXht2F/ZoHBH76EA/mS1vcy3SL6O64PdZ8e3jNeshcZHLYcwfzwqJCPRs3A0E79RKT6PD2E0Zlr15vMWu488nCHin3MtjGbEJFv/yuTTDY1joDKzcaIRwdLEanP7vY2yZy5RG+XT/TSmQ45SkZMRFM8y/VqE2IPU4YR2+AAXXRHpvYer7iEjcx04jJjSz/UeJcPLZizeQyX6HBppmnCna9yS4fHjAopA2o6WgY9wFQ6wibWobnjN4BL9sCEot2u7AMKlwg0IMSuBxAGbWZvYzIqwgW58w+xQ9iQwLCHJow5RvNMvqKPtg5S+p8ZbJOKBPjiJxOub99jjfeKvC5XY6Rl8oCGaa4qeUKGMRwfCjmAyQ8ay+LjqNY7JCKBlmpHy7qdwPJKjngAO/ucI8h87v1v2TaigreCZ5cvWWjIPCsiMSJcspGTlAk+djkMzxgRnhRe14dWgwbJOSlkbJmhOx21mwiUEs/EzLrH+zxHzhc3cg0ruSExJKhd2CVPT3AVvC
 M6x99bnc
 mWy+3vA9jI7+wKt2yxw6xb2JjVwM29BTU7bCnHp+nOPcDntiZkHT9IVto6Ocgl9iNzGBUW6jNRbej/2SK6GtEqA3aqkd4bunz5WuIr0MdsZCjul8xhdrlVwiwX4ryjRxBRmBN+o+Q1Uk7zYImmZciZpUBHPMCPZtTq99G/Ht33I9Qd25YfxChJpCW7IGvTTs9nofRT+d8wWZ0+Np+JKWrG0aHrHGwra+XlhYNBNl650PXt+A=
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

