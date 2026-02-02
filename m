Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FF1AE73164
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 13:05:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 777736B00D0; Mon,  2 Feb 2026 08:05:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7258C6B00D1; Mon,  2 Feb 2026 08:05:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65BF86B00D2; Mon,  2 Feb 2026 08:05:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5134E6B00D0
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 08:05:17 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F2E91BC6E
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 13:05:17 +0000 (UTC)
X-FDA: 84399537474.20.20BA1B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7BBBCC0014
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 13:05:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FdM2WSOE;
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770037515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J7QljuPFQ7fz61T1NeHMKksjlqrS3vnTQcCwOj8e0Jo=;
	b=UR7h9W53J+H/xcGVfsePag2lIgaKqV7LbYil6QZNwmMOk6O7QryYzVPFWGnoo3/yUbJtb3
	LuRxmGp+18r0IfBww1USco8VBSIUW7dwWhxGzm4B429QR4fWd0Te043i7rOk6kQhhWQOJu
	grikKuyJMibrYzdJmBhl0neExu4fzXo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FdM2WSOE;
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770037515; a=rsa-sha256;
	cv=none;
	b=8NMNWJYfv2Y7dkO/fJWUmmK/9iR1/6+3nKpzpkJzQFqUHItlfQTDnz0z9PvWC3KjBkEqeI
	BCU5aFqdpqZ31BzHK7j460lspuKPIvUrRREDrCLTPyY13w8zmaHiFc9d4PQB3k2nES2Y14
	UGbzNcwYogoV+LOZuc1bFlVeZLgfU+8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 63AC5600C3;
	Mon,  2 Feb 2026 13:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5443BC116C6;
	Mon,  2 Feb 2026 13:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770037514;
	bh=EA8qmHxvlMjKBeqgsh6FoAR2kX5IcYCMu3Q/fDbz/zg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=FdM2WSOEpeVQ0G9EyU21z1S0Lc0i5nKom3jrdf4XT0vgxVkmSvVv01d7Bbqzor4Fr
	 CKetcy6KuujlK1hofUqZhdONhdECK3R68Fs7v//6QJguXupZST0CUs8zTOP9DioDPT
	 IUnmq8kMggsi9hM/2sWsGOulgfdLPcK393LWYJkIgu+PxzntGjJR8JkaKZmODhjqMr
	 4Ea8+agyrb3fZaidYMXZ95Vvnc/vkji4291P5tmXEeFMR/upeh++8DYO0R1c5Phm5z
	 UTz1+AHlfwlF8f9Wzh344oXZckqGRPiIKrhA4666Jd7Zkj638nJsu/G51PO4f0Yq98
	 RRwcBhArrCJpQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Gary Guo <gary@garyguo.net>, Gary Guo <gary@garyguo.net>, Oliver Mangold
 <oliver.mangold@pm.me>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Alice Ryhl <aliceryhl@google.com>, Trevor
 Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>, Danilo
 Krummrich <dakr@kernel.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman
 <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, Leon
 Romanovsky <leon@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard
 <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David
 Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Alexander
 Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan
 Kara <jack@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam
 R. Howlett" <Liam.Howlett@oracle.com>, Viresh Kumar <vireshk@kernel.org>,
 Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas
 <bhelgaas@google.com>, Krzysztof =?utf-8?Q?Wilczy=C5=84ski?=
 <kwilczynski@kernel.org>, Paul
 Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, Asahi
 Lina <lina+kernel@asahilina.net>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-security-module@vger.kernel.org
Subject: Re: [PATCH v13 1/4] rust: types: Add Ownable/Owned types
In-Reply-To: <DG4H66NZ5ME0.3M9CQY1ER4Q0X@garyguo.net>
References: <20251117-unique-ref-v13-0-b5b243df1250@pm.me>
 <20251117-unique-ref-v13-1-b5b243df1250@pm.me>
 <20251201155135.2b9c4084.gary@garyguo.net>
 <87343jqydo.fsf@t14s.mail-host-address-is-not-set>
 <rHWhMe7C5fnwgGCnKS4N7G90SrX0Ao8332cwKPH2o-Em_lCBG3lm_erDn9dtg55SpjMFQQoJ_hhDU3bKOdYfAQ==@protonmail.internalid>
 <DG4H66NZ5ME0.3M9CQY1ER4Q0X@garyguo.net>
Date: Mon, 02 Feb 2026 14:04:56 +0100
Message-ID: <87o6m7pa87.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7BBBCC0014
X-Stat-Signature: sb3w9nhbnexiaef4kxj748g3aiz4m997
X-Rspam-User: 
X-HE-Tag: 1770037515-242004
X-HE-Meta: U2FsdGVkX1+q6DDyBAsDyrGNNN4lYx0wo2tMVk7jrN0nBvCJD3rtvQbBWO3t6s4oaY1VZymuRwus4fQ67QuwjQuVL5A5I7ZxlMbhg1atfk1c1imj8e2+ZrHIAxPxafD9PnPEsu9iCXoJCz4zZiZ+dt7eOwDKObY1jB3tdSQQGVeq/+c4phiT/vCS5apQHhcw908Y6wBdc5kj1Spg29ZGff75roErqhnSbJ46RVgJUt8o/q250Pn1JoRyqChlCSMywYFjwXclRqWRI164rQC2IgpGB+mnh2Pihkx8N4SoM9ecUl4xxKTAdwZ3YV2AeFNC/LEA8Xr4gbhAh1pFbMyFwZNnw6agN+NukvMYXhSt0P4TwLEjp3YH1TKWOGyOdeRn5SHCj2D6kNZAB9JH1liM6tAvzgOIvn0GcWJCcV31s0ZWiUGVMVsSnsz/6Lir7HVie+daSIPtLjJ6MjDubRXQj6c21sZpIpIHXgxcAqgK/Qd/l3ip8kNpCWHGJsC7aCvkwMIqngmX8ZrbigEx4hVFhzu5SsL3JUtgQLT9c2W9U2CVXrzaZ2vrNpJHGbGT53GoOxOX+F9F1EmiAePlMmlgmJ8Jh+4xQNqx0deoGlWqAdb1CuLjoZR9CCUSiIqIDtYle+/UjCbJdtlxf76kU7aNANrLFdXCEo5CnnxlS8sU3pn9cd60QqoAQjE2B2+E0qA1LppaqcXOXDnpXprCToZOw0DTEXU2w6dsZVe3YxM1a0utsL0MGDgx1T0NW3FWYdLvRsyZi4XvXUB+K3cqClFLycWraNxsd3nUOhrtwMZFXT4MLHEMrZrHO31gpeZnWWP222h51OiYFG5s1Az+bLGyhn8xzHIFY7nGql3Nt4nmhfoNy3DJAghGS8RSao3neLUcATpRnGJMnwdRFcXlsc2JqWIeOP35pNwFR1QalrIgEW4RpVW1bGj7h6S8mPxMxb9gMmBuC9KC/2PliLkiZ3d
 0wbNYjRr
 Wp3l6qR3LP4FWdlozRvb3JrpJhK7hWcMqiTJOzdrKBIDyWavoOA9lf2uDp6XV8T5UY3LUng18hMKbLkftfJif4EctoxrS2CoPzeDo+ckW1LLPTK/S91n2L2AsDHuty4Y18hSyXySdJbH69FcEn8TeF9Wm6Ss6dpCP4zlSh+JHAWGbN4m3ERZeiWl5TBC9vOyvOVYGktyLwXf9YfHFPn4D/MYWflM2teYtAA0LjA2dL/z58S5pdcq5JdcnVf+0WoRGOsKgp/swum2fjfQ05iwa4oJSkQu6x1nnCRPsWwDfAG+NmrxD4iCX/IBc76BlR5rwmuBk4QI3zNSj8iJ6Z3UOOk3G/bkYpThvuuKMrMG2FaV/z2Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Gary Guo" <gary@garyguo.net> writes:

> On Mon Feb 2, 2026 at 9:37 AM GMT, Andreas Hindborg wrote:
>> Gary Guo <gary@garyguo.net> writes:
>>
>>> On Mon, 17 Nov 2025 10:07:40 +0000
>>> Oliver Mangold <oliver.mangold@pm.me> wrote:
>>>
>>>> From: Asahi Lina <lina+kernel@asahilina.net>

<cut>

>>>> +impl<T: Ownable> Owned<T> {
>>>> +    /// Creates a new instance of [`Owned`].
>>>> +    ///
>>>> +    /// It takes over ownership of the underlying object.
>>>> +    ///
>>>> +    /// # Safety
>>>> +    ///
>>>> +    /// Callers must ensure that:
>>>> +    /// - `ptr` points to a valid instance of `T`.
>>>> +    /// - Ownership of the underlying `T` can be transferred to the `Self<T>` (i.e. operations
>>>> +    ///   which require ownership will be safe).
>>>> +    /// - No other Rust references to the underlying object exist. This implies that the underlying
>>>> +    ///   object is not accessed through `ptr` anymore after the function call (at least until the
>>>> +    ///   the `Self<T>` is dropped.
>>>
>>> Is this correct? If `Self<T>` is dropped then `T::release` is called so
>>> the pointer should also not be accessed further?
>>
>> I can't follow you point here. Are you saying that the requirement is
>> wrong because `T::release` will access the object by reference? If so,
>> that is part of `Owned<_>::drop`, which is explicitly mentioned in the
>> comment (until .. dropped).
>
> I meant that the `Self<T>` is dropped, the object is destroyed so it should also
> not be accessed further. Perhaps just remove the "(at least ...)" part from
> comment.

Right, got it. The "until.." is in place to allow reuse of the
allocation. There is no requirement here to drop `T` via the `release`
method when an `Owned<T>` is dropped. Implementers are free to implement
schemes that reuse the object without drop and re-init. This can be used
in object caches such as for the block request cache.

>
>>
>>>
>>>> +    /// - The C code follows the usual shared reference requirements. That is, the kernel will never
>>>> +    ///   mutate or free the underlying object (excluding interior mutability that follows the usual
>>>> +    ///   rules) while Rust owns it.
>>>
>>> The concept "interior mutability" doesn't really exist on the C side.
>>> Also, use of interior mutability (by UnsafeCell) would be incorrect if
>>> the type is implemented in the rust side (as this requires a
>>> UnsafePinned).
>>>
>>> Interior mutability means things can be mutated behind a shared
>>> reference -- however in this case, we have a mutable reference (either
>>> `Pin<&mut Self>` or `&mut Self`)!
>>>
>>> Perhaps together with the next line, they could be just phrased like
>>> this?
>>>
>>> - The underlying object must not be accessed (read or mutated) through
>>>   any pointer other than the created `Owned<T>`.
>>>   Opt-out is still possbile similar to a mutable reference (e.g. by
>>>   using p`Opaque`]).
>>>
>>> I think we should just tell the user "this is just a unique reference
>>> similar to &mut". They should be able to deduce that all the `!Unpin`
>>> that opts out from uniqueness of mutable reference applies here too.
>>
>> I agree. I would suggest updating the struct documentation:
>>
>>     @@ -108,7 +108,7 @@ pub unsafe trait Ownable {
>>         unsafe fn release(this: NonNull<Self>);
>>     }
>>
>>     -/// An owned reference to an owned `T`.
>>     +/// An mutable reference to an owned `T`.
>>     ///
>>     /// The [`Ownable`] is automatically freed or released when an instance of [`Owned`] is
>>     /// dropped.
>>
>> And then the safety requirement as
>>
>>  An `Owned<T>` is a mutable reference to the underlying object. As such,
>>  the object must not be accessed (read or mutated) through any pointer
>>  other than the created `Owned<T>`. Opt-out is still possbile similar to
>>  a mutable reference (e.g. by using [`Opaque`]).
>
> Sounds good to me.

OK.

>
>>
>>
>>>> +    /// - In case `T` implements [`Unpin`] the previous requirement is extended from shared to
>>>> +    ///   mutable reference requirements. That is, the kernel will not mutate or free the underlying
>>>> +    ///   object and is okay with it being modified by Rust code.
>>>
>>> - If `T` implements [`Unpin`], the structure must not be mutated for
>>>   the entire lifetime of `Owned<T>`.
>>
>> Would it be OK to just write "If `T: Unpin`, the ..."?
>>
>> Again, opt out is possible, right?
>>
>
> When the "mutable reference" framing above I think you can just drop this part.

Agreed.

>
>>>
>>>> +    pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
>>>
>>> This needs a (rather trivial) INVARIANT comment.
>>
>> OK.
>>
>>>
>>>> +        Self {
>>>> +            ptr,
>>>> +        }
>>>> +    }
>>>> +
>>>> +    /// Consumes the [`Owned`], returning a raw pointer.
>>>> +    ///
>>>> +    /// This function does not actually relinquish ownership of the object. After calling this
>>>
>>> Perhaps "relinquish" isn't the best word here? In my mental model
>>> this function is pretty much relinquishing ownership as `Owned<T>` no
>>> longer exists. It just doesn't release the object.
>>
>> How about this:
>>
>>
>>     /// Consumes the [`Owned`], returning a raw pointer.
>>     ///
>>     /// This function does not drop the underlying `T`. When this function returns, ownership of the
>>     /// underlying `T` is with the caller.
>
> SGTM.

OK.


Best regards,
Andreas Hindborg



