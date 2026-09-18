Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6D4DC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 16:27:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFFE96B008C; Fri, 18 Sep 2026 12:27:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAFA26B0096; Fri, 18 Sep 2026 12:27:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA1516B0098; Fri, 18 Sep 2026 12:27:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 91F316B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:27:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CB8E216070D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:27:52 +0000 (UTC)
X-FDA: 85227414384.23.C066850
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 20739120004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:27:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oz5E76IC;
	spf=pass (imf29.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789748871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RUrki9PiihwqQhD1He2HPnPY/iXNXQ626jiFsHj9jNE=;
	b=r3cbi92npadsb9hL2xIKmj/EirUvYAzaN6roKAuvip+6vvXwqJRr0pKcRjNcQGA7B8pe8F
	q2DY/tCOAl1cg5quFHiJssa4P4yw/NUd1DH/kgzgbP6EjZE/GIpYf/debtXcZTC2LmUIeL
	bNswrKhPWdDJToZGcW5AQRVFXW0KrNs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789748871;
	b=GLi0zpzuT/T+6NtUH9nPgokF7WshX94cdM4z6jh40HXhVbQv6zzLpjdFV19eH0yjCSZAIB
	7T9pH7VXKt5q6u/vZmbnJxnN5ieRPvP/tmRn9/GStRoxg16RCJSB5w/9ugZ7dGokrLMLrZ
	CW6OdlvCC6QAugu3cs805Ds3ruYK2tw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oz5E76IC;
	spf=pass (imf29.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3DF0E41A79;
	Fri, 18 Sep 2026 16:27:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067F71F000FF;
	Fri, 18 Sep 2026 16:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789748870;
	bh=RUrki9PiihwqQhD1He2HPnPY/iXNXQ626jiFsHj9jNE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oz5E76IC1AW958/OUCiLVFPK5O7IA+IxOlkLIFaPL/lstGjxdAu9qkLwneHvOXAm8
	 /xsMM1GKPycYfyUcVsfLeJ+zz/LmAi+r4ijC6UisTu8rfZKebDQTq3ndKWvKZRW6/L
	 tvVmTbPn/42oV4pvF3FAVzMs1Fl2HNBs91bqs2Pi5Ni7+OPTKLwyaUz4vgyRcODGLM
	 aa0zQzqttJ9ShuLZM7S32GyDsYhEUnp8A2mfzjxWzWxZ/QPHswu8KO9/EvikoSGcRI
	 rMVHRJFoIEsgkxWwKuM3ET9catgXFbWZ2t17QkcjeUfJHfJkB3pmrB7GA56iZdyad7
	 rSr3njC0LIivw==
Date: Fri, 18 Sep 2026 17:27:43 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Samiullah Khawaja <skhawaja@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>, iommu@lists.linux.dev,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pranjal Shrivastava <praan@google.com>,
	Vipin Sharma <vipinsh@google.com>
Subject: Re: [RFC PATCH v2 00/10] dma-mapping: Add preservation of direct
 allocations
Message-ID: <aq1mf_EXzn2hUwy4@willie-the-truck>
References: <20260708234854.4044652-1-skhawaja@google.com>
 <20260826183112.GA3703145@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826183112.GA3703145@nvidia.com>
X-Stat-Signature: 1jzx4c4roo8cd4m351ygisn7drd9p7mr
X-Rspam-User: 
X-Rspamd-Queue-Id: 20739120004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789748870-672826
X-HE-Meta: U2FsdGVkX19FbasLA8CGga/8Yf9xvxyDGN5YWAg6+vOclpAM9YcRP32eKQubOTgX7ClsScYUWGrJA7vCkF9hnIeV9Ntoq31YGSSCFYuMo4+a+yKAP4o9b0LGTlwl8Y7io+31be6+mNNYl7Gg+isJi1NPGEa2ft2CHDGFw9PjhgzFp8o85lhxfslADiL3FlZkBSZQLdEuoLjJo1y10JMW8qDjGodc8v4vBOE2JQzKMEs4eF+mrlWrbB7JGrQtqsPBYSfFKkrN4t3rnT8rSG6+fKFX+crwpA65cyEKE/DgWBl8g1PF8LrrF9U/iIgeKtEC4aVah02hNl88Q998kb4E2O2fVppldPvrqT6C3zzvxPaAPGaeThF0IrZ2x0qJzo7ksmZsEQWcAVnWIf/DYMsdijiETdZAElR8TwN4BmQgy6gK7wnzFkLQ2sPuD0HAGyEcVIdTP43wpgKjl4z9cN00kjrQ5iyR4YZCpi5nsFjOLf0sNTJlR6yy7zyutZXnIzQD74Eu7oR6KYlo5gLLMLJ+g0nGrl3Kj0mGJSAUW/MbdnpKedO5nTUhjJ43ac66j5nGDXHfTRTi4o2/OhDUHutLJa2hmEJqMgO0fJJ4ZHJ5MJahJ0ElfkuQd1fFf2TPN+7AiyVZfO7zcLQW61CnqtENEHOINYE4L5Ahr/K+7IozsOlAElQ0r500yUP1r2KT4qdkyKMyY/hmIBGGkuDNjE0YfEpXyuVA1PGzzvFXXTKYyF/dgz7zrF08oKbJJCpfBFqvqMaxZVIXG4C1kglsibOZsg6+8MpK/WEkHEl+6jiSZxgo3jEZyQhwmgVs0PZo54svEWZVv+/f2RGb8uZBk3mRVGZ0ONJhotNmbP6obgkVNUky2GQgLY1Lc5HQPAnIbd4lsZMj6u5j0UZaUQ+cXDP1AgiRJ+531xlQ9D4+NSZ3Wly6EYFWUnu24VOWmqInVzgeI7g7/ikmdNQQAcsmJ5o
 ArCsYpLW
 tj382KOXGk+H5PSEojl8xuLoZwfuBJFZm735NpSo4if8SlaVyvd5XFG90fJmyJhBaGtJJXNj5zs+fSTtU36zwtTlWtY+Kamz3W0BhPq+MFOTh+JmdL8bsJBGkYH2w2da4l7g1XC/h/V3KVJ0383RseAt0bZpX+eu+/6P/rRTbtKQ6TvxVZLpZzUJxLm76eVStYzsMkDl10DUIP2IQ2XiohZZuGmElLQc7uWvFTfh0Nwcn5cLEkLsMfEIVHWCxcK0oCy45
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 03:31:12PM -0300, Jason Gunthorpe wrote:
> On Wed, Jul 08, 2026 at 11:48:44PM +0000, Samiullah Khawaja wrote:
> > This is an RFC v2 to discuss the preservation of DMA allocations for
> > devices that are using direct allocation mode. Note preservation here
> > means preservation of physical memory using KHO only. IOVAs and IOMMU
> > mappings are out of scope.
> > 
> > The complexity and need of this was discussed in the thread mentioned
> > below. It was proposed to allow preservation of only a subset of
> > allocations with minimum support. Offline discussion with Will Deacon
> > concluded that this series is still needed, because we still want to use
> > coherent allocations for Arm sMMUv3 ste/cds, so sending this v2.
> 
> Was this before or after concluding that ARM was OK with using
> cachable memory?

That discussion was primarily about the page-tables iirc.

I still think drivers should be able to use the coherent DMA API and not
have to use an entirely different interface depending on whether or not
they need to support KHO.

> >  include/linux/dma-direct.h        |  29 +++++
> >  include/linux/dma-map-ops.h       |  10 ++
> >  include/linux/dma-mapping.h       | 100 ++++++++++++++
> >  include/linux/kho/abi/dma_alloc.h |  32 +++++
> >  kernel/dma/Kconfig                |  12 ++
> >  kernel/dma/Makefile               |   1 +
> >  kernel/dma/coherent.c             |  11 ++
> >  kernel/dma/contiguous.c           |  27 ++++
> >  kernel/dma/direct.c               | 189 +++++++++++++++++++++++++++
> >  kernel/dma/direct_test.c          | 208 ++++++++++++++++++++++++++++++
> >  kernel/dma/mapping.c              | 132 +++++++++++++++++++
> >  kernel/dma/pool.c                 |  17 +++
> >  12 files changed, 768 insertions(+)
> 
> Because this seems like quite a big change to swallow compared to just
> using iommu pages.h

Maybe, but I think it's in the right place rather than scattered across
a bunch of drivers. A good chunk of it is also test code and empty
static inline functions.

Will

