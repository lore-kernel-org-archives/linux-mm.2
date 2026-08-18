Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1058EC5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 03:46:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA3536B0140; Mon, 17 Aug 2026 23:46:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B54296B0141; Mon, 17 Aug 2026 23:46:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1DE46B0142; Mon, 17 Aug 2026 23:46:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 70EA96B0140
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 23:46:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5F7AC0975
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:46:19 +0000 (UTC)
X-FDA: 85113002478.17.F0B40E8
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0B74040005
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:46:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=g-ucla-edu.20251104.gappssmtp.com header.s=20251104 header.b=YREg2AK6;
	dmarc=pass (policy=none) header.from=ucla.edu;
	spf=pass (imf27.hostedemail.com: domain of jasonangelov@g.ucla.edu designates 209.85.214.176 as permitted sender) smtp.mailfrom=jasonangelov@g.ucla.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787024778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fDkagHVNS2LJhNT8XESQiKeoHr8QVrsAQC8Ivqfl/sw=;
	b=eoXf5qHeyCDsGtHHS1bwrWmluHSHexUPxIvesvi2WhRvRjbT3OUI189Rrjiz/mdF1gEMu+
	8obznEneMLlhxzls6YB5j5xYBldIWzr+UIKv4KKiR3Gn+2VComycWcPTrEk0YkreI5nySR
	K30UNNY6/mBP5g8Iz3Wsf5hCQCsISqY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=g-ucla-edu.20251104.gappssmtp.com header.s=20251104 header.b=YREg2AK6;
	dmarc=pass (policy=none) header.from=ucla.edu;
	spf=pass (imf27.hostedemail.com: domain of jasonangelov@g.ucla.edu designates 209.85.214.176 as permitted sender) smtp.mailfrom=jasonangelov@g.ucla.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787024778;
	b=Wofw48H1ZtbRUsEdHUAn9MV7zURwqQzLtfpDNGlVKj5H1A3JhMwfzh1nXeVgzwuuf1gpRi
	6IcOhC9eVZjMCRYkBrHcDFi9YPPmBJ9K9pHTdAfbOK1eMIJu2L/jpY+Jfib1/zaIPfDurd
	fcbxJlXcm5kqZYQaYHTkrs30ha4IMT4=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2d01663d816so37161015ad.1
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 20:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=g-ucla-edu.20251104.gappssmtp.com; s=20251104; t=1787024777; x=1787629577; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fDkagHVNS2LJhNT8XESQiKeoHr8QVrsAQC8Ivqfl/sw=;
        b=YREg2AK6RebCEfxC/TVhl68s2uih44JpxKY9FjNfBLl1y8w3RHNemDxafM4uhp1Lzt
         6VUf6L/DWGdWddBnLklBEeeCwrdpSLHNbL20v2Rqgnyf5QOBqIZtNyQKvsukOQnnwGKx
         sBcswN/Nf+JnVcrPqnu9yt6EqYTHBcuQd1mRiHpH4Bs6O0HZxGIH/yqjvJDb9j6e31Vr
         nNjKrHc44V0y+fp2PJbNpiGJ5y4WbZ1SzBxuX2sbZnYUuA1PKXyjrQbY7STC9UQuuEGi
         rm5SUHPwT+6kya3USTrcef390jwCUnOfUYVO6yWyCk/7JOCj+1l0bWLEzUKr2c/tbC8z
         yvzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787024777; x=1787629577;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fDkagHVNS2LJhNT8XESQiKeoHr8QVrsAQC8Ivqfl/sw=;
        b=OWGdjdbw05Ha5Y4zG5RpZI77VXA9ei9smkhPH2yi4haXG7YNrqMAD1t4+J+Gmx7DzR
         1i0z95HmWP5gTSRoQJheUNvjpBaSA8rELuNObKB9mnBSsTCfTVQ3mvjNtdaOTDMfXpA8
         ab6WX3VitpTAs+5yyRdlMlIeN12LCbuMXDmdZvtrVYlGSYs5RyB0mX1mEmVrICwp3JJv
         +dKTgrA8hfcfHXMK29tN0L7FSW6y5Z/fQ7w8ORn/njverYpH0Olyk9CWNL2cybng/cKY
         fiyIw336z8z9QM4nO9lJK9gTWPe7CBQyP9ee1DDVsRXPWf1Akb/a/wqo4u6Q2EkwiQsq
         cM1A==
X-Forwarded-Encrypted: i=1; AHgh+RoCUaIkqkqioLyWI7xvLZJB05cW3kv8pZifidbNSZX6EPLEPxjV9HWy6vXDNXwyh4WishURyUDrlA==@kvack.org
X-Gm-Message-State: AOJu0YzBZquetMz3upkHkBLYvvoihzsVdqsn4NA+dboXjlQsGYvKCLNb
	Ep3sIcncMniyt9ZDVmJPcm9EQObYRvyh6LWMNK5XovCX3BRyU8+ESoRd/dIJrZ9f7Sg=
X-Gm-Gg: AR+sD12hffNn5ZFcGfd+QRjcRWehPntAjbQvXEfVKxX/DWqYAccr/YwRR5HjJ+sTUTz
	zPtnteZub0iV++so1CIimvUgO3CzgHyxK2rfhBPJ35eeRvSiZpPmLkG5Y5rtR7syfrQDlYFFdwy
	1RMx1QKPASOasZ+RpXPQMJAPM/c+BkFXE6/d0hewVApprV7OXFL7DdE/ZL7PCk4b6LoGWnxMFJ6
	Ept3wpcwaTEgHpM3gFSeoBtxui5AbRbPsQlEw+pYXrReeru13f9UHXrtPypdPKPXtn06bySmkGE
	N7JLt2ljkkuDW2+gSoi1Q5oiwKZzlSlSR7NdEILgNXN0wrPX+sBbgy3wEvdDMU9dm7okGRWbjre
	VxYD8D8yXuwMSAnbvlf6WEb7CKOGmm643l1pYo8erP3IinQnSrU/R02P4dSIKY4bfYMz/5YeSGM
	glzLe4CfU5iWCebp0wpWNi6mcge/VuzyTmvqH2D/FGkzN0OC1xCCGNWc2xszx6pkFWlaw/NKu9O
	jt0dqH1wpuBbbJV
X-Received: by 2002:a17:903:37c4:b0:2d2:da8e:9017 with SMTP id d9443c01a7336-2d3b0c5437dmr334519695ad.8.1787024776791;
        Mon, 17 Aug 2026 20:46:16 -0700 (PDT)
Received: from damon-kunit-dev.tailb106f5.ts.net ([73.93.135.51])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3267be8e35bsm11453293eec.14.2026.08.17.20.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 20:46:16 -0700 (PDT)
From: Jason Angelov <jasonangelov@ucla.edu>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: shu17az@gmail.com,
	jiayuan.chen@shopee.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Jason Angelov <jasonangelov@ucla.edu>
Subject: [PATCH 2/2] mm/damon/core-kunit: test damon_valid_probe_params()
Date: Tue, 18 Aug 2026 03:45:52 +0000
Message-ID: <20260818034552.11975-3-jasonangelov@ucla.edu>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260818034552.11975-1-jasonangelov@ucla.edu>
References: <20260818034552.11975-1-jasonangelov@ucla.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m73t6jxfiord54x7exhzgrsa4i6rpw6k
X-Rspamd-Queue-Id: 0B74040005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787024777-435453
X-HE-Meta: U2FsdGVkX1/HIt7U5mFOtUwh8HykF+7BAtKg8Y4NxQCwQZZ+jl9c4aMDhaH+BWqfu2lix9tQ/ZUHG4i/J7V+uXtSV0AligRhwxm8HZ1WeqVQkiOXrgSIqsBQaQ5ND31KVNpTCS6DlBk6z35bvy0U7JLrey1XKtVzOQY84RqMaTXz+/JxtHQchVQOLbzKYL1mh/vw/J4UcV2CwhY1Qq9CBNFyNjkv/l2W0Re+ICJUpM9H5ScViWZk7WeE5KQnCR26YtdyW7sGwrmdc2F0js2/brcF30ZTikwf2AMUlJH+iplbLNEw/tHqTLWSpRt1oK0qvTymHGnkk4/MlGRKGDjpSia0lvU18ZkuNwXc+Foq54/1AHesl2ERxWpdVlBwVT1wnLDRR63uZcW2SDCrygz53VUobXZG1Bz50fF/XriHEwYVOa9Hrb/BbWg0+kw/XWfNZZza+3+pHXf1iROFN+fKCYrU9W5DlIxybYeKBjdgaAbK87onwQ4FhQ68EHTtt9SooIHbmJ7daUuPaz9gNh36VwCVbf63dtNTn46Lle1d0zjQlWordCMQ4FjZZyoxU/qeYo83yk1M+d5h0jB7+M1F9eTME4qBihCnzonp6LP3vfnfwBdo08nenfZCdAvhhfKr6dgp7OjSuihxjXyznqiEDB1oeN6QW4+iSVeSaff0O4lsmun1fld2AjKD9k/ulCDnwKrXi36LGEpagFGZAuDl1mrG+5CYxZFEi+HPugot2H435UfLowEStOTE4fnuRFU3MiUG9q5Q67WeTNy/KjY5W80L5GoWYck5PYjw7tcL3rjXqojKclWSZNsjzZqP1fBvDqdefndgUNw8WYKjJ5j+lYEGlTYJGHtoF4Nur6iZgdlQWfM1zN601Nm2hwufHP5gX3o/K9ekRxtxO7rDQ9B+3SlPVDg5wxSqU/BZ0baosyVM38ApibWCR5oiHWx+YGI1oKn47aUO0iH8EEqg4Cn
 9SejbWDZ
 NfOEArSzZIyymNiZS3v6813IqOmfzJ8s2maCppyBguSEqfIk/SHrrflqaJM8PkS/gB+et8Zv7RjKnNz2n573DguWXFxAborMuRTBWWhzWNbV/nGwV0ek5pseGHqNsP1raWcEuEVax4Hrs3V1XAEcKEGI6f9uWaA72xMBsO7Bjjn/TGDCPZoDFKK3IOcdm34ftg/eKNx3/GBP5lgURe3mpepxsr/vBNgrNRyqfkWlxMbKlFyop7+8JGPVRFaaMopUf/dSEDaN80P3WoybqJtnucox/fn35Wj5/Z6aVU7E1e2WijTiWwFA+HjmlIfyvncYTUFVRPlsGUtJDkkFi+WSo60INt25ABR01vhJQWSqctT1HldGr61p/XjMKHnnQm8o3KwHyYrzOx6d2wH59h3E3JQ18qoLD3I0cA5afCqxgwoQxsy1HPkT+/iAi1qcs3CliShA2D8AKEI4ymcnJ8YUR51Agmp9MWYPL0oFS41MxugQd4q2AF8NbIGTqtzs/saH4c8z6xF0o/lXFkCFsHggxsP+IfGwWgSv0KaUP0r7QZ7pTNThPXHlyDZq78OZiCbp/98QYRNl6b+MCxwU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_valid_probe_params() makes damon_commit_ctx() reject probe
configurations that could overflow a probe_hits counter, a single
(weight * probe_hits) product, or the sum of those products.

Add a kunit test covering each rejection at its boundary:

- samples per aggregation interval: U8_MAX is allowed, one more could
  overflow a probe_hits counter
- single weight: the largest whose product fits in unsigned int is
  allowed, one larger is rejected
- multiple probes: each product fits, but their sum overflows
- no weight set: the validation is skipped

Signed-off-by: Jason Angelov <jasonangelov@ucla.edu>
---
 mm/damon/tests/core-kunit.h | 57 +++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 2db94d49c9ba..b1ca4c8e03f0 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1338,6 +1338,62 @@ static void damon_test_commit_ctx(struct kunit *test)
 	damon_destroy_ctx(dst);
 }
 
+static void damon_test_valid_probe_params(struct kunit *test)
+{
+	struct damon_ctx *ctx;
+	struct damon_probe *probe, *probe2;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc fail");
+	probe = damon_new_probe();
+	if (!probe) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "probe alloc fail");
+	}
+	damon_add_probe(ctx, probe);
+
+	/* Parameters are validated only if any probe weight is set. */
+	ctx->attrs.sample_interval = 1;
+	ctx->attrs.aggr_interval = 1000000;
+	KUNIT_EXPECT_TRUE(test, damon_valid_probe_params(ctx));
+
+	/* Up to U8_MAX samples per aggregation interval are allowed. */
+	probe->weight = 100;
+	ctx->attrs.aggr_interval = 255;
+	KUNIT_EXPECT_TRUE(test, damon_valid_probe_params(ctx));
+
+	/* More samples could overflow the probe_hits counters. */
+	ctx->attrs.aggr_interval = 256;
+	KUNIT_EXPECT_FALSE(test, damon_valid_probe_params(ctx));
+
+	/* The largest weight whose weighted hit count fits in unsigned int. */
+	ctx->attrs.aggr_interval = 255;
+	probe->weight = UINT_MAX / 255;
+	KUNIT_EXPECT_TRUE(test, damon_valid_probe_params(ctx));
+
+	/* Any larger weight could overflow its weighted hit count. */
+	probe->weight = UINT_MAX / 255 + 1;
+	KUNIT_EXPECT_FALSE(test, damon_valid_probe_params(ctx));
+
+	/* With one sample per aggregation, even the largest weight fits. */
+	ctx->attrs.aggr_interval = 1;
+	probe->weight = UINT_MAX;
+	KUNIT_EXPECT_TRUE(test, damon_valid_probe_params(ctx));
+
+	/* The sum of all probes' weighted hit counts could also overflow. */
+	probe2 = damon_new_probe();
+	if (!probe2) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "probe2 alloc fail");
+	}
+	probe2->weight = 1;
+	damon_add_probe(ctx, probe2);
+	KUNIT_EXPECT_FALSE(test, damon_valid_probe_params(ctx));
+
+	damon_destroy_ctx(ctx);
+}
+
 static void damos_test_filter_out(struct kunit *test)
 {
 	struct damon_target *t;
@@ -1664,6 +1720,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damos_test_commit_migrate_hot),
 	KUNIT_CASE(damon_test_commit_target_regions),
 	KUNIT_CASE(damon_test_commit_ctx),
+	KUNIT_CASE(damon_test_valid_probe_params),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
 	KUNIT_CASE(damon_test_set_filters_default_reject),
-- 
2.43.0


