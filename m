Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95463CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 18:44:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EE018E0018; Tue, 11 Nov 2025 13:44:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 777EB8E0019; Tue, 11 Nov 2025 13:44:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690CD8E0018; Tue, 11 Nov 2025 13:44:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 245AA8E0019
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:44:33 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DAE7B5641D
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:44:32 +0000 (UTC)
X-FDA: 84099201984.06.2425B53
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 208B64000A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:44:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ivB+mUEJ;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762886671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yQL5mwIv1JbloV+S9EmZALk/mWUSKjWp0QtOEDmPYrs=;
	b=P/kupyA9jeTNMbukEzFr/SohK7IUP+floE1ctVj6DUYJ4tZvmuyC4TgEAEv7r3KzF9Fcbg
	ErxK/pgkJ9ri5ZIU/tXW9OlcUeueq+njmiQQw3Q2faPTbFd9qH0m4mF1JvwSAQkY/tWU2/
	dFY4cElWczxWlcS0nV5NUAfD1CibqCk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762886671; a=rsa-sha256;
	cv=none;
	b=02v/V+PON6O85THcrBj+xk6HqtEIZVVqDgVQOeMLKaVqoNeVxdu8G0frZZjwTtHJHlACKu
	zNbHyxmiwXubB3323LO1iKiSHvDn7ljekngA465W1jj/PsRU6uTGaqng7FPfMp5IqBDyTO
	9sXWnT44LHq5f9/Fz12+pdh3xKGkF+s=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ivB+mUEJ;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E265A446FF;
	Tue, 11 Nov 2025 18:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D23FC116D0;
	Tue, 11 Nov 2025 18:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762886669;
	bh=UHTTCWbBxKg4HVFBjTI+3bp4LAWv9VnyN7HpL47+onk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ivB+mUEJg/v+GWvlW7Q7nRX8JRqQEfRVL0BwPVv9S1vkR6mhVZO/vgmOG9bWe6nQK
	 tQKRPeqjBXg5Zbor+Vn+l3o/rVu1HkdRN6hgT9YM7sNvfcATE99rKvba+BmemfCHeO
	 SHunCl44MO+uvxRsip0iaPF9XNuCLpuNdSyAEb6kGbHMSy0yGpwkVyd4bLaOq9lOBG
	 R742RGGAY3sSUhywxeUgdHnpPjM/miRf1TtzPG6WzMHGOBpuYm+OvrN2/LO7KNpGYK
	 xkSeqg13Uet2qerkEo8vZWhhTda5LWSSABDZrFHoEwT74wP1qn5YtRkRiiZIwxYgwT
	 cqOpD5atP/lOg==
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
Subject: [PATCH 10/11] mm/damon/tests/core-kunit: add damos_commit() test
Date: Tue, 11 Nov 2025 10:44:09 -0800
Message-ID: <20251111184415.141757-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251111184415.141757-1-sj@kernel.org>
References: <20251111184415.141757-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 208B64000A
X-Stat-Signature: u3t3f4wymcimb8pfutmwabfbak11e1kd
X-Rspam-User: 
X-HE-Tag: 1762886670-237543
X-HE-Meta: U2FsdGVkX1/WO/ygUYPayTSqO7vmLAGFGMSU5mxBpaBiYlPVew0S7MMDBL71ABevGmlUbb8eTQufCS5Q8PdpF90pT89DT2thcrvyyQL/dWLyhBkO47Zgsa36dhaN7P1TD3hBMIEMLpnK63ruxXPV0O2wE9df29VVo1JEBPohEhkC2yT2sqMy8mUBi7D8xWIvqSOitWNGZymYleRgG6b7OqKplCCluT/bAfXU8H6m5T7RiwwM9KlUsvDMIXYNgDZN9Lw8WSff8QMGVXoz7/aEKhHkJ2DsNXO+/yu0fp4ko+CIObFIiMwDHmwDscvW5D8lpXKiY3/Hapl/darKLGtFDp9YDVWJBw0AEjJGeCluK9rzbijYJvMLK9twZwpVnaf8uCU6BuEMSciAonLyTJNCLH19JkwVBFbDS55z7awdH/PHKgYLN8NUVdfibJ2ItEOvtd7gJQse/wRLN/rdHClpNL15dknSJSh43o/755SxUqQWc5HuCsSQQ6wAT7F1bSqU3EXYi4TL9pqTrcGGfuD8ZeZknn16QqV8AYAulOnhrXI0gUvo0s4jTmMouhyzSl+EyFqoqjWL9mzBeWf5nYOy/uiJ5+y4dZ9ERMV4+YI8KqlPvBRkmqlzwI+bOkRZtaFDI7As1iuJgRJgZ1pCg8lXzjdwflwLgEU/ngzujLaa7vIxcd330zAwqZHae4ydb6gAf82Js03zu+vncPZgEl+h8pL1DnciDxcBwKXrMvc3csbNPhqAC3Y0nDf/msh21CNoaAkKVqaoY1s+Dj4/34jQnnAJUQunbClG2IQWFh/7IG++t8DnKymDOrcvbwmCmjvmi9IhfNqJA7/+2mmCoJbyhYM1VsYVR9CbMqZB/+4FILNjvp+CVoPn5H5KgBfxKl8QWFtzSfgkgiCmHPX8GuprRDxWpg2IHIR/SA63uLPRUsvTy4tcLYyiGeXZf4UjR4yn4WB66HmM+FKDqkVuxXG
 zFSRyMNJ
 MKq3frf3T8mwUpAv/LK9P4MkYq4KnlDxd2jzZSsaapjhf+9B/O5J/tSjkb9ImAeUSSqvcjCQ+jIXrM1m8KXUhYaxKxEjLidr3sSRK36Hl0tFwqhUwr+krmBw4bntce9u6khWIL0inTNhUzLgi5L0auURcGnLGXZ3R56hdKLZ6VcHd3wmMg3IkNOEZkZU3wa+VtHEW1xtqNwiwCWT20+zPsSNotC6BDBESgSt1Y82CIMclfzygoJUBM0L+9chxP+21jVx9zqVTryo2kuOfO6mTRwyTCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new unit test for damos_commit().

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 92 +++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 10f2aefc71ff..c71c10f9e059 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -873,6 +873,97 @@ static void damos_test_commit_filter(struct kunit *test)
 			});
 }
 
+static void damos_test_help_initailize_scheme(struct damos *scheme)
+{
+	INIT_LIST_HEAD(&scheme->quota.goals);
+	INIT_LIST_HEAD(&scheme->filters);
+	INIT_LIST_HEAD(&scheme->ops_filters);
+}
+
+static void damos_test_commit_for(struct kunit *test, struct damos *dst,
+		struct damos *src)
+{
+	int err;
+
+	damos_test_help_initailize_scheme(dst);
+	damos_test_help_initailize_scheme(src);
+
+	err = damos_commit(dst, src);
+	if (err)
+		kunit_skip(test, "damos_commit fail");
+
+	KUNIT_EXPECT_EQ(test, dst->pattern.min_sz_region,
+			src->pattern.min_sz_region);
+	KUNIT_EXPECT_EQ(test, dst->pattern.max_sz_region,
+			src->pattern.max_sz_region);
+	KUNIT_EXPECT_EQ(test, dst->pattern.min_nr_accesses,
+			src->pattern.min_nr_accesses);
+	KUNIT_EXPECT_EQ(test, dst->pattern.max_nr_accesses,
+			src->pattern.max_nr_accesses);
+	KUNIT_EXPECT_EQ(test, dst->pattern.min_age_region,
+			src->pattern.min_age_region);
+	KUNIT_EXPECT_EQ(test, dst->pattern.max_age_region,
+			src->pattern.max_age_region);
+
+	KUNIT_EXPECT_EQ(test, dst->action, src->action);
+	KUNIT_EXPECT_EQ(test, dst->apply_interval_us, src->apply_interval_us);
+
+	KUNIT_EXPECT_EQ(test, dst->wmarks.metric, src->wmarks.metric);
+	KUNIT_EXPECT_EQ(test, dst->wmarks.interval, src->wmarks.interval);
+	KUNIT_EXPECT_EQ(test, dst->wmarks.high, src->wmarks.high);
+	KUNIT_EXPECT_EQ(test, dst->wmarks.mid, src->wmarks.mid);
+	KUNIT_EXPECT_EQ(test, dst->wmarks.low, src->wmarks.low);
+
+	switch (src->action) {
+	case DAMOS_MIGRATE_COLD:
+	case DAMOS_MIGRATE_HOT:
+		KUNIT_EXPECT_EQ(test, dst->target_nid, src->target_nid);
+		break;
+	default:
+		break;
+	}
+}
+
+static void damos_test_commit(struct kunit *test)
+{
+	damos_test_commit_for(test,
+			&(struct damos){
+				.pattern = (struct damos_access_pattern){
+					1, 2, 3, 4, 5, 6},
+				.action = DAMOS_PAGEOUT,
+				.apply_interval_us = 1000000,
+				.wmarks = (struct damos_watermarks){
+					DAMOS_WMARK_FREE_MEM_RATE,
+					900, 100, 50},
+			},
+			&(struct damos){
+				.pattern = (struct damos_access_pattern){
+					2, 3, 4, 5, 6, 7},
+				.action = DAMOS_PAGEOUT,
+				.apply_interval_us = 2000000,
+				.wmarks = (struct damos_watermarks){
+					DAMOS_WMARK_FREE_MEM_RATE,
+					800, 50, 30},
+			});
+	damos_test_commit_for(test,
+			&(struct damos){
+				.pattern = (struct damos_access_pattern){
+					1, 2, 3, 4, 5, 6},
+				.action = DAMOS_PAGEOUT,
+				.apply_interval_us = 1000000,
+				.wmarks = (struct damos_watermarks){
+					DAMOS_WMARK_FREE_MEM_RATE,
+					900, 100, 50},
+			},
+			&(struct damos){
+				.pattern = (struct damos_access_pattern){
+					2, 3, 4, 5, 6, 7},
+				.action = DAMOS_MIGRATE_HOT,
+				.apply_interval_us = 2000000,
+				.target_nid = 5,
+			});
+}
+
 static void damos_test_filter_out(struct kunit *test)
 {
 	struct damon_target *t;
@@ -1078,6 +1169,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damos_test_commit_quota),
 	KUNIT_CASE(damos_test_commit_dests),
 	KUNIT_CASE(damos_test_commit_filter),
+	KUNIT_CASE(damos_test_commit),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
 	KUNIT_CASE(damon_test_set_filters_default_reject),
-- 
2.47.3

