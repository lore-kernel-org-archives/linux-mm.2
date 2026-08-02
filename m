Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBC77C55171
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 18:54:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D21D6B008A; Sun,  2 Aug 2026 14:54:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7349B6B0092; Sun,  2 Aug 2026 14:54:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FBA96B0093; Sun,  2 Aug 2026 14:54:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A8616B008A
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 14:54:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BAF6A1C0F54
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 18:54:43 +0000 (UTC)
X-FDA: 85057230846.20.A986CE0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 29DBC1C0004
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 18:54:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lTae5JiF;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785696882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KZNY1MD6P0OCjtAb6cuHefbevIrlOVJqJGEJAaJiWKI=;
	b=OjHH3aW+CZROi0nB0O2gPZMyC7ESiCsGnGU41TD10dpfesPeH+lXquIMHK/eoxuQuuAce8
	5a3nSyRDrM29n4zvHPBmGDfGSeOWtLZKywIgqvrwTgs0cbXvQ+ZIa0krPdbXf2dIuzgq3a
	1mm9pT8r1Di85RuviASD1I22o012sM0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lTae5JiF;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785696882;
	b=KSZt2f1QwieY30Je6rFFC0fPPFXSbxPeJD2ZeTXSJi+V+3V/ZpDc7eXt5s/+ABO0c+nnYw
	tDWd7LkpIS54YgEMUEbyIbfqWHSFfKxmOp5vY/sd1hdZt64/4qaEC5d3dT4QHePjFQaXwV
	cz3txl6Z+dE0rHIB/3RIQRr1xKRX0V8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 90133436BE;
	Sun,  2 Aug 2026 18:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8FA1F00A3E;
	Sun,  2 Aug 2026 18:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785696880;
	bh=KZNY1MD6P0OCjtAb6cuHefbevIrlOVJqJGEJAaJiWKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lTae5JiFy4IZpvv98o7309NigTJWUP3B1irg7TQpYpWaa231tj7JUYYeSSw9q+ny8
	 GeI6Rbk2q0AoNG0KZwsjC+lcLnAY06RZTrIWwhsz2O6rne4i38shQxPuUSs6HTwAuB
	 c8/Bg99D3iClUIceuOzkzP8kZvRxlx0cu+b2fggviRXp+fx1jYW6JwzVjM75mkaXvZ
	 ePjNoZJo+gY77RmBLBbAdqIzvrXwKaAbxuKsFl0kCR8cD3vEkcN5Qxe3cFaFVRDUQN
	 jWpHQp2d6qv9pHdVB9qNJ6KzXB4pYza2Ms0G+D97LkYLda89P1glVzujA5nDgrtkI4
	 7fS766uf+sLyg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Liew Rui Yan <aethernet65535@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/2] mm/damon/lru_sort: skip damon_call() if ctx has not started
Date: Sun,  2 Aug 2026 11:54:28 -0700
Message-ID: <20260802185430.9940-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260802185430.9940-1-sj@kernel.org>
References: <20260802185430.9940-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 29DBC1C0004
X-Stat-Signature: x4orfu9bxwxqaza74f7mi5hz7d3nf34w
X-HE-Tag: 1785696882-7326
X-HE-Meta: U2FsdGVkX19Wmqj1tGXXsE7xbxQD/UHuhiPkIlAST+pyQn55OVEmaFcLXc/yonfrfVYfyYdnte5p6K2pke/WBqcJGlBAXwBL3yK0LTW8IzdWBG389n/XFfnLwcbwye2zwgZYSqNNUrQhnngygAoWyLYVRW5naXA7tevlOEnGDNL9zUDrUFuquOkfU8SxoSWvTd/oJ+h64m3H/YCYrTq7H6S6bfIOXhcFKJXb6om/mGzsJI6mYwoOrIwEJUBD+75Nsi9qGt+Bt9vjkFfO/QSgjAlGQKdZGqp1c6i0DMLz3S7WLD+NiiiqV1CitwVPp+1fw7L4lE1mN/sIN4zPtMmfL92/8YABfuySeI31SfTzdQiX+mRW9ud8BzhKOSU9BrAH61HOPLmoKxApNtv2OoAVgx0RuK2+ls9HK3mcueILe6yL3AG5+RuaHxtk26mAqX6b2pvnoG5AstPnt/Goj9hHQEsSFDrwD/5OLOetYa3QIiE0sW0A7RqQWEo503PgESn39qPby86/ztoWLf71hxElwZ6Y6K/o/rMepaocQFkqw0G65tafTxk9SzxEsDIODkUyR2nHmLx3eDLOnQYn+7EM5uWV6ZbV0rT0j7VL1bVl+pZnEDtGLzwI7+HesHVYOY3oAZY5ktnGsQAYczwYXRzu18fLVktu5rr8mUWLmS6/LVvtTN5YX1v8TW+6SlP/fSBWuLn5clMfrgg+AXDhVcrvhYtk/pLyRx/uQ412U8oeSI61cXBdHtsAtcgPwpgdXoGwKrha78FFMEAfNk8HmX3hrCZPzrllVAi3MysVRdVtTdXiVhqLBCepIrA26/9UXEQK9J7js+LVvGhvlu9YbuVgAS7pkzrjNkFRH6DV3Oj5vc6Vc0E5PXSMZWjEbeQ8qsxNYNdvfO5cYiay7OLxbRZESm4vbl//LydfOlPQ5f+L07AjjhBn1Z/vGAY1rIGU3mhIuCNWkYA7GFZNP+4MZlZ
 yzaCQEtF
 7R2WZz9Snv/dwkbjQW50fDWPjWGlj3JqY4yz9UiR9KtcejpYB7ld0KkRTpkl+NeKR83gSi3d7HcihimJOJ6NA3qdOwzLShZ/8xll08bWkcBy7Yqsqn+3WysZwxxMXdirUf93fxlVHyJiJijrbrMIv9FDU7HsqigZ0ZNgmror+8/7U/Jq5VVsMkG7QmkcflbI9vpf7nXAOHm/0LsIr+8jl4HYfLIvGRQHxaxP0xW6CHLEv9HOll6vOc2VeAHBYqUZIt3LGXigwoqHi11MYNJQp1eMhDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_LRU_SORT calls damon_call() for commit_inputs parameter user input
if the DAMON context is initialized.  The context could be initialized,
but not yet successfully started.  In the case, damon_call() could
indefinitely hang.  Read the comment on damon_call() for more detail.
Fix the problem by memorizing if the DAMON context has ever successfully
started, and skip damon_call() if it has not.

This issue can easily be reproduced by writing Y to the commit_inputs
parameter file on a system that DAMON_LRU_SORT has not turned on before.

Fixes: de3c60e1c831 ("mm/damon: add synchronous commit for commit_inputs")
Cc: <stable@vger.kernel.org> # 7.2.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 3920d5042f109..bd847829a9907 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -346,6 +346,8 @@ static int damon_lru_sort_commit_inputs_fn(void *arg)
 	return damon_lru_sort_apply_parameters();
 }
 
+static bool damon_lru_sort_damon_has_started;
+
 static int damon_lru_sort_commit_inputs_store(const char *val,
 					      const struct kernel_param *kp)
 {
@@ -366,11 +368,8 @@ static int damon_lru_sort_commit_inputs_store(const char *val,
 	if (!commit_inputs_request)
 		return 0;
 
-	/*
-	 * Skip damon_call() if ctx is not initialized to avoid
-	 * NULL pointer dereference.
-	 */
-	if (!ctx)
+	/* Skip damon_call() if ctx has not successfully started. */
+	if (!damon_lru_sort_damon_has_started)
 		return -EINVAL;
 
 	err = damon_call(ctx, &control);
@@ -423,6 +422,8 @@ static int damon_lru_sort_turn(bool on)
 	err = damon_start(&ctx, 1, true);
 	if (err)
 		return err;
+	if (!damon_lru_sort_damon_has_started)
+		damon_lru_sort_damon_has_started = true;
 	return damon_call(ctx, &call_control);
 }
 
-- 
2.47.3

