Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A203DC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 05:28:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FE5F6B0099; Tue, 28 Jul 2026 01:28:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AF8B6B009D; Tue, 28 Jul 2026 01:28:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EC9C6B009E; Tue, 28 Jul 2026 01:28:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0B2FA6B0099
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:28:20 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 81A3BA0200
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:28:20 +0000 (UTC)
X-FDA: 85037054760.06.8BAEFCB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0568440009
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:28:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V2dGFUnX;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785216499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=69vkU0D1ZC9y76VW8fWIr/5QR0D00VAs0a00zXjnW44=;
	b=yFrTqtEHjjzBCdTN8hpqvDz7C9waj0umNVFt7fGvXy83/3TrbN8fMd9X2LPXc0gbqKMaDE
	7vcatLt1lKf3m61tfl5KEImHMNLazH8wBKAB08cLIog0ZWbQrqbPLrQpiRFbsreplJObgJ
	2HIMHTL5KKP9MU7XnlyxvAEaT6PWnT8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785216499;
	b=Ekl1yIGpjTRJIkOmoE1alpL6KzXZYG4j/JIFSyKQXHevijwbIWeNSqco4b4+emK8sPhjp7
	6yGm4G1KKsQmyPQU6NjV61iEVHeiVQP8Et91QA8NgRqlYRWYHfkwj20WA7s0ZeYYTJfwD2
	jKL6JHsSXE3l2/3vg8/xk3YkK2WraSo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V2dGFUnX;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5354B43EA3;
	Tue, 28 Jul 2026 05:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72131F00ACA;
	Tue, 28 Jul 2026 05:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785216498;
	bh=69vkU0D1ZC9y76VW8fWIr/5QR0D00VAs0a00zXjnW44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V2dGFUnX32iH54X59LjRu3KD43H08ytdjfiq+W5IUFp+yIkbUrYs1F2dfRnIE8BRQ
	 Iu52W7c30k2K/2h5/Xh4ad7jBJutRyAtzYrrZr8zlSzC95R6NQ9o/FOs4mp56nnIw5
	 B7oYHEj2YhBHmZoJcN0Q88Dzzu0+CpeKBSI8z9J3UqJQ/6JQ2jkKens0bs+0JktGRl
	 7clUKJP6ZebDV3pHXLd9+V9AP2sHhWkuSS/ELDpki0GFjQyQWfp4n36Z7vWW/OAlwo
	 utdNUJ+RcKkr40FZ/BjP+1R6sseXmqBZbKhEzOyCJRhWE4RdngTUCA2nzBCVJynYA7
	 8/QKsaoI7XWQQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 06/10] mm/damon/tests/core-kunit: test overlapping ranges for set_regions()
Date: Mon, 27 Jul 2026 22:28:05 -0700
Message-ID: <20260728052811.192712-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728052811.192712-1-sj@kernel.org>
References: <20260728052811.192712-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0568440009
X-Stat-Signature: s7fwccutdyfggkwzzyja3w9y68qrntte
X-Rspam-User: 
X-HE-Tag: 1785216498-423938
X-HE-Meta: U2FsdGVkX1+69i1dm4IUnOZTOrKJO9p6IvIduP7ciScwDn7/U6cQDNv2Dn2ELr8l557Pq2GzURSE3aI/euSTynu0M1pORv4O+pooCUgCuXaKqbK6DnhgFWQgb5MmxaCuVCKsDXzleOlC3X3O9LkeC15vQF8bvUOPn7RmDtRZqbOCFfh4oGfLsKL7LE+DaY6fjtV6xXiJAs50m6t4Hv/zjm4VhexO040ZosYoLxJEBO8OMBScz0AA/GOq2D9XoRZJEtTvzWD4yVG/xGUb0JV/L5he3ngj8eu8l6qke13DDhk+0OhD0IGdaDTcIQg6IfHC03TGuNkn6Jyjn1KE+YShRLq7Po+AOsmhp0EWAx0dPpnL1S7T5X8mpjDBL027YyqJBEKxwpgoa0MW27Fd6lSQ5qYaBInhuEMN23nynw4e83W52jETUBTHbQyQAITSXSU1EtZkz9Zpk5j5DK9x28FFDCNIUBeJj52ZHJ1KYWt67kfzdiLpxYWQDT7TuF1qbenRDBPYweCZOgONuJ8X1+YrTCgzCrzzcmsSdDtY8rV9PG/QbQjGMqhpROEPyo0nhFdG7Lxw7abnJ22ag42XtByVq+GxsDeashZG4IM7igdM1kIF4DbAnAffqO9XdZTRxVtBbrRY17TOmpm30PLJxD58j4vkYUo+GemrdMzo6vHGLyIrj48iSjhJ+w4+90xSyAlXX6FOZMEAw1Ej7xch3hNh5PtuKSomOjSLrqcdeK2muFHrgYaYUpjwNZ9a2xRofsVdL/+zSE9zei1OSOCFx5NtTqymv2FF3lF+u3siALurWJuYSfMX4xVPq+X4P9J/n/BueeKP1TOcjKcEqndklQHDx65q2nCGOi1Mpec5QAegSXuIIuw+E1SOWrQyUYP+L7SCP39kLWrYE4yoYNjI4urTAOLSWeF6YnPpyYtJDrc0DlqZd5iN1nGTQL4tHMQ+0H+rIGRVrJPZHldHBCYGXWE
 7GSSU7VK
 R6MdgOWVzrmNjtdTfLhgfye5/TwwFni78rDXC9/jFHhv9fTulSXBLqxnZAlRArTBasiYWy2yRN6tYnmZ9dta/xlrLPjwGLv7EbXaIvrEEUwOrBn4mfzfcVfZm/GnTwqVlrjJqIZAP9kJQYAaVq/Z1eunetUpFDB91PGdkMVf326ILcxWjQ+z3tgeHGusfiw5CDfkDXTeyPcbcNwGMv7FZiIZIWCacU8ePZD83tR9yKlnMUNPhYAzizxOV4dF1Ilpx1XcruUvomDqlG1lUk1CzkJ7Aig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 954157679ec3 ("mm/damon/core: disallow overlapping input ranges
for damon_set_regions()") disallowed passing overlapping input ranges to
damon_set_regions().  Add a kunit test case for the overlapping input.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index ac15393a7935b..3041b8288ec26 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -606,6 +606,17 @@ static void damon_test_set_regions(struct kunit *test)
 			{.start = 42, .end = 21},
 			}, 1, 1,
 			(struct damon_addr_range[]){}, 0, -EINVAL);
+	/*
+	 * Regions resulting in same region after alingment should return
+	 * -EINVAL.
+	 */
+	damon_test_set_regions_for(test,
+			(struct damon_addr_range[]){}, 0,
+			(struct damon_addr_range[]){
+			{.start = 10, .end = 20},
+			{.start = 20, .end = 30},
+			}, 2, 4096,
+			(struct damon_addr_range[]){}, 0, -EINVAL);
 }
 
 static void damon_test_update_monitoring_result(struct kunit *test)
-- 
2.47.3

