Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C23B9CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 18:22:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 481A78E0059; Tue, 19 Aug 2025 14:22:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 431C48E0003; Tue, 19 Aug 2025 14:22:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 284D18E0059; Tue, 19 Aug 2025 14:22:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16A348E0003
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:22:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95EA916019F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:22:36 +0000 (UTC)
X-FDA: 83794327512.23.1CB38B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 047732000B
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:22:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="alN6/hwH";
	spf=pass (imf03.hostedemail.com: domain of kbusch@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kbusch@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755627755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rPawf4MAOK3K2lEjypEKyp/U3T0IFN68PxzTHE3J6/E=;
	b=i9pGGZpecLrsW1f8Kc4mpM0dbt7+VOe/jCJeCpn7tjpYm6Wk39+0C+HpCzszqiVIJ28pWu
	WRx456KVvG3fVxem14rgb4tjei2c/tfhNC7JzHuxJUUvNuIRMaR7VkZDCNxryJG70krm3A
	/8Dq9R4H19H8HHN3ZqQKQfyzKMgTzcY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="alN6/hwH";
	spf=pass (imf03.hostedemail.com: domain of kbusch@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kbusch@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755627755; a=rsa-sha256;
	cv=none;
	b=jraL+Y65FVXb2M3ck5ZP8+69pOzaQYHRNhaKGJkzZS/T3p0Lkp43h11yqpOFqSVf3rZqEj
	VkejjQf+TEBTfUze7xbZBJ/f8FWk+/KdvhYVeIZDA5gQ+Xw9QHeJ5FT6yXb/TU1XEk5VsP
	ZpkYILDr+qxKXxZLmGHE3E2t9LXiTUk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 594E960209;
	Tue, 19 Aug 2025 18:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8557CC4CEF1;
	Tue, 19 Aug 2025 18:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755627754;
	bh=VSqn6WSqLVd/XpfzgudXSJRo0uPOQ5wyv2bWmCBBnJg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=alN6/hwHpvzthoP/KrllDuyPfF9f8yAYQER8+ba4p7ZAaMRpwoXt8rvK6QE3L0ekl
	 bNm+CTndacGb+nR2BKXPNUnvE9okK+nJN6vWKLBypTEbMKpjdWZnobeyYbTdlJBwG3
	 eQhAlRfAJUiGmqIDHRjbObolLDa17Te4yFQpGASd/eKfIFxPevya5z3Kg7b9O2j2pW
	 xGJZckYIQxAQDMxUtnVFWJEEUia3gPTM6PRono+D9/zC602CQuuuu0N45uS/29jmmO
	 kxle5BpRno+jkLFSoQGxLhrpEA9gCkuIidPS0ZJ3bdNRJ1LR7RUOVZQkLijjuMZ2fZ
	 kFmTbvgXjx5hQ==
Date: Tue, 19 Aug 2025 12:22:30 -0600
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
Subject: Re: [PATCH v4 11/16] dma-mapping: export new dma_*map_phys()
 interface
Message-ID: <aKTA5i1IZquRBolf@kbusch-mbp>
References: <cover.1755624249.git.leon@kernel.org>
 <bb979e4620b3bdf2878e29b998d982185beefee0.1755624249.git.leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb979e4620b3bdf2878e29b998d982185beefee0.1755624249.git.leon@kernel.org>
X-Stat-Signature: sfqsiuwri7r54zb3egm881ixuijgcuie
X-Rspam-User: 
X-Rspamd-Queue-Id: 047732000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1755627754-937530
X-HE-Meta: U2FsdGVkX18H+rLYW8icQWOxQ6Fp2OC9R9S1+Ba9IXWDLcWe6/0c+mIY1umYPvyrV1MunzvmkxxLfmZreYkKMQ//56eKGYi+xnb/Akc9K6KylTAUCFGrSCWj0Mc0rnP49FRqI9g7WeFDpCaQ9LEn1P/LT8kwOd6U8kriJybU55o2FDN0AZRlLfgsAl/KqHIAbkKnT6EJxAkRdYpiwZUTjrlCxy+6N66ojvdNa+1KirAso/yeda1ZznQxWRFvuRkhq9ZTlMTJD6u5EbNgg9htEJzzZQAyMQTmHtd+uEOJxKUnbkMCc0vg6VtNRYByD1UlZsYbetZBX6QjkkOiigSLZaDHKT1SF9L2XlkT6m/ppu26JXyNwzHvVFcDCZ2/7nQFhockV0eUhWOiislW1migeyHTAwCseIMb7Cim/0FLllp5mQhMZTbDcJQwJmARZoBTui6M1UNednby490wASGDbLFGL7mW6StNj2A8RGEONnY0ed/p2wnX7IAkaiS6GhK0vDQ1oCfgWlNL2vzAB1+0alNLe4HLtOJQ8AjFI6T9++sRsAVIfZN9SFR7EFpg12OOfbO/8uzs3f5y008D9gM1nfjuZ6nw5UmnmSu8DaoM1s729GZhx+S7ekdH7qhHmoEjXI5Y11cunzbvw0+MNhEY9Ikai7BdF5v9ptxR73vQLPKpTwRzi0EUxB4DZWjrBFytZB7XIHsYUyYjWFUg4QNaqXSUMRM0z7jBZ/P8MQzf1f6J2qWOc7POnKaI2H9Jgvm4q6GdXGWbvKfUKvbTiXHNheP4JTF8H7+J1FBS5vIEl0ZbD4ACquh/kxh3FtbffGN0kysUTaIZACFrwOINKVMkYhN6N/+j99TfsEfhlaqm2B5brAqu4rS5QCv3p4agqXzn6mzOukxCBxqf7OfIQToszxhyZOnxfF8Kc5Hx8VgtiXMSVPuTfHKgrtTpzGScTDppTsfW9EH0kM/2K7v4liF
 JCh4OFpI
 Eji+mveuu1OocM/h9VJli99L7gXlbAihgJuZC4scDC51cp7ruMbOH9whPftrTdD7vnb+tIwduVLQymab0ZdVTh7HvhyuHNl5PGbYN4X4+pCfTCMEr6PSPpm/ZPuMjkGtyMbTXg0+tmNnTVsSRjtrJncVRHlr5GARisj24IcARWkKFtkU5smCDIyJQQutVuUKXo3i0lprEvBjU+VgTQgY7jvbdXKIae9BQ1Ju/okCVtkua+Db5blWYiLlvBCscgFx/S9xqirSIqGOhk8+qOZJWJ4QqyUF8FJ4lkOmLlXmN+JH5ebzjAi9aOaib6035XrrI2/U9E+pXogxkiBg1410PcmM4+ZQUceFMTHXlF3ia8iyZ/hBa9mjB1P8KpuUXhrssy99j/KBQWROhTD9lR1K9F5dxc8AkfyVkykl3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 08:36:55PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Introduce new DMA mapping functions dma_map_phys() and dma_unmap_phys()
> that operate directly on physical addresses instead of page+offset
> parameters. This provides a more efficient interface for drivers that
> already have physical addresses available.
> 
> The new functions are implemented as the primary mapping layer, with
> the existing dma_map_page_attrs()/dma_map_resource() and
> dma_unmap_page_attrs()/dma_unmap_resource() functions converted to simple
> wrappers around the phys-based implementations.
> 
> In case dma_map_page_attrs(), the struct page is converted to physical
> address with help of page_to_phys() function and dma_map_resource()
> provides physical address as is together with addition of DMA_ATTR_MMIO
> attribute.
> 
> The old page-based API is preserved in mapping.c to ensure that existing
> code won't be affected by changing EXPORT_SYMBOL to EXPORT_SYMBOL_GPL
> variant for dma_*map_phys().

Looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>

