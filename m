Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08DFFCFD2F6
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 14:29:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6501E6B0012; Tue,  2 Dec 2025 09:29:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 600ED6B0022; Tue,  2 Dec 2025 09:29:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C89D6B0024; Tue,  2 Dec 2025 09:29:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 376546B0012
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 09:29:40 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0EBFE1A0174
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 14:29:38 +0000 (UTC)
X-FDA: 84174764436.21.98E1EEF
Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2B9CB18001F
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 14:29:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=OLO1VZQq;
	spf=pass (imf16.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.22 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764685776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N+YMyXrUIDlvdwT88k+hzchw//5574kLYOWxbowQd+Y=;
	b=k1I/j0+iqZZ+v0s6GaWRQ0Z+Hxs3Ya72dKBX9M3ldTtnPCLbpMzLlZ4mMHNl6QLxCACvx1
	9lfhRTkQR9Pm9nkhOmdQHo3rEtZETWSbgEVXriyP9XOj4/I25+k0l1L+z9WndbdMA4rkJd
	/BcUbG7B8d1vz7BsjCI4w1xpm1OcYc8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=OLO1VZQq;
	spf=pass (imf16.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.22 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764685776; a=rsa-sha256;
	cv=none;
	b=OKhJxQ9DFOh/2MVkqxmSWT9xktFB9BpHVAwpJC39f8ZEallfVoQ1IY9RE+5v0UiKuqr7zm
	NKIwxY0F1/pGXT7Auu7DQzVQvY3En3vPj45Q0LohqZDTfoQnnYYEAaCy6TJ3LJ5NfRvmat
	XTwiWXeJe0mq4PP8JE3eL0+c8BZxdhs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1764685774; x=1764944974;
	bh=N+YMyXrUIDlvdwT88k+hzchw//5574kLYOWxbowQd+Y=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=OLO1VZQqFWzj+DN9B0D2HPGIJo+ITebJMu7zH98a5j/ALNxRNFtR+KtxeEpUYnUgB
	 6bc8rY5Ac12NLTP29EQHiQ2xDycv7DznWVLU2LeZohPZZb5TrYqWk4JUjZEvV1DWqz
	 TqDc444iZBFbQyKrpRqF7fd/MMr9eycaleu+XL7kgm3VG9xAxsSjSkbukfpFoUClMH
	 HbGT1NBt1av02FxLJEUMiz8W18hTVfzVv0chKYNjWfir42/0O6H0OGaHbCpj1ALicE
	 ziqDFswMLPEbGob8rKY+iRYfRqes/U7TFCaeUPQKkuEhihhor8zcKeNa3HG7uQZNeU
	 293qcGZFqQFQw==
Date: Tue, 02 Dec 2025 14:29:28 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Marco Elver <elver@google.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Maciej Wieczor-Retman <m.wieczorretman@pm.me>, stable@vger.kernel.org, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] kasan: Unpoison vms[area] addresses with a common tag
Message-ID: <325c5fa1043408f1afe94abab202cde9878240c5.1764685296.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1764685296.git.m.wieczorretman@pm.me>
References: <cover.1764685296.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 87d59c9c44924853cf81bc1e8bd9a2df71af726c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2B9CB18001F
X-Rspamd-Server: rspam02
X-Stat-Signature: fixfgwq5fsic5ejkye55jigoj4a98ymh
X-Rspam-User: 
X-HE-Tag: 1764685775-342107
X-HE-Meta: U2FsdGVkX1/+aa178EHsXiDQ7F23+VHH2p61E50Dt0yBeGN/GJMe6pV1CGrM8dcF4OCIkrDm3TMNsPCtm14UVOhe3IyDh0EoHHxuck/1i7IDfMK1+p/kBu4m2N0kT3Q4TRgdKrIVuhwioEq6HATPlBTiLPFPmLlNQxyDOVtvOOcrvih3hiQ7WRgyL9Cck8I0HH/EhIeNgoAF7rf1HI6EBpHaAdSrCyan9H4sh6oEn6zRjbI/khF+qO/efNS756vp7uFWAu57Bdo3c1DJh6v4ZPjaRz8Z1PbQB3gamF/cdpsMYv4VxutSdgAsZOLftNac3qxGQNuDFECeKxAamSG3HnGBjXtJwp0cA9lqryvZU4COq/y7Y8Pzel9wjtroQZ6WFTR5zz21L0gdb7oD56aA/KydY+QRZMG/tB5CP7gXWDZeHQBhpwhATKNfBLMwswYuJ3z7uEbtmrDBQPlpyaYZfE/LBRu4hDGMs2Nv86qUO5Uuy9inSYf5fancQ2wJyOqxQPNung3yqOgSV8ZFSmtF80e3e1bewxZPHPN4sVeo+MF4Hflw5zFtAtK5XBTQtHb30FvZ43TYk9qie6VDfdqCUbxMsB8OwxjSWMkOo165e9TS24cCHMNXN1qJEnbLtfuKRbZxC1ur+NrSFtCi/gMwh2+LBN9zMyonDACTiTLKqnt1tg+EWWDe2GxZQi41ZTME8n0Oi/7Sx8OL+gRta0R5Uwtfa9OI0mwMf72CdQmmRjk+8fh8OddaXxna5aRGCYEuYtfPGpOJerIryTzhRvCDg0QPIgLkxarazkElNHvygXiz5sm+qFdFltsPG/4xeTILGbA7Oe1Q/rrkyW5KY4uD34Ngekw+1g/QtA4hQw8WaRyq5MLPwnZ1r/1CDNj/ENypAdZVcM0Q3OjQw9bh0VF0DmhclBnsBMxLX2fXXgXWY1fpOEkiP1lrvy0kiAu12Pxy1tRx+ThMFMsha40LIzm
 g48OTxcI
 oVjKx9NXPMeC+NCrhLpLSxwVOGemivR7e4mZU/i04EivHrwE2nY6++fW1YEJOVQstyBDJ32wAtKbCBX9bkdkIwiQxFHmwRRQ1mj60Mxed6RUciqGuHA+vHTtb9QV1VG5U+3n6CMaQ6uMpCUcETu65Tk6eIGh1UPs0d/SHJO2v4mJ9C651ej3HPB+SSOZHD2a2+0iHEj+CR2bcHliqiYuG/N28Ytu3x+FXx0/P3cuFC9Jz2Ss66qUQpN3zSZeD2sT3mh7vCGX8osmXUQVJHUSYKnUfdkzUmN1Z+t/tWNlmR+HoxNL7kf4jKRXV8rPbcOWaYjnW0sZ60HFaCBU=
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

Use the modified __kasan_unpoison_vmalloc() to pass the tag of the first
vm_struct's address when vm_structs are unpoisoned in
pcpu_get_vm_areas(). Assigning a common tag resolves the pcpu chunk
address mismatch.

Fixes: 1d96320f8d53 ("kasan, vmalloc: add vmalloc tagging for SW_TAGS")
Cc: <stable@vger.kernel.org> # 6.1+
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v2:
- Revise the whole patch to match the fixed refactorization from the
  first patch.

Changelog v1:
- Rewrite the patch message to point at the user impact of the issue.
- Move helper to common.c so it can be compiled in all KASAN modes.

 mm/kasan/common.c  |  3 ++-
 mm/kasan/hw_tags.c | 12 ++++++++----
 mm/kasan/shadow.c  | 15 +++++++++++----
 3 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index 7884ea7d13f9..e5a867a5670b 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -591,11 +591,12 @@ void kasan_unpoison_vmap_areas(struct vm_struct **vms=
, int nr_vms,
 =09unsigned long size;
 =09void *addr;
 =09int area;
+=09u8 tag =3D get_tag(vms[0]->addr);
=20
 =09for (area =3D 0 ; area < nr_vms ; area++) {
 =09=09size =3D vms[area]->size;
 =09=09addr =3D vms[area]->addr;
-=09=09vms[area]->addr =3D __kasan_unpoison_vmap_areas(addr, size, flags);
+=09=09vms[area]->addr =3D __kasan_unpoison_vmap_areas(addr, size, flags, t=
ag);
 =09}
 }
 #endif
diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
index 4b7936a2bd6f..2a02b898b9d8 100644
--- a/mm/kasan/hw_tags.c
+++ b/mm/kasan/hw_tags.c
@@ -317,7 +317,7 @@ static void init_vmalloc_pages(const void *start, unsig=
ned long size)
 }
=20
 static void *__kasan_unpoison_vmalloc(const void *start, unsigned long siz=
e,
-=09=09=09=09      kasan_vmalloc_flags_t flags)
+=09=09=09=09      kasan_vmalloc_flags_t flags, int unpoison_tag)
 {
 =09u8 tag;
 =09unsigned long redzone_start, redzone_size;
@@ -361,7 +361,11 @@ static void *__kasan_unpoison_vmalloc(const void *star=
t, unsigned long size,
 =09=09return (void *)start;
 =09}
=20
-=09tag =3D kasan_random_tag();
+=09if (unpoison_tag < 0)
+=09=09tag =3D kasan_random_tag();
+=09else
+=09=09tag =3D unpoison_tag;
+
 =09start =3D set_tag(start, tag);
=20
 =09/* Unpoison and initialize memory up to size. */
@@ -390,7 +394,7 @@ static void *__kasan_unpoison_vmalloc(const void *start=
, unsigned long size,
 void *__kasan_random_unpoison_vmalloc(const void *start, unsigned long siz=
e,
 =09=09=09=09      kasan_vmalloc_flags_t flags)
 {
-=09return __kasan_unpoison_vmalloc(start, size, flags);
+=09return __kasan_unpoison_vmalloc(start, size, flags, -1);
 }
=20
 void __kasan_poison_vmalloc(const void *start, unsigned long size)
@@ -405,7 +409,7 @@ void __kasan_poison_vmalloc(const void *start, unsigned=
 long size)
 void *__kasan_unpoison_vmap_areas(void *addr, unsigned long size,
 =09=09=09=09  kasan_vmalloc_flags_t flags, u8 tag)
 {
-=09return __kasan_unpoison_vmalloc(addr, size, flags);
+=09return __kasan_unpoison_vmalloc(addr, size, flags, tag);
 }
 #endif
=20
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index 0a8d8bf6e9cf..7a66ffc1d5b3 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -625,8 +625,10 @@ void kasan_release_vmalloc(unsigned long start, unsign=
ed long end,
 }
=20
 static void *__kasan_unpoison_vmalloc(const void *start, unsigned long siz=
e,
-=09=09=09=09      kasan_vmalloc_flags_t flags)
+=09=09=09=09      kasan_vmalloc_flags_t flags, int unpoison_tag)
 {
+=09u8 tag;
+
 =09/*
 =09 * Software KASAN modes unpoison both VM_ALLOC and non-VM_ALLOC
 =09 * mappings, so the KASAN_VMALLOC_VM_ALLOC flag is ignored.
@@ -648,7 +650,12 @@ static void *__kasan_unpoison_vmalloc(const void *star=
t, unsigned long size,
 =09    !(flags & KASAN_VMALLOC_PROT_NORMAL))
 =09=09return (void *)start;
=20
-=09start =3D set_tag(start, kasan_random_tag());
+=09if (unpoison_tag < 0)
+=09=09tag =3D kasan_random_tag();
+=09else
+=09=09tag =3D unpoison_tag;
+
+=09start =3D set_tag(start, tag);
 =09kasan_unpoison(start, size, false);
 =09return (void *)start;
 }
@@ -656,13 +663,13 @@ static void *__kasan_unpoison_vmalloc(const void *sta=
rt, unsigned long size,
 void *__kasan_random_unpoison_vmalloc(const void *start, unsigned long siz=
e,
 =09=09=09=09      kasan_vmalloc_flags_t flags)
 {
-=09return __kasan_unpoison_vmalloc(start, size, flags);
+=09return __kasan_unpoison_vmalloc(start, size, flags, -1);
 }
=20
 void *__kasan_unpoison_vmap_areas(void *addr, unsigned long size,
 =09=09=09=09  kasan_vmalloc_flags_t flags, u8 tag)
 {
-=09return __kasan_unpoison_vmalloc(addr, size, flags);
+=09return __kasan_unpoison_vmalloc(addr, size, flags, tag);
 }
=20
 /*
--=20
2.52.0



