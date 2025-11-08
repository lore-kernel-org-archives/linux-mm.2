Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9166DCCF9F8
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 03:39:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E58B8E0010; Fri,  7 Nov 2025 22:39:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BD448E0003; Fri,  7 Nov 2025 22:39:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ABBE8E0010; Fri,  7 Nov 2025 22:39:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 401E78E0003
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 22:39:21 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1A07BA7FC
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 03:39:20 +0000 (UTC)
X-FDA: 84086034480.27.1B60B9B
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf18.hostedemail.com (Postfix) with ESMTP id 14F2A1C0004
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 03:39:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bCSjHtCh;
	spf=pass (imf18.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=yury.norov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762573159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9h3FkFllvRL301ULuxgOtHl5uOTbxkQC4ivgx2/U0MM=;
	b=ZvrB0BIECKLJxK4YnLhrZVqNldeQ1eIPQqaie0JU525tzRmr+Mh+X6KgcrlUqSe0koynxW
	RWwGc0vWEbEYwBCldHiAcxp6mZ/AeF7JH+LHg5U88+VrYL/P2+cT3ebb555/h+GH4qf4kT
	FS+TvMUGVa75LDb7N2tMzm3nBA8MTmM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762573159; a=rsa-sha256;
	cv=none;
	b=lDSJzX/GrENf96V+NrmxxytiIV45bFdqfRbP7I1U7n6Ayo4EL6m0DJj0Gxf5LkOlePslO/
	vdektUYsOLPNwVChSvHJU7e2f9ZA7N+wJ93XB3XgyW98A5nowDwSb5fTFHbicSjWv6XK1D
	yWIhUsZXC1VHQsKj9s/FXKvoQ7yJ2CI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bCSjHtCh;
	spf=pass (imf18.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=yury.norov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-786635a8ce4so12477267b3.2
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 19:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762573158; x=1763177958; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9h3FkFllvRL301ULuxgOtHl5uOTbxkQC4ivgx2/U0MM=;
        b=bCSjHtChKz/JwO1DiXlaY7zKIHH2ZyiqJFncHGIT7i18fx8RFQcztKiyNvMg9yVB12
         H8DLgxK9TiYT/8Kq4rY76PdYcHs86fFWlwOxkhNcbjtVKYdhciXoi1hlwDQCWHseTLDu
         7+x41bYR+0khiAccHfCW7fFjNW50x3HJ80dVHz4yp/ifXct8WCpa9ZTqnwDDpvboRh4Y
         klycG7FCnLWpZmQy8vDaWKq8Pd4UPi8LW1cbBNr1BogJpwVSHJWPqItT/HgU0U6YspF8
         SeE1KhHy73mpFSCb1X2CfvBPhIGVj4OYUv7H+YpT3NLLUZPg/moAkP8x8Qqdso/TEOMR
         4cQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762573158; x=1763177958;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9h3FkFllvRL301ULuxgOtHl5uOTbxkQC4ivgx2/U0MM=;
        b=k9JlIJxac805soEtz+YDYaMPO2S5rW5NJeEmNDP2yXRQ77D8URH2lkwiZ3S5ixKmb6
         9v5FcIybrKKNv7KpCc+anfU/7lBVwYoMuXcvQAwhyhq8jL8rbWYA6pPCmK+9hhIH3pBU
         4KL4pLrb00ksy00UsXx1At3xQq/7OINUQGBr+UQGJGU5J6ADC+n3TSCoVydU1ZilmjE3
         d3Em3c4GUFFgAGG0xM1LFATziAGR/DD8HJoVari6AnbYMAQ67527/3IeBD+JnLRRUr0e
         WeGFPAqzqjIRJPnD/wxBG8lTv6oH2h5HOog3TioE25y8BQb/FO7kDeGauw+FtfWSJYxk
         KSHw==
X-Forwarded-Encrypted: i=1; AJvYcCVU+4i2w5xb2eylfpLbfbqxA3pBYaCSOqAasxNIcKtpKp8QFZbPl4W8PBu8RV5oGg1IfYKjULpwUA==@kvack.org
X-Gm-Message-State: AOJu0YyhHBaDamaPk/e1GymERhkdhqzroEmlHBjZlDGthBDPlh0vb0Hx
	mUZhpixyRnTaz+Gf9TU9lCBneRLbPRJ9lMjeQqNBTJsscA3vo/u3AowB
X-Gm-Gg: ASbGnctyoYmiIbVzglwzTt4J5fW+ZqskyIdTx190fAGfSJwr5iYTHWRp1v2BTIuowr/
	zC3lZ+7d7spyWw4Xy611ghUUm248ij1Y4QLvdl68N64ob2/iEYmxu1WvYCCq3Pq9QCQn5waHadX
	SGzQcAVZobLt2mFGv7iwHZN0hBth1NNPE0U1a1MdwlpKNMIKtIPVcqOlLDhaB6uwp44z1bYEVAR
	CY5wcjMEPV6cFroXKluNc9giJBWnWu8tf01iPtBEGTl3StNJGVSaH99Cf14Vp/2YFItxVMzO+7n
	XNr0rEjyozEES7kR+CAp52NabMOHGkj6ax4jb+MpBhsHmANMIQUcb4+rJT0wy1QP6d8U2jwDME4
	GOLf24FPSuoUwErVutTAfJv8AgfADCxS/r+gGVV+EsBTZZjtx0qZPmW66Uva/OL0HAHx6i32XAq
	zip0TRbS4aygeTjzMOa4edw4ZY5HL8MFNswJDveniM0cU=
X-Google-Smtp-Source: AGHT+IFYVT1fUkHV6VJLT6N7hlDvCT+tD4Kfn+cnUafAF1yf5tELB6GAdHtxmqPcstSWjWMEWAfufA==
X-Received: by 2002:a05:690c:6e0e:b0:781:4b2d:7261 with SMTP id 00721157ae682-787d54156c4mr14832407b3.41.1762573158025;
        Fri, 07 Nov 2025 19:39:18 -0800 (PST)
Received: from localhost (c-73-105-0-253.hsd1.fl.comcast.net. [73.105.0.253])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787d6a2947asm3452237b3.55.2025.11.07.19.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 19:39:17 -0800 (PST)
Date: Fri, 7 Nov 2025 22:39:16 -0500
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
	Tyler Hicks <code@tyhicks.com>,
	Allen Pais <apais@linux.microsoft.com>,
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 1/9] rust: cpumask: Add a `Cpumask` iterator
Message-ID: <aQ67ZC__zN6yt7Ln@yury>
References: <20251105-rust-percpu-v4-0-984b1470adcb@gmail.com>
 <20251105-rust-percpu-v4-1-984b1470adcb@gmail.com>
 <aQ08d2NUVsIf5ukH@yury>
 <690e897d.170a0220.3b9532.0c02@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <690e897d.170a0220.3b9532.0c02@mx.google.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 14F2A1C0004
X-Stat-Signature: fzr8gfhxsns88qyuuphoaajhnboqmuy8
X-Rspam-User: 
X-HE-Tag: 1762573158-868029
X-HE-Meta: U2FsdGVkX19QyPjMuJbozDCVkN9ShHsLiTrV8ujRCYDuKI1V9h0+SSvx7NE8OUmhvkmwOTTzcEaZZIo+RWtbS/GIPf8RL/WopAKOWEegC//Tke9vE8tVWsWYJKkZVxYqL4n3VhPIoTNu6UvwXNq0do7zzFv0/cPy0ztmOKWkC+o4t9bekdRYQLAfkd9YVNU504jYiJJM32rIw1frugstlkXCXdOJ34+S7VVN9S8/0ySDSeHyXnvO9MLHbjup6gMMpMNyuP26c/RftGTKsPxlmL2tgHYIBT+Pt73PkX+IEWek0SqdB9s5BGHBWl+tusG28PnHDbrKXlOfzdgGwJJ/vdTQRbDF8QMZbLtEFhhBbw1/4bOe8FNZveZyCcKa8V0YTZAvzUSLnB7WCzLrHu3+F3a3KSHIoGNcwMM86jeWGq3SfWFEHK5JOvF7G1P5Xhzb4EIp3OeRYygJmoA3Z7jvhoQnaPnTJUvr+zHguqfM9EEafwvIKh+LWrTmtKLwQabRcNOI/njl4Kn56HF3Gok/v6Hn+p1ABJCarLrfkEJR9AeoQjS38YrmTQC3PjyqN7ci8Je1VKTOMT7Qdu1GCEGSG30b8frGJS9bPMHYl9gpIiC/UcFrN8n+TvORz1jEu9eoNuZh3B9xZg0i3oaGrl0Idf/02/sCKtySR/2xZTdK7RiYdDZsSLAmnMdBv3fB3BD/H27y5KvOffSjcYY69+VGbAGWJw4OYovPr9FEA2w/k7oBMbi9LMrN3cGF13gYvyyJ/nJYIVvf46rT8RWhheJ7Tcb5EjMYV/qZmxsr96KX4mI6ZSgMxqmN5+cTCnFF/Zu4n7TI6nR4yeuQoA1k23fA76zYK52QrCHWMUbP8Rdw7UB4IeKatPHpKbCRXUErKs2or3Q3ZBJqVgVmYFCRJUgKcEY+VpCUbTGHj4n1n9AN6SLHUyONjBfyDf05G1C44bZCYjBNEzuru9e9k5t76a1
 pDxAqyuI
 QLTEKg/pD8OAjTKiq9W+9j5lLJzKiCNQR9Z9HW2TgqtfynvfcVfPvwZY8M+SI79vGByx65nk2+r0mOqi6EdwhdXmNVKmpJtgVxpsdxM1mG0bluAopDDe0jXxAaO3W2KVMIheG9mAvDnF4aaOepSxo2EcQ+bp+cCnIXG2vkxY8dFuoP8HwYbjNugnptiUHV4TZaHyICZ5utN53HfCkhiPdCPyeD6ewo/guBABtHs9TbDJif54bwAlZ1x5MN37HQjK1nieM9UYQmtuqEgM5OUg5OBIYrDeqTOZ68VDPiAam7INa4iF2ue0KLxRvuNgO1lXkxamn5v8QGISDn4PO6M6kD/OVwOotcwrDlh+WsbGwMS2W+vHmPWa1/7USxSVq3hF6Sn1dmdkgVnaZDASaCaaif0E4C6lwSIFzk8hz55F0LoFb5nT1nsTo/IxiToLm3TVbByBpQCfaFmVTG3RXewLfInthkCgxKJGNTisKBRT5q+naDnYOY2Lgjnvw9pRkzWx5di0B/F+LRie4eZRq1zyErv9QBSbMTNB95JoPn77aCncN0dw/rPouFz0wshzdbo7MZN7RmyOz6QMN7wuuavmtHXGUSXRQNZ3/ncF1MfQesrPQWxuENBsCfQue4lpDGBD8DLoiZqnQXWKXnbI4PiYJ4WwNVllfISqcS9Jg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 04:06:19PM -0800, Mitchell Levy wrote:
> On Thu, Nov 06, 2025 at 07:25:27PM -0500, Yury Norov wrote:
> > On Wed, Nov 05, 2025 at 03:01:13PM -0800, Mitchell Levy wrote:
> > > Add an iterator for `Cpumask` making use of C's `cpumask_next`.
> > > 
> > > Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> > > Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
> > > ---
> > >  rust/helpers/cpumask.c |  5 +++++
> > >  rust/kernel/cpumask.rs | 48 +++++++++++++++++++++++++++++++++++++++++++++++-
> > >  2 files changed, 52 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/rust/helpers/cpumask.c b/rust/helpers/cpumask.c
> > > index eb10598a0242..d95bfa111191 100644
> > > --- a/rust/helpers/cpumask.c
> > > +++ b/rust/helpers/cpumask.c
> > > @@ -42,6 +42,11 @@ bool rust_helper_cpumask_full(struct cpumask *srcp)
> > >  	return cpumask_full(srcp);
> > >  }
> > >  
> > > +unsigned int rust_helper_cpumask_next(int n, struct cpumask *srcp)
> > > +{
> > > +	return cpumask_next(n, srcp);
> > > +}
> > > +
> > >  unsigned int rust_helper_cpumask_weight(struct cpumask *srcp)
> > >  {
> > >  	return cpumask_weight(srcp);
> > > diff --git a/rust/kernel/cpumask.rs b/rust/kernel/cpumask.rs
> > > index 3fcbff438670..b7401848f59e 100644
> > > --- a/rust/kernel/cpumask.rs
> > > +++ b/rust/kernel/cpumask.rs
> > > @@ -6,7 +6,7 @@
> > >  
> > >  use crate::{
> > >      alloc::{AllocError, Flags},
> > > -    cpu::CpuId,
> > > +    cpu::{self, CpuId},
> > >      prelude::*,
> > >      types::Opaque,
> > >  };
> > > @@ -161,6 +161,52 @@ pub fn copy(&self, dstp: &mut Self) {
> > >      }
> > >  }
> > >  
> > > +/// Iterator for a `Cpumask`.
> > > +pub struct CpumaskIter<'a> {
> > > +    mask: &'a Cpumask,
> > > +    last: Option<u32>,
> > 
> > This is not the last, it's a current CPU.
> 
> Ah, I meant it in the sense of "the last cpuid we've seen", though now
> that you point it out I agree the naming here is poor. Will correct to
> `current`.
> 
> > > +}
> > > +
> > > +impl<'a> CpumaskIter<'a> {
> > > +    /// Creates a new `CpumaskIter` for the given `Cpumask`.
> > > +    fn new(mask: &'a Cpumask) -> CpumaskIter<'a> {
> > > +        Self { mask, last: None }
> > > +    }
> > > +}
> > > +
> > > +impl<'a> Iterator for CpumaskIter<'a> {
> > > +    type Item = CpuId;
> > > +
> > > +    fn next(&mut self) -> Option<Self::Item> {
> > > +        // SAFETY: By the type invariant, `self.mask.as_raw` is a `struct cpumask *`.
> > > +        let next = unsafe {
> > > +            bindings::cpumask_next(
> > > +                if let Some(last) = self.last {
> > > +                    last.try_into().unwrap()
> > > +                } else {
> > > +                    -1
> > > +                },
> > > +                self.mask.as_raw(),
> > > +            )
> > > +        };
> > > +
> > > +        if next == cpu::nr_cpu_ids() {
> > > +            None
> > 
> > Please:    if next >= cpu::nr_cpu_ids() {
> >
> > > +        } else {
> > > +            self.last = Some(next);
> > > +            // SAFETY: `cpumask_next` returns either `nr_cpu_ids` or a valid CPU ID.
> > 
> > Now that you've handled the no-found case in the previous block, the
> > comment doesn't look correct. Can you either move it on top of the
> > if-else, or just drop entirely?
> 
> Actually, now that I'm looking at this again, I think this whole if-else
> thing should just be:
> ```
> CpuId::from_u32(next)
> ```
> which does exactly what we want here. I think this should address both
> of your concerns, though please let me know if it doesn't.

Looks like that. 

