Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8C02CA5FF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:20:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EAD96B0099; Tue,  6 Oct 2026 05:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04C1A6B00A0; Tue,  6 Oct 2026 05:20:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1D1F6B009D; Tue,  6 Oct 2026 05:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E8246B0093
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:20:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 17E97A76ED
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:20:39 +0000 (UTC)
X-FDA: 85291656198.16.FFDAA63
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6ACE6100006
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:20:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J4co+Zpc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791278437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RRyPEkZ+ZfmK6tjBW72oAefzXONIUsLRfqoAHzypc3s=;
	b=p3DCuAGso+FtXpHq9vyvXRiiM4GtXmJenbfwfzaIq8X60N3PQ6NwQCyIcx/8Y7tPGi+pzL
	arOdrHbrfPkowVqTM6sHyYzvoU2oXEnwqAOnNOhb+LOOFz8QpkR61/O0vXP3s+u+OfqlX0
	ZGQMz2ddd+p7qO36VbUl9LHVb3X9SAw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J4co+Zpc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791278437;
	b=ZVupzaLX87Kko9kA77AReXqddpXLiPwRd13TtKwLTDYBi/SFEIpH9TlrYip+iN7ULzdmQr
	Gl1dGi6bYVp7vf1BYJwQzCmNfzeGt5FKO9XACxe+C143GgNE56748TgBlp/vuXH+UCLRQy
	lmoux7wf1b+0vVxwYo78C6/ASkHV/6E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C2F256057A;
	Tue,  6 Oct 2026 09:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7096B1F0089F;
	Tue,  6 Oct 2026 09:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791278436;
	bh=RRyPEkZ+ZfmK6tjBW72oAefzXONIUsLRfqoAHzypc3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J4co+ZpcCJ8t4bVYxlz7ppJ19xOX2Z+P98GC60KCa3ERMO6O69lS8UC7MM18SoDvI
	 s/Lgo1ZJuQB2Qtii2akqe1NpJ23hbjsi7E7wRXd6uwZjYPXaJW688bmmFgThgH0Bli
	 fBhMY2nIMwW0beaDf3H9t1SM8uZHAf/aInl90KsT3wI0nEJEl1jqsh8O41wrXJ//+t
	 KkGZJ4s0djlVAe5fowLygTFmLbQTFc7eqFy/HZAgxTo36VICiJ8IO/IPJBViINoptL
	 x/jr+7NXYQk4EB67SCnunmjnvoURxxDMxbDMzCWh0huDtBXlE99Fx/Q1Syqk64vUaz
	 y1BkZgYGM8J3Q==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v6 6/8] mm/slab: Add tests for the existing kmem_buckets behaviour
Date: Tue,  6 Oct 2026 02:20:32 -0700
Message-ID: <20261006092035.166776-6-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006092030.got.500-kees@kernel.org>
References: <20261006092030.got.500-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10322; i=kees@kernel.org; h=from:subject; bh=k2v7XTUE7M2oSlV7PbZULb9YGZZnAP5BYpCfw9riwUY=; b=owGbwMvMwCVmps19z/KJym7G02pJDFlH9iaWaF63ar82eZX4n72zhZjuJhl3ezPJP9m8XOrww rDTp4Ind5SyMIhxMciKKbIE2bnHuXi8bQ93n6sIM4eVCWQIAxenAEzk7zFGho1CehqnJk+3udFt l/BRcn2Y6Zql6tKzHpVrWiUYJK43vMLw3133yMTfGtwn007fVc7+8yRgXxv/3Hu7VDc+zuea7vN TiAEA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6g3ihr1bj7e8smwypqsprcduhrtuaquc
X-Rspam-User: 
X-Rspamd-Queue-Id: 6ACE6100006
X-Rspamd-Server: rspam08
X-HE-Tag: 1791278437-76144
X-HE-Meta: U2FsdGVkX19RAqgUv/IgDW1MvVpTPZrdVmexMSaR0VRjvuZsN0N2Xri/YERW+EIzT/qSeEJZmSZweFQdY3MdDewxT2yS0ERveO0LC1wWQVyFA8spKtOojfeRTageYtdqi3Afl6FX+Mu99mM6XcjW+cijl26UQVLh8/BtxMmc6syYTtPkDav0I1uezURWsJko9+u7FrKdlnACyh14aSGnpZefOmdiK5kvX/G5C5EXmHYMcBSl9M+xQB8ufYjn2ndbk8KswCjsyNSJSeCzI+cxA9+IEhH7mCuE4fw/uVPn6rtjTAAWlVNC35L2rx/bC+jWOsUiM9ZSZ/9FOO0TgskAq4KQdFvNXooekxgVgVZkIcH+VN5oMulyk5RNAFgI3vtHewNzl9aZyxwCBlfiKF/D8iP8HUPw01YkahqZ8MJQilXFa9Z20a04dSfZAiXijvm23j1mlggHpOn8HADpJqbrXE15th9707oMTqs0gtmNNBs2fm31Eo1ESyXj1tVdTlps7Gk6dbojOpWZDm3kj0mvaPcCMGwSAG1Lg3d63bR91aIRyL2IHUgV+Rtmd45DtMqOwqSvdOrQa6N8UGZSWnRHXEU9VgpGVh9zwke0af2Vsnjmna4SRknKtMvxtuW6jcSOnCRq9yGnZJvBMoAEMLKYYkIXFKyLzyuz5rfd0mgi11yufz39zlD8qHSI4a+yNYmiCY5MwnuiabCBdEbJub6PMjJN4gQ1DCmEGMfmchQXptEKskXrzOdD9VGHwW96xn2A3ipFFV5MQJVnXs24y28WVClXl30MTdaFG1OpC9qDOfKu1KSjVufLDg6qiJ5lsezXKLzKN+7zHLyoPoiePSKmCwsrghjnunXHIWWbBBVx3uxn4fKu4jQsbvTqt2hF0FQLPvBd4nkx0JNhKjQqH9Ie4xXtkuMD5ciuupCqQzA1mlasocGMbg4vtzdkLG6N4YmePm7y8n1iLj2TWxfnlz7
 +Uzg6vqs
 6KWGdqT1dtGowgsLKxSkzvENwUAPaZfqfC2tov9Ik1QQBhYTFXiJHT6nyNcSH2MHYUxRvYR7FZ1803fUKUDAncCxh0Rfw8mZPpnrFhtPeizn7VilVvPZHlp1a9XSbklzf92itdziFzpaqjEtFjkWx3LaEQekThNIjrwFwQAoS4bj3yfjCWYEZmrIvlRhWbo/lnoqyelSPdPTEPauRbhRYzZ/V2W58fmIPnkrA74ev73fqC5lbzLpWQEAAUmpa1i8dXc6JcyHGe0+6p+i6z+a5sFZLSA+yDmEY6iNX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmem_buckets has had no test coverage since it was added. Add tests,
including stuff unique to the bucket design:

 - A bucket allocation comes from a cache of the set's own, and that
   cache carries SLAB_NO_MERGE.

 - Each size is served by a cache of the set, of the size kmalloc()
   rounds it up to, including 96 and 192, which are not powers of two and
   which kmalloc shares with a larger class on some configurations. Sizes
   above KMALLOC_MAX_CACHE_SIZE go to the page allocator instead, bucket
   set or not.

 - Each cache is aligned like the kmalloc cache it mirrors.

 - With CONFIG_SLAB_BUCKETS=n, kmem_buckets_create() still returns a
   non-NULL (zero size alloc pointer), so that callers only have to check
   for failure, and allocations through it come from the general caches.

 - Destroying a set takes its caches down rather than only freeing the
   set, which is what a module creating one on each load depends on.
   A set freed without its caches would leave the names taken, and the
   next load would warn about every one of them. This test skips when
   KFENCE serves its allocation, since a KFENCE object is in none of the
   cache's slabs for the teardown to find.

The tests skip rather than compile out, which is useful for testing
the CONFIG_SLAB_BUCKETS=n behaviors.

Built and tests passing (with expected skips) on ARCH=x86_64 defconfig
with GCC 16.2.0, with CONFIG_SLAB_BUCKETS as y and n.

Assisted-by: LLM
Signed-off-by: Kees Cook <kees@kernel.org>
---
 lib/tests/slub_kunit.c | 228 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 228 insertions(+)

diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index e3b63f0338d5..a2a15a49c5d7 100644
--- a/lib/tests/slub_kunit.c
+++ b/lib/tests/slub_kunit.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <kunit/test.h>
 #include <kunit/test-bug.h>
+#include <kunit/resource.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -9,6 +10,7 @@
 #include <linux/delay.h>
 #include <linux/perf_event.h>
 #include <linux/kprobes.h>
+#include <linux/kfence.h>
 #include "../mm/slab.h"
 
 static struct kunit_resource resource;
@@ -474,6 +476,227 @@ static int test_init(struct kunit *test)
 	return 0;
 }
 
+/* Destroy buckets on test exit so a failed KUNIT_ASSERT_*() doesn't leak. */
+KUNIT_DEFINE_ACTION_WRAPPER(destroy_buckets, kmem_buckets_destroy, kmem_buckets *);
+
+#define KUNIT_ASSERT_BUCKETS_CREATED(test, b)					\
+	do {									\
+		KUNIT_ASSERT_NOT_NULL(test, b);					\
+		KUNIT_ASSERT_EQ(test, 0,					\
+				kunit_add_action_or_reset(test,			\
+							  destroy_buckets, b)); \
+	} while (0)
+
+/*
+ * The cache an allocation came from, or NULL if it came from no cache at
+ * all, e.g. a size too big for any of them is served by the page allocator.
+ */
+static struct kmem_cache *cache_of(void *p)
+{
+	struct slab *slab = virt_to_slab(p);
+
+	return slab ? slab->slab_cache : NULL;
+}
+
+/*
+ * A bucket set exists to keep its allocations out of the caches everything
+ * else uses, so check the two things that make that true: they come from a
+ * cache of the set's own, and that cache is never merged into another.
+ */
+static void test_kmem_buckets_isolation(struct kunit *test)
+{
+	struct kmem_cache *bucket_cache, *general_cache;
+	kmem_buckets *b;
+	void *p, *q;
+
+	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS))
+		kunit_skip(test, "needs CONFIG_SLAB_BUCKETS");
+
+	b = kmem_buckets_create("isolated_buckets", 0, INT_MAX);
+	KUNIT_ASSERT_BUCKETS_CREATED(test, b);
+
+	/*
+	 * Free each allocation before asserting on the next one: the cache
+	 * outlives its objects, so nothing below needs them, and an assertion
+	 * that leaves one behind would make the deferred teardown report a
+	 * cache that is still in use.
+	 */
+	p = kmem_buckets_alloc(b, 128, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, p);
+	bucket_cache = cache_of(p);
+	kfree(p);
+	KUNIT_ASSERT_NOT_NULL(test, bucket_cache);
+
+	KUNIT_EXPECT_TRUE_MSG(test, strstarts(bucket_cache->name, "isolated_buckets-"),
+			      "expected a bucket cache, got %s", bucket_cache->name);
+
+	/*
+	 * Cache merging is on by default, and a bucket cache merged into a
+	 * same-sized general one would quietly undo the whole separation.
+	 */
+	KUNIT_EXPECT_TRUE(test, bucket_cache->flags & SLAB_NO_MERGE);
+
+	q = kmalloc(128, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, q);
+	general_cache = cache_of(q);
+	kfree(q);
+	KUNIT_ASSERT_NOT_NULL(test, general_cache);
+
+	KUNIT_EXPECT_PTR_NE(test, bucket_cache, general_cache);
+}
+
+/*
+ * Each size is served by a cache of the set, of the size kmalloc() rounds it
+ * up to, including the size classes that are not powers of two, which kmalloc
+ * shares with a larger class on some configurations. Sizes past the largest
+ * cache are served by the page allocator, bucket set or not.
+ */
+static void test_kmem_buckets_sizes(struct kunit *test)
+{
+	static const size_t sizes[] = { 8, 96, 192, 1024, 4096 };
+	struct kmem_cache *c;
+	kmem_buckets *b;
+	void *p;
+	int i;
+
+	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS))
+		kunit_skip(test, "needs CONFIG_SLAB_BUCKETS");
+
+	b = kmem_buckets_create("sized_buckets", 0, INT_MAX);
+	KUNIT_ASSERT_BUCKETS_CREATED(test, b);
+
+	for (i = 0; i < ARRAY_SIZE(sizes); i++) {
+		p = kmem_buckets_alloc(b, sizes[i], GFP_KERNEL);
+		KUNIT_ASSERT_NOT_NULL(test, p);
+		c = cache_of(p);
+		kfree(p);
+		KUNIT_ASSERT_NOT_NULL(test, c);
+
+		KUNIT_EXPECT_TRUE_MSG(test, strstarts(c->name, "sized_buckets-"),
+				      "size %zu: expected a bucket cache, got %s",
+				      sizes[i], c->name);
+		KUNIT_EXPECT_EQ_MSG(test, c->object_size,
+				    kmalloc_size_roundup(sizes[i]),
+				    "size %zu: served by %s", sizes[i], c->name);
+	}
+
+	/* Too big for any cache: a folio from the page allocator, not a slab. */
+	p = kmem_buckets_alloc(b, KMALLOC_MAX_CACHE_SIZE + 1, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, p);
+	c = cache_of(p);
+	kfree(p);
+
+	KUNIT_EXPECT_NULL(test, c);
+}
+
+/*
+ * A bucket cache stands in for a kmalloc cache, so it has to be aligned like
+ * one. The DMA layer decides whether a buffer needs bouncing from its size,
+ * on the grounds that a kmalloc cache of that size is already aligned for
+ * the device, so a weaker alignment here is not something a caller can see
+ * coming. Without slab debugging the size implies the alignment and this
+ * holds either way; with it, only the cache's own alignment does.
+ */
+static void test_kmem_buckets_alignment(struct kunit *test)
+{
+	static const size_t sizes[] = { 128, 512, 2048 };
+	struct kmem_cache *bucket_cache, *general_cache;
+	kmem_buckets *b;
+	void *p;
+	int i;
+
+	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS))
+		kunit_skip(test, "needs CONFIG_SLAB_BUCKETS");
+
+	b = kmem_buckets_create("aligned_buckets", 0, INT_MAX);
+	KUNIT_ASSERT_BUCKETS_CREATED(test, b);
+
+	for (i = 0; i < ARRAY_SIZE(sizes); i++) {
+		p = kmem_buckets_alloc(b, sizes[i], GFP_KERNEL);
+		KUNIT_ASSERT_NOT_NULL(test, p);
+		bucket_cache = cache_of(p);
+		KUNIT_EXPECT_TRUE_MSG(test,
+				      IS_ALIGNED((unsigned long)p, ARCH_DMA_MINALIGN),
+				      "size %zu: object %p is not %d byte aligned",
+				      sizes[i], p, (int)ARCH_DMA_MINALIGN);
+		kfree(p);
+
+		p = kmalloc(sizes[i], GFP_KERNEL);
+		KUNIT_ASSERT_NOT_NULL(test, p);
+		general_cache = cache_of(p);
+		kfree(p);
+
+		KUNIT_ASSERT_NOT_NULL(test, bucket_cache);
+		KUNIT_ASSERT_NOT_NULL(test, general_cache);
+		KUNIT_EXPECT_EQ_MSG(test, bucket_cache->align, general_cache->align,
+				    "size %zu: bucket cache aligned to %u, %s to %u",
+				    sizes[i], bucket_cache->align,
+				    general_cache->name, general_cache->align);
+	}
+}
+
+/*
+ * With the feature compiled out, kmem_buckets_create() still returns
+ * something non-NULL so that callers only have to check for failure, and
+ * allocations through it work (i.e. come from the general caches).
+ */
+static void test_kmem_buckets_disabled(struct kunit *test)
+{
+	kmem_buckets *b;
+	struct kmem_cache *c;
+	void *p;
+
+	if (IS_ENABLED(CONFIG_SLAB_BUCKETS))
+		kunit_skip(test, "only meaningful without CONFIG_SLAB_BUCKETS");
+
+	b = kmem_buckets_create("disabled_buckets", 0, INT_MAX);
+	KUNIT_ASSERT_BUCKETS_CREATED(test, b);
+
+	p = kmem_buckets_alloc(b, 128, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, p);
+	c = cache_of(p);
+	kfree(p);
+	KUNIT_ASSERT_NOT_NULL(test, c);
+
+	KUNIT_EXPECT_TRUE_MSG(test, !strstarts(c->name, "disabled_buckets-"),
+			      "expected a general cache, got %s", c->name);
+}
+
+/* Destroying a set has to take its caches down, not just free the set. */
+static void test_kmem_buckets_destroy(struct kunit *test)
+{
+	kmem_buckets *b;
+	void *p;
+
+	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS))
+		kunit_skip(test, "needs CONFIG_SLAB_BUCKETS");
+
+	b = kmem_buckets_create("destroyed_buckets", 0, INT_MAX);
+	KUNIT_ASSERT_BUCKETS_CREATED(test, b);
+
+	/*
+	 * Deliberately leaked, as test_leak_destroy() leaks its own: the
+	 * teardown below has to find it. kmem_cache_destroy() unlists the
+	 * cache either way, so the name is still released.
+	 */
+	p = kmem_buckets_alloc(b, 128, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, p);
+
+	/*
+	 * A KFENCE object is in none of the cache's slabs, so the teardown
+	 * would not find it to report.
+	 */
+	if (is_kfence_address(p)) {
+		kfree(p);
+		kunit_skip(test, "the allocation came from KFENCE");
+	}
+
+	/* Tear the set down now, rather than at exit, to check the report. */
+	kunit_release_action(test, destroy_buckets, b);
+
+	KUNIT_EXPECT_EQ(test, 2, slab_errors);
+}
+
 static struct kunit_case test_cases[] = {
 	KUNIT_CASE(test_clobber_zone),
 
@@ -495,6 +718,11 @@ static struct kunit_case test_cases[] = {
 #if defined(CONFIG_KPROBES) && defined(CONFIG_SMP)
 	KUNIT_CASE_SLOW(test_kmalloc_nolock_and_friends_kprobe),
 #endif
+	KUNIT_CASE(test_kmem_buckets_isolation),
+	KUNIT_CASE(test_kmem_buckets_sizes),
+	KUNIT_CASE(test_kmem_buckets_alignment),
+	KUNIT_CASE(test_kmem_buckets_disabled),
+	KUNIT_CASE(test_kmem_buckets_destroy),
 	{}
 };
 
-- 
2.55.0


