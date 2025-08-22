Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CE7CCA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 11:44:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84F9A28001B; Fri, 22 Aug 2025 07:44:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8272E8E009D; Fri, 22 Aug 2025 07:44:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 763F028001B; Fri, 22 Aug 2025 07:44:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 60F618E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 07:44:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0343481279
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:44:39 +0000 (UTC)
X-FDA: 83804211120.27.2A16F4E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5CA8E1C000E
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:44:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="F1W11D/J";
	spf=pass (imf21.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755863078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NE31bL2Ymc7yqrH9LQSWQCDabRe+yWHzak4y6y9X5cU=;
	b=nJpUXTDpqFTGnyeDz7k65WHxrovpp1yrs4S3ft5p0QGXH6z0Z7AYm3rtIwgJciJfgGwPO5
	X6P9bmQVwUifY0F36g5Jbka5QoWF2/wR6nasjOdtblYFGgVnshscZiFdgPA1bVjjVxoKif
	mnQDtZTUzeKT5bfKoYAQk7yWQWZxQeg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="F1W11D/J";
	spf=pass (imf21.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755863078; a=rsa-sha256;
	cv=none;
	b=EBFGS2l9U4g7niZpA8fV7h5OVfe3oAt3XiQ3MrimUYXGg5PwYArht0yGxgA7mSwNF+hpDG
	2dUynbursiOZFcMlPt3SvvN9jokY4D3zZf6VPpmc+NZ01INZs+cyK+w0ArN/ARkA5uKyo6
	EVzSVsotetuKzCjZqiQZifoM4VZIV7Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BD40660266;
	Fri, 22 Aug 2025 11:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C73C4CEED;
	Fri, 22 Aug 2025 11:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755863077;
	bh=Ehes+TywfQ8xDxHjBhYwV5+QsAnE1nz2pIE2gJ1LGto=;
	h=Date:Cc:To:From:Subject:References:In-Reply-To:From;
	b=F1W11D/JM+EVtZrd92D8APNnrRop1qUdCnOCAAI9gsr6pFiXkKFWqTBytD/QTtUyd
	 iBoNrJwEsu1fXNzWoKiBt1n1lVURchROVLD1cmjvzUhwTGQo40OjJtpfs8Fn81qRCX
	 YrxCtcPh8l7cCgzF11ttjKLP7uQtXBH7CbMUhV832gEqDJekFDAwxYLfCLviOwEN08
	 jvy73WQG+l5k04vvDHgGb9Qsslni5m/A7j39xE2gAnfBaez53gEEFFLYyvI/jSnG20
	 aj5o8tCaNHsYYggUwZC9CDcmvPC5wkstUB2bh9p5HFiKLhkC3J7R4ouC1v5AaScFSH
	 9OPNIZrlm0weg==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 22 Aug 2025 13:44:32 +0200
Message-Id: <DC8XIFWZN1SE.ZZP90D2N843X@kernel.org>
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
To: "Miguel Ojeda" <miguel.ojeda.sandonis@gmail.com>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH v2 2/5] rust: maple_tree: add MapleTree
References: <20250819-maple-tree-v2-0-229b48657bab@google.com>
 <20250819-maple-tree-v2-2-229b48657bab@google.com>
 <DC6DC244ZIUL.304JSP7JFDE9Z@kernel.org> <aKRx8xsY8CpzbeEm@google.com>
 <DC6F7BN2L19O.1APQU9KWZV7H5@kernel.org>
 <CANiq72=xdryEKzo73-1vaBqGNNme2kRU0atP5PYOnOOXjNxZZg@mail.gmail.com>
 <DC8WOHIEAHQD.21VWTH8VI8QG5@kernel.org>
 <CANiq72=ZZ7+tMi_XsRKunGAqm_v+kehFqzpEMMqm2qcTvzA9Mw@mail.gmail.com>
In-Reply-To: <CANiq72=ZZ7+tMi_XsRKunGAqm_v+kehFqzpEMMqm2qcTvzA9Mw@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5CA8E1C000E
X-Stat-Signature: xqmwqro7b36t4t3qc3tgzhtrtirsjddy
X-Rspam-User: 
X-HE-Tag: 1755863078-475666
X-HE-Meta: U2FsdGVkX1+aWSTyus6BL/MqAORy633a5oSDiQQ5kBFG8mhXlKQsPE0+RmTIAfFPsSBgny2Wseu8PakVyPxxbSDJJKJ91uzZna2oVYM+D7jyXr/vyRZNbANyWmNhTacrFFfwP0ODL3K9Ykcqh/aqNVHpVCulT4TZMnUz6J4KfMYaYyoEUkIVP9UK8In/R/XHIZO7fOcYTtDBmF7WNjsdyMJJ1TPCPLFXF42ET75qMEriRjEoGh2uQtwQuTASHxC+HK6rRnyx4NqsFgwZVpXnREi12zqnKo1ShGxAspvQfjAwmuNR17Ghng1BVFjQNNR0amY55Vbxh9hXIxTlLKgp/1ooRCH/FCmDmsaF3rGmGt5co5OVrTK9uAJqtba3OioRmgi1nu5relpkwJ+dBSp9k4D5vggqIg+XlJM5vL+eAYLBKN8ZGiHTuALhoflG7w3Vr+2/Mzw7q/9d9xkALTCg8yiq8kQc79fcsY/XaLS0vJXFZAIzDfiHz3ZDg1WjmrAZBWNNyvnc2jYKAp/6TZ7285Uo0hAq32hmYoJUxBmf5I+HhJ3VKNUq1fjZYX5riaOdRAZN1C46ZMXOlrUdS4LmHUGOuWVIhE1YYG3KeKj+tZAclqq7g9QZwtWjkyOVr1W6bVVisuduLso3p2qJZOpp/3DUd+QuAIkmUNDTyjomUxvGcWAs+qvdqv2SvqCh5bFRTklgPnD7TH41ImjyrLC2r79MIgofHSzoEhDk9WhxzyELx0dtsNWQ1of2BlnxK5QaDfkIYCHrcw3VDDZKnVuVR+q9U1ZIEhWhpdJbeRRg68PWT+iHX6TrbjcnHli1nD8B6kUY0m7Smy/kTsgtZHIfkGHdbGhcYs0QGxHHhdqktRQks4CpCJSn8m/d6/IAWM8ZjvG9Kb/1OZBMhaTG3EG6Ih0wvehpNyxnV3EuSUpJonjnNMzx7e1TSiKibupYWcBhPEKBHIOnKE5PrrI92fe
 lprFheXS
 r3dm/AZk0cBaP3yDfonDTOh++t9MfVIC9CaKsJRNUWvUwMkydMIxb6yqDe6qh0aEPnUQQWu0T0tORf8mI0kC6LArl04ypEuzMAUFtbpWnRxY4oMHaaklRWlOHdejMKBby44ujUzLlbdYjkWuyDnn49yHXpFeSJT2WR7fOCgPUajOtln5IDCQ2toQvEbq/HH8izLmBXY+urv15vxm2bPEe6hNJeJJ9zsQakMTFjIsVmo31oEEIlIINFqsjqgWDyUHslfQXtnXA6UwiILdKFGv1Fp+SRshydAnGSd09iOWgaAwUK04LGAJTh6LGpJYYdL0QRKn1+TpRKex0t+rNwgC1r61oGqVneUzTiLF/1d7/Fr6u5rFtmE9Mq4Ui0Jhuvkfm23QzyahIqIYpLJIRBch6hu6w8DopV8fO090nnvRj6TzPf/OfTNap5ASp+lOMDaJsVz565WamusF69UMi2FOP/H0bo7knO+U1nNZm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Aug 22, 2025 at 1:26 PM CEST, Miguel Ojeda wrote:
> On Fri, Aug 22, 2025 at 1:05=E2=80=AFPM Danilo Krummrich <dakr@kernel.org=
> wrote:
>>
>> We should probably check if we can get a clippy warning in place for thi=
s.
>
> There is https://rust-lang.github.io/rust-clippy/master/index.html#unwrap=
_used,
> which covers all cases.

Great! I think there's a lot of value in getting this enabled.

>> we could also write
>>
>>         assert!(tree
>>             .insert(100, the_answer, GFP_KERNEL)
>>             .is_err_and(|e| e.cause =3D=3D InsertErrorKind::Occupied));
>
> If we want to use the Clippy lint, i.e. go hard on avoiding all kinds
> of `unwrap()`s, then that is fine.
>
> But I wouldn't do it just for the sake of avoiding a few
> `unwrap_err()`s within `assert!`s

Why not? I mean, the above is cleaner and more idiomatic with or without th=
e
lint enabled. As mentioned, it's even the showcase that has been picked for=
 the
documentation of Result::is_err_and().

> I don't think there is going to
> be a problem of having a lot of people concluding it is OK to panic
> the kernel in general just because they see an `unwrap_err()` within
> an `assert!` -- the `assert!` itself could be also understood as
> panicking, after all, and we really don't want to ban `assert!`s on
> examples.

I didn't mean to say that people conclude it's OK to panic the kernel.

But especially people new to the kernel starting to write Rust drivers may =
not
even be aware of this fact. If they see some unwrap_err() calls in examples=
 they
might not even thing about it a lot before starting to use them, e.g. becau=
se
they're used to it from userspace projects anyways.

> Now, if we do get something else out of it, like enforcing no
> `unwrap()`s (still bypassable with `allow` etc. if needed) and thus
> removing a class of errors, then that sounds worthier to me.

I think we should do this; I really think otherwise we gonna see a lot of t=
hem
once we get more drivers. It's just too convinient. :)

