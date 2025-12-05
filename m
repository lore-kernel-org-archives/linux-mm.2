Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EA2AD32D8A
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 15:00:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6637E6B0179; Fri,  5 Dec 2025 10:00:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63A926B017B; Fri,  5 Dec 2025 10:00:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 578E46B017C; Fri,  5 Dec 2025 10:00:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 460E96B0179
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 10:00:02 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E8D0EC01DC
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 15:00:01 +0000 (UTC)
X-FDA: 84185727402.06.3098034
Received: from mail-24418.protonmail.ch (mail-24418.protonmail.ch [109.224.244.18])
	by imf13.hostedemail.com (Postfix) with ESMTP id 14B4E20011
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 14:59:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=N+3AZIRl;
	spf=pass (imf13.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.18 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764946800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L0KdqaoEvJRt9/c4L5Rt4JS2SHbqfjLO2UUM/bE4AmE=;
	b=IMr4P3YGcfpRip65RYVBluGrhn7sl4TqthfHne1mOO0tSH6B6fwjRaY3Q0L2b2I5zVDFNc
	nGMvJmoDn8R7ImZIcWO4Eu37cDTknKmAPRmmTzeXpGKrNHKTaOrI+TGJZnW7saUXMx1HO3
	JtMccT6OQkpp0cxm+3Riwm8Koh/eXaA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=N+3AZIRl;
	spf=pass (imf13.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.18 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764946800; a=rsa-sha256;
	cv=none;
	b=kjrBXo/5WxNnVq01ScpMxxxv6DqHBqrSI83nRstAyQlTpC5dgN4SP5wbVfQZYCT5kkol+l
	unt1yTgwtVtCeVUWAlMqCQktiVozJR7Zom5xi8yqIuAROGxy9LLf4jmMzO3sXy6rokXHvB
	aiJoR5IUdeVLxEE57OcD9zQ6WpLqFy8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1764946798; x=1765205998;
	bh=L0KdqaoEvJRt9/c4L5Rt4JS2SHbqfjLO2UUM/bE4AmE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=N+3AZIRlFffP95lEsDGcJwonEwcbmnmiP+y9G7XIZ4CFhPqE12ntUM7VqVh8YDUHr
	 6BJW7IfSW9jwX6j3p+t5RY5+0ZEg+L6wKYKw9NKULxp3VFb2cXmz604zMCbYqwA+V5
	 Uc/Y4JAt9Qklgc14X5IqwNYWQwjAAI3CipzqUjHEO/4J1FgCRc4nrGXFgX7anR/7gF
	 hu++oTotuKns356sfhzGjNvViiiYwVN2nam8yAPQSzrQ7f/kvvB1In/ps2JXOFIcJA
	 70YVK1WzmHJ9gRvB8H7RqV+iK5AgWStUXVHjnR8fMAeH0ZfefZcy+sv+UVxUM4WgLW
	 Z/OZs+EMukOBg==
Date: Fri, 05 Dec 2025 14:59:26 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Marco Elver <elver@google.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: jiayuan.chen@linux.dev, m.wieczorretman@pm.me, stable@vger.kernel.org, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/3] kasan: Unpoison vms[area] addresses with a common tag
Message-ID: <919897daaaa3c982a27762a2ee038769ad033991.1764945396.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1764945396.git.m.wieczorretman@pm.me>
References: <cover.1764945396.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 1f0ff2af25c0def600917e4f386d03b302b45161
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 14B4E20011
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 156h7x6x995phn5zeerq6krdut9su8qa
X-HE-Tag: 1764946799-362076
X-HE-Meta: U2FsdGVkX18b5fW9gNWQwNsGvae7uwvVUzVAfyJqedROvCbrTVEoPkVUBlISPNDQUVCWY/dU9qZdSxYCA8Qtshsp5kTWdkKZK99eo7vyl5tHbQlgeYxJ+xBO5MJybq1Z9I+1nwgd3t+aao6+2P8KIRnjIiNxTUyXaq+X3G4xJ+rm/tE+hsn897Wo3n6ooCILgkCf2fJ9nb1m1EmPIofScYbmyKu9PvNM6NzdCHM1j1b5K94FTZg0tyuD5Rg3cRaL3SrfQL6XCEKeaGCdNIMX8tbC6SS/9h0yoUfUBSAAWK/LGBODJmNoqz6Wf/jJ3MUiKmdECpMkmEkoeLjLdTFgiuAGJHn9Hya+weNfJLWMbH+rer8V9fJqTjJs3A9xkFb04xt/NSFtunjymSVOy6ya/S0yRScTcfvj5pgj5SquR0zZpO1TSpjTDkJ4X3e9It8gFAhYPhLvTSJBR4Nn9SPFBnARxV89SO3hQyUntvARu0VNT8e3SEHzjTRjGBSpiw1oCYHvr7GBQ0LES8MteI0XR+S4ilmdODWr63NtlBS8xLhJ/0Dsjw/FeEK1O/22A2ZnRYTd929JkZs6pfWe+SIJo5HC6xUn180xzDKVPHXTzBsbwzk6ir/VWEIfvIPcqczJoqU+8MWJFpk1wQXtSIzxn1nV5s9wzTf3KWlKVnXoy5Mpt62H+UjQyIhhFe4qmw3q+Cx+yyYjhM4pJVk6ECvdZXT1+prZNdR4goENhTMTButclN9RMymhQTMijyRKRQWRbAJFmk58aiuhH6t5mQE704IeZZg7RD+p0bmaumWPacBUpyBAlwaUY1EeaCwtsqfiziXdDgFCNmdHqfy6z9+NnGSsLAYPzFNMsEsJrEL2LjXzdWYyQjc9EPli5pbVd0kSeE7OaxzS+/c++mOZRP1D+eIhAI7qHaUgLyWdFf04m6YYRO4L5IPr16WrecAw6rkeg9jwpAhcyVkXRAn3TLJ
 qs+a58Q2
 qmisPQRiSoskU5h9WYilCqLgkpnboEeZcpfP0kPPCQKTZNC99IAmTtHDNsHjazqnEIkr+AQnyJj73kJ4SHgNlTB/EKqr9SDcXiSBwEH4qIasQ6OSeS9n/FurkvCCt0tJuS5Ij2JWt3T3gp2PbdTmORg64tIe6aXWe9qkoaFC2yczojeeNryIJWwpd6me3Jqtg+WMhq2Ha37GRBfj2+Pe+yd+6VGlrwb9WxAK8Qq9KXul7j3U/XsRD4O6+lKYXvHMRgPuyiEc5CHtxus41lPC4r9jlG7wiwiD4YN9nTL7C7bwBJmYV49VafuUhxOIKwXbT8QThHLQixVoFq9F/R4AGnledalQs7E/VqbTu
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
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
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
index 1ed6289d471a..589be3d86735 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -591,11 +591,26 @@ void __kasan_unpoison_vmap_areas(struct vm_struct **v=
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



