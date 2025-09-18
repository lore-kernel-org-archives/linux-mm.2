Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA36CCAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 03:47:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D21C8E00AB; Wed, 17 Sep 2025 23:47:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 454EB8E00AA; Wed, 17 Sep 2025 23:47:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36A9B8E00AB; Wed, 17 Sep 2025 23:47:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1BF478E00AA
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:47:12 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D28B287418
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 03:47:11 +0000 (UTC)
X-FDA: 83900985462.04.A63586E
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id DA3A940006
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 03:47:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JvbQ3sPl;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758167230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RTSPriXkykSZAqFc/d3pFWgXfbyl1hq/sl6Tq3Oc8Jo=;
	b=z9In3ClsvHkW+uIKKceeAxOhKlXKH/CB2u2mzutdIEOtTY6L2A+9+TdEFtslKYYNhQIk3U
	dOh/cRiG/IkW/aaOALqkxhQAbpi8jOm8/EnAGBltuo1eWuwh5m1ELozlwc+o/HWG+o7MIr
	i359wdb5jD/XfwZHaL29B4B53DL2gkI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758167230; a=rsa-sha256;
	cv=none;
	b=sm3gwYQeDA3KTFIu18MTpyOek+kPSuXxfNONbuiGaCwJZDN8j87clsJ89htd8ejkfRG0v8
	gy6l3nfUp8vL5r3vP/zACPKArVBkUBZcEi9zvOyi9jELcbmTb9E+KknE1LoKaspLK/nYkN
	XATj/deO1cTBgJJI308zgqnOrV9Uf3A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JvbQ3sPl;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758167225; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=RTSPriXkykSZAqFc/d3pFWgXfbyl1hq/sl6Tq3Oc8Jo=;
	b=JvbQ3sPlT3HWknW0YBv4jXaEM1RWp8ghfhtGRjZnAOXKs/YX1SEoa84a3xzg1n3t7ybTyEqAhU6QwUWsh8SRa9g8VQ3mEx6SAYuFbijHFmPwRKBw0M6AYselvU0tWA6YKLNdiDf78XVb8v3zLIHemNvl2aJ15FeZSrkNjcP2oaE=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WoEWeJK_1758167222 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Sep 2025 11:47:03 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org
Cc: david@redhat.com,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	hughd@google.com,
	willy@infradead.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] mm: vmscan: simplify the folio refcount check in pageout()
Date: Thu, 18 Sep 2025 11:46:54 +0800
Message-ID: <4cbbec5bb92397aa4597105f1f499aabf7a1901c.1758166683.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <cover.1758166683.git.baolin.wang@linux.alibaba.com>
References: <cover.1758166683.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DA3A940006
X-Stat-Signature: 3i3by84885uauaf61iz4xh3ijnbucdsq
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758167229-180880
X-HE-Meta: U2FsdGVkX1912LZYtc0KlvLO+VI1z1EVmoLVVFuiSoL5pn/yDkceEi6XjMYi4FteZ9pXmyc8OjXTVWigwoge1W04pOg9A/CcJr3STD9dF3qW4ZBwHyoJoCu+1wwTGV44Oor2Wm6hCKoOTjNsu/AJFwG3L7ysA4fXgI48ghDHdPIlFMrPPPdmaDSdXskpLnODeA9/ATP+tj+qsb+02FWsXBHi3dDSAS5FWAYu7TjxohNVZCdqnQqMorXvS+FGm5pgbXioeQJ4+qAza/5rCftNh7BhIdTmOq/B1NZ9ea+az+Xq95UE86P4wPAQ2mntCxQQUGheTXQ2A4QGPz8DKMAgTvFFXKUcDkBeM+yHgL1q4nJSyeQgkU3ioB+enFZZX98SKLJLDCdMeafv5hbbhMeav6Ws+eBNxVV8Yx5SPiVw0JCQbH8rY31EjvAzU1xoelno0AelOoCzVESBVGusabQumHzrErSS019WtxuRDY9TwfOqnxcyJCuChwVOrFnjbnbH3+TJml/D330H+Qu0UI3Q37014i4wOuktxdzKhGBmJO4Ov85E4xCb6FBkFbOBFC3cn4S9qhLtRwHFowifv3lmKfFH0GGFkClhPrEPTyJ3njVOIFdOhCjzcGjkI32NWNgSM0WjZOk4tGy9h5KtaADCVN7qe2i6B2wIeLRTIwUNaTasilpmk5FCP3l4J/+GrZL8eLJmOvpgDyvYzCuQzqut1QARY+13KNl8rDZMVKH9RHaZcNwYjgLTGMnLu2QFBoPZdJmeHII+MX6zpMXdounU0nrcgrINceIJPwg/88KAREYqwzm/M65QrixobEKUuwmRFumUJxhEWkf2h763yrBck56M2eTEa9LeYILTh8UtJ7Q2JDvbf/BnQpt3FLlgWd+Aoa2Lx+BZn7b5KVLk8nfDByeNlw3zlnLousD4Karertr1HSbKNthzsMuqc7Bg3NCx/e3l9DTfHBbGHpFhc5z
 ZIah6ld8
 fHRBwWsS5kWiAxUJ4aqhRV9TWa4oWJvteiv8T6mtbl9TFPNJZyay0hYIuiR+W+dywsUzepa5ucXV+ACHx834BK+aY9o/QmaieVEf8tNCDvkI418GUZFhb1rKVdJrFAT3E/me6EUV2pg8X0BGLMa8ri3twrEoeBSsWqEbQZZNU+SnRN9kAvanvQghX9QvEYjtPYq2IIjiuE0l3PKggCD2HeVUgQa1z+Ld6OKxrw2DZXhKQERCtO3ffPcNP3B1pbTZ+Lne8Y1y7ZRcZ9EYe712fIHzhIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since we no longer attempt to write back filesystem folios in pageout()
(they will be filtered out by the following check in pageout()), and only
tmpfs/shmem folios and anonymous swapcache folios can be written back,
we can remove the redundant folio_test_private() when checking the folio's
refcount, as tmpfs/shmem and swapcache folios do not use the PG_private flag.

While we're at it, we can open-code the folio refcount check instead of
adding a simple helper that has only one user.

Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/vmscan.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 930add6d90ab..b3a57db6a445 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -477,17 +477,6 @@ static int reclaimer_offset(struct scan_control *sc)
 	return PGSTEAL_DIRECT - PGSTEAL_KSWAPD;
 }
 
-static inline int is_page_cache_freeable(struct folio *folio)
-{
-	/*
-	 * A freeable page cache folio is referenced only by the caller
-	 * that isolated the folio, the page cache and optional filesystem
-	 * private data at folio->private.
-	 */
-	return folio_ref_count(folio) - folio_test_private(folio) ==
-		1 + folio_nr_pages(folio);
-}
-
 /*
  * We detected a synchronous write error writing a folio out.  Probably
  * -ENOSPC.  We need to propagate that into the address_space for a subsequent
@@ -696,8 +685,11 @@ static pageout_t pageout(struct folio *folio, struct address_space *mapping,
 	 * block, for some throttling. This happens by accident, because
 	 * swap_backing_dev_info is bust: it doesn't reflect the
 	 * congestion state of the swapdevs.  Easy to fix, if needed.
+	 *
+	 * A freeable shmem or swapcache folio is referenced only by the
+	 * caller that isolated the folio and the page cache.
 	 */
-	if (!is_page_cache_freeable(folio))
+	if (folio_ref_count(folio) != 1 + folio_nr_pages(folio))
 		return PAGE_KEEP;
 	if (!mapping) {
 		/*
-- 
2.43.7


