Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40CA1CA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 06:52:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C5736B0095; Tue,  6 Oct 2026 02:52:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59D046B0096; Tue,  6 Oct 2026 02:52:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B2D36B0098; Tue,  6 Oct 2026 02:52:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 204216B0095
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 02:52:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 31FE61C3705
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:52:25 +0000 (UTC)
X-FDA: 85291282650.10.A7A02A9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9787FC0004
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:52:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XLYKtt2o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791269543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oPGhPEdn4k02nRhaGV+54+OxW9Un+YDg3dsLDCMry2s=;
	b=x9G+mcqAdzJH7G2DHz5I4e5axYBYLC952Kd3v7izWiPmpIAuIiLIPPNG468uGyCKs82YZF
	zILIPxx3OBrCi4wLfkjeocbbhfUZT0+Pev+T5oCestYTv+IrUbQoscJndvzWGj/Q0MQ9yI
	MKjZB5Jl7dEKp0q5cqEVh5amg05zQ70=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XLYKtt2o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791269543;
	b=yKVQppZy9dthTEpbZJEHvm++/RhT4RNcD1yvnIDkuSiKC/jS/aZb6eAAxtFgixLD6DFq9j
	MA4m7HkNKeWegrl5+3tOraCQ79xFFi8MkF57A1ykkJr+a0G3xbGA26CPFZXq0Kccn27Omm
	MNEyYN+tBuWKZfiTz2NG+fStt2MGSUs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 344A3601F1;
	Tue,  6 Oct 2026 06:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7356E1F00898;
	Tue,  6 Oct 2026 06:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791269542;
	bh=oPGhPEdn4k02nRhaGV+54+OxW9Un+YDg3dsLDCMry2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XLYKtt2oNmQNaZG3Zsk4SNTtQhqBFDGvvm7AVt8J427Ty4skLLe1nE7LoVfTAbt+F
	 T3ST74NAWPg3JbcNvLOZSOzVUn+YdxInLCPL9CkDpie8PvhCQDoroOhdjZgn2CPVBW
	 ux7IhrdwsQG3Rzr8lgw5IjVfnICQRjPiU46i1a59XEe8jPYAjHTNbPMqQkQoLqDMIt
	 1ewq/VMcGJwym2/pZ1TVpFnozve+g4JYqK1LpIyEm6MK2zAwnRfG4ze+Hot/ls/Vrt
	 hgUzDMU3SdBUv2c04KQeU0eFEcPnthNITOjOcwN/t5rG253JREwkbNQ28t1dsmDx5P
	 QFaLqqMZhMlRw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/3] mm/damon/tests/core-kunit: add test for unconditionally skipping the last region
Date: Mon,  5 Oct 2026 23:52:07 -0700
Message-ID: <20261006065209.41507-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261006065209.41507-1-sj@kernel.org>
References: <20261006065209.41507-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ehrofjn7mbqah94ghz189mw7g4uyp179
X-Rspam-User: 
X-Rspamd-Queue-Id: 9787FC0004
X-Rspamd-Server: rspam08
X-HE-Tag: 1791269543-18120
X-HE-Meta: U2FsdGVkX1/qQ4B7IuWtqWkBHz7C17D1GTw5u1LcEVGCePpu1xHLl3I6FfcTc2jhnKDLVB/pnTI4yBSxBkpQ5KRKHEY0ZS0VXXNmkW6uJO7h4jQm7eR0FyBdX2Ckx762Q2MGofXZSKX6iB+qtvswdM+4T4xvvH/DTbQSN2IZYH1IDDvAMClILkOAY57PZJwJfGnu7E7ndS/JRF4Hp9nP5KQl9Q7X2BUPp+OLUU7VMj6XcJFKDs1Ut9Gk6QKKOa2Qw6TxfzX0zaOfmtWwcsjTklpYrNfgZf5QhzPTm7a2ILj3Gi7I/FKGtsPihda5LNv5bnY+nzyLwAQ9Ig03LCVWtQ6ttd/j5uPqqkOqa9tAX1pbQQmiwsi2M0+h+88hR2AHQtbcxph8Vri9U8BFIFOlnIz6gtBpHB7n5NTQQwvqvx5C9vnLkrM9LSB+Klhpk+FKpAe7ez8VQo3YXfqkbN/rWdFq4MmwYSO2AlG6GEoy/NWWxFsemAdw3giyhiG2LFN1SGA6X9s2X6TACcqETTR9SXsvbtuqd5gT28zBhx+K/fif/NAwppfRoBmy6ztIaOH6AVL235Za64P+zhtKAVj1tOY2ipePfQ3JvKdYASFugZItfNgXYviI/IL4bYbL42rB9EcAXeJRw+Xdk0m8Ig7wfRDbVjCHlw7vEzJ2CG0+LYf31SaQuIUHubh/9lygHjR4bDxUb76Pm36/wgUV7fiAJcJ5agweBn+mWvbnXO1RpzNuS6qMn9e4h+M9Rri81E7Gubq8rzt3QoQQY04Pwun77h3TxoQclqyrnrDYWB6zgHN/vBMT91S3FFROxV+f+RFRia8qwJ8f7/9bWcPoSJQ67VDWXVCaJ3oS/OY53TxQyjdhSi9EtqgXmzoWbyeJczaB37EJuuYbmmD1Cn4PmdkTdtXu+qDRY2Mmuxpf1SD+rKzA+YnIifMt1ZAKwx2j9GCmL2n+3tUNS9OViFHD4DK
 93xJdLfa
 bZTcd7Dl2+Y9krmVY3v76rbgINzgJJ7R4ZWkzPjJBXumJmxATr2ylH/9WJNDThWz4pJsmZjeJQ1UdQex6sPTD2decuX8IHBmmgIEBMQ1b55WuwjyUuqPY5a96oCNUmkj878y4wSBN4r6h/Eqen+NaTHuxUARAisRHgJK6R0PLM+Ev52XnpcN/wj7aa1W5/2U6FXIFIVXtcTDczvoUxyHNayZ/vK07cgAJ04ns8Gdn1qtgPtaGFIAi8lj4NNy8cas+s09q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Liew Rui Yan <aethernet65535@gmail.com>

Commit b3723b596b54 ("mm/damon/core: fix unconditionally skip last
region") fixed a minor bug.

Add a KUnit test case to cover this behavior and prevent regressions in
the future.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v3
- v3: https://lore.kernel.org/20260927175159.60703-1-aethernet65535@gmail.com
- Collect R-b: from SJ.
- Rebase to the latest mm-new.
Changes from v2:
- v2: https://lore.kernel.org/damon/20260925045350.66595-1-aethernet65535@gmail.com
- Change the commit message, mention the fix rather than the original
  bug.
Changes from v1 RESEND:
- v1 RESEND: https://lore.kernel.org/damon/20260919080453.628679-1-aethernet65535@gmail.com
- Drop braces for single line, as suggested [1] in coding-style.
- Set min_region_sz initial value to power-of-2 value, '1'.
Changes from v1:
- v1: https://lore.kernel.org/damon/20260831113735.3349-1-aethernet65535@gmail.com
- Resend since the dependent patch is merged into mm-new, that would
  help us getting AI review help.

 mm/damon/tests/core-kunit.h | 42 +++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index ef146ca2ae8a..3fbb4e4e36fa 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -2439,6 +2439,47 @@ static void damos_test_esz_goal_temporal(struct kunit *test)
 	damon_destroy_ctx(ctx);
 }
 
+static void damon_test_last_region_quota_reset(struct kunit *test)
+{
+	struct damos s = {0};
+	struct damon_target *t;
+	struct damon_region *r1, *r2;
+	unsigned long min_region_sz = 1;
+	bool skipped;
+
+	t = damon_new_target();
+	if (!t)
+		kunit_skip(test, "target alloc fail");
+
+	r1 = damon_new_region(0, 100);
+	if (!r1) {
+		damon_free_target(t);
+		kunit_skip(test, "region 1 alloc fail");
+	}
+	damon_add_region(r1, t);
+
+	r2 = damon_new_region(100, 200);
+	if (!r2) {
+		damon_free_target(t);
+		kunit_skip(test, "region 2 alloc fail");
+	}
+	damon_add_region(r2, t);
+
+	s.quota.charge_target_from = t;
+	s.quota.charge_addr_from = r1->ar.end;
+
+	skipped = damos_skip_charged_region(t, r2, &s, min_region_sz);
+
+	/* 'r2' is not processed, it should not skip */
+	KUNIT_EXPECT_EQ(test, skipped, false);
+
+	/* 'r2' is last region, it should reset charge_{target,addr}_from */
+	KUNIT_EXPECT_PTR_EQ(test, s.quota.charge_target_from, NULL);
+	KUNIT_EXPECT_EQ(test, s.quota.charge_addr_from, 0);
+
+	damon_free_target(t);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -2482,6 +2523,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_walk_control_obsolete),
 	KUNIT_CASE(damon_test_rand),
 	KUNIT_CASE(damos_test_esz_goal_temporal),
+	KUNIT_CASE(damon_test_last_region_quota_reset),
 	{},
 };
 
-- 
2.47.3

