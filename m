Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61958CD4F25
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:37:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF5906B0096; Tue, 12 May 2026 10:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2176B009D; Tue, 12 May 2026 10:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8B156B009F; Tue, 12 May 2026 10:37:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 891DF6B0098
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:02 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4BA251204BB
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:02 +0000 (UTC)
X-FDA: 84759019884.29.10295F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8BD2CA0009
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AvCucv5B;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/RmMzGsPEN+DDqEiu+I0131qTGpfnpemsypj0s7iC5c=;
	b=V19hEd1JnVfbjkJJDp/uM1h/SoD5A0pJQYDAISfKYeaHJvZR1wdvdkzUfWDqbYsL7Cf+Vc
	ql1am479Xr8XwjHUf3UJzh6wS1H8ayFAc86yGBQ6uLXirvN3K1XofLzmug/NJpxIIBpLGh
	MT9zvAUanLjb8FNVm48bjlh/EzBUcAU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AvCucv5B;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596620; a=rsa-sha256;
	cv=none;
	b=zX92qrs2XiSGvJrOwN5heqfkbEIPLE3sDoTETNMUDJP5IzR4gc0n164MdnsuKBr12NZqNS
	Io/fXTtmIVdX5eru+b80qo2RuFtxY7IwEGA0+us1nrcviDrw6knC9g1jPViWpK5b3bJLfI
	ZqXC0gVlqKaoaau6hs/2lh/pFJ/wn/M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B06F144AA6;
	Tue, 12 May 2026 14:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0DBC2BCB0;
	Tue, 12 May 2026 14:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596619;
	bh=sqTfJo5eyZfIgPieldGgPDsesotOxkPfGODr6Semhvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AvCucv5BnfwStN8bnkbrx8qW6MAFLmXHFk8Lz4P3dUPAmmvG6cRLR9twBgi22e7yy
	 blKIN3ZS2qREWyurMfrguoqHa1cu14dobPyOvvrJO4EWFBX1pkKDtxlH7ikwZ9IKD8
	 ahd6Us4+KjL3By0ez9gIEQjIosh/TKnxb1uR8Gm6NZ7MTxTvxpdzjMa3nCBabFfTsT
	 ivmC5sIKc1VmdxpRIvNwzVZiwGKYmrWc5pAyEzCbSH8nN0dxzKrtmi5IB6l+a6wizo
	 skSwbszm/+iJqfOxusaJvqvtKi/1MrO+XRrR+2qICEeBML55B+zvmZsElPRmhhaoBK
	 TRAwQ6xiJwUTQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 05/28] mm/damon/core: introduce damon_region->probe_hits
Date: Tue, 12 May 2026 07:36:20 -0700
Message-ID: <20260512143645.113201-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512143645.113201-1-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8BD2CA0009
X-Stat-Signature: iigiodt3x41878w7i31eh9wqsx9sxxrb
X-HE-Tag: 1778596620-207337
X-HE-Meta: U2FsdGVkX181MdrFPkH7iIYPIis+s52ydeJcjZ+mNYNhrREjfsh6I4BduaJ6IaZOfeSouzqTn/VpKdtHbRyoKseBrxz2BYOrWVryjqxcC/had4I7II1HBsvPf4B2jr5iwYy0/ObvGqFZWLaF2e7FSZvb1XOhbZ7BSYu+CS8ONk9ymJe7iHflw5WluMvmSrweZ4sVGbsu/ETHL+HjcvLx2+NLf3BPFy7AnowHXq0lEapCo3EoU6yIYz6SEfvJgFnbiDenJfp+cWU7yw0F8+u9Nw3aTATvOukguAoceadIlloNj2m+8wfnZ6346Whyw7Rft/2kOzD5zxPZRcHhRfVJjt85OtRBR17N2JJLVljF0E4l5JfuGIaoj3HVQwuFmcMGV+WdnixX/IDd1hCBjI7gb6CtOWAfG+xi192cCTUN+1dhO7GnsMyOc6YVNPgQoxk6i6ghaY9KoahmpdIeTPzt6GAtD1ufCxkJd2AlY7xR3rzMqcDETjef0b2NlqcnazuMfb9d4YMnnsXgJ4biSr1sOxxeJQMhEsMg6X5ErBBw4/V9A4/kdR6BqpxkocVsphKHUH7fttSyiqUQ+MXWTAomT8yHuXggStmXQ7BhmV6rVyuy4dCvAbhuKMlc2Xn7XqPm0v6k31cxZBL/U6NDcTFU0OANX/x0+FLxPv3iioxLBOaAnOQxHWXR2k9FtWNIQaN3IhC/AWrT6KJF4qw+GFxysqZSY5zbzzlCTfvxkD2ATRCYE1B5hD8FgAn07aiycRylQwF2KsHSnxr1WlPFCXmvBk5tCcX+dmYpdRAtXL+6oxEAXMfJOVgtsY6J2ebkheGBGBw2xtv2n4du5woZnZTzHaqg7XYmJnkiKuxxKstoAmty0Gcie365NXKDJTX1Ifh9i0FLGFUKTZTLUBB3OYv61oshTJkDz7EP4hZwNxfLYub24do6qcU1G0mWgj53a9PeOu9TBHtpjcR7CDtTFBU
 V8GCzEKc
 7nq7n9mJYzRJm7dV3F8qbN9DSJrVfApbagSbWpaQu9HgNXg80bxUjypdRlK25C6OydaTdZj+bCKTl7gqiDAQC9QTb6YkLI7ugUB57V7ZiTr/k1wecbxstUySzRud6dXuTBxoL/52c3SN/rEJTaiZOSQ30f+E3JwT3AvEWcf/7PlnAQnp2XO+6kaBbk0BSyCH9SBl/FX+dKXuWMAi8x1Jk7DF3VC7noaQxNB7lPm8J2lPHyeRYIZsvE9lpGmKshgegaP+A32b2f+ndo//bF/8fYImzJQkuts4UQ9WUvXdZS1L2pcjtyr6s/vK83/I5wyS+zgon
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an array for the per-region per-probe positive samples count.  For
simple and efficient implementation, add a limit to the number of data
probes and set the array to support only the limited number of counters.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 4 ++++
 mm/damon/core.c       | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 95b2c508a63ea..19b780bfab051 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -17,6 +17,8 @@
 
 /* Minimal region size.  Every damon_region is aligned by this. */
 #define DAMON_MIN_REGION_SZ	PAGE_SIZE
+/* Maximum number of monitoring probes. */
+#define DAMON_MAX_PROBES	(4)
 /* Max priority score for DAMON-based operation schemes */
 #define DAMOS_MAX_SCORE		(99)
 
@@ -47,6 +49,7 @@ struct damon_size_range {
  * @nr_accesses:	Access frequency of this region.
  * @nr_accesses_bp:	@nr_accesses in basis point (0.01%) that updated for
  *			each sampling interval.
+ * @probe_hits:		Number of probe-positive region samples.
  * @list:		List head for siblings.
  * @age:		Age of this region.
  *
@@ -75,6 +78,7 @@ struct damon_region {
 	unsigned long sampling_addr;
 	unsigned int nr_accesses;
 	unsigned int nr_accesses_bp;
+	unsigned char probe_hits[DAMON_MAX_PROBES];
 	struct list_head list;
 
 	unsigned int age;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 240cae1420c12..72acdeb8c478e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -229,6 +229,7 @@ static void damon_verify_new_region(unsigned long start, unsigned long end)
 struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 {
 	struct damon_region *region;
+	int i;
 
 	damon_verify_new_region(start, end);
 	region = kmem_cache_alloc(damon_region_cache, GFP_KERNEL);
@@ -239,6 +240,8 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 	region->ar.end = end;
 	region->nr_accesses = 0;
 	region->nr_accesses_bp = 0;
+	for (i = 0; i < DAMON_MAX_PROBES; i++)
+		region->probe_hits[i] = 0;
 	INIT_LIST_HEAD(&region->list);
 
 	region->age = 0;
-- 
2.47.3

