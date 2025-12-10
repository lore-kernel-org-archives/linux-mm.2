Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 446F5D3C928
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 17:29:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 707C96B0007; Wed, 10 Dec 2025 12:29:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DF716B000A; Wed, 10 Dec 2025 12:29:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61BDE6B000C; Wed, 10 Dec 2025 12:29:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A4336B0007
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 12:29:16 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D190059E5D
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 17:29:15 +0000 (UTC)
X-FDA: 84204247470.18.F33679D
Received: from mail-10630.protonmail.ch (mail-10630.protonmail.ch [79.135.106.30])
	by imf18.hostedemail.com (Postfix) with ESMTP id E03DC1C0016
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 17:29:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=ekLjSZAu;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf18.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.30 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765387754; a=rsa-sha256;
	cv=none;
	b=Bik6/4minl81wiGv4ozUpE3DeQQqJIO8XlNB0kD2UuNFU1bRXi6SFaAs5WMuk0Zw4DjVmS
	pLM+xrdgPNxcSMrMKUhWByxCFBZT3LqPaXJFI8vrYdR32dCh8j5GnH86WRMAMoz2Rho/LZ
	kHLeBGNQ1oJUFJ5G/jyFfI5QkuSZL2Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=ekLjSZAu;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf18.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.30 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765387754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FfChR2RkA9EYwmqKbBDmes/ZKIT7Eu4BfGwYt0WPyRQ=;
	b=5SNHFnTe79A9WROkO7YnPPUgU6gnT8g0Sv/V1OEfRI7QWsimPkGNna/W66ictbZTPq0oJm
	l/3dtbTtdoZ6XD5mBKfHPQPqs9aPJZCK4y1Lr51+ZjSHS7N0OCwFBcTTw2CaWCAg+J6HMR
	eM0HbA+JpWvBxeO4Lqsp/uGjdU84i/g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1765387751; x=1765646951;
	bh=FfChR2RkA9EYwmqKbBDmes/ZKIT7Eu4BfGwYt0WPyRQ=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=ekLjSZAuJKh1V6Q/ncfaqcknUCY3uBaE8bKGLCG9M8NbGmtUvK0fZ/zI9RlORxRlr
	 XiK4UvFAIt2y5TROTEKt3H0Ec6tGx6V5K7cKF/Obux1nHRin6B39dUY+y8rxMBe/Yr
	 aXobeX0WJXT3q5720HHN+nbv8qt+dMnCjWPDRW4QJE78SZIpvyBqo37u+S9EftUs66
	 z8tTm+LQGWP8gIr8BojV2bS1jjFwbkLLO26Za3/t47J9zO68XR4REjZZeneyO7SY9D
	 XZyDMPhHYDrUI8y3C+owji97rppXuw8qmjOR6DB5MnpO2TSolmZqcPom3XogyZ5yz+
	 pFhiaYS6f53Uw==
Date: Wed, 10 Dec 2025 17:29:03 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v7 04/15] x86/kasan: Add arch specific kasan functions
Message-ID: <406416dea492be82578c2cf4ee70e45d98200081.1765386422.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1765386422.git.m.wieczorretman@pm.me>
References: <cover.1765386422.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 5a34045bd28f1283c14c644ca9f08dc44d52c0f8
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: zodgq53gxjs7ibpepbw58tinhbp3j59f
X-Rspam-User: 
X-Rspamd-Queue-Id: E03DC1C0016
X-Rspamd-Server: rspam01
X-HE-Tag: 1765387753-537799
X-HE-Meta: U2FsdGVkX19kzOaZdAq4PctqFp4U3hOWuf9WIkhiBN0MAaHTLrTnNxenQRW0zBHdmzMoC+PN/BuRdrviTeJVwaG4bbv0YiUHtOslUzk7uGbhdRzsmqiFHQP0MAEZm1hTK//GP8skR1o8HhwCv/9PTWBti1WFivszSuFDG/faYvDjUMTYCGrQDlfZb62rUay4I5mgzqwS5vpi6NAbSXiq3E9wYqtKT86N7U3i0usAOyxrISKeoH80ZVG4mIEYJsKX8Q2XzNfTC54gHh+Tv1YLmP+Ol54HMHSNuFkoLX+DrVDkGletjHb6bRTdVY++94gGg1ODpYgmBEs7dCDn4jlsgbogMRmHBXhCyGDE/PPspKR1R+YwTudJR7rnbZx1rx1i73iRmDsktTRcqPB2YdqAF7bBrcYOYGQJZ0SF0yZ3WYiVldokJdRQBNy2cHKpIGp1rhATdFR2m0l4j9TacjBcX7luQMMHoUiWWstKjt/ePTdPIAOdcjw0rQ0F/lsUmI4la7ghQ6Cu8/6JSc1MjPGelqXpdKIn4hUYBvW9BL0Z6UO50qDLgalihQAtSVm5xPGdaA/qPzD+WNwq3y5GjazbwUxTG5ArjJ5xAsvwXgisTrfxMEtmPKv5SlFffm9G0Yodf9577CFidMgQ6qUsl6EmPNRYPW5mPUQ4QZD61tuU2cKzN4RAiMx83VrWbQ1GIr1aIzPYROSyyXeY736Q1M4JX3JzxH148Lo8nJrBjUqk+TGkmZ9CdBbLGpSpHC5MVw9WDS/64zqR7HklFrAeP+oJAuDoScRK9f5gJQchfGobiAHtrOIxMUUCIhqaPCWMo4sbdqoKcgQuC4dJ1yLFSlfBlCi/4qRn5ci990yZppJCmXFQXh8a4Ph5M5iYVtclLS/rFr0qyEsAI/gci+cjZ9aRzSJIiU1qhsqwEpK8pvHxVSLtttHSxPziTynZJQ65kF7q4tlNmEFoVqC9/iIWWKS
 /rxBhHIA
 hHdEGoPqdhk36LE096GNa/CUHKKSYoAwFjf9xFvVCnO4enG7aQsGEBYSUjfCe1GaxOMdB9rjrl5sL2z4LJmVjqPiVFFeuTdiHx0XEe5id09/i52hjN5f0IeqPLe4/IwMHt/q0J+ebVL7U9TPNlJEcXXBjqWhPFaFxVr0HbNybtZcjs+g1pA38jrEgC5o/2qT37h7Q5cdNISSZJc4fZQccXwYOxbDM6SmqghHjUNblrtBST645XDXnvJsRmy96KEH6xpFwKr9OQ4zB8q2HXytwO4k0XlCJMoohEz3/5voBS8TddNSI0Xz4K9tosKVNFIieD8Nt4obP3IODpSzEJ5/YO1iC1Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

KASAN's software tag-based mode needs multiple macros/functions to
handle tag and pointer interactions - to set, retrieve and reset tags
from the top bits of a pointer.

Mimic functions currently used by arm64 but change the tag's position to
bits [60:57] in the pointer.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v7:
- Add KASAN_TAG_BYTE_MASK to avoid circular includes and avoid removing
  KASAN_TAG_MASK from mmzone.h.
- Remove Andrey's Acked-by tag.

Changelog v6:
- Remove empty line after ifdef CONFIG_KASAN_SW_TAGS
- Add ifdef 64 bit to avoid problems in vdso32.
- Add Andrey's Acked-by tag.

Changelog v4:
- Rewrite __tag_set() without pointless casts and make it more readable.

Changelog v3:
- Reorder functions so that __tag_*() etc are above the
  arch_kasan_*() ones.
- Remove CONFIG_KASAN condition from __tag_set()

 arch/x86/include/asm/kasan.h | 42 ++++++++++++++++++++++++++++++++++--
 include/linux/kasan-tags.h   |  2 ++
 include/linux/mmzone.h       |  2 +-
 3 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kasan.h b/arch/x86/include/asm/kasan.h
index d7e33c7f096b..eab12527ed7f 100644
--- a/arch/x86/include/asm/kasan.h
+++ b/arch/x86/include/asm/kasan.h
@@ -3,6 +3,8 @@
 #define _ASM_X86_KASAN_H
=20
 #include <linux/const.h>
+#include <linux/kasan-tags.h>
+#include <linux/types.h>
 #define KASAN_SHADOW_OFFSET _AC(CONFIG_KASAN_SHADOW_OFFSET, UL)
 #define KASAN_SHADOW_SCALE_SHIFT 3
=20
@@ -24,8 +26,43 @@
 =09=09=09=09=09=09  KASAN_SHADOW_SCALE_SHIFT)))
=20
 #ifndef __ASSEMBLER__
+#include <linux/bitops.h>
+#include <linux/bitfield.h>
+#include <linux/bits.h>
+
+#ifdef CONFIG_KASAN_SW_TAGS
+#define __tag_shifted(tag)=09=09FIELD_PREP(GENMASK_ULL(60, 57), tag)
+#define __tag_reset(addr)=09=09(sign_extend64((u64)(addr), 56))
+#define __tag_get(addr)=09=09=09((u8)FIELD_GET(GENMASK_ULL(60, 57), (u64)a=
ddr))
+#else
+#define __tag_shifted(tag)=09=090UL
+#define __tag_reset(addr)=09=09(addr)
+#define __tag_get(addr)=09=09=090
+#endif /* CONFIG_KASAN_SW_TAGS */
+
+#ifdef CONFIG_64BIT
+static inline void *__tag_set(const void *__addr, u8 tag)
+{
+=09u64 addr =3D (u64)__addr;
+
+=09addr &=3D ~__tag_shifted(KASAN_TAG_BYTE_MASK);
+=09addr |=3D __tag_shifted(tag & KASAN_TAG_BYTE_MASK);
+
+=09return (void *)addr;
+}
+#else
+static inline void *__tag_set(void *__addr, u8 tag)
+{
+=09return __addr;
+}
+#endif
+
+#define arch_kasan_set_tag(addr, tag)=09__tag_set(addr, tag)
+#define arch_kasan_reset_tag(addr)=09__tag_reset(addr)
+#define arch_kasan_get_tag(addr)=09__tag_get(addr)
=20
 #ifdef CONFIG_KASAN
+
 void __init kasan_early_init(void);
 void __init kasan_init(void);
 void __init kasan_populate_shadow_for_vaddr(void *va, size_t size, int nid=
);
@@ -34,8 +71,9 @@ static inline void kasan_early_init(void) { }
 static inline void kasan_init(void) { }
 static inline void kasan_populate_shadow_for_vaddr(void *va, size_t size,
 =09=09=09=09=09=09   int nid) { }
-#endif
=20
-#endif
+#endif /* CONFIG_KASAN */
+
+#endif /* __ASSEMBLER__ */
=20
 #endif
diff --git a/include/linux/kasan-tags.h b/include/linux/kasan-tags.h
index ad5c11950233..e4f26bec3673 100644
--- a/include/linux/kasan-tags.h
+++ b/include/linux/kasan-tags.h
@@ -10,6 +10,8 @@
 #define KASAN_TAG_WIDTH=09=090
 #endif
=20
+#define KASAN_TAG_BYTE_MASK=09((1UL << KASAN_TAG_WIDTH) - 1)
+
 #ifndef KASAN_TAG_KERNEL
 #define KASAN_TAG_KERNEL=090xFF /* native kernel pointers tag */
 #endif
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 7fb7331c5725..aa35f8331a4b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1181,7 +1181,7 @@ static inline bool zone_is_empty(const struct zone *z=
one)
 #define NODES_MASK=09=09((1UL << NODES_WIDTH) - 1)
 #define SECTIONS_MASK=09=09((1UL << SECTIONS_WIDTH) - 1)
 #define LAST_CPUPID_MASK=09((1UL << LAST_CPUPID_SHIFT) - 1)
-#define KASAN_TAG_MASK=09=09((1UL << KASAN_TAG_WIDTH) - 1)
+#define KASAN_TAG_MASK=09=09KASAN_TAG_BYTE_MASK
 #define ZONEID_MASK=09=09((1UL << ZONEID_SHIFT) - 1)
=20
 static inline enum zone_type memdesc_zonenum(memdesc_flags_t flags)
--=20
2.52.0



