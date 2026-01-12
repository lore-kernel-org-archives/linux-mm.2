Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09382CF45B2
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 17:27:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DF486B0089; Mon, 12 Jan 2026 12:27:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 689366B008C; Mon, 12 Jan 2026 12:27:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 567BA6B0092; Mon, 12 Jan 2026 12:27:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 499B66B0089
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:27:52 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 117ADBB961
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:27:52 +0000 (UTC)
X-FDA: 84323994384.18.ED4FEA0
Received: from mail-106119.protonmail.ch (mail-106119.protonmail.ch [79.135.106.119])
	by imf13.hostedemail.com (Postfix) with ESMTP id 17B9720005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:27:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=E0ml2UWO;
	spf=pass (imf13.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.119 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768238870; a=rsa-sha256;
	cv=none;
	b=MqpMnuiwl8a9uzmlvbMXhwuNxLPnugvlJZWdxRwML42pnjInRvAtoONMgIgFTiAlfGpwsz
	u7aCClRkUwvajnv4rIfRP+5FVMmAYXDpP4qbRm8QBJ3NFwPp5+LEfynZJBfrISxABFqDI2
	jfG0iCY6rIJoD7kN8LBsrr+zm7c4K34=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=E0ml2UWO;
	spf=pass (imf13.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.119 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768238870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yESMxyUg3nEjWhMgjSTmmglxLz0NhSPoNJMpCNZiqMs=;
	b=uBHTq/eXi/Uk7xSbMd+a8kVGK/MvAtrEVN0pTYYj5KNMnD6OpBScswMu2mieJwVGCMqUzE
	2NzjIkR+Ze06ioEGzDbo9rakaGv5fGoNE/7gQsXsgPMczekheFm/00CGLVjt/g+BqHYJSe
	BSGKhxOL1xbbLL0ZRt0Gj6L4Bq16rMo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1768238867; x=1768498067;
	bh=yESMxyUg3nEjWhMgjSTmmglxLz0NhSPoNJMpCNZiqMs=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=E0ml2UWO0gaxz3PTlf5/zQnrEZwbNK1fh90WlTa6MRRxNcNMudGUpmXCGS3M43yvJ
	 v3HX/WOpOlX9oJbHzJhPhS4APnzjFNJnoy1deGRnXpXtkUFzZniYhHHp/FaXdEMc7E
	 0sMy/Msr7YzONOEnaGMVxr1Nhvt90ikcXoMs0GlLRKyqoQuyehKnbo8xm49ydX/HWd
	 ScRWr5adodhfyXmAcnMPre9jyC8WWhwh2P9Pbn0O4Zf4qszckK5DporB8Ci6CFVYJU
	 6/86ZdNwyYkqKpqAJRGc1G2BOUxMPRw8XN6LT218d003Ct6KHLbq7ghHQ73zaGQzYj
	 vDbo+AfBRb5Dg==
Date: Mon, 12 Jan 2026 17:27:43 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v8 04/14] x86/kasan: Add arch specific kasan functions
Message-ID: <785eb728e2cc897e05ee709d42214172be481ab9.1768233085.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1768233085.git.m.wieczorretman@pm.me>
References: <cover.1768233085.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 10432f028dc5aec035899d14c4ef5f6e6dbe8005
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 17B9720005
X-Stat-Signature: yafjo5yq74faznhzz4sjmfac6fewscgh
X-Rspam-User: 
X-HE-Tag: 1768238869-915635
X-HE-Meta: U2FsdGVkX1+y+fnNcC3X0KR2KZyfNp4Ixv/QMCl98XeJ50DQwuZ/HKA5B51qY/qduklzZ1JFXp1PXJxpuIV8UejpZj1idmpst57XCPxyUtoDgwWqsk/lyRzlwpAPT+0toYrJ3bZdY6sj/8pNy6+vVFg6juDAKX16NPHjUjGJYuME2BP1O6X2PmI+VobbXXqf33NDyIfCq4qdX3DO3QLj9UnFa+/3WFJMwRxOfUU5HfG+dqo4wOFGqJCv6YMdWf4DHkhOjyFdFjGK6Ybzizh7HpgavrShHD4/XadiA4L+ld/USBgpDiyf7BeTyK1xWS0my7fqlM/dwLBY3Z9omdtIvc+pSxztMLbH0We7ECvdPBNqZyY+fBEVxibzdsj9PVE/4FRlBogrDV4VongMgwytTOKbY4BVyGRWPpqTdotn5r5GhuBDh3GflzQlQa58ZX3+OBR8sjCocg99XusE+/IP2np4cG4BByuhcr91cD+gCqFqBoms64K0PWO+4YOJFVkBrcpVVth/vbfk7Xf3Wh8uDXrK4i/V5VvN4EAx0VHx/L35euloWB8mELLOKGRlsEx33uLSEd6jN3TWVGocMQhZ4USDfH3z+/7Hnalb0o8X+4iTb6GmfSoBX/RH3MO1Wh3BR7oQ/cbPSGqpyM45eWL3DhsiU/I9a7q6Jh4i0W4WCFd+Z/lEZD7LbVAYqMHSM60eT7TrvTf//Y2aeybx6pikWYYqfYAOuKAAV7+7usSHZtLSutBuyXSENdp6QBrUyP0pm/U3bc3hFiN8gRbZunTp3rR29unkyQbPR3ppNK8mMJJKpPbT8S3pksUA+oVYG2vyjOvBgP0VHdBf91ITYMHytA1Z3FCongCv8IcJ1ONjIbGTZdP4DHuuhtHdCkYiVAJJrWcrYeBBaTSZx/adcmZHYJ7NZSmQlN2cxstXIP1sfHygswkKPzgbn5d3AWwfQZgQk79v/akuZzRJrobm+ks
 AZUgYYRA
 HaIUNZm1oOrwzBfeSHpqPClWAg3I+sjrB0pDCV2N6PiaTIW3xhX+wjfew3zaPNfah/kUzMILaKD80X+FzadWiqxY1sBLY6cAv9OWm7qe39uEOZqYhP7N3X3aBElqjeHYeHAmajJ55ToxUBH3GCJyxmDHaSG9POGUjn8DK23mVEx10J3eRZqurtVuJ5Iot2H+RiUwKj7ZmDJhSMNvgtRjrebrfSVhGr6ZWBwqKiZMsivZ3xs2uREOODm/MOqqwIygCVEIbJ4/FySX16Euoy6JMTJcymwAToRoDAVuFIzApLosyzziPSp1F7by6BseH8Ye/0aWSa9VRsir8+VLEQlcLaN2j3w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

KASAN's software tag-based mode needs multiple macros/functions to
handle tag and pointer interactions - to set, retrieve and reset tags
from the top bits of a pointer.

Mimic functions currently used by arm64 but change the tag's position to
bits [60:57] in the pointer.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v7:
- Add KASAN_TAG_BYTE_MASK to avoid circular includes and avoid removing
  KASAN_TAG_MASK from mmzone.h.
- Remove Andrey's Acked-by tag.

Changelog v6:
- Remove empty line after ifdef CONFIG_KASAN_SW_TAGS
- Add ifdef 64 bit to avoid problems in vdso32.
- Add Andrey's Acked-by tag.

Changelog v4:
- Rewrite __tag_set() without pointless casts and make it more readable.

Changelog v3:
- Reorder functions so that __tag_*() etc are above the
  arch_kasan_*() ones.
- Remove CONFIG_KASAN condition from __tag_set()

 arch/x86/include/asm/kasan.h | 42 ++++++++++++++++++++++++++++++++++--
 include/linux/kasan-tags.h   |  2 ++
 include/linux/mmzone.h       |  2 +-
 3 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kasan.h b/arch/x86/include/asm/kasan.h
index d7e33c7f096b..eab12527ed7f 100644
--- a/arch/x86/include/asm/kasan.h
+++ b/arch/x86/include/asm/kasan.h
@@ -3,6 +3,8 @@
 #define _ASM_X86_KASAN_H
=20
 #include <linux/const.h>
+#include <linux/kasan-tags.h>
+#include <linux/types.h>
 #define KASAN_SHADOW_OFFSET _AC(CONFIG_KASAN_SHADOW_OFFSET, UL)
 #define KASAN_SHADOW_SCALE_SHIFT 3
=20
@@ -24,8 +26,43 @@
 =09=09=09=09=09=09  KASAN_SHADOW_SCALE_SHIFT)))
=20
 #ifndef __ASSEMBLER__
+#include <linux/bitops.h>
+#include <linux/bitfield.h>
+#include <linux/bits.h>
+
+#ifdef CONFIG_KASAN_SW_TAGS
+#define __tag_shifted(tag)=09=09FIELD_PREP(GENMASK_ULL(60, 57), tag)
+#define __tag_reset(addr)=09=09(sign_extend64((u64)(addr), 56))
+#define __tag_get(addr)=09=09=09((u8)FIELD_GET(GENMASK_ULL(60, 57), (u64)a=
ddr))
+#else
+#define __tag_shifted(tag)=09=090UL
+#define __tag_reset(addr)=09=09(addr)
+#define __tag_get(addr)=09=09=090
+#endif /* CONFIG_KASAN_SW_TAGS */
+
+#ifdef CONFIG_64BIT
+static inline void *__tag_set(const void *__addr, u8 tag)
+{
+=09u64 addr =3D (u64)__addr;
+
+=09addr &=3D ~__tag_shifted(KASAN_TAG_BYTE_MASK);
+=09addr |=3D __tag_shifted(tag & KASAN_TAG_BYTE_MASK);
+
+=09return (void *)addr;
+}
+#else
+static inline void *__tag_set(void *__addr, u8 tag)
+{
+=09return __addr;
+}
+#endif
+
+#define arch_kasan_set_tag(addr, tag)=09__tag_set(addr, tag)
+#define arch_kasan_reset_tag(addr)=09__tag_reset(addr)
+#define arch_kasan_get_tag(addr)=09__tag_get(addr)
=20
 #ifdef CONFIG_KASAN
+
 void __init kasan_early_init(void);
 void __init kasan_init(void);
 void __init kasan_populate_shadow_for_vaddr(void *va, size_t size, int nid=
);
@@ -34,8 +71,9 @@ static inline void kasan_early_init(void) { }
 static inline void kasan_init(void) { }
 static inline void kasan_populate_shadow_for_vaddr(void *va, size_t size,
 =09=09=09=09=09=09   int nid) { }
-#endif
=20
-#endif
+#endif /* CONFIG_KASAN */
+
+#endif /* __ASSEMBLER__ */
=20
 #endif
diff --git a/include/linux/kasan-tags.h b/include/linux/kasan-tags.h
index ad5c11950233..e4f26bec3673 100644
--- a/include/linux/kasan-tags.h
+++ b/include/linux/kasan-tags.h
@@ -10,6 +10,8 @@
 #define KASAN_TAG_WIDTH=09=090
 #endif
=20
+#define KASAN_TAG_BYTE_MASK=09((1UL << KASAN_TAG_WIDTH) - 1)
+
 #ifndef KASAN_TAG_KERNEL
 #define KASAN_TAG_KERNEL=090xFF /* native kernel pointers tag */
 #endif
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 75ef7c9f9307..3839052121d4 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1177,7 +1177,7 @@ static inline bool zone_is_empty(const struct zone *z=
one)
 #define NODES_MASK=09=09((1UL << NODES_WIDTH) - 1)
 #define SECTIONS_MASK=09=09((1UL << SECTIONS_WIDTH) - 1)
 #define LAST_CPUPID_MASK=09((1UL << LAST_CPUPID_SHIFT) - 1)
-#define KASAN_TAG_MASK=09=09((1UL << KASAN_TAG_WIDTH) - 1)
+#define KASAN_TAG_MASK=09=09KASAN_TAG_BYTE_MASK
 #define ZONEID_MASK=09=09((1UL << ZONEID_SHIFT) - 1)
=20
 static inline enum zone_type memdesc_zonenum(memdesc_flags_t flags)
--=20
2.52.0



