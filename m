Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAC71CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:09:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82D4E6B009E; Thu, 14 May 2026 10:09:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 742AF6B009B; Thu, 14 May 2026 10:09:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51FBC6B009F; Thu, 14 May 2026 10:09:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 33FBA6B009B
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D39241205B0
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:23 +0000 (UTC)
X-FDA: 84766207806.02.C36F81A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 41ECD8000E
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TSxFk+bb;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cf2bdlE4ziVui3OtGWtYzeuLdctz2fJM7ipSuN6p8Y8=;
	b=iSDmtIdMqx81DEeiNL3tQbmvjGlIXeo5fP/ee+IvemwhyVUjdGOvEajb1a3EY8ZG0wmoKt
	VD6ABOur/mGRSmx+PC3LmLnQMrxyphtJhfiJsTlU703bYGO1OSdIwm+q3EQ20vR1XgxCSJ
	BtjF1skFr8kiGMA0SeY02K08tEKUjWg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TSxFk+bb;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767762; a=rsa-sha256;
	cv=none;
	b=AQMKOpFJX424vta4oqgyWbc+PhplCAMXfG0NHSOFSkYiRDq7ajcOviGVZyTkDT9bjgOKZW
	qvSjGM+aKIcdtu2XfkPLJDKm0p6ToQRKnOMxXXyIG1ebW+knQxKScsr/VhyImOMOcbDXfI
	WwMNhAGTSa7UkDudiM4Wy53I+PUVwa0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B80E044534;
	Thu, 14 May 2026 14:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64246C2BCC7;
	Thu, 14 May 2026 14:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767760;
	bh=SGvDGH8HeHXn8zTVaCZsyhJzQGptwbmD0KfHLczQ4ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TSxFk+bbIJ21MwYKBtiVCAORutbQ0qsh59pDgQMMBT6Jjm2t9L8OffX/GZ3fEqHpn
	 J7LxEhj0pPWxKuLFSOlUSZEtTC1YUE6XsusV8x/g8X+2m+it5qU0b7MSzmFcrnSx2d
	 2GJ5u/ivLnq72A6gIsBONUtwAlaJrtqU2eQUPoo7fUxDwRlcCrE2epC2YCdHuXZoCv
	 Lb418mWzR0q7ApNNOppcHUMK28BlQfF3elCubjVvpJ9M5r+adADmphEhjswa8yCin8
	 FU6oz0jdyfLF10poeCbdzylDNZiyCDld43ltKUQgYDTcIHdV0M/IsL/8wRlnPDrPi/
	 xpwlRpY30sbkA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 07/28] mm/damon/core: do data attributes monitoring
Date: Thu, 14 May 2026 07:08:40 -0700
Message-ID: <20260514140904.119781-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: <20260514140904.119781-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 41ECD8000E
X-Rspam-User: 
X-Stat-Signature: 1pkpq8rd7nnxsqhucidwr36mskryut1a
X-HE-Tag: 1778767762-22681
X-HE-Meta: U2FsdGVkX1/i/0UpvsVdiqXBHZQYoZbT4KfkG2Gr/gWfNyUepg+cQ+voL11Be8f9xvx240vPlhnHCoKNMlRIzOgJtAydxK0Wwzm38CyQAUOCDJuRJ5y5UsfZwGJJTTPT/3atX3LryWUhdvPOYCtqSduPvmeOgpnRUu6PM/ktHfZ604M3/a2d2II2NGW29G0ujd2sBXRm78PoukeYcdhKFoVW86f03Ck9ZuYPr4yuRf8Pn1hLKIXVIzZjEAlPed5kbwzBb8UPtBjsRCePYtianBue+aRBWTgs/YsWxOcFJHsBteP2E8R+CsrifcoDH4Y4FDysmyVFhGyqa88MwbLID1VWZvviGsziLKI48Cr7obZJEsAaHO/juWtYVqrWS8jI8swzJ0tRnGfhPEmYn6UkQecfCWs6feGJU33B1jzMMixnhFDCCuzSW4Hrqj5+yehHIqU6Jw2NihhDSAwp8vjahgzsRtqzSkw1t3MSIXMjbuEy1g0UQWenWDJ0bGYqYxXPVWlnqEXPo8aodTX7r5fZ0+RSZxHmyPtaoqj+UIUG1cFLzIUZJ1LOEMB0FDgeaajcp9Xb8/Fc7PtbL0W/snJ/hcVLRdsK2/7gphkdCfJi0+ZQV7xVAaznitmv90Z9+caEWmdgVr7Jiz2RX5c2vfQGd1M2g7gEUfS9sMGvRNJ+DgHt0vCyqa5aV0bM3KGXvANnDb+0WLy/FXNeFXXmaC9H5oHuwgbAXx24MP+d9GL6DphTesv+1uHHVwrt77QDo00vgXs0Sro9QoezDiWR1JkdFwFM3WEdziltNZUqBz+tC1sIYzWxNlLFKfC7SV/blR17VnfezEmU9gYze4xtE1uIvrVZvqIPEtdTIhPWoxvsU6nITjg2jJEWhmkAQvM5y3Q/QPLwHovzfyupe/K5zZatQqR1O2NnrkGn3WqyTcTFSYjhqcxGnsFuLnWBj+Kztr2nNjCBnzMBfHTtIvrjDvh
 D9IqAnxl
 CfAhmeh+BSK4uuoMB/Ht7MHfxUJ8auw2Jc17kVmqnrUZgJODenK6AmksUzMoY+Ty+GhJzsJLag6aTKy2fz57aj8dpMbrPu1vFdncIW2o9SnVcUlGlt2EmyDZv0gQLLGGzgSPVaxQbAjtKKYl5TYDWQz6v+djCqzAvFZPbAasZpmgbMaTCUaczBC+4vlGGwHhu00pgRueWl9QahTV3D5ppQkMcVXgFDP+XIH3OvHl77TJwHqg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the data attributes monitoring execution.  Update kdamond to
invoke the probes application callback, and reset the aggregated number
of per-region per-probe positive samples for every aggregation interval.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 72acdeb8c478e..fe6c789f2cecb 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1910,10 +1910,14 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 		struct damon_region *r;
 
 		damon_for_each_region(r, t) {
+			int i;
+
 			trace_damon_aggregated(ti, r, damon_nr_regions(t));
 			damon_warn_fix_nr_accesses_corruption(r);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
+			for (i = 0; i < DAMON_MAX_PROBES; i++)
+				r->probe_hits[i] = 0;
 			damon_verify_reset_aggregated(r, c);
 		}
 		ti++;
@@ -3400,6 +3404,8 @@ static int kdamond_fn(void *data)
 
 		if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
+		if (ctx->ops.apply_probes)
+			ctx->ops.apply_probes(ctx);
 
 		if (time_after_eq(ctx->passed_sample_intervals,
 					next_aggregation_sis)) {
-- 
2.47.3

