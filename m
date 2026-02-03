Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67A67E6E81B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 11:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10D2E6B0095; Tue,  3 Feb 2026 06:34:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D5446B0096; Tue,  3 Feb 2026 06:34:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F199F6B0098; Tue,  3 Feb 2026 06:34:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAB836B0095
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 06:34:28 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9910BD4BBF
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 11:34:28 +0000 (UTC)
X-FDA: 84402937416.29.F53C964
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf10.hostedemail.com (Postfix) with ESMTP id CAC9AC0008
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 11:34:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GwYykoCh;
	spf=pass (imf10.hostedemail.com: domain of 3Qd2BaQkKCFYy9602FM594CC492.0CA96BIL-AA8Jy08.CF4@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3Qd2BaQkKCFYy9602FM594CC492.0CA96BIL-AA8Jy08.CF4@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770118466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=44BM+t61qGHb8bSQxUBenNw4K81sfYTOIHgLXsB72RY=;
	b=p1g5IiJPlI2kJPQ9I0ZSMP/TUIAsoc/o3pbUmNZy9pwYbdXFojyp2NF2ASReUdZpOpcL/9
	090K45HvI3GfSckpb+aHKrAfLJ1i9bJfqkgakvxYJM7xaombt9dF5W64Xy1x6ykuUWFV9h
	dak6SkTh+1oUNa+HjPBW3zZDo95mS30=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GwYykoCh;
	spf=pass (imf10.hostedemail.com: domain of 3Qd2BaQkKCFYy9602FM594CC492.0CA96BIL-AA8Jy08.CF4@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3Qd2BaQkKCFYy9602FM594CC492.0CA96BIL-AA8Jy08.CF4@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770118466; a=rsa-sha256;
	cv=none;
	b=hD/qaTOp+cDBV8uUlT/RTuRVu4Elo5DALSK5Wf4GU6tb0inO8f/dhJYBVnO3M+beH5KXO6
	l544O5blHS8WxIpUieMPm22GArjxqELhCGAO7RjaFI31adduM/knyO98PqRTe6IRTskdwg
	3snlLDMWv7jdkPwKbxoEN7RT3hDZUrQ=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47ee056e5cfso50549225e9.1
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 03:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770118465; x=1770723265; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=44BM+t61qGHb8bSQxUBenNw4K81sfYTOIHgLXsB72RY=;
        b=GwYykoCh7kwpYSoggP657FqG3jNYrXuE5Llo+cqW1XpgXeLqMYHTShIOyjf8IHpbFU
         s0kfvPNWlK1u8PPxlmCoDDRTTDZYOTg8JTIi+Zv6PwINK76qyV77vSFuyUgojloVmJDd
         +7TqXX4SlC0dlGPp1evPkkOy+5W712NTepYtutJNMB9AzxweC0S4KynCYLjXHM0LVjOR
         rNzrfwr5dJysqhkvgMUQce4eQdXGxYfpkysDBjuGG5NBUEnzSTbVJdwDi6IrX4Gxn8kC
         MUknt1rEN012zLz4qJU/AaleZpNfTtyOosEUKvwjfOIGnP5PrSyDrdjllVI/BxXG3iJ/
         v1nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770118465; x=1770723265;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=44BM+t61qGHb8bSQxUBenNw4K81sfYTOIHgLXsB72RY=;
        b=AoI/kCPXvV9L7yuR0bvpRkx5JqPxkuFNIglyxIZIC19+c8Kr6LGwvihim0sBt6440n
         kKp2Xx91xS5+95hqJIE6jtMd2qVKfz8b+dMgd8bZKxtYJX+E+IlxaPkwzGat07rExZWY
         u/dGVn5UtGMkAViLPHSD++CUQQjF7nN+jHp1B/uS6GVwmPDmprgAhSke954EK5wrEDSo
         MbNq9lntfY0qaUVnYLdHt16qe+KCAAaC3jzciLSINXdyXLKj5FBtG3XVoPRmTFZs1jhV
         uUCiCVDjZSJqXy2A4hJm22vWsOR/2KJ+vUBakUitr3s+RmK32mPN5C38AB0fpRiR+5hd
         G8QQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsYBhCzmQd5rk4Tk8RLR1q++I8E0C2epusUIRYJO/ms3VITutFDM6Kbzo9sGqpDssK4jEPLQ8/Dw==@kvack.org
X-Gm-Message-State: AOJu0YwYA+I9yUjx5VVeuJOQdq3fniR+TX2pxg1kpCc1CoDE5qKi3N6u
	y7kPy/oi+r2d3fG1Mqq+yfH9z3IKY3C2o/6fQv7xDt2OmwyhRV7ZbH0/EHmn+KF3nutOops2OUS
	lGN8WVASwPxzHXUnIzg==
X-Received: from wmoo1.prod.google.com ([2002:a05:600d:101:b0:480:6bd0:3fcd])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8115:b0:47e:e2b0:15b8 with SMTP id 5b1f17b1804b1-482db447c40mr231437485e9.4.1770118465517;
 Tue, 03 Feb 2026 03:34:25 -0800 (PST)
Date: Tue, 03 Feb 2026 11:34:09 +0000
In-Reply-To: <20260203-inline-helpers-v2-0-beb8547a03c9@google.com>
Mime-Version: 1.0
References: <20260203-inline-helpers-v2-0-beb8547a03c9@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=3615; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=c8KaIUkKoLbnzKPHztCk8a85+2NFtPPqK1S79zJ3Ew4=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBpgd09MDQTJ/taK3Lf49afHdmnGD/aHx2441aqI
 WiSFym9hA2JAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaYHdPQAKCRAEWL7uWMY5
 Rmo1EACd7QneqQSnMGd/PSyupu+WC8Qo0Dt5lLlYv+YuBAghZSMC40dNomgCxRecczFi73AtCF1
 xQWsJUbfpi0qSHg5D7b2yhKZgm2z8o97sciV2yYOLmzty/siHbIAK4DzUqZrht3LqWAF1oUQHZh
 DZQWpVnLt372AzmSfnAlngaFeryk+5Kgkrgj8VkmOsZb0f/xK52bAKdefYYqtY0NyMo+C0RtjGU
 R0X1L2Xne/PyIsIUPVchOAKrL8I3Bmwfq81tUDW2u84eHRkQXBYRNFsWIfaOqq+5mddEBNm7Wkm
 6kacZLAWeLreMRtqKFla1B9Y31g119GAB3R9NU8CDupVLiipPz+1zSJ/nYpoZ1T+G5fgYIbmfme
 isbeGXOU8NQF0ehV9rIBnZLk6SuqqYCFi0JuBAcTohsSvO2R7yEZK8mrzo8lyYW8f/WkZyokuXL
 AmxVqO2vl+gLIVAcRgScCC7Ty3xbpRkArdS/tDt+UfL5G36cKcwWR+AloosJ2L0C0AdHIGi+wwe
 T47u6O6NNstj2VJOHi1udvRWBa+KzCZjguMjfUkDTni9AoNss0l8UpkxyJVL6z02jTc8lMszCBx
 1tnhbxOr9prmPAO93SH8qQaU/DGebUpg9wIhTl0mErECRp1F0zHk5b9nINJPIm52x/kIJotfQZa GXngUhbk/tn3KQA==
X-Mailer: b4 0.14.2
Message-ID: <20260203-inline-helpers-v2-2-beb8547a03c9@google.com>
Subject: [PATCH v2 2/3] rust: helpers: #define __rust_helper
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
	Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CAC9AC0008
X-Stat-Signature: yfnym1mt5cbg8ubs68yot9zang8bf718
X-Rspam-User: 
X-HE-Tag: 1770118466-555303
X-HE-Meta: U2FsdGVkX1/NLxbQc5omTtmbFZXUv/1/39SPbbKdx0qZ+Hxw7TxrK1hxmvhQsVTCyPaozYzOi3BmMTzfL+6H2A/ed2fiwiLbWOo2+1blujBeGsnQimU6fvobQzeJeXdfUn8G/HAwp5EQtygUXm3LBYVcaUKUZz69J1gfga5PumF7zfBVNjNuxlPMaBhMPbU+WyK85YiUxYtROCGFe2rF1nCUC+ouXp2NZVflsU54b8z7GeFJLHhuOsb1K22zeOEGE1HE3PujInciUyPwct77tgNRcy1Djo9fVFQeCsrAy+PN2s7uSiNpQiNOGFRgLV19t0FRpmyPRIxlupOPCg46tvus1NW4SCzU+h9BPBdtuNs07Vtm1HhNWvnlCi9LwJ5WR1C50K/HsXFpwPMoUH1XZRoEGUs5e/7vUBB1XsU+lAJq4sGhiFy2w2wIkMwNtXucpxGryBhBfGJLS4e9N1dimbuz7BWPsmAGrn/u4e/JK9UXxHuQa2AjMOFb/z3X5ufEwaRIu+LT3Tshpvim2Pkxlw8hKoXzoQ1i/PVwMV/jm5jCBXpl43gurOYm9A5q4QejIgQzvUCKYCQ45ybmEs49TiP6GIMCRi1igw8yrQtBDbS4a79tv5ou+AXPL6fz05CSBEabbnYcuTG7b9XSQa9j6+NzxdoSiNDfdb3g+Ma4pwM3TP7OJT7OtpA5TsbhyBkC5olk5yIHXb5j0DkM9UzSmd2BQ+7UL9l/xt11C/rrcjZiL1xxv6R5xVNVRweQMGsF3kYTbVWwQZkr91AcijPPelAKJqu8/EHHE1x3dGCrl8A7qpwJRCCVdKOGXEc8+Iqq34waSgIlSMP9uKdqunlSfxZhGFzi+3K+ceCfAcwJn3lKgkRuQTXS8bwQU1eAinnoxUxyJ3yY4TxinQjnNWVKFrtOBZ3zkow494eUy0xG04ff92DYcuIhr95Z8reJKx6NTETTyPR3Yi0ebKbodrS
 6nzI/BbQ
 ZtEXAQEWKPbeLe9mANH4q10Frnv5u7g7BQX4aEkM97ySMTLdh3xvSHQGQxJD2/4duhoqNCwV7E1xYyf7QrDvRS3n1y6RjP9Vga0geinsy51h9EHyk85lSeOzOna3v0XQ73zyHgU4WHbIDRhSRtg/DYwySdmj6jBu6ugPh6VCVkZJRtNLXYOlVtiwlnHEElqlMvKRc6OXKWjPIv+oS5djCYoRdMZMvEQ7/XVy23oeEgJ0fF5U0B5VWpJK5ckRiyhiLmwmN0EgpWMOdBFDuoDxk7X/Vjz09P3vydiqg/dDadLGwpTJwOSeKj1WwmRIhXHeLJB+glZhNYYEKA6Onz8GESNXkPqzsUHs/FpmDcCiVRrj+cop2/zBbsL0AQxkV4KvYYD95VSF3Ou6uZyIK4RCyym0ikQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Gary Guo <gary@garyguo.net>

Because of LLVM inling checks, it's generally not possible to inline a C
helper into Rust code, even with LTO:

* LLVM doesn't want to inline functions compiled with
  `-fno-delete-null-pointer-checks` with code compiled without. The C
  CGUs all have this enabled and Rust CGUs don't. Inlining is okay since
  this is one of the hardening features that does not change the ABI,
  and we shouldn't have null pointer dereferences in these helpers.

* LLVM doesn't want to inline functions with different list of builtins. C
  side has `-fno-builtin-wcslen`; `wcslen` is not a Rust builtin, so
  they should be compatible, but LLVM does not perform inlining due to
  attributes mismatch.

* clang and Rust doesn't have the exact target string. Clang generates
  `+cmov,+cx8,+fxsr` but Rust doesn't enable them (in fact, Rust will
  complain if `-Ctarget-feature=+cmov,+cx8,+fxsr` is used). x86-64
  always enable these features, so they are in fact the same target
  string, but LLVM doesn't understand this and so inlining is inhibited.
  This can be bypassed with `--ignore-tti-inline-compatible`, but this
  is a hidden option.

To fix this, we can add __always_inline on every helper, which skips
these LLVM inlining checks. For this purpose, introduce a new
__rust_helper macro that needs to be added to every helper.

Most helpers already have __rust_helper specified, but there are a few
missing. The only consequence of this is that those specific helpers do
not get inlined.

Signed-off-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/helpers/helpers.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/rust/helpers/helpers.c b/rust/helpers/helpers.c
index a3c42e51f00a0990bea81ebce6e99bb397ce7533..e05c6e7e4abb7e6a4c4a3a417e35022dac1d9c58 100644
--- a/rust/helpers/helpers.c
+++ b/rust/helpers/helpers.c
@@ -7,7 +7,36 @@
  * Sorted alphabetically.
  */
 
+#include <linux/compiler_types.h>
+
+#ifdef __BINDGEN__
+// Omit `inline` for bindgen as it ignores inline functions.
 #define __rust_helper
+#else
+// The helper functions are all inline functions.
+//
+// We use `__always_inline` here to bypass LLVM inlining checks, in case the
+// helpers are inlined directly into Rust CGUs.
+//
+// The LLVM inlining checks are false positives:
+// * LLVM doesn't want to inline functions compiled with
+//   `-fno-delete-null-pointer-checks` with code compiled without.
+//   The C CGUs all have this enabled and Rust CGUs don't. Inlining is okay
+//   since this is one of the hardening features that does not change the ABI,
+//   and we shouldn't have null pointer dereferences in these helpers.
+// * LLVM doesn't want to inline functions with different list of builtins. C
+//   side has `-fno-builtin-wcslen`; `wcslen` is not a Rust builtin, so they
+//   should be compatible, but LLVM does not perform inlining due to attributes
+//   mismatch.
+// * clang and Rust doesn't have the exact target string. Clang generates
+//   `+cmov,+cx8,+fxsr` but Rust doesn't enable them (in fact, Rust will
+//   complain if `-Ctarget-feature=+cmov,+cx8,+fxsr` is used). x86-64 always
+//   enable these features, so they are in fact the same target string, but
+//   LLVM doesn't understand this and so inlining is inhibited. This can be
+//   bypassed with `--ignore-tti-inline-compatible`, but this is a hidden
+//   option.
+#define __rust_helper __always_inline
+#endif
 
 #include "atomic.c"
 #include "atomic_ext.c"

-- 
2.53.0.rc1.225.gd81095ad13-goog


