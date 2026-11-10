Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0D75606A320
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 19:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=SwhjvWDy
Received: by kanga.kvack.org (Postfix)
	id E57CB6B00EF; Tue, 10 Nov 2026 14:02:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE09A6B05B0; Tue, 10 Nov 2026 14:02:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF71C6B05B1; Tue, 10 Nov 2026 14:02:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA4B86B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:02:21 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 343F2160A3C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:02:21 +0000 (UTC)
X-FDA: 85420130082.04.0255BFD
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1F9D214001F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:02:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=SwhjvWDy;
	spf=pass (imf23.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794337339;
	b=GNbrYDO6cFkBilDgDfmR5jnNbl1lOn868RULEBW2cgZ76Rry4s/lBjjKL4+5AdRqwaobhG
	wtzHTIrZof4FcI0P/Uuwv8gX9XrbLQJMMHR0a+6bANlONWou+lo9KHBke0NWUjpmyeHCLf
	VMwnkgHOb542HtbA4yCe55OGL8fTQD4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=SwhjvWDy;
	spf=pass (imf23.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794337339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rc92iNBDR3TpfE1Wb0FPlqB33KW4gheFc7Efbj9D4zA=;
	b=y0xzTFv0kZhz72X2S0I8SQl7Z41fDYBaF6nnZMuMb9ovmvONCQwi5uXavkOl0/zumVSpZD
	1V7D2FLe4ck1b1EiED2zMAuGNzk8+BtpLp3CNROLEm5W3qEbLbbL6/tS/uFBUvvuKyZZTD
	Qx8WLsQeejbac8iRlx7RGQkJZgKgMUI=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ed3f563739so6795ad.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:02:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794337338; x=1794942138; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Rc92iNBDR3TpfE1Wb0FPlqB33KW4gheFc7Efbj9D4zA=;
        b=SwhjvWDyOiFPbPADK3RApRw4MLD+Nyl+w1zK2t+qeCM3/VJ8dYsTz0hiwriINYV9b/
         4jBFER4u84Y11VrsDWbugu19Uqxeu9Z440btzPD/5kTG0PRjGLaGnLicWiOLFREFW7R9
         RB1C5ZWgClQX8013r+uMZN0QRlN4myqke93O7eCqUTHVgCA1/85ggUDGNJq0rQLD4js7
         i1dzSX2QAZznApdHLYoS+O0d1spKAP7fDe1KCL9miIcITEq9fxlzwk2AGiREhLhfjPVE
         DiV+uA7PfZEEqdgl2u0a9FZkbUkSfrRYKm0RqJTnawwpUQQaukMbb5kReLzMA5kqdsUh
         NIfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794337338; x=1794942138;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Rc92iNBDR3TpfE1Wb0FPlqB33KW4gheFc7Efbj9D4zA=;
        b=0lXg7z/iUxjDnM/GsJlUtvQRTq3ADUtEmzoYGCPn64Iaf3nvoHREFkk62Ihat8hgEf
         I1MWZ/YV5+Hgd0CQ/bxoglIkNU/RZfgVD8iJvqZX0ahuPqkFUHjaMlRaIKhxn3rHbXyb
         /fRMo3XXQ4wHIYUk8YFCsR97DFjUKR8Z87BdYcFPVvEvM0b8ZZCgq9giuGfuWjLqS5u0
         bfH7QtIrUrFTpqfWxaJjbeaXx5a1SGE6vRymXKr0IUAyTvCpTPzQF+xb68eKJB+EDa6L
         rfGhaRLmAOUM+btFqPpXf1tYREkDEbX6TjHerOh8Hu9EATkZNn7/guG9V1nsOJJ+J+Yk
         Ji0Q==
X-Forwarded-Encrypted: i=1; AL+hErEwrF8y6W2bIq/cdaJRd9wjttszz9VzUM73MKfi8W0RAvl/FZNyRdBCcOA8b+oOIUg8nzMl5nxb4A==@kvack.org
X-Gm-Message-State: APuU4Z+LcIAepFn8S9F2lFi+cG0wiXo0X1MMAPsNHva1mV3UjFJU+ZI/
	qPBPmqGTX9c3gIr4m7kPSoK+FRkvdXXIJc3ylVOsIn/NHR/ebv2NLm/NGtfpJfuIag==
X-Gm-Gg: AYBFou1M7zlr6Sw7ENYW7EbJu3oSTTSuO1+JJrA5Wzx4srswECy1t1FWWLlrB9sPinX
	meCse7aJe8TaT98qj80srLjX+BSTUy1ztB05DKY2H4C6yI9xAVapUP2MUpw/91TbFOa3HjMhESa
	ORCB1BDyjyNTxSVdrhsNy8rvFjOCWG/Xr4sLZAu/QwKp6bdzillBt53R+oUnLIHiku8aBtkdajC
	+P9JbYAdC7UKJbpc2pLXyMzE0Go0nk0eOf4aB60mQa+UwMkDBu6+qmjjh2gBp/1kGhs0loQTfSH
	a4RbaPrKbqA52XcUmvcTN6K3gtX3HsKBhJSySbkdzWJNfT1haCehkDfmMH8n+A+CbLKwG91iCxy
	+yFE4ljIBBLJ1C+8Ir/P989bRUwP5niwGZBCfLCnFJ9I2e+TBBZgb7ajnNXGZQ2+3w1mtp6l7Uw
	I6pUajfIaW5nGuZ8sNuEX2l8Ee3V1uDuGqPIurZTFki4r5hRm2jBYKTmKj5EofQMvPMHFXc5BxI
	KXFuGY8nnZNp1M4dYVtcRi7L355LY+fhfT1N6zUZ/Pu5O29mUqsJAlXpEWv1pUpODeXx8Hzn0G1
	JB04wSZoKP0Sl6+c5EASjtmMueYoBAVJ+iU3yPbhs2NXJqcP00WuynNnsjm25dNh
X-Received: by 2002:a17:903:1b44:b0:2d5:db38:8010 with SMTP id d9443c01a7336-2edba3e2a10mr5113665ad.15.1794337336971;
        Tue, 10 Nov 2026 11:02:16 -0800 (PST)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17db31cafsm914394a91.3.2026.11.10.11.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 11:02:15 -0800 (PST)
Date: Tue, 10 Nov 2026 11:02:11 -0800
From: Vipin Sharma <vipinsh@google.com>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org, ajayachandra@nvidia.com, 
	alex@shazbot.org, amastro@fb.com, ankita@nvidia.com, apopple@nvidia.com, 
	bhelgaas@google.com, chrisl@kernel.org, christian.koenig@amd.com, corbet@lwn.net, 
	dmatlack@google.com, graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, 
	jgg@ziepe.ca, jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, rananta@google.com, 
	rdunlap@infradead.org, rientjes@google.com, rodrigo.vivi@intel.com, rppt@kernel.org, 
	saeedm@nvidia.com, schnelle@linux.ibm.com, skhan@linuxfoundation.org, 
	vivek.kasireddy@intel.com, witu@nvidia.com, yanjun.zhu@linux.dev, yi.l.liu@intel.com
Subject: Re: [PATCH v6 04/27] vfio/pci: Register a file handler with Live
 Update Orchestrator
Message-ID: <20261110185305.GC519525.vipinsh@google.com>
References: <20261102153656.1431701-1-vipinsh@google.com>
 <20261102153656.1431701-5-vipinsh@google.com>
 <au5T7qouVfxJSDmr@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <au5T7qouVfxJSDmr@google.com>
X-Stat-Signature: 1t5mk49owysfj1r196kp6ujwyogr83jn
X-Rspamd-Queue-Id: 1F9D214001F
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794337338-750503
X-HE-Meta: U2FsdGVkX1/xVqWA6UG9r8rwkFUIbOTnKzwW9KaA3HILaANYEHklnI4S8EZJStLIFmQN5rdYZarHTkeIyXjetRCbkw+rqdHcTDnij4+UmIJ84oLqfH6gIDr5J0nrkAfkFoL0LugVKdfMS4lpOyags8+bzwi0AbZS/LipV+Fb6z/gdCcTvgX8HEOuj6GPebn+E4Bi9Sc0XKmaqI6QBCTVTE6RithdOqqlXx4LGmvPgnBZ+a0HatuPuPu/AB9EjFFJeiahs//Gla3emYb/BCBR1NWan+z1q/sIBV9aMPGYbLcOgeG0y7StvOsfuNoVzWG8Lu77L70R/W2eLaY2fgU83Xx5trOYR0557hvV60Oc6biLF7kfZiObZYp/v2gr/88UQvvtFRvNxvZ1/iIBs6dN9ozj0oRtT+bSC9yH20RggV2ozgVzenR7c0hXcevTec/pM51xnrK7egpCaUw9plhwCxWMaPLzpX17SVk78HoHOGtN0PEY3kIJxTwXFm/+2I0rsbek837qM8VNVK2XUAwBv6zEorQAj+TZ+Ouqu4Xtv+iyfcACPuTCt/xhu02Ps9vJ2+N+OR9dovWV87dpWJtBaJSHoehsH17B1a3uj5pVf0MyYQa9NCaSoU289MDdfwUO30e1YUfhAhvTfYfR/o7BvI87qsI839DQSJ+pnq10elL1T+ldZOXLQJXUOrpHw28w5MD8B8ogIMN547R9cLxZHzkEqUD30LYpuo/zeGpyKT1cFli+K2yibF9AHKN86fS7xAf10L6x/OynRgDyAKDu1P8TDK+pib2UH4rcqgOTQpz5ckORLwJPDFNILRpd1GypArWvqL/guLhBBMKMt0GmBSuhY5bS/paG5E4NmCiJgzH85jDlH0e/t66chHuxO2dXx5mYtVwV/XIl3pmkdTdebVgXxE6dpnAtVJWeTGct5TNt83WIfwRiv4XkRKeKZdM8QrwUp3jL79Y1rqpSGlt
 9hCAJDbQ
 PBIhh9tVNAJib2CzMxtQegZ/TnXn+k4YluBC3w5fIox3pu46DgzUtIlO86hKBZ2ANnTrKZWWqomArkTRuJ1lhYP9VAknBM+ZMOVzJekW3sk6VD/9n53tsXJiL9+X033AiUrMS1gfXvvgLoOmmF0gJHV6LrbeCDCZbGjAkW3jaUxerjl31Nh6vVjkSpaxNzendcCcLXcuKSmrs8VMPsxk+NU85QHnn9CvLVb6O5oSVqADoYNIpNqM3LG5kh84Oji3mmpzMNihLXODt4hkdQTm4DSwot+ila36QLzcs7sqWS2EG3OUj92ADW5TKXnVxukMTNhDWwr41xg8bxcoaMt0wnzPDUh6k/2gKn3p9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 10:29:06PM +0000, Samiullah Khawaja wrote:
> On Mon, Nov 02, 2026 at 07:36:33AM -0800, Vipin Sharma wrote:
> > Register a live update file handler for vfio-pci device files. Add stub
> > implementations of all required callbacks so that registration does not
> > fail. Register it with both live update framework and PCI subsystem.
> > 
> > This file handler will be extended in subsequent commits to enable a
> > device bound to vfio-pci to run without interruption while the host is
> > going through a kexec Live Update.
> > 
> > Put this support behind a new Kconfig VFIO_PCI_LIVEUPDATE. Initial
> > support is added for no-iommu model vfio-pci devices.
> > 
> > Co-developed-by: David Matlack <dmatlack@google.com>
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > ---
> > MAINTAINERS                            |  1 +
> > drivers/vfio/pci/Kconfig               | 11 ++++
> > drivers/vfio/pci/Makefile              |  1 +
> > drivers/vfio/pci/vfio_pci.c            | 11 +++-
> > drivers/vfio/pci/vfio_pci_liveupdate.c | 75 ++++++++++++++++++++++++++
> > drivers/vfio/pci/vfio_pci_priv.h       | 14 +++++
> > include/linux/kho/abi/vfio_pci.h       | 28 ++++++++++
> > 7 files changed, 140 insertions(+), 1 deletion(-)
> > create mode 100644 drivers/vfio/pci/vfio_pci_liveupdate.c
> > create mode 100644 include/linux/kho/abi/vfio_pci.h
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 5d1b58271989..167aa9d66ce8 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -28662,6 +28662,7 @@ F:	Documentation/ABI/testing/debugfs-vfio
> > F:	Documentation/ABI/testing/sysfs-devices-vfio-dev
> > F:	Documentation/driver-api/vfio.rst
> > F:	drivers/vfio/
> > +F:	include/linux/kho/abi/vfio_pci.h
> > F:	include/linux/vfio.h
> > F:	include/linux/vfio_pci_core.h
> > F:	include/uapi/linux/vfio.h
> > diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> > index 296bf01e185e..e8285ad93a69 100644
> > --- a/drivers/vfio/pci/Kconfig
> > +++ b/drivers/vfio/pci/Kconfig
> > @@ -42,6 +42,17 @@ config VFIO_PCI_IGD
> > 	  and LPC bridge config space.
> > 
> > 	  To enable Intel IGD assignment through vfio-pci, say Y.
> > +
> > +config VFIO_PCI_LIVEUPDATE
> > +	bool "VFIO PCI support for Live Update in no-iommu mode"
> > +	depends on PCI_LIVEUPDATE && VFIO_NOIOMMU
> 
> Can we handle this dependency in code instead of doing through
> configs? Are there any build dependencies on noiommu?

I can remove it but then by itself VFIO series will enable LIVEUPDATE
irrespective of VFIO_NOIOMMU and it will just fail when someone tries to
enable it. So, kconfig looks cleaner to me.

Can your series modify this kconfig and add (VFIO_NOIOMMU ||
IOMMU_LIVEUPDATE)? Will that work for you?

