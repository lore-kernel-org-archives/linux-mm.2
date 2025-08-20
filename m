Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F048FCA0EE4
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 11:18:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 953136B0101; Wed, 20 Aug 2025 07:18:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 903306B0102; Wed, 20 Aug 2025 07:18:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F1E16B0103; Wed, 20 Aug 2025 07:18:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 67BD06B0101
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 07:18:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 13D22140432
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 11:18:40 +0000 (UTC)
X-FDA: 83796888000.28.07D11BD
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5AD86C0011
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 11:18:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j+c6f9wv;
	spf=pass (imf10.hostedemail.com: domain of dakr@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755688718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tv8EU749jBpHAt8hha4FGVprlzg7WP9YBqakTWrnkfY=;
	b=ZgsrpAHTA43b0EWpqN7jqcabwIwi7E+KOJJ5TmEMt4406AQAvx6IBQjYXHO9jCQqMyZAyP
	7PwU8wmBDx2BZJRdNLQd7+RaNTZ9slHv7iiybaPkCb0s40ZUit/pgnOncozVf7B7fSUXMf
	zKQB7YmeYXblKjsHgS0ZArbbkG0yJyI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755688718; a=rsa-sha256;
	cv=none;
	b=EUPkf5D1ooIYyLga7+hjvNJTjtcI2DnR3msro/GTlkO9sQCtfOriOsuxnF/xrNZPsx2U5v
	6TueTT69raiEHuoYCmysqgqFAkSWzISkvT6B5x2R3QDiBzj6yKZcmkiJ83LLk3jL/4+kLW
	WtLfVCw/F/FxVY69uyoFKnvc+1mwa8M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j+c6f9wv;
	spf=pass (imf10.hostedemail.com: domain of dakr@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 73C1A5C67DB;
	Wed, 20 Aug 2025 11:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D925C4CEEB;
	Wed, 20 Aug 2025 11:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755688708;
	bh=NvKhqfHAjC7nxN4srjgB/PPxA3etfbhzLv69VOVPOKA=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=j+c6f9wvQwsckWE4213N/FIFio0R3U3278n1yw8riaV8XMnaYGLGdoxefVtOkrFMS
	 vXn/Q+ukin9JH+3jKvILqVQeba6kwSB5woWp05xEtWysf1puQDnonLq8Ct4dReKyCa
	 nRSmhZPVT0Z95FeeARd++Wv1WPPLU/W1CFZWUehCJBdOgYEgExzjFcTKr036SNgPUn
	 TuH6ck7UUMIzZsj0CdxgCrnEw2XRcxk8cyt98gEuzFGIGO9CMIeHqKwRIw8Ug1BTeK
	 7dd4MBMzVvWabZP1rtovHfDU4+lR0aUpzFuFt3xneVd93sgcKYE1YzzxAOkxTCYsLZ
	 2oqRJ+TxWEzqQ==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 20 Aug 2025 13:18:23 +0200
Message-Id: <DC77PBXCZP32.1FJ6BGM9YV27H@kernel.org>
Subject: Re: [PATCH] rust: zpool: add abstraction for zpool drivers
Cc: <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 "Uladzislau Rezki" <urezki@gmail.com>, "Alice Ryhl" <aliceryhl@google.com>,
 "Vlastimil Babka" <vbabka@suse.cz>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 "Miguel Ojeda" <ojeda@kernel.org>, "Alex Gaynor" <alex.gaynor@gmail.com>,
 "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>, "Bjorn
 Roy Baron" <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>,
 "Andreas Hindborg" <a.hindborg@kernel.org>, "Trevor Gross"
 <tmgross@umich.edu>, "Johannes Weiner" <hannes@cmpxchg.org>, "Yosry Ahmed"
 <yosry.ahmed@linux.dev>, "Nhat Pham" <nphamcs@gmail.com>,
 <linux-mm@kvack.org>
To: "Vitaly Wool" <vitaly.wool@konsulko.se>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20250820091543.4165305-1-vitaly.wool@konsulko.se>
 <DC76DSYUY978.3NR8S2K13I9RX@kernel.org>
 <C642BA32-4EA5-4843-9625-5DBF40A42C6C@konsulko.se>
In-Reply-To: <C642BA32-4EA5-4843-9625-5DBF40A42C6C@konsulko.se>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5AD86C0011
X-Stat-Signature: 7yazd31hqqurkhyfpbsxpmmqbeq56e94
X-HE-Tag: 1755688718-172276
X-HE-Meta: U2FsdGVkX1+IiiYIzzwuFx03flkRbZYw8+3TEbb5EqrrY/rmu8Ii8qWQIB+Wtpjk+xC9FEcjacFs802WWk4V2aN9c2YJLOwCF5PWxBWmWz7/qpXLZy3O0KKjeE5RlF0+E33OC+0RVYydnTGOeb9hA3B0jMgmERQiG/TO4qbZsIIdyztKAmaBE+E1IM3a4s6qDdhBWgyjE9GZVIAIxo0QiAH9tDejzb+Zjt/NGMH9NGXsTnOR6ecN3+J5vwznQeGfXq+uZd1xrKwCJEvihMKjskGbyozW2MyRCqPK/JRtWLK7/I9N837KbQ3hIksfXzsInpYeisE3+BRNZZY9hKPobhcng59W08gI3DSeHLPv7u35NkYc6+1FjlDNv+xDr4K6U4FDvrOTcN7BH9vHXO1Njz67ZtsjaUM6jtiN8VIJDvnzIwiwK3Z0sqqFeKBz+tO0WX5i/tCmutZo4FMCvyh2As5fXXdMZ8HrYMsjXFKXMkhff5DAEsfCMqhZj0GQW/pyUeO8vCbg/nUWBQ6A4KHD/GmdaulbVokWYQ7Kiq4M2WypooiKCRbwckW+pfVIH9+FX1IEKNNCRZ3oPbo2+FAz9cN/wrP2v2GVuC6C49V2QCSAIeCPzv+elVbAhvm4Pxgu+R6OQRbJEiaoxvyqeuWTC3DKQxeWMLpuLnKc2SXt18o3Syk95OQwjpIvludHxljCAc2bX7Jb7yyuj782a7bmbUo4LW4A1/AvxURw8RoMiKzUIOf1sTQRb7BPP8K9GpGB4uR7D6FBtZVdmoWKK7DrTMHMLpvF7bUPHhuOocn1BF9upbFADpO2vmtrweIbJHvnSmLi+26zzwOpPGczXJ2tyo1PF1g55tQ/+nqIfo1dt4Zqyoy+nLABSqH/v1SddmN2Kech3gh9aKNaYZlYTynz/l78PI5h1JsAsoOCwxmBSRqedPv0tQ6DHC5s6MZHSwru5O6cluTHnnUBRaNwSI0
 4WkgAdbN
 q8LWa5Bg2wu2onUAxAQF324htoeSiEiz4rybH5Ss8OkoTaKmF0sF9Ki6l0sxpg2gt2Y+afcgblay9u0Sb0969Qvb/3l2t/hmLeY/qrwOo86tAOs4S+9EOGlgFDD7ys9MfXu0uGDZ/HbvCeFyDmIa+kaCS4vqv2XMRNGM8++HDCxzAkBkU62DLJYzI3mvvMIcpQDH8rryB8PBxj4Cmhl9UUhhn2iWx1qJEyYEbwRX/KI1rIp1kmBsX9cv+DEwqOZaTR6JpBZK1AvK9B6qpunl0bn3/qaFMu4qf8q/cFsj7VVVMOzhVHOcqZBi8biXDz2gfBxyybmf85ASOUV19Xj4OSZ6k5Zbq77nH9e1DpSKTYcSIYhCdVtO2sz5YdX3vTwPIyA264kkFGb2i13YhMGDdZvKrr/Cc3ry/NaQg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Aug 20, 2025 at 12:44 PM CEST, Vitaly Wool wrote:
>> On Aug 20, 2025, at 12:16=E2=80=AFPM, Danilo Krummrich <dakr@kernel.org>=
 wrote:
>>> +/// zpool API
>>=20
>> It would be nice to have some more documentation on this trait, includin=
g a
>> doc-test illustrating some example usage.
>>=20
>>> +pub trait Zpool {
>>> +    /// Opaque Rust representation of `struct zpool`.
>>> +    type Pool: ForeignOwnable;
>>=20
>> Something that embedds a struct zpool, such as struct zswap_pool? If so,=
 isn't
>> this type simply Self?
>
> I think ForeignOwnable provides a good representation of 'struct zpool=E2=
=80=99 and it=E2=80=99s convenient to borrow it, as done later in the patch=
.

ForeignOwnable is not a representation for a specific type, but rather some=
thing
that originates from the Rust side and is owned by the C side. But that's n=
ot
the case here.

Regarding the "convenient to borrow" part, why can't Zpool::create() return
Result<Self> and e.g. malloc be defined as

	fn malloc(
	   &self,
	   size: usize,
	   gfp: Flags,
	   nid: NumaNode,
	) -> Result<usize>;

i.e. why does it need to be ForeignOwnable in the semantic sense of the tra=
it?

>>> +    /// Make all the necessary preparations for the caller to be able =
to read from the object
>>> +    /// represented by `handle` and return a valid pointer to the `han=
dle` memory to be read.
>>> +    fn read_begin(pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>, =
handle: usize)
>>> +        -> *mut c_void;
>>=20
>> Why does this return a raw pointer? I think this needs a proper type
>> representation.
>
> The zpool API wants a raw pointer here so I decided not to overcomplicate=
 it. I thought of using NonNull<[u8]> but it doesn=E2=80=99t seem to be a g=
ood fit. We=E2=80=99re basically returning a pointer to a place in memory w=
hich is guaranteed to be allocated and owned by us, but it is a raw pointer=
 at the end of the day. What would you recommend here instead?

I don't know the exact semantics behind read_begin(), but we should at leas=
t
encapsulate the pointer into a new type and restrict its lifetime to the
validity of the encapsulated pointer, such that it can't be used in the wro=
ng
way.

More general, if we don't cover such things and use raw pointers for conven=
ience
instead, we may not provide enough of a benefit compared to what we can do =
in
a C API.

>>> +
>>> +    /// Finish reading from a previously allocated `handle`. `handle_m=
em` must be the pointer
>>> +    /// previously returned by `read_begin`.
>>> +    fn read_end(
>>> +        pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>,
>>> +        handle: usize,
>>> +        handle_mem: *mut c_void,
>>> +    );
>>=20
>> Same here...
>>=20
>>> +
>>> +    /// Write to the object represented by a previously allocated `han=
dle`. `handle_mem` points
>>> +    /// to the memory to copy data from, and `mem_len` defines the len=
gth of the data block to
>>> +    /// be copied.
>>> +    fn write(
>>> +        pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>,
>>> +        handle: usize,
>>> +        handle_mem: *mut c_void,
>>=20
>> ...and here.
>>=20
>>> +        mem_len: usize,
>>> +    );
>>> +
>>> +    /// Get the number of pages used by the `pool`.
>>> +    fn total_pages(pool: <Self::Pool as ForeignOwnable>::Borrowed<'_>)=
 -> u64;
>>> +}
>>> +
>>> +/// Zpool driver registration trait.
>>> +pub trait Registration {
>>=20
>> I think you should use the kernel::driver::Registration instead, it's
>> specifically for the purpose you defined this trait and ZpoolDriver for.
>>=20
>> As for the C callbacks, they should go into the Adapter type (which impl=
ements
>> kernel::driver::RegistrationOps) directly, they don't need to be in a tr=
ait.
>>=20
>> This way a new Zpool Registration is created with:
>>=20
>> driver::Registration<zpool::Adapter>::new()
>>=20
>> This also allows you to take advantage of the module_driver!() macro to =
provide
>> your own module_zpool_driver!() macro.
>
> There was once a problem with that but I don=E2=80=99t remember what the =
problem was :) I=E2=80=99ll try that one more time, thanks.

I'm pretty sure this should work out well (just like it does for driver
registrations such as PCI, platform, auxiliary, I2C, etc.). However, if you=
 run
into issues, please let me know, I'm happy to help out resolving them.

