Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A37E0FD45F1
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 00:28:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E22CB6B0088; Wed, 25 Feb 2026 19:28:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFA6C6B0089; Wed, 25 Feb 2026 19:28:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D072C6B008A; Wed, 25 Feb 2026 19:28:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B56F46B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:28:39 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 88FCF1401D8
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:28:39 +0000 (UTC)
X-FDA: 84484721958.05.02D3CC4
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7CF131C0003
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:28:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vIv69CXG;
	spf=pass (imf20.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772065717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yFgIHLNWG5nn2bKXAGosicvw/0Yu+qAVnLqqJ5fJf90=;
	b=ZiNvaOQ6VhOEaj7J8rlOn13E27QLiwNGnyoM4CCVvplt6cu/P5jnRSmPRuQWdzL/iyaFnC
	X6/N40LiMlbKo0JncggK+XKDhfVn+4ZOyCwriZidkgwMFZkr/cpNcrBhaDiUK5sJsR75l2
	Xpp5d5KQ5aNvzZEepRSvFH0sUyl2UAI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772065717; a=rsa-sha256;
	cv=none;
	b=hJaewpipJhxZf4CgqOMCtFNeR8OpWIETZRceY8GLmZWzYY/TC1XxIFZ+kxQVmdBy7iTiqV
	i7gzUig3F1XadPzOL+5RhknZbAKMoWpdoMRgvGbfKRY0V9N7iQCOuXdm0byEm3lk/k/Ke3
	bj0cM+HzckXVmiUPAmbGvl10B0FIOog=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vIv69CXG;
	spf=pass (imf20.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-824ac5d28f9so378449b3a.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:28:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772065716; x=1772670516; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yFgIHLNWG5nn2bKXAGosicvw/0Yu+qAVnLqqJ5fJf90=;
        b=vIv69CXGX5hdISjkpPpFBbUR7pRRSE/1ONvoMZTmFPlQQUMUPl9VjoT/nAbAdTWMHN
         6jDAV379UiG7m9NWMTTlmOoNsggeTIen71AB3YWS/8/8Zbbgqq0QRDccTuRxihhvCJ60
         2yRj42Hp0FJAqRH6Kgl77ICo+j85nO4NSWRs6sULcQ8FPVKXUMjcbG5bTFnJW1jsIpPd
         qu8b0BBqj+qT1KSBXb89CH1Twf5d64IcxBBpgeZW8UGeIftTD32cxnPOXIXSwCbdg+Mw
         TaOTP9CI5X0O73xlfb0KKu7Srhs2wCRQxEVJsZMDfOdJo6Dl93Bc6Hwk7Sde5K8ZN9qP
         Nhtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772065716; x=1772670516;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yFgIHLNWG5nn2bKXAGosicvw/0Yu+qAVnLqqJ5fJf90=;
        b=A+HWhlPhgkJ6nMvVfGdWd8B7EHidEaIEReGxYox14I1aCqZoy6RHCxNk6eixIIR2fc
         +Zhnwctro4a94F/Z9+HRUH+H5NcSit81cezT97fNc5f+nozutGUp4yAYsmgZyWt2/zZc
         uGThv+d9PO/ztaYnGgMVp5e00bZDItBRlGUpmXNrypRt844991O3rzqu5QV9G/Uxy+Kp
         X4r49Z+suQaY7vXoW8LDp3QjW7ETB69MU0JEgGEOpmGqODwC9FSItFJkB5JhW8jRej4o
         89O9JAZhGn7cgBrfWObpqoymVyKA199fSb9zNpTKYtE/lBGu+0NiTJBvOCUELwDHRW2O
         VS8g==
X-Forwarded-Encrypted: i=1; AJvYcCWmZgvGuH/u5i4JOgsYkNqm21k1vdC0s5GrADF90qEevKUJYa1Xh3ea0kqwgC0j5VbphgWCpp6drQ==@kvack.org
X-Gm-Message-State: AOJu0YxkRRS/STwMWZdYBsCBq4s9FGIBxBouU1TZnbR3B44IVcpow7U7
	G1zG2GamCxqKbmjuEZBjSv3r/ANTayooiVoLkYNyNiXv0zeWO+pHDX42yL9HJFHm/w==
X-Gm-Gg: ATEYQzwkIhud3AFT/q8T7sFAppGVQjCfDZIrZPIdI6L4oSg5DiJ6m9QJ8bdcRa1Ucq8
	/Z15dY6nmK68KH3mAFTSzyZ75H2zRwVF86X5dtMe/4swAcOYEZur9UEqEXgBTgFlPzEmVQ0rS7y
	GwHXZyeBv76ROeQRKN34dFlJL2C9ikizyV1dhUxP8PSm0qIjKbKraCDpVnYOjs93b/xzYLs/1fr
	lhtqyAFs4+DBqLtN61qIVIhOteyTM9lVNVzjaDgRNTJqZhfcNGgnrHtjt9wrmi+zwOx4SJPHWUG
	688+2eoD+dpTFundA3iaOzyh4EEs0wPZE013ks3S1nWj+H1sRKLZp95wOjqoDpQ3g3v8n869tjP
	hV86WPTEQQkKKhlekUPqhF5cEu4M33Clq9dYdgVqKSdNVfSrmOUGalAI1cPKdH7P5NwQhhzRGTW
	aOrKm7bFC8xzoxvwf1CZNDIu5W4eJXD39QzBgdObwIsSJsL7+gJouB3OPw1dnPDw==
X-Received: by 2002:a05:6a00:1d8e:b0:823:1cf4:bf38 with SMTP id d2e1a72fcca58-8273366fd35mr1707567b3a.12.1772065715499;
        Wed, 25 Feb 2026 16:28:35 -0800 (PST)
Received: from google.com (239.23.105.34.bc.googleusercontent.com. [34.105.23.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8273a0299d9sm467054b3a.51.2026.02.25.16.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 16:28:32 -0800 (PST)
Date: Thu, 26 Feb 2026 00:28:28 +0000
From: David Matlack <dmatlack@google.com>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Alex Williamson <alex@shazbot.org>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Lukas Wunner <lukas@wunner.de>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
Message-ID: <aZ-TrC8P0tLYhxXO@google.com>
References: <20260129212510.967611-3-dmatlack@google.com>
 <20260225224651.GA3711085@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225224651.GA3711085@bhelgaas>
X-Rspam-User: 
X-Stat-Signature: 4jhf6xhhkqaey1z5ixwziah8m6rjpe7h
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7CF131C0003
X-HE-Tag: 1772065717-862306
X-HE-Meta: U2FsdGVkX18Sy2it4cfZ9CJdsHfl7B63ADSh4g5tk9nuQr0PLS1MOHGGUxhDf23MednCG5faX2roHcnl6/wLkBYEv6OLchVfkKxZbyIofM2pWfedZXR1D1FjESy9O+R1tzJdoI6kckzNqvyyMm2FvNW4/4qxEt8rwFc3aEJdGm5sknHqPop60cu9P56vAX9M37K+OFXL/Df/ar8irFF5oIzKMU33OOZxySYkzoz9wakqG1XZO5dGIEKJgnmeHeocAoAxBBLB/pbO6x6Ofw31acHY8ZlKi6FfX1bvUwxK9vc86HCdHFkoK2BASPJ+vMZ9AlWNce2/FVftFYoOA4kI9HnJtLeqDVQdbQfURGxg81T0iSanU8Bc6/yKCd+Qzeo58IREdrNkD6tbLa2wLMU5kocpjKS7GiswLN+fRGaXJnXGhcOygazCXS+EmhaQSoajccxpLg2gm2QdRnnKhBERSch8zkvdqjN0vC7hSaYY9eo/lR++XIUBuBHSFYWeYToZzaZfC5DjNgepTK2XDDRUDHM3m5nDToPTKzVoRK5SMM1H/7ZhxYV3T8VnpKY+OiZR/NwqNxsDNEGPXwWUECt9VmHvOremFuiDHMJyU0YMoKjHm5H67WE/Q20E+X4IVLNEm87FsL7RTaQpKXPP6kJ8ZZI/lXPgVwagphYuaHa8xdupTm3nu2AXP393dLzWkldooUfXhPNGnz4WYmscW+vSF2LbH2+F9sD2gLrrI/L5oCbJ/DhtVx4H2osCCqNL0HkrcHlUMqqgM6yvIhpzVO3Xhygpi3nByT5r0ux+QunZr0LosJPm8crY+L3i/qRS1i6aPp/CiViApVeL915pNxmtg+eI+1JGzL+ws95uCdM9fhV03ljvXGf9ZVGrYsNwriNJ7k89U+NEhVQYypp2CU/kCIVbGh8zJXDUR9fNwVoR14H1WAbR+F52GtQgySyvAEFo//xmjUlJh75A0iwDBv2
 iHp+BXD5
 RCIh3XVakcrYEVR/Rjwiyhuye5JSs0hkQwj0j59ubp+onIz8KeLQ0P/4sScsnTS8CaFEKVYx1GsEe82gwFNsKOXUpaKEp3Tu5yoiDspLT6431V4w7orojOOE3gD8J6wprBBQN1o7S57lxCubb84idPzQkcWbmyh+H0hg2HcIVBdsqO6Jexpb7KCVBIaoHr37c2zuP2mnws8+teyVIqms0wMienn3wqSoK2prgLs8gGrThnizsbm3mC+WGFDHkKJeM2pgKVfCh7xFzHTjVPZ1ejXmGsVIS2vkkBCbOStv9gi4b/E4oYgI0Q3FDZ9oa3qaJlEoXOeSdaboc5aCkQO0m4pXJbzNE47t29Esa/NGR8fJRA+H3BMFrXG596oYTm0/Um0xeMwY0b4WvLv/tGVOopLqO3VwhFpSBZfyptjwSB4hcre+mnX3sk/6Yt4llb/yZz852ylkldUaYPq8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-25 04:46 PM, Bjorn Helgaas wrote:
> On Thu, Jan 29, 2026 at 09:24:49PM +0000, David Matlack wrote:
> > Add an API to enable the PCI subsystem to track all devices that are
> > preserved across a Live Update, including both incoming devices (passed
> > from the previous kernel) and outgoing devices (passed to the next
> > kernel).
> 
> I'd probably describe this in the "outgoing ... incoming" order since
> that's the order of operation.

Will do.

> > Use PCI segment number and BDF to keep track of devices across Live
> > Update. This means the kernel must keep both identifiers constant across
> > a Live Update for any preserved device. VFs are not supported for now,
> > since that requires preserving SR-IOV state on the device to ensure the
> > same number of VFs appear after kexec and with the same BDFs.
> > 
> > Drivers that preserve devices across Live Update can now register their
> > struct liveupdate_file_handler with the PCI subsystem so that the PCI
> > subsystem can allocate and manage File-Lifecycle-Bound (FLB) global data
> > to track the list of incoming and outgoing preserved devices.
> 
> In what sense is this "global"?  I assume it doesn't mean global
> scope; does it mean something that persists across the kexec?

Global in the sense that there is only one struct pci_ser in the system.
There is no global variable for it though. It is created
pci_flb_preserve() when the first device is preserved (and destroyed
after the last device is unpreserved/cancelled).

So it's lifecycle is bound to the number of devices. It is maintained by
LUO (which does not know about devices, it just knows about files being
preserved). For the PCI FLB, each file happens to correspond to a device
(these are vfio-pci device files), but LUO doesn't need to know or care.

> 
> >   pci_liveupdate_register_fh(driver_fh)
> >   pci_liveupdate_unregister_fh(driver_fh)
> > 
> > Drivers can notify the PCI subsystem whenever a device is preserved and
> > unpreserved with the following APIs:
> >
> >   pci_liveupdate_outgoing_preserve(pci_dev)
> >   pci_liveupdate_outgoing_unpreserve(pci_dev)
> 
> IIUC this is basically asking the PCI core to preserve the generic PCI
> parts of a device, i.e., the PCI core and the driver collaborate to
> preserve it?
> 
> I know what "preserve" means: "please maintain the original state."
> The sort of made-up "unpreserve" sounds nicely symmetric, but I don't
> think it means "destroy the original state."  It feels like more of a
> "cancel" of the original request to preserve something.  Maybe not
> worth any change, but I suspect this operation is going to be part of
> the user interface for the administrator, and the description of
> "unpreserve" will probably include something like "cancel."

Yeah it is a cancel of the original request. I chose the name to match
the callback op that this function implements
(liveupdate_flb_ops.unpreserve).

> > After a Live Update, the PCI subsystem fetches its FLB global data
> > from the previous kernel from the Live Update Orchestrator (LUO) during
> > device initialization to determine which devices were preserved.
> > 
> > Drivers can check if a device was preserved before userspace retrieves
> > the file for it via pci_dev->liveupdate_incoming.
> 
> I see how drivers need to know whether their device has been preserved
> and needs to be adopted, but what does userspace have to do with this?
> 
> I don't know what the file is, but it doesn't sound related to the PCI
> core, so maybe it should be mentioned elsewhere?
> 
> I assume the PCI core preserves a device based only on the indication
> from the previous kernel.

At the Live Update Orchestrator level the PCI device preservation is
driven by userspace preserving files via ioctls. So that framing leaked
into this commit message. I will rephrase this to be more in the context
of devices that the PCI code actually cares about.

> > +/*
> > + * Copyright (c) 2025, Google LLC.
> 
> 2026

Will do.

> > +static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
> > +{
> > +	struct pci_dev *dev = NULL;
> > +	int max_nr_devices = 0;
> > +	struct pci_ser *ser;
> > +	unsigned long size;
> > +
> > +	for_each_pci_dev(dev)
> > +		max_nr_devices++;
> 
> How is this protected against hotplug?

Pranjal raised this as well. Here was my reply:

.  Yes, it's possible to run out space to preserve devices if devices are
.  hot-plugged and then preserved. But I think it's better to defer
.  handling such a use-case exists (unless you see an obvious simple
.  solution). So far I am not seeing preserving hot-plugged devices
.  across Live Update as a high priority use-case to support.

I am going to add a comment here in the next revision to clarify that.
I will also add a comment clarifying why this code doesn't bother to
account for VFs created after this call (preserving VFs are explicitly
disallowed to be preserved in this patch since they require additional
support).

> 
> > +	size = struct_size_t(struct pci_ser, devices, max_nr_devices);
> > +
> > +	ser = kho_alloc_preserve(size);
> > +	if (IS_ERR(ser))
> > +		return PTR_ERR(ser);
> > +
> > +	ser->max_nr_devices = max_nr_devices;
> > +
> > +	args->obj = ser;
> > +	args->data = virt_to_phys(ser);
> > +	return 0;
> > +}
> > +
> > +static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
> > +{
> > +	struct pci_ser *ser = args->obj;
> > +
> > +	WARN_ON_ONCE(ser->nr_devices);
> 
> What is this warning telling the user?  Is there something wrong?
> What would I do to fix things if I saw this, and how would I know what
> to do?
> 
> Is this telling us that we're undoing a "preserve" operation, which is
> supposed to involve "unpreserve" on each device that has previously
> been marked for preservation, but something (what?) forgot to
> unpreserve one of the devices?
> 
> Seems like maybe a debugging aid, but probably not something an
> indication that the administrator did something wrong?

This WARN_ON (and the others you flagged) are all "this should never
happen" scenarios. For example if this triggers it means a bug somewhere
in the kernel (likely in LUO), or some sort of corruption.

Would you prefer I omit such WARNs or should I just a better
accompanying log message or comment?

> 
> > +	kho_unpreserve_free(ser);
> > +}
> > +
> > +static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
> > +{
> > +	args->obj = phys_to_virt(args->data);
> > +	return 0;
> > +}
> > +
> > +static void pci_flb_finish(struct liveupdate_flb_op_args *args)
> > +{
> > +	kho_restore_free(args->obj);
> > +}
> > +
> > +static struct liveupdate_flb_ops pci_liveupdate_flb_ops = {
> > +	.preserve = pci_flb_preserve,
> > +	.unpreserve = pci_flb_unpreserve,
> > +	.retrieve = pci_flb_retrieve,
> > +	.finish = pci_flb_finish,
> > +	.owner = THIS_MODULE,
> > +};
> > +
> > +static struct liveupdate_flb pci_liveupdate_flb = {
> > +	.ops = &pci_liveupdate_flb_ops,
> > +	.compatible = PCI_LUO_FLB_COMPATIBLE,
> 
> I don't see anything in this series that checks this.  Maybe omit it
> until it's used?

LUO checks this when it receives preserved data from the previous kernel
and needs to hand it back to the users of that data. This prevents
passing binary data between 2 kernels that don't speak the same ABI.

> > +int pci_liveupdate_outgoing_preserve(struct pci_dev *dev)
> > +{
> > +	struct pci_dev_ser new = INIT_PCI_DEV_SER(dev);
> > +	struct pci_ser *ser;
> > +	int i, ret;
> > +
> > +	/* Preserving VFs is not supported yet. */
> > +	if (dev->is_virtfn)
> > +		return -EINVAL;
> > +
> > +	guard(mutex)(&pci_flb_outgoing_lock);
> > +
> > +	if (dev->liveupdate_outgoing)
> 
> Is there a real need to keep "dev->liveupdate_outgoing", as opposed to
> just searching ser->devices[]?  It looks like the only use is to keep
> from adding a device to ser->devices[] twice.

Yes that's the only use-case in this series. I think there will be more
usecases in the future for checking if a device is outgoing (for example
in pci_device_shutdown() to avoid pci_clear_master()). I can defer
adding this bit for now if you prefer.

> 
> > +		return -EBUSY;
> > +
> > +	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&ser);
> 
> I guess this "get" must correspond with the kho_alloc_preserve() in
> pci_flb_preserve()?  It's sort of annoying that there's nothing in the
> function names to connect them because it's hard to find the source.

Yeah, the LUO FLB flow took me a little while to wrap my head around.

liveupdate_flb_get_outgoing() actually just returns the data
pci_flb_preserve() already allocated. It does not trigger
pci_flb_preserve().

pci_flb_preserve() is triggered when the first file is preserved, for
files that have registered their file handler with PCI
(pci_liveupdate_register_fh()).

So what happens in practice is:

 0. VFIO calls pci_liveupdate_register_fh(). This is what connects VFIO
    files with pci_liveupdate_flb.

 1. Userpace preserves a vfio-pci file using
    LIVEUPDATE_SESSION_PRESERVE_FD.

    a. If this is the first file to be preserved associated with
       pci_liveupdate_flb, then LUO will call pci_flb_preserve(). This
       allocates struct pci_ser.

    b. LUO calls VFIO preserve callback to preserve the VFIO device
       file.

    c. VFIO's preserve callback calls pci_liveupdate_outgoing_preserve()
       to notify PCI of which PCI device is getting preserved.

    c. pci_liveupdate_outgoing_preserve() calls
       liveupdate_flb_get_outgoing() to get the data allocated in (a).
       Note that this data may have been allocated a long time ago since
       (a) only happens when the first device is preserved.

(And note I am saying "first" but I really mean when the count goes from
0 to 1.)

It's kind of convoluted but it has some properties that I think make it
worth it:

 - It works for any kind of file (not just devices).

 - It allows other drivers to participate in PCI preservation by
   registering thier own file handler via pci_liveupdate_register_fh()
   (so it's not VFIO-specific).

 - The lifecycle is managed by LUO (create on first file preserve,
   destroy on last file unpreserve/cancel). So it avoids PCI subsystem
   having to maintain any global variables for struct pci_ser.

> > +void pci_liveupdate_outgoing_unpreserve(struct pci_dev *dev)
> > +{
> > +	struct pci_ser *ser;
> > +	int ret;
> > +
> > +	guard(mutex)(&pci_flb_outgoing_lock);
> > +
> > +	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&ser);
> > +	if (WARN_ON_ONCE(ret))
> 
> I'm a little dubious about all the WARN_ON_ONCE() calls here.  They
> seem like debugging aids that we would want to remove eventually, so
> maybe they should just be out-of-tree to begin with.

This is another "should never happen" guard.

> > +		return;
> > +
> > +	WARN_ON_ONCE(pci_ser_delete(ser, dev));
> 
> I don't like putting code with side effects inside WARN_ON() because
> the important code gets hidden.

Ack, I'll separate out the WARN.

> > +	dev->liveupdate_outgoing = false;
> > +}
> > +EXPORT_SYMBOL_GPL(pci_liveupdate_outgoing_unpreserve);
> > +
> > +u32 pci_liveupdate_incoming_nr_devices(void)
> > +{
> > +	struct pci_ser *ser;
> > +	int ret;
> > +
> > +	ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&ser);
> > +	if (ret)
> > +		return 0;
> > +
> > +	return ser->nr_devices;
> > +}
> > +EXPORT_SYMBOL_GPL(pci_liveupdate_incoming_nr_devices);
> 
> Currently only called from drivers/pci/probe.c; does this really need
> to be declared in include/linux/pci.h and exported?  We can do that
> later if/when needed.  Put in drivers/pci/pci.h if only needed in
> drivers/pci/.

Will do.

> > +void pci_liveupdate_setup_device(struct pci_dev *dev)
> > +{
> > +	struct pci_ser *ser;
> > +	int ret;
> > +
> > +	ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&ser);
> > +	if (ret)
> > +		return;
> > +
> > +	dev->liveupdate_incoming = !!pci_ser_find(ser, dev);
> 
> I think this would be easier to read as:
> 
>   if (pci_ser_find(ser, dev))
>     dev->liveupdate_incoming = true;

Will do.

> 
> > +}
> > +EXPORT_SYMBOL_GPL(pci_liveupdate_setup_device);
> 
> Currently only called from pci_setup_device(); does this really need
> to be declared in include/linux/pci.h and exported?  We can do that
> later if/when needed.

Ack, I'll take this out of include/.

> > +void pci_liveupdate_incoming_finish(struct pci_dev *dev)
> > +{
> > +	dev->liveupdate_incoming = false;
> 
> What is this useful for?  Does the PCI core need to *do* anything
> after a driver finishes its own adoption of a preserved device?  I
> assume everything the PCI core does, i.e., rebuilding its pci_dev and
> related things based on KHO data, must be done before the driver sees
> the device.

VFIO needs to know this before userspace retrieves the file associated
the preserved device from LUO. See patch 08:

  https://lore.kernel.org/kvm/20260129212510.967611-9-dmatlack@google.com/

> > diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
> > new file mode 100644
> > index 000000000000..6577767f8da6
> > --- /dev/null
> > +++ b/include/linux/kho/abi/pci.h
> 
> Seems unusual to make an abi/ subdirectory when that's the only thing
> in kho/, but I assume you have plans for more.
> 
> There are several *-abi.h files in include/uapi/, but this abi/
> directory is the ABI-ish name in include/linux (except for the
> include/soc/tegra/bpmp-abi.h oddity).

This directory hosts all the ABI structures that are passed from
kernel-to-kernel across a Live Update.

  $ ls include/linux/kho/abi
  kexec_handover.h  luo.h  memblock.h  memfd.h  pci.h  vfio_pci.h

I agree the directory structure doesn't need to be quite so deep though.

> > +/**
> > + * struct pci_dev_ser - Serialized state about a single PCI device.
> > + *
> > + * @domain: The device's PCI domain number (segment).
> > + * @bdf: The device's PCI bus, device, and function number.
> > + */
> > +struct pci_dev_ser {
> > +	u16 domain;
> 
> ACPI _SEG is limited to 16 bits, but I think all the Linux interfaces
> use "int" and VMD creates domains starting with 0x10000 to avoid
> colliding with ACPI segment numbers.  I think we should probably use
> u32 here (and for the Linux interfaces, but that's another patch).

Will do.

Thank you for the review!

