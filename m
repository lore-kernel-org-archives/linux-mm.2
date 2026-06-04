Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA8DECD6E55
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 03:42:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF06E6B0093; Wed,  3 Jun 2026 23:42:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA17C6B0095; Wed,  3 Jun 2026 23:42:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B7036B0098; Wed,  3 Jun 2026 23:42:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8DCC46B0093
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 23:42:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C5B6F1A01A5
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 03:42:02 +0000 (UTC)
X-FDA: 84840831684.22.3CA19A2
Received: from mail-m2464.xmail.ntesmail.com (mail-m2464.xmail.ntesmail.com [45.195.24.64])
	by imf31.hostedemail.com (Postfix) with ESMTP id A2AAE20002
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 03:41:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of zhen.ni@easystack.cn designates 45.195.24.64 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780544521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=rLMb6npMQMKrDnA3d3ShqxNnz/3TlTnlFImRfLhTF04=;
	b=itfJDOb8BFRumWHQE9f0353zK8qdSn3PPO8Y36U+GZ81Y91XBmPbpd/Vis+0O4MUAd4p0G
	f2afTPNfDFUoqVl+Zzi3sZmgNxD34fVev1BpsQb/H782dLjjt1Pwxa+Crq7MN9ucQxLhFw
	2nB5z/V3dJSik7pmJwiD76en7jyOMwc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780544521;
	b=wGFK8JNA61yTSK3zNmpOgLO4jOYV9bfqz5MjJWcgRdDEbKAZ3TYCl56nb9tp3n1gwckp93
	jRB0uHkO5svBTNB3XeGCgdCsy5KtATmHehovQsIrU+G8QlhOyzMuJgkX5hX/9jG6KeLyAZ
	YeDGHxLCswQlVig43xCj0+nQ0jMZxvE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of zhen.ni@easystack.cn designates 45.195.24.64 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1afc83ec1;
	Thu, 4 Jun 2026 11:41:52 +0800 (GMT+08:00)
From: Zhen Ni <zhen.ni@easystack.cn>
To: Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Cc: linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-mm@kvack.org,
	Zhen Ni <zhen.ni@easystack.cn>
Subject: [PATCH] mm/memblock: Introduce memblock_alloc_node_or_panic() helper
Date: Thu,  4 Jun 2026 11:41:39 +0800
Message-Id: <20260604034139.2827148-1-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e90b9218b0229kunm3abe23872c1e40
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCH08eVkwdTU8YQ01MQkpNHlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lCQ0NMVUpLS1VLWQY+
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A2AAE20002
X-Stat-Signature: 7xded6qqz969icztmgsoi4urrxhi8j5k
X-HE-Tag: 1780544519-808032
X-HE-Meta: U2FsdGVkX187eYfmgXs/kXnN5BoTYUqAQ6SD1d98rJ96PQ66QEbHiiBkB2jkTY1iNw92RxYCOaClNAdFc9nEkqei1VCq0SX5JLXny9VktDp2/9x1vIykYxz+M9uSUHuHikZO/YgZq8Hv9CwcpOz79O4y+JPcFaOXOMq95JJaXQXi0ZUGwbDT2fC7wLexDbyMXRgB2pRYAwM7cBjc5IwJpZdYMjshOaFikg8v30DvZv619wdgq5uD+bdrHz5WcDmknvk6aJIukckfzIMbKc/YCT56cN+Pjs9vYiW4Cae2qyyKMI/EqXgVzsxGcycpjC8u3pDrB5IXZdEI0S32Qpols/UAdQWGYMfX7W/K6QV+FFDcNctqouJNMwDF8bkoTZ0aNxxnyFBejCQjwXvlwjkqZ4PeDsWqARDPcr62c3MYtpkoISDbGjOnw482htm96DeiTNuvgaUelhTACF3Dky33eC2CmrwGVoAX23y48z76lDLdbEGkq4WVZaaSA5e8OdEr67UU/V3K7qTZL3i8VtINSdZ6Hatg6NDf0xsaWT+0bRSen1HVXLTR3L4lyC9sPRdEwPn7Og5290aKKQwM8m46MF69T62MrTzeduCgL9z7vGOqMmxHrg4NUFW1SJN9I5wbliHEGOnf5BYe3u0b5XhVn3GMJXoIcr64Azhbh1KTgstvMpYoQLkyEH9dadks07r2Qc0+bFKZqJadOBBVXSJM/jFGrQwqJZvC0WxAZZTc2ILs0aSCMcQvxV/bx5tKuFKb/5kTDeuu+dNhcotw9fCLZ8MpiByytL4ajEzNA6AwB1962M1wJtqMLEc0Rg5nbd+7kRo0KsXTMkinHi53GPW9uxgPsjUWZLiqrY6NKvmkoFPrVCvjiCdZ2ChevqKIfeYRpdC/RDdMB36+TC1haFQAhnh1Dn3ZMaz3iGLayL3lFYZYsC6Vv7n9a1AKXgxIZep00LEAOGCrt3VGrOCRpL0
 gqh2+1iP
 WrNUL8yvIip8VLz9yUgru1EDMI+OWQqgq/1TK3wpY62C/1oFlHLsmEN798qZbMx+6BH2GzL9MHKeZShtE9A3y3YR7u0VuK5jTz1q6XUEpJdp57ov7MN49vYZOP36R3RhbzU3PFCCaEG7qvdM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During early boot, several subsystems allocate memory from specific
NUMA nodes using memblock_alloc_node(). When allocation fails, the
typical requirement is to panic immediately.

Introduce memblock_alloc_node_or_panic() to automatically panic on
allocation failure. This reduces repetitive error checking, improves code
consistency across subsystems, and enhances code readability.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
 arch/sh/mm/numa.c            | 10 ++++------
 arch/sparc/kernel/setup_64.c | 16 ++++++----------
 arch/x86/coco/sev/core.c     |  5 ++---
 include/linux/memblock.h     |  6 ++++++
 mm/memblock.c                | 22 ++++++++++++++++++++++
 mm/mm_init.c                 | 11 ++++-------
 mm/sparse.c                  | 13 +++++--------
 7 files changed, 49 insertions(+), 34 deletions(-)

diff --git a/arch/sh/mm/numa.c b/arch/sh/mm/numa.c
index 9bc212b5e762..32b01697b27f 100644
--- a/arch/sh/mm/numa.c
+++ b/arch/sh/mm/numa.c
@@ -38,12 +38,10 @@ void __init setup_bootmem_node(int nid, unsigned long start, unsigned long end)
 	__add_active_range(nid, start_pfn, end_pfn);
 
 	/* Node-local pgdat */
-	NODE_DATA(nid) = memblock_alloc_node(sizeof(struct pglist_data),
-					     SMP_CACHE_BYTES, nid);
-	if (!NODE_DATA(nid))
-		panic("%s: Failed to allocate %zu bytes align=0x%x nid=%d\n",
-		      __func__, sizeof(struct pglist_data), SMP_CACHE_BYTES,
-		      nid);
+	NODE_DATA(nid) = memblock_alloc_node_or_panic(
+				sizeof(struct pglist_data),
+				SMP_CACHE_BYTES,
+				nid);
 
 	NODE_DATA(nid)->node_start_pfn = start_pfn;
 	NODE_DATA(nid)->node_spanned_pages = end_pfn - start_pfn;
diff --git a/arch/sparc/kernel/setup_64.c b/arch/sparc/kernel/setup_64.c
index 63615f5c99b4..57e3a45f4750 100644
--- a/arch/sparc/kernel/setup_64.c
+++ b/arch/sparc/kernel/setup_64.c
@@ -606,16 +606,12 @@ static void __init alloc_irqstack_bootmem(void)
 	for_each_possible_cpu(i) {
 		node = cpu_to_node(i);
 
-		softirq_stack[i] = memblock_alloc_node(THREAD_SIZE,
-						       THREAD_SIZE, node);
-		if (!softirq_stack[i])
-			panic("%s: Failed to allocate %lu bytes align=%lx nid=%d\n",
-			      __func__, THREAD_SIZE, THREAD_SIZE, node);
-		hardirq_stack[i] = memblock_alloc_node(THREAD_SIZE,
-						       THREAD_SIZE, node);
-		if (!hardirq_stack[i])
-			panic("%s: Failed to allocate %lu bytes align=%lx nid=%d\n",
-			      __func__, THREAD_SIZE, THREAD_SIZE, node);
+		softirq_stack[i] = memblock_alloc_node_or_panic(THREAD_SIZE,
+								THREAD_SIZE,
+								node);
+		hardirq_stack[i] = memblock_alloc_node_or_panic(THREAD_SIZE,
+								THREAD_SIZE,
+								node);
 	}
 }
 
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 7ed3da998489..0191835dd5de 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1191,9 +1191,8 @@ static void __init alloc_runtime_data(int cpu)
 {
 	struct sev_es_runtime_data *data;
 
-	data = memblock_alloc_node(sizeof(*data), PAGE_SIZE, cpu_to_node(cpu));
-	if (!data)
-		panic("Can't allocate SEV-ES runtime data");
+	data = memblock_alloc_node_or_panic(sizeof(*data), PAGE_SIZE,
+					    cpu_to_node(cpu));
 
 	per_cpu(runtime_data, cpu) = data;
 
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index b0f750d22a7b..9b22d7fc0dc7 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -433,6 +433,12 @@ void *__memblock_alloc_or_panic(phys_addr_t size, phys_addr_t align,
 #define memblock_alloc_or_panic(size, align)    \
 	 __memblock_alloc_or_panic(size, align, __func__)
 
+void *__memblock_alloc_node_or_panic(phys_addr_t size, phys_addr_t align,
+				     int nid, const char *func);
+
+#define memblock_alloc_node_or_panic(size, align, nid)    \
+	 __memblock_alloc_node_or_panic(size, align, nid, __func__)
+
 static inline void *memblock_alloc_raw(phys_addr_t size,
 					       phys_addr_t align)
 {
diff --git a/mm/memblock.c b/mm/memblock.c
index ccd43f3abb82..2e97cd6d21a1 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1845,6 +1845,28 @@ void *__init __memblock_alloc_or_panic(phys_addr_t size, phys_addr_t align,
 	return addr;
 }
 
+/**
+ * __memblock_alloc_node_or_panic - Try to allocate memory on a node and panic on failure
+ * @size: size of memory block to be allocated in bytes
+ * @align: alignment of the region and block's size
+ * @nid: nid of the free area to find, %NUMA_NO_NODE for any node
+ * @func: caller func name
+ *
+ * This function attempts to allocate memory on a specific node using memblock_alloc_node,
+ * and in case of failure, it calls panic with the formatted message.
+ * This function should not be used directly, please use the macro memblock_alloc_node_or_panic.
+ */
+void *__init __memblock_alloc_node_or_panic(phys_addr_t size, phys_addr_t align,
+					     int nid, const char *func)
+{
+	void *addr = memblock_alloc_node(size, align, nid);
+
+	if (unlikely(!addr))
+		panic("%s: Failed to allocate %pap bytes on node %d\n",
+		      func, &size, nid);
+	return addr;
+}
+
 /*
  * Remaining API functions
  */
diff --git a/mm/mm_init.c b/mm/mm_init.c
index f9f8e1af921c..7c69056c1a8c 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1477,14 +1477,11 @@ static void __ref setup_usemap(struct zone *zone)
 	unsigned long usemapsize = usemap_size(zone->zone_start_pfn,
 					       zone->spanned_pages);
 	zone->pageblock_flags = NULL;
-	if (usemapsize) {
+	if (usemapsize)
 		zone->pageblock_flags =
-			memblock_alloc_node(usemapsize, SMP_CACHE_BYTES,
-					    zone_to_nid(zone));
-		if (!zone->pageblock_flags)
-			panic("Failed to allocate %ld bytes for zone %s pageblock flags on node %d\n",
-			      usemapsize, zone->name, zone_to_nid(zone));
-	}
+			memblock_alloc_node_or_panic(usemapsize,
+						     SMP_CACHE_BYTES,
+						     zone_to_nid(zone));
 }
 #else
 static inline void setup_usemap(struct zone *zone) {}
diff --git a/mm/sparse.c b/mm/sparse.c
index effdac6b0ab1..c7c80783b6be 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -66,15 +66,12 @@ static noinline struct mem_section __ref *sparse_index_alloc(int nid)
 	unsigned long array_size = SECTIONS_PER_ROOT *
 				   sizeof(struct mem_section);
 
-	if (slab_is_available()) {
+	if (slab_is_available())
 		section = kzalloc_node(array_size, GFP_KERNEL, nid);
-	} else {
-		section = memblock_alloc_node(array_size, SMP_CACHE_BYTES,
-					      nid);
-		if (!section)
-			panic("%s: Failed to allocate %lu bytes nid=%d\n",
-			      __func__, array_size, nid);
-	}
+	else
+		section = memblock_alloc_node_or_panic(array_size,
+						       SMP_CACHE_BYTES,
+						       nid);
 
 	return section;
 }
-- 
2.20.1


