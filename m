Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21A5DC43602
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 15:56:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 314AB6B00A2; Sun,  5 Jul 2026 11:56:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2781C6B00A5; Sun,  5 Jul 2026 11:56:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18BFA6B00A2; Sun,  5 Jul 2026 11:56:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFDA46B00A3
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 11:56:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4BC301670D1
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 15:56:08 +0000 (UTC)
X-FDA: 84955174416.09.0AABED6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id C4C2C1A0009
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 15:56:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B0KOOB1v;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783266966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z4feI/qU1SbwMydOJY76MHjKjfYHnoO820guZYu+4uI=;
	b=GqlaVkQdoMBx35Uq+RlXaVLbhVMCu38FsLieytSh1Fil6dlP7apUGBj7HCSTH4/2U/O0TN
	yCS7HkloBBeavtxnXZQZC2gcey/ZJzciJHInqNmmmBx0TyR0pWbi7Uz1jIXoJdER/p0Xdc
	ERT6KGCGXtEUxwExZCGCO2KOhsr1RNU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B0KOOB1v;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783266966;
	b=PVtEPWfDS43JoofxBKe3tMZ5h4mpNRX6oLEW8Iz7ek/bqxwPhSBvbX16c10xEhtO2DADVR
	mDGskvNd7KJ1MU1/Eqwj7L99B0kE/39/n3tBRXr8IqVA4uyuMw8DXnWKA2gqkrUd0Qggjr
	RWdPqaq/aa76PAOV5k458ApsqCk+ZvU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A3146138A;
	Sun,  5 Jul 2026 15:56:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2C71F00AC4;
	Sun,  5 Jul 2026 15:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783266966;
	bh=z4feI/qU1SbwMydOJY76MHjKjfYHnoO820guZYu+4uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B0KOOB1vokuwb80M4eI7jlPbhSZfGFRBd+Dw9CLV57xwAGfJHlTnfX+eM+xLnASqG
	 S0Btv1Ykwk3sSzloClyfGKdCOMFgXCY0mC+vP9zbB1bKt5T3364+sTMduxm+FNRyZf
	 o44W808vD0BwHDU+4d7iuQe4CfR7+DMCGPwxCHGvV04jJKc6FXDUGijAazry20Xj9V
	 qw/vk2nA53vKZ6SsiAQ1JN1eGHE2ZGYTme8CB/SbTty/TWcncWUyMQPwB26aPaywq2
	 Oq6KLUwQE3PJH72GtzMlUePxyfmruDAYZGWbHonJnC6m9U8/wM9o5jGl8QZC8zndTK
	 q6BQYZoE1y1+g==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/8] mm/damon/reclaim: remove duplicated min_region_sz power of 2 check
Date: Sun,  5 Jul 2026 08:55:55 -0700
Message-ID: <20260705155600.96555-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705155600.96555-1-sj@kernel.org>
References: <20260705155600.96555-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C4C2C1A0009
X-Stat-Signature: 1hmt7wyu8t8p6gzr8uz5eja6htodh8xk
X-HE-Tag: 1783266966-687617
X-HE-Meta: U2FsdGVkX195dOsGPwrzQQXOfEN5o9mU9mFyhS7JBHk61PCUauaq3Xbx9dgSM23RVFyrcQ9oqcg6ZCbvR8zaE9grX0/Rl72cFabeTHpnlNswr5n0J9uvAtA4XmdO1W3D5idZjiI0rm+/Goclj+Wzjkqg2yIESjK5LqcEOIsHRcw+G0Psb9GOu56NWWEiIASrVLku5u58LrKljYTiH0c7Exy7jJ5SXfVpNw+jbtia4UPBjVE1WX3S2h6e1odzaFosDjpcPPckBrdA4a4xpbaBMh8cndhfjOdyjNXoh6cv7iDUJG0h1aBqCyETlRHZprtAYSmTC0IsYNcY6BImE4PsIX5qKczGTyT2DJ9TuoxcV2fAkNYIVZE6qSpI3f5T6jUzxH4T4gJ5t7l0VO2maua1P0jyULC3LIUDRds80NcKnzy2vq2HIwj5BdHxqD6OyZZ3w4S5OCS0pOIXoPRQmvHwN7/Ktj1/y+6fdf/PEV2sUVBpFfHW9XjpHZJLUYLRE3aFi3LXKb9trSsr12Agv3KBVyUKX/XMLILHEk+fHWkV9SSIPWIy+6X0z0wRGETvPBmqlDi8Ox8TrFpd+ruZYd392q51N+wjI3Z0IUnAJWnTL30hXFzYJ4l2pw/yqPFzChMPmlRud1fJKZdzPUFGqQMKvHqoUNnNOJ209ILPmOJ1zgelNIH93G51F/1qnZnQWgLdNxzeMxxJElIBHL2eFNn262iKZuDMfCFug5DRQ7KHkMFazI3PPwvNCKRSSJzQhvl5pgR7Wkv0uymFhBxNfkK9KlMpiDO0CXrM4VdbQbaKWHR0g5uDozogXtkW6aDSCthReZXb0qeWIje2e2ZTvV+ZWKuaxfvjiuq6aqvQxkz/DMlIc8bfKCHUhAuS7UilDKc2srPR6lDPx+Yla2dpitmQR7ZPfVZxpZOno/h5hL57PvPyps/IUxhMPzVrYZUmW/oX0MsGZHKO1yU3Wpb7+Of
 T1f3cxKu
 7c2iOn2wLzoxukplkPKJXOoD5qsLD4vgUvF/9wwFA8d95pH9ICwGkHsAJ3fUjnwYCPoKjhMui3KB6MZdvJuVPMmxSJIJWMnk0CYhlAiNfrtV2NDWRi4UVt0N50kIxduRJ4GNSf7pcAdt36mK3GL0iVpr2jCl1+7i+zi8iFlMassGoCNAF7tH1aw1mUygY+6Rk7q5kd5SEtQJIAGoCgIZjdgwVX8kuKh3VBVfAiGp5FZKP+o61sRERuzedb/A1LjvE4zGbdW3AmXw/cClmHk74y27gSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_RECLAIM validates the user input for min_region_sz.  The same
validation is done inside damon_start() and damon_commit_ctx().  Remove
the duplicate.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/reclaim.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 11b70d0a9a6f0..6469b25cc34f9 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -208,11 +208,6 @@ static int damon_reclaim_apply_parameters(void)
 	param_ctx->addr_unit = addr_unit;
 	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
-	if (!is_power_of_2(param_ctx->min_region_sz)) {
-		err = -EINVAL;
-		goto out;
-	}
-
 	if (!damon_reclaim_mon_attrs.aggr_interval) {
 		err = -EINVAL;
 		goto out;
-- 
2.47.3

