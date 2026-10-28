Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBF5F60A2612
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 19:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Z1aVYGYf
Received: by kanga.kvack.org (Postfix)
	id CDC3B6B05B1; Wed, 28 Oct 2026 15:40:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8CCF6B05B3; Wed, 28 Oct 2026 15:40:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2D2C6B05B4; Wed, 28 Oct 2026 15:40:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87E886B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:40:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F6F3A79B7
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 19:40:21 +0000 (UTC)
X-FDA: 85373051442.12.4A05BF2
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf27.hostedemail.com (Postfix) with ESMTP id A52234000C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 19:40:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Z1aVYGYf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3ok_iagYKCCkPZSNdZLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--kuniyu.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3ok_iagYKCCkPZSNdZLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793216419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4EyCB4tNuDeAFm446x53Kex3Q14IoClXTMY/WxKZafY=;
	b=HD5AT6mST5GusVk3jnBnBID76iMx0sCdqqf9ApuUcJdemw9kAPDcZdEiRu8xDqeL8d/CKc
	DURQtPWorikHjJRGGc3gc2yf8TEywlJgXTG6K0U0JEYALjEAQxW1B/4VSDD0NIeAOkuJI/
	Z3D/Y9Hwt35BYpR0qjrCzWSernZz4Ws=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Z1aVYGYf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3ok_iagYKCCkPZSNdZLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--kuniyu.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3ok_iagYKCCkPZSNdZLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793216419;
	b=tTWWmGIgBgPdQ/paSdsrUoEWtESXXG6jz/OZwG0//lzod/nazblHoCdwmNzUakldYQ1e62
	eLJh2kAiQw7GZlXPAIFU1E7fxZw/iqtDHYvQhlMLG5pcqlAmYx77HQkOqdBNndAEuC+lQQ
	aVu7Ktgd2CmAl3J8UxFTTuQMeKYmboc=
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cdae10aebfdso13249a12.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793216418; x=1793821218; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4EyCB4tNuDeAFm446x53Kex3Q14IoClXTMY/WxKZafY=;
        b=Z1aVYGYfAaooxQQe9cZulWvtOE0OIuN+/tSYZvqO4+ZjdY9nfiHn9hGHSo/nVxmStf
         DY/pvH1PKaCVrPBSOwFQdPl4cfjNLnw8sWRMkZn18s9tnV2ptfASrAFsko5uPX3DeUax
         yw1W2mg48OhEl4547KiOOY4mHxQEc6qDyqD86n5L0+sIA3kwYCCgMWOS5uwmWizer8D4
         TzmG/aOwEKDHe2GrxAG8KYN5e6grbYTzS01VlK3CHPvCpy2ZdqgqZqyDhnLEaaUVIXLy
         qcPm7X6k0NfOeNo0EiDLJEqZtu7ZFMGjXz9TnPpuicLrG9Psree1RVJr7bMkxBP29uWt
         VpEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793216418; x=1793821218;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4EyCB4tNuDeAFm446x53Kex3Q14IoClXTMY/WxKZafY=;
        b=NUB18+0+GwHkGHl4PI7bKxQTbza3TNoaAJnYUFjawyQEArwSaXvoFHqaMzuDcfvFW5
         57k4TNLX3+HnQzKJiJmw5bFYMvMzXM1eOL1wfLZBYMHKT5AWZSJMOnRWhY9eUkCL0Qps
         h5I6t337SaTMdHCxmmqI3UzyeyAbAsz7AfZRw9YggvPRQzlUAv3rYi/6lP8zE6RijlBF
         1SSSaBonADJmqyxnqlasZeDQdtyjwsWvFqrD1ZaIouhnTLktW6qQtZa4mDE+Cb3JgF7W
         RuVn99AytfdHO8FC2fnNGTZCXNgNhfLARWeQO2+QfQYpT4N7nXGDS4JxuG6lIurwpxwo
         rgTQ==
X-Forwarded-Encrypted: i=1; AKwUvByixzPBYQebOMeZtwf1g7dLNYq3spQHmPed7xLRpOaCp13hx+ChyUDVD32ExS+74tuRS1v6VWHzUA==@kvack.org
X-Gm-Message-State: AFq9FYJ2DXNRFRfTZuiH7FcUQlxy4uQ+fMRGSjr2v7ktrgQSpF+LUFd0
	QHTIX1rQvrFRjpSTzyftaojmakwypCWEQOkkZF9orEqvugGP+1NFWh++mhxWmZeA1wcxc9EGGGT
	x0XHPsQ==
X-Received: from pfoo8.prod.google.com ([2002:a05:6a00:1a08:b0:890:4d0b:32b0])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:cc8c:b0:3e0:c346:734a
 with SMTP id adf61e73a8af0-3e91399fb4amr281562637.11.1793216418242; Wed, 28
 Oct 2026 12:40:18 -0700 (PDT)
Date: Wed, 28 Oct 2026 19:39:20 +0000
In-Reply-To: <20261028194014.3671161-1-kuniyu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261028194014.3671161-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261028194014.3671161-3-kuniyu@google.com>
Subject: [PATCH v3 2/2] mm/kasan/kunit: Add double-free tests involving kfree_rcu_sheaf().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>
Cc: Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	Kuniyuki Iwashima <kuniyu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: A52234000C
X-Stat-Signature: im3y68qdaorn5mmndgzh6ww6t5b3a7kd
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793216419-746741
X-HE-Meta: U2FsdGVkX19kJ6zbINsHGSf2jJvNorBsFnfSH8ACGtTlViChu9qnqOh7bgHPlez1YcJwPrP5Y6Wfoxh5FmnNeNJS+jVDZ+IMdSv4HQa14Ify8uptKg2L8u5AXMc4UrOMWHLiUBqwcPRZTEvaVKg1j3rBIsJKmf+CGnWyfGqY30Vk6g/e7MHKlki7zk/YeY49DDm1pJGrj2ZmCAJobLBJ03t9dsDK/B7JKMVlb/qlNpABfmW6sXL20a41IHJt6nZ5tygITrFugc6mlCBM8LLb0fr5IEoeA2NQHKsyi6pvrXmCGBcC2+vT+irG8qeYwA8TcSjuc1bNN5oiNHWunKtLdC9WqUaROGiz1z9G5jNqEo3GlMnwfmU8J9AVxMqh8jqG4re8kOv69EJXxKhNBg34ZmvmIEVwY2CdeQiApM9mUTQqV+ENBLCBAxD+LTHsIEW0Yg+B+DaoQN9pcgOdrFdt1R/EtSL5ysd1MusyUmZ3vRvUuvh42DYIfrNIKrR6LmdWT5A8ukZWwNnQPto6BLcFo5WZIF4Kee0zblwj1xj9ZOUSOawACD3kmE9LhM9P8cdm1GLOOQTlz5/9cqms4xzNd8OMMAw/jMzaIaJM421BFN/yFlu9+/+CCp+yl2FwbsWTgFGfw30Opf5xJZj5GTnk4q87pQeEO1K7af7UVfK9noFN8jfduWlRHTFXZSygoyrc5nWsKpP9x3XAeRsXEwbeWAUJxMb9LFXcQpcgmaJaYl6F0YyIaA972HwrxbtXCjt8jBK2LvIHpfEg6H9ofgjPrcminFYHzlkzg3B4mZ8i6chMn9BllDouS4BnkVVi7KnfdaVLy8KUZ/D0tY0sg/J69Frw4wzcfGml9B3q61I1ldaxW+fVy8MLR3/7eXeKbO1Rr1+Ga5j36IQ57kOVgIXcpUGV8qp9Pt1lGnqDNOIHdmqg8g9Zsz+n8u+0mgnnHUrJOxXyUuc3UGdD0pPH0yI
 ZzFRI3Yz
 K3teqPZsu0hpX03Qi5enA8wRnDAZ1Bf2ZFadKaDYQkjfzRQK1z3DgRkulKdXy+Fp06WsSx3h8Jp8yMvzfO7m9CExZkNFO64cvqEwNZe4nE5MxG6rc4FN2qKGekCLp0mxrX2qeJ8PxDoVHHIaJImg/afdVtt+am8ympg0nOJ068H1HYox6se0jlY1MCmRuPVffmaHMs4aMTLPIjN34UGBVyb4QzQ/Mj5p/GhRqURQS51oVFrsR2AzN2cY+LdmhLJcYVQmMRGJxd+Fl8pe8pMnzZceJMQxNFPNYGwcdkCwrWvHsmdfTJ913Whpqhn1QzHZYRUJf4VwHeMjyA2PO13EZXWtMxrRQr9NVAVj30WB+3hEcAWWu7dUFvRMP4CrwMEt+a9Aq+cqVE/dkS8maPM2PjdbZTlXCxEBUqVo4hL5ADiRkK4jH6dMCTFdCkZryKpx64BjAgTE6pnpfb/P9PVGws3vkrrNC3ECi2Ixc6fUy5m5Wza/clxIeCZ1hrjVsh2TCnRK5fuLau1NmbV7QLRGKRAcO6cnH9xLu1XJ67pqfvqhQWAVHH674JIfT8BA2DzBG1o6JZDwiUzy+bgurPVi7yWE7qJXWBBJvk8ep0xQb4jq9RGLK8HkfclGvSrL1p/zv663cqgJZatBxQXAuCiZbAXFgTTw6mJzXUr0T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The new test cases verify that KASAN immediately detects all
three combinations of double-free involving kfree_rcu_sheaf():

  1. kmem_cache_free() -> kfree_rcu()
  2. kfree_rcu()       -> kmem_cache_free()
  3. kfree_rcu()       -> kfree_rcu()

Each test also evicts the object from the KASAN quarantine and
reallocates it as a victim object before flushing the RCU sheaf
to ensure the live victim object is not poisoned by the rejected
double-free.

Without the patch, all tests fail to detect the 2nd free, and
the victim is poisoned:

  # kmem_cache_double_free_rcu_1: EXPECTATION FAILED at mm/kasan/kasan_test_c.c:1096
  KASAN failure expected in "kfree_rcu(p, rcu)", but none occurred
  ... <splat below is logged here>
  # kmem_cache_double_free_rcu_1: EXPECTATION FAILED at mm/kasan/kasan_test_c.c:1156
  Expected (<...snipped READ_ONCE()...>&(victim->i)); }) == 42, but
      <...snipped READ_ONCE()...>victim->i == 117729280 (0x7046800)

  # kasan: pass:0 fail:3 skip:0 total:3
  # Totals: pass:0 fail:3 skip:0 total:3
  not ok 1 kasan

In all cases, KASAN logs a false-positive use-after-free splat at
READ_ONCE(victim->i), and it has no information about the suspect;
the two stack traces ("Call Trace:" and "Allocated by") are of the
live victim, and "Freed by" is of the RCU task.

  BUG: KASAN: slab-use-after-free in __kmem_cache_double_free_rcu+0x9ee/0xaf0
  Read of size 4 at addr ffff8881076c2938 by task kunit_try_catch/513
  ...
  Freed by task 0:
   ...
   __rcu_free_sheaf_prepare+0xf6/0x240
   rcu_free_sheaf_nobarn+0x31/0xe0
   rcu_core+0x75e/0x16b0

With the patch, all tests can detect the 2nd free immediately and
prevent the victim from being poisoned:

  # kasan: pass:3 fail:0 skip:0 total:3
  # Totals: pass:3 fail:0 skip:0 total:3
  ok 1 kasan

All the stack traces point to the same object for double-free,
and the two free traces are shown in "Call Trace:" and "Freed by"
(or "Last potentially related work creation:" in the 2nd/3rd test
cases).

  BUG: KASAN: double-free in kvfree_call_rcu+0xb6/0x3c0
  Free of addr ffff888108495938 by task kunit_try_catch/511
  ...
  Call Trace:
   <TASK>
   ...
   check_slab_allocation+0x10d/0x120
   __kfree_rcu_sheaf+0x1c/0x2d0
   kvfree_call_rcu+0xb6/0x3c0
   __kmem_cache_double_free_rcu+0x310/0xaf0

  Allocated by task 511:
   ...
   kmem_cache_alloc_noprof+0x14f/0x3c0
   __kmem_cache_double_free_rcu+0x152/0xaf0

  Freed by task 511:
   ...
   kmem_cache_free+0x14f/0x3c0
   __kmem_cache_double_free_rcu+0x2c6/0xaf0

Notably, in the 2nd/3rd test cases, we can detect the 2nd free
before the object is poisoned:

  Memory state around the buggy address:
   ffff888106dc7800: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
   ffff888106dc7880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  >ffff888106dc7900: fc fc fc fc fc fc fc 00 00 00 fc fc fc fc fc fc
                                          ^
  ...
      ok 2 kmem_cache_double_free_rcu_2

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
---
v3: Move migrate_disable() before p = kmem_cache_alloc(),
    and add KASAN_TEST_NEEDS_CONFIG_OFF() for PREEMPT_RT

v2: Move kasan_byte_accessible() check and
    kvfree_rcu_barrier_on_cache() after switch
---
 mm/kasan/kasan_test_c.c | 139 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 139 insertions(+)

diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index b9e167ed5be3..3c9ffee8001b 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -30,6 +30,7 @@
 #include <asm/page.h>
 
 #include "kasan.h"
+#include "../slab.h"
 
 #define OOB_TAG_OFF (IS_ENABLED(CONFIG_KASAN_GENERIC) ? 0 : KASAN_GRANULE_SIZE)
 
@@ -1070,6 +1071,139 @@ static void kmem_cache_double_free(struct kunit *test)
 	kmem_cache_destroy(cache);
 }
 
+#ifndef MODULE
+static void __kmem_cache_double_free_rcu(struct kunit *test, int mode)
+{
+	struct kasan_rcu_info *p, *victim = NULL, **objs;
+	struct kmem_cache *cache;
+	int i, n = 0;
+
+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
+	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_PREEMPT_RT);
+
+	cache = kmem_cache_create("test_cache", sizeof(*p), 0, SLAB_NO_MERGE,
+				  NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);
+
+	if (!cache->sheaf_capacity) {
+		kmem_cache_destroy(cache);
+		kunit_skip(test, "Test requires sheaves");
+	}
+
+	objs = kunit_kcalloc(test, cache->sheaf_capacity * 2, sizeof(*objs),
+			     GFP_KERNEL);
+	if (!objs) {
+		kunit_err(test, "Allocation failed: %s\n", __func__);
+		goto out;
+	}
+
+	migrate_disable();
+
+	p = kmem_cache_alloc(cache, GFP_KERNEL);
+	if (!p) {
+		migrate_enable();
+		kunit_err(test, "Allocation failed: %s\n", __func__);
+		goto out;
+	}
+
+	switch (mode) {
+	case 1:
+		kmem_cache_free(cache, p);
+		/* p is already in quarantine. */
+		KUNIT_EXPECT_KASAN_FAIL(test, kfree_rcu(p, rcu));
+		migrate_enable();
+		break;
+	case 2:
+		/* The actual free order is inverse. */
+		kfree_rcu(p, rcu);
+		KUNIT_EXPECT_KASAN_FAIL(test, kmem_cache_free(cache, p));
+		migrate_enable();
+		break;
+	case 3:
+		kfree_rcu(p, rcu);
+
+		for (i = 0; i < cache->sheaf_capacity - 1; i++) {
+			objs[i] = kmem_cache_alloc(cache, GFP_KERNEL);
+			kfree_rcu(objs[i], rcu);
+		}
+
+		KUNIT_EXPECT_KASAN_FAIL(test, kfree_rcu(p, rcu));
+		migrate_enable();
+
+		/*
+		 * Move the 1st full sheaf to quarantine, keeping the
+		 * 2nd in pcs->rcu_free.
+		 */
+		rcu_barrier();
+		break;
+	}
+
+	/*
+	 * Move p to quarantine if not poisoned yet (case 2,
+	 * or fallback in case 3).
+	 */
+	if (kasan_byte_accessible(p))
+		kvfree_rcu_barrier_on_cache(cache);
+
+	/*
+	 * Evict p from quarantine and reallocate it as a live victim object
+	 * before the RCU sheaf is flushed.
+	 */
+	kasan_quarantine_remove_cache(cache);
+
+	for (i = 0; i < cache->sheaf_capacity * 2; i++) {
+		objs[n] = kmem_cache_alloc(cache, GFP_KERNEL);
+		if (!objs[n])
+			break;
+		if (objs[n] == p) {
+			victim = objs[n];
+			break;
+		}
+		n++;
+	}
+
+	for (i = 0; i < n; i++)
+		kmem_cache_free(cache, objs[i]);
+
+	KUNIT_EXPECT_PTR_EQ(test, victim, p);
+	if (victim != p)
+		goto out;
+
+	WRITE_ONCE(victim->i, 42);
+
+	/*
+	 * If kfree_rcu() failed to reject the double-free above,
+	 * flushing the RCU sheaf will silently poison the live
+	 * victim and cause a false-positive UAF on victim->i.
+	 */
+	kvfree_rcu_barrier_on_cache(cache);
+	KUNIT_EXPECT_EQ(test, READ_ONCE(victim->i), 42);
+
+	if (!READ_ONCE(test_status.report_found))
+		kmem_cache_free(cache, victim);
+out:
+	kmem_cache_destroy(cache);
+}
+
+static void kmem_cache_double_free_rcu_1(struct kunit *test)
+{
+	/* kmem_cache_free() -> kfree_rcu() */
+	__kmem_cache_double_free_rcu(test, 1);
+}
+
+static void kmem_cache_double_free_rcu_2(struct kunit *test)
+{
+	/* kfree_rcu() -> kmem_cache_free() */
+	__kmem_cache_double_free_rcu(test, 2);
+}
+
+static void kmem_cache_double_free_rcu_3(struct kunit *test)
+{
+	/* kfree_rcu() -> kfree_rcu() */
+	__kmem_cache_double_free_rcu(test, 3);
+}
+#endif
+
 static void kmem_cache_invalid_free(struct kunit *test)
 {
 	char *p;
@@ -2239,6 +2373,11 @@ static struct kunit_case kasan_kunit_test_cases[] = {
 	KUNIT_CASE(kfree_via_phys),
 	KUNIT_CASE(kmem_cache_oob),
 	KUNIT_CASE(kmem_cache_double_free),
+#ifndef MODULE
+	KUNIT_CASE(kmem_cache_double_free_rcu_1),
+	KUNIT_CASE(kmem_cache_double_free_rcu_2),
+	KUNIT_CASE(kmem_cache_double_free_rcu_3),
+#endif
 	KUNIT_CASE(kmem_cache_invalid_free),
 	KUNIT_CASE(kmem_cache_rcu_uaf),
 	KUNIT_CASE(kmem_cache_rcu_reuse),
-- 
2.56.0.313.g2479322e68-goog


