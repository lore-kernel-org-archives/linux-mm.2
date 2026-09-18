Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4815C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 00:48:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97C8F6B008A; Thu, 17 Sep 2026 20:48:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 954D36B008C; Thu, 17 Sep 2026 20:48:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81C0D6B0092; Thu, 17 Sep 2026 20:48:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B20A6B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:48:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E37AC40538
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:48:30 +0000 (UTC)
X-FDA: 85225047180.05.BF9A3AB
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1444440009
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:48:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rnw0h+b5;
	spf=pass (imf17.hostedemail.com: domain of dmatlack@google.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789692509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MH5QEcAdSFYOoMIMiWDV8W/y30UDqiHCwxXnldaYp0E=;
	b=m0ab0NRC0n/yuPLiJNtyEtTQzv4K4O0+lqLxDRpoIbVOgmZT977ILsJXa69LdarpT4g4sl
	hEFvvBT807xby9xNz2GmToPxl8MllXNdK/vbkGs0apBw8pn1c93Xk+qA0iys7tG25TSCYP
	8MsMzxT9mcB2QrMHxm2lkHoSln+NBFE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rnw0h+b5;
	spf=pass (imf17.hostedemail.com: domain of dmatlack@google.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789692509;
	b=BoW2gI3mC1sPtC+iYTDxHcjUgx3ZOfwrN3Y+XkZxLOycVJU1OhZoZN6L5oeGYyeNp4E1HR
	RPSXevTRlqQZpIH490XS0WFhK3SBH33WtXa3fbIt4ULcGtLGMVoviaPZNwN07KkgWwBXqh
	rVikSKThauIeAvf1LcQIua+agSNmD+w=
Received: by mail-pj2-f43.google.com with SMTP id d9443c01a7336-2db1ca069c8so1655485ad.3
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 17:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789692508; x=1790297308; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MH5QEcAdSFYOoMIMiWDV8W/y30UDqiHCwxXnldaYp0E=;
        b=rnw0h+b5OIboRSC3Y59KAy9rSgjWduNKPvI8V1pFDg54wyYGfr716DafTXIcYwfSNu
         psIQC2OSRHpYkCcMz8lyDOk5zJzI6+3ocKnvSbFobrBUzt9rb8ZvDpJ/O2IgR3h3AJUT
         CdUaoKYF1iIOLd0suKDl27BlD/9Be31CIqSV37OJECpXLLKe9FNdoC58LOeCCjBozkJx
         0ayV02mI39BgDq3HyHK47Qy7a0MCM9LriLEA6jMi4SGHkbxqQIzHsYLDF8W7bNL7bVUd
         ru5b1X8bVfAtb4HCzeMe9eyDnqy78zOOEAqJkhetXs/VTq9wwhug8y/MKtOAir0iZkZ9
         C0Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789692508; x=1790297308;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MH5QEcAdSFYOoMIMiWDV8W/y30UDqiHCwxXnldaYp0E=;
        b=Ta4lipss+zqfH3fsTqQn9SEzikzuaRlDXhbkbJC5jJpOHfv9l+t9cuUyWLK1YcMzMC
         9X88gwQSA3WpwIRtXqs/E1qRhEK6fqHeQ925UXkiJEqE2EhiCwDBxBl3PF+vs0UH6c1b
         W4kJZBJTyOonKZqMk+TXTBc6RnsHQRJlAxL0ukqvz6u7ZPfUMsitHlAbYxnu6IbSOXaD
         pWwB+/MzZgVJO+ThWRp0NZVKl6Unv3lcBE5lg0vfMX213ua2S2mc5l5ykdQ8pY3BxMsN
         IEf030qtI7gfiYBbQU9SbJNYUmZvYExhsNAjLclhyvWvIIC1sih3Xlec7+Jx1ief6r8G
         ug5g==
X-Forwarded-Encrypted: i=1; AKwUvBzWLU3B3CzKHfWR9rQ79RJli/jPkdkiM4Mx4DMz6LzXYUa2HPn7V4Cp0Aofvv2xTOoS6iOrVDfZYg==@kvack.org
X-Gm-Message-State: AFuF++kP1ZxMidVVaaBWZfk9uSoXeyzYgtJ7Lgf6uHfu8nUDOOHJJVaA
	494HXCfI70WjHvUnI3/Bkh7QPiqWyTnCb51FxK7RDXeOZlLiioa4R4x3xpCC3L/8gg==
X-Gm-Gg: AYBFou343C9xaDICoqwXckOEn9ecSb83iJqVct4iBF5Ce1npFQ6JglzhbQnh2WznmqM
	kljicjNqUZp4mm0S1iE+A40mWAryMHqkCRgpIPCdQoexAxOr83sYvfskFXjwLHPfWI1xK2+/RhA
	VaJzhssI3TAFPdwEg7vA877IkB8rJkPPHtYnTaje5dV3pVn24dXQLcoigDbsCJfjM4ogeqKZ6sx
	UkLxfHvKDBl00+ehiJFINs70F75qLYOllvmz7Z9euQeu75Pw6QaLypBncRPj8CDTyovvR95vb5+
	ntaYMnkeHFeLEVgf39v6jDlBJjNy3Gz/q4l/C7ShTV+Dq8HCr2KaJIa7o2Cl+b30NSxKifWCDJo
	p9dU0qyqEoA5FllJadTJecpMtIDc4p3VBB3omIuiEHRRT0ygiG5AOSKBK1epJQUH/wKBDPbyJIN
	9o3yaQwXaaZyjhpIqDyWvMM/xfKPd26K+O3NUgWLQyBfUdQV1aQ2Ox9Yh2EQMa5gHVP2DMcAhY1
	JQ5SYhnmtPgT5rYU3qG1z8QKwarqFlL9+H62pvpiaYKL1E3X04=
X-Received: by 2002:a17:90b:2ecb:b0:39e:4c7f:8b1c with SMTP id 98e67ed59e1d1-39e54d4cb89mr1939357a91.33.1789692507312;
        Thu, 17 Sep 2026 17:48:27 -0700 (PDT)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e5a0e8ca0sm201754a91.2.2026.09.17.17.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 17:48:26 -0700 (PDT)
Date: Fri, 18 Sep 2026 00:48:22 +0000
From: David Matlack <dmatlack@google.com>
To: Bjorn Helgaas <helgaas@kernel.org>
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
Message-ID: <aqyKVkIH58DK0EZO@google.com>
References: <aqQv0jJdT4xq6VWu@google.com>
 <20260916235041.GA989143@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916235041.GA989143@bhelgaas>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1444440009
X-Stat-Signature: 4d3aisb4bbtpp743qmzo6ycbppi1wxud
X-Rspam-User: 
X-HE-Tag: 1789692508-132152
X-HE-Meta: U2FsdGVkX1/+R620ut6CXFDQbKueXPD0baHjEV8kSxIfRQHzJHAF95pjEZ9RXH8uTtLMAmVqfzRNmzlQ8bhz6BImQzAVaxxpgUEl2Ch+bRbvQyfP0bk3juvVg/kucVkUt2SZJYnCjlcT90wACD3jOcpQET28TCfjq7rwkpxDaAANxU/fZgOhAd/71DMnx/YwuCxufPnCnDVVkpXAmYnYl+RA+6CeNZf55/08nCM5L53ErkY6/ThL9z1jV5plbz8rPPKzAIpxadAMk7cWJ88ftu2ft+jej/+M/QGj0SBEBi6eC1ZvUrvQr5S97nuSMjLn3IvRvHFmSVHBml4VjWdFJgAKvBtMww3iGzzsNA9J25cN7E/iMB8YLXtTCDgpAbNqIN3Z+gbVgPLdtqto7cDq853MFhwGavTMDyIrkQ7HCGpf6cebIPDVP8Bdx2Q/rkO4twgPwcrqJMq3EW6VIqBMZVhdgsYDdSdh1HS3H8PrNgDjCJwwVEvtqGOh0Ki8Iqw0vXP3VAYwFkAa/X3zcHYwraVhmX1CGno9FKupQ+GajonBmq2zQbOu9a3ZH/z7fnaC8oRHLniQDOOBvjhLaeQevpRtEzviu9i/0PExIxfNVTYQ7Z8qQEDOIw9jrtE1cQyWUyEma8/leVs5V0vPNIDn/NsJ50NMoWP2j0BkjvqLeViUru2vtPpuZgMzDnMFdJhWm/H4DvJ5dIGP7hsqeMuZtIPJlzpr/Mkj83CNHYOnadYkHltwsTNhpQiqKNhWSgLVYEzswUSHuZibgQYjOZi4Gr1RZPNqbZy8f3njBjnSe62GhCjSOJeNsd4iRulFzQ6LTh0saWGk/z3fxEcbnvKPdsj7aT/ycrwYD6+disUZR1EvkORFHlXCGjUSeMW1omLI0NvNSUtCs3ZIoQz8wkedb7UqnV2qkP84zfdkTIe1ZmZL/930e6chZ/pLr0QdzuUN3b7VT9N7fETKzHO9npu
 s99DNG9H
 YrsAQo5pS3wi5h7qj7JdIjmFMBJs9dj20DOoDZzZ2WISL3uGsN4xcDoXaFP8sLkp9PqaOzbzuKE/Nz5fuVXg2O7PFTwMLLkUkFbA07T7deyqW4FHqWQpx3/rqf8r80TH4atZho79eHaLupSRlnN13WsFYuPldlSrP9uerUfM8oBP6Ti6MauKm5SRojTjYT7mgPh+yA0jROkP560PoGYAS2RODn4Tz1qAkMR1dAF2fjB2rqAvMqrEBF05jxxqAhF8jDUqWj4lyoWKpcND2ZGqSqvmeRxicsREUZAWWjqkD6pjHB9+TvlhMW1pvyhw8HMvptenvnJvW6frAn5Qu34b5fZgrKwc6KAbE9Oq8hRSIgDmx//R3RQDyBrXkLlrZWGUiCs4bfxNj40tpZB8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-16 06:50 PM, Bjorn Helgaas wrote:
> On Fri, Sep 11, 2026 at 04:44:02PM +0000, David Matlack wrote:
> > On 2026-09-10 06:48 PM, Bjorn Helgaas wrote:
> > > On Tue, Jul 28, 2026 at 10:09:55PM +0000, David Matlack wrote:
> > > > Set up a File-Lifecycle-Bound (FLB) handler for the PCI core to enable
> > > > it to participate in the preservation of PCI devices across Live Update.
> > > > Essentially, this commit enables the PCI core to allocate a struct
> > > > (struct pci_ser) and preserve it across a Live Update whenever at least
> > > > one device is preserved.
> > > 
> > > I assume pci_ser is the state the PCI core needs to preserve across
> > > kexec so the new kernel's enumeration doesn't interrupt the device
> > > operation.  And that whatever state the endpoint drivers need to
> > > adopt/inherit the device in the new kernel is managed without any help
> > > from the PCI core?
> > 
> > Yes.
> > 
> > > > Preserving PCI devices across Live Update is built on top of the Live
> > > > Update Orchestrator's (LUO) support for file preservation. Drivers are
> > > > expected to expose a file to userspace to represent a single PCI device
> > > > and support preservation of that file. This is intended primarily to
> > > > support preservation of PCI devices bound to VFIO drivers.
> > > 
> > > Where do drivers expose this file?  sysfs?  I guess it's a file per
> > > preserved device?  Thinking like a driver writer, I'm expecting a hint
> > > about how to expose this file (should also be in the file doc somehere
> > > if it's not already).
> > 
> > There is no requirement about how drivers do this from the PCI core
> > perspective. For all intents and purposes, the VFIO PCI variant drivers
> > are the only drivers that are going to be supported in the next 1-2
> > years. They expose a misc character device for each file.
> 
> If this file isn't relevant to the PCI core, maybe we don't need to
> mention it here.  It doesn't seem like it motivates this patch.
> 
> > > > This commit enables drivers to register their liveupdate_file_handler
> > > > with the PCI core so that the PCI core can do its own tracking and
> > > > enforcement of which devices are preserved.
> > > > 
> > > >   pci_liveupdate_register_flb(driver_file_handler);
> > > >   pci_liveupdate_unregister_flb(driver_file_handler);
> > > 
> > > So a driver calls pci_liveupdate_register_flb() once, then
> > > pci_liveupdate_preserve() once for each device it wants preserved?
> > 
> > Yes
> > 
> > > > When the first file (with a handler registered with the PCI core) is
> > > > preserved, the PCI core will be notified to allocate its tracking struct
> > > > (pci_ser).
> > > 
> > > The passive voice here makes the actors a bit obscure.  I guess a
> > > LIVEUPDATE_SESSION_PRESERVE_FD ioctl on some per-device file kicks
> > > this off?
> > 
> > Yes. (And I will reduce the passive voice in the next version.)
> > 
> > > I guess the pci_ser allocation is in
> > > pci_liveupdate_flb_ops.preserve(), i.e., pci_flb_preserve()?
> > 
> > Yes.
> > 
> > > So the PCI core tracker (pci_ser) isn't actually allocated at the time
> > > of pci_liveupdate_register_flb(); it's allocated on the first
> > > LIVEUPDATE_SESSION_PRESERVE_FD ioctl for a driver that has called
> > > pci_liveupdate_register_flb()?
> > 
> > Yes. The first device that gets preserved triggers the allocation of
> > struct pci_ser. And the last device that gets unpreserved (preservation
> > cancelled) triggers the freeing of struct pci_ser.
> > 
> > > IIUC the call tree for that ioctl looks something like this:
> > > 
> > >   <driver>
> > >     pci_liveupdate_register_flb
> > >       liveupdate_register_flb(fh, &pci_liveupdate_flb)
> > > 
> > >   luo_session_ioctl
> > >     op = &luo_session_ioctl_ops[...]
> > >     op->execute                               # eg luo_session_preserve_fd()
> > >       luo_session_preserve_fd
> > >         luo_preserve_file
> > >           luo_flb_file_preserve
> > >             luo_flb_file_preserve_one
> > >               if (outgoing_count == 0)        # only for first FLB device
> > >                 flb->ops->preserve            # eg pci_flb_preserve()
> > >                   pci_flb_preserve
> > >                     ser = kho_alloc_preserve  <-- alloc pci_ser
> > >                 outgoing.count = 1
> > >           fh->ops->preserve                   # something not included here
> 
> So IIUC this part of the path looks like this, which answers my
> question below about ordering of pci_ser and
> pci_liveupdate_preserve():
> 
>               fh->ops->preserve                   # eg vfio_pci_liveupdate_preserve()
>                 vfio_pci_liveupdate_preserve
>                   pci_liveupdate_preserve
>                     pci_liveupdate_preserve_device
>                       dev_ser = pci_flb_alloc_dev_ser  <-- alloc per-dev PCI core serialized state
>                       dev_ser->bdf = pci_dev_id(dev)
> 
> > > Seems like kind of an awkward way to allocate pci_ser.  Couldn't it be
> > > allocated on the first call to pci_liveupdate_register_flb()?  That
> > > would be a lot easier for driver writers to trace through.
> > 
> > I agree the LUO FLB API is a bit awkward, but this is how it works.
> > 
> > If we allocated it during pci_liveupdate_register_flb() we would then
> > need to stash it in a global variable to hand-off the LUO later. Despite
> > the awkwardness of FLBs, it is useful to avoid globals and have LUO
> > management the lifetime.
> 
> It seems like pci_ser is a singleton by design, so a global variable
> doesn't sound like it would be terrible to me.
> 
> > > > When the last file is unpreserved (i.e. preservation
> > > > cancelled) the PCI core will be notified to free struct pci_ser.
> > > 
> > > There's a lot going on behind "PCI core will be notified".  I assume
> > > these refer to the first-time behavior of luo_flb_file_preserve_one()
> > > and last-time behavior of liveupdate_flb_put_outgoing(), which is
> > > honestly kind of hard to suss out.
> 
> Could we say something specific and PCI-related here, to help connect
> the dots?  Most of these paths are outside the PCI core.
> 
> IIUC luo_session essentially has a refcount (outgoing.count)
> incremented by each LIVEUPDATE_SESSION_PRESERVE_FD ioctl, and the 0->1
> transition in luo_flb_file_preserve_one() ends up calling
> pci_flb_preserve(), where pci_ser is allocated.
> 
> And the refcount is decremented by luo_flb_file_unpreserve() (in a
> luo_session .release() function), where the 1->0 transition in
> liveupdate_flb_put_outgoing() calls pci_flb_unpreserve() where pci_ser
> is deallocated.
> 
> That gets into a lot of detail, probably too much for a commit log.
> Maybe mentioning the function names by which the PCI core is notified
> to alloc/free pci_ser would be enough of a bread crumb.
> 
> > > This series doesn't include a caller of pci_liveupdate_preserve() (or
> > > pci_liveupdate_register_flb()), so I can't figure out the ordering.
> > > Obviously pci_liveupdate_register_flb() must be first.
> > 
> > In every version of this patch series I have sent I included a link to
> > the vfio-pci driver changes that build on top of this, rebased that
> > series on top of this one, uploaded it to my GitHub, and included a link
> > in the cover letter. Here is the relevant section from the v8 cover
> > letter:
> > 
> > . This series was tested in conjunction with v5 of the VFIO PCI driver
> > . series:
> > .
> > .   https://lore.kernel.org/kvm/20260714151505.3466855-1-vipinsh@google.com/
> > .
> > . The full set of patches used for testing can be found on GitHub.
> > .
> > .   https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v8-with-vfio
> > 
> > 
> > > I first thought pci_liveupdate_preserve() would be called via the
> > > fh->ops->preserve() in the luo_session_preserve_fd() ioctl path, but
> > > it's not.  pci_liveupdate_preserve() is intended for the driver to
> > > call it directly.  But it looks like it has to be called *after* the
> > > ioctl?  Obviously I'm confused :)
> > 
> > It is called by the driver during it's fh->ops->preserve() callback. In
> > other words, it is called during the ioctl by the driver.
> 
> I think the updated call tree above shows the connection?

Yes the call tree you added above is correct. Here is an attempt at the
complete picture that I plan to include in the kernel-doc in v9:

 * Call Flow
 * ---------
 *
 * ::
 *
 *   # Driver initialization
 *   pci_liveupdate_register_flb(fh)
 *
 *   # Userspace: ioctl(LIVEUPDATE_SESSION_PRESERVE_FD, devfd)
 *   luo_preserve_file()
 *     luo_flb_file_preserve()
 *       luo_flb_file_preserve_one()      # first preserved file only
 *         pci_flb_preserve()             # alloc and preserve struct pci_ser
 *     fh->ops->preserve()                # driver callback
 *       pci_liveupdate_preserve(dev)     # record this device in struct pci_ser
 *
 *   # Userspace: preservation cancelled or session torn down
 *   luo_file_unpreserve_files()
 *     luo_flb_file_unpreserve()
 *       liveupdate_flb_put_outgoing()    # last unpreserved file only
 *         pci_flb_unpreserve()           # free struct pci_ser
 *
 *   # ---------------- kexec ----------------
 *
 *   # New kernel: PCI enumeration
 *   pci_setup_device()
 *     pci_liveupdate_setup_device()
 *       liveupdate_flb_get_incoming()
 *         luo_flb_retrieve_one()         # first request only
 *           pci_flb_retrieve()           # previous kernel's struct pci_ser
 *
 *   # Userspace: ioctl(LIVEUPDATE_SESSION_FINISH)
 *   luo_file_finish_one()
 *     fh->ops->finish()                  # driver callback
 *       pci_liveupdate_finish(dev)       # release this device's pci_dev_ser
 *     luo_flb_file_finish()
 *       liveupdate_flb_put_incoming()    # last incoming file only
 *         pci_flb_finish()               # free struct pci_ser
 *

And here is an updated commit message that I hope explains everything more
clearly:

 PCI: liveupdate: Set up FLB handler for the PCI core

 Set up a File-Lifecycle-Bound (FLB) handler so that the PCI core can
 preserve its own state across a Live Update kexec.

 Preserving a PCI device across kexec requires preserving two independent
 sets of state:

  - Driver state, e.g. everything vfio-pci needs so that userspace can
    keep using the device in the new kernel. The driver preserves this
    itself and the PCI core is not involved.

  - PCI core state, e.g. which devices are preserved, so that the new
    kernel knows not to disturb them while they are still running and
    doing DMA. That is what this commit adds, serialized into struct
    pci_ser.

 Userspace, not the kernel, decides which devices are preserved, and it
 does so through the Live Update Orchestrator's (LUO) support for file
 preservation: a driver exposes a file that represents a single PCI
 device, and userspace preserves that device with
 ioctl(LIVEUPDATE_SESSION_PRESERVE_FD) on that file. Binding preservation
 to a file gives it proper lifecycle management, e.g. the preservation is
 undone if userspace cancels it or goes away. How a driver exposes that
 file is up to the driver and invisible to the PCI core (vfio-pci variant
 drivers, the first intended use-case, use their per-device cdev).

 LUO only knows that a file was preserved; it does not know that the
 represents a PCI device, or which one. Bridging that gap, drivers
 register their liveupdate_file_handler with the PCI core:

   pci_liveupdate_register_flb(driver_file_handler);
   pci_liveupdate_unregister_flb(driver_file_handler);

 LUO then refcounts the PCI core's FLB against the files preserved by
 that handler, and that refcount drives the lifetime of struct pci_ser:

  - On the first preserved file, luo_flb_file_preserve_one() calls
    pci_flb_preserve(), which allocates struct pci_ser and preserves it
    with KHO.

  - On the last unpreserved file (i.e. preservation cancelled),
    liveupdate_flb_put_outgoing() calls pci_flb_unpreserve(), which
    unpreserves and frees struct pci_ser.

  - In the next kernel, pci_flb_retrieve() hands the PCI core the struct
    pci_ser built by the previous kernel, whenever the PCI core asks for
    it (e.g. during enumeration), and pci_flb_finish() frees it once the
    PCI core is done with it.

 So the flow for preserving a device, once a driver has registered, looks
 like this:

   ioctl(LIVEUPDATE_SESSION_PRESERVE_FD)
     luo_session_preserve_fd()
       luo_preserve_file()
         luo_flb_file_preserve()
           luo_flb_file_preserve_one()  # only on the first preserved file
             pci_flb_preserve()         # alloc + KHO-preserve pci_ser
         fh->ops->preserve()            # driver callback, e.g. vfio-pci

 Note that struct pci_ser is deliberately not allocated when a driver
 calls pci_liveupdate_register_flb(). A driver can be loaded for the
 lifetime of the machine without ever preserving a device, and there is
 no reason to allocate memory and hand it to the next kernel in that
 case. Letting LUO own the lifetime also means the PCI core does not have
 to duplicate LUO's refcounting and unwind logic for preservation
 failures, session aborts and fd close, and the incoming side
 (retrieve/finish) comes from the same object rather than requiring a
 separate KHO FDT entry owned by the PCI core.

 Note: This commit only allocates struct pci_ser and preserves it across
 Live Update. A subsequent commit adds pci_liveupdate_preserve(), the API
 drivers call from their fh->ops->preserve() callback to tell the PCI
 core exactly which devices are being preserved.

 Note: There is no reason to check for kho_is_enabled() since it can be
 assumed to return true. If KHO was not enabled then Live Update would
 not be enabled and these routines would never run.

