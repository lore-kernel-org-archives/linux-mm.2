Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 395B4606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 22:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=oG+y/z2l
Received: by kanga.kvack.org (Postfix)
	id C0AA56B090B; Tue, 27 Oct 2026 18:26:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B93CB6B090D; Tue, 27 Oct 2026 18:26:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0E226B090E; Tue, 27 Oct 2026 18:26:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E2296B090B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:26:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DF05F160B77
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:26:05 +0000 (UTC)
X-FDA: 85369840290.24.1A75F57
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3326B140005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:26:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="oG+y/z2l";
	spf=pass (imf09.hostedemail.com: domain of 3-iThagYKCCcNXQLbXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--kuniyu.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3-iThagYKCCcNXQLbXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793139964;
	b=8jJX4MNaWbbd0jPfo2oJ03eabZm98HLaoaqNfuFnEbTqd/srngq+NoqtpONqG+lzP94hyb
	YbFMfuuhlAFflJef5sv58gp7r0amAg6gfozbmw1Ja/aBLQsvdCr+XERGgRboBzq3rHEEyl
	MOGOyOU30qWg+1ItBTaK3t51WB5rezs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="oG+y/z2l";
	spf=pass (imf09.hostedemail.com: domain of 3-iThagYKCCcNXQLbXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--kuniyu.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3-iThagYKCCcNXQLbXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793139964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FNi8nsPJckF1Y5N3TfQ22WZotxjkC0XSS5p26FuZZRo=;
	b=u+M0OXrhaP9b5mNRt1STS4llN+k8puuIxlCjPvrxj5NjMCwiEs4ST39ZIwrt+7lHuZ690/
	+rrl8pp7wcgsfdYgMWErzzfXItAlZGkYwQgB0vYDUYoBBj2Hq3CwpfH78OlyZmaq/Usy1y
	UFCPyDzjFkpNeWyTcm/qDW8bMXgXHNo=
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cd0cf3b1c70so366465a12.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793139963; x=1793744763; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FNi8nsPJckF1Y5N3TfQ22WZotxjkC0XSS5p26FuZZRo=;
        b=oG+y/z2lAjGaZj78CkMKi4R07GxrKAXdbUPJZswiMZyFZleFc6tKEu1iTMBOxwL0xM
         s89UMJDIdD4iB2+ZsI99UrMC7jHqRsOqxHFQw33KiOx83m85DMsl4QcRJhzO8/A7YFdP
         AoawMazDcuNC2XmEsDipQiZGvIEfg2oK6PA6C/HE43YF51ztl0UVz8FjOHpmaHoOpRXF
         JoVtEgIq6nXP5la6lH0oZtFSmRKMkXCqD+JzCtGq/a8hptR/iSq3UIlQ1rj27rSiliB3
         RVaaP0v+b47f9DlO7MYlY2qFydKtjadQdGo2B9+D6CTZq9lBzhZOGya73tsJu16rDKnv
         u4Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793139963; x=1793744763;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FNi8nsPJckF1Y5N3TfQ22WZotxjkC0XSS5p26FuZZRo=;
        b=mbO1D32UgICWw2Jnmgid26eERcN36cMHrW8FZmmrhLO8m7WNTkVVDMgyIuOLTVvCzf
         6Z7Qfh/c/raYuICyAkB3ySwYHEyD+1pXXQ3d8+LHjFAnO/qCCTgwDhCeVkyXOSR5R87F
         gqrES6EhiWKwOgcWU0KLOPcNyyxLZtyOkpgtHSpddXkxY694FfTKzBKWDGEx+3bYJoPU
         8HTHWsNwtsCloxN36hGMznmXRq/Iqz0X1/gLODsXOuXNkItCozPY6c16raeKGDnzBQgJ
         FCWolluUa+QRQk/0UV6n6H/BA1yQmm6a4VvUJv4If7c4mQqGrs67IuYbNe0Ht5wRMEiU
         Uo/A==
X-Forwarded-Encrypted: i=1; AKwUvBxOEPQeMqkKOlyrnusvqAi9SZuzYdtkKGT8gRraaIfMv2OxuroJKKU8LvxupF9RZsetiHQV4/Q6JA==@kvack.org
X-Gm-Message-State: AFq9FYKVuhzrIt+t5/WjINiTZtSAWK8AgdrzNtjrodtf6pVUPk+1Y8dG
	DSHl18WEwN/qgzd9spXjoejY9wwAVEgdTcBjm2PLgaLiGFLnQ6nn2vD7QVFIUJ7/cyT1PyJZLSL
	1ypuFrg==
X-Received: from pjhr18.prod.google.com ([2002:a17:90a:5012:b0:3aa:ee30:1a77])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e83:b0:3ac:9706:772c
 with SMTP id 98e67ed59e1d1-3ae582c2817mr333038a91.60.1793139962594; Tue, 27
 Oct 2026 15:26:02 -0700 (PDT)
Date: Tue, 27 Oct 2026 22:25:46 +0000
In-Reply-To: <20261027222557.1072105-1-kuniyu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261027222557.1072105-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261027222557.1072105-3-kuniyu@google.com>
Subject: [PATCH v2 2/2] mm/kasan/kunit: Add double-free tests involving kfree_rcu_sheaf().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>
Cc: Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	Kuniyuki Iwashima <kuniyu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 3326B140005
X-Stat-Signature: 1dhyhd3azicqz1o6nna8cstbgtqb69u3
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793139964-780606
X-HE-Meta: U2FsdGVkX19rFGxHFAH0aOuluQOgUe/+qfqKk9ExyvZEwB6I/23oKwV6JcbvR3ivmXY/VvN9lkUuup9paq0SjBmXFdCogU1wsv1LxGdk2rcznSpvnEQy56KcEM3KDqrLdHKXeUvYrr2F29iv0yGlGKCR2zGzCdzrl4ptHrNAZLSvPOADUef3a1gLS2NZwCYG1MnDGUZjtgp/C4U9KMOdehZGqJE/DwvI7EjIBhPbDPE82h8Zwqb4NEdc3ckzc07crUWYRSNLgfVvvLh4Xhxt5+6szboXJU4abIiJW8EyPslI+KMrpU1pmFKwGA3tMsBZJULUmrC7fhG7Cd6CuIU1Q5NfP0Ee6KDK9d7CGbO7QN30JnrzfcG9sQLoOSCWnKTH9S7kxF9p1O56XKzNQGE/W42ukl/Xla5AuB/FgehfDg/0SvM2vF4ISdy3TaQLwrNxJfYm9lyMPB+731S6zmup9ktiunRtAofX9gXaunH7JOnirBWt+I/GKUCMNFQn2Im5DvGByH27wfsv0/l6wbhdIEujxAtbRRFGgnFsP+vYZ7FJws1or+JDBl0QHAqGFlvVD1iS6DG88cUeWMd5vGGL4zU4c0/2LMFw1/Uk6muz09DTvKvf/lFJR27Ksc5QQkEt3mFt1iOWbfwHfVfpbhCtB8T4Qeesj1dGyjd7SjDEQYMTmh0KO120lZaS2p8KP98nVC3IX7ZfBqYXTzKX5tDzPSn4o+jEGKVryAMHjFC3OCsS8Af0+mWkJTjHdmzdr6O+9EFO8scG/f5CjcLv0Eraek0BmCeAHSDdP3+wQ1CtB89ws3mq8MTLXlreAMuUm6Da6G3Qmr1me42+qoxH4GbBZxFFDfWiAJ4oJEDutepIk7Kh/Gj12H/eff3wTciP3xgBvajo2FSJ4Qt/XXZ2WeDgmHfjVRmcILLNRAxztsMCYM3P4i6Ta9/ivcROX5O0thznje9odVQqhVz90hYdJWv
 oq14NH4D
 Y+5ri6NGolYivG5wWqMzU5zdBvjdd5kFi+LCuaPIcFn1Sur84Aj3w6dqq/xiXk2q0zkogedlg2eRlrziwZBdBEe3xVp4EXhLqF1TJEYdGBWDvAr87zopKEZbm2ZEZynuAotCKG2FM/JaV3r+v7PC3cDNEgYbQVorLwigw6U+EHmVT01UOfHUabE9XuTifYMJlmKawslMQYwsCtQpcsNvF9cfUcqPqXWDUKFNa8BcFOaKj+ydR3XL41p9IaGct5ysxOCx2z18pjw/YuA6R5d4Y6U/jK7sJ0ho2uVpvQ4Bu7wlB+fXqLDguJXHYmWimvsUvt75OptymPncwff9K7grlNg0vr5QolwBcKhCiurD6ndZnBGvgU+59A9rS3tieL/12U84aIhN1rNRfuL3i8feZ9J1531A3m4N38BQh++N4ZsSzs/gw7IRvxPUAbigh+j7C2jbza0ic1u7kZgYcBF0OfYAYjRzkdY53nj8Vi2l6iMwYMjQGwHZoIdb90maNkWNo+c6F38ft0qHiK0MxE+D69bWQ1ThItLPue7yV/ZPUA7R4Wuu8FksrZ9+2pl5pz2QK5d+cNmtQr3u5GhK31l20AYW7S+l/EyxZEV7nNEORPWx9iqR+MZRB+7zDB1qFmFlUcodZESMjjMc7ebI95flLQhdfFUZP3koimLIRQObVwvfAqHwYXKJkO21IUaGX+HAPKiKMNTIHnKYhdQc=
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
---
v2: Move kasan_byte_accessible() check and
    kvfree_rcu_barrier_on_cache() after switch
---
 mm/kasan/kasan_test_c.c | 134 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 134 insertions(+)

diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index b9e167ed5be3..83c418c0ef87 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -30,6 +30,7 @@
 #include <asm/page.h>
 
 #include "kasan.h"
+#include "../slab.h"
 
 #define OOB_TAG_OFF (IS_ENABLED(CONFIG_KASAN_GENERIC) ? 0 : KASAN_GRANULE_SIZE)
 
@@ -1070,6 +1071,134 @@ static void kmem_cache_double_free(struct kunit *test)
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
@@ -2239,6 +2368,11 @@ static struct kunit_case kasan_kunit_test_cases[] = {
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
2.56.0.307.g5fe7bd680c-goog


