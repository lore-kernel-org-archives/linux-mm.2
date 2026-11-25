Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EE4D606A327
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 06:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=KrYeRAFp
Received: by kanga.kvack.org (Postfix)
	id 689FF6B06B6; Wed, 25 Nov 2026 01:55:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 550F46B06A4; Wed, 25 Nov 2026 01:55:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 306ED6B0624; Wed, 25 Nov 2026 01:55:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 08BA56B091B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 01:55:36 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90AA5C0D1C
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:55:35 +0000 (UTC)
X-FDA: 85472730630.28.07CEC04
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id AF36CA000B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:55:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=KrYeRAFp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=vipinsh@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795589733;
	b=21vYh1WwzQFghrmck8uaS+gj/MltPUbBJ2xyh8W/W1DVs/PpiPkfsD2kZHhXf+gKa9psRe
	LmT+0wNK4n79DJ37NJL+xOHyS11K3dBlxsDXbv654IVZLs23ggUS3mF5i4AkPc6KlF00hw
	Z0xwuK6cmA6cFLn+Xtv7tUNXgkFYY7w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795589733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JPRUbVIzxn2NwG5vGsxVyrASfvomYL0+/SGbKSIacUs=;
	b=vvDmOobdVCtlhdPnpTxDL+jEAENxB4Hs/LiE+/gJtwe9LdmZYqAq8y0mffWYBqYGoTuhKb
	hDD1lsYO8vUAiAIHjZEueRGqhjuYs7nwOLld/yesII+2ZKOjQI9gs7T+ytl2/GwDDeK4/G
	RTFu6y0I4P3gETN5dUeS0zmIFQZ05mw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=KrYeRAFp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=vipinsh@google.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2f0afdb97abso177225ad.1
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 22:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795589732; x=1796194532; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JPRUbVIzxn2NwG5vGsxVyrASfvomYL0+/SGbKSIacUs=;
        b=KrYeRAFpjMh1oNPDvSCaPpKEzaqrS5q+I7eHUjVsBlxiSShjX8C7QTyzBLA4IZh07t
         F0tL1Gk26+n48xaTSi2djiMEknCwp3xtsVSHpmfe9uBqze9XyW7/ELvIuYTHhpHj77gG
         n1TtXvqZVv8L3vfuj2RlytYYn7TuGmuL+lw/fHjIpRtAMgrLvaqaZXszSCT7VTbY8pnL
         IQD2wTcw3whAmv9Q2dMuXasaFqEkNHr7RNHmu53T6+MkHg/nvXwGAFkl5off/HCIB7cA
         rVgTbm9zgfyJ7NyaSdxikEppNvyJVjKcX+Fh42OdiIrZcQF3znT+64dOR83MV+46lTpB
         R8zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795589732; x=1796194532;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JPRUbVIzxn2NwG5vGsxVyrASfvomYL0+/SGbKSIacUs=;
        b=wxtmzIkxE3MBYXtqvyEFe/KrReGA2QnrpG5pc2W4YMb0x0uPx9PiHN+ddSO1+Yc/DT
         8sJ5ifAI36Qx31V3Tx3Fmi6YY/NXISBjgsKXZf6/Epnw5IY8uuDH52puYC9l96O3P5xv
         IDFkBDglJj4q6GJA2xkDN9YVVDg6YlsHiinKSj62CryxHGrT5PBzcstUrd9UQeIVoPG0
         46BKl5EN+nczs+aXL1qpIlO5aD5+GOHktg8N5S9uzqko+BagdTN+eLE4lXIPMP7ciG8Z
         J99Q06ueWVbY9u53cmdOU1mAh9nATDGXbelItDvo9cChPHt5fHdRL6hp9GchKsdnvacm
         bLlA==
X-Forwarded-Encrypted: i=1; AL+hErFBjOigkF9II4zmBQ3/UKRRUjcjRMvNRO9VgmcoxX77fS0jLS03r7CAjsm58UFStxtczPFsGjgKvQ==@kvack.org
X-Gm-Message-State: APuU4Z/JADjkL+j8uZm9wH6sP2Zz7+a6gqsie6GkWaFzcvvx8DRse1XZ
	dTK+ygM3DWLoXdeUHgYE9fydVsx4NW34fk8/MhocZcgfjLCFQTNR/hc9wiAYwfPuhQ==
X-Gm-Gg: AZFdTZdg/pcdoV9QCRIyuFy83+d//8QKnK31t8+XymzuMhPpXVH7WpjJcrg5P67zBci
	/LSBKYuIbYlqICYhzsXX2UvJrz0PaXlL4d4fcs3dpT0pv4O4mvC4hbJ7lHLrZYxWYENjoB25JYX
	GDlYDJZWg+LlHgjQ4g53EHnhcokLxHxjo2hUhB/1ka/EBvMlWuK58HI4cGo5wULPJB+nq1s6skl
	4pHsPfe0SZd/iVAVs6UukYK0WLRasFRYoETq/JxDKfp7IRXfUB/cXd30DRAPidp/K/O/+I/VW9Q
	ys7FrE0pb0BeNe0Ak6GHmsmQY54y2zChLqMFr/uN+XS/UDnuffNOUFr5EjCvChgZmG7ZLKEECw5
	0Q2sYw0fzzwnkmT7QfZxyU/rzGfwxcxmbd5RPav5TIPJ0gn0Em9MzzL5guR4oLPyqUZSC3GvBSM
	/cp0JOh6kHn5zHajN84EdW8y8nzDxguwkDEDcelRiDE1mN6HmNBzCVrDTgY69NXJAMfew+YwhYc
	yPHIRiH7lNabu/6mrF245unooGYPnF//PzE48vhPDiElBFTO4fpzErclXTlYqarsSddgKxP44SC
	628XS4UeFU3NlyBxRQcReVQ+PbiVOr6a3BOEU9F2CrynWPGLGFKiSbe+rRFtTJs7940=
X-Received: by 2002:a17:903:298c:b0:2e6:1013:ad57 with SMTP id d9443c01a7336-2f0666c0739mr15428995ad.12.1795589731845;
        Tue, 24 Nov 2026 22:55:31 -0800 (PST)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6cfebdbasm8167972a12.13.2026.11.24.22.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 22:55:30 -0800 (PST)
Date: Tue, 24 Nov 2026 22:55:27 -0800
From: Vipin Sharma <vipinsh@google.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org, ajayachandra@nvidia.com, 
	alex@shazbot.org, amastro@fb.com, ankita@nvidia.com, apopple@nvidia.com, 
	bhelgaas@google.com, chrisl@kernel.org, christian.koenig@amd.com, corbet@lwn.net, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, kevin.tian@intel.com, 
	leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, mattev@meta.com, 
	michal.winiarski@intel.com, parav@nvidia.com, pasha.tatashin@soleen.com, praan@google.com, 
	pratyush@kernel.org, rananta@google.com, rdunlap@infradead.org, rientjes@google.com, 
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com, schnelle@linux.ibm.com, 
	skhan@linuxfoundation.org, skhawaja@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, 
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Subject: Re: [PATCH v6 11/27] vfio/pci: Retrieve preserved device files after
 Live Update
Message-ID: <20261125003759.GD3545683.vipinsh@google.com>
References: <20261102153656.1431701-1-vipinsh@google.com>
 <20261102153656.1431701-12-vipinsh@google.com>
 <DMZMRTXS7OSC.M79XF39ZVEWE@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DMZMRTXS7OSC.M79XF39ZVEWE@google.com>
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AF36CA000B
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 45o9npq57r3iwdr1nnqjp6fwp6ubxhq3
X-HE-Tag: 1795589733-955154
X-HE-Meta: U2FsdGVkX18GTeQLpBsG9MDr27rWzeVU/kqr4DDkt3gl/fir2o3X+LqAaYjgHkAbzczXqeervNCERjV+PSax4lSvinQmScj3t0aCY+cfCO33Cws7SgZJBr7aiZeXgsJLjYUOzdg3MoBgg0tWLZ7h0KbVDzYlXW6fUBjcU9jZ24FQyM3euff4f/w4GFJnCE8WOBsPwk+C7sLeofVMLwje6DPd+Y2Ivo5oqYVhFIjfcsZyT1fOMOqEmYzAl27j0gvyXgx6nGTdsp15Rkrtp+rjBkRysKiqhXUMsHTvV8KaNXsk16KfmK/ZUeRJ3/AX5Bu7Am2+9L8ZNqQd82dHDLw8A3pt6YOFBbmz94O5tSLUkIIJHY7UuBtyusZf2hDjFFkKKMqyTzixjiRrymqcSdCk0qfE7kiDuV6B5TQDL/5g76hDRT5h+cBPSpJcTU8SNbqMS7cCm8vvbI7v0/7jAkyvNn5/mUDoUIIFzIRBJ8t0QXEbI0arL/hGl4V/7syBclmC6Qg5qbbz0v00IANgfc3RQ5GbZpsoa6MTkrRysXuJIAHY76EKUIJEp93zu25pvP/DYdapX/49qUbsMF9SVrqdUNf4VRWiPtW0uqfp8oNMztZDUvOS1/zWmOPN/kBKukqUNQbUkp/q7TKmVZFp/qJfpHCgHuYQqzUG6R8/RQZXriemscyrNQpqzMG2Djfocst+rWPnJsi6O9LD+1jmpj6aQEJ9gOaW2ErJEhaSvmcuf/+SJPnw6zw7AIFtxtfCABf+q5ixyvGXLI2sWOYWX3hglg0IxB0h5+h1EmdJmQeOrMZhKViY/KPU0CjM+8diqbDvOYMwiB1NeAxYvVpgZ1ynPMtfWHFOfMMiOb3v1ZcyiteDv0JZbacnsKH+Fwe5c8WuGBvnnhZG4Dcq/Vtpx591/UOFiZ7rxsFPOSiUmLi8LVGv2kl9o4+TuoskWPc9wdI+bjlIANCDd9MtvXbba9W
 6uq80IvF
 53CIi5BzkjDUKnCcY6VlLcrL3sBH4+iegNQmMYnEQypk0uy1XeyE67o1d4TYRDTiLeZ5KvMg22iNqiFXgjl3PmubDU+3SbJhxd3APAP3883BGSwHWojKrZ40VR6VJMVaW2PacMCCDuo8AFaTE0PKNZm3/imiWpioGKSc5WQKaIdhvSJNpB8YftKGJ6bWlJmzMk5vIeFOgxno4c/+de1QTURQXa2u2CK0guwoyjpp2A+67SRlxOhmTsDUyFT9rrT2zGz5a/ZVzvTgQ6MI/01kUp78qtqC2wFMNWqoMeuMD5lPZb8/KhEfgcClYk8jMaFor+JGTxP7bq6yAUp/tWErjzymF2XEdz99qisBwfptv0xidmCEspw6xD589ljPlznCLBdfwAjv+GMN6MNSBZ9p7gtHrfSbcn1gQ1zbvtamU7wUJGLMAovUx6scMKWqVXsZdlRo/5TAbL4AMY7FA8ZEoUpO4kqbKJ/9zP4Ecrf9H38yj8Dbqh6tjbdK19Lt9eWao5TBW3HzfU57CN0ewdr8NwXa+QR371mwK/NzOPcxNUmqBNTwzjPhLgNfo+e6DQpNV6vFh3HGCzfVjgKc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 05:01:19PM -0800, David Matlack wrote:
> On Mon Nov 2, 2026 at 7:36 AM PST, Vipin Sharma wrote:
> > Enable userspace to retrieve preserved VFIO device files after a Live
> > Update by implementing the retrieve() and finish() file handler
> > callbacks.
> >
> > During retrieve():
> >  * Validate the handed-over struct vfio_pci_core_device_ser header,
> >    sizes, and flags.
> > [...]
> 
> Please make the commit messages in this series easier to read. They are
> mostly long bulleted lists of everything the code does, which is hard to
> follow and largely repeats the diff. A commit message should explain, in
> prose, what problem the patch solves and why it solves it this way, and
> only call out details that a reviewer can't easily get from the code.
> This applies to most of the patches in the series (e.g. PATCH 07 and
> PATCH 13 too).
> 

 I will do a better a job in the next version.

> > Do not implement can_finish(): closing a retrieved LUO session invokes
> > finish, and refusing can_finish() would leak the session and leave
> > unclaimed devices running. Instead, finish() always completes:
> >  * If the retrieved device was claimed by opening it via
> >    VFIO_DEVICE_BIND_IOMMUFD (which consumes vdev->liveupdate_incoming;
> >    subsequent patches replace the open-time reset with non-reset
> >    take-over, reject opening incoming devices other than via retrieve(),
> >    and protect incoming kept-running devices across runtime PM, dev_set
> >    resets, and non-noiommu boots), finish() simply completes its PCI
> >    Live Update participation.
> >  * If the device was not claimed (never retrieved, retrieve() failed, or
> >    retrieved but never bound via VFIO_DEVICE_BIND_IOMMUFD),
> >    vfio_pci_core_liveupdate_reset() logs one pci_warn() naming the
> >    device, clears PCI_COMMAND_MASTER, resets the function, and restores
> >    the inherited pci_saved_state just as closing the device would. If
> >    the device has a function reset but is not reset, e.g. because
> >    pci_dev_trylock() contends with a concurrent driver unbind, latch
> >    vdev->liveupdate_reset_pending so vfio_pci_core_unregister_device()
> >    completes the function reset and state restoration via
> >    vfio_pci_core_liveupdate_reset_locked() under the device lock held by
> >    device_release_driver(). Opening the device after finish() resets it
> >    like any open, so it drops the latch.
> >  * If the device was not retrieved, look it up under pci_dev_lock(),
> >    which waits for a vfio-pci probe in progress. If it is bound to
> >    vfio-pci, finish it as above. If it has no driver, clear bus
> >    mastering and reset it. Otherwise leave it to the bound driver.
> >  * Call pci_liveupdate_finish() and kho_restore_free() on every path.
> 
> This is a lot of complexity for one commit, and it's hard to review. I'd
> like to start with the simplest approach and build from there: implement
> can_finish() and have it return false until the device is fully
> retrieved, i.e. retrieved and taken over by VFIO_DEVICE_BIND_IOMMUFD.
> Then finish() only needs to free the incoming state and call
> pci_liveupdate_finish().

Closing session FD is not retriable. If it returns an error then
userspace won't be able to retry. So, only option will remain to reboot
the host.

VFIO doesn't need to impose this restriction. We discussed in LPC to not
block finish() as this call can only be tried one time in LU if
session is leaked.

> 
> That gets rid of vfio_pci_core_liveupdate_reset(),
> vfio_pci_core_liveupdate_reset_locked(),
> vfio_pci_liveupdate_finish_lookup() and its bridge and device locking,
> liveupdate_reset_pending, and most of the finish documentation. If you
> want to handle the other scenarios (devices that are never retrieved or
> never bound, devices bound to other drivers, unbind racing with finish),
> please add them in separate commits on top, each with its own
> justification.
> 
> As for closing the session leaking it and leaving unclaimed devices
> running: that only happens if userspace closes the session without
> taking over all of its devices, and leaving the device running with its
> memory still preserved is safe. Resetting the device in that case is
> something that can be added later.
> 
> It also has a nice side effect: LUO calls can_finish() on every file in
> a session before finishing any of them, so a memfd in the same session
> that the device DMAs into can't be finished before the device has been
> taken over.

If userspace has two session, memfd in one and vfio in another, we will
still have risk, where memfd is retrieved correctly and may be
closed/released due to a process crash but VFIO device still acessing memory
by continuing its DMA and potentially corrupting memory.

I am still inclined to let finish proceed without blocking via
can_finish(). I can try splitting patches.
> 
> > +static int
> > +vfio_pci_liveupdate_attach_incoming(struct vfio_pci_core_device *vdev,
> > +				    struct vfio_pci_liveupdate_incoming *in)
> > +{
> > +	guard(mutex)(&vdev->vdev.dev_set->lock);
> > +
> > +	if (vdev->liveupdate_incoming || vdev->liveupdate_claimed ||
> > +	    !pci_liveupdate_is_incoming(vdev->pdev))
> > +		return -EBUSY;
> > +
> > +	vdev->liveupdate_incoming = in;
> > +	return 0;
> > +}
> 
> The pci_liveupdate_is_incoming() check here is redundant with the one in
> vfio_pci_liveupdate_retrieve(). Nothing can clear it in between, since
> only finish() should do that (see below) and LUO holds the session mutex
> across both retrieve and finish.
> 
> The liveupdate_claimed check is redundant too: LUO only lets a token be
> retrieved successfully once, PATCH 12 prevents opening an incoming
> device any other way, and the liveupdate_incoming check already prevents
> attaching twice.

I will remove it.

> 
> > +	if (!pci_liveupdate_is_incoming(pdev) ||
> > +	    ser->cfg_size != pdev->cfg_size) {
> > +		ret = -EINVAL;
> > +		goto out_put_dev;
> > +	}
> 
> If the device isn't incoming here, that's a kernel bug. The previous
> kernel only preserves the file after pci_liveupdate_preserve()
> succeeds, the PCI core marks the device incoming when it's enumerated,
> and only VFIO's finish() should clear it. So this should be a
> WARN_ON_ONCE().

I will add a WARN_ON_ONCE().

> 
> > +	if (pci_liveupdate_is_incoming(pdev))
> > +		pci_liveupdate_finish(pdev);
> > +}
> 
> Likewise, the device must still be incoming here, so
> pci_liveupdate_finish() can be called unconditionally.
> 

Yes, I will remove it.

> > +static inline void
> > +vfio_pci_liveupdate_unregister_dev(struct vfio_pci_core_device *vdev)
> > +{
> > +	struct pci_dev *pdev = vdev->pdev;
> > +
> > +	scoped_guard(mutex, &vdev->vdev.dev_set->lock) {
> > +		/*
> > +		 * Complete a reset that finish() could not do, see
> > +		 * vfio_pci_liveupdate_finish_vdev().
> > +		 */
> > +		if (vdev->liveupdate_reset_pending) {
> > +			vfio_pci_core_liveupdate_reset_locked(vdev);
> > +			vdev->liveupdate_reset_pending = false;
> > +		}
> > +		vfio_pci_liveupdate_free_incoming(vdev);
> > +	}
> > +
> > +	if (pci_liveupdate_is_incoming(pdev))
> > +		pci_liveupdate_finish(pdev);
> > +}
> 
> VFIO should only call pci_liveupdate_finish() from its finish()
> callback (see the kernel-doc of pci_liveupdate_finish()).
> 
> If vfio-pci is unbound from an incoming device before finish(), it
> should just leave the device and its Live Update state alone. That's
> fine: if vfio-pci is bound to the device again, the device is still
> incoming and can still be retrieved. And once the device has been
> retrieved, LUO holds a reference to the device file until finish(), so
> vfio_unregister_group_dev() already blocks unbinding it like it does for
> any other open device file.
> 
> If userspace binds a different driver to the device instead, that's
> userspace's problem. The PCI core documentation already says it is the
> user's responsibility to ensure that incoming preserved devices are
> bound to the correct driver.
> 
> So I don't think the unbind path needs any Live Update handling at all.

I think this should be doable.

> 
> >  #ifdef CONFIG_VFIO_PCI_LIVEUPDATE
> >  	bool			liveupdate_frozen;
> >  	bool			liveupdate_intx_disabled;
> > +	bool			liveupdate_claimed;
> > +	bool			liveupdate_reset_pending;
> > +	struct vfio_pci_liveupdate_incoming *liveupdate_incoming;
> >  #endif
> 
> With the simpler finish(), I don't think liveupdate_claimed or
> liveupdate_reset_pending are needed.
> 
> PATCH 13 later inverts liveupdate_claimed into liveupdate_kept_running
> and uses it to block dev_set resets while a preserved device is still
> running. That can use pci_liveupdate_is_incoming() instead. It blocks
> resets until finish() rather than until take-over, but since finish()
> now requires take-over, userspace controls that window. If some flag is
> still needed later, please introduce it once with its final name and
> meaning instead of adding it here and inverting it in PATCH 13.

