Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10251C5DF71
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 06:22:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58ABF6B009E; Tue,  2 Jun 2026 02:22:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53B606B00A0; Tue,  2 Jun 2026 02:22:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 478276B00A3; Tue,  2 Jun 2026 02:22:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A49E6B009E
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 02:22:10 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ED18E920C6
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:22:09 +0000 (UTC)
X-FDA: 84833977578.28.468D2F1
Received: from outbound.baidu.com (mx13.baidu.com [220.181.3.100])
	by imf10.hostedemail.com (Postfix) with SMTP id 3AB43C0011
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:22:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=temperror ("DNS error when getting key") header.d=baidu.com header.s=selector1 header.b="S4lB/Enr";
	spf=pass (imf10.hostedemail.com: domain of "prvs=md1607C3BC26=lirongqing@baidu.com" designates 220.181.3.100 as permitted sender) smtp.mailfrom="prvs=md1607C3BC26=lirongqing@baidu.com";
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780381328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DaOgBQX2Bprj5SEr7V1aHONGUCzeW+2n3CTATOhVeeA=;
	b=tqtslADrCBNyZUAsW/Qtn7hFtXU2eW5aYM59CB5k0rhHRzx4nYKMpjAZulCU/ohfLcBPRF
	IpB3NCvkFxulpvJY3cRguWBqN2F53v8KCntnZB1V7qCKVO9+V8INuGBBTTfOizL4NSrWuJ
	elLcY0rZXsbBbHFAweRi1Biw61q60Uo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=temperror ("DNS error when getting key") header.d=baidu.com header.s=selector1 header.b="S4lB/Enr";
	spf=pass (imf10.hostedemail.com: domain of "prvs=md1607C3BC26=lirongqing@baidu.com" designates 220.181.3.100 as permitted sender) smtp.mailfrom="prvs=md1607C3BC26=lirongqing@baidu.com";
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780381328;
	b=AFeo7fHTRYZgWB4vVejC8v7Rj6MqygvuUKusnWi6Y4S9VzVwIjWZWZBHqdt/WaMF8YNSe3
	SQXoatSZ5PForiso0Rfza285PeNgTEdPcGNJxtCzKf+xgNvIu5VCejx+TtJDQ20HnhnOdi
	u1XqVD+z0DT2hmMencD7/qa+jvCi2SA=
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
Subject: [PATCH][v2] mm/mempool: Untangle CONFIG_SLUB_DEBUG_ON abuse and switch to static key
Date: Tue, 2 Jun 2026 02:21:42 -0400
Message-ID: <20260602062142.1790-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: bjkjy-exc2.internal.baidu.com (172.31.50.46) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1780381317;
	bh=DaOgBQX2Bprj5SEr7V1aHONGUCzeW+2n3CTATOhVeeA=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=S4lB/Enr29lMpr6+7E1SC+oWMbBuGHJFn5nGYXF+lbosR+VhpVm9c6btNo2de7RVN
	 wFjsWCFas+atqBD40tqAZjj+S7AkW2nyoa/kPdJpzGnfiYP1Vdd9uiXqXzkD6XeCQT
	 PFLyeYTWcinTK34Q9svaJH+hPW8ZSaF7q+A8tsXTaUpjr8xGAG3IvVsYjev8Y5GaVx
	 co3l6zsTqn/yrN1eY+dZEsahjpD0EhYLxpbJmqRzj3Hgx01NJpin6LXYJq+2JlOPvX
	 fKH8LZWGWwBi6jVj4e4ba6JAdDu0+A18QLmrVQ3c40h8ZplU6ockO3Jj262OhkXurL
	 UsS87trX+cenA==
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3AB43C0011
X-Stat-Signature: ajb7qu15e6ukyas1j9yeufjr3shcgqfp
X-Rspam-User: 
X-HE-Tag: 1780381321-925382
X-HE-Meta: U2FsdGVkX1/udDAcMtLCUruRariLkwDEALz72GYjfIC2UzXkCLDfyzP5l9nIrfzW/F1TufSN8exwHrt1JIInDUqZT6OA1e3HYLZuLLcR4cDedpHjIsOauZuP8PsS85FcCtESSRrx/eqpMB/M9VM9DM3KD+xzbXZ9V7MSADTHJEFkvGYXyznU4PS/uqDZVva7vsJo0S5sWzjInolxrsZdjpTjSzPEig7S/DT+OESWspq7ZiDtO4g6MKGw0akAZ+VsDI+izfdffQlp9sZkBLtSk3cKyR5GmeqU8WUr+F8avS9C8qSGTe2SjIIxBBWUjD/sisGKsBI6RCRN5Wan7hivhmJwY8GrvERMEUbsVfUYtYm8QJuwyF4K4GYitzJU4JJteLoI1BQ9yAz5999+/3qqgDnMK+ae0Uc3l81hJnolSgmPzuKp24heux14TC/Fph0AYpT/vVmv3k/B1o+hNVDoV0bJM1IlD6kuy3b79u8xVZNHoF7xk5fZR7Njrf+jTHvvWRR9r0h/FaMMIgkm+bpuywleGgk30XNb8xEZH/mJ01GSQjno5QZZrpZtEy7gGvESW/G8G6OEiAphXOBWWaF5KP7VRMY3y8Upf9wm1e0FK9dtR/9SwFjh/cUctFPFK7AIcunyh3MOBCIbFlRfO2NlTjdtdDbLfU4OfvbIbf4SNmAFR7UvPDeN8XZDW0TrW1UmGNxv0i3C5SSCcbkTH4sbSU9AWr6Is973CQRZm8I/+rismzD6Qb2rL1LfT0YYjh7OwrWbPHzlyuiFpd14eq4sF9XXYS7TGcpj60sTRQnZRLUZKvpR45IgwXt+c6WnG4kC7jwMwnrPVjbPac9eRrw4CFhsgp2BQYkvEZDM5LMs4gCGANwjX7uhNoHV5jeEfXmHAgDd+FWpZoLoybmz4XFbtDZM4S9t6h4a7vONZKXkge/GlBfqjUTJiAlqaZt9G3IhQkLB306ATdQHg9ZQOaD
 pvhdNPK3
 8bqGgt48TUMMWWg5sjMINBgf1GvogN4aNBqHc3r/qKIiFF6kvTD53LtlQsP10NLWkRxK8QEvJMEGdicmbDBBNeWC21i45PdDQ0nuTfQMTfvS1peZ6h4hKwQlAKy0jCikfyqve0riEvk4TJngTEHwKhGz/GWZyueva3WVIjIKaN1LPIHAY/q8nXydNrXKtO7V5l+LY9/4hOjxN52UaNLgix/RrZOWDRgx/9F6kGnqxaj4TKUI6iQVBa+WCL2YovFYVnxFqje5PL2knWTTTmVLo6jBLlGR1ThclpR4MWZNSQoyvGOWYAt6OJ4LVyXjZrFJooFC4r6YHGV2HCOvLLPGMfVOnReqxWQrit36Cd1s45p+1XDSb4nUKY/6m4oghcJNz3XAZN99oK96o9+ZdZkR6VtuWHOlq15ijriUCrRi6NKBvQQ1UxLRxQ5XXvXTVL1X+zgoDCBTNOeBP6Tk5R4mpJzB2SwEkzFnPqLFNA5WO8mYPfX44OxKSowbHk3XDAepW0GblLSgOcT6+/wDQQ1bZ2XZhkDyp3wP7KsEI58vcY1DZ6oiNXNm5oVfSKJ7jVDQ61R/38eBsA/k7KE8ZSThwgrMa6dycLolNwCitQ8+86npQ1KM1ctKJmEkg3GY5qvBHKieGD61kI9kPunT59PvWWrzg4bdSNexjwa43
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
Diff with v1:
	Rewrite commit message, change early_param to __setup

 Documentation/admin-guide/kernel-parameters.txt |  5 ++++
 mm/mempool.c                                    | 32 ++++++++++++++++++-------
 2 files changed, 28 insertions(+), 9 deletions(-)

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
index db23e0e..71e4b54 100644
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


