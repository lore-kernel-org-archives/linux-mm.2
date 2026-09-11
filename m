Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE716C88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 13:26:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD1B66B0092; Fri, 11 Sep 2026 09:26:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA96B6B0093; Fri, 11 Sep 2026 09:26:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE65D6B0095; Fri, 11 Sep 2026 09:26:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 968FB6B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:26:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 58E6912022B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:26:02 +0000 (UTC)
X-FDA: 85201554564.25.2CFEBCA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id C6DD540006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:26:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VXtn1fiY;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789133160;
	b=hG61W0C6CUmYB8yo+jcle8aqEEM9czNknBo/Pl0Os/2lM4k7AIq9fW7k96bq5JDAxJanne
	WWZPBTFFJuJmcX3Hx4YR8c+WxVd1K2M3Ek+qyBnrVwOSXK6Xed57otUVXdF5tX+GY1HpkN
	R9kq/y0mBAb4GzQi/IiwW+rWiwRvusQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VXtn1fiY;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789133160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b8hBkIDR5gbaIa/OcVZo7VYHM8DXFaO8ihp5gcV65Tc=;
	b=SutT3eXqEll54mNshkoQ22GjpuRfufPfXIeBCwCXh9nM100ww0oqPl4LSfZ7slHcTC3nWW
	yScT/85uR6cg+FpgovJRRCPHmNO10WzW17cqWo/q0FSE8rdmytx3KQEXZSLztShvT4xbhg
	RMHxD42VpFn56lCS2oRqnMi1hgmKHaA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 18C206025A;
	Fri, 11 Sep 2026 13:26:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34FF51F00898;
	Fri, 11 Sep 2026 13:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789133159;
	bh=b8hBkIDR5gbaIa/OcVZo7VYHM8DXFaO8ihp5gcV65Tc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=VXtn1fiY2o5DXMdoNaf8ZzLgSZsGCdT7ZwNY6FB4pdySVmjeQIqo+jTZLfm3/q33+
	 LnCbzK/A0d6W3mHy5MlGsh+dOBxN4T+7UuC7if51SC4Y4WOsawT4loI6z4f/cPPsPb
	 LEHZm4NM/UiYfaaDB2e8nAEDA/bUbIeD89ffVwAWP5YoZyzbml/CvceH29+Tq6pfbc
	 5OiH8ODldkyB5xaiz0JQc+5SkYuDaxk8ZB5CaqnQ1olk+xod9sHadlEIgKFs0bPhqk
	 mpWXADE1ONaJWHe+tK1DyeoOXHAnAcaBRnsz8NpG1Ysw760kl3cXOV1DCzOlIhHu25
	 jY4cewUPGE/7g==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>, Miguel Ojeda
 <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo
 <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Daniel Almeida <daniel.almeida@collabora.com>,
 Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot
 <acourbot@nvidia.com>, Onur =?utf-8?Q?=C3=96zkan?= <work@onurozkan.dev>,
 Lyude Paul
 <lyude@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve
 =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>, Todd Kjos
 <tkjos@android.com>, Christian
 Brauner <brauner@kernel.org>, Carlos Llamas <cmllamas@google.com>, "Rafael
 J.
 Wysocki" <rafael@kernel.org>, Dave Ertman <david.m.ertman@intel.com>, Leon
 Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge
 Hallyn <sergeh@kernel.org>, David Airlie <airlied@gmail.com>, Simona
 Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan
 Kara <jack@suse.cz>, Igor Korotin <igor.korotin@linux.dev>, Viresh Kumar
 <vireshk@kernel.org>, Nishanth
 Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas
 <bhelgaas@google.com>, Krzysztof =?utf-8?Q?Wilczy=C5=84ski?=
 <kwilczynski@kernel.org>,
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Michal Wilczynski
 <m.wilczynski@samsung.com>, Ira Weiny <iweiny@kernel.org>, Matthew Brost
 <matthew.brost@intel.com>, Thomas =?utf-8?Q?Hellstr=C3=B6m?=
 <thomas.hellstrom@linux.intel.com>, Philipp Stanner <phasta@kernel.org>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, driver-core@lists.linux.dev,
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
 linux-pm@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-pwm@vger.kernel.org, linux-usb@vger.kernel.org, Oliver Mangold
 <oliver.mangold@pm.me>
Subject: Re: [PATCH v21 6/9] rust: Add `OwnableRefCounted`
In-Reply-To: <aqPHvi1xFnMXvYLW@google.com>
References: <20260910-unique-ref-v21-0-e83257373062@kernel.org>
 <20260910-unique-ref-v21-6-e83257373062@kernel.org>
 <or1Yx6egJPyUT07SJzH5J4d8aI6S2qOc1sfl70J55bvsy-l2H0DHJHa-MeXQIv40mrfFILbhL0uB2G0aHIYUlA==@protonmail.internalid>
 <aqPHvi1xFnMXvYLW@google.com>
Date: Fri, 11 Sep 2026 15:25:43 +0200
Message-ID: <87se3fvs14.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C6DD540006
X-Stat-Signature: 17wfoetnoasqmb4e1ptskhppdk6moqz6
X-HE-Tag: 1789133160-269772
X-HE-Meta: U2FsdGVkX18p50jpDpx2yzYGPUOl9WOrOs0wKHffH/bPklewvzVHuQBm+BFniKnqmNu6orSDCncLzcng0KUBThsidcPUfvaruB/xwMPm2nGXI2LR2qo3ujnqIwP5ie5IadktQ5ZEXpBc6rlFjG+pKf+AcIWT8dhQFxNdBBWf/yfkpEpim0BBPNcq+wbDPpQ1Cr9KRgxztx81Ku9zW2ts6jC1jJBdTY4sQNYmwsoJr3A6iIrJzg4DSMeg6LFWhsQFHZE4yz8qYytIKHN3/hwAembYhNxwQzZG7LRkIAjCtqhRnePbDai/WtekiIVE6TMQTZenJjrsLNT6NV9m0hKhA7mcLbhfDnheDCHkaRR9u/H/LTmBnSO9IwrKTnqZd2F/CyhNLp35Hfvo4YPKXMMH6+3iIpJQLGqcND56LOqy5AqAGb0E0Pln/x/nqYbW4OY2v6/Jq0XeJG5d4PLrcGDyL7F9B5Xnzk/MqxGWHizb+fWsv6pJYaJXEDYLeCh85CMRIQpOX04yfSVOPMzLE9k1IKsIgviWfdaOq9/QW/qq5U/Ho6weWm6gHazl3+5crwK+PWwpygfd+UBCvfhMpKUWccqxFvgdjiRgoekuESCe4GYtwj/5Gfc71S8FJuzpgfDaXqItK6fylLPLNuuRh6OTsEz04Sn/+UimBzKc5gT2qH6PdT9OhYiAAG86MvleaPZRd5xqNcx9Fqeg4QyyZkhhFfrdFtKo/veP/NCrl+gbGGzYj8srI1UO+LctK+aXoJJSOBQGjRCn+YX2jG4+JWkvBlT7GwoDwbVL1THSDNVMxWklqk1dC48lY3hZZOe/UgTXv0dEXBJBE2ITIvQ0jjtGqRRFwFAAzlhewxtcHvviYe6DBFD7455f9RiZOGxaAXV2MI34LX2MVztxIX62c6QbW4oGDdor6wdvaFH1IibvQbfd+Kn88UBgJw1aSndxkbpwCQr/Mkp5HSQhQFtUZsd
 SfvoVzpz
 sZXTETgbZpPLYOjYpVeg+n5wyT6gH9Ptl/0OzZSr5ei0AFcB/5WpljyEzYQfHgZEz5SSqJpbb2HgwMKDpcABqIMieiLK46pSo4Z5d7O5Rm0T/DHhn2gFfGvKX0zNGiG/NHP7OuHGMCSOz3gqTiNWbB+roUgMgteFRwPH6lLT26akSYtpj1bgL5sV1z/zkwSJUd/vQ+bH3ockLOZTUEzp/+mfoQvS0o8s0UGPiyLmV/4tDYsVXD9+Wy2PKVGxVGVNMSVfX1UZcUvsjnZoLiFMOMfiED4VtJTzU0FcrEHOjFj8bR3cKGDGrIoE3RV8y4I9lRTrtEQjuZL+9FsU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Alice Ryhl" <aliceryhl@google.com> writes:

> On Thu, Sep 10, 2026 at 11:00:10AM +0200, Andreas Hindborg wrote:
>> From: Oliver Mangold <oliver.mangold@pm.me>
>>
>> Types implementing one of these traits can safely convert between an
>> `ARef<T>` and an `Owned<T>`.
>>
>> This is useful for types which generally are accessed through an `ARef`
>> but have methods which can only safely be called when the reference is
>> unique, like e.g. `block::mq::Request::end_ok()`.
>>
>> Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
>> [ Andreas: Fix formatting, update documentation, fix error handling in
>>   examples. ]
>> Assisted-by: LLM
>> Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>
>>  /// Types that specify their own way of performing allocation and destruction. Typically, this trait
>>  /// is implemented on types from the C side.
>>  ///
>> -/// Implementing this trait allows types to be referenced via the [`Owned<Self>`] pointer type. This
>> -/// is useful when it is desirable to tie the lifetime of the reference to an owned object, rather
>> -/// than pass around a bare reference. [`Ownable`] types can define custom drop logic that is
>> -/// executed when the owned reference [`Owned<Self>`] pointing to the object is dropped.
>> +/// Implementing this trait allows types to be referenced via the [`Owned<Self>`] pointer type.
>> +///  - This is useful when it is desirable to tie the lifetime of an object reference to an owned
>> +///    object, rather than pass around a bare reference.
>> +///  - [`Ownable`] types can define custom drop logic that is executed when the owned reference
>> +///    of type [`Owned<_>`] pointing to the object is dropped.
>
> This diff looks like it should be in the patch introducing Ownable.

Yes, wrong target commit for the edit.

>
>> +/// # #![expect(clippy::disallowed_names)]
>> +/// # use core::ptr::NonNull;
>> +/// # use kernel::alloc::{flags, kbox::KBox, AllocError};
>> +/// # use kernel::sync::aref::{ARef, RefCounted};
>> +/// # use kernel::sync::atomic::Acquire;
>> +/// # use kernel::sync::Refcount;
>> +/// # use kernel::types::{Owned, Ownable, OwnableRefCounted};
>> +///
>
> This newline will appear weirdly in generated docs because no content is
> shown above it. Consider not hiding the imports.

Will remove.

>
>> +pub trait OwnableRefCounted: RefCounted + Ownable + Sized {
>> +    /// Checks if the [`ARef`] is unique and converts it to an [`Owned`] if that is the case.
>> +    /// Otherwise it returns again an [`ARef`] to the same underlying object.
>> +    fn try_from_shared(this: ARef<Self>) -> Result<Owned<Self>, ARef<Self>>;
>> +
>> +    /// Converts the [`Owned`] into an [`ARef`].
>> +    fn into_shared(this: Owned<Self>) -> ARef<Self>;
>> +}
>
> This trait provides two methods that have very different conditions for
> existing, IMO.
>
> The into_shared() method is so likely to exist, that I would almost
> consider placing it on the Ownable trait.
>
> pub trait Ownable {
>     unsafe fn release(this: NonNull<Self>);
>
>     fn into_shared(this: Owned<Self>) -> ARef<Self>
>     where
>     	Self: Refcounted;
> }
>
> On the other hand, I think try_from_shared() is more likely to be a
> tricky operation you cannot necessarily implement, and as such it can be
> on its own separate trait like you have here.

Ownable does not require RefCounted, so this method is not always
implementable.

>
> At the very least, I can easily imagine that some types can never become
> unique again after having been shared.

It could make sense to split the capability in a separate trait. But
perhaps we should wait with that till we need it and not introduce
premature complexity?

Best regards,
Andreas Hindborg




