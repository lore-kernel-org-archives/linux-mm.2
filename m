Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34402D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 10:23:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 891576B002C; Mon,  1 Dec 2025 05:23:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 842046B002D; Mon,  1 Dec 2025 05:23:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 731756B008A; Mon,  1 Dec 2025 05:23:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BF166B002C
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 05:23:36 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7A1B91363F6
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 10:23:33 +0000 (UTC)
X-FDA: 84170515506.30.DE84B88
Received: from mail-43102.protonmail.ch (mail-43102.protonmail.ch [185.70.43.102])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7377D8000B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 10:23:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=RpHDpQZz;
	spf=pass (imf30.hostedemail.com: domain of oliver.mangold@pm.me designates 185.70.43.102 as permitted sender) smtp.mailfrom=oliver.mangold@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764584612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QnPScfECMfGXASlBfNyIG7Imc1U13Cp1f8LkX6qmIUk=;
	b=bfVysKjUC+qecTSgP9/wayiVO+fdeK8sNiotknqmfs6vLbKVFyZQ79Vskpbr9S14WnaT5Y
	0R2LY7UzQPBB8ViItOGdGJ2aWt8DgpuZZQePK+u2Lhmt6Iap8MYbKmIjO6n+JuALB0D4kH
	g1I+2UturZejnPRNMrJReW+r3w1nFSQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764584612; a=rsa-sha256;
	cv=none;
	b=pbDv0Epby447kin2C6gxcnQQcL8MdloYvrARdnpc3WOM/jildffWW5uqOt30yqFXqQBRl7
	kSDM/5L6ViYXDkPnTvKDQ2MupoB+rYLKFPxrOrWmcD84NR+tJRbCBTKR3eU2v+3bz/2ooM
	1bhG+JH9q+H8kd4+rhHyQ+nX2vbdhpY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=RpHDpQZz;
	spf=pass (imf30.hostedemail.com: domain of oliver.mangold@pm.me designates 185.70.43.102 as permitted sender) smtp.mailfrom=oliver.mangold@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1764584606; x=1764843806;
	bh=QnPScfECMfGXASlBfNyIG7Imc1U13Cp1f8LkX6qmIUk=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=RpHDpQZzYuktwGoF6ihhp2LS52OTDz4RVT/GsNzw44D9RYrEC1d0h/X3FKZUNWqPq
	 C/3rllP/4P22OrASzib/QAqi2dIGjis2zjL5mY7IIcUEAcL83/qda8oBG4rRQYE1+/
	 kQfmdU2sN54teUEA3Qy+r6rCZdCytGsRdsQdv2yax5W/NEyYn8WumNdFtVs8q3XZBX
	 JssZh5RD7Mv63jptrzfwaQaE+KTnySpGQ86wrEoxHZPpPQxzf0D7qSwEYj0RrWvDaN
	 yJPVjChTQiiMSStQ6r5/HBN8EE64sr0hoQ9jOrXBjmhPw1E/49oN7sFYSsdfwwpWJm
	 vcxWADWzG0sTQ==
Date: Mon, 01 Dec 2025 10:23:20 +0000
To: Daniel Almeida <daniel.almeida@collabora.com>
From: Oliver Mangold <oliver.mangold@pm.me>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, Leon Romanovsky <leon@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Viresh Kumar
	<vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, =?utf-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, Asahi Lina <lina+kernel@asahilina.net>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v13 4/4] rust: Add `OwnableRefCounted`
Message-ID: <aS1slBD1t-Y_K-aC@mango>
In-Reply-To: <A5A7C4C9-1504-439C-B4FF-C28482AF7444@collabora.com>
References: <20251117-unique-ref-v13-0-b5b243df1250@pm.me> <20251117-unique-ref-v13-4-b5b243df1250@pm.me> <A5A7C4C9-1504-439C-B4FF-C28482AF7444@collabora.com>
Feedback-ID: 31808448:user:proton
X-Pm-Message-ID: 4625f7cc3b95621c135f74a512f54cf7f5392afa
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 7377D8000B
X-Stat-Signature: rw94ts8hcho7974ewjd5kox6fjag6dw4
X-HE-Tag: 1764584611-167846
X-HE-Meta: U2FsdGVkX1/YjvND9m6Cuycc5GTG08m8dUFJg7+Ar3NkhFxMoGBRIjdjUGVl8G3RgS3x3LXCLFqPLQt6+XWD2lLEFrstTVf/DuELajysmgmTmHErc99wTBVei7c6aPXx+0hfL1yORXxeQUl8+piDDH0NEOLjt4yYoB47VEEfv9RRXAuQRCISGiXnpUX20Y0b7lxJ/7+sGj/HQntPjvlg9z8U8cSxgjhgNH9mRIaEtN2Y/TFxr/C41huIAxmBZXjH287TQjbaEu20xWk2dcQuss0r8f8Q90CZXvcXPbNFMynaE2oOoyrcLzHsP0oguoncZu7GNJNmW0kITvagM/tCHYk69fq3x6JJrcqCpGx7CYer+IexJ4uulS1ZhrOMSljCXtxx5v0Qk3ewf4qdfwALWQHxMYAAvN0CayI6+GPj3pt4NIP3ARncjHK7xAw8lcRzWLxZLqpjFUPkuwtDW/TaJud0L+622NvjXvI0634n9V8JlnPN3ro1Xs9PWJzC7voAPwrccE+2XjF0ToQdZzuW+z0hWPOz9heiTUPFUG7385B+dKjH5rwsHT+zyBKUSLcNu5aohrfOGSXPmtNhiBLY3s9fkuAVMUKJxLIIh+7vXGJqAPZ+IplGreEbC3n4Mw+xbInKeDf+fcW6Z2HRvGpdfRpLQo1qXep1QcooQwLzjwgTTVDHl54xa5p7CACc81BNCv+1h6KD40eDzL81cGBx2Zhxf5dV0UwWu79fY9cwts0Q6S76CkOY5I7+KDXI8bTuwkapAeUzAj0Lo+WziiMQdpoqHyUC6pfLKlCDs2cc9qarKUkJ1Q0AO4cMagpa0trFpjGo2In/kmtiuRstq5gJX5ql4VcQQA6nusriCiweLaCbfGxQwDGKGtudOWlGV44ErAO8N4KYIybL8moAncgU9RFO3rNxSbKkNi9LXDrnWN8aet29G5QT+ERonJmgmYdI3pPs0kqnaK+viJpsVF2
 8HSLHImS
 hpVQIo6Xf2uw/I7W3ZiGsDuHgScaOQbjkndtjqq2lROIXwQh8xqZu4UJp3G/OHa9P+S8s5HY1LKbMYMPzyxryjC3FW+s5qRwyyyeaFm8C1vRnmG2ba0djRtwHtbxLf8b4LfxBbqEi6rqvTO7XoA99/9qzdOLVrWS+t+V7pb9BwultVeJbUXcBpsghxvkRvJcN3gKUyvCQWQFNh7dsnFLDqKvXhjPGRiwiYFrNK1+cao3jvXgGdR+qfbdnxiXu5om07UXdjD0xWOMtJJRLUGvWINE7f8mBOx6oiKDZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 251128 1506, Daniel Almeida wrote:

> > /// Type allocated and destroyed on the C side, but owned by Rust.
> > ///
> > -/// Implementing this trait allows types to be referenced via the [`Ow=
ned<Self>`] pointer type. This
> > -/// is useful when it is desirable to tie the lifetime of the referenc=
e to an owned object, rather
> > -/// than pass around a bare reference. [`Ownable`] types can define cu=
stom drop logic that is
> > -/// executed when the owned reference [`Owned<Self>`] pointing to the =
object is dropped.
> > +/// Implementing this trait allows types to be referenced via the [`Ow=
ned<Self>`] pointer type.
> > +///  - This is useful when it is desirable to tie the lifetime of an o=
bject reference to an owned
> > +///    object, rather than pass around a bare reference.
> > +///  - [`Ownable`] types can define custom drop logic that is executed=
 when the owned reference
> > +///    of type [`Owned<_>`] pointing to the object is dropped.
> > ///
> > /// Note: The underlying object is not required to provide internal ref=
erence counting, because it
> > /// represents a unique, owned reference. If reference counting (on the=
 Rust side) is required,
> > -/// [`RefCounted`](crate::types::RefCounted) should be implemented.
> > +/// [`RefCounted`] should be implemented. [`OwnableRefCounted`] should=
 be implemented if conversion
> > +/// between unique and shared (reference counted) ownership is needed.
> > ///
> > /// # Safety
> > ///
> > @@ -143,9 +146,7 @@ impl<T: Ownable> Owned<T> {
> >     ///   mutable reference requirements. That is, the kernel will not =
mutate or free the underlying
> >     ///   object and is okay with it being modified by Rust code.
> >     pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
> > -        Self {
> > -            ptr,
> > -        }
> > +        Self { ptr }
> >     }
>=20
> Unrelated change?

Ah, yes, rustfmt must I done that, and I missed it. Will fix.

> > +///
> > +/// impl OwnableRefCounted for Foo {
> > +///     fn try_from_shared(this: ARef<Self>) -> Result<Owned<Self>, AR=
ef<Self>> {
> > +///         if this.refcount.get() =3D=3D 1 {
> > +///             // SAFETY: The `Foo` is still alive and has no other R=
ust references as the refcount
> > +///             // is 1.
> > +///             Ok(unsafe { Owned::from_raw(ARef::into_raw(this)) })
> > +///         } else {
> > +///             Err(this)
> > +///         }
> > +///     }
> > +/// }
> > +///
>=20
> We wouldn=E2=80=99t need this implementation if we added a =E2=80=9Crefco=
unt()=E2=80=9D
> member to this trait. This lets you abstract away this logic for all
> implementors, which has the massive upside of making sure we hardcode (an=
d thus
> enforce) the refcount =3D=3D 1 check.

This wouldn't work for the block `Request` use case. There a reference can
be acquired "out of thin air" using a `TagSet`. Thus "check for unique
refcount" + "create an owned reference" needs to be one atomic operation.

Also I think it might be generally problematic to require a refcount()
function. The API of the underlying kernel object we want to wrap might not
offer that, so we would need to access internal data.


> > +/// // SAFETY: This implementation of `release()` is safe for any vali=
d `Self`.
> > +/// unsafe impl Ownable for Foo {
> > +///     unsafe fn release(this: NonNull<Self>) {
> > +///         // SAFETY: Using `dec_ref()` from [`RefCounted`] to releas=
e is okay, as the refcount is
> > +///         // always 1 for an [`Owned<Foo>`].
> > +///         unsafe{ Foo::dec_ref(this) };
> > +///     }
> > +/// }
> > +///
> > +/// let foo =3D Foo::new().expect("Failed to allocate a Foo. This shou=
ldn't happen");
>=20
> All these =E2=80=9Cexpects()=E2=80=9D and custom error strings would go a=
way if you
> place this behind a fictional function that returns Result.

Not sure what you mean by fictional function. Do you mean a non-existent
function? We want to compile this code as a unit test.

The rest of your suggested changes make sense, I guess. I will implement
them.

Thanks,

Oliver


