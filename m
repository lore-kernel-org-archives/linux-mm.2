Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53B27C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 06:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E541F6B0098; Tue,  5 Aug 2025 02:23:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E047C8E0001; Tue,  5 Aug 2025 02:23:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7F1E6B00A3; Tue,  5 Aug 2025 02:23:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B98466B0098
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 02:23:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 79EDB1DD64C
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:23:55 +0000 (UTC)
X-FDA: 83741713230.17.355638F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id B6FBEC0005
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:23:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FpKnyhqf;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754375033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YU51QcBxpYhMcGyh8yXmd1ecFtbJIeZYT5VTxJvHY9k=;
	b=E/RNPUH4zbzyIYCfNxvytkqIZjULxoALo4aPUUBKbtBxqlHAnBBeTZCfLO/7rDyImIPNA9
	+cPKTRUN6ThfunyUQQg4tsO52v3uJmTcHYkuyotX6jjsZbHgeibm6+vOSl3Qy6iBxeXr3r
	w0TEd+wQR8HdMfUmSqBp5d86MIJSqK4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754375033; a=rsa-sha256;
	cv=none;
	b=hu1KKH8hm/IeCU4DFb5jG2laMaeL/SavNQ7KjA910Znd3eZ4bmhW146SIiVZkd3KwEhigP
	qsF92kYFNlj8TQYlU/cOwLh/+GDF6JA2XysZdSm9hiPS6Fp+v3sTTaXRw/v/AJtp5tQUTj
	MSxp+wllV7f8hV7d7KXEP1bgX2Nipyc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FpKnyhqf;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754375033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YU51QcBxpYhMcGyh8yXmd1ecFtbJIeZYT5VTxJvHY9k=;
	b=FpKnyhqf6tTQkwwXpD90y9l+FqLjSkKzXnfWO0AqGYApYD1qIk+ARS2Cdkyh04mGl7gJJp
	SFbIi7jxHjz6KDvs7Lj6d1jACu1rW5O9dhzFDHVa8wBoF2A+jB4k8SPHSCnJ+ZcKl67NUc
	61/4YJAdjea82mlhMv+5diKFsFBiOfg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-308-8_Hp1WdPNaKVrdPYJCqwew-1; Tue,
 05 Aug 2025 02:23:50 -0400
X-MC-Unique: 8_Hp1WdPNaKVrdPYJCqwew-1
X-Mimecast-MFC-AGG-ID: 8_Hp1WdPNaKVrdPYJCqwew_1754375029
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8F8761956089;
	Tue,  5 Aug 2025 06:23:48 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.136])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5033C1956094;
	Tue,  5 Aug 2025 06:23:42 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	akpm@linux-foundation.org,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH 1/4] mm/kasan: add conditional checks in functions to return directly if kasan is disabled
Date: Tue,  5 Aug 2025 14:23:30 +0800
Message-ID: <20250805062333.121553-2-bhe@redhat.com>
In-Reply-To: <20250805062333.121553-1-bhe@redhat.com>
References: <20250805062333.121553-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Queue-Id: B6FBEC0005
X-Stat-Signature: 83kyepi41146gz3wc3u6gk4t8aj1bhrd
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754375033-881373
X-HE-Meta: U2FsdGVkX1+8lAujOYU0gVRm/2p8GVQVIkY5QZLNI27TteucZ00a5riIyvbKL2bZx+ucSgH9i6DNdtSqZjB3TZDiobzbPn5UpBOXztVW+OOTfLokSTt9O28Q2RLxyEfv4dXrhqA5RenhKRPV7NvL+ZcIP7EdYZuF/5C5jwZCPF+cQGrYbEocfs+L6HioqZprhDumTw1OgLwb/kuiNK4Xpk23QLWWIREEB0Y2Xk+pl8tjDwySTg24JGxXrHjN9CnOJfkT6U0VidGZ2VBbwlI8IhquB6XKMeBtfTIFc2mH/XBJAFUx9QhkEmgn7mC+hb1BjPQVZ8N9wSIBVcyJOhTV6isFiXoR16VVfq2u19BsV1NdhoeWGY2/oO3M2fqt374CJTcEUjNN5Fk+KdzVu1uyDZIioEfugMDyEbJViGamwjQHB2nynD8qPJ57jM+beND2mEEERGX8RsaCB9DvE8pfdu76Rdg5Mve+qeegG7kWA2w5P3jkg9YJZf/jSjp6kdOwsa9zGrPgafwri8oqLFmrg2nrb6f6xwOOMZxIRHWTmavet1aX5vaPWjetT6td+W9EcLx0dLX3GZeLkjRKXPpTM1sROAw6QL9Jh3huoSTXJ8QrlD/ojBm5F/xXCJdxm7yrdNS0txHIRlnoshKb85V+VwQPcwK76eWGD1AQytpFX5FSPn1T4wa7BQeNMN0ZykQVpVbWLOfJg89fDg9pr9DmMSTpSy4njKVT4KcyG8QzXo0F9ozwdKi37d2PFeacV/aDv7p58WnIe8OcGkSeVCXP0nORqqWyP4h3RPH8p28o4GRcmzXAdnSW0C294T/yV/pZde52EA36Mrr6u0YLk9gO54yW1oT9YPMePNhN/APl8kl9G7iyqDW/XG4hoosfKAzNT1kQ0CDBniWiljBsKZeaHXxrO8JDiw8X8ntTfm/yyLGZnMuyuJKqyImbFnnxGLTp6J4HEM1e27co8W5zcN4
 4XWn/t0f
 my5GubFiBex87b6kNh6kgsnsITVMdQkUAUsbgdBmDwZKllUauxyhvHalw4YnuLq6GNFHFJsfrRE15cC8utoTOwqIwON2HeNyFmO9/yl1ZupAODKdxfGw6JTcVdtl/SjwyJQFKDcHHuWB5EpfaalQNHJZ7EIilcp3K/nYVCRH709zAXrVIc8MuSuFZIZAZkb0QfhjePE94h0J35hWbiw0XzIu3CofNYOih0F65KzIgHUDjVjGI0fvEZyC1FVZISzZ2R0Vx6R4d5ZnJlrud8uo+bGp1SIlSGtsmbKLi2yf6XdldprSLmhj1uZ38shRVy75We2L5on65+kF8h7QyOhBURv2YnX4QVJixz0AMnG6rrcAYk1Wqf/OHR4u/vaPkziPnuTe/KLk0sp8geRzl2rff1AnKMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current code only does the check if kasan is disabled for hw_tags
mode. Here add the conditional checks for functional functions of
generic mode and sw_tags mode.

This is prepared for later adding kernel parameter kasan=on|off for
all kasan modes.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 mm/kasan/generic.c    | 20 ++++++++++++++++++--
 mm/kasan/init.c       |  6 ++++++
 mm/kasan/quarantine.c |  3 +++
 mm/kasan/shadow.c     | 23 ++++++++++++++++++++++-
 mm/kasan/sw_tags.c    |  3 +++
 5 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
index d54e89f8c3e7..ee4ddc1e7127 100644
--- a/mm/kasan/generic.c
+++ b/mm/kasan/generic.c
@@ -165,6 +165,9 @@ static __always_inline bool check_region_inline(const void *addr,
 						size_t size, bool write,
 						unsigned long ret_ip)
 {
+	if (!kasan_enabled())
+		return true;
+
 	if (!kasan_arch_is_ready())
 		return true;
 
@@ -203,12 +206,13 @@ bool kasan_byte_accessible(const void *addr)
 
 void kasan_cache_shrink(struct kmem_cache *cache)
 {
-	kasan_quarantine_remove_cache(cache);
+	if (kasan_enabled())
+		kasan_quarantine_remove_cache(cache);
 }
 
 void kasan_cache_shutdown(struct kmem_cache *cache)
 {
-	if (!__kmem_cache_empty(cache))
+	if (kasan_enabled() && !__kmem_cache_empty(cache))
 		kasan_quarantine_remove_cache(cache);
 }
 
@@ -228,6 +232,9 @@ void __asan_register_globals(void *ptr, ssize_t size)
 	int i;
 	struct kasan_global *globals = ptr;
 
+	if (!kasan_enabled())
+		return;
+
 	for (i = 0; i < size; i++)
 		register_global(&globals[i]);
 }
@@ -358,6 +365,9 @@ void kasan_cache_create(struct kmem_cache *cache, unsigned int *size,
 	unsigned int rem_free_meta_size;
 	unsigned int orig_alloc_meta_offset;
 
+	if (!kasan_enabled())
+		return;
+
 	if (!kasan_requires_meta())
 		return;
 
@@ -510,6 +520,9 @@ size_t kasan_metadata_size(struct kmem_cache *cache, bool in_object)
 {
 	struct kasan_cache *info = &cache->kasan_info;
 
+	if (!kasan_enabled())
+		return 0;
+
 	if (!kasan_requires_meta())
 		return 0;
 
@@ -535,6 +548,9 @@ void kasan_record_aux_stack(void *addr)
 	struct kasan_alloc_meta *alloc_meta;
 	void *object;
 
+	if (!kasan_enabled())
+		return;
+
 	if (is_kfence_address(addr) || !slab)
 		return;
 
diff --git a/mm/kasan/init.c b/mm/kasan/init.c
index ced6b29fcf76..43d95f329675 100644
--- a/mm/kasan/init.c
+++ b/mm/kasan/init.c
@@ -449,6 +449,9 @@ void kasan_remove_zero_shadow(void *start, unsigned long size)
 	unsigned long addr, end, next;
 	pgd_t *pgd;
 
+	if (!kasan_enabled())
+		return;
+
 	addr = (unsigned long)kasan_mem_to_shadow(start);
 	end = addr + (size >> KASAN_SHADOW_SCALE_SHIFT);
 
@@ -484,6 +487,9 @@ int kasan_add_zero_shadow(void *start, unsigned long size)
 	int ret;
 	void *shadow_start, *shadow_end;
 
+	if (!kasan_enabled())
+		return 0;
+
 	shadow_start = kasan_mem_to_shadow(start);
 	shadow_end = shadow_start + (size >> KASAN_SHADOW_SCALE_SHIFT);
 
diff --git a/mm/kasan/quarantine.c b/mm/kasan/quarantine.c
index 6958aa713c67..a6dc2c3d8a15 100644
--- a/mm/kasan/quarantine.c
+++ b/mm/kasan/quarantine.c
@@ -405,6 +405,9 @@ static int __init kasan_cpu_quarantine_init(void)
 {
 	int ret = 0;
 
+	if (!kasan_enabled())
+		return 0;
+
 	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "mm/kasan:online",
 				kasan_cpu_online, kasan_cpu_offline);
 	if (ret < 0)
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index d2c70cd2afb1..637f2d02d2a3 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -125,6 +125,9 @@ void kasan_poison(const void *addr, size_t size, u8 value, bool init)
 {
 	void *shadow_start, *shadow_end;
 
+	if (!kasan_enabled())
+		return;
+
 	if (!kasan_arch_is_ready())
 		return;
 
@@ -150,6 +153,9 @@ EXPORT_SYMBOL_GPL(kasan_poison);
 #ifdef CONFIG_KASAN_GENERIC
 void kasan_poison_last_granule(const void *addr, size_t size)
 {
+	if (!kasan_enabled())
+		return;
+
 	if (!kasan_arch_is_ready())
 		return;
 
@@ -164,6 +170,8 @@ void kasan_unpoison(const void *addr, size_t size, bool init)
 {
 	u8 tag = get_tag(addr);
 
+	if (!kasan_enabled())
+		return;
 	/*
 	 * Perform shadow offset calculation based on untagged address, as
 	 * some of the callers (e.g. kasan_unpoison_new_object) pass tagged
@@ -277,7 +285,8 @@ static int __meminit kasan_mem_notifier(struct notifier_block *nb,
 
 static int __init kasan_memhotplug_init(void)
 {
-	hotplug_memory_notifier(kasan_mem_notifier, DEFAULT_CALLBACK_PRI);
+	if (kasan_enabled())
+		hotplug_memory_notifier(kasan_mem_notifier, DEFAULT_CALLBACK_PRI);
 
 	return 0;
 }
@@ -390,6 +399,9 @@ int kasan_populate_vmalloc(unsigned long addr, unsigned long size)
 	unsigned long shadow_start, shadow_end;
 	int ret;
 
+	if (!kasan_enabled())
+		return 0;
+
 	if (!kasan_arch_is_ready())
 		return 0;
 
@@ -560,6 +572,9 @@ void kasan_release_vmalloc(unsigned long start, unsigned long end,
 	unsigned long region_start, region_end;
 	unsigned long size;
 
+	if (!kasan_enabled())
+		return;
+
 	if (!kasan_arch_is_ready())
 		return;
 
@@ -655,6 +670,9 @@ int kasan_alloc_module_shadow(void *addr, size_t size, gfp_t gfp_mask)
 	size_t shadow_size;
 	unsigned long shadow_start;
 
+	if (!kasan_enabled())
+		return 0;
+
 	shadow_start = (unsigned long)kasan_mem_to_shadow(addr);
 	scaled_size = (size + KASAN_GRANULE_SIZE - 1) >>
 				KASAN_SHADOW_SCALE_SHIFT;
@@ -691,6 +709,9 @@ int kasan_alloc_module_shadow(void *addr, size_t size, gfp_t gfp_mask)
 
 void kasan_free_module_shadow(const struct vm_struct *vm)
 {
+	if (!kasan_enabled())
+		return;
+
 	if (IS_ENABLED(CONFIG_UML))
 		return;
 
diff --git a/mm/kasan/sw_tags.c b/mm/kasan/sw_tags.c
index b9382b5b6a37..01f19bc4a326 100644
--- a/mm/kasan/sw_tags.c
+++ b/mm/kasan/sw_tags.c
@@ -78,6 +78,9 @@ bool kasan_check_range(const void *addr, size_t size, bool write,
 	u8 *shadow_first, *shadow_last, *shadow;
 	void *untagged_addr;
 
+	if (!kasan_enabled())
+		return true;
+
 	if (unlikely(size == 0))
 		return true;
 
-- 
2.41.0


