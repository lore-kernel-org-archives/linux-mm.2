Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A7F2CAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 16:58:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B747D8E000C; Fri, 26 Sep 2025 12:58:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4C448E0001; Fri, 26 Sep 2025 12:58:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A89518E000C; Fri, 26 Sep 2025 12:58:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 973838E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 12:58:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 461CE13AC53
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:58:14 +0000 (UTC)
X-FDA: 83932009308.07.22D57D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id A1545C000D
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:58:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jPZBN41d;
	spf=pass (imf10.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758905892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hTXvYaTg8MyKUz4g3T1ZJcC/upqs6AKRyMn0drAfaWw=;
	b=qw900eyjRkFXunssQ/BybVTZfDOKLMDvS6OWFsdkLtp5pdN3xtLxpH52wIk4wzw7hKFuOw
	QSAeq4K8xY5/qOwtVmhlL9IzU7a/5Jb4njQ6lVHgHUqIr4RRVyMZlJ0NUr2YC5KXtzhiIO
	iUa5ZQkH/mnnevIwZW4Se5Agi8el1Us=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758905892; a=rsa-sha256;
	cv=none;
	b=yOg+v0wziEHpFPGfMhLpyPOtSPc5s0jELraSg04pTvUH97KTOEY2rCARMaTcOVc71Rjgto
	aXx6w7LyDkA3VmKzw4LgTdeVQO4K5mBR5NCsk9pBhhG8DtVRZ9q0ii3hN0mIZxq2UzAe+p
	854AO0jZad3fNciricJe3GjS/C32Ykg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jPZBN41d;
	spf=pass (imf10.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E52B361EF7;
	Fri, 26 Sep 2025 16:58:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702C0C4CEF4;
	Fri, 26 Sep 2025 16:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758905891;
	bh=jVJK8LGegwhqO+0VtnrfQPb/RxRKwtl+yfaKeB1SOzw=;
	h=Date:To:From:Subject:Cc:References:In-Reply-To:From;
	b=jPZBN41d8N96n+QGhajTpesnYkcN2IRpa1XMCib2BywYLEKk1Spw3TAKs3LwC1b2M
	 qY0Z+dgyIpC8LGOS6ZL/Cn/+lAulX1IZ09FjtYhdqQuqusr+SGmUM+3Ddpc9L9e51r
	 UZ1o2GEs1kuCWhKKkDqsYfsa0aJjDdWyQJLYPcIsPCnfxtBgw3oZM8SjC5ropmpM8o
	 7Eof93GrxvT2tMPOAffuYTLrEIofYzBFq0WwvQRJ7bgsn1UM3BEekBngPtpCau5goe
	 sZr+Ex9RQ+W6LsAJibJ0AtFLre7el6+KhvUr5S/3+ljfXBv4uoLJV2bkNaR+WXCbws
	 QO4mGuPklEuGg==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 26 Sep 2025 18:58:06 +0200
Message-Id: <DD2W3LCC7FWA.2X90YAPLI1FGC@kernel.org>
To: "Vlastimil Babka" <vbabka@suse.cz>
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
References: <20250924193643.4001-1-git@elijahs.space>
 <DD1SGLU4180C.361W5XLH76XNC@kernel.org>
 <5f09b7f5-e7de-4333-8de5-322eb6d93aa9@suse.cz>
 <DD2UB5P01XW7.1GW33112S22Y@kernel.org>
 <DD2URCNO2P88.168J48GHSJRRL@kernel.org>
 <1f5ae3bd-db21-4042-b177-55464644ce2e@suse.cz>
In-Reply-To: <1f5ae3bd-db21-4042-b177-55464644ce2e@suse.cz>
X-Stat-Signature: qas5p8kxg3dih5bu54hpgn3d988rua5b
X-Rspamd-Queue-Id: A1545C000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758905892-215234
X-HE-Meta: U2FsdGVkX19XufqAow/iibcjRsuR52EO0dms3xFiY4VPAdzCW6RfX8Sqx/Qz+oXupdy7FkSwTU95xrETbXPUDNqTzJ2JTLlzI7sMXa/D+YDuBvBmzxQp7iDlZ5dtipSeG2Du9YydaqqAcrdwPFBmty8wWgOloc6JSM8dZJe53KbcCgGHOqAST7szY6qDaYDMf6pbeRelMqDN/70Le33hyqM5gOZJK+g6xi3B98j9lCQWcg/M72QgP4jzhF7JsAvGFfBU1HcwMupbANsztQ6q/f6Px4eXNo3tjD9YJiZgarmR1mFyQJq71ZKCrGse2DfaJwC6WPge/q/Dn9xvK06ta3sRyWK4U+MqnS1jIcIC4PgNMWJLxxl6E4mMj2voV2MBSPSNf4C0VRmebEO7QKYr86KVkboNeXQlxnpyYU/sNLydrFNG0OjeN25eXYWcz1kXzXVb4QV05LjTZOS+UlDFd0HywwREihUHcsQPu+LsX+yl5ty46KQBqmmA7PDCLdvaDuInxCf+WyIkh0lhWvpeIN8lDZtN7yAsydC8fZ9OP3NK7XBdVSY5oXxp8l7EhO8sD5gAfZcFvu+GSovjs8ZE4P1OPZ9aS+NM3zZper6T6xbgr/kOnKibcPZO0n29mFuzCr3rcf+3I9g1Cna9AoL76uQLSvcuz7A4lJllKAJp312UzMXnOU+4rq/dh7cqhzVBsNkNaiw4bdbK1e96szalTZCV1vCOnIeHhcW+PDJ8F02/AIb63A9Adzftf37tQBkE187zCzCJagPVigdgaMxtu/alS80g4paPFV6doyIBQtX8nX0FRi0JF5EnmCYAfXepM96IzW+/584vLBnOrza+uNw84j7sYOt+KzGjbsI/0gpoRNwQU2PXvneYyMGjC7ur2L8WuqNgbO4yCRKUQbU4U3tXB6xC0PGdh9Z7rLnmGHVAYDCxLXyy3rpgbsX1NclPinLIIPYnyWObbt8NFu+
 G/d7iQAv
 JttD63mOf56k87m8zW424tCV52PRA0dT2THZwiHFxrqb3xMjFjeX+FTOWU/ZazbPH1/2wVXyqdAyOOfQzXEZNDCrMe0G2uYhgXOUEAqxJtP9g5TcfElefuuhHAF5l8NXYTmU/uZDuv4MCmMeTrleT06Aju0T1DeX7yGNnai0lIkHWd651pOoDHn3fSTpUWACWnUPz1psSJulhdt22AwY4mqV39IfysvLzjLIH9iQPaUb2TPbTZF/W6TNB09yjOHFU2dhg6J2e4dj0qWRqr1p3dfVf4/V4EQU52VjQoFh+mfT9UNIvqShiX4sFQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Sep 26, 2025 at 6:32 PM CEST, Vlastimil Babka wrote:
> On 9/26/25 17:55, Danilo Krummrich wrote:
>> On Fri Sep 26, 2025 at 5:33 PM CEST, Danilo Krummrich wrote:
>>> The only thing we need on the Rust side is that existing allocations re=
main
>>> valid even if the cache is destroyed. Or the other way around the cache=
 is
>>> silently kept alive internally.
>>=20
>> Or to express it in C code:
>>=20
>> 	struct kmem_cache *cache =3D kmem_cache_create();
>> 	struct Foo *foo =3D kmem_cache_alloc();
>>=20
>> 	// After this call cache will never be accessed; leaves a zombie cache,
>> 	// since foo is still alive.
>> 	kmem_cache_destroy(cache);
>
> This will cause a WARN.
>
>> 	// This must still be valid.
>> 	foo->bar =3D 42;
>
> Yes this will be safe.

That's great!

>> 	// Frees foo and causes the "zombie" cache to actually be destroyed.
>> 	kmem_cache_free(foo);
>
> The free will be fine. But not cause the cache destruction, as that would
> require checks on each free. But should be fine wrt safety if we only lea=
k
> some memory due to a wrong usage, no?

Yes, technically that's safe, but we wouldn't prevent the leak, which still
is not desirable (and not our ambition for a Rust API).

From a C standpoint, both the warning and the cache leak could be solved by
making kmem_cache_destroy() fallible as you mentioned previously.

On the Rust side the cache would be represented with a struct KmemCache<T>
(where T is the type that should be allocated by the cache).

kmem_cache_destroy() would be called from KmemCache<T>::drop(), which is no=
t
fallible. But even if it were, we can't enforce that users keep the KmemCac=
he
instance alive as long as there are allocations.

So, either we always keep the KmemCache<T> alive for the whole module lifet=
ime
(which depending on whether its built-in or not could be considered a memor=
y
leak as well). Or we ensure that the last kmem_cache_free() also frees the =
cache
if kmem_cache_destroy() was called previously.

OOC, does the cache pointer remain valid if kmem_cache_destroy() is called =
while
allocations still exist? I.e. is this, except for the WARN(), valid code?

	kmem_cache_destroy(cache);
	kmem_cache_free(foo);
	kmem_cache_destroy(cache);

At a quick glance it appears to me that things would go south in
kmem_cache_release(). Anyways, I don't think it would help, if it would be =
the
case.

