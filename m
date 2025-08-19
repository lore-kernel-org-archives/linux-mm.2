Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27502CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 12:58:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AA4B8E000B; Tue, 19 Aug 2025 08:58:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85BA38E0009; Tue, 19 Aug 2025 08:58:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 798AA8E000B; Tue, 19 Aug 2025 08:58:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5F47E8E0009
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:58:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DA50D1A0700
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 12:58:28 +0000 (UTC)
X-FDA: 83793510696.10.C16522C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5301E18000C
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 12:58:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dx8gHTLS;
	spf=pass (imf16.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755608307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jazjw7kkxYam+upD0MYMsEqu4g3xvEwq6K8sABONJMQ=;
	b=8MYgD/Nq6DjDHjXlj6cQYKDekpHwXxviPee4/luIiO5QhwylrWSwM7yhABCB1P9iHqfqlz
	pSzMMb4BtJ1adIwSOmX4Y17ytWcZPXbSqYPqYsBTUimyiIrOy58e8efnLtQRWd2xJaD1tW
	z1uvr7MWhXtUgwlfmRYlMyjXMNDv3KQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755608307; a=rsa-sha256;
	cv=none;
	b=h+dPGxzboY7mEMXFxpeMKLly4HHHV8dbvPcwcCI2bpZAXdcpdACgxcqQnzhSCeewux4las
	AA5dgjUBLfq6fPuF6xXWFDXdWAXU4DU1K/DBwq0cM3pR7cjpoqrDhJrwDC7fR1SAvjy0dw
	uJGeQKzczV8PmZj2RgA0Tg6kOdifYOc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dx8gHTLS;
	spf=pass (imf16.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D1AE61431;
	Tue, 19 Aug 2025 12:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242C1C113D0;
	Tue, 19 Aug 2025 12:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755608306;
	bh=4DO3dYAOM5pTDmnI1hLhVydMIin2dEAMrChEU5JifQg=;
	h=Date:From:Subject:Cc:To:References:In-Reply-To:From;
	b=dx8gHTLSmdApS+hHpltE88MUhCsHHt1MRH532v/ggxPXGNIWWPmnn/3FfBveGOq6f
	 JNIkdDaQIkQsMJi2L69hCyXyNHHN8R9TDex52yYrRJXhJdMZhAVyjs44KO41Uoe8SK
	 8iQee498MjVKFcn9D1BfY2h0vS3w+Ar1QPSHP4C9qbXOaL4gEOkj+cSd8O4ZEUH6qL
	 WAodkhxeNDPDG8QfzZlB3YpxYg7f8dQCBSis9kxUWCGoxdxZ6PF9uhJDxjrcp1vvj5
	 Jx4D6THiLj0HdWuh3yV1AWKjldwyz6Ucb6daPp0csYFXX/cwOFID+p3qGED2qE7CGX
	 lLmEip0Lu/Cug==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 19 Aug 2025 14:58:21 +0200
Message-Id: <DC6F7BN2L19O.1APQU9KWZV7H5@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH v2 2/5] rust: maple_tree: add MapleTree
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Miguel Ojeda" <ojeda@kernel.org>, "Andrew Ballance"
 <andrewjballance@gmail.com>, "Boqun Feng" <boqun.feng@gmail.com>, "Gary
 Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Trevor Gross" <tmgross@umich.edu>,
 <linux-kernel@vger.kernel.org>, <maple-tree@lists.infradead.org>,
 <rust-for-linux@vger.kernel.org>, <linux-mm@kvack.org>
To: "Alice Ryhl" <aliceryhl@google.com>
References: <20250819-maple-tree-v2-0-229b48657bab@google.com>
 <20250819-maple-tree-v2-2-229b48657bab@google.com>
 <DC6DC244ZIUL.304JSP7JFDE9Z@kernel.org> <aKRx8xsY8CpzbeEm@google.com>
In-Reply-To: <aKRx8xsY8CpzbeEm@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5301E18000C
X-Stat-Signature: txkbdpaznz4gyhthawkt7ey1yhrftxf5
X-HE-Tag: 1755608307-9661
X-HE-Meta: U2FsdGVkX18NWWM+CZz9vXI6MdxI7TTbLU2LwAg7hqizZQZRXHNbcvf1W/II65CefLSoU12WXS4Lm/kg/YsA+QxiRD7PU15GhQbHPzCyWllr74JDG9A/BlTz5CRqD30M+alASfON/CDmeVCyluaJWW28VCl88uIQ3T0movhvQlXbPuZ9sOSPJgRWc4A+zi+RGYt6WjbSa5YWiS3qTVm4jFf8VIkClhwExQpbpGnKWo0WP+hvxXqH6pMsz9EJxkLm+64Cnlkb2O07rW5AVRg3wrjylGQtWODHDaqwHL5hC7P3fQjtt3GNf08wnlt79bzPU9U4KAswja3rGvlyx9JTQpCI08pC4DjWRV4CEEVlRQp13mMsO9aLmqQRa2cRudJUwhSm0N1yKO3n8neblCn/W+Og18kzpNH4bTc5XaemcDoTNPrZ8Ugzmi/Spdp7uEilMr30HwK+31/tVQMOE7O3qbWRLZmBn6eYPlI6LSadcknpUqGDiX1CAbOu/tZpzCv1s7v1ylA53/ro/St37ZSJvSF94j0QPYy0QzOlaoF6wY2joTUPHyP69u6iCOaRRs7LxmVqxd2caYH6a5A7xIlU8Dh1uNJh7NTc5KhgnfdqGI1ZKr8C9zj7EhdG56E/i2Ub9zbtsndpjorBVA6iS24oKQx1LSkw5Ebrl88TfNEf48dY5jaCXLCkH7UXBfiPtHNgKCeirX5oANrQ10TfF5YKQTsZmTfcOQNM9bkFs8RPv6hf09XVdGg1vfPYkP9ZLYu9ircq07Gtg87URHIlkfChKzhfYAYna1uZN4vmaPAkMzeRPIA6vKiYrBTZByqanqxM9UsuXvK+MDrRc0QAWwT+nTQ/LstnO114jCdm9b9SR/GTJUSzVOKD4irPisb1um6Q3sOQnHE/VuJ7QUBSyzQG/SEawtbJ7//v3xpUTFp1nqvecZ85rfC20mx6gvKhFHlVrnGbfX5AzbZOf1uGnw4
 Ewl+hVd0
 EGyhOUbNuh8R7GWOqCGF4v3g47eBJL+/xQF4EnF0kJ1w7m3D+bC0Df+VYJ7E577mkVOOBS3QJMXP18Mu+/uUDUW+i0RO3IllmXrKxeGL9o8/wYRJyVOLM6r2p/0w6euV63kHPR+zu3ipCL136nF6iGDvL+G4eiP226KZD8kNGpeZSVA5XX6aW8ViUfNY05T0Kf9lb5OcbqrTwNIrJHxrSN1bNG5yspwRSKm+f4fbmoORjDxgnNCVj0Ga5nzSICg8uX90HJTTToVeY0DRRW23CdRkcy+i7A85nyQy2PpBph1CQ68h+jSgLvzicxOtaGQjHr3+t3k0oBtfFd0dj+cvK68G2i9a1nmuRlIEM0Ds5CfFPfRkBbxWUoVtI59EVIMFep4rUU2fvApINbmG1gnYtGBstRuR1Dfi7/znwB8jDnN4T4YeT2r1BMS2BbaA7UjkPoWmcI3UawIqcdK6UnjwPeD0iqQ7mTJiSRA1f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 19, 2025 at 2:45 PM CEST, Alice Ryhl wrote:
> On Tue, Aug 19, 2025 at 01:30:30PM +0200, Danilo Krummrich wrote:
>> On Tue Aug 19, 2025 at 12:34 PM CEST, Alice Ryhl wrote:
>> > diff --git a/MAINTAINERS b/MAINTAINERS
>> > index fe168477caa45799dfe07de2f54de6d6a1ce0615..26053163fe5aed2fc4b4e3=
9d47062c93b873ac13 100644
>> > --- a/MAINTAINERS
>> > +++ b/MAINTAINERS
>> > @@ -16250,7 +16250,9 @@ L:	rust-for-linux@vger.kernel.org
>> >  S:	Maintained
>> >  W:	http://www.linux-mm.org
>> >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>> > +F:	rust/helpers/maple_tree.c
>> >  F:	rust/helpers/mm.c
>> > +F:	rust/kernel/maple_tree.rs
>> >  F:	rust/kernel/mm.rs
>> >  F:	rust/kernel/mm/
>>=20
>> A later patch adds a separate entry; is this intended?
>
> Ah, no, this isn't intended.
>
>> > +impl<T: ForeignOwnable> MapleTree<T> {
>> > +    /// Create a new maple tree.
>> > +    ///
>> > +    /// The tree will use the regular implementation with a higher br=
anching factor.
>>=20
>> What do you mean with "regular implementation" and what is "a higher bra=
nching
>> factor" in this context?
>>=20
>> Do you mean that the maple tree has a higher branching factor than a reg=
ular RB
>> tree, or something else?
>
> This is compared to the alloc variant of the maple tree from the last
> patch in this series.

I think it'd be good to mention this. You could add the corresponding comme=
nt
and link when you introduce the type in the subsequent patch.

>> > +    #[inline]
>> > +    pub fn new() -> impl PinInit<Self> {
>> > +        pin_init!(MapleTree {
>> > +            // SAFETY: This initializes a maple tree into a pinned sl=
ot. The maple tree will be
>> > +            // destroyed in Drop before the memory location becomes i=
nvalid.
>> > +            tree <- Opaque::ffi_init(|slot| unsafe { bindings::mt_ini=
t_flags(slot, 0) }),
>> > +            _p: PhantomData,
>> > +        })
>> > +    }
>> > +
>> > +    /// Insert the value at the given index.
>> > +    ///
>> > +    /// If the maple tree already contains a range using the given in=
dex, then this call will fail.
>>=20
>> Maybe add an error section for this?
>>=20
>> > +    ///
>> > +    /// # Examples
>> > +    ///
>> > +    /// ```
>> > +    /// use kernel::maple_tree::{MapleTree, InsertErrorKind};
>> > +    ///
>> > +    /// let tree =3D KBox::pin_init(MapleTree::<KBox<i32>>::new(), GF=
P_KERNEL)?;
>> > +    ///
>> > +    /// let ten =3D KBox::new(10, GFP_KERNEL)?;
>> > +    /// let twenty =3D KBox::new(20, GFP_KERNEL)?;
>> > +    /// let the_answer =3D KBox::new(42, GFP_KERNEL)?;
>> > +    ///
>> > +    /// // These calls will succeed.
>> > +    /// tree.insert(100, ten, GFP_KERNEL)?;
>> > +    /// tree.insert(101, twenty, GFP_KERNEL)?;
>> > +    ///
>> > +    /// // This will fail because the index is already in use.
>> > +    /// assert_eq!(
>> > +    ///     tree.insert(100, the_answer, GFP_KERNEL).unwrap_err().cau=
se,
>>=20
>> A lot of the examples, including the ones in subsequent patches contain =
variants
>> of unwrap().
>>=20
>> I think we should avoid this and instead handle errors gracefully -- eve=
n if it
>> bloats the examples a bit.
>>=20
>> My concern is that it otherwise creates the impression that using unwrap=
() is a
>> reasonable thing to do.
>>=20
>> Especially for people new to the kernel or Rust (or both) it might not b=
e
>> obvious that unwrap() is equivalent to
>>=20
>> 	if (!ret)
>> 		do_something();
>> 	else
>> 		panic();
>>=20
>> or the fact that this is something we should only do as absolute last re=
sort.
>
> How would you write it? The way you write it in normal code is an
> if/else where you handle both cases, but that doesn't map nicely.

I'd just

	assert!(tree.insert(100, the_answer, GFP_KERNEL).is_err());

and if you want to test that the error you'd expect is actually returned, I=
'd
suggest a regular kunit test, rather than a doc-test.

I think doc-tests should mostly illustrate idiomatic usage, especially now =
that
we have good and easily accessible kunit support.

I say "mostly" because I think tests to the degree of where they stay withi=
n
reasonable bounds of illustrating idiomatic usage are fine of course.

