Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE9D8D66B87
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 01:59:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 271D86B008C; Wed, 17 Dec 2025 20:59:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21D1D6B0095; Wed, 17 Dec 2025 20:59:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E951B6B008C; Wed, 17 Dec 2025 20:59:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C271C6B008C
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 20:59:11 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 85FCD140C92
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:59:11 +0000 (UTC)
X-FDA: 84230934102.27.C7D9C78
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf05.hostedemail.com (Postfix) with ESMTP id E2E06100002
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:59:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=iU94+Fuq;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf05.hostedemail.com: domain of yuanlinyu@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=yuanlinyu@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766023149; a=rsa-sha256;
	cv=none;
	b=wHl8dHXRie7jEBnVSa5dm7LdoN85DLT2han3Wv4GErxSmcWesvM4fXZ73dbO+GPrfiRM7n
	LFFTfLaswJuvCjdGLFry99d+E/tJ5gRa5F39dY/kGxIwHTM/lc+pjokvESO1Ipfp4nnwJQ
	s0lOZA9TtC/G7NQn/fiZeGy+vIC8J0k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=iU94+Fuq;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf05.hostedemail.com: domain of yuanlinyu@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=yuanlinyu@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766023149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hU40RLa4jRhtk5Sc+fhCSmQtLG8/DL1BTepfIHBkGLs=;
	b=RHRnFxB52hjsFoORx8adeRHazEbhG72Job81EbfqtNFI2ADe2/Nq+beJ0IXv7/uEtjBTDN
	Y5Df+meL01sE3LosjW7hOGKxBMuINSPkBD7/TDngMzMYfLha+GzlGfq5t1fBEYg5URp6BS
	YeZtloUw9kuAJSHVBLFxQdPh2KvVM5A=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=hU40RLa4jRhtk5Sc+fhCSmQtLG8/DL1BTepfIHBkGLs=;
	b=iU94+FuqIzGpv2DTR0/CvobFtspitqmbm/y+jfs+2cVymrHGVLdQWGK1fXZGtzTaAkJAdKa9f
	Ibdo9tCeAVLaHB9qEIXkL3W+dnTckzPK0Owmj+W9pdt4eZqYUhyL/ZVTA5hDC+wvMfMuO6HDfvn
	0/CTw+KygTKDLc8d7rn+eMA=
Received: from w012.hihonor.com (unknown [10.68.27.189])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4dWv1B6lt7zYmf8k;
	Thu, 18 Dec 2025 09:57:02 +0800 (CST)
Received: from w025.hihonor.com (10.68.28.69) by w012.hihonor.com
 (10.68.27.189) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Thu, 18 Dec
 2025 09:59:02 +0800
Received: from localhost.localdomain (10.144.17.252) by w025.hihonor.com
 (10.68.28.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Thu, 18 Dec
 2025 09:59:02 +0800
From: yuan linyu <yuanlinyu@honor.com>
To: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
	<akpm@linux-foundation.org>, Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui
	<kernel@xen0n.name>, <kasan-dev@googlegroups.com>, <linux-mm@kvack.org>,
	<loongarch@lists.linux.dev>
CC: <linux-kernel@vger.kernel.org>, yuan linyu <yuanlinyu@honor.com>
Subject: [PATCH 3/3] kfence: allow change number of object by early parameter
Date: Thu, 18 Dec 2025 09:58:49 +0800
Message-ID: <20251218015849.1414609-4-yuanlinyu@honor.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251218015849.1414609-1-yuanlinyu@honor.com>
References: <20251218015849.1414609-1-yuanlinyu@honor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.144.17.252]
X-ClientProxiedBy: w012.hihonor.com (10.68.27.189) To w025.hihonor.com
 (10.68.28.69)
X-Rspamd-Queue-Id: E2E06100002
X-Stat-Signature: 95ipiywkuu6hp74d59n4wfcp9t53iafw
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766023148-155607
X-HE-Meta: U2FsdGVkX1975d2/MnUxBsgov+KZonJPq9yJ96h1bsnz26ykZx1EoJjRp1+c49/Jv10SBbESMG3i9xhQ2zKuNwnQ3+42mCI53zNMzHNcWNP2ZRNJwForFm/qiO1qwSsGoshalLZbFMTwNCtJKTGJDwVZAPgefq7kUBNd0caeacGDI6MGjnWg4BuwxxrikqLWydFUkwYhvkqQ2G0iSXIvv0aLt5J+3oUqNXurfbs4ZUW7YveiJNprW8BVRIaX0Hw+L/uqAGzt4kd5MPA7oDcBW1NadWODA/eOo9pxa2/6hB+uOcJSIQzCeXL4pA/DWEitYKU4htev8B/vy3t8nxZdD2Hctt6kc7zMgDsQpAtwlJN3I0JA/IYmC+ed5IB0eNXXgJTlXgybiEw+bSMw5Eywm1kSI7xUxka3ON1bBBRBLZSXF44l+c1+IAK1fL8JgswuSnN4ramCMDCDE189XpF2atd1VYjwMFrrE8D96cHBCYAU5wApLQYfj7oRXqcTkT3l+pScmR9njpsAfhRIkUMiYiVuGEkfR8IH8AmWEnM2udMbUcfPuzzhhoPmT8g/djnHEaA+y4Bt9jCz9Loj35dCxrJDTUVqfuCAVgJX9ZPV6tmLTUa0KK5oAmkRIi8eyDvPAK8Q7RG1YpVX0PnuUed465S5ucRXt97tZXmCFBIzh9ajPZVLWe9PFCmVWBqsNWuRvEQ+ohow4i8KuJDevf/jWr4rvDKHDAauLlB2oF4ry8JSC/abgFLEi9ACcQB0u/ov4kenINZwjF63IQ7LdJYoeQf7c73qoC9cesH3KDlFqz/0p47LRDhLlDnjg/N+dy4xnWwC1o5JEcMOSo0YNG1iPcJ0dDF87SYraWDFHCVFSDEiiDCiEyGZcE+8m+TpwQi8FRo1gf4PuRFwQDv0B6Z7lBQ+P3AanJ5QN1/v14umUJ48hUg3NuVBjiOQ0sAYt35f08DA0Zu+R3Nd3sAGosY
 J//9inF7
 921W7L9c8CZWM/aq0KXDhF4U4hbS5KU//srMRBHvUzmxhbjkDl9xi0o568jv1rD1KSk/V5dTOUsoBzy/S7etupERVuwGc15nkraiiSmdHTuQOLTJVSZK8KOwEVrxbcz75x0QNsw7Nw2xEkP+CIMAEt1jA6YWn4N2V/x9K15jwhGb33dxgrAFdd2a3UKNPoK75H/eN3Dmb73pqohPgCDpBEqgbKKQ/6yGLn+lVkCkBkHYWA83AXIoSY6KfeugVh2Ujfw9JsxDQ+RRXVfZz5CVsndLxL7yfHfeMBVxi9rnXOwZsuyGplbxGp6eCuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

when want to change the kfence pool size, currently it is not easy and
need to compile kernel.

Add an early boot parameter kfence.num_objects to allow change kfence
objects number and allow increate total pool to provide high failure
rate.

Signed-off-by: yuan linyu <yuanlinyu@honor.com>
---
 include/linux/kfence.h  |   5 +-
 mm/kfence/core.c        | 122 +++++++++++++++++++++++++++++-----------
 mm/kfence/kfence.h      |   4 +-
 mm/kfence/kfence_test.c |   2 +-
 4 files changed, 96 insertions(+), 37 deletions(-)

diff --git a/include/linux/kfence.h b/include/linux/kfence.h
index 0ad1ddbb8b99..920bcd5649fa 100644
--- a/include/linux/kfence.h
+++ b/include/linux/kfence.h
@@ -24,7 +24,10 @@ extern unsigned long kfence_sample_interval;
  * address to metadata indices; effectively, the very first page serves as an
  * extended guard page, but otherwise has no special purpose.
  */
-#define KFENCE_POOL_SIZE ((CONFIG_KFENCE_NUM_OBJECTS + 1) * 2 * PAGE_SIZE)
+extern unsigned int __kfence_pool_size;
+#define KFENCE_POOL_SIZE (__kfence_pool_size)
+extern unsigned int __kfence_num_objects;
+#define KFENCE_NUM_OBJECTS (__kfence_num_objects)
 extern char *__kfence_pool;
 
 DECLARE_STATIC_KEY_FALSE(kfence_allocation_key);
diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 24c6f1fa5b19..82425da5f27c 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -132,6 +132,31 @@ struct kfence_metadata *kfence_metadata __read_mostly;
  */
 static struct kfence_metadata *kfence_metadata_init __read_mostly;
 
+/* allow change number of objects from cmdline */
+#define KFENCE_MIN_NUM_OBJECTS 1
+#define KFENCE_MAX_NUM_OBJECTS 65535
+unsigned int __kfence_num_objects __read_mostly = CONFIG_KFENCE_NUM_OBJECTS;
+EXPORT_SYMBOL(__kfence_num_objects); /* Export for test modules. */
+static unsigned int __kfence_pool_pages __read_mostly = (CONFIG_KFENCE_NUM_OBJECTS + 1) * 2;
+unsigned int __kfence_pool_size __read_mostly = (CONFIG_KFENCE_NUM_OBJECTS + 1) * 2 * PAGE_SIZE;
+EXPORT_SYMBOL(__kfence_pool_size); /* Export for lkdtm module. */
+
+static int __init early_parse_kfence_num_objects(char *buf)
+{
+	unsigned int num;
+	int ret = kstrtouint(buf, 10, &num);
+
+	if (ret < 0)
+		return ret;
+
+	__kfence_num_objects = clamp(num, KFENCE_MIN_NUM_OBJECTS, KFENCE_MAX_NUM_OBJECTS);
+	__kfence_pool_pages = (__kfence_num_objects + 1) * 2;
+	__kfence_pool_size = __kfence_pool_pages * PAGE_SIZE;
+
+	return 0;
+}
+early_param("kfence.num_objects", early_parse_kfence_num_objects);
+
 /* Freelist with available objects. */
 static struct list_head kfence_freelist = LIST_HEAD_INIT(kfence_freelist);
 static DEFINE_RAW_SPINLOCK(kfence_freelist_lock); /* Lock protecting freelist. */
@@ -155,12 +180,13 @@ atomic_t kfence_allocation_gate = ATOMIC_INIT(1);
  *
  *	P(alloc_traces) = (1 - e^(-HNUM * (alloc_traces / SIZE)) ^ HNUM
  */
+static unsigned int kfence_alloc_covered_order __read_mostly;
+static unsigned int kfence_alloc_covered_mask __read_mostly;
+static atomic_t *alloc_covered __read_mostly;
 #define ALLOC_COVERED_HNUM	2
-#define ALLOC_COVERED_ORDER	(const_ilog2(CONFIG_KFENCE_NUM_OBJECTS) + 2)
-#define ALLOC_COVERED_SIZE	(1 << ALLOC_COVERED_ORDER)
-#define ALLOC_COVERED_HNEXT(h)	hash_32(h, ALLOC_COVERED_ORDER)
-#define ALLOC_COVERED_MASK	(ALLOC_COVERED_SIZE - 1)
-static atomic_t alloc_covered[ALLOC_COVERED_SIZE];
+#define ALLOC_COVERED_HNEXT(h)	hash_32(h, kfence_alloc_covered_order)
+#define ALLOC_COVERED_MASK		(kfence_alloc_covered_mask)
+#define KFENCE_COVERED_SIZE		(sizeof(atomic_t) * (1 << kfence_alloc_covered_order))
 
 /* Stack depth used to determine uniqueness of an allocation. */
 #define UNIQUE_ALLOC_STACK_DEPTH ((size_t)8)
@@ -200,7 +226,7 @@ static_assert(ARRAY_SIZE(counter_names) == KFENCE_COUNTER_COUNT);
 
 static inline bool should_skip_covered(void)
 {
-	unsigned long thresh = (CONFIG_KFENCE_NUM_OBJECTS * kfence_skip_covered_thresh) / 100;
+	unsigned long thresh = (__kfence_num_objects * kfence_skip_covered_thresh) / 100;
 
 	return atomic_long_read(&counters[KFENCE_COUNTER_ALLOCATED]) > thresh;
 }
@@ -262,7 +288,7 @@ static inline unsigned long metadata_to_pageaddr(const struct kfence_metadata *m
 
 	/* Only call with a pointer into kfence_metadata. */
 	if (KFENCE_WARN_ON(meta < kfence_metadata ||
-			   meta >= kfence_metadata + CONFIG_KFENCE_NUM_OBJECTS))
+			   meta >= kfence_metadata + __kfence_num_objects))
 		return 0;
 
 	/*
@@ -612,7 +638,7 @@ static unsigned long kfence_init_pool(void)
 	 * fast-path in SLUB, and therefore need to ensure kfree() correctly
 	 * enters __slab_free() slow-path.
 	 */
-	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
+	for (i = 0; i < __kfence_pool_pages; i++) {
 		struct page *page;
 
 		if (!i || (i % 2))
@@ -640,7 +666,7 @@ static unsigned long kfence_init_pool(void)
 		addr += PAGE_SIZE;
 	}
 
-	for (i = 0; i < CONFIG_KFENCE_NUM_OBJECTS; i++) {
+	for (i = 0; i < __kfence_num_objects; i++) {
 		struct kfence_metadata *meta = &kfence_metadata_init[i];
 
 		/* Initialize metadata. */
@@ -666,7 +692,7 @@ static unsigned long kfence_init_pool(void)
 	return 0;
 
 reset_slab:
-	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
+	for (i = 0; i < __kfence_pool_pages; i++) {
 		struct page *page;
 
 		if (!i || (i % 2))
@@ -710,7 +736,7 @@ static bool __init kfence_init_pool_early(void)
 	 * fails for the first page, and therefore expect addr==__kfence_pool in
 	 * most failure cases.
 	 */
-	memblock_free_late(__pa(addr), KFENCE_POOL_SIZE - (addr - (unsigned long)__kfence_pool));
+	memblock_free_late(__pa(addr), __kfence_pool_size - (addr - (unsigned long)__kfence_pool));
 	__kfence_pool = NULL;
 
 	memblock_free_late(__pa(kfence_metadata_init), KFENCE_METADATA_SIZE);
@@ -740,7 +766,7 @@ DEFINE_SHOW_ATTRIBUTE(stats);
  */
 static void *start_object(struct seq_file *seq, loff_t *pos)
 {
-	if (*pos < CONFIG_KFENCE_NUM_OBJECTS)
+	if (*pos < __kfence_num_objects)
 		return (void *)((long)*pos + 1);
 	return NULL;
 }
@@ -752,7 +778,7 @@ static void stop_object(struct seq_file *seq, void *v)
 static void *next_object(struct seq_file *seq, void *v, loff_t *pos)
 {
 	++*pos;
-	if (*pos < CONFIG_KFENCE_NUM_OBJECTS)
+	if (*pos < __kfence_num_objects)
 		return (void *)((long)*pos + 1);
 	return NULL;
 }
@@ -796,7 +822,7 @@ static void kfence_check_all_canary(void)
 {
 	int i;
 
-	for (i = 0; i < CONFIG_KFENCE_NUM_OBJECTS; i++) {
+	for (i = 0; i < __kfence_num_objects; i++) {
 		struct kfence_metadata *meta = &kfence_metadata[i];
 
 		if (kfence_obj_allocated(meta))
@@ -891,7 +917,7 @@ void __init kfence_alloc_pool_and_metadata(void)
 	 * re-allocate the memory pool.
 	 */
 	if (!__kfence_pool)
-		__kfence_pool = memblock_alloc(KFENCE_POOL_SIZE, PAGE_SIZE);
+		__kfence_pool = memblock_alloc(__kfence_pool_size, PAGE_SIZE);
 
 	if (!__kfence_pool) {
 		pr_err("failed to allocate pool\n");
@@ -900,11 +926,23 @@ void __init kfence_alloc_pool_and_metadata(void)
 
 	/* The memory allocated by memblock has been zeroed out. */
 	kfence_metadata_init = memblock_alloc(KFENCE_METADATA_SIZE, PAGE_SIZE);
-	if (!kfence_metadata_init) {
-		pr_err("failed to allocate metadata\n");
-		memblock_free(__kfence_pool, KFENCE_POOL_SIZE);
-		__kfence_pool = NULL;
-	}
+	if (!kfence_metadata_init)
+		goto fail_pool;
+
+	kfence_alloc_covered_order = ilog2(__kfence_num_objects) + 2;
+	kfence_alloc_covered_mask = (1 << kfence_alloc_covered_order) - 1;
+	alloc_covered = memblock_alloc(KFENCE_COVERED_SIZE, PAGE_SIZE);
+	if (alloc_covered)
+		return;
+
+	pr_err("failed to allocate covered\n");
+	memblock_free(kfence_metadata_init, KFENCE_METADATA_SIZE);
+	kfence_metadata_init = NULL;
+
+fail_pool:
+	pr_err("failed to allocate metadata\n");
+	memblock_free(__kfence_pool, __kfence_pool_size);
+	__kfence_pool = NULL;
 }
 
 static void kfence_init_enable(void)
@@ -927,9 +965,9 @@ static void kfence_init_enable(void)
 	WRITE_ONCE(kfence_enabled, true);
 	queue_delayed_work(system_unbound_wq, &kfence_timer, 0);
 
-	pr_info("initialized - using %lu bytes for %d objects at 0x%p-0x%p\n", KFENCE_POOL_SIZE,
-		CONFIG_KFENCE_NUM_OBJECTS, (void *)__kfence_pool,
-		(void *)(__kfence_pool + KFENCE_POOL_SIZE));
+	pr_info("initialized - using %u bytes for %d objects at 0x%p-0x%p\n", __kfence_pool_size,
+		__kfence_num_objects, (void *)__kfence_pool,
+		(void *)(__kfence_pool + __kfence_pool_size));
 }
 
 void __init kfence_init(void)
@@ -950,41 +988,53 @@ void __init kfence_init(void)
 
 static int kfence_init_late(void)
 {
-	const unsigned long nr_pages_pool = KFENCE_POOL_SIZE / PAGE_SIZE;
-	const unsigned long nr_pages_meta = KFENCE_METADATA_SIZE / PAGE_SIZE;
+	unsigned long nr_pages_meta = KFENCE_METADATA_SIZE / PAGE_SIZE;
 	unsigned long addr = (unsigned long)__kfence_pool;
-	unsigned long free_size = KFENCE_POOL_SIZE;
+	unsigned long free_size = __kfence_pool_size;
+	unsigned long nr_pages_covered, covered_size;
 	int err = -ENOMEM;
 
+	kfence_alloc_covered_order = ilog2(__kfence_num_objects) + 2;
+	kfence_alloc_covered_mask = (1 << kfence_alloc_covered_order) - 1;
+	covered_size =  PAGE_ALIGN(KFENCE_COVERED_SIZE);
+	nr_pages_covered = (covered_size / PAGE_SIZE);
 #ifdef CONFIG_CONTIG_ALLOC
 	struct page *pages;
 
-	pages = alloc_contig_pages(nr_pages_pool, GFP_KERNEL, first_online_node,
+	pages = alloc_contig_pages(__kfence_pool_pages, GFP_KERNEL, first_online_node,
 				   NULL);
 	if (!pages)
 		return -ENOMEM;
 
 	__kfence_pool = page_to_virt(pages);
+	pages = alloc_contig_pages(nr_pages_covered, GFP_KERNEL, first_online_node,
+				   NULL);
+	if (!pages)
+		goto free_pool;
+	alloc_covered = page_to_virt(pages);
 	pages = alloc_contig_pages(nr_pages_meta, GFP_KERNEL, first_online_node,
 				   NULL);
 	if (pages)
 		kfence_metadata_init = page_to_virt(pages);
 #else
-	if (nr_pages_pool > MAX_ORDER_NR_PAGES ||
+	if (__kfence_pool_pages > MAX_ORDER_NR_PAGES ||
 	    nr_pages_meta > MAX_ORDER_NR_PAGES) {
 		pr_warn("KFENCE_NUM_OBJECTS too large for buddy allocator\n");
 		return -EINVAL;
 	}
 
-	__kfence_pool = alloc_pages_exact(KFENCE_POOL_SIZE, GFP_KERNEL);
+	__kfence_pool = alloc_pages_exact(__kfence_pool_size, GFP_KERNEL);
 	if (!__kfence_pool)
 		return -ENOMEM;
 
+	alloc_covered = alloc_pages_exact(covered_size, GFP_KERNEL);
+	if (!alloc_covered)
+		goto free_pool;
 	kfence_metadata_init = alloc_pages_exact(KFENCE_METADATA_SIZE, GFP_KERNEL);
 #endif
 
 	if (!kfence_metadata_init)
-		goto free_pool;
+		goto free_cover;
 
 	memzero_explicit(kfence_metadata_init, KFENCE_METADATA_SIZE);
 	addr = kfence_init_pool();
@@ -995,22 +1045,28 @@ static int kfence_init_late(void)
 	}
 
 	pr_err("%s failed\n", __func__);
-	free_size = KFENCE_POOL_SIZE - (addr - (unsigned long)__kfence_pool);
+	free_size = __kfence_pool_size - (addr - (unsigned long)__kfence_pool);
 	err = -EBUSY;
 
 #ifdef CONFIG_CONTIG_ALLOC
 	free_contig_range(page_to_pfn(virt_to_page((void *)kfence_metadata_init)),
 			  nr_pages_meta);
+free_cover:
+	free_contig_range(page_to_pfn(virt_to_page((void *)alloc_covered)),
+			  nr_pages_covered);
 free_pool:
 	free_contig_range(page_to_pfn(virt_to_page((void *)addr)),
 			  free_size / PAGE_SIZE);
 #else
 	free_pages_exact((void *)kfence_metadata_init, KFENCE_METADATA_SIZE);
+free_cover:
+	free_pages_exact((void *)alloc_covered, covered_size);
 free_pool:
 	free_pages_exact((void *)addr, free_size);
 #endif
 
 	kfence_metadata_init = NULL;
+	alloc_covered = NULL;
 	__kfence_pool = NULL;
 	return err;
 }
@@ -1036,7 +1092,7 @@ void kfence_shutdown_cache(struct kmem_cache *s)
 	if (!smp_load_acquire(&kfence_metadata))
 		return;
 
-	for (i = 0; i < CONFIG_KFENCE_NUM_OBJECTS; i++) {
+	for (i = 0; i < __kfence_num_objects; i++) {
 		bool in_use;
 
 		meta = &kfence_metadata[i];
@@ -1074,7 +1130,7 @@ void kfence_shutdown_cache(struct kmem_cache *s)
 		}
 	}
 
-	for (i = 0; i < CONFIG_KFENCE_NUM_OBJECTS; i++) {
+	for (i = 0; i < __kfence_num_objects; i++) {
 		meta = &kfence_metadata[i];
 
 		/* See above. */
diff --git a/mm/kfence/kfence.h b/mm/kfence/kfence.h
index dfba5ea06b01..dc3abb27c632 100644
--- a/mm/kfence/kfence.h
+++ b/mm/kfence/kfence.h
@@ -104,7 +104,7 @@ struct kfence_metadata {
 };
 
 #define KFENCE_METADATA_SIZE PAGE_ALIGN(sizeof(struct kfence_metadata) * \
-					CONFIG_KFENCE_NUM_OBJECTS)
+					__kfence_num_objects)
 
 extern struct kfence_metadata *kfence_metadata;
 
@@ -123,7 +123,7 @@ static inline struct kfence_metadata *addr_to_metadata(unsigned long addr)
 	 * error.
 	 */
 	index = (addr - (unsigned long)__kfence_pool) / (PAGE_SIZE * 2) - 1;
-	if (index < 0 || index >= CONFIG_KFENCE_NUM_OBJECTS)
+	if (index < 0 || index >= __kfence_num_objects)
 		return NULL;
 
 	return &kfence_metadata[index];
diff --git a/mm/kfence/kfence_test.c b/mm/kfence/kfence_test.c
index 00034e37bc9f..00a51aa4bad9 100644
--- a/mm/kfence/kfence_test.c
+++ b/mm/kfence/kfence_test.c
@@ -641,7 +641,7 @@ static void test_gfpzero(struct kunit *test)
 			break;
 		test_free(buf2);
 
-		if (kthread_should_stop() || (i == CONFIG_KFENCE_NUM_OBJECTS)) {
+		if (kthread_should_stop() || (i == __kfence_num_objects)) {
 			kunit_warn(test, "giving up ... cannot get same object back\n");
 			return;
 		}
-- 
2.25.1


