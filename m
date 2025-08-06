Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 501A0C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 18:38:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C390D8E0003; Wed,  6 Aug 2025 14:38:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10B58E0002; Wed,  6 Aug 2025 14:38:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4D548E0003; Wed,  6 Aug 2025 14:38:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A8C788E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 14:38:38 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2688DC073F
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:38:38 +0000 (UTC)
X-FDA: 83747193516.04.CD3C35F
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf27.hostedemail.com (Postfix) with ESMTP id 87DD74000F
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:38:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ge50qjue;
	spf=pass (imf27.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754505516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1x3Q7Y/VrhoNVJRSqy0Fcj4XeiXf5SuLbr9bYLsjRI8=;
	b=cjdJfCiCuG8I/z/jsMsgMDvO3EWFsCbWDRvkgA1iUY9Nv4eWiHIvffMOxqdGAaJ4G3VxHf
	fpeDw3sDcCpW3mKkR+5XuTxGQCh2i052dP2xWvPRfFd6pkGTOjDKJbk1yate8OVrCfeHNT
	ve+5a7dY3ZIJMg6b/FFP7uu89UnOZO0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ge50qjue;
	spf=pass (imf27.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754505516; a=rsa-sha256;
	cv=none;
	b=bZBjXAK29mK1dhs2coTF6ETaLJdrSnE1VYaql/neDC2MCJTH8fA92YNXtxOhfkJC7fWNHD
	XQ5Mb/+dGvfQClWV9hYhwwkcPzPkt6e2+2Gzm9fO62WZJO/QSJbvl2BcMUL3F/CUGqOF4+
	njlXQzsK+eYqf0l/gqPGpASL0sV0CFo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 534C15C5889;
	Wed,  6 Aug 2025 18:38:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410C2C4CEE7;
	Wed,  6 Aug 2025 18:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754505514;
	bh=3VsSAjLVcmccxCZ3hnnn1RvFFPeP1KXfNR/kPK523tc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ge50qjueu3yzrmSLvI7mO9n8KQkiFiYfr4PhBvbyi9xJtwRH+3VLE26OL160ezEfS
	 l7n3yTGZYML7usXiAxesUibX5X3uv+Y7zSbVhAbamikh3Xal+W4d9sOmoNJufjNKOd
	 mltqBVBcA3J9CQVjxxN7y8g/410e0ODnTntjvgOrjJZ0GcQu7FKKjy5hCvF14lL7EB
	 GCHlgBFQUU1u6mCSnNeVtRb+60F9YWCMntqEV5h3kpkOIbolMnee/QD5F6iZ+TELym
	 IpJ05UFpUZfqx3imORqYTmOC8S0Z30OtwN23sPhn2SppRACGNtVevxAEaRFm6toCBl
	 Pc8wnVLkh3LNQ==
Date: Wed, 6 Aug 2025 21:38:31 +0300
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
Subject: Re: [PATCH v1 03/16] dma-debug: refactor to use physical addresses
 for page mapping
Message-ID: <20250806183831.GW402218@unreal>
References: <cover.1754292567.git.leon@kernel.org>
 <9ba84c387ce67389cd80f374408eebb58326c448.1754292567.git.leon@kernel.org>
 <20250806182630.GC184255@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250806182630.GC184255@nvidia.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 87DD74000F
X-Rspamd-Server: rspam06
X-Stat-Signature: z5jpxnm531uedd7ra1y1dd7epz6oz7rf
X-HE-Tag: 1754505516-487250
X-HE-Meta: U2FsdGVkX18vlybH0PxBP88FFlHP1et+oa01ELOHmsomGvtWmVX+mAMvb5AffMUpkfUfDk7vOako9mbWxaoEob3jY3P8Eznb0uy/Q1gaI9e72ddMN7ZeDco2SU5KxtuNCjkkdSTCEp292MBGFB02/2o2NoAnM1tnbO4mr/8tzMRfm3LP74JS4hy4hQdncjACPJ5UMhNZMSX1a7bsCg6lf3bthv2ynKbGNRtHjng27Pm0ungtng5uNOLg32ELjwPrYKbhhWLFOBuLgSfFqt+112c8Lka+1finogQ0TNEUe2tDu3+3QuJGNP97G6cy4T/csr/IX3g7dNrEZdG/VWdJ8sJrtH5ZHF8/GY/7zzw74Vpgqb8RmckKjbYW6tnmNgjvAuU2l6JHO2dKeC/1sAQT5pAzF1NivUV0BexHLELEWmZIfCgVXB1HFMT2Wa9Ay22Nb0AE1g0syfrNYjFKdqFhCS23+JVm9wXVmi1407vrkCEQLiC+P/xWspjR2LhKlMB2pxGVemzdISIHraliecX/K2o7RI1ciW3Ve3w8KKdT1mx0wy9jcHbaihzWlG9VBB1PMSwMULOwEXAHs3duGVsboGFt5GU1xRrfvdXosVWpEbaOr+qI65oHGMFRJ11QCbnGFNRLuwg6Zwafzte0bAEVoDuGA8NkCrul/a6MfDsy7bgANgdnIT+etBoZqZpS2KgbaS5stXbHFGhqhXPfcVnXuSfYcDQkDj1WUAQxKTniTZJlxQnJzrUgcxF1LENqOcIJws/x5tBl/K7n9BHHVvhts9/G2hr6y2RHied/lBFQ6ImTgyG2v2H9ybzuMLB3SdRGJFkzv4NJlowU4vMFTB2dgsa6scUR3nBx1SK431QYgPNas1t6yZmJl5J5YsJTsa4TKtvKRARwlKbHhtQ/9jXJvHxZlxSdE/1+cUHXLsXcEupFr/lijp3M0OebYH55IOnGhSTYQb9WzSdxcI4Bx03
 V0W3g5yC
 bE4VQ8km3ry7xUnGBqpNwNDZugTUewg9GCvTMddBLWheGUQ+nJmr7CuxGO9Vx3U3iP/99PyheTgfSBIt5JH28N7YOPZljpQ9XRJtpsUIFu+JFyCjKoSURg/Hj2R2JLMmw9eRKzVAhCzWJChIqlJnIjiCNbShV9R5M8UwwX7XwqiOck64i0YkFusPgatPDKNafSh00I2Vzz2Hy1D4fpm/6/LUAxeYkPjm2qDL5DM9n/QbBW9M2Fcdeu/JJnw68ffzWAxDqpG3eG0jhOQQCCEBkva453qWPc9RmX5WqbVmiN5i4zYToNsVxgdwQFpqdAMRkua4v45KBB+hu2gR9HyAnQSgvfZ4h9G0AmV3I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 06, 2025 at 03:26:30PM -0300, Jason Gunthorpe wrote:
> On Mon, Aug 04, 2025 at 03:42:37PM +0300, Leon Romanovsky wrote:
> > +void debug_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
> > +		int direction, dma_addr_t dma_addr, unsigned long attrs)
> >  {
> >  	struct dma_debug_entry *entry;
> 
> Should this patch should also absorb debug_dma_map_resource() into
> here as well and we can have the caller of dma_dma_map_resource() call
> debug_dma_map_page with ATTR_MMIO?

It is done in "[PATCH v1 11/16] dma-mapping: export new dma_*map_phys() interface".

Thanks

> 
> If not, this looks OK
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Jason
> 

