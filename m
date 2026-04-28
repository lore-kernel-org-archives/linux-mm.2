Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22E58FF8867
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 01:34:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0FD66B008C; Mon, 27 Apr 2026 21:34:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 999786B008A; Mon, 27 Apr 2026 21:34:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A4816B008A; Mon, 27 Apr 2026 21:34:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6D84C6B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:34:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 321E21C05D7
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:34:33 +0000 (UTC)
X-FDA: 84706244826.28.DC47A70
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6D0F7160009
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:34:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=omaAhUye;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777340071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w02SkIjDxE1+5WOK99/afWMwXe2BKw/YhIT/2ry9pw8=;
	b=tAf4LEwtCnRW/7NUa7Qd/fKrAnwXb9FC80sv3bjMCSnw8Lco2sD+mmIcpKiEkvH70L7qLB
	wevADwc+OcG8sRL+mNKKVnB6sxB9oBck6zI5+PftLWhPW9tic7zYcu1LjdN1K4WNJWTwgh
	IM5sGF+hdm0FK61ShgY8Io2iOX8QS0E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=omaAhUye;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777340071; a=rsa-sha256;
	cv=none;
	b=vQoNCTVCEs1p4UEKz/ZHja1k8lgOabUb1JZF0KOYAeTAEW8WQGkDqJm4bK7Cw4aBNluKSa
	404Zv05t2CYWTV80yZ3acRwXCJgjQB0CitEZMPuQrjEtIZ4aDTJgnrO/YemZzgyKAepTsa
	4jY8TEi5Wwvlcs5Uo+Hqx0sCTcPJh64=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 32E2242BB7;
	Tue, 28 Apr 2026 01:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE879C2BCB9;
	Tue, 28 Apr 2026 01:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777340070;
	bh=CbuuRamb/kBQi30M9xcMQJVCapHdXjhxNpZwhqf9TZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=omaAhUyegFAJx3SDDZ9s6uKHSs/OVhumd7gScii7OT1kQ86yFeNfP5NwgoHvIi0Dt
	 XSPF8wfv0S6k4KUlhaggo5kuqmaygpeNULxi/ncPJvGr90Xp5gHBZweo6qHTrhfQf5
	 MrzZ5BI3Wlk9Z2GZrc0czpa4kR/MwTjcwdlSBuTsqUDFOIN4UBX6W73zRd5eZo2DvP
	 oE/lUwrLarSIlVJ3NAmzIsnKbmVuFO34UzAWcT89kd7lRAwO+KtLAUhpDkUV89zUD8
	 Q2peGg4FMIeuO5NtZ4h0VRVGL0F68DzRi0CmCmPZrmsfLCv8MgZW/SQFvGB8FClP95
	 viYG76miNhlPg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 01/11] mm/damon/core: handle <min_region_sz remaining quota as empty
Date: Mon, 27 Apr 2026 18:33:50 -0700
Message-ID: <20260428013402.115171-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260428013402.115171-1-sj@kernel.org>
References: <20260428013402.115171-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D0F7160009
X-Rspamd-Server: rspam06
X-Stat-Signature: t77ejartp71hoxrxrs36i7ifn6qttz16
X-HE-Tag: 1777340071-247260
X-HE-Meta: U2FsdGVkX19ZIvr2JnWWvtgaE8/kzKnohDKnhfwUARJ2itubQ9dqaFemrycbeeh7ifHNCQhz3qWk3ukylpHZ5Zosb0Javo3KRnauqYErRoxH2mf+yT/JnJum1yzD9Pk7Qqcl/MBKVihSOamvIjt+lpD1pm1U2YPtTS113vBIb2F8shZHHaOzM2lX4F2HQLwzkwaeDdpEqMS2WCvmDtFZ2A7PcoJUjSnNnD1hkWv7TBGaRhcxOpEjg+L4gpg0JCk8Gt9vSf++cRJXGhvbUHByVrDVRTERR1r9jhJCmXCYXLM1m4WZU7dt+Wjf4A5Yad8cDh9Dxz/uefivzSZe/I9LzM7PcNL6uJxR/a0+BCzRlAP0o+/6YPBJ5K0dptPyNPwjVcNBCzdAvTF8tuCRcOi8ua8cT/M9YR6XHJenSqO/ImPxvDueeca66EBCet3YzHdeGs7VAByk94FoFwp/jBtb8MN6Jc07dxn/D7Y5WM8DqZTXLC+ch5rI/3HbSP/S6Egjc7zHyOWdhsCRrTN8o/wnHNImRFnF1vr6xn9HmsyuWST43e4sliYZxMC3N3VK/wYAGBiOJ5OQah785lZtsj01Uylfwye2nzWzqF7jqOHCO37ghK4xWQmuGTcfKmmhPyTm/OmUpRuUkD31SODdqOFw2LR1dPVNIxBRwklcFLJVCds/6GeoDVHxZZE773dnht2b7QrWFlwgSeUp4snTbdM1GCaCt7pRBBrHy7by9Mclno3a1h6Sn0HJPE0tnqOXMCgiB9cLLauLqIXg7tXx48R9MLZdXKMD3nS1E0buwQOg5bWFl4Ao6toxrX3bLSwezxYPKjyHOQVT0IVdnHroLmHlqDX4CJo6QvwJbcuoNzAbI4gY4i+SfkUVmj7kz7dR0YVyvWObBU6FdjEXv8Y6Miw8Dt6Mj94DDULMmdTdOMBEVcN2wllzXyOj63vS+uO4HElmRVkMVELiS9QNkyqT2x/
 68z3FEDM
 5s0YnIIM8d22M6DbauRwcmtWI2L9lOzjqzxqHdw+yuTRJOjDbF8YnjauR6Mk1HAgOFTWdzXVtB1/58BxgRpP8bOBGMqGoCcerwnz2Pekvy7bMYeTD70bgrxZnSfuafIAmNaVEInPC/9wxnpPys/YefRZNs0ui2GpY+4UUBLG0tUDKZKHylTrKRHjjaZfki2bVV9TPsG0gKFilNpCq6X/aG8eamRD23Ox6x6XpMIAP73H1yyk7m1kGTxUHz/ehWf5PFkSyBOJIz6lY598vjDJnWSJ6Pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Less than min_region_sz remaining quota effectively means the quota is
fully charged.  In other words, no remaining quota.  This is because
DAMOS actions are applied in the region granularity, and each region
should have min_region_sz or larger size.  However the existing fully
charged quota check, which is also used for setting charge_target_from
and charge_addr_from of the quota, is not aware of the case.  For the
reason, charge_target_from and charge_addr_from of the quota will not be
updated in the case.  This can result in DAMOS action being applied more
frequently to a specific area of the memory.

The case is unreal because quota charging is also made in the region
granularity.  It could be changed in future, though.  Actually, the
following commit will make the change, by allowing users to set
arbitrary quota charging ratio for action-failed regions.  To be
prepared for the change, update the fully charged quota checks to treat
having less than min_region_sz remaining quota as fully charged.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 278594847cf94..888b6ac29feff 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2047,6 +2047,20 @@ static void damos_walk_cancel(struct damon_ctx *ctx)
 	mutex_unlock(&ctx->walk_control_lock);
 }
 
+static bool damos_quota_is_full(struct damos_quota *quota,
+		unsigned long min_region_sz)
+{
+	if (!damos_quota_is_set(quota))
+		return false;
+	if (quota->charged_sz >= quota->esz)
+		return true;
+	/*
+	 * DAMOS action is applied per region, so <min_region_sz remaining
+	 * quota means the quota is effectively full.
+	 */
+	return quota->esz - quota->charged_sz < min_region_sz;
+}
+
 static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		struct damon_region *r, struct damos *s)
 {
@@ -2104,8 +2118,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		quota->total_charged_ns += timespec64_to_ns(&end) -
 			timespec64_to_ns(&begin);
 		quota->charged_sz += sz;
-		if (damos_quota_is_set(quota) &&
-				quota->charged_sz >= quota->esz) {
+		if (damos_quota_is_full(quota, c->min_region_sz)) {
 			quota->charge_target_from = t;
 			quota->charge_addr_from = r->ar.end + 1;
 		}
@@ -2133,8 +2146,7 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 			continue;
 
 		/* Check the quota */
-		if (damos_quota_is_set(quota) &&
-				quota->charged_sz >= quota->esz)
+		if (damos_quota_is_full(quota, c->min_region_sz))
 			continue;
 
 		if (damos_skip_charged_region(t, r, s, c->min_region_sz))
@@ -2460,8 +2472,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	if (!time_in_range_open(jiffies, quota->charged_from,
 				quota->charged_from +
 				msecs_to_jiffies(quota->reset_interval))) {
-		if (damos_quota_is_set(quota) &&
-				quota->charged_sz >= quota->esz)
+		if (damos_quota_is_full(quota, c->min_region_sz))
 			s->stat.qt_exceeds++;
 		quota->total_charged_sz += quota->charged_sz;
 		quota->charged_from = jiffies;
-- 
2.47.3

