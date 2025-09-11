Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55102CAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 08:35:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB4126B000E; Thu, 11 Sep 2025 04:35:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A63E46B0010; Thu, 11 Sep 2025 04:35:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92BD06B0011; Thu, 11 Sep 2025 04:35:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7ABC96B000E
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 04:35:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2405BC0346
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:35:46 +0000 (UTC)
X-FDA: 83876311092.05.E7443A6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1D3611A0002
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:35:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="V/2pNPLX";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8wJXEdI7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="V/2pNPLX";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8wJXEdI7;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757579744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KZHXjktAiNRSWCsp7mRo7oXVASySHuSrY3xtvxgr0Oo=;
	b=cgSLFbAm5fVeGAb3byY6mjEpyZu/JCuhAp774XlvYln/NCKX30njdK1gxhNVgMRxPmKX6w
	axXgvyPu0S7iJ/TiFKFT+wgveGA0262+MCaIrVrYK0qvjTHQbOgtJUFmBPpUu8VE330Nab
	Rm7YlhM3Rs4qlg4g9ideWFPd+QiiHEE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="V/2pNPLX";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8wJXEdI7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="V/2pNPLX";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8wJXEdI7;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757579744; a=rsa-sha256;
	cv=none;
	b=V+oL/T6ifhCBdnJb8tmQPVWr8Nkm0NElkwXYMMB0PsqTW16g3W1XMWO3EyYnCV5skRYHT8
	s6ZtKlXql9mzuJ/XKScb25ONPVvAq5J6RSkAs3Y7JR0F0pgWLFiOFX5pMNupw32cIPwzuB
	6nNp3kZ+niROJZVU7lO68Z/L0nM4UNQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A4BA43F8BF;
	Thu, 11 Sep 2025 08:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757579741; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KZHXjktAiNRSWCsp7mRo7oXVASySHuSrY3xtvxgr0Oo=;
	b=V/2pNPLXjZxOAXOZsGDYJjc2AyKj4F+z+UmxbO0U71QzrlxliA1spl1IIsigxVlhuUNypU
	V+MwrG1Yfq34WpkYW+gGb73AoQEZkis/St+xrG74pfZnVJhJQupE485J/8vHlzsMWXBU2i
	e8t2YbSo3Vc4NHMqR5+gg1L1eA9ZgiM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757579741;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KZHXjktAiNRSWCsp7mRo7oXVASySHuSrY3xtvxgr0Oo=;
	b=8wJXEdI7KEwDUG4TdenbF0CZ7u9cEaytJTrnh2lXLZFebLh6NR+j81h2lyWMG5ZPD0huZZ
	exnc3+IjyrgjDqDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757579741; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KZHXjktAiNRSWCsp7mRo7oXVASySHuSrY3xtvxgr0Oo=;
	b=V/2pNPLXjZxOAXOZsGDYJjc2AyKj4F+z+UmxbO0U71QzrlxliA1spl1IIsigxVlhuUNypU
	V+MwrG1Yfq34WpkYW+gGb73AoQEZkis/St+xrG74pfZnVJhJQupE485J/8vHlzsMWXBU2i
	e8t2YbSo3Vc4NHMqR5+gg1L1eA9ZgiM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757579741;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KZHXjktAiNRSWCsp7mRo7oXVASySHuSrY3xtvxgr0Oo=;
	b=8wJXEdI7KEwDUG4TdenbF0CZ7u9cEaytJTrnh2lXLZFebLh6NR+j81h2lyWMG5ZPD0huZZ
	exnc3+IjyrgjDqDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 93F831372E;
	Thu, 11 Sep 2025 08:35:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1yYeJN2JwmhYcgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 11 Sep 2025 08:35:41 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 48964A0A2D; Thu, 11 Sep 2025 10:35:41 +0200 (CEST)
Date: Thu, 11 Sep 2025 10:35:41 +0200
From: Jan Kara <jack@suse.cz>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>, 
	Guo Ren <guoren@kernel.org>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, "David S . Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Nicolas Pitre <nico@fluxnic.net>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@redhat.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, 
	Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, 
	James Morse <james.morse@arm.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-csky@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, linux-mm@kvack.org, 
	ntfs3@lists.linux.dev, kexec@lists.infradead.org, kasan-dev@googlegroups.com, 
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v2 02/16] device/dax: update devdax to use mmap_prepare
Message-ID: <fpdlink5oiu7dbx35qayavv4lq2qjvruyplo2bomvu7lnsz62h@uwoawxkmywo7>
References: <cover.1757534913.git.lorenzo.stoakes@oracle.com>
 <12f96a872e9067fa678a37b8616d12b2c8d1cc10.1757534913.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12f96a872e9067fa678a37b8616d12b2c8d1cc10.1757534913.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Queue-Id: 1D3611A0002
X-Rspamd-Server: rspam05
X-Stat-Signature: ii493j3qz7bq7gma4th1y74max9zrrf4
X-Rspam-User: 
X-HE-Tag: 1757579743-329508
X-HE-Meta: U2FsdGVkX1+G8TSlI8qyc+x/OQLh8rcWZZJE8RdGVYcYvVi3N55ZY+klUn2IwIw5QjvMBNgaPsYWDj7DmDaa1AHYp7V7mKId2EFSVO0K8lfhG712VNyqGUsZ3KqrLoZ3emFaEp/qmqRe/nkpc95qHzrA1r2m954B6MSsp4aWTwhWzuSjdjzdTETDxDGAhQwHJSgeeeLHRfHAQsuUBktfWBMxRFbAbXIMzfcSElj3eniQGihcNolxEoTvl61422J/H6U9nQWI5l0Z13GKjt6sV+awqv4uC/XWz1lKh8c/DcjHkwUOkMttKbmKiSUdsjfuDYQrpXki4K0ESaFplwBT6Pn8NuCTk/Nn4WgnFtzWxJ0zS6DCF/4YsQI/JpmpxcMgLKmcxrg7Mp9LfXrpQQpFIURNINXFLBphWpcfvQLVVu/mJtTY0k+hffHsDmNWHhLe4R5CNf5TUDX0EcwYWaPqgJVn7aSBKksCgCO41Mo49zu1TezBih8E2eb8YdHGyoctrZEwdK76Js+fOTrglfK5nKHumtHHiojpm0HNXWI8mP9w9guIx2S0PiQuPQ00Pb6P7G1ywpbJXk+n2iI0mMPfqvHZfi16VlQKk7vfZ6o6/Q9ev+DWhYX2wleccbb4sZctF/O27JQMCwBaBeMNU5mW+cRKjlxRiwXKKuvEIrm5RMLLyijYPwKk11h3rv0K8tfxVD5q9/lAzN8/Gqz/kouPxgH/LHhWZXcvd2Rcy90P+52Hr23gSk7EoPmArH3eQOQBgzI5OChl13l2DTFg8vftuBvfHuJ4yiahaRjOn+KqT3HO+em8th2caUMhHDFSpPV8xW85Y9Ryv/6uQmqN6oDfawgVsn/O1qgtbBdEuaoHg9OFNjtT8O3W7ge2rl+AWvMTV9TrvHMGEraERbYnAU+KMrGM5qTIy2nlqp+OC2EXeSpUyGTAygDdtEXoA7Hex/uiO5FV4+PlVse4zYoBDax
 JYYKMaac
 zMCSYyPDKLMRHEa0MuE08jhMnA2ZMBkXXtTorhWSRC6e1VHc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 10-09-25 21:21:57, Lorenzo Stoakes wrote:
> The devdax driver does nothing special in its f_op->mmap hook, so
> straightforwardly update it to use the mmap_prepare hook instead.
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  drivers/dax/device.c | 32 +++++++++++++++++++++-----------
>  1 file changed, 21 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index 2bb40a6060af..c2181439f925 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -13,8 +13,9 @@
>  #include "dax-private.h"
>  #include "bus.h"
>  
> -static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
> -		const char *func)
> +static int __check_vma(struct dev_dax *dev_dax, vm_flags_t vm_flags,
> +		       unsigned long start, unsigned long end, struct file *file,
> +		       const char *func)
>  {
>  	struct device *dev = &dev_dax->dev;
>  	unsigned long mask;
> @@ -23,7 +24,7 @@ static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
>  		return -ENXIO;
>  
>  	/* prevent private mappings from being established */
> -	if ((vma->vm_flags & VM_MAYSHARE) != VM_MAYSHARE) {
> +	if ((vm_flags & VM_MAYSHARE) != VM_MAYSHARE) {
>  		dev_info_ratelimited(dev,
>  				"%s: %s: fail, attempted private mapping\n",
>  				current->comm, func);
> @@ -31,15 +32,15 @@ static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
>  	}
>  
>  	mask = dev_dax->align - 1;
> -	if (vma->vm_start & mask || vma->vm_end & mask) {
> +	if (start & mask || end & mask) {
>  		dev_info_ratelimited(dev,
>  				"%s: %s: fail, unaligned vma (%#lx - %#lx, %#lx)\n",
> -				current->comm, func, vma->vm_start, vma->vm_end,
> +				current->comm, func, start, end,
>  				mask);
>  		return -EINVAL;
>  	}
>  
> -	if (!vma_is_dax(vma)) {
> +	if (!file_is_dax(file)) {
>  		dev_info_ratelimited(dev,
>  				"%s: %s: fail, vma is not DAX capable\n",
>  				current->comm, func);
> @@ -49,6 +50,13 @@ static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
>  	return 0;
>  }
>  
> +static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
> +		     const char *func)
> +{
> +	return __check_vma(dev_dax, vma->vm_flags, vma->vm_start, vma->vm_end,
> +			   vma->vm_file, func);
> +}
> +
>  /* see "strong" declaration in tools/testing/nvdimm/dax-dev.c */
>  __weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
>  		unsigned long size)
> @@ -285,8 +293,9 @@ static const struct vm_operations_struct dax_vm_ops = {
>  	.pagesize = dev_dax_pagesize,
>  };
>  
> -static int dax_mmap(struct file *filp, struct vm_area_struct *vma)
> +static int dax_mmap_prepare(struct vm_area_desc *desc)
>  {
> +	struct file *filp = desc->file;
>  	struct dev_dax *dev_dax = filp->private_data;
>  	int rc, id;
>  
> @@ -297,13 +306,14 @@ static int dax_mmap(struct file *filp, struct vm_area_struct *vma)
>  	 * fault time.
>  	 */
>  	id = dax_read_lock();
> -	rc = check_vma(dev_dax, vma, __func__);
> +	rc = __check_vma(dev_dax, desc->vm_flags, desc->start, desc->end, filp,
> +			 __func__);
>  	dax_read_unlock(id);
>  	if (rc)
>  		return rc;
>  
> -	vma->vm_ops = &dax_vm_ops;
> -	vm_flags_set(vma, VM_HUGEPAGE);
> +	desc->vm_ops = &dax_vm_ops;
> +	desc->vm_flags |= VM_HUGEPAGE;
>  	return 0;
>  }
>  
> @@ -377,7 +387,7 @@ static const struct file_operations dax_fops = {
>  	.open = dax_open,
>  	.release = dax_release,
>  	.get_unmapped_area = dax_get_unmapped_area,
> -	.mmap = dax_mmap,
> +	.mmap_prepare = dax_mmap_prepare,
>  	.fop_flags = FOP_MMAP_SYNC,
>  };
>  
> -- 
> 2.51.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

