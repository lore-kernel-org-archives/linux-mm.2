Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE4CFD29FAE
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 19:00:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 542596B000A; Thu,  4 Dec 2025 14:00:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CBC06B0011; Thu,  4 Dec 2025 14:00:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 408F06B00A2; Thu,  4 Dec 2025 14:00:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2DD736B000A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:00:20 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DCBCC51A9A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:00:19 +0000 (UTC)
X-FDA: 84182704158.03.D7BE877
Received: from mail-244123.protonmail.ch (mail-244123.protonmail.ch [109.224.244.123])
	by imf05.hostedemail.com (Postfix) with ESMTP id DD56A10000A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:00:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=MGFUiyyI;
	spf=pass (imf05.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.123 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764874818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OkoBRhgSwjuQLuLgL6yseexB7KxkTDwJEiXAnUMLOgo=;
	b=siVRGXl8nRq3Sl010p60tRLXwgZpvXKn1IgYAFRInj3zGm5drpB8khXED6XH0BddgU5bTi
	TKIhZgvAWA9r67VR2LlyJuIInXdaeip4lvRiB+py3vquLqNYdOCNN9SZQLvtSz0C2R2wgf
	9IteILV456iBzhcwxCvKyqnJ7t9Q04w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=MGFUiyyI;
	spf=pass (imf05.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.123 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764874818; a=rsa-sha256;
	cv=none;
	b=AHrYUabsTVWYaEEnQpLBoq6SoGWIXVRT7lZ9M+TNS7HiUcIHgDwff2ncQz7nt1aiOblEur
	WdIt8M+sJz+K7XPi52EtUWcGtjOGQUDt3zkkE8ld4V6EABbY71fDwyJxUDItqi8SmxQKs6
	0c/bdO95BfIN4S4cbvwryiVgaMRNKaU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1764874815; x=1765134015;
	bh=OkoBRhgSwjuQLuLgL6yseexB7KxkTDwJEiXAnUMLOgo=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=MGFUiyyIDKtVbJTiczN/PWRSWvLhh11G6a4GRU9xXEEewJkCTZxEmuxNpqmyytJiZ
	 D+HattnA4aU9m28WTAhKFXHgJPLJAXelaYDyr+J79xtORsVLTBbyQoeJCy56B8b30H
	 RPU23LVvrseHJ6PDlrp5wIGFfIB/voK1OsWmC61UvRydlyrdZ1DaxCh7zd2Gboy/Ok
	 uO6okFnUrx4K3A7nutPQLkGK6Je4mIty4LjAsen/CCpZ19YnrFfIGJRROER9xX8082
	 LhDuEBFtt61LoqKRyWcqrUYhicukpYFPdJYNjQfLEmEPTzNqN217K7xo0vooaXYvsQ
	 z4POOsS7x2YaQ==
Date: Thu, 04 Dec 2025 19:00:11 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Marco Elver <elver@google.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, jiayuan.chen@linux.dev, stable@vger.kernel.org, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] kasan: Unpoison vms[area] addresses with a common tag
Message-ID: <873821114a9f722ffb5d6702b94782e902883fdf.1764874575.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1764874575.git.m.wieczorretman@pm.me>
References: <cover.1764874575.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 68527f4c7d069f0e80ad4d48c006acca2241fe68
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DD56A10000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ij5rfkcih8fbbo4qk9bqjjarfr77kjsi
X-HE-Tag: 1764874817-222423
X-HE-Meta: U2FsdGVkX1/7ZBj/J8a26IG4n1GF2Rk837fcORC2G5/qfkRl8a63jsLC/X32W8XDjDrBzgVsEbGmIWBt5d33zYJv+cOetizpI5NYkUsbzxrpu51LKJwjogFGh90o8Pghsbg86WqMuOHSQN/GqjI0yeM8dOlfthuzhLkaq9jXyc7sRDkEnqVxIovcyr9n9OH2FMs+/T32Rghh/OA1h6T1Qrcjo4MEjdMj83slvfIpi0rWZGHUpiQLZL/MM5zRUdTYxtihB1zjze8Q7H4FsHOrvhIzqMron6BOs1Npalpqj4aF2GQiaFblbRKkWtI/a9tXaYQoNjrYeK9lOE8SseoVHy1Y33oDk3SS+n7SoqSi7PMPnh4TUbVPo0VifSAs5X+AMDxkbg+uw9vLZAtMq+FZOITQRDdB0sTOeMAGQgg5rw2Q8YuOkrcmZ+op+C7VHcRF8PkCL3BK6b/MKBTueFfwCsglQjwblNVtTp9SZ3ksNA6jSkacUol7l+mn4mpGUAD4bslkyHdxCLaqQjB+rxMcOREY/Wi2R/NKY3zKM0DBe1TF2MkRUZV62vFL36TAB4pZNYuFoXcR4+H+oYIgy1h6OhqCcilUGiZpxc9EfG9Io1Xnbkr9dPRjO8nnjFoYD0iQwwvq5XtWCbwhbMzhQLCozBK6YCJLCZkplddwrpP7MuVzUfXa2rhbfbvz2Rb+2N0pHzuUaXfH1TrT4m/8sjon5YIeMEW6DvYkHG+CwG3uB3HHnjHSYlCY01+sPNfG4JUVz44eGrbQ8obNjLfg3Ph92WT/uyq/72zeP80dc7JmcN7ztKq/bPHG6npdFnRkZQvoMXf85m/fszlgraddOPRcjyIadDjhsbWufb/pjGgF5Cehb8/2CmfQeN3YQh20cOh6VgDGeCP3AZPoU/eNOz4KkMMDEX02DDJg28Y11nNENP3TFIY9lrYie4CnoJO8ku6Yu12elb4qSxheBzgOqNe
 uAgqZCVn
 pEBhHB5vjMUPsDoiiCJ6azAlfycUnV921+UhPFwPrMzK72FCQzU47x7DUCbWev503GQ4/kJvC/iBEdGHR/H2eVewwfyiHx11ro1CB5DCGJ7im6gZxbRdBC7vEVPo2WXhpWSeLEM2Krpb/K2QMQy7NfB1UDyZ4nIM18gCMhPNVgrPxY8FrBjFlnRMu1sk1mwAZe+NcJCdt7nTJlwk8Y5XRaS5w8e8KJz/ZDEBbGSa/N6mCsl+8jRtW+trmvz4aXZEH0jIvnkm7JuJYUkHIPsJwiDNx6pBf/LxMIkVgIDnLsUk72nuoCz6v4m9duv5r/5KGpPLbQq0esL/bKoQ=
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
Cc: <stable@vger.kernel.org> # 6.1+
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v3:
- Redo the patch by using a flag instead of a new argument in
  __kasan_unpoison_vmalloc() (Andrey Konovalov)

Changelog v2:
- Revise the whole patch to match the fixed refactorization from the
  first patch.

Changelog v1:
- Rewrite the patch message to point at the user impact of the issue.
- Move helper to common.c so it can be compiled in all KASAN modes.

 mm/kasan/common.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index 1ed6289d471a..496bb2c56911 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -591,11 +591,28 @@ void __kasan_unpoison_vmap_areas(struct vm_struct **v=
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
+=09if (flags & KASAN_VMALLOC_KEEP_TAG) {
+=09=09pr_warn("KASAN_VMALLOC_KEEP_TAG flag shouldn't be already set!\n");
+=09=09return;
+=09}
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



