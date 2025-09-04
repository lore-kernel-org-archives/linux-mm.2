Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40854CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 19:54:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43F998E0003; Thu,  4 Sep 2025 15:54:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EFC66B0010; Thu,  4 Sep 2025 15:54:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DE658E0003; Thu,  4 Sep 2025 15:54:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 180E16B000E
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:54:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A8108B8EBE
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 19:54:05 +0000 (UTC)
X-FDA: 83852618850.06.63EEC20
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf25.hostedemail.com (Postfix) with ESMTP id B9663A0004
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 19:54:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="gv/XS6Ny";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757015643; a=rsa-sha256;
	cv=none;
	b=EwCSK0o3Hjx4dSCGXbWqfZ7bpdwbT24EDAuBSKBAv4bo0oCWXPy+hLCA+/grIHW8So/wpu
	4YXQtjMpwLeMfN9JYM90yRYEWq8dx+Mi9bE7Kr0tDlOHPusA5QnW3ZZEOznBpWNFmOw/Y5
	EDGECoKsbC4XTQAhF8W9RqNcD3AsTlw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="gv/XS6Ny";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757015643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CW6N/04aVXSqAqCWFvMO/Nhy5na9bRfLZIbzmF48rh0=;
	b=llE6kDs4S9ER20jDJu2miKnLryhSTcpuSTdOl20STrR+lVrJpD0xeruBaXN/1pU9zVxU3L
	HzuLfSWZmDl1yxAqcXUrh2lE0l/eMDhoe5foSpL5dl9goHbuAYH9vGRiFfXWRbJAwLqmur
	XmKS1vtCMSg5s2x0vvbTspfiYnNbHLE=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-329e1c8e079so1273766a91.2
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 12:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757015642; x=1757620442; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=CW6N/04aVXSqAqCWFvMO/Nhy5na9bRfLZIbzmF48rh0=;
        b=gv/XS6Nyr44vG3eeDaIlOb5ALNiIFKmi7ud/hPaEct/nP7nvjTzoF/Cd1xMEr+/Fvq
         LHnjEm2UJECTNdgtqupKdLzJ5Pw2cIdLxxOOUNbF6mr6pzIgqhWO4PaZqugmRE4dimAq
         r+fbskQ7PzOVNZFOlhhj6TRnClpcl7lEjafwMGh9gGA14fgWssNplUOr9kne/jtYvFLx
         7wi/IGIIy7w6zkmWH4s71g4fBRAye9VsFd1GniYac07lTia4vtI/hchrm+/46JQU7B10
         jqYmWOLwiBpjFnXkraMEyP+kSe3AMS5GUAR0biyP+d/4A+B8voSpLTfViHuOu+DvvEiB
         8QuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757015642; x=1757620442;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CW6N/04aVXSqAqCWFvMO/Nhy5na9bRfLZIbzmF48rh0=;
        b=ExUhDB4lB5/RUmYIB6Oi7JxEb6iGP6oRiGNEG6SypGhgSBlYEmm91Ua/bs+CvbqI+/
         9fYrn/YDJdEAJCnOGlThVzS0/dpqGoREWVjlrD8WL1IWJnRH94mtuH81XKPRx5NiYXIx
         JdKLji4//KUW4504Nc/xmpwj+/2N++g8CyGtjaLPnwu9xOeFhT7jYIvjYhReFB+G7Hz8
         b6vVYXMjvjcuORdlxdWF5/4wp7QxtTzCBwrP10ItTK6GZy+BVi2CCnl6VAKb74SzjEvr
         wCMakbEGBKVZ3NjDnavtrq1gFqD103B+7hQYgEqaOLLB42hRbSvc/Ucdfxq+k16roB/F
         Hg6g==
X-Forwarded-Encrypted: i=1; AJvYcCVVghXwmhnEJU4ZorfSefAW0XaumtzSkVeOTxEePRN2KtgPBIfToxjLyOW7drLXf6Zi6U5ZoAu2bA==@kvack.org
X-Gm-Message-State: AOJu0YyqFe20doy45Cvu7LZlY5zqH2XnHwPSLitXh9xvpZTO/KczRknY
	W6ckmvu8/ukX6AOQQUClvd5EKrJfXSfHBhiw7WuSXR0stFg7gSfBU/XJ
X-Gm-Gg: ASbGnctvLhGIK3nB1H3QmBlpN6E9aogVimC+lbtFSkquGZ+ARbF1jSrqiiWrbRSIOd5
	NzfIE+7we/7gS1MbzE3DG46zMyOSuxdnO1mHAr1LFt9oGSTq/ZMCedsx69+Z/o41dECN9zXeLAW
	hVNk+bMKH1Q5hE8/BX0H5YcLFnt0KU/cdl5BfjvtN3/2+54qleHYtBJ1uJT57z0UUUs+gKxYjIM
	GO15RS8jzGa3Fcqz82JPjW/zK4ZjoekktCvleQoCg6GmbSJlrflEgFza0fJsFGya02vp9XKQXRf
	lg7yUqDyremtR00QEcDqTTSK5QHT6nwILa5Lkml4vGj5wdGyjXi//RrfT3go98Va4KhAY9/enI3
	nk+dAZUpE86WvcxQw40xYQ0s/Co0PFGnKZy6Hfg==
X-Google-Smtp-Source: AGHT+IG7yjTqmFrmq0f5et6mH4alxx7MGzM2q6Z+jEo61g9eRQwwTVozQdAP4sVYRYxT/Uynbist0w==
X-Received: by 2002:a17:90b:2809:b0:32b:6223:25a with SMTP id 98e67ed59e1d1-32b62230482mr8507388a91.28.1757015642287;
        Thu, 04 Sep 2025 12:54:02 -0700 (PDT)
Received: from Cyndaquil. ([174.127.224.194])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32b90b574cesm1442080a91.0.2025.09.04.12.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 12:54:01 -0700 (PDT)
Message-ID: <68b9ee59.170a0220.a7a31.675c@mx.google.com>
X-Google-Original-Message-ID: <aLnuV7zP28+sbl2t@Cyndaquil.>
Date: Thu, 4 Sep 2025 12:53:59 -0700
From: Mitchell Levy <levymitchell0@gmail.com>
To: Yury Norov <yury.norov@gmail.com>
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
References: <20250828-rust-percpu-v3-0-4dd92e1e7904@gmail.com>
 <20250828-rust-percpu-v3-1-4dd92e1e7904@gmail.com>
 <aLi2MBAwoD65tokv@yury>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLi2MBAwoD65tokv@yury>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: B9663A0004
X-Stat-Signature: bqjt8he53p7ar6759nyri33a9hgc34wi
X-HE-Tag: 1757015643-165866
X-HE-Meta: U2FsdGVkX1+V2eYv1Agqlyx6JLVmDxPtYW75GIscz8AbxmsQ5MzNh7CC9E5sSUGWPETQypj2uZcfiSrwGMUteJoF4h446GgDNY3tFp5h3LH7Y+/Tu+DX29v3lp9yww6u1qUHGmRF9jYEKpn462y3fmYXG2gAdEjESE+GulKA6RGCTSetvM71tFlgg8rHK6k7vGx5GY3dU+FNXdM6h6lG92Wk0ULbY+su93yCM9I/ag1vO1szgYycgrZ6sGyPGHKaWlPdzsYQz//YAp80Bf4A6ksndD8bvviOyRJhuObEcCbvGlRdFL84kNzovzRAKEUm1l4RcJMV1OwoiqJ72zaiBto7mfUGSI/zFZu5l18mNXtcaGJ0J2vOibxHajZRg9ezB/M/j53Q8lqebUFwRuLSdeZrjArFrDOrVhR8qt4fv5pW7DZllBC0CzngBzc/XAjsxeYBzg1KHD6UWhEnhzc+3y3fy7rGVy1WWadOQ1wie6FUUORLv4ktnLXMEH27ocBKS3BEGCqGfSaURsm5MLENC70uVHOiCFBHTy2tZAAqpifzYU0k6M2jHxCBLkMgmfeQkV9KyQVxufNz8izd3bF6Rlu4qaZf83K6GzQCW3d5N7lox/i2OD8cuFPqnunkoOtlmNub0GFtv4FeZ6aVelZMKZR8budl67ns2YY3ELWQu44pldFzW3eaftrLQTyq9YEwSloQlr64gDdGRnewyTiHamk42ZKSpimskub7VH+DH+nSl+6EUYQ1OTRHFrpaXY5LpKEI4h9Vf7volI9GiQn7jQRiRzWzPTgji7aFo0KnmrfqLMFgUTvdF1egUzJghNDbGTq35O7DnpxGyoidHP0ohdiogeb6IemKb37wTGH0P25hKahHs4+++FnJPn1ZVd/h21KdVNdYjOfMGzyFERmbkd6iSr4bqMQqO4rHQQpATk5S15aKXtc7/beiSNRZ2SGggxNe0MlrieUKiK0pKMY
 /sUU01XW
 dV++WLa/WyESJqaGscYCAb5FQ0IKqeK/zJrDI/snourRshtVV8qAsSUdoV7Eare4D8vtFcgXfUoz3VZ3dxCbwB59GLNH5Me7z5VrlHCxDrwd6tsk/BBP5LZrrBjWDNAZQ9gGa0UXtY/2QM2za2ES1V/ujrKbfMV2WuObvBxCHOAp8yLEFlBJS56L0psLrD1zWq5uTKTh7RwI2jmuu4NmD0vXpbBLqD1F2v+xzNGYFmIFz1tyGnURHMG0XZv8pQwHkXDxEBWC1CoWTZTh0+zuYPCOv27TxgpFGbynMA39djIZjtzrVpGbCy+DmwT9Rm+II/OylWcy7kdZluHTW2D9q2STkzQj2kiEFyMtk6qmBiV//Cp+miZRcPQ+NN6joIiopcybLfauOZcv2ULIHHSecDWnMes64XwerNhIKrLuH0B2S76xRrC+hmS5BRdWgIsrPWsVEDCF8s4E3+Imf6iFB7x/lKWuGE5VOegsaDm9AGS2KPvOGspTA5nRxomEiyN7OrxnAS2Etwlxycn4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 05:42:08PM -0400, Yury Norov wrote:
> On Thu, Aug 28, 2025 at 12:00:08PM -0700, Mitchell Levy wrote:
> > Per-CPU variables are an important tool for reducing lock contention,
> > especially in systems with many processors. They also provide a
> > convenient way to handle data that are logically associated with a
> > particular CPU (e.g., the currently running task). Therefore, add a Rust
> > API to make use of per-CPU variables.
> > 
> > Add a `CpuGuard` type that disables preemption for its lifetime. Add a
> > `PerCpuAllocation` type used to track dynamic allocations. Add a
> > `define_per_cpu!` macro to create static per-CPU allocations. Add
> > `DynamicPerCpu` and `StaticPerCpu` to provide a high-level API. Add a
> > `PerCpu` trait to unify the dynamic and static cases.
> > 
> > Co-developed-by: Boqun Feng <boqun.feng@gmail.com>
> > Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> > Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
> > ---
> >  rust/helpers/helpers.c          |   2 +
> >  rust/helpers/percpu.c           |   9 ++
> >  rust/helpers/preempt.c          |  14 +++
> >  rust/kernel/lib.rs              |   3 +
> >  rust/kernel/percpu.rs           | 223 ++++++++++++++++++++++++++++++++++++++++
> >  rust/kernel/percpu/cpu_guard.rs |  35 +++++++
> >  rust/kernel/percpu/dynamic.rs   |  83 +++++++++++++++
> >  rust/kernel/percpu/static_.rs   | 132 ++++++++++++++++++++++++
> >  8 files changed, 501 insertions(+)
> 
> That's quite a massive patch. Can you please split-out C-binders, and
> maybe make separate patches for each .rs component?

Sure, will do so for v4.

> > diff --git a/rust/helpers/helpers.c b/rust/helpers/helpers.c
> > index 7cf7fe95e41d..2fc8d26cfe66 100644

[...]

> > --- /dev/null
> > +++ b/rust/kernel/percpu.rs
> > @@ -0,0 +1,223 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +//! This module contains abstractions for creating and using per-CPU variables from Rust.
> > +//! See the define_per_cpu! macro and the DynamicPerCpu<T> type, as well as the PerCpu<T> trait.
> > +
> > +pub mod cpu_guard;
> > +mod dynamic;
> > +mod static_;
> > +
> > +#[doc(inline)]
> > +pub use dynamic::*;
> > +#[doc(inline)]
> > +pub use static_::*;
> > +
> > +use bindings::{alloc_percpu, free_percpu};
> > +
> > +use crate::alloc::Flags;
> > +use crate::percpu::cpu_guard::CpuGuard;
> > +use crate::prelude::*;
> > +use crate::sync::Arc;
> > +use crate::types::Opaque;
> > +use crate::{declare_extern_per_cpu, get_static_per_cpu};
> > +
> > +use core::arch::asm;
> > +use core::cell::{Cell, RefCell, UnsafeCell};
> > +use core::mem::{align_of, size_of, MaybeUninit};
> > +
> > +use ffi::c_void;
> > +
> > +/// A per-CPU pointer; that is, an offset into the per-CPU area. Note that this type is NOT a smart
> > +/// pointer, it does not manage the allocation.
> > +pub struct PerCpuPtr<T>(*mut MaybeUninit<T>);
> > +
> > +/// Represents exclusive access to the memory location pointed at by a particular PerCpu<T>.
> > +pub struct PerCpuToken<'a, T> {
> > +    // INVARIANT: the current CPU's memory location associated with the per-CPU variable pointed at
> > +    // by `ptr` (i.e., the entry in the per-CPU area on the current CPU) has been initialized.
> > +    _guard: CpuGuard,
> > +    ptr: &'a PerCpuPtr<T>,
> > +}
> > +
> > +/// Represents access to the memory location pointed at by a particular PerCpu<T> where the type
> > +/// `T` manages access to the underlying memory to avoid aliaising troubles. (For example, `T`
> > +/// might be a `Cell` or `RefCell`.)
> > +pub struct CheckedPerCpuToken<'a, T> {
> > +    // INVARIANT: the current CPU's memory location associated with the per-CPU variable pointed at
> > +    // by `ptr` (i.e., the entry in the per-CPU area on the current CPU) has been initialized.
> > +    _guard: CpuGuard,
> > +    ptr: &'a PerCpuPtr<T>,
> > +}
> > +
> > +impl<T> PerCpuPtr<T> {
> > +    /// Makes a new PerCpuPtr from a raw per-CPU pointer.
> > +    ///
> > +    /// # Safety
> > +    /// `ptr` must be a valid per-CPU pointer.
> > +    pub unsafe fn new(ptr: *mut MaybeUninit<T>) -> Self {
> > +        Self(ptr)
> > +    }
> > +
> > +    /// Get a `&mut MaybeUninit<T>` to the per-CPU variable on the current CPU represented by `&self`
> > +    ///
> > +    /// # Safety
> > +    /// The returned `&mut T` must follow Rust's aliasing rules. That is, no other `&(mut) T` may
> > +    /// exist that points to the same location in memory. In practice, this means that `get_(mut_)ref`
> 
> How long is this line?

102 chars, or 103 if you include the newline. `rustfmt` doesn't break
the line, so I left it as-is for this patch. Happy to change it if it
poses a problem, though.

> > +    /// must not be called on another `PerCpuPtr<T>` that is a copy/clone of `&self` for as long as
> > +    /// the returned reference lives.
> > +    ///
> > +    /// CPU preemption must be disabled before calling this function and for the lifetime of the
> > +    /// returned reference. Otherwise, the returned reference might end up being a reference to a
> > +    /// different CPU's per-CPU area, causing the potential for a data race.
> > +    #[allow(clippy::mut_from_ref)] // Safety requirements prevent aliasing issues
> > +    pub unsafe fn get_mut_ref(&self) -> &mut MaybeUninit<T> {
> > +        // SAFETY: `self.get_ptr()` returns a valid pointer to a `MaybeUninit<T>` by its contract,
> > +        // and the safety requirements of this function ensure that the returned reference is
> > +        // exclusive.
> > +        unsafe { &mut *(self.get_ptr()) }
> > +    }
> 
> Here and everywhere: would it make sense to enforce it by testing
> the CPU with preemptible() before returning a reference? 

The only thing we could do would be to panic, which I don't 100% love.
Another alternative would be to take a &'a CpuGuard and bound the
lifetime of the returned reference to 'a, and then we don't need to do
any run-time checking at all.

Originally, I had left this to the caller because it might make sense
down the line for some complex behavior based on per-CPU (e.g., per-CPU
refcount) to do all its own management of per-CPU variables using
`PerCpuPtr` as a core primitive. In these cases, I believe there are
some times where being non-preemptible wouldn't actually be required
(that said, my thoughts on this aren't well reflected in the safety
comment, since I said it must be disabled... gah). But, the more I think
about it, the more I think these use cases would be better served by
just using `get_ptr` --- conjuring `&mut` references seems like it would
be a big footgun. And the safety comment already actually reflects these
thoughts somewhat :)

For v4 I will probably have this function take a &'a CpuGuard and use
that to bound the liftetime of the returned reference, unless there are
other thoughts on this point.

Thanks,
Mitchell

> Thanks,
> Yury

