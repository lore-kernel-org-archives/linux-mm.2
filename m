Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 652CBCF45B2
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 17:27:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB8AA6B0088; Mon, 12 Jan 2026 12:27:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A638B6B0089; Mon, 12 Jan 2026 12:27:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 962C66B008C; Mon, 12 Jan 2026 12:27:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 86AE26B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:27:38 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 41D8D1608AB
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:27:38 +0000 (UTC)
X-FDA: 84323993796.23.CAB5316
Received: from mail-24418.protonmail.ch (mail-24418.protonmail.ch [109.224.244.18])
	by imf11.hostedemail.com (Postfix) with ESMTP id 891034000D
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:27:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=eXbCNbAs;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf11.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.18 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768238856; a=rsa-sha256;
	cv=none;
	b=SFtFruuw/iiCTnevkIUSPmuyoxhY2UThh+8egFDKWafJ46Q3xk09Bibz2WTmZKri0EnW7U
	jMCj+x77iCuQf7fv1nDhF2PWawRGopRNFW2DsqO0MQ3obxlsPBwvpsUPQKM8JCqqmiauoo
	YGc74h6AeTeQVXXrvUtsMXqdSq/VLws=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=eXbCNbAs;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf11.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.18 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768238856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zYoTsocZClxknlYhcC3iOmUo2Nj+iM7h4tlwilxbfpM=;
	b=66jnXyULxPWDH2lXLr1GnK5mW1Ce71oOSB55lXMySTW9+TNfMIXuuIAKRlr4bPmKLbyhyB
	mAnIl4FLIsnZ0XDo0cOGO2ZY5TUB6pVDobKvm9vh3ApfNu7uf/voYT/4DLQguxYKt3Fu2y
	TeP4fa/h4596FentewMc+nSi2gXhT6I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1768238854; x=1768498054;
	bh=zYoTsocZClxknlYhcC3iOmUo2Nj+iM7h4tlwilxbfpM=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=eXbCNbAsbfdTYUOtfEjPHxxoETutjpDCzmgl06KFlLBhrQyTYUDrn0FUs9KxtfbKd
	 uDE7RAxmPd5QBI7fTEI7OgST0f47TY0TpzWjEeMkG8A6t6IAY859VKl5dUnywazVdd
	 Qgkp0btL0PFZsvdFmoovITuaA48JC+uUMT7MhJnMwn+wC8er0Km7k1q+nrjOvip7Dk
	 jFQvYxmM3ktl+TbjWUiyVLWv0efEFyJCB9uSqL3FWiv+8AXnze84P9SbFazuEM2Zc4
	 j1Ij2f9MwDb8+CO6tjcyhSq9EtjyJOipI8TOVO1m8ItFKi7V6+xmyhYwceTCerIUBY
	 q7/L5u0H2Gt2g==
Date: Mon, 12 Jan 2026 17:27:29 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, Samuel Holland <samuel.holland@sifive.com>, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: [PATCH v8 02/14] kasan: arm64: x86: Make special tags arch specific
Message-ID: <be136bf8d1a6ae9ef98686c3ba0b6a4e2ea2e780.1768233085.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1768233085.git.m.wieczorretman@pm.me>
References: <cover.1768233085.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: f03de1003023037700aab2cb9b05c2dac6dc7c44
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 87bsei1dm1x5ow14yswr7urudybwn444
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 891034000D
X-HE-Tag: 1768238856-472409
X-HE-Meta: U2FsdGVkX19kM9WjJ7E84QM+PcNdgT88G3qouGFEU5VPKrFnm/VORkwB/vVR7VZh916eKXn57t9VZ6sPTzbgtkxpjPiCq2iH+/wLCjfVtF89fj4tPVA1BwC4pSfvUeUmDgp53lQR/7xGs8q6dGu7m0FBXYUaI7GAC3SitgWZxbdo9cfbP8B0FrXOPVHYWbQ+H+XsFRcBD1QRzcBWDFFzVYILM9cURFopxy5obnL+93BnLjz8kqBng4xNPLxMpFP4fDAQTow77Tjmo8ZivO2+NJrleuwiHnjwZaNH8Ffhk30Gmissk6EchyvUsFOGeS27bI9KnuzY9xJxMFivqXCcpJMnAoSBwWB6+8RkCL7LwqEorXuBrEfoStoq+2tJFQ2di0l3JrzttMf/5oCOk51hbLHlfCi87HFNoE+G/EmdL3fgWfsNyhTqOfc2qB5w7ulNZzeNW/gHZnbfWT04ya2A9N1h6NjpuIEtvp98BKS7eUwFUBn5miGx3mPTzY4Vssm82TJhPvTJgwt6V6FrxshKTAa/0tS89mTaUkQTBAhOcOjpCLo5Y3g/jX8v99dtDB0NlghK1J/lX8926JDpKy7eHCGCL0j7wHgc0ZZB2s+gfWZO4M6UhnomHpJcZdv2xlynzkdVjQWnD0yxSXaIwLuL5A7Q8GmDIMDVCOVEXzmg5/krh/u54qxrbs9vatjsNuvIOFdhVg1RwC7aQPmX11nbS1wIV/6VImyElhIdMxWy2T2h0Mj1EmYB6qSHtQK1r2oE7NqLO5v5q64BnwDzOYl8ueKtVjZVXJFJIUPzimtdmU4sugQMxxpebRHz5tE5FBdwaj4mMSTVLAqTrWg1ddbpZIA8YR1wZuTQmzzUaZP1MO3kIwokVYDcydrCoq7V9zfpKMNFysY3HX620KjchxqyIEs7IRcGPOkd
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
---
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
index 0d044a58cbfe..84fdf497a97c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13581,7 +13581,7 @@ L:=09kasan-dev@googlegroups.com
 S:=09Maintained
 B:=09https://bugzilla.kernel.org/buglist.cgi?component=3DSanitizers&produc=
t=3DMemory%20Management
 F:=09Documentation/dev-tools/kasan.rst
-F:=09arch/*/include/asm/*kasan.h
+F:=09arch/*/include/asm/*kasan*.h
 F:=09arch/*/mm/kasan_init*
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
index b167e9d3da91..fd4a8557d736 100644
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



