Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2867C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 08:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D26BC6B0088; Wed, 16 Sep 2026 04:35:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD7D16B008C; Wed, 16 Sep 2026 04:35:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC6516B00A1; Wed, 16 Sep 2026 04:35:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 881606B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:35:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BBDBEA5BC5
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:35:05 +0000 (UTC)
X-FDA: 85218965370.20.755C8CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 33A23A000C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:35:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cd2Z9Sxp;
	spf=pass (imf15.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789547704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Y8u9M/CPrZ8uUGb5gcQd+lDUMbsBuT9RIoPai58SWkI=;
	b=NcmynZJ0L5VjHuCJ7Qx7daHDctZ8hj/T3B6muMUHkGtDhcCSykCg4FlShzQ3XU74g+7p6a
	BMz+Mkm5JMSJH2598+Z72G8kRZPGVOJJ2XQSRDHRU4dETGfQUW6NxKQ2uBQbyPiP88uZuT
	hiHDefTlyuIncCmnX0k1BvUg+eA+QvE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cd2Z9Sxp;
	spf=pass (imf15.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789547704;
	b=eJvXxu/yF3m7Kry/IhEIgolSwy2FoBsFyGMlm3QX86MzrdPRiRgs4X96r2OQTfDoNx8DZL
	N9VImSp3AOHFqVT5hp8imZ8k8zKtdotnMdW/4jOTJh3tOnGM/qkmsuN6XykFOVvLwFmwXb
	yJsp2xXfc0knNDXl/7oyxE6RJxi6kxA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7119F43BD1;
	Wed, 16 Sep 2026 08:35:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E0B1F000FF;
	Wed, 16 Sep 2026 08:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789547703;
	bh=Y8u9M/CPrZ8uUGb5gcQd+lDUMbsBuT9RIoPai58SWkI=;
	h=From:To:Cc:Subject:Date;
	b=cd2Z9SxpnkTdH1y1FcHDR85THhmLg1DVK79MLRBdRCJ7jrGFGuHz3EOm+1lgjoxQs
	 P99byAnWaXD9p8xXn89E3AzOKhuN5gv6rX/ijcdxo1mvHXXstI97IPXci9EHoIty0A
	 isqHt8/ClvZCSfl6A5yvhD7YHpgMN55ji+BD5O9eebKd2KXYy5tu/NWH7xhcqkVbdb
	 y18ExV8YCpBN8+4yS+awIntit5R05/OZJz0DxEkozrbpGB0mQjWG/aaXiTabpqut/R
	 R8pMJ2qPPM1ZU0RPNQKllljAnYCy/i8aM2jnZF38cEzu4FpqLcx/PmhYWVHRLJulV0
	 ZZf+8RpJDObzA==
From: Arnd Bergmann <arnd@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Arnd Bergmann <arnd@arndb.de>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ridong Chen <chenridong@xiaomi.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/vmscan: avoid false-positive -Wuninitialized warning, again
Date: Wed, 16 Sep 2026 10:34:46 +0200
Message-ID: <20260916083456.4136132-1-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 33A23A000C
X-Stat-Signature: ocnbk7smckn1c9fe1733ixuuhb8jjq9x
X-Rspam-User: 
X-HE-Tag: 1789547704-752993
X-HE-Meta: U2FsdGVkX1+FgJM1T9EAQjj2pGJGB4K/RcW1nLjDuyQJW+oGrkGzpy6QLXFUU+HM8KwdYgmKQL6cdaLXWxdR76PYN2L5s9F5/M/+W3vl8EagjTiNbggYwY3Un6feifGX7kGOmAUZUDW6fIRFzOivOGWvMGqNXWjq3lFWOEZmFM8T8N0ul0AHIUU9JcnD6iOu5tLm4gt54lijluAsTM8jlSgXketyncjAh7hW8uuZsudkrmKld3uOTZadt6B4+ZkwiYC3r0hk1Fmg1yJp2+fpk8/pZil9gEnXZdTFy/gV5safiAzXQjZfspmoQew7XFjTDnag5tjwzwHxUGQTD5uXv/BHYSMvuX7OzX0aIl0Qr7wuct6/wzMzIoUCgnpwRe3CftvHB3y8OkyOIyxlvk0qNwMG1543cE1lmp5Y4egnrhhm4ETwLgGqq1zVcpqmaUwiMNz+icM77MT5DEnnmMPscyekPZ2+/kd5AWwJiynKl39imbl4iXa4iILM23hnzs3/cx+qF+2XQPg/rdzhV3WLAt4lTR5lp8i2jDAuBzwaMch4L445LgQxqCw3Cxg8xoL4e4BwsfDK8g+mdjrVBLPI8z5NA1n5BMfyGDHKYYZcAuIDX8e/C8ub/n9tCaPwc+gLuUoyHIATHyyQTxyEZIh8sHKG2ZkoEwEXb89OXltUzwneO8AULcgcBNHtpVDPl46Fn9FdIeCTwyzB/9oBWKiWcDAT8aR3yntQI1zglJQ5f0BWC/PsxEqigN7Z7c3ft9iAH0P5uxeAWOR7vPpWcaeKt6sY+BT5005eZ8lDjnvyZEqds9pgt3H0dK5Y/UlplUr4IS4RmgnGHGraOiNsY6Sq3/YhmXwIv2GZXxF5lCni+33AvKSG1FBBn/71SH3J8Ojg6oMEvd5sq0/h7RjBzyPO/LlLBYkY636dVdbfTjoMqihoEx3zh/OYrZpK5lK114YkQ+6vM6Q3HmUEQryYhdC
 9rnt/ZVe
 BGhZSvHd36KNzGWLwiWI2cPtJbmDyJ+Lz9z7MTUH7TahFQoJzm7lHIPErZ0Fs6tWT/FloyXHi0V1vIjoTitYFkteofFMo1ddngMnAqaPTTICMSp4CP0B9kr7rc6Q6BZvCyATTncUAAWLXMCBbVfp78yTBZmVLCBj7hZDGN4nWRwV4ZgizpqWk3q3Fd8/YMtWABs3qD+kNaM30NyddeXDv1NmedYql+e6cNF+fq20+L5IbV7Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Arnd Bergmann <arnd@arndb.de>

I previously worked around a false-postive gcc-16 warning in the
get_tier_idx() function, by adding a fake initializer. This happens with
the -fsanitize=bounds sanitizer when the compiler creates a specialized
variant of isolate_folios():

In function 'get_tier_idx',
    inlined from 'isolate_folios.constprop' at mm/vmscan.c:4982:9:
mm/vmscan.c:4934:9: error: 'sp.refaulted' is used uninitialized [-Werror=uninitialized]
 4934 |         read_ctrl_pos(lruvec, type, LRU_TIER_MIN, LRU_TIER_MIN, 2, &sp);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mm/vmscan.c: In function 'isolate_folios.constprop':
mm/vmscan.c:4946:25: note: 'sp.refaulted' was declared here
 4946 |         struct ctrl_pos sp, pv = {};
      |                         ^~

Adding another "= {}" would solve the problem as well, but to prevent
this from happening again after the next code refactoring, try instead to
prevent this by forbidding interprocedural optimizations on this function.

Link: https://lore.kernel.org/all/20260213123902.3466040-1-arnd@kernel.org/
Fixes: 3de705a43a46 ("mm/vmscan: avoid false-positive -Wuninitialized warning")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 mm/vmscan.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 11387a0fbeeb..626d2fc78cc9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3274,8 +3274,10 @@ struct ctrl_pos {
 	int gain;
 };
 
-static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier_min,
-			  int tier_max, int gain, struct ctrl_pos *pos)
+/* __noipa works around  gcc-16 warning for uninitizled use of pos->refaulted */
+static __noipa void read_ctrl_pos(struct lruvec *lruvec, int type,
+				  int tier_min, int tier_max, int gain,
+				  struct ctrl_pos *pos)
 {
 	int i;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
@@ -4924,7 +4926,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 static int get_tier_idx(struct lruvec *lruvec, int type)
 {
 	int tier;
-	struct ctrl_pos sp, pv = {};
+	struct ctrl_pos sp, pv;
 
 	/*
 	 * To leave a margin for fluctuations, use a larger gain factor (2:3).
@@ -4943,7 +4945,7 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
 
 static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
 {
-	struct ctrl_pos sp, pv = {};
+	struct ctrl_pos sp, pv;
 
 	if (swappiness <= MIN_SWAPPINESS + 1)
 		return LRU_GEN_FILE;
-- 
2.53.0


