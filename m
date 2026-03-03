Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CC4DEDA6AE
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 16:58:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79EA36B00A2; Tue,  3 Mar 2026 11:58:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75FE66B00A3; Tue,  3 Mar 2026 11:58:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67F7C6B00A4; Tue,  3 Mar 2026 11:58:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56F5D6B00A2
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:58:31 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0CCD213A1C0
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:58:31 +0000 (UTC)
X-FDA: 84505360422.24.1D8D950
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5375A1C0002
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:58:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JBBTutCI;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772557109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zuO7xXLZYBoTVCsXlC8EM/dmyDiHVPbuEm4QCTzJl5U=;
	b=V/EghBX/ey2EcicioEHNxVrwEbmRWPN9LjiobfDQYn1tEYRapQQCkDhXHS9BVhv7gejqNg
	YHvjmhxLi9nfzdK3ekk8RTJ8SpmOXTPi/U8gn8R/5yP9rUFrGYa7LionQbf2y3BjkyPxFB
	iofvsH71fd2NXKnIx0kD7srBUjUMLQU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JBBTutCI;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772557109; a=rsa-sha256;
	cv=none;
	b=jMoiHSN5qfm/qlfBh83RhHFEpjxhKe/5+ThhKzwr2UC2wO942eCOIk33LfrlRDDuNpRb4N
	a6GWk80RSR9bzEEYx9RtaZmQ2Jn9eLreabp81O6AQVTMfRHp7z3uI3t7FGjhuXEmQ274Hc
	Sk79svQLNtDLselNwz9TIe++/euxi2g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 997AD60018;
	Tue,  3 Mar 2026 16:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0E5C116C6;
	Tue,  3 Mar 2026 16:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772557108;
	bh=OVAgh1C/XzfXbtKoxyBCaCV23qvyohGYSDUW/NXiyOA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JBBTutCIgj+C/noMsPz566cZ3KYohlS0hKyF0VtP/i5dmPER2jOpLCgGR15Y05W72
	 UQysmqgLUTi3xS9Qr6l1lUAhKPrPgbhXodgkzDhMu1tUQro014B1M8nnsjU2qSVzRS
	 Zq1LfVR1GOrklFPIiR0TbyOR9ZXSeBfPp3OEo/PKYNWnLbVOqhhDg9yCx5pofEAxPZ
	 3HlEI5qbfqbeJdcbJbJ3EgyKwpla/AMOu3KBppMY1kAerQ4HrLcz/82I//rViPevQe
	 SQYH0WS7fL4D3TYQ9YbqRA+20UkwbAbClS4R/y5ymTtlnQWvommix5lPjinIIB5Shf
	 +W1RgiTRjqeHA==
Message-ID: <06a86676-51e8-4298-9f63-00e2ad9cdd0e@kernel.org>
Date: Tue, 3 Mar 2026 17:58:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 04/13] mm/migrate_device: Add migrate PFN flag to track
 device private pages
To: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org
Cc: balbirs@nvidia.com, matthew.brost@intel.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 ziy@nvidia.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com,
 lyude@redhat.com, dakr@kernel.org, airlied@gmail.com, simona@ffwll.ch,
 rcampbell@nvidia.com, mpenttil@redhat.com, jgg@nvidia.com,
 willy@infradead.org, linuxppc-dev@lists.ozlabs.org,
 intel-xe@lists.freedesktop.org, jgg@ziepe.ca, Felix.Kuehling@amd.com,
 jhubbard@nvidia.com, maddy@linux.ibm.com, mpe@ellerman.id.au,
 ying.huang@linux.alibaba.com
References: <20260202113642.59295-1-jniethe@nvidia.com>
 <20260202113642.59295-5-jniethe@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260202113642.59295-5-jniethe@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5375A1C0002
X-Stat-Signature: 58paihwts83zmo8yaaasxxyaxyafo4uc
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772557109-255738
X-HE-Meta: U2FsdGVkX18wogR3MUaED2+H8uLtxDTFfiehUCVMyfzopyCQMyLcmMXbZf8AOJCngRU9d8wBwmWYLO2eRI70EKfwcd/nUO/mNu7MPDLhDX1sldaYiOc33hthw9/ynDUY8q8eHWJtc0MeE8E5hV3GbdVTaLzJFOteJhrCO5by4QUF96Q0bXcDSn6wIGivDRJR/x3KaDXpAJUZhAS1AxDJOCHATzZM/lbLcrhDtIfHiHEO3fcNng09MSDxqTo11AqmGp65ZlDkSvKO5qJAQg/bUoHVfUiG7gI5jcxTyPI0koN6k1xzDgUmrvi8wsJoKnAKcOl2dMiN5wOXA7MZYe4Zf9WTMKoEmWI45hAOvKXGX6ZT80HQdA//HNGV8U2d1ocJQr1CmULFbA510Q8r0K2K57FQ83htovdjwzdbFzWvFf0Fo1VHdrsX2iFH2ZXN7YwuBsCBFy0bPT5g2pc/71Ztq1dtJH4k4+yqB7Y6QNlsg90z8unqx4KbIY5mPsIvbJg+6eptVmeusgOROO1kT8s3a/Dk2SfO+KjKCkwDmgUnRZVmqzZ0RERfwzX6sVBFvayA5ZasZUNyoKDIlaBz7com0Nm6miy9j1rADbJjbY5SA+NIK55lXwc84OJhPiQgAZ+BWaY7ZZdrFiE7kSwGJZYZDiVq8a71IwR9CC4CbvSHc8WvUTzgo1YCO+TFS3P7URmDA+0hVNEAuvXtL8Tz6nYcSGkK/2XiGESPtLtyRQEOxt4yv8x14EhyW8Ur4rTiX7bnaMop1r40w3FjdCIpv/Zg8w2vw9gGCMxqlLKsy1YnP3XTT8xGWqhyPmZRIOJMnF8fCAzWra3NxyG75iQTkZPVmDZgUi0696wSzYnVftuM82LRji8xhYj7rr4ZelTOATdVxcqzw9oXsKbnGsjskU+XiVbA4ku2W8wSBgqHCgS0sGgXRneQNgCHbr8StjdJAGBeaL3U7tt1ktRBcErTH8v
 UIgrrIil
 IXmzHM8OgPaHYIzZ6nhgUBMR1nGjoLEB8xqW4uFuIo9Hs0+DohZCReBzy4VADbDwf/NTihD94LhDo/zcuweTNz4J1bUJfzf9kAZP6a+CYe9A+K4rcctKuv1nFEwAzgKkXm6Nj8vYwV350KjwOVa3argVld7pTwX5bwP0cB7hn74L2c/VlAlkS3gYUn+7AlosgSqGBkax/4WoOYUVtmZxOLhik1l35jQu2z8qembDwF5uVyUB6xJMBPsEoqfFY5e19rqAuYq899a4NB3v+LLD6ceGT2sKw+RgQlL9Tfep7LRSa/QiYT2S278VQYHT7ir1kPprwW73MMU+5FPZNdOUgUOxW8/avsdVPJBby
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 12:36, Jordan Niethe wrote:
> A future change will remove device private pages from the physical
> address space. This will mean that device private pages no longer have
> normal PFN and must be handled separately.
> 
> Prepare for this by adding a MIGRATE_PFN_DEVICE_PRIVATE flag to indicate
> that a migrate pfn contains a PFN for a device private page.
> 
> Acked-by: Felix Kuehling <felix.kuehling@amd.com>
> Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> 
> ---
> v1:
> - Update for HMM huge page support
> - Update existing drivers to use MIGRATE_PFN_DEVICE
> v2:
> - Include changes to migrate_pfn_from_page()
> - Rename to MIGRATE_PFN_DEVICE_PRIVATE
> - drm/amd: Check adev->gmc.xgmi.connected_to_cpu
> - lib/test_hmm.c: Check chunk->pagemap.type == MEMORY_DEVICE_PRIVATE
> 
> v3:
> - Use adev->kfd.pgmap.type == MEMORY_DEVICE_PRIVATE
> 
> v4:
> - No change
> ---
>  drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |  7 ++++++-
>  drivers/gpu/drm/nouveau/nouveau_dmem.c   |  3 ++-
>  drivers/gpu/drm/xe/xe_svm.c              |  2 +-
>  include/linux/migrate.h                  | 14 +++++++++-----
>  lib/test_hmm.c                           |  6 +++++-
>  5 files changed, 23 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
> index b6075a2808c2..fc9465db6d5e 100644
> --- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
> @@ -212,7 +212,12 @@ svm_migrate_copy_done(struct amdgpu_device *adev, struct dma_fence *mfence)
>  unsigned long
>  svm_migrate_addr_to_mpfn(struct amdgpu_device *adev, unsigned long addr)
>  {
> -	return migrate_pfn((addr + adev->kfd.pgmap.range.start) >> PAGE_SHIFT);
> +	unsigned long flags = 0;
> +
> +	if (adev->kfd.pgmap.type == MEMORY_DEVICE_PRIVATE)
> +		flags |= MIGRATE_PFN_DEVICE_PRIVATE;
> +	return migrate_pfn((addr + adev->kfd.pgmap.range.start) >> PAGE_SHIFT) |
> +	       flags;
>  }

Just pack it into a single line (checkpatch should no longer complain),
or alternatively, indent "flags" properly.

Shouldn't migrate_pfn really be called pfn_to_migrate_pfn()?

Also, looks like a "addr_to_migrate_pfn()" might be a reasonable helper,
which might also reduce the line lenght :)


But now I wonder: could't migrate_pfn() detect internally that this is
MIGRATE_PFN_DEVICE_PRIVATE, similar to how migrate_pfn_from_page() does
it? After all, there must be a "struct page/struct folio" there, or am I
wrong?


-- 
Cheers,

David

