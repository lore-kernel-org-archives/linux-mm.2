Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 282D21061B00
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 14:33:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9582E6B0099; Mon, 30 Mar 2026 10:33:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92F096B009B; Mon, 30 Mar 2026 10:33:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86C7F6B009D; Mon, 30 Mar 2026 10:33:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77C966B0099
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:33:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4A05FC2554
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:33:41 +0000 (UTC)
X-FDA: 84602973042.17.688A2F4
Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	by imf23.hostedemail.com (Postfix) with ESMTP id 701C2140016
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:33:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="dupg4/Bi";
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf23.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.16 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774881219; a=rsa-sha256;
	cv=none;
	b=OnWqtla3plz5v1KNvJRlxQKAI8KR2OlyEcOkelzgjZTC0uxHlQeWWw2+c9NmGR6Bol3Es7
	FdTT7OgYpO4vzNftu7JPoCkj8EsIfF3duXFhHSwMEiLE5j4P7b69L6g1b+Dss4HeEE31Pw
	Og188U+0qYt4ZQkg0bTpQqvUvYUNjJ0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="dupg4/Bi";
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf23.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.16 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774881219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AInB1WLraGnVpbEFot6AYEw25ZN3HBhArAeFNl6DT0g=;
	b=xLwWm5pSa+2AqCpNnQV9DdT0mWXB5IcBsfygfPY2bMQsxAj2e4UTQn8is48OHbO0pezbVN
	6Ql5tDPv8o6krzS/1DQaM6PXfRLD8N6HA96zTK3T7Lp2ghefv5PyRuVMnY3suqmP0I90QA
	+HhJUnm7a/TbFrR5I1xCCGupkG/nF7Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1774881216; x=1775140416;
	bh=AInB1WLraGnVpbEFot6AYEw25ZN3HBhArAeFNl6DT0g=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=dupg4/BiGzfJ4BSGyBiX4+Li4qFJ8XZZ1DH2q/I0C7DlIDiMOYhEzWEAnkwaMxznQ
	 k9CRhqu2l44Qb1U8pgQgcuoOL/d4XuuH3LBXl1ApjoldI49K6d36jCtvKe+tQy4SUU
	 nm6Fy6KeGOOhVd1UbUZX1wdxvjKSJQh6jm/6QUOUYNirGo5d1hYVEkEMe6GKVolhQ+
	 U+O845xjsolSa29ASzgvKouJxHob9paLyL0s6RHRLDXTAibzb1k4CJw+T+3JgLmAAr
	 aj3qdw3ySL7uifKyVMlKreIcwhv82Djefo3Eo5I66Mp8KLTV68fRI0YtQ5w7r70nGo
	 tbv+Pxi/jXZ4Q==
Date: Mon, 30 Mar 2026 14:33:30 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v12 04/15] x86/kasan: Add arch specific kasan functions
Message-ID: <d8e62cde8ab244b9403a180e2df976016361f0b1.1774872838.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1774872838.git.m.wieczorretman@pm.me>
References: <cover.1774872838.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: f12ade9a7d415496909ab469ba49499df63371a3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: adm9o8149kg6cmhc4scatg1xcthzpwuy
X-Rspamd-Queue-Id: 701C2140016
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774881219-632403
X-HE-Meta: U2FsdGVkX1+HAWqGnxYYPb2rjuU5wBjHb/8Dg1SHOoAlhCyMOCnP2ZrLXFOhRsHFYlVooDsPpo/4i71Rk4sK/uHQlJU5Aea5OX/tSrhV4stdABWAcZsQJKRNoCqGfFaOXOTGDS/a3XZH+o3F3AN7zUeX1dUyN86HvuTKXejQjdyXH1h1aWgaNMB1bCC4H1FP035tn0k/dKdcfxCZqc9CodETA3FDSUu3bzDeo/S0ZDY2k61dazsKK8AlnuHC5f9dB+g4tOsGq73Vq1Y6dBLOeVP/AK4gz3FWJms9am7AkJ0V8wlhVXO16p5Rcq5W4Lj5AsVsp6xE9w9bQ9A9nZm29M14Hrh0QHw0Zlfcwu/mepEqsD4kznSvc76AuUMBmtIRJfdVwdE5PlttU+71FpvNHffn/Jo/UHwbxMjsbm+HHVZcHH7ZHPfjCs9Jh6W/6JXMrGEgNLtElWfkV9KSLh7iCJYblBvkV1q9AElxaTY+iE6xvzJJfrD2i10mn+uvvnAQpKaLBoqonredjnOagTDwXSQGZkl/kItxpPR7s7F8Vkee/Wrej32+zG1SVslD4kUKVR+tkH57igwsJkzkKJmBV8P/VUw6Q3C8Cl9M3YVSr7rA1CUx4nGvmfHsNVrle/XAczbx0WTM3f+jtaeUrw53Mo6VIE5CuO6Dx5uVJQjXhHoX8H2o2HwcjMAwOAzZ3sWOu29EEd+hYt6NdfgWRejgs6KGmQctg+6TvLyKrpNaBQJ5eYo07mgUdvHwSpHqS4TXsBZQ4sWpJA1XH2vrRN+ZuPGU8uHJWahOwTVnIsyRS2jpOhAN9+UrwqH/qqM7WjNQCT/3shDxl9L1uvoho3IravsuRa/DbYQn55IO9GfVh8D8hv222uJqHg==
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
index 7de42be81d4b..61df894ad105 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1266,7 +1266,7 @@ static inline bool zone_is_empty(const struct zone *z=
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
2.53.0



