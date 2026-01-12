Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB20FCF45B2
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 17:28:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A9A56B0095; Mon, 12 Jan 2026 12:28:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 353A36B0096; Mon, 12 Jan 2026 12:28:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25CCA6B0098; Mon, 12 Jan 2026 12:28:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 167416B0095
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:28:39 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D246C13BCBD
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:28:38 +0000 (UTC)
X-FDA: 84323996316.25.91D563A
Received: from mail-24417.protonmail.ch (mail-24417.protonmail.ch [109.224.244.17])
	by imf18.hostedemail.com (Postfix) with ESMTP id 00FBD1C0010
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:28:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=G4blWAFk;
	spf=pass (imf18.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.17 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768238917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/xH0MFGMknW13Vj90S8r/ENniLRp7vgZ605IVSOXpxk=;
	b=fddw6GDKFCxy856zXw8sPoyY27QfVRUHfilGgt6in5/RSgTcG1J+Q7KbxljT4AP1wa2ilH
	w25KX8OR7MihjOIZBrfBnxMptm5iN1L2r0KUwAraSg6e1L3KoSRXLLnEHgLj5L/u/+6EXc
	q+JoRfdckww5ACrTSt1MbJQN5+h42I8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=G4blWAFk;
	spf=pass (imf18.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.17 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768238917; a=rsa-sha256;
	cv=none;
	b=mXJy/8fwwEDLrSoC0Wuz+E1zKA/onldsO86JOkIWr2scALqJmoVvJgbHkT4CZGr9BPuhdV
	1yCHtnJE7ukZTYPA+sRC5uOo6D+1BYYPofwd63HcaWnxj1CKxxqwGjYIqiTpaUfyhgNv00
	c38DiF7QnpUlToeXG9/MwGV068uAmPw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1768238912; x=1768498112;
	bh=/xH0MFGMknW13Vj90S8r/ENniLRp7vgZ605IVSOXpxk=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=G4blWAFk5byNfXW6sc8JClrQD1Yo2joQbK9NwSd9/F+bao7hBWObosKIhX0h+Dzm+
	 l7NnKw1ApP3F/gjuBosm6jHB3W1LMFULfRIbQ/thydJ3OPRh0CsvfB1qxJDMFknnfp
	 y2K4tUyJ8k63pdYGoQt4FtIhqa7Y9Us1pSZCf7Qqoe80joX+Inqsy2f9OOdKYcbJld
	 U8Y++Psvuv+5YoSxY6GVJ7IDbiS9b9x8F4reEedI2UgMdZQg4/8uPbSxJIbhwADE00
	 2Qs1U9Ygtp/XXT0oeDwuIWKs5jW0kG00mCIc4+9GHqTxjo7exCxEgveBBWh4grh4Y4
	 UpkbwRx2UxEBw==
Date: Mon, 12 Jan 2026 17:28:29 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v8 13/14] x86/kasan: Logical bit shift for kasan_mem_to_shadow
Message-ID: <b1dcc32aa58fd94196885842e0e7f7501182a7c4.1768233085.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1768233085.git.m.wieczorretman@pm.me>
References: <cover.1768233085.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: ebf057f553a2e357d38ef3e18edf71ca7fe2c8c0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 00FBD1C0010
X-Stat-Signature: nuq9utyhxwu9d6y8idqtb1uuh1bqyks5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768238916-219211
X-HE-Meta: U2FsdGVkX18zbqrDwXxdyZyu3NdxWJ7K4UHhiFAZOfAoChRasvds8WQtkEer0vuE2U+6sYueDwo61EjkVkE/x4S9QBR0AKIdxZ4JGN8kTRzWA4pDcVWo9/5zC6n2dEh5UjKR3CePZ8R36oTRDuUGW0O2KGC20kUL4bvzQnrhm/aNsQ4fgF10OgiZTH4rhCRW/1BIlT7m82MDBm+OoOj/rPneu9zMBwz4lsFAMDzDcZMbxKz1vEKbX69HuzRdlxDHZ2N5GrkBOCbk/i4UZc6kPo38bpeepIpk9FOeBVG37Sy6jwjBvTwbGT8IlUgBoq+p/5M+tr5DYg6p/Kv1E8HxYqASkU9ltr8Ad/+gd3p9Zd5dVxWkYY9aSN8I33hY7rvQcwDinTESYmd31LVulf2pO/Yp0wtZrnlSOby1SQhxAgn9Xcs1Q3z0SqdutInvMfLSQHr7jItzUYaASv91qf9Mndhpd6OCMcFUO4AGOXm/ggfZMSrh2bl74/Lc60GRyiqUdUmVXv0JOEU1uiazNGfLgB9UCk9pdS/OSY57g1XWKIi9F+bx8756BSG7p8+MZS+8slwc+1gd6AwQvn8fxLXCpqz2dJmQqsFV8MFKTV5UiTC1P3JYBpdDYUkFEw14k3lwFKl/190XqMvRU6tbERte03S6MRqdg9Ve5QU2QIaFs1KMSHvRBJSx3O4e8wb3PswC/ppYez7XZznTp72mcaiC0uBzIF3xZwzU7DBFYfu9SLA4/vdM3K2IpOZFWbLoVdz1fWwoXo17u6mgOBIzfk/HoY8pAhilPVZs475+G5d9RCQWNG4EDLRmOgtRIahFcTVo8CnUYOQTc0igobRQnJRJfzGRFTrnzka6SJns7scGNkDAsXGNG+kF9knNam3zS8B2GIZOYAQ9Gz2zva8puL35oyJtSB2i9f8vG4RHmeVYAeYad6d0RK7Jslw9k1NJxDi+JZt7CT3IseB4o8N3ViB
 et8iOSpP
 DQL9ir3Qv/avSG61fMzhMfaNkEE12xG7CPx6jbTfv13kHvPOMiEvQRWJWfF9ZYHm2W1tXo0dNuy9oEYnRONrDP49BW12CtOG7wF0NsJ2tl8a82s9cuNzYvVo3RWLVgFH7LWtOQwIK9NODMUIbxXXWbqDATF8Zg4uwrJm2coV8b91g0xZs8Mn7EXFJtR13JUT2qRN92LdRNyFuMiRXCHLWzr0ja3zzkq+LvxcLN/HOCAS3XKXosQH9AmvKxEq9Dz7HMRz46f71D+/Y3ak0EN6BRiDNTGHot+EI51cYrukP+XWRX1nBOWkscxQlYfZZBvsWkQ6x3gitx32zAI8abDq0rdbsUnysw5JPuaJzB6sqkLUSYw8Dh8rWg7o1M3LYSP9Ont/kyt/iz9P1lns=
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
index eab12527ed7f..9b7951a79753 100644
--- a/arch/x86/include/asm/kasan.h
+++ b/arch/x86/include/asm/kasan.h
@@ -31,6 +31,21 @@
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



