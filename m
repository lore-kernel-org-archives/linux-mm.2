Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6381606BAB5
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 15:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=g-ucla-edu.20260707.gappssmtp.com header.i=@g-ucla-edu.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=jkBb59ec
Received: by kanga.kvack.org (Postfix)
	id 089F46B05B5; Fri, 13 Nov 2026 10:59:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F07C16B05B6; Fri, 13 Nov 2026 10:59:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA7726B05B7; Fri, 13 Nov 2026 10:59:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A0AFB6B05B5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:59:23 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 15AC71C26E2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:59:23 +0000 (UTC)
X-FDA: 85430555406.06.07C19B9
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2E11718000B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:59:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=g-ucla-edu.20260707.gappssmtp.com header.s=20260707 header.b=jkBb59ec;
	spf=pass (imf16.hostedemail.com: domain of jasonangelov@g.ucla.edu designates 74.125.82.53 as permitted sender) smtp.mailfrom=jasonangelov@g.ucla.edu;
	dmarc=pass (policy=none) header.from=ucla.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794585561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BUQE0kUGDk8M7CIw9MtJvjFLkWAN6uJ898YNqYUmUwc=;
	b=boBmT3hU8sfKiEMM7++bvScXBjUynbyTfiwbWip6j8Uqf7wgGdfcJp9em4DXZQzj3VMiHB
	2S86qRGGclTkmkOBh3pqbaLcG4nLFNbpkTRFbLy1vJe/Ld7MQzBZ5rqMeuMQCnyab2LmCR
	OA5aixvc6l+fnPIQFLa9byzT/O3AhtQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794585561;
	b=EY00AwSgEdbhzBnNoh0dXWOuPAT9akQRzCZJ/+CReMT3jUhY32TMG2wdP/OOIIQEjM1Xj0
	rluJcIwWBsAn8H+MeNkoXqNT3xMJYByEm78Aegu6Rm5Qzf/08H36mquKqqZhZkYSAAaB3y
	H+6jTjvBq1CQZvlAwwgGraknWquio7k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=g-ucla-edu.20260707.gappssmtp.com header.s=20260707 header.b=jkBb59ec;
	spf=pass (imf16.hostedemail.com: domain of jasonangelov@g.ucla.edu designates 74.125.82.53 as permitted sender) smtp.mailfrom=jasonangelov@g.ucla.edu;
	dmarc=pass (policy=none) header.from=ucla.edu
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-1a2af4c8d00so2114944c88.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=g-ucla-edu.20260707.gappssmtp.com; s=20260707; t=1794585560; x=1795190360; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BUQE0kUGDk8M7CIw9MtJvjFLkWAN6uJ898YNqYUmUwc=;
        b=jkBb59ecdmkrdrI0zjNAbRscOIQcUBmZn20SjsfKBcxbo4aEe0OemzJzBStBItHq49
         oYoTnTjjs1FW9BeUy5lJHVKspr9bRT672A4kIjUnSjlvE7njbIB431shTPxCNFELrKb+
         ydEPv4TVbv56z4xRqmftN0miN+r0HXHCPeWTX5t8G4zzqRz66ImF92Kn2Ev8FXLviXyx
         7IAs/bUeePsGnlkpLaBSbIMCwjHL/zw5ai+xkPL2vuyyxMbbZ7gU9tdGkGgrzR+Lyfi6
         rx2fuKGFjwL/aGkF7hVP9DL7OTxunkfvgfr4PgYInmp2e0FdeGwFgYcy3Ul/qAoSGM4H
         +IAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794585560; x=1795190360;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BUQE0kUGDk8M7CIw9MtJvjFLkWAN6uJ898YNqYUmUwc=;
        b=pXzFLqriZ0OLbx4ZsWLPqnDC+sFPmkvaxhgkgX4k3lmqsXBdrhbRz9l8r8hW2FhGub
         mpbaluPGf44T751qAiIKHU1vaRqcSEDDZniKwBCLnzxwOqLAs6Jgd2fSn+1o8GEYJ3lx
         HhCuOMFqvV+BNQ3949bGjNm1NunS+xuxSl2YfwiztlJbVu0o2mU66m3kuSKIq/uCPOMM
         n6cGmMVbVQUZaWL/S2v4DNTc+sOEaOKcLLMP404njrM/agdApK9wfdmEhUhdHcryQTin
         J/UshoJTwxoFscBhTX5EHFtlTZluJhL6BrXMoloc1DHSwL+6y9hQcGRwoZj8ECvyPeM9
         HH6A==
X-Forwarded-Encrypted: i=1; AL+hErG97dhZ4+Kud88PPbk2nAbI4ZBfOlK+0sG3Ozvp40Jnmwhm2ME9GuOj2zfrC1nKmTYnPYkajQKqkA==@kvack.org
X-Gm-Message-State: APuU4Z/iOrwJddzn3eELZsx5LlNqlbMdfAAow0S9iXcRhatGJVPn02KK
	mZKyPbHxvBNMJDwwRL6gHV+osZrygUolzicN7yy36yK/nIME0a2Cchn0KYpa4FtKw+v80kzuOvB
	OyLEmeOeH5g==
X-Gm-Gg: AYBFou3g3Eu+xKgeS0+eYUA/SYglH+RfkoiRrL+vw2NL8xQW0EZnCUznyYe+RIdyTF2
	j6byrttol92pdKQNDQb1NjmMFXJkQLJYaezxgOqqtyGpgUkuRLq//Txd5O1gJ+ct2CrTst15FLs
	KjaBj01vmtDPvEqoLnNYvqFtFrtEM5btvhxdRs8Edqxcx8CnJpT6nefbuoPakbRHZWllQRMBYva
	T08mS2lPlbaL5XZEQAu23ztV55JTJp59fOefzLArirHGInMrIOXbOPVItF20yzPhYMR7GpvYAY4
	TAXWec0dDOCfY26NYCD7u8RBeX9emLtV/jhsDSMCCxjuaNKMDyIkL+bdQ6usmwwIyO5Y1A/jQ6P
	j5gzngljNNYZ+IeTBCXK3+ZGHKurZeI2E5JLUaD4QLv8Xy6Qt3AqaCYKcWhySNtzlmaz4tnS6fA
	y9VbVbYYoZo5pTKeNCoXjMgilZaiJmaOtyHMiPFiCtkaVkJb9tUYNI9BybanwPL4wV4rRLiJT0s
	8Jmqj4quef9+ZIwjQ6OByhIEPJN9v2LgpfFkV+BGCmu2oKGH0k+9oNfOy0AOa+7UEneYcJYY5tE
	UtN1TN+BKDNCD2ffGgb15c2NLn+W2Q==
X-Received: by 2002:a05:701b:4590:20b0:1b3:b53e:b4c5 with SMTP id a92af1059eb24-1b503137aafmr2631085c88.38.1794585559658;
        Fri, 13 Nov 2026 07:59:19 -0800 (PST)
Received: from [127.0.1.1] ([131.179.95.34])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031bc518sm7868383c88.15.2026.11.13.07.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 07:59:18 -0800 (PST)
From: Jason Angelov <jasonangelov@ucla.edu>
Date: Fri, 13 Nov 2026 07:58:57 -0800
Subject: [PATCH 3/3] mm/damon/tests/core-kunit: test
 DAMOS_FILTER_TYPE_AGE_MS interval changes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-test-age-ms-filter-v1-3-b99eab2f71bb@ucla.edu>
References: <20261113-test-age-ms-filter-v1-0-b99eab2f71bb@ucla.edu>
In-Reply-To: <20261113-test-age-ms-filter-v1-0-b99eab2f71bb@ucla.edu>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Jason Angelov <jasonangelov@ucla.edu>
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam06
X-Stat-Signature: qh6uj1nkf1phqgrrf99i69tb438be8dh
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2E11718000B
X-Rspam-User: 
X-HE-Tag: 1794585561-881395
X-HE-Meta: U2FsdGVkX1985EF3hnEMcOhW5g7Xl80B9ZhHdMNE7EuYRp063AWrNkx1iNZohpMRx9eJRqq/72HNdyz4RwQaKeFfcnfsCxorR9astjvEPc6VkEhXqZD2r9TJaPjZv6fjjHUekAEJ90WuQ1fkjluu5I7yNcdfiaRreDDa+enBvBkfR3+wVDyDIi5Z4ve/g85nCK+sHuwlljCRAj1w2OZ5FwNHXRod8M6CDlg43sfk0Vx47aXmCLMREJWlFlXBmoNcRCVnkcQ8JFoRRT2bdXL3ZhdvDpyPc9+7NwoDMV0AjZHUi9FptoNxElhyqy2fX2XQbRNoQCGrnOfTw+ZwBwr74ORjE2aYwUebsqL5VwnHhkUnmsvkr44j4diNyz4BVEpdQ1Q23nwCAiV0NF27WU9dFjHJ2GQSP2H9IhBTwRa0sJmBZkrRsYn+BT3LcF/GPi/QALq6GGjnwW9gUYc8gpHWRdvA+Cje4kS3qjAvMbaWpUsKU1R1UWmR0hw6EjFRIVI2hfE7EDNFbWSQb9VB+MCkcRPhbwCDGSBunIpXLcKrFF/dXWuEpV+WDvVmGHfS4osV1/h3Yb+NyXybNb9zDtVoZ82Xthpfdg456xsBmN3PTLdNUZ5hOW8M7/LH6h6A6WEMqoF6mBtkVCNwbbWnLWvV804/8wmGgHrYHwJ8EA9FUXaslr6BGMedplWm+jajOaQEX/coGq50/DylkWJ7sETAv5PPw1ruepbvTQx8R/4dUtkRtS8LvG0aXvmxwR6FLdAsJQdh86q4SGto4B4Ymf91VuTabgYqWf/EKgICWos7CjUrE/Br2PEYSjnNRdil7uaUebrZTq+7BIh3NtksqtJrao/xqoTuVezi+9sTPyQ+YNDog96oO0oXlWgzTuZ8NNiiIu5ColRO/2P1PTHZ635R+CrzIsDvaIBg2ksvixnBnwHLZz75NTBn2dzjUwYL+v1GWJTHzaIRC34o5yP7xwS
 7L+PxgAS
 EkGpX6bDOsJERsNdEKz35GAR6odlOeGJadIiibhjrtltSRk5v2g4r6pawfghTzjtU2OvZljcXuNcuPArez56fXxScK90Ejy3l7ovNCS8tvMW+jYVv7ujB9h79KSfk7bqD5qpnKy5cK1406ikIRn31CFamRounERU1e0ItIPvTJFqea9cGWgQM+O7sZX+wJL2AIoG3RCU5ba0A3IiEI+tVpOaLmLI2ecYxKLOxp4us1fhXve8Jjqfo08pqoXzossbzcL8v8hYIR41cGbhlZJ5ioBuw16rQcqMkSxv//1+huqeHYmYWQwvuVXrfRkcpE52TamV0EwPbveTxNsdrb203wlgLUE7ISK5DuC6bDOqNpAdw589KM/UkuBDUUp0jQVj0qwDP//du26J0X9SCwm09FJORszctWVVYX1J8Bid85Fd5W+FNymloCjDTFOJLLOQM8wcXoilg7JZYCOx8u12pPFZb9J/tSlP8ve9RsBym0CwFjN//mhTzVijToaKLquODx5x7gO2ffCtoH3ewHkKpmR+fbrlwbY7kAZe/DpNBGUbBwHEClwkprESXDDvneJRKUMCa2BrknPoQq/JOwah7PGiwAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMOS_FILTER_TYPE_AGE_MS defines an inclusive range for age in
milliseconds to filter for target regions.
Aggregation interval can be changed by users or intervals
auto-tuning features.

Add a kunit test for each:

- convert region age to milliseconds, correct behavior at boundaries
for defined filter range
- DAMOS_FILTER_TYPE_AGE_MS filter keeps correct behavior even when
aggregation interval changes

Signed-off-by: Jason Angelov <jasonangelov@ucla.edu>
---
 mm/damon/tests/core-kunit.h | 81 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index fb84d30a712d..6de7c2531702 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1837,6 +1837,86 @@ static void damos_test_age_ms_filter_is_core(struct kunit *test)
 	KUNIT_EXPECT_FALSE(test, damos_filter_for_ops(DAMOS_FILTER_TYPE_AGE_MS));
 }
 
+static void damos_test_age_ms_filter_interval_changes(struct kunit *test)
+{
+	/* Filter window: 200-400 ms.  Start: 100 ms interval, age 0. */
+	struct damos_filter filter = {
+		.type = DAMOS_FILTER_TYPE_AGE_MS,
+		.matching = true,
+		.range_min = 200,
+		.range_max = 400,
+	};
+	struct damon_attrs attrs = {
+		.sample_interval = 5000,
+		.aggr_interval = 100000,
+		.min_nr_regions = 3,
+		.max_nr_regions = 3,
+	};
+	struct damon_ctx *ctx;
+	struct damon_target *t;
+	struct damon_region *r;
+	int err;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc fail");
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "target alloc fail");
+	}
+	damon_add_target(ctx, t);
+	r = damon_new_region(0, DAMON_MIN_REGION_SZ);
+	if (!r) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "region alloc fail");
+	}
+	damon_add_region(r, t);
+	KUNIT_EXPECT_EQ(test, damon_set_attrs(ctx, &attrs), 0);
+
+	/* below window: age 1 = 100 ms */
+	r->age = 1;
+	KUNIT_EXPECT_FALSE(test, damos_filter_match(ctx, t, r, &filter,
+			ctx->min_region_sz, &err));
+
+	/* inside window: age 2 = 200 ms */
+	r->age = 2;
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(ctx, t, r, &filter,
+			ctx->min_region_sz, &err));
+
+	/*
+	 * change aggregation interval 100 -> 200 ms:
+	 * inside window: age rescaled 2 -> 1, still 200 ms
+	 */
+	attrs.aggr_interval = 200000;
+	KUNIT_EXPECT_EQ(test, damon_set_attrs(ctx, &attrs), 0);
+	KUNIT_EXPECT_EQ(test, r->age, 1u);
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(ctx, t, r, &filter,
+			ctx->min_region_sz, &err));
+
+	/* inside window: age 2 = 400 ms. */
+	r->age = 2;
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(ctx, t, r, &filter,
+			ctx->min_region_sz, &err));
+
+	/*
+	 * change aggregation interval 200 -> 50 ms:
+	 * inside window: age rescaled 2 -> 8, still 400 ms.
+	 */
+	attrs.aggr_interval = 50000;
+	KUNIT_EXPECT_EQ(test, damon_set_attrs(ctx, &attrs), 0);
+	KUNIT_EXPECT_EQ(test, r->age, 8u);
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(ctx, t, r, &filter,
+			ctx->min_region_sz, &err));
+
+	/* above window: age 9 = 450 ms. */
+	r->age = 9;
+	KUNIT_EXPECT_FALSE(test, damos_filter_match(ctx, t, r, &filter,
+			ctx->min_region_sz, &err));
+
+	damon_destroy_ctx(ctx);
+}
+
 static void damos_test_filter_out(struct kunit *test)
 {
 	struct damon_target *t;
@@ -2599,6 +2679,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_commit_ctx_keeps_quota),
 	KUNIT_CASE(damon_test_valid_probe_params),
 	KUNIT_CASE(damos_test_age_ms_filter_is_core),
+	KUNIT_CASE(damos_test_age_ms_filter_interval_changes),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damos_test_apply_scheme_filtered_sz),
 	KUNIT_CASE(damos_test_apply_scheme_filter_sz_unchanged),

-- 
2.53.0


