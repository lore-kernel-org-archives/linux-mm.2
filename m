Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E449FF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:50:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 499C96B010B; Tue, 28 Apr 2026 19:50:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44B976B010D; Tue, 28 Apr 2026 19:50:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3392A6B010F; Tue, 28 Apr 2026 19:50:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 246E86B010B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:50:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C0C00140D08
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:47:31 +0000 (UTC)
X-FDA: 84709603902.23.F7C24F6
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf11.hostedemail.com (Postfix) with ESMTP id D9D944000E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:47:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="bHoGdu1/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777420049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EpaL2C2UFwZgckez6PzSxOJ2+MS43lyhGR+45AYtYTo=;
	b=QYDXrbMNxXvLrz8Ul5W8J0fNP6P4OPDNn2GIRBm0VPpSfInNa76HkcBbPaG1YY8ampxT1S
	w+z9jlOSV/YygOjtTBFggvG35yBmV0I+72kvonSaLkhk54pMbGYdoiz+T767ayfED+3O3v
	wZS27bFIZ7SIiZefLS1hXzQlcVGDB5Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777420049; a=rsa-sha256;
	cv=none;
	b=KIE9UbqIaPhIGTZGwKl7fs3UCqmss8Uxsy7TZ0UV+b35LmFCr8DTs7L0cU9TWCq6zNEZgX
	Vd/ev1Dr7jz1Cq/qta9gBe84oSejUz7lOVoWL3Jka5iQp56BGq4avJfRHGtd+T88bRGluI
	TuwiNTYDJwidR6tvf4jDHRZ4Hfpxnm8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="bHoGdu1/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=dmatlack@google.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-35f9ab079bdso8132458a91.2
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777420049; x=1778024849; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EpaL2C2UFwZgckez6PzSxOJ2+MS43lyhGR+45AYtYTo=;
        b=bHoGdu1/YK4Mx7m5ciIu8xtl9gra7JGdVhOwWwPVMi9+8yH49zUe0gT/aj8MD+8nws
         NxSlFkKr6NBG2/qR/CKlDUz9fFTC0EZdQ1rEaPtx61mfyQZguouQO01x4jpY1SZU2CRm
         k/Ih2Z4nNjMaNSr1kbX99RQFgrfCv85QevB8WpSk8CGK8aw9enl0I24zS1xo9RufEY5w
         5j97itks3+bY5BJhwmsUZ8oFtthv6vlqQxUnmkn1cJBoXuwMamwGsyVjPNK1Ir4bqFeh
         RGXt1a3VW/lvIWWWyAg0HL8SWUS9gM2RnWrtFLBibD5/K2obo45D9ekN0+KfQGXelZ0i
         I8ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777420049; x=1778024849;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EpaL2C2UFwZgckez6PzSxOJ2+MS43lyhGR+45AYtYTo=;
        b=UiBitIFNFYC4pRRobwpRNDD84QZu6xirn6sWOSQz/YrkbjY6o4tBLS7OktSf8VhNBE
         f1xjQwZpJhg/FItZwQN/dkKz/vd9wV8Mqs5sGFmOe0+JBEDzMlsm+VewqXkaW5gLG7h7
         fBtNvaQ+HQH8bAvXbweTIdIRiZ7CpZBaHt/hWbfuMPYVWwgp7dLIQj+wl48tNKi/7Wv8
         cBs00QvOGb7htNwrKyc4L0hckaRKFicbTqyp3pAD1Zl2vSbQhT25vzIvXP4hJF+V1zJ9
         +B+zVFHD/MEv3Cb09kLMN1c0RmO7VBO+G/RmsZ0ce1rcHYEB1taFyeAa2RRc5z2FpCfQ
         6Rwg==
X-Forwarded-Encrypted: i=1; AFNElJ//rRvmqdSHKytE4Hc2f55aFPMqxDLip+r60Qu+N1TCPlqqO0FJKYJrhftSQ5QhxdKCxbb4+d/zxA==@kvack.org
X-Gm-Message-State: AOJu0Ywoo0WSkahhXV1ef7WqgGNzonwTfzqLKhl7W3AmKwBA2n5hZt72
	DfK9fNNZfnsRZZtBC7/dUDKgNkiVq74sdQkw0bxpWpdS6CyirBMHhhtxPYDbEzhiAQ==
X-Gm-Gg: AeBDiesUuKRM6t5GFUKSUKPLqXILtrPhSmfEHd9pGY9pVRST9jjCCDvlu2ZIa3hYQ9i
	XEXzpcvvZD2FvSEzi3ujC9jEpmIa55FdhHiJWcLnK+vO6RJFrwQJLZ7MlCgvzUKHcnLBC7lBZh5
	9FwcWoMfcf1XX0TsgVAazcX/U5E0Df3xokvQCvQSA4Qkfg7MyxngRWSUU9/9ldVQ19JgqmGaLD5
	xiXmaULrSwhAgXIxBzVrc//oEXwv4pl3f+vO9gzNhUjVHn+WiLFEruF/9sdze+4GOGy39LsO8EB
	DAdAVKQIAkf02I3/OiuC4UoMIF27nyj7or04JNjgtxQzTsZbaCSofggDRSxbEUsA8AWIfA34lhv
	RvjHp+UUa8kh+KjVOVgJIBSUJFdBs3eXZTGMZPsPaX4DkB3fbkgZ6Q4YcDJgPQKessyy1thMEKJ
	0Ww+FVgT7YNTJKHuSw2+mc8/ribVTk4pP44gcL4LYyMVAdqU4geA9pyUrC1EK+bXnkUaOm6XWlU
	XdgVw==
X-Received: by 2002:a05:6a20:a120:b0:3a2:bd1d:d68c with SMTP id adf61e73a8af0-3a3af60f200mr1710132637.50.1777420047985;
        Tue, 28 Apr 2026 16:47:27 -0700 (PDT)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7fd64f09fdsm178148a12.17.2026.04.28.16.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 16:47:27 -0700 (PDT)
Date: Tue, 28 Apr 2026 23:47:23 +0000
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
Message-ID: <afFHC6C1Qbwio4pH@google.com>
References: <20260423212316.3431746-1-dmatlack@google.com>
 <20260423212316.3431746-2-dmatlack@google.com>
 <2vxzeck45yin.fsf@kernel.org>
 <aetvAkM0y45WAmfV@plex>
 <ae_4fg_18Rli2_Nt@google.com>
 <afDroRNDr9ttY4O9@plex>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afDroRNDr9ttY4O9@plex>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D9D944000E
X-Stat-Signature: zw8xa4pfcbommbk5jadog4k6hx9rekax
X-Rspam-User: 
X-HE-Tag: 1777420049-794994
X-HE-Meta: U2FsdGVkX19POGREvKtCdX/ayf2fwWSAnSI0ItmjuRf5JTOQarmYf34UtZkKK7jpOXjoSmWMlCY2KLpEOam0iAmbwZ62LQJONN6IOKLFXXp5FY4kXe2Rc0i8G2SCfVycuQd3rCYCqJMNEmzgjpO95NBEHslXmeeWjLnrg4TzTAiHYMdl3Vao6V84YzpaAooXyRUfySIaBKUSMNc2QTaHrNJ5RdvE0EwrWBYW67w9t+bYfOKv5q4X0EiEkcR1NlXP6rPy35WlHu6kDlXplbUtiFdxjejzZejMHwQYJ137eq2/vPALLLA8p1ioKL25Fuu1NqeygK8+rMOSMnwvQBv8zNSJJXzli4iIJNQYR2DM3/kpb6+0rMBSVR9pa1xlMDKCHtvOAUVUzcB9e23oX9a18plQdir9vhc0kBtDChU0HZupAZK5l9jAnaJLQi91jAd9c5ax/NlkReqwHPfRPljUfD70jdnqB2T6+ZDC4BnK3BAQTKmPLiZX/ubjTu9ThYRB1o7VH86k83KDqVSqPc5engMb6LFhZk0COQLf5HYzi0MOYsfdqRsK+f5P8Gf0CIBX9c6CO7V1ovmLZMqx7a88kkLFvM3m8d3WfOS+fqGdyWNKIRsHMMTFxifG+3O+GOhONv0872YwgvTJB00emBt22uNyTcHrh8u/KLgbrIEUbmz0mfP3aC7LnyU3KaYOkC+kyLWM8r6DI0RHv8L35qch6ozQ6uI9NI1QuhIg3BaVuQF8wwJMFktQrEhEAfwNuXVV8Sw+fKlIrQ2OTGkC8xj/e5XQxIZou5BOCtvaPt5gCjf+5G2aelh7OaZA1YjfKrDT7piLs9tPdvfE58zqyHjnyX6ftNaGIkEdVjD1dlb+oPgn0AdeajQO8ehrhIglRryzyPSlozORf3Gaz8xm4cemU8a6HMJabE0f1a2dM2YTynI1c9IqS9dw1vpbUkwSq03DGsZ6akl9gJ0aq23XX46
 yYrcZsAy
 rPBaQU3VxuZmtfOgPTL7bvUtoz8xQFZM5AQS/Yp/RlC5lljEAp1s3DJIfTiNipZ/x4vytIZ5XoEbxNJr0MkR/7O161nZksk0WUz8rpxkzY3uWeX9V5y3tgLvsnoa/zB3nf190C/21k9hhXy93e//NjiBCSJ66K5cwaIMWXsJLDtXtZf8v3vgPT3hzcC0AB2Dzr+DEDvPIwnuzE6O825dcF1Ydiz7JSVMNYrrTGUiSnj3U9zEuZ9D+u/HdTj2j180O3mqw0MflOLUvu1ET0ngvsM5zc1KyweHpiQXtOXzP1Ijvx3aTrDnCTHRlaon7pAiNLbJov2FhLFaAvVV+eZmqaxNvW6eQZU27lr6yxs5002hGntzBdYyl23eEX/6vrjDalZ5HesJRkFYMcI97Pjwuw7++UjqeZZUIAP1w0iZfW1f5PzyuhWNncWGecwyPu2BaJYX2zJgp9mx/mwG5yRvAQ+HX0ZwEgW2B8MZHA+Vu4Y8BsqkUih8Mslbl2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-28 05:50 PM, Pasha Tatashin wrote:
> On 04-27 23:59, David Matlack wrote:
> > On 2026-04-24 01:29 PM, Pasha Tatashin wrote:
> > > On 04-24 14:33, Pratyush Yadav wrote:
> > > > Hi David,
> > > > 
> > > > On Thu, Apr 23 2026, David Matlack wrote:
> > > > [...]
> > > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > > > index c9b7b6f9828e..94af31837375 100644
> > > > > --- a/MAINTAINERS
> > > > > +++ b/MAINTAINERS
> > > > > @@ -20555,6 +20555,18 @@ L:	linux-pci@vger.kernel.org
> > > > >  S:	Supported
> > > > >  F:	Documentation/PCI/pci-error-recovery.rst
> > > > >  
> > > > > +PCI LIVE UPDATE
> > > > > +M:	Bjorn Helgaas <bhelgaas@google.com>
> > > > > +M:	David Matlack <dmatlack@google.com>
> > > > > +L:	linux-pci@vger.kernel.org
> > > > > +S:	Supported
> > > > > +Q:	https://patchwork.kernel.org/project/linux-pci/list/
> > > > > +B:	https://bugzilla.kernel.org
> > > > > +C:	irc://irc.oftc.net/linux-pci
> > > > > +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git
> > > > > +F:	drivers/pci/liveupdate.c
> > > > > +F:	include/linux/kho/abi/pci.h
> > > > > +
> > > > 
> > > > Can we please also add these files under the "LIVE UPDATE" entry. The
> > > > code here concerns both live update and PCI.
> > 
> > Covering that intersection of Live Update and PCI was exactly my
> > intention with introducing this new PCI LIVE UPDATE entry. This ensures
> > we have maintenance coverage with knowledge of that intersection.
> > 
> > > > We can figure out the
> > > > maintenance details as we go along, but I think the live update
> > > > maintainers should at least get all the patches for PCI live update.
> > 
> > Would adding kexec@ here be sufficient or do you want to be CC'd
> > directly?
> > 
> > If you want to be CC'd directly do you think makes more sense to add the
> > Live Update maintainers as Reviewers under PCI LIVE UPDATE, or add
> > drivers/pci/liveupdate.c under LIVE UPDATE?
> > 
> > > > 
> > > > Perhaps also add the kexec list here? We plan to use it to maintain the
> > > > LUO patches, and adding it will make sure we get the patches in case
> > > > someone updates the file list here but forgets to update it in the LIVE
> > > > UPDATE entry.
> > > 
> > > +1
> > > 
> > > These files should also be added to the Live Update entry, and the kexec
> > > mailing list should be included.
> > > 
> > > Changes specific to Live Update should be routed through the
> > > liveupdate/linux.git tree, while generic PCI changes should go through
> > > pci/pci.git. In either case, if liveupdate.c or abi/pci.h are modified,
> > > acks are required from the Live Update group.
> > 
> > Do you want to merge changes to drivers/pci/liveupdate.c through the
> > live update tree or PCI tree? We should probably decide now. I was
> > assuming the PCI tree since its part of PCI core.
> > 
> > As we project this out there are going to be users of the Live Update
> > API across different parts of the kernel: PCI core, IOMMU core, IOMMU
> > drivers, VFIO core, VFIO PCI drivers, and KVM. I don't think it will
> > scale to take all that code through the live update tree.
> 
> All Live-Update-specific changes should go through the liveupdate tree. 
> The liveupdate tree is the only Linux tree that will cover full Live 
> Update regression testing, and it contains reviewers and maintainers who 
> know the details of the Live Update process, its lifecycle, and its 
> requirements.
> 
> The request we are hearing from other subsystem maintainers is that they 
> want to make sure Live Update is isolated enough not to make their lives 
> harder. This means reducing the number of conflicts, the maintenance 
> burden, and testing responsibilities.
> 
> Therefore, the "PCI LIVE UPDATE" entry should specify you as a 
> maintainer, "kexec@lists.infradead.org" as the list to which all LU 
> changes should be CC'd, and "liveupdate/linux.git" as the git tree 
> against which changes should be applied.
> 
> It should also include "linux-pci@vger.kernel.org" so the PCI 
> maintainers are CC'd. In case there are larger changes that touch core 
> PCI and liveupdate.c/abi, we can ACK them, ensuring we are aware of 
> incoming conflicts during the current or next merge cycle.
> 
> It should also specify the members of LU group so we can stage the 
> changes.

Sorry what does this mean specifically?

> This is the way we agreed to handle kexec changes: Baoquan He is the 
> maintainer, and without his Reviewed-by tag, we won't take changes to 
> kexec. This is the approach we follow with MM for KHO changes to 
> memblock and memfd preservation, as well as the upcoming 
> hugetlb/guestmemfd preservation. 
> 
> This is also the approach we should continue using when adding LUO 
> support to other components like PCI, VFIO, IOMMU, and KVM. It keeps 
> life easier for the core component maintainers and ensures we do not 
> regress LU by staging everything in the same tree and sending LU merge 
> requests from a single tree.

Ok it sounds like we are aligned on keeping drivers/pci/liveupdate.c,
include/linux/kho/abi/pci.h, and Documentation/PCI/liveupdate.rst in the
PCI LIVE UPDATE entry and not duplicating them in the LIVE UPDATE entry.

I think the only open question is what tree to use for the PCI LIVE
UPDATE entry, PCI tree or Live Update tree. You are proposing the Live
Update tree.

Bjorn are you ok with that approach?

