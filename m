Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7283CC624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 15:07:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EF5B6B0095; Mon, 31 Aug 2026 11:07:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 826C46B009E; Mon, 31 Aug 2026 11:07:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 651AB6B00A0; Mon, 31 Aug 2026 11:07:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 286056B0095
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:07:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A028514017A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:07:01 +0000 (UTC)
X-FDA: 85161892242.20.7DF5C6E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 157E61C0002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:06:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F5wScyc6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788188820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o7lIq+lsQYzbYzf+cqUQ249deMwzfBwDjcIr5FOU1kQ=;
	b=4eVa+OckWfFjSY4sTPf9kGZQXip8qf7PS9RFsvy1xq2BHOUgUrrH4tjDbngTxg5OriUKZm
	EQ/s37xAbt6SJn2zydWEpSM9hH6CZMf0YRrdOWXhRjh8oLDRYMU7eeksP263eyBIpZl2Y4
	ojHsJMMQ1U0Oztlqq/pwtb7r1PvWFZo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F5wScyc6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788188820;
	b=GWv/ae/bw4Mu8b1A9hjSEHHRg6T9SIMD64G22Vt5euXHgzCLJSR7/K2M5lvMhODdKfQ+pz
	zDmjmQmQpvomKKcnEvJTWF3tDIkyb7HnuNko+YbhNXRav+pe5TlOfSjWRiPf6m82zHv50C
	hq+HVj8XhFmZc7ifg+KGK8pHDQHi5SI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A914E601DE;
	Mon, 31 Aug 2026 15:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119F51F00A3F;
	Mon, 31 Aug 2026 15:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788188819;
	bh=o7lIq+lsQYzbYzf+cqUQ249deMwzfBwDjcIr5FOU1kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F5wScyc6VUkcQzeNeObcmSoumA5UwCUlKoqWQIJjXLhYY/NhNn0CVz16iLB6Wof5X
	 OVbAR8k2fpqNpOlw8oKOWNbtpgLrFd76oQ4H0cv34bKVOU8Twv0chFMJsgWvfk/PLP
	 +Y8dF45RzxRUn3tlrqfTrFCLv9XnBsnjWxG6nf4WcmqBLEJtMgQS+5pE53CGvhVPSf
	 fsnGoVnyVVwT/n1NZD9f6PU+O4e0k5p+6U16ExhiX+lWBunFoXtCTCV+/cBa4spfb+
	 s8TVCYgOvdvblvVqxU62Sin/thY7oQUGByap+TxLzaHqDjUEYwf5HkFZz+zFqqIWDz
	 0OFFIq2lQutSw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Angelov <jasonangelov@ucla.edu>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 2/2] mm/damon/core-kunit: test damon_valid_probe_params()
Date: Mon, 31 Aug 2026 08:06:49 -0700
Message-ID: <20260831150650.84829-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831150650.84829-1-sj@kernel.org>
References: <20260831150650.84829-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nc341mczaxswpe8boo3sgormh14ainpc
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 157E61C0002
X-Rspam-User: 
X-HE-Tag: 1788188819-770015
X-HE-Meta: U2FsdGVkX1+GNB1frzVRsimvxoXsnvlKbiTVXr5YbB4L9eEtch+zTs3uajhKm/gbQ54ucMUjm6ikFIhPa2bYS9Lg0ugIeSPiLh4Pm71hneNYpdpEiHUEVfiBbSlU5cmIoKfDqTB5HyvBTCDrI62lYz6BP+15bnnJmqFb8cDh8T8kkjeV2JY6QJy9fwEEqhkVDyqD+OJ8E06gIj43JITe2j2iBQ3enrvlr1uKywmJ8G8pqAZLCyMMp0tcoXUx6hGgPeFSjRZ3ZznhKkFvbKGsmhkUynnv5vZv0sqLT3XZmDmaQ6X1w09o6icmMp+8Kyh5GT58MZ+jciatxu1UpNc2amAl3MPmqdZoohSWc9KWSYNDhcj82M730Yax4XR+fPgPtCK8O8GJvHyLdO/a8HazDv8x+KhSWNikrHFfy9S0lhyggBAZSSlKlmRUAf0p9O89qCNH3yCSRkFQ5hTDkNldNGz005TZihLgG0nryJ8MH0xiNDKlCjRBzPMkQES3uOS8FzjUbPkKw+dQenj0xVxYhlkQkDxX6A18LZd/NMhPc4SHAKI/ggR/Ft9ZhrvJjzCnhe/DmGQXwO56++rGe4taEhanclkXC5KJ4LdZ4og2CelFCdwKTRLPfz7ugCOh8BtS9I05XdlPQ13jb79CetdmvTtVCEhZqC/GzvjlUhDn3qpjalSGEf3v/cmnYGAtZYF5rR5j1hh/MSrV5sOLXDvt6b2Ef0jzARLoXYX7D241pMAnE8WCu6QF0evQQrj5XqZyyp20j8+b6CmhkGL/KvZx0+qZ2vQ2xvUKkIUosZiMHgkvN9Q/xBOKYnH0nqfcJ+OHQ+JrImRy9zui59sSqvrV5gway5HcC9857CIjVe9Kv2mY1E3QFXOakUShTkp0OIpYNYmz/wJiAZgLCgZeHENQdmq7Jj5Z0ujIvnL4Iv3zEJypuY/dvToeI4GaIl1slNDVuuHmYo8aoZD44tr/cSK
 HD2rep/S
 TDT4pREUXaaz2DEF+jDlf3xCOSvuYjRnUaBhyNQQv8FTJNRh0yYZQrAOWkURYbNbu7lz674YjKqgq8wzO0dQkZRDZ88XJGinkL78D528G8ABr4397SZw5fmqrTr7xEYJsJS0VrmK+yKCMF69He7RPqr9derVx0FqUOdc+xGz8D2/xhNLKu2MDPM66JPJpkgqxiIMkoWeVXKo8hWaNmD7HSLkkCRZonTPvlCxPcpU3Rtx4PE799bswqgpykQLKQdJdm0U4RxC33Ux2rgZd7pGc5rn5Xb81wdtpC78qjCN/rCFLXsUsfcT+7Par0t/ZKhgpLV6o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jason Angelov <jasonangelov@ucla.edu>

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
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 57 +++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 68591ca99a4f7..af26b3d60957b 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1341,6 +1341,62 @@ static void damon_test_commit_ctx(struct kunit *test)
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
@@ -1667,6 +1723,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damos_test_commit_migrate_hot),
 	KUNIT_CASE(damon_test_commit_target_regions),
 	KUNIT_CASE(damon_test_commit_ctx),
+	KUNIT_CASE(damon_test_valid_probe_params),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
 	KUNIT_CASE(damon_test_set_filters_default_reject),
-- 
2.47.3

