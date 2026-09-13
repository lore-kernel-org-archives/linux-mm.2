Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8315C88E5C
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 17:17:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C01AA6B008C; Sun, 13 Sep 2026 13:17:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD7606B00A5; Sun, 13 Sep 2026 13:17:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF68C6B008C; Sun, 13 Sep 2026 13:17:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 918B96B008C
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 13:17:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 48C041608B1
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:17:17 +0000 (UTC)
X-FDA: 85209394914.25.B43BF8D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id B290D160006
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:17:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j1k7zoJA;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789319835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=umQcJFGrr068QYat6Lud6jcAzEmAFL/l4IbhvroBRbM=;
	b=2HTLh7H6paHeed+CrgvPimBywX0U54TwahbmwzKCYwKJNPQeX/SNFQIVvo6DOm8RxT7uKx
	Ohu6+Gki1q3ZD+KKeccz/XdBfDOfe83q/qoCJ8zsT6Cz/unlXpOJx5ShVb2uxfER+Nwp/R
	P8sFYT9T/BAbP0HH5+266PqlKG3xQNU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j1k7zoJA;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789319835;
	b=zetK4MujELUNm8xOeHkU2bpnlfWgOSv/SmnLzYiGF8Gx02ypN1Cjdm0JBeW1ixUpD2+BDX
	W+fjR3HqcNXn6sXrBoRGviU87aBMgA6HmH/3YiTgI09fwVVnur/BSZA0c+itp2rgSFPpAb
	uM9Sb4icp/Qwn7C8FuxEDcRJwXnO8IQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5032460E91;
	Sun, 13 Sep 2026 17:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5881F00898;
	Sun, 13 Sep 2026 17:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789319835;
	bh=umQcJFGrr068QYat6Lud6jcAzEmAFL/l4IbhvroBRbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j1k7zoJAgMukJ87qFcCabtTBQywMrBVQHbaRWC/DyUpvXwM47ftkD1bexp32XZFF7
	 b/8M3iKWwESa2g4k/bLHORL1gcqtYrbrIuL0R3jcq5K8meV/q3ARaDyHya0v70JCi0
	 huUzxAOePyQ3EDjdN9OkxU2Zp1uiIWShkEwoyu09GUnDWnhLcTdtzLl3mGDaDIhC6J
	 pprqvoHR9GKtmX5r36JoYzQY8h9pDU1befab3UYj9t8gFTaRHk/FLZoUdIeThDSM65
	 4RLXgTsEbCZiIaqbWZdkwHSWW/qUSdwHa953t14G+u7XY35F0Iqm7WlghQavn3TZfu
	 BW3yxMAaVyREQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 1/8] mm/damon/sysfs-schemes: read sysfs_filter->addr_range only once
Date: Sun, 13 Sep 2026 10:16:58 -0700
Message-ID: <20260913171706.103052-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260913171706.103052-1-sj@kernel.org>
References: <20260913171706.103052-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: r863u68fr7bobzypjmje6f55jz3t6kby
X-Rspamd-Queue-Id: B290D160006
X-Rspamd-Server: rspam07
X-HE-Tag: 1789319835-488878
X-HE-Meta: U2FsdGVkX199XLbN99WJDficGBsf3qMVTtxEoCkDlDNPl/3CmMV0jAsD4YanXyTjhzRwk9tFKS3dmVW/xtbLYNZBaL1h1xvG0QorsVyA8u1uwVOt7Gfo4pud08T3tv/yCT833HVQb/+vAMkwv31jk89vlQ1WMMHro0zLTlo+bLeb6zt+q2C9RtgbbV9LYcOyplcsG1R+xYBM8hVPoNg7qjl+jV/jKCyikluc7KPWpQwL9Z05gqJ3+mmXjxz1zuZ1Br1yv/GrU5RsUxuJVrDlG0qOxoFlw+KAsqjI/N/KB+dNwU9ABDgzHRiek9KuZPeuG2zvPs6kAHmJugE9xalnsVyWkQnERKBBp4/dU24XDXiXcO7YvHivdTx7JlA+vIHOvJzDOJLU02lGm6HE68C0iO8cOHdhY1Z9JPUMipGDV0t1N+WKYcT8pIGn/2pxQ/cG2zQ3z/ncM5iXm4VEYuG3sgDWhbDf3r/bMxiyQJ6ovySKAA8463M9sH5TT/UoeYGOfPEElfz939+lFUvav/bUXJqIT5HjFtvDyI2wo3cecwiI40jX7lu+rc1L+BIh7Sb598XGJbNm+JIyMHW/xPIMMosASla065NQ9+saW+/3aHTAxy2qb0DuUalWH0xnkFGs/x3omgyDlIqASmvpURxUs3CqUoqENj1cX6/V+Fibvnwx0R+hgZuaACPyP3DjzJFu4SdOpwKA8lp3Ysic4M8qi0k4GIbe1LWsok4Q8/ml5UCpEBAnl9RnjFEyxlLwf7+woA19AxwNuKFDqE0EPk+PdP9UF/enq5DEiJ4DUUUKyJ60mkXUEttQI58TN4ZnLZMVaY9unYJnFoQiybLm04d0t0fUwIkfn1CJhoDkNMPy5XyM8NuTP9cYf619VqGI9pN51huAhEgRNe+mjEDPzJ+VI5v3hpWpSxX+f0x2zOQJYT7dMISTzNP+AP0GmyNZ+2sVvGAlAB1FArUYEI+jkc0
 pOpniLYB
 9WsEuNCMB0dTxj9LXcqWm6QsLve8JQzkOST3RTsdLfWxq1HofH7ClP6kZLenkB6m/D4lTKTyke3aJsHfDs+Y+44c5rRn0MVtPHwsg2AYRKWTpm3wzsDfwK1VdBOlikgywra4PU7XrlCcMfVg8jajI7QHw2VyDPWutM0Ia8bSUKWAQlKHu6DLBwJ7O7QeKZcMC/yPtkiUyEYAg48mROVze+t5UdiwQ7wRVMaTZE6iHLUOyiS68AjoszH8S+x260+lZERWXdOf5ml4D6iIj2JvMTj9Q7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface reads the user-provided address range arguments
for addr type DAMOS filter twice.  Once for validation, and once again
for assignments to the variable that will be passed to the core
layer. If the user updates the argument in parallel, an invalid address
range could be passed to the core layer.  Avoid it by doing the
assignments first, and then validating the assigned variables before
passing those to the core layer.

User impact of the bug should be trivial.  From the core layer's
perspective, the invalid address range is not really invalid.  It just
works as having a weird address range.  No critical issues such as a
crash or a leak could happen.  And sane users ain't do such parallel
arguments update anyway.  If they do, such racy behavior is arguably
somewhat expected and deserved.  That said, there is no reason to keep
such races.

Fixes: 2f1abcfccd86 ("mm/damon/sysfs-schemes: support address range type DAMOS filter")
Cc: <stable@vger.kernel.org> # 6.6.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 3de4d804e049f..3c1c1cb387fec 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2831,12 +2831,12 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 				return err;
 			}
 		} else if (filter->type == DAMOS_FILTER_TYPE_ADDR) {
-			if (sysfs_filter->addr_range.end <
-					sysfs_filter->addr_range.start) {
+			filter->addr_range = sysfs_filter->addr_range;
+			if (filter->addr_range.end <
+					filter->addr_range.start) {
 				damos_destroy_filter(filter);
 				return -EINVAL;
 			}
-			filter->addr_range = sysfs_filter->addr_range;
 		} else if (filter->type == DAMOS_FILTER_TYPE_TARGET) {
 			filter->target_idx = sysfs_filter->target_idx;
 		} else if (filter->type == DAMOS_FILTER_TYPE_HUGEPAGE_SIZE) {
-- 
2.47.3

