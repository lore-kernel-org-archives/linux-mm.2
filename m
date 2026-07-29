Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1664CC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 03:38:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED8DE6B009B; Tue, 28 Jul 2026 23:38:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB0126B009D; Tue, 28 Jul 2026 23:38:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9E8F6B009F; Tue, 28 Jul 2026 23:38:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ABF7F6B009B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 23:38:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4AC8A4040B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:38:05 +0000 (UTC)
X-FDA: 85040405730.28.CCC1E21
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id B1D4DC0009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:38:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZzxeRFxL;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785296283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ggyUfqv6rcj2Idk2Q0OaE5oz1yQGxvQa0INt8+zgULo=;
	b=U62clfpzA/bmd/Eh0bA6IxBS3QfmTuWLrfPOlUdXCd6As46qzNgEwnHAqgoXaq2f+ujkFs
	3Eb7Txx/hRUkNI+LmA46HNTtw2t5rcJPg5qSJgr9qd7Vp/v2OFei2IXeSAVnCIKsWAlGG1
	B3l7dBJ/enfvAuZGVLLwawiVaRf3L3c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785296283;
	b=v1tvpzW11Cz8g/mduxvF1mSkB3sIaCsaIpsyAcy2J7zwzteiVSu275i5D8ANFX0yiSIkRn
	F79/HNjy3WRFEXPhErG089CIRHdLnsKUk30EgjHnNzDviECyEYjlCc7/IW2qiBJtRnEkd0
	qZ+9ecYjZjX8FxcmDoaZoaw0khl4MSo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZzxeRFxL;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 113A445135;
	Wed, 29 Jul 2026 03:38:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E58B1F00A3E;
	Wed, 29 Jul 2026 03:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785296282;
	bh=ggyUfqv6rcj2Idk2Q0OaE5oz1yQGxvQa0INt8+zgULo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZzxeRFxLEmbPpcaxNy5rtqNHDk75sZk/D32PBHaSu2X5RJpgBdZtGc09ZAwXdYxkH
	 2FQ73eNIGjZ60PFSFM27Cy69En9S+TI6KwXZDaS24n+GuT5du23PYhez/Xlmlhb3uE
	 KLKa3YBDWr7zES++U6PU39BbfU6zd6+LGOVBPAiC1bmZ0A+GMwj8LX6fMP/UsL4pbO
	 EJ6BqvynLxuxQutAQEdnH9ea2bLrz7yKEVU/04AaEtwxWoBBkYjOTrGiEoMqYtrZb5
	 Xqzx0vtNQ9CJ4wfiDr77NZpJUSgTCEJLp4UE0iK+jyyGars+pdUgEhw/N4n53tlszR
	 MQ2dPFAXI6D6Q==
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
Subject: [RFC PATCH v1.1 07/10] mm/damon/tests/core-kunit: test damon_nr_samples_per_aggr()
Date: Tue, 28 Jul 2026 20:37:47 -0700
Message-ID: <20260729033751.131213-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729033751.131213-1-sj@kernel.org>
References: <20260729033751.131213-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B1D4DC0009
X-Stat-Signature: xttn7ckiep4zj3dewyihbjjp74td8ao7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785296283-120018
X-HE-Meta: U2FsdGVkX1/BO7/ffslGP3rU0Yfvw9QuBOr5H1Ri0eoMBfsCWShWlU5as6eH0qLMsTxLoobSgjcdllrdRQKrLZe9fc+uWBWaaIlkF7sEpVbJWdwPfbTD53G1yA2ciE9QQmfs8tQO89ECMfqW3AEbWRGixReQcW6TeCGuPaMEb8lAzmcnzBvw18vN8P3HN5UVQY7lwCqLgucrY1IhFJJVPdd/pz/maiJ92RC/D+xhrLqyntO7crbVZZNeunn25C4pjq0hrBRFoYWvfke6FumOzjf1dkgyEGJUuZdevrGqe7z7YIhvP38GFPlTiWSuMUrxnlFdJ/N27r+ZbYQuiaxWoZDX5um6imgJHwn1j7UXrSc9Z5SRGrVnakInv8wJLw+prfAIuceJhAACsTa+7wdKrCcNs4wXsX68+qHrVkXzPUKZ1lVYn2V/ccJjPneC7ivYyBAFaBXs4B66nRt+zZ20te5CZHJyWWjU6ePX8i0VcY5b6zosyUIV7QhVyNdssKl3//qq+EEEjEd+nqMhYjGUamjj7jU7lqGv31lSMk8y9MRBwUrSfAISqHmnN61gxaFSwSLI/DrMzHLp5/Ep6IEoIT/DX6fZzRv4paYsdtX1pP6ixQjA9ANcUsy7i9uqgFMgzAH/yFuEupx32EH/azZGvi/2b15cpgViaNCIjxJ3lxOcXjMG1+8JnM79MEe4+whOCMD9LxyR3JLjCltoLHt6NBAzokM/8lQIu7kW6XBW/mmCXrUkdtc+6n/tNS+wqtBKqlVLCvYCFYDaEJFYVeQrU79J+1ojbPR3b//lfuneGlM4MKZ4CymjgNcS5CvGj2LtdvJagntNTdnder7MU4WsuUiFoQnI0c0beJmm4AtdmViKlIWJfBw8zytt6UoNSeI7JHuxCpFFNCWfy1w/OZCn32+bnXAgFw1GXimGiOcFVtVtoO1CKdWaOf8xMBalGFhNzA2KNbCBlNbiF3qcNAt
 x2FcBL1P
 IdznyU6AEeJzDZ6L6J+sHzQppu6DkkiUcJ4eke1f9yE86h0u2XCMuMU3UxToy63TxnkDnj4TWZqaJWei0ZQ59ywYbUpD/WVt6+8YovAQ+GKC0jEdBlvEcsTsFwDYhoTBVRZA57RHKCwKlauvfd96SQZ2n+p4cD+gA9eDVOwJwSMOuIYCbIIxJ0/bClVXb03alhx2K0jT/2UrfmGqkByGRDrplURn/rQVhtYU0GPF2KVDEKZj1hMfaM/k8w0O1N9xTLnxt5F6kdqvG21oh3Y4xYiHp1A==
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
 mm/damon/tests/core-kunit.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 3041b8288ec26..0a1882ce6a081 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -619,6 +619,27 @@ static void damon_test_set_regions(struct kunit *test)
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
+	/*
+	 * Too large aggregation interval on 64 bit system doesn't cause
+	 * overflow
+	 */
+	if (ULONG_MAX > UINT_MAX) {
+		attrs.aggr_interval = (unsigned long)UINT_MAX + 1;
+		KUNIT_EXPECT_EQ(test, damon_nr_samples_per_aggr(&attrs),
+				UINT_MAX);
+	}
+}
+
 static void damon_test_update_monitoring_result(struct kunit *test)
 {
 	struct damon_attrs old_attrs = {
@@ -1670,6 +1691,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_split_above_half_progresses),
 	KUNIT_CASE(damon_test_ops_registration),
 	KUNIT_CASE(damon_test_set_regions),
+	KUNIT_CASE(damon_test_nr_samples_per_aggr),
 	KUNIT_CASE(damon_test_update_monitoring_result),
 	KUNIT_CASE(damon_test_set_attrs),
 	KUNIT_CASE(damon_test_mvsum),
-- 
2.47.3

