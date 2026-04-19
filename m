Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85EA9EA719A
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 16:10:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAE0F6B0324; Sun, 19 Apr 2026 12:10:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A36E56B0323; Sun, 19 Apr 2026 12:10:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 925BD6B0326; Sun, 19 Apr 2026 12:10:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7961A6B0323
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 12:10:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F051413AB0E
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 16:10:13 +0000 (UTC)
X-FDA: 84675792306.04.BA3B8CD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6BBEA14000F
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 16:10:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RcSfOb3c;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776615012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NoNIPxg413G6GYh5eE3OkprcImtU5PYyP2sYlRTcH+4=;
	b=e67jLr+CEPnxeTDg4/4wjqp/nEDND9T92xlk5ag7FYzs3iGAc4enqlPpvtoG/J69A0Ko4g
	CUP87XRaH0awBWhyNFvtj39w0HN8J6aXjTdVvAInGvVvnuSZ9D3DldUg58tzYOsMx8MZSJ
	lw7ntLJUK52jF2xn/IqkDBxK93kOuLo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RcSfOb3c;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776615012; a=rsa-sha256;
	cv=none;
	b=k76k5rm2udQiB5gXX5wuj00juJZSjXpFdN6tDjgZpI76UmMnU7J88ROChEZHEsy79Oa1gK
	w0tYy2Qu4Gr63SUXrXRAtx04q45T2RSlnlvEm0YhgASkuuLpxZGEo3BAQCxyS36Jn6gzrO
	beppvSQsZHlxEOZymuGIRHeGjLhl9KY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C76606011F;
	Sun, 19 Apr 2026 16:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45554C2BCAF;
	Sun, 19 Apr 2026 16:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776615011;
	bh=ICP4ejP14X/+oD3w9wU26G/JpfDfG6uEmFxcpnMElSw=;
	h=From:To:Cc:Subject:Date:From;
	b=RcSfOb3cljkpqeIwkHFSmEkODaVwl7Ey6An63tiBa4ncCL5Kcv0z2WQZzreEzxaW/
	 NBn3ybcy6q5HtCdC77f6fg9Y9RxvotACAgS1GnsekMOW4eM4JpsN3H8iS9LyHbTBcW
	 w2kqqrOfVQhwJkf5TMB6QWv/gVVMT1H20+cSyZPw1Gys1dBAkqaKtVV5vtvN0uTKao
	 Mf6NB371qUvXYB3nKfgyex7tJHZgQdS2UimQAFkIZfwOZ9E0fxEaXotPq0GmuHXZF3
	 dwbU+vpb/0PYKfHYtnwd3PkmteR4W5YfPX8DsH4xcvkwlGyo2bESJFzEugk3OO+XRs
	 034ZmFWcoQHNw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 19 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 0/3] mm/damon/modules: detect and use fresh status
Date: Sun, 19 Apr 2026 09:09:59 -0700
Message-ID: <20260419161003.79176-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6BBEA14000F
X-Stat-Signature: 8fgqkxyw7dm3suac3yohiumrdgis5ptg
X-Rspam-User: 
X-HE-Tag: 1776615012-826373
X-HE-Meta: U2FsdGVkX1+bAa3RF65YDzTQ5n8XAfMB2eaMhCuBvrt3w3L6XetN3twoKAZ2qNgPLsOUdR8+k2FjbwwV/4j9B1GznMprAVc0q+I1CCvX2GHlq76ThSEWOTrsn/OlYF7auY+OlW3VuQH0pJrU+CMzt5qUyYJYMQobomumiLbkme/8yd6H1mGW7OANGinLjNGldFEHW8ZDG0NNylqPAdThGve+EsvTjK8DmlGwF5nzfEPUsJkKgTXczMS2MeYXOxfL3JdxUbhFwRRZaVD6plfeuyKrUSVpmhYqXgOlceK60B1tklYqOiHxUcXxgPx14dZ+GC3Zj941nlk3P39/d6cn1Mqg/FCbA8xNc4/nOtyLE4VFK27jIPu9dIPgGk9fy3QDXs7EA4GOHleVGxUzEtcDgcVuB/HIWqIFsaC5EDHRAKEB3ipvKW5Tk/ckT44OxGZXmcZPr+2CnsL71AJszfyi8Q2xapljMbJF5MKG4mCipmuUxUxQSp/EV/Q6SvvlPpHRA4iB4zRh5B/i42rDDKOrHtIVSCoGe0XxWz6SvIBQsz9IkP3t+Z3xlGd3SpN8EnyqQxS/uNvPXPKgC8dSS2aBBYCvowyndk/sWAbqeWVj3a136mO8Qg1qOjiyzqbaZ8vpHDW2JZe24uKu8U5nGEZ7UvhukIPHD4kgdLia1NKBxyx/7KDyz1XIuoqCGgLmwL1FZwYpohfeaQwyC2AG1VJZLiQ0GMxcwJV0b8duDzXCnJbY38zBOdNHvCyLebO/GcOwvhmloHrkCBlKOkFTaihdbzDEdmFlxODlS6f1U+PKbYK10wVCUradmdsg7bQNj4wAgjhD9WzSld8aSLv/4n5m/m8YQzYAI1kFAzLTQtEwrDn5JmFs2+PDZNR1zufdtGii7srg/E4X9h3AhxynsZpJknL9wTufFDkXAj/GYS80M+OprWyHgHikPUArButOvY+MbwbDF8G9uFT/6OxJf7f
 6zAaXcCN
 qfhIBfrT6p1H+JL1Z0588FB8Mv3vCrdMdHFuik8eEbJw/zgnSZ0Gl0ahYd6hjVHFHpf1fP7RzJm3LLwiMlroYfDs8n2S2raovK5xL2r+YP2g1eCh0j7EeJDZln+OY2E/jYC4CMEwIecgNDDYkAL/0qmMZmxwqAh6Z8yAb6fnoJHyIINDR49KccbGkB+mX7aIbYDgxvMGolWMxwY1x+/iut//GvKftkBkdxOvSdpG1xbk0VwC50jCice1XAtNEQdikX5cm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON modules including DAMON_RECLAIM, DAMON_LRU_SORT and DAMON_STAT
commonly expose the kdamond running status via their parameters.  Under
certain scenarios including wrong user inputs and memory allocation
failures, those parameter values can be stale.  It can confuse users.
For DAMON_RECLAIM and DAMON_LRU_SORT, it even makes the kdamond unable
to be restarted before the system reboot.

The problem comes from the fact that there are multiple events for the
status changes and it is difficult to follow up all the scenarios.  Fix
the issue by detecting and using the status on demand, instead of using
a cached status that is difficult to be updated.

Patches 1-3 fix the bugs in DAMON_RECLAIM, DAMON_LRU_SORT and DAMON_STAT
in the order.

Changes from RFC v2.1
- rfc v2.1: https://lore.kernel.org/20260418222758.39795-1-sj@kernel.org
- Rebase to latest mm-new.
Changes from RFC v2
- rfc v2: https://lore.kernel.org/20260418014439.6353-1-sj@kernel.org
- Set kdamond_pid set callbacks.
- Support multiple enabled parameters setup on boot commandline.
- Acknowledge the third patch was discovered by Sashiko.
Changes from v2
- v2: https://lore.kernel.org/20260413185249.5921-1-aethernet65535@gmail.com
- Add RFC tag back, for sashiko review.
- Detect and use fresh status instead of trying to catch up all scenarios.
- Change Liew from the responsible author to a credit-deserved co-developer.
- Move authorship responsibility to SJ.
- Add DAMON_STAT fix.
  - RFC of the fix was posted separately
    (https://lore.kernel.org/20260416143857.76146-1-sj@kernel.org), and
    only commit message wordsmithing is added in this version.
Changes from RFC
- rfc: https://lore.kernel.org/20260330164347.12772-1-aethernet65535@gmail.com
- Remove RFC tag.
- Remove 'damon_thread_status' structure and damon_update_thread_status()
  (SJ pointed out this was too much extension of core API for a problem
  that can be fixed more simply).
- Add a fallback in damon_{lru_sort, reclaim}_turn() 'N' path. If
  damon_stop() fails but kdamond is not running, forcefully reset the
  parameters.
- Reset 'enabled' and 'kdamond_pid' when damon_commit_ctx() fails in
  damon_{lru_sort, reclaim}_apply_parameters() (kdamond will terminate
  eventually in this case).

SeongJae Park (3):
  mm/damon/reclaim: detect and use fresh enabled and kdamond_pid values
  mm/damon/lru_sort: detect and use fresh enabled and kdamond_pid values
  mm/damon/stat: detect and use fresh enabled value

 mm/damon/lru_sort.c | 85 +++++++++++++++++++++++++++++----------------
 mm/damon/reclaim.c  | 85 +++++++++++++++++++++++++++++----------------
 mm/damon/stat.c     | 30 ++++++++++------
 3 files changed, 130 insertions(+), 70 deletions(-)


base-commit: a51b50e60d2dae1f66329f147bde8723e6b1031e
-- 
2.47.3

