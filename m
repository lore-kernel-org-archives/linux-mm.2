Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49299D32D8A
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 14:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FAE86B0175; Fri,  5 Dec 2025 09:59:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D2366B0177; Fri,  5 Dec 2025 09:59:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80F0D6B0178; Fri,  5 Dec 2025 09:59:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E2726B0175
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 09:59:48 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D05456839
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 14:59:48 +0000 (UTC)
X-FDA: 84185726856.14.E91C8BB
Received: from mail-244123.protonmail.ch (mail-244123.protonmail.ch [109.224.244.123])
	by imf29.hostedemail.com (Postfix) with ESMTP id 262AA120006
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 14:59:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="ZOWGS/m8";
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf29.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.123 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764946786; a=rsa-sha256;
	cv=none;
	b=k6g28U93wgh/1/Wg6Mk90g4964ScNf/absg+b6zVC6gvJdDZSKBMuH0vbuNHoXr6FeEI5Z
	40QMfbV5ClaaM0xB+htj80JPWKvN5zXDMqD0F61JZteigrLy9007Bhxw936c7QvHBfrGZB
	ndlA0OLMa7ACxObc1KCBDKdumuqNcxE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="ZOWGS/m8";
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf29.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.123 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764946786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qIyabYfRYXeVwZVp9LPPfWirGseEPkYszpblk/XZ5Dw=;
	b=52yjUBtt0AupxxnO7mFXSCEu6b6kHsaK8LOZ9Y11OrBKaElqrtq9JG2eYzJacwJA0ZFOwg
	mKdt9LNViutES97DYVccLwY4UpQV+nm0s9ussLJ2jK6Jv5Bh9w3RCwj/rPcG10rXfvRYxz
	bjyU3P84dGbD5S7q2lOXNdos+G6DQMI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1764946784; x=1765205984;
	bh=qIyabYfRYXeVwZVp9LPPfWirGseEPkYszpblk/XZ5Dw=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=ZOWGS/m8tzXkiQ5rMpz2nfSazNtDRqiAV7taCW/XZHvZinRh0fuzw1xalMJyHG1ab
	 NmmS8SF6qxmpWheZnvotMSLFiKUAd6yB7OkYE4RINBY50RpB3Jni5l6u6ztRjB5TuB
	 5MugaFAEwCTF3DX1z800bHR88KfVIs0venVyLJnnKESz6+oIoxGVkyzuUgnWk1aAj3
	 Dodl/LWeB2nlQwDFotSW08UdY0skGH/FgEbdT/rtmxXXUyWdlpTwLTtx2WEC+1eqW1
	 VyE2NqB0hE9sZwNkvYPvhe/tk3WFgas7LfcQAvvuytTAoczZXR+1Cvxj3pOaKfz5xf
	 DeOLp3gaajH0w==
Date: Fri, 05 Dec 2025 14:59:17 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, Marco Elver <elver@google.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: jiayuan.chen@linux.dev, m.wieczorretman@pm.me, stable@vger.kernel.org, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v4 2/3] kasan: Refactor pcpu kasan vmalloc unpoison
Message-ID: <6dd6a10f94241cef935fec58c312cb846d352490.1764945396.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1764945396.git.m.wieczorretman@pm.me>
References: <cover.1764945396.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 948f454a99eeea8eab949328f562c02766404396
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 262AA120006
X-Stat-Signature: e8qfa6n3ckebfbpbnspwku948ehxg5w5
X-Rspam-User: 
X-HE-Tag: 1764946785-828248
X-HE-Meta: U2FsdGVkX18I3gOdhAaBeIosKNLmfrqZulS3RUYu0J7z664/sJlQe8bkpVKWEvHnisSEXPVK6KxfhotCTcOPwUfACLZkvF/SHlCVtJVt8XScCIzdD7efrOHE4h6NVEeX0W1BHQOidwgj110hxn94TthQmNNgvWLTj3VRPmvnlndl4VH6M3OBMULXJiF2JJRRT8Mi5K1h9x9w4ZIRoZ/fwPcLPXaOWWs7gGjtMEvv7fmjwObd4+8UKSfnwNh4lTP/qQSI08ixDIT11DTwH/gt/5kcnCjNBBOPTMBmG5WxYgFti2x40cRM9yHilFPGNW+EZKw0PPM7NBUleXqNlLN5lt61fkCq/GNJshRhfRgwbouwb3VBgVm8Z+3SNg9xruPuaAyTrMZDDP1libEmx6ec9Se6FDyitigjKYv4rm25Z49FFe0sQqdHoSgsaXNMYqn/dX53GSXMbJ1/vwT4NCYy1ucyIwcuKmM+eW0hoY9sRG4hb4Dv1Kn0518xZ9c/DtIh2q95LXxvycHeNUETC62b8+1vmJ2bIan6KxSpesTQyk7U87RHPg0g8696X4ZAQe1N2RQsQAIXdDPllWj7gqD3XyD/nDDHyPjylrphtsqLOJK+qQ2tbc8kj+i3zRmwWVXIR24ufp0XlUr6Aw8S7P3P2xoFfYMaTrS4NZnG6soON/7kTIyhG9avLghqa3y1Fu4MHm4r9htu8YXYtQRFsrbo+2gH+KsQdaWAV0QRFhzHVgOdDu1t/EHTIW8IoQt/YGiLOyz2FKSoHA2Z2hSA0bMEJShCr6NE61kZuuAIVdKxTMebgQQBAJBINxbnR4lv46K61iDoxsY7FjxwGgnMQlvgNu1Jvi8+mWSZnwdad5qanobAzFCOfw8nMBJT10aVpG4s2By8/hsbhDJxxXXf9akibFtpfn+LsGJqQbSCgn+MbcD5enM1cgBfN8x3c2ujtwbrnGe5k53pOaFaFPcClwr
 0XViaTIn
 bKQziZtlgQT5tnqEvBzXk/FE59nDeKN+TpgdIhsFUoPNq08m35GXvcVwue2W0C8kvPkPNuwRhTdRy1VfqqUK5VTyDRhQ6XYAxq1r2Pvp0QCHvyocRL2ZxXl5PF42gmUxy6sL/qNuqfq4zEUUD/HDq8rI7WAUzMmqIvMn2sTzOAg96BQL9xXT9AGpHXGqRytseCT93CzVdOR4lD8jO+bEoYs44BhxbrrTubbfLUaLuAEt7GpkaAWUexYS6F0ww0GFN1rWBIjk8EBoHysn7KuVEvbNFWd93j7WKLh5+ATLo9Bh3i4c1ckbx2j0Uy9FI5sDwzYnaWqRtrNiEY/VvHSkXoT9/b6J8rgivp/2Wrd75FX0gKZF48eytnxeA3lhskYnMoGUB
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

Fixes: 1d96320f8d53 ("kasan, vmalloc: add vmalloc tagging for SW_TAGS")
Cc: stable@vger.kernel.org # 6.1+
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
---
Changelog v1: (after splitting of from the KASAN series)
- Rewrite first paragraph of the patch message to point at the user
  impact of the issue.
- Move helper to common.c so it can be compiled in all KASAN modes.

Changelog v2:
- Redo the whole patch so it's an actual refactor.

Changelog v3:
- Redo the patch after applying Andrey's comments to align the code more
  with what's already in include/linux/kasan.h

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



