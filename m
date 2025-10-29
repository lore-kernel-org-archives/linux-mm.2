Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB220CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 19:07:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44DC28E00D8; Wed, 29 Oct 2025 15:07:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4249B8E00B2; Wed, 29 Oct 2025 15:07:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 361FF8E00D8; Wed, 29 Oct 2025 15:07:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 238B38E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:07:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E786413BE4F
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:07:30 +0000 (UTC)
X-FDA: 84052085460.24.3B7CEB4
Received: from mail-24417.protonmail.ch (mail-24417.protonmail.ch [109.224.244.17])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0150D140008
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:07:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=kVBnL3t8;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf26.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.17 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761764849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lbXAxn7Fr4Nsk0Pj0RuqXVl7zH+aG4MTOYlJmhasqg0=;
	b=cnOrzluU+1BuEPS/Ctiu5Sn1Fit8KvK35PEatC9/Whawxf7q55mX9Pqk1nd8WRIdvvXmtH
	8xytAV4FQ3barpUoVaLJxFIvU8Xy3gq88Wdg2KYma13chLpPDuHWzeA3FHM/rBh2KEwi9S
	T1Zhv5SYYpBQ0+MhKXwzg/O8qJpxs94=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761764849; a=rsa-sha256;
	cv=none;
	b=Dg6YltcoXPRO0JhrlGKX05n8gvgn2X8YerZ/tKnOrHz5qkpK13l3DHrn/1RLfSyNQgQNiB
	ztLuXE26EjEc+/GN2MSInpVljnf1CoGUkForCT1nTPeKaOeevQHQXJc5z1EuSm8ZWZfTl7
	Ch8XJd/ck/gSKPA/bRBhbqwGDt7P/GA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=kVBnL3t8;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf26.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.17 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1761764845; x=1762024045;
	bh=lbXAxn7Fr4Nsk0Pj0RuqXVl7zH+aG4MTOYlJmhasqg0=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=kVBnL3t8JvjQ9HqLZI8hjXHke1yeuJACxtQMIgo03RCuNpTJrog3nwzZuch3Sq2HX
	 eplFtslhSeF1H9XtAz3TxhLc6rYpwoIwfwtCSB2izjzP5z4ouVdqY5oxIo9OQ9YfhX
	 qoZE7Gx/tHaWOqcYpYKTMNgSLXDkK5d02/7j6xlwl3K+JI82dbPfEcEQ2wB0zOdp6e
	 lpeOLa2anhhZTFZd5bLxzRN+RgujTzwyFrhLbahp3HIh2XgpHF+W2YfZ9IWQrn9F7P
	 Jyb2XOVHcLarA36q7cAU+FE+SailOTdfiMn1UOHBwFbxw/Hba8Y36Fl1VihdBITwZk
	 AsGfuPMCtIARw==
Date: Wed, 29 Oct 2025 19:07:18 +0000
To: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, glider@google.com, mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com,
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, rppt@kernel.org, will@kernel.org, luto@kernel.org
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, linux-doc@vger.kernel.org, m.wieczorretman@pm.me
Subject: [PATCH v6 07/18] kasan: arm64: x86: Make special tags arch specific
Message-ID: <fd549c974b53b5410dbf85c0cf6a1f9a74c1f63a.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1761763681.git.m.wieczorretman@pm.me>
References: <cover.1761763681.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: ce29df287bb81048c364d183798873981c136eab
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: 57xdbsk7t8kga9ooycdkwerixds8okii
X-Rspam-User: 
X-Rspamd-Queue-Id: 0150D140008
X-HE-Tag: 1761764848-202349
X-HE-Meta: U2FsdGVkX18KF6cCWM4xBmbZOL7xUjI5iSWIUOO1ydMLvYmnYf+IEvgTcun7onPjxX4HnOPww+PXfxFPFXVp4YAjYtjCwUEBRAWgwZtgqmpORx5X1emIrnWYInRaBLDZ/7U3FTLs/52CBrpzjMZjmBx2fMZWwYiSNhmijc/lTFU9RJAz1YeN2ut3Qt7RW0uWZJXUiixTKJ6zWD5eHMx6Lhemt5qK7SCc/aGsgyaOs52gs6I3ndo5DATzun9k+zI9Jxk43cCgC/PLr92FCiFPPxGsT42WqdmXT8Y75emmbqfUyK2uY8UFFEHvTjRyRjyXJJ5nwrkajiUoiehLXyJ4bWVXZrCYdNeDwu9xp7+hek7EFLSES79CXzpPLoyFc1gqeBYfiE+mKHH1Sm7sF/WLCH7IGy7cMMEkuODMvf16NTZsJW6pcHW6+VUXnzNokqee4U00nMO60cI5WbmMD/cRQCyBWZURio4f/f/yciBVoOKEEve1yu5t8rLthHHMyhFBJsCHG8uUZWpFVAYSsGZXgg8dr8woS59k5/OGpO0pPd2f1yaehTOOWeJ0uZH6fSkAbr66O99/vwy+NR5VcMrf9uPBe4N63ZNztFRXYCgnFewf6jfmGUaP3vipEiWgW2AEHKzDYz4cBozc0Ttki8SWY2+5l65hphOX5M916mZmsLCChhqbEJsVfedMc7P8UKJ86xWYiLiGUqCuLPhU4sLsFixVX3q3veOeHihLJiJYFWNx8/jQ33us/iGNJ7a8BqpQW+EowvKpLefhzzt8E1v1yxp2LPs5D0vg7fsOq377cCOt7dPLXY3z/v1miHoVounfhLT40SrHU+E2Vn6SMyw7WB97OjjTNoQJdeNIwC5M/7NffsSzpI0Rqfhg9RQjWXfWIwPStt51T1EM1/bEb/eGZsKrm0tnSK4X+qs2GPacf4Srpx3BI/bYa0RcuXHrkpnmM+yPCcfu/6tg0uATCRL
 BL0XdJ9j
 YbLxqysUEe79ePCG/D/k0pxSIrHo+KXuzcyBMjeXcnXEac0Hb75mEagJ5LBYPzogFJEgr6+ceEGXdw+PZ6oxa52yu2PH67FPVDyEhXCRIDS/AbIPcF/7yf/iLaB/7Kp/tP4uVGcuu6uFwpkN1vPbKgc8dNU8ugVqZ5xvr4T5ibvkC86zmg+CEZ61Guo0DkTJ7bRE342h6n/MmB+mTfO0TxIOohaUdRPWQxPTsYaOs0l4ARXiENyb2Tq7swrZgwVqZzR0SK7KGTYsnsO5lG25celtTzR4akAEksjkV/vxfSq2ynPUaqaCql3VLXBMsBO+UUuSoqAtjo6kwsiJb9zAVeGNmTKyI+3f1vFPdnUfVZs9DxPqYlOJtAUwqY5EdWqaxmfWKiiTmO1u/dsYWr5rAqHoEpePUPhvsn02QshsqNTQFrCQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

KASAN's tag-based mode defines multiple special tag values. They're
reserved for:
- Native kernel value. On arm64 it's 0xFF and it causes an early return
  in the tag checking function.
- Invalid value. 0xFE marks an area as freed / unallocated. It's also
  the value that is used to initialize regions of shadow memory.
- Max value. 0xFD is the highest value that can be randomly generated
  for a new tag.

Metadata macro is also defined:
- Tag width equal to 8.

Tag-based mode on x86 is going to use 4 bit wide tags so all the above
values need to be changed accordingly.

Make native kernel tag arch specific for x86 and arm64.

Replace hardcoded kernel tag value and tag width with macros in KASAN's
non-arch specific code.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
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
 arch/arm64/include/asm/kasan.h      |  4 ----
 arch/x86/include/asm/kasan-tags.h   |  9 +++++++++
 include/linux/kasan-tags.h          | 10 +++++++++-
 include/linux/kasan.h               |  3 +--
 include/linux/mm.h                  |  6 +++---
 include/linux/page-flags-layout.h   |  9 +--------
 8 files changed, 38 insertions(+), 19 deletions(-)
 create mode 100644 arch/arm64/include/asm/kasan-tags.h
 create mode 100644 arch/x86/include/asm/kasan-tags.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 3da2c26a796b..53cbc7534911 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13421,7 +13421,7 @@ L:=09kasan-dev@googlegroups.com
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
index 000000000000..e6b5086e3f44
--- /dev/null
+++ b/arch/arm64/include/asm/kasan-tags.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_KASAN_TAGS_H
+#define __ASM_KASAN_TAGS_H
+
+#define KASAN_TAG_KERNEL=090xFF /* native kernel pointers tag */
+
+#define KASAN_TAG_WIDTH=09=098
+
+#ifdef CONFIG_KASAN_HW_TAGS
+#define KASAN_TAG_MIN=09=090xF0 /* minimum value for random tags */
+#define KASAN_TAG_WIDTH=09=094
+#endif
+
+#endif /* ASM_KASAN_TAGS_H */
diff --git a/arch/arm64/include/asm/kasan.h b/arch/arm64/include/asm/kasan.=
h
index 4ab419df8b93..d2841e0fb908 100644
--- a/arch/arm64/include/asm/kasan.h
+++ b/arch/arm64/include/asm/kasan.h
@@ -7,10 +7,6 @@
 #include <linux/linkage.h>
 #include <asm/memory.h>
=20
-#ifdef CONFIG_KASAN_HW_TAGS
-#define KASAN_TAG_MIN=09=09=090xF0 /* minimum value for random tags */
-#endif
-
 #define arch_kasan_set_tag(addr, tag)=09__tag_set(addr, tag)
 #define arch_kasan_reset_tag(addr)=09__tag_reset(addr)
 #define arch_kasan_get_tag(addr)=09__tag_get(addr)
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
index e07c896f95d3..fe80fa8f3315 100644
--- a/include/linux/kasan-tags.h
+++ b/include/linux/kasan-tags.h
@@ -2,7 +2,15 @@
 #ifndef _LINUX_KASAN_TAGS_H
 #define _LINUX_KASAN_TAGS_H
=20
-#include <asm/kasan.h>
+#if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
+#include <asm/kasan-tags.h>
+#endif
+
+#ifndef KASAN_TAG_WIDTH
+#define KASAN_TAG_WIDTH=09=090
+#endif
+
+#define KASAN_TAG_MASK=09=09((1UL << KASAN_TAG_WIDTH) - 1)
=20
 #ifndef KASAN_TAG_KERNEL
 #define KASAN_TAG_KERNEL=090xFF /* native kernel pointers tag */
diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 952ade776e51..3c0c60ed5d5c 100644
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
index d16b33bacc32..09538c7487f3 100644
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
2.51.0



