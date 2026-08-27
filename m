Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D97FDC61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:25:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8AF06B00A6; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B388B6B00A2; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82B7C6B00AF; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3EF546B00A2
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C0D24A10E4
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:45 +0000 (UTC)
X-FDA: 85147572930.13.9606763
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf14.hostedemail.com (Postfix) with ESMTP id B297F100002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=s4BuyPR4;
	spf=pass (imf14.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787847883;
	b=E9kRSbe/pktaXC04Wn0/IE2YLjvs77FdVMynQTqTgo1IYNu0BITXdphpB9vtMKRHEk1xlh
	MIeCotxPLzilMQb7daSOrClQUMkd3qjSCo29qfubO/n5+4z5qk+BarHmOsAxOCHRvdpHyO
	tuwja1zUJpn/jmRBkXZeq6DHv/NaZ1E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=s4BuyPR4;
	spf=pass (imf14.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787847883;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mJEDJhtFMNSnLhy3o2OpHLDFK+OrNY4mUlH1+uIwElw=;
	b=sHKt4tJbzzMTurMbHThvdbS6EqukPqk9gC4aQy7J+ublPO8DZFtTe1IC7+0lgl4R/e6e0Y
	oDey9KIApZu15ZkWjX7RWuNSThaDNkJdAlZiEWk/wfOErH8qm7SYvxCpw2rBwXk4+MR+Hh
	IoGMrSMoYNkTdr6UjA8jXzMiRISLYVw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=mJEDJhtFMNSnLhy3o2OpHLDFK+OrNY4mUlH1+uIwElw=;
	b=s4BuyPR4z6gvxyyhsQPmUQLxP8SwiElyHOlbrC1Eo4Rgkt/YbyWTj7n33YgGtw0nWyN69mN76
	NsVuPhOXAWVkrROAXHp01c/lc4cxcZuHQq/5FRCUYaAjOnDpMs3T63Y5vAGwjSZpB6mzq+tZFFj
	YQyUpUQJBZabrg0CIZAOjmw=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hW6KX5cWQzJ46Yq;
	Fri, 28 Aug 2026 00:24:16 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 55E1340572;
	Fri, 28 Aug 2026 00:24:38 +0800 (CST)
Received: from mscphis00949.huawei.com (10.123.66.11) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 27 Aug 2026 19:24:37 +0300
From: Nikita Panov <panov.nikita@huawei.com>
To: <catalin.marinas@arm.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <vbabka@kernel.org>, <cl@gentwo.org>,
	<linux@armlinux.org.uk>, <will@kernel.org>, <mark.rutland@arm.com>,
	<liam@infradead.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <wangkefeng.wang@huawei.com>,
	<artem.kuzin@huawei.com>, <panov.nikita@huawei.com>
Subject: [RFC PATCH 17/18] mm: init kernel modules with replication support
Date: Fri, 28 Aug 2026 00:11:57 +0800
Message-ID: <20260827161158.3618409-18-panov.nikita@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260827161158.3618409-1-panov.nikita@huawei.com>
References: <20260827161158.3618409-1-panov.nikita@huawei.com>
Reply-To: <artem.kuzin@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.11]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500004.china.huawei.com (7.188.26.250)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B297F100002
X-Stat-Signature: z6x5c9inhdx77adw1j65ij84x18x41s1
X-HE-Tag: 1787847883-585929
X-HE-Meta: U2FsdGVkX18W7wufh4TLMr92WDmvUJoRQoQHASJ1/078e5+FZL1+qs0LGDqJaV3G/BDlGQMozQi19Sf4aaQri3rkU+KWYo9OjCh9ugjXjq86RUZ85XVdgIBegla6/GCLMKsEAWrgKSQA89lsI0yd8xOfmBwm10kZaStLXziJ2LI1Y3xT4oxG8Q3hTqCYIdMOmjeTFY4E1OJoQ3de/yCzLMDqz3W4CK0xaGcrkjYddC9VyNCP0WUhfQ3gE3w/8oezsJzGSfhHPhlVO/Dl+hP1Kl49xPrwJkb69/A9+mqmoI6QS3kyr/oVTnDAwQwUDM8ZnhLKo+lRCuulejS+zHtJllMroDUuAfNNg7g/WM3ZtetT3D+bSGG+KwFKgcJ/qkvs7Cvmd9anhy5jNXlgSIjt3BR5pIAiu+ZaIaDjcyH8aMx7mXe1NfM4sn4SE2mUFRo6DT1nDYFJDoZFo/IYm8U8IAEsZjz0a+CBwQPSVou6znhvnSmzg07u9fjqK5TaroZwuncoewNhMGOFmNASIEuZOll5QAQyzmk3LlIHC/+mIEeY2uP29ZT+YtqtTPaFUcxREPYb3wdCLhlJAB5SM1GgGX8MrA/zBIwxSk1/dd/YtVHC1t7Hn+CLP/yHj6IjdgIOOnn4M16QIzVB7i2FrzgSW19+rSywdQGNZhsPuykx1nMymXHkHpb/ZwXyYLGCLSMido98eNmjr0FvEU/+nlb7YMqcJhQB7ibowLpClThgvo2P7UWkLNhh6aOXg/gJUO75f/S+d6THKokM25swtKtMbsKbtjbZaJcNjDgXJhbkRpa7/8CTsndBh5s3RCUblSd8yz+GSdFjKjztCPDIldmfZN2EKKyI2b1G6CXhdXteQAOCtsA0XnCzr/oThXRdJLMlt43Tpv6xvfHWFKbwGuIgSypEFog4+v0YtSTp+yVZrlG/CqYj9Fdhst3GtX9ZMpO9NhQJDdkF0nPAmK+mxFM
 fgnWwEh7
 bjTwtCUAbUNe5j5pJxxnqYH4ZI6AgISIVCeTvQfPlwWNQahY8jOWXUJs0xQf2Wf+FcwPKC/ztOr7DdK8h0pGUFuaOjsWVrYTCxlBMjNB3HjyJ76FIIu1JlbpfsKCH+YSR9JZTK/NcWYW0JgXAjMsBpMDc/pQ/gIPKKg/BW/kSDhAbA62j7qAyliGsSjVhPh8KUv/aIctRn9k3R1yoaG1gan48MGygBBZ1B4JqR9h+h1TK4xSSr7rn/76Nhjo8uQBtqyZhVeL78AQ0YDyCqAxNOnVJOXDBiFWBHfqmoKdNyeSrkjzWdDSI98GhUTJt7PcC87NyE/a1eYglO6UCRr/30jOqURX+idQIRVsbUaSMgnbqdj+TsrXu36LInXpnpPU6CXBxOvc9G3ab7R/EApZSHJMySRBwQtlHdn1gJu2rz26p7ECVL1pJt2a3bAB33ofWy+AhW9uulzymJQC+jovGA9S8aKJzcFPPH3eBFTrITodY2zdnmg+PQl0HYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Artem Kuzin <artem.kuzin@huawei.com>
Acked-by: Alexander Grubnikov <alexander.grubnikov@huawei.com>
Acked-by: Ilya Hanov <ilya.hanov@huawei-partners.com>
Acked-by: Denis Darvish <darvish.denis@huawei.com>
Signed-off-by: Nikita Panov <panov.nikita@huawei.com>
---
 include/linux/moduleloader.h |  4 ++++
 kernel/module/main.c         | 17 ++++++++++++++++
 kernel/module/strict_rwx.c   | 12 +++++------
 mm/execmem.c                 | 39 +++++++++++++++++++++++++++++++-----
 4 files changed, 61 insertions(+), 11 deletions(-)

diff --git a/include/linux/moduleloader.h b/include/linux/moduleloader.h
index e395461d59e5..1d100dfc8251 100644
--- a/include/linux/moduleloader.h
+++ b/include/linux/moduleloader.h
@@ -25,6 +25,10 @@ int module_frob_arch_sections(Elf_Ehdr *hdr,
 /* Additional bytes needed by arch in front of individual sections */
 unsigned int arch_mod_section_prepend(struct module *mod, unsigned int section);
 
+#ifdef CONFIG_KERNEL_REPLICATION
+void module_replicate(void *ptr);
+#endif /* CONFIG_KERNEL_REPLICATION */
+
 /* Determines if the section name is an init section (that is only used during
  * module loading).
  */
diff --git a/kernel/module/main.c b/kernel/module/main.c
index d0e1e0bd2ad0..d5c8f041be48 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -60,6 +60,7 @@
 #include <linux/codetag.h>
 #include <linux/debugfs.h>
 #include <linux/execmem.h>
+#include <linux/numa_kernel_replication.h>
 #include <uapi/linux/module.h>
 #include "internal.h"
 
@@ -1338,6 +1339,18 @@ void __weak module_arch_freeing_init(struct module *mod)
 {
 }
 
+#ifdef CONFIG_KERNEL_REPLICATION
+static int sections_to_replicate[] = {MOD_TEXT, MOD_RODATA};
+
+static void module_replicate_sections(struct module *mod)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(sections_to_replicate); i++)
+		module_replicate(mod->mem[sections_to_replicate[i]].base);
+}
+#endif /* CONFIG_KERNEL_REPLICATION */
+
 static int module_memory_alloc(struct module *mod, enum mod_mem_type type)
 {
 	unsigned int size = PAGE_ALIGN(mod->mem[type].size);
@@ -3330,6 +3343,10 @@ static int complete_formation(struct module *mod, struct load_info *info)
 	module_bug_finalize(info->hdr, info->sechdrs, mod);
 	module_cfi_finalize(info->hdr, info->sechdrs, mod);
 
+#ifdef CONFIG_KERNEL_REPLICATION
+	module_replicate_sections(mod);
+#endif
+
 	err = module_enable_rodata_ro(mod);
 	if (err)
 		goto out_strict_rwx;
diff --git a/kernel/module/strict_rwx.c b/kernel/module/strict_rwx.c
index 8fd438529fbc..07ad1af69eaa 100644
--- a/kernel/module/strict_rwx.c
+++ b/kernel/module/strict_rwx.c
@@ -39,9 +39,9 @@ int module_enable_text_rox(const struct module *mod)
 		if (mem->is_rox)
 			ret = execmem_restore_rox(mem->base, mem->size);
 		else if (IS_ENABLED(CONFIG_STRICT_MODULE_RWX))
-			ret = module_set_memory(mod, type, set_memory_rox);
+			ret = module_set_memory(mod, type, numa_set_memory_rox);
 		else
-			ret = module_set_memory(mod, type, set_memory_x);
+			ret = module_set_memory(mod, type, numa_set_memory_x);
 		if (ret)
 			return ret;
 	}
@@ -55,10 +55,10 @@ int module_enable_rodata_ro(const struct module *mod)
 	if (!IS_ENABLED(CONFIG_STRICT_MODULE_RWX) || !rodata_enabled)
 		return 0;
 
-	ret = module_set_memory(mod, MOD_RODATA, set_memory_ro);
+	ret = module_set_memory(mod, MOD_RODATA, numa_set_memory_ro);
 	if (ret)
 		return ret;
-	ret = module_set_memory(mod, MOD_INIT_RODATA, set_memory_ro);
+	ret = module_set_memory(mod, MOD_INIT_RODATA, numa_set_memory_ro);
 	if (ret)
 		return ret;
 
@@ -70,7 +70,7 @@ int module_enable_rodata_ro_after_init(const struct module *mod)
 	if (!IS_ENABLED(CONFIG_STRICT_MODULE_RWX) || !rodata_enabled)
 		return 0;
 
-	return module_set_memory(mod, MOD_RO_AFTER_INIT, set_memory_ro);
+	return module_set_memory(mod, MOD_RO_AFTER_INIT, numa_set_memory_ro);
 }
 
 int module_enable_data_nx(const struct module *mod)
@@ -79,7 +79,7 @@ int module_enable_data_nx(const struct module *mod)
 		return 0;
 
 	for_class_mod_mem_type(type, data) {
-		int ret = module_set_memory(mod, type, set_memory_nx);
+		int ret = module_set_memory(mod, type, numa_set_memory_nx);
 
 		if (ret)
 			return ret;
diff --git a/mm/execmem.c b/mm/execmem.c
index 74a178a87e75..ea4b15c8a788 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -16,6 +16,7 @@
 #include <linux/set_memory.h>
 #include <linux/moduleloader.h>
 #include <linux/text-patching.h>
+#include <linux/numa_kernel_replication.h>
 
 #include <asm/tlbflush.h>
 
@@ -26,8 +27,9 @@ static struct execmem_info *execmem_info __ro_after_init;
 static struct execmem_info default_execmem_info __ro_after_init;
 
 #ifdef CONFIG_MMU
-static void *execmem_vmalloc(struct execmem_range *range, size_t size,
-			     pgprot_t pgprot, unsigned long vm_flags)
+
+static void *execmem_vmalloc_node(struct execmem_range *range, size_t size,
+			     pgprot_t pgprot, unsigned long vm_flags, int node)
 {
 	bool kasan = range->flags & EXECMEM_KASAN_SHADOW;
 	gfp_t gfp_flags = GFP_KERNEL | __GFP_NOWARN;
@@ -40,13 +42,13 @@ static void *execmem_vmalloc(struct execmem_range *range, size_t size,
 		vm_flags |= VM_DEFER_KMEMLEAK;
 
 	p = __vmalloc_node_range(size, align, start, end, gfp_flags,
-				 pgprot, vm_flags, NUMA_NO_NODE,
+				 pgprot, vm_flags, node,
 				 __builtin_return_address(0));
 	if (!p && range->fallback_start) {
 		start = range->fallback_start;
 		end = range->fallback_end;
 		p = __vmalloc_node_range(size, align, start, end, gfp_flags,
-					 pgprot, vm_flags, NUMA_NO_NODE,
+					 pgprot, vm_flags, node,
 					 __builtin_return_address(0));
 	}
 
@@ -63,6 +65,26 @@ static void *execmem_vmalloc(struct execmem_range *range, size_t size,
 	return p;
 }
 
+#ifdef CONFIG_KERNEL_REPLICATION
+static void *execmem_vmalloc_type(struct execmem_range *range, size_t size,
+			     pgprot_t pgprot, unsigned long vm_flags, enum execmem_type type)
+{
+	if (is_text_replicated() && (type == EXECMEM_MODULE_TEXT || type == EXECMEM_MODULE_DATA))
+		/* Need to specify some numa node id for correct allocation and further replication */
+		return execmem_vmalloc_node(range, size, pgprot,
+					vm_flags | VM_NUMA_SHARED, numa_node_id());
+	else
+		return execmem_vmalloc_node(range, size, pgprot,
+					vm_flags, NUMA_NO_NODE);
+}
+#else
+static void *execmem_vmalloc_type(struct execmem_range *range, size_t size,
+			     pgprot_t pgprot, unsigned long vm_flags, enum execmem_type type)
+{
+	return execmem_vmalloc_node(range, size, pgprot, vm_flags, NUMA_NO_NODE);
+}
+#endif
+
 struct vm_struct *execmem_vmap(size_t size)
 {
 	struct execmem_range *range = &execmem_info->ranges[EXECMEM_MODULE_DATA];
@@ -87,6 +109,13 @@ static void *execmem_vmalloc(struct execmem_range *range, size_t size,
 #endif /* CONFIG_MMU */
 
 #ifdef CONFIG_ARCH_HAS_EXECMEM_ROX
+
+static void *execmem_vmalloc(struct execmem_range *range, size_t size,
+			     pgprot_t pgprot, unsigned long vm_flags)
+{
+	return execmem_vmalloc_node(range, size, pgprot, vm_flags, NUMA_NO_NODE);
+}
+
 struct execmem_cache {
 	struct mutex mutex;
 	struct maple_tree busy_areas;
@@ -475,7 +504,7 @@ void *execmem_alloc(enum execmem_type type, size_t size)
 	if (use_cache)
 		p = execmem_cache_alloc(range, size);
 	else
-		p = execmem_vmalloc(range, size, pgprot, vm_flags);
+		p = execmem_vmalloc_type(range, size, pgprot, vm_flags, type);
 
 	return kasan_reset_tag(p);
 }
-- 
2.34.1


