Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94E09FF8867
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 00:00:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFF976B008A; Mon, 27 Apr 2026 20:00:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED73D6B008C; Mon, 27 Apr 2026 20:00:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DED1D6B0092; Mon, 27 Apr 2026 20:00:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD5DA6B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:00:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2ADAC40229
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 00:00:07 +0000 (UTC)
X-FDA: 84706006854.17.1623417
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5818280008
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 00:00:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rWBBgk6T;
	spf=pass (imf02.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777334405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tW+6Pw0a8+ahYm3oOFUJTtBa/jkSN4mmIAQkMqykSWk=;
	b=EtEj57qxyU1tBGQ0qapNImdHaCAk3BoD/9zlyo9PEmEDjcG3mvPGo98LIF5KG+pq+e2WJV
	wACl3b3zyktySYG3bR0FrSzJwX/h43LFK29hPaIiBQFmcE9sp+IBRffLCkNU4dIqXumJlp
	DYmpf7jPLslRxBOCKc/4wbbveTGjpNc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rWBBgk6T;
	spf=pass (imf02.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777334405; a=rsa-sha256;
	cv=none;
	b=B9RW1eFKBHb8YWFBgRYkufZp23TI04mJEEn/Ti9Q6XtWoP/8gBR3zaItfTIMt994+3I9dm
	eOVX18L2GWI4HoHhj47jW7ojdsnbjnI++aviHUpj2ugPY2389oeQ/5ae+mYRaM8Cjcdx0z
	oGJBeVgObkAxzIl16dq0f3JXlx8JrSQ=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-82418b0178cso6630358b3a.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777334404; x=1777939204; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tW+6Pw0a8+ahYm3oOFUJTtBa/jkSN4mmIAQkMqykSWk=;
        b=rWBBgk6T0o7o6u4eYNxGJp268cZa/Tqe7teMeSFdY3B5oJlXU/aNSXJJFq7S1MolPf
         RaZEj5jMP+hrZoYBqKq6YvwrxII5RItn99WECtYsFa2+7ghHTlAESSXFS7Yvcj0Hp7Di
         dFTgBMC4ha5eS22Hj18jb2JHVQcBfwT8JeovmTMZFxxf+79UstyFZBgR2DlJuw8qOV7p
         TXp04Pny4kJhw5rbAUkH1PgzRz40dgWsY154OYgKgOtfrVmfLBRIihdYzW8PCFYIA37b
         Q+H0n99/MlUBBzzUy/OLZCmpgqD0Yd8nKxoRJD7DTy/Wn1rupgGlYvHvHELHFssDkLnV
         p4YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777334404; x=1777939204;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tW+6Pw0a8+ahYm3oOFUJTtBa/jkSN4mmIAQkMqykSWk=;
        b=dKfJrUdJppJs4VFwG2mPVWL7SZipJdHBzKwkT379Nk5wMyxfyNFdqnudt6v/o6ESjJ
         SSBYCID6tfnhDRauRPhhzkrL/J5NNugFOReXdqR/ZYBpd4PyJHxVNjOcxa/kyEVBLZqT
         jD7jG+Q0DQPYIqeI5FhXR9dkSHv3DCNaLddZM8FwcsIG0dH7znYVS/VrB+NPfaaaXnlT
         8B5C+HyixmpC6Aac7Vnx4En/T09Chc8eylqLX1PoV1yt7//SX4xL/ihZUghZrApZUCFp
         +fPSmDIw2U6wYoFFP5n6SUfVXI8amxTSueCANBVOhpJo/jKfEmqLYNZ8sgLsJVMTiZ6p
         er+g==
X-Forwarded-Encrypted: i=1; AFNElJ95lToUDCMJtHa7RaPojE9H8NGYlqQ5PvbXZjB1OuKZcazV5N/O3vMjufnxiseH6/Ah9zEF9iBItQ==@kvack.org
X-Gm-Message-State: AOJu0YzXI+L3JP63eU0cmHga/UBrCQb0jCdFYAsCs8Tt2w6QMIo6uR2/
	tirNNWEFodSBCBa+aby5ABY5WbELjvkPJu1uBJulYeDwemIw0QnSYDZv7VY+/Xk1Sw==
X-Gm-Gg: AeBDiesLE4/5QRQJkiNCrRXguRepTajCx6rOObYV0qkAuuIiH1jwcw3Rh0O3jkGF3ps
	Mk+uSo9/JzDiFERmYk5bOtrhaSoJrOnvqmpH1ag0awTg4oibZ4SW7AJzXSYlCsEl8xP5TO4GcxP
	ZpQSTO2uKEFuQvlr2jiWY9aCAc6gNgcDjyaifNl4FYbpA1F7hlHgOTFz8H9VUVpOuwWNPAvRZdw
	6tRcMn6MVwlxOINLmBROJbRQjL9pZP7Pb/+alqD81dvcgxu7eMRtUmz3A471c9/IWhtEd1MyU+e
	8q7vdQ4duzd6zqF/wfM/A9YfKSbQ+EJfD5F1IGUdoNsdWN8WoXUH34WR2IC7HVsG+XvKWy7OILW
	f9Im8BVB9HsxQ6hCGc5c544kIZ7ANrd5CIrQfEDmc0dygZ6wvR2ouYKv0ICNee+Yw1ZUHZjFS+B
	wGCP/kPfH404vv1jLYu+BP4wUKn7owiMR9Kzhglpl2tZscrjVJFKHDDoQ6p6fdL8RvSACkaeY5C
	7aYog==
X-Received: by 2002:a05:6a00:1885:b0:82f:1d38:f68d with SMTP id d2e1a72fcca58-834ddc22f16mr638227b3a.34.1777334403001;
        Mon, 27 Apr 2026 17:00:03 -0700 (PDT)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-834daf7f43bsm633995b3a.58.2026.04.27.17.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 17:00:01 -0700 (PDT)
Date: Mon, 27 Apr 2026 23:59:58 +0000
From: David Matlack <dmatlack@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, iommu@lists.linux.dev,
	kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
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
	Pranjal Shrivastava <praan@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v4 01/11] PCI: liveupdate: Set up FLB handler for the PCI
 core
Message-ID: <ae_4fg_18Rli2_Nt@google.com>
References: <20260423212316.3431746-1-dmatlack@google.com>
 <20260423212316.3431746-2-dmatlack@google.com>
 <2vxzeck45yin.fsf@kernel.org>
 <aetvAkM0y45WAmfV@plex>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aetvAkM0y45WAmfV@plex>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5818280008
X-Stat-Signature: i7wwsapcd4e9qnk9dwzf1dbyb5faq4so
X-HE-Tag: 1777334405-824951
X-HE-Meta: U2FsdGVkX1++NzxV7Zp/HROCeg+kxQsuIRp+aNBwoWxomZamHvLmqLx9CvpG4HQOCMF5M2Boc9bhQfzQl7m7NjBlP8cl0nK4OKQe8Q/tU8NHjRQ/2jbOb14WVtHQPQcyF9GA4h9addXYRBuYJN3Al7hjHFYI2yNo9zn7yi1vwlT+gTo+2JznJZTPH80EL/lEKWyzGofZDr5Erst13ZdJoGQ7Nn+Xhkz07cPAKKsx2uzpAEo9h6kPmJhb8qn7OPIGWNwHnQoqQdRaQMzP0pn2CXU1w55AVkEXHe3LGeZlTwbx37QU2TCTCHNFbwtv5anukww3awwwhsuJAPZKy+OAuaUio3zT9g0utvv3SA3ChH0hFo2keLITYPDjaNrl1ojW58WtUq08cqQsPKP5C6pLzlYIbIXXkabTh/00xV20Yo9KUKGDOKuDQlpoCnyvd02p2qsxjmKB0eT4tz41OkHuHYQuBe7mU6mBDKXpENrBy/JLh8dQj7hmCSA96K1zZuRPfuQ+v7HFTcER+6vVAv+UPdNZOtJ33Xcz2P8HQsvkOOCAWzOeu+fiPGbbsQWHfaNxL/Mx4jJRVPLyF08cPThpMqw810OHEIdAowLow19uwB2AiKEdBET5t26SAfIUsRR64CfC7189lt2g6quV9BvA2pWl4Bxu4xP1BcfRpXJgFCOhdZ7FD2OxtSw1/25XtOzZ5rae3UeA4Gq5vECxbS9/zv5Q9kBE3uTQ0kLe/jVOwe9xB2WcFJPXOqSi3loDxZ1mh/igsds/vjs9mNu4w7wFmmHUAS4nn3rhO/w1ap34MFjhyK8GNUWXOp5f07xzXbm9zP7JKpxiqAzIgs00ZOdssl+czX4hT2CQHZySMHMcacX87EVpN8fYTwYl0o7npob/L/K9Bn1PnZ0YG6je1dewSrEakNzRNyThxGkxSAISHt2Ey8ZMpjWmqK+wzvQ9t/HW/mJgfB3TEhyUGTv+Aee
 KinqvQgX
 7IPI1p52a2JiR3Zk/QLfOPpT7ujk7XV0g9NP1acHuAFWn/DpX+vKec51uZhfdWy8UNNK8MLwXeP1m3eZ3gJQV0ccjA0tEVUkfLeDO3JmJoNz+qQjr0TsyRcekQ9PMHcoHERDcAZftcrf7XHoMjjxCToQ7Sy8DlDyVOcApl4wRDHdFbHX8Q8SAW1ar5Mlt8bKwJKxOAlk6szs0esrQcFl2zFeLZlOOWqVb0J9QBjgRy/Q/eblkcLYOcvG7XtrtTnQimUyGHP1cQJln7HPS6qP1gbMbqLuYXHNo4MiQRw+Oa9sl5YL3F8fTKQh/hJnd65FiSJbu7RVuPtL/Qihwuk8YgSeqn7FKwo7zQ7cPSkdstdEv58dCIO7wuVartt6ksBfHQ7hdZGLeJ0EeTdiikilsjm0aLPSi+eKsSn+mQ2O0g2loG7Y6WXFNNeXneQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-24 01:29 PM, Pasha Tatashin wrote:
> On 04-24 14:33, Pratyush Yadav wrote:
> > Hi David,
> > 
> > On Thu, Apr 23 2026, David Matlack wrote:
> > [...]
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index c9b7b6f9828e..94af31837375 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -20555,6 +20555,18 @@ L:	linux-pci@vger.kernel.org
> > >  S:	Supported
> > >  F:	Documentation/PCI/pci-error-recovery.rst
> > >  
> > > +PCI LIVE UPDATE
> > > +M:	Bjorn Helgaas <bhelgaas@google.com>
> > > +M:	David Matlack <dmatlack@google.com>
> > > +L:	linux-pci@vger.kernel.org
> > > +S:	Supported
> > > +Q:	https://patchwork.kernel.org/project/linux-pci/list/
> > > +B:	https://bugzilla.kernel.org
> > > +C:	irc://irc.oftc.net/linux-pci
> > > +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git
> > > +F:	drivers/pci/liveupdate.c
> > > +F:	include/linux/kho/abi/pci.h
> > > +
> > 
> > Can we please also add these files under the "LIVE UPDATE" entry. The
> > code here concerns both live update and PCI.

Covering that intersection of Live Update and PCI was exactly my
intention with introducing this new PCI LIVE UPDATE entry. This ensures
we have maintenance coverage with knowledge of that intersection.

> > We can figure out the
> > maintenance details as we go along, but I think the live update
> > maintainers should at least get all the patches for PCI live update.

Would adding kexec@ here be sufficient or do you want to be CC'd
directly?

If you want to be CC'd directly do you think makes more sense to add the
Live Update maintainers as Reviewers under PCI LIVE UPDATE, or add
drivers/pci/liveupdate.c under LIVE UPDATE?

> > 
> > Perhaps also add the kexec list here? We plan to use it to maintain the
> > LUO patches, and adding it will make sure we get the patches in case
> > someone updates the file list here but forgets to update it in the LIVE
> > UPDATE entry.
> 
> +1
> 
> These files should also be added to the Live Update entry, and the kexec
> mailing list should be included.
> 
> Changes specific to Live Update should be routed through the
> liveupdate/linux.git tree, while generic PCI changes should go through
> pci/pci.git. In either case, if liveupdate.c or abi/pci.h are modified,
> acks are required from the Live Update group.

Do you want to merge changes to drivers/pci/liveupdate.c through the
live update tree or PCI tree? We should probably decide now. I was
assuming the PCI tree since its part of PCI core.

As we project this out there are going to be users of the Live Update
API across different parts of the kernel: PCI core, IOMMU core, IOMMU
drivers, VFIO core, VFIO PCI drivers, and KVM. I don't think it will
scale to take all that code through the live update tree.

