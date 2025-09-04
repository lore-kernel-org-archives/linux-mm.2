Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02716CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 20:27:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61B2B8E0011; Thu,  4 Sep 2025 16:27:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EBA28E0006; Thu,  4 Sep 2025 16:27:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DAFB8E0011; Thu,  4 Sep 2025 16:27:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A21D8E0006
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:27:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EE7D485A91
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 20:27:47 +0000 (UTC)
X-FDA: 83852703774.10.9988D7D
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 19C5A1C0011
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 20:27:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mNbcGtSN;
	spf=pass (imf18.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.219.170 as permitted sender) smtp.mailfrom=yury.norov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757017666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KvB00ALLfGnFg6LmNb2oOcpwz39zT9dJ6DxoEfayJGI=;
	b=6SIpnvMyT54PIo5t1tKd9aNewg8orKOHmh5vYuCUPsZxEuiw4B7l2jAujlULmuadKOcfJT
	3rgEMWIfxpOsl4kPEAV5CI06H4Zd2muOroUvOAaNNNKcrp1vmWPHybmkl9mpQJ0hb6fwi1
	yBwuSeiXvAEUldV1h+gwK0MDxQzlqvQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757017666; a=rsa-sha256;
	cv=none;
	b=IP6SiVlrkLtMmerWKODbF34LyDIcquLidbDFGYxD4++8uhJzcyCJOYHpBfbgCUWIsUoS/a
	q4jmfYhTCHP/3RQkySVkYHrQVe1dNli/PySPwm90H/W7zJwiL751NuUK1LkP00MulMnEDW
	D522/ADQUqUWGDffEaMQjk5W+ivWxEo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mNbcGtSN;
	spf=pass (imf18.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.219.170 as permitted sender) smtp.mailfrom=yury.norov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e98b7071cc9so1535572276.3
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 13:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757017665; x=1757622465; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KvB00ALLfGnFg6LmNb2oOcpwz39zT9dJ6DxoEfayJGI=;
        b=mNbcGtSNmz+NGpkQE1OxLjnokAiO/g8lPZ70NLWvXVDBc+7XDeF6JtXr4AMzebGEbd
         8RtKLEw7naTEsU72TCAvNQYR024O2Ry76I0U3tBm+iNHWo7CicH4PveFnrQV8eOPjn7r
         Nz4bz/PlBH7vE99V+wJpZEeprsViDwzrE7AvWs45ms8xubMOc+HZb2CNf+M1Ep69eYZv
         NNXHUx4Nljrxd5ea50O01PbhnzQvBQyohlLt7qvdZqWgW36PWU4besFyoBI7nhPj88YG
         kBXJmnJnN4uaXyWsVohS325BC/Lata9nH/aoW9HGNhK3lSDCcrIJhLFL+2zLq1g0j5dd
         Xmrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757017665; x=1757622465;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KvB00ALLfGnFg6LmNb2oOcpwz39zT9dJ6DxoEfayJGI=;
        b=tkxqP+yAi0rVVczie/PirItlcbBRBKmUzt+ycA4WKNilqz1qocdt2oYect8dIy//RE
         TjejYZQBLAUiK7buoSFRgKeOvWqSKGcR3oH2XrE+sW5ASgbWF8sFZuv0yljZM94QeM4L
         EHT2Yn1l/xzikxNOPSzBvUQ0TaLFjDT4Upp6DVR6gENEmL50T8xkJT2s6+7h79w3CN8K
         ZercDkKhJapqe/dZHWBbQ2sjV4TiCdPWn27gPoTPCmgB0BGRG+3cfCfDuRFi6/T3qsNA
         Q42gX+AWoTbsdmvDsZ6QbWps9/d8t0LUze6LGhz6MN94gq139SFbTfkSt2j7K3dpPC/A
         z8ug==
X-Forwarded-Encrypted: i=1; AJvYcCWx5b2oMuiyypR7DxVDyTujedPSWfgjGFCYJwWKYZJuMH4G959PijuXLlXhDl46HzvuWQU4ooHifg==@kvack.org
X-Gm-Message-State: AOJu0YwZi5Tv8IKkFKFjweU3XlbZruParYFHgrxYQs2vHqAv1O/ncaxj
	dWLCPrHSYFwz/+JKkXKisDTZQKbBTukh+PZMESs9EYLi8q5GwbRKp9Z/
X-Gm-Gg: ASbGncvt27uB0tuYjaTwU/N9CMf1RGK8/qNd6+Jp8UOl3XHLf27iUQPmIXdF8hPyKJk
	2trLxK7uTMPhemwOrhPJ32JdHqjgfKCfOy/BaTAEJkdYxPC5T9nBdjBxxJFBeQS7KKXeXmokIe6
	CxH5pIYy14OxFRw2WPAa2o55l2IoFSkF+CzZRBZa3dzrOmIX0gyKYDPbK0cnyqCznu46qQuw9KZ
	q59xDFD/iuuYzvQ0CBcsTFyu1q6eVB/d3d3IJoF59APqAlzCzRIgaUtBfuNtJWPSq4ZkPJeKWAd
	X9LgadUjiZLUnqTl0EW46tndK9fuqJL8gqMHixcXaY1bUMpTaIOUM6ev6eBf4XXb+OCrjRvUcAu
	wxMiBVSgbGnxyRbjTDYCsJliWw+aYoWHU
X-Google-Smtp-Source: AGHT+IFEin3sVc/RJ0H3j23pXeDGR2NQkhbQfFAip/QeL6r8A6bl0sYH8LkbMo/F5ZLv1yUwPLRxSA==
X-Received: by 2002:a05:690e:165c:b0:5fc:8075:1ac5 with SMTP id 956f58d0204a3-60175d7f7b7mr3511304d50.11.1757017664951;
        Thu, 04 Sep 2025 13:27:44 -0700 (PDT)
Received: from localhost ([2601:347:100:5ea0:1218:85e4:58ab:e67f])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a83295b7sm24319117b3.24.2025.09.04.13.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 13:27:44 -0700 (PDT)
Date: Thu, 4 Sep 2025 16:27:43 -0400
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
Subject: Re: [PATCH v3 1/7] rust: percpu: introduce a rust API for per-CPU
 variables
Message-ID: <aLn2PzD1KRbu4SpZ@yury>
References: <20250828-rust-percpu-v3-0-4dd92e1e7904@gmail.com>
 <20250828-rust-percpu-v3-1-4dd92e1e7904@gmail.com>
 <aLi2MBAwoD65tokv@yury>
 <68b9ee59.170a0220.a7a31.675c@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68b9ee59.170a0220.a7a31.675c@mx.google.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 19C5A1C0011
X-Stat-Signature: oaqzs1t3eeixaiayj9mjqx31i4ecnjzk
X-Rspam-User: 
X-HE-Tag: 1757017665-297157
X-HE-Meta: U2FsdGVkX1+CxXUiSATRlkWuCR4Y1DoOV/mAM7GanHRZD71PpoxjBQzZ3lBHSloIbybWdSxtR2ZnVjosY7i1IdlV5/LRiWHHdJyGiQdbeSZjVuBtE0cobLdWKoOQIk0P3ux18saOLOL/enhuR6C23wQDOtlwqHnd3B6Pk/+eJfiBmJ6/TEDInSURyzVKTIa84wM0ImgAch4agbp6fGTJ8UipQ8aXAqUrxuAxypbVu5EnH8s7sLTe9gm8IuVqXzHHlHR0ZwJCGe1xP5vveWDhVTN0OCKz6sJ2eAilEeCisg/LJf0y1ozZa3sfr3cWwtKsLi3f2DkdKQX2cL1NxWwPAR+aPgGFyOcs7ZFz2jR90TgBadRyhicr7OmC0mrpitPEL3r2J1nWEwLc7tMXy+5VW7Nuf/FFJc3jzs+Ao/OWpwvUR279EUaIW3BchyhOIQjl8YLTOFpqjKV08APyrS1XNH3c9v5zG6DhiZ6bXIQWSTBFs3+etJakICU890STm7v/Mm6MhbZdIjoSsq8kLnqgRhMfPFYZ7N6EI7D2/Ra+b4CWIt6GhfKSWoLKEhw2dECydtC2BloI3yBGeE+Ac1gvKGDi2mrAUhLxsiqmqG3qZh7oI3vLbRe8FByC+YMFjFC9q1xLvP/BM207EupdPb95ZfQcJStpV/cSeVPQaedX3w2IjOFlpG8GSrsvpHSx85Dq4lka5kW4p45een8fKXOJ8F3ipJj5JaqtusmvCvlUw+hSYLxzra4NR33pUXdEDKLBva+MMaBZIhYI6+g0UekFdkAK42bLUg54EQzoe9kS3MexkFZ+PNm+MMB3GssWNpLRHVhyuVJcGjECuTf/CbWaVni5KtOG3sK8vz8uauuV4s2HxgqbaLUlRWKT91kWuRFAMfDzHXFb5cVImY4kfeO+SbM3NTz73pAAknTYPA8k7FOVFoi2UjqIsZ7V0FUvaeL+Wzswber1EBeMA9DN3z0
 mZcdtSnD
 Znk8EdM5g1zDkHll28iBJbdJVQrxhTmhLaxpmurqdjHQrvY+cDdlTXImFolz7w23Yj8DdpB0GZvigDCbKQfqqZDeVaRdJcJpQJZDLeKOb8ndZfqof/P0g8phDUrpLF9r4ZXpZFEQPI5Afl95TUgu5ErxspLcTRZ8G/8GUciLq53lqNngghvlbwFF9ahlxr5+DfhV2W8IOzmaTdeesyBXZXb+wlOWJL04k8lNCi+vMnf6hwuPjcIZzunh9i+89FeTN9O+ufNC1W7ifoczK8ZeuXn8I0o2djN1sb/QCfaZ6cKfXCbfs/Z8TaAWyujfq9qxoQg+z7VkimVoXK6qfdl4i2VtkmejM5jNAYlEnmzo7iDUAyXSoS1jwZnGZV8D7axVBhPniDVE38NOuxktzQGU4osoOB11EP2eZt4nfjG5X4+A1IGxC5bCbjtH1zhnDm+DT9OJOepWuaRFtr5FLAnKcYqMjZITrZTuoXOgd/B/MV+TVPxY607Hs1TroU+UxF9ArkywD/2FGqfka3RXnxaDsjrQ/7n+uyG9N7XO+AvyDl6XH1p/EcT10aDEwMcd40Co/Q9ZPwaLGTdFZ6COeoB/Qm38a+jOh9LPLXyvl/X5idSzLWr0xEYPY6KrN5qtXwPUtD0H37dH7CDiOsGiLLrgRkrN/p5XiCU+HByAB6Ic7M21p/94=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 12:53:59PM -0700, Mitchell Levy wrote:
> On Wed, Sep 03, 2025 at 05:42:08PM -0400, Yury Norov wrote:
> > On Thu, Aug 28, 2025 at 12:00:08PM -0700, Mitchell Levy wrote:

...

> > > +    /// Get a `&mut MaybeUninit<T>` to the per-CPU variable on the current CPU represented by `&self`
> > > +    ///
> > > +    /// # Safety
> > > +    /// The returned `&mut T` must follow Rust's aliasing rules. That is, no other `&(mut) T` may
> > > +    /// exist that points to the same location in memory. In practice, this means that `get_(mut_)ref`
> > 
> > How long is this line?
> 
> 102 chars, or 103 if you include the newline. `rustfmt` doesn't break
> the line, so I left it as-is for this patch. Happy to change it if it
> poses a problem, though.

Then don't use that tool - it's broken. In kernel we used to have 80-chars
limit for the lines, recently relaxed to 100.
 
> > > +    /// must not be called on another `PerCpuPtr<T>` that is a copy/clone of `&self` for as long as
> > > +    /// the returned reference lives.
> > > +    ///
> > > +    /// CPU preemption must be disabled before calling this function and for the lifetime of the
> > > +    /// returned reference. Otherwise, the returned reference might end up being a reference to a
> > > +    /// different CPU's per-CPU area, causing the potential for a data race.
> > > +    #[allow(clippy::mut_from_ref)] // Safety requirements prevent aliasing issues
> > > +    pub unsafe fn get_mut_ref(&self) -> &mut MaybeUninit<T> {
> > > +        // SAFETY: `self.get_ptr()` returns a valid pointer to a `MaybeUninit<T>` by its contract,
> > > +        // and the safety requirements of this function ensure that the returned reference is
> > > +        // exclusive.
> > > +        unsafe { &mut *(self.get_ptr()) }
> > > +    }
> > 
> > Here and everywhere: would it make sense to enforce it by testing
> > the CPU with preemptible() before returning a reference? 
> 
> The only thing we could do would be to panic, which I don't 100% love.
> Another alternative would be to take a &'a CpuGuard and bound the
> lifetime of the returned reference to 'a, and then we don't need to do
> any run-time checking at all.
> 
> Originally, I had left this to the caller because it might make sense
> down the line for some complex behavior based on per-CPU (e.g., per-CPU
> refcount) to do all its own management of per-CPU variables using
> `PerCpuPtr` as a core primitive. In these cases, I believe there are
> some times where being non-preemptible wouldn't actually be required
> (that said, my thoughts on this aren't well reflected in the safety
> comment, since I said it must be disabled... gah). But, the more I think
> about it, the more I think these use cases would be better served by
> just using `get_ptr` --- conjuring `&mut` references seems like it would
> be a big footgun. And the safety comment already actually reflects these
> thoughts somewhat :)

If you think that in future there will be a user who will not need to
disable preemption before dereferencing a percpu pointer, then you can
add another less restricted flavor of the helper.

> For v4 I will probably have this function take a &'a CpuGuard and use
> that to bound the liftetime of the returned reference, unless there are
> other thoughts on this point.

I don't want you to panic just because of invlid user call, but
whatever you call in comment must be enforced in code, right?


You can use the guard, if it guarantees the preemption disabled; or 
you can return None; you can create CONFIG_RUST_PERCPU_HARDENED for
panics.

Please refer the recent bitmap API wrapper, and how erroneous request
is handled there.

https://lore.kernel.org/all/20250904165015.3791895-4-bqe@google.com/

