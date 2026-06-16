Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B120CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:05:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A3426B0005; Tue, 16 Jun 2026 17:05:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1541A6B00C1; Tue, 16 Jun 2026 17:05:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06A8B6B00CF; Tue, 16 Jun 2026 17:05:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB3A46B0005
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:05:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4B73D1C2D50
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:09:03 +0000 (UTC)
X-FDA: 84886108566.11.933E2EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 95203160014
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:09:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SJYO+ksc;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781622541;
	b=qRPykcgDprIMRS9ElR5F2FQ7s/MxAlw+5nqyo0LcjMb+qhF400oQKWxh7zAqQSYTXEp4JL
	jC8I1ntiLAzvavf9AWiApZUukpO6vuXHbH5a1ETL0doqELwkOFC+RPggwKCGsVfaKAZMdc
	f8GyFexesf7vo5WtcbC8yXU/pjjIxZ0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SJYO+ksc;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781622541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fRYCEJGGbsLwqfrNLbJ3qqnMcfvhiZNMWDaTEuP0qWI=;
	b=JH8dKutK2nNZ7AK/qTn+2LQumIC0sl987xmv2fmCWaEFOOA/KKdUs63tGk1PS75pi6VHkr
	WMbx6pUgYyQl8sMQvq4d+RIz1n68+RHNBhOZkADkYlT2qPmFTXJgLIjYslVbGxBVfbhj9L
	91B4NEx4Yd/JGMN2LhmQ5hKlst2nl28=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 98BF743D4F;
	Tue, 16 Jun 2026 15:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165321F00A3D;
	Tue, 16 Jun 2026 15:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781622538;
	bh=fRYCEJGGbsLwqfrNLbJ3qqnMcfvhiZNMWDaTEuP0qWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SJYO+kscTWI6vZEd4GRfFOpZeqxztssiWSx5yfldPZKiVEFxnvVdD0kABQSOkpm9o
	 i7oKnn0L/ybhKo1PzJa1O4y77wnivc0iE8hD+isFjA6/v6mJGqQtmR5duBNUisGX2E
	 sjxevFbAf52YMHgK9KLZxzkldJF3QijoMiq1Zht+11VOHaZ/Xsg1yIFTN3TUeV5AgG
	 V1VWEaMGNfwd+ce3U/NXAkJ9XqsZGMC6MI/YE9Dh+ZydgXM4qI/eAJVK1X8M2wzn4Z
	 vclJFW5LIX/QUX/EDnnS7wdn6kv68YE5ifBCvSwRhUvuj3jIlGn2vjzu0mTAWceX9h
	 TcYByUfZC9ixw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 18 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/9] mm/damon/sysfs: kobject_del() target, context and kdamond dirs
Date: Tue, 16 Jun 2026 08:08:35 -0700
Message-ID: <20260616150844.88305-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260616150844.88305-1-sj@kernel.org>
References: <20260616150844.88305-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 95203160014
X-Stat-Signature: a81tcwantug4bz4k6kjxg4rqyyq1e16s
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781622541-347978
X-HE-Meta: U2FsdGVkX1/Eizvat14Vnh6O60wmMtubaiBneU94mqcejuwGyYSoDx0CUB5Tpl79T0k7Lfr2MLa06B8MNQGNFAkzUACE3aF7+zc2gYmurcMJTGVdduutjS/uLBQF5NPYnPmfdcTml2guJFL/gnEF62gkhvr9GbQz8i6XeLZ+8U3Y6Sjq8xgbwCGzCCASTffVH7wcU+ft11qLYJdP2liAPnQGOIH9kIrVQdVHK1+nws7BvInn86/yK6ZkNgJ0VeeDe65VfaeCW7cbsw1beC/N8nbABh+HgqNomKCK268KgeyxrqmZ2HUpD8+mkXImQa1sSSU6iV5otWLkg2np060LbUWqONtpofFhcYX23C9IkZToOfXb53NE4V4cFpeLev9wEjKhlYBSqlblc+3B9RBf57xtqOzfQHYwiAs4tPwn7xRZGuKZUVpY1CGFnP3y/j7kK4+hktdkAmdPjh2XwVUugt/IDccv8Z6r0q0HvyfuS+0wuIENoJ/4hHID4CNX7EX1ozOW65KyHeQUMJBAJb+r/LgN0VJQTU1oz0OphRoN08MmCSYD9OceGfhr3j1q+uoBjv25Y0/bsijIB8d37hUecaP1o5z+Ic6J1u6c55hK4PS5xRNF7wP/GZj1Qe+Ji52AR57SYuJ5s2vG6YrUz2pJinNIciB2Xbr3tTeFlE8fgWPWjQM4KLVm/mws7ynWxsMu9B1d6JvR+zCmUclZ/DPtfwg1WY/dst2TboAZtltSgDjnDQvRqki2s1wUHmZlxl3mUpSiO/T3dykv6Ayq75Dc6lH28eajDAhA82nJY+Jo0BHkMGFYX/uIh5H1Fvsh5xERtg8jcVVxShfZXdLhB+qmDLKwpr8+lSDarNrs1n7PsGCbAYWl0H2zSJJxXtlTmkd2jsC5lLQgrx2nt0VlU3mL59izdmmyosiiwqkgt9mIa8qlPTRhELURCTdeH1/gn9U6P/7Uowj3Q07DuGUkYMc
 07C3ohow
 mFgDl+Ku7wS5PjtsZHb/8ACgJUshLppJFUTGsQPU4g15PwEQw78D3nC62Nhopg/rmndeHbCHt5QR0ShHIjDAMw8bJRzNi5hjHjgLDd9mLMuGwfuhjFyBDXHYjnXv5yf0AlNVJzo+AhCI43LHItQ7JRUG06cIm5luN9aiQmWLxmt1eTsom+ys2xWYXSoMSVnycK49/xpwiSZpXUoPqiEvwUtETeKoS4/JByN62TiEh+3Fve32tw91vvSOZwBU8i+nv0DwOWcPie/BYpBi5RLGSp8DyMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts.
Fix those issues for target, context and kdamond directories by adding
kobject_del() calls.

Fixes: c951cd3b8901 ("mm/damon: implement a minimal stub for sysfs-based DAMON interface")
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 2e95e3bac774d..d93f7919c3ca1 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -333,6 +333,7 @@ static void damon_sysfs_targets_rm_dirs(struct damon_sysfs_targets *targets)
 
 	for (i = 0; i < targets->nr; i++) {
 		damon_sysfs_target_rm_dirs(targets_arr[i]);
+		kobject_del(&targets_arr[i]->kobj);
 		kobject_put(&targets_arr[i]->kobj);
 	}
 	targets->nr = 0;
@@ -1642,6 +1643,7 @@ static void damon_sysfs_contexts_rm_dirs(struct damon_sysfs_contexts *contexts)
 
 	for (i = 0; i < contexts->nr; i++) {
 		damon_sysfs_context_rm_dirs(contexts_arr[i]);
+		kobject_del(&contexts_arr[i]->kobj);
 		kobject_put(&contexts_arr[i]->kobj);
 	}
 	contexts->nr = 0;
@@ -2501,6 +2503,7 @@ static void damon_sysfs_kdamonds_rm_dirs(struct damon_sysfs_kdamonds *kdamonds)
 
 	for (i = 0; i < kdamonds->nr; i++) {
 		damon_sysfs_kdamond_rm_dirs(kdamonds_arr[i]);
+		kobject_del(&kdamonds_arr[i]->kobj);
 		kobject_put(&kdamonds_arr[i]->kobj);
 	}
 	kdamonds->nr = 0;
-- 
2.47.3

