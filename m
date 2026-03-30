Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A15771061B05
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 14:33:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 141506B008C; Mon, 30 Mar 2026 10:33:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1188A6B0096; Mon, 30 Mar 2026 10:33:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 054F86B0098; Mon, 30 Mar 2026 10:33:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E6D0A6B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:33:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A78E713A6FE
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:33:14 +0000 (UTC)
X-FDA: 84602971908.28.71205FB
Received: from mail-24417.protonmail.ch (mail-24417.protonmail.ch [109.224.244.17])
	by imf23.hostedemail.com (Postfix) with ESMTP id 90FF714000A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:33:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=kt1RTrdd;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf23.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.17 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774881192; a=rsa-sha256;
	cv=none;
	b=dk7AUyEbLSG08yu6wys7bGAUW7z2CoO/htk3/dNIsA3+fulNCBIUAcZK2c8LEy0peMYl8p
	qmI1QkLMEmWdL+HbH8gJQPNWsbgvBQAh7DKlr5Q+t4pMvUgCsKzcLpf+Bwst2hJsAIIBqI
	D2yaXj6hKMaWRpE/G1/wzNGsH4kfNag=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=kt1RTrdd;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf23.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.17 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774881192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jVsC+rspioS0w86d9U8mtCfZpTXD4fMS7/g1bcI2b7A=;
	b=wAedCVzKxxcKioCJ1sW9QHoNAXdLph6bIs8oMDEXwLRZq1KNVSKmAxMkvJP7xiX3FCTTAz
	Kts9ggL0YFPNFrsAYuF9aT55Zw2D7r1gNWfVB51Bz6Xb1KiwF97SK0iQBlYKKKZItI8hqd
	T4xUVFeAmzxlqAyJ6hMNhLe/dSS/s+s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1774881190; x=1775140390;
	bh=jVsC+rspioS0w86d9U8mtCfZpTXD4fMS7/g1bcI2b7A=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=kt1RTrddpYQQJdv+yx0oYChQW4qrPJGn0+wGIYJd4Ympw8DhOcXUHy2/DcL7cSY3w
	 6aExOe+pEz7KcRIegYu0F0ySYtAuuuM36x7MImGqiX+dWF13bmQhzWtlLWsuw0KXMU
	 e2QM28Ad0tteuGY1T5+N//Sj3WnQezxGmYemOSsaEQYoCXa8aNxOi/+OTVyNZSDuiU
	 GvhkWvy4e75STELDNz9jwUeuIxCfPe0LmH12ne1DCi+T/jPRXD6ei2aCmg1yADrCv3
	 W/cjar+ReN+0QMxZlgZ5YGDQ/u1xBKxF3xzETujpLMSRrgeUvbd2CRual9sMUApHqH
	 aV2LhSE3XgxDQ==
Date: Mon, 30 Mar 2026 14:33:05 +0000
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, Samuel Holland <samuel.holland@sifive.com>, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, workflows@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev
Subject: [PATCH v12 01/15] kasan: sw_tags: Use arithmetic shift for shadow computation
Message-ID: <c36fe46e1dde1a759e8ffdd0fe9439bdf2c66dd8.1774872838.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1774872838.git.m.wieczorretman@pm.me>
References: <cover.1774872838.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: a0e6649a43bc470d0d645b061def5e8973771c8d
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: tm35hogkaigzag4b4fi81btph61xot91
X-Rspamd-Queue-Id: 90FF714000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774881192-452436
X-HE-Meta: U2FsdGVkX19sAbVnCsoLNA9NIqjnv0x1OqHqIxamocOQ2abu0Y+45hGOW9Py5uumhKQbftAUkZOD7oAxwQrbixnUH37p1cB1IdDD8HAtRJ5XOgQVocBBq6HAvFBZD9R29ei5s6PaLjErr0R7X0H1qA7+Z9i8C7fsDsUhVV6VTeLLfFaq7W6PYoosxQIuTvPU76zXMfXfieShdjiqYLhVSxny5R+DmXsbnKHuHRI4vrmDcdhSkPzp2RfKI4lJZx1N3PmcWiStgQCH0FNSqw7sEJDU6rpAevXzRSaSzIFUiw3RHwl/v4SP3jR5nAVowyK2GeAaZtR3tzbJVNlJPukOSqy2m1Nmj+qu7B28AEbWn2FXmJQD2IdEa1dxV+eeSEvDawZlNFPdmWeH+uivpNV0+6BglNnKcg4ilQGSq1D5EoN/o2sQMAmBagDUbdB5a6ED0pGQMreUQOOeKC9AxRn5v64iT17A9wGNCRd/h1Npz46z/AYt5Cbc+QW6MBOmk5k/EdpHtdXqNoqnshDvdoItR/ap+njsIQl3be7RPsDbnRp7RvZp1kL1vmm8UntTSJLZzuF8QIGoI/wiazEOoeOLqV9Lqut6OrQYqmsxopkrnO/cDs9p61fWI18kr3Z8wGXYJs28AfDcr+MZkPmwTho4hF832p7XGiquxPM6SHfLGyB9STVZbGf+h/9PX7vP2Nw8TLfoN1XUwON7jsUSehoDBfbpX73NI96pDDnYxMauCLSPK5eb+5zP8f4pSm6j8nwd5XaEkKZXSAOowrx/H/c+n30VmeEP4MmnC8NYAJYxjSIy8AiHyyP+AnUSblanjf77hZMnai73EUpbVopgRgJQzoiz0QcJDl8zlT8EmmD48vmt0X7ulO/bKoXDttF1zYMt1C1iVO4uogIaFq5BXWYK1hNlPOj+qaODhodof0Lbkxrqy37FlZC9eBArV9vIeQFY3E/C9MpCfZzJnaNG/3j
 cL9Ttljk
 rctH4hDafTI06c+qUJDWuQfhwVfvj9Fcve4wusazXl4makYRB1FNEwArBD2zulHxHhq5MwyYAOZJ/mcrsZFlDFpcpyhriM+sjXzluXg+M5udzEWdgg93jUFQnYhAbuvEzW6S+vQL8tVQD3eiF6Wc6pqaZDr6ThRkD5YVHm2N0rWGr+TFAEHGjZbpkeSOCQZNEYpfiedVeeweRWdCRDZXLI7qOWtQwOrdyC6UD4emR2ny1WjZKrxwVe7ut1VhO+DrwnJID6OD5vPE4Fkw/WuBPn/+gcNhWC3/2QAgXCid+76w4Eve3ftJEUnJqgxyZyK2ox9kZ30pzHm6utNKFQr4CO1OwdDIkK7njTMMFllCgvrdZRqVvfFlP8sKuFfpVMnvvEwftVzY7nxBQCKQ4Gk8Aru9Fp4SQjheOODUJySpSDlqV4pTuzI+anVOr7sDE963HChtJpmmDGcPnAzBHnNlNs70G0WHoBstbLZUSwTr9g5Zqm6tl8RFq6vJxaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Samuel Holland <samuel.holland@sifive.com>

Currently, kasan_mem_to_shadow() uses a logical right shift, which turns
canonical kernel addresses into non-canonical addresses by clearing the
high KASAN_SHADOW_SCALE_SHIFT bits. The value of KASAN_SHADOW_OFFSET is
then chosen so that the addition results in a canonical address for the
shadow memory.

For KASAN_GENERIC, this shift/add combination is ABI with the compiler,
because KASAN_SHADOW_OFFSET is used in compiler-generated inline tag
checks[1], which must only attempt to dereference canonical addresses.

However, for KASAN_SW_TAGS there is some freedom to change the algorithm
without breaking the ABI. Because TBI is enabled for kernel addresses,
the top bits of shadow memory addresses computed during tag checks are
irrelevant, and so likewise are the top bits of KASAN_SHADOW_OFFSET.
This is demonstrated by the fact that LLVM uses a logical right shift in
the tag check fast path[2] but a sbfx (signed bitfield extract)
instruction in the slow path[3] without causing any issues.

Use an arithmetic shift in kasan_mem_to_shadow() as it provides a number
of benefits:

1) The memory layout doesn't change but is easier to understand.
KASAN_SHADOW_OFFSET becomes a canonical memory address, and the shifted
pointer becomes a negative offset, so KASAN_SHADOW_OFFSET =3D=3D
KASAN_SHADOW_END regardless of the shift amount or the size of the
virtual address space.

2) KASAN_SHADOW_OFFSET becomes a simpler constant, requiring only one
instruction to load instead of two. Since it must be loaded in each
function with a tag check, this decreases kernel text size by 0.5%.

3) This shift and the sign extension from kasan_reset_tag() can be
combined into a single sbfx instruction. When this same algorithm change
is applied to the compiler, it removes an instruction from each inline
tag check, further reducing kernel text size by an additional 4.6%.

These benefits extend to other architectures as well. On RISC-V, where
the baseline ISA does not shifted addition or have an equivalent to the
sbfx instruction, loading KASAN_SHADOW_OFFSET is reduced from 3 to 2
instructions, and kasan_mem_to_shadow(kasan_reset_tag(addr)) similarly
combines two consecutive right shifts.

Link: https://github.com/llvm/llvm-project/blob/llvmorg-20-init/llvm/lib/Tr=
ansforms/Instrumentation/AddressSanitizer.cpp#L1316 [1]
Link: https://github.com/llvm/llvm-project/blob/llvmorg-20-init/llvm/lib/Tr=
ansforms/Instrumentation/HWAddressSanitizer.cpp#L895 [2]
Link: https://github.com/llvm/llvm-project/blob/llvmorg-20-init/llvm/lib/Ta=
rget/AArch64/AArch64AsmPrinter.cpp#L669 [3]
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Co-developed-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v11: (Maciej)
- Remove the arch_kasan_non_canonical_hook() scheme in favor of Andrey
  Ryabinin's much nicer simple implementation.

Changelog v10: (Maciej)
- Update the Documentation/dev-tools/kasan.rst file with the changed
  kasan_mem_to_shadow().

Changelog v9: (Maciej)
- Take out the arm64 related code from mm/kasan/report.c and put it in
  the arch specific directory in a new file so the kasan_mem_to_shadow()
  function can be included.
- Reset addr tag bits in arm64's arch_kasan_non_canonical_hook() so the
  inline mode can also work with that function (Andrey Ryabinin).
- Fix incorrect number of zeros in a comment in mm/kasan/report.c.
- Remove Catalin's acked-by since changes were made.

Changelog v7: (Maciej)
- Change UL to ULL in report.c to fix some compilation warnings.

Changelog v6: (Maciej)
- Add Catalin's acked-by.
- Move x86 gdb snippet here from the last patch.

Changelog v5: (Maciej)
- (u64) -> (unsigned long) in report.c

Changelog v4: (Maciej)
- Revert x86 to signed mem_to_shadow mapping.
- Remove last two paragraphs since they were just poorer duplication of
  the comments in kasan_non_canonical_hook().

Changelog v3: (Maciej)
- Fix scripts/gdb/linux/kasan.py so the new signed mem_to_shadow() is
  reflected there.
- Fix Documentation/arch/arm64/kasan-offsets.sh to take new offsets into
  account.
- Made changes to the kasan_non_canonical_hook() according to upstream
  discussion. Settled on overflow on both ranges and separate checks for
  x86 and arm.

Changelog v2: (Maciej)
- Correct address range that's checked in kasan_non_canonical_hook().
  Adjust the comment inside.
- Remove part of comment from arch/arm64/include/asm/memory.h.
- Append patch message paragraph about the overflow in
  kasan_non_canonical_hook().

 Documentation/arch/arm64/kasan-offsets.sh |  8 ++++++--
 Documentation/dev-tools/kasan.rst         | 18 ++++++++++++------
 arch/arm64/Kconfig                        | 10 +++++-----
 arch/arm64/include/asm/memory.h           | 14 +++++++++++++-
 arch/arm64/mm/kasan_init.c                |  7 +++++--
 include/linux/kasan.h                     | 10 ++++++++--
 mm/kasan/report.c                         | 16 ++++++++++++----
 scripts/gdb/linux/kasan.py                |  5 ++++-
 scripts/gdb/linux/mm.py                   |  5 +++--
 9 files changed, 68 insertions(+), 25 deletions(-)

diff --git a/Documentation/arch/arm64/kasan-offsets.sh b/Documentation/arch=
/arm64/kasan-offsets.sh
index 2dc5f9e18039..ce777c7c7804 100644
--- a/Documentation/arch/arm64/kasan-offsets.sh
+++ b/Documentation/arch/arm64/kasan-offsets.sh
@@ -5,8 +5,12 @@
=20
 print_kasan_offset () {
 =09printf "%02d\t" $1
-=09printf "0x%08x00000000\n" $(( (0xffffffff & (-1 << ($1 - 1 - 32))) \
-=09=09=09- (1 << (64 - 32 - $2)) ))
+=09if [[ $2 -ne 4 ]] then
+=09=09printf "0x%08x00000000\n" $(( (0xffffffff & (-1 << ($1 - 1 - 32))) \
+=09=09=09=09- (1 << (64 - 32 - $2)) ))
+=09else
+=09=09printf "0x%08x00000000\n" $(( (0xffffffff & (-1 << ($1 - 1 - 32))) )=
)
+=09fi
 }
=20
 echo KASAN_SHADOW_SCALE_SHIFT =3D 3
diff --git a/Documentation/dev-tools/kasan.rst b/Documentation/dev-tools/ka=
san.rst
index 4968b2aa60c8..b11c1be8dff4 100644
--- a/Documentation/dev-tools/kasan.rst
+++ b/Documentation/dev-tools/kasan.rst
@@ -315,13 +315,19 @@ translate a memory address to its corresponding shado=
w address.
 Here is the function which translates an address to its corresponding shad=
ow
 address::
=20
-    static inline void *kasan_mem_to_shadow(const void *addr)
-    {
-=09return (void *)((unsigned long)addr >> KASAN_SHADOW_SCALE_SHIFT)
-=09=09+ KASAN_SHADOW_OFFSET;
-    }
+        static inline void *kasan_mem_to_shadow(const void *addr)
+        {
+                void *scaled;
=20
-where ``KASAN_SHADOW_SCALE_SHIFT =3D 3``.
+                if (IS_ENABLED(CONFIG_KASAN_GENERIC))
+                        scaled =3D (void *)((unsigned long)addr >> KASAN_S=
HADOW_SCALE_SHIFT);
+                else
+                        scaled =3D (void *)((long)addr >> KASAN_SHADOW_SCA=
LE_SHIFT);
+
+                return KASAN_SHADOW_OFFSET + scaled;
+        }
+
+where for Generic KASAN ``KASAN_SHADOW_SCALE_SHIFT =3D 3``.
=20
 Compile-time instrumentation is used to insert memory access checks. Compi=
ler
 inserts function calls (``__asan_load*(addr)``, ``__asan_store*(addr)``) b=
efore
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index bcd9f5bc66e2..87239396ed23 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -434,11 +434,11 @@ config KASAN_SHADOW_OFFSET
 =09default 0xdffffe0000000000 if ARM64_VA_BITS_42 && !KASAN_SW_TAGS
 =09default 0xdfffffc000000000 if ARM64_VA_BITS_39 && !KASAN_SW_TAGS
 =09default 0xdffffff800000000 if ARM64_VA_BITS_36 && !KASAN_SW_TAGS
-=09default 0xefff800000000000 if (ARM64_VA_BITS_48 || (ARM64_VA_BITS_52 &&=
 !ARM64_16K_PAGES)) && KASAN_SW_TAGS
-=09default 0xefffc00000000000 if (ARM64_VA_BITS_47 || ARM64_VA_BITS_52) &&=
 ARM64_16K_PAGES && KASAN_SW_TAGS
-=09default 0xeffffe0000000000 if ARM64_VA_BITS_42 && KASAN_SW_TAGS
-=09default 0xefffffc000000000 if ARM64_VA_BITS_39 && KASAN_SW_TAGS
-=09default 0xeffffff800000000 if ARM64_VA_BITS_36 && KASAN_SW_TAGS
+=09default 0xffff800000000000 if (ARM64_VA_BITS_48 || (ARM64_VA_BITS_52 &&=
 !ARM64_16K_PAGES)) && KASAN_SW_TAGS
+=09default 0xffffc00000000000 if (ARM64_VA_BITS_47 || ARM64_VA_BITS_52) &&=
 ARM64_16K_PAGES && KASAN_SW_TAGS
+=09default 0xfffffe0000000000 if ARM64_VA_BITS_42 && KASAN_SW_TAGS
+=09default 0xffffffc000000000 if ARM64_VA_BITS_39 && KASAN_SW_TAGS
+=09default 0xfffffff800000000 if ARM64_VA_BITS_36 && KASAN_SW_TAGS
 =09default 0xffffffffffffffff
=20
 config UNWIND_TABLES
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memor=
y.h
index a2b7a33966ff..875c0bd0d85a 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -89,7 +89,15 @@
  *
  * KASAN_SHADOW_END is defined first as the shadow address that correspond=
s to
  * the upper bound of possible virtual kernel memory addresses UL(1) << 64
- * according to the mapping formula.
+ * according to the mapping formula. For Generic KASAN, the address in the
+ * mapping formula is treated as unsigned (part of the compiler's ABI), so=
 the
+ * end of the shadow memory region is at a large positive offset from
+ * KASAN_SHADOW_OFFSET. For Software Tag-Based KASAN, the address in the
+ * formula is treated as signed. Since all kernel addresses are negative, =
they
+ * map to shadow memory below KASAN_SHADOW_OFFSET, making KASAN_SHADOW_OFF=
SET
+ * itself the end of the shadow memory region. (User pointers are positive=
 and
+ * would map to shadow memory above KASAN_SHADOW_OFFSET, but shadow memory=
 is
+ * not allocated for them.)
  *
  * KASAN_SHADOW_START is defined second based on KASAN_SHADOW_END. The sha=
dow
  * memory start must map to the lowest possible kernel virtual memory addr=
ess
@@ -100,7 +108,11 @@
  */
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 #define KASAN_SHADOW_OFFSET=09_AC(CONFIG_KASAN_SHADOW_OFFSET, UL)
+#ifdef CONFIG_KASAN_GENERIC
 #define KASAN_SHADOW_END=09((UL(1) << (64 - KASAN_SHADOW_SCALE_SHIFT)) + K=
ASAN_SHADOW_OFFSET)
+#else
+#define KASAN_SHADOW_END=09KASAN_SHADOW_OFFSET
+#endif
 #define _KASAN_SHADOW_START(va)=09(KASAN_SHADOW_END - (UL(1) << ((va) - KA=
SAN_SHADOW_SCALE_SHIFT)))
 #define KASAN_SHADOW_START=09_KASAN_SHADOW_START(vabits_actual)
 #define PAGE_END=09=09KASAN_SHADOW_START
diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
index abeb81bf6ebd..937f6eb8115b 100644
--- a/arch/arm64/mm/kasan_init.c
+++ b/arch/arm64/mm/kasan_init.c
@@ -198,8 +198,11 @@ static bool __init root_level_aligned(u64 addr)
 /* The early shadow maps everything to a single page of zeroes */
 asmlinkage void __init kasan_early_init(void)
 {
-=09BUILD_BUG_ON(KASAN_SHADOW_OFFSET !=3D
-=09=09KASAN_SHADOW_END - (1UL << (64 - KASAN_SHADOW_SCALE_SHIFT)));
+=09if (IS_ENABLED(CONFIG_KASAN_GENERIC))
+=09=09BUILD_BUG_ON(KASAN_SHADOW_OFFSET !=3D
+=09=09=09KASAN_SHADOW_END - (1UL << (64 - KASAN_SHADOW_SCALE_SHIFT)));
+=09else
+=09=09BUILD_BUG_ON(KASAN_SHADOW_OFFSET !=3D KASAN_SHADOW_END);
 =09BUILD_BUG_ON(!IS_ALIGNED(_KASAN_SHADOW_START(VA_BITS), SHADOW_ALIGN));
 =09BUILD_BUG_ON(!IS_ALIGNED(_KASAN_SHADOW_START(VA_BITS_MIN), SHADOW_ALIGN=
));
 =09BUILD_BUG_ON(!IS_ALIGNED(KASAN_SHADOW_END, SHADOW_ALIGN));
diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index bf233bde68c7..fbff1b759c85 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -62,8 +62,14 @@ int kasan_populate_early_shadow(const void *shadow_start=
,
 #ifndef kasan_mem_to_shadow
 static inline void *kasan_mem_to_shadow(const void *addr)
 {
-=09return (void *)((unsigned long)addr >> KASAN_SHADOW_SCALE_SHIFT)
-=09=09+ KASAN_SHADOW_OFFSET;
+=09void *scaled;
+
+=09if (IS_ENABLED(CONFIG_KASAN_GENERIC))
+=09=09scaled =3D (void *)((unsigned long)addr >> KASAN_SHADOW_SCALE_SHIFT)=
;
+=09else
+=09=09scaled =3D (void *)((long)addr >> KASAN_SHADOW_SCALE_SHIFT);
+
+=09return KASAN_SHADOW_OFFSET + scaled;
 }
 #endif
=20
diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index e804b1e1f886..1e4521b5ef14 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -640,12 +640,20 @@ void kasan_non_canonical_hook(unsigned long addr)
 {
 =09unsigned long orig_addr, user_orig_addr;
 =09const char *bug_type;
+=09void *tagged_null =3D set_tag(NULL, KASAN_TAG_KERNEL);
+=09void *tagged_addr =3D set_tag((void *)addr, KASAN_TAG_KERNEL);
=20
 =09/*
-=09 * All addresses that came as a result of the memory-to-shadow mapping
-=09 * (even for bogus pointers) must be >=3D KASAN_SHADOW_OFFSET.
+=09 * Filter out addresses that cannot be shadow memory accesses generated
+=09 * by the compiler.
+=09 *
+=09 * In SW_TAGS mode, when computing a shadow address, the compiler alway=
s
+=09 * sets the kernel tag (some top bits) on the pointer *before* computin=
g
+=09 * the memory-to-shadow mapping. As a result, valid shadow addresses
+=09 * are derived from tagged kernel pointers.
 =09 */
-=09if (addr < KASAN_SHADOW_OFFSET)
+=09if (tagged_addr < kasan_mem_to_shadow(tagged_null) ||
+=09    tagged_addr > kasan_mem_to_shadow((void *)(~0ULL)))
 =09=09return;
=20
 =09orig_addr =3D (unsigned long)kasan_shadow_to_mem((void *)addr);
@@ -670,7 +678,7 @@ void kasan_non_canonical_hook(unsigned long addr)
 =09} else if (user_orig_addr < TASK_SIZE) {
 =09=09bug_type =3D "probably user-memory-access";
 =09=09orig_addr =3D user_orig_addr;
-=09} else if (addr_in_shadow((void *)addr))
+=09} else if (addr_in_shadow(tagged_addr))
 =09=09bug_type =3D "probably wild-memory-access";
 =09else
 =09=09bug_type =3D "maybe wild-memory-access";
diff --git a/scripts/gdb/linux/kasan.py b/scripts/gdb/linux/kasan.py
index 56730b3fde0b..4b86202b155f 100644
--- a/scripts/gdb/linux/kasan.py
+++ b/scripts/gdb/linux/kasan.py
@@ -7,7 +7,8 @@
 #
=20
 import gdb
-from linux import constants, mm
+from linux import constants, utils, mm
+from ctypes import c_int64 as s64
=20
 def help():
     t =3D """Usage: lx-kasan_mem_to_shadow [Hex memory addr]
@@ -39,6 +40,8 @@ class KasanMemToShadow(gdb.Command):
         else:
             help()
     def kasan_mem_to_shadow(self, addr):
+        if constants.CONFIG_KASAN_SW_TAGS and not utils.is_target_arch('x8=
6'):
+            addr =3D s64(addr)
         return (addr >> self.p_ops.KASAN_SHADOW_SCALE_SHIFT) + self.p_ops.=
KASAN_SHADOW_OFFSET
=20
 KasanMemToShadow()
diff --git a/scripts/gdb/linux/mm.py b/scripts/gdb/linux/mm.py
index d78908f6664d..d4ab341d89c5 100644
--- a/scripts/gdb/linux/mm.py
+++ b/scripts/gdb/linux/mm.py
@@ -281,12 +281,13 @@ class aarch64_page_ops():
         self.KERNEL_END =3D gdb.parse_and_eval("_end")
=20
         if constants.LX_CONFIG_KASAN_GENERIC or constants.LX_CONFIG_KASAN_=
SW_TAGS:
+            self.KASAN_SHADOW_OFFSET =3D constants.LX_CONFIG_KASAN_SHADOW_=
OFFSET
             if constants.LX_CONFIG_KASAN_GENERIC:
                 self.KASAN_SHADOW_SCALE_SHIFT =3D 3
+                self.KASAN_SHADOW_END =3D (1 << (64 - self.KASAN_SHADOW_SC=
ALE_SHIFT)) + self.KASAN_SHADOW_OFFSET
             else:
                 self.KASAN_SHADOW_SCALE_SHIFT =3D 4
-            self.KASAN_SHADOW_OFFSET =3D constants.LX_CONFIG_KASAN_SHADOW_=
OFFSET
-            self.KASAN_SHADOW_END =3D (1 << (64 - self.KASAN_SHADOW_SCALE_=
SHIFT)) + self.KASAN_SHADOW_OFFSET
+                self.KASAN_SHADOW_END =3D self.KASAN_SHADOW_OFFSET
             self.PAGE_END =3D self.KASAN_SHADOW_END - (1 << (self.vabits_a=
ctual - self.KASAN_SHADOW_SCALE_SHIFT))
         else:
             self.PAGE_END =3D self._PAGE_END(self.VA_BITS_MIN)
--=20
2.53.0



