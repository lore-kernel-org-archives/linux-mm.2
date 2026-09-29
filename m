Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33943C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 07:11:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15F736B0088; Tue, 29 Sep 2026 03:11:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 110AD6B008A; Tue, 29 Sep 2026 03:11:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F41E46B008C; Tue, 29 Sep 2026 03:11:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C942A6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:11:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 04FF014041D
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:11:21 +0000 (UTC)
X-FDA: 85265928804.09.EC80CCB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 528D54000A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:11:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k3hWMC6I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790665880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JdlkVNS4LHpC8Yj8xus5KzRNAlfmfW9Jat5ACbHfNXQ=;
	b=5s08EUQIJwp0f2/FAJx6R3q2Rdd9nGjrotVvdfBlReEPbffJO7N6nWCnLhP+NGQP/HvXbl
	wPUAuOLAtsu06JELFvvFYwBskp2HmM0s3jE4Kkd63x5SUTyT6fap6PcsEG0zIQwW2PZZw0
	rJ2ybQolFFzijyir577w5G6mBtZOBN0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k3hWMC6I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790665880;
	b=wHgr4lBPHPCztuFCazOCqhuN7acecX+GilofS9uGirLO0+ZQp+mHakMGvEu+tQeThaLQBe
	XFYrOZQl3uh8jvbq2YP+V7cwvap1CFeQhUX3OWUvgvePwoxY6gr/RMAiLGzXE7zSRgiTJU
	rHtaG2LGnj9unXLhFoTuLpNV+dB+1u0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BC8CF602CA;
	Tue, 29 Sep 2026 07:11:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467421F000FF;
	Tue, 29 Sep 2026 07:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790665879;
	bh=JdlkVNS4LHpC8Yj8xus5KzRNAlfmfW9Jat5ACbHfNXQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=k3hWMC6IUNtYuzOPzmJ7y1M5aFJuabov6fIU9bZ0sHW+WrXQhJQFQybdudnHe7uBU
	 1DheJOg0y7ORTXvx77EkEpgphs6LsSg66jTwGk+v4p4Il8mUmIfRg7h4RIwsGdhDNj
	 giZetxpv1pMCMoxqM++pU4Fka2UKLcin4pQQCZECGzEKtd1t8cQZoBnzqgHeFmFZod
	 ozIEGX/tYSllaAWg78LdWR7Of0JKD+T0ijfiMdKsMgZPb0rw+iKSrYuLhAvGm8oHUK
	 D33cywp6G4E7nt22lpQHhxzxlnX82ly0Fx06nJ0bUvBq8q8ac/FWRf1p60+E1EcP7n
	 IT1xmbxcMe9QQ==
Message-ID: <d7a75c99-3021-495f-ae34-883d047370f3@kernel.org>
Date: Tue, 29 Sep 2026 09:11:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/12] mm/sparse-vmemmap: introduce
 CONFIG_VMEMMAP_OPTIMIZATION
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Lance Yang <lance.yang@linux.dev>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
 <20260927025441.741633-4-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260927025441.741633-4-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 528D54000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: zqukekuyaymr3xim1eogjfmirqt4bipy
X-HE-Tag: 1790665880-676044
X-HE-Meta: U2FsdGVkX18JMQtJghvNnZoAu+yizxo83g8ysztkBINeq1oVrMYGvW6y6nJ+sH2hrL3WcclFAn5LQzA7dahZX08lC/RISNjv8qFGeVBCTxPQRcEmbzj+HCRPYhsf6L0G3BMQ8RV5ptgDIFi9qq6/paaptCk+2Aod4tKbxNdqPuD+SoB5EyBINOZl0tVF/ZN2n53lzVJywS6/5XVYt05hE8qWREhmOrae247myn2XTB3PKFm2Ot24hc0YyyHJMNonG1oOfuu7xawOylf2kfTtSSQJky5E7XOBKpQzM8Q1B4ItYU5VENQSvA9Cnp26hDvIqH5HZk/6Ilb4b4vCwuI/wPJidGVTk6ip4tch5znrddgA8iQD+VrZx8lf78ydTlzZpzxMfkY+setr1kN4P6o5tMl4XDoZHOYBnqo2RbhbfDpVdqc9CwFCDxmGunFG1zGagT6+O+bVMeNHi4gyy/BZDCYCpOLJs4DfRyXuas9XISkVrZo9cfkaLh7LnWhPlWQ8TBaNwhcezhLUjgWYMRd85eUShQO2eWJ0GhPxG7/3Al1uSsD673B+U/X6SxaIAvBi0Quron35h9lykcdmqlINuQnBeWDajMAvRNPOw5hVhcMYkhqjAInXPrS4V7s9jFEuSFExIzMk0+qZsJ+vaz5dRL5fq3aMPfGihPaYtDV55s1ZVW05ORejWILNK+VQbRqOepZv2DziK9zRqE/ToaLdFOffb1BbXuziTzmAPeV0ZvXdUw3lHNEiXnmelyzZaqptImDs2RYoGvfN8veHMuDisvU2x53666vGSIT7sbazQq5cXm5oiZMz0O8s0+V70hiOeWyUtyDVIFNi3+wVNved2N39E3W9Wmxsp5LCJeKkzdgoBigVZzXbm8pVHCZmG+T3TTcZv1cdKkicIz/ZrdAt36XPGnw4mPcQHq6T9K7AWAL1crMxiNXmaRBzUg9ZKB8NWNBS7H2PcWxqs/bdCIP
 bpz3VhlQ
 los2BArhr54KqzU6UbWWNAWXFRaj9uk0syPMwvWVnCop1oGLPn4SALU26wX0rM9aR14hW47kooQBzyUQAfEPf0nVes6KXOyNJoiGUkwfX9JKz8K6mY0gyqrU1DI1ZwLDBIj+Vc1zTpN+CG/zUuwhK4POrOxUV1vuZcxRNK4FsaWjdEXl0/bmAyyMaHGNNI1D2by1l8y2DoES39UbuJXB1SC2LbsrszV5Hr03tJWHJngjWxsRJVbZ3TjepwDWINHawDKY0jXMNe4jS2kLQotYgx07BLAlZxGBb/sF4e7VnOg/xzJX35H9YHf19x63g6uCQg5Hr60ekWnLleunALJ3q74mMTtcw9r50VEo+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/27/26 04:54, Muchun Song wrote:
> The section-based vmemmap optimization infrastructure is guarded by
> CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP, but it can also be used by
> ZONE_DEVICE users that set dev_pagemap::vmemmap_shift. Introduce
> CONFIG_VMEMMAP_OPTIMIZATION as a common config for the shared
> infrastructure.
> 
> Select the new option from HUGETLB_PAGE_OPTIMIZE_VMEMMAP and from
> ZONE_DEVICE when the architecture opts in to DAX vmemmap optimization,
> and use it to guard the generic sparse-vmemmap state and helpers.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
> v5:
> - Move this patch after the shared tail-page factoring.
> - Select VMEMMAP_OPTIMIZATION from ZONE_DEVICE instead of DEV_DAX,
>   covering all users of dev_pagemap::vmemmap_shift, reported by
>   Sashiko.
> 
> v4:
> - Rename SPARSEMEM_VMEMMAP_OPTIMIZATION to VMEMMAP_OPTIMIZATION
>   (suggested by Mike Rapoport)
> - Collect Acked-by from Mike Rapoport
> 
> v2:
> - Fix SPARSEMEM_VMEMMAP_OPTIMIZATION being selected without SPARSEMEM_VMEMMAP
>   reported by Sashiko.
> - Add an explicit DEV_DAX dependency on ZONE_DEVICE
> - Collect Acked-by from Qi Zheng
> ---
>  arch/x86/entry/vdso/vdso32/fake_32bit_build.h |  2 +-
>  fs/Kconfig                                    |  1 +
>  include/linux/mm.h                            |  3 +++
>  include/linux/mmzone.h                        | 10 +++++-----
>  include/linux/page-flags.h                    |  5 ++---
>  mm/Kconfig                                    |  5 +++++
>  mm/sparse-vmemmap.c                           |  2 +-
>  mm/sparse.h                                   |  6 +++---
>  8 files changed, 21 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
> index bc3e549795c3..72a92cb9b53d 100644
> --- a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
> +++ b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
> @@ -11,7 +11,7 @@
>  #undef CONFIG_PGTABLE_LEVELS
>  #undef CONFIG_ILLEGAL_POINTER_VALUE
>  #undef CONFIG_SPARSEMEM_VMEMMAP
> -#undef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
> +#undef CONFIG_VMEMMAP_OPTIMIZATION
>  #undef CONFIG_NR_CPUS
>  #undef CONFIG_PARAVIRT_XXL
>  
> diff --git a/fs/Kconfig b/fs/Kconfig
> index d1c210c6508f..1454b7fe9641 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -278,6 +278,7 @@ config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>  	def_bool HUGETLB_PAGE
>  	depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
>  	depends on SPARSEMEM_VMEMMAP
> +	select VMEMMAP_OPTIMIZATION

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Is there a path to remove HUGETLB_PAGE_OPTIMIZE_VMEMMAP, and to merge
ARCH_WANT_OPTIMIZE_DAX_VMEMMAP+ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP into a
ARCH_SUPPORTS_VMEMMAP_OPTIMIZATION?


-- 
Cheers,

David

