Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3D8AC982CC
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 00:36:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD8806B0092; Wed, 16 Sep 2026 20:36:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F5706B0093; Wed, 16 Sep 2026 20:36:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BE876B0095; Wed, 16 Sep 2026 20:36:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5A36A6B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 20:36:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BF54DC01AA
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:36:09 +0000 (UTC)
X-FDA: 85221387258.04.2256A66
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf19.hostedemail.com (Postfix) with ESMTP id 08ABF1A0003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:36:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DvtaRSvI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789605368;
	b=iLgMZoy/cm+BhN6eTbqIqhmIoWTDrLSsbHgNJwcjoJG+vhCWQmI8H1rCc+6Jv2D5B0JcMU
	+Clak0X6hH60dG0pVHO7uEku8OfYsNQVxmN5MI1xiBjz4c+VH8f6mr3j6pLfQmwydFrAQZ
	9cm31cWBrBnEYHxanTQPQT29uywn1GU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DvtaRSvI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789605368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xwJTJdNBgS/rtyknRednfqg6/8S30G/8tgACWLX5raI=;
	b=KQJw5OCc2tdJdTNBRudLifol5dcujUOzpKYNT0KPg/zLNWYwSpXV3e08Tk0wneC760u8x7
	EDr5jFQEU9wobwFajkU6RTH728szqZSbhLzu3IXfU6qgArQsJOmVfiISlwPgSQADnxlPIS
	TbxOlFMYaIQMGjvJhP3Zayy8HOgRkIU=
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-398cb5615deso255137a91.3
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789605367; x=1790210167; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xwJTJdNBgS/rtyknRednfqg6/8S30G/8tgACWLX5raI=;
        b=DvtaRSvIToiaHnp917ygQm4mz9WncnCGZeUX4tG5p0zAwaKq8+S6MR+Vti3f5/IKIE
         ZzecE15obPznRoUUEFkuNB90r1iX4LIAsX6BApZs4lbaFVuowDMEf3yXhZ6ESuqYb9LS
         srP0sJpxLT5NoPiT8AyAdySZ0XEbJd/xCG1kCUwSTMiZUXxPniKC6n8c+FeypPM7iQQ1
         NDJAwCJUvr08YlxP0NuFzw7KMrtoFoiPf0ajijudmXnDQpQOoNkQkUWH2CJCaNsY6676
         96HDttvbxnrzMr70PrhlqPkBD4FUTcPstLPHA/iHv67NFhpnhj5ZOhZRPzyX1ylhINLR
         Zn5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789605367; x=1790210167;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xwJTJdNBgS/rtyknRednfqg6/8S30G/8tgACWLX5raI=;
        b=0iGrTj2MJcLTM6EriFRJucpNPcSU6tt5yJsXVwDSvcK/qN7Bhei/M1VKxg7qPhoN/L
         fWahbxee/5Aj2YroMbsScr4CH+xM22TGNNn+bjAtoWkn8vfnr1k56etF/lkJXg62nT/7
         h1jpcTbeusls5Gzz/qcGojSe2gRVdImYa/yYCd3Uocf7HiOVHgEuG9iuSn08ky05NbvA
         HN+9iItJtAh+EslulG61o0d8fJBzH6hs5CGILs4fZtoBbpPo9hAikzMs75xmWA/E+8/S
         Yg5K8xY1CdAfytVxvkRWqNMP0uTjE+XRQqDAop27Uv2BufLb83AeUSXHEkxPwjAVz41k
         fJRQ==
X-Forwarded-Encrypted: i=1; AKwUvBweROEWaF3cBhx0tOQ1ag+AoLJx9633C2vzcbz4B/Qe/7r8dyVtxqaaHT9GukXYdfq/ZUdJ2owP3A==@kvack.org
X-Gm-Message-State: AFuF++n8vN4aQTOPfZm4y7fk94Uv5UYofs/T8iGwiJc0d/g0p2oghIx8
	tt4yGX++Zy4PGVQCUFV+CWFdCTCR2JzBbTDayQT4J1JRZyase3IbpkM=
X-Gm-Gg: AYBFou1W0KRDsqEFwjyTo2INhvQg035fwHMGFrqO4QjCHhDB6SFwGkRiDv5bqCSAa2s
	CL+9F3X3B1rzGEp9UfUPIyzGAyU7rPM+HO6oCDtGAss9dAiE/eQo5yMp8Uk5pB+s5NgdCK0ZA9R
	FtfPjEPcOqi56DrFOTEz35fibYq3pZ+ppABf9/VQ5Pq0JIDj28qVinGmVSGJPg1y8hevgc2UvGb
	j1u5Y6qqxh3c1ClkeEr1GsSf5QhJqmHkVmMWM4CjHanQMDRO+M6opeP6oIf9Hws9cGuuShRWojo
	XSxPq/f86RT7fX1aTYxGGMPxRXdOHUWPeZi3PrQmcd2X53rBGlO7bC/6akYipMJCdfOybT8Ee5s
	pRnzPoQ2EVVl64IffLsg4C+yCGvl3/mRdLBp6ZvPFDBeCj/+kBk+vs1MqYgwutV0QcsOq5ysAra
	1Y00zmdz1fCU7BKNTFiQu6/TAp2jm0kHEZtwl8rGihiKzL+4jH7Jr2eb5dRFmcJdNoCN5P14ljs
	mS67yAg+EmEbAOlVpZ/E4zBMy8=
X-Received: by 2002:a17:90b:5847:b0:39d:ec1b:9651 with SMTP id 98e67ed59e1d1-39e1e484b90mr10744846a91.13.1789605366824;
        Wed, 16 Sep 2026 17:36:06 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7f00:8c85:3990:d106:a51f:be7c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e36115cc8sm1722374a91.3.2026.09.16.17.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 17:36:06 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com
Subject: [PATCH v1 2/2] mm/damon/tests/core-kunit: test the size charged for a filter-trimmed region
Date: Thu, 17 Sep 2026 09:35:53 +0900
Message-ID: <20260917003553.2465523-3-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260917003553.2465523-1-donggeunyoo.kernel@gmail.com>
References: <20260917003553.2465523-1-donggeunyoo.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 08ABF1A0003
X-Stat-Signature: hmb5q1ye8q3a6n1i5i1ui14wsp9awrur
X-HE-Tag: 1789605367-468608
X-HE-Meta: U2FsdGVkX1+nzx46sp2YC3bl5/39BuWPNcAbxaSDuyFzxVfsIMPCSo509xWjzDqg7uDHwowFnr93XbXc58jWh3BN1t6YvQDJLpgAwwuOHX6lQSdVTLoF8A/0Ce7UZlH5mSxZjgxG4nfjBAuaOwxnXtGbxmMeDKGQzl1OGYmTp/1dEsFCjnlsUohzlg3xk8D30kecmTo5EwEbxK5BLBnPuq8YxcupNbjeohtSVET5uCSqyzSPXY5IxE+CPrhuvBDR2wsfkEESKhQfpGMblJZ8lPqkG0TLwr78PKrOcobCQ7Ui6aFFFRNYjLMOAnbfaDTgY5CDZx9Lri7CUKXklUvuRSUK25HazrgyI0RvfOtyEcaDSIsVzOiMTOdbPwDueLxnT3pzkMDu3lb5PGC3u764l/ZAd1M1G3VzN7kNKT52b/1pWju5PDnd5oI52gsz4BjXIrOJvaUwJADnXd9HUPaGEt8UveexOaybGfw3r8X3z2GFCeJ+lTsNZivkW5kVBTS5DtkWuzrRgDMgiwBw2AClPFbt1crtu6xf+ra3MxfKcUOsJ1k9IYrk4AaazgLsVl4V94F0D/WctVLuv5AUvPbRbPP2/mA+Adwe8psR9lRzaT8aPENH5V6Q/O+sk8jfNuL7Oib0bbge3aWTN0ak7Il2oseBrXmOU5Y9SLr9HM3NrXWRMtKjYOy781oRFrDJ6RbX8NUT7xfMWS8Bx8NahpmIQkkmfq2UKhVlMyoxaSCt5Cg+JFM3ky4GRfG6NLGC1fZib8dtjumad21FZ6pQx42CugGISfHfsL9h5KitToOOcvEs89Od7eDqQm1OtE1D6bw/+qHsagChyqIBugz8PtmbYc1DJ1mbJjLthgb6dqcbJZTY+wG2j89nrBFlIeIFIEMEWza7qsR8NK741zBszPP4yjyS1opzT6Pt+Yt0nK5efAFRnfYus6OZ9JLqrM8w3oHkzQSlN6PVOiXNrrjVtLc
 sWNSaOfF
 iexKPWmQ6zq6rMCwAsR5jiX2evYjz+HuGTQ/+jHoOL5kjQGwnit49xFPySUxrswbS2OqGEeHzUAHg9aEzwz1OIeu5PQnCy2xJdy/emrsD44Uwol5w5dR3NGziwA2b/cEvk3MELbtaELD+KO51bqH+usY/rHLlnoMJboogPfo/1OiYxYGNEP8Zit6u+M/T8m4exQulasEr6Ivs3uR1gShzr7JJbAH7VFffXbyJDKEtxqGu3g8DKV+a7eK3gqjn7CNRTkIfM/0RbCJnqgiCk6qRN9oNHAabj5+RSX+RxGkXYpDU16jOw5Mu4apZ2osSyawMA2sP7Zo6dZio1GLqSrVL6RY0Utz9KSgws6+vxmLT4pLRJ0Yfl1hupoNucPKTqu9xRN7SM7Bzou59uNE2UKLJN0frZlZjov38HMr0WYgMFnXlyl60ld4iL8UTI05IeLUSO2M9Po/5ZK5W3DCTTcamsifLMu/rdA48qr8nsQStKRIb1Jc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
---
 mm/damon/tests/core-kunit.h | 316 ++++++++++++++++++++++++++++++++++++
 1 file changed, 316 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 5da84caf4124..82c542afaa60 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1676,6 +1676,319 @@ static void damos_test_filter_out(struct kunit *test)
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
@@ -1929,6 +2242,9 @@ static struct kunit_case damon_test_cases[] = {
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
2.53.0


