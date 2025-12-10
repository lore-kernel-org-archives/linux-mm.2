Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 175AED3C933
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 17:28:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A2D96B0006; Wed, 10 Dec 2025 12:28:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77AED6B0008; Wed, 10 Dec 2025 12:28:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B72D6B000A; Wed, 10 Dec 2025 12:28:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5B1466B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 12:28:55 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 09068BA57B
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 17:28:55 +0000 (UTC)
X-FDA: 84204246630.07.BB6ACEC
Received: from mail-24416.protonmail.ch (mail-24416.protonmail.ch [109.224.244.16])
	by imf16.hostedemail.com (Postfix) with ESMTP id 278B2180010
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 17:28:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=XQg25V1L;
	spf=pass (imf16.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.16 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765387733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uKUcoWRGEpioVsYqfJYYUwDSXTCCDSTxDl6r47kG8IA=;
	b=tTddb60tcDAwdSFCA410z3fDxMcrY6xNt9nzx9ftrrs5OzfZMKZFHFB7vsCvpWvUV5A/pC
	ChS7CZWL15MtcyCkCwIHlH4u+qB9ZvbE5x1mGupE8aWJ4m3IiqbZYNPyQMuOb6UGvVrwq/
	gz2V5Z+AJT54JsudOxKCr2kdDmIa0Zg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=XQg25V1L;
	spf=pass (imf16.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.16 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765387733; a=rsa-sha256;
	cv=none;
	b=vF0CG3B6WfhYIkiv27qZP8WqnwX1y4xwuudGsKyr+Eqg+tHKjmubdeSP1mmjUCUrJBx/ZE
	njjlAKR0cVjBMHVoqqocdQbRkG0vpnixoDkI+Q7BHfZ/DlTkqcsoS/3qY+YYaA4ps7CYmt
	3jVA1UVspILcp9mN4ZatM2UU/8xhS6g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1765387730; x=1765646930;
	bh=uKUcoWRGEpioVsYqfJYYUwDSXTCCDSTxDl6r47kG8IA=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=XQg25V1LFYpvoYroj2dRRJCBZNsgxg7t/VnqW9cMbGn3CIxQENLETA/NkSkPKowp+
	 Xf0w0hIwjaW3WHYwCshE6mXEQiKDQPFMGlZuKa3PZV4VP/VYD1sN4y+CuEYhvGej9f
	 xydCpgdmxD0Aiqn8d7wOnX8WdVVA7jPIRxamZvSmn7Y9TtnWbVRvngZkZj2b4AtNkf
	 sKwHQggNmSA8qYPQaS8H4cOm3AtmH0DizAI7EYE2yQYrynpiE2HU6rK+lz8OZGPQBn
	 YOidNzDQ252kNJLRQHsxuLiv7DacGfaS3d3tz3CyROZ4Xe5H3tRmHSd5tA4sg1ELcx
	 /qcLFnPwCEGXA==
Date: Wed, 10 Dec 2025 17:28:43 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, Samuel Holland <samuel.holland@sifive.com>, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: [PATCH v7 02/15] kasan: arm64: x86: Make special tags arch specific
Message-ID: <0db7ec3b1a813b4d9e3aa8648b3c212166a248b7.1765386422.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1765386422.git.m.wieczorretman@pm.me>
References: <cover.1765386422.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: dcbf8ea52fee4f67b789474d9088b2f73bd5f9cb
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: xksupjwtbii4s7pyd648g7jubx51xhy6
X-Rspamd-Queue-Id: 278B2180010
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765387732-385521
X-HE-Meta: U2FsdGVkX1/hYdO7G9miCRLIUdsFmGRZbrElB4PK6xGoIIg9kZco6OOWMWiEeqEEFcFK2Ib9pmxc5TCU1P+NiRe5Sgeq0MOAobsUSIs7B9kJ62WyvoeI9QBJtCtzNXD7ig/vKOSRBb8QuZ5POpxrhpZLlANdJve3fcGaq1xYtbdu34ML3nToNasDvISefRFDq5amF3KsnmJQwjb+2RxHoup1XEV6xli7GXIBg734FqW5P6QL6vvaUx+eHYSSyCsM8Bh+33q4dkYumWg3ZoBS/zWFxhpcT5KlR7ORTmLOsJ2Bj8BL7Rj9XAEWT6K7fQPj6bnOWEdauBBjMQmxhUaylODE/fBZVU1u2pwazRkUdjcO4rsQFx9HSHkoK8h54308NXGXhjbMJyRM8xb6xdMtI6ci0ST08epzwLaeo0gs9rweWP5hUKWXKeA12pZ+uy1GeIAcWdbHOK+vRh9kIvksR3dympcpvu1G+OIER/RV59Dy2VXJ1nYc9JnG9wFe1wfPdslFLOEwy6G9RRmxZRG9SJnXRrmNFec11XAFM9cMu34KyKajztfL1zHzohdEF2PWGIzN6Tuno06cpdLzM7SXwBLtD4tBCzlCok519i/SRGAXYKsca5ZBfpjF1s6YPiHbZKKPObQlHPdgm4FJhTck+BDrNQecnqpG5jjLUG0s80N6+PjdZQQJnpId61V2ktbviVdEFv22wlKze0k9T5h1jp8YRSVjWuCeBqgPqUZDoAx13AIAaT8lXNqtgIncC7GrVhi6ZO4mATRrr6CcSATKH9WxzBXOAi+/CyrW9ciRNRDDTRYF4sh+XAMRCaZTvmEsMzGM9cwjqqbGNtupEkAfE+CmrUa9k8H19nf09EWjJ2owhZZhsmtuuns8QonkRE+42i85DzLe0X1b5CRPs8JTJW60IqY8KnjWEOlZpmhymyDTfckXayHkGVoqVfwdHYZMpw1L9m5H1RNjSlH3rk3
 pGQmOexX
 RtDVv4DJGAH+6iFMVNRlOVK5+t0tcZRPH/No2EqA3M1wJNX2SNXXQBkp7NINVoDYnx41J2lJVi8FSsqi459wSYjJ0VUTSEYtpprFVx/RcMMjVQ3CrlvQ6jV8JmUC+h7vSizes1xLlc5oXCDcpiQ24pNTktPvQ+E6e6yWOFl2lDrtsw8PZ8gKGFrQTCiBWdZnidf0JMadj08cP1OrzsH73IrPUUSP64p6kwWIklsjCN4rIMBUmsdAzWrC8UPq05RVoE8AAWaOqZSlmTwSYKMIrbtEQP6Crdt7F4lAdVQeOJdG1Hm3dVoyvpDkUlTS+3DHGOZSTGzNEuaCDky7StMu57196XKmBfTi/NLW2vPNupE3yxm79z8b5XYYdk0p7z9THFvwO3paXCRTQH//5AmNaD3sFctYP/cBfpKH4T8R0gdZGyCvkZvIm6jRLHQ5AStOTN6kEw4p08NIGhLXyn36uyeDBBQcXyCs5F05w
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
index 7bf6385efe04..a591598cc4b5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13420,7 +13420,7 @@ L:=09kasan-dev@googlegroups.com
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
index e1b57c13f8a4..d2841e0fb908 100644
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
index 670de5427c32..5cb21b90a2ec 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -39,8 +39,7 @@ typedef unsigned int __bitwise kasan_vmalloc_flags_t;
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
index 8e9268cf929e..b61090a80e3f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1762,7 +1762,7 @@ static inline u8 page_kasan_tag(const struct page *pa=
ge)
=20
 =09if (kasan_enabled()) {
 =09=09tag =3D (page->flags.f >> KASAN_TAG_PGSHIFT) & KASAN_TAG_MASK;
-=09=09tag ^=3D 0xff;
+=09=09tag ^=3D KASAN_TAG_KERNEL;
 =09}
=20
 =09return tag;
@@ -1775,7 +1775,7 @@ static inline void page_kasan_tag_set(struct page *pa=
ge, u8 tag)
 =09if (!kasan_enabled())
 =09=09return;
=20
-=09tag ^=3D 0xff;
+=09tag ^=3D KASAN_TAG_KERNEL;
 =09old_flags =3D READ_ONCE(page->flags.f);
 =09do {
 =09=09flags =3D old_flags;
@@ -1794,7 +1794,7 @@ static inline void page_kasan_tag_reset(struct page *=
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



