Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11693CCF9F8
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 00:27:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F1D78E0009; Fri,  7 Nov 2025 19:27:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C87A8E0006; Fri,  7 Nov 2025 19:27:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 505A48E0009; Fri,  7 Nov 2025 19:27:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 43B898E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 19:27:29 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CBD6F1A064B
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 00:27:28 +0000 (UTC)
X-FDA: 84085550976.17.BA0F024
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf16.hostedemail.com (Postfix) with ESMTP id E109B180009
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 00:27:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PZvLmhRs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762561647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oITIVQgMr73mFnSfBGd/HefCrTD9E8UlLjNjhfP/oZE=;
	b=GsmCNY7s63knFly2hlzkuwGDNJc2MVZccKWId7qHWEdUIE0sqeGnDQtOd3wlN9KT1YvLp9
	yiousV0gi8AUrKISdUxvguB+L2I/6yfakUUUWtLX08pfaNYIEsSTRIYeDWYBCKGSSePDnC
	sIZwJhwZHkbPldN4iehayJZ2bln7d9Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762561647; a=rsa-sha256;
	cv=none;
	b=r7QppVXW1rQdKeG1x5DYURxmsROiAOrKZrgjdai6Hrqv1/WHubX4PqlFKhiOPwTXTALeRy
	N9ck9xHj87SK/k4iWaq3IPXZGhkFXjHEUBadLdABK8+dItETv5gmCf99uxmVNhTv8NMXhx
	OD8lSXRHTqa65kTmHUp1hz7CzOzJ1Ak=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PZvLmhRs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-29470bc80ceso13991015ad.1
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 16:27:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762561646; x=1763166446; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=oITIVQgMr73mFnSfBGd/HefCrTD9E8UlLjNjhfP/oZE=;
        b=PZvLmhRsSj5tLczBk97diLuAcuuOkNamt8GcvXal/+pp/EFWxJ/tYdVpsk7/b+GYW5
         ByBjXpweg1nF5Dw0MDLKjqeHfUhmJGea+eO2uh/jaZC8UyLz4h0k70w7w/j8u+od5rwH
         B/B+O95AnAMhgkI0ywx5rSXjDj80qlQ4vEk83nrjOpvd/OAn1J0RAk72zy3jrixjO/ZY
         bUgJac5zspZs+Gs4tNql7tmu+PI5pgY3zpWnUhFrCaWyxbz9BLjO/BjWWjfLKwwiCgy7
         za8d7CVbVtAoRuYzs9IS3sJA2ucX9sm5WMH13FYSBFsaEQ9vGmUT4B7ejzYFV5zZzEYF
         L0KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762561646; x=1763166446;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oITIVQgMr73mFnSfBGd/HefCrTD9E8UlLjNjhfP/oZE=;
        b=dOIX4duPC3zu6K64r2FRetXMSSPogY2ENT/xxTEW7tfkJV3T8TMl9H9c/dqRSY1OZy
         wp3VZZ7/X0RwKk+FgKRTAoOD6wWX4749NrON/apX78r1BednucQlg7AMjAkNMegJBbRd
         cnIQ7qTRbiHd9yQTXzlE/s3tD4NyHBgqUR0o+1d4NslvUVgvnRwega/9cSz1NUE53GLR
         0+HzMgS9U9uDnLSohzQtvqkPXYkEqC/KIp3agWxA20tMLiMiRwlVTc7Xw9nblTsTWWVQ
         Y+eaIFnwN3afRkbrTE3HlnGLrNCyKd7cm6p0Iw3JaaGlHFwhOIP9+F3O0nIIB1dzEssC
         7+TA==
X-Forwarded-Encrypted: i=1; AJvYcCWGWhkaNvn4TFmjN4SobdaGyI7REF6JJBIxMKu47pCyPXq4MbsvlVdX754JchvUnvfJE/f9T41RGA==@kvack.org
X-Gm-Message-State: AOJu0Yzjg1PNv6oAFJJo4QtJd9ltx+iLu+8TgBA75ufMuQB+QafkBYfr
	MSLibC+hKuj63f2FhiMy3hIN/NhEn0aHNXBaCiz5fa0Wqv30EI9mLKtf
X-Gm-Gg: ASbGnctlBSD0DsCtXaBlV0fMzgni9ai/r+D9vWVbOFL4c+di50V6S35zaVJ3mC3T/N0
	DH3CTxQwUl32dceQTAj74BnEm4FIBp7aH2HhdrH3zUFygUa7dFMmOK7CboT7QAQb8dXj+ReUN39
	Z/CdF7hWMl6Ysk+JAvXkH6a3nD3UeXLr+gm3mfSAg3UcdL1b7OlLGVGVlBEbwjJAw6+N36NHheC
	SM219AhOjoyonPT3n+UYR3Xvc/LYRJ2x3/wb4Vs2fPNvsU7JDz/gjI3LaruLan4opHUDb2g28ne
	UZXGlMnAhpJ+wDM8salVDMbUoYUgg67yZqelY4fUNXhutaE5CvjMDl/KIi/3d19ZQqoVewvcPI3
	XLUzk1aXBKBkxltZTFMpbnJv1+xBDseW+QFyZosC6vOwOtGJAMOYR57itedEVmMdfhZ7cevmJ6u
	ffzpHn/URQPhCOn1A=
X-Google-Smtp-Source: AGHT+IGBkvZLAhvDKdrvXHQG3c3w7IqpLjYOFlvAQCWtRpkM1DWxhdW7r8G7DO/y1DZ2Fmaan/pCUg==
X-Received: by 2002:a17:902:cf0b:b0:290:ad7a:bb50 with SMTP id d9443c01a7336-297c96a5cd5mr39554295ad.27.1762561645531;
        Fri, 07 Nov 2025 16:27:25 -0800 (PST)
Received: from Cyndaquil. ([174.127.224.194])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bad33c80393sm2734157a12.4.2025.11.07.16.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 16:27:25 -0800 (PST)
Message-ID: <690e8e6d.050a0220.b06fd.d2ec@mx.google.com>
X-Google-Original-Message-ID: <aQ6Oay2rcmaQLDup@Cyndaquil.>
Date: Fri, 7 Nov 2025 16:27:23 -0800
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
	Tyler Hicks <code@tyhicks.com>,
	Allen Pais <apais@linux.microsoft.com>,
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 2/9] rust: cpumask: Add getters for globally defined
 cpumasks
References: <20251105-rust-percpu-v4-0-984b1470adcb@gmail.com>
 <20251105-rust-percpu-v4-2-984b1470adcb@gmail.com>
 <aQ1DAn7Djc19CgGF@yury>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQ1DAn7Djc19CgGF@yury>
X-Stat-Signature: 7oytnnma99s6xfextfbq85e4fs9pyy8o
X-Rspam-User: 
X-Rspamd-Queue-Id: E109B180009
X-Rspamd-Server: rspam10
X-HE-Tag: 1762561646-987434
X-HE-Meta: U2FsdGVkX19V64Q/Q+MJPkK6ChwV61s+Sjs6o5nNuLEvR3rQekVNtokiSOimZSqvJxcjwC/8UeRQYykhNkBANSbIE0/qG57Prc3g4IIZaALAUxs8CnGTdjK7iCLklzvHIKJc05TN0I1bjgAmwbwPI6AAu0VNhqX6PL4/x+YFRm9XyMp9TGwTCcuUzVbQyTfKWvnOF3T3FRXuI2cQISLZ8j8Y3CdlveUoSqbrZmm2U0jFhK3b/Zca27m/MZ8v4gdlDDRtB3tGhrOa4CmCPQACKK5Fo+piuDo1t3y3qWdyv2ewUE9yMl7rISzNReQIagrFZU7+hReLC2VSuWkv8ceqyd4hg7NOaMMytZRU6dQdVMuQypt1+2hN36+CeodtDkLL6/medQxxDM6JyN19mcA2l/23/idv9oqBfwEcTWahO2LmhNdBSXokUPn1NTdSVZ52x+ZXfZ4UqgSB3WtUumKHA5tx+dNHot6PKM6iSvS4KaFIiSeJDWmV+oUVaRKNC/ZfwBvRbj8u/4bmC4FEaWXN2YTAGSsAZOzV+UNTwb1QTvaZjlOnyuvAm2qGDtNeHo94SIshH9OKNSynQX4PgjulGqYA9pRQmgUJna67Mh0OJxV2bhZV6tYPAP+aAI4UVMB8iNfiqNBUMckFYLtQZL6dN/NCsdMgCV0Z0pimjVyfCaUUPRHFkYkXzP2WO7/5U9Lg1mS51d3Xa3VGKFB2nawfH7zoY1O0uliG+xiNXiA3NWfYQZ43l+QHthMXkOj5qoh+lrlbZPvtF5f77SnFsHrVjlgEq4b0sBjwfHi/p/yke9EtobFxK+Vsv5t1zyTSagQQA8k+jtxLRwVBFh2V/2jTG2O1vb+H541ELPKAlf81XaZtceL+g6s0gHxRwg7HNF2BbYr0DmrwgrYQKNjJ9wsToB4xmny0SC94SUXolB2ec983v+NXXAOV/65qOT95DDSWKaUV20ZGrRwKYPYd0Ie
 ecLjB+LD
 RACPs+WOx27aSw6ZXGCvaVMDTx0OuTx8UHL3vUfSIavxasweMBNIlCo9mtNc3csy1VgaaK9wwHMC5WwGny7hVrgl5mDtL8QsDgcmKxOuOeP4i0os3MxyZuDIurFZZl9o9AEv6DpDMsI+mBsTwliRr53H9HWslBgvSsrnr3tJV5Qyuy0o6QoRa/I3OTY/ZgWJHFupFS96j4E1F1wY4e3CRvsWOFAFn6uv7W1GzP5snbchQ9yQH+8qvKx1N/AIc5ueN4pFtHdZcl7KCwlwJro0AO44k55IW78da1Yuf6HS4dgwBmC7miapq7ToGKEmTIi/ghem98nPUT5AtqjRrO98178NZ57lBJoY4/qWLsWuay1NJvScPwjTR4Dn/gufMME22UWAFJtbo4ZangjU/phOIY+7fTiD8dzhxEJJJBrSHkpHs8dk5Begg4OMvQzmTGGEc4YZRmscd3LnXuNFY9Ci4JhrfIjb1BykR3MNe/SGVxNxOwzuhLMK4Ze6EVFaFZeyZmJ0sebXTKBUxJVkOWH5a59AfAMbpbJn7F+KSIL0Dqg8x2KI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 07:53:22PM -0500, Yury Norov wrote:
> On Wed, Nov 05, 2025 at 03:01:14PM -0800, Mitchell Levy wrote:
> > Add getters for the global cpumasks documented in
> > `include/linux/cpumask.h`, specifically:
> > - cpu_possible_mask
> > - cpu_online_mask
> > - cpu_enabled_mask
> > - cpu_present_mask
> > - cpu_active_mask
> > 
> > Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> > Suggested-by: Yury Norov <yury.norov@gmail.com>
> > Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
> > ---
> >  rust/kernel/cpumask.rs | 46 ++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 46 insertions(+)
> > 
> > diff --git a/rust/kernel/cpumask.rs b/rust/kernel/cpumask.rs
> > index b7401848f59e..a6a130092fcb 100644
> > --- a/rust/kernel/cpumask.rs
> > +++ b/rust/kernel/cpumask.rs
> > @@ -77,6 +77,52 @@ pub unsafe fn as_ref<'a>(ptr: *const bindings::cpumask) -> &'a Self {
> >          unsafe { &*ptr.cast() }
> >      }
> >  
> > +    /// Get a CPU mask representing possible CPUs; has bit `cpu` set iff cpu is populatable
> > +    #[inline]
> > +    pub fn possible_cpus() -> &'static Self {
> > +        // SAFETY: `__cpu_possible_mask` is a valid global provided by the kernel that lives
> > +        // forever.
> > +        unsafe { Cpumask::as_ref(&raw const bindings::__cpu_possible_mask) }
> > +    }
> 
> Not sure about this '&raw const' syntax, but I want to make sure that
> all this getters provide non-modifiable references. To modify any of
> those masks, one has to call a dedicated helper like set_cpu_possible().

For `id: T`, the syntax `&raw const id` produces a `*const T` pointing
at `id` (the analogous syntax `&raw mut id` produces a `*mut T`).

All getters here provide const references (`&'static Self` as opposed to
`&'static mut Self`) which will cause the compiler to prevent usage of
any `Cpumask` methods with a `&mut self` reciever (i.e., methods that
change the `Cpumask`).

> Can you maybe explicitly mention it in the comments?

The compiler will prevent using these values to change the underlying
`__cpu_possible_mask` etc, so mentioning that these return values can't
be used for that purpose seems redundant to me.

It is possible someone could get the pointer out via `Cpumask::as_raw`,
and then do something bad with that pointer, but this isn't any
different than someone doing something bad with
`bindings::__cpu_possible_mask`.

Thanks,
Mitchell

> With that,
> 
> Acked-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
> 
> > +    /// Get a CPU mask representing online CPUs; has bit `cpu` set iff cpu available to the
> > +    /// scheduler
> > +    #[inline]
> > +    pub fn online_cpus() -> &'static Self {
> > +        // SAFETY: `__cpu_online_mask` is a valid global provided by the kernel that lives forever.
> > +        // Since we wrap the returned pointer in an `Opaque`, it's ok that `__cpu_online_mask`
> > +        // may change its value.
> > +        unsafe { Cpumask::as_ref(&raw const bindings::__cpu_online_mask) }
> > +    }
> > +
> > +    /// Get a CPU mask representing enabled CPUs; has bit `cpu` set iff cpu can be brought online
> > +    #[inline]
> > +    pub fn enabled_cpus() -> &'static Self {
> > +        // SAFETY: `__cpu_enabled_mask` is a valid global provided by the kernel that lives forever.
> > +        // Since we wrap the returned pointer in an `Opaque`, it's ok that `__cpu_enabled_mask`
> > +        // may change its value.
> > +        unsafe { Cpumask::as_ref(&raw const bindings::__cpu_enabled_mask) }
> > +    }
> > +
> > +    /// Get a CPU mask representing present CPUs; has bit `cpu` set iff cpu is populated
> > +    #[inline]
> > +    pub fn present_cpus() -> &'static Self {
> > +        // SAFETY: `__cpu_present_mask` is a valid global provided by the kernel that lives
> > +        // forever. Since we wrap the returned pointer in an `Opaque`, it's ok that
> > +        // `__cpu_present_mask` may change its value.
> > +        unsafe { Cpumask::as_ref(&raw const bindings::__cpu_present_mask) }
> > +    }
> > +
> > +    /// Get a CPU mask representing active CPUs; has bit `cpu` set iff cpu is available to
> > +    /// migration.
> > +    #[inline]
> > +    pub fn active_cpus() -> &'static Self {
> > +        // SAFETY: `__cpu_active_mask` is a valid global provided by the kernel that lives forever.
> > +        // Since we wrap the returned pointer in an `Opaque`, it's ok that `__cpu_active_mask`
> > +        // may change its value.
> > +        unsafe { Cpumask::as_ref(&raw const bindings::__cpu_active_mask) }
> > +    }
> > +
> >      /// Obtain the raw `struct cpumask` pointer.
> >      pub fn as_raw(&self) -> *mut bindings::cpumask {
> >          let this: *const Self = self;
> > 
> > -- 
> > 2.34.1

