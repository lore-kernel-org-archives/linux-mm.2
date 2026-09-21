Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AEFBC982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 07:58:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFFF46B00E3; Mon, 21 Sep 2026 03:58:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB0AE6B00E4; Mon, 21 Sep 2026 03:58:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99EF16B00E5; Mon, 21 Sep 2026 03:58:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 677A76B00E3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:58:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5FC0C0335
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:58:25 +0000 (UTC)
X-FDA: 85237016970.03.09CF11A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1ECD440002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:58:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DnDCIUYj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789977504;
	b=k8SOcp3N+UZuvUMSaYGoFzeAqL1RYG8uollNJ1YD6ejeLgP+RETmTUO0RZfgRs+VLvT451
	5Wo4hyAC7c3QF5JR2P5Dwcb6P8ZyAhuIk49l/lP5Sm2E9oXqVLeDlqE60SCAT5MnB3IFj1
	WX8BceAN4y6p5p4tca6vFjN/ikwbxNs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DnDCIUYj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789977504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5fdg4lhf7l6/dVSDg/4vChlOULkSsDgKH3aMkmNkZpA=;
	b=Ye6+kH/us92z7q5M4/1dCL6FjAwIu8Cl9qd4T14pfL0ImX27NWh+FBiytB4gjtMOpBCbH3
	09ECWwKfH1y0iqDKBqMvvFreYsmDxQ2u851bv7T/Z+IXJy+hnuwHeZYl+AxHOlH0dGWHpa
	KQM11oYnoqPN7fodcukuCn7C1vtC8m0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E3D5A44FF3;
	Mon, 21 Sep 2026 07:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A571F008A0;
	Mon, 21 Sep 2026 07:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789977500;
	bh=5fdg4lhf7l6/dVSDg/4vChlOULkSsDgKH3aMkmNkZpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DnDCIUYj9hIZIXpHnIxt/PK9wHSQiUd5i9g6ixo4ueszCOAj3NYiDtyBq32Urq9BO
	 hUF8WallP+4OY9VsnqSPkg/q4maHxSAUsX4yszDcroGJJGloWqOjd5UckiLLVY/qRF
	 72YwFTtVSptyazK+lj5BpJv4QiR/Jux+jKw2iVc1PfiBdosAYqRaIkpXwO5C9qOJl1
	 3QATLFG1dmsdGJm/PnGtlJGvDjXp6h5SH3l3dMUZGaFEFaRgz5lfRIbRnO8HXGJbme
	 /y7UvrhOoDz8eYn6oqOVIfhMSN1efoqlR9THHYJV8otFKeAK6rElh7ACMgm9Qknqyt
	 CZQx7pn5AzUaA==
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
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jason Xing <kerneljasonxing@gmail.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Willem de Bruijn <willemb@google.com>,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH v4 6/7] mm/slab: Let a bucket set handle __GFP_ACCOUNT
Date: Mon, 21 Sep 2026 00:58:17 -0700
Message-Id: <20260921075820.1718334-6-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260921075811.too.775-kees@kernel.org>
References: <20260921075811.too.775-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=17623; i=kees@kernel.org; h=from:subject; bh=TFRiW7uKuGLJ5RAboQjREyhJzsC0Jl/peT6jDjy0Hc8=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkbHs+S+xNt8WTXlO75v8Qm+FctfPnxAduiDvMAc8t04 QM7u3MmdZSyMIhxMciKKbIE2bnHuXi8bQ93n6sIM4eVCWQIAxenAEzkz2SGf5bsj/dEyj5S+Hxj OsumzOK4ivbMs3p1BWk3+ZWnfF61fQIjw7TIPu0+jZY/R8VZhZNZIrmM32mEfjs4p0Ny+TRDdda PfAA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1ECD440002
X-Stat-Signature: dkfihrcdgbarhb1e3q975jhhbemm89dg
X-HE-Tag: 1789977503-991629
X-HE-Meta: U2FsdGVkX18qoHSlly6lBVj6aqhK4iCYIgwWgvlyyAHUm47pWdRUYBZzBBY1GvWk1+22L7TS2q42wceLcpFt6SqYqSqX/wM6lzSS714NBNXbwmgs0w+lx9nQFJjApm9od3b41i69Y9H8lG9Umh+abcVCWT2Q3htU8aC9H3kwV/NHAB6oCrM7gJ0o78nG1eb7pSao2YM0et5D9qcCgfZSLtK3tOCaYTpayit1nq+AKrj9RlNo8l1vhPRwsmDcmRWnfs2+R53DqmFIE5wTU5PIherg9niC/MdaMFmS0zcrF5Q7H2658VGZj5VajzcGjY+f2f6brfRA8z4r/INwq09YacYpHOlfvmeXO01M8gkeNO/NzIsgfFGNkVuQsnld8aWzBcxK8+JZJwIY+ov86C5yZPv0XwDanJkxYK+1S1M7XTo0GfcU6XgtZlNfulMkqEtGh3Z7+dyvACvn0KFeBjKd+Umi2CwdvKR0T4bzvphL0uI/5aG36nWuA6Tbz0kV5FhFmjGKIk5OfRUg8qYURlpowxt4YTWYMbsGVwlhCfQ8pj9xkK/+OiQg56hDNIQMOLI13rPv0YsbCOWuQ2YjK709PpR8odefTqExlMc8Lwp3Tsim7+JowA03Qm/fQSnkOAEZ1umPa//Cl2OWxng/0GFZP6MSHXe8jhIg9dJuEKByszYEGrU+Z7SPRiY7Ycr+TJtdNhWt5h4v3R/4zBEszPoDXQrOlReEuQKzsCgqnI4R8RsFquXJ968a7/MysoyiEgGaT44KKcHDr5jIA0ewhOxPwBFFLhzh+2nslxZDSKtf5YRqfiDIemiOBRopN9BjtzZMYX422S4u7YMQ1lSbkcbHZE8iljRdxAHXThJgdejTBI0Z0qXstqHM1+ChE4Q8+S4pZH9mTJO3oCIwdjPKqsxbVdoGdgYNlKlw6Hw6gWkx1t817ZGiz3kO/FGTrpwdSc88Sbo9zk49SH7xPOM9sZC
 In/fs7cu
 fjTFaAAR6xLcS5EcdYYkdC1+gFqKFDwKoMN7is0fW+HcqJIEIYSl5ad33LCyRC5oxnU7UE2vNJsY5Rmj5QeuyIPCzYoeoMx5Qy4O2yC9OYTmH3KRrX/FdlZ3Wi0ywkLdUbrjBMAgRdixSpn03xA6kSDGp/T8Dh38918JnjzO5Y6oHMUsNzc8VrceEhmuZSQVqKTfvnxz+Gk5g2PDMDQm5c0wGW9DCVLrL2dInWXO22UMedIY1iutJQAWPiZ7Andm/sW6iVRhJtnMneFkIrSF6HsmOrc7lr/W8k8ZnucS29SHPtaDqK1yeFVkDeIO2yQ6PONiwlf1Sj+lBRZ54CG1kvV5jCsaTBWqsjEsZTmfG0ERDxf8fOFPvp8GGkjnxnhXD8GbPF9tTNLodTFdv4s+IJpsvDKsf/VKo5B36g4u+zLSP0+yojL9gUef3/jhYRN8Hp1ffoL89DXTc/at9t5mbmviDTRqp/YFBo/MqYjTHfVkhroo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A bucket set holds one row of caches, cloned from KMALLOC_NORMAL, and an
allocation of any other kmalloc type falls back to the general caches.
Extend this to handle __GFP_ACCOUNT, so that a single bucket user can
isolate either GFP_KERNEL or GFP_KERNEL_ACCOUNT allocations, as is
needed for skb data, where AF_UNIX uses:

	sk->sk_allocation = GFP_KERNEL_ACCOUNT;

The coverage is selected at bucket creation time:

	b = kmem_buckets_create_types(name, flags, 0, INT_MAX, NULL,
				      BIT(KMEM_BUCKET_NORMAL) |
				      BIT(KMEM_BUCKET_CGROUP));

The prior kmem_buckets_create() function keeps its name and defaults
to only KMEM_BUCKET_NORMAL, leaving existing users as-is.

Only the accounted type is offered. Nothing wants a reclaimable or
no-obj-ext row, and of the twelve places passing GFP_DMA to an skb
allocator, all rare hardware: b44, b43legacy, prestera and s390 ctcm.

The choice is made at creation rather than every set getting every type
because the rows, when populated, are not free. Each holds 13 caches, and
a cache is a 1208 byte struct plus an unconditional per-cpu allocation,
a node struct, and an entry in /proc/slabinfo and under /sys/kernel/slab.

KMEM_BUCKET_CGROUP collapses to KMEM_BUCKET_NORMAL without CONFIG_MEMCG,
exactly as KMALLOC_CGROUP does, so NR_KMEM_BUCKET_TYPES is 1 there and a
bucket set is the same single row it is today. Where the type is asked for
but the system is not creating caches of it (under "cgroup.memory=nokmem")
the row is aliased to the normal one, as new_kmalloc_cache() does for the
general caches, so those allocations stay isolated rather than falling
back to the general caches.

Built and tests pass (and skip as expected) on ARCH=x86_64 defconfig
with GCC 16.2.0 in all combinations of CONFIG_SLAB_BUCKETS=y/n and
CONFIG_MEMCG=y/n/y+"cgroup.memory=nokmem".

Assisted-by: LLM
Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <linux-mm@kvack.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Kuniyuki Iwashima <kuniyu@google.com>
Cc: <linux-hardening@vger.kernel.org>
---
 include/linux/slab.h   |  45 ++++++++++++-
 mm/slab.h              |  23 ++++++-
 lib/tests/slub_kunit.c |  65 +++++++++++++++---
 mm/slab_common.c       | 145 ++++++++++++++++++++++++++++++++---------
 4 files changed, 235 insertions(+), 43 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index ab9ab3d34847..bbc27e4e5e1c 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -752,6 +752,11 @@ extern kmem_buckets kmalloc_caches[NR_KMALLOC_TYPES];
  */
 enum kmem_bucket_type {
 	KMEM_BUCKET_NORMAL = 0,
+#ifdef CONFIG_MEMCG
+	KMEM_BUCKET_CGROUP,
+#else
+	KMEM_BUCKET_CGROUP = KMEM_BUCKET_NORMAL,
+#endif
 	NR_KMEM_BUCKET_TYPES
 };
 
@@ -903,9 +908,43 @@ void *kmem_cache_alloc_lru_noprof(struct kmem_cache *s, struct list_lru *lru,
 bool kmem_cache_charge(void *objp, gfp_t gfpflags);
 void kmem_cache_free(struct kmem_cache *s, void *objp);
 
-kmem_buckets *kmem_buckets_create(const char *name, slab_flags_t flags,
-				  unsigned int useroffset, unsigned int usersize,
-				  void (*ctor)(void *));
+kmem_buckets *kmem_buckets_create_types(const char *name, slab_flags_t flags,
+					unsigned int useroffset, unsigned int usersize,
+					void (*ctor)(void *),
+					unsigned int type_mask);
+
+/**
+ * kmem_buckets_create - Create a set of caches that handle dynamic sized
+ *			 allocations via kmem_buckets_alloc()
+ * @name: A prefix string which is used in /proc/slabinfo to identify this
+ *	  cache. The individual caches with have their sizes as the suffix.
+ * @flags: SLAB flags (see kmem_cache_create() for details).
+ * @useroffset: Starting offset within an allocation that may be copied
+ *		to/from userspace.
+ * @usersize: How many bytes, starting at @useroffset, may be copied
+ *		to/from userspace.
+ * @ctor: A constructor for the objects, run when new allocations are made.
+ *
+ * Covers KMEM_BUCKET_NORMAL only. Allocations needing another kmalloc type
+ * are served by the general caches, keeping the type they asked for and
+ * losing only the isolation. Use kmem_buckets_create_types() to cover more.
+ *
+ * Context: Cannot be called within an interrupt, but can be interrupted.
+ *
+ * Return: a pointer to the cache on success, NULL on failure. When
+ * CONFIG_SLAB_BUCKETS is not enabled, ZERO_SIZE_PTR is returned, and
+ * subsequent calls to kmem_buckets_alloc() will fall back to kmalloc().
+ * (i.e. callers only need to check for NULL on failure.)
+ */
+static inline kmem_buckets *kmem_buckets_create(const char *name, slab_flags_t flags,
+						unsigned int useroffset,
+						unsigned int usersize,
+						void (*ctor)(void *))
+{
+	return kmem_buckets_create_types(name, flags, useroffset, usersize, ctor,
+					 BIT(KMEM_BUCKET_NORMAL));
+}
+
 void kmem_buckets_destroy(kmem_buckets *bucket);
 
 /*
diff --git a/mm/slab.h b/mm/slab.h
index 7f1bfee83b92..2af44e09edda 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -435,10 +435,31 @@ kmalloc_choose_bucket(kmem_buckets *bucket, enum kmalloc_cache_type type)
 
 	if (type <= KMALLOC_PARTITION_END)
 		btype = KMEM_BUCKET_NORMAL;
+	else if (IS_ENABLED(CONFIG_MEMCG) && type == KMALLOC_CGROUP)
+		btype = KMEM_BUCKET_CGROUP;
 	else
 		return &kmalloc_caches[type];	/* No set holds a row for it. */
 
-	return &bucket[btype];
+	/*
+	 * Either this row was created, and holds a cache everywhere the
+	 * general caches hold one, or it was never created and holds nothing.
+	 * Test with the KMALLOC_SHIFT_LOW which exists in every configuration.
+	 */
+	if (likely(bucket[btype][KMALLOC_SHIFT_LOW]))
+		return &bucket[btype];
+
+	/*
+	 * A row this set _could_ have held, but was not created with: the type
+	 * mask passed to kmem_buckets_create_types() did not cover what its
+	 * callers actually tried to allocate. Report the mismatch but still
+	 * fall back to the general caches.
+	 *
+	 * At present, only __GFP_ACCOUNT can be missing.
+	 */
+	WARN_ONCE(1,
+		  "kmem_buckets: __GFP_ACCOUNT needs BIT(KMEM_BUCKET_CGROUP) in create mask\n");
+
+	return &kmalloc_caches[type];
 }
 
 /*
diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index 823607e06248..58f800582170 100644
--- a/lib/tests/slub_kunit.c
+++ b/lib/tests/slub_kunit.c
@@ -723,15 +723,63 @@ static void test_kmem_buckets_type_fallback(struct kunit *test)
 				      "expected a DMA cache, got %s", c->name);
 	}
 
-	/* Nor can one that has to be accounted. */
-	if (IS_ENABLED(CONFIG_MEMCG) && !mem_cgroup_kmem_disabled()) {
-		p = kmem_buckets_alloc(b, 128, GFP_KERNEL | __GFP_ACCOUNT);
-		KUNIT_ASSERT_NOT_NULL(test, p);
-		c = virt_to_slab(p)->slab_cache;
-		kfree(p);
+	/*
+	 * An accounted allocation would fall back too, but a bucket set can
+	 * hold that type, so reaching the fallback means the create mask was
+	 * wrong and kmalloc_slab() warns. Not exercised here for that reason;
+	 * test_kmem_buckets_type_covered() checks the type that is asked for.
+	 */
+}
+
+/*
+ * A bucket set created for a kmalloc type keeps those allocations isolated
+ * too, rather than sending them to the general caches. Where nothing creates
+ * accounted caches at all, the row aliases the normal one, so this also
+ * covers tearing down a set whose rows share their caches.
+ */
+static void test_kmem_buckets_type_covered(struct kunit *test)
+{
+	struct kmem_cache *c, *normal_cache;
+	kmem_buckets *b;
+	void *p;
+
+	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS))
+		kunit_skip(test, "needs CONFIG_SLAB_BUCKETS");
+
+	b = kmem_buckets_create_types("covered_buckets", 0, 0, INT_MAX, NULL,
+				      BIT(KMEM_BUCKET_NORMAL) |
+				      BIT(KMEM_BUCKET_CGROUP));
+	KUNIT_ASSERT_BUCKETS_CREATED(test, b);
+
+	p = kmem_buckets_alloc(b, 128, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, p);
+	normal_cache = cache_of(p);
+	kfree(p);
+	KUNIT_ASSERT_NOT_NULL(test, normal_cache);
 
-		KUNIT_EXPECT_TRUE_MSG(test, strstarts(c->name, "kmalloc-cg-"),
-				      "expected an accounted cache, got %s", c->name);
+	KUNIT_EXPECT_TRUE_MSG(test, strstarts(normal_cache->name, "covered_buckets-128"),
+			      "expected the normal bucket cache, got %s",
+			      normal_cache->name);
+
+	/* Accounted, and still in the bucket set rather than kmalloc-cg-*. */
+	p = kmem_buckets_alloc(b, 128, GFP_KERNEL | __GFP_ACCOUNT);
+	KUNIT_ASSERT_NOT_NULL(test, p);
+	c = cache_of(p);
+	kfree(p);
+	KUNIT_ASSERT_NOT_NULL(test, c);
+
+	if (IS_ENABLED(CONFIG_MEMCG) && !mem_cgroup_kmem_disabled()) {
+		KUNIT_EXPECT_TRUE_MSG(test, strstarts(c->name, "covered_buckets-cg-"),
+				      "expected the accounted bucket cache, got %s",
+				      c->name);
+		KUNIT_EXPECT_TRUE(test, c->flags & SLAB_ACCOUNT);
+	} else {
+		/*
+		 * Nothing is creating accounted caches, so the row aliases
+		 * the normal one and the allocation lands there -- isolated
+		 * still, just not separately accounted.
+		 */
+		KUNIT_EXPECT_PTR_EQ(test, c, normal_cache);
 	}
 }
 
@@ -762,6 +810,7 @@ static struct kunit_case test_cases[] = {
 	KUNIT_CASE(test_kmem_buckets_disabled),
 	KUNIT_CASE(test_kmem_buckets_destroy),
 	KUNIT_CASE(test_kmem_buckets_type_fallback),
+	KUNIT_CASE(test_kmem_buckets_type_covered),
 	{}
 };
 
diff --git a/mm/slab_common.c b/mm/slab_common.c
index eb29cfb2f0a9..3861d8b3d849 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -410,9 +410,15 @@ EXPORT_SYMBOL(__kmem_cache_create_args);
 
 static struct kmem_cache *kmem_buckets_cache __ro_after_init;
 
+static int kmem_buckets_create_row(kmem_buckets *b,
+				   enum kmalloc_cache_type type,
+				   const char *name,
+				   slab_flags_t flags, unsigned int useroffset,
+				   unsigned int usersize, void (*ctor)(void *));
+
 /**
- * kmem_buckets_create - Create a set of caches that handle dynamic sized
- *			 allocations via kmem_buckets_alloc()
+ * kmem_buckets_create_types - Create a set of caches that handle dynamic sized
+ *			       allocations via kmem_buckets_alloc()
  * @name: A prefix string which is used in /proc/slabinfo to identify this
  *	  cache. The individual caches with have their sizes as the suffix.
  * @flags: SLAB flags (see kmem_cache_create() for details).
@@ -421,6 +427,11 @@ static struct kmem_cache *kmem_buckets_cache __ro_after_init;
  * @usersize: How many bytes, starting at @useroffset, may be copied
  *		to/from userspace.
  * @ctor: A constructor for the objects, run when new allocations are made.
+ * @type_mask: Which kmalloc types to hold caches for, as a mask of
+ *	       BIT(KMEM_BUCKET_*). KMEM_BUCKET_NORMAL is always included.
+ *	       Allocations of a type that is not covered are served by the
+ *	       general caches instead, so a caller need not know in advance
+ *	       which types its own callers will ask for.
  *
  * Context: Cannot be called within an interrupt, but can be interrupted.
  *
@@ -429,12 +440,13 @@ static struct kmem_cache *kmem_buckets_cache __ro_after_init;
  * subsequent calls to kmem_buckets_alloc() will fall back to kmalloc().
  * (i.e. callers only need to check for NULL on failure.)
  */
-kmem_buckets *kmem_buckets_create(const char *name, slab_flags_t flags,
-				  unsigned int useroffset,
-				  unsigned int usersize,
-				  void (*ctor)(void *))
+kmem_buckets *kmem_buckets_create_types(const char *name, slab_flags_t flags,
+					unsigned int useroffset,
+					unsigned int usersize,
+					void (*ctor)(void *),
+					unsigned int type_mask)
 {
-	unsigned int idx;
+	enum kmem_bucket_type btype;
 	kmem_buckets *b;
 
 	/*
@@ -453,20 +465,87 @@ kmem_buckets *kmem_buckets_create(const char *name, slab_flags_t flags,
 		return NULL;
 
 	flags |= SLAB_NO_MERGE;
+	type_mask |= BIT(KMEM_BUCKET_NORMAL);
+
+	for (btype = 0; btype < NR_KMEM_BUCKET_TYPES; btype++) {
+		enum kmalloc_cache_type src = KMALLOC_NORMAL;
+		slab_flags_t type_flags = 0;
+
+		if (!(type_mask & BIT(btype)))
+			continue;
+
+		/*
+		 * Under CONFIG_MEMCG=n the two types are the same value, so
+		 * the IS_ENABLED() is what keeps the normal row out of here.
+		 */
+		if (IS_ENABLED(CONFIG_MEMCG) && btype == KMEM_BUCKET_CGROUP) {
+			/*
+			 * Aliasing below reads the normal row, so this loop
+			 * must have built it already. That holds only while
+			 * the normal type sorts first.
+			 */
+			BUILD_BUG_ON(KMEM_BUCKET_CGROUP <= KMEM_BUCKET_NORMAL);
+
+			/*
+			 * Nothing anywhere is creating accounted caches, as
+			 * with "cgroup.memory=nokmem". Point this row's
+			 * entries at the normal row's caches, the way
+			 * new_kmalloc_cache() aliases kmalloc_caches[] for
+			 * the same reason. Leaving the row empty instead
+			 * would send every accounted allocation out of the
+			 * set and into the general caches.
+			 */
+			if (mem_cgroup_kmem_disabled()) {
+				memcpy(b[btype], b[KMEM_BUCKET_NORMAL],
+				       sizeof(b[btype]));
+				continue;
+			}
+
+			type_flags = SLAB_ACCOUNT;
+			src = KMALLOC_CGROUP;
+		}
+
+		if (kmem_buckets_create_row(&b[btype], src, name,
+					    flags | type_flags, useroffset,
+					    usersize, ctor))
+			goto fail;
+	}
+
+	return b;
+
+fail:
+	kmem_buckets_destroy(b);
+
+	return NULL;
+}
+EXPORT_SYMBOL(kmem_buckets_create_types);
+
+/*
+ * Build one row of @b by mirroring the general caches of @type: a cache per
+ * kmalloc size, each named "@name-" followed by that cache's own suffix, so
+ * a row of KMALLOC_CGROUP ("kmalloc-cg-96") gets "@name-cg-96".
+ */
+static int kmem_buckets_create_row(kmem_buckets *b,
+				   enum kmalloc_cache_type type,
+				   const char *name,
+				   slab_flags_t flags, unsigned int useroffset,
+				   unsigned int usersize, void (*ctor)(void *))
+{
+	unsigned int idx;
 
 	for (idx = 0; idx < ARRAY_SIZE(kmalloc_caches[KMALLOC_NORMAL]); idx++) {
 		char *short_size, *cache_name;
 		unsigned int cache_useroffset, cache_usersize;
 		unsigned int size, aligned_idx;
 
-		if (!kmalloc_caches[KMALLOC_NORMAL][idx])
+		if (!kmalloc_caches[type][idx])
 			continue;
 
-		size = kmalloc_caches[KMALLOC_NORMAL][idx]->object_size;
+		size = kmalloc_caches[type][idx]->object_size;
 		if (!size)
 			continue;
 
-		short_size = strchr(kmalloc_caches[KMALLOC_NORMAL][idx]->name, '-');
+		short_size = strchr(kmalloc_caches[type][idx]->name, '-');
 		if (WARN_ON(!short_size))
 			goto fail;
 
@@ -484,7 +563,7 @@ kmem_buckets *kmem_buckets_create(const char *name, slab_flags_t flags,
 			if (WARN_ON(!cache_name))
 				goto fail;
 			(*b)[aligned_idx] = kmem_cache_create_usercopy(cache_name, size,
-					kmalloc_caches[KMALLOC_NORMAL][idx]->align,
+					kmalloc_caches[type][idx]->align,
 					flags, cache_useroffset,
 					cache_usersize, ctor);
 			kfree(cache_name);
@@ -495,14 +574,11 @@ kmem_buckets *kmem_buckets_create(const char *name, slab_flags_t flags,
 			(*b)[idx] = (*b)[aligned_idx];
 	}
 
-	return b;
+	return 0;
 
 fail:
-	kmem_buckets_destroy(b);
-
-	return NULL;
+	return -ENOMEM;
 }
-EXPORT_SYMBOL(kmem_buckets_create);
 
 /**
  * kmem_buckets_destroy - Destroy a set of caches made by kmem_buckets_create()
@@ -517,28 +593,35 @@ EXPORT_SYMBOL(kmem_buckets_create);
  */
 void kmem_buckets_destroy(kmem_buckets *bucket)
 {
+	enum kmem_bucket_type btype, t;
 	unsigned int idx, i;
 
 	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS) || ZERO_OR_NULL_PTR(bucket))
 		return;
 
-	for (idx = 0; idx < ARRAY_SIZE(kmalloc_caches[KMALLOC_NORMAL]); idx++) {
-		struct kmem_cache *cache = (*bucket)[idx];
+	for (btype = 0; btype < NR_KMEM_BUCKET_TYPES; btype++) {
+		for (idx = 0; idx < ARRAY_SIZE(bucket[btype]); idx++) {
+			struct kmem_cache *cache = bucket[btype][idx];
 
-		if (!cache)
-			continue;
+			if (!cache)
+				continue;
 
-		/*
-		 * Sizes below arch_slab_minalign() share one cache, which
-		 * kmem_buckets_create() then stores at each of their indices.
-		 * Drop every reference to it before destroying it, so that no
-		 * later pass reads a pointer to a cache that is already gone.
-		 */
-		for (i = idx; i < ARRAY_SIZE(kmalloc_caches[KMALLOC_NORMAL]); i++)
-			if ((*bucket)[i] == cache)
-				(*bucket)[i] = NULL;
+			/*
+			 * A cache is reachable from more than one entry: sizes
+			 * below arch_slab_minalign() share one, and a row that
+			 * kmem_buckets_create_types() aliased onto the normal
+			 * one under "cgroup.memory=nokmem" holds all of them a
+			 * second time. Drop every reference before destroying
+			 * it, so that no later pass reads a pointer to a cache
+			 * that is already gone.
+			 */
+			for (t = 0; t < NR_KMEM_BUCKET_TYPES; t++)
+				for (i = 0; i < ARRAY_SIZE(bucket[t]); i++)
+					if (bucket[t][i] == cache)
+						bucket[t][i] = NULL;
 
-		kmem_cache_destroy(cache);
+			kmem_cache_destroy(cache);
+		}
 	}
 
 	kmem_cache_free(kmem_buckets_cache, bucket);
@@ -1088,7 +1171,7 @@ void __init create_kmalloc_caches(void)
 
 	if (IS_ENABLED(CONFIG_SLAB_BUCKETS))
 		kmem_buckets_cache = kmem_cache_create("kmalloc_buckets",
-						       sizeof(kmem_buckets),
+						       sizeof(kmem_buckets) * NR_KMEM_BUCKET_TYPES,
 						       0, SLAB_NO_MERGE, NULL);
 }
 
-- 
2.34.1


