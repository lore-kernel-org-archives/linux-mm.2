Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2799ACA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:37:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4F359001B4; Thu, 14 Aug 2025 13:37:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B26A2900172; Thu, 14 Aug 2025 13:37:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A63B09001B4; Thu, 14 Aug 2025 13:37:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 942DC900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:37:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 37885140715
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:37:41 +0000 (UTC)
X-FDA: 83776070322.10.78E7010
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id 27FFA140003
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:37:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="4KLyFDU/"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755193059; a=rsa-sha256;
	cv=none;
	b=VTK9EGmbuf9hWSB4u0wRM4JULCekKvpaXd+jBPKvBtfAxtN14c3FmDwyMmsWWSwNd32yoq
	FoCLoKDPEEuIvaxxqOJUT9J150oRkIWzSsFxEgVqgWEgFirUzf3K//WQfIVhNKcgDfXjxB
	SpbCyu6kq5ZSG2fUzhsk6zwUpWXYyWE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="4KLyFDU/";
	dmarc=none;
	spf=none (imf09.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755193059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OE4LAchkYGbRbWIAPtKdq4yp8AV8hBrJ1qdnR14GXT4=;
	b=MZ5S7UYI05KqWBNyai8qY+UIpBOgFj/kw6ECpPP4TA/BxzeEak/H3yqe/VpAQDsYHAd2gt
	/7c6gO1SAeLOn+XSo6c6e30mW92x3IBW7ApDnnZYguLt2w3+W//tHxJjnZ7WyFB3fF205R
	XfUiW8fNkFeaLsrgaPg/HCRwRnHVNWA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=OE4LAchkYGbRbWIAPtKdq4yp8AV8hBrJ1qdnR14GXT4=; b=4KLyFDU/Vumsz96izTNEFh1dPT
	gcELlCyTppY1dhYETNtbcxbOIeh1/sthMu9DbTeiVaAcP7tcEuyIkykR+tjpcFgzaiM4l5e7zW/99
	WT21f95NU5V6ne9427BqfukuNCmE4P8LKLVbcXGI3NVbyx+CI0xucaJY3VBJ0r3B7kFJXEhhBYBCH
	rRABtXI9ZkOcgZvf82D6jL0f5HF0S2ekt30gXEkdZuKsfcL0Px0gARfb1GdZ7N6PG/l3W5OuzmpWz
	GxsIWFejW3a3LSYz1Mfw2PcJDMlTUQWwRae7vRCeE50nJNZOOiGyqf3SNV1eNn7Mpy146jdENj5EG
	0OjLyf7Q==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1umbtD-00000000E9n-3MTt;
	Thu, 14 Aug 2025 17:37:23 +0000
Message-ID: <c855a4f9-4a50-4e02-9ac6-372abe7da730@infradead.org>
Date: Thu, 14 Aug 2025 10:37:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/16] dma-mapping: introduce new DMA attribute to
 indicate MMIO memory
To: Leon Romanovsky <leon@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Leon Romanovsky <leonro@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Abdiel Janulgue <abdiel.janulgue@gmail.com>,
 Alexander Potapenko <glider@google.com>, Alex Gaynor
 <alex.gaynor@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
 Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
 iommu@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
 Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
 Jonathan Corbet <corbet@lwn.net>, Juergen Gross <jgross@suse.com>,
 kasan-dev@googlegroups.com, Keith Busch <kbusch@kernel.org>,
 linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-nvme@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 linux-trace-kernel@vger.kernel.org, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>, "Michael S. Tsirkin"
 <mst@redhat.com>, Miguel Ojeda <ojeda@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
 Sagi Grimberg <sagi@grimberg.me>, Stefano Stabellini
 <sstabellini@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
 xen-devel@lists.xenproject.org
References: <cover.1755153054.git.leon@kernel.org>
 <f832644c76e13de504ecf03450fd5d125f72f4c6.1755153054.git.leon@kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <f832644c76e13de504ecf03450fd5d125f72f4c6.1755153054.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 27FFA140003
X-Stat-Signature: ee6mu7i1i8kpfne47nxs44igit38ps6r
X-HE-Tag: 1755193058-372185
X-HE-Meta: U2FsdGVkX1+V531zACqntGFHYPsuIHf94DBg3LM4B4Wir9IQNJEngduK2touKFGKFg9b05V/ud9Fcnip2TvqPIstcuRQuG5ozh/Vdt9uBGGH+F3SOw6SZdEEBixLx1B3Hrvc3v6Da7rN7fxcMx5a1GSG4TFnV9IN6LaCus1C2xRFpSshkRhm8MGBimU+hj99kGj8Qnhs2DC1HfLqw0mf3dBDNZ2XvBXr7TIrxfZjcbXlQVp7q7GpcyAXufNrlE+TlaVXg5uq9sNCt8J8wFFbQ3r2nIfzLgNwqZq4ml9TrZVDhWy1ICoYuN4tSp1iAchoZ9kr+UV9CeBPji8jZ17tBjUYCa+JhfxeZPnX3UM2F8tD0QpPpi0oETfFAPq4L9KhA6dnazFyqrih2a1LwMhFBoC8VQiQzbJCfzlIuzqk+1bT9Go3751ZaYxplgDkOlGn44tGlS+9ko01qpN13VCE0UPT+E4i9cMD5BlucdLyU8OPYzGzUemVWORyjBq1aVeSE36/4avgSdrIAbg2zH7uFHSWzDEyvTlkRdnRVThwytNl1RmyRteWVz1mJdjmE7O8Q876ZYlNkf8mubFRFt88GxsIoRd8ooc7SnhPJZg3aa9abVOZgt3VNKez0F+YFIuFxsPt9gOlYJiIwW5T+LoOPKP1Ll+TQruYqUlRAnB/PuRUBH2NZPzqxecTreUZVUl2g7sDT0X/RIdpukxerSJR3xGv+kPd1huYUJ/m5eOiloYR4GaGR74DOACJ6Wu9ug9Bng8PLDyCWKXoEdC+0tbAl8NBKhjPNvStfR3NT13EZSHnFITiNvIKU9/6G11W6j4S2OpYTaEqQ+DeTrTOBWahm4sVgpb6iHQupXcPn6n+Tt+zeJXNIvdZUyw1SFktOTOahTyXIoTHHXQXFlnqZgI+q9Vp4m6A3eB0j4WpePSoSRab8n0rRjv57u4aCjrM5TXl/Sp6rj5mrHWIRYE9rpX
 zag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Leon,

On 8/14/25 3:13 AM, Leon Romanovsky wrote:
> diff --git a/Documentation/core-api/dma-attributes.rst b/Documentation/core-api/dma-attributes.rst
> index 1887d92e8e92..58a1528a9bb9 100644
> --- a/Documentation/core-api/dma-attributes.rst
> +++ b/Documentation/core-api/dma-attributes.rst
> @@ -130,3 +130,21 @@ accesses to DMA buffers in both privileged "supervisor" and unprivileged
>  subsystem that the buffer is fully accessible at the elevated privilege
>  level (and ideally inaccessible or at least read-only at the
>  lesser-privileged levels).
> +
> +DMA_ATTR_MMIO
> +-------------
> +
> +This attribute indicates the physical address is not normal system
> +memory. It may not be used with kmap*()/phys_to_virt()/phys_to_page()
> +functions, it may not be cachable, and access using CPU load/store

Usually "cacheable" (git grep -w cacheable counts 1042 hits vs.
55 hits for "cachable"). And the $internet agrees.

> +instructions may not be allowed.
> +
> +Usually this will be used to describe MMIO addresses, or other non

non-cacheable

> +cachable register addresses. When DMA mapping this sort of address we

> +call the operation Peer to Peer as a one device is DMA'ing to another
> +device. For PCI devices the p2pdma APIs must be used to determine if
> +DMA_ATTR_MMIO is appropriate.
> +
> +For architectures that require cache flushing for DMA coherence
> +DMA_ATTR_MMIO will not perform any cache flushing. The address
> +provided must never be mapped cachable into the CPU.
again.

thanks.
-- 
~Randy


