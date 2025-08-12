Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87047CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:10:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C07F8E0125; Tue, 12 Aug 2025 09:10:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 297F98E00E5; Tue, 12 Aug 2025 09:10:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ADEA8E0125; Tue, 12 Aug 2025 09:10:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B57D8E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:10:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B82C511692F
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:10:41 +0000 (UTC)
X-FDA: 83768139882.11.6CA6013
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id A39524000E
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:10:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eAkLPF7g;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755004239; a=rsa-sha256;
	cv=none;
	b=L1tUBzSRw7D75aanD2OEhnwMVXhn6zV8VUruRsBdPV7WwELsgFVVhmS7rvf6xGNb0rrtJf
	bk4B192ce9NL47TmmI0WRkjcYZX3o2DSWqRiaKT7jPbNPtthgNgQBHB6h6CBEI/sKZ2nBx
	/uptVmQfA2kDa4Fr0cKuD698gCn16Jw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eAkLPF7g;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755004239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=90kjOoDlgJxvROpKhCBaV42MFQEOcPlCS7aVoYrLf2Q=;
	b=xGxm8BLFItN4kUVH77Zk0JtuyRcHIe6EqjQuWE3s6sqUcrxez3AYkR7SSoplM/vGZ1gVWY
	7b4h+QAnQsOvHs1g6ms10qnzyymzSOq/7lybkYMJDRNzYBCnxsy2m4Q3q+SCu+zTx1GgYS
	GTuBbARa9ETh9hy+boXufu/30qQMMDo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755004238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=90kjOoDlgJxvROpKhCBaV42MFQEOcPlCS7aVoYrLf2Q=;
	b=eAkLPF7gCa6J/GOUZWqYUVVPPgJFC7q9JT/U6GY/biUQ4cJ/uDDVixWFFFoy8VrzGLH+Na
	kGjcTrWFCcyutrjeG+ZJhvy5ocx03Yhh8yzh+Sld+o8DcS5f9Ipswte9hCTIFjJ40AKNrh
	RRPPALBEkHgIMK3WYHFYrm+wuOgBsPk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-675-TQnxb7SJOn-5DJ0f1i7kgA-1; Tue,
 12 Aug 2025 09:10:33 -0400
X-MC-Unique: TQnxb7SJOn-5DJ0f1i7kgA-1
X-Mimecast-MFC-AGG-ID: TQnxb7SJOn-5DJ0f1i7kgA_1755004227
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5A40B1800291;
	Tue, 12 Aug 2025 13:10:27 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.156])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7D1B71955F16;
	Tue, 12 Aug 2025 13:10:18 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: snovitoll@gmail.com,
	ryabinin.a.a@gmail.com,
	christophe.leroy@csgroup.eu,
	hca@linux.ibm.com,
	andreyknvl@gmail.com,
	akpm@linux-foundation.org,
	chenhuacai@loongson.cn,
	davidgow@google.com,
	glider@google.com,
	dvyukov@google.com,
	alexghiti@rivosinc.com,
	kasan-dev@googlegroups.com,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-um@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	agordeev@linux.ibm.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH 4/4] mm/kasan: remove kasan_arch_is_ready()
Date: Tue, 12 Aug 2025 21:09:33 +0800
Message-ID: <20250812130933.71593-5-bhe@redhat.com>
In-Reply-To: <20250812130933.71593-1-bhe@redhat.com>
References: <20250812130933.71593-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A39524000E
X-Stat-Signature: 58zrrfpo4iqduz7hxpu58eecj183whdw
X-Rspam-User: 
X-HE-Tag: 1755004239-738127
X-HE-Meta: U2FsdGVkX1+csC+NICM6gjfVbqEovTfFqbd5ZLxwUF9I+XLtA/vCTSxvH/HaeOuHR9ism72EpGFy7ICc0EMqXUcvzqgWF/FS1/re9ilSEmcK/IAHFZ9r/EKlniwHn5oMg/owyN58sVDAHFUW2XbHIz2mp7IIlAfvibfVO4Hg+G8TGAigaTiNj8K3+YwmXG3mOlVOb+TsswnnA6xMAmismiFZq7inS55mwdCFKp/DMlNQCfXS8C7T/Hqf37VIevgSN1Y58IYrHd8SOhkPx48oX6mpyHf9+/tmt6yWiLGTtbzYgr+MRO4XFkIciRLiOpVFnk4DNzBnYw3jgFHb6wquHFRM+lEmvZfPU0sAXnzcu96yS+DeYMZoaFOpy6c9Gzqs3D5R6vx3Moig2V6tLmjU/ibX0Z7cVtqej6sOEqTTFadee//Z7XjI2xfa8QACajqkeGhiVRhB0dqpgBq7YlaEbH3XLhy7/raGdgmOgIP1L+vd3QFjoNpzj6RqXmYqwLkfM/HibztBCpqsxvS171DGiZ0GgJvqTQQNy6hUHL6yl3A7+C1B7PvHOj6V6+14bGBxZAFWPuym2vgpiX2OvuDxgrGwhFKg3mKM9AkYxCF8ascIFPiUNeXCuFoTedY7qrHM/74eMBASRKwSWknnKVf/hcCt27rJFvZwoMR2xXsvaSLwPYHrcNXC8H9lxZ9Zx5qUsSm8/kmJpoUboDEC+6vOQiJgdYzBpzj3T6VXxrM2qDr9wQPXDlSd7FHBFbj89Yz8VfERLfMmRnduqtLXNI5EMT4oWusL4q99U/WvuLHfq16MUJx39ItOuYng6tf8XvsJxG7H1OJeIn3iWZeFRygLtHNlIIel5eIuDcgSrx87SabbnHXX4wCbIynMXTlxYObwgPK4qv3eF3iAVfTwM25ZjSO+6I83ndHnkS2OttAbfL9iQAr9/b84UCIiaIWy4p+ohtP+lZ0gHICQ8b3oG4j
 OTuoaFrH
 H2hv1KZ3N4I/GzRHOvpZo9MVZcZMZD+JNdWJCtFANVoeHe64GIYKUzEnnZzqbIU5BsA4KifmCaO3ej31jFuudg/KwmFS7FR9zn59VIXjUkUt6KgiOtNRgDP+9sJJ73UjHNX2nh49+JvbUmGCsXTLmLV3ILlS3buSvJTFoXa5TYk8YiG3j9SoJioUaPMJgY55Yq4n+LI5cnZ4ME1e37tvMTHNb3Y3JHHxWCWGb/R5JNpI86sp4XGDgWkSefg3jKfVPhZW0mr/1DfN5BpsDBs967fQesMVTEBi8xKCKfbml24yltBlCcdCCuDmFWjhodipYZZCzpO2G097Q2ogugA68VGaZh6oJruAckjCaDrSfiafCi6pmT0kQw+5nB6/DU/cesbLYnr6UNq150yElThUUxdp+Rjh50Ccpde0/aV1p4dPdoyCmfcDlUMkz+/JOG21tSQ1zdx1TtUqX4lk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now there's no any place where kasan_arch_is_ready() is needed, remove
all its invocations.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 mm/kasan/common.c  |  9 +++------
 mm/kasan/generic.c |  9 ---------
 mm/kasan/kasan.h   |  6 ------
 mm/kasan/shadow.c  | 18 ------------------
 4 files changed, 3 insertions(+), 39 deletions(-)

diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index 69a848f2a8aa..e48c1fd60edf 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -271,7 +271,7 @@ static inline void poison_slab_object(struct kmem_cache *cache, void *object,
 bool __kasan_slab_pre_free(struct kmem_cache *cache, void *object,
 				unsigned long ip)
 {
-	if (!kasan_arch_is_ready() || is_kfence_address(object))
+	if (is_kfence_address(object))
 		return false;
 	return check_slab_allocation(cache, object, ip);
 }
@@ -279,7 +279,7 @@ bool __kasan_slab_pre_free(struct kmem_cache *cache, void *object,
 bool __kasan_slab_free(struct kmem_cache *cache, void *object, bool init,
 		       bool still_accessible)
 {
-	if (!kasan_arch_is_ready() || is_kfence_address(object))
+	if (is_kfence_address(object))
 		return false;
 
 	/*
@@ -318,9 +318,6 @@ bool __kasan_slab_free(struct kmem_cache *cache, void *object, bool init,
 
 static inline bool check_page_allocation(void *ptr, unsigned long ip)
 {
-	if (!kasan_arch_is_ready())
-		return false;
-
 	if (ptr != page_address(virt_to_head_page(ptr))) {
 		kasan_report_invalid_free(ptr, ip, KASAN_REPORT_INVALID_FREE);
 		return true;
@@ -547,7 +544,7 @@ bool __kasan_mempool_poison_object(void *ptr, unsigned long ip)
 		return true;
 	}
 
-	if (is_kfence_address(ptr) || !kasan_arch_is_ready())
+	if (is_kfence_address(ptr))
 		return true;
 
 	slab = folio_slab(folio);
diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
index 8daea5892754..d513e3e2e136 100644
--- a/mm/kasan/generic.c
+++ b/mm/kasan/generic.c
@@ -168,9 +168,6 @@ static __always_inline bool check_region_inline(const void *addr,
 	if (!kasan_enabled())
 		return true;
 
-	if (!kasan_arch_is_ready())
-		return true;
-
 	if (unlikely(size == 0))
 		return true;
 
@@ -196,9 +193,6 @@ bool kasan_byte_accessible(const void *addr)
 {
 	s8 shadow_byte;
 
-	if (!kasan_arch_is_ready())
-		return true;
-
 	shadow_byte = READ_ONCE(*(s8 *)kasan_mem_to_shadow(addr));
 
 	return shadow_byte >= 0 && shadow_byte < KASAN_GRANULE_SIZE;
@@ -505,9 +499,6 @@ static void release_alloc_meta(struct kasan_alloc_meta *meta)
 
 static void release_free_meta(const void *object, struct kasan_free_meta *meta)
 {
-	if (!kasan_arch_is_ready())
-		return;
-
 	/* Check if free meta is valid. */
 	if (*(u8 *)kasan_mem_to_shadow(object) != KASAN_SLAB_FREE_META)
 		return;
diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
index 129178be5e64..e0ffc16495d7 100644
--- a/mm/kasan/kasan.h
+++ b/mm/kasan/kasan.h
@@ -544,12 +544,6 @@ static inline void kasan_poison_last_granule(const void *address, size_t size) {
 
 #endif /* CONFIG_KASAN_GENERIC */
 
-#ifndef kasan_arch_is_ready
-static inline bool kasan_arch_is_ready(void)	{ return true; }
-#elif !defined(CONFIG_KASAN_GENERIC) || !defined(CONFIG_KASAN_OUTLINE)
-#error kasan_arch_is_ready only works in KASAN generic outline mode!
-#endif
-
 #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
 
 void kasan_kunit_test_suite_start(void);
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index 637f2d02d2a3..d8b975282b22 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -128,9 +128,6 @@ void kasan_poison(const void *addr, size_t size, u8 value, bool init)
 	if (!kasan_enabled())
 		return;
 
-	if (!kasan_arch_is_ready())
-		return;
-
 	/*
 	 * Perform shadow offset calculation based on untagged address, as
 	 * some of the callers (e.g. kasan_poison_new_object) pass tagged
@@ -156,9 +153,6 @@ void kasan_poison_last_granule(const void *addr, size_t size)
 	if (!kasan_enabled())
 		return;
 
-	if (!kasan_arch_is_ready())
-		return;
-
 	if (size & KASAN_GRANULE_MASK) {
 		u8 *shadow = (u8 *)kasan_mem_to_shadow(addr + size);
 		*shadow = size & KASAN_GRANULE_MASK;
@@ -402,9 +396,6 @@ int kasan_populate_vmalloc(unsigned long addr, unsigned long size)
 	if (!kasan_enabled())
 		return 0;
 
-	if (!kasan_arch_is_ready())
-		return 0;
-
 	if (!is_vmalloc_or_module_addr((void *)addr))
 		return 0;
 
@@ -575,9 +566,6 @@ void kasan_release_vmalloc(unsigned long start, unsigned long end,
 	if (!kasan_enabled())
 		return;
 
-	if (!kasan_arch_is_ready())
-		return;
-
 	region_start = ALIGN(start, KASAN_MEMORY_PER_SHADOW_PAGE);
 	region_end = ALIGN_DOWN(end, KASAN_MEMORY_PER_SHADOW_PAGE);
 
@@ -626,9 +614,6 @@ void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
 	 * with setting memory tags, so the KASAN_VMALLOC_INIT flag is ignored.
 	 */
 
-	if (!kasan_arch_is_ready())
-		return (void *)start;
-
 	if (!is_vmalloc_or_module_addr(start))
 		return (void *)start;
 
@@ -651,9 +636,6 @@ void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
  */
 void __kasan_poison_vmalloc(const void *start, unsigned long size)
 {
-	if (!kasan_arch_is_ready())
-		return;
-
 	if (!is_vmalloc_or_module_addr(start))
 		return;
 
-- 
2.41.0


