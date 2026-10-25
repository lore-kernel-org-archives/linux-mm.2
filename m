Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDD89606A31B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 18:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CgxJsRH4
Received: by kanga.kvack.org (Postfix)
	id E93E06B05B2; Sun, 25 Oct 2026 14:00:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF7376B05B3; Sun, 25 Oct 2026 14:00:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBEC46B05B4; Sun, 25 Oct 2026 14:00:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9E1306B05B2
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 14:00:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1952312064F
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 18:00:50 +0000 (UTC)
X-FDA: 85361914260.17.D7D88AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8C2BF20006
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 18:00:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CgxJsRH4;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792951248;
	b=rs2U40GyrUcmzglFCVxNfEtSXX/nM+oJoU1yHBAbaXQzcMupRVND+AH2ra+2DC0C5aJlJ3
	NmlIRsyApu5ztkujYShG6vRvj0HXfvodJIIDQU5aSsb/NUMzl5WbIgVEnuC9lOrjr3hHnv
	9vjtEOopiDivmEu4tISf68/szzNs3rg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CgxJsRH4;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792951248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GyEh0TwwqVHVC+Uz5uZPmfD33kzhIpkmMSy/zdUq/EM=;
	b=ZTnTSFnqpV/4KBG4XlOi7L8H3WhST7tE2AM4JZBBTymg72V2K4Q9On485dgVDqfiUeul9Q
	Oup1KgiSoJTT+Ke8ruJnoV3QGt7SagfYlI0QQffDsAKqXpEicMKa+NLSfAnxImxOSVPwZk
	UvYC2jbMxEVz7wanxhJ26HdEcF29+fk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E88E9600AA;
	Sun, 25 Oct 2026 18:00:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC131F01825;
	Sun, 25 Oct 2026 18:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792951247;
	bh=GyEh0TwwqVHVC+Uz5uZPmfD33kzhIpkmMSy/zdUq/EM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CgxJsRH4LVNHNvLuMniPe8HrqsbqZOFUEbY3ndhUtA66fh5KLi7N9j4BphI4DMxb4
	 7sP9+KC2SnhaQzgwFiyfQWb7KB8p+FP7oouf8BjqjAfW4d0Q0GEIfE6q5Hx+4EisO1
	 +giZqa9aDVYR6afju772f1PlmpuRv73uskpc4XouggkTuDuhKcfpN45MyWNeciJgay
	 2BR97j+l3RXtQXEBlUbcxbG50hC8jsZv+kGgraQymmbfZ56eFP7CKZHBo4RoOTB38V
	 XmKYlmoEGwCANU2RoD8fvppClQ79wEWfEpj7ZNuAQlCalUI/IyWcMkkvWZXc//WE9L
	 xdMPeXIb3509w==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [RFC PATCH 7.2.y] mm/damon/core: error damos_commit_quota_goal() for zero target_value
Date: Sun, 25 Oct 2026 11:00:39 -0700
Message-ID: <20261025180040.170037-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261025174647.165255-1-sj@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xz114mzf1xjtko3qpmwcu36tx566jjkk
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8C2BF20006
X-Rspam-User: 
X-HE-Tag: 1792951248-616363
X-HE-Meta: U2FsdGVkX185C4nvAGHCoZtqxfk7/LpmZDBsrCrfjTStSFNh5fWraHV2IZFdhoAUYuOLv3V+muxwhXvby+xgtkg0cxJC710ldDHpB/cUx7i1WFy4uiWANv5ndCvbupcRlQWfoAG8Libqs3LYDADrIGyvos+IeuN74mDgqGuOtJuEnWrXJtjM2IBaHhRItWzIde2Qqm8MBCeo8V5EA/t+V/sOv9a4A7TJF5s9TKMWWTEOHXWwdUGox/p9dpq7mlo8IyaTEwC/VLoV4X6Bn2hzquvQKqphMhtnJ9AmSIDQ+JyXu/ItY5eWY3bNcJUu/KYtJKRnuqiu4fNH/vvd+MsPsfTQVQmVABfNF/Tvl8UOk8hUy3FI67j5ZwUzJ5M2wwsa49ZKYKBe+zQe66M6CzAq4YjhYEEmmaDTw7Vzopjp5RYWFlJ3kp3qyEfCsIHrdIxD6uJYwwnp2PVbB0WpVBYyVr5vsEVTiEGuQbTUafXg7hUTX34+iMXGcoxho4GeoVB+iKmZ8GWWJHc8aQ0xqOcdkA7lT1uVu3aDqaDB9d/6mekduibVzyFMqLkLZgzt7xRMo5AHlVdaDvm9thcpMXaNVd9ywJ1fyLBoWYE6Ezn9rniTq9FlK1XwL2wO6hHnyzVwv1sc68b1f59IzQvpTZ1ClJAlo3GMt9W05CpE10hU0FBgOldBJ+3YK38AgYJ10ExdksbfHdrZP+MbGjD5YTFWL9BW/yBBLyaRzlFUqc8pir9cFSQ+RV1kuGbh/Kv8NIUPjCxMLPQ5EpBsH1wR90Yo4jZvCi1X+D/4pE1/HHL2KH1EzfBP9kZC4WvBIctCZOx3lSYlX3m/bnVUobcihlXqQPOr4qYnjZ/OUR1kb5d8jCFMx8nIESiuedd7uYVr8qBov5evghxe9CEtC4AWbZVS9KMPefaQIiKuCPMKBZOUB5IEANdrvX+Dnw1IkeXUkpWpnQhcgpeL8Ry1RkMIRb9
 S0f9wswB
 6I+ZXVfetp/jTtYZuqlchoJRlIV5j28wHu43j5SnhhCoVwnTZyOmpgSuRWUXUA8D4nDdTtXHlfApEe8fayBqMhkk695zdvdLgtnuTtsgSWa25g3JtwdRMHAuIjp+ronBXclAz9RNYl2sfU8QN9xIVmlyyFhs5w5DroSfuiPavEPmWCYWNKfj1mkuIwsRe7v4UIErX06XloaiLN7GCyhqgm9ko6agCKo4i5ED5wF1HCDniyikacWo7zoOwcx2Ecr43oI2J4Mvx82WEBDP7LEaV0mtlFrEzz78daWZEnyqozAbx4oJRkJNY0IEhzZJQf9jlv18rB09BhHHG/vhA2XN+aI1xeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 25 Oct 2026 10:46:46 -0700 SJ Park <sj@kernel.org> wrote:

> On Sun, 25 Oct 2026 10:24:33 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > Patch series "mm/damon: move zero damos quota target_value handling to the
> > core layer".
> > 
> > Having zero DAMOS quota target value can cause division by zero.  DAMON
> > API callers are checking the target value parameters to avoid that.  It is
> > easy to make mistakes in some of the multiple API callers.  Move that to
> > the core layer.
> > 
> > Patch 1 adds the corner case handling into the core layer DAMON parameters
> > validation logic.  Patches 2 and 3 remove no more needed DAMON API callers
> > side handling of the corner case in DAMON_LRU_SORT and DMON_SAMPLIE_MTIER,
> > respectively.
> > 
> > This patch (of 3):
> > 
> > If a DAMOS scheme has a damos_quota_goal of zero target_value,
> > damos_quota_goal() could trigger division-by-zero error.  Hence each DAMON
> > API callers should do the zero target_value validation.  It is easy to
> > make mistakes.  Actually such bugs in DAMON_LRU_SORT and
> > DAMON_SAMPLE_MTIER were found and fixed [1].
> > 
> > It is better to handle the corner case only once in the core layer,
> > instead of multiple places in all DAMON API callers.  One straightforward
> > option is using an alternative denominator for the corner case in the
> > damos_quota_goal().  However, the zero target_value is meaningless.  In
> > this case, the quota goal is always evaluated as achieved or
> > over-achieved.  The quota will only keep being reduced.
> > 
> > Simply avoid using zero target_value by adding a check in the core layer
> > DAMOS quota goal parameters validation/commit path,
> > damos_commit_quota_goal().  Update it to return an error in the case.
> > Also update its caller to propagate the error.
> > 
> > Notes for stable kernel porting.  The upstream commit doesn't have
> > Fixes: and therefore not ported to stable kernels.  It turned out it
> > fixes commit 8b549a4fd3c5 ("mm/damon/sysfs-schemes: commit damos quota
> > goals user input to DAMOS") which was merged into v6.8.  The user impact
> > is a race condition that can result in divide-by-zero.  Hence backport.
> > Reproducing the issue requires sysfs write permission, certain DAMON ABI
> > usages that are supposed to be uncommon, and a rare race timing, though.
> > The issue was discovered [2] by Sashiko as a part [3] of its bug report.
> > 
> > [2] https://sashiko.dev/#/bug/linux-7f814c9a-986f-4103-a55a-ef9537dcf62b
> > [3] https://lore.kernel.org/20261021005234.94107-1-sj@kernel.org
> 
> On v7.2, DAMON sysfs interface calls damon_commit_ctx() for validation purpose,
> for parameters commit but initial DAMON start.  Hence this patch fixes the
> issue in parmeters commit but initial DAMON start.  I will post a new version
> to cover the start case.

For minimum change, the next version will add one more validation in DAMON
start path, like below.

'''
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2226,6 +2226,20 @@ static int damon_sysfs_repeat_call_fn(void *data)
        return 0;
 }

+static bool damon_sysfs_valid_start_ctx(struct damon_ctx *ctx)
+{
+       struct damos *s;
+       struct damos_quota_goal *g;
+
+       damon_for_each_scheme(s, ctx) {
+               damos_for_each_quota_goal(g, &s->quota) {
+                       if (!g->targe_value)
+                               return false;
+               }
+       }
+       return true;
+}
+
 static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 {
        struct damon_ctx *ctx;
@@ -2251,6 +2265,8 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
                kfree(repeat_call_control);
                return PTR_ERR(ctx);
        }
+       if (!damon_sysfs_valid_start_ctx(ctx))
+               return -EINVAL;
        err = damon_start(&ctx, 1, false);
        if (err) {
                kfree(repeat_call_control);
'''


Thanks,
SJ

[...]

