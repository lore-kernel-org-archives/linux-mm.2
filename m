Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C9A3CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 19:34:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39CD56B009B; Fri, 19 Jun 2026 15:34:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34ACB6B009D; Fri, 19 Jun 2026 15:34:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A09B6B009E; Fri, 19 Jun 2026 15:34:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E041A6B009B
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:34:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 741221667DC
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:38 +0000 (UTC)
X-FDA: 84897664236.12.9389109
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id B31801C000D
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VE8lS8lg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781897676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wn0Yt3L/+VcBwshPHSrlOXJyN82jOMXxHwXqkPJym7M=;
	b=R4wRLPkKxTr5SP/9ReVJOnu+NoT6LYyd+EzzVHj5hblmc7hRQmHWgkElfiDogkiDGbbme+
	eTARsHFyx1hFvW7Bx9FDCWotxDxJJoJlyN3joSVCXVxhgZ1jw7o/TOH0Epzy/tDhu4XFxh
	g+h16jTwLffmP4JXbbM6xvq9JnyhB58=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781897676;
	b=gfRvFwm/fd3lPlFAl41emx0CgR95UF0Y0CYVvgD6KQBVtwGLJlVkmDbQmvDkVmZpyu8wZ/
	cfW1uo+cRrEOBJh1uTejY19M666Bi32uaELQm/LXoJBx+MZRVAMKC1vo9WSlazQQA/3WyC
	1TE5VZRg3qNZL6zNxLF/estyuezCppU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VE8lS8lg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4DC3B601E3;
	Fri, 19 Jun 2026 19:34:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCC31F00A3D;
	Fri, 19 Jun 2026 19:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781897676;
	bh=wn0Yt3L/+VcBwshPHSrlOXJyN82jOMXxHwXqkPJym7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VE8lS8lgX/m+9KZwGEHGAnntHpiikNKYNo4gGbwPDs63d7FaPaZv01ifWhFO42XxY
	 ze3ccSnuoW7FbmekSGApTNtMGHJrVpJaPyYniIUMNbrkVwTcdORlVa2sImaMMJOF8X
	 eSsthRjorUaacPPI1u7tFm7/5zK6tN9kJ9IT6niYOGg8CGr5NWT3zJVUTFQKiqWyff
	 NR7i9MDqvq5qW5+LS40IZalcOVS2A9GFbVUpBU8dcHDo1wL4SQ6GUdYr622GOt2/ti
	 NYabqEFTfGnvXjGhOr6Sm0sxus1SUYKu7i0IMDpds2fL1A2kFo1ik+K9uRltEk6gkW
	 j4x7BxGm+dFww==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 06/13] mm/damon/core: remove damon_warn_fix_nr_accesses_corruption()
Date: Fri, 19 Jun 2026 12:33:51 -0700
Message-ID: <20260619193415.73833-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619193415.73833-1-sj@kernel.org>
References: <20260619193415.73833-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B31801C000D
X-Stat-Signature: ii9fa5jnipcdrmir9wqtm4fsy647rj1u
X-HE-Tag: 1781897676-323651
X-HE-Meta: U2FsdGVkX1/kpZ5D/HlichILnllBi3/UmTULVsKRNWjHdd8AcG33Vrc5jb9nfwGYlOuF8IVnE9KdSAfDqbbFOPhFAkWMejHgQmeBqAzc3/WEyEHbPrVPlHczGJlV2h22iEHJVPJEfIJBtIUVC/WQsQ5MxpXvW9v8MbQKwBfc0tpg1hYh0Nk7mzjNnr4KuengRj4HHYr+4s/ASWkTqqBKo2jFeM/zlCgMj8JRIj+4Fp5Z37rzTZgUjM9KGLHGPoEAiAXnaCJDdwndqcPovJ6it9JLthjq/0RWoULbiu+PW5U3zRXVpw6ZwliggfzAEnvQ4kL/OcckW/DXtHHHqjyvLIOrEUkGasuusEAkrWZgwFbYALB+krCvY4teGv68PsPomVWwE/1apb0Eqa3fWUMcoZ3gp0OXFJJ9cdrm8nc/0mFyQ54xuzBYr84dqnUC/DlzjnfZqJ7HZODR8NFQ0q/y8sTYEl4Rbh3MCOIE0jtuxEusYF4YgHlhgKUvyBdK1xob20BP6i4JOjCQxxv8IJEPeMH1vB8S4G82hSPfvm8ELzXL2I7KvY9Pil4kInLzLK5DGj9MtwdFG+97Es929lJBx27cUowliOLv/+JSjlmxQMs2qc7CwR+oUldkTFzZaHwsXI32lCGkGG79gt+AJmwHHAGliDlc1HyJnOxwGUrwgoMuG3dfN5CCE6c/L/AcHmLkFlHIGuhmB5oBdbu6GjL+5MSl/qeFK+CSqtTrthhZJco/BfWNI7inNIaknlOOP+Dt66yy3C03Zv9C/4/Y3/15VoSUU052uK1fkA0vn1qo5bnMd6VuhRPkqHzhpHgVmKDML5yCQ5+1jZSoWsDDpquzsbyyk6R9tuP3RKviSuMDIlnK+0dmFymRKe6463iieV93bVPScH1z+VCS+CzRAJZIBrnvH+SsCUR5aKgksGuXxn//8he3dt36MITZIoV6OIi4HuAKYSAV0vxq9vEBEfp
 hvYG3uYk
 McyMV7khqDxgoqAKo133utcM2BKvZ7ZbjzRf1IC6W9YO16pUGjoNqskKZlm52hzjihixo+gERg16WsOu+H9Ksui5A1KMyVPntAP9SbJdHpHab3OtCQ+8EHhiihOWux9rVqTwJ6bfpAUV6yExAbQtXw4tX09HDV3SKPDQfUe6BVcth+m2Pu5YI/9DohirYJ18jV1UvbcaYUZGbIS7C7y9yXIb9fZhXWTQSQa12guEXHnLzgCVgmhmEVLB7uQA1UNpacy9CeIngx4KHoSkelF7snHUGkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nr_accesses_bp is delicate.  Once it is corrupted, the consequence is
the bad madness of DAMON monitoring results.  From developments of
features of size, we historically found nr_accesses_bp can be corrupted
by complicated bugs that are not easy to debug.  Hence we added a
function for finding the corruption and fixing it right away.

There are no more uses of nr_accesses_bp.  Hence the function for
corruption detection and fix is no more needed.  Rip it out.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 2eddf2674f4fa..12d09d2f7ea1e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1992,19 +1992,6 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
 	return 0;
 }
 
-/*
- * Warn and fix corrupted ->nr_accesses[_bp] for investigations and preventing
- * the problem being propagated.
- */
-static void damon_warn_fix_nr_accesses_corruption(struct damon_region *r)
-{
-	if (r->nr_accesses_bp == r->nr_accesses * 10000)
-		return;
-	WARN_ONCE(true, "invalid nr_accesses_bp at reset: %u %u\n",
-			r->nr_accesses_bp, r->nr_accesses);
-	r->nr_accesses_bp = r->nr_accesses * 10000;
-}
-
 #ifdef CONFIG_DAMON_DEBUG_SANITY
 static void damon_verify_reset_aggregated(struct damon_region *r,
 		struct damon_ctx *c)
@@ -2046,7 +2033,6 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 			trace_damon_aggregated(ti, r, damon_nr_regions(t));
 			trace_damon_region_aggregated(ti, r,
 					damon_nr_regions(t), nr_probes);
-			damon_warn_fix_nr_accesses_corruption(r);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
 			for (i = 0; i < DAMON_MAX_PROBES; i++)
-- 
2.47.3

