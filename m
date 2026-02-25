Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 525DFEFD206
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:15:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1C2C6B00C3; Wed, 25 Feb 2026 03:14:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF3B16B00C5; Wed, 25 Feb 2026 03:14:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1CAB6B00C7; Wed, 25 Feb 2026 03:14:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 907796B00C3
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:14:59 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3A9C7160290
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:14:59 +0000 (UTC)
X-FDA: 84482268318.19.7AC6284
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 51A4840002
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:14:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YfaD0xoz;
	spf=pass (imf11.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772007297; a=rsa-sha256;
	cv=none;
	b=YDZ/jz/Ebh8MmnwzqoZptDk906uUA+mP2Qj0+y3AH5lkumOmgUZtWYELifz6SZqjYbWvrM
	rhCjd9U8EwKnG/0oRA5krvl8FUZzLQxl1RWfnm+7j0wOPHB3YBvUOROf/uzsu2ISE9QGJR
	sJYq52uFQQ5XXtlzw07mAcvGVgwqUfQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YfaD0xoz;
	spf=pass (imf11.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772007297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1+o8INxubcV2x/Jl5UdObmj+gfJwsgp0C09vqymuwDM=;
	b=bHrAcyu7ehuGKChZugK/T5heY3Q5BfNjdtm8srin9hOVeMoQHEDh1J7UFBasIFXNjDqnAV
	prgoHEcybwLKafsAsCFYPrPoxFVlpjkean0GL2rKv3VS3Qeb/Pj4+k/BGk1zA/RztwV95C
	yUPp/GIlT+gYdpV1ellnN46VPiyfF4E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772007296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1+o8INxubcV2x/Jl5UdObmj+gfJwsgp0C09vqymuwDM=;
	b=YfaD0xozfdQUlUgrC4uUT6noXJAq0SZ6rOFQjfM0QaL68C7gt388Hjjodxr2tm68pe82YC
	RmCkZK1oUI98e/fTXd/LA+LiabhMSdGdcdLgq3yG5l8pTa7Vsp1cTn8LkiS4rBwufjqeyV
	z1FhxYhA602EaqiYvliwPtHDQOnIP1A=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-556-nQ4DDfqXPK2cnN4hGIJDvA-1; Wed,
 25 Feb 2026 03:14:51 -0500
X-MC-Unique: nQ4DDfqXPK2cnN4hGIJDvA-1
X-Mimecast-MFC-AGG-ID: nQ4DDfqXPK2cnN4hGIJDvA_1772007289
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A0E82195609D;
	Wed, 25 Feb 2026 08:14:48 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.55])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DE8351800351;
	Wed, 25 Feb 2026 08:14:38 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: kasan-dev@googlegroups.com
Cc: linux-mm@kvack.org,
	andreyknvl@gmail.com,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	dvyukov@google.com,
	linux-kernel@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	linux-s390@vger.kernel.org,
	hca@linux.ibm.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v5 01/15] mm/kasan: add conditional checks in functions to return directly if kasan is disabled
Date: Wed, 25 Feb 2026 16:13:58 +0800
Message-ID: <20260225081412.76502-2-bhe@redhat.com>
In-Reply-To: <20260225081412.76502-1-bhe@redhat.com>
References: <20260225081412.76502-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: uOAGFtC5kDf26UwHKdoXGypoX3icCI4NimEOazs8lPE_1772007289
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 51A4840002
X-Stat-Signature: w6m8bg5sjg9twxpxfw3fr7tu75o4z8y4
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772007297-995309
X-HE-Meta: U2FsdGVkX1+sJzmkzn1sjNB6QBTXeEO+tFLkGs0NGVw8E2EP8diOYeGDSXhtDh+S9SRVWsuqwhYD3mTOvzkoG3m/wk1+QnRXUcQggClOH96C4/Uj4lbQrhV1FxFUY3gO2zqHPPI70KYBYV+OuM0bJMUxQNPs4QW3fQTqqYVmRaZFkHZ40dQdoEIh6KQDJcafHn9kv/+hKSshk9EGfw29azLeHY4gbVrMdriaDEdCJuQdt3pdBlCcO7O1IWMUzNrLb3hPwavwzfpPct9d2FVfDHM/sCWcMLwLJRgXBVooCIJE778LX432vTmgnPfMrEOdopRenGSqCnDssnKbI6FqTQz+eGi1yet+sQVRl9/+qF66b5raBCj31ghF6l3XKyHsbkjhQCM4/2ED6hUTqOpjSzjkZckXbPzuY4PFf8xHIteOSEO2FrErN616pnTqq7otxjBX+qgZykxMopkF6aOfRw6IJd7RnFdc93kRE5X6g5ep46HfXH6B5sFWEZlpBveOSVe+5vVIxOx3a2zWxp87vZefZP+tHTIySUriiPyWRJ3pVqlRT6PXlEVG7eOnB9KXc9eEq+IDZCi7Gc4qm2ncnVl+3dmPHaLDd58Cg7Cu5Jr8KdvAHZbplNbfQk7rAQHXQP+8/zBrAPKFOKNyxROaSYV6t9dQxOP+roA3n2kqVGZIqmUW+6WljUbcvQVJ7CkdHnazTUqdqIqAN7Yjbje0Ztjs63jFmOQ6Ok6VrzTy8MviTuQ0rsSMXZ1aQvotrUcED+KFgpGn7yPselx6RD9kFPx1WBIZUermVHfwZ0KTcMHstdBN61iAHswFjoj9cMcb7oZypM1BAKI95xJ++l6dNL4NFPoAA9IE/dGZsVhns+DZFFdAQEvYwWOpwnhrAi856MkdUMd26srYBPu2kuzAd5uSGiq0Md9eX5Nbrpinp5encztDDD9KhDZ8mAdlp1ehHbn9RJsUyrnmb5zeaTg
 f/+h3LTK
 sgu2P8IEojPrYDK/3CTS2eFZDhZ+gC22rsapVXYPvyhwGHuMVEhgV6kNFFUWKnstlh2G+ZRJnKubZVr+DpfopNsGFOjXyMkzcLjbyjksPcCJmvBuioFtA8Urem4zIRx0BELtzS7ss04/R9tnHPzoE1rn+DQRKa7YvLF322mSu0nRA0rCbEo6zX+0YCyXpjEKO9XkPW4CQ5Reqpd9KYX/dJk0g+UOGwe6Vu9mg8Q3SsEH5zVuGNEjjCvPu3mcAkiZs0W7ebpGE/qTZC5Sr2ROK5zVn/DrerLg7dc75lhH5vK6YAcFLLi165xK6friYzVVa3SIHf8hnKKTnv+TN1Lm8u+qslOidPUXUn4RhYaiB0cp5h3M6fjlgY24M8EdIaUx87iOT9gHbCFEEyNnLRI9QUYeqPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current codes only check if kasan is disabled for hw_tags
mode. Here add the conditional checks for functional functions of
generic mode and sw_tags mode.

And also add a helper __kasan_cache_shrink() in mm/kasan/generic.c
so that the conditional check is done in include/linux/kasan.h.

This is prepared for later adding kernel parameter kasan=on|off for
all three kasan modes.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 include/linux/kasan.h |  7 ++++++-
 mm/kasan/generic.c    | 16 ++++++++++++++--
 mm/kasan/init.c       |  6 ++++++
 mm/kasan/quarantine.c |  3 +++
 mm/kasan/report.c     |  4 +++-
 mm/kasan/shadow.c     | 11 ++++++++++-
 mm/kasan/sw_tags.c    |  3 +++
 7 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 338a1921a50a..a9b8d58d8699 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -492,7 +492,12 @@ size_t kasan_metadata_size(struct kmem_cache *cache, bool in_object);
 void kasan_cache_create(struct kmem_cache *cache, unsigned int *size,
 			slab_flags_t *flags);
 
-void kasan_cache_shrink(struct kmem_cache *cache);
+void __kasan_cache_shrink(struct kmem_cache *cache);
+static inline void kasan_cache_shrink(struct kmem_cache *cache)
+{
+	if (kasan_enabled())
+		__kasan_cache_shrink(cache);
+}
 void kasan_cache_shutdown(struct kmem_cache *cache);
 void kasan_record_aux_stack(void *ptr);
 
diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
index 2b8e73f5f6a7..25850e7c2e00 100644
--- a/mm/kasan/generic.c
+++ b/mm/kasan/generic.c
@@ -212,14 +212,14 @@ bool kasan_byte_accessible(const void *addr)
 	return shadow_byte >= 0 && shadow_byte < KASAN_GRANULE_SIZE;
 }
 
-void kasan_cache_shrink(struct kmem_cache *cache)
+void __kasan_cache_shrink(struct kmem_cache *cache)
 {
 	kasan_quarantine_remove_cache(cache);
 }
 
 void kasan_cache_shutdown(struct kmem_cache *cache)
 {
-	if (!__kmem_cache_empty(cache))
+	if (kasan_enabled() && !__kmem_cache_empty(cache))
 		kasan_quarantine_remove_cache(cache);
 }
 
@@ -239,6 +239,9 @@ void __asan_register_globals(void *ptr, ssize_t size)
 	int i;
 	struct kasan_global *globals = ptr;
 
+	if (!kasan_enabled())
+		return;
+
 	for (i = 0; i < size; i++)
 		register_global(&globals[i]);
 }
@@ -369,6 +372,9 @@ void kasan_cache_create(struct kmem_cache *cache, unsigned int *size,
 	unsigned int rem_free_meta_size;
 	unsigned int orig_alloc_meta_offset;
 
+	if (!kasan_enabled())
+		return;
+
 	if (!kasan_requires_meta())
 		return;
 
@@ -518,6 +524,9 @@ size_t kasan_metadata_size(struct kmem_cache *cache, bool in_object)
 {
 	struct kasan_cache *info = &cache->kasan_info;
 
+	if (!kasan_enabled())
+		return 0;
+
 	if (!kasan_requires_meta())
 		return 0;
 
@@ -543,6 +552,9 @@ void kasan_record_aux_stack(void *addr)
 	struct kasan_alloc_meta *alloc_meta;
 	void *object;
 
+	if (!kasan_enabled())
+		return;
+
 	if (is_kfence_address(addr) || !slab)
 		return;
 
diff --git a/mm/kasan/init.c b/mm/kasan/init.c
index f084e7a5df1e..c78d77ed47bc 100644
--- a/mm/kasan/init.c
+++ b/mm/kasan/init.c
@@ -447,6 +447,9 @@ void kasan_remove_zero_shadow(void *start, unsigned long size)
 	unsigned long addr, end, next;
 	pgd_t *pgd;
 
+	if (!kasan_enabled())
+		return;
+
 	addr = (unsigned long)kasan_mem_to_shadow(start);
 	end = addr + (size >> KASAN_SHADOW_SCALE_SHIFT);
 
@@ -482,6 +485,9 @@ int kasan_add_zero_shadow(void *start, unsigned long size)
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
index 27efb78eb32d..1a39b3f62c57 100644
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
index d286e0a04543..87f517b76d6e 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -164,6 +164,8 @@ void kasan_unpoison(const void *addr, size_t size, bool init)
 {
 	u8 tag = get_tag(addr);
 
+	if (!kasan_enabled())
+		return;
 	/*
 	 * Perform shadow offset calculation based on untagged address, as
 	 * some of the callers (e.g. kasan_unpoison_new_object) pass tagged
@@ -277,7 +279,8 @@ static int __meminit kasan_mem_notifier(struct notifier_block *nb,
 
 static int __init kasan_memhotplug_init(void)
 {
-	hotplug_memory_notifier(kasan_mem_notifier, DEFAULT_CALLBACK_PRI);
+	if (kasan_enabled())
+		hotplug_memory_notifier(kasan_mem_notifier, DEFAULT_CALLBACK_PRI);
 
 	return 0;
 }
@@ -660,6 +663,9 @@ int kasan_alloc_module_shadow(void *addr, size_t size, gfp_t gfp_mask)
 	size_t shadow_size;
 	unsigned long shadow_start;
 
+	if (!kasan_enabled())
+		return 0;
+
 	shadow_start = (unsigned long)kasan_mem_to_shadow(addr);
 	scaled_size = (size + KASAN_GRANULE_SIZE - 1) >>
 				KASAN_SHADOW_SCALE_SHIFT;
@@ -696,6 +702,9 @@ int kasan_alloc_module_shadow(void *addr, size_t size, gfp_t gfp_mask)
 
 void kasan_free_module_shadow(const struct vm_struct *vm)
 {
+	if (!kasan_enabled())
+		return;
+
 	if (IS_ENABLED(CONFIG_UML))
 		return;
 
diff --git a/mm/kasan/sw_tags.c b/mm/kasan/sw_tags.c
index c75741a74602..6c1caec4261a 100644
--- a/mm/kasan/sw_tags.c
+++ b/mm/kasan/sw_tags.c
@@ -79,6 +79,9 @@ bool kasan_check_range(const void *addr, size_t size, bool write,
 	u8 *shadow_first, *shadow_last, *shadow;
 	void *untagged_addr;
 
+	if (!kasan_enabled())
+		return true;
+
 	if (unlikely(size == 0))
 		return true;
 
-- 
2.52.0


