Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49D07CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 21:49:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BC7D8E001A; Fri, 22 Aug 2025 17:49:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86D738E0018; Fri, 22 Aug 2025 17:49:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7341B8E001A; Fri, 22 Aug 2025 17:49:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5FA2D8E0018
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:49:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1A17058A87
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 21:49:53 +0000 (UTC)
X-FDA: 83805736266.22.9D85F71
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6F33D80008
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 21:49:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hO65IyFw;
	spf=pass (imf30.hostedemail.com: domain of dakr@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755899391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AQ7GOPbPnoi2XkOJuJzBtqyepSDg7kZviOD+6vCf7eY=;
	b=2LB9EA7y2+LB6DzFkVjyLocwmo+EW1okG7Zk0yQab+Sfb0j0cHsNFkUJn3gQw937bKcNCG
	/lLjcrGC/N+85KuIN3Hjx7if9AXauLTL96uMaCoDiSp/udqPPcUkasp01p/YENN4r3fxd9
	XuL9UrgfyAHsQkipl8XDcvcSSLUc3Dw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hO65IyFw;
	spf=pass (imf30.hostedemail.com: domain of dakr@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755899391; a=rsa-sha256;
	cv=none;
	b=jETo8a3RQ/6xe56sCpkd475cJSECgZVTFbOe/vH98m/N+AdKXagGiENIOA6oIo4rGbskaH
	8vyL8BClLRJp6GTufLkNRrcqVcrtH07hdxvNNIlpFHwGLMHGWF6PpBD8x3NYsDGqb5SBFj
	yW6EJQ09fA1nTsKtpqsHrTeL0EusCWw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 498B95C5C87;
	Fri, 22 Aug 2025 21:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E199FC4CEED;
	Fri, 22 Aug 2025 21:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755899390;
	bh=wXrPR1g3JpzZb33O4hssEbGQZzGeBolfT7rXw5mzIzE=;
	h=Date:To:From:Subject:Cc:References:In-Reply-To:From;
	b=hO65IyFwXuDZm/j1t+2HMXodd8geddF/a5rOL79Hyx9QgKrmUzsYjy8eXDjz3bhZm
	 BXUW9EvwA3AE9inv5x2cBSgCEdXw1Qikj/DCqrnSXqaPj6bndG8GdhOOOhgUlSaWUm
	 +bMvTZzULtWXqBFHDsdqwtz5tMQQMfvAx8mGZgrNY5tH2yOj44VY89IxZ+iofv29FA
	 sD/93HtObxM/3ltOyXIeoEbPtRXEG2pTp1+WY0VGnrtUqLmNVzdqd/j1XDTsdKsUFB
	 C5WBeVGq/hy4r2SYe5bqet6os814yqiR1kA0YbHnqYYwXyQeJy+DsRJmgq3C99cTjt
	 fd1MK3ZNpVtlg==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 22 Aug 2025 23:49:45 +0200
Message-Id: <DC9ADTLUFTUC.8OVFMY20FXLF@kernel.org>
To: "Miguel Ojeda" <miguel.ojeda.sandonis@gmail.com>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH v2 2/5] rust: maple_tree: add MapleTree
Cc: "Alice Ryhl" <aliceryhl@google.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>, "Miguel Ojeda"
 <ojeda@kernel.org>, "Andrew Ballance" <andrewjballance@gmail.com>, "Boqun
 Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Trevor
 Gross" <tmgross@umich.edu>, <linux-kernel@vger.kernel.org>,
 <maple-tree@lists.infradead.org>, <rust-for-linux@vger.kernel.org>,
 <linux-mm@kvack.org>
References: <20250819-maple-tree-v2-0-229b48657bab@google.com>
 <20250819-maple-tree-v2-2-229b48657bab@google.com>
 <DC6DC244ZIUL.304JSP7JFDE9Z@kernel.org> <aKRx8xsY8CpzbeEm@google.com>
 <DC6F7BN2L19O.1APQU9KWZV7H5@kernel.org>
 <CANiq72=xdryEKzo73-1vaBqGNNme2kRU0atP5PYOnOOXjNxZZg@mail.gmail.com>
 <DC8WOHIEAHQD.21VWTH8VI8QG5@kernel.org>
 <CANiq72=ZZ7+tMi_XsRKunGAqm_v+kehFqzpEMMqm2qcTvzA9Mw@mail.gmail.com>
 <DC8XIFWZN1SE.ZZP90D2N843X@kernel.org>
 <CANiq72nJiJ4K6jy17x-YRYnJpjqTnohYWvoFrLkYQp0X4tLL=w@mail.gmail.com>
In-Reply-To: <CANiq72nJiJ4K6jy17x-YRYnJpjqTnohYWvoFrLkYQp0X4tLL=w@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6F33D80008
X-Stat-Signature: jfgjyh6q9mbtme9uz1es53zomeew5u4y
X-Rspam-User: 
X-HE-Tag: 1755899391-551093
X-HE-Meta: U2FsdGVkX1+YyFtpWvU2t+TMvhghqGJV1g9MzBYsHwJpYMvuY/5CjmwxgbkqROnzXJA6b+TKSExEzdmXDoSptHrxrorTLAM+cnxUvG6NRSiVlj10LqoauKUteVhq/IjK7AvsaR5B6h1l/slOZNTr9Huifvs0AwrgQJ3/ERalZFP2AmS3N0KPSxZI6HZj8e7GOLQGzHntkdYYexUZDAzbNMUnyMTrDE0IOI0yBFmPjrGY6mGID+hbufVK8QMqDuxTGTbNjOV3xPQc7sd/OOPFs3CshcGBbxb864uHhoU/szFn7O5ejwZ6ebkClMP2HFg2aao2jGYl2z4l6w2LXen2ZNBUlVWCDJIVJYFhrjTJ531NItZSKfXurtv00vHRqVuS+b1NsEAK9X2YRx6Y3178E/gP6DmXgVAbMbpnGL51cN/mZVE2ZlpevQEY4RUU608OvO7r9OXM8LDgvtrAS8X9MquBDpYI5bmgDcEycqGrbHbZJxwmwKajMCHPmNwWnQnQMAEqSHrdpkxZN0WZAR71Z4swi1/Jw6MecdSU9mBOpMSFQrO++A+IZfYLE56lBeowPWeHl7T4b1ZJ0J7Ibg3xAEAXT7Byp2pveD9XzOyJfHUQz2hku7OFMYo0F8XYbrE9ppXVOdlZSleLw9ptRSxEL3ZtCWoyZ0xXQjGn8t0yf7t7thZ14JIVU/ZYaAPD+QOqb2U6Q6rD52GCDEVnOtX5vY7LZtBNqKtBcNpbAy+65vcBIDAi3GOhixTU6s3zqFNZTVejNfNESprVWz+uRLg/740/fyd3BQyW0tYeqeeY44USqHKQ1u9LbJxIMPH3PmxtUikmX4EeXqy/wijnkaFH6dRrSiQ+W6E/HTqeJXD2veyAfxQbiL8hsrPVR/driR0YQAcaRljOvcQUMD8ZG8evHGeoinmyvZPlVD6SyFusClYqHAqRyOA9tRcFY4UEZq9VGK422OCPZWj424DcFfM
 JvllJYxG
 ISce3e1qo+hxwzOjTnxcrHzyhg5EKST/ie2DfRK0ZKORt/OWvninWA+88WPUxMWsBUrOrM0Vs3YMTKPzaQWHq+ISvbhKKUyokm0JKjms2muZWq945KJVzh/K4YKeQzIgjmkwI3KYHR1IFfS/d5vLaSX8x80SDzw5YzxD90oniZnqkvBhQIIxy6fccSDxPK/ZrzlTQQPcKy1lzeUMeLBv4Dw/1I2LYP23zUznr9gZBwbm5G78axuqydZXsGVvkKsjk5jJft5ECFZxXzX7anATZw6pnCBMRXnv1L/AaDJbjaWdarqCYEefLvOZFgqTVPeal4bYJk2fLRLrcwRCoYhLyjCQhtbqVQ8v5OF9+MsVuLcBuyLx/4BzuLCFAam4fAWFuLXBDsmWpKqSpbsFSM4a7i3LGCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Aug 22, 2025 at 11:22 PM CEST, Miguel Ojeda wrote:
> As for being clearer, what we want to assert is that the cause is a
> given one, so `assert_eq!` seems like a natural choice (and it isn't a
> case like `is_none()` where there is an advantage). Plus it means it
> is able to show both sides if it fails. So it is not a clear win-win
> in my eyes.

As for

	assert_eq!(foo().unwrap_err().kind(), ErrorKind::NotFound);

vs.

	assert!(foo().is_err_and(|e| x.kind() =3D=3D ErrorKind::NotFound));

the only thing I can think of is that the former fails differently for when
foo() is Ok() vs. the error kind does not match. I assume that's what you m=
ean?

If so, I agree it's indeed a downside.

>> But especially people new to the kernel starting to write Rust drivers m=
ay not
>> even be aware of this fact. If they see some unwrap_err() calls in examp=
les they
>> might not even thing about it a lot before starting to use them, e.g. be=
cause
>> they're used to it from userspace projects anyways.
>
> We still have the issue that they will see the `assert!` anyway and
> thus can easily think panics are OK. I understand what you are saying:
> you want to minimize those cases anyway.

Yeah, exactly. Another reason I'm less concernt about the assert!() is that=
 I
think it's generally more more associated with test cases than unwrap(). Bu=
t
this one might also be just my perception. :)

>> I think we should do this; I really think otherwise we gonna see a lot o=
f them
>> once we get more drivers. It's just too convinient. :)
>
> A potential middle ground is to apply the lint in normal code, but not
> in examples.
>
> Or, even better, we can actually only allow it within `assert!`s,
> since it is a custom macro I wrote for KUnit and not the real one,
> i.e. enforcing what I suggested above [1].

I think this would be a great solution; thanks for pointing this out.

> Another one is a lint that just affects `unwrap()` and not
> `unwrap_err()` -- I think the Clippy one doesn't allow it now, but we
> could request it. It could be combined with the above so that only
> `unwrap_err()` is allowed within `assert!`s.
>
> We could also go the C way, warning in `checkpatch.pl` about it like
> it does `BUG_ON`.

I think your suggestion above is perfect, whereas I think this one is likel=
y to
still slip through.

> What I like about the Clippy approach is that it can be locally `expect`e=
d.

Agreed!

