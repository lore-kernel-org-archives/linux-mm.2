Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E06ECA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 20:26:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 770056B000D; Thu,  4 Sep 2025 16:26:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 747F96B000E; Thu,  4 Sep 2025 16:26:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65D8D8E0006; Thu,  4 Sep 2025 16:26:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4FB126B000D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:26:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EA4A71403B7
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 20:26:13 +0000 (UTC)
X-FDA: 83852699826.12.4E87AAA
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf17.hostedemail.com (Postfix) with ESMTP id F1C5540010
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 20:26:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gNGsrVsy;
	spf=pass (imf17.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757017572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M3DawnKdh1VJq+m8353LvBxh7HWUqrctE+0WTNHYxA4=;
	b=EIzzJQnVObN78ydAj6wmuWH0LH2JrDlAPTF2JhjIJdQbUcyCi29f0VtmtE2vrdiEsWw/wB
	eTd9u+UqYQcY4Lj4lOv6DDtu8bY4eXr7+Bk3Z3FfdIxc27TWGgAV7hvUbyRlSA84GYYF2q
	7pYr+zhNM0yDs2UfjBfKGpegjkXJiD0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gNGsrVsy;
	spf=pass (imf17.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757017572; a=rsa-sha256;
	cv=none;
	b=A1+b/qcHg+5kGi6r3SxEedh+qor3mL/pXzHul+uXrL5OGkDZW0YY8b7FxEeLkWrQW5iayJ
	V3E/0qxBWzNo+dzOP69BmrZxjCUobdH119OiKaFlJaS0Ze1Y9swDV+Q9sjTLeCwY8TOw0H
	NnDQLECBGkGn3cNK7RqOQL1e54H7tgs=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7704f3c46ceso1202314b3a.2
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 13:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757017571; x=1757622371; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=M3DawnKdh1VJq+m8353LvBxh7HWUqrctE+0WTNHYxA4=;
        b=gNGsrVsyLptyXPx6ehKs7wtMTa/cv7Yk3okhS0uLL7qrEBdBr8MBT5qFDLbpkMaZek
         j3lmv0L5ocQJl9KTz8XNLsYIR1hOR8aKYLvyTfFugWnraqFjYDjEsG5rmy8K4qCdGvu9
         hHpvNnveakR9pKu91goN0FZ42m5uIyRn1H1IzTKb6olDVeQRJJlTNYRyTx/HTECinEtk
         rUehUTQkoGk2KY63T4P0JWShS7pTa2l5noZ3DFNA2X0zDN9Akdx2X7ZOvmL10S6kamAu
         xWG3piZxNjpHQwL7i3xLwBvdVOJNtBCOOegepD/vYg4YTTVK9NVEbPb7RBzUkaBfir7V
         xtsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757017571; x=1757622371;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M3DawnKdh1VJq+m8353LvBxh7HWUqrctE+0WTNHYxA4=;
        b=ecOgLzBmMW/MTNAu/D0+m/ZgOHbMOHWNpc2PZXeOXjLI9QJwE0J0kuvaEPxf0Ajewe
         Xwpv5QqqI3VtH1XOYVJGoPzTxIy1sKC32s/hapr/8p9AoeZ7N6dU2Jn4wXxj4LGtfz6t
         gUjphPf+Fqdd52rgdiGyE1CbwHOgjopX2PgUkUcey9gWKOeiFpgNCLtlhA5wEAvu0StV
         njVJHwikOkbdZARQQO+jAESD0+xwKKwSfCHO/sUtff1ZV9VQrBZS1r8CoAxxA4zZ5o+M
         M6YTjs5xwKgBCIKvYv6ADD+W50tyoTx8js1rAUEPvVo3Ep+tUTnji21LJvpOHwLPIrOz
         xXpQ==
X-Forwarded-Encrypted: i=1; AJvYcCXjqGBdsFGymA0lLzpsBFhh6jgRXj6keQDD3DI6FbHrkArYd+QLTnZbb3yYVdVbONS2a12RSk91rQ==@kvack.org
X-Gm-Message-State: AOJu0YxPhFxSuWew6WSkw1MkxqUZ5Nxcgj1O7tePpbogJV2u36GNNhGI
	16JGIs9JxFEd8SRyQLU8vWyVd8HkuHcql/TwGmTG81rVxqPpQC99NwoA
X-Gm-Gg: ASbGncugBfa64Gv+K8CoN9k8yMlW60TCkqoFkraHV8ajXaPbCQBDICdvwwGtgOKUWZ0
	SyctUF7YUZIZMK3krB2okb4y1Y+hbSnzbwTKHWteBaXz51d1G52KjVznTEWJIU6wwpf5bpywH9u
	K4fdDt5RXigiHx5g4ZZOc0RbhOmO16fZj/h7cEKqgeL0cG3pYcNaw8hHaKXqjAuo3HkRj/KUKs6
	0RVjs0YR+1BWX+nNuF0YUxG1B1xN5BN9lcQsjMbD+epX4lwfRwZ7U5pBmE/Z1yVtAgzEm4gFsfS
	oyIPc6siEJ81ZAsL9GkXxQ/sVSnS38Jc4AWHUgE1CPgg+rNfASNghVrlhO3hnExyaXXuNT5wGNu
	uEaWBLScZs0K13M+vh1Miwv6+xVVKwLLo3JKKxw==
X-Google-Smtp-Source: AGHT+IE4ZYCCGuchESUfP/TSkRBdMrDu9ZhZyv2wkzlRJ9OVelRFoCLCt0dmnWPHWazi7+BB2MjuPg==
X-Received: by 2002:a05:6a20:7fa8:b0:243:a251:cf46 with SMTP id adf61e73a8af0-243d6f0bc16mr30937981637.32.1757017570537;
        Thu, 04 Sep 2025 13:26:10 -0700 (PDT)
Received: from Cyndaquil. ([174.127.224.194])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32b9120cef8sm1354636a91.0.2025.09.04.13.26.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 13:26:10 -0700 (PDT)
Message-ID: <68b9f5e2.170a0220.1224d9.5d3d@mx.google.com>
X-Google-Original-Message-ID: <aLn138+i5jtEioqU@Cyndaquil.>
Date: Thu, 4 Sep 2025 13:26:07 -0700
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
Subject: Re: [PATCH v3 5/7] rust: percpu: Support non-zeroable types for
 DynamicPerCpu
References: <20250828-rust-percpu-v3-0-4dd92e1e7904@gmail.com>
 <20250828-rust-percpu-v3-5-4dd92e1e7904@gmail.com>
 <aLi-7W21N45fBGJk@yury>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLi-7W21N45fBGJk@yury>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F1C5540010
X-Stat-Signature: 1muu73meh7rxmmbok4u4ztyckfeoxeaq
X-Rspam-User: 
X-HE-Tag: 1757017571-354806
X-HE-Meta: U2FsdGVkX183FsHyAnDZYt5s8XicGKYb+p3Jypl/K6femAnRur6nDAbWaMxzcuUs4d5UAOw99FwJhgdWJTTqNorLqTQBciGIzrhBlkY0jwoJGmOBABM6MHMesT0Jj6bTdd5dDV2Byz+XyXd7VSCOhbAUNzXTuXxdYBROkROsQn4SyLW7rU3sfbPk3NbLsBNSNsnbKjEEyXgAHaEhE4JgQOdAbH426Fm+XPvkLZAyUbHjXrq9gBHkiBDKB2JbJ6HAeb2IXKkavPlBDIhSgQ6nxtv+OZg3j74XSVPgI6/pWciJZkCRg3bnLEtLy7LBboH+EfvEiWtXQXlXtdvOYCZ+zGGD/Bx60WJLMPQzklfBuObZUBPN5PnZbMAoC+/yXtS6FnttBZil8QdktJ2Hw2Y3TfS62ItOFHeUdiom5pkoSvYz3qDnvDl3OTcYj+OdrFZPNkx15IeA+ePLSl7C6i1p87pRcmK+J85i6VPec/++D3Gx0Cg+anBXBBVkJRBYvlvoVqv6FzwFpOCoHHQaLNZe9U0EVMQb/Vvr1N5YTDQIObd/U6/NcPkpg3mdZymnOHfntZwqTb3ObeU3afgv/OXeQmwyhDcVaIPSfzULlg1L8fMFm0LmsigtvrK7K+fAUwlfyO4v5wlMVobGsNI5VJthZqu3z+Mt1rFTbVDpUVN2rD4SW0toS1/GWH0+8nIGJBuAsHR0+del08QWgo3QV18H4uObliq7EV/XIeyVQcycqD3mm04Sp8D3UMhuPdayxZMZvV7IYIlYng4znabOW7isuL/l4l5CKoZA+afu4M0Wvvyve0hN5EHzBkdTQrGlGhNFvZQ4YAPj+Bnf8tXz7KGvK4nwkKPkOcz3o2h6sLaiEwreqAXFRvi1099k7wAMdgO86pdUuCxphmZNU2e2GuSswkhw2Mroi7iHyC6p5adE3YWsJdlPSUqnwp6Ics50uYBNHngnXoyAW7n0ja/HsCv
 V2HfQp8V
 Rt7PpYQzNDyvuvTT0oZUQh5O5WP0gQNqa3qv3TmcaBCuqogvR20U6fjOWd2E6oL9oy+UDzViFG1VG82z7TK2Pn4rCSy5UE35MOyMuUKR4URqh+SNAscUdPdyvBqkrYWa3Tp0bCPlYv0shamV14yBbQLTAc5X+likcjfEsP40PoYKqlrN+q5/wt3UD1LJqMLNKHClr3SHMZfheYW/vDqD6ZHeeLYzpZO9SlsNBEUkaf2+LcMBLSBkbtHtQuc72swhf7VyXoU1IWuMyndpQpnGjnFqw3C36kDzdOPTgUr67I5vFL8x9jYBmmHl7wQFaBXVW4Lvx0wySm6jEsu6Qwxey/qwAPaGcvPL+D15GI2qSmdQ1uahpvdTG1ABSQdzGoKVgXO7bwq2j5jDAtIfcxZGKhVfopRbYsoHUlnB8rGBhGtenKSqly+yO8dWkWVZcS/MBFvDMAL2enrg7CSH5jSsa0XXaZEv55Z7JsDaHkNA8nNvDcOY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 06:19:25PM -0400, Yury Norov wrote:
> On Thu, Aug 28, 2025 at 12:00:12PM -0700, Mitchell Levy wrote:
> > Add functionality to `PerCpuPtr` to compute pointers to per-CPU variable
> > slots on other CPUs. Use this facility to initialize per-CPU variables
> > on all possible CPUs when a dynamic per-CPU variable is created with a
> > non-zeroable type. Since `RefCell` and other `Cell`-like types fall into
> > this category, `impl CheckedPerCpu` on `DynamicPerCpu` for these
> > `InteriorMutable` types since they can now be used. Add examples of
> > these usages to `samples/rust/rust_percpu.rs`.
> > 
> > Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
> > ---
> >  rust/helpers/percpu.c         |  5 +++
> >  rust/kernel/percpu.rs         | 15 +++++++
> >  rust/kernel/percpu/dynamic.rs | 40 +++++++++++++++++
> >  samples/rust/rust_percpu.rs   | 99 ++++++++++++++++++++++++++++++++++++++++---
> >  4 files changed, 152 insertions(+), 7 deletions(-)
> > 
> > diff --git a/rust/helpers/percpu.c b/rust/helpers/percpu.c
> > index 8cc01d094752..8d83b6b86106 100644
> > --- a/rust/helpers/percpu.c
> > +++ b/rust/helpers/percpu.c
> > @@ -8,6 +8,11 @@ void __percpu *rust_helper_alloc_percpu(size_t sz, size_t align)
> >  	return __alloc_percpu(sz, align);
> >  }
> >  
> > +void *rust_helper_per_cpu_ptr(void __percpu *ptr, unsigned int cpu)
> > +{
> > +	return per_cpu_ptr(ptr, cpu);
> > +}
> > +
> >  void rust_helper_on_each_cpu(smp_call_func_t func, void *info, int wait)
> >  {
> >  	on_each_cpu(func, info, wait);
> > diff --git a/rust/kernel/percpu.rs b/rust/kernel/percpu.rs
> > index 35afcdba3ccd..c68c7520b67f 100644
> > --- a/rust/kernel/percpu.rs
> > +++ b/rust/kernel/percpu.rs
> > @@ -14,6 +14,7 @@
> >  use bindings::{alloc_percpu, free_percpu};
> >  
> >  use crate::alloc::Flags;
> > +use crate::cpu::CpuId;
> >  use crate::percpu::cpu_guard::CpuGuard;
> >  use crate::prelude::*;
> >  use crate::sync::Arc;
> > @@ -115,6 +116,20 @@ pub fn get_ptr(&self) -> *mut MaybeUninit<T> {
> >          // the invariant that self.0 is a valid offset into the per-CPU area.
> >          (this_cpu_area).wrapping_add(self.0 as usize).cast()
> >      }
> > +
> > +    /// Get a `*mut MaybeUninit<T>` to the per-CPU variable on the CPU represented by `cpu`. Note
> > +    /// that without some kind of synchronization, use of the returned pointer may cause a data
> > +    /// race. It is the caller's responsibility to use the returned pointer in a reasonable way.
> > +    ///
> > +    /// # Safety
> > +    /// - The returned pointer is valid only if `self` is (that is, it points to a live allocation
> > +    ///   correctly sized and aligned to hold a `T`)
> > +    /// - The returned pointer is valid only if the bit corresponding to `cpu` is set in
> > +    ///   `Cpumask::possible()`.
> 
> Instead of explaining those rules in comments, can you just enforce
> them in code? Not sure about the 1st rule, but the 2nd one looks like
> a trivial check.

I don't think the first one is possible to check (at least, certainly
not without peeking deeply into the per-CPU allocation management
system).

For the second, I will probably be converting this function to a safe
function (see my reply to Miguel), with these being requirements for the
returned pointer to be valid, so panicking when the requirements aren't
met would probably not be expected behavior.

> > +    pub unsafe fn get_remote_ptr(&self, cpu: CpuId) -> *mut MaybeUninit<T> {
> > +        // SAFETY: The requirements of this function ensure this call is safe.
> > +        unsafe { bindings::per_cpu_ptr(self.0.cast(), cpu.as_u32()) }.cast()
> > +    }
> >  }
> >  
> >  // SAFETY: Sending a `PerCpuPtr<T>` to another thread is safe because as soon as it's sent, the
> > diff --git a/rust/kernel/percpu/dynamic.rs b/rust/kernel/percpu/dynamic.rs
> > index ce95e420f943..64f04cef3705 100644
> > --- a/rust/kernel/percpu/dynamic.rs
> > +++ b/rust/kernel/percpu/dynamic.rs
> > @@ -3,6 +3,8 @@
> >  
> >  use super::*;
> >  
> > +use crate::cpumask::Cpumask;
> > +
> >  /// Represents a dynamic allocation of a per-CPU variable via alloc_percpu. Calls free_percpu when
> >  /// dropped.
> >  pub struct PerCpuAllocation<T>(PerCpuPtr<T>);
> > @@ -74,6 +76,36 @@ pub fn new_zero(flags: Flags) -> Option<Self> {
> >      }
> >  }
> >  
> > +impl<T: Clone> DynamicPerCpu<T> {
> > +    /// Allocates a new per-CPU variable
> > +    ///
> > +    /// # Arguments
> > +    /// * `val` - The initial value of the per-CPU variable on all CPUs.
> > +    /// * `flags` - Flags used to allocate an `Arc` that keeps track of the underlying
> > +    ///   `PerCpuAllocation`.
> > +    pub fn new_with(val: T, flags: Flags) -> Option<Self> {
> > +        let alloc: PerCpuAllocation<T> = PerCpuAllocation::new_uninit()?;
> > +        let ptr = alloc.0;
> > +
> > +        for cpu in Cpumask::possible().iter() {
> 
> In C we've got the 'for_each_possible_cpu()'. Is there any way to
> preserve that semantics in rust? I really believe that similar
> semantics on higher level on both sides will help _a_lot_ for those
> transitioning into the rust world (like me).

I'm not sure I understand what you mean --- I believe the semantics
should be the same here (`cpu` takes on each value in
`cpu_possible_mask`). Could you please clarify?

Thanks,
Mitchell

> Thanks,
> Yury
>  
> > +            // SAFETY: `ptr` is a valid allocation, and `cpu` appears in `Cpumask::possible()`
> > +            let remote_ptr = unsafe { ptr.get_remote_ptr(cpu) };
> > +            // SAFETY: Each CPU's slot corresponding to `ptr` is currently uninitialized, and no
> > +            // one else has a reference to it. Therefore, we can freely write to it without
> > +            // worrying about the need to drop what was there or whether we're racing with someone
> > +            // else. `PerCpuPtr::get_remote_ptr` guarantees that the pointer is valid since we
> > +            // derived it from a valid allocation and `cpu`.
> > +            unsafe {
> > +                (*remote_ptr).write(val.clone());
> > +            }
> > +        }
> > +
> > +        let arc = Arc::new(alloc, flags).ok()?;
> > +
> > +        Some(Self { alloc: arc })
> > +    }
> > +}
> > +
> >  impl<T> PerCpu<T> for DynamicPerCpu<T> {
> >      unsafe fn get_mut(&mut self, guard: CpuGuard) -> PerCpuToken<'_, T> {
> >          // SAFETY: The requirements of `PerCpu::get_mut` and this type's invariant ensure that the
> > @@ -81,3 +113,11 @@ unsafe fn get_mut(&mut self, guard: CpuGuard) -> PerCpuToken<'_, T> {
> >          unsafe { PerCpuToken::new(guard, &self.alloc.0) }
> >      }
> >  }
> > +
> > +impl<T: InteriorMutable> CheckedPerCpu<T> for DynamicPerCpu<T> {
> > +    fn get(&mut self, guard: CpuGuard) -> CheckedPerCpuToken<'_, T> {
> > +        // SAFETY: By the invariant of `DynamicPerCpu`, the memory location in each CPU's
> > +        // per-CPU area corresponding to this variable has been initialized.
> > +        unsafe { CheckedPerCpuToken::new(guard, &self.alloc.0) }
> > +    }
> > +}
> > diff --git a/samples/rust/rust_percpu.rs b/samples/rust/rust_percpu.rs
> > index 98ca1c781b6b..06b322019134 100644
> > --- a/samples/rust/rust_percpu.rs
> > +++ b/samples/rust/rust_percpu.rs
> > @@ -130,13 +130,72 @@ fn init(_module: &'static ThisModule) -> Result<Self, Error> {
> >  
> >          // SAFETY: No prerequisites for on_each_cpu.
> >          unsafe {
> > -            on_each_cpu(Some(inc_percpu), (&raw mut test).cast(), 0);
> > -            on_each_cpu(Some(inc_percpu), (&raw mut test).cast(), 0);
> > -            on_each_cpu(Some(inc_percpu), (&raw mut test).cast(), 0);
> > -            on_each_cpu(Some(inc_percpu), (&raw mut test).cast(), 1);
> > -            on_each_cpu(Some(check_percpu), (&raw mut test).cast(), 1);
> > +            on_each_cpu(Some(inc_percpu_u64), (&raw mut test).cast(), 0);
> > +            on_each_cpu(Some(inc_percpu_u64), (&raw mut test).cast(), 0);
> > +            on_each_cpu(Some(inc_percpu_u64), (&raw mut test).cast(), 0);
> > +            on_each_cpu(Some(inc_percpu_u64), (&raw mut test).cast(), 1);
> > +            on_each_cpu(Some(check_percpu_u64), (&raw mut test).cast(), 1);
> >          }
> >  
> > +        let mut checked: DynamicPerCpu<RefCell<u64>> =
> > +            DynamicPerCpu::new_with(RefCell::new(100), GFP_KERNEL).unwrap();
> > +
> > +        // SAFETY: No prerequisites for on_each_cpu.
> > +        unsafe {
> > +            on_each_cpu(Some(inc_percpu_refcell_u64), (&raw mut checked).cast(), 0);
> > +            on_each_cpu(Some(inc_percpu_refcell_u64), (&raw mut checked).cast(), 0);
> > +            on_each_cpu(Some(inc_percpu_refcell_u64), (&raw mut checked).cast(), 0);
> > +            on_each_cpu(Some(inc_percpu_refcell_u64), (&raw mut checked).cast(), 1);
> > +            on_each_cpu(Some(check_percpu_refcell_u64), (&raw mut checked).cast(), 1);
> > +        }
> > +
> > +        checked.get(CpuGuard::new()).with(|val: &RefCell<u64>| {
> > +            assert!(*val.borrow() == 104);
> > +
> > +            let mut checked_native = 0;
> > +            *val.borrow_mut() = 0;
> > +
> > +            checked_native += 1;
> > +            *val.borrow_mut() += 1;
> > +            pr_info!(
> > +                "Checked native: {}, *checked: {}\n",
> > +                checked_native,
> > +                val.borrow()
> > +            );
> > +            assert!(checked_native == *val.borrow() && checked_native == 1);
> > +
> > +            checked_native = checked_native.wrapping_add((-1i64) as u64);
> > +            val.replace_with(|old: &mut u64| old.wrapping_add((-1i64) as u64));
> > +            pr_info!(
> > +                "Checked native: {}, *checked: {}\n",
> > +                checked_native,
> > +                val.borrow()
> > +            );
> > +            assert!(checked_native == *val.borrow() && checked_native == 0);
> > +
> > +            checked_native = checked_native.wrapping_add((-1i64) as u64);
> > +            val.replace_with(|old: &mut u64| old.wrapping_add((-1i64) as u64));
> > +            pr_info!(
> > +                "Checked native: {}, *checked: {}\n",
> > +                checked_native,
> > +                val.borrow()
> > +            );
> > +            assert!(checked_native == *val.borrow() && checked_native == (-1i64) as u64);
> > +
> > +            checked_native = 0;
> > +            *val.borrow_mut() = 0;
> > +
> > +            checked_native = checked_native.wrapping_sub(1);
> > +            val.replace_with(|old: &mut u64| old.wrapping_sub(1));
> > +            pr_info!(
> > +                "Checked native: {}, *checked: {}\n",
> > +                checked_native,
> > +                val.borrow()
> > +            );
> > +            assert!(checked_native == *val.borrow() && checked_native == (-1i64) as u64);
> > +            assert!(checked_native == *val.borrow() && checked_native == u64::MAX);
> > +        });
> > +
> >          pr_info!("rust dynamic percpu test done\n");
> >  
> >          // Return Err to unload the module
> > @@ -144,7 +203,7 @@ fn init(_module: &'static ThisModule) -> Result<Self, Error> {
> >      }
> >  }
> >  
> > -extern "C" fn inc_percpu(info: *mut c_void) {
> > +extern "C" fn inc_percpu_u64(info: *mut c_void) {
> >      // SAFETY: We know that info is a void *const DynamicPerCpu<u64> and DynamicPerCpu<u64> is Send.
> >      let mut pcpu = unsafe { (*(info as *const DynamicPerCpu<u64>)).clone() };
> >      pr_info!("Incrementing on {}\n", CpuId::current().as_u32());
> > @@ -153,7 +212,7 @@ extern "C" fn inc_percpu(info: *mut c_void) {
> >      unsafe { pcpu.get_mut(CpuGuard::new()) }.with(|val: &mut u64| *val += 1);
> >  }
> >  
> > -extern "C" fn check_percpu(info: *mut c_void) {
> > +extern "C" fn check_percpu_u64(info: *mut c_void) {
> >      // SAFETY: We know that info is a void *const DynamicPerCpu<u64> and DynamicPerCpu<u64> is Send.
> >      let mut pcpu = unsafe { (*(info as *const DynamicPerCpu<u64>)).clone() };
> >      pr_info!("Asserting on {}\n", CpuId::current().as_u32());
> > @@ -161,3 +220,29 @@ extern "C" fn check_percpu(info: *mut c_void) {
> >      // SAFETY: We don't have multiple clones of pcpu in scope
> >      unsafe { pcpu.get_mut(CpuGuard::new()) }.with(|val: &mut u64| assert!(*val == 4));
> >  }
> > +
> > +extern "C" fn inc_percpu_refcell_u64(info: *mut c_void) {
> > +    // SAFETY: We know that info is a void *const DynamicPerCpu<RefCell<u64>> and
> > +    // DynamicPerCpu<RefCell<u64>> is Send.
> > +    let mut pcpu = unsafe { (*(info as *const DynamicPerCpu<RefCell<u64>>)).clone() };
> > +    // SAFETY: smp_processor_id has no preconditions
> > +    pr_info!("Incrementing on {}\n", CpuId::current().as_u32());
> > +
> > +    pcpu.get(CpuGuard::new()).with(|val: &RefCell<u64>| {
> > +        let mut val = val.borrow_mut();
> > +        *val += 1;
> > +    });
> > +}
> > +
> > +extern "C" fn check_percpu_refcell_u64(info: *mut c_void) {
> > +    // SAFETY: We know that info is a void *const DynamicPerCpu<RefCell<u64>> and
> > +    // DynamicPerCpu<RefCell<u64>> is Send.
> > +    let mut pcpu = unsafe { (*(info as *const DynamicPerCpu<RefCell<u64>>)).clone() };
> > +    // SAFETY: smp_processor_id has no preconditions
> > +    pr_info!("Asserting on {}\n", CpuId::current().as_u32());
> > +
> > +    pcpu.get(CpuGuard::new()).with(|val: &RefCell<u64>| {
> > +        let val = val.borrow();
> > +        assert!(*val == 104);
> > +    });
> > +}
> > 
> > -- 
> > 2.34.1

