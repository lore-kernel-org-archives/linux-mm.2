Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96668CD6E6B
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 11:03:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9AF86B008A; Thu,  4 Jun 2026 07:03:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4B8A6B008C; Thu,  4 Jun 2026 07:03:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D62796B0092; Thu,  4 Jun 2026 07:03:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C0C276B008A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:03:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8A2EE1C20F4
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:03:39 +0000 (UTC)
X-FDA: 84841944558.15.C20C98D
Received: from outbound.baidu.com (mx16.baidu.com [111.202.115.101])
	by imf29.hostedemail.com (Postfix) with SMTP id 0AA1F120008
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:03:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b="N1c+ApV/";
	spf=pass (imf29.hostedemail.com: domain of "prvs=md16098F0731=lirongqing@baidu.com" designates 111.202.115.101 as permitted sender) smtp.mailfrom="prvs=md16098F0731=lirongqing@baidu.com";
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780571017;
	b=H/E/BuGnUIaRTGLtWj1K97gGWxaP9I7ATjhFzpOJ1MEPqvrcAnTpQzK2ubpzpUUpUURlxn
	GFHLrEtrbZzaSXnKSYVU1KDFjIrX8FSxzWR4uB+iQIJhX4uzP4e+XtoMr9Er21mAZXu8+2
	UaAA92Kqzc2xx1m4oO9S97I1l4t4L4Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b="N1c+ApV/";
	spf=pass (imf29.hostedemail.com: domain of "prvs=md16098F0731=lirongqing@baidu.com" designates 111.202.115.101 as permitted sender) smtp.mailfrom="prvs=md16098F0731=lirongqing@baidu.com";
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780571017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=w92cZ2nK9Zp3rFwz53YEnnxqHwDnKWU566oE80egZhQ=;
	b=3/MpETbFUC8p9dDihp8PwYZbaUCIboD1vKEgLK4IbH9Hdsekn1LFpP8awNP7yNg8uzhtGO
	V28j3TJ6WuFyBVGZcvByhEBpgbE743M9tOBcb6L5c4KNz3Q8HS6pZuECVRjyZBVPf+bLe0
	x0jX9INxf4d4tNICa8CW2qLV7LZyxl8=
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, Andrew
 Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph
 Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman Gushchin
	<roman.gushchin@linux.dev>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: Li RongQing <lirongqing@baidu.com>, Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v3] mm/mempool: Untangle CONFIG_SLUB_DEBUG_ON abuse and switch to static key
Date: Thu, 4 Jun 2026 19:03:18 +0800
Message-ID: <20260604110318.2089-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: bjhj-exc4.internal.baidu.com (172.31.3.14) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1780571009;
	bh=w92cZ2nK9Zp3rFwz53YEnnxqHwDnKWU566oE80egZhQ=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=N1c+ApV/0pkSLxt4fczPqkwaZ4ftA8kmr7FB0uM/rwDL6ilndlCEGjbyKuyVfTel2
	 Tw4OBAPybFtKpvmttiIdbi7v6+7UeSrV5SBmsZX2pawVtEdHng35VLGrjXBKpGMNdI
	 y836GFNAz684i44gvTxKYvVaPONvgcjjENr8LD9RhQx61gTbnir7xt9wFF4BS9J8zx
	 YEDUeqJPOyoJDFyEhHwqH/4aJ0lJxJBLeNMuO8h4gxK3cPKIdg/V+mH4LPoNmblSDJ
	 L40ZOTA3XI/GVZRFJMH9F4+e50p2r2IF1btMO5CYvDr8bL3d/UW6iOmnel8Ebt2g2m
	 s6dP76NwaIZCQ==
X-Rspamd-Queue-Id: 0AA1F120008
X-Stat-Signature: p8amezcainbifjw14yhgzk435pcmbrhm
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780571013-681150
X-HE-Meta: U2FsdGVkX1+A1WM9avF17MQSo/7dqbr3pzmtiL7+SR29+LV6rhk4gxveo8PR5TlYkGXcrbi8Hdu2yIa+IZevPVjANOv/fXpHSe2CcLZogt5+aw2w+y9TvI0Om6RJFK1H6KUnoZe4IP6iHW4oCNGYg7kZjjArluk0SXq2MjcSZkxdZwqK0JFlgPopqFV92GrwEOHuhnQSV/KxOeOstsH1SVIkNbScZw2qUFwKjiCoJLRe3lICl05HEOVsNNm0l6CIxPXlQUnTn6z8V7fpWQnInqUbBh9UJYugSREBDcDDJPdOFzPVCKtyBcLQbCS2zr736vUOY0LddPqMF0q2XQLKQK+MJIk12mUUwE669d15RTrteAEgYSEx5YlZpm3kYBPjKZvmNJi9XO+5L8xnn7pMxyObfVRiXKNKBz6He69hpTs5YiSyCyQtOH8c1LFSq70/RYU4Hixc9eY/776c45GwhRzMbh1twGt4JWuhO92uTSAikC2fiw3JG3uMettNnzR7bsksO8Za5IwyOu5/xNx/CDSOsDtJc8ExudhNR4tgFTl4MhSZ2O/k4HumZzhw7iuyEmFsGFhrr8yEa88RgAQyYHvdZZlbAd77cskqKJc/QMWd07lgGEs6sRU+9oKAIQbt5gdn/giuLMWyvkBt78rDYsXZX12XIHn4wveDZ2XBMu4OiG1j7Hi8v3sI4/MNQqiMbjvQpsxLjqc1HYNxAdgCMU3r7weucBrVDRfoHOYrDaj5cuIkL9y4NSLU9Z6aO2I1FuNCnGoBWzyihmGmL+8KIFZlhNspp50ks4Ix9W0UE6M5lhIwhcxjg+TfCRfv6vI/adqz8aiR+pz4QbA4DPQnoArjwOLnUKNOY0ctjusYl1cN4skk43i+wd1bPtOStirWx55c7Ac8kpdUY8C+foVjG1fWV1kUyOUY9Gp0RwdjPODiso2xPucx/A/qqpW/BPdSlP2JFtN0EMtZa/fl6A+
 cc8JchG5
 ljag2+PwRM/vWMDMtv6fVqA74AaLI8TOohRNDiEThwa29fJsqCpce8TLbgjpkca9TAA0fLjpVi15nrICj5geHsgKeKXHIRuZ6BftfjMgqh7GbQVuTlGbH20qvuw2oIf59QyeRpY+UqGJkJTAWlJBJk9RuC6YU1x2fJziSOAEjYbTaEU9gCiT8jh2+VprwKxkZf3yvw2P3CCfb1DlbKvQXT8w71h9rwzPkOle39kl/8HRauEN8wckE+VxHXxUdpp7AY4clJMQvh1m7NZRfa5fJXxuSnQ56Ty+UbIyLBr1n5Vf5xrSgd6GB1qWk6P14/UKewUyhKwP7UAvVI8zREi9JV0W+f9P5GVpQljv3x1AYB5/vOFSzR6mOoHi9LBzfICLETx/8rQ746CsRC7D3Qamqs4UzhkQaySlT/OCFHGN0jUoO/U07StLWHJOK03BCW2dAOQXzf2Cnr3C+wEVtTfs26TE5LnR7ay3o60j1WtJK/uag0H25XWBLEKWsjrnSeAVthgMdu30yReJDxA7q9NtuKaJO/2zUGdVhnPIoWvCdFX6s00jxucdXWLislCkgVnGbPsVO42texfBLEMHOhzLTHAt+GrWDkUKVn8heNjGQzx99j/5wD6gLU1qYw3suFpUOi9VvROS4WHh6WjIHkETLtwPsjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li RongQing <lirongqing@baidu.com>

The mempool subsystem historically wrapped its debugging logic inside an
merely defines compile-time defaults for SLUB and caused two flaws:

1. On production kernels where CONFIG_SLUB_DEBUG=y but
   CONFIG_SLUB_DEBUG_ON=n, mempool debugging was completely compiled out
   at compile time.
2. On kernels with CONFIG_SLUB_DEBUG_ON=y, mempool debugging stayed active
   even if a user explicitly disabled slub debugging at boot time.

Clean up this mess by removing the #ifdef and switching to a runtime static
key (mempool_debug_enabled), allowing mempool debugging to be toggled
cleanly via its own boot parameter.

Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Usama Arif <usama.arif@linux.dev>
---
Diff with v2: Move the check out of check_element/poison_element 
Diff with v1: Rewrite commit message, change early_param to __setup

 Documentation/admin-guide/kernel-parameters.txt |  5 ++++
 mm/mempool.c                                    | 35 +++++++++++++++++--------
 2 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 642659b..89b5994 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3980,6 +3980,11 @@ Kernel parameters
 			Note that even when enabled, there are a few cases where
 			the feature is not effective.
 
+	mempool_debug	[MM]
+			Enable mempool debugging. This enables element
+			poison checking when freeing elements back to the
+			pool. Useful for debugging mempool corruption.
+
 	memtest=	[KNL,X86,ARM,M68K,PPC,RISCV,EARLY] Enable memtest
 			Format: <integer>
 			default : 0 <disable>
diff --git a/mm/mempool.c b/mm/mempool.c
index db23e0e..dabe05c 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -16,11 +16,28 @@
 #include <linux/export.h>
 #include <linux/mempool.h>
 #include <linux/writeback.h>
+#include <linux/static_key.h>
+#include <linux/init.h>
 #include "slab.h"
 
 static DECLARE_FAULT_ATTR(fail_mempool_alloc);
 static DECLARE_FAULT_ATTR(fail_mempool_alloc_bulk);
 
+/*
+ * Debugging support for mempool using static key.
+ *
+ * This allows enabling mempool debug at boot time via:
+ *   mempool_debug
+ */
+static DEFINE_STATIC_KEY_FALSE(mempool_debug_enabled);
+
+static int __init mempool_debug_setup(char *str)
+{
+	static_branch_enable(&mempool_debug_enabled);
+	return 1;
+}
+__setup("mempool_debug", mempool_debug_setup);
+
 static int __init mempool_faul_inject_init(void)
 {
 	int error;
@@ -37,7 +54,6 @@ static int __init mempool_faul_inject_init(void)
 }
 late_initcall(mempool_faul_inject_init);
 
-#ifdef CONFIG_SLUB_DEBUG_ON
 static void poison_error(struct mempool *pool, void *element, size_t size,
 			 size_t byte)
 {
@@ -140,14 +156,6 @@ static void poison_element(struct mempool *pool, void *element)
 #endif
 	}
 }
-#else /* CONFIG_SLUB_DEBUG_ON */
-static inline void check_element(struct mempool *pool, void *element)
-{
-}
-static inline void poison_element(struct mempool *pool, void *element)
-{
-}
-#endif /* CONFIG_SLUB_DEBUG_ON */
 
 static __always_inline bool kasan_poison_element(struct mempool *pool,
 		void *element)
@@ -175,7 +183,10 @@ static void kasan_unpoison_element(struct mempool *pool, void *element)
 static __always_inline void add_element(struct mempool *pool, void *element)
 {
 	BUG_ON(pool->min_nr != 0 && pool->curr_nr >= pool->min_nr);
-	poison_element(pool, element);
+
+	if (static_branch_unlikely(&mempool_debug_enabled))
+		poison_element(pool, element);
+
 	if (kasan_poison_element(pool, element))
 		pool->elements[pool->curr_nr++] = element;
 }
@@ -186,7 +197,9 @@ static void *remove_element(struct mempool *pool)
 
 	BUG_ON(pool->curr_nr < 0);
 	kasan_unpoison_element(pool, element);
-	check_element(pool, element);
+
+	if (static_branch_unlikely(&mempool_debug_enabled))
+		check_element(pool, element);
 	return element;
 }
 
-- 
2.9.4


