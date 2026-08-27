Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7E62C61DC7
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:45:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5DDE6B0096; Thu, 27 Aug 2026 05:45:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE7C86B0098; Thu, 27 Aug 2026 05:45:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB0376B0099; Thu, 27 Aug 2026 05:45:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D28B6B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:45:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2F92C1C1C05
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:45:24 +0000 (UTC)
X-FDA: 85146566568.25.4527CEE
Received: from mta0.migadu.com (out-166.mta0.migadu.com [91.218.175.166])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2297E4000D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:45:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.166 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787823922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s8t7wBl5GuRrDpcpUAUNIUwyHz5WU4gODDS1vmQM7sw=;
	b=djiXWctISzcoY6pXmGYzqssjFE7Y+eUdqQmR6+ezsrCYnLN8Igx6wZHmAqfPs+XBlbYz4w
	AKdZCTs1pfZ8bDiqU8FAXvvb22DLWXd4QhEOYjZH4opsR6NqWygu6kWQE2Kp0B8YD6Ern8
	v5LAcsDdurtBpOY8YmjwmlhGTsvGsl8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.166 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787823922;
	b=jIATTjcSmrmqI3M8vW1YZZPcSsSwSDSLw4b2EcVYCzS8dqmn+pSnPnPwNHeJygiLQjp2wQ
	aCDfOjYDw8+edUCTsjU/Zy75iiXTJz8ket2WzNCAJqRI5h/J2eBd0E00RdebdQuTjUIaFT
	6ihxQvZfl0n7bhfC0fkuL2eSGQcrHRc=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 70fc1b369778f235;
	Thu, 27 Aug 2026 09:45:20 +0000
X-Mizu-Trace-ID: 70fc1b369778f235
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 01/16] mm: zswap: return -ENOENT when the swap device is gone
Date: Thu, 27 Aug 2026 17:44:51 +0800
Message-ID: <20260827094509.1016740-2-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: g4o4woeijwidgax6yatgjxyek64qjim1
X-Rspamd-Queue-Id: 2297E4000D
X-HE-Tag: 1787823921-743163
X-HE-Meta: U2FsdGVkX18vOTPcvqPpV3m01p3Iq4XOtRXWqgeDiJH839uJ/gTwBCHX0Ze0Dbbm+6jgujeOFmp3QB8fCDC9w1UUZH2b00pROQySnS7nVX0mnvq5elpyfbZQfWs0S8NzJI3SH5p9b6POeFoO+wJUDLu4R9zghuXFFj+OyDCLrr2jz0z5urac1oDFwnXMXYs5ap5JZH5qdChMvsxV9b0q/npzkL1BeKsaDv04geGWROgjXxZvEoxbe4SoVeKwLd5gOw2mDvIerBXXLySPvvi+FiW/BAgLT9+E6n5DLDuNxpWYroCGhVYmJXOjSM8QHx6jyGoSjF/IRu6eON2eGBDR7kfhy2L436M6EUMQ1ibjhDewQhEdIww/E2DCvD5LnLQoOxT7fJPGwEON45HlnIRRbs+eulaiVycHdTO+Tn0Z/5GoD/uWBj+B6MCzjqav9AFK6I5el2q1gVyFZmuvApyKmxit6HQb/wrJBHmzKOtnSDbs9CT7Pf9ovvnpa3nle2nLLw4wwxc2DkLf9r4lEnTHgEv/dPLlWYOqiWKfDFf/lxnRkIflLR3RwNfRclVDE+VtRqPAoCtEH3mpTWvW9SvtXn6l/2Qxabh87bKf4+l0tO6ONNmRS422OBqORIwqhdeGKrQ+j8k6POjxM9DhWz1B13v9Bux8ajLl94ObvLPR203530p8Q0EnzRqRpO0/VNLks9Tko9UCc1+RYbiWFKB8T8FS5Wm8pfwSpdSGfH5uiDfKgF5RnD8W4oeH0gPmYvKKT+q/lQTD6U8Py2qHz4UFmXM/O/kmORUCqktua8yOWLINhHKW6WlfEWR5XGBuEyW1yBX8lMhqF/lfAQMVLXOI37YOgP9pQaxwme46BBkwnSaCft7/MDMO034/cqPH0y5XKvmvsPN/VwFC6vYcvtkP2qWc8UmuZNGA+rN5qpdCRTpYHUChv3cIXTZnU/06VgrXXLdI8Zov63T1qAubyL/
 Kxp2+CgO
 0xCm/gjvPChmxXhAICpSrOwdO3Yw2embuwmr5cIKqeOyXhzgJKef/WzQGSGCvRMtBFo4bcMYJyA1yB3FmQn+U9lPod4XdLKEeqS4z3u7ZORnjfqRSYogm1G7rL5bDynmCHf/YSEly5pExV4Qr7d5ay6VBH8Ssm7MWPjkjuzxiN1EBRf7wWsKTmntyC/kX1grzqcPlx5gBSuWLPkQwu1eAeDp8aBzT12mlVWwc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap_writeback_entry() returns -EEXIST when get_swap_device() finds no
device.  -EEXIST is the shrinker's "page already in swap cache" signal,
which makes zswap_shrinker_scan() stop shrinking entirely.  A NULL
get_swap_device() instead means the device is being swapped off, so the
entry is simply stale.

Return -ENOENT so the shrinker skips the stale entry and keeps scanning.
Independent of xswap; affects all swap devices.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/zswap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 37f34e406c8e..b9948d4657d2 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -998,7 +998,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	/* try to allocate swap cache folio */
 	si = get_swap_device(swpentry);
 	if (!si)
-		return -EEXIST;
+		return -ENOENT;
 
 	mpol = get_task_policy(current);
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
-- 
2.54.0


