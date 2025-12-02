Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93C68D116FE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 20:28:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1071E6B0024; Tue,  2 Dec 2025 15:28:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0970D6B002A; Tue,  2 Dec 2025 15:28:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC97A6B0027; Tue,  2 Dec 2025 15:28:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B49666B0024
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 15:28:16 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CAB8013A8EF
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 20:28:12 +0000 (UTC)
X-FDA: 84175668024.21.8828DD5
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf07.hostedemail.com (Postfix) with ESMTP id DA11840012
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 20:28:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Cr1Berhr;
	spf=pass (imf07.hostedemail.com: domain of 32UsvaQkKCH4cnkegt0jniqqing.eqonkpwz-oomxcem.qti@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=32UsvaQkKCH4cnkegt0jniqqing.eqonkpwz-oomxcem.qti@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764707291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=K+pnIulJNJt95g4PRiZ1OZGjLuh0/T2E5jVeAQXxxJo=;
	b=hV2u33XAIWJOcEQLvDcVLgu3HajdhuqRzE1pmQAHVwPyBnw25dO2WXkjUdZvtTYzsAvNPw
	PSRuUyYgDt1mZFfMVgxeovLZ7cdoeqxBUug2gnySdzHNXAjyqkaTu5Scfeo64xJejJ07mN
	AxQ+ortpEnsYn37Mr9ccmBP/bvrfWLU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764707291; a=rsa-sha256;
	cv=none;
	b=A7ouNX2go1ZnWr8oJI5iFAdqPx+t9xzjkaegIkVqkpCwmVGGHVXGYeSxggHVprYPGyXKxO
	nbrNSQkPe7EF64mt//1yEE0NfxAvB19/yKlTo5SCEEzlo7uKnAxvYj+dnS2zHVnJZPGDmO
	ipKwKSke0qQ2ifjhlJi7owQXuwHIHQU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Cr1Berhr;
	spf=pass (imf07.hostedemail.com: domain of 32UsvaQkKCH4cnkegt0jniqqing.eqonkpwz-oomxcem.qti@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=32UsvaQkKCH4cnkegt0jniqqing.eqonkpwz-oomxcem.qti@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47799717212so44624545e9.3
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 12:28:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764707289; x=1765312089; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=K+pnIulJNJt95g4PRiZ1OZGjLuh0/T2E5jVeAQXxxJo=;
        b=Cr1Berhr+vw169WgzjWgX33hnedDS6KPjM5KPozWT0RIxjqwSBlTt95ooSs9hsB3LF
         rl+cX9dzjAxFvm05Os5okEzGR3W8abX+ZfF5KKeM1+hXseU+rZE+Fc/aiaLUpbugFjkx
         fcx4DSM4YpI689dEnybJSkEjVG6sOYsCzuUT8iHNPFpxO5pPfsf+Th8sSAaUWEZAOVTn
         w6F6w9qZb508lGuE3DvHFdPqnI30VKTnfaCubPh0gfvhHKEMEcGCl4G1oHZoZHTMwmOw
         pPdiQa7zdysApUhnArC3X8KiUZ575P/5NomZJF9vm0Dre1b4i4lGla6NOyLeKVsfGcmi
         k2mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764707289; x=1765312089;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K+pnIulJNJt95g4PRiZ1OZGjLuh0/T2E5jVeAQXxxJo=;
        b=JYP7/MQ4SFRVtL8y8hs6mEQjibMaMg0M8+vEIBqopzM4VjUdYgUN+2UvW54Zd9GnEu
         vrUnwJ0R4DtNZjyJiwXiBaEM/GJcbloR8kWsbEiXO2qcRFJ/UN9LRZGjw5XufQi409ng
         1Wx7jWvysKxZpUl+Yk2Om7x7J/rcVaEg6NRbtNiZC4RxK1aA9c408iytHJG5jMSFesIJ
         lah3TP9HGnfOOnBz75+cRDXRcyBrkT8GBuec2IC4iyvvjSzcJhySwtLADJKJSPQ3x9Du
         Zdm2Xszi+iwpCWfl9+tLEro6V5zu4NUhOjuoa0uYBgrjSNlpnrmV7VMnntvlZ8n6skOb
         Oyww==
X-Forwarded-Encrypted: i=1; AJvYcCWFDFN/N6rrYJuMHYQjnd23jkGGBI5GDso4iWZyjl1EPp/YEiSSx4vrMTN2MQJXzOfZvGy6HVYeuQ==@kvack.org
X-Gm-Message-State: AOJu0YyXmTzY0CAUxAq6timykXL6oybhkaY5Ey/TcNBA61534cUMowfu
	8yl2zdLvKLD2xR+nf1Kar5NLnvzepPBpdlfFwfueCkAoB7fhv3XiLx9HcTxYLJzTZK/fA+4uDeR
	ibXsmYQfyAkwIpcmWEw==
X-Google-Smtp-Source: AGHT+IH3ZnwQuecxPwgzPlJuv0hxZRJepRnTk5tmXYQ4WU4tTZ8xIPGCG9Cfm/NQ+p0+9yexgPUvCiE9XPhmDG0=
X-Received: from wrps1.prod.google.com ([2002:adf:f801:0:b0:429:c967:33b2])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4743:b0:477:9cdb:e336 with SMTP id 5b1f17b1804b1-4792a6112d8mr8320595e9.21.1764707289252;
 Tue, 02 Dec 2025 12:28:09 -0800 (PST)
Date: Tue, 02 Dec 2025 20:27:55 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAMtLL2kC/x2MQQqAIBQFrxJ/nZCRkl0lWlQ+80OYKEQg3T1pM
 zCLmUIZiZFpagol3Jz5ClVk29Du13BAsK1OfdcrWSE4nBwgPM6IlIUx2g120wpypBrFBMfPP5y X9/0AgS4xtWAAAAA=
X-Change-Id: 20251202-inline-helpers-996f4db65e18
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=2237; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=DMU3lV0kK4kJNtnPc3Nty9uyb1cSSeng7zHph2BnL3I=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBpL0vTWsH3yDN/Q/6rER62qMlw7HA494CvIvA6k
 Xo+t+QaZICJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaS9L0wAKCRAEWL7uWMY5
 RnOsEACnF8HBaipvKfp6mXpVRzCwiqlyfZ6QeeAmd7YfE8IRUASURdP9ijwkPSEZlU3oDOyN/3M
 lrK8WFFRMJKXhCD7lZZ+UYOaLAsmHQ9rcAEOG6j2bxASbgwRjLLekdscs9hAfZov7h/QfGfHpMb
 TF0B0c4D/9HpOeBUWNR0j/l8SNHRe8d7wURImtKNSeRtpQjJeVDLp8Iy9z4DLyLnaQ81I5RtKlr
 czGEYrJSkwqdI3mOLUTXpamSSPaCsz9MZq3CG5Ioy66L1wLwPUNFEg+kc93ovxc+VT3c08omqbY
 BSnTlURzwn5/siI2pqSiV4nURivCk672LWfNDdI61Cxi2IFwr4Qm5KvePO7Q85jaAlx1kwrshoD
 bhrA23CWhDy3lvUr1MyfjuOci46kj2FW3G26Qfg5s2aTKjfEUGSxszPb3YJaCqmjaKmopOT/tI9
 9xjVZadcgpE+jAG8EfsKe+wMsFd4kWQ8hnwQlmmmlxpjvHVx8AMi4VzOXFf7bqgKisYDmm4S+R2
 7xY6EZkX0JvLIVtKlTVJ/UJztESkroU7fuH+DHKGq5mIucS6zkMvZXiuq7Gl7lxfO45J+PRfKKS
 RYZBcTnOtuQVMwtxvDHnU09VlF8X515rNezV9L2RmoVVdHtiiYiX/6p0YOJ+Ier80bXNRRZ+Va6 pKekhjpZDMT87kw==
X-Mailer: b4 0.14.2
Message-ID: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
Subject: [PATCH 0/4] Inline helpers into Rust without full LTO
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
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DA11840012
X-Stat-Signature: dwkxb8drorymhq8um9d6t8uqk3frwgmp
X-Rspam-User: 
X-HE-Tag: 1764707290-851027
X-HE-Meta: U2FsdGVkX18acrP+mIxvRPIw6aU6K1R60XUt8DS97ZTBKtr0sKL7b6ojnhjlc69YK3jcyJSzpohOn/ziIojexdVwzCEBxKtMiNV1rRruVpusXqT0dICKcjtXoeHE6+U7GQ2bvjUI4NPWMITyEQG+Vy8epqiamAk5zen8X+oUN2/w2DoOFdHTDTR/wq2iBuhTDdiICZFFoWLeGp1pwbRI+2XZXvfGyk4Zf/jka2goTOoN8C1FYIjWQxfkthgH3EZwiao+AaOFjEF/5H2GvBZ950Z9w6kdcwLfsmh3flSNfqlpXkWVxLHsjgHS2F/z3K+CpjC+xxQfJMcdE8jc6XMFkiUBpp/duXn77hpAMVmAfVAmuJ+OMKHdudPmh0s6qf5sGaP+GvGbu6yEvGusd/YCEUYGhq3gP5EQFS8Vvr+Dr+TeVjwr23PVnA4srD2T9+RbAP/3ILSwK+6oqrWc5UFM/LRhO/3TDmsGOpwiInefUbAxeZKeY4HBpQMVrDaliYC3qSLNm9Ng6n9NWBSGIVwLrGeX1AoX+KNl7261Njpoyp7LAeH7SX843Ce+2jKWe3hASJjXVV211qni+QPdvbqUzQhPaeBWAJocrpGU5ZioyvGrdcyJA/3oTYFPaQJ3tP+b1GlI7a4Hml32by5WuM/ZpI3pNwlOF1fgSbqeZx0PmNMR6fgTZ7qqiRUX8zItubh59IJK4WJj/BFSourUJEE99ue32wdnIyOgNoqlIYfjYMmXZ9oGMM9vqhzqG1dCL12wAy7kXXX9ApxMwIiibeTNWnCAarBcwb57VMf9Toy9Bvz2NpMGqPasFRKsgw5fLW5KAWwMk9wTZoate9Ud8pmzfZscbYvbBzxyyKsB+Zz5HmhSwqT34184/pTP66jxToQKcIFD94LO1ryXSAcGFTVfmmhcu3hl7QPU12jd5Wb0D7sJKb7/oe5jtZfQXh3mEC8j2GYEPvxTR2HUShWAVxE
 i5rn56X2
 qOalkxvvR2SGcuzO5N2nzJsEw3Zo7sIMe/K7YlI3DsjRul8f+JVx9NafSA1EKI9LsQcBHpVo2d5ugxwW2YXsRorqB8+0+DYiQ2wNB2OM/OHIH0SyF2xlt6QNd3MLPTfEHRNr1a2xaxTU/6Vk9KvkW+DjJYLCUYKOpOuzxINqdkd6ehUrZ36liREqEWaT/F03a9bSdYfsUmsjClhxLb+ZrSfAKpomJlS7Jcwjqj++ayf8R8JpRlKMpi9v9OxAWO+T2GV9GTbHlODyLTX4Rl7t3+ZEh1i6YTGUVYH8MnKNx0EINvWuI2crYEiNYuz7rrgyPCdOz+yG1cjsGY1dONbwsuaxrh8nIptBf1xEB+dtVo2RC8KDtQNxTDhpMBwevHdUHkDdUlXSf8vnHMP+oESA1aFUUwwpy4WvS5MAPAilSg0ZgUUNGux8otooWw+y5D2sYDjUT9sESDVhV0Y3MPNsYpmFeBL/VF+8pRopiBu07En6AEa47vk3b66lbQhF8XaQdRU+YX5UDagb+u0BZT8cM1qJB39amIk2L092AuvC+VJiGdWXgo4SBAogps/TVuvNj8TmB+++Kw0gC/QC+/rbjvsLzlPisJMAra6X6Su+RrJWyAR43I7hIyg4vGjNyo+Sl8Ud+rQmpE8sLPxZiFGZkisYMi3DBJkUO/Dsn
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
Alice Ryhl (1):
      vmalloc: export vrealloc_node_align_noprof

Gary Guo (3):
      rust: helpers: #define __rust_helper
      kbuild: rust: add `CONFIG_RUSTC_CLANG_LLVM_COMPATIBLE`
      build: rust: provide an option to inline C helpers into Rust

 Makefile                                  |  4 +++-
 init/Kconfig                              | 15 +++++++++++++++
 lib/Kconfig.debug                         | 15 +++++++++++++++
 mm/vmalloc.c                              |  1 +
 rust/Makefile                             | 26 ++++++++++++++++++++++----
 rust/exports.c                            |  5 ++++-
 rust/helpers/atomic.c                     |  5 -----
 rust/helpers/helpers.c                    | 31 +++++++++++++++++++++++++++++++
 scripts/Makefile.build                    |  5 ++++-
 scripts/atomic/gen-rust-atomic-helpers.sh |  5 -----
 10 files changed, 95 insertions(+), 17 deletions(-)
---
base-commit: 54e3eae855629702c566bd2e130d9f40e7f35bde
change-id: 20251202-inline-helpers-996f4db65e18

Best regards,
-- 
Alice Ryhl <aliceryhl@google.com>


