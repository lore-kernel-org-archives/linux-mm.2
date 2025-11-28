Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA1F3D116F1
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 03:33:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 151676B0022; Thu, 27 Nov 2025 22:33:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 129826B0023; Thu, 27 Nov 2025 22:33:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03F426B0024; Thu, 27 Nov 2025 22:33:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E90326B0022
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 22:33:52 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6D4ACC0350
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:33:52 +0000 (UTC)
X-FDA: 84158596704.03.62A8723
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id A40E0140004
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:33:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Skgr8bCv;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764300830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UdCEhX0QnAccjf1ifoDBiGeeToccBUA00HLj78ygtME=;
	b=VZqTsliOifZYpM2iJQZ7hCc7nVlmyFIPr7Elrge6oCeuTTEPA/ePmLAxgLSv0jK4CqFQgk
	NJjE7gUIUjo44wh4nfniBFy8yWpMF9lsBhZsGhINHjUInR/00Ia2G15Li5sBAnOT9AXfW4
	38qoTxRphQ/l9t3WqE27Tfy3qOp2568=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Skgr8bCv;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764300830; a=rsa-sha256;
	cv=none;
	b=CxeoS8SMsGpw4ldIxwzRdzEXDy95H5SfEBhsHo/681HCZoqr/EjGJBfQpDKUWvuDDcjIg5
	4M7eoOGZlBXg4Ek4XwueOUYkXnz5xsLY191CFqHpYU8nfdRt7+Q6E1qFU3raIc6QcpUVIx
	Q9CTTgPvZQUrAHkL03vwMU+AssVzCkM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764300829;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UdCEhX0QnAccjf1ifoDBiGeeToccBUA00HLj78ygtME=;
	b=Skgr8bCvUlk4LrJxBuqj0vaZiRdFadGtwZCRS6qOLtAoKoWBWM1qCxTUE49hmEJm/yIem1
	m9QjchoLvYNaxBV7loHOj814LxeCkWV+dSGv6KepSF4JGjjRHORFbqzYClMCnCZg+jdrr4
	zitu7YoK+yguy9R47flO+ilcvL4HNno=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-561-UOimTxoJOkekNTmxQjBXig-1; Thu,
 27 Nov 2025 22:33:46 -0500
X-MC-Unique: UOimTxoJOkekNTmxQjBXig-1
X-Mimecast-MFC-AGG-ID: UOimTxoJOkekNTmxQjBXig_1764300824
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AE5031956095;
	Fri, 28 Nov 2025 03:33:43 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.7])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 003BC19560B7;
	Fri, 28 Nov 2025 03:33:34 +0000 (UTC)
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
	elver@google.com,
	sj@kernel.org,
	lorenzo.stoakes@oracle.com,
	snovitoll@gmail.com,
	christophe.leroy@csgroup.eu,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v4 01/12] mm/kasan: add conditional checks in functions to return directly if kasan is disabled
Date: Fri, 28 Nov 2025 11:33:09 +0800
Message-ID: <20251128033320.1349620-2-bhe@redhat.com>
In-Reply-To: <20251128033320.1349620-1-bhe@redhat.com>
References: <20251128033320.1349620-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspam-User: 
X-Rspamd-Queue-Id: A40E0140004
X-Rspamd-Server: rspam11
X-Stat-Signature: 5fd8szuhzkrfkkrrqntnifqnkos7da3c
X-HE-Tag: 1764300830-375542
X-HE-Meta: U2FsdGVkX18vPnIBzs1DuTOrNh4THKcxMrPMfgA4liQnWqURwSlMByOTxFP4ZHdvwNnvrc4bAaN1Sw3slAj42PZEptPF6IWJtk4AyOVhGmXUFeQKC0Hy0/3YnxRPaSdRgkv4E8ePRsO7OJF0X1VDvb+UAOlQRtEuRdvrM3rUn9Un2lNiKV5danGxkx1r1yH31oMEFLkUG4tfrFFTL8NTdw3JhiRAfsafi1lZTGcjtEW71Yf0wuR+UoL43ThSIpSHzYqkojq9T/BOfBET82zVY0vFbyHTTm5LL2sQMnRXLT+Kh2oQpcYE8vVFqc169F1w0Ff5RARtyC7pFpxK+DAkIHeum0h5DfuzOueU8WcnAwoNzahUz8k88PeeRQwfhhBHsyZLdCNpHWaR+nbZmGqiLTuVVRPQM92WUIV7j14vegSVXHo+zudwUd9FxEe3V7iRaF1NgnWBv2JvvtYp3MUlDYd6ydDwsTWc0b4mP8IvQFfZMIVQVKUwbrQ9btcnZbfPq6XRZUpM+v+msrLxrYqjFisAQhTR6mNzRtYQoI/gwbfjWx0hHjnfMq1q3R7mMLzxnlFKmIfetyGrkIbsw3PrcKmNnwAM1CVB6Lx8rVHpWQM4tTMIDTJ9ly5vBRUnFi0M3ldoZoL3cUY+6olfop30VAwIrgs8wopOBl4+ewSdyA/gNYwO9SOer4iCzo3azMwylApaq/yOIWxiyRsl42lDZzNjjWZMlsZ4GmspvW8SKRSwO4bS2WDS8KmehxqRl8v1swsJoZoHyOPREm9+CrmVuutno5Lz0lLSC6gLgQd13oWkDVn+aRvmWoaAokyp0w3G61oJC3ViCFyLlwsWksbqJOZ3NA7fx5PQd/pU0MkYcsbG/FywMSTxqmZQygVbZaMLn6Gv4/l+invx3fs0O40BNkZlpp8warNxZNHXHMzQyVUECajFUPZ5hnLmIzdIqAjvb/x3e7xO1Lm2AtZAuMY
 5rs9ye/p
 RKS2OQ9Z3kv+CeXHKYXBPW6Z+yBuBxco0S0WSY8t1y8hFnHig1/uBA7vg2pGyNBrH6ws/spw61QFcrIrSiHyXfvPhsJWitfwsNKgCX0rNT/BXU+K5wWu+uirl+MWy52Il2v43Rs3U+yAicDybGXaF8aCJdQSW+lQmbqVt6BPh7sdrhOlbe4Se7PEn6lT0FAIBMqi2eLUfgxQV12+1r3KSlw7zUmfNxnqPChOcV7yZt1C3RDMqIB5XUbrmNmq+ZvXWqZnHE3anmrlFCNmOmKrfduHy7lNxWTHkW2/vJEt/JIo08vY27ojdssWLlEjzaC4hVP5RjWg9EbpjPoZfNiUDfeVR/usjOcKkxlWcjKxcp1Wx1fiR3tWShmhrX81X9m8071HkiX+jb1rhSB+GONBeIxIOLQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current codes only check if kasan is disabled for hw_tags
mode. Here add the conditional checks for functional functions of
generic mode and sw_tags mode.

This is prepared for later adding kernel parameter kasan=on|off for
all three kasan modes.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 mm/kasan/generic.c    | 17 +++++++++++++++--
 mm/kasan/init.c       |  6 ++++++
 mm/kasan/quarantine.c |  3 +++
 mm/kasan/report.c     |  4 +++-
 mm/kasan/shadow.c     | 11 ++++++++++-
 mm/kasan/sw_tags.c    |  3 +++
 6 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
index 2b8e73f5f6a7..aff822aa2bd6 100644
--- a/mm/kasan/generic.c
+++ b/mm/kasan/generic.c
@@ -214,12 +214,13 @@ bool kasan_byte_accessible(const void *addr)
 
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
 
@@ -239,6 +240,9 @@ void __asan_register_globals(void *ptr, ssize_t size)
 	int i;
 	struct kasan_global *globals = ptr;
 
+	if (!kasan_enabled())
+		return;
+
 	for (i = 0; i < size; i++)
 		register_global(&globals[i]);
 }
@@ -369,6 +373,9 @@ void kasan_cache_create(struct kmem_cache *cache, unsigned int *size,
 	unsigned int rem_free_meta_size;
 	unsigned int orig_alloc_meta_offset;
 
+	if (!kasan_enabled())
+		return;
+
 	if (!kasan_requires_meta())
 		return;
 
@@ -518,6 +525,9 @@ size_t kasan_metadata_size(struct kmem_cache *cache, bool in_object)
 {
 	struct kasan_cache *info = &cache->kasan_info;
 
+	if (!kasan_enabled())
+		return 0;
+
 	if (!kasan_requires_meta())
 		return 0;
 
@@ -543,6 +553,9 @@ void kasan_record_aux_stack(void *addr)
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
index 29a751a8a08d..f73a691421de 100644
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
@@ -658,6 +661,9 @@ int kasan_alloc_module_shadow(void *addr, size_t size, gfp_t gfp_mask)
 	size_t shadow_size;
 	unsigned long shadow_start;
 
+	if (!kasan_enabled())
+		return 0;
+
 	shadow_start = (unsigned long)kasan_mem_to_shadow(addr);
 	scaled_size = (size + KASAN_GRANULE_SIZE - 1) >>
 				KASAN_SHADOW_SCALE_SHIFT;
@@ -694,6 +700,9 @@ int kasan_alloc_module_shadow(void *addr, size_t size, gfp_t gfp_mask)
 
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
2.41.0


