Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D08BCE8D44
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:24:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DB6E8E0026; Fri, 14 Nov 2025 10:24:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B2DD8E0002; Fri, 14 Nov 2025 10:24:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EFC48E0026; Fri, 14 Nov 2025 10:24:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DC9B8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:24:33 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 076561A03F3
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:24:33 +0000 (UTC)
X-FDA: 84109584426.07.D21F407
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5C2AB20002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:24:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DfMf1lEE;
	spf=pass (imf13.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763133871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ic0h3NZMZNIBp6WsmjUb9XT/3fZ/MM2GYrcCUfaAWY=;
	b=ml8vw0hXwjku6s0QNPFHquPRyNSnO6dkDoNECzpzvUDbIU6Red3VWRorUM+YQWHoflAOy1
	C99nZ35hpa9jlG+gQtaykMcll81smAVdtdG57zJdtWvk/imOJ7Bpmt5nnSwHtNIMMihUV2
	5DuiDDiHHjoeRoRLjK2zYuw//IaTaI0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DfMf1lEE;
	spf=pass (imf13.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763133871; a=rsa-sha256;
	cv=none;
	b=j9Dfr9yMIdWmLnakQhXME5JERw3auj4P0uDCSuFaIpCtTPpe++fhrdrvx581k9beYRbV7h
	d8rSB52W/L1P50lr0EHqZjEJ2of2mUSiHvk6KTsj6yIC09l27pzbgYcD94StIgRMtS95Gi
	qQvX6Kh7ICFSPiMJoVtrNARdIu4gKnU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 189D740E51;
	Fri, 14 Nov 2025 15:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B65C116B1;
	Fri, 14 Nov 2025 15:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763133869;
	bh=QBSnPvSO1GNVbt+v4ouKlCcxmuLb1PsUsCj+WCfoziA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=DfMf1lEEs2cqFcQ7RTwcJNZB4afx8bxgA1C+4hrJF1QRTh5F8m4fX2UbUFXOnNrmV
	 DtlzLSCbubbaKxYigDV3/8WZmjOtdrp4ffKdTKPaZEgsb+2PomIQpNnz4OP418GJgF
	 XU0UK8VTHK0p2jusTvvzsA5Lx9YC9zH+Rhk+bOQEOV7DXFfn2HxnaKixAG5YcmMyvZ
	 XD985/x5+9w9KVOou+md6yTNlZJ3/nu1Es1KfAig2rriaYqs3hIREXyuCCPHVtb0Bo
	 JBLH8XAswkzNabET3ueqDRX6gzI5EO/VwpGt8FtT1xe7K5uLO/HmLBzZvsmWHT24Pv
	 dThWV7yWlWedg==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Mitchell Levy <levymitchell0@gmail.com>, Miguel Ojeda
 <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron
 <bjorn3_gh@protonmail.com>, Alice Ryhl <aliceryhl@google.com>, Trevor
 Gross <tmgross@umich.edu>, Andrew Morton <akpm@linux-foundation.org>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph
 Lameter <cl@linux.com>, Danilo Krummrich <dakr@kernel.org>, Benno Lossin
 <lossin@kernel.org>, Yury Norov <yury.norov@gmail.com>, Viresh Kumar
 <viresh.kumar@linaro.org>
Cc: Tyler Hicks <code@tyhicks.com>, Allen Pais <apais@linux.microsoft.com>,
 linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-mm@kvack.org, Mitchell Levy <levymitchell0@gmail.com>
Subject: Re: [PATCH v4 5/9] rust: percpu: introduce a rust API for dynamic
 per-CPU variables
In-Reply-To: <20251105-rust-percpu-v4-5-984b1470adcb@gmail.com>
References: <20251105-rust-percpu-v4-0-984b1470adcb@gmail.com>
 <9HWB8ewzZ5ZFApS4ggvpeoZmA-oRMmwXv2XOy_c_Ck7HkH7QOR0EaFmGnjNTmk22baplRPX3UcbWj9WnXw0r-A==@protonmail.internalid>
 <20251105-rust-percpu-v4-5-984b1470adcb@gmail.com>
Date: Fri, 14 Nov 2025 16:24:16 +0100
Message-ID: <87jyzs3ae7.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5C2AB20002
X-Stat-Signature: piuqkirssq7ceakfm65ad5j11r8g4jh7
X-Rspam-User: 
X-HE-Tag: 1763133871-829270
X-HE-Meta: U2FsdGVkX19SBp+vuy/rEKX5WAJQ6ns8Qr9Sr+VR6ybGxv8aJHDCzXTKUJmEY0XSlGcYAhTtbROEv/y1k9ObZjO/zAAHaDCXYpaX8h8WafrFKR82KOYE50e9oNpyogjRxUcK1X+DfqH8zMD90dgGXie6Gj4sRy/llNbXbuUlglGbRCNqshHO9tHTSn6villZKpku+bwFYzDlcT8413T7zTXdix22yRJKJvloW+qnfaGMdK3uCKmLxaDMxfc6j9wN98UGKex63YIVkLwX8duOKxKKNHKWPBhK6kVeCqdqZ6QSNAV7JBnyX3Nw1aX9kBSiSyUZtyI5TtMIQd9JafgYCrMX6qYebhC3MWoGkRPNnhPlHGhZ8Rkhy44e/QoGmKOz5VQVB3eSypSypsdClcWNwn0TIHKS61bAAZtP/fvFthkoOCZ3CbZlLW8dXDRrHHRRd+uSVDQ+iS1fx04Rm4tObTVBx07BpuPLLzs2d/UZyEI+SXrpUNUVHOqeknEqSplZ8+kxZ5iu3HR7o9WbyzRELptNxA7ztRR8Asi5tnDdUVbRVuZbZCeKFEJsGAgUmjwQHPC4kaDkQN6X2A3HIGu+bsrAkOzeCgCcuCfS5jqzRpe1Kikuce9ybJ/RzfABPm2QucYSVrzX/oQoCeV2kuIwsVMVoXJnOnwNVTbiNnwqtbWKJy+lvN72mYOZbzwHx3cBbH+6VdU7qHT7iCZoZLoOojmCgtvdxqxetM/2vg5vR2ISdcabBTs3QrKzUDGX/V3JNyAiK2uHTwNIVk/x7H/Kosko7KinHieXAnLBVewvaQNH8jCVDYb6YRLC9WsJYYrbgm9AfqU6fw9/gXdH3t5Ymz/y+ykzDemqKf09TU8bMCLbVp0BM6T+eHGdyvoE3QiVzhRPYJzkaV14hGBqYkbP7Th40T3S7MOuii+KOIdxAJALS60scmccRGxDaq8WuCu5t0vhWO7+PKUy6Kwd7R2
 yAeZM0uS
 Ng6WmXW0/RmxhPelXIMIGBmNSMxj8UihtgcBBS7JJ1PXTMcSv4ROHqKu9Ytm5fzjQltkBa6zRsXgZj4uL0aYh1PFGoQIVk+Wj+wHym4izmTGGf6MCqTBcue/1lWF77IugBlILV0C6CHVYRWoOO1ki+XrHAhnmlL+xeiIaqlMCzO5zAF/WAvPokKTOPsKdk5OYpBwc/s7ioucHCzfNMJwvYapoLzvuvbetTBbZK7UGOnU6hTawFJfBGsxj2nYDfQo82HCj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Mitchell Levy" <levymitchell0@gmail.com> writes:

> Dynamically allocated per-CPU variables are core to many of the
> use-cases of per-CPU variables (e.g., ref counting). Add support for
> them using the core `PerCpuPtr<T>` primitive, implementing the
> `PerCpu<T>` trait.
>
> Co-developed-by: Boqun Feng <boqun.feng@gmail.com>
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
> ---
>  rust/helpers/percpu.c         |  10 ++++
>  rust/kernel/percpu.rs         |  30 ++++++++--
>  rust/kernel/percpu/dynamic.rs | 130 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 166 insertions(+), 4 deletions(-)
>
> diff --git a/rust/helpers/percpu.c b/rust/helpers/percpu.c
> index a091389f730f..35656333dfae 100644

<cut>

> diff --git a/rust/kernel/percpu/dynamic.rs b/rust/kernel/percpu/dynamic.rs
> new file mode 100644
> index 000000000000..1863f31a2817
> --- /dev/null
> +++ b/rust/kernel/percpu/dynamic.rs
> @@ -0,0 +1,130 @@
> +// SPDX-License-Identifier: GPL-2.0
> +//! Dynamically allocated per-CPU variables.
> +
> +use super::*;
> +
> +use crate::alloc::Flags;
> +use crate::bindings::{alloc_percpu, free_percpu};
> +use crate::cpumask::Cpumask;
> +use crate::prelude::*;
> +use crate::sync::Arc;
> +use core::mem::{align_of, size_of, MaybeUninit};
> +
> +/// Represents a dynamic allocation of a per-CPU variable via `alloc_percpu`. Calls `free_percpu`
> +/// when dropped.
> +///
> +/// # Contents
> +/// Note that the allocated memory need not be initialized, and this type does not track when/if
> +/// the memory location on any particular CPU has been initialized. This means that it cannot tell
> +/// whether it should drop the *contents* of the allocation when it is dropped. It is up to the
> +/// user to do this via something like [`core::ptr::drop_in_place`].
> +pub struct PerCpuAllocation<T>(PerCpuPtr<T>);
> +
> +impl<T: Zeroable> PerCpuAllocation<T> {
> +    /// Dynamically allocates a space in the per-CPU area suitably sized and aligned to hold a `T`,
> +    /// initially filled with the zero value for `T`.
> +    ///
> +    /// Returns [`None`] under the same circumstances the C function `alloc_percpu` returns `NULL`.
> +    pub fn new_zero() -> Option<PerCpuAllocation<T>> {
> +        let ptr: *mut MaybeUninit<T> =
> +            // SAFETY: No preconditions to call `alloc_percpu`; `MaybeUninit<T>` is
> +            // `#[repr(transparent)]`, so we can cast a `*mut T` to it.
> +            unsafe { alloc_percpu(size_of::<T>(), align_of::<T>()) }.cast();
> +        if ptr.is_null() {
> +            return None;
> +        }
> +
> +        // alloc_percpu returns zero'ed memory
> +        Some(Self(PerCpuPtr::new(ptr)))
> +    }
> +}
> +
> +impl<T> PerCpuAllocation<T> {
> +    /// Makes a per-CPU allocation sized and aligned to hold a `T`.
> +    ///
> +    /// Returns [`None`] under the same circumstances the C function `alloc_percpu` returns `NULL`.
> +    pub fn new_uninit() -> Option<PerCpuAllocation<T>> {
> +        let ptr: *mut MaybeUninit<T> =
> +            // SAFETY: No preconditions to call `alloc_percpu`; `MaybeUninit<T>` is
> +            // `#[repr(transparent)]`, so we can cast a `*mut T` to it.
> +            unsafe { alloc_percpu(size_of::<T>(), align_of::<T>()) }.cast();
> +        if ptr.is_null() {
> +            return None;
> +        }
> +
> +        Some(Self(PerCpuPtr::new(ptr)))
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

Can we place an example here? It was a bit difficult for me to figure
out how to use this from browsing the documentation. Perhaps we can lift
some of the sample out and add it as a documentation example here?


Best regards,
Andreas Hindborg



