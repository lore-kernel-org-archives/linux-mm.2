Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 967A4D44C7F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 16:43:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05E066B0088; Thu, 15 Jan 2026 11:43:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00BEE6B0089; Thu, 15 Jan 2026 11:43:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4CC86B008A; Thu, 15 Jan 2026 11:43:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D19856B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:43:19 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 70A7E160412
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:43:19 +0000 (UTC)
X-FDA: 84334768518.25.AA6C833
Received: from mail-10630.protonmail.ch (mail-10630.protonmail.ch [79.135.106.30])
	by imf18.hostedemail.com (Postfix) with ESMTP id 73D611C0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:43:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=lAZsD8D3;
	spf=pass (imf18.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.30 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768495397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0mJ77Ei2Ao2nIh3bxf+lreguMZ0Ww1g/bobwuzi9ljs=;
	b=n3RJ8oU65i7D7Cb5cfyLBYMqe7T6+erwrwMXWYx23zOtJ4ou0z8jNbLUwRad2aHe2bdywr
	favp1Dg67//US202yVD2uNbRH7cCNI5ovbR+q037OKxA5nWKXTtosniB+3pFfDwyqykeI5
	0pg1Mv3ogL/TZEXUhE+MtwRqwX86du4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=lAZsD8D3;
	spf=pass (imf18.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.30 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768495397; a=rsa-sha256;
	cv=none;
	b=vLt0P6WJ9nnaXlQUmGRGmUG+0Kan2jqF8SMKF1anSqnN/FfsifTbbWJ9FKkprqQl4+BvcL
	knimXcXYaYNSABA6OrxMELcwSsJmpRKoEzOXhDrHEer0TH5mazPaPU/Wi1awzqNVWXh7MN
	Ijb13cPB/IWi9vcU57LJ9kVsGhKcirM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1768495394; x=1768754594;
	bh=0mJ77Ei2Ao2nIh3bxf+lreguMZ0Ww1g/bobwuzi9ljs=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=lAZsD8D3unGZMo/Ckb/tyLKxupjS3Nhvwkfy20n2p9F3zjjen1TALC5j3tgch2rFv
	 RRDnWwR4rIGpih5Pxx3HdJirLwdxMx6DLsT7n2H+6oKHiq/xaQH/4Dqf0xOrDEyAFU
	 Ul6nnZWUE5vTSvF6EXKIAD0e3mmyoNGN+iCYAnVpldq7QV8vLHTsLW9kI0xmbCQpT2
	 Fg52ycPyGHHgifKOkowE17GbNUWDcmxDNHvc3dLyfkA/alofOAbPwzjWg513otpeMA
	 RTZHe25sGTpKbMHEEnIAAdKTN/fuTKAeQPU7SFuNDD2zaEvNBy2qZHeozR2ApLAhNm
	 4twRqSK1iE1yw==
Date: Thu, 15 Jan 2026 16:43:08 +0000
To: Andrey Konovalov <andreyknvl@gmail.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v8 13/14] x86/kasan: Logical bit shift for kasan_mem_to_shadow
Message-ID: <aWkVn8iY27APFYy_@wieczorr-mobl1.localdomain>
In-Reply-To: <CA+fCnZd4rJvKzdMPmpYmNSto_dbJ_v6fdNYv-13_vC2+bu-4bg@mail.gmail.com>
References: <cover.1768233085.git.m.wieczorretman@pm.me> <b1dcc32aa58fd94196885842e0e7f7501182a7c4.1768233085.git.m.wieczorretman@pm.me> <CA+fCnZd+ANJ2w4R7ww7GTM=92UGGFKpaL1h56iRMN2Lr14QN5w@mail.gmail.com> <aWfDiNl9-9bVrc7U@wieczorr-mobl1.localdomain> <CA+fCnZd4rJvKzdMPmpYmNSto_dbJ_v6fdNYv-13_vC2+bu-4bg@mail.gmail.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 13c6233a9439a29467710c147956a9b472747181
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: opu7mabeyyuhny9eyzuuxf53hgrde1x8
X-Rspamd-Queue-Id: 73D611C0005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768495397-228459
X-HE-Meta: U2FsdGVkX18ZbbITXVOPyxAzBgcNpooCz326BELOO/DGr0PKVpr9ZR1/V5tu/hvcZuWxfJCDqugQ3AAr4PzXW68AFqgvx2hwaMWVgawbaw0d+p8cNn5BrJQjynbnBN/hZlvthBFvlTU7C5WO2FrcygkkkZ/Jds4sSAVQvFbiJ0899JGbwl//M0fou/stlgg8x95vLUHEyt+4OhIhmL2xtyspA8akbsjAc6c+mp1DWpytgHY8e94ZudmCqOyxnAvZsqT8FQO1FgpL5B1dyvaTyKoU5QqsfX1PfasIh/iSws7/xLyOFJ34Wpskx/cEMTi9vx2S3BCOX9AyHLqVMN41PCsQ3GvRVJGVumKywSL1mjJoPZ2K9Skbn2fRsKCKdYwbRxg3xJEdUMaubW4rOWFqkJPpPpAcYJw10DvLAOpQJEYF2C8WYBdTkBbOJtMMbXVl743ruZzJncGSPV4palZR2EkCyl+Or6fUZqDMAgWyLzOkrd3j0nXg6L71mJRLRHlga3CcHjCDF4s/1M8gTHW50UG7FYCLkIIS/Jpy5ukpeU5gewPfQOzgRQIGtWL+9Ps4RShqIKrCB3mmxWwyawWwDAQfFOsIQMtttzCxmtI3cBpQNrRVjdmQVOYttAnG6jabAt1NPuzV0jWEnn0kUCDwAEN/Zc6jwA64wZHu1Jw3MaWbwu02sHUbJ5sCnou4PNQ6cZsZQhJQVSX72UXNtesLhy4hAbau0+sjw9fD6w3UjOhwtbute45xPChW96XvlqyDI8NQZJ443gLk6CsiXlCO9XXyFw/PuWHQ4bYv467prfBdClagEq96116rAEHqv9jcWd1x3cHbloNUp4Stgf9yiX4dcGLS6jLuvdoAZV/hQBH5inGQSkdltZm+tamgL/v4lzg04netyOiPf0Dj2shU0+IjIHeJ04wtWwR743oIkQsxAxf/AEq30orgfDd+cMkAXPJG0w549FT7QUHFVxi
 peOTcDQh
 19/Chz69UtxfHDquvMSe6LkHz0ZA8FxqKlHiRNgIxP1pGH2EvO+NKdL5EH7gx7MEBvwUMxR5zIPAsn05ZnBA/Re4EetDlrH+VuBxxz3u2G2T18V5ecBlilLKdPKvIOGb8YyIzjIBWrEy/jxzSXyYKrEOUDekSXzP95IF12qYo4RU93eB1ZOcbbV3wzXrK4m58YCfLx5ZHtA9sbw7rmHhW0TTZoIwnenfjTff8zGDH+9Z+Vg8YEfb+VOcFeObZzp7sumuFDSONMo2hy1IduDi3AIMrj9z5bX6t38/zhUSlNcdgvKnRx2hFfKhZOg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-15 at 04:57:15 +0100, Andrey Konovalov wrote:
>On Wed, Jan 14, 2026 at 5:52=E2=80=AFPM Maciej Wieczor-Retman
><maciej.wieczor-retman@intel.com> wrote:
>>
>> I'm a fan of trying to keep as much arch code in the arch directories.
>>
>> How about before putting a call here instead like:
>>
>>         if (IS_ENABLED(CONFIG_KASAN_GENERIC)) {
>>                 if (addr < (unsigned long)kasan_mem_to_shadow((void *)(0=
ULL)) ||
>>                     addr > (unsigned long)kasan_mem_to_shadow((void *)(~=
0ULL)))
>>                         return;
>>         }
>>
>>         arch_kasan_non_canonical_hook()
>> There would be the generic non-arch part above (and anything shared that=
 might
>> make sense here in the future) and all the arch related code would be hi=
dden in
>> the per-arch helper.
>>
>> So then we could move the part below:
>>         if (IS_ENABLED(CONFIG_KASAN_SW_TAGS) && IS_ENABLED(CONFIG_ARM64)=
) {
>>                 if (addr < (unsigned long)kasan_mem_to_shadow((void *)(0=
xFFULL << 56)) ||
>>                     addr > (unsigned long)kasan_mem_to_shadow((void *)(~=
0ULL)))
>>                         return;
>>         }
>> to /arch/arm64.
>>
>> For x86 we'd need to duplicate the generic part into
>> arch_kasan_non_canonical_hook() call in /arch/x86. That seems quiet tidy=
 to me,
>> granted the duplication isn't great but it would keep the non-arch part =
as
>> shared as possible. What do you think?
>
>Sounds good to me too, thanks!

x86 was easy to do because the kasan_mem_to_shadow() was already in the
asm/kasan.h. arm64 took a bit more changes since I had to write the
arch_kasan_non_canonical_hook in a separate file that would import the
linux/kasan.h header in order to use kasan_mem_to_shadow(). Anyway below ar=
e the
relevant bits from the patch - does that look okay? Or would you prefer som=
e
different names/placements?

diff --git a/arch/arm64/include/asm/kasan.h b/arch/arm64/include/asm/kasan.=
h
index b167e9d3da91..16b1f2ca3ea8 100644
--- a/arch/arm64/include/asm/kasan.h
+++ b/arch/arm64/include/asm/kasan.h
@@ -17,6 +17,8 @@
=20
 asmlinkage void kasan_early_init(void);
 void kasan_init(void);
+bool __arch_kasan_non_canonical_hook(unsigned long addr);
+#define arch_kasan_non_canonical_hook(addr) __arch_kasan_non_canonical_hoo=
k(addr)
=20
 #else
 static inline void kasan_init(void) { }

diff --git a/arch/arm64/mm/Makefile b/arch/arm64/mm/Makefile
index c26489cf96cd..a122ea67eced 100644
--- a/arch/arm64/mm/Makefile
+++ b/arch/arm64/mm/Makefile
@@ -15,4 +15,6 @@ obj-$(CONFIG_ARM64_GCS)=09=09+=3D gcs.o
 KASAN_SANITIZE_physaddr.o=09+=3D n
=20
 obj-$(CONFIG_KASAN)=09=09+=3D kasan_init.o
+obj-$(CONFIG_KASAN)=09=09+=3D kasan.o
 KASAN_SANITIZE_kasan_init.o=09:=3D n
+KASAN_SANITIZE_kasan.o=09=09:=3D n
diff --git a/arch/arm64/mm/kasan.c b/arch/arm64/mm/kasan.c
new file mode 100644
index 000000000000..b94d5fb480ca
--- /dev/null
+++ b/arch/arm64/mm/kasan.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * This file contains ARM64 specific KASAN code.
+ */
+
+#include <linux/kasan.h>
+
+bool __arch_kasan_non_canonical_hook(unsigned long addr) {
+=09/*
+=09 * For Software Tag-Based KASAN, kasan_mem_to_shadow() uses the
+=09 * arithmetic shift. Normally, this would make checking for a possible
+=09 * shadow address complicated, as the shadow address computation
+=09 * operation would overflow only for some memory addresses. However, du=
e
+=09 * to the chosen KASAN_SHADOW_OFFSET values and the fact the
+=09 * kasan_mem_to_shadow() only operates on pointers with the tag reset,
+=09 * the overflow always happens.
+=09 *
+=09 * For arm64, the top byte of the pointer gets reset to 0xFF. Thus, the
+=09 * possible shadow addresses belong to a region that is the result of
+=09 * kasan_mem_to_shadow() applied to the memory range
+=09 * [0xFF000000000000, 0xFFFFFFFFFFFFFFFF]. Despite the overflow, the
+=09 * resulting possible shadow region is contiguous, as the overflow
+=09 * happens for both 0xFF000000000000 and 0xFFFFFFFFFFFFFFFF.
+=09 */
+=09if (IS_ENABLED(CONFIG_KASAN_SW_TAGS)) {
+=09=09if (addr < (unsigned long)kasan_mem_to_shadow((void *)(0xFFULL << 56=
)) ||
+=09=09    addr > (unsigned long)kasan_mem_to_shadow((void *)(~0ULL)))
+=09=09=09return true;
+=09}
+=09return false;
+}
diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 9c6ac4b62eb9..146eecae4e9c 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
...
@@ -403,6 +409,13 @@ static __always_inline bool kasan_check_byte(const voi=
d *addr)
 =09return true;
 }
=20
+#ifndef arch_kasan_non_canonical_hook
+static inline bool arch_kasan_non_canonical_hook(unsigned long addr)
+{
+=09return false;
+}
+#endif
+
 #else /* CONFIG_KASAN */
=20
diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 62c01b4527eb..1c4893729ff6 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -642,10 +642,19 @@ void kasan_non_canonical_hook(unsigned long addr)
 =09const char *bug_type;
=20
 =09/*
-=09 * All addresses that came as a result of the memory-to-shadow mapping
-=09 * (even for bogus pointers) must be >=3D KASAN_SHADOW_OFFSET.
+=09 * For Generic KASAN, kasan_mem_to_shadow() uses the logical right shif=
t
+=09 * and never overflows with the chosen KASAN_SHADOW_OFFSET values. Thus=
,
+=09 * the possible shadow addresses (even for bogus pointers) belong to a
+=09 * single contiguous region that is the result of kasan_mem_to_shadow()
+=09 * applied to the whole address space.
 =09 */
-=09if (addr < KASAN_SHADOW_OFFSET)
+=09if (IS_ENABLED(CONFIG_KASAN_GENERIC)) {
+=09=09if (addr < (unsigned long)kasan_mem_to_shadow((void *)(0ULL)) ||
+=09=09    addr > (unsigned long)kasan_mem_to_shadow((void *)(~0ULL)))
+=09=09=09return;
+=09}
+
+=09if(arch_kasan_non_canonical_hook(addr))
 =09=09return;

--=20
Kind regards
Maciej Wiecz=C3=B3r-Retman


