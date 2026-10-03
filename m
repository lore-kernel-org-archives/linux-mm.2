Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A98ECA5FE4
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:09:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73CE66B00A0; Sat,  3 Oct 2026 17:08:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ED866B00A1; Sat,  3 Oct 2026 17:08:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DD3E6B00A2; Sat,  3 Oct 2026 17:08:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3076A6B00A0
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:08:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A611C120A0A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:08:47 +0000 (UTC)
X-FDA: 85282554294.20.207DE5C
Received: from mail-yx2-f10.google.com (mail-yx2-f10.google.com [74.125.224.138])
	by imf12.hostedemail.com (Postfix) with ESMTP id C64E040003
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:08:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cAxpUuSh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.138 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791061725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7T2njtLf+tsG9r8toysyAJNfleUrJXsFeeqkEldERK0=;
	b=nQ1oScTQGVLFxN8sECX6YSVlo6YKHjlGF1hjY2TwVWCxRyfja733mNoHTW6k2ZAWicyyrL
	HJ4hIXKHzCKa9y+a36/8eovSXABFU50plcPrGdSQIJ2DlIGVaueyzO65vWi4EIJOkaWmmW
	rP8Uvad+bNfZySenKHVpkydSKsxObc4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cAxpUuSh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.138 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791061725;
	b=lBdHrmInOF0d7tUt0jyk6Z9q8/Yxx2MkvE8GsuKPD6XojztnVsQr0kHriGtjVk93xuaP8T
	BxgjbhyDp1h8pw4aAXlIpvnXeIdYsB3aNgLTWAvLAS2m3DTchVimSGKHDUKQbzV1K0x9Fd
	9GZlPAkCeCNbb9hborQ52TL7N+E2ngU=
Received: by mail-yx2-f10.google.com with SMTP id 956f58d0204a3-66c711552cbso269242d50.1
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791061725; x=1791666525; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7T2njtLf+tsG9r8toysyAJNfleUrJXsFeeqkEldERK0=;
        b=cAxpUuShHIeGBP7DIvgpHMW1hULpQoIUj33Mp6uA3NMGSVZreAABr+9eZD32ZiidwQ
         8RPV+UHTAXbAIx2yi/mqcLy9n1oK+xnNF3J9nULXMR03hYiBHZk1yVYbyzUN04BfFz5E
         1lXTxisWcrvLwFqUpPPY4Us+tEJZN2Vt/Hfg8DbZdey64wxVYjmWmi7e9mGrS4Kz4Tcu
         k6X9Kv1qKif8BCzkAeISW7jdy56I43yj2ItHHUVuRW7t7w6xJsShOP0Cy2FlYpz/CNRh
         MtlDUAHUXR67MNuPEGxtXVd0twaW0OynPKQQ4Xas4kwhDcnuBslierQZOu5C6/hBWPkk
         0g4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791061725; x=1791666525;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7T2njtLf+tsG9r8toysyAJNfleUrJXsFeeqkEldERK0=;
        b=0X/fZl2KX/XyvL3d4+zqRO9gckoXW8CqpVVewFa4u3hXV0E5XoyrJU/w5aSGjlVrN/
         l6tFv3qEGGfY+rTXoPxi/SYCGhvbvn/oT9xU/yPpsmqyyYgvjnFHVAhajt52lH9lhpAG
         R22CYVAjtbyf4pluoNKxnqJVVL1fAPETKP8MVy6UbPlcMVi1/aREf40TEjZtgnP8y6Kn
         wpTib9cob597axEXKUgFWLAisfWOQwMkcBK4wPtTX/PZxlWOX21W9ff5XvkPNq8b1WH4
         056mYPTfIbGNaWlSYcSfR2+eMH7jfbvE4GsSIHGQo5RJpxMEfZS1cij/Rb/EiWk2DfUX
         V7yQ==
X-Forwarded-Encrypted: i=1; AKwUvBy3dX6+4C/vuU/rhMZGzulA1Vj3UfqV+rQGNGWCetfelarZXZ6fGzE7qnpR1LZBr8vZX4csmiyhEw==@kvack.org
X-Gm-Message-State: AFq9FYIBLHT6h4/BHt0E5I2uHNI6ZRVrScC2M0BTxJ7Y726rdZtjFOz+
	Mbtm50E5WtKHNG8+GJ+sZ2xRxlzHx0yjro2SFcKYHFU+W5v2w+wrkF9/tYpGz9tzeQ==
X-Gm-Gg: AYBFou1dGHOjHl2h3UHFxiXi9f1HJ6VDapkF9Bg8hgMkLCjN/OFmEZET2fa9NNmIYeo
	/zQBF7QtvZX4IU/z4VDQfCEa6vvo9bO+2GGHSLg69n3J9LRzehe+pC/pp0g8nzYwQ7P43SxDhCc
	tISy/dGBG5lYcMOG8U9AhA1RpSKmMgOp+S2myDmsjR26GGthSoseHCioQZje+Cg0MTe1iI9L7J3
	4IE7k9MjFRv/1XUxtc4vfiDQUmfowEvLrWIL4ikmN39XWNZQjX/QCJLlt5ZLEi98CMnM5CqmmkU
	yYCnI8RrfqRfTMlIYewdEI6IDc9VEBD6+UGUtiigvmw5VzU1bRCLD+PpRMW1lzpY91ULuDfUlJU
	bCHphYWXaid4Eyw4V4WkL8mSQ4cycqAWclsiA27RCtBvTRG005cQwwO92kmflB6S4r51DmAErFJ
	fsxZFen58d+jgfVWceMNjOaWFEqfCze+aU/q01RqiLqbGQyb4DyMoBu4bUBZnQbFkqYT4bmJuln
	KUFgQJs3ujyuv8AG3nuabSsyoeL9bNkGgynOT4Bnaj1kddJRQRcrMzgRh/0EJBVTwiZkEnCfw7R
	ydMvvEtEoS6QRNOMT/CxauXMelNlRX5ipw==
X-Received: by 2002:a05:690c:e3ec:b0:8a4:b0dd:c849 with SMTP id 00721157ae682-8ae3a5e66b0mr30220037b3.52.1791061724836;
        Sat, 03 Oct 2026 14:08:44 -0700 (PDT)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([2600:1700:4577:1050:550f:9551:5468:60f1])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8af0d179d3bsm743537b3.40.2026.10.03.14.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 14:08:43 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Sat, 03 Oct 2026 14:08:02 -0700
Subject: [RFC PATCH v3 9/9] mm/damon/core: allow both primitives disabled
 when a perf probe is present
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-damon-perf-rfc-v3-send-2026-10-03-v3-9-0f00417b41bc@gmail.com>
References: <20261003-damon-perf-rfc-v3-send-2026-10-03-v3-0-0f00417b41bc@gmail.com>
In-Reply-To: <20261003-damon-perf-rfc-v3-send-2026-10-03-v3-0-0f00417b41bc@gmail.com>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gregory Price <gourry@gourry.net>, David Rientjes <rientjes@google.com>, 
 Wei Xu <weixugc@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Bijan Tabatabai <bijan311@gmail.com>, Ajay Joshi <ajayjoshi@micron.com>, 
 Honggyu Kim <honggyu.kim@sk.com>, Yunjeong Mun <yunjeong.mun@sk.com>, 
 Akinobu Mita <akinobu.mita@gmail.com>, Lian Wang <lianux.mm@gmail.com>, 
 Kunwu Chan <kunwu.chan@linux.dev>, 
 Ravi Jonnalagadda <ravis.opensrc@gmail.com>, 
 Jonathan Cameron <jic23@kernel.org>
X-Mailer: b4 0.16.0
X-Stat-Signature: 49etdnycrj5z8oyr8mwtm1cj19q9mb4d
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C64E040003
X-HE-Tag: 1791061725-589370
X-HE-Meta: U2FsdGVkX18FiRW44ZqqZNIGSFBmUBWw81C53aMNio0whtuNzNqJ2ZCSC5Gk3D5IGicsUQPmVCPUbsBQSpd2BIkpB/PZhxVsi4iDtvsQDKNYsCmV4OK2x1cEQtbIDhLD50Def9Uh/ZU6nn7+HSxG6GVIOECr7qOfF86w2uHu7SFi38zRuQx+599ALFN+vMWDbbBsv5lW2JdxAdb/4+gONeFYd84eGZFmN+gCbhCvivpjOxNOX5oRIa0yiqbNwkOvi1JppD8PRTqzS4i23NJGNzsaR3EvBiACwn8sclmU/AcMADnvTpIdeBTXzZih1YumVReXyyRF5IHt+lku1Dt8ZsbXKdpZdNMgUq9bkJ6tXDDzeso/5JhA/VDTuhtqdwruhLOKZRe4CO0wy25nbbBn8pC6wQVP1JqO08AEEMMPo41jnKvLOGpToHbovsROavMQAV/davuR1evzimbgbRPangIPLMUOOXwimMvhnOU6BLQpjQltmwhV9GoW2iXaEy9kQJec1vZ4EUV9uw09OFC3X0wx8c8K+V1qIDpNP25OVQJwSXBN/iGJjrUlIGyVfgcDW6ZB17kcqvgi05X+kebdjwTN/INPaO/C167UmVzU4u0+MoJbwu1aVtHqej2F9BYOVRE86yRcszkc3kbWeMQnGAYM0ZBV9kWmc/XTKnM+BRiwAGehIwwWxia3unDkbsW6JVyeNMU9qH8+ae+ZKNg4gDXDEfFCl/XSPFH4+IeIfMZODB5VV6wtua9GoxKUKE2n1CMriE7ei6nUDXHSNDhCks67bpEjn86NwuYgKsGauV8ekTxFSu2wu02KjG38o4zZUKZAF8TmPRC4fkVO8JQcCccC7PFg0yJmEfngQeMAkyylDlS4dJS/54Ipht5uA2pTXvKzPncw887GGtdtDJ3i5IXGKCb9asEp1pdbC6LrmP7cs4+OJdU7aXbrmInVEZ0KZIpaTHb5feIYUEJ04s/
 o1K+A2QN
 iPq1lSCz8oVBdf2ab0LB2yjOYu0tKEkx9P2M2lZmNrNuLH53TRBJoRz0Jm/JL0e0eoXdFA1U6XLAEYjHjAwR/CegAVZ5abkVjmLzfczR9SJjSXEMvJtz/XvfHuggEDwSoFf6qo4o5hcWs0IWMPp1018QG7c2wRt4zbqf49wX9iF112fOb43a4LrEwoCRK/Vi2M01B7qGGh3o/edir4+HxNc8jIwh5QCuSz2DBOgDOtN7lvvp3uw/8FsarfPyydrI5daFRGTHubmrOBPcrnM0AJTEWvk5flKqukL8DaC2qFwl0Bb5krkyIG7OwpS98svO/OKzzE2YNGt/MSJzlJjBUDsiGpYuhKTWJxgj3K0pumhx+qnnqQOSuUU/pqWINR+INRGeqNBNogsNZEjm2sFilP49o4dGA3F2h2+u729qyMtAtiKOXtw/KYnLpsRJgQSnYuXR+deOZf4neESsGLJfJTNro9SFCc1Re6lUYprYe0jtoRedwK0nOSU5K83+tVNoIb1V1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The sample control validation requires exactly one software access check
primitive, page_table or page_fault, to be enabled.  A context carrying a
perf-event probe needs neither: the probe drives the access signal
through its report ring and the drain, so region access rates and ages
update with both primitives off.

That check runs in damon_commit_sample_control(), which sees only the
sample control and cannot tell whether the context has such a probe.
Move it to __damon_commit_ctx(), skip it for a context with event-driven
probes, and run it with the other validation of @src before anything is
committed to @dst, so a rejected configuration cannot leave a live commit
with its PMU events already armed.

Add damon_test_both_primitives_disabled_with_probe(), which commits a
context with both primitives off and an event-driven probe and asserts the
commit succeeds.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/core.c              | 11 ++++++++---
 mm/damon/tests/drain-kunit.h | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index c2c74d0daf95..04a1cccbc2f5 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2357,9 +2357,6 @@ static int damon_commit_sample_control(
 		struct damon_sample_control *dst,
 		struct damon_sample_control *src)
 {
-	if (damon_primitives_enabled_invalid(&src->primitives_enabled))
-		return -EINVAL;
-
 	dst->primitives_enabled = src->primitives_enabled;
 	return damon_commit_sample_filters(dst, src);
 }
@@ -2390,6 +2387,14 @@ static int __damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src,
 
 	if (!damon_valid_probe_params(src))
 		return -EINVAL;
+	/*
+	 * A probe-driven context needs no software primitive.  Validate this
+	 * before anything is committed to @dst, so a rejected configuration
+	 * cannot leave a live commit with its PMU events already armed.
+	 */
+	if (!damon_has_event_driven_probes(src) &&
+	    damon_primitives_enabled_invalid(&src->sample_control.primitives_enabled))
+		return -EINVAL;
 
 	err = damon_commit_schemes(dst, src);
 	if (err)
diff --git a/mm/damon/tests/drain-kunit.h b/mm/damon/tests/drain-kunit.h
index 8e5023ebf6df..be44311617fc 100644
--- a/mm/damon/tests/drain-kunit.h
+++ b/mm/damon/tests/drain-kunit.h
@@ -722,6 +722,42 @@ static void damon_test_bsearch_unsorted_regions(struct kunit *test)
 	damon_destroy_ctx(ctx);
 }
 
+/*
+ * Test that damon_primitives_enabled_invalid() accepts the both-disabled
+ * configuration when an event-driven probe is present (this commit's
+ * relaxation).
+ *
+ * Before this commit this configuration was rejected (-EINVAL).  After it,
+ * it is valid: the probe drives access-rate updates directly via the report
+ * ring, so neither software primitive is required.
+ */
+static void damon_test_both_primitives_disabled_with_probe(struct kunit *test)
+{
+	struct damon_ctx *ctx;
+	int ret;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc failed");
+
+	if (damon_test_attach_perf_probe(ctx)) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "perf probe alloc failed");
+	}
+
+	/*
+	 * Explicitly disable both primitives.  With an event-driven probe
+	 * present, damon_commit_ctx() must now succeed outright.
+	 */
+	ctx->sample_control.primitives_enabled.page_table = false;
+	ctx->sample_control.primitives_enabled.page_fault  = false;
+
+	ret = damon_commit_ctx(ctx, ctx);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+
+	damon_destroy_ctx(ctx);
+}
+
 static struct kunit_case damon_drain_test_cases[] = {
 	KUNIT_CASE(damon_test_unified_vaddr_match),
 	KUNIT_CASE(damon_test_unified_vaddr_tgid_mismatch),
@@ -733,6 +769,7 @@ static struct kunit_case damon_drain_test_cases[] = {
 	KUNIT_CASE(damon_test_report_addr_space_keyed),
 	KUNIT_CASE(damon_test_ring_full_counter_increments),
 	KUNIT_CASE(damon_test_bsearch_unsorted_regions),
+	KUNIT_CASE(damon_test_both_primitives_disabled_with_probe),
 	{}
 };
 

-- 
Git-157)


