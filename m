Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98F8310F2860
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 23:33:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB0D76B008C; Fri, 27 Mar 2026 19:33:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C61976B0095; Fri, 27 Mar 2026 19:33:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B77796B0096; Fri, 27 Mar 2026 19:33:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A63FD6B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 19:33:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 594C2C1F75
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 23:33:25 +0000 (UTC)
X-FDA: 84593446770.02.6986517
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id D757240006
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 23:33:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aV3zfb8V;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aV3zfb8V;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774654403; a=rsa-sha256;
	cv=none;
	b=wPdHpgcbQqSmol5UgQ8TNKQldW9IAS4P3VkQEAKl+9kTwlGpo+CwlLris5F2iKcRoew0ud
	hEB4iveh5GWcAhtEx6zX6Cua9yApT+O0eodoVl4Ffizyg+miCmpeev35hoyleGAyLL+b/D
	Oi0O6mUQMTGs3wdwMPz+d5e+MQLhzpE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774654403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6nt6bgTg7feQbqCAG3lgF1oGbnOb5bLOzK7dYR6qxmM=;
	b=CFKlfo7DWdcAKGD0hgkmqY5FgfvcjUarcMNqd8pn+NhjVNXLuv/JJh3swsWAO6r7ZDuQ09
	pErHWjAfD8luNsZaPJzyhcp16gxDN2aB73cx+pKai0oxW6+WwH/EW/jej6VScNQS65vIuj
	DFjYVRQtZwY0RGRWuoflVYLhgCoZT5Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4FD6B60054;
	Fri, 27 Mar 2026 23:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D254EC19423;
	Fri, 27 Mar 2026 23:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774654403;
	bh=dWCz2l4DePKMhhkdEk4cKnFnxgNxvWZ3jr/uvPfGnKk=;
	h=From:To:Cc:Subject:Date:From;
	b=aV3zfb8VQPsec1pWT3gMYdrkuEN7lNzJdgQFsiDX/Ne0FwTJgqGc5cSDY9C7gQIj9
	 PlUEfuYv3v6h7nJlkdYNNS6KV99+muIGgtYIfLY2xK6PcNEe2zl244eVVRJW1/+f1U
	 G5+Kh8983qoYEh79fc3+d8nO31o8mcPFWV7lyYHObNOw0Q2Bdhbzu3ApotV5wpI0xV
	 V5DRfegGjPi/ItdFohfT+zrUW66Scp8HdfH8UoRarG9gb6/oVNBdEoL7hMaUYnKH0d
	 QHxshrk+D/6oSPzmLB5LQ83QAeoABvoQXDKl4Pb6RQx1Qd8G0ym7xaZ3zVkJk5gwCe
	 pM6Squ/iQ6dXQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/2] mm/damon/core: fix damon_call()/damos_walk() vs kdmond exit race
Date: Fri, 27 Mar 2026 16:33:13 -0700
Message-ID: <20260327233319.3528-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D757240006
X-Stat-Signature: gacg8bmszkuydcncue1c6yc1zbjfy6we
X-Rspam-User: 
X-HE-Tag: 1774654403-817833
X-HE-Meta: U2FsdGVkX1+fp6gaZHGlVbmxFNnu+sl+LRLwwc2aLyqsS4h4jut4Z07rJ0B0HqcrkapGvRAt6Rypv1wqrmS/m0N+xXR1feFYB6lO23EJfC+qQWhfJHTK4SEbcIs899ETe0LVboaWpL4Q7Mtpd4SM2Q6jYQhEUeKi5jR1hoPh1/PebYjfn31DREPs2CJK6r7C5ZDHpfw+KO5X8HyhwJxJdADQXv3kwRKGoH0ZcdUq6l7Rh7cTUPylt83baKvXn6cJJlVXOrXiW7RT5Z5yA+T/9Iz0FIbK6gTrwXpyq+8UeVdb5Mw59Vi1OqAxZUOgeEDXmEOsDXr/E1pv6TwcSSXSleuiGW+o+GiuM1tBsM+xOPdRPhtSZSLy81eA6x3TPKBYm8M9XJ6lRH+Fyt5IZpHz8tCe+EZn9BhRzJpzq9FRc1NzFcpONzNefpieI0BKrBBHMd5GT5REXJsdQO3LHHoEkXIjztSxqxK+P4x8IN0pb5XiX+PFHE28BWBEz/7tuY7QDAu6qfPHlZnAFISyTMXVJ+GqHmAZylfIYD1O6atVGf3p4meFvgOaM3/K7WILAY0FV+VpaK1q69O7DHeaktiL8kqwyKS1/9Uj4IPAoa5xotyT0kw+APgCqzI60A5a5Cp81cz103KKjpSGc84157XfopZo9ImFX+Pg6RqVxLihcXRttrBMKNV9o8Lnq5J+JKcYw1LSCfJN0K3wJOKWDoaS4y0qnrke9ur/t7EUQgXgCcJzAZVd4H+BCmiqCWIbbBPlwZpgiylBLP8g7Bo7QtieJy8s+ltKQSipXmverlEF3XnqYNH2nGG3WzGQwO2qiA5lfdRno39px0oUB7rLG9SyhTEOCcx3DBhF+Ryk1AGZS7nmE2jPdZZ375MDOdTeq5s0VnWUb+mfZDxLj3WHDxVlLgLBc6Br49Ky/BrE/OCkQz/QtaLkfNS8JD9gcbc57caxgoVk3CJmmF0WumhVOCx
 G1V67d4t
 27v+aICXWnTvQxR7NlZ4W2pDpZL7sTEgxh9QLm8ad+eN0CAB3JMQAxsg+Y/JADmG3d2mCkoRNY1bZK4GehylcpuMeYD1ocMUjEzn9dgXqAEEq4Iw1tz1w/nb9P4h8uMkR9qel6vnwcaoKU3r7dlGst+aET5XnK7/zi3V28HD8z1xgVudfWQjucGRJABDjBDQcNJBrKYMYYIAHq6jAkgBdzn6Q5y9g3d8IwbDev7/ge9kHnrT55k/NXVfz0AWn4c/owzsZMGxmSnnejDsobAKRJgBOwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_call() and damos_walk() can leak memory and/or deadlock when they
race with kdamond terminations.  Fix those.

Changes from RFC v3
(https://lore.kernel.org/20260327142605.4834-1-sj@kernel.org)
- Drop RFC tag.
- Rebase to latest mm-new.
Changes from RFC v2
(https://lore.kernel.org/20260327004952.58266-1-sj@kernel.org)
- Update and wordsmith commit message.
- Add damos_walk() race fix.
Changes from RFC v1
(https://lore.kernel.org/20260326062347.88569-3-sj@kernel.org)
- Clarify damon_call() call condition.
- Init call_controls_obsolete before kdamond_started completion.
- Wordsmith commit message.
- Split out repeat_call_control leak fix from the series.

SeongJae Park (2):
  mm/damon/core: fix damon_call() vs kdamond_fn() exit race
  mm/damon/core: fix damos_walk() vs kdamond_fn() exit race

 include/linux/damon.h |  2 ++
 mm/damon/core.c       | 66 ++++++++++++++++++-------------------------
 2 files changed, 30 insertions(+), 38 deletions(-)


base-commit: 305aff97ab8306284a0aa85f9128403b50c89019
-- 
2.47.3

