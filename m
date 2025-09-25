Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 337A7CAC5BA
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 18:15:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71A868E000C; Thu, 25 Sep 2025 14:15:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F2498E0001; Thu, 25 Sep 2025 14:15:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 607798E000C; Thu, 25 Sep 2025 14:15:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 504348E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:15:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E17ACC048E
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:15:31 +0000 (UTC)
X-FDA: 83928575262.26.27242C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2F3E5180008
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:15:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SBzzN4io;
	spf=pass (imf06.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758824130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9hNaUdCI2ZMhoByqtrdHE5BEoOcf7BwV0LLCMm1jFXg=;
	b=Pm/adu00IlDTbWntpkQeCQ9zPCs5cvHaLHFwgkmmMra12sC/RXK8921a6Wze0LN3kcDGK8
	z/2260LJP0e7jCBosb24xUc9VWMrbdc/zLuMrBaLi8T5RtDj2RNNtBlJD4VhK1jZWtB6sa
	advysfmEzw/9JbDGSq0sMFDGmh3R5WM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758824130; a=rsa-sha256;
	cv=none;
	b=aKiN1w216vouSZHYIOheIUPgyLLbW508MSqDSHC3C/t7txTsV7AlrZ+EvkjDPx5tDx5vys
	RGaa4uOGc7GvpTfwdSYw8bJe/iSWQfxrLl+3R9qPbT5GOSEHvHwCqCKQxZc6OQeMprc8/g
	VYE02d2fHW/rStiuWVZ7+TOuvEZl1oo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SBzzN4io;
	spf=pass (imf06.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2180644741;
	Thu, 25 Sep 2025 18:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F585C4CEF0;
	Thu, 25 Sep 2025 18:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758824129;
	bh=OMdYq83OkDKRZw/s0mDBqBorGXDjzGEN2c30eHemUKI=;
	h=Date:Cc:To:From:Subject:References:In-Reply-To:From;
	b=SBzzN4iotExRcTbbma5iJDp7MBTjmmMi+tQHAjQzvsHtCym4Ru5wRiMbgImHdPZJF
	 B+OvIroSkk2F73eg/cLAq5o+oS2m+qMINsm9df/Z0ymKrabIohccfOXrRu11ghovgk
	 zskV/wwOWu2ygf9jLBU94isVGCa2IxTCOVxblHC2HlBE5JgM89BVCnTGucwqp+UXp3
	 FDa+ke32ls4d2bqwiKyudpvvWkpd+CeGDBT8ZUe4VljXQHlzlyqNcuLCw4Es2yFatx
	 R7xNiWJEW8Yxb9rTxi2e78G4Gb27LPIzMTvvUrJiXC6Xd5+3XoZqgBNKWV4cooRyXa
	 ts+VNbcqrMMPg==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 25 Sep 2025 20:15:23 +0200
Message-Id: <DD234804U7YK.3S2MBUJSFHF8J@kernel.org>
Cc: "Elijah Wright" <git@elijahs.space>, "Miguel Ojeda" <ojeda@kernel.org>,
 "Alex Gaynor" <alex.gaynor@gmail.com>, "Boqun Feng" <boqun.feng@gmail.com>,
 "Gary Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>,
 "Trevor Gross" <tmgross@umich.edu>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Vlastimil Babka" <vbabka@suse.cz>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, "Uladzislau Rezki" <urezki@gmail.com>,
 <linux-mm@kvack.org>
To: "Elijah" <me@elijahs.space>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH] rust: slab: add basic slab module
References: <20250924193643.4001-1-git@elijahs.space>
 <DD1SGLU4180C.361W5XLH76XNC@kernel.org>
 <73d7d53f-439b-44a9-98ca-0b1c8fbc1661@elijahs.space>
 <DD22FI7F2ZHT.32SL8PXFZZHV3@kernel.org>
 <6e9c820f-070b-409e-ac25-af96b8b962c6@elijahs.space>
In-Reply-To: <6e9c820f-070b-409e-ac25-af96b8b962c6@elijahs.space>
X-Stat-Signature: 6peostmxyguphk6fjmspegh45ka4a4qb
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F3E5180008
X-Rspamd-Server: rspam10
X-HE-Tag: 1758824129-280784
X-HE-Meta: U2FsdGVkX1/7/JVQNOXzxUIEtygqYh+D3jf+hoU/Q3L2xXBPtTkNGP1pS09NWMQSpsGUuqgHMMSX475edh2uNz2w4LNGF1BlYzdoJl4LWOoyxdc/i07m6br80CB3molInB5uScrUEFbHzaWA0x+uBjgFyA5J+lzSVhG+NNRqCx/NbNDPcCAVoZitczQQ3mBQScvHfX8ZMRoRtvlrozi1xp2qxOrkCNdQW+fur2KPbAHSXU3X9taKzC5WsXCPK61Dd1lwxQOuorugycID10cqBPPHnDZrGib3UQqOqIdwZHfLcSGGAI+QcUrcv62xnTuPfe06SyYrSYz0v76sbF7RUYJQkcaM1mMjylGC8+iMe2cjVop1ALumZioXgiaSF++GEywfJIWZBOFYlazDnXRb0ZQXFNlGAx6XdNkyHDxnbKDaaVw953zTHAUJTJxDvZwBkt9SMRhTufaTAaSdbK1E0fgVavqQ37gwoHw7mcroKYNAKFvPwyIZVHFEUp4Ot2yfD8JU5TAj2TlhphuiV9/0Yygj4lMuaUJaVqVaeonyD18DHlS4nUKdtZApLX6cDaACckaX36IgtvfEy0qHIseg8YgfRQDddEKi3gK96NURQf97ss35maoy4oEa9DNdmx9gA6Xy5bn7vD21ET7yseJx+pSrSj/kklIFVGITwSdQjRxi+P4UgKiz9ezUq/VG3wH+OEi0mwiMwNwxuok7QG9TcD2eBZekkyUmpSL3ICdtp4DTj59v/H4GExuqAon7IAMgOGd7meEDk+WLu68Xyn2xp0AjL8A9okR2vvZqchEoh+yjk/kWtWvgtj2T5pgT+6S3M3EsD7Elbh088RCH8d94L//ROAeacrDiqiLTfy5UPMdO91QUzXefl/EnRtidcZQ5btzhqJUpFGHv4P023nx9b1KCBqTitne1UVHWZo7X2ZOuCbyc8h6IlkCffv4ZKhgKB0wNoFD72J+LdLPAz7/
 ynj6B2fR
 HvOJ57hmcFAf6VQ1NcyDy9xuz0X6jlAQEpdN/Y+/J0YHegcbZDFnexliDM7igHYGqF0j/8wBIt+YBZmStyGfOljl2lO4qhnwgQ5t0GPX5vSo7XBm8Mxa3AGLocjifxWjfdTwIzc387OpLkZPwHkRj5xIO/f5vyxqaF12E3yvNWh0kgybAcwDEbA4/3fvuVAvOngVE1N+wWhjHBNeh4hOxZ0v+wWmzo9Vara3Zph4jVOssI6b3fIqzn7D0T8HmCp4BR7bWLtwOFnXdMvYyl1rZ2MsBoVFF2sWaVkemQPTtH3FQArWA4cL+cygA2Cx7w4wTpiqhxSpHDcRMnev1zcNaqEiwP4wjPE/nsvzp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 25, 2025 at 8:05 PM CEST, Elijah wrote:
> On 9/25/2025 10:43 AM, Danilo Krummrich wrote:
>
>  > Anyways, I'd also like to hear some more opinions, especially=20
> regarding (4), as
>  > mentioned.
>
> ok I just looked it over. I think (4) isn't really viable, the cache=20
> pointer storage overhead is probably too much (in addition to some=20
> complex issues).

Probably, given that kmemcache is meant to be used when we have a lot of (s=
mall)
allocations.

However, I'd like to hear from the MM folks, if there may be options in the
existing infrastructure, or if it's really a dead end.

What are the other complex issues you are referring to?

> I don't really like having a macro (so (3) basically)=20
> and I think there are issues with non-static caches, I don't know=20
> specifically though. obviously (1) doesn't work. (2) is exactly what I=20
> was thinking specifically for rbtree. IMO the only useful options are=20
> (2) and (3). I would say maybe implement (2) first and if you want=20
> macro-generated ZST allocators they can wrap whatever that Box ends up=20
> being.

I'm not sold on duplicating the Box code just yet. What issues are you refe=
rring
to?

