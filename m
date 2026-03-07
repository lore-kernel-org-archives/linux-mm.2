Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EFB6F55102
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 19:54:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE8CA6B0096; Sat,  7 Mar 2026 14:54:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE8576B0099; Sat,  7 Mar 2026 14:54:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A952F6B0098; Sat,  7 Mar 2026 14:54:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 877B76B0095
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 14:54:10 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3CC6DB6B47
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:54:10 +0000 (UTC)
X-FDA: 84520318260.02.BC94614
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8E892A000A
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:54:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RrDLMqsi;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772913248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PMpIcUPmgfnC/TM7LS/LXJ+r6A6RR2yXFY5S7SCh0uE=;
	b=UNv50WlGDD89GfLONYdxkINdpVSVPxdcRXHTgYjncocuXbh4IVnYSdMm03w5OAOLjycOuC
	lCxO6MwvZBuTeM1xn1aPbUFEsnaroDkym79m+P02G7cKaw9bzd0PFHLkx5OCqVmbxifLl1
	RZ2XNLJZlmnXU4N8j/Wza/HY6VExiBo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772913248; a=rsa-sha256;
	cv=none;
	b=r5YPy2L1Wu1U7s+/mmcqFQpjc9A87HcbxJ2qy0vJja07Abk7o07L/9O1s+REwAL2eqFXOQ
	A42diK0SnmuSbSC2TgonZD5neIswVX3eNcc66CTFUroqmcqZ5LSK+Um8OszhVSOnF5Cjvj
	IIqI0q0ASyw4Ai2EkW08hTjuoZWvZwI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RrDLMqsi;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BE3CB4406A;
	Sat,  7 Mar 2026 19:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C34C2BCB5;
	Sat,  7 Mar 2026 19:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772913247;
	bh=cHAWOwLABE0IuRjMJHLuZg8SBEg0KiVoUUFpxTrX+yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RrDLMqsiYefqJ5d79fNnxVvcFSYtuDfZZZJ97LGdVq7EFv41zDhGggdm3+UyaSmxr
	 PBOMZmxL2uVBPb9W16T3rkDri/sWtMjBRNITE3W2ZsiJpLLS3WMUrpNyhul7/r/AE5
	 ay6amn/VCsmnX1P3MXuSqH5Rhx505HaS2zABmsFN5D/kI5qMV7eGaYykqHmMfDZXqJ
	 QzvGJFIN8DPHltAzVH62R2ibPehalNvmhc0V1L0pMKoMp8545eqMXpi4tSfkUKKjom
	 mYo3L9c9Cpa02jP3NA/ssCK+or5eNXff2jYOyqPJ1vSCywS81h2qvbpfjXt8i5xyl3
	 5yE9/efUJBP1Q==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/7] mm/damon/tests/core-kunit: add a test for damon_is_last_region()
Date: Sat,  7 Mar 2026 11:53:50 -0800
Message-ID: <20260307195356.203753-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260307195356.203753-1-sj@kernel.org>
References: <20260307195356.203753-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8E892A000A
X-Stat-Signature: 5smarq84zgw5qneeg87edjruuox43nut
X-HE-Tag: 1772913248-34600
X-HE-Meta: U2FsdGVkX18vfaohGw2o/+T685F8n9DMiGnSCAhmnmSZDeXIiehPABDmQoqhlpn8P818OApAkpf7NtoOCLd6FmOwxuIFHj6c298I1nBAqfHsb8chpbG6xS2E4JUiOOOyvzhJk0O0v866P8i6ekpp3XXlxpTTCoD/QspEdevys/ngdsrVSmnuHlUKWAkDN0b55ig00GEHMwpbVAPvmAW8sg0yFY3TMG61ILMrcnj4X2nPlDUpbr1D0y/z7v9FUm+hg5P4V1ziypEGLirg/rq87AWJU+z+4tPHubTEGKugYnLQAbHS9b/uPPWzUshajuAa/BEtJmC2MB2Cc6V/gWrWm3MBYjox2S8kFCUCHZQeGITOVz/dUzn3d3orpCLIto68zjxAQMi2WaSi4XlHBEr+1tSIt2fFvjOriJT60ojJymp7l1gJCwDd3X82A4iVW1DTeNwEpZXLPYfmYQnCdl2QvLTtuRX8I3YZI3kswvdCcOigbzQtAmVw3vqzQh65P2YnuU3Bea6MC+9OouZ4XQOuxA+qu5SCMC+xPxQ/Upe4GZi0p8/UnVDSrHMMu6oPGil8ogAmXtvmFyQpWCuLEghExezwvT6iIp5bvOVr+zP8/5feC/5Empusr/1M4nxp3tdLWoqqpOvf6tXzlCMI3ZiXLcRHu3i0liVloeKjmZQ878CxaUPLmTmYjenLNAda8JlOzhqJwHx+rjFss6pn8QnsKdxWIKl1K++6uaNKgtyZfm5y2UXghFbIPD/Q6blcWBqDHnRQm2xTEX7k3iL7qTZvRdPpRJIJMArURx5q1ZXz3LD09KjWphDqN5r+Ff1rgkutNIHuy4NFxgUXlGJMyd5mLG70dS0L/lRQSeb9EuE9QsEKsxMUPYhfRlfSgU2PPP1lN/lt8kQEGVcgBBymX3iaCvV/kk5+G+rmEj9bH4kS2e7IckBlt/lr7Z53GT3YaeFadiurB1j2LJcmqcr2vAR
 mvbETV4Q
 y0w8mvHofgyO6WxnOpDryAawuRdp+pMdhDQkSMSKws8mZuovzi2Nam/6JEkaFVq7Ut4ilgkntGVWOMvD574I1fzFUANAIIXWYx1sXgqhYUn9AYh46Zhz/Nm9Aioz8Rw5rvUy55KtCkioyHDPBuFvl/PJydX6gZ6rQCP7BhPm00GzT+8LRnGkofATYwgYrfEPNGdQ34yJvfK/US2C0fbG8T/7nRigxv/NfoHorIJNUFyVARXXeo3U5AvQ0kPI2kfrm/gdP7NVNg+Ts/kTTeGHM3awCug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There was a bug [1] in damon_is_last_region().  Add a kunit test to not
reintroduce the bug.

[1] https://lore.kernel.org/20260114152049.99727-1-sj@kernel.org/

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 2289f9e4610c0..e86d4f4fe261a 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1311,6 +1311,28 @@ static void damon_test_apply_min_nr_regions(struct kunit *test)
 	damon_test_apply_min_nr_regions_for(test, 10, 2, 10, 2, 5);
 }
 
+static void damon_test_is_last_region(struct kunit *test)
+{
+	struct damon_region *r;
+	struct damon_target *t;
+	int i;
+
+	t = damon_new_target();
+	if (!t)
+		kunit_skip(test, "target alloc fail\n");
+
+	for (i = 0; i < 4; i++) {
+		r = damon_new_region(i * 2, (i + 1) * 2);
+		if (!r) {
+			damon_free_target(t);
+			kunit_skip(test, "region alloc %d fail\n", i);
+		}
+		damon_add_region(r, t);
+		KUNIT_EXPECT_TRUE(test, damon_is_last_region(r, t));
+	}
+	damon_free_target(t);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -1339,6 +1361,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_feed_loop_next_input),
 	KUNIT_CASE(damon_test_set_filters_default_reject),
 	KUNIT_CASE(damon_test_apply_min_nr_regions),
+	KUNIT_CASE(damon_test_is_last_region),
 	{},
 };
 
-- 
2.47.3

