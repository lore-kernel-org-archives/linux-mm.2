Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D1CAC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 12:41:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 354A76B009C; Wed,  6 Aug 2025 08:41:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32CCD6B009D; Wed,  6 Aug 2025 08:41:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 242D36B009E; Wed,  6 Aug 2025 08:41:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 122E96B009C
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:41:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D4D6D59155
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:41:54 +0000 (UTC)
X-FDA: 83746294548.16.A6489D0
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf06.hostedemail.com (Postfix) with ESMTP id E26A618000F
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:41:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=QLUSGTXs;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=iTQxPsYz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754484113; a=rsa-sha256;
	cv=none;
	b=CasmFrB79uroKUhoUMJhFDSs/Z2ED0pv2ggQ2saOs6cibq2YBzvLZFpuOo6Kr+iiPrs3Gm
	2CDNP0q5aLhjJVYcFMeAGLutUvfXLaP6FxcxqHF3QURdlm3EA3HDZcz4OL5z0onWZjt+ZW
	iTy9WUWgk+Uazhw8lxnJygjykpU/uEo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=QLUSGTXs;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=iTQxPsYz;
	dmarc=none;
	spf=none (imf06.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754484113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pjAfZVitxErZt1vrAjky7Diqv9MECrtNO3aybwOppWM=;
	b=43bmLNUaMkVLs2OmtclJSfAcLlKlqvFTLzUmGiDYqY6k85/k/2s3z4u+hozn4nRc6DPlP5
	WgievRBub6X3XXiQwGTPYT31CoDdJTtnkQ1fRMHRp2QUyfbtFxfAhN3VmFQQ2wH/9hA5H4
	SzL1EolGflTAS7230BzVVNNQj16ewH8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1754484111; x=1755088911;
	d=konsulko.se; s=rsa1;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=pjAfZVitxErZt1vrAjky7Diqv9MECrtNO3aybwOppWM=;
	b=QLUSGTXsUL+Tm8j0wA6JYfkbPDriRX2GdqD4uZEnx8yTfZ1xuz++jLyVyXeOXo5HwuEOkz6fDXTEr
	 LSWAr3QbZTCZy/8mhd+shQZi0KIWzYaSA2Qapd5BkSoTPVtQsDDtNrOGU17h5afXxe0lT0DpFvG/yq
	 DH83x7vh8KnJih+te/fMD3uqXWDwk4ZOmZHQcoRnzvz3aGlul8LbmywTDP9dy4dyZ6EqVsiTGVH7Lc
	 kSBhISQci/I6Fzcrwl/IqP9lQ5A7AfoOdpCHVibt7jQFRBHirtvXERQZJpAuoHZ4GrBozp/Czdq6wL
	 FA1oF11j0u8vwfBpXpRyHcC1W2MV1Kg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1754484111; x=1755088911;
	d=konsulko.se; s=ed1;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=pjAfZVitxErZt1vrAjky7Diqv9MECrtNO3aybwOppWM=;
	b=iTQxPsYzR0MXlyDzpqHrU1teSRa1uHSFmwOBDYdRfUKqWbv6vcBDT8xbBlvagvCMbt1iWJ8x2PbEA
	 t9XG+otBQ==
X-HalOne-ID: b8ecdef9-72c2-11f0-bda4-e90f2b8e16ca
Received: from localhost.localdomain (c188-150-224-8.bredband.tele2.se [188.150.224.8])
	by mailrelay2.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id b8ecdef9-72c2-11f0-bda4-e90f2b8e16ca;
	Wed, 06 Aug 2025 12:41:50 +0000 (UTC)
From: Vitaly Wool <vitaly.wool@konsulko.se>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	rust-for-linux@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	bpf@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Vitaly Wool <vitaly.wool@konsulko.se>
Subject: [PATCH v15 2/4] mm/slub: allow to set node and align in k[v]realloc
Date: Wed,  6 Aug 2025 14:41:47 +0200
Message-Id: <20250806124147.1724658-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250806124034.1724515-1-vitaly.wool@konsulko.se>
References: <20250806124034.1724515-1-vitaly.wool@konsulko.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E26A618000F
X-Stat-Signature: rk54umaanxsub87zpykaezb97kbrz5ts
X-HE-Tag: 1754484112-865126
X-HE-Meta: U2FsdGVkX1+baxt3XiXy2lz319Hu9NgVovrEV/XnQi2FG87KDP3J1wxsWsryh6hOpyG7LjwLHyjm9TWP3zN460+OesbaUDYqpqrcGc8BNy204q5xaK89vSCfWuImhO8pGqOt0LRcZdned6jGu0gS7TOAWlZZIzsSBWSjr9xjjhezvlPvinuz0wChX4DiM0tPlrEEB/8DHRTIBts7Uu4q4s7sQtUH4gnSQQ6M1ywCCnftioXVgw4CckQWy4KCcUcR/kUaeMzehwA35rKNoiD6zhViDiB29kNkrTJBU1YWvHbcfkJKNw3J17M9VhqSfUzEZsMgiYWsIyf+0OfFwbrbRNAAvRau68MIJ5SfDfcy43D2rAJ+v4OviPdPIBRHOzU3tuv13/qWt2C4S16l5MeInW3LKEFim0NFrKtEHqAY/Uqv65LtELIggzXaohtYw2HvWdQvbW8qPoMnOYFWp7F3XzlOv669cw5wtkLwpEmyMFYgwxp0qL8OJxkXQXSynZkMu6XFuU0xFB6BJDEIFnfkACz6x6pU868zwJc26M1HBlN7la7JSzGBA7HO4kacSdWQ2GVwmLosypjAUMtuGmGD+U6k6I4j+ymLB/ZDpoWRKX4FkGh6u+WbbbBhC7IBiLtBuBWUg8oKzTScNoZLNReTt+WZoj8OOrqnmc3KKtWA8qIAIOOfobazn+kiI3BPvfXW6WQU77ItiBgss0M4cmFWvnS1Zyy3eBd3kKjlns8o1l3NqjqwteI0P12RzigXqzO3EiyOkQMGA0HiwNXWAKamqrSlCl4G0cdzL32fQnPxbbzGJ1ZxwOLuel9UH+VEyyBEjqgCCzddlRfl9ZwOhLURDzi8UrF5iHoMtUFI3M4yMjo01NhSpsm83c3BPkC9N0UlXLccCDQHgGx4gDoq2y2M4w5dtSuguqAcMzDdVS2G4NQE5YSWBzilQt3ZPm/gZ2YVwVwl4O+AVf0Af5Df3MX
 wGKqQwZ2
 oYMg7nJ5zN2Bt27JLvRkZx2DsHiUPfcxNqTdhmqXg8ifhBv/+SWBvuVcQO+fV7b/IVTBiE/ARj74hgpQatClaKmZRnrMDoIaRD4KcTY6RpT0hl28mzXTRREzI3VC14HZSn2pRBTEpIoLqhPNgpG7nQppQgBc4H35G7i6cgkURKB3POvE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reimplement k[v]realloc_node() to be able to set node and
alignment should a user need to do so. In order to do that while
retaining the maximal backward compatibility, add
k[v]realloc_node_align() functions and redefine the rest of API
using these new ones.

While doing that, we also keep the number of  _noprof variants to a
minimum, which implies some changes to the existing users of older
_noprof functions, that basically being bcachefs.

With that change we also provide the ability for the Rust part of
the kernel to set node and alignment in its K[v]xxx
[re]allocations.

Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
---
 fs/bcachefs/darray.c   |  2 +-
 fs/bcachefs/util.h     |  2 +-
 include/linux/bpfptr.h |  2 +-
 include/linux/slab.h   | 39 +++++++++++++++++-----------
 lib/rhashtable.c       |  4 +--
 mm/slub.c              | 59 ++++++++++++++++++++++++++++++++----------
 6 files changed, 74 insertions(+), 34 deletions(-)

diff --git a/fs/bcachefs/darray.c b/fs/bcachefs/darray.c
index e86d36d23e9e..928e83a1ce42 100644
--- a/fs/bcachefs/darray.c
+++ b/fs/bcachefs/darray.c
@@ -21,7 +21,7 @@ int __bch2_darray_resize_noprof(darray_char *d, size_t element_size, size_t new_
 			return -ENOMEM;
 
 		void *data = likely(bytes < INT_MAX)
-			? kvmalloc_noprof(bytes, gfp)
+			? kvmalloc_node_align_noprof(bytes, 1, gfp, NUMA_NO_NODE)
 			: vmalloc_noprof(bytes);
 		if (!data)
 			return -ENOMEM;
diff --git a/fs/bcachefs/util.h b/fs/bcachefs/util.h
index 6488f098d140..7112fd40ee21 100644
--- a/fs/bcachefs/util.h
+++ b/fs/bcachefs/util.h
@@ -61,7 +61,7 @@ static inline void *bch2_kvmalloc_noprof(size_t n, gfp_t flags)
 {
 	void *p = unlikely(n >= INT_MAX)
 		? vmalloc_noprof(n)
-		: kvmalloc_noprof(n, flags & ~__GFP_ZERO);
+		: kvmalloc_node_align_noprof(n, 1, flags & ~__GFP_ZERO, NUMA_NO_NODE);
 	if (p && (flags & __GFP_ZERO))
 		memset(p, 0, n);
 	return p;
diff --git a/include/linux/bpfptr.h b/include/linux/bpfptr.h
index 1af241525a17..f6e0795db484 100644
--- a/include/linux/bpfptr.h
+++ b/include/linux/bpfptr.h
@@ -67,7 +67,7 @@ static inline int copy_to_bpfptr_offset(bpfptr_t dst, size_t offset,
 
 static inline void *kvmemdup_bpfptr_noprof(bpfptr_t src, size_t len)
 {
-	void *p = kvmalloc_noprof(len, GFP_USER | __GFP_NOWARN);
+	void *p = kvmalloc_node_align_noprof(len, 1, GFP_USER | __GFP_NOWARN, NUMA_NO_NODE);
 
 	if (!p)
 		return ERR_PTR(-ENOMEM);
diff --git a/include/linux/slab.h b/include/linux/slab.h
index d5a8ab98035c..6dc300bac2a1 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -465,9 +465,13 @@ int kmem_cache_shrink(struct kmem_cache *s);
 /*
  * Common kmalloc functions provided by all allocators
  */
-void * __must_check krealloc_noprof(const void *objp, size_t new_size,
-				    gfp_t flags) __realloc_size(2);
-#define krealloc(...)				alloc_hooks(krealloc_noprof(__VA_ARGS__))
+void * __must_check krealloc_node_align_noprof(const void *objp, size_t new_size,
+					       unsigned long align,
+					       gfp_t flags, int nid) __realloc_size(2);
+#define krealloc_noprof(_o, _s, _f)	krealloc_node_align_noprof(_o, _s, 1, _f, NUMA_NO_NODE)
+#define krealloc_node_align(...)	alloc_hooks(krealloc_node_align_noprof(__VA_ARGS__))
+#define krealloc_node(_o, _s, _f, _n)	krealloc_node_align(_o, _s, 1, _f, _n)
+#define krealloc(...)			krealloc_node(__VA_ARGS__, NUMA_NO_NODE)
 
 void kfree(const void *objp);
 void kfree_sensitive(const void *objp);
@@ -1041,18 +1045,20 @@ static inline __alloc_size(1) void *kzalloc_noprof(size_t size, gfp_t flags)
 #define kzalloc(...)				alloc_hooks(kzalloc_noprof(__VA_ARGS__))
 #define kzalloc_node(_size, _flags, _node)	kmalloc_node(_size, (_flags)|__GFP_ZERO, _node)
 
-void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node) __alloc_size(1);
-#define kvmalloc_node_noprof(size, flags, node)	\
-	__kvmalloc_node_noprof(PASS_BUCKET_PARAMS(size, NULL), flags, node)
-#define kvmalloc_node(...)			alloc_hooks(kvmalloc_node_noprof(__VA_ARGS__))
-
-#define kvmalloc(_size, _flags)			kvmalloc_node(_size, _flags, NUMA_NO_NODE)
-#define kvmalloc_noprof(_size, _flags)		kvmalloc_node_noprof(_size, _flags, NUMA_NO_NODE)
+void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), unsigned long align,
+			     gfp_t flags, int node) __alloc_size(1);
+#define kvmalloc_node_align_noprof(_size, _align, _flags, _node)	\
+	__kvmalloc_node_noprof(PASS_BUCKET_PARAMS(_size, NULL), _align, _flags, _node)
+#define kvmalloc_node_align(...)		\
+	alloc_hooks(kvmalloc_node_align_noprof(__VA_ARGS__))
+#define kvmalloc_node(_s, _f, _n)		kvmalloc_node_align(_s, 1, _f, _n)
+#define kvmalloc(...)				kvmalloc_node(__VA_ARGS__, NUMA_NO_NODE)
 #define kvzalloc(_size, _flags)			kvmalloc(_size, (_flags)|__GFP_ZERO)
 
 #define kvzalloc_node(_size, _flags, _node)	kvmalloc_node(_size, (_flags)|__GFP_ZERO, _node)
+
 #define kmem_buckets_valloc(_b, _size, _flags)	\
-	alloc_hooks(__kvmalloc_node_noprof(PASS_BUCKET_PARAMS(_size, _b), _flags, NUMA_NO_NODE))
+	alloc_hooks(__kvmalloc_node_noprof(PASS_BUCKET_PARAMS(_size, _b), 1, _flags, NUMA_NO_NODE))
 
 static inline __alloc_size(1, 2) void *
 kvmalloc_array_node_noprof(size_t n, size_t size, gfp_t flags, int node)
@@ -1062,7 +1068,7 @@ kvmalloc_array_node_noprof(size_t n, size_t size, gfp_t flags, int node)
 	if (unlikely(check_mul_overflow(n, size, &bytes)))
 		return NULL;
 
-	return kvmalloc_node_noprof(bytes, flags, node);
+	return kvmalloc_node_align_noprof(bytes, 1, flags, node);
 }
 
 #define kvmalloc_array_noprof(...)		kvmalloc_array_node_noprof(__VA_ARGS__, NUMA_NO_NODE)
@@ -1073,9 +1079,12 @@ kvmalloc_array_node_noprof(size_t n, size_t size, gfp_t flags, int node)
 #define kvcalloc_node(...)			alloc_hooks(kvcalloc_node_noprof(__VA_ARGS__))
 #define kvcalloc(...)				alloc_hooks(kvcalloc_noprof(__VA_ARGS__))
 
-void *kvrealloc_noprof(const void *p, size_t size, gfp_t flags)
-		__realloc_size(2);
-#define kvrealloc(...)				alloc_hooks(kvrealloc_noprof(__VA_ARGS__))
+void *kvrealloc_node_align_noprof(const void *p, size_t size, unsigned long align,
+				  gfp_t flags, int nid) __realloc_size(2);
+#define kvrealloc_node_align(...)		\
+	alloc_hooks(kvrealloc_node_align_noprof(__VA_ARGS__))
+#define kvrealloc_node(_p, _s, _f, _n)		kvrealloc_node_align(_p, _s, 1, _f, _n)
+#define kvrealloc(...)				kvrealloc_node(__VA_ARGS__, NUMA_NO_NODE)
 
 extern void kvfree(const void *addr);
 DEFINE_FREE(kvfree, void *, if (!IS_ERR_OR_NULL(_T)) kvfree(_T))
diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 3e555d012ed6..fde0f0e556f8 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -184,8 +184,8 @@ static struct bucket_table *bucket_table_alloc(struct rhashtable *ht,
 	static struct lock_class_key __key;
 
 	tbl = alloc_hooks_tag(ht->alloc_tag,
-			kvmalloc_node_noprof(struct_size(tbl, buckets, nbuckets),
-					     gfp|__GFP_ZERO, NUMA_NO_NODE));
+			kvmalloc_node_align_noprof(struct_size(tbl, buckets, nbuckets),
+					     1, gfp|__GFP_ZERO, NUMA_NO_NODE));
 
 	size = nbuckets;
 
diff --git a/mm/slub.c b/mm/slub.c
index c4b64821e680..d01441ea0522 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4845,7 +4845,7 @@ void kfree(const void *object)
 EXPORT_SYMBOL(kfree);
 
 static __always_inline __realloc_size(2) void *
-__do_krealloc(const void *p, size_t new_size, gfp_t flags)
+__do_krealloc(const void *p, size_t new_size, unsigned long align, gfp_t flags, int nid)
 {
 	void *ret;
 	size_t ks = 0;
@@ -4859,6 +4859,16 @@ __do_krealloc(const void *p, size_t new_size, gfp_t flags)
 	if (!kasan_check_byte(p))
 		return NULL;
 
+	/*
+	 * If reallocation is not necessary (e. g. the new size is less
+	 * than the current allocated size), the current allocation will be
+	 * preserved unless __GFP_THISNODE is set. In the latter case a new
+	 * allocation on the requested node will be attempted.
+	 */
+	if (unlikely(flags & __GFP_THISNODE) && nid != NUMA_NO_NODE &&
+		     nid != page_to_nid(virt_to_page(p)))
+		goto alloc_new;
+
 	if (is_kfence_address(p)) {
 		ks = orig_size = kfence_ksize(p);
 	} else {
@@ -4881,6 +4891,10 @@ __do_krealloc(const void *p, size_t new_size, gfp_t flags)
 	if (new_size > ks)
 		goto alloc_new;
 
+	/* If the old object doesn't satisfy the new alignment, allocate a new one */
+	if (!IS_ALIGNED((unsigned long)p, align))
+		goto alloc_new;
+
 	/* Zero out spare memory. */
 	if (want_init_on_alloc(flags)) {
 		kasan_disable_current();
@@ -4903,7 +4917,7 @@ __do_krealloc(const void *p, size_t new_size, gfp_t flags)
 	return (void *)p;
 
 alloc_new:
-	ret = kmalloc_node_track_caller_noprof(new_size, flags, NUMA_NO_NODE, _RET_IP_);
+	ret = kmalloc_node_track_caller_noprof(new_size, flags, nid, _RET_IP_);
 	if (ret && p) {
 		/* Disable KASAN checks as the object's redzone is accessed. */
 		kasan_disable_current();
@@ -4915,14 +4929,19 @@ __do_krealloc(const void *p, size_t new_size, gfp_t flags)
 }
 
 /**
- * krealloc - reallocate memory. The contents will remain unchanged.
+ * krealloc_node_align - reallocate memory. The contents will remain unchanged.
  * @p: object to reallocate memory for.
  * @new_size: how many bytes of memory are required.
+ * @align: desired alignment.
  * @flags: the type of memory to allocate.
+ * @nid: NUMA node or NUMA_NO_NODE
  *
  * If @p is %NULL, krealloc() behaves exactly like kmalloc().  If @new_size
  * is 0 and @p is not a %NULL pointer, the object pointed to is freed.
  *
+ * Only alignments up to those guaranteed by kmalloc() will be honored. Please see
+ * Documentation/core-api/memory-allocation.rst for more details.
+ *
  * If __GFP_ZERO logic is requested, callers must ensure that, starting with the
  * initial memory allocation, every subsequent call to this API for the same
  * memory allocation is flagged with __GFP_ZERO. Otherwise, it is possible that
@@ -4947,7 +4966,8 @@ __do_krealloc(const void *p, size_t new_size, gfp_t flags)
  *
  * Return: pointer to the allocated memory or %NULL in case of error
  */
-void *krealloc_noprof(const void *p, size_t new_size, gfp_t flags)
+void *krealloc_node_align_noprof(const void *p, size_t new_size, unsigned long align,
+				 gfp_t flags, int nid)
 {
 	void *ret;
 
@@ -4956,13 +4976,13 @@ void *krealloc_noprof(const void *p, size_t new_size, gfp_t flags)
 		return ZERO_SIZE_PTR;
 	}
 
-	ret = __do_krealloc(p, new_size, flags);
+	ret = __do_krealloc(p, new_size, align, flags, nid);
 	if (ret && kasan_reset_tag(p) != kasan_reset_tag(ret))
 		kfree(p);
 
 	return ret;
 }
-EXPORT_SYMBOL(krealloc_noprof);
+EXPORT_SYMBOL(krealloc_node_align_noprof);
 
 static gfp_t kmalloc_gfp_adjust(gfp_t flags, size_t size)
 {
@@ -4993,9 +5013,13 @@ static gfp_t kmalloc_gfp_adjust(gfp_t flags, size_t size)
  * failure, fall back to non-contiguous (vmalloc) allocation.
  * @size: size of the request.
  * @b: which set of kmalloc buckets to allocate from.
+ * @align: desired alignment.
  * @flags: gfp mask for the allocation - must be compatible (superset) with GFP_KERNEL.
  * @node: numa node to allocate from
  *
+ * Only alignments up to those guaranteed by kmalloc() will be honored. Please see
+ * Documentation/core-api/memory-allocation.rst for more details.
+ *
  * Uses kmalloc to get the memory but if the allocation fails then falls back
  * to the vmalloc allocator. Use kvfree for freeing the memory.
  *
@@ -5005,7 +5029,8 @@ static gfp_t kmalloc_gfp_adjust(gfp_t flags, size_t size)
  *
  * Return: pointer to the allocated memory of %NULL in case of failure
  */
-void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node)
+void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), unsigned long align,
+			     gfp_t flags, int node)
 {
 	void *ret;
 
@@ -5035,7 +5060,7 @@ void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node)
 	 * about the resulting pointer, and cannot play
 	 * protection games.
 	 */
-	return __vmalloc_node_range_noprof(size, 1, VMALLOC_START, VMALLOC_END,
+	return __vmalloc_node_range_noprof(size, align, VMALLOC_START, VMALLOC_END,
 			flags, PAGE_KERNEL, VM_ALLOW_HUGE_VMAP,
 			node, __builtin_return_address(0));
 }
@@ -5079,14 +5104,19 @@ void kvfree_sensitive(const void *addr, size_t len)
 EXPORT_SYMBOL(kvfree_sensitive);
 
 /**
- * kvrealloc - reallocate memory; contents remain unchanged
+ * kvrealloc_node_align - reallocate memory; contents remain unchanged
  * @p: object to reallocate memory for
  * @size: the size to reallocate
+ * @align: desired alignment
  * @flags: the flags for the page level allocator
+ * @nid: NUMA node id
  *
  * If @p is %NULL, kvrealloc() behaves exactly like kvmalloc(). If @size is 0
  * and @p is not a %NULL pointer, the object pointed to is freed.
  *
+ * Only alignments up to those guaranteed by kmalloc() will be honored. Please see
+ * Documentation/core-api/memory-allocation.rst for more details.
+ *
  * If __GFP_ZERO logic is requested, callers must ensure that, starting with the
  * initial memory allocation, every subsequent call to this API for the same
  * memory allocation is flagged with __GFP_ZERO. Otherwise, it is possible that
@@ -5100,17 +5130,18 @@ EXPORT_SYMBOL(kvfree_sensitive);
  *
  * Return: pointer to the allocated memory or %NULL in case of error
  */
-void *kvrealloc_noprof(const void *p, size_t size, gfp_t flags)
+void *kvrealloc_node_align_noprof(const void *p, size_t size, unsigned long align,
+				  gfp_t flags, int nid)
 {
 	void *n;
 
 	if (is_vmalloc_addr(p))
-		return vrealloc_noprof(p, size, flags);
+		return vrealloc_node_align_noprof(p, size, align, flags, nid);
 
-	n = krealloc_noprof(p, size, kmalloc_gfp_adjust(flags, size));
+	n = krealloc_node_align_noprof(p, size, align, kmalloc_gfp_adjust(flags, size), nid);
 	if (!n) {
 		/* We failed to krealloc(), fall back to kvmalloc(). */
-		n = kvmalloc_noprof(size, flags);
+		n = kvmalloc_node_align_noprof(size, align, flags, nid);
 		if (!n)
 			return NULL;
 
@@ -5126,7 +5157,7 @@ void *kvrealloc_noprof(const void *p, size_t size, gfp_t flags)
 
 	return n;
 }
-EXPORT_SYMBOL(kvrealloc_noprof);
+EXPORT_SYMBOL(kvrealloc_node_align_noprof);
 
 struct detached_freelist {
 	struct slab *slab;
-- 
2.39.2


