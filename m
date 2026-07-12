Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FEB6C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 17:03:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 295006B0096; Sun, 12 Jul 2026 13:03:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26CD26B009B; Sun, 12 Jul 2026 13:03:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A7DD6B0096; Sun, 12 Jul 2026 13:03:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DD11F6B0096
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 13:03:44 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 53AB91209AA
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 17:03:44 +0000 (UTC)
X-FDA: 84980746368.07.1E33B83
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id BAF1780004
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 17:03:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jqnAdXsz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783875822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hhmDCI+ot7IL3VsT3pLzYBJmbk4njLZd345nGTc/fNs=;
	b=SHAtEoeXOWBfGHE3O8ViVxr6m1nxQSHv0FBFMZhzcD1ERZQtbupEG+pbAg9Nuoigf1RJYP
	RQ79cj1t/ana3V97vAn8444m58Nlkxqtpv0gFb6wBmsgBu2/o70DVTtoVIgYD44K1j1z72
	xivmpv4Q4r54dfYWGTs8sB6hF+mlnMM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jqnAdXsz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783875822;
	b=O/SjssO+DZz7brPQLA3ZeNrLLTiGZnPelsACTObODxLtsxU84DpK4ivI2mwsVcno3QfESs
	X4IFGwpD5hA4rMOM4rwu33aU0ONBGF+D/Q4sPHNqW0B2HzqZJJkbT6iU2VcZiKBoWALS3v
	fJPAZjwnaM+EyRvq19Ctxi8xvST9q5o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B513543B2B;
	Sun, 12 Jul 2026 17:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A4D1F00A3D;
	Sun, 12 Jul 2026 17:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783875821;
	bh=hhmDCI+ot7IL3VsT3pLzYBJmbk4njLZd345nGTc/fNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jqnAdXszxWlkiGPhG+kdzDqhjT1jdYqU0Tnu/kSJ3AMyLxt5ZpLy6QMxsZmv3a5np
	 N8uVClMafeRShHx+Rw7BP9jddNRBrX9cBzjseNGnUi/MihUGK3Ybddi98rHiCHQXjb
	 geQFfvghXDWU/d4XOctmwpMMxEhwPMmJ7cRocPSE64rgpaUdzqbfxeECokC1ZlazMQ
	 bqpm69Gpg0v4AhyX/xxiJ9RNhhppw32Fb+lEvftBArHE3Xi5Hoys88Q/1gnahxHqE6
	 xv2Yv81igcLUYxhiVAlzno6vOk+XCuzG9SNEw6NqV/wGiKiNXkWhQ/CeYPCjPFwavb
	 4rA9AUj3dsOVQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 5/5] mm/damon/sysfs: read ops_id only once
Date: Sun, 12 Jul 2026 10:03:27 -0700
Message-ID: <20260712170328.91144-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260712170328.91144-1-sj@kernel.org>
References: <20260712170328.91144-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BAF1780004
X-Stat-Signature: bnwjgsxiztwbp5gybhu8naa7w79j1oxo
X-Rspam-User: 
X-HE-Tag: 1783875822-271981
X-HE-Meta: U2FsdGVkX1/ORSuHzRXlsNnzsjDzit0LiKijevRQ90BIhWEVJpOgDcJRjxlrV7bQZqAgQDj2wOjplK76yPs3BLWtWo+oatUPNSqw3bRyoina+gdNj/R+yQHaUN0jvKInQZ4YHsie0pXYrLlFKu6RXehgNURkEspjSdqbLS/CjvDQUjdnTjAUQ7OkXG/XjyaqhoKzZs4+baInoTPd35S0oByVr3lI7bt/zdlSOt1ikoTFm8fPl4E6XLdSgGOp+2bmmHuHjEnh0u3lRryzKEhBY7xphnGLf0m3Q9oW380uwVgXKLpKgNzJvB/GUaYoXUdXoN8eoTw3MNKAS93MaTswLgNtasS1GDOxStwI5YTuOebIxuya5mGsboRiBOjDsyDXcTiJBl455dfqsU3UJXrXBJU0X2znC5nCiFLyYCVqWxj2LhlNA+nVNSLaqcPXuSzmFbojKKgK+dJib7Jp1ChiKq9vdQaZUEuFLCe4EjdXBMClg9Xajsbos1+0iANjyhQU8tHUmFgQXZREf73un4sy1tDuMwhk1My/5dAOte7vCCdymi9yz2nOgL46KenkIM0/Yeu0jIZLPP4zpZnfRWXPUfbZRQ4XcC9lQ5rtSHd1pL0IxxIBRKH5J4rOMz+dqZTtAOoavSGnE1uYrNUH+qX0Wta69iKhDajm+kKf4KLOM4blCWHxajI2MpzoylGyQE0xud888gSC6h7TkQ9qH1l4UcK30M/MuoYVSTUl45xMiPaDBA9IJXXySTfZrjI+5g+/74pWWhVqj68k6viqnM3WzOPlG0/vgBlkiAuXDo69zmdSMyPYZEAwNTyHICjFexUF5YsrPSmmFFED49+h+1VHBSN4oBhp+jws/4E8rxU4HE/WW//bC3Qn3D53XZ9vCVaI+7Zbym1LYnnHPDdBnenffxpB5233uijK/FvUZxqh83CCnwvMRRhxFSV3WOjR9xuWCwyd9X+g8pYMe3NFaZO
 1rK4LS7m
 AK1/q9bKzNMc2AVdLWFqQH4XAP85NROy0og86oAV9xtq4aUO7GB7UvBicCBsUr5GLylRBB5pALFy3Z9sKgoXpKuRdh+KYv4iavwTVomZ9jrH7vj3N/DKOybJVYQyVQi8lx2QiPyL/9InGJcYlFByhl453fvdkz+ibxE0FYsZqN77cwstOSIJXLWc0PqHKKxfb5hi50qbpP2oC92D3mnP8UyPxYgFiBrwikfA3/0XMjhCs5BgqV0HRjq2lwl7ECJXyGvD1PK7b4eK++mYBKjMvHVXVsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_apply_inputs() reads ops_id twice.  It could race with
ops_id_store().  As a result, the min_region_sz could wrongly be set up.
Read it once.

The user impact is trivial.  Sane users ain't update the parameter in
parallel.  Even if it happens, only monitoring itself runs differently
than expected.  No critical consequences like kernel panic or memory
corruption happen.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260703172417.95426-1-sj@kernel.org

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index b5fe036f78015..60a1a9e4ada34 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2094,14 +2094,16 @@ static inline bool damon_sysfs_kdamond_running(
 static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 		struct damon_sysfs_context *sys_ctx)
 {
+	enum damon_ops_id ops_id;
 	int err;
 
-	err = damon_select_ops(ctx, sys_ctx->ops_id);
+	ops_id = READ_ONCE(sys_ctx->ops_id);
+	err = damon_select_ops(ctx, ops_id);
 	if (err)
 		return err;
 	ctx->addr_unit = sys_ctx->addr_unit;
 	/* addr_unit is respected by only DAMON_OPS_PADDR */
-	if (sys_ctx->ops_id == DAMON_OPS_PADDR)
+	if (ops_id == DAMON_OPS_PADDR)
 		ctx->min_region_sz = max(
 				DAMON_MIN_REGION_SZ / sys_ctx->addr_unit, 1);
 	ctx->pause = sys_ctx->pause;
-- 
2.47.3

