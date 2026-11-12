Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC3A3606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 22:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KkJPMBad
Received: by kanga.kvack.org (Postfix)
	id CE93A6B05F7; Thu, 12 Nov 2026 17:19:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC0706B05FE; Thu, 12 Nov 2026 17:19:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAF1F6B0603; Thu, 12 Nov 2026 17:19:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 96C326B05F7
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:19:44 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 31DFB1A1CB3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:19:44 +0000 (UTC)
X-FDA: 85427885088.06.B48F737
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 52C8E80004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:19:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KkJPMBad;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of maz@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=maz@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794521982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MdFOkR9T1vyvJTEbm/GmyrakOZfYhcZ9ZgO9mPMwqgE=;
	b=2K9U+6VubagL6WLTZXdE9wsuI7X2sSqzuAzeo2g9U+h/UPRIFi321DdioBv8+4I7IB7fpD
	LN5b2+FrMjOKsbOKMkLczz5qUGW4RxlLfqCkUH1TJ0i2OXo+QEI11A7JW+yUDtJjOIG9QX
	UK72Mot8GdMgGRxUg44deitO6vU+HyQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794521982;
	b=CUeIDvaTubqsHr8zEFH496G8Kjb70fhRHGs62uBgWD0YPfn0kWk+yDu70dW4RhVNQTZ5Cd
	CwYldYhtLIGFzYD9rhHWg8Zue9hwhEXBKEISfYJqnc5YZToedjsI5YnXaAVjQ/gubzKhK1
	ZFAfWN/jfmbSvMY4JwGTAi5zUFnrrMI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KkJPMBad;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of maz@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=maz@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 62DEC4376C;
	Thu, 12 Nov 2026 22:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A31C1F000C4;
	Thu, 12 Nov 2026 22:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794521981;
	bh=MdFOkR9T1vyvJTEbm/GmyrakOZfYhcZ9ZgO9mPMwqgE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=KkJPMBadtLEVv4ypOglQwOiufTUuvQXpZInKdUsDfVLX5m16RASaLRZGF3Pfpwq5k
	 Z3l76XFR6I6l2Ruv8Kj3Nwk4AFyFkGuK9xYfnJeQQTscKJVWq3zctGaoNQdWQbyQZM
	 JTfhw6EKmkNKKAx4UaeNOGU3vdAc9pBpcDvKS3OVMw3C+ZTuYa3o9nolv7dXk4a7kM
	 FNCFi6+G/UdRgo8wHU+FMyG3JGJMXBoJe6ln/FqhEDt8uoLumgEFgCtVUE6ufwZEUz
	 22ZFh7iknY4Ssw62qkkSZGpWu/c5KtAOmDmY1R2c/TjcUPFbtZo/AbBjdVW5PwfokN
	 nqgy8nw1bs8qA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=lobster-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xRd8r-0000000F2ee-31UM;
	Thu, 12 Nov 2026 22:19:38 +0000
Date: Thu, 12 Nov 2026 22:22:52 +0000
Message-ID: <87ld6x8zb7.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev,	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,	Mike Rapoport <rppt@kernel.org>,	Pasha
 Tatashin <pasha.tatashin@soleen.com>,	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,	Christian =?UTF-8?B?S8O2bmln?=
 <christian.koenig@amd.com>,	Jason Gunthorpe <jgg@ziepe.ca>,	Joerg Roedel
 <joro@8bytes.org>,	Marek Szyprowski <m.szyprowski@samsung.com>,	Robin
 Murphy <robin.murphy@arm.com>,	Steven Price <steven.price@arm.com>,	Sumit
 Semwal <sumit.semwal@linaro.org>,	Suzuki K Poulose
 <suzuki.poulose@arm.com>,	Thomas Gleixner <tglx@kernel.org>,	Will Deacon
 <will@kernel.org>,	Russell King <linux@armlinux.org.uk>,	Benjamin Gaignard
 <benjamin.gaignard@collabora.com>,	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,	Mark Rutland <mark.rutland@arm.com>,	Radu
 Rendec <radu@rendec.net>,	"T.J. Mercier" <tjmercier@google.com>,	Madhavan
 Srinivasan <maddy@linux.ibm.com>,	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,	Shrikanth Hegde
 <sshegde@linux.ibm.com>,	Alexander Gordeev <agordeev@linux.ibm.com>,	Gerald
 Schaefer <gerald.schaefer@linux.ibm.com>,	Heiko Carstens
 <hca@linux.ibm.com>,	Vasily Gorbik <gor@linux.ibm.com>,	Christian
 Borntraeger <borntraeger@linux.ibm.com>,	Sven Schnelle
 <svens@linux.ibm.com>,	Ingo Molnar <mingo@redhat.com>,	Borislav Petkov
 <bp@alien8.de>,	Dave Hansen <dave.hansen@linux.intel.com>,	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,	Kiryl Shutsemau <kas@kernel.org>,	Rick
 Edgecombe <rick.p.edgecombe@intel.com>,	"K . Y . Srinivasan"
 <kys@microsoft.com>,	Haiyang Zhang <haiyangz@microsoft.com>,	Wei Liu
 <wei.liu@kernel.org>,	Dexuan Cui <decui@microsoft.com>,	Long Li
 <longli@microsoft.com>,	Paolo Bonzini <pbonzini@redhat.com>,	Vitaly
 Kuznetsov <vkuznets@redhat.com>,	Andy Lutomirski <luto@kernel.org>,	Peter
 Zijlstra <peterz@infradead.org>,	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org,	linux-media@vger.kernel.org,
	linux-mm@kvack.org,	kvmarm@lists.linux.dev,	patches@lists.linux.dev
Subject: Re: [PATCH v9 14/14] irqchip/gic-v3-its: Preallocate VPE L1 tables
In-Reply-To: <yq5ah5huoteu.fsf@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
	<20261104164555.3555725-15-aneesh.kumar@kernel.org>
	<86zevn1c9a.wl-maz@kernel.org>
	<yq5ah5huoteu.fsf@kernel.org>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/30.1
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: aneesh.kumar@kernel.org, linux-coco@lists.linux.dev, akpm@linux-foundation.org, baoquan.he@linux.dev, rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, catalin.marinas@arm.com, christian.koenig@amd.com, jgg@ziepe.ca, joro@8bytes.org, m.szyprowski@samsung.com, robin.murphy@arm.com, steven.price@arm.com, sumit.semwal@linaro.org, suzuki.poulose@arm.com, tglx@kernel.org, will@kernel.org, linux@armlinux.org.uk, benjamin.gaignard@collabora.com, Brian.Starkey@arm.com, jstultz@google.com, mark.rutland@arm.com, radu@rendec.net, tjmercier@google.com, maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, chleroy@kernel.org, ritesh.list@gmail.com, sshegde@linux.ibm.com, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com, mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, kas@kernel.org, rick.p.edgecombe@intel.com, kys@mi
 crosoft.
 com, haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com, longli@microsoft.com, pbonzini@redhat.com, vkuznets@redhat.com, luto@kernel.org, peterz@infradead.org, dri-devel@lists.freedesktop.org, iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, patches@lists.linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Stat-Signature: 75tkoqeagywdbwpwyz59rpu6hgw3qbzm
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 52C8E80004
X-HE-Tag: 1794521982-8557
X-HE-Meta: U2FsdGVkX1+pR2Xm6PyX5SaiW+cCVq65NoyMrRgAUdlOwmAD1Qhbj9LX+7Io0ZtSpWpPZJCC8V+SzXFwPNFael2jBhYwhP+15oHz0fZdyBdjAdhHAWCdIdM2gmoiRtL0cJXcZQ9HLy/Lg389XO5k+OYl3UWHQ6YUh86KP3kjCDasstGYotm9XGmsO7VKdOIOnv9cK0AhiyOJrTqYJZgSjEHUEQX4Ph3b8FSb+S/18DtUcra+j3sXOKtoAYdbqkTkymhIVxjFh9QGBs3wmwEh3r3EzlDRefqKHl/goAxPQUCiPff5AP2BtWxc0IwNIp6gG3T8EOCgrL7iUeJXX9qFcF0VvjjQepB4CUOMUnMcBuTZ6QXFBnYqsgJQv2JX9/cyaAUFmiK9pN9nj7dFpNpVwQrThi5Z3+ly/8voUSIEFkEO2MzZT7bV9+OYZ7HeZpVPk+qIIc3OTJ4TBBguQOxZru8+sGCsYnfiQgHk5HfDXvxTmFcdJCyOOhSPF6mqONtGwAaZFLzoXZxjCMsV0TeAGYO69iKRGheGsV/eUGjdcupDP1Vu/tetiF+Ab01GS9i5uGeDYk9zNd0bWEajpDka+tPCZjjvGVJbzO2qbXtlQlNUGw03n7YzZfEg5GL6F8VkfdWQtOcEK2Goh8n4kPeALBl5VPtf+KKBy2eptT8hmvDRFBq44s4Ec8Gkwz+E3ELPhYhh5OqMFxDo5voKBuDD/oP7CwdIHF7YmTm003W1A2MWqVpX1MpYWRiJSWgDAV0nk3GJ7PVKokv1w9u7Y3myVn5nUjcy+4+0PYoWU/POC86XGtURrUUHvp9AHO9Hl3Q4HKz+Wb128RLr4u/sUq9RvNWqjcDwZR2zb8fOUPPMkmb98D2MY8QjuopsLb0Ej9h0eBtqzrZX59HkINWWq8AK5+tAQ2yGLAy5xOFLh7uSoNgK7X464aSVeBeqHHwK9s+GyhyEZtRMuFmwlYawjvI
 OtQvIDRC
 CV1jejqZEbvM4ZLX2NwuI0o3Z6H7rBVrJxdtFaZnEqsb59dC8zzabGAnMEdI6D6jh13TxAqIIA7potZz9NJQQJuatcYXmbar2F73Ih1GVWyRvo58QtOMSIXMU/MocfbRV5UUBzKnZg7Iwcqz80ef7OOhzoxHhqiMYsOioDmtzmuU9foejXQzhu5F88PFkU3TXzMIcZTLx5b/GZU6e3Mw8+OZuhJz1Z7LFiYscn+1UNC/NuuzYCg5dkY5n8VBo1qKcUHzoAlK5IS6NV8qO1DkgjfxJRcPYB7z/kNUsNQtHAQWzfBE27teVnMSfm+xiKzFK5olN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 06 Nov 2026 15:45:29 +0000,
Aneesh Kumar K.V <aneesh.kumar@kernel.org> wrote:
> 
> Marc Zyngier <maz@kernel.org> writes:
> 
> > On Wed, 04 Nov 2026 16:45:55 +0000,
> > "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> wrote:
> >> 
> >> VPE L1 tables are allocated from the CPU-starting callback, where sleeping is
> >> not allowed.  Remove the page allocation from this atomic path.
> >> 
> >> Use a blocking allocation for the boot CPU and record the resulting table
> >> order.  Allocate a page of that order from the sleepable CPU hotplug prepare
> >> stage for each secondary CPU.  Consume the preallocated page only when the CPU
> >> cannot inherit an existing redistributor or ITS table.
> >> 
> >> Reclaim unused preallocations after the CPU reaches the online state, and from
> >> the prepare-state teardown when CPU bring-up aborts.
> >
> > No. The way to do it is to move the ITS probing out of the
> > non-sleepable CPU hotplug path.
> >
> > I proposed a potential hack at [1] (which I find far more palatable
> > than this proposal), but the real fix is to probe the ITSs as
> > devices.
> >
> 
> Could you share a bit more detail on what you have in mind?
> 
> Are you suggesting that we create a platform device for each ITS and
> initialize it through the driver's probe callback, while the rest of the
> GIC initialization stays in the existing early boot path?
> 
> Would that mean the main GIC is operational during early boot, while
> ITS-dependent features, such as MSI delivery and direct injection, become
> available after the ITS devices probe?
> 
> Is that the split you have in mind?

Yes. Then once this is done, all the tables become normal DMA
allocations, for which there should already be adequate support.

	M.

-- 
Jazz isn't dead. It just smells funny.

