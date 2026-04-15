Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47644F428D4
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 20:34:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 576C96B0005; Wed, 15 Apr 2026 16:34:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 527506B0089; Wed, 15 Apr 2026 16:34:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 416616B008A; Wed, 15 Apr 2026 16:34:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2CC536B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 16:34:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B5E691405EF
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 20:34:33 +0000 (UTC)
X-FDA: 84661943226.11.D593C68
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id CAE8B40019
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 20:34:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gCpXN4I0;
	spf=pass (imf01.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776285271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=evPdVc7JX1/GCJya2uVD7AD+qpQmSg6Z2GMNsgZnKSs=;
	b=SV4PVLZBdMsRDfpooa65YxVJMY/wLMiFWZxLMHmC3zKyDa0zcmZX9JeXIw9+e3e+RobCoZ
	EI+Oa/5GulCGqv/VA23TxZcDoU+Nan4vuVcR7p3Zq5Ai6i9V42/LZMcPGzBwy8EKZs2pNx
	9ciBrOZf05FTysRvUu7c0O8F6dA/zgA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gCpXN4I0;
	spf=pass (imf01.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776285271; a=rsa-sha256;
	cv=none;
	b=JLFW+OWNiqdV+UArqfi+CbwR6qdPmYLFMNaA6HaS3uBDjMdltFJT3RCDMQP1YKewjc0hpS
	5vyNau0dpAFZXGMJdNAjcnPDnELIrgKasw87yugfVVN/sx99ljISUhdilJkIq5OhG4zOPR
	IniYEQl5mYNYZ7CU/DXfRm2KqRDubZs=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-82f206f2b54so1958165b3a.0
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 13:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776285270; x=1776890070; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=evPdVc7JX1/GCJya2uVD7AD+qpQmSg6Z2GMNsgZnKSs=;
        b=gCpXN4I0M+ip3Ak8c4kSa4hJQ7bAWQAGdg9ip7G6zbX+SDJpdK8YgatdiUdYYWpTbj
         7c89nQMjuvWvw49Xq0hn+qoWWgE47WqOpsXN3qNvru1NfKaNhTro2ofq7OfxB4CmUupJ
         X8sjqq/FtTCNE5aQf6adPJTm08aNc6yQiShX4+FJFLWyjVTr4ho+l4/CXN40qypN0dJS
         vMF1PxRvKowbrqVG66R1uWCl2nHWoleSU4CSldo5NMDy3YnWqG0bpmXpkA47FdTSvIrf
         RZ2q0B05cOv4v2nBJzGAxVn8cMP4/kxJ/x/uM/7ObNuPxEuAR1+e7f6EZ5+N4/BufXC+
         3+Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776285271; x=1776890071;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=evPdVc7JX1/GCJya2uVD7AD+qpQmSg6Z2GMNsgZnKSs=;
        b=nSL5XEENeF+Wke9LGLcM9GhqyEBqSQLrOcvQ3jDe31wRsBs5KBR5AN75b13j5znWY4
         InAkO3WrTwmEg56E1+32+4vVLVoU5Yp8CY67syAn/4vfNhi/coQqa0TjLkMu41btE07m
         hastlG+cJ0C5bxzhOBO0wo7CNK48cyTcaENWel/zui53bJsbiNK4XFUh/8qMgqLKDfX4
         ipPTW68e0Xs9djwfcTQTjb82YZCVz9wHylpYuxFVhB0Y8ba4eWIk1cdCCZc/vxpHbnsE
         1JcXU9M8I9tAZrX+SazsoyXE6ROOBmbah/8ByHumO6ZwBHOwNxkLn8R8jioRxGtoMfk6
         MDJw==
X-Forwarded-Encrypted: i=1; AFNElJ/PWhcRP1diobqTEkmeowghqG+84CqPU4Ts4EEzgh3mHq/PpVKQB+IYYbMmdEXKvT3v5ZZ8omQBDQ==@kvack.org
X-Gm-Message-State: AOJu0YxpjeSslfyFKvi08mt99mIzlQ8/ctuodVGA60p3BmrWMtdbXEqJ
	igySEc0NAl4m10awTj3O08dlP0rbKaTTay4ixEj8g0KRqc83fn4GgQOv
X-Gm-Gg: AeBDieuHVZrHgqagXLIU1wXfzu8lSmuowQ3MzYQtKnqxW/tIDF56ubiw3aAi6ZZhVti
	O3Een7zVk2mVxFDhTLu64kbVwtRvYJhAVQxkudlKgL6Ffa0BbOsWaY4EoqEXqGH4yVmI3nTsmD8
	9N+fo0EcgdURUEfeNQ1PpcxMXOBzZfmD9CbJyAz5vDYbcQyuzC4vS7iTlmNeaT6NcPKwfHYW6HP
	vtwZKZjgNXhTj6teUpL+MEG8FPVzuXVxHnvzGvV4kquBq/YIWoiXhBrt8LNUmZ+H2AjCH/j/Dwv
	3eFr40t4IzctAisinxNOUDbQScimtHyoOtn4ZlrW1GygDsehzmtVx2au5qEmW9FEWxYPQwEXB9j
	zpQ4O0Ra6FWwkrPanhEipkML1nUwkkHkTjwHaGIMaEypw+VvgvwPOgu2CBoLT1NrLp235cZSbz3
	F+td9HcE9mUFzT2hzX8rJ+bM1ivObuQYfI+M8rF1YSXy3oVbSd0GgbdROQbZgsOcfj8w/AbXXlb
	c9gWQS9sZyaoRsw3DTQVJzLmaknllmH3XACOy0iYz01POPtwjY=
X-Received: by 2002:a05:6a00:99a:b0:82f:453e:3863 with SMTP id d2e1a72fcca58-82f453e4382mr12834428b3a.22.1776285270267;
        Wed, 15 Apr 2026 13:34:30 -0700 (PDT)
Received: from Cyndaquil.localdomain ([131.107.1.142])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f6728d5d3sm2997490b3a.25.2026.04.15.13.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 13:34:29 -0700 (PDT)
Date: Wed, 15 Apr 2026 13:34:28 -0700
From: Mitchell Levy <levymitchell0@gmail.com>
To: Yury Norov <ynorov@nvidia.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Benno Lossin <lossin@kernel.org>, Yury Norov <yury.norov@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Boqun Feng <boqun@kernel.org>, Tyler Hicks <code@tyhicks.com>,
	Allen Pais <apais@linux.microsoft.com>,
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v5 7/8] rust: percpu: Add pin-hole optimizations for
 numerics
Message-ID: <ad_2VOc2hjhTYMQk@Cyndaquil.localdomain>
References: <20260410-rust-percpu-v5-0-4292380d7a41@gmail.com>
 <20260410-rust-percpu-v5-7-4292380d7a41@gmail.com>
 <adm6rmerdgVtclo5@yury>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adm6rmerdgVtclo5@yury>
X-Stat-Signature: wmhphcpnzcu3wj5mhsg9cnnww55ck9fz
X-Rspamd-Queue-Id: CAE8B40019
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776285271-163241
X-HE-Meta: U2FsdGVkX19NxaMrmEnIpz56x8Xgdczyj7MCQYV+s52FCmUxT9yhUBQMAx799PQC8QICG41qCH3IOlY1YUF+P5iBHE8C2zvrvpY4Qc7VmmHTDNaGt+y75NZzEJRhaPUoyUtjglHzkvi6ofuQf38ZxPQD0Vys7O5j+mXdaOdKwdFl+vIo/8cXVZhnUkB3m8qqYpRMo+IFyOae9b2nFi57HPcrNBGNiIkmpRSrAQga10eDPaVB2hOtULfm7oAVj1ltX6oaoanUtOsz8VQHovaT/uQTnksbZVv4FZpOB4q8BUtV31TjB8uiIP2uQ5PbZFjEchNS6D0YUeXd8jTiYFUN74ciwNAtgZ/w5AijzOBETX+GLvzL1CTfiDXuYHbFd89ngbz80OroJFhKUxhtVXXNj6fv1/jm3DaJiahtqwboImupOGV4R3Z9J4v7TXiLrnR2Kphk21jJ/YZYW5Y9nVupnqZWchi3fHMw24vjmI2iyjU900Zeduf8Fh3dOC4YtVrOYZog/Kpbp2ppMb1cPEpaXOMKRDww811dxVKs30c6eTatjDKYYuVdofO8Ay3DB5fhiXfiP21+YV7cMTmkiUr4U09EkQGx0DMOxS4DMLEoanOShwy0HsdxHom/qsd/1adWSpUTV4hSb3e5uMz5ZkLx6g1cdwpUMDu/0a6yLQsqcEb8YJdkbPxatI6NaUy5gFvQKOl8ld/fvyl1+G0/YynvNcXMmwUSQ2nwS1ahN0bKLHNYanZHrSBpLacUAYHuacJ/GSPRyxlhlxk3P7v3L7sMn2B2lJKhctnc3jDip8yQajyWAL0kvI1i/b2piHYyijP8bJoEXQcZS+zrqzwg2A8IsTZBP7ao3IsJ4gTKZzgJC+GYeSJ/10ChVNGAYZm2WyKKbeYFqJfHmYlMfm1ouzXweO7Rl9qGpdsf76TOu3m9aU+Gvp1FSHx8SGP8tDE16wyuhiaYxdQ8AAuFQnBCycn
 Wt/MvC6S
 2s8S90+9xel+227ZmPS0cjzJWat4ALDVIWPZZQt2vKTXRRizSDUkLwsR5bc1SXyVT44LAW0ATw3b52G3fyJNdJ/7NQ/RykqnN7nvrSSt4TZVkECCitHYTtAEsnpauBlWCfK5bikxqE+IGZJFgIgrMtHepWPtuJiyqnQoDQUMyoPNdtb4ZVxmxP9eoiecCX4K7BZh5xvAeT7lsEGZ5Mi804DXoRsGd5RldGLf4noRnh27rhdEMRrVtajLhmFCr8A+jDdqL60MRCncrOsGxaICVNa5xJBTKxDFSQH/+T0dijXoyx/wjIA029/T0I+DaWcsDFV2p28yO66CW6biZRdqTLzzHopo9ELCgy0lgAsO9AcI5HV0qk/+B7RKGY75ExDp4l06QuuB08gGogllW5YNRR77MHaOuXx+7SxGfvQWOG53f00Rkwr46HEjCaT770ESO1t3bDzko4oAK7W8qLuU1GHHlpjX+BSbUTmepikrWWw9s8apidSiTL4xOWrAHbUAwlX6f53FL8OOq16MdHGPB+/2NXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 11:06:22PM -0400, Yury Norov wrote:
> On Fri, Apr 10, 2026 at 02:35:37PM -0700, Mitchell Levy wrote:
> > The C implementations of `this_cpu_add`, `this_cpu_sub`, etc., are
> > optimized to save an instruction by avoiding having to compute
> > `this_cpu_ptr(&x)` for some per-CPU variable `x`. For example, rather
> > than
> > 
> >     u64 *x_ptr = this_cpu_ptr(&x);
> >     *x_ptr += 5;
> > 
> > the implementation of `this_cpu_add` is clever enough to make use of the
> > fact that per-CPU variables are implemented on x86 via segment
> > registers, and so we can use only a single instruction (where we assume
> > `&x` is already in `rax`)
> > 
> >     add gs:[rax], 5
> > 
> > Add this optimization via a `PerCpuNumeric` type to enable code-reuse
> > between `DynamicPerCpu` and `StaticPerCpu`.
> > 
> > Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
> > ---
> >  rust/kernel/percpu.rs         |   1 +
> >  rust/kernel/percpu/dynamic.rs |  10 ++-
> >  rust/kernel/percpu/numeric.rs | 138 ++++++++++++++++++++++++++++++++++++++++++
> >  samples/rust/rust_percpu.rs   |  36 +++++++++++
> >  4 files changed, 184 insertions(+), 1 deletion(-)
> > 
> > diff --git a/rust/kernel/percpu.rs b/rust/kernel/percpu.rs
> > index 72c83fef68ee..ff04607ee047 100644
> > --- a/rust/kernel/percpu.rs
> > +++ b/rust/kernel/percpu.rs
> > @@ -6,6 +6,7 @@
> >  
> >  pub mod cpu_guard;
> >  mod dynamic;
> > +pub mod numeric;
> >  mod static_;
> >  
> >  #[doc(inline)]
> > diff --git a/rust/kernel/percpu/dynamic.rs b/rust/kernel/percpu/dynamic.rs
> > index 40514704b3d0..a717138b93dc 100644
> > --- a/rust/kernel/percpu/dynamic.rs
> > +++ b/rust/kernel/percpu/dynamic.rs
> > @@ -28,7 +28,7 @@
> >  /// the memory location on any particular CPU has been initialized. This means that it cannot tell
> >  /// whether it should drop the *contents* of the allocation when it is dropped. It is up to the
> >  /// user to do this via something like [`core::ptr::drop_in_place`].
> > -pub struct PerCpuAllocation<T>(PerCpuPtr<T>);
> > +pub struct PerCpuAllocation<T>(pub(super) PerCpuPtr<T>);
> >  
> >  impl<T: Zeroable> PerCpuAllocation<T> {
> >      /// Dynamically allocates a space in the per-CPU area suitably sized and aligned to hold a `T`,
> > @@ -162,6 +162,14 @@ pub fn new_from(mut initer: impl FnMut(CpuId) -> T, flags: Flags) -> Option<Self
> >      }
> >  }
> >  
> > +impl<T> DynamicPerCpu<T> {
> > +    /// Gets the allocation backing this per-CPU variable.
> > +    pub(crate) fn alloc(&self) -> &Arc<PerCpuAllocation<T>> {
> > +        // SAFETY: This type's invariant ensures that `self.alloc` is `Some`.
> > +        unsafe { self.alloc.as_ref().unwrap_unchecked() }
> > +    }
> > +}
> > +
> >  impl<T> PerCpu<T> for DynamicPerCpu<T> {
> >      unsafe fn get_mut(&mut self, guard: CpuGuard) -> PerCpuToken<'_, T> {
> >          // SAFETY:
> > diff --git a/rust/kernel/percpu/numeric.rs b/rust/kernel/percpu/numeric.rs
> > new file mode 100644
> > index 000000000000..13b4ab4a794d
> > --- /dev/null
> > +++ b/rust/kernel/percpu/numeric.rs
> > @@ -0,0 +1,138 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +//! Pin-hole optimizations for [`PerCpu<T>`] where T is a numeric type.
> > +
> > +use super::*;
> > +use core::arch::asm;
> > +
> > +/// Represents a per-CPU variable that can be manipulated with machine-intrinsic numeric
> > +/// operations.
> > +pub struct PerCpuNumeric<'a, T> {
> > +    // INVARIANT: `ptr.0` is a valid offset into the per-CPU area and is initialized on all CPUs
> > +    // (since we don't have a CPU guard, we have to be pessimistic and assume we could be on any
> > +    // CPU).
> > +    ptr: &'a PerCpuPtr<T>,
> > +}
> > +
> > +macro_rules! impl_ops {
> > +    ($ty:ty, $reg:tt) => {
> > +        impl DynamicPerCpu<$ty> {
> > +            /// Returns a [`PerCpuNumeric`] that can be used to manipulate the underlying per-CPU
> > +            /// variable.
> > +            #[inline]
> > +            pub fn num(&mut self) -> PerCpuNumeric<'_, $ty> {
> > +                // The invariant is satisfied because `DynamicPerCpu`'s invariant guarantees that
> > +                // this pointer is valid and initialized on all CPUs.
> > +                PerCpuNumeric { ptr: &self.alloc().0 }
> > +            }
> > +        }
> > +        impl StaticPerCpu<$ty> {
> > +            /// Returns a [`PerCpuNumeric`] that can be used to manipulate the underlying per-CPU
> > +            /// variable.
> > +            #[inline]
> > +            pub fn num(&mut self) -> PerCpuNumeric<'_, $ty> {
> > +                // The invariant is satisfied because `StaticPerCpu`'s invariant guarantees that
> > +                // this pointer is valid and initialized on all CPUs.
> > +                PerCpuNumeric { ptr: &self.0 }
> > +            }
> > +        }
> > +
> > +        impl PerCpuNumeric<'_, $ty> {
> > +            /// Adds `rhs` to the per-CPU variable.
> > +            #[inline]
> > +            pub fn add(&mut self, rhs: $ty) {
> > +                // SAFETY: `self.ptr.0` is a valid offset into the per-CPU area (i.e., valid as a
> > +                // pointer relative to the `gs` segment register) by the invariants of this type.
> > +                unsafe {
> > +                    asm!(
> > +                        concat!("add gs:[{off}], {val:", $reg, "}"),
> > +                        off = in(reg) self.ptr.0.cast::<$ty>(),
> > +                        val = in(reg) rhs,
> 
> So, every user of .add() now will be only compilable against x86_64? 
> I don't think it's right. Can you make it in a more convenient way:
> implement a generic version, and then an x86_64-optimized.
> 
> How bad the generic x86_64 version looks comparing to the optimized
> one?

Currently, all of `mod percpu` is behind `#[cfg(X86_64)]`, so usage of
per-CPU variables in general is only compatible against x86_64.

I believe a generic implementation would require implicitly creating a
`CpuGuard` since in general you require two steps: computing the pointer
to the per-CPU variable's slot in the current CPU's area and actually
doing the write. On x86_64 we can get around this because segment
register relative writes let us combine these two ops into one
instruction which can't be torn across CPUs. But in the general case you
could have the task get preempted between those two operations and end
up with a data race.

As I understand it, x86 is the only arch where this is possible, so even
once `mod percpu` supports more architectures, I think it'd still make
some sense to have `PerCpuNumeric` specifically be x86 exclusive. This
means that the user must always explicitly disable preemption rather
than having a `PerCpuNumeric` type that sometimes does and sometimes
doesn't.

Thanks,
Mitchell

> Thanks,
> Yury
> 
> > +                    );
> > +                }
> > +            }
> > +        }
> > +        impl PerCpuNumeric<'_, $ty> {
> > +            /// Subtracts `rhs` from the per-CPU variable.
> > +            #[inline]
> > +            pub fn sub(&mut self, rhs: $ty) {
> > +                // SAFETY: `self.ptr.0` is a valid offset into the per-CPU area (i.e., valid as a
> > +                // pointer relative to the `gs` segment register) by the invariants of this type.
> > +                unsafe {
> > +                    asm!(
> > +                        concat!("sub gs:[{off}], {val:", $reg, "}"),
> > +                        off = in(reg) self.ptr.0.cast::<$ty>(),
> > +                        val = in(reg) rhs,
> > +                    );
> > +                }
> > +            }
> > +        }
> > +    };
> > +}
> > +
> > +macro_rules! impl_ops_byte {
> > +    ($ty:ty) => {
> > +        impl DynamicPerCpu<$ty> {
> > +            /// Returns a [`PerCpuNumeric`] that can be used to manipulate the underlying per-CPU
> > +            /// variable.
> > +            #[inline]
> > +            pub fn num(&mut self) -> PerCpuNumeric<'_, $ty> {
> > +                // The invariant is satisfied because `DynamicPerCpu`'s invariant guarantees that
> > +                // this pointer is valid and initialized on all CPUs.
> > +                PerCpuNumeric { ptr: &self.alloc().0 }
> > +            }
> > +        }
> > +        impl StaticPerCpu<$ty> {
> > +            /// Returns a [`PerCpuNumeric`] that can be used to manipulate the underlying per-CPU
> > +            /// variable.
> > +            #[inline]
> > +            pub fn num(&mut self) -> PerCpuNumeric<'_, $ty> {
> > +                // The invariant is satisfied because `StaticPerCpu`'s invariant guarantees that
> > +                // this pointer is valid and initialized on all CPUs.
> > +                PerCpuNumeric { ptr: &self.0 }
> > +            }
> > +        }
> > +
> > +        impl PerCpuNumeric<'_, $ty> {
> > +            /// Adds `rhs` to the per-CPU variable.
> > +            #[inline]
> > +            pub fn add(&mut self, rhs: $ty) {
> > +                // SAFETY: `self.ptr.0` is a valid offset into the per-CPU area (i.e., valid as a
> > +                // pointer relative to the `gs` segment register) by the invariants of this type.
> > +                unsafe {
> > +                    asm!(
> > +                        "add gs:[{off}], {val}",
> > +                        off = in(reg) self.ptr.0.cast::<$ty>(),
> > +                        val = in(reg_byte) rhs,
> > +                    );
> > +                }
> > +            }
> > +        }
> > +        impl PerCpuNumeric<'_, $ty> {
> > +            /// Subtracts `rhs` from the per-CPU variable.
> > +            #[inline]
> > +            pub fn sub(&mut self, rhs: $ty) {
> > +                // SAFETY: `self.ptr.0` is a valid offset into the per-CPU area (i.e., valid as a
> > +                // pointer relative to the `gs` segment register) by the invariants of this type.
> > +                unsafe {
> > +                    asm!(
> > +                        "sub gs:[{off}], {val}",
> > +                        off = in(reg) self.ptr.0.cast::<$ty>(),
> > +                        val = in(reg_byte) rhs,
> > +                    );
> > +                }
> > +            }
> > +        }
> > +    };
> > +}
> > +
> > +impl_ops_byte!(i8);
> > +impl_ops!(i16, "x");
> > +impl_ops!(i32, "e");
> > +impl_ops!(i64, "r");
> > +impl_ops!(isize, "r");
> > +
> > +impl_ops_byte!(u8);
> > +impl_ops!(u16, "x");
> > +impl_ops!(u32, "e");
> > +impl_ops!(u64, "r");
> > +impl_ops!(usize, "r");
> > diff --git a/samples/rust/rust_percpu.rs b/samples/rust/rust_percpu.rs
> > index 5adb30509bd4..90f5debd3c7a 100644
> > --- a/samples/rust/rust_percpu.rs
> > +++ b/samples/rust/rust_percpu.rs
> > @@ -28,6 +28,26 @@
> >  define_per_cpu!(UPERCPU: u64 = 0);
> >  define_per_cpu!(CHECKED: RefCell<u64> = RefCell::new(0));
> >  
> > +macro_rules! make_optimization_test {
> > +    ($ty:ty) => {
> > +        let mut test: DynamicPerCpu<$ty> = DynamicPerCpu::new_zero(GFP_KERNEL).unwrap();
> > +        {
> > +            let _guard = CpuGuard::new();
> > +            // SAFETY: No other usage of `test`
> > +            unsafe { test.get_mut(CpuGuard::new()) }.with(|val: &mut $ty| *val = 10);
> > +            test.num().add(1);
> > +            // SAFETY: No other usage of `test`
> > +            unsafe { test.get_mut(CpuGuard::new()) }.with(|val: &mut $ty| assert_eq!(*val, 11));
> > +            test.num().add(10);
> > +            // SAFETY: No other usage of `test`
> > +            unsafe { test.get_mut(CpuGuard::new()) }.with(|val: &mut $ty| assert_eq!(*val, 21));
> > +            test.num().sub(5);
> > +            // SAFETY: No other usage of `test`
> > +            unsafe { test.get_mut(CpuGuard::new()) }.with(|val: &mut $ty| assert_eq!(*val, 16));
> > +        }
> > +    };
> > +}
> > +
> >  impl kernel::Module for PerCpuMod {
> >      fn init(_module: &'static ThisModule) -> Result<Self, Error> {
> >          pr_info!("rust percpu test start\n");
> > @@ -228,6 +248,22 @@ fn init(_module: &'static ThisModule) -> Result<Self, Error> {
> >  
> >          pr_info!("rust dynamic percpu test done\n");
> >  
> > +        pr_info!("rust numeric optimizations test start\n");
> > +
> > +        make_optimization_test!(u8);
> > +        make_optimization_test!(u16);
> > +        make_optimization_test!(u32);
> > +        make_optimization_test!(u64);
> > +        make_optimization_test!(usize);
> > +
> > +        make_optimization_test!(i8);
> > +        make_optimization_test!(i16);
> > +        make_optimization_test!(i32);
> > +        make_optimization_test!(i64);
> > +        make_optimization_test!(isize);
> > +
> > +        pr_info!("rust numeric optimizations test done\n");
> > +
> >          // Return Err to unload the module
> >          Result::Err(EINVAL)
> >      }
> > 
> > -- 
> > 2.34.1

