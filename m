Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE20CC88E40
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 09:37:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F0846B0088; Sun, 13 Sep 2026 05:37:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A1F46B008C; Sun, 13 Sep 2026 05:37:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 891E56B0092; Sun, 13 Sep 2026 05:37:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 612A76B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 05:37:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65157A0651
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 09:37:12 +0000 (UTC)
X-FDA: 85208235504.12.2D0AB7E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id DED1A40004
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 09:37:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZXq3ebKy;
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789292230;
	b=2tQbtnFd49Ed7IaQQ8gTLB1fWDJyVS9uJ4c3HhaFwAcHVi+tc2FO0Iss2f2uNlguhv/bDk
	PrA1cwDNZECosv2rHCBrUVvgJWqi70UzMdd2A6Iq5mLDMvYdQadH41YOGYFyL/mQEwL2re
	EGtWA+1hCr8RQnw71kVsfQB6OiC5Ujw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZXq3ebKy;
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789292230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TeKLAo2lyBFX9D/j+t1NddJvYANiKwcO6O8pNn5tCYg=;
	b=G7b81PJGrmta+7kusEcqsWp9+JZCSlt1vuZJD8USSh5yiG/JDHOrJVQIyP+P/jONwCFIN1
	PHuOujMm2TsBSBkH1jSY7guSuP+CEhY8gTmia8kZbZJXoAXpVIS0VCfymgvOrJbvc/fGwV
	7gMYyVWH917zf+naCW91vblwjjLWWzM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 370D360AAB;
	Sun, 13 Sep 2026 09:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B941F000FF;
	Sun, 13 Sep 2026 09:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789292229;
	bh=TeKLAo2lyBFX9D/j+t1NddJvYANiKwcO6O8pNn5tCYg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=ZXq3ebKyzE91YMdk8KbwizzTYuRfKiJOjlC7hKcGtHQQZJ5nCJUfiu07FF3uqPR7f
	 o6PqZ16b+Hzz787iWq7uAC2vR9/5i/IcYkPHKcuLhWMNuP85R6uSJM7F8FyrlWBS1Q
	 KGIHV9T/yk+v10sUF/WNyxF8c8Po1Eo24e9YNLKt1UalWmzbnS3U12EvMGLOio9tEM
	 ODMte60um3jwtWBD0ubXBYEB7KUwVDXh6qnHC7TqbJBMW531TTW44iAHQTQrd9L9Ll
	 YCzgkk7cH0cJu67QwfwU4dQxrTMaBkv9vzAy6OxG6D2amnqezq/M6SGoPo0FCl+y/h
	 jcgRapmP3RlUQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>, Miguel Ojeda
 <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo
 <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Trevor
 Gross <tmgross@umich.edu>, Daniel Almeida <daniel.almeida@collabora.com>,
 Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot
 <acourbot@nvidia.com>, Onur =?utf-8?Q?=C3=96zkan?= <work@onurozkan.dev>,
 Lyude Paul
 <lyude@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve
 =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>, Todd Kjos
 <tkjos@android.com>, Christian
 Brauner <brauner@kernel.org>, Carlos Llamas <cmllamas@google.com>, "Rafael
 J. Wysocki" <rafael@kernel.org>, Dave Ertman <david.m.ertman@intel.com>,
 Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge
 Hallyn <sergeh@kernel.org>, David Airlie <airlied@gmail.com>, Simona
 Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan
 Kara <jack@suse.cz>, Igor Korotin <igor.korotin@linux.dev>, Viresh Kumar
 <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen Boyd
 <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Krzysztof
 =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, Pavel Tikhomirov
 <ptikhomirov@virtuozzo.com>, Michal Wilczynski <m.wilczynski@samsung.com>,
 Ira Weiny <iweiny@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Philipp Stanner
 <phasta@kernel.org>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 driver-core@lists.linux.dev, linux-block@vger.kernel.org,
 linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-fsdevel@vger.kernel.org, linux-pm@vger.kernel.org,
 linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org,
 linux-usb@vger.kernel.org
Subject: Re: [PATCH v21 9/9] rust: page: add `ExclusivePage` for race-free
 page access
In-Reply-To: <aqYUWzRSade_Ww67@casper.infradead.org>
References: <20260910-unique-ref-v21-0-e83257373062@kernel.org>
 <20260910-unique-ref-v21-9-e83257373062@kernel.org>
 <aqYUWzRSade_Ww67@casper.infradead.org>
Date: Sun, 13 Sep 2026 11:36:53 +0200
Message-ID: <878q55v6fe.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DED1A40004
X-Rspam-User: 
X-Stat-Signature: ridd7wj5teb8rxfwx7rhfncfnywy4ruy
X-HE-Tag: 1789292230-675032
X-HE-Meta: U2FsdGVkX18xYRRKHapYrihDvSExcQ3UsiDKfoRvIM8UuJ2YkU8HUjquX3oqsPuovaB5ReFSDhFRvH0Xip+hoVttSsAQyGYhITZrujsYXbfs0IIFbIULIWhf4rKdLd7uoNfEl5z5O0P8H3vjBXZS+/XspOaqk6uQ9a9Tq799UL1gDXAQm0+mfRTBD9FckG5FSret07KJ9hctQZ4QZcqSHN66hG9oQ2f12W6LGHa6HdiP5qeDL0rDzamFe0kt8ReI5sITU04fVo2lfPLtkbhE4xTpMkzQh8FtkmeUCkDD7qPK3j5LBKZ5yjJZhHgnaag6LhfU+4ftJ6uN5zd4x1VeNa5ZVS5c7u9jBVbBXBDLkEMLkfhMZ9JidEQEwAuqV5qIdOnHYVSPBOU7SHrn69ENaxv0qSKNAy6lY/d3Eb4YX2bkM7GQUFIytgXg7VMSZ9BMqW3DeJTS6X9UtrQEw1Ym0fc2SNc9EJe6MNzev6P5Aawu9ZqJBzTz36x84gAp6J6wrLpDLyNHpwODeNTClIKQqvNfSx5cLS2aPh85kow8zOLsKkL5BvnqNgMSCpbrBW8bJTjAbUkHR0n5NAyK7TL1wRB0CzjAJJXlyp1yuzl6CGi8Ei0CIshCjgqafoUQpns5hJSkUggZ/XdY8+EFfnofCcsvL0QbqvYafaxRtKG9A5EQfXVz44EMXBtYT52TKZstL3c/ncBEn3ryPfhPh0d4lcjxDeE9k90Eyz7IX1iqBvTzmwLGbp8wzkIYT/pbFkgkTT2ApEfETKWRDqRapWNECWMG80Rm5kxCW78Ns70d1GDP6uyhzJvulukkSOl/HSHtPQk96JFKfmgMTXuORga2+toZ3ZluijrddL92uu+E/AuP3bP0eXdgep+JKeeMhz0NOK+Nyd3RLNccQ20sB/zfh637THYwbG2qdTlFk19zdxAzTOwm0CabaFx458EmOvidpJuaZczsMPMNmJjCoZF
 BunMDtfd
 vPmfVvwGY4F9l4ocR1V5JSxPRm4ovmaxZwm6QrpLlFzgKmfBraQQ10r7D7YBiLxAPfWdGv43QlWTz3pdVnTL20RIJqmz9aJhPeA2NGw+LTS5ZNZvbgB13ZuKJKkIQrjwEWEMJLE6G2d4foSMeFtW2UO2igy7VcOZcnRsjDOUy3OXR0jWkc2cay6Y6bANHGVfFYY/u709ZNElgwHCOxUi+WfXQx+3bRRTv9tNFRvVcjFpOPJqQkOx41tNdP0wj0z3oaSeDk6rMl6+WjKuvdS94RXnaokLBAIKhYVFwkF5xPEWVuoUZUUubW7rYwwg0kJDRnVP5TpRw8HYEDe2ude8QTKV5jXCWC7r3qVHlac92ZZLkJ7c47qU+1yHXkWCGMCHKYKlAIxvfloPDAaU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Matthew Wilcox <willy@infradead.org> writes:

> On Thu, Sep 10, 2026 at 11:00:13AM +0200, Andreas Hindborg wrote:
>> `ExclusivePage` wraps a regular page but adds an invariant that the
>> page data area does not incur data races. This means `ExclusivePage`
>> cannot be mapped to user space or shared with devices, and it
>> becomes simpler to directly reference the contents of the page.
>> 
>> Since `Page` implements `AlwaysRefCounted`, handing out a `&Page`
>> from an `ExclusivePage` would allow safe code to obtain an
>> `ARef<Page>` to the page and break the aliasing invariant of
>> `ExclusivePage`. Thus, do not implement `Deref<Target = Page>` for
>> `ExclusivePage`.
>
> Given this description, I wonder if this shouldn't be implemented by
> alloc_frozen_pages() / free_frozen_pages().  We'ree certainly trying
> to move the C parts of the kernel away from thinking that pages have a
> refcount (folios have a refcount; otheer memdescs may or may not have
> a refcount).  Do your intended users of this actually have a need for a
> refcount?

I'm not familiar with that API, but I will take a look. The
`ExclusivePage` would not need a refcount. The reference is intended to
be exclusive, giving mutable access to the page contents.

I could imagine a situation where someone might want to transition a
page reference from exclusive to shared, but I do not have a user for
that at the moment.

>
>> +++ b/rust/kernel/page.rs
>> @@ -17,7 +17,11 @@
>>          AlwaysRefCounted,
>>          RefCounted, //
>>      },
>> -    types::Opaque,
>> +    types::{
>> +        Opaque,
>> +        Ownable,
>> +        Owned, //
>> +    },
>
> While I'm asking stupid questions, what's the significance of the //
> after Owned?  I see it after RefCounted too.

It is a hack to get rustfmt to format the import statements in a Linus
compatible manner [1]. As far as I know, it will go away once rustfmt
learns to do this by itself.

Best regards,
Andreas Hindborg


[1] https://docs.kernel.org/rust/coding-guidelines.html#imports


