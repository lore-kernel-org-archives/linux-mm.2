Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77A55606A8B8
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 22:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kd6C8JiL
Received: by kanga.kvack.org (Postfix)
	id 30FB76B05B1; Sun, 15 Nov 2026 17:34:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2420A6B05B2; Sun, 15 Nov 2026 17:34:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BAF66B05B3; Sun, 15 Nov 2026 17:34:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C9D026B05B0
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 17:34:48 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4C71F40881
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:34:48 +0000 (UTC)
X-FDA: 85438809456.01.358308E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 273CF160002
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:34:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kd6C8JiL;
	spf=pass (imf08.hostedemail.com: domain of devnull+alireza.asgari.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+alireza.asgari.net@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794782086;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=inUC0SkyqCWXT74KU7Ifm0uEpFiY4HdTsNKZBYvwNYA=;
	b=1RZYIJbWBewNlfJTDsJ59NDuVrEwy0dF9JjBBlC35g83IPs8WWqsLYN4JG7Gh2+87ReCMx
	mO58cyZ4CrVfOs1M9nEKwKsOvUVZZhETjSV+rTDbTUAK6Opz7lp830QM7dRShr7XzXi5EP
	utOTEVi1yQl1H+0e8/jeIlzuQsDt/q4=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kd6C8JiL;
	spf=pass (imf08.hostedemail.com: domain of devnull+alireza.asgari.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+alireza.asgari.net@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794782086;
	b=PVG79NmTOA4Ldwi8SzlFmmfK3RP8feAJLTtE7He8BpmiZoiSEqUEMNBn+Xlwe3YYRq2i+/
	l0St/f3KroI8XcIbFH5TqFsTwdeZl8M1rfL8k2kIzZRSMtOcqAWz6jXyGMNttFp62s3RWL
	7W/Y9ZvhqIXAKQCq1UXMm/d2xBECElY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7670345A06;
	Sun, 15 Nov 2026 22:34:45 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794782085;
	b=ZTaNg5ObAEkXF1v2+25qroM6TeDPPsxgdb9CTnNPbNWdXvnGui2mboTNoRD51w69whQS
	 4fJU6BmW7fqdcGAyiM7VUFWgMDclY+vaoB7NDvCb2VzHUSmoWzgpQtJTCV1TGSMSC9HHI
	 PpUrf8H7KUi8C/G9EsCTXqyzj5Y2ypXQt7Gk2vtZuWNX8upin2yMQw4kWC1kE9GEI3wyL
	 Kv0nkHmQW9c8l3xPDJ0yq4XjxBvuADwcos3D9xOy0o9J37HTpcV61c7KDw3+8MtBnx8oi
	 GYj6lGhGxMKYN2SXnXUwDEVfEqrEbnqYLwrUkyjwLpH4B4fJSqTgOsyAgLOIQ1EGoFA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794782085;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=inUC0SkyqCWXT74KU7Ifm0uEpFiY4HdTsNKZBYvwNYA=;
	b=T+WVf8CUc8eIU507U8O1yfZn+MUCg2AHDzz2mAe/GAAHlQX18c8bMv6q4v+er4XzP0sN
	 TL+oVQ2DbmIrnW/R3mAQlvtx5RYUrighQjv6lrdAdqzqidOiZrm8u7oMu/u8U6MeuZnCx
	 09of/28g1TJvibUlQ6zABMFRSUxWJ/aBKA7ahjUWK1rzNpCPBT9P3+DwXtmp6nqN0cUWP
	 +XFf82d0tnX8S40xqnj2afNkcwV6m61T0qZtBSUQFjgi4p4hr+83HGzo07xe4AmNRO4cR
	 JQnQG60Ricp6yVPmmpkzrov6+g7G2z+P1+a39T+rhrDitWeoA6POAy3XqBjhQjNpMXA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id F0F151F000C7;
	Sun, 15 Nov 2026 22:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794782085;
	bh=inUC0SkyqCWXT74KU7Ifm0uEpFiY4HdTsNKZBYvwNYA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Kd6C8JiLlQa/rOQOCE5bgkxio+pFPagJ/70dwKul6SA6cU+wCFKVUfH1kxVF8QSW5
	 tTZy1HbfY2TUCf9ok76oT4XW4B9uS+0Z/cjPquVyxVHSc8WP0k8qrwnG4HtoQHCPMF
	 tT/MBI5gvohWzfmV7ApSIHmxJIesW/Eg97nhp1CU4Sfq9cYtbwxxtqvOb13RzT50yN
	 LXHy14isE9J1/CpjNOdH9O6am42Tnzsl64wlyTGwuzTvd/OIqWMYcMxifwfYoGoXd0
	 jzafC73OOa2IoVtEpOebQTZ37xgpGR/G80E3C5UJaU4w7JWr6EhQbvYCDWxh6ociQK
	 MCjYGb40qz2xA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 78EEE4A249;
	Sun, 15 Nov 2026 22:34:43 +0000 (UTC)
From: Alireza Asgari via B4 Relay <devnull+alireza.asgari.net@kernel.org>
Date: Sun, 15 Nov 2026 22:34:43 +0000
Subject: [PATCH RFC nf-next 3/9] memcg: add KUnit coverage for memory.high
 accounting
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261115-b4-nfqueue-memory-accounting-v1-3-b9cc30819997@asgari.net>
References: <20261115-b4-nfqueue-memory-accounting-v1-0-b9cc30819997@asgari.net>
In-Reply-To: <20261115-b4-nfqueue-memory-accounting-v1-0-b9cc30819997@asgari.net>
To: netfilter-devel@vger.kernel.org, linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 Phil Sutter <phil@nwl.cc>, Shuah Khan <shuah@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, 
 Chris Down <chris@chrisdown.name>, 
 Zhang Jiao <zhangjiao2@cmss.chinamobile.com>, Song Hu <husong@kylinos.cn>, 
 cgroups@vger.kernel.org, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Alireza Asgari <alireza@asgari.net>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794782082; l=7275;
 i=alireza@asgari.net; s=alireza-kernel; h=from:subject:message-id;
 bh=Z6QbxMTafWb669wa4rTvonBSA708LhbpJBhhLrjki24=;
 b=CTVYi/Mx/6tdBxGj1tMEaVxZ4E6RcSaznHu6ApJh54WF1KH1hRJxcddFgzH1qWKDbzNfOcV30
 v0PQd775resDas0IBE0A8BwvOYL7y6bK7g1wh1mSmjVRgTtqEV3pkrZ
X-Developer-Key: i=alireza@asgari.net; a=ed25519;
 pk=wuQ0/M69FqoVnrCMUJ13EQCwrCwVjCrtz75k15vW8tw=
X-Endpoint-Received: by B4 Relay for alireza@asgari.net/alireza-kernel with
 auth_id=1055
X-Original-From: Alireza Asgari <alireza@asgari.net>
Reply-To: alireza@asgari.net
Content-Transfer-Encoding: 7bit
X-Stat-Signature: x4xc8h59n4w3btdoir5qhh3smdkmigrr
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 273CF160002
X-HE-Tag: 1794782086-4898
X-HE-Meta: U2FsdGVkX1/p3Jx17bUCSUDwi0SZylet2nVmpRnEUAkuD5AiGP6vIFMhhBs0XcTsl+too+rWQzfDMyf5M+i7sggis6cSpB46ZmZ8u11hogjL+yoev7W0O7FZlr0XMOF4F9bt8/GZxXqCIhaGatDZ0/U/xuFLXBFpjlsJC9yyB0xXnxMIrC4iadq8nzaFl7C7L8yHrNM+RhdTB6gNnG3x9/uTn/qr3uNeDU93ZNNz7PPkll5cGtm7mOe3XEuSIKzCoMiUyg14Pwe52lUZ9vHiSUOSJrbweFoeFhcXKJztVgZn9eVISr/Pa9tVYAxXjUSFP+y6K1Zyy0fYCdT86RN1CKgbliqGJIsNubC6dJM965NBE2XjDooyiI9R+C+RFEKYHfkJ17QYkCz0E/lO2ffebBvuUTOOsM/VXb5O4Sb1P62rQ1P3We216qI1fsNxO9ZgIBpPogsMEhjRUBe7CMTfEyCm28syOQjC1RoODi4CwRZIygqw2+gXqCpUPJIjSuPLtgP1VHGI7shnCe4AWmjPhPqxyTCurdvddL8iQTaQWe/71FDTMRnhsedC+B1JvOz6u/hFOHLamcDofpdLruUPEDjKaVoyVF5sd6qxX2HoC98Z6hTHYv07l5RNM+bl2giEeZnU7d7qC8DkRIVDIemRAI6gp+4td/RMcVFh213rQ9tikFPlRSb3U8RI2aM8KIq51GskNKKCDmZgerBFv5U8jqUQWjAcwgJeV7RQGgyJxZp2j9cBhCf04JSSs/OSklM8Rxkw0tj7vJmLwhP8QTkez/b3K9wsIChOBPRyFG2BsDJy5R/ISiGnghrxMfKr4H/dbWAfrLpyJYJxeKkVbBNnVacakEee1EkpFd+uPwCwkjcKWfCJQwQpKkLrwRJt1sYYk3Z2VdG+ZdA67GLXsySLBe1wQyunZ2LXq9EI7sYLgUrFl+wneW2NzUpXUnFWVhpM1pY6JsdIagjbeDfpbbN
 qgCjYPnQ
 DW3U8X5wkPXrFK1wzpMNEQmlEVNy57j8cyTAy4mk438i0Hla5LjaYWoTdS7fXsJ/qfRk6uN1lb8GciArB8sU3tFrRKtUbW2Z/YFjLcTmkMUxynRMZf3OrN/3McaqIUId8F1noShMtvW4OkeGuVLMiC95Za3sw223SpNWbrtJbWDIILkQP9ggysy42xj8MBh+3RsBj/s4tDrKCOoHSYiI5oQEvPjsJWxmKVIGP1MpjIWeHcaQqYm1LNKg0fCAK9kXzYLirfXEyoJFxlOX7C5KKsLqaVSKzuNLA91o4Cf5lav34E4USslmuoAFF5cXKGpkEX/BEaY8xnHUdGnyqod8+pmFp8CBJ9GlziWRXqmLHTmNtUoQSVyWdqD//lYzoretNVbtzLPwCK2CWbz1qbPkASoiYcH6neHWW3Pce2PonJU6EmrebTalTHa37myVynJkaB2J9emWMIIp4a1XnsdO7rO+hOeHkYvEBs5oGcx4aTUK2ktzVKUS3gvRtMRb/jZi0eo9Buoq1Y1qZ3m+wMOL3W7hlGGlbfJIQHLWJfhQL5cRxvic=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Alireza Asgari <alireza@asgari.net>

Exercise deferred page-debt saturation and the bounded delay arithmetic
without requiring very large memory allocations.

The debt test calls the real charge path using an isolated page-counter
fixture, small GFP_NOWAIT charges, and seeded debt values. It restores
task state and fixture counters before checking results. The arithmetic
cases call the internal helpers directly, including one-page debt and
large numerators whose scaled product would overflow u64.

Keep this coverage independent of the capacity-reservation interface so
the generic MM fixes can be reviewed and tested separately. The tests
require built-in KUnit and memcg support on either word size.

Signed-off-by: Alireza Asgari <alireza@asgari.net>
---
 mm/Kconfig                |  10 +++
 mm/memcontrol.c           |   4 ++
 mm/memcontrol_high_test.c | 162 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 176 insertions(+)

diff --git a/mm/Kconfig b/mm/Kconfig
index afff1b25b543..dd763d3d0e36 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1531,6 +1531,16 @@ config PTDUMP
 	bool
 
 
+config MEMCG_HIGH_KUNIT_TEST
+	bool "Memory cgroup high limit tests" if !KUNIT_ALL_TESTS
+	depends on MEMCG && KUNIT=y
+	default KUNIT_ALL_TESTS
+	help
+	  Test deferred memory.high debt saturation through the real charging
+	  path with isolated counters and small charges. Delay tests cover
+	  fixed-point rounding and arithmetic bounds on 32-bit and 64-bit
+	  kernels. Say N unless developing memory cgroup high limit handling.
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 665ce8dfb9ec..446b60ca6aef 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6532,3 +6532,7 @@ void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
 		K(atomic_long_read(&memcg->memory.children_min_usage)),
 		K(atomic_long_read(&memcg->memory.children_low_usage)));
 }
+
+#if IS_ENABLED(CONFIG_MEMCG_HIGH_KUNIT_TEST)
+#include "memcontrol_high_test.c"
+#endif
diff --git a/mm/memcontrol_high_test.c b/mm/memcontrol_high_test.c
new file mode 100644
index 000000000000..bf792d398021
--- /dev/null
+++ b/mm/memcontrol_high_test.c
@@ -0,0 +1,162 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <kunit/test.h>
+
+static void memcg_high_test_restore_counter(struct page_counter *counter,
+					    unsigned long before)
+{
+	unsigned long after = page_counter_read(counter);
+
+	if (after > before)
+		page_counter_uncharge(counter, after - before);
+	else if (after < before)
+		page_counter_charge(counter, before - after);
+}
+
+static void memcg_high_test_debt(struct kunit *test)
+{
+	const unsigned int nr_pages = MEMCG_CHARGE_BATCH + 1;
+	const struct {
+		unsigned int before;
+		unsigned int expected;
+	} cases[] = {
+		{ 0, nr_pages },
+		{ UINT_MAX - nr_pages, UINT_MAX },
+		{ UINT_MAX - nr_pages + 1, UINT_MAX },
+		{ UINT_MAX, UINT_MAX },
+	};
+	struct mem_cgroup *memcg;
+	unsigned int i;
+
+	memcg = kunit_kzalloc(test, sizeof(*memcg), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, memcg);
+	page_counter_init(&memcg->memory, NULL, false);
+	page_counter_init(&memcg->memsw, NULL, false);
+	page_counter_init(&memcg->swap, NULL, false);
+	page_counter_set_high(&memcg->memory, 0);
+	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
+
+	for (i = 0; i < ARRAY_SIZE(cases); i++) {
+		unsigned int saved = current->memcg_nr_pages_over_high;
+		bool notify = test_thread_flag(TIF_NOTIFY_RESUME);
+		unsigned int debt;
+		bool notified;
+		int ret;
+
+		/*
+		 * Exceed the stock batch to use the real counter charge path
+		 * without leaving a reference to this isolated fixture in stock.
+		 * GFP_NOWAIT defers reclaim until return to userspace.
+		 */
+		current->memcg_nr_pages_over_high = cases[i].before;
+		ret = try_charge_memcg(memcg, GFP_NOWAIT, nr_pages);
+		debt = current->memcg_nr_pages_over_high;
+		notified = test_thread_flag(TIF_NOTIFY_RESUME);
+
+		/* Restore the test task before any assertion can abort the case. */
+		current->memcg_nr_pages_over_high = saved;
+		if (!notify)
+			clear_thread_flag(TIF_NOTIFY_RESUME);
+		memcg_high_test_restore_counter(&memcg->memory, 0);
+		if (do_memsw_account())
+			memcg_high_test_restore_counter(&memcg->memsw, 0);
+
+		KUNIT_EXPECT_EQ_MSG(test, ret, 0, "case %u", i);
+		KUNIT_EXPECT_EQ_MSG(test, debt, cases[i].expected, "case %u",
+				    i);
+		KUNIT_EXPECT_TRUE_MSG(test, notified, "case %u", i);
+	}
+}
+
+static void memcg_high_test_overage(struct kunit *test)
+{
+	const unsigned long large_high = 1UL << (BITS_PER_LONG - 3);
+	const struct {
+		unsigned long usage;
+		unsigned long high;
+		u64 expected;
+	} cases[] = {
+		{ 0, 0, 0 },
+		{ 1, 0, 0 },
+		{ 2, 0, 1ULL << 20 },
+		{ 99, 100, 0 },
+		{ 100, 100, 0 },
+		{ 110, 100, 104857 },
+		{ 150, 100, 524288 },
+		{ 299, 100, 2086666 },
+		{ 300, 100, 2ULL << 20 },
+		{ 301, 100, 2ULL << 20 },
+		{ ULONG_MAX, 1, 2ULL << 20 },
+		{ ULONG_MAX, ULONG_MAX - 1, 0 },
+		/* A modest ratio whose scaled numerator exceeds u64 on 64-bit. */
+		{ large_high + large_high / 16, large_high, 1ULL << 16 },
+	};
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(cases); i++)
+		KUNIT_EXPECT_EQ_MSG(
+			test, calculate_overage(cases[i].usage, cases[i].high),
+			cases[i].expected, "case %u", i);
+}
+
+static void memcg_high_test_delay(struct kunit *test)
+{
+	const unsigned long cap = MEMCG_MAX_HIGH_DELAY_JIFFIES;
+	const struct {
+		unsigned int pages;
+		u64 overage;
+		unsigned long expected;
+	} cases[] = {
+		{ 0, 0, 0 },
+		{ 0, U64_MAX, 0 },
+		{ UINT_MAX, 0, 0 },
+		{ 1, 1ULL << 16, (HZ / 4) / 64 },
+		{ 63, 1ULL << 16, (HZ / 4) * 63 / 64 },
+		{ 64, 1ULL << 16, HZ / 4 },
+		{ 65, 1ULL << 16, (HZ / 4) * 65 / 64 },
+		{ UINT_MAX, 1ULL << 16, cap },
+		{ 64, 1ULL << 17, HZ },
+		/* Apply debt scaling before the cap, including sub-batch debt. */
+		{ 1, 1ULL << 18, HZ / 16 },
+		{ 1, 1ULL << 20, HZ },
+		{ 2, 1ULL << 20, cap },
+		{ 1, 2ULL << 20, cap },
+		{ 64, 1ULL << 32, cap },
+		{ UINT_MAX, 1ULL << 32, cap },
+		{ 1, U64_MAX, cap },
+		{ UINT_MAX, U64_MAX, cap },
+	};
+	unsigned long delay;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(cases); i++)
+		KUNIT_EXPECT_EQ_MSG(test,
+				    calculate_high_delay(cases[i].pages,
+							 cases[i].overage),
+				    cases[i].expected, "case %u", i);
+
+	/* 32 GiB over an 8 MiB high limit, expressed in 4 KiB pages. */
+	KUNIT_EXPECT_EQ(
+		test,
+		calculate_high_delay(64, calculate_overage((1UL << 23) + 2048,
+							   2048)),
+		cap);
+	/* Both memory and swap contributions are bounded before addition. */
+	delay = calculate_high_delay(UINT_MAX, U64_MAX);
+	delay += calculate_high_delay(UINT_MAX, U64_MAX);
+	KUNIT_EXPECT_EQ(test, delay, 2 * cap);
+}
+
+static struct kunit_case memcg_high_test_cases[] = {
+	KUNIT_CASE(memcg_high_test_debt),
+	KUNIT_CASE(memcg_high_test_overage),
+	KUNIT_CASE(memcg_high_test_delay),
+	{}
+};
+
+static struct kunit_suite memcg_high_test_suite = {
+	.name = "memcg_high",
+	.test_cases = memcg_high_test_cases,
+};
+
+kunit_test_suite(memcg_high_test_suite);

-- 
2.34.1



