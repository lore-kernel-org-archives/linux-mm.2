Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2027CC624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:57:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F32B6B009E; Mon, 31 Aug 2026 10:57:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A38F6B009F; Mon, 31 Aug 2026 10:57:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 491956B00A0; Mon, 31 Aug 2026 10:57:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 237E76B009F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:57:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AE1A51A017A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:57:34 +0000 (UTC)
X-FDA: 85161868428.06.0E383ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1DD49A0004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:57:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KxCSK/lI";
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788188253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z/q1Yeqt6RZSRYDCAAqabUKJ+epH72uUvgP43VjXaQA=;
	b=N38RpqZg6PXDWAIDoC42caqS4d5fxKrGaih8//14ZMmtu4VZWCLzxU/RObuOvQ2Xw2875U
	hwG/negaZyUPo/4KtL1YhxICE07P63PH+2Cv1SIX0qEl2xHnLgpgrt+RDH0SG2bo4WpMkW
	LyqzNjsmGOZ3Q/9itGjNdVq4Df41hE4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KxCSK/lI";
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788188253;
	b=Z1RFZGr488/Rt/DSayd17hYr6yJjR7FtwPkYgYqh0dexLqpg5kzy+IVoK03H05Qxr33ObD
	qS6UZWFNc7vGbLlLKbmLYQgQsCHtlQPiqgFFJOVgyK96OjqTn+2zB8x5MefGgVAJs23hXg
	FTCul0Pa5R+jSz6uIcNhf5wlPNmVGZc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 652C8419BF;
	Mon, 31 Aug 2026 14:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19FC41F00A3D;
	Mon, 31 Aug 2026 14:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788188252;
	bh=Z/q1Yeqt6RZSRYDCAAqabUKJ+epH72uUvgP43VjXaQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KxCSK/lI8mnji2zwaf/RVqvW+az04RzyWNdMfc3c+ybG4VfvWmsMx/AWEBnruTqlX
	 2gCeddu+zUitH+oCA8x+HaamRBjID4B13iry5qKRARgbwv97eM6fVxQDenNmLXqO7F
	 1XKpDbESRqGQX6T9L85R8Q8vu/G8X8leYnrIoqY7bEwTlrIT+ZU5+iHy0YOlTAhoQn
	 Ih6ij8ycmERAJhn/eA/1G1FI/0O/Unes5koZsCepWYjJ+APQDSkECLaBrNcpPxv3vL
	 hd3GasJn/yKKL4zkS48W8MGu0shMw0JhJYi9ZCGURAfymUsWrgrSlRFQXPvOLbJu1v
	 MFZWVPcKfyA1A==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Cheng-Han Wu <hank20010209@gmail.com>
Subject: [PATCH v2 1/2] mm/damon/core: remove unused damon_targets_empty()
Date: Mon, 31 Aug 2026 07:57:21 -0700
Message-ID: <20260831145724.82387-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831145724.82387-1-sj@kernel.org>
References: <20260831145724.82387-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8gj4fos5ks3fzpk6u9ht8hked3oy7mj4
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1DD49A0004
X-Rspam-User: 
X-HE-Tag: 1788188252-156998
X-HE-Meta: U2FsdGVkX1+wS0y3GI96nprRbuEWe6V27AOoB5JQrm91wD2AysTKGcNzHD3JbnnkcjUifb5nZ0kXtqdD5zPnDP2e+mYy5LJRAxBY4z5jmrGMRVtOYfpWcim26VL9I0VbLvQ1hRCdqwTH9gIwK4xlJzqpwU6Js+gqo04/++kcdnMSuniIdqkILs2tPS5btUVM1GGYHkSqG+H3hC+BPO/9+yhIdqv+kdNmVjun1QsCFwu98kwpOG8T3z1gKaPAf4rtVChAHVcs4AGBR42fsoYvesfiTw128y3DMhpCrCvLU0gxlt1VF/HD7UqinbUk3D1nm9VEY58+eqBogHQAwQaejxLZuXsFMycUfxQX4vgFcUzMMvO2ISOdTuwyYM5goH54IQ1CQOsc4YO+AV/hUJrmI1hEHxJpenFmdSzLFYZGC52aidLrrJPrLYditFPZ9eza7GdM/PC37lv/2HH5aWGmmIUeOB+AKdR/xr4gNYoPkbzrMlrUkvcR0Q7doYVw7cbRqYQ5OE43jdzJCLTwf1ZCZEGTMZrIrUL/6CFU0HNTBEYa3fvK2tl483CVb13pEVJE9MDdL4G/zDiAStHkKDFxz9JqcmzMROshFedLUJkAqZKKX30TxlvvNhTw4F+cVWOT4sYhmumPsvOs3KNjY2AhU4jcYP1Ix6bd75YS3NzHFoAi4MSKCQQnC75edjgymPDCF5QRU49IWV7kW2THETWF3nzJ3rcbVQmv6Y45tfSG4SkzOayOI9JEFQSNq1PDfVJeIlUcnVFXFirh/rr39FamfTZu2NPqCkSrpLXOCxZ/siPFUDcdkjjXMHn1Y/B6a3oyEi4gnQvof0DcfQAntALuAXIw02aarBPI8eW8XXBn0eyqhlelanPHfr5/uUSEXLLc2rV8LZ2rThkwr6ZFUNysBLU/cqWK4dT0HkgWSzySjw0oIShZneRow72P68U0WkQaMRbnxnZ0ov71fmxMKqH
 NR13an0Y
 Vzdh67pD9o4sP+yU+3v19gc+IlbtcsLv3MnqllyWd3x7/kZAs8mTZcXIcAZwhM3jddOSwj3F/Tl90dp1nHJftQkNGrTZu9VSPtBsRyyJriOKjL0Ek9A0+fMecTbvz1RVMcvA1UBlXo6sZ//qGaHIi9i1vCwTCbyt29yZUrZ14m34ghKy/deOJr2ZR88QTqOuZ1XD5znPKVt4jVnyhPwaG6QcvIIBfUgWFG3MvabXgNeEPyhSI0eDuqEuZJDzok6QpFuFkmZkXcSySpZcNJpw6dqOYvxs1HN2i19ODGpIrqBhfDTE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_targets_empty() has had no in-tree users since commit
5ec4333b1967 ("mm/damon: remove DAMON debugfs interface") removed
its last caller.

Remove the unused declaration and definition.

Signed-off-by: Cheng-Han Wu <hank20010209@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 1 -
 mm/damon/core.c       | 5 -----
 2 files changed, 6 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 310509455db13..9835b864a8db9 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1056,7 +1056,6 @@ int damos_commit_quota_goals(struct damos_quota *dst, struct damos_quota *src);
 
 struct damon_target *damon_new_target(void);
 void damon_add_target(struct damon_ctx *ctx, struct damon_target *t);
-bool damon_targets_empty(struct damon_ctx *ctx);
 int damon_set_target_pid(struct damon_target *t, int pid);
 void damon_free_target(struct damon_target *t);
 void damon_destroy_target(struct damon_target *t, struct damon_ctx *ctx);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3fa1b096c8330..043eb38de5fd3 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -798,11 +798,6 @@ void damon_add_target(struct damon_ctx *ctx, struct damon_target *t)
 	list_add_tail(&t->list, &ctx->adaptive_targets);
 }
 
-bool damon_targets_empty(struct damon_ctx *ctx)
-{
-	return list_empty(&ctx->adaptive_targets);
-}
-
 /*
  * Assign the struct pid of the given pid number to the given target.
  */
-- 
2.47.3

