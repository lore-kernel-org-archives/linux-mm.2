Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73DF3D5B87C
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 07:34:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0FC96B0005; Tue, 16 Dec 2025 02:34:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B932F6B0089; Tue, 16 Dec 2025 02:34:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9F376B008A; Tue, 16 Dec 2025 02:34:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 92D006B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:34:48 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3F3301A053C
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:34:48 +0000 (UTC)
X-FDA: 84224522256.18.A9CA6BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id C7B1B20004
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:34:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ci7Psk2J;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765870486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WKt+IbMk1v1Py25PGF5FhLvPU41OMXZRbBIOzlYuWcs=;
	b=U9SuZ3hJORxYy1rkOjqVPsz4Pq4hHozLzb3vs5YUsvZzZ+cVh/nU/TXPWs1ihxAlUyGy7G
	4T+eFvA7WGCiKT9PDpiFitMt8fXP9ZHQitGxzF/6dTy+ZKkyUPN9xZY4Q90PYLrELdIqyg
	VoGYazdqx/tRqpo90MYOwWzFzgEbdi4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ci7Psk2J;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765870486; a=rsa-sha256;
	cv=none;
	b=nyRceltjLgSXhMOgLeEABweAEjj5KQmHTMcV3QC6A0sNckC3nZVLpX1pjkE2pp1/Ld5c83
	Ps4c4ebal2lcatThroPJpgWc6kcS8q9IVdCGlhId1h5UxI4sDXokb8mfgQSNsAogagmvlx
	9yOhoqj7u8o5yHxXq/TcgPFBR5/Aelk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 02A666013F;
	Tue, 16 Dec 2025 07:34:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F442C4CEF1;
	Tue, 16 Dec 2025 07:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765870485;
	bh=cTgue9oJHs4eyHA2WXBqYnceUZkmXFS9QudKYRO1wFg=;
	h=From:To:Cc:Subject:Date:From;
	b=ci7Psk2JV2qnpdhmzfWPlqe3n9/Dvz3YMfCGZyhc6sYAsEPHvU/gN+e7x8ukEEzMI
	 4opHTsmMY/ycriAGRoWPL/58OBXAkM9SWbm1OB1vgBuRYols3nXjgHvvSJ6+a9YaaK
	 xNtXs8WVMuCQNe1Y482LuxFohFTchgIOlpqVGR80UzSJOB5Y56APcs8CbOL8x/yt0o
	 fejRiDJC0stHwKakTkCmRHBsotsiUZsjRlV05LGn1SrxXNNTBgvcDOyZn3KJjEy63h
	 hHetDnsiCcoV+CTz5alO68+HKlAH6gOO/qWrQo5Gd6yTx+HdBXmRUemLF+KQpfUXp4
	 lASEe+JbBWNzg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: JaeJoon Jung <rgbi3307@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH RESEND] mm/damon/stat: deduplicate intervals_goal setup in damon_stat_build_ctx()
Date: Mon, 15 Dec 2025 23:34:38 -0800
Message-ID: <20251216073440.40891-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C7B1B20004
X-Stat-Signature: m6o4pzmu638tbzw54y6f5ikr8ig58qgy
X-Rspam-User: 
X-HE-Tag: 1765870486-734208
X-HE-Meta: U2FsdGVkX19oLK07Vu99AH6mAv1tiW2ra4xc8cu0SaOfH4V3/+7lDG3gRzP9TZE6iqdPvfhd0vhkAAPtzZowd+lPTNFJ7tpe+k2MEFspvcLo7AOr5hvuM+3eJzulktch/9dBT4813dtUwYUz1hiSOb2hYxPJ1ZLe/5DJVRPu6lG9Ys2/ZsWftOawgHydFlCR2xaJx7xxUvaye40HcQvYqEtSQJlMXtsRel7t08YIJU0bnvBXEPEEZ1i846gk7Epw8MjKRpQC7d0/pCFX97HaE70nRNY/DTie0OwlpLDwKfY6C3Sq6Eg8iaEJizJvuF0R0KAnloG2q6eaf3/lFG3CRycm1OI7Sw0I3jBjEryNxyWgbNIey5S/ubueUQELewKJ9IbvfmJVUTBTPEuQVkOetZQfC7fFKVDANauem4NbcWfFUSbaMp3e/zOQkByLQE6C8Fo+aM7UG0czmHof9zdVgZY8xMYmuPYBU33nUhCskv20maJgElsW/q+kzglXL32WcD/15Lhm6DcEkbPOYfQ9SptXYTaXfR+EGPsJ0J71Q3xwWHqMLhxziuohIPNTCmvyewKdkXdu8/Dg+0OvNF244zPkBZqUdzvSZ+O60SarYCtXo0hMXfmGTmL5caXILJID2QX9wItJv9xI/S2lNT7zBSPWyBsE0EtwwZurWGogeH53VWd2DAoNqKVlq4HwaPei0Zy5z6/umOndObxpcV9JM9AAP0QTghaGhNCJc9sNUjIPuGoiuwCz31sQraAe/o6h9ZOVbLVxJDTEbAPanN+zM0fr5Zf9r7a3EHdjIvZzAbJBLjB/XOHaHbALeYFjheu4DYLyQ0QX04JlBXNZT3O5629NDYsf8A9cPflA7myHPCvhQU7Dvi05Ae+bxOdMJhQw3sYy0Uo48YOGH6R8qNDRO+rKvRUzu42KebSR3waDgSEQEIFmE+n5yM5RfaCi4lRpw6XRwiBgh5E/Dnib9dl
 eOqQQ3dg
 eN/YEaRrNgLx78nOhkH/83ZQx6u46JgNeP5/pHWQd0+vlZPZzeTLk4czNmcsQ5QbZdWb1i20xUpXCt4Djzzm0g4NjgYQL+U4otoMjmEimeYX+x7rjD6LnPyp/p15K10XNb1f7iEjSNc+A+UoUGlDKILN8Qn+if1iYCROFhS4/rQ/sOqdyJueGQ+dzp/Y81FdgN8FbkOQ/bKF0HKem0TbbVGD/frdbu/r5Q0dmL3hQnErGI3M9YL1Taiu8RuxGjWe7KgVbuQx5ssOlDENc9nY4Jd3lSSbw329nROpocMV+VgbXSftAONHftAGBRXxHU4ltmK9tc+C5uTX6nNywKyxnz/kNF48WxUB3+MYOHtbJJL/zDtOFFgg78HZM1znvpG4hsoQI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: JaeJoon Jung <rgbi3307@gmail.com>

The damon_stat_build_ctx() function sets the values of intervals_goal
structure members.  These values are applied to damon_ctx in
damon_set_attrs().  However, It is resetting the values that were already
applied previously to the same values.  I suggest removing this code as it
constitutes duplicate execution.

Link: https://patch.msgid.link/20251206011716.7185-1-rgbi3307@gmail.com
Signed-off-by: JaeJoon Jung <rgbi3307@gmail.com>
Reviewed-by: Enze Li <lienze@kylinos.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/stat.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index ed8e3629d31a..ef0a1195a584 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -173,14 +173,6 @@ static struct damon_ctx *damon_stat_build_ctx(void)
 	if (damon_set_attrs(ctx, &attrs))
 		goto free_out;
 
-	/*
-	 * auto-tune sampling and aggregation interval aiming 4% DAMON-observed
-	 * accesses ratio, keeping sampling interval in [5ms, 10s] range.
-	 */
-	ctx->attrs.intervals_goal = (struct damon_intervals_goal) {
-		.access_bp = 400, .aggrs = 3,
-		.min_sample_us = 5000, .max_sample_us = 10000000,
-	};
 	if (damon_select_ops(ctx, DAMON_OPS_PADDR))
 		goto free_out;
 

base-commit: 1791b1de223b928dd1903984344b64b8148ca671
-- 
2.47.3

