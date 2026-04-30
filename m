Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABC99CCFA13
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 21:16:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FA276B00C6; Thu, 30 Apr 2026 17:16:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D1726B00C8; Thu, 30 Apr 2026 17:16:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E85D6B00C9; Thu, 30 Apr 2026 17:16:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F14216B00C6
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 17:16:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9BF0B1A01C1
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:16:11 +0000 (UTC)
X-FDA: 84716480142.23.17161EB
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id B02EE140010
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:16:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NO3KxNQK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777583769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qKjNRn2md89MeJaRqxCLA5wY9NhKNsbLMVT1tb1aOVs=;
	b=eKMS9dkNlsoUkuhTQmSxGHkCm4JkR9y2kC7tw2i3O6oxGADa+Gfjz0GYCLFb8/mhlS4LrM
	ZcswHrWs8ZX/lsyFCzCl5yEeJPgAiHcISBDS6FCIDY60Dq3jHntak1UD6ZVbSiXOa8t3vA
	xwNiA18R8/BvqotDvXKZGxPn1r5SGO0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777583769; a=rsa-sha256;
	cv=none;
	b=NWwf7h5Nnf7gPf+Vx8fX+Ley+zl/ty58pib8m7zSrgt2s/IZ0oXlvXxtsz7qllQRK3v/Qv
	il8mOlbllaAjGhjTRJmkqAKYhZjEcn6yNRPG9OjDSzBuUZVn74mi1K4Js0VeYq1HFuuWsz
	GtnmT7/EPnY9geiZgIPfWrLL3mjMm6Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NO3KxNQK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=dmatlack@google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2b24fede2acso8606005ad.3
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777583768; x=1778188568; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qKjNRn2md89MeJaRqxCLA5wY9NhKNsbLMVT1tb1aOVs=;
        b=NO3KxNQKzZdcL9E6C6nW0RZOjGeCQsi9jdm7QKq3mQTLpHlwC3PrzC0/SC+xw7GMVT
         1rub9K/It35Y+GLtjKL4kJeW8ItN8iUgxk55k4JbPkLNvpen2XOiYtkncTSt/7ys9NyM
         oDi/OoIeXk4rhN/xUkaZ+RNSKUlG4IJUQOQIjHx1s2uIIV40ZeZ1svE/uTy+cd9biKVg
         Hej36jXth8/McwTlADvndc99zIyB13FWw1KGxHtIKmZBX3ysyoZaJV1uYaU7Q1JuZ3Lu
         wIPOjzaODfdaI0fm2h74TEhcXdSs9H3VcrrbwVKo9s/jKXhXsff643dYVZ4nReoA7NmL
         bHvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777583768; x=1778188568;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qKjNRn2md89MeJaRqxCLA5wY9NhKNsbLMVT1tb1aOVs=;
        b=tNsUL6D/LPZ8czvoHBH27+Y62T2CzEYiQkTvPy1dqMgKoBFQ93mwvh1ts5AoMpdqR1
         BX2AVT8mfTwLzPFGZOqA4qAeTUioHq9M60+3AVo11G7sVzkK75ASPS3gGJmZkDctmFOQ
         fnHpsoXVoVpMPLKvZDdUhZJgO71+v7Hde8qwp5aASOwPHo7lhTlaXz3o8seWbl0G4RFa
         MrDuZHPjrDRZGFr38nUHUZWduJcPqke5D3uxB5o/Kx7iGEmoMsY+TGDDdUWo1D+trMbO
         dB/1ox88XcPvEpp++lNWcgjUDvX1q0Csht1kZEn9mwJudRkrbeAACm9UEDAn7HobdNmY
         72tQ==
X-Forwarded-Encrypted: i=1; AFNElJ+nHiaovmTzl4UHKNUodkKZhgCWNjGxfJ+1UnwVg41up267ZOZPn5eBqNEIn6mcxSaiDkQvYntDIA==@kvack.org
X-Gm-Message-State: AOJu0YxuD0d6CDFkYqtl+VNq/6Eo5eI28nw6nuaDb9o9RwgGWfchu8DF
	aMl0Uhm3rJQBGkENRZVKHqoLLGwygOeJHeXoEBkWgXyThGAijcANWjp8bENtCdk0hA==
X-Gm-Gg: AeBDievoFVk1lttSBVJOi8zsmz2GDL/D6Xthf0vAAj6oNZY3osCxrzdVQfX/zpoKKun
	+K5mTiJxc87750xAv83cZhttf4PT7jxOFUiMPt5L60IG2t3vaJMg+O85E6ybIzuMI622NuMzE8M
	Y+deMbObGFrpxk+K6et8hFqVVCmvyx4lV2BCagxzsp3rfui3e6nAiWBDfm/P00PkTYs3YIaBimg
	Zr2L4sfjBYQn1J/pQBYLu2I9ijzWpIA6B4Dl/wc11Lda5mzXNhFbJ6qKKJyiTni3ULSvFdB9wLi
	D8vHZ8+39yNgmqqzLK1Ohx+f6SAtohsyd6rNv0Mxlbn+8N0qZPhj8P3UBFtD5YnfKkcVsnUUH3h
	dybaHdWgRL2lsaS8Ud02w6ElE3IGqtUWXTON6m9eEagnV4NwHFiFCKp6Z5Yv7xGeLlhessqz73u
	twywdlPdwLpzfWV8Oe2semu5aF5OK4KGaM3swiatHF3E/IQ7t2vWBb4ym1+3wPqaWXT0edshbxy
	n/8aA==
X-Received: by 2002:a17:903:22c8:b0:2b9:9086:da9c with SMTP id d9443c01a7336-2b9a234e736mr49645755ad.17.1777583767972;
        Thu, 30 Apr 2026 14:16:07 -0700 (PDT)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9cae67196sm5018815ad.79.2026.04.30.14.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 14:16:07 -0700 (PDT)
Date: Thu, 30 Apr 2026 21:16:03 +0000
From: David Matlack <dmatlack@google.com>
To: Samiullah Khawaja <skhawaja@google.com>
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
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v4 02/11] PCI: liveupdate: Track outgoing preserved PCI
 devices
Message-ID: <afPGkxjCdPCL8MLG@google.com>
References: <20260423212316.3431746-1-dmatlack@google.com>
 <20260423212316.3431746-3-dmatlack@google.com>
 <afDqs6oqWlhoVqMN@google.com>
 <afDvVhkp8tQpsVlt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afDvVhkp8tQpsVlt@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B02EE140010
X-Stat-Signature: ojj9xwofwagaz33amwb5ypzqx3dk79b6
X-Rspam-User: 
X-HE-Tag: 1777583769-440911
X-HE-Meta: U2FsdGVkX1+VJsdYDZVsIrWYYTna2RVp2xwB1aew8l+Zcu4hOAakfkE+MByun76P+BL5VrzzbaV5qyeqUMImDlpXdxCKC/05wkDhG2jz7ovSCKWowP1L/0SR4Spo1tLIiE2L6oCCOVZPBtOUiF9cw/htnXnVhlTeZ1+dtgfiNj1n/JqfgZW+C35TWjlnGHQP4PxZ084AjKMSueUqfLHN+ne2XGSU6D60s1RdCmbSrpEaky5fX7XLJuBvSAB4dmgIfJD6XtiGBNrF0ncCJlIg1GYDl7NcL48Mz0s9KnJli34nnXxcguA1I5fQfv6C/G2jz2WZ1wwxTRB9MkS2w+nn3rc0u5Cj8Kyh97gDOWZcJDaEOtbMjhMcdPMdMUdTl1/b/mxtkTCAYzlZ/rAMcLiO9ac4I589nYQX0w/As5jk8DNh/iyp0/Ev3a5RXByi5TNnyDoZTsHM7kToKQdUeDl01HrmHtXsgyHrbLubEUgreYwFB0dFP110M2RkBZZ8ZRLu73EOdn5YnqziSyXU70ncohNFyEzI3YIFNtAQGy6MY4cWrLsBOUvlkEI0mvoEN0kaAgPSIjMYg3Yn8ea1gX0E1eOxmivOuDy/VrOLV8QnDE3OgV3qPiTyS/P9DzAxC+2lvXcq0vR5Kb6E5eROYnPDH8U7jGA/mmbm6IDXbXfwEi3IE2A4tCLpbce9E6NiEqyXa/5TeiOn64GBpLNRe+maWbsuYKwOZHyH9eTrtMoj4VH8+Ouifaawt4eKPf5T7NBfMBf6klaOJx0IYaf+oK6SGGMXFa3Vil4skm5qoTYU4QrG+zG995LR+vny+SgY6SUc67uVvq+Nq9lMwaArD2Yyvd7+hblRhb7+9V28XQhkqvXgU3bU1RylrZ+hc4KzVGIi0TiYmGIPXGY3ZP6dndQGy2pElLuKlFEkbN1v3Y5GAKjXPBNt19Bfe3GAfl0yr1GJMWV30dCQF3cG2tcqqQF
 GST/tZ5w
 cdKTJMJP+E3+0L1CWCkxiJwzsWNJx2w2+d1+7Hy6Kvt5A8m4vs+HHKflEfNyQqIOchqVRoXjWttI3sPKFDWNKIMQ0EvArdCGtd6wDBPT9fjnXKvlC2xaAyJUeI+iXaArtYL19dQrC+u8eNC2mPwQjUQXSBmZ2m/KCRJlNNRvXgOb9qi68h/hptOsrw3OTOF+BSucQT3UMMK7k/pjCMeypFPI/G6PHatqMAzM4xPnflRRKEZw05j9ImrXQisz2iLDP8Plnp2ICoLJFzYx+kUtSN+6uOCWnyHZkqpfxwh3K9cYAnphoVhu91iestN+5oBr7cRvPS34NnozR1dkBV/dVbn3ZB8xrEDRx1BB2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-28 05:35 PM, Samiullah Khawaja wrote:
> On Tue, Apr 28, 2026 at 05:24:53PM +0000, Samiullah Khawaja wrote:
> > On Thu, Apr 23, 2026 at 09:23:06PM +0000, David Matlack wrote:
> > > Add APIs to allow drivers to notify the PCI core of which devices are
> > > being preserved across a Live Update for the next kernel, i.e.
> > > "outgoing" devices.
> > > 
> > > Drivers must notify the PCI core when devices are preserved so that the
> > > PCI core can update its FLB data (struct pci_ser) and track the list of
> > > outgoing devices. pci_liveupdate_preserve() notifies the PCI core that a
> > > device must be preserved across Live Update. pci_liveupdate_unpreserve()
> > > reverses this (cancels the preservation of the device).
> > > 
> > > This tracking ensures the PCI core is fully aware of which devices may
> > > need special handling during shutdown and kexec, and so that it can be
> > > handed off to the next kernel.
> > > 
> > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > ---
> > > drivers/pci/liveupdate.c    | 101 ++++++++++++++++++++++++++++++++++++
> > > include/linux/kho/abi/pci.h |   7 +--
> > > include/linux/pci.h         |  26 ++++++++++
> > > 3 files changed, 131 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
> > > index 5c0e92588c00..5b4c8d9e462c 100644
> > > --- a/include/linux/kho/abi/pci.h
> > > +++ b/include/linux/kho/abi/pci.h
> > > @@ -23,19 +23,20 @@
> > > * incrementing the version number in the PCI_LUO_FLB_COMPATIBLE string.
> > > */
> > > 
> > > -#define PCI_LUO_FLB_COMPATIBLE "pci-v1"
> > > +#define PCI_LUO_FLB_COMPATIBLE "pci-v2"
> > > 
> > > /**
> > > * struct pci_dev_ser - Serialized state about a single PCI device.
> > > *
> > > * @domain: The device's PCI domain number (segment).
> > > * @bdf: The device's PCI bus, device, and function number.
> > > - * @reserved: Reserved (to naturally align struct pci_dev_ser).
> > > + * @refcount: Reference count used by the PCI core to keep track of whether it
> > > + *            is done using a device's struct pci_dev_ser.
> 
> nit: I was wondering why is this named refcount and why it is needed. It
> seems you are using it to track the preservation dependency between
> parent devices and leaf. Maybe add a comment to clarify that.

Ack, I will clarify that more in the kerneldoc in v5, thanks.

