Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A947CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 04:53:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FD276B0098; Thu, 21 May 2026 00:53:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AE3C6B009B; Thu, 21 May 2026 00:53:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F0326B0098; Thu, 21 May 2026 00:53:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 40E436B0098
	for <linux-mm@kvack.org>; Thu, 21 May 2026 00:53:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EBEEBA0510
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:53:08 +0000 (UTC)
X-FDA: 84790207656.04.B48989A
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5C6E21C0006
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:53:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JdSL8oC2;
	spf=pass (imf21.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779339187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+TMZKInof45y0i4jsA/uEMDRZe595ToXMa24DqFXerQ=;
	b=lYOqH4VnK01kp732CF6GsOl0h4KCerx2ZoRBlpPPUSS1j5C4c96sViOZMZxxCZUqbLIfXr
	ZGmYiyAJvdlOe88hXtvoVdYxdeAT6Rms8paEKrpj6lzAsfR+Z0gPkjJDyTAODA4PgpKMS9
	3+eYVcrkYmiOX2Om2BB5mKMhA5xBq6o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JdSL8oC2;
	spf=pass (imf21.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779339187; a=rsa-sha256;
	cv=none;
	b=fs2nWTzS8yhAagOnWdFwtlhSI4GmWVC/K5z/kkwvANDp4uMJ2eDGzZTDA1YQKKdjAVUmc5
	dORi+K2OHhwO7NKx7l7om+QNRL+95Fu5HKNhieWmHrsrwTDhgnaUmKR1rqCqD/tAMC5Ca1
	xs3LM9T5P4jkWKh8XokqvGDUuN4Ekes=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779339185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+TMZKInof45y0i4jsA/uEMDRZe595ToXMa24DqFXerQ=;
	b=JdSL8oC26JhfCkCCLDzXIJ2jl/dNNqteRDB5gXeL3AWCvNAMIEyK/G1dyix+KjY0Lg1CkF
	ki0FsJpjVjXfF4ojbNeIALSxNdTytyEasbe+8MA7g0EQi/1cOh8UnhYqFvs/UM0qlMOIRE
	EmxDuyGyWPLTGvcj30/Y9Wk6pOiUgOo=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: damon@lists.linux.dev
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shu Anzai <shu17az@gmail.com>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm/damon/tests/core-kunit: test split above max_nr_regions/2
Date: Thu, 21 May 2026 12:52:24 +0800
Message-ID: <20260521045236.115749-3-jiayuan.chen@linux.dev>
In-Reply-To: <20260521045236.115749-1-jiayuan.chen@linux.dev>
References: <20260521045236.115749-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: wfsbzzbiepzfa91nw46fofo7z1b5t7qi
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5C6E21C0006
X-HE-Tag: 1779339187-399343
X-HE-Meta: U2FsdGVkX1+VrnUWn3BewvoQl7+gqgd856fieChUt10Img3IueM03sXmEBaaaauroW9qaSJwvJbpq8zK7kUJT9iw08U20nZ2XAU1cUtmrMvZpOPLcDmPbV6e7BUn6VJagI/1U8HfMNbmCHyeZz6b6SVe2IRMPrHxLwBGWHjkhTa5lTzmc0Vow6cxBLMePN76EowtLE5eTTxj6q0Y7wJ+qvUlMxKl0nhMjyaIUM/VBGlnr77FbbOsP7aN47CXAjSWX2RllWRt4UfzbRGz1X0iqqzdc5HoKPQc66hNQgR8Ug9JtkEGxRRWUi86sRll5fVV6NcSpG+yrNaHeloSqDeWcTvKRGY+OIj8liTZNHhzzzIABTUV0AKG+Ue1Pvrde552DEx7ygpPNXLBqXXHYh3uEe3ia3WyLDeMHL6hEqk8kouTG7/WnXjdosje740z6H1aU9UXnGs/I9S5Cdz7zwbYydx3dDAD2esguo6JxvyE3NDflDsATBfUVisV5ahjaURDhsAebOfIwfYNknkGDdP0s2W2irLHiPPI1Bw8ao9w158tF82/3S4BYCxAs8MQn8LeyTkSFX+m9Gdb4VIjP/6j/LWi35T6LV14niga06xcqU5iIiwJKbTHW04yeNHIxrez4Aj9youNdnQXtMbCBNI0winadJhKNCP6ZWiy1l3Dz/rRuBzWPTghjUJL8SBIS6krqA+TFufpa+WeGT3u0rK3zKyvAJ23TuLBJ6XIIXd7xKnPvu70OWD0dcc17zCxII7uJYBDeGJ3ZL7zyyxKyQaDeak2XY8P/3/9pOm/wPNZO/lxYf5rvhGk3lD0moZ+/L2iWdv0PS4TDZJLFAGm3ubmJp0WfaXLSHic1w63Prh4z3O+ZWUlWRaEsY2gQATMHNfG7SaBJyws7QADAx0n5Xoea69ycE5W/hewsyNRds69Ct7hvzpziNKaJC9e/GZLQjSzF1TP85W76Rh/SFUYtHF
 lVNcjhJi
 88ZVoYsomf0pHJ48vasgL5uDFIx0e08IX79zjmXNpY3u0Gxu5kvkNMsEgoGjvqMB3csfARYuysxUAOD5uVi+Hgo9cJQMaeVqOhWMo2h6RylPXdr+iQSBFD1o6Ct1Ptp3/uJU1CDeZEklt2hsAdov+2W9dpTaePAX6K3R2bC5I7qzQ6jmxSqHAkaWNgLN1dmWDjWBvNQ4/b59Kz2A0PilEtTXMnlbYWM43nkOB81qDBD/J23R9hPDV/kqzX2pb0D4w08eoT/O0gfz75oz2kdvQocyErP8MW98i0FbTN91ZCBf7khJOoQ2X9u3ZxdUC8VNDKyOzPnsGe4Misd7xq3c3pC4KTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

Add a test that exercises kdamond_split_regions() when the total
region count is already above max_nr_regions / 2, asserting that the
function can still produce new regions and does not overshoot the
limit.

All tests pass:
  damon: pass:29 fail:0 skip:0 total:29
  Totals: pass:29 fail:0 skip:0 total:29

Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 mm/damon/tests/core-kunit.h | 70 +++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 1cfb8c176b87..6b2439670049 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -339,6 +339,75 @@ static void damon_test_split_regions_of(struct kunit *test)
 	damon_destroy_ctx(c);
 }
 
+/*
+ * kdamond_split_regions() must still be able to make progress when the
+ * total region count is above max_nr_regions / 2, as long as there is
+ * unused budget and at least one region whose access pattern has just
+ * changed.
+ */
+static void damon_test_split_above_half_progresses(struct kunit *test)
+{
+	struct damon_ctx *c;
+	struct damon_target *t;
+	struct damon_region *r, *big;
+	unsigned long start;
+	unsigned int nr_before, nr_after, i;
+	const unsigned int nr_small = 799;
+	const unsigned long small_sz = 10;
+	const unsigned long big_sz = 1000000;
+
+	c = damon_new_ctx();
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+
+	c->attrs.min_nr_regions = 10;
+	c->attrs.max_nr_regions = 1500;
+
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "target alloc fail");
+	}
+
+	for (i = 0; i < nr_small; i++) {
+		start = i * small_sz;
+		r = damon_new_region(start, start + small_sz);
+		if (!r) {
+			damon_free_target(t);
+			damon_destroy_ctx(c);
+			kunit_skip(test, "region alloc fail");
+		}
+		r->nr_accesses = (i & 1) ? 0 : 100;
+		r->age = 5;
+		damon_add_region(r, t);
+	}
+
+	start = nr_small * small_sz;
+	big = damon_new_region(start, start + big_sz);
+	if (!big) {
+		damon_free_target(t);
+		damon_destroy_ctx(c);
+		kunit_skip(test, "big region alloc fail");
+	}
+	big->nr_accesses = 50;
+	damon_add_region(big, t);
+
+	damon_add_target(c, t);
+
+	nr_before = damon_nr_regions(t);
+	KUNIT_EXPECT_GT(test, (unsigned long)nr_before,
+			c->attrs.max_nr_regions / 2);
+
+	kdamond_split_regions(c);
+
+	nr_after = damon_nr_regions(t);
+	KUNIT_EXPECT_GT(test, nr_after, nr_before);
+	KUNIT_EXPECT_LE(test, (unsigned long)nr_after,
+			c->attrs.max_nr_regions);
+
+	damon_destroy_ctx(c);
+}
+
 static void damon_test_ops_registration(struct kunit *test)
 {
 	struct damon_ctx *c = damon_new_ctx();
@@ -1468,6 +1537,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_merge_two),
 	KUNIT_CASE(damon_test_merge_regions_of),
 	KUNIT_CASE(damon_test_split_regions_of),
+	KUNIT_CASE(damon_test_split_above_half_progresses),
 	KUNIT_CASE(damon_test_ops_registration),
 	KUNIT_CASE(damon_test_set_regions),
 	KUNIT_CASE(damon_test_nr_accesses_to_accesses_bp),
-- 
2.43.0


