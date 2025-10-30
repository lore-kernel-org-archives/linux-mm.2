Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FE05CCF9EE
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 02:07:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C85F08E01B4; Wed, 29 Oct 2025 22:07:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C416F8E01B2; Wed, 29 Oct 2025 22:07:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C5A08E01B4; Wed, 29 Oct 2025 22:07:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7F7D18E01B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 22:07:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2095612AF0C
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 02:07:22 +0000 (UTC)
X-FDA: 84053143524.06.B071ADA
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf26.hostedemail.com (Postfix) with ESMTP id 93CA6140006
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 02:07:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=l+XDWrmA;
	spf=pass (imf26.hostedemail.com: domain of yanquanmin1@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761790040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fr+3CDNz64iBwWCR8OXL6QiRv6BkJHD6nWLy2Y5mJRg=;
	b=kMe1Ow3+J6g+RVQpHKFA2HlYOMOv8eErlbXUb4+54LnqE7MO2DqpqxpVGTOu+Nn0qRYaQm
	MDftZJUHPyb89orO5mYRYyxKJId5WuF+/7fT+qzqI48omC0sIWtJk3cfOZ90mqo/kUFS+r
	XFDS9EI7ubMiTXO8UgJ3IscotNAcfpI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=l+XDWrmA;
	spf=pass (imf26.hostedemail.com: domain of yanquanmin1@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761790040; a=rsa-sha256;
	cv=none;
	b=hSivbXKq7A0NVV2kobfoq2wx+lVbIJrWmROMBcmDrsp9IcFAj7n4+pnY9WeYpeohY5gC6C
	IR/z18RMSEJLwVXS/U3gUf18tQHR672fg8ngXYkf+Zd6/yrJM02diVRTta8J6jQVc5y/09
	pcqms2hhswK+5CPW5vTwZ9phYgicjQw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Fr+3CDNz64iBwWCR8OXL6QiRv6BkJHD6nWLy2Y5mJRg=;
	b=l+XDWrmA89J7sFLQjzNeZ5TUea1iYtJx18bPrE4Pn5sL5xmly5KhYipxZKWVsTS2f/ITQU7l2
	G3K/K2+vhp326P7vtkK2klRq4NxaIQ0Uilnfw+rz844UsH7YAwMqDFuX19fQrUf4J8cfoJ+AK/O
	pmL6gmdQODnoSeH4QJomBc4=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4cxnXz4xzmzLlSH;
	Thu, 30 Oct 2025 10:06:43 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 02D901A016C;
	Thu, 30 Oct 2025 10:07:13 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 30 Oct
 2025 10:07:12 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH v2 1/2] mm/damon/stat: change last_refresh_jiffies to a global variable
Date: Thu, 30 Oct 2025 10:07:45 +0800
Message-ID: <20251030020746.967174-2-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251030020746.967174-1-yanquanmin1@huawei.com>
References: <20251030020746.967174-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Stat-Signature: hcwwd8951juqa3i8bxkcf4wast6efa15
X-Rspamd-Queue-Id: 93CA6140006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761790039-346071
X-HE-Meta: U2FsdGVkX18usRBxY2sOgKprJYuGw/IqH2zYPOh/QYVamJgId9Iir6QlO9oLEDNl5/zCOgjRLmoFYVnD82eMpUlCgV+x8bdNIMewsOzzfHC7cdwLjkDPx5+/HfR2mx1vlchH77kq/zz4NDmedlkN0ttGdQeAuJCxbTQo2JGFmHDj7vsfrwevJTvK1rT6iHf2SEOvjHz3tUcsxVLb90Lw1+WsNs2q2s8qDx0B5S8PLIGi/KfhaAoI6Wyz3KWtaHIMtTkgXHcR6+ixJvy8+UvTqvro/zeDS4KD+BmcbYSklCuzb4bnmvpvRHotWRr2ROq9poRjEmst/1taAsJfcAXyTkegawvvwUrYMjPtmMOayv33pLs7BXTxX9a9eHctnGelXzuR7wgR93KkNIUNa7VFtjmyhebpylyfGM1B0CF7Vc7mNCO8WEiCIvj/U/bzQCP3IGX6Rl9P/U6ZxybmBP5bzpRuKpoUPzk84EWRSdxG1ZWT4REah8htosqGOmpihBjrQOjyuNfbAeTiieec4Xi7+KNJ++guD+N/D9y/hd1zy2HKrIxddAydUW3S5Ivz/yFgCA9PbsaLnYPRSJY5PMHTbs1wwoUBOV9NBJ8g9e/xBfowbJ0FGaDXj3hO7lM9rtrPYrauINXviRrFhtuqBtfx8vdPUhdpP3u1bfC1BdznbTJkE1HshhWYmesnT07P46dXLelflaSqtN90Grzmmjx96HOgK+MJdcvpLa3daYts0wiSJO9yvrejJZFqrud/ESp5/1u2+FJMGM8UY7pI/qo0it4jq1pxHYdJd8hoVoFqOmrW1jz+wpYtTLOzYgqJHoo4wUGy9Lc49/vPfoUsw9ymBsNITTPKiVYkTWfHnWh2vGKPhve+Z0qYI3xbhcJgQ7KD4TMmUKcVQf/oZEI/ts0psphd8QeAbKvZiMJP3BNH7sTWYBBpihLljap2q1R+WaWE9e1XOpPUvQLxv5PymVf
 b2nMQZfd
 q16RDcXGjxWapQirL87HpG9MAq7kco66qZi05W00GMn2MIfxJYufRb6BeR8nmt2/JpKM9hOE+KQklRinU8acF6+wrY2q0/+vh84bmkkzBUyw6cK1Bd+FrKDvZMw+tVSMwajNNIYCqMGigsqVt0eO6Z5ea++xgzve81UxxTKEsTLpgflr1KbjXwM7uK3YbwyplV7PaFyhSX3IBN7/rWQLuv3LIqDYoWVjCgzy0E92ta8RGw11Xc7br/Bix9MYY5uCkLK498I/CnHwYIIadKFbvK7luHnnAlOZnVjpGiYzFoZqBzipZmaSu5eyqpOB6QUnIlgYWtB0BTKHpY3BGMxXBb431EQSiksMBPWAPHR5JywbS+kjzPGo+1QeX0WDd/c3D1WqWKd7bM09w+C7DvYVqLJ6bW7yO93KXRBEQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In DAMON_STAT's damon_stat_damon_call_fn(), time_before_eq() is used to
avoid unnecessarily frequent stat update.

On 32-bit systems, the kernel initializes jiffies to "-5 minutes" to make
jiffies wrap bugs appear earlier. However, this causes time_before_eq()
in DAMON_STAT to unexpectedly return true during the first 5 minutes
after boot on 32-bit systems (see [1] for more explanation, which fixes
another jiffies-related issue before). As a result, DAMON_STAT does not
update any monitoring results during that period, which becomes more
confusing when DAMON_STAT_ENABLED_DEFAULT is enabled.

There is also an issue unrelated to the system’s word size[2]: if the
user stops DAMON_STAT just after last_refresh_jiffies is updated and
restarts it after 5 seconds or a longer delay, last_refresh_jiffies will
retain an older value, causing time_before_eq() to return false and the
update to happen earlier than expected.

Fix these issues by making last_refresh_jiffies a global variable and
initializing it each time DAMON_STAT is started.

[1] https://lkml.kernel.org/r/20250822025057.1740854-1-ekffu200098@gmail.com
[2] https://lore.kernel.org/all/20251028143250.50144-1-sj@kernel.org/

Fixes: fabdd1e911da ("mm/damon/stat: calculate and expose estimated memory bandwidth")
Suggested-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
---
 mm/damon/stat.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index 6c4503d2aee3..ed8e3629d31a 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -46,6 +46,8 @@ MODULE_PARM_DESC(aggr_interval_us,
 
 static struct damon_ctx *damon_stat_context;
 
+static unsigned long damon_stat_last_refresh_jiffies;
+
 static void damon_stat_set_estimated_memory_bandwidth(struct damon_ctx *c)
 {
 	struct damon_target *t;
@@ -130,13 +132,12 @@ static void damon_stat_set_idletime_percentiles(struct damon_ctx *c)
 static int damon_stat_damon_call_fn(void *data)
 {
 	struct damon_ctx *c = data;
-	static unsigned long last_refresh_jiffies;
 
 	/* avoid unnecessarily frequent stat update */
-	if (time_before_eq(jiffies, last_refresh_jiffies +
+	if (time_before_eq(jiffies, damon_stat_last_refresh_jiffies +
 				msecs_to_jiffies(5 * MSEC_PER_SEC)))
 		return 0;
-	last_refresh_jiffies = jiffies;
+	damon_stat_last_refresh_jiffies = jiffies;
 
 	aggr_interval_us = c->attrs.aggr_interval;
 	damon_stat_set_estimated_memory_bandwidth(c);
@@ -211,6 +212,8 @@ static int damon_stat_start(void)
 	err = damon_start(&damon_stat_context, 1, true);
 	if (err)
 		return err;
+
+	damon_stat_last_refresh_jiffies = jiffies;
 	call_control.data = damon_stat_context;
 	return damon_call(damon_stat_context, &call_control);
 }
-- 
2.43.0


