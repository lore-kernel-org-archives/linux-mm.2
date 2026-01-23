Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A05FD6CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 04:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20D8B6B03B5; Thu, 22 Jan 2026 23:57:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AE9E6B03B7; Thu, 22 Jan 2026 23:57:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0140B6B03B8; Thu, 22 Jan 2026 23:57:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DA55A6B03B5
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:57:48 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9B223140262
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:57:48 +0000 (UTC)
X-FDA: 84362021016.25.AF2D391
Received: from mail-yw1-f193.google.com (mail-yw1-f193.google.com [209.85.128.193])
	by imf17.hostedemail.com (Postfix) with ESMTP id CA5B040006
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:57:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QFH7Pifr;
	spf=pass (imf17.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.193 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769144266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1D+wUgUp3AIJjrSF87TlviSGACs4vs0t8FpLdk/Qkks=;
	b=InakUvgrp11gb7oky50fkTgqwWaMp9qG/JagCLBqaD+9NeU14o2LAV5wOVHGQXfJJ6deEP
	RqFOkVfVXoly7e7b4wMjWBrLPnPs2bjE9bKhB30qZ8TQ4eL6UiG+4f7P0zj07Bshtgzk0d
	c/P4fihltTdSPXmnjVj+q8dFB3gR1No=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QFH7Pifr;
	spf=pass (imf17.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.193 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769144266; a=rsa-sha256;
	cv=none;
	b=SO5LcFVG+fSEgWbRq87fkBbSobrrZYa9gzRsPas2iDhpEdbB7KvIFvX+lqxsjLNgR7HghH
	P5zO73ovFd4RdKdJ8SmF5RxAeMEQlEgFCKxI6jFLQmFhxFy52sQlV4ufLp9xAbfxv0zGrO
	fBCHa93ySeg1LiPIn8iOvU9tuCSahzk=
Received: by mail-yw1-f193.google.com with SMTP id 00721157ae682-7927261a3acso20445067b3.0
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 20:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769144266; x=1769749066; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1D+wUgUp3AIJjrSF87TlviSGACs4vs0t8FpLdk/Qkks=;
        b=QFH7Pifr6YBDs+t2TITcso8c1a0kn4UBq9I7mUf7zhKse9PoYrHEJZAIw90S4NEis7
         gA2Tl0HV1IoTzc2W0/v6DLwMO6CthHJH1KQdnGyPHqtQQddyklg0SFzQJIgD/nVI2ewd
         qs7KHJ9lEP+KTQFdUyH2/E4WrTkxfndGNiXD+i2e/EyAqiSe862xWzKS4Q1Fsn3spNpu
         ISBj07RlOeks7AQULH1Cd2ntbb0JVs2sFgw6lumE6mBPvZytep70fOZ5wtBbO6ZThPNF
         MoFEGGlL1eXAR+csLUQWbq10lzXt64Rz+mbToTCqNt/1/c4IIqmlNmanSISSiGpQOkBi
         9mvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769144266; x=1769749066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1D+wUgUp3AIJjrSF87TlviSGACs4vs0t8FpLdk/Qkks=;
        b=gdb3E7Sa3Md0M4hC71DUpH6Mk32ZP2hnbHXF0aSjzVitT5un8LVaCmRgxCeZI58EeF
         2CLxKHTgs89W28aLfcL0LcmY0Uuv99EkzW+vPMV/NTtpPM8hiI9XuHLV5gz1MaODLpH7
         9p7wrZn57pSyPs4a5HgswRyZ4FF8fp08cEivajI/NNG3Jkhh8HFmfFPugM5XOyrv7XoB
         ly9cSt0gYYDJlEdh7XgO67nVZtjpDV8XOR4Y2yIXYzjUpksLPTSP1h9PuWWw8K0LLmcb
         xh63qj4WeO4ntbUv5xvnQ3yYQ0u/0utu9vjdFdgJSuSigywcwgDCc6dHycM+ZoUR54m+
         OY9A==
X-Forwarded-Encrypted: i=1; AJvYcCWtu/2tnXM6IaxWIz5GE39I8ZKH0kAI/mDzqNVCz0Hou9aJx8Ppmpr1GvUw+fze62G2jyFm3cK/vQ==@kvack.org
X-Gm-Message-State: AOJu0YyfZcfKl+6VCtkl23Qe0Ees9j07VmgFtic8HrSBH5JZN7OfT7KN
	haULSFhqnJdXsRwiWaRArTxHtsaY9eZHB0Ta3DrAm8ledYdL/GG6vRc=
X-Gm-Gg: AZuq6aLo+d7k+D2QFfhGxozy5nHioXcO412ZJzFymd09ayXsJxUP3H9OTtivOAcJ1x+
	kdY2cnYhQkm2y5SNnF3pAlalB/9qBAQv+uXYEQ34q1qo5BTBzn501+q68CGtls3qq/tQEadf0HU
	jtxv7I60sQ+gDwZmGkZGZoALg3wCyJ4VQjdq90J6NAGJyQirD8DqczrE94QR0poyhW01/m7SAEy
	+/5K/HZT1Z2dCb+fWTVcENCvWFIH4eksHy+TDJtDqpRtEhy690ZxhHdLKr6V1aypQgEbN8X3hU2
	E7Tj1n2XpEET+eMFEcQN3E+YN7gzmLUVyrFX3JCdRLPD/JIICFmqeKY3nKplWJK2hy1dsfk6MaX
	xnD6fRnuTalRce2AKJA7cg1XAtlzbsOLghIoGlQbjat6oOxX2HlAjMT221odkkhz/o0REX32j0t
	dBy3Of+veUiDttWFPOJ9u17K4tGx7jK2bs2ticefC6pO7wZiVnhKCh5UBKlumlmw==
X-Received: by 2002:a05:690c:630a:b0:793:c850:9e05 with SMTP id 00721157ae682-79439900187mr15750197b3.28.1769144265778;
        Thu, 22 Jan 2026 20:57:45 -0800 (PST)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7943b2d060esm6104507b3.56.2026.01.22.20.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 20:57:45 -0800 (PST)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: sj@kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Subject: [RFC PATCH 3/5] mm/damon/core: add new ops-specific goal metric
Date: Thu, 22 Jan 2026 20:57:26 -0800
Message-ID: <20260123045733.6954-4-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260123045733.6954-1-ravis.opensrc@gmail.com>
References: <20260123045733.6954-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CA5B040006
X-Stat-Signature: 4kkonfdon5xanpjuf6ybyu153t38zrnk
X-Rspam-User: 
X-HE-Tag: 1769144266-805320
X-HE-Meta: U2FsdGVkX1817UTm3rPcW5ERPdompGx1RfGKHyjVFNYI2DZkedrungJTvCPH7/XzDfPDDCaJVDqaXdjhmfUHi9PuXIKQ2r1fnf/l1eM3FKIpNCqn6ES556s7a1nOcIPJ16uUCd4fxs1KRy3sT+J+xvBwRgZIeIpNj8to6kkzLH6Nr38Mg+NGsYMj7hYzH7GZtSMyinEJ0vFSP7szz3ozafp1Yye3YnSFotdCF3yfKZ6e7dKQFZd5jRDBe9EenCtj70caEZuD7uz5AwoAMh+LnI0gnUt4dP5Ez9s5MJFLDyGrkA6Rqb6YZSU4i6zyB6GzIzUcn5ZKVLUzE8ul9EQwwqMxujUN85cNSITEaQCL8OUrMA7rldGjLsVNvXkHyv7E+pguYrWt5EORC3dx9yD1nIPdMUpkAOyrdb6edaPNJ/ghbhhEt4NY60SPeMn7a9x7lHmkichPJo1mMPb+58JOIzt2f0pK4AT+AL/pN9jJ0buESNKnZyheeMUElLgejATqx8Bl2okwy4es6t6FWWx9c+gLqyQ59tw2kXNDsSrl8vzUEThN3jIy6DnP9RZd6nQbBsPJXGFUu+8b/axsALT6peTgiPIiVqSgAufAJ/qRwf7OcqheYxGWcXHrxUUeXAkwk2JSndYO13VSz7K1Ngr9jHk6JcQP3XYlK49u03LLMigRUGcz/XFRhCiHJXp8HQAv/hf1tGsCG0TYKL51IGsyUcpKwRZMhyAs/I2DrUZJ1FDm1Zl9YtOvVJRXKea6QJpKlSXwT3oE463hSvtXkPDyilbCT/Xpel38L1iv5VKhPSYMPTeq/QcyIm/dZJQSyzfCcqMMzOdK8MWrcxqo77VpJz7370XwYtRRDbu4eeqA6vTjjoH/yOnI/boz3KmFuR+ly352onncGSmibkeWqKcpIQiGEWHn1neOexVG1l/NH/1gl6fhdefR2rKn5zg+QDqIsOg61F2NVCXy59LVOIb
 euiR6BOm
 gDD6UppOnc6kwdjlrqQ+0Ne0Fy/9z0hclDPDc2txsq65m+DomLZEA5CI1zMbox3S+5AoBIXxiRAifzcCzhZslT4A7AmAhX30l4cddJztvdLXYC0QBrFshQJf7ZN/LtxcqL4qg+75sA66H9EkZXUTS8fltqFnrf1WYvIqvSYj7E94pyRRrrDzxSTaDRtxltr0Gq4COFGIt6C9lVARJu5m53eHILgYUNSZcbOozf1l5GbJdWetnw/ba4vWvqFSn8rJT341Vpp2Fgc5NvL5aBe732SFMUuCnTmcp8o1f3H7I+b3LvfyTA+KV4uu1tVWHrbrIB8HnUPzuGwmkhycvlpBr2g6K8vzROgfxdmAH93Bg380+QpdxAP+11X5ypfcgguWsi4LjM626EXCDIOHRmgeeOy1mZ/jwEgqXCRhmb7Ci5kU23C117JuD7OU1Caq48aJW1lcRG8LjMsOemWuVFZnorhwXO4GbN9bJ6pSm+Mv15F3/sYO+ij/BPaAdkdTnIhicxM03Af6l8S+93KkKfeVmcETHpnmV6fmRlg4pfx7GhuiEBRzwqspGksk5C9LfhAPPbK4kUmHKOfz+wMSHsqYpoDs0khWTMJV9YdJkcxC8BwUqUEWCCilULG4TeY7x6MC0TV6k17/Vn50Ox8enRKMzdHG/MA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert static functions in core.c to pass damon_ctx* and damos* down to
`damos_set_quota_goal_current_value()`. This keeps all goal metrics (PSI,
node_mem*, node_memcg*, and the new node_sys_bp) computed in one place,
while core remains generic and ops-specific computation is delegated via
ctx->ops.get_goal_metric().

Only static functions in this file are touched; no external ABI changes.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/core.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 84f80a20f233..d898bfcbef72 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2119,8 +2119,20 @@ static unsigned long damos_get_node_memcg_used_bp(
 }
 #endif
 
+static unsigned long
+damos_get_goal_metric_from_ops(struct damon_ctx *ctx, struct damos *scheme,
+				       const struct damos_quota_goal *goal)
+{
+	if (!ctx || !goal)
+		return 0;
+	if (!ctx->ops.get_goal_metric)
+		return 0;
+	return ctx->ops.get_goal_metric(ctx, scheme, goal);
+}
 
-static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
+static void damos_set_quota_goal_current_value(struct damon_ctx *ctx,
+				       struct damos *scheme,
+				       struct damos_quota_goal *goal)
 {
 	u64 now_psi_total;
 
@@ -2141,19 +2153,25 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
 	case DAMOS_QUOTA_NODE_MEMCG_FREE_BP:
 		goal->current_value = damos_get_node_memcg_used_bp(goal);
 		break;
+	case DAMOS_QUOTA_NODE_SYS_BP:
+		goal->current_value = damos_get_goal_metric_from_ops(ctx,
+							scheme, goal);
+		break;
 	default:
 		break;
 	}
 }
 
 /* Return the highest score since it makes schemes least aggressive */
-static unsigned long damos_quota_score(struct damos_quota *quota)
+static unsigned long damos_quota_score(struct damon_ctx *ctx,
+				       struct damos *scheme,
+				       struct damos_quota *quota)
 {
 	struct damos_quota_goal *goal;
 	unsigned long highest_score = 0;
 
 	damos_for_each_quota_goal(goal, quota) {
-		damos_set_quota_goal_current_value(goal);
+		damos_set_quota_goal_current_value(ctx, scheme, goal);
 		highest_score = max(highest_score,
 				goal->current_value * 10000 /
 				goal->target_value);
@@ -2165,7 +2183,9 @@ static unsigned long damos_quota_score(struct damos_quota *quota)
 /*
  * Called only if quota->ms, or quota->sz are set, or quota->goals is not empty
  */
-static void damos_set_effective_quota(struct damos_quota *quota)
+static void damos_set_effective_quota(struct damon_ctx *ctx,
+				      struct damos *scheme,
+				      struct damos_quota *quota)
 {
 	unsigned long throughput;
 	unsigned long esz = ULONG_MAX;
@@ -2176,7 +2196,7 @@ static void damos_set_effective_quota(struct damos_quota *quota)
 	}
 
 	if (!list_empty(&quota->goals)) {
-		unsigned long score = damos_quota_score(quota);
+		unsigned long score = damos_quota_score(ctx, scheme, quota);
 
 		quota->esz_bp = damon_feed_loop_next_input(
 				max(quota->esz_bp, 10000UL),
@@ -2227,7 +2247,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	/* First charge window */
 	if (!quota->total_charged_sz && !quota->charged_from) {
 		quota->charged_from = jiffies;
-		damos_set_effective_quota(quota);
+		damos_set_effective_quota(c, s, quota);
 	}
 
 	/* New charge window starts */
@@ -2240,7 +2260,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 		quota->charged_sz = 0;
 		if (trace_damos_esz_enabled())
 			cached_esz = quota->esz;
-		damos_set_effective_quota(quota);
+		damos_set_effective_quota(c, s, quota);
 		if (trace_damos_esz_enabled() && quota->esz != cached_esz)
 			damos_trace_esz(c, s, quota);
 	}
-- 
2.43.0


