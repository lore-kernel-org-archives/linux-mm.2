Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96B65CA5FF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:21:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E33FC6B009E; Tue,  6 Oct 2026 05:20:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB8B56B009B; Tue,  6 Oct 2026 05:20:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCFB16B00A1; Tue,  6 Oct 2026 05:20:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4AFA6B009B
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:20:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2B41BA5ECB
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:20:42 +0000 (UTC)
X-FDA: 85291656324.10.6FE69DC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 58C681C0006
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:20:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IrxZAqAk;
	spf=pass (imf18.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791278440;
	b=zozkt/SES9637udBbUftZKAyF1B4O1uFbK5me23BZ/Jm0hi2CrhqfqtWAJ8/OL+TBqoXay
	KUTopiBzycAXd+PF/6FTpwMGxTlAdQci6Rctl/zgJiQxIqR4nZQIEzIy20OEYDLHVxLwnF
	J0XBdeiNyoGky2003bQ2qLbZp8fcQLM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IrxZAqAk;
	spf=pass (imf18.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791278440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pwKbDoq6iSAvWzodLVAwDaQk8venNDlb5LaSpx0zjmU=;
	b=7Jg+b1GpUdBl3cA7g64T9+WJpmuju/L1UVwHTHW5DeCNPORtwpMuYSUkooe1CLwgNKQk0k
	8kFLMlfdH1HbXgYo0FQ8kkIgNPfwwliRMB8K3aAfsel5y6Ymp8dEdROESXszG57J+W5BU0
	bdxY+2/mbGaww+Zey7U+jHF9/+SEi7o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CEBD447C2;
	Tue,  6 Oct 2026 09:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2FE1F008A5;
	Tue,  6 Oct 2026 09:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791278436;
	bh=pwKbDoq6iSAvWzodLVAwDaQk8venNDlb5LaSpx0zjmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IrxZAqAkAnXAWdCx/BtUy1b63fNmD0zRoGFoBOtlw17uoMwWdPVRiHm1FTfe8nYY4
	 vVex+OpWoX120ae5VMv7lJYX/CxgnUYIAhdL67tVbXZGzrG3N9aY/1wIh1HKIoO9WD
	 hu4WEgLxxn1PHBBmiDcCDqiSMczxID/8n4FoakidgUw1Qkkl1U/4Ka8ulJg/A90RS7
	 RUpxYJd1GNj3QN2ahG+1c49TKbexUAh26d2Js+Q7Dfp87LXF4xm1Lhh7kQ+90OehoS
	 vONDkUCgJ9VXJ5CYYv9bPMT1CPqVQfZ6iJBcm57tFZ9loVRYAx0QvczbW07QVlK7+N
	 JKaIi0raaXzXQ==
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
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v6 7/8] mm/slab: Provide kmalloc type fallback for bucket allocations
Date: Tue,  6 Oct 2026 02:20:33 -0700
Message-ID: <20261006092035.166776-7-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006092030.got.500-kees@kernel.org>
References: <20261006092030.got.500-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6105; i=kees@kernel.org; h=from:subject; bh=dYx28s+IQ11OCGRHcWcMZU79ypXV2MF4t78CsqcAKhg=; b=owGbwMvMwCVmps19z/KJym7G02pJDFlH9iZuu9V5bNsHnpKqlo+9MiFL/ws+v7TyaSXvwtJ4v mr5iAN9HaUsDGJcDLJiiixBdu5xLh5v28Pd5yrCzGFlAhnCwMUpABOZvpvhn8GklrOLprGdZvjH mavMKCd3k3cql7TH/htOjenXJvW8LGH4Kyq7z44ztHwicxLjvzBphwRefr3Pnw+yhhT+WCZYwsT EDwA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 58C681C0006
X-Rspam-User: 
X-Stat-Signature: 55izi7d1idom3jgsbewhcgynee1gguqq
X-HE-Tag: 1791278440-159700
X-HE-Meta: U2FsdGVkX1/3Tm9YjqIShCMM7GDTbSy2j09qRnH3u36cKZQdA1MXeoDaV5jKVwXG3uBysxPod/9xV66gy2cxXYY5v/udr2sz5rT9xcA3fJMHiAdNU72dHkRokBrFI3dIrMb4YQwtZIvN31qVu0/bOTnf1TCvnnxSwXjmzRE4XF0YgR5z18pTAKKstIbOZ3yRu7/yxfPqHdtcRz6NXxfOv6uSg6oyr8IoAkzfPRXbsXWOsyNl+o0NrtE2DaSexO7w/P9uzXWcer5Gv9L0//8ntQSaXES4eQVoi6tsGO9WEIE0NF9OYM1+gV3rHt8jigMxPcKS4IeY20Mza+ViWJb0LAuqx3Dgq1XTA5vRfmm1tMXXOPCr8ptVV/xWubOG9WJZo96c7GOGDqDdXpiJ8tpUduyLmsRjX+qjsmfCaT0MgFhD0HcBYV1jalfKn4dFEz2tXogSalw9Rf8T/2mKzxjb6JUeF94dG9+BqIm8/aXbDGcMdm+Bfv/b2RMwXbpmE+FiAY4YFaUb6Xr+6n3PTae+4UpFM7s0o/uxbf2Zc8y14h+Aet9E48fYrLyZ3HGA0BwOmzupMSi0o2zJ/X6OAULGwB3dJhSuqixHqU1FaeegVa0jdgKJ5PsURS0RnxCIOBZdz7c0srIXHXz/UVOHnsIfw7Z98T/Mp+ckXvJKzFEOjoQwn1araYvQ/uJflwv+AXDoBNBWU026HBAIXqLdYOkbkjBPu3BfRHcKbb9xj3e3kpR88dbY4A7Mm67gWCnV14TEIine8miF6qkWpclfI/r6I7UqEXGZ8exRKOw+8a2MYiHrzujlW2quTG/nD593NCM6kFl3ZlHjLbTOlYHayC6dUE3Q5yYanCfdzaxhSt2YAnTkxBT0ZbgmVyOrghse89n5gtkQrYkoloprWNwm6Dnn4PPcABh9KZfODrw5tLn5olortwdy1+fCyzQqGSAWlpWBf3EIBpf/4wzKeqfSCPr
 0HIY8xxi
 nYIOWUNLm2RXv4JH4Q4dikpZpJZem+aOqzFjhx0gV0eQwEufTnmDhc7intqsGxeETCZvKA6BcGQ3yUpNgTU/pnSg4NjWle3/ANELuJCpUAJUclzKTsrI+b40zBBrSZ4Zk1kN0h0BtEYWHheJNiWhiikkmn4hqvIIgWXUP9o8dipBrBJWFFndVZapBGR73hJV2kxmcXXjuBP0xk/mXQdeDYjpD+/9m9nIkFpUB/XyYY+OZ3EjqBeQPK5YqXFEtLq+zXmjV5fofDmj5/2A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmem_buckets_create() clones kmalloc_caches[KMALLOC_NORMAL].
kmalloc_slab() figures out the kmalloc type the caller asks for, but
then ignored it whenever a bucket set was in use, returning a normal
cache regardless. That breaks an allocation that needs other pages: a
GFP_DMA allocation would not get memory from ZONE_DMA, and a
__GFP_RECLAIMABLE one would miss the reclaimable caches. None of the
current users do this, so there is no problem, but it makes adding new
users fragile. For example, skb data[1] needs to handle GFP_DMA (rarely).

Send those allocations to the general caches instead, so nothing breaks
and regular allocations remain isolated in the set. Accounted
allocations stay in the set: memcg charges each object on its own, in
any cache, so a bucket cache serves them as well as kmalloc-cg-* does.

Built and tests pass with ARCH=x86_64 defconfig with GCC 16.2.0, with
CONFIG_SLAB_BUCKETS as y and n, and with CONFIG_MEMCG as y, n, and y
with "cgroup.memory=nokmem".

Assisted-by: LLM
Link: https://lore.kernel.org/all/04debe19-bbe8-4b5f-9668-753d1f97832d@redhat.com/ [1]
Signed-off-by: Kees Cook <kees@kernel.org>
---
 mm/slab.h              | 19 +++++++++++--
 lib/tests/slub_kunit.c | 63 ++++++++++++++++++++++++++++++++++++++++++
 mm/slab_common.c       |  5 ++++
 3 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 8fd6835e4235..af39a4e47c9e 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -421,6 +421,22 @@ static inline unsigned int size_index_elem(unsigned int bytes)
 	return (bytes - 1) / 8;
 }
 
+/*
+ * Which set of buckets to use for the given kmalloc_cache_type. A bucket set
+ * mirrors the KMALLOC_NORMAL caches, and also serves accounted allocations:
+ * memcg charges each object on its own, in any cache. Types that need
+ * different pages (DMA, reclaimable) or no obj_exts fall back to the
+ * general caches.
+ */
+static inline kmem_buckets *
+kmalloc_choose_bucket(kmem_buckets *bucket, enum kmalloc_cache_type type)
+{
+	if (bucket && (type <= KMALLOC_PARTITION_END || type == KMALLOC_CGROUP))
+		return bucket;
+
+	return &kmalloc_caches[type];
+}
+
 /*
  * Find the kmem_cache structure that serves a given size of
  * allocation
@@ -438,8 +454,7 @@ kmalloc_slab(size_t size, kmem_buckets *b, gfp_t flags, kmalloc_token_t token,
 	if (alloc_flags & SLAB_ALLOC_NO_OBJ_EXT)
 		type = KMALLOC_NO_OBJ_EXT;
 
-	if (!b)
-		b = &kmalloc_caches[type];
+	b = kmalloc_choose_bucket(b, type);
 	if (size <= 192)
 		index = kmalloc_size_index[size_index_elem(size)];
 	else
diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index a2a15a49c5d7..1e6fcbbf8409 100644
--- a/lib/tests/slub_kunit.c
+++ b/lib/tests/slub_kunit.c
@@ -697,6 +697,68 @@ static void test_kmem_buckets_destroy(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, 2, slab_errors);
 }
 
+/*
+ * A bucket set mirrors the normal kmalloc caches, which can serve accounted
+ * allocations too, so those stay in the set. An allocation that needs other
+ * pages (DMA or reclaimable) has to come from the general caches. Check that
+ * it does, rather than being served a cache that does not satisfy what the
+ * flags asked for.
+ */
+static void test_kmem_buckets_type_fallback(struct kunit *test)
+{
+	struct kmem_cache *c;
+	kmem_buckets *b;
+	void *p;
+
+	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS))
+		kunit_skip(test, "needs CONFIG_SLAB_BUCKETS");
+
+	b = kmem_buckets_create("test_buckets", 0, INT_MAX);
+	KUNIT_ASSERT_BUCKETS_CREATED(test, b);
+
+	/* A plain allocation stays isolated in the bucket set. */
+	p = kmem_buckets_alloc(b, 128, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, p);
+	c = cache_of(p);
+	kfree(p);
+	KUNIT_ASSERT_NOT_NULL(test, c);
+
+	KUNIT_EXPECT_TRUE_MSG(test, strstarts(c->name, "test_buckets-"),
+			      "expected a bucket cache, got %s", c->name);
+
+	/* One that needs ZONE_DMA cannot, so it falls back. */
+	if (IS_ENABLED(CONFIG_ZONE_DMA)) {
+		p = kmem_buckets_alloc(b, 128, GFP_KERNEL | GFP_DMA);
+		KUNIT_ASSERT_NOT_NULL(test, p);
+		c = cache_of(p);
+		kfree(p);
+		KUNIT_ASSERT_NOT_NULL(test, c);
+
+		KUNIT_EXPECT_TRUE_MSG(test, strstarts(c->name, "dma-kmalloc-"),
+				      "expected a DMA cache, got %s", c->name);
+	}
+
+	/* Nor can one that is reclaimable. */
+	p = kmem_buckets_alloc(b, 128, GFP_KERNEL | __GFP_RECLAIMABLE);
+	KUNIT_ASSERT_NOT_NULL(test, p);
+	c = cache_of(p);
+	kfree(p);
+	KUNIT_ASSERT_NOT_NULL(test, c);
+
+	KUNIT_EXPECT_TRUE_MSG(test, strstarts(c->name, "kmalloc-rcl-"),
+			      "expected a reclaimable cache, got %s", c->name);
+
+	/* An accounted allocation stays in the set; memcg charges it there. */
+	p = kmem_buckets_alloc(b, 128, GFP_KERNEL | __GFP_ACCOUNT);
+	KUNIT_ASSERT_NOT_NULL(test, p);
+	c = cache_of(p);
+	kfree(p);
+	KUNIT_ASSERT_NOT_NULL(test, c);
+
+	KUNIT_EXPECT_TRUE_MSG(test, strstarts(c->name, "test_buckets-"),
+			      "expected a bucket cache, got %s", c->name);
+}
+
 static struct kunit_case test_cases[] = {
 	KUNIT_CASE(test_clobber_zone),
 
@@ -723,6 +785,7 @@ static struct kunit_case test_cases[] = {
 	KUNIT_CASE(test_kmem_buckets_alignment),
 	KUNIT_CASE(test_kmem_buckets_disabled),
 	KUNIT_CASE(test_kmem_buckets_destroy),
+	KUNIT_CASE(test_kmem_buckets_type_fallback),
 	{}
 };
 
diff --git a/mm/slab_common.c b/mm/slab_common.c
index fb1dd15953a7..6fa02b4ff775 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -420,6 +420,11 @@ static struct kmem_cache *kmem_buckets_cache __ro_after_init;
  * @usersize: How many bytes, starting at @useroffset, may be copied
  *		to/from userspace.
  *
+ * Accounted (__GFP_ACCOUNT) allocations are served by the set like any
+ * other. Allocations that need DMA or reclaimable memory are served by the
+ * general kmalloc caches instead, without the set's isolation or usercopy
+ * region.
+ *
  * Context: Cannot be called within an interrupt, but can be interrupted.
  *
  * Return: a pointer to the cache on success, NULL on failure. When
-- 
2.55.0


