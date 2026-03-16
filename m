Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0611F53D6F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 16:22:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 230146B030C; Mon, 16 Mar 2026 12:22:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 205086B030E; Mon, 16 Mar 2026 12:22:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FD126B030F; Mon, 16 Mar 2026 12:22:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EE32B6B030C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:22:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 486A216033E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:22:41 +0000 (UTC)
X-FDA: 84552444522.18.B986C1A
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5835014001C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:22:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=f2Rdbr8d;
	spf=pass (imf23.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773678159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qInQBteouiFFrqfiLhXSZXU3zqWyev9a+m0PyBXHRjI=;
	b=uSy9hsOULWZbDmzs/SotT/QFDYwONSp46nRZUluE3TVQFtom71yVe0X4vOJdLTuZZOSv/f
	yRy0EN+jc+8wXyD5+PFYAJ8CthI/iFF9ydk1EXMhVhDjvV1z2uyHkpVAFFOE7LJQUJom86
	zFWWR57B5fhB1fItS2IbBoUdWS2h110=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=f2Rdbr8d;
	spf=pass (imf23.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773678159; a=rsa-sha256;
	cv=none;
	b=1/p7Czh//ibm7rNog+ZtKNVPmNpjIDYgkLAA9mE9r9f8aAyuPI0Tg60TH7sHOpq6ZiYvZT
	ZeL7R6NJQHiUmeCLk2VuC/nGLhQa+eozjOt3tuv+wlFSZjIeBAmmsjVyxndhveCz6X1f8u
	8FZpEpLETrDBCFjuCyTGNdQ8L+9BrA8=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2aeab6ff148so163115ad.1
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773678158; x=1774282958; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qInQBteouiFFrqfiLhXSZXU3zqWyev9a+m0PyBXHRjI=;
        b=f2Rdbr8dSyXIUTEXlS9zpm1fq9K0N1cheaZ6jIYmoLPrhi9gl/1SkT21a+GobRoH7q
         0ZTjrlugr8eoY38ty/gN7A9FhC/isFrWW6jmTWkK9JiuwknWJ1bXxCCVmOCy+xAR8Epb
         1Th61jnj5FBiarbTqA3SDZ02zR6pnv4ajXkow1iG/igdFo7O1dq50anS2pcsbvE0RFEd
         HK+gorQ6mn0JHhTtYt2/VfFhol9IiTTyg4Y0YFytiDM5ihfrmgg4EcPZRHfvjysFbhsQ
         PMjX68P6mQJOc81CypzM6TfpJ0iX1gHcym4xcm9qcBGp9yh009+0aBvjPoOjACsy/Kfd
         /RCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773678158; x=1774282958;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qInQBteouiFFrqfiLhXSZXU3zqWyev9a+m0PyBXHRjI=;
        b=GfRbm1uRCgGQfpy9kByDuxmRsR9+xCrivMSf9wsKrQoDaNoWOZiUyvT5zyTVs8VnpS
         d0kIxGbZTqzei0N3AdXaPQpftVTTamR1Lyv51FICHFfBJMbzjfDTimyncDkFTrhrNgzX
         nLrO6nUuvQjca3zJeQLHwV/CGmU/luAUU9oOaMWtYKW/gAeHaoxD9w1UT2YrnaRE6eV+
         9vTcfGphjlXPJ09sTKL0YOUowvi/Af+FKXLEdtr3TMvGRO8oosJNca77XCJaNMzRgy3P
         rcCtwubBObjHaQD4c3Cz8hgtPU0EIhPE45fIP9arjcjvZlY4NXfmLSHFOa6QJ2N2sF83
         2nvg==
X-Forwarded-Encrypted: i=1; AJvYcCXOgw1eAoLA3LHXg6Z31LW12v+AZR4CciBy4zzrCOVGV/pocnIWxifR029szskg3LeTygkDLorZLQ==@kvack.org
X-Gm-Message-State: AOJu0YzT5qFUa7jBvUASY7zezJ1nrlnAzvMFl4jD2pyS55KzypEkCX9C
	WiJahW5PYu+9FtJwcT3/TAszmXtlqy+ugsyp9bOIzl3BEr05woyD0YdAS6qfTybrqQ==
X-Gm-Gg: ATEYQzx73zrOl927gGb5B/Ms8sDbvndwYhU3EpcUATm06Eo3tiMGYEhFC3d4MkBqSL6
	rTcmzuTJuesqfSzS4+M4WsidOXnhyTi/FwW3L41KK7XH5Q+hEHK//+otBYcT6rtMS181d/1KzNp
	+jVwVLfvPlsEKj+m4ktMvSPBXRfhZGJ8Yo8MnvNYqf4lNhunHDzkX/CC/iE/Uq6tbbGaWrT0TyX
	N9wd+93+21bb/bUbxXu/e+qVGwoHQnyskmV1eYuvC3spPkWQxJwUcPgzjs6sh53ZkU0WFCIavpu
	JhXh8n31YFBgrbTVMd/q2opfQKCcCcq5zjZOwHccP7LgO88RU5+1sg6Mqnc94TcztIMk3+9/giM
	ZvobAHQK8OzntLluRvb6pBXAnuLq6EWqaouf67jMniXXnB6D7t13Rt7gRqa89P+jVgmG4hfPHFM
	uHoJwjiHmOs3P/+rhdaxA4yl7o9uxcC0sArlsJ14FMp9+Qy/MM4hL8gBuh2P4I
X-Received: by 2002:a17:902:c94d:b0:2ae:4572:50e8 with SMTP id d9443c01a7336-2b04208841fmr5460915ad.8.1773678157593;
        Mon, 16 Mar 2026 09:22:37 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bada43329sm111822a91.6.2026.03.16.09.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 09:22:37 -0700 (PDT)
Date: Mon, 16 Mar 2026 09:22:32 -0700
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
Message-ID: <20260316160759.GA1767448.vipinsh@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-11-dmatlack@google.com>
 <20260226170030.5a938c74@shazbot.org>
 <aaDqhjdLyf1qSTSh@google.com>
 <20260227084658.3767d801@shazbot.org>
 <CALzav=fHy23RAzhgkdaL+JA5T2tL9FT6aPgRfXUh7i9zvYCGPA@mail.gmail.com>
 <20260227105720.522ca97f@shazbot.org>
 <CALzav=fjRPa_ZbXu7iFXyemcf_8Kq_dZTWT6c-A0bc6czF_Rdw@mail.gmail.com>
 <abNOwcOTXqxCxNzt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <abNOwcOTXqxCxNzt@google.com>
X-Stat-Signature: 41t3f5nrjpophrrfdp6r46t9gpmossex
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 5835014001C
X-HE-Tag: 1773678159-722569
X-HE-Meta: U2FsdGVkX1+61/WADS+MArRevRcBHReCcK6tivCgrNhj7xu5tLoaZ/ZCr3DYhvqHwdirVEWE0MZl5ZHgNZoaAackavcx9Wu1RWhdHpbHyJWwX6YT69TqB7kTAH9ExZ/qPBlUb4JR4DrjNFjy22ecqptgcdb7Oi8fX6Qw38r6SxRQXH/CTFJRXdi4ytuOuAeuIoHjWflEXG/5y0W49mtRCrAXj2ik9UdYxXfRw3evTdfz7eSfGfLH5WB9x1l8333ZoPn+2V07rFzo47zOjVk6qmb/6T0Lm9sfjyCVNli4AluscHFCU4ZtkHuptVdCtIFIoxjf7lEF9ykYJjWUDI9FTBXTkn8BFuMnO1fdMm9QgrWgj+ANxsGnutzhG5zYigJez67J5BxtI1/0tWsQhSKtU0RcUkUdEES8KmGeYq5aK78aC+8BEyOXttyzUuyHE9lWVopAV1mZd8Aah+Hsr9mgaXRnxzrB7T8dwhNZJFNhxqJHTxGuCIoQJF6niD/0oC9l+i7pmJOgwR6dFmXef2GloyPUG9gZo+qCFt9yTqRI++E7SvNUpVHXDtaXkELcKt+Nt8qMm5aI/9Ie/io4gRkcdC+hL31vVyYla9Xls1qUeiekE1WXrCwHERxn777kUJ/coC1Yb872Y1+pD63aRd1WeZHiQ9XAMIg6yEf1xUUnhVeAVO8cYUtrXBLfPT2TWsGGuGMhaET2ymdcl4fqwHpYQMwr0z82FV9uUUgBdJs6qc8vKeyPV3eSucPdS2yNlphvV+y5IdRZ6TuzLqGUicx4pX9zhCoUubCh8mmVvMg9hwzuuLZSQhYoZfyzjO8uuqktvWBkSu73SfjhW+wyR3XrklWlVq14bBP5jDKw6nOT1yzJyQ0e7dVhnqOPWnzKKyuxSu8rlVz/IqwnNTPWy6qhdp+9ijPNWs0YMp1rFJoWGvI9V2MmKUT6ZIK5VmAW1QlpC8zppNw17PQTRtKo7sq
 Yy+WzuxD
 +EdPHDv1pAq1Rg0/Oxrween/QcXNqpfMZFGkm2hROMsgGfnfHm6fbM0UtWngJs+Slb/PGJhmbm1rPIJfctozUIPX38XlvxclakNHJmP0FOR73NiLzIkHQtwOPMTV79eMnk7NAW7yHlav6x61sanGvIkqAsxkq+QRLivofg7vU1+wdNAbd7nSUeYQp++Q/B0zSPYNB63EvIv1KBxZIzSVTCXah8bgugQ+ZjyM/04MGA/GaUn+/MqFnr2Icq1AVzbkFwFxxlKFQFzxsY9MEg47Nr3dl/vfT2XHJ4LjvgkB5zZjIatcQwCBp07AAMmpjg0/5yZ5Y+PCK5STGC6DOOrnC1zt1TSelF7IxcZMb3L85TCiOCGqvfdcew6U83a1Tr1F6DO2dK4C+5X4CgD5VB73Tl/7nL8sn9uWTtrGJdNOVc3xhVO2kTxQhNAFDnTxXPff3To3c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 11:39:45PM +0000, David Matlack wrote:
> On 2026-03-09 10:32 AM, David Matlack wrote:
> > On Fri, Feb 27, 2026 at 9:57 AM Alex Williamson <alex@shazbot.org> wrote:
> 
> > > Sorry if I don't have the whole model in my head yet, but is exposing
> > > the restriction to the vfio user of the device sufficient to manage the
> > > liveupdate orchestration?  For example, a VFIO_DEVICE_INFO_CAP pushes
> > > the knowledge to QEMU... what does QEMU do with that knowledge?  Who
> > > imposes the policy decision to decide what support is sufficient?
> > 
> > Hm.. good questions. I don't think we want userspace inspecting bits
> > exposed by the kernel and trying to infer exactly what's being
> > preserved and whether it's "good enough" to use. And such a UAPI would
> > become tech debt once we finish development, I suspect.
> > 
> > A better approach would be to hide this support from userspace until
> > we decide it is ready for production use-cases.
> > 
> > To enable development and testing, we can add an opt-in mechanism
> 
> Here is what I am trending towards sending in v3 as the opt-in mechanism:
> 
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 1e82b44bda1a..770231554221 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -58,6 +58,27 @@ config VFIO_PCI_ZDEV_KVM
>  config VFIO_PCI_DMABUF
>         def_bool y if VFIO_PCI_CORE && PCI_P2PDMA && DMA_SHARED_BUFFER
> 
> +config VFIO_PCI_LIVEUPDATE
> +       bool "VFIO PCI support for Live Update (EXPERIMENTAL)"
> +       depends on LIVEUPDATE && VFIO_PCI
> +       help
> +         Support for preserving devices bound to vfio-pci across a Live
> +         Update. The eventual goal is that preserved devices can run
> +         uninterrupted during a Live Update, including DMA to preserved
> +         memory buffers and P2P. However there are many steps still needed to
> +         achieve this, including:
> +
> +          - Preservation of iommufd files
> +          - Preservation of IOMMU driver state
> +          - Preservation of PCI state (BAR resources, device state, ...)
> +          - Preservation of vfio-pci driver state
> +
> +         This option should only be enabled by developers working on
> +         implementing this support. Once enough support has landed in the
> +         kernel, this option will no longer be marked EXPERIMENTAL.
> +
> +         If you don't know what to do here, say N.
> +

To use VFIO liveupdate, user has to do at least two things:
1. Enable CONFIG_LIVEUPDATE
2. Pass VFIO FD to a live update session.

This means someone using it has to know what live update is and
intentionally pass the VFIO FDs. Isn't act of doing this itself an
opt-in mechanism?

I am not sure providing VFIO_PCI_LIVEUPDATE alleviate Alex's concern
about how userspace will know that sufficient VFIO support exists. May
be write in liveupdate documentation (PATCH 11 of this series) that
support is experimental?

