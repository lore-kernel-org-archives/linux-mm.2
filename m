Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E408A606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 22:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AJ6ML24A
Received: by kanga.kvack.org (Postfix)
	id F02A36B05B2; Fri, 27 Nov 2026 17:03:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB1F86B05B3; Fri, 27 Nov 2026 17:03:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC8396B05B4; Fri, 27 Nov 2026 17:03:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6773A6B05B2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:03:05 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F33CB404FD
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:03:04 +0000 (UTC)
X-FDA: 85482275088.17.5EDAE05
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3FE85A0012
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:03:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AJ6ML24A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795816983;
	b=aGVuqQZq7dQ2TGRR1iM6kWgGnLXOiZy6ZAGG86PSny4hriaQBu8yHOcShd158ZmX9/AFxO
	KZ6VYGRVsPh/Os2l+5lDPDmrbgy375pJcnknPbFL2ICCYtRpo4UjDnaj7XaVKOwG0gGp8n
	wqeWxAwhwlTpnd+0FBsn85hu6Tm7XWI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795816983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BCJTZRnGztgdMYTCaqeVM+6f8MnMShmmaX94qOAQDo0=;
	b=IDFv4XFgZmC2/CP70gDaviQFGY6kYMaOG99zXKUUt5R4S5CWNqLW0wHT/V5qhQgEf4NuQj
	90d93RLSoOQyYp8irHRThxqsbvepuauT/WKwwBDawiWRWRKuvjck4yDAjGzryN+LzHzNzk
	DpDLws1/p9Nxxolzzg07+nExUdIkFog=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AJ6ML24A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD39260F9F;
	Fri, 27 Nov 2026 22:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D991F00893;
	Fri, 27 Nov 2026 22:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795816982;
	bh=BCJTZRnGztgdMYTCaqeVM+6f8MnMShmmaX94qOAQDo0=;
	h=From:To:Cc:Subject:Date;
	b=AJ6ML24AXM3tssIwQAlxrjOq/OucBgJ1gzTSGTrlZn5O314KKU8ge+M6xPypCRCfo
	 zqMh7DFjhA6kR6nbu87subKbRihAaYWzbSNZNs4gLe+AEUMA08/rOSgZ91B+kFfzon
	 FAn7SrkJkY+cBwSZDNMDiE6volrqK6C98OVaV0nUzyIumaFMtPC7Nz31/EkDNHjdBK
	 zgL4uipPTNI4YGBYkmt0rx6x4K5M/MQH2XuPGiKn8B57unqYXV/uT4WxFsTopLgAsB
	 uzFu6cCuRxy4cdXdg97NlAG0Ai2VbMLeO76v5uQD/r9b5mPI5JUgrP046Ygg1zfhiI
	 V/YZXqzBQTEig==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Lin Ruifeng <linruifeng4@huawei.com>
Subject: [RFC PATCH mm-hotfixes-unstable] mm/damon/core: let kdamond freezable
Date: Fri, 27 Nov 2026 14:02:53 -0800
Message-ID: <20261127220255.99924-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kzcknyhnmcg7y3ey87kughdbe83ai5d6
X-Rspamd-Queue-Id: 3FE85A0012
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795816983-351298
X-HE-Meta: U2FsdGVkX19XEQXcgrvXzRXAD72aM8sOf0tyVkZ4Zpeb2W1Ufm8QMHPXZe3Ev4nwQdQiL9NgmssctK1grI/DHJzZPjp1874rO3dqNfQY3d2QECG/+C1s/EI02fWlN/5539p77DGdijmiPy0VNrx/bG+JResDL8vTiwiF6JIRjRDRBwrhglt7JBL5ljW/M/I/ztFLkckOKW9IRt1LcSKkwrk6lRHu7TS7gP3LW9d/I61BLi1SQyXl9oMXDLtQfOIfkl7vFFCbP3Btu7f8m24VZL83HS/g5Ht1CDiKKVc0biaLdRf139UtZCFi2IDPNrWMu09a1hu17b4VvRf0d6rjV7UsCFO6qVipcJKRCHUwGoHJvTY8kPb9mlnOVOmzrBnsgUHJn5SeZC7ImwHUWiFJYe/j9XSr6FFEAnA1KFveawF74YvrV8D5TgdQDNwjAt3gn/GW+RLRlE2gSfgS6E54LfwMMmIZwKMaXXyoWYJ0uXZr2o4W4AakBfDkvcchVJyRjlfxaVp1OzbASBVlrDXLX8yFl+E+h5Da/vGDee5VYHZ397bZeK5Oqb17M+5/j7M770P9xknbmrX+nN/27tnXpnVULSPAvXc+pveil8iw9KHOarvhTI1Ao42a+QMLkVjDltXTkjwSnOAp/LqAtkR0X3dYVUMzyJtjNAwUYW0z6vlk30J1ktTOIY8SmTMTPGPJzrBopidBVAx7sMKwSMh8zqTO1tp18dVlFekpbF5zU6zzlUPqwKMfSwENRqJx2OPSwmdGwcjMDkT3edEcQ2/vTPB5NOKxPDHBRXiVXcC/bCGoOJky5eGvij+3/ZNfrWBgWN7q4gIh4zkJ32cpuLOHYNr7oZNA5WjbV/R96Xuu9SNCiSTLx/gJ1EBYNBqv67OhERdceXHMikCQVhhsr1mm7udtSXZSRzPFbBpnjyLkTLp31HLdlGpM4Dv8aM3MjJZ1N16lNQb8X8kkIMs9jEU
 dmYz5hXD
 Rk2KIC7kMH4SYK8xqhoqZo1fGCf6f5+EoeTGvRozbYSfAT/X/wIjbiREdI4kEPaQzCLJTcpuGIv7PGKIiRDOvlj0h9F0xftkHIUry1BxP59WHHKiIGdQ6tEVzJfF+jVdw5NYE3PbB/UvbXCXLBBitdM6xXuQk8AmcKnWVBFHbTRFtj80xvaQixzvXMAw/oEXUS4tG9lnth/ckhsd4ebBM+5n9XEDQQ3PG0ZqFu6RV9lVJ/HGhg0bbBkLpSO1wO6y4vrYdYEFaQtv8TgomG8YYd9w1ykmdV3WNd4kZPg8vEJda5J3uCOnxyUsg5NdwKUHc1H561BrIZg+qVJKP0+k9uk/C72xOj9sp24VczsMss6nozvn2IfXU9/63NieWuTORZ3A7+avNXLUVVjaDJtw5rPIcsyIUgLg9rUiqh+LsgAcPmVxOLNygRrXrx9SqwLBpFedWhoGDLJflfx/8RuV4av/na2xY9JI9iuwU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMON's worker threads, kdamonds, are not freezable.  If DAMOS is set,
it could migrate or reclaim pages while the hibernation image is being
copied.  It could corrupt the resulting image.  As a result the system
could run with the corrupted memory after resuming from hibernation.

Users could work around by stopping or pausing the kdamond before the
hibernation imaging is started.  But it is easy to forget.  Just make it
freezable.

The user impact is quite bad.  Nonetheless, the problem is only found by
the theory.  No real issue from such memory corruption is found and
reported so far.

This change was originally suggested [1] by Lin Ruifeng.

[1] https://lore.kernel.org/20260408080652.1745410-1-linruifeng4@huawei.com

Fixes: af122dd8f3c0 ("mm/damon/dbgfs: support DAMON-based Operation Schemes")
Cc: <stable@vger.kernel.org> # 5.16.x
Suggested-by: Lin Ruifeng <linruifeng4@huawei.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0e6b361f97ea..f421965d1f58 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -7,6 +7,7 @@
 
 #include <linux/damon.h>
 #include <linux/delay.h>
+#include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/memcontrol.h>
 #include <linux/mm.h>
@@ -3845,7 +3846,7 @@ static bool kdamond_need_stop(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
 
-	if (kthread_should_stop())
+	if (kthread_freezable_should_stop(NULL))
 		return true;
 
 	if (!ctx->ops.target_valid)
@@ -4056,6 +4057,7 @@ static int kdamond_fn(void *data)
 
 	sz_limit = damon_apply_min_nr_regions(ctx);
 
+	set_freezable();
 	while (!kdamond_need_stop(ctx)) {
 		/*
 		 * ctx->attrs and ctx->next_{aggregation,ops_update}_sis could

base-commit: daba53bdc1a54c453c2f4ced54a1cd52416c3f87
-- 
2.47.3

