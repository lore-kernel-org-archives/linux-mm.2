Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B280CA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 21:17:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E64A8E0002; Thu,  4 Sep 2025 17:17:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BE2E8E0001; Thu,  4 Sep 2025 17:17:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D4038E0002; Thu,  4 Sep 2025 17:17:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 37A1E8E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:17:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CCCCC58DF6
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 21:17:18 +0000 (UTC)
X-FDA: 83852828556.02.63173BF
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id D5B8B180006
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 21:17:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AmX1+F7i;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757020636; a=rsa-sha256;
	cv=none;
	b=CA0V4gDmtYtgwsC5bg/evvDjMikjB7gva2YJpXgjA4xbSbGatrzezHQFXfnGN1VxCjQypt
	vvj45u6IIS8/Q6x5sjVhcyZ1r4iJTS+qxSQMnqCLR6AXcfFmUqjWnqwEQA/ur5KnvqHk0X
	0Um0cUSQ9PWYmkhmqSZyBGf0QYA6s0s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AmX1+F7i;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757020636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=px3Ogp6YWCHs89tEx1iBwQpFNyIvSJt4gg+izDxpdC0=;
	b=v96NTcSvfstc0OlMjHG/IxFUuzRW4LUPcLFpoH8n2C+OtUf38kZ1OzwoX3QlGcTFNxdLWa
	52neBQb2QReLA39+U1a+ShqBLFaTC2P1mHueDN+4yJZy+wr2RPU9iofFyBh259MsI173OK
	HITJGUbpwfOH/uzk/ZTTqctqt2VI6dE=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-248d5074ff7so17443395ad.0
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 14:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757020636; x=1757625436; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=px3Ogp6YWCHs89tEx1iBwQpFNyIvSJt4gg+izDxpdC0=;
        b=AmX1+F7iEuBLcFU069yibYr6v6pLQOo5u64z+8WFoUzrS4Iak6PAp4AXoWQBMSEu6v
         B+2PJkU6MJNLAzuP6o8uTNTF1bDy/uofW6N2QinQXFZ0PM+uqwW6dNI7vOphldC65kqR
         B6r7MRIGZDguPl2gxsb6MssEaZilAZR5tQm7GeZsznBfDZ7tFKFD+4+9vKK155DRiNv2
         M+SFx55kJbfpxdaljfqZ6iLqgTULfGHusoqesfWOV839KTw201SVBRTAQy193Ws0hn6K
         hDjr7gvtkrbESYdA6IoKOdSsOxVi/mp1ogyRWtNwDJzwkz2uVAfH9xfBP/Wz6P0q/gRW
         JIew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757020636; x=1757625436;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=px3Ogp6YWCHs89tEx1iBwQpFNyIvSJt4gg+izDxpdC0=;
        b=J6L0AvgwNt0v76DUNw12ScCT7pttLhF3nkjNw6xCZfLsYZRd8hz1V/V81bx3W3+FU4
         JfW50+cv+geIXLgK8+etgiGv/JiK/LJHGpwLYlsaeKO7m8KUTXCK9BW1l7m516J4a4xw
         7eIqsrD1T/60Xzw7V8GCt/qrqaY+rBATSqSpIdLixzx+3fY+GO8zL/YLpMuAopAP+BgN
         e03cuLPQi/cD6v4kPamd9StczFSjNAzTbYJJBj8MTVZRROaK9AZ2GXDe4Jae1jSJiqOv
         nr794LcqtBPSn6n84as3jrcGrGaEeuYwmPkh+yapyLqvpyZ1nWvTkguffsJ9ti9F3W1n
         +7CA==
X-Forwarded-Encrypted: i=1; AJvYcCV0hi0IQnA3iUt603RRsq+IyEQiZ5mYxL0zlzsM2ODvPJyC0HDzlsYrPj5l0mbzz9/fEhrD186VLA==@kvack.org
X-Gm-Message-State: AOJu0Yyn44LQrb3YvLmnO5NvBiktDA0LdktlTlXyEZZUy3KaJHNwfmg+
	diieLSZzfpHmylS7YluFeZEwgpBmBTn/HiPB6/EpAV2/evr24Jd/5afB
X-Gm-Gg: ASbGncuRRVyXyt+m7fSVTTpOd/EzO3fpeCNMYhYvG36so92cY21wAxyoT8LCEwYe6Xo
	MGxXOXw9qfPuJHHbrIn1Lf7BDj0jUtBwd+DinMLtndJ+pSPnLeBsVFhD8oouvjyZreBg1cBqLsH
	AtqSESUM4OMGCjx5aL0AtCksOhYecRkn+yqLJD9ERNPa9C077AoBUETia8klUUMSDSRYpydQyR5
	d/f2b92/drreVg3jfF5neSvgjMGcLjrHEjECYAGgCWpKOB7RSb09R405V4prPcmzQoXPhUicvBj
	GaSE/YUS5dPHg/ywAkALlnkteJcJnAfcOCgGjQznDthDXuD7Pth1DOhGM0s3q3ukNkwF0sdWHke
	Ejcsr3d421PgmnuPSVYkYwiPXTRQ=
X-Google-Smtp-Source: AGHT+IG5l20PWWMfzJjJHKvLY6V0Xvg6JZ009OTeub2pHn29i1TL6bxezyUFqKnj2cbj0Z5C4lE+rQ==
X-Received: by 2002:a17:902:e945:b0:24b:eef:643c with SMTP id d9443c01a7336-24cedc6f3f1mr12554305ad.5.1757020635583;
        Thu, 04 Sep 2025 14:17:15 -0700 (PDT)
Received: from Cyndaquil. ([174.127.224.194])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24cd5092951sm18811275ad.18.2025.09.04.14.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 14:17:15 -0700 (PDT)
Message-ID: <68ba01db.170a0220.31417f.72dc@mx.google.com>
X-Google-Original-Message-ID: <aLoB0+aEivX5jEuV@Cyndaquil.>
Date: Thu, 4 Sep 2025 14:17:07 -0700
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
 <68b9ee59.170a0220.a7a31.675c@mx.google.com>
 <aLn2PzD1KRbu4SpZ@yury>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLn2PzD1KRbu4SpZ@yury>
X-Rspamd-Queue-Id: D5B8B180006
X-Stat-Signature: w8t537bym3pcu4xjnyigce4pin57mjku
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757020636-125568
X-HE-Meta: U2FsdGVkX19c5SMyylHKn5V3FqUTvNffmHGxm3n41I6aVlsCajeFRG3Bmg7a40fkU5cyvBdSE9i0wrh/v5snndvkrXkknrmR7B/OJFrlY769D7q+gMo+sxZObfxDLxhL2uSxKztpQ1UD7fQHMboF/ZaKCNTr1jeGEqTuS8MjlCEWbQCVNDf1QuYA17hCgN/0Z1rdh35P9P2OxK2mtiCeRmlgB0mc6D02j8KBBXTeD1pAOrZNtcrd0AaL9poXnt3KYF969Cu2/y8nQpHeBHLph4+Bf2hs/t4h5r+6WfNcGrOhxX2bITRo+6yMnSY/+KRt+xBZ90OZJtD/nD3gAAfYkrE4LEPtsSSI4/l0JWpPd9MyVYOYw9QI2+iP06YNZNoZU88N6v8tVuJimCHrmfp3Z+wRXl4W6iM5EVPq3rvxPgMNpzgqtOpskz1R01LjgASHusc2STJTnyyg3OEIroZZyWDrPaEWl4R5wEJSTzJtOT3CfX/KVxrsrmWMjnF6dEQOpWfgEdbt9XKPdGRbk0j1ugLRM1aF8BwKQznzz3vWP1/3xECZ8eEFI7J5xnXmbgcUA2QqAF6q81qaFxhyAF5vs1eyUVco8MlqCfoTOOUg4QTN/7wUroOcil4u6AK3IffNET2hahUVbHTGjx+Offt+BbCd9lj3PjuBI6L99Kzlt4v2J3ieK6SUFliiF5Nxd71UCo4A7+WmR1PY11rF1HVm1SE3d2tv1LzZQYcRDUsigP7tz1zvx+F8WXLcEXS3lcMZwbw8SGZa701/8r+l+BvdTb5C0XQOKbo6NwW8FcLKzoDTsNOw24RAgTumb2g0D8ReUGSQeuZc8NtVnn2RUk5NHwYWQykuk3YImH8LNwOILp82u9wjLGeUhUA+GaQiMw9uWr4s0G77ZBuHwep02iugX22hswFTbNxXX3fhtn25/O1Lw4bh7btQt+UX5a/sYcvnAN87LW+PXNpuZ3ooHGX
 1uXBtsgl
 lR3W1VxppZVinH9mNZGOlh0CVxkrL7nMtgElXyp0fx6Z5Pe+TNbdhtJy39/jxn/Zo56KaUHJ7Yi639nT4kBfBETI93bLyPZpXcfzP4DwMx/oTrI6nCBzyXn2Uvccv6wIGOCDyrGeid4zPhmCuff0AKufk0cTCZiYATI7od8IWVlF+f2L5iXCeuMKzxZVgsKFPvTC+tpakUempLCFY3yuLq6hHE2Ljv8g2goM31hAxMX/UEB9AheQjNgMblZz40003/QmsFKms2Zh7yVY4AhdFkvhH/O4kLMCGQxzdW49k5kBVF/SYa+ujGu41sC1I1BTGAdAyect6u14eYtyj/8WSfgpFoVXG7e4QR4TUHkvH4K5NqqkGHQ0L3arAG2XM4GinJbjCRjH1V7U+Rppvl4RWQlYhnZFd0yPcw+J43OYk3fmMMZiEjmieD2xHPKfOT6IIdkZCSA9LorwiU78YFxdXecPMuke7fTdzT1jyVdqJhU1/0NczxTML4yIIHXpRzp6H9Uu1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 04:27:43PM -0400, Yury Norov wrote:
> On Thu, Sep 04, 2025 at 12:53:59PM -0700, Mitchell Levy wrote:
> > On Wed, Sep 03, 2025 at 05:42:08PM -0400, Yury Norov wrote:
> > > On Thu, Aug 28, 2025 at 12:00:08PM -0700, Mitchell Levy wrote:
> 
> ...
> 
> > > > +    /// Get a `&mut MaybeUninit<T>` to the per-CPU variable on the current CPU represented by `&self`
> > > > +    ///
> > > > +    /// # Safety
> > > > +    /// The returned `&mut T` must follow Rust's aliasing rules. That is, no other `&(mut) T` may
> > > > +    /// exist that points to the same location in memory. In practice, this means that `get_(mut_)ref`
> > > 
> > > How long is this line?
> > 
> > 102 chars, or 103 if you include the newline. `rustfmt` doesn't break
> > the line, so I left it as-is for this patch. Happy to change it if it
> > poses a problem, though.
> 
> Then don't use that tool - it's broken. In kernel we used to have 80-chars
> limit for the lines, recently relaxed to 100.

Sure, will fix.

> > > > +    /// must not be called on another `PerCpuPtr<T>` that is a copy/clone of `&self` for as long as
> > > > +    /// the returned reference lives.
> > > > +    ///
> > > > +    /// CPU preemption must be disabled before calling this function and for the lifetime of the
> > > > +    /// returned reference. Otherwise, the returned reference might end up being a reference to a
> > > > +    /// different CPU's per-CPU area, causing the potential for a data race.
> > > > +    #[allow(clippy::mut_from_ref)] // Safety requirements prevent aliasing issues
> > > > +    pub unsafe fn get_mut_ref(&self) -> &mut MaybeUninit<T> {
> > > > +        // SAFETY: `self.get_ptr()` returns a valid pointer to a `MaybeUninit<T>` by its contract,
> > > > +        // and the safety requirements of this function ensure that the returned reference is
> > > > +        // exclusive.
> > > > +        unsafe { &mut *(self.get_ptr()) }
> > > > +    }
> > > 
> > > Here and everywhere: would it make sense to enforce it by testing
> > > the CPU with preemptible() before returning a reference? 
> > 
> > The only thing we could do would be to panic, which I don't 100% love.
> > Another alternative would be to take a &'a CpuGuard and bound the
> > lifetime of the returned reference to 'a, and then we don't need to do
> > any run-time checking at all.
> > 
> > Originally, I had left this to the caller because it might make sense
> > down the line for some complex behavior based on per-CPU (e.g., per-CPU
> > refcount) to do all its own management of per-CPU variables using
> > `PerCpuPtr` as a core primitive. In these cases, I believe there are
> > some times where being non-preemptible wouldn't actually be required
> > (that said, my thoughts on this aren't well reflected in the safety
> > comment, since I said it must be disabled... gah). But, the more I think
> > about it, the more I think these use cases would be better served by
> > just using `get_ptr` --- conjuring `&mut` references seems like it would
> > be a big footgun. And the safety comment already actually reflects these
> > thoughts somewhat :)
> 
> If you think that in future there will be a user who will not need to
> disable preemption before dereferencing a percpu pointer, then you can
> add another less restricted flavor of the helper.

Yeah, that's fair.

> > For v4 I will probably have this function take a &'a CpuGuard and use
> > that to bound the liftetime of the returned reference, unless there are
> > other thoughts on this point.
> 
> I don't want you to panic just because of invlid user call, but
> whatever you call in comment must be enforced in code, right?
> 
> 
> You can use the guard, if it guarantees the preemption disabled; or 
> you can return None; you can create CONFIG_RUST_PERCPU_HARDENED for
> panics.

Yes, the existence of a `CpuGuard` guarantees that preemption is
disabled.

> Please refer the recent bitmap API wrapper, and how erroneous request
> is handled there.
> 
> https://lore.kernel.org/all/20250904165015.3791895-4-bqe@google.com/

Thanks,
Mitchell

