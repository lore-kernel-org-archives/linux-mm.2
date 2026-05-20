Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2E2ACD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 06:29:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E8DD6B009D; Wed, 20 May 2026 02:29:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79A766B009E; Wed, 20 May 2026 02:29:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D8AD6B009F; Wed, 20 May 2026 02:29:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3DDFF6B009E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:29:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1406B12017B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:13 +0000 (UTC)
X-FDA: 84786820986.05.A4616DB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7566440002
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PuffpziA;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779258551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i4QYAEHbDCvNou4iBTdigpX/qcP0blVfRQa9MnkoH2M=;
	b=3L6k1TmJT0CnY+w+Huvr4+CZX9IhdkVgP2lwibMshFnZMYQ3d9ewx3U9Iwt8H6LQrgqSfG
	/9nxYrKYEBepaMoSgWl6G/m/B9gF/QnJdVTu+HW0Ui5jQCcD+NEeBdbulLi/kI+cL4QD7e
	BNviwhoOvjwaXVKPLYg4Bd61TD6xWQo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779258551; a=rsa-sha256;
	cv=none;
	b=gut8BxnP7RRbX4KLUyTEfrYzifQPeGPEhqgl9UnZrgyaadl81x9TgRQH9afxj5hj465Ezc
	RNUe7PWJ50Lk3fNcKj/tK6COiBmMKxNDOmjxarwhhurhzsbuVvpjDoxMbaftcLL5GLMRHe
	Els5rXTCG+4om3rWIogq6AFFwyqNTFo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PuffpziA;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1253260218;
	Wed, 20 May 2026 06:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979101F00894;
	Wed, 20 May 2026 06:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779258550;
	bh=i4QYAEHbDCvNou4iBTdigpX/qcP0blVfRQa9MnkoH2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PuffpziAWFwnPx+GwTm5I81IktL90Ytz6cqBL47N2tAApCaD1794IXBGY0MSedK1C
	 rw9QV5bzVvjay2UlCCZh7TRIgnnQK2fbmRifTouq2ueSu7LbHv9LpVsigyUKmgTC3F
	 0qGGzoyErrEbYAcD9JwZvu8YzEgjED1gTzEwTy6Z6ir7jFizIMgUpQGricmQ7asNhx
	 R1OdbxXr1HAzcDYFQi6MxHFUFU9NOfNhWKFX9qS153UpEoNweD36vEjhxg47gsv2Q8
	 qLDyDmf471SMXGT3UL9iSD7QkAUxAxP+hZrJyjlxHi9K4QDMODlGE91820cxFthxKP
	 Z3YKcpdKviQJA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 09/14] mm/damon/core: remove damon_verify_nr_regions()
Date: Tue, 19 May 2026 23:28:41 -0700
Message-ID: <20260520062858.167011-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520062858.167011-1-sj@kernel.org>
References: <20260520062858.167011-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7566440002
X-Stat-Signature: q543dnz9m1zr7uha8cij5f5pjchazw4r
X-Rspam-User: 
X-HE-Tag: 1779258551-862925
X-HE-Meta: U2FsdGVkX18iDKo+GD3qKXOTHHODrnvGFswPPVF5YFf7H+Mw0zxc49vnpZ9nRelvjIQR/XenXp7OL4fjy4tdLvryhelYxeD6cOUUIPzoO4CWgwpo8Yfb+H0qfXnMOiX9Z6NNYAaTmyRyS6Y0cweTQHKMZCi7dQMoXfxB7fiLu5dsTrfLbIb+1evt+8781LosQcwm0nZHyi50j9MgrqzqmTd728QFHc+7+b9YCBf48g/XZVzGTHsYqHz9Icun/hCabdC3ob6zhvPvLeHdqq8z4ITeWexnDW0pghE4wiIRwSIUdZ+mq3MVxznpFfiR/zyNjQqr17shEQUiWAFEm9VlBVhs3RhLHvtBOEHtNX1WLJYEpBbPo7qW7+OWwifJ0VadjYSqsa+xNs6aBUICH7BcZupzvmSymO2dPcMWOFw/NPLwxW2du07Z80GtD8F2Qwl2BrQOfunxfo5Ju2Q9X+DHxB65F56O6fKE58Z6uFeYs6CWMdIgrZDhLJUwySAzpPUMlFH6NePczIBk27oU8gzoaU29G47PeZTta0tJ8y+ltlrTchrUZC/Gv72asOVzoylR/Bp1d26oUJMNfVf5GhtfFNDPsVxB5rfzx93HGOH+Khiz4AEhNL+1PMcolP6Q//6o4iDWcHicvuHhb5u89sEWf7Y2TfUsL0I0eYFfEJcmT/r3IxgaeyVvyeE7fPrhKRhmsLbhWReQz3rCOIM1wbqtATYOu165L9458m6vYyvu3xpL21fnMdBWFGtL9bAJpEPBVBRH6dkXz6UtpLouOeNw8G+4OEh12BM086G0kT/JA8gOQ5X2SN1GJSG4TP5b/OAIl/6H6Ay1SqZiZser42qwhzOgwoGRGqVmK/0oLqhVAb405d9Sq4dnS6lxXM9ebX096kAQ2VRwkgUl4pf75wXloftQ0YKs9Y4bKjCYQwiNR8BHqDXETdpvDwL0GBFgr8why66sy1nyc1QF5GzHIPi
 cRwzbPGa
 N1lWfExxXSWczhoMsnSwQWRmaUCNeLweQBBUmBQrbAfqKkR/1X+FLvxUSqJ3GjMScKlX1LVM5RZhfMSKImhTcJ4I63wcuw7isBTv/qoaKNyqwmVhQOpJmvI5ebIYWmklIUWPjOR4sRJ7Vm9sScweoi4XQVIxqW6NwndSVhk+F2tnRLJz05v4ljR6yxEo3trMWd4yUIfqQuTQFqXqUOJejUdBxvTs/1wk2N9Tf7SiA44ga9l2Uz8ldmo7xOJlqAXKiS3zOp9C1GqQaFFHWHJq+4V3WTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_DAMON_DEBUG_SANITY is enabled, damon_verify_nr_regions() is
called for each damon_nr_regions() invocation.  damon_veify_nr_regions()
iterates all regions.  damon_nr_regions() is called for each region in
kdamond_reset_aggregated() and damos_apply_scheme().  Hence it imposes
O(n**2) overhead where n is the number of regions.

Though the verification is enabled only under DAMON_DEBUG_SANITY, which
is not for production use cases, it could be too high overhead.
Meanwhile, damon_verify_ctx() is doing the damon_nr_regions() test.
Because damon_verify_ctx() is called for each kdamond_call(), the test
coverage from damon_verify_ctx() could be sufficient.  Remove
damon_nr_regions() verification.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 22327a23c7e57..b2d268c4102db 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -686,27 +686,8 @@ void damon_destroy_target(struct damon_target *t, struct damon_ctx *ctx)
 	damon_free_target(t);
 }
 
-#ifdef CONFIG_DAMON_DEBUG_SANITY
-static void damon_verify_nr_regions(struct damon_target *t)
-{
-	struct damon_region *r;
-	unsigned int count = 0;
-
-	damon_for_each_region(r, t)
-		count++;
-	WARN_ONCE(count != t->nr_regions, "t->nr_regions (%u) != count (%u)\n",
-			t->nr_regions, count);
-}
-#else
-static void damon_verify_nr_regions(struct damon_target *t)
-{
-}
-#endif
-
 unsigned int damon_nr_regions(struct damon_target *t)
 {
-	damon_verify_nr_regions(t);
-
 	return t->nr_regions;
 }
 
-- 
2.47.3

