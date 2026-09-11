Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97883C88E58
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 16:44:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 763066B008C; Fri, 11 Sep 2026 12:44:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ED1E6B0095; Fri, 11 Sep 2026 12:44:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B4E06B0096; Fri, 11 Sep 2026 12:44:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 28EFD6B008C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:44:18 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 05F851402B7
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:44:17 +0000 (UTC)
X-FDA: 85202054154.14.E160BE2
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf15.hostedemail.com (Postfix) with ESMTP id 29D84A0006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:44:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Qc8sGxeW;
	spf=pass (imf15.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789145055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sNNu1TO589CWD7onDuXMEv1eJ3q2rtxkDJ3Q314d4zo=;
	b=pd8ehVHTs8E5kPSOFiWp87kVGFBJIf1kMjjRt1G2Oi6UXV/bUSVyNWrvUZqX2Je7Nxj4ru
	o/iG+iDGB+oshDr/lItVGUKlWzxZtBRqc1aXZSQRoLIQT6yNBKvhrN2H89dLKBFDwAHG2l
	OW9gLdiO9lKHqz+lz68BgHAmlQ73S7Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Qc8sGxeW;
	spf=pass (imf15.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789145055;
	b=cO3qbFuLNWQY9jNc2A9w3Ghr+5vBE90mvrjekdvlAUqNVKzpnuEELurhjQ+SdGJFS0XgwU
	iaEWZzKGooiBOMADi7r/laCO5NPVeIcF1xAA1Lcdgtg/jEE2J2go9H/gG/yAaOZg8pFcWf
	zCCy2IWtc5FlIN5VOo/XpJ0AwchzkKw=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2d9520b9155so11560225ad.3
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789145054; x=1789749854; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sNNu1TO589CWD7onDuXMEv1eJ3q2rtxkDJ3Q314d4zo=;
        b=Qc8sGxeWksrTrAcnbZ9TXhgCHIQlc2k/qcjDKlE5lA0GmqLgj+heRrLYK89O17NbJJ
         LjwxlnpeMdDa+dAwm7y3DZqYrOOZQgJO45LgiJCkrCo4nqT3Gm42SIW33N3SqNSUpMws
         6FIh6JSEPIJ90f6QMltY5Kd1ZQ9tJvSJR5pvgMCfuQ4BEQwUE1A8sP6DmpHkGqxxaNb/
         O5o5F/gHp7o6PTk+avSDo+PwhmOFirqeITN/TGDPUlLet95vU1NYcCIzSAIaqI43KTTK
         Z8LioU2OQBF/L8GT/tS0h0lobFet5Q53sOsFeYXp5NWLV9iOqhb+YmaadaNbHXoa3YP7
         TJWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789145054; x=1789749854;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sNNu1TO589CWD7onDuXMEv1eJ3q2rtxkDJ3Q314d4zo=;
        b=fMbpoCkHpW4P1cNGdcJUitr7Ri9GnMv5ntI2D34EBQtTvMzRDgBd3ena2SLztQwi5d
         UdloHKzJj6oMOh3m3EbzqDFpuP3127w51xQB6HtRTNnZkeOLp8H/jQwXl4nt+mYuTiev
         KvsGPWZgvco8lE0nrz2wegg0lSz2XKe+bmGzuV+2AuWn6HSmYzMpQoB6dswwwXCHUdbZ
         cLdSsUPtus77eoxnalotxSjoMqFEaUhk2pMFcJZvrFNNUkqr2L0FfzoEmcziUtHm3ykm
         QIIxmEr5LfawL+wCmIW6tkPn1TJ+gGA7100pjmhPzC2PdM1/YUB4K3BIR9BofKA8iNFG
         +ACQ==
X-Forwarded-Encrypted: i=1; AKwUvBxRrQKoA72XyL1dVt/NByjQMHcCX32MgRnN3QxHXM95pr89wN0t3MYxTq2RnZRL2my4RTqyRn1dfA==@kvack.org
X-Gm-Message-State: AFuF++mqEF7Bnv1n1OIYhXxs/ekxhCCDvwQBHH3X49ouVoUCkP3sr4My
	YVUEDSvUg4WhPFdoSbu8B1IodOfs94uYUnqgMsnCk02lzARnvs5pOg3MgyaiF/WFpg==
X-Gm-Gg: AYBFou3OjpFTJXPh0EVrrPMoFUfoabXf8YyAWWTe5JjigXgAeAp4B1jATO4OqSj+NSF
	ms5TlqVxqfWn+TPFMLtHy7VKq5wnKlHUqooCfydkZDCIliJSkCdBnE9kNmBGTQB4I+rs59hJtl1
	rqJfFGvwVmpMaC6qWmVFF81cbAQS5GiuJcDFHCADTuuJWd6YQE1Yu3d/AOEACZvqmu9gKxALFOr
	70znHF7gV9N/VeTKWEvGnG0M3lo3kLBG5VOJaMdGBwWongQE4cFPNuPOgQ+ZQ3QNXBMdY+N5Ygr
	i5FtByTQSccQkPdhWO7YTCPIQzuqMFUt6tVXeIJ4e90iqFFKRDZ8Z05EDxdWWJw76ObQYzJxVKc
	PWAtc4+cyXKw0U7m9Ai63uEgQJOZ1RwfS6mbT2Rvx3ZOUCX1kqccVPLsB8pku0jV9CpMi3pSbI5
	oLGGDKlCvL/JFZ8sVBTb6wgrO2rEoJKqnlRrLOAH6yL2jtBQ6ST1PsY4Nh5S36W8zev/b3goeLZ
	OtSiL9TBf9zBLtgo6jf+YiugJtus+qmB/4ESWZk
X-Received: by 2002:a17:902:f546:b0:2dd:40cb:a04c with SMTP id d9443c01a7336-2dd40cba291mr28022885ad.19.1789145053219;
        Fri, 11 Sep 2026 09:44:13 -0700 (PDT)
Received: from google.com (192.150.203.35.bc.googleusercontent.com. [35.203.150.192])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd2cca263fsm14640505ad.6.2026.09.11.09.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 09:44:12 -0700 (PDT)
Date: Fri, 11 Sep 2026 16:44:02 +0000
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
Message-ID: <aqQv0jJdT4xq6VWu@google.com>
References: <20260728221007.2098560-2-dmatlack@google.com>
 <20260910234824.GA366888@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910234824.GA366888@bhelgaas>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 29D84A0006
X-Stat-Signature: g97sy13rcozx8wrktmgio1obn6cwmo6m
X-Rspam-User: 
X-HE-Tag: 1789145055-370516
X-HE-Meta: U2FsdGVkX1+CoiikvEF8BdDj/qtFyz3l1oYv3d1RRYc5VyNVk7zpN0NlBnn+d4IbDJU68rOQvqgqAsR2cM9M/VQ84HKM7RyTAAxrvlzCuBAOS7NpgGNSXibDW6sPbh/Or4OWBY1om04TlIdBgBpi2InfFtOhqWJbE3RJS/aZi2iEvNoD0TREiGuTxXbr9ul9HbaQAlBKpS6MNjygTllrnx0nVn6h7tyKGQrcGLaVKtBpZ46Y2Lktiilep3HpDbPsdg2EYa+8E1B4NAV6207hVKJ362VL8+m4vIPxbLLH3Y9/K5qN+phfklDRZVtaxdRKq6MBSlSwtvyH//+IhpaFVRrSbvQtTf3Bayx5++iQug2n1LqnXe7itLK1BAHwfhjA0GZhlPNCouu5NbwYEkVX5F7tZpduzx62YuNyMliqjzl/uS/rC4EazsVw3GMs38r2gWYLmGKUQWi1MgOpwZdmH+2e/O9QYTFYYkZIh4kwYe6B0OVq1W/EZGBvL9InS78WC9dCn+FNsqMwR3jF/CsR4M6W4dXQQ9ie2yUagvtktRMKEWhpArJtrOFRnBscERwyXSXLCvZNi1ezap/8yYUjHJB7yNjn3c+zXi57Dam/y+4F2yeRUNeKyw6kCXJ+GkGzwAZvJe4hiRSRa21gVx2AgGllDzQ8uZ7lZ2DfvQ7tiTzbY5Pi1/9iy+wQ7qPY60FjvD64zw7bAR3z1KigEG5eTxKbY7OOaoJWjg76ROByioKiRdc5X8A38SlW4fDvBhzfsOk2Adh+6fDzuoNdPsLwvKd95aKxg46g3ZTFlPEO7MYW27OcEncBMJVxPuWcv9mJjjadKhDG9DlhLtPL9D0ZrPA6ueVTMTopr/UkFk0MUHOTXU8fDdzy0YuTMgMrWBVOvlOPEOMIMtWPmb7ySt3SrWihBJQVVNz3y7u2Uwkn9JY1WUy2xgi6VAPQuj4pkcKqfb2Yy528Cuk/A/ZozPc
 RvFy9UV7
 Odt0vNX4xSIiDNi0HCmKCV+fk2//fxGa4mc1DKgIL6B6YVAFOp6EeADnx8Gdx4Evj/fVZO05PWgfef79RLunVfjCqx+fU2d/XMy1R62R+prGngHhOnyPGudZAlzWlqNlBOfhouzrT1O+YSlOvsZdomWCn+O7Z01Yn/n20QAui8GSLYnOSdoXxk8uYZUGIDGvlIqJi689IeOJqvFHsGHCcDRBKDW3AV4IfCzt/jMhH2uKPQVtarp12CDjtsM6D5UvE08X2fNg3k4DaQvKGUBidZRyetc8sdz0JL08hAOXW/GprnFylF7wJEZ+16Eyq1oTSQ6ZDsdwA1Q03ZoDyBcr0/X6IeGjEdmNMpsTZZIeCFOM9cbzzvM5aT9FjQA9xWfYjI3Eagg0lO7JJGwEcVCOUZVDUHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-10 06:48 PM, Bjorn Helgaas wrote:
> On Tue, Jul 28, 2026 at 10:09:55PM +0000, David Matlack wrote:
> > Set up a File-Lifecycle-Bound (FLB) handler for the PCI core to enable
> > it to participate in the preservation of PCI devices across Live Update.
> > Essentially, this commit enables the PCI core to allocate a struct
> > (struct pci_ser) and preserve it across a Live Update whenever at least
> > one device is preserved.
> 
> I assume pci_ser is the state the PCI core needs to preserve across
> kexec so the new kernel's enumeration doesn't interrupt the device
> operation.  And that whatever state the endpoint drivers need to
> adopt/inherit the device in the new kernel is managed without any help
> from the PCI core?

Yes.

> > Preserving PCI devices across Live Update is built on top of the Live
> > Update Orchestrator's (LUO) support for file preservation. Drivers are
> > expected to expose a file to userspace to represent a single PCI device
> > and support preservation of that file. This is intended primarily to
> > support preservation of PCI devices bound to VFIO drivers.
> 
> Where do drivers expose this file?  sysfs?  I guess it's a file per
> preserved device?  Thinking like a driver writer, I'm expecting a hint
> about how to expose this file (should also be in the file doc somehere
> if it's not already).

There is no requirement about how drivers do this from the PCI core
perspective. For all intents and purposes, the VFIO PCI variant drivers
are the only drivers that are going to be supported in the next 1-2
years. They expose a misc character device for each file.

> 
> > This commit enables drivers to register their liveupdate_file_handler
> > with the PCI core so that the PCI core can do its own tracking and
> > enforcement of which devices are preserved.
> > 
> >   pci_liveupdate_register_flb(driver_file_handler);
> >   pci_liveupdate_unregister_flb(driver_file_handler);
> 
> So a driver calls pci_liveupdate_register_flb() once, then
> pci_liveupdate_preserve() once for each device it wants preserved?

Yes

> > When the first file (with a handler registered with the PCI core) is
> > preserved, the PCI core will be notified to allocate its tracking struct
> > (pci_ser).
> 
> The passive voice here makes the actors a bit obscure.  I guess a
> LIVEUPDATE_SESSION_PRESERVE_FD ioctl on some per-device file kicks
> this off?

Yes. (And I will reduce the passive voice in the next version.)

> I guess the pci_ser allocation is in
> pci_liveupdate_flb_ops.preserve(), i.e., pci_flb_preserve()?

Yes.

> So the PCI core tracker (pci_ser) isn't actually allocated at the time
> of pci_liveupdate_register_flb(); it's allocated on the first
> LIVEUPDATE_SESSION_PRESERVE_FD ioctl for a driver that has called
> pci_liveupdate_register_flb()?

Yes. The first device that gets preserved triggers the allocation of
struct pci_ser. And the last device that gets unpreserved (preservation
cancelled) triggers the freeing of struct pci_ser.

> IIUC the call tree for that ioctl looks something like this:
> 
>   <driver>
>     pci_liveupdate_register_flb
>       liveupdate_register_flb(fh, &pci_liveupdate_flb)
> 
>   luo_session_ioctl
>     op = &luo_session_ioctl_ops[...]
>     op->execute                               # eg luo_session_preserve_fd()
>       luo_session_preserve_fd
>         luo_preserve_file
>           luo_flb_file_preserve
>             luo_flb_file_preserve_one
>               if (outgoing_count == 0)        # only for first FLB device
>                 flb->ops->preserve            # eg pci_flb_preserve()
>                   pci_flb_preserve
>                     ser = kho_alloc_preserve  <-- alloc pci_ser
>                 outgoing.count = 1
>           fh->ops->preserve                   # something not included here
> 
>   pci_liveupdate_preserve
>     pci_liveupdate_preserve_device
>       dev_ser = pci_flb_alloc_dev_ser  <-- alloc per-dev PCI core serialized state
>       dev_ser->bdf = pci_dev_id(dev)
> 
> Seems like kind of an awkward way to allocate pci_ser.  Couldn't it be
> allocated on the first call to pci_liveupdate_register_flb()?  That
> would be a lot easier for driver writers to trace through.

I agree the LUO FLB API is a bit awkward, but this is how it works.

If we allocated it during pci_liveupdate_register_flb() we would then
need to stash it in a global variable to hand-off the LUO later. Despite
the awkwardness of FLBs, it is useful to avoid globals and have LUO
management the lifetime.

> > When the last file is unpreserved (i.e. preservation
> > cancelled) the PCI core will be notified to free struct pci_ser.
> 
> There's a lot going on behind "PCI core will be notified".  I assume
> these refer to the first-time behavior of luo_flb_file_preserve_one()
> and last-time behavior of liveupdate_flb_put_outgoing(), which is
> honestly kind of hard to suss out.
> 
> This series doesn't include a caller of pci_liveupdate_preserve() (or
> pci_liveupdate_register_flb()), so I can't figure out the ordering.
> Obviously pci_liveupdate_register_flb() must be first.

In every version of this patch series I have sent I included a link to
the vfio-pci driver changes that build on top of this, rebased that
series on top of this one, uploaded it to my GitHub, and included a link
in the cover letter. Here is the relevant section from the v8 cover
letter:

. This series was tested in conjunction with v5 of the VFIO PCI driver
. series:
.
.   https://lore.kernel.org/kvm/20260714151505.3466855-1-vipinsh@google.com/
.
. The full set of patches used for testing can be found on GitHub.
.
.   https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v8-with-vfio


> I first thought pci_liveupdate_preserve() would be called via the
> fh->ops->preserve() in the luo_session_preserve_fd() ioctl path, but
> it's not.  pci_liveupdate_preserve() is intended for the driver to
> call it directly.  But it looks like it has to be called *after* the
> ioctl?  Obviously I'm confused :)

It is called by the driver during it's fh->ops->preserve() callback. In
other words, it is called during the ioctl by the driver.

LUO just knows that a file has been preserved and what preserve()
callback it needs to run to preserve that file. It is has no idea which
files correspond to devices or which devices. The file could be a memfd
for all LUO knows. That's why the driver has to call into the PCI core
via pci_liveupdate_preserve() to let it know that a device is being
preserved, and which.

