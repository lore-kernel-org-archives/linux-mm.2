Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D305FCD8CB9
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 17:20:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 417566B0005; Tue,  9 Jun 2026 13:20:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A1016B0088; Tue,  9 Jun 2026 13:20:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2953A6B008A; Tue,  9 Jun 2026 13:20:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 13C2E6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:20:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B40FD90E1F
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:20:27 +0000 (UTC)
X-FDA: 84861038094.01.6236FEC
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id C92D24001A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:20:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vubt9fix;
	spf=pass (imf04.hostedemail.com: domain of praan@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781025625;
	b=pT+ytEexh7B1vlQ5b1xqCz8ogMfciMoQsgm41cHf4/JaVVnFFCvQk8CE7aJzs5LKXEI1I7
	RRQJe7zFHzqUw2IOZodPp+VmN41DPREopgrinybWjyV+tVuiVTOd1W90UQDo5CQkjYDGtA
	+8CRwfNA61Qgd5N5fqWsVkF/2Wd5nu4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vubt9fix;
	spf=pass (imf04.hostedemail.com: domain of praan@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781025625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=01u/8EAi6NGn4gFgEAFXoW9+VQRDowjxcP1j39dvRbk=;
	b=gXmy1AteoroO3Gv0ziBlOINDEbDjL5e8ImuzFTUMcElZ+8B8IV2RMIVXK2TMVIsLoiMjax
	EgAyWDxOlsWGnf4t89hhkRTHyRFE+JDvntzi/MXVBedB4aFNzId85FiMBKkNC9XS/uhBc2
	AU9DeKMZwaf7Alsfl2lOg9wyu3jdESI=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2bf2911f93cso461965ad.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 10:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781025625; x=1781630425; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=01u/8EAi6NGn4gFgEAFXoW9+VQRDowjxcP1j39dvRbk=;
        b=vubt9fixcAapXHtGAH3nNFZwnG6DE5y9rJsTcZcAYutANGf7N4zaJVYcEi6LbTheYt
         S6pyi4XGAu/1WVXlXfF/O1kg3zKkyYWMfCkEy3LD3q39EqWq121dBPSMKN+joN3ghFDm
         Vm9xNwT3qQbN4BLNfvIN/YwD4jOBpqCpgWX5EpBMjn6gdMMl4/zkLYC/KcoFRduylxBb
         p7V/j3ZjkcRuNjJ0Csdqj0HUnM3+gYArDdN+wd0EWSAO4urhORSWHLh0juPIL9MTTP9i
         3vfhGkzfo615ZtvjZ0RVyVkcYTNZt6r2WzPAFOqlmgRJfUifnCItF5GADxfRTGm0mXbH
         nBbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781025625; x=1781630425;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=01u/8EAi6NGn4gFgEAFXoW9+VQRDowjxcP1j39dvRbk=;
        b=F8fFXmV4vn9RKGlbyCmqeer1X4bfsmas+nDIDl1eNBofH+odbm4iLmvPHKJVYYG51+
         XSPFkPzz7jFwTpgUBAzTTb2GK/6Wk49Emv4caDOWovN8k0ixzgAvAv9vYIpgFLAzMEbX
         8wk49kMYxb33gnt9v14byynKkq2sNXMw2Ol30xogMBGNCBT0XtC3n4a50PNIMDB9F1LV
         pUk8zhTPJKKoifVnu2sTWX4XxoZMNMkyp0iOSdSPGUq9YomYYoHgEJrR1KtM2sr3ETWv
         jTSQu5oEQWH2A5EmtGgh0+5Jq4SRoNBwt6cDkCi/p5wFybTkWHhOHEdp/6QiMSejLXHv
         cuQg==
X-Forwarded-Encrypted: i=1; AFNElJ9EuZ7tuPln4bH8LJrmka3yIT7rU67WLTdXwMrgf5FUEkQZ1fvwPav5pInVJIurZ9fV0ZzYQSp/9w==@kvack.org
X-Gm-Message-State: AOJu0YzEi52Os7EWE31EHHeAZJUJvJnYMXGNK+MFtrHw3mgNSqwoPqqq
	EKhZ7cKS4+Dmfr6Wdgz5SK7IxmBAxW+6ErycM+0gniDexbDPwLb2OZQRNjdGHBajaw==
X-Gm-Gg: Acq92OF1YKMmCVFuIdeA1eqmRk2H5AQtxDkD5RV/zXRbeBG6hibjbJ5zW+mudp6+csU
	ei0xJIBDDS3TH5Ha5vR2SbJ/UUlzGoFgYY6xDqqbmeYEcd1XCA6eqw5ZW/iKRS/8tf9P0fxkUxY
	h28tiAYiyFC8PaKpZdxth5Zggs0/SiVhfm/VQvJPhf2d7frVfR3PsrmKMWR7NTkMNhAu9e+gK0+
	+KuTeSnisPLEvKQ51UxQWa6GsTiXHK+q3kiHpvFDwQwVW4i9hqtxEppXt+VY8Zf8VD0UMt1uofn
	9Fk3R37wkNhOnRxa9qutRO/R50y5DMy9aqKZqKs4RvoClDdsJTJuRQdvKyO5mjh3xZn1T3vGMWO
	FFBAPhXEnh1pgqW5Grpd8NmVuE7DcPqD/b8GemGHxYaYXYgLED6jGd7GoWDZ5ItzxhykXOuyDuO
	s9nYZbmVVF9Sb+NEYcD2PrFREPOhTA5rx/YsnbpD7H/0qj1EGnIgVgeF/GXofLD7GTwE61SrMv5
	RUgTlQTng==
X-Received: by 2002:a17:902:e744:b0:2bd:907:2ce5 with SMTP id d9443c01a7336-2c1eafbcbdamr9084545ad.7.1781025624007;
        Tue, 09 Jun 2026 10:20:24 -0700 (PDT)
Received: from google.com (199.255.142.34.bc.googleusercontent.com. [34.142.255.199])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6bf827e6sm25059778a91.1.2026.06.09.10.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 10:20:23 -0700 (PDT)
Date: Tue, 9 Jun 2026 17:20:14 +0000
From: Pranjal Shrivastava <praan@google.com>
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
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 08/12] PCI: liveupdate: Inherit ACS flags in incoming
 preserved devices
Message-ID: <aihLTgs1Y49OXQaV@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-9-dmatlack@google.com>
 <aiXWmR-ettxin4LC@google.com>
 <aic6mdiZ0qUJpFca@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aic6mdiZ0qUJpFca@google.com>
X-Rspamd-Queue-Id: C92D24001A
X-Stat-Signature: hhumwojahybrkbgm59ph73t1pqeegmw6
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781025625-444938
X-HE-Meta: U2FsdGVkX1/j37+ep/0kmJUDh5px1q4gic0fkKaU9t6ypCxeBV2XeBXZdAj5J3cZVh7svzaHUOaKQ+rKC3+Oc9YU87Mwa4FVSh5Pb7LnON/oSCsJmyfNaJFsR+KY6ALZK5/NvDrmLl0DQbKv6Dfb34++4EzGs0qElgozEvZ9SIpg3qz8tD2zeWOP98ZZNZp+4JKSFgVXVvIt1EuW6VITwPhRgwtvaQXBfi1DXaL2jg2Qt32ydtIkw1jDYq4QeRXxW1rxLFZx5iFFtVztnwtRRy6dIwQmM1n0le0k8GbSt6yzwQTSmuNDPJBWBy3Cu1sRv6NgudE2nQBGJZ338W5g42ozBRACYIpgMIZ3LRW6FG189uoO4QILSdF2VHiQCd0NVT8zpZOUzcnVgtlsXntJiI2YVrI4u6U6Lj51xgJJolmklOd18JoBhaI8aLc77bRBqLggKqr4vHlYUIp6GBdv6f+GDaFHwWt3d+In0NJIUcq3oqAaaeEz8qN6umObbHwHf3DUOGOOPIUF3LwsAi2V9xsDIXxqk0eTkaEu0VMq10F2HcVSwhWN1E5X8pqXmkz2EJ35tvFZ7LkTu5FI7GHg8DMgfkPk11cdkDvKdGVEqGvkFyyAwKaPFXaZKOdZiCouawkmUhipLrCfVSo5JhtN70q9jxODO0frfN0x9P47yOajBslZEdVGhg3qRbNd0P+EhCiiZ0mvA+cS/H5SDC9OXvrTN+YtlSljtyUwiObW1ODRy2bPeI1eRkZ8fH32vNe3lzPbd/j8oqMMbmDK0/p/9UQ0x8UJP6HZOf/lmHVpDhgwfVFZWWeBJLq3K3Igsuf2JkzVgmx+irXQO8W/d5R8DvRBkgy1tBDJXSGHC+c00pZb9zT1PSjU4Td4zDcybiZQI01GvmiBlQS4ZGYQvFVKoCCv75Cn2+xmoTuMZorh+LTlTEi1JnKNrRe6n2obLq1k1qvm3xCksNuxWi/3hQ7
 /sF53rs6
 ApkDIceEyCA0QXXEMClqYuTRuT8mx+cDxR0ryHmv13kkC9L01z9WNddRC8xJBZ3jfePthhKL0dNJ4DYpRhPT8HDOV5RDc1MFtWF+AjQ+sS/HGZlIg+W4/VhfkD9n8hh6GgJ4KRog8NTaeiS6hubgqYWPoxUjFuCwjCvC1Mdoloo7zscWbZjvrhgc3igYXnJHopAiSuKdGhicd3lx7z4jsfLODjUSlTdEnhya8qxai+lwU7rYelH3v4eZ+ZPt306fi9F8d7Iwd4zkF0JdPVmxDqig+uGqt221z7Fjvwx2AQ6rHm6MMNnp566JE3wFj3GIuN1q/8dm+QFT9Ldrq8O2QlTT+WOy2TFKO5CA5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 09:56:41PM +0000, David Matlack wrote:
> On 2026-06-07 08:37 PM, Pranjal Shrivastava wrote:
> > On Fri, May 22, 2026 at 08:24:06PM +0000, David Matlack wrote:
> > > Inherit Access Control Services (ACS) flags on all incoming preserved
> > > devices (endpoints and upstream bridges) during a Live Update.
> > > 
> > > Inheriting ACS flags avoids changing routing rules while memory
> > > transactions are in flight from preserved devices. This is also strictly
> > > necessary to ensure that IOMMU group assignments do not change across
> > > a Live Update for preserved devices, as changing ACS configurations can
> > > split or merge IOMMU groups.
> > > 
> > > Cache the inherited ACS controls established by the previous kernel in
> > > struct pci_dev so that ACS controls do not change after a reset
> > > (pci_restore_state() calls pci_enable_acs()).
> > > 
> > > To simplify ACS inheritance, reject preserving any devices that require
> > > quirks to enable ACS as those quirks would also have to take Live Update
> > > into account.
> > > 
> > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > ---
> > >  drivers/pci/liveupdate.c       | 68 ++++++++++++++++++++++++++++++++++
> > >  drivers/pci/liveupdate.h       | 11 ++++++
> > >  drivers/pci/pci.c              |  5 +++
> > >  drivers/pci/pci.h              |  5 +++
> > >  drivers/pci/quirks.c           |  7 ++++
> > >  include/linux/pci_liveupdate.h |  6 +++
> > >  6 files changed, 102 insertions(+)
> > > 
> > 
> > [...]
> > 
> > >  
> > > +void pci_liveupdate_init_acs(struct pci_dev *dev)
> > > +{
> > > +	guard(rwsem_read)(&pci_liveupdate.rwsem);
> > > +
> > > +	if (!dev->acs_cap || !dev->liveupdate.incoming)
> > > +		return;
> > > +
> > > +	pci_read_config_word(dev, dev->acs_cap + PCI_ACS_CTRL, &dev->liveupdate.acs_ctrl);
> > 
> > I might be thinking out loud here, but as an attacker, this motivates me
> > to somehow hack the EP FW to mis-report the PCI_ACS_CTRL register across
> > a liveupdate to fool the incoming kernel. If the FW feeds a 0, it silently
> > strips ACS protections.
> > 
> > Should we also serialize ACS state in ser somehow to ensure we aren't 
> > fooled by something like this?
> 
> What does "EP FW" mean?

I was referring to the Endpoint Firmware (basically any SW running on
a downstream device)

> 
> Does such an attacker even need Live Update to attack the system? It
> seems like such an attacker could route TLPs in whatever malicious way
> they want regardless of Live Update.
> 

I agree that compromised PCIe devices are a menace anyway. But I was
talking about the potential window opened up by Live Update here,
suppose we have Device A & B assigned to 2 different VMs (implying they
are in separate IOMMU groups because the switch set ACS_RR = 1).

Now, the attacker has an opportunity with Liveupdate, since the devices
are already assigned, if *somehow* it flips a bit like ACS_RR, the
incoming kernel might see both the devices in the same IOMMU group.
Who detects this case and what happens if this happens if the devices
are kept assigned to these VMs?

Thanks,
Praan

