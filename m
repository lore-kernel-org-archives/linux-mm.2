Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F9FF606A327
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 03:41:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 108616B05B1; Mon,  2 Nov 2026 22:41:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BC036B05B3; Mon,  2 Nov 2026 22:41:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F137A6B05B4; Mon,  2 Nov 2026 22:41:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CC5626B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:41:04 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4336DA0301
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:40:59 +0000 (UTC)
X-FDA: 85392406638.29.44C258C
Received: from mail.linx-info.com (mail.linx-info.com [114.247.232.78])
	by imf22.hostedemail.com (Postfix) with ESMTP id CEDE6C0003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:40:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of gkwang@linx-info.com designates 114.247.232.78 as permitted sender) smtp.mailfrom=gkwang@linx-info.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793677257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=VSTrktgGZ8s9uEUboO9uuASria0PEjkILQvjOya3gqE=;
	b=pxENEkg3UP8cTAQc8q/HIQA9rO7dB/pBAi3FuvnLFZCoD7MTH7tb9Acl9AoPLPJVSmUwiz
	GH6EOYqyigpEvIXJDXgDWHrM/dWc7CoDUMnYT0SzbMjPNIySAneS94g1F+0rgwpPP8kzM1
	OTGvORkVH3/BWxS1hZ8lWy2q3aOFRZM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793677257;
	b=sa/CD7aHoOWpnRkfLiUfT5vtiUgN687/68oshNOiidJMGw4TJ34OcdJFQnJEq1yqUSFkH3
	dkBp7i8iA6cbGgSLXvCQ0OZf9fp411Bqc9/5wiMimvkdV7WLuQW68gN9ezktPm1LfBMAxx
	PP9vPY1hoAsTihd+FWQKPC9rZyDUA50=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gkwang@linx-info.com designates 114.247.232.78 as permitted sender) smtp.mailfrom=gkwang@linx-info.com
Received: from localhost (localhost [127.0.0.1])
	by mail.linx-info.com (Postfix) with ESMTP id 761E53211C5;
	Tue,  3 Nov 2026 11:40:51 +0800 (CST)
Received: from mail.linx-info.com ([127.0.0.1])
	by localhost (mail.linx-info.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0X34993ex3hU; Tue,  3 Nov 2026 11:40:51 +0800 (CST)
Received: from localhost.localdomain (unknown [172.22.21.200])
	by mail.linx-info.com (Postfix) with ESMTPSA id 5DBB232119D;
	Tue,  3 Nov 2026 11:40:51 +0800 (CST)
From: Wang Guangke <gkwang@linx-info.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wang Guangke <gkwang@linx-info.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/damon/stat: avoid overflow in estimated_memory_bandwidth calculation
Date: Tue,  3 Nov 2026 11:40:34 +0800
Message-ID: <20261103034034.7978-1-gkwang@linx-info.com>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: boornhmc6szef8o8japi9xuhqxbuj7ci
X-Rspamd-Queue-Id: CEDE6C0003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793677256-901074
X-HE-Meta: U2FsdGVkX19+DfRDJopYhCdMAPCOG3o9o9DIFuxcn8HuBo2kU8cLT04yriH3wofmWWXf7d8adRkgv8DNiw/RTDXjt1DRxcPzEllf+2OkownYoEMF1wP6v2ixCQXZRr6bpDrdob2KfvA4FHQZukWZgUmI6AUT48XXuywh7iCJbzxt59Ix/YCaXt+MjQGtaW7+45Imcrbne9LxhIyo8e/5Vf+JuA/6tRaGyaIlrcFjcZcsoK0Q/oFBdLHGXyB7Twa4/1+R51Pu/pkqx+PvnJZ7NmUIv9CU3wUfNhDvEmE3L4AO1qxKMDRc1r05ejPaADrAyOOXdBljrOG94FhWrX3gbNgaxCBxNpTgSEUK7uSBD1YazYiNHN7rM3HpVU6TqALMSPDxal7JhRfHQCWG9gu3WFmivVGfmhqhGg3eN5OFgNX3KfGoKrfOeDMFpYK3bow1NKjNjn/IAB1lnmSLG5AttBnN4Ur++RtOn0oyw4usmCS37z6IJ/C5IiPvAdnbLYLw6c2oJRZdLyJExSc1AG+hn3poUI67EvG4lSlrSjzANUwS5v2cCxzlBd2mZXukO+OHD9TVXtNCZIaYVuRx/tqJg3VfJjhDuCYfv93aEh46PhmNWxwb2YIjZe/YV+r2fSogug44puxWSZ+84dW4jdtOkh/MuMRhvUFgMKara5E48KwUrzgFMWiy0TY3/iQ8ii86WgZPheg0sSYwZ75L1RNuzL9aUg/7rJcQvU+YMxizzf0NAcRcIuok4c8Nq2S0MLgl8eYd23K9m9PYUBKCbBK8/7oOVudawG9nvqOmDYsaMlZSksHTPLgIiBGHFgeiz6SrAH1TJg45WyPNjYqk0hvC8L+A66WSQ9QhvNFeB/bVPLDDxajtIfahD66Gb3sAml225xUiw7abFecKxo/8hiyeqJP1c25aAPeZemPnctUn91FdScKLFx97f2gPaXVJKiiuY+gtDSR0iE9IhTg9Mdj
 VP2LT1iV
 x0yNYec11qC1ObYL4x49rWdZOICkb+a8EMhrTEfWpwodWca+iKz62z9T4k1Fv0GLpxGAAXRULVPVnG+hyP2Y8/oQYN3d8wSJ16X7L3c2/35+igdeDT4O49Ax12o/ykUUkkOjX9vdjF6oMxhx5HgeAZ3F0M5QSsZRZlLLCh+DlMAN0xijJD8m8gyyZ1AaBSUicRwH+qjYlBTr1YKA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

estimated_memory_bandwidth is calculated by access_bytes *
USEC_PER_MSEC * MSEC_PER_SEC (= USEC_PER_SEC) / aggr_interval,
and users read it via
/sys/module/damon_stat/parameters/estimated_memory_bandwidth.

On 32-bit systems, access_bytes * USEC_PER_SEC overflows unsigned
long once access_bytes exceeds about 4294 (U32_MAX / USEC_PER_SEC),
so users get a wrong value.

Fix it by doing the calculation in 64-bit and splitting the division
into quotient and remainder.

The issue was reproduced on a 32-bit system (qemu-system-i386): the
parameter estimated_memory_bandwidth reported 362 instead of the
expected 1926150; with the fix, the value matches the expectation.

Fixes: fabdd1e911da ("mm/damon/stat: calculate and expose estimated memory bandwidth")
Cc: <stable@vger.kernel.org>
Signed-off-by: Wang Guangke <gkwang@linx-info.com>
---
Changes in v2:
- v1: https://lore.kernel.org/all/20261101180001.167198-1-gkwang@linx-info.com
- Clarify the issue and its impact on users.
- Add Cc: stable@.
- Rename variable bytes_per_interval to bytes_per_us.
- Use USEC_PER_SEC instead of 'USEC_PER_MSEC * MSEC_PER_SEC'.
---
 mm/damon/stat.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index b05b68f73e10..e44f5bf3645c 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -32,8 +32,8 @@ static bool enabled __read_mostly = IS_ENABLED(
 module_param_cb(enabled, &enabled_param_ops, NULL, 0600);
 MODULE_PARM_DESC(enabled, "Enable of disable DAMON_STAT");
 
-static unsigned long estimated_memory_bandwidth __read_mostly;
-module_param(estimated_memory_bandwidth, ulong, 0400);
+static u64 estimated_memory_bandwidth __read_mostly;
+module_param(estimated_memory_bandwidth, ullong, 0400);
 MODULE_PARM_DESC(estimated_memory_bandwidth,
 		"Estimated memory bandwidth usage in bytes per second");
 
@@ -55,15 +55,18 @@ static void damon_stat_set_estimated_memory_bandwidth(struct damon_ctx *c)
 {
 	struct damon_target *t;
 	struct damon_region *r;
-	unsigned long access_bytes = 0;
+	u64 access_bytes = 0;
+	u64 remainder, bytes_per_us;
 
 	damon_for_each_target(t, c) {
 		damon_for_each_region(r, t)
-			access_bytes += (r->ar.end - r->ar.start) *
+			access_bytes += (u64)(r->ar.end - r->ar.start) *
 				r->nr_accesses;
 	}
-	estimated_memory_bandwidth = access_bytes * USEC_PER_MSEC *
-		MSEC_PER_SEC / c->attrs.aggr_interval;
+	bytes_per_us = div64_u64_rem(access_bytes,
+			c->attrs.aggr_interval, &remainder);
+	estimated_memory_bandwidth = bytes_per_us * USEC_PER_SEC +
+		div64_u64(remainder * USEC_PER_SEC, c->attrs.aggr_interval);
 }
 
 static int damon_stat_idletime(const struct damon_region *r)
-- 
2.47.3


