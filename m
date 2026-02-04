Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 779C2EA7940
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 19:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C53B06B0098; Wed,  4 Feb 2026 14:19:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3EC96B0099; Wed,  4 Feb 2026 14:19:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7EEA6B009B; Wed,  4 Feb 2026 14:19:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A73E76B0098
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 14:19:54 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A56158355
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 19:19:54 +0000 (UTC)
X-FDA: 84407739108.21.D2DF197
Received: from mail-244122.protonmail.ch (mail-244122.protonmail.ch [109.224.244.122])
	by imf25.hostedemail.com (Postfix) with ESMTP id 811FAA000F
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 19:19:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=PGOowp5R;
	spf=pass (imf25.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.122 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770232792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8q4FTnyJKL7VL66Fr0/i2+AcAlsSlxe0w17bfcxDbBw=;
	b=TQ7vgO0TetslcIwfdLLhqtbIuaHM/gvjHctjhADloRdyNZAJxTkUPKDlNkmeRcS+WxOqTW
	rhkVOK2DR/Y+dj/3HvEC/TSEOB1mL+k51tsU31XMgGC3xjWPFtuPs8IGeVfyk2aAIO1f/a
	OVCFswYMogoQoxfvglyENl/+iHVXsTE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=PGOowp5R;
	spf=pass (imf25.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.122 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770232792; a=rsa-sha256;
	cv=none;
	b=SSf4tF1FsBEiF0zeCub1TOf3WWHpoIEgsfFViEvY5eLefcYVC4eF5SMbBaatlmbDQP/j9a
	K78JVuuHvQUMOEPBDy9yaVGGOVm3mUMgyFP6ApbbW5t5PAJuqKcCtcFFz+vr6r6IzNnF7Y
	RzGj6guChpCseKayeuzrdAFa2i3rOOc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1770232790; x=1770491990;
	bh=8q4FTnyJKL7VL66Fr0/i2+AcAlsSlxe0w17bfcxDbBw=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=PGOowp5R7D7D1nm1AWYNfyiAzwMYE901S2kF3wzkkIcjTUWmYR3o9oIVzPk5VxS62
	 Hvzc2nMTA+NmRRx2zX8QleHZtEwfWVF5GhWO/Cmemrz1TqG/UkGUYB4QTc+Cx/A2lY
	 Oy6CGuqqnmcbcAG0H2iRgD0nbF8lyyUp01GO5Mxp/CN6/KjSw3pSjgkQ1M1KjdGKmY
	 16n6wMepcuWVH3MWl1Z/6IPuOb6LkpfJRfq6gIxhAY8n4Nk6qxFevNtj8B8gjZ1mIk
	 tUilgiuVbGRHbf+dX42Bf0TPfc3zIaS/SagH0xhQf/ib2KR721fi0nHddpzWgSWwCo
	 la8NULeSsAxrw==
Date: Wed, 04 Feb 2026 19:19:45 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v10 04/13] x86/kasan: Add arch specific kasan functions
Message-ID: <d58968c27836adbd0b4a067fe39edc4b973d4b4c.1770232424.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1770232424.git.m.wieczorretman@pm.me>
References: <cover.1770232424.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 144eb06d27a67966df17bfcfb2a55167d1a539cb
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qgwimoerjur89r7gcze6i9g3rjsjszh7
X-Rspamd-Queue-Id: 811FAA000F
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770232792-759510
X-HE-Meta: U2FsdGVkX1+KpvbB3cCKJgWKZVFhqmf1QjOJezFUGZFMRQMBxTkmcwZ62eSsO9QHACBjrOcZcwjkDH6KcS8yR+3yvMTg4VCt/T9Aqv81f0ig8srsCuNy+b8HP3LXB8C2kkcpMbr1iDMZO8Glv+6MZ84CfiPJm1qi0COkXhxmdhfSfBN50UioH/fsfW67ynwduUKXTzgHbUvDJbMSYf730qN/iDSQB9HyyhhQLvSF4Fnff/ApWMtVJy/636IgA2YFSU+eag05OiAsxNB5OLS1dQveuIyG32hOmP0y/INezram/eWWs/RA0/Wz36qQND3px+knS33OxzmRn3PSxwZK3sBQbTHUmKXVr+f99KZbGAqUDHeJqgDb5X5GUdIkP3h3UAdaBaYFTwmlNRsoyBBo1DRtuS1VgDErCdj6TA6BnKXIrIhgiSXm441gUkOX0uczfPtEacJDC7Q463oDwHJr9tRMTYDISQhmlpRERXv00a8Rqsj8+LEVmMLeUfOyWv36uin93SsQmRcF3s2QuoFiyVQKzJhTXOqmGYGabddsTHedW/Exexi/EFtRULku50XwAjyCkJjZUFWefqg6S5MNqMaz7AAtORsWbX83oZv3AUVub5aobosnNaCKRz3ZvAPGmuFD+efZG+C1NHOg+n7qI9EGWlgskzrAtJuhRmEviLqQ7NDj6q+hj8YKw6C+QQ1qWWONOxPGGwqZWPxA4T+3JBCY9b8nCFNlntXI44PXk9gz7wfJc6yUU9Sjy6QVimezuSzhjoEdV/wJ1bM1BipzdT/YaC1JdN0JNwUHB/FNwTvjoQYCBWkUy9mhkmqs/TbGTm+Ve+lHgWgfq10EmJqmP4D/SKxp5tnk0mPtHUcPyqsMYGp/r0W6qnTGgPYz9q7BEeBTSiOcqV1IXax2Z+5t6b/h04LyWrrPrxjgqLOwndGRjPPSsfxUpnupOkRC3dTbj53rrCgtACGyxjSxcvP
 rZkmPHCw
 EhZWDw0WscnwRxBNGvlbnIdz0yn22Pcn3lalhwCmyOMNsGcE8lCMRwEDvAp2f0YlUgf9WaWf/64fkCFn4HtU5pTy05UB/Mn+bcoHwKPyg706aIRp4DW/zTHwVKZFm81+bWZtf+SA2mEm5c9JzELJBGlrPzT91b7YRbKtiLxmDcrnV6rq0AdfbkQuqjgTnZSipP5LFnR+0jBRlxKTTulh8B5Gr1bGZ2GujQGB+W6tgUoT5/DHTytlr8tIB8lDM747r1wgrTfmvAsSbV/jRtHvQuG9fOukKIx3oQMq6FFcpsWDN01tjIvMRT+/AV4wEds4AtWxReZBHCLVh1HeZC82wod7ctqD26R8fJ4Dd9GeBoluY8NI=
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
index fc5d6c88d2f0..72c958cb6f3b 100644
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
2.53.0



