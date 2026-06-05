Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E675CD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 14:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C9F86B0005; Fri,  5 Jun 2026 10:54:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57AD86B0088; Fri,  5 Jun 2026 10:54:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46A086B008C; Fri,  5 Jun 2026 10:54:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35A866B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 10:54:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B9EEA1C0617
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:54:22 +0000 (UTC)
X-FDA: 84846154764.07.23D103E
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id A14B8140014
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:54:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VfF32TBA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780671260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iMx/nHWOMEwtym34VZ261ncrvtjhMvq2oZ5WpIEUnq0=;
	b=Tf7C0gPEdcnSRvO83FwAzFfzISaDlwFznUn9OkIOvGI039B4qVxIfczN0xuE/0zfloa3ne
	jgNb+qlW3y19P1d2daOOzKZP9YkmF5VwwktpLDyQ1N9h571uds3A4huslw0uB1Nr8mcUJi
	a+DCedPX62/WzUl43h9wOyHQaFu7o5Q=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VfF32TBA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780671260;
	b=ZtcoZ6bwUV6NiBb8RZF4V8nSZaT8GuVHVW3ETPqITvjVZKyYHWUAqQfJGW1J4rxuMQi95G
	u4GxvP+cAQnBP8w+gAvm8OpcD20re6B0iXzlvdOeB437PE9kaVu0V1laPWykOGJQurr0FJ
	gpA2f70shcUQwTIFPlEYo8h2RM8piVc=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-45ef779c1c2so1392416f8f.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 07:54:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780671259; cv=none;
        d=google.com; s=arc-20240605;
        b=KN8umAGb3oeP6yn3kQLS9nSUvrEHf+wOB0+qPx9mKOO88HnmhtangeimHl1hpSjOVH
         5rueJUfVLsNf2WCnUsrNKAJeembjVkzxdOyCZziOuaVRYLHhxKl8RluQy56CwVTPnJKc
         oAuieSK+fDsIDQJCCwX1tVH0eM0dTPjAcvAJvWXacu+U/k0sbchGxp1+GmvPBtdkcQu+
         6DOz5XtofjMVNX9BE6oVnoKl2LSzSb1g54V75JacHXeTlWa7U10DXvf1cujvr1v5558F
         3mZYJ/t4wBW+dwDv6zyz4A3NE/K7qU+l+rCyV8COEoQfQNIkL6zHbm5f6pXRQtandBmA
         FzTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iMx/nHWOMEwtym34VZ261ncrvtjhMvq2oZ5WpIEUnq0=;
        fh=vVltJpwrprOF6PcER6QkH9xzWf0O+5Ex9okdZZjCuWQ=;
        b=e+bH01zSURl1m6fhJ3+g3OhZTDbK2UpAKRRUa9ywLZ207Ry45BdwZkRZG6vbA1FVCr
         Ov3IptS7U4x3u7gwvjcqpxaWYjU89XTAEWaX3phOvN8hLvWI5BSh35ZjGUsMWWZrkTll
         6NpQvySVNF21hqt2fG3/oMV6pv3KcTn7hrU7oiuVPRS/stvlW1UX0a5xfZE88YiTHAlR
         cF0z4Jztqj0X4Cr/M42ibcHppZnq6vuT52/qwocNrOV4Pzm6jY7o5h1wnTmfCVtMZM9E
         M+v6lhbCPnhf1Ymw+SAvZ4JzYvdMT7VdN+fn1EXth6M7/7D6Ki1PSELazeR4XPuDwtPH
         +47A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780671259; x=1781276059; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iMx/nHWOMEwtym34VZ261ncrvtjhMvq2oZ5WpIEUnq0=;
        b=VfF32TBAmEwEVoSZz4nu6a5g3F7UYrttCc6kMHqKsfBv1jvogZMxz3BveXQbNNe2Nf
         8wbqytmIoyxxbIRz2AUNJyu096MpWm3Nt51N5/5GtDnwPClSTJEBNRHE1Fa1r7YB5vwn
         tTW6FTv0cXbPmA7A4dnsSTMVMuyxtwrR3mfPlTWah5Ip0RGjL8yX+kHR20j7DLDZX8HB
         Z92TO9HsVt8zVS5T+7su3CfcUjfmiTIG6M4KueSzyTwS4+L/cwcHBgC7uOxaYWeTVN1y
         rYKBN1ONynCF2TUtc8eAachHyArDqkOt86cKX1BL9ncf8TmdqxsTji86tkccrarp/++9
         CGOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780671259; x=1781276059;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iMx/nHWOMEwtym34VZ261ncrvtjhMvq2oZ5WpIEUnq0=;
        b=hbCtKIfPXOhe7zIL3TvFcjTIDL5cCk6kLJDrIT+FaDf8IvQ+ohWgiD+pmgIOE9llWO
         DmrmbYhMRJIp72CBc4htQHtROhSFC5RhMq7bwBILm6FNHQmvLw/FS1XX8OUTO575b5p0
         8Yh7dBsNvyU0hUiR160p/35zo6LEV1Q5ha79yI74fDIyeo3V8DAAlBIm9amCo8rVdIgN
         8EHqQ347dVEXoG3PuYtUHmuyGtrdxq1vrLsQ8VwjdnlN4PbiLUBz9IU3tG+UdOr011oN
         gkkRvtVOKZ8Bd1a+xgoQE1kW6LW535t/7jhqOAu4qKpW6jPAjMmmXxs25MVIfWNm38yz
         9LMw==
X-Forwarded-Encrypted: i=1; AFNElJ/jvC2QODpOQ8HogO709i9/2hDVPVB3shkR5OMWS/Greswiju/nKWfY1/uoWRmVORqEeCCPeOjfLQ==@kvack.org
X-Gm-Message-State: AOJu0YxYvOXv9OQiWQ0Uce3jD7/5tPazS4BVVvPOZ0Wn16l3RtI1iChH
	4g32uMZxcVdO0g+UxfnRljPDUhLuoj/WeAkwjnUayuhHTpkiijaInHrvlyYEcFZqKVo8LP8+yeV
	y2XU5NfE393cvafU095Tf9LiwAbCMACnrCJnIeOEc
X-Gm-Gg: Acq92OFanM0Th5aYUj6F1s8TLOjkUGtlr3q582opoQBtlUZbiiV6ykNIukKofVC1H8j
	Q7e6A1crvxLv8NqBW2ROH2yqTfKvFEA2Da44pCID3FXVycS3oZVlIJ+joLu3oyg1T//6a5K7QWr
	OExcLASu4WcQMwKQvk7usDUOtP5JVdOOjt0EiMDZPJr3OHeJxPhLwHJZiFU4qTOQGWUpLTeWERW
	7Bfiz4T1IVv3ii2MFeIk4ySD5n6MiLS2TnYxZAeHjUopvtZpBFVkJKyWnbZIFugPvR+l0Z476Vs
	4YeqGFTM7kN5bP2F5xbvO2nsdpPWdg2AWoU7WTAFu0zZuXg+dDHev6jyZuM=
X-Received: by 2002:a5d:5747:0:b0:45e:73b4:85cc with SMTP id
 ffacd0b85a97d-46030762e2dmr4902991f8f.35.1780671258380; Fri, 05 Jun 2026
 07:54:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260605133541.22569-1-boqun@kernel.org> <20260605133541.22569-6-boqun@kernel.org>
 <aiLXWHg22P6OTb7O@google.com> <aiLbOd9BkRrrzauk@tardis-2.local>
In-Reply-To: <aiLbOd9BkRrrzauk@tardis-2.local>
From: Alice Ryhl <aliceryhl@google.com>
Date: Fri, 5 Jun 2026 16:54:05 +0200
X-Gm-Features: AVVi8Cdg9vKBauMx2gFlTcbSb2NA7zDY8I7EUodYwLM12r5vWqTj6E3w8SCGnp8
Message-ID: <CAH5fLgiBayr6S5ijfEdXNgZqaZvFbKWqLvVEsVePmrBybqDZzg@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] rust: rcu: Introduce RcuFreeBox
To: Boqun Feng <boqun@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	rcu@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Andrew Ballance <andrewjballance@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Frederic Weisbecker <frederic@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
	Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	Philipp Stanner <phasta@kernel.org>, Lyude Paul <lyude@redhat.com>, 
	Daniel Almeida <daniel.almeida@collabora.com>, =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: fz1wkf78xnnriaj4hniscthyppsbmm9p
X-Rspamd-Queue-Id: A14B8140014
X-HE-Tag: 1780671260-930100
X-HE-Meta: U2FsdGVkX1/FpjLVLKpR/cvZ57zTmCClJ6lCNmHqSrTUBu0NZdTJ7zzKdHD8b19DkJVn4muT/DmahUHH4cfTzsxnQW8EaRHKctb/NFFvYxnX3yFFn7bunWdXJUc0CwylWIgT5NgRcA+lDkWMIlFSN19yk/0lxjcNQHVo2XlwtF85K79mwzGDRhQ3ykqNPXSJaCKUGPS0zQkS+I8KMa7Az7GNJgcnoiSlzuCTWEy69BNB6mzOkkbiYZr6JDx+nnNi8+n12GcHcYlgK2dk67HOY86+/g5BjSQAoUkIxJmYK4FiuXRM2xwaVzZ9O01u5fNYdXt/bUfPxvrAd3fBQUMvEcziDsGO+LksXzGPFAnCVmLj4+kbG/tARAIA7d7Jx3DwC6KoGzBa6EaNQdN6N/a12uIenrwI79o+ohwOWthHYZ7LO+qT2JxMwirBsBkL3eMH8goomCxi3oHscpokp1xn99w99Nmn7TtjopIb4XgESfj0VjzWCk9X9qg/hzLxzCU3/OGI/vc+EYmOsOn8j/p8f1N4x5EweRWn6klvAkqtUkkHszRbnSl9V6QXfCZlm/KHMJD8O4SUrl41+bNonXM+MgI+rn8NxSuu+GQXB1SbRDCX0w8XvU5p4hguN8dEknrYPNu9gsujvOR79PIY5vSc2Uy0X8Uc9BDrPNRlqxjwxlGX5PoOHs8o+WxCTXKDWd0kMzuzpqxcinXOB3Be47OQBZdfRS2V4aEQyHU9l4wCCapQj2t6zHkfzTu/h3Y07uCBZhFkSPLnrhYHrr8o+Op0YO3PvL+VvJajGtz+LdlheTi0Cx3Fb7MyHjStUPjmRcKljGDtE3LSUqRC9qNKCw+7tfW7FO/CV6MbbbBfuPiM0yI01AcpvDcWJFrf3cVduTvp+oo56sX7vpodRL7C0aLA/uqC/nv3TPvXO8uiz+sd52baC+DreHgnkhAAbWhQz9wd8sKKqVYKtuYn07EbSYQ
 DVs+YITP
 1KPfItWfASImwRsFbfjU8L6ivhHpjMUT6UXGeoj5/Iv8DUTSBo729LiblTW2ZIsMKgHlcOEQbQVfyhPGs3L4KUr0p/Q2mapQs2Qqw4vBtIaydCUJe6sxMYG5Ms+iC95HTj/L+M0Hj1yiRdebK+2Y/U6i1TJEKSc1Wxs4px0ifVVATtoppwiblxM9I/2Vez86PPmpMbafOA0LbKO76GvW8wBGLmqpgghzGTiwUO5dAQ9hdTys0Dgz73fxW326utCsyrb96aqDhEzQ5pW6NMsLO3Gj0i9m7cDuaG2UEj0702bJxYqQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 5, 2026 at 4:20=E2=80=AFPM Boqun Feng <boqun@kernel.org> wrote:
>
> On Fri, Jun 05, 2026 at 02:04:08PM +0000, Alice Ryhl wrote:
> > On Fri, Jun 05, 2026 at 06:35:41AM -0700, Boqun Feng wrote:
> > > The current RcuBox will call the `drop()` function after a grace peri=
od
> > > inside an RCU callback. This suffices for maintaining a RCU-protected
> > > object:
> > >
> > >   RcuBox::drop():
> > >     call_rcu(
> > >       |..| { // <- call back after one grace period.
> > >         T::drop(); // <- call the destructor of the inner object.
> > >       }
> > >     )
> > >
> > > However, to support a different RCU usage pattern as below we need to
> > > extend RcuBox:
> > >
> > > 1. clean up the object, and unshare it from future RCU readers.
> > > 2. wait for an RCU grace period.
> > > 3. no other RCU readers, we can free the memory.
> > >
> > > An `RcuFreeBox<T: RcuFreeSafe>` is introduced to provide support for
> > > this:
> > >
> > >   RcuFreeBox::drop():
> > >     T::drop_before_gp(); // clean up and ushare.
> > >     kfree_call_rcu(..);  // free it after one grace period.
> > >
> > > Signed-off-by: Boqun Feng <boqun@kernel.org>
> > > ---
> > >  rust/kernel/sync/rcu.rs         | 31 +++++++++++++++
> > >  rust/kernel/sync/rcu/rcu_box.rs | 68 +++++++++++++++++++++++++++++++=
--
> > >  2 files changed, 95 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/rust/kernel/sync/rcu.rs b/rust/kernel/sync/rcu.rs
> > > index 7da6b8d22277..7c26591bb318 100644
> > > --- a/rust/kernel/sync/rcu.rs
> > > +++ b/rust/kernel/sync/rcu.rs
> > > @@ -4,6 +4,8 @@
> > >  //!
> > >  //! C header: [`include/linux/rcupdate.h`](srctree/include/linux/rcu=
pdate.h)
> > >
> > > +use core::pin::Pin;
> > > +
> > >  use crate::{
> > >      bindings,
> > >      types::{
> > > @@ -82,3 +84,32 @@ pub trait ForeignOwnableRcu: ForeignOwnable {
> > >      /// [`from_foreign`]: ForeignOwnable::from_foreign
> > >      unsafe fn rcu_borrow<'a>(ptr: *mut ffi::c_void) -> Self::RcuBorr=
owed<'a>;
> > >  }
> > > +
> > > +/// Declares a struct is safe to free after a grace period if all re=
aders are guarded by RCU.
> > > +///
> > > +/// # Safety
> > > +///
> > > +/// Implementation must guarantee `drop_before_gp()` makes sure no f=
uture RCU reader will access
> > > +/// any part of [`Self`], as a result, after `drop_before_gp()` retu=
rn + one grace period, no RCU
> > > +/// reader will be on the object, and it's safe to free it.
> > > +///
> > > +/// Notes for implementators: implementing this trait in general req=
uires `Self` being a
> > > +/// [`UnsafePinned`], i.e. a `&mut Self` is not a noalias reference =
if `Self` has non-trivial
> > > +/// `drop()` function.
> > > +pub unsafe trait RcuFreeSafe {
> > > +    fn drop_before_gp(self: Pin<&mut Self>);
> > > +}
> >
> > Should this have an associated type for the rcu-safe view?
> >
> > pub unsafe trait RcuFreeSafe {
> >     type RcuView<'a>;
> >
> >     /// Access this value in a manner that is safe after
> >     /// `drop_before_gp` for one grace period.
> >     fn rcu_view<'a>(self: Pin<&'a Self>, _rcu: &'a RcuGuard) -> Self::R=
cuView<'a>;
> >
> >     /// Drop this value in a manner where it may still be accessed via
> >     /// `rcu_view` for one grace period.
> >     ///
> >     /// # Safety
> >     ///
> >     /// All other accesses to this value must happen before the call to=
 this
> >     /// method, except for accesses using `rcu_view`.
> >     fn drop_before_gp(self: Pin<&mut Self>);
> > }
> >
> > The idea being that once you call `drop_before_gp()`, the value
> > immediately becomes unusable as the type itself, but you can still use
> > it via `rcu_view`. The `RcuView` type can then be a type that has a
> > subset of the type's methods that is safe to use for one grace period
> > after `drop_before_gp`.
> >
> > If you define the trait like this, then PollCondVar becomes RcuFreeSafe=
.
> > It can't be RcuFreeSafe today because you must not create new waiters a=
fter
> > `drop_before_gp()` is called. With this modified trait, it can simply
> > not provide methods for registering new waiters from the RcuView type.
> >
>
> Good point! But I guess I could keep RcuFreeSafe as it is but remove the
> `RcuFreeSafe::with_rcu()`, and this should be sufficient for
> PollCondVar. I do want to wait for a meaningful usage of `rcu_view()` to
> add that, but I think your idea of that is great. Or maybe you have a
> potential usage in mind?

For the dma fence, the fence context would let you access the name c
string via the rcu view.

Alice

