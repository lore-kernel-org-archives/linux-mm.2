Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F686C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 17:03:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E54886B0092; Sun, 12 Jul 2026 13:03:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E04DE6B0093; Sun, 12 Jul 2026 13:03:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF4706B0095; Sun, 12 Jul 2026 13:03:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B01586B0092
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 13:03:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3874F1A09A1
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 17:03:42 +0000 (UTC)
X-FDA: 84980746284.25.6A635F4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id A860D40005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 17:03:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mjT+7kGG;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783875820;
	b=TU4qMaI2HNvnzdZrSXlZJ+71P5GcYtUNy80GgsxbsxG7MM/GqLHwCY1/poqCa+IIuNK784
	jMPw8UBR0TUtJ3m1hzQbpsC97SHfZGtUy35VJzcT1/P1QJrGCEN7twzeGUFx6mV3mloNLF
	jMSYJznBpqLBdFjZyDntNPDD7N8dDYk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mjT+7kGG;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783875820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SKLq7ZuoHq2BFm176pu4DfNEYfPU8F0EbpgzHa8ZXlA=;
	b=ZMbjqM8qZSiJ5rNKqiIusTobFzALE3S1H9nDfpEAbUQLuL7TQC/gV9o8hveu1h7XoIlQw4
	dFbWOANMhZjgbnDdjyZWe49To3AYxeMWCFOCf2caLN/n4KyuNau9za7QARbEEwtEvKcRKl
	WAguILqoR5KXxAi+5i9/1YcUiW3lMAI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3AB97600AE;
	Sun, 12 Jul 2026 17:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC761F00A3E;
	Sun, 12 Jul 2026 17:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783875819;
	bh=SKLq7ZuoHq2BFm176pu4DfNEYfPU8F0EbpgzHa8ZXlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mjT+7kGGAZYWj8JiuahXfYm2MBh7kCuE9DE+qZXwgVLnf66mD8V7l5743EVqT/ZB+
	 px2Kktm5XGebVXuPIEqzhuGDyAxeou/Yg5M3DlHa+j3Fh1/kpD0DD6txtSqp5RfQ/y
	 lcFGHl2+XcewCNUxbjxgMnH9R0lVWko4XgbBORuqZ8AbCbSt3DFRDv8l8RRKBcrZQu
	 7eMhcaAEkzAYqX+zbo0qSI7Cf9AVEST+FwnpkEYdutt7uaJ2VpVjONtoiPhR2ZeCgT
	 yXnTXCwj6RviPh1VazChP3DAGy28Q8nkBEV+kuYR+vDUeAfMfNytJrGMvgT14wTs20
	 D6KhmXJ2YEGMQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	SeongJae Park <sjpark@amazon.de>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 2/5] mm/damon/tests/core-kunit: catch test failure in test_merge_regions_of()
Date: Sun, 12 Jul 2026 10:03:24 -0700
Message-ID: <20260712170328.91144-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260712170328.91144-1-sj@kernel.org>
References: <20260712170328.91144-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A860D40005
X-Stat-Signature: wbu9d7n7hd59o5uhqxqzcayu419bj598
X-HE-Tag: 1783875820-590623
X-HE-Meta: U2FsdGVkX18ukcPIkbvsObAhD4amuoWlxd/zad4LFaM5xkc0gIQ8KuO6M+KOdWgDC8hPWUJ/gZMf3WdFXcJ4X36AUMArt3ihQPrIR1yQt5A3Ixzo4UO5q0vMUNTs9QqFNWWOjsfaZdaPihiSpk+S38tuXV8Y3TjXe9/2ccut4Ugr/Oi9CnLDRjqMkZgnysxRbeLDxpMf3hswjHkSZFmDkTnO1Lfh815l+agXTBlkzowHLgUpXMoa/D6VTpsji7ve1jVG/layHTlNjMxF0iBf6H9ro0oMCQdH+VAsWRF3fNM+0uTMK2gy7SJnwEV6p6McE4PCz6YqOLxxDRpUW1/A+xW+7xFkp0gm8fal19EW2e50+9fx+vw/+VengOHvMmEuet87OEvWyul0sB5JgPzfU80tTZxxjL3kAvq5mUl6/kCw/6x7RKMxEL5UdUWho9W7Nv8Nn5ki+pnhnpoxmQKOii/+cHcp+7wwbdwO6GL0WOHl/Myy05K5sIKkm1AlFmgcQDArZR1eJF3Uuqc/x37aRKyKNsVDU9ZIuQlsrUVxCxK5BBLLkiiHBNCMtQWDUriIvJtSRSjdngbgK/iXhiHKaIsw2ddM1q8rVpPIHWhNBw0vTpk6R6ZnlEgQ8ZJaV+0BE3cqJxppZ8ZRjlXm1gq5lu8vgtFG5WO0nL4KT8oQCdUQvvrAkQIeIWtGIAP8GUHXs+WMWdtc0Vu5hBg/fZsuHTkikA9q65dlb5NIhnjGHAzCUa/qDIPRHuLZeA/f4Q9gsbi32wnV+rMZjQBuPaEHddIoXPjOxG9HZ+SbwfSbtIQ2XXt22KoyBSoCCXjLN3kiwLw5S6DH6q9NifxFK1KPtNFS7s3cdCijGlgMWe67bcaK4t03f7m7nriF57KC/xuBUIW8xkhZ0pd78hXt/NN+A2t2apzEk6DL0WqabWs0bG1IlIfuPwg1yeQXZ6dZXj/PAX12S3YMzpQCV1GllZV
 JV2nBgc3
 nGhsa36KqauaYSInMdFcM/yPcGeha3s7qhakMUYsrHXbKibDWNBty9xK3QFHVKluJsLRyiMk9xcTXk9+fs9KS0kZ/qzK1VUldzSP4In0ul5eH2hqYwnkHzoHmMD6h4yskWX3dO0TQFl0smMT9uA4/wh4vU2Y/ggIqIruotSvWAYrF8klJoeKGrVg+irxJKr1TlxK4wnR9VxlxULh3NiK+Ts8ZEccUC79G3f7dyKqR7mHlLTYQxvJLI87eVn+xtFfXTAmWTt8yNsP+LJrBSNtoXrcXpeVwat924zH+PV0PGdcEZDVcqMKjSmcFVBauzsu03sOl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KUNIT_EXPECT_EQ() does not abort the execution of test code when the
expectation is not met.  But damon_test_merge_regions_of() code after
its initial KUNIT_EXPECT_EQ() call assumes the expectation is met.  It
does a per-region test with a hard-coded number of regions that is
correct only if the expectation was met.  As a result, __nth_region_of()
could return NULL, and the test code can dereference NULL pointers.  Fix
the issue by catching the expectation failure and skip the per-region
tests.

The user impact on realistic setups should be negligible, as it is a
unit test.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260710144937.26981-1-sj@kernel.org

Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 6ad73559dd8ea..a99363720e677 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -260,11 +260,14 @@ static void damon_test_merge_regions_of(struct kunit *test)
 	damon_merge_regions_of(t, 9, 9999, ctx);
 	/* 0-112, 114-130, 130-156, 156-170, 170-230, 230-10170 */
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 6u);
+	if (damon_nr_regions(t) != 6)
+		goto out;
 	for (i = 0; i < 6; i++) {
 		r = __nth_region_of(t, i);
 		KUNIT_EXPECT_EQ(test, r->ar.start, saddrs[i]);
 		KUNIT_EXPECT_EQ(test, r->ar.end, eaddrs[i]);
 	}
+out:
 	damon_free_target(t);
 	damon_destroy_ctx(ctx);
 }
-- 
2.47.3

