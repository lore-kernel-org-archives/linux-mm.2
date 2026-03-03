Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9A5DEDA69C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 16:41:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FD996B00BA; Tue,  3 Mar 2026 11:41:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DEC86B00BB; Tue,  3 Mar 2026 11:41:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DD906B00BC; Tue,  3 Mar 2026 11:41:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BB546B00BA
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:41:08 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9B11F14024A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:41:07 +0000 (UTC)
X-FDA: 84505316574.14.FD47331
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id B3C2880019
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:41:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hqoRkAxf;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772556065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qCSHDHc/8ypToeqPN8PoWJeRLF0T6o3MKkWY9OPr7/4=;
	b=BiDWAXaIrj5HMV2CMNicxX4ynuK5msAYpdoNGd43W/odNn0bLC1PY3GlHI6gl2l1kCDKhw
	dHiEjK68iL2a/svd8906aHgKm1q0QndZp0rn+i7znLyBg0jv1QuUZUrP+mByWTzxc2iYLI
	L7hSnJxie8DtTcZCw9Mv20mCZsWkwv0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772556065; a=rsa-sha256;
	cv=none;
	b=hvML+mX3Y6WMnBnsu5PjLJ3+ogV3sg6JX6M9o8bV1mcySvkNtni+halFYzo+0M/Eog07cQ
	PNo3jsW9S+o1Wh2Lp2g7BH5DQB0iZJ3jaJIAM1U9EM8wvBeamkgnNqz0t8S3WrpVJEjSQ2
	rDKceQQ3xRNQsyRwvSPv818xL2t9EJc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hqoRkAxf;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B5D9E4349C;
	Tue,  3 Mar 2026 16:41:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BD9C116C6;
	Tue,  3 Mar 2026 16:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772556064;
	bh=0LFa7vXZyD9LMEFVvzGin3tMycV+fpDYSnfRCbWLcEE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hqoRkAxfE5twbIJWM8Ud9CZqn2sf98qKjlHpYvR8ECBXvt8ol3xRSaeN3+irT6sZB
	 /1GDoD4Y1P7qEsKPh92/JptcJVXV3grvE8FdpeQCTzoMK1VNA9NwLI/ddd3FOhN32B
	 LAw9wRjM5pfLAUnQ/rFdLuhbIoBlD58yH08Q9Oa4Y9wZkmM4k4+jm9wUOFPWEJR0bB
	 x7Rq7FGb3nH9RSRPkzdn9r7PUUIWIqAF4sA97GNw6Ewd3//K4RjHZWizQuO5U21W1S
	 so3AlHzhXfaFGCsaJRJV83dn1sbvi62l2YHvxlUrwvYq0oMSKtiZyBjdhsMSS9T2Z8
	 B9cHur4uyhIbg==
Message-ID: <139c7644-99e8-4d5a-a88e-74bf2b14f2cc@kernel.org>
Date: Tue, 3 Mar 2026 17:40:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/13] drm/amdkfd: Use migrate pfns internally
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
 <20260202113642.59295-3-jniethe@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260202113642.59295-3-jniethe@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B3C2880019
X-Stat-Signature: ooipng7q97ikkbd7zsstbxgtuh19gn75
X-Rspam-User: 
X-HE-Tag: 1772556065-812355
X-HE-Meta: U2FsdGVkX1/yx0AHCat9mmtzI97SvL/eiJLaZsNiHyUfkK5lBQhfQy0Bj/O9aPAqZNjsPRNKRz/ayyYsYgCKG9JOZC7k+4oLq4UkaCK5rUObH/LO+s0JC69fE92v84Xklejz7Lo1bQL0vKXWAV+NslH11An+NpqaFUHV3Cr883RXy+8ro3jFRnbetVuitdCvjNkE/ov+zgGj0MqAwitvPmdurotnhL2y6eMESG8zYob2G8/F4+aBKQHq2KqF5FtMvTd4TJHJj/hx9F4vY0lYm8xgJMxolHPtPco7jqFi1muEmzPrHbyzj2zE5rYfNeaXiroZyaJZVa7YPevya/ytc+0Kd4qoYePuL+rwWo3qFLnWiXl5uCXOC3uXcCM+vAicMALN5DbX9rUiAVl4AFOBcfJCDZHMHGLz9/pUg3k/Yj20P0oCewcz535B/Hq+GmlGH93E89r+SemCHxueVEWIvhbU32AugDPOg54mKkSXE5z/Pp+y0lcAYVdwJrUZ1fNI/LL7EguBT2nIFp+Fj8gEeZmxu4SpX2iRN9NgqCLX5/PU2Va6fdSIGVVsMVdmw4sJUPnmxNfQqoQFM8dsqyYalzH9IP/TFSdJY+tqsnIOtO4UWNCw8Bbp95cCMQzxXkd1iYwc/zrx7DHsFnLZ2AHGPGztvNwi5ScqOBhS2azXPjMUDTatf7u9dWbcj3aHt9dQwguw+vKMt2VtrUAeyFrNyIXhjVKtVAUAWFCi5V6T0JqgjT9plxI5FT5v1VbVQ6K3gmH4EBYPCgGV7ttDu+aFAHq6C9eAACVsxnXX7Mxdqe5nnmW1IDKFK2CdHkuOwBGbjam6Kw+6gRcf+RO34L0NdnDYmE+Ts5CwejsmZJDq8qzQblaYxxVlaWJRB9Hcr1OD/QeoIdePxRelumD5HxinlhgX2Wtr5bH3kwWBNOF+/WCZ4dNNzLT9MaLb4A3mAQNui7d3kT2EulVXc5V66Oo
 3S9GnAGU
 cyg2jST7Xg/M1FvDKQYQErTC+cHSTyi1Jvb8qwPTQ0bNuk5nzuodxg4ZKI7etIDVJIeM9waFTOWXY+WWE/nLwNiVI7wtWOg686QzJxYuYYBQOF9hkKLRodQE48bvFb7qsg7VL9ivXlqq9mA/bkFuuFn0HZYkDg78KrICyVm7qcIRXr4e6AuD3ja3ytTBUihs4Ap6pzIpYoIxY6v4e90nqiNwjYcF49WsxJWDOXzAvxtN6XBDsad563U0Kj1C3PljG/xbE0x274MZizMPrChGm1P1OK7g1e8MQo6Ndfg8DfcHjI85CKRd4U5TymA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 12:36, Jordan Niethe wrote:
> A future change will remove device private pages from the physical
> address space. This will mean that device private pages no longer have a
> pfn.
> 
> A MIGRATE_PFN flag will be introduced that distinguishes between mpfns
> that contain a pfn vs an offset into device private memory.
> 
> Replace usages of pfns and page_to_pfn() with mpfns and
> migrate_pfn_to_page() to prepare for handling this distinction. This
> will assist in continuing to use the same code paths for both
> MEMORY_DEVICE_PRIVATE and MEMORY_DEVICE_COHERENT devices.
> 
> Acked-by: Balbir Singh <balbirs@nvidia.com>
> Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
> Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
> ---
> v2:
>   - New to series
> v3:
>   - No change
> v4:
>   - No change
> ---
>  drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 15 +++++++--------
>  drivers/gpu/drm/amd/amdkfd/kfd_migrate.h |  2 +-
>  2 files changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
> index 297fa108ccf9..b6075a2808c2 100644
> --- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
> @@ -210,17 +210,17 @@ svm_migrate_copy_done(struct amdgpu_device *adev, struct dma_fence *mfence)
>  }
>  
>  unsigned long
> -svm_migrate_addr_to_pfn(struct amdgpu_device *adev, unsigned long addr)
> +svm_migrate_addr_to_mpfn(struct amdgpu_device *adev, unsigned long addr)
>  {
> -	return (addr + adev->kfd.pgmap.range.start) >> PAGE_SHIFT;
> +	return migrate_pfn((addr + adev->kfd.pgmap.range.start) >> PAGE_SHIFT);
>  }

To make it clearer that the result is a "migrate pfn" I'd call this.

svm_addr_to_migrate_pfn()

Not sure if maintainers have any other preference.

Apart from that LGTM (someone should convert this code to use folios ;) ).

-- 
Cheers,

David

