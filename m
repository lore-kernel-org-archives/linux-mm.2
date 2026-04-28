Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 522F6FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:51:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7A766B010D; Tue, 28 Apr 2026 19:51:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2AB36B0110; Tue, 28 Apr 2026 19:51:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A19CA6B0113; Tue, 28 Apr 2026 19:51:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8ACF46B010D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:51:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4212C1A01CA
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:51:46 +0000 (UTC)
X-FDA: 84709614612.18.07C0681
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6730C1C0004
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:51:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nyKljRov;
	spf=pass (imf21.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777420304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=in+mysCXNp4IJcp8wpKV/ePcsC7P4CQwStR4ajhF2Xo=;
	b=SYpVElcUIqrV/br2vLqoubMtdTCa3ydlGVnUgvzGxYDF7bj7f78jebhstNcNe5jqJ9LYp9
	YEtjASmaHp0zGUwtZ0agWeqgQT+U+2xldCM/mSvoi2yXm1Zd/4DSSLhlGSfu1MDyEXY4i1
	lg9AdUgohlSip0vXjY51Rgh54NDaxXs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nyKljRov;
	spf=pass (imf21.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777420304; a=rsa-sha256;
	cv=none;
	b=WaWRrrv3+uDX3IC/UiYH8ARwMH3rCXqtfId4cI3boTI7fK66nfl37/oUYpABrq8qaP+Xkx
	6uy7e8CCDipPI3ZMpjC77ADEldjpRujjOc/cczbAln+cu9isYi9RD7taA1KMF0ATWxGpeM
	nsKAYyI3vtqOfyvJTOqOKAaOMVIx4vg=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2b45cb89f7eso74796485ad.0
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777420303; x=1778025103; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=in+mysCXNp4IJcp8wpKV/ePcsC7P4CQwStR4ajhF2Xo=;
        b=nyKljRovUVWljkyVtbz4bWdF2aJQ4XQkmgl6raBe8uzFsWIHPWikFHYTAK4qQFe1yk
         ZHTJMwSwrkrhUhZI3XiAcJlfLp+e426672PoROdCSmK6siceQs3I6VKp59gdku4RuUYY
         3LrkU3vA+KOYMdjB+dCeJbtK7cv2Y0e3GJQB5VAj/AGCXl0p/PY4ig7HEkT9Q765/0ql
         x2kv7bQLD6eO0+SYaMWAZBH/yww6T5jfZUfM14/7Eb02VgL5QrBvFrDMd6YpVxPHdtcC
         0SHujvgF3nDngiWRVnlrjl+UDAcm+AmyfXB0XaWfv+gEF9qZcpuUStZdbhduCLrTJagw
         XQwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777420303; x=1778025103;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=in+mysCXNp4IJcp8wpKV/ePcsC7P4CQwStR4ajhF2Xo=;
        b=OXYhIFw0z/oG9taRH91OroXyWe48KknJvhGYqC3JW+NHHo1HEi/6Xk5KzGb2vHdh/R
         N96HpnPBLR/C/WT0Wnd5X9Zvh9prcYAsepFdMARKtC6q29798FscyTkK6naiskPR6T68
         cwyZl+W9AKSJ7M80lyWzpwsN8zAxHxDNHggpRkvyAoDAQwJ3VpKhlR6M4oGUTOl3xfAS
         H1osb5MXwNRRh4m5WyKnPiVRFKRVDCzIWj4kZBmFb16kmsiEJtpZpvqvQIfq7hq1K/XW
         +t5Dnx6nzbXMbvrbKG5KxU1G4cusUdeym1LHp0j9E6Pkfr88JHyj78+bPIzOOlJoR30f
         eiCQ==
X-Forwarded-Encrypted: i=1; AFNElJ/8ZbqRSnynOOwhIrp+8xfkfgw2TT6tTtp6vYRphDHmoMhjxOUgqN/oBWeny5IGnPR2a7WcmtjcoA==@kvack.org
X-Gm-Message-State: AOJu0Yx7IYiHfqAShkaEH4iK7YnmsAwQT8LsEZEfYvU9eFuCUxTXt0D6
	lGl3JDmSxAE2vXX2m0PA2l6OQWaJ/7hfyX2bTF8085UcUQNCxDWjaSFAiwnovVmxzQ==
X-Gm-Gg: AeBDiet55zCXjSGgebfWKyNSdnErNESKtX/FN3gxJutzZao+dtlR4z5XshhQLVWTVFC
	nnvKA7+TPM3zRE6dvh02qHI25Yyw4hcIfcwRk7XH/GdSKdBuNrpgFCj1Q59M3iJE2gmqISL53u4
	CAJeSQwHHLPYCg5b2UAMzYbufdE7ZF5aVSPk/ra4SxcBNchPEllC02+iXTrjjmjy+3Ajlqw7S8u
	NPGNyDSCDZC0qvde7P8s71WiqyZ+GO4Qg/1uxWu2a4QvDiuCnVjNdfruJpwgyMQjSTe2JAGv9vl
	v6wEDRbUdTTnHlwlE2Loyjzb+nSXapKrNplAnGwklA/91wGzxcuOyuxpjmXnWG1LaVLVXbYkgfR
	K7IWbCEUZm6jSQkKiq5j4EnHUCCaoDGuhmZBl7b4g85Csj5rx8LOiN5lUJrxhC9hl7rPbyX7U/Q
	WkxUX3gWX1xq3gJ7BYoqq7np1VqyDo2Dn315S1RZGcqzayJ53hcvyrcZyUo6wHHzXXrb1B86s1J
	7Cm+w==
X-Received: by 2002:a17:903:a90:b0:2b2:65db:8c5f with SMTP id d9443c01a7336-2b97c4c8995mr46570035ad.27.1777420302688;
        Tue, 28 Apr 2026 16:51:42 -0700 (PDT)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b98859f629sm3480345ad.0.2026.04.28.16.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 16:51:41 -0700 (PDT)
Date: Tue, 28 Apr 2026 23:51:37 +0000
From: David Matlack <dmatlack@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: iommu@lists.linux.dev, kexec@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v4 01/11] PCI: liveupdate: Set up FLB handler for the PCI
 core
Message-ID: <afFICT9mSL1XG0v_@google.com>
References: <20260423212316.3431746-1-dmatlack@google.com>
 <20260423212316.3431746-2-dmatlack@google.com>
 <20260428185242.GB3825533.vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428185242.GB3825533.vipinsh@google.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6730C1C0004
X-Rspam-User: 
X-Stat-Signature: zizjdcfm5wfnuqamemtoz5kjjz4wnihn
X-HE-Tag: 1777420304-81949
X-HE-Meta: U2FsdGVkX19rbaqsMCzwxJxLIWedl2TA/NdeMsYXodUWETDO3r2dktJ4jRZSDS8khsEiMFZ+ABgQR7el/jAz2iKY7lNHu2NsUIpHNYZsB7VeWy7z5IdB7VAszb9U7A+uf8Q/IYeLBofiqlz74ZG0y21LaXkzueZCRi8mGtJ9kPHRCtP0DVAdMWPC68fWS8fzPILsgsT1hLs49Odr3tN4fhw1xpwAvMEydYwIO0MfnKwXWIls/a9Lg33IxyEwKLf4kHWKzOWm5eZSQm0sLLcC2Ww95pNahJ2uzHplKzqomisYD4hrAev6pxWT+p+UOddfw23YQFRCCto78f53Vuuoetf09z4sduVX4ZvK99UHMp6pWB+4TS5XrR1+b/tUU/FA1wT5vJnppdFg/xpJthg3QvnBvS8aHVymdNf9QIQe3B8fZZvbnGHKa6PdQutRAIz1YXB1wa9Ac8OspjmB9MEZzYzcBwErTf9OEa2bNbDrPBdWRHi4lBkL+vNP8TPJaTQkIBjMT9c2RwTq0BsFg/esQtIIDs+aU04wgXoUgFBZ8/iJIr4bzAeDNk/PdKKo893tNZw/SneofPlHhh9JcJ/NtRI+8bgeYr8DMRBaIex2tUESi3eUh5SiA4XLTTeNLUrBzwKlLJCUTV/boT26Z9Dobv53MNoo8dzjZ7Hz6JFUd5rwfpIkY5sJjJ1bgKJoFJhfXjX3NqcOL1B93hcqw7a35H0s/aecKfy1nkieLScha3+4me9ZUtmbIrd8W9gxHr8NGx0jQorLhr/EB6irZiP/ffGU0MdMO0tfEHd+ZzExD2Sls1EmWzSdUWGHI9o791aJ0F7Libx5QoqzeBLutQBrpxyrKiUimvsxrrRtg2oVm/r6UJH1nLuKgdcXjbk5eEU6fNWTKmzrX9eFZVdpVjEOC6+2rXTKzRSbgUBi2NJN3wB/hzKjEYZxC7/ec3M67d4DJgbd+SFInIlETe4IrTy
 OOU3VBfu
 urejCGiwSra8cTd/8DVzy1ZP4REFKVEoAEQzU3tSefDQkUJVxGWhJIBdsFPIqjQ8Doe1tOnPV/YwKHgmmkOHWeY8KUpCv5LPXFdsNgME3QuX7f7FKVPXDKjT57y7QL/UbhoVSZebzCU83ZLfBsKlsmluZLnm6CXSdKlrkG4r2rkr7kkP9gGivF1jfgv18KWEcGdkRQ2MZUuJM/sfS1QLkQJpAPX1VfcJ2YQouWI5kjBn1El9HcLT/7jAX0h7ZwyNqycXpmrwpi7KIglzIaZusGZ7l9cCFDY9zBxI5DMsVrU7uDttpGvY7o75r51Mf59CDdbaSHWTXRpPtCYnC51qoiieENq994l64Hu8KCTEKcl93JnY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-28 12:45 PM, Vipin Sharma wrote:
> On Thu, Apr 23, 2026 at 09:23:05PM +0000, David Matlack wrote:
> > +	pr_debug("Preserving struct pci_ser with room for %u devices\n",
> > +		 max_nr_devices);
> > +
> > +	ser = kho_alloc_preserve(size);
> > +	if (IS_ERR(ser))
> > +		return PTR_ERR(ser);
> 
> Should there be a similar pr_debug() in case of failure to denote that above
> "Preserving ..." message didn't finish, or, maybe just print one
> pr_debug() after the error check above?

Hm... I guess there could always be more pr_debug()s but I don't want to
instrument every error path. I could move it to the success path but I
don't see how that makes it any better.

> 
> > +/**
> > + * struct pci_dev_ser - Serialized state about a single PCI device.
> > + *
> > + * @domain: The device's PCI domain number (segment).
> > + * @bdf: The device's PCI bus, device, and function number.
> > + * @reserved: Reserved (to naturally align struct pci_dev_ser).
> > + */
> > +struct pci_dev_ser {
> > +	u32 domain;
> > +	u16 bdf;
> > +	u16 reserved;
> 
> Should this be renamed to 'u8 __padding[2];' instead? This will allow to
> just change the array length based on the need (0, 1, 2, 3).

Sorry I'm not following what you mean here. What is the reason to rename
this field and change it to an array?

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
> Nit: Maybe move this assert to be near to the definition of this struct,
> easier to find it when editing the struct vs finding it later during
> build.

The combination of these 2 asserts is what guarantees that every element
of the devices[] array are naturally aligned, that's why I put them
together here.

I can move it up though if you think it's better.

