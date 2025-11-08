Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEAD2CCF9F8
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 00:06:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40EC28E0010; Fri,  7 Nov 2025 19:06:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BEF58E0006; Fri,  7 Nov 2025 19:06:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AEFD8E0010; Fri,  7 Nov 2025 19:06:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1400B8E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 19:06:25 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9A6EE4BCEE
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 00:06:24 +0000 (UTC)
X-FDA: 84085497888.20.18C0251
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id C35E720007
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 00:06:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E4VHrnoj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762560382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7h9CdYuOTS5h75lNFIMVYyqAeLAsvDUl8xAoBGVKS88=;
	b=yjREBMxdkN3V4qRR2QCWWqxCqH9sUkSHjDGgpMeMFRCdzaanMxi1JkAL4ZCOtPQKftj6SS
	Fu7xjPVAdLhpCT3WhvKwY4U2fV/Ig+Ds0DpygpWrPsvwsh4ohKF3xRPcr50TFqo7nqtMsH
	PT+52lkN9sfhYzTviYU8HX8wL8PsUqY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762560382; a=rsa-sha256;
	cv=none;
	b=jS/ZIoRNvld43wM50Yy2IGUg4Zjf+xelmExBr7wH8wTTzcvfJNPCAhbUCwBB49T2bNmcGU
	x9bG+M9bmZlht6/hEA0cL4KAPt6F2uvsKA19aucVTCt6O93bTM5iuQKE3qGkDjv5bSRjl3
	CraKEIvLOrCkKZyCRt8777AYoWcHJrQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E4VHrnoj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b550eff972eso785266a12.3
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 16:06:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762560381; x=1763165181; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=7h9CdYuOTS5h75lNFIMVYyqAeLAsvDUl8xAoBGVKS88=;
        b=E4VHrnojdttiEZM/zok42+SnVVMxWfdF79awV/g+dlg6+Lbqy5cTZ2MJnvqQelXHmB
         GWriVvZyKEa/u6AMWDF01//A5IcGhMpydq57jqL3PrDNaM6TD1WPqXlgA8QLFM2SrDKP
         DDOCufFVYyOTFt7H/jX4dKWD5HpYNubvCfDKAElo59+eL71JC4dm4CfDBpD5dv9rRHhq
         UZU0rj2Vdi4S721ZBgTDiD5WKI6MxLhdBkhK85pxMzrJJM1vKUFBZpYw+AEVP9VuSjBr
         5nx5/aM/JeQfTybjqyOYop6lfp8cm3tt5p9JVQRcD5vlWabFv1cvN4TV1aKXv3fZSrjI
         Vv1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762560381; x=1763165181;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7h9CdYuOTS5h75lNFIMVYyqAeLAsvDUl8xAoBGVKS88=;
        b=tAvSwkBCRXnEsZQRiEll6WP+xZnoX+mtYyKDajoEB34Mv9NgyGZN1bsmwbbVB1ZyWY
         1PrF7wJLFicHo6/1LiuPgCfqAygv4KG/zW4QRq/gEoLqVmZ3t6L9A8ddzTVALUMI9TQm
         kwwBrCJ1AHrhTXQ/BOXkke3d4n3UJPY6w4QOdgXW5Lo77q4oDiugtng3/xAE1YcG8011
         2VtKp1rtDdiK7E982UYiHUpgd8aIJ4nwD0HshgcfSJes2emy1QPJHWX/DglxhLExsTBl
         Fuy6pBGlyA7bBxICVRp77l1WP4UVKpxunn00LUn+m28B6AbTsuSUyqWcOjNKTGu+p8ag
         H1sQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQFtcsu+jyjDrU39gNX/sfKZ6sozPolQiMOdopSE7YBzI82NO/Ov1lY60gAhbC1ahpgcY4T6Tegw==@kvack.org
X-Gm-Message-State: AOJu0YzWMEeYNi7JFGejTlXwr5NqBXPlUhNVZofwA1/O1g5DR1Oa3qdK
	36rjafdv+0X0YZwODeQq/iwz9kNPmW54mrOJZyLFTqJZQqX3IeM7yxeg
X-Gm-Gg: ASbGnctA8ILsSJ2Nj6Ey6e17gjrF32eluIlnoIHBuYCHxnvwh9KEA03x30qjSUu+HB6
	NjeOtPAjCKE+v4fYKPOJq8E6wcMVNRTQLZCOUOxiI9qRj0CGn8WR257Y5Uo4wlWISdMrk/dASdG
	uaEw35Wxyzo6ojp/J4QykJ22EAo4WCSbwGCI86oWuU1vxSrAZPPdjfxVB6HG5094WT8sd5gnlEX
	lXTTIcrHDM8gdO/tiiYVGqv+NXifGYpYIORM4arr+PnzDxOvl3uH05oFi8j97lAZyufCJMFd2/6
	yWYnVgEQjf2XMlKYtkxsDsIKCp5Xfa35GI+Y3Nuw9DAw1cS38LwGr39G2787oOPSf4a7DcC1KDy
	ZiW4IOGQzo6QVxBbJrEGECZv0cZcPO+vYeTIPhjWiQvsgnaRjzRYTAknCbEvdJyDaH3z73NUVWD
	yxBK43RZPU0MKQfJA=
X-Google-Smtp-Source: AGHT+IH33qICY4uaeKk57pGvzo3XJVsrnq22IGhfO2Tvsbq1LFIDdEBpg7HfH7riDrhUDN3/lHoYxQ==
X-Received: by 2002:a17:902:f609:b0:290:b53b:7455 with SMTP id d9443c01a7336-297e5411300mr10140325ad.10.1762560381315;
        Fri, 07 Nov 2025 16:06:21 -0800 (PST)
Received: from Cyndaquil. ([174.127.224.194])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29651c9c310sm71930075ad.87.2025.11.07.16.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 16:06:21 -0800 (PST)
Message-ID: <690e897d.170a0220.3b9532.0c02@mx.google.com>
X-Google-Original-Message-ID: <aQ6Je9ZrTdaudama@Cyndaquil.>
Date: Fri, 7 Nov 2025 16:06:19 -0800
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
Subject: Re: [PATCH v4 1/9] rust: cpumask: Add a `Cpumask` iterator
References: <20251105-rust-percpu-v4-0-984b1470adcb@gmail.com>
 <20251105-rust-percpu-v4-1-984b1470adcb@gmail.com>
 <aQ08d2NUVsIf5ukH@yury>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQ08d2NUVsIf5ukH@yury>
X-Stat-Signature: x4qc1ef7efeaq8w56upk3zfsysudd9pu
X-Rspam-User: 
X-Rspamd-Queue-Id: C35E720007
X-Rspamd-Server: rspam10
X-HE-Tag: 1762560382-54809
X-HE-Meta: U2FsdGVkX1/DqtG1vI1u8criKH1z3HiWHhzwxe9FeWfDHXCmQE2CUVz6apBOVSxvsaxTl0vCQg6rppSrr4TBSCOBeptqIaonMJQhpfvJGezP3Q/utsb1mEozFz3t0S7N/vEJQAMI8syWeDed0JrwBLpPXGrD9uthXalv3qhufMbgOMLJSROi5zDMgLw+vL1lUrRsqQoQpuHb6qp9YBeiRG6sGKx3nQMKn4OrZMDxKRL4A787/xh869kegW13ApPpDXbiIxVLoWJp2vhyzFY+xss3EFbyuubsXQ7JRCPx7yC3KIySZSfglKTNGuRIlxBu2HPFb6kZYWrjxG3EohnpIplnbUibuI/JbRcjmuphO00cNJ52UlEVHx1BozNrMZNmrpTLE+0kG5c8k112rmDt8E4X3xC+podl498B2FAd9XPmaEMzSHqaeFczFz4mNVbmBPzKXaAMOImybDkUIWkUzHG76aPXDyozaWODrXLIGj6Tk13CFIlL1t7JyZVqUq8oAt4XaPrnANGoPhw5VrOJ5fkLIAs+SYt2ImhgV1kknk6mzq9R086o96Ome5zs0eySLZKHkP10NL4vV+oWj4GI2wfblDcNwJaOq3OHBdvJiGa/pXo4G6jlmE0oouVMA+bA/q4ZlmBBLV+H/XGYtgS2lfC5E+c7kJTMMTjpLmvMwZYb0ev06RPoidGPbaf2d63lKYEIeBuB41pLQHDTkb01f8u5gbIMTRWH7lFO7ebHyPurtcXcxnjImM88OzdlYqDGucKPP7yK8Bv3Gk8D3OkwSCnGoCDb4ZKW2GWidH3cXYMCuhRwBsHfU1WVKEGYQzdSvQVhT4r73h3Zn+Xri9IIDsyoLJG+Hxb4MShtC64JnRHx9zGQuypKf6p1mBh5fCZgfJNcyOfUpIf2I4nV+AsopWW9X/cV4TKa+hOX7VMz4l8UjBPxd2vH/q1pbI4M3ltKT2MyaVFOtoMg6FdddU8
 ZkBkcA66
 VhLKY7YCjsBNhIw9bV3e5/X1wALGAYDJoPtBg7wmxMVgDt5juoLLaGwxLXk31624SACOXCcET/cTNVkc2FPXlTvgDCA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 07:25:27PM -0500, Yury Norov wrote:
> On Wed, Nov 05, 2025 at 03:01:13PM -0800, Mitchell Levy wrote:
> > Add an iterator for `Cpumask` making use of C's `cpumask_next`.
> > 
> > Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> > Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
> > ---
> >  rust/helpers/cpumask.c |  5 +++++
> >  rust/kernel/cpumask.rs | 48 +++++++++++++++++++++++++++++++++++++++++++++++-
> >  2 files changed, 52 insertions(+), 1 deletion(-)
> > 
> > diff --git a/rust/helpers/cpumask.c b/rust/helpers/cpumask.c
> > index eb10598a0242..d95bfa111191 100644
> > --- a/rust/helpers/cpumask.c
> > +++ b/rust/helpers/cpumask.c
> > @@ -42,6 +42,11 @@ bool rust_helper_cpumask_full(struct cpumask *srcp)
> >  	return cpumask_full(srcp);
> >  }
> >  
> > +unsigned int rust_helper_cpumask_next(int n, struct cpumask *srcp)
> > +{
> > +	return cpumask_next(n, srcp);
> > +}
> > +
> >  unsigned int rust_helper_cpumask_weight(struct cpumask *srcp)
> >  {
> >  	return cpumask_weight(srcp);
> > diff --git a/rust/kernel/cpumask.rs b/rust/kernel/cpumask.rs
> > index 3fcbff438670..b7401848f59e 100644
> > --- a/rust/kernel/cpumask.rs
> > +++ b/rust/kernel/cpumask.rs
> > @@ -6,7 +6,7 @@
> >  
> >  use crate::{
> >      alloc::{AllocError, Flags},
> > -    cpu::CpuId,
> > +    cpu::{self, CpuId},
> >      prelude::*,
> >      types::Opaque,
> >  };
> > @@ -161,6 +161,52 @@ pub fn copy(&self, dstp: &mut Self) {
> >      }
> >  }
> >  
> > +/// Iterator for a `Cpumask`.
> > +pub struct CpumaskIter<'a> {
> > +    mask: &'a Cpumask,
> > +    last: Option<u32>,
> 
> This is not the last, it's a current CPU.

Ah, I meant it in the sense of "the last cpuid we've seen", though now
that you point it out I agree the naming here is poor. Will correct to
`current`.

> > +}
> > +
> > +impl<'a> CpumaskIter<'a> {
> > +    /// Creates a new `CpumaskIter` for the given `Cpumask`.
> > +    fn new(mask: &'a Cpumask) -> CpumaskIter<'a> {
> > +        Self { mask, last: None }
> > +    }
> > +}
> > +
> > +impl<'a> Iterator for CpumaskIter<'a> {
> > +    type Item = CpuId;
> > +
> > +    fn next(&mut self) -> Option<Self::Item> {
> > +        // SAFETY: By the type invariant, `self.mask.as_raw` is a `struct cpumask *`.
> > +        let next = unsafe {
> > +            bindings::cpumask_next(
> > +                if let Some(last) = self.last {
> > +                    last.try_into().unwrap()
> > +                } else {
> > +                    -1
> > +                },
> > +                self.mask.as_raw(),
> > +            )
> > +        };
> > +
> > +        if next == cpu::nr_cpu_ids() {
> > +            None
> 
> Please:    if next >= cpu::nr_cpu_ids() {
>
> > +        } else {
> > +            self.last = Some(next);
> > +            // SAFETY: `cpumask_next` returns either `nr_cpu_ids` or a valid CPU ID.
> 
> Now that you've handled the no-found case in the previous block, the
> comment doesn't look correct. Can you either move it on top of the
> if-else, or just drop entirely?

Actually, now that I'm looking at this again, I think this whole if-else
thing should just be:
```
CpuId::from_u32(next)
```
which does exactly what we want here. I think this should address both
of your concerns, though please let me know if it doesn't.

Thanks,
Mitchell

> > +            unsafe { Some(CpuId::from_u32_unchecked(next)) }
> > +        }
> > +    }
> > +}
> > +
> > +impl Cpumask {
> > +    /// Returns an iterator over the set bits in the cpumask.
> > +    pub fn iter(&self) -> CpumaskIter<'_> {
> > +        CpumaskIter::new(self)
> > +    }
> > +}
> > +
> >  /// A CPU Mask pointer.
> >  ///
> >  /// Rust abstraction for the C `struct cpumask_var_t`.
> > 
> > -- 
> > 2.34.1

