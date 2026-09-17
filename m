Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF8F1C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 23:34:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C90D46B008C; Thu, 17 Sep 2026 19:34:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1BB46B0093; Thu, 17 Sep 2026 19:34:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE2746B0095; Thu, 17 Sep 2026 19:34:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 81E696B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:34:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D3DF71A04B0
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:34:04 +0000 (UTC)
X-FDA: 85224859608.13.C897955
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0F35720003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:34:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=G5OLZ8Gt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=G5OLZ8Gt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789688043;
	b=poDihXIq7oBE6ScgH+u3/Iv3wFT9wB9hgieQbpe7krfzUdH3nR8HIPN1ngmYRkr5RjKjVC
	s2GYFfMg/ADCUm9WZypKYkt0syDcdmZ7+ySEUz0A/WsKXkOQ40pY3+FupgmoVr+UDlIHCf
	DQ/gZcccnp3JH/vUaS0KzOFssW1n/XE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789688043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RQOshW1Wlhutz0RqxDn5T1g0vEprp2QiXpRdTBiiFYc=;
	b=EJg86kmB+410JCU4Hma9a4PTI0v9FAAQS9wnmMuDPzLmNQdMrLIY89w6kZJrebOWBqgZ3t
	l9LVlndsHp0f0zH+tklg+8tEfVC+Hvlk3yN1TeqxD86FN9GIMM5CdOG4758WwQ1+zYR9Em
	EI00O5MW7UDxzoCEfdMCeJp0PiTDwsU=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2dd1dcdcf95so706045ad.1
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789688042; x=1790292842; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RQOshW1Wlhutz0RqxDn5T1g0vEprp2QiXpRdTBiiFYc=;
        b=G5OLZ8GtBMckNprblefpuJgr2rDc6hmiqqEAZh83OOltEVa0yBkvt4x6DmIn9jVmms
         fyQpTalJpmAFr9D2oh9PGdcgQs9EF88REYJiZdj1xnckm7Yj6c7WHFEINjmF/bnr65Zi
         XWLJJ2z5UxxzlS6UmERyZFxwiyiLMkG7TxjUN0hNqffkmc0b2CbGkpG45G2aDWNgnXUl
         obUcURsNMU1S42OL3NSGMqt5VZfn8ou6OobJyn4uSzg2m14Zx75VmFVJv6frwoFdxHqc
         cWmGMtJERNC7DxaftfQGZg8FWwmMNNvrEJpILfNACC5ce4CFpZPILCUX6kOGJCp9apHy
         jAzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789688042; x=1790292842;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RQOshW1Wlhutz0RqxDn5T1g0vEprp2QiXpRdTBiiFYc=;
        b=jyYzXupsBM6WtNUXJR7OY2dWTTRXTabyPKUvv+3sKB2X/BeCwPmZgK6Es/O9hfQ8no
         JHTrN5ExETBe75lS53DmnTLWp5lXKfqf0XkrWlwLuNvpXrR+q44/vJuL49z6NErnuusB
         jTl96EXLvXtij+s+l46S4m+KvjRRSvVT8NWyrw+/uZh4srhitGbHtuWop5MuT2BqMY4q
         LMMG3wQSe+gkeaKJe4oAOEBhHkQQh46uy+yq5+MttI+Uj3aO8shb+m5m3YsBCnI9zzni
         LMEIxHm1MOuoIRC0C9h0dXAC0Vucdx8QVL7GcZFYjLREq1EhpanVrZsNeQKmPbj39LM2
         q+iA==
X-Forwarded-Encrypted: i=1; AKwUvBwvxPnMemjM5lq/dtAbP8SAfBI2P/ZSO1F3qnls8dhYpXWFYUGcpRguHly4+vaCsE9on8xVIS9Uqw==@kvack.org
X-Gm-Message-State: AFuF++nGssUhcLTGCCJV4+uw3tBRmtnDBGk4dPVYtGe3X2X7cQgciHgW
	A/2E3gwDfETEWabUzUTGwsliaK/ffNF3xVe51uas/IbuIDsU/6lwI6gdcBSGnrl4ew==
X-Gm-Gg: AYBFou3tzyoy3/q9/UQ9plhpP5zj2FmSGPfN2/00L/Dqdn0SgSyOOIFsVuHfAbCdfL9
	0/1D/fyjiAA0f+fSp0GO6kSBxvgnevUVvu10pT0LG6wgfgWAwb8atLlMlYpFh3brjfsZrpqNxAP
	4yX+riumRmxhanLwZs4fxwJ7nkFUMHxauJWqWp4ntVD49FvOJXHGkHtSBmJVBKDfXudea/T/h28
	W9cLQugrSgZk5nHn6V41vfFiv2pSVrBXrqT7WDHNesQB3xO8rJ/y73gYrb4dDhJHx0E3F3H0yzq
	vt/I7kZB5l41Yqkw7dHjQRmXcDZoGOVbGXGjwWMF5Qsw0P+DDzsy4S7+LnbcOo23qmoWbMOVCaZ
	cja88X6hy+fTJwJJtqfQHW7L27fxx5/50bItjbJq9/YlVQ72SGMJ3LbsTqZ00VBCbiTfRyrJzc0
	LtjivtedE+C8i6pIN2Ss6Xt1pqzw/rIfz7JfBZD8SvBgaTf3i5iHxCP5JxPrNRVdGpGDeGZVvW9
	QG1nuWJr4RQt1iSO4noqErPWEU2B2PUqODji03z1Kc2Gj8cs+Q=
X-Received: by 2002:a17:902:c410:b0:2dd:b442:ea48 with SMTP id d9443c01a7336-2ddb442ee33mr2803545ad.19.1789688041146;
        Thu, 17 Sep 2026 16:34:01 -0700 (PDT)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd9e79bb2dsm16491025ad.25.2026.09.17.16.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 16:34:00 -0700 (PDT)
Date: Thu, 17 Sep 2026 23:33:56 +0000
From: David Matlack <dmatlack@google.com>
To: Bjorn Helgaas <helgaas@kernel.org>
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
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v8 12/12] Documentation: PCI: Add documentation for Live
 Update
Message-ID: <aqx45FqmkRps0wCF@google.com>
References: <20260728221007.2098560-13-dmatlack@google.com>
 <20260917213912.GA1049556@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917213912.GA1049556@bhelgaas>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0F35720003
X-Stat-Signature: y857d1h1xg76hns4a511jf6ohiwiqt35
X-Rspamd-Server: rspam01
X-HE-Tag: 1789688042-830852
X-HE-Meta: U2FsdGVkX18muQFo1zs/d4wDxmSkvyWAA5NeOFDHzdU+NE4FrLub+xhriwiAwDxoRmbDif3owRWll9rm99uVV4eVkmTiW9TOq8AHZYmoN5qyZ9fXyEAE4QAMMvKw4NJc+0JUDUCIKNE+Qwc3vD/wV289FQH/XqB3k2y0tKYTZWKeoaXgEta+mFhCc5+bBLEGRlyJNz5ceDvHG9kkVTYuDAXthc1NoXWEe3OTsJrQ9nQEsJTw8kpksCfQfbsT2m96rmOnuliFSfc98hSoHSIGybFxLphcilAXDOh6xu4I0vp6jRD9tHRnIrYteSMDz10KvFA6YKxcipeLVa2SDiW0MSP4PTPRqGW1u2cxy71Dg/Moig2/wj22m/D20eNOfEYKImq8QNLk9NpY0OMYIzVrBooDr40/NJwk71XIojZsOyMqyriUC8MmT2qgDLmsNxk//0pZbeTJTKAf71knABnrQwRAxyQiAPPCGfIIA1MuG1AIIoB3Jv+bhqEw9B4Hdn87taH/3lLaL558Sn9izD46Nt8DQbIznmFuS1KLRbox1wI/yV3q5DfG4ay6N+fheY6rWXVWurGyfMdehHJAu/GdeH5KKZF4Y5YgZGrRt9UpKDt0QwSVnUcsNkvO7zj7rFEF7IfXBeOn7FXG2Oq8vmJJ8QpjwtB31tQpIHlo8DCY27eXpf6PJoxTcRtp5RmPsT7omgSQrJsKU6pGMC7jDiXFyWuZahd8GNjXl2bDKss5RQ9NuaM7qm64ZcjTen97JfuQKQEp/QzLMUzIfvfzyRc5L7vN0uC2UH5mG/523J/q9wZKVYA7zj58KYeo4PnpxPI/Y7igQSulLTSlbfGTrc0ubYICPFXSBUSfuPKLXYQDRjlHs8YOnBWqjNt/KT+sMLd+CHzhJNTzocLv4tUm4BY19jrauF0y15Fl3CpqhsJ02ZRK5LUpBlT+WrqzFbznJBYN/CUKOTkx5QbsHTFNm2N
 Hd3+jDpR
 hn5gNnXz2bmNqjr2zhPk93RAyaZcKutWQkU18gT6Cru7WsuxhjUBNOBXAG3+AxBl3J0aFCpsHBc32YZe1Cv7k0L8aooeaRUgmv11Mg78wAOPfnE4kosiKWIz5ewaC9nKChP6Jh7hHw4GnXu3rvWLqJDdW6dzOu/FABcjeV2k9nSmKbKTbqnnAOVPKI17Bdx2UI39kYIU27g23Clk9X3flH1JhDQBWiYz75WUOVKJ7pINAHFYd1iUjz6EZsFMNSmz3CmWOMdRT3BsDVOJhF1N4Kt+igfDPJYeZPmCmlWUayJAEGTmprUQKIk3MDKs8phrh+r5T1mJuu1ChQCPfGAZvoc1RnGpIPArbRjWrJBWNiHpK1T92FRXiaqzDS25Aq2qGzgHcMe1IuA3wdo6f9bRPF5S64J4atORJVTSS4kPKxgWtW6piya88gG/7cA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-17 04:39 PM, Bjorn Helgaas wrote:
> On Tue, Jul 28, 2026 at 10:10:06PM +0000, David Matlack wrote:
> > Add documentation files for the PCI subsystem's participation in Live
> > Update.
> > 
> > These documentation files are generated from the kernel-doc comments
> > in the PCI Live Update source code. They describe the File-Lifecycle
> > Bound (FLB) API, the device tracking API, and the specific policies
> 
> Most uses fully hyphenate this: "File-Lifecycle-Bound" data, object,
> etc.

Ack, will fix.

> 
> > applied to preserved devices (such as bus number inheritance and bus
> > mastering preservation).
> > 
> > Reviewed-by: Pranjal Shrivastava <praan@google.com>
> > Signed-off-by: David Matlack <dmatlack@google.com>
> 
> Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> > ---
> >  Documentation/PCI/index.rst           |  1 +
> >  Documentation/PCI/liveupdate.rst      | 35 +++++++++++++++++++++++++++
> >  Documentation/core-api/liveupdate.rst |  1 +
> >  MAINTAINERS                           |  1 +
> >  4 files changed, 38 insertions(+)
> >  create mode 100644 Documentation/PCI/liveupdate.rst
> > 
> > diff --git a/Documentation/PCI/index.rst b/Documentation/PCI/index.rst
> > index 5d720d2a415e..23fb737ac969 100644
> > --- a/Documentation/PCI/index.rst
> > +++ b/Documentation/PCI/index.rst
> > @@ -20,3 +20,4 @@ PCI Bus Subsystem
> >     controller/index
> >     boot-interrupts
> >     tph
> > +   liveupdate
> > diff --git a/Documentation/PCI/liveupdate.rst b/Documentation/PCI/liveupdate.rst
> > new file mode 100644
> > index 000000000000..96b1d7f5df3a
> > --- /dev/null
> > +++ b/Documentation/PCI/liveupdate.rst
> > @@ -0,0 +1,35 @@
> > +.. SPDX-License-Identifier: GPL-2.0-or-later
> > +
> > +===========================
> > +PCI Support for Live Update
> > +===========================
> > +
> > +.. kernel-doc:: drivers/pci/liveupdate.c
> > +   :doc: PCI Live Update
> > +
> > +Driver API
> > +==========
> > +
> > +.. kernel-doc:: drivers/pci/liveupdate.c
> > +   :export:
> > +
> > +Internal API
> > +============
> > +
> > +.. kernel-doc:: drivers/pci/liveupdate.c
> > +   :internal:
> > +
> > +Live Update ABI
> > +===============
> > +
> > +.. kernel-doc:: include/linux/kho/abi/pci.h
> > +   :doc: PCI File-Lifecycle Bound (FLB) Live Update ABI
> 
> Ditto (and in include/linux/kho/abi/pci.h itself).
> 
> Trying to understand the FLB concept, I found
> kernel/liveupdate/luo_flb.c.  I know that's already merged so this
> isn't really the place to ask about it.  But FWIW here are some
> questions from this naive reader:
> 
>    File-Lifecycle-Bound (FLB) objects provide a mechanism for managing
>    global state that is shared across multiple live-updatable files.
>    The lifecycle of this shared state is tied to the preservation of
>    the files that depend on it.
> 
> I understand "global state", but I don't know whether "global" is
> relevant here.
> 
> I don't know what "shared across live-updatable files" means.  Is the
> sharing a fundamental aspect or just a typical use case reflecting the
> level the data is for (e.g., bus vs device)?

LUO is fundamentally a system for preserving files across a kexec. FLB
solves 2 related but independent problems that arise when trying to
preserve files:

 1. For certain types of files, there is some data that needs to be
 preserved that is not necessarily tied to one specific file. Instead it
 is shared across multiple files. FLB gives you a way to allocate and
 preserve such shared data. The association between FLB and file
 handlers tells LUO which types of files require which FLBs to be
 allocated.

 2. For certain types of files, the next kernel needs information about
 preserved state before userspace has come up and is ready to restore
 the preserved files. FLB solves this by existing separate from the
 preserved files and thus can be fetched during early boot.

For the PCI core we use FLB to solve both these problems.

 1. The files userspace is preserving are VFIO device files that
 correspond with endpoint PCI devices. Bridges can be shared across
 multiple endpoints so the PCI FLB gives us a way to track those
 independent of the VFIO endpoint state that is inside the file.

 2. The PCI core needs to know during enumeration which devices were
 preserved by the previous kernel so that it can set up those devices
 differently, e.g., adopt ACS controls instead of programming new ones.
 The PCI FLB contains the full list of preserved devices, making this
 possible.

> I'm imagining a *kernel* being "live-updated", i.e., a kernel being
> updated while things around it (devices, some user-space things) stay
> alive, so I guess "live-updatable files" would be preserved across a
> kexec?  I don't think of devices as being "live-updated" since they
> themselves aren't being updated; in fact, the whole point is that they
> *aren't* updated.

Yeah I think live-updatable is not an accurate way to describe these
files. I would say "preserved files" instead.

> Do these FLB objects appear in a filesystem?  Or are they merely blobs
> of data that are preserved across kexec?  I suppose there must be a
> mechanism for the new kernel to identify and request one of the
> several FLB objects saved by the pre-kexec kernel?

They are not exposed anywhere in the filesystem. They are blobs of data
(e.g. struct pci_ser) that the kernel hands off to the next kernel
across the kexec. To request a specific incoming FLB (i.e., FLB passed
by the previous kernel) liveupdate_flb_get_incoming(). Strings are used
to uniquely identify an FLB. PCI_LUO_FLB_COMPATIBLE ("pci") is the
string used for the PCI core's FLB.

> What does "lifecycle is tied to preservation of files" mean?  I
> expected to learn about the beginning and end of the object lifetime.

Specifically it means:

 - Just before the first file goes through liveupdate_file_ops::preserve(),
   the outgoing FLB is allocated (liveupdate_flb_ops::preserve()).

 - Just after the last file goes through liveupdate_file_ops::unpreserve(),
   the outgoing FLB is freed (liveupdate_flb_ops::unpreserve()).

 - Just after the last file goes through liveupdate_file_ops::finish(),
   the incoming FLB is freed (liveupdate_flb_ops::finish()).

>    An FLB represents a global resource, such as the IOMMU core state,
>    that is required by multiple file descriptors (e.g., all VFIO fds).
> 
> I have the impression that the important thing about FLB is the
> lifetime of some data, e.g., something that lasts longer than the
> kernel that produced it.

I think that is fair way to think about it.

>    The preservation of the FLB's state is triggered when the *first*
>    file depending on it is preserved. The cleanup of this state
>    (unpreserve or finish) is triggered when the *last* file depending
>    on it is unpreserved or finished.
> 
> Maybe this means .unpreserve() (in pre-kexec kernel) or .finish() (in
> new post-kexec kernel) is the end of an FLB object lifetime?

Hopefully my comment about explains this more clearly.

> > +.. kernel-doc:: include/linux/kho/abi/pci.h
> > +   :internal:
> > +
> > +See Also
> > +========
> > +
> > + * :doc:`/core-api/liveupdate`
> > + * :doc:`/core-api/kho/index`
> > diff --git a/Documentation/core-api/liveupdate.rst b/Documentation/core-api/liveupdate.rst
> > index b3c689e633c1..2bce2644eba2 100644
> > --- a/Documentation/core-api/liveupdate.rst
> > +++ b/Documentation/core-api/liveupdate.rst
> > @@ -74,3 +74,4 @@ See Also
> >  
> >  - :doc:`Live Update uAPI </userspace-api/liveupdate>`
> >  - :doc:`/core-api/kho/index`
> > +- :doc:`PCI </PCI/liveupdate>`
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 08a724b860dc..347c435ca404 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -20833,6 +20833,7 @@ L:	kexec@lists.infradead.org
> >  L:	linux-pci@vger.kernel.org
> >  S:	Maintained
> >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
> > +F:	Documentation/PCI/liveupdate.rst
> >  F:	drivers/pci/liveupdate.c
> >  F:	drivers/pci/liveupdate.h
> >  F:	include/linux/kho/abi/pci.h
> > -- 
> > 2.55.0.487.gaf234c4eb3-goog
> > 
> 

