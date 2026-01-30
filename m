Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31D80E6BF10
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:41:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 376586B00AA; Fri, 30 Jan 2026 16:41:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3371D6B00AB; Fri, 30 Jan 2026 16:41:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 247176B00AC; Fri, 30 Jan 2026 16:41:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 125FB6B00AA
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:41:12 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B0C881607E2
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:41:11 +0000 (UTC)
X-FDA: 84389951142.12.4A4D546
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id D4E892000D
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:41:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B4KQbvu4;
	spf=pass (imf03.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769809269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a3NgH7Q4am6XLXzW9+2/EkywFX/qafdEAdbDivr+79Q=;
	b=3GZ3+kw9/cwcxwAsshs7RBvnlejOl6oo8VKcUk+gr144uV7ZdBy6kaa5AJdr4hL19Bby24
	5mKJRR7AUwlTcO4x6VVmLQf4QrytAqqqFce22m72Fo4nJVuXf2S1p6WCkjfRRmzKi5vV87
	fKrR8MQ/7nI7fELRReEE/JCHh5uU/eU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B4KQbvu4;
	spf=pass (imf03.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769809269; a=rsa-sha256;
	cv=none;
	b=FOpbgOQlvMMn1UgeXD+Bc6jiv1jrGyl31OTwvlRMa5DcH253Gk/GuVnqe6ocSolte9Z8aF
	uU3/3mdb0eHvCQMh+01q2Z8hKwNRQd4CAUApaN7Xoo53SxF12we9PzIJB0g6Ndx1JhOM6y
	euPTRWz/Tlh/mgcC8NfO81gxi3M3jnA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A8526013D;
	Fri, 30 Jan 2026 21:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4E4C4CEF7;
	Fri, 30 Jan 2026 21:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769809268;
	bh=nYAz8cOnAdH7OKPPWgG8rvbMO1Wr91nM6L7SjxMsYRU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B4KQbvu4vdFgHIUDXyt3iCPRcTH8tz4B9WSg8heLg4k7VW24Dj08kXxC9QPo8tE6C
	 l2dgfQLe3MbSGRPK4Ec8gBZYWPEW9tVa9t+TCB0K5LwNw5CCixbBWo1GJZuK23ciJ9
	 m8kRdL/Xbt7FBS+hJtw03laGB1CYuqEVvFqKL22OBjbi0bKahI+0fOTK2KU9LXx45v
	 wkwjWxpKkIfqQ+7gu7DxxzBKpfKC321WokPMKbrpJNMtJ3uHu/34jYJVNtVjoFmQjs
	 pqH+yG71ptSrxUEXqfPwD2hdy67s8LyjaNOyPCXwll9bI1YdUzaL/wloQLWxMg/z9k
	 8Js0VxNUyyL4A==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 5A4E9F40077;
	Fri, 30 Jan 2026 16:41:07 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 30 Jan 2026 16:41:07 -0500
X-ME-Sender: <xms:cyV9aSxbljfv-mFkc0MCRmSgwoGMguq8AXp2beielNeThjktiOQDqQ>
    <xme:cyV9aYpus3y--F2FwWzPkZ2cmRI-rNEIqjj6hLYweVjagjvjlOdUtWE7XmMAQH4Wk
    QEDb3ZebEq-FDAJhZcQUPW_U--p8S0E8tKpgFAlqcz23mojkeDcvA>
X-ME-Received: <xmr:cyV9aaestI1JpNgyFi311oTnhLkr2Gwf1XpIxW0VV0j76zBDC7HIay6DHHom_T029-VBhaAsuQbgbfQYdrmoj1qdSo28VoBg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddujedtudehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhunhcu
    hfgvnhhguceosghoqhhunheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpe
    ekgffhhfeuheelhfekteeuffejveetjeefffettedtteegfefftdduteduudfgleenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnod
    hmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdelkeegjeduqddujeej
    keehheehvddqsghoqhhunheppehkvghrnhgvlhdrohhrghesfhhigihmvgdrnhgrmhgvpd
    hnsggprhgtphhtthhopeduhedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprgdr
    hhhinhgusghorhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehgrghrhiesghgrrh
    ihghhuohdrnhgvthdprhgtphhtthhopegrlhhitggvrhihhhhlsehgohhoghhlvgdrtgho
    mhdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdrtghomh
    dprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghp
    thhtohepohhjvggurgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepsghoqhhunhdrfh
    gvnhhgsehgmhgrihhlrdgtohhmpdhrtghpthhtohepsghjohhrnhefpghghhesphhrohht
    ohhnmhgrihhlrdgtohhmpdhrtghpthhtoheplhhoshhsihhnsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:cyV9aTqxZsAtdPlqFrhoo4AIijYuLjnrdr3cxKzRpVIvlU8i5EoAcg>
    <xmx:cyV9acmWlnA8XPJf-uaa1V5EZpR5npPWHyJSzjR6-UA7FsnK38TlXQ>
    <xmx:cyV9acQ8jb5MZ8CaJmiQU4g0vsuv9bhd9-ShrSn8ikWR9jpIjO446g>
    <xmx:cyV9aaZnTmR4rOJnUOmyUflM3Mkq1bv9lqEKxsAYlMguxFrafOGj9A>
    <xmx:cyV9aU8VG_6owHVdEOD9kpanSvSxb0pwLlsczlW0b0UNQYd0gkrisVIF>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 30 Jan 2026 16:41:06 -0500 (EST)
Date: Fri, 30 Jan 2026 13:41:05 -0800
From: Boqun Feng <boqun@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Gary Guo <gary@garyguo.net>, Alice Ryhl <aliceryhl@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rust: page: add volatile memory copy methods
Message-ID: <aX0lcVngRcRwqgd5@tardis.local>
References: <877bszrz37.fsf@t14s.mail-host-address-is-not-set>
 <a8nHDdzac5l20akcxjjf9w7huObjn4eIHjUI-A17aKEwWl1N-4vvLBiVdqTQbBHwypMIA6gNkzm8YFXmMl44ew==@protonmail.internalid>
 <DG1ZJ1350EMS.1S1360PA496QG@garyguo.net>
 <874io3rwl3.fsf@t14s.mail-host-address-is-not-set>
 <iFJVkpTMbd-NR24OHYTJj8lr4dw7MwCQ9rJWiuRZFgK3JRDhIIAcpf5Z24viL5qHhkrPzpnKfvX7JS6X_VO2vg==@protonmail.internalid>
 <DG20LKAHMXMZ.262Y7NAC1A1Z9@garyguo.net>
 <871pj7ruok.fsf@t14s.mail-host-address-is-not-set>
 <-9VZ2SJWMomnT82Xqo2u9cSlvCYkjqUqNxfwWMTxKmah9afzYQsZfNeCs24bgYBJVw2kTN2K3YSLYGr6naR_YA==@protonmail.internalid>
 <DG21IW5HZV2F.PXTH9P2IO8O7@garyguo.net>
 <87sebnqdhg.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sebnqdhg.fsf@t14s.mail-host-address-is-not-set>
X-Rspam-User: 
X-Rspamd-Queue-Id: D4E892000D
X-Rspamd-Server: rspam07
X-Stat-Signature: c8s8cm3fox8dc8gj34xdjmxy8phrzp89
X-HE-Tag: 1769809269-665678
X-HE-Meta: U2FsdGVkX18NErTlCJyd5kOqJ1qiPkDZON9zIwTY5Ik+ne+kFMxcT40GCIWfE7KFjqiwMkSXuYCGdIK0AnLmHg0FckdnGDMHPe6azRx+YyKTclJBojK6YzL7FBy0cX/QpMLmnfcdl2BIvvCu/xZqk9zM4lyIYzuLxEXWIFUbbUstCLZBCd+xFnHUSx5xzR3swkAY2hNyEtbfzCSZ3TZ53SEIUlXF2BkzFNjfpbV5sDBCdbrxtS40aqm/Z0cKoaPK42DUVKr6nLEU2LN9l5Z4bUPpHn/kW0RgXfrc1+xmNoThuWMbDZCRkiAxAtXXEUxotyOSut8bf2HvR56vxISUe+WJaPUkT1KSf9xWQqYchO3gXkVSgLeZLeW6NM88w+JGNFDFrGhxK0lUYjfM03K7XA644iPw0ya9K6KewhLwDOzK2lk/PABGBx7YK9mTKCydoF7GQHy5S5LBIg8pg/iEx37LGNVwlfMvkSxJRQSU1H1/75rV7ylj9OuQ5NtAwSQy85jVMTN/nnXtlqL9riCe0IbJKbn2PETN22YWgw41pLh3dRtFsPT4ijSeenwD+uYishLI86HabH5rC4TvhPNVvxlRromte7jx1jhc1lGasIIxfONF7H7aUKKtkbIk+vcd3O15k5Nx5Ci9qlSf7BrEPP52Nmw4zQDT9DWpqqJaurQHcy69b8CyONmnyv2dlJZitfmVtTnYANx8YPumJxe8KChxopmlyA5SGBH5FgqW6uHBKgMndZ9x69vhmgdmK/2nguWs7GCknlNym0HQIHngbqM4aUIy0QNPlLuKbSkpbQpCKUteqOmqjvXMjERtTfNveQSvnPzvZpCujGcM7pkmX3BSbyBH1Na7PNbzGjk71aj6QFGiOFoGyNHJv0sfDLDR3kT9+WyaOMivQi4adsOd1/EBe9E37tO4EkFBDlvmy+bJM+buVCb+JvkNGbzCjdHEY/mMWPXyBBvgmpvn56O
 +pA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 05:20:11PM +0100, Andreas Hindborg wrote:
[...]
> >> In the last discussions we had on this, the conclusion was to use
> >> `volatile_copy_memory` whenever that is available, or write a volatile
> >> copy function in assembly.
> >>
> >> Using memcpy_{from,to}io is the latter solution. These functions are
> >> simply volatile memcpy implemented in assembly.
> >>
> >> There is nothing special about MMIO. These functions are name as they
> >> are because they are useful for MMIO.
> >
> > No. MMIO are really special. A few architectures require them to be accessed
> > completely differently compared to normal memory. We also have things like
> > INDIRECT_IOMEM. memory_{from,to}io are special as they use MMIO accessor such as
> > readb to perform access on the __iomem pointer. They should not be mixed with
> > normal memory. They must be treated as if they're from a completely separate
> > address space.
> >
> > Normal memory vs DMA vs MMIO are all distinct, and this is demonstrated by the
> > different types of barriers needed to order things correctly for each type of
> > memory region.
> >
> > Userspace-mapped memory (that is also mapped in the kernel space, not __user) is
> > the least special one out of these. They could practically share all atomic infra
> > available for the kernel, hence the suggestion of using byte-wise atomic memcpy.
> 
> I see. I did not consider this.
> 
> At any rate, I still don't understand why I need an atomic copy function, or why I
> need a byte-wise copy function. A volatile copy function should be fine, no?
> 

but memcpy_{from,to}io() are not just volatile copy functions, they have
additional side effects for MMIO ;-)

> And what is the exact problem in using memcpy_{from,to}io. Looking at
> it, I would end up writing something similar if I wrote a copy function
> myself.
> 
> If it is the wrong function to use, can you point at a fitting funciton?
> 

I *think* for your use cases, a `user_page.read_volatile()` should
suffice if the only potential concurrent writer is in the userspace
(outside the Rust AM). The reason/rule I'm using is: a volatile
operation may race with an access that compiler can know about (i.e.
from Rust and C code), but it will not race with an external access.

However, byte-wise atomic memcpy will be more defined without paying any
extra penalty.

Regards,
Boqun

> 
> Best regards,
> Andreas Hindborg
> 
> 

