Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55B1DF46101
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 13:28:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8CBC6B0088; Mon, 23 Mar 2026 09:28:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B642D6B0089; Mon, 23 Mar 2026 09:28:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA1446B0092; Mon, 23 Mar 2026 09:28:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 98EDE6B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:28:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3BE478CDA0
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:28:39 +0000 (UTC)
X-FDA: 84577407558.19.77C7AE2
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by imf15.hostedemail.com (Postfix) with ESMTP id 76087A001D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:28:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=lunn.ch header.s=20171124 header.b=k7sIINJI;
	spf=pass (imf15.hostedemail.com: domain of andrew@lunn.ch designates 156.67.10.101 as permitted sender) smtp.mailfrom=andrew@lunn.ch;
	dmarc=pass (policy=none) header.from=lunn.ch
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774272517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ffZcBi0UU6q88Ce7nJSzo/9O0PBONBoKE6v9nT0tfQ=;
	b=bRXirx+JETFTxIwFMfDBtUKdx0N/hdumqfB/9uvZ4acq0RxLVIzEDjSWNea5p0NA2JaDvC
	y+uTReTtPGHCUFGsDksPf5HNjKskYereqh4s+lTpAUfKJuFn484x+c7+QTocjp+DqIJqmK
	ESY80AakcfIehYGzjgW2Ru4N0Dnl928=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=lunn.ch header.s=20171124 header.b=k7sIINJI;
	spf=pass (imf15.hostedemail.com: domain of andrew@lunn.ch designates 156.67.10.101 as permitted sender) smtp.mailfrom=andrew@lunn.ch;
	dmarc=pass (policy=none) header.from=lunn.ch
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774272517; a=rsa-sha256;
	cv=none;
	b=Kb2+M1KtvPjTA+ilO7Pz/fKOo/t+bCCcKTqQZgYhbPLZQovuo8l9cBrsbCcSLl2YdYA3lx
	ydHRVD9D21FMtcrWg276dxhmXIw06aEqn7bIvp3RAbcrXjySY3s+iTW88cx0W1bm/FAP+0
	gsZqtf+/QnH2zyqZqku5AT8mCN+MReI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=5ffZcBi0UU6q88Ce7nJSzo/9O0PBONBoKE6v9nT0tfQ=; b=k7sIINJIYCzIpzZ2gI5it43Ag6
	kvT42IIsbXwV7JvxdG5TtKzLycY7I/GlZ189VNwiAeNQ09bB8gR5Ah6+IcHW6BmNfxqetQ7Xlt9oH
	T7zzeRvxjh+oHL2kLEEPZALfZYETH8PDWPPP3/DOZmbV7KliYRBmFOeX+G2g6lZbgixY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1w4fKT-00Cw79-Bh; Mon, 23 Mar 2026 14:28:25 +0100
Date: Mon, 23 Mar 2026 14:28:25 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Gary Guo <gary@garyguo.net>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>, a.hindborg@kernel.org,
	acourbot@nvidia.com, akpm@linux-foundation.org,
	aliceryhl@google.com, anton.ivanov@cambridgegreys.com,
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, dakr@kernel.org,
	david@davidgow.net, johannes@sipsolutions.net,
	justinstitt@google.com, linux-arm-kernel@lists.infradead.org,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-um@lists.infradead.org,
	linux@armlinux.org.uk, llvm@lists.linux.dev, lossin@kernel.org,
	mark.rutland@arm.com, mmaurer@google.com, morbo@google.com,
	nathan@kernel.org, nick.desaulniers+lkml@gmail.com,
	nicolas.schier@linux.dev, nsc@kernel.org, peterz@infradead.org,
	richard@nod.at, rust-for-linux@vger.kernel.org, tmgross@umich.edu,
	urezki@gmail.com, will@kernel.org
Subject: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
Message-ID: <b5063e7e-9245-434e-9877-5ac7b45f4bc7@lunn.ch>
References: <20260322192159.88138-1-ojeda@kernel.org>
 <20260323000327.111235-1-ojeda@kernel.org>
 <96287f3a-d245-47cf-b7cb-f821451493d3@lunn.ch>
 <CANiq72nwSWVDRqm0Vap5j5X5k+Q-wq8okQ9d3KUgZt6M4CpW9g@mail.gmail.com>
 <65336ad0-ac37-416f-b6ae-e691e3e375ae@lunn.ch>
 <DHA6SE9EMEQF.1PKVHEG18I5FS@garyguo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DHA6SE9EMEQF.1PKVHEG18I5FS@garyguo.net>
X-Rspam-User: 
X-Rspamd-Queue-Id: 76087A001D
X-Rspamd-Server: rspam08
X-Stat-Signature: d5rmkweo7bxig8gtqhgfqomjgptbrotr
X-HE-Tag: 1774272517-834126
X-HE-Meta: U2FsdGVkX1/lG3pWxnn0jsHVGruYK0eVdktWKHmyh+DhgAuGhKKjIc+rDSikE2udMwusj/dmsrsl0MWoihhab7OzDzGHjqHM9fNL+eyPe+gIpJ7qNrZgu6deg8jilSStmuAWAyUdq1qCwLk5fP+Vtr0CAeDX1PTvB9pfCYfy15f8WpVwnSHlL72b6zVa3862IZN0EzBNBqCIqs/8deJR4492ONke6kTdzvQ9kQhlqHsKsQSbz3hUHpw6iFgkFG4BGRWWnoFroGRw2SjXLJMG6ibklnaFoqzuiG8+humDbEPnILN70GYMOAHDWtjTKI19u5vykgMk+7vgrsjjkGx0c8qIFF7PP8NIZnPMwgIQufVlDqmHlNIqMTqD0dEO3tgoWmV3UTodK1Ml0lb7fF/8JhK3pBaFgN4cMEYD/AaDBeIv3WGsNneMYVdzietwzP6qO+HmFzxxxKxZuNEoGx4cHjMbGQPyWTB+b3xU01b71XYBHKB6MYJwyBkBLgSExe85YnFKnZWfC3DZDF4ZELbToR87vdvpEzvv9BcWw4Sky5ZykSEUlw5vTrR0Cw8PGYlj3flqDPwgi0UKFwG7hcpOe2j7sh/xQcyQtG/NZlYpMXFmABg4jVUjY/gU8szI2Y2O8ICRVOT01PfiRSFjGCrVeZefVs4k222UZtDwPH/eecAlc1JcSoMawYyLf2crvqoMhP5BKdwvH/fMPaFLmvDeKH6NtnQMcgJEhZRPJng3+ChLWjbdxq3BHlhpifg/IY9cgGumdu88tUCSxp6QA0HLuScFT0FOvIYELjCCc9ZuL91czeIvrEWnxLAf41OCHSRXzlwLFEdpkCC2hUkMqkeNRQAdhYTcMTjZwaIL9X2I1xSb2TXDqkb8h+ro/ryDNtt0wv4oH84Fji4XnElaNEyUe8EDjr/OmTX6mkqxpqny1BbkuSlDPZvZOmDF0yNVXVdSlJ8Vio/rYN/ne/Vpt3P
 6g48q/XD
 EhpEWVaYmq85SihMAOKCkLkzwBAG0ovaU8ZHAPZC2jT1tN78IJyAL2EWwEufKAtwBlqmZjGuzqj3FMaARoGmyenpIJxqPAQugR0/Ts9JQyx/X5KX6bh0NfNElQn5oJIEALnaMdXMZuvd1tQ+Q/Hh49UxDWcSaAQ2tSQw9cjOxftDHVXjXXHsO60LUN1z9sz6mDel2tuyvdUyvZ+m3AwSBGoBXl4pY2PUNMFbCRe4nS7IERNt6O8POBBMq+J+BwciVYd03/g6rvRsOw+L285IeHNVypF44xtjY9qjrcxmn/TPQ88KJc0JIrRsr2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > If you want netlink on um, arm32, riscv, loongarch you would need a
> > different implementation of the binding?
> 
> It doesn't need this feature to build and function. It'll just be a bit slower
> because inlining from C to Rust won't happen.

So it sounds like my understanding is out of date. When the first
Ethernet PHY driver was being merged, Rust could not access inline C
functions. The binding had to replicate the functionality. But you are
saying that Rust can now make use of inline C code, but not actually
inline it? It results in a function call?

What this feature does it actually allows inline C functions to be
inline? So it is just an optimisation?

	Andrew

