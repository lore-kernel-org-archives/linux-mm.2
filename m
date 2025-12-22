Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B752FE67495
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 17:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC97B6B0088; Mon, 22 Dec 2025 12:10:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D76EF6B0089; Mon, 22 Dec 2025 12:10:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4EDB6B008A; Mon, 22 Dec 2025 12:10:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B37856B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 12:10:55 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 54B67137358
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 17:10:55 +0000 (UTC)
X-FDA: 84247746870.13.5670BE4
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4F753A000B
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 17:10:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=deltatee.com header.s=20200525 header.b="tRWsY5/s";
	spf=pass (imf15.hostedemail.com: domain of logang@deltatee.com designates 204.191.154.188 as permitted sender) smtp.mailfrom=logang@deltatee.com;
	dmarc=pass (policy=quarantine) header.from=deltatee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766423453; a=rsa-sha256;
	cv=none;
	b=ylC8ZYv/iDxnvI7k4xW5NKgrEkXR5/Vx2Z7aR+KvGkWtgYT0djSa/gNFfS+lTQXtWJdWyq
	ijOyM3wmmLDIkyn1k+EKoAt83dOeFCv+yxT/W8usBP3MQlFrySI5OyJR49FG40IcYYw5k5
	SuJH/F3TVl/03orVrZkWSODyAesfVEI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=deltatee.com header.s=20200525 header.b="tRWsY5/s";
	spf=pass (imf15.hostedemail.com: domain of logang@deltatee.com designates 204.191.154.188 as permitted sender) smtp.mailfrom=logang@deltatee.com;
	dmarc=pass (policy=quarantine) header.from=deltatee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766423453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rlyvxFeosUCTgS/NckPF7IGlpen8lONAZ5K7J2cadI0=;
	b=xkMVYVvVctrrVFsnEEw2Vh5hZ/l76KA/ccaJrVO4g8ELPxg7XFwJedI899XEM7P6ZKT32l
	2ut+eh6ULSdepOMGzLymw3do1k5YvxI+5Px7BLHyZDpTvf2jjGN59QO0KpK3XPHMjrdHqA
	mrigtIHQZCt/UjqLEpXD9/tEsmTOtvo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=rlyvxFeosUCTgS/NckPF7IGlpen8lONAZ5K7J2cadI0=; b=tRWsY5/sJc3LPeDw1XCCSz61w0
	BvWaboyhIaIEstf+FY+Pw3Mrt5ROwsjzprelE/Dbmh9BRCgZcjM9cRhrK2xDiKCWBtQWK5F/lzZkP
	PpNJy8D3qK5jOtsyf83j2b/46tSYE2IZtAb2YXy03L2FOOBYZuZTHLkFQ9P/e3jjabtrTcdFSKFS2
	6tbk1P8d+7aR874dnSz0hvwa3Pr8j0MJ/1UMfgGkU4Hep4RAWOBos1XCBpfcxtIjMFxDzRDQaYobq
	fYyVRqMJCkHhV1tUjPk9oLYItwU/iRUmJ6kI8a7h/oSA1jTsdui5AzoJ6T3PNXSVXYLTCvV3Wt/ZH
	rSeMv9vw==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1vXjQp-00000008K3A-3QRR;
	Mon, 22 Dec 2025 10:10:52 -0700
Message-ID: <33c4a321-0e5c-4090-be2c-4bfbee603f5a@deltatee.com>
Date: Mon, 22 Dec 2025 10:10:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Hou Tao <houtao@huaweicloud.com>, linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org, linux-mm@kvack.org,
 linux-nvme@lists.infradead.org, Bjorn Helgaas <bhelgaas@google.com>,
 Alistair Popple <apopple@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich
 <dakr@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Keith Busch
 <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 houtao1@huawei.com
References: <20251220040446.274991-1-houtao@huaweicloud.com>
 <20251220040446.274991-14-houtao@huaweicloud.com>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20251220040446.274991-14-houtao@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: houtao@huaweicloud.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-mm@kvack.org, linux-nvme@lists.infradead.org, bhelgaas@google.com, apopple@nvidia.com, leonro@nvidia.com, gregkh@linuxfoundation.org, tj@kernel.org, rafael@kernel.org, dakr@kernel.org, akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me, houtao1@huawei.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH 13/13] PCI/P2PDMA: enable compound page support for p2pdma
 memory
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F753A000B
X-Rspamd-Server: rspam04
X-Stat-Signature: gy4jqp9ydps3gdx6quauwkyn1e56oac4
X-HE-Tag: 1766423453-989781
X-HE-Meta: U2FsdGVkX18vy564m9dGKyLB2pL1cgerq1IgryKdmNSXsMqt1bWVBqL/kEFH39tvk6Kx7QsIpAMWWTotPtaroTan4cr7+00CuzPEzQzl799Mqyp6vwPifgPw9vNzW6zViatSTpmCogYfBHg68SIAPL87hgbdVHshjQ0NkW9RXk40ZSXEBAomm5JTZ2fofV9BkNvFznsRaX0mZNW2sulTGXGUAgs6wIfRF16ZTDOZgtClikyIGrjAGGKqM7rjkcSQ8r3k0+dvxDz3RuQYmBRy/RhLHnFYo64NcTTVfrOhd0RLGgPfWehZ9oTpdCugbz2gxKvv/99n5wXF7AORmrEAaEgQvfNETHPwd9RQug/t50MCZKgEGpPn2qDI3DFH+Teh7CUkaVcj4etA8CbTc9gMjibnROUFrHUUm8oW6sKZrCNH1/eu3vD1YkxELm99JNz/hBvKPWpImhT99KwwYCh1hcpV8TYddJQqg4AG71pYLQCTLGqRDzAF198B0bnPJfTs/LgSphl1W9fkqM6V+vls9HdtEDlJFJHJzb26WTRQ1p0qiua19P4vD7iQmuPPZuf+vthxLW7at5GJgxMkls4t4voZi4YRxSBpylE5J7G7GC3SwshjBI1n3j8ku9qBmbs15xpYpzzmBab8XZN6jEOrW55VBsFOEiKQyb6VDs9J7Oyah3ldoI9yAkSi01hk65KGVqzXm6FK7xMrF9YwQJAy/I44HJ/wWJ1nj2itYiMTz8hGShNlQg2JWF7OsJ4d3DoBiQYtrwBkesvPZlIPZpckIyFV63izjX7xHtn46QsxywET7vt3vYZA9e9vc72pWIU4gJTk2y/BPnhMnJWnxFk9pmEDhKALYXOB0pfC1q10UkgjpGmQZpqObLM31EgVYYQOvwoV9/iavPV4JFRKRSMRX3eTH3HH2TOQNt/xTCWI2Cm6GacbljFZLgsSH3GjZReAjN81O8Wn5OrOStU4udj
 URw6ymb4
 YPBjnlPh+8y8Zf7E+Cvfli1a/Wrj9p/1wO36vVTvUhatOsepgCuK6TXFUGX3Wu745h4+Npv4zG2nQeZjRvKsYlQ3r7wHDtRVF1Y2494ZGSiomWV0VJSekoeDMmmdrCvQ03j4BZ5eX+3SxGXEpr5JnKLfwithl4CDTFuGaC6i6c06SNKGVymlpHc9sQwdiMo5bamArDgoW4vI8MUr5TZ59L1C3guui26NSi7sJHHqVCgNMG0tMrvD3Ig7EUXQEgr+2I+W3TZPFRX7jKCMterAY1UFcO0maiyEAp7SKS32UormRuUKpWQi9smCpVZd0K3Thxs5B1XZj1kH+eGw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025-12-19 21:04, Hou Tao wrote:
> From: Hou Tao <houtao1@huawei.com>
> 
> Compound page support for P2PDMA memory in both kernel and user space is
> now in place. Enable it by allowing PUD_SIZE and PMD_SIZE alignment.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>  drivers/pci/p2pdma.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index 4a133219ac43..969bdacdcf8b 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -452,9 +452,19 @@ static inline int pci_p2pdma_check_pagemap_align(struct pci_dev *pdev, int bar,
>  						 u64 size, size_t align,
>  						 u64 offset)
>  {
> +	if (has_transparent_pud_hugepage() && align == PUD_SIZE)
> +		goto more_check;
> +	if (has_transparent_hugepage() && align == PMD_SIZE)
> +		goto more_check;
>  	if (align == PAGE_SIZE)
>  		return 0;
>  	return -EINVAL;
> +
> +more_check:
> +	if (IS_ALIGNED(pci_resource_start(pdev, bar), align) &&
> +	    IS_ALIGNED(size, align) && IS_ALIGNED(offset, align))
> +		return 0;
> +	return -EINVAL;
>  }

Again this seems strange. It's a bit unlikely to have a large BAR that
wouldn't be well aligned, but this change is now requiring all P2P
memory to be aligned to 1GB if the CPU supports PUDs. So if a particular
device only has a small (say 256MB) imperfectly aligned bar it may now
fail to be registered.

I don't think the alignment should be a property of the device. When a
mapping is created, if everything is aligned appropriately, and there is
enough free aligned P2PDMA memory, then it should map a full PUD page.
There shouldn't be other restrictions placed on the hardware to make
this work.

Logan

