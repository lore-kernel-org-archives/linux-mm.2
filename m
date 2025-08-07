Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1335C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 18:30:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40B4D6B00BB; Thu,  7 Aug 2025 14:30:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E31F6B00BC; Thu,  7 Aug 2025 14:30:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 320006B00BD; Thu,  7 Aug 2025 14:30:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 249E56B00BB
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:30:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 90E6F140AFD
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:30:23 +0000 (UTC)
X-FDA: 83750801526.20.CA5EB89
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf29.hostedemail.com (Postfix) with ESMTP id D37CE12000A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:30:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lmkfJM/L";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of dakr@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=dakr@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754591421; a=rsa-sha256;
	cv=none;
	b=VDCX21VqJ/Zzla+GRrkD+f0ISGm6+YHWCYPszBKEWKRj8mv1/RfJ2inQ7RWlAUJb1UNc43
	6/+wZNcv3vFJkTD/KZA7Xhzeufh7OTl7vOkibGsme7crvqc4jBbXkhxUhH5TTv4ksdo0CX
	kOpeynOTJ8CJYl3VJBaMM6VSApjGj70=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lmkfJM/L";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of dakr@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=dakr@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754591421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/j8vh2RSPP8shfa1Kylb0837DSiOhHBLH6f6C4ibAA=;
	b=YEU2ceXFplYb7lG7YnU9lfB1WkJYTbCCgc9X0Fm0I9g3FcDay1We/4dfdGDQGX7x0x8v6a
	WxZIMWEgU7582P8VJd4v+oTzcvjSXN43AnAvKvN82GuBr2FabRDfxnmemrUZsNTpwK4F3h
	GfwihOz3ivsAkzPz/J/keNNtxK/cvEI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 338B8A55B5B;
	Thu,  7 Aug 2025 18:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7A2C4CEEB;
	Thu,  7 Aug 2025 18:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754591420;
	bh=fvKzj6dUHRc3HjFsvlOPaQYwooIML33QLBDFoF6wir4=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=lmkfJM/LS6/7uM1TyYApJ0aWL6Xc7yNpgS1I0uzHlMlTxvDhBTz5h8jtlKu8jhaxe
	 q5XLt+pxPU3vUy/IwD3lXnX7/BeC9DVmiroVtHbiuL/SsUq2WXQPalfysR5OBK/xtP
	 nxSygpIcW/9nAK92lvoIRPa9tBwrU1S0M7KhKrcv/3LVfKqfBUch6ahNTFQoIF6oQQ
	 z6KQc+1xDkeZYzap5py/DsIUOGBG8caN/UROmEZ9834uop1nnz8qDxP/oIsN1iyCoJ
	 dSWzwbXWHe/MeyRErzxAYf0gFZxlnP3Qd6BF6nUMCzgKEk4ZIPHwJT0KrD+PQhlqJf
	 ABHHa4Kw494nQ==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 07 Aug 2025 20:30:15 +0200
Message-Id: <DBWEQWVWLJWA.2JHS152T8YSO1@kernel.org>
Subject: Re: [PATCH 2/3] rust: maple_tree: add MapleTree::lock() and load()
Cc: "Gary Guo" <gary@garyguo.net>, "Alice Ryhl" <aliceryhl@google.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Miguel Ojeda" <ojeda@kernel.org>, "Andrew
 Ballance" <andrewjballance@gmail.com>, "Boqun Feng" <boqun.feng@gmail.com>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Trevor
 Gross" <tmgross@umich.edu>, <linux-kernel@vger.kernel.org>,
 <maple-tree@lists.infradead.org>, <rust-for-linux@vger.kernel.org>,
 <linux-mm@kvack.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20250726-maple-tree-v1-0-27a3da7cb8e5@google.com>
 <20250726-maple-tree-v1-2-27a3da7cb8e5@google.com>
 <20250726165020.46880c31.gary@garyguo.net>
 <CAH5fLgi-3oT8+5Krzrg5JeagJMm6-8FNVr5G-UAszuhi0qZ1xA@mail.gmail.com>
 <CAH5fLgjB7-xJ2OjVa6nxnUPk-1+wyxPMWQ15-Vc3mUp36+_Rhg@mail.gmail.com>
 <20250727130257.3549ea3c.gary@garyguo.net>
 <imzcbuqlhj3dhzxyk7t44pt3ufxckwlonuqpsdohxuztvk3sss@z4douqoxmxqw>
In-Reply-To: <imzcbuqlhj3dhzxyk7t44pt3ufxckwlonuqpsdohxuztvk3sss@z4douqoxmxqw>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D37CE12000A
X-Stat-Signature: ibj8oz3ipwfyz7sysac34ow9s7ipx8s6
X-Rspam-User: 
X-HE-Tag: 1754591421-705962
X-HE-Meta: U2FsdGVkX18EYPdCa6VjCPiPzJYHQB6R1UaahdIjY+4riSB0LHZ61MkiG7orPGsexbrX/0cAmUnUYr1c1KAwHGeyzhJDVeTtWszg/Vs+v8GfBnNlnKz8rhMiN3B8fs81VqejwivRpjJqa/HfuRA0qyUWQw4FVKArlLfoai93pNSUSAa4FwGHQ4tPdPjEfNz+xp305TdLZMdkFzWZvhh+TBdN2p+tOglUP75iCE0Yp7Buxx4yMWx64SxUP3T6U6N+I3Q5Q3/+3BHtsifXF+qC9fP3MCdEbwSi6XiSfB20dmoEn91yBILc25TKQliEbjqos38OW3z+C9ElIFZem1IbuPLO2iioLPhkIlgzq8AKbnwbH0ag4j7coMy0HDq/2PHN9FgKuOd719bpNtyV4vuUpr0ZGuE7zmuypWG1kDgvNnR6MEskcnD5bvPlRvjNvRmYVv0w6L0F/3evYQ5ZaXXZtWUVvyslui1P+Yn4BD6sTGlYzG/hkbioEl+SjBERac4qgoePoB6Z9JMuo9Ya1sK1o3thi8VZ/Z63dDe343SLE37jJLqrEfB4aGStm95tXkjN9JV5FLjImAhIiw8ZIdxriO1V8kXFGJljGcBf6erT0gR2n8U+SWxstrn9uNtrIdWB3s+5fOsu/E+4aA0272s+UgO8KzED00Gy5VLs7OHM6rNBIL5MYkxQXkO5vMF9LrbICenDU5Psz1Ol0Gx+td20IafzCdDnzeGqXO3k67UqkLF/iY9GfGKbxSQsg7q23t+/4tCFfOEwSI854ciC7S+1yOh6W4zqkXfIFDo8slDIPJ/mTddb8UlaWV7g1o65ofaT6RuFT2KiH/Kl7SbBbVrl5uJrsZgT4Z5xTe+ouZ6VC/syYcS84ZhlH/5JpPh+E427pr1OYK0OubgBGVIiHDddd5DxtjR9Fs5E4IuMTX2pk5JF3HtTfIbK/tS8di4t72ZxTGeUMs4UxVLglihZvFy
 l6hJlpnc
 qaPojAqOThVjWB3TdfvXIIJ9yljWCWLAIFm4GJ5uT/Y//kK0Ko2QYdEFWLDKMGrK7qMuTvYhpPzcBCbb/eAEStT0CdsXvJ38SC5DUQXTzf6RoNdYpMrodIFJzAszpAb7YU8nsSh8aGVss0+geMTSO8tqIpP+z0siZApF3tWro+puf5oxOWp1wJgD6oBtxTfCQxOMI4t03LdYy88WTsCVKhA1qpuwIdF7krZ1fgZCEjxFFF8qNVeIiizh1tDDZql23yU9lqws/HC2d1Wbv+GsnTMtpl2/VAuxObW3anc9Shv+a23UkrVAjyA7VrqjBM1V5DHieEgebjXkJclgEPTOqngwaQY2Qh5f/sljkWgzNtzETgq0AKYrCKsNtpKGLk0SHysKKeo2JNsozVza4WV864K9kEaAuMawVUW+NZ1Sp9Eg6vFVcg4b5xfSU/6ugkF3e+RmV0XP7H/T60gY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 7, 2025 at 6:15 PM CEST, Liam R. Howlett wrote:
> * Gary Guo <gary@garyguo.net> [250727 08:03]:
>> On Sat, 26 Jul 2025 18:18:02 +0200
>> Well, `Lock::from_raw` is designed to interact with a C-side lock:
>>=20
>> > Construct a Lock from a raw pointer
>> >
>> > This can be useful for interacting with a lock which was initialised o=
utside of Rust.
>>=20
>
> If it matters for future build out, the tree supports an external lock
> that may not be a spinlock.  This is currently used by the mm for the
> vma management, and others (although willy wants it to go away
> eventually).

When I was considering maple tree for GPUVM, i.e. vma management for GPUs, =
I
would have needed the external lock as well. For GPU VMA management we have
section for which we have to ensure that the tree won't be altered for a
sequence of sleeping operations.

In the worst case we could have used the internal spinlock and yet have an
external mutex for this purpose; an uncontended spinlock shouldn't be that =
big
a deal to take. So, long story short, I think there may be a few cases wher=
e an
external lock can make sense.

Just to recap why GPUVM couldn't leverage maple tree: we have cases where w=
e
have to pre-allocate multiple entries for the tree, whose ranges are yet un=
known
at the time we need to pre-allocate them. Unfortunately, I can't think of a
solution for this given that in this situation we can't predict the number =
of
new nodes this requires.

If however in the meantime there have been ideas to tackle this please let =
me
know, I'd still love to have maple tree for GPUVM.

- Danilo

