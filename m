Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5F81E8B39B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 05:02:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E44E76B0005; Wed,  4 Feb 2026 00:02:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFC016B0089; Wed,  4 Feb 2026 00:02:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFA776B008A; Wed,  4 Feb 2026 00:02:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BD0296B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 00:02:17 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3CC0959031
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 05:02:17 +0000 (UTC)
X-FDA: 84405577914.17.C7815C6
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf17.hostedemail.com (Postfix) with ESMTP id ACDF740009
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 05:02:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LNVUFYYp;
	spf=pass (imf17.hostedemail.com: domain of yilun.xu@linux.intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=yilun.xu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770181335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tuo+6Gy8WeMFzFJhqHPF7dzcm0Gg6EFx2BZCrPQPs2I=;
	b=Etb9NPXZr/7pWZ7Juxo77Pze0qtMgu4qiCJStZhz/kG+ATeY44Nb9K8jZZc2qj/qsmsoBo
	Yvlk31z2JRSpXNRG+NV3PewP/8nMRxsjvt4wIYnVt6Ty9argyzgipkZrb91zRhvgl2Mi9Q
	ZFCSFgQd8W6NOOqzFeaY5k8Odedo7g8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LNVUFYYp;
	spf=pass (imf17.hostedemail.com: domain of yilun.xu@linux.intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=yilun.xu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770181335; a=rsa-sha256;
	cv=none;
	b=DPtQcnQHxdGtktvCOXxQyx7exYbqOJ0VrWnMFQ01vbfRROQtdWu2ZNL2/LoHMNP6TtW7Ot
	stqnd6EDha/+GAiPg+Aue+UID3TUnHzXCFgchssBtGDK2IR73J/5K6RGOgQ8u5Vc1jdE5h
	4kPOrWAhnfMWEhtV0fwNElhfwh+yY8U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770181335; x=1801717335;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BssClzJli42sqwnuhq7EEp2oGu8Z3L8cVPtpreDMGtc=;
  b=LNVUFYYpXipxbPXrbeAzCeiRTXyfYIeKTrRuLXrJnbS6eGCtVWa6CQ9K
   8B02HEL5D9ns0Kq9SqYqn+DRB/SAd8JfBrvn68ZLPTH6ywXjC60qFcNKm
   rvuFgCi/5XFS24OCMVbPlP6R/xKLDq3dg1Al7v5vWkmHMgJNkfMThHnJ+
   hkh2qfpzRNZAdSOcqy8appj2Ava8XaN7FADVtUT+zWqsHuqDlTbmKXWfT
   8uxi778PpmJ25bqYl8SxqI+1Gz0E2WXSIF1R504rUWDCARHRf4cOKoi9c
   oh3vNIadVXZoB0DW2Yzyp0mz0xrH/0D4sgFicSEtnFQPwrVE1iUQirNpF
   w==;
X-CSE-ConnectionGUID: 9BDKjFXPRIiZ4U3E0wVi+Q==
X-CSE-MsgGUID: Xo1PauLmQ6eM1kwRzhjXvA==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="71086396"
X-IronPort-AV: E=Sophos;i="6.21,272,1763452800"; 
   d="scan'208";a="71086396"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 21:02:13 -0800
X-CSE-ConnectionGUID: r6WIlB3hRYOB1WMvBCSX1g==
X-CSE-MsgGUID: 4L+xrWR+RMKF3IcyS644EA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,272,1763452800"; 
   d="scan'208";a="240739427"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa002.jf.intel.com with ESMTP; 03 Feb 2026 21:01:47 -0800
Date: Wed, 4 Feb 2026 12:43:16 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Sean Christopherson <seanjc@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Alexey Kardashevskiy <aik@amd.com>, cgroups@vger.kernel.org,
	kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, x86@kernel.org,
	akpm@linux-foundation.org, binbin.wu@linux.intel.com, bp@alien8.de,
	brauner@kernel.org, chao.p.peng@intel.com, chenhuacai@kernel.org,
	corbet@lwn.net, dave.hansen@intel.com, dave.hansen@linux.intel.com,
	david@redhat.com, dmatlack@google.com, erdemaktas@google.com,
	fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com,
	hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com,
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com,
	jack@suse.cz, james.morse@arm.com, jarkko@kernel.org,
	jgowans@amazon.com, jhubbard@nvidia.com, jroedel@suse.de,
	jthoughton@google.com, jun.miao@intel.com, kai.huang@intel.com,
	keirf@google.com, kent.overstreet@linux.dev,
	liam.merwick@oracle.com, maciej.wieczor-retman@intel.com,
	mail@maciej.szmigiero.name, maobibo@loongson.cn,
	mathieu.desnoyers@efficios.com, maz@kernel.org, mhiramat@kernel.org,
	mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com,
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au,
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es,
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com,
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com,
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz,
	qperret@google.com, richard.weiyang@gmail.com,
	rick.p.edgecombe@intel.com, rientjes@google.com,
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org,
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com,
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com,
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com,
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com,
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org,
	wyihan@google.com, xiaoyao.li@intel.com, yan.y.zhao@intel.com,
	yilun.xu@intel.com, yuzenghui@huawei.com, zhiquan1.li@intel.com
Subject: Re: [RFC PATCH v1 05/37] KVM: guest_memfd: Wire up
 kvm_get_memory_attributes() to per-gmem attributes
Message-ID: <aYLOZIZU0nwk+0UN@yilunxu-OptiPlex-7050>
References: <cover.1760731772.git.ackerleytng@google.com>
 <071a3c6603809186e914fe5fed939edee4e11988.1760731772.git.ackerleytng@google.com>
 <07836b1d-d0d8-40f2-8f7b-7805beca31d0@amd.com>
 <CAEvNRgEuez=JbArRf2SApLAL0usv5-Q6q=nBPOFMHrHGaKAtMw@mail.gmail.com>
 <20260129003753.GZ1641016@ziepe.ca>
 <aXqx3_eE0rNh6nP0@google.com>
 <aYHGVQTF6RUs7r3g@yilunxu-OptiPlex-7050>
 <20260203181618.GY2328995@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260203181618.GY2328995@ziepe.ca>
X-Stat-Signature: iuacne3x6pt4637jhdusrddmfe6s47pr
X-Rspamd-Queue-Id: ACDF740009
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770181334-21576
X-HE-Meta: U2FsdGVkX196PqvRSdSFKaztkbJ8SWxJd04O/KFb1AIBwo6cWr0kUDXScy0vfhs+Zt8x0yYMq/+w/xhnOWmW5YoUzmrdWbAJrogNs06Vodjartmv8MZU0K85PE/KhHmdvW6T+Bkz4WzmoO8Y2POdPWDBlp0lXZ8YTd7s1GovdZfldPDtnOu0WQOL8ZOLpGe3oEXF3GEQVbxPNXoH+ma4n1cDgNdFOJ2WmpDuqbvgS1vRqjKP2cE+yGlbLBDYmu6us59SEczucV3sobDgY/ii7F8Pon9gUE6mjcnNfvvQ8wcNgO4VNbnCdQNPhqLSmYAxObV1pFY2MWWA0p9VDjvSHrwvCoHgMHCAzU23Mm5upvkTswrnocxbu3EAPxIl7QRaFlDCF9tMV1ZoIf0h8jGZD57ZWs0x39/FJh5Ejdymwk0ovqQVIENgh04PR6Ipks8n/uMSQv3sYtCdrfKe7toY04lgOPOo+KIa2ZV8EUl7WA49rLyh9DB5Y4or5vbb5RN6Av+47VWJHR891eW9o7z6AWrhtnZXMGCoA+0O7G8+2+VB1aDH5KaOaHaoCR0Xd+hBRUSJTi196NvPcVnKXguxD0OzOIXXe9yppe3HKGgU1d91BjjBz+er17NQYMDGNsuVCSeNP3f5EmNua5E8Rs5QL0+OuGf6y7gjrFW2kRgZF95qvNdWq52xmQpaId22nCdGYLYF6zNv1PbQz1Vte/pMOyh78BJaItSlYKSTtZavlBfxyfuVpe+uPgJ/gL4qkcMMGY4ORsK1/qWJYl09hKdUMLSOt4OX5scQFxXMuzpPfnQW4NQnunaiOcM46dpgAmvwNWZz7mRrVTlXmrdCYwYIVbgdoO5UErv6bQTLNv80tRtrog+nBKkxk8QmIvKSV2dunfNEf8QYI4y0zADD0CgQg+QsYIMJlA32w4fjlgOwCdSYZQoW9d/2SFTD2JSs+kPYlujpBtJ9l8iLr5IeXEz
 blE5Yf54
 tl+s0P7lyUSc0Cfzpykw5fMBxrcJSnBSZMuuzXL+y/ESF0sOdrakTZ7+Srg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 02:16:18PM -0400, Jason Gunthorpe wrote:
> On Tue, Feb 03, 2026 at 05:56:37PM +0800, Xu Yilun wrote:
> > > +1.  For guest_memfd, we initially defined per-VM memory attributes to track
> > > private vs. shared.  But as Ackerley noted, we are in the process of deprecating
> > > that support, e.g. by making it incompatible with various guest_memfd features,
> > > in favor of having each guest_memfd instance track the state of a given page.
> > > 
> > > The original guest_memfd design was that it would _only_ hold private pages, and
> > > so tracking private vs. shared in guest_memfd didn't make any sense.  As we've
> > > pivoted to in-place conversion, tracking private vs. shared in the guest_memfd
> > > has basically become mandatory.  We could maaaaaybe make it work with per-VM
> > > attributes, but it would be insanely complex.
> > > 
> > > For a dmabuf fd, the story is the same as guest_memfd.  Unless private vs. shared
> > > is all or nothing, and can never change, then the only entity that can track that
> > > info is the owner of the dmabuf.  And even if the private vs. shared attributes
> > > are constant, tracking it external to KVM makes sense, because then the provider
> > > can simply hardcode %true/%false.  
> > 
> > For CoCo-VM and Tee-IO, I'm wondering if host or KVM has to maintain
> > the private/shared attribute for "assigned MMIO". I'm not naming them
> > "host MMIO" cause unlike RAM host never needs to access them, either in
> > private manner or shared manner.
> > 
> > Traditionally, host maps these MMIOs only because KVM needs HVA->HPA
> > mapping to find pfn and setup KVM MMU.
> 
> This is not actually completely true, the host mapping still ends up
> being used by KVM if it happens to trap and emulate a MMIO touching
> instruction.
> 
> It really shouldn't do this, but there is a whole set of complex
> machinery in KVM and qemu to handle this case.
> 
> For example if the MSI-X window is not properly aligned then you have
> some MMIO that is trapped and must be reflected to real HW.

In this case, the affected pages are not assigned MMIOs and KVM won't
import them. Mapping them is just OK.

> 
> So the sharable parts of the BAR should still end up being mmaped into
> userspace, I think.

This does mean we can't make VFIO totally unmappable. But VFIO can still
try to create unmappable dmabufs for assigned MMIO regions, fail dmabuf
creation or fail mmap() based on the addresses.

> 
> Which means we need VFIO to know what they are, and hopefully it is
> just static based on the TDISP reports..

I don't think VMM need to check TDISP report. The only special thing is
the MSI-X mixed pages which can be figured out by standard PCI
discovery.

Seems this doesn't impact the idea that KVM needs no implication of
Private/Shared from VFIO, as long as VFIO keeps exported dmabufs
unmapped.

