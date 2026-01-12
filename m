Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE127CF45AE
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 17:13:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24C9C6B0005; Mon, 12 Jan 2026 12:13:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FACC6B0088; Mon, 12 Jan 2026 12:13:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 106AB6B0089; Mon, 12 Jan 2026 12:13:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 005666B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:13:20 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AAD55BB61A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:13:20 +0000 (UTC)
X-FDA: 84323957760.12.F6A9BBE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3BC2A100006
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:13:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SXE+tFKS;
	spf=pass (imf05.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768237999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=3xsQVXLwfVFP6CfLeMcZiJ7ZZ/bIA3XEoOt0eQ9EwXU=;
	b=B3BwqON5npjNYs+bOTfEwkb0s3PgiY4da4H5pk7OZf7lfrNZlrmjODj9Ugsb9VICLM+yum
	8ULIJ3oePWsrdcYMN7b3AYtTFJLq47Gec61Bu5fwV0eQ4H0so8vrJbSVwPkOrXcCwSl7uh
	FjcAuSVu7Wc51sjoMYK+cPzCYxzqy/4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768237999; a=rsa-sha256;
	cv=none;
	b=bxmw242IcoBFpYvaPYkz08+VwuC7tlmqVfBA/1ZHedRZ1qFSIDxidwt3oR0tFsdzHbGM6l
	8/CnB69JeAwIpOmu4O5BYIGeeIidgLdgbpMjuuTN4wfM6kSHh2Zg8EQrt0UJ7gCKiBHhZo
	lud9GmX8pQO8rRbmlxntnWTW4SJxusI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SXE+tFKS;
	spf=pass (imf05.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C09E6000A;
	Mon, 12 Jan 2026 17:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144AEC116D0;
	Mon, 12 Jan 2026 17:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768237998;
	bh=CTVrya0benCYisxRFikm+e5pStHqutlTbypDz019q6s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=SXE+tFKSoL3IJzOL0ppAEPq1Yj7631M2XmO7QzgW1/gIIiFmnoWqfAPWfTBwwxbSM
	 bFp4XbZ9Tun1GbQSuiXmnO35eBQSDD8H1/1xu2uShPTnb8U6Lycln70OJTzwHJ5xb7
	 ZBZqpqy8ntCxqZUB5OrIBKYu0IqEdpxaOMPdTtfWHURIEP8JV0S/nIbkaCiEFVKl11
	 QQzyPFqigdgxEm9DJ/AOJpDmi9cwsGOvdW73h5Oe4dIpZBs6H3kgbxo9tEr957uUHV
	 vb+sz7up2888w2Wal0vkGLAhq3oTi2Lqy9fy8cq6vHZbiAhBq4bMaFzoTvqa+fJOkx
	 7eI9Byrbykzwg==
Date: Mon, 12 Jan 2026 11:13:16 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Alistair Popple <apopple@nvidia.com>
Cc: houtao@huaweicloud.com, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-mm@kvack.org,
	linux-nvme@lists.infradead.org, bhelgaas@google.com,
	logang@deltatee.com, leonro@nvidia.com, gregkh@linuxfoundation.org,
	tj@kernel.org, rafael@kernel.org, dakr@kernel.org,
	akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, kbusch@kernel.org, axboe@kernel.dk,
	hch@lst.de, sagi@grimberg.me, houtao1@huawei.com
Subject: Re: [PATCH] PCI/P2PDMA: Reset page reference count when page mapping
 fails
Message-ID: <20260112171316.GA716207@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112005440.998543-1-apopple@nvidia.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3BC2A100006
X-Rspam-User: 
X-Stat-Signature: yf8h7cd7dg7phaw4rsjih7dyb7imwwku
X-HE-Tag: 1768237999-491607
X-HE-Meta: U2FsdGVkX18nF7P45r1L9nt+pz1ZmXXyR91qZkZu0B/WLdg4HEVvsMeHAdTfzSbApOTwBXOPndHy2DXPSxOw6M939IGYSH6mPHoHSz0xxxWG6npGWl/JwFzRvDXBwnj9+8WtiP4DgxJ/wI0+75PoCQBhg1BTGrHnF8AGO3eFtgpXUPD17xGTOPssUOOUpiSVg6mrLTxoyE/Gj+FkWdq27huC7wn07luues4kpUHowonXxfyHDowTKHi7q1E62xfSvDwarOEf8DWpzx9GlxP0DHLJ0jMayy5EKJjDF9ozU/W2gTRXwWgeVxn7Vz1yU+BUHv5Wp+P0msrXj/bTO9jkXzFUkiNvHt9WSvmf/4XstsKy0d0gUL9sYMW38vHfXt+ZsCr7kt/uf/OK3FT7Hfm3MngRX4Kf7KCqzyLPsR19NHiiE9wJwZ2zWeqrMLF0NABPk5Hh4pStZ18bMOwllQZcsS9uhHEzQaI2ibHB/JepqbPPwqDT33wced6cYBrUGljjH58s1phuLZ5M/P8JnylxRRVLWv+5W4Z79cKVtYu3KXVL5GfOgYsIZ//G6lHG1oA40qhy74Mr8Otkl2HnVsF3UD1V1l2fMi2bz3v22RyE5taYhsZHTz5620asjlpTiTI6eZJA5PNwSkFjWxFh8xZ7YDgvUnsJiOAPSGUb3HCqc44qTtbTx1Qv8QuPzjS+wfxoOHyHTijAxl7j+4v1nBJUPOUVnw+DuKpyC4wARhdz6aBI6zNJhVvY6V2Qmd5m9JeipvPJE0DcDEsfRnZPT77kSqruzM4UKJrF3b1X/NRQO8aJiyPzWqJAcPIEWyV6OigNRYUeF2OigyWCxzcDBnH105yUl5P3L5CPVAc2CM0LDONRb61Il/At/RxIoq1jZvpahIbgCnItyCcTiqHs+UKtkRy+xJCiaVCLfyeeZYMXyHcEP7U43grB70ggOkSfqkX+FvMDDIT+0AfcWV8ZZww
 bF6O9UP+
 qfRyZwtX+5O4g0Ob2wYmsFCbqVaFlRKfSNDMXgmV6ZRLizVENRmkauI21qtjpUG6PzrFLIxOrXQdKDZfOArsD38lhs7liFeJ4+tNCBLagPBHCLYpR+2I/d5BWQRY5enMgbo/kFC7LY/OBwP1oxEd/WWPRf7ajsElHkZsKAjh4NK1hCDp7p8uY9g9Zlpx3imT3xlI8v+n9B220hY1gz2yoNMoh3fFyflCNaLqsAXCOYYWmhaAJ6TPH5VG++21xRZmnM0BaXy6FnobLoNi4Mt10vuHlSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 11:54:40AM +1100, Alistair Popple wrote:
> When mapping a p2pdma page the page reference count is initialised to
> 1 prior to calling vm_insert_page(). This is to avoid vm_insert_page()
> warning if the page refcount is zero. Prior to setting the page count
> there is a check to ensure the page is currently free (ie. has a zero
> reference count).
> 
> However vm_insert_page() can fail. In this case the pages are freed
> back to the genalloc pool, but that does not reset the page refcount.
> So a future allocation of the same page will see the elevated page
> refcount from the previous set_page_count() call triggering the
> VM_WARN_ON_ONCE_PAGE checking that the page is free.
> 
> Fix this by resetting the page refcount back to zero using
> set_page_count(). Note that put_page() is not used because that
> would result in freeing the page twice due to implicitly calling
> p2pdma_folio_free().
> 
> Fixes: b7e282378773 ("mm/mm_init: move p2pdma page refcount initialisation to p2pdma")
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Applied to pci/p2pdma for v6.20, thanks!

> ---
> 
> This was found by inspection. I don't currently have a good setup that
> exercises the p2pmem_alloc_mmap() path so this has only been compile
> tested - additional testing would be appreciated.
> ---
>  drivers/pci/p2pdma.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index dd64ec830fdd..3b29246b9e86 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -152,6 +152,12 @@ static int p2pmem_alloc_mmap(struct file *filp, struct kobject *kobj,
>  		ret = vm_insert_page(vma, vaddr, page);
>  		if (ret) {
>  			gen_pool_free(p2pdma->pool, (uintptr_t)kaddr, len);
> +
> +			/*
> +			 * Reset the page count. We don't use put_page() because
> +			 * we don't want to trigger the p2pdma_folio_free() path.
> +			 */
> +			set_page_count(page, 0);
>  			percpu_ref_put(ref);
>  			return ret;
>  		}
> -- 
> 2.51.0
> 

