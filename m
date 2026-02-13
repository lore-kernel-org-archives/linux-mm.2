Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5318DEDF17E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 17:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A5C16B0005; Fri, 13 Feb 2026 12:44:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35D226B0088; Fri, 13 Feb 2026 12:44:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27FE36B008A; Fri, 13 Feb 2026 12:44:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 18A816B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 12:44:25 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C1C6F1A0597
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 17:44:24 +0000 (UTC)
X-FDA: 84440157648.10.67E5271
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id E358A18000C
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 17:44:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LaS2/9Ic";
	spf=pass (imf24.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771004663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JfZF8yFfLEMChIGqgt8V9wY7EmtxYgXu9da0OYbroCg=;
	b=V8OG3zOLgPxW9/nDzOosiAH5eoLHZRddOhjgWLvbgp6Eh26xm3CDmgUFuUrfF3TkvjRJrh
	IykS7N8dSTrjQDErj9zGTFhavo42VPAqgjr8WktBDTwPZ/HNs62kh700HhXUyg4cvPi/pR
	XFX/y77AIMQam8vhxkprfQZYbuppsn0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LaS2/9Ic";
	spf=pass (imf24.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771004663; a=rsa-sha256;
	cv=none;
	b=cau2umSUb4ke6zk1S1Rn6gMlNa8YRxbhYcZqAznOAXIUJSCy1IsoMcpwKFYgrAqIfznvr7
	dCovjxqAfywxkl+n/XVr2L2VVSD04oMAxaGCHVsLtw1sL+JtWbQ0aw5IcMMAkVqMmYVfsR
	fC3hq3I+MEPYNPVp0zWjdNI2vUoRNJk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B5192444DE;
	Fri, 13 Feb 2026 17:44:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8BA3C19421;
	Fri, 13 Feb 2026 17:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771004661;
	bh=VFAXBTc9oMi96YIx20U30QjLHc0sOwJECYK1drWpRwc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LaS2/9IcMxORLFUlVKygMy56493bI1Pi4wJrtuIkhi88GoLv6tkmTf0kGD3uGWws5
	 /7J5UIBCPUeCduHJP7pGIu0hYk29mHeRqyo/POd69rSlmduHZ33rVMhY35K8HpcpTh
	 tO8dMQMwcJpIrb6zy+Bcbyg4Ar4x9mqfLdP8uQAO3KwJ5/ONQ0IGKSz55KfYPq5Sqx
	 kwX0b+yWmeC3JJ8MJTRoTSttMgbVzmyqtSbp8E1tFsuPL4pBoYx4zvYJVr2yNLhdFD
	 b26RyHrpf34jFa/8TFsvfWvp2Bfh012M/BGSbG12Kzgg2wgn307qWHPwXr1wumo3am
	 mO/474VtBpldQ==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 0C334F4006A;
	Fri, 13 Feb 2026 12:44:20 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Fri, 13 Feb 2026 12:44:20 -0500
X-ME-Sender: <xms:82KPackIExudVHz6pkLUWeYWNLJR1NNYzarjIn94YFbKy3CCFSKnKA>
    <xme:82KPaXwSkFH1lToFfOT1YwX4vG8RmZLwXZgFQLtOV5qPbNcfzoN9VHqnoIoAdmAjM
    lEGehJoOyo6vYlNZYEhkZNN54603o-X8Ur2FiMiyX7tSith5xb4UQ>
X-ME-Received: <xmr:82KPaQzjJICnlZsLQAQ0_vn17zC2k_dmfowuc7Y9r4nywClm36bQuCPFaORxvGc3fLgJdSw90uknnmKkxpM_JVdmZMMhmR1D>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvtdekkeekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhunhcu
    hfgvnhhguceosghoqhhunheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpe
    ekgffhhfeuheelhfekteeuffejveetjeefffettedtteegfefftdduteduudfgleenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnod
    hmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdelkeegjeduqddujeej
    keehheehvddqsghoqhhunheppehkvghrnhgvlhdrohhrghesfhhigihmvgdrnhgrmhgvpd
    hnsggprhgtphhtthhopedukedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprgdr
    hhhinhgusghorhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrlhhitggvrhihhh
    hlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghs
    sehorhgrtghlvgdrtghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrg
    gtlhgvrdgtohhmpdhrtghpthhtohepohhjvggurgeskhgvrhhnvghlrdhorhhgpdhrtghp
    thhtohepsghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmpdhrtghpthhtohepghgrrh
    ihsehgrghrhihguhhordhnvghtpdhrtghpthhtohepsghjohhrnhefpghghhesphhrohht
    ohhnmhgrihhlrdgtohhmpdhrtghpthhtoheplhhoshhsihhnsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:82KPae9MZ40FRtc5HKBI4BT7ebR80YEUDyuMucTplEURhImS28IabQ>
    <xmx:82KPaY8uLj_G-SSHzudcdbz1c5U_gMBzmoX0l6ffQzc8Oz9touUFSQ>
    <xmx:82KPaZfoeu8g5YrXZubihdOaFBha1l_j8Wt9tjWlfiu4cw1Vtaj4mQ>
    <xmx:82KPacvRHwxQ-44xaDEJrYl1YYqGtq5MExIHpwHL3-A-WIy0vqz_Vg>
    <xmx:9GKPaa1MR5PAaeY8OxIzmLE8aGXsB3BGGBNaIHOs-nplD-R80MPL7pp0>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Feb 2026 12:44:19 -0500 (EST)
Date: Fri, 13 Feb 2026 09:44:18 -0800
From: Boqun Feng <boqun@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rust: page: add byte-wise atomic memory copy methods
Message-ID: <aY9i8rbvnxdOA9DV@tardis.local>
References: <20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: E358A18000C
X-Rspamd-Server: rspam07
X-Stat-Signature: nncir1znx4c677tyuiwbwctujg3uwby7
X-HE-Tag: 1771004662-360153
X-HE-Meta: U2FsdGVkX186VwdwU0EC8KMOGMNbXWVbNL070XBRt/bb+E6v192XmE4/6SdBOsjWMIft99vLWx3UByW4xakHLaAbWDSau4d6fHeWLsaPx3KJ3dtgvU1oFtILmRcBLpEuVe9NB1vbpgaOiAlI5BK+pxQt81DWpMHSad0owCCumslCNLKNDETi3RdaUFOjcP/TaJmJfNGm27jy9XJDyaJvHF9E3ckRTVtbmIuB8y/31KO4bjRZEw2j6E92LOm7jZkkkrdsDaV78CS+Rn2VmlrfCZCnbEKolSr/RN7oescmouwJRWbfIpfdaGovW6LRUIBtIp6V1hCd350sRV+PNNf7m2Im/X5z6hXqCttgCVxiB9Z8ts4IlqTLalgEl1v1Be1Ws6Jjmh0P/pc3U7bjcT2EeCdYgDmd0S2SjOKf+l6yEWApDFm/xPYpl5RBrdssKaPK32yJeYipcuTiy3fnkDbMTbvUNBDOnAUqhYhzicYyR3kEs2WptJGOtkajAhYgef3QfMOkrGGX9b4YLMcCfogkKQk/RAEUVTchtwOQawPTc5U92xTlqxpM9Y3KfRDHsGxaWpIK2/a/iUQSTxgKCX2X+G7KC6uorEd3OIjeg1jyYvUv5EG4kLQPfJTWXThEwOs/WxkRF2EPc2uQgoJDR3bRajj+RrlMThn5Ug5wNuhPD2NRNDMcBKGtpjqMZNQ6N47EFEduW3sxovQYxj8LU5m0dYGWf+Q/8uZO+tHcqY8Ai2uGnb7N1Ws0/EBkNvcrVm3WX59nmv4qV/nOqKxIQvAIg1OyMuiBzeG3byc8bT8M3xF6YHpX78j1+lj99oxe1GVkZf2BxG5f2xOX7U4qpqYGD/WhV4HsTqEFwOEEzIwX1hmOBLtp+2NrVSrfxiihU33tJr9wwv/WukdyRZXWOY4xM4XkDrIyRN1PDBzYWTMGoHu/BjVvPZAeQRM14cZx0p8hQIg6Aije4pchsBKjxMA
 egw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 07:42:53AM +0100, Andreas Hindborg wrote:
[...]
> diff --git a/rust/kernel/sync/atomic.rs b/rust/kernel/sync/atomic.rs
> index 4aebeacb961a2..8ab20126a88cf 100644
> --- a/rust/kernel/sync/atomic.rs
> +++ b/rust/kernel/sync/atomic.rs
> @@ -560,3 +560,35 @@ pub fn fetch_add<Rhs, Ordering: ordering::Ordering>(&self, v: Rhs, _: Ordering)
>          unsafe { from_repr(ret) }
>      }
>  }
> +
> +/// Copy `len` bytes from `src` to `dst` using byte-wise atomic operations.
> +///

Given Greg and Peter's feedback, I think it's better to call out why we
need `atomic_per_byte_memcpy()` and why we use bindings::memcpy() to
implement it. How about a paragraph as follow:

/// This is the concurrent-safe version of `core::ptr::copy()` (the
/// counterpart of standard C's `memcpy()`). Because of the atomicity at
/// byte level, when racing with another concurrent atomic access (or
/// a normal read races with an atomic read) or an external access (from
/// DMA or userspace), the behavior of this function is defined:
/// copying memory at the (at least) byte granularity.
///
/// Implementation note: it's currently implemented by kernel's
/// `memcpy()`, because kernel's `memcpy()` is implemented in a way that
/// byte-wise atomic memory load/store instructions are used.

And probably we make it a separate patch for this
atomic_per_byte_memcpy().

Thoughts?

Regards,
Boqun

> +/// This copy operation is volatile.
> +///
> +/// # Safety
> +///
> +/// Callers must ensure that:
> +///
> +/// - `src` is valid for reads for `len` bytes for the duration of the call.
> +/// - `dst` is valid for writes for `len` bytes for the duration of the call.
> +/// - For the duration of the call, other accesses to the areas described by `src`, `dst` and `len`,
> +///   must not cause data races (defined by [`LKMM`]) against atomic operations executed by this
> +///   function. Note that if all other accesses are atomic, then this safety requirement is
> +///   trivially fulfilled.
> +///
> +/// [`LKMM`]: srctree/tools/memory-model
> +pub unsafe fn atomic_per_byte_memcpy(src: *const u8, dst: *mut u8, len: usize) {
> +    // SAFETY: By the safety requirements of this function, the following operation will not:
> +    //  - Trap.
> +    //  - Invalidate any reference invariants.
> +    //  - Race with any operation by the Rust AM, as `bindings::memcpy` is a byte-wise atomic
> +    //    operation and all operations by the Rust AM to the involved memory areas use byte-wise
> +    //    atomic semantics.
> +    unsafe {
> +        bindings::memcpy(
> +            dst.cast::<kernel::ffi::c_void>(),
> +            src.cast::<kernel::ffi::c_void>(),
> +            len,
> +        )
> +    };
> +}
> 
> ---
> base-commit: 63804fed149a6750ffd28610c5c1c98cce6bd377
> change-id: 20260130-page-volatile-io-05ff595507d3
> 
> Best regards,
> -- 
> Andreas Hindborg <a.hindborg@kernel.org>
> 
> 

