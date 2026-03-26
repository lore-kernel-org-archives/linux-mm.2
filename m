Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 054C910A88C4
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 15:18:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D8576B00A1; Thu, 26 Mar 2026 11:18:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 688CA6B00A2; Thu, 26 Mar 2026 11:18:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 578046B00A3; Thu, 26 Mar 2026 11:18:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 43CF06B00A1
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 11:18:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D5BDB160E6B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:18:38 +0000 (UTC)
X-FDA: 84588571116.19.B782C87
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	by imf19.hostedemail.com (Postfix) with ESMTP id 659EF1A001C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:18:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=D26skTX5;
	spf=none (imf19.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774538317; a=rsa-sha256;
	cv=none;
	b=Nf+U8N+d8o7LquV9DghJDd9kEBQ+OR0lzNG9q4y1zwZCnMbO/eU34UTtybS4vfcuYmiNtE
	w7IvQJ5SpPgoqh4b3IYehmCYYFrBTeLeg/R9XTFnAy2xO6yfpzZoMky0YdBAZpQpZe361z
	JdjtW7gOOgIKo45HFQc7PRSp/KsAkqs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774538317;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1vOiFYL2/2gauah1MO2J0SrthHCAYelycFB7wMm2FBc=;
	b=GgmWzQhZN/6yeSWQ9X+G/jVP/0hiif7z2vV9YAD2xRh9q1+UzJg/2WvNYyvsxUoP710OnI
	Nicz/mWL9CUYQYXXL0K5SWHqWpJs+xYFV6K5vMwuOPS8CfRFhPy+uOc5BbrlEjMOYiTGp4
	F+lxocdUZ+26GGcAxoqWQjAfbGD4rgQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=D26skTX5;
	spf=none (imf19.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=1vOiFYL2/2gauah1MO2J0SrthHCAYelycFB7wMm2FBc=; b=D26skTX5ljpAkNaHIlMIJtyMXA
	iuIGQ5XwwypR4BJdeLJLVDrC+G8tMEFZ5P4tqFmMjvoI6AOG6PIGOYJ85eGHPeAxV6gRfx+n68+yA
	Z6Dx/Y4Gh1bEmBoiL199z+7bIHDUJX8pt+YRZ3g5KB5wjXksBBQ7eBwENc+99IFKclwJ/lK53Pjir
	PcYACczVKeLDRVOEKCWwE4d6xmObv4geC0gR07wywRb3JWhj2yDBMxHaFvNVJJPEA+2cOalvqqiaA
	4k8w4+HXDBOVmRXqj/u7croVsR0r2ZAHcvW2tmFLlVzNz55dyKB4kAZ54aQDsDWoJgqZAgnfjOQ71
	P2yYBqiA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58812)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1w5mTM-000000004wB-0dxj;
	Thu, 26 Mar 2026 15:18:12 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.98.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1w5mTH-0000000077v-1ifh;
	Thu, 26 Mar 2026 15:18:07 +0000
Date: Thu, 26 Mar 2026 15:18:07 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Christian Schrefl <chrisi.schrefl@gmail.com>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Alice Ryhl <aliceryhl@google.com>, Ard Biesheuvel <ardb@kernel.org>,
	Jamie Cunliffe <Jamie.Cunliffe@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Miguel Ojeda <ojeda@kernel.org>, a.hindborg@kernel.org,
	acourbot@nvidia.com, akpm@linux-foundation.org,
	anton.ivanov@cambridgegreys.com, bjorn3_gh@protonmail.com,
	boqun.feng@gmail.com, dakr@kernel.org, david@davidgow.net,
	gary@garyguo.net, johannes@sipsolutions.net, justinstitt@google.com,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-um@lists.infradead.org, llvm@lists.linux.dev,
	lossin@kernel.org, mark.rutland@arm.com, mmaurer@google.com,
	morbo@google.com, nathan@kernel.org,
	nick.desaulniers+lkml@gmail.com, nicolas.schier@linux.dev,
	nsc@kernel.org, peterz@infradead.org, richard@nod.at,
	rust-for-linux@vger.kernel.org, tmgross@umich.edu, urezki@gmail.com
Subject: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
Message-ID: <acVOL5Psz6kHlhq2@shell.armlinux.org.uk>
References: <20260322192159.88138-1-ojeda@kernel.org>
 <20260323000327.111235-1-ojeda@kernel.org>
 <acEP7tl8pqFA3tK8@shell.armlinux.org.uk>
 <acUGAsjYvNvTEO92@google.com>
 <CANiq72mzPpkELXis1CiSbKUmBXNQYMiMmjj-7-sYiLh4T_JSOQ@mail.gmail.com>
 <9cf5a94c-0f37-446c-b63d-ddac5674d220@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9cf5a94c-0f37-446c-b63d-ddac5674d220@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 659EF1A001C
X-Stat-Signature: dx4mk9p6undoch8sjg99ozi7dc4xks55
X-HE-Tag: 1774538316-466942
X-HE-Meta: U2FsdGVkX1/Qx4u+ONbichOS+Su3gMToDUmyGRhSn+/kYknkWoe2jb+JHk3My+pPzHDl6tdyOUCiCqNE/qU3t0qPGoa7ECPNKJyOhCT1vnz2557P9TOiTbsObnLcCRJ7v9BvDMCyR/vBIcDpuZ6ScpF5zNlyaPrgBfXWR9CPiB52rOKmCNOHicQyn9CC+uG3X3eDnq1iuprwuRQbXVKIyPLox5f85gEPmaafaursddBXTwOGxoeq5T5icSYx1RVgHJrHOy80WoIGerC0Vgs62z7XApftKB/QIFLnj8Cx8DjM2r1Oov/i9rNF3T3i1+SqAn+7YdNnylueX6ME8LFJR+qMlTflzyJ+dS0sQHzwTO6SdHflz8kEV+JHEJMAQgxUjSq8GA6u5XZrwuaZ+F7IHiBEwRhk65QfPp4JVAGkFO4embObI3v32yb7iYPZm0dX7wkjzqRlVJHN9O6NFecv1FT8VW012XKOuFYMJaZRWsImLP82od029qySmdP1/5GdkmVQA9CJwsxLQELgiV5RW8StY/gtF5vwtNkMrlIHj2yfnNKk1DQJbXMH+Ba/wLlzYzvd1MOM/44CsmXIs7vuHZCeD59aOyWaLzMSc3qxcXP4cOxgzROK1dJRd9XclkodqYxmFmj9vfRVD9m9fqK9IUTV7bSoRhIR6/SvF6jiphxhXiabC6Qu6EmDd0mGbVHkxLpOZbTdRJfFNrs0uei4xUlj2VM9YjiYVjloDDapmRqmjaOyI/FI69yfu4Gt8L4D3Ot4qajYHL8KuNDV8IlB3FTkNxE04haFqX6v+nGIx32K6w9pWGAr6z1PO78HR+dPG5HtJ78DkM1mQJw0N4bMqNPL0Ox2rvrucgfqWnIvBwSNEyBbZr+3YMrgWS2f+5ry5AvydhZmb0aDQZwfFmq9UvC6wbOXZowX5Up6RDfBhq1UlLBOmoFj9eo4TpLTkSQInuoqig8QeDGYV0ODyUJ
 l0yA3LPu
 EqHS/bstRsJSFLd+RJVbx8bDhFkiqWHMIBj8PHc3D4gAzlR8ao390unNwVHIePgQ857uRYknlnsMa3CqwvDM1Kw5miAO9Igocn37hnplIC4mvEuAiuHzpVu0rFaz3UlRR0sNS94oFPP1tfEqs/BNNIsLshG+vkQhean20c4IJFuiy4lqGW7xk2iAge72l/ns2xulN3jWRDtimesk/UZUUcgdY9jNU/JI3KY0XVATwY07KHXXQKhX8cXZW6F+w6o1xA4RAb2JXkeHuoASeakkNwM8msf4SG/lY7bzyH9kCmobptO1iuH7mp5LWV8FpiOWcO/QlS0JZqVJlTGXjNXe3zh4905Wi+DBemsgZ+ptWJka8p3H83BS4bXt3DsfOYK1prcHl3vhggVtTAfxhNQZT9h5XaVbO9O2GDavViTOyU8X9tVzh/0+Bl+fPCD5+Egh/0VUircj+bs+rQ7yIoRJNwkOX5AfrJyeiNK/6giGOEirhM0Fni03muJOnTAlW36Zy0EUBTHUsl2EDSGb6XH9WeFe6M/IyjMOnm+HTa5t47WP8DCi2S8eb0tRlhLFNa/BvXO4TVu84dh3sCfosA4mKsWZH4shGHIwHPez5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 03:31:26PM +0100, Christian Schrefl wrote:
> Hi Miguel,
> 
> On 3/26/26 2:47 PM, Miguel Ojeda wrote:
> > On Thu, Mar 26, 2026 at 11:10 AM Alice Ryhl <aliceryhl@google.com> wrote:
> >>
> >> I noticed that the Makefile currently uses the arm-unknown-linux-gnueabi
> >> target. It should probably not be -linux target to avoid this? Probably
> >> it should just be armv7a-none-eabi, right? We gate HAVE_RUST on
> >> CPU_32v7, so we should not need to consider the other variants.
> > 
> > I think Christian tried several targets back then and eventually
> > picked that one.
> > 
> > Christian: what was the reason to pick the `-linux-` one? e.g. was
> > there something you wanted to rely on that target spec that you
> > couldn't enable or disable via `rustc` flags or similar?
> 
> It should probably be fine to use armv7a-none-eabi. I've mostly used
> arm-unknown-linux-gnueabi

I'm not sure if this is still true, but I believe it used to be the case
that the -linux-gnueabi target has one behaviour for enums (fixed size)
whereas -none-eabi, the size of the type depends on the range of values
included in the enum.

Certianly, when Arm Ltd were proposing EABI, EABI had the latter
behaviour, and I think there were cases where Linux used "enum" in
its UAPI.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

