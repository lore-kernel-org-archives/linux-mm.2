Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB1F8F4BB6F
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 19:03:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D64786B0088; Tue, 24 Feb 2026 14:03:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3B916B0089; Tue, 24 Feb 2026 14:03:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3DFA6B008A; Tue, 24 Feb 2026 14:03:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF6406B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:03:11 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4A93C57BB6
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 19:03:11 +0000 (UTC)
X-FDA: 84480272982.03.8D868F4
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id 46A8220015
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 19:03:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=stks3CI6;
	spf=pass (imf03.hostedemail.com: domain of praan@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771959789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X93b96xDCWqbNSn/Osk0k6D0QiHzoDXCBhSgmB8C344=;
	b=CH7m8NPbDbdq9PRx9/OYlklT+TrEaJ/ppZEZSQn6sYSsdxSgsoYUVJYDAUkzZAO+lkfUqr
	HG03Xfy3VwfM8vCEVG9lw10K+eqRAotRg/RaS/4iD95hIlFdv+f4mbtQuvet05LXSTDPOd
	6Cw6Qqis5sH++152Yn0PJCyqFMoIiLo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771959789; a=rsa-sha256;
	cv=none;
	b=u9GS9UxnxdDnXQj+VhQzkk4t0B/EVVZO62gLvQO7YVgrZpm4/NwnRYke2p+3ewGG7IpHAX
	ONflsup/MFlXp2l74uaG7pQnVRALVIRFkFMuG+Khn8T3JXDe1CTRMezHpWSvgtPWJa+K8V
	jwpfxs9+8qvIGwgCbjq/FIsBdatXsms=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=stks3CI6;
	spf=pass (imf03.hostedemail.com: domain of praan@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2a964077671so10585ad.0
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:03:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771959788; x=1772564588; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=X93b96xDCWqbNSn/Osk0k6D0QiHzoDXCBhSgmB8C344=;
        b=stks3CI6OjhkChsF0kVAC+/HQK0lK3dxHL4AeSDcNjVo6tq2PLucZYw1OSoZt6o2r8
         ERmKpsEOR6Ycro1eWhndIWpQDqsIssFnUTkBtNtYraUI/U7dmF0nHMS/jpebUKbrECZp
         8YamSIRxQi+0vcn9OxTpBkKp/1mV4fbXg1UOP8IJdqPkdpVTQbGi0NQYxeGUV5hYgxI7
         nQ384/xbDQkO0j4G5VYRaQjI0xvw6c6fMFuOUmVvOWQi+a1yQB3CV1IL8LotFGkx+ZwI
         HYnfe0AIRKIytSJFvvY4zwLa02Dv/U6BmZloBqeG5yEdjYrENHGCOci1vnZe5W7FXtv4
         9yDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771959788; x=1772564588;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X93b96xDCWqbNSn/Osk0k6D0QiHzoDXCBhSgmB8C344=;
        b=sC5vRIMdwIN7mKrDAk7XhrrqqPKE33SbEvbqdiNXlSDEVN5XiPH060Q7lNOeK9fkAn
         VmppacvSXJ07JCtHOxMmuceqzr6F7PHMnIgo+Gx4xwQ4ECB/AGKuw8RcKC7AjaI28xK8
         1DtcZHyAbGJUhmh6dL7Ml4eGEWnO0BFwbOrE2U25HhLC6YVBBfzJsUfY7oOevmdgFttc
         sOVTBtiAHKir3/x4yJuUricmafCn5GoKi9NRk4NjmRLHbOjj5W7FVq/daQE1cmwXWvIT
         QE5Vop3MvJ/w0liePNonbX8jqlcp0p+l9i510LFY4WJuki5TqlHFVk6z7OUk2mfi0XPi
         IVrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNBmZ5pdmlZJ0EFnrwJl+Dg6R7U1wyckVbwIaYu9CsssrSsUU+lwGCx4sqMc1XPY2toNafh/xx2g==@kvack.org
X-Gm-Message-State: AOJu0YwBQyw2cNvbcbylLJD4DTgP3rpW/rsH20wCVLoKGrN38iPGYA4q
	pl5stYMb8HG9EVmcD0ngCvhYW6xyQ+B32tds1MvyhAgbWISd7dinL08mh2iO47nPjw==
X-Gm-Gg: ATEYQzyULqpo3diS9gF7NuOVITmt1bxiv/MCdVAv87Oto8FCZM6SqSGaoS+48P/kguC
	xzwrlm8N5IKCE4aUQBrUUwLptIaTt4SZcLxfUvWPdwSXQwx5SLPbfB6QKTwc9YT8iNqI79fMoMg
	Vbr299x8DSMcQ41G3zTqDK+YQq5p3kBOPKwMBNqQE9ODBcDAMj/RW/zqEaHhYyXnZrhAslRfMLO
	+7qBCYcFKIRaRO9GXNFWLjntrSouwuvxLKzUCYlMWzV3d8J5CnWKiIUb4903Eo8VCumGQoCpFfI
	6N8FZtTvu+N5ZDkfpS7SuPZMaKBLR3QEuc9RrXUdzcydf45XvuzI4IGgCFUztFNyWk227GceB/l
	RAY7CqTc7yEAyt4YZyAGof0r993fyKkYw0nGrCB/dQZAFwG1XXwETeR/dGA+1JLoPd0nB/IfCwW
	Q1S9UfeV6XppXOxlMiWUgp76OhsTcXBdMjQo8U1wOtwfr1d6swCnH/97zRoiDK
X-Received: by 2002:a17:902:c412:b0:2a9:5bfa:54ef with SMTP id d9443c01a7336-2adca6c8e0amr234085ad.10.1771959787309;
        Tue, 24 Feb 2026 11:03:07 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad74d36911sm114902575ad.0.2026.02.24.11.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 11:03:06 -0800 (PST)
Date: Tue, 24 Feb 2026 19:02:56 +0000
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
Message-ID: <aZ314HSRnYtGinTU@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-3-dmatlack@google.com>
 <aZ1svGur9IxQ7Td2@google.com>
 <CALzav=fSpd6H5pQNtJoFHdNtWVO11vffhWQFsMFkM+osGuE0wQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=fSpd6H5pQNtJoFHdNtWVO11vffhWQFsMFkM+osGuE0wQ@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: rjxhkyim4ffg451naishyyyatrftyzia
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 46A8220015
X-HE-Tag: 1771959789-958779
X-HE-Meta: U2FsdGVkX189MtdbGw0NImQPaky4w0uBozfhpC87Z1iEwHBWe6VYTCHdXwea+4WoFtZ/Lxr3jUsThwZAo1eT9072LI1CWsETK1MYsXBKFQFEA12QkCmOlWUal7wjPs9NW5lYQ4lRXUdyyNxVkyi2rsg5Q0dOZcpRdRWL1eAGX5i/ZL3ngNXyhGxUTF9lkkEWaKBhBsILhHYMzMfOGA6iK5+nk2h85lQZdXSC5t2BL7Tb4WpLl4B855t0rz5Wuda0hi23r9k0ltCLvaNwnqyGNnRmkz6VwuZelPGPq7uzfCYJFKpYV7WyvJQDJ4vMB+1cAMTE/QjJs8kgkO3/7PHIklTmnsRu2ysnNrzjQ+Z8iA5TUtiJYMh+C+lIxELLhBWLsuhgGi8z1aBoi5j6NFNTFQ9zxY6pVgYw+0zRr28usx2P1tnXI0gs1wo6vcrfKntHv//fkGV/FcJVQNCVIlNyaX9FquwVNKzfbrN2wjJf6cHBpkh7H79QrbsUEpGLBVOfFkKSl/Tj58t//enjlbzGUYkr/Ts0JLgUnAAz9C/2nGlXtbH9xxIwIRkIica+QdGmf6B70VCtv2OGfoZ9QX/ZfEzCOf+BelHsrteg2j73zm2p694p0dI8X5bn2YgeW6Vma8wB4VG6JCoFtvNCuqBKRNOUYNn/zGlpg6wAto3bCjPTrgbEIGX+OAb33c+zVMaS0g/7g+DImryBNaV7s8TYQBOakjVxC/Z7nZBGm5Q9hbgXrAz6xxBTYDriMyoZRkgX9gLV3TaQew9rj6bHnvf8X9kCVCa6L3htC93hnN5NPT2+LXHgZL1rmiOOSxLHIm8Ve5edYl1zW5RLbDnmuyYtrPNcOh48X7PUXxfbcajBmwryVwl6vOrDOqcEOSmXqFZ+x3rM9y4+QxkV04Zv/OmRHWo02tkAcSB2DYGRaO/ihvzjBTZWeTZ9+OPHJTECiDkuE39ZHOM8qrAH+Sjfqv9
 V5c+POEd
 WDrA8x6dMSFIIKk8ISqmWofxujCGUJ3f0KdYpaSkNOJd/xAIYy4bjVQOn5tqrntQ2Cp1AfxOxlpI3A1GbXBwZVHLUm9J6RKg3DemonIUeK7Iam4bN2Bg2aBMa/tdbqfTQfAbJ+d+W1LQu0/UxUlVo3AU7Q79gXc+LMl9Oz/OPGltoNch2USUKDB5e2Ed2M65tcQrQL336ohzRKYAQLl3KqY/r9q37uUaTAp/gejrG8DM4od0YVpCoWv8o77MHa4lqrQE1DlbDBDQjVomMvF9SROyPu9m9CY+lBYqr9lmaArMYEh8sOuOanmy1tfBth2zCv0ZPNuy9iK052mHsKXYfJzZGrrpatTrxa584NPsTf522gan8PsCwlSvshdkLPhoaI2POexFRdd49Qpa7I7KanFzYmWvEC46v7KRBZuGBgUxv7uVtsG8fgsTRmD/RvcrWyQihE9vAHG7qZW8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 09:33:28AM -0800, David Matlack wrote:
> On Tue, Feb 24, 2026 at 1:18 AM Pranjal Shrivastava <praan@google.com> wrote:
> > On Thu, Jan 29, 2026 at 09:24:49PM +0000, David Matlack wrote:
> > > + * Copyright (c) 2025, Google LLC.
> >
> > Nit: Should these be 2026 now?
> 
> Yes! Thanks for catching that.
> 
> > > +int pci_liveupdate_outgoing_preserve(struct pci_dev *dev)
> > > +{
> > > +     struct pci_dev_ser new = INIT_PCI_DEV_SER(dev);
> > > +     struct pci_ser *ser;
> > > +     int i, ret;
> > > +
> > > +     /* Preserving VFs is not supported yet. */
> > > +     if (dev->is_virtfn)
> > > +             return -EINVAL;
> > > +
> > > +     guard(mutex)(&pci_flb_outgoing_lock);
> > > +
> > > +     if (dev->liveupdate_outgoing)
> > > +             return -EBUSY;
> > > +
> > > +     ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&ser);
> > > +     if (ret)
> > > +             return ret;
> > > +
> > > +     if (ser->nr_devices == ser->max_nr_devices)
> > > +             return -E2BIG;
> >
> > I'm wondering how (or if) this handles hot-plugged devices?
> > max_nr_devices is calculated based on for_each_pci_dev at the time of
> > the first preservation.. what happens if a device is hotplugged after
> > the first device is preserved but before the second one is, does
> > max_nr_devices become stale? Since ser->max_nr_devices will not reflect
> > the actual possible device count, potentially leading to an unnecessary
> > -E2BIG failure?
> 
> Yes, it's possible to run out space to preserve devices if devices are
> hot-plugged and then preserved. But I think it's better to defer
> handling such a use-case exists (unless you see an obvious simple
> solution). So far I am not seeing preserving hot-plugged devices
> across Live Update as a high priority use-case to support.
> 

Ack. If we aren't supporting preservation for hot-plug at this point.
Let's mention that somewhere? Maybe just a little comment or the kdoc?

> > > +u32 pci_liveupdate_incoming_nr_devices(void)
> > > +{
> > > +     struct pci_ser *ser;
> > > +     int ret;
> > > +
> > > +     ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&ser);
> > > +     if (ret)
> > > +             return 0;
> >
> > Masking this error looks troubled, in the following patch, I see that
> > the retval 0 is treated as a fresh boot, but the IOMMU mappings for that
> > BDF might still be preserved? Which could lead to DMA aliasing issues,
> > without a hint of what happened since we don't even log anything.
> 
> All fo the non-0 errors indicate there are 0 incoming devices at the
> time of the call, so I think returning 0 is appropriate.
> 
>  - EOPNOTSUPP: Live Update is not enabled.
>  - ENODATA: Live Update is finished (all incoming devices have been restored).
>  - ENOTENT: No PCI data was preserved across the Live Update.
> 
> None of these cover the case where an IOMMU mapping for BDF X is
> preserved, but device X is not preserved. This is a case we should
> handle in some way... but here is not that place.
> 
> >
> > Maybe we could have something like the following:
> >
> > int pci_liveupdate_incoming_nr_devices(void)
> > {
> >         struct pci_ser *ser;
> >         int ret;
> >
> >         ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&ser);
> >         if (ret) {
> >                 if (ret != -ENOENT)
> >                         pr_warn("PCI: Failed to retrieve preservation list: %d\n", ret);
> 
> This would cause this warning to get printed if Live Update was
> disabled, or if no PCI devices were preserved. But both of those are
> not error scenarios.
> 

I agree, the snippet was just an example. What I'm trying to say here
is, what if the retval is -ENOMEM / -ENODATA, the existing code will
treat it as a fresh boot because it believes there are no incoming 
devices. However, since this was an incoming device which failed to be
retrieved, there's a chance that it's IOMMU mapping was preserved too.
By returning 0, the PCI core will feel free to rebalance bus numbers or
reassign BARs. For instance, if the IOMMU already inherited mappings for
BDF 02:00.0, but the PCI core (due to this masked error) reassigns a 
different device to that BDF, we face DMA aliasing or IOMMU faults.
Am I missing some context here?

> > > +void pci_liveupdate_setup_device(struct pci_dev *dev)
> > > +{
> > > +     struct pci_ser *ser;
> > > +     int ret;
> > > +
> > > +     ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&ser);
> > > +     if (ret)
> > > +             return;
> >
> > We should log something here either at info / debug level since the
> > error isn't bubbled up and the luo_core doesn't scream about it either.
> 
> Any error from liveupdate_flb_get_incoming() simply means there are no
> incoming devices. So I don't think there's any error to report in
> dmesg.
> 
> > > +     dev->liveupdate_incoming = !!pci_ser_find(ser, dev);
> >
> > This feels a little hacky, shall we go for something like:
> >
> > dev->liveupdate_incoming = (pci_ser_find(ser, dev) != NULL); ?
> 
> In my experience in the kernel (mostly from KVM), explicity comparison
> to NULL is less preferred to treating a pointer as a boolean. But I'm
> ok with following whatever is the locally preferred style for this
> kind of check.
> 

No strong feelings there, I see both being used in drivers/pci.

> > > @@ -582,6 +583,10 @@ struct pci_dev {
> > >       u8              tph_mode;       /* TPH mode */
> > >       u8              tph_req_type;   /* TPH requester type */
> > >  #endif
> > > +#ifdef CONFIG_LIVEUPDATE
> > > +     unsigned int    liveupdate_incoming:1;  /* Preserved by previous kernel */
> > > +     unsigned int    liveupdate_outgoing:1;  /* Preserved for next kernel */
> > > +#endif
> > >  };
> >
> > This would start another anon bitfield container, should we move this
> > above within the existing bitfield? If we've run pahole and found this
> > to be better, then this should be fine.
> 
> Yeah I simply appended these new fields to the very end of the struct.
> If we care about optimizing the packing of struct pci_dev I can find a
> better place to put it.

If you have pahole handy, it would be great to see if these can slide 
into an existing hole. If not, no big deal for v3.. we can keep it as is

Thanks,
Praan

