Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33EB3D65C4F
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 13:50:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B9746B0092; Wed, 17 Dec 2025 08:50:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9844A6B0093; Wed, 17 Dec 2025 08:50:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B0C56B0095; Wed, 17 Dec 2025 08:50:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7D76F6B0092
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 08:50:35 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2525B60AE2
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:50:35 +0000 (UTC)
X-FDA: 84229098030.24.BC9DBB8
Received: from mail-106121.protonmail.ch (mail-106121.protonmail.ch [79.135.106.121])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4AD3A40005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:50:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=p9cmJ2rv;
	spf=pass (imf11.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.121 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765979433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=geckSBD2rjVv/S+5QzW1VD5eMz8cQME5gCZakvPeAEo=;
	b=nrhOk2mwx65rUHn7j68vdciKEFD5Oj6u9EPpPrq8Ascyu1PpYrnhGeoPrmGF5IaqN9PXye
	NPcTY6OsZdODFJg3MDSJ+fnnVaMV10Q0OwvQ3ypa5scsJBC4yXdKjUhj+N8z4EVz0BvtT9
	H0Na3pG83US4kmVh7selYCzZKz/BEoY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=p9cmJ2rv;
	spf=pass (imf11.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.121 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765979433; a=rsa-sha256;
	cv=none;
	b=0TbRCYrMT1NinUTDtyDlkQE49+3hrAEwhxlE0Vacq/wClOlb99/DtuVczfmGDdu5lDZxKR
	nTwb1mgU2hM6Hg6yx2s1rOzLrLIsG6JOL2zWiR4V7Q25u0beIXPJULC5v+GQOb/rLZrRoJ
	niE6SLXvgWbzLzCaOUYculEjWtge5zQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1765979431; x=1766238631;
	bh=geckSBD2rjVv/S+5QzW1VD5eMz8cQME5gCZakvPeAEo=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=p9cmJ2rvWKkNsMRMNLsQoq5FTa/vunwInrBRG7HNCfWlgo2NDugyFBLd6n2lOr7EW
	 wdiwIX0wEQxR9YPOGo+siuEcE7SjVpP9IMnk/HH2dYJSjsJYq52ytmXBfxUyjqY9O3
	 JH7WWCk9BHFJ886rwEMSqOQENXMvfzzybznnJ28k2CgwOJSZDOWQiEP4xcMUBWHLgS
	 JRCJcUWzAvERfXV4K15xeyTxi9oGo+wikD84DwJghYeTzsq2z8QVXO4LLHNEdpee25
	 7arYAf9QAMAiJXXGaaEC2zH2tCVaUSDOXWumT/vh8cyFCU/YIXgVrZ5L7wkOVypq7J
	 BXOBNipH4WAKA==
Date: Wed, 17 Dec 2025 13:50:26 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Marco Elver <elver@google.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, stable@vger.kernel.org, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 3/3] kasan: Unpoison vms[area] addresses with a common tag
Message-ID: <a2a1889754be3d97b8919cb2d3d099d12461f814.1765978969.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1765978969.git.m.wieczorretman@pm.me>
References: <cover.1765978969.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: d75a71bd0b83a1602390f2bf46fa186102550207
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4AD3A40005
X-Stat-Signature: 6bz3cf95knx8fodtbi5fetzs4xhxtout
X-HE-Tag: 1765979433-561324
X-HE-Meta: U2FsdGVkX1/nn+7bI/H77dNtWdM4f5CdmeWxKVZ0loX/J63K89Zmo1zkyWoK3lLl23+bALREDJT8etztFxK/Rt2VM2qHyS1Gt/HXI+FPbMQrxYJEFZqnNBefxdsbgmTh9buWO8YMLhSIMJ6MJOgX0zuqZMvGFsGNGkhYuELXWKDDORj6IF15ql7Zt7o7HFP2wfyZnV1kyYnwjr7o4VbF+OTA72j29qQoU+DEbOLX5iHTGR+AiRslRDc1F1cG6Lf0hHV8J6g0Cy+05rlnWHxJt5AqBJVt/uHMFRM825Edju41zudsWpyufkes4d6oGhUGSnfHTjyHXNk76ug5wVjivlWM8e9py+0z/7S8mwrm+ewU00QlR3wce8cmcszhLYFc3/dXxNgGrqEGJeXGuVNZlA6S5Na3hVVYfBLff7YZfu15eChnZhj04nxSxJNzOlYl85iiSp5xJ30U+CG0eaDLU4Jeuv82yr8JwvnMDQENg8zxeWJDX31koktr/hDBXtsxXstaFSNCUTxK/91dPzqOvlakqInfvLd0ByOqulObXAXAMLQ7qkcmIhyuFWNIOfNILZ8/e6kCm/YTE2FbZ6KWjppbZPrQxFL2107pVPWvSWIw8PmS8x74HYmk1s141WkIe/UJeHpUO4o8UsVQw4yPsbK6ZADNIBmhhXJwmdQZJqnrnD/gp+n4c0+j4jW5WL3KLR9/gRsx7P2q+yRdUIyxK79ImbM2ec2/gz84Wt5oJnAxpwEIEIQJOiM5MwaN1XY8L6dzWJUIHHj3VLYfCl1EQBVAHX1f+WWLcjKJZLWr0/ozNXSl0BQHJspgEY2l9daiu0RgQOjkSJve4WorwUzx8pGrqPYwRRVnpNMqC6OIahFv3YKiwt/25cNW4xTfNf3ADx7etM225PmIfTnmXo5aVGBNYofdQkkseJULms1UmWC9teaA72QCjplOE/Ci5GZpp1YYHikH8qnLH82dcuD
 0JLrcog2
 O2WDcZq/6FU5Xr718T4gjMSTUllc6KDYKwORL/F4Nd99qsGSZ/AU3JpALZYtkcldd83f5k+fCMobkT+11QkBEurjq2a1vZDK5baHAJA5Sd2n94Qi8dnsW+MkQdepJpfzrUhlIE9RbEmTR0Qbppe36dbxxDV17QmBfX/xR0ts+tmjRvSVhk+rVPL378UGoFECApOp2HXhlWEOtWxE+b+vreSyPG8bfNWlWJae22SvpsznrLnQ4Vp0GQBfENoFZni4bo6nSnezOyNY1Lrjb0ChQhQVtY01j3pDEAFebeXUagezpbXxAByg75zdmO8gKsLe3IvxrizfykETRjItVlGqep9UNhL/hlhlMfWya
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

Use the new vmalloc flag that disables random tag assignment in
__kasan_unpoison_vmalloc() - pass the same random tag to all the
vm_structs by tagging the pointers before they go inside
__kasan_unpoison_vmalloc(). Assigning a common tag resolves the pcpu
chunk address mismatch.

Fixes: 1d96320f8d53 ("kasan, vmalloc: add vmalloc tagging for SW_TAGS")
Cc: stable@vger.kernel.org # 6.1+
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v4:
- Add WARN_ON_ONCE() if the new flag is already set in the helper.
  (Andrey)
- Remove pr_warn() since the comment should be enough. (Andrey)

Changelog v3:
- Redo the patch by using a flag instead of a new argument in
  __kasan_unpoison_vmalloc() (Andrey Konovalov)

Changelog v2:
- Revise the whole patch to match the fixed refactorization from the
  first patch.

Changelog v1:
- Rewrite the patch message to point at the user impact of the issue.
- Move helper to common.c so it can be compiled in all KASAN modes.

 mm/kasan/common.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index b2b40c59ce18..ed489a14dddf 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -584,11 +584,26 @@ void __kasan_unpoison_vmap_areas(struct vm_struct **v=
ms, int nr_vms,
 =09unsigned long size;
 =09void *addr;
 =09int area;
+=09u8 tag;
+
+=09/*
+=09 * If KASAN_VMALLOC_KEEP_TAG was set at this point, all vms[] pointers
+=09 * would be unpoisoned with the KASAN_TAG_KERNEL which would disable
+=09 * KASAN checks down the line.
+=09 */
+=09if (WARN_ON_ONCE(flags & KASAN_VMALLOC_KEEP_TAG))
+=09=09return;
+
+=09size =3D vms[0]->size;
+=09addr =3D vms[0]->addr;
+=09vms[0]->addr =3D __kasan_unpoison_vmalloc(addr, size, flags);
+=09tag =3D get_tag(vms[0]->addr);
=20
-=09for (area =3D 0 ; area < nr_vms ; area++) {
+=09for (area =3D 1 ; area < nr_vms ; area++) {
 =09=09size =3D vms[area]->size;
-=09=09addr =3D vms[area]->addr;
-=09=09vms[area]->addr =3D __kasan_unpoison_vmalloc(addr, size, flags);
+=09=09addr =3D set_tag(vms[area]->addr, tag);
+=09=09vms[area]->addr =3D
+=09=09=09__kasan_unpoison_vmalloc(addr, size, flags | KASAN_VMALLOC_KEEP_T=
AG);
 =09}
 }
 #endif
--=20
2.52.0



