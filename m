Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F07FCA1010
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 22:03:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCEEE8E0005; Wed,  3 Sep 2025 18:03:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6728E0001; Wed,  3 Sep 2025 18:03:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABC488E0005; Wed,  3 Sep 2025 18:03:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9A6578E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:03:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4C71413BB36
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 22:03:57 +0000 (UTC)
X-FDA: 83849317314.01.E835281
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 647A780010
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 22:03:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UMgLCWvg;
	spf=pass (imf02.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=yury.norov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756937035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jG0m6HNJ/BCPE0TOqPLp7Ou6yvk+l9Cs7COyFN/45qQ=;
	b=bEXda/7pup8ubmY343d/L4J90vnqZypY4FaA9N6t1elUdxxYAO/DztiP12DqZ+3dzJzq8Q
	e9Zp8NCMON+xMYEinFPRihGzeZN870Qiu0hUAlwseCBJP7fIsF7+f3u1RsghyOdu/Z+y/B
	WZZi1Co/Z1hYsq4PHe6yllgZIXOFvGQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756937035; a=rsa-sha256;
	cv=none;
	b=wai4zI9XRf+MU7CM/lE3lR2Ts9AEB+yPwihtiQuKOEvXGhtEgJrSJK6yt9xbVtGgsRMkTc
	KgROwyak8hXS8kd8h8wz670/P2egYLxcVMxESBWczGbS94ERW0FJtx3N+hV5Ph9GCPMtxH
	wb4xfifCIAsY5UHaaFWeT2h2MvQVwyE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UMgLCWvg;
	spf=pass (imf02.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=yury.norov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7722c88fc5fso398486b3a.2
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 15:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756937034; x=1757541834; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jG0m6HNJ/BCPE0TOqPLp7Ou6yvk+l9Cs7COyFN/45qQ=;
        b=UMgLCWvgOfSsjoozoSQjCDpw6GTu4xbyC10PD37snWTuUYUMaxU9tfLHqFJRnw+VQF
         Tud+9e1eSzvZ0/KW/cF7wweIktIyjljwJ/yQm7Pzd3vsEwA1JaeP3V4F/9PDeNP+UkCF
         H6dpnZvlvh69gYX7svicbLWuckLXTP6Qlalpg5lQPRflWe+Jp7VTkk/bMvu1HO+SFupd
         HTc/Sh0MSdVz1arjX/02ZSlT20r0KeJf9nzn6w4+LNUYO/QxYFDO9nuSxtfaBD0VoQLm
         HoATwG0PuTQfJC+FFcCID1LGwIxcflLZ876cTBAU3Ex5kAmLz3KsugXTaq0a2T1quUf1
         KwuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756937034; x=1757541834;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jG0m6HNJ/BCPE0TOqPLp7Ou6yvk+l9Cs7COyFN/45qQ=;
        b=fMdK4+xrVs1u65EvHGPyifIMJ7BW3I15tgx2e4B+TwwrMY1+lyufZoc219Da63iNcD
         rqDk+kGI7ddj9ww7snM+I1N4Vn+6gmqZbXqQzixkcGvSR12QUGzWEJLpm/fbryNFZYhu
         pPk0TMuP+6xIWm1spyTg8XurtB/MMC4vNsNLZnorlinMb2Eg/PO1uGQ7bENqILBe4cxf
         eJtURqQi01sT2hhvjpvDcCHwPB/h1us9YijFJ6dGYjxOym8bjddYCsob8ArqTW5zf6qS
         4VMx+NLgiWCBoNZHGHiVwnFNQn1UpoomH/Y0csu1kFDz7511gnF+5c50jeLgh0NEm7LU
         XEKw==
X-Forwarded-Encrypted: i=1; AJvYcCU0C7XzVuOyYRf7VTpOePIKFNQbirICnoTOkDn0zfU5lV7N+GcVy+FU/GeXe2DKoVr8OQGYXmO0mQ==@kvack.org
X-Gm-Message-State: AOJu0Ywhz7iNxsPuFlCjXLJecmFot9Cd2syUW5M8eJsjmRF77T9PgUuI
	Pzj6Q+JwCYqP9U03c6ZWiPGYV66Gcy1OsjPlZEqfuYplq/LwG0SKFVMh
X-Gm-Gg: ASbGncs7RsLYwaehC5SnlDPMjGFN5FbHvwpyj804ccKBJkWhbdZBvbE65KBkpjP9RY0
	Kph1+fDZOIizWaINz0MTxI3TShEK62V/IqUapFdqvyO1XcnWMQaBGzWxf4GwWKjfii7kxrhdEsl
	LsyYKnOqoQbgxMUc/xVDHR6wfJW5z/gmiEk5qmnF+rznf5Qqm0ODju5a+J0zqjyCxo3Ylb7mlKy
	7Z0E0Y146X4yWmajy3QI446AHNz+1cPva/oL3pX6yC5OLmKNNRtvkSjiz+MjuvbzMMxvy40FK1e
	yHCt5N9m4r6XeODfSqEjURAQG1QJtWtKtvkFAeH2x+wRhV861HpHrC9s/IZIns+4OYPij/8NuIx
	uEQihvwXnGfJMUlsbos0T64xqsghNMfOy
X-Google-Smtp-Source: AGHT+IGFzD46F74vfRZav7p17SnqQadIrOzjssirKipnGqHhiSHqc/rNHmh16H0lV55oT0r9qjPfFw==
X-Received: by 2002:a17:903:2301:b0:237:d734:5642 with SMTP id d9443c01a7336-24944ac6b51mr224607925ad.41.1756937034059;
        Wed, 03 Sep 2025 15:03:54 -0700 (PDT)
Received: from localhost ([216.228.127.131])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24b1b5e5902sm54229625ad.49.2025.09.03.15.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 15:03:53 -0700 (PDT)
Date: Wed, 3 Sep 2025 18:03:51 -0400
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
Subject: Re: [PATCH v3 4/7] rust: cpumask: Add getters for globally defined
 cpumasks
Message-ID: <aLi7Ptya5xp22P-B@yury>
References: <20250828-rust-percpu-v3-0-4dd92e1e7904@gmail.com>
 <20250828-rust-percpu-v3-4-4dd92e1e7904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828-rust-percpu-v3-4-4dd92e1e7904@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 647A780010
X-Stat-Signature: bmaop14ct8zqsp9pjk7c7pnn8noe68o3
X-HE-Tag: 1756937035-295845
X-HE-Meta: U2FsdGVkX1/XWyMqGXP1oDgNQWAeZoJFipzVYdYzdkwCuDiP4M9I0KJKJ3TyBYxPM3VfUrRiEK26BrRL1KxwPHAGR2kpsBGNxlIQs4qi7JVXQcG9mxrEpsJuq7l5s+JUCppKO6fvRY+napOYbI300AWyvBUVUzleKu00nog39pD50nGEkKOiz8WhgP5ttIjyq6O4lOoDYVOHnBtLM6PJUsKZyvhN31CmVjquAFiFrCy681oxIRbhBw5VpQEcnc7nsFhgLcaYlsXu8ZsxxOJMZqnz2ASyiZ06y1+wdsfCpM0hFj/R6eikVe1sOyPS4iiS6SySYVb+kfnXh6GmrOfLvsgdpyQWasbNm+QBsqosTjXdKbD0Pt/arkz9g+EFvAX+2poBmwJPHQvl3EkWtsSO9KdwcsRGwW61Xeqm+TfCCQpI0DcFxbz6OhGDaHeldv1tjsH87wk3bobefAQLNN18bQgQKQXBdd2MA8yYq693B7/4Vonf7x9+jZdMP7Th/4y4QV+pj0aCSKAv5kaK/X4A4z5kORzI4KtIr/gxenKdzxE3nqQ+jzbYYhWYcbWBaKpeSlH182rg3aSsEnLqyAkTNFGt/RxNp4qmisCfdfG3XSUsVP77g0SkTYeWMdSFaWW+zhDXprRFrOKlo/DifA7Rz0eHuYJUoaDLbzVJWwAlq9ptCzOXc8MOQGYI3r1QyS8dtvjAjahiRnC2LhBrUs2UdcQ1DyvI2syS4jVlGD8fDi5EN2FkpaBdxFVfcvz19verHdMScRyh/AtzdnIEPOK7Z69mH0jlBp+QXVRZ7t5Quocn8EgD43E4S6lU0OopXSJbzWPxF2/mxpAiKb7dafDGnc81JEIb5hTgnAgQqFgr+xd9mKih6LdUJQw5d4zHBBDl5BRrO3I9GcjuL52fmCOXzdTbAxeFv6F0nKBB80Lm4yTEKeyYuBkGdy9ZEMeD6ZqKXW27UhR1SDp/1BAFakY
 RtN+eiEU
 vs/K3pMWQc7Hb3Kdff7bAajAElp3XbvaP9bIpJlXp2oOp9LeERbCBT8irfZRnPPiIB5qSY4j0ulLvx5RVlDrsoeZr8qRDv+x8+XSnct99PEGdzdwnTgEEnHOb2/OjDAcfqsfFfNg4u0WhSJ4wEk0+2rn3t2gcbyWFR1UXEsgF9LYXXvYrldmubnMeHOl3kynL1X/EEtOUwzzuxTMB7M80o2W4Va13MCYmdx/OiK4s6svmpQRjidXve/SSzj6qAVgd9mR1c9WDixr6NBsFQTohJLr2r9wUd4Pw30ptYsI8DBxFFaR6XME9zHCm+9n0jxKTtj2Irz/c2uvJEw1H+MbM5b+tR7z2wpvwPY6Py4YwlSppXboYAwGa1hwn14GuvJMWAo6c5Kn45f4+b/VxeAz/iQ+/GiTu6cOVVUM8XMnxwvgIBXcEEfrnSzqFb+JiszJ251upkhDTLg1FWR03+5lRmDbzJrLu6fZaHOiVHhSu2Ds9sloghpWhJE5J+olbqOug3UFWqMU/UxuwylR8Z2MULkRwZPrrXW0G5D5EMvJ36iQkg5t/3ud+qInLZnLreu4bpybU1qLROAu28sJkGjudsSnJSwp9M/9+BlaF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 12:00:11PM -0700, Mitchell Levy wrote:
> Add getters for the global cpumasks documented in
> `include/linux/cpumask.h`, specifically:
> - cpu_possible_mask
> - cpu_online_mask
> - cpu_enabled_mask
> - cpu_present_mask
> - cpu_active_mask
> 
> Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
> ---
>  rust/kernel/cpumask.rs | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/rust/kernel/cpumask.rs b/rust/kernel/cpumask.rs
> index b7401848f59e..ca9aa6875b4a 100644
> --- a/rust/kernel/cpumask.rs
> +++ b/rust/kernel/cpumask.rs
> @@ -77,6 +77,52 @@ pub unsafe fn as_ref<'a>(ptr: *const bindings::cpumask) -> &'a Self {
>          unsafe { &*ptr.cast() }
>      }
>  
> +    /// Get a CPU mask representing possible CPUs; has bit `cpu` set iff cpu is populatable
> +    #[inline]
> +    pub fn possible() -> &'static Self {
> +        // SAFETY: `__cpu_possible_mask` is a valid global provided by the kernel that lives
> +        // forever.
> +        unsafe { Cpumask::as_ref(&raw const bindings::__cpu_possible_mask) }
> +    }

This function and the following look like returning a boolean.
Maybe possible_cpus()? 

The general rule is to keep the rust naming as close to C as
possible, but in this case Cpumask::cpu_possible_mask is, OK,
somewhat excessive.

Thanks,
Yury

> +
> +    /// Get a CPU mask representing online CPUs; has bit `cpu` set iff cpu available to the
> +    /// scheduler
> +    #[inline]
> +    pub fn online() -> &'static Self {
> +        // SAFETY: `__cpu_online_mask` is a valid global provided by the kernel that lives forever.
> +        // Since we wrap the returned pointer in an `Opaque`, it's ok that `__cpu_online_mask`
> +        // may change its value.
> +        unsafe { Cpumask::as_ref(&raw const bindings::__cpu_online_mask) }
> +    }
> +
> +    /// Get a CPU mask representing enabled CPUs; has bit `cpu` set iff cpu can be brought online
> +    #[inline]
> +    pub fn enabled() -> &'static Self {
> +        // SAFETY: `__cpu_enabled_mask` is a valid global provided by the kernel that lives forever.
> +        // Since we wrap the returned pointer in an `Opaque`, it's ok that `__cpu_enabled_mask`
> +        // may change its value.
> +        unsafe { Cpumask::as_ref(&raw const bindings::__cpu_enabled_mask) }
> +    }
> +
> +    /// Get a CPU mask representing present CPUs; has bit `cpu` set iff cpu is populated
> +    #[inline]
> +    pub fn present() -> &'static Self {
> +        // SAFETY: `__cpu_present_mask` is a valid global provided by the kernel that lives
> +        // forever. Since we wrap the returned pointer in an `Opaque`, it's ok that
> +        // `__cpu_present_mask` may change its value.
> +        unsafe { Cpumask::as_ref(&raw const bindings::__cpu_present_mask) }
> +    }
> +
> +    /// Get a CPU mask representing active CPUs; has bit `cpu` set iff cpu is available to
> +    /// migration.
> +    #[inline]
> +    pub fn active() -> &'static Self {
> +        // SAFETY: `__cpu_active_mask` is a valid global provided by the kernel that lives forever.
> +        // Since we wrap the returned pointer in an `Opaque`, it's ok that `__cpu_active_mask`
> +        // may change its value.
> +        unsafe { Cpumask::as_ref(&raw const bindings::__cpu_active_mask) }
> +    }
> +
>      /// Obtain the raw `struct cpumask` pointer.
>      pub fn as_raw(&self) -> *mut bindings::cpumask {
>          let this: *const Self = self;
> 
> -- 
> 2.34.1

