Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7946CD3C934
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 17:30:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEC5B6B0007; Wed, 10 Dec 2025 12:30:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC3B96B000D; Wed, 10 Dec 2025 12:30:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B00B16B000E; Wed, 10 Dec 2025 12:30:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9EF256B0007
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 12:30:27 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 548DEBA5D3
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 17:30:27 +0000 (UTC)
X-FDA: 84204250494.09.DBE03B7
Received: from mail-10628.protonmail.ch (mail-10628.protonmail.ch [79.135.106.28])
	by imf21.hostedemail.com (Postfix) with ESMTP id 73C4E1C0011
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 17:30:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="WwAq/3hF";
	spf=pass (imf21.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.28 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765387825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yptnXmuAYz2NtPaUpK9TGJ5xoKzD/S2RQj7G4MSwUA8=;
	b=rzJ9On9/7CtH3u8l8DZUbCTY4g8HwPY2DN4Anf7vYVWRokT746/iBTjG4V8BvssJAnSjWm
	tgGZ+T8daGpO2lCjggqWXom4bOtVswP0k5/aZordLqtqr29W8fJlu7G10cG1ZWRCz/iNW5
	1tKB6lE+6ICymybPMzj9i4EQSZWjRB8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="WwAq/3hF";
	spf=pass (imf21.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.28 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765387825; a=rsa-sha256;
	cv=none;
	b=vgrxJ8u0WQrDM9ufBOAAL5J1KF+SkVL5pMK7+huTva7j+GVvkk9gVwrXmcWwjpOJebwr8y
	F3T4Cvp4Z2QD1DrlXnABXc+UCtoDoWt1fP/bPkbwn3bVZ2pDm8DmGqUygpSH67kUs3SLnc
	TcAnNkcUWru5myZmvBB13PSAkdhLciY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1765387821; x=1765647021;
	bh=yptnXmuAYz2NtPaUpK9TGJ5xoKzD/S2RQj7G4MSwUA8=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=WwAq/3hFtfJcKKZxvwBdu9XItJzK3N0PZdKkLOTNuMcLXaEwoGzToOwklIhFKy9W+
	 tEUI7p3D6/Q7SpbI1zC842u0uNQPyV+O6JSahVe3Dcrlk2jaVwfrArkvV6omX5x5Pu
	 RSjt5T+fKVFYntwdNIipAjzqZv4sWPlvhORHx1sKsbiFSfNgyCvf5HQf00acqC7p99
	 lvV+oOQLmGXcGeYI1iJPZN5EaLbxpF9H+CYvJCoxnVf/fZVbVwkTlsgCDuc8lo7IgT
	 YU1RJDZxpzk0ghJDjGMuSzgXRi1dVmlAoAqP+WmiYD6m/oKq1DRLNMX5AmGDYnJg6V
	 zlv8G6xK1OJvg==
Date: Wed, 10 Dec 2025 17:30:14 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v7 14/15] x86/kasan: Logical bit shift for kasan_mem_to_shadow
Message-ID: <4dd0d4481bbd89d04bcc85a37a1b9d4ec08522c4.1765386422.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1765386422.git.m.wieczorretman@pm.me>
References: <cover.1765386422.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 67aeb239351e306f83687190add56130a7705643
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: o88eqzii8rtym38sajn31zsnuparrtf7
X-Rspamd-Queue-Id: 73C4E1C0011
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765387825-200971
X-HE-Meta: U2FsdGVkX19ZfCWWvT3PTU2iY0PgEks/fKXZRAWOyY1zsVEmHSo4RqJFqRVg4j6BkFBG3fWr18BEzigWaSx72HdSxh3GtrYYKdtSVcuMVB75sSL4AT6PUEYeSySwDHAVeduAIbuSBAn5gc507jZslz8nYKIeojaDP5FnVZ4iRCPOVvojRYZPqJJnZxcVbTOgZKOyCmYD4BM9hJnNNdKeaHOiQiw84OYf63lpae2BQYIGIpcPDSfuKaK4jPJtO/lzRoXNTLPKNuXYcY5ipLaPxICWhzTIl80EXr6lDvvf0KqOhrXQ3KHk8E+JlKvL8Ap4QRNXMvM1HFBSwvGzoOzvwrqAFGNmwtlv0nEgm09FzDeBjapEug12kLnIS0pmY1SjgveIwUHyk8LLki9YOLjxGs8fMo8st7AtGQYlVIhKergXyz0FKqzlS+xuLIDhAzHusnF9/uzobAOeNjJk9MA0nx5SdvAz7MMzQM/tU+sCq6zi6YCK5a6rfTUPo1wbV3WoobT4JfyRHRC7EjlPcxBkWc7skvPn21Up4jNf/WaFGiQfxaCsYbAzCjw/XH0vTPOCHD+Jv+9tUM69nGz1WiqFrIfgnkIo7Px7CsY8P8lXgheKoPwrIaWAsEnBzngpT27Y3T3S1AbYAwMqwUjA5+2rjSV12etTMxuMInDsHhn2pPVfAtR3cnMSGCnR2tXA7bxZN1csB9i12lZ9fIVzS4cTHb2HDAVtk4V2pc/0Mzo7ftZwTCycAAZjc6ReDH0e/B41+EUYjEHo/Md0IL9L3GSjBbwE/qWMQwFsvTNbL0GpmxGGo/FR21KPMIQ2wWWrV+5k64SgiYHUdq0ETqazJMdlLe6WXuGzcCy2UY68Q4P3tSK4Q/Og40BvGzxXdmkgshwqnWP1TPb3/5wCUMcN7ql1uIO//FK8GVGQznItGRU+W3PI/u0o/ACA3AdN4RYr4yOGqWpAYjqNUSwDeQEzzfg
 tmIwBDRu
 B9HjqpXB5ngPADZ2DA+/ijC+NQWMH102GMzgERHqHYN2T9MoIZtyDdvTjKVPhK9k0zgg1kICWGCHSIbNgeAbIFUmf5gVoHTkqBjp0a8au0rCM8Z5zcfS7uPxlrrywGDgOem1Hpr/jOWxWz7rXznAX7BI9W51ow+NoWn0Fk7OXgCMMIPPT6jQHXZNhq5mHqAbw9VDZIcid3PsBs+K/LgNYfGaGHlXwuiGaO6zMo71O0k1VXts9cbBctajKab4Kpdk30aplqNvPFSkmQtoRqTvHv5/aesr2Z71+AjgEwnAfNG304BtXVYfB8TZQUVr0++/kFipCFY9zk+PR0cvM+x1kqC5DMmHNGIwUyUlIBAJI3qdkpc4Plm1jVIflLNdhXm+MnhI8m1/paMrLn9k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

The tag-based KASAN adopts an arithemitc bit shift to convert a memory
address to a shadow memory address. While it makes a lot of sense on
arm64, it doesn't work well for all cases on x86 - either the
non-canonical hook becomes quite complex for different paging levels, or
the inline mode would need a lot more adjustments. Thus the best working
scheme is the logical bit shift and non-canonical shadow offset that x86
uses for generic KASAN, of course adjusted for the increased granularity
from 8 to 16 bytes.

Add an arch specific implementation of kasan_mem_to_shadow() that uses
the logical bit shift.

The non-canonical hook tries to calculate whether an address came from
kasan_mem_to_shadow(). First it checks whether this address fits into
the legal set of values possible to output from the mem to shadow
function.

Tie both generic and tag-based x86 KASAN modes to the address range
check associated with generic KASAN.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v7:
- Redo the patch message and add a comment to __kasan_mem_to_shadow() to
  provide better explanation on why x86 doesn't work well with the
  arithemitc bit shift approach (Marco).

Changelog v4:
- Add this patch to the series.

 arch/x86/include/asm/kasan.h | 15 +++++++++++++++
 mm/kasan/report.c            |  5 +++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kasan.h b/arch/x86/include/asm/kasan.h
index 6e083d45770d..395e133d551d 100644
--- a/arch/x86/include/asm/kasan.h
+++ b/arch/x86/include/asm/kasan.h
@@ -49,6 +49,21 @@
 #include <linux/bits.h>
=20
 #ifdef CONFIG_KASAN_SW_TAGS
+/*
+ * Using the non-arch specific implementation of __kasan_mem_to_shadow() w=
ith a
+ * arithmetic bit shift can cause high code complexity in KASAN's non-cano=
nical
+ * hook for x86 or might not work for some paging level and KASAN mode
+ * combinations. The inline mode compiler support could also suffer from h=
igher
+ * complexity for no specific benefit. Therefore the generic mode's logica=
l
+ * shift implementation is used.
+ */
+static inline void *__kasan_mem_to_shadow(const void *addr)
+{
+=09return (void *)((unsigned long)addr >> KASAN_SHADOW_SCALE_SHIFT)
+=09=09+ KASAN_SHADOW_OFFSET;
+}
+
+#define kasan_mem_to_shadow(addr)=09__kasan_mem_to_shadow(addr)
 #define __tag_shifted(tag)=09=09FIELD_PREP(GENMASK_ULL(60, 57), tag)
 #define __tag_reset(addr)=09=09(sign_extend64((u64)(addr), 56))
 #define __tag_get(addr)=09=09=09((u8)FIELD_GET(GENMASK_ULL(60, 57), (u64)a=
ddr))
diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index b5beb1b10bd2..db6a9a3d01b2 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -642,13 +642,14 @@ void kasan_non_canonical_hook(unsigned long addr)
 =09const char *bug_type;
=20
 =09/*
-=09 * For Generic KASAN, kasan_mem_to_shadow() uses the logical right shif=
t
+=09 * For Generic KASAN and Software Tag-Based mode on the x86
+=09 * architecture, kasan_mem_to_shadow() uses the logical right shift
 =09 * and never overflows with the chosen KASAN_SHADOW_OFFSET values (on
 =09 * both x86 and arm64). Thus, the possible shadow addresses (even for
 =09 * bogus pointers) belong to a single contiguous region that is the
 =09 * result of kasan_mem_to_shadow() applied to the whole address space.
 =09 */
-=09if (IS_ENABLED(CONFIG_KASAN_GENERIC)) {
+=09if (IS_ENABLED(CONFIG_KASAN_GENERIC) || IS_ENABLED(CONFIG_X86_64)) {
 =09=09if (addr < (unsigned long)kasan_mem_to_shadow((void *)(0ULL)) ||
 =09=09    addr > (unsigned long)kasan_mem_to_shadow((void *)(~0ULL)))
 =09=09=09return;
--=20
2.52.0



