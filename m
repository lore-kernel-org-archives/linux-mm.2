Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 288B2CD8CA7
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 10:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AB006B00A1; Mon,  8 Jun 2026 06:49:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05BA06B00A2; Mon,  8 Jun 2026 06:49:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8C3B6B00A3; Mon,  8 Jun 2026 06:49:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D7B736B00A1
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 06:49:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7010040A24
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:49:42 +0000 (UTC)
X-FDA: 84856424604.28.2EA1CA0
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id 92107180002
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:49:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Qa38SBcn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of praan@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780915780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fmn+PdTc6vMvIeP/V6J1RAe1SscwIO8ISTB8QBGG6KU=;
	b=zLOnBDdfAlhFtQzgAtJu4lX6RYQStBmbeKL3NbAqxgbsue4d5xOb7XBAyA+QtKJ4WKD25p
	3lMHgGVorkXJv5Oq6+Kfcn1lWTUIvM3fJNWyLI+L2mNtxZgpolYd7ssECpKwGlPlAj0em0
	gV8smnLnUclT9Hgmc9HTlYB3ojAsgXw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Qa38SBcn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of praan@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780915780;
	b=tlpTdiPCibWYY2U6B5/4fkvzQSjU3RDoh8JN12aWlooFCjq+w071rJfKqyeWVqEigIzLaC
	lN+k1Y32awanfQv6zQoaNVDX4DSMdV/b9cVXIEhLixjsMGnsGVlf1pcaQmUxT7NnBGy7KC
	Qw6Xpmahs2Np/kWXIXWPaPDOoUKxmUY=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2bf22c18ad3so368985ad.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 03:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780915779; x=1781520579; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fmn+PdTc6vMvIeP/V6J1RAe1SscwIO8ISTB8QBGG6KU=;
        b=Qa38SBcnUCJNibWS7byLi/WF4cKmJlkfv1a0wilA8Tgxh0mwswGQ57TIT5ydqx/Lj9
         Tl3Qbr3tBObnW3gl2d9SJK42Nf/fcfZiX3mwYr/2slou2kIsqHWkL6Nz64DwevxaSsxH
         iCG28CwuVHXyZI+a0dupix0JTB7Rn7yqUXZtjes9vLMPPIILl0C5TpAgkmcIN3raq+3D
         pLE8rtYJOTnrX14eDG93O1gexXuXAmx5KTqoZ+q0dYfcGqitwKHJ92ERXRkpGcXGZICz
         f9uTsCVHkmCp327bPaFz6Xx2vXAPC83LHdZ66St/PcNBUA2mIy1v34ULafUStUV5BSSR
         3t6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780915779; x=1781520579;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fmn+PdTc6vMvIeP/V6J1RAe1SscwIO8ISTB8QBGG6KU=;
        b=UQ5re2tNViZP0KOkclRiDSB2PUeXvPPFHaRuju5/jDAMgd3EnvoTW0gNs9lYriHiss
         WYOLdzZelcfkAPaB36nUUy90VBMvEri6j7J1UPggQD2zFhcf7na2aDGkrGYE0+ZJRiAB
         LAIMn/EXiB5phfKGwWckRb3HIGmOGuxaNuonGOP+Hmmz/UnrAyqigpG57lR3JsLab+uM
         1ngUBh06CDwWIN7a5rYExW2evuzNDUPYa5IatR3zGku8Qby7/YUSnvsEdwqLVXGyoKiW
         HvvA05M1Ri/r1zRATXhuAfEM+C2tioWcLxEU3lvcMrdpGEOXT4Mx8mDQDLhhTKXtGwWq
         ulpA==
X-Forwarded-Encrypted: i=1; AFNElJ+egoKhtx4awDUDzXUr4mYyp7zpkzjGS6MC5HAen5zIODEyBfSBDadQtPaNiU3EtvbPzo2wmh6tmA==@kvack.org
X-Gm-Message-State: AOJu0Yzcp3n7pAzGEOkWALegv5nRe0aLxMMH1RrXfFLX1i4LAs1cmX2q
	9WS+55ZYpd8oxZ/gVNCCzr5SE6Pl0GaCReT2ff6jzC6pJFHbXs1D/lOmZhFb3awY0g==
X-Gm-Gg: Acq92OHAX9hIyLra++SRrtFuCpl8AIYmzrnc6hLwUKRaBYjdsRj90BxIJT2k+56INmL
	L3ZvCpt9tLlqA5eU2kXKtBIW2OTtXoAWV6saZoIrtFMQ+THbqj0WUpqtY/9fTJ834Z/NjLhXMOr
	csIJflF3Mveu8ZoRbWJX8nSzOiakx9eHcHNa6fEz2hxjLaAACrQG0hoC2xxN3u8qoMkpJizjuAi
	00ams/w34vyOxM9FAQCDB8YYWmkMGP1QSB+ZVgatAdqnRr8/qpROpQ5p8vVIcDHGfr+pGoVMfUZ
	9Nr5UdXCyWc83bNky+HHbBaYf/F4TlB17ZNb5GatNLmZBNx3VWO8Uj5L6dRQ/RkRlm9Qq1IX+rd
	NMeTre59S5vOOsCDlLbRIb4GwrKmRJfMHIk3IhDnq9S7N3FtF0tE9q6Ld0SybZ2J90/nkL09kyo
	/0H5+IfplDGhfPqXsbeTxgCkaa66gjbJgEBv0sPRbmQoY3Xj9YX3EAYwN0kxXVSOZsGfFBNYs=
X-Received: by 2002:a17:903:1986:b0:2c1:ee6e:4e50 with SMTP id d9443c01a7336-2c1ee6e51d9mr4607285ad.33.1780915778977;
        Mon, 08 Jun 2026 03:49:38 -0700 (PDT)
Received: from google.com (199.255.142.34.bc.googleusercontent.com. [34.142.255.199])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16649c302sm173906215ad.73.2026.06.08.03.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 03:49:38 -0700 (PDT)
Date: Mon, 8 Jun 2026 10:49:29 +0000
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
Message-ID: <aiaeOVomxQZhoM3K@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-9-dmatlack@google.com>
 <aiXWmR-ettxin4LC@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiXWmR-ettxin4LC@google.com>
X-Rspamd-Queue-Id: 92107180002
X-Rspam-User: 
X-Stat-Signature: 19pexeeohhb6krs1tptc33nbqpsm9kii
X-Rspamd-Server: rspam09
X-HE-Tag: 1780915780-217333
X-HE-Meta: U2FsdGVkX1/3YEJiu+tDxsgbjiFavSGzzOMd4eGZi9seetVbsFupox558uklX42Ryb3YCWCMu0xUKkXlWnpNOIdfzgfuP7o1re+NZ/fQxEd7qQkOJWqWY+C9/i3COoL7F7s3YrPlHCLwOUnNMak1XRLdf7Sl7b7QtlzlPSrWSOMjEF6UjKIl5nhsTnWu0PYLjaT/fi6D+rIvZemqwq9PWocYwPauOpXL46cDt86TIfMmZVPRitNHORoNWF0PE2x+71Sun+2wiKkCJjoxgjtWYlDu8KVbLIOLLDU8qe03lpo51rjb22ezH6DINlbAA4MSHrgeOaBHjorsHHJxj9o3YZL8meBbGwo0WP4shGRVnQZONGwmuMD0MJjRAllInBRRcHshwhyY5/y0ooTBXgTJWtCP4a/4c2QL5G+xpWchz6tu+Q4QkVgxDJ7vwOqJvMDiXeyTgTEFBM9RslCcZ79BeDsXpHinuWnynI4wqLCVhil25mizpZIZKaNUoe2wuBLZWK75/CUMEuHyOtnFDe1t7enzPrZPY6uwp50dR/Dg5CkFsXG/X8Sh3pUYf3FJhm58gfPsoJdL5hnVtihxU1o6zYeDvrwHPhQteYrW0Xm0URyMz5pQ/WqNlDk/xUiOZIKZ4seIhsRbT0t8r/BtpC+iMbz5oLAfleD3PAgD7Hed604cIBThPpgXGgIRy6WyfGGArFqbrgGEtTs79V0Mxxt40fOvBuLaXFuGXvylC2ukHND0iMdIK8ov6GilU0jUjmLvbAzaSkCpQqW8E/tXhb5ZAXNoBhRKPQ0bQDK9GhXzQ1V+GL4WznuZMYRuG3lRwW0Ge5z/ipZ8GyHKQBHRIrP/0NrnynVpabrJDchjcWThFLfUrKML3yPlFbGsrZKUqBRHMsEQ+Lo/thy3dfeyFOKQm8EzEmED1d47kkW6kGh5m6xkjj4t7X/VNatoUaRjcqOKC18VCeuRfuGWHYOyEpL
 4ITlJ1Ar
 2hFsM7dC/FjaQ6F0+yhBEELPs36YvCDtUa4Zbn4Nk0PlmY5sy6cztBrAgvENvx08+7l+ezdtAqlWIRVr3ul/VfObZ6YKAN+7g0e48DoqXYAGuodrZbP8kekLEMrnA9D9+a6mL8LjN+A66VtaRM1W43VIQl1XAOHc5fRhtP531/OwbSk6nmb1kEehp/2JTxL688WS/pmQp8YTYcpIliMyqqcIaTJp0aGVj7IDBuWGK3bYFGlCirVsJs1jFEEOIzMOWt3vJ3Dvx2jBDHFQAcbL8kty59JdmgUot2ps2VX8nKyKsX0mrPZRLkdJ2TB7rHOChIJ3/w1YOkyahD4aergTiPA17TO9e3trgVTy5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 07, 2026 at 08:37:45PM +0000, Pranjal Shrivastava wrote:
> On Fri, May 22, 2026 at 08:24:06PM +0000, David Matlack wrote:
> > Inherit Access Control Services (ACS) flags on all incoming preserved
> > devices (endpoints and upstream bridges) during a Live Update.
> > 
> > Inheriting ACS flags avoids changing routing rules while memory
> > transactions are in flight from preserved devices. This is also strictly
> > necessary to ensure that IOMMU group assignments do not change across
> > a Live Update for preserved devices, as changing ACS configurations can
> > split or merge IOMMU groups.
> > 
> > Cache the inherited ACS controls established by the previous kernel in
> > struct pci_dev so that ACS controls do not change after a reset
> > (pci_restore_state() calls pci_enable_acs()).
> > 
> > To simplify ACS inheritance, reject preserving any devices that require
> > quirks to enable ACS as those quirks would also have to take Live Update
> > into account.
> > 
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  drivers/pci/liveupdate.c       | 68 ++++++++++++++++++++++++++++++++++
> >  drivers/pci/liveupdate.h       | 11 ++++++
> >  drivers/pci/pci.c              |  5 +++
> >  drivers/pci/pci.h              |  5 +++
> >  drivers/pci/quirks.c           |  7 ++++
> >  include/linux/pci_liveupdate.h |  6 +++
> >  6 files changed, 102 insertions(+)
> > 
> 
> [...]
> 
> >  
> > +void pci_liveupdate_init_acs(struct pci_dev *dev)
> > +{
> > +	guard(rwsem_read)(&pci_liveupdate.rwsem);
> > +
> > +	if (!dev->acs_cap || !dev->liveupdate.incoming)
> > +		return;
> > +
> > +	pci_read_config_word(dev, dev->acs_cap + PCI_ACS_CTRL, &dev->liveupdate.acs_ctrl);
> 
> I might be thinking out loud here, but as an attacker, this motivates me
> to somehow hack the EP FW to mis-report the PCI_ACS_CTRL register across
> a liveupdate to fool the incoming kernel. If the FW feeds a 0, it silently
> strips ACS protections.

Minor note here: I used "0" as an example value, I'm aware that'll
effectively disable ACS and kernel will enforce more security.

My point was that a FW exploit can meddle with the bitfields of the
ACS_CTRL to spoof and mis-report the ACS flags.

Additionally, we might give rise to use-cases that start depending on
this, for e.g. if someone wants to change ACS policies in the
new kernel, the FW may silently update these flags across a kexec.

> 
> Should we also serialize ACS state in ser somehow to ensure we aren't 
> fooled by something like this?
> 

Thanks,
Praan

