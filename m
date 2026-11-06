Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2DA7606A32C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 15:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=HoIuxL1I
Received: by kanga.kvack.org (Postfix)
	id 917156B05B7; Fri,  6 Nov 2026 10:34:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C7906B05B9; Fri,  6 Nov 2026 10:34:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78F016B05BA; Fri,  6 Nov 2026 10:34:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42E636B05B7
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:34:37 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C1D8FA8DA0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:34:36 +0000 (UTC)
X-FDA: 85405091352.17.F3504CB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8048B160014
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:34:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HoIuxL1I;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793979275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uj6b08bxBrGPMBQHtFI05sMh6Xoy8ejNAgMPUPWV1BQ=;
	b=mtOjAdgHBzb1XkIa1+4bmwzM7X/fGvDrXRWSaBwCiwMnIx66A3tNddUUJ+u/a+eXGgPeey
	u7XtMyaFYJqQx2qWhpi+ZOPlBpkiwZr1GCL5xfCJ6n4g/Dgn7T5SPF/Cal6icnIiQNIn8K
	nMrd+6S3/bdsw+k+vKEZl3SAKLuKGbE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HoIuxL1I;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793979275;
	b=clz00Owbrrcjyc66q4J9Z7E6wAg2383Hw0SI1sPBmYp3dUKiVGREl+a7ggbxh2keQiE7v7
	P5HBjnHnpcL/er1DiekyZX464LFnLWe+dA8Gj/Hcz8pRBBLU+4DNx+cU0BrlTL2rx+xMf0
	dj3cilY90PbX74x8o+CcUAvIaa6N1Vk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1F8F71650;
	Fri,  6 Nov 2026 07:34:30 -0800 (PST)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2B6803F632;
	Fri,  6 Nov 2026 07:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793979273; bh=kbtuYZHukFIc3XIsRQp6dsFZOem1VpVxmEcgHFZmqd0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HoIuxL1ItDLUGlcavjNXD/JxrmPk3WBhtY7TT2qM8F45c/7Q3yyjSI+pQ153K1fb0
	 YXClJGmCHDlVOTNxhr9aTezROBBizZumSyroGckV652hcFVqpuVFnjin2TJWlbTvqZ
	 Bx38XYVnikraEyti5l13jjcvEmncaKF99Gps4Xng=
Message-ID: <397b7702-ae85-472b-909e-05b3c4135c61@arm.com>
Date: Fri, 6 Nov 2026 15:34:23 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 01/14] mm: Add an allocator for CoCo shared memory
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, linux-coco@lists.linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
 Marc Zyngier <maz@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Steven Price <steven.price@arm.com>,
 Sumit Semwal <sumit.semwal@linaro.org>, Thomas Gleixner <tglx@kernel.org>,
 Will Deacon <will@kernel.org>, Russell King <linux@armlinux.org.uk>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 Mark Rutland <mark.rutland@arm.com>, Radu Rendec <radu@rendec.net>,
 "T.J. Mercier" <tjmercier@google.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>, Ritesh Harjani
 <ritesh.list@gmail.com>, Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
 Kiryl Shutsemau <kas@kernel.org>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>, "K . Y . Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
 linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
 linux-media@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev,
 patches@lists.linux.dev
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
 <20261104164555.3555725-2-aneesh.kumar@kernel.org>
 <2e448ac1-7b4f-4d45-90db-dfe9dc5ad329@arm.com> <yq5ald76ou4m.fsf@kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <yq5ald76ou4m.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8048B160014
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 56xrc15qa8cmwjwdfhy4amujn9ypu67e
X-HE-Tag: 1793979274-461406
X-HE-Meta: U2FsdGVkX1/eVUutA95TfE5RKQxNm3YcgT8RbTxQ+RUaUvh6SO32KL6+u3Pnaz7VHAhpdWM3HSsY5wmVVX1somoBEByfemDfYoNV+8yZeKxIFTqfQryfMofyj5fsVJ5MJ9OKsRISYTlMwZQDru8nX6s59cDV87lN6z0cFHNUhfwKfeuopuPTlDsnY+U+q3pZZFji7Cb2PH+Q6cmA/FjsjEhXs/Rs2Zc5malSOJUoFZar+54p2ssIoDAijb388WWNduiBvKDkCk47FgtdjEYdNOKv22KUSHNzzLCdaKsguBGj7szt6wO/ALLoTo6R4x30t6QHJwetz3BGOYUjt2CVYVpkIaHajKT7Qxjnu7RLMPgk1j5LFVQaDmarY3P/A/tfTubeLrNPT4P4gIjlVjyruR7NQKiaU7aK1u/3hnNzBOtRX4kgaupFy11l+KM62SGzxpENdbOjzI26RnJhiaJWlZW6skCqQyGGSuC4Q42ywnAYoanxozSBXBZNadEITY5UpV+SkVbRPh6sQw0dCsnZweZkSL50B8bUvQk8TXz3ebEzeBjSns2rjyzjzw631BmI1RmFnabwXkyA8IXd4zJ66AfPCslb9H3gRJtkjQomn/5thUFSOjPaQffK/ROETFEh9Y5h2MAsKU/5Vv0xxXQwW/mtk2KLGh+dX2362vS4kEiWcRcNjxfuX6DxKaTbfNJvmxxXtU4DmWe4NaqB0szDyGmdNSgn3neG2DcqDRFi6HrVA6tHv9nBnjbTFbt892ZGXv19N8rreoW3dqLT1dnMMNSj+UPfO1V1nnWlBnTZU+dDs/Qn2KXLkt/r5ZX6arkzyvxhdo/WPeQaF+Y7XX9wjpPgBhLV4o8+MNMZqZsjEoQ87YtubZBrRuHTw4WGrn0DQAf3tzJMo1EHP2nz5DTFkDHIIVls1S9vjPUTQAvdAojXJxSQWi6rpeEjoJmKcxvZJoAqFLIW7YcaJ9whJzc
 sBekYQCQ
 B+l73oCITc1K28+jNke4PhrUYQ44P1q4ZkKcvIrLJ76JWYWzLiXDici9JJ1fEmYw05ZyXZVd85ZVpzqalsXouBYRaoFJ7+XjKg03fR9vvHDk9M8nFrYqmQ4N0Q54kQhyFDKIwCZVk2EAn0mv2iTVjUGw52VkAT6aLwi5CE6KJUS73WypLuikb07V5rWgmiGYowII5vMdeoWUJuNT4MosePoj9Itdtyutmng73BfLjZoCzLU1dMnsdpINidYc1yh4a44WEo4jJqt617sGgkCikNPwAKr3CMGnlA8BD9bDSfmMF2GsY8e3zDipx+TtuuwvWYhFZM/5AXL0lzZs0cDtoWuuGvtGfydMQqgXdQWX1JsH+csg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 06/11/2026 15:30, Aneesh Kumar K.V wrote:
> Suzuki K Poulose <suzuki.poulose@arm.com> writes:
> 
>> On 04/11/2026 16:45, Aneesh Kumar K.V (Arm) wrote:
>>> Confidential-computing guests may require memory shared with the host to
>>> be aligned and transitioned in units larger than PAGE_SIZE. Several DMA
>>> users need struct page-backed allocations satisfying these requirements.
>>> Provide a common allocator instead of requiring each user to open-code
>>> this sequence.
>>>
>>> Add alloc_cc_shared_pages() and its node-aware variant. The allocator
>>> rounds the requested size to the architecture's shared granule,
>>> allocates suitably aligned contiguous pages and transitions the
>>> complete range to shared state. It also preserves the caller's GFP
>>> policy.
>>>
>>> A private-to-shared transition may alter memory contents. Mask
>>> __GFP_ZERO from the underlying allocation and when requested, clear the
>>> complete transitioned range after cc_make_shared() succeeds.
>>
>> This is not true for pKVM though. It is the other way around. i.e,
>> pages must be cleared before transition (e.g., from private to shared)
>> to make sure the contents don't leak into the host.
>>
>> Do we need to handle such cases with a pre_conversion and
>> post_conversion hook ?
>>
> 
> Patch 2 does something similar.

Ah, yes! Thanks

Cheers
Suzuki

> 
> -aneesh


