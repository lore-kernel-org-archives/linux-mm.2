Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48577C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:03:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 123846B00B3; Wed,  2 Sep 2026 10:03:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A6256B00B5; Wed,  2 Sep 2026 10:03:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF9A76B00B4; Wed,  2 Sep 2026 10:03:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B327F6B00B2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:03:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2A3121C0DFA
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:03:41 +0000 (UTC)
X-FDA: 85168990242.22.409158A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 78E0D14000C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:03:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A8GMKvau;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788357819;
	b=b/hhZepi6ugmFdn3n9e8RDthCQGUrORaG61gZDDuEFuG5Icur+xnvz5LxVkstijNPGUSPZ
	W1gE2ZVH98u+sYGVUarh0MbhXRF05lXEU4FLHkRJccPMHFggpa7+c5n+nkNFoTSMkE4WDP
	NHkv9OlXHN+zTkKFiglO6dct977RRVA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A8GMKvau;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788357819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w+y2YGAE9dCS66KlFXJ1CfqA9PNhGVCbFRiU+z6GWB8=;
	b=fm9fMukfdCJwraKUsepo1utYRuxewzqWtzWc+kjCX5XmlVSrIM+qYG9eljlRPIVS+ng8nj
	4jZrJ3qQReIr335aOycDewl4kCp5yAa55bojpjkbppe3ku95MbqxGyEubggFDwIZVOovCM
	TSzVcU6K80MGHwhQqGQ0HxAf4ATnRWA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AF75E43A64;
	Wed,  2 Sep 2026 14:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0D01F00A3A;
	Wed,  2 Sep 2026 14:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788357818;
	bh=w+y2YGAE9dCS66KlFXJ1CfqA9PNhGVCbFRiU+z6GWB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A8GMKvaur5A0pGiCYcRq25dH9g8ieYXqvdJV7+FJTx227q0RwkObIse7UVbq8E52B
	 wsGio2tAGIeJImnBWe930VkihgttsxasQNoolrwco2tMmdTjC946GflB60YrJOBCJE
	 6PujGNQOkx18GuRX46w9/DdLvFPHwh/AOBM9S1fqD2bJfbICQwJwS58HQ9+Vm4skFW
	 GS+tgCIKssbWirh9QIi/61bIyMrMqCH19z/v7kZTLxTEVEuUjETXoe7HmqtC4JfrEZ
	 a3047oU+oe3oOmxG702GvYLytWS6KCzGCXD2jhOJmpSjWm/j+iXBXDAyXsrZLvlaxZ
	 c9e5sWL6PEXIw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/6] mm/damon/tests/core-kunit: add damon_commit_probes() test
Date: Wed,  2 Sep 2026 07:03:08 -0700
Message-ID: <20260902140313.85983-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902140313.85983-1-sj@kernel.org>
References: <20260902140313.85983-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 78E0D14000C
X-Stat-Signature: uid9gf8dhzfyr4t4k5a6uhm1eg6xgynh
X-HE-Tag: 1788357819-242965
X-HE-Meta: U2FsdGVkX1/7sttGOZw2IxyU1dpQJV6Guyk6cgtcQAeup/yTM10Y9PHhJAftZjIE4lgniXs78Ipo+hxscXU08dxgt3QDHmZP+vocsOM0JbbrzHs6ROc0Djha6zwKkU4/9HD+1tZ7P508vbqc9JsU71DVlIK/XEW2788hRd7axzhZvAezaxxEffpQ4+6o7PLfEZ9cYR9SQXezhYPhab1Sg9iqOVVOJ5sJv+N+Nk4TwXf5/Ked+IG/AZ+prj0Mw7RXLcUtlmAraeNeVh69osoNuNOGlYf4TZGWemWzD18r9KnZ9MnzQ2WMReU6hoACSARdPjRPrPkogf2YpP+3BVEG0/I7EY3BAQe9ua4pVqM/Fkw/yfa0R+910BBrAXEGMmkGJSVkZsKjqlV0m3w7alinXgx5bEimAhlEtHtvvXFi/JqyHwp0MriZzsrtectqRNv7vrMe/hnNLZBAqng8UVlqqGTYpsbEzXGfdh3N7u5ZdVa2LKvZc6vGP6xt6+aiJPtc5l5aHys+0wTk9wNgCo+b52IReYYgBdeddVETJnVkq0lGjChYwu2a2enx6ZJNtzaz6jgKehd3BuDRBgcB34YM2ws90Zbt5A/oQXM2NYSVEflE3aG7XMAuEJqiAshFUyENiR69fN3d4z5JfUaw8KdXRUfgOAQHWwncev4dvuGaXv5SlTabQ01uFXhGhiOKkXgeqDEvT235vHeBBAskGPdEPfJF/F4Z23B2A3bGlTa6q9Y7E0qNe+k5rbDTrG2LiTbX0hXtlqTBeY18jWdFVHQKu2Ef1WqdKT8vYrdQzb0CTjt6Z1UuAvfFhZpqaLRHMdSBlYn6uMgtR5+ip6eCaN/iyNNTdYGyQbXmvaIti2gkPcoLsS3s5cEFEFP3PmwMyZRqKBX2mDDrDrqCmJ/u2Zl+h+RX9E6VmbV2ZB9joWZ/ugmMLldYRtrdIYjNtq/3QtvgL4nC4dc+MINGQupJEEB
 gKQBM+nj
 ppIBdjud/81wr34nTAkFBoih+3tXRQox+pUVrR+mXXaQBl4vgQibhJaoDMdNsf8rZ1+/2yIaWG8FpRpqU7CT9S2HdXIdu70JzAFydUyrcu4Jv/5OvzSGUylCAb4JLX8L3tkoyf4ETJ1oO8vxSs4j36FWoD5kozJXXat5FunNe7QB2FpaiUkNbA+ZHLlbkEvMRrdOidQ6MsM//z56Bp34QnKU9gSG/WW9N7QTCd35Xs3rXm/2qlI8RUqVaqya0PI/OrSoFcRGicC6cdvx3T2RHJZehaPWLNhhblx2V+Tk3RY6JJZ4imyip78Secv2L9/us032x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add kunit test to ensure damon_commit_probes() updates destination DAMON
context with source probes as expected.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 84 +++++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index c2ddef3c76d35..c01e6a75cadc1 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1403,6 +1403,89 @@ static void damon_test_commit_filter(struct kunit *test)
 			});
 }
 
+static struct damon_ctx *damon_test_help_setup_probes(unsigned int weights[],
+		int nr_weights)
+{
+	struct damon_ctx *ctx;
+	struct damon_probe *probe;
+	int i;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		return NULL;
+	for (i = 0; i < nr_weights; i++) {
+		probe = damon_new_probe();
+		if (!probe) {
+			damon_destroy_ctx(ctx);
+			return NULL;
+		}
+		probe->weight = weights[i];
+		damon_add_probe(ctx, probe);
+	}
+	return ctx;
+}
+
+static void damon_test_commit_probes_for(struct kunit *test,
+		unsigned int dst_weights[], int nr_dst_probes,
+		unsigned int src_weights[], int nr_src_probes)
+{
+	struct damon_ctx *dst, *src;
+	int err;
+	struct damon_probe *dst_probe, *src_probe;
+
+	dst = damon_test_help_setup_probes(dst_weights, nr_dst_probes);
+	if (!dst)
+		kunit_skip(test, "dst alloc fail");
+	src = damon_test_help_setup_probes(src_weights, nr_src_probes);
+	if (!src) {
+		damon_destroy_ctx(dst);
+		kunit_skip(test, "src alloc fail");
+	}
+
+	err = damon_commit_probes(dst, src);
+	KUNIT_EXPECT_EQ(test, err, 0);
+	if (err)
+		goto out;
+	nr_dst_probes = 0;
+	damon_for_each_probe(dst_probe, dst)
+		nr_dst_probes++;
+	nr_src_probes = 0;
+	damon_for_each_probe(src_probe, src)
+		nr_src_probes++;
+	KUNIT_EXPECT_EQ(test, nr_dst_probes, nr_src_probes);
+	if (nr_dst_probes != nr_src_probes)
+		goto out;
+	nr_dst_probes = 0;
+	damon_for_each_probe(dst_probe, dst) {
+		src_probe = damon_nth_probe(nr_dst_probes, src);
+		KUNIT_EXPECT_EQ(test, src_probe->weight, dst_probe->weight);
+		nr_dst_probes++;
+	}
+out:
+	damon_destroy_ctx(dst);
+	damon_destroy_ctx(src);
+}
+
+static void damon_test_commit_probes(struct kunit *test)
+{
+	damon_test_commit_probes_for(test,
+			(unsigned int[]){}, 0, (unsigned int[]){}, 0);
+	damon_test_commit_probes_for(test,
+			(unsigned int[]){}, 0, (unsigned int[]){1}, 1);
+	damon_test_commit_probes_for(test,
+			(unsigned int[]){}, 0, (unsigned int[]){1, 2}, 2);
+	damon_test_commit_probes_for(test,
+			(unsigned int[]){1}, 1, (unsigned int[]){2}, 1);
+	damon_test_commit_probes_for(test,
+			(unsigned int[]){1}, 1, (unsigned int[]){2, 3}, 2);
+	damon_test_commit_probes_for(test,
+			(unsigned int[]){2, 3}, 2, (unsigned int[]){1}, 1);
+	damon_test_commit_probes_for(test,
+			(unsigned int[]){2, 3}, 2, (unsigned int[]){}, 0);
+	damon_test_commit_probes_for(test,
+			(unsigned int[]){2}, 1, (unsigned int[]){}, 0);
+}
+
 static void damon_test_commit_ctx(struct kunit *test)
 {
 	struct damon_ctx *src, *dst;
@@ -1811,6 +1894,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damos_test_commit_migrate_hot),
 	KUNIT_CASE(damon_test_commit_target_regions),
 	KUNIT_CASE(damon_test_commit_filter),
+	KUNIT_CASE(damon_test_commit_probes),
 	KUNIT_CASE(damon_test_commit_ctx),
 	KUNIT_CASE(damon_test_valid_probe_params),
 	KUNIT_CASE(damos_test_filter_out),
-- 
2.47.3

