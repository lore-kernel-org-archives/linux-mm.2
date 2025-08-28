Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5056CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 15:20:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B55A8E002F; Thu, 28 Aug 2025 11:19:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08C4D8E002E; Thu, 28 Aug 2025 11:19:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0B4A8E002F; Thu, 28 Aug 2025 11:19:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF7838E002E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 11:19:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8DC4A83F78
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 15:19:26 +0000 (UTC)
X-FDA: 83826525132.06.E0C277F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id E0EE9160008
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 15:19:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Fiz/IFX/";
	spf=pass (imf08.hostedemail.com: domain of kbusch@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kbusch@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756394365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Wz4elI208IK+JSajFW9ZYSY4sJyfxAIN3oV4QuXWNY=;
	b=ZS8P7SvCclXXVVC4i3eO4z+cMq73/2ii/0rXaeE5QJm+zS1AHBc6BU2ZsJcuLVEdpt5Y8D
	XQvzeOKDYokFROfzdDv+zUVTl3QrF9IHQNm6psKrXhZKJNB45WkBnru9J5Pq+Isum64hsL
	KVCcY6/B5EzHnSYvKwKyypB62kHX+G0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Fiz/IFX/";
	spf=pass (imf08.hostedemail.com: domain of kbusch@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kbusch@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756394365; a=rsa-sha256;
	cv=none;
	b=Eylp+gi41D/cc7mumyDfLfFryuBf4+0J5QXP83QH8aaiUOicp2qntGjrMNTIpHh7rNVPAZ
	g9UNVKIl2AyEpTJdkRpUgff6UQEKFq2E+ROvDHAUKK4hMFQRVzb4L7fb/pug01bhZJ/o4M
	jrjxY0yPyAab7FVDxUwS3uNMPw8NItw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8EB99404AA;
	Thu, 28 Aug 2025 15:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D216BC4CEEB;
	Thu, 28 Aug 2025 15:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756394363;
	bh=nTKrcpDsshWT34MR4DBCaPN8mPA7gJtcVOPD1NWA+qw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fiz/IFX/cbprksFrwcYLPDvY3Zj3oM+9xj/s3otiwCFW0WEBrDAgB6JRjK+IdqZnC
	 OFN4Z0AL7m05VQmwPYApcrLewjZzB+NKCYXZOIU9ibwe7/P/cr26ecTqFmQEgaS6pv
	 89DgMHR/jfK9TG7bugNXs7ta3ON2u0FFPpRcZMhF8LuBBzR8fYiYNcrkRaeoqL84Pa
	 vG8dcgdTqIBhIwwgWFEaigYJZlxM0LDruE+7Hf8BMGaT2uPwEeDcL2AHvfnUbMmlQ1
	 qic40gUjOmMG1Ib24qu6/1eYpqYTDcYO5/R+Bonh5umwbDCeb4/lCZ33BnqzYEikCq
	 EOso5xuGJTjTg==
Date: Thu, 28 Aug 2025 09:19:20 -0600
From: Keith Busch <kbusch@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Leon Romanovsky <leonro@nvidia.com>,
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
Message-ID: <aLBzeMNT3WOrjprC@kbusch-mbp>
References: <cover.1755624249.git.leon@kernel.org>
 <642dbeb7aa94257eaea71ec63c06e3f939270023.1755624249.git.leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <642dbeb7aa94257eaea71ec63c06e3f939270023.1755624249.git.leon@kernel.org>
X-Stat-Signature: yxew4f1hka17oh5azu9b191t741wpfca
X-Rspam-User: 
X-Rspamd-Queue-Id: E0EE9160008
X-Rspamd-Server: rspam05
X-HE-Tag: 1756394364-363849
X-HE-Meta: U2FsdGVkX1+gsPL9b4rgQIZCCluRAZiZggGPe7zs5+t8ojqLr1FqDfSc3VszIE8mEVY6c4SCFJ9LoyyB48RuMzwyi/+gjJWLHHGX8BLluPhS5GTKWEN/Cv2mfEiENJX9QLosr1JGiuZ3rQqzWdKEU3J8mIYQobQcONpIpI5x5pLLqxC//d7+mGkgX5lMDA7UFl+UFAxM6QQwGprMWkitAEv582aQKk7aTRpqMbEbZcTXJwFAt0rWRcCXHeqRC3P2lKhQt+MQwMmaOHSB+soe7OmBsv3lfnrNmovncfu/X78hpj4SMlZrveqCp+sNO40wEoo9unDWfNRNLgA61CxCeLfLSLyhLKsaDtqFRyYzeQBqCDWVjABItfkFGYhX0+WU9XpAfj6Um/eSbXzCmKyWWKohqqJ+6bU/SneAkVkVIL3fy3iIUv6ibphgQOP2lB6QOjaENHMQlEaXeJO3/uBcNaa166jW1/jLI+pnGi2VMBqfhxvsIxCMwkrNW/54pYeIReUkmNKxBXf34ITZ0dNWpNdb5a5trMv/ftHyc4kiMz1KkjTMwhY4hhGp6hhlCzle1aoVzTyW5UIwYSSSTAmMuVKIEidcfo8sG5beXC2nSXugyFxKlV6EBTPTr+ZeRoEoMOPVxQTtOjniKozRQk4SMZCFgmM2E/AZXglSOSpJSEjxtGiz0TfaeOYEGT1yDYNzY+JO4fpZrUlghRAioiWGkhEX8BnXsNcW2Ry33DG9cp3SyYxyZyZNFJzHUXGCpNMxlV9p5eNCMbVLVzRbfNvqhNF0W+CeJRDLqXO3ELP7a3NRPyLQQTtjHeicysh6RRevqB39YfGe69Xlh8FsN4eCc4uzG/aFqgQxco+9gnrOy7Q38aPaUMrSX6FPkMgWhj9d+oJuYCrQQskVu2O8AJmlkMDTphcMZ6+hqMgPeAzBvR1Fzv9dSGIiDZoKG9XFsSjsfYOyYtkpDUZf2UZvklJ
 7GIL9OQY
 sUSejbQ8QS7UZBhrHYm4OOZvIqWTyu5/bJlM8g2BMLMKzon6pngsEezh6VoF3cTamt1Y/SGiHLKc11w2ndxrdQw44cc3Dfn4bt8HpBLu9bo3ryH3zKQt6+L+Ve0HAp1nXz89UqYrRK4YPN2Bq0yJv0Cq55vMXI279PzNheKd3egx5lno0pQkICX09ojm9r5WUcbVvoYR+k7wqgRFR2m0zzsvFs91GcOBXR+QF+giSFyXN+PBDykJ+Nge0nhHV1ISemD+drNue+TErG4oQY/qC6n2913zoGiPZQLaV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 08:36:59PM +0300, Leon Romanovsky wrote:
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 09b99d52fd36..283058bcb5b1 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -387,6 +387,7 @@ enum req_flag_bits {
>  	__REQ_FS_PRIVATE,	/* for file system (submitter) use */
>  	__REQ_ATOMIC,		/* for atomic write operations */
>  	__REQ_P2PDMA,		/* contains P2P DMA pages */
> +	__REQ_MMIO,		/* contains MMIO memory */
>  	/*
>  	 * Command specific flags, keep last:
>  	 */
> @@ -420,6 +421,7 @@ enum req_flag_bits {
>  #define REQ_FS_PRIVATE	(__force blk_opf_t)(1ULL << __REQ_FS_PRIVATE)
>  #define REQ_ATOMIC	(__force blk_opf_t)(1ULL << __REQ_ATOMIC)
>  #define REQ_P2PDMA	(__force blk_opf_t)(1ULL << __REQ_P2PDMA)
> +#define REQ_MMIO	(__force blk_opf_t)(1ULL << __REQ_MMIO)

Now that my integrity metadata DMA series is staged, I don't think we
can use REQ flags like this because data and metadata may have different
mapping types. I think we should add a flags field to the dma_iova_state
instead.

