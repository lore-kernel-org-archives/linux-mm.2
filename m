Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5179F46100
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 12:55:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 011EB6B0005; Mon, 23 Mar 2026 08:55:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2B2C6B008C; Mon, 23 Mar 2026 08:55:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E680D6B0092; Mon, 23 Mar 2026 08:55:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D354D6B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:55:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 654EB13C080
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:55:14 +0000 (UTC)
X-FDA: 84577323348.19.5D3953C
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5D569140007
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:55:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=lunn.ch header.s=20171124 header.b="jA 1fKF6";
	spf=pass (imf26.hostedemail.com: domain of andrew@lunn.ch designates 156.67.10.101 as permitted sender) smtp.mailfrom=andrew@lunn.ch;
	dmarc=pass (policy=none) header.from=lunn.ch
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774270512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1d81UGW+g5moJ12QZLJ70AfXTnILA70sV1AIVfxWkPk=;
	b=2QtJFrBsgRzrr+4Pwmk/qHinLD0MoLhZzpLWZ3PDJvnpA3sJGBM/43sZFZrAa5FX2czAdK
	EJ/ppjfWNO9ij3HGkKxLlHxab9wkBPJtGmsuX6A1FnaNBfmK22FGayL7s4dvGaf49LUdHR
	L567TneC8of6f+Sz4+BfDRpzLA+E2OY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=lunn.ch header.s=20171124 header.b="jA 1fKF6";
	spf=pass (imf26.hostedemail.com: domain of andrew@lunn.ch designates 156.67.10.101 as permitted sender) smtp.mailfrom=andrew@lunn.ch;
	dmarc=pass (policy=none) header.from=lunn.ch
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774270512; a=rsa-sha256;
	cv=none;
	b=WH7JGoYCu6NdH4F39m5T+ksv+5Ozc9uUX2O48Kf3tx9MtxEba/4mPpzvL5SCTQndqe84UR
	iTGUpwRynnhreTgqfqDw6excVHfKuKE9UxBw74BBA6Ii+lgdXSoOK14Q3M4Zx7qJq9BnFO
	s/wy+/7z6fEq6kVulJDKgyJhv1wWtqw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
	In-Reply-To:References; bh=1d81UGW+g5moJ12QZLJ70AfXTnILA70sV1AIVfxWkPk=; b=jA
	1fKF6JCm07M3XMCGUuLHhhI9Pu6ECn1GJ3yeUqHNhRkzLmXiEKTE/QlBMy2b+v7qeDJ/Lwc6gzpEd
	uTbq1XPNawby4AoIaQRDN6D1/Dwq4q51KKQd6nnrU4sc4PnuPzJ60QWKwdET9ZkSy1PsI6j8uUhzN
	bgmLoRVpwaHE16E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1w4eo2-00CvjR-O0; Mon, 23 Mar 2026 13:54:54 +0100
Date: Mon, 23 Mar 2026 13:54:54 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, a.hindborg@kernel.org,
	acourbot@nvidia.com, akpm@linux-foundation.org,
	aliceryhl@google.com, anton.ivanov@cambridgegreys.com,
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, dakr@kernel.org,
	david@davidgow.net, gary@garyguo.net, johannes@sipsolutions.net,
	justinstitt@google.com, linux-arm-kernel@lists.infradead.org,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-um@lists.infradead.org,
	linux@armlinux.org.uk, llvm@lists.linux.dev, lossin@kernel.org,
	mark.rutland@arm.com, mmaurer@google.com, morbo@google.com,
	nathan@kernel.org, nick.desaulniers+lkml@gmail.com,
	nicolas.schier@linux.dev, nsc@kernel.org, peterz@infradead.org,
	richard@nod.at, rust-for-linux@vger.kernel.org, tmgross@umich.edu,
	urezki@gmail.com, will@kernel.org
Subject: Re: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
Message-ID: <65336ad0-ac37-416f-b6ae-e691e3e375ae@lunn.ch>
References: <20260322192159.88138-1-ojeda@kernel.org>
 <20260323000327.111235-1-ojeda@kernel.org>
 <96287f3a-d245-47cf-b7cb-f821451493d3@lunn.ch>
 <CANiq72nwSWVDRqm0Vap5j5X5k+Q-wq8okQ9d3KUgZt6M4CpW9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72nwSWVDRqm0Vap5j5X5k+Q-wq8okQ9d3KUgZt6M4CpW9g@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5D569140007
X-Stat-Signature: 3w3ukq7x8g3kj4k83s43ierxsqrun8qh
X-Rspam-User: 
X-HE-Tag: 1774270512-582577
X-HE-Meta: U2FsdGVkX1+8Fo8uyt9wOJE04o817dqPSnrbmHL+2idQa+Xl3b65xVnCQEviHNS7kuIaQe5dovvJMyoOGxifN6XPp3jbyrhV1XzUNAJM4ImmoW98fXpR4Qxgena3QemQe30MV+0v236qm47bumygmzxol8RWA7X9HJ9oiGJKREfbZ03ZkSgTJjS1iYMQHfSv0JZ4gwnPClZG/QrcHxFEVYXKJGaAau/KvNnIeDHC2pljQZm0kS60XPwAMIYBA+ZbOFJ0ccK6T6a6p0dHNYLgk8WjYvC2US0uNfBcSq6+jtIn/pIbasbZ3M6QicslW7JWpZGr69AJ/DBe2HWHuPnDwVUGN+JkF9fGLFTGh1sSIpq7qLZX9x9Dwia6APLZpHx0uW5A+4oNyamCgMEcxmdEwfBliCYXMa6y0kRmfhHr14E90Zy2LX12pEjrPrQX9XAaPjsclp5LmEbZq1UbYxv1/sAas5ezexhtvDANqiqKJrpkAtC1iMT9oFAAKUxnP4Z6+nKa/e13O7D18d69doFar6azm72oJkvVBphlN2TqFhQkXFizmck28zzecAH24y5c3xkH/PG2CMR7u9R0I/TQhWYdTwWNL8NDMKjqClfU5KSzmFYDx4IrRhmi/M+aPQ+VwiF1WvEOnu4PAVHQlc04GvZ38uLKGvzPOogCZj5rnINuk7uTrAC77Jln+0uXRyhIE17JUfrK/12C9e41BpQnzrYEw4SscdUkHs7unQoTEZnENSFbJhmaL32rfdMqRnbcundW4AgybBeVWPGJVwP6QEOs7jd+aMRqUMm220r00LWtJjAZGIAhuhcKdNWu8NVPCx3bXZSm10wPYCPTXHABHgfpsUDOzRclZHIN2srWSsflgl8Ua6Ns5/K9co0e94g3WbkFIIG7VmR6hNjS7JvwJv/hEuo6kdv7fiFnnGJy0ldF6Vi0XNdIv5Nz1Z115lj98RjbNyBO0NzCKQRyfE3
 B8UEM4JG
 4Aoz4Oc/Ky/joqEz5IZ3MSWCG5MhKcs3r6Ygrq5CRaRDrAZeVZeHYXWm7IEEUmnBtl82VkavvuzQNQE6DLBTXwh9uxbx5gyMJTQYlcYHrtBDqsH6z5TGCVzrhQYWvADUArQTPe+vyVCCCccW5gEDEH/5Ep0Iy0iMSkRiad+8BDTIWu7PiTMqDKGaad1BaTe9MOR83/CGjJaVuOKRprV+ExRXVsVU7P0v0k/GFtrsYLg74r1dUb3/c1YIMrn5I+5/xHFFoMfys2eMLlMU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 04:24:59AM +0100, Miguel Ojeda wrote:
> On Mon, Mar 23, 2026 at 4:04 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > Rust is already fragmented, because it does not support all
> > architectures. Do we really want to make it even more fragmented by
> > having some bindings only work on a subset of the subset of
> > architectures?
> 
> That is not the case. The `depends on` is not about putting them on
> abstractions, but on this experimental build feature, which is gated
> on `EXPERT` to begin with, because it uses a fairly exotic approach
> involving LLVM bitcode, which carries potential pitfalls, like the
> mismatches on the target string like one of the commit messages
> mentions, and possibly others.

I'm not sure i follow this.

Maybe i should ask a different question.

You said:

> we
> may want to start simple with x86_64 and arm64 or similar first.

The current proposed code for netlink needs this feature, because it
needs access to inline C functions. Is the implication, following a
chain of dependencies, that netlink would only build on x86_64 and
arm64?

If you want netlink on um, arm32, riscv, loongarch you would need a
different implementation of the binding?

And a completely different question. Are there other work in progress
solutions to allow the use of inline C functions? For networking, in
particularly MAC and protocol code, anything which needs to access a
struct sk_buf, a solution to this problem will be required. Do you see
this "fairly exotic approach" as just a sort term bridge until some
other "boring approach" is ready?

	Andrew

