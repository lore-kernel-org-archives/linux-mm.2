Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70D62C624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 01:07:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A84696B00B3; Wed,  2 Sep 2026 21:07:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0B326B00B5; Wed,  2 Sep 2026 21:07:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84DE16B00B6; Wed,  2 Sep 2026 21:07:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 65CB96B00B5
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:07:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5DFB8A4317
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:07:31 +0000 (UTC)
X-FDA: 85170663102.25.EF1AA9E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id E3D2AA0009
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:07:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ULtb46dv;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788397649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Vzm/scJF4B/qwUzRWO3RKybiqI2rNfNYcnSpn8QAXGY=;
	b=xsCVQKvOnlP6bvfLUfRw7LxR9XNe6S1pOQnQNJbD9EF6cxSSEqwtBWoac7XP5Yv2x/Eh6d
	b5Auo+08OMak+GSdKMFi0HYQBsEh9GpWigcKWbWaTeuer9bDKKqiGEZACxQOMgKmP1ZKuY
	tHz5/w7P9dV0S3zStmidU2wYHM84ukA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788397649;
	b=cNZ6EqsRHqha4icNDOKuFw82adwbCDImVj95axTFtZZ2Zp9AkYrgiziGnbGV9fhpT4NQuQ
	/hedr6BriwgM46WObfVSq2y8LcOb/Pb+Nzi5wK79GxxYUceZQy6Lqy2mC6utCN3EN7tYEb
	7A1AFTuYIyr+/q5nWcY2tEaKrIAQQ0c=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ULtb46dv;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 87B75600C8;
	Thu,  3 Sep 2026 01:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132311F000E9;
	Thu,  3 Sep 2026 01:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788397649;
	bh=Vzm/scJF4B/qwUzRWO3RKybiqI2rNfNYcnSpn8QAXGY=;
	h=From:To:Cc:Subject:Date;
	b=ULtb46dv95AH46NihZ+pCkNhjRhJKn9bWs4Ph7oKX/WbclWjZrVOyYrs7rOITU3UA
	 yEzI4GnKGx/5m32PrvFZ+Di5jEVJNQxlNGXOlg1aqQBkiz6Z7QvEFqVQN34Tn+Z3nJ
	 5rMDuKtEnnIIC6mSUDDwg/Rd0dnS6EQBP4HnZ4pfOsJI1glcQsr4w/T4ZA3+O6BEDK
	 SKJyVEbqGdjvMsABDhAu3mFKPx7JKx8y7KwUjG+E6uYozMZ0eULUnTzwAchM72+2uH
	 WmR6fCndZF0lobx+by8nHpMAfP4MFgCvuN0L861cqah5BC+VHBmY13NXENgRxrDQoL
	 7ZPzP0VHOWj6w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/3] mm/damon: move zero damos quota target_value handling to the core layer
Date: Wed,  2 Sep 2026 18:07:18 -0700
Message-ID: <20260903010722.94244-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E3D2AA0009
X-Stat-Signature: 6fai4f7sioaexjnd5yeg3psg5koa8hb9
X-HE-Tag: 1788397649-795981
X-HE-Meta: U2FsdGVkX19YaBB8NQucChxG4LE0y7rX4FZZVymZMM5GEvKzd5+EbavM8WCME6zm7a2r1hVSfAggyQ1Z8W5Loxh3/8StCAP6pT0Xin3h+5K81kv16Ijmt6PXuQ9gPBp9isD90uOeKrW7bxnwLJvOtaWPANw+JNS6JT1CAn6Qd92/9iyhqHnRpGo8A6oyAJvF+ke3D+R1QimIMw4YAbwUZ0SsaC6+pmsbnDdIG5MZVG8SHmc0LHZuZ3XGHktdSD0OEh5jLsnxTXFDBeRUEsy6SBTS92fsuUgS/+NG0ivHFwgxKZVY0RRJpJsupZEgTbC9HuYhoszddKwX3VOqFWOhShDpLIt1BrgE38ice88Tlb/FK7NVUzGYqllb1C3pX9FBd/ROd/dc11nKmVVj+mlZYLGQ82Wk3EFTxC7P6fjNFbvzs47x9gaj4p6imWmcoMNt9/cd2e3xrf4vZzmUJ0sNEOspvgdtJyAep79fceprUVkkVwwqK4M3U8bZhjTJyCYGW3jGwIPgXwFRWODPH6gBTQtPsxN96Qwy/EaB2clLCXVQJ3SgdANzeWlietTrt3XP+AMeogWv9uPN6ZKprKK4WJv6NR0TVrY9tbqPXeCtOerwki7N8nht/LERbrgdCMCI0WwmPQNEvLfZo7a39LTVIM16nq3+UZOGzTwBYNYhxJbhrag9q30Gxbe4nvqMJep5SuVj1YrTUe1T7OSlc9NjEdvdyLIBeKSIX1sSIq+LcbsTju+Hp+lCDbPaDA7/HSnTtbcuQVFYLAq8jBzZIGIwARoKrNuojJzFAB5xzur4eJXky95R3WUzI/ZK+YDK7axScQNu//SGwRE3ZpLkBl3IdGPZTOKaCPI7duGBuxR/dDWR9aNm4b9DdI5AM/NXh3fdRA5ccE9Rmmy7FVj4QVBWPHzEPotSQuYbxN3FbolsHgzmO3emboniE0Kf0l+vIUvM6qQ8ONl1Blh5Crf8WNW
 K3mnsZ9x
 Zd3PLQb+RFvjgZ1VYERAPgNQIdHOZPO81u4GcPCI75w0Ojyt8bw/4clESpHzc+sz5jFpq5BgMD4vTo9fMNq2Ur/BTkbKXi1SO3E9hymu0W7xxlQ5den/f5ozhgLvfWGkEDJf2fsKfBuiCnf0IQF8acsW43YUqQgjPnR2Ed3s1ySAhRjWHV9bIE+owdhIAFGSMiKvGAW+FCJKPYkde/uAS7sR1A+fIFSSTOQWmU1LUzCyn57Wbo7KRmqOGAmV7EhQc8RE3kErjtCblQxFH4y8d78lZBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Having zero DAMOS quota target value can cause division by zero.  DAMON
API callers are checking the target value parameters to avoid that.  It
is easy to make mistakes in some of the multiple API callers.  Move that
to the core layer.

Patch 1 adds the corner case handling into the core layer DAMON
parameters validation logic.  Patches 2 and 3 remove no more needed
DAMON API callers side handling of the corner case in DAMON_LRU_SORT and
DMON_SAMPLIE_MTIER, respectively.

Changes from RFC
- RFC: https://lore.kernel.org/20260813054432.101197-1-sj@kernel.org
- Drop RFC tag.
- Rebase to latest mm-new.

SJ Park (3):
  mm/damon/core: error damos_commit_quota_goal() for zero target_value
  Revert "mm/damon/lru_sort: error out for >10000 active_mem_bp"
  Revert "samples/damon/mtier: error out for zero quota goal target
    values"

 mm/damon/core.c       | 22 ++++++++++++++++------
 mm/damon/lru_sort.c   |  2 --
 samples/damon/mtier.c |  3 ---
 3 files changed, 16 insertions(+), 11 deletions(-)


base-commit: e5bdf22abf33923f4571fae61ef1e184afc7ddf6
-- 
2.47.3

