Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3E8D1073CA1
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 11:54:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B94856B0088; Wed,  8 Apr 2026 07:54:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B452F6B0089; Wed,  8 Apr 2026 07:54:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5B066B008A; Wed,  8 Apr 2026 07:54:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 943806B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:54:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 31BCDE2A6E
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:54:52 +0000 (UTC)
X-FDA: 84635232024.23.66546E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7FFF62000C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:54:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uSpon30t;
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775649290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=878qm18YxMYzItfPtNMKjfhCVPT8Ifjhfhbfby67eJ8=;
	b=3b5Cg0S//LHNrbwccWPv+1yf7fnCpK85b2JZQFXa99CNQjxd4EU1iPX6AWk6C1wg+K02J9
	O3ZeSryJr7u4wAEpZGIMXd+alnaHLXnMVBJ9E9nG3QZ9cy6vhtXMpeaIUjGo/nZHn2rwip
	LUTsg956PH2xuljOGQl0x281Fmlt66I=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uSpon30t;
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775649290; a=rsa-sha256;
	cv=none;
	b=sXctn9maHXcRIAHOoeZgAd4sVN0O0fQ73nre3yxNTEZrwfgLV0f9baCf9WcYCgTZ/8YbU1
	9WkZ0HX2i1D1dVtec9v64TqLqjBy3YPS3pUntl/KaJbomeyQgXULTVSsM4na6ssXLhEaL3
	Iz3fIOJ3R5o+c7+O61X0/l2ac64VCqo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 42EDD4343B;
	Wed,  8 Apr 2026 11:54:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70368C19421;
	Wed,  8 Apr 2026 11:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775649289;
	bh=MA4d5fmu8ycPYDqnj6TGa+JGYzSgcY/0NWIkLvFzBgc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=uSpon30tvzkTfS7qtJ3EEJ/MmbBlGC7JQxCib7bKKB9Hx5QZ5zBnKqt0BWOuXoHpF
	 0ZqGrd/gni34h1C6GP0iagG+vdvDa/zuYJU9zefs3X9GgSlqJuPo3Qe78yQGdo0Fbd
	 GDRb0Wpw28RQKRtt86wQ9B0V2JUuYqJV/6SE807lC96NIVCkfHqhBJ+2FH72Bq1QjJ
	 Ob6dnX9w1r9luRnZ2h8Jr3db6fkmm1ehN/vkMUENuRM4hzV7c49MUEdczgp0rIGQyZ
	 WLk3qKZUrAEWRj8kJVse6ggIazbN+DClwtYpeDtrfTvXq6P6gbYWagmNsbUAv3rkZb
	 TgY3HvvBXGM/w==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, Miguel
 Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6?=
 =?utf-8?Q?rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Trevor Gross
 <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, FUJITA Tomonori
 <fujita.tomonori@gmail.com>, Frederic Weisbecker <frederic@kernel.org>,
 Lyude Paul <lyude@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>, John Stultz
 <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 linux-block@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 05/79] block: rust: change `queue_rq` request type to
 `Owned`
In-Reply-To: <CAH5fLggq-1pReNsRtgRfm0Y_PiQvUsXbMMkPkyO9kuhqzB3wrA@mail.gmail.com>
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
 <20260216-rnull-v6-19-rc5-send-v1-5-de9a7af4b469@kernel.org>
 <abfU_itQLa4jDy5L@google.com> <87ikamrbo7.fsf@kernel.org>
 <CAH5fLggq-1pReNsRtgRfm0Y_PiQvUsXbMMkPkyO9kuhqzB3wrA@mail.gmail.com>
Date: Wed, 08 Apr 2026 13:54:35 +0200
Message-ID: <87qzopwttw.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7FFF62000C
X-Stat-Signature: n5zyixs9dmpbefjtj4h3pj3w4uzahkct
X-Rspam-User: 
X-HE-Tag: 1775649290-738067
X-HE-Meta: U2FsdGVkX19zsfvAEtGJ4d57aIkkCmjcKM6rMtWv3jKEvXPlaVVf7kOGkSRT6+CYdfYYnIO/sWREInw/zfxgmeVdQP17gQZCIl6idpxj1Bk2TBykubYMiXMqu9LJZ9EdW7psmNNK5njy9GJm5f05W5gYrYvJwYPnO0KmlGnjqoXeNiu1TCXmtS1CpAbDhmSbtXWbR1t3dgmYyceJjox/L6fNduHcmMziFwUg32fMQecSVCgGUJf2Wg0ntbSaiW8mA1jH66aq3SwxXZduIrCT3zvGIoQX/mz0P/VMDi0bxSvZHWKYpHmdBHzbxYySiYN+21PEm9thw9yapsKU6pH2VFGwKgjjLcx5+xIyia9qDJLwEe/zflK9cI2L3eR0qyluJu0ZD7580fCzgRnGof+u9emN3i3BfMYCk2D3qMF2cS+OZfpIJs4v16vfUbH9WPgXAzlbbrUk7TKr9pjBufqySnFI96LPZAMiutKhmFumneiTUwpiHpram3KO6KEHbRCjoQQ50KH9rCuEeR2yv2pwGBChSuW6/ZLCmM1aC9DwU5fJzqhUXnSqfH/9qrbMDvkVT+mAzPMnlcYdf73Ejwkq8Il7k+64gv1qrdqz0jNJKOZW0/GPeynLn6eFBmJLd18w0q0SsTx9/OeuJGfbLJNl9YE28sjbbB6A9vbI2GIAI0OYp22RwNDzoJDviLal00jNEp/SlKy4TafDdTLAsWGKgb0MGu+UPsSP5xaBdH4Su6GOdZQWbTc9KkAldRwoKXaHQKjBSnrjM8fnjOOUtu5JivYF8opYf83ZUErK41SjRxmdwWBImN3T5f0Dsin5Fo8vrQsyI94oDivqjbShP9y6JPGycIxKbdk6wx+8tg45uDcfpdrgaIyk1Ltz0PjIr407r2mUYvv+sdrc9FmrweFDPOY3OoGG6eHhsNl//wW7UdKcKpHOmyTPPbduGGX28j9T30mkM3eeZL8AwBYxLZF
 6lNeVp3s
 dgUxV1x+0U4ysobG/sP3rFC7SVqxdA8zUPlgKCd4Ac7vBMwu9y6tiECoUdXjQF/1Cpe8bIQdcTvKcldq8faaRjEJt5+Wzgcd6OKLkBa3pRkNrhxJs8N8lPP4zYXVQFPKxCrgClEGHHQQSUZ0cYlBpVaAzUd+99YIjyEIWOazSentMMZPSEGfdHLE+wITK5KC2P2zSE0JbFeg10/IVnPvddqdkDXmofp2v+sIGNC1t2SPfC9KHtjFN6k11Fiu6+N8gLB1CHo0Jp1bSYG4ziqNpbRxIuqbc/EiHMGUQz4Lkb4dcjqucpbC+bVDl49Hm8fDezx09jwZog3oM105OcZ9xMYmsLI8TvKXlh5uSbZXTO0Vdkap2CCg5rR+i/JZ30EwrEjaBCA1GiuG2pvAYxtIzWIl1RtO5zwuT/zU6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alice Ryhl <aliceryhl@google.com> writes:

> On Mon, Mar 23, 2026 at 1:08=E2=80=AFPM Andreas Hindborg <a.hindborg@kern=
el.org> wrote:
>>
>> Alice Ryhl <aliceryhl@google.com> writes:
>>
>> > On Mon, Feb 16, 2026 at 12:34:52AM +0100, Andreas Hindborg wrote:
>> >> Simplify the reference counting scheme for `Request` from 4 states to=
 3
>> >> states. This is achieved by coalescing the zero state between block l=
ayer
>> >> owned and uniquely owned by driver.
>> >>
>> >> Implement `Ownable` for `Request` and deliver `Request` to drivers as
>> >> `Owned<Request>`. In this process:
>> >>
>> >>  - Move uniqueness assertions out of `rnull` as these are now guarant=
eed by
>> >>    the `Owned` type.
>> >>  - Move `start_unchecked`, `try_set_end` and `end_ok` from `Request` =
to
>> >>    `Owned<Request>`, relying on type invariant for uniqueness.
>> >>
>> >> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>> >
>> > It would be a lot cleaner if we could implement HrTimerPointer for
>> > Owned<Request> and entirely get rid of the refcount in request so we
>> > don't need ARef<Request> at all.
>> >
>> > Is there a reason we *need* ARef here?
>>
>> There is. Real drivers will need to dma map the data buffers in
>>  `Request` to a device. This requires taking a reference on the pages to
>>  be mapped, which in turn requires taking a reference on the `Request`.
>>
>> We could split up the reference counts into multiple fields, but that
>> would be less efficient.
>
> So how exactly is the refcount used here? Can you elaborate?

I can try to be more clear.

`Request` objects are created when a driver initializes a device. A
driver initializes a number `Request` equal to the queue depth the
driver supports. That is, if a driver/device supports 16 in-flight
requests, the driver allocates and initializes 16 `Request` objects up
front.

When the kernel wants to issue IO to a block device, it finds an idle
`Request` object and sets it up for the IO operation. Then:

1. The block layer hands off the request to the driver. Ownership of the
request is transferred to the driver. At this point, the driver has a
unique reference to the request (`Owned<Request>`).

2. The driver DMA maps the pages of the request. We have to make sure
the request is not handed back to the block layer while the pages are
mapped. To this end, we take a refcount on the request. The reference
that the driver holds is no longer unique (`ARef<Request>`).

3. The driver instructs a device to carry out the request. The driver
releases its refcount on the request and the device takes a refcount.

4. When the device finishes processing the request, ownership is
transferred back to the driver. The device releases it's refcount and
the driver takes a refcount.

5. DMA mappings are torn down. The refcount associated with the DMA
mappings is released.

6. The driver transfers ownership of the request back to the block
layer. To do this, the request must be uniquely owned by the driver.

When the device is done processing a request and we have to transfer
ownership of the request back to the driver, we use an API function
called `tag_to_rq`. This function takes an integer tag and may return a
request reference. For this function to be safe, we have to be able to
assert that the integer tag passed to the function is naming a request
object that it is valid to obtain a reference to. It is not sound to
create references to requests that are not currently in flight. Thus, we
must be able to know this information. The current implementation relies
on the refcount to discover this information:

/// There are three states for a request that the Rust bindings care about:
///
/// - 0: The request is owned by C block layer or is uniquely referenced (b=
y [`Owned<_>`]).
/// - 1: The request is owned by Rust abstractions but is not referenced.
/// - 2+: There is one or more [`ARef`] instances referencing the request.

So, we are using 1 refcount field to encode all the information we need.

Further, in the current implementation, for step 3, the device does not
actually take a refcount on the request. If a driver drops all
references to a request, the refcount lands on 1. We use this to
indicate that the request has been leaked and to know that `tag_to_rq`
is safe. In a situation where the request is DMA mapped, the refcount
would be 2 while the device is processing the request.

Here is a sequence diagram of the flow:

  Block Layer            Driver                 Device
  =E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80            =E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80                 =E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80
      |                     |                      |
      |                     |                      |
  (1) |  hand off request   |                      |
      |-------------------->|                      |
      |                     |  Owned<Request>      |
      |                     |  refcount =3D 0        |
      |                     |                      |
      |                     |                      |
  (2) |                DMA map pages               |
      |                     |---------.            |
      |                     |  into_shared()       |
      |                     |  ARef<Request>       |
      |                     |  refcount =3D 2        |
      |                     |  map_pages()         |
      |                     |  refcount =3D 3        |
      |                     |                      |
      |                     |                      |
  (3) |              submit to device              |
      |                     |--------------------->|
      |                     |  (drop driver ref)   |
      |                     |  refcount =3D 2        |
      |                     |  (DMA ref remains)   |
      |                     |                      |
      |                     |                      |
      |                     |  .----------------.  |
      |                     |  |  Device does   |  |
      |                     |  |  DMA to/from   |  |
      |                     |  |  mapped pages  |  |
      |                     |  '----------------'  |
      |                     |                      |
      |                     |                      |
  (4) |              completion IRQ                |
      |                     |<---------------------|
      |                     |  refcount =3D 2        |
      |                     |  tag_to_rq(tag)      |
      |                     |  ARef<Request>       |
      |                     |  refcount =3D 3        |
      |                     |                      |
      |                     |                      |
  (5) |            tear down DMA mappings          |
      |                     |---------.            |
      |                     |  (drop DMA ref)      |
      |                     |  refcount =3D 2        |
      |                     |                      |
      |                     |                      |
  (6) |  hand back request  |                      |
      |<--------------------|                      |
      |                     |  try_from_shared()   |
      |                     |  cmpxchg(2 -> 0)     |
      |                     |  Owned<Request>      |
      |                     |  refcount =3D 0        |
      |                     |  end_ok()            |
      |                     |                      |


We might be able to get by without shared references (`ARef<Request>`)
and only use an owned reference (`Owned<Request>`) if we add additional
fields to the `Reqeuest` structure. We need to track if the request is
in a state where we can return an `Owned<Requst>` from `tag_to_rq` , and
we need to track if any of the pages of the request are mapped for DMA,
so that we can end the request.

I am not convinced that having the additional fields is worth it for
simplifying the reference counting scheme.

> With regards to the Owned series, I still think we should split it up
> so that the patches making ARef+Owned work like Arc/UniqueArc is
> separate follow-up series.

I'll take that into consideration when sending the next spin of that series.


Best regards,
Andreas Hindborg




