Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F47DD1D47D
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 15:56:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69F1E6B0092; Thu,  8 Jan 2026 10:56:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64CBC6B0096; Thu,  8 Jan 2026 10:56:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54F906B0098; Thu,  8 Jan 2026 10:56:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 428886B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:56:03 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3220B6DDC
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:56:02 +0000 (UTC)
X-FDA: 84309247764.28.27F7F1A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 577EB160002
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:56:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=smTz0YN5;
	spf=pass (imf08.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767887761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=GL/JyBjUJmShYOyJwPO5n+a/X7IaKmCFq2H7t69Lepk=;
	b=p5knRaFBEwJrQ/YX50tQv/YtLLIgcVGQ2ZEfR1Seuj/bfHyCZea6Rg6tfXx/VahPzX1hHC
	i6zHXzgsabQY8BEnRKILZVQ/bp0K/imr9ofHd6puE4EQVEo9SWKFaVvIGZuY6J8ibngTUa
	h9eERS2ko9fr7zzjUMyQ0JfnEQz4QLg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=smTz0YN5;
	spf=pass (imf08.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767887761; a=rsa-sha256;
	cv=none;
	b=lI5TMXgVfbh4sQIF9uGgor+HX+UGu3AffuYNio0CvgZHmWevMX6LwFnFap1pnLd3i1j0Et
	qoVPbXCSZiUCkanRjf/+OusaXwEvSLcCwrRAXvqIBD+8cGNoyYcld86E0iZX3R7p9DWvLG
	8VTxwPdARq7Sc3Y8F6fs35b1O3Cr2ls=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D35EF60130;
	Thu,  8 Jan 2026 15:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DFD6C116C6;
	Thu,  8 Jan 2026 15:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767887760;
	bh=GfulWa/ARu4Yr8rPC67SODwYIn35P8iw0erhJXUkXcY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=smTz0YN5YLFmAlOwB/XE8lSG6WmMP9wwqSDofdB02oq65EsOYfnBlUklxTr+EgvDK
	 D8lBV6Neawx+hCoXcQ6EgI+F4Vv4Zrwc9mjuyRoN2D9iz15mp/8X/xXkIDpluV8Z1+
	 2w9Aq1d0cFAIHm7EvNx2GH1ulX6+5eXLtIUGYofhwcoOT947MRxroquuxMdN+9IewD
	 W929EV3dvo4vDZAvAU27sNCWOs2xaEra2+bel24JzUK8CDMgc77ZvAVp3//FojQ+v7
	 kOs71Vya+liqOAZf8HJg6nkTyKyr+a/U1QkBeLh3lRWlYEt1McXz1ecpnZeMxewfMx
	 W9fCRcqMSwgog==
Date: Thu, 8 Jan 2026 09:55:58 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Alistair Popple <apopple@nvidia.com>
Cc: Hou Tao <houtao@huaweicloud.com>, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-mm@kvack.org,
	linux-nvme@lists.infradead.org, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	houtao1@huawei.com
Subject: Re: [PATCH 01/13] PCI/P2PDMA: Release the per-cpu ref of pgmap when
 vm_insert_page() fails
Message-ID: <20260108155558.GA482755@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46lz5szq44vz3chzj6unh2sff4cfnpyvih7zty6fcnitzyrulu@6a2xdopoafxt>
X-Rspamd-Queue-Id: 577EB160002
X-Stat-Signature: 69ntm183qwjbi36y7dsfiyofzoh31bso
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1767887761-774773
X-HE-Meta: U2FsdGVkX18UH2YuiwBYk/iHbKKt8916dtJGsQnsVPK7PlaziiegwU6bdeBSgiaF7tm/uo2/gojKA2HUhyqiWe5/bHeSDuab+AxVbwxmyU+O/mEbIoClWzPrwSy+vfwAC5gbrEI6/chdd0MHUjJhmq4GGXQn4njXJ/itV5FyP13GUPDHkYY8GH7nw4oGfpNCey1U8/hzjMCBbmbPO1NLRhmWfZ01EbrIJWtYiy3ADCQh4NhOUmzE+5jY3/1A914kH63iYFDUjyCf9anmtLoZxP7SrU5+yvjBZPza237jm4A46mu/TzsGC6eErKR2GumP/PsmkwnmCZ63heelV4ucy9yLHAaXI+Eu0k9nIeM/iQyOJ2Mzb0mFp4Mija1rSoBI2nixV8TuwaKAaiwNkjKv8vwHalUKwBeP7N1FD2S5F+J9H6vjlGNxajIgSLP0vcj3GXDqfSRCmXbd+xbkWxaid5sY7+MN9AFc+5HBNucomAzVaB/vSkqnPXbPD1FNtTTmYu6TLHCvOZSC0CmK/KLfso/EVQ8Ob+/c22/Hp6e7Gym/Ujbpbj2jKoEZV8EAfWkW/YgHZMXZzCW+UXY/IzQaimXexut3BHsCI8BGcaK0iVfln9rOp3gcu2CJlHovnBXW8dkDkNggLCQVNCj3P+7N1p64lY/T03oViWBlCgNpQioBoxwvi+Q3m4sY9/LHMccWEADR0z1xx1jg5ZvpjWnUyrcV/8NjBjVg55d2K/TBxFhoC8F7oJWIFwZjUDv23ALp7WtzjZ2vHxFiD7M+JMgIY3vJ7doQs6Pv3dMPn8EMtgdF2Yey4YV32vWrjujPxBgDZoC+uoSqcVQXeBe62bAre7ujmmEC1OHKsPcToV0vLADNxaCawnADqdRpkjaRvaBiNxT5ChNCfvStQJtNTgXmNGpJZOroNgCgSM0P44I89Axy7yhNTQ41BaCKKauKoDyO7h4osqWEsiKkOxISoR3
 gS+EMGfh
 lHx5pARIhMwgeUr+F2u/PYYOyTXgYkph5ScGprfOpeSuzBld+b7+oSYyqAVpljNM0VySx8U6Sn8u1WDyaU6gI18yigXwtEh/t1YObZCeVY9uJAhnPmMyRvhhj9D4aSQ/oAva8dpHTawm00dSyqfE0kEAoyMyY1XazN3ABywW4pDm929Pz+267QjdDVCcDEKhK5zhQBFiHqtKtOhxmNa2RV3YeFAkdJsrjplNVo6X9HrjzNWAlgs0UGqK1unm5N2DVzC2FYwn5liwvVqviRbdUzSoi2DSL4nO7joPIEHiw4Ae243nFx8PJ/qtphGcSGw5xGmJZqscFTQZx/OrZg/+Dyeq5z5+nFpP+aPILsQUi5VI90Qt9IwCGn35ftQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 02:23:16PM +1100, Alistair Popple wrote:
> On 2025-12-20 at 15:04 +1100, Hou Tao <houtao@huaweicloud.com> wrote...
> > From: Hou Tao <houtao1@huawei.com>
> > 
> > When vm_insert_page() fails in p2pmem_alloc_mmap(), p2pmem_alloc_mmap()
> > doesn't invoke percpu_ref_put() to free the per-cpu ref of pgmap
> > acquired after gen_pool_alloc_owner(), and memunmap_pages() will hang
> > forever when trying to remove the PCIe device.
> > 
> > Fix it by adding the missed percpu_ref_put().
> 
> This pairs with the percpu_ref_tryget_live_rcu() above right? Might
> be worth mentioning that as a comment, but overall looks good to me
> so feel free to add:
> 
> Reviewed-by: Alistair Popple <apopple@nvidia.com>

Added your Reviewed-by, thanks!

Would the following commit log address your suggestion?

  When the vm_insert_page() in p2pmem_alloc_mmap() failed, we did not
  invoke percpu_ref_put() to free the per-CPU pgmap ref acquired by
  percpu_ref_tryget_live_rcu(), which meant that PCI device removal would
  hang forever in memunmap_pages().

  Fix it by adding the missed percpu_ref_put().

Looking at this again, I'm confused about why in the normal, non-error
case, we do the percpu_ref_tryget_live_rcu(ref), followed by another
percpu_ref_get(ref) for each page, followed by just a single
percpu_ref_put() at the exit.

So we do ref_get() "1 + number of pages" times but we only do a single
ref_put().  Is there a loop of ref_put() for each page elsewhere?

> > Fixes: 7e9c7ef83d78 ("PCI/P2PDMA: Allow userspace VMA allocations through sysfs")
> > Signed-off-by: Hou Tao <houtao1@huawei.com>
> > ---
> >  drivers/pci/p2pdma.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> > index 4a2fc7ab42c3..218c1f5252b6 100644
> > --- a/drivers/pci/p2pdma.c
> > +++ b/drivers/pci/p2pdma.c
> > @@ -152,6 +152,7 @@ static int p2pmem_alloc_mmap(struct file *filp, struct kobject *kobj,
> >  		ret = vm_insert_page(vma, vaddr, page);
> >  		if (ret) {
> >  			gen_pool_free(p2pdma->pool, (uintptr_t)kaddr, len);
> > +			percpu_ref_put(ref);
> >  			return ret;
> >  		}
> >  		percpu_ref_get(ref);
> > -- 
> > 2.29.2
> > 

