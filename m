Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF79AD65C49
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 13:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43E136B008C; Wed, 17 Dec 2025 08:50:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F58F6B0092; Wed, 17 Dec 2025 08:50:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 349676B0093; Wed, 17 Dec 2025 08:50:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1FA4F6B008C
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 08:50:24 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B93C98B57F
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:50:23 +0000 (UTC)
X-FDA: 84229097526.13.CC4EBB9
Received: from mail-244123.protonmail.ch (mail-244123.protonmail.ch [109.224.244.123])
	by imf29.hostedemail.com (Postfix) with ESMTP id D562112000A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:50:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=aaO2qhro;
	spf=pass (imf29.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.123 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765979422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s2JYxSYT5Izoz83uHW43rnJd8Vyki+WsPGIbQcYTHRk=;
	b=7W3zMw2hZYB/8u1VSSl13zb6pVfVkYwLsJXnyZwWE2ge8D43efxhKVJcyxrwg71u6IUTSN
	kEE/ZMOCSllPLQ1h1u/3Ozo+bVjEtwsH/5G5InLCSc9464koXmEK0kE3EwjpzPmZDU+eqD
	6rKAdRq43DhgNZ7YCbeaeept7DEaS/E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=aaO2qhro;
	spf=pass (imf29.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.123 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765979422; a=rsa-sha256;
	cv=none;
	b=3avCb6GYPxyBOR98X0b5wMEeIX/COUCC+fAPVV5AoigiBxU86XcuD8VZvbjVNtpf0RlMjK
	uEaJhUna/oaPMc1gKNWTgdEsRB0ExEREgS8ZL0BXGQhLtxaQNt8tOcKVJj3y0f5bQqpfIT
	NpKdCVjSVRph8ZcZR0j2jcWwqfs2FUA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1765979419; x=1766238619;
	bh=s2JYxSYT5Izoz83uHW43rnJd8Vyki+WsPGIbQcYTHRk=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=aaO2qhroUwaDY/buRgs8KHtp2AkOjae7AXWsAyHYPxMDMnZVOjYRehCSsZ63kLgkg
	 U2lA588W08yu2bhPUd0Yycekc6mlfvU+ZIco2y7+ZxrqTeH7bcW6H6YTZNP1DZBo0N
	 fl9Q1qY1T7XyoWrisNkMI4LInRmsQ2p2Ywjirp5dc2Ys5ElrArCbYWT0uNtQDv2kfs
	 HcCt0Apcok0wcfbxLZwS4jnk49fUcHqtevJfbAzD/qIfNQICtRCariJahFkIJj9a5f
	 hzPK/LYGwz1yjzt/7UAym22/2Vql5ksfrfpcPbRzBIxJfh1JmUSqK3IWOMGmhYvONX
	 mpHVXmnslxtsw==
Date: Wed, 17 Dec 2025 13:50:15 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, Marco Elver <elver@google.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, stable@vger.kernel.org, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v5 2/3] kasan: Refactor pcpu kasan vmalloc unpoison
Message-ID: <aac5a2493bdd16e99d879d2f92944e62314f2465.1765978969.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1765978969.git.m.wieczorretman@pm.me>
References: <cover.1765978969.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: ef69e21d81520e5a8eff366705d9de1d575b6ec0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Stat-Signature: ttim3jcbwxptme1ecwikq7krcykcsxfn
X-Rspam-User: 
X-Rspamd-Queue-Id: D562112000A
X-HE-Tag: 1765979421-407946
X-HE-Meta: U2FsdGVkX18HDu/vKWrj5TesDdwCUPg7DbiKY7dPT5bH9Gs5DARSRVM303QBDl9onUziPA/OshhMVaM6/qSUkQWymJJQ0cylIJ5f9MfsyzbSNpb3BcqX/O2Q6Ml8NUGIZDN+Q6N6vrhEjzRxZ7oYu2TuL4LI5dsMx+zFoNLITaA3ZGQkm33bcKMV/WQ87r6sJp4fXYEDxMqLzaqmpJGeDhEVplx2gkL4/o7bWCs/gB9b8zGs853srwnO6y522zMi7LtopHHvEwiocVEyzS13r7k7Jyb1rhmEdmoUR6xMF/8YVMFaqYfTrd5EN6ydmgQiT19fE1euOIa61z49OfQ9aHwiuQ0SjG1/eaJCGBJ9AYbnjk3V0PRLXNUxnpnhPVlfCcRmhq+mWEpvk6nX1x/smwOLE2kgEP20lKG1amTXaApcCrJe+3WqEGiqfAXO+F2CKPrjdiyj+s7nlkrmyaiT6TZkfA3Evvq3jTMdPJQQ30S/n78y+YUuM3gtQT/E5pMhiz14m1ah1zipxYaUr/n2vYRCHnrOVo3NnAuZglF/FhEymAKcOkR9/2qGWRICion5WaIogKWpaoABQLDy91s4pbcGQtU7/nAoAH1lGuiQX+nfPmeAIbMfE4z8fBdpDd4AYPvSG9Nf1G3r0ZYaA6L6ffvcZakIflPehI0xGUfUjhU5H7KB2KzbBgQocDNyiUiWvvWieqEeFSRq7T2esLKL1/de51rFglkJogpUBaHEmxEO5ukCMJG1tH4bH17gEBQ+MEo+mK59YuZCOmxJW4CzfggVrK97bIP0aDTBnRuua67W+FmDvIxMLadTvjzGcRS/BWW2XmhaHiVDg1xQK5Tx3E0c9SUOhMUCav0xCxOptpmAyXXwMYvzRCsc5xxs9zlRDtoP8Jy8km3KedLH3Tu+4tT+DcqM8FSN029V0ytg4xha7PZ0vkIevFAJKRCwsu2pRhAOkcnOKwVoqBPGsMJ
 sfHUD8v6
 UhEomYvrf4NnBeDOXPXfh+NkhvTVA8iNJvcJ4oQPC9Q+bDZBoPk4SMrGranzf7Sw/FePV0pMQVBblBNfHiwe09eya566d0Q9SeQKvQk0WDOSxwENWuVTHGt0WW5hwcFve+anW0WrwcS5SRv85A4nLnlwvpNR2H9XcXTk1r0ESlZup2h2agIw0bTPl5MWo/umA6u1OqLsCEpGhy2ODLaGi1ApgKySjnL3kYbBH41fFfDO4eZaqVHvDU/LA61CwG8n16he3HB1ObvuIqZO6g4yJlYk4t31FrFDlKvD/A27Mx8jNJrsIg0XQYBQJwChlUkWAypfnGovIHFEo3UBTUfIZwjgM3Su50ch3VtjBTwuxT3WwUozWzADwgEEzsz+tBOTdjeWt
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
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---

Changelog v3:
- Redo the patch after applying Andrey's comments to align the code more
  with what's already in include/linux/kasan.h

Changelog v2:
- Redo the whole patch so it's an actual refactor.

Changelog v1: (after splitting of from the KASAN series)
- Rewrite first paragraph of the patch message to point at the user
  impact of the issue.
- Move helper to common.c so it can be compiled in all KASAN modes.

 include/linux/kasan.h | 15 +++++++++++++++
 mm/kasan/common.c     | 17 +++++++++++++++++
 mm/vmalloc.c          |  4 +---
 3 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index df3d8567dde9..9c6ac4b62eb9 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -631,6 +631,16 @@ static __always_inline void kasan_poison_vmalloc(const=
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
@@ -655,6 +665,11 @@ static inline void *kasan_unpoison_vmalloc(const void =
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
index 1d27f1bd260b..b2b40c59ce18 100644
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
@@ -575,3 +576,19 @@ bool __kasan_check_byte(const void *address, unsigned =
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
index 94c0a9262a46..41dd01e8430c 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -5027,9 +5027,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned l=
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



