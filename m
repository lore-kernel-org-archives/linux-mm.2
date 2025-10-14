Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11FD2CCD183
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 00:18:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C81E8E00B7; Mon, 13 Oct 2025 20:18:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59FB18E0024; Mon, 13 Oct 2025 20:18:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DCA68E00B7; Mon, 13 Oct 2025 20:18:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3EE328E0024
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:18:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5BF941405F6
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 00:18:53 +0000 (UTC)
X-FDA: 83994809346.20.4F34AC7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id D468618000F
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 00:18:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EnxiU2wh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760401131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kQAfIyYpPQE0GDnDD/YmNAf47h6oCTss9bU5Wbwbrw0=;
	b=joFmFPezJZT5UPTZ9w7VqXsJcyj8WJa6zbmjo8UB4vqXCBA0iFIDCdszW408AiZIjGBtmA
	FI8mTWixoq9yAAZSzmru1xKSYQXeVkmp56aEnc1NG3WMtwHUkjMToh8a2NvRYQ7E7g/k3G
	4ZiRkxD9OUSZk2ntqhiZIFV7/CPiGIU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760401131; a=rsa-sha256;
	cv=none;
	b=0fJZU95B9PHQ7uHiLm+eH+cWFFZaaPPULCADDYKvbRTaJwa/Logc8eQc2KH91wyNl54R6z
	OlyyGwelSs0MM/r+XP+Gr3iBhxUvJLvSwlOi8KXlfOSB3l5KvsIvbN1Yj+Jp50dOyBSOe2
	l1L49GRE81SAW/hEdPaQx2zis7tih70=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EnxiU2wh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ECC8062091;
	Tue, 14 Oct 2025 00:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76584C4CEE7;
	Tue, 14 Oct 2025 00:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760401130;
	bh=Wj7cSLcyT0p0yvwLU7VLNGP20MDD+s64RMgH2Oq8gVw=;
	h=From:To:Cc:Subject:Date:From;
	b=EnxiU2whCnZHUhG3hop0501oo0Znua44eztBcxHHpcDKvqctxqoBaaULm3oZuJ6Fq
	 QcuWIJMf0g3JJAMsAZ9xXnMUfpDF/VhkkcxRRTYnveOqNgcEELdDWjXZIQ1yAtWS6X
	 x8clovOVioShD79aGcl4Maj896DiLcjFhyoIMacQPCdENh/f1D8CdU7cj5LyhiNlqk
	 FqK4eOZ4zXYS3fFpYaVDta7X4FIME/JnjpKYx12Ap+up5OwKQq4M+3wUMMXkKx3CSs
	 nUHCtwjKNsZpvXt61K1whz0slG3bN7VEZCiBlPZBRyVgTjURPedUxR0HGTnEeS3yt8
	 gUPSTBavfE3DA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 16 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/damon/core: use damos_commit_quota_goal() for new goal commit
Date: Mon, 13 Oct 2025 17:18:44 -0700
Message-ID: <20251014001846.279282-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: oqfkprtz1ayg3t5718wjr3yaucaw9u6q
X-Rspam-User: 
X-Rspamd-Queue-Id: D468618000F
X-HE-Tag: 1760401131-198056
X-HE-Meta: U2FsdGVkX1+JmhYGhruGgYFeP4/cB5M0R0ynPqxsKD1ybQ/lGJopPGJ8JVzxCUrnqsSUw4uIvYB4FRmvDOxf53TRb1CKUO7QqNzHsfL0q4ZIewKLHuGBnIBvPosOA3JqvtVVCVtYsE7f7DTx7mfVytCtTzQYUx91i7SGy8X8neqq0U0hZF7/o+yR8KYNWku7BRH15HX7E9GexZO/ECw/zLoQrmqaLAaPsvUE1eO24MhlgmC7t/pZhYM8qZt4eVfQd4gs/4RKgUZJcCWP12NANQpzKEoe7jKsDcbXU1y8W+m8gHf/7gFjNvThZ16BA+UTmzklgSiY/haWMocMBw6GlYsUQeeWkL1D7JufYtnh1msI4GcW25BAoBQ5x2ckNii+laecBgGwnrAawpOC28wdhOGmhcxPjtOV6jcy2x61M+pkgn+x2sU+pPxM44SM0F2DnndOVWBeY7pjGsTxWy+fzC+UrtTuuoeh/jtnQsnNvJXMMLt5ft6la9++uE1ngvkyJnJQfJcKFrZEMEZnyQ7HmRTS9B/iXUhg5ibewHLeJOKEws3X376WZ87MZ1L4j1+3K6QZfM8aP1CYFsEdCxNvZEjgA5OPsmGlI3svfClcydaMk2ZYVyvq9GcVTYkYtI7urh3rYAF38jlZ7rLVfFILWY3ElvYWxnkb24pQF3aEJSLQKzUWBfv8jHH40kv2S6fa1K/TJWsWv10zFJXTx09rvI3jvE32Z84sMsBaTkYb9EP6LbTwjgkCND8OEUdmIdeWOmpTtQXRWID2czxZoQh5nrT6uwGI19qDN1t0ZIovfNPAGlmjskeJYFvRXfgc79rtXB7pXmz71t5BEqtPNHOueabA7zmM4y8mP+snMXFcdZsg58WKgxweQxaqAkGhPnFZOvxQpqkFsgIcVKDQteaHbZADaOIEM9T3td4KeeyCq57+8YuSS4UNFGkQQWLNoQERbnMe6J3aqXAogl6FEW2
 NIT9de21
 EYI+7GqmS+l9eUBrf3aeZWxaPicP9JSRMff0o7x9SSMcFfl1815vx8V0dMPAKilQJVsElUyR6Q5BWrw5QsRzEDprubUThY0R/4e2XxgFy6kfxJkhjfuLWEWEu7/6myVzPCJF0u1uSzfi/TguuDOMRDisUdl5nC8nf5wMmk2l1SNF4CQY0T3AX67m5Lt9YQFr1DI6kYO14uGQqfHl5RROCf4eMJuP1O5+oJGj5/73Y9cTjEH4EfpLs7k46rNoZ2Mp+cjxfLAFVjtVCdmn+3qHKv7HbMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a damos_commit_quota_goals() is called for adding new DAMOS quota
goals of DAMOS_QUOTA_USER_INPUT metric, current_value fields of the new
goals should be also set as requested.

However, damos_commit_quota_goals() is not updating the field for the
case, since it is setting only metrics and target values using
damos_new_quota_goal(), and metric-optional union fields using
damos_commit_quota_goal_union().  As a result, users could see the first
current_value parameter that committed online with a new quota goal is
ignored.  Users are assumed to commit the current_value for
DAMOS_QUOTA_USER_INPUT quota goals, since it is being used as a
feedback.  Hence the real impact would be subtle.  That said, this is
obviously not intended behavior.

Fix the issue by using damos_commit_quota_goal() which sets all quota
goal parameters, instead of damos_commit_quota_goal_union(), which sets
only the union fields.

Fixes: 1aef9df0ee90 ("mm/damon/core: commit damos_quota_goal->nid")
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 93848b4c6944..e72dc49d501c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -832,7 +832,7 @@ int damos_commit_quota_goals(struct damos_quota *dst, struct damos_quota *src)
 				src_goal->metric, src_goal->target_value);
 		if (!new_goal)
 			return -ENOMEM;
-		damos_commit_quota_goal_union(new_goal, src_goal);
+		damos_commit_quota_goal(new_goal, src_goal);
 		damos_add_quota_goal(dst, new_goal);
 	}
 	return 0;

base-commit: ccb48f0d949e274d388e66c8f80f7d1ff234ce46
-- 
2.47.3

