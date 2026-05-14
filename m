Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF26FCD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9685E6B009B; Thu, 14 May 2026 10:09:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 809826B00A0; Thu, 14 May 2026 10:09:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 632966B009E; Thu, 14 May 2026 10:09:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 355DD6B009D
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F20D51205B6
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:23 +0000 (UTC)
X-FDA: 84766207806.27.5EC8132
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3CFB7A000D
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RYYPs19q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S5U1TdNeh8aWoLpKX+5mI2lMGYR9gNPa9LKhgEIcu2s=;
	b=qiFv8E9ugB3V439m+s9Wig0szdT8bmuZqnPuQxPRwoyWPTeyFabF6+QyKxKjnmwIV70f4Z
	GTWvVdM9wyNq+FfpZRYsf1HVeDvXw/2CV32DpCiDAm/c0Q8Gv/8H/XO48sQfId4/ExEfWY
	3nALH3tMkbCaBSS1PAwz63p15poHPrI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767762; a=rsa-sha256;
	cv=none;
	b=HG2u9gNfFJDF/89mlSxiDbhyt/MZ1448HcwvdoKh+AMN4WCvZyQ68fLApNCiD82v3ZHAwf
	+yArV4Gjaeip436pLVMlxfANUUD0zVA1WG5rcy7/xcp8ZFd3/4qsqziuR+Y52jHiCcnxeR
	vkLUhAXVESiOC2xwtsvKsv6BX6cwdkQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RYYPs19q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5789B4430D
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E84CC2BCF6;
	Thu, 14 May 2026 14:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767760;
	bh=T23N/ChU1TyBSEMb1nXX6ZXwE6Ou5N0n+X87B8zILMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RYYPs19qHtcWiTw8LuehBBrlHddIwu2W18Vg1Ngs1HEB6UkPqM/Uy3KM/aHSnL2N7
	 23XWZxPbT9VLCXxWyzGP/SKX0P9KPhVPuR1BrXIHcs4YkQ4kYcflLjn+X+OCNNVOP5
	 hxg5FTdpHbHxfDp9QcTUJqSMSQkkiCQaAQL5uL3v9BfzTTKOytVBrermkUTvNBUZzb
	 CfWzWh9ffNUoRYX4/TKGHcBh137ysiW//kWAGuw+TjcYuJjHJTjz+oaqpr/Qhp3sky
	 Kw4bI6hBmDtqiohRCCmu8jxxcY/tKBPr1zcgASOYqA7+4KNolkGOChUeQYdOa3gJ4O
	 snRL0B8mtkYqQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 06/28] mm/damon/core: introduce damon_ops->apply_probes
Date: Thu, 14 May 2026 07:08:39 -0700
Message-ID: <20260514140904.119781-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: <20260514140904.119781-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3CFB7A000D
X-Stat-Signature: 1a9c44gkohj9wczs3snah9x4o9fhaom8
X-Rspam-User: 
X-HE-Tag: 1778767762-988609
X-HE-Meta: U2FsdGVkX1/tp4I6EJQTjqjvPYZo/M/55Jk7b28US2U80WUU9Oas2pQ4Ilwh68/KO0uPyR+Pl5R2ApsftGj6rki1m2TePmqVePlhqPvNzlG2GwWIkybdes8KJzzgc3WknVB+0TK65xuIKoRP3JlMjFZmtSALf3hTS8qP2N1rCFj4ilKL62+WfNhj4lZMuqGicig3oGimRem9jGKcFzHDuyL5pFUaWsTPWz7TyOOuCzVs/bUTBjig1xdvRCvVzBQzHCOl20WsmPJ7Hut0lf0dJ/2XNcDqdq4TkFxkPAV/V16vMY2ck4GepAHuWseUPV9LqdKqML3wt5lto+GBceNU813KRrtnb/NscEeKUYOG0WA++Y4vbhz/Bwhfp0YdrUEOV4eepp18hzhQpUwrpLoxqVZDI7Bj1JS3fUPbHovw5yILWfd8EWVng5dgj7JmPnWOiruOD/fZMWyGehAQnYzMsMkkia6nbuzY10gn3AR7ElOgjXWHYvAkT5Mq+7ahoB7RD8382bPOnlBr7V11Nexq7p0S1ukOsZBc006LRSOU/6OeXlflWY2kI7KJCBLWsnl4oEHpkIMTtDNm1GZPszcV8+2Mj91ceSiM4vXguSPjXxr/zSQir+7a9NatudVuC5euzbG9HGqvHBsjVs9+3HflZC7sEkAXco+sTNqxWYhltUHRFUkPAkqnyAXD81dW8vpu/cudqxk5uGNUI5hNrBgYkbtq+WwCllvVFKncjqM9PZnidwA5mIKE6XuaQbcAZ3DH/r0Qu0wh3WM8Dpl7YvL6d+FI54sJI4biy6U+e5fZFHUvn8TYLLOlm21Z0+B9Z/394zZmHdSjkZ4m7iL+pmEIKYOsOYKOCsg84tBFHMWAVMSvQvdQ+TxyP5PrjIjUlhLNiBUf2UM4X9pE5meGPlxWmyrd3azZuY/JiCMPWzOcW4ZaPDx2hA7lHuDzS+2LOVef2v4fbD6PWyzss49uKY0
 CYIVA5Ez
 eAHzMIcrYxUT3EdoyMVvm5ZiSg7Z5KaDvfWhjbK6ApUZzGA28LGfMRxtLMtsl/X6EJwjSSIQVQqzBDwnoEE+7ppy8p51iKijtWnmbPkY0BC1orQcbhDp8F/87hVZ8YFH4NM0sVwuUaR6Cd/5FBCXRRPtXhpOTlusKGzhYOC2WZ3Ns3ZSyYEOun8RC8Ivg/fLEa/8vbaynNPdIA8/yY/Fp+gnHOxkHZ7WeFNj3uKx6gn7Qr8un60TOMoIle2dIA/48OuNtEVuDmG+I4rSfLkxapZaAPHlxK5DM2RjgYO0dDirQeKraZ0lWjNqYgagUGUytbD0i9/aqBHHJbNBHROWcNyg2+dV8FbfrfJAn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend damon_operations struct with a new callback, namely apply_probe.
The callback will be invoked for data attributes monitoring.  More
specifically, the callback will apply damon_probe objects to each region
and update the per-region per-probe counters for the number of
encountered probe-positive samples.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 19b780bfab051..e9ca40cdd9102 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -630,6 +630,7 @@ enum damon_ops_id {
  * @update:			Update operations-related data structures.
  * @prepare_access_checks:	Prepare next access check of target regions.
  * @check_accesses:		Check the accesses to target regions.
+ * @apply_probes:		Apply probes for each region.
  * @get_scheme_score:		Get the score of a region for a scheme.
  * @apply_scheme:		Apply a DAMON-based operation scheme.
  * @target_valid:		Determine if the target is valid.
@@ -673,6 +674,7 @@ struct damon_operations {
 	void (*update)(struct damon_ctx *context);
 	void (*prepare_access_checks)(struct damon_ctx *context);
 	unsigned int (*check_accesses)(struct damon_ctx *context);
+	void (*apply_probes)(struct damon_ctx *context);
 	int (*get_scheme_score)(struct damon_ctx *context,
 			struct damon_region *r, struct damos *scheme);
 	unsigned long (*apply_scheme)(struct damon_ctx *context,
-- 
2.47.3

