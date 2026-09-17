Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66770C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 04:06:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BF3F6B0099; Thu, 17 Sep 2026 00:05:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 475576B009F; Thu, 17 Sep 2026 00:05:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B20E6B009E; Thu, 17 Sep 2026 00:05:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 11FEA6B009F
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:05:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 849101A020A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:05:50 +0000 (UTC)
X-FDA: 85221915660.12.A786AFF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id E1ACD160004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:05:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=anOYjV8W;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789617948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YMhruRxJ71aCSjWmA7d/+kJKddMflnbOBghZf4lSJQc=;
	b=qVJSODA8uUwKZPh3P4LEEnTAKathtxEPT7ThT3COPVNPqKz3qxIP2dCENVZD6deM/ao6T8
	KTAmY/YxuV/fLow3IjcuYKaPWogGsLAZC5SRNUVqA4ZtN/zOY6kWQatzizdTtAqZXP8/2p
	mYvvWRk03RQZxYFA49IZDrGRumWgFyk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=anOYjV8W;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789617948;
	b=wO9Gvvx4iiK3NIQyPTXpRBYQPUBD07BcvCllbEDnoBDOCS+1/w951Re/HAWr7oBW5YEHMD
	BjuSDI2aJ3K7gPk/eIioAgIq1f5U75huCKSGV8juQoJYsjt5CKkFLuQdkEzjbXoXdczxs6
	e+lMPTBha0PNM6hMVE6kWlqiZDKnQrM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F1C744787;
	Thu, 17 Sep 2026 04:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19341F00899;
	Thu, 17 Sep 2026 04:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789617948;
	bh=YMhruRxJ71aCSjWmA7d/+kJKddMflnbOBghZf4lSJQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=anOYjV8WCsTVncf3Vj6GaK/Mje5Z954BIPh7Ig2bs0MwnSsePdkjJNjToRs7jZ8Ql
	 sx71PURDHbmgVwzK3TSL0mqjxtVj5D11bJnnGzmWa/5thquojlNAwFwxi8hS67ZmQz
	 LDnEJEuaDWGfs28g9XjhJvInrUE5/j+ZB/xrft8CKJ3cpjNn3UQ/s9JRRUB3r4Tgyr
	 MvbTtcccdwLMt21apoMLyArSvBDzxTFZcQWCe5IOfrS73WVpTSnXcTyGBrlEH4AHox
	 D6OUEMYyUb4F8TAJSq80mU7ErhD8NaNlob9QNncLXBqsKw4Zc6dtLPRbQyAMXzs4Y2
	 jEm/M143L3rbg==
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
Subject: [RFC PATCH v2 08/10] mm/damon/tests/core-kunit: add probe_hits_wsum damos filter commit test
Date: Wed, 16 Sep 2026 21:05:34 -0700
Message-ID: <20260917040537.107341-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260917040537.107341-1-sj@kernel.org>
References: <20260917040537.107341-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ini7s1eyj9tzze8ynphecj9cea758831
X-Rspamd-Queue-Id: E1ACD160004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789617948-316494
X-HE-Meta: U2FsdGVkX1/fNEG0MtfhKc9/L8q2RvqfQcwOc80hgnzAVKT2use3HhrH7fiiItaxIB7YwuH2e3LRbkhMHw4r4GsVj3cn2AuEvXW2U2OkcQ7vNX1ZO8exdV+XSWps+wVXNOEVO/3PAtDc+TVQUlEqW+f/9ccMx9aRiNwl0ZHIGa5Ls5r16KahQQIcIU+ubmOIWeB7K8+MRPnHV6fP80skze17n6GY7ZySsO+mPFCF75144O6cG2EGy59l7WwDS/h288J1w6DBmNiBsWH8IETCgSrO7NQ+4i2mkWzb//z5KsN5bX7h2qjwg51VitsvnFVt9xdFtjYEaTxBTYlaI+20WLMQ/IExX6D5C5pa8WNBjwOxFof2wBmvtRibVc/3DKggCPzjTpT9k3v6ZIrR2YjtoTjiIQiyS+UqXG3Jg4LizGr8D4GLDQPB+XAy9vp+qhXoNeyiOMQRRoh25Q8E/fP0cgq+du1L0/ElqbfeT80uExmXqsyn+gjttIWMOMbg3lViDd9oucvBOlMc9ydogfuTUfdpg9EnAMfex+RkWtec1rPX/JVIAqMNArtBTRNG8KOH/yiPhvYCwCceFa2k4nfRCdQGWpDJeoQSak3PR6CMY44ULxw5aPfCV14fxYQvBX8hwh4k7wto9bko9L3iPrqmL4Xx4MNq2GrWeMfQXipkEThxiMY+kqX/lqlTGjVPfPy4LBk177Uwi4wCATMpi6YdfAZ79RuX9O1AORlNEE9slAWd3HN9+vYur8pjruON//ODTubpY5zs53GgaRD81JhiXoBvdapmQCB4w9DdA6adU4YZBMqAb42BaUfAvzQ3fIzSJ7i6YlwxsJIy1e3jPZ+vc6oK829K2WSyKT4WekJHIjNQGNyaN0XgHaRBYZKAblFxJSOwEy+wrBefAII5O2XfmPLYsUkiJTnUFrrq8fA4XtnaZARSSABpAXuLGX48ZqoDiGZYwbFV70LWYNQPsrn
 dJiWVhUx
 plFoOgdG11fC9cIOlmxAllOTn6cM7jzQw1q38qF9fJuUvRWcpzvHmaM4GqU3HgauscsNdkfVDBiAXiFLzmhypNeDDzLSumKq5klluXsa2xOdRMDhjUyyWKnszWMbVbK+JoEnsHrOQ/FobdmN5GcX6hN3o40yunJ3OR0ehT+ZM0YD9vKMp3vv3j/i7JSIAgFfi8uTXsb0nGhYpKon4Wz8VPnGLsGByJyPJQUqjlFSwcjRqjHbkfewn8wTnh9ftNaGsNd+SS/sUEsfy2EsocCuFwCpkzQhREoJ3+vA3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMOS filter commit kunit test lacks test cases for probe_hits_wsum
filter type.  Add test cases for probe_hits_wsum type DAMOS filter
commit.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 1244cfeae5e70..df84d9cc7d204 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1166,6 +1166,10 @@ static void damos_test_commit_filter_for(struct kunit *test,
 		KUNIT_EXPECT_EQ(test, dst->sz_range.min, src->sz_range.min);
 		KUNIT_EXPECT_EQ(test, dst->sz_range.max, src->sz_range.max);
 		break;
+	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
+		KUNIT_EXPECT_EQ(test, dst->range_min, src->range_min);
+		KUNIT_EXPECT_EQ(test, dst->range_max, src->range_max);
+		break;
 	default:
 		break;
 	}
@@ -1239,6 +1243,22 @@ static void damos_test_commit_filter(struct kunit *test)
 			.allow = true,
 			.target_idx = 6,
 			}, false);
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
+			.matching = false,
+			.allow = true,
+			.range_min = 12,
+			.range_max = 34,
+			}, false);
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
+			.matching = false,
+			.allow = true,
+			.range_min = 34,
+			.range_max = 12,
+			}, true);
 }
 
 static void damos_test_help_initailize_scheme(struct damos *scheme)
-- 
2.47.3

