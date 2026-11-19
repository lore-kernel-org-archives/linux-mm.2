Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DD54606A324
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 17:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=GBcU6b9g
Received: by kanga.kvack.org (Postfix)
	id E15826B06B7; Thu, 19 Nov 2026 12:04:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC6D26B06BB; Thu, 19 Nov 2026 12:04:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDC196B06BC; Thu, 19 Nov 2026 12:04:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F21F6B06B7
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:04:00 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 419531A0BD1
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:04:00 +0000 (UTC)
X-FDA: 85452491040.14.018D9D7
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	by imf07.hostedemail.com (Postfix) with ESMTP id 730C040010
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:03:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=GBcU6b9g;
	spf=pass (imf07.hostedemail.com: domain of 3_Cv_aggKCK8PgSQ+VXiVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--ardb.bounces.google.com designates 209.85.221.69 as permitted sender) smtp.mailfrom=3_Cv_aggKCK8PgSQ+VXiVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795107838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=obEqzr5P8jya1lv7nDl4lL8ve5JAV9a9vzMEN4ZFalw=;
	b=DFbV7N/0i8+DKGHAtYxT7hwRIrwkSFCqNXKRkMy5fePZrWIgoPdWshbEiriXZvnHWQCSOs
	QAGKFe2gs4spY99GdcGTVrED75/MfeoUxb2Dv7Y4MLpbk05jpTP1XgPu81pw82/u0OA3nC
	3JuRE31XCb6W8NHFBIJvxtfeAYtR/yQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795107838;
	b=bk8ieWFmeNJsvsQrmSc3khWiZRMI/zxE/wADdhhtJ7ZvfasX7PWtpvR4LMNqks19CLOAHo
	fW0Id3CsspEnpeLYLWApCFGDrTwe0lx6WYB2TeFb+TjC19VZBlhIrj3qA4KYKrdr3YNoFz
	fxjZmzJ9lSmewd9pQf1Z6K95aC00wIU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=GBcU6b9g;
	spf=pass (imf07.hostedemail.com: domain of 3_Cv_aggKCK8PgSQ+VXiVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--ardb.bounces.google.com designates 209.85.221.69 as permitted sender) smtp.mailfrom=3_Cv_aggKCK8PgSQ+VXiVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4a370217dcfso1986933f8f.1
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795107837; x=1795712637; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=obEqzr5P8jya1lv7nDl4lL8ve5JAV9a9vzMEN4ZFalw=;
        b=GBcU6b9gzdChkq6/vgoDE/CRKVj8WBv70Ovd8RHrZNeQllu9fyHef4DHsAwN9lX8uz
         don6pRhxF4LkTOlu0lpbxWY/W7ftrEGXT8qxgEchX3kOM/5y2KWH9iHCFRES1CmaJBCU
         K2+UqG6gb5F/TWOVpyhtpQWVdP0TOqpnsfvU1nj5+AigpFYozkWvnacpmV+PwhqTMXoU
         cCIc8jlmNIfVmMTTqvW60TbxtQR6ocEi7kUvePtYSEbJTS5p030f2NpLrPIbIOfkZkBt
         zQNXVbyuq8emCr+46wNCpVEyACM826HXd0CsDDe9flCZNGR8JiS/5qTh0o8At6J3h4Qm
         U7EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795107837; x=1795712637;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=obEqzr5P8jya1lv7nDl4lL8ve5JAV9a9vzMEN4ZFalw=;
        b=yTc2+GkrTrS50i5ZVQY1kG1Qgc9Im35cICv2bqpxEBl71gRmgzRA3ftLCTCWXhPBcZ
         kq4E82SmAb5YdCJlud97Sx3dj8Ll4LSkwLtP1awXkEn/QLtkdDucSmY4/uv5XiYiqXvT
         N69KS8qIQqjTWN2/OKI6WfDB0TiIpqFz04wkrt7UWmSJvcgqckiEH/2nKT+V6bElaXJP
         Xw6J9tVKJTAroZSO4YLvGvqo/5QV+o86f5iz64B6ETFGDpzEmzBh5u5rRbVQjhKQ4vQg
         llyum8NE444FLhDOjvo0qEgY/NmUJ9nc4Sh9VY7dLCmk8f+DZoqW8JRjhCu9J76aswTd
         keJA==
X-Gm-Message-State: APuU4Z+QxkRrmgoqWiIx9FO6cXoAlbfcsxgwe/CjpC8ngWtFSB9+Ae7Q
	2NH334Fbm3+MutcTnsv6mH7KvS/cpCO3L66/qpi5RDzkIMbaDU32lFUCJfqeTHxms2VJUCpdP6W
	XlDjYNI23oSF5mvGNU0sBOepUqyrAJQi3iAb1v+23070+vJijV0zkJNMwayu5R77Zvmf/awtKyn
	MbbkKwpHHAuPUiuXho4GFv
X-Received: from wruh18.prod.google.com ([2002:a5d:6892:0:b0:4a5:10f2:8d79])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2406:b0:4a6:a5f0:be41
 with SMTP id ffacd0b85a97d-4a6a5f0be8fmr12520096f8f.54.1795107836464; Thu, 19
 Nov 2026 09:03:56 -0800 (PST)
Date: Thu, 19 Nov 2026 18:03:54 +0100
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=5473; i=ardb@kernel.org;
 h=from:subject; bh=7fLi+eafcqOIBfwwWOAcxTlGP7o83tyVSdXLqYWQuG4=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeu/9i//lpl/l7xwL10+e9W3p2/PfzTNU4ssWPbAxm7WV
 N+NPLucO0pZGMS4GGTFFFkEZv99t/P0RKla51myMHNYmUCGMHBxCsBE2AsZ/go9keIJj5+kGyB9
 Oejeuk0LmSbVzzo826nqSmuFkfeKTdUM/73e738Zo8q90VfD9PTLaRY/epZGfpzlz/F13Zx17zb 8KGMCAA==
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261119170353.1835737-2-ardb+git@google.com>
Subject: [PATCH v2] alloc_tag: Use __ prefixed ELF section names
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-mm@kvack.org
Cc: Ard Biesheuvel <ardb@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 730C040010
X-Stat-Signature: j95k7dzhqpkbfx75z64u19ij179twqkj
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795107838-207877
X-HE-Meta: U2FsdGVkX1+b1zAZ2n5OCGcyOjmmAhiKHQ55LEk9n/UotCMz6fUtZLqeqcXhhzJmowbTSd/olyYP631VHZUxqIJR0orrfY4kwBsGgtaCdjsYFyBdjYIiorgWcWVRQVnYm4LGPswRW6CC3Lgtl2ITtnfD20MMCiz/tL8G7cGhwr7mppdyCoxxHmuW95Ofco9ovD/CFMyMWIVsKEQEminaYXUwLQbbUbF5n4tFu3oO6WEhdliv1Jjvo1K8u3BF+YkCkQe4YAcqHkrpOm5vaBRwreRxK3N+mXRupqw2FXqlI24fl1EkrTdhcEcbX2sto4k1twwt1v6BQ6vHekpcxXxTYq0vyMCahOmgtH0jcAngue3y3R5+fVpXvRJU9Ua7Pxw54P6/+8wLtDt2JFg8WSRbfitsLe5eqDNCYZVynt2Juqma4IG5e0wvJK+e2n69qoXpVxtrPzRy6LkbHdnTrp1E0rmCy7dVdjbyVLbdGTviFAxlOUhPn5RX7uUySc90cB1Fp216BD1FkX+nF33+8RGxMPW2Pqrx6LK1LxkaoRl+CE+AYgbT8NDRjyvA+OgqAd4LiTF4aUYyOa23qTi+NNje91xPfnDYFF0z5ugj9v6Z202yYejdGPYa44E3Ffevogy7BQuF6AXFDzSZRNKdgKzsIHs7AUxoQItAcaGTLTLAqvtrJ7PxmX4d/OWuvjWokxORRD+8edSW+B42mTjVXrhyTPtmsEx6LcZK6aPl0wwWejHEY+fbX+4a51Iw95o0BOyd8jr7AeaTVFdKByoM+uiB4LAIEnvlaaugVT4SpJSt8WTHfWzueVu7tIyhuuT1RsttwW2695Lz0d0Y+4SuLmkvQ+76+I/QXdSJzebZ/8xoS5OJVbpiGJRkwfkLrJ8Qq+ubkqGRxbahWA0WUMA6j28U/9KtPVH2UJoBkQELGPIw0+vq+KaY3PhZ8M8xm7GmBs2v+1MbqbB4vrSTX+PIgfM
 a+Wg4Il2
 6dPsGiDYB1qxWnoE9Z9xqnK3YTwqh2VnaWQwet2kG57NTEOLad/hh0bIdGehpYvbeWa1mrJJPLgdjEjkBVxmqmp180bkoSIjeani8GPPAEnSQmpB/7k6npL3w+qmQtZQ/1MQYRM7+i83pNvSF2K+B1dKoUVJ+YgYh3IEqzSEsBhutiLY4m3l/75CYN5iVdO8JobWYX9NT7mR0G09JGQ7dQYIFyFqlj1mIMf0M0wjGo6mNGx0gwLWLtFAB6FbJ4Kc9Ml9xjktVdcBHceC4842B+C73nnPwEsniulmvFsZ1KjcsUUMiT1IIU5mK8QvmuIlkjwhvN/aDoXZT6dWVRLzom6BAZJ4az2bTKK92ATtxTHUeTS+ZUGMEFsmiPb8x00rr4U5ck/ZkRhj8CVdVy2AclsxRXuVTirHuOxFf4ciBJUyVZwmunULiAR9wuvOMWlEZajRWtwGbVXCnkUXThsIVq2gXgYVH98O8WkUFoKl3Wh7HlNnId7boppfEmEjE1GADYc3I+huFzkyZf9F7rSKxkwOnO9O62RCbOT8nvYZf5HOQF1f99QqWrjAySqmPm1ZsIaIWATxbKkb/7lTA6o9HGImQwAOfAO9xC9E5spzVlJM5QLBJS3EJwRYsW1VA3S9++ONv
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

When section names start with . or __, this results in section names
that are correctly matched by the various pattern rules in the various
linker scripts across the tree.

Without any such leading delimiter, it may lead to spurious warnings
such as

  >> ld: warning: orphan section `.relaalloc_tags' from `init/main.o' being placed in section `.rela.dyn'
     ld: warning: dot moved backwards before `.rela.dyn'
     ld: .tmp_vmlinux1: section `.rela.dyn' can't be allocated in segment 1

Fix this by renaming the section to __alloc_tags. While at it, tweak the
headers so that the definition appears only a single time.

Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Hao Ge <hao.ge@linux.dev>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
v2: stringify NAME correctly in definition of SECTION_START()/_STOP()

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
index 82e2c3448dcf..cce88ded2b06 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -23,8 +23,8 @@
 
 #define ALLOCINFO_FILE_NAME		"allocinfo"
 #define MODULE_ALLOC_TAG_VMAP_SIZE	(100000UL * sizeof(struct alloc_tag))
-#define SECTION_START(NAME)		(CODETAG_SECTION_START_PREFIX NAME)
-#define SECTION_STOP(NAME)		(CODETAG_SECTION_STOP_PREFIX NAME)
+#define SECTION_START(NAME)		(CODETAG_SECTION_START_PREFIX __stringify(NAME))
+#define SECTION_STOP(NAME)		(CODETAG_SECTION_STOP_PREFIX __stringify(NAME))
 
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
2.56.1.708.g77570a6a1d-goog


