Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B69FD0D171
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 20:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D0826B0098; Wed,  7 Jan 2026 15:34:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 754786B0099; Wed,  7 Jan 2026 15:34:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 660F06B009B; Wed,  7 Jan 2026 15:34:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 52F896B0098
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:34:44 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EF3888BD30
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:34:43 +0000 (UTC)
X-FDA: 84306321246.04.32FA98D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4FD85180006
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:34:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Zkagjpi/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767818082; a=rsa-sha256;
	cv=none;
	b=Bsloyxa8IqujtquE7zHwE+XjbZtU86e8wEEdR+cFS8LVSfjyR1TvFos7pEbjvI8w0eahbJ
	8LMpbCns6QT5S+3un3b9lEbjhY1oqy1OeMt1Dl24bqUXcSZtcprQptTWIYT0uyAuGC+1d/
	9nCBDY4sircPkbE2bzjW4t/m1YaSRp8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Zkagjpi/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767818082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=zzo+3C/hPTxFw/xRNJRkyrKmK7xeVFmoq79bpzpX3Ls=;
	b=nY1sFmhh29B4clmRUu/kx8RLcgCgEU6vaQFVwWLWikEugT4EtLExbplSgjgFhaEXkq5qDk
	U8rsMQZczYqO7poQ9Bbx3jRI44A/vKVYPY6T9inW12yWhrkJNTsTOI6I+I2V9GBU3oEc4H
	wOGtxae1IbZxkyRpfbGbEWCSexXhrkU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 091944414B;
	Wed,  7 Jan 2026 20:34:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76CFC4CEF1;
	Wed,  7 Jan 2026 20:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767818080;
	bh=AOWaSug2G86K93bzxMiGRrg2OWHdAUJfYh0qmRde9cw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=Zkagjpi/muS2VGzfUQjIxWGGH6i70N++9x5xZTIbkQuBU/DRrQKhH+4pJNASzSy7j
	 VZVMqRapNWwBVu4ByYANDdpu5Sr1knnVuTrRyvvD9WvCdJEJGw7K64bSO0hKmfhQqY
	 OThU+sNzp56YiPAIE2t6FI8X1MJjVuPhzRzGd7emskjfYVBBhV532eSF+mtSAlV4PM
	 /Bk4PfbiIBZ6xke04u2/c0EbrakDa/8EflVBSSO3zKX1nL5AtFS09ovFmx7BrgOCgU
	 tmdVAzw0ELBLL1dewvzFHL5enSxqyAR/O6JMjvEonF6tFvrO5qIZ2ZFH4+K24yXrjT
	 cQqiR/XDuYSbQ==
Date: Wed, 7 Jan 2026 14:34:39 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Logan Gunthorpe <logang@deltatee.com>, Hou Tao <houtao@huaweicloud.com>,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-mm@kvack.org, linux-nvme@lists.infradead.org,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alistair Popple <apopple@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Sagi Grimberg <sagi@grimberg.me>, houtao1@huawei.com
Subject: Re: [PATCH 02/13] PCI/P2PDMA: Fix the warning condition in
 p2pmem_alloc_mmap()
Message-ID: <20260107203439.GA446340@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107171724.GA432074@bhelgaas>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4FD85180006
X-Stat-Signature: r8zkb8ba95ucmngsfwjuzibe7etepk6j
X-HE-Tag: 1767818082-364926
X-HE-Meta: U2FsdGVkX1/HopoYaOME4hDINAYbTYydoWTh7IJdyG+4BsrSJqMuMVrmNl7Ux04nitd3Gx9Sg8baGI+//YfMWB7+QplFsfTf5hAWxnrlqfMxV/G7goeaialDGvRBGXW0DNAH6OqgZY2dz66z9WgXpXAEiNVh5pfIafdj+gGrokyQx8ZRXExMGSTmYsXlM2g3kbomSmUOP+D3PJeOEntFiu3PcZUr/T95Pj7oFqjrCXlxlIwRhOUB4/4H8YG3cAk2iHVJ9Xe/oIhSpaax+0CdkyTTyP1atjrNJkDk9XQCGEEI9erAQJ6IFZrDmT4MxkFq5r+0Vo8Yz7zJQMyG/iX+h29E/z+J71gfl1UB1hClGaRJhkk6EUC9xPLrS5nEEcMlWCHiYrgvy9uEFt3fG+CbJZOuPTpE0CPnzFrae30uMVRJ7s3ewcjRzC01G+V0XvE3PpYJnikF97dpZGDF4CPv9QkPkJRyu5O6IJIJmE0Dph2uPk4QIT9yhhPZHiwLbBNKve+lBRIVzWBEn/ZmzdtFZoKGABuqXdA+XNQ9gkWCh661EclGg1Ah0cD/UNjGi/HhgKfAem6aHclJXpRNclIy+nqiT+5nHmIlMfTYDd9MpFnGUNrF0jP5guTBujhlp4aPumv2gHPFq7CAUXPCLe7P6l6dt/pKRl1T37sKoLR3Aaga7x+/PtuMvZiZPZCF06t9SlcfvaSKfyM4/5ikKEziadC7aY6L7ZG5U8TIaPpykc17T9w0epaEfnxsDYgGboIOVQrFbCeDSt94qtpEEYyhSBj3KYXjzK6aIVBqNU6k49xjvmLCBTaXu3GZckuw/Gd4NTCO33TVqyYQoOE+UJhtBISKdkve0kiWniPTa6s8SPlOpSLsHEVEZ+qm/fHbDnxWwCGVc+j9zpFkXYRI4OMZwhuqKMoGfTfyB22Xcsf6QIe8UCEBWHpU70v3UWOcmE67Xd6ja3yFpoX3tSuCLOA
 U9ECNlBy
 fEWyDOpSmX+y7ARKvE8hSCFxalZ3z9BM0ZrZEUx6wCAHx9Kr859+Lq66EOkx7tGCLPQvqxNbSzo9vCRiafKH262xLLNrErUDrxDuOiZ43JHhEcqb0cF8DN4bMatBHe4RbS58Eam4tZ94y/JLt5S2GbZD/j7BMcvp0XOGYWrHaL+WTGRqrEkfvoq2IRmGHoFlri5q3uXsdVGlECz/Hm4DD38G66jbtGPZKDAhhMcdG0E0LHaDsdxwutwahmqDVIzPXtZoLIOKgmT6gNKqS+ldZs5JxSnIS6FUBBswo0zvloys35vj8NYqtOjgYuaGAo806ggbiOHn+PRYuBdVTF68Z7jjaWDd0CO3wchnj1vxesERQjrteO0v328XpbE0xpbKnFxa2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 11:17:24AM -0600, Bjorn Helgaas wrote:
> On Wed, Jan 07, 2026 at 03:39:42PM +0100, Christoph Hellwig wrote:
> > On Mon, Dec 22, 2025 at 09:50:18AM -0700, Logan Gunthorpe wrote:
> > > > Fixes: b7e282378773 ("mm/mm_init: move p2pdma page refcount initialisation to p2pdma")
> > > > Signed-off-by: Hou Tao <houtao1@huawei.com>
> > > 
> > > Thanks for the fix
> > > 
> > > Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> > 
> > Can we get these fixes queued up ASAP while discussing the new
> > feature?
> 
> I assume you mean the first two patches:
> 
>   PCI/P2PDMA: Release the per-cpu ref of pgmap when vm_insert_page() fails
>   PCI/P2PDMA: Fix the warning condition in p2pmem_alloc_mmap()
> 
> I can certainly queue these up.  The second is a warning fix, and the
> first fixes a hang that has apparently been around since v6.2
> (7e9c7ef83d78 ("PCI/P2PDMA: Allow userspace VMA allocations through
> sysfs")).
> 
> Given that, I would ordinarily target the v6.20 merge window, but the
> "ASAP" suggests more urgency.  Do you want one or both for v6.19?

I put the patches above on pci/p2pdma for v6.20 until I hear
otherwise.

Bjorn

