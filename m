Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EDBFD1266C
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 20:28:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01FF56B0029; Tue,  2 Dec 2025 15:28:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3A326B002A; Tue,  2 Dec 2025 15:28:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E04016B002B; Tue,  2 Dec 2025 15:28:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BDB896B0029
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 15:28:20 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 22DDBB7EEC
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 20:28:18 +0000 (UTC)
X-FDA: 84175668276.20.E408D98
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2C44C2000B
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 20:28:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KQ6Oxipo;
	spf=pass (imf13.hostedemail.com: domain of 33ksvaQkKCIMhspjly5osnvvnsl.jvtspu14-ttr2hjr.vyn@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=33ksvaQkKCIMhspjly5osnvvnsl.jvtspu14-ttr2hjr.vyn@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764707296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Id46d5Vmg/QweH1w+t+fx2ST+00n7i1ciKT4MxLQ6Gk=;
	b=vyIvYGrunHtj9tGzUX6Zrc06yfE0gUJ+zfUY3lxo/d5+yysCNqhxGrlpjpb/t9UY4OlqYa
	coO7whA6v+b0HWCoxSlhLAxG7NqXpmwbBHEzhYRT++DcyYPX1YNxh6AV7t5tY1c4X+XZXo
	UOh1HwWhovMZOVVAScgby3QyLZ/NAx4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764707296; a=rsa-sha256;
	cv=none;
	b=wnLBESv+4amEoejpglOUBZFvp0AmNsCQCdpZdXj+d5ovt7svj90fcV/EP9Rx8e21d99Jd0
	fr2/BM4imLUD0PPnS8+5ydDCpJp1qZaoRn6dQx3aUwuzMYfPyym+OGfzcpZs16aXoHrWN6
	v2bW66iYNr4lXjYYEINga8ioVzI5MLg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KQ6Oxipo;
	spf=pass (imf13.hostedemail.com: domain of 33ksvaQkKCIMhspjly5osnvvnsl.jvtspu14-ttr2hjr.vyn@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=33ksvaQkKCIMhspjly5osnvvnsl.jvtspu14-ttr2hjr.vyn@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47799717212so44624865e9.3
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 12:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764707295; x=1765312095; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Id46d5Vmg/QweH1w+t+fx2ST+00n7i1ciKT4MxLQ6Gk=;
        b=KQ6Oxipo3x8xr5XoBbi/7d2kqlYIrQksyKYTgCI3FSJuINxRUHCSLtOV7TcYGkDi93
         HSHux2GE5cPTSDOMlBMGt6wuG+m+LtwPAokU8LiNYu5cBBgiR9K6DHCd7xb3hQpP/obw
         Oe5Nr9AQXUVnopxebW+n9xBRyr1w5xCzdtWPiDAvbKnWhP5s7/yv4SaC/GH3+HIDVyr0
         5gnlHjSN4TCXb5tJZvrlMojzhWAK7K9YR/lhq3G3TmIcUjyQqFyy8wGn46bdBjcShb7h
         WuIq7qhdLhvGqFvLQdYQ7pKwqNYsgymuyuw9DmeJr3P0wMtVoKx9ict0LOCWb7HDmPI9
         4u6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764707295; x=1765312095;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Id46d5Vmg/QweH1w+t+fx2ST+00n7i1ciKT4MxLQ6Gk=;
        b=ILKFVkDh9iYrsHAYZwQjSFH/Iwf7t94LevzdlU7K1uNN5whNPvLu4T6JhWwknuGpBr
         INMo4AF4OOpXYwz8CXh+Xf1TXsEfEJgRPNlLnDhfbFAiW968oSsVHMMifGyGncU2y8sd
         NCFc36wNSweXOLzK7Tv2J6NCLLPsT6vnELKT0D6E25UZ4npIK0TZizk3uy4T8e0LzY61
         T3R8w3NXqyouANJP8ew95sVbm6IzpLExJGW1QRIdDpYNOqVJKsRV6V558sKEr6b4vXXv
         4W1l/lXfnQ21ETUh/NhFLv2iTHVfoC2N/HPP+Xxu3Ig/GYXhPjvCMHkmg4mcJY61iUuo
         fjfA==
X-Forwarded-Encrypted: i=1; AJvYcCU2lmrwEf1DV1NVZxPFs7bMy6esaWNWcCGSJbU/3DT2eLPCd7icQEE9uA4lsVGPE03dVM9NaPpc6Q==@kvack.org
X-Gm-Message-State: AOJu0Yzl9CrU1/iFLbnb/r5kNfxng6oF9rPlmW7LYleZpyDjqTALEzzn
	M+HwnOkjXdEVIXVfqt7ChUvfW8Y1WmMkjZJeDuCHCO924p/8Z/wCUNyaufXA4jfKLg1nCZ0e2DO
	uuyqr9057tnIROyhWIw==
X-Google-Smtp-Source: AGHT+IEV8MdqGcyCgbe2mt3hk2i0zy9sL5yMlrGz8Wfzitbo0qZDeAoS7Bz5wRmT2BDTK8lUXG2WtOVPXNGQznc=
X-Received: from wmqg19.prod.google.com ([2002:a05:600c:4ed3:b0:477:a1f9:138c])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e91:b0:477:7ae0:cd6e with SMTP id 5b1f17b1804b1-4792a5ddcc9mr8270815e9.5.1764707294808;
 Tue, 02 Dec 2025 12:28:14 -0800 (PST)
Date: Tue, 02 Dec 2025 20:27:59 +0000
In-Reply-To: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
Mime-Version: 1.0
References: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=8979; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=ZnZgTS3QcWRawBw++AAPhDFQtHAEQIZjfTFyfZ+xDmk=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBpL0vY58X0j2N0y6zci+722T9v5vmhEw8pSHYzy
 bBoMvTYi1uJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaS9L2AAKCRAEWL7uWMY5
 RgpGD/0fasxYXiW6xVDDz8y4znLsMtXtDdRWNS+6bJ+27GT03cNM49SunHDvdbd1REYSO2YPMBz
 kPaPyVggZHDWnyck1v+MiaG+x4LW+ZRIkW8vaUrh+aymRIXxt76FsCU9rUOcgAZ16qMAGGpu6N+
 phlcZRw3rBj1By8r+yuXf8PdJKxCF4DbMGLkzT41x5F1+oHfjrHV4azKoBtDZzOLfrQf14dJ+wE
 MXz5NrtQdnDi8+fGcMM6T2TA4rimlfzl817O9Ho/Z4sbqYoYciomv8XvLM3z5hS9pzvjfB8UYF5
 u5m/OyCU61eDcrbiyQJbjny4mgxknTjmeUmsF5u1ihqApi8vbB/ZlYHyZL9MgJEkFKqHAyZKga2
 qEGd/jKKrArjdJwDk4TLcMwofyvdezUNx56N+IwbaQ8nKUWxV01veHHnkhvHWBCrkKPP5LvnemU
 woHsvvPGxiX3D6uXJDgzNM2ZaO4uNVFBDnjOkWEUCRvzPFg4muptJlGYfXtrbLGar7KWHu+0scl
 +2UMIdbTQV7p5t32aiJn3k4MV+FSMnPlbBEFJohWVT0dFSUgOeB1jnuJHp6oFzzhJtevrHVJ5iD
 N2Q7FYIYgHL3/LwM4YB/7bDJs6WhgzHaAsvSbU71oiP9t2Fmzvrx0ndD1YMaaBeWrcRhhwR+AH9 PlvCH9Zp+KU5/LA==
X-Mailer: b4 0.14.2
Message-ID: <20251202-inline-helpers-v1-4-879dae33a66a@google.com>
Subject: [PATCH 4/4] build: rust: provide an option to inline C helpers into Rust
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Nicolas Schier <nicolas.schier@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	nouveau@lists.freedesktop.org, Alice Ryhl <aliceryhl@google.com>, 
	Matthew Maurer <mmaurer@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C44C2000B
X-Stat-Signature: rwdwdfoig1gkxdq17yb148d8j1751nuk
X-HE-Tag: 1764707295-602044
X-HE-Meta: U2FsdGVkX19uX719qooka/pw+Q3Bk1cSIvt0tzKvpRnpTOhU/jlw/xRRGsHHgaUdTMACZUHr7fzQkTIFDsVvKjZYKGm2NqOI9giTEkZVf4twlOcKJk2DY6ZUi2vUYq7KIBO8OsC9vi76lC2x79I+XnKVoyNYcyxndsdRo4cbiJOxoMd42EFMAk5zsoYyi2zmIh11/8tPGD9+Zrtj5E1/5lsunY5x1xiaB9SVCswOspmzZbKvcXz4iizW+MspDkGv6E4XEsNsqnKhmbAwJihrqx1I8FH4pbEkTgP5OE7rTbB6KJUoa0Hf3cjNig/vFew+jOJg/hnb96OmJovMgWMT5iXfuedKMGWLKpdIBaHgGnL/wvT1ZX50yWsiebjWzSWDJhMOs4gOIFYN9InGKs6tvStEEdPO00P2v6sWQTRHHJy259jXz/hlaJRfmNaDmZquV1Ib4PhBoKz4toh5gzjBgznlEOXuRB3rqoAXnPNQjc8FLxcvd7viyNb4r4zsCht+eivmgsttFZmUOSvJ4s4U4NwJFhqaz6kgfVddTnSgfZyIoEjGS6p2VTpopzGgWmV3To2EosOs4WyiO4+w4HNLvYuY5ZUat6BUFdO3NvKRwj0xFH0Nsar8hgSfWrr64eOmulMezLx0Efydqfxi9UtrWVeF8xnG0JzsVfJsPLsgDOzHe2LGs6KiqDcb2DRzrGWsBxJzKpYjY42yPu7+dnw701nPJa6Hr6t8RgEJIZFkYAhwDTMD+ZOvD9dnn1DVgnnT+wkxHVCLP1KTAXxmrmUTzvlpZbJ7Wa7Q9qGg3taTSPiJVIr4ca7drY5o5nJ2IjQJbJLhcHzsIlccTo4gHwCEGCVwB23iVePxvoqYvx/Y/9t9DD9r9rFVy+sOHaMJTzpv511omuiJToybSjUJEfdCee4q1RRCLGjhfCfdNdnSHA2+8ccKHmbUbKcHrB/SmmwVt3I/XzFuqBhue/DGO0x
 2iUf8xtZ
 XUQb+4v7wyJXiZhuoRxo+j6ie4wurG8S6g/zZn/99lmM68Qw3S6YjuhxKnsGqlobaUJlpJmvxIN14su/cX8d8eH4eUjWoVdHifnNcHzmWpRsVeHzVoejrtloU6dSDxofDCfZUasK+rMiSasqAQApELOUmri6uSjxSxSv/8yvuc5Sy8ldxxyrPDmk0gpmVBBAT5UJs5wWojyw0tryAi0INmJPu/oUssg8zdmHaFiK+a87WTqhLUDTmD7tl6kV88X1eBL/eXZ8orFyT3SJADqWJU50LmdCC21GCW830jmt8OXXveQyjhqoldB6SYWTtDvRkdGH76vZsqbUYOXPvykBklqSU3XrocfMiu55oxbgiFuFAF74/pL02GGba33C4FYxDtOMyBCdQmPLOtLN/9fn0rQ+U2g4OJh/jslQ8k+/299YyF3/PvKNG8M0+5S7EOoBHS9t98dRnp3EOqxY8aSQj1+FZC6XXCrvTrHlNx5fJj6fsK/UPf5wT3gDOUvE8b3mDXjmppYkp5XwbMF/V3EzxjnyHaZ1nByvPoMWUNIJTWFNiHKbd0gfM61T9o9MsbfjyKCEPQ4pjPYFAvS5Ew88+UKvh0NJ6MVofirP5MtveeI0v5cS652ZsgpFvwooQCm35orlSGgnn9yZ1ThZ96yhqfU3nDWslCKed5fLljC1FU0hovB9YSWzgUhWZNOjpyX2k3T9/o71JWpRaX5ES6Wh6ooTRg7LUi2O3dCWJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Gary Guo <gary@garyguo.net>

A new experimental Kconfig option, `RUST_INLINE_HELPERS` is added to
allow C helpers (which were created to allow Rust to call into
inline/macro C functions without having to re-implement the logic in
Rust) to be inlined into Rust crates without performing global LTO.

If the option is enabled, the following is performed:
* For helpers, instead of compiling them to an object file to be linked
  into vmlinux, they're compiled to LLVM IR.
* The LLVM IR is compiled to bitcode (This is step is not necessary, but
  is a performance optimisation to prevent LLVM from always have to
  reparse the same IR).
* When a Rust crate is compiled, instead of generating an object file, we
  ask LLVM bitcode to be generated.
* llvm-link is invoked with --internalize to combine the helper bitcode
  with the crate bitcode. This step is similar to LTO, but this is much
  faster since it only needs to inline the helpers.
* clang is invoked to turn the combined bitcode into a final object file.

The --internalize flag tells llvm-link to treat all symbols in
helpers.bc using `internal` linkage. This matches the behavior of
`clang` on `static inline` functions, and avoids exporting the symbol
from the object file.

To ensure that RUST_INLINE_HELPERS is not incompatible with BTF, we pass
the -g0 flag when building helpers. See commit 5daa0c35a1f0 ("rust:
Disallow BTF generation with Rust + LTO") for details.

We have an intended triple mismatch of `aarch64-unknown-none` vs
`aarch64-unknown-linux-gnu`, so we suppress the warning.

Co-developed-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Co-developed-by: Matthew Maurer <mmaurer@google.com>
Signed-off-by: Matthew Maurer <mmaurer@google.com>
Signed-off-by: Gary Guo <gary@garyguo.net>
Co-developed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 Makefile               |  4 +++-
 lib/Kconfig.debug      | 15 +++++++++++++++
 rust/Makefile          | 26 ++++++++++++++++++++++----
 rust/exports.c         |  5 ++++-
 scripts/Makefile.build |  5 ++++-
 5 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/Makefile b/Makefile
index 96ddbaae7e12de71bcfabef4639de3a13a6e4815..5834bfd568548d1bee34b328dccce5d60f85526f 100644
--- a/Makefile
+++ b/Makefile
@@ -517,6 +517,8 @@ OBJCOPY		= $(LLVM_PREFIX)llvm-objcopy$(LLVM_SUFFIX)
 OBJDUMP		= $(LLVM_PREFIX)llvm-objdump$(LLVM_SUFFIX)
 READELF		= $(LLVM_PREFIX)llvm-readelf$(LLVM_SUFFIX)
 STRIP		= $(LLVM_PREFIX)llvm-strip$(LLVM_SUFFIX)
+LLVM_LINK	= $(LLVM_PREFIX)llvm-link$(LLVM_SUFFIX)
+LLVM_AS		= $(LLVM_PREFIX)llvm-as$(LLVM_SUFFIX)
 else
 CC		= $(CROSS_COMPILE)gcc
 LD		= $(CROSS_COMPILE)ld
@@ -625,7 +627,7 @@ export RUSTC_BOOTSTRAP := 1
 export CLIPPY_CONF_DIR := $(srctree)
 
 export ARCH SRCARCH CONFIG_SHELL BASH HOSTCC KBUILD_HOSTCFLAGS CROSS_COMPILE LD CC HOSTPKG_CONFIG
-export RUSTC RUSTDOC RUSTFMT RUSTC_OR_CLIPPY_QUIET RUSTC_OR_CLIPPY BINDGEN
+export RUSTC RUSTDOC RUSTFMT RUSTC_OR_CLIPPY_QUIET RUSTC_OR_CLIPPY BINDGEN LLVM_LINK LLVM_AS
 export HOSTRUSTC KBUILD_HOSTRUSTFLAGS
 export CPP AR NM STRIP OBJCOPY OBJDUMP READELF PAHOLE RESOLVE_BTFIDS LEX YACC AWK INSTALLKERNEL
 export PERL PYTHON3 CHECK CHECKFLAGS MAKE UTS_MACHINE HOSTCXX
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 3034e294d50df55c4003c5fa5df442f59e711bd8..e63c5eb57b049aff988419ccd12dfd99d59f5080 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -3427,6 +3427,21 @@ config RUST_KERNEL_DOCTESTS
 
 	  If unsure, say N.
 
+config RUST_INLINE_HELPERS
+    bool "Inline C helpers into Rust crates (EXPERIMENTAL)"
+    depends on RUST && RUSTC_CLANG_LLVM_COMPATIBLE
+    depends on EXPERT
+    help
+        Links C helpers into Rust crates through LLVM IR.
+
+        If this option is enabled, instead of generating object files directly,
+        rustc is asked to produce LLVM IR, which is then linked together with
+        the LLVM IR of C helpers, before object file is generated.
+
+        This requires a matching LLVM version for Clang and rustc.
+
+        If unsure, say N.
+
 endmenu # "Rust"
 
 endmenu # Kernel hacking
diff --git a/rust/Makefile b/rust/Makefile
index d7d19c21b671dea10242b1772a8bcf0bf5dcc1cd..2344e2662ce29280582215954132c09f63cd8c9d 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -6,15 +6,19 @@ rustdoc_output := $(objtree)/Documentation/output/rust/rustdoc
 obj-$(CONFIG_RUST) += core.o compiler_builtins.o ffi.o
 always-$(CONFIG_RUST) += exports_core_generated.h
 
+ifdef CONFIG_RUST_INLINE_HELPERS
+always-$(CONFIG_RUST) += helpers/helpers.bc
+else
+obj-$(CONFIG_RUST) += helpers/helpers.o
+always-$(CONFIG_RUST) += exports_helpers_generated.h
+endif
 # Missing prototypes are expected in the helpers since these are exported
 # for Rust only, thus there is no header nor prototypes.
-obj-$(CONFIG_RUST) += helpers/helpers.o
 CFLAGS_REMOVE_helpers/helpers.o = -Wmissing-prototypes -Wmissing-declarations
 
 always-$(CONFIG_RUST) += bindings/bindings_generated.rs bindings/bindings_helpers_generated.rs
 obj-$(CONFIG_RUST) += bindings.o pin_init.o kernel.o
-always-$(CONFIG_RUST) += exports_helpers_generated.h \
-    exports_bindings_generated.h exports_kernel_generated.h
+always-$(CONFIG_RUST) += exports_bindings_generated.h exports_kernel_generated.h
 
 always-$(CONFIG_RUST) += uapi/uapi_generated.rs
 obj-$(CONFIG_RUST) += uapi.o
@@ -468,6 +472,13 @@ $(obj)/bindings/bindings_helpers_generated.rs: private bindgen_target_extra = ;
 $(obj)/bindings/bindings_helpers_generated.rs: $(src)/helpers/helpers.c FORCE
 	$(call if_changed_dep,bindgen)
 
+quiet_cmd_rust_helper = HELPER  $@
+      cmd_rust_helper = \
+	$(CC) $(filter-out $(CFLAGS_REMOVE_helpers/helpers.o), $(c_flags)) -c -g0 $< -emit-llvm -o $@
+
+$(obj)/helpers/helpers.bc: $(obj)/helpers/helpers.c FORCE
+	+$(call if_changed_dep,rust_helper)
+
 rust_exports = $(NM) -p --defined-only $(1) | awk '$$2~/(T|R|D|B)/ && $$3!~/__(pfx|cfi|odr_asan)/ { printf $(2),$$3 }'
 
 quiet_cmd_exports = EXPORTS $@
@@ -547,11 +558,13 @@ quiet_cmd_rustc_library = $(if $(skip_clippy),RUSTC,$(RUSTC_OR_CLIPPY_QUIET)) L
 	OBJTREE=$(abspath $(objtree)) \
 	$(if $(skip_clippy),$(RUSTC),$(RUSTC_OR_CLIPPY)) \
 		$(filter-out $(skip_flags),$(rust_flags)) $(rustc_target_flags) \
-		--emit=dep-info=$(depfile) --emit=obj=$@ \
+		--emit=dep-info=$(depfile) --emit=$(if $(link_helper),llvm-bc=$(patsubst %.o,%.bc,$@),obj=$@) \
 		--emit=metadata=$(dir $@)$(patsubst %.o,lib%.rmeta,$(notdir $@)) \
 		--crate-type rlib -L$(objtree)/$(obj) \
 		--crate-name $(patsubst %.o,%,$(notdir $@)) $< \
 		--sysroot=/dev/null \
+	$(if $(link_helper),;$(LLVM_LINK) --internalize --suppress-warnings $(patsubst %.o,%.bc,$@) $(obj)/helpers/helpers.bc -o $(patsubst %.o,%.m.bc,$@); \
+		$(CC) $(CLANG_FLAGS) $(KBUILD_CFLAGS) -Wno-override-module -c $(patsubst %.o,%.m.bc,$@) -o $@) \
 	$(if $(rustc_objcopy),;$(OBJCOPY) $(rustc_objcopy) $@) \
 	$(cmd_objtool)
 
@@ -678,4 +691,9 @@ $(obj)/kernel.o: $(obj)/kernel/generated_arch_warn_asm.rs $(obj)/kernel/generate
 endif
 endif
 
+ifdef CONFIG_RUST_INLINE_HELPERS
+$(obj)/kernel.o: private link_helper = 1
+$(obj)/kernel.o: $(obj)/helpers/helpers.bc
+endif
+
 endif # CONFIG_RUST
diff --git a/rust/exports.c b/rust/exports.c
index 587f0e776aba52854080f15aa91094b55996c072..1b52460b0f4eeef6df9081abb9b7e054a28c3c21 100644
--- a/rust/exports.c
+++ b/rust/exports.c
@@ -16,10 +16,13 @@
 #define EXPORT_SYMBOL_RUST_GPL(sym) extern int sym; EXPORT_SYMBOL_GPL(sym)
 
 #include "exports_core_generated.h"
-#include "exports_helpers_generated.h"
 #include "exports_bindings_generated.h"
 #include "exports_kernel_generated.h"
 
+#ifndef CONFIG_RUST_INLINE_HELPERS
+#include "exports_helpers_generated.h"
+#endif
+
 // For modules using `rust/build_error.rs`.
 #ifdef CONFIG_RUST_BUILD_ASSERT_ALLOW
 EXPORT_SYMBOL_RUST_GPL(rust_build_error);
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index d0ee33a487be95f8ba9a5c964ebecfbebc6c4bf8..04eaf2b4fbca2245f904a6dc7875cb3275aa7df6 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -343,7 +343,10 @@ rust_common_cmd = \
 # would not match each other.
 
 quiet_cmd_rustc_o_rs = $(RUSTC_OR_CLIPPY_QUIET) $(quiet_modtag) $@
-      cmd_rustc_o_rs = $(rust_common_cmd) --emit=obj=$@ $< $(cmd_objtool)
+      cmd_rustc_o_rs = $(rust_common_cmd) --emit=$(if $(CONFIG_RUST_INLINE_HELPERS),llvm-bc=$(patsubst %.o,%.bc,$@),obj=$@) $< \
+	$(if $(CONFIG_RUST_INLINE_HELPERS),;$(LLVM_LINK) --internalize --suppress-warnings $(patsubst %.o,%.bc,$@) $(objtree)/rust/helpers/helpers.bc -o $(patsubst %.o,%.m.bc,$@); \
+		$(CC) $(CLANG_FLAGS) $(KBUILD_CFLAGS) -Wno-override-module -c $(patsubst %.o,%.m.bc,$@) -o $@) \
+	$(cmd_objtool)
 
 define rule_rustc_o_rs
 	$(call cmd_and_fixdep,rustc_o_rs)

-- 
2.52.0.158.g65b55ccf14-goog


