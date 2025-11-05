Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59D3CCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 23:02:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E54E8E0005; Wed,  5 Nov 2025 18:02:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BCAD8E0002; Wed,  5 Nov 2025 18:02:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D21E8E0005; Wed,  5 Nov 2025 18:02:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A3DA8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 18:02:30 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B04461404A6
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 23:02:29 +0000 (UTC)
X-FDA: 84078079218.15.158FB46
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id AFB771C000C
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 23:02:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HX8f3ZY4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762383747; a=rsa-sha256;
	cv=none;
	b=RVEt2J4pcpZfJXiQmKBn8eYnY5dY0ZfGm1GjzO07H98ChbfJoNXsiKRp7weTfMoRhIcvY1
	hHwiHqodd54Q5iktk+YEF0wtYruILxNJY1+bE+8gBgASN/8De9WxC6V4XvJnFLcZuH2U1M
	O7P9VRpxTvCw3yhM0a4SXc+Ap23UrAo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HX8f3ZY4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762383747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=m5P8jXB+dIsfoWVQD4/Et/l6O3PGrt87olQD+9nhTtY=;
	b=8g3/qn1gN+DiYNtRnxIZv5Al7m8CbpQuCQ0biaeg8sDHixGjDUPOSQVNgmc6FH+nfSmEh2
	uBQL32QfmfUKAWXsalY9hhm0XOq3bcqwz/2pI+O8QDdMK/MRNpe2KxqiRTIK0+pV2/5j38
	LgeynguyuI63jxeAYUiBE+YyEAiKj8s=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2964d616df7so4835225ad.3
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 15:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762383746; x=1762988546; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=m5P8jXB+dIsfoWVQD4/Et/l6O3PGrt87olQD+9nhTtY=;
        b=HX8f3ZY4YoagRPoFbDSDUHgJcBKk1kpjXPj9xPAGp5SV6k1VVVtpomj/dV/lzY0XmG
         jHAmOS+R7FK8dbGzAjJ5Yo8IaWERgETPUIOiXg9SzMDlfXKwuike0CSTZMSbz/M3hDMN
         p3RYOPke3GeaKt2F55SGx3BaZVrqShqSrurd30RcU0nct2RgTkYtx6AZnrlva0iI66Zs
         P2gIoDqAv5x7qx2t6XrGPNKdfaFWbkOEegYG6+uJ5L+A2s8j2rmVPGeMSeDIsVNcoBPn
         PEwMGXEu+1jxCFqM5s9eKZmOlx7rdq0sK+kF0CT2nx0FrASyyH753Zl3XLXWQaxda09o
         8NvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762383746; x=1762988546;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m5P8jXB+dIsfoWVQD4/Et/l6O3PGrt87olQD+9nhTtY=;
        b=GzcWGXwZyK0RAbdNskPqlsS3sgblmaHkrU5H8jsGWFVrz2TtEGGxvxWqORChMl6Mlc
         e6YlQojIRUP12lQVhrufLXLiH5tJ9o5Pkv9jW7e9KkivJGhSPsDpzLTPIfS/57VdEM53
         Zag54W1lXDYe+bUWMOTQqzQ7Wa/sFGJ6n1FAPn1If4CxTP1LZA/wP7XIn+ERPv8foZ8Z
         E/aGjAPGKVlGVKUoDtAqtHTAy6mBPOgySpxMfKLmisTwrNyD+r4VaZWFTK4wdfXfh8Pl
         VXTBRUxtt8Ytq5fPm2VK+0TG/8zRGeMSqri+/XGmaUcb7kz2P0wxfD7vrQaZP0Ik49GJ
         U+Ow==
X-Forwarded-Encrypted: i=1; AJvYcCWxVO+5BXNQGChqZJYJM1+XdYc0+R9EWxeHrv26onOUToepf/f42RIJfRmF91FsmB4d7b30New5cQ==@kvack.org
X-Gm-Message-State: AOJu0YwvrhYDI06seSeYJMgI6jil95/VbiDqiA9XMYT26ItUBlB8L/Ze
	vR8+0RH7hYboXt22FhJQaql2b8ImPazzdd4hjRr1Ei5WjlNyri611IC7
X-Gm-Gg: ASbGncvKeJftgE/JRU+mxONFRCtPNYs8BIOtA4NTNWncWg3OXc5o0ENakq02ZEhAWct
	8pOfW39XSpU8+KJ9lCSVyszDJKvQuGikEZMD3ho6/0A1HGWqSn5uFtUrZrMiXdFP6xOeJOQmojm
	shlNMdtTw6tlhNNC/0ZIssnIQaXt05IWQDLUGB9voIlusznh6MMKcZwlfHzJEU1GojlLVWlj0XP
	mXy09OTrZPKkcrXf1NVNe03nvfLjoxx9COEorRikDYtPUX/mwPLranQ6rdJidG+Ybpl1d9AFeR6
	Lpl8BgkkoQIxhMMXZrHz0/v4SlZeO3MxPkiqDaK/c6j+hxIwgGnvLH1BYdTT4CqeKLhsgSAg7rY
	0Ph+p6ZmMN9XRRs6O0BV/ADgyCF4icykaOfBtglzyf7ZeGMNnJbsFIWZWPPsYzvzh0MGSCLWysW
	ro1HEuflus0VUNmJbajjNxlukTNNdeCy+695/0ITlYX2g7
X-Google-Smtp-Source: AGHT+IFcWQsxhsDJYw8BvHJ+cu4xy3Cbjz4NgQDldTTtvAA02XiwTojS7CTRnWKlbDVxorN9sS9LUA==
X-Received: by 2002:a17:902:d488:b0:26d:d860:3dae with SMTP id d9443c01a7336-2962ad83389mr72820715ad.3.1762383746250;
        Wed, 05 Nov 2025 15:02:26 -0800 (PST)
Received: from mitchelllevy.localdomain ([131.107.147.147])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2965096839asm6325645ad.13.2025.11.05.15.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 15:02:25 -0800 (PST)
From: Mitchell Levy <levymitchell0@gmail.com>
Subject: [PATCH v4 0/9] rust: Add Per-CPU Variable API
Date: Wed, 05 Nov 2025 15:01:12 -0800
Message-Id: <20251105-rust-percpu-v4-0-984b1470adcb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADjXC2kC/22Q3U7EIBBGX2XDtRhmgAJe+R7GCwrTXRJ3W6FtN
 Ju+u7Rq3B8vv0nOOcmcWaGcqLCn3ZllmlNJ/akO9bBj4eBPe+Ip1s1QoBIWJM9TGflAOQwTJ4+
 dVq2OXkpWiSFTlz4228tr3YdUxj5/bvIZ1uvmAQR35ZmBC47CARiyiC08748+vT2G/rhqK6NFg
 +qecUG7VpiI3oULZm3P+NvTQsENi5XV5EUUkUB6/U/PAN4zFpsOdWM0Qnvbk389i/aalZVVMTo
 kIOOEumSX78dlep/q98ef7y3LF3S2LbabAQAA
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Andrew Morton <akpm@linux-foundation.org>, 
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
 Christoph Lameter <cl@linux.com>, Danilo Krummrich <dakr@kernel.org>, 
 Benno Lossin <lossin@kernel.org>, Yury Norov <yury.norov@gmail.com>, 
 Viresh Kumar <viresh.kumar@linaro.org>
Cc: Tyler Hicks <code@tyhicks.com>, Allen Pais <apais@linux.microsoft.com>, 
 linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-mm@kvack.org, Mitchell Levy <levymitchell0@gmail.com>
X-Mailer: b4 0.14.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762383744; l=5076;
 i=levymitchell0@gmail.com; s=20240719; h=from:subject:message-id;
 bh=unKKUkPd5pRTqG3L9Z0F/ADhxBnwusdEiP6PTAc6qPM=;
 b=wJYwix5/zj4Vy0vQM6M/OltQSTZy+YEPGtMMsjgYxv3Uz1EwTP5wCYJJImuAi/rTC8Jt8quPT
 BKnBugpFEAqA+8tOxJtVekq+qC4/uZGDxtzL43n7if+USvw9ItaSj9r
X-Developer-Key: i=levymitchell0@gmail.com; a=ed25519;
 pk=n6kBmUnb+UNmjVkTnDwrLwTJAEKUfs2e8E+MFPZI93E=
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AFB771C000C
X-Stat-Signature: kzme6b86dpdesnkrcek1by8p5bfgn8hw
X-HE-Tag: 1762383747-859379
X-HE-Meta: U2FsdGVkX18pYv7sqyQ8i6nmHu5xnRTivgBtoPa92NCZ8S+i4HxGci15fdqsK1mKj0wLXmX4NVm7ODR/tKwgQcac4K8aAIvMzSrO1ujQSCCmm5xrDt6l9DlamwKTvMUw5t6+h5Z7K0NwVlaU9sQdtOgx32LeEbx3iMjePOywbAc5u3QuHqHGDkR8+lN2ThKNxqh6B46pGfq4cYGdrNgezHSCZjEWemXrdyfp8MqsmfYoYHXDOOKeXYS7+u/L8wDk6xib/wWFZVSXT6h45/FEJdH4pZS/8Cn19vfVD/LcJUJpvoZw/9gaxu7oCk0j/u/6cFdTRU/886XM42LioPhHwgOr934HItyKJcT0KqCOZW6CwAZ9lAKAlm1XdlURqpOTCYh2O6URFUtD6++m0Irntp0uzDGhiE17a964bP2ybxEKs4z+33bBrCBMj8dJjUZ5UJMWJCKry00M3bRnx+8pnhi0zHjgRSDo2T3MbvEsxENaeQrQRbjk1quG2J6tebk6SKmYDBJLDgVdvtZPddCKLNpiLMlim4dgiHr6lgDUVeEvAzd+Hhhd3KfujTyJtk7o4d/ttVY1wSmOxL8ZhsJgSYwZYg6/C6LIAv4FesL98e+UVVtvYJMP3QqjhxRgjTy0EwYTBPLqkTemrVH6vrDQfq4CCYO2iocxwwvPICfYzU5yWqs9sS5uN641L2TpKtOBsWMlvAR1svL26hgZWgaV815pU5rw9k6KGy2gzzVcv/Io2K8iL6kW/w4TDYTA06Ut2CvL4Z0zAaomHNHm5xbmmy70zEDnXfwL+aB0j3HYCbuwZWeTIrtahmYFWv1E144IPr0e+0KXp1FrICmC7zaYcWA02FgUjirI0fpsRQGw+cjLLw355At+SFu8FZ4YA8ujvIog7mcQ1TAd7gj71s/rLCMqKpPKZDOMvsVzDSWvZocTaDBNJ02zcuAwEP/W0NaF65/YhtU1amlqZ9aQj8g
 M7l8Xy63
 9T7WxqCheUrLucr142uONaYo5m48femGy92pnx3ThXqHdUA6Ou2FTeycPAIhMSqD9lYURkv6LZaPWfUpwcY2VIhbyfdA1RtnqTLnwvtM91fqP3TQ6q62kto4KgG+MiDLkgmKJDZWYRbnixiq+tSPyYd0gLYKfDYro9NudCjzcK/pKqiedkmeN9BWe7FEgsKUKYz4UL9BdQF1iiRv8f0yuzxEegeHD1f8ix39APxyh5VnTS3WhLJfzH7OjvS37ZvFbRS+FYYK3l/Pds6KA0lnnFhuMLr6SLyXP4//QflQI/j7Amfmg/0zrvupibcF4Vm5r7SjoK7dO6Gr8Wyoz1KNnoFJPbMxYQ6MvCX0/fZthx0+gozy+TeUKLivgH1KJP1YsaRBlXvKWafXsA4BDsedEyw/ALxiujz5QotEy88ukvcWr+W0ETvXpf0j0i+hUhYLuFWuuM5Atz5VjK2teI9k7AOuXzJYKXtmZq8lqjO2B81ncalgNm39tbfoelahVhSXTo2mVtUmNMSppVlI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series adds an API for declaring and using per-CPU variables from
Rust, and it also adds support for Rust access to C per-CPU variables
(subject to some soundness requirements). It also adds a small sample
module, samples/rust/rust_percpu.rs, in the vein of lib/percpu_test.c.

---
Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>

---
Changes in v4:
- Split what was the first patch into three patches (Thanks Yury Norov)
- Add intra-doc links to rustdoc comments (Thanks Miguel Ojeda)
- `get_remote_ptr` is no longer unsafe (Thanks Miguel Ojeda)
- Renamed the CPU mask getters to be more clear (Thanks Yury Norov)
- Add an `ExternStaticPerCpuSymbol` type for static per-CPU variables
  shared with C in order to make the extra soundness requirements for
  these variables more explicit.
- Properly drop the contents of dynamically allocated per-CPUs when the
  `DynamicPerCpu` is dropped, and properly document that
  `PerCpuAllocation` does not handle dropping values in the allocation.
- Functions on the numeric token types are now `#[inline]`
- Safety requirements of `PerCpuPtr` functions now include the fact that
  the pointed-to allocation must be live and appropriately laid out in
  memory, and SAFETY comments of uses of these functions have been
  updated to reflect these requirements.
- Included the cpumask patches first, since it might make sense for
  these to be merged separately.
- Documentation improvements throughout.
- Link to v3: https://lore.kernel.org/r/20250828-rust-percpu-v3-0-4dd92e1e7904@gmail.com

Changes in v3:
- Add a `CheckedPerCpuToken` that enables usage of per-CPU variables via
  a `&T`, allowing for a wholly safe interface when `T` allows for
  interior mutability (Thanks Benno Lossin)
- Add support for non-zeroable types to be used in a `DynamicPerCpu`.
- Remove necessity for `unsafe` to get a `StaticPerCpu` from its
  declaration (Thanks Benno Lossin)
- Allow the declaration of static per-CPU variables of types that are
  `!Sync`.
- Implement `PerCpuPtr` in terms of `MaybeUninit<T>` rather than `T` so
  as to keep all invariants in the `DynamicPerCpu` and `StaticPerCpu`
  types --- this would also enable `PerCpuPtr` to be used in a per-CPU
  type that does lazy initialization.
- Link to v2: https://lore.kernel.org/r/20250712-rust-percpu-v2-0-826f2567521b@gmail.com

Changes in v2:
- Fix kernel test robot issues
- Fix documentation error
- Require `T: Zeroable` in the dynamic case
- Link to v1: https://lore.kernel.org/r/20250624-rust-percpu-v1-0-9c59b07d2a9c@gmail.com

Changes in v1:
- Use wrapping_add in `PerCpuPtr::get_ref` since overflow is expected.
- Separate the dynamic and static cases, with shared logic in a
  `PerCpuPtr` type.
- Implement pin-hole optimizations for numeric types
- Don't assume `GFP_KERNEL` when allocating the `Arc` in the dynamic
  case.
- Link to RFC v2: https://lore.kernel.org/r/20250414-rust-percpu-v2-0-5ea0d0de13a5@gmail.com

Changes in RFC v2:
- Renamed PerCpuVariable to StaticPerCpuSymbol to be more descriptive
- Support dynamically allocated per-CPU variables via the
  PerCpuAllocation type. Rework statically allocated variables to use
  this new type.
- Make use of a token/closure-based API via the PerCpu and PerCpuToken
  types, rather than an API based on PerCpuRef that automatically
  Deref(Mut)'s into a &(mut) T.
- Rebased
- Link to RFC: https://lore.kernel.org/r/20241219-rust-percpu-v1-0-209117e822b1@gmail.com

---
Mitchell Levy (9):
      rust: cpumask: Add a `Cpumask` iterator
      rust: cpumask: Add getters for globally defined cpumasks
      rust: percpu: Add C bindings for per-CPU variable API
      rust: percpu: introduce a rust API for static per-CPU variables
      rust: percpu: introduce a rust API for dynamic per-CPU variables
      rust: percpu: add a rust per-CPU variable sample
      rust: percpu: Support non-zeroable types for DynamicPerCpu
      rust: percpu: Add pin-hole optimizations for numerics
      rust: percpu: cache per-CPU pointers in the dynamic case

 rust/helpers/cpumask.c          |   5 +
 rust/helpers/helpers.c          |   2 +
 rust/helpers/percpu.c           |  20 +++
 rust/helpers/preempt.c          |  14 ++
 rust/kernel/cpumask.rs          |  94 ++++++++++++-
 rust/kernel/lib.rs              |   3 +
 rust/kernel/percpu.rs           | 273 +++++++++++++++++++++++++++++++++++++
 rust/kernel/percpu/cpu_guard.rs |  36 +++++
 rust/kernel/percpu/dynamic.rs   | 184 +++++++++++++++++++++++++
 rust/kernel/percpu/numeric.rs   | 138 +++++++++++++++++++
 rust/kernel/percpu/static_.rs   | 218 +++++++++++++++++++++++++++++
 samples/rust/Kconfig            |   9 ++
 samples/rust/Makefile           |   1 +
 samples/rust/rust_percpu.rs     | 294 ++++++++++++++++++++++++++++++++++++++++
 14 files changed, 1290 insertions(+), 1 deletion(-)
---
base-commit: f3f6b3664302e16ef1c6b91034a72df5564d6b8a
change-id: 20240813-rust-percpu-ea2f54b5da33

Best regards,
-- 
Mitchell Levy <levymitchell0@gmail.com>


