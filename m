Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 683F4606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 13:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=IjFpKo2H
Received: by kanga.kvack.org (Postfix)
	id 8D6626B00EF; Wed, 18 Nov 2026 08:27:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 887386B05B0; Wed, 18 Nov 2026 08:27:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79C786B05B1; Wed, 18 Nov 2026 08:27:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5ADA46B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:27:27 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EBB2480756
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:27:26 +0000 (UTC)
X-FDA: 85448316492.04.041150B
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
	by imf25.hostedemail.com (Postfix) with ESMTP id 49B7EA0007
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:27:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=IjFpKo2H;
	spf=pass (imf25.hostedemail.com: domain of 3u6f9aggKCGA8PB9+EGREMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--ardb.bounces.google.com designates 209.85.221.70 as permitted sender) smtp.mailfrom=3u6f9aggKCGA8PB9+EGREMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795008445;
	b=vaA3RUT7HMOY9D361d8p7FEyjokHW80a+zh8P746ExYZiqO3uKOaIIbmg/1QnSa0sGjNQJ
	6bQSgwLmvdVqNor+FokXn7IxRIs2ab4TBC46vKOzQVx+WPeSPlDVvGagJ+WLHgb3ZV0P5s
	/H3VoemtR2sCmjXm3XOBnfvD2xRgHqE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=IjFpKo2H;
	spf=pass (imf25.hostedemail.com: domain of 3u6f9aggKCGA8PB9+EGREMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--ardb.bounces.google.com designates 209.85.221.70 as permitted sender) smtp.mailfrom=3u6f9aggKCGA8PB9+EGREMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795008445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=C0gkJSeMraADNA/r3uqlbuo9SQ79PZxtaX0FhESBVCg=;
	b=Ee1NIiq5n9PwijSyH7z3XdOuPDkoPJjHTu8CU2LAKtwN3w3dSG3z90xz8itnhq1Js5Mal0
	Tl9+NDpi2MTkOATSnCYRs4+icG48GGzA4BC3KZ9q2hiour0V747BbgpiJRSEz33oOz1qZT
	Y8OuxT/SbR81HKSYzLqZ5GX4frVxcVQ=
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-48fbcf023dcso455292f8f.2
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:27:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795008443; x=1795613243; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=C0gkJSeMraADNA/r3uqlbuo9SQ79PZxtaX0FhESBVCg=;
        b=IjFpKo2HCTyfg6jQ4wUNiva388I6wrBaJtQWm3l3ppttK0eETE+U4X42pK41PtCQm2
         /f3APPKvzTUxUqKl/vneav4+y6SVJDX/CNCCAyKKLqPkKyb+1yS7M9oKScNF8kRq/RDr
         ElH/S1aOuBwDeaM85XtFpAxKvxvjB7d8tMvTU8bXalYsspZVi3HdxyXHPpPYYCMAeskp
         /j+N89snJk2HSNhG2fxDwMOsglqVH7J5xr+cobcpqhLFFqF7ebiDb+A9BTm856NTqwji
         XMKp07v+1QloceEQygc2wCw97iaQh+GRn/5Rv4lqgN9HP8VJ2kZiwIki/AXDQDJoYtFl
         DqSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795008443; x=1795613243;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C0gkJSeMraADNA/r3uqlbuo9SQ79PZxtaX0FhESBVCg=;
        b=WQFs2xAGNUzhOwiOVr1WdVpZQrGvOA9pdwuQLUeuWswuPh/3HWsXPiKWfWDwnVE+f3
         KZnXTjyOESQzupEIL9NVoKn/uHGoi4pdtxTIAbMFWxpwOV/sSmkoXxI7LcfDAbzx14k1
         /lekYhPfZWrGyg8Zs1fX+NEOoDRRKnL3QWqx07rlKG32s/X+R7xpKx1pb22h8kLiydjJ
         NkXisVFH5LYph1Vrnw13FuKOJTl6K+6uqtRotqpbT4jX57B6u/I7Dfh85KtXs1Gj6oHN
         crCynUAuq5yI1VyYahY5n6EBpZZ4U11faeg7mpgBJxrwvjrM6L0sZ2Zy2MKyLAX2upI3
         NEGg==
X-Gm-Message-State: APuU4Z8lMRWIEpIeho6dsHpOHHTlDrULPADgKaWUtarZee/AosjC2+nU
	IBM3Xp87ZxowGyYUu0gVevJg3DrsJecGbiZZzZz3ECyjXD3s79xnllpnrKL/byYB6AGQ+reVK+B
	O95LQx7vRFWPOxOsbHMF/NWsHEliY70KAvTFNehOCF4+hD011aW1vwbwQk/yB4yvR18Ckx3Dorr
	wAU54g0OM25dnvDNb9vK+m
X-Received: from wrxq12.prod.google.com ([2002:a05:6000:cc:b0:4a3:4620:1d69])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:3cf:b0:4a6:5a2a:f5a3
 with SMTP id ffacd0b85a97d-4a65a3a384dmr5520002f8f.3.1795008443068; Wed, 18
 Nov 2026 05:27:23 -0800 (PST)
Date: Wed, 18 Nov 2026 14:27:20 +0100
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=5399; i=ardb@kernel.org;
 h=from:subject; bh=SCJyZ1eX6TDbZ6r7r5FwcibvX2ynI4W+KzVBJk10Ujs=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIevv8h2PPphaduuHXXBpklxxYAlv+JuWxs/mYQs5v/akP
 OkM9o3qKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABPR2sLIsEDcYZdF9fVWY4ns
 ZZ287EVyGbvDnjk1zoqYy731z//pKgz/FKa0Pf0y76PgVDc7jcqEdyZ2t+anr0/1KG+zSXe++ek SNwA=
X-Mailer: git-send-email 2.56.1.703.gf848ed807c-goog
Message-ID: <20261118132719.632451-2-ardb+git@google.com>
Subject: [PATCH] alloc_tag: Use __ prefixed ELF section names
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-mm@kvack.org
Cc: Ard Biesheuvel <ardb@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 49B7EA0007
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: gsuzra68hx7odoobho6d833gx34mppm7
X-Rspam-User: 
X-HE-Tag: 1795008445-286629
X-HE-Meta: U2FsdGVkX1+ZH58XTAf1yJLbSf7TRMjYNhMkNdtPnnnuW7LLRLpFOQdlrtHhWD8wPC73mGBkOSEsau/90Qp89zCpzLkhPj/R6+mehNjxcnU6Acw1r/kTXhiexk40B7G7KQSg/1JMh36n5gLZIMOOoeUFpBZTeLsk4HPml6/StILypFBsGaJX6AVUEkJSU9iT7op/RFehUHyYtT2y+1IxRSwiQnDvBwyOh96Jasolwm3Mva0Pxe9hK5D6SKr9Wjk4lfkY+4vhiTyk1YozlzyrLeMSw1G7kXCsuXUDpwMtWMPemDznuIh/NSe4/prLhQuS5IUXsmbhZ63z7O1PumEBdkLW4namVe2Pqcee8InqfhgUUY2EbDNscmlgX+61xkPEaLauXtRbLQTDLBNYq8pKrTWhUr1sZtmYf/uL+O7rXV3dP33pSoxfzorHQ8l/J1RTsJKRELNjkfYxSLRKQg/7P7OibjshDvhyXPXrq8UGDYtx/ImiQWJCXfqlYn2mjQWZ7HhUtVnVZD1N4mT8pmbcC/KK5mEa0PPmqfDKovuIMGIYSSrqJzy0A4/OyRgfnskQZ1ovUQfthUVk3gKOQd3n0ZMblTiNDOmJS6Jx7k+Cr2mF5LXq9FoVeYntvTD5fuvL9FK6coolvzmjQfY2VQmJFtUcDWQB+E8JjPqxiBVvVaq/pY0k0Mt/5olWpO2D4PggvyP1W/Kl52XdAn1svcn9SHos8M25l3NTje3OsV1ojIO2stCFAnrSbNv1BUPs4XdRWqG1Ub7cUkb1yalyop4xIcZ9JhpquojPg0ON8PldGKBBVt7UEjQlnYRBuy/lIDmTeKdgYuIMMvgHL6+/ti3sj3eUnI8iRzMubsMzMtXDRX3/sdu6lFCClQLzGCh2OpaSXz20x5SaXMO0tSHqRWkLO9NzdjCLt1XN0l7l/lyQoxf0IMIdVfIr1+Yz4gS8sZNzfuDeTTuj/JOHtD+Xep9
 mgOEoekn
 u7U+ahWA9eC5Y1Fto4YQ9pDaZe7CjUvxu/HO/mkwSwJn4eNvtZpLfcW4WzKLVSVfwips0BU6bjl3brQKb6zxyxmGx9fFWnRSuXPKcfYHc4ilRUAZslpwx2+b0Ko3MlIT3g+BZ/+x/rZvlqGCdyE1SpJSQYXaitPsWG8LzvWoK9IgC34H6qNmHZUDkYkoiKXw9+FgNuwwyM70wQiUPKG4C4TQtouNJ5SMgHFJpMqn8TCVC+1A7iqGVjarvPqAaaC0p9+uoVB106BUIiO8hl7TVuIHjt3hi+mlUXRWpL5ui5DHB8jXD2My/7qsbhYefGEcBQDNclOJ38CCqeWh7pnREl0zuJtYLO0/zxFd5dW1l3xuYQo/hHqlasqm9ZgRcfUm60a5wlerZLOvRQS53luoMrOYTqWWWWL6XPT6nyWY+uK28bMtshC889LIujSpfeYlNoE68fcpiY4DwqVaMcUbwJecwdbMOU67H2ha9KNHbSFUGMHoUDCv0pL1M4BOG7FiMkKn9lGJhtEM1W0cDUC4NqHcxvNPiNonzKSSN7ew8rXuvjXOQMNM/9vOELwA/p76crU7nYxAGXJjBU/rSLPHkEJU/0HSwKfeXwfN/NJFP21xbvz9caDoex1mMSkp4KhJJPAdB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ard Biesheuvel <ardb@kernel.org>

The compiler will emit static relocations related to a section .foo into
a separate section called .rela.foo, i.e., it just appends the section
name to the string ".rela"

When section names start with . or __, this results in relocation
section names that are correctly matched by the various pattern rules in
the various linker scripts across the tree.

Without any such leading delimiter, it may lead to spurious warnings
such as

  >> ld: warning: orphan section `.relaalloc_tags' from `init/main.o' being placed in section `.rela.dyn'
     ld: warning: dot moved backwards before `.rela.dyn'
     ld: .tmp_vmlinux1: section `.rela.dyn' can't be allocated in segment 1

Fix this by renaming the section to __alloc_tags. While at it, tweak the
headers so that the definition of the name appears only a single time.

Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Hao Ge <hao.ge@linux.dev>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 include/asm-generic/codetag.lds.h | 14 +++++++++-----
 include/linux/alloc_tag.h         | 11 ++++++-----
 mm/alloc_tag.c                    |  6 +++---
 3 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/include/asm-generic/codetag.lds.h b/include/asm-generic/codetag.lds.h
index 4948e5d4e9d9..443e3a8fa60b 100644
--- a/include/asm-generic/codetag.lds.h
+++ b/include/asm-generic/codetag.lds.h
@@ -2,6 +2,10 @@
 #ifndef __ASM_GENERIC_CODETAG_LDS_H
 #define __ASM_GENERIC_CODETAG_LDS_H
 
+#include <linux/compiler_types.h>
+
+#define ALLOC_TAG_SECTION_NAME	__alloc_tags
+
 #ifdef CONFIG_MEM_ALLOC_PROFILING
 #define IF_MEM_ALLOC_PROFILING(...) __VA_ARGS__
 #else
@@ -10,15 +14,15 @@
 
 #define SECTION_WITH_BOUNDARIES(_name)	\
 	. = ALIGN(8);			\
-	__start_##_name = .;		\
+	__PASTE(__start_, _name) = .;	\
 	KEEP(*(_name))			\
-	__stop_##_name = .;
+	__PASTE(__stop_, _name) = .;
 
 #define CODETAG_SECTIONS()		\
-	IF_MEM_ALLOC_PROFILING(SECTION_WITH_BOUNDARIES(alloc_tags))
+	IF_MEM_ALLOC_PROFILING(SECTION_WITH_BOUNDARIES(ALLOC_TAG_SECTION_NAME))
 
 #define MOD_SEPARATE_CODETAG_SECTION(_name)	\
-	.codetag.##_name 0 : {			\
+	.codetag._name 0 : {			\
 		SECTION_WITH_BOUNDARIES(_name)	\
 	}
 
@@ -28,6 +32,6 @@
  * unload them individually once unused.
  */
 #define MOD_SEPARATE_CODETAG_SECTIONS()		\
-	IF_MEM_ALLOC_PROFILING(MOD_SEPARATE_CODETAG_SECTION(alloc_tags))
+	IF_MEM_ALLOC_PROFILING(MOD_SEPARATE_CODETAG_SECTION(ALLOC_TAG_SECTION_NAME))
 
 #endif /* __ASM_GENERIC_CODETAG_LDS_H */
diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
index 7f2d80a59792..0703592a3302 100644
--- a/include/linux/alloc_tag.h
+++ b/include/linux/alloc_tag.h
@@ -15,6 +15,9 @@
 #include <linux/static_key.h>
 #include <linux/irqflags.h>
 
+/* for ALLOC_TAG_SECTION_NAME */
+#include <asm-generic/codetag.lds.h>
+
 struct alloc_tag_counters {
 	u64 bytes;
 	u64 calls;
@@ -74,8 +77,6 @@ static inline void set_codetag_empty(union codetag_ref *ref)
 
 #ifdef CONFIG_MEM_ALLOC_PROFILING
 
-#define ALLOC_TAG_SECTION_NAME	"alloc_tags"
-
 struct codetag_bytes {
 	struct codetag *ct;
 	s64 bytes;
@@ -98,7 +99,7 @@ DECLARE_PER_CPU(struct alloc_tag_counters, _shared_alloc_tag);
 
 #define DEFINE_ALLOC_TAG(_alloc_tag)						\
 	static struct alloc_tag _alloc_tag __used __aligned(8)			\
-	__section(ALLOC_TAG_SECTION_NAME) = {					\
+	__section(__stringify(ALLOC_TAG_SECTION_NAME)) = {			\
 		.ct = CODE_TAG_INIT,						\
 		.counters = &_shared_alloc_tag };
 
@@ -108,7 +109,7 @@ DECLARE_PER_CPU(struct alloc_tag_counters, _shared_alloc_tag);
 
 #define DEFINE_ALLOC_TAG(_alloc_tag)						\
 	static struct alloc_tag _alloc_tag __used __aligned(8)			\
-	__section(ALLOC_TAG_SECTION_NAME) = {					\
+	__section(__stringify(ALLOC_TAG_SECTION_NAME)) = {			\
 		.ct = CODE_TAG_INIT,						\
 		.counters = NULL };
 
@@ -117,7 +118,7 @@ DECLARE_PER_CPU(struct alloc_tag_counters, _shared_alloc_tag);
 #define DEFINE_ALLOC_TAG(_alloc_tag)						\
 	static DEFINE_PER_CPU(struct alloc_tag_counters, _alloc_tag_cntr);	\
 	static struct alloc_tag _alloc_tag __used __aligned(8)			\
-	__section(ALLOC_TAG_SECTION_NAME) = {					\
+	__section(__stringify(ALLOC_TAG_SECTION_NAME)) = {			\
 		.ct = CODE_TAG_INIT,						\
 		.counters = &_alloc_tag_cntr };
 
diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 82e2c3448dcf..4c13483e68b6 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -23,8 +23,8 @@
 
 #define ALLOCINFO_FILE_NAME		"allocinfo"
 #define MODULE_ALLOC_TAG_VMAP_SIZE	(100000UL * sizeof(struct alloc_tag))
-#define SECTION_START(NAME)		(CODETAG_SECTION_START_PREFIX NAME)
-#define SECTION_STOP(NAME)		(CODETAG_SECTION_STOP_PREFIX NAME)
+#define SECTION_START(NAME)		(CODETAG_SECTION_START_PREFIX #NAME)
+#define SECTION_STOP(NAME)		(CODETAG_SECTION_STOP_PREFIX #NAME)
 
 #ifdef CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT
 static bool mem_profiling_support = true;
@@ -1322,7 +1322,7 @@ static inline void sysctl_init(void) {}
 static int __init alloc_tag_init(void)
 {
 	const struct codetag_type_desc desc = {
-		.section		= ALLOC_TAG_SECTION_NAME,
+		.section		= __stringify(ALLOC_TAG_SECTION_NAME),
 		.tag_size		= sizeof(struct alloc_tag),
 #ifdef CONFIG_MODULES
 		.needs_section_mem	= needs_section_mem,
-- 
2.56.1.703.gf848ed807c-goog


