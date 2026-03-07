Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3847AFC9EC7
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 00:33:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A9976B0088; Fri,  6 Mar 2026 19:33:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 457256B0089; Fri,  6 Mar 2026 19:33:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 359996B008A; Fri,  6 Mar 2026 19:33:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 22AA06B0088
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 19:33:43 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE2BD59F9C
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 00:33:42 +0000 (UTC)
X-FDA: 84517393884.22.E84DE0D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id EDCDE1A0002
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 00:33:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=atyXmy4N;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772843621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PaZnQi+abzFrlbUguZCbt5fidufuwzxrlveg/MIiWpM=;
	b=JfN44Vpfm8B53a/9Z9m8qvAnrGCfw5R9BxebTVsiuOtZwUi7bNcI8PQ9Zm9LK9BM+WOwq2
	yzOkpd6HFVrLKW4PsUCyysc0CYaB73tco0B8jnpXx+LHRJ5OhhhRRrJIuEY866I7XSqlih
	38jz3KE+pQyaXLzyH1+0yEJxpyAC2uM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=atyXmy4N;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772843621; a=rsa-sha256;
	cv=none;
	b=kQVHUlZlDTPNf54jVKWWYD8ArDSv0KK3+l5GQyeTxt44uwaOj+N7l9BGteGNeCNijkYJvR
	IeYKp5jxtRygMnV4eYos+iUp9pjUdzOjsYW42y8xp0IecHlmZBcXkFoJ5i4IXIO8ZDeF/f
	2BOtVU2UpGXybZZW3ly9eBcVus/FRGs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0640641879;
	Sat,  7 Mar 2026 00:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6810C2BCAF;
	Sat,  7 Mar 2026 00:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772843619;
	bh=emm5hofz+4Swmt0IujrmOwV5BydfZR5A4wBWzsREwNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=atyXmy4N/F7bDXE1BJs9nOpPUHx+0VJvLqlE0iC00MsdHhG6oCx8pC2fmzP6ykVie
	 3vjMuecaXqFp+iJh4o2hWaYmGOsyUT2MdEJcQ4nnq7dsFcsqbt9v+sbl6R1e5ajWrT
	 d3NXF5yFDdsLUHAMb+oeq+8hS6Q3FubDmYxtdgwWhixTe/mfJTC4vrETEFRmLEHxTw
	 L4IMNam3MBXp1YYx+yRAfTjRPiUajPcrwy2Pt2aaqll3w2KJ9HSidSrYJwUgPtQM0k
	 +n58JrPxPXYWdxZ1liRwyft8KpXK0VLk7MPruZ0ljENifrHPNrtwrHO5M8KR/sH7Xf
	 1Cl2f/YYPys2Q==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 00/10] mm/damon: support multiple goal-based quota tuning algorithms
Date: Fri,  6 Mar 2026 16:33:20 -0800
Message-ID: <20260307003321.109390-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260304044122.79394-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EDCDE1A0002
X-Stat-Signature: 4mw45kjnuuf6iwoa1598j8e5h9r9jfkt
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772843620-297199
X-HE-Meta: U2FsdGVkX1/extvbYV275K+ZnHGI2qIh2JZSTf+EHs/Vn0HoN0CiFe/Kzt19UIWsAHG8FePIjSoFiETvnzBIBXDUUuyC7EvsncHIRWEjkRew04eCxonh3nDa64GD4ITrReXcWbGf3mSOiAZqMTIf8heJE4+I3BZMp/KFrC+e5VEAplcbceBpoXvnDRPF7wgTBMR6LOEcnaVy7OPhxYoYOTDH8ezAt5IX1TN7J6Ytr3FCUbSlSt+fSzb7AyH5Jng2PnvB7y50Z0qmJJzgPudDqC8zB6Iag0q1GzSSILw07Pde38SkTkHPXtpJOwOJLmMrtJcASFtdG/l9C51/Yhf6EZ421yZLeX/6cHhfqebGp48sI5cVLQoNNSiQCFHbcZm00XPYqd81omfi1IX3jCdrtFweDxJvk2wjc9TnIKA4dTFD0p8ofq6EDnJdfVZv9GyxJ7Jqumi+bcMGWqPfgKXxBWP1BkNuC42vimPNPZKFqPIQRg74Yi7a+E4dZCNI7M1mkr7PFiMBAhbCZJjIY8Znldip2Gvz2tZjqpLjBaFBLzIkQ1NegpCkrthII+XKDwWEBGOwB5jTayV+KOYZcpJsQ+2Rhxrckl6KH8IE0PSaKtlgAFDJCnZeX8iF3pSj2wjBiaqvG//lnEaV3dFqJqeguKeEKmKRS6pmpx29rvTJftaY+PrVIq8Fk6iG1OYlNpUoCEjwvU+W/WRbbZs4AfBEhlImb9gTmCRiYSXG4opLVi0qBMVfsYUzI6YXN7fbskdAWHvyBzFHgV6lFJfdXZa1Hnff+gDxtROJ/aKcimBMrF5DRX6q39tfvdfh7Pt2VbocTqs43cXTcPoJ0wnAeOWNSvrS6oJhEiRVeRPk9/0+vvZEzC+hYdz4LITJXdAMLHmSNgVb225NZT9Mjy6fMJYMffRgeAvKjFQnXOyh+AL2LNQq71ZAvfHQZ/Lvj3oCsqPt4iNTdjXilnDv5ogbrsm
 SBLP5+e2
 dmWm7Kyjmlp9izHEj0YLQmwMr6vKAt0YTAqrfy4P/NAV7I1a1GkRaRD8VDOPV335nI7q23GgvNruEVPt4uNuusYLdSAI+4qEAfjNC3TrxzxIQcK0ebTc7IbO8dFZK/Fo5/q3T16THmroUtuNOAUnZkQhiEJi8n2XckamKvlH1OowBEbHw+r1RjrtCIxkrCP1Pw2vaAcIcDZ5nDH/HIVlbOKk7vZYwL2mqjAj0jmVDitwkF2EpDlgs44RX/qFcFhF9f6+s3Pxl664AMosB3qhMcEut/7GWfUWyZgrrtqmkLUu0y+/tu6XJzjG+B74P8FiKyyHA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  3 Mar 2026 20:41:09 -0800 SeongJae Park <sj@kernel.org> wrote:

> Aim-oriented DAMOS quota auto-tuning uses a single tuning algorithm.
> The algorithm is designed to find a quota value that should be
> consistently kept for achieving the aimed goal for long term.  It is
> useful and reliable at automatically operating systems that have dynamic
> environments in the long term.
> 
> As always, however, no single algorithm fits all.  When the environment
> has static characteristics or there are control towers in not only the
> kernel space but also the user space, the algorithm shows some
> limitations.  In such environments, users want kernel work in a more
> short term deterministic way.  Actually there were at least two reports
> [1,2] of such cases.
> 
> Extend DAMOS quotas goal to support multiple quota tuning algorithms
> that users can select.  Keep the current algorithm as the default one,
> to not break the old users.  Also give it a name, "consist", as it is
> designed to "consistently" apply the DAMOS action.  And introduce a new
> tuning algorithm, namely "temporal".  It is designed to apply the DAMOS
> action only temporally, in a deterministic way.  In more detail, as long
> as the goal is under-achieved, it uses the maximum quota available.
> Once the goal is over-achieved, it sets the quota zero.
> 
> Tests
> =====
> 
> I confirmed the feature is working as expected using the latest version
> of DAMON user-space tool, like below.
> 
>     $ # start DAMOS for reclaiming memory aiming 30% free memory
>     $ sudo ./damo/damo start --damos_action pageout \
>             --damos_quota_goal_tuner temporal \
>             --damos_quota_goal node_mem_free_bp 30% 0 \
>             --damos_quota_interval 1s \
>             --damos_quota_space 100M
> 
> Note that >=3.1.8 version of DAMON user-space tool supports this feature
> (--damos_quota_goal_tuner).  As expected, DAMOS stops reclaiming memory
> as soon as the goal amount of free memory is made.  When 'consist' tuner
> is used, the reclamation was continued even after the goal amount of
> free memory is made, resulting in more than goal amount of free memory,
> as expected.
> 
> Patch Sequence
> ==============
> 
> First four patches implement the features.  Patch 1 extends core API to
> allow multiple tuners and make the current tuner as the default and only
> available tuner, namely 'consist'.  Patch 2 allows future tuners setting
> zero effective quota.  Patch 3 introduces the second tuner, namely
> 'temporal'.  Patch 4 further extends DAMON sysfs API to let users use
> that.
> 
> Three following patches (patches 5-7) update design, usage, and ABI
> documents, respectively.
> 
> Final three patches (patches 8-10) are for adding selftests.  The eighth
> and the ninth patches extend the testing-purpose DAMON sysfs control
> helper and DAMON status dumping tool to support the newly added feature.
> The tenth patch extends the existing online commit test to cover the new
> feature.
> 
> References
> ==========
> 
> [1] https://lore.kernel.org/CALa+Y17__d=ZsM1yX+MXx0ozVdsXnFqF4p0g+kATEitrWyZFfg@mail.gmail.com
> [2] https://lore.kernel.org/20260204022537.814-1-yunjeong.mun@sk.com
> 
> Changelog
> =========
> 
> Changes from RFC v1
> (https://lore.kernel.org/20260212062314.69961-1-sj@kernel.org)
> - Add selftest for goal_tuner commitment.
> - Set goal tuner inside damon_new_scheme().
> - Allow zero size effective size quota.
> - Update the ABI document.
> - Wordsmith change descriptions.
> 
> SeongJae Park (10):
>   mm/damon/core: introduce damos_quota_goal_tuner
>   mm/damon/core: allow quota goals set zero effective size quota
>   mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL
>   mm/damon/sysfs-schemes: implement quotas->goal_tuner file
>   Docs/mm/damon/design: document the goal-based quota tuner selections
>   Docs/admin-guide/mm/damon/usage: document goal_tuner sysfs file
>   Docs/ABI/damon: update for goal_tuner
>   selftests/damon/_damon_sysfs: support goal_tuner setup
>   selftests/damon/drgn_dump_damon_status: support quota goal_tuner
>     dumping
>   selftests/damon/sysfs.py: test goal_tuner commit

Maybe it is better to add a kunit test for the goal_tuner online commit, like
below.  I will add it to the next spin of this series.


Thanks,
SJ

[...]
=== >8 ===
From 15d87f41d0d960e3c337899629cf4e05d09dc042 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Fri, 6 Mar 2026 16:27:45 -0800
Subject: [PATCH] mm/damon/tests/core-kunit: test goal_tuner commit

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index d759314df00d8..28e5de749db04 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -791,6 +791,7 @@ static void damos_test_commit_quota(struct kunit *test)
 		.reset_interval = 1,
 		.ms = 2,
 		.sz = 3,
+		.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_CONSIST,
 		.weight_sz = 4,
 		.weight_nr_accesses = 5,
 		.weight_age = 6,
@@ -799,6 +800,7 @@ static void damos_test_commit_quota(struct kunit *test)
 		.reset_interval = 7,
 		.ms = 8,
 		.sz = 9,
+		.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_TEMPORAL,
 		.weight_sz = 10,
 		.weight_nr_accesses = 11,
 		.weight_age = 12,
@@ -812,6 +814,7 @@ static void damos_test_commit_quota(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, dst.reset_interval, src.reset_interval);
 	KUNIT_EXPECT_EQ(test, dst.ms, src.ms);
 	KUNIT_EXPECT_EQ(test, dst.sz, src.sz);
+	KUNIT_EXPECT_EQ(test, dst.goal_tuner, src.goal_tuner);
 	KUNIT_EXPECT_EQ(test, dst.weight_sz, src.weight_sz);
 	KUNIT_EXPECT_EQ(test, dst.weight_nr_accesses, src.weight_nr_accesses);
 	KUNIT_EXPECT_EQ(test, dst.weight_age, src.weight_age);
-- 
2.47.3


