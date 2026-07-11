Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68662C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 18:04:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9A346B0092; Sat, 11 Jul 2026 14:04:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D23DF6B0095; Sat, 11 Jul 2026 14:04:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C621E6B0093; Sat, 11 Jul 2026 14:04:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9169F6B0098
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 14:04:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 122E09173E
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 18:04:24 +0000 (UTC)
X-FDA: 84977270448.13.94462A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 855BEC0004
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 18:04:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eq8LOAv3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783793062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hhmDCI+ot7IL3VsT3pLzYBJmbk4njLZd345nGTc/fNs=;
	b=pWf5wX0RCpIdmnHkbNm+7JkrNcs/hbMpG+AzeHRvrh+eYQkWUM5c5D4Xi5vY6zWdoNhIpt
	e5dvGtjMa8GlJNfhtGAYNMyb3VI9WXiEc3NzgOHvi5e8Fec0mIh8NMcRMCtoIT0WzgQAKf
	2xFOq6iojiddqStPegJqy8aURvoPPOY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eq8LOAv3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783793062;
	b=5GHTlWBeqG0s1eENtrR1b7i/uiTZmrO9G0CFEvQGXx2DzgXF2PV+m9FOjmEQDsA3TLiv3Q
	+lKIda9TO/Na7DaRRrEeF9koxnpe6s7K/WXVQuVTtSDUeC06qR2Hx83KKm1icw+mDy70WM
	NRT9LAbiryVeTzdymcpR/JU9mLn4bBk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DFDAB43756;
	Sat, 11 Jul 2026 18:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999F91F00A3A;
	Sat, 11 Jul 2026 18:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783793061;
	bh=hhmDCI+ot7IL3VsT3pLzYBJmbk4njLZd345nGTc/fNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eq8LOAv38/JT//HvNVNFuX9mQYVns/QjBaRg4lFD6H13iiyHwdAqqGAHzowFBfpYp
	 TQ845vSB2U/vzHnithCWeTxZHU2L4LlQ+w4ohRPsP+z26/uQkgXKJqxWwF7prLpa7F
	 v8OfWijkA7lDe0BKpuxMaLmjq7HPpxf92RN3DuqjlxcCn3NT+Gu63ScjWp2C/hdYEC
	 BJjrA9WqF1RvbnR5DP1QYEhLqbnKaftOrbc1Bb/x/+npMXPDZCH0OFnE1Yr2GL2PBB
	 Dz3LKLleFAI+dUaGDHW7S0oF1Y/p+03h9hzlCS7svr+6fURFqcY4prI2uxh8l5Thdc
	 Ihs5v09i67MxA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 5/5] mm/damon/sysfs: read ops_id only once
Date: Sat, 11 Jul 2026 11:04:08 -0700
Message-ID: <20260711180409.82093-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260711180409.82093-1-sj@kernel.org>
References: <20260711180409.82093-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 855BEC0004
X-Stat-Signature: w3hoiz8mqj9c1t48u46uiy8yjkko48pc
X-HE-Tag: 1783793062-318179
X-HE-Meta: U2FsdGVkX19S9tokKAITpZm1b4B97IPE53BLZUI9EzUNHe9xGWHyj1z+MkDStvyahpSKqgWbRbLS5xeAWHh5OrDjw1Jacu4Ov+MFTZrghSvTOn+xmq8hLfdaCAae5zmOX+yPsY8nA/NeLPYEz6M0xVPuLQLVvAl9P3vYUHV+JZVjV74nW2T8lS9R0/Q65pl+ZeWlbwkZUl9K8K7MofwsIkvDcNssjAgVkBZEhj5EOgnO30xdu33wPgKLIr5s+UAy3ywASe51z+l1WaPQw+kcc0nPzUAYQeoBgRChhYND7Av1QXjarJy5lXIbrG8p8e4VZD17zhzC/P98/mgSFTMab7wfpvaEeMwajIwX5Q2sPY1pb1VTjWZj/fa8JAz0c7munQrDN8eEyQTqpEYf94l3P+0lWkozimcl+UfLnU3SyLgH9ghMrII814Ib3uWxv8/1qOwaK00Fr7SFkPNl0b36I8YHL3Fq5uFPWh8ZoZERprkqAgt9GYYZQWxLauvKNuuND+CP799RgJYBUa6cAs4RUAf2ZWZXxoPWbDemowPHQqZD49qPIAf47cI1WgYKOd047o4fA6eqY2Lejr9CE1W21NyGkTb/FZeA5hROQx2qz2elOYzKG0NJxDGcHKssi7imlz6I9b12OCM8md6Js6sxKuWu+6WjzIbZPoEohvJEEzdFKwVnpsAUz7q7q1yyzEdkh1lIbzYrpDqgIKtkgWDfHmaMBbYFPsg1mBzCeP8Qwj/cX4OrSWWFwuLaqgmLNM3YHzfla/b135qvEvDQy+j8XP367l5gCMfP2bTgohnvL3WOQHRIlZOXbzpgWrJGMy94O196jxmNsViMt+gQUI9K8MFL6Q3ZNL+GQjehPQ8F83yJx9f/lFYALzn/gwDsa3HyzNtetpUTIyeuJLnrLsuYDVZrqf5j8HPGuGdODUur2vXKlL4HhoHcF+j+FaLEr7XEiDhrbIJJzpZMOvwFi3P
 mjpMbtky
 anbDtbSwQzdjQ6TF9Sxt86wS4+evQsV+cLMA3jUes4IFZOWo+OATsaBF5I3obLVhZIHo1+bn3m2RBcl5WbHyIKSWyqB5Ut1PV2gv72tBotOYZcV6vYcEhXzakxLA4ZHhHU5bHIaxZerYai32tnajn5Ys0kQNfanTwRByZWq7OC78ldtGnc9DeMQM1+N9gVdydWeYxobwFojJYu/XZC60b/g67KjPlokBABm8pvbwahdxgFga3INkHrEBR19ndv1AnSVoxGdMtPu/Fa9BlfzQ68ifHXw==
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

