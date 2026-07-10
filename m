Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3735C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C71446B009D; Fri, 10 Jul 2026 09:47:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B84236B00A1; Fri, 10 Jul 2026 09:47:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A996B6B009D; Fri, 10 Jul 2026 09:47:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8249B6B009F
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:47:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 27B3AA0459
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:06 +0000 (UTC)
X-FDA: 84972993252.26.C03C7A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 93EAE100007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K+UxNb0Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783691224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XGD2YWf7x+bc2xuKYd61BqqesZUpM+m83fMjtL5Ub3o=;
	b=QpdnqxFg2IFJtnOHqEUIDRX+nETxJY7W5ZrRr8V0tqIZkj1vM/dSChW/LZESGBduFBeoaz
	bXhGrdI341AZK802q9cDNGFEcPF2zII4K86Q0nwKalWm8DkYxOR6OfsK8bykE099zQjXiR
	x2Jzu4fIDqYs3fslyMI79ebX1Km+F2c=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K+UxNb0Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783691224;
	b=oSCpngPV9MPGIJuX784qIZB3oH75CKjkNAFJ/BEdbg0FVjYjQ1lT4g33y1dDx3ZPuma/j7
	NNFKLSpOnxUZV4jAAVCncIGTMVBl/q6bN1UuuzDEy4r59637HEqVwEynwN/ufiAPLOH+fv
	AEY6LDUk5MT5+RUKDB2COitlgWteiek=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3BA7861372;
	Fri, 10 Jul 2026 13:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33001F00A3F;
	Fri, 10 Jul 2026 13:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783691223;
	bh=XGD2YWf7x+bc2xuKYd61BqqesZUpM+m83fMjtL5Ub3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K+UxNb0YCGeNfa+n6P1nu3YMCqGAXuvj1D1MEMX/tCmR97lOSfrytuUmBhWen9hk5
	 XQZIsVWXa1V0V9rH2WvqLgEAM8AqH3oRBSxlfC+446bBKX/ruVKKs5VBL5wuBUyYgg
	 jItKxirBf3+vOW/BoTuaHgAZ6EZiJLJovv6Ni0MVGPSN+UUeUVE6o2GqjUWTGvInqW
	 e7clg5PcoDR2lCcLWVqFTJmBuZcWdNwOADLATTmX8XKPetpDN/A/0XBXykKTjiSFcw
	 Tg3wER+d/zJXNxMUxJoautQdM3nbQli/VYBrr9Om1R/FuCrto9RTyo/LLh+p4Fn0DB
	 BUVyqDzmZIG3A==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 11/19] mm/damon/core: disable access monitoring when probe weights are set
Date: Fri, 10 Jul 2026 06:46:40 -0700
Message-ID: <20260710134651.18084-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710134651.18084-1-sj@kernel.org>
References: <20260710134651.18084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 93EAE100007
X-Stat-Signature: hmhcj4qo39equb3dopsf5qp1qj5f8m6r
X-HE-Tag: 1783691224-224072
X-HE-Meta: U2FsdGVkX1/rVSYxmpc6/UWZqMpSL5CpdmSb8iEurr2lLt+puk7+q03PhfEsAPUeC1+T5XsNDACgR0cQ6JUTkBvNwPGqJsEJb9JBmDYgQlKcRf9l5DT22+QYndC4MduQcUvfIsWpE1NPrMx971sueDTVqCPXoT5ZYYrimLTKAeJ/bZBezFzuVPApq+UmaKzuQIHQhLX6tV3W89a6OPhl8Sh0lGEqFyXOB978KKc+FhmFyGDWk+YkzvX9MSqGn1hIRDaesybNz+pNOcV6Kn4z/jFHQzzrbOOybP42h2maUoMIBmx8t6BDGE2IK7JtvKFVGxB/b8ZadZVuS+txmBzmLgchHetnR3b6xGJHepa6yF62XBqnILCruRg4UWHtXZBkNlTSUxKUAQJ7jQ7Yu6P2/mCJ2o+Rh0AzbAMe2zJAJKgJApWnO+EO7RMYSxFUXiZFopSoP9JgxsE2YcI/MldGsXKyvzpbeuqGnfPheRXnGyDNEnBmSpukwzxqoJV2Lk5mni+6nfmgQwPyh9ZMFOAiXvL3uAflveGoGI/Z59+xKVxxwzmMYf7L/8351zVjc0co6FvCT/sYvsvRAB6f4WlTvSvEhVQsqSPO7zOqFeJ//b/Hc2ej8qJ77pvJwtHlNkXtJ2NWvW3EM7aVbuodgZfXyJuJFQPRIbcvtCE18nlpmHGrmOmrV6fwjGFDFq3V8zbfhHfjAEG9zkkUf2JovqYMxCcwrD0mWqnMUoTeQDy35KdwueFMz+QW9zvfzUHE+WRR8OMTV/YWR6UI6hxC1DE2IesA/yeYaZ/WElFJ37b0y63JHa03eEdD4iTzPW1/F8rcjeZo98bny+1nhHicXCPXcnlaBSnSVysEHsRrB1DFmy8y5AMx8KJumq/pLLYjQypIo+KH12NlJIZoXa5rg7UdrUtvJdQizP1UmF7xsAzwgPWH3rqy/R9NQWhcYJJjihU0QMcmgmyehHETvLQmQRt
 uOo/SpvU
 p9gsW4b7UBwSOEfq44PFK0/iNkeb4GLJ+psQl4S3NqeApRXtcYjxLnOJX+qpPYEOlgBReS8vHixvEYfCfGzNjyKd+LItRKTu25sDVRbBPTB8T0fHWFvgCCnZMLN06B5MJqXEK25jfwM8W/eG8Wac5PvCtB7xtGPKn62pCmVw1amwYhdLdBH4BVVnbY/DGLJULV1S9mLsf01nVWdb6CtBlBkVLLJwUeSSMeXpnJaYDLE7/BG0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When users set probe weights, they are interested in the data
attributes.  Not necessarily they are interested in data access
patterns.  Disable the data access monitoring in the case.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index a0e6a5129fbf3..65f91e3b58d2e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3763,17 +3763,18 @@ static int kdamond_fn(void *data)
 		unsigned long next_aggregation_sis = ctx->next_aggregation_sis;
 		unsigned long next_ops_update_sis = ctx->next_ops_update_sis;
 		unsigned long sample_interval = ctx->attrs.sample_interval;
+		bool access_check_disabled = damon_has_probe_weights(ctx);
 
 		if (kdamond_wait_activation(ctx))
 			break;
 
-		if (ctx->ops.prepare_access_checks)
+		if (!access_check_disabled && ctx->ops.prepare_access_checks)
 			ctx->ops.prepare_access_checks(ctx);
 
 		kdamond_usleep(sample_interval);
 		ctx->passed_sample_intervals++;
 
-		if (ctx->ops.check_accesses)
+		if (!access_check_disabled && ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
 		if (ctx->ops.apply_probes)
 			ctx->ops.apply_probes(ctx, false, false);
-- 
2.47.3

