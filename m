Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68D0ECD5BC9
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 10:46:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B17A6B0005; Wed, 27 May 2026 06:46:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 462926B008A; Wed, 27 May 2026 06:46:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 378626B008C; Wed, 27 May 2026 06:46:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 26B0D6B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:46:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 52CF71C16BC
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:46:55 +0000 (UTC)
X-FDA: 84812871990.24.5FE04D4
Received: from outbound.baidu.com (mx20.baidu.com [111.202.115.85])
	by imf10.hostedemail.com (Postfix) with SMTP id 66E25C000F
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:46:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=IEPKg1hi;
	spf=pass (imf10.hostedemail.com: domain of "prvs=md1601170BF1=lirongqing@baidu.com" designates 111.202.115.85 as permitted sender) smtp.mailfrom="prvs=md1601170BF1=lirongqing@baidu.com";
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779878813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ttl9/NsuNFlHuotnHMTPmnULmKzmEYt9adzvKWukcR0=;
	b=qHv2+1KFtxh9vedy6NO8R/8MVkJ6P2PBQQIc1z4EPUqHe8vi0dAx7jMnb3rFCUtUWL5PfV
	46CNtp/FxHXgWjUwDoJAF5yGEFg0Ae4x0FC5ptikat2ih2ILSOMJcZFV5LQFA4sGNAtRd9
	0OW1PbmDmYtXMAkVNuyEf7y/1i7HL9c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=IEPKg1hi;
	spf=pass (imf10.hostedemail.com: domain of "prvs=md1601170BF1=lirongqing@baidu.com" designates 111.202.115.85 as permitted sender) smtp.mailfrom="prvs=md1601170BF1=lirongqing@baidu.com";
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779878813; a=rsa-sha256;
	cv=none;
	b=R4P1FrboHmYb5cPU1/TzionSQA7mRtgUOl8cK7OQv7b3fGfwpG7ge5uKcG2k9XwWGqM14f
	CfzmO/KjoL81uSpBG4i30j98CPJASmsADLmavXvDS1ZNk6Ox3yHut6/sGpsa9IExtWmGSg
	AvsrPIznpITT2IEeFN2oB3sbm3c9l0E=
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, Andrew
 Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph
 Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman Gushchin
	<roman.gushchin@linux.dev>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] mm/mempool: use static key for boot-time debug enablement
Date: Wed, 27 May 2026 06:46:34 -0400
Message-ID: <20260527104634.2434-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: bjkjy-exc2.internal.baidu.com (172.31.50.46) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1779878805;
	bh=ttl9/NsuNFlHuotnHMTPmnULmKzmEYt9adzvKWukcR0=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=IEPKg1hiIMTsP4HD+cgRMhRkdDM7X4Tf1wLpUskAl/8wJx7arkEV4WaBCC+UQCFPq
	 S1OOJADpBdQplrnp+yiu91B+zS3ImXniJBE5BX6rA5KiI7ofT7Y0oitf+fbQ1sWkG5
	 jcwA8ikzlSqy+GgITq5eo/1gQ3zSmyo+LEnBT2x377BJY2grEnJzbs5hr8WCkoJBEp
	 5jm4pXB2iYK3duYCQZwNmuEi6zDO+UQu3pzdLQ7STBN4JtUvwSRisQKqNTkJctxxZU
	 LOfD7mdDwhwD8DvL5JZRewKt1+EwlAYHdgPK/3L25ryLiobIolgC8B9DRZ27NI4Ogd
	 0RLRXZ+z0wZEw==
X-Stat-Signature: 4kboyh83y1941wqik6wkfnydjcarnto8
X-Rspamd-Queue-Id: 66E25C000F
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779878809-954719
X-HE-Meta: U2FsdGVkX180Hjz1Zpc7E6TIviHZun4PTJkRfD5S4x+pvqW4OEpJIpp3SALUEbUo66BaVEDQyWBJYwYTV8CS33YZpDu4cFp1gA+vPbk86XQRNVTFxs3OsTMqORg9RuKs9ShleMrXVHxEfG2gdYpfwYLe56khulBTJv9DqTpoMbWjsX1ZInX1wyJHrQLym+UFIUsCqavPpLtFrDMN14QBUL6tidrDzzIGazo7vWX6gflR5w6wE0IVzH1q7Idl8p/Dw877Q9t/CfEkP/2hxF7rYuLfnuTOLGQQNgXwhGCb539j2ApQMOSwBAjpm/iG1ht1r6UAMW4kTNbO/EacYLTcziMPHusHCOEBHS85zFs5mOtUrZPje9O4Vo/UefWdmpD1Wi2wWDMjVM1uYrpIgetCNrVy3k+u1nGPhy349BGEYDVWAx7UUck+OJ/Vhj0dPP4bkIS+sATBnoVsmrrNOhCT3CNJXt6Of5eH8SFXB3TOGP2jZNeegKXOeOBiGZBePVUpTJyi710rtbozqVABJhrHp7Uf0U+JVLsMyvXgydnzTmE4UwCcDcowlloRrvq8RlEwKta1FbvVg3ym2gTduhlJ1Fv34DXPEtWh55DC5ztALNbasWd+xdRT7+lHumanuB0f5Bh+4wqKQpOqvVbSQ0qf8BQGjbbJ0TkZBqavxoVBaFtTe4r3dQTfPKDIA60NdnjUlQud3OjjBqZiotirWoZcByR0jh3uVTH5z5jlK/cGsRnc2LFMmSzKDMIbAHSH7bmH9z9JI15zOWunHSe1sAZPn4O4P1TIe77neZ1aoXR7XcMkQmEjQnhu1+LIjPjtXTzT2CtXvx6ALhQOPxZKdI2luEScSgYMlfkMCGd/nL1YaZ1BEPwyh9ty199nlk3+AQWdQLNnXRdi+5IqAebP1eUeOzmkiYTsQ3kAmDbBuJ1/OZQdOoaGbzYg0XnOh2c9X95NjOLbWL00o6p1Q1H2Wrh
 BDEv2gL1
 O5Pp92+3QrfY19SXYdKcTJYhNtobSUKsWmfONnOXiRucaikdz2++P0tEHMddOAMMcH/vcOrk63NBJZgtP0SPzjX3AY5JmRKygJym1VUnuSO7DII5lczed1VJZILFFzJyp96UIscS/RXafLIRI4N4OvgQUcc7BJOCYBHlc7pOy8ffhkPWmgU3P40ssQOy4n+6ZLPR851TFlNISKLNVF6vt9V/3JGC0WfF/8GrMHwd5QmqI39l7D0JCbLlcGWkICn3Qk5+22T6mrKeNxQO3NBzb+r/8ifc8OHfTpH66q/ncG3y84Ms41rEMfPciUFvMtjzY56oncHU/+BkRlxjFyKjaeQ4UJcMn/eMOHlL5hjQnJpfuUkSNNOk+OMGVEngTkLFTe29nOdyrm776+/2cwcoYX8klUYrUj7NMjM7fV8bwc2KFLKLF1+Q2zRzmKRQNoJQy5tUpoDqGpC3nWxoZeYh6x/0z7QtzKbn7QuFwUO/N43v8MkZBHiwoKbT6ROFtF9Hnocwe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li RongQing <lirongqing@baidu.com>

Replace the #ifdef CONFIG_SLUB_DEBUG_ON conditional compilation with a
static key (mempool_debug_enabled). This allows enabling mempool debugging
at boot time via:

    mempool_debug

Instead of requiring CONFIG_SLUB_DEBUG_ON at compile time. Benefits:

- Debugging can be enabled without rebuilding the kernel
- Uses standard kernel static_key mechanism with minimal overhead

Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
---
 Documentation/admin-guide/kernel-parameters.txt |  5 ++++
 mm/mempool.c                                    | 32 ++++++++++++++++++-------
 2 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 35ed9dc..5a070e6 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3998,6 +3998,11 @@ Kernel parameters
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
index db23e0e..4f429a1 100644
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
+	return 0;
+}
+early_param("mempool_debug", mempool_debug_setup);
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
@@ -73,6 +89,9 @@ static void __check_element(struct mempool *pool, void *element, size_t size)
 
 static void check_element(struct mempool *pool, void *element)
 {
+	if (!static_branch_unlikely(&mempool_debug_enabled))
+		return;
+
 	/* Skip checking: KASAN might save its metadata in the element. */
 	if (kasan_enabled())
 		return;
@@ -112,6 +131,9 @@ static void __poison_element(void *element, size_t size)
 
 static void poison_element(struct mempool *pool, void *element)
 {
+	if (!static_branch_unlikely(&mempool_debug_enabled))
+		return;
+
 	/* Skip poisoning: KASAN might save its metadata in the element. */
 	if (kasan_enabled())
 		return;
@@ -140,14 +162,6 @@ static void poison_element(struct mempool *pool, void *element)
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
-- 
2.9.4


