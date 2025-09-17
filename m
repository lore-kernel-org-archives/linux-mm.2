Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71A22CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 10:37:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA00D8E000D; Wed, 17 Sep 2025 06:37:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4E798E0001; Wed, 17 Sep 2025 06:37:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B161A8E000D; Wed, 17 Sep 2025 06:37:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B1798E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:37:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3306386CD3
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:37:25 +0000 (UTC)
X-FDA: 83898390450.27.1B2A639
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 04BE640004
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:37:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="kNJ/uzXV";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="lCKrd/3S";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="kNJ/uzXV";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="lCKrd/3S";
	spf=pass (imf17.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758105443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nZoP7xI9bh5cuZAC2MMMkkaHSM2qArN4UzTRm8GitpU=;
	b=jUuYWN+Zt/8pCFEjXSlGogPkc72mTdwc/uzxtFShVeZ5kyyfV2lo2W2hC+IKuGLXSlasWS
	JxePUgitcvi+4XhObOFAIJZkGwnblz5lzYW6cxTXgA2hPxzTJ0Puw0vRkF3oU7U5tLtlMz
	ceKVOKpGQTWEAibkcnecEPUx+TJw5wI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758105443; a=rsa-sha256;
	cv=none;
	b=SrzxakYhx/utpqISBh0phW5ZdBygs3E94O6KtMv4GQpUhCjSjbJB8aGjautBopvJpH0w8Z
	h12AYNh5it4pTtviAFIRVU1SqLuIzkN15zlgcREMrQLgM1LvSxzMR3tEm7b4HVFGx1cgao
	hTsZ6eKNSQJ8GDIH2urk48Y71apcOoU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="kNJ/uzXV";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="lCKrd/3S";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="kNJ/uzXV";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="lCKrd/3S";
	spf=pass (imf17.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5CAD71F7BC;
	Wed, 17 Sep 2025 10:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758105441; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nZoP7xI9bh5cuZAC2MMMkkaHSM2qArN4UzTRm8GitpU=;
	b=kNJ/uzXVRbTatfy05IVGNQLIzQ9yPArYK0Vuo18L+EvSl9LkJwvDxVTm6ipLRjopRYl37Q
	lmkvpfx9V6hiDWJ3AUH0fo1eVRtgsuz3WXVd+0UCwW7ZT7gSDrbreDLFTElddZkurFO0tw
	GBvYGseZhe+WcZcn66UCFBOvcVxQJvE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758105441;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nZoP7xI9bh5cuZAC2MMMkkaHSM2qArN4UzTRm8GitpU=;
	b=lCKrd/3SMkAsu71vkV/44IEKXQSRO5fArYajtSwRNnnRLyN7UEpS4+bqwddhUAybMv2xHJ
	mWtV6X5XQFK+a+CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758105441; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nZoP7xI9bh5cuZAC2MMMkkaHSM2qArN4UzTRm8GitpU=;
	b=kNJ/uzXVRbTatfy05IVGNQLIzQ9yPArYK0Vuo18L+EvSl9LkJwvDxVTm6ipLRjopRYl37Q
	lmkvpfx9V6hiDWJ3AUH0fo1eVRtgsuz3WXVd+0UCwW7ZT7gSDrbreDLFTElddZkurFO0tw
	GBvYGseZhe+WcZcn66UCFBOvcVxQJvE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758105441;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nZoP7xI9bh5cuZAC2MMMkkaHSM2qArN4UzTRm8GitpU=;
	b=lCKrd/3SMkAsu71vkV/44IEKXQSRO5fArYajtSwRNnnRLyN7UEpS4+bqwddhUAybMv2xHJ
	mWtV6X5XQFK+a+CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BE4BD1368D;
	Wed, 17 Sep 2025 10:37:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SZxDK12Pymj2OAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 17 Sep 2025 10:37:17 +0000
Date: Wed, 17 Sep 2025 11:37:07 +0100
From: Pedro Falcato <pfalcato@suse.de>
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
	Jann Horn <jannh@google.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-csky@vger.kernel.org, linux-mips@vger.kernel.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-mm@kvack.org, ntfs3@lists.linux.dev, 
	kexec@lists.infradead.org, kasan-dev@googlegroups.com, Jason Gunthorpe <jgg@nvidia.com>, 
	iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v3 02/13] device/dax: update devdax to use mmap_prepare
Message-ID: <2jvm2x7krh7bkt43goiufksuxntncu2hxx67jos3i7zwj63jhh@rw47665pa25y>
References: <cover.1758031792.git.lorenzo.stoakes@oracle.com>
 <bfd55a49b89ebbdf2266d77c1f8df9339a99b97a.1758031792.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfd55a49b89ebbdf2266d77c1f8df9339a99b97a.1758031792.git.lorenzo.stoakes@oracle.com>
X-Stat-Signature: 86zao3n64ykg7p4zt4r6883975idxpuq
X-Rspamd-Queue-Id: 04BE640004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758105442-590258
X-HE-Meta: U2FsdGVkX19SP5lIs3I1ydUwB7048qYUg6aUhSeqIVSxK7WFryIMbAGwjZBJxrMh0hxbdRoJGByXYSLwiciGtnFh4sJLswjO866jwm+9ZxdCiO7WrzUkJ+5il/bWfgkB9AMVYFNrqqrgBg1pjAd1DF3IpSVz6b2ptdSCcEWNWWv75LVSXrTQyQQFStw7FTYEItyhxK6iHaODSGGTIO1Bf9AFtHOu4nUgWKlX/4v8MW4c75Gu+hlPcnwA/RFycK92iOEMR0huVs+OKeXguUnlMQoNSs9tJxRn3oOslLAdfklDy9taEtAiVcp/JfLLO9fCtMxam1AVFg262eqBNNxP+qwBD3PkJjlsnICV2N/rNE3bJHQq6xcgiXKNc1dH7TRe5qJM8G+QHqkAyskokBrohHqk+F8YAWG6taMhad88IV5SCx0R3zpEHT6twLFJ9wOqQt3zPDVTSQnh3o4zzr2yz8qBYbuGegW5D6s9Sjv5v3xzM5yyiYFaDipORY+nvb7u2Bjt9j1TbMrSfRMgC8eDtYw2FayEPJ+bGpaMpdOAppstmAe3MXHOVTYEn8fUU1/QBLdVcyC/JOWhrfqA/AKe8LSNpF5SHKaZFlgch76sVy6nnKXS8/2kxmbAdONPJmvESerHEoMInhYsuYXFMShqd3HDcWekSNozl0lBVc4m4Azry89WEitlWDr2R/gxAn9BxDHBtHeKvgV6MvE6nnYODU28qq2IHgefwsrGSSG3wrZrnoFcX/a2E3uSsrWmnxu35Udmiuszx8oLTpU/BdhMg3t1ZphlvolAxKFmj7WQumrg540obY18ZuZR4WHXSjP0MaeyOifwpOHEzCgVdHtHw9XfCVYFGTQBxVjeoPTz7QOBOTSyq/sIrgCds9hhxbxQxhP3BryRHZ2G/18pLcUx43LxFpbbSZpYNdtWb0tcSrpT3bXDv+TyUtZ67bRTt6dIRBf0GsZzlbNO1kEtkdD
 rHcHW4C5
 1m6tcKUUuxcpcS/yVGqKBOv/omrFtPsS182jLDhaod+jomq7dd64pWF/AYo0i3OiC9r5b6YcvF6OLJxDc+J7ubgsY6kUg1DFSFwVQbNssNA38O6d9S1z2R914mSkFo8+8HRH2JOnFNGsG8ZvM+DwSa1HHndyvjxH/7iBoo65zhlmYDDdjL81/M+alM1RVnOwHt69Me5fR4T050UqlF+451fS3wpY5D+hIQbifqeEsXVZapZgKMFptttuxyhtKy0JCRPskbKoZHUssXq8kGiGrrS6hLKe9lpSQ7it2JpI5L/DyFI2mePQ1sYCy3uURkFCJNaobJ1ESMaqC9c3Rr2LpDZlZvxjL1Ok6ON+t1b355eYawgduUUF1+q3qsziRpifANQqV6XmUFwwjxd59KyD0TIj/vaTazMFEB/1NSixRqkBu2GMT5xjGC+DYog==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 03:11:48PM +0100, Lorenzo Stoakes wrote:
> The devdax driver does nothing special in its f_op->mmap hook, so
> straightforwardly update it to use the mmap_prepare hook instead.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Acked-by: Pedro Falcato <pfalcato@suse.de>

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

Side comment: I'm no DAX expert at all, but this check_vma() thing looks... smelly?
Besides the !dax_alive() check, I don't see the need to recheck vma limits at
every ->huge_fault() call. Even taking mremap() into account,
->get_unmapped_area() should Do The Right Thing, no?

-- 
Pedro

