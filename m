Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8873D1266E
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 20:28:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9ED06B0012; Tue,  2 Dec 2025 15:28:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4F716B0029; Tue,  2 Dec 2025 15:28:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C59E66B0012; Tue,  2 Dec 2025 15:28:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B3B9A6B0012
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 15:28:16 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 681F61A02D1
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 20:28:15 +0000 (UTC)
X-FDA: 84175668150.10.484CE96
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7E517100005
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 20:28:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xGXN91Sk;
	spf=pass (imf05.hostedemail.com: domain of 33EsvaQkKCIEfqnhjw3mqlttlqj.htrqnsz2-rrp0fhp.twl@flex--aliceryhl.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=33EsvaQkKCIEfqnhjw3mqlttlqj.htrqnsz2-rrp0fhp.twl@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764707293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6p+COANrRJg4iyKTRaWVzi/wMI4z3c+bFvZRqbOPrm4=;
	b=qxv5ILuD8O3LJ6tIbIFokHwdMWjx0lKMFsLc+aItgXEajJ5Su/GSd0H29XuUkC7eIYZoID
	1KmguvG+1vu113rg7pbOu7mZy0TWGE4t8E7dscRJy9cNda8FEliaVfeUTuNlecmQS6myAi
	Yc84VEHEf1gRgOxwuYU5AVhQzMmKpWQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xGXN91Sk;
	spf=pass (imf05.hostedemail.com: domain of 33EsvaQkKCIEfqnhjw3mqlttlqj.htrqnsz2-rrp0fhp.twl@flex--aliceryhl.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=33EsvaQkKCIEfqnhjw3mqlttlqj.htrqnsz2-rrp0fhp.twl@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764707293; a=rsa-sha256;
	cv=none;
	b=q8sHpIAtYOAbM288ciq4yzkWAvE9pZR3j00BdPhF2LK9IKPk/R7Y8pdIMYkp0Z456qzvh5
	/BvLC3kcoWNcN6W66NUp5cGyaYNEUY+BSHQTjDW9Z1aRBMAioFP9WekivVaHXzOCSWigxG
	S79xejdUqxrMNWMtX2F/BgkciJdtBaQ=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-640b06fa998so5177234a12.2
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 12:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764707292; x=1765312092; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6p+COANrRJg4iyKTRaWVzi/wMI4z3c+bFvZRqbOPrm4=;
        b=xGXN91SkSz79bvEhe41lbzobl1kzE07Y8siPKRAlIHnXjyI4394bW0RqIR2YvWbRib
         cZZjFdCAkUvgMjiI528mmQnCgNY2mTLSMjV7hl1zxTt7M0jm6ZYXSYQZbz9zGtF8A6QI
         k0bWwgK9M96j80E9cUFygsBkWhjxVC9XQLQSQm8TdVyVqycVVFcrtAk50n7od9XND12d
         2OjGdKa/yMJuz73P3+E5JYOykPbvfTPJpZHSjJkYj+TvDpl68WWxb/fY3dbMksicS8BN
         EHXsjiyW+QUG2C8vSVSCX2tqJW2HZYdVyV+TRYGOUfDWyS+gVR48tALI/qwl/xJQj8Ei
         XoNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764707292; x=1765312092;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6p+COANrRJg4iyKTRaWVzi/wMI4z3c+bFvZRqbOPrm4=;
        b=EDyzslDBvLkw2mCC19WknR/jlIZ4JG2KaUcd4DbQhOwqya/GBdiX4eAZJn1CTL6wSH
         MF/cMhY/AaRzAQRXICkRe/MaNTJdg3tk20KqIucsKo77/N3cC9cIMw0P32mH8VcPTsVv
         TA6sAfWne1rTuSMtrE9i2STlYiVcAU8wRn5nZPvhtChwkQXw5ZuawfPhC3SSaw+atcqX
         cLFeOwi8oZT5Qi3slqLliPCJSDorLLWJH7LTrJAGqhAFGZX4VxO/d0K1cCx8imlkuYSb
         u+8LzzhEjORCr8VzDUwnYsHzzc+Vz2sC10krulFYla+Tk1aoRdz85pekiEI2Jr7wUGYG
         7C1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXiP3BdbdodN5I6rmjFi1rHl6GCDA6aSaLHhI7F87jYsJCoSJgpUOp0KHTK7EXPD7RvNyQ/V8Sa3w==@kvack.org
X-Gm-Message-State: AOJu0YzhUkXtsgmveheVn4SAW1Gr/7VCiRHuSCRj6SBdXGq58rHuW5ql
	uF3N+QntLt6V0xlVN7pGSv7F7YQ62p6Ft5Kr77QSqwyOuFIj9e5ry6GxGEK0ReIHEawx7WPFpNh
	MOkYj4ny/hIeA/4369A==
X-Google-Smtp-Source: AGHT+IHlno9/sG7/bayEdrUxcRJ+XAK+NEe9iVymOZCA9KTFp8CJ1IAcUSelacyyX3nFi5Yad+XDFFP4AwI+IlQ=
X-Received: from edaa21.prod.google.com ([2002:a05:6402:24d5:b0:640:92f5:e6fc])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:3584:b0:640:74f5:d9f6 with SMTP id 4fb4d7f45d1cf-64794f74e19mr816955a12.25.1764707292013;
 Tue, 02 Dec 2025 12:28:12 -0800 (PST)
Date: Tue, 02 Dec 2025 20:27:57 +0000
In-Reply-To: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
Mime-Version: 1.0
References: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=4811; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=ILovg7w2jH5gFOEQybF86Y3dXSsF4YeG9sZZSLyxF8g=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBpL0vXWcW4aVlMjlcTWMGU9dXcoeSC3ebU+h+yW
 gJ6gVmPh1OJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaS9L1wAKCRAEWL7uWMY5
 RngFEACMVsbQT0Zwv8K0Ot/Yv1D0f0w7dRnqAHbcNhDHMtJMF0eKhiccoIyiC0h/BYKvRp8B5Pu
 KSeabwFIVcOwoJsWy+5R1rqIx2eJqi4leqQWKrIzXrso29P9gXpzBWdBOHwwr0PRYGZZs9eqSEp
 Ni8/A1g20ZtVifJDwYSoZtF/5PminXSIGBdm5krya3CD3v+xoirkqH8c7cd2uifxi5KrJD6qek3
 5UiQj/e4qgQTTynWcQS9YiJt+sMktrku/XQEmJXyVaDIHrxSMZoWHIYLpdeIwuiWJpPkFPmM8Ni
 UzcSlSLe2Bxh/onkCZs/OKqLm0ynAVl4fGqZIA6f3VhqaSBHVnokKZ+zij8Jdz14c35nUQN/dlr
 fvOd1oiCesg5Ish6+R3Bi9z1VNW+dWygGww6u5+rCxA0+GEIXwc1qoQir54sFgOIf+hunXFo4Ps
 uLzgkzsB6nmOXPv2xxyib9QijAdpCBZ86gSnclbCWDhA/RolFCvtuAfNdVfh8WJ1Iy0/4U/1DaE
 rITItP7ShM8YN+VXCGtruti4f6K9bW3e4z5o9gr5h2C2ODxhxNafTH018EFzRJ9GMSoZZiqSNG+
 wV0PayaQaYSr4TIzmDNriukMQuoKo6fI+++0wRf8nzwUNjnaAZu/qQppZTmL/cbdyjVfrZ8J0ZC bpyEsLN+f3zJ2gA==
X-Mailer: b4 0.14.2
Message-ID: <20251202-inline-helpers-v1-2-879dae33a66a@google.com>
Subject: [PATCH 2/4] rust: helpers: #define __rust_helper
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
	nouveau@lists.freedesktop.org, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 7E517100005
X-Rspamd-Server: rspam02
X-Stat-Signature: 8xxe4eg173hapw9qyub7qxis9z16aa3j
X-Rspam-User: 
X-HE-Tag: 1764707293-930279
X-HE-Meta: U2FsdGVkX19oeNzBrFgVp4W46NYRG61I+58uZUzxIoeBmr9j+ux4OAR1mfsyvKyX+ksMRRIsr6RZv0+Ot/LfGoiO/DhTVVQPPtLxESP6dxfIjN3ptHBZPJOjrquf+Viv7CVu9Rwv+BnyU19MP1m0617KxWned4z+pFt1i5h67PX7Y8/sq33hMxv4cpHqunjmXyKQoLh07jHgumAI0foV1f1qM+TxfFFSDTm7KnJ2b9XJzU8sqPnvvsSfzP1hZMMIo2H6GYSvCA1t3erORuoETwO2d+7q3xDyweNkJaRrfqv+Oy5EhzLMrIypYryTD0INwAIAMddZDDgnOgn8YT5SsSehK3lHgpVe/v7yjmS4wLelkPbIyhhO3uFr1z5clWdIqrPAyAXJhbi/mTha5Q58YLsyc0lenFuNxKKEgaA5l4ntf3isLwQEM3vdvjmyCfXI/ohh0OAzs5MsK51EaxzZ6mcq8LdJcUmemTegKW0pVCbXdm/r8581G7V2f5FcGQwGvJw5UYgmIB7uqLG8OzdjGDPYGzGo30TZc6E7wi2Q38Eth0laFOkJiBBjja1gQFoJW3KtomnmynaDIiNCudP09hgUIR1FdgeBXFthhfAp+6Mu/Wr9wj3yucuDgAv+lVbAvwVSAC0UYIKDXL2+Lxr06G43+Twp9CVeChtMpcbj7I83rfnbDtkqNM8Y4Rqq6ctwpTZA6EonFriCszDKJ51e3puu9IoPsMVZikr1AAxf4ie+W/LG1+WUCRd5BtOkUsshe6G9o8eyR9pzHozCh32pabFpAXfLFFtYuiKLkDZV/glhRnqsUotAlCU4zdec2/5MaCl5JLMtbRfEbKi/gkOobv0cBMZrmYXgA83kowBApt+o6CU4k05o7890vA83ONe0EzQZUrkRMDzMmLKB1xuKrtrpCFVne2rMn4NEUJbfyH8XNxPr2Zbjgc463w6IfBirUeWeyA9NDwEZzdzsz8Z
 lFlIAYi5
 ENzdnWjEqit9EhEx7SbNSNp9Ewu1SxWW7GP5Czx+pME1wyrDzHwq3gugudEHofsdcVdBTVsqDJY72QoIKkF1gXmTnpv4dI+aOg050DzLUAH4o36mytcuhMvMfjOcgZCr0D6IS9yybRzYXR38ubQL/HMpoU1VciLLGWd7GIu93tR6g8q9DvOmWXeIGNuQMxKvIZGKB2/olm3EgTLFLB8AqNtRHHbjBVWmClEqEP2Y4qGmjjsXdWr+OAt8B15U5DspEaLS0cvfhl7Z93fUfdp5fogOuyYKBgOytIuOLxhmTzkUq5753szM2lt9JgJA2w7Mns2WOeYbldqlpIJJ4VGr5SG2KWiHPUxiU3XSEimiIaX4CNmUXpJhqK3T+n0z/LEYr9HHRTXjf6mlS70+cvN/QUBth06Mmh4HKT0dStlF8WhQQIsjCV5iWJKGvz5i5zE+0Npl7kxCDDwO95uH0Rz3WVrmIpIBmHhpYszehRr0j3K6Fku1pHpgudur1DhJPfwilpP/lvbJfY0eZki5+k5+hSdC2mDUc9eQ3wC/S+Z3KW3EiPfY3xU3Kl5ZWsjr7vAkk6LDgx1ekgiQFSyXj5H1T11js1lLHJOfdeVqYOicU+uP84OOeRUopoMSjtxqIGt1HgRNfpn2VyLXBLvuCnRin69QWefI3Ub4LpJ+DLWjWWlKG+TsIsMmQqZRrIbwDElsHVWdv2cvZPT1/kIbI2HO+k91uidOk86SK42+CvU8O2f7Pibmgc94D0OwR8g==
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

The actual additions of __rust_helper can happen in separate patches. A
"flag day" change is not required since missing annotations do not lead
to anything worse than missing inlining.

Signed-off-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/helpers/atomic.c                     |  5 -----
 rust/helpers/helpers.c                    | 31 +++++++++++++++++++++++++++++++
 scripts/atomic/gen-rust-atomic-helpers.sh |  5 -----
 3 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/rust/helpers/atomic.c b/rust/helpers/atomic.c
index cf06b7ef9a1c559e8d7bdfc2bcd2aeb8951c29d1..a48605628ed73ac32aae2e6280481407a670e88f 100644
--- a/rust/helpers/atomic.c
+++ b/rust/helpers/atomic.c
@@ -11,11 +11,6 @@
 
 #include <linux/atomic.h>
 
-// TODO: Remove this after INLINE_HELPERS support is added.
-#ifndef __rust_helper
-#define __rust_helper
-#endif
-
 __rust_helper int
 rust_helper_atomic_read(const atomic_t *v)
 {
diff --git a/rust/helpers/helpers.c b/rust/helpers/helpers.c
index 551da6c9b5064c324d6f62bafcec672c6c6f5bee..d0e2f1f9b449b2248cfbddcee1e8bf9becc8a2f9 100644
--- a/rust/helpers/helpers.c
+++ b/rust/helpers/helpers.c
@@ -7,6 +7,37 @@
  * Sorted alphabetically.
  */
 
+#include <linux/compiler_types.h>
+
+#ifdef __BINDGEN__
+// Omit `inline` for bindgen as it ignores inline functions.
+#define __rust_helper
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
+
 #include "atomic.c"
 #include "auxiliary.c"
 #include "barrier.c"
diff --git a/scripts/atomic/gen-rust-atomic-helpers.sh b/scripts/atomic/gen-rust-atomic-helpers.sh
index 45b1e100ed7c63108ee6cb07e48a17668f860d47..a3732153af29f415e397e17cab6e75cb5d7efafc 100755
--- a/scripts/atomic/gen-rust-atomic-helpers.sh
+++ b/scripts/atomic/gen-rust-atomic-helpers.sh
@@ -47,11 +47,6 @@ cat << EOF
 
 #include <linux/atomic.h>
 
-// TODO: Remove this after INLINE_HELPERS support is added.
-#ifndef __rust_helper
-#define __rust_helper
-#endif
-
 EOF
 
 grep '^[a-z]' "$1" | while read name meta args; do

-- 
2.52.0.158.g65b55ccf14-goog


