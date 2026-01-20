Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10D3DD2ED0F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 14:41:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78C536B042D; Tue, 20 Jan 2026 09:41:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 738D16B042F; Tue, 20 Jan 2026 09:41:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65C796B0430; Tue, 20 Jan 2026 09:41:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 545C76B042D
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:41:29 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C2068BBCE
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 14:41:29 +0000 (UTC)
X-FDA: 84352605498.20.BF2FEB3
Received: from mail-43102.protonmail.ch (mail-43102.protonmail.ch [185.70.43.102])
	by imf05.hostedemail.com (Postfix) with ESMTP id D7ABD10000B
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 14:41:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=fIMBnXKN;
	spf=pass (imf05.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.102 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768920087; a=rsa-sha256;
	cv=none;
	b=X2a2gZoUWFiUmQpMQgb253ag+01MQLXVc465Ktjzk3Sy1aax1hoNmoMqNsWDhhaX8E1Mpw
	h4ISu15gWdkSCI8+1/VveD8XuD4nwoSkG/yZ+bPKTH2rmEYXnUyRwn4RIJtEtkYHLBLWP5
	pOTvMD9GlaiRv5JId147YgeFCGDpS/E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=fIMBnXKN;
	spf=pass (imf05.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.102 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768920087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9hxw38OLLXdn+9VGuKWdisEOvAzjfmeUi2K/qt7IE/4=;
	b=ISgfF5ruRYjWmZ5yW59TwReANgQbR3yLLaEJDncHtWnqE+8BgxH1QA5pzavggxy/jaFlQ5
	8kIpQQBVl8T2OzN0FFW2bOXIVDfRKAAPxsAog/RgRjRsz8AnjV23T0W72WgOnn/khnP4PX
	pLBJszx1zHCPiOYbVp0xdbDRGnv1qR4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1768920083; x=1769179283;
	bh=9hxw38OLLXdn+9VGuKWdisEOvAzjfmeUi2K/qt7IE/4=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=fIMBnXKNEWgJNlYzHqlptxvPPr5+RkkBtofLIJf06eYD3LnW+z/3Jb2GE0hZAfYkc
	 Eh4eJ2XlmBQZvYe72eQEDI2J0wSgcnWATlU6yIsJ8M5Rs6zss2BRneUE+kik9xTsmM
	 eQ8hFj9rbRP/UEAqg1rjLe0N3dHJ8fhQb3cNTF8nUCyZrhyQ6VYmmfpmucEh3UVliR
	 yMZjJBVAo2KR7YkNNb2iQnJa4w4OBwQuEb3EH/AyYOq4PSYBtRg205Fbrw1OR0NDJX
	 8vTFuwfXaEiVP+hC5FXp3qOJgMc79EF2zSnn4tPgceBT1GX3A+Gsiomv05L0uODuAO
	 1INcQ/qSa7OiQ==
Date: Tue, 20 Jan 2026 14:41:19 +0000
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, Samuel Holland <samuel.holland@sifive.com>, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
Subject: [PATCH v9 02/13] kasan: arm64: x86: Make special tags arch specific
Message-ID: <2053362955d8b719b25d962c0bb1c5e56888f495.1768845098.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1768845098.git.m.wieczorretman@pm.me>
References: <cover.1768845098.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: ba4fa83822e36fe09ee7010abe018ce1287ac7fe
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D7ABD10000B
X-Stat-Signature: pgan5r4f5nuirpq3zntuw6fyj8bianei
X-Rspam-User: 
X-HE-Tag: 1768920086-554747
X-HE-Meta: U2FsdGVkX1++SdPsuNIrsd0RhK3khn0EPx9sMUrTrbH5Fqi7WAJuFYkVtWFu9SlKWvSWzZFRzWb9fvGmedjmGa0O2Kfa2eHZOu1dlvGYymppaEcKLO3BL3nPkW1cY9SAcEbjypDhxweYrvnrut7Fnb1RLS2RApggwP+qmcXoSVpETfKi4o5uPNKyVYIx6q68vBHBDMRLf9NEVcyRGVYp6QkhkBt0phGpKaHSd0GMg32nkSCcJgGzfks1JaRhWPAXAJzYlVVu+HepAOil5vIwEAcQzQOeljI0PDPjWWoXHh8h+W05Wam8DGcqywO9NyeH0bGvkAxX/dvMp6IJjaED5XNEMDNLLjEGnPRfS0f2yp8myPz6GZJAeGm8TSa9V6qwH9mRa5IPACJg/w/Gjy35NLlYVKuJ2no6HEQIFyJjRikuN8+VHcZL+HaxGX64BP/N5OTRwQGoAbFpqi0X+3XWXURNUDxSrMxo6ThgxRqpNuthAfadvL6lxG1cTVi4sVPvqRKotwOTPfOFZiU+msjEY7ulb4EujKFiK/VkzdmkKutcH+SXOXd2fiFyzHdnc4/gTkRz/Q7Nel1BxD47LRb6nBExaWpIyjGiCDZqOX3ppelDHbUMre/BilSZsKiwxFi5TJ1xk5No6+GW4GBlcGM94rUT9y74RtFCrToTV+CLOVkktaM1tvxkwluogHUuGhJcRtGQNzmD0Rn6S9nC29Jg0rwK2UopXi0AqgGquxBd/CramWl30mnnxIK/fnO8CIIzvLvL2YEUF1vros1nW2hgVnUeHaSnUGavv6Q8EjZWDVpsWiKwg01XsPpRcEKjFR599DHfkx8pPCLA9Tl6wB8i7SP8LgckPL80Mm+4IfRc9zsmAbuxpH/74+i7SPEsJHyZAyfzsPDuwlsyOu7IiAx1kQjbRm+/BSVZchldGH9VrjnZELQA3hNzkX4L1YGBBE5lr2NTF2u8jqpSMEM9bwm
 7PCiFDlR
 hxIGh4608F/uLM09aqsTIqUZNq4ucF1BJIhB98yN2E3imeYBKO/gR8eCvma5sx1l3dlXQr1u8zjwEYbn/OwiXrqw4QyJ+qh7XjLMmIgo53sL/3InjTc5U2AflaxGFyS8cOE5eFGRB51vgkOOBWNw6gDtxYWbDc0A1ubNahPDdJETnJVQXAQ5o+6sVka9dqcKpfJ4GO58ThNOQjFXJZGhqgThRUsNsm+Kbhgd6T32PScifxmx4ZAU847of1Tz66037SOTU79RW2x3JJpkt67jc68jgvu+OHlz9SLHFALu/Esii+NKnJ2quGY9MFiViVtkepnIBODlTrZHjQ4QbZYP3IyNz//J9ckN2/UFoytR2ZdSDL8VnyLhyrJVV5m5ePazINgkrEOyM4hnvoyu1+zKLE0R6fWVXvtBZPh9pAV04UcsAJQw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Samuel Holland <samuel.holland@sifive.com>

KASAN's tag-based mode defines multiple special tag values. They're
reserved for:
- Native kernel value. On arm64 it's 0xFF and it causes an early return
  in the tag checking function.
- Invalid value. 0xFE marks an area as freed / unallocated. It's also
  the value that is used to initialize regions of shadow memory.
- Min and max values. 0xFD is the highest value that can be randomly
  generated for a new tag. 0 is the minimal value with the exception of
  arm64's hardware mode where it is equal to 0xF0.

Metadata macro is also defined:
- Tag width equal to 8.

Tag-based mode on x86 is going to use 4 bit wide tags so all the above
values need to be changed accordingly.

Make tag width and native kernel tag arch specific for x86 and arm64.

Base the invalid tag value and the max value on the native kernel tag
since they follow the same pattern on both mentioned architectures.

Also generalize KASAN_SHADOW_INIT and 0xff used in various
page_kasan_tag* helpers.

Give KASAN_TAG_MIN the default value of zero, and move the special value
for hw_tags arm64 to its arch specific kasan-tags.h.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Co-developed-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Acked-by: Will Deacon <will@kernel.org> (for the arm part)
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
---
Changelog v9:
- Add Andrey Ryabinin's Reviewed-by tag.
- Add Andrey Konovalov's Reviewed-by tag.

Changelog v8:
- Add Will's Acked-by tag.

Changelog v7:
- Reorder defines of arm64 tag width to prevent redefinition warnings.
- Remove KASAN_TAG_MASK so it's only defined in mmzone.h (Andrey
  Konovalov)
- Merge the 'support tag widths less than 8 bits' with this patch since
  they do similar things and overwrite each other. (Alexander)

Changelog v6:
- Add hardware tags KASAN_TAG_WIDTH value to the arm64 arch file.
- Keep KASAN_TAG_MASK in the mmzone.h.
- Remove ifndef from KASAN_SHADOW_INIT.

Changelog v5:
- Move KASAN_TAG_MIN to the arm64 kasan-tags.h for the hardware KASAN
  mode case.

Changelog v4:
- Move KASAN_TAG_MASK to kasan-tags.h.

Changelog v2:
- Remove risc-v from the patch.

 MAINTAINERS                         |  2 +-
 arch/arm64/include/asm/kasan-tags.h | 14 ++++++++++++++
 arch/arm64/include/asm/kasan.h      |  2 --
 arch/arm64/include/asm/uaccess.h    |  1 +
 arch/x86/include/asm/kasan-tags.h   |  9 +++++++++
 include/linux/kasan-tags.h          | 19 ++++++++++++++-----
 include/linux/kasan.h               |  3 +--
 include/linux/mm.h                  |  6 +++---
 include/linux/page-flags-layout.h   |  9 +--------
 9 files changed, 44 insertions(+), 21 deletions(-)
 create mode 100644 arch/arm64/include/asm/kasan-tags.h
 create mode 100644 arch/x86/include/asm/kasan-tags.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 8e0e776b66a7..87c0f0e44f47 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13584,7 +13584,7 @@ L:=09kasan-dev@googlegroups.com
 S:=09Maintained
 B:=09https://bugzilla.kernel.org/buglist.cgi?component=3DSanitizers&produc=
t=3DMemory%20Management
 F:=09Documentation/dev-tools/kasan.rst
-F:=09arch/*/include/asm/*kasan.h
+F:=09arch/*/include/asm/*kasan*.h
 F:=09arch/*/mm/kasan*
 F:=09include/linux/kasan*.h
 F:=09lib/Kconfig.kasan
diff --git a/arch/arm64/include/asm/kasan-tags.h b/arch/arm64/include/asm/k=
asan-tags.h
new file mode 100644
index 000000000000..259952677443
--- /dev/null
+++ b/arch/arm64/include/asm/kasan-tags.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_KASAN_TAGS_H
+#define __ASM_KASAN_TAGS_H
+
+#define KASAN_TAG_KERNEL=090xFF /* native kernel pointers tag */
+
+#ifdef CONFIG_KASAN_HW_TAGS
+#define KASAN_TAG_MIN=09=090xF0 /* minimum value for random tags */
+#define KASAN_TAG_WIDTH=09=094
+#else
+#define KASAN_TAG_WIDTH=09=098
+#endif
+
+#endif /* ASM_KASAN_TAGS_H */
diff --git a/arch/arm64/include/asm/kasan.h b/arch/arm64/include/asm/kasan.=
h
index 42d8e3092835..ad10931ddae7 100644
--- a/arch/arm64/include/asm/kasan.h
+++ b/arch/arm64/include/asm/kasan.h
@@ -6,8 +6,6 @@
=20
 #include <linux/linkage.h>
 #include <asm/memory.h>
-#include <asm/mte-kasan.h>
-#include <asm/pgtable-types.h>
=20
 #define arch_kasan_set_tag(addr, tag)=09__tag_set(addr, tag)
 #define arch_kasan_reset_tag(addr)=09__tag_reset(addr)
diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uacc=
ess.h
index 6490930deef8..ccd41a39e3a1 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -22,6 +22,7 @@
 #include <asm/cpufeature.h>
 #include <asm/mmu.h>
 #include <asm/mte.h>
+#include <asm/mte-kasan.h>
 #include <asm/ptrace.h>
 #include <asm/memory.h>
 #include <asm/extable.h>
diff --git a/arch/x86/include/asm/kasan-tags.h b/arch/x86/include/asm/kasan=
-tags.h
new file mode 100644
index 000000000000..68ba385bc75c
--- /dev/null
+++ b/arch/x86/include/asm/kasan-tags.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_KASAN_TAGS_H
+#define __ASM_KASAN_TAGS_H
+
+#define KASAN_TAG_KERNEL=090xF /* native kernel pointers tag */
+
+#define KASAN_TAG_WIDTH=09=094
+
+#endif /* ASM_KASAN_TAGS_H */
diff --git a/include/linux/kasan-tags.h b/include/linux/kasan-tags.h
index 4f85f562512c..ad5c11950233 100644
--- a/include/linux/kasan-tags.h
+++ b/include/linux/kasan-tags.h
@@ -2,13 +2,22 @@
 #ifndef _LINUX_KASAN_TAGS_H
 #define _LINUX_KASAN_TAGS_H
=20
+#if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
+#include <asm/kasan-tags.h>
+#endif
+
+#ifndef KASAN_TAG_WIDTH
+#define KASAN_TAG_WIDTH=09=090
+#endif
+
+#ifndef KASAN_TAG_KERNEL
 #define KASAN_TAG_KERNEL=090xFF /* native kernel pointers tag */
-#define KASAN_TAG_INVALID=090xFE /* inaccessible memory tag */
-#define KASAN_TAG_MAX=09=090xFD /* maximum value for random tags */
+#endif
+
+#define KASAN_TAG_INVALID=09(KASAN_TAG_KERNEL - 1) /* inaccessible memory =
tag */
+#define KASAN_TAG_MAX=09=09(KASAN_TAG_KERNEL - 2) /* maximum value for ran=
dom tags */
=20
-#ifdef CONFIG_KASAN_HW_TAGS
-#define KASAN_TAG_MIN=09=090xF0 /* minimum value for random tags */
-#else
+#ifndef KASAN_TAG_MIN
 #define KASAN_TAG_MIN=09=090x00 /* minimum value for random tags */
 #endif
=20
diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 0f65e88cc3f6..1c7acdb5f297 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -40,8 +40,7 @@ typedef unsigned int __bitwise kasan_vmalloc_flags_t;
 /* Software KASAN implementations use shadow memory. */
=20
 #ifdef CONFIG_KASAN_SW_TAGS
-/* This matches KASAN_TAG_INVALID. */
-#define KASAN_SHADOW_INIT 0xFE
+#define KASAN_SHADOW_INIT KASAN_TAG_INVALID
 #else
 #define KASAN_SHADOW_INIT 0
 #endif
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6f959d8ca4b4..8ba91f38a794 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1949,7 +1949,7 @@ static inline u8 page_kasan_tag(const struct page *pa=
ge)
=20
 =09if (kasan_enabled()) {
 =09=09tag =3D (page->flags.f >> KASAN_TAG_PGSHIFT) & KASAN_TAG_MASK;
-=09=09tag ^=3D 0xff;
+=09=09tag ^=3D KASAN_TAG_KERNEL;
 =09}
=20
 =09return tag;
@@ -1962,7 +1962,7 @@ static inline void page_kasan_tag_set(struct page *pa=
ge, u8 tag)
 =09if (!kasan_enabled())
 =09=09return;
=20
-=09tag ^=3D 0xff;
+=09tag ^=3D KASAN_TAG_KERNEL;
 =09old_flags =3D READ_ONCE(page->flags.f);
 =09do {
 =09=09flags =3D old_flags;
@@ -1981,7 +1981,7 @@ static inline void page_kasan_tag_reset(struct page *=
page)
=20
 static inline u8 page_kasan_tag(const struct page *page)
 {
-=09return 0xff;
+=09return KASAN_TAG_KERNEL;
 }
=20
 static inline void page_kasan_tag_set(struct page *page, u8 tag) { }
diff --git a/include/linux/page-flags-layout.h b/include/linux/page-flags-l=
ayout.h
index 760006b1c480..b2cc4cb870e0 100644
--- a/include/linux/page-flags-layout.h
+++ b/include/linux/page-flags-layout.h
@@ -3,6 +3,7 @@
 #define PAGE_FLAGS_LAYOUT_H
=20
 #include <linux/numa.h>
+#include <linux/kasan-tags.h>
 #include <generated/bounds.h>
=20
 /*
@@ -72,14 +73,6 @@
 #define NODE_NOT_IN_PAGE_FLAGS=091
 #endif
=20
-#if defined(CONFIG_KASAN_SW_TAGS)
-#define KASAN_TAG_WIDTH 8
-#elif defined(CONFIG_KASAN_HW_TAGS)
-#define KASAN_TAG_WIDTH 4
-#else
-#define KASAN_TAG_WIDTH 0
-#endif
-
 #ifdef CONFIG_NUMA_BALANCING
 #define LAST__PID_SHIFT 8
 #define LAST__PID_MASK  ((1 << LAST__PID_SHIFT)-1)
--=20
2.52.0



