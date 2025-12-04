Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F8ACD29FAE
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 19:00:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 827BB6B008C; Thu,  4 Dec 2025 14:00:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FF966B009D; Thu,  4 Dec 2025 14:00:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73D226B00A2; Thu,  4 Dec 2025 14:00:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 60ED06B008C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:00:13 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 27A861A024D
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:00:13 +0000 (UTC)
X-FDA: 84182703906.12.22E5A84
Received: from mail-106120.protonmail.ch (mail-106120.protonmail.ch [79.135.106.120])
	by imf29.hostedemail.com (Postfix) with ESMTP id 371E1120006
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:00:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=rtyWO8Mh;
	spf=pass (imf29.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.120 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764874811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IkyiGHAPhFI7mnPUmSkIC1C5JfoL+QfGKczkbPsXbcs=;
	b=KHagMcRyqj4AlB/QkK1kdo6krGg/M8Z0Q9HjbkCZzsyy4AdKBLLute0GWxB0s8nhQ5GbE8
	F8C7+DKEk56WR1/0IwIuZh3XzGDXvZgcZCIu6B2DOWiQVVqyXD98ebSLviNghgA2kF1o+h
	0wRnKDNnof41MHdkUrNkvsA/FHoKP9g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764874811; a=rsa-sha256;
	cv=none;
	b=jg/qNVOtssE7ZpsI2ZJ6YKibtTXacveXWGIOzKJ5wiAJYVC4nF2Un07l8EjCpd4TuYxcgq
	SdqoZTIBBjTV2854i5SuseTm6joEvrm33K0LQX/roV6k2hjuTvcjGZz7hKLI0nj+AebWWD
	R8AxeW/GZW+aUNxrkR9P4vmvBPc8vc4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=rtyWO8Mh;
	spf=pass (imf29.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.120 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1764874809; x=1765134009;
	bh=IkyiGHAPhFI7mnPUmSkIC1C5JfoL+QfGKczkbPsXbcs=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=rtyWO8Mhp0k18ZcQhE62dU64ZWyjWu8gN4X48g8L7vsLbz32pen4vX2yR817pv5nq
	 UR/DJUVaJVGf1bfG1/ykN0eJQ4sDYYb5PEPyTVVi2VqWnMDFG7HqizX9h4BRSVYHy+
	 eltUby5UQqhC/4NhV5za0t/SkcGg5cZm/OA96J6Qk12U91Va9FC19YF8ueSVubUIAy
	 duTz/653G7dC15XWOBSwTkf/Si9UYE1w2DliI/x0CvNxxYkY3WJG7guCxZiKWkcg4S
	 c33NbGc7cAxKHLjIp4qUt7Siq939KZEJ3PTx7ASwE+XXkLee4Mjq8qy1R6V0b2VWa0
	 YsmXZfQBkLZZA==
Date: Thu, 04 Dec 2025 19:00:04 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, Marco Elver <elver@google.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, jiayuan.chen@linux.dev, stable@vger.kernel.org, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v3 2/3] kasan: Refactor pcpu kasan vmalloc unpoison
Message-ID: <eb61d93b907e262eefcaa130261a08bcb6c5ce51.1764874575.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1764874575.git.m.wieczorretman@pm.me>
References: <cover.1764874575.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 258475af37f58ec18af8ccf0e0fabf0466575111
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 371E1120006
X-Stat-Signature: aybp1jgsc9573aqpobn3imp7yzddq7r1
X-Rspam-User: 
X-HE-Tag: 1764874810-149550
X-HE-Meta: U2FsdGVkX19HEJFsczk4i+/tQP+m8C+bbJ1eYccP/1uFMZlQ7R2O4O9gee89DZvVLK3LadFYJtRkbaac/6eoiVmlXwgsTbV+GT8g0Q2m5Bg3feHdVYlP0FuxGtb1b/jMNTKd4tGkwDJv6JqrBYtprHZSVyrncwZDjTxe6dXgS9/m4h9iQxcvOYfdTz6El/edVQLWmm2z2BvzSje4qPIybupjx5W5EIwQe7iYU8bVnLTEjoUMJLEnWecF0Uw0nY6aN8aLsiJQhvqp/DCiPHZ8ciEq2GqbDyFxhcclubnvXN1ALjBmpdThnoLMli8GbBGgKt0edD7ai+zdpah6hv7c/cwgfsMJo57GaK2GH9LKka81LDXKtFAmxHOIG+cK1wsUTg/15jpth3f9GJWpmcw5ixMu9juph8aUsvPgdLZsCE5B7RpJwX7WCn5yMP3bEmR1xMut5ALb0N48s/i5nd3LEazXyLZR+TDlgscLZDeiUmP3QZ242K/4IAEAfbErbi+ttWBVaz9aNrPBpWU1THUGCDDqnRO4yKW2oLwl0srw3Cxld2sKQN8yrCOjlqKKvLNvCq96dPdGtSqsGlR64xY0SDGPgRdqe/JB2Rl1dz2MNt5AYfrkdBhhQXIjgqIwaFaKjnT/YPAdZzhyq/9B5Mx842mzabVOThD89gaq8VeaJOpUKnRmCnX6fK22yZm7IQBcqPcgAs2wPzeibThx6qYzskt1YVHNGFpS5xnoibtCYZZgzPk7EuPoBaEjnIh7iRk6JcCuYWQpqGSai0L/ReKVKOBASxFMOYoosof8Miv/Hv0LzdMrwIYMbwhLeSOIm1ctfI7HAc75pOo+QhqUjSyS7c7VlKMA+yncZcMEnWV4Sk02ejhgbAvRRszxxBFUdE99Cx8kJfXGGx0Pc4HLxCCmfLkkQm/H6R2OeYQXDCqL8/rTLdkjFMU8q7xKCXXTZ+vEClg+8gi05wB9vI46PXY
 7bCYaZqA
 7f6MSZWL/SFJAu29ukCA+h7PhFR2w3vB+NQECs+RH/HkdCjcexv3hWdXuBg3rwWvhNI6oxu4r+VlXHSEOEGFxM/3WOW8lZKxStC/+N16vTdX8484fD5b8OVtXB5BwGWX62HzvrRBPiHdtlFmG4R9CR9xIjRVR2+wsBSEE3ZK1OThY6V1g9421K8x3IiqM7B5V3QkbPKa2XIA/pOF/7TVal0tiEUDQMYxlVfs9fw2lBC57bMqT5vraUF2tVn8oPkA4RJ+fXfJZqiEJWUHggk/uJ2MVtdpTg6BsJCGUZI0h9R4evC2ioIoqNka2x7YpJ7SwnpUNBzmaOqg/n9QfBxuUNSmKmxIbDHCqr5N2ofyVblvrD+k=
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
Changelog v3:
- Redo the patch after applying Andrey's comments to align the code more
  with what's already in include/linux/kasan.h

Changelog v2:
- Redo the whole patch so it's an actual refactor.

 include/linux/kasan.h | 15 +++++++++++++++
 mm/kasan/common.c     | 17 +++++++++++++++++
 mm/vmalloc.c          |  4 +---
 3 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 6d7972bb390c..cde493cb7702 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -615,6 +615,16 @@ static __always_inline void kasan_poison_vmalloc(const=
 void *start,
 =09=09__kasan_poison_vmalloc(start, size);
 }
=20
+void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
+=09=09=09=09 kasan_vmalloc_flags_t flags);
+static __always_inline void
+kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
+=09=09=09  kasan_vmalloc_flags_t flags)
+{
+=09if (kasan_enabled())
+=09=09__kasan_unpoison_vmap_areas(vms, nr_vms, flags);
+}
+
 #else /* CONFIG_KASAN_VMALLOC */
=20
 static inline void kasan_populate_early_vm_area_shadow(void *start,
@@ -639,6 +649,11 @@ static inline void *kasan_unpoison_vmalloc(const void =
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
index d4c14359feaf..1ed6289d471a 100644
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
+void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
+=09=09=09=09 kasan_vmalloc_flags_t flags)
+{
+=09unsigned long size;
+=09void *addr;
+=09int area;
+
+=09for (area =3D 0 ; area < nr_vms ; area++) {
+=09=09size =3D vms[area]->size;
+=09=09addr =3D vms[area]->addr;
+=09=09vms[area]->addr =3D __kasan_unpoison_vmalloc(addr, size, flags);
+=09}
+}
+#endif
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 22a73a087135..33e705ccafba 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4872,9 +4872,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned l=
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



