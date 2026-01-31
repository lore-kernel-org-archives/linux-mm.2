Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40573D49C9E
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 16:27:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B7096B0005; Sat, 31 Jan 2026 11:26:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6645E6B0088; Sat, 31 Jan 2026 11:26:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 546816B008A; Sat, 31 Jan 2026 11:26:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3FF686B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 11:26:59 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9F0FD8C36E
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 16:26:58 +0000 (UTC)
X-FDA: 84392788116.26.B9C0F96
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id A81F080005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 16:26:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E6MTfjls;
	spf=pass (imf02.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769876816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y1AD8F5WzC66H4+3qgvevIvVYsZzYt5ijP3mj5E+WQQ=;
	b=lGTpGGxmJwrnwWbOl7/e/4b5dYI8airbCfXCK2mI3+8z1X2yKfVUSCagktGu+I3cXR7uPD
	JK8+B8Z+ABw/LSXIGYQ3mnJ6SHHaGDkUozAgLjnypKBJpoLwmThKY8WgnSUj3HRHH2sTiy
	xssEN6eWWpCExNksZO95czgzxqnVA7I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E6MTfjls;
	spf=pass (imf02.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769876816; a=rsa-sha256;
	cv=none;
	b=Z3HwI6ZZNhLTRej+X1XVrBmeM26PjLhC64IkrjRXUnmCKAWSKCKQBEqwVgC5FXFDBKzbpg
	Gby1b4XBjto1sWPIPoaknIDeYWQvVy7q99ZRLdqDRPPqEBV185pbRzz+Ip9TyEDv1kalIO
	a+Iq6UyWkjKaeIGerOJD+O1/KSVSTEo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 00FA06020F;
	Sat, 31 Jan 2026 16:26:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BF7C4CEF1;
	Sat, 31 Jan 2026 16:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769876815;
	bh=YqTZirFJnMSRv58R4i6aOMSFmcSP9mWjJAQAv7y98rA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E6MTfjlsG6XOR0vpaWua0qzBC+XG3ymfughr877+W0DcUd5Rhab64h0auQ1uWZ63i
	 eaE4cZHLYe1TzdQXMZBnEMQbpW7M8YEl6JiphUmLwZ+M659YJNW2eYgdZCrLH+blkw
	 V3+aTrROw2yQ7csatoULmId4dg2jW2JgIVYAMVDodjY7t3znYvuDXPR55B0uRjJj5H
	 T/mhC+C6P+s6fdu1HtuXGU+7uBbV47VV6vF2jVblNT295Pe/HVirLdDabymyu1Fh1y
	 0Hq1+ImHiED82rf8+EF8le+eQc6u42kwDIg0sr+4it6Uoarva8S/A6XsFl3UIAwd6o
	 XoJ+2M+ZkI1cw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 06CBBF40069;
	Sat, 31 Jan 2026 11:26:54 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Sat, 31 Jan 2026 11:26:54 -0500
X-ME-Sender: <xms:TS1-aaTlBPXcUJ6iWMjKRhK9ecmta-OGcuKkp7zBhLCB-HsHfMxAUg>
    <xme:TS1-aaIzzCtdLFom8fpX5K1aFUqAxIz5wg5Zd-kCx3fIOI1Lv_c6aQBUkB5DCIzYO
    hKFX7OdcjjWI0sBITQHz10G50YP1Z8QgEp549p6k_bnPMnwYxt2yQ>
X-ME-Received: <xmr:TS1-ad8ndN6dw4RFw7Nb1GAKyzW6xE3M8QWaAUunoRgwX-90755ePUqfIV1Wq6yUZLqHo-FKTLzU-GRg2SgiPOg2La5oBr2u>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddujedvfeelucetufdoteggodetrf
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
X-ME-Proxy: <xmx:TS1-aRJ4QlJTKxa26PSLhWKwiMe7-FjfkLZzopzYAC8COrs1g2HG6w>
    <xmx:TS1-acFQ8J5VjWgaSRkSRKZcsxu3ObAmhyqfXwvcDG53JWmmzHeKPg>
    <xmx:TS1-aVw7dpgowosj3Yl3SR4YAozyt8X38k7C3zOqxdYyNihCr-a_LQ>
    <xmx:TS1-aV5eXwVwsaII55uAs0FY6cMaDI2-EojvmHScZdoSWE6D3XC_6A>
    <xmx:Ti1-aadxndG8Lw6eqpZYomnBfeGCGb5nt_27Iddqu8kDiRg8yXsjnW8m>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 31 Jan 2026 11:26:53 -0500 (EST)
Date: Sat, 31 Jan 2026 08:26:52 -0800
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
Message-ID: <aX4tTMrMx1G7hXHf@tardis.local>
References: <iFJVkpTMbd-NR24OHYTJj8lr4dw7MwCQ9rJWiuRZFgK3JRDhIIAcpf5Z24viL5qHhkrPzpnKfvX7JS6X_VO2vg==@protonmail.internalid>
 <DG20LKAHMXMZ.262Y7NAC1A1Z9@garyguo.net>
 <871pj7ruok.fsf@t14s.mail-host-address-is-not-set>
 <-9VZ2SJWMomnT82Xqo2u9cSlvCYkjqUqNxfwWMTxKmah9afzYQsZfNeCs24bgYBJVw2kTN2K3YSLYGr6naR_YA==@protonmail.internalid>
 <DG21IW5HZV2F.PXTH9P2IO8O7@garyguo.net>
 <87sebnqdhg.fsf@t14s.mail-host-address-is-not-set>
 <aX0lcVngRcRwqgd5@tardis.local>
 <SEV7bR_nyQNtvtgoO8X80HMkMTPLW_6roBSxJ-MpKHHNmkZQyVxSS9k1iFV7-bgAlHSLM566L8EqtRBnht65uA==@protonmail.internalid>
 <aX2tyn9nBUEKM-SN@tardis.local>
 <87ms1trjn9.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ms1trjn9.fsf@t14s.mail-host-address-is-not-set>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A81F080005
X-Stat-Signature: owsxp48zkn3167eyrisk7i5y5nn45fxc
X-Rspam-User: 
X-HE-Tag: 1769876816-279261
X-HE-Meta: U2FsdGVkX1/G2YHlimumPzC0G6r3UFlEkWjene8/8bdV0gf0a05qwg/8Mi7umnU1VVmL1SgWW5bntftpdBztf+OlC2on/39wqMaJsZUnaYs05nKkSi0xVEpmX4N7rSBNo3CDqCq8UWYiZZXfVYuz+iOZlZxpdmZ4qOL1cjxAd+2hfFOlH/ijpEjAs1zvNehAXosaydf56h0Mg00b36Uju1bGkSTO+qxCyhHce28HVUcFAaURQR25yVRLagRXoPHPQkFzSsDiHJLphLCoCb//6mpkmnKjqwVsIjqx3QobDCcQGleiiBhUMgSIKj81E/+32wFJHr/LQxl8ofCR+QlS3B2FhKsgU+ozhEtmRRA1rykFTFHb0hlB57EbPS7JfxcUX84KoSyN209p2/V1R4Z5Ynu7OB5JylvII/zrE3QYTOTsUVEpn5u8klkM8IBVbflXoXxObZipWEmiAh+RfDg0L5BUJkuSbu/Dhv1OoarCR4QGj1WNmnSyvqbLSDrrrU/lQfiJBVdYJryWhIrgZDqhDl35QyKlwWnw3E6/ZEuK74Tqxw/8UnQbfJnhaoOxD4pkbjRVW7NK/wNPGRJg38/on6yCqBsAPgoC9GEA4zjZvtVQ4gwJo8diS2FNDqSqgFJfnU88qIcaCyL4d10YU/UiHvfF3cBMBqznsebWXH1evNkOFCCC4/QI+p7OVN6lNeWmntxjvdsF23vPRZRrTHq5wooEWqHu8PY75NYaTjmgVkA8NAHcPDW1QQViZsK1lSOMiyUSpN0JOTQcYV7HNvd7LiPLevwJyyt8KtFOXIiI69rG2fXEQ5OK92oCIbpE5tmLk6ZGpUQfklbSyJNwHadHWHjGDVp2h+2wmSvclIvTMkuaMmxQ87aasRPFCumGXHmMuf7AadSWRWS3YeWRKY2V/bx0B0gqshdEgdcKnw2XXkKDOPb9S+NmFv5TVRCR4ftGk3RRErggtG8M5Kr882r
 ICpM3gYp
 XRo2MzrUr0cHj/aGun1t+ZrJzIB3EY+zvpqrmgDTBlmIJzLKH0kjzXswlj+qizJZcqghqMmiRA19DVjokkluxsD06aGUg6Z4/mR/cBpd6DycqFXWc1fpdZtddvutfDxXpNdATT6IoCMB0ytWF6TidDUg0KJgsKhncpujAocTvedbzHjN+lYeMZllGQP1QqN6jNwG0MP0SunhV3QNUpPCFmvHDGVSQQIDiZw0/53NBgxw8LEiMSqG7EQ5uMiUJb7+/hQBTT9CgTGTCykfxXM2sSu/q3zytHsI7ATuI0OWrpW4YsXp8fIoQRElolw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 31, 2026 at 02:34:02PM +0100, Andreas Hindborg wrote:
[..]
> >
> > For DMA memory, it can be almost treated as external normal memory,
> > however, different archictures/systems/platforms may have different
> > requirement regarding cache coherent between CPU and devices, specially
> > mapping or special instructions may be needed.
> 
> Cache flushing and barriers, got it.
> 

For completeness, I think for some architectures/platforms, cache
coherence between CPU and devices can be achieved by hardware, in that
case, DMA memory access can be just a normal memory access.

> >
> > For __user memory, because kernel is only given a userspace address, and
> > userspace can lie or unmap the address while kernel accessing it,
> > copy_{from,to}_user() is needed to handle page faults.
> 
> Just to clarify, for my use case, the page is already mapped to kernel
> space, and it is guaranteed to be mapped for the duration of the call
> where I do the copy. Also, it _may_ be a user page, but it might not
> always be the case.
> 

Ok, if it's not a page mapped to userspace, would there be any other
access from kernel while copying the page? If there is other kernel
thread or interrupt could write to source page, the write needs to be
atomic in some level (byte-wise for example), so does the read part of
the copy.

> >
> > Your use case (copying between userspace-mapped memory and kernel
> > memory) is, as Gary said, the least special here. So using
> > memcpy_{from,to}io() would be overkill and probably misleading.
> 
> Ok, I understand.
> 
> > I
> > suggest we use `{read,write}_volatile()` (unless I'm missing something
> > subtle of course), however `{read,write}_volatile()` only works on Sized
> > types,
> 
> We can copy as u8? Or would it be more efficient to copy as a larger size?
> 

Copying as a larger size is more efficient: less instructions for the
same amount of data to copy.

> You suggested atomic in the other email, did you abandon that idea?
> 

No, if we have byte-wise atomic copy, I'd still use that, but that is
not something already implemented in Rust. (my reply had a "if we want
to avoid implementing something by ourselves" at last)

> > so we may have to use `bindings::memcpy()` or
> > core::intrinsics::volatile_copy_memory() [1]
> 
> I was looking at this one, but it is unstable behind `core_intrinsics`.
> I was uncertain about pulling in additional unstable features. This is

That's also why I said "(or suggest Rust to stabilize something).

> why I was looking for something in the C kernel to use.
> 
> I think `bindings::memcpy` is not guaranteed to be implemented as inline
> assembly, so it may not have volatile semantics?
> 

Well, it's used in C as if it's volatile, for example, it's used in the
similar case in bio_copy_data_iter() (hopefully you can confirm that's
indeed a similar case). And I'm suggesting we use it forever, just use
it while waiting for volatile_copy_memory() or something.

Regards,
Boqun

> 
> Best regards,
> Andreas Hindborg
> 
> 
> 

