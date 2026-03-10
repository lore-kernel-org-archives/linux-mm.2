Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40577FD4F08
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 17:54:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7286F6B008A; Tue, 10 Mar 2026 13:54:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DCBF6B0092; Tue, 10 Mar 2026 13:54:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FBD36B0095; Tue, 10 Mar 2026 13:54:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3AFFD6B008A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:54:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E1B2E1602DB
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:54:03 +0000 (UTC)
X-FDA: 84530901966.26.A815526
Received: from mail-106121.protonmail.ch (mail-106121.protonmail.ch [79.135.106.121])
	by imf16.hostedemail.com (Postfix) with ESMTP id 04AB018000F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:54:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=P+XiKjo2;
	spf=pass (imf16.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.121 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773165242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GAJ+J+1XntmG0XcWACMTfZBywC1fG1kbT1ZPvAKl7/I=;
	b=KHauTHRpFBhXXD13MczS7bMW6jyAquOBYjjsnRjH/pdoD3iuVbMIWb2amIeIYcuCSkcbVG
	Q78vCN0gv0ceuU0j74xnYo10x4nRQb0Pyc8N4N9bZnK1r5UmiaD258j07N1BVcr1NesQtV
	8u6MzXGA004ThbXXOBy1fjK6FKSUaxg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773165242; a=rsa-sha256;
	cv=none;
	b=0raBD8kCkFXA3N+nbIN3HCH2H+3p52pUlhJiI8TG1ElYNBoqi1MGU1cv3O8/A+DZPwTuBt
	Jxs5auhWwhKNj7MKzkllzoqMUgq4uIJ3aUi/XHoCqXCZw1+ZxWZk40HBnCcIQoWjdU7ccf
	xpQYeyOiTIjT1a3KEXLnexyBzvgIR78=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=P+XiKjo2;
	spf=pass (imf16.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.121 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1773165239; x=1773424439;
	bh=GAJ+J+1XntmG0XcWACMTfZBywC1fG1kbT1ZPvAKl7/I=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=P+XiKjo2WDhinx0LrZhoCyEO9Xz+s6vrjf4PAP6BYgEFfhhXNGL4WxkqcfRL5LKQd
	 mRqR/n13Qr+TlRaDEPhsv8mhs8s/iECp5fYo4Xp38yrJa7pvqHKHYqP1bDdYRoRvWo
	 hnFlILtUZ982lBU4y/339wXeTtL1Lwzj9znt1VKRLyrhc0dfpQ7av2ya+WO/tIW/qh
	 xuXWGc7T+l0ECmd2r31w55ZhDRO8l+htirq7RNuBnsxn51eaMTCF6605eYD1apPZSZ
	 N5AV4HhxU3wF/5eh72gUxCVPvZxkw135q/Dcu5vwt1P3+uVM4u4CMLu0RmrzAkk/Rl
	 yclEgiNjw698w==
Date: Tue, 10 Mar 2026 17:53:55 +0000
To: akpm@linux-foundation.org, Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v11 04/15] x86/kasan: Add arch specific kasan functions
Message-ID: <61a7cecb9f498a565d87508e434ea1d7df9623f1.1773164688.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1773164688.git.m.wieczorretman@pm.me>
References: <cover.1773164688.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: e16ac0e855ec3772eef990d44995458f1f48bbd8
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5y6x5kgatfzu5barqjrzuh9ahid1skat
X-Rspam-User: 
X-Rspamd-Queue-Id: 04AB018000F
X-Rspamd-Server: rspam12
X-HE-Tag: 1773165241-53273
X-HE-Meta: U2FsdGVkX19dKs+wYIhN7rj7+/9/QJfNWq+ZyGhn0qMLy1o6v400UiXeW+rMbu0w91MYT6jg/4L8U2zhyKzZxXQlzHyf/E7YmuyvC1mptWAcD1HleLWe6ong+nLX+ofbbP/ZtDCzfaXnHTUghdxu2ucgI+gOSQna2LfXgxVwnOJRK2SEIf8Xw24oze/bauqr/DXFFUBE3PxKnWWo6NYHh2yPmJqA9BWrs2CJseK6zM1vilqSrZvHGGdmG0jMoPbWn2kxNr6RasC96T2fJIF5sQZufPennNmlB9z9SYbN9SE1i7BI52WXMAvub0DU7couEb3D5yW6iI4VPc/oa07FhHm0ElKKbL4yeSb6D/Degnz51o1BE6TfUY2kmJDUr0wC+cWtJpj/gUm/Dhg+yMSUysJaSNgVPEHZCbWRWlmqQwxwEvuK+5D/HgBwS/kiWA1qzxDsBZ0CoeEvaomve65ZTZNhKlC/gdzRSjCa/pvWHkyUZ1aY6thvYuZoSiwkTz2hUnWohwWzOs7hse0MUfjBDqzLS/AAV2XUqe3bNTWZwoC5/0hFvARMLjR+FQ4DbPeMrsim2o1DLbw0mbPZulJ6KMp1C4iFhKJO0stsfF2PhQ6wHHNo40ZvKudWUnolG941zljQLWUP0PT20GQ81uKxvaALFt7CgBUk+0YKq+9q01KY0SLExc17/4tZ16fuTnKoP/I2p8CroFKbIsGgk6xGgVkqpL9rFVPPR55KIH3DjChxvPdf0Ki1Ttb1nMiEv3rakYJi/OkdOCexTJWrlFm4+rdQl71Ht48+sM8YmvxSsWIyv6uquQIKITgjPtFdLVhE75jviKnz964rsKnobep9PZsosoOKZFhJjYNMibbeR0d6qiqn6naIOYg4pG9qrUSCAtJxsEuNfEKkr0ilNEqv9CMB/r5RZto5NEkrtSe0DC49Lod+8FwWA8MiOoMc/r5ozo+SWgaTmJXl3unaNj/
 ZjIqIQs/
 woCXgmta/u/ENqgHsPxS5rlSz6rZVY/g60K9+gvgWF6uNttzDUTAhqg817uEX1OmWu/TCqY3+M0OCGl+feM9ArZxH/orakblCvmou0ZHMnAJz+c45F+qyCsJHCANtsMmcg2LMCm1RjEfv5NfAJa3h2/P8/kaB6uKS963Dfa8St67F5BV4ypPrLT9d/Uc/JYKp2jDWCwTbQesNo2oNg6aVnH5abWWspKwcd4y26iWH5jMyWvUjKHpSvwPjmOxSgSPsTETh3zKBcdU/19Sal7FkHbXYGwC0VApsAPjr
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
index 7bd0134c241c..2bd4f9eb1ea7 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1269,7 +1269,7 @@ static inline bool zone_is_empty(const struct zone *z=
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



