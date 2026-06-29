Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F8EBC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:56:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBBB26B011E; Mon, 29 Jun 2026 10:55:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1DFA6B0121; Mon, 29 Jun 2026 10:55:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0C4F6B0122; Mon, 29 Jun 2026 10:55:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 684086B011E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:55:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB6E112016B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:55:48 +0000 (UTC)
X-FDA: 84933249576.23.6D9A995
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 25EE9100006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:55:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V5qQPFvO;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744947;
	b=Jbqn+sp4hIIZvW2JsRgjHbWjno4JWWiUT/h1FzR+u6GGpi70OfPLtoJ1rskPUs2cQKnKc8
	XjU0eHKqojuntsN1ll4S2/ODRfMgKatXaHMgGD9YXYwQ+AHzfJmjKCl77k/mYRtebpx7vd
	NTUKR5r5x4qSSLsTkElJwgTBz6eIEsM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YEMOORj6+k+v752vYE0fvW8oE/gyV10AxdEBNRJjrnM=;
	b=NQ+r6xvtkJgxpme7uGl5jaaxSyRqm3L+Nu4uodt4pVCLymhQi6FWk/p63g6y+I7nZxJ0se
	AxxDdKV8CZTzhtI2Zhtc/WCeNVS/YglfHjdA9zQ6zLtaFE0/49qQZY87YPtZSMwtB2v2bm
	M41tB4ucn7YdR0jdmHlejvKXSRS/cHM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V5qQPFvO;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AC5BF601C2;
	Mon, 29 Jun 2026 14:55:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F961F00A3E;
	Mon, 29 Jun 2026 14:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782744946;
	bh=YEMOORj6+k+v752vYE0fvW8oE/gyV10AxdEBNRJjrnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V5qQPFvOwWuoHblsWDCUSPcMaUkfQr0s673YQXPIpHGuxpWZJzMj2fGfNmEgQUS8T
	 mcPlhF+P8MqFhjMeAxmUor3NAuTDNdUB7Mv6SCedZ8pTsScwx5+7h99ZZlZwUxJ3xm
	 HGd2KiTTD5rdSSHQa/MuyUs8eMd6fDyTHqE7GL5D/K14xl+7SHetvbuYeKh5ZoJ0yS
	 o9q3oluA3W8T/ZCgLcWeUcabzeCPVhl4NAfATyKlam+pwiYG0eX87W3wdxl0ODQ0CR
	 AS3LydIvR9iIMB7pVG1rErUeAFNlsQjYydbXZrELnWnhiRZt2knJOPYkJOtpXpZBhv
	 tyJlYUwHs0b0w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/5] mm/damon/tests/core-kunit: add KUnit test for walk_control_obsolete behavior
Date: Mon, 29 Jun 2026 07:55:36 -0700
Message-ID: <20260629145538.134832-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629145538.134832-1-sj@kernel.org>
References: <20260629145538.134832-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: z41fbsrnzwu6gnpoy8j9knfxust85wtn
X-Rspamd-Queue-Id: 25EE9100006
X-Rspamd-Server: rspam06
X-HE-Tag: 1782744946-502687
X-HE-Meta: U2FsdGVkX19Unmk/JFa4gg2ovC6luJnl8xwUTRSQ3pNV+9FtilrcoVAEyVHhUd74jhpuDzGj/PRybPj5v/nZD7xpo7ALeJT+DAqVUL0lBbRVAuLOzJ4UzjL7+xEhu7iykrVwu/EHvw+JmNq9Re0PYfl5A9g7vhEaOZwWRumTUTLE5WctmtsVtY0WyGbl3yFN/HoSIVchyxeEz9laUiyafFvo92PS02Js2L0Xp2P7BPJB4ph192l7H9jDK7j+wq3ZTHfQzTzVqL7OO5sJAATNWzresRaVBVGeWon8nrBIkzh5B2MInQfZmG9XOaZluaDeQKBLeN+KmFmLJ8Xm6Pf0GrrxotEjPmO0cgs9V+f3B7hoUwCTWXvVyDp+U9KWGjg2J10YWx0yX8BGoz1YdT+ougIiljYGRnDNuea6l5CTkqcjC/EOmmMWQbLwebXdacE3b6jAVic8MxxZw/1m70xuDHlvebKpfgQa4worySwLkuEyZGvR/Yl3/ONgBeSZbfHALbwAd85zjSLg6q2MgLL3s5azDVdrCTYlbHTLBq1aofLXb6gWLY4OkxosmAqMGynGET5wpD6x5j0dlG39PtuYwFy6In0xGjOE86iU9OWFM2rXrLHY9s7QwmONYXAtB5lpH2RTkFO5HQLXaroShF1UL8z51eZFJ7l6UQ1VKNnBtK3FbMlgFXMn2pykns0fC1yDFaKLDhfmyuepeXb7OJusZeYSy6FlLTlQr2scg0M05/bung/zgRzdvbBWbhSXGVYLlKomVUXKR1faLHlYTrKI8JfKLpMOaAnybNI6dizto6fwLDotqAHP1ixdZmpHPr+iS8pEy0VS45Ddg7Lapy+QTTyXU3X7fK8lzbT1OidBLkY0baZyDBkrRq/rtgSHuaFYiZP0dhge+EkzJUKJOkxbGYfJ55IFRgvI4SUE0vSFKvU+PB0j3UbfvidXnBPwCJiSMcWz8Cxir7eF6SGEcaR
 heewC6fq
 L6WgJrggsUANnwj3XjrJDJVVPVaNmBv9XaGg6Qj1sea7lQlOCX76QVQVGGLFIBaIs8sRmwOCAXWvD87Mr2rkdzh/6X/22RHo/8G0npjH3/GOKgbfCURdsAQB/TMWU3nTQxwUCCN/NP4W2tT8eVA6cyTkqMf9B+NXSJKu9HR8YADpaWnUI5RF1nOeAjVJfuGwa5cVrBY6c2Xdb7YnQImToD/I6Gd67TtqjdLGnle2bTxte3ub+9uibYHnEsVotB6HcncTIZSiKqPIKu8P0KaSGNJxxwB71S98UMrUo4lo4tRIwwWvE2lnd8JBmv1N8uXnnXT81kKrbGwD4y0HgcNM8HRnwTVxcbcpz8FSlM5WooOUHRG2lQSfPG9mE3NtmiwHMqCgQ4ZkX/p482Xw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>

Add a KUnit test to verify that damos_walk() rejects
new requests when walk_control_obsolete is set.

Commit 33c3f6c2b48c ("mm/damon/core: fix damos_walk() vs
kdamond_fn() exit race") introduced walk_control_obsolete
to prevent a race condition where new requests could be
registered during kdamond shutdown and never handled.

This test simulates the shutdown condition by setting
walk_control_obsolete and verifies that damos_walk()
returns -ECANCELED immediately.

This validates the invariant introduced by the fix and
helps prevent regressions.

Link: https://patch.msgid.link/20260612062337.2459-1-saileshnandanavanam@gmail.com
Suggested-by: SJ Park <sj@kernel.org>
Signed-off-by: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v3
- v3: https://lore.kernel.org/20260612062337.2459-1-saileshnandanavanam@gmail.com
- Collect R-b: from SJ.
- Rebase to latest mm-new.
Changes since v2
- v2: https://lore.kernel.org/20260524100258.36819-1-saileshnandanavanam@gmail.com
- Dropped the userspace selftest approach entirely. SJ tested
  v2 100 times on a kernel with the fix reverted and it always
  passed, confirming the microsecond-wide race window cannot be
  reliably hit from userspace due to syscall overhead.
- Added a KUnit test for damos_walk() + walk_control_obsolete
  instead, as suggested by SJ. This directly sets the
  obsolete flag and verifies damos_walk() returns -ECANCELED
  immediately, without timing dependency.
Changes since v1
- v1: https://lore.kernel.org/20260524091812.35283-1-saileshnandanavanam@gmail.com
- Addressed sashiko bot review comments (execute bit, threading,
  dynamic sysfs path, OSError handling) - superseded by the v3
  approach above.

 mm/damon/tests/core-kunit.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index fcf7c7fadb5fe..c5f5124c3d1f4 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1456,6 +1456,33 @@ static void damon_test_is_last_region(struct kunit *test)
 	damon_free_target(t);
 }
 
+/*
+ * Verify that damos_walk() rejects new requests when
+ * walk_control_obsolete is set.
+ *
+ * This tests the invariant introduced by:
+ * commit 33c3f6c2b48c ("mm/damon/core: fix damos_walk() vs kdamond_fn() exit race")
+ */
+static void damon_test_walk_control_obsolete(struct kunit *test)
+{
+	struct damon_ctx *ctx;
+	struct damos_walk_control control = {};
+	int ret;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc fail");
+
+	/* Simulate shutdown phase */
+	ctx->walk_control_obsolete = true;
+
+	ret = damos_walk(ctx, &control);
+
+	KUNIT_EXPECT_EQ(test, ret, -ECANCELED);
+
+	damon_destroy_ctx(ctx);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -1485,6 +1512,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_set_filters_default_reject),
 	KUNIT_CASE(damon_test_apply_min_nr_regions),
 	KUNIT_CASE(damon_test_is_last_region),
+	KUNIT_CASE(damon_test_walk_control_obsolete),
 	{},
 };
 
-- 
2.47.3

