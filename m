Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A0D2CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 20:51:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6547A6B0005; Mon,  8 Jun 2026 16:51:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 605556B0088; Mon,  8 Jun 2026 16:51:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51AC36B008A; Mon,  8 Jun 2026 16:51:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 43FC16B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:51:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B65A8402FB
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:51:09 +0000 (UTC)
X-FDA: 84857940258.17.7FD54B7
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf14.hostedemail.com (Postfix) with ESMTP id D91F2100005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:51:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mLVOUmhr;
	spf=pass (imf14.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780951867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OqANBGSP00mnERvECbdyBZ/QnoUicIMj2Z9x9A+M1D8=;
	b=JrXJCmlk4Jte/Rq81ouAn1W3a7DHUaOsB/OsOq64s3CtjLEbZhqT3Lt5A5Bmx5wZ+7uphZ
	RX+VTD9GSU5wrwODGEgEXYl3jC/pBuOavy6Fr7UW8t0CloZEc+LDiX/ql0+PDrP5XlbsTb
	TwY6Wr8eDswC9v078gaX3l6DDLw60pc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780951867;
	b=HqK/XPqjoZdK2CY/B5ELfWl4J5EDtj85TVsL2XYKXtcJCfk+oGNhQUtQ1l9pMJC2W7uWLi
	ZnKW1vMYdPD2wsZ8VFQEBCxLyTt8FWO+iOIBnwaW0A8njS0TPHy5PrVEvb+bQQrsBRtl2y
	GEm4f4rUcVmTCD+UzzvEEg0pk8yZRoc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mLVOUmhr;
	spf=pass (imf14.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c85b2139015so1578398a12.2
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 13:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780951867; x=1781556667; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OqANBGSP00mnERvECbdyBZ/QnoUicIMj2Z9x9A+M1D8=;
        b=mLVOUmhr1H2y/5fHWuMWhTyFWgaGrp9mG3H6FvQ82+3I00yCowvEvcJZXbJxMYnZ5J
         Z37qXUnDRYS10UInAeonnd5iuy9Wrg/fUfm2sI7eKSbwYZqhbxWBjYEbtQfVqwXB2ZZ0
         2/7r1ZqXyXAFqrTVBFTwAfMT/hu9KACSIr1bCPHcv5UwNG1lqBYWUghlHuvcGL5ZKIy2
         fhFcow7s5vjSG3DmK7UJ3+smAOWk6Ct9qcJW1Vyu5HdhzEJCo5tdQBXMSQxl+8qzOn+q
         DkD9d2WV98AZdNGSCrkh1VuXs1e+6cv/MfO5kAwEvqsOUGBJoKnMXXnm8c8E5XZsTFzI
         wpfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780951867; x=1781556667;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OqANBGSP00mnERvECbdyBZ/QnoUicIMj2Z9x9A+M1D8=;
        b=jlSzNOYfCPlEFzagVILZWGmm/XL6Gz7Rtnqte5EiepmqFhkhyKLq3tR1zuzI5AyQw0
         MjWh1fw51yYAJQtLKnHNj+dtU8VbRR2Q8ku31onE/bNSWD+V4gFE4s81gi2+qlrRmbea
         eZSjP6qNIZeRe+7c2q8Dx+LjcXuP8C779m/06KpovfvfSFNEcPAPLCKhcRcWYUpLqmJo
         7QI72PAnvbEo2SsT8HrGdrg/TmvoCASGcKBTxgq4t2U5Zv7flsRmAYJe5LXfskGZkjYt
         MftuzaD/1jk3uOp4KKd/tGFIfgCx2EK5b9FM5KcHLiCgGy8ZeVM/vGABXgv+5fbeGNrw
         1ZmA==
X-Forwarded-Encrypted: i=1; AFNElJ+0kTH51GvnjaY3GVGvoTJ6bu77n5K+8gIa8X1X0gpdLASKqIoUgJ7t80FAWAgMJqqokluBxgQuXw==@kvack.org
X-Gm-Message-State: AOJu0Yw7gT2s9BupFl/85qo8qYuSSpaCpPnuoir7+pghyhxE78KiHQqX
	CLkq7HIqQ4cahCALJ9msG75wjV4UNY/LR7OdSChZlfNgwWf6sTrTSafVhjxHELcPrksEU61W4jQ
	w+kQeuk7/
X-Gm-Gg: Acq92OGVdUvNI8+P9bvIOFOMB38a2xfrWcP20D80Smwp/Tjs79hzc+pn7pIEe5Dn4ye
	cImsAMsppSatSG+cYf7s2XKafRzzPEDsvrVWnMAK5XZECbOboTqKjVbPhNx7FaP8LG4dKzcEZ6L
	Apmlk3q9/YbFt7x1+f3raLLpA/KmNco0oO0hpv4fXUulPt+gv0J1RIq+p/d6WDaPDHVc8j2ZAIA
	DXEyz6jjq2KrRySyZVJHIMuOnqbE44JE8zI0h1+z2XaRR7HggCGzfO4N/OlWQQQUj9AoKcchRM8
	7YGCetRsBNLWH4N1QHER4nkCGQJkS82hm1djm7RkMyLH5dXZXMXFZhMTVqAZwdWYShCqpHaYtsZ
	o4RiZ66jlV2TXId4gXtQqprcppfk7hF+eIEk4ufM1pBkKp4TMTszDM3njX/iVOymQZGwfZC24IE
	9eEp6BP3HXaSYywBhr+GxVdKUZhFkbyn1Eqgz+hXqkTGWkGQvy2VZrZoCg8PKbCxhbMYTCNloX
X-Received: by 2002:a05:6a21:a38b:b0:3b4:904f:c9cd with SMTP id adf61e73a8af0-3b4cccffc4fmr20088541637.6.1780951866181;
        Mon, 08 Jun 2026 13:51:06 -0700 (PDT)
Received: from google.com (56.149.168.34.bc.googleusercontent.com. [34.168.149.56])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85df0b315esm15840734a12.26.2026.06.08.13.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 13:51:04 -0700 (PDT)
Date: Mon, 8 Jun 2026 20:51:00 +0000
From: David Matlack <dmatlack@google.com>
To: Pranjal Shrivastava <praan@google.com>
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
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 01/12] PCI: liveupdate: Set up FLB handler for the PCI
 core
Message-ID: <aicrNNVrMBtJD2iZ@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-2-dmatlack@google.com>
 <aiJhoq_Yj6-1Hl5r@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiJhoq_Yj6-1Hl5r@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D91F2100005
X-Stat-Signature: yrffkksojqrsbnq9yo3ep39shcu11esm
X-HE-Tag: 1780951867-673611
X-HE-Meta: U2FsdGVkX1/1ino3sznhAe8VDFe7ZxvYQY7zqWZKZhVWbTzjzrxl13AdOrWYx2LQfQeLalKNEc1h/EcINOFP2Un8pmtywHy4J+xF72jSulBDzViFHxuMOdFZ2pKxWvCcs/VYoF6oLjfvNIa5LyX8hvNzHO2HfYPcfdxfYlb2vb4QP14hNvgIwNax3tYln2zmnLEdfFoegWNiKh1DmB8P24/w5z7lalx+yuPbHKMDlfhqCgfh3RvdP7CYuMRnzwFGWMzns8g5smxdDkO/e7DNNYK2aUfOs8Rr0q4nJied4v2IUDTkkOsuyRD22JINsXHJF7BmR0/ysFLC8bZr9tyPJ55rKiXQyGOgr7LCgsNpTS69VuLqdf8x5Oa5/4+HnoSrNvTOx6oY74tqPbZSCujEatpeVQ94Y+lOn0ofTYMN/U9oRagqdilU97hlylKdIeZZVWcrnk4cvJ7yAGQVWVKv8ngTWZOd0B30OZyiWsMR2eOL/Z1Ty1bJx4y1fZh8lrpq0/6Fr9y7CiQT+zeOi5wI5g5U0QqpnCh0e133gqZKl9RmaLq45yzorLu0LSGUXRbfiCipTXpZi7kp2UNPPWzrfzQuV+18o/gvaiWQFvr/seOw4ptHZE0xRD1T9CYpwLo5XVkECHIwlGyIe7NpvrHZTtIC6zcjJe6pM39OskC3KKP0mV1ftrpN7chzBn/CNGwLBiXtD6ANkzE6pSOU78O0EYLuO/fhYHh2JEztjk4gNJa+f+8VWZfb6NcJwoed/fcGu71Mfmy4dobrHXIlBcyr32OIFYNJE+CSaaeEvH45CLSaBViBhAYrvjHYt5EylKK9l/CyufBDL/bBVxH6SBxJvxk6aE/958Sfve/RTdzgAQ8l2yGwejCMDsk86AxeanbWAcavzmq5tAlHns4iHfdtkXSFRK+6pQk4zlWShLyZDQPeUC2S2mJoWi17/3A4vHkepnVI8V2C3i6vsZyx0/q
 hXj9jAQc
 rSkUOhKqfxjVXH+Ns2F3OiYAdcfKq7QeGfr7R6H3q1FXoL/isRtnCXF4okz27PyoMyeP+3LqFWRbc8ZnME+SSz/M37Ie97Hk3xgo2paSBXbkCoQfE5rc7VfuWtCFP7NUpelMLgHIeTyg+0oDP/+dTPVSU9UCMpxxb2VoOG+8GeYTs1X15mzZyAwXloElUaFJlqTVfVWm2gziaBf3aGukMGA5rMQumf9mWU/EdLGFI8QzmbixYl/sMF5UxqGjpoiqP38RPjXuS3/NITnOrpSMtTFcFXG8OmRF8Xugg4DgN7ieYZmQ79U4WmSc8FsqkOvvmmBDIKamI3WL+MkI0GyCzFYPW9/2cCL/+pAPw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-05 05:41 AM, Pranjal Shrivastava wrote:
> On Fri, May 22, 2026 at 08:23:59PM +0000, David Matlack wrote:
> > Set up a File-Lifecycle-Bound (FLB) handler for the PCI core to enable
> > it to participate in the preservation of PCI devices across Live Update.
> > Essentially, this commit enables the PCI core to allocate a struct
> > (struct pci_ser) and preserve it across a Live Update whenever at least
> > one device is preserved.
> > 
> > Preserving PCI devices across Live Update is built on top of the Live
> > Update Orchestrator's (LUO) support for file preservation. Drivers are
> > expected to expose a file to userspace to represent a single PCI device
> > and support preservation of that file. This is intended primarily to
> > support preservation of PCI devices bound to VFIO drivers.
> > 
> > This commit enables drivers to register their liveupdate_file_handler
> > with the PCI core so that the PCI core can do its own tracking and
> > enforcement of which devices are preserved.
> > 
> >   pci_liveupdate_register_flb(driver_file_handler);
> >   pci_liveupdate_unregister_flb(driver_file_handler);
> > 
> > When the first file (with a handler registered with the PCI core) is
> > preserved, the PCI core will be notified to allocate its tracking struct
> > (pci_ser). When the last file is unpreserved (i.e. preservation
> > cancelled) the PCI core will be notified to free struct pci_ser.
> > 
> > This struct is preserved across a Live Update using KHO and can be
> > fetched by the PCI core during early boot (e.g. during device
> > enumeration) so that it knows which devices were preserved.
> > 
> > Note: This commit only allocates struct pci_ser and preserves it across
> > Live Update. A subsequent commit will add an API for drivers to tell the
> > PCI core exactly which devices are being preserved.
> > 
> > Note: There is no reason to check for kho_is_enabled() since it can be
> > assumed to return true. If KHO was not enabled then Live Update would
> > not be enabled and these routines would never run.
> > 
> 
> [...]
> 
> > +/**
> > + * struct pci_dev_ser - Serialized state about a single PCI device.
> > + *
> > + * @domain: The device's PCI domain number (segment).
> > + * @bdf: The device's PCI bus, device, and function number.
> > + * @padding: Padding to naturally align struct pci_dev_ser.
> > + */
> > +struct pci_dev_ser {
> > +	u32 domain;
> > +	u16 bdf;
> > +	u16 padding;
> > +} __packed;
> > +
> > +/**
> > + * struct pci_ser - PCI Subsystem Live Update State
> > + *
> > + * This struct tracks state about all devices that are being preserved across
> > + * a Live Update for the next kernel.
> > + *
> > + * @max_nr_devices: The length of the devices[] flexible array.
> > + * @nr_devices: The number of devices that were preserved.
> > + * @devices: Flexible array of pci_dev_ser structs for each device.
> > + */
> > +struct pci_ser {
> > +	u32 max_nr_devices;
> > +	u32 nr_devices;
> > +	struct pci_dev_ser devices[];
> > +} __packed;
> > +
> > +/* Ensure all elements of devices[] are naturally aligned. */
> > +static_assert(offsetof(struct pci_ser, devices) % sizeof(unsigned long) == 0);
> > +static_assert(sizeof(struct pci_dev_ser) % sizeof(unsigned long) == 0);
> 
> Minor Nit: Shall we consider using specific bitwidth types here?
> I'm wondering if down the line another u32 field is added to 
> struct pci_dev_ser.. in that case on a 32-bit machine 12 % 4 == 0 but on
> a 64-bit machine 12 % 8 != 0..

I think natural alignment is what matters for efficient access of the
array elements. So failing the assert only on 64-bit architectures seems
like the correct behavior.

> 
> [...]
> 
> With the nit:
> 
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> 
> Thanks,
> Praan

