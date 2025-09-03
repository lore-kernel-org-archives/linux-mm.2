Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71D20CA1010
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 21:42:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB0E38E0007; Wed,  3 Sep 2025 17:42:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C87428E0001; Wed,  3 Sep 2025 17:42:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9CA88E0007; Wed,  3 Sep 2025 17:42:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A31928E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 17:42:15 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1E3ED1604E0
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 21:42:15 +0000 (UTC)
X-FDA: 83849262630.18.2832843
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2256B40005
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 21:42:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T0FltFFV;
	spf=pass (imf07.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=yury.norov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756935733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=913G5mrad7tqw4Q34JzVSSV+9stS80/tzD0diJIXDJg=;
	b=LJQF+sOksOtleOy65Iwh9U8UI3NEdAeq5UBE1nuFntBcEt9/Fc3/zXzVKB50a590QAqJ4Y
	iNW6HJK2ofPQq+new1pmOnV4AN5M9tX+nLYQj0hjFfOCOLXIYs0PH3CuPi2oPGcnD46omh
	SJ0Zh7PHkm5VYnKVlkcr5dMvgSQpiWg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756935733; a=rsa-sha256;
	cv=none;
	b=3tOddtzRkyvSmbu8BddHa6Pz4vydG9faqrjmgftEiC5zxYDvZQgkDY64WyQXdywjr6NKPO
	FyL5vf21y2W5OyQK5Z7epbe69N7EMGdgjwl1mSJAfp7qEW9e9+fSJLqBGy0sq17fRl/mAb
	nT3E1Elr4wJr27HGCRgEQHr6Bd2+mC8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T0FltFFV;
	spf=pass (imf07.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=yury.norov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b4cf40cd0d1so258675a12.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 14:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756935732; x=1757540532; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=913G5mrad7tqw4Q34JzVSSV+9stS80/tzD0diJIXDJg=;
        b=T0FltFFVI/nC/LttVeYK44yn1CNhFGZPyl7AqrzPlY54yg39oQkyxqPFN1noYH9S6s
         iG5cS1vhCAOoEFdk4vrvdovXCL/nuLf7vu+Qha2+3Vj62/mdzCuB30QRpIkLdhGv3d9v
         7NdVSzlsKuT/keRuoi65UxI+6om0EtF/yLBF6jvd5B5nJXJSSBKMCDZc2NEYoY/VYNJQ
         0UpF6IRHCsAFiQhIIS3NKQKNXiFf0cQmD84LL7dPIKQshe5RL6Kj5DtSe0ieE3GQHZTp
         FdEx+6ompB1ZUtb8+Wubx6xlJqH/KL8j/Xr/0uuroElQAiN6uvVPGuLrliHfmF48XItA
         sXsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756935732; x=1757540532;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=913G5mrad7tqw4Q34JzVSSV+9stS80/tzD0diJIXDJg=;
        b=q5cmJWuqpP1vkVSD69E+6VurjpXetG6VNxcXOcc4oKNCNCABefmJBLuUnTew+TUf2E
         lO4voRzkvBGiIXR/jsri4AVbIvoOMvYF+HRCD5Sz9L/jZfR+YzJXb/1wnNefOmp4gTXf
         XJqoVMPHPzgBktYStYZsjO8IBpc20ZR49hyY8YO5PUEamtpuyzhqku8HvDykaWPrNoHN
         x2dokjN490rnlL2ZKMXeB2PCv6PWLa18vYDZrCpNiG5RgX5A9SLqpX4FGU4aemI8sQWG
         5T9CGZ8h1ynqNhp08k+M9O4WSOarkqg0/9g7N5ianEuzSV9xQQgUkBWYZc8vVpPKQk7b
         OrdQ==
X-Forwarded-Encrypted: i=1; AJvYcCWeLp1w8DS9pJLoY4Ii0qQpDFbtClWinKlTp7GK0mPrKzVjn8ZaldmzsxoNngypTBIXKVjvcVnFew==@kvack.org
X-Gm-Message-State: AOJu0Yx5gJrn/MlAxQUPPXPyA7FC5LPFtlr6oh21K2FNm5Qto9rGLUt0
	OnkBD7IZLXelZa0vmC3QXlw5sIUB3oyu63upFIUOOrFWGnrE+3wfTKXS
X-Gm-Gg: ASbGnctupeouGudHoGlMdInFCpMVNoZBPrEWOCbryRevAQTLBtK6dVMDCPMIGQFTlWc
	GXOyCEPhgCkHj48/TAD/FEN/FvYrR07kJXT4fNZ2rGX7i1XjAIWb8E2EkIjNoaJqSDAOGuBaTWC
	vvJzk+0fpkX3+zu5DGyHozUnMGvPTYyqsh197rPsq/CiGSrxwZwuzP3ZfAaM1nnvjguPry2zKO6
	DcVvXkjOxweiwfPS0Cwyg8FTWsVzkMs+3tr3zdcAa+Iy9iSgmeVzYZi0AA74Z6yynZeZ6k4xphk
	g28eoOkoiOvUWMAqcqUfH7lnMqn/5nCldJbKMMRZh1JYy974OPH8p6MsGeEpFWQKHfMX0IcC+Zi
	qtNK0CdCPn1DTL0kgK2tA11Em8A3qKbfdYS6cImKTEWA=
X-Google-Smtp-Source: AGHT+IGEYHhpxlwqty29iAepYIz+AXBP+Q3J6jABrmveCaY2FnQU2gGFW3oELEV3nWCQvKX8RF2QGw==
X-Received: by 2002:a17:902:da84:b0:24a:ad8a:81f0 with SMTP id d9443c01a7336-24aad8a8560mr158617335ad.51.1756935731425;
        Wed, 03 Sep 2025 14:42:11 -0700 (PDT)
Received: from localhost ([216.228.127.131])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24b15780a11sm57490635ad.93.2025.09.03.14.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 14:42:10 -0700 (PDT)
Date: Wed, 3 Sep 2025 17:42:08 -0400
From: Yury Norov <yury.norov@gmail.com>
To: Mitchell Levy <levymitchell0@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Benno Lossin <lossin@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Tyler Hicks <code@tyhicks.com>, linux-kernel@vger.kernel.org,
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 1/7] rust: percpu: introduce a rust API for per-CPU
 variables
Message-ID: <aLi2MBAwoD65tokv@yury>
References: <20250828-rust-percpu-v3-0-4dd92e1e7904@gmail.com>
 <20250828-rust-percpu-v3-1-4dd92e1e7904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828-rust-percpu-v3-1-4dd92e1e7904@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2256B40005
X-Stat-Signature: zc4xq1uj9n6w9ixgk3g655d9wtgrdbja
X-Rspam-User: 
X-HE-Tag: 1756935732-630027
X-HE-Meta: U2FsdGVkX19N+6GUEFjjO3WRUXvfPljChMTB11AlIyCt9HaRZ9kuUN24m7gWK7gTuHiG+o083pRc6Nrn8YTmojsgSFovAhuRCao1egYLOv80zZ9m72FrtZvnDLDgblUF2JmVtKbYNAntUnJ7rJ0Y2SlRM5Xwc4UC6Zjj6bh1BxUpsqPtfNxAXvQNpuqcL8x6gxI5sRo4kn/m/AtLfxT9Y9SNqplBuG0z9aMCqmBT/TAtnjXjtOJSElB/5A+rogkS+VDlWcL2gKxVcVbHe/L284CK0oq7gX+6IHWMA2p4gwrM7pVKx+Po2HTWNHyLfDYZaqYwf7abW64cjaXdeeyIWFUxD6h0iiOH0gQaF16zLLUi7Vzen4/9ctGJO6zcv8+OPGqR8c518O7OCdjT8yaaZri9Rkhma831RPNcsCSGnOGxwJKZIbdd3SE5zEP3VDWD7X4nZQw8mcCAWnsT0CP1rUQp7pTKOzHYBWmuYRnrHUYqPJsb5LBbvL2gDoDrJcuThrEkHhcsmpqqAhX/25cPKvUO1bE4pGmUHnt+OGoBPzFMKTdORaGXmWyCh6ZWvMeHTgT/6FH8qnkViHt9Ks1bQkb1B/+flS+pC6mUttTeIP0Bk2xUQxAjVntwtNU99K03zNY5kfNKWi1b9cp+9tIq1h+3+LtxJznpbFi4KW0YIJ4f6ThDfluqp7UhL+oyuHlvB9WSoK2Hr3iyy/AcBzVmOAM9XR48jEdCJDDDxy8/b3gEA4m4yFnznHonbKLLU+16iob+eQJgnlywVvUalZp0T0Vi2LYtVHSNCzJlIXrPZ+ZBp+MyniT0NQYucgwKdSWtxHar4pfrrrPUdH5ZD0cFqInVc5aEmpjWRpo93bob5vYoDZOsT6XB11d2jQGiWhwGXCz/7HExbF2ATpxzKDUSKvkYXSZO3rDOsNA0870ZSajYJeSKIfMD+wrdcRSRUCWHXKxMw0M2JpZpAHqVxEl
 7gfuobdq
 v3NbFbuuqxJ7l0z+8vx8ElO7GYaJteLPBhndsUr/vDQRJB728SVBwD74u+uHB0ueO5E6DvCBOGObFdq0t6nvG42ZtryF/9MrflOmGxhQu7bhuT0LmMr82flde9Ale42uiCol0x5QDTMWKUmMqTXagYDG22JuZwppqn7FwZ47JCN21Pumb8dn+aFbgooIZioBsBzuTc8Q3U3Ow3qoZGJ2CpCrt2GJigxOkaRuvNKuFirabbswxyr6Qddny534UDzL24tDhIvSxWVIFfphLaK+bhXBXiMcTUMLs7bNffVYWHcGUsBGLBNlZ7sTjQWvZc7azAf2lYGnmrl6k6UfRJRqWHLIqUCqCIofJb3xt+CSo+8Rg5nmRhb55ezxMa7KzA8rITy6PY/QmvSRIAMNzRwQ9ByABn+HeRQrbKmXNKUbjGloHzDlm9p+qqs3E2+8ITmhIxFxN01xE5ZQCYUZT7aEtS2120dHzqVz/5VKePb5yZflnS05575hioWT5pKcmHSAJFGuHQ+BlVo6m44gwpLbBviggP8cy5wf0b/FWgzdpr0e0FH1yu8PJ6AAvO1HZK/16RsQny+zjskeZI3nELkFtUMXe9B+y6NopPeHA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 12:00:08PM -0700, Mitchell Levy wrote:
> Per-CPU variables are an important tool for reducing lock contention,
> especially in systems with many processors. They also provide a
> convenient way to handle data that are logically associated with a
> particular CPU (e.g., the currently running task). Therefore, add a Rust
> API to make use of per-CPU variables.
> 
> Add a `CpuGuard` type that disables preemption for its lifetime. Add a
> `PerCpuAllocation` type used to track dynamic allocations. Add a
> `define_per_cpu!` macro to create static per-CPU allocations. Add
> `DynamicPerCpu` and `StaticPerCpu` to provide a high-level API. Add a
> `PerCpu` trait to unify the dynamic and static cases.
> 
> Co-developed-by: Boqun Feng <boqun.feng@gmail.com>
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
> ---
>  rust/helpers/helpers.c          |   2 +
>  rust/helpers/percpu.c           |   9 ++
>  rust/helpers/preempt.c          |  14 +++
>  rust/kernel/lib.rs              |   3 +
>  rust/kernel/percpu.rs           | 223 ++++++++++++++++++++++++++++++++++++++++
>  rust/kernel/percpu/cpu_guard.rs |  35 +++++++
>  rust/kernel/percpu/dynamic.rs   |  83 +++++++++++++++
>  rust/kernel/percpu/static_.rs   | 132 ++++++++++++++++++++++++
>  8 files changed, 501 insertions(+)

That's quite a massive patch. Can you please split-out C-binders, and
maybe make separate patches for each .rs component?

> diff --git a/rust/helpers/helpers.c b/rust/helpers/helpers.c
> index 7cf7fe95e41d..2fc8d26cfe66 100644
> --- a/rust/helpers/helpers.c
> +++ b/rust/helpers/helpers.c
> @@ -31,9 +31,11 @@
>  #include "of.c"
>  #include "page.c"
>  #include "pci.c"
> +#include "percpu.c"
>  #include "pid_namespace.c"
>  #include "platform.c"
>  #include "poll.c"
> +#include "preempt.c"
>  #include "property.c"
>  #include "rbtree.c"
>  #include "rcu.c"
> diff --git a/rust/helpers/percpu.c b/rust/helpers/percpu.c
> new file mode 100644
> index 000000000000..a091389f730f
> --- /dev/null
> +++ b/rust/helpers/percpu.c
> @@ -0,0 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/percpu.h>
> +
> +void __percpu *rust_helper_alloc_percpu(size_t sz, size_t align)
> +{
> +	return __alloc_percpu(sz, align);
> +}
> +
> diff --git a/rust/helpers/preempt.c b/rust/helpers/preempt.c
> new file mode 100644
> index 000000000000..2c7529528ddd
> --- /dev/null
> +++ b/rust/helpers/preempt.c
> @@ -0,0 +1,14 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/preempt.h>
> +
> +void rust_helper_preempt_disable(void)
> +{
> +	preempt_disable();
> +}
> +
> +void rust_helper_preempt_enable(void)
> +{
> +	preempt_enable();
> +}
> +
> diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
> index ed53169e795c..ed0d5756dc55 100644
> --- a/rust/kernel/lib.rs
> +++ b/rust/kernel/lib.rs
> @@ -106,6 +106,9 @@
>  pub mod page;
>  #[cfg(CONFIG_PCI)]
>  pub mod pci;
> +// Only x86_64 is supported by percpu for now
> +#[cfg(CONFIG_X86_64)]
> +pub mod percpu;
>  pub mod pid_namespace;
>  pub mod platform;
>  pub mod prelude;
> diff --git a/rust/kernel/percpu.rs b/rust/kernel/percpu.rs
> new file mode 100644
> index 000000000000..35afcdba3ccd
> --- /dev/null
> +++ b/rust/kernel/percpu.rs
> @@ -0,0 +1,223 @@
> +// SPDX-License-Identifier: GPL-2.0
> +//! This module contains abstractions for creating and using per-CPU variables from Rust.
> +//! See the define_per_cpu! macro and the DynamicPerCpu<T> type, as well as the PerCpu<T> trait.
> +
> +pub mod cpu_guard;
> +mod dynamic;
> +mod static_;
> +
> +#[doc(inline)]
> +pub use dynamic::*;
> +#[doc(inline)]
> +pub use static_::*;
> +
> +use bindings::{alloc_percpu, free_percpu};
> +
> +use crate::alloc::Flags;
> +use crate::percpu::cpu_guard::CpuGuard;
> +use crate::prelude::*;
> +use crate::sync::Arc;
> +use crate::types::Opaque;
> +use crate::{declare_extern_per_cpu, get_static_per_cpu};
> +
> +use core::arch::asm;
> +use core::cell::{Cell, RefCell, UnsafeCell};
> +use core::mem::{align_of, size_of, MaybeUninit};
> +
> +use ffi::c_void;
> +
> +/// A per-CPU pointer; that is, an offset into the per-CPU area. Note that this type is NOT a smart
> +/// pointer, it does not manage the allocation.
> +pub struct PerCpuPtr<T>(*mut MaybeUninit<T>);
> +
> +/// Represents exclusive access to the memory location pointed at by a particular PerCpu<T>.
> +pub struct PerCpuToken<'a, T> {
> +    // INVARIANT: the current CPU's memory location associated with the per-CPU variable pointed at
> +    // by `ptr` (i.e., the entry in the per-CPU area on the current CPU) has been initialized.
> +    _guard: CpuGuard,
> +    ptr: &'a PerCpuPtr<T>,
> +}
> +
> +/// Represents access to the memory location pointed at by a particular PerCpu<T> where the type
> +/// `T` manages access to the underlying memory to avoid aliaising troubles. (For example, `T`
> +/// might be a `Cell` or `RefCell`.)
> +pub struct CheckedPerCpuToken<'a, T> {
> +    // INVARIANT: the current CPU's memory location associated with the per-CPU variable pointed at
> +    // by `ptr` (i.e., the entry in the per-CPU area on the current CPU) has been initialized.
> +    _guard: CpuGuard,
> +    ptr: &'a PerCpuPtr<T>,
> +}
> +
> +impl<T> PerCpuPtr<T> {
> +    /// Makes a new PerCpuPtr from a raw per-CPU pointer.
> +    ///
> +    /// # Safety
> +    /// `ptr` must be a valid per-CPU pointer.
> +    pub unsafe fn new(ptr: *mut MaybeUninit<T>) -> Self {
> +        Self(ptr)
> +    }
> +
> +    /// Get a `&mut MaybeUninit<T>` to the per-CPU variable on the current CPU represented by `&self`
> +    ///
> +    /// # Safety
> +    /// The returned `&mut T` must follow Rust's aliasing rules. That is, no other `&(mut) T` may
> +    /// exist that points to the same location in memory. In practice, this means that `get_(mut_)ref`

How long is this line?

> +    /// must not be called on another `PerCpuPtr<T>` that is a copy/clone of `&self` for as long as
> +    /// the returned reference lives.
> +    ///
> +    /// CPU preemption must be disabled before calling this function and for the lifetime of the
> +    /// returned reference. Otherwise, the returned reference might end up being a reference to a
> +    /// different CPU's per-CPU area, causing the potential for a data race.
> +    #[allow(clippy::mut_from_ref)] // Safety requirements prevent aliasing issues
> +    pub unsafe fn get_mut_ref(&self) -> &mut MaybeUninit<T> {
> +        // SAFETY: `self.get_ptr()` returns a valid pointer to a `MaybeUninit<T>` by its contract,
> +        // and the safety requirements of this function ensure that the returned reference is
> +        // exclusive.
> +        unsafe { &mut *(self.get_ptr()) }
> +    }

Here and everywhere: would it make sense to enforce it by testing
the CPU with preemptible() before returning a reference? 

Thanks,
Yury

> +
> +    /// Get a `&MaybeUninit<T>` to the per-CPU variable on the current CPU represented by `&self`
> +    ///
> +    /// # Safety
> +    /// The returned `&T` must follow Rust's aliasing rules. That is, no `&mut T` may exist that
> +    /// points to the same location in memory. In practice, this means that `get_mut_ref` must not
> +    /// be called on another `PerCpuPtr<T>` that is a copy/clone of `&self` for as long as the
> +    /// returned reference lives.
> +    ///
> +    /// CPU preemption must be disabled before calling this function and for the lifetime of the
> +    /// returned reference. Otherwise, the returned reference might end up being a reference to a
> +    /// different CPU's per-CPU area, causing the potential for a data race.
> +    pub unsafe fn get_ref(&self) -> &MaybeUninit<T> {
> +        // SAFETY: `self.get_ptr()` returns a valid pointer to a `MaybeUninit<T>` by its contract.
> +        // The safety requirements of this function ensure that the returned reference isn't
> +        // aliased by a `&mut MaybeUninit<T>`.
> +        unsafe { &*self.get_ptr() }
> +    }
> +
> +    /// Get a `*mut MaybeUninit<T>` to the per-CPU variable on the current CPU represented by
> +    /// `&self`. Note that if CPU preemption is not disabled before calling this function, use of
> +    /// the returned pointer may cause a data race without some other synchronization mechanism.
> +    /// Buyer beware!
> +    pub fn get_ptr(&self) -> *mut MaybeUninit<T> {
> +        let this_cpu_off_pcpu: PerCpuPtr<*mut c_void> = get_static_per_cpu!(this_cpu_off).0;
> +        let mut this_cpu_area: *mut c_void;
> +        // SAFETY: gs + this_cpu_off_pcpu is guaranteed to be a valid pointer because `gs` points
> +        // to the per-CPU area and this_cpu_off_pcpu is a valid per-CPU allocation.
> +        unsafe {
> +            asm!(
> +                "mov {out}, gs:[{off_val}]",
> +                off_val = in(reg) this_cpu_off_pcpu.0,
> +                out = out(reg) this_cpu_area,
> +            )
> +        };
> +
> +        // This_cpu_area + self.0 is guaranteed to be a valid pointer by the per-CPU subsystem and
> +        // the invariant that self.0 is a valid offset into the per-CPU area.
> +        (this_cpu_area).wrapping_add(self.0 as usize).cast()
> +    }
> +}
> +
> +// SAFETY: Sending a `PerCpuPtr<T>` to another thread is safe because as soon as it's sent, the
> +// pointer is logically referring to a different place in memory in the other CPU's per-CPU area.
> +// In particular, this means that there are no restrictions on the type `T`.
> +unsafe impl<T> Send for PerCpuPtr<T> {}
> +
> +// SAFETY: Two threads concurrently making use of a `PerCpuPtr<T>` will each see the `T` in their
> +// own per-CPU area, so there's no potential for a data race (regardless of whether `T` is itself
> +// `Sync`).
> +unsafe impl<T> Sync for PerCpuPtr<T> {}
> +
> +impl<T> Clone for PerCpuPtr<T> {
> +    fn clone(&self) -> Self {
> +        *self
> +    }
> +}
> +
> +/// `PerCpuPtr` is just a wrapper around a pointer.
> +impl<T> Copy for PerCpuPtr<T> {}
> +
> +/// A trait representing a per-CPU variable. This is implemented for both `StaticPerCpu<T>` and
> +/// `DynamicPerCpu<T>`. The main usage of this trait is to call `get_mut` to get a `PerCpuToken`
> +/// that can be used to access the underlying per-CPU variable. See `PerCpuToken::with`.
> +pub trait PerCpu<T> {
> +    /// Produces a token, asserting that the holder has exclusive access to the underlying memory
> +    /// pointed to by `self`
> +    ///
> +    /// # Safety
> +    /// No other `PerCpuToken` or `CheckedPerCpuToken` may exist on the current CPU (which is a
> +    /// sensible notion, since we keep a `CpuGuard` around) that is derived from the same
> +    /// `PerCpu<T>` or a clone thereof.
> +    unsafe fn get_mut(&mut self, guard: CpuGuard) -> PerCpuToken<'_, T>;
> +}
> +
> +/// A marker trait for types that are interior mutable. Types that implement this trait can be used
> +/// to create "checked" per-CPU variables. See `CheckedPerCpu<T>`.
> +pub trait InteriorMutable {}
> +
> +impl<T> InteriorMutable for Cell<T> {}
> +impl<T> InteriorMutable for RefCell<T> {}
> +impl<T> InteriorMutable for UnsafeCell<T> {}
> +impl<T> InteriorMutable for Opaque<T> {}
> +
> +/// A trait representing a per-CPU variable that is usable via a `&T`. The unsafety of `PerCpu<T>`
> +/// stems from the fact that the holder of a `PerCpuToken` can use it to get a `&mut T` to the
> +/// underlying per-CPU variable. This is problematic because the existence of aliaising `&mut T` is
> +/// undefined behavior in Rust. This type avoids that issue by only allowing access via a `&T`,
> +/// with the tradeoff that then `T` must be interior mutable or the underlying per-CPU variable
> +/// must be a constant for the lifetime of the corresponding `CheckedPerCpu<T>`.
> +///
> +/// Currently, only the case where `T` is interior mutable has first-class support, though a custom
> +/// implementation of `PerCpu<T>`/`CheckedPerCpu<T>` could be created for the const case.
> +pub trait CheckedPerCpu<T>: PerCpu<T> {
> +    /// Produces a token via which the holder can access the underlying per-CPU variable.
> +    fn get(&mut self, guard: CpuGuard) -> CheckedPerCpuToken<'_, T>;
> +}
> +
> +impl<'a, T> PerCpuToken<'a, T> {
> +    /// # Safety
> +    /// No other `PerCpuToken` or `CheckedPerCpuToken` may exist on the current CPU (which is a
> +    /// sensible notion, since we keep a `CpuGuard` around) that uses the same `PerCpuPtr<T>`.
> +    ///
> +    /// The current CPU's memory location associated with the per-CPU variable pointed at by `ptr`
> +    /// (i.e., the entry in the per-CPU area on this CPU) must be initialized.
> +    pub unsafe fn new(guard: CpuGuard, ptr: &'a PerCpuPtr<T>) -> PerCpuToken<'a, T> {
> +        Self { _guard: guard, ptr }
> +    }
> +
> +    /// Immediately invokes `func` with a `&mut T` that points at the underlying per-CPU variable
> +    /// that `&mut self` represents.
> +    pub fn with<U>(&mut self, func: U)
> +    where
> +        U: FnOnce(&mut T),
> +    {
> +        // SAFETY: The existence of a PerCpuToken means that the requirements for get_mut_ref are
> +        // satisfied. Likewise, the requirements for assume_init_mut are satisfied because the
> +        // invariants of this type ensure that on the current CPU (which is a sensible notion
> +        // because we have a CpuGuard), the memory location pointed to by `ptr` is initialized.
> +        func(unsafe { self.ptr.get_mut_ref().assume_init_mut() });
> +    }
> +}
> +
> +impl<'a, T> CheckedPerCpuToken<'a, T> {
> +    /// # Safety
> +    /// The current CPU's memory location associated with the per-CPU variable pointed at by `ptr`
> +    /// (i.e., the entry in the per-CPU area on this CPU) must be initialized.
> +    pub unsafe fn new(guard: CpuGuard, ptr: &'a PerCpuPtr<T>) -> CheckedPerCpuToken<'a, T> {
> +        Self { _guard: guard, ptr }
> +    }
> +
> +    /// Immediately invokes `func` with a `&T` that points at the underlying per-CPU variable that
> +    /// `&mut self` represents.
> +    pub fn with<U>(&mut self, func: U)
> +    where
> +        U: FnOnce(&T),
> +    {
> +        // SAFETY: The existence of a CheckedPerCpuToken means that the requirements for get_ref
> +        // are satisfied. Likewise, the requirements for assume_init_ref are satisfied because the
> +        // invariants of this type ensure that on the current CPU (which is a sensible notion
> +        // because we have a CpuGuard), the memory location pointed to by `ptr` is initialized.
> +        func(unsafe { self.ptr.get_ref().assume_init_ref() });
> +    }
> +}
> +
> +declare_extern_per_cpu!(this_cpu_off: *mut c_void);
> diff --git a/rust/kernel/percpu/cpu_guard.rs b/rust/kernel/percpu/cpu_guard.rs
> new file mode 100644
> index 000000000000..14c04b12e7f0
> --- /dev/null
> +++ b/rust/kernel/percpu/cpu_guard.rs
> @@ -0,0 +1,35 @@
> +// SPDX-License-Identifier: GPL-2.0
> +//! Contains abstractions for disabling CPU preemption. See `CpuGuard`.
> +
> +/// A RAII guard for bindings::preempt_disable and bindings::preempt_enable. Guarantees preemption
> +/// is disabled for as long as this object exists.
> +pub struct CpuGuard {
> +    // Don't make one without using new()
> +    _phantom: (),
> +}
> +
> +impl CpuGuard {
> +    /// Create a new CpuGuard. Disables preemption for its lifetime.
> +    pub fn new() -> Self {
> +        // SAFETY: There are no preconditions required to call preempt_disable
> +        unsafe {
> +            bindings::preempt_disable();
> +        }
> +        CpuGuard { _phantom: () }
> +    }
> +}
> +
> +impl Default for CpuGuard {
> +    fn default() -> Self {
> +        Self::new()
> +    }
> +}
> +
> +impl Drop for CpuGuard {
> +    fn drop(&mut self) {
> +        // SAFETY: There are no preconditions required to call preempt_enable
> +        unsafe {
> +            bindings::preempt_enable();
> +        }
> +    }
> +}
> diff --git a/rust/kernel/percpu/dynamic.rs b/rust/kernel/percpu/dynamic.rs
> new file mode 100644
> index 000000000000..ce95e420f943
> --- /dev/null
> +++ b/rust/kernel/percpu/dynamic.rs
> @@ -0,0 +1,83 @@
> +// SPDX-License-Identifier: GPL-2.0
> +//! Dynamically allocated per-CPU variables.
> +
> +use super::*;
> +
> +/// Represents a dynamic allocation of a per-CPU variable via alloc_percpu. Calls free_percpu when
> +/// dropped.
> +pub struct PerCpuAllocation<T>(PerCpuPtr<T>);
> +
> +impl<T: Zeroable> PerCpuAllocation<T> {
> +    /// Dynamically allocates a space in the per-CPU area suitably sized and aligned to hold a `T`,
> +    /// initially filled with the zero value for `T`.
> +    ///
> +    /// Returns `None` under the same circumstances the C function `alloc_percpu` returns `NULL`.
> +    pub fn new_zero() -> Option<PerCpuAllocation<T>> {
> +        let ptr: *mut MaybeUninit<T> =
> +            // SAFETY: No preconditions to call alloc_percpu; MaybeUninit<T> is
> +            // `#[repr(transparent)]`, so we can cast a `*mut T` to it.
> +            unsafe { alloc_percpu(size_of::<T>(), align_of::<T>()) }.cast();
> +        if ptr.is_null() {
> +            return None;
> +        }
> +
> +        // alloc_percpu returns zero'ed memory
> +        Some(Self(PerCpuPtr(ptr)))
> +    }
> +}
> +
> +impl<T> PerCpuAllocation<T> {
> +    /// Makes a per-CPU allocation sized and aligned to hold a `T`.
> +    ///
> +    /// Returns `None` under the same circumstances the C function `alloc_percpu` returns `NULL`.
> +    pub fn new_uninit() -> Option<PerCpuAllocation<T>> {
> +        let ptr: *mut MaybeUninit<T> =
> +            // SAFETY: No preconditions to call alloc_percpu; MaybeUninit<T> is
> +            // `#[repr(transparent)]`, so we can cast a `*mut T` to it.
> +            unsafe { alloc_percpu(size_of::<T>(), align_of::<T>()) }.cast();
> +        if ptr.is_null() {
> +            return None;
> +        }
> +
> +        Some(Self(PerCpuPtr(ptr)))
> +    }
> +}
> +
> +impl<T> Drop for PerCpuAllocation<T> {
> +    fn drop(&mut self) {
> +        // SAFETY: self.0.0 was returned by alloc_percpu, and so was a valid pointer into
> +        // the percpu area, and has remained valid by the invariants of PerCpuAllocation<T>.
> +        unsafe { free_percpu(self.0 .0.cast()) }
> +    }
> +}
> +
> +/// Holds a dynamically-allocated per-CPU variable.
> +#[derive(Clone)]
> +pub struct DynamicPerCpu<T> {
> +    // INVARIANT: The memory location in each CPU's per-CPU area pointed at by `alloc.0` has been
> +    // initialized.
> +    pub(super) alloc: Arc<PerCpuAllocation<T>>,
> +}
> +
> +impl<T: Zeroable> DynamicPerCpu<T> {
> +    /// Allocates a new per-CPU variable
> +    ///
> +    /// # Arguments
> +    /// * `flags` - Flags used to allocate an `Arc` that keeps track of the underlying
> +    ///   `PerCpuAllocation`.
> +    pub fn new_zero(flags: Flags) -> Option<Self> {
> +        let alloc: PerCpuAllocation<T> = PerCpuAllocation::new_zero()?;
> +
> +        let arc = Arc::new(alloc, flags).ok()?;
> +
> +        Some(Self { alloc: arc })
> +    }
> +}
> +
> +impl<T> PerCpu<T> for DynamicPerCpu<T> {
> +    unsafe fn get_mut(&mut self, guard: CpuGuard) -> PerCpuToken<'_, T> {
> +        // SAFETY: The requirements of `PerCpu::get_mut` and this type's invariant ensure that the
> +        // requirements of `PerCpuToken::new` are met.
> +        unsafe { PerCpuToken::new(guard, &self.alloc.0) }
> +    }
> +}
> diff --git a/rust/kernel/percpu/static_.rs b/rust/kernel/percpu/static_.rs
> new file mode 100644
> index 000000000000..be226dd2c3aa
> --- /dev/null
> +++ b/rust/kernel/percpu/static_.rs
> @@ -0,0 +1,132 @@
> +// SPDX-License-Identifier: GPL-2.0
> +//! Statically allocated per-CPU variables.
> +
> +use super::*;
> +
> +/// A wrapper used for declaring static per-CPU variables. These symbols are "virtual" in that the
> +/// linker uses them to generate offsets into each CPU's per-CPU area, but shouldn't be read
> +/// from/written to directly. The fact that the statics are immutable prevents them being written
> +/// to (generally), this struct having _val be non-public prevents reading from them.
> +///
> +/// The end-user of the per-CPU API should make use of the define_per_cpu! macro instead of
> +/// declaring variables of this type directly. All instances of this type must be `static` and
> +/// `#[link_section = ".data..percpu"]` (which the macro handles).
> +#[repr(transparent)]
> +pub struct StaticPerCpuSymbol<T> {
> +    _val: T, // generate a correctly sized type
> +}
> +
> +/// Holds a statically-allocated per-CPU variable.
> +#[derive(Clone)]
> +pub struct StaticPerCpu<T>(pub(super) PerCpuPtr<T>);
> +
> +impl<T> StaticPerCpu<T> {
> +    /// Creates a `StaticPerCpu<T>` from a `StaticPerCpuSymbol<T>`. You should probably be using
> +    /// `get_static_per_cpu!` instead.
> +    pub fn new(ptr: *const StaticPerCpuSymbol<T>) -> StaticPerCpu<T> {
> +        // SAFETY: `StaticPerCpuSymbol<T>` is `#[repr(transparent)]`, so we can safely cast a
> +        // pointer to it into a pointer to `MaybeUninit<T>`. The validity of it as a per-CPU
> +        // pointer is guaranteed by the per-CPU subsystem and invariants of the StaticPerCpuSymbol
> +        // type.
> +        let pcpu_ptr = unsafe { PerCpuPtr::new(ptr.cast_mut().cast()) };
> +        Self(pcpu_ptr)
> +    }
> +}
> +
> +impl<T> PerCpu<T> for StaticPerCpu<T> {
> +    unsafe fn get_mut(&mut self, guard: CpuGuard) -> PerCpuToken<'_, T> {
> +        // SAFETY: The requirements of `PerCpu::get_mut` and the fact that statically-allocated
> +        // per-CPU variables are initialized by the per-CPU subsystem ensure that the requirements
> +        // of `PerCpuToken::new` are met.
> +        unsafe { PerCpuToken::new(guard, &self.0) }
> +    }
> +}
> +
> +impl<T: InteriorMutable> CheckedPerCpu<T> for StaticPerCpu<T> {
> +    fn get(&mut self, guard: CpuGuard) -> CheckedPerCpuToken<'_, T> {
> +        // SAFETY: The per-CPU subsystem guarantees that each CPU's instance of a
> +        // statically allocated variable begins with a copy of the contents of the
> +        // corresponding symbol in `.data..percpu`. Thus, the requirements of
> +        // `CheckedPerCpuToken::new` are met.
> +        unsafe { CheckedPerCpuToken::new(guard, &self.0) }
> +    }
> +}
> +
> +/// Gets a `StaticPerCpu<T>` from a symbol declared with `define_per_cpu!` or
> +/// `declare_extern_per_cpu!`.
> +///
> +/// # Arguments
> +/// * `ident` - The identifier declared
> +#[macro_export]
> +macro_rules! get_static_per_cpu {
> +    ($id:ident) => {
> +        $crate::percpu::StaticPerCpu::new((&raw const $id).cast())
> +    };
> +}
> +
> +/// Declares a StaticPerCpuSymbol corresponding to a per-CPU variable defined in C. Be sure to read
> +/// the safety requirements of `PerCpu::get`.
> +#[macro_export]
> +macro_rules! declare_extern_per_cpu {
> +    ($id:ident: $ty:ty) => {
> +        extern "C" {
> +            static $id: StaticPerCpuSymbol<$ty>;
> +        }
> +    };
> +}
> +
> +/// define_per_cpu! is analogous to the C DEFINE_PER_CPU macro in that it lets you create a
> +/// statically allocated per-CPU variable.
> +///
> +/// # Example
> +/// ```
> +/// use kernel::define_per_cpu;
> +/// use kernel::percpu::StaticPerCpuSymbol;
> +///
> +/// define_per_cpu!(pub MY_PERCPU: u64 = 0);
> +/// ```
> +#[macro_export]
> +macro_rules! define_per_cpu {
> +    ($vis:vis $id:ident: $ty:ty = $expr:expr) => {
> +        $crate::macros::paste! {
> +            // We might want to have a per-CPU variable that doesn't implement `Sync` (not paying
> +            // sync overhead costs is part of the point), but Rust won't let us declare a static of
> +            // a `!Sync` type. Of course, we don't actually have any synchronization issues, since
> +            // each CPU will see its own copy of the variable, so we cheat a little bit and tell
> +            // Rust it's fine.
> +            #[doc(hidden)]
> +            #[allow(non_camel_case_types)]
> +            #[repr(transparent)] // It needs to be the same size as $ty
> +            struct [<__PRIVATE_TYPE_ $id>]($ty);
> +
> +            impl [<__PRIVATE_TYPE_ $id>] {
> +                #[doc(hidden)]
> +                const fn new(val: $ty) -> Self {
> +                    Self(val)
> +                }
> +            }
> +
> +            // Expand $expr outside of the unsafe block to avoid silently allowing unsafe code to be
> +            // used without a user-facing unsafe block
> +            #[doc(hidden)]
> +            static [<__INIT_ $id>]: [<__PRIVATE_TYPE_ $id>] = [<__PRIVATE_TYPE_ $id>]::new($expr);
> +
> +            // SAFETY: This type will ONLY ever be used to declare a `StaticPerCpuSymbol`
> +            // (which we then only ever use as input to `&raw`). Reading from the symbol is
> +            // already UB, so we won't ever actually have any variables of this type where
> +            // synchronization is a concern.
> +            #[doc(hidden)]
> +            unsafe impl Sync for [<__PRIVATE_TYPE_ $id>] {}
> +
> +            // SAFETY: StaticPerCpuSymbol<T> is #[repr(transparent)], so we can freely convert from
> +            // [<__PRIVATE_TYPE_ $id>], which is also `#[repr(transparent)]` (i.e., everything is
> +            // just a `$ty` from a memory layout perspective).
> +            #[link_section = ".data..percpu"]
> +            $vis static $id: StaticPerCpuSymbol<[<__PRIVATE_TYPE_ $id>]> = unsafe {
> +                core::mem::transmute_copy::<
> +                    [<__PRIVATE_TYPE_ $id>], StaticPerCpuSymbol<[<__PRIVATE_TYPE_ $id>]>
> +                >(&[<__INIT_ $id>])
> +            };
> +        }
> +    };
> +}
> 
> -- 
> 2.34.1

