Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23477606A31E
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 22:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OS8TcZci
Received: by kanga.kvack.org (Postfix)
	id 452D36B00EF; Sun, 22 Nov 2026 17:41:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42A616B05B0; Sun, 22 Nov 2026 17:41:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 341936B05B1; Sun, 22 Nov 2026 17:41:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 14BC26B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:41:07 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8BEB38047D
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:41:06 +0000 (UTC)
X-FDA: 85464226932.18.9AF2A55
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0BC5040006
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:41:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OS8TcZci;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795387265;
	b=f9J6ce9fHwwsPYLE7R/A8uNBbNaDyDa7yWBBOgGRkH6yhoKmcNj2xaHLa9Jh3BFLeeZJnR
	fipP0OzMWPsRl8GBmgjqrxUK96TJkQiBAJ0nrM1vyvxyXM6KprhPSnXt8cacym5+VXUOsu
	LOZbbj8qBFAYIGH1jMvWwapnNhFrYWA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795387265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sJFKXYBlyKsjrymChPkVlwTwAE7JP3i6GsdhQ8/eAqU=;
	b=bWK2110IFInpGq7XwZuJJPNtgCijFAc53VdeD8ndbdXDKJm9isv+W8EGRIK9zPow27EieG
	fmnmnOE0GG3Vkhq6SGEHbiEKP8pJk2iOnDsVG/FF8MCq8A1rt/9BDaRhD3y7xBKYRohNZD
	tfrqPBRh3ASWog5Adw+VArdYyU3bgiA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OS8TcZci;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 01F7E41786;
	Sun, 22 Nov 2026 22:41:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3B31F000C0;
	Sun, 22 Nov 2026 22:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795387263;
	bh=sJFKXYBlyKsjrymChPkVlwTwAE7JP3i6GsdhQ8/eAqU=;
	h=From:To:Cc:Subject:Date;
	b=OS8TcZcihfSP+khLyNygpchK1BCLDPefv4GAZhdMrw/JnZVxFTB5QxsMq7x4VD0IO
	 pPJDmxdONZVsBOw2JZUD5cwr9xfx5VPu1fEsZ3EqcYn6cM4s9+X46gp2wGRoWaKed0
	 Nl+hLfwGIXmi21TSu4VAR53a/fRH1b43E8Qow90EqjP5CPUCkLvxdiM5VYAo8XecWl
	 RnA/BTHEtexTTmUhfcgPcNs3wZ/GnbXVP4X7FayxyIPCM8GjDW1j/O2D9nztkmtfxr
	 f8Hd5M9hA+1LfntvHkn/CLoc573hHYJQts+tPQIZv4RhH/z1ooGe+hLindixxoqndS
	 2AGCt6hhFskgA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [RFC PATCH mm-hotfixes-unstable] mm/damon/core: cleanup damos->walk_completed in damos_walk_cancel()
Date: Sun, 22 Nov 2026 14:40:53 -0800
Message-ID: <20261122224054.79767-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0BC5040006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: wy5kgncixuen1a5cp3ejzkzondg34tzt
X-HE-Tag: 1795387264-88241
X-HE-Meta: U2FsdGVkX1+0c7TONJfuN7o3/uBSG2OrrSqIVxI+wqOgSPyji54BVbi9DZJWGeqCBdLFSW6wgTJFE/IlLxk8Upwk3VoV86DKlz6ey270GEiya0awuH7V3trgBdFZXJfgAwT35O1nPEdf95sQMdePfgZLwzgfGx5C3AmXpCa02Rs0kMAv01hh8xKXS6aygiW5cw1RJ/VUbpzCeEeB8vG33J2WehtPxbknrYDeXuntLZMLYNoHvMfnPJcErIz/46mVCWw86IeXi6Q+yjYS5dZqe8GuE7rYhklZZdsnyDDRl+d1XILZrQ6GsgG4CG0agYfb0A7BjWUPIykTlP7rch48wjvQ/7oO4lNEiiDgR2+d1vo7nI02qiLDby2yvvjXCHvaJEHDxuyP/mRsnWmplfwkEQ3wg6c8KQhjJvlxY8XA0OcIL/uRZI9d4B7cSN6fu1FLh7XUcujWfi9f0KF7LLB9/tIkwzOMz0fObBE4vIx1K0yZ2yYGC+9Ha3HGkze9aHKaYrnL1HXgxdLM8JxV67zlrf/Rg+li5fn8jDn/BOIXwOM5A7LSjVBfirGusqvrY26/nuQKNG9Rz3g2x9CArbAdaFeBJZmXwfLnRufY89yM+RjQRydUjDu5esuzO3ueYnZ7dnNGM8RbxoDl2PPscA/enL1wm+xmOx/mi9zgYEMhlOtVx0qN6jA7ZubkJ6PAjVIfen0w7yqg3120i+edGpo6PrwC63R/RO3Il867q5MREM3vG5+b6g264JZJN32ETiRugWNy+F2d8PLYtvl2f2xNh4Kn5WXq5XTya9QpFHQwcQxRd2niKtOxNWLuQzbzx6YgQNGITQopbRaA3syIYIvNgMyUJsd3vJhd6ReZM7SvzB9fDLE88pVI5E8z4fnVWqAg2YBFGpWU8gzAYYz2V00XXjdLJnoGk9Ga5H68tQgdTOTBr7mNlp7hDzvmRSosvCb1LMWvrlERkSvc2piQO+A
 VKD6qRmS
 oEU3Oeinc5aaDLvDKHCKi1FNQ8CtEFKirini0NPmd5+9sNfjerJz4ZcDQeGBM1EmPutOecHHHJwdgI/hCk1/c13xVXW3OPv43kkKrnRRrGl+hRzb/l2xcb1IvSIrKc0Z6JSuz6ryQ95p4XpZ9UkYhcUBKcjp0eo6mGXe3teBmy36DGKPHlpDiRtNJLbAfcaLprlPkpz58Nxzjgz0TfqJZ61S1l5lwsSkY1Yk7+a9ctj0pjTxqAeeKAl+LJXvrc4rnwzb8dEMj9IDlsAPcyQMYEHHWOuvuJzdNpLp0fiYC+UWVqxb6MTrRL5fTZuWdQH7+FGn4OayP5YFl8M80JrIP3fE6YM/2sCNeiIP20lz10daf/l0vp/WW2Kfy3N9222trEecPmh2vjhQnxRNt2Hy5tH2J2Vtft/cSbqjviqUoC4MV3FFEOqCNNDWR1w4tnwA65TeJbDxMaXp8d56/cigEIyVXu0uRrIsW3HNPHKUuMrHz5qKxMMVSi4+mkNLC+TGGgauPT1EgirJNgSF9QOHEeMrKpc/o1POIwG1nm8u1QTzWuNq0Do64B0OJ9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMOS walk could be unexpectedly only partially performed.  It can
happen when there are multiple schemes and the walk is requested after
the previous walk is canceled.

The expectation of DAMOS walk for a setup that has multiple schemes is
that it will walk for one snapshot for all schemes.  To know if the walk
for the one snapshot of a given scheme is done, each damos struct has
the walk_completed field.  It is set when the walk for the given scheme
is completed.  The walk skips schemes having the field set.  It is reset
for all schemes when all the schemes get it set.

damos_walk_cancel() cancels all existing walks.  But it does not reset
the walk_completed field.  damos_walk_cancel() can be called at any
kdamond loop iteration.  For example, due to DAMON context pause or
DAMOS watermarks-caused deactivation.  It means that the function can be
called while only some of the schemes completed their walks.  And users
could request another walk after the canceled walk.  In the case,
because some of the schemes still have walk_completed fields set, the
walk for them is skipped.  As a result, DAMOS walk based user operations
such as update_schemes_tried_bytes kdamond command could show incomplete
output.

Fix by unsetting the fields of all schemes in damos_walk_cancel().

The user impact is not critical.  No crash or leak happens.  Only DAMOS
based monitoring results retrieval could work unexpectedly, under the
certain setup and the race.  Given the best effort nature of DAMON, such
occasional monitoring quality degradation would be not critical.

The issue has found from the Sashiko bug database.

Closes: https://sashiko.dev/#/bug/linux-228a4c52-0545-4c1f-90ce-41114d8272e9
Fixes: bf0eaba0ff9c ("mm/damon/core: implement damos_walk()")
Cc: <stable@vger.kernel.org> # 6.14.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index b8678a53b0a98..ec7f20b7856de 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2699,6 +2699,7 @@ static void damos_walk_complete(struct damon_ctx *ctx, struct damos *s)
 static void damos_walk_cancel(struct damon_ctx *ctx)
 {
 	struct damos_walk_control *control;
+	struct damos *s;
 
 	mutex_lock(&ctx->walk_control_lock);
 	control = ctx->walk_control;
@@ -2706,6 +2707,9 @@ static void damos_walk_cancel(struct damon_ctx *ctx)
 
 	if (!control)
 		return;
+
+	damon_for_each_scheme(s, ctx)
+		s->walk_completed = false;
 	control->canceled = true;
 	complete(&control->completion);
 	mutex_lock(&ctx->walk_control_lock);

base-commit: bcafbab5174a89c3f689e458b5114641a0f68032
-- 
2.47.3

