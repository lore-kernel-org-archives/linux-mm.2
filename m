Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 382441090234
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 14:55:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C00A6B04EE; Thu, 19 Mar 2026 10:55:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96EED6B04F0; Thu, 19 Mar 2026 10:55:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 885A16B04F1; Thu, 19 Mar 2026 10:55:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 741846B04EE
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:55:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2DE5E8C0AA
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:55:05 +0000 (UTC)
X-FDA: 84563110170.25.C25EE4F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7AC424000A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:55:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="DWK1/jLt";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773932103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Q8w+/udVX28sDzSNf/iFfEPclIcvE+hqY9pQyr/FQQ=;
	b=RKS4u1JofKzh7J0XSnhKPLOH45w54Fh/4lFgttb9t97TNoJr2IrmkZtoqy9h4WTjTCRLVH
	yiYMuOiMcUpQWOgh2tvobK+z0CU2Ym9QssToqNC29ZVsqSPl+1QYcYCgBq5v1FPX3eCSsW
	gf8d2MVBsaqemnp0/f0cFKCecfsHtkg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773932103; a=rsa-sha256;
	cv=none;
	b=J2D/yKOPELncg/IKwAigX93em7P+PqciA83fuIQZHSXcR6flkynv1co/kgif/9XuU/We6o
	/NLvHm7T389JbxGr4LtX4XZuOPYiJUWZKTStFcYlmggNfeAx3TavGHHYqO6Qr0kpbMPeoC
	ZrndvzwaWcUtI/9XlnBZoJ133mv3Y2w=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="DWK1/jLt";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DFCBF60126;
	Thu, 19 Mar 2026 14:55:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA46BC19424;
	Thu, 19 Mar 2026 14:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773932102;
	bh=vZULXEbqvj9XMh1iYVr0JxZ7kXOOtLBngxqmvXJyFD8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DWK1/jLtFiueTNNf0pKNXUf0Wa+NCtGhMgYPS/t0qA9zA1dxoc4Ik3Nf5HFoaRTlI
	 ZwECl51xgnBi+rSjBkwE9ujeqvhnhxXTEQUH4rRcDnoW4wKG+gPiRa4Kg/HMH5dRAw
	 2PhCk0R4iSLNJBmtXcgsUFCEmb5vCcz/NqSeir7Y/POHMXx0jlq7aZCe5pHNH0vP3M
	 KOZzMRHcg2i1C+Sb7X7aeYo4lLhsHzNPVMAtbUovXYUwi2SRf2nJuhsGJNx8DqdxGw
	 kjjsd8A9g0s19vG6z1+5nKRV/txEbuDzgBGRKOoZHEjirW/6VCeDwwWCUiwBJ6YC+Q
	 YjwfuxBcKb4Lw==
Date: Thu, 19 Mar 2026 14:54:59 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"K . Y . Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
	Alexandre Torgue <alexandre.torgue@foss.st.com>, Miquel Raynal <miquel.raynal@bootlin.com>, 
	Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>, 
	Bodo Stroesser <bostroesser@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-stm32@st-md-mailman.stormreply.com, linux-arm-kernel@lists.infradead.org, 
	linux-mtd@lists.infradead.org, linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH v2 11/16] staging: vme_user: replace deprecated mmap hook
 with mmap_prepare
Message-ID: <8cdad898-b306-40fe-a367-efe7147f83b9@lucifer.local>
References: <cover.1773695307.git.ljs@kernel.org>
 <48c6d25e374b57dba6df4fdddd4830d3fc1105be.1773695307.git.ljs@kernel.org>
 <CAJuCfpFXuHg4KPY27pqMC-xV5y9ZY2W72_R8_rxO0DvrJ=_yvw@mail.gmail.com>
 <CAJuCfpE5qZmi43EeZiRcy78pD6YvJb5n_xnoUJfwEjomowu0=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpE5qZmi43EeZiRcy78pD6YvJb5n_xnoUJfwEjomowu0=A@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7AC424000A
X-Stat-Signature: ormf991pxc57wbmr5ab3bjifepub8kmm
X-Rspam-User: 
X-HE-Tag: 1773932103-487331
X-HE-Meta: U2FsdGVkX19ho85hb8yaHfg2L8nEK3cnmKlBmTSKzmTkmMg817ND9yUsT3Dz+zKnSwFT82NVhGb71t0Fflt7T5lRjD+Q8721MnlZZlQgbje6n9akY+uU6PzlFLURmfOjyjI57ODkbX8GYuIoUav9msEYvtKnfyQv8EVVPF9HUusO2mLLbxWPRW/FOrnKyTdU5GcLaxkmKKBLGXe5zfPhmCQ9eSdy36lYnrNwImslsy3BwTVwTv3vyiIOk7gYWzuSpA/shpWmld5/yHS8n3hohzKe4yqPVP37DyVvddd8rVPau/IBlIrzyezS135KaPdp5dmPYYZPF0rPsGxUmy76ZLMzNCYwgnSdSH+3r0X4tX1RMzLlClqQTArDKEeLYACwgKriS0Cn+Fsx7wUWo2wUHV1BfbMatGr3BGYlSPseGfcfJSj6brbPxFRPW8FhW18Kv3648umltRtLPN4ysp43eCAvn3zdp/EW0FULp09cxE0bn6C/AmG0soF9emjGpIX5Bq8ToM6AKLCmChogV1/P2bdsxT5qZXcZNQabff0g+bo089U++aI/018b2+uoWSTlwAW4HsRQ4XXTWkDZLsMLDfg/dB28VS2i2pKGbKX5YNkNCOK6t9LzwRrIAn6RO9WY/sNgXU8751740aQKF9pP+GRT9K1z3jXpzfy0GE8pwR/8QAC1AQoSqBd/yE3kT9E61d9YwVZ0JTh+pd5GwEq98h4nh2wbOqJBBkHmVKF8AbZNDFxPg3toXt4BZxg5QlmCaKHgYQrhgiJgI2H4lTTg0rK3bFug3F0QPd1+FPZ0O/uy9I5K5yjf7uHsTxhH9dCb68+v0M2C5K4fOmQebWYrjrgGtRw0ElfRUOgpOna5xF3CZMEwesafhoG/rHBYUCKW/l/dbMIWUnpeWdJBy3JSjdXndxKa2lJJtBDurhm4ad7u9AW0wgcouU2fzcRfIDbDnbTN75FAgkB0hviPrqt
 k9nag4F9
 Go2vdQFy/tkgdCphb6J4Y304QyrHsE72RxB0MqYnf8bIWx0mxwCB8R0BTYq8M7sOn2fwPzOy0kIY8usjlwYPzSGQlCTEQC7c7dQLgi3g3C3d4nnEp5Y8nO+yIsBprciNfb3w/WMjXvxJX7e+Szw1X+gdh5FAX3wngZ9cyiQnlmio4x9DHY/tLLcaR0flcPfDbSo8WiZRAZWEweMZ4Fxx6i5PJFIvRM6hKHrQOXu1JSEzJ1SE9dxuOmCKa9z/x4nQUMOnAo67MnJ4HdtBJCoiTqLMF8RpbcC97XXK0zl86c006TDDDLM/TqkWBhkj3bocy8N9Y3dHKLaZMy03V6F62O9EABhCo6b7WjS15IiSIn6UiocnTQjkRi5ehTPBtQ8mo2FhK+s/gQICYcv7LNfRWUbyUjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 02:32:16PM -0700, Suren Baghdasaryan wrote:
> On Tue, Mar 17, 2026 at 2:26 PM Suren Baghdasaryan <surenb@google.com> wrote:
> >
> > On Mon, Mar 16, 2026 at 2:14 PM Lorenzo Stoakes (Oracle) <ljs@kernel.org> wrote:
> > >
> > > The f_op->mmap interface is deprecated, so update driver to use its
> > > successor, mmap_prepare.
> > >
> > > The driver previously used vm_iomap_memory(), so this change replaces it
> > > with its mmap_prepare equivalent, mmap_action_simple_ioremap().
> > >
> > > Functions that wrap mmap() are also converted to wrap mmap_prepare()
> > > instead.
> > >
> > > Also update the documentation accordingly.
> > >
> > > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > > ---
> > >  Documentation/driver-api/vme.rst    |  2 +-
> > >  drivers/staging/vme_user/vme.c      | 20 +++++------
> > >  drivers/staging/vme_user/vme.h      |  2 +-
> > >  drivers/staging/vme_user/vme_user.c | 51 +++++++++++++++++------------
> > >  4 files changed, 42 insertions(+), 33 deletions(-)
> > >
> > > diff --git a/Documentation/driver-api/vme.rst b/Documentation/driver-api/vme.rst
> > > index c0b475369de0..7111999abc14 100644
> > > --- a/Documentation/driver-api/vme.rst
> > > +++ b/Documentation/driver-api/vme.rst
> > > @@ -107,7 +107,7 @@ The function :c:func:`vme_master_read` can be used to read from and
> > >
> > >  In addition to simple reads and writes, :c:func:`vme_master_rmw` is provided to
> > >  do a read-modify-write transaction. Parts of a VME window can also be mapped
> > > -into user space memory using :c:func:`vme_master_mmap`.
> > > +into user space memory using :c:func:`vme_master_mmap_prepare`.
> > >
> > >
> > >  Slave windows
> > > diff --git a/drivers/staging/vme_user/vme.c b/drivers/staging/vme_user/vme.c
> > > index f10a00c05f12..7220aba7b919 100644
> > > --- a/drivers/staging/vme_user/vme.c
> > > +++ b/drivers/staging/vme_user/vme.c
> > > @@ -735,9 +735,9 @@ unsigned int vme_master_rmw(struct vme_resource *resource, unsigned int mask,
> > >  EXPORT_SYMBOL(vme_master_rmw);
> > >
> > >  /**
> > > - * vme_master_mmap - Mmap region of VME master window.
> > > + * vme_master_mmap_prepare - Mmap region of VME master window.
> > >   * @resource: Pointer to VME master resource.
> > > - * @vma: Pointer to definition of user mapping.
> > > + * @desc: Pointer to descriptor of user mapping.
> > >   *
> > >   * Memory map a region of the VME master window into user space.
> > >   *
> > > @@ -745,12 +745,13 @@ EXPORT_SYMBOL(vme_master_rmw);
> > >   *         resource or -EFAULT if map exceeds window size. Other generic mmap
> > >   *         errors may also be returned.
> > >   */
> > > -int vme_master_mmap(struct vme_resource *resource, struct vm_area_struct *vma)
> > > +int vme_master_mmap_prepare(struct vme_resource *resource,
> > > +                           struct vm_area_desc *desc)
> > >  {
> > > +       const unsigned long vma_size = vma_desc_size(desc);
> > >         struct vme_bridge *bridge = find_bridge(resource);
> > >         struct vme_master_resource *image;
> > >         phys_addr_t phys_addr;
> > > -       unsigned long vma_size;
> > >
> > >         if (resource->type != VME_MASTER) {
> > >                 dev_err(bridge->parent, "Not a master resource\n");
> > > @@ -758,19 +759,18 @@ int vme_master_mmap(struct vme_resource *resource, struct vm_area_struct *vma)
> > >         }
> > >
> > >         image = list_entry(resource->entry, struct vme_master_resource, list);
> > > -       phys_addr = image->bus_resource.start + (vma->vm_pgoff << PAGE_SHIFT);
> > > -       vma_size = vma->vm_end - vma->vm_start;
> > > +       phys_addr = image->bus_resource.start + (desc->pgoff << PAGE_SHIFT);
> > >
> > >         if (phys_addr + vma_size > image->bus_resource.end + 1) {
> > >                 dev_err(bridge->parent, "Map size cannot exceed the window size\n");
> > >                 return -EFAULT;
> > >         }
> > >
> > > -       vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> > > -
> > > -       return vm_iomap_memory(vma, phys_addr, vma->vm_end - vma->vm_start);
> > > +       desc->page_prot = pgprot_noncached(desc->page_prot);
> > > +       mmap_action_simple_ioremap(desc, phys_addr, vma_size);
> > > +       return 0;
> > >  }
> > > -EXPORT_SYMBOL(vme_master_mmap);
> > > +EXPORT_SYMBOL(vme_master_mmap_prepare);
> > >
> > >  /**
> > >   * vme_master_free - Free VME master window
> > > diff --git a/drivers/staging/vme_user/vme.h b/drivers/staging/vme_user/vme.h
> > > index 797e9940fdd1..b6413605ea49 100644
> > > --- a/drivers/staging/vme_user/vme.h
> > > +++ b/drivers/staging/vme_user/vme.h
> > > @@ -151,7 +151,7 @@ ssize_t vme_master_read(struct vme_resource *resource, void *buf, size_t count,
> > >  ssize_t vme_master_write(struct vme_resource *resource, void *buf, size_t count, loff_t offset);
> > >  unsigned int vme_master_rmw(struct vme_resource *resource, unsigned int mask, unsigned int compare,
> > >                             unsigned int swap, loff_t offset);
> > > -int vme_master_mmap(struct vme_resource *resource, struct vm_area_struct *vma);
> > > +int vme_master_mmap_prepare(struct vme_resource *resource, struct vm_area_desc *desc);
> > >  void vme_master_free(struct vme_resource *resource);
> > >
> > >  struct vme_resource *vme_dma_request(struct vme_dev *vdev, u32 route);
> > > diff --git a/drivers/staging/vme_user/vme_user.c b/drivers/staging/vme_user/vme_user.c
> > > index d95dd7d9190a..11e25c2f6b0a 100644
> > > --- a/drivers/staging/vme_user/vme_user.c
> > > +++ b/drivers/staging/vme_user/vme_user.c
> > > @@ -446,24 +446,14 @@ static void vme_user_vm_close(struct vm_area_struct *vma)
> > >         kfree(vma_priv);
> > >  }
> > >
> > > -static const struct vm_operations_struct vme_user_vm_ops = {
> > > -       .open = vme_user_vm_open,
> > > -       .close = vme_user_vm_close,
> > > -};
> > > -
> > > -static int vme_user_master_mmap(unsigned int minor, struct vm_area_struct *vma)
> > > +static int vme_user_vm_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
> > > +                             const struct file *file, void **vm_private_data)
> > >  {
> > > -       int err;
> > > +       const unsigned int minor = iminor(file_inode(file));
> > >         struct vme_user_vma_priv *vma_priv;
> > >
> > >         mutex_lock(&image[minor].mutex);
> > >
> > > -       err = vme_master_mmap(image[minor].resource, vma);
> > > -       if (err) {
> > > -               mutex_unlock(&image[minor].mutex);
> > > -               return err;
> > > -       }
> > > -
> >
> > Ok, this changes the set of the operations performed under image[minor].mutex.
> > Before we had:
> >
> > mutex_lock(&image[minor].mutex);
> > vme_master_mmap();
> > <some final adjustments>
> > mutex_unlock(&image[minor].mutex);
> >
> > Now we have:
> >
> > mutex_lock(&image[minor].mutex);
> > vme_master_mmap_prepare()
> > mutex_unlock(&image[minor].mutex);
> > vm_iomap_memory();
> > mutex_lock(&image[minor].mutex);
> > vme_user_vm_mapped(); // <some final adjustments>
> > mutex_unlock(&image[minor].mutex);
> >
> > I think as long as image[minor] does not change while we are not
> > holding the mutex we should be safe, and looking at the code it seems
> > to be the case. But I'm not familiar with this driver and might be
> > wrong. Worth double-checking.

The file is pinned for the duration, the mutex is associated with the file,
so there's no sane world in which that could be problematic.

Keeping in mind that we manipulate stuff on vme_user_vm_close() that
directly acceses image[minor] at an arbitary time.

>
> A side note: if we had to hold the mutex across all those operations I
> think we would need to take the mutex in the vm_ops->mmap_prepare and
> add a vm_ops->map_failed hook or something along that line to drop the
> mutex in case mmap_action_complete() fails. Not sure if we will have
> such cases though...

No, I don't want to do this if it can be at all avoided. You should in
nearly any sane circumstance be able to defer things until the mapped hook
anyway.

Also a merge can happen too after an .mmap_prepare, so we'd have to have
some 'success' hook and I'm just not going there it'll end up open to abuse
again.

(We do have success and error filtering hooks right now, sadly, but they're
really for hugetlb and I plan to find a way to get rid of them).

The mmap_prepare is meant to essentially be as stateless as possible.

Anyway I don't think it's relevant here.

>
> >
> > >         vma_priv = kmalloc_obj(*vma_priv);
> > >         if (!vma_priv) {
> > >                 mutex_unlock(&image[minor].mutex);
> > > @@ -472,22 +462,41 @@ static int vme_user_master_mmap(unsigned int minor, struct vm_area_struct *vma)
> > >
> > >         vma_priv->minor = minor;
> > >         refcount_set(&vma_priv->refcnt, 1);
> > > -       vma->vm_ops = &vme_user_vm_ops;
> > > -       vma->vm_private_data = vma_priv;
> > > -
> > > +       *vm_private_data = vma_priv;
> > >         image[minor].mmap_count++;
> > >
> > >         mutex_unlock(&image[minor].mutex);
> > > -
> > >         return 0;
> > >  }
> > >
> > > -static int vme_user_mmap(struct file *file, struct vm_area_struct *vma)
> > > +static const struct vm_operations_struct vme_user_vm_ops = {
> > > +       .mapped = vme_user_vm_mapped,
> > > +       .open = vme_user_vm_open,
> > > +       .close = vme_user_vm_close,
> > > +};
> > > +
> > > +static int vme_user_master_mmap_prepare(unsigned int minor,
> > > +                                       struct vm_area_desc *desc)
> > > +{
> > > +       int err;
> > > +
> > > +       mutex_lock(&image[minor].mutex);
> > > +
> > > +       err = vme_master_mmap_prepare(image[minor].resource, desc);
> > > +       if (!err)
> > > +               desc->vm_ops = &vme_user_vm_ops;
> > > +
> > > +       mutex_unlock(&image[minor].mutex);
> > > +       return err;
> > > +}
> > > +
> > > +static int vme_user_mmap_prepare(struct vm_area_desc *desc)
> > >  {
> > > -       unsigned int minor = iminor(file_inode(file));
> > > +       const struct file *file = desc->file;
> > > +       const unsigned int minor = iminor(file_inode(file));
> > >
> > >         if (type[minor] == MASTER_MINOR)
> > > -               return vme_user_master_mmap(minor, vma);
> > > +               return vme_user_master_mmap_prepare(minor, desc);
> > >
> > >         return -ENODEV;
> > >  }
> > > @@ -498,7 +507,7 @@ static const struct file_operations vme_user_fops = {
> > >         .llseek = vme_user_llseek,
> > >         .unlocked_ioctl = vme_user_unlocked_ioctl,
> > >         .compat_ioctl = compat_ptr_ioctl,
> > > -       .mmap = vme_user_mmap,
> > > +       .mmap_prepare = vme_user_mmap_prepare,
> > >  };
> > >
> > >  static int vme_user_match(struct vme_dev *vdev)
> > > --
> > > 2.53.0
> > >

Cheers, Lorenzo

