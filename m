Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09BCEE6E819
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 11:34:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B14AB6B0096; Tue,  3 Feb 2026 06:34:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADC456B0098; Tue,  3 Feb 2026 06:34:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 994AB6B0099; Tue,  3 Feb 2026 06:34:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 89BE16B0096
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 06:34:30 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2934E58E29
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 11:34:30 +0000 (UTC)
X-FDA: 84402937500.11.34C4982
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3850120003
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 11:34:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Gvoxrocz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3Qt2BaQkKCFczA713GN6A5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3Qt2BaQkKCFczA713GN6A5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770118468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aE0I4qCeFvAhyrBrsfU7k4O+fmQQ+xM6mESOeLTMWYY=;
	b=RsUmCUhxM1CuNkdyOZ8K6SPAISgz93D9mXIxDJLDi4oyWZCiJQaNQer0xoq64z7Q0oVjhU
	8JUxi+qxEUo0w0Ord+F/IlbJ2IGuCXXtr3TxYguavNjd0XvTNRh3MEDUK6lyI1P3i0lc4s
	kykhY5dvuBZPIXrEbVqqOyGJtT/wYE0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770118468; a=rsa-sha256;
	cv=none;
	b=QyZ2gQe0kd0wbKEiNGsVsjRMBFdVVL3eUd7qWGogwQPfM0OIXx62D1/1XIkXhxtNJz5lX/
	tpoGegx5tI31pTdr70kpqugBp0iVRCFl37cgsjUQV/U4jUdDUP1jVPmB3aT9phSypyV58c
	+piHASs8YbNc3Xls2yt5r0cg4JwqGh0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Gvoxrocz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3Qt2BaQkKCFczA713GN6A5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3Qt2BaQkKCFczA713GN6A5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--aliceryhl.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-430f57cd2caso4347100f8f.0
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 03:34:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770118467; x=1770723267; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aE0I4qCeFvAhyrBrsfU7k4O+fmQQ+xM6mESOeLTMWYY=;
        b=GvoxroczY5oB/4jFkOV0v5RQCyAR+zvIR4bMOcqCLfRu7SNPilBqcR+FyRC9pRdI+Z
         U/rgusj7BLzxzx42izcW+5z2QdYZFLQgRpELmg0XxplTt+NcB+unN4OToVIt7Vcdrdw6
         gyBdbaU+yzwQaEQ3pbm2Z/BDSbIe37ViXVGQbr/9L2qQNxoHjr07VGIF/DU5Tq63eUTl
         B83ribQ1XmbfTO0D8zvi5D5Po2tFrq7P7ZzUTxifqNOZsPcE7dpMKrmhOQ6bQVQ7A0p0
         5qccnsNeaygWczMRopKgFZTmfMU24LEVw7WJBO6Is5w+yYak6X8i/gtuxeiCFn2dX+Ch
         PrTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770118467; x=1770723267;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aE0I4qCeFvAhyrBrsfU7k4O+fmQQ+xM6mESOeLTMWYY=;
        b=AMrUgKT4YOZ0679+BUHZfI7zmpdEjN0L5UllvEloC++k12sj/q9SCKm0aeY0H5HsAv
         k6iSTiYR4/CL3od9NYDrpXJxWmEBDdoer+ccLkyxg5ElzmAQAoIuCvd6GXjL9TXC/aFq
         avkBJOE6pKg9u06pk3kFr9j4SlSKXd86ld/Jrgpq7D+zKr9VMIdDeam7JBeCLS31XVm0
         QkpkYc/WnR9QJCbNBVXnxFdmheedY6K9v+4Yznu+pmOfCfTGEyyuAhaLu/J2rI7dHton
         gJ74vwsXwvlQiFMt8hwppmwbWMFTDxeLum0+g50bGuYsS9FLH1GVz7CphIzXdEEaDf+e
         M6HQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGvF1qzaVySVNw0hmLZwyzYRVVhVy0y3TcHrvuJHSZaTOrPt5e7lHeHGyd/yXTae78bArxFfdRSg==@kvack.org
X-Gm-Message-State: AOJu0YyNTJ9g1oqj1eW0hKjS4ZaTe9H/gFTeAALU7T+gAOkFbPwkBSTt
	CI826x4L/gd16wCLoMd0V3f9RBjPhou0rT0zcP+X49YZ2squ5MF5JjRJbBPdDH4HeXYxWhR1ZAn
	TQ8OVhneRmrv4NPscFQ==
X-Received: from wrfu10.prod.google.com ([2002:a05:6000:38a:b0:436:1564:8b38])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:26c6:b0:435:a815:dd81 with SMTP id ffacd0b85a97d-435f3a6a9e4mr23351106f8f.11.1770118466723;
 Tue, 03 Feb 2026 03:34:26 -0800 (PST)
Date: Tue, 03 Feb 2026 11:34:10 +0000
In-Reply-To: <20260203-inline-helpers-v2-0-beb8547a03c9@google.com>
Mime-Version: 1.0
References: <20260203-inline-helpers-v2-0-beb8547a03c9@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=9996; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=ccYqFunpYUJ3E9tFyGaM8o4GOz90mNx5YokAm40heqc=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBpgd09hi110q+7UOnBQB1eL+5EOe+WuCfuQr49U
 unbqQxlHpmJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaYHdPQAKCRAEWL7uWMY5
 RmdyEAC8Gb4J7AKABnGI1ESN5mKs8wfRAVbeEptQbCRE5TG56C8/CwBu3BxngSIJaR/jsj4cg+v
 7E0sKl/e97o+ZFQ1e9+FgXjFE7mVT12T4WUYBVqLBjTCamAok2TTrixp+zYddUq+ccwGolxU2MY
 wBGy5AIj3hlrdI1XTXv0NYJa4I4Glhfer2cK5LuX/6pkbjv7AQywMBrJtEapUtDvygG+cs0Uz4n
 zHRznz9Xh6RSnlT17RKc8EABqA3R7Z/Y1TfSPuiYNT+i1vFhkHNGluu0cxtkBL/PEZd15dIpN9B
 CXvT+lZRPcrEVVL2fuqYe+gQgP56/sgeJvjD7jcfyJI3zXMfQpMyFC8pB+rbFKJIVG7GNB7L0Rt
 4WqgYZBp0kM9WfQ+cmN7CaAFLaSsq6PDDnQFm61oEIBCoup6Q5tW2ceX6RNTUETpSUxy80qbzu8
 Rhm7tuiSWxxpbMg+aRVGw5nFrxnliAzu/PFfSdq7Ro9SOo045XuS6+UKMlWE9o9WbFN/DB0TD9L
 w8uffrD51wqql0njRGx4d6VDYm6dS3Zi9JOQVznM/Z2AIqWquCTTwpocObwK8qDoX6PwKhb9ix/
 H5C5Hb9A4mUHv16LwURptoWOxXnWZP3I9pTQEulcrf6CnuKSZ9eQszFn5hXt60Q4x6yPGd9DXBd EsK/t8LslrkpMww==
X-Mailer: b4 0.14.2
Message-ID: <20260203-inline-helpers-v2-3-beb8547a03c9@google.com>
Subject: [PATCH v2 3/3] build: rust: provide an option to inline C helpers
 into Rust
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
	Alice Ryhl <aliceryhl@google.com>, Matthew Maurer <mmaurer@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 3850120003
X-Stat-Signature: 88xuz39uf7oscnj41fx5f8x8zb1ez8zz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770118467-945939
X-HE-Meta: U2FsdGVkX1/CafR3sMTgfBl2qr9quLTea/NwUf2FjaeoIJhFqyvaolae6wCjXj1jFgSZaeW3S7ghrwDzdEuqOAdEMQABe6qswLBQzTKIpEvFMGu7UuOM7pAUpXwgMP0nwMEgcwOP4gLmaKKnMJIx7X0ZPGz4WohEQ+gWKSFoJdfjMGzzX5UcDWHBmDG6ETNDjgbaYBpVKqXVasXfBYX04X2cfOpvH+BIwIIbGti0fVPg23yhI/9v4Z+RasojXkU90Yk30qDGmkbb+K4yUHBUu5FmgyEU0iF4v35v1WgEm3ZPmmY4yq6NO6HjLttLZLPY6idVrASx1GubYeEdFbRxlOh5gMTINi15DgI6fx+oAQ9SFweoucgKucv352PONEpGT1ojV8ukbcJo6fya5+2U6xSg3gYfNLOW5xKWTlj+oD/zbM+opJZBMeW5rrOnIXTS3vfGQ+U9poSXfjcTdzGwAnJf3AUuo6Euf7fKkTgf8nMLYyUeZszxVtaNeuOvvW3y0Hn/R+1uyJQxTUptKamPtXa7vkC4xjza7paQYR+EAd8tZu3S++BIydonSVDuFDe2mJT0UJi9V19lNJyhNJcdssWte9Xeb7XmaSpprIxfT1T6o8NG99bWXpF0edgmFgbqmQc5ZLNA4iLujjYz+untiiAzPX53pwE5m8BkhW5cPO01VnjARsFbJGWegh+dWI83dHsDwEOqVtjp5FPsaMTDFhtAkOJAilASLVVTIquuXor3nrTMpA757Px5XS1bzzlxNhFzrPN2XWUUAthoGE8o9sL3/6aIXAuQTz/PLFr6rAQb0/5exdSxxLJvubQda22O7pcfiN1ZZeUPa/AXkbHjMyTcpIoPJ1Gqjp9dD6KnFPBhM4cXdVAB1631yToKdNrhQMVqFwlQh9kZ7YXoL2PuOSNAsxtScWQlrEQOJSb5obHqeUn2l3xCngYWwI0VgIZj74n4BYajA5E1h0ZDYON
 V23eebd2
 m7eZjdusAU6TA23Js3t96dNMNmvlQITkJdHU8rc4yizAKLi7gnN4XGLLj9pG8VLIHNvN1kmWLvGbFmF6Mnz9rGgbLyp3HEThP0Eua8qQbTN4TEbicVCg4EEIYow5HBsBnPxsEVOCGCibQPtaHR0G5ANnG86JSwuvgC2cGSo/fu5fAF8itnPOnVQ80uWHyxJGAkid2G6Aq8/x4FJNZJ9DadKwXuUTnVp05GDeozhMuozhSD4KD6ktoLTxmRXLR0aitnNxpWViD+v/+9J6s08EF6wicF1l7Y+IuCOK1R7TNrvBvnyO5QYv2Ny0UPchICnJyaQxCjjsoXuCC7dAs86vp2Yw4fmFJ/pe1i9z3FSGHZC1AqIiAMZTyImgm8e+0mAcLABZmf/LkPi+vltOJyaKPbEZMtbWUcxGAY6ugoY07xMk3M452HEQhWv/INs12hFQsJXWETuPNHLhwIIpGES/LbcjUYD5jV57RIj3aeM81+b1B0ZF0m0CanFcXPfJXTX8DBYxkTwAys/8B2ftxGrHGYcB5HEDG16u5298N8uVoIPYp7iXfReLAdTSaX18j1b5SRJlp2Q5XeuAKR9quoVR0FGbw0R4Yl/zDoqIOpHBTfBPbOnO+HURXpvfzrJcSwgj2I5EDpB7DVysb5+n2UWHVjAUEPwY/qc/p/5XTqNRA4mZJ5g13nQHZuEuGOprLr1E9qZhqT4AX9d6tcniUqnBhNgQf+FgFxoKDnRB/XS8rxVQM7r0evygKnl4UFw==
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
  into vmlinux, they're compiled to LLVM IR bitcode. Two versions are
  generated: one for built-in code (`helpers.bc`) and one for modules
  (`helpers_module.bc`, with -DMODULE defined). This ensures that C
  macros/inlines that behave differently for modules (e.g. static calls)
  function correctly when inlined.
* When a Rust crate or object is compiled, instead of generating an
  object file, LLVM bitcode is generated.
* llvm-link is invoked with --internalize to combine the helper bitcode
  with the crate bitcode. This step is similar to LTO, but this is much
  faster since it only needs to inline the helpers.
* clang is invoked to turn the combined bitcode into a final object file.
* Since clang may produce LLVM bitcode when LTO is enabled, and objtool
  requires ELF input, $(cmd_ld_single) is invoked to ensure the object
  is converted to ELF before objtool runs.

The --internalize flag tells llvm-link to treat all symbols in
helpers.bc using `internal` linkage [1]. This matches the behavior of
`clang` on `static inline` functions, and avoids exporting the symbol
from the object file.

To ensure that RUST_INLINE_HELPERS is not incompatible with BTF, we pass
the -g0 flag when building helpers. See commit 5daa0c35a1f0 ("rust:
Disallow BTF generation with Rust + LTO") for details.

We have an intended triple mismatch of `aarch64-unknown-none` vs
`aarch64-unknown-linux-gnu`, so we pass --suppress-warnings to llvm-link
to suppress it.

We add $(cmd_ld_single) before $(cmd_objtool). Otherwise objtool fails
to parse the resulting files as Elf when CONFIG_LTO is enabled.

I considered adding some sort of check that KBUILD_MODNAME is not
present in helpers_module.bc, but this is actually not so easy to carry
out because .bc files store strings in a weird binary format, so you
cannot just grep it for a string to check whether it ended up using
KBUILD_MODNAME anywhere.

Link: https://github.com/llvm/llvm-project/pull/170397 [1]
Co-developed-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Co-developed-by: Matthew Maurer <mmaurer@google.com>
Signed-off-by: Matthew Maurer <mmaurer@google.com>
Signed-off-by: Gary Guo <gary@garyguo.net>
Co-developed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 Makefile               |  3 ++-
 lib/Kconfig.debug      | 15 +++++++++++++++
 rust/Makefile          | 29 +++++++++++++++++++++++++----
 rust/exports.c         |  5 ++++-
 scripts/Makefile.build |  7 ++++++-
 5 files changed, 52 insertions(+), 7 deletions(-)

diff --git a/Makefile b/Makefile
index c97f06ee0dda1c922aa23bd5249052591d528eb6..155db03cf489d931eefdb4bd7e3b93e5aa3ea2d6 100644
--- a/Makefile
+++ b/Makefile
@@ -519,6 +519,7 @@ OBJCOPY		= $(LLVM_PREFIX)llvm-objcopy$(LLVM_SUFFIX)
 OBJDUMP		= $(LLVM_PREFIX)llvm-objdump$(LLVM_SUFFIX)
 READELF		= $(LLVM_PREFIX)llvm-readelf$(LLVM_SUFFIX)
 STRIP		= $(LLVM_PREFIX)llvm-strip$(LLVM_SUFFIX)
+LLVM_LINK	= $(LLVM_PREFIX)llvm-link$(LLVM_SUFFIX)
 else
 CC		= $(CROSS_COMPILE)gcc
 LD		= $(CROSS_COMPILE)ld
@@ -627,7 +628,7 @@ export RUSTC_BOOTSTRAP := 1
 export CLIPPY_CONF_DIR := $(srctree)
 
 export ARCH SRCARCH CONFIG_SHELL BASH HOSTCC KBUILD_HOSTCFLAGS CROSS_COMPILE LD CC HOSTPKG_CONFIG
-export RUSTC RUSTDOC RUSTFMT RUSTC_OR_CLIPPY_QUIET RUSTC_OR_CLIPPY BINDGEN
+export RUSTC RUSTDOC RUSTFMT RUSTC_OR_CLIPPY_QUIET RUSTC_OR_CLIPPY BINDGEN LLVM_LINK
 export HOSTRUSTC KBUILD_HOSTRUSTFLAGS
 export CPP AR NM STRIP OBJCOPY OBJDUMP READELF PAHOLE RESOLVE_BTFIDS LEX YACC AWK INSTALLKERNEL
 export PERL PYTHON3 CHECK CHECKFLAGS MAKE UTS_MACHINE HOSTCXX
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 7570a694d54e6170ae6738634218b37e38a4b76a..c44c08b49f3a3c2e06fca42adeb9e04304e7a869 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -3551,6 +3551,21 @@ config RUST_KERNEL_DOCTESTS
 
 	  If unsure, say N.
 
+config RUST_INLINE_HELPERS
+	bool "Inline C helpers into Rust code"
+	depends on RUST && RUSTC_CLANG_LLVM_COMPATIBLE
+	depends on EXPERT
+	help
+	  Inlines C helpers into Rust code using Link Time Optimization.
+
+	  If this option is enabled, C helper functions declared in
+	  rust/helpers/ are inlined into Rust code, which is helpful for
+	  performance of Rust code. This requires a matching LLVM version for
+	  Clang and rustc.
+
+	  If you are sure that you're using Clang and rustc with matching LLVM
+	  versions, say Y. Otherwise say N.
+
 endmenu # "Rust"
 
 endmenu # Kernel hacking
diff --git a/rust/Makefile b/rust/Makefile
index 63464bd2c1e9734cd6e659f7ee3db58bf995d6dd..a6839f2d39feefcfea497384ae202a7c6b475942 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -6,15 +6,19 @@ rustdoc_output := $(objtree)/Documentation/output/rust/rustdoc
 obj-$(CONFIG_RUST) += core.o compiler_builtins.o ffi.o
 always-$(CONFIG_RUST) += exports_core_generated.h
 
+ifdef CONFIG_RUST_INLINE_HELPERS
+always-$(CONFIG_RUST) += helpers/helpers.bc helpers/helpers_module.bc
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
@@ -480,6 +484,14 @@ $(obj)/bindings/bindings_helpers_generated.rs: private bindgen_target_extra = ;
 $(obj)/bindings/bindings_helpers_generated.rs: $(src)/helpers/helpers.c FORCE
 	$(call if_changed_dep,bindgen)
 
+quiet_cmd_rust_helper = HELPER  $@
+      cmd_rust_helper = \
+	$(CC) $(filter-out $(CFLAGS_REMOVE_helpers/helpers.o), $(c_flags)) \
+		-c -g0 $< $(if $(filter %_module.bc,$@),-DMODULE) -emit-llvm -o $@
+
+$(obj)/helpers/helpers.bc $(obj)/helpers/helpers_module.bc: $(src)/helpers/helpers.c FORCE
+	+$(call if_changed_dep,rust_helper)
+
 rust_exports = $(NM) -p --defined-only $(1) | awk '$$2~/(T|R|D|B)/ && $$3!~/__(pfx|cfi|odr_asan)/ { printf $(2),$$3 }'
 
 quiet_cmd_exports = EXPORTS $@
@@ -561,12 +573,16 @@ quiet_cmd_rustc_library = $(if $(skip_clippy),RUSTC,$(RUSTC_OR_CLIPPY_QUIET)) L
 	OBJTREE=$(abspath $(objtree)) \
 	$(if $(skip_clippy),$(RUSTC),$(RUSTC_OR_CLIPPY)) \
 		$(filter-out $(skip_flags),$(rust_flags)) $(rustc_target_flags) \
-		--emit=dep-info=$(depfile) --emit=obj=$@ \
+		--emit=dep-info=$(depfile) --emit=$(if $(link_helper),llvm-bc=$(patsubst %.o,%.bc,$@),obj=$@) \
 		--emit=metadata=$(dir $@)$(patsubst %.o,lib%.rmeta,$(notdir $@)) \
 		--crate-type rlib -L$(objtree)/$(obj) \
 		--crate-name $(patsubst %.o,%,$(notdir $@)) $< \
 		--sysroot=/dev/null \
+	$(if $(link_helper),;$(LLVM_LINK) --internalize --suppress-warnings $(patsubst %.o,%.bc,$@) \
+		$(obj)/helpers/helpers$(if $(part-of-module),_module).bc -o $(patsubst %.o,%.m.bc,$@); \
+		$(CC) $(CLANG_FLAGS) $(KBUILD_CFLAGS) -Wno-override-module -c $(patsubst %.o,%.m.bc,$@) -o $@) \
 	$(if $(rustc_objcopy),;$(OBJCOPY) $(rustc_objcopy) $@) \
+	$(cmd_ld_single) \
 	$(cmd_objtool)
 
 rust-analyzer:
@@ -696,4 +712,9 @@ $(obj)/kernel.o: $(obj)/kernel/generated_arch_warn_asm.rs $(obj)/kernel/generate
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
index 0c838c467c764e14a51ad132444544373e90a84c..7176d997ecab7c3ffd1e00400a8a79a8309485e1 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -343,7 +343,12 @@ rust_common_cmd = \
 # would not match each other.
 
 quiet_cmd_rustc_o_rs = $(RUSTC_OR_CLIPPY_QUIET) $(quiet_modtag) $@
-      cmd_rustc_o_rs = $(rust_common_cmd) --emit=obj=$@ $< $(cmd_objtool)
+      cmd_rustc_o_rs = $(rust_common_cmd) --emit=$(if $(CONFIG_RUST_INLINE_HELPERS),llvm-bc=$(patsubst %.o,%.bc,$@),obj=$@) $< \
+	$(if $(CONFIG_RUST_INLINE_HELPERS),;$(LLVM_LINK) --internalize --suppress-warnings $(patsubst %.o,%.bc,$@) \
+		$(objtree)/rust/helpers/helpers$(if $(part-of-module),_module).bc -o $(patsubst %.o,%.m.bc,$@); \
+		$(CC) $(CLANG_FLAGS) $(KBUILD_CFLAGS) -Wno-override-module -c $(patsubst %.o,%.m.bc,$@) -o $@) \
+	$(cmd_ld_single) \
+	$(cmd_objtool)
 
 define rule_rustc_o_rs
 	$(call cmd_and_fixdep,rustc_o_rs)

-- 
2.53.0.rc1.225.gd81095ad13-goog


