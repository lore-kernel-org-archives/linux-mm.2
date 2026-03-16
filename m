Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45623F53D6C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 21:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89D936B03AB; Mon, 16 Mar 2026 17:49:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84B696B03AC; Mon, 16 Mar 2026 17:49:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F83D6B03AD; Mon, 16 Mar 2026 17:49:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D7D46B03AB
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:49:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F38C513B619
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:49:42 +0000 (UTC)
X-FDA: 84553268604.06.43E73CB
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id EF93D20002
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:49:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NrVr+lb3;
	spf=pass (imf03.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773697781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/8z1/dIhYqxHzj3/umwHNkEcO1PtVcvAJP18LcAQq1Y=;
	b=PHbq2QW+BR/XgeUqgd+xRtzVkDpH07HwB4FjRZ+DvT4P8IVdfcj5IuO5uGwxckhFq217wM
	xhLLJL0267HECwbBt6CGAVv5AGFHrl6AUmLn8UtStJojOhffqj2pJOa5ZG9Uni+fBmOkwQ
	lt7iSCOzgV6noAbaAwkNfbSk4geF9PI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NrVr+lb3;
	spf=pass (imf03.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773697781; a=rsa-sha256;
	cv=none;
	b=ttU6VCJnOO3zTucuswpDvbWaWuOzN3Vv3+IUIuW+4oJxZrVl/tvzwtaxk2UwQXhOVKsXgt
	jea+TeE8nbBqJs4C3wQxhjbuKmw04Y/KXd++WstJByvIkduNu5GVCNA2i/oXO6EoLNcwna
	PGjX2NOsyU/3Xx9MaElYer/XJ5D0nG0=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2b04c9e3eb7so28105ad.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773697780; x=1774302580; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/8z1/dIhYqxHzj3/umwHNkEcO1PtVcvAJP18LcAQq1Y=;
        b=NrVr+lb3oS2pW6K4hmQXXj/l4jmOQW81c0pdPV5PVxoy7mBsqoy+IyNDSqm/xefvdN
         /CPH4QSMl0z6Cl6ngXBcL7MHMgCshdGRwxFbePyY8GUsc1eS2fEsvb8D0slR9n8ubwA4
         KfLKpkVpECfe/DaS05GqbBOgXHxojpHsWXeLDLTCslp+3/ldt9wcgToiddusukgPrJoA
         U3xNLpLG3Mv7ONSrBq56F58AOzaYHpO2tAxFtW4PG/ez666gllJiSrkWOqNOr93or4RM
         tfaq+UJA2glMNqi6h/9sU18xjUQdh9S9GY1kIm4uTKjVVmjHtRb5a/9kEWhS3oD3hQna
         B0/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773697780; x=1774302580;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/8z1/dIhYqxHzj3/umwHNkEcO1PtVcvAJP18LcAQq1Y=;
        b=KtKjiHQ3xFU/nqVX/FrV+y0EL7802dWvS+FLVeNAW5/r40VgRrh6X2sd/5Ya1YUEuf
         NVbUIuqBUOOIY6Lws2we9r/M9vyUPfvLSS5io3tfxWT/QgSJiR46x9es2FmIeRaPYeV0
         0cxyvE3d1zAccbkO3UAwLSBZVe0ovSGooj+d/24tmpEnGuhekecyvUFAcTubGON+TpIp
         slSz4hzirRLWAImQ5IuihO4RO07ssyXvvC1mGC0tAc9Rl25uiN+JaAKBwYOqI0dtKXSL
         gvsYgb7Bt+hLXRFmfvvyJqS2T4TEr2Cb1iz8lc2eX5krRdZAP3FEFJGz1zuHG02Kimj8
         8mUw==
X-Forwarded-Encrypted: i=1; AJvYcCWY+5emRJH9CnsQCMVvJTB1bTvmoTufqmKJVYDfxM1STS1LCy3qLQY3bVNT7UGE/Qsgc8AVxzXv7w==@kvack.org
X-Gm-Message-State: AOJu0YxSGV/2nFlfJIeud9qZe+mhupMW2FXCl8tOQv+4vacyG3M1umnX
	LlymMk788ibl8rGx5yemhoNwrhLNAhyZi63A4vUWm+lp3g/AQ1fyOix/INwNxL/cIg==
X-Gm-Gg: ATEYQzzONexbtsoaHa5u0vRDl24j5Q2VLgZw70ORC1IDl2KOCOAt+lSYFZa4bTXFYm9
	ZPaRuNbDNiSzavY0eNkAx+2xnX//2gDaYxm3b8jP9SXOKwEPYWxaIv5p6E5wASXvMNuh4CX03Ls
	C/rXt4RJ2mVXRG26mIB/gL9rz9nh/zMmn/8pUMo3k+0EB54tEEP0CXGF+lXUYNU/wC9zy2mNEyx
	VCNr5Qu1YqO9vL5kwj6qOilocrGTcpeegY/Tk1pypgldawQRyiyayoiaB7lN+iEBdMY5rtcNQGl
	IwbxOOZm5bOQ6qJLSlpWTLSWnUiJBdejTrSXJziFZchS3svoTVt0WOuFEt/J7m0DYRQMtY+YxWu
	KgDsNaCfRImea/xTM2ZilCroD3rhJSF2CMXD7J0sCJ8F9s8ljdSV601DExplwk2KECeZiajiIqr
	6qnWRxU6+e0UKh3J0BtMLaSCBESCJX51/+99fclxh0G6apqqpDfT2M2UdHsBN3
X-Received: by 2002:a17:903:98b:b0:2a8:ffed:4663 with SMTP id d9443c01a7336-2b06402f49emr1238925ad.12.1773697779367;
        Mon, 16 Mar 2026 14:49:39 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a07365b22sm14359627b3a.45.2026.03.16.14.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 14:49:38 -0700 (PDT)
Date: Mon, 16 Mar 2026 14:49:34 -0700
From: Vipin Sharma <vipinsh@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 10/22] vfio/pci: Skip reset of preserved device after
 Live Update
Message-ID: <20260316214055.GB1846904.vipinsh@google.com>
References: <20260129212510.967611-11-dmatlack@google.com>
 <20260226170030.5a938c74@shazbot.org>
 <aaDqhjdLyf1qSTSh@google.com>
 <20260227084658.3767d801@shazbot.org>
 <CALzav=fHy23RAzhgkdaL+JA5T2tL9FT6aPgRfXUh7i9zvYCGPA@mail.gmail.com>
 <20260227105720.522ca97f@shazbot.org>
 <CALzav=fjRPa_ZbXu7iFXyemcf_8Kq_dZTWT6c-A0bc6czF_Rdw@mail.gmail.com>
 <abNOwcOTXqxCxNzt@google.com>
 <20260316160759.GA1767448.vipinsh@google.com>
 <CALzav=cskxLZtZ5-uRa0+aV+1Kb3fwQQJ5dS=Yes4GAHrS6GpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=cskxLZtZ5-uRa0+aV+1Kb3fwQQJ5dS=Yes4GAHrS6GpQ@mail.gmail.com>
X-Rspamd-Queue-Id: EF93D20002
X-Stat-Signature: gpwjf7xifcfq1brr7ag1g3kzdecfzgmj
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773697780-864425
X-HE-Meta: U2FsdGVkX19lLG8GnG+bLDreW7MEKHDR5nHKEPAKsqFUl0XZilqSuosO0SroXN9epAq0lLflU7U1pHLlEvFx39LjFBqhWwdunjLu4hO9ykNW8A/S9gRCaNOGOJ0Fcfvg8rJLAoko7xaX4TOrQo1PhkT1xLQT91e3Z2Eafkif1jZohUprSrcfauNtKCSEW+VJLchJHw/ya97DfBLViKACRjnWQNrLl/16DynIFFr1UZLv/M2hTJJCy7URRmBFF5vPyx2A+KbuQcdyL6Ld9/hG9VJLdNJbVL1lf4kOPH1LFO/INAxkM/HNm5M3hlXVbIG0K7tx8P+y/L0Fry+DSxc6scf6ivppQKWd1ZDx7E8139krojtHobrxi8/hq/lg2Be/PwRitMV7ovNZBnL2kQSR0Ji31PUUFLxGp+FdRzViXvN4Inr8TDQ111CdQvfJXhi6gb2G5PHdyMy1yv+e6kIk1G/pmbhFN+RPJ7SO3P60XK4jaVq4aMuhPkkMdakVg+DHf8NjYrvdiTaxwIHNHdjTRLQixiy8ksCrEdiQ/TozvwiNCVSTyTejsGAKe+g6J1jWLHAz9xvkniekDEVyMsngroKMPKLLG/j/9C4v1oQ/XtXRMKUYvsWtt57KAaG4XFdRU8BK92eYP2NzhUT5knWmsOPyk/CX9vEdw0Af1rMTcD/cLJ8ZxFLw/8Bu1E2uxSd9G0YkxHW38scmMNKm0qqFpyBYoNOqCZXieG3bBsu+Q+U7pgjY73b586jVxeOlz8+k7kU9n1fOXFeVJge3l0DrxLOu+FKTlN7TcFLXC3mJUpgeEAZ1h2MNLaeQ1GIWm91wi2/HUsFgjt9afyFYZY7Gd+ck8vj7lh1sKdQ/r3VilzFZn9g4UJlY25Jd8uMI1WujGY2Xh8WqRO2uqpIlk53uXGPHRIUg7C8/xoGB99LweZGvWRd/z1IHEpc1kZfMdVHh7u9qTQMKvHiQ7pQkHl8
 hczTMN6X
 rDlnidcENt3wIdCOlKW6Hni+I1KdMtNwcw5KpMzxVLchkTikoMtVgOjAMrWhKApQ+ssFb8Lo7BZRIGDIw1HOUv0FAidusEykiYRjfTFCro9xDQzdlmeEBBFNCtutUCeUG3m7CArZ+/Gam+lJcoAgR1S7kkpf9LuKQYj9hphhfzoxcHSRFTrRvTH0x+BaJ8u1KkeIqLo6g6Wmr+H9W/UX3rmnWjXU1Lz0uFcqYg+bDPTPehjTERy9NXfjiP6W93Zk/xbiiO/vsDFN0po+WntZHkYjFHOZZ0Mwpx82XLMld+igpSHtj7NVhOD/YivmCNpux80qZ6J2d1K6FWg1ywTNr8Aqtkm0zXsBDqhBd8+7tm/dnBrdwk7lGdxVi3gHErCgYZaSQrE9/W558yCEZZf2Hm8CBPDhE786aYJMT/2sWy7+U0YLw0iI/QwH6uA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 10:18:22AM -0700, David Matlack wrote:
> On Mon, Mar 16, 2026 at 9:22 AM Vipin Sharma <vipinsh@google.com> wrote:
> >
> > On Thu, Mar 12, 2026 at 11:39:45PM +0000, David Matlack wrote:
> > > On 2026-03-09 10:32 AM, David Matlack wrote:
> > > > On Fri, Feb 27, 2026 at 9:57 AM Alex Williamson <alex@shazbot.org> wrote:
> > >
> > > > > Sorry if I don't have the whole model in my head yet, but is exposing
> > > > > the restriction to the vfio user of the device sufficient to manage the
> > > > > liveupdate orchestration?  For example, a VFIO_DEVICE_INFO_CAP pushes
> > > > > the knowledge to QEMU... what does QEMU do with that knowledge?  Who
> > > > > imposes the policy decision to decide what support is sufficient?
> > > >
> > > > Hm.. good questions. I don't think we want userspace inspecting bits
> > > > exposed by the kernel and trying to infer exactly what's being
> > > > preserved and whether it's "good enough" to use. And such a UAPI would
> > > > become tech debt once we finish development, I suspect.
> > > >
> > > > A better approach would be to hide this support from userspace until
> > > > we decide it is ready for production use-cases.
> > > >
> > > > To enable development and testing, we can add an opt-in mechanism
> > >
> > > Here is what I am trending towards sending in v3 as the opt-in mechanism:
> > >
> > > diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> > > index 1e82b44bda1a..770231554221 100644
> > > --- a/drivers/vfio/pci/Kconfig
> > > +++ b/drivers/vfio/pci/Kconfig
> > > @@ -58,6 +58,27 @@ config VFIO_PCI_ZDEV_KVM
> > >  config VFIO_PCI_DMABUF
> > >         def_bool y if VFIO_PCI_CORE && PCI_P2PDMA && DMA_SHARED_BUFFER
> > >
> > > +config VFIO_PCI_LIVEUPDATE
> > > +       bool "VFIO PCI support for Live Update (EXPERIMENTAL)"
> > > +       depends on LIVEUPDATE && VFIO_PCI
> > > +       help
> > > +         Support for preserving devices bound to vfio-pci across a Live
> > > +         Update. The eventual goal is that preserved devices can run
> > > +         uninterrupted during a Live Update, including DMA to preserved
> > > +         memory buffers and P2P. However there are many steps still needed to
> > > +         achieve this, including:
> > > +
> > > +          - Preservation of iommufd files
> > > +          - Preservation of IOMMU driver state
> > > +          - Preservation of PCI state (BAR resources, device state, ...)
> > > +          - Preservation of vfio-pci driver state
> > > +
> > > +         This option should only be enabled by developers working on
> > > +         implementing this support. Once enough support has landed in the
> > > +         kernel, this option will no longer be marked EXPERIMENTAL.
> > > +
> > > +         If you don't know what to do here, say N.
> > > +
> >
> > To use VFIO liveupdate, user has to do at least two things:
> > 1. Enable CONFIG_LIVEUPDATE
> > 2. Pass VFIO FD to a live update session.
> >
> > This means someone using it has to know what live update is and
> > intentionally pass the VFIO FDs. Isn't act of doing this itself an
> > opt-in mechanism?
> 
> If it is, then I can leave this out. Alex?
> 
> My thinking was: Distros are free to enable LIVEUPDATE and use it. The
> support it enables today is all fully functional (albeit new).
> vfio-cdev, OTOH, is not. A separate Kconfig can help express that
> difference.
> 
> Consider that LIVEUPDATE could be enabled by default in a future
> release, but vfio-cdev support might not be ready yet at that point.

But that also requires point 2 above i.e. userspace explicitly passing
VFIO FD to liveupdate. Unless there is a capability mechanism like KVM
then userspace cannot know what is exactly supported. Also, users who
are using these APIs will already be advanced users and have to know
many details about what liveupdate supports or not.

> 
> > I am not sure providing VFIO_PCI_LIVEUPDATE alleviate Alex's concern
> > about how userspace will know that sufficient VFIO support exists.
> 
> I was thinking we can flip VFIO_PCI_LIVEUPDATE to be enabled by
> default (if LIVEUPDATE and VFIO_PCI are enabled), and drop
> "(EXPERIMENTAL)" from the option title. That would be how distros and
> downstream users of the kernel know that sufficient support exists to
> enable VFIO_PCI_LIVEUPDATE.
> 
> > May be write in liveupdate documentation (PATCH 11 of this series) that
> > support is experimental?
> 
> The documentation in patch 11 includes largely the same text that I
> put under VFIO_PCI_LIVEU"PDATE. But I can explicitly mention
> "experimental" as well if that's what you're asking.

Yeah, even though documentation do get stale but I think there is no
better way in this scenario.


