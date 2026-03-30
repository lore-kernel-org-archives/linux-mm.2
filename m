Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B27A510D14A4
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 12:05:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C249E6B009B; Mon, 30 Mar 2026 08:05:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFCEF6B00A0; Mon, 30 Mar 2026 08:05:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEBE36B00A1; Mon, 30 Mar 2026 08:05:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9E67C6B009B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 08:05:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3B3A28BFC4
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:05:33 +0000 (UTC)
X-FDA: 84602599746.08.A26DA97
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 99D0D40011
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:05:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jkF2qVAb;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jkF2qVAb;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774872331; a=rsa-sha256;
	cv=none;
	b=F7PMp9LTzM5tJYN4riFe/tDFEKOdzxtuNPE+PxRrEvOU6tognr1cIDGceFdpXUASwWxMHD
	YTmTcMnxNWKU4kqEEkHf2NOz0BZ96GFOaLzf9QxP2nirAplcEJr691UgI60MzLK0Jqay99
	woXgCpri9mT+XIXTK6SiMS9M/YRou1E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774872331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SF7gTb5qGcoTEjjBPXj0s6BCFat+ERh82G7vrVOY3B0=;
	b=Bju4SFfNCifKZd+MVCOEEqVGAJnd8TSs+TwmU17hJJLCVrZhZe7qt5Gqm0Z93HJl8tj2jr
	TeVwPyDCu8KOfjqYBdBPDBJaf9cWhVl9Y6ikkNkMVjWYeocEINLMSAXkiPzXyeNxLixqhk
	WBvj/09Qw1w1CVfLTzMFQSa4AdXzp/Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2160C60131;
	Mon, 30 Mar 2026 12:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692A4C4CEF7;
	Mon, 30 Mar 2026 12:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774872330;
	bh=fckQad9uvkMGEVwpEwBUucO8q9GVwf03fWoMEZuJ4qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jkF2qVAby3PLCcJIBHq4PWILtfQMfwG08dYFVhw1GptuD9n+phFpXUGV94tU5Nrq5
	 SbTznRAbDuMicT15KDPSwYjGWMzaxz5UAYtGUgF6dWvY1/vzcibjdyCnWn/hh4VmkC
	 BEcXI4ihirWdu/bmJDjF8YTUsXCfaBCQUIRTkn6JONO0crrxH40AydNsN6w4fHekjY
	 RAkMQ6TZXof0e+FOPAq7GY7EemT3t5MdMr1Qbe4m5iQ99AXOVPTi+LfrYz28d5uojZ
	 dShI5jczLuZ9ad2S/3prVgwOz8qxwEijqfSQBpv55Yq6BU7w+EfyHe8Zu1yo1iJkV5
	 I+mq9U994CyPA==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	"Harry Yoo (Oracle)" <harry@kernel.org>
Subject: [PATCH V1 2/2] lib/tests/slub_kunit: add a test case for {kmalloc,kfree}_nolock
Date: Mon, 30 Mar 2026 21:05:16 +0900
Message-ID: <20260330120517.104743-3-harry@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260330120517.104743-1-harry@kernel.org>
References: <20260330120517.104743-1-harry@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 99D0D40011
X-Stat-Signature: skrjfnf7g5hguarcge5c34hn5duk65pa
X-Rspam-User: 
X-HE-Tag: 1774872331-31994
X-HE-Meta: U2FsdGVkX1/HEoX1x7cepow26DWIwAZNlgBs4Okv35riH+ndCfk0MxLRO2v7ss6SMfJHjPpIgIvsRvr0LTZoHKTearmXRvgpzh6UgpsoXTeO8QKxhhm0yAFImqHlyKUVPmVkU29JUETxrZEvOeesDf2P0pXT3hzqJwE9tThobCaPmKffZTp9VCiJJ+4P2okmb7WYrd5YYlKrb9nlenPAMRQP85bxPhC/TC98QKrXTVI2x/Qpthz9otwNZ90iChVOUhts8Da2IHRSLo2JZA4v6DZc/LSFSxKWOfjxM+CdGmwFclnMErR8cbCdC/T2CEE5Taw2TF/vRpH6x0yVnAeTEmnzAVxtimHG61zWCo5wGjV589XqvLZyYUIqrRA/HNiefF7ZqLrbDHp1rimHtQdmcYMMBX6nMsLZWjit6gbSTt/mR4k0HVgNhFRGXEWRpCCFPWthgZSfsDaAfdY6W8qRhdK/GkzXJRtCPvJd5veN44bvR8oDGcF2hf59kVTOCnaUsUH8bsLCohaSiupDAYPlfFhRDGSA9aXhQhPNxlUasOnpRtGL/10L3aVccVLvp5yiXWlk+jVlIZK/zMPNlY455jwXlHOns295GGH+9vvoWR8wvjjoheYAJL4TN5vtbf6gy2c2ptYJAQMv/PyZyZF//FlkgWCdiRh8kkIKzKY1e8dKndKDVkJJSY85gcBXZm7ZxoI/Qln/PXGVJ0ikRtz9Tls/EVfJl//I88iGFggJYNFzBeREgd76T2uwtIixraskg+XImuFwaOjyNjmtWD0zncZZejc5x5EibuFLFugXhf/D5gWPLzQOwnQLOGg7l2DLKLNwEXWF948ePWHbDsM6K34i2XD+AJiko66gRgHY57yIJ89EzxZB2qjr2F1urTMimvnkVKqw59cq73g1E2DOsSWBO/VKZaiNdcibglIxogzA2LEm/r34yeF2nI9/bGHNco/v48dRnneDJR+1Mxu
 kFlKaLyk
 FOe+Q62UODj/juiTkIuPyjd97fyIuEyDH+4OYSVKHS6QKUm8q9RJC4W4qb9QF5HsWWnnKyFhhSQnDdkBuYJsfHhxSzb+xvxGMtlrxES6vi/vjywG6N6WvxzXssk4JiD4MS9Rdhqs6zTE9FztSWDi//p+roYoHUbH4OQZXtvxv5LX7J8A8wTquklwOFYockoUktFqs8zzUfNf4gaaxx0m/BSoJHyYveOvfHDEeQtjDYlxi65Lr8dp+5x7Cy7K9IPiXgu/8nF2D+oVFo/3oHEcvE9/WuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Testing invocation of {kmalloc,kfree}_nolock() during kmalloc() or
kfree() is tricky, and it is even harder to ensure that slowpaths are
properly tested. Lack of such testing has led to late discovery of
the bug fixed by commit a1e244a9f177 ("mm/slab: use prandom if
!allow_spin").

Add a slub_kunit test that allocates and frees objects in a tight loop
while a perf event triggers NMIs on the same task, invoking
{kmalloc,kfree}_nolock() from the NMI handler.

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 lib/tests/slub_kunit.c | 88 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index 848b682a2d70..2ed5f90a748a 100644
--- a/lib/tests/slub_kunit.c
+++ b/lib/tests/slub_kunit.c
@@ -7,6 +7,7 @@
 #include <linux/kernel.h>
 #include <linux/rcupdate.h>
 #include <linux/delay.h>
+#include <linux/perf_event.h>
 #include "../mm/slab.h"
 
 static struct kunit_resource resource;
@@ -291,6 +292,92 @@ static void test_krealloc_redzone_zeroing(struct kunit *test)
 	kmem_cache_destroy(s);
 }
 
+#define REPEAT_TIMES 1000
+#define LOOP_SIZE 1000
+static void *objects[LOOP_SIZE];
+
+struct nmi_context {
+	struct kunit *test;
+	int callback_count;
+	int alloc_ok;
+	int alloc_fail;
+	struct perf_event *event;
+};
+
+static struct perf_event_attr nmi_hw_attr = {
+	.type = PERF_TYPE_HARDWARE,
+	.config = PERF_COUNT_HW_CPU_CYCLES,
+	.size = sizeof(struct perf_event_attr),
+	.pinned = 1,
+	.disabled = 1,
+	.freq = 1,
+	.sample_freq = 100000,
+};
+
+static void kmalloc_kfree_nolock_in_nmi(struct perf_event *event,
+					struct perf_sample_data *data,
+					struct pt_regs *regs)
+{
+	void *objp;
+	gfp_t gfp;
+	struct nmi_context *ctx = event->overflow_handler_context;
+
+	/* __GFP_ACCOUNT to test kmalloc_nolock() in alloc_slab_obj_exts() */
+	gfp = (ctx->callback_count % 2) ? 0 : __GFP_ACCOUNT;
+	objp = kmalloc_nolock(64, gfp, NUMA_NO_NODE);
+
+	if (objp)
+		ctx->alloc_ok++;
+	else
+		ctx->alloc_fail++;
+
+	kfree_nolock(objp);
+	ctx->callback_count++;
+}
+
+static void test_kmalloc_kfree_nolock(struct kunit *test)
+{
+	int i, j;
+	struct nmi_context ctx = { .test = test };
+	struct perf_event *event;
+	bool alloc_fail = false;
+
+	event = perf_event_create_kernel_counter(&nmi_hw_attr, -1, current,
+						 kmalloc_kfree_nolock_in_nmi,
+						 &ctx);
+	if (IS_ERR(event))
+		kunit_skip(test, "Failed to create perf event");
+	ctx.event = event;
+	perf_event_enable(ctx.event);
+	for (i = 0; i < REPEAT_TIMES; i++) {
+		for (j = 0; j < LOOP_SIZE; j++) {
+			gfp_t gfp = (i % 2) ? 0 : __GFP_ACCOUNT;
+
+			objects[j] = kmalloc(64, gfp);
+			if (!objects[j]) {
+				j--;
+				while (j >= 0)
+					kfree(objects[j--]);
+				alloc_fail = true;
+				goto cleanup;
+			}
+		}
+		for (j = 0; j < LOOP_SIZE; j++)
+			kfree(objects[j]);
+	}
+
+cleanup:
+	perf_event_disable(ctx.event);
+	perf_event_release_kernel(ctx.event);
+
+	kunit_info(test, "callback_count: %d, alloc_ok: %d, alloc_fail: %d\n",
+		   ctx.callback_count, ctx.alloc_ok, ctx.alloc_fail);
+
+	if (alloc_fail)
+		kunit_skip(test, "Allocation failed");
+	KUNIT_EXPECT_EQ(test, 0, slab_errors);
+}
+
 static int test_init(struct kunit *test)
 {
 	slab_errors = 0;
@@ -315,6 +402,7 @@ static struct kunit_case test_cases[] = {
 	KUNIT_CASE(test_kfree_rcu_wq_destroy),
 	KUNIT_CASE(test_leak_destroy),
 	KUNIT_CASE(test_krealloc_redzone_zeroing),
+	KUNIT_CASE_SLOW(test_kmalloc_kfree_nolock),
 	{}
 };
 
-- 
2.43.0


