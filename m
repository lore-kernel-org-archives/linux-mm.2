Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99160CD8C83
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 14:04:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C36026B008A; Fri,  5 Jun 2026 10:04:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE7236B0093; Fri,  5 Jun 2026 10:04:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD5966B0096; Fri,  5 Jun 2026 10:04:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9B7F86B008A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 10:04:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C508C02E9
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:04:14 +0000 (UTC)
X-FDA: 84846028428.10.AE9BF80
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id 716111A0003
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:04:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Hmc2Ul6S;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3WdciagkKCOoMXUOQdkTXSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3WdciagkKCOoMXUOQdkTXSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780668252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KzxQflFVSTadDNXMRobclacHPyZHXHcPR4PL2Kdl0Ys=;
	b=CMEMd/vNDrV4pea7nS8mRdvjlWV4nbcQ4LI23rYHbXcZt9/3vCJEgQXmwyue+tk7uekDo1
	SnI+qaMOYtVqru12gUWEYomf5TJ3KiD/yGt6W93SLFuQ/8zyehtlnBT9HHwOY62dRhyFDJ
	ZldQKKYYv29jiMwcIHdP3oOGW0pxt9o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Hmc2Ul6S;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3WdciagkKCOoMXUOQdkTXSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3WdciagkKCOoMXUOQdkTXSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780668252;
	b=qbmswKp3zcjTABvTDNwm8VMhi4D31YJ0Vqti8G3qcXsBDy25uwrgFgT6FHvI8yBkEZecs3
	7XM3omyIc+iUKYLM3oeAz9Bi3Y0AgTa8arDV4G32iZZgL2qvxKm4s0fl1Ab4+Af7Nr/S5s
	EuBHgddT8Z2JoZDMSL40McJsJ2mjSUE=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490b37e1f47so17916035e9.0
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 07:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780668251; x=1781273051; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KzxQflFVSTadDNXMRobclacHPyZHXHcPR4PL2Kdl0Ys=;
        b=Hmc2Ul6SwxO6nYOinnnc4ducYtHC6jZFlGQOoouVLicO/VINSr/LPWPjoUAFtWnX34
         88G2y4xZahqhJP5KwL65LYc/1I3+quiy3LFdGtFm/SfXCjbiTF2upXeuxL4Ihq7aHnIb
         /++Urr3ZQxagloyUCaMdnl5PlxikFoxrpKvBB0Ss7B1WKwgHkfNOtqGSfs5mo/70zXYa
         RGMyLHTIi06iSBh54wmfIxH1YmH1I2W3rEVTW8qQ2ZUjMihCACDLUrsFYbDdPJ+KQfVm
         7JeRzDBaA+wSwdjuT3lYYcOVjzGpNZuTvgAvBg6fGbGsbiKlj35+xMkKVxLDu/Px6GS4
         YwZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780668251; x=1781273051;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KzxQflFVSTadDNXMRobclacHPyZHXHcPR4PL2Kdl0Ys=;
        b=NnyfWXWRb415mYr+5zsO+Gij/B0JybwVrrh7poTRnDfhQELDZYjp45yMg+7RSTDeBa
         VjfttNf9vIRNQ4Ygx2zbsKd1yckEIXRXL4Bq4fmjTeZ783OOqQaMtpHE62FHPQNmSCGR
         U+7hAWJMwnUKOFwU2DnVCLcEDrsh43oKs39QRoroemnq/7G7Q3Ku/iOs2kEVwRpfaebw
         RsRJ23ICQq2d+rL97uSKZWVXWQ5xkTuLtpdOSTmKPGTdk7Elc5sjr4S8t6tlEn/VaUHc
         gM1fEbpWEP2/Sjq8jA4CgAOeWRJecbnPTREOl9tuqbtTtY18fRPgbrOZEPU4o/vxvWZ/
         vu9Q==
X-Forwarded-Encrypted: i=1; AFNElJ9CDimrmRB2wlIIDjmgLTPEmTI6yW1JERxH9A+BQ2+G1yZrJ2lN+qyJoA5josEzghYNFvCWwmOREg==@kvack.org
X-Gm-Message-State: AOJu0Yyg2or7fxEoalbxQWP3DuAgYM7nBj+0zweLZcoyi26pSq+mN5MG
	kUSCaxGOjYFoyU3h1YwA0BR2vgDqCGgP1e+QXkVNLXgxB840u6mboZ3dif+7M7+OMtZNoWcWwMP
	yE+fIh2QiF2Qtv/frRw==
X-Received: from wmsk10.prod.google.com ([2002:a05:600d:848a:b0:490:acbb:67d7])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:45d1:b0:490:b9c3:6c62 with SMTP id 5b1f17b1804b1-490c261007dmr52711405e9.28.1780668249942;
 Fri, 05 Jun 2026 07:04:09 -0700 (PDT)
Date: Fri, 5 Jun 2026 14:04:08 +0000
In-Reply-To: <20260605133541.22569-6-boqun@kernel.org>
Mime-Version: 1.0
References: <20260605133541.22569-1-boqun@kernel.org> <20260605133541.22569-6-boqun@kernel.org>
Message-ID: <aiLXWHg22P6OTb7O@google.com>
Subject: Re: [RFC PATCH 3/3] rust: rcu: Introduce RcuFreeBox
From: Alice Ryhl <aliceryhl@google.com>
To: Boqun Feng <boqun@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	rcu@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Andrew Ballance <andrewjballance@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Zqiang <qiang.zhang@linux.dev>, Sumit Semwal <sumit.semwal@linaro.org>, 
	"Christian =?utf-8?B?S8O2bmln?=" <christian.koenig@amd.com>, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, Philipp Stanner <phasta@kernel.org>, 
	Lyude Paul <lyude@redhat.com>, Daniel Almeida <daniel.almeida@collabora.com>, 
	"Onur =?utf-8?B?w5Z6a2Fu?=" <work@onurozkan.dev>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 716111A0003
X-Stat-Signature: bk7a768qw3wgs9ghaonx5sto1kkozepo
X-HE-Tag: 1780668252-284352
X-HE-Meta: U2FsdGVkX1/YUb9xwgRpARUSF0/rWzkAoyIfBH8mcMesGdboKg5ul+936dGFAPo7n5z4+9QvwY2w6am4PP+UWcEIV71rqVU468wpGO8FveYO6oBW/06ioCFz5Muy5vINvgFX24X5tnUIw9UxnUN+TotQWTeXVqbb93d1B88xNK/juMMKI8v+xFjGE2IgDNkRMXyZM8eAgnJvYY0DuxxJEJvzo7x+bqYj5Tvr0THnA3Lm+bOv954yed+/XDCuxrMRNTOs0jzo50fb0Bj+oHPjvbajO5l5s9tkCc+hmcBEjRxNLy85rs0hWnqi3mqNaMe5ABOV7Fp9bDWrk9vYqemmh9FgnqfhYwrWPWVEPqJA4xpb1VQsZVFxTVpY4+uSbY040mJTfvaWjflVNOWkcPRhqYFw9oSDaobRJCGMiOdxV0EIGgikuyavXkVjilJMGyO5TXey2k1GDv+csbKbhWMu7sPd8LS9RJ3Z4kuNACGZ6H+cQXXZqiGACX/WjVEF8EJ+3zjUP49lLewpimmrigGFbUU6QSbTTnkxy99PtXF86YtMhJggnJCSao7UAl1OX3zhbBmLQGTGT7TufeLx41s1pphBX2KUUaH4JWURQTjyBQ8qnJEmcJCiW0vBBi/FRW+3K4I23Q8dMAOaQKvhwt+HDj7tg1V99gvrQNzFS87cJD9rwN1P7kWKofip1EZneCcoZeDQ/ousEQhWLXWuTM1YPyGyIGeetq3Jt3xtF5glCZutaqDYAodHznTrj+zQ94BtKMhBcyQJyTW+0fPCSvJKXb9GJhQKNPJFNMu/+2wyv8iCKOw/eGmra3wg/5+oiqdLm74NdblYVo+JGqQpcpYtN2oOfsbKiGSAhlIYRV415C7TrvmlJ3EHxa7lvTaBSkf9vL1RY9ia1KZQmHhEDcsCiKLw80wXjzKQJ+jD0HylxWMLH4iu8r5b2mBT/IHY69uCkK5vh8m7oRgaoEC14Kc
 AxAO83wJ
 wG+FEj5LxyPXx1lsIn7m5pHPcmBItwTMDvU8bolHbpQ4N6KWoE8TAYjBdIvnltAAacVScxxAmOKMeJjCoNLTbf9YycStH9dHzD9w4GRsA2+UkjE0+b5yOpNW/oIyDSm76yg8zc3rFWf5p8nirbQxUCq0P6UafNH6EfID1YI4q56DvLLtVVtoujtoM6EnSj3zvVhQpjacJhYGRMLG6dxy+DtNw5JFoO5jtrmZhyv5qBZFZueq1yZMFAfbrWMnijWfS4DaTgwSy+//e+Y7gtZHsI+43CJho+tVzMaL8PlAbgIoPp8tAfWCCNudJymjULYLNlsE1tC7Gswg9bw5K35v/Hau4zMJrxZC2cLDyb/1BH+D9R3s9pV5D0ZWZrn3pjow4VBRZaU4x6Ip3o0vZVvmt/h2+Aov45JUQCjEMhVVtLOdR2G4/gIoJWkzuHrRl3bVHjIIsxKCY2OTeoyUyaOKCXeIfM9xh6ejFegLcE21G3IXR7V7i/JTIaDM36146n+ZxlGJNN7pGWw0Q4uMTl8iJGic+gQpFnO7OYfsot3/+CeasCpwYIN4lZlwST8/DucuvrZrjvD+T5P3Vah/8+QiyGgVzi2l33Mm0SUyXECo8gxsUC/JSJAJzH6Br45435yJMZvoZW1QjYup8McoL+9zKwCUl8dtZRLgpQfhZ2VOyP5G7XAE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 06:35:41AM -0700, Boqun Feng wrote:
> The current RcuBox will call the `drop()` function after a grace period
> inside an RCU callback. This suffices for maintaining a RCU-protected
> object:
> 
>   RcuBox::drop():
>     call_rcu(
>       |..| { // <- call back after one grace period.
>         T::drop(); // <- call the destructor of the inner object.
>       }
>     )
> 
> However, to support a different RCU usage pattern as below we need to
> extend RcuBox:
> 
> 1. clean up the object, and unshare it from future RCU readers.
> 2. wait for an RCU grace period.
> 3. no other RCU readers, we can free the memory.
> 
> An `RcuFreeBox<T: RcuFreeSafe>` is introduced to provide support for
> this:
> 
>   RcuFreeBox::drop():
>     T::drop_before_gp(); // clean up and ushare.
>     kfree_call_rcu(..);  // free it after one grace period.
> 
> Signed-off-by: Boqun Feng <boqun@kernel.org>
> ---
>  rust/kernel/sync/rcu.rs         | 31 +++++++++++++++
>  rust/kernel/sync/rcu/rcu_box.rs | 68 +++++++++++++++++++++++++++++++--
>  2 files changed, 95 insertions(+), 4 deletions(-)
> 
> diff --git a/rust/kernel/sync/rcu.rs b/rust/kernel/sync/rcu.rs
> index 7da6b8d22277..7c26591bb318 100644
> --- a/rust/kernel/sync/rcu.rs
> +++ b/rust/kernel/sync/rcu.rs
> @@ -4,6 +4,8 @@
>  //!
>  //! C header: [`include/linux/rcupdate.h`](srctree/include/linux/rcupdate.h)
>  
> +use core::pin::Pin;
> +
>  use crate::{
>      bindings,
>      types::{
> @@ -82,3 +84,32 @@ pub trait ForeignOwnableRcu: ForeignOwnable {
>      /// [`from_foreign`]: ForeignOwnable::from_foreign
>      unsafe fn rcu_borrow<'a>(ptr: *mut ffi::c_void) -> Self::RcuBorrowed<'a>;
>  }
> +
> +/// Declares a struct is safe to free after a grace period if all readers are guarded by RCU.
> +///
> +/// # Safety
> +///
> +/// Implementation must guarantee `drop_before_gp()` makes sure no future RCU reader will access
> +/// any part of [`Self`], as a result, after `drop_before_gp()` return + one grace period, no RCU
> +/// reader will be on the object, and it's safe to free it.
> +///
> +/// Notes for implementators: implementing this trait in general requires `Self` being a
> +/// [`UnsafePinned`], i.e. a `&mut Self` is not a noalias reference if `Self` has non-trivial
> +/// `drop()` function.
> +pub unsafe trait RcuFreeSafe {
> +    fn drop_before_gp(self: Pin<&mut Self>);
> +}

Should this have an associated type for the rcu-safe view?

pub unsafe trait RcuFreeSafe {
    type RcuView<'a>;

    /// Access this value in a manner that is safe after
    /// `drop_before_gp` for one grace period.
    fn rcu_view<'a>(self: Pin<&'a Self>, _rcu: &'a RcuGuard) -> Self::RcuView<'a>;

    /// Drop this value in a manner where it may still be accessed via
    /// `rcu_view` for one grace period.
    ///
    /// # Safety
    ///
    /// All other accesses to this value must happen before the call to this
    /// method, except for accesses using `rcu_view`.
    fn drop_before_gp(self: Pin<&mut Self>);
}

The idea being that once you call `drop_before_gp()`, the value
immediately becomes unusable as the type itself, but you can still use
it via `rcu_view`. The `RcuView` type can then be a type that has a
subset of the type's methods that is safe to use for one grace period
after `drop_before_gp`.

If you define the trait like this, then PollCondVar becomes RcuFreeSafe.
It can't be RcuFreeSafe today because you must not create new waiters after
`drop_before_gp()` is called. With this modified trait, it can simply
not provide methods for registering new waiters from the RcuView type.

Alice

