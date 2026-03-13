Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4401E105F791
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 10:19:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 686866B0005; Fri, 13 Mar 2026 06:19:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 633A66B0088; Fri, 13 Mar 2026 06:19:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53FA16B0089; Fri, 13 Mar 2026 06:19:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 400F76B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 06:19:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C1BC2C2C49
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 10:18:59 +0000 (UTC)
X-FDA: 84540641598.20.9EA2813
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf28.hostedemail.com (Postfix) with ESMTP id C46F3C0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 10:18:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=E8PFd7gc;
	spf=pass (imf28.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773397138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e7VmSIl4unW6O204RkOQM4M3cIx7ucOnD1dcxwQUtH4=;
	b=mFu34Yx1Yx5c8BzzYhxwI7G5jkXN0OTAB5amPi6foGopD2rZ4iULfdZSilTGY/IEWBmPXV
	9In62UyUlu8KCydyOyoroxmzOHlL3oSJYOI8rXNNLfksFY17TEOrs6xvjqyap1VnnP96gR
	Yrjy4HkKcwHQOyn7Iwnrb83RVXpx33I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773397138; a=rsa-sha256;
	cv=none;
	b=OB7nJZR5Fhjl1/5KpLuc6iEFsE43rfaQzYSvw4lghsze4lNNnxQ3bvz4CxPOuQEl8fOFIn
	t5sHcmYzeeAP90PSNIIZ45WLldLaWpMmGDSRg4VNg1Fjpk6cDxHGUOblTWISzKQXN+VhmD
	i88GK+YBUPxXxe7a1pYRsG96yvEYM34=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=E8PFd7gc;
	spf=pass (imf28.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1773397134;
	bh=M7TdXX9zTPqW7Kt9Iztm/Jip/BQuxT6Rf8Ea4mHYUpw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=E8PFd7gcTn3pjinCydHkNJg1x+9DSN7Uu7EUkgHwkfV+HxhP8ufe+4Yk22FS9ol6S
	 dQTDzE/ltrQmTkdPOF617T1gvNd3grMTjwimcjIrhzBxGzz8gqiH/ZmtmFoj5q3zy3
	 6uVHECECgLnCvUwY6uXK12VFeYjJeyvJ08HdSvkAgBYyhwTitEVdWc7i7TRAVW052a
	 W8nWMhOHccxGe1kVbzy6NxCX3U0g8MgJmdOrm1U16mXAw68HJpJ4oplsRJNs31Ea9o
	 t/V/bDHV5QW92CVb10jIHNygLntuHDZVvtU7vet9H2HJ1RWuf+5yk0sUoMCBWk2h1m
	 yM3s7ZaDTRxnw==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 3B04517E0222;
	Fri, 13 Mar 2026 11:18:54 +0100 (CET)
Date: Fri, 13 Mar 2026 11:18:51 +0100
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Biju Das <biju.das.jz@bp.renesas.com>
Cc: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>, Thomas Zimmermann
 <tzimmermann@suse.de>, "loic.molinari@collabora.com"
 <loic.molinari@collabora.com>, "willy@infradead.org" <willy@infradead.org>,
 "frank.binns@imgtec.com" <frank.binns@imgtec.com>, "matt.coster@imgtec.com"
 <matt.coster@imgtec.com>, "maarten.lankhorst@linux.intel.com"
 <maarten.lankhorst@linux.intel.com>, "mripard@kernel.org"
 <mripard@kernel.org>, "airlied@gmail.com" <airlied@gmail.com>,
 "simona@ffwll.ch" <simona@ffwll.ch>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>, "dri-devel@lists.freedesktop.org"
 <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty status
 in mmap
Message-ID: <20260313111851.4c1f89f3@fedora>
In-Reply-To: <TY3PR01MB113461ACB668738E1952EC8898645A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
References: <20260227114509.165572-1-tzimmermann@suse.de>
	<20260227114509.165572-6-tzimmermann@suse.de>
	<abL5rcYIaFFO3GW2@tom-desktop>
	<TY3PR01MB113460CA616D3576DA0C3FC698644A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
	<TY3PR01MB113461ACB668738E1952EC8898645A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4xt97iuwozwwybexiz59hx1zm1krxb55
X-Rspam-User: 
X-Rspamd-Queue-Id: C46F3C0005
X-Rspamd-Server: rspam12
X-HE-Tag: 1773397137-16792
X-HE-Meta: U2FsdGVkX18eHDcRfOyb2TOyURkD4rsSXJHTh9q5R9CfT5NXfeKU7fbRJNYASqbhEH324kRXiGwM3W6TBHleoC9c6X7gYlcpOyqvuM3AAgcSTwKWS6eJDbpJrGFcLAj8xV9njqCWI0tveSzKedw7CyA3FzK2nkHU4Rz4mvjOfjxAbwNNdMelPepD+caSRyz86gNfCqsv0RBFbFOobx/8ZaWACNbTieRkf3tqJm6t3Zt9EsGzsXFcx/Y5PNfGPssGxzsSFTST6f5yFSiUEIvyEeB27oqkqxuzY0/KK3ZrzJTazNNmGwj/pcW2bkH+fR58c5LwZ518gMZGHwhsJ+ElwX+aRoWRLEHe2bwFXf8IHP7+b88fWLVMzJobfMu4mMDU+Z0KPVo5QdmmjRYGwPvJ/j3ayAcqGR9WNJZLfI6KtGwAe3670JX798xhTVmCnnnauG5ahlCIn487OQpdwPWng+121HmFBEHAPJ8wTjsYXGSZuvn5iVdDw01RpVjn7Q29JDDHRhnh877tm/Sausctu4kYoaPFvmS5uz+mdzXSyXUIgBy8DJqLHyH/vohsRkzEoeXT6sgKlydNeeMZlw402V2nGyYdBGXXIssCzI/hdW3xu1PeTPolRy3MAxrAr93L5TWZfhkbhUF59KWe3ZvnJW094jum6PxX01mczxExe6MIxXiSOixjppTlyGvRwLjMBcdHTGmJQ7zIreIQ+1iKdo9VaW4rmQtpBDf3RpPv3NAtvFYFGn0g3V0Sqsh2rFh2aQ/mOKK2yKAIkZa2Ib3DEXwKwI66Fgyh+F6zPsEn62YAFYaUrD5zyXyP/D0S55jMnJPFoyNlGBQLh6Uoe8/3iU+jUO6fz56Ip2qGCAsNHXYXBpQpUbeDH6f1NXDi/685OU/eLL2RbwBv771eLJTSp07TlTPelqkxuOHQdaGpCq1AvJ+ks6JBOhcmpCmLKfHEI7406F2LLNWVItX8gs9
 sll2HOkP
 Wk81+9fVWG4f6M2FiReVqvuTkWA5lUfHZGj5XqCl18oVo9K247mM5vWvSsrHBlYPi5Fvag3bVFGkWfjy/ZvQJVqsNb/hPfdAAF0a26mJThjPTAs9ktAjz58JaBHlxgMhwlsG5rrGNJcBkk3R40VvIBDEPBD8DftML4bksEzqQ1LBPqOOj015eKVW0Zjs7yIXFCig0N7BFpoT0LbFE8FkLVmiv7dstfZOM4aACJWGIXo2iEDpX8NF+39BxFTTP3F1gkh9Goo+g0+snuIrtV4nh7oAvwNgJ88AEt+PrJgxswPfy8UNVoZ35Qo8exlBFqwBX1wSqoDzb0VtHwcpaxyY1A2u14q+XhdP1PSaASsDd2gTa0fOP+5sGIQDh9MkmbqAzDMVtNmy+24Gbw4Cw7P1Bj73lI1WkcfbHjmCDXNHO9QtKmnfYXsAP3gIzPL2FBgRdfqrjEFvu/9Ra5BaSQ+fhValln5XkStbs2e1QWmNwnHZFn5Kqj3u0TFAZ03Dnw4PccgYCgtEDjCC/dl0dmUkuj5LmpkoUT8br6W9F315ebGb0bRCPRjkZU7jYpRCXuY1CwP3OzlBhaWexiwUVrMwtfUyA8h5zugF7oYU0OeDMFDerhULUougsmh4hxAYtplGBJToCZVLsTYvoJ4Q8BKqW2RaDHpDwI+XRJ3euVAJlX4jcvrjHQBatH6VNpzZVhlFgdUxXgrmnm5Rs0XVJK/I1GihtzMHtPZdTrhfJLP8SapXnCB8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Mar 2026 06:44:25 +0000
Biju Das <biju.das.jz@bp.renesas.com> wrote:

> > -----Original Message-----
> > From: dri-devel <dri-devel-bounces@lists.freedesktop.org> On Behalf Of Biju Das
> > Sent: 12 March 2026 17:47
> > To: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>; Thomas Zimmermann <tzimmermann@suse.de>
> > Cc: boris.brezillon@collabora.com; loic.molinari@collabora.com; willy@infradead.org;
> > frank.binns@imgtec.com; matt.coster@imgtec.com; maarten.lankhorst@linux.intel.com; mripard@kernel.org;
> > airlied@gmail.com; simona@ffwll.ch; linux-mm@kvack.org; dri-devel@lists.freedesktop.org
> > Subject: RE: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty status in mmap
> > 
> > Hi Tommaso,
> >   
> > > -----Original Message-----
> > > From: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
> > > Sent: 12 March 2026 17:37
> > > Subject: Re: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty
> > > status in mmap
> > >
> > > Hi Thomas,
> > > Thanks for your patch.
> > >
> > > I'm working on DSI support for RZ/G3E from this morning rebasing on
> > > top of next-20260311 I'm seeing that weston hang on my side:
> > >
> > > Reverting this patch fix the issue.
> > > (git revert 28e3918179aa)
> > >
> > > I'm wondering if anyone encountered this issue?
> > > Thanks in advance.  
> > 
> > 
> > I am also seeing same issue on RZ/G3L with weston.  
> 
> Just add I am using mesa with panfrost(Mali-G31) on RZ/G3L.
> 
> Disabling Mali-G31 renders weston desktop during boot.
> 
> Looks like this patch is creating some hang in panfrost driver
> during weston launch.
> 
> Cheers,
> Biju
> 
> 
> 
> > 
> > Cheers,
> > Biju
> > 
> > 
> >   
> > >
> > > Kind Regards,
> > > Tommaso
> > >
> > > On Fri, Feb 27, 2026 at 12:42:10PM +0100, Thomas Zimmermann wrote:  
> > > > Invoke folio_mark_accessed() in mmap page faults to add the folio to
> > > > the memory manager's LRU list. Userspace invokes mmap to get the
> > > > memory for software rendering. Compositors do the same when creating
> > > > the final on-screen image, so keeping the pages in LRU makes sense.
> > > > Avoids paging out graphics buffers when under memory pressure.
> > > >
> > > > In pfn_mkwrite, further invoke the folio_mark_dirty() to add the
> > > > folio for writeback should the underlying file be paged out from system memory.
> > > > This rarely happens in practice, yet it would corrupt the buffer content.
> > > >
> > > > This has little effect on a system's hardware-accelerated rendering,
> > > > which only mmaps for an initial setup of textures, meshes, shaders, etc.
> > > >
> > > > v4:
> > > > - test for VM_FAULT_NOPAGE before marking folio as accessed (Boris)
> > > > - test page-array bounds in mkwrite handler (Boris)
> > > > v3:
> > > > - rewrite for VM_PFNMAP
> > > > v2:
> > > > - adapt to changes in drm_gem_shmem_try_mmap_pmd()
> > > >
> > > > Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> > > > Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
> > > > ---
> > > >  drivers/gpu/drm/drm_gem_shmem_helper.c | 22 ++++++++++++++++++++++
> > > >  1 file changed, 22 insertions(+)
> > > >
> > > > diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c
> > > > b/drivers/gpu/drm/drm_gem_shmem_helper.c
> > > > index cefa50eaf7a4..1ab2bbd3860c 100644
> > > > --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> > > > +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> > > > @@ -598,6 +598,9 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
> > > >  	if (ret != VM_FAULT_NOPAGE)
> > > >  		ret = vmf_insert_pfn(vma, vmf->address, pfn);
> > > >
> > > > +	if (ret == VM_FAULT_NOPAGE)
> > > > +		folio_mark_accessed(folio);
> > > > +
> > > >  out:
> > > >  	dma_resv_unlock(obj->resv);
> > > >
> > > > @@ -638,10 +641,29 @@ static void drm_gem_shmem_vm_close(struct vm_area_struct *vma)
> > > >  	drm_gem_vm_close(vma);
> > > >  }
> > > >
> > > > +static vm_fault_t drm_gem_shmem_pfn_mkwrite(struct vm_fault *vmf) {
> > > > +	struct vm_area_struct *vma = vmf->vma;
> > > > +	struct drm_gem_object *obj = vma->vm_private_data;
> > > > +	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
> > > > +	loff_t num_pages = obj->size >> PAGE_SHIFT;
> > > > +	pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page offset
> > > > +within VMA */
> > > > +
> > > > +	if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >= num_pages))
> > > > +		return VM_FAULT_SIGBUS;
> > > > +
> > > > +	file_update_time(vma->vm_file);
> > > > +
> > > > +	folio_mark_dirty(page_folio(shmem->pages[page_offset]));

Do we need a folio_mark_dirty_lock() here? 

> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > >  const struct vm_operations_struct drm_gem_shmem_vm_ops = {
> > > >  	.fault = drm_gem_shmem_fault,
> > > >  	.open = drm_gem_shmem_vm_open,
> > > >  	.close = drm_gem_shmem_vm_close,
> > > > +	.pfn_mkwrite = drm_gem_shmem_pfn_mkwrite,
> > > >  };
> > > >  EXPORT_SYMBOL_GPL(drm_gem_shmem_vm_ops);
> > > >
> > > > --
> > > > 2.52.0
> > > >  


