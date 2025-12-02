Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17748CFD2F6
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 14:29:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64FD46B000E; Tue,  2 Dec 2025 09:29:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D8856B0010; Tue,  2 Dec 2025 09:29:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A1C66B0012; Tue,  2 Dec 2025 09:29:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 346726B000E
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 09:29:26 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1B13B56947
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 14:29:24 +0000 (UTC)
X-FDA: 84174763848.22.A4C48A5
Received: from mail-43101.protonmail.ch (mail-43101.protonmail.ch [185.70.43.101])
	by imf02.hostedemail.com (Postfix) with ESMTP id 39FF980002
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 14:29:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=NRGZ6d4+;
	spf=pass (imf02.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.101 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764685762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cxvGIY83ye9YgTgKuvjuMWrA1hnR8fL/ldcb4UtoE+A=;
	b=4PytSVqiHUDavDjhnUIvm1E50tV2GgOYInE5jubttRUTT06o2wGOK+StxHBZAXQN0K/7Ha
	gwP53o1RW3IhO3a2zMr1fQXqqzB9QNUrIYTjt3YK9HksMVbOc1oUYl6+6f0HODVIuY9XyQ
	oFfD4OxjcUb2du3ZPfvhRwefIN07CCc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=NRGZ6d4+;
	spf=pass (imf02.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.101 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764685762; a=rsa-sha256;
	cv=none;
	b=wOgiXNEAIZDGvxi5LZVb3QIedkyjGoBwBeAEjaM6tXI+X+mdD8I+3472SpGeB/98KLFj9y
	RZo9WR2vyLUx/P2p+x3G89drvN4SLli0luHnZGQPyczPVpz8NFm1R07W6sN9axfSxbcvR5
	SxTBcE0MyuMql+PGJZpP9z97SIVv1bU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1764685760; x=1764944960;
	bh=cxvGIY83ye9YgTgKuvjuMWrA1hnR8fL/ldcb4UtoE+A=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=NRGZ6d4+04HGZNVf2o6gyp1B8hOsaMCbLjx6U19LwJTosYjrSR8DPJQzQ7GAc3hb7
	 8Yu4KjEb93EOHb9kpciwshWxjqqFU4/m2UGkJKRE9mFOp6F0NfcSiAJtkGek24Nj8S
	 NL6wBjvEZApPHsZ5acYJkwHOKUYix4KhCRjSiY3/D1iRWM9EgahIxh0uxs5TegCxyn
	 2VKXIadE4qsAulkORP6VyXw37NAlyzwZKFWWKuyP6Uba3XaikCfYNjjwrnIS1zeuhu
	 QGIDs9d+cgcogZWGBmv4SlQ4WeVWxJHD7+E8aN3zN9WkDqNRWOZGzL4XrlLmcWSDm8
	 jGzreVUYFUd7g==
Date: Tue, 02 Dec 2025 14:29:17 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, Marco Elver <elver@google.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Maciej Wieczor-Retman <m.wieczorretman@pm.me>, stable@vger.kernel.org, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v2 1/2] kasan: Refactor pcpu kasan vmalloc unpoison
Message-ID: <3907c330d802e5b86bfe003485220de972aaac18.1764685296.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1764685296.git.m.wieczorretman@pm.me>
References: <cover.1764685296.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 39231ba515aa7720d08908d2e3bb7dc16ac86540
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 39FF980002
X-Stat-Signature: d4jypr198eemgyd59drho4k8sozks759
X-Rspam-User: 
X-HE-Tag: 1764685761-630983
X-HE-Meta: U2FsdGVkX1+8LrEtoPkwHsrMybQQW11DIBOvzC/H5MtuwH3H9OcDPhp69b+rGvxQsjuiPrWiyjLnXHlfwvS+1x1SHQBEcqNbhzCh26xKz9LaNS0B4JRxTEYsqnou9Enr2lxLyUv9itXN+q078qd8EM9Y+KfpvVLnHLO48LRDhQYu/vnd3Mxs0VDmwwzNe2XFNeIJ/i/FE/aiRDx22gBUmdpF8WCkwh6HoisGfHgn6hW5eyafbb4lOvROHYMAhID1N+yUFvGWnavntAbI/ShsPgPl2fOmC4aBsAN/eQNz/uVtXm2LH59HAohhcoU//lhwC0rNR1urhh1/iZLrx0RzmnYTHJPuph0Vkizqoe6iR0Ai7st3mLGBhIjVeVLqcT4dRmcRFnKcOn6aPpevAeCwVyrK4tRkkh9BCxIUdkkBYb4HQKFGyc0UYRjBIPNK+j9ml8BU5bjAV8sgrr3Inbp/LUDa6IBCQ9awooRgOLtRky4OIxOZcGB6mMNr2o2d8aDz620YI+/laHRUU/merfeAAHADqGbzwJCowp8GmDfP+UbX3JoFVfC8u74ABwS/yRqsRe5641AG+qHzazeclWZTM051fqEv2sl1WjuwEAvDL3V0Lz5kymJy9RdjG94E40mPOkxCopK937G3s8YuRK0ZQhjvHmwUSn4rWJB7Ird7EtI9/pndRVRKeuCSnVqsqEVlNNj9xROKAjARih1TvWBnicThQueUHa37HHCdNtGKCfxsFBwnG1e40cw95ixZX/Nys8dZciPJ01wEehnmEsPWh7ysP6DVylJFuY6Zc0qfRP50DOsb9tMyizSUvF/5FoiNoWqo8mFXOqy4N9CzkysKIR5KytesgMn6GdMOFXTWAfovSpEYY45lRTO7XVyzIxzrm1BijwAoNvSQWyv2BDs/00Fjr/wO07281JGy6DwQOIhMxBulDwsUJxZLlRnlUm8RWz4C//ePlcVihaBXPbV
 KQ7gR2EA
 UIpMi0DwSudM2zdFxGTFOYy/0W4hiU8mxs4FFYzST4jR8HZz2TgGJGXr47gqP7e1yid1nUK8yIU59sZ+fcuFEng/ahrV/FK8uPZYPDPoxKf2RpkJ+zOJI7Dl+kFwScEpECnjmHMMAx40vDwKL63HpNEmVZ7hUm/Q+VM2d9K4arQIEPvIHNhUzM7ZXx8sqx9bkGtJiKwLxlLkk2W4C5bUalmw+4G24KwNt7xQUwh0L8Gu93F1xAeryfVB4e684KWEw4YFWdQOdFYTGJ9vySwj0vQRT6oB4BpOq7igwetJNrbSmygcckq/UCB/Y6nC6fjjGc7sOvF1UaCof9/w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

A KASAN tag mismatch, possibly causing a kernel panic, can be observed
on systems with a tag-based KASAN enabled and with multiple NUMA nodes.
It was reported on arm64 and reproduced on x86. It can be explained in
the following points:

=091. There can be more than one virtual memory chunk.
=092. Chunk's base address has a tag.
=093. The base address points at the first chunk and thus inherits
=09   the tag of the first chunk.
=094. The subsequent chunks will be accessed with the tag from the
=09   first chunk.
=095. Thus, the subsequent chunks need to have their tag set to
=09   match that of the first chunk.

Refactor code by reusing __kasan_unpoison_vmalloc in a new helper in
preparation for the actual fix.

Changelog v1 (after splitting of from the KASAN series):
- Rewrite first paragraph of the patch message to point at the user
  impact of the issue.
- Move helper to common.c so it can be compiled in all KASAN modes.

Fixes: 1d96320f8d53 ("kasan, vmalloc: add vmalloc tagging for SW_TAGS")
Cc: <stable@vger.kernel.org> # 6.1+
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v2:
- Redo the whole patch so it's an actual refactor.

 include/linux/kasan.h | 16 +++++++++++++---
 mm/kasan/common.c     | 17 +++++++++++++++++
 mm/kasan/hw_tags.c    | 15 +++++++++++++--
 mm/kasan/shadow.c     | 16 ++++++++++++++--
 mm/vmalloc.c          |  4 +---
 5 files changed, 58 insertions(+), 10 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index d12e1a5f5a9a..4a3d3dba9764 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -595,14 +595,14 @@ static inline void kasan_release_vmalloc(unsigned lon=
g start,
=20
 #endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
=20
-void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
-=09=09=09       kasan_vmalloc_flags_t flags);
+void *__kasan_random_unpoison_vmalloc(const void *start, unsigned long siz=
e,
+=09=09=09=09      kasan_vmalloc_flags_t flags);
 static __always_inline void *kasan_unpoison_vmalloc(const void *start,
 =09=09=09=09=09=09unsigned long size,
 =09=09=09=09=09=09kasan_vmalloc_flags_t flags)
 {
 =09if (kasan_enabled())
-=09=09return __kasan_unpoison_vmalloc(start, size, flags);
+=09=09return __kasan_random_unpoison_vmalloc(start, size, flags);
 =09return (void *)start;
 }
=20
@@ -614,6 +614,11 @@ static __always_inline void kasan_poison_vmalloc(const=
 void *start,
 =09=09__kasan_poison_vmalloc(start, size);
 }
=20
+void *__kasan_unpoison_vmap_areas(void *addr, unsigned long size,
+=09=09=09=09  kasan_vmalloc_flags_t flags, u8 tag);
+void kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
+=09=09=09       kasan_vmalloc_flags_t flags);
+
 #else /* CONFIG_KASAN_VMALLOC */
=20
 static inline void kasan_populate_early_vm_area_shadow(void *start,
@@ -638,6 +643,11 @@ static inline void *kasan_unpoison_vmalloc(const void =
*start,
 static inline void kasan_poison_vmalloc(const void *start, unsigned long s=
ize)
 { }
=20
+static __always_inline void
+kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
+=09=09=09  kasan_vmalloc_flags_t flags)
+{ }
+
 #endif /* CONFIG_KASAN_VMALLOC */
=20
 #if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) && \
diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index d4c14359feaf..7884ea7d13f9 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -28,6 +28,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/bug.h>
+#include <linux/vmalloc.h>
=20
 #include "kasan.h"
 #include "../slab.h"
@@ -582,3 +583,19 @@ bool __kasan_check_byte(const void *address, unsigned =
long ip)
 =09}
 =09return true;
 }
+
+#ifdef CONFIG_KASAN_VMALLOC
+void kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
+=09=09=09       kasan_vmalloc_flags_t flags)
+{
+=09unsigned long size;
+=09void *addr;
+=09int area;
+
+=09for (area =3D 0 ; area < nr_vms ; area++) {
+=09=09size =3D vms[area]->size;
+=09=09addr =3D vms[area]->addr;
+=09=09vms[area]->addr =3D __kasan_unpoison_vmap_areas(addr, size, flags);
+=09}
+}
+#endif
diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
index 1c373cc4b3fa..4b7936a2bd6f 100644
--- a/mm/kasan/hw_tags.c
+++ b/mm/kasan/hw_tags.c
@@ -316,8 +316,8 @@ static void init_vmalloc_pages(const void *start, unsig=
ned long size)
 =09}
 }
=20
-void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
-=09=09=09=09kasan_vmalloc_flags_t flags)
+static void *__kasan_unpoison_vmalloc(const void *start, unsigned long siz=
e,
+=09=09=09=09      kasan_vmalloc_flags_t flags)
 {
 =09u8 tag;
 =09unsigned long redzone_start, redzone_size;
@@ -387,6 +387,12 @@ void *__kasan_unpoison_vmalloc(const void *start, unsi=
gned long size,
 =09return (void *)start;
 }
=20
+void *__kasan_random_unpoison_vmalloc(const void *start, unsigned long siz=
e,
+=09=09=09=09      kasan_vmalloc_flags_t flags)
+{
+=09return __kasan_unpoison_vmalloc(start, size, flags);
+}
+
 void __kasan_poison_vmalloc(const void *start, unsigned long size)
 {
 =09/*
@@ -396,6 +402,11 @@ void __kasan_poison_vmalloc(const void *start, unsigne=
d long size)
 =09 */
 }
=20
+void *__kasan_unpoison_vmap_areas(void *addr, unsigned long size,
+=09=09=09=09  kasan_vmalloc_flags_t flags, u8 tag)
+{
+=09return __kasan_unpoison_vmalloc(addr, size, flags);
+}
 #endif
=20
 void kasan_enable_hw_tags(void)
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index 5d2a876035d6..0a8d8bf6e9cf 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -624,8 +624,8 @@ void kasan_release_vmalloc(unsigned long start, unsigne=
d long end,
 =09}
 }
=20
-void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
-=09=09=09       kasan_vmalloc_flags_t flags)
+static void *__kasan_unpoison_vmalloc(const void *start, unsigned long siz=
e,
+=09=09=09=09      kasan_vmalloc_flags_t flags)
 {
 =09/*
 =09 * Software KASAN modes unpoison both VM_ALLOC and non-VM_ALLOC
@@ -653,6 +653,18 @@ void *__kasan_unpoison_vmalloc(const void *start, unsi=
gned long size,
 =09return (void *)start;
 }
=20
+void *__kasan_random_unpoison_vmalloc(const void *start, unsigned long siz=
e,
+=09=09=09=09      kasan_vmalloc_flags_t flags)
+{
+=09return __kasan_unpoison_vmalloc(start, size, flags);
+}
+
+void *__kasan_unpoison_vmap_areas(void *addr, unsigned long size,
+=09=09=09=09  kasan_vmalloc_flags_t flags, u8 tag)
+{
+=09return __kasan_unpoison_vmalloc(addr, size, flags);
+}
+
 /*
  * Poison the shadow for a vmalloc region. Called as part of the
  * freeing process at the time the region is freed.
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 798b2ed21e46..32ecdb8cd4b8 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4870,9 +4870,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned l=
ong *offsets,
 =09 * With hardware tag-based KASAN, marking is skipped for
 =09 * non-VM_ALLOC mappings, see __kasan_unpoison_vmalloc().
 =09 */
-=09for (area =3D 0; area < nr_vms; area++)
-=09=09vms[area]->addr =3D kasan_unpoison_vmalloc(vms[area]->addr,
-=09=09=09=09vms[area]->size, KASAN_VMALLOC_PROT_NORMAL);
+=09kasan_unpoison_vmap_areas(vms, nr_vms, KASAN_VMALLOC_PROT_NORMAL);
=20
 =09kfree(vas);
 =09return vms;
--=20
2.52.0



