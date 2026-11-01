Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9E3060A261E
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 17:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bHnHlvuL
Received: by kanga.kvack.org (Postfix)
	id A14B96B05B5; Sun,  1 Nov 2026 12:16:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 977316B05B8; Sun,  1 Nov 2026 12:16:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88B966B05B9; Sun,  1 Nov 2026 12:16:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 650D76B05B5
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:16:42 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CA0061C3F71
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:16:41 +0000 (UTC)
X-FDA: 85387204602.30.688FEE5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3F42E140004
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:16:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bHnHlvuL;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793553400;
	b=Ex23RiQGbS1m3MR3Ly+VwsdCzm2W8buQJAdE5A7E7BOJWF2bjNsUfRJDkmncGzWfxNqHE1
	w0XK51HLxfmlEwDt/G0Dk47qcEOisGPIlw87oMzRIbv28ZnPb77eKzi3fqAfhx+1mJ+Fff
	IOdnTEcxylztfy2dvFm5ZCZwKcFX0Ro=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bHnHlvuL;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793553400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kuii1OxTBCJKn/aKUCi3+2COKzMgGJ8Y558hfckwvWc=;
	b=mjqxC+SsaQkctYa6Ap/S6AYS0NTWm/wKl3pZVoltc4C8yyydOQx7uFG3FbBQUutZIrLk8R
	+t0aoYvNSgIrq/FolQJONtLF4YCfwennerTSIyHZ9p5y5Rgzi3Ub7NH7zUk2/ixMPp/7e1
	PmY+a/I4X9nOJw1DgfBlsUhCidRnGG0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D4052601FB;
	Sun,  1 Nov 2026 17:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F0F1F00A18;
	Sun,  1 Nov 2026 17:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793553399;
	bh=kuii1OxTBCJKn/aKUCi3+2COKzMgGJ8Y558hfckwvWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bHnHlvuLtN8sAW4efMQa/2BStqLpezZTUSvbaMHV4QTiT0zRg9a8rjjsZ4nEIzjMX
	 NB0/XxHhbZM4xXO/RZgy2tQz276Nxs0atzjpGLVanS+E8J1uhgXiGKbkjZ+C//TP6X
	 5Y0mPolpqhHcAvQxISBEINUq2cAbGNgNEX08k3M2SAAC7XbU57ZHEZ9/UYN0tNf9yJ
	 5CmaCYVRbHLauBdWQBbuNuXHL7o+0mKlheCugfDltMc4jjblbf5JUrTOM5Zs0wL8oc
	 gb72hxel/oq1xU7u11QdktDXNwNiNEq6fDbzNy+pXuKnGEeKWMIp9WVH9fML3DXTh3
	 TkrYcb2Z7oHyQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 4/6] mm/damon/sysfs-schemes: drop redundant and racy zero target_value check
Date: Sun,  1 Nov 2026 09:16:27 -0800
Message-ID: <20261101171630.81477-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261101171630.81477-1-sj@kernel.org>
References: <20261101171630.81477-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F42E140004
X-Stat-Signature: 7gb1yi6aw3a6mbtfor73u31stmtoc5y8
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793553400-219655
X-HE-Meta: U2FsdGVkX19p1VwxbkM8VwNl/PIQUr5Z0G2UQ1eXjK7/N35zlu7pddLHWGNgFGHmhQMx7qOA2AKuu/edBfMkl11oxB5FPmWdi68N8Xb5is5CWnDHdCDp929XLaCfDN25kmLedoMRkGcocmyG+IGp1REJgl3UGELb9slJQB3MA89nt+diF2CNECkBGMlLwtcNxVWD4ejHcU39U4rczWgRsYONvyb64slTO/DeY1Qi0NNjzoL/dqWLqiTIujxuJ3QRwdyzKrgdeEdx6cdO32JiOjpkJhgnz4hxaQOF9eiBvQCuRgiLUfWvNH+vJfPJRjaNywODk5tPaTo15MQbfeMsIHOXvpt/1sO3lcJLhs0cC8J9BnAQQ0hRH0u7JZBx/4aM0TmNCqr4qYfl4l8k7I48BGL9BrGJvOh2o051LleK12rD6pL/AZEIGhsXGWIF/vU3oKiKPZmpjsgsaBZ1eOx06hFgceYCmiUHrIb8i4ZfT7C/lYjcGdZ741ElZLR25qKfp28C02cmm5FGu6nznFjw7VN73A6pjyTI7XjBhXfSywYiZfiVKrwXCt4q3o73lMle1dDTdxkVkTlowMQKCYHAjrpc8JOoPI+Rffw78ONnMZRauQ7IMzR9Zsi7i0ueic8EmZxAifEolRoCiLOizgOi+ItE0yKen0sQo/n9ltuV8bG5ZbaYBe/7toy0XlrjZDZ/VMvG31B/WkunyKP/iEKt1CRSQ9fpAHHUX1bctdJWtObN0dJnZDP3u06gDX0cprHOLEVO0zEkN7dXZyFdbIGK9XtvNBrZURivFu9hi/JyTvkqw++ewSnUBTRqIzN5L6i59vLsWCtZgxbAjdXc9RNjnXklddeEM2whLkggbav0jP3VVcj6u5sHfAV1pq5X5LVF4pxkh5lDT3+6bfTMXBo2Jl9drVbQJWUv8h9bLI8bEAmJe+7X7zsXIcHeL1Yd3fkautYd8boBWBWH61Ba7ce
 uvLd63mm
 cqd/4hQ8nwvGtUnnykMYCeA3hYzlyjv6qtg5vhg0+ebeUKB02j7NFw05WAf/GRnyC7PoDt+Z4iMx+xEBjExLyYjkaz78ntXKwlhJ5MTr8Q8VvOb3PS30D+N6Lf/f+Qt6gxUnn41Db2lymdbGIrLUcaIuJX0Vc7SMXj8LRibUGgINRHPq1TQ3q7ggpwGMS7SwnneAjo3tieGq7qkq8XglsiOeseEnT34W8TZ91m8byzQWq8Jvjy6lBv/qMoLwhtKcP/x0K+mNKYd1Bd+kPNu1AQ0xPeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMON sysfs interface disallowed zero target_value because it could
result in divide-by-zero in damos_quota_store().  Because similar checks
were duplicated to other DAMON API callers, a patch series that starts
with commit 610c4438fb66 ("mm/damon/core: error
damos_commit_quota_goal() for zero target_value") added a same check in
the core layer central parameters, and dropped redundant checks in
DAMON_LRU_SORT and DAMON_SAMPLIE_MTIER.  It forgot to drop that in the
DAMON sysfs interface.

Now the zero target_value check in DAMON sysfs interface is only
redundant.  Further, it has a time-of-check to time-of-use (toctou) race
with target_value_store().  It can confuse readers to believe [1] the
division-by-zero can still happen.  Drop the redundant and racy check.

[1] https://lore.kernel.org/20261021005234.94107-1-sj@kernel.org

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 637f1bd0c950b..38efdc258ef3f 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2898,9 +2898,6 @@ static int damos_sysfs_add_quota_score(
 		struct damos_sysfs_quota_goal *sysfs_goal =
 			sysfs_goals->goals_arr[i];
 
-		if (!sysfs_goal->target_value)
-			continue;
-
 		goal = damos_new_quota_goal(sysfs_goal->metric,
 				sysfs_goal->complement,
 				sysfs_goal->target_value);
-- 
2.47.3

