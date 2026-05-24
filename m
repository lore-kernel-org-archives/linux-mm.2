Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF2FCCD5BAB
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 03:40:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E88A26B0092; Sat, 23 May 2026 23:40:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E120E6B0095; Sat, 23 May 2026 23:40:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD98D6B0096; Sat, 23 May 2026 23:40:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B38F76B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 23:40:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EF6F4140C3E
	for <linux-mm@kvack.org>; Sun, 24 May 2026 03:40:40 +0000 (UTC)
X-FDA: 84800911440.06.9DBD9C1
Received: from outbound.baidu.com (mx16.baidu.com [111.202.115.101])
	by imf15.hostedemail.com (Postfix) with SMTP id 1EFEDA0002
	for <linux-mm@kvack.org>; Sun, 24 May 2026 03:40:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=Xmtuwj6p;
	dmarc=pass (policy=quarantine) header.from=baidu.com;
	spf=pass (imf15.hostedemail.com: domain of "prvs=md1598909048=lirongqing@baidu.com" designates 111.202.115.101 as permitted sender) smtp.mailfrom="prvs=md1598909048=lirongqing@baidu.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779594039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=auEp3spqgbRyV4sCde7hRJzHFuKPJdXALEUCtoAvLcE=;
	b=TUHTl1+8v3VaRlyAzSjjuBNLmKgFWIdlE5IDA+onsJinJ+WqQ3x7HfWG+9nqAlUSEJid1k
	w3E3YM3ttlPuX7mtDUeW9oFL57FkAbrFveWkvH0aYyiX2k4dCES9LnEefBi8WXN1/n9da1
	WfZtWtA1cnIl/Rg4tCRiqEt60KnUN40=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=Xmtuwj6p;
	dmarc=pass (policy=quarantine) header.from=baidu.com;
	spf=pass (imf15.hostedemail.com: domain of "prvs=md1598909048=lirongqing@baidu.com" designates 111.202.115.101 as permitted sender) smtp.mailfrom="prvs=md1598909048=lirongqing@baidu.com"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779594039; a=rsa-sha256;
	cv=none;
	b=tDTI+ZI7wf0lmCzomiHsyJGr4cE7G9Ato3PeaIFqg0Zy6NYv9qJdyMZ8XqhNfMScOIV9Qk
	Z3NFJEFemc35QcT/WOjheatD3aCEM/ZVGl9mC49KRH3J9DHAB2UtJwkHjb7LmP2EKyOlAE
	FmO1meASbp1z2YUfp0DS8wOpX6Br9qw=
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
	<liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<corbet@lwn.net>, <skhan@linuxfoundation.org>, <linux-doc@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] mm/dmapool: use static key for boot-time debug enablement
Date: Sat, 23 May 2026 23:40:15 -0400
Message-ID: <20260524034015.1830-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: bjkjy-exc5.internal.baidu.com (172.31.50.49) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1779594033;
	bh=auEp3spqgbRyV4sCde7hRJzHFuKPJdXALEUCtoAvLcE=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=Xmtuwj6pi1tfGjnfP1Z7Ix7osoUCPHg6Y3BaFOZBEseWajvomc/zk+vd+k7nnHDAB
	 HTwnzNOJyG0Wdh6y7xEs1pAryM9upwT3/H0iHiRX1bS9rVsbd+0sXsFXDI5ABsVJIM
	 aOYl0eqhLxVoUeIV1+OGIBciC57n/gfSYu0Lg2iHmp6erha0Z0tZ0dFg1yCz9ebost
	 yiWE2NxChpsiJLgHuQLwDNfZrZuE0+2vLLYLQ6mP8suFZ2Ts4Kx+v/u5ktcqulj2ox
	 Yl3tVUOQst/fW06uym4trCV0RM7SGB8Gv/pLHeAbFEcg5lZ3TvTdqe9crjh9S+/th4
	 us7LraKuo2Xiw==
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1EFEDA0002
X-Stat-Signature: m3sz1wnbafodc3emeqq5wic41t1ef7my
X-Rspam-User: 
X-HE-Tag: 1779594035-772319
X-HE-Meta: U2FsdGVkX1+XZEcfvydzYtntxGFtH6JVf1xIRZ5GFCER/dw9UN1H6pfvcqbNzXfh5uRfZV1V6Ivb+M/U8ySNTxa0tAMOhHfSnJ6A/JTBKdqkNVjcuOnT9gUKESUTaT+xj0idup+MLNDCQPD5lvmBxCdQbazSNfOa9SbG7Y79ICKF1ekjnR0q1RBBP2p64eo95foWAP3FC/1//ASOKHkqlb+cbDmY0bNjTT0xH88iZS5tibgN7kJK7HEYT8YAgmqROXL1/Zy4Wd1Qr9tgoN4htx3WAQCaXz80O3vvYaslSOPDSBGGdos00A7Oi+QjSIpzqJNTAfn0/0M+HM+LwZAatf2lZ2cn4M5ut7LZBXc6Xg8Vq3fvTCOrcAyUkbOsBuWQmVkewMFo5WGs7OW96T5VBdngrFsSVWpBOAvc9gzrGa/s/erEOTsIrRD8Ncnu3hREEanEXflvau8iFVKuoXXaoCiRpXm4Stlj2Gn+lQOTJp3M7XgqZz8WbOxbsEM3nfWHi7b9CCJhsrrWMLuqR5XM7RrZC09qKftv/ZkC9dn7St9bEvUoO2UpfB/CX2DOZ1X8leq+oL+DCbHRhfghqagP3fTYKa5QwOsf/c3O37h9xY7d4emGPBKdjOTEXVaQm/IpqCCBfowhaRTo5k+5A47a7jQdfVrZNHqTva1ruiHUpniuTQ4BSBI0yGP3TZyQI6V7QqHKeqFJXq2WpM51n+eRIUeHGmu0/b3NYLZLzSsyxIC/R3R2ii+mVDEpOHqviHEZ1j4pg1kCXiPzGEPPUXClket3UWmPQkgWAyRH3YgLDVkU82UW0+Vztea8mMaG+oox+/1FswJVO9VC8F31GPho3wtRQWaQyayVd0TPjUHehg9B/EryyII+SO8X4N93FF/liDUyxlUsqTZHItdajw+DSTRJAnkOoBrJICR92WWf9+U7EwGVjnTMo3Ik/l4sTlsQcnrdDiF1ctpxlh+hwZn
 MdzS1BPv
 F6ny6bc1O92VwcXgnwKG1zpEjT/WsVsBofQ92mMfjASdyMunXHjVwR0Iez7qz1BOtNjRflXL+8hu0VsG/c8jRPTabJdM6r8i8qJVC5gJTAj7gubO9niMrIDD6ySOSdgRMnnNsCLQUVho3n/IF/fR7Jq1P2cEOSHP4DCfWEVzp6Vkqn3+mcU59upk/2M+e+B9WGULcxcmbcna/M6ZGy/NSxUI/sQmJyulNSd1mOqqNzC6wG+/c9HFHYoGQBxCI5CaBNie/WsP7tT0epxjHPBPVb5FRrAPx51nA6Wa6wywb1+KQANVhtLs6NBUUB+soWszT9LIhjFZnhU9aJXuL5Ap8Tl0AKqQBCO2kN07LUCOfLL2Ap9x6rjVUaWW6g63TEGPl01FfbPdPLREybTOjSxem91dbnZrQ9J8/jKlfqRTAatSmudixGajzhfeiXbhici8ynOB8KY3fqWiUBF9Kd2HmlqUofwCDhOFcBXONxOzwNn4Qpuf9O4Eqqn8gyNVxfI0wPXhC1ldFZcaSgbF4s9IgmaJtlCYPGITPAvnnKM3Fopw7H/7mcHKv0nSI/BB6PSb0wzba
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li RongQing <lirongqing@baidu.com>

Replace the #ifdef CONFIG_SLUB_DEBUG_ON conditional compilation with a
static key (dmapool_debug_enabled). This allows enabling dmapool debugging
at boot time via:

    dmapool_debug

Instead of requiring CONFIG_SLUB_DEBUG_ON at compile time. Benefits:

- Debugging can be enabled without rebuilding the kernel
- Uses standard kernel static_key mechanism with minimal overhead

Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
---
 Documentation/admin-guide/kernel-parameters.txt |  5 +++
 mm/dmapool.c                                    | 52 ++++++++++++++-----------
 2 files changed, 34 insertions(+), 23 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 4d0f545..35ed9dc 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1333,6 +1333,11 @@ Kernel parameters
 
 	dis_ucode_ldr	[X86] Disable the microcode loader.
 
+	dmapool_debug	[MM]
+			Enable DMA pool debugging. This enables memory
+			poisoning and validation for DMA pool allocations.
+			Useful for debugging DMA API misuse.
+
 	dma_debug=off	If the kernel is compiled with DMA_API_DEBUG support,
 			this option disables the debugging code at boot.
 
diff --git a/mm/dmapool.c b/mm/dmapool.c
index 5d8af6e..d26f19c 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -35,10 +35,23 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/wait.h>
+#include <linux/static_key.h>
+#include <linux/init.h>
 
-#ifdef CONFIG_SLUB_DEBUG_ON
-#define DMAPOOL_DEBUG 1
-#endif
+/*
+ * Debugging support for dmapool using static key.
+ *
+ * This allows enabling dmapool debug at boot time via:
+ *   dmapool_debug
+ */
+static DEFINE_STATIC_KEY_FALSE(dmapool_debug_enabled);
+
+static int __init dmapool_debug_setup(char *str)
+{
+	static_branch_enable(&dmapool_debug_enabled);
+	return 1;
+}
+__setup("dmapool_debug", dmapool_debug_setup);
 
 struct dma_block {
 	struct dma_block *next_block;
@@ -92,13 +105,15 @@ static ssize_t pools_show(struct device *dev, struct device_attribute *attr, cha
 
 static DEVICE_ATTR_RO(pools);
 
-#ifdef DMAPOOL_DEBUG
 static void pool_check_block(struct dma_pool *pool, struct dma_block *block,
 			     gfp_t mem_flags)
 {
 	u8 *data = (void *)block;
 	int i;
 
+	if (!static_branch_unlikely(&dmapool_debug_enabled))
+		return;
+
 	for (i = sizeof(struct dma_block); i < pool->size; i++) {
 		if (data[i] == POOL_POISON_FREED)
 			continue;
@@ -133,8 +148,14 @@ static struct dma_page *pool_find_page(struct dma_pool *pool, dma_addr_t dma)
 
 static bool pool_block_err(struct dma_pool *pool, void *vaddr, dma_addr_t dma)
 {
-	struct dma_block *block = pool->next_block;
 	struct dma_page *page;
+	struct dma_block *block;
+
+	if (!static_branch_unlikely(&dmapool_debug_enabled)) {
+		if (want_init_on_free())
+			memset(vaddr, 0, pool->size);
+		return false;
+	}
 
 	page = pool_find_page(pool, dma);
 	if (!page) {
@@ -143,6 +164,7 @@ static bool pool_block_err(struct dma_pool *pool, void *vaddr, dma_addr_t dma)
 		return true;
 	}
 
+	block = pool->next_block;
 	while (block) {
 		if (block != vaddr) {
 			block = block->next_block;
@@ -159,25 +181,9 @@ static bool pool_block_err(struct dma_pool *pool, void *vaddr, dma_addr_t dma)
 
 static void pool_init_page(struct dma_pool *pool, struct dma_page *page)
 {
-	memset(page->vaddr, POOL_POISON_FREED, pool->allocation);
-}
-#else
-static void pool_check_block(struct dma_pool *pool, struct dma_block *block,
-			     gfp_t mem_flags)
-{
-}
-
-static bool pool_block_err(struct dma_pool *pool, void *vaddr, dma_addr_t dma)
-{
-	if (want_init_on_free())
-		memset(vaddr, 0, pool->size);
-	return false;
-}
-
-static void pool_init_page(struct dma_pool *pool, struct dma_page *page)
-{
+	if (static_branch_unlikely(&dmapool_debug_enabled))
+		memset(page->vaddr, POOL_POISON_FREED, pool->allocation);
 }
-#endif
 
 static struct dma_block *pool_block_pop(struct dma_pool *pool)
 {
-- 
2.9.4


