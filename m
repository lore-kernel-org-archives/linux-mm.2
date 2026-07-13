Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E69DC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:24:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5955C6B00E1; Mon, 13 Jul 2026 12:24:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 546826B00E4; Mon, 13 Jul 2026 12:24:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E6E76B00E3; Mon, 13 Jul 2026 12:24:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 19CF36B00E1
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:24:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C4341140131
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:58:48 +0000 (UTC)
X-FDA: 84983909136.19.3C9D824
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1CD2D18000C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:58:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MEkO4cOG;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yFIQucAr4vFmOrW82XY64T561EcF6nkSnWV7DSiSLJg=;
	b=3Wzx/VeYxLjRmwIRubVyFGqnShJNheSwtiDgjTmZoO+NShCgBDEV7uSMoXaRyEyn6bK/2q
	5QVqbwfz0pyyK+7tLhkHCn+d+mT7vON9WHDRJAdOyHsGJTYleEWd7Ry+zIsBO3VG3n1h6x
	W8n8POpglXPaOOLPnwpCArqLNCmun3A=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MEkO4cOG;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951127;
	b=LPdL76IPT84071pUvGb39RWwCKbcP/wFxVTE8U9b4VXXGB+9rSXwYj5+ELs9gRAo+rT6Z5
	BZBlA7iadZVdxZkwJdcaHQoZFpXZr5edUiH+bJRK0LVYfDMUtrKc4akCtyPEDjyqbmG7I2
	+67EGD6n348pgFrcmLVJguBA7kilVuE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 497A5402A7;
	Mon, 13 Jul 2026 13:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C461F00A3E;
	Mon, 13 Jul 2026 13:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783951126;
	bh=yFIQucAr4vFmOrW82XY64T561EcF6nkSnWV7DSiSLJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MEkO4cOG07NJ7HKPJXu62PXT/o98eeK7TbKkTVT+LMqWbUKy8aZygB2ygoNst2sRj
	 gzXjIFlJyFrWDM6dButP2m/w78beObSMeuDCcC6XBQN+wMUof0NDeVOkmTzOIjVsvX
	 vda83iP5GNBiHr2EWkKqMacRAYB3/h7Skld5ia18TmOZJHI90UFAaZW8mFaQN1STnB
	 Oh6nZjIWOrghkf2//6kGQBmZUUIjmUhpBCDv8RxOqziLQlsy0jcZN+1q2uTQorM0z1
	 hBb6oEjPFxvqOmnAsUZrNGVkxxl9jp56aoWwMgfZnCkNkSye/bJUUzrFwapcTh/0w+
	 /p3IkKRDDSeyA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 1/5] mm/damon/core: avoid infinite kdamond_merge_regions() internal loop
Date: Mon, 13 Jul 2026 06:58:32 -0700
Message-ID: <20260713135838.32730-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260713135838.32730-1-sj@kernel.org>
References: <20260713135838.32730-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1CD2D18000C
X-Stat-Signature: kbpb8f1hxfsc6f5134edehrgtcigxk9b
X-HE-Tag: 1783951126-999954
X-HE-Meta: U2FsdGVkX1/YBKtMoOwe3lE9RpN+C5r0ApS5cuk+G6wHz9F0+EMn19Jfr2bKRVyWzGvDutTZyLClpwu1ywdoRY8J3YNG68hoKiBrL4/hRaSBwcO0Fcsm73bSEJnba/X35Kff/NON0ORWN0xsuKJILGMADc80Ew2gZEqbUcdsfVbHWAoWLua7NP8bGYfk/57NtWDzyqo056xzhk8Er/Ry1Xb6NIX6e0ipdyOYz9dTYntuQL75yUgs9FXO4g0qAdIpWIa738/AvGlg4LXkklAZig8/M9WC1vpEx+rH5lJ4v/0dqMxdTzMXzoRo6I/ICPiEeZ9bdEhFKIgBc0+FsrpSNdBRcwwc/JiRV5mokfhJTrq41mucp/wi/+jfxxpIRuvYrz8wUGeLEoB7JZoXTNv54fAHkfvCCKtIfO27rNlC1eiYUXf008FbHacAZjnYuP59gX5IOzK5A5JBLvXvF0k1n2KEaidx8CAOCO4tLOqKfu3SSZx2UBDzOxmQWC6snlh3k7e+HQm7z6Ey3CJA/tufLE7x+e41rJFJeUR7Fy/eY/OVj3DSE1g3/LRpoE+fO/Cj70igKtM4EF4uM5b8EROlqrePTi3t7oeJa/09LL5d+/SJy7bJ0JNeuoARSnITtgETPpZsU+vwyv1BSSEu51rVAHwIyDxiV0F8ZzsICYAv/6Ko9gUD2dtCi9C0DJe1rth/A3dmDhGMlDZHK5Qh9CZ3tqBAdVHTyfT2+v4Si9VcByknmW1wGeXcjSztzO+c8XLqsFmxPGSHlT1lQUDsPJS1xYBRazAan3rsZIUPATydAZyxopKtUac8HTJTe9IvJea4xhfLdhQ7/2rFxEOPWJJWDxZHCpmPPHplWMnzyxwPriA5G1CbR5GZGOTma0Fqhx5mKsS2qapKyTJjw5ThNdUYjVQT627q0zmJkHndMRqphzhCXnNHUP1whUqbr2CYJWLeE46zQN1Jm1xWTZxc+dx
 /dtsbjtn
 MNXr1Jxz2YPHW+BWBdRu2j8+tMFuaDiRHLcX1VNhUmHVgcK4F79mWCbqiC6JYCHPvplz+3826xt3z5Frp2EsX8JAdBshRcWPSZIagL4POPqC8CNw9UMC6gvkrGYPuHHkA1F+yxhJnvxlKU/F1xvR7azGpcT7Z6p+uaeiG6nagB1Yi6SqNFiSZEm5TWlwPpeDRoNyhEWu5vMi+GptP8gBy8gVJL+Ylr/9XtkwxWV3icA8t2C2Fti5cY9U8PsZllaqkDF6K3Dnkmuzduc7wW9eYlG1whQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Due to online parameter update like events, the number of DAMON regions
could be higher than the user-set upper limit.  kdamond_merge_regions()
repeats merge regions until the number meets the limit, while doubling
the merge threshold up to the theoretical maximum threshold.  It is
tried only up to the theoretical maximum threshold because even the
aggressive merging can fail from reducing the number of regions under
the user-defined upper limit.  For example, there could be many
user-defined non-contiguous regions that cannot be merged.

The threshold based loop break condition is evaluated by comparing the
threshold for the next merging try against the theoretical maximum
threshold.  If max_thres is larger than UINT_MAX / 2, doubling the
threshold could make it overflow, and bypass the loop break condition.
In the case, if the number of regions cannot be reduced under the upper
limit like explained above, the loop will run infinitely.

Prevent the case by doing the break condition check before doubling the
threshold.  Also, prevent the threshold exceeding the maximum threshold,
as it could overflow and apply the wrong merge threshold.

This issue is unlikely to occur in real world, since having the
max_thres higher than UINT_MAX / 2 require unrealistically large
aggregation intervals compared to the sampling interval.  Also, it
requires an unrealistically large number of uncontiguous regions setup.
Nonetheless, the consequence is bad and the fix is simple.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260709145425.96247-1-sj@kernel.org

Fixes: 310d6c15e910 ("mm/damon/core: merge regions aggressively when max_nr_regions is unmet")
Cc: <stable@vger.kernel.org> # 6.10.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 806a67d02a6e9..f3b6a46fdaabd 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3369,15 +3369,20 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
 
 	max_thres = c->attrs.aggr_interval /
 		(c->attrs.sample_interval ?  c->attrs.sample_interval : 1);
-	do {
+	while (true) {
 		nr_regions = 0;
 		damon_for_each_target(t, c) {
 			damon_merge_regions_of(t, threshold, sz_limit, c);
 			nr_regions += damon_nr_regions(t);
 		}
-		threshold = max(1, threshold * 2);
-	} while (nr_regions > c->attrs.max_nr_regions &&
-			threshold / 2 < max_thres);
+		if (nr_regions <= c->attrs.max_nr_regions ||
+				max_thres <= threshold)
+			break;
+		if (threshold < max_thres / 2)
+			threshold = max(1, threshold * 2);
+		else
+			threshold = max_thres;
+	}
 }
 
 #ifdef CONFIG_DAMON_DEBUG_SANITY
-- 
2.47.3

