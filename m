Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCB96CD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 14:20:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 215F06B0088; Fri,  5 Jun 2026 10:20:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C7056B008A; Fri,  5 Jun 2026 10:20:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B6066B008C; Fri,  5 Jun 2026 10:20:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED5A36B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 10:20:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9A0861A0002
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:20:47 +0000 (UTC)
X-FDA: 84846070134.16.02FDAC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 91191140012
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:20:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d6bDNQUP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780669245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rZm80SCqfNzEoYvnBtG8GQgboPdoaSiQU7oZ5wE97mI=;
	b=da9fuZtL3iLx84LxAc+rA9cgJw9exGfWCCPfVYQorD+v9y45EKvM6IcgUfxkYqTxh4/Udu
	okuvSqhBN8PNFQPvpvLleVgVLmn2MoQvYbTwRGk9SQOsC2qmFEENR1GmHchQZWtiPs/0QK
	3Y60aADN8XddrQoma21gBdylGj+Lz8Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d6bDNQUP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780669245;
	b=ekyxz8D4Jmv73NaOj/GIxNga7gyg7PGr6Lcj4sCXTFK7edT+GUI3hi+I93E5g1vbK98psA
	VJUT3M/9phZifoWjSMBvAR7umkHOsiwv+Vu2EbSGMtLSgMN7C3ezDCgO2PWvMEYWZsOaPi
	odP3kEMK3b9G7enxqxLETWQPxaOcjNY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C1A35418D4;
	Fri,  5 Jun 2026 14:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8691F0089B;
	Fri,  5 Jun 2026 14:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780669244;
	bh=rZm80SCqfNzEoYvnBtG8GQgboPdoaSiQU7oZ5wE97mI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d6bDNQUPgpcbZgQiqdR7qpbaVpZqpX22yPzIfuJ+X+GJfUbzwzTmhRuFueQZrfIRJ
	 qxAYnTx7PSD0kxAIrvwBFLS0tADeNc8ISDI/ttUfp3PuPFPJm1KN14jN4sB6gBG/3Y
	 D3bUHFjFi4zKYwkXGsgm7mJvlUoXjGzzhmsJ67QqBI1WH64oZLV3DALzl2SrJvt56j
	 4rt427WTisuUzs/KQveAhMuNFDFthyZOV9ep9fxi4DeqU/w1vvIQQ3NTAGZ5xtpgMt
	 sCnlDWere+e/wn3rpGd8BEgRxwFmJ5ECnsmG0x5jGfDZrRX7d48ldKejKhWolQuCEk
	 NxT4/9TkH5ojA==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 11C11F4007E;
	Fri,  5 Jun 2026 10:20:43 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 05 Jun 2026 10:20:43 -0400
X-ME-Sender: <xms:Otsiakb3VgscOwQzObb9TnmCmdWfqsPbh1aKv6Ob1Gd4GnMm7g45cg>
    <xme:OtsiaswjOPU2H6OSi5TRRzTWJN1oxdosSHMWKU_xFLsbRBHQpEW6NqVq9E3l47Ar_
    _lgTF2cByW95QA75xv5ldkBLiujDQu1BJ0vYDNKrvTVE-_5bXKSjw>
X-ME-Received: <xmr:Otsiaq96ApZ9LuO6DemZFypZXDeykSN9R4ZWEMcOu325AV7T_b7aEirzjVs>
X-ME-Proxy-Cause: dmFkZTGmnYP5N/Y3347uBlTz0c7MclhskUD680CYIEvbldBBZOlbo8Ym/SOIKA+wnzZwqu
    zergSXkVsymVPFOH0pDne+qgzS+nkBAu5N0axf3sYZRo2nvTNCUjtPm1MMQssycnGEvk2z
    yaI544/RtZ8irsNtuXAmHJZIpjSaeCpLMs7XgEV+/rn1pCm2lHwIKR5NxoLv/Kp7KTgG1Z
    lLY1vZh76vKJ+oN17gUDdN0Th/LrUAsJPcjSsE776bPWq7CPgQxyXYzm+Vjk8Dm/1y02fb
    puunQqufAKdZiWOXFH4RfjlNHdhu4yzA3qQXzyuuNqM/+68+zvAuDsnJfYTo4B5CI11KSz
    0Z/h4GuSIxa5oqGjjmyx76Enz2u2eUx7GXT1PNjs4iwrlg39TUG6FjeYF87UoM4WeCLG/r
    xouuK/m/Gk1nqyzUOYDGO2U+yhP3S8w2gDavQX3jstdmU+W0AE2r+P4S3TBS1qziQ3CO5x
    8+wy91h1pK5gBNMtQgKVrEL+9GPYeWmYLnGblXrzWiFcUFuEJ8RjuWpZ2Roa3wu45wsPGh
    j2ArhLYXf5wYyOqLiXH6+dkO55yhJCVHrgy+4O67SQ6ZWH6nc5ZcdT7S5//okCwxaE7/Mt
    4OEXVNhzWwVZuRMC7T+q6xEjTLQdr8IO4/n51Tj/DiPrTPnbPzY2g+Kmowwg
X-ME-Proxy: <xmx:OtsiaiX5ZZYYUUWBD0GFrR8lNA7Remyu638zwCJRWBzviig9GfKXew>
    <xmx:O9siarOe-qdwbCXDYWcMKzCkwHhGyJk4yeG00Y1xAGgqgVNz9avZTQ>
    <xmx:O9siaszJbtt1LQ2ng-3qPyR_1TRzEwSqe6XFTozbY0hJbDwn4etASw>
    <xmx:O9siajPKFsXAgrpE11c85DtWGygRvW1UO8lxWAUqZ5z_ine-CUmJow>
    <xmx:O9siaii1Yx2gN81YC7CB5PuXo-Q7xO6ltrA6zbuXUtHBh_gZiER7_fFK>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Jun 2026 10:20:42 -0400 (EDT)
Date: Fri, 5 Jun 2026 07:20:41 -0700
From: Boqun Feng <boqun@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	rcu@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,	Danilo Krummrich <dakr@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Ballance <andrewjballance@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,	Zqiang <qiang.zhang@linux.dev>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	maple-tree@lists.infradead.org, linux-mm@kvack.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Philipp Stanner <phasta@kernel.org>, Lyude Paul <lyude@redhat.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>
Subject: Re: [RFC PATCH 3/3] rust: rcu: Introduce RcuFreeBox
Message-ID: <aiLbOd9BkRrrzauk@tardis-2.local>
References: <20260605133541.22569-1-boqun@kernel.org>
 <20260605133541.22569-6-boqun@kernel.org>
 <aiLXWHg22P6OTb7O@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiLXWHg22P6OTb7O@google.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 91191140012
X-Stat-Signature: u5u5a55ye5xwdyhnico3og8537ou9shw
X-Rspam-User: 
X-HE-Tag: 1780669245-891991
X-HE-Meta: U2FsdGVkX1+LsXP+o84VpfcCIBZa/hj3sa8t+wlxyOLHxEE6nZduY53zdkJy/cbYBeBmTeIY0hP46q1G9/+D2REnb8CwC4R2cdzWqyaDE7ZMJ1RbIHHP6XCji8deafYNckWACJgF/i1BFGpcTTHeS84ZvkPC8XVR9VHA3hJLP1bqIDmHeniks/BMB8Kj3ISuDXqvyH9suwFTtvXWwBvFZ1bis4jZh9vVTgwCQGabpujWqQZVUCcy50nKiRfm+ZLs+GKeEWEAUgU1Qq/D1qBg5FI2x/RnL8d/m3R3BN0ZQoAIazA2LqQzcmldmSKgeAZA6nsWrkClFTDg1NVOmS59wasjgUfw/rbXehLHEawREuj/AVkNbzXLqKD8d86eMWWndeXtPldnIcgtMPDUF42c0s9m2+3kqdxRFu4hPP251LMCNY1TOcMWjJVTaXEIm2q7XzpxlnseK/MinO79n2SGWfNrTwRzaCaV+NcqMVM1knhv1Omvp4k7ga3bFgrWCuxlrQYZd8UJymf0rV6L863k5F26wBsdhzWO7/76tfiBsn0b/hTQLRCcCu7NnrUiTWerUJ7nVCdm1UrLKTzUw6M+yhCCcEc4VtGlTNGlAIRjHiOWj0pPUYR0Fl491cLntlvfOg/J1thWFJ0IzQEHrCCqP4hyGobbtBz8D+BQPj09esCvcqcdB6S9A7QhRZQoE3LLJNmc1VA+d4xkdC0qDEwQM7VBHaszy0dNLNs7DcG+n+51tBHIL/sivT8JEpGvSvEZKAed3AI0Ytj0bAz1aBUCLpDKuEYvRR3Pncq+POJecKKRw6ibdcRyGRCBfAGHoTkLLSKqZt0MEYyqtmv+EID4J5DYmSmxNe2UgWrsmGiKYSsYZFgxJp2jrtgoD46nPXqdD7xijzinJ0WpYq1NjD4FsSJKBDprBjsw50GHdcEzu6sbafQQfa7wN8MFjz+AhLpEe7mfzfo0NKryjHoyZCV
 NbVI4JKs
 NSQvGwsXbsTkuAis6kubdAwXhmIEqCMKGM97qMh39/2C8IHK8yb2sia8YpGlG587tWmqIB/EzHGwVjIOpd9appP6dkonKKiOMOippaFiJFOZDXS1YCZQgxdbp62Wq8QSSTZsLt2cM2C/UuPEXsxfaUg6phJzYZ+IoBft/TKi2AG/m0w16WePwzDMZTZfklrJYKgzgJoK12y+jY5282BLDP1c0hZ+uJ5hpbyGhGIx98vss8u1tK3PNrPFaleRmNOdwIRUqV9/sNS/tvnM9Es7JIknWYK/DuUXg7F8zorOsyaG3YSk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 02:04:08PM +0000, Alice Ryhl wrote:
> On Fri, Jun 05, 2026 at 06:35:41AM -0700, Boqun Feng wrote:
> > The current RcuBox will call the `drop()` function after a grace period
> > inside an RCU callback. This suffices for maintaining a RCU-protected
> > object:
> > 
> >   RcuBox::drop():
> >     call_rcu(
> >       |..| { // <- call back after one grace period.
> >         T::drop(); // <- call the destructor of the inner object.
> >       }
> >     )
> > 
> > However, to support a different RCU usage pattern as below we need to
> > extend RcuBox:
> > 
> > 1. clean up the object, and unshare it from future RCU readers.
> > 2. wait for an RCU grace period.
> > 3. no other RCU readers, we can free the memory.
> > 
> > An `RcuFreeBox<T: RcuFreeSafe>` is introduced to provide support for
> > this:
> > 
> >   RcuFreeBox::drop():
> >     T::drop_before_gp(); // clean up and ushare.
> >     kfree_call_rcu(..);  // free it after one grace period.
> > 
> > Signed-off-by: Boqun Feng <boqun@kernel.org>
> > ---
> >  rust/kernel/sync/rcu.rs         | 31 +++++++++++++++
> >  rust/kernel/sync/rcu/rcu_box.rs | 68 +++++++++++++++++++++++++++++++--
> >  2 files changed, 95 insertions(+), 4 deletions(-)
> > 
> > diff --git a/rust/kernel/sync/rcu.rs b/rust/kernel/sync/rcu.rs
> > index 7da6b8d22277..7c26591bb318 100644
> > --- a/rust/kernel/sync/rcu.rs
> > +++ b/rust/kernel/sync/rcu.rs
> > @@ -4,6 +4,8 @@
> >  //!
> >  //! C header: [`include/linux/rcupdate.h`](srctree/include/linux/rcupdate.h)
> >  
> > +use core::pin::Pin;
> > +
> >  use crate::{
> >      bindings,
> >      types::{
> > @@ -82,3 +84,32 @@ pub trait ForeignOwnableRcu: ForeignOwnable {
> >      /// [`from_foreign`]: ForeignOwnable::from_foreign
> >      unsafe fn rcu_borrow<'a>(ptr: *mut ffi::c_void) -> Self::RcuBorrowed<'a>;
> >  }
> > +
> > +/// Declares a struct is safe to free after a grace period if all readers are guarded by RCU.
> > +///
> > +/// # Safety
> > +///
> > +/// Implementation must guarantee `drop_before_gp()` makes sure no future RCU reader will access
> > +/// any part of [`Self`], as a result, after `drop_before_gp()` return + one grace period, no RCU
> > +/// reader will be on the object, and it's safe to free it.
> > +///
> > +/// Notes for implementators: implementing this trait in general requires `Self` being a
> > +/// [`UnsafePinned`], i.e. a `&mut Self` is not a noalias reference if `Self` has non-trivial
> > +/// `drop()` function.
> > +pub unsafe trait RcuFreeSafe {
> > +    fn drop_before_gp(self: Pin<&mut Self>);
> > +}
> 
> Should this have an associated type for the rcu-safe view?
> 
> pub unsafe trait RcuFreeSafe {
>     type RcuView<'a>;
> 
>     /// Access this value in a manner that is safe after
>     /// `drop_before_gp` for one grace period.
>     fn rcu_view<'a>(self: Pin<&'a Self>, _rcu: &'a RcuGuard) -> Self::RcuView<'a>;
> 
>     /// Drop this value in a manner where it may still be accessed via
>     /// `rcu_view` for one grace period.
>     ///
>     /// # Safety
>     ///
>     /// All other accesses to this value must happen before the call to this
>     /// method, except for accesses using `rcu_view`.
>     fn drop_before_gp(self: Pin<&mut Self>);
> }
> 
> The idea being that once you call `drop_before_gp()`, the value
> immediately becomes unusable as the type itself, but you can still use
> it via `rcu_view`. The `RcuView` type can then be a type that has a
> subset of the type's methods that is safe to use for one grace period
> after `drop_before_gp`.
> 
> If you define the trait like this, then PollCondVar becomes RcuFreeSafe.
> It can't be RcuFreeSafe today because you must not create new waiters after
> `drop_before_gp()` is called. With this modified trait, it can simply
> not provide methods for registering new waiters from the RcuView type.
> 

Good point! But I guess I could keep RcuFreeSafe as it is but remove the
`RcuFreeSafe::with_rcu()`, and this should be sufficient for
PollCondVar. I do want to wait for a meaningful usage of `rcu_view()` to
add that, but I think your idea of that is great. Or maybe you have a
potential usage in mind?

Regards,
Boqun

> Alice

