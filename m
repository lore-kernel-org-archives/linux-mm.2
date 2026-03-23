Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82CF8F483D7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 17:52:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D614B6B0005; Mon, 23 Mar 2026 13:52:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D38F66B0088; Mon, 23 Mar 2026 13:52:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C00D76B008A; Mon, 23 Mar 2026 13:52:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B09766B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:52:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 52FC3BD886
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:52:04 +0000 (UTC)
X-FDA: 84578071368.08.D14BEF8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6B03C4000B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:52:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hRTaRylF;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774288322; a=rsa-sha256;
	cv=none;
	b=yemO6+FatXfAxPTIvbaYU1gUAah7Y006QvZIkxJODqmjYunKebOc0ZKBVNIpAhBYo/6ZXT
	sGeSgfIeVfBYa8Ihd1nPc3psk6qHgYYjpK1lVK5hB9aU2lcXOzPQk9pzsTFX2HMXqP1fjH
	Ne2FjAC+wHAtMPijKLwYZH3Jmg1MGmI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774288322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N8Q2YI+aHkKmnXGsLGvl2FTJOOn9qfXrIl8SfLUQfBY=;
	b=n2TBblyfC5mElmDPs+crnf/DUwpkjQzov5fr23ovc2IQmKk24MCXF3UqY3iIkYjy7Z7bUm
	H7ZtvC01i3D0GdYXxByMcVx7g3xpJ1TCbVUgEy3LarUuAi9J0niNcCGhqQxr9fuHFa9Y5h
	HU4yjTCM1hCL+DeW7JZ2FYnZlm2TrVE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hRTaRylF;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D081E4089A;
	Mon, 23 Mar 2026 17:52:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D040BC4CEF7;
	Mon, 23 Mar 2026 17:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774288320;
	bh=5hK0lEzqKpD6B7ugeP6Y6wm+od5B652rwYVrsebBxYw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hRTaRylFaKiULg4U5aE4ktkU7BRuQLdv1usSIlvOyM3oyxczdRVbPv+Pr3eENuc0B
	 eNT73uQH0QPu3oY+IbPuS1dvOyK2mZihmZ0UpnDjsoN8FJqzyWvG2A0tXjGZiG317m
	 tbP8sYYAGc0NkxOd7poaHGmvnhf8U6+WFBQ85I1eRmcmFu4ftMRKHaF8L7SIv5/s8c
	 ZF/oYLz912UjohFG0YBksMiYmu4/SHJUsawsDt9nBkWWWBO4KkprZa8ALqadxd81RG
	 BgvMsAmxJ9MvZD3XqCHx4Uwwxf7Zu0a7PHi6AjCOgSDlC4eZ5n/FpnMXZI9VnY0H39
	 pINsESfKgcnZg==
Message-ID: <54f9b5a7-b8a9-486a-9c12-a910f5287947@kernel.org>
Date: Mon, 23 Mar 2026 18:51:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 02/16] set_memory: add folio_{zap,restore}_direct_map
 helpers
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "kernel@xen0n.name" <kernel@xen0n.name>,
 "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
 "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
 "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
 "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>,
 "oupton@kernel.org" <oupton@kernel.org>,
 "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>, "seanjc@google.com"
 <seanjc@google.com>, "tglx@kernel.org" <tglx@kernel.org>,
 "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "luto@kernel.org" <luto@kernel.org>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org"
 <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
 "mhocko@suse.com" <mhocko@suse.com>, "ast@kernel.org" <ast@kernel.org>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>,
 "andrii@kernel.org" <andrii@kernel.org>,
 "martin.lau@linux.dev" <martin.lau@linux.dev>,
 "eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org"
 <song@kernel.org>, "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
 "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
 "kpsingh@kernel.org" <kpsingh@kernel.org>, "sdf@fomichev.me"
 <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>,
 "jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
 "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "peterx@redhat.com" <peterx@redhat.com>, "jannh@google.com"
 <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
 "skhan@linuxfoundation.org" <skhan@linuxfoundation.org>,
 "riel@surriel.com" <riel@surriel.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "jgross@suse.com" <jgross@suse.com>,
 "yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>,
 "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>,
 "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 "yosry@kernel.org" <yosry@kernel.org>,
 "ajones@ventanamicro.com" <ajones@ventanamicro.com>,
 "maobibo@loongson.cn" <maobibo@loongson.cn>,
 "tabba@google.com" <tabba@google.com>, "prsampat@amd.com"
 <prsampat@amd.com>, "wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>,
 "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
 "jmattson@google.com" <jmattson@google.com>,
 "jthoughton@google.com" <jthoughton@google.com>,
 "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
 "alex@ghiti.fr" <alex@ghiti.fr>,
 "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
 "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
 "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
 "dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com"
 <gor@linux.ibm.com>, "hca@linux.ibm.com" <hca@linux.ibm.com>,
 "palmer@dabbelt.com" <palmer@dabbelt.com>, "pjw@kernel.org"
 <pjw@kernel.org>,
 "shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>,
 "svens@linux.ibm.com" <svens@linux.ibm.com>,
 "thuth@redhat.com" <thuth@redhat.com>, "wyihan@google.com"
 <wyihan@google.com>,
 "yang@os.amperecomputing.com" <yang@os.amperecomputing.com>,
 "Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "urezki@gmail.com" <urezki@gmail.com>,
 "zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>,
 "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
 "jiayuan.chen@shopee.com" <jiayuan.chen@shopee.com>,
 "lenb@kernel.org" <lenb@kernel.org>, "osalvador@suse.de"
 <osalvador@suse.de>, "pavel@kernel.org" <pavel@kernel.org>,
 "rafael@kernel.org" <rafael@kernel.org>,
 "vannapurve@google.com" <vannapurve@google.com>,
 "jackmanb@google.com" <jackmanb@google.com>,
 "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>,
 "patrick.roy@linux.dev" <patrick.roy@linux.dev>,
 "Thomson, Jack" <jackabt@amazon.co.uk>,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 "Manwaring, Derek" <derekmn@amazon.com>
References: <20260317141031.514-1-kalyazin@amazon.com>
 <20260317141031.514-3-kalyazin@amazon.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260317141031.514-3-kalyazin@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6B03C4000B
X-Stat-Signature: uji9983cziorj584puf4rk36tkoefyc6
X-HE-Tag: 1774288322-361652
X-HE-Meta: U2FsdGVkX19kKm60vGGFGEHMrhKhQ/lx2wzxF6AZD6czuxgKqZOj7cFBmzlbCuebEFUqInKTkqgLJ0EUEeWcJYxUvdKcJljLaByr/B8GXVcgppHM6NvD2qGWsXgg8Hcq1e4nvrW4yHAvfzqg36dsO/zjoiECvTDYQhE2QWJejeM0iZe0xTFwPE5AUUQrIEZqo6RueqQHSsQ3q6h76yGPEmXjYbD3jpoKc2zsCafPGdZc+1XSvreG7aUNKi5Jl1X5FzYCGRtfUXJK1+viJOgnqjZero7DFAHoDA1Ic+EUIVZmDffx3mikoPFu+GvibQp9eqeJT3fAOHvcWkMN1bRBmFTC59DmYimd6ZKeF9+GAM3fkKuHq1/52T1ddItgo4FaljTnv8AhtF5/0NqtH6Du2x9CmhMWhqR/eDnn98FsriUTGjCfWQqaUyh9FKvCDgws9NKPu4NWDmaGcsYr9+wZpebKzApNR0VUfcbOxCw+k2umxgtm04lrsKHAXTDEWo6Y7hh0IRMMc2233liqsg+pxV98Li9RsBwrWJb1tkT7f0jNYJHpTStmYEbPcWmcbyRuE38Bi/LxyrQoVXb7pXnQ4E9O3GcwW9bjrsvzvLVrahWgHjNvbKj3Z0dlA+1nmnHLh22XWhQSSeL1rITLfE/LiRBFZw/VSWGFb2li+Y3FglpXRBa53l90Y+SCrlzYFN4k2A4q+Xkioua7VC+0+xTMflvycK/FpiB2LR92Vx4EzXVqs3WU+Rtun8VQ89zreqHgRj7Dh5/Yg45vsho/pIpBmV1N/8gmTll9uUQ5PptrA03lwgWFYTobKJUkt0tcQRon3h2esIzlOgts+EZfYjGGVwF9P7EoIjiWgImArZkOc+blJs3IGirR/UCaM5vfxEz92k52KRxxSLQXybPtDy7SE//YsF/wfIisr3/o0/BTKrxJtGVPCTjAERR6fe36WGApgyokBoZaEIvxZdasIWi
 gridSQV9
 v1w+3NtyLDTvIc/8nCDUr3FFmWC7n9kU73AGQcPnwOGuHNGtwgsYjf6IkSrrQVefPPP0zFhfjfgSO/WzRwXjSoyNQ85c1+w363v3Vc6yUGrWlRYacUo+oSKumgoKoX3eyfkTsKVcuALXvjex3PyFQ87wyYSfblVtU0eTeBvEtfCZCu0XcQDPfG38w1YodwgfIghgljFftW3MYCfbF8tDNylbhueEBBzHPrnRwG40lMtCCscWzYuyftpgLVF8wJDTtlmyFKk0JXr6X6pfuFmHS21jRe5gE/JTB9JolimQgAb+vKpWhBK+mZp2SD3h4CxiZOntIN2AGxR4ANLedpCWJv5EfNQK9PeBEsRFVB8cYz9bM6ohxFmYY2KFHPBAZHbijX1FSqSaNwNbJPzZOemPzrSKrIo5EN6VI+8txPG11z0ksVdkQ6tdso42vxAKkz7Z7rq/dsbf9BHmViE96Ho5hJjRQYXfmqZHVqUu0AFmTwQjrp6aTlaRRfaXMsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/17/26 15:10, Kalyazin, Nikita wrote:
> From: Nikita Kalyazin <kalyazin@amazon.com>
> 
> Let's provide folio_{zap,restore}_direct_map helpers as preparation for
> supporting removal of the direct map for guest_memfd folios.
> In folio_zap_direct_map(), flush TLB to make sure the data is not
> accessible.
> 
> The new helpers need to be accessible to KVM on architectures that
> support guest_memfd (x86 and arm64).
> 
> Direct map removal gives guest_memfd the same protection that
> memfd_secret does, such as hardening against Spectre-like attacks
> through in-kernel gadgets.

Maybe mention that there might be a double TLB flush on some
architectures, but that that is something to figure out later. Same
behavior in secretmem code where this will be used next.

> 
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---
>  include/linux/set_memory.h | 13 ++++++++++++
>  mm/memory.c                | 42 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 55 insertions(+)
> 
> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> index 1a2563f525fc..24caea2931f9 100644
> --- a/include/linux/set_memory.h
> +++ b/include/linux/set_memory.h
> @@ -41,6 +41,15 @@ static inline int set_direct_map_valid_noflush(const void *addr,
>  	return 0;
>  }
>  
> +static inline int folio_zap_direct_map(struct folio *folio)
> +{
> +	return 0;

Should we return -ENOSYS here or similar?

> +}
> +
> +static inline void folio_restore_direct_map(struct folio *folio)
> +{
> +}
> +
>  static inline bool kernel_page_present(struct page *page)
>  {
>  	return true;
> @@ -57,6 +66,10 @@ static inline bool can_set_direct_map(void)
>  }
>  #define can_set_direct_map can_set_direct_map
>  #endif
> +
> +int folio_zap_direct_map(struct folio *folio);
> +void folio_restore_direct_map(struct folio *folio);
> +
>  #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
>  
>  #ifdef CONFIG_X86_64
> diff --git a/mm/memory.c b/mm/memory.c
> index 07778814b4a8..cab6bb237fc0 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -78,6 +78,7 @@
>  #include <linux/sched/sysctl.h>
>  #include <linux/pgalloc.h>
>  #include <linux/uaccess.h>
> +#include <linux/set_memory.h>
>  
>  #include <trace/events/kmem.h>
>  
> @@ -7478,3 +7479,44 @@ void vma_pgtable_walk_end(struct vm_area_struct *vma)
>  	if (is_vm_hugetlb_page(vma))
>  		hugetlb_vma_unlock_read(vma);
>  }
> +
> +#ifdef CONFIG_ARCH_HAS_SET_DIRECT_MAP
> +/**
> + * folio_zap_direct_map - remove a folio from the kernel direct map
> + * @folio: folio to remove from the direct map
> + *
> + * Removes the folio from the kernel direct map and flushes the TLB.  This may
> + * require splitting huge pages in the direct map, which can fail due to memory
> + * allocation.

Best to mention

"So far, only order-0 folios are supported." and then ...

> + *
> + * Return: 0 on success, or a negative error code on failure.
> + */
> +int folio_zap_direct_map(struct folio *folio)
> +{
> +	const void *addr = folio_address(folio);
> +	int ret;
> +

if (folio_test_large(folio))
	return -EINVAL;


With that,

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

