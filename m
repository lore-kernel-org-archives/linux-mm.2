Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83A6BF54ACE
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 15:40:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5DB36B0088; Tue, 24 Mar 2026 11:40:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0EE66B0089; Tue, 24 Mar 2026 11:40:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B24A56B008A; Tue, 24 Mar 2026 11:40:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9B79E6B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:40:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54288B6166
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:40:24 +0000 (UTC)
X-FDA: 84581368368.13.B414A79
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf21.hostedemail.com (Postfix) with ESMTP id 584371C0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:40:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=ApcTv89Q;
	spf=pass (imf21.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774366822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lnuvGybt67fKfdFIPouSOwFAG9kGA6DmWroqEsHCBQs=;
	b=27Z+xTiQX9X1znu3/mU+7tM2EXYVbgmKetBtpq+1rPw/DIlpDnMZg1mf5mwFI16buT5H5Y
	Cz0so53iPRUcHnQO4TZ64yOJfTCe88qY8lYZhp5c6uxaoIncDvASyi5BR9f1dEkp7r+9pr
	Cl+ntFoX0oaTn5a49gzstRtkcGfGsek=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=ApcTv89Q;
	spf=pass (imf21.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774366822; a=rsa-sha256;
	cv=pass;
	b=vDdYaL8mbDvwCPJ/LuMvye9tn8qnDa0D6GxbJ8dQ8OP+aMoLSDgKxVE3PLDpgJ0RG1duMi
	VwmgyJ5TMfSlRe7X/9CYOkhrNtgd4zh6mVGzN+q1rlciIoNu2LOEZl+b9b1IvrLOVw51Mn
	RfmWLEh1HyzwU7z1BZm8uuUi759G6JI=
ARC-Seal: i=1; a=rsa-sha256; t=1774366809; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=PG+uUpA0fQD+DWxyX5gc5CFsJwS1CLZTBshjd8V1y2FbCkIbB6bClUessVUdFywKZ9RLA7qd0fus54lprO+Ak/X9wFKhPYHBcRevA6oPgiX0KU/L6D5Uo4qzIZdpiZ0xuEWhuVJXcsV+ibwc9YVA/lsu1OrMvvBzuKPihqp2jt0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774366809; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=lnuvGybt67fKfdFIPouSOwFAG9kGA6DmWroqEsHCBQs=; 
	b=QsiOtcb6/eodUJIc8Xx88I7v8Ydfi1mpwDa4yGy2249kSh1cCi2Uv28r/iWTRXVZyMGznNiwHi8AKqZIbEhVaWUkc6PLOEfCxXm8Hp5FEZKLRPouhRRj4el4+g7DmtEdA7mHElLhJaG9ZTb0Z+T5MndpYU82UPlBZLKtkawQIGA=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774366809;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=lnuvGybt67fKfdFIPouSOwFAG9kGA6DmWroqEsHCBQs=;
	b=ApcTv89QuZolSgC985pWaNnS8UKQ1dYo6Olk+EijNpyJKeV/xjfwnd3xsXl0A/Y6
	E5Ik3PWPmWRd2gFT0XBj+PeKwqeyuBGeYIqBwAc0rlC5mes1GFu4p3JCCMQxvpBYDOq
	Xv+X2sYT696aZezdivaxY3OOc/GWL2GGfkyqZZWQ=
Received: by mx.zoho.eu with SMTPS id 1774366806625819.9630672140645;
	Tue, 24 Mar 2026 16:40:06 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH] mm/damon/core: eliminate hot-path integer division in damon_max_nr_accesses()
Date: Tue, 24 Mar 2026 15:40:05 +0000
Message-Id: <20260324154005.83651-1-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 584371C0005
X-Stat-Signature: oay1wdqjopcz4kzcatzma3dby4h6ey8u
X-Rspam-User: 
X-HE-Tag: 1774366822-700875
X-HE-Meta: U2FsdGVkX1+i+IFEgE7aeim7JKQ3cIeCcmtN+NC1krm2oVHgYEm6nDeJcDXAtAVR4zbfkkISW4OyhbBtTqawPIAs9RUHIcNWznJEK7MvR0Ej17pcScIGLxKMqRbZOe/I7LdoIQGjbJFP3wtuYD0X6Z6GOZvDEZECWLfLZq/UJn2TdD6TFTiOd9wWxC6GVdOtTakKGgAK47KxdT2RHyPqjioQ/cuidYTX5j3lJ9O1mDagNlwAW+ElwR93uQQ4ZfEauP5fyX+hDrtkffrYncSbwkHnBm0XaF7aNrL7+D64ZHi8JuDeDYoZky5oxS/3Q68+7urL7TxoYgMhS8Flu0LFamCRBIePxZl+Z67Qij+ejh3PbEBcjki/PKespqNhprFBs1ZS1tqAQsR7DfZ38JI31ZoQTrxewjuHBzyvQm8B2EzSt3xDGyr3h4pcUzCtu81/Wkk1lv/cKOn2T0jPQMOLLRpkGaEkkaRuQDmLIffskt4lrMb6kExkZbIZlFiYP8BgNSPvHSH8kPC8fsNsurbdXdU1SlRoFcMBI7uhKPjVCZJpVAbkc1IO7j1BABSMZ+IG9iaOEZ+zD9HUE5yRdHAe2gKj1bSDQCqdsYP1E7zD1meHkYMuKnjZloVkKa6lXt1QvpAbeuSf1FQbwR+BM3GVchlfKJ1qAEpU8NHwknuszk7O9i4m+mp2wY/Ef2acBQMXUqBNLfk+rZUxVGEu0n0JJHM9rGDiomrZiNooz8SM1flP52X+PEMhtQeLeegEQ6Dkla48W1sLuW/AfKAZnv1tJdodz22xJOL+6FHJFbEEv9TJtcTlU8tlNrDB+/qJWtkJeU4Gog3isacDEsI9YBnPDZf3VIfYsMvNE3j6l+asF/A2RhFxxRsAsP86zDJzbJGqVw7pmuTxjEj4+Cr7zN5Gb8/VUcJlA6uuzW9nO+Em2HgKdhz4hTNKqRPZkob+8RFR7MxNpXFT0b1RoUWeCS2
 C3EXBURr
 w2ZaIw9hogdSAXKsUMei/NfZyKFv1PbNjSjeCSGfMj84DI87ENXgwEPf3xyKJ/pOS54fjFGYnMdWOHIh+7cKV3+irVABdD33vQa5T7uQAR9ag4M+U3Agvk6Fd2d9cEkHLC9uqmSzbnLKNUVg9i6aw3NbPhpG9LZPrMb9Z4Yr24O8Mrr+gPuKsJRKR6+cUboPVBn4gA0DBVw5ic/FTKulLFbQFHqzy5KiwJ3S+KtUJ/SGU5FHGyE0+akggk6aEpuApA8eiE9HSC74voyY5uFcq9NV4CXfhvYztgbqJTRyKWdDeTyEJzOGcSTAZUWtL2U/losKnoeRaBSxFVCOdk7tYfPTUzsXI82izS4zepgxWWKkLv3ZBg1XSzDdn7s4QORbSfROaYm2R75HssSc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hardware integer division is slow. The function damon_max_nr_accesses(),
which is called very frequently, performs an integer division.
However, the struct damon_attrs already caches this exact ratio in the
internal field aggr_samples. We can eliminate the hardware division in
the hot path by simply returning aggr_samples.

Signed-off-by: Josh Law <objecting@objecting.org>
---
 include/linux/damon.h       |  3 +--
 mm/damon/core.c             |  1 +
 mm/damon/tests/core-kunit.h | 16 ++++++++++++----
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 6bd71546f7b2..438fe6f3eab4 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -960,8 +960,7 @@ static inline bool damon_target_has_pid(const struct damon_ctx *ctx)
 static inline unsigned int damon_max_nr_accesses(const struct damon_attrs *attrs)
 {
 	/* {aggr,sample}_interval are unsigned long, hence could overflow */
-	return min(attrs->aggr_interval / attrs->sample_interval,
-			(unsigned long)UINT_MAX);
+	return min_t(unsigned long, attrs->aggr_samples, UINT_MAX);
 }
 
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index b0ab0ee6eab9..59b709f04975 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -582,6 +582,7 @@ struct damon_ctx *damon_new_ctx(void)
 	ctx->attrs.sample_interval = 5 * 1000;
 	ctx->attrs.aggr_interval = 100 * 1000;
 	ctx->attrs.ops_update_interval = 60 * 1000 * 1000;
+	ctx->attrs.aggr_samples = 20;
 
 	ctx->passed_sample_intervals = 0;
 	/* These will be set from kdamond_init_ctx() */
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index e86d4f4fe261..56d03ef6a5a4 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -416,6 +416,8 @@ static void damon_test_nr_accesses_to_accesses_bp(struct kunit *test)
 		.aggr_interval = ((unsigned long)UINT_MAX + 1) * 10
 	};
 
+	attrs.aggr_samples = attrs.aggr_interval / attrs.sample_interval;
+
 	/*
 	 * In some cases such as 32bit architectures where UINT_MAX is
 	 * ULONG_MAX, attrs.aggr_interval becomes zero.  Calling
@@ -434,7 +436,8 @@ static void damon_test_nr_accesses_to_accesses_bp(struct kunit *test)
 static void damon_test_update_monitoring_result(struct kunit *test)
 {
 	struct damon_attrs old_attrs = {
-		.sample_interval = 10, .aggr_interval = 1000,};
+		.sample_interval = 10, .aggr_interval = 1000,
+		.aggr_samples = 100,};
 	struct damon_attrs new_attrs;
 	struct damon_region *r = damon_new_region(3, 7);
 
@@ -446,19 +449,24 @@ static void damon_test_update_monitoring_result(struct kunit *test)
 	r->age = 20;
 
 	new_attrs = (struct damon_attrs){
-		.sample_interval = 100, .aggr_interval = 10000,};
+		.sample_interval = 100, .aggr_interval = 10000,
+		.aggr_samples = 100,};
 	damon_update_monitoring_result(r, &old_attrs, &new_attrs, false);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, 15);
 	KUNIT_EXPECT_EQ(test, r->age, 2);
 
 	new_attrs = (struct damon_attrs){
-		.sample_interval = 1, .aggr_interval = 1000};
+		.sample_interval = 1, .aggr_interval = 1000,
+		.aggr_samples = 1000,
+	};
 	damon_update_monitoring_result(r, &old_attrs, &new_attrs, false);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, 150);
 	KUNIT_EXPECT_EQ(test, r->age, 2);
 
 	new_attrs = (struct damon_attrs){
-		.sample_interval = 1, .aggr_interval = 100};
+		.sample_interval = 1, .aggr_interval = 100,
+		.aggr_samples = 100,
+	};
 	damon_update_monitoring_result(r, &old_attrs, &new_attrs, false);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, 150);
 	KUNIT_EXPECT_EQ(test, r->age, 20);
-- 
2.34.1


