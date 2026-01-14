Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53B62D31A0F
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 05:53:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9CCF6B0089; Wed, 14 Jan 2026 00:53:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4A9A6B008C; Wed, 14 Jan 2026 00:53:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 922776B0092; Wed, 14 Jan 2026 00:53:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C7296B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 00:53:19 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43A80C1A02
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 05:53:19 +0000 (UTC)
X-FDA: 84329501718.17.D7DD1B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id A90524000A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 05:53:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tDpC5MJV;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768369997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uocmb0ofz5XPAProLoNyXFTCSzhqcYQ0t0xPWsNt5S8=;
	b=4e2rheHnBrKzk59rDed/k5Hvt+ZtRuZxcc+ALkZBkIXzRTYE4EtY7CQf3zO0AVA+kyVe7L
	lXxe/7HQ8al4KlTNSPsDWIUv+jkTZhB+N6K2kg+T6HpXG6hU0eQ9z9DO5A74ZXFb8TlVQk
	6RLhbp1B5AqFmH3yBDOenN/PocAlDjA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tDpC5MJV;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768369997; a=rsa-sha256;
	cv=none;
	b=WTHf34jjR6bPaYZhQlPp9DxKJHWGOiszr0DZn/gKh7SNLO4eYi0V+hVx7K5jjSZYU7yVpu
	KfmxkqqEghWBuh580AZaHhqm+Qm22wmuxVpA2+/LhZdIhWQri1u89kSl+twIS44iH1lqeE
	89BnPaC7kqikjx8zQMGIKTf++n0NOIo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C68160052;
	Wed, 14 Jan 2026 05:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9208DC4CEF7;
	Wed, 14 Jan 2026 05:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768369996;
	bh=V+SlBavLJRAAZg4Ll9BOkS3GsX17kKE4EmJ2ubSxjKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tDpC5MJVH1/nhAPRueH4hsrd7ITCEK5QtUFuz21OuvxBEEOaa8IMvhT64bPEg3bu7
	 +vWn6q1EMRHj9vn40URiDRiKLrqS3iIaaDkM+gOgbVBS/GiKt3L+LAiL04T5PeLikE
	 G82mbGia4WIS/5mjXs60WEpyK6FXeFwQOKfGeJG02E7CKRDIXTzDSv/wGOCSAgAbRX
	 ZWcsKJQpVWxtsL/xmxy0SaUSdySkyYGfv9bNGTZdS9LBRRkYG1o2wgH3vHra7THZu4
	 +FI/W4VABwLr/E/XVWEr5xoz5yWyfrn2OWrB3NleDzsqe9u7wZcXeFhnnF/8sL/kzs
	 tzO1qbfiUN2lg==
From: SeongJae Park <sj@kernel.org>
To: wang lian <lianux.mm@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 08/11] mm/damon/lru_sort: support active:inactive memory ratio based auto-tuning
Date: Tue, 13 Jan 2026 21:53:07 -0800
Message-ID: <20260114055308.79884-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260114053629.85750-1-lianux.mm@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 5w6xzibm7tqhstaxqdxip1jfrjzarar4
X-Rspamd-Queue-Id: A90524000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1768369997-614812
X-HE-Meta: U2FsdGVkX19rw5AIsvDr6cODt7oRoQgv1f/XQ+XFni8kAvQjEliy7s3FIMAglvEf5gaIFBabRah99VybWpdrV9snxLiM3CaNptENT0Pj/NHHF47ljHysrhZt2OtET+WKCRDuCoRi/+HanZIg/GBg6ddupFPFuyQrim2PjxyqRDEEWZOTBCEvzkURSLmS1dtNO5mfZtM0i+lyxm5x0BiX271Ie+9xCQZDMSEGvNHDF5CZo8q0rZnx31L60SBCfUt81S/CrNF6IO0BkT6/7+wvL9GTHzbUpvK5Ggkn2fzwElmrFylGDz5JgCaTGcGMpoU1vhzBDYmWLENfA6al++4YjmeHK01TjUj56C1LtRt6UdIJGXT22umsPD/1vSXzavbr2EXpmQ9FPuIiv4sUqtguz+PhP4Go+zuqxcEKgw/fonM5dQalOFtqf5P0nvrMer0Ge/kSCEjcQz8Odn0AKsEx2oLj3AuQrzQTwSegMkSq3a2Rzj73rnZMAVeXi2q3cw1Rfsfu86Hq0IH6HSzHozUEq+2A9FUO/tocg/gBqGMf7WE3VAnAgoOMg7h2EBdBNcdHg+q7gslxMVFZxnk44bWloK0VBxF4EfTZfdFMY7Q3vxpZMfzd28d4fjjpCxaBv7gKmUJwkTh2bDAqrVahjzZPYI6q/UuKgmqzIx46/dUPlkOVhLfw7RiQeDA668ahA1PA9oCcXhhSkWqYYJx6ZClJq1BRLbQXM2RKT6x+BbCPSNLrdqmu8UZy5e7i+xVEQkALhhxJi/Ioca4CCAm+DiasEWNzW42ohyLFrGZzSqidEbsyhKaA6OVD+TlWPvj45cVIoV7cq+tyHAf0pFe2k4y7cdbr/MWLXmX1W6L14jBwPwaSqZA6ZzW3rqQDGyxPs0uXPncyMCwhSEoUY+GqUMN5DnIuGpVCloVb581KtblyZveu5XvTn9fLwJ//y36am2ONQ8v4JKlpNgliKoTwzkV
 T8R+w6jE
 arvQwCrGAfjfrRxmOIYag0XIRys021znBMzwpp0KVefmc/E8CSrw8BLPV2br+D5qrKdc87HIZzWvAxW47fecMRSsGwfdiNeJpK1uKXZKjqeI413bNeaU+h4dr0zsFnOhoH3cWQuFL3bA4E5VM+RPMXjCQl+JaW03RuDHm90S1KFuqDlEYBZO8MH1e0x4YJD9+jzxJajobP6qLdyc7KtYVtMwodXijAdD/fmKh/5D2ghmqNMKnVdnbab6xto72O4IBmmVe6cRi/MVIZH4xAmKTkqzh4ob6oHf0zofVujlTEFU4aN+Fhisrma+eAcXY8iZ/2s3prdTdowY5NO5Ggh1WHpQBWLyK6BZsTHnguM58F2K9MceXurKlr8lhTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Jan 2026 13:36:28 +0800 wang lian <lianux.mm@gmail.com> wrote:

> 
> > Doing DAMOS_LRU_[DE]PRIO with DAMOS_QUOTA_[IN]ACTIVE_MEM_BP based quota
> > auto-tuning can be easy and intuitive, compared to the manual
> > [de]prioritization target access pattern thresholds tuning.  For
> > example, users can ask DAMON to "find hot/cold pages and
> > activate/deactivate those aiming 50:50 active:inactive memory size." But
> > DAMON_LRU_SORT has no interface to do that.  Add a module parameter for
> > setting the target ratio.
> 
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> 
> ```
> > +static int damon_lru_sort_add_quota_goals(struct damos *hot_scheme,
> > +		struct damos *cold_scheme)
> > +{
> > 	struct damos_quota_goal *goal;
> > +
> > +	if (!active_mem_bp)
> > +		return 0;
> > +	goal = damos_new_quota_goal(DAMOS_QUOTA_ACTIVE_MEM_BP, active_mem_bp);
> > +	if (!goal)
> > +		return -ENOMEM;
> > +	damos_add_quota_goal(&hot_scheme->quota, goal);
> > +	/* aim 0.2 % goal conflict, to keep little ping pong */
> > +	goal = damos_new_quota_goal(DAMOS_QUOTA_INACTIVE_MEM_BP,
> > +			10000 - active_mem_bp + 2);
> > +	if (!goal)
> > +		return -ENOMEM;
> > +	damos_add_quota_goal(&hot_scheme->quota, goal);
> > +	return 0;
> > +}
> 
> The second goal (Inactive ratio target) is added to hot_scheme again. 
> Should this be cold_scheme? Currently the cold_scheme parameter appears to be unused.

You are right, thank you for catching this, Wang!

Andrew, could you please add below attaching fixup?


Thanks,
SJ

[...]
=== >8 ===
From c8dbbf0cfb01de606d47f455bccc2d7b2d6d07ef Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Tue, 13 Jan 2026 21:48:53 -0800
Subject: [PATCH] mm/damon/lru_sort: add inactive mem ratio quota goal to
 cold_scheme

damon_lru_sort_add_quota_goals() is adding inactive memory ratio quota
goal, which is for cold pages scheme, to hot pages scheme.  Fix it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index f3a9dfc246b6..8af97642912a 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -238,7 +238,7 @@ static int damon_lru_sort_add_quota_goals(struct damos *hot_scheme,
 			10000 - active_mem_bp + 2);
 	if (!goal)
 		return -ENOMEM;
-	damos_add_quota_goal(&hot_scheme->quota, goal);
+	damos_add_quota_goal(&cold_scheme->quota, goal);
 	return 0;
 }
 
-- 
2.47.3


