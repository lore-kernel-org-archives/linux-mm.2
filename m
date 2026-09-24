Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6587C98318
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 21:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE0246B008C; Thu, 24 Sep 2026 17:59:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D91776B0092; Thu, 24 Sep 2026 17:59:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C81176B0093; Thu, 24 Sep 2026 17:59:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9C8336B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 17:59:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A13BB1C2D7C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:59:22 +0000 (UTC)
X-FDA: 85250022564.14.9E9F492
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf06.hostedemail.com (Postfix) with ESMTP id C1807180003
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:59:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YBzEinXx;
	spf=pass (imf06.hostedemail.com: domain of dmatlack@google.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790287160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NevIoRhVPx1e2+eEuK5IsXEei6EeRuHGTwV+ThnOoJ8=;
	b=C4t07H7NJxDBVYiswmPRzVJ7hByfLwxk0V9Zej1MdUz1w2fU/vcp+H+/eYcFTUFk6ENsWX
	G/Ss9JoVr5l8hDlTcubbKq/MicOn8WfJM6ik9d5QfXNvADgBNqtMrrXfRrqAt3RQEHzKYE
	ZvBQjNva7oui3iLrIdFA20kHJ4pd/10=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YBzEinXx;
	spf=pass (imf06.hostedemail.com: domain of dmatlack@google.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790287160;
	b=UH5+PVQFjMwp0OX0SLoRhmErWN4FX7nT/ovzx0aiO8iD+sNjTPh3/oQLm3Gq/xkyRmbZf7
	R6LDtWILc+21J3c/nEr5xACTtGefgOqNXfLpgC6HqZ38fgHyZJhU+YFRjI8ucau4NE++26
	weuzELdOhFIo+sDG3u3EYXlVxZardYo=
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1cea50db3so87469a12.1
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790287159; x=1790891959; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NevIoRhVPx1e2+eEuK5IsXEei6EeRuHGTwV+ThnOoJ8=;
        b=YBzEinXxtQhNNZgikRkI0V7pTWC8uxuE6D4XGo0awBK22ZMGt3MmJkqvMDOIWeR/mY
         CaX09HKLfSfsh+2nL/Gdrhy1882IWdAlxWlyLoAlTtYgd8k+Yu69Aj52ink0mM5LMg6V
         UqLMl2y52m11dVZyxloK/mf0AwJYMjpeRL0FWEMQfZINMAyyXGQG207MABLuexH3Xt/R
         TddtBbuNhXuUZgSpyhEU+5OTtnHpFpYF7sxqxWhM6z7lUCd4alTgAazMfuYj2C/OFTq5
         6mX6NBekaUC31sMVRkqRg4jfvkcBceoxZsodTo0VpFTorjneuYhAjKoh/W3HeFu7XHo9
         qogg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790287159; x=1790891959;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=NevIoRhVPx1e2+eEuK5IsXEei6EeRuHGTwV+ThnOoJ8=;
        b=Lc/nbNc5mxJSNfrJoib3jLM1vNBSrDJzE8Fw2Ejy0Kj9egdFvDVXEzFcx+yKmdr6KS
         6Uic2g7QXROyufBrXYz3KDGkmu47eX9E3aMBweqaEel2HjNTAn31zCXQJroKC77Ok23J
         Q9kaC2rV+a0+LaDn1tfHzlQq5SI3q3vo5jWfY9p7YMb6s1nLGTOGQq7LPtnkqnk8y1GY
         NgEYwSYTzdpGTR/EiYTZAvLBqQOm4+R8ZsAMBvb5nP0kPgZdpsp8/ZszrAIY3zeg+n2A
         P9f/l3OW7+VMr909UK3JL4E7ADLm0oXn6QEgqp7z9NSv9ZIXNpcEPqkzGc+ReezndTfY
         Co5Q==
X-Forwarded-Encrypted: i=1; AKwUvBxYJJ+mbkO9el4CpkG2C8wRYWncfXs+24s03ONQbuJSHUGknV7vcsC2LZHiaQhPhjql5+vctV0RxA==@kvack.org
X-Gm-Message-State: AFuF++mo9EuUwC1/ielcr0KTKc+VmBagpE2SjKPmOIXQ5Lijg4uJoDh2
	g2yFX7a0uNZnyVachAeBml8Dm/8z7OWuGepFMSwRyhxtABQyjsCctFNtJ9f9vTcDug==
X-Gm-Gg: AYBFou2Yk35EyMF4Z6v2Yky7VQalgZe0o1CRWdYFH3QXZ7BQwoxTlkmcIJUleQfPw9v
	JA24GTInX2LhnRpxH5Uz8W1LgNqJaunHwSLnqYNql4arRL4QPAhJ8EJuFrp9Xy/Wwmh5m7oPckb
	0DEWPOgegzDPHEDVS/cG8J8axK3/+xuTyc2e7PqE4WrkPxdAiCHMDJStASwQMjR4A8H0IlTpX0Y
	J7FZ+OfmHA9P68xvWUVxnp/227KdgsRWbmVtmOqgVyqNNn3XPadqSA0V6UNJs3yKJ+GvcVY8c6U
	DziY9bNPCY17RNqR41o21sgWPT6u4BAi7jt5jKeKMOrNbUo7Z4pddY73bjmNOJ9IoliXWTsHJZ3
	m483dcFfQU9vtiBcfEhcGnFN3g/hUflO3GHqRNCOpdtIeufqAl+YHoY1VNkp6FRuJjGN5JeVMQH
	ELmlzMezcObvvElBaiU/U3MG9OpOgDGIiH8GIGdRqfHyPhlHrAHR42G8fRe9vbPLLsqcVJwNNwT
	9p7ayVjfJfnToOnPQJWV12uo+GzzXZna3sJH7UC
X-Received: by 2002:a05:6a20:548d:b0:3dd:a008:dc3e with SMTP id adf61e73a8af0-3de0e89e58bmr4338025637.44.1790287158837;
        Thu, 24 Sep 2026 14:59:18 -0700 (PDT)
Received: from google.com (192.150.203.35.bc.googleusercontent.com. [35.203.150.192])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc78791e4b3sm309308a12.17.2026.09.24.14.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 14:59:17 -0700 (PDT)
Date: Thu, 24 Sep 2026 21:59:11 +0000
From: David Matlack <dmatlack@google.com>
To: Zhu Yanjun <yanjun.zhu@linux.dev>
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
	Randy Dunlap <rdunlap@infradead.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v9 00/13] PCI: liveupdate: PCI core support for Live
 Update
Message-ID: <arWdLyuHJwcU5tVn@google.com>
References: <20260918200640.887030-1-dmatlack@google.com>
 <2e88b92a-d3f2-41f7-bdbe-11fd71690606@linux.dev>
 <CALzav=eJU+fnPr-QN4s7gY_Lj8Pc3T6KXfC9kiQQ=g4rPEDMuA@mail.gmail.com>
 <d4547411-eeae-46c5-a30b-12d8cdde9329@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d4547411-eeae-46c5-a30b-12d8cdde9329@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C1807180003
X-Stat-Signature: zpikktunnmj7nqz3imdco8op9z6meong
X-HE-Tag: 1790287160-67172
X-HE-Meta: U2FsdGVkX18uoc1fl0ZfP8sKGzn6m0u/KbSwc/Oy1NtWAVkdu21N6N+Gsl5tSXp+7rJzwIVIkZvzWsKXTES1g538ilqDoiKsEt8Ke7sKAM1rIntozk5qZE6oFj01GMMbNx2KJBdqf9LAUIT30pbQifvX3B8B8+Eb1fBS5vd7gquIOKh8+FNLH3FDDqPZ2d/pWFRuQ2eQkO9Sz2fsdux7Xx9tbbNIaa5kYswZSwUAEqmLoKUPOqIQav9pXyZP4GdXyYDKOdtbgMVo8KDZVQzVyp7zGytrg4Sdk4i0Fmi6EYz+5qZWhz3O6pt3KjGUU/AYk5TCvRoRvosCBYF7qZPn/yGrvXMh0Ra8QlTiXEkigr+OP4+IYsQVLb88LqsGiMqvK9/954yNbnlRJ3+FgCHKY4OI34Am6ovr8zXJVSY9JgE5XaHVmkicL6LYYNYzA3NynlFAtVweN6zmg9qLxpFgkjegd8hqfK2ZAJOpQg+jR6bZ+Yuvca5c20CpNw6LManB+TpwxFG4TViaTwVNj75Zto5R2kXjnjcF96gwbMcdav/Kd72wKyrtqjiTpCzS37pGTNEQFN+kfdK+goY535X/LFoOKombB6cg48mu9oItBmZIsFooxR4AHuKC7uRAW8gHgnC7kzlsTRpK3pO0YcAmE3sI1lc7jRt/kb5H8w51zX677E9HawCXyEvsLGhewyi26VTim6Nf0mNJ7pWmNmm+B0uYKtnNJjtL0sHyhxxP449CioYmC+lf7A+Fe7RjdoUP4XSXX8W0Xar4MPo33rFHhUyee7oZuZYIGOFlY8zimoRW6GiYVC+ewEbcaxU3Uhli5ojXDuh9jRz/eOzMZsWHV1P+fh7wtpnz1gDPQt7mcCfeNaW4RMwAk/eeCo3Nnop51TcGJr4yWAQQna+gmj9aQGUSkFL1Lg1cFy+B8BiFD9fEVqgY3nwsPZHIRcB2AbUDfriLMyHwXEHgdvIaPY8
 OQfkBBhh
 a/YKmvPMTUbhY4SzX4oY5lDI3H9IEaf3ptRdu+mNmrw0m6aC3BNMS7N84zCtXIT3spNyqyB4vFTk9TLLDDDNqARM0ryqLIySPrHsZSilnCRoYGY6snITHFlvP6wE4gduqI4x0sOH+RelR66j2senlrVOVjBrw/p6trica0lBFjqT/bOSAPiWdvbi1ecFKvK7Lse3qN38c9C4eCA+B7OG4DPhtdbKhmHLJsTsABrtuVYbdeKaBq1SvJitrvJlsBN37o0Lbqa1hyoo/ERZZhqNnvGVPA+M+oGUuLzpfI/Tlj2AVqpDqeq1N+W8JLufc68RiIk+5Xqg45kqHMWdXtbJFwcz99AbCk7S8onyfhLiKrYQiBRJPP/Cm4fR28hU3bWYGl247jscDkTWLw/k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-23 04:27 PM, Zhu Yanjun wrote:
> 在 2026/9/22 11:53, David Matlack 写道:
> > On Tue, Sep 22, 2026 at 11:36 AM Zhu Yanjun<yanjun.zhu@linux.dev> wrote:
> > > 在 2026/9/18 13:06, David Matlack 写道:
> > > > Future Work
> > > > -----------
> > > > 
> > > > Following this series, we expect to make further improvements to the PCI
> > > > core support for Live Update:
> > > > 
> > > >     - Allow P2P across Live Update by avoiding resizing or moving
> > > >       preserved device BARs and preserving all upstream bridge windows.
> > > > 
> > > >     - Support preserving Virtual Functions by preserving SR-IOV
> > > >       configuration on PFs and enumerating VFs after Live Update.
> > > Preserving the PCIe topology, bus numbers, ACS, and Bus Mastering across
> > > kexec is a foundational step for minimizing downtime.
> > > 
> > > As we look toward complete end-to-end support for DMA preservation
> > > across Live Update—especially for VFIO device passthrough and dma-buf
> > > sharing scenarios—IOMMU table/domain preservation becomes crucial to
> > > prevent IOMMU page faults when devices continue performing DMA during kexec.
> > > 
> > > I would like to ask about the current status and roadmap regarding IOMMU
> > > Live Update / KHO (Kexec Handover) support:
> > > 
> > > Is there an ongoing effort or RFC series for IOMMU handover / page-table
> > > preservation currently in development or under discussion?
> > > 
> > > How is the coordination between the PCI core Live Update mechanisms and
> > > the IOMMU subsystem being envisioned for preserving IOVA mappings (e.g.,
> > > restoring domains or handing over root tables)?
> > > 
> > > Any pointers to active discussion threads, RFCs, or future plans
> > > regarding IOMMU participation in Live Update would be greatly appreciated.
> > The first IOMMU series to support Live update, can be found here:
> > 
> >    https://lore.kernel.org/linux-iommu/20260921004834.2601285-1-skhawaja@google.com/
> 
> Thanks.
> 
> I have a question regarding the restoration sequencing when module
> dependencies are involved during a Live Update reboot.
> 
> For the standard hardware/driver stack, the sequence seems to naturally
> follow the kernel's early initcalls and device probing (e.g., IOMMU early
> hardware handover -> PCI bus topology/BME preservation -> IOMMU domain
> attach & DMA ownership claim -> VFIO/iommufd cdev binding).
> 
> However, if there is a custom kernel module or subsystem (let's call it
> Module A) that is not part of the standard PCI/IOMMU device probe callback
> chain, but strictly depends on the fully restored state of PCI, IOMMU, and
> VFIO/iommufd:
> 
> 1.
> 
>    What is the recommended or standardized way in the Live Update
>    architecture to guarantee that Module A's restoration happens
>    *after* all its underlying dependencies (PCI / IOMMU / VFIO) have
>    completely finished their restore processes?
> 
> 2.
> 
>    Is the expectation to rely on LUO (Live Update Orchestrator) phase
>    notification callbacks (e.g., late restore notifiers), Driver Core
>    mechanisms like |-EPROBE_DEFER| / |device_link|, or something else?
> 
> Any guidance on how cross-subsystem restoration order and async probe
> dependencies should be handled in the Live Update framework would be greatly
> appreciated.

Note: Some of what I write below is not yet merged into the Live Update
tree so may change. Samiullah Khawaja will be giving a talk about file
dependencies at LPC where some of these topics will be discussed.

LUO does not have a global "restore phase" or late-restore notifier.
Restoration is on-demand and driven by dependencies, and userspace does
the orchestration.

There are two types of objects that LUO manages:

1. FLB (File-Lifecycle-Bound) data, for shared/global state.

   An FLB is retrieved lazily the first time someone calls
   liveupdate_flb_get_incoming(). The PCI core does that from
   pci_setup_device() during enumeration, and the IOMMU driver does it
   when it initializes. So the order in which this global state is
   restored is simply the normal boot/initcall/probe order of the
   subsystems that use it. LUO does not impose any extra order.

2. Files in sessions, for per-object state (vfio cdevs, iommufds,
   memfds, ...).

   Files are retrieved either by userspace (LIVEUPDATE_SESSION_RETRIEVE_FD)
   or by kernel code (liveupdate_get_file_incoming()). Retrieval can
   happen in any order and is idempotent. When one file depends on
   another, the dependency is expressed between the two files, not
   through a global phase.

VFIO -> iommufd is an example to follow (see Samiullah's IOMMU series
[1] on top of Vipin's VFIO series [2]):

 - Outgoing: when a vfio cdev is preserved, iommufd_device_preserve()
   calls liveupdate_get_token_outgoing() on the iommufd file the device
   is attached to. That fails unless userspace has already preserved
   the iommufd in the same session, so the dependency is enforced at
   preserve time. The iommufd token is then recorded in the preserved
   device state.

 - Incoming: the recorded token is what connects the device back to its
   iommufd after kexec. Retrieving and re-attaching to the restored
   iommufd is the next phase of the IOMMU work, so that part is not in
   [1] yet. The building blocks are there, though:
   liveupdate_get_file_incoming() lets one file handler pull in a file
   it depends on by token (it is idempotent, so the order userspace
   retrieves in doesn't matter), and ->can_finish() lets a handler
   block LIVEUPDATE_SESSION_FINISH until everything it depends on is in
   a consistent state.

 - Device binding: vfio-pci's ->retrieve() simply fails (-ENODEV) if the
   preserved device is not bound to vfio-pci yet. There is no probe
   deferral inside LUO. Userspace is expected to make sure the device
   is bound (e.g. wait for udev) before retrieving the file. In the
   meantime the device is protected: the PCI core keeps bus mastering
   and BDFs stable, and the IOMMU core reattaches the preserved domain
   and claims DMA ownership, so no other driver can bind to it.

If you can share more about what Module A is and what state it needs to
carry across the update, I can try to go into more detail. But
generically I would recommend:

 - If Module A has state that must survive the Live Update, model it as
   a LUO file handler. If it depends on specific VFIO/iommufd files,
   record their tokens with liveupdate_get_token_outgoing() in your
   ->preserve(). Then in your ->retrieve(), get them back with
   liveupdate_get_file_incoming(). If something isn't ready yet (e.g.
   the device hasn't probed), fail ->retrieve() and let userspace retry,
   and use ->can_finish() to keep the session from finishing too early.

 - If Module A is a driver that binds to a device, the normal driver
   core mechanisms (-EPROBE_DEFER, device links) still apply for
   probe-time dependencies. Live Update doesn't replace them. But
   restoring the preserved state itself should probably go through LUO
   as above.

 - If Module A doesn't need to preserve anything itself but just
   consumes the restored VFIO/iommufd objects, the simplest option is to
   let userspace sequence it. Userspace already knows when the devices
   are bound and the FDs have been retrieved, so it can hand them to
   Module A at that point.

[1] https://lore.kernel.org/linux-iommu/20260921004834.2601285-1-skhawaja@google.com/
[2] https://lore.kernel.org/kvm/20260714151505.3466855-1-vipinsh@google.com/

