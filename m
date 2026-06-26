Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 249F2CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 08:59:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7A456B00BA; Fri, 26 Jun 2026 04:59:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E52B96B00BC; Fri, 26 Jun 2026 04:59:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D424C6B00BD; Fri, 26 Jun 2026 04:59:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A87A76B00BA
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:59:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2209B403E9
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:59:57 +0000 (UTC)
X-FDA: 84921466434.25.FA1659E
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf24.hostedemail.com (Postfix) with ESMTP id 10D6F18000A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:59:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TWTPuoHN;
	spf=pass (imf24.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782464395;
	b=BMm9jkvj4SRsC7J+ti8E9y/MnnDweTx7vU7u2AwpkYLhKGELWBYKDRHpMShS4EV9dXLxMY
	7b5hqGwr5o1Sqc/l8VR5wq1GxdyWtqugVAfKap+1Cm4MAZa8inBmKB1PHuiqIVY/McaYmX
	DuEOlW05cveasFgAjIykofhZ7f8klJ4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782464395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o/AKESdZLDH+aWzHoqnqaRdmen2KGUt9vPtou3JWZ00=;
	b=I7P+jvA4CtNeVHTFCLOTt5pmSepI6t3r4nhSvOTlEzaVTWC4tMd+lNYNxxukR95SlOBOBx
	dUX4yE4LL4yOJIGLEDOQWfeaSW3L/DGeWqulvJgx6mForwXsUX1+JV6k0GPvBUWb/CY//V
	Nyby3YEbKPYAw4+MJf2XmENnmw5fcpk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TWTPuoHN;
	spf=pass (imf24.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782464393;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o/AKESdZLDH+aWzHoqnqaRdmen2KGUt9vPtou3JWZ00=;
	b=TWTPuoHNMpUrutD9Nj5/mAVZStDcfAmZBTehgtlcu4Pw1KjmDMv6X8cIENgSdluXtb2DiO
	rDcUEbC/8L/P7nXqzUCERKrX1CMhLuZ9eCdUtfE2U6eDRoiN4Arr85sfdy+2e/dFL205//
	v6ZGeIiQGRf1NGv6mLwnvxX3zOCHK3w=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: damon@lists.linux.dev
Cc: jiayuan.chen@shopee.com,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shu Anzai <shu17az@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] mm/damon/core: split a fraction of regions when nr_regions exceeds max/2
Date: Fri, 26 Jun 2026 16:58:37 +0800
Message-ID: <20260626085851.70754-2-jiayuan.chen@linux.dev>
In-Reply-To: <20260626085851.70754-1-jiayuan.chen@linux.dev>
References: <20260626085851.70754-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 9eeppy3nbza9uz9tbj8aecyqdaz3nus6
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 10D6F18000A
X-HE-Tag: 1782464394-678794
X-HE-Meta: U2FsdGVkX18SHhAaE3rvD4uSDgkRx4rKZpf5r5v82mu1NQL9RYBQ0bxcJ0meVMzsJtleco/qWrTrxaJESVZTVmNN2kRc9uOzz2+r5ppXa1k6aGlAPuBJNoOAxO8DCpy6RRsgKp3KyLDmBtVIzFXffh/J0lyhWxZlGpmWAoxmbolVvuEnSsxvdhVlFWMFUiJS5YuT1uoUxfcBs6CzOA1GbEXQpqYPd7iIoHQXyX/D/M4Silub5OMYuT6nSyzKvKn4KcuWL97gjfw3zDKlcjjFxw2Zsg9Qx0HigzK2BBqU5mqgZbUqCuhIUbGSxgEL1cATf+7go0G0gJJg0Gzp/SvrYW0Au7zmHavcl27cv3Vrwhy/t4nvD8j7gA2OXqjL3b/yNWk4f5xD05zjzySm70cv78bWPYqCBtve2kReF6jDjx92wCO83YxGsGhu0jx9F2VZ2g+QhGgg34Dl/E6kIOooatbuQBKZNW/7sFILl0lFwd8Hr/J2PzTFmgRQ7m3NWyrgPRwJoVkhI/2/+4MrErWYMAPQfKqQVbEVmlX9lx1RKCrKEvEaDXAn25R3kRE7UrkcaorKHYYaHj7JBTDacruZETd7XR9gQO0S7i739JZ51lDji0goCSe3fpRiGQMQUd4aBw0XaAK2EgMudPVetL0uFJ6ShwOozUL9G33SnvHTNvV97I/o5/b7Ri1iauanbVrGBBHn7vjT5hi923Jv4czmXnX1jZ1YM3hIUjQ6qv0U754zNOf5baltWofgQ7gjHpqMeLnfQztumiXLu2X10V6Fuhv7U2GQ3bBxzhEXPpllqEj8LZTF+adFQc4MYPZkuI/Xw9uvaErn1+EKf2sy/U3zb5GIQvqCbcdL3yxtlGbhlFdj2yAHmv6P2CxyyPdnCuwlQd4lvyZcfhPrZJW0wk0HpNnAbDWc7XNWzG///ElgBv5Pg2doRPtd2+BHxQ1Q550XksbTRofgExCqRT5LQpf
 o7IIqMtp
 RrWBKZ9tiGt6bGGm0KrnpdN+Cs7f0+7vP8t4W5ia54+vFmMZ/owHzSOMkL+xZ4JteUT/s9XFic0i7MB58c4e89JwVz2S2DJM0a+alAXGIeg3k6dwKHF3MP32KeXwJMJo4gkPG4M9dtZRqb0sIetqQ5Ery0a/3hfgkdnftQH4JlBrBkQBy02kLJhRUuy27wCnq/xa0b9prl/Lil6bgL+RoASbORMzBrJqPHo7WAcVrCiDhw4YA68L8mBruXBURB/PalwXZfsS2oip1qhYn2NKtwL4r1sYxqBMn0c4HU8iCO2hnL8t8nyI8AZ43qxO9xdkw1ySDsN0hjJTeUj3vYzxuKMMZ5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

kdamond_split_regions() returns early when nr_regions is above
max_nr_regions / 2, leaving internal access variation inside a large
region undetected.

Such a layout is common with damon-paddr on hugepage workloads or
damon-vaddr on processes with a large anonymous mmap.

For example, with max_nr_regions == 1500, a target may end up with
799 small alternating-temperature regions plus one large region that
absorbed a uniformly-accessed range during an earlier merge:

H:hot
C:cold

      r1     r2     r3                 r800
    HHHHHH|CCCCCC|HHHHHH|...|HHHHHH..........................|

    nr_regions = 800  >  max_nr_regions / 2 = 750

If a cold subarea later emerges inside r800:

      r1     r2     r3                 r800
    HHHHHH|CCCCCC|HHHHHH|...|HHHHHH........CCCCCC.............|

The small regions cannot merge with each other (different access
counts), so the budget stays full.  r800 cannot be split because
nr_regions > max_nr_regions / 2 causes an early return.  The cold
subarea is never discovered.

When nr_regions is above max_nr_regions / 2 but still under the
maximum, split only a fraction of the regions instead of returning.
One region in every 'max_nr_regions / budget' regions is split, where
budget is the remaining room (max_nr_regions - nr_regions), starting
from a rotating offset so different regions get picked over time.  The
fraction shrinks as the budget shrinks, so the region count keeps
refining while approaching max_nr_regions smoothly rather than
overshooting it.  An unnecessary split is reverted by the next
kdamond_merge_regions().

Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 mm/damon/core.c | 49 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 44 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index d0cbfb6d1e4c..26a2cdb935f5 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3712,6 +3712,37 @@ static void damon_split_regions_of(struct damon_ctx *ctx,
 	}
 }
 
+/* Split one in every @split_step regions into two, from a rotating offset */
+static void damon_split_some_regions(struct damon_ctx *ctx,
+				     unsigned long split_step)
+{
+	static unsigned long rotation;
+	struct damon_target *t;
+	struct damon_region *r, *next;
+	unsigned long offset = rotation++ % split_step;
+	unsigned long idx = 0;
+
+	damon_for_each_target(t, ctx) {
+		damon_for_each_region_safe(r, next, t) {
+			unsigned long sz_region, sz_sub;
+
+			if (idx++ % split_step != offset)
+				continue;
+			sz_region = damon_sz_region(r);
+			if (sz_region < 2 * ctx->min_region_sz)
+				continue;
+
+			sz_sub = ALIGN_DOWN(damon_rand(ctx, 1, 10) *
+					sz_region / 10, ctx->min_region_sz);
+			/* Do not allow blank region */
+			if (sz_sub == 0 || sz_sub >= sz_region)
+				continue;
+
+			damon_split_region_at(t, r, sz_sub);
+		}
+	}
+}
+
 /*
  * Split every target region into randomly-sized small regions
  *
@@ -3725,25 +3756,33 @@ static void damon_split_regions_of(struct damon_ctx *ctx,
 static void kdamond_split_regions(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
-	unsigned int nr_regions = 0;
-	static unsigned int last_nr_regions;
+	unsigned long nr_regions = 0;
+	unsigned long max_nr_regions = ctx->attrs.max_nr_regions;
+	static unsigned long last_nr_regions;
 	int nr_subregions = 2;
 
 	damon_for_each_target(t, ctx)
 		nr_regions += damon_nr_regions(t);
 
-	if (nr_regions > ctx->attrs.max_nr_regions / 2)
-		return;
+	if (nr_regions >= max_nr_regions)
+		goto done;
+
+	if (nr_regions > max_nr_regions / 2) {
+		damon_split_some_regions(ctx,
+			max_nr_regions / (max_nr_regions - nr_regions));
+		goto done;
+	}
 
 	/* Maybe the middle of the region has different access frequency */
 	if (last_nr_regions == nr_regions &&
-			nr_regions < ctx->attrs.max_nr_regions / 3)
+			nr_regions < max_nr_regions / 3)
 		nr_subregions = 3;
 
 	damon_for_each_target(t, ctx)
 		damon_split_regions_of(ctx, t, nr_subregions,
 				       ctx->min_region_sz);
 
+done:
 	last_nr_regions = nr_regions;
 }
 
-- 
2.43.0


