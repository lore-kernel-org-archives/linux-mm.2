Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC223606A889
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 15:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=jRNS6qMT
Received: by kanga.kvack.org (Postfix)
	id BF9346B05BB; Mon, 16 Nov 2026 10:32:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAA1A6B05BC; Mon, 16 Nov 2026 10:32:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A99A96B05BD; Mon, 16 Nov 2026 10:32:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 859486B05BB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:32:43 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 12008A014B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:32:43 +0000 (UTC)
X-FDA: 85441374606.17.9FD629B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id BA04314000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:32:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jRNS6qMT;
	spf=pass (imf26.hostedemail.com: domain of steven.price@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=steven.price@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794843161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jj5m6gkNclPyoQQk/4BXK65xYrNPjI5avdyYMJJgjD8=;
	b=wTSLa+pskNajnMG8ioD/YxAZi0CgcZpfMme4sqL84tdKkG5S2eXX+O4VAP5YafqNLM7Njf
	WLqD9LyXeWQD9mYY58oNz+S3QZbTUXiLb3qOieDUL2pc4YEL3uEa+tvj5FAsDffJ62xRdu
	IYu4ohVGNbhsmXGalzTqXav9MIae/sA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jRNS6qMT;
	spf=pass (imf26.hostedemail.com: domain of steven.price@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=steven.price@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794843161;
	b=rYZUP8nQMuVl92Ir0tS9KRdb7y4d/8JkrLWnV+TexHzl8vdJGDXhWwqD7zFAFbBZAqtzd9
	IsDqz3JGmyqMleTj3Je8jqqlpYWarHGeWtxGy+JbnzzfKGj1C1mHnKGZ4Vj7vORq8hCF38
	pFPcyfZDf2Ny1JDd7JQ7BiPAkG78kmk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 981E61684;
	Mon, 16 Nov 2026 07:32:36 -0800 (PST)
Received: from [10.57.63.54] (unknown [10.57.63.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F11FA3F763;
	Mon, 16 Nov 2026 07:32:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794843159; bh=43dgJFkp15JzcneMwI62MfsDly+SSUj435aeqqE9QFA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jRNS6qMTC1i1b0ZGoCqXwbS6KBrk+Yh5SqMP1Ral6xS3Kl4b05yV/26O1O9OQPr/V
	 VKv8wWRTeAZ2qJ0AGAc5mdeJ1sNcv8KVpuqbRXV/JZl8UK6xrppLNhbKHBUqg37QLZ
	 28VI45Iu+Fte5YfxEwqeMoQxZGRjZaXXLp6Vp5Us=
Message-ID: <f2e47b68-1aee-4d17-8b63-e67075e7a42e@arm.com>
Date: Mon, 16 Nov 2026 15:32:25 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 14/14] irqchip/gic-v3-its: Preallocate VPE L1 tables
To: Lorenzo Pieralisi <lpieralisi@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, linux-coco@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>, Baoquan He
 <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Thomas Gleixner
 <tglx@kernel.org>, Will Deacon <will@kernel.org>,
 Russell King <linux@armlinux.org.uk>,
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
 <20261104164555.3555725-15-aneesh.kumar@kernel.org>
 <86zevn1c9a.wl-maz@kernel.org> <yq5ah5huoteu.fsf@kernel.org>
 <87ld6x8zb7.wl-maz@kernel.org> <yq5apkw5xpnz.fsf@kernel.org>
 <avrgNBXDFMGL6dqO@red-moon>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <avrgNBXDFMGL6dqO@red-moon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 54we4w67rtrpd1og3n4154dmrpnztnwc
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BA04314000B
X-Rspam-User: 
X-HE-Tag: 1794843160-546731
X-HE-Meta: U2FsdGVkX1+SfTfMWAjmJ/aDIKK/u5wp+vvP4IFxHuLf7QQJQLr7h5zLItJd5vAU74ktjeF9WBmR+Biq2Zx6yvGqxlx+7d4VazJHLGUgg4fXzlD0Bmu1cYOOrNy02/Ys4kQBvP8/fiZ2VhQan7cwlrVYroJumIRhMNzBcPrs9SNa7/l8oKMj+LDfpeYVM/qKzWivOzvffXrwb7Nmd2lfc8GOFKL2H7U0RmzLhTSNeRie1vChu5lj804qvr3XZDd87sha1XsP6xeqpdwJ78FoE7k/6Z+fwyVAiUOiqubRBUYV/zOqPQ7EQsU32sfNKQKT9WFQUFdyQjC9D61g9CMwpp8ewqvpiPAXHt6H/q6APIsIJa+1DNX225NAZUxDgTm60nAOgPnJiWFDfae9m6Jxwp/gom48PA34kBDajhC7p2oXXCZcPAhGG58Q5QQVmBi6z8fcs44ri95B0eMkSI7Xkz/gQVw6VcOtEUzZ9NWSegMIvYvqWAanRcS40Xfq0XDvLE8QhanIbMafBo1l54xT/bzwjfF0RAlByJpJOoaAsoLdwP98umUyy/uomxYWIcrNq2azRGRtCFDZog0Mr/Z9X6TSBfGV40h5PhJXad+upugVt1ESKWUm2nSGFdHcaz4rZaec/CNqGaJQ8ICXo2p0FTo3kefoTWwc5edcdfB9TvcxqSrUWgA8NkLSbl8RpihbMuOnVm/4VgXQP+R+nZirf4jjPK+7Gx4lFAZNvRSO+34izY8sc2jX8YwabmbnRu+w2GiiKE9IanNJBJmszr3rTlgBziBgo98AwvuqE/gHjBSwC6SPwD6r8Sm9on8v6nrmq0yhtjHFTVNqhCHyOtfVVj4gZDLoR+9zz33afkoVXLD7yPnl6QT8MhukpP/6uERqzySIYUF4avs5l85LHHv8gegBXDuUeix+8iZHEs8Z6R1bF4XsJR+eoea4DjEGjsXZGQJl4M11dGQ7GVMKNIB
 BZvFTJFu
 OyU3yfcsZdCPP2EVEQVM7qhicxalCJwWzsrjGu3+JbaLGlzTK5sGIVYXUaYzwoziGxIEcjqpN54yrQJaqVzqHwHeu76m+Rq8F/uveGZ8NxZoBMLTEaQCDkDOYNbEA239Fki4CPi1/BHpNn9RWZY0+dLTfocxrdPaPYxIOXTKbm31+YcRVK9pv5VO24uyC0DzTUa3tssabWk/4aUYkiVTNW5OQbyahrXFgO1tKZaKpD9nKddoK53dN2qLOe7cM5GI/fRZU5Juwc9oh1phntlC8e+NX0vSO22cFuy7przqMzxoICI4q17FFOYlmRDovFgjVUox5bQsNVDDB0p8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 16/11/2026 10:51, Lorenzo Pieralisi wrote:
> On Mon, Nov 16, 2026 at 11:51:04AM +0530, Aneesh Kumar K.V wrote:
>> Marc Zyngier <maz@kernel.org> writes:
>>
>>> On Fri, 06 Nov 2026 15:45:29 +0000,
>>> Aneesh Kumar K.V <aneesh.kumar@kernel.org> wrote:
>>>>
>>>> Marc Zyngier <maz@kernel.org> writes:
>>>>
>>>>> On Wed, 04 Nov 2026 16:45:55 +0000,
>>>>> "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> wrote:
>>>>>>
>>>>>> VPE L1 tables are allocated from the CPU-starting callback, where sleeping is
>>>>>> not allowed.  Remove the page allocation from this atomic path.
>>>>>>
>>>>>> Use a blocking allocation for the boot CPU and record the resulting table
>>>>>> order.  Allocate a page of that order from the sleepable CPU hotplug prepare
>>>>>> stage for each secondary CPU.  Consume the preallocated page only when the CPU
>>>>>> cannot inherit an existing redistributor or ITS table.
>>>>>>
>>>>>> Reclaim unused preallocations after the CPU reaches the online state, and from
>>>>>> the prepare-state teardown when CPU bring-up aborts.
>>>>>
>>>>> No. The way to do it is to move the ITS probing out of the
>>>>> non-sleepable CPU hotplug path.
>>>>>
>>>>> I proposed a potential hack at [1] (which I find far more palatable
>>>>> than this proposal), but the real fix is to probe the ITSs as
>>>>> devices.
>>>>>
>>>>
>>>> Could you share a bit more detail on what you have in mind?
>>>>
>>>> Are you suggesting that we create a platform device for each ITS and
>>>> initialize it through the driver's probe callback, while the rest of the
>>>> GIC initialization stays in the existing early boot path?
>>>>
>>>> Would that mean the main GIC is operational during early boot, while
>>>> ITS-dependent features, such as MSI delivery and direct injection, become
>>>> available after the ITS devices probe?
>>>>
>>>> Is that the split you have in mind?
>>>
>>> Yes. Then once this is done, all the tables become normal DMA
>>> allocations, for which there should already be adequate support.
>>>
>>
>> Thanks for confirming. Can we handle the ITS platform-device conversion
>> and the switch to DMA allocations in a separate series?
>>
>> The existing VPE L1 allocation path calls set_memory_decrypted() from
>> the non-sleepable CPU-starting callback, even though
>> set_memory_decrypted() can sleep. This issue predates the shared-granule
>> allocator changes.
> 
> If I may ask, why does the existing code ends up calling set_memory_decrypt(),
> or reworded, why does the VPE L1 allocation path goes through the ITS specific
> allocation function rather than using alloc_pages() (as it was before
> b08e2f42e86b5) ?

Because it needs to be accessible to the GIC "hardware". In this case
the GIC is emulated by the hypervisor and the hypervisor for a realm can
only see the unprotected memory.

Now I agree this is a little academic in practise because Linux (as a
hypervisor) will not expose RVPEID - so allocate_vpe_l1_table() will
early out. IIUC this would only actually be relevant in the case of
nested virtualisation within a realm guest - which is a long way off if
it ever happens.

> Why did b08e2f42e86b5 patched allocate_vpe_l1_table() allocation and moved
> it to using its_alloc_pages() ?

In that commit I simply changed all the allocation paths which were
allocating memory to be visible to the GIC to use the new allocator. As
we "know" that the GIC can only access "decrypted" memory. Admittedly
that could easily change in the future - but my expectation is that it
will only change with the switch to GICv5.

Of course what I missed was that this specific allocation uses
GFP_ATOMIC and that set_memory_decrypted() can sleep. This wouldn't have
shown up on any testing because of the early exit:

        if (!gic_rdists->has_rvpeid)
                return 0;

Thanks,
Steve

> Thanks,
> Lorenzo
> 
>>
>> Since fixing this properly needs a broader ITS rework, can we handle
>> that separately and drop the preallocation patch from this series?
>>
>> -aneesh


