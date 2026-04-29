Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EE57FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 04:13:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED6046B008C; Wed, 29 Apr 2026 00:13:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E87A56B0092; Wed, 29 Apr 2026 00:13:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D76C36B0093; Wed, 29 Apr 2026 00:13:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C8E086B008C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 00:13:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 918CCA08C3
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:12:40 +0000 (UTC)
X-FDA: 84710272080.02.9076D91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 065EE40002
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:12:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q6fEh0o4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777435959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=imSIJsDDnKUSN6i/JQPeDsqcpntW1CclCFA9soIV90U=;
	b=BcyVVNVTr/UZ7gpf1HF+JXMquBUVrVPwSMKcgybNeEOK1VvnEc4bKp+tIm1zwkqnwjHsrL
	iFCEo3qxBA1VgpAC2Pm4rDBqTRvBqwk276w6R/Ah5L8EPRKErE/5qOApgqndBdW5nswci1
	HzhjxejILJ3nLiwMlVeyIlH8qRNSnD0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777435959; a=rsa-sha256;
	cv=none;
	b=gy/BbGlrEtsW2VDWKLr+/cc6SC3QNWa5YkakzwnuR4oq/oyonIMkzvBnKwjzVOpBI2By08
	8GA6EzuXdnyr2sHckoAWF0r7JCijFz6toNKVP62cInXTowHitlZuhDqf0UG7uFFMOGfoXJ
	riaSSPF2Hw/yVyv/c8ILYlizPCFVhYM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q6fEh0o4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 123AE60581;
	Wed, 29 Apr 2026 04:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905CDC2BCB4;
	Wed, 29 Apr 2026 04:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777435957;
	bh=t9Rr9ycMseYm87fA5FNyb+eYDvT/K9z7TWRb2DuqipQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6fEh0o41yEc+4ITmIpOW2AlL/IMvgwSy9Mp/yEficOXCLiG/2jPhfzFDwUd3cxh/
	 /PLdDOriqj6CMab+2VyDo4U3ynVmdvHYAcOFD9LnLVPM5EA4qm95Z506x8aiaO9h4L
	 bnSUEzEgf9T4foy0Wo4LE/gAUmiOhsCG4hLoW1EvAl2Oc8zq/hS8npjcdz+xb+C4lE
	 vfa5+9IVo3t3+W0bgzbgXq2MsMbDyZ1WQzyK3QeieEEoCuqzog2um6xRbHZNbIEUlC
	 /1td3NePQkTJWXZSULinnNb+YXdd3R+ldYuJodf+cBmeWOsqumMAXX1oeo1y8VTZFA
	 u/jcHgDqxDfYA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/7] mm/damon/reclaim: cover all system rams
Date: Tue, 28 Apr 2026 21:12:24 -0700
Message-ID: <20260429041232.90257-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260429041232.90257-1-sj@kernel.org>
References: <20260429041232.90257-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 065EE40002
X-Rspamd-Server: rspam04
X-Stat-Signature: 4sitixawrni7sn95k3a1ur3xzt8fukyj
X-HE-Tag: 1777435958-921508
X-HE-Meta: U2FsdGVkX19jagI2dU4bmB1E5jFOk6eTSurvWK2InMBRN1KOll6NEfJHta2bvJSSW/yAMSF6yHAzhLrcq0fzyCvR2bDrid2zDPGGaegUquHFTT2pLOGFtXYI9f2XyaGQZpp4VDxKEaJr8zxU6HRq49QiqBe534gaA9EN+zvnjySy2+X3Ms7LCqWdy4XPWWJ88lb5huPpyJO72rWfoKB/YAWHt8WBIIZnedrucKFWrxwlWUBmvtIfp/vf5RLmuqtkzpYguhKlE2Jnvd4iBiVqIqeHmDN2XIeiyUMS+4v1G3+dyjoai0iSgF5mMJ26jCFUkGpRNVBSwmQ4Fu3oj273cvO3426BrEDe0ii4MQW9tR+9eP4y8ftmRoUhFASr0SvAs8BE9gywH4KebvW9xw6ONPx9gOvc/x/Q9nPy6RcY3BzyroDNBjJDNkBsBQaqj+/hb2sf7/cSc57vwwb0gSD4SIdeyyKszIg4Rg+mnxFkmA2Atbi4Ee8sIFHLRSWKfS8+/Z+KqzcN7SZbbVPYr7AjWOAs8mQsKhBcP47cHOu3/Rk7WYFJ6R67HP+7C6CG1f6AWWZx9gsqvftqaoHlLK94o0C0ND2GDZvY+SHTEkcqXIU1tKPJuTN8EBgr/xw1TTEkSyBoR3LSOid0TGrRtXqnOY20fm/FzCbtCLN5dN4y7wMRxQOzYNUTDhdX4ZzddzZj9nnwnrFZ4kdBwbafUqPRY1oaaxRHSothWUln3RqZJ1Qxsrh6O3/h9xi+8iDe7hXiU/zVVhZYcyWmebYEYCIP8fZyf+xnYVh4rs5OZ4FjIouGwnQxAKz+fZ2wT8btqaeFCVDA4645fhu2AdJcUYM50SO00uU/5yt+HrDOBrfTHrDEnaVTKIN+OZu7zwGtCXNhxTRdP9O7YY5doziIz/CyRN8SIw3hTKg8kJsETv89Pz5ta2FkGH2JTleNbQQME1smgWWBfYWeZWH1cuxu3Dq
 wfh976iZ
 r+I27ZYdu6dmwYMpUJIZhdSeo1XXDDccBOmECR4JLEvMSBoipZ3GN/7SnM9TaS5fGiHUJtedo/0jHONQC+SdCaYH0+ZXCyxmLb2muT3QS725VLnp5SFUzaLSw/xivr3BLEQSQ5ZYlKTIoOzgJ9KOTWLFNELibJErn/GOYPIwMB0uogN75x2CwpVTicUdW1PMHcjN06mxmZyuX/mazczuhrWwLI2Ey1Ck/feX3p0o9r5XimEeForay8urXW/7rITWrQIYP3gLQcreRW6EwEoyvJsafrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_RECLAIM allows users to set the physical address range to monitor
and do the work on.  When users don't explicitly set the range, the
biggest System RAM resource of the system is selected as the monitoring
target address range.  The intention was to reduce the overhead from
monitoring non-System RAM areas because monitoring of non-System RAM may
be meaningless.  However, because of the sampling based access check and
adaptive regions adjustment, the overhead should be negligible.  It
makes more sense to just cover all system rams of the system.  Do so.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/reclaim.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index b330ff1695907..a60ee800d63e9 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -113,7 +113,8 @@ DEFINE_DAMON_MODULES_MON_ATTRS_PARAMS(damon_reclaim_mon_attrs);
  * Start of the target memory region in physical address.
  *
  * The start physical address of memory region that DAMON_RECLAIM will do work
- * against.  By default, biggest System RAM is used as the region.
+ * against.  By default, the system's entire physical memory is used as the
+ * region.
  */
 static unsigned long monitor_region_start __read_mostly;
 module_param(monitor_region_start, ulong, 0600);
@@ -122,7 +123,8 @@ module_param(monitor_region_start, ulong, 0600);
  * End of the target memory region in physical address.
  *
  * The end physical address of memory region that DAMON_RECLAIM will do work
- * against.  By default, biggest System RAM is used as the region.
+ * against.  By default, the system's entire physical memory is used as the
+ * region.
  */
 static unsigned long monitor_region_end __read_mostly;
 module_param(monitor_region_end, ulong, 0600);
@@ -232,11 +234,9 @@ static int damon_reclaim_apply_parameters(void)
 		damos_add_filter(scheme, filter);
 	}
 
-	err = damon_set_region_biggest_system_ram_default(param_target,
-					&monitor_region_start,
-					&monitor_region_end,
-					param_ctx->addr_unit,
-					param_ctx->min_region_sz);
+	err = damon_set_region_system_rams_default(param_target,
+			&monitor_region_start, &monitor_region_end,
+			param_ctx->addr_unit, param_ctx->min_region_sz);
 	if (err)
 		goto out;
 	err = damon_commit_ctx(ctx, param_ctx);
-- 
2.47.3

