Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3DF4D32D98
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 14:59:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0484F6B0177; Fri,  5 Dec 2025 09:59:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01F9E6B0179; Fri,  5 Dec 2025 09:59:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E513E6B017A; Fri,  5 Dec 2025 09:59:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D12536B0177
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 09:59:50 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A9DB4132BAC
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 14:59:49 +0000 (UTC)
X-FDA: 84185726898.08.481830D
Received: from mail-244122.protonmail.ch (mail-244122.protonmail.ch [109.224.244.122])
	by imf12.hostedemail.com (Postfix) with ESMTP id 99D6140010
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 14:59:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=NvvwT+Xl;
	spf=pass (imf12.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.122 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764946787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/FxBYSqiLvEPPLBRet/OeAbti72yHyHumcmcCrArpUM=;
	b=Jz2JMp6yUsYvOTiSGe+af+FXZunlwrazm2D0ac7mSMy023JT61y5ri0XNxHZrmAmdASHdm
	eFizPkD72SO9BIMUamksy/8bedOKPeXTEtlG0DETqpmtF6cYd84KBVuHWwgIcn7WQCvpr/
	fBQ4CcrlB8Mkz8fBVYmQblbGt9mv6qw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764946787; a=rsa-sha256;
	cv=none;
	b=m2KLojr6mSxgUPEq//oTGrcq3T9uX59Bng6rLgJByP7//rfNN03U/pdkgnZNlcXS3ntWUX
	ucNURWowVk9PNydRggGz5uTm8d/589K6cd7GhcFyrizBsT3KIrXk4TT7iwnZ+eie8gAIsU
	5Z2nrfw9zUBe7n/F2X5b5waBR/HG5o4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=NvvwT+Xl;
	spf=pass (imf12.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.122 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1764946785; x=1765205985;
	bh=/FxBYSqiLvEPPLBRet/OeAbti72yHyHumcmcCrArpUM=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=NvvwT+XlqjIGjbPn28ArTuGmb2NZ/bH055y0UgAlc9MgwM3Qjhw8v4wRgOCWSF3FE
	 xxDf6vS2oJ4EbuZitnh1UD1SJBFGDVFKAamJBHAnPCYB1C8NEixS0HVlu7UdzQZYux
	 hQoL1eTYixZfwrAG9yrJN5uJZWcvEF12qKSsvMo2e3fj6LkO9kXw7A5V4ftW64J1Zq
	 5caW8XihbSl4/zFsDaes5KKg33S9eU/uo35Ys2Cp5vOY90g5seYNCtBGvAjbWJd70V
	 STfedzSroYtFp9F3B3FS8yTldpm2mEy72sSSZjWrz+yAcFJltECbtD5sARdWu8QIMw
	 LUM4XzJtpdkqA==
Date: Fri, 05 Dec 2025 14:59:05 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>, Danilo Krummrich <dakr@kernel.org>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: jiayuan.chen@linux.dev, m.wieczorretman@pm.me, stable@vger.kernel.org, syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v4 1/3] mm/kasan: Fix incorrect unpoisoning in vrealloc for KASAN
Message-ID: <247fd641cbf4a8e6c8135051772867f6bd2610ad.1764945396.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1764945396.git.m.wieczorretman@pm.me>
References: <cover.1764945396.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: d2dc6589d37d0aba1e593ab762db40d7e36c2a38
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 99D6140010
X-Stat-Signature: cxg5bwdqeq1n8k35ffxpk6q75dfbc6x4
X-HE-Tag: 1764946787-587589
X-HE-Meta: U2FsdGVkX1/KngBe+JRXVKHO1hSqbt9hGuIpgodsW0v0IwA0c9TbJb581yweY9lMK0FmerPl2yCU4NYaTgTbt5lSOxLs1JCtncoSKFr6TDJxqfr4gXcnbvboquqj+MFQwoiu10vLohWGR26AiyKKYVjl9jAtsdwepm7XZyjA+O/qPRKv0NIaMoGIVLVOjywkXmvoaLNp8i8IsEid3xoDGU4bAYS7LN3vsdPge4XuzadSsa3skUxLq/7s7DQyXmhDJxcEMZBGKrlVbX1u37+Mqn1+1an/iCYN0eMQRAxauKcBEY+Vn2U1tfuhchb/97VHnRBINNuaDLXPl3C3wgB7smaN93I9TFZfOU30kiV4fSIQXKk9SJ041nldd75ArCoVXwBENp0zNONBmyGSp9R/loPRCPIhvNES7dHOsohrh8bCkUh5bZCl5x87PcylYKvDts1h55lbD0PpA97Ufmnly1ddiJm5N4i9kn+g+n9vYxA9G5+/AEHB3iodH7I/xCDZmKQQ/AzD6m7FCK0vicfQ6xmeHO28ykbaieTpR66ZVvtumBrIywXdAMzB4c1jlPAR6KZNLK5Z65WJsFfI8iZzlu9olDSe2cBtMvIJ9jcGxaLL02UoQy5oOK5owwX6h7JxmVcqWrLezVHqNRjEMevteb3wIJulj2Dd1AsFTgN2B3j5MuLDrdnmln39qa5h7P4XuhMpA4d61I9tuTQ9kWISlv0q/Kc0tJIZKNIEBIM1oK/4hGZ694LXKTeb1LWt5EO9gwiJR8IR6rKbVAUU5O6QmJeJ5JBANW5AS2hjnXrrjUV/Uzqk3Z4tiHT0BoNEmK5PwZYKaqVYDBVPdZmwv2yZpnxKxghm1A4NnTgc6apRfvve3T8ObW0eH0Ci5ZCR0Q7jkuvI/DX3mrrXX9UHcaSAWGy3uR4XDqMZCn9Q/SYMI/86+md0e5jMyn1/nxYDISMYdoYn41dYuQ5E6/o95tP
 AzL7wiId
 OrOaynFbblMGa7XWiGtHoiSh6sX6LhP0FonERX5rYNbPg2PbuvEeR7GlEuxYOuRB11zGkoz0asWz1Qkv2uRdcLKJXIPZ8M3gA5V8kJkgIzUSBqcT8pfwFRaTEgoTjtJC02QRt4ZU4LpqcmrS3t55BtUh0znrNGac+bHFPMEjsytVsCNwFUM6+zbkyY+zgPWZdfS52I3/DmNSM2RGhtBPjgFV5TQqRjXOtwe/vxkGQIj2+8AQM5neloC4VHr3nspRTOQSmGu91ZCBBTHEYDZriiy1EKV+2wUq1t/1WXSumQ1oQfaZt+6N65L1faz+Uu8JYVHcEOB1PK5JIbg9MB6eWOFck2TOZAYVzUEShuhORnaAVj36gEms01AXC5jHDphSQgvUV4+qWzM2fQRSqbtt1y+JGHRofAzMQWC8HybczUUKur/pbDiwKoXoEmEncnas4JKkVAn1eJi9hBBfy3eKubTzHz/xwXtnEEINrYgnThD9JR3JWsb7CqSthkoY9xH4C0UhjhMsuSKXVElg=
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



