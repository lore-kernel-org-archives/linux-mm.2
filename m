Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD33DC61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 13:44:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD91A6B008C; Thu, 27 Aug 2026 09:44:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D89746B0092; Thu, 27 Aug 2026 09:44:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA01A6B0095; Thu, 27 Aug 2026 09:44:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AFB6C6B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:44:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4F88040433
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:44:39 +0000 (UTC)
X-FDA: 85147169478.04.2B59167
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id BCCB140004
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:44:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B47RYJky;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787838277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=MnS4ty+RKYNyC5nGC8tLvTuVTGSdFsmrW5pkVTeJfPU=;
	b=pyurqhmDPHmGVfp+LvAG/3q0zqJNkgXoO2EfdqQovSpU5JznsDMZMJMPEk0Ddis2mzqd08
	ZMKJKAnmdwbZJzjFElDXmG+0ZyVbOcva9R1ZMSGbTr2HkeRR/3TOvxbAF6mvT5s12ES8cr
	Q8E1DvmzqpFxIf7JJ0m1AI1Ym/AoQDE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787838277;
	b=jvfM+lfuA8zU9Cy6Rctj2bHdT6XRTUEcX2XmCTANoqZHSK2YZHIk5R0nCrxLsOI1HGQc75
	WML0WMsYkoSXpfPG90tBHrNSxKNLW6zDbBWDJbGxMovdCS0jlV56mJg0W9T4NoOG31rNz6
	ZZnqzgHImt+e/0IGbvToaAwj//eS948=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B47RYJky;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E34A4405CF;
	Thu, 27 Aug 2026 13:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7181F00A3A;
	Thu, 27 Aug 2026 13:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787838276;
	bh=MnS4ty+RKYNyC5nGC8tLvTuVTGSdFsmrW5pkVTeJfPU=;
	h=From:To:Cc:Subject:Date;
	b=B47RYJkyewAm9XsyDKqhwZfHkKQIggkE4zsOVvEuX/vLZP7V9HjqH6Q5Vq2Hqiq1I
	 qDLNfcpVknpQi1z9gYdOrjV6JgMnRJL0+Hk3rxdhZPYlaV/DCC+IPtBLhMaJ8jZ6/e
	 BxMfLOwSJCWze6geE7qJ9e2gIqwdRDA320K1xUJV+oKSMFJje0CuiAL+63PHEoA3ko
	 9IFlpg/vJhtW6LnbMkK906ozBBAg1DiEXJ+D7UJQCMuCG+bnsatKArVG9MkdEOcqek
	 XJd1AG4nQ6jGQ/bG98Oz8DcmgYNapzTZT5l1CxNNuje5rXZsutbq1TGhfRr61lgIm/
	 2yOpQ0uvSqyGg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 0/3] mm/damon: fix wrong behaviors in DAMOS quota goals and sysfs refresh_ms
Date: Thu, 27 Aug 2026 06:44:25 -0700
Message-ID: <20260827134429.123023-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BCCB140004
X-Stat-Signature: 8cwm5jhpadhf18adq1qub61dsyjuoohn
X-HE-Tag: 1787838277-742511
X-HE-Meta: U2FsdGVkX1+QKy0Ysp4M+wnoJfmqIXgPMV8/dbI+xtI58H9mYIpmblRcsB7/7BfWaiMpzXnoCkX6SHDTYYeJ5x+N80GyhpZH94f77fOfCH5Rd/xh71m9a8FLE8IsIw0JOL22YuoltM1p6bpLkKdmPD6Pn0tIghBDrIarxgmcLdvuRWP/VHYHEfG9OTqSRFxOYMntQB0H5hMKY/byQTlq89TwYRPbBGeuIFbySyTxkA7LJv0huiqfwy7xpNKSrAdVK7ZKX2OdFcambe5/udKDBEKWGkBZR8yvgDl1kMHnpTnUqmSRL8SCwRHgLAdhi+nhFvyQXgKJzp26f4JxJuGCwZq2t+FVEGG/y5QThts1G4+QZaZQhavkAvt4jKl0NcnErMJOhtiEFluq9/d+CHW0vv6nLtPUGdzbNnv9UpCU97nveaoMu7GExbsFq14FA+cogLrpxLfEobwliNeogK1sBoxB6RKafbsoXjNZU4V6LkAbLFUkHjNqXd5sSOS8nn54tQ7iZ7/raOXyKjX1Cy792De6srvigvwzpaU3nbdqufl3lPkp4nq/SWeDrroMyNFfg0jpiiVWmiEGsCGKzfbBOnBHigeGyvgMYY3Bno6cMEl6YJc7dxtOo8z4y+8mBV9xkuCbKXPZH2p6Wm0ao7QPOSsAbLMvPCQ4/wkpHdr8/uOjc2tcH7F9NuB0Q3cckNudlHlSHGhDJ4K5IAxuvdOeQ5lsXYaajWFBvtjCtupc/I+j9HW8UW0aMD9UgSkDbH/sbQK7zyaNpKoZ0eCNDvuHNJbXTxob3ERc/L8u9PMZfvI/cUbV3vQ2NG90A1mPkwU8uhSTq44+rOvrqhvJ9JK1gq6I7MM+sivJPCVb7GSUfmHXIHHmbul5uQZLFClZyUg/N3Rmw2TnJQ+qYgEatqEZe01kMnJ4ZMuTnWacaTMkPdf1Jev6wCm9QKXsbahk/63IAKnbGP6qGLL7seeY11C
 u0PaBeSR
 J9l9seAX1umV90ovp/PnfDHsOLTgkK5pUB14E59F9pWVgm7hI6zvPvNfpDrqaSAGv91hjH9sdl39WWfURd3JHrfHKTA0F6jCnQKrzSfwrrqs2ka65M/Ii0+6MZ9JiFfGICGytaftXpf0wY/39mLCZAwf4aFZDORKLtylZJKjrvI70APw5KpJ+1KWEhKHkeVv1pW55TKG8foQyZ0k4TUWZ2yEqEbottzsbB5zT4D5DpB3mtkH+LYA74cyzaGyLL6H5jGkTBjjYm6Fu1F8LJKotGPxgj4UiKRckHom1APmAMRll03B7yzoaO040IWR6lsH0YhBpq7UmRZEAZ+q5lx18gOH8+EiCHzh8WbBn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMOS quota goals and DAMON sysfs refresh_ms file have bugs that can
produce non critical but still unexpected behaviors.  Fix the two bugs.

Patches 1 and 2 fix the bugs in DAMOS PSI goal initialization and
eligible_mem_bp online commit, respectively.  Patch 3 fixes the bug in
DAMON sysfs refresh_ms file handling.

Changes from RFC
- RFC: https://lore.kernel.org/20260827042920.93580-1-sj@kernel.org
  (Mistakenly missed RFC tag)
- Fix build error.
- Add eligible_mem_bp nid commit fix.

SJ Park (3):
  mm/damon/core: initialize damos_quota_goal->last_psi_total
  mm/damon/core: copy nid for eligible_mem_bp damos quota goal commit
  mm/damon/sysfs: set next refresh jiffies per sysfs context

 mm/damon/core.c  | 21 ++++++++++++++++++++-
 mm/damon/sysfs.c | 11 +++++------
 2 files changed, 25 insertions(+), 7 deletions(-)


base-commit: 9e11dd3caaf0ac70acdc0f568265a7fa5085ef42
-- 
2.47.3

