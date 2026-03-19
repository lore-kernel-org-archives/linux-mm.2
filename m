Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 696DB1090237
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 15:10:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC0B96B04F8; Thu, 19 Mar 2026 11:10:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A70FB6B04FA; Thu, 19 Mar 2026 11:10:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9394A6B04FB; Thu, 19 Mar 2026 11:10:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7899B6B04F8
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:10:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0192E13B24E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:10:44 +0000 (UTC)
X-FDA: 84563149650.23.07DFFC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id F037F18000C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:10:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mGEtPIVR;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773933043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LIUiWLcTdM9jHXZTerPMEHMqw+NZlkNHStyN1sK3jR4=;
	b=8QOho5fDEkszNU8VQJTkEQa4P+JNBccI8PTw5hJk6XX5B/X2ZoAMZEHHEhUIH7c1ZtiVzl
	Q6yg6t/S8xnJHkvOFfrtP6ux9Qd58ytyUkodFGPcilKonGoCYvsYhnNLFmHlUT/hbiF6U1
	dQGeH+gNbZKXcpcl4rWGNiyLh435GF8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773933043; a=rsa-sha256;
	cv=none;
	b=n7RKSrbDOGgnCw3edQv7XUsfcL4TxE18t94Z5tkqIOPDexBUEpf07xrYOi2LHKqSDioTUZ
	dzLO4wauRuXry51DcBsu720nZwMYvgFB87HYE5zdtH42WkIRQG5kJUAHasRsFJYNxg6GxE
	ClUOb5bgbO80jqYkAOsYO6Psn6lx3Sc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mGEtPIVR;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CB03843FED;
	Thu, 19 Mar 2026 15:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CBCC19424;
	Thu, 19 Mar 2026 15:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773933041;
	bh=962OH3BCkCnFuqUFZ6CV6GTYwYwg7Cgfzq0lQ5WSVD8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mGEtPIVR96Qqe9NRoICiZzfXXvz3eZQfjphLLBby5YW9M/BWfyVYLEBn5CApHzfYK
	 DYwxRwq+IqVZ+jMnAbQm61aQhpOOaoXrNX9ia5fX6UWtQiRQx/DzaS9uB1I34caUA/
	 kSQ26nH8AzkZ+Gh86+t8fpytlEgq36RbVzySi/1xeYRMiCPH+fdqPFPc9jNUY3AxeN
	 3GOgSMnuyMQOb9WOdXp5172TVmges2jncXhuy3ytoa/SJkQBntwckOvs1FobX4Q0+0
	 qSd7IEKle/UnTGEEMe57JCHxS5q4XVdII/482MSps8V37TPFkv9c9ASh42lN0FVVEY
	 JRtphCO+57l2w==
Date: Thu, 19 Mar 2026 15:10:38 +0000
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
Subject: Re: [PATCH v2 12/16] mm: allow handling of stacked mmap_prepare
 hooks in more drivers
Message-ID: <1fac76fc-9d1c-43e4-ae96-b03fadf646f1@lucifer.local>
References: <cover.1773695307.git.ljs@kernel.org>
 <72750af6906fd96fb6f18e83ac3e694cf357a2c1.1773695307.git.ljs@kernel.org>
 <CAJuCfpFr8_uU28S=v7y74Opa4L_4s9J70NgUXg1WGmraDhsxRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFr8_uU28S=v7y74Opa4L_4s9J70NgUXg1WGmraDhsxRA@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F037F18000C
X-Stat-Signature: hgqc9r5qfqt56pci9gauwf66ysha9tk1
X-Rspam-User: 
X-HE-Tag: 1773933042-557232
X-HE-Meta: U2FsdGVkX1+zQH8YUU2mIDKsp1mUwA+FQD9nLS4bOdmGNkP73iTJBh7ZN/dDgGMJSQfeFEyI5IcOt6ky5pBlCJJ0wlNusCRW/LyU6EqBSrrbeLLVz3T1IOWhIDwRDhHh0EthchzlorXjNcJIorhB9LqtvS+AoXfpjGMrRRIGD5VAjGPmR/A7n2eKrNYQoraBK54GBCHqfWk5OBh2oAaT14Cr80WdMWDfoLXEUWECaZKy0SFjiklYGeNneeLsaPAr4WNNRUyBtE+kg45BcmoyhlNxEp7aptZoeYHBCfpO4GRNn9NxqGGyU2X1WnZ6dpROjG0cr7vIDqAd5UTZq6Mo0ibg4s3qV/UE0N1PrY4x7ylEZiiuLyEB30teuUpAWc3C+mUYKvhlixFsawqMb9OJ1MhsX1p3CtPlAWAxoJ05/MmIIDc5FDodHb8b6vjLA26EMRcuKW4+ptW3MwUAx6mB9hylbV+DYP7CC3VMXMasnsXFdUqaYvN6fwR0+Jkd9/ZAHfHwwjuiKKf93sks3ye5tBxGc538n+Pos8vQDm6t4/ExQrAWzTI3b+zyKCPOxIY9qd0myjMLI20FdeT/wKArvW4eZuB/t54Q5M5lHlhs/XQ2/6GHMPCkkU+yM7AAmMNxl8e8LRznTtikvZr8Y0TGSPqzsMkNbcmne+9LuwlFf3nQ8zt7WzO7SGU02Y7DAOtTJUSHSG9lbwtY9fv/bmYrYuhiOkXTnJA7r9kyrus0gOmJc1cSnCR/Rz2hlo8wSBWRz5SryNtRMqLi3WvhmqcoXSdAFwAYiXGqfADfYolABgW9aYC2UQutwaWymMV8mBpcYEuv8WoHCZXdjZyV+YXKjBCzOBM9sAKermOgSvnB37WiL4dOmGnZnCea+h7RRQNFRgHkzB0BTCqnRqbZRuOosX9SzilKSS/86zzU/GA59L6DbuxgTpHlCe5ylA0/ub5/86b7FsxxTb4ch2Q5IaW
 eCaZJ7mj
 ZYn49AviGpqpTwrvygI7CiUkmm2M8PmpQe5+wXXC6QxRPC31VxroWPCeATyXjjnOf7i0c9/rMsliL7I7EvAuY9ib7ulj4r7wr3hrnxsIkTA61/NkY/ejzcQxhoi5uKyNE+iRAohw32Wr854Yfj966L9lXbj9VuV/MQrYQPscXwu21mypHNzmBVntyxD+1knQBlLsO8dOcDy6/4FSYux77g6o8WKXPgfkzUEQ9L/iBfmxwMXDL+AoUICiVzoe3NFsK+T9TC2or3jnATdsDrg70AaY4IWjNFXKYkbR/X3+ISSMVInLvuFklTWwxvsbNqAmSdRRQjXiKc/hnmvZc9/3vFoA4XIGGEi8gUfZosLm13gzbwPVwXzrskCExpegat5pLM8ml
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 08:33:28AM -0700, Suren Baghdasaryan wrote:
> On Mon, Mar 16, 2026 at 2:14 PM Lorenzo Stoakes (Oracle) <ljs@kernel.org> wrote:
> >
> > While the conversion of mmap hooks to mmap_prepare is underway, we wil
>
> nit: s/wil/will

Thanks, fixed.

>
> > encounter situations where mmap hooks need to invoke nested mmap_prepare
> > hooks.
> >
> > The nesting of mmap hooks is termed 'stacking'.  In order to flexibly
> > facilitate the conversion of custom mmap hooks in drivers which stack, we
> > must split up the existing compat_vma_mapped() function into two separate
> > functions:
> >
> > * compat_set_desc_from_vma() - This allows the setting of a vm_area_desc
> >   object's fields to the relevant fields of a VMA.
> >
> > * __compat_vma_mmap() - Once an mmap_prepare hook has been executed upon a
> >   vm_area_desc object, this function performs any mmap actions specified by
> >   the mmap_prepare hook and then invokes its vm_ops->mapped() hook if any
> >   were specified.
> >
> > In ordinary cases, where a file's f_op->mmap_prepare() hook simply needs to
> > be invoked in a stacked mmap() hook, compat_vma_mmap() can be used.
> >
> > However some drivers define their own nested hooks, which are invoked in
> > turn by another hook.
> >
> > A concrete example is vmbus_channel->mmap_ring_buffer(), which is invoked
> > in turn by bin_attribute->mmap():
> >
> > vmbus_channel->mmap_ring_buffer() has a signature of:
> >
> > int (*mmap_ring_buffer)(struct vmbus_channel *channel,
> >                         struct vm_area_struct *vma);
> >
> > And bin_attribute->mmap() has a signature of:
> >
> >         int (*mmap)(struct file *, struct kobject *,
> >                     const struct bin_attribute *attr,
> >                     struct vm_area_struct *vma);
> >
> > And so compat_vma_mmap() cannot be used here for incremental conversion of
> > hooks from mmap() to mmap_prepare().
> >
> > There are many such instances like this, where conversion to mmap_prepare
> > would otherwise cascade to a huge change set due to nesting of this kind.
> >
> > The changes in this patch mean we could now instead convert
> > vmbus_channel->mmap_ring_buffer() to
> > vmbus_channel->mmap_prepare_ring_buffer(), and implement something like:
> >
> >         struct vm_area_desc desc;
> >         int err;
> >
> >         compat_set_desc_from_vm(&desc, file, vma);
> >         err = channel->mmap_prepare_ring_buffer(channel, &desc);
> >         if (err)
> >                 return err;
> >
> >         return __compat_vma_mmap(&desc, vma);
> >
> > Allowing us to incrementally update this logic, and other logic like it.
>
> The way I understand this and the next 2 patches is that they are
> preperations for later replacement of mmap() with mmap_prepare() but
> they don't yet do that completely. Is that right?
> To clarify what I mean, in [1] for example, you are replacing struct
> uio_info.mmap with uio_info.mmap_prepare but it's still being called
> from uio_mmap(). IOW, you are not replacing uio_mmap with
> uio_mmap_prepare. Is that the next step that's not yet implemented?

Yeah, there were 12 more patches I didn't send :) because I feel they'd
make more sense separate and wanted to test/develop them more.

This is all laying the groundwork for having mmap_prepare DMA cache
mappings ultimately, while expanding functionality as we go.

The intent here though isn't _just_ that, it's more - in general - when we
have an e.g.:

int some_special_mmap(struct some_type *blah, struct file *filp /* sometimes */,
		      struct vm_area_struct *vma)
{
	...
}

Or some say custom ops for something like this, where in the existing code
callers hook .mmap(), grab some specific struct (like a device pointer or a
state pointer) from the file private data and then delegate to another
helper.

In this situation, we are able to use the compatibility layer to change say
the ops to be .mmap_prepare instead while the overarching caller is .mmap.

This allows for iterative conversion to .mmap_prepare without having to
amend 100 files at once in a multi-thousand line patch touching dozens of
drivers or some hellish notion like that.

This is vital to sensibly being able to implement these changes bit-by-bit.

Cheers, Lorenzo

>
> [1] https://lore.kernel.org/all/892a8b32e5ef64c69239ccc2d1bd364716fd7fdf.1773695307.git.ljs@kernel.org/
>
> >
> > Unfortunately, as part of this change, we need to be able to flexibly
> > assign to the VMA descriptor, so have to remove some of the const
> > declarations within the structure.
> >
> > Also update the VMA tests to reflect the changes.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > ---
> >  include/linux/fs.h              |   3 +
> >  include/linux/mm_types.h        |   4 +-
> >  mm/util.c                       | 111 +++++++++++++++++++++++---------
> >  mm/vma.h                        |   2 +-
> >  tools/testing/vma/include/dup.h | 111 ++++++++++++++++++++------------
> >  5 files changed, 157 insertions(+), 74 deletions(-)
> >
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index c390f5c667e3..0bdccfa70b44 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -2058,6 +2058,9 @@ static inline bool can_mmap_file(struct file *file)
> >         return true;
> >  }
> >
> > +void compat_set_desc_from_vma(struct vm_area_desc *desc, const struct file *file,
> > +                             const struct vm_area_struct *vma);
> > +int __compat_vma_mmap(struct vm_area_desc *desc, struct vm_area_struct *vma);
> >  int compat_vma_mmap(struct file *file, struct vm_area_struct *vma);
> >  int __vma_check_mmap_hook(struct vm_area_struct *vma);
> >
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index 50685cf29792..7538d64f8848 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -891,8 +891,8 @@ static __always_inline bool vma_flags_empty(vma_flags_t *flags)
> >   */
> >  struct vm_area_desc {
> >         /* Immutable state. */
> > -       const struct mm_struct *const mm;
> > -       struct file *const file; /* May vary from vm_file in stacked callers. */
> > +       struct mm_struct *mm;
> > +       struct file *file; /* May vary from vm_file in stacked callers. */
> >         unsigned long start;
> >         unsigned long end;
> >
> > diff --git a/mm/util.c b/mm/util.c
> > index aa92e471afe1..a166c48fe894 100644
> > --- a/mm/util.c
> > +++ b/mm/util.c
> > @@ -1163,34 +1163,38 @@ void flush_dcache_folio(struct folio *folio)
> >  EXPORT_SYMBOL(flush_dcache_folio);
> >  #endif
> >
> > -static int __compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
> > +/**
> > + * compat_set_desc_from_vma() - assigns VMA descriptor @desc fields from a VMA.
> > + * @desc: A VMA descriptor whose fields need to be set.
> > + * @file: The file object describing the file being mmap()'d.
> > + * @vma: The VMA whose fields we wish to assign to @desc.
> > + *
> > + * This is a compatibility function to allow an mmap() hook to call
> > + * mmap_prepare() hooks when drivers nest these. This function specifically
> > + * allows the construction of a vm_area_desc value, @desc, from a VMA @vma for
> > + * the purposes of doing this.
> > + *
> > + * Once the conversion of drivers is complete this function will no longer be
> > + * required and will be removed.
> > + */
> > +void compat_set_desc_from_vma(struct vm_area_desc *desc,
> > +                             const struct file *file,
> > +                             const struct vm_area_struct *vma)
> >  {
> > -       struct vm_area_desc desc = {
> > -               .mm = vma->vm_mm,
> > -               .file = file,
> > -               .start = vma->vm_start,
> > -               .end = vma->vm_end,
> > -
> > -               .pgoff = vma->vm_pgoff,
> > -               .vm_file = vma->vm_file,
> > -               .vma_flags = vma->flags,
> > -               .page_prot = vma->vm_page_prot,
> > -
> > -               .action.type = MMAP_NOTHING, /* Default */
> > -       };
> > -       int err;
> > +       desc->mm = vma->vm_mm;
> > +       desc->file = (struct file *)file;
> > +       desc->start = vma->vm_start;
> > +       desc->end = vma->vm_end;
> >
> > -       err = vfs_mmap_prepare(file, &desc);
> > -       if (err)
> > -               return err;
> > +       desc->pgoff = vma->vm_pgoff;
> > +       desc->vm_file = vma->vm_file;
> > +       desc->vma_flags = vma->flags;
> > +       desc->page_prot = vma->vm_page_prot;
> >
> > -       err = mmap_action_prepare(&desc);
> > -       if (err)
> > -               return err;
> > -
> > -       set_vma_from_desc(vma, &desc);
> > -       return mmap_action_complete(vma, &desc.action);
> > +       /* Default. */
> > +       desc->action.type = MMAP_NOTHING;
> >  }
> > +EXPORT_SYMBOL(compat_set_desc_from_vma);
> >
> >  static int __compat_vma_mapped(struct file *file, struct vm_area_struct *vma)
> >  {
> > @@ -1211,6 +1215,49 @@ static int __compat_vma_mapped(struct file *file, struct vm_area_struct *vma)
> >         return err;
> >  }
> >
> > +/**
> > + * __compat_vma_mmap() - Similar to compat_vma_mmap(), only it allows
> > + * flexibility as to how the mmap_prepare callback is invoked, which is useful
> > + * for drivers which invoke nested mmap_prepare callbacks in an mmap() hook.
> > + * @desc: A VMA descriptor upon which an mmap_prepare() hook has already been
> > + * executed.
> > + * @vma: The VMA to which @desc should be applied.
> > + *
> > + * The function assumes that you have obtained a VMA descriptor @desc from
> > + * compt_set_desc_from_vma(), and already executed the mmap_prepare() hook upon
> > + * it.
> > + *
> > + * It then performs any specified mmap actions, and invokes the vm_ops->mapped()
> > + * hook if one is present.
> > + *
> > + * See the description of compat_vma_mmap() for more details.
> > + *
> > + * Once the conversion of drivers is complete this function will no longer be
> > + * required and will be removed.
> > + *
> > + * Returns: 0 on success or error.
> > + */
> > +int __compat_vma_mmap(struct vm_area_desc *desc,
> > +                     struct vm_area_struct *vma)
> > +{
> > +       int err;
> > +
> > +       /* Perform any preparatory tasks for mmap action. */
> > +       err = mmap_action_prepare(desc);
> > +       if (err)
> > +               return err;
> > +       /* Update the VMA from the descriptor. */
> > +       compat_set_vma_from_desc(vma, desc);
> > +       /* Complete any specified mmap actions. */
> > +       err = mmap_action_complete(vma, &desc->action);
> > +       if (err)
> > +               return err;
> > +
> > +       /* Invoke vm_ops->mapped callback. */
> > +       return __compat_vma_mapped(desc->file, vma);
> > +}
> > +EXPORT_SYMBOL(__compat_vma_mmap);
> > +
> >  /**
> >   * compat_vma_mmap() - Apply the file's .mmap_prepare() hook to an
> >   * existing VMA and execute any requested actions.
> > @@ -1218,10 +1265,10 @@ static int __compat_vma_mapped(struct file *file, struct vm_area_struct *vma)
> >   * @vma: The VMA to apply the .mmap_prepare() hook to.
> >   *
> >   * Ordinarily, .mmap_prepare() is invoked directly upon mmap(). However, certain
> > - * stacked filesystems invoke a nested mmap hook of an underlying file.
> > + * stacked drivers invoke a nested mmap hook of an underlying file.
> >   *
> > - * Until all filesystems are converted to use .mmap_prepare(), we must be
> > - * conservative and continue to invoke these stacked filesystems using the
> > + * Until all drivers are converted to use .mmap_prepare(), we must be
> > + * conservative and continue to invoke these stacked drivers using the
> >   * deprecated .mmap() hook.
> >   *
> >   * However we have a problem if the underlying file system possesses an
> > @@ -1232,20 +1279,22 @@ static int __compat_vma_mapped(struct file *file, struct vm_area_struct *vma)
> >   * establishes a struct vm_area_desc descriptor, passes to the underlying
> >   * .mmap_prepare() hook and applies any changes performed by it.
> >   *
> > - * Once the conversion of filesystems is complete this function will no longer
> > - * be required and will be removed.
> > + * Once the conversion of drivers is complete this function will no longer be
> > + * required and will be removed.
> >   *
> >   * Returns: 0 on success or error.
> >   */
> >  int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
> >  {
> > +       struct vm_area_desc desc;
> >         int err;
> >
> > -       err = __compat_vma_mmap(file, vma);
> > +       compat_set_desc_from_vma(&desc, file, vma);
> > +       err = vfs_mmap_prepare(file, &desc);
> >         if (err)
> >                 return err;
> >
> > -       return __compat_vma_mapped(file, vma);
> > +       return __compat_vma_mmap(&desc, vma);
> >  }
> >  EXPORT_SYMBOL(compat_vma_mmap);
> >
> > diff --git a/mm/vma.h b/mm/vma.h
> > index adc18f7dd9f1..a76046c39b14 100644
> > --- a/mm/vma.h
> > +++ b/mm/vma.h
> > @@ -300,7 +300,7 @@ static inline int vma_iter_store_gfp(struct vma_iterator *vmi,
> >   * f_op->mmap() but which might have an underlying file system which implements
> >   * f_op->mmap_prepare().
> >   */
> > -static inline void set_vma_from_desc(struct vm_area_struct *vma,
> > +static inline void compat_set_vma_from_desc(struct vm_area_struct *vma,
> >                 struct vm_area_desc *desc)
> >  {
> >         /*
> > diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
> > index 114daaef4f73..6658df26698a 100644
> > --- a/tools/testing/vma/include/dup.h
> > +++ b/tools/testing/vma/include/dup.h
> > @@ -519,8 +519,8 @@ enum vma_operation {
> >   */
> >  struct vm_area_desc {
> >         /* Immutable state. */
> > -       const struct mm_struct *const mm;
> > -       struct file *const file; /* May vary from vm_file in stacked callers. */
> > +       struct mm_struct *mm;
> > +       struct file *file; /* May vary from vm_file in stacked callers. */
> >         unsigned long start;
> >         unsigned long end;
> >
> > @@ -1272,43 +1272,92 @@ static inline void vma_set_anonymous(struct vm_area_struct *vma)
> >  }
> >
> >  /* Declared in vma.h. */
> > -static inline void set_vma_from_desc(struct vm_area_struct *vma,
> > +static inline void compat_set_vma_from_desc(struct vm_area_struct *vma,
> >                 struct vm_area_desc *desc);
> >
> > -static inline int __compat_vma_mmap(const struct file_operations *f_op,
> > -               struct file *file, struct vm_area_struct *vma)
> > +static inline void compat_set_desc_from_vma(struct vm_area_desc *desc,
> > +                             const struct file *file,
> > +                             const struct vm_area_struct *vma)
> >  {
> > -       struct vm_area_desc desc = {
> > -               .mm = vma->vm_mm,
> > -               .file = file,
> > -               .start = vma->vm_start,
> > -               .end = vma->vm_end,
> > +       desc->mm = vma->vm_mm;
> > +       desc->file = (struct file *)file;
> > +       desc->start = vma->vm_start;
> > +       desc->end = vma->vm_end;
> >
> > -               .pgoff = vma->vm_pgoff,
> > -               .vm_file = vma->vm_file,
> > -               .vma_flags = vma->flags,
> > -               .page_prot = vma->vm_page_prot,
> > +       desc->pgoff = vma->vm_pgoff;
> > +       desc->vm_file = vma->vm_file;
> > +       desc->vma_flags = vma->flags;
> > +       desc->page_prot = vma->vm_page_prot;
> >
> > -               .action.type = MMAP_NOTHING, /* Default */
> > -       };
> > +       /* Default. */
> > +       desc->action.type = MMAP_NOTHING;
> > +}
> > +
> > +static inline unsigned long vma_pages(const struct vm_area_struct *vma)
> > +{
> > +       return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
> > +}
> > +
> > +static inline void unmap_vma_locked(struct vm_area_struct *vma)
> > +{
> > +       const size_t len = vma_pages(vma) << PAGE_SHIFT;
> > +
> > +       mmap_assert_write_locked(vma->vm_mm);
> > +       do_munmap(vma->vm_mm, vma->vm_start, len, NULL);
> > +}
> > +
> > +static inline int __compat_vma_mapped(struct file *file, struct vm_area_struct *vma)
> > +{
> > +       const struct vm_operations_struct *vm_ops = vma->vm_ops;
> >         int err;
> >
> > -       err = f_op->mmap_prepare(&desc);
> > +       if (!vm_ops->mapped)
> > +               return 0;
> > +
> > +       err = vm_ops->mapped(vma->vm_start, vma->vm_end, vma->vm_pgoff, file,
> > +                            &vma->vm_private_data);
> >         if (err)
> > -               return err;
> > +               unmap_vma_locked(vma);
> > +       return err;
> > +}
> >
> > -       err = mmap_action_prepare(&desc);
> > +static inline int __compat_vma_mmap(struct vm_area_desc *desc,
> > +               struct vm_area_struct *vma)
> > +{
> > +       int err;
> > +
> > +       /* Perform any preparatory tasks for mmap action. */
> > +       err = mmap_action_prepare(desc);
> > +       if (err)
> > +               return err;
> > +       /* Update the VMA from the descriptor. */
> > +       compat_set_vma_from_desc(vma, desc);
> > +       /* Complete any specified mmap actions. */
> > +       err = mmap_action_complete(vma, &desc->action);
> >         if (err)
> >                 return err;
> >
> > -       set_vma_from_desc(vma, &desc);
> > -       return mmap_action_complete(vma, &desc.action);
> > +       /* Invoke vm_ops->mapped callback. */
> > +       return __compat_vma_mapped(desc->file, vma);
> > +}
> > +
> > +static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
> > +{
> > +       return file->f_op->mmap_prepare(desc);
> >  }
> >
> >  static inline int compat_vma_mmap(struct file *file,
> >                 struct vm_area_struct *vma)
> >  {
> > -       return __compat_vma_mmap(file->f_op, file, vma);
> > +       struct vm_area_desc desc;
> > +       int err;
> > +
> > +       compat_set_desc_from_vma(&desc, file, vma);
> > +       err = vfs_mmap_prepare(file, &desc);
> > +       if (err)
> > +               return err;
> > +
> > +       return __compat_vma_mmap(&desc, vma);
> >  }
> >
> >
> > @@ -1318,11 +1367,6 @@ static inline void vma_iter_init(struct vma_iterator *vmi,
> >         mas_init(&vmi->mas, &mm->mm_mt, addr);
> >  }
> >
> > -static inline unsigned long vma_pages(struct vm_area_struct *vma)
> > -{
> > -       return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
> > -}
> > -
> >  static inline void mmap_assert_locked(struct mm_struct *);
> >  static inline struct vm_area_struct *find_vma_intersection(struct mm_struct *mm,
> >                                                 unsigned long start_addr,
> > @@ -1492,11 +1536,6 @@ static inline int vfs_mmap(struct file *file, struct vm_area_struct *vma)
> >         return file->f_op->mmap(file, vma);
> >  }
> >
> > -static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
> > -{
> > -       return file->f_op->mmap_prepare(desc);
> > -}
> > -
> >  static inline void vma_set_file(struct vm_area_struct *vma, struct file *file)
> >  {
> >         /* Changing an anonymous vma with this is illegal */
> > @@ -1521,11 +1560,3 @@ static inline pgprot_t vma_get_page_prot(vma_flags_t vma_flags)
> >
> >         return vm_get_page_prot(vm_flags);
> >  }
> > -
> > -static inline void unmap_vma_locked(struct vm_area_struct *vma)
> > -{
> > -       const size_t len = vma_pages(vma) << PAGE_SHIFT;
> > -
> > -       mmap_assert_write_locked(vma->vm_mm);
> > -       do_munmap(vma->vm_mm, vma->vm_start, len, NULL);
> > -}
> > --
> > 2.53.0
> >

