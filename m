Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A433AF8A145
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 09:10:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 181696B0099; Thu, 16 Apr 2026 05:10:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BFC16B009B; Thu, 16 Apr 2026 05:10:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3F936B009D; Thu, 16 Apr 2026 05:10:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E62866B0099
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:10:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B04661B89E8
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:10:56 +0000 (UTC)
X-FDA: 84663849312.08.DC13931
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 175AF180003
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:10:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dxTiqn9W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776330655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cKsAd94ONAvVkGOzpQ0BpBmwMN5DKryVdLqPfSLOjoo=;
	b=fufGIBzHq3p/AYNYahIDCIuhnrgVsOPOtgMO7IrAHpcGTHSNvLGia/7xK3Z1vv9eFCwoy0
	x1v12YhSG7i3skTMqsnYGjIg3qJZk4nKZXg9h8XsvggCw+qP2y9jGTLdntEctB0Fluh2/T
	jyFyKXwhkRQ2GpbwedbW2qiPY3wdbEc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dxTiqn9W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776330655; a=rsa-sha256;
	cv=none;
	b=A3WB5ybLO6HoMzb3FyTtcCyDe4cMRmBiZJGJKc5W7sGBFTpv+MeestYLmOpGoFhgJyp0IS
	FIuyuc7BJNgvTeFNvk/3NpE671qolTj724b5E/egtZYwBUChWsxECl11Gzj1zQdISQK1Gt
	RCu952Q51MUHpTpxIcNz9ubjyXWleOA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8FE2160127;
	Thu, 16 Apr 2026 09:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620A1C2BCAF;
	Thu, 16 Apr 2026 09:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776330654;
	bh=LATxRaCRQ+I6DOtBbEo4sXyXtR4wOYD3wcNo4oJIen8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dxTiqn9WdOiYD8TTOctyYBTJnnfrMrkIeNLNCEcJUxewnXGOtMLXNR6lFgs0Ktc+q
	 eok+ngmcTckSQlufgwP6MTzr62gQDBmhMxcHJM1BrCXAf+NKX05bWz0fKIvtvH3cr2
	 h7J9ruuVqla1sjjCnOamlY3HpVfPvBsOLvqogelghkjecKWUdknjSFsE31BhrucK9n
	 WcRYB0+q7cGDsU3KU+ismnHqij89BchWGuXefNClV+Kg7D530uUo33F2DBEqXOFjQ5
	 nabrjLq8llo2lYf14wSCqMvQWGkqdik7Z6TPiaoaW39Hd+LXWZChWcStVyolkIzQNK
	 7rDdRACbh2U8g==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>,
	Zqiang <qiang.zhang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	rcu@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 8/8] lib/tests/slub_kunit: add a test case for kfree_rcu_nolock()
Date: Thu, 16 Apr 2026 18:10:22 +0900
Message-ID: <20260416091022.36823-9-harry@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260416091022.36823-1-harry@kernel.org>
References: <20260416091022.36823-1-harry@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 175AF180003
X-Stat-Signature: p9chugj6ybahzmmqsu59ybxy9w3n6t46
X-Rspam-User: 
X-HE-Tag: 1776330654-705741
X-HE-Meta: U2FsdGVkX1/LYex1W7toTW3wS5irnrGVpq5zLLHBHXN7hBauYb8GgqIHBF/w6uAxFtX0sN+GahIUMiMDHpy5Lg6T87m/zlKOVVOocS8RCq7RVyESxRoIIX7Rn9LfKRV7Kuhz0YHZe4o2AcwofHn3G5aS12wDpX3kVUelIVmlsCRamlp2r++3j+vr+ZeFMIkLFwDuGxoCQaCsRl1DnR2Ql6klpwVRY7LUR/p7zqYjLB2lKPX1oSuYi56CSCKz4DgdqqPOKKVJNW7hI7hNMyc1H3gEr26zwurvRYGEjPEx5Qz+iAUK6qay1L3H716XIiwp6thwJG7eHGJqr3oaX/ynhpEv51JSpOpbn8/6R586qnD3g/S/2vaWKJQR96TDws7t+L16igUwZuD//UIgAhk2MtnrBBzvHh7f0G0x8t7fihQdn+ojn/C0C3vCu+K4txnR4xNpIOlonMBfVN0uz+Rerw4a7MH2QC1YqhYmfDUT/bID6xVexs/MPhGKV1SwMSTsrVTOWUoMClLGPmXPg4V61z/J4RSyNF2myrvIfa+WztdHwzJJfOu8MD68zX4Lib6Oku+Tc54Jo53v/BcT4ALyKsz2tQiwCTTrXbpoCCi7pGXwTpRFSHsVwYL9VLflfKp4rI7oyTxL8D7afZppHUy/NLgHSARhC3g9v7afGgx/Mij6Q+U02XDLvoXb2EFcEuUlm0XAWH6+vXaZN073MfKrlG9Hhu2/aR8p4otgjsBL55SMN6L1sQ9FHlBkevB8ZPFnPfvdb2TNTr6C8Ggp6y3SnRQ1qPzT4RsPEJwZljm2vEBSImJJeSsJ0hX1K18WWdVkc2VEnLSM7mk8O0xo4A14Lsq0z9H4lgnx4OaSwIo8Lq0nPEyjFLPzoFFJCOBPvoKKBXVzbU46pcBKH9+tcPTtgyW+oY6UaapXkxYvUFRqNsdHQQ36d/64bie1la8kYXi9iIPCmV4xxlTLxyPMDuu
 QdW1/l9O
 VNbJk1WWXiI0Z80hIoL8nOGh8qwf1izYV2MI0Xk0fP/TzX9LkHuWti7KQR24G8BC/YZO7qL0lgvcHAson9CM5JYxGzKfbTYCdZoUPMiGQJ8iqr6ioL6fuH02FINkzMYEHfE3623sP+GUGXUVS339NneD493gcvmAvaxuLMNYdlSieyrxaf8gGA4+A64+5PfB2bHOcC3GEM2xFU6huSZUTNwS0Igs0ZBItor4hjtoWBf6VdSPv/kTUCaoo9ABp+TBqhSDC79ZuWrlJA5TIYi6aZaIUoEhm6XvhcrJS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Similar to test_kmalloc_kfree_nolock, add a test that allocates objects
via kmalloc_nolock() and frees them via kfree_rcu_nolock() in a perf
overflow handler (NMI or hardirq depending on the arch), while the main
loop allocates and frees objects via kmalloc() and kfree_rcu().

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 lib/tests/slub_kunit.c | 73 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index fa6d31dbca16..f8d979912246 100644
--- a/lib/tests/slub_kunit.c
+++ b/lib/tests/slub_kunit.c
@@ -367,6 +367,78 @@ static void test_kmalloc_kfree_nolock(struct kunit *test)
 			kfree(objects[j]);
 	}
 
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
+struct dummy_struct {
+	struct rcu_ptr rcu;
+};
+
+static void overflow_handler_test_kfree_rcu_nolock(struct perf_event *event,
+						   struct perf_sample_data *data,
+						   struct pt_regs *regs)
+{
+	struct dummy_struct *dummy;
+	gfp_t gfp;
+	struct test_nolock_context *ctx = event->overflow_handler_context;
+
+	/* __GFP_ACCOUNT to test kmalloc_nolock() in alloc_slab_obj_exts() */
+	gfp = (ctx->callback_count % 2) ? 0 : __GFP_ACCOUNT;
+	dummy = kmalloc_nolock(sizeof(*dummy), gfp, NUMA_NO_NODE);
+
+	if (dummy) {
+		ctx->alloc_ok++;
+		kfree_rcu_nolock(dummy, rcu);
+	} else {
+		ctx->alloc_fail++;
+	}
+	ctx->callback_count++;
+}
+
+static void test_kfree_rcu_nolock(struct kunit *test)
+{
+	int i, j;
+	struct test_nolock_context ctx = { .test = test };
+	struct perf_event *event;
+	bool alloc_fail = false;
+	struct dummy_struct *dummy;
+
+	if (IS_BUILTIN(CONFIG_SLUB_KUNIT_TEST))
+		kunit_skip(test, "can't do kfree_rcu_nolock() when test is built-in");
+
+	event = perf_event_create_kernel_counter(&hw_attr, -1, current,
+						 overflow_handler_test_kfree_rcu_nolock,
+						 &ctx);
+	if (IS_ERR(event))
+		kunit_skip(test, "Failed to create perf event");
+	ctx.event = event;
+	perf_event_enable(ctx.event);
+	for (i = 0; i < NR_ITERATIONS; i++) {
+		for (j = 0; j < NR_OBJECTS; j++) {
+			gfp_t gfp = (i % 2) ? GFP_KERNEL : GFP_KERNEL_ACCOUNT;
+
+			objects[j] = kmalloc(sizeof(*dummy), gfp);
+			if (!objects[j]) {
+				j--;
+				while (j >= 0)
+					kfree(objects[j--]);
+				alloc_fail = true;
+				goto cleanup;
+			}
+		}
+		for (j = 0; j < NR_OBJECTS; j++)
+			kfree_rcu((struct dummy_struct *)objects[j], rcu);
+	}
+
 cleanup:
 	perf_event_disable(ctx.event);
 	perf_event_release_kernel(ctx.event);
@@ -406,6 +478,7 @@ static struct kunit_case test_cases[] = {
 	KUNIT_CASE(test_krealloc_redzone_zeroing),
 #ifdef CONFIG_PERF_EVENTS
 	KUNIT_CASE_SLOW(test_kmalloc_kfree_nolock),
+	KUNIT_CASE_SLOW(test_kfree_rcu_nolock),
 #endif
 	{}
 };
-- 
2.43.0


