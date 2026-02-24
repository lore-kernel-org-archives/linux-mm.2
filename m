Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27C6DF4BB7D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 19:05:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7397B6B0088; Tue, 24 Feb 2026 14:05:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7078B6B008A; Tue, 24 Feb 2026 14:05:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61D786B008C; Tue, 24 Feb 2026 14:05:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E6926B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:05:55 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 227F31A02ED
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 19:05:55 +0000 (UTC)
X-FDA: 84480279870.13.9108568
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 322E64000B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 19:05:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KYdasP7X;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of praan@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771959953; a=rsa-sha256;
	cv=none;
	b=s3snvCFONDel+tYrFxnZKFcknaTwZw9+J/URC6hqdGCZzYOm1hyNZlBCBeotV7OJPrx30I
	IAvtByG6Igta7qlrq0/AGFEIkJ4ecehDOmuNReO67xy2/4ol2renYKk9vsCZmu2KwnaEOX
	zlLxTXptiaCGvsE1pSYMXNw6sj66Irk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KYdasP7X;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of praan@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771959953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y+nxktJgrzlaK8SQflM75E9Ffs6HGnnvzkBNJC6O+O8=;
	b=2Hy3ZA97w1V337bz8s94zq5MONFZaRXFQ1OUjOXC7Ei3TJyqAFVt247mheRcSgwr/Z/La9
	KBz+xBV14zazoFA5TV7gFgjZJE8sDqkrHo2kyldYP6bP+zSL1hOcubcCQzdDgJsvBkdyP8
	0Q0cCpvuaP1FbNRk+RngzoTUjLMP8nM=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ada9e4ea32so8475ad.1
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:05:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771959952; x=1772564752; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=y+nxktJgrzlaK8SQflM75E9Ffs6HGnnvzkBNJC6O+O8=;
        b=KYdasP7XnPATKUemfoYOw8QG1cJyFWxw869zDdGjX/+KR5ZOxQpeMzEwUsDUWb+BlL
         xpXBmtsOOQWb1l37OT5txbCEfA9kcKeFULewllvPQmMFG81Vke/PxTPxdaJfkwPA+1Vw
         UwnG+OxtD9tcPunggzGMNPSD4fU5AYjj0Au2Frz7rdDnPBZ8LLG8sBaAnkyTUm132pr8
         V5U4/XF6LfZCeKwV+qxpL7UGuKZYBOkYAOvFZzz8MpoW26G3MjM0TNIT21QlKykF7RuH
         +sNgX1b9wGTZy2TRBc+rYgY+RRi4JVbGTDAICXe0fiasgAcMZ6KuezAJ5z0oSF7v+IDI
         vrXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771959952; x=1772564752;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y+nxktJgrzlaK8SQflM75E9Ffs6HGnnvzkBNJC6O+O8=;
        b=b7QC5ZlNsXmALc6B68hBwWs/RhaO2YbqhJRzoviUrkcpMteY8mznT/sDfT1dZSaDp5
         3cOUx0GagW0HoA0dKtenLTBBh9e0C+uMxWBsPVZL1M4XLVApPuFj+ywIB15mwgq/gDAJ
         tusuLHDxwrb0ULRUJ9iY/rZme3gY0QizlXPJjmOn09k4HBeYdWQLw3YvAW0SwRK1Ua2v
         U92z8fCdr0JqWLz3GcE+d8ukR/sC2UXkDHUt5cv08MucwrgRqPPdVGMRBetOBUFzSAUi
         T1RI3R6oLBqJJechtfkgvyWOjHXnhsTet+aNN6Ld39+ntyE7H6cObGuPQe2MGYWrodbt
         JyYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWefz9SEB8VnwC1RFboPv5+NcqZpaoQbHULdbBmnaH/BF2B34eMDdNg2oesdTdv5jRJvZ3JTJ4Iw==@kvack.org
X-Gm-Message-State: AOJu0Yz3f/BzK67EeZunDzvZ+kZqhSpPacG47+rdQqeCIvLlIlB9FhYd
	pPJYnP296BypHWeieNEq5ioF7yWJtOKBCd8oLBpVF91yqeu4u+kRsWS3G8p41iu+cw==
X-Gm-Gg: ATEYQzzbyZitui/J29Bm7N7Qb4MvtHpvT+Y+PlHMGB0Uh9gTBpssztdNpwV9eoWWfjb
	aizunE0n2XaozPg5k6/N5qIJyBbsAKM9y9LeyrA4N6IdPCug2oJPpCh+Nd0ozPN0i8aJVTJD3K3
	kukEIYGyrGZQCTQzhjd+6bGpTJ8pCKhkZb/0EFl8+xF5ln+mLll0QTiIIHS9Uhkzunyi7UNAZYv
	+IisMcJrLvP7p6w83o1gwfwjJ7H8CTGvnMpxa0DjiV/UOAz4zfZaGHAemLGV+EmEwRk2RYLQuHG
	aJPOQyGpF7Fj/Wd4A34XdfqmJqcDcSTv0t010zSmOr0gptJcB/HLIKzvv5yBmfraxz/uTIhUIRS
	ZuTIUJCuX6T/roBflYvoNrfNAHe8GiBzCaoTTX7QDnG08litg+xQdzdpQTm/3K+RrJSGc6s6Tco
	hCATiZWFl2V0w8kbHXxe55YG0V10Hcr9GrQgEvKvbCOWsht1gQ7uslrhFRJWsM
X-Received: by 2002:a17:903:3d0c:b0:297:f2a0:e564 with SMTP id d9443c01a7336-2adca83b652mr139205ad.11.1771959951330;
        Tue, 24 Feb 2026 11:05:51 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3590241e8a2sm595715a91.12.2026.02.24.11.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 11:05:50 -0800 (PST)
Date: Tue, 24 Feb 2026 19:05:41 +0000
From: Pranjal Shrivastava <praan@google.com>
To: David Matlack <dmatlack@google.com>
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
Message-ID: <aZ32hf3dHibfb4B5@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-3-dmatlack@google.com>
 <aZ1svGur9IxQ7Td2@google.com>
 <CALzav=fSpd6H5pQNtJoFHdNtWVO11vffhWQFsMFkM+osGuE0wQ@mail.gmail.com>
 <aZ314HSRnYtGinTU@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aZ314HSRnYtGinTU@google.com>
X-Stat-Signature: mhmfecadrdttwkjwq8njgjz7gujzxnng
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 322E64000B
X-HE-Tag: 1771959952-917758
X-HE-Meta: U2FsdGVkX1/UBb1ZFgI2e7+5pT8U1y7i49qvTZtYGDNBHSoYkCHFhJC8lcNMa6ksdCOvtYrITOZHzHhHk5w/BD+T9Fqx0331U73WqwUsNret8Mnc5nJocFYLCzAHqzp7V/NnCFitypo3KaIvGrmeedIHYUEH3C8dJjcEjoOkhcqNXUnt/Q3o3PAkT8D41tAz98zss9bqAQmwy8fMTGGUCNw0UojJiZQC5AhCXhP/gZ/t3nyCvdTimCesIEnDsjKBPZEmqYXKFkg7xen7onAs2og3GP1svTkG7SMSarZlVG2J3i32RMEHg5gf4ysxGIrSTEddy6IceQQZPGfI+HEIxu67+xDSsW5BJJDLXq2KC7wy6lASH5f77JxyPcL7xkzwg3LOCaVV9TEsR6nsn+KCWPKCuNqX3e8y9DENogcDDNWsBR27Y/Hp41sMscIvFW7maaSn0AGTr/O+yJlNYnBdEN7JRj3OKDATwznN5LjReD4E6h0+ANLUF2nh2+BGIx+/TayiBYEpma/NUduQVZAXNcmtjo0sXo1wnBjGv3Pm5d4Wq0wNjH3LT0skAslnCxnuI3rcCyiawFu1OBfpNB7zhNI5/B6DkcQQX34LHpKBuLz0iz6MlUN4zU0mEHnUirEmbS1C/SE6dqQ8O92vFoUw7yNFHiJlqYiEI/LORNIjtyrMjx6Y2DL+qpkDubTOfDAvL/atvovxnKuGlSVdhBXxO1mKRPmO4VjyzM4Tb6DtigxfkFXGM68d2uMcd23itpr+gidgMDYFXoRRayqOPox/dOQj7qy9WkKOSzrCxqGuRS5o+M1IZQycC4fdyHCAOQqKQwKZtA4U7fmopkD3TRw/oK0zkb8dS7pKMZXxdBivXO1/piAiPKXbpA5B8GAHvW5CKfTRaEhl5m4Vyl9dqCw+185/33s6z0qhR7zqqsJ8qMyaoiFRxRJoByoWWgTp9M0ZyNffHhnTKcrncI7zSPJ
 hUzDeLzo
 tKzgVY4GmUPDmsXwZeikcrm1nlbIH/VxjKQ99GxWVKmbBagiXl95LirbeMTkrQBs3CTrwJOStRtOmrvkljSJcU2uYRrUIVF0CEgvuC3I47MQNYZu5ApltKS5oQqYGagzgIKd13s+KM1Eijdxe9mWfe2EarwnMlYU5f0J6CMPEdQ41Q2ikCuBoK6VeCJHj5iFc48+voSNv09RzckBgO2jTQZMH7KUY6B8OXhG5uroNhcO/TFv+U639j9CU3N91mgjHFHIC59kI/hqeYvDovYKW+M7oEO5lcwWOaX39eJvRSm8G3Dsji6cZv1Z1OliagVKfsyFQFpcuQqOji5kb6vDDcZvenJwXjH2D1hBgHGw+abWIqu3HgTRNKFzqrA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 07:02:56PM +0000, Pranjal Shrivastava wrote:
> On Tue, Feb 24, 2026 at 09:33:28AM -0800, David Matlack wrote:
> > On Tue, Feb 24, 2026 at 1:18 AM Pranjal Shrivastava <praan@google.com> wrote:
> > > On Thu, Jan 29, 2026 at 09:24:49PM +0000, David Matlack wrote:
> > > > + * Copyright (c) 2025, Google LLC.
> > >
> > > Nit: Should these be 2026 now?
> > 
> > Yes! Thanks for catching that.
> > 
> > > > +int pci_liveupdate_outgoing_preserve(struct pci_dev *dev)
> > > > +{
> > > > +     struct pci_dev_ser new = INIT_PCI_DEV_SER(dev);
> > > > +     struct pci_ser *ser;
> > > > +     int i, ret;
> > > > +
> > > > +     /* Preserving VFs is not supported yet. */
> > > > +     if (dev->is_virtfn)
> > > > +             return -EINVAL;
> > > > +
> > > > +     guard(mutex)(&pci_flb_outgoing_lock);
> > > > +
> > > > +     if (dev->liveupdate_outgoing)
> > > > +             return -EBUSY;
> > > > +
> > > > +     ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&ser);
> > > > +     if (ret)
> > > > +             return ret;
> > > > +
> > > > +     if (ser->nr_devices == ser->max_nr_devices)
> > > > +             return -E2BIG;
> > >
> > > I'm wondering how (or if) this handles hot-plugged devices?
> > > max_nr_devices is calculated based on for_each_pci_dev at the time of
> > > the first preservation.. what happens if a device is hotplugged after
> > > the first device is preserved but before the second one is, does
> > > max_nr_devices become stale? Since ser->max_nr_devices will not reflect
> > > the actual possible device count, potentially leading to an unnecessary
> > > -E2BIG failure?
> > 
> > Yes, it's possible to run out space to preserve devices if devices are
> > hot-plugged and then preserved. But I think it's better to defer
> > handling such a use-case exists (unless you see an obvious simple
> > solution). So far I am not seeing preserving hot-plugged devices
> > across Live Update as a high priority use-case to support.
> > 
> 
> Ack. If we aren't supporting preservation for hot-plug at this point.
> Let's mention that somewhere? Maybe just a little comment or the kdoc?
> 
> > > > +u32 pci_liveupdate_incoming_nr_devices(void)
> > > > +{
> > > > +     struct pci_ser *ser;
> > > > +     int ret;
> > > > +
> > > > +     ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&ser);
> > > > +     if (ret)
> > > > +             return 0;
> > >
> > > Masking this error looks troubled, in the following patch, I see that
> > > the retval 0 is treated as a fresh boot, but the IOMMU mappings for that
> > > BDF might still be preserved? Which could lead to DMA aliasing issues,
> > > without a hint of what happened since we don't even log anything.
> > 
> > All fo the non-0 errors indicate there are 0 incoming devices at the
> > time of the call, so I think returning 0 is appropriate.
> > 
> >  - EOPNOTSUPP: Live Update is not enabled.
> >  - ENODATA: Live Update is finished (all incoming devices have been restored).
> >  - ENOTENT: No PCI data was preserved across the Live Update.
> > 

The flb_retrive_one seems to call:

 err = flb->ops->retrieve(&args);

which could be anything honestly.. since the luo_core doesn't scream
about it, maybe the caller should?

Thanks,
Praan

> > None of these cover the case where an IOMMU mapping for BDF X is
> > preserved, but device X is not preserved. This is a case we should
> > handle in some way... but here is not that place.
> > 
> > >
> > > Maybe we could have something like the following:
> > >
> > > int pci_liveupdate_incoming_nr_devices(void)
> > > {
> > >         struct pci_ser *ser;
> > >         int ret;
> > >
> > >         ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&ser);
> > >         if (ret) {
> > >                 if (ret != -ENOENT)
> > >                         pr_warn("PCI: Failed to retrieve preservation list: %d\n", ret);
> > 
> > This would cause this warning to get printed if Live Update was
> > disabled, or if no PCI devices were preserved. But both of those are
> > not error scenarios.
> > 
> 
> I agree, the snippet was just an example. What I'm trying to say here
> is, what if the retval is -ENOMEM / -ENODATA, the existing code will
> treat it as a fresh boot because it believes there are no incoming 
> devices. However, since this was an incoming device which failed to be
> retrieved, there's a chance that it's IOMMU mapping was preserved too.
> By returning 0, the PCI core will feel free to rebalance bus numbers or
> reassign BARs. For instance, if the IOMMU already inherited mappings for
> BDF 02:00.0, but the PCI core (due to this masked error) reassigns a 
> different device to that BDF, we face DMA aliasing or IOMMU faults.
> Am I missing some context here?
> 
> > > > +void pci_liveupdate_setup_device(struct pci_dev *dev)
> > > > +{
> > > > +     struct pci_ser *ser;
> > > > +     int ret;
> > > > +
> > > > +     ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&ser);
> > > > +     if (ret)
> > > > +             return;
> > >
> > > We should log something here either at info / debug level since the
> > > error isn't bubbled up and the luo_core doesn't scream about it either.
> > 
> > Any error from liveupdate_flb_get_incoming() simply means there are no
> > incoming devices. So I don't think there's any error to report in
> > dmesg.
> > 
> > > > +     dev->liveupdate_incoming = !!pci_ser_find(ser, dev);
> > >
> > > This feels a little hacky, shall we go for something like:
> > >
> > > dev->liveupdate_incoming = (pci_ser_find(ser, dev) != NULL); ?
> > 
> > In my experience in the kernel (mostly from KVM), explicity comparison
> > to NULL is less preferred to treating a pointer as a boolean. But I'm
> > ok with following whatever is the locally preferred style for this
> > kind of check.
> > 
> 
> No strong feelings there, I see both being used in drivers/pci.
> 
> > > > @@ -582,6 +583,10 @@ struct pci_dev {
> > > >       u8              tph_mode;       /* TPH mode */
> > > >       u8              tph_req_type;   /* TPH requester type */
> > > >  #endif
> > > > +#ifdef CONFIG_LIVEUPDATE
> > > > +     unsigned int    liveupdate_incoming:1;  /* Preserved by previous kernel */
> > > > +     unsigned int    liveupdate_outgoing:1;  /* Preserved for next kernel */
> > > > +#endif
> > > >  };
> > >
> > > This would start another anon bitfield container, should we move this
> > > above within the existing bitfield? If we've run pahole and found this
> > > to be better, then this should be fine.
> > 
> > Yeah I simply appended these new fields to the very end of the struct.
> > If we care about optimizing the packing of struct pci_dev I can find a
> > better place to put it.
> 
> If you have pahole handy, it would be great to see if these can slide 
> into an existing hole. If not, no big deal for v3.. we can keep it as is
> 
> Thanks,
> Praan

