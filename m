Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFEC6F31E26
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 14:22:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 108E36B009E; Thu,  9 Apr 2026 10:22:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B9346B009F; Thu,  9 Apr 2026 10:22:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27016B00A0; Thu,  9 Apr 2026 10:22:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C049A6B009E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:22:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E1A4D1A0840
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:22:04 +0000 (UTC)
X-FDA: 84639231768.07.ED30562
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3212C100006
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:22:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oalTStXa;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775744523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4joi/1jxL0tMeoK2jtxaL6glpzvmpSwsvYu1Z1ZZFRc=;
	b=F0gfBpybPN2Zk36DiLs4cy/5VZZcI0VfnnoZhufkhLYgjcIcgTtA9HzQ2bDtFlbO5+Dhpa
	xPwPHe8yMJ+Rxj+9J6X6NyHgVpelkQjZz25rKfWEBgrRJdedRnSeTmu4b6VJyl3T3deBIO
	Nigdey6JVyMf/rgQZxpqzBd1sN0Y+TM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oalTStXa;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775744523; a=rsa-sha256;
	cv=none;
	b=QDQI/n/rDl94fV0iMjSJTQeWLd4Ljsg0B3VLKUR5M+dlnBkHm79IHm3pxwLp79r/iyykvL
	fHSZzKrZFgLLgz6MXo2ENvzdZNnYew/u/ZQJIlM0Kowo9CNKV6oVRhcoPhYdSBz1WHhkgA
	h8PRnaioOXcqIXEjlt3Rl+9g1CM5oc4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 62A7744538
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0233EC4CEF7;
	Thu,  9 Apr 2026 14:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775744522;
	bh=EuOHul4fripHvwsgWhBfbomSmWCRXpHL6QQJMWdANgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oalTStXa4K5sBORw1mgSQoL+F9f6rKw3CicXIy7SO+yYgNunmNGoW5ehkeP7pc3Uz
	 XmkeAD9uXFl3BVeVNireldkfkTGWCdmdCC4rrDMnmDtdEACASjPNQ7WqwZsKQlWeg5
	 qkNMhwrsCV3TNRI/PDe+o7bFihoabLQlFdsb22SbyHI0VB9/msGKWrVqpysKfM0SFw
	 lubyQ0MPzvoi+oby8P2uIEtlDoZaItQeQY3Wr9Ec/3V+O2CkyWYm/GC80X50YWGuZC
	 pc55uYmPg3yoEMO6Fuix059rBMVLLN8kDFnWm/TO/QZPYsnQHx3y/Dn8jdDRaIGX9Z
	 FPgvBHB2iKNvQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 10/11] selftests/damon/drgn_dump_damon_status: support failed region quota charge ratio
Date: Thu,  9 Apr 2026 07:21:45 -0700
Message-ID: <20260409142148.60652-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409142148.60652-1-sj@kernel.org>
References: <20260409142148.60652-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3212C100006
X-Stat-Signature: 344ui7if8a6yyhm98hazrzca67otgg57
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775744522-757250
X-HE-Meta: U2FsdGVkX1+TeIs4klA5aayCpyKEf/v4t2xRcJQ1rZk+vKldFnp9SROAvNNHb8rL/SP95blAsfY1fJNSRmLdR6ii6Zc43P2EaqrqZ+S9+FiX/irbrmUdbagQ+TJ9kRwicrNsG5sp0Zh7weDn83WGfkGagykFai1WM4i5ieA8boMmEB9zUCQ/X/9tIvk6KlDajVFseWxOCIKsK0SXYpB6EGhsaR5APwqwScTEPffMkwAXat6NcKrNyE0MfEMR+hK4sUkOqmoX00GDnWimy98nKDNutbjJ1YlVkAWj91W7h6+ZRsAMmtU7Z6Rc03Jok1QIiu6TTawK8uYPq28MjsSUArJRzK6RNVdQCF2vLWtHCkm3F2ZM5JpTz22RUuN4A7MwH8d+jXdboI02tPSYL+Rgyxqqd4RLypQPpIXiClyXQPJYkJTGSpIeorSqtx1Bky2HxYBXXf2dhrEDOHC5GYmKJz5E8og6FRXoO2cIvRtJAi7x5TuDq2kMYc2C1lIKCp1C1ydL0VB+jxWSXOb0bOaRW1MgSaL9NS5668vCy4LRTr1RHSJIW3NsHNKUonfwPMAPmKGtf7G5bz01B6B3sTDTBJVZlJKpr//fpGL9M9LqmOh2c2Uk0TaTUjO9nFuwiFdNJM37vUOu2/tyUo00zam7e/ssufLYmgO+acm1RqlIxVLECP1EZb3gGbr8XjoPBMoZTYfsCF/VrgkZJo4ji1DSepx9mT8wigue8A0nfqfJgM/KJvGnhz/043TZaEOLc57BIM+MpfInFx0NAXeFki8ftXcB185rqcKT2UofYB6w5CTtdimlzhz+gaWIHZgwFbF5arxn5CrQdPWpehPZKOvbnif9aqYfSTUCAH56Kyp/R05KWgzK7/ldXzwXiI/lOU1IjRiixO6EhrxOODG5iAn+6qsXecyJ6y0o/1i7GS7Z+KK4NVY24t6DNzl7uw0DH+BhTfiFn4jJIADbEtXCRRZ
 AD4o2xCs
 BvrQNCKzT4Q4IFaV2NL/T0HKFv7rXE4PwCqVem9o+DszlzyUIWgDam4A47LjmAmPozeDkuJ0Sqe8YfwauruHuZnxu15RuLQNXdMzcq8nH93VY2E37FeKJb3yYq+QGH1aFvgFx3vgQlXNMVYLeEE8II0An3WrFKKJjxj0LhK0P1XOEW6PhVf1E0hRwkf5bhIK5l0oovkPSVpHoJ+MoWp5W5G5puEKVhqy1wajD5/tKEoa4CkQLB+EOxWp7Mik8BRa4Zm5QskASEa+PbPX19JnOZcQw+E+nPJfYtNDL9FxXNIKUJqLbbLNcsilRZCTTGOS51AyhThr1BUZ+rzcLxYDjqPpm+Xzov5Gl01tS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend drgn_dump_damon_status.py to dump DAMON internal state for DAMOS
action failed regions quota charge ratio, to be able to show if the
internal state for the feature is working, with future DAMON selftests.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/drgn_dump_damon_status.py | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/damon/drgn_dump_damon_status.py b/tools/testing/selftests/damon/drgn_dump_damon_status.py
index 5b90eb8e7ef88..972948e6215f1 100755
--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py
+++ b/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -112,6 +112,8 @@ def damos_quota_to_dict(quota):
         ['goals', damos_quota_goals_to_list],
         ['goal_tuner', int],
         ['esz', int],
+        ['fail_charge_num', int],
+        ['fail_charge_denom', int],
         ['weight_sz', int],
         ['weight_nr_accesses', int],
         ['weight_age', int],
-- 
2.47.3

