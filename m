Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95F65FF6E97
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 23:36:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B579D6B00AE; Tue, 17 Mar 2026 19:36:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B08DC6B00AF; Tue, 17 Mar 2026 19:36:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F7936B00B0; Tue, 17 Mar 2026 19:36:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8ADE76B00AE
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:36:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 316511403EB
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:36:26 +0000 (UTC)
X-FDA: 84557166372.21.6EAF4AD
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 39084C000E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:36:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mjYM1vrF;
	spf=pass (imf10.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773790584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8R08fAS2L/TqkBdbNFXhbiB2wc1JFGzUh5S9wXtuww4=;
	b=B6tzjVQ+gzNAhV2WP96Itq0JK8G+Cf1LToC31y+GaKsRZ2Mf2Qd2mZvc4WpW+0beLTD6x/
	8rzNrkoHqBO4pBbjzTT8p9/7bCHNU1DYPW5+kpC5Am3EkrA/J49Xkc2E+pckQGTllPpA5m
	PXPcImxrosFNmHYYknI7vLaHTKpiRo8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773790584; a=rsa-sha256;
	cv=none;
	b=7QkVcWxfnqEZcaalYnPuNnjgGPPPeWZa+thgixn9svAPs7wvp3k6FH7WJF1AURdD3xvEb8
	5R8k1aCIOMwlf6RnTFDmsLFxcwIDnVaZUU6wfYorWMc6qafpCQC3VkIfSm0LZsgC4mJMLm
	aoc77NS4oniAgs+LDUwgb1hdfm+GVYI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mjYM1vrF;
	spf=pass (imf10.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2b052ec7176so20935ad.1
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773790583; x=1774395383; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8R08fAS2L/TqkBdbNFXhbiB2wc1JFGzUh5S9wXtuww4=;
        b=mjYM1vrFb4hd8uNo3IjvYAWASnfJ8/uF3OU+heR1HmPwZf8hI+UWjrYcKdzsXdLyEt
         s3qr6iqtPZ0KfFxV4Nvd9ZEpLJVxGCg1CcuFQ9HfWq+T7xLhlh0DzZJNonddRMFwBqFQ
         jTG/6YQxQgd3xuflh0cJRsc557PGDvo7IGFVnq9z6FSVYNM0kll5dipf9DzpjdIAjN7g
         gtRi8bKPgRrh6iFtOHUm5N9Td4V0u5+T1BqSvx4Q/I/3gtqH6EZ/eCrsLkRp/iqKdIbv
         L2GCUdtCofXD0rZOzNBbiCR2059RaEZHLKZoO6cjlTT0Hwod0IsXAjLSJ4AKjM0Q1jnK
         hl/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773790583; x=1774395383;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8R08fAS2L/TqkBdbNFXhbiB2wc1JFGzUh5S9wXtuww4=;
        b=dP9Q1Vc+mMU/Lf6EqVqXdoD7a2Lpcf9mYOwCZVQWA/cCBhXqEOY/tDeuocpGlt0F8S
         GO0j3DmmV6VVpdXaLJHGGgw+aPtt+YNc/dG/jSD/91O7JzRghEk8YIqLuWIAPB3gQ5cj
         cOcnHYPeoTcTiTYbTcDF4ChM2zW9VbH/MgRyIYCU5mJ2+V/70cgJ+n8f34ArRA5z7qw0
         BMjam2fhQBsJmu7QLYzcPzCeF/DLAxQNA/rDBLhZrhr0vqpS8DGNnenN8vNikbYrX1fR
         gJKHD6Eh4iIO60pGSgdtPACjOXR+JCvSLEjhfewwMGGrfbcTZitvnIbaAnNQ+3K8UysQ
         ImDA==
X-Forwarded-Encrypted: i=1; AJvYcCUMou7pVB+NR80eU+Q2BahbgXsBaABNcNHyfGcYOFXZs/28nlAbm+p8bkR5RzHRTjRoKMgGSI3Fig==@kvack.org
X-Gm-Message-State: AOJu0YxIVoz0Qp24YW2WhqJmFbzjIPx8LQXuRHMwuXaQKWcYxuqz/J/Y
	x+OD8VUL4vrox04AGMgaePha4xC7RB2AEVAQWB7ew/Lhy4+SACJ/Bi2YdCwzuht7uQ==
X-Gm-Gg: ATEYQzxEgNtTrWeeilTMEJzyu8sVNuFNxrPSZwmctBKTLWYtTWeBjWA3dV6+6H/uVQR
	5zS7Wjeint9Ly9V1LtwMg/0N/TvrhsymVXLbnZ7iPjSRbDZ/Sn4+8ANV8G5Xw6cqjl9MzMn7djb
	ug0WCjnIwTELE64x5eo2QsGPcjHBtcBhFYxx7rOphTeegDimH7MCKcluOGjIVRHnrhCbkfNj6dt
	FJ4lBXryq0oWK+gnwwuJ64hiT3Zzjjw94rIkbGLTL28ARLCyMGTXj7PIxTvW4RDJUVf3uYHhM7C
	QCXaT2ONGbSj3cLu1TAYt/2WtAyImDu0utpKRYuQtixp3AoN3tckG7uj4DSppE63hsgTdWFk4wH
	m8+ni9JuFa5FET6BPhiLwMXlYTTl0UHx37pWJofyZuMxKA9HqtALu9OMkYOmVM6S+xXrD6mQQFW
	VYd5So5oHDgdjfPf8j2QlhveMpxsvGLxi0uRdhhgerbffYI/t+biOs+tGnJQ==
X-Received: by 2002:a17:903:22c7:b0:2ae:c566:bd99 with SMTP id d9443c01a7336-2b06e88a5f7mr1634235ad.22.1773790582361;
        Tue, 17 Mar 2026 16:36:22 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b06e629da3sm6015715ad.76.2026.03.17.16.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 16:36:21 -0700 (PDT)
Date: Tue, 17 Mar 2026 16:36:17 -0700
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
Message-ID: <20260317232431.GA2795773.vipinsh@google.com>
References: <aaDqhjdLyf1qSTSh@google.com>
 <20260227084658.3767d801@shazbot.org>
 <CALzav=fHy23RAzhgkdaL+JA5T2tL9FT6aPgRfXUh7i9zvYCGPA@mail.gmail.com>
 <20260227105720.522ca97f@shazbot.org>
 <CALzav=fjRPa_ZbXu7iFXyemcf_8Kq_dZTWT6c-A0bc6czF_Rdw@mail.gmail.com>
 <abNOwcOTXqxCxNzt@google.com>
 <20260316160759.GA1767448.vipinsh@google.com>
 <CALzav=cskxLZtZ5-uRa0+aV+1Kb3fwQQJ5dS=Yes4GAHrS6GpQ@mail.gmail.com>
 <20260316214055.GB1846904.vipinsh@google.com>
 <CALzav=df8K0R0gJyQ=ifoznp_CMRRtyrWchbNvcw2-wpkdaBaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=df8K0R0gJyQ=ifoznp_CMRRtyrWchbNvcw2-wpkdaBaQ@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: dmm4o3qor77qndotbegawppueqos4fq8
X-Rspamd-Queue-Id: 39084C000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1773790583-277769
X-HE-Meta: U2FsdGVkX19n/+N6S3e2koXXJfvB9fWs+27Uj7O3a7ZiVGdQV4bGHnijrUDVhQY60PJDhyoLTMogOBqYLON1yK6W53NRUWQMlZ8YL9WBNLbnppzE19QTb2gPrrE5CC6QAAA7B4baDLo0xVT2vAnri33aPuYNMOxhOofhCsX3c48mvEXNSGWQNmYJQZBRp1mWH+Mif/1DN5ZrsOL1lGCVDu++qtEiqLg04AIQqI8Po6CIr5eImqXKDl2Pw8ECDkiKJUANJvIfCRjcP5gK/ONHUGlpya/BUyNNnIBjVsRbn6Y0o2oJJ06/cYiBGGoZMSmFYElzAf0fvf3IG/pJvWt56TOzJ1XhAybqvCHHGmw8iGMgymgGEblbtFEgNlxDlWXRi7uBcCR8UbnhBn3kUEB0fPesxpEwUi+HfDyXg/ndWRpJalRpru+wEIMaYPqWM5qzOLenFTIg2b2coBROE0VEurjbwICwghtQztN2MqfbWSs+6DQhnQHkjdAHfVUUeAu5kMlkuEGjEeiIYv9ae55IU4ukE+3kZ7/9vjklroXXPdyVrZbrdHIMhP4jWo6nFiutDI2hA5tQYc2ef98UlQyN9Tqk+dV+/aLCx1lXUhaeM4iZB9+uyp1NG5eD2pZqHfh4dSjDCNlqtBPH+JqFWdrQZKiCH2ILIHZzT3dgQHonDg8SgBQsbwwB5pssgP+q6GTSuBpTdnU9j8afl35gpjhFlMRQMONagicbVTLexQ6flnWOhfoeMoDxZeTjqvzlXdmx4bfs1j3t7iY5yrhVgRlTj6GJP3BqX/lkKcDpbXb0CVLnMPFJ5MUgHu5qyYl+J3yEqvLVhFvXS3CrXqBQX0kRR3pEKbhe1vMXX2EAzA9vzhw85uaulwXu18vGmNIO6ro6HTgrdWF1FVkx4lKw0QY8oCfp/ytIXBgMyf6FQxQ8yjQbDspz3wLWoT/70OZOskSd8N6nXYA374Mu2XjXJSB
 Dc+wgb07
 NFU4UTDJmXX5OxKOgAgTmHNYPggF3WjJzHe7VwslH2HYEx9IDXX2YBpx2iA6xgsA/BBxs00SzkBsZRs/QTBQUPGIPx8jrmY+1Iop1PngmrezMlaQLA7IGrzmvS18CfTe+PHTee0ERsYVlotIkkST/yZ265C3S9/FXfwCWntEOlr9GCOC1b/28i6edBJqJvR3hZooVdiDpL/gYLBAUSRKF+i8fC3BifFNJ+cFIqyiLXF368DVWtMaLrPsxWGZ2HlbbsmHG5DPQSgTxLNBvv0XlhM2lvBC+3PhXgNAZ3ro857FtyIDcvXiwxEc857yj4oIfcXAS0VrqZlzwTPplMYV6hsiqHwWtP2gFLDIKUgs9O2WPwYEQFDNC5LZX8au+EKWoQv8hR9KhRxgpBvE1vDWk2wtSXLbUNNpO77LlRVs3xill+HMal9ilxWqqeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 03:14:18PM -0700, David Matlack wrote:
> On Mon, Mar 16, 2026 at 2:49 PM Vipin Sharma <vipinsh@google.com> wrote:
> >
> > On Mon, Mar 16, 2026 at 10:18:22AM -0700, David Matlack wrote:
> > > On Mon, Mar 16, 2026 at 9:22 AM Vipin Sharma <vipinsh@google.com> wrote:
> > > >
> > > > On Thu, Mar 12, 2026 at 11:39:45PM +0000, David Matlack wrote:
> > > > > On 2026-03-09 10:32 AM, David Matlack wrote:
> > > > > > On Fri, Feb 27, 2026 at 9:57 AM Alex Williamson <alex@shazbot.org> wrote:
> > > > >
> > > > > > > Sorry if I don't have the whole model in my head yet, but is exposing
> > > > > > > the restriction to the vfio user of the device sufficient to manage the
> > > > > > > liveupdate orchestration?  For example, a VFIO_DEVICE_INFO_CAP pushes
> > > > > > > the knowledge to QEMU... what does QEMU do with that knowledge?  Who
> > > > > > > imposes the policy decision to decide what support is sufficient?
> > > > > >
> > > > > > Hm.. good questions. I don't think we want userspace inspecting bits
> > > > > > exposed by the kernel and trying to infer exactly what's being
> > > > > > preserved and whether it's "good enough" to use. And such a UAPI would
> > > > > > become tech debt once we finish development, I suspect.
> > > > > >
> > > > > > A better approach would be to hide this support from userspace until
> > > > > > we decide it is ready for production use-cases.
> > > > > >
> > > > > > To enable development and testing, we can add an opt-in mechanism
> > > > >
> > > > > Here is what I am trending towards sending in v3 as the opt-in mechanism:
> > > > >
> > > > > diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> > > > > index 1e82b44bda1a..770231554221 100644
> > > > > --- a/drivers/vfio/pci/Kconfig
> > > > > +++ b/drivers/vfio/pci/Kconfig
> > > > > @@ -58,6 +58,27 @@ config VFIO_PCI_ZDEV_KVM
> > > > >  config VFIO_PCI_DMABUF
> > > > >         def_bool y if VFIO_PCI_CORE && PCI_P2PDMA && DMA_SHARED_BUFFER
> > > > >
> > > > > +config VFIO_PCI_LIVEUPDATE
> > > > > +       bool "VFIO PCI support for Live Update (EXPERIMENTAL)"
> > > > > +       depends on LIVEUPDATE && VFIO_PCI
> > > > > +       help
> > > > > +         Support for preserving devices bound to vfio-pci across a Live
> > > > > +         Update. The eventual goal is that preserved devices can run
> > > > > +         uninterrupted during a Live Update, including DMA to preserved
> > > > > +         memory buffers and P2P. However there are many steps still needed to
> > > > > +         achieve this, including:
> > > > > +
> > > > > +          - Preservation of iommufd files
> > > > > +          - Preservation of IOMMU driver state
> > > > > +          - Preservation of PCI state (BAR resources, device state, ...)
> > > > > +          - Preservation of vfio-pci driver state
> > > > > +
> > > > > +         This option should only be enabled by developers working on
> > > > > +         implementing this support. Once enough support has landed in the
> > > > > +         kernel, this option will no longer be marked EXPERIMENTAL.
> > > > > +
> > > > > +         If you don't know what to do here, say N.
> > > > > +
> > > >
> > > > To use VFIO liveupdate, user has to do at least two things:
> > > > 1. Enable CONFIG_LIVEUPDATE
> > > > 2. Pass VFIO FD to a live update session.
> > > >
> > > > This means someone using it has to know what live update is and
> > > > intentionally pass the VFIO FDs. Isn't act of doing this itself an
> > > > opt-in mechanism?
> > >
> > > If it is, then I can leave this out. Alex?
> > >
> > > My thinking was: Distros are free to enable LIVEUPDATE and use it. The
> > > support it enables today is all fully functional (albeit new).
> > > vfio-cdev, OTOH, is not. A separate Kconfig can help express that
> > > difference.
> > >
> > > Consider that LIVEUPDATE could be enabled by default in a future
> > > release, but vfio-cdev support might not be ready yet at that point.
> >
> > But that also requires point 2 above i.e. userspace explicitly passing
> > VFIO FD to liveupdate. Unless there is a capability mechanism like KVM
> > then userspace cannot know what is exactly supported.
> 
> Yes that is why I propose not exposing the support to userspace at all
> until it is ready, by compiling it out of kernel via new Kconfig. This
> way it does not get accidentally enabled in distros or downstream
> kernels before it is ready.
> 
> > Also, users who
> > are using these APIs will already be advanced users and have to know
> > many details about what liveupdate supports or not.
> 
> VMMs will be the ones preserving VFIO cdev files. I think you are
> suggesting they should know what versions of Linux support what kind
> of preservation? Like QEMU would know that Linux 7.1-7.4 supports
> partial VFIO preservation and 7.5+ supports fully? That does not sound
> like a good situation to be in.

I agree, for VMM its better to just assume it is a complete preservation
feature but it is an experimental code in kernel.

> 
> I think it's much better to hide the support behind Kconfig until its
> ready. That way the PRESERVE_FD ioctl just fails on kernels that do
> not fully support (because VFIO_PCI_LIVEUPDATE is not enabled), and
> succeeds on kernels that do fully support.
> 
> If someone wants to enable and use VFIO_PCI_LIVEUPDATE while it is
> still marked experimental, they're on their own.
> 

Sounds good. Thanks!

