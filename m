Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5823C1061B00
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 14:33:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C165B6B0096; Mon, 30 Mar 2026 10:33:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEE0C6B0098; Mon, 30 Mar 2026 10:33:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2B0C6B0099; Mon, 30 Mar 2026 10:33:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A3C266B0096
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:33:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 137885B7C9
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:33:25 +0000 (UTC)
X-FDA: 84602972370.26.4E7CE8E
Received: from mail-24416.protonmail.ch (mail-24416.protonmail.ch [109.224.244.16])
	by imf17.hostedemail.com (Postfix) with ESMTP id 48B3440008
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:33:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=CRGzF8JZ;
	spf=pass (imf17.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.16 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774881203; a=rsa-sha256;
	cv=none;
	b=zjnh+9e04vuvDt+2zg2QOEOtOqjiRorZqXLNpa8U4mnLJMH74ukp/CKBPOUtK5TKmuxSNg
	8kyn6XfPyfMgjCpgRPhFx1S/JIKIrhEHNxOq7fh6CNnpH9F6tJYWIqgb6WvKCkOUYBmgE/
	GJBr/6FSK77wpw0Cb+cLMV+Xc4QaZms=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774881203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C6RPAE+IMjAOmkl7tc8DZi3umBRg/ZmgJ/efKnqWEoc=;
	b=CfJXP5e25QjZaGev+vxEnN8FrL63ihJOC3t1j0MRn71X8CBMWIu/YveO9g7y59JkY/Wi3j
	FrdyppOIjG8eUaotquwU8ePziltzZYZLOFxDFS0l8Ih+Wum3xTKFELyltqugcoAYf5zOH3
	Uhsvww9cOO6hvT/FfkKpJBviLIWU4A8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=CRGzF8JZ;
	spf=pass (imf17.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.16 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1774881200; x=1775140400;
	bh=C6RPAE+IMjAOmkl7tc8DZi3umBRg/ZmgJ/efKnqWEoc=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=CRGzF8JZycNd3OpbKU8omrgqB8xu8NCxoq5VTplJozAziqnZGGS9uVmkE6/WhDVjb
	 55FDa21vBc1qB9w2GttFaUQ/hAvhTU4vFtugCVBsn/WmQEtl7O7yljs093gv0ys55s
	 1tTUUnRVHu1P6ae3QIi70DA1P+vlUbyyHIaw44q+0Tdl7nsXMSLFALYMk5SjQ38bYq
	 HiHi2/QOTkQzHpkgS1rvrniaVt6dJYZcsDx1xIQmNUmb1BHHlqdEHGWfhVHX43iqL+
	 f+/7APqDjR8ZMqsReRqYKgxLCO75ehGM3Sfl1efLuitfGo5EfnZui9o6PchOP5Uh1V
	 YhqGrbAtNT2rg==
Date: Mon, 30 Mar 2026 14:33:16 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, Samuel Holland <samuel.holland@sifive.com>, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: [PATCH v12 02/15] kasan: arm64: x86: Make special tags arch specific
Message-ID: <6080be7964fc726327186d5bf7979e16ddd282bb.1774872838.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1774872838.git.m.wieczorretman@pm.me>
References: <cover.1774872838.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 0ce3648d813dbd335bc37a151748b3b43270f6c0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 48B3440008
X-Stat-Signature: a6ry3jmjgccj7tmt66sgm6jxi1wo6nai
X-HE-Tag: 1774881203-328867
X-HE-Meta: U2FsdGVkX18lGf4SFuDX156Ge/rQlGPZKTbzGlEGx8KLh5hk3YQ+tSn+0sZM7ZkwvORgqLp5XQ0mZ3Xa6iKekiUfl9vT0/VipyijN9inwuf6jRPxnh7jwdDEEUOAA1SJsIXD8XtG8uDJnnn8F996Ls23RVmqkN1oUb66CuSiV+qmdYesiwq2DHbge9GunCQPgxxeKYujqt1SRCT09rzw3Iq7jiEB9mAY/Zs/mZzP4c4fzGLkRxpLQd4H/mlFRY5duOlezzJYVgFPLhNR5mvbSfXnpHPlZROXLxkZ6ifYaqw8hkKc9/cvh/6dMBZp6ye0y0unKmHi2QdvLAn8ME3aexqgraXPhv2Tgjkno9ZUXF55vESDu5GCbrHlMcnTSvcc0JFTCu9XIVdby/p4yM1ILNNfSMpat7tFmuf+QE1j3pGNPw8YxDaDeg/fe8iZgVfsJ9hL/gokanE1EQLIHRcabaCwDOy0kVtfdo6udwMmXW12qlQmg/F3Z23MUhzWT4QH375FpjcEDtYJQPDIeAvVtiWzeJUMj6EYtMQgzJFLvmxo0mUuu2hK7C06zWRV6SeNDE6Oya7V8CrDqVwgVyas4lDe9hfNhEsAY0bsa+RdoCcwEkLWy1SDJjvfsRnGb896nmWkTKugKVJMVaKEshyPEpDqOvAsFrAzFh1EG95a9l/UwJdCMo51jWXTemkauEPndAk9Ozq5G/043BuED5/BItu/NOdlzPOXBpOqrnIdSEcZnqe4uXm6ElIAQDA6cMUK531Diigtvi8BjNbxcdT6AHjQZZU2dqj8abOEeNWPp1VCWKxona4FzJpp/YeMTqGgyJrPFW3gu2IaUykynagDKqJPcR4pX0UjQnwDSuYJdUstQ45YOhSy0Fge3IP6Qy7DdOlCy1f810S7J+NEHgCCFThfi8CxcSc7
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
index 16874c32e288..897210732d30 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13735,7 +13735,7 @@ L:=09kasan-dev@googlegroups.com
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
index 9810106a3f66..5465bc97ccdd 100644
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
index fbff1b759c85..e18908f3ad6e 100644
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
index 633bbf9a184a..09044934dda8 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2440,7 +2440,7 @@ static inline u8 page_kasan_tag(const struct page *pa=
ge)
=20
 =09if (kasan_enabled()) {
 =09=09tag =3D (page->flags.f >> KASAN_TAG_PGSHIFT) & KASAN_TAG_MASK;
-=09=09tag ^=3D 0xff;
+=09=09tag ^=3D KASAN_TAG_KERNEL;
 =09}
=20
 =09return tag;
@@ -2453,7 +2453,7 @@ static inline void page_kasan_tag_set(struct page *pa=
ge, u8 tag)
 =09if (!kasan_enabled())
 =09=09return;
=20
-=09tag ^=3D 0xff;
+=09tag ^=3D KASAN_TAG_KERNEL;
 =09old_flags =3D READ_ONCE(page->flags.f);
 =09do {
 =09=09flags =3D old_flags;
@@ -2472,7 +2472,7 @@ static inline void page_kasan_tag_reset(struct page *=
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



