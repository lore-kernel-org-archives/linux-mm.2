Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3BF2D1266A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 20:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D07E6B0027; Tue,  2 Dec 2025 15:28:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 799796B0029; Tue,  2 Dec 2025 15:28:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 639086B002A; Tue,  2 Dec 2025 15:28:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 50CFE6B0027
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 15:28:17 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1461EC02EC
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 20:28:17 +0000 (UTC)
X-FDA: 84175668234.08.12E923B
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2AA431C000A
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 20:28:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NKZlOvqw;
	spf=pass (imf21.hostedemail.com: domain of 33UsvaQkKCIIgroikx4nrmuumrk.iusrot03-ssq1giq.uxm@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=33UsvaQkKCIIgroikx4nrmuumrk.iusrot03-ssq1giq.uxm@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764707295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gzxkQHE3Gn13GhwfvC/ki50S4oawaHmvikFNCkwElMo=;
	b=Kzyf28b5N6CGkwnitjZJ0Ht6mmeRnCqpPGD2VFT5nsK4pN0BRTokPcMeQKLWGtnS5uqJFW
	OAXeAb9InV8+3E0skspGIdcEQVmPOhy9GUED4xhhdYl0HzH/GO/QrAjwupCgElRGgY35Ip
	9peFXJPsItpnoSwMLr87f5ww+u2LCws=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764707295; a=rsa-sha256;
	cv=none;
	b=uHc/mzeJJzHbaL+HvQxO4qyp71JxQCoy7DsHNz98ExaaQ8DjiJb6zWYI/r5ECcQxf9m1t3
	9bDnjusA7Ug7nfD8rcDRI5IEVHkaJdJk+62On+6C3YzpPkaHDjYl8se8BAvR+cRTWDxKBs
	USvCCSf5aRIsTYpyJoNkduJGq9iExyM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NKZlOvqw;
	spf=pass (imf21.hostedemail.com: domain of 33UsvaQkKCIIgroikx4nrmuumrk.iusrot03-ssq1giq.uxm@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=33UsvaQkKCIIgroikx4nrmuumrk.iusrot03-ssq1giq.uxm@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-42e2e3c3e1aso1830704f8f.1
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 12:28:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764707294; x=1765312094; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gzxkQHE3Gn13GhwfvC/ki50S4oawaHmvikFNCkwElMo=;
        b=NKZlOvqw9yMbDHk5nQUqfF/ldAtDA8jUOnxwmQNiuA0350ye6lCuo8mlsy8IteO7cA
         NbjubSdMJsjofVSshYq+C+b4b9go0VU/l8lCKpzy6ORPR0tTL8VTrXS6Hep9GzSZ/jIR
         BVxafAjVeRoB8uL1EwoE3TRQdILyOHREFczqgUPSXzIksufKb5pyfO57CKjOv5J9BSXl
         ZTdaanHPmhbPqdryvI9zBi+P67ZRXQjSi3L0aqG4320KW0z7h72SAz4NytHNGIPjgcj6
         5NBItse3tiV//TFfX+xO/FZWuoAisoipPQ7Ju45b1RZhSpudZH6x/w7vLpeWcezoQwcc
         YAbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764707294; x=1765312094;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gzxkQHE3Gn13GhwfvC/ki50S4oawaHmvikFNCkwElMo=;
        b=SLBhRy+1Imv5nPzrOhBGwimLpeRUHEWnD81g4ZW6SSH8qd7Rm9XEcpsXTI3dlZm4F9
         pOQrg+dCvdQMi62clpp4L1jRWbkHOtQ5OHE71EXi5jj4XkVSSBX9dJfPMwxRtz3njhIC
         kTo8hPO0xPl1pyOebdHb459nUvbduUk2y78A2XgPPYdqK2yueueVI8bWV/Rrrrz8UqCm
         l09ETlPx6m5+GGavAA8rlWVQHVtdyozcjMIcXnRV3RuKqA2jmjLl6+uVEMlODoho5Q9G
         vdpVMnkN45BSNi6GbPFWDLnBMfMbQdIAiGqEDVZH1Fjt2N6mwXnLrT5OmMwiC2+uruKT
         JXyA==
X-Forwarded-Encrypted: i=1; AJvYcCXC8fuKwUN+yRHBQyUrsoyiWx85BOfJJntYMJdHGaPWf3UgD+xIlW5almCeUJZ/uFyAdkSxZSnWhg==@kvack.org
X-Gm-Message-State: AOJu0YxBiwV/sfOygbHa5FTTsKOPD44/C+ERfrAj/Zu03KEnghap6lR5
	JBen0od3mZ0hIobVWCQXrpB17HLTFda+ef1/EDMcs+dJfSoSNW1IQDHBVvyUSfM8LefS66/4Ylb
	eecFtyk+UPyHo4XavBQ==
X-Google-Smtp-Source: AGHT+IGSHYTHK44+Q/MF6SQhcldsTZ4F1l/P7eqEkOlosij1EkIh4u00KVkeS7lVD1xE0j+H0LySU44dB3+wV1E=
X-Received: from wrbl4.prod.google.com ([2002:adf:a384:0:b0:42c:c2d6:2ac])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2502:b0:429:d3c9:b889 with SMTP id ffacd0b85a97d-42f721fc486mr463737f8f.1.1764707293233;
 Tue, 02 Dec 2025 12:28:13 -0800 (PST)
Date: Tue, 02 Dec 2025 20:27:58 +0000
In-Reply-To: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
Mime-Version: 1.0
References: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=1823; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=XPDdA9qRPdYsgm5Nsj04MFhk3BGo//T0H/GXZaSfcnk=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBpL0vXEU3vfH0ez+fWa3XM7NL47DJ51BTPUHznb
 cVT8tuwz0eJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaS9L1wAKCRAEWL7uWMY5
 Rr5AEACDSrcLuNKFX5r42YLqnad/vd877J0UJtGVWFmfriVe5P6Y6yqMkDEJ4ZMuWqwR0CnkulQ
 iiVfYamb7odLVlOubnoHlMlj7AWP0dyPUvMSZSqNcAWaYbGW483ZRaOxEZ4MVgvv0mP7aVNfzTR
 AXKUkJtJQsTI3jC+m/+ONvFAwhiG/+ExbJiOQBnFIeA/dL5OLSlAzjBaKqkw0Hsjntsfgglh0AU
 gB0JD/vBPuKmQIVm80pytBPt6BxtuYQkBmnCsIF5IvJhOPmqYIUPGzEKdP/jNzFe+mQ1tYdDU9M
 7OjSUVfVipG9L/SkRnOOZrtyBAw3ajN898MH9PL9BL76iul3Xq5SYqIYisYp1EkVSeAV1nI1nQ0
 PVAfjmGqhZJAhvdAiFK4JJe89ZSYbg8lS2SM2eCdcS/YvCndmO7zlcsm4tN/dEbSsIrdJe9t/Jq
 3T2AaP31hxuZkqIDVjDWYWot0m/f4ZO1DDvtY2NCpcCuooX/eqS89rOiC+QPd3ohGU3j6DpUhyb
 mfcdw6Kb2qywcFJVSyoT3wGIFQxVosTnahQ4kEHggZST0Fg4rfiMos2UpeMS03pTZ2tJtDFKVcy
 ZpVWYPeUkijjVyO5ttcLvgrMtnNiUzhdEYUK8ju5sJYNmGueW9AmruIzbdTRORaqrYkAvlfEdrO 8DhJzFKcq8IlMyA==
X-Mailer: b4 0.14.2
Message-ID: <20251202-inline-helpers-v1-3-879dae33a66a@google.com>
Subject: [PATCH 3/4] kbuild: rust: add `CONFIG_RUSTC_CLANG_LLVM_COMPATIBLE`
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
X-Rspamd-Queue-Id: 2AA431C000A
X-Stat-Signature: 9r7y8dzyt1nyc87d9w61sc4iitn6tn8p
X-HE-Tag: 1764707294-391665
X-HE-Meta: U2FsdGVkX18ZaLGFG9f8EckMyRW5gGOVXwFuyk2yMJ3E1Vcr78uEU14XsusIEA09g7iJdAFqpKobWD+dht3BM9cI54f4+gwqyI1mQkQ7XhrPZbW3uNrcK9gSukA4IuYfDFFW2+269+jA/19CgXqieNzCan4fcFXIjANTypUnxre6GmfjXGRqeqX+E8jkx+PJcr2DObPOEP2RdOf0nllN/W8hqXpDHANqLmSgXOnl2FFzL0MBcKn+0XDJOxG7H8Y7CUZK0QNomm/bFxA/PDAKLA60A4eGbouXg1DMUXTLbcUZOz3rtjs0dzccrza9aoVPsWEokaWswK0WuTKAVMMgiTTKLVRNWsCeKtVFFOMaBuPnoDRvC5nwNt5oz2aOUMUM+U0FmaXavrXakCXwCM6j80Y14/m3eNCJyaXx4YYMGx/wwavAwDfBEr5WBzvmu1rkq263pzKhnEtbSLLg7slXVQ+eO8VNqnOV3MMdEQRHLW7HKzvuYf5FtOnqq04NzvMtYXLSw7h/+PfIxk8fSHC9+ZU+ojtFNOjGA77BdDeIWkhyQ2r9aYWOnIkk6ZouQ3O0M/VwsCDj8FLiU8BVMPOTEEOoVX54IF5PlhtqsvIu2usLwHsjXt7uBAhiVoEhsF2b/IPBCnkZZjJcoBkkayG9oWhEKY03VuAxkn71mwQ2AIw6NZYOkyZ0IUBW28klcNoTDUcF2u0zzWMYHW/fPRAbq1wiWYvmKLoUagb0o9DYgvkPCU+k4aZatPbSfqAAYURHqAgKNf9arlceC5kY05+jIvjt4BR+0VMeUETf8iq+i/u7GfDdTuvrUUwxCYcuqOW/tKi78SDSv18TsO05X9nF0+gww/hC+/fcQqG8kV/4BdnoDiSgE1qBSbfhxaQ3P4cGnHSAzXGBea4ZYYldyfw+GfsactUqNKRhB992hSPqgeZqGJDjgJ4N/Zrii2BWH6nVqgOBSAo9uPXWF3kRuem
 icbIqTDG
 kjvIgC0PpnN7IwVVD0FlNTiCY+QP3tYcLkBSrs/yknhuJ6A2DDV7woPkaG6IaOS4CW2M6gGKfkc+AVdZQ70HR+8G68ZX3TKP7zDWm9aoLAOLswPE/H2P2YtGgp34EvLyBJk8WrLde4MyjU9IHeDEWPB7cINv3tYKJBIoTPMb/xCfj1oPw9ncz/IeiPM/h0ulS588O95n3Gj4qDOsPKVj72qlRlp/gX22hqRQHSu6VYdLCbhy7xKBKounSvD1MAYK5ADfhoPnMQ07/E6zSal5CtRVNI0aU55kR11G5tWCyxEsecfUuVa5ELfQetaBj2umJytCRpmJULZce4V19CDsqKcbUEnnyebYw1j6xrTKUIPTpN00fiP079kWnxPFBwl7rSDYVkRWdkTvScrHBLkP4KdoKU/SaQkjxY27K+c9gvcVMoh84k7vx4mUPDeaeSiTyz/GvwnpA424ChMHG+Ehi7NJj6jccB4xeJk3+5zEFihn9qoq/+gI3rKVGcssajAgZDWkzkeCdGLP2EXjvcztLBIwQxniBc3kTFXDFgzUZjTLhRAoXBk3IJ5f9738Ke978XZmHjHMrhFfwB0j4TJmsYSFUwDDbyIfQKCGM1BsfoZwjU5u9/uNPfEL41Th4F7dJYiQE0q5m2tzmA5Q76wDf7nVqC0GJixoaEi4Mri+KCYkK6Qtyz32asMefZKXOfdRt7t0UMcpUvaHZGWT6qVUb8ZQ4QYQNW3IwaEOfIrP0UMPJMaXD6WpDEGKzxrTLG8+PPj3RGNtEuJnfCBfGc+DGiPRJduEa6N9t6ZMb+qrXeWV/HBoPM+yhkqrzhxHVwjMIZ8TOWbE0Y2JINXCgENztL1L7K7Qyt0pA1NXQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Gary Guo <gary@garyguo.net>

This config detects if Rust and Clang have matching LLVM major version.
All IR or bitcode operations (e.g. LTO) rely on LLVM major version to be
matching, otherwise it may generate errors, or worse, miscompile silently
due to change of IR semantics.

It's usually suggested to use the exact same LLVM version, but this can
be difficult to guarantee. Rust's suggestion [1] is also major-version only,
so I think this check is sufficient for the kernel.

Link: https://doc.rust-lang.org/rustc/linker-plugin-lto.html [1]
Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>
Signed-off-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Matthew Maurer <mmaurer@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 init/Kconfig | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/init/Kconfig b/init/Kconfig
index cab3ad28ca49e7ac930207c9cde8d431d55dc7af..d35d0ddee573d09997087a0f99dee7c7c9a66ae3 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -82,6 +82,21 @@ config RUSTC_LLVM_VERSION
 	int
 	default $(rustc-llvm-version)
 
+config RUSTC_LLVM_MAJOR_VERSION
+	int
+	default $(shell,expr $(rustc-llvm-version) / 10000)
+
+config RUSTC_CLANG_LLVM_COMPATIBLE
+	bool
+	default y if CC_IS_CLANG && RUSTC_LLVM_MAJOR_VERSION = $(shell,expr $(cc-version) / 10000)
+	help
+	  This indicates whether Rust and Clang use LLVM of the same major
+	  version.
+
+	  Operations involving handling LLVM IR or bitcode (e.g. cross-language
+	  LTO) requires the same LLVM major version to work properly. For best
+	  compatibility it is recommended that the exact same LLVM is used.
+
 config CC_CAN_LINK
 	bool
 	default $(success,$(srctree)/scripts/cc-can-link.sh $(CC) $(CLANG_FLAGS) $(USERCFLAGS) $(USERLDFLAGS) $(m64-flag)) if 64BIT

-- 
2.52.0.158.g65b55ccf14-goog


