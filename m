Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37A49CD98DA
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:07:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C67B6B00A4; Mon, 15 Jun 2026 07:07:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 977B36B00A6; Mon, 15 Jun 2026 07:07:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8669B6B00A7; Mon, 15 Jun 2026 07:07:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 736BA6B00A4
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:07:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4688C1C45CF
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:07:22 +0000 (UTC)
X-FDA: 84881870724.03.D85A4DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 89E622000F
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:07:20 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ok05IY9h;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781521640;
	b=kOOmFcR9tWIcgacNW+mOytgPkBsTRa47pnB8E5BrcDONBlleBa4V41cj0HqBrHw8R1zuRg
	rChEmpxMC050LmnmaO3MQpCr5PNyGqQQXH/OfUTbKwVNMOQo0lt/201SoymmlUyUy8/TwI
	CXGLfUZrC5gGi6G4v7LW1ecpU044be4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ok05IY9h;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781521640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=alw5HkCTiTdHCndsz3LKMMxy51B8ZMiiU4H9kP+lPXc=;
	b=hsv/DnII0botMYhOnwdOQcb9N7gx4xgNYHDwJYeNrGzZikjLcHK6avm6nE0i/GuVN1wBWu
	gytIYcD1ANFF7rtlQVnJPuvC2HifMxND7uiJl+ru/BuYzDDwS1iBPA/KDmnfDO12NcyjfW
	KkMlC3OGKFk1strl74mH8c9foLNaPmQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DCDBE4383C;
	Mon, 15 Jun 2026 11:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E811F00A3A;
	Mon, 15 Jun 2026 11:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781521639;
	bh=alw5HkCTiTdHCndsz3LKMMxy51B8ZMiiU4H9kP+lPXc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ok05IY9hDxqFSvOMGbiJhAqKJrAvhilMe/yiZa/x/NCFYVEgFIgWqE3p95bLknrRc
	 U4fKogysbNvoJiIg8J2l3ZpscbhAS+tfD1/xqyGSSQBpvLEQy224NpcUVDheeaHsDj
	 heHwLnTiGf/e70zkq43DWD5YIxoYCNwcmt3FzDgmGy4aGaNCT9hJKL7T2zUP3/Nzsr
	 uNqRWaN3ZVjjmFut8Xzh2qOlp9WzqSwIANUqdWLd8rxKQi59Tgv1IrR1uuuB30m/y3
	 zn2wu/LLHf/xG8OdnpoYEDsXvIA4FXbZhbB6xDHLesBpcv6EHloGjd8+soJiTHTxZM
	 kca4UZ4Ve702Q==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Mon, 15 Jun 2026 20:06:03 +0900
Subject: [PATCH for-next v3 9/9] slub_kunit: extend the test for
 kfree_rcu_nolock()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-kfree_rcu_nolock-v3-9-70a54f3775bb@kernel.org>
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
In-Reply-To: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
 "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspamd-Queue-Id: 89E622000F
X-Stat-Signature: m7kgz7u8yig779bjbww6sdkuxtgp5db8
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781521640-859883
X-HE-Meta: U2FsdGVkX19FlBlxW6W0Ys5vSz1dIcM5DiPDLHVcolSAFTL05AdAP/qAxizx7e4wzvP5gSbwp4UmfhEJpqN9jSqFJrv1dU8yRR2KwPuWMmeXOLdHyubanJuEsBKj63ytfo3NaW2PmKnQMcdjqGUM4B96nZvPUQIiLXFGu6HWBKn+dmSLZwE2kcXU0rAfXosdezQUyVAQaK04rQ3ZzarUXD52QvG8t2c8w5nlSIr2e8oMkXUSMeFZsdE3onGne3+B0xjmo+kPXtaTRb7mSvvZT83ehX6S9dj19TvPSJD1ndB8qCbFp0sme1Osk88ETA5rnhU3w/+JTZ7NS+QvelG0Rc4gw6K/AdfnXAq29oOTNnl2+npqUW8ikDINGxWUMV3E1R2Us7Z2Mg2gLU3wgEiGaICuuFtb2ilggTpbDxPTM7eLvq2RFfCnPmNPQXP/5L45KhzhQ8uGn859YjhYaO3hopW5qodrQvRCIT5Y28llHAWS+9o14IzOagI2wyOwJpg4ppU9olFcSK4AjLv1fDpKxVBzk6QZ/1UKaSbSDBMS5DGxkkI6ta9ekZC/XpZjT4y2cxP33FANrk2EKGWvYvIR2NWYpecIR07y1atr7L0qrMuGpZKdct/HgTd49HxSr/ogEOTZwB8KNGRxRCBCwzmAwCXeqEfEpbgvACUbRt2f0T/4nAaM/3/1FyQKNw2OmxdJEhUTc+pkB+ptPzPDcm/ElTtNeKxqzeKU/16l4yjQHs8+/X59eqz/ixaJUU47BE44f7/dkZ46I9uUSYx1mxZ4MEuZ/Mb5rqEcYSqzK1P4Ioc+zCzlFeD+U/iReAiNg9ZrSuX9tcPW4mI2NYiHXtVPR8eYL1/ONfXRUFzUE68Z1hGR/EWt3Zb1HpvzFS2H8PbYYfyZr3KWO406ieLrRVrO3Oj39oasg1l9DcI4UW3YWrCi5xTzcINHxIsU5tARjKd+PViy47e9EVdtnSHZ4C9
 nVzSA2kg
 cMqn6BHad7cPcipC1ryIfgy0QAnAW/d7lRZ0Micqo/jcHFU2in/6Hqa8jurK5rxaEE0XNPIyJwqxm0Iw7oVMorjSjqdM5xQj+7I6IsFp1fnqMwRlDHhhuOVnNZFaooLVPUMlgC+5fKKovqPP6k4ggks7wLZ5SWIwtPPiSs9badp6T6rvniteYJWlMID9B47SmoSz/oyc9HgKZZC4w4+knJw9QI3RBK/G0Vs5U8dRvP/G/lhGJP9FF7XysiuqLIvHVSfQbKY+k/LrXixDlCYKkCQB4yODuFg5eq3Sh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When slub_kunit is not built-in, call kfree_rcu() and kfree_rcu_nolock()
to test kfree_rcu_nolock() in slub_kunit.

Rename the test case as the test covers more _nolock() APIs.

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 lib/tests/slub_kunit.c | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index 01d808cb77fa..6ed4de88bf0b 100644
--- a/lib/tests/slub_kunit.c
+++ b/lib/tests/slub_kunit.c
@@ -162,7 +162,10 @@ static void test_kmalloc_redzone_access(struct kunit *test)
 }
 
 struct test_kfree_rcu_struct {
-	struct rcu_head rcu;
+	union {
+		struct rcu_head rcu;
+		struct kfree_rcu_head krcu;
+	};
 };
 
 static void test_kfree_rcu(struct kunit *test)
@@ -294,10 +297,10 @@ static void test_krealloc_redzone_zeroing(struct kunit *test)
 }
 
 #if defined(CONFIG_PERF_EVENTS) || (defined(CONFIG_KPROBES) && defined(CONFIG_SMP))
-#define SLUB_KUNIT_TEST_KMALLOC_KFREE_NOLOCK
+#define SLUB_KUNIT_TEST_KMALLOC_NOLOCK_AND_FRIENDS
 #define NR_ITERATIONS 1000
 #define NR_OBJECTS 1000
-static void *objects[NR_OBJECTS];
+static struct test_kfree_rcu_struct *objects[NR_OBJECTS];
 
 struct test_nolock_context {
 	struct kunit *test;
@@ -336,19 +339,24 @@ static struct perf_event_attr sw_attr = {
 
 static void test_nolock(struct test_nolock_context *ctx)
 {
-	void *objp;
+	struct test_kfree_rcu_struct *objp;
 	gfp_t gfp;
+	bool can_use_kfree_rcu = !IS_BUILTIN(CONFIG_SLUB_KUNIT_TEST);
 
 	/* __GFP_ACCOUNT to test kmalloc_nolock() in alloc_slab_obj_exts() */
 	gfp = (ctx->callback_count % 2) ? 0 : __GFP_ACCOUNT;
-	objp = kmalloc_nolock(64, gfp, NUMA_NO_NODE);
+	objp = kmalloc_nolock(sizeof(*objp), gfp, NUMA_NO_NODE);
 
 	if (objp)
 		ctx->alloc_ok++;
 	else
 		ctx->alloc_fail++;
 
-	kfree_nolock(objp);
+	if (can_use_kfree_rcu && (ctx->callback_count % 2))
+		kfree_rcu_nolock(objp, krcu);
+	else
+		kfree_nolock(objp);
+
 	ctx->callback_count++;
 }
 
@@ -432,12 +440,13 @@ static bool register_slab_kprobes(struct test_nolock_context *ctx) { return fals
 static void unregister_slab_kprobes(struct test_nolock_context *ctx) { }
 #endif
 
-static void test_kmalloc_kfree_nolock(struct kunit *test)
+static void test_kmalloc_nolock_and_friends(struct kunit *test)
 {
 	int i, j;
 	struct test_nolock_context perf_ctx = { .test = test };
 	struct test_nolock_context kprobe_ctx = { .test = test };
 	bool alloc_fail = false;
+	bool can_use_kfree_rcu = !IS_BUILTIN(CONFIG_SLUB_KUNIT_TEST);
 	bool perf_events_enabled;
 	bool slab_kprobes_enabled;
 
@@ -455,7 +464,7 @@ static void test_kmalloc_kfree_nolock(struct kunit *test)
 		for (j = 0; j < NR_OBJECTS; j++) {
 			gfp_t gfp = (i % 2) ? GFP_KERNEL : GFP_KERNEL_ACCOUNT;
 
-			objects[j] = kmalloc(64, gfp);
+			objects[j] = kmalloc_obj(*objects[j], gfp);
 			if (!objects[j]) {
 				j--;
 				while (j >= 0)
@@ -464,8 +473,13 @@ static void test_kmalloc_kfree_nolock(struct kunit *test)
 				goto cleanup;
 			}
 		}
-		for (j = 0; j < NR_OBJECTS; j++)
-			kfree(objects[j]);
+
+		for (j = 0; j < NR_OBJECTS; j++) {
+			if (can_use_kfree_rcu && (i % 2))
+				kfree_rcu(objects[j], rcu);
+			else
+				kfree(objects[j]);
+		}
 	}
 
 cleanup:
@@ -504,8 +518,8 @@ static struct kunit_case test_cases[] = {
 	KUNIT_CASE(test_kfree_rcu_wq_destroy),
 	KUNIT_CASE(test_leak_destroy),
 	KUNIT_CASE(test_krealloc_redzone_zeroing),
-#ifdef SLUB_KUNIT_TEST_KMALLOC_KFREE_NOLOCK
-	KUNIT_CASE_SLOW(test_kmalloc_kfree_nolock),
+#ifdef SLUB_KUNIT_TEST_KMALLOC_NOLOCK_AND_FRIENDS
+	KUNIT_CASE_SLOW(test_kmalloc_nolock_and_friends),
 #endif
 	{}
 };

-- 
2.53.0


