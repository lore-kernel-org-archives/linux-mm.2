Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16220C98315
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 17:53:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 780626B008A; Sat, 17 Jan 2026 12:53:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72DBF6B008C; Sat, 17 Jan 2026 12:53:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62FAE6B0092; Sat, 17 Jan 2026 12:53:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5040E6B008A
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 12:53:07 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F32EB8BA12
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 17:53:06 +0000 (UTC)
X-FDA: 84342201972.26.35A62E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 78D2FC0008
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 17:53:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MgIAAu1w;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768672385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=goFLKuCU9qfnmZ5A0+BQsN0J6NO4WPCgxUWbVzafo2A=;
	b=od9T5+MOkJI8POqB3MKfgFkXNx8uAIzxIpT2/y1prPOeh5pji6CYn7hRShjsZel71Py+dD
	J4UAtEMbTs9W+Jnp8iZtyA4q/n4l/9nG0Tr4cY/9o5Vqe+Z+E6ZkmYfJu3eKI3oNYHnnNB
	+Hg1dIa1wLrU2B2Tt3Y9Si3XMG0VX2w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MgIAAu1w;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768672385; a=rsa-sha256;
	cv=none;
	b=Dac5ZdND+CVQ72SZBOq/2kASAEyAszwsEFCknrWTtrL0WOlJa2yNhE9RnxQdAGbGYA8pVk
	X1ibulKYaUOJYiM4ZkesCG3x7ZLHdxTz2u+W4MoPnxw0Ozfw+65nDzyGUW17HlxWGVUpUp
	ggloaqqRt6lggQKNxhsQ4UqG/mq0mYU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DF3AB60127;
	Sat, 17 Jan 2026 17:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EB5C4CEF7;
	Sat, 17 Jan 2026 17:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768672384;
	bh=BrhbCrEirTOhCYFjA97mSPQaKUy3EH5FD2Gu/gQI3T8=;
	h=From:To:Cc:Subject:Date:From;
	b=MgIAAu1w4/CWCZJiuLLu5kFcobQQr2kktaP5aJUyrLFsARW4KF8/g4i8gcsk3uKhs
	 k6WnlweJvSFt+ha6mHfoQGQODYc3RcD417fU43BA4ZexjId0zXOjaMPdG47jQaVtrd
	 EWHBiGxUyDwmK0x1tNJEtdrcMNpP7lizmH2IzdMyrJsgh0tKPh0g7y30QUjAxqVIgJ
	 1TvEKiCT4Ql/HfUqEDWyLUcBoMNl/7TcXnt/nYhUpnJW0MUDtzJnFwfp6kJxDMobOz
	 QgNfqsXExC0kvwgmtW/ku93cGdA5zi5598Q+mpUomS/xR22gSoPRWCvNJ1byoELGy8
	 Qebwzn6y9/K1Q==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/8] mm/damon: cleanup kdamond, damon_call(), damos filter and DAMON_MIN_REGION
Date: Sat, 17 Jan 2026 09:52:47 -0800
Message-ID: <20260117175256.82826-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6ye3ekq943htb7moef7c115y8c9995ox
X-Rspamd-Queue-Id: 78D2FC0008
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768672385-497703
X-HE-Meta: U2FsdGVkX1+2VJGQEbkG5tLpifPp17cQpiO6rXvjjMDU/k44h3ZAtNFqCs+uVK5x1ezZzn2wN7kvBQhPRx/rcyP0WXoEA4DpFn5TO64rWjtyERuIvvKd1vKnkf28sJ8axpteOH7bRSGM/DK+XZELw7TEGZiNX0HUwGZapqzEZaVCehk6bUDeWH/i5a5JUSbI5UpTt72cmp+eSD6SIBjWbmVsUfIZkuDacLZJsxOLgRYL/ar8z8366/HSIat006XtpxJOTqerhpI+VycU90kkByJdtyDbHW0pmfQWn9M/epxs/eXL2aOwnGw0UG/87bxyJ8lo2fKqjPu9o14Kub/HUftVwWhAiEp4JuVtIXc6D+qquaJom4FemeF9dC8d68fuiro3NQX8sihVhv1H3xtKEHyHlTwqVfIw4N+cIURwc4lEAGz91ZBIPqhlcO+xJ9mEQn+9Iy6mudh4WHjCONWl1aNKsdHLpyKIKOy9VQT2WVM0ZvniBUsoeN2IQiBn/jW0GZD2wdAQ7YDOFGrre+g/tnWegeHQcwyc94kPUOEzg46mPy9Js/XvL59fL+4hx1EdvsllA1KS+s3MhyKT8+6AeNSt6CPUV/S8dJJ9ahNGxcHi7T1naa32vG+OlI0t6usGMWyHSURqc3ry2St/ZHCgDPBWyH2T2oymvLoY/4JSL3li1vi3R+EgKbsInbfSOpc7MjcFKv4dHEpeVfAbnL5EVW4FzNSfnGFR6g5pK4MbyYO5GCqbQy7cR6z90bisVXz5M2zAWb5B1YngdWj4ULKi5Rq9ZzH+FaHJx8Di/J35OJhpumGniIyU8bLqeGjn2JiCGhiVqWaRaP+mjVRyHplvyBG97Z+3e/g3ujpidEgJdQijxDjWlfbXjS9NF9only3qg+1zSEKhSae2W74EW3wH7Uy45uWRlcL373+cDp3WQDc+qLVelVkUmRLyweaYbG/RYBTenKi0pthFJiaGgel
 Nv9nKCdv
 kF2oGohI0tGeXG9SaEzB9gPeWolngniLJmuUDgthUCquTyPpCo2Q6GNU3+TBI1KA/ZX+rHkAojyaQoRBFnOUoVdg/upQpPQqKBo+7y8bg8tnlSbWoe2nd9FaebVb06XH5TTotSjXYSTKkdNGPJGnMHIXIdZtmx/b8e8G95QAc8hIn92VqC9QSXI4oNLgr2WjhKzZKn2LwHUuyCbeP/5gD8os1tXl6Cl41p1IJsVeTQonymGeff8Ghy5BBDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Do miscellaneous code cleanups for improving readability.  First three
patches cleanup kdamond termination process, by removing unused
operation set cleanup callback (patch 1) and moving damon_ctx specific
resource cleanups on kdamond termination to synchronization-easy place
(patches 2 and 3).  Next two patches touch damon_call() infrastructure,
by refactoring kdamond_call() function to do less and simpler locking
operations (patch 4), and documenting when dealloc_on_free does work
(patch 5).  Final three patches rename things for clear uses of those.
Those rename damos_filter_out() to be more explicit about the fact that
it is only for core-handled filters (patch 6), DAMON_MIN_REGION macro to
be more explicit it is not about number of regions but size of each
region (patch 7), and damon_ctx->min_sz_region to be different from
damos_access_patern->min_sz_region (patch 8), so that those are not
confusing and easy to grep.

SeongJae Park (8):
  mm/damon: remove damon_operations->cleanup()
  mm/damon/core: cleanup targets and regions at once on kdamond
    termination
  mm/damon/core: cancel damos_walk() before damon_ctx->kdamond reset
  mm/damon/core: process damon_call_control requests on a local list
  mm/damon: document damon_call_control->dealloc_on_cancel repeat
    behavior
  mm/damon/core: rename damos_filter_out() to damos_core_filter_out()
  mm/damon: rename DAMON_MIN_REGION to DAMON_MIN_REGION_SZ
  mm/damon: rename min_sz_region of damon_ctx to min_region_sz

 include/linux/damon.h        |  15 ++--
 mm/damon/core.c              | 143 +++++++++++++++--------------------
 mm/damon/lru_sort.c          |   4 +-
 mm/damon/paddr.c             |   1 -
 mm/damon/reclaim.c           |   4 +-
 mm/damon/stat.c              |   2 +-
 mm/damon/sysfs.c             |  11 +--
 mm/damon/tests/vaddr-kunit.h |   2 +-
 mm/damon/vaddr.c             |  25 +++---
 9 files changed, 89 insertions(+), 118 deletions(-)


base-commit: 886ef5515d08f05191b61a347fc18f371627bdd4
-- 
2.47.3

