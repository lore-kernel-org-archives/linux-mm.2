Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C87EDC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 15:24:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D33796B00E4; Mon, 21 Sep 2026 11:24:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0BA46B00E5; Mon, 21 Sep 2026 11:24:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C47066B00E6; Mon, 21 Sep 2026 11:24:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A06066B00E4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:24:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2A10314014F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:24:57 +0000 (UTC)
X-FDA: 85238142234.12.F714896
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 983AD100003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:24:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LkxD8AWZ;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790004295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZLvkpkC88KAc9pc9JRn5s2cgjSsFH8QP7LkU/PCNgfk=;
	b=JHVByhH9tadRyUVU5ytUmkctVZd1RigINwcf8/C45ZQ9N7jStJ5t4DnMQhLMF2xCBiM+nB
	yLZ+2SWI2FU9biLhUHUh4v0TsHVuFQKs3TsTgyQ6q9aFiWKc1+o3ns3E6+8YtMWeIJvv3l
	E0qUyJjduz3WHFwuUwgjtYzgF0gFUtM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790004295;
	b=NHA6QAnRYVF9U4AqQrKCaVJmHSf8oLQGbvdue+rCHvZt3KYgok56ZEBHqRtWloM1sCh13/
	uP6JaGTdvxFBIDiS9K45Bu3uWvrnOBilhaGrkqAfhkCGSEDMVN5KVg/2yzrMk8rFRtd2/Q
	I1qQNC2OzdeM9yFnkf9blv11tkGuymM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LkxD8AWZ;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 25037601FB;
	Mon, 21 Sep 2026 15:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B731F000FF;
	Mon, 21 Sep 2026 15:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790004294;
	bh=ZLvkpkC88KAc9pc9JRn5s2cgjSsFH8QP7LkU/PCNgfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LkxD8AWZ5YFBPNXU57iAJXfnShcYu/TRlKkNQ4e+kNk6g9E3QI9iM2eVSjROcIc0r
	 QJQ7+7r9FfwISjC1PBhu9/8NZBQtxdCmDI8Vt3b8iEYf8pMNEjwtY6h3kveojh5dng
	 CEevjvcHdVSZwSF/+NiMdKjyxVAHF3DHkFJh2qyWSyDyymbtiA1ux8ULAeeMhK5Qes
	 LvvlM/4cBBnyH7BhL4yxVGBYsTdZPmUomFlluXxTUWxfyWVyWN8wYOf9V2vBQDLSdJ
	 9HHGevnwAIuIXUju57TeSmrQqTuSMmhLBRtwJ2J654U0WLj9C9EYIbUpiW+AUCSxz8
	 PTG8S4Tg2k1aw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 2/2] mm/damon/tests/core-kunit: test the size charged for a filter-trimmed region
Date: Mon, 21 Sep 2026 08:24:42 -0700
Message-ID: <20260921152443.80132-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260921152443.80132-1-sj@kernel.org>
References: <20260921152443.80132-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 9frpddd3q131wgq4ouuufhnceh6ctioq
X-Rspamd-Queue-Id: 983AD100003
X-HE-Tag: 1790004295-707105
X-HE-Meta: U2FsdGVkX1+OMlJMt70Bhe8k2DVkdVNwvSwj9l2A3VHBggEVR55Sc4YfR0fFd3aWybAGht7PrTbsU5mnrSB347kSci/qv7C1MbW2wvLAqA8Jj6wSzEGYL153NmCFzP1cdIItmnf30JkzaKrYV7HaK3MT7xnD74/mVP9NIZy3HEzQ4VJ557NaeqepIpWXqTHMNCQymgAlXUbuLVJT9yxFVjkFoj+xY4lRKzz17Y5H2R8PHxna9I4NP4pqiZYbzxHw3Aczg1UAAzzfvcmPPXvdWNtsOeBG/vtYr1s4Y9tuFx0EtDDdFyAxGqVsomNu4CalhMa417AigFewocgpnlNKrCkLzh/3ZjRntNqO/V1Kxjhdr2LKSLsQAX2C3opW+0UZxydwmm4ipDv1nkT+t2emnaYU+YDxu4bZ0YFPGjnu/kKZmz/coPAUchYtbQFH6eamPa2unv5CaURfe8d9fBzVkOjMdiWvZbUrdfNOd6xpOq2uIrcTkwiusqW0ps7/VWejjYViDTRjaS27SQsx1FUPvnhXOX0Fh3bvIr/SLB6k/06I6ERQDdMNgtT1/StuJlejn2IlojRqKxMkFcseahqmsRZFoTmYU6ajDNP7oydMhGKmK7d54Hp6yGJscGZlpqBsmrAYxHpiASb4geS9SERbHP1vSqNofPst9GeagcVugE1uCs+M2v7+H6BgQEalDouQTqoNwG1tTs6F3vveG99hDjQKzLcwZKnY7jWWfuQKrHY3ub0jB+1HFBm8Ybr+VzXRwS3hiAJ0G2bFZAG6FkzDxjNTIso0yEXRAIe18cXsRJmVIUdXGaCDBWmjbQewdn6NSdsd9bpMURv75JM5LtZ1FUW8eF+BB0vHkbBb5rUplOauXXwfup1x6mH1boz3DT5I4UaxwTXbJpP9IhYE8AHP/0jVTqndQMaFd9bcCsozM8NR1is7OsHXEz2eTIxCruM2FR+xVQrWuvtz3qnz5nX
 P0W8mU2q
 IUdlrwG8dDcHPsgoAJDUulwE0pGEh/bUhI1LaxCDvoRD9UNmztnlUtULNdWjXfi9AHHORNYXaepCLCZsyhHnxFU3slfq1cGeDH7P0G9Vc8pZViWLsKheB8BNLT/IAHD6Ezf0xsX1BYEZ9N3ErCkvxeylQXy5H5vpC0NJMEEHZ1/sd7BrbMQkKH/BxwpycDEf/LXBrDskU0ltM/ydm3yaRMrf/8uo8iQI3juRfqv/5YWZCpt4KwmjDGWmx5221YrQWPicbtE6yBBsAxn8gQqfZzMVSE0FWvp1Q2Da2vA8q9b6W9r/MZ81Ix13Q/Kjupmx/GUz01+gsdwpWW6s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

damos_test_filter_out() checks that an address range filter splits a
region at the filter boundary, and stops there.  Nothing checks what
damos_apply_scheme() then charges to the quota and reports as tried.

damos_test_apply_scheme_filtered_sz() covers the two ways such a filter
trims a region: one that starts before the filter's range, and one that
starts inside it.

damos_test_apply_scheme_filter_sz_unchanged() and
damos_test_apply_scheme_quota_sz() cover the cases whose accounting must
not change: a region wholly inside a reject range, one wholly inside an
allow range, two filters trimming in a single call, a filter type that
never splits, no filter at all, a region the quota trims, and a quota
remainder too small for one region.

Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 316 ++++++++++++++++++++++++++++++++++++
 1 file changed, 316 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 5ff0436c5844..df84d9cc7d20 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1706,6 +1706,319 @@ static void damos_test_filter_out(struct kunit *test)
 	damos_free_filter(f);
 }
 
+static unsigned long damos_test_apply_scheme_stub(struct damon_ctx *c,
+		struct damon_target *t, struct damon_region *r,
+		struct damos *s, unsigned long *sz_filter_passed)
+{
+	return 0;
+}
+
+static void damos_test_apply_scheme_filtered_sz(struct kunit *test)
+{
+	struct damos_access_pattern pattern = {
+		.min_sz_region = 0,
+		.max_sz_region = ULONG_MAX,
+		.min_nr_accesses = 0,
+		.max_nr_accesses = UINT_MAX,
+		.min_age_region = 0,
+		.max_age_region = UINT_MAX,
+	};
+	unsigned long min_sz = DAMON_MIN_REGION_SZ;
+	struct damos_watermarks wmarks = {};
+	struct damos_quota quota = {};
+	struct damon_ctx *c;
+	struct damon_target *t;
+	struct damon_region *r;
+	struct damos_filter *f;
+	struct damos *s;
+
+	c = damon_new_ctx();
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+	c->ops.apply_scheme = damos_test_apply_scheme_stub;
+
+	s = damon_new_scheme(&pattern, DAMOS_STAT, 0, &quota, &wmarks,
+			NUMA_NO_NODE);
+	if (!s) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "scheme alloc fail");
+	}
+	damon_add_scheme(c, s);
+
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "target alloc fail");
+	}
+	damon_add_target(c, t);
+
+	f = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true, false);
+	if (!f) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "filter alloc fail");
+	}
+	f->addr_range = (struct damon_addr_range){
+		.start = 2 * min_sz,
+		.end = 8 * min_sz
+	};
+	damos_add_filter(s, f);
+	damos_set_filters_default_reject(s);
+
+	/* reject filter, region starting before the range */
+	r = damon_new_region(0, 4 * min_sz);
+	if (!r) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "region alloc fail");
+	}
+	damon_add_region(r, t);
+
+	damos_apply_scheme(c, t, r, s);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
+	KUNIT_EXPECT_EQ(test, r->ar.end, 2 * min_sz);
+	KUNIT_EXPECT_EQ(test, s->stat.sz_tried, 2 * min_sz);
+
+	if (damon_nr_regions(t) != 2)
+		goto out;
+	damon_destroy_region(damon_next_region(r), t);
+	damon_destroy_region(r, t);
+	s->stat = (struct damos_stat){};
+
+	/* allow filter, region starting inside the range */
+	f->allow = true;
+	damos_set_filters_default_reject(s);
+	r = damon_new_region(2 * min_sz, 10 * min_sz);
+	if (!r) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "region alloc fail");
+	}
+	damon_add_region(r, t);
+
+	damos_apply_scheme(c, t, r, s);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
+	KUNIT_EXPECT_EQ(test, r->ar.end, 8 * min_sz);
+	KUNIT_EXPECT_EQ(test, s->stat.sz_tried, 6 * min_sz);
+
+out:
+	damon_destroy_ctx(c);
+}
+
+static void damos_test_apply_scheme_filter_sz_unchanged(struct kunit *test)
+{
+	struct damos_access_pattern pattern = {
+		.min_sz_region = 0,
+		.max_sz_region = ULONG_MAX,
+		.min_nr_accesses = 0,
+		.max_nr_accesses = UINT_MAX,
+		.min_age_region = 0,
+		.max_age_region = UINT_MAX,
+	};
+	unsigned long min_sz = DAMON_MIN_REGION_SZ;
+	struct damos_watermarks wmarks = {};
+	struct damos_quota quota = {};
+	struct damos_filter *f, *f2;
+	struct damon_ctx *c;
+	struct damon_target *t;
+	struct damon_region *r;
+	struct damos *s;
+
+	c = damon_new_ctx();
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+	c->ops.apply_scheme = damos_test_apply_scheme_stub;
+
+	s = damon_new_scheme(&pattern, DAMOS_STAT, 0, &quota, &wmarks,
+			NUMA_NO_NODE);
+	if (!s) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "scheme alloc fail");
+	}
+	damon_add_scheme(c, s);
+
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "target alloc fail");
+	}
+	damon_add_target(c, t);
+
+	f = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true, false);
+	if (!f) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "filter alloc fail");
+	}
+	f->addr_range = (struct damon_addr_range){
+		.start = 2 * min_sz, .end = 8 * min_sz};
+	damos_add_filter(s, f);
+	damos_set_filters_default_reject(s);
+
+	/* wholly inside a reject range: not counted at all */
+	r = damon_new_region(4 * min_sz, 6 * min_sz);
+	if (!r) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "region alloc fail");
+	}
+	damon_add_region(r, t);
+
+	damos_apply_scheme(c, t, r, s);
+	KUNIT_EXPECT_EQ(test, s->stat.nr_tried, 0);
+	KUNIT_EXPECT_EQ(test, s->stat.sz_tried, 0);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
+
+	/* wholly inside an allow range: counted whole, not split */
+	f->allow = true;
+	damos_set_filters_default_reject(s);
+
+	damos_apply_scheme(c, t, r, s);
+	KUNIT_EXPECT_EQ(test, s->stat.sz_tried, 2 * min_sz);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
+
+	/* two filters, each trimming: the size left after both is counted */
+	damon_destroy_region(r, t);
+	s->stat = (struct damos_stat){};
+	f->allow = false;
+	f->addr_range = (struct damon_addr_range){
+		.start = 4 * min_sz, .end = 12 * min_sz};
+	f2 = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true, false);
+	if (!f2) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "filter alloc fail");
+	}
+	f2->addr_range = (struct damon_addr_range){
+		.start = 2 * min_sz, .end = 3 * min_sz};
+	damos_add_filter(s, f2);
+	damos_set_filters_default_reject(s);
+
+	r = damon_new_region(0, 8 * min_sz);
+	if (!r) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "region alloc fail");
+	}
+	damon_add_region(r, t);
+
+	damos_apply_scheme(c, t, r, s);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 3);
+	KUNIT_EXPECT_EQ(test, r->ar.end, 2 * min_sz);
+	KUNIT_EXPECT_EQ(test, s->stat.sz_tried, 2 * min_sz);
+
+	/* a core filter that never splits: counted whole */
+	damos_destroy_filter(f2);
+	damos_destroy_filter(f);
+	f = damos_new_filter(DAMOS_FILTER_TYPE_TARGET, true, true);
+	if (!f) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "filter alloc fail");
+	}
+	f->target_idx = 0;
+	damos_add_filter(s, f);
+	damos_set_filters_default_reject(s);
+	s->stat = (struct damos_stat){};
+
+	damos_apply_scheme(c, t, r, s);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 3);
+	KUNIT_EXPECT_EQ(test, r->ar.end, 2 * min_sz);
+	KUNIT_EXPECT_EQ(test, s->stat.sz_tried, 2 * min_sz);
+
+	damon_destroy_ctx(c);
+}
+
+static void damos_test_apply_scheme_quota_sz(struct kunit *test)
+{
+	struct damos_access_pattern pattern = {
+		.min_sz_region = 0,
+		.max_sz_region = ULONG_MAX,
+		.min_nr_accesses = 0,
+		.max_nr_accesses = UINT_MAX,
+		.min_age_region = 0,
+		.max_age_region = UINT_MAX,
+	};
+	unsigned long min_sz = DAMON_MIN_REGION_SZ;
+	struct damos_watermarks wmarks = {};
+	struct damos_quota quota = {};
+	struct damon_region *r, *next;
+	struct damon_ctx *c;
+	struct damon_target *t;
+	struct damos *s;
+
+	c = damon_new_ctx();
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+
+	s = damon_new_scheme(&pattern, DAMOS_STAT, 0, &quota, &wmarks,
+			NUMA_NO_NODE);
+	if (!s) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "scheme alloc fail");
+	}
+	damon_add_scheme(c, s);
+	damos_set_filters_default_reject(s);
+
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "target alloc fail");
+	}
+	damon_add_target(c, t);
+
+	/* no apply_scheme operation: the whole region is counted */
+	r = damon_new_region(0, 4 * min_sz);
+	if (!r) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "region alloc fail");
+	}
+	damon_add_region(r, t);
+
+	damos_apply_scheme(c, t, r, s);
+	KUNIT_EXPECT_EQ(test, s->stat.sz_tried, 4 * min_sz);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
+
+	/* no filter and no quota: the whole region is counted */
+	c->ops.apply_scheme = damos_test_apply_scheme_stub;
+	s->stat = (struct damos_stat){};
+
+	damos_apply_scheme(c, t, r, s);
+	KUNIT_EXPECT_EQ(test, s->stat.sz_tried, 4 * min_sz);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
+
+	/* the quota trims the region: the trimmed size is counted */
+	damon_for_each_region_safe(r, next, t)
+		damon_destroy_region(r, t);
+	s->stat = (struct damos_stat){};
+	s->quota.esz = 2 * min_sz;
+	s->quota.charged_sz = 0;
+
+	r = damon_new_region(0, 8 * min_sz);
+	if (!r) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "region alloc fail");
+	}
+	damon_add_region(r, t);
+
+	damos_apply_scheme(c, t, r, s);
+	KUNIT_EXPECT_EQ(test, r->ar.end, 2 * min_sz);
+	KUNIT_EXPECT_EQ(test, s->stat.sz_tried, 2 * min_sz);
+
+	/* quota remainder below one region: tried, but nothing counted */
+	damon_for_each_region_safe(r, next, t)
+		damon_destroy_region(r, t);
+	s->stat = (struct damos_stat){};
+	s->quota.esz = 1;
+	s->quota.charged_sz = 0;
+
+	r = damon_new_region(0, 4 * min_sz);
+	if (!r) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "region alloc fail");
+	}
+	damon_add_region(r, t);
+
+	damos_apply_scheme(c, t, r, s);
+	KUNIT_EXPECT_EQ(test, s->stat.nr_tried, 1);
+	KUNIT_EXPECT_EQ(test, s->stat.sz_tried, 0);
+	KUNIT_EXPECT_EQ(test, r->ar.end, 4 * min_sz);
+
+	damon_destroy_ctx(c);
+}
+
 static void damon_test_feed_loop_next_input(struct kunit *test)
 {
 	unsigned long last_input = 900000, current_score = 200;
@@ -1959,6 +2272,9 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_commit_ctx),
 	KUNIT_CASE(damon_test_valid_probe_params),
 	KUNIT_CASE(damos_test_filter_out),
+	KUNIT_CASE(damos_test_apply_scheme_filtered_sz),
+	KUNIT_CASE(damos_test_apply_scheme_filter_sz_unchanged),
+	KUNIT_CASE(damos_test_apply_scheme_quota_sz),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
 	KUNIT_CASE(damon_test_set_filters_default_reject),
 	KUNIT_CASE(damon_test_apply_min_nr_regions),
-- 
2.47.3

