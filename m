Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92C1DC982DE
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 01:14:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E64846B00EC; Fri, 18 Sep 2026 21:14:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEDAB6B00F3; Fri, 18 Sep 2026 21:14:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2F966B00EC; Fri, 18 Sep 2026 21:14:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 76B166B00EC
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:14:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DC763120164
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 01:14:11 +0000 (UTC)
X-FDA: 85228740702.17.FF9F35F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 457A8A0006
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 01:14:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="S/eUpwDe";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789780450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yRWBrRHzXRD4yV6zK3pssB5trIwz9nJ/p0K/bKugcGc=;
	b=ykhQtU7adpq6wMlIOBl9EImGv8pZj1T/iBK3XnW+qsOS1XobGSr3ZJdgpowYxS5VJpnzGK
	qJZNkYgeIilqBNJY0Od2p4ZprXd7SnW7h9Pta/FYi82CawUnOUqSsiBPtw0h6rxzPdGLMT
	45a6en8Jd4TaBX8FuVLMmCttaQy99LA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="S/eUpwDe";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789780450;
	b=zYO3dCN0h/HQH8hApTSyBncN4wdACHQFxq12awp+h9VSgnT/22OKxrL3x7QcEdvTGgYdIU
	PaSklWMsJgAx9c/FJPn7yD+GSWh3LCD+2Y3zvMxQIlirAyydkdeWG2sAwBR8YsJErLKJ8D
	lSlwDQsoSEwl0ixoPb7T8zX2oePrHEg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 91C3E40091;
	Sat, 19 Sep 2026 01:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFED1F0089B;
	Sat, 19 Sep 2026 01:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789780449;
	bh=yRWBrRHzXRD4yV6zK3pssB5trIwz9nJ/p0K/bKugcGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S/eUpwDe+6EpsVRHBLLOe8RKee8YZX9K9fwa0l2tZlIaeY9bJvCcF4Q76jGjVXuqY
	 uOSiQBCMHU3oyHyzBvgNxmD1OYYvaX4RinwQCDslB4XCmzhJcz/oVhKsGlgpymI8Vc
	 ++ScuqaRzrhYHbILzrAhUax6Q7rOY06/4sokwMgXm3ejct4PADva0R4e8uAmgP787g
	 Vtpqeq8ddSWArCdZzuqnc+qwysC0MrFrmdnzipHMYFdBzdawmODXEWMdh43P4W6jJI
	 yhtcQNScxw7SbUeEvV+d2NEng0a5nfwBl7SOQQPByymTSpkHy3mtVLla6b/4mF1gXW
	 FnTZUVqa26aQg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 4/7] mm/damon/tests/core-kunit: test quota_goal->complement commit
Date: Fri, 18 Sep 2026 18:13:53 -0700
Message-ID: <20260919011359.88921-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260919011359.88921-1-sj@kernel.org>
References: <20260919011359.88921-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 457A8A0006
X-Stat-Signature: 9xwta9bo7r97zskdzkydg3haa1r9ycmu
X-Rspam-User: 
X-HE-Tag: 1789780450-946194
X-HE-Meta: U2FsdGVkX18XDL+3qd5FHbQ5Ct//uevTWVaYE+NsDxbx3cnDRe5jQkj+GxzeZyA2sHouVR9K8W3KA59g/kqLgrQ01GkEhtHa4rga9Gw0cBVs7H6DIbVAGPKKWXaeDjsaciFilUXI4yfy9bYrgkKUD3hVS2Gq/ids0lf0JMbQq1arsOWelGKsToUT04XPBCql/HvAxWdOQaxYfEU8E6SRZp2KLJFzFbOvcTNEgbHB2C/a2kU61eQk7ZvzJHFXh5KUyq4LMXTp9Ne8nuFON3mOOc5JX+u3E6LWM5Fakbr46Bgu7Bv0PZQgkM7UQ7JTeEoH+eUt/bqECGrJtAn3MyL+zflqMzPCBrGGUuLNQZQoIMMaNzY3mZRB1vQLa24Kr4nM1NqDnFAQkNGkMddZgZN6cYTqtv1AQQ4NHQ5DIAXtOXohr9O8AcseGLBl2NkUs3Z4tepx1Osmhnioc8uVH61MyjgXFM5NxSC5s2AAwleCKsumkuO7vN9GWiZBwc94Teie6BJPjhMQOvrh0W0AB9+XAQX7hxsFyLoBfMzbvUL/CoxpSzRKySuQDVVjXLPIXfwf8aZ3Ww29xhxTfTHXMXH1XzTlCkSL2JiNwO6/rlaxZRdARJtX0usEoP2eJzJEnJEXFS28VkgLE7cJgGgWUn2uChkPkpgPikx2DQtDYNH5yCVBuSHkgA0/wwaFojQYu+iOjKa1KwyuJFnJpxVAIOdmz9y/Z00vghY9ArrwwhFG2kYwfF4AkTcjLPC/LbS4XFV+Zivz1Qj3jLiv4uz3e9uDjLXqaysXicWFlJjjLyZsynEVV2fklDo8p7oQfwmnM67b995hYn461NBB4x8Z/ZbWcLmoH7XvnMfIQVAJOO1jsPLGKf+dY39vAepK133lLibfDl/+qptzMmcpVuoWDKHz5jmYm9j13bPMwdgjhSDe0lIbt1oKgcGJ7HjNBv/HRmflnzXEYsbn4YwNDzVKxHt
 cO2oP5l8
 T8Cg4v9X2IQjKn8iJoyqL1+Z0g7hw/sg+qHeDvw+mysmz6wA4ARi93t0Ug696sqYwTIpeMR3mtCNOfFNE5YbtPTuTi5W+1bq9QPoHKPuyiWtEeo54fZBZlxEPYGLM3XYy9Pfb6Mtdma85fxh+ztApQBv5aA77CzmxnCjT2c6vo1T+ssxcazjgpgTJgRuADqPn/ckDHQeWFzKIHacMFvgWhL9d8wHQGeuUEylLgVdS47WFixFTw3IQn4ApSNN0w/5bVGEGFm47jL2BGr7wME1JD06qGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend existing DAMOS quota goal commit unit test to test the complement
flag.  Set the source complement flag and confirm the destination is
updated to the given input.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index e8290a2c6f343..a2504e96954f7 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -819,6 +819,7 @@ static void damos_test_commit_quota_goal_for(struct kunit *test,
 	damos_commit_quota_goal(dst, src);
 
 	KUNIT_EXPECT_EQ(test, dst->metric, src->metric);
+	KUNIT_EXPECT_EQ(test, dst->complement, src->complement);
 	KUNIT_EXPECT_EQ(test, dst->target_value, src->target_value);
 	if (src->metric == DAMOS_QUOTA_USER_INPUT)
 		KUNIT_EXPECT_EQ(test, dst->current_value, src->current_value);
@@ -862,6 +863,7 @@ static void damos_test_commit_quota_goal(struct kunit *test)
 	damos_test_commit_quota_goal_for(test, &dst,
 			&(struct damos_quota_goal){
 			.metric = DAMOS_QUOTA_USER_INPUT,
+			.complement = true,
 			.target_value = 789,
 			.current_value = 12});
 	damos_test_commit_quota_goal_for(test, &dst,
-- 
2.47.3

