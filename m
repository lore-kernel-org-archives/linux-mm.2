Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A4DBE6E81A
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 11:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C188B6B0089; Tue,  3 Feb 2026 06:34:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFACD6B008C; Tue,  3 Feb 2026 06:34:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFF7A6B0092; Tue,  3 Feb 2026 06:34:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9CEB56B0089
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 06:34:26 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3D7B68BB0E
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 11:34:26 +0000 (UTC)
X-FDA: 84402937332.28.27DDCFD
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5A6B6140004
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 11:34:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BVAwUhm7;
	spf=pass (imf09.hostedemail.com: domain of 3Pt2BaQkKCFMv63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3Pt2BaQkKCFMv63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770118464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Wt6rr7j8WqJzmDBy6ebcZd6xKb6YF9nq3jIKBZXTuLo=;
	b=i7f5A+M0dHMXFhpWqpmVaZHymuZb7xzf6U6QaMDBI5RnBb3lES+7IeqOh85khA0+h1MHFA
	tFym9PYUu9T58ax7vDSqtoe4yA1hP8vtG85OKEgo18dJFGSql/FLwgHCbgbpjWWDezjojq
	Tn9etnNAQdndK+QULbnTzvN0tJA9hk8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BVAwUhm7;
	spf=pass (imf09.hostedemail.com: domain of 3Pt2BaQkKCFMv63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3Pt2BaQkKCFMv63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770118464; a=rsa-sha256;
	cv=none;
	b=k0QjJb7DNP2tXfPOhicRSN3vErWUhlaCgQKMrszAm/LIPFCxDb6eW78EAR37GnsMDa65ko
	SjbXHDYYlAZ1AjyqSnzDKidslrEN+b68O3Kb9snRF8bPrDtHhD6AGOiXjJqLVVch5MZKXA
	IOAJOrXRZMwGocW4IYzl1EaHyyyEoHE=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48069a43217so61360865e9.1
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 03:34:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770118463; x=1770723263; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Wt6rr7j8WqJzmDBy6ebcZd6xKb6YF9nq3jIKBZXTuLo=;
        b=BVAwUhm7Svx1QypFn3PbdEv3vX6t/1+gbnQJd0h2NlZFwWB50W0OXk04cWmwzyb/RY
         AQ9LkUZYsUh3ptgJ0KA1GuDky6KFxnVrRO0/zhg/a/OOuOxGyF8tCwj7O/Q56hUSq2VV
         fVgcOkvnBNDEvHwuN7Hk6iXY0aGkyuyVYY/btbzMnZ+vlfSGE+/Y17HUGFwSBRmc5KuW
         ggoLj/repwSzfG6QKlatjqxUjvbR4zZLpDjTQhpCzRpxmNkw16Q2cK9q4AwpCd7LqNw7
         fvd/6dN1Oh0TN63hfZ16QnAZ5Wudp6pNEhL6C7/t04qtNkVVRWOPm4MWFn095H9ih08t
         xoCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770118463; x=1770723263;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wt6rr7j8WqJzmDBy6ebcZd6xKb6YF9nq3jIKBZXTuLo=;
        b=EsuqPymXaQ/4ZgseTvbAiVogyT2c0OoH10hRsBMrm3aC4rpzzKOqxnWDUrlO2qolBz
         AQtQ42j8S6tNgVXSpsk//yJX/mWIL/gJw8J1Tnmp5SP9YXSgrynPaN2jyUeyeaJHGQcG
         8oeqEvzOnmYCdwyHu+CFZKssNnYmtnNabIG9+TgRwttik8BRVbNAEc/W3N0hyS7nf6oT
         ky+++6apXdhlIgpx0q2zrFm7cW6cr9gUiCniDTo0twK023e65JwQtzo+oWuGD0bCmyrF
         r5p/maXuMPF8xnNX5jf5QujERG7pWOB0bSgRoE6NsyaIGudmDbpj8HehizMw3BhpirDE
         YHkg==
X-Forwarded-Encrypted: i=1; AJvYcCXzvI6mwV32K6HQomwclwRGEPMUYGBmET72YCB4MKDPL42hF0o4yR2wrC1Zfl4aBELqaPgC7+8VQQ==@kvack.org
X-Gm-Message-State: AOJu0YxxD+hJgZYFVxrowt+zPEseWy1deIkrE8xGsJi9UtoSxJfRB5eV
	B9lmspr1E57MUboJxgkFdJ7icCgIVGhvTb+VypR/jl535rRLfGqeM0FtlgWWJkH5zeUTKtxJTKZ
	glj+wffznUskmxhGBNA==
X-Received: from wmjq2.prod.google.com ([2002:a7b:ce82:0:b0:480:3842:3532])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1c20:b0:475:de14:db1e with SMTP id 5b1f17b1804b1-482db4d84d1mr202173045e9.24.1770118462768;
 Tue, 03 Feb 2026 03:34:22 -0800 (PST)
Date: Tue, 03 Feb 2026 11:34:07 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAC/dgWkC/3WMwQ7CIBAFf6XZs5hCLbY9+R+mByxb2AShAUM0D
 f8u9u7lJfOSmR0SRsIEU7NDxEyJgq8gTg0sVnmDjHRlEK3oeR1G3pFHZtFtGBMbR7le9EP2yAe o0hZxpfcRvM+VLaVXiJ+jn/nv/ZvKnLVsuI5aYdcpKdXNhGAcnpfwhLmU8gWYaqQZrQAAAA==
X-Change-Id: 20251202-inline-helpers-996f4db65e18
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=2301; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=r/0+9qJswzrRb/+EdDwKidCVLUWK29vWT4K+wcArP6I=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBpgd04KSDTy59pIFCvPyqmf0oiuMXWez7Ej7S0v
 Efk/14aHv6JAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaYHdOAAKCRAEWL7uWMY5
 RoepD/4hC0AzibWqTqtig41zWC+uqMM3eR2aWMM0i25I9KhiHYzJwp+gXTjm/sdMUtX+fmLdomD
 JOOtqTqJRgJb2M6ppRVbT6Zr16NDh2thgm6DmrBDyUDidDREkq6Ka3U57sAP8dr1LUsA4a4wOl1
 IGU4hI3u6+dqf4OaEBSnjjfLEErseNEYr090nMDDZ/uALAI68FtDhxcFDbUTcuzM5qUvAgQkEhb
 s1CRiaOYLsF5YUi+oVfF56c4X/ek8JBXcVe+oBqQQyBTdeE/twj8UzBksin0Kq5fvtOdgBXaJzi
 8mI9ffxQo2D4BrnbbBVi28EOVU0WJ31j8MKrthJHjeJKtuf7nLSMMOMcUD8wOqeB/kNXsMEHbR3
 jrhfVfvFXEqmLCU86/tLNr8sU9I4BYtjIwrjCEBwGQ9rdGzWcSE+BfVvQ8ECDNXhYSBNBramDs5
 GABnreeSJ/GWaIZajEcbzUy8pVe/IONoUyl5bwYcOTd+0Q7o13gGfv//GGGx5GzFqvu7E7WTwkd
 rJvBNgGJd8jgAI6H9e+h4K9C7POeRap4wWVkfVmisaVarpIVsNkkcvIb46ihFwBsHYSKbvEuPA3
 l6Br7+K+wySDSLflrojd8uUlpgesx82SSP1oAJb6ZVTP8iJuKc9sWSRchCqBGagigA03+NGfmuq VDWmoDGJBU6oFcg==
X-Mailer: b4 0.14.2
Message-ID: <20260203-inline-helpers-v2-0-beb8547a03c9@google.com>
Subject: [PATCH v2 0/3] Inline helpers into Rust without full LTO
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5A6B6140004
X-Stat-Signature: j9awb7i8d9usgbgp71m8wy67w9a8cbgz
X-Rspam-User: 
X-HE-Tag: 1770118464-934822
X-HE-Meta: U2FsdGVkX193Yq3cJvepLwyxtbqoSn8JHs7lPOlGt3D3lzDZFDrlcPP+/GNZnagKw1L035lpa1gaf4t1q5UPTpuEqzCDPC/l0Or6mEq2zCQnnADOqOwnEAcacADQgPT6EVBSaZFqVPIYAZFeRcF5Pp773M9px5NYABT6yzEp2uM6Ttvr5FCYZV6NbdMaOiI+VUzrVPtvMp5h2izS0vwml1gzwjkLanSTez20TCvQfdqMEty3tynu9LI4ttirLZi+3nGzpgwDJ0OsXK79KMimRr1KyPRpJavoKRc4303FoTG07Q0POXpXbdsvFqbpil2AW+DzFxdqq99GBg1etg/k9EHt9R73V0yPogY+gRkhgfRaYMkjLMpatDAnFRbZBNffJTNrD05KxDk9QrHsVM3QzI2NAg/qnxKXa3nfNCY8IlHOAzNmQLoFzlt7gH2RCVOpyRSVj94Iyi0dDRPwfQeLt6UJnCmUqsRNafPrYaNeAENPAu9ZXbKspN+3id7rekMt1DEC2QxCX9tOhd5Vp6WVmqAGKULruznZF0ERIK9eyqDOGgm+hPe0WUYYmGhCB/bb3yLSPCar7Wh5Xg+M6hnuzgxV5eBAVUTYtuwaXoXS+HCZD6R+UYIb+4YkPgNYXh0ZyYAI4wt78BcTOAziQi8rSbCAYVBvg3MMd5GJl8xg7N+k1pBX9I+IQqtsKQCNIKc26sSw37U13g6YuGF7liZ6uT0vsnv5seTPcBViWmH3YPiDl3QNsriqzoOrLAKaJjG0u688JJasNLhrzzL/NF3i+N07PR1S5L/UJdiu/dK49SAbYgHrd7hb74/aFZZ/egvkjZQ930O6u5jeRx1w4Br6Ata9vs3epQ1HWeANsZJZOaut8/c0L3xKbbLXi66F2gjI2k4O5n8aQazJb6zAlIaai9oXhFNfF1vEM/tAS9SH6ccHL6DxE8oEiggAaOqEGUumkAxeBv/Z2eZHn1BECEV
 Pc0Nxe85
 PoMfCnZkPx+LiNkJpYwaKdi7vmdrkS2aRq6mAmsXfILtLQE7K7qGS2dQscsXJahb1/ofEEScEbiwC6M+DFZFcLg+Nd3XEnJdRVgzUvchJvhy2uFappDuVzd9fb2sntEuqgjlMwH5YZ29nUlXGyndDa/VW0xczbE7/uqaC+OjK1vh34rBU3Nq5HueAkz3i5k8aGrybFAMrXPaDCxwN/ytvKFSkRvRYgZx8FwiBcu++gIrixgB/UaZnn9L3h8MLJOw2ixPBdjCKQyZtO1T6hoHH1zBlXWI4LkgKUngIwOaxc4l5Nn6SHhCZoRVXOh8DQhn3VrvFigmwusW8JuFz3yjmI9u1QUSdtBSd4P9lWQqWXc1Qq80ajf7Z/p1zBAA1xzhe8Qpk5/Ki5IIdElYGivkmqo/7NQUyHQAqT0wzQtDI1FULyX8Apk9JyAQUmkT6CtMmabBOvmEr8bwbxvLqfhFhrK5RvwwQFpeyyHV47N7B3G/SgBw/CyJ9LGrT/UFvulG5tUXq6sUQZmmeNUjjkCfLbvQ+sMCqfRD6AyJ4bxiiqC7+T2ea5DjAvcdya6GZ8WYOakPOmOnTj3tuMZuq7VGeI4FZhiHrZ4ooMIKOOiUsDH1kiVVugWHNGqUPkFt3KxMyfsLuvo+SZUUCtVepoZmSIfa7RYJuH9INu2qB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently the only way for Rust code to call a static inline function is
to go through a helper in rust/helpers/. This introduces performance
costs due to additional function calls and also clutters backtraces and
flame graphs with helper symbols.

To get rid of these helper symbols, provide functionality to inline
helpers into Rust using llvm-link. This option complements full LTO, by
being much cheaper and avoiding incompatibility with BTF.

I ran a microbenchmark showing the benefit of this. All the benchmark
does is call refcount_inc() in a loop. This was chosen since refcounting
is quite hot in Binder. The results are that Rust spends 6.35 ns per
call vs 5.73 ns per call in C. When enabling this option, the two
languages become equally fast, and disassembly confirms the exact same
machine code is used (in particular there is no call to
rust_helper_refcount_inc). Benchmarking Binder also results in an
improvement from this change.

This patch is complementary to:
https://lore.kernel.org/all/20251202-define-rust-helper-v1-0-a2e13cbc17a6@google.com/

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
Changes in v2:
- Dropped merged patches.
- Generate two copies of helpers.bc, one for built-in and one for modules.
- Remove unused llvm-as tool.
- Add $(cmd_ld_single) to avoid breaking CONFIG_LTO builds (note that
  LTO does not happen over the language boundary, except for helpers).
- Improve Kconfig help message.
- Link to v1: https://lore.kernel.org/r/20251202-inline-helpers-v1-0-879dae33a66a@google.com

---
Gary Guo (3):
      kbuild: rust: add `CONFIG_RUSTC_CLANG_LLVM_COMPATIBLE`
      rust: helpers: #define __rust_helper
      build: rust: provide an option to inline C helpers into Rust

 Makefile               |  3 ++-
 init/Kconfig           | 15 +++++++++++++++
 lib/Kconfig.debug      | 15 +++++++++++++++
 rust/Makefile          | 29 +++++++++++++++++++++++++----
 rust/exports.c         |  5 ++++-
 rust/helpers/helpers.c | 29 +++++++++++++++++++++++++++++
 scripts/Makefile.build |  7 ++++++-
 7 files changed, 96 insertions(+), 7 deletions(-)
---
base-commit: 33a647c659ffa5bdb94abc345c8c86768ff96215
change-id: 20251202-inline-helpers-996f4db65e18

Best regards,
-- 
Alice Ryhl <aliceryhl@google.com>


