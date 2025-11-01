Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9AF2CCFA03
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 18:21:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22B868E0017; Sat,  1 Nov 2025 14:20:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 202248E0015; Sat,  1 Nov 2025 14:20:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAD358E0018; Sat,  1 Nov 2025 14:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B8EFC8E0014
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:20:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8FD31B97C8
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:44 +0000 (UTC)
X-FDA: 84062854008.26.520EC82
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id E43A6C0006
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PBKwpse/";
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762021243; a=rsa-sha256;
	cv=none;
	b=OAPUvWS2lWc3oID2QTC15nhV+3wUUHSJVcFnXFW3lHC4I0lAgiAJiSnm9OKxhtdh4vY2D8
	yoJoZegyRSZBcPig0et9K3+dCETeyo4g3+mS0n8bFqVjCki70kxaqkbhL26GG5FU61AZbn
	4ER+58/88kr7EbLyx7y/I5ZQ/NZsdlE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PBKwpse/";
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762021243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LtM7TPbFvo83NhxgKLHhweSPQSwubrn+0fPjUs1hsD0=;
	b=KrDGqyF3ho2V2YnShHX5YLsJOccmFTHe+abXOlJ7QuRNfWbaGWNuvzWCeTx5yhQOIbXmWm
	WRZVQP5mMkwZZ08ZmBbjO8MAnOs99xEqBR0AKANOxZNH0JUG4Kp3SZkQueaUvKXx8rG0He
	rdpROg3QqE8lkGTNPa0r1jUgpFkjRmI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A8DA744368;
	Sat,  1 Nov 2025 18:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED08C116D0;
	Sat,  1 Nov 2025 18:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762021242;
	bh=YKKetXWckUNAeNivss353X8s+7x7z2c2pZKrb6m5Vqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PBKwpse/W69Y85fbiyxFTe0Yhn0KF55DLJUWj7U/1BQmCjOjs9/sk7MwkKx2qt5yP
	 20MSUTKtBNCNfZ+lOjrSwRis54URs5b/7mg+Kfw/rH2hL826ghikSzuGKIirCe+yUp
	 5+rnCF4THr0Xs0PD50d5TjYTJOlFqPoAkE6A4VEvydg8RtPh+3iIdfpkhfn17Zc5I/
	 W8DJnV3+sPWBnDxWk59G2mnuEWQCVFbXX/OgS/4mf2k6xoWM0lsFwIjJaQxcxIx7oe
	 em/lD1X9cfs54/iwlOuEo+LAbbcR0j7L/VS1b51U2kaDhOYzX1zWkaJSkcuyXzUEjf
	 UGN5MC4ojfWgA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 7 . x" <stable@vger.kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 20/22] mm/damon/tests/sysfs-kunit: handle alloc failures on damon_sysfs_test_add_targets()
Date: Sat,  1 Nov 2025 11:20:14 -0700
Message-ID: <20251101182021.74868-21-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251101182021.74868-1-sj@kernel.org>
References: <20251101182021.74868-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: wxoz53he5d4uzcg93a7s9w3k1cqhd8z7
X-Rspamd-Queue-Id: E43A6C0006
X-Rspamd-Server: rspam09
X-HE-Tag: 1762021242-335152
X-HE-Meta: U2FsdGVkX18gCK8IGrgYDVNClyvzKQz4io5IRx+Ig70dEb7y3JgdEVL5HVggDjXk34logK95dt4z/7qBX96+4xdVDcyM6lPLm3SpnkNeprZjr8LzaJjYT5ZYGRP8t25ni751BwLyZzig7pfYZx+x32L7CivHopojnCasFYMtQ/4jJhjEK0jItZNQqr+ctbWChS3G3aSFyMn5pED/3gNoFxAbq1ziLoyp+avFAYVeRTbpXRjgrZpZrenW1tKyimg0GY9afA8lBeEKWYozoAkBPxZH+IoXg+pWHDcDUD3Ki+XNidgjoQLy54//LGJzLbdF7FPhwyCfkTTgqmbLi4vlqFEvned5PMrP7c7zKVv+qlLsP9Koj3TVgK2ednqNE9FeldDvbP1LmxeczKt1Y3X21b5bZ6PB181yyYOzpOpH7FySzCl1W0GAeF+Y3lQZ49//zLqQ1MqZdY0IN9sdWY+gUcrGAMZJUT1WKsn/zZFy2U0ZZggvjtiuUYx+mV7ppMb5T+1TSBr0Wb7frGOPe6oIdKDu/GVYEWUfMMaIrExo1U2Ys1KTodJT+SbCvXKBJelHKRv6l6T1xl7xq7FMVqM4PtcYr4cb18//XcDdfKIYqLdFsHVukEvmx6dxGNnepYqCZLRqblZua3FoSuSgbPZ3MDxq95Z0i2Odt70KukPdsuOSrYYerMM20vTiW2OMTGrUROvwSXBVjUeNuJDyoOfB96RenhhP9x45IjFYJDhcMzu6PTGE/RBJa+BEsAbBuPt9u1hSjsIjf+GEth6MzSwLA91iZNWjYaudXOTGLXEssa/9zHodeyUQ2fkiWLbFBJIA8hHZ6zC7eB9r8dbCQXXg4BTe2/xaOJT5W/nWdwapP/Raoi0ksvj/JBRTmhWY7vGYoFkiLfiqrrayHo+PtwFWrgQVPJDaTIlsea7iT0Q3WhB7Mug005Ukv8RjJzli81BY7OekQ8sJfpi/ExBtBQb
 W7vbC+fN
 HENsqwSYOHttjdSnu4RyIzVqJcZNkaBDhMLdZ+za5g/CwbROQhqyQtXykxSc+8C+qytKsp0mMAraj67H37fDMJ3NNlwhyEtZ1/T3ma/8zs7BV9J8oXxQ10I1W2Sf7bN+DX94SSbVqRlYR4rgEPNpRbIXrEH4GiWKVCL0sQi1dkYKj1D/rbaJp5Egl2nGl+2I12Aif9dRzXBOhv1pzI63NSsFGphT8SbNgimvi5a1RRXNo4nbU3F9trb5uFolhSLerjTXQ49E2fEy6Q4fBZc3Vdo8i3SIJdBbhU+5n
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_test_add_targets() is assuming all dynamic memory allocation
in it will succeed.  Those are indeed likely in the real use cases since
those allocations are too small to fail, but theoretically those could
fail.  In the case, inappropriate memory access can happen.  Fix it by
appropriately cleanup pre-allocated memory and skip the execution of the
remaining tests in the failure cases.

Fixes: b8ee5575f763 ("mm/damon/sysfs-test: add a unit test for damon_sysfs_set_targets()")
Cc: <stable@vger.kernel.org> # 6.7.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/sysfs-kunit.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/mm/damon/tests/sysfs-kunit.h b/mm/damon/tests/sysfs-kunit.h
index 7b5c7b307da9..ce7218469f20 100644
--- a/mm/damon/tests/sysfs-kunit.h
+++ b/mm/damon/tests/sysfs-kunit.h
@@ -45,16 +45,41 @@ static void damon_sysfs_test_add_targets(struct kunit *test)
 	struct damon_ctx *ctx;
 
 	sysfs_targets = damon_sysfs_targets_alloc();
+	if (!sysfs_targets)
+		kunit_skip(test, "sysfs_targets alloc fail");
 	sysfs_targets->nr = 1;
 	sysfs_targets->targets_arr = kmalloc_array(1,
 			sizeof(*sysfs_targets->targets_arr), GFP_KERNEL);
+	if (!sysfs_targets->targets_arr) {
+		kfree(sysfs_targets);
+		kunit_skip(test, "targets_arr alloc fail");
+	}
 
 	sysfs_target = damon_sysfs_target_alloc();
+	if (!sysfs_target) {
+		kfree(sysfs_targets->targets_arr);
+		kfree(sysfs_targets);
+		kunit_skip(test, "sysfs_target alloc fail");
+	}
 	sysfs_target->pid = __damon_sysfs_test_get_any_pid(12, 100);
 	sysfs_target->regions = damon_sysfs_regions_alloc();
+	if (!sysfs_target->regions) {
+		kfree(sysfs_targets->targets_arr);
+		kfree(sysfs_targets);
+		kfree(sysfs_target);
+		kunit_skip(test, "sysfs_regions alloc fail");
+	}
+
 	sysfs_targets->targets_arr[0] = sysfs_target;
 
 	ctx = damon_new_ctx();
+	if (!ctx) {
+		kfree(sysfs_targets->targets_arr);
+		kfree(sysfs_targets);
+		kfree(sysfs_target);
+		kfree(sysfs_target->regions);
+		kunit_skip(test, "ctx alloc fail");
+	}
 
 	damon_sysfs_add_targets(ctx, sysfs_targets);
 	KUNIT_EXPECT_EQ(test, 1u, nr_damon_targets(ctx));
-- 
2.47.3

