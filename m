Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69A68CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:43:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4DEB9001B5; Thu, 14 Aug 2025 13:43:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF84D900172; Thu, 14 Aug 2025 13:43:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE62F9001B5; Thu, 14 Aug 2025 13:43:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98E14900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:43:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2B21F13881A
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:43:42 +0000 (UTC)
X-FDA: 83776085484.11.C36F5D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9CC6940007
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:43:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qET8o0Xv;
	spf=pass (imf04.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755193420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z1CFrWb4l1P3vBMSmP6h2aBCsMLffmmJDEsMJ59wit8=;
	b=79mLZC9oi5c73Fy1l0y+L+Kb/6301S2ZF2bgVX43VJPZBI76BSYASYwB2mydiBlDcHnUre
	dQhRf08aKkeNLoaNs1f3OG8Z8DgpocdpZtTT49+xoBnEORLyCCw6EPIfdnAmYxM21Z64vg
	MIPtZ/APwNhfj3+yf7jrwCAJzHIBqwk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qET8o0Xv;
	spf=pass (imf04.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755193420; a=rsa-sha256;
	cv=none;
	b=P2r31g7pDVAJxkIyMRoDw7u7T/3a8atRnKXWImzrCiInM9qsPNOw49OWiiuRAotzzWuW0D
	QbCUNWGvvCErlZxVBirpIR7muXgHtsilmwZsPhgRZPm0TJxjG0Hx0lG9jQtxGWVjcYP3+I
	/PXz5JpTV8AaTCrOPQJ0rv6h+KkVfwo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7FB4F601D8;
	Thu, 14 Aug 2025 17:43:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66588C4CEED;
	Thu, 14 Aug 2025 17:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755193419;
	bh=NtGaXEt/rCXZbH6AhRXhKag5AQfcAprg8g7HcBf4fa8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qET8o0XvKzXdUiWMSbCsLL3eECdWZ/AbT+J3b7auosgo7K/gf6rt6x3D6UTI76iqO
	 ti/iGG5xkCHTOQimoWMmFfEnk9qKFL2quOO5nh0SiN+AtdcIknOOMaCwhWCHlP4gMD
	 ykB+wRt62M5cjTVShpIgxGBKujUJevNaAvQmESCXsgTaz6eSAmBzP6Np2+HWgacd/i
	 ptn2QT+kSVgRjXKbq92+rFZQUf9rAqUBC2DFgoqq/jRE8er78UlpXtOrVW/WVebQgm
	 oscioXsT1akK/vdGGIJZToP0KYoeWZGwANzuVPBNp0BvFFlINHo65cmqBExc85Nyt2
	 XqGc4T1I2WbCQ==
Date: Thu, 14 Aug 2025 20:43:33 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	iommu@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>, Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com, Keith Busch <kbusch@kernel.org>,
	linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-nvme@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v2 01/16] dma-mapping: introduce new DMA attribute to
 indicate MMIO memory
Message-ID: <20250814174333.GA8427@unreal>
References: <cover.1755153054.git.leon@kernel.org>
 <f832644c76e13de504ecf03450fd5d125f72f4c6.1755153054.git.leon@kernel.org>
 <c855a4f9-4a50-4e02-9ac6-372abe7da730@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c855a4f9-4a50-4e02-9ac6-372abe7da730@infradead.org>
X-Stat-Signature: n77xo833jp8ioyosjqc1o6w1heic1ruc
X-Rspam-User: 
X-Rspamd-Queue-Id: 9CC6940007
X-Rspamd-Server: rspam05
X-HE-Tag: 1755193420-492651
X-HE-Meta: U2FsdGVkX19Mhzd1bHnkJLZaKCeXL73Q8eNFxmdGnBvJXZqRAZ5Wv5YavDHsngeGfyUSdjzrrM/RxnvlRJ4L6H+qGxrxcIYSC7KQsYj8/ZvHKHKJvkV0yUzVUKwXZPiO3/Qfipg5sVvFDV5SZ+lOpIyxSBToG6bxJpqKU67K6XSR6nzcthGq0vxbxsv0sQw7kSu6mZHj/1i9q6JWDYzvk/koGEz8JP3IVwbrybrxpbPTeBJ2F0ONkL/3CbRVwjt3BmcYCpYKFE6QksWRWBIfJIUYwM4TWp8gAOf1ViQXBZaPlSmZDJVI/oT/q7LSYzZj/6FpED9KXzVtaCWBb+UiAZpJPIeaxkFOHOGnSEd0aVoL0ANKW4F3C5nMBt6G/9dQV4++5rQFZVmS1EZtB0Elm0yZu6C7yoZfdgz2AiUdvhW61HVZgRcgC/nZWDlFg6BnOgGR82CvfjA53+0TnJakJzjECpGddWRkxz7k8Ae6oFhZlj3ZJM2Dc68dD+sFeK78AqVyBS9KdIWsZST5fjccY7SQYCwTr1KBTAYHSxiBIV+YXb/c/XLAU3rfO0rBJlkje+vMWmi8GIbRQvbIByfCfUknJ6EzDzWreGOZMRv+l8MxhWo2fybLy1FS3UGbhxF1/J5gcWMAbAosgM2Gum4JVZTsf8U57Il+hLxPSOeG19F7tyLJW3B2E8CY5zBzLuTxlF/EE3/O90pNSw40oSZUvR5/F+OwXA0qoYcCSplT4NrN5eo8n0mXanS0RYsYRrU3pODuKNeZD955J/Z/U+9SFJ/JS9NrbDKMAnaZLy14rFEY3CrFNpJq45yaNoHZXiLSCU/jzNPEsehqoNvz99NLGhhpD/3yxJl26V4O/FU1qvc+YvWf7S7KExWb91JnWYouYtq9nSn7xj+SIUFWj84anKMU47HAth8wVdxkRVufhAESVx/DweYKTFmDKUFpDJnT+FiWMOQiUdeebG41/3O
 Be1Q0Gs0
 Bt9i/8T7l8rlob+GcwTd8O4xc/66BLr7wrm+mNVJlrqxGu21oZ5ODRqgABY497LoQo5ZzEQm/+g395ZUzGoVNjL2UhCOuJiOrz7dgml29aNtUCKNl6sBrmYLjB3L7qyIosdmWrFDMg/Ay7KMRxbR6QN5brc+JvM85OZA1Mzv33RtkDReSWg2ZMWU1nswFp2cjVZAbzH4ZRQmhm00fRBBwj3HIwkoBUvQQqu7X3exMmMF4RYzEpk6sgz5GUM7zia4UAlTFnHO2CLydqLwCFuOz6spzGDYve0kUhBBBjVhsWEuS7YCbuIbndq1z5beEGalyVoMB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 10:37:22AM -0700, Randy Dunlap wrote:
> Hi Leon,
> 
> On 8/14/25 3:13 AM, Leon Romanovsky wrote:
> > diff --git a/Documentation/core-api/dma-attributes.rst b/Documentation/core-api/dma-attributes.rst
> > index 1887d92e8e92..58a1528a9bb9 100644
> > --- a/Documentation/core-api/dma-attributes.rst
> > +++ b/Documentation/core-api/dma-attributes.rst
> > @@ -130,3 +130,21 @@ accesses to DMA buffers in both privileged "supervisor" and unprivileged
> >  subsystem that the buffer is fully accessible at the elevated privilege
> >  level (and ideally inaccessible or at least read-only at the
> >  lesser-privileged levels).
> > +
> > +DMA_ATTR_MMIO
> > +-------------
> > +
> > +This attribute indicates the physical address is not normal system
> > +memory. It may not be used with kmap*()/phys_to_virt()/phys_to_page()
> > +functions, it may not be cachable, and access using CPU load/store
> 
> Usually "cacheable" (git grep -w cacheable counts 1042 hits vs.
> 55 hits for "cachable"). And the $internet agrees.
> 
> > +instructions may not be allowed.
> > +
> > +Usually this will be used to describe MMIO addresses, or other non
> 
> non-cacheable
> 
> > +cachable register addresses. When DMA mapping this sort of address we
> 
> > +call the operation Peer to Peer as a one device is DMA'ing to another
> > +device. For PCI devices the p2pdma APIs must be used to determine if
> > +DMA_ATTR_MMIO is appropriate.
> > +
> > +For architectures that require cache flushing for DMA coherence
> > +DMA_ATTR_MMIO will not perform any cache flushing. The address
> > +provided must never be mapped cachable into the CPU.
> again.

Thanks, I will fix.

> 
> thanks.
> -- 
> ~Randy
> 
> 

