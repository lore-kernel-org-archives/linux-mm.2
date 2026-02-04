Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE910EA7942
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 19:19:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CDCE6B0096; Wed,  4 Feb 2026 14:19:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 090EB6B0098; Wed,  4 Feb 2026 14:19:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBCBB6B0099; Wed,  4 Feb 2026 14:19:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC5A66B0096
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 14:19:39 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9981D138E6D
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 19:19:39 +0000 (UTC)
X-FDA: 84407738478.15.A971173
Received: from mail-106120.protonmail.ch (mail-106120.protonmail.ch [79.135.106.120])
	by imf22.hostedemail.com (Postfix) with ESMTP id B7F2EC0010
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 19:19:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="Hg+7dYS/";
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf22.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.120 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770232778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5O1b3FfR1Vp+0do34cNQaTZ7/jUxE68vpVVGzruC3Os=;
	b=Ows6Jsn1B2Aczh/kREy52IM5wwKyoQTBH8K5TcRLsMkg4oMuIO6xuN2W6O4UML1tJhh64Y
	7zhpUt7QM/D6Zj0UqEfHsRipKFZGBpu+IOVCQfSCuiNu7iodGn75JIFrLpx6DN3OwkvsM4
	DR2o4IeRiCBIQ7rM9lYHQvzZhUfwqps=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770232778; a=rsa-sha256;
	cv=none;
	b=Qlfg8XE4fSSZ+7pif15tQ5kU5C69vYwP5RbPrZ6KIuyLo1uYRp/MmYnKQWa2k3EClka4mY
	LoWKQGZUQPtwnkyfp853WRjzSZaUAxnPgP893VhLftHWfdDFfzpgj3HwQS9UXIrZCBIy0i
	Ragka2xNdzVOif8FPgw4EJs0i3ZxGeA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="Hg+7dYS/";
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf22.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.120 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1770232774; x=1770491974;
	bh=5O1b3FfR1Vp+0do34cNQaTZ7/jUxE68vpVVGzruC3Os=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=Hg+7dYS/2u7X3bM1eA4paCvWzimSdHWwbgXrKgioMbfMEf1Wpf8BY/+saHQoyZszt
	 bDHmPXCfeeQRtxjwPqbq2rHGBS2QgUAbxlZtketBG46xUYWdhRZDRVX+4uBmIqps99
	 FANUtjN7BJ2yDoh9GrhmKWTUxINp0uRMLZmF3YHrR3sZYyq0NtdKvj0kfm+onN+/s2
	 xrfNYD3AaEwDWFVBNIVQkMo8RrlurFpb8K766nA6RgJ7NwoHmfDAF08I4X1L6jNIeT
	 9oSzPWGQnlezLVtaDbP8A0gAnyH2m1Mb2eD3Uun6d5zeYvvRrrKEngZw6RCv47eZg/
	 6pcdxtvTEW1lg==
Date: Wed, 04 Feb 2026 19:19:27 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, Samuel Holland <samuel.holland@sifive.com>, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: [PATCH v10 02/13] kasan: arm64: x86: Make special tags arch specific
Message-ID: <2680630ab18d648422d3ce2775b76f8afa0d1e01.1770232424.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1770232424.git.m.wieczorretman@pm.me>
References: <cover.1770232424.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: e73d08e0b0321a8680dcd736a6f57b61ed147d52
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B7F2EC0010
X-Stat-Signature: sgo5t81igngnfk9awrkjsaaty6ftjpi5
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770232777-704544
X-HE-Meta: U2FsdGVkX192Chiw0N9MLitSxHGFHnAyve7xyFNd//wd33vwKna8wGsCoMykX68MPksz7bOY3nfUVzIDabtEAg4qKveVZ/jl5EhvYWQsc4LqA+I0/AzcYoVeabyPgGRbV8PkumqO4/7JuX9P12UN0bl3anNyAJX+gYGsqsGQd6OelwvKM1NEjmScAU5M9iUXbOasE29znPP/SSgkMRFe7rZBA4OANU6ZoZTKQbnC3eF2RMgtsL8jmCry5eiaHjmWZU+c/GGpqHtc8fvh6Pda/lef2ok/bZkA24CzgR9o2U2jtJFl/9F2rrudBNzxR/MDX5WjxsfNEBEiJbkKQ8HVsW5C+UXu/94NHLkax/Eoco7SKoDFPbELjnwFrrHW2iXuyZraMeQVedx4f++VItl3ilWwLqB+vSMy3rPVfEM7feCpjcQNi8ke4sLTZLYuifmtMde+0z42j42F5JZKD03w7CfCjLuZRo6dB7Xe8y1ffcgpB90GzaOzt+EzzK6iQmPaF/l36Y8TM67adw3vgZD/iSuCRQJAHBEkRESL2Tt0dQw7n+pD/HyZYj/4VjWPV79WqHEA7touY3pgkwSjEgUWUiGONJOxYbZD/A8SsasRQDPte66z6Y7HZ6Oj06CCTLGzn5TQfB2t7Nqfbyc18XjkpDdtHB0UXnEssPHeUkGe1bqyXCcRjjIyHs0rBnoNpQdmu47RWjliYRTwLBRxdW0WFOQRmQokw7eN6TO3JFOcqCfcKCojrKjDCYlSxNXlWsf5m9WaRMK5JgbNDE4Q2+r8G6vYVU5psmq8h9ci4z7xAIDrlFCpIZ/uQbn2pP/VgTsUzoq3Q4JvWpTPStjZFP7jW4qK9mhG+pPRoYrxHtkRMCUp5d0CMDlftIvmrB3OSLHtLPmh0AnsJgu/goLWGDmZMlra4iCG+JLFaA0Ux5jFppQqgsFX9G5DtGL0pDfpHiBmKDHaTSMzuCSgVfJGEwL
 sZz/riC+
 OGGFxm0UZs1DejMCPi1NHaTtizERtuCjewv5S3emMCTQSohDR0OwuzC/eRW2ihTtrv7jLNla5A6T+pokjF1KCcm90q1MvyuvkfpeDXAu88cONabBHKcMy/XHOormc9Col5+kVfBB6EVptvWALQKPkPDOSojY0x7meiUy6u3NISRYncx7pP6VsR81Zp9vifMAIPXDa3Dq8k3xpRvbX/X6ebSqWkUPF1CYNenOlpwnUEjtM68c3Hc8i8I2rXWvg/WeNUh6Ors0oxsjZ1KP5orPB/dtAvjot3PBUBkryWzIK7WBbZnb5p8/+8OBUcO3oQ/cbCzaQhKohVsYJC/vek+I/YpxMwCHyQvJrVfxl4leM1enCcHHITsqlqmgKDpazR3OqPiD6qjX3b98UVE7PHaDXwjBCrq+8yaBtRqasQCwpwxlRtTvtVJ5+GfQ2W5dLUHRS4h7IIqAK41nPLWThzPJuJ7x/XQ==
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
index bbcb5bf5e2c6..e27bdb0f100d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13586,7 +13586,7 @@ L:=09kasan-dev@googlegroups.com
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
index 81c83dcfcebe..c6febd1362e8 100644
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
index f0d5be9dc736..e424e68569a2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1953,7 +1953,7 @@ static inline u8 page_kasan_tag(const struct page *pa=
ge)
=20
 =09if (kasan_enabled()) {
 =09=09tag =3D (page->flags.f >> KASAN_TAG_PGSHIFT) & KASAN_TAG_MASK;
-=09=09tag ^=3D 0xff;
+=09=09tag ^=3D KASAN_TAG_KERNEL;
 =09}
=20
 =09return tag;
@@ -1966,7 +1966,7 @@ static inline void page_kasan_tag_set(struct page *pa=
ge, u8 tag)
 =09if (!kasan_enabled())
 =09=09return;
=20
-=09tag ^=3D 0xff;
+=09tag ^=3D KASAN_TAG_KERNEL;
 =09old_flags =3D READ_ONCE(page->flags.f);
 =09do {
 =09=09flags =3D old_flags;
@@ -1985,7 +1985,7 @@ static inline void page_kasan_tag_reset(struct page *=
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
2.53.0



