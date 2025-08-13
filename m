Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED679CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 15:37:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EF899000A6; Wed, 13 Aug 2025 11:37:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C714900088; Wed, 13 Aug 2025 11:37:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 404329000A6; Wed, 13 Aug 2025 11:37:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2F4B3900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 11:37:36 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9CD881A03F4
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 15:37:35 +0000 (UTC)
X-FDA: 83772138870.22.5E6A7BD
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf14.hostedemail.com (Postfix) with ESMTP id D8399100013
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 15:37:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kkqdIE/H";
	spf=pass (imf14.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755099454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zm/dCvvK+iI7j714RjSP/vwEDHJVwvkiYDPPSLpMKNg=;
	b=JFWzruRFtZWk52af1sg3wIzMfVV38r/1pl6pxXgT71p2xP1QrbotTAJDlKDoll3qDBJSyn
	/LK0LGzpDliV3gEuF4wZ2QfauhVVeG3/OItcXcWeDs1gI6CPKYZ82Gm9LND7M4z3k6YIUv
	UaxVsb7eKqg3946NwAwkLKd9Vll68dc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kkqdIE/H";
	spf=pass (imf14.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755099454; a=rsa-sha256;
	cv=none;
	b=J2eIoQI+Wuw3g1pvsiV2wNGF5uTmsPG6sqVrU50ZyksvWRnJsvn91vnGEalkmuZRrLzyOL
	f1tf3TTCibmx7XsBZdy3PiiYAhSeslKS1DRkuXu/AMQrUSc8d3mw/u0vbt2R0hzH681vqU
	v2fOoCqRtImGuK9daGfiZ6jC3Z8TDlo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id B00E35C1360;
	Wed, 13 Aug 2025 15:37:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A911EC4CEEB;
	Wed, 13 Aug 2025 15:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755099452;
	bh=PQhq5rWxBSi6wo5Tnnh0V92zapg7M+UyVJSAH0kCd/o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kkqdIE/HRQ5cedE1zyuMfMRaAZJeqzpFBH0/fLyOJbOpD7Q9Y6fUKKVCUSYg6Iu9+
	 +0lhPpaogX+zo7DE625PlBBN7tO+nQtx0LA2aKRv5GqYQcf/TD8I++3mIddUS1oGuS
	 2Xu0FGRyeN7MRl5kxApDBRYf8dHZhW8fLMu9BCMo8fTZeDkfiJH03TaTo8MCeUS3wk
	 Q3N2kSeVd08IYz9d3sNubS0p0XfPjY2fnOy5IU5HLL6nAdg88Wdvo9IzmX54CnrqWQ
	 dCVsQbDhz8GqQ+nB2+l0260S3CZs7QJe8H773Ex1NmDTheYUl2t1VYx6TqiJOtited
	 Jw1XTt4Q0BCbw==
Date: Wed, 13 Aug 2025 18:37:28 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
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
Subject: Re: [PATCH v1 16/16] nvme-pci: unmap MMIO pages with appropriate
 interface
Message-ID: <20250813153728.GC310013@unreal>
References: <cover.1754292567.git.leon@kernel.org>
 <5b0131f82a3d14acaa85f0d1dd608d2913af84e2.1754292567.git.leon@kernel.org>
 <20250807134533.GM184255@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807134533.GM184255@nvidia.com>
X-Rspamd-Queue-Id: D8399100013
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: fuggffep8t5f1agn71ba78euyywixntq
X-HE-Tag: 1755099453-798986
X-HE-Meta: U2FsdGVkX19PaWQyILmwcRX38K5DtloNGqB5+OJ7Ftm/672BMr9dkQY2x6ZARRIJtK9oACYzG1A+lZw2nRrkt87JT8YxhU10m72k2cIPR/eSqznGfozL1pPpldWy5NwBdEVw9o3FoWTWSwYUeIuI+RfkQpqvDhAE5qwsIWe4B3dTecpbhlmjus5hOFEDp9K/bMF73Vt48JWA7IFVbUoHF4aOTuWV0/edDd+rwECiV8emQOGkC1ChK1XPYGsP8XE+tRL/b3kIlCgX2v7A3Hd7ob6zCmblK5YqVON4RsmYW5PByehMFNX+HFR9qYrUyr70TtjogZ0SVCSaAt2FBedraGrMqlcAR5K3xY1Sn22x2igGyX3kpGABNHshGXxmR/HMgZJr6wzReJaiEtloqZ52LSoCVolllLOcyVYiW9HA8Fc1YS/np6PpJ+DNv00Q1d6X6MAg39UIRZRgHcM20YkQtrNgq0BXVPJWjVJRtn4tQHex9FZIJKNJS3izrw/yarHwuvKjLTfqS8gDnwS6lx6fD/kIhvaEjwMozWF52Qp2JWJdyTWQAvHXEwy84asR2z1XiVwKkdIGaeludK95nDpEfjBu83oXZms++w3bVyeu+VIGHY3DMkRe72j/AUwL+jxtQEDbLEEIKrKOFQFbR7Cz/uTHroHr0rdxnybQ7O6v5/xPxUj8yFZF8rG7dAVNKlChCNmckNTZsjKN1XWULYHFNe96VhHwp/IrhJ0VJmUURSEVumxNES8YBRC0S+u5UNJUlVpQdJVhDjaY2TNbuePIGLhaJ+di/2nmNj4lSDqT5FxCRqnEhOV1DdHEIMS5MN5ebOk6jNtrDICjWR0wa6Mc+OEpDOQZgBKvEnPwdw+CiNGSGTqCtqfAf/DLeWaN0rnca0P8KYb7/5dBEHHFxUYuBvz8zot/5MTlrz6h3DoUEM0xqSJ7xBjOKtu0y2zRBTVKEY6KHNDYZSEobdbCrBo
 T7lhw8S6
 8cMrtsjc6W/bWBjRxZeUwJKO2BN4QXYeAIl72zSoAPw8++cZTunbvarE5J86a+MievlqSLmtjmqSLJx4U7hFAbVeGU5wNQvPmyjUUl00s21eMj17s57W7UF9ZOdezZt3ms0gXtTmwHLbo8WMxP0OhqQZFmnVT8Pr7z2fpL13eiB0YVs9v1KJPbZH+AohShRDT+Rn+vixUjduKmm9HF7TBUT7zW1iQAHRvNx/Pk3H4rnH7YrLlP5AnhQruMbemB6HpxU96Q8k1+TlT7H5YxPz/dY7Mecd2ouBPi6DfyG3sU5IP632fyS63stoy2Rk3aRNj/4gp05YdxOA375m7Ve+oBohzY+3yrGeOioPW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 10:45:33AM -0300, Jason Gunthorpe wrote:
> On Mon, Aug 04, 2025 at 03:42:50PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Block layer maps MMIO memory through dma_map_phys() interface
> > with help of DMA_ATTR_MMIO attribute. There is a need to unmap
> > that memory with the appropriate unmap function.
> 
> Be specific, AFIACT the issue is that on dma_ops platforms the map
> will call ops->map_resource for ATTR_MMIO so we must have the unmap
> call ops->unmap_resournce
> 
> Maybe these patches should be swapped then, as adding ATTR_MMIO seems
> like it created this issue?

The best variant will be to squash previous patch "block-dma: properly
take MMIO path", but I don't want to mix them as they for different
kernel areas.

Thanks

> 
> Jason
> 

