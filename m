Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8B08C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 00:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2D576B009F; Thu,  9 Jul 2026 20:24:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8F146B00A0; Thu,  9 Jul 2026 20:24:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A53B6B00A1; Thu,  9 Jul 2026 20:24:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6F9556B009F
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:24:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E48F2A02CA
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:04 +0000 (UTC)
X-FDA: 84970969608.01.48FBC05
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6B82F1C0003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mmw8spaI;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783643043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gcmh3CO5nLFI9rnEGlo1ly2IEXcDgUHS1nJW1mHJiU8=;
	b=B5ukhhCIHvGdZFltsJobEAgYlMeHBTuK2DMfV7bvBzT2CayfRsaTBswJmq2FSqtZW1WTh2
	ML2K4vVcKasLjll1DYf2BnEB/9ihgxJE8aAufYbS9SJjliras5NzHYMOJMoGe7qC4TwkCT
	+sYawRn6ArzHgHRrubmXGTug++LAFPY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mmw8spaI;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783643043;
	b=E3bbrZwsQEH7RL+AXKxapmDMRg+JKmmBB1JwRWbyfLGlSHFMOMtg0VEAycZM5dl6sXwxzd
	3ZINk7UVNPwvjN+8L+SV6n4hD04mtz/NWx9qxhfQKQ8uTQLd6xlCWvfIyakL/BmdkoqPae
	Jjk1PXvVBtDfFHfxXn9Rwt2kcqHPQaM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C30E445044;
	Fri, 10 Jul 2026 00:24:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC3F1F00A3F;
	Fri, 10 Jul 2026 00:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783643042;
	bh=gcmh3CO5nLFI9rnEGlo1ly2IEXcDgUHS1nJW1mHJiU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mmw8spaIEiOHr9fuXewgQ8ToRh/yCTyAG1cYvF7+JCpMEds1D/AgzFKm1EW0R3dbB
	 YHKLnRgSQjp2A9/HF78rGjPsPkUOh9R8zmpM11+eXCTetdfcz/CRTew1GOR4qHraBe
	 wHRzLCqG8yN7Nrs4Cp40EL5uJq6e6ZR5YWDi0jdtPrINW9R4+EK92MFdQ8Xy+rJw5q
	 8k4Pkg80HldkibWY6dbDO2hKJP/ZqUZ+x9YTOeMUXOompcFi/M0XrcrgyVuqQnWajJ
	 b3rNwM4Y02UOhymsFoq/80ibELZMOLGooxdr9Ruk2FvBIIqmDkbEFDmBm/oH+uifXH
	 T4+6pMdpIloog==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 12/19] mm/damon/core: set samples in apply_probes() if probe weights are set
Date: Thu,  9 Jul 2026 17:23:38 -0700
Message-ID: <20260710002349.111414-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710002349.111414-1-sj@kernel.org>
References: <20260710002349.111414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ostpfbiu3or5tb1wcb6y1ukxs19hbyx4
X-Rspamd-Queue-Id: 6B82F1C0003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783643043-471649
X-HE-Meta: U2FsdGVkX18guW8JGcD1bTbJjvGhu7HodRGkzosf7lgFbIVLjJmCU2meBQ51JXtRw646NrIMpqfrRWzLZy7m8BecWd3/eB7DJG5Lgp2TakshsAeIH9UNd5xUcvdsKqXefj1mmkiYfA6SUSJwivWcjNcNDxa7craE1YBcGKcYPZMGmpmtEoeCF7aglL/yd2C1ua58Uat4nIgIDQh+1X/fRca5NfqILmdEAsesjKvtdf3v6W4zNsPZ4GuwH/DRamUdhYmIAmPeqznfmju4+nTNQkDqpd+4lsZgxYdmoLt8eU9nxq8YnWDxsvluFTY0hY38sdeT99wVYx1lb1TAOB9TlOFNklK4rXdT6aKVNFj7Xo814d9MwttQh1RamxBpm/a6jfdNx0u6liL6nFSH4puK0mCEWZQ7NTzRGwYpVsvybSBlVGmHdfZoEtC1sjO5BA4Tx3D/dXbeKzhr0seat3W4fma3jEi4Y/ptCdj/m/ZMmmDUxbyfS0cwrNwjPO425qgYLS8rWfrJfiyK1kjCzAP2C9gEds7uW4ZgBNSngOJSjHuVw4+kW5AUDqMRlrxrhEWwPjDiRLUeETsBid94cIVlzH1LppmRLC/nedqotHXG2GmxMRclEr74q6BHihZ8rKHkywVtA31G5RIZCINW/8wULFo3OgHzy0b7Xa4PIl3SrPqsP8OMrj2p22M3P9r9v9g0hpYtNRwQ4aytf54qdwaWA2cirxCgWRDw5d4Y3SfmTlO4riL4VS570Nmn7ddl+RkVIbD0V3od8ub7v6x4PiG6BDxtzd5o27f/+6l7Eew/9kcjRC/6ovbkoHuSTlzOTISEC6ghbJhnONZ9EmFS2OY2OuIDeSd+kGFNIY9a+PApCUjlIIOjxyX+zxEQDOHPMb6TMcLhZGp2JZHzDbv/R3AnmTnfjCJdeeN29y5zy+nA7ePBruHQGuRkdDkHP4aNhKmMF0teT3s3u3ae5mpHWMl
 RYwJ8EiM
 Y+fLd73zC5dz5rBaABNZqr7sVZA9fiENx4ph52hCFa3fXxwVH7Mev6ipM34M25NMSK0SVomAy+p4g0QqXWrNOh4LmORePcR0Mn59mIeZGQad1rzdTY40wgXnPvBsvnWCfb//JxzNvm9obnE+Kf19O8r/uy3rn8ruDKI+NR6PUWRXjVhJMAFw/YuUt0fFVgDXP4Milqs9CiALE5y3yI8K/b5snmS5ijJrMSEwTpBlIhhCQ55ZaF8prU/kB9x9MLexq3zPHNB1LkK1gtbJ6aqVslSy2eA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When probe weights are set, the prepare_access_checks() ops callback is
not invoked, so sampling addresses of regions are unset.  Ask
apply_probes() to set those together in the case.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 65f91e3b58d2e..dd0612e1a408b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3777,7 +3777,8 @@ static int kdamond_fn(void *data)
 		if (!access_check_disabled && ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
 		if (ctx->ops.apply_probes)
-			ctx->ops.apply_probes(ctx, false, false);
+			ctx->ops.apply_probes(ctx, access_check_disabled,
+					false);
 
 		if (time_after_eq(ctx->passed_sample_intervals,
 					next_aggregation_sis)) {
-- 
2.47.3

