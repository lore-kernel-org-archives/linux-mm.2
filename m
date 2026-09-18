Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E785BC982DF
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 18:49:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E56BB6B0095; Fri, 18 Sep 2026 14:49:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E07C36B0096; Fri, 18 Sep 2026 14:49:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1D6D6B0098; Fri, 18 Sep 2026 14:49:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ABE186B0095
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:49:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 39E251A0756
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:49:16 +0000 (UTC)
X-FDA: 85227770712.03.AC431E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7F472C000C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:49:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YuFxYvgz;
	spf=pass (imf10.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789757354;
	b=Ltq7mdoxxdfJ4x2mwwuRwNyye6GVgKUmnm7072EeN6KWS77xISZ4ORlVn7opVFT+3EIcll
	baBuRx+9uhe1PMrj9iBfkttmsX0u/4qDTWeopxCylM4KK+8LPTsIQJSHTcZKGyrFDZLlgG
	EzQUJ5Z3/iPrL8AIBd7V1k7dJgJ79Uc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YuFxYvgz;
	spf=pass (imf10.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789757354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=+YjGVXkvvWrv64RKhh2Ovbep417GN5lNtlx2Grs+mP0=;
	b=b+BEnVDNEq5UxN8jrX2RIafzj/eqQSc47wMeOUzNiPM9+ODMp8wyneZPCJfGu5dXL2xh7J
	YPY7zwqvjxL6lb/XpVSEjN9ZcxJin/8bYjxmtSyc2zvS+OOXG33+QAXT7E1SLwsdqxMbU+
	cyiuDwwqopJOOvQ59wIDkHIjk4k+Pr8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CEFB4385F;
	Fri, 18 Sep 2026 18:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53211F000FF;
	Fri, 18 Sep 2026 18:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789757353;
	bh=+YjGVXkvvWrv64RKhh2Ovbep417GN5lNtlx2Grs+mP0=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=YuFxYvgzPYhdduBLAORJLPUdjvearnmMp/fan5nWo+/eh3i1rmVcE2+8bsxFqWAZB
	 KT1QRxXloP9WcCBp5VHvkzeaxyBVcEXaFVs8L7px5wEmCFVd4DRuTzSePmsvx/QZsH
	 557qUC/xYhUq1LcRg2M8cvXcIBStQBlD2TmDm3UAxhu50WlfYNC7YwKuHpTKgyWpQO
	 SwelWz7E13KCSFTM8WqUr7mEmspD1XuBqCRdIX7HQx/MI0C2cE4G3XwIUqT7vjqFZj
	 WHVl2SMv2LHLxANBnVl5BVIOC5Zpn68h5xB4xDXglbxHvWtTBpjqoUM+JJU+8Qixol
	 s6YDhozh+VXUw==
Date: Fri, 18 Sep 2026 13:49:11 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v8 01/12] PCI: liveupdate: Set up FLB handler for the PCI
 core
Message-ID: <20260918184911.GA1172993@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqyKVkIH58DK0EZO@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7F472C000C
X-Rspam-User: 
X-Stat-Signature: sa7b6zzmwh1ccz1aynxnm5gbu8k1iqm1
X-HE-Tag: 1789757354-810121
X-HE-Meta: U2FsdGVkX1/nKJ9iRzq98WmmcaVzFu/rlleR2tVk2ANO8EV5E8J+2YJ9IXS2mzcr5k1PxqzRyzDbAtHvGoigGgXNYhmo0j1NfGu+hlyFZjLQOzpBTtUs8hFvIuMv8jKKjiFMv2xYu3Ci7Yp4OLlRVi75lFK5ltmSgvDG62R01x8End/03Y7IB1uuQMfoDs58Ej1hIrYIMQam/rbnbST3VjnZKamdWZQATlh686lI/3nHrobFBBmUtLkIG4dZnaFinWltPgLg9DtlHAOV++0wdZk5qIxuRzlnR/nlT0BUSrxHTR8GILvTpmWCIaPXkNRnWtF9zinBfTY/J4rKgLE+1t9bht4TTHJQwaKQlQZFAT20nuahfrZNuNFYyHjKWrOIjMzM8X26cJEC8hr3Buiufc9lCX4/Z0zpPKRpudvL/cwA39TowDNfGeZynTy3vGjOWssbcJZwPuXtBVPdCePUU7kL7/K5E9n6AHoGCKEWhwt8B/9wnIliehxOyCJ/s44NSjqIhatTamN1NO36X+1Y/a+TtiXgxFMZhp1jaXBPA1AYztYE2vD7D/B8FqNME/qkmj0YXlAPaUg8d8LodOcVNWePXu0lMeA01X9AXIHZX9/vRAcperpw4MQU8oYSdIchCWWstaFaB5sMAui7IRm5mZaokMVefja0ExG5cTUIJALnDtNIu6fTmT0cFtbZ3VD4gPvFL1vfbzToZu3CJinxTb9GErfAumJZuQ4AekHvFLFqpRkIkBl+/oY7tnKOml4klyubNmhg+4FOcGxS33qqz1lXW9OMQkiIwJcEtUBJMW5mdBzGzXB1RStNzuyBNhHVeajRWmPG9OucONjW9zhTZKo9jiThzPyKa21I5ygXBRHJiX/+ImY0xubyZU6fVCoFl4FdcHcLfgkiNx25KeknOSdBVCLglsbNN0D3cDoCO6mP0w9Ut5rdKIdHiv/sZOSvvPi4lwjL21blDd6/3u5
 nSJluNR+
 S6FaHIPYje0JqolgM2Oodp08YJPdJeww0Eax7WY868YGIQizdl4XVIvoFPSq0MkLdOinPEG5eIFj1h2VchOGCLzBRPa0kFGPKsh9ylvWStdD95dQOvBpDtL716SwV3ZuKxoS1x4Z459TwF+ErqnHHq9RiEamZe1zdpypQ2xPjJ9l8YcDVHqYkOdbXVgysllMEyLL2g2P/Gbk+7g70wayPC0Xq/gttY0Kw5rvruO2NUyTkdHGkzzdsPTaNUaOaxWQ4gDU7r+gIc3KWyyw4nGDkPeJqv7EQiX4iewKVs88rYK5zjsfTr7asIARdNBTRcg+g67bQO3oYeI6nTD0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 12:48:22AM +0000, David Matlack wrote:
> On 2026-09-16 06:50 PM, Bjorn Helgaas wrote:
> > On Fri, Sep 11, 2026 at 04:44:02PM +0000, David Matlack wrote:
> > > On 2026-09-10 06:48 PM, Bjorn Helgaas wrote:
> > > > On Tue, Jul 28, 2026 at 10:09:55PM +0000, David Matlack wrote:
> > > > > Set up a File-Lifecycle-Bound (FLB) handler for the PCI core to enable
> > > > > it to participate in the preservation of PCI devices across Live Update.
> > > > > Essentially, this commit enables the PCI core to allocate a struct
> > > > > (struct pci_ser) and preserve it across a Live Update whenever at least
> > > > > one device is preserved.
> > > > 
> > > > I assume pci_ser is the state the PCI core needs to preserve across
> > > > kexec so the new kernel's enumeration doesn't interrupt the device
> > > > operation.  And that whatever state the endpoint drivers need to
> > > > adopt/inherit the device in the new kernel is managed without any help
> > > > from the PCI core?
> > > 
> > > Yes.
> > > 
> > > > > Preserving PCI devices across Live Update is built on top of the Live
> > > > > Update Orchestrator's (LUO) support for file preservation. Drivers are
> > > > > expected to expose a file to userspace to represent a single PCI device
> > > > > and support preservation of that file. This is intended primarily to
> > > > > support preservation of PCI devices bound to VFIO drivers.
> > > > 
> > > > Where do drivers expose this file?  sysfs?  I guess it's a file per
> > > > preserved device?  Thinking like a driver writer, I'm expecting a hint
> > > > about how to expose this file (should also be in the file doc somehere
> > > > if it's not already).
> > > 
> > > There is no requirement about how drivers do this from the PCI core
> > > perspective. For all intents and purposes, the VFIO PCI variant drivers
> > > are the only drivers that are going to be supported in the next 1-2
> > > years. They expose a misc character device for each file.
> > 
> > If this file isn't relevant to the PCI core, maybe we don't need to
> > mention it here.  It doesn't seem like it motivates this patch.
> > 
> > > > > This commit enables drivers to register their liveupdate_file_handler
> > > > > with the PCI core so that the PCI core can do its own tracking and
> > > > > enforcement of which devices are preserved.
> > > > > 
> > > > >   pci_liveupdate_register_flb(driver_file_handler);
> > > > >   pci_liveupdate_unregister_flb(driver_file_handler);
> > > > 
> > > > So a driver calls pci_liveupdate_register_flb() once, then
> > > > pci_liveupdate_preserve() once for each device it wants preserved?
> > > 
> > > Yes
> > > 
> > > > > When the first file (with a handler registered with the PCI core) is
> > > > > preserved, the PCI core will be notified to allocate its tracking struct
> > > > > (pci_ser).
> > > > 
> > > > The passive voice here makes the actors a bit obscure.  I guess a
> > > > LIVEUPDATE_SESSION_PRESERVE_FD ioctl on some per-device file kicks
> > > > this off?
> > > 
> > > Yes. (And I will reduce the passive voice in the next version.)
> > > 
> > > > I guess the pci_ser allocation is in
> > > > pci_liveupdate_flb_ops.preserve(), i.e., pci_flb_preserve()?
> > > 
> > > Yes.
> > > 
> > > > So the PCI core tracker (pci_ser) isn't actually allocated at the time
> > > > of pci_liveupdate_register_flb(); it's allocated on the first
> > > > LIVEUPDATE_SESSION_PRESERVE_FD ioctl for a driver that has called
> > > > pci_liveupdate_register_flb()?
> > > 
> > > Yes. The first device that gets preserved triggers the allocation of
> > > struct pci_ser. And the last device that gets unpreserved (preservation
> > > cancelled) triggers the freeing of struct pci_ser.
> > > 
> > > > IIUC the call tree for that ioctl looks something like this:
> > > > 
> > > >   <driver>
> > > >     pci_liveupdate_register_flb
> > > >       liveupdate_register_flb(fh, &pci_liveupdate_flb)
> > > > 
> > > >   luo_session_ioctl
> > > >     op = &luo_session_ioctl_ops[...]
> > > >     op->execute                               # eg luo_session_preserve_fd()
> > > >       luo_session_preserve_fd
> > > >         luo_preserve_file
> > > >           luo_flb_file_preserve
> > > >             luo_flb_file_preserve_one
> > > >               if (outgoing_count == 0)        # only for first FLB device
> > > >                 flb->ops->preserve            # eg pci_flb_preserve()
> > > >                   pci_flb_preserve
> > > >                     ser = kho_alloc_preserve  <-- alloc pci_ser
> > > >                 outgoing.count = 1
> > > >           fh->ops->preserve                   # something not included here
> > 
> > So IIUC this part of the path looks like this, which answers my
> > question below about ordering of pci_ser and
> > pci_liveupdate_preserve():
> > 
> >               fh->ops->preserve                   # eg vfio_pci_liveupdate_preserve()
> >                 vfio_pci_liveupdate_preserve
> >                   pci_liveupdate_preserve
> >                     pci_liveupdate_preserve_device
> >                       dev_ser = pci_flb_alloc_dev_ser  <-- alloc per-dev PCI core serialized state
> >                       dev_ser->bdf = pci_dev_id(dev)
> > 
> > > > Seems like kind of an awkward way to allocate pci_ser.  Couldn't it be
> > > > allocated on the first call to pci_liveupdate_register_flb()?  That
> > > > would be a lot easier for driver writers to trace through.
> > > 
> > > I agree the LUO FLB API is a bit awkward, but this is how it works.
> > > 
> > > If we allocated it during pci_liveupdate_register_flb() we would then
> > > need to stash it in a global variable to hand-off the LUO later. Despite
> > > the awkwardness of FLBs, it is useful to avoid globals and have LUO
> > > management the lifetime.
> > 
> > It seems like pci_ser is a singleton by design, so a global variable
> > doesn't sound like it would be terrible to me.
> > 
> > > > > When the last file is unpreserved (i.e. preservation
> > > > > cancelled) the PCI core will be notified to free struct pci_ser.
> > > > 
> > > > There's a lot going on behind "PCI core will be notified".  I assume
> > > > these refer to the first-time behavior of luo_flb_file_preserve_one()
> > > > and last-time behavior of liveupdate_flb_put_outgoing(), which is
> > > > honestly kind of hard to suss out.
> > 
> > Could we say something specific and PCI-related here, to help connect
> > the dots?  Most of these paths are outside the PCI core.
> > 
> > IIUC luo_session essentially has a refcount (outgoing.count)
> > incremented by each LIVEUPDATE_SESSION_PRESERVE_FD ioctl, and the 0->1
> > transition in luo_flb_file_preserve_one() ends up calling
> > pci_flb_preserve(), where pci_ser is allocated.
> > 
> > And the refcount is decremented by luo_flb_file_unpreserve() (in a
> > luo_session .release() function), where the 1->0 transition in
> > liveupdate_flb_put_outgoing() calls pci_flb_unpreserve() where pci_ser
> > is deallocated.
> > 
> > That gets into a lot of detail, probably too much for a commit log.
> > Maybe mentioning the function names by which the PCI core is notified
> > to alloc/free pci_ser would be enough of a bread crumb.
> > 
> > > > This series doesn't include a caller of pci_liveupdate_preserve() (or
> > > > pci_liveupdate_register_flb()), so I can't figure out the ordering.
> > > > Obviously pci_liveupdate_register_flb() must be first.
> > > 
> > > In every version of this patch series I have sent I included a link to
> > > the vfio-pci driver changes that build on top of this, rebased that
> > > series on top of this one, uploaded it to my GitHub, and included a link
> > > in the cover letter. Here is the relevant section from the v8 cover
> > > letter:
> > > 
> > > . This series was tested in conjunction with v5 of the VFIO PCI driver
> > > . series:
> > > .
> > > .   https://lore.kernel.org/kvm/20260714151505.3466855-1-vipinsh@google.com/
> > > .
> > > . The full set of patches used for testing can be found on GitHub.
> > > .
> > > .   https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v8-with-vfio
> > > 
> > > 
> > > > I first thought pci_liveupdate_preserve() would be called via the
> > > > fh->ops->preserve() in the luo_session_preserve_fd() ioctl path, but
> > > > it's not.  pci_liveupdate_preserve() is intended for the driver to
> > > > call it directly.  But it looks like it has to be called *after* the
> > > > ioctl?  Obviously I'm confused :)
> > > 
> > > It is called by the driver during it's fh->ops->preserve() callback. In
> > > other words, it is called during the ioctl by the driver.
> > 
> > I think the updated call tree above shows the connection?
> 
> Yes the call tree you added above is correct. Here is an attempt at the
> complete picture that I plan to include in the kernel-doc in v9:
> 
>  * Call Flow
>  * ---------
>  *
>  * ::
>  *
>  *   # Driver initialization
>  *   pci_liveupdate_register_flb(fh)
>  *
>  *   # Userspace: ioctl(LIVEUPDATE_SESSION_PRESERVE_FD, devfd)
>  *   luo_preserve_file()
>  *     luo_flb_file_preserve()
>  *       luo_flb_file_preserve_one()      # first preserved file only
>  *         pci_flb_preserve()             # alloc and preserve struct pci_ser
>  *     fh->ops->preserve()                # driver callback
>  *       pci_liveupdate_preserve(dev)     # record this device in struct pci_ser
>  *
>  *   # Userspace: preservation cancelled or session torn down
>  *   luo_file_unpreserve_files()
>  *     luo_flb_file_unpreserve()
>  *       liveupdate_flb_put_outgoing()    # last unpreserved file only
>  *         pci_flb_unpreserve()           # free struct pci_ser
>  *
>  *   # ---------------- kexec ----------------
>  *
>  *   # New kernel: PCI enumeration
>  *   pci_setup_device()
>  *     pci_liveupdate_setup_device()
>  *       liveupdate_flb_get_incoming()
>  *         luo_flb_retrieve_one()         # first request only
>  *           pci_flb_retrieve()           # previous kernel's struct pci_ser
>  *
>  *   # Userspace: ioctl(LIVEUPDATE_SESSION_FINISH)
>  *   luo_file_finish_one()
>  *     fh->ops->finish()                  # driver callback
>  *       pci_liveupdate_finish(dev)       # release this device's pci_dev_ser
>  *     luo_flb_file_finish()
>  *       liveupdate_flb_put_incoming()    # last incoming file only
>  *         pci_flb_finish()               # free struct pci_ser
>  *
> 
> And here is an updated commit message that I hope explains everything more
> clearly:
> 
>  PCI: liveupdate: Set up FLB handler for the PCI core
> 
>  Set up a File-Lifecycle-Bound (FLB) handler so that the PCI core can
>  preserve its own state across a Live Update kexec.
> 
>  Preserving a PCI device across kexec requires preserving two independent
>  sets of state:
> 
>   - Driver state, e.g. everything vfio-pci needs so that userspace can
>     keep using the device in the new kernel. The driver preserves this
>     itself and the PCI core is not involved.
> 
>   - PCI core state, e.g. which devices are preserved, so that the new
>     kernel knows not to disturb them while they are still running and
>     doing DMA. That is what this commit adds, serialized into struct
>     pci_ser.
> 
>  Userspace, not the kernel, decides which devices are preserved, and it
>  does so through the Live Update Orchestrator's (LUO) support for file
>  preservation: a driver exposes a file that represents a single PCI
>  device, and userspace preserves that device with
>  ioctl(LIVEUPDATE_SESSION_PRESERVE_FD) on that file. Binding preservation
>  to a file gives it proper lifecycle management, e.g. the preservation is
>  undone if userspace cancels it or goes away. How a driver exposes that
>  file is up to the driver and invisible to the PCI core (vfio-pci variant
>  drivers, the first intended use-case, use their per-device cdev).
> 
>  LUO only knows that a file was preserved; it does not know that the

s/the/it/

>  represents a PCI device, or which one. Bridging that gap, drivers
>  register their liveupdate_file_handler with the PCI core:
> 
>    pci_liveupdate_register_flb(driver_file_handler);
>    pci_liveupdate_unregister_flb(driver_file_handler);
> 
>  LUO then refcounts the PCI core's FLB against the files preserved by
>  that handler, and that refcount drives the lifetime of struct pci_ser:
> 
>   - On the first preserved file, luo_flb_file_preserve_one() calls
>     pci_flb_preserve(), which allocates struct pci_ser and preserves it
>     with KHO.
> 
>   - On the last unpreserved file (i.e. preservation cancelled),
>     liveupdate_flb_put_outgoing() calls pci_flb_unpreserve(), which
>     unpreserves and frees struct pci_ser.
> 
>   - In the next kernel, pci_flb_retrieve() hands the PCI core the struct
>     pci_ser built by the previous kernel, whenever the PCI core asks for
>     it (e.g. during enumeration), and pci_flb_finish() frees it once the
>     PCI core is done with it.
> 
>  So the flow for preserving a device, once a driver has registered, looks
>  like this:
> 
>    ioctl(LIVEUPDATE_SESSION_PRESERVE_FD)
>      luo_session_preserve_fd()
>        luo_preserve_file()
>          luo_flb_file_preserve()
>            luo_flb_file_preserve_one()  # only on the first preserved file
>              pci_flb_preserve()         # alloc + KHO-preserve pci_ser
>          fh->ops->preserve()            # driver callback, e.g. vfio-pci
> 
>  Note that struct pci_ser is deliberately not allocated when a driver
>  calls pci_liveupdate_register_flb(). A driver can be loaded for the
>  lifetime of the machine without ever preserving a device, and there is
>  no reason to allocate memory and hand it to the next kernel in that
>  case. Letting LUO own the lifetime also means the PCI core does not have
>  to duplicate LUO's refcounting and unwind logic for preservation
>  failures, session aborts and fd close, and the incoming side
>  (retrieve/finish) comes from the same object rather than requiring a
>  separate KHO FDT entry owned by the PCI core.
> 
>  Note: This commit only allocates struct pci_ser and preserves it across
>  Live Update. A subsequent commit adds pci_liveupdate_preserve(), the API
>  drivers call from their fh->ops->preserve() callback to tell the PCI
>  core exactly which devices are being preserved.
> 
>  Note: There is no reason to check for kho_is_enabled() since it can be
>  assumed to return true. If KHO was not enabled then Live Update would
>  not be enabled and these routines would never run.

Beautiful, thanks for your patience :)

