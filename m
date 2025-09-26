Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC3E4CAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 15:34:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 168928E0011; Fri, 26 Sep 2025 11:34:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1403D8E0001; Fri, 26 Sep 2025 11:34:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07D1F8E0011; Fri, 26 Sep 2025 11:34:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EC4608E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 11:34:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8E1DA11AA8A
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:34:05 +0000 (UTC)
X-FDA: 83931797250.23.B9ABC43
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id C83F740012
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:34:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JOIxIqaX;
	spf=pass (imf07.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758900844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pyh7SRpyjXugpmgrCV8plxEjtCYnRbqr/YAQRDh9K2s=;
	b=kzk/jo6ifMBo2ipUGsFAZz33axfa7hMOJ3CqJJRDEBwXt5650s3CiLrLIlhazHAgH/CAAs
	+SSUHAsv9opKZYMS+lLNDWhHo8YMqFfEH+T3N8FTREoq+dt5SbzJZacUe1n2N9vBVcxmxR
	oZ0uNIssJEOa1JYZDHngrWbSUHP2aCI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JOIxIqaX;
	spf=pass (imf07.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758900844; a=rsa-sha256;
	cv=none;
	b=3UsWPSwKT2L//sRNPW7AD3ie4uSeNPLO576F57os9S/e5bxIE45EOruh0dR4Ih/nrtq/Uv
	KagNAvfbB6nYoPC+UYbKYe69OxlkmrUeav1A2sX6Zp4vgP82ONrirMtNMa4b/4kTDcWMoj
	BQfAegUn09Eb5h/U3Kce6MXy2bMaIfQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 48F4843DE8;
	Fri, 26 Sep 2025 15:34:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22B1C4CEF4;
	Fri, 26 Sep 2025 15:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758900842;
	bh=AyEuhcc/KBdFsnEyAfH3GoL7xIxURJXhcw3SPv7GPgQ=;
	h=Date:From:Subject:Cc:To:References:In-Reply-To:From;
	b=JOIxIqaX/xLyzXWjbGYfeZLPHoJF0M3M3FYuJUkkkYntrH4fkEfMceJJ1aAs0+DhD
	 S6ayU35ln1PxQnbxa1LIg7HpXJnpPvkhktw1oWHcGJYH8fd/+Y0Oak0CXai9ZNqgKw
	 WK3F9vvwgotDBpvpziEcrNbF+16oEbmkMsh8Q2s0kWwc12zePQregiF55Ll2Ku0o/O
	 YwAMv0aAGZdbhi5tPz6h8TqxdinlGMyOb8oTpr2OapoTcVjtoCRdWt1QKRjvpZEfJ4
	 sV5uuQQ8XYRrMgzeHQ2ZVEzeyIehrttjNEYro/EozUWVUIsOGa+NYUCSioqa8H+/4e
	 bYASHKTy3TLvQ==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 26 Sep 2025 17:33:57 +0200
Message-Id: <DD2UB5P01XW7.1GW33112S22Y@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH] rust: slab: add basic slab module
Cc: "Elijah Wright" <git@elijahs.space>, "Miguel Ojeda" <ojeda@kernel.org>,
 "Alex Gaynor" <alex.gaynor@gmail.com>, "Boqun Feng" <boqun.feng@gmail.com>,
 "Gary Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>,
 "Trevor Gross" <tmgross@umich.edu>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Uladzislau Rezki" <urezki@gmail.com>, <linux-mm@kvack.org>
To: "Vlastimil Babka" <vbabka@suse.cz>
References: <20250924193643.4001-1-git@elijahs.space>
 <DD1SGLU4180C.361W5XLH76XNC@kernel.org>
 <5f09b7f5-e7de-4333-8de5-322eb6d93aa9@suse.cz>
In-Reply-To: <5f09b7f5-e7de-4333-8de5-322eb6d93aa9@suse.cz>
X-Stat-Signature: 834zym38u3d7113q7h5xkbqkn4pagryf
X-Rspam-User: 
X-Rspamd-Queue-Id: C83F740012
X-Rspamd-Server: rspam04
X-HE-Tag: 1758900843-478438
X-HE-Meta: U2FsdGVkX1/15mMvHhJlpFpkyQvoZ6Ljt4Lo338Kc2raothF0VGrvRnRsgiecB+4sILn7YPCxWaBLoss9qivve3EUrsDT0Wvaxz1/TL8bLJCpBA/C2f8X2ae7Bbh2kZBPFrHAsMRKA404orMQwpo5oyh1ms3SaHkltL9stSp3UlNmZgp2rs8Wbm5C+HB9gltoHTJNlPocsyOeDIsPiaqymsf8yHQhWprcrwMtqCxEJD8VxZ8tV5jnhEopFkw36EFZxMUf+308aaX+x3qdrCsRlJbrk8RslqVRl72UUhujgJCDyl5F/WW3vNHGNRQLpqvzzj1EFtwBX3ec6div8NIEo8afLIvgOmBLXAOkon1NqDRh8ir3HfNGTad+DiH+w47FZQYG5ubJ00AAlexnSPZPrnfQ6Kn3drpzLzh4LMJnGRyKX+BpKcJ/0HVFCOnPggo0QXaoE9xdn04jsXSgB1nAp9FK8CW2QhxEJ31bSKo5cUUk2m6VzBGnuWGhE9RDSSgtSu4nRz8TmpoxJ/G/x/iqtK2Lyzhe1lz5zUg9c+eUxnWzn+Ekw8uVpBtCL6jTbb8LVz/eyMyoYS/lgHdByR2FUWtOL9kiRZNBiGuCRHO0eR8AGlv+/EDbgSIVH6sVCFQO/0AqWWHdnsKAnXjClDIa8PKeRKRu7hqQ+UzWqytVC3QFjv6vtnV8x6Pdo7HSt5i3k1FdgYV3Xf61t79YGQU8KLU9CJRbPDD3HLVbVvSI8K+9QA6i58fimGRfXFNyH9aL6eujZ8/Hvgs3lUKMEqBpCmQ6UWoP/iOhhDHpqChNqd2slvjRjBmfKDnF2UwP81y9NdkY1aK1Dfmr0ud4T8ShlJJnDJGeHATVBPD7CO679dtlE4UdZRmrHzKgcvOx90HASzWHS2h9wFC1hk/bWCWO+lTUhQuNE/KP9jU/gM31WwcW5zKwTQdgnBIgjBmR9fcoGz2oC5dvrAqfpRYQLE
 UaLKClgs
 c09PfsrGdMUJJWhdymBt1iKyHWOSoP81SWoalukkBwbQ5cho+4VZJygy9xuv/2Kzipu4cfa5hTkbqzVCEtnidWTKqEEWB0e0NxeXlyypJmvNFH4RAKNzj8vinQkDN0XiYISk4hb7nwavHBBL32Xc6iKNQsCaM5+KcdDlZw0H4WkuOeqW0KWyiGjJ3q/jHl1/Ts2VlwFtRMQu828gks0z8WYdRAzEGKhB4j6X3nh7voR7njMRCShYD7M4eCVDAH+HXCrQtS0XfRB/ygB5Z2p5eV2jUwU/r4ocj0hlW6e9Wzbds7XYnpigWlZfBrQPtKnl9wrMgF4vd7c4CGe5GsoEziXdZqPqh6ZSVWPOZPB3aFMAcg61W0svMug2skrxNoVrjOLVA56xOtnGU+LmkMVu/ns71/n0cSr4/m23NFtOVqcXbA4cpdU7Yzr1A4R7BMIAkjlFVpSxkPk4U1BPGxNSrsj4abBqFmSuvO4unILNwWkbnWaBchL7CPYhdvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Sep 26, 2025 at 5:00 PM CEST, Vlastimil Babka wrote:
> On 9/25/25 11:54, Danilo Krummrich wrote:
>> (+Cc: Lorenzo, Vlastimil, Liam, Uladzislau, MM)
>>=20
>> On Wed Sep 24, 2025 at 9:36 PM CEST, Elijah Wright wrote:
>>> this patch adds a basic slab module for kmem_cache, primarily wrapping
>>> kmem_cache_create, kmem_cache_alloc, kmem_cache_free, and kmem_cache_de=
stroy.
>>=20
>> What's the motivation?
>>=20
>> I mean, we will need kmem_cache soon. But the users will all be drivers,=
 e.g.
>> the GPU drivers that people work on currently.
>>=20
>> Drivers shouldn't use "raw" allocators (such as Kmalloc [1] or Vmalloc [=
2]), but
>> the corresponding "managed" allocation primitives, such as KBox [3], VBo=
x [4],
>> KVec, etc.
>>=20
>> Therefore, the code below shouldn't be used by drivers directly, hence t=
he
>> question for motivation.
>>=20
>> In any case, kmem_cache is a special allocator (special as in it can hav=
e a
>> non-static lifetime in contrast to other kernel allocators) and should b=
e
>> integrated with the existing infrastructure in rust/kernel/alloc/.
>>=20
>> I think there are multiple options for that; (1) isn't really an option,=
 but I
>> think it's good to mention anyways:
>>=20
>>   (1) Allow for non-zero sized implementations of the Allocator trait [3=
], such
>>       that we can store a reference count to the KmemCache. This is nece=
ssary to
>>       ensure that a Box<T, KmemCache> can't out-live the KmemCache itsel=
f.
>>=20
>>       The reason why I said it's not really an option is because it disc=
ards the
>>       option for dynamic dispatch of the generic Box type.
>>=20
>>   (2) Same as (1), but with a custom Box type. This keeps dynamic dispat=
ch for
>>       the generic Box type (i.e. KBox, VBox, KVBox), but duplicates quit=
e some
>>       code and still doesn't allow for dynamic dispatch for the KmemCach=
eBox.
>>=20
>>   (3) Implement a macro to generate a custom KmemCache Allocator trait
>>       implementation for every KmemCache instance with a static lifetime=
.
>>=20
>>       This makes KmemCache technically equivalent to the other allocator=
s, such
>>       as Kmalloc, etc. but obviously has the downside that the KmemCache=
 might
>>       live much longer than required.
>
> I don't know enough of Rust to follow why is that. What does mean "much l=
onger"?

Nothing Rust specific, I just point out that if the kmemcache does not need=
 to
be tied to the module lifetime (but a more narrow scope for whatever reason=
), it
would still need to live as long as the module lives with (3). Which for
built-in means forever, which would likely be "much longer". :)

>>       Technically, most KmemCache instances live for the whole module li=
fetime,
>>       so it might be fine though.
>
> I think so, yeah.
>
>>       (This is what I think Alice proposed.)
>>=20
>>   (4) Solve the problem on the C side and let kmem_cache_alloc() take ca=
re of
>>       acquiring a reference count to the backing kmem_cache. The main qu=
estion
>>       here would be where to store the pointer for decreasing the refere=
nce
>>       count on kmem_cache_free().
>
> Pointer to what, the ref counter? If it's part of struct kmem_cache, then=
 we
> have pointer to that in kmem_cache_free(). Even when kfree() is used, it =
can
> be (or rather already is) obtained. So that's not the issue (unless I
> misunderstand).

Yes, the reference count.

> But we wouldn't want to pay the cost of the atomic updates of the refcoun=
t
> for all caches. If done only for Rust-created caches, the implementation
> also would better not to add branches to all allocation/free fastpaths.

Indeed, that's why I was wondering if you see other options to deal with th=
is in
the MM layer, and reading the below, it seems like you even already do.

> But also why is this refcounting needed? What would happen on the Rust si=
de
> if someone destroyed the cache too early?

Well, that's the question. I thought that if the cache is destroyed potenti=
al
remaining allocations become invalid.

If that's the case we have to ensure that all allocations are freed before =
the
cache is destroyed.

> In the underlying C implementation
> we notice it (reliably AFAICT), warn and abort the destroy (leaving it as=
 a
> kind of zombie) so I'd say it's safe. So if Rust needs to know if the
> destroy was successful or premature, we could probably just return the
> result instead of the current void.

The only thing we need on the Rust side is that existing allocations remain
valid even if the cache is destroyed. Or the other way around the cache is
silently kept alive internally.

>>       Theoretically, it could be stored within the allocation itself, bu=
t it's a
>>       bit of a yikes.
>>=20
>>       However, it would resolve all the mentioned problems above.
>>=20
>> I'd like to see (3) or (4), also depending on what the MM folks think.
>>=20
>> - Danilo
>>=20
>> [1] https://rust.docs.kernel.org/kernel/alloc/allocator/struct.Kmalloc.h=
tml
>> [2] https://rust.docs.kernel.org/kernel/alloc/allocator/struct.Vmalloc.h=
tml
>> [3] https://rust.docs.kernel.org/kernel/alloc/kbox/type.KBox.html
>> [4] https://rust.docs.kernel.org/kernel/alloc/kbox/type.VBox.html
>> [5] https://rust.docs.kernel.org/kernel/alloc/trait.Allocator.html


