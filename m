Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 282DECCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 18:44:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 048DC8E0015; Tue, 11 Nov 2025 13:44:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF5E88E0016; Tue, 11 Nov 2025 13:44:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B484E8E0015; Tue, 11 Nov 2025 13:44:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 981968E0018
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:44:32 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6B0AA1A016B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:44:32 +0000 (UTC)
X-FDA: 84099201984.05.32724FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id E7CC34000E
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:44:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FNPTrLvs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762886670; a=rsa-sha256;
	cv=none;
	b=6YhMhOhUSOnJsME8UlpsQbQ+xnQOclqmm6mhP+BZm7XBAFK6QOk24l92BkbfZ9AIsK7k9Z
	VqjqHe/Fxs4tUFR6RtBv8X9gTReGBZCwbF5ZaX8oqCj8MyQdhKL1k9euJTRhd9YoLyLtgm
	AKZqyH3xegXpdn67ih6sQXJIpv9S29I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FNPTrLvs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762886670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YP8Pnb8a8CH83ePzz6IlyhaAHkHRAs5/ySOeXwi6TJM=;
	b=cMgFdDDdx/8xM/jQ02FMaxHYu92d696K+PC00bdbo23Bbui0X1TYLKqheuffTA1BhDAnjU
	sqzKaFV0BwGfAzKAEN2IVGqz1UbKHRdppaYYQwIVVQmEtrUjQtFjgclKL9gVDwv2Quy3z8
	fv6tWVfT4xUoerWrGjHoNVGFAjwnZVM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6D53760212;
	Tue, 11 Nov 2025 18:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B0FC2BCB0;
	Tue, 11 Nov 2025 18:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762886670;
	bh=m/GX1of/o0JwmQB22uABGhbz8AVH+G+y5IyrNLPgTaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FNPTrLvs9YPxmIT6K0ECp8GD35K01XGC/S34VT/9Wej8jKHlX0asTUZSAxO3VSoKg
	 34behRhWEUos0wj4lYps20hRlOSRHQTvmS30ugkz5TkUL7qrEYyTsveSy31dBN5yAa
	 Sm/wkBIY0eYDWjuDoyOPYGMKHWbErVsUEWTrAgDJVe0KdBDgMKRpfnZE1Cd8DnO9Ze
	 n6VVw0LB9GW1+5i8gwGKg40k36uRDBmgEDvZtNLA1MzpZ8GJ4nOCE+//jsud4X/gVa
	 Jqq9stjJXqb1n7xE5s+hpLu2mzMUkWMFBsQzO8XWJWdHNQZ9DZoZQa1UcDn+F3Tb++
	 dXoG050dSrRCQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 11/11] mm/damon/tests/core-kunit: add damon_commit_target_regions() test
Date: Tue, 11 Nov 2025 10:44:10 -0800
Message-ID: <20251111184415.141757-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251111184415.141757-1-sj@kernel.org>
References: <20251111184415.141757-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E7CC34000E
X-Stat-Signature: ofsygezk6mmiwpjde55a178byujnx9bo
X-Rspam-User: 
X-HE-Tag: 1762886670-302243
X-HE-Meta: U2FsdGVkX1/KdiqbvUHbHtD8I/xx6HS2yA85zLKh9howIlX1Xt0ptJ6K3vhe6RCU1Cj4R0wVmRvIZMhWnbxOrzV6NgZHQxYT3glvRu/lZq1wWERCZEHxHkFyH9RF8IJCXIUHvywf8D3L4tKWcrDjew/6U12Av1YBJKCn1v5bztJY26lzfc+qv2fdu9zXizkMC55BipAXpqcWMjW734Z1Ijs7arLtCdNjN9Zqz7MrkPyYMnGM/V3lwZRAVwTJrUBRFMtHZgUHXW9b3SiVg1nY/zZCq8PYH3ZOakOKaHmvCYZAGXgOhAUwMUo1Owvvg3ev9zXLm5+0q/jlKaml0kv9C49CRH7EvPmV+VRVlDYy7JrzmIPOdGJ2VjhwrOpgaBjw3yKU43icvcB1/fSVQxljf3r2NHpXfBsAbIuSidm9M/1BG3tjyJmtX0e92V1Hyt00wzpZujCZUvx9hA2vnqOXlj4OMp2rPUSchsK+OrqNVs+FRIHZ9OxJOhHq9Hrrlze2r1KIDyL40pwa3jXiLWo9PRyDRSaBhG/5h0MxxYbHBTArdwP3AJ04Bb8uePLXGlvIpclPzI4fizBGio8Bhf9VeQ6SDPLVxwrPAe6Vz1xxuEfEfoB2mqwP7M0mLQmTWLr+3mWpIjCzk3V5/cD54bdwtQmCAN4pzDpdiCLp4X6kgs5Z9llttwqcwX9QmsuT019wFKgBQ5exkqFvSWHZhyZsZqhxc8DT8ImIr1QypQf/FldUgy+jLUm2k36lP8I3WFYQqolPG4JUhpmw4ihBKjKb0ofGo5MmvdY5T6HBZ+LzZrhvxlany6rfZhM2woShd9gei8N88G8JgMLtAxG9YvhpMdT+aGx2tdyBHVmhqKBUAFUY7V+RpELv1CaWobXAmkiYXlqnGKSEt2lYJTrFccWwpmld47C9tH6NEAx9ukyg2uigaadEBjfzzMRKFo/6SlOcLj/CYJ7b2TT+dEDhJLM
 OijfJWAJ
 cD/fbMUkbmPcg9KC6Q1blWOXWz7OffqkbBGAT/7NzhDc6b/oa9m5i36AhW7QJ0RiHNx6crYOIPA8Fg3xg586wfm/bDVX8XPnr5IxUQXQgb96Ps8VFTMgAx0W5+dJ8oEvcabNtgwc9jl2EA73s6br1Jv6F6mw2hZax1rEuDLPC+eeAkOqhv0R7Z5ird02WwgMdMA43exj9KtOh3ayYc3PVXiM3WcrCciGtsrxqhrMMyJb6lBRefDCxampIeWqlXMN8F2q36ZARETiIIqHoCogINsxFsQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new test for damon_commit_target_regions().

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 65 +++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index c71c10f9e059..0d2d8cda8631 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -964,6 +964,70 @@ static void damos_test_commit(struct kunit *test)
 			});
 }
 
+static struct damon_target *damon_test_help_setup_target(
+		unsigned long region_start_end[][2], int nr_regions)
+{
+	struct damon_target *t;
+	struct damon_region *r;
+	int i;
+
+	t = damon_new_target();
+	if (!t)
+		return NULL;
+	for (i = 0; i < nr_regions; i++) {
+		r = damon_new_region(region_start_end[i][0],
+				region_start_end[i][1]);
+		if (!r) {
+			damon_free_target(t);
+			return NULL;
+		}
+		damon_add_region(r, t);
+	}
+	return t;
+}
+
+static void damon_test_commit_target_regions_for(struct kunit *test,
+		unsigned long dst_start_end[][2], int nr_dst_regions,
+		unsigned long src_start_end[][2], int nr_src_regions,
+		unsigned long expect_start_end[][2], int nr_expect_regions)
+{
+	struct damon_target *dst_target, *src_target;
+	struct damon_region *r;
+	int i;
+
+	dst_target = damon_test_help_setup_target(dst_start_end, nr_dst_regions);
+	if (!dst_target)
+		kunit_skip(test, "dst target setup fail");
+	src_target = damon_test_help_setup_target(src_start_end, nr_src_regions);
+	if (!src_target) {
+		damon_free_target(dst_target);
+		kunit_skip(test, "src target setup fail");
+	}
+	damon_commit_target_regions(dst_target, src_target, 1);
+	i = 0;
+	damon_for_each_region(r, dst_target) {
+		KUNIT_EXPECT_EQ(test, r->ar.start, expect_start_end[i][0]);
+		KUNIT_EXPECT_EQ(test, r->ar.end, expect_start_end[i][1]);
+		i++;
+	}
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(dst_target), nr_expect_regions);
+	KUNIT_EXPECT_EQ(test, i, nr_expect_regions);
+	damon_free_target(dst_target);
+	damon_free_target(src_target);
+}
+
+static void damon_test_commit_target_regions(struct kunit *test)
+{
+	damon_test_commit_target_regions_for(test,
+			(unsigned long[][2]) {{3, 8}, {8, 10}}, 2,
+			(unsigned long[][2]) {{4, 6}}, 1,
+			(unsigned long[][2]) {{4, 6}}, 1);
+	damon_test_commit_target_regions_for(test,
+			(unsigned long[][2]) {{3, 8}, {8, 10}}, 2,
+			(unsigned long[][2]) {}, 0,
+			(unsigned long[][2]) {{3, 8}, {8, 10}}, 2);
+}
+
 static void damos_test_filter_out(struct kunit *test)
 {
 	struct damon_target *t;
@@ -1170,6 +1234,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damos_test_commit_dests),
 	KUNIT_CASE(damos_test_commit_filter),
 	KUNIT_CASE(damos_test_commit),
+	KUNIT_CASE(damon_test_commit_target_regions),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
 	KUNIT_CASE(damon_test_set_filters_default_reject),
-- 
2.47.3

