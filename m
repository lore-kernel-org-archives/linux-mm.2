Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBEFDFF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 20:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61BDE6B0098; Sun, 26 Apr 2026 16:52:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F3BA6B009D; Sun, 26 Apr 2026 16:52:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BCC86B009B; Sun, 26 Apr 2026 16:52:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 325D76B0098
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 16:52:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E536A1B80CE
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:39 +0000 (UTC)
X-FDA: 84701905638.17.DB84B44
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4D8C1A0002
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="aTRBdK/2";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777236758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R0ZL1Ji6WIS7dxVwSBZIGd1+onjG3Qxo536vKuYH+jM=;
	b=ynQSP7+PiA0ia+JAQnW9S1qLts0kaFc3FBd9PWV5/SzYr5zc1D76u2rDFSpyELjmNMrB26
	oobGwN9bhvo76XC3TfK+2ndhTDHUVUa53XYQxqpDbGblFGBcHAT0o8KJ9IQWivVw54kyNO
	J5TIpcW/UNiIBFNIRadr3TU3l/XW0i4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777236758; a=rsa-sha256;
	cv=none;
	b=KP+MlxBM0Uw5giw78c9FWP7yQnuI4YTGWPWDg50GTPCE3MiL3nX/NMloRaE22tznC4jDLK
	sDhZy9XYiPBFPbFN4/p8smnqBKUbVExXeXl2etgc1wqobCtEUnK8vO52AkTWGtjNVcABZJ
	kpcgkbVmWc005pyJRsELIYwaT0jHvE0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="aTRBdK/2";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2FEAB419AB;
	Sun, 26 Apr 2026 20:52:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF92C2BCB8;
	Sun, 26 Apr 2026 20:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777236757;
	bh=blGlhx9hlnhuQ75ddAmdhCx+qtv30Q5dipQv2/NkGPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aTRBdK/2U3yntQylTgNKqIttVqxCUE3i+E4RHYiq5BGShm5gYKI9lXdpgIG+21tIk
	 /7KmfS3xmC2nVEkKgiFZsJuvygaXRI01ala5hy6z3ZgMSQ+DLOTrEZX+4xClsbHgsc
	 gzs9XEFLxs7viJvj585MSs59aGhoTgBLQjRmb153PNpkemLfR/qoswyWrfXLbWbPRQ
	 mcsbH30utTdYkhvxBQopPL/RhH4AKdX/W6tcjbEzyB3HK+AI0HAurxBQ/5fE7BMtxd
	 YjElo4oWhhqZOSVFxLLON9/MwmI6QCRYjFt/okmA3yjTS3o709v9vGQXLrCnBPCCx2
	 4CNfgwSSHq17A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 07/19] mm/damon/core: do data attributes monitoring
Date: Sun, 26 Apr 2026 13:52:08 -0700
Message-ID: <20260426205222.93895-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426205222.93895-1-sj@kernel.org>
References: <20260426205222.93895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4D8C1A0002
X-Rspamd-Server: rspam04
X-Stat-Signature: 8yt7ozwdrqzxu9fq6pah3kzftcengkwi
X-HE-Tag: 1777236758-795918
X-HE-Meta: U2FsdGVkX1+6hn61ibCn7dB8ISV6Vhyf6L6rCV34fkCxOPMhjhmY/0BNfA1U4CDPHzbGVI0wgjvJTvxcuAC1WBjeWfZTnM/g5R0THK3vJWVevRidOfzi3GrPdR33tDqbW9KLJNKH4n5p5MD2qauX7Cp9JH626bz7VdaAmWIdliaC9dYETGo/2oZGFbDcW4RDy9pCQSq5Y0YqXrk+ceXbmGOuYAnA1DNYC8f6LiIaESBoOVev1mZTY+cTVlu1OHvQklBWnCQpDKOaG289TZREaJd6mcfUNG6KzW1XCDWRWmKEgUOVgxcd4XuYsG3uonKrApnZlmWOcOgsh7IVC7cV7ShbeiSHRhkaNwyA7kygcUdoIflMhJgHtZ9LGA3vRr9BkQRQj33o37G+OVqOgG0Alr+XlTO2Q8ha4PaSh80Bc2jdNeIl0gYTpR9ExDOgcKjUdOuVf2CkoAhWmVOvEKr5Bh1J+10+tueWF3hKoMD3YayeF32fek4NsCj7TyPFuEgXRIiR272dG9FY7NXds6CifVeHDtO1sWR1cEnnwGy3hrIpGt07Gp5sFjyaciAP4g+tHAWEjvOYzFrsyuzbecu5gY1nfmlJQiSqvYSXjMLhH1so+4Vxjt7mjQGkWaGW6hjuOPdXTvo7APakaxbW3w9hZ8XHWKthbu4esAeDUzKqhJzm84JUhw37pj58Cwnco3NS/AbDtufVYidLKbzX6E4AffT3z14VN6e3rOKBF2n9XS9FN67b2hFISxFZNaYh8IuGxrKtdAFxRfPyEwwFO7kj4DcZYtgtFdd4MERY1FjKO/ibEtC+8ANI33N4IhVbJyi39H95Rkf+FYU+pAGadZOncG9GAYiFrTNt0MFovnxOsibr/Z5WKLZnSoHQImPhVezq2w8wYitkg9dE/nvSaIbg6UuGrDXKT1sayNGjb9OkthBQM9YoFSGnPPD38n4EDbNk3Vzc6ZQNxJe0KeX/ZuP
 4nQRAOSM
 rDRiMtHzBMOZezE40bMIOgOdlZTJK5JkgchvMQ7Qq5hhQXIoTOa4X1KYvtxLqUD8Udrv1VO41jNYwJN3FwGt+DYhjJfwWHzAmg9zU60EwIBhEdKXyK0HuiTfYpqxylZGSrXC+lACYno6/GUzVB9IRR9KZitTi+aHFodp3HjvXR+t+0if0VkdOenaGxWg3GeuCoaoiW/Cm/p2v9++Jds5NR/Ta3z6/vf197AWy3zb931jFh4Q=
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
index d4779b647a495..fe14971d72747 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1921,10 +1921,14 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
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
@@ -3288,6 +3292,8 @@ static int kdamond_fn(void *data)
 
 		if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
+		if (ctx->ops.apply_probes)
+			ctx->ops.apply_probes(ctx);
 
 		if (time_after_eq(ctx->passed_sample_intervals,
 					next_aggregation_sis)) {
-- 
2.47.3

