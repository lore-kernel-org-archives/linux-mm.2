Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F31FF45A0D
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 21:36:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DDC76B0089; Fri, 10 Apr 2026 17:36:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B4886B008A; Fri, 10 Apr 2026 17:36:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CE096B0092; Fri, 10 Apr 2026 17:36:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 497716B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:36:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E5AFEE33B5
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:36:23 +0000 (UTC)
X-FDA: 84643955046.28.11462BD
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf17.hostedemail.com (Postfix) with ESMTP id E104B40006
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:36:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bD3tuQUb;
	spf=pass (imf17.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775856982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=EgBk9xfaTaIhz7BKaj+gDTnrVInusTqsyGsO5zeX01Y=;
	b=LdBNYapOF7ltnCkADAxep0RRqrj6dOgjFdGux0DYSJ/zfYRo4zWpbH4cp8opQgEbJqtSnG
	ijKGxsO0sPvJoDQBHfzJv2NzApfyeZO1EgPwWaXgx+hiF0+H8IRY8g9Nv0AGWXwcSN8Ms5
	EnxQsfbpdjRY70RrHJ0Je4/qTo0+MMI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775856982; a=rsa-sha256;
	cv=none;
	b=lIVUjqetHqkLzj9NCCK93udKZJg5Y94taAnuoXzX2uVgbezQbwXRe8fsZHbl8Oefx6bsUE
	WUouEda47T4sz+9SzcNA2GU9VIeVaN0O7syRUgs0DTXJTjWfSPjV/yoonNhYX5orq8NpnY
	h54qxg6NL8ThflHo2150BpnWfESL+BI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bD3tuQUb;
	spf=pass (imf17.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-82418b0178cso1364866b3a.1
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775856981; x=1776461781; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EgBk9xfaTaIhz7BKaj+gDTnrVInusTqsyGsO5zeX01Y=;
        b=bD3tuQUb6fU+DaIyJy6mZeIZxuzEOAoBYPDhvYb454tn9bqAOCVE61ezB2f6zn+sv4
         1h29Z525pKZ57uhsNJk3NbPM2Xf1QziR2cYLd2L9L0PSViIF14BtIGK6nbUVKKntX/NK
         mqXxDLQ4lhjv5t0fhQGc4jQj69WjVm12XkWdzbNZWtEMBUnRn9DqkY69mTY4KXvKgfiI
         NSGGg79YRrKoIlbEDHo8INhTFyAujIjTh+7fN841ogSLstl+VIBoJGRZtK9Mvs6kcn5f
         72trJddyPPFPmKg+1c7dYWa/bNRSr4Mr0eR16dW2f6FS8yQa8YAec6QeDP+WlLe5obuF
         ovFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775856981; x=1776461781;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EgBk9xfaTaIhz7BKaj+gDTnrVInusTqsyGsO5zeX01Y=;
        b=NtivLPdbblaUUkejnWaq6IWaVfQog5Dax3LexRSXTY7z+aYMI/vTMQ5XXvM07mlcyp
         m1RW6MUZ7h7mBsixqIRVv4oQIGiDdLNYjT5FkKN0F3vRNIUyKvAbxlq2Z6s/ImSu/XTj
         /ljC9qsPXxBVusC2kpKVzCJt+Ojalk8VDIQToOx4QuqqJIpSdMACpjTaPKb0NwR7HXkL
         wGHtojrGxqaS1ihH08ifDlB0n7yh6GelZpfpPoh0d1YSAAac32NLE3NtXX45Ik82Z1SR
         d7S0bqFvAZtv9/fO/3xODBhaE7/UTADo0L/Ba4w8vEpQEx6z5zsWUiKNXyzs/9/KOvzD
         +Dyw==
X-Forwarded-Encrypted: i=1; AJvYcCUcTCQ+7ENXFXSo9sUVheXnyQIMqWuTNJKTr3pU11YnwU3pntxvIgibHEbspzXlO87JLD1o37i8eg==@kvack.org
X-Gm-Message-State: AOJu0Ywk9kLU5u4eL1i+64jy9ilxCoz7YFv1A+EaNfo7yGPu0cFd7MCP
	jwl8E5METajMAK0vRaaBLEKD/LGV3Nyxo5nbGLtzpj2iI5kNjngM+zWe
X-Gm-Gg: AeBDieufmilsoaC4U4drXEcRAC1s9PhCLIyARYIboQyONW6By21ZMiLVdbCLtbXIMlY
	0ZXxFj4HQtHhnvCDUrnGa4bxFJcp0cFdy745iMaA8BvFfbadNZb1Yb5J1jcCFMdjAXNQQhH4jyo
	i7NpQXQC0FPhAwsafA7DTu7ogGrm5SM/mT+ylHZyKforSdzaamSnRrQbH9Fpr9GYPZjaAOwmiaA
	S9RG50vC6oK8R5q8QbToeGHkyeDmHDhSgjMtOOGxc7udLrUCSVDKbZmEDKK2Up4VS+Ai9d7qmye
	ZY0oQaHBSBk+AG9ZT3gjIlRGMPMaCSRK4h0g2cTEt6MU4Oa9ab06UG6mWp4nou/bHVD/5ROHAgD
	AJ3RFweOFiOWSmX06ZPQlle9xRcghFM+9TUwdoI+i6hewgILrU7GrL4vD60mgreKWB7yw/uL6xF
	rlhjZEaicB3RBMcFRxNYuKiHIQzXHDFcgqWYJyRPKaxVsn
X-Received: by 2002:a05:6a00:12ca:b0:82f:6e7:152d with SMTP id d2e1a72fcca58-82f0c1896c9mr5253153b3a.21.1775856980448;
        Fri, 10 Apr 2026 14:36:20 -0700 (PDT)
Received: from mitchelllevy.localdomain ([131.107.1.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c4e3d41sm5111551b3a.48.2026.04.10.14.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 14:36:20 -0700 (PDT)
From: Mitchell Levy <levymitchell0@gmail.com>
Subject: [PATCH v5 0/8] rust: Add Per-CPU Variable API
Date: Fri, 10 Apr 2026 14:35:30 -0700
Message-Id: <20260410-rust-percpu-v5-0-4292380d7a41@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACJt2WkC/23Ry27DIBAF0F+JWJeKGcBAV/2PqgsM4wSpiV38U
 KvI/17sPu10OUjnXjFzZT3lRD17OFxZpin1qb2UQd8dWDj5y5F4imVmKFAJC5LnsR94Rzl0Iye
 PjVa1jl5KVkSXqUlva9rTc5lPqR/a/L6GT7C8rjmA4DY5E3DBUTgAQxaxhsfj2aeX+9Cel9hit
 KhQ3RoXtKuFiehd+GOW7gm/+7RQsLNYrCYvoogE0ut/+gzgrbFYNagroxHqfZ/87bNot1YWq2J
 0SEDGCbW36scCCL21avmnVTUoI3wMm975c+mZXsdyueFr8/P8AcOF//nXAQAA
X-Change-ID: 20240813-rust-percpu-ea2f54b5da33
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Andrew Morton <akpm@linux-foundation.org>, 
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
 Christoph Lameter <cl@linux.com>, Danilo Krummrich <dakr@kernel.org>, 
 Benno Lossin <lossin@kernel.org>, Yury Norov <yury.norov@gmail.com>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Boqun Feng <boqun@kernel.org>
Cc: Tyler Hicks <code@tyhicks.com>, Allen Pais <apais@linux.microsoft.com>, 
 linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-mm@kvack.org, Mitchell Levy <levymitchell0@gmail.com>
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775856978; l=6467;
 i=levymitchell0@gmail.com; s=20240719; h=from:subject:message-id;
 bh=hnAIvYLiIWfQPZ9W7jbssmsqX0poA4NOwFeQCUBzju0=;
 b=O9W2xljSfMWOmdcmOeMtCGsXYlEt2lu39FqFz1eSPuHWK7fz92+HJnD043jzSALQGk5bGWZwX
 io1Sw1d/PAoCPEvxoLxPy2Auqrua8a/yXGJXCCARQf2pQZ4QHVyfOG+
X-Developer-Key: i=levymitchell0@gmail.com; a=ed25519;
 pk=n6kBmUnb+UNmjVkTnDwrLwTJAEKUfs2e8E+MFPZI93E=
X-Rspamd-Queue-Id: E104B40006
X-Stat-Signature: tawownaxnudzeimtuzx1p8ic3uoh8dup
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775856981-399528
X-HE-Meta: U2FsdGVkX1+6dVECWy4AZoXNQrhO0wrkCzVPatwBYLW/+eRP9qDKbZCKJMX+tG/xhwfNxHhNddoJoGWDOy08BTZvrHau0fybS7eK3F7xn0avzQ/yvHBe4HP9y46nxVkLiB5cR4IsqEAHDF9lAtLN48e887vApWspQsZWwO8UPK+OdiI8NdTlJ0/iqhylHhegETeeu7xkx4eV7Ee9koSTxTKK0dgBJyNGykU168b8yYHz7/49/st59IVbQAnZ9enI15+EOVOfGTNDnOi8FG6Mh4/sG8BvzWK/dvWrUox/u6upSnMCmY3OVYabW6E7wUHbZbyi2GIx9TGL+c+02ZKRZEJ4VsfUYiy9MnFkVUOT7aNLFCSi6oUNa/JYAxmDuN4PCp8pmjz3W9J5MeCAw+f3Fav0AFEASoL6xWDeVFJ5TYFxHF2v6c6Pm1FY2OHJ1xToc9bU6Mh36/GMeRmjwW+P49MUASh9yR2bmfGWQCu4YB40f08wUBQsqRF3GuKmz4tGvYATIz5b5ogErODb5TqCWZhB+r00RoVQ0TO9Uaxg3IcQUKUz5y682jWxEINIK4gGFomwyYMMx/+9VIBAGTxMNmSMJOKoKVr9UWuHCkONymr9U0K4mTVCtaj1lQwB5bwxgCagnwOq1O04G0nILbsk/7LQO6oq01LQ/YzjXsjoH5B6/sh0nRVxd7zHpB4d7xi3OWCEGjurqxhGvq8ULx/JI0+hz3bveXoH55SVeexzfz3U19WKTArxKmZifODAyI+GRHzL3mUbmbRYxhjAqlZAr+KJSbuINcO63v5xnprSWXJKhN8cvgbuFXUmQj5OmaYfIs1bf5PL9EI1+vrO3MOTmMy6c47pTCPUxm326w+4Un8xmLnqOBX4eWctJAlKjb7QXpLr5bXhNumNZs9UeRG93BXZ1h03nckU9GrMTD7hAMW5hjJUyy6/XXgPVnPvmlm65mCisKDO6XZ+Xg5WYLe
 c0Yc3gWk
 TJeouhrUteFHrl/WD2fhLa+8L3QhxdPMb9OFu8D4EBgl9AZSEekSRULVy57L3ecbtOHRFOSA8ODCSNkatmaCZrz2JXkMe8Y6hcza81R/EQfRESf+CyJrLZ0s3sfiMXUq7x7YnAS0m/NLPoY5asEl08KvwroI3CiPxpJFEwW8SCj8psefJuzfXpN+4ssgD87UsK9OMx6AI6yyvKUEgt07NqP/uTF+CCWxo4F1Y8UdpoBYYwbQm5TYZAUSI0koNPwStC2xErNdk21R7DLEP3q8vpQo+7bNX7//rba5W1DMdzmI48Pa7XB7RggKrXqkeGMG8t0s2SR9QNp599Tz4ermGzI24XPjRXvVmJcwS4c6UauvzzstCweZFGFZb/xCgiFE3ih+29lquE0ZoFVy0FhkqtW66Z7LXIFlL4WcpJ57NN+Tzeu5WbJcV4twp65V8AiEHEgSMHZQkFojxMuV/Qfg0RgWg7EYoSl1rg2wN97kLxFiXNCSQndTOpox6hay3izvkpBKhCGfLHPW0UzI=
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
Changes in v5:
- Rebased
- Documentation clarifications, typo fixes
- Added an early out in `CpumaskIter::next` to avoid WARNs under certain
  configs
- `CpuGuard` functions are now `#[inline]`
- `PerCpuNumeric`s now use `ptr::cast<$ty>` to get a `*mut $ty` rather than
  `ptr::cast<*mut $ty` which gives a `*mut *mut $ty`.
- Changed `make_optimization_test!`'s `CpuGuard` to be bound to a name
  rather than `_` to avoid it getting dropped immediately
- Remove `DynamicPerCpu::alloc` in patch 8 since it's not necessary at
  that point
- `CheckedPerCpu::get` now has a `&self` reciever rather than a `&mut
  reciever`.
- Consolidated the non-zeroable dynamic per-cpu support into the
  introductory patches
- `CpuGuard`s were previously automatically `Send` and `Sync`, even
  though that doesn't make sense for that type. So, added a
  `PhantomData<*const ()>` to prevent those from automatically being
  applied.
- Impl `FusedIterator` for the cpumask iterator
- Used the cached `self.ptr` in `DynamicPerCpu`'s `get` and `get_mut`
  since there's no reason not to save the indirection.
- Added `$crate::percpu::` to `PerCpuSyncMarkerType` and
  `StaticPerCpuSymbol` in the define_per_cpu! macro to avoid needing
  extra imports where its used. (Thanks Andreas Hindborg)
- Cleaned up logic in `CpumaskIter::next` (Thanks Yury Norov)
- Link to v4: https://lore.kernel.org/r/20251105-rust-percpu-v4-0-984b1470adcb@gmail.com

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
Mitchell Levy (8):
      rust: cpumask: Add a `Cpumask` iterator
      rust: cpumask: Add getters for globally defined cpumasks
      rust: percpu: Add C bindings for per-CPU variable API
      rust: percpu: introduce a rust API for static per-CPU variables
      rust: percpu: introduce a rust API for dynamic per-CPU variables
      rust: percpu: add a rust per-CPU variable sample
      rust: percpu: Add pin-hole optimizations for numerics
      rust: percpu: cache per-CPU pointers in the dynamic case

 rust/helpers/cpumask.c          |   6 +
 rust/helpers/helpers.c          |   2 +
 rust/helpers/percpu.c           |  22 +++
 rust/helpers/preempt.c          |  15 ++
 rust/kernel/cpumask.rs          |  97 ++++++++++++-
 rust/kernel/lib.rs              |   3 +
 rust/kernel/percpu.rs           | 282 ++++++++++++++++++++++++++++++++++++
 rust/kernel/percpu/cpu_guard.rs |  48 ++++++
 rust/kernel/percpu/dynamic.rs   | 227 +++++++++++++++++++++++++++++
 rust/kernel/percpu/numeric.rs   | 138 ++++++++++++++++++
 rust/kernel/percpu/static_.rs   | 218 ++++++++++++++++++++++++++++
 samples/rust/Kconfig            |   9 ++
 samples/rust/Makefile           |   1 +
 samples/rust/rust_percpu.rs     | 314 ++++++++++++++++++++++++++++++++++++++++
 14 files changed, 1381 insertions(+), 1 deletion(-)
---
base-commit: 8a23051ed8584215b22368e9501f771ef98f0c1d
change-id: 20240813-rust-percpu-ea2f54b5da33

Best regards,
--  
Mitchell Levy <levymitchell0@gmail.com>


