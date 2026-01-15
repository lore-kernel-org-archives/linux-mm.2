Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 686A1D3CCA6
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 02:40:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF31E6B0088; Wed, 14 Jan 2026 21:40:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDB346B0089; Wed, 14 Jan 2026 21:40:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD7786B008A; Wed, 14 Jan 2026 21:40:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC4C76B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 21:40:47 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5CBFB1601B5
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 02:40:47 +0000 (UTC)
X-FDA: 84332645334.22.601517C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id B629E10000A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 02:40:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Vfb3gBTf;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768444845; a=rsa-sha256;
	cv=none;
	b=llkqxch9xpkFpkvzVSgaFxpY15LPG5mTcofg/vMImCxACJgAWt269l8fv9xpXyrA9qeJO0
	tXuG6TeqecHxLwtcn9uus59+we5v2hZ59CihHauulZbKT2wRCSppV0qp6nBV3f4DChSJGq
	8FDjgPQjpeovZGuzQWnTn9kHGcMVBhQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Vfb3gBTf;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768444845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wPg1Rmvkx3e8pTULbrjUB1f5F5lTCXFNy35V+rVVRpY=;
	b=lnlKV1r/bpOA2FYsrKy0XbYHYRdp9wdXGr3z3cntYf/fuhHp1us3SaBEk2kB6iCiOrJQf2
	o4VxxW/KFoAiP9W3iVnwmBYDOFI7xSyK0p9g5VMdxuszVSum31N1PSCg2d367QJHhgPtu/
	7W8GozAx1Y/IYsUrUvUCbo0+48OJS1s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1036C60144;
	Thu, 15 Jan 2026 02:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4C2C4CEF7;
	Thu, 15 Jan 2026 02:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768444844;
	bh=kEIihbTO7hsA7HfHf64JRGq8WxboK1l9W0XcXEHbfeo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Vfb3gBTf+rsrpPAPcJ/Dig6SSOOLelLK4b09yec6FTVrBjTNJT3KBH/W/IuyCOUUG
	 rWCMabju6IaOer0i0XS9FstGNEW6IG96OZlxk9eDNmuYljuhHuOo2Q6G5GIosWUK/o
	 TtHClSrBGTI6P5GEFzOrr+RjoUt0V7nWJ0JUctS8=
Date: Wed, 14 Jan 2026 18:40:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>,
 <intel-xe@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, Zi Yan
 <ziy@nvidia.com>, Alistair Popple <apopple@nvidia.com>, adhavan Srinivasan
 <maddy@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>, Michael
 Ellerman <mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)"
 <chleroy@kernel.org>, Felix Kuehling <Felix.Kuehling@amd.com>, Alex Deucher
 <alexander.deucher@amd.com>, Christian =?UTF-8?B?S8O2bmln?=
 <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, Simona Vetter
 <simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann
 <tzimmermann@suse.de>, Lyude Paul <lyude@redhat.com>, Danilo Krummrich
 <dakr@kernel.org>, "David Hildenbrand" <david@kernel.org>, Oscar Salvador
 <osalvador@suse.de>, "Jason Gunthorpe" <jgg@ziepe.ca>, Leon Romanovsky
 <leon@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, "Balbir Singh"
 <balbirs@nvidia.com>, <linuxppc-dev@lists.ozlabs.org>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <amd-gfx@lists.freedesktop.org>, <nouveau@lists.freedesktop.org>,
 <linux-mm@kvack.org>, <linux-cxl@vger.kernel.org>
Subject: Re: [PATCH v5 1/5] mm/zone_device: Reinitialize large zone device
 private folios
Message-Id: <20260114184042.64fc3df3e43e6e62870bb705@linux-foundation.org>
In-Reply-To: <aWgr9Fp+0AeTu4zL@lstrano-desk.jf.intel.com>
References: <20260114192111.1267147-1-francois.dugast@intel.com>
	<20260114192111.1267147-2-francois.dugast@intel.com>
	<20260114134825.8bf1cb3e897c8e41c73dc8ae@linux-foundation.org>
	<aWgn/THidvOQf9n2@lstrano-desk.jf.intel.com>
	<aWgr9Fp+0AeTu4zL@lstrano-desk.jf.intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4g8umxk89tupxk4uassu4ssnmnoh7h1i
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B629E10000A
X-Rspam-User: 
X-HE-Tag: 1768444845-249687
X-HE-Meta: U2FsdGVkX19Ikpt5sAesYfLk7rgIoriZ08xJuA1nLFzQQNQJE77+NSa6E8rUuOehNKK/d04351R0iO1B4CoHi6xmpCx8JvDmZ2/ZeyRxLmLOXOaTJzKLXn7sTEXufsTEKuMK9IJuC2hiq/ehTIrrJ7M7SKvbDkou1/21TnrTjuzM9nuxILFaW+mgQSS7/5zUNdSnA5yM3n7XsZtpguhSVPwsqCtG3RDI5CVaaNf77wmCHfHBs8+x06OYrf3M7/4/NTEd2/IZEPb17WVnr10c3IRUncrMCXGPShLvM0hMfDcGwV44cmb9KARulteJaH5lDmdIz9wdwiMgeVllWbEdGtsszvyAsBpiIOxhJVrYbxYXYtoTe0FCukIeHo1BXOUNOQw+qS9PopMoo6zY582trERWufnu4r7IIZx8UncgybpOVtapd0JrIciOfnKae+keudnOVSUn4eKe6hDkXNB6Yurtizua47x2wF0LfhNLkPElmzuDoir5pMNX8eOULQjJc2dxFR2lrJbQ2oC/oOBh7eBROMVcEN3siovuxhS6/Gqvtxq8Qhw801WBIsKA+569k4VaoE5YhRUui8igjqV/HIemlpSt5WJXEKGXm5wdP0HN2BUQJVnHT/V8qctxr5anCDCd++EdJip9csQk3Rb9HiHXq93x/XpuYMidlFEatgBYPhjsi+nmrUHzRaQoH3UaGThSfwsmill6Q5z4RM9H6YmQ8IPp5HRG6zDS7X+NEi+8L8dcgtyPV1Fc3M2FBPVVBzgfDGSlKKK1etQF4Ca5t8W2NNa8bHEBUsdboLC1lVnh25vDyDjVEgpl1x9aK08vIrH0LwqqPB1dxe0D7oBH/eblOY5Hkjxj949zX/omFPwFSbc7G37u/h2CuVqqw1dct0o6tcMbtiu8jSbOeMMzWrLhxBlrx8ZCH763cmVwnfh1qI15YtL2uAONMJFvivCgiu8PVXYE20Bd/AeyfzU
 Xsm4c4by
 RV5IFjCb72rivqX563UMRBOgYxZfVuHxTtjPAyVGgIDf0Re2LEkNcQ9fRDpjQzQtfZgOZCZVVM+bw5WNfwSHfhQgtatVgPsDAhmRz9x7BGwGIwob6WSM0npBE/o6ISaTcBM77XCIFJPRsBFJ0WzVySGCJOCooj0yZyhWFHZqbLYj11RopkXQnq11PQ/Dkoa/7neiwPXTDilmpTTd2E1apFe0PUF5C1XagnwaGSRTqBnywfvyEu1rfAdOMJ4xmRI1qliNa9PTiIVfHBdO7vDf5BEUAn3PoPtKF6bGxnVVUy88WxfoJk7qfBAMycsLDY+zHI9J7cXoIGlVWD88Yn9SamlzvQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Jan 2026 15:51:16 -0800 Matthew Brost <matthew.brost@intel.com> wrote:

> On Wed, Jan 14, 2026 at 03:34:21PM -0800, Matthew Brost wrote:
> > On Wed, Jan 14, 2026 at 01:48:25PM -0800, Andrew Morton wrote:
> > > On Wed, 14 Jan 2026 20:19:52 +0100 Francois Dugast <francois.dugast@intel.com> wrote:
> > > 
> > > > Reinitialize metadata for large zone device private folios in
> > > > zone_device_page_init prior to creating a higher-order zone device
> > > > private folio. This step is necessary when the folio’s order changes
> > > > dynamically between zone_device_page_init calls to avoid building a
> > > > corrupt folio. As part of the metadata reinitialization, the dev_pagemap
> > > > must be passed in from the caller because the pgmap stored in the folio
> > > > page may have been overwritten with a compound head.
> > > 
> > > Thanks.  What are the worst-case userspace-visible effects of the bug?
> > 
> > If you reallocate a subset of pages from what was originally a large
> > device folio, the pgmap mapping becomes invalid because it was
> > overwritten by the compound head, and this can crash the kernel.
> > 
> > Alternatively, consider the case where the original folio had an order
> > of 9 and _nr_pages was set. If you then reallocate the folio plus one as
> 
> s/_nr_pages/the order was encoded the page flags.
> 
> ...
>
> s/best to have kernel/best to not have kernels
> 

Great, thanks.  I pasted all the above into the changelog to help
explain our reasons.  I'll retain the patch in mm-hotfixes, targeting
6.19-rcX.  The remainder of the series is DRM stuff, NotMyProblem.  I
assume that getting this into 6.19-rcX is helpful to DRM - if not, and
if taking this via the DRM tree is preferable then let's discuss.

Can reviewers please take a look at this reasonably promptly?


btw, this patch uses

+		struct folio *new_folio = (struct folio *)new_page;

Was page_folio() unsuitable?


