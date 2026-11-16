Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DE8A606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 10:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=HEymC+HY
Received: by kanga.kvack.org (Postfix)
	id 7F5396B05B1; Mon, 16 Nov 2026 05:09:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A6086B05B2; Mon, 16 Nov 2026 05:09:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66DB06B05B3; Mon, 16 Nov 2026 05:09:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 34C446B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:09:52 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1FC5C1408A9
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:09:50 +0000 (UTC)
X-FDA: 85440560940.02.630BEA2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id F061B2000E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:09:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HEymC+HY;
	spf=pass (imf03.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794823788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=koCbOd0tdqhrnAzypAwoIYt0Xseq42FLcbswCn/kURA=;
	b=OxLswD3hoRmM1w22Os9fqOY/i2/o7EPoD6R0i9LA6awBx3Wdtx1U+zbzTb4HuPt9wb3KKR
	ndCa2IMolOHvmIxwUDuEGN2K1BeF9wKVoPZDj72R1opOUKcVj/SYdybmR4jNZh54ytnyri
	4iSs9B/Kwk88EB1s0LlBTOk7xxQ+27c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794823788;
	b=UfJngNciOztZUoRyVmtwEUzBbqvFZEiUbYEB9A2ilW0chTo+N/AJlTRaU9+H+gmS0m1Qc5
	hYvauivs4jQuvZSB/8ZotFb43SSfcuWdBq3cjqmhnSNuko8tw2MSeQhcUaQohCnb4GNPYW
	Ln3KHoenaVXUeSiOpoxzKVGTMCytoaQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HEymC+HY;
	spf=pass (imf03.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9F3FD1476;
	Mon, 16 Nov 2026 02:09:43 -0800 (PST)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 726053F632;
	Mon, 16 Nov 2026 02:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794823786; bh=2ad7YSntj3N8mQFw+MdlSPpSYmiwoq+kfn6LiXSNNQs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HEymC+HY2cjrTWlk5Rrica1pXk+RwFDrHn67MHbsdlytf78F9T92did0jsY25RToE
	 sSptL9z9vRblTwNCeZdQbDIdCAcbDlQ2zYp18Tdyi36jH6aNLiGqDcEjfxLEaws769
	 jKj/QuiKH6fEL8kQv4xYSwiCkECe+c4s3EoSb1ZQ=
Message-ID: <0524abf4-2306-4046-aade-c23aa7d1e0e6@arm.com>
Date: Mon, 16 Nov 2026 10:09:35 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/13] coco: guest: Add a shared-granule allocator for
 host-shared memory
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 linux-coco@lists.linux.dev
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
 patches@lists.linux.dev, Alexey Kardashevskiy <aik@amd.com>,
 Michael Roth <michael.roth@amd.com>, pankaj.gupta@amd.com
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20261116091137.94252-1-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: ehe4grcqt3gderkoq38fzbdueippfk64
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: F061B2000E
X-Rspam-User: 
X-HE-Tag: 1794823787-407446
X-HE-Meta: U2FsdGVkX18H7QZp4Y7jYCuz96p6BVsDX9yZ+zw+U7Jj2Cs1InQixPjt7BDauTbO9kE4MKq2vkvoW7ZEAbWW6DP4QSfhIbi7E/ooOv6y+hhIgAOju0gCtILrhpTkl44i9M/txAmEylRUKAIsCTHaKDgRK0bru8uPwcf25eMXcd74RaH0YnKlyxVVrjYYV1A/eY3oQYgPIVw54qM2m93r8pLZ2MTcnMA1+TirQ7hOU1YzNczl9ZNFR17lAnYkrrkaRI4bbwb6tEJKUsocY73tudz7COP0ywAJfsmrz60xN0aizyJXnOsSvN8tv6zynqoQZJfGtieQ3gXX0ZeNw7UahBUNaSf/ZDJUeYx5T3i6DQ4e5w17K712pSzfDCeu1xvA7FWZEfyfziWG9ZaxKtA+Conp7ZGXYEVtEJLXzUbZGC4n/5TRZCPEYsk/K1l/coR6JaOCMUYwADUN0gfbzS74BmiPMNfDgU8DEYTCtrWqdU/ZLjhDuSxpTftnShEH+oABp3seDH9tK2MuwRx77GpDTOEVJE4pd8vR4X/BeRSmL8ANL5aN1YIQ42lnpbiPDGxOsjjnLRLLecPIxz8v3hpgiCRqD0xFA6zRxM4Ru4sCtxSd6kgTpfbDpfsRfS8eFzyXayzRWhuwqlPnFaj0zy4QeAq4Ztl8i6UompSeWVXab/myRxpFYjYYyFYlnEl0q9kP2Npz2h9E7PXKJWTfgg7jqlDsuYoPmhcVo1suFo5J2uTNE/IPaPxdcUKQXdHrZwFcxj0PkqWkzYk++Gd1BTq15loO7NcrapnSBt7AieGJx8bZ2h0dyqLSDJJrczbNtkkQfsys/gNKCF0Bpr2eZBJOfcwYixkK9KHNZilB0V4xzFLXYVEMtbgPnN9bKyVU/uvBSg+UyQMniTqkMFNuzsxgXVm7/HYH/V+p7SR9Kt+1YXdmMDtaj9pxDY28V7kvBp2Hn3EEf3czc0DDJYBy761
 qQtOalC3
 k6oTiAds1wIvZzc+xmcP+UMP20ouekDXQnnDpLLBsSE0AjmA2curukWydnndP5IZUZZAFsu1qlzPQA0Gr6xR/a2brNI6wDHPoD24YS9wSzjzqrMPTZH2akaCFXUfNa7CLoY7IapAZyCAjuoXmxQmSk/d5HrkGAA5d0RM4dz3fY2WCrc35GO56ZioTNRsQ6eZEUuDE+iVL3ejlIvdplCMnsot3QKRqRiAktxF/JA4DFC/BNYT3YyLiDljzgv0QA+rKjireZWZUOVJx+O4RQOa6xOspyysRpLHMY/xTBiOtKNnviAVoFtul3Hdtvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Cc Michael Roth, Alexey, Pankaj Gupta

On 16/11/2026 09:11, Aneesh Kumar K.V (Arm) wrote:
> 
> This series tightens the alignment requirements for buffers that are shared
> between confidential-computing guests and the host, and adds a common
> allocator for host-shared memory.
> 
> When a guest runs with private memory, buffers shared with the hypervisor
> are not only accessed by the guest. They are also accessed by the host
> kernel, and the host may manage the corresponding shared/private state at a
> granularity larger than the guest page size.
> 
> Architectures such as Arm can detect incorrect accesses to Realm physical
> address space PFNs through GPC faults. However, relying on that as the only
> line of defence is fragile and can still lead to kernel crashes. The risk
> is especially visible for shared buffers that are later mmapped into
> userspace, such as guest_memfd or dma-buf backed allocations. Once
> userspace can access the mapping, the kernel cannot guarantee that
> applications will only touch the intended 4K region rather than the whole
> host page mapped into their address space. Those userspace addresses may
> also be passed back into the kernel and accessed through the linear map,
> resulting in a GPC fault.

IIUC, AMD SEV-SNP also has a similar requirement for other reasons, to
align the "shared" allocations within a guest (2MB ?, as mentioned by
David Kaplan at the LPC).

Michael, Alexey,

Please could you share your thoughts on this series ?

Suzuki

