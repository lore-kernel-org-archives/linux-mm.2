Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B293D65C49
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 13:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7030F6B008A; Wed, 17 Dec 2025 08:50:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DB1A6B008C; Wed, 17 Dec 2025 08:50:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60E2E6B0092; Wed, 17 Dec 2025 08:50:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 516A26B008A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 08:50:15 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EADE21A0A72
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:50:14 +0000 (UTC)
X-FDA: 84229097148.20.A28CF2A
Received: from mail-10629.protonmail.ch (mail-10629.protonmail.ch [79.135.106.29])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1F3B2120011
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:50:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=O35IO7JW;
	spf=pass (imf29.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.29 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765979413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=srKF/LsI6PPbEJ2JymYTvJSPX0AgbkVbHs9iEZzuI9A=;
	b=nClAOrPVUZ0YbulXWgtstxzMsAfmGLvRnGCRF4Ldc3LqCW6sAxNJUzbM+w6P6j0d1kgDHi
	OilPKvsUgSKv0XDbLZXX4kHuAOpTS5LqAgKeVtau6+Rd//sKOBRytdSLKjNs+ZuJDRzdQg
	7mupPbLUrrRYrP46DSkV/b0sgfuJUe4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=O35IO7JW;
	spf=pass (imf29.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.29 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765979413; a=rsa-sha256;
	cv=none;
	b=5Wp8aO6oG2gpQj0kVnETpmOwS6heeNxU+fPf3sCK9j0JAhJWrVAZtZ3ScO8RmEhrz/wMEN
	GV8g7NMqCixw/EPh6w35URQJQSRY6CoZNABCJ52vQx2T/1NRtfHjSAUxS9oJyK/DqQ0WOf
	29pxEZ987wZPl2xDhpt1rUV8/YBgZvg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1765979411; x=1766238611;
	bh=srKF/LsI6PPbEJ2JymYTvJSPX0AgbkVbHs9iEZzuI9A=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=O35IO7JW/ro9Jo8gR76XtYsxZThKfr0wv14Xf93ZZNdm7fklI0t3DdCmInY/3tj0m
	 6iyJ2bz4kGSuHW4vOklie4rrCp9WCRHhBwrhNXBTyvOjrHEX34r2ffDwZEMUsiK440
	 Uy4krURxA7opcMjfqwegJCepZhKXv02ZjxXYouhemmHKkAR028XeZwldhMckqoG1jQ
	 8GGYyVqU/fPPmdt9oHhVi4Vczrh//kR8B9N0bOlbinBbBR60skGONF7OSnodssABEa
	 LgBXe4u0xchn12axhs42phx9Op9DETtbmIEPlqN6dIB7UYUc+dgInkDnyPgtFKSAEY
	 setwGfGp3dOcw==
Date: Wed, 17 Dec 2025 13:50:05 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>, Danilo Krummrich <dakr@kernel.org>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, stable@vger.kernel.org, syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com, Jiayuan Chen <jiayuan.chen@linux.dev>, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v5 1/3] mm/kasan: Fix incorrect unpoisoning in vrealloc for KASAN
Message-ID: <3f851f7704ab8468530f384b901b22cdef94aa43.1765978969.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1765978969.git.m.wieczorretman@pm.me>
References: <cover.1765978969.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 0bc86e18ec967a34de1512b770ea99c717647150
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Stat-Signature: 81iw6b73a3igix6c56qpa1osh51j7z61
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F3B2120011
X-HE-Tag: 1765979412-453421
X-HE-Meta: U2FsdGVkX19GyXZcH+/7mtsD9JQLvXKrnppqfJ9zGTCDzin+1mgCjWgY679Xg+bTv+lgaPnKZqvwmpQYzoEr+BMjXcHHTbEzArs6bZmPOYLxYHuh5AkQYy76pRhTfhmm2D1ScZB8JI2KrMDlCR4bBpqutMQQRyT8aQVlLDNkLzvb41BVZO4uFSftKUeKaQIQoHNeznN8+sSLaljTAyMAQIptPngfgbs/IKabH6sqaWStLiTZGR+vSmKtyvspS/9J8UwqKvz7nkvxSzvA3kaNhYmQSpB/dIrijOypi865ncQMWdfKiLjudzimzfDFHgkubPRpn6xNI9Tiwkiz4Lekc+Mt6i1T+jbHr3qiMuHwT74m0ha0MpdYlI3GTgp0JT+ote1OhRUrV4ZPgGF0drZhD8jdP+qxX/CEjDBRk6BDTLWBtlwVIjjfLuLM65f1Gtvxc01nyF+VqD9SCRWrNXnIuDzEPMvLwLV8U2amKYnTs7SG2i/3wW/wP7jQknGRSaxQE/mZDOBHWygbufJrrDf3KdxpyLiealrkeCTqKsMO6rns+rfzEqAAkTm+Xwhmtxgu+XRS8WKkxjzbsgg3y3eQDEXexGI9WZFrjr8yeaMvc7HI0DygjEUcZwZMzTM/sJhnctvapME0RvhSPuva3N+cJ0SaxcLu6TMQPikXsfuY6JzGzjeowPeFSZF76WUrf1x78BISsr2R/ihSK6iRgcXaM3fIn+q0h9X9rvxzdUB1Z9LEYrOTkK0gGRrF4bsP6l0jtLefbSuFU8Wem1ajEQvsXwuSeatg5htvM2deJ3GqDNSyRDTH4j7BnwTUAlTBmy+3uKhVbfus75z4p0ABAV0AY8zQrUbM+KEek4D4+cPoHttAWdMeL/qNZ8ZlMhLJXlCPyDNjixC384Qki7Z+YSeQFnS/ieqLizizYzDAB2SClBinGW1pM7/YZjmjKxHO37QH3UbbVir16TLwnti5xiN
 E7OKy+Iy
 wUntrLk/i5YcEn1ESCmsyrmO/xCySeDC4H1yC7jk4FQPewoCIjQbfy+Zmm1LC3owOBIWXsoe6szDDUQ8fO9ONE4MZGEsXY+sbSByG2RJb4KC/kFZ4j3OfSB24hzEa0YmJmDHuH810Z3tkO8dfZ7w7puuRVc50KyVP2Tjm4A4kf9Ir7jBJk6PcnVh9udB+4XE+asafw/IjsuFoT9tk2LmqUUQAO+Mnw/qiMPfQEdn5o62rL2y1jUi671Qzlho19cafpFSM0jR0HtC6kt/dXK8G0zO3+gL72ESy/ttc7K0wbSFZku3Xu2YyAD4QLa23m5A/keErfWqJpFJFHKGtljxsOY+0iWjwl5yEjAUzNb+ZwsYc3SLd799HTWL41WzasjRrq8k/a9S7bRvi3NGUWhzPeID1/BTRM0oYt6WxACM/n0F2TBnLgZBfFcvK3+PLGW1mg3b/NfN1McdtdzD7US2ADqDukUq8w2klG1xJy3hjoqFM3C/xSpauUGdrRTAtUluK5FaAXtPcmCKcjCc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@linux.dev>

Syzkaller reported a memory out-of-bounds bug [1]. This patch fixes two
issues:

1. In vrealloc the KASAN_VMALLOC_VM_ALLOC flag is missing when
   unpoisoning the extended region. This flag is required to correctly
   associate the allocation with KASAN's vmalloc tracking.

   Note: In contrast, vzalloc (via __vmalloc_node_range_noprof) explicitly
   sets KASAN_VMALLOC_VM_ALLOC and calls kasan_unpoison_vmalloc() with it.
   vrealloc must behave consistently =E2=80=94 especially when reusing exis=
ting
   vmalloc regions =E2=80=94 to ensure KASAN can track allocations correctl=
y.

2. When vrealloc reuses an existing vmalloc region (without allocating
   new pages) KASAN generates a new tag, which breaks tag-based memory
   access tracking.

Introduce KASAN_VMALLOC_KEEP_TAG, a new KASAN flag that allows reusing
the tag already attached to the pointer, ensuring consistent tag
behavior during reallocation.

Pass KASAN_VMALLOC_KEEP_TAG and KASAN_VMALLOC_VM_ALLOC to the
kasan_unpoison_vmalloc inside vrealloc_node_align_noprof().

[1]: https://syzkaller.appspot.com/bug?extid=3D997752115a851cb0cf36

Fixes: a0309faf1cb0 ("mm: vmalloc: support more granular vrealloc() sizing"=
)
Cc: <stable@vger.kernel.org>
Reported-by: syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68e243a2.050a0220.1696c6.007d.GAE@googl=
e.com/T/
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Co-developed-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
---
 include/linux/kasan.h | 1 +
 mm/kasan/hw_tags.c    | 2 +-
 mm/kasan/shadow.c     | 4 +++-
 mm/vmalloc.c          | 4 +++-
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index f335c1d7b61d..df3d8567dde9 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -28,6 +28,7 @@ typedef unsigned int __bitwise kasan_vmalloc_flags_t;
 #define KASAN_VMALLOC_INIT=09=09((__force kasan_vmalloc_flags_t)0x01u)
 #define KASAN_VMALLOC_VM_ALLOC=09=09((__force kasan_vmalloc_flags_t)0x02u)
 #define KASAN_VMALLOC_PROT_NORMAL=09((__force kasan_vmalloc_flags_t)0x04u)
+#define KASAN_VMALLOC_KEEP_TAG=09=09((__force kasan_vmalloc_flags_t)0x08u)
=20
 #define KASAN_VMALLOC_PAGE_RANGE 0x1 /* Apply exsiting page range */
 #define KASAN_VMALLOC_TLB_FLUSH  0x2 /* TLB flush */
diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
index 1c373cc4b3fa..cbef5e450954 100644
--- a/mm/kasan/hw_tags.c
+++ b/mm/kasan/hw_tags.c
@@ -361,7 +361,7 @@ void *__kasan_unpoison_vmalloc(const void *start, unsig=
ned long size,
 =09=09return (void *)start;
 =09}
=20
-=09tag =3D kasan_random_tag();
+=09tag =3D (flags & KASAN_VMALLOC_KEEP_TAG) ? get_tag(start) : kasan_rando=
m_tag();
 =09start =3D set_tag(start, tag);
=20
 =09/* Unpoison and initialize memory up to size. */
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index 29a751a8a08d..32fbdf759ea2 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -631,7 +631,9 @@ void *__kasan_unpoison_vmalloc(const void *start, unsig=
ned long size,
 =09    !(flags & KASAN_VMALLOC_PROT_NORMAL))
 =09=09return (void *)start;
=20
-=09start =3D set_tag(start, kasan_random_tag());
+=09if (unlikely(!(flags & KASAN_VMALLOC_KEEP_TAG)))
+=09=09start =3D set_tag(start, kasan_random_tag());
+
 =09kasan_unpoison(start, size, false);
 =09return (void *)start;
 }
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ecbac900c35f..94c0a9262a46 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4331,7 +4331,9 @@ void *vrealloc_node_align_noprof(const void *p, size_=
t size, unsigned long align
 =09 */
 =09if (size <=3D alloced_size) {
 =09=09kasan_unpoison_vmalloc(p + old_size, size - old_size,
-=09=09=09=09       KASAN_VMALLOC_PROT_NORMAL);
+=09=09=09=09       KASAN_VMALLOC_PROT_NORMAL |
+=09=09=09=09       KASAN_VMALLOC_VM_ALLOC |
+=09=09=09=09       KASAN_VMALLOC_KEEP_TAG);
 =09=09/*
 =09=09 * No need to zero memory here, as unused memory will have
 =09=09 * already been zeroed at initial allocation time or during
--=20
2.52.0



