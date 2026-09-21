Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 115E1C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 07:58:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B1936B00DF; Mon, 21 Sep 2026 03:58:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1134A6B00E1; Mon, 21 Sep 2026 03:58:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF6406B00E2; Mon, 21 Sep 2026 03:58:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1C726B00DF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:58:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0DAE180323
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:58:24 +0000 (UTC)
X-FDA: 85237016928.22.E1E582D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3D1AA180003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:58:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F7gaLOOy;
	spf=pass (imf06.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789977502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yijECeyPSWNw4ynQbXuj4ormaGJLP5eNf5p0NnJNYTA=;
	b=4IqGuU/C0Vxxbm8T3eTnhLjMuCs5G5wTd2DIj0J9iulwtz3+55RRW8hASNxC8YIB9qwNOh
	YlqN7K3nTXLShPZbDOipm9DVTr6ttYeBJ90vUvLQ6abp/xSqwcbCQYqWHAU1yZaHLkj9BL
	gdy1U3CRnLZHTrxlxKmVejdnMukV8mc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789977502;
	b=INKAS5CjchD4gBIJhBgit4eDjcL1J6r4XDKDpU9aBBIAy56EoEte8KDY7l2CrsF/E5eE4s
	jOuSoxJL2UK6HWrEQUScT24cR+3Ws0LQycnIgdT+525lWBrrdFfMkF8TcV/Rs5WW2p5sbG
	VKluu4nusGv5F6n/sNGlyr2I8OGUu7o=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F7gaLOOy;
	spf=pass (imf06.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DDFA044DEB;
	Mon, 21 Sep 2026 07:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF991F0089F;
	Mon, 21 Sep 2026 07:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789977500;
	bh=yijECeyPSWNw4ynQbXuj4ormaGJLP5eNf5p0NnJNYTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F7gaLOOyxLvwBiW7gSUta9X63c8Dgm/E8HGRTY2VHCQMCjFT/ne11cizs+X+lvWkG
	 wX1KjpOQEm+9px1QueJc++e57qYKlyBU9gfNJ/OnikvetwQJbBfgovwi/TYYvlSyYT
	 s+Q39M9FmFVZJKK2GA7JYy+8Zz/vsJI5AjF6joWESIutRegzES931DIQ1J47nZE6Zm
	 oDYYtzbpGB3Gyi4+f7vp2e4FbaWzWCyfS1mNPJWuAXvHKJ6HyX1fo/SqyJzTgCxk9E
	 mOQe/tKjsAHoRk7mMrUxL3fOXIhZGF/4he05kJ1a86y6olq9/s3BVPdjhFxOUuClPD
	 m6RNtXsEiz+VQ==
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
Subject: [PATCH v4 5/7] mm/slab: Provide kmalloc type fallback for bucket allocations
Date: Mon, 21 Sep 2026 00:58:16 -0700
Message-Id: <20260921075820.1718334-5-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260921075811.too.775-kees@kernel.org>
References: <20260921075811.too.775-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6106; i=kees@kernel.org; h=from:subject; bh=JttRvJ5Bt7Z1wv5k3OeZaQLY1XifIpQ6GOQSBGFqk9c=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkbHs906rW+v3eOw4TVFQofjDkNs+Xbee77upmkZh9NU T2y7pJYRykLgxgXg6yYIkuQnXuci8fb9nD3uYowc1iZQIYwcHEKwETCOBj+x/c9ThZ6eXPZWZMJ qx8J/r41+aG0x+EkdlaPxb5G3Bo3pRkZ9py0ZZ9T75xktja5xzL9Tojb0ektIf16vUxb6gu3Kv3 gAQA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: hf1j8kecb99a8nj3brs89f3hixp35ioh
X-Rspamd-Queue-Id: 3D1AA180003
X-HE-Tag: 1789977502-792318
X-HE-Meta: U2FsdGVkX1+XqPsculJrhcA+PGxo6ozoTErNPbZNWkKX+Ju3n8PomKP1f8QAAQD4oPAY0bFOw7xtfDPmfTqmA7OJxbSnjIlTCgnaWzDaXaOd9CUZogyPUWFJLWDAKa4HAJ+XXON85/Ohp9yiRIe8ysW0sDp7MPAqiqzWG1hdKgppH8E9wLdl1hgzHNg0uBqFySsGh28UDSH7lt8CFBWqgeEmO8//3vZUwJA3PmqghO8wFayfDrH4voaQSFi+GrhXLpb9YwJ/ExKYcg9Y7p0XpYOix8JDn2fqOoxfLPyHodmlVZ34VumgSq4H76rlMaD1aoRwT9f4eNWq+jkKnRmFttM17trk8zdCxIOn3v0Isx6nkuJBKMGIcnW34racR4YkbXqSLKV20sig6F3YQBy/tn7UqryL6KOgnPgtVFlWVL5kWxtM7B08JkrvLK6eogp7maRPnXlmTMOqDINK61XdJS4U8oRSRNOi9Gw5tPb9CLrvfhh4mnRAhG7lVnWma4S4tKxtR8tYCqpnOp8q4iqQWmlZiwr5FCy7lgHp9zFnDAdYsMPp/kp0OLFcp77PRLGUomBEgAGXY5n+00b1CNvzvJszVqsRhvUB3vxsqHamNdaeLgwZn8bR7qZ9X6IAc3Vs6ktkNhagLWt+rVIc9FfTrVzP7ra2rtw51wbmiwavwJ8KuWOIzJh4A8qu9G6YwH5GH4H47EF9q+qyOH1F1HOpuDwX6kUviuHaSxb0xBoKXFrKDSzM8rT/Fc/T7jnbn03H/i/lqAbJrjZiZ7bc+1qWVAPxoLrz++OoXR5wgalTlfqiAqlvOZIr9JG3LMfAro5ImrI3rJD6QIVfRrirm2i/ueIlYHrdvACJQH5EMPxnsiwPyN3vOz9I1yoOfDXgBajIQvjN5SYIkLUBYnJ6NgQdoJ/f5C/ggVZSzd200uUaqVyd/FDszmlspGld7vvAv5QbOTd7jVzeCWQ+67idj+d
 LJV/8d/U
 I8i1F4IDMvxI24rHzVSbNg4IlL/AQAx3wqHm9pKYc12l8MkAV+anGAaOxmIEWDO63r1Pfy88LKhLipeZXfXgwt7zuPnO4+BtylKy8lOEIboqtGIadpYBoigQVHBD+NGCQoOxuo8JKKbHsCPv4PD04g1jS58wrbv7PH+vByVA84PwqTTHg+5FHO/kaM0ToOQ8BB0PLvqkZ4EvkBNDtU4o/wDFCj2nduesG3fr2H8D8KhBVle+g/i2SB2RNPFt/Ui0noBL7xk2cQIs5nu7/ai+mbEp0iKwjFyfP/dQBsw+ZlP+3VOVRkbo3uI5UfoqcKC8zbJVVKmorcCdQp/KKzPg7xqd9535L/voH/UuPCrqSuo2WyhvO1nDei5FUjWKe6S5a2EpHiHqD9Cov3SSJq0rRsOYNuF5TLO5LsqY1Om4OVeWg3Ay/W4d6bxrAV/IfWbSH1W5pNZEGB66/uVA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmem_buckets_create() clones kmalloc_caches[KMALLOC_NORMAL].
kmalloc_slab() figures out the kmalloc type the caller asks for, but
then ignored it whenever a bucket set was in use, returning a normal
cache regardless. This would be a problem if a caller asked for GFP_DMA,
__GFP_ACCOUNT, etc. None of the current users do this, so there is
problem, but it makes adding new users fragile. For example, skb data[1]
needs to handle GFP_DMA (rarely) and __GFP_ACCOUNT (often).

Send those allocations to the general caches instead so nothing breaks and
regular allocations remain isolated with the bucket. The kmem_bucket_type
enum contains only a single item here, but will be expanded in the next
patch.

Built and tests pass with ARCH=x86_64 defconfig with GCC 16.2.0, with
CONFIG_SLAB_BUCKETS as y and n.

Assisted-by: LLM
Link: https://lore.kernel.org/all/04debe19-bbe8-4b5f-9668-753d1f97832d@redhat.com/ [1]
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
 include/linux/slab.h   | 13 +++++++++++
 mm/slab.h              | 23 ++++++++++++++++--
 lib/tests/slub_kunit.c | 53 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 87 insertions(+), 2 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 18a2351f9084..ab9ab3d34847 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -742,6 +742,19 @@ typedef struct kmem_cache * kmem_buckets[KMALLOC_SHIFT_HIGH + 1];
 
 extern kmem_buckets kmalloc_caches[NR_KMALLOC_TYPES];
 
+/*
+ * The kmalloc types a bucket set can hold a copy of. This is deliberately not
+ * enum kmalloc_cache_type: the KMALLOC_PARTITION copies are all "normal" to a
+ * bucket set, which already separates what they were there to separate, so
+ * indexing by those would mean up to KMALLOC_PARTITION_CACHES_NR unusable
+ * rows per set. Allocations of any type not listed here are served by the
+ * general caches.
+ */
+enum kmem_bucket_type {
+	KMEM_BUCKET_NORMAL = 0,
+	NR_KMEM_BUCKET_TYPES
+};
+
 /*
  * Define gfp bits that should not be set for KMALLOC_NORMAL.
  */
diff --git a/mm/slab.h b/mm/slab.h
index 8fd6835e4235..7f1bfee83b92 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -421,6 +421,26 @@ static inline unsigned int size_index_elem(unsigned int bytes)
 	return (bytes - 1) / 8;
 }
 
+/*
+ * Which set of buckets to use for the given kmalloc_cache_type. If not
+ * handled by the kmem_buckets, fall back to general caches.
+ */
+static inline kmem_buckets *
+kmalloc_choose_bucket(kmem_buckets *bucket, enum kmalloc_cache_type type)
+{
+	enum kmem_bucket_type btype;
+
+	if (!bucket)
+		return &kmalloc_caches[type];
+
+	if (type <= KMALLOC_PARTITION_END)
+		btype = KMEM_BUCKET_NORMAL;
+	else
+		return &kmalloc_caches[type];	/* No set holds a row for it. */
+
+	return &bucket[btype];
+}
+
 /*
  * Find the kmem_cache structure that serves a given size of
  * allocation
@@ -438,8 +458,7 @@ kmalloc_slab(size_t size, kmem_buckets *b, gfp_t flags, kmalloc_token_t token,
 	if (alloc_flags & SLAB_ALLOC_NO_OBJ_EXT)
 		type = KMALLOC_NO_OBJ_EXT;
 
-	if (!b)
-		b = &kmalloc_caches[type];
+	b = kmalloc_choose_bucket(b, type);
 	if (size <= 192)
 		index = kmalloc_size_index[size_index_elem(size)];
 	else
diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index d6467dd5cf9b..823607e06248 100644
--- a/lib/tests/slub_kunit.c
+++ b/lib/tests/slub_kunit.c
@@ -683,6 +683,58 @@ static void test_kmem_buckets_destroy(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, 2, slab_errors);
 }
 
+/*
+ * A bucket set holds only the kmalloc types it was created with, so an
+ * allocation that asks for a different one has to come from the general
+ * caches. Check that it does, rather than being served a normal cache that
+ * does not satisfy what the flags asked for.
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
+	b = kmem_buckets_create("test_buckets", 0, 0, INT_MAX, NULL);
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
+	/* Nor can one that has to be accounted. */
+	if (IS_ENABLED(CONFIG_MEMCG) && !mem_cgroup_kmem_disabled()) {
+		p = kmem_buckets_alloc(b, 128, GFP_KERNEL | __GFP_ACCOUNT);
+		KUNIT_ASSERT_NOT_NULL(test, p);
+		c = virt_to_slab(p)->slab_cache;
+		kfree(p);
+
+		KUNIT_EXPECT_TRUE_MSG(test, strstarts(c->name, "kmalloc-cg-"),
+				      "expected an accounted cache, got %s", c->name);
+	}
+}
+
 static struct kunit_case test_cases[] = {
 	KUNIT_CASE(test_clobber_zone),
 
@@ -709,6 +761,7 @@ static struct kunit_case test_cases[] = {
 	KUNIT_CASE(test_kmem_buckets_alignment),
 	KUNIT_CASE(test_kmem_buckets_disabled),
 	KUNIT_CASE(test_kmem_buckets_destroy),
+	KUNIT_CASE(test_kmem_buckets_type_fallback),
 	{}
 };
 
-- 
2.34.1


