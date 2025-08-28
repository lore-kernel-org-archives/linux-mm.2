Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4916ECA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 16:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 618F48E000C; Thu, 28 Aug 2025 12:54:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CA098E0008; Thu, 28 Aug 2025 12:54:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B9E48E000C; Thu, 28 Aug 2025 12:54:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 373988E0008
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:54:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D947E58434
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:54:35 +0000 (UTC)
X-FDA: 83826764910.08.B9F1F8F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 223341C000C
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:54:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Utug3C4q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756400074; a=rsa-sha256;
	cv=none;
	b=IJv4JyYY+YQ1iG1G9UO6x/1O4TqprxDicLIBm4jYCAPd2ffalcMrbb6topjZ6LyDDRwFyp
	cz+1o/CN/MS9kWmybL4JBpqCc+2ESp3TCvVlDKRAluqqPUV8BeEk7uw3KFiZGCLocN0f1M
	Yr9EngwxVBbP/vHIu+iZPero9HU+lL0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Utug3C4q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756400074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nk21NoeFbSZuqbZYbv31DbqcJk0/VzI2uLLcHSo6RQc=;
	b=ffRepvTp1wbBySOtHHdubBm6/12YYzl+LnZ/6tF2A5md3JT8m+eLL7tifczfcgywxIEl+a
	A2KGq4UWbXr6lq4cf76JPU0z0KpSuDU5mAfU77niLCtE5+vvYYaTLwwjc8muuIyj3zCntf
	qrNkOgikFjTZiTEriYhdHXp4hult8sM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F66D45196;
	Thu, 28 Aug 2025 16:54:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C34C4CEED;
	Thu, 28 Aug 2025 16:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756400072;
	bh=3QSqWFwhLXFpgIQB1AhDzeFYEFSsyOykW/t8YMcdvDs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Utug3C4qHAngGkUPRUqPcVpMv2skHSOiyTR1dzioCxiyV/N0D3D3xwLMN4kKVhjRg
	 R1e3GaQ66/QDlvAbclIdn1b0xrBO+DODu7rLesJ54dZQOJ+qr4UwXmhZorK6X6L1pe
	 /mKnN3THYo/PX+SSQI5FBBXcz4a8pvxXQG8iBycA9jlkdj9zJMMNMWOCxqVVHcRMG0
	 jrJGkyKqRduB/ujzl45UowCIqtVEnLBTqm/vLH4mWU4+vwRxIYccg9OHedq9aiILZs
	 hmuixBFk7xqznER0ERf4UjMVjXknV66U4Y9wYKKHbgLQRBDuheIDJSUa9AzDEN/7Pr
	 p4K8MwEWQi7/w==
Date: Thu, 28 Aug 2025 19:54:27 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Keith Busch <kbusch@kernel.org>
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
	kasan-dev@googlegroups.com, linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-nvme@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-trace-kernel@vger.kernel.org,
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
Subject: Re: [PATCH v4 15/16] block-dma: properly take MMIO path
Message-ID: <20250828165427.GB10073@unreal>
References: <cover.1755624249.git.leon@kernel.org>
 <642dbeb7aa94257eaea71ec63c06e3f939270023.1755624249.git.leon@kernel.org>
 <aLBzeMNT3WOrjprC@kbusch-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLBzeMNT3WOrjprC@kbusch-mbp>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 223341C000C
X-Stat-Signature: c3szisymeows7wsjjfb1hiworfe3ctmq
X-HE-Tag: 1756400073-357417
X-HE-Meta: U2FsdGVkX18zX5uKiUIY0vD4Kg440ayEQcPJB5vSQprt8vk2lc4xO9ng61yEAizRcvvMdPqcn4YuER6xvcwL14jPo9QtOHgyVznPvGU3iiCSzcUBGMNZwSNqcsVHvJHu08c52K+ELIerHFbIi1S5fAc+rDSIJ1vrAL1IBikB+9Xk9e3wo4CtRShwe6mAeP/OhyIqlas84uKahYG90XI/bCJ7SSEISkb2ZTeBQUH7GKqA2fB9w/9UOyE8cJSiF07gMusRsvbde9H7fI2xgBAoRvoiT//9aGBBc4CKG7/AZ0b/2CjiMuhM6PLffCDINu6K4nWiZb5HEy6bpgG5Ul0LAgkCweEk0X8n6lh615Smp9kT8K716+FqdVJRoSQsweZlusLncjrCILpswVFPiOhA5jEWO4XsVKPyQ4DN1/S6b5nRaRx3N1eaRJRqx5cL+oN3a6z4RGEe2ozOn0aEIwkmaKEVAW4sn+gm2hDRNCfxA/QUjWgvvrj5JjBew0F27idGzquWOlU37R/BoPjUs1jk37Qf4y//c08/RgoUdQkz7vtTidHY2zwRAnGAYAazJnRG52sWPnKbi2GPWiaRl46M0lmSGLzHrzT14noWA0UYFKOqp4XpMGkBwhQ2dLphyHmg/MJNVr+CdvzemCqKmDBXID7cXPFi10C1IZSCmizraLlHZzFjIJY+7jXycFcsyGydKYmMUFof2QtxuYFp9X/6MrT1iMATz00VWegXRY7c4PAFMp/v7YuDK7bnHnYr8OaGZ33WiQ8R6aq0JI1zO1wWpjKGB6CswwN2Iji7u9uMG5QGQexiFWYVdQEQ/oY7dATLXEgWVAs2gtQCBXnMw/fToF9J3y/Me+B8bqk81LiZ3hAJyIXPMEv0IhgTp3MI0Ga1ks0wgIGu4/VqvqEeQqq2CygjndEGZXazt6BWjvCeZKzipgqsr9D35wwoffAldD2+tHIaW1pg7yTlrdb1j57
 O/1t9Vkn
 QyWuXyD1veTzECO3EeRn4ZM667sTiHsy7RzDvxVmaL14iDchxqQpkjVbRHTPOVCFW43jw9ziApMuXSSbTRYNwxnfImtLmKMrjKbBZHV8KvdudmmGIqz6aoK0EkC+1RtrOYcD7u8NdX5NdXeRGnzjWMrz6P2P7Fp/PIo1kvman7jgwHExa61P+62AZAUhqvF91hv/1fEkaM+HywxMeYt6GE2nFEKGFOmKsNNTjkechUOSz7ldcdt5tEAz4SOysoirv/YTNuE+YVOdfiryCHOFlERZxiVufqOTN0Q9B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 09:19:20AM -0600, Keith Busch wrote:
> On Tue, Aug 19, 2025 at 08:36:59PM +0300, Leon Romanovsky wrote:
> > diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> > index 09b99d52fd36..283058bcb5b1 100644
> > --- a/include/linux/blk_types.h
> > +++ b/include/linux/blk_types.h
> > @@ -387,6 +387,7 @@ enum req_flag_bits {
> >  	__REQ_FS_PRIVATE,	/* for file system (submitter) use */
> >  	__REQ_ATOMIC,		/* for atomic write operations */
> >  	__REQ_P2PDMA,		/* contains P2P DMA pages */
> > +	__REQ_MMIO,		/* contains MMIO memory */
> >  	/*
> >  	 * Command specific flags, keep last:
> >  	 */
> > @@ -420,6 +421,7 @@ enum req_flag_bits {
> >  #define REQ_FS_PRIVATE	(__force blk_opf_t)(1ULL << __REQ_FS_PRIVATE)
> >  #define REQ_ATOMIC	(__force blk_opf_t)(1ULL << __REQ_ATOMIC)
> >  #define REQ_P2PDMA	(__force blk_opf_t)(1ULL << __REQ_P2PDMA)
> > +#define REQ_MMIO	(__force blk_opf_t)(1ULL << __REQ_MMIO)
> 
> Now that my integrity metadata DMA series is staged, I don't think we
> can use REQ flags like this because data and metadata may have different
> mapping types. I think we should add a flags field to the dma_iova_state
> instead.

Before integrity metadata code was merged, the assumption was that request is
only one type or p2p or host. Is it still holding now?

And we can't store in dma_iova_state() as HMM/RDMA code works in page-based
granularity and one dma_iova_state() can mix different types.

Thanks

> 

