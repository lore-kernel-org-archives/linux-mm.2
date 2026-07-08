Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45316C44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 02:49:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D1A66B0093; Tue,  7 Jul 2026 22:49:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 482216B0099; Tue,  7 Jul 2026 22:49:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BEBC6B009B; Tue,  7 Jul 2026 22:49:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 14B846B0093
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 22:49:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8C0FF1404AD
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:49:06 +0000 (UTC)
X-FDA: 84964077492.22.295FEBC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 027C2C0003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:49:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZqriC04w;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783478945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JCC9FMAOFAsuAQp9u1XHHxd8HHnGHTKjPJp30Yo3v74=;
	b=Y6iHTVuuOK8YLS6H3I8W4Mn14+0ksRDVZpAhPyg6H1acDarryGRPk7HEfGgN4pQI12pu7M
	mhJyL8yJ0BD4aPy2J7GZX+A2ebWplCNDs7c2zgQPVzKpNkMsAWYYZMubSU3+5ZCcxtxbqF
	/5xY2zPHhopeMi1RzX71/0j4CKhqPSM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZqriC04w;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783478945;
	b=n6rNG0ndyf+cXTgOb2+rofohh9Cr99XCr/B20zYIOnlbvUFIZomT+nWTGh9bLRiXcLsDvo
	keV6bwfAMg88V+sh/C380VgJG0fQUndiZJJHBBZseM+gQe7JfgPb0w9dM8EUfXaiula1UP
	k8PL9kJFY6LJjZ459d6BLbqcroP85Ps=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 770986001A;
	Wed,  8 Jul 2026 02:49:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F2C1F00A3D;
	Wed,  8 Jul 2026 02:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783478944;
	bh=JCC9FMAOFAsuAQp9u1XHHxd8HHnGHTKjPJp30Yo3v74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZqriC04w3Ae7ID7pH6eyKY1qnkdT8nCo69YhVoPpjA4o6zWTh8u/iana8L6YTXxXS
	 MV+s/CtR9xqcvu8lEavSitFKwh64iW1OSEu730zltUvFhiJhIuNeGeRtYJ2cdE2ZFa
	 t9rDYSnk8NbyEpD9vxX9BBDJ4mCOFEYcJjE8L45qNjzibXSWcQhFFMyXq+0S45rZay
	 Iz7zAkjqWW+onqp9r6m3cC0HjFGxWzlXP3QqtMQ2Or/LChU7487TfT9a4/t1MFDLjZ
	 UmelNBlJdYMy2AD4RF9FvBK7vqU/kUeVaxkzNdmGehy2R0+YAdLzSGo8NbZrY9OdWi
	 xkUK/GBpvmzrg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 1/7] mm/damon/core: remove comment and test for nr_to_bp() divide-by-zero
Date: Tue,  7 Jul 2026 19:48:47 -0700
Message-ID: <20260708024855.116614-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708024855.116614-1-sj@kernel.org>
References: <20260708024855.116614-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 027C2C0003
X-Stat-Signature: xp4iqnb4w5gng59ei8gzfb7prue5ztwh
X-HE-Tag: 1783478944-678694
X-HE-Meta: U2FsdGVkX18BNgw71Ly3mKwLBfRX1I5q3BWqmc/RT5yXSOl6BM4/xRUqGMZbqC4sxGrF9MIHYla6oPk3ftYChmm3uxpfM/bfSEEWPhUq90S39+gvYzvBoSCJmGYfHm1cs6Jed4HyN3APJUzB9bvmaXZbloTK1bJVjWsYXOBALDJ8r9kx4vTAjmuI7GLJq+wNbsVQqLhUyezxQCloxjjmFw09ZZR8hkzp2t/SdJGof9OFIaaHPTzdZccLrWAh2bj19Dw7iahYsxalQKyJe1uED+pYrXkEsJq4mK8eg+CGvx0QOgmh4rHQV7y0RpgxB6fW9Lvi+kgm+7OPnN6FUfjLEywj2k4m7jLnEgLdXUc+C0Woy9n5pGrL5o4vlf2qUgs9UJkYY/dS5tst7hr5vdl+hmmkUlHK189mCAMwt5DzICVzTSOc+0b15b7dy3kDz5i1mpwTdjJXZPpVj54zsCRTHiGrg+osDoF3qcQExvMBzh3mKquGQGkUY3+jfnpv4Yrnb+HPIxR0uqcucwXP9rMl26yn09c0Z+plCU8YCcyGasrHrAD2T7Yzq0XK1Er+NY4bQPeMZddlUuNl2Dybx4aq2t/IMOwYgbyShl7NOcT/wA9GkknikvZkAtEveMTSnbC8gk038kGG2bBew0FVAdITXmqqxrImYhwkgdVDFTdlqm4TxtroeVDdYhWsHeAAUMbUQ3GX6Hib1DYPW5UdRedHuO221SQ80feBwA0JO2thl+H5Q+5aNjhgGoPvSwolramdP9YtSyj3D+s/OMvFxxK1JL7P2RYKB+lggBHloRwC0sJOXD65rGcPxT2ge8Uk6rJaNab463J5dSC1gTmtOu8mbXY/vecNJ9HMF1V28RccTSrAs3Y9FwD+U24BoN/Lgg9Tra3CyD4QjRdRZBnSO6woFf+t8Rq69gdrDPTaRXCj1MDKZN1cC1hqKMYTQ4KFN4slsr354UhhXpo93qj7sNH
 aZDTYGTd
 fdXgcslkXu66IHIKwbb7fHF07PZndyXU7wN75JOwE0f2s87fY9StjLiIe4P5+ep/rAcDiU/qrZCh05XzFkNUSa0Spk7SA7O9nGhLbtG6fn+8GzYBR//KGGAX1F0bf/IHSF/h1Jbm1XP2epQBUDp+GA3YrKJejMisfo4DtxYSb3hh9JjaHYm/2xJdUOrwK2iILpsUdy+sLRIcJDsVjbHA+TXymFUnbXIr938kG9iIobCZ9U3fjuR8RWnR3A39DYtKi6WsCXBa6ykrt3Dk0N649iieruA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The comments on damon_nr_accesses_to_accesses_bp() and its unit test
warn it can trigger division-by-zero when the aggregation interval is
zero.  Commit 35d4a3cf70a8 ("mm/damon/ops-common: handle extreme
intervals in damon_hot_score()") modified damon_nr_samples_per_aggr() to
always return non-zero.  Hence no division-by-zero of the note can
happen.  Remove the obsolete comment on the function.  The test code was
written to test the division-by-zero case, which cannot happen anymore.
Having it makes no sense.  Entirely remove the test code and its
comment.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c             |  8 +-------
 mm/damon/tests/core-kunit.h | 23 -----------------------
 2 files changed, 1 insertion(+), 30 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 390e00b3685ef..a15005db82899 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -883,13 +883,7 @@ static unsigned int damon_accesses_bp_to_nr_accesses(
 	return accesses_bp * damon_max_nr_accesses(attrs) / 10000;
 }
 
-/*
- * Convert nr_accesses to access ratio in bp (per 10,000).
- *
- * Callers should ensure attrs.aggr_interval is not zero, like
- * damon_update_monitoring_results() does .  Otherwise, divide-by-zero would
- * happen.
- */
+/* Convert nr_accesses to access ratio in bp (per 10,000) */
 static unsigned int damon_nr_accesses_to_accesses_bp(
 		unsigned int nr_accesses, struct damon_attrs *attrs)
 {
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 0124f83b39b83..278d46632eff4 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -575,28 +575,6 @@ static void damon_test_set_regions(struct kunit *test)
 			}, 3);
 }
 
-static void damon_test_nr_accesses_to_accesses_bp(struct kunit *test)
-{
-	struct damon_attrs attrs = {
-		.sample_interval = 10,
-		.aggr_interval = ((unsigned long)UINT_MAX + 1) * 10
-	};
-
-	/*
-	 * In some cases such as 32bit architectures where UINT_MAX is
-	 * ULONG_MAX, attrs.aggr_interval becomes zero.  Calling
-	 * damon_nr_accesses_to_accesses_bp() in the case will cause
-	 * divide-by-zero.  Such case is prohibited in normal execution since
-	 * the caution is documented on the comment for the function, and
-	 * damon_update_monitoring_results() does the check.  Skip the test in
-	 * the case.
-	 */
-	if (!attrs.aggr_interval)
-		kunit_skip(test, "aggr_interval is zero.");
-
-	KUNIT_EXPECT_EQ(test, damon_nr_accesses_to_accesses_bp(123, &attrs), 0);
-}
-
 static void damon_test_update_monitoring_result(struct kunit *test)
 {
 	struct damon_attrs old_attrs = {
@@ -1572,7 +1550,6 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_split_above_half_progresses),
 	KUNIT_CASE(damon_test_ops_registration),
 	KUNIT_CASE(damon_test_set_regions),
-	KUNIT_CASE(damon_test_nr_accesses_to_accesses_bp),
 	KUNIT_CASE(damon_test_update_monitoring_result),
 	KUNIT_CASE(damon_test_set_attrs),
 	KUNIT_CASE(damon_test_mvsum),
-- 
2.47.3

