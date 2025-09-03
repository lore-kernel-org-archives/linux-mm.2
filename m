Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA704CA1012
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 22:19:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 169D48E0003; Wed,  3 Sep 2025 18:19:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11BCA8E0001; Wed,  3 Sep 2025 18:19:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00A478E0003; Wed,  3 Sep 2025 18:19:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E076B8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:19:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8532B160929
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 22:19:31 +0000 (UTC)
X-FDA: 83849356542.29.5B7A22C
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9C318180003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 22:19:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f3YNuofz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=yury.norov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756937969; a=rsa-sha256;
	cv=none;
	b=D2fNQxPAxZUimY9haaNJjJBBwiAhGsj/aS2E55d17/9DwByZxpD08/U/B2N66cvUkQFxrh
	uu4OS5e/4Qgc4QUrvuM6rDk1Sy7iXtDhnCiYwZEOlV6TkN2DT1qJxB2YoukaAZZBV++dv9
	QlvRNeGKBuY2wPKOWEIdrMYuu1S74Zc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f3YNuofz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=yury.norov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756937969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FGh0aO9P7/8bAqXz1KGMkNxGhUGFVRPwAI7ofK2YqgQ=;
	b=p7m+sTsw4yNEEHiu28lor+TvC/JRN/UxZx8pyTyOLcZZDZB02HnTq7h6m0DuZWCewTKqU1
	NHPha37rMUFqXFqlwV9sOLzzAunxzX/1CdtiGMEHB6QZ5+xt5HWBu6p4JDgpilyGDr6Dbp
	53HJ3tcXryAv6xyuOmeS4E2icUZU7to=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b4f8bf49aeaso283785a12.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 15:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756937968; x=1757542768; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FGh0aO9P7/8bAqXz1KGMkNxGhUGFVRPwAI7ofK2YqgQ=;
        b=f3YNuofzFcIVTLL83/GBvqxjXpGd7cTkkzfn269eFwrjXLbs8xWXu1VnpgpEsbNtZG
         q1HnZT3uEUyQGGDJDqQpcYiSYlwPKwvHQp9irtKDUQMD7vKtXIVFxISsnB7KB7Ud+YYS
         RnftvhQPbOxnaV9OZjzzKZwAcM1wPDARderBTIHVzZa48kRAa2wUgTL4qkw02+1c/CZC
         Lb/BHvLRgc021qtssQztyGj1o4Y3mx2ZWU/82VMqKvd07ijYm2u3pS7XGGm+Q1Tld4yO
         jIwwAc2m6PNcOim/FQD9kDllZ6bq4/Ty/vev1yuPkRT2WJ+zDRX+KrSnfIHJ/+KH7W+A
         bp+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756937968; x=1757542768;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FGh0aO9P7/8bAqXz1KGMkNxGhUGFVRPwAI7ofK2YqgQ=;
        b=oTHvHSlNN4VeHvZgWxA8GdCNwSgRNfgmypxl5/3Jox2gEN0UOHrm41+EomwCLDxeNF
         O8kfqnnd8wFSEME+h73dxVjuLZ8tzr4/Zz+eDiaC188NnKFNsNIRhB1npjhhp0ZikQKZ
         yvyyWHt27CS78+m0bWbBimPfrriMkO3IlVkciSzVNz3So+yRx3D0r0pkmZZAcrEwUO1v
         Ujq2Cph1AXDMikDCZev1/LgTwuc/JK+wadgThF/Ztr2tqHYlOgFYA0vUkW047MU0Npb9
         jSC4rod33ng/ihutp9cdyGIELVDMqcP+tgTRxbLHM6RCo63FeyAE2Ld1+hvb2+y89WZd
         /+FA==
X-Forwarded-Encrypted: i=1; AJvYcCU4mBlpK7tJCfCfo5br+JkoVDxG0kIqn9xthuww7JqiwjN8IF2m2EUmZ8rAzWbBlirdMSkqs1w7YA==@kvack.org
X-Gm-Message-State: AOJu0YzX/GDJxQbRFGsBWnWbktJJf+rlDbX+ZWVtQvYM64T1ZnkQBgIt
	lHbrs8Dx0RdrBNTBIWWzh9LqjJl63et3rB6YKvn15rKQs8xegS2TGQeo
X-Gm-Gg: ASbGncuJfAhVA5iQOeeqQs7yCZODUM9v92/zJlXTIYNJkkvbnV2uk56wdxRD00nyNoj
	M2RjaqaIfuGcIzeAGg14ZjPDbFbvlIifhBsoJB0TtLneRqsxb88PLZxQxzA/TYSL4efiGScOTLR
	hvuHsJbE8C39LG1VZGJeHDVW2643bRgo2tsuCNYtJg51iXqYzY24ARQcsH8LFAW+N9elKC6jcGQ
	m8A/k3K/nmNHfGJaLyT/wtqNWzDWoWiB5O2mf+KoOuvuSn0I12rmTUBlrviKBnelhAQHs7E2c3y
	H0pEU4D7QbmZWBVcPBMEMpNVr1I/63tYy4Ho4L59RY5nflyW7mvownanC8Pbb3wJc5Mu6knFYqq
	+Ts1snXJCBZyXvhyPsPsnH8aY2LdS9STI
X-Google-Smtp-Source: AGHT+IHaoA1D5Y10BtKzlkX/Du8lTHmOmK64FNdTYwKg9zp5WV48oAL1copKMRA7EORTsmNKAIAGBg==
X-Received: by 2002:a17:902:e551:b0:246:d3a1:c6c4 with SMTP id d9443c01a7336-249448d8a65mr221190555ad.16.1756937968264;
        Wed, 03 Sep 2025 15:19:28 -0700 (PDT)
Received: from localhost ([216.228.127.131])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24ca63c9e71sm21354135ad.95.2025.09.03.15.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 15:19:27 -0700 (PDT)
Date: Wed, 3 Sep 2025 18:19:25 -0400
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
Subject: Re: [PATCH v3 5/7] rust: percpu: Support non-zeroable types for
 DynamicPerCpu
Message-ID: <aLi-7W21N45fBGJk@yury>
References: <20250828-rust-percpu-v3-0-4dd92e1e7904@gmail.com>
 <20250828-rust-percpu-v3-5-4dd92e1e7904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828-rust-percpu-v3-5-4dd92e1e7904@gmail.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C318180003
X-Stat-Signature: 1iwuuazm7d6x638bdwtty1qyujyw7ehm
X-HE-Tag: 1756937969-775930
X-HE-Meta: U2FsdGVkX1+uYDzA+SGCFQAOhOUZHu/cz80vF67d/gC9AnQpnK23diNDpc4g9CHUgwgMLWlwoM1N342Eihw9pLn4pets+L85J6JxqQNc6xy/rHt3vHd2hBYYHZMYEztV3YhDRtfHQlmzpZ8Kw1b+CZmDOZhgDiSjQ1cMpYZJwuWkqHfB/ysAqBsfz5UO2faIDPSsyMlNHiMOmk37criiuTsV7U+/PZw64sG2xuN+CWpezWai2Yy4V0bFB+G45LTbrWNlgtUA6aP9brMl/eFL4bRLGmAmjN0qNnhwamZ4C69Zgjz+jw95flbNwWJZNryVsDntZLEZXyvBvIhmCfSDqsaUNQMkb0cEbkhUYcXVUibqk+yYpM1xk7igEZlDArAzzXPeg3chiy0P9bPgT42WPXoD6Cv0TWNT3Zmw2uJc7JehPURtf3/4rQeYgFKJCVM19wAQZrJMwFRr71Jf7jonwS39NgOnyVL897aH2Ucxs4DMiguO4ts4F3jHJ9MabfRkqZNiWONJ3I6m3+kaGPAPK29/93nG6XPsg/WhHGmb0hDwJ2KkO15U127KVez3aKF5IMHBJMDJgnUiuA8HJsKByxI1+u4luCGoWGn6eWxcwsElCTs66BJ4Z5QXj3vSRiox1Iz43Qu0F8rqv4KPYe0oRuGE1t+jqufblhAhHmWgSnLFCD5/FZQuFE6a/V81V9AzBb+8e1Vu4DkBxKK/xXUW1MqGt+uRlfp+tcag92UekFB9uLIvWbD3Es2qE7l8aOB+WPiP4XTFaH2pY1jufn0IT4CNPcWE7w6B/NDkiiQaiyC/WFEnJtT/zoMjDtvvZ9KauklJ80g9T17NJcRbQimsZyhTSsqcMj0Mk4RSY3EpbBaQrJ4K96mbhyY0ljEwMT0khcNOQ3EL2TiE4Y2XpZX+KDr+R8DGec0BHu75ZNLfEkIbnC58L+d4M/Q3e0Fx8HDk10EK27jSW4+jlNXgC2e
 QU2gsCtD
 dwug3nQzbpDbvqUZZxpfUqMix2nhD3hbureT7CWAJhcKGjewZaYg+TKWlMK7y21gppWLTLiuRFoqv4JHmdXWZr7JOV47mV5l/X+m+OHoVxMBNv3BdEzdhQS4mTJoYNa9ZPeUSy2glGpUk1yt9x5fsurnTnvZybmgVoYH/FJNWNea4Rs/uvaJcXFSCJ3GPzcEnrcqcpV1ZVcwT452o8t/cOhSK4N9hoNjCB/7zdCVoCBH7hJG40uT8Hhq9MjsyTy636Au7NaAq9LDGFwOzwY238Hcu13uvVnCSyvpYQDk3X45lRtWtsN2vtaVjBD0kAOA9i4p3HiyZVG3tSoKiYsS7ll1h78TRPb6VSATz9sLDuT4a8DoUA8S1wzj0vOMEImfhKzWejNRaKE1M2OoK+U6BkKyfj/4123Jsun/GUnr1SHR/ZVMCAFdutFmKLPaOWinhlhvfi9sNTNA4pMbS+dVwrVyd/rztFiwCB20tCDy/scwrNz8rRK90C62a+mJU382dRgyuB2QRpdIZTr0+M94Svq3KKFJbxXx0XxtMkT/Lkruhsy9pJBIJLjLH+GAv3BrDRJRIM0P1AANsCWgq1L8ksUBNw30rpsrCy+5B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 12:00:12PM -0700, Mitchell Levy wrote:
> Add functionality to `PerCpuPtr` to compute pointers to per-CPU variable
> slots on other CPUs. Use this facility to initialize per-CPU variables
> on all possible CPUs when a dynamic per-CPU variable is created with a
> non-zeroable type. Since `RefCell` and other `Cell`-like types fall into
> this category, `impl CheckedPerCpu` on `DynamicPerCpu` for these
> `InteriorMutable` types since they can now be used. Add examples of
> these usages to `samples/rust/rust_percpu.rs`.
> 
> Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
> ---
>  rust/helpers/percpu.c         |  5 +++
>  rust/kernel/percpu.rs         | 15 +++++++
>  rust/kernel/percpu/dynamic.rs | 40 +++++++++++++++++
>  samples/rust/rust_percpu.rs   | 99 ++++++++++++++++++++++++++++++++++++++++---
>  4 files changed, 152 insertions(+), 7 deletions(-)
> 
> diff --git a/rust/helpers/percpu.c b/rust/helpers/percpu.c
> index 8cc01d094752..8d83b6b86106 100644
> --- a/rust/helpers/percpu.c
> +++ b/rust/helpers/percpu.c
> @@ -8,6 +8,11 @@ void __percpu *rust_helper_alloc_percpu(size_t sz, size_t align)
>  	return __alloc_percpu(sz, align);
>  }
>  
> +void *rust_helper_per_cpu_ptr(void __percpu *ptr, unsigned int cpu)
> +{
> +	return per_cpu_ptr(ptr, cpu);
> +}
> +
>  void rust_helper_on_each_cpu(smp_call_func_t func, void *info, int wait)
>  {
>  	on_each_cpu(func, info, wait);
> diff --git a/rust/kernel/percpu.rs b/rust/kernel/percpu.rs
> index 35afcdba3ccd..c68c7520b67f 100644
> --- a/rust/kernel/percpu.rs
> +++ b/rust/kernel/percpu.rs
> @@ -14,6 +14,7 @@
>  use bindings::{alloc_percpu, free_percpu};
>  
>  use crate::alloc::Flags;
> +use crate::cpu::CpuId;
>  use crate::percpu::cpu_guard::CpuGuard;
>  use crate::prelude::*;
>  use crate::sync::Arc;
> @@ -115,6 +116,20 @@ pub fn get_ptr(&self) -> *mut MaybeUninit<T> {
>          // the invariant that self.0 is a valid offset into the per-CPU area.
>          (this_cpu_area).wrapping_add(self.0 as usize).cast()
>      }
> +
> +    /// Get a `*mut MaybeUninit<T>` to the per-CPU variable on the CPU represented by `cpu`. Note
> +    /// that without some kind of synchronization, use of the returned pointer may cause a data
> +    /// race. It is the caller's responsibility to use the returned pointer in a reasonable way.
> +    ///
> +    /// # Safety
> +    /// - The returned pointer is valid only if `self` is (that is, it points to a live allocation
> +    ///   correctly sized and aligned to hold a `T`)
> +    /// - The returned pointer is valid only if the bit corresponding to `cpu` is set in
> +    ///   `Cpumask::possible()`.

Instead of explaining those rules in comments, can you just enforce
them in code? Not sure about the 1st rule, but the 2nd one looks like
a trivial check.

> +    pub unsafe fn get_remote_ptr(&self, cpu: CpuId) -> *mut MaybeUninit<T> {
> +        // SAFETY: The requirements of this function ensure this call is safe.
> +        unsafe { bindings::per_cpu_ptr(self.0.cast(), cpu.as_u32()) }.cast()
> +    }
>  }
>  
>  // SAFETY: Sending a `PerCpuPtr<T>` to another thread is safe because as soon as it's sent, the
> diff --git a/rust/kernel/percpu/dynamic.rs b/rust/kernel/percpu/dynamic.rs
> index ce95e420f943..64f04cef3705 100644
> --- a/rust/kernel/percpu/dynamic.rs
> +++ b/rust/kernel/percpu/dynamic.rs
> @@ -3,6 +3,8 @@
>  
>  use super::*;
>  
> +use crate::cpumask::Cpumask;
> +
>  /// Represents a dynamic allocation of a per-CPU variable via alloc_percpu. Calls free_percpu when
>  /// dropped.
>  pub struct PerCpuAllocation<T>(PerCpuPtr<T>);
> @@ -74,6 +76,36 @@ pub fn new_zero(flags: Flags) -> Option<Self> {
>      }
>  }
>  
> +impl<T: Clone> DynamicPerCpu<T> {
> +    /// Allocates a new per-CPU variable
> +    ///
> +    /// # Arguments
> +    /// * `val` - The initial value of the per-CPU variable on all CPUs.
> +    /// * `flags` - Flags used to allocate an `Arc` that keeps track of the underlying
> +    ///   `PerCpuAllocation`.
> +    pub fn new_with(val: T, flags: Flags) -> Option<Self> {
> +        let alloc: PerCpuAllocation<T> = PerCpuAllocation::new_uninit()?;
> +        let ptr = alloc.0;
> +
> +        for cpu in Cpumask::possible().iter() {

In C we've got the 'for_each_possible_cpu()'. Is there any way to
preserve that semantics in rust? I really believe that similar
semantics on higher level on both sides will help _a_lot_ for those
transitioning into the rust world (like me).

Thanks,
Yury
 
> +            // SAFETY: `ptr` is a valid allocation, and `cpu` appears in `Cpumask::possible()`
> +            let remote_ptr = unsafe { ptr.get_remote_ptr(cpu) };
> +            // SAFETY: Each CPU's slot corresponding to `ptr` is currently uninitialized, and no
> +            // one else has a reference to it. Therefore, we can freely write to it without
> +            // worrying about the need to drop what was there or whether we're racing with someone
> +            // else. `PerCpuPtr::get_remote_ptr` guarantees that the pointer is valid since we
> +            // derived it from a valid allocation and `cpu`.
> +            unsafe {
> +                (*remote_ptr).write(val.clone());
> +            }
> +        }
> +
> +        let arc = Arc::new(alloc, flags).ok()?;
> +
> +        Some(Self { alloc: arc })
> +    }
> +}
> +
>  impl<T> PerCpu<T> for DynamicPerCpu<T> {
>      unsafe fn get_mut(&mut self, guard: CpuGuard) -> PerCpuToken<'_, T> {
>          // SAFETY: The requirements of `PerCpu::get_mut` and this type's invariant ensure that the
> @@ -81,3 +113,11 @@ unsafe fn get_mut(&mut self, guard: CpuGuard) -> PerCpuToken<'_, T> {
>          unsafe { PerCpuToken::new(guard, &self.alloc.0) }
>      }
>  }
> +
> +impl<T: InteriorMutable> CheckedPerCpu<T> for DynamicPerCpu<T> {
> +    fn get(&mut self, guard: CpuGuard) -> CheckedPerCpuToken<'_, T> {
> +        // SAFETY: By the invariant of `DynamicPerCpu`, the memory location in each CPU's
> +        // per-CPU area corresponding to this variable has been initialized.
> +        unsafe { CheckedPerCpuToken::new(guard, &self.alloc.0) }
> +    }
> +}
> diff --git a/samples/rust/rust_percpu.rs b/samples/rust/rust_percpu.rs
> index 98ca1c781b6b..06b322019134 100644
> --- a/samples/rust/rust_percpu.rs
> +++ b/samples/rust/rust_percpu.rs
> @@ -130,13 +130,72 @@ fn init(_module: &'static ThisModule) -> Result<Self, Error> {
>  
>          // SAFETY: No prerequisites for on_each_cpu.
>          unsafe {
> -            on_each_cpu(Some(inc_percpu), (&raw mut test).cast(), 0);
> -            on_each_cpu(Some(inc_percpu), (&raw mut test).cast(), 0);
> -            on_each_cpu(Some(inc_percpu), (&raw mut test).cast(), 0);
> -            on_each_cpu(Some(inc_percpu), (&raw mut test).cast(), 1);
> -            on_each_cpu(Some(check_percpu), (&raw mut test).cast(), 1);
> +            on_each_cpu(Some(inc_percpu_u64), (&raw mut test).cast(), 0);
> +            on_each_cpu(Some(inc_percpu_u64), (&raw mut test).cast(), 0);
> +            on_each_cpu(Some(inc_percpu_u64), (&raw mut test).cast(), 0);
> +            on_each_cpu(Some(inc_percpu_u64), (&raw mut test).cast(), 1);
> +            on_each_cpu(Some(check_percpu_u64), (&raw mut test).cast(), 1);
>          }
>  
> +        let mut checked: DynamicPerCpu<RefCell<u64>> =
> +            DynamicPerCpu::new_with(RefCell::new(100), GFP_KERNEL).unwrap();
> +
> +        // SAFETY: No prerequisites for on_each_cpu.
> +        unsafe {
> +            on_each_cpu(Some(inc_percpu_refcell_u64), (&raw mut checked).cast(), 0);
> +            on_each_cpu(Some(inc_percpu_refcell_u64), (&raw mut checked).cast(), 0);
> +            on_each_cpu(Some(inc_percpu_refcell_u64), (&raw mut checked).cast(), 0);
> +            on_each_cpu(Some(inc_percpu_refcell_u64), (&raw mut checked).cast(), 1);
> +            on_each_cpu(Some(check_percpu_refcell_u64), (&raw mut checked).cast(), 1);
> +        }
> +
> +        checked.get(CpuGuard::new()).with(|val: &RefCell<u64>| {
> +            assert!(*val.borrow() == 104);
> +
> +            let mut checked_native = 0;
> +            *val.borrow_mut() = 0;
> +
> +            checked_native += 1;
> +            *val.borrow_mut() += 1;
> +            pr_info!(
> +                "Checked native: {}, *checked: {}\n",
> +                checked_native,
> +                val.borrow()
> +            );
> +            assert!(checked_native == *val.borrow() && checked_native == 1);
> +
> +            checked_native = checked_native.wrapping_add((-1i64) as u64);
> +            val.replace_with(|old: &mut u64| old.wrapping_add((-1i64) as u64));
> +            pr_info!(
> +                "Checked native: {}, *checked: {}\n",
> +                checked_native,
> +                val.borrow()
> +            );
> +            assert!(checked_native == *val.borrow() && checked_native == 0);
> +
> +            checked_native = checked_native.wrapping_add((-1i64) as u64);
> +            val.replace_with(|old: &mut u64| old.wrapping_add((-1i64) as u64));
> +            pr_info!(
> +                "Checked native: {}, *checked: {}\n",
> +                checked_native,
> +                val.borrow()
> +            );
> +            assert!(checked_native == *val.borrow() && checked_native == (-1i64) as u64);
> +
> +            checked_native = 0;
> +            *val.borrow_mut() = 0;
> +
> +            checked_native = checked_native.wrapping_sub(1);
> +            val.replace_with(|old: &mut u64| old.wrapping_sub(1));
> +            pr_info!(
> +                "Checked native: {}, *checked: {}\n",
> +                checked_native,
> +                val.borrow()
> +            );
> +            assert!(checked_native == *val.borrow() && checked_native == (-1i64) as u64);
> +            assert!(checked_native == *val.borrow() && checked_native == u64::MAX);
> +        });
> +
>          pr_info!("rust dynamic percpu test done\n");
>  
>          // Return Err to unload the module
> @@ -144,7 +203,7 @@ fn init(_module: &'static ThisModule) -> Result<Self, Error> {
>      }
>  }
>  
> -extern "C" fn inc_percpu(info: *mut c_void) {
> +extern "C" fn inc_percpu_u64(info: *mut c_void) {
>      // SAFETY: We know that info is a void *const DynamicPerCpu<u64> and DynamicPerCpu<u64> is Send.
>      let mut pcpu = unsafe { (*(info as *const DynamicPerCpu<u64>)).clone() };
>      pr_info!("Incrementing on {}\n", CpuId::current().as_u32());
> @@ -153,7 +212,7 @@ extern "C" fn inc_percpu(info: *mut c_void) {
>      unsafe { pcpu.get_mut(CpuGuard::new()) }.with(|val: &mut u64| *val += 1);
>  }
>  
> -extern "C" fn check_percpu(info: *mut c_void) {
> +extern "C" fn check_percpu_u64(info: *mut c_void) {
>      // SAFETY: We know that info is a void *const DynamicPerCpu<u64> and DynamicPerCpu<u64> is Send.
>      let mut pcpu = unsafe { (*(info as *const DynamicPerCpu<u64>)).clone() };
>      pr_info!("Asserting on {}\n", CpuId::current().as_u32());
> @@ -161,3 +220,29 @@ extern "C" fn check_percpu(info: *mut c_void) {
>      // SAFETY: We don't have multiple clones of pcpu in scope
>      unsafe { pcpu.get_mut(CpuGuard::new()) }.with(|val: &mut u64| assert!(*val == 4));
>  }
> +
> +extern "C" fn inc_percpu_refcell_u64(info: *mut c_void) {
> +    // SAFETY: We know that info is a void *const DynamicPerCpu<RefCell<u64>> and
> +    // DynamicPerCpu<RefCell<u64>> is Send.
> +    let mut pcpu = unsafe { (*(info as *const DynamicPerCpu<RefCell<u64>>)).clone() };
> +    // SAFETY: smp_processor_id has no preconditions
> +    pr_info!("Incrementing on {}\n", CpuId::current().as_u32());
> +
> +    pcpu.get(CpuGuard::new()).with(|val: &RefCell<u64>| {
> +        let mut val = val.borrow_mut();
> +        *val += 1;
> +    });
> +}
> +
> +extern "C" fn check_percpu_refcell_u64(info: *mut c_void) {
> +    // SAFETY: We know that info is a void *const DynamicPerCpu<RefCell<u64>> and
> +    // DynamicPerCpu<RefCell<u64>> is Send.
> +    let mut pcpu = unsafe { (*(info as *const DynamicPerCpu<RefCell<u64>>)).clone() };
> +    // SAFETY: smp_processor_id has no preconditions
> +    pr_info!("Asserting on {}\n", CpuId::current().as_u32());
> +
> +    pcpu.get(CpuGuard::new()).with(|val: &RefCell<u64>| {
> +        let val = val.borrow();
> +        assert!(*val == 104);
> +    });
> +}
> 
> -- 
> 2.34.1

