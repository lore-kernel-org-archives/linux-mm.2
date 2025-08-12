Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C8F1CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 12:50:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A98C8E0114; Tue, 12 Aug 2025 08:50:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15AAC8E00E5; Tue, 12 Aug 2025 08:50:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 049318E0114; Tue, 12 Aug 2025 08:50:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E31A58E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:50:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A9C5FB8253
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:50:09 +0000 (UTC)
X-FDA: 83768088138.14.ACCF112
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id D99521C000A
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:50:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cork1m+3;
	spf=pass (imf18.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755003007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nAFiQLTxZfWIjT2BgzBfUHBH1TsYFyFlhKTQvwrw4NE=;
	b=It5TulgjPOiOeVTonJpPQn+9HIDle7cXN96WtMnG8BkA7KbN0SpwNXHlibxFsXcWGAWaFn
	ygLoD5btljE5BLKrnZCzPmPVWjT3l1+RBWadUae9zA0xClUE8M92KUe8eH9qDn8KPAn3Xn
	XcbYhbOQ7scpFm3q96N7LxrXyjFHfhQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755003007; a=rsa-sha256;
	cv=none;
	b=xREENLHhS5UYS0Bt/UOUrvcvEgrN6rC/DcYcvvY5RGM9f161XxlLFC2eXq6Q38g5c4RC98
	dJN6XCH0Zz4MTL4TXQi4t64LUsJ9+JjtNlqTtkP9d9XGhCYr1wIy2+2Sx+MPhVCy5+1ljI
	fFjaKMw+yv7SRL/I8jSX1Q7AYdXs/fA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cork1m+3;
	spf=pass (imf18.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755003007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nAFiQLTxZfWIjT2BgzBfUHBH1TsYFyFlhKTQvwrw4NE=;
	b=cork1m+3eEfjY1HBiDN9nzke0VayCRPjTFuIIzcl1mp3dw8AlEGkXdXgL3mX4geU8RhckV
	jMLtyDbuqh/BOgX8QYaHs7vyesesQdczvWzVScLA8fyoIoE6Lmr6vUpKAkeRpLfFQSqwbN
	0v9gM4Efw/FxW0I/Z//L/dpwcutRcpA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-21-pCgxLexbPZWoogFBtgeuVQ-1; Tue,
 12 Aug 2025 08:50:01 -0400
X-MC-Unique: pCgxLexbPZWoogFBtgeuVQ-1
X-Mimecast-MFC-AGG-ID: pCgxLexbPZWoogFBtgeuVQ_1755002999
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 937D9195605B;
	Tue, 12 Aug 2025 12:49:59 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.156])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A119E300146B;
	Tue, 12 Aug 2025 12:49:52 +0000 (UTC)
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
	sj@kernel.org,
	lorenzo.stoakes@oracle.com,
	elver@google.com,
	snovitoll@gmail.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v2 01/12] mm/kasan: add conditional checks in functions to return directly if kasan is disabled
Date: Tue, 12 Aug 2025 20:49:30 +0800
Message-ID: <20250812124941.69508-2-bhe@redhat.com>
In-Reply-To: <20250812124941.69508-1-bhe@redhat.com>
References: <20250812124941.69508-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D99521C000A
X-Stat-Signature: yqht3yminb9tm3ktaohuerxp6t9c9uk5
X-HE-Tag: 1755003007-879625
X-HE-Meta: U2FsdGVkX1+cBi78+fw6SAfAvjbyOIrROT+OwuziDfiOF+bqQuPJSelgbrSv0QQSxb66ENUx5pya4M3UkZQ4UsHPxq+l7Xp82BNDKAEgebzvcwdLN1mKZtqc8iPsXLKP7sNML5nvxNONHbf2qp0IrS5b1MYFctcsZkKnYKCtMASUalm+M7FRcwPikfBcdqiwGD0QXnvUnd9qbZ+5MhwRz/VYdv/vjCrK/SieytjJnwA0mgd3zDSfONLpMY/Jie6nKaKFkY250eQA5Ii9+z5j3cVYTb5qS3oKk3u6YJFu1CBxAqOwKBDyX7iZZ3lnONkKN36NYe7V6Y3grKTM4Cvf4zMbtcuuJNat4WcUjt9JUZprSST9ug/35U1gDlSBcZmYlCPU4tPuByAbwIDnZN+6tRMjW2tpB4VVFBpifTTXULbF1we1cD+QI9DWddIL2/0HaYAyt6/iokqXQsAAY8iT9gM2AODQhn5hSLQDPvg2852ICmVXU02a1aM0JaF19UYzqnbwRjEklLbpfXobF7W6N4MlN9KNURAA9chhFwfFvmTg8pqeeWlWdkqbRfzwtM3lhC350KPzgayd3Bc3lb9RBF3p4EN2RDpwO3wir+m1niv8TFS0v3ht7+uZRUTR7gI+4u2egnDWQTXgVO05O2sDn6YO1qalo5QwVmXUu1k9tnAH524mMwNeX8YgXzHQTjw+Zm9qG14ktkTUxVT6M3/GTDFgeYUt7yfQBzEPS92mZnlH5gyTjS/tO2H8arskVt2ePbQHlKRPrt0cbFC/a2NfjLZj8aNX8cR66AciMRD1eeBi+bHWD1Ic5DQaHRBBfMKfb49yjJVgO1geDLUfQLofnF2aEJpiMhYqC5fbaScu4x7SaB7pt+fsEY9TTMO4+AuCb8lv69aS4e7DABRLnx4zxHhTJ971NMwDaa0TdLKVyfZRLGt/Cgg2Kckxc30HxbRd2w2ArfwzTHUmZASX6ZT
 om6FEPlK
 HM/5uTIerSYc2HdzoeHojkLf+UwRSPXP/Oj5Op5KxeAGjlA0aGdf+ekx709jApnRmjSGbLXQ2rfAUNTlZVugKqAiDVq74fN7DU644V1lPABnr9PudkyzZm65VGBpRxatyNmOcNU9XWgQendKuxbZ0CplYO7ydGYe5Sjaqci3yk7nsn0AM3kiIGNFZ4cF6K/uVwzoiG41LbzneauDkDyBB6tLEki+ugUNd+FsyselybOLEXYeSatSRAwmgagNbsD1tbUhuJmiHx8J7B7Cgt9aYX8OjwrRbNX4p1fBdkK6aUksar8h/YTCiIlrtdcsfQjrAh2EtxzxlkZhrGz8FAQcn7i5VWh6Fd3z18PHKyEjVxLIU9XBnnnO0/VZxGqnuUEaTtGhrL7pAqvH3MmUl+fSzaRXT7w==
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
 mm/kasan/report.c     |  4 +++-
 mm/kasan/shadow.c     | 23 ++++++++++++++++++++++-
 mm/kasan/sw_tags.c    |  3 +++
 6 files changed, 55 insertions(+), 4 deletions(-)

diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
index d54e89f8c3e7..8daea5892754 100644
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
diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 62c01b4527eb..884357fa74ed 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -576,7 +576,9 @@ bool kasan_report(const void *addr, size_t size, bool is_write,
 	unsigned long irq_flags;
 	struct kasan_report_info info;
 
-	if (unlikely(report_suppressed_sw()) || unlikely(!report_enabled())) {
+	if (unlikely(report_suppressed_sw()) ||
+	    unlikely(!report_enabled()) ||
+	    !kasan_enabled()) {
 		ret = false;
 		goto out;
 	}
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


