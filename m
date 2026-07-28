Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6954C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 05:28:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFF9C6B009D; Tue, 28 Jul 2026 01:28:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAFE26B009E; Tue, 28 Jul 2026 01:28:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC5E06B009F; Tue, 28 Jul 2026 01:28:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 99B3A6B009D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:28:21 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1E95B1602EF
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:28:21 +0000 (UTC)
X-FDA: 85037054802.22.FE35077
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 71D0540004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:28:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ITlgc3K1;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785216499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WANJwchnQO/oDcbFCGZSI0J0jnkXHDon5WOhOSC7mrI=;
	b=YXB/oV8UpZ/IQHe5I2glPf2LklYIkgGOmGZrtoBavNCkg3Ue68zXTv4WFg13KTAJXraxhT
	LqUfSfbsG3qjeASKnMW+oW6ECzy5+9LUFbmYMSqo6yXeCPdk42NgLnX07ckkw1eAOmXNJR
	44HcXhaLNn8EZtd/J/TfglEbf2/nuoo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785216499;
	b=vSNnZW/JixusL8LdLfYOWcq5KXDuMQXBL3fZsXWy1m5N9IxUMoxAmbOM24tN0y9LIyE7Gf
	2XqX847kt06nueckEQIuM+CpnUy8rrBxwgjeKfF4SH/HMqKJolcVs9Wf6ptFXOTVZI35n6
	QvUZkD+JBMARSl8tHMnvGJHEodioIe4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ITlgc3K1;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE81D43EC7;
	Tue, 28 Jul 2026 05:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED511F00A3D;
	Tue, 28 Jul 2026 05:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785216498;
	bh=WANJwchnQO/oDcbFCGZSI0J0jnkXHDon5WOhOSC7mrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ITlgc3K1gbc4fzExooJOGRYeHLp5/stACpvKLZqGvUS1G6qW4Gx2Q8k/3sz7fzvXi
	 uIPkuLr5J0tdHWpSqLNmcw/SjhTM8Hn2Yln/XxPmvNkaa59I4EUMuaoyG6MvM0CK4X
	 87EbdlTkVbaeljZxrhbz6IsuQ6fWyqmc0ZLYRGDbUbdIU9OW/Cdko8QWzOqHxOk2pK
	 KgL6ipr151mM3xUxBhKHwanPVkJT+L3IBtVgKIEEypnoeedEr7mITJSKAebkUas9yA
	 JAZqgqZ/fT69QSNTWahmgNpD6gUoOh+VkLTDwvk4ub4N8ATLYwT9CkxHultJ1nA27C
	 Wh/QCAESTew4A==
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
Subject: [RFC PATCH 07/10] mm/damon/tests/core-kunit: test damon_nr_samples_per_aggr()
Date: Mon, 27 Jul 2026 22:28:06 -0700
Message-ID: <20260728052811.192712-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728052811.192712-1-sj@kernel.org>
References: <20260728052811.192712-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8pkixwamry1i4fk31pdooqrb979k6cia
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 71D0540004
X-HE-Tag: 1785216499-132421
X-HE-Meta: U2FsdGVkX19RSGigZ182QMom7ggbIiHYKVaXuEAbYtGARfFqQ68K0kWW7aMNZjQHNRwxc8Z+hptWoKE0EUrobvnSwmwIp7fH+/+vUmrL+a0KyZO571d7Hugp5/14OjGlqWxyv6IU5gCuwmuXIA9tYMM54z/djPvaumkD5kmOvpZSgzzvjFJaxp0HLY5fJtLocdf27Aq7VjUCSnjQLr152B5hdxxJrtdoRxYeJGjOc13MOgGWxiyahyOh33MDh/UdbrfGvG5ts4tSTRltjYf7ySQRT1VbPAmZ5YlVfIQ6sQE+WPL4UeNhJJsXRQpEZJXafG6r2QGffwGOQXgX/P/OhLNcpSeYMhZepRlklTC3PskDDisUfzACMyFzUNmYKj8c9PNmmCtr8oPO0UC6xhvro+x1zNY2RwK54ccqyxgORUPdVEz3Xr/E04c+WIXYNwe/m0wvrD44PLGBhn5CgfzXvgb+n2KH+XlPeqNc0CT/PWRvJViefWlf5+QXPgiSYQB9MOBi6t7FroF+8OKK0OSVGNsSCYciMBdBKZAIIXdmQXzsmOT7sPBscqcLEG8+jiwVXf92aQKOiuABFNAURuwEzPWV8b5TB1zMv/JrFk4B5XQ0LRa1rbJ9rxNxpo2/KIVykbChYFsLe8XX8dGmARt6OvGaRkEg/q5S0+eJIuA2aQBd/D6H9K69GNepdFpTSK54mzFuJ8E39gV+6nsM4aN0Yi+q+KHcaGYltDmkfeuXcd16NZSBuSOnh9la8Ch8cH5YYWCoOhoXo1vn3iyc7VqOnVMOwEohX8EHXs0TaS0m/mkycJLHaIgcD3uYzzjj0RGNg22Q+u1+rhZYbSXL3WGJ2EQuCFGeoWNaiMzs3b9FlZa4bZorJQ0t4B5G2Xg8mHANQANK+kTT2OsGPg+7JSxaVbgwHMdVtroslGSv7SH5pVEqJ1VTACRL+k+LsAeIgtr3d5kmZ9YRLhADKU3+hu9
 e+2PQ2Cx
 ycIAQN69Ynh1k5BX7ykMil+/VR3GED0mid18er2aAkAIxBoy9k4DqUKngpo7j4TH2gQdvTUVsqn1aKnXxpzqahM5/CaYudBJs1HComNZ7gDg6573C3PUN5nYjsgOVMRPLm4ldsmHjtse5oHA2IC05ljiANQZWEC4nBTBiUc+5DMCOQE/HMLpGjvvz7SOkE/m9DVBrAMv9tUZpwXhZipkSS3HlgrN6wCeaAcJ7+mG9WDIWJlIHzQ95zpSBYsbQP3oUtSflr4872ujOqpwE6foPvva4WQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_max_nr_accesses(), which is a previous version of
damon_nr_samples_per_aggr() before the renaming, was wrongly returning
zero or random overflowed values for extreme intervals setup.  Commit
35d4a3cf70a8 ("mm/damon/ops-common: handle extreme intervals in
damon_hot_score()") updated the function to return correct or more valid
values.  Add a kunit test to ensure it is working as expected.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 3041b8288ec26..511f2856d343c 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -619,6 +619,22 @@ static void damon_test_set_regions(struct kunit *test)
 			(struct damon_addr_range[]){}, 0, -EINVAL);
 }
 
+static void damon_test_nr_samples_per_aggr(struct kunit *test)
+{
+	struct damon_attrs attrs = {
+		.sample_interval = 0,
+		.aggr_interval = 0,
+	};
+
+	/* Zero aggregation interval doesn't cause division by zero */
+	KUNIT_EXPECT_EQ(test, damon_nr_samples_per_aggr(&attrs), 1);
+
+	/* Too large aggregation interval doesn't cause overflow */
+	attrs.aggr_interval = (unsigned long)UINT_MAX + 1;
+	KUNIT_EXPECT_GE(test, damon_nr_samples_per_aggr(&attrs), 0);
+	KUNIT_EXPECT_LE(test, damon_nr_samples_per_aggr(&attrs), UINT_MAX);
+}
+
 static void damon_test_update_monitoring_result(struct kunit *test)
 {
 	struct damon_attrs old_attrs = {
@@ -1670,6 +1686,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_split_above_half_progresses),
 	KUNIT_CASE(damon_test_ops_registration),
 	KUNIT_CASE(damon_test_set_regions),
+	KUNIT_CASE(damon_test_nr_samples_per_aggr),
 	KUNIT_CASE(damon_test_update_monitoring_result),
 	KUNIT_CASE(damon_test_set_attrs),
 	KUNIT_CASE(damon_test_mvsum),
-- 
2.47.3

