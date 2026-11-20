Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C96E606A514
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 06:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HglOJQvF
Received: by kanga.kvack.org (Postfix)
	id 11D5E6B05B3; Fri, 20 Nov 2026 01:07:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A9FE6B05B6; Fri, 20 Nov 2026 01:07:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E614E6B05B3; Fri, 20 Nov 2026 01:07:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BFF236B05B4
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:52 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 287E11C4880
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:07:52 +0000 (UTC)
X-FDA: 85454466384.05.A397AD8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7FECAC0003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:07:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HglOJQvF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795154870;
	b=qXvpmGPefCHdf8udGYhKY2ftzHUYWR10pswJxuRtK445UT6dMoQ0F5cOmeyfQLfSHoTom2
	bZFzy6Si0u9pSZlcw/s4khkMYod31qGQebrfir2nmjQxMVtMLzgmVlFO2AkpmybPzEZClj
	HM5LY7K62SaU9UGqs6y3+nXe47LdtvM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795154870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qcJiPZgN8pOzganoOrgFc2rVZ3r5oqkHfeWdy+wn69g=;
	b=L5uYVAnHmMepK1SMSmrLpjtrFQWiI9UZL7smnxJS2/ZKAm8QiThS3y2rX1oQzIjHA8rEUL
	gOU31Qra4LLcSYNKv6rbLjdNz69Ko/EZd8a8o8QSa/rpbDgeniYZ7ihCzXBpAwrvrSuqZO
	A4g3AenZ8MErl3qA0ZxVR4Xg1xOWSjU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HglOJQvF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 24A4F61948;
	Fri, 20 Nov 2026 06:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41211F000CF;
	Fri, 20 Nov 2026 06:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795154869;
	bh=qcJiPZgN8pOzganoOrgFc2rVZ3r5oqkHfeWdy+wn69g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HglOJQvF8hFc3qx1LYrKqBI4k40AOZzxok/k0qZ8fU+ee+4sa4lnrKmoGZeUgY+PD
	 ZCQc6Ii4Ng9cB2tRTPsRUYVyJL7Ar+7dAgquxnkW5MOv4LnRCEkc2E7LrBKJEyKOQ5
	 ApdPktoFcOFvyzhgCAo2TiMmJ3k3L1pusU25R5jrvuCFb2wqwsibtM38yjGDwAbnm+
	 Hn8eP92dZ5AcRKe7IbPtfZ/rKPcqlm4draL4B6F/ToKepI7p/hHVcjYj4o2A8yRpK1
	 Vn426Yx2YruMERQxKrLBLmfV6X2t0ZdIj2Xz5kUPrH5Tg/SH9tF5fUPN3xcbFRIaOV
	 Grq6eB8NTTVOg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/4] mm/damon/reclaim: set memory PSI 0.05% as default quota goal
Date: Thu, 19 Nov 2026 22:07:36 -0800
Message-ID: <20261120060741.92121-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261120060741.92121-1-sj@kernel.org>
References: <20261120060741.92121-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 7FECAC0003
X-Stat-Signature: n35m3sikrkuhc9iq4c4brmrae3htcwb9
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795154870-976225
X-HE-Meta: U2FsdGVkX1+u6+OuPWWcOMWpANUcQDoR0/i4DdbzoUmfip6CPKV4PUVxJi3YEMCG9NR9LAjC/ZuvDBEiMod0H3FD8hu9WbUk+W1Akr4wCzM4f2K5mmVw81GPlvXuNWtll4AXbu47SQqxeA8TPNoSG0U6MZ/vCMhdbtY56s5lH66xu3h/OIvoR15r41bdiVSQ9Murdvrx5F4y2tAEO4KIv05t/uKKmIzIyhX73PQX5hvsWOCMnVdhoqnmSL0kWkSf/O8zkLEtGgvPbMude2kf0prSIQwELQMk/M8kmgRLmrlgKepXodx43DDToVfLqdJdUjvSsfX3Agfsdo53D74p4X2FPLhnJ3a1DQZHZxhhJ+TF43TD3+U7wuGSafoWR6qCRihnBKaFGWokMKYyhj9Uoc9wk42KUtoaS+Kjkn8stRR5g3+yYSepmtAMEXGL3m+HnHA6w4f/YYZ+qE5XCoz1PKXJ+/SGYjg0u4Z6Y4hDLo7ob0kP4cdFwLavuJgiomvFZm0N3nq+Z7y5JvOYw0Tzrtu6KjiE4e37Kp1vyDkKJ8ES4aXDD+mmPeugjP64gt1Ypl/SlsBxkiDQYunE+Kph1YwW1onWihSt5uWED6wt3iKRTygYZzWWRo+dEM3gS8FvXe5FfniHToADGihYBsP1wKXVh3MfktrfjFW8H4PZGY5hZIV1yYaQZUkKyzsEsIXK6QwiYjrM/sr5xmieNqe/YwZbKeulFAm5nGjH7+sjy3qHwFRFfZ6C2WsvKxbuYGjPuTgJHN40PIRyEDUMzj2S3Nu0d6QDIVspyJXTCNni9vFsoTajJlf/4zEfxf4Rtati1gOpK8PARhsyUmCw3C/49fNGUI+Jd/kjbtXynIDgc57RZpXU92BHH5CFhOaR26v34maA+zlVrNXYf7mgDqOoo4NFmUb0gI38NLfg6ybseF4NHGowFSoL7z6Ee0VXlwQiUAj4P+42Lh6CJgrAq6C
 suivZL2a
 4Jo0SEAECa0u9f8fUrvOCTzS1cGr9NAxDVGx+yfuQQ2cMrzRkBqF32gtJHeOF2Y3hGlW43PpNv+3hFODk9o/FLpA9UEkcK6gTnM5vGJ5BzyTGUKSh6edNXCbYNQaGy0BcBZASwxim0CbBFfMvYmedrous9fmZAlTwLes31WVgoJ3TFC3+A/dvh/M33C9+clihdCKHunYJxt1SeXXAdqrUAIS0FoY5RY6k/Q9D2YsB5Kj1VtEP8NQ2QW5f2VIvmYYLIICuO2zf1m83Va6PgmdnbSgjq9AhYT9v8wBGoqDaNYhtFZ8mYzPL5qQapXaokWVQspkZz4Ssy7w3m1mW35IxuRbrQ7J5hH5kIlS4XR5ChpH8Q1CpX8kgmIlIhfHQh0J2Zb07+yWiOxo8pEggZxPAPw4GrW4LtXipEV2UYq2DSc/icK8yMcmFYDD8zjdGZy3KkLcZVUw+79566dU6QgbaLXh2HJPikK/hO8Qx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMON_RECLAIM provides a PSI-driven quota auto-tuning feature.  Because
of the DAMOS quota internal access pattern based region prioritization,
it means the coldness threshold (min_age) is also auto-tuned.  It is
tuned off by default, though.  The feature is expected to be only better
to be enabled.  Enable it by default.  Set 0.5 milliseconds per second
(0.5%) as the default auto-tuning target memory pressure ratio.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/reclaim.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 2241b3e9145ef..d297b1596704b 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -69,9 +69,9 @@ DEFINE_DAMON_MODULES_DAMOS_QUOTAS(damon_reclaim_quota);
  * compared to this value to see if the aim is satisfied.  Value zero means
  * disabling this auto-tuning feature.
  *
- * Disabled by default.
+ * 500 microseconds (0.05% of default quota reset interval) by default.
  */
-static unsigned long quota_mem_pressure_us __read_mostly;
+static unsigned long quota_mem_pressure_us __read_mostly = 500;
 module_param(quota_mem_pressure_us, ulong, 0600);
 
 /*
-- 
2.47.3

