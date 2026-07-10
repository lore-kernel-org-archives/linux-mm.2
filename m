Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 216D7C44506
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:47:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82AC76B00A1; Fri, 10 Jul 2026 09:47:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73EEB6B00A3; Fri, 10 Jul 2026 09:47:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62D596B00A2; Fri, 10 Jul 2026 09:47:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 351466B00A0
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:47:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC417120454
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:06 +0000 (UTC)
X-FDA: 84972993252.28.26282D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4121320004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QD47a+pU;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783691225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UYlXBFEEj8Bqit1WCVkStlsJk2B9S/H0owK0kWMcnr8=;
	b=es1EOnjtir6myDYBqsP5YR1uOj1CNGtgwG1eieZCyEVHjcV3zTDEf+daTdALAu/27zYs5/
	HurQhqL9k10R9FQ1QQWUdoJIVQqtouS4+Y4uWd8UA44nAd+GR8/O/KOBqhu/5Cz621CTMN
	owk7kK3Ppoq4W5uPwmzHUoJfEHNnIP4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QD47a+pU;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783691225;
	b=jUxUJTWsLpAEoeWmLLEGOboFK3+7GAZguuEXlzJnU6EwKLrFRggZpJe5e8DXa608DjoMJv
	bXBeoQIZj1Eb07QKQxwv0Rf7yaBbcqBoTF/HQAvtLOYKQIve24pqtYoqnIOsUdgcb5LWP2
	hbFbvqNY5GxaxAceIItmsticQtngTmI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D76D260052;
	Fri, 10 Jul 2026 13:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684771F00ACA;
	Fri, 10 Jul 2026 13:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783691224;
	bh=UYlXBFEEj8Bqit1WCVkStlsJk2B9S/H0owK0kWMcnr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QD47a+pU2LC+s0dnvDU7JTzIMPniYub9WoVYKsZACiTjstOYpY53RzuPKXDN16LEt
	 Nge3POqD00YI1QEp/O1DzO0Mtm6BcKmJ3GwyGrb+zWtkczWRzw1m1InFq6UG/Ap912
	 UQVhxwXCdwb8hctwebO2qFH8/EUxPNzih2nRaI5pskEEk3nGnDXjotV4IYNuuVqj68
	 ejn4421GyhreCdu3uvBhgZcKgLxr9WpL4rLuCVivIk05y6VkMPoY+cks/wLyBJljJi
	 yNbNWAy20GQGorLoNAjYUTpfOyiVSbQTscc8j8m/xadq12Li63qwNIpXXbiibK9smi
	 1bdKu6FNPdFyQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 13/19] mm/damon/core: s/max_nr_accesses/max_merge_score/ in kdamond_fn()
Date: Fri, 10 Jul 2026 06:46:42 -0700
Message-ID: <20260710134651.18084-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710134651.18084-1-sj@kernel.org>
References: <20260710134651.18084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4121320004
X-Stat-Signature: 7cqsj963wkxjwk5wony9mksuj8m9wkuh
X-HE-Tag: 1783691225-847967
X-HE-Meta: U2FsdGVkX18EPngatatM4IsX9uFeHtXvhVOeXuCRqwBg81etWF4KLLzHXABTA1dzW+JG+0svOZpcGgHxmQGPm5seXwOgoZkZMdYCCFkvuOYpVWboAdW9PiQo4tK3uTLBmIoRu/H52VZhS3ZOkzYItcDW63HiXqeQqhSfodQ05EWarLHfRXEhQ349gQ3PnfcbZX69r2G0O+X1GRk/q+i3dqd/331OgUeUHXr+1NiFi0jdf8GQbbek3ulOSLm/Ao8kCihXsjmm2/dLr1RG29JtAxeWH97UC+FEQ8pdCcvuEnHCoDzx6oOL+cbFARO8MEUAxoTWkFeRLLIFsIQs3CZMBj6qg6wqGAqH+q8V+MD+hX/eucGnKv8zUguK4wZZWK2SfGdcMPqU1nQsXXtJe2hGrAl+HCoGmc7RDpchcXApxR0tXOnqIZP+vVvyY8LfP1AWdJEpPRAxSrV6kyMb0j78RKcw5y8i95pdcVEvIpvyJd+Sohw1VHhXms2G9AsDBl5/lcEZQ2hvWYKbW336a/4r6a2g2jTUwMIrctXME36zvhY9JXRQoW29Q1q+BzeHVOfxkgsMqk2/Sv3DCkBieuMCDlD4UEv1mo7FJtTVbMhlMX3Z5gX8eDuUOsakNct5JbTqadYGY1dD439WiBKF9bAR7Ez5SUi4RsIRLtVW/ASWDz2xeRO98t5zODPHtSAjekzDHomv4p+19i7yOemVUfHRFmsiIPnUR125apm8hDreHJmDlDTIyzJiN8Z1yyjqnfKOXSLl1THMegSTcH2/Zifm5XnhO/Io//YYRwtCgAut7YArEVTthyuPfGoHUNrCloIKyj8HcdSCzJnnaYNYHlYzFtuuw5OZn73yUsnJbIKDDPwRPztW+ij2G5Q9MxSjy5gazEwP+Jd9qX4qoQSAWKeJbEv7t1v5ab8hdVD4PRdYdfIRfcREAErHij/RCr+odHIq+1Vbfr1aZJVbWcFVawa
 CanZi3ua
 905w5nV12BJcqe3HqnHyICv0aQV56cFvTlbWIZR7pyG5JiYxil/eJD+6WlNAVY6BnQE/5SnFJ99eGTwm3gmnWAJ39DTbmGI2VVKCwmp7yOd7bG45xkwDK5aUq3t5Se6fgn+HaQE3mboUIvgOFw+pQ8n+e7BrjEsHolOTq7YsY6TLQ00xwtt0kMUh+27unYGsrHTpyfXRyrsdeE+6HvZrM7J1FUGQhlkYyQuEMi0unnUl4jaCG9TH3NApwGC/KFRptajfizj6nm2qQloMCHobGBHx/QQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When probe weights are set, DAMON merge logic works with the probe hits
weighted sum.  The core logic is setting the merge threshold based on
the access frequency, though.  Before using probe hits based threshold,
rename the variables to look more general.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index dd0612e1a408b..f7782c69037da 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3730,7 +3730,6 @@ static void kdamond_init_ctx(struct damon_ctx *ctx)
 static int kdamond_fn(void *data)
 {
 	struct damon_ctx *ctx = data;
-	unsigned int max_nr_accesses = 0;
 	unsigned long sz_limit = 0;
 
 	pr_debug("kdamond (%d) starts\n", current->pid);
@@ -3764,6 +3763,7 @@ static int kdamond_fn(void *data)
 		unsigned long next_ops_update_sis = ctx->next_ops_update_sis;
 		unsigned long sample_interval = ctx->attrs.sample_interval;
 		bool access_check_disabled = damon_has_probe_weights(ctx);
+		unsigned int max_merge_score = 0;
 
 		if (kdamond_wait_activation(ctx))
 			break;
@@ -3775,7 +3775,7 @@ static int kdamond_fn(void *data)
 		ctx->passed_sample_intervals++;
 
 		if (!access_check_disabled && ctx->ops.check_accesses)
-			max_nr_accesses = ctx->ops.check_accesses(ctx);
+			max_merge_score = ctx->ops.check_accesses(ctx);
 		if (ctx->ops.apply_probes)
 			ctx->ops.apply_probes(ctx, access_check_disabled,
 					false);
@@ -3783,7 +3783,7 @@ static int kdamond_fn(void *data)
 		if (time_after_eq(ctx->passed_sample_intervals,
 					next_aggregation_sis)) {
 			kdamond_merge_regions(ctx,
-					max_nr_accesses / 10,
+					max_merge_score / 10,
 					sz_limit);
 			/* online updates might be made */
 			sz_limit = damon_apply_min_nr_regions(ctx);
-- 
2.47.3

