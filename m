Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 151EFCA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 19:55:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7294E8E000A; Thu,  4 Sep 2025 15:55:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D9DE8E0006; Thu,  4 Sep 2025 15:55:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C8788E000A; Thu,  4 Sep 2025 15:55:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 45C8D8E0006
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:55:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DFBE685E41
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 19:55:50 +0000 (UTC)
X-FDA: 83852623260.19.7A612D1
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id EF22A18000A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 19:55:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Z/yiSF8j";
	spf=pass (imf24.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757015749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bMvvP6Q6P7dnqKHCgcbrirHcRzQIivzHuvswVHDmhxk=;
	b=oaBpTdcDiepD10H2fAhl2aGq4s43R7C/7Pa14vHqyzMTezlew1sZpCLS2FcSbpxWg5sA/y
	85pZ+mE/7yyqlRnMo0Tmtd+ElyMZvw3jZQBjRqcNcpcG8LsbNp3NUUk+XTiweAjuz/4sRQ
	LHotNaFbVyecbdn6o8nZFfLnKxENVYA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Z/yiSF8j";
	spf=pass (imf24.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757015749; a=rsa-sha256;
	cv=none;
	b=RLW1dMMKvd9OrBjHkk+lq025UYcRffeoBRChBzBzf1yts5qv7HJ/5OBtCG3CQwy9bLvYLP
	mKINy3l+vWyDyyJt/gIT1RJ+TI4jhuGyUP3UB0n7VFuErIk3I7V8oafcg930EA8zlGOMx7
	gWZFbejvgutK9SHbVgL51WhTkbJfc4U=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b4df220483fso927224a12.2
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 12:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757015748; x=1757620548; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=bMvvP6Q6P7dnqKHCgcbrirHcRzQIivzHuvswVHDmhxk=;
        b=Z/yiSF8jVnhbzRndhy1dF6VBIlwb1AxiGSs2BH9/UGqMhDEZxOaUFYIA2al9J9t1vX
         HsUlaccI3Bkn/Ylv54jbhM+ZYLh0yCBuxgj3STh/kwfHJVqeezlwAp8bY3R7350oI0rA
         6UKkPkw4CP7qIk2IwUy4LrCHhh8iFa2qwmBqDAk3S/ndOTFLHcS3muLLr8sxv6DtwV3t
         ie/Ew5VKza0FJhY2A0FfiqZjLAEDst5IdE9cJqTsGLtwke1ugXvcDFtJ4IQPr0uDi8QP
         e6G9NndSMU4gqVizJRscnz9QIUHDj/ETC9QYQDYHRE6z72k9mrX5PtwL6aaT/cF+XUL+
         ktXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757015748; x=1757620548;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bMvvP6Q6P7dnqKHCgcbrirHcRzQIivzHuvswVHDmhxk=;
        b=lA2/X9FoVvFHtMgYefir/crvKOd8jMo87CGS0MuELfxlEe8lgvCBN8CPMRUy6l7Zf5
         NxZIMykdkHNQKU8Box+gz9D9FN1imZupJoI32XpVaYCLzJAtnqw5ZTPxidbUZIeASKO0
         Xt7pbdNmOZCh9sEhhot0KFsvIJqyPZV508T15yawPxz41jHw6LehvCaj4uWrkUllhOpP
         vMU3MlluU6PH2+Y4FcnFngtUdkdZUHOgoQbBkx3alUYSkRo8fFz5YzLXjVR6ZLuyMtml
         WTAegcElvgoAABzUceeUqzXpO0+XBAB3jqO8cn1MRutwzRFqEZannl3UVnhUUjKA6gy3
         tXXA==
X-Forwarded-Encrypted: i=1; AJvYcCWpV5ojbbtGyrGh6MF3CvTG8scHw+TTNQtq8Zrxo/yfYs5IQHzWNyqA49VEgVY7nYqDUkyxJw4Byw==@kvack.org
X-Gm-Message-State: AOJu0YyG4wHQ9uBRH6LLQoBGNqDqhsuyFyfAXgNLt92x3zJLbS1x3T6M
	Q+8H11FoHL90YH8nWgB/5Q9+fyEG+wSKmnzELgSnays8lfB8yNypZQPHhEGo0IkL
X-Gm-Gg: ASbGncv4s+79VLVFsj6iMYeYkacKYiseDkMviBd5/x6lquQ4K6y6tb4iXIIH0MQ3nTb
	cSITD+r4PKACLZ34mZ99TT9/SnWvWWK+FxF/1AJA3Wah08p3/2YVKyVRbz1xDyZEfqym0XecD2N
	xeAjGIunQz4mAWJ9wg2+TrjFnlFiQzJ8cYiY8YmlH00PJATAcLZEPGb98SEJ8awzkYOEgD7tVtN
	Y7W7vMzF9zPxBgQ9rqXKqAnDZOOu+Q0XCagBbAaldeo5ESbx/qA8b02IKhfuK0BXbKXB6/O0Q88
	2mulpygjp6T4fyce/tSuuGUlfij0zpiqFMOYjjIlb6PDs+t8lL9gY2uhDGSRfRIjjgDTNxZENYv
	L+93ACIMUSvoFD9jSbAU/cMZ4RRkWPRZnBXvAWFs82kufCCfy
X-Google-Smtp-Source: AGHT+IHW6f+P8YnMRKWbSCVkVppITDLw8F9XmDLoYK0RMqz7/Up3hPmTP38YZ62HC4D/4i4MyuBATg==
X-Received: by 2002:a17:903:1a67:b0:24c:b83f:c6bc with SMTP id d9443c01a7336-24cb83fcae1mr71797005ad.56.1757015747493;
        Thu, 04 Sep 2025 12:55:47 -0700 (PDT)
Received: from Cyndaquil. ([174.127.224.194])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24cac2f24fdsm39950505ad.46.2025.09.04.12.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 12:55:47 -0700 (PDT)
Message-ID: <68b9eec3.170a0220.67a17.2278@mx.google.com>
X-Google-Original-Message-ID: <aLnuwADb4/E8BhN9@Cyndaquil.>
Date: Thu, 4 Sep 2025 12:55:44 -0700
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
Subject: Re: [PATCH v3 4/7] rust: cpumask: Add getters for globally defined
 cpumasks
References: <20250828-rust-percpu-v3-0-4dd92e1e7904@gmail.com>
 <20250828-rust-percpu-v3-4-4dd92e1e7904@gmail.com>
 <aLi7Ptya5xp22P-B@yury>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLi7Ptya5xp22P-B@yury>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EF22A18000A
X-Stat-Signature: s5gdpzfowwrjrobq1fqpkdmdrcpskbue
X-Rspam-User: 
X-HE-Tag: 1757015748-798302
X-HE-Meta: U2FsdGVkX1+uoLi3I3VQmEhHujZLH9To9pBeZKAa4s3HU1lXv+06Xbnd4XB/ySck0YRPqzh2YxMNr9AjrRsowtXJnEzmEIRMZSrWxEKar2cpaDdyX1dro7cHRbDHT8LKENXkGi26jVHFbsGgRHOkiuItgz97vSxV27S3KRToQ9++2rBMMBS18tJhVvp8XCem87oV1qnQe2qchzDwiWisMCd+XfHY5GbyefqYtht8+7OpSfXO8weYM9K0rzc5TfrIRqSitRofDEpjfDjCTkSon82Y09BgsFVOTD7EM9rvZKeYiW3PPJvzLn6L2FLxn/MQposHdFdTCstwbMs/PloaMI6CCanqlYmvaYebwOTM87sPHgeTZ5SEiySlYkIVPetJHj2TjD+AmpgayWnVx/4AtqCGuiTCsKBG9Zs3yCw5II8oJBM9etmJ8pQ71P1SWTFLE76C2DfP0GDG1VAIQcDNKp8tVjmT2UQWsJtY8X3kZr+Vv5d3me26TYSTiNMaan0egUuVzdczLtjMwYQPuntqxWGK/mEGe0V/gz99fQyWZjFKbzTtnX3BJiIYc8Ac/5AbLq4enueaDQB0LhNbPPSVhki+fQmnfPbAgaXZpAg0kTRXmu3hDgehS5VtEPJ7ibYgPCep62V/9/t8Wspwmdc4mOcTLAzSiCYKEpRzbeU0h/zTGRAZsf/gzYNqaVsWRpXJkTCUVDncSCBPR2AuYbUHMMFxH68DkiEzki721rPl6N8fFQW+lv32eOZe1fvBhg60BEW0NjhPOkLyK4cUqW0r3tKrzmwV91Z8D1pIzvT0BN+XMCgBU+LNh3t/EqCw7Ayd9qpVJFYF3/Ol+wQ7NCv78H4dBKOWvomCWNODX1+JP5ZNwj4AWYHzN720YFsCegebJuffIbE1dPLCX9DJtR5Q0j2toPIDEPwt4kpwZtGJX00CfHszSAAKMKJfnDsDaXRde8Xkr3iLthGUlTW1XI3
 FiEqhl0B
 u6TkmnDqlMgFegVSLy9dTTVJ8Vn07niUudQHRfbk7FrI+vinTq9/Xdf55FIKT+Bg4E3328+iM0uuCpvGnEYRP51kOaydwVhCqq6TfElgt+5OB9s9S49wloTPbxW6AbU+0QWIEN+eKqZYk+cquy3XwekXRENd37tG2iAZeBiSMFwmFGLITUQX67OAB6zr+K993SCavNAaBkqq3Bzcf9DaSul0XFYIm+0OgZjjFarBVWQ3QKKpN4R2kzUt4YWzLCPeRPfGBWdfPjruOqs70BrOE7W6LzaVDO/+u6+mTlNABbJ1e31PHFaacqAmuZORaJRlqpurqU4u+RCGGXjVvZRog3jSYKAnQIkb8C4zu1DiowGuSXXDkiTqAxwPm05XHoBmuWptb/GmTlC2l9rOknqs1lMYGYKXFFnBtwrsaSFmBY5nJ1Boa+BDl2LIeThZlhaWbLZJu27Z3dwlb+RL6pkBpWdvUZGZ2/r2P8W9Rr3On5Bex99c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 06:03:51PM -0400, Yury Norov wrote:
> On Thu, Aug 28, 2025 at 12:00:11PM -0700, Mitchell Levy wrote:
> > Add getters for the global cpumasks documented in
> > `include/linux/cpumask.h`, specifically:
> > - cpu_possible_mask
> > - cpu_online_mask
> > - cpu_enabled_mask
> > - cpu_present_mask
> > - cpu_active_mask
> > 
> > Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
> > ---
> >  rust/kernel/cpumask.rs | 46 ++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 46 insertions(+)
> > 
> > diff --git a/rust/kernel/cpumask.rs b/rust/kernel/cpumask.rs
> > index b7401848f59e..ca9aa6875b4a 100644
> > --- a/rust/kernel/cpumask.rs
> > +++ b/rust/kernel/cpumask.rs
> > @@ -77,6 +77,52 @@ pub unsafe fn as_ref<'a>(ptr: *const bindings::cpumask) -> &'a Self {
> >          unsafe { &*ptr.cast() }
> >      }
> >  
> > +    /// Get a CPU mask representing possible CPUs; has bit `cpu` set iff cpu is populatable
> > +    #[inline]
> > +    pub fn possible() -> &'static Self {
> > +        // SAFETY: `__cpu_possible_mask` is a valid global provided by the kernel that lives
> > +        // forever.
> > +        unsafe { Cpumask::as_ref(&raw const bindings::__cpu_possible_mask) }
> > +    }
> 
> This function and the following look like returning a boolean.
> Maybe possible_cpus()? 

Agreed, I think that's definitely better. Will do for v4.

> The general rule is to keep the rust naming as close to C as
> possible, but in this case Cpumask::cpu_possible_mask is, OK,
> somewhat excessive.

Agreed :)

Thanks,
Mitchell

> Thanks,
> Yury
> 
> > +
> > +    /// Get a CPU mask representing online CPUs; has bit `cpu` set iff cpu available to the
> > +    /// scheduler
> > +    #[inline]
> > +    pub fn online() -> &'static Self {
> > +        // SAFETY: `__cpu_online_mask` is a valid global provided by the kernel that lives forever.
> > +        // Since we wrap the returned pointer in an `Opaque`, it's ok that `__cpu_online_mask`
> > +        // may change its value.
> > +        unsafe { Cpumask::as_ref(&raw const bindings::__cpu_online_mask) }
> > +    }
> > +
> > +    /// Get a CPU mask representing enabled CPUs; has bit `cpu` set iff cpu can be brought online
> > +    #[inline]
> > +    pub fn enabled() -> &'static Self {
> > +        // SAFETY: `__cpu_enabled_mask` is a valid global provided by the kernel that lives forever.
> > +        // Since we wrap the returned pointer in an `Opaque`, it's ok that `__cpu_enabled_mask`
> > +        // may change its value.
> > +        unsafe { Cpumask::as_ref(&raw const bindings::__cpu_enabled_mask) }
> > +    }
> > +
> > +    /// Get a CPU mask representing present CPUs; has bit `cpu` set iff cpu is populated
> > +    #[inline]
> > +    pub fn present() -> &'static Self {
> > +        // SAFETY: `__cpu_present_mask` is a valid global provided by the kernel that lives
> > +        // forever. Since we wrap the returned pointer in an `Opaque`, it's ok that
> > +        // `__cpu_present_mask` may change its value.
> > +        unsafe { Cpumask::as_ref(&raw const bindings::__cpu_present_mask) }
> > +    }
> > +
> > +    /// Get a CPU mask representing active CPUs; has bit `cpu` set iff cpu is available to
> > +    /// migration.
> > +    #[inline]
> > +    pub fn active() -> &'static Self {
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

