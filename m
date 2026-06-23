Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2C3ECDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 13:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B65566B0096; Tue, 23 Jun 2026 09:13:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3D376B0098; Tue, 23 Jun 2026 09:13:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A537D6B0099; Tue, 23 Jun 2026 09:13:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E41C6B0096
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:13:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 059DC1C2EB1
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:13:19 +0000 (UTC)
X-FDA: 84911218518.07.FD0BEA2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 648682000F
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:13:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="W/iifiGe";
	spf=pass (imf13.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782220397;
	b=AkYk0LfIIKbj+mu6TbGlYbxlBvp87vTcDd5n30qAhiKysnMaF8kBaetTsm92epiQ249vjX
	bzI8gctY1WmcN+ag0NTqU63kX8JwYv/mnDt3CLNYaoJYHNKcNNDSlR6Kyyi1/gx3Ioog7p
	bd4O2dtble7MT0HAV7DBZUMR89dQxIo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782220397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g5mc2seyBJ1pVIiIaXg4bERPFOr66pMuwtVwk9IXTQw=;
	b=vElOm9j6+DQ22OtPyQInchnn5xI+T4zfSU+Sl7VQZeVjDUIfBnFMgzfigPUU76IRbN1JCu
	pvBcBpzKu/3Ka6IlRdVLgtNX5C1IXRpmZfGl8UWQiuzbxJAsTGY1+QXFaMFzlLobrTwrSq
	RUCOvo41BG8JFWE1LwSJ9HyoQP+Heao=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="W/iifiGe";
	spf=pass (imf13.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5564A406E1;
	Tue, 23 Jun 2026 13:13:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF4D1F00A3A;
	Tue, 23 Jun 2026 13:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782220396;
	bh=g5mc2seyBJ1pVIiIaXg4bERPFOr66pMuwtVwk9IXTQw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=W/iifiGeQ+aI6lAeV71CEqax9mMJWJCFwgoBoQoIXt5uDLfWF2eopH8ndgqr5khmL
	 ETCbgXqUuQLrRe0nw90m5Y1k/nWjyo/F9LvE0c0A9jPuFsW6g+yW9pteF6cL5KfxKm
	 6gsTB1cF8sSKT8xWb9CUH7u2G+WpMr5QrWkbkcR/0vltXolw6QZiMIyDgOog42tKMz
	 +FstpuzGaoX6FoBosQztfPgipJpx2kH42sKLMG8FKKd7zao4S1oih9afeLeAIwUgyI
	 5IWt+x5Kqr9Gmam/rVWXq/uNF1ViiAoavSb7we+Cbe6vy6rHcUnEUYAx0VyPJTwgEp
	 X8PyHtZfF+/Ew==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman
 <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, Leon
 Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge
 Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, David
 Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Alexander
 Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Daniel Almeida <daniel.almeida@collabora.com>,
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen
 Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Krzysztof
 =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, Boqun Feng
 <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Igor Korotin <igor.korotin@linux.dev>, Pavel
 Tikhomirov <ptikhomirov@virtuozzo.com>, linux-kernel@vger.kernel.org,
 rust-for-linux@vger.kernel.org, linux-block@vger.kernel.org,
 linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-pm@vger.kernel.org, linux-pci@vger.kernel.org,
 driver-core@lists.linux.dev, Asahi Lina <lina+kernel@asahilina.net>,
 Oliver Mangold <oliver.mangold@pm.me>
Subject: Re: [PATCH v17 02/10] rust: types: Add Ownable/Owned types
In-Reply-To: <ajE5c-5gZtJRoadx@google.com>
References: <20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org>
 <20260604-unique-ref-v17-2-7b4c3d2930b9@kernel.org>
 <ajE5c-5gZtJRoadx@google.com>
Date: Tue, 23 Jun 2026 15:09:04 +0200
Message-ID: <87h5mtpfnz.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Stat-Signature: 61rr9darih5wifecgs7xsty5jz1ppzik
X-Rspamd-Queue-Id: 648682000F
X-Rspamd-Server: rspam06
X-HE-Tag: 1782220397-498907
X-HE-Meta: U2FsdGVkX1/sfEykYH4iokz6y2+fR2ogR5HK0b/B755MXKijPwpYGyv0cuPLfIF4N/6oyWesOjXOFakWb8Mqoa7gHcFpIkRtVv+KgUGH6vn8kT1BGPC0q7XDh1z2ZqZinrez3T0Fsj73cAF+h+9MFj8QxNl91PpH3CsynWSvkOIxtqhxyxJ4urLP7hhlKRDfCF0+dmcChyVIYg9uUi1qGxLxCE+Cjf2tBlp00i0YvaaiFUz4gVVJ1rsSXvScwwePyvr9AoLF0d8G6psyld2LyOYorJNfBI4xKQ0xDl5nfV7kF6Gigl63q68L4utlwmWph2RtNSPT4xvOXG7o1QMWh7y9G5CnnT3hUl7VHrOEWJ9CalGZDwxueGDkpClizYS2FzaEGquYPGZVEnVpB9Av1Y5VH7du+VlknmCoteSIoWxHZ5OI4/PrruZIPUL4ybsrtuBo7KcO4RV818SIM2bciHBgIXYumqwC2qiG972YyNoZbYkC6RF1lQEwNvyY2HW08S2j8GhYNOhMPmc7Fuid7Z11fzwm0Z+eM1ssSFJ895Q1VAEYlP/WX/px/K/vfFyy0F5Nz9NemT7ouyltyTjk10mZ/0L9UeyGMwKsnfro6+gApFAqn6c8nWhYMSZEQrdy8iBr/wWegvu+K4Gdx//qD022wdFK58xkOjz6a5C6pGkupsvnC+nH/LgYWnmuDbS0zCeCidyi7NJ8vVFywTmfLrPqPnZ7ADhIsyRL1Y+S1XU+GAxoEopM5SgHxRz+7VTX4zeAGTveAI9RxNI+HsZKjUzZKOhRZcxRLtTRKKiStWqQ4piPCMxH+eOOahvG2HqfwlUnBMcNlu5kSZ6BXukT2HYHXQPpce19sskQy24EKjG5kyuZDwGA326dhRCrR86QuW5ymldLxqAVjicJxJupH0iSg2eVCyZBLmJ59LICF7zjoghWAqucBeuu53nX5riEmIZlyWDZPPIfOIuvlPW
 9Ka7ciKo
 7F7JtK56BV26bvj1lcr8dWKlKc5zPzmcyqKBXj5tyMlZ45fpZgDQWGSBmEQOCFraSjLd5ZlOfrIYTpC1HO/uL102gXBq4WEGPLyEKHnyWfBvQTdgcywU7MSUv7HiPi/04fAeCaGp0PwD0pXxc20cIG634+IDEQDQYuNbmTOlBFB7fnioJ0RR99nscfHzAv4GeGN9vQT2vksu2z2IuxLNawcPPwxz32ac9eaBUVhmMjJ0SOUP4d9EFCsUUj9dWMucTz1T20bXz/AD/tfsdPsbfpJGDTbQdqXhT3wQXkPIEFPS+EU8Pg8wqY9Gr8vjSl3VvcwY1tRx2UEBiWVhIB7ejx8tOj0oFH1WFmhQKqdedG1Jm2tUbc8N9mjpvFxXjXPYR4MGIeXNuffdJXV36U55vRolo5rQYujC+314sSV4CaT2zVgISgjPSRRSc2p+K39WQmUVe41umgQ6F+5QR2WLp2Q/MuJxCgIVPUhsrLXYTY/TSaxGkxM+gIsamzHfEmi/AGgZmt3wMIyFDyrjKobm2jeVk46QSsIcHi0Rmbkxbj89o2XiyoXA0mpYL4BAn5et2IRKF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alice Ryhl <aliceryhl@google.com> writes:

> On Thu, Jun 04, 2026 at 10:11:14PM +0200, Andreas Hindborg wrote:
>> From: Asahi Lina <lina+kernel@asahilina.net>
>> 
>> By analogy to `AlwaysRefCounted` and `ARef`, an `Ownable` type is a
>> (typically C FFI) type that *may* be owned by Rust, but need not be. Unlike
>> `AlwaysRefCounted`, this mechanism expects the reference to be unique
>> within Rust, and does not allow cloning.
>> 
>> Conceptually, this is similar to a `KBox<T>`, except that it delegates
>> resource management to the `T` instead of using a generic allocator.
>> 
>> [ om:
>>   - Split code into separate file and `pub use` it from types.rs.
>>   - Make from_raw() and into_raw() public.
>>   - Remove OwnableMut, and make DerefMut dependent on Unpin instead.
>>   - Usage example/doctest for Ownable/Owned.
>>   - Fixes to documentation and commit message.
>> ]
>> 
>> Link: https://lore.kernel.org/all/20250202-rust-page-v1-1-e3170d7fe55e@asahilina.net/
>> Signed-off-by: Asahi Lina <lina+kernel@asahilina.net>
>> Co-developed-by: Oliver Mangold <oliver.mangold@pm.me>
>> Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
>> Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
>> Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
>> [ Andreas: Updated documentation, examples, and formatting. Change safety
>>   requirements, safety comments. Use a reference for `release`. ]
>> Reviewed-by: Gary Guo <gary@garyguo.net>
>> Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>
> Overall looks good to me, but two nits below. With them fixed:
>
> Reviewed-by: Alice Ryhl <aliceryhl@google.com>
>
>> +pub trait Ownable {
>> +    /// Tear down this `Ownable`.
>> +    ///
>> +    /// Implementers of `Ownable` can use this function to clean up the use of `Self`. This can
>> +    /// include freeing the underlying object.
>> +    ///
>> +    /// # Safety
>> +    ///
>> +    /// Callers must ensure that the caller has exclusive ownership of `T`, and this ownership can
>> +    /// be transferred to the `release` method.
>> +    unsafe fn release(&mut self);
>
> I'd make this take a raw pointer because the pointer can be freed during
> the execution of release(), which references don't allow.

Ok.

>
>> diff --git a/rust/kernel/types.rs b/rust/kernel/types.rs
>> index 4329d3c2c2e5..4aec7b699269 100644
>> --- a/rust/kernel/types.rs
>> +++ b/rust/kernel/types.rs
>> @@ -11,6 +11,17 @@
>>  };
>>  use pin_init::{PinInit, Wrapper, Zeroable};
>>  
>> +pub use crate::{
>> +    owned::{
>> +        Ownable,
>> +        Owned, //
>> +    },
>> +    sync::aref::{
>> +        ARef,
>> +        AlwaysRefCounted, //
>> +    }, //
>> +};
>
> We removed the types::ARef re-export, so you shouldn't add it back.

Looks like a rebase failure, I will remove it.


Best regards,
Andreas Hindborg




