Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70D91CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 18:48:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7DFF6B0088; Thu, 30 Apr 2026 14:48:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B548C6B008A; Thu, 30 Apr 2026 14:48:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A92F36B008C; Thu, 30 Apr 2026 14:48:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9912B6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:48:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3BEA416020B
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 18:48:30 +0000 (UTC)
X-FDA: 84716107980.13.58AC184
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf26.hostedemail.com (Postfix) with ESMTP id 50FF6140012
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 18:48:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mFh9c9UT;
	spf=pass (imf26.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777574908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9xAzQZcfn4hf28SgvSsobLbrv7DrZRSNcDWvXS0OfYE=;
	b=wCt1lvACXDyFdnOrUjRKx7HRIDUDViebRWWdOWGzhFhZMyBszZQ0AuC+S+cFByyDVqaaoW
	LocS2ihvFKBSJCdNpeqU+MC+cz2+Q+WV7WrYu0UDoJ46+J1g7nIE9mfHeq4uANUshGWe/Q
	L3PVW+Z6R4cWx9rtID/4GRvLj7Iv/es=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mFh9c9UT;
	spf=pass (imf26.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777574908; a=rsa-sha256;
	cv=none;
	b=PmCet3KbE3bXNCFVdnRGnpewm0xbNDO255AvHnLtdVc4Qm+XopzwqWXsjNYaOpLIWjl60Y
	0NG5M+MBR3brvM6D0pLLZFvRN3yXxoUbdkrpjmOIZ6QdNI6Tz4/nrTXEu07Z/eos0XkW71
	5XmNoZHzI2Y0KSNUsPl1Byx0GYtI+AU=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2b243198058so24655ad.1
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777574907; x=1778179707; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9xAzQZcfn4hf28SgvSsobLbrv7DrZRSNcDWvXS0OfYE=;
        b=mFh9c9UTwV0oyU9j9SwgEYU1dM+9M+EjzwTWMCnv8jpwD/LUVXRFqJO3ZSBrV+VMjd
         pMhlCDbHX4F7tqLgeXlogj/UbRPFoqOd1Qr9u6hGPh9NEwbrTz6/KRWCShZv2FZMmgyw
         c2CpYDCcdKhc9guwXoVm+3HsaDj2d57USUXCtU63HBjJp5l7mfQvK2MefAcrN27j4WSM
         dK23MNr8SzY0IeSCyFHOcZMOmj8M/6CRP5r5s4TB1DGqbg39HLU4vu8Ya8pqiUzRDf1x
         es2tJKDF2R3yrDQ0+FnOR1cr+jgN0cEmmkAaJcSU4OFDVXw9E62NrXDWzOG+677hO/Pt
         e2cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777574907; x=1778179707;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9xAzQZcfn4hf28SgvSsobLbrv7DrZRSNcDWvXS0OfYE=;
        b=Vu9S2MbV+gsuK/c7TYuVxN5R3LoyLKAWMHnfmCK1bIw1Djsi58txIfWhsszd+b30QI
         E0/z45A7k4Y7jzwfrRzkF3nYoKm41hSROd11S/qnrxk2sElk6MsStg0RSACxI1URS199
         Q9oXFDy7CDEXG/XApd6o02R0nkiCeGQJe7G9zRgVlKWkKCBJVVTJ2oUoMvF1JQKupTGR
         vlvTuh7TidwPpjV2dYOEl8IFKG3DVXLUJ8XHAQDfDkYvWB6LGqS6ZDomVap7fYN9fSCZ
         KgjxIJ3vW3OEXrBDUAtm8EJ5tLcQkJO+hEJtC+84vaPSsB7o3cPw2grS33ZBNtjdmbgH
         RG5Q==
X-Forwarded-Encrypted: i=1; AFNElJ9stR5P7Ll4i7IAHhf9K8cCw/UjmivUXPZ6foBsHkYKwxDssHkd4lGsmeoiVxiev53vggkLU2+fsg==@kvack.org
X-Gm-Message-State: AOJu0YzX1Y1dWeiFjLGII8LPF5JTzqbfZOYp/vVAcaAeJk6WyXVD0G0j
	wgggvwIvhkNVLsfG6W3/Q/joX+OKVjOMznyoIVlAmulSiBw7yRiysPywgrtj5+UasQ==
X-Gm-Gg: AeBDiesTKwgPGGJNpkefCvEY+zSq3mvHRWuXSUs3BxK2L3BN5muncQ2b5AxCBQwgsoH
	eATU2x1pb3xWNIostNb7iwsgf8YTGgsacTpRWUJpsA+bK1LHN25QsG3pc3+sifS7irRdfHHDZqN
	BAty0kgOMcNP4GZ6nu3fUAxnwxPgsXUuqm2e2rON5hsXh6/B7sJPW6YD3Bw0NWApQWQSY7YJM+C
	fao5Pq7LcmFpLwApCbpmi78WSVoMKo2spTRbpYZ4w+I4jn2hFKS9aZegA5xYBdql6UjmBjeZMza
	ksvaWrNDIldvl1Ma/b84rQUMtqybQlI8AsZ8m11Mc9ibpmEJo6gNd9npgX0+KLjKouITwZ49zLi
	mzGOYQajMNL6bWwS37P8DQ0ddhT4CODehAj4wLS7slRp56/kndcCEUl52k45OIC+vYHa1ZjrLHO
	XyfM91cUMJtuTr78rJH0i+GVOctLBCd8uQagDHqNMZqa2V0PQsQviC122m7S8ANJhnZbgrNGRCf
	icXF77EgQ==
X-Received: by 2002:a17:903:4b4f:b0:2b0:5c88:51e1 with SMTP id d9443c01a7336-2b9cd98bb43mr418175ad.14.1777574906266;
        Thu, 30 Apr 2026 11:48:26 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9caa7e47asm3289405ad.15.2026.04.30.11.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 11:48:25 -0700 (PDT)
Date: Thu, 30 Apr 2026 11:48:21 -0700
From: Vipin Sharma <vipinsh@google.com>
To: David Matlack <dmatlack@google.com>
Cc: iommu@lists.linux.dev, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>, 
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v4 01/11] PCI: liveupdate: Set up FLB handler for the PCI
 core
Message-ID: <20260430182532.GB13902.vipinsh@google.com>
References: <20260423212316.3431746-1-dmatlack@google.com>
 <20260423212316.3431746-2-dmatlack@google.com>
 <20260428185242.GB3825533.vipinsh@google.com>
 <afFICT9mSL1XG0v_@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afFICT9mSL1XG0v_@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 50FF6140012
X-Stat-Signature: 9a9n3ynozgx9mh9hhe4fqyrkhgcrwbp1
X-HE-Tag: 1777574908-138084
X-HE-Meta: U2FsdGVkX19TjzvFl6osu5hkLZn14Udf4e1SzGtiRlwFET6yLHdy1uKPPkyJrQCw139wef/PXp8lXq1F+ZkREjyn1HF8dnazym0jljsjbNCz2qPwiOE4PtGprm1XpeGu+TplfolCM+wf5tZ9B1bm/QK2EOS8batggo7ANgH7r5bzBTqw4/HJ3ABuY7cwrjremTxjlMDyRs9EoxKMADzcLh37TX+2q2b/fH6UWZWyQTqIsEg8VBNFkNPmK3qEaIzIoHoBK5cINpzYd2ZKezhf0/DNYFcKVcw3Hu+xh2FaIl/e8FgAgl1XXFjdZ9Zpy3aydR4vp8vZGJoZeNHZs5oq8I4isc7vvtMAmpAeh/P1fEK8UOj4H22OUY7EVpxM5E+/ks+CGqS1aa09XIOXd7z+stFx9UeB+zModvuqX138C8+kInVZDsB5o9+wgihpH1Ienl98ckX6Nx0U4FAnac3D2582tf2miejsM1vDJNqJ96y2PbRCFpH/I4Yf3iLIxlpfJxqQektsdraDag7e8GUeDtyB2hRcP2YbPlhcJkmYd+MT2LVpL5QXTbmq2+XgK6TXcJT8m6ZBjx7L7kLy5dfcmtDtwhHk4T09yBXSLrNZw1aqiCOkT92sm5csNErYlPsEQfEVe+INhi/3oKQwnuwRdXrhmDL+d4xbDIpZP14fLr5zrLYfidVdC8wqvYJpSI5BApECgWFEkSXVQRS9be3nKasmfz/kaKJS/WtRN4+Wp+QSGocQmjInzduGCOwQ1dKUwZ/mwnRabJsuKXGszlsRPAuu9msHjBkRdTD9gr7vfHX4UfTDTjcjY+RGVuEuR11oqSjNtZJciKME7waxwKoxfSNfjQDd5+e1pJeSpkwT5LRfaVFVL4pd70LUzEzm3qUnPz9B2XThU6dPnuqng1zrAwAlK9tUTFHhhl8Nw1T9/FpRxP5rXFjeHXczrx+kq5FvpLud1MMGkqplp5FAFNO
 bv+pYpft
 NYVPnHqFD11eWfBMNpbVgiEmV9VWKWza43RtxyudP8E5GXJlEKoxP2m+WbaiBjO4ReWWW8ibJokqDVhiCScFau0WnPEjOMBp8LEw8YFgEDx7eTjXVIyXOwMlF5UU+Xat2r+kQvaK0ZWDKMSPh/zXKQNDFuodLmOT3VVfJWBB4daNXBAVVcMtjTmEX6OxeJEaU/AVlCue99DjMipzzL74k9jRnR05G/xlWhQ9sPErdYrfQUYHWpPSMliATRgq1vTXL47ADGuoEBEnVjnbj7L8VA2WqkvyZv2Fjm4x2ZWytiDQx90Zh5AFVy8+h3qKscvQVTKQvyCvp/xe9YWVcE/XlCdunestgLJ0QnRPKoRdMn1WhTHw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 11:51:37PM +0000, David Matlack wrote:
> On 2026-04-28 12:45 PM, Vipin Sharma wrote:
> > On Thu, Apr 23, 2026 at 09:23:05PM +0000, David Matlack wrote:
> > > +	pr_debug("Preserving struct pci_ser with room for %u devices\n",
> > > +		 max_nr_devices);
> > > +
> > > +	ser = kho_alloc_preserve(size);
> > > +	if (IS_ERR(ser))
> > > +		return PTR_ERR(ser);
> > 
> > Should there be a similar pr_debug() in case of failure to denote that above
> > "Preserving ..." message didn't finish, or, maybe just print one
> > pr_debug() after the error check above?
> 
> Hm... I guess there could always be more pr_debug()s but I don't want to
> instrument every error path. I could move it to the success path but I
> don't see how that makes it any better.
> 

In current way, it is printing that it is preserving pci_ser, but there
is no indication did it succeed or not in logs. If we are printing the
logs then may be complete picture will be to know what is the action and its
result.

I think moving to success path or printing again based on the failure
provides assurance of what happened. If this gets printed in happy
path, then we will know it succeeded in preserving that struct on
kho.  Absence means it didn't. 

We can also remove pr_debug(), if this is of no value.

> > 
> > > +/**
> > > + * struct pci_dev_ser - Serialized state about a single PCI device.
> > > + *
> > > + * @domain: The device's PCI domain number (segment).
> > > + * @bdf: The device's PCI bus, device, and function number.
> > > + * @reserved: Reserved (to naturally align struct pci_dev_ser).
> > > + */
> > > +struct pci_dev_ser {
> > > +	u32 domain;
> > > +	u16 bdf;
> > > +	u16 reserved;
> > 
> > Should this be renamed to 'u8 __padding[2];' instead? This will allow to
> > just change the array length based on the need (0, 1, 2, 3).
> 
> Sorry I'm not following what you mean here. What is the reason to rename
> this field and change it to an array?
> 

Having a padding explicitly tells there is a requirement of being
aligned. Reserved sounds more like don't use this u16.

If someone add more field down the line say u8, then to make struct size
aligned they will need to add another u8, u16, u32, and name those
fields padding or reserved. IMO, having a u8 array named padding makes
it easier to just change array length as per the need.

> > > +} __packed;
> > > +
> > > +/**
> > > + * struct pci_ser - PCI Subsystem Live Update State
> > > + *
> > > + * This struct tracks state about all devices that are being preserved across
> > > + * a Live Update for the next kernel.
> > > + *
> > > + * @max_nr_devices: The length of the devices[] flexible array.
> > > + * @nr_devices: The number of devices that were preserved.
> > > + * @devices: Flexible array of pci_dev_ser structs for each device.
> > > + */
> > > +struct pci_ser {
> > > +	u32 max_nr_devices;
> > > +	u32 nr_devices;
> > > +	struct pci_dev_ser devices[];
> > > +} __packed;
> > > +
> > > +/* Ensure all elements of devices[] are naturally aligned. */
> > > +static_assert(offsetof(struct pci_ser, devices) % sizeof(unsigned long) == 0);
> > > +static_assert(sizeof(struct pci_dev_ser) % sizeof(unsigned long) == 0);
> > 
> > Nit: Maybe move this assert to be near to the definition of this struct,
> > easier to find it when editing the struct vs finding it later during
> > build.
> 
> The combination of these 2 asserts is what guarantees that every element
> of the devices[] array are naturally aligned, that's why I put them
> together here.
> 
> I can move it up though if you think it's better.

Okay, SGTM.

