Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A1BBEA7942
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 19:19:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B0336B0093; Wed,  4 Feb 2026 14:19:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6708E6B0096; Wed,  4 Feb 2026 14:19:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5881B6B0098; Wed,  4 Feb 2026 14:19:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3F5BA6B0093
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 14:19:25 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DE10AC171F
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 19:19:24 +0000 (UTC)
X-FDA: 84407737848.25.D6DA6E2
Received: from mail-43101.protonmail.ch (mail-43101.protonmail.ch [185.70.43.101])
	by imf20.hostedemail.com (Postfix) with ESMTP id E23FC1C000D
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 19:19:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=MO4VC4At;
	spf=pass (imf20.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.101 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770232763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iu4zpkhKjTMZbG/WxcEbj/JRgNUZ5JOTwFm/0BMFTmk=;
	b=0UGUztco6WAHIHR1W6n7ztqpKU40pnDhOAznBMAr7tARy/iwPXHCZuQR62qUwxcFYk94st
	/WWZITLTtEHtRezJMvlz7DvmirUa3fwDfe7b7OdwTc+95oIR1911QxshATlYeyMoHEzsHB
	jIKCKBaN0wL0d1b/PopiL4Wot1oRz8k=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=MO4VC4At;
	spf=pass (imf20.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.101 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770232763; a=rsa-sha256;
	cv=none;
	b=5G6doJvlu9YkwXXfOn3tevBuIJv2hld4pbzxAG8MQTNr5/J7NOzpzWA8rNR+SDJntQBG79
	WRPr4hMj2B2YCKCXux/paqPSstey3SUIoHXjtEp1WpoKeSeN6GLDZ2cNUXytb9O7Pe9/qu
	PvikDapcbqMa6Jpp3B3qCuNE/UkH20I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1770232758; x=1770491958;
	bh=Iu4zpkhKjTMZbG/WxcEbj/JRgNUZ5JOTwFm/0BMFTmk=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=MO4VC4Attf+I37WB3EKoBTEIob1VtiNYhPpDIOu8Cu8cya34n3bMXNuCSfA68C3LI
	 WypgDVXRVTECsETgHMNMH7Zln9gHJ9e0dTaJYCi65tJa/VX8W24CppIUuwKxkeFseg
	 Q7k0Q2/Ln/Q0+2xEBw+r7dEOhxjzwTK7op2ztge7BYgwfsNnsLIOwP2/KehrQhJrAV
	 okyI4KZjucbJEPeXUIIpJm3SDiOhDoO7+cr96hRKv0VfhaB0pUvWwAmjLy4FyQiaEj
	 9C0NgzZSUqxIYpEh3F8ywVauNHLl1zoXPu1AKVxPbEYjyo95XbOPOt3g5HiBrAAd59
	 weJJEg4Dtkr2w==
Date: Wed, 04 Feb 2026 19:19:15 +0000
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: m.wieczorretman@pm.me, Samuel Holland <samuel.holland@sifive.com>, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, workflows@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev
Subject: [PATCH v10 01/13] kasan: sw_tags: Use arithmetic shift for shadow computation
Message-ID: <bd935d83b2fe3ddfedff052323a2b84e85061042.1770232424.git.m.wieczorretman@pm.me>
In-Reply-To: <cover.1770232424.git.m.wieczorretman@pm.me>
References: <cover.1770232424.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: c8829a6f9b7ff2043ab798bf58e89b6f35bb03af
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E23FC1C000D
X-Stat-Signature: 4gsttp93bi8d1g7pj55xfmnqt36dgi9o
X-Rspam-User: 
X-HE-Tag: 1770232762-248745
X-HE-Meta: U2FsdGVkX1+uu9WOpz8ECDSUqOG0Tjxb0GHKM6oEm91NTvVX34VuBEvcRPSjw7jl02iALvru84pCgZhb3wmJU1acHJadxgGIUiYaxJnM37FyIT9kRi3/XgE6Vd2ql53ROIrHj9OtjutjPs7j2iAyeommEF7etwZOFjB0KJkkK/nNhqSX6GBhG9J8/7K/HOMBvUqL1Gj3PT9Wt68ChM/OgvhzDexMJE0gYnvsSzV7yHU7TohNZMo4i/nHZNr39B7MYz1ec+cCxQ7Jail3U9rIbTgtRlOHFqzaHpWBFRSAldxvDdloTtTjAG1PIolO8HPMsahBibwgPDx7PgAGnbOqfW3O3hmdl+v9R44YSwz3np/bPuVLVn7Uc4OKkFUOGScSf45Ijgqr/f5PA51MnvowPJmcwk2KLm5g85QjU4GVHeWepSxsfv3SJvPC5vetuFomsVykLAwOEyYGdLL26OgxgFI9sZ2yZ9FZDaPJvmXTptsymlmChWCmJyREq1gyudZpoBEEtGhZypJ8MUWZ9Z/4G3aGkWhn+mAIT8XyqM3ZInJXf2KX7fSa6eJsWO3ACjn9jUAX4b6uYy0EpxTmgKFPCwW1sswptXM9oGJJvDLKn+pTj6sAuo4PyZTdyXkHP9IT14rirypzBWaXs1oerKgTwFi2y039qyRA4NdD9oRRyg+DXvlBmXe1WR3QkipN7qIxcWrCxoK/WsDgooSaU69xfWWrq7SCLRcWBLHcgM/a44XweLraun6ipUDmG35Obni6oLLjlDmNBVv6UX4PCr3UXX3yRnthA7G0WbCO9nTFcMDQjK1Q4qxRWw8uFWjHLR5XYj9+V5eGFkRovi9cArodk+j64ZE28Ea4rsxhKyO3e89bkGEaKyPnU96C9txnZ0VMHsbNsM+ReNfJ5vax0NZMS2XQ06qiYw2zhgLBIOoWEeBsOAjrtH/cNb1Q1JwPZe3Ja9GKi3vNxsIt6FeZEXQ
 faCazEUC
 ICQ5I/UlIuGwcCIjMOWilX3l0LgAZK5byHx+38lvc3XMKdAI4yaJCk9CCdrMDfQMbLDCUfgLLL6Gqr1WqWXUN0kQRBW3hq5YFwgycZleplOuOPK3YLcq7UAU2kido/zTn3MWPIKpty4WlAd9PgMlCmNL/U28x1hPXyugXxgTKjQYwEnoFJxzE03VPFLYBfkPX8p3vYUI2qwqu4oZkFyT/oeLxyzTibapmSIDrSA/htWonN9n7imdjiCG8igQmazsJYT/Om03iR6lNoF23F7UlwUnnU/X02vUCb30Z7FYBmWebTkBQ9I7fT7vdsAuTzOWdhHNfa6K462rF4/HoWgn3VQyJ7t/yQ8BKjyDy25djzRXk2Y9n89LmeeRv7vFQ5idFnEXCKmp5PuKiN393uK8eogYKea6TcwdHmm2CQFgvjK2lNhKJudRIGjchw2FkoAcMx7N6HJuU6BpnmLrmHMLTIyt/MIG8Urn/73F8PQmazdTD8ctemIWpQEZsQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

Add the arch_kasan_non_canonical_hook() to group the arch specific code
in the relevant arch directories.

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

 Documentation/arch/arm64/kasan-offsets.sh |  8 ++++--
 Documentation/dev-tools/kasan.rst         | 18 ++++++++----
 MAINTAINERS                               |  2 +-
 arch/arm64/Kconfig                        | 10 +++----
 arch/arm64/include/asm/kasan.h            |  5 ++++
 arch/arm64/include/asm/memory.h           | 14 ++++++++-
 arch/arm64/mm/Makefile                    |  2 ++
 arch/arm64/mm/kasan_init.c                |  7 +++--
 arch/arm64/mm/kasan_sw_tags.c             | 35 +++++++++++++++++++++++
 include/linux/kasan.h                     | 10 +++++--
 mm/kasan/kasan.h                          |  7 +++++
 mm/kasan/report.c                         | 15 ++++++++--
 scripts/gdb/linux/kasan.py                |  5 +++-
 scripts/gdb/linux/mm.py                   |  5 ++--
 14 files changed, 118 insertions(+), 25 deletions(-)
 create mode 100644 arch/arm64/mm/kasan_sw_tags.c

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
index a034700da7c4..64dbf8b308bd 100644
--- a/Documentation/dev-tools/kasan.rst
+++ b/Documentation/dev-tools/kasan.rst
@@ -318,13 +318,19 @@ translate a memory address to its corresponding shado=
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
diff --git a/MAINTAINERS b/MAINTAINERS
index 0efa8cc6775b..bbcb5bf5e2c6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13587,7 +13587,7 @@ S:=09Maintained
 B:=09https://bugzilla.kernel.org/buglist.cgi?component=3DSanitizers&produc=
t=3DMemory%20Management
 F:=09Documentation/dev-tools/kasan.rst
 F:=09arch/*/include/asm/*kasan.h
-F:=09arch/*/mm/kasan_init*
+F:=09arch/*/mm/kasan*
 F:=09include/linux/kasan*.h
 F:=09lib/Kconfig.kasan
 F:=09mm/kasan/
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 93173f0a09c7..c1b7261cdb96 100644
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
diff --git a/arch/arm64/include/asm/kasan.h b/arch/arm64/include/asm/kasan.=
h
index b167e9d3da91..42d8e3092835 100644
--- a/arch/arm64/include/asm/kasan.h
+++ b/arch/arm64/include/asm/kasan.h
@@ -22,5 +22,10 @@ void kasan_init(void);
 static inline void kasan_init(void) { }
 #endif
=20
+#ifdef CONFIG_KASAN_SW_TAGS
+bool __arch_kasan_non_canonical_hook(unsigned long addr);
+#define arch_kasan_non_canonical_hook(addr) __arch_kasan_non_canonical_hoo=
k(addr)
+#endif
+
 #endif
 #endif
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memor=
y.h
index 9d54b2ea49d6..f127fbf691ac 100644
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
diff --git a/arch/arm64/mm/Makefile b/arch/arm64/mm/Makefile
index c26489cf96cd..4658d59b7ea6 100644
--- a/arch/arm64/mm/Makefile
+++ b/arch/arm64/mm/Makefile
@@ -15,4 +15,6 @@ obj-$(CONFIG_ARM64_GCS)=09=09+=3D gcs.o
 KASAN_SANITIZE_physaddr.o=09+=3D n
=20
 obj-$(CONFIG_KASAN)=09=09+=3D kasan_init.o
+obj-$(CONFIG_KASAN_SW_TAGS)=09+=3D kasan_sw_tags.o
 KASAN_SANITIZE_kasan_init.o=09:=3D n
+KASAN_SANITIZE_kasan_sw_tags.o=09:=3D n
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
diff --git a/arch/arm64/mm/kasan_sw_tags.c b/arch/arm64/mm/kasan_sw_tags.c
new file mode 100644
index 000000000000..d509db7bdc7e
--- /dev/null
+++ b/arch/arm64/mm/kasan_sw_tags.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * This file contains ARM64 specific KASAN sw_tags code.
+ */
+
+#include <linux/kasan.h>
+
+bool __arch_kasan_non_canonical_hook(unsigned long addr)
+{
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
+=09 * [0xFF00000000000000, 0xFFFFFFFFFFFFFFFF]. Despite the overflow, the
+=09 * resulting possible shadow region is contiguous, as the overflow
+=09 * happens for both 0xFF00000000000000 and 0xFFFFFFFFFFFFFFFF.
+=09 *
+=09 * Reset the addr's tag bits so the inline mode which still uses
+=09 * the logical shift can work correctly. Otherwise it would
+=09 * always return because of the 'smaller than' comparison below.
+=09 */
+=09addr |=3D (0xFFULL << 56);
+=09if (addr < (unsigned long)kasan_mem_to_shadow((void *)(0xFFULL << 56)) =
||
+=09    addr > (unsigned long)kasan_mem_to_shadow((void *)(~0ULL)))
+=09=09return true;
+=09return false;
+}
diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 338a1921a50a..81c83dcfcebe 100644
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
diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
index fc9169a54766..02574e53d980 100644
--- a/mm/kasan/kasan.h
+++ b/mm/kasan/kasan.h
@@ -558,6 +558,13 @@ static inline bool kasan_arch_is_ready(void)=09{ retur=
n true; }
 #error kasan_arch_is_ready only works in KASAN generic outline mode!
 #endif
=20
+#ifndef arch_kasan_non_canonical_hook
+static inline bool arch_kasan_non_canonical_hook(unsigned long addr)
+{
+=09return false;
+}
+#endif
+
 #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
=20
 void kasan_kunit_test_suite_start(void);
diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 62c01b4527eb..53152d148deb 100644
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
+=09if (arch_kasan_non_canonical_hook(addr))
 =09=09return;
=20
 =09orig_addr =3D (unsigned long)kasan_shadow_to_mem((void *)addr);
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
index 7571aebbe650..2e63f3dedd53 100644
--- a/scripts/gdb/linux/mm.py
+++ b/scripts/gdb/linux/mm.py
@@ -110,12 +110,13 @@ class aarch64_page_ops():
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



