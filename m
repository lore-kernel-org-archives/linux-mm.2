Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F156CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 05:35:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16E798E0021; Wed, 20 Aug 2025 01:35:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11F738E0011; Wed, 20 Aug 2025 01:35:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F299E8E0021; Wed, 20 Aug 2025 01:35:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D91508E0011
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:35:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7C7301DCDFA
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:35:31 +0000 (UTC)
X-FDA: 83796023262.14.BEA18F5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id BAD6940008
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:35:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d0HjIYy9;
	spf=pass (imf27.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755668129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nAFiQLTxZfWIjT2BgzBfUHBH1TsYFyFlhKTQvwrw4NE=;
	b=tPnHoylIysxQvCo4gzlMu8f9hSl5vNP59U+lT+/OSvIQdikSpemx84p1ZT+p35uJoCaeUo
	lN7Fo+t0EgDKPgKonlgPAFzmE30+3YSfgL+o9YMuG9YNwpUlVb5ry8d2xpymgEfDSrS8eK
	xn+WN2PW7zjM4wbudo/Tc2gtuT0Vpks=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755668129; a=rsa-sha256;
	cv=none;
	b=fUP6fvnihWgHgrbI9uR3mKBjhPGJL4FVZt8Lex6OwOnU45q/AUZmS8Fyj5B1wAU/hd4BjC
	AYMSBMBtolY9VH9rkPLPJoytkNb+pZX1ScBlEVEuHFR9wzDrR/UCEbjhODSY7K7awd1Qcw
	FHho3OsM66ilVtbt3UuylBxSgQSAnME=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d0HjIYy9;
	spf=pass (imf27.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755668129;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nAFiQLTxZfWIjT2BgzBfUHBH1TsYFyFlhKTQvwrw4NE=;
	b=d0HjIYy9sbXf6giNc4lo1neXfYJIdIicvIxUDQ9gHLWTxnnq/15FPyY/Z2NsjWE1omAxxx
	8qQefW4EoCKAzjd5kWjrooCEdFcHsqOpRZHahQwHWjSlBGogTnYYdjqmFBaRB4Jbl5M7h5
	mvCcV2pf/a75Al9yES5engdyTBn8fy8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-185-SZJqQwM0MQieMhFfhK9-vw-1; Wed,
 20 Aug 2025 01:35:22 -0400
X-MC-Unique: SZJqQwM0MQieMhFfhK9-vw-1
X-Mimecast-MFC-AGG-ID: SZJqQwM0MQieMhFfhK9-vw_1755668120
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B55A11800357;
	Wed, 20 Aug 2025 05:35:19 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.99])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1D33719560B6;
	Wed, 20 Aug 2025 05:35:11 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: ryabinin.a.a@gmail.com,
	andreyknvl@gmail.com,
	glider@google.com,
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
	christophe.leroy@csgroup.eu,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v3 01/12] mm/kasan: add conditional checks in functions to return directly if kasan is disabled
Date: Wed, 20 Aug 2025 13:34:48 +0800
Message-ID: <20250820053459.164825-2-bhe@redhat.com>
In-Reply-To: <20250820053459.164825-1-bhe@redhat.com>
References: <20250820053459.164825-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BAD6940008
X-Stat-Signature: 46faf1sqi7g5gdqudi7699dcpdwrtecg
X-HE-Tag: 1755668129-423958
X-HE-Meta: U2FsdGVkX1/6qBPBfCFt45MpiCz/0Yx4XMoWswnCQ77/9IKVQ0TRGQwbB6F7e8n6Xz2ozrg3m9Yenv3k3sy0kp6o8cIWhR5AHxVyr92qfghrVpmKbWc1LDKOMo/szfxN4I7CTCETEHMVQYDcivuyVUuVFfpoyCCbY1kV0U0gy8wtmA/6g0Yr1z4KMnei/ruOBOcx02nkGkaWlWMfmhgTRSN/jzG2a2iPbH5EHljDhk9x19U9YLn8bvY12UzspRBa9qz5xoXfpPDwExFlFIjbu/dMZGnFm4k1q1gqAe8uJHfO0nFKQ9dxc578dtKTQzWDJHp+TytAbReIr6wNX6W8r6KKnSRZ/xBNf0Uy+lMJGFIiiOBRMvXWtZn237/M4kGj3H66xtDnfQ1d0afPgIaeiJsJphSK/DmJ6uVRUp4vTChcSTzByyOkNzMBxYcDwsTcDPT2oVEqRzNlYvpP6VmAGmX9oIl+OJlpZToobggHypQ4NJJGlqFwRLuUUqpmx1BSLC8PcaAMzVKVv9fxji8MkxJdMZRNDap8CQtJQ+JEX8nG9NU7zHkNul/0Xh+CkFpWXLhXOxLyhe3+nhxY6eLmwzO092LuEwIgPKuaWU6engmSqPWs5x2nrp+NLc46AndUEatZevx/OrWZ12UxtrCFGU4ommJPhgSw6HrlSD7ASuuh/RQRAR0IFHMR8eW2GqS8PDNMTw4wJKJZSBxhJa/urM8ka+suSqmJcTwgHMPgdU0UoJFPdjGxPt+6asdWSEiUX+2yxbax+RSccatw/1btj0/stw+OPZQ+WgWDOrQ640hfwqJw1Eo0WmLvf2qlsZQFAABEsfYsO06SlSlQMNf53kzFis9dO0V6/oKHmxUOqgEuqqG/mnUOBt8YautJlUxVzFlDq8MI+Pau+Sg6ivtFUMjqjVR05VMMB0awgOV2rwajiH1c+o5epaai0lcq+6KV6wQVcXtn3xBoAAjkIi8
 QR5MGwDf
 JtBAc7THFGCkyr9So2M+6g5igfpm4X4QUipv2JDfpAw/Nfk+2tuXgd6Bfz2uUH3w7oe4fCAEpTt2PD93eK3rDH+erbcdVmSQWu2H7URrv9tIL9CEBFaAW3C9XXFFgRGak7YSdyPaqjwn5IVIE3J/YzlfkpQ9CEnDVTAYI0BoJlSssbDdhDfBGgBLpObBAphVC+zTRLWClgqT2uDy0Ewp4X2uaUysdrnnQEXHBIYWmhe3G1KuBiljTt3/MRzsK2jP3DQIkTfimMS6fHwv2Y7R/5FU0tr0mEaZz8wqGqSaYXbradiXpgbJKElGVc1n+QB7KzjHNUlVaZxaoy7t+HKrIqRzCdW0GQVYldaxAgN/xSrUH051ksmbuddoEClwDG6xtNCfO8S9RNYae3zya++Dc9/5nIA==
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


