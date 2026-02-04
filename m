Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A4CBE95398
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 12:47:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20F7C6B0098; Wed,  4 Feb 2026 07:47:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E6FE6B00A8; Wed,  4 Feb 2026 07:47:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BC526B00A9; Wed,  4 Feb 2026 07:47:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED7BA6B0098
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 07:47:19 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 859C51B024E
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 12:47:19 +0000 (UTC)
X-FDA: 84406749798.09.3F2EA3A
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf18.hostedemail.com (Postfix) with ESMTP id B8BC31C0003
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 12:47:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=kcUIn6kl;
	spf=pass (imf18.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.178 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770209237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+U8LpVemtW+m+yu1KTxoehmwVgUgV8X5ud3ORfVCCrA=;
	b=tLp/y6LNl7P093rDjOpVRI9v8RypRwP68/tXaqY9txs3bn5dAn3OgEiSu8mS4JbrrIdAdh
	YJwuiaSRJqgL7zRui+mP0DHHghzbM0J+BqbIA0gy7W2PNAhYeGN7FgiNTvmcMnX2nI+aXo
	J3dMaoEof0bobVMbc44FgGRnhR1OrAA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770209237; a=rsa-sha256;
	cv=none;
	b=wi0lQUUH1QxTVh3LpDLH80kyo2cp7diQar43Fe+Y+w9irAPbDrYtImCVFekIum0IEUBO/8
	CL1kOT5Ry/uLbX+Sd8QDNP0kGGN/TR8X0HTOfmU0Nt3rCCkuGYxHzNuXop2dyIJfpmaWmJ
	YQdRFZ6dyaox9uypuBgMVLakWdIJ79A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=kcUIn6kl;
	spf=pass (imf18.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.178 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-50336cffef9so52628131cf.0
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 04:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1770209237; x=1770814037; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+U8LpVemtW+m+yu1KTxoehmwVgUgV8X5ud3ORfVCCrA=;
        b=kcUIn6klOexcSeXZahcCGq+q4T96+0wNun+Td7MApkgeW85cocEVTY1RrMgEd3S/XR
         eDyOAJ+cPW7UbcVU2v2Muh0JxT1dYSpGhyzVrT8XMB3ETg89yelrlv+naXakZlz9K200
         8vBxIPVIaMfpi8aecApQgi0cPULIfSulwHzyN8qjDxOwcLFGRwAj7D0RjO8EAyigcKUK
         NXPZqVu7r1uXK99vfBSMoeyTqtU7L2UmQDy/Bidg9UTIzvmRU0d2dtUbgUDbTCin+2vh
         4UV/dl2dbgjiIpiYcq5pCI0CWoNHGPo4ucFHKGa8y7bFBMlG471POjSnnEAoXTDua90t
         6yWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770209237; x=1770814037;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+U8LpVemtW+m+yu1KTxoehmwVgUgV8X5ud3ORfVCCrA=;
        b=US7xYeM7C6k2P/dLXgTB4zRH84KSeFO+dmSjAH8r1X6rbpONR9wsLqM0hLM0NUjetv
         gh4V2qDQOy5S5N0gXygf2354NDtU0x950jR+X4cJ9CPZeAWjHWiI9D9sIJOKW/IdMpLA
         LkGAZcMF5NW4WVPonLdi4Qwi376cNNLGDyLCBubzhf2Z5umI5MZJ1OrrZTLBtppjSNFe
         doXgjocc4FDUeNsYjWnYKnr+vbIaN/Tf7XwfjTC4SsyQ7SthnSP3TLdATYfuSnFXr+mM
         PmtS3GUwPriUV3Y/HzDJIGhX/YD3DmW+7QcQx1W5wgWuLisfi3g7GtmRVsKHlP3kAJzH
         MZPA==
X-Forwarded-Encrypted: i=1; AJvYcCWpMc04c6ELSYrxiXSUlcw5DTQBj1yUTnmpm07dZQo4842Yn1jjGBrq9yJaiU7DforZqr3vEvxxzw==@kvack.org
X-Gm-Message-State: AOJu0YzKRJFhC8/GNkFx9GjKfkPjZj3qB9xkCaLcHIx7DyQ2+GI0By42
	JxGw3YCr5uK6Rem6qSM14TLHGM/puvcLMKiNs+TWZyw781AzB4McO7YeHVstChfLqt0=
X-Gm-Gg: AZuq6aLdpYBqG9w/EpOvyNwOG7PpgnItyJ/23nepiOfaOBykOyeLsbo9oSuS54WWxid
	mIxcew7nrsyw7Hgg0zCw0P2O4GUerRpae/zMjTn7hOkrelI+BOM1Gbl+pIfltoYLc/CTPfD7q/W
	TW8ScOD6+IkDzBXQeYjRuPauxt6KmOJogKERjvqLXLZjkxPtaXTwdc/EBytUoGl7ILcyiIetv9Q
	e7+5VTIWlK/4LcgGIUzpym/bC124kmPrHtkOH9qQfo2I0CHE/3PQ2GB90vz80EwIEO1MrLOzb9K
	89/cCfFAnlBad+3LN1Zbp/761ZjMqhG33+XnD02h8cn6ayUPdBf3FSagmVmn32QgSoJca+Zt3zY
	mlgtjRF8XDr1bLOeLqLrOdBooNjuicwwN+HJaq81UUk4FAvbCizlykj6pMhK2F1HOJc3QHfvwCq
	4fl3hAe2OCc09ELjpcVSP55Iz4J9ao0SjmcFWr84buq3I/nCnglr2PcWIKOqkRteEJaZY=
X-Received: by 2002:ac8:7f4d:0:b0:4ee:5fc:43d9 with SMTP id d75a77b69052e-5061c0d57d6mr32950401cf.16.1770209236488;
        Wed, 04 Feb 2026 04:47:16 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5061c14815asm18573661cf.6.2026.02.04.04.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 04:47:15 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vncHr-0000000Gzio-1QmV;
	Wed, 04 Feb 2026 08:47:15 -0400
Date: Wed, 4 Feb 2026 08:47:15 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Xu Yilun <yilun.xu@linux.intel.com>
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
Message-ID: <20260204124715.GA2328995@ziepe.ca>
References: <cover.1760731772.git.ackerleytng@google.com>
 <071a3c6603809186e914fe5fed939edee4e11988.1760731772.git.ackerleytng@google.com>
 <07836b1d-d0d8-40f2-8f7b-7805beca31d0@amd.com>
 <CAEvNRgEuez=JbArRf2SApLAL0usv5-Q6q=nBPOFMHrHGaKAtMw@mail.gmail.com>
 <20260129003753.GZ1641016@ziepe.ca>
 <aXqx3_eE0rNh6nP0@google.com>
 <aYHGVQTF6RUs7r3g@yilunxu-OptiPlex-7050>
 <20260203181618.GY2328995@ziepe.ca>
 <aYLOZIZU0nwk+0UN@yilunxu-OptiPlex-7050>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYLOZIZU0nwk+0UN@yilunxu-OptiPlex-7050>
X-Rspamd-Queue-Id: B8BC31C0003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 6emo7g31ghe6x1bwfwrycoy6w1qnhsge
X-HE-Tag: 1770209237-3676
X-HE-Meta: U2FsdGVkX18wLOlHixLkN9nJbLq4li+i5fULeztex/5sagp64nTb95NcPpSqt98tMBnTWAnCS0nZN4XuUArYzA+5Jf/FAAGk6UU3Rl+e3k3mME96JpSsdE6K7VXB6tWpKPV1NTtAtVPFAxQdCY5cAs2ovXRAY7tLdKIwNgwZmPkGLUN+i4BgAynClyWyIiew0vMkIxD5QccJGCzC0BKiEFiGoEYZJAzSnmM7K2I/3Mqc648M5tZN+bqxuFJGcJYzZXB4AmBSRTuX6ojWW1FK/NNEzHBS8K/QtKXA3FLMoVWJJJxIgm2SAK+7Es6acoCq2DaqlSVn7aFfHMv9iwU0JGyxrOYs27fgflQOBHMWyvyvJPyuOkQQWt0Bqo9L3ohDi09axencjqIpmFmtQDLnePkuycz+Rqc14jdLoH2Wg98MWFxIa9jUezDm4ealqsaqXFEeOHC25Jum1LVV+ewER2qAiUUb/hJiaWLe/6PAMRCuo6pkieQ0jPJMioA3/9cLRwgUH4SS+6YXae/7vVYUSR+0ep0l6ycU1xAqwMG+3RzVefdQReWQO62nGbpbUFOw7lL6R+ZiPYc8NOnI0oHZBQbVlza7GfjI7XHDVbC1Ox9xhpi2dP9s7zY7HXczpRMvogzeilMIbmy0kDm7EcyyFzqloE3Pu1S4kLpSr8Nzjjps6IdxMXCTzDDGwlIPHblwOj4mFlVdbNCY0EcqkC+5Pppg2jMR2R2C3nt70qUxubcUuvVPxjDHLq7gE5PzXzLqLee+132QWH1KnbG0dYPbCciCQdaFG7XeNreBc07d38cru7LqdXQg/3ROoPCV9brA+AHxjpd7dpphydgo+GlLO6DQzxsXR71N7zC2lt0QqI/gG0TeaGiJOeOcGg+2KJFijTK9su7JnY5fVFLGi+f8BSUWf6XMAstY603MdcRCFo41pL+bcBGKURBPbcRZs7iD2QIC/UC7kvXvyQY4acr
 KjVXr9RK
 SoHd98JEIFd5IVpwVsWq4KjLDHDDExtv+YXyAA+DCoBp77EhexcCBwKKTVtMxHCC26nJol6LKoRLkXhjdWloqIfK7YmNdIjpnfQ5vpB4QKm2BDVc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 04, 2026 at 12:43:16PM +0800, Xu Yilun wrote:
> > Which means we need VFIO to know what they are, and hopefully it is
> > just static based on the TDISP reports..
> 
> I don't think VMM need to check TDISP report. The only special thing is
> the MSI-X mixed pages which can be figured out by standard PCI
> discovery.

Either that or follow along with the guests's choices on
shared/private.

We can't let VFIO mmap a private MMIO page, so it has to know which
pages are private at any moment, and it can't guess.

Jason

