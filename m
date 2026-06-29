Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ED7AC43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:56:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30BCF6B0123; Mon, 29 Jun 2026 10:56:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 295566B0125; Mon, 29 Jun 2026 10:56:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E8AB6B0126; Mon, 29 Jun 2026 10:56:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF6736B0123
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:56:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 65F888B55E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:56:42 +0000 (UTC)
X-FDA: 84933251844.23.4D108A8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id CA158140006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:56:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E0p6niVz;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782745000;
	b=fzqlA2xccirm24O9spVWnlPMMXOY0Oh2IFIGw8vUlMyfkGlylMtNouhkIEF4ixZpo3+gGh
	L1J7e47eOq6n/z04tAiFuwDRR0gVhH+6FoxDcwG6fYB6QiDwaFlFxNrbAgfC9aAF5+a3ze
	mqsEDa2o3aM5Jb/LTm0ynMxLBK304jw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782745000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bnTE7JQYb8oLGzV0AMcpP4t+f6X2wdwYV6UVz9FcFq4=;
	b=K50kQme5JKJwtBR6jWF4Um5nWVcg4IhKz9VL6tZU55DelOlir7LOX9F7W+4lbBKDtf/h14
	IjnkxtEAsYGUqu4NIk/czsE5CMWyg7ZmvyuVcb7UV1/YqoRgU1yR+6cxULpCfYsgNIu/TV
	DeWyZELbdMGHDkyFl8Z53l+YlMRaoTQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E0p6niVz;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5AA79600AF;
	Mon, 29 Jun 2026 14:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7609C1F000E9;
	Mon, 29 Jun 2026 14:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782745000;
	bh=bnTE7JQYb8oLGzV0AMcpP4t+f6X2wdwYV6UVz9FcFq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E0p6niVzr944xjRtcTil+YADxceiaUiz4FBwNlSoB7Ex0G3NTNBcEjrYvdTGRt4Ls
	 uWkiw1JTnBONqF5l7A/3dvoj4mkhSu84SD34HsO7sEH7ZeSOdzIe7/lgx1L5PGUiEF
	 9Pa9wBg9EcNqEVmm8RaCGn4DkMiCT1j04GP/CLyhf6Y/tBSrMZWnBZ4jqpbFu/OZoC
	 CRGvy6gXw57/KZQmeL5WxsHUTm6JBNpEuiiT7vOodDNOaXJ39bswS4/wVT0hjG181w
	 QLpKD+1whJuDdf+ppU05DKe09W7HF1OsEzPmbtTXcDGDjlyfDhRr6LlxieSx03431u
	 99aCdy/+V42WA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	SJ Park <sj@kernel.org>,
	Shu Anzai <shu17az@gmail.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 2/2] mm/damon/tests/core-kunit: test split above max_nr_regions/2
Date: Mon, 29 Jun 2026 07:56:29 -0700
Message-ID: <20260629145630.134891-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629145630.134891-1-sj@kernel.org>
References: <20260629145630.134891-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CA158140006
X-Stat-Signature: wi8kp6hqzhwtd4ij1oozorfcrx4oknqy
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782745000-841233
X-HE-Meta: U2FsdGVkX18geoyffWUBEK8nEPEp7qId0oW7QOFEttVAI9ndzN64wlrYlgTLAXrtaE7uBuUEZqtJ7ZWYQ7NYl8WEGCHGo9vKLMHD/c8YUTWhwVKVA2bSkPYlggjANeVbonZ6xKMn2fQTUpmfVNDns5I8LioiokTZZfCZ0vDkHB6rOrFU6NfeuBaNNwc8msricd1gaogp95aPBHDNI/wtd0ikw67IbOcs9DGdw1DGSBnQjBiCvzGlJ6cduPKWjigO7aitSmoiyKZT525AQpRM0v1LAQXZ9pIgokGEdaIJwRGUhFQivFboxaHsTuSKkje8fVMjxQmHABnvxN/G7aLSX/kdo79Or9GX3if/g8ol6eL3r9Fm4PqnvhsAw+0J3+lt9JubbSGj/0bPielLUt1UJ/USmRrN2XstahBfYxtUEWusJiF6BBZf/ZxRTq7Aa7JRKyfDb7apUrC2hwNt5QJBeR5XcRqBKqFcqkz+PHfPlSrkJI906KLYpazMD/Km5gpoBhgSkmFxAMJHosPitJ1DjFWSOgi7QJGkA250ibTtykVyuyD1llYGVjhqi/dvQOnToF34IjqApnii9VT+XjgDOV7FghzJkVMGKIXniXapLeRO93R9MF7xN+Bb7ZQwWNLX8oSK2D8EHQFWc97ccddh7/H5yq18Hdt2lWVIkbZAtBP4TyKQsZ4eOdquBAWV7QRFhhUe5DWcNMNwI1uxEAauGIKa5BL7EjBypzUv+9UcHLsoqxmA543kAMKne7lNhye1sQrNswATsI7sVyD+mmLMn4p9hZbRWjdZZnTFN6ertfb7GKRQkJm+TSxOSGbdMqfWUAdqeToPmhCMG2i/BfBk+aAGRh3Z6PGZYLT7NZkAALqaPA+Io8I11BtX1tbkWkjtIDEEtDwWKhMNhE1KSNIwh7JAHNIh5g4yKzTxgJH6NXEvQfWYOzNEfe7E4YKl+NLdAPq4Ad77d4Wef4NAlJ/
 EmzDfKKA
 9PwtAIGzXafwxqOpKzfNLHEmVUcU+U/hl85kWihLwJ7gVg2rPYenZNGoewYqkXv0hT8DM9GfCkRmTFlagg1Ru83uwz6WOEkIRF8Da0NVEVK+b6uc2+WnSoG65jQJp+LT0DM7uo/7cAo/q8X6FIv+ZSRBVT+HMBANAKKzzLQdKHCysJMJqrxwxgUFIQqmq+gkMMss8NBQBK/Mq8kPbCd7S97h/AYkaL4CqydwKZCptGqi50zQg/Ri+SCk427el9ClttzWJU6TbWT4b35kHAFNc4g6cPKb64EJzhJXHMPDwXnuSCr9fEiv3scSLpUEf8ep5MWncXFdvu5agfUNpnNYN4CV6L9Qtzei8VaHkkHZMSc80SvugbOd2LfzPTEBJAx9hwGv+cwZKL979VEv0Lo/ScNZeskMtRSnjyjTt5B/lj4t83Dc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

Add a test that exercises kdamond_split_regions() when the total
region count is already above max_nr_regions / 2, asserting that the
function still splits a fraction of the regions (makes progress) and
does not overshoot max_nr_regions.

The region size and min_region_sz are picked so the split arithmetic
does not depend on the page size.

All tests pass:
  damon: pass:31 fail:0 skip:0 total:31
  Totals: pass:31 fail:0 skip:0 total:31

Link: https://lore.kernel.org/20260626085851.70754-3-jiayuan.chen@linux.dev
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Shu Anzai <shu17az@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 64 +++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index c5f5124c3d1f4..a00168730445d 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -335,6 +335,69 @@ static void damon_test_split_regions_of(struct kunit *test)
 	damon_destroy_ctx(c);
 }
 
+/*
+ * When the total region count is already above max_nr_regions / 2,
+ * kdamond_split_regions() must keep refining the resolution by splitting a
+ * fraction of the regions (making progress), without exceeding
+ * max_nr_regions.
+ */
+static void damon_test_split_above_half_progresses(struct kunit *test)
+{
+	struct damon_ctx *c;
+	struct damon_target *t;
+	struct damon_region *r;
+	unsigned long start;
+	unsigned int nr_before, nr_after, i;
+	const unsigned int nr_init = 760;
+	const unsigned long region_sz = 100;
+
+	c = damon_new_ctx();
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
+
+	/* Keep the split arithmetic independent of the page size */
+	c->min_region_sz = 1;
+	c->attrs.min_nr_regions = 10;
+	c->attrs.max_nr_regions = 1500;
+
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "target alloc fail");
+	}
+
+	for (i = 0; i < nr_init; i++) {
+		start = i * region_sz;
+		r = damon_new_region(start, start + region_sz);
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
+	damon_add_target(c, t);
+
+	nr_before = damon_nr_regions(t);
+	/* Above max_nr_regions / 2, so the blanket-split path is skipped */
+	KUNIT_EXPECT_GT(test, (unsigned long)nr_before,
+			c->attrs.max_nr_regions / 2);
+
+	kdamond_split_regions(c);
+
+	nr_after = damon_nr_regions(t);
+	/* Still made progress ... */
+	KUNIT_EXPECT_GT(test, nr_after, nr_before);
+	/* ... but did not overshoot the configured maximum */
+	KUNIT_EXPECT_LE(test, (unsigned long)nr_after,
+			c->attrs.max_nr_regions);
+
+	damon_destroy_ctx(c);
+}
+
 static void damon_test_ops_registration(struct kunit *test)
 {
 	struct damon_ctx *c = damon_new_ctx();
@@ -1491,6 +1554,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_merge_two),
 	KUNIT_CASE(damon_test_merge_regions_of),
 	KUNIT_CASE(damon_test_split_regions_of),
+	KUNIT_CASE(damon_test_split_above_half_progresses),
 	KUNIT_CASE(damon_test_ops_registration),
 	KUNIT_CASE(damon_test_set_regions),
 	KUNIT_CASE(damon_test_nr_accesses_to_accesses_bp),
-- 
2.47.3

