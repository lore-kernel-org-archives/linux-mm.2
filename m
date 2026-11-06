Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE87B606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 15:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NHfHZnPS
Received: by kanga.kvack.org (Postfix)
	id E839F6B05B5; Fri,  6 Nov 2026 10:45:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5B096B05B9; Fri,  6 Nov 2026 10:45:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D71BC6B05BA; Fri,  6 Nov 2026 10:45:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B58526B05B5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:45:53 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4293EA0D86
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:45:53 +0000 (UTC)
X-FDA: 85405119786.20.0B4A80D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 92D081A0002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:45:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NHfHZnPS;
	spf=pass (imf19.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793979951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sf7jpXPq+wp6SBfVuD5VhfW8K2K7PrL3pzRu30lk/Qs=;
	b=ryjAtOlY2rV+5OMWZp9Dv0+e7JyEiwppheDzykqqbptv75cfYi0F+u8Hey3U9as6njUsLs
	lNRNBDJ2nJ1O5WWkU0HfBUf3YtRKG0glexcQhoumfXVu9X0O4FYNI3+I6Ffm3eyl/N1TcX
	7gdOx1kAO2Y7NfOX86WM0OvA6eJPYXo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793979951;
	b=qwuc2ClKgwZVxjiIl5oKeqVBYVmF6ibEjwWN8mR8U8IcOsNU0r5duVpWSMhyiexmMAf4wI
	RTfB+dvT8SN/6ENRsvnSEru+Cbut4e/rDlUffjn1HqeQKJM6T/B2dm3mzVT7A3U37lGtwE
	KugryFzk194mnF3oiOYHMWgF1/8s4Cw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NHfHZnPS;
	spf=pass (imf19.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C680640784;
	Fri,  6 Nov 2026 15:45:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1B21F008A1;
	Fri,  6 Nov 2026 15:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793979950;
	bh=Sf7jpXPq+wp6SBfVuD5VhfW8K2K7PrL3pzRu30lk/Qs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=NHfHZnPSDSHLthC28xmc7Tynk3g3EuBVtAtF3YePrjls2avEgiFGihXMqKalL6SYK
	 SeJfbKbhS1SHWhGP9tCN6jALT7jREvu0x9m17dhcE0oLL42alVk0H4Ve6UWnQsZ17V
	 pOd3zRki1UcQZ29EAFK0E5v9T4pzWtOa2Z1QlBdeIUapAvd2pzBNLlIfkVE6aLRurr
	 uq5rcOkbHr9280TJ3ts+7TSC30ovRao2lHyLtEiO9tHldNoUeF0owFJmmy9pFG8jCG
	 5cQRmxsKh588fJfaFewhWE1XgoaoMSVyjoOt6yV+WAzO5GfLn/FYQd7wPywABOqUIP
	 iCRRMFk+OTbyQ==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-coco@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	kvmarm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH v9 14/14] irqchip/gic-v3-its: Preallocate VPE L1 tables
In-Reply-To: <86zevn1c9a.wl-maz@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
 <20261104164555.3555725-15-aneesh.kumar@kernel.org>
 <86zevn1c9a.wl-maz@kernel.org>
Date: Fri, 06 Nov 2026 21:15:29 +0530
Message-ID: <yq5ah5huoteu.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: n4to3gcxnkmifp5naxmz9i15sqwm8yaf
X-Rspamd-Queue-Id: 92D081A0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793979951-117557
X-HE-Meta: U2FsdGVkX18bBvxR3zjdq5h/4AJVZVcUXhEnR6ROuHEGmjYPq1WIVm0TkdhnQXsAwmaT5jQWpjURULI8UE+PGJMyL0jeojxqcG5QlCW88ZUCfk/83jzxzHNP9ODyOVTj1XXLF3d9BLbJEgK7BE7pVn1DIoKri32pqLZVI2fNQO6y87foxNpJkqAzhBdbDSZ6/Yb8z2GE1C+ry1Ro4Qr5Di5FTortzpBNXWfJQ7RSQgW5kAVs2z9nSag7ZUAn4WUfNiLghiqtGxn41mYyxa+SsQabK9Sw+SO1oghiqJDkUAHcxNyZb2RX6pVJXzYfbUyxQr8lJf8FFKqSTkHfb4PRUF/c+7weO9MojlJRVfVWhTgrrZX6wSjfIKYqu1K8ZeBrqa0rdkEx7RkVOAkdkmzUVId3MMaKVEK7mlTGVni87Dgah/hMMM6agxsBKIgGNV2azzItjAWn+Wfgmitc6Lvrq8VotGbXKALCv+77W2YxOj5mLvtfOAEMYpBSCOMzcW6SDNmqYEcbmdXYMsOLcEdBwLD8K5fafq6Cyul/Pir3/T6ooYZ9wJ4Ufm1Pl8xxR7XPGD14IERpJC88WwDMrBfhUA5cVPl+kT+9/2hx9N7Sum4z6xxULwKCS+vxPaGmiOC4Y+x9t6N2hGHULELaHpDG6ac8tLozFbpMcEY7NjnJNQGmOLx5rQTkjRJ0jp8Rz2VUaljCJS9hx7RJ/OmS7nRTyuE9kjR8omHmkGCVvHL5NDtxGFb3ar5Az+5qUx+d3wc2YZm66FnSEVxokouu6M1p78C9Cw/6OelyDslkJJom/VWQ6WUHBIF5My7HJJnS09FHbyVBd7PffDjZPhiA2Anp2gt+LDNI4rVQp7RmZ6hLZ6HPl3SWfJ3NG5cBtQzR3MmMdU+/IrNCbEurMJ6Rg5y0Os2pUUaDWPBKSJiS8VZgacoFx+0m89P3eBm0MIbXJV/8N9aLz/LtgS5gvI3n/9k
 W9RTWnHP
 ko5r+QuGruQ0pyADxYZRPjkRW4KYWHdISeIML72FTm3cBF1giR9bXH7PMrpw+aCjmM1syjeuz8BO47B8LFAF6MzcLXF1irTfzI/u4uJ9Hvw3cqRsjRhE24VqeGkkAMKmoM85rnlYVyQXkIBFTrxEQYWimsna30Bx+cXqc1jRydlfzuQnFFbk2wjfn6BW5QJL8/TdKb6ZXe1qtK9mK1PxDvZTA0EPydgKgWwIzAY5KMfE7LIk9JccLS+LYcGMSpEdX/f/Uo7kcd9nkhrnanakHn5+SVWoIFJAzp7J9kVag+PTXxxQXsyPDM82u/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Marc Zyngier <maz@kernel.org> writes:

> On Wed, 04 Nov 2026 16:45:55 +0000,
> "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> wrote:
>> 
>> VPE L1 tables are allocated from the CPU-starting callback, where sleeping is
>> not allowed.  Remove the page allocation from this atomic path.
>> 
>> Use a blocking allocation for the boot CPU and record the resulting table
>> order.  Allocate a page of that order from the sleepable CPU hotplug prepare
>> stage for each secondary CPU.  Consume the preallocated page only when the CPU
>> cannot inherit an existing redistributor or ITS table.
>> 
>> Reclaim unused preallocations after the CPU reaches the online state, and from
>> the prepare-state teardown when CPU bring-up aborts.
>
> No. The way to do it is to move the ITS probing out of the
> non-sleepable CPU hotplug path.
>
> I proposed a potential hack at [1] (which I find far more palatable
> than this proposal), but the real fix is to probe the ITSs as
> devices.
>

Could you share a bit more detail on what you have in mind?

Are you suggesting that we create a platform device for each ITS and
initialize it through the driver's probe callback, while the rest of the
GIC initialization stays in the existing early boot path?

Would that mean the main GIC is operational during early boot, while
ITS-dependent features, such as MSI delivery and direct injection, become
available after the ITS devices probe?

Is that the split you have in mind?

-aneesh

