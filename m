Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E779CCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 08:05:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBB7E8E0036; Mon,  3 Nov 2025 03:05:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6C128E002A; Mon,  3 Nov 2025 03:05:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5A918E0036; Mon,  3 Nov 2025 03:05:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C012C8E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 03:05:29 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 688291A0A67
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:05:29 +0000 (UTC)
X-FDA: 84068561178.24.7D8BC37
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id AE8F8100009
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:05:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YNIMhHK+;
	spf=pass (imf05.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762157127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MENFHqQdCM/upWrhnvldLJ5d/Mmo7/c3cfyIErXyUzc=;
	b=kjmmp7CK86jU42QvMhCADuIz+eL8OAW3mXZfxXPXt2KOfZCuIL3XpZFs+TRW9UAWEXyGy8
	VTYFdY1EB8LelKp0g5FJLfEH1Edk2TifdhaRGujFPFIcsWLJdj2kwTKu4phrtqpWhf7yMi
	eIFXdAJ1nQU69JFrduMbvn4kOMpIjXE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YNIMhHK+;
	spf=pass (imf05.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762157127; a=rsa-sha256;
	cv=none;
	b=3C2MY07zOSkRaOJKx2t5orifiulFeyRfjniL263FweJZc3UAHwF7eVjJ+1HyZ+vrAQZjsn
	fNRidpXgLvdmTMlQd90UCFpGohC24beMnh0lRKotTRF4Ebwdm1+njitOKgot852BJSyYlm
	a3Y/2rDVH8Tdh8ZhoJiXhaQ4dAU94P8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C7BA43DBB;
	Mon,  3 Nov 2025 08:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBE8C4CEE7;
	Mon,  3 Nov 2025 08:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762157126;
	bh=/Z00hsFx0kFKgS/fH2fkWOXPCRXDBSY3j5PVFskPLtY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YNIMhHK+TIAw9S8epUQRLJ0hHWrXGrX021AASru7kQYHYuMFC6zo5jxbc7KUmJ0L3
	 YNEe1nE+4ae3JtQxcTTez3gXWgSy2u2msyRHFv6Ufnrx2bt2n0+8KYqma3OyMomdHy
	 Und0omT0toRmHQSOMJHh8FIiBDSXmNrLx8mv1uScrl9HdFKsXLarM713jjbRgR+/v4
	 7/jTF678ISrptDm6AzMN9ALIVAtiWOrlbYsGz2TuzZPwPoiteJ/wA8NnfdkaDlmCac
	 R8sanushWpLqk/uQd051eoYlDOALHHRNHhGhWZBT9cBCKpSLGzr/fRIrMBO19/jAvs
	 SiEU4tXpMsS3Q==
Date: Mon, 3 Nov 2025 10:05:18 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v6 05/11] PCI/P2PDMA: Document DMABUF model
Message-ID: <20251103080518.GB50752@unreal>
References: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
 <20251102-dmabuf-vfio-v6-5-d773cff0db9f@nvidia.com>
 <86383031-807e-43d9-976e-dd955d79dc52@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86383031-807e-43d9-976e-dd955d79dc52@infradead.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AE8F8100009
X-Stat-Signature: wowdwh341zqdj1fypjxkuf56k5i7ndqp
X-Rspam-User: 
X-HE-Tag: 1762157127-107570
X-HE-Meta: U2FsdGVkX18O4UCjd59Lg5FL3ZCzEGaJNW7RZWALfTSjvBY0SZu7XOK+oYegDJQ7gQKG15n9obbD8VyEnnm3xr0xv/kkA9QP6CF7tg/zVWyFdd5tDvwZ4gVNJq4dYctbl4sdYbBoDmCEqCoUaZXAaonmOpOvfmDq8J9bLpKGhTNgiD1DEBYv0pEzcngajXsaoOg4jp7XUmPm4luZHb/x31y0+sPUTmVCu5AMfevFz+cGMQOCHRRlBAh+GXYL6Ef/G6fyGvfkiTQx51888Dsrtl/ELLq9nsy9bWt1fIdTxJvWtJ4NF6ZVOnjYOurVB0mBbGU9y1hpATrmVrcxGpIqQACTBpoNaemjJCO0Zz+8Lu9mkcQej2R01FldZGJbWDVxpJDv0YHFlpB3kGngs07745r7PzvGh6ur15uNFlG9ovBJPm1vIk2JjhrQYppELRy+xvSMIpaZhSQvNkyW0Ond2Xv529PLgGjMnaE85XS8Ko/FgpVyY0FydbgerGsJDRgLTkPI9TYpFyYi8vtQS0xth+qQ4yzsw+4T0roPCmC5YiNC7UTwePHliwkzHObQ882u6gKTMB761ZoylU8kAopYvq7sbz8QiQi1OtwG2aGbCH6TkupUZr6zYat/2H5/hfffymYpecKWRpyBrurd9V8KJQZm8I2Kr7+M3Dh++F1m2KnR2mVbPTpiRi6eSTdm2xp3gN0fFdc804P+HVDBRilniTQV3/uo5qLGDlYkqqzBoCOHkRgaMjRWBKuRGc78nkE7vi9H4z9dnhzCfpQArbokpDWLgNbzXuWQtJv69XJVTRBZ3fjC8BPgL5I0D3K8vG8c8XRqlmNqt8Rd+aq0TZlsqkrIUw80H368UQBuQihRjqRJ3/6NqDA0gsP9hBLCa4CXRimB015JXrSqzkBiw2x2rGWEtMMMXXJo7XZrY8FNKbgQiw+3V8ktnc+NFdLeO3lV/hUgciXWqWSG+ktYO83
 bjTYpeg/
 qgHo3CdaJ0vyDgEOpBlipl6/j/ueogpPAvEyIIF87O5OBBqt0aFXmDfrJYnNsdnsWhMhkVNQ++l8mxsYogS0hAa8VzYG1ZV7IKy1gFqDcCn1GIa6U2o1/ebGJWsVYxANAUMajwAoFPrvujd1vNEXY8O+BeZEIG/ph3W+ovoU3AX+gQZj6AvqtRKP2ZKImyHgyBdFbtSPH/CALDnUJeu5M9IulCy1nLgCf4C8+qyKLZHMYS8+E5s0VN9Ny9rM/NDuCgfJFMgAg1oAliZnN2V1qwQfShg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 02, 2025 at 10:16:59AM -0800, Randy Dunlap wrote:
> 
> 
> On 11/2/25 1:00 AM, Leon Romanovsky wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > 
> > Reflect latest changes in p2p implementation to support DMABUF lifecycle.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  Documentation/driver-api/pci/p2pdma.rst | 95 +++++++++++++++++++++++++--------
> >  1 file changed, 72 insertions(+), 23 deletions(-)

<...>

> > +guarentee that the consuming driver has stopped using the MMIO during a removal
> 
>    guarantee

<...>

> > +if are used with mmap() must create special PTEs. As such there are very few
> 
>    if used

<...>

> > +pggmap of MEMORY_DEVICE_PCI_P2PDMA to create struct pages. The lifecylce of
> 
>    pgmap ?                                                        lifecycle

<...>

> > +architectures, others will experiance corruption or just crash in the kernel.
> 
>                               experience

<...>

> > +In this case the initator and target pci_devices are known and the P2P subsystem
> 
>                     initiator

<...>

> > +exporting driver has destroyed it's p2p_provider.
>                                   its

Thanks a lot, fixed.

> 
> -- 
> ~Randy
> 
> 

