Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 281A4C88E40
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 07:51:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D26036B00A4; Sun, 13 Sep 2026 03:51:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD70F6B00A5; Sun, 13 Sep 2026 03:51:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC69E6B00A6; Sun, 13 Sep 2026 03:51:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 978706B00A4
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 03:51:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D1C5C0565
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:51:17 +0000 (UTC)
X-FDA: 85207968594.21.1363A1B
Received: from mta0.migadu.com (out-149.mta0.migadu.com [91.218.175.149])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6729840006
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:51:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.149 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789285875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nKZlj8YKRiZZrwBRuN7vLQ9cTs7jd4wf9NZC3OreOeY=;
	b=ZmYuX2n9RlwSPFvHKlsQWsih66rBt8VEFIkYMckUSxFzGiupt64Z12cpcC1gQRD9nnRL1i
	J3fzYhIsbQbapanEnv8tApbddRrC04NwEgf3ZMT8Exyp+jAlKQv/G18AQeTACD6iSpxHVs
	oCAD1QXJ2TvJYQa2YnYFn2ZaQtbXj0Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789285875;
	b=bPrn5/rj/lzYIynVlIQgUFHGETaQnvtv8OKLfT8gm4ZDW1XMFHTa3WabIiE6v+2E/f/4LK
	LxjccJHAspsA1/+Nz9W8rMebcO12vpoo76lyS+dLC9wBEWBMrYGa8aVcCtqHvyM6oJn6MW
	E/NX6rpLaZYiqks+GD5CXeQqW/B+lJA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.149 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id bd2b349e2fca1da0;
	Sun, 13 Sep 2026 07:51:14 +0000
X-Mizu-Trace-ID: bd2b349e2fca1da0
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
Subject: [PATCH v2 11/12] mm, swap: require zswap for xswap devices
Date: Sun, 13 Sep 2026 15:50:13 +0800
Message-ID: <20260913075014.1732524-12-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260913075014.1732524-1-hebaoquan@kylinos.cn>
References: <20260913075014.1732524-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: a6fcpaz53aaejubbybjiwjzq4mtyjp9w
X-Rspamd-Queue-Id: 6729840006
X-HE-Tag: 1789285875-112330
X-HE-Meta: U2FsdGVkX1+xpT+dVRG1IS7wU5QYQg5O2Ai6vstqXzkeETYJIUrcMCxqKJdjKPp7UJ9EwsSdkdZYrTucVS9nx0JdkZOm0Ed0jLKEgFS7BrTgzWOmsHa7BoqKidwLqgOZdSMZr0GVkpV13WJ6NdrA9wh+Y03QLy5/rDwOjopFCMKksQSRlyKzSUVSIc4fa3Tuus/P9fpOWFh6B5qhWzAGwzG+V/n3bIrlOBtIREPpPAVZ4xMKgN8jSadW0zdAqrshP7EtB98J4+6X68+RBYjP/sc4E4wK0/QQzug+NshwivMZNwGgjJeWCA5BeaSTv/INQTRApnvR39D2QBY3FWpmtjyCZbjSkUEYgjZiQJa8NnU0w+oEweROsdv52nCWDgTWwSDe7jvO82oC3c4mPL7q+xUEoqbNKMsX4QYCbAOnZ2WJg3zglhNLUFTRg6tmyGJsZs75KWjfLCJxQw+PIM00iQ6XLAlnS+vLzG7hTihlHek0T2xunuaZrL7oqnuKtUfNjttQTXlrWjUhRxeACkRsMzj38Y19R5CfPDudaFDseV/M6yacZWlJmemxRqMmO6iwSIbghthI4pFsTR/KOUxnznXsw0X5AeoNcEboe3V/90X1VvpYr9Z05fdbVFUyy39mL6qzMWtRviU2To7neHmpv5jjBQJrPGhHXWAp604LQwe51luRgNggV5IFYWHdw7fj/dPzcGmJtSaI6V5TNHkLv4g3XJVAHzDtCZoksa0ddTzIl0vOLkiysvC3i7Jj6v2ocpexrOK4ggYKeH5kjER9UVcI7G2e1ZD264p9ES7ZRZi/sZVIX/II3Wtecn8+IOWGGZODhZb1t+NUeyI1QolTvUcoYpBaxmbZyNKNzhO8ft+cyltUohl3tka9OsiXOjyhRrfnQvNdog2QX1k7dMbI+Zjb/8PIRghu2yl242VhiINaqazIL06fQQrq77BT73HbIN/ihbLiJSj77gaspS1
 XzDes78x
 R7PGEgFiLzhXnyPYBteskLjWcdTlIwI2hROy8KgEG+k+HkqXAB6lob+WbpKoH7Nxn7YUP0UGQQeJGCgTlsU8aPJ02XrV7J3cipWBzCS5dwGLIy4g9Aum8+kF1EQKcJQ7hLfIPDBylfljdEI25bU2asMChpHtdNIP+vPsdLka59jcywYi7N5+Y+id2p5TyBDqceuVTI8JsGeWGEMcC8dgIWxll2XO2oZHCpOdg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

xswap has no backing storage: swapped-out pages live only in zswap.
Without zswap, swapout always bounces back, so the device would
consume swap entry space without ever freeing memory. Refuse to
create a device when zswap is unavailable.

Runtime disabling of zswap after creation is safe: existing entries
stay loadable (zswap_load() gates on zswap_never_enabled(), not the
runtime zswap_enabled flag) and new swapouts merely bounce back to
memory without freeing it.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 0321b6b0da56..c2ca0a9ac625 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -4305,6 +4305,10 @@ static int xswap_create(int prio)
 	if (prio != DEF_SWAP_PRIO && (prio < 0 || prio > SWAP_FLAG_PRIO_MASK))
 		return -EINVAL;
 
+	/* xswap has no backing store, it relies on zswap. */
+	if (!zswap_is_enabled())
+		return -EOPNOTSUPP;
+
 	si = alloc_swap_info();
 	if (IS_ERR(si))
 		return PTR_ERR(si);
-- 
2.54.0


