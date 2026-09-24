Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F9D3C9831F
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 20:16:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 580906B0096; Thu, 24 Sep 2026 16:16:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 531A46B0098; Thu, 24 Sep 2026 16:16:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35CD86B0099; Thu, 24 Sep 2026 16:16:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C2D56B0096
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:16:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7773AA04DB
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:16:39 +0000 (UTC)
X-FDA: 85249763718.06.C58459F
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf31.hostedemail.com (Postfix) with ESMTP id A3E5E20008
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:16:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JrIE9Tl8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790280997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lNjYmC2mw6Yjd8M3Db3AkasSR6Gybp0ryKVRb8ZCRNE=;
	b=2r7GonNhJj21C7uwTBDdNqk7VI+m+MJeZicYImG6BuB14RSY4lDc6+dJKQeA3EGi7HBc/D
	z7Uik1OSerMze+DBddnl2qXYX1vYFyMxykTUB4hDBNBdNHKiDOI6hWXfK53cl4tt3EVJ55
	7jrJsdYHaypYg6ICxgK1Ytg9cHnZyzA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JrIE9Tl8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790280997;
	b=epjnVkOFxvrlUncbG7W7aOGtLo+ohWd8Kwhs2CDG7Yrl9PTAqEi2xufzwpw0cwR8m282vt
	N+6zVEjdlHhB9E0Y9SoWj2Vl9c6Fi7nD0i0/3ye1FArzc8fGyj9cqAmplr2Bpbnh/sKCND
	K6gyXRG/G1UNNybK3OMpr+Lr2EfWOyo=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49d1ca5b0d6so1661855e9.0
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790280996; x=1790885796; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lNjYmC2mw6Yjd8M3Db3AkasSR6Gybp0ryKVRb8ZCRNE=;
        b=JrIE9Tl8mCFFV1Xq/HuCViQLUSv1rZCJL+oHOax7SODw5y2wa+OG0eEYkdnEXbpPg8
         wTNtoP1crT9vXpiT5istDir/8UQVIRwFPhFJqqIKgWALfHOO1wmDi67tJoFuhjTeW0cF
         oxHwqmMZ/d2Eb3zJrzwnZGV1l6PeZrE308dxS4pua9tAyGZLe14Qv63DNU6CPOYbjD5C
         drJilYiAKspmiu3eWLjZ7anPqXosp9ge/xoJl4vY4c8Wt28asAY0JrZTqGGLf/75wBKe
         JNUUyTdifuglpXhXzWhssso9VaSRwztccneARmI8h5niSdMpYzg0duRH64l857rPYmFG
         PzBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790280996; x=1790885796;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lNjYmC2mw6Yjd8M3Db3AkasSR6Gybp0ryKVRb8ZCRNE=;
        b=iuu5ZtKi2GJGLyQDSORLZp+N6hHyxiRoFhrcsyghfOsn81jbDngu6Kqf6Fs2O5uH7j
         VIBY13yIbdLRdOEhHL2hzVUI1RVu337dGHNWn38jwwFWh5lQ/NkfsUVXP/10oU1xVZfe
         OMJv8L9KkuIDGCliEOTmNCD0DtbcxRDXOUTdMYzTXMzKT9D/kKvGOVIu8tCPoNkm3mDr
         yQWlQmPju2JqywlSrrdexmaarx62fo6w3Fk36Bq91chxemytZNFFlcUDt14BwYkaZYzW
         9bVVUJhBI5eygPM5RtzKBu/0KRwhjai39b0p9msm/JmN1mRh6KzoNFokmyCXTds4n3bj
         PaWA==
X-Forwarded-Encrypted: i=1; AKwUvBz18nQKk+a3IXvjRa/2GMSwFa7PYvqeSbeiffO/1O5Wfz5AFxis3LycBI6KVZuFQwtcNgEZrT3BXw==@kvack.org
X-Gm-Message-State: AFuF++kLc0CpeqNE3UAaEVmTingHXfno/CeJw9akEemSmYJ/qldEzRsr
	QFd4YbuU2LaAbht/Osi446uopb0Jsq7ZFzoVLQ35e820vdu/W4uN5TS8
X-Gm-Gg: AYBFou2bJ0bAI/5PHxMGRCEO8TG0jHrcsjIXTtXpdQilKmdEdXSXNu8qAeMwF7E6S2a
	FWn+HnvRn3/yLUSoxU9iH3UWyO/oUe26J+YZJmSPRj0B/MCfjaE523IzGf6816hmj+7Jnv8PvO5
	fg+0kJ4bBDdIdXquqr17HEDAV1lQHZUU7g+xJ5g0fC9jwipIl14rIsSrMQjZPVl3v7qJmz1y+Le
	NDthYQR+gX6lS7JjbpI4FUd1NbDokwduiK1A0L8F849yoa5NV58iHJTSTxpjItr1Eo2emC7bBgt
	53/NlboLNl+TK7VoFOR3ZZjm97aEEkMWWZGw7jpmVB1QR5N9fiRQaTKjqxJuie0z44gtjMxOUQT
	3sneC55QPiaEyOfyjNFJe72W6HaEG4hHHtph0KnDrmEb/C9KPiQe5xTijlF3ew0AWolCdeGtUok
	AaLQB+lr3LMmB6nJe+7EiXjsRKN8IH9eAYTDKrAQ0T6RA+zhZddIPkm81flLKAymkIarTRD9XtG
	x9yz/sWDrrS6RmdZo7LANZqROSKJ8JmkB+uggN9WimWtmSbqeA0sAgYUdSJeix467HuUO8l3LN/
	nuS+CdUwUada1DuZ11pH3YCd0H4iZtKqJ8l0VT30cx0qYkO21577b6ADTpguCyEN7xV2rZ2AVav
	ezIrl8ciha4o=
X-Received: by 2002:a05:600c:4e86:b0:49e:6ac4:b76e with SMTP id 5b1f17b1804b1-49fe66f720bmr62480535e9.30.1790280996266;
        Thu, 24 Sep 2026 13:16:36 -0700 (PDT)
Received: from MBP-von-Karl.localdomain (dynamic-2a02-3100-adbf-6901-3138-76b5-e9f7-b9cf.310.pool.telefonica.de. [2a02:3100:adbf:6901:3138:76b5:e9f7:b9cf])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe5dfa6a7sm144818795e9.12.2026.09.24.13.16.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 24 Sep 2026 13:16:35 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bijan Tabatabai <bijan311@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] mm/damon/tests/core-kunit: test preservation of quota state
Date: Thu, 24 Sep 2026 22:16:14 +0200
Message-Id: <20260924201615.4478-3-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260924201615.4478-1-kmehltretter@gmail.com>
References: <20260924201615.4478-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fxrqprt4yzrn7mn81sotzh1fokekias9
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A3E5E20008
X-HE-Tag: 1790280997-752863
X-HE-Meta: U2FsdGVkX19ZlkZ3pUk2NTLp8tVUbBydJWNhk1NDa/s6M2O6tOZIf6IpBLWyHtBGOvSRoKEDz3SmGiuOqlFIrQPYvYiPYoA+AJKO2lDmdpkCcmo+3IytKlEI06t020yMt0BtRp2GCnKq6OD3vM6Q9LBt2yv91+eiKi2/lcgPJTzSquBnX4zrVen8C+WOXva47RnOZskgeTmaAt87DUjshTxKKWwVTFArCvW2+Y7pJBJTj5o8WCOVLkLEkrusAdaP/Mi8Vf9Qgx6dyMm33N8Sg/yAZMN/bMjslnC2sfw4kUY2Jm1nPA47c0r/5DHy64b1TPAXuFnbM8pUqyLFuZi7/QZp4wblzOUZyh5rqJToepPv2AxpYfaCqXfiKZ3s9WNP8pLiuCoVfZm0utgRTn7aGPtniWasJyQo9fdBRcxCGBchbthTEWRSz0LVb/AsV8QJ5fGKymhfJ5rFfcE8epbSGnqIvga00VEXmHjAzE4WPUOLDuVEE7GZP46Vgk716IyvNxtgVcriKf4p/poMl7sKOdDOQeYjbc+oiOHInL6JtgHa6WObQSrCjFcwkjfjF3aACBm9svNXAthOAfAE/Njb/HhElIeXCEsu8CkFFwS+jzSIJw2TqW/CbMFCcWTbQPhXiuoVF+U9sQiiFzJAIyvkZNNv5JQUe2ZJ8l0ZdNtatEa19jnZI5rxPUQvGNIQbb5kySIGDu3GUKLP5SXwJ4e0ozW6jJwQdwCIpck0n4Tm3Mqn0m4ubVjaIYra95bmS1D4B73vFPB3WGXqZrXWdTrnJJEmamTHWqptrv+AZ8FjFhMPGBP45gFNBgAaRLdnj4MkCCGYnkHoPF4di2DzdepYTvIBz3reTf8WTsaoQVhf0Vd/QiifX9dGNo+sXgJZzYaXfJ0i+6czdG1dSFBskV135xbDNOdZ5smXQFgaNRfkwyA7tQBMTACZX4CgGJyiVL7abLyFeKD3+iTDktroqsx
 5LJQMfXx
 5PUI1hfTNugInyB4uQEkrOPuUXjb5fWnU+QjMoPza/Q9s/4bAWbp1ftYyIelLn34/bQvEQRocqfArfEo1PpH+fSwFGhudmi3fAB7yqoe+yDTJ3NR8jiPJrtFSuxRqtThFvFwhl0vOGwb86eaDkg/JlyMcEMHGTV9YvNVS696X+f/2EtYGID0/yh8HQ22NRUoLzMrFU5EjB353xcJ7GrBaqMaLPL17EzLkQCgbU0NDCBZZg/6zdsJVm3rUavvkiQU6wEs/Dt89vGys/W8ltXHCxcYS+IKZ3zVtloAtpMgtoLgsHuaqssJr60VkJp5kM7HQUrZZ4uj2wk7azugJFGfRJjaKpi0dAAY/AFrXpP3gRq5/t3QhhZwUVDs0PEg5ObW5bsLnmUypyByn//YmIjHkrlj1hAtmi0ThsGRrQSsFj0C1xitG1jNwzGa9Kw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Check that damon_new_scheme() initializes the new scheme's quota without
changing the quota passed as a parameter. Cover all eight fields
initialized by damos_quota_init().

Also check that damon_commit_ctx() preserves those fields in the
destination scheme for both accepted and rejected parameter updates.
Use an invalid min_region_sz for the rejected update and confirm that
returning -EINVAL leaves the running quota state unchanged.

Without the preceding fix, all eight fields are cleared in the
constructor test and in both context update cases.

Reviewed-by: SJ Park <sj@kernel.org>
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Changes in v2:
 - Collect SJ's Reviewed-by.
 - Refresh context after rebasing onto mm-new. No changes to test logic.

 mm/damon/tests/core-kunit.h | 107 ++++++++++++++++++++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index df84d9cc7d204..ce17f44583087 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -812,6 +812,48 @@ static void damos_test_new_filter(struct kunit *test)
 	damos_destroy_filter(filter);
 }
 
+static void damos_test_new_scheme_keeps_src_quota(struct kunit *test)
+{
+	struct damos_access_pattern pattern = {};
+	struct damon_target target = {};
+	struct damos_quota quota = {
+		.sz = SZ_64K,
+		.esz = 123,
+		.esz_bp = 456,
+		.total_charged_sz = 789,
+		.total_charged_ns = 1011,
+		.charged_sz = 12,
+		.charged_from = 13,
+		.charge_target_from = &target,
+		.charge_addr_from = 14,
+	};
+	struct damos_watermarks wmarks = {};
+	struct damos *s;
+
+	s = damon_new_scheme(&pattern, DAMOS_STAT, 0, &quota, &wmarks,
+			NUMA_NO_NODE);
+	if (!s)
+		kunit_skip(test, "scheme alloc fail");
+	KUNIT_EXPECT_EQ(test, s->quota.sz, (unsigned long)SZ_64K);
+	KUNIT_EXPECT_EQ(test, s->quota.esz, 0ul);
+	KUNIT_EXPECT_EQ(test, s->quota.esz_bp, 0ul);
+	KUNIT_EXPECT_EQ(test, s->quota.total_charged_sz, 0ul);
+	KUNIT_EXPECT_EQ(test, s->quota.total_charged_ns, 0ul);
+	KUNIT_EXPECT_EQ(test, s->quota.charged_sz, 0ul);
+	KUNIT_EXPECT_EQ(test, s->quota.charged_from, 0ul);
+	KUNIT_EXPECT_PTR_EQ(test, s->quota.charge_target_from, NULL);
+	KUNIT_EXPECT_EQ(test, s->quota.charge_addr_from, 0ul);
+	KUNIT_EXPECT_EQ(test, quota.esz, 123ul);
+	KUNIT_EXPECT_EQ(test, quota.esz_bp, 456ul);
+	KUNIT_EXPECT_EQ(test, quota.total_charged_sz, 789ul);
+	KUNIT_EXPECT_EQ(test, quota.total_charged_ns, 1011ul);
+	KUNIT_EXPECT_EQ(test, quota.charged_sz, 12ul);
+	KUNIT_EXPECT_EQ(test, quota.charged_from, 13ul);
+	KUNIT_EXPECT_PTR_EQ(test, quota.charge_target_from, &target);
+	KUNIT_EXPECT_EQ(test, quota.charge_addr_from, 14ul);
+	damon_destroy_scheme(s);
+}
+
 static void damos_test_commit_quota_goal_for(struct kunit *test,
 		struct damos_quota_goal *dst,
 		struct damos_quota_goal *src)
@@ -1572,6 +1614,69 @@ static void damon_test_commit_ctx(struct kunit *test)
 	damon_destroy_ctx(dst);
 }
 
+static void damon_test_commit_ctx_keeps_quota_for(struct kunit *test,
+		unsigned long min_region_sz, int expected_err)
+{
+	struct damos_access_pattern pattern = {};
+	struct damos_quota quota = {.sz = SZ_64K};
+	struct damos_watermarks wmarks = {};
+	struct damon_ctx *src, *dst;
+	struct damon_target *target;
+	struct damos *s;
+
+	dst = damon_new_ctx();
+	if (!dst)
+		kunit_skip(test, "dst alloc fail");
+	target = damon_new_target();
+	if (!target) {
+		damon_destroy_ctx(dst);
+		kunit_skip(test, "target alloc fail");
+	}
+	damon_add_target(dst, target);
+	s = damon_new_scheme(&pattern, DAMOS_STAT, 0, &quota, &wmarks,
+			NUMA_NO_NODE);
+	if (!s) {
+		damon_destroy_ctx(dst);
+		kunit_skip(test, "scheme alloc fail");
+	}
+	damon_add_scheme(dst, s);
+
+	/* Copy the parameters before populating dst's runtime quota state. */
+	src = damon_new_test_ctx(dst);
+	if (!src) {
+		damon_destroy_ctx(dst);
+		kunit_skip(test, "src alloc fail");
+	}
+	src->min_region_sz = min_region_sz;
+	s->quota.esz = 123;
+	s->quota.esz_bp = 456;
+	s->quota.total_charged_sz = 789;
+	s->quota.total_charged_ns = 1011;
+	s->quota.charged_sz = 12;
+	s->quota.charged_from = 13;
+	s->quota.charge_target_from = target;
+	s->quota.charge_addr_from = 14;
+
+	KUNIT_EXPECT_EQ(test, damon_commit_ctx(dst, src), expected_err);
+	KUNIT_EXPECT_EQ(test, s->quota.esz, 123ul);
+	KUNIT_EXPECT_EQ(test, s->quota.esz_bp, 456ul);
+	KUNIT_EXPECT_EQ(test, s->quota.total_charged_sz, 789ul);
+	KUNIT_EXPECT_EQ(test, s->quota.total_charged_ns, 1011ul);
+	KUNIT_EXPECT_EQ(test, s->quota.charged_sz, 12ul);
+	KUNIT_EXPECT_EQ(test, s->quota.charged_from, 13ul);
+	KUNIT_EXPECT_PTR_EQ(test, s->quota.charge_target_from, target);
+	KUNIT_EXPECT_EQ(test, s->quota.charge_addr_from, 14ul);
+	damon_destroy_ctx(src);
+	damon_destroy_ctx(dst);
+}
+
+static void damon_test_commit_ctx_keeps_quota(struct kunit *test)
+{
+	/* Only power of two min_region_sz is allowed. */
+	damon_test_commit_ctx_keeps_quota_for(test, 4096, 0);
+	damon_test_commit_ctx_keeps_quota_for(test, 4095, -EINVAL);
+}
+
 static void damon_test_valid_probe_params(struct kunit *test)
 {
 	struct damon_ctx *ctx;
@@ -2259,6 +2364,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_mvsum),
 	KUNIT_CASE(damon_test_nr_accesses_mvsum),
 	KUNIT_CASE(damos_test_new_filter),
+	KUNIT_CASE(damos_test_new_scheme_keeps_src_quota),
 	KUNIT_CASE(damos_test_commit_quota_goal),
 	KUNIT_CASE(damos_test_commit_quota_goals),
 	KUNIT_CASE(damos_test_commit_quota),
@@ -2270,6 +2376,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_commit_filter),
 	KUNIT_CASE(damon_test_commit_probes),
 	KUNIT_CASE(damon_test_commit_ctx),
+	KUNIT_CASE(damon_test_commit_ctx_keeps_quota),
 	KUNIT_CASE(damon_test_valid_probe_params),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damos_test_apply_scheme_filtered_sz),
-- 
2.53.0


