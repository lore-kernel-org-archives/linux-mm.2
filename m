Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94AB3D44149
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 08:44:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA2936B0005; Fri, 12 Dec 2025 03:44:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7A4C6B0006; Fri, 12 Dec 2025 03:44:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98FFA6B0007; Fri, 12 Dec 2025 03:44:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 84F926B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 03:44:40 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1E1961A0317
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 08:44:40 +0000 (UTC)
X-FDA: 84210183120.09.8705F62
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2D9231A000D
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 08:44:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=nXdso5e8;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf19.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765529078; a=rsa-sha256;
	cv=none;
	b=ki2iR4X7xbMuK8vkITpAH70zKHJBuWU4zVKQyxpRWudQWfJjdHRvfp9qhtHbkwNnu4Dd8m
	AKFBOuOwR++gxwZD/OkKoeFMVh0aOTlKijBiuv4vCJykipJjvdy73t0J7UXC+EprezC0IL
	HFFXmagl3diPEEvQWyw8DsijXR2LZKw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=nXdso5e8;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf19.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765529078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vAYLjTJDqvg81ZKTZa2xcGlTQMi7ddtiNuDniSW7pgA=;
	b=uNZKG7cO0fI9fXS6bBV65Oz6vDXLbBUbBTcDynYjk8eNLMGgLpEBA/z3KiPG+/DmNzf7xI
	sgg6u2SWDZOXp5m7W80mVSz7TFxuyb1pq5pZxmoEdm3WN+atPtzPkJeA+U9WNZt9mUMKQb
	+/uuT/B6jAkVPHaEy46tGFEa4zuhKDI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1765529075;
	bh=YlZVG6EILJaffJguwlBqnLil+hF3zrisdr9uOMs57Ig=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nXdso5e8mTqNIXLu2cVx7wFXHiG+nieYuTSpMvTYVrQOCAy04g0RVrCJDC1jKcsf/
	 z0TpLcINPiOgkvn89GyoInLC/fMKhhExVgksYk9kl348oFtQvU+3Xp5dCeKMTBE+7/
	 J5t5NTqbN4TXjDrTSNl+M23Dd+nCvphe98UBxOo+xkMy6PpX4LrqTzTH5J7zEaM7sa
	 AYDBhI+EyFH1Jftx99sWy/T5E9i1SbycuXsGD5gXCV3lGnlTA8K4lIz02YXmMgQ3qg
	 uep/GimQQe3QQkRfMcc4QE6WqcrwRGVDTqnoCbcjYdnH5bIJoK94Dy6/mgLKAO9Cgo
	 7K5ANLzcoUT+w==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 6FF6317E1135;
	Fri, 12 Dec 2025 09:44:34 +0100 (CET)
Date: Fri, 12 Dec 2025 09:44:27 +0100
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>, Will
 Deacon <will@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin
 <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross
 <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Joerg Roedel
 <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Asahi Lina <lina+kernel@asahilina.net>, linux-kernel@vger.kernel.org,
 rust-for-linux@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH v3] io: add io_pgtable abstraction
Message-ID: <20251212094427.2ec0b31e@fedora>
In-Reply-To: <20251128180255.GA836877@nvidia.com>
References: <20251112-io-pgtable-v3-1-b00c2e6b951a@google.com>
	<20251128180255.GA836877@nvidia.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2D9231A000D
X-Stat-Signature: qeiougufqb5b69mi643jzf4ohqpkutaa
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765529077-730238
X-HE-Meta: U2FsdGVkX1+z8Z4BxzaC15cLiM3QIFqAZlpGV7q041PTTwk+FZZ6J9rGOLo1ziMHIv+r4oOCdNF5GcU3cRl29uCKBDCYIgAPB6ImYFgcFFWeDTjVjSkCrd4E9h5KT8MuiIevZ5ocfxPLmOKmm47AfWvX0AM5BhDo434KWlgzT4w0y61mzOOti0mBbMHnyQ61yoYlD4aaSsysbUlwrFgBWRx6KugDpbXsGwSqwq1CyGenq36/B9ZDdb9KAhiUMbXftrrFOBUJpYp2ZUthkRnlRwyexqMhNWbPbPWI4npk12QuFK4ukTxosagD5RI1K3FGe1nGpNj4h44ZB1ajPRdtxmrBOUL+FzwhRxPic08ZOEq1cobVSNztRhkHQRDXPxyUKIlaJidtAjE6gct40xHOw6zE5vvSYo/gkN4k7PenxEpUh1v1JZsxGNdHnF44MdEc7m4kq11wbldvq3r9oxji7+bq0BiqZhH3GKlHxTmIe+zxrZ4r1vpbEIakXygIHeCPWFyvYgh7mEhnyCdfm9ieMIAVDs2pqbI6WitkrZooA3N7sgHExY033SkOcnoCAV3HyfCoZF7XyD9ndSeZJETmX4FPAg8T6LG3rcZGHC/XONFvwym67aOXmYNM48fIQzLMoD/TZESnegnOsrUXfGIu3WaUGZkGZA4M2GxqmyRHSbPY1RwmdLPRrqP6D+Op4Ew2GbzjBJmmyKoNfcz8LHPT5DrrxRRuLAwRIXFt78IrTH+bM4D+DPjRIVFTA0gSO4LyN6GGlcU+vltSrqtZ3on6/7npwNmsR+oqZweN45udJiiA2LCr3jyzvoISXMkqrK6a7Kd8mEFfB/Im8Mdn6L40E6T686FZSCs4gMEjBUqibfZB3fNdcsMQ1p5fZ8Gubnlf9+38Y4udJ/7rnhpqrnhPaI8ZrnBpeOpDX25y7g+WaKbUN+q5ju8dflpYVPstiI8lFkg4zoIu2NkHegq3I9Z
 UJDzhoIW
 /ynDjdqMC7+Uqoq34KKgSD0mlqmJr3/AGX4kwsY7E6b7T5N5tMqO3zdH42K2rpxlizlAFId7v+8xXk2b9opG7ZvYx/XYcx3eMDVLyeCceUCnxcmm3SZVslETD5YsYs6dmfvp3TxZsY3AzR+9AIMzxsD9h3CynjCgz0qATD/v6GEQpbWlhTRlxLOIbwSoaUQX41GN5JGntSjjZntknSCdhRaDsZAL7Lonxu+Ev3YXgdvuaJfO6jSwRW4XBQrNuWg6GK8cUtvkbEPLChGcQZ/R8F5bqrGNE0tde7Ld+mIofLYw7bEyM6krds4g349rVpE7cn0aztDCa8yAqzHDhZvjCNqVaK/Q9eR/IXp66ftljUg/uydweS3HtFkZTnon6Pz6TPFmQPb6Sa8mv9yuoq4UICU3uvhKRfY0GZMTZ/L1N8WgU6n/CMMSVt/CRLo9LjDrDUF0Ji+KvcUGtADU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jason,

On Fri, 28 Nov 2025 14:02:55 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Nov 12, 2025 at 10:15:00AM +0000, Alice Ryhl wrote:
> > +    /// Map a physically contiguous range of pages of the same size.
> > +    ///
> > +    /// # Safety
> > +    ///
> > +    /// * This page table must not contain any mapping that overlaps with the mapping created by
> > +    ///   this call.
> > +    /// * If this page table is live, then the caller must ensure that it's okay to access the
> > +    ///   physical address being mapped for the duration in which it is mapped.  
> 
> All the iommu page table code runs with a caller provided locking
> regime.
> 
> The caller must effectively hold a range lock over the IOVA it is
> mapping/unmapping/iova_to_phys'ing and it is illegal to race those
> three functions with overlapping IOVA.
> 
> For example the caller cannot map to IOVA A-B while unmapping C-B or
> iova_to_physing(A).
> 
> This locking detail should be a safety statement.

Sure, adding this to the list sounds good.

> 
> > +// These bindings are currently designed for use by GPU drivers, which use this page table together
> > +// with GPUVM. When using GPUVM, a single mapping operation may be translated into many operations  
> 
> Now that we have the generic pt stuff I wonder if GPUVM should be
> providing its own version of the page table implementation that
> matches its semantics better.

Not too sure what you mean here. Are you saying that we should fork
io-pgtable-arm.c (or rather a subset of it), and have it all
implemented in panthor? I actually asked Rob if that was a good way to
go when rolling out the initial panthor version, and he advised me
against it. Now, I see good reasons to do that, like the fact we
would be able to add features like batched repeat mapping updates
(mapping the same page over a wide virtual range without having to
duplicate the intermediate page table levels that are exactly the
same), or the ability to extend the mapping arguments with
shareability/coherency info (that we can do by adding IOMMU_xx flags
too). But there's also downsides to it, like the fact we wouldn't
benefit from bugfixes materializing in io-pgtable-arm.c, if any.

It's a discussion I'm fine having, but it looks like even the IOMMU
maintainers are not on the same page here ;-p.

> 
> > +// on the page table, and in that case you generally want to flush the TLB only once per GPUVM
> > +// operation. Thus, do not use these callbacks as they would flush more often than needed.  
> 
> This doesn't sound quite right to me, the flushing requirements are a
> consequence of what flushing HW is available in the xTLB that is
> caching this. The flushes generated by the common arm code match the
> ARM64 architecture semantics. If the GPU has different semantics then
> it can do something else, but one must be careful not to match a GPU
> that is expecting ARM semantics with "do not use these callbacks".
> 
> IOW it doesn't seem right that common code would be making decisions
> like this, the nature and requirements of the flushing are entirely up
> to the driver binding to HW.

We're not saying this will work for everyone, but rather, this is a
default implementation that does nothing, and if you need to do
something, override it with your own. I guess if that's really
problematic, we can force the user to provide one and keep the NOP
implementation on Tyr's side.

Regards,

Boris

