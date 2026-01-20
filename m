Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C402D2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 14:41:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8875C6B042F; Tue, 20 Jan 2026 09:41:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F92B6B0431; Tue, 20 Jan 2026 09:41:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69CE36B0432; Tue, 20 Jan 2026 09:41:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 500346B042F
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:41:41 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 10464D26D0
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 14:41:41 +0000 (UTC)
X-FDA: 84352606002.14.3EE6103
Received: from mail-43102.protonmail.ch (mail-43102.protonmail.ch [185.70.43.102])
	by imf16.hostedemail.com (Postfix) with ESMTP id 22B8C180007
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 14:41:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=IEOg9iUY;
	spf=pass (imf16.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.102 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768920099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eIIDTGQyCgm26nLjZu4KEA9Oyj/JLFsBgq7aIkvXEts=;
	b=zF8+aeJtxNlCMeBAhiVYcXAguSX/J8OmSq2OhJlXzkAffuGjLO++lmsKIfqvDIGdb5oBAT
	u3sQrsgMhgFtLXmSLxXdKtPHR9xLAcOOxhF7fTXoruq6Vf8CQBMaWDib2xpITUiSec8K5p
	vidsbnQr9MFz6UjfHVabQ7OCszJQ9Ug=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768920099; a=rsa-sha256;
	cv=none;
	b=LbH3tNqt3QA6SMl6BnULKKzJdD2RL4UIS8Lyhcdv95X0h49DPyqK9fqI/sPCi79MVn1BcM
	TfrmBoIpgmcLf6Zj1JYycVYOrJMNwRThtTzNoNZ7EqHTvuEjQaWvQQASvpT6vFaUVnL7vy
	snI+4BSCNRe74a/Uy/IQu4Fl0aa3HpQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=IEOg9iUY;
	spf=pass (imf16.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.102 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1768920096; x=1769179296;
	bh=eIIDTGQyCgm26nLjZu4KEA9Oyj/JLFsBgq7aIkvXEts=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=IEOg9iUYq2ZqJPYZWszBpyLy/b9vEZFXAJDJ+BWvQUqNbBX1r7uM5IsVv4ba23JlS
	 9V9/0hM1T2U9f5ZgugXGAu2S4IuOYL1s5+clpY9yVA6gh1rUW94kCUeT3IKbiw5Q4c
	 8wuo/6/AhRPm09tnnlVnObYYwrEGFKofl+IRbQ2lz6E8pCShcfxCNW5OhInCwmDJSB
	 M/Z1J3DzqnOTOdYHawRE5AohPbCZfAf/6mxBVgrYmzdzmLtlVwQoIYNOll7JiSAvET
	 Kf3i4f1W6MEkBH15Or+LcI1vKz1nlSClgprBowz7UCostb4SOOgUioT0oa6jHwbdJf
	 Zy/QTVAmfOY8Q==
Date: Tue, 20 Jan 2026 14:41:32 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v9 04/13] x86/kasan: Add arch specific kasan functions
Message-ID: <764ec564b29372fa7e8cd6cf3ba1f4cfac6ea1d0.1768845098.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1768845098.git.m.wieczorretman@pm.me>
References: <cover.1768845098.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 9d53fc9017bfe54371bdd75ce3f16f0f911acc40
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 22B8C180007
X-Rspam-User: 
X-Stat-Signature: 31srnmn6r87nzt5fpykehsas3ddn7zp8
X-HE-Tag: 1768920098-638411
X-HE-Meta: U2FsdGVkX1+KyIsQpAc2YgVCPqJGM1T8ZyxJz+wV5t5aW8lo8Vz9XwobntbFTLiB+3YV95xzb40cfBS3tClmFY75gyvZ261lLlaKxgYVOXV+nko6JkZPR9AD2/Yx9IYvajctXO7Tx2vKSIrPwSicaJb8sURoBKMjESTjMHZrvlvm6jL4ODmPAIv2ycATd42FaOqanT+6UY0l6Lo5xMMTLAmt4NGaNfNMrUEEsHapYfZjgKMD5F+1quoil+6FG7Pqt0cZD3fnW/6D/8G+SJ1hcM2i9WSUPD1wCd0h6o1ESkMJ6YIUL1mRbCfH5JKkMzttTLfLQxKa9Hv6yzt9xLpo0orCda+Fq8jT6QQD2KDoUM2aRqrxOU8yW3yyibUZ96Y2wC96i7+5w86g+J/Ov2gOY/j4ggOvA+yDaDxxVVrASwuoIusypdBc0IA/XesJ2Elc95hZBMuMYJcZsMgS3m/+Mlcl0bhksbRF8se9WTknqbhzKRc19r983VaIYpbsjzWP9BDKQ/8ErVsbksSRw9UxBgA3MsctWWOSJ9eAxpiIvZZu/0LvA4yBc+3zKqqymdI2tBrnU1PhIexmCTTdl8OTdKk5fPtawjWulXpxnBI21hEzv4/Haelg1al6JAVNRJn9rZDE5WN8vpG0LxxNutPu8Tdeo2oldKnWpcP4TrZIfkrRIS9RRYKwTxmRQddfVMSRrGRxBwrwfm8Ovm6W9T0P/8HGGT/hy2/7VsNOfa63AToUoTqCY2LcgxrHMoYbMsa72ob/yqcSydq+oR3X5OgH7rhpEWba9ID17XHYh1spNW6eCoFvnrWKWGUh5aZKKyP87hcfPKC4ol1gyh5pepauaHGINm/jb7fYkIILdiOCNvPbHob+ltMEPLjUAe6L8KMNEoB+GdZSs8XaumnsSj0IccuHNFfHgaKZ/d+Te0JKSeyLQDeL4H/CFYhAyy3VHiyxdYlRSNiUtRLWeODNirF
 qrMwTDGl
 1czZ3lWZ1IAwqUdzQd02fYibB9kQGCQcaYg0Fukibj8gfSLjyMNmeV9W/M4gssGJApKYv8wOZ9KQCC0h2v75FOjHv5fKwK/obHw7c9ZpTmMiyLwXcLePX82tuySh2W4JjFWSUui9UWxYPCNXFXWpaSS2HbVyQ8eYtqF/aiXz1P02wtHcaHSEDCGyeJiqKMA/cEcfsGzoQ61WUYDjNi3OvCLD6F0ibanowPGY3weVO2H08wP5XPb54a230bxvAJU744yuGhX8z46r1yzj6TuBuUngp4QGx+QFcpWVrKkrlL/NQpfBk+z9fpJ489GsEJZdIUoP+p2w5+X+iz7AOxJbRuX4XZCybKar2ut4PH3r2i2McIYI=
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
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
---
Changelog v9:
- Rename KASAN_TAG_BYTE_MASK to KASAN_TAG_BITS_MASK.
- Add Andrey Ryabinin's Reviewed-by tag.

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
index d7e33c7f096b..c868ae734f68 100644
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
+=09addr &=3D ~__tag_shifted(KASAN_TAG_BITS_MASK);
+=09addr |=3D __tag_shifted(tag & KASAN_TAG_BITS_MASK);
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
index ad5c11950233..36cc4f70674a 100644
--- a/include/linux/kasan-tags.h
+++ b/include/linux/kasan-tags.h
@@ -10,6 +10,8 @@
 #define KASAN_TAG_WIDTH=09=090
 #endif
=20
+#define KASAN_TAG_BITS_MASK=09((1UL << KASAN_TAG_WIDTH) - 1)
+
 #ifndef KASAN_TAG_KERNEL
 #define KASAN_TAG_KERNEL=090xFF /* native kernel pointers tag */
 #endif
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 75ef7c9f9307..631200332c45 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1177,7 +1177,7 @@ static inline bool zone_is_empty(const struct zone *z=
one)
 #define NODES_MASK=09=09((1UL << NODES_WIDTH) - 1)
 #define SECTIONS_MASK=09=09((1UL << SECTIONS_WIDTH) - 1)
 #define LAST_CPUPID_MASK=09((1UL << LAST_CPUPID_SHIFT) - 1)
-#define KASAN_TAG_MASK=09=09((1UL << KASAN_TAG_WIDTH) - 1)
+#define KASAN_TAG_MASK=09=09KASAN_TAG_BITS_MASK
 #define ZONEID_MASK=09=09((1UL << ZONEID_SHIFT) - 1)
=20
 static inline enum zone_type memdesc_zonenum(memdesc_flags_t flags)
--=20
2.52.0



