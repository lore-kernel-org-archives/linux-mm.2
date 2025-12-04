Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EFEED29FAE
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 19:00:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A5C36B0010; Thu,  4 Dec 2025 14:00:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 455C96B008C; Thu,  4 Dec 2025 14:00:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36C246B009D; Thu,  4 Dec 2025 14:00:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1F9D46B0010
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:00:07 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C1857B8490
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:00:06 +0000 (UTC)
X-FDA: 84182703612.10.AEC5936
Received: from mail-43103.protonmail.ch (mail-43103.protonmail.ch [185.70.43.103])
	by imf20.hostedemail.com (Postfix) with ESMTP id C4D4E1C0021
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:00:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=ReCyGiNT;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf20.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.103 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764874805; a=rsa-sha256;
	cv=none;
	b=4uX4VGXYeyTOLcmKLcokAS5x70OGADQALBPbIUVaLaUYlfaUJNZWDGm6lSHiLux/W+ShnB
	JqATWWPhkQzABD5prWzbeX1fbb3JJoK7sUVwFoq6WOSCTcZDwN5OFIGujnc8Mf8vO1imEF
	kkIKhkT8tlNoZRAR1eqr3UYfF3rWy3A=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=ReCyGiNT;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf20.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.103 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764874805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bhwcCfVXLxvJTjdvRA/wCu8iamjahYD6lETVGfCcvog=;
	b=o8D/3YtmAOydwhBjT6B+54BQA9WbJnlVCGO16An8Rw3Lyr4HSoD7MSOB+VFNSCN3cFH5a5
	x3GdZb48MfOoqkk1kl1fu1SO52V79HxIJjQw9zDl65VxsiWL6IWaPaZNBsXoxsly8BAAh7
	hB+HhbIJLYd0vId5UoSPUjijksHQHpQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1764874802; x=1765134002;
	bh=bhwcCfVXLxvJTjdvRA/wCu8iamjahYD6lETVGfCcvog=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=ReCyGiNTpYIBd1A6Q2im8TqP1U3Q6/hR1SbkzZ+pjsxoLxG9I6vfkLtZYqNMayfkR
	 y2u/zg7R7dZxX6e0GOGtXN2bRTlh2RSLU/E74LU0KU9+AzpdOzOGlejXOxDoONQXmt
	 bfb8o4vYCj+QmFq6k4DCx9xqnbN2rsG3QbuL/MWu5LK8snoXrP2diHfVB7dwYVBzIJ
	 iiS8X4rXcRzmvqbV+qP7iYDx7aZZLDkbIIbekkDG4xB6NJAwxXfGeJPyQrR+NrpFOO
	 H9+V6yiB328EWnB5NFvQSiTBXY30B2Ch+8CjrzBFKzcmGEwuyD9oBX9QIpiU9ljNQF
	 JlLP7j+ymnBUA==
Date: Thu, 04 Dec 2025 18:59:55 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, Danilo Krummrich <dakr@kernel.org>, Kees Cook <kees@kernel.org>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, jiayuan.chen@linux.dev, syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v3 1/3] mm/kasan: Fix incorrect unpoisoning in vrealloc for KASAN
Message-ID: <38dece0a4074c43e48150d1e242f8242c73bf1a5.1764874575.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1764874575.git.m.wieczorretman@pm.me>
References: <cover.1764874575.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: a4419e9b3fef3fe2260aceee3124e0bc104820b2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C4D4E1C0021
X-Stat-Signature: jdc5h8c17w5gk8opgmosntg9ia78hk74
X-Rspam-User: 
X-HE-Tag: 1764874804-963655
X-HE-Meta: U2FsdGVkX1/Iu2vh8MM8n9kb9YuJnnREAGHWNn5WAEYfJCqAHyr285sGazsv9qYk0B0sr4ztAepoF0kkpesHK1CjuQ/mQEjilDvJEUWHJUle9+NSHqyu4pecIOLmlXMhn1nw2GXZ+SzAeQneDugY2iAu2pHi+u4LRnVi232Vf+Vxff/7Crf+zGf796roHQBaPknLkpDfE2Y5OUg2g5s36zwVJ9q33yn//I8iBpahK40a3stL6mXd1isKBg0ID8lXoZgK+AsMisXgDRLd9NscAUtt5If5b8wNBXXzSlWKKCQj29B8yM5G4tSAYFbfHJB1i6cmDczPguPv647WROwmEDt0vFfMA/CE08nw05mwH1jAoO96DcVEc8b1U1BtrLNSKvg9bGcDt/v2IfXzoQf1Nht0HxL6JpFaydwjWcU14H/rQEE9rVj6izQsqZC3m6k2gFGxtzIq1XlitsGHey/kTq3mzwbT7Y4vYjh6bEi3E3bAh8nYJLC6udgFhJ0/51eV+jpiGVZSSAAeXYxpHeiiXtM0naZXqGUJt8mO+Qvo9RoPjNoMNklQL7rflbmuRyDBTUs+A6fZPoCYT6S/IP8cVhqQdghWNzypcTjRM6X8pNcWjUh9aQVtb1SFA992MSClxjVes1x9orxnoZ0CPJQzqXueBPYd3PoZrQ/aQF/2oqIj4MxdRPLB0P382vr+L4gCA7+keCI/9mnrOyV/LrrdP6IYa+RxBtEt3CNOorvONBrmPAQY7QJvPgJsJLee+WsNcKyvu+h35J4aKEbxWY50gFs0T74inWewlmINz6GDdhTryHd1ucd3LHGfY+vy8YZkrt2EghscsRcOZS20qlbfMw/P6jE8gaBsyIY+1gBDY4amke8GGl/lS7kS/jzSQxjqhFeDgsyWGvd1EpJRyxG+bkkl2LlUh1cQfQ4BADzC2ATwqrpRak6pLrTx2SDKcqdJOA6rDHts1ZfpbKo4Xux
 tpt802EL
 FW8vOrx7oAq4dE8DVOQqYFpHlaykdzp6U6XmhABePkLJBJ8O7vDYbqAbfK1JeRbGp7o3tWMMIh0N0EVz83qw2GfO9Ce4WQjObLmrwPSe6V7TW5duNWicWmQnJHMEFM+yAyECMVVc7njz/dG8Sy1cyIqCNKTHqMG4Yvt9w9pQZqs46cfspUpt2+ezSCiiDeBkuw6QhxndoqNCQJB3QA10ddjcSqBTFAMJLugOkX5FkLLWtBIM6cM7LKykXxxi60esdPmSx4+felx9TluI6gW0JPDcuWA4rwFXptMIIC6QUEz5jDScYKONqp9RnmpC6SI5cxUOu/wxEjxjh1YRfExazPjFedeG7XCJWmZRayG7DKUdoZGlA3a6Gu/+6onpHMJ+ae+0oJVAaZT6wnNktNjdmJNGFRnrPovLrJlD2NRBG1d6Os8UfTxStxfMWxQGvDDPHO8Ze2CRGMnDixN4=
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
Reported-by: syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68e243a2.050a0220.1696c6.007d.GAE@googl=
e.com/T/
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Co-developed-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
 include/linux/kasan.h | 1 +
 mm/kasan/hw_tags.c    | 2 +-
 mm/kasan/shadow.c     | 4 +++-
 mm/vmalloc.c          | 4 +++-
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index d12e1a5f5a9a..6d7972bb390c 100644
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
index 5d2a876035d6..5e47ae7fdd59 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -648,7 +648,9 @@ void *__kasan_unpoison_vmalloc(const void *start, unsig=
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
index 798b2ed21e46..22a73a087135 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4176,7 +4176,9 @@ void *vrealloc_node_align_noprof(const void *p, size_=
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



