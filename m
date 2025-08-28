Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF4D2CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 17:18:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FB2D6B002E; Thu, 28 Aug 2025 13:15:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AB796B0062; Thu, 28 Aug 2025 13:15:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44A106B002E; Thu, 28 Aug 2025 13:15:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 245376B002E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:15:28 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC5328478F
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:15:27 +0000 (UTC)
X-FDA: 83826817494.11.43EB67B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 295E4C0005
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:15:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fnmNyIm6;
	spf=pass (imf10.hostedemail.com: domain of kbusch@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kbusch@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756401326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KCRt+XDfxBj5z23z/FYOBSKOJE6UKgt5OADwYjTTtQI=;
	b=ZYDDYWewwbF9TSRSo8Onm94Htkzu9mQo0Jqsp9JlD0dL/SFYhZrzyEqHkiXONLoCbRjBXQ
	irgH99U+Atzo5basWgNM//HrhUpuW42H5hKb46Tpb5eTWqbIk8xGCqHAWyZpKKax1ab22S
	WErqj8AVgAQBJ7M+cgcsBkm0UX4dPDQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fnmNyIm6;
	spf=pass (imf10.hostedemail.com: domain of kbusch@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kbusch@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756401326; a=rsa-sha256;
	cv=none;
	b=F4Bn4dSYK/ffEJMwOwaYymqBPNksnHPWQwh1bzEiAK7hewhKzjkBuuoWYzpNTSesAKz4AS
	kO/cQcVGtCRv6+TwE4HQcRP/xT2aLXTEjoZll6c0GMdSzoUFo5CuwEkUjkmWV7naKzl9vT
	DySvXFvsT2nb55dZNJJj9Fc/noIu278=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ECDE644C27;
	Thu, 28 Aug 2025 17:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A72BC4CEF4;
	Thu, 28 Aug 2025 17:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756401324;
	bh=ou3iD8shgadPVxQRtF41FaHPfXiCub7fMhAggBLVXMc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fnmNyIm6kveacQ6zFjHwSr/ld+cbNXoqmfCrawHp1gvsXVCDDljqqxTV+b1zApRgH
	 5lcwKbYEv5XvzJ74pZRRlHz4xMMdbU2hypSAtpXWfDMqRVbb/qc2SqQSSCNqbZ1peQ
	 BdR01HGV590kQ600i1NoQpXCyGOYKnHeIsk3mGhcH3PGq+tQybbYkfchgS5mr5H49F
	 IvJGdW2sSi79scStsbkC/ihQucpNHR67O3EvTjBCfBwOnwU2YHvQc3Mh/Yo09lKjUz
	 oioVDuGo8iH8GapTPxpdVPh2h5wOe61XtWreqwSjOT2z6hU8npwTgtY7JSO24epBr/
	 2W6Y4P8WQ/UJw==
Date: Thu, 28 Aug 2025 11:15:20 -0600
From: Keith Busch <kbusch@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
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
Message-ID: <aLCOqIaoaKUEOdeh@kbusch-mbp>
References: <cover.1755624249.git.leon@kernel.org>
 <642dbeb7aa94257eaea71ec63c06e3f939270023.1755624249.git.leon@kernel.org>
 <aLBzeMNT3WOrjprC@kbusch-mbp>
 <20250828165427.GB10073@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828165427.GB10073@unreal>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 295E4C0005
X-Stat-Signature: ma9pdmskbajkquy9bygp1zeewy6n1781
X-Rspam-User: 
X-HE-Tag: 1756401325-832699
X-HE-Meta: U2FsdGVkX1/1+cvOmOc/zmH9nbVkAbz9h+8GNvtzbniQcU+BCL/duqjVpFlfUT02yDptndHolXu8Ntu3o5tPz7WbMOi/CLOv7W/wKb9R2Bbw0HOyG/9zHhDqjtXNVwCMuUWjqymIVoEBj0dMLH5N8CLJYFTM8+zACk7xwodWHxNF+wc7HJixyDILK+1vRNQcy018E2isbPG2DJbxFAjBzvaUIJc6IXRDsIdBj8+ywa1+iRTper0Wje7SnijgvHsPco+RCIqChdFXZMqc/EqbCDcTNQwj13ihnVww1WhydadrD+3SFUklSYzYCBVsZ4Fsx//EzTNFay3E00CAx6+vl1VDuaR3W5RI8emr/37edYwJaluHC00jXzrcAGMEAN8eMaRS9g+5hkmdTcFw+m16tSrjcRHP3WOhojZCEMxRdNlKtQYnPuYp9idDEoOMiO0PkP/tTWeFXAOfmw0YJFZUupbSe91zC0jmamUtA3c/ujyErmdEVLhPHKMKPuScdDYqwoU2etk7fWRAfQSyqsweXPJDClZ9Wqdx9SlGLJ9OfeO94PO7DbQ5olMBwx2f3rBquK7m3dtoe9Kq5QTgqhtdvClwn9WRjDIzZOmODHnNlIya/9Nx2B3mXBR5vaqdxq8aKk7RCuW7KsxD0zqnTqE+SF0oLW1jE/zEd8qgtHKWihAoAs/LjS0wu/lYZKYvorVu3l2Gadq7FTXh3TPjfSPkEnXTLX89w2aVrMxCPveSRuJ3tdAaRQ02DNFoV04CvIIx0Intc/yjBigQRXLkQQ6e5Mtr4PoV2GsNX8aSpgLu2gf59KeytkyBFMM8QIGBcPbiyl4j4uItlzDNHmiVwIz/a1svbYIhb+jlB4gUVxPHQ8v4xcaUXdIZtQ2YokKtOgar4h3za2kKx9923Gl/8DmptkjTrcQ29ldvjkLPZRK42z/kOFkxWb0pIHY1h39Zf41WE/1yykleBQMp2Gmsvk/
 JnnF2Nut
 K0IvKsmj2rQN/S1t1/G2+YrYvxWL3exQRHZwDosYDnB2GCMo3JsyBaM32c0FT6532MHgNgO5m2OFSg3pmpbp7AvuwZs0sO5dh6vm6quGemQYP8Ufbsmri8sWkz+QQ8TUKlopiSvEfIJto2d32JeBqAIQFkGmnacnPB2rRpMZCwQms3d8vY/qcTeltt5zK8BhlnBou9Iiv/7ZgAhz0UE0qlU+jPbvNyK3XjbZxioLCk2F49E10vMzDFYiMveMuiJnQ83b3E20oZDdmAzH15s7bMzq0eg+gYGFggi4Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 07:54:27PM +0300, Leon Romanovsky wrote:
> On Thu, Aug 28, 2025 at 09:19:20AM -0600, Keith Busch wrote:
> > On Tue, Aug 19, 2025 at 08:36:59PM +0300, Leon Romanovsky wrote:
> > > diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> > > index 09b99d52fd36..283058bcb5b1 100644
> > > --- a/include/linux/blk_types.h
> > > +++ b/include/linux/blk_types.h
> > > @@ -387,6 +387,7 @@ enum req_flag_bits {
> > >  	__REQ_FS_PRIVATE,	/* for file system (submitter) use */
> > >  	__REQ_ATOMIC,		/* for atomic write operations */
> > >  	__REQ_P2PDMA,		/* contains P2P DMA pages */
> > > +	__REQ_MMIO,		/* contains MMIO memory */
> > >  	/*
> > >  	 * Command specific flags, keep last:
> > >  	 */
> > > @@ -420,6 +421,7 @@ enum req_flag_bits {
> > >  #define REQ_FS_PRIVATE	(__force blk_opf_t)(1ULL << __REQ_FS_PRIVATE)
> > >  #define REQ_ATOMIC	(__force blk_opf_t)(1ULL << __REQ_ATOMIC)
> > >  #define REQ_P2PDMA	(__force blk_opf_t)(1ULL << __REQ_P2PDMA)
> > > +#define REQ_MMIO	(__force blk_opf_t)(1ULL << __REQ_MMIO)
> > 
> > Now that my integrity metadata DMA series is staged, I don't think we
> > can use REQ flags like this because data and metadata may have different
> > mapping types. I think we should add a flags field to the dma_iova_state
> > instead.
> 
> Before integrity metadata code was merged, the assumption was that request is
> only one type or p2p or host. Is it still holding now?

I don't think that was ever the case. Metadata is allocated
independently of the data payload, usually by the kernel in
bio_integrity_prep() just before dispatching the request. The bio may
have a p2p data payload, but the integrity metadata is just a kmalloc
buf in that path.

> And we can't store in dma_iova_state() as HMM/RDMA code works in page-based
> granularity and one dma_iova_state() can mix different types.

I see.

