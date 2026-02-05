Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C04E2E91287
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 07:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C5026B009D; Thu,  5 Feb 2026 02:23:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 073E86B009E; Thu,  5 Feb 2026 02:23:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE4B16B009F; Thu,  5 Feb 2026 02:23:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CCC2E6B009D
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 02:23:50 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9056F140402
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:23:50 +0000 (UTC)
X-FDA: 84409563420.02.575FB23
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0A480140002
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:23:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VYjDcr3x;
	spf=pass (imf09.hostedemail.com: domain of yilun.xu@linux.intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=yilun.xu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770276228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Hk694WXrry5fbSrFAvG80ABK+iq2sEw5lG4fv+F3pg=;
	b=4I3s/Sv7PFbzAOJVGBwaNC9bGQTHyvmeFIG3WwW7X5vwzC0UAiA5+uIfDyWvViNe/fZ4a2
	q7HOp68q6tBUt3V8Ye8McCwmAjVtNUN+Mpk+3BYMhFwRUvVvPuGmLsxFfse23BALzypsqX
	+CI/CqC8gAcgRHpSpLx21azUPGFIaTA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VYjDcr3x;
	spf=pass (imf09.hostedemail.com: domain of yilun.xu@linux.intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=yilun.xu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770276228; a=rsa-sha256;
	cv=none;
	b=pafIUiVqe632egYi2ySKzmSsxvIUpwBkio8a0PtTrWRlLULYS8jxPxCPdKJWQzEkQgqjiI
	bPratmBS4WeMr0HcpU1dOuXn0eBPCbBFN8zy8iii+Gmo3NyUmy7hZGbzMpVHNrVAgjG9B3
	ZtIPprf74+y6eYfFwcmjU00Q+XBfYKo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770276228; x=1801812228;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FgmZNaT1AJdOs3lof3+rnMI62Gul05tMmOYxnVyfbkM=;
  b=VYjDcr3x5+DFd7ZAKcn2QeYY1YWWcCbUsOKwMBUpBz4vvwn9XfQw9IHm
   WggexHTVcolIrJw3S7aMTSkJ07aEs6TapnKA9p6E86BRSyksOQ46+q2E8
   cxxDxqCh05coU/mIplx94/VB8IhS2YqI3ejg9JpKTuPLHqR4thFr9Enw6
   gNy2H5HEHG9qJrySIAzyQCoCVu/ZDBm+JvbqmFyx6bHG6wsX4P85S+ysn
   qT2NcVCC9mqH+x2Cp8kK1SsGthwUykJhD7ERVeNcih0i8GW1VZg1kGl+y
   OcErM0qVf213oZfwORKk4AFNfiExgcAYpgpPwhTlCXo7qtjXnrfp/kngB
   g==;
X-CSE-ConnectionGUID: vXEvR6jzR2ibnfZnPZF3AQ==
X-CSE-MsgGUID: PRVdfWoySw2wzZ3559wAAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="75322739"
X-IronPort-AV: E=Sophos;i="6.21,274,1763452800"; 
   d="scan'208";a="75322739"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2026 23:23:44 -0800
X-CSE-ConnectionGUID: w4M3nSSLQ/mBj1j0Il6KlQ==
X-CSE-MsgGUID: NkzCqGaoSdu69QFLY8HZpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,274,1763452800"; 
   d="scan'208";a="214913923"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa005.fm.intel.com with ESMTP; 04 Feb 2026 23:23:21 -0800
Date: Thu, 5 Feb 2026 15:04:48 +0800
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
Message-ID: <aYRBEJSan8eoT8xw@yilunxu-OptiPlex-7050>
References: <cover.1760731772.git.ackerleytng@google.com>
 <071a3c6603809186e914fe5fed939edee4e11988.1760731772.git.ackerleytng@google.com>
 <07836b1d-d0d8-40f2-8f7b-7805beca31d0@amd.com>
 <CAEvNRgEuez=JbArRf2SApLAL0usv5-Q6q=nBPOFMHrHGaKAtMw@mail.gmail.com>
 <20260129003753.GZ1641016@ziepe.ca>
 <aXqx3_eE0rNh6nP0@google.com>
 <aYHGVQTF6RUs7r3g@yilunxu-OptiPlex-7050>
 <20260203181618.GY2328995@ziepe.ca>
 <aYLOZIZU0nwk+0UN@yilunxu-OptiPlex-7050>
 <20260204124715.GA2328995@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204124715.GA2328995@ziepe.ca>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0A480140002
X-Stat-Signature: cparuqawbtmfmkkfzaw4bw1u3198sbyh
X-Rspam-User: 
X-HE-Tag: 1770276227-86163
X-HE-Meta: U2FsdGVkX1/wuIaVk6LKMAezO4ptrlyPDR1EXrC+GeNFubQSQ+dqEJ6rBPYAqxggQZYfRtanIyvV28ycRsUxW2rKElUBDIUzbpGHKsAMh0KGM6u+zwG2HleVi3B1UfZRMouN9fuq+GntSjrvz1diEg1tIb7/uhI1DFtlC9w8q3qM5DYiCSFOrkF7X7yVujzNkfVox8A2k8/0bcN/mnv82rnQJ6A7aaQNLUY9MmnDNJL6oq0PDMC0WBZGn2Xi4RQ0R7vbmYV7vNnUs2LuoEcvdOQHSQvVoAcRcT7GdavEdwlyD58M726M02g6CW2226IsD5ShStfM2SBo/onHhqfJjhS59UAbqBrFce6mfpoNpNNaDrZc5GV8bTt/WfZMis4SJ7lKRbq8nUx+JucxMVBgoqJyh8q9CAODwtj1dNbClvnRZXreL83T3CqXXLnzxCJbUsdLYAdVQkxZaj8ZqXr2qX2egqwka86AcecVnOLVR95V434lQMz+f4n4UMe8tyXW2k4mN8WGLl9fADZCpVf7OR4w0d5bLUz/IJtP4t4eel404VVNVPQKkHQfvmYGXciyHD+0UeTIaSyGZB2tK0ylMiNrBYXPQquup97Jvde51KFfmW3YoPARxdAsnG/53vytauQNMnhZ2re8riF44gvd+2AJg3hAMCMQdD5bHmX853VBsxJVrLO++zHXKUU8ifhRHCHTggQ4o774lqNy5quFxhhrQVQH2V72CoAvCqeuNEwJ+sBtB0u0PKaew46EKbcxu7LVC8HooU2s9Vsk6cHVmd1yFB8TCY1veNQGk2LkWVToiFspcyWLzCkE+bXofmMwCmbV5uxchqsTeMwqrdXL1Ol/4kj0G7rT10Im9dNJcToz+uwTQhdVwxxcSurSRGgvY0fQb9zkP2TO5eODfxHHEampYFcZXRD0F51qq8bx1Dwq56xYMsKG+2GZUBTHy5s1RVWDHz+hfVsipqml9BJ
 fTTk/I8R
 YQdxY241sR4rFct1BpvqtmbB1owbwr4EbdlaF8W6JKCeVgkrFLuGJko37preqY3J59qEOM9wUyrgJ3bWLwXxuEtrJDEBRAza/RzB5R9qROmo99YmSr02K4wLypT/680FjDqrXXX17ze/fLvhSUs1Nj4popRnjeZZw2ViFoFlHg2JP6MtgTYpfiht1+RbsLA9xvjouwZRSJKOgkW7VDl5DMERtEQKnaNGQPC6E2aHtZv+TCeDRlfBWKRFUYKh4/2CGkZCHF1jbV7yutYM+0hlMcq5Pd8wLNjlD161zfApczKgtjAvqD13t4Cw7PXGvIrtwMlNCiRRwgkiiptSeNMhtJE/PsWDHTqqRs/4T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 04, 2026 at 08:47:15AM -0400, Jason Gunthorpe wrote:
> On Wed, Feb 04, 2026 at 12:43:16PM +0800, Xu Yilun wrote:
> > > Which means we need VFIO to know what they are, and hopefully it is
> > > just static based on the TDISP reports..
> > 
> > I don't think VMM need to check TDISP report. The only special thing is
> > the MSI-X mixed pages which can be figured out by standard PCI
> > discovery.
> 
> Either that or follow along with the guests's choices on
> shared/private.
> 
> We can't let VFIO mmap a private MMIO page, so it has to know which
> pages are private at any moment, and it can't guess.

No we could only let VFIO mmap MMIO pages that need emulation (like this
MSI-X mixed page). MMIOs in such page cannot be assigned to guest so no
way to convert to private.

We don't allow VFIO mmap all asigned MMIO pages, no matter they will be
private or shared. They are assigned to guest, so host don't touch them.
Does that make sense?

> 
> Jason

