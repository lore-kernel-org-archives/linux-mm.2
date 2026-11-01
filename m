Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19AEE606A325
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 18:00:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C04A6B00EF; Sun,  1 Nov 2026 13:00:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 271316B05B1; Sun,  1 Nov 2026 13:00:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 187476B05B2; Sun,  1 Nov 2026 13:00:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC9686B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 13:00:30 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7DB681A0AF4
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:00:30 +0000 (UTC)
X-FDA: 85387315020.04.0B19C5B
Received: from mail.linx-info.com (mail.linx-info.com [114.247.232.78])
	by imf10.hostedemail.com (Postfix) with ESMTP id C49DFC000B
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:00:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of gkwang@linx-info.com designates 114.247.232.78 as permitted sender) smtp.mailfrom=gkwang@linx-info.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793556029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=sQF5AaRAqJJwPNtFv8d82MWcPLAgvRqmvTygJZxjDWE=;
	b=o2+PV8ZWEzlq/9P4a22RQCrfNG0qvIXq9iGgkZeTXw3++3s3H8Dook4DJQAzGaj2IHI5BK
	QwS+vCx4gaJrhSz0bHBCljD7G68HUXgojfBL3CxUCvCPvkI2lJdAaOWa565EENb/EAz8Ch
	n06SwL8r8jIJMhtIvHkjxsICnCXQE3k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gkwang@linx-info.com designates 114.247.232.78 as permitted sender) smtp.mailfrom=gkwang@linx-info.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793556029;
	b=hDuJRi6pbrxVi2Jl6I7zC2UFhbPtMBQhJ8T+mt78wvFJ9rsfW5ZcDbJ754dC134Q5lep4f
	mCD3weJl+LdgcvyCXNwhb8gJxIZ2MUHUNYRzwJMNsD3MuxsmzoTqpIZgi/vcFpoY70QNCQ
	RTfnm61+rw3wc3f/vGQ7QQttjcLFW1k=
Received: from localhost (localhost [127.0.0.1])
	by mail.linx-info.com (Postfix) with ESMTP id E2697321215;
	Mon,  2 Nov 2026 02:00:24 +0800 (CST)
Received: from mail.linx-info.com ([127.0.0.1])
	by localhost (mail.linx-info.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n6jflpuqa_Xy; Mon,  2 Nov 2026 02:00:24 +0800 (CST)
Received: from DiGouShu (unknown [172.31.255.20])
	by mail.linx-info.com (Postfix) with ESMTPSA id 8498432116A;
	Mon,  2 Nov 2026 02:00:24 +0800 (CST)
From: Wang Guangke <gkwang@linx-info.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wang Guangke <gkwang@linx-info.com>
Subject: [PATCH] mm/damon/stat: avoid overflow in estimated_memory_bandwidth calculation
Date: Mon,  2 Nov 2026 02:00:01 +0800
Message-ID: <20261101180001.167198-1-gkwang@linx-info.com>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C49DFC000B
X-Stat-Signature: f5md1r81hq614y8q5gy6qq1qio7deepd
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793556027-82549
X-HE-Meta: U2FsdGVkX1/j5f8fX2X6c8SiOjPd57n5UhA7edURwioKdwiq2UU+slE9IBhEq02UcjQoN4YCYfuT2m8yWxGxtNwmQNPayjhsG4S7XP1ODJERHUJQuRj0l/H16v+AK04RJsYWxgvKYhEjrE3W5U7F87ykJiKJPssh5n6jpqyS5F3+5MNZUSqubNwnQcXtZ0oVUPNqkDK4TtMnhhSOguaLqUsO4aXWDDvzCZTTjnodsIPIH4ryUebi/Nc7cN8pJNrtH5ECzq3NU+FkV5RzZJZzkm6k1bAf5pBkVbSEUqWU4u+YVq7Da6BfeIHlVRC8uAj2xgS4RNMQt65xfp/JgOKIEcJh/kN+f5BNzAPomedpgdmh+2oVVkjIAKxln6UWQ1FmMezX5iz9MY/1KGLaZIC8JMsUwbsD5KA2CazwBMS2j8ug7PWegv8ZOSIhkM750c07FTUEc9zMJWLiS+JZarzgxULIb6tZOEzfJUXKwOA0JC9+D7ZBUihKXsDuJ6x/nCe6Mmd9YOtwIZC6GVs0zHspYv5Sx0vPviEYEZtxv187P857lm6wu0oM2zH29VOnHeqUeUSj+QkAsA7clCNvu+ZYUBiv/IAb90HZI8A2pK4RwKiFpcpsSfJ3Qeh2NZytl/N7iy1Hfi1Nr0YjlYLyLv9os1pMMMQaApOLqjah1XDoxmr3K9GriIXooiXqvCykr0aI5J3omQOwFquvfYEqzdMFJwBvlmzUPda+UYd95xE9Ew9rATyg9DVAECNk45vA6nt5zsFBsm/s/NXhCA61qlLf7Z4/FiFO+fniHhdXrnqju8RjgVg9PgpzsIay8DSXJhiST9mWH2Q25ZgG548LrzZLMh4uCCnDv20z1uouHq6xqcMXTJvOJFUBbeYFYg9bjprdo3A0uyuQlEHjtp0KmMBkeAputcMn/4x0dZPsAqz+7l+zF3dOl6C28zClTeTSBKmNCaCvtjy2eEq2VqMx22U
 jzIlVR15
 MtaYUJmaOczW0hH3R3yZGF7ngTCNOoXa/yCuKNeRppqLfjnIWoiS27H5Iu2EtQJQOWnfJEGcRGKVeZnsKFcxPRkJAXl++651ezBN1aEGznE43NZfdh/eOVRO8aE8SE7u5hBqT1lnKIDECNjWo5Ud7orqkf7Dcr+GGcGWn3ZsyKSMc4jhgyQGMzSNWjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The calculation of estimated_memory_bandwidth computes
access_bytes * USEC_PER_MSEC * MSEC_PER_SEC / aggr_interval directly.
On 32-bit systems, the intermediate product
access_bytes * USEC_PER_MSEC * MSEC_PER_SEC may overflow before the
division is performed.

Fix it by splitting the division into quotient and remainder,
multiplying each part separately.

Fixes: fabdd1e911da ("mm/damon/stat: calculate and expose estimated
memory bandwidth")

Signed-off-by: Wang Guangke <gkwang@linx-info.com>
---
 mm/damon/stat.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index b05b68f73e10..7cfa3a8d6801 100644
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
 
@@ -55,15 +55,20 @@ static void damon_stat_set_estimated_memory_bandwidth(struct damon_ctx *c)
 {
 	struct damon_target *t;
 	struct damon_region *r;
-	unsigned long access_bytes = 0;
+	u64 access_bytes = 0;
+	u64 remainder, bytes_per_interval;
 
 	damon_for_each_target(t, c) {
 		damon_for_each_region(r, t)
-			access_bytes += (r->ar.end - r->ar.start) *
+			access_bytes += (u64)(r->ar.end - r->ar.start) *
 				r->nr_accesses;
 	}
-	estimated_memory_bandwidth = access_bytes * USEC_PER_MSEC *
-		MSEC_PER_SEC / c->attrs.aggr_interval;
+	bytes_per_interval = div64_u64_rem(access_bytes,
+			c->attrs.aggr_interval, &remainder);
+	estimated_memory_bandwidth =
+		bytes_per_interval * USEC_PER_MSEC * MSEC_PER_SEC +
+		div64_u64(remainder * USEC_PER_MSEC * MSEC_PER_SEC,
+				c->attrs.aggr_interval);
 }
 
 static int damon_stat_idletime(const struct damon_region *r)
-- 
2.47.3


