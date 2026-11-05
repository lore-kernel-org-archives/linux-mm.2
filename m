Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0DBF606A32E
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 16:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kqGX0Qru
Received: by kanga.kvack.org (Postfix)
	id 982646B05B0; Thu,  5 Nov 2026 11:20:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90C7A6B05B1; Thu,  5 Nov 2026 11:20:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D3446B05B2; Thu,  5 Nov 2026 11:20:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 45A506B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:20:09 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE22DA0AA9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:20:08 +0000 (UTC)
X-FDA: 85401577296.27.6CE43DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id B50E91A0006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:20:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kqGX0Qru;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of maz@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=maz@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793895606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rAfgYJb3CU0ZmVV1RZG4jgQB2Ko2DnWepqbK4ErMKrU=;
	b=H3TtiBro24kysLDYaKxmGQLiT0F7mR7uktn3mx3uxIUCURrkp6QfPbrjQKRBFDuUamwc4g
	MO5ViIsOhszgPFJ2lMOOi5qWI+B9SWar0s3sm56hcFyg+J3Za6jt2v5ErV8zjVslKW+3Z1
	8OiHFx2U5C8x+1HJNM34LxwiNTi/Feo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kqGX0Qru;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of maz@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=maz@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793895606;
	b=0jdgAYOZo5liyjjJBmKlQv9UjtTUlCHENxYKFVIsA9Fmr6U1knmUJDxYfkozthADTjvpgm
	QW/UEFQ9TS5YOBbvj0S6sme6DqNymcpFA3Ag4DteOg0wv/7p2yY1nnIEPUQxLVDdEsdZTu
	w3g7tMkKpDmVvbNuPcERzpapxoZw8QA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E449343C67;
	Thu,  5 Nov 2026 16:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B740A1F0093A;
	Thu,  5 Nov 2026 16:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793895605;
	bh=rAfgYJb3CU0ZmVV1RZG4jgQB2Ko2DnWepqbK4ErMKrU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=kqGX0Qru58U+OHeadfWAMb6N1IIP8ucW5R79h/yfRES/lFapRAfnom+jxQL2+D3KV
	 3VQbn8o338D9ZOjUnPRfSX9vx3or6dxyvJDRfb8uWtUPdtBR1YkqA8RDo+wLHUnYhD
	 SNKeQKf9n/HutLT2t0XYRKog0ysFPvZ1lye/wN0HCNBMvjQH3Fs6cJxkrYv8hOlO2P
	 fawYH0KgT3QqQvH5C6FRD45wGODhb3YMbpl9C6RamZcNoZb9DyM32ieGHf6D7TfVFm
	 AcKZwanrXLScxtreb6moYqjqIjr8iAVyG8uq0LOftKSGgBAYij0D4VGSlvcplT2XAz
	 3CU89qOPiF6Ow==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xP0C3-0000000BiuJ-000O;
	Thu, 05 Nov 2026 16:20:03 +0000
Date: Thu, 05 Nov 2026 16:20:01 +0000
Message-ID: <86zevn1c9a.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
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
In-Reply-To: <20261104164555.3555725-15-aneesh.kumar@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
	<20261104164555.3555725-15-aneesh.kumar@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B50E91A0006
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: cgbnqc58mswnm6u8sqg63ksxfstybpz8
X-HE-Tag: 1793895606-104165
X-HE-Meta: U2FsdGVkX1+2sNov+ljp2Sp8feGNTRVQgLmYSpzuJXtIkuCWWaGh3vUNvzpK/Wm/YWX+6+zzWmi9BEiAtIzQxv5aeCwEgU8+elhQqsgUW4XqXbc2f7bO7+qjAYjoJDS16vSr+LAkwMPrXZpghcMSNi2IOMIhbMw+BI3L+a1VFBzhd6naPD7XZlunJxYUvsl0ZjrlHX9tq0I8MOdXUl925PP0tY/JgELFNhgudPAwwdtsjCWGCMR4SJOcnmcG2D3Z6r9qHmwaIEL4Wixq42hRFBwLcTZ5Nh3Fo6mT/SXq5h1w/3jSCHHt6tG3hWqcWjYzR891cSKV6Xe6KLO/g+evmMSK2eh07vFSAWwr3Z34GtPAgSZ3VJ05b1PwdvQNB2/h3v5a4xNVvyUCO9R5QOMOyLkxsgeieElakfIf0di8Ia7S2HJi5VWSxO9sPUzYQhUn31bOBKpe9mxl/w3NXScr+GFV2/R/SqYSST9pFDgtqLshLwwFs0Z3XoFTk91vC6PrY3WKiIw3wk2i70WWUv/HcZgAQfYgP3c/E6+HySDVr7xiNnIH9IlIlUq9Iy4wRuKc+tkpIhFqBDyJWctnrtngpvGLRlG17Ww3cTqkitY+wTR5z3aWWbQLXRkT2pY8kJo1+GAKLmXtEVjjX3RUI7uELFrJVLemnqVQrbGCArC85Cmm7AMR6pgu+sYLWhbm1g/8sEDuZXgBhIo/K6EjRhTaxvnn/uIVcL3vUuM7anuO8F++5YgucJqtrrNJD5ptsTtR7T/ZwyOolbb/L7J4/FifbmIOrx+qnyTHwLLCmwUMUPad8nuWbBKdrroftDfJstmS8Ty1GQRtBgS0CGIEs+4uLlylyc0hNFavw2KtpTQo6z/cCDvDz/gPxC0mN1scNzvQZOMwePnGlW/4wZOf+ahk3+tAAem/YL5+2Mbg6UofQImrOKH+FmzIMf7x+bxwo51PD45BdyQ88qsH4d/gkT4
 m6ecw7gy
 +91HpvKO/rVdblCHwdKyCYNYdInFKoFyjHjDqq0s7UtYE68oMHCq/FfUYj2D4IfxPJ0cqSniqeuFuSvT3DJK+YdrfsvInfQoC4+/sssxfZjiCbV/HwyR/phMsC7zdauvUvtSIL7Kdw9iDl8IKtq5QpkSpZjMKjORozflipKDnON+dGBD/QRNOaUuGGyleaEw7gjrZNUFK8jSmym28J+iqPSMxTMsScw+jr1ECGsiMD7bB1mMY/8P9u2o4jPvO+gM8VnL7kbOtAjixLI8EsilGxNOuvsHYmfWrs+uhB6UCadIRjwp9ZSiTd++2Q3sNCFvlbXg0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 04 Nov 2026 16:45:55 +0000,
"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> wrote:
> 
> VPE L1 tables are allocated from the CPU-starting callback, where sleeping is
> not allowed.  Remove the page allocation from this atomic path.
> 
> Use a blocking allocation for the boot CPU and record the resulting table
> order.  Allocate a page of that order from the sleepable CPU hotplug prepare
> stage for each secondary CPU.  Consume the preallocated page only when the CPU
> cannot inherit an existing redistributor or ITS table.
> 
> Reclaim unused preallocations after the CPU reaches the online state, and from
> the prepare-state teardown when CPU bring-up aborts.

No. The way to do it is to move the ITS probing out of the
non-sleepable CPU hotplug path.

I proposed a potential hack at [1] (which I find far more palatable
than this proposal), but the real fix is to probe the ITSs as
devices. Putting even more ugly hacks on top of the existing PoS
driver is definitely not an acceptable outcome.

	M.

[1] https://lore.kernel.org/all/86tswrkrh4.wl-maz@kernel.org/

-- 
Without deviation from the norm, progress is not possible.

