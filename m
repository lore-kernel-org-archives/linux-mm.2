Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42734CA9EBE
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 21:46:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A37CE6B008C; Fri,  9 Oct 2026 17:46:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E98F6B0092; Fri,  9 Oct 2026 17:46:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B09D6B0095; Fri,  9 Oct 2026 17:46:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 60B286B008C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:46:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D68B716048F
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 21:46:48 +0000 (UTC)
X-FDA: 85304422896.14.940D703
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2AE1320007
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 21:46:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CxZ+SOaq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3xWDJagYKCAou4xs84qyyqvo.mywvsx47-wwu5kmu.y1q@flex--kuniyu.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3xWDJagYKCAou4xs84qyyqvo.mywvsx47-wwu5kmu.y1q@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791582407;
	b=2VaqYDgbf/k5E7PzUSk/ykRJus+gJPJbju35CaRyrnAPin7xPx2Cyg8NTGM+t4C7Byew/j
	Va5K+k+6wmAuZjiohNHkPET82B9+/QCaox+BXK/HLRvS576Ijo41R6ovL4zDqYbc/kOUBp
	33JZpkByostR6044qTiiopC7n4PzO8w=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CxZ+SOaq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3xWDJagYKCAou4xs84qyyqvo.mywvsx47-wwu5kmu.y1q@flex--kuniyu.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3xWDJagYKCAou4xs84qyyqvo.mywvsx47-wwu5kmu.y1q@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791582407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8bttx2p1LF4ymQzhEXtCtn+deAYuzqXkmR7IkqHZP+g=;
	b=A8W6Ty8Z4HTAgRZZEmW2GgxPLUZPLU2qvYa6QSrGIsn1P0aRgmTpHYC/Hd9RZ/mioU2k1r
	jBAHL3bCtxP3UUPpmzAJE1NSACIRKfn6wEjWjmntWplSJUvJBDENsR1SQnC6jbi3fp6H89
	0Ld3AgkyWy8KdH28RiVYQ0uE83CqTzw=
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3a8af172664so79455a91.0
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 14:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791582406; x=1792187206; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8bttx2p1LF4ymQzhEXtCtn+deAYuzqXkmR7IkqHZP+g=;
        b=CxZ+SOaqEmFBSv7uq6UKaeKVpOVfzb++CbLrrlIMCKv3tbvlB25tYAu4hf21AZBjL7
         JbYO8AY7XNZ5ygMVjLEseedQJdgpKtXwxuts7ppwuq/ii8uimQa18m/v2XItG+zO5qzn
         2wpLr2EIo2N1a8RGLTGF9I+ZkgkMheRJto/7CSVvUK3s3NrfFhopZJlrQB2pby2zUlEr
         hmcM614sjJhsR1hmWVRnYUgbMbi5f5qw42u4GkVdgR3rMUmDrofIkTApWRgma7ieTg4C
         BK0LLnoOtBRdD8RR5nRnrMSNtfJTsCl0uN1WEf5L7OCbPOQWF5ZZ1Y+nAQ+Mojc1HWTm
         IRKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791582406; x=1792187206;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8bttx2p1LF4ymQzhEXtCtn+deAYuzqXkmR7IkqHZP+g=;
        b=q6Vr4mZVZY0jk6SCxIsPsi6OXvEi4gc86SurnXVV5HUwgWSlwG0IWfAAM1fg/1wUCO
         8zCbWzU45LYaseuEpSUipE9cDeILFZ0NRnqqGemlzB6A3pJvV79NGSKqoM3TphBGsviP
         rPsodLpsaLfZsubHHW+OZjaIVsEzeagdn5x1p0YCKtnoWYAmWUZn8vwjfQ0+XykSW0nk
         7JHtlcNyMaddc2AogIPMGN6dVXSnip0xkv603EMcqMPzdT6dhkzdR3bJydrzf5jY+n0C
         y3TUxXwf6ONB6Xhejmoct1/Cu4Qq/EhS52XdbbfZj3wJxshhVtc2RhZlc6/vd34B4F0t
         JdoQ==
X-Forwarded-Encrypted: i=1; AKwUvBya529vunh8U5ee4V59vt2gwnZkhUFlST7ltFR+B3l1vPZpsahKYzLc85p56aMgYTDIUqLePOTaJw==@kvack.org
X-Gm-Message-State: AFq9FYKyXzJtGENnO/pJHERF+FosWUzZer/ybDUbwObYIQ399893phsb
	KQfTv0kNgjwVJBWQISkCa6ZhV0jlGB+Tzsny39rlnDo60wnXbzKlfVaqxRQ95V8Ke1QrfI5sqCT
	HnqHEAg==
X-Received: from pgmt20.prod.google.com ([2002:a63:2254:0:b0:cc7:e5e0:1b43])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2784:b0:3ab:9cb:b5a5
 with SMTP id 98e67ed59e1d1-3ab3a74739dmr2829199a91.18.1791582405705; Fri, 09
 Oct 2026 14:46:45 -0700 (PDT)
Date: Fri,  9 Oct 2026 21:46:26 +0000
In-Reply-To: <20261009214639.2878857-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20261009214639.2878857-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261009214639.2878857-3-kuniyu@google.com>
Subject: [PATCH 2/2] mm/kasan/kunit: Add double-free tests involving kfree_rcu_sheaf().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>
Cc: Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	Kuniyuki Iwashima <kuniyu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: xwrb7t4o53tgjt4t5mjwn9croof77wt9
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2AE1320007
X-HE-Tag: 1791582406-515877
X-HE-Meta: U2FsdGVkX18m2y2+S+EzPxNGkLgHAIXdlvpgK1ofPd61vl+fCt3eKqiBhxN2I9bM8KAbRy3lma4ca8wtkn2N3Qpa9al7pKv2aQL7/cxzIcWtGZBB2+WTVSAs5baFRQ1I5ru7HEAeaVJwchWi3yaryXiv1OvGDLG86SliDpCnqmfAG+z7Pru6Axaf5a+BCAGOKhZ/LQBH6TOFBloQFX1CCGuWfgbxpjj/U9QIix/yxL7ED+9F1Sg0C98/w6DMcykNxOiuiqVuZ3eODyRY+vzZS9I/JsqvGEnz+536JR4pk+/0fWdx8d8kLdfDmBJXQHWqKENn5NJBA1tYDoedCLvVUmypVdgs73dLMCUxwjYn1/sf/PUJ75WbdBaHdvr4yqcDE5DsMWVEfv5irfdUNncZt6zzHOjXA0vxnr104g6XuQXiKpDbKbw1hykCCr1X/sh/3u4G/lWqhG5uGbMwHB5XTt2zYGRB75Bf3DbyejoL/+t6TrXOetxjHPnGiM2o2GbUNtwRonti6l/CO1K9OFFvDcFt4LGEWDuwUf8LvNIuQY/bzYMJ0nFRSZEIoQq2gCNKohQMtBcoTLqrSTZ9yrb2NJ8Q1MV7Y8rBPJTFZbOQDEgPSe+hWqw1McOSjpHTL7LXKcS442qO4b7LnJcrQoRvMnt0mCCG/OdsdPJp0w4Frnb/Wdv4eBlHYqCgemB+LTrJ9nVI1X3gLkA4WFx/d1ApVS/YHeLdD34Ay9p5KNcobKH9bQcA0K4e0XNDaZA+xSivmYMsVpJPBpV89LuYma2oRqXEAWDgnOhkpaCLna9c6XziZV4VfoK5OWsBz19KoXHYIOKhNVPiNqLejC4Impoq8qh0HVQSnBrVaCALUFtOEzV/vHKkzEityXUvvV2uzLTheP5tL/Je9/7R48Qna/6MLdeWxKshI/0f92PaLvwAfu+6gHrI8rdIkBxwX4y+dDEOdbCYnlsTgOCqB4p41B/
 zK8Ize5M
 DOzxMzFB6NOTiwptcndcTkcInXwdxDacPOJaV15UTKPH3HM0kVDWsXwjxWi00Rr1PSrLCl90469/Mm6UQlu7JMsMeo7p0Qc23Zfs99P4o5qhfSEnqXWJcgpt5KRUJ/Tl/T63eokvrG1pZF/fLG/MfidV0L+UoCXWzrkCjuloIPMXgxykpymP755pGKu3U81QdkCuwUbMwPv8hvPE9O+zUVLSHorVGqXnK/wgAbngw6CjPEBxwUqUMpgkVOwm5SMk1GnqlYQtO65ymO78IoNH9W/MRfxqL4cvHLpOn34AWQ79qonC+AKfHe36E+FdvAHg6LOpMYzAOvnPlI40qtHIAuMlc6i6eiT4KJ9y+gbjJHYG13jbWzMbMnt4MkqO0Xae7ogxDR45DhwwL71bY8smHrkuLnjw2sqWjc9zJ3vchh7qJm3nv60hNOhowYkVjKPy0DZ9Vygwziw8lsgrwo6Mb8tum8bsgTpOexhMQ7J/1p44v7Gw9hpJY02KUQozVpEDeq4ru2Bv8N5TmOe4VYdZKa1yKhaQTbNTNOyJyIxtCnFnk4QRnNEuktXw21JxoEaE/yeTHVx0U2AR0IoAIXKnUzeizGfaoA6C/j2FA/nZVMc9zeJU7uSt1LeMVq38zunMiBZrVTvssyp7OvWRuH5jCZoU/nJmepKlKvnwV/GLKF/8T5+pBHn46AS8wr0rFkonNY2yIXB8bJWfa9/4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
---
 mm/kasan/kasan_test_c.c | 131 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 131 insertions(+)

diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index b9e167ed5be3..60d25eb7cb01 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -30,6 +30,7 @@
 #include <asm/page.h>
 
 #include "kasan.h"
+#include "../slab.h"
 
 #define OOB_TAG_OFF (IS_ENABLED(CONFIG_KASAN_GENERIC) ? 0 : KASAN_GRANULE_SIZE)
 
@@ -1070,6 +1071,131 @@ static void kmem_cache_double_free(struct kunit *test)
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
+	p = kmem_cache_alloc(cache, GFP_KERNEL);
+	if (!p) {
+		kunit_err(test, "Allocation failed: %s\n", __func__);
+		goto out;
+	}
+
+	switch (mode) {
+	case 1:
+		kmem_cache_free(cache, p);
+		/* p is already in quarantine. */
+		KUNIT_EXPECT_KASAN_FAIL(test, kfree_rcu(p, rcu));
+		break;
+	case 2:
+		/* The actual free order is inverse. */
+		kfree_rcu(p, rcu);
+		KUNIT_EXPECT_KASAN_FAIL(test, kmem_cache_free(cache, p));
+
+		/* Move p to quarantine if kmem_cache_free() was rejected. */
+		if (kasan_byte_accessible(p))
+			kvfree_rcu_barrier_on_cache(cache);
+		break;
+	case 3:
+		migrate_disable();
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
@@ -2239,6 +2365,11 @@ static struct kunit_case kasan_kunit_test_cases[] = {
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
2.56.0.385.gd3acb90ef8-goog


