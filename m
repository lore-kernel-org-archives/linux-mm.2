Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8755BCAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 19:37:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA63F8E0015; Tue,  9 Sep 2025 15:37:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A55E58E0001; Tue,  9 Sep 2025 15:37:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96B9A8E0015; Tue,  9 Sep 2025 15:37:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 787528E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:37:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 29793160725
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:37:56 +0000 (UTC)
X-FDA: 83870722152.17.0724C63
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 784891C0004
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:37:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BK33sGpV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757446674; a=rsa-sha256;
	cv=none;
	b=Av3PLPwXezyJkGBpdkucgd0Y/HJFJHzunvLmgT10d131B1DXFMGBAkTl0Te3zzihct8ZAY
	ExT9aJp6LWOqqoHQ1LH2sWn5qZcaswEs3cx/qKMGrLlmT9PhxQkthlyAXn8VpTk+GLdjvJ
	EUwnt4hnJgGFv8EZuuQ5sECV73wJocE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BK33sGpV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757446674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zMm2NBLKPbhkgjTIqBzOjplNw/nP7kHLNg99irSoOEk=;
	b=A1Z5ooYiYF6ao2H9txmujkiHVzbm68BvgCm5tupc3zPNl6baOYceMMKL48Y2AwUzHed68j
	ZBCDz5TIur0KNz9K8L/O/IyD+ef3WPusGEGEOGtA6GzNnjSCDlMhGKHhdag1UDtiSKmNt7
	Buij9rKWYTiO8yBCsDHIOzDloQL0Xy8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F194442F8;
	Tue,  9 Sep 2025 19:37:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BB1C4CEF4;
	Tue,  9 Sep 2025 19:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757446672;
	bh=Vkfs1C2Q/m2ciXngYEnMywKI/5g7jYuOYmYnMi4Z+6A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BK33sGpV6gJZdNQka35B5igzFncF6O4QoVJduYx5uymEwm19+Pae/Y8Ji2ztm6vFh
	 Of79hrgQzN752E6kK9Pd6CitdpQ05JM71b0yY2nJK5WUadz3JmWI4AqHd+rhRkpPML
	 jPSesTwS7Zw48bKNgh3AxJtfj3r28MMf09jWFv3Lide1Ok8C5lkasp0zoJfr6zuOnF
	 N5cxlSvTSt07fnYvpbKZtFqt6TP2eL80kCSBPIQL9mOveIT/STSyNFrSlP91N6uUF+
	 FdL0uwcDH/ATxbhiykxuiJP1XMjnnp4vhtxpR+0sRrU4PCEIaA22KI5S4HXWZpjWlB
	 smMV1bUYsFvcA==
Date: Tue, 9 Sep 2025 22:37:48 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	David Hildenbrand <david@redhat.com>, iommu@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>,
	Juergen Gross <jgross@suse.com>, kasan-dev@googlegroups.com,
	Keith Busch <kbusch@kernel.org>, linux-block@vger.kernel.org,
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
Subject: Re: [PATCH v6 03/16] dma-debug: refactor to use physical addresses
 for page mapping
Message-ID: <20250909193748.GG341237@unreal>
References: <cover.1757423202.git.leonro@nvidia.com>
 <56d1a6769b68dfcbf8b26a75a7329aeb8e3c3b6a.1757423202.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56d1a6769b68dfcbf8b26a75a7329aeb8e3c3b6a.1757423202.git.leonro@nvidia.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 784891C0004
X-Stat-Signature: maadjtureep61jxgz6diqwp7rtfdp34j
X-Rspam-User: 
X-HE-Tag: 1757446674-158666
X-HE-Meta: U2FsdGVkX1+7mLcSsROVh+fDFGvYVYY+B0/xttn72G8ypMj6IL5PiNNkxdPabYHQIed54jdeO4X//9EfUpGHuzelxAg+JHaqvwMF3M3/Oj7GFBo7omPt1Oyk29YjosYZETJ2yKiQ0jLewe+oBkB7q8tj81x7uOwpl4fTwo0pnvxupOgQSZ11swdvSMk7x18hGUb2ZBt0f5vts2liUG4nBhhpanLq8Be04xeFvA9lnRcnrzKEOdZAfhRavbG4oMJeYROO93c56ftHdaEzniG42QW9a822cw9mYlFtOmFUTVVPl7TxoqWiH2ReCILcVUdS1c7iPtEdODigfbafFubx66lW5LYq7jax7CoyTCnLSeLcUbLDmR6eF9MHcyvdcJb/To6V+p5wKEnpa+SkgZePgqdnFTrfY/kBB5yKViN/5cbq9x4dYTstnz07JHTA7iZn6QYEI1lWSnnE+ZbDigRX0MDqBkvXySl5tg4t633cf8V7bKsjOb+tr5O5pMC5attOblXqlv1QyU6j8X1LwMCx5wYAACvFdKJzCkrcXcEivNxhHzCnl4t6Y8gTDUVju/sM1yGsOWXFPhiiqs9MNxSE1YUGiG30tA06pYipzuj65vq1B1UxrKZHAjLKtJ3CoKHshsPs9vmHRl9FKTxDHKEYbpWBEq8mJ0uUgCBYrIARg1vdtd1WzR2hdIstVVy05ec4yKU5tcTJl9eRfUyBMbXXOjE/WvnEOFKCzAkzF6j+B84MGQ/Zn5MyRaaNFMgmnVMaa69EbJyP96C1miqYKNJ/jew5dz+vJ6bjzhvsBPf9VWVbsUoGQCpXQZO/PTGwGikUdU5oX/sTGtrGCtA/2PBK040M2va5G5dDFfxs5xVvpyhzp+cGxK62cgG5zFkqmlYtpKHAWr3GeDbfH5DxvxvhY+8eh0TAIVn9wyqAvQNqf4ObQndBPbOG/LAFJv2CgwEiVF1W+YZbE7vsnMjPB3y
 L/beTKq0
 FrqSDumyCqp4SeXGMQyjhpqxSKi3vyYT6KMRf2ZwuwhfcSVTDEbBSyNEnp23hWyuFBIhQcqXxcM/17cNc24s9eHXwsB3NkU1nFkJVCs9oVIedecyde1jrSIdmKfisX4q/xdfQEnd830Rzrw/wuQVVb2VKjMXMtdxZ4/gAhnK3lwt+7i60Y9ybC/j8vKKrQ1kmJyt86AvWnW9E+hE8reb9yoYWQCs3liaX3noGWr3N4Yw6o+6WcMYYLu5QdNoKStYEc716oStOg+D3oMfyUp+fKF+zRUHS0X6EJ1H4h9cf31vINQSAjmDyaHigIA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 04:27:31PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>

<...>

>  include/linux/page-flags.h         |  1 +

<...>

> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -614,6 +614,7 @@ FOLIO_FLAG(dropbehind, FOLIO_HEAD_PAGE)
>   * available at this point.
>   */
>  #define PageHighMem(__p) is_highmem_idx(page_zonenum(__p))
> +#define PhysHighMem(__p) (PageHighMem(phys_to_page(__p)))

This was a not so great idea to add PhysHighMem() because of "else"
below which unfolds to maze of macros and automatically generated
functions with "static inline int Page##uname ..." signature.

>  #define folio_test_highmem(__f)	is_highmem_idx(folio_zonenum(__f))
>  #else
>  PAGEFLAG_FALSE(HighMem, highmem)

Thanks

