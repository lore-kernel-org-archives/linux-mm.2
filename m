Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C742F483DE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 18:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 957C86B0098; Mon, 23 Mar 2026 14:05:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92FB16B009B; Mon, 23 Mar 2026 14:05:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F75F6B009D; Mon, 23 Mar 2026 14:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6EB3D6B0098
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:05:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1CECC1A0C9D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:05:47 +0000 (UTC)
X-FDA: 84578105934.06.53E94FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 44AF61C0004
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:05:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AHKvItoJ;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AHKvItoJ;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774289145; a=rsa-sha256;
	cv=none;
	b=fNvAP/9XKzALwp2Wk34XJOQYDck2JEwtwxA9HkaH+y5ficQ3vdfb5EmdwTDzAE8Y+xWRBh
	CXCj31yYCGxu2zkCFRVzDwiFEOu11AKULrwBDQBKVYKwDr1TXwVt0mEHNDA7AtpSjFOxan
	DLYvAo+qeWhBGlphJZ+DoqRO8QQ/9eM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774289145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cuCDsJCDyPDBccUfufnh2G2zzX0Ih/aAYBkb6n4apcU=;
	b=y3uqqYedn4hr7VN9piT+ZnOJTzt7S7cqwil2cQErhzGTAKxcY4K+nq6Xx6F+fjokXiItYY
	NYOJNUSjzUq5oqKlKF8x5eVEn9+1YmX6URnGEWhYNrdISznFP9wEsqExtX8mDBWBNoINVM
	ghLgKyrYjnhQqoW3F9TuUprhJfRzyQ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C9DD40A1E;
	Mon, 23 Mar 2026 18:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004F1C2BC9E;
	Mon, 23 Mar 2026 18:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774289144;
	bh=4YF94x65bzJ3rKIUDmxtedMV/tAeS/S9+gKVJXnd5qE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AHKvItoJGXAujQc/G8P6Gc8rqqw2ndF2rJFpzDL1wCRIM4zePKLLUYmkzEcl4rV5x
	 C9dQIrOKubc/M7z8daRTOn08rZp1JjjdrEF5HWZM/Eq5XE3bvu/GyUJruGyRc1Wh41
	 xeXWPV/3ivjsJOz9LrxSGSDT3g9tz/IE3u7wW5ThW3KCHSrdwbWdUqenmm4LlO7Odb
	 vswG3r2NfoxosJhfVYTmOKg3LA6fkMLbIqPCelZHfI4QqFYbcVlvKcbd7kQQ6YMVUo
	 ytodebTDvx9Zcc/e3Zptz0rtqxGcsPJnMCmMFBTcBJaaF8I52M8NLfU80excBckG1C
	 I1GpEc5mzI6rw==
Message-ID: <50bfaeb5-551e-403f-bd00-a7d8b6bbf6e2@kernel.org>
Date: Mon, 23 Mar 2026 19:05:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 10/16] KVM: guest_memfd: Add flag to remove from
 direct map
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
 <20260317141031.514-11-kalyazin@amazon.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260317141031.514-11-kalyazin@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 44AF61C0004
X-Stat-Signature: bbwzx8dhmsyybpca9iz35rbxrop67p67
X-Rspam-User: 
X-HE-Tag: 1774289145-395540
X-HE-Meta: U2FsdGVkX1+GrPMBfcgnFIVTXohSvee6+tcPNm99Xby6LoXYWr1CSSB6sP8IXNqiFFDz2H27OcI9HKWDDGbvlPUyoAkbjgPQmxulOGMckyWbN5Gj2XqevKqQjwzO8C96BNvYt4tCgcwXQxsdQPcxb7wfSHFiHHhoK+F/USAxheM8PR+Rg3d1Xp0P0g7sKFkMlYvEzomdgeMiPcUiqB8xGVnIFe3nSE4ckHS2cdXk9bAlKQUZVVH/9l86FnbIxg2Uoq6H/ODgdedLEmhDiCVEOtuwmww/X7/kM7prpCLbnks1XkgaGsllK0yT0KGYqs49cTlI9YNDLd5XeCUj2DizhdhDquMqwiwJfRT0PghzXir9WtJWV4Z+lkaTiIyRjV4xYE/XRjvsevzqDXBJSk2ImturhyJdIH8hEfI6DRZZkcbQ/M5OshT5BCcPRJxAWVZiNLhIsmfm2XzqePJSK3krsipzKhO6/pO6D67HYnGXA2ECuZXd3I3bv6eWpwyxJQkcEwAPQrlNG8FntplafobGLgZI+LfCaQPnS9eHECLe6YnmciBG/tHLinprAtUX6cOx/FdIq8u5X8XJDe3N9V+Ant0iZAzWHveoMFlIc5rucor1KHcmv3nPX+e6swpSIJaVArCS7WJE+GA3ZOzMSeckD7FxZ3NfBQ6ogt+RYwWGLypCSpNjZ5Fyx/NNNxCm7POaCMPHAwPArSG/jham5hUhqe59OaJHIfW+42XgkKIeP3gCRcQ2dE/gGH9i9e5ZhwZwDUoNnCvcp7CGkwYqtImWHuSNVlWR7ndTwSc4fFCrvtfsBYWtk6LKJJcgor3/pfK9/KH5GqpnweJ++dOpLt4NHznfS4BSqFhzGpzevbnk9mnhLsDYCpLtffEx7zI9HH4k426G1DchCF+Tjaf2mTMmhKSkVwy3v260ipBq8qMqVvOgnrveDNp4kMPnqrzjWBptFteTnG29MyiQfPT8Dnr
 8Jg3ZxAN
 yTLND1yGNM1NUA87jwfZgToQX3hWwUPajT61WRfiutve+XOIEH5UkICHCw5FfEDVP5AK+rz8Et72T6UbD9gROCytX62vIm1Gq54GlSRluLIMMWsJNAFQGNRzKvkgRI7eBVYf9Spq5zKWsrH3xHJSqkDKxDj4kiz3Mv4vPinVg2a/XmLmzb3TNVfil4EduUfqhxulWGTnw6LMyb0CURmkWhjz7Vk01AHZj7O65b6PZRJHd5Qf0z5DSBZ4RM0jRAoWpzgh2UTBLmyRRCiw3SPXZb1J4nexCiTiOiCSarAZNudg38aFTwmqy6xE2wE1W+ptU2ATTqCPVKd1g0Y/1Ykjh/IdyiM1j2VlLZkUjtkFJsoHfF4P17+UPs/gvJF9HpHZRNyCFXy0hbCXeKUPqFaNW1HDqpiBHtC2QtEC/C7VKnCdl44dY9rFtOpF/yojOPfB+8+bk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/17/26 15:12, Kalyazin, Nikita wrote:
> From: Patrick Roy <patrick.roy@linux.dev>
> 
> Add GUEST_MEMFD_FLAG_NO_DIRECT_MAP flag for KVM_CREATE_GUEST_MEMFD()
> ioctl. When set, guest_memfd folios will be removed from the direct map
> after preparation, with direct map entries only restored when the folios
> are freed.
> 
> To ensure these folios do not end up in places where the kernel cannot
> deal with them, set AS_NO_DIRECT_MAP on the guest_memfd's struct
> address_space if GUEST_MEMFD_FLAG_NO_DIRECT_MAP is requested.
> 
> Note that this flag causes removal of direct map entries for all
> guest_memfd folios independent of whether they are "shared" or "private"
> (although current guest_memfd only supports either all folios in the
> "shared" state, or all folios in the "private" state if
> GUEST_MEMFD_FLAG_MMAP is not set). The usecase for removing direct map
> entries of also the shared parts of guest_memfd are a special type of
> non-CoCo VM where, host userspace is trusted to have access to all of
> guest memory, but where Spectre-style transient execution attacks
> through the host kernel's direct map should still be mitigated.  In this
> setup, KVM retains access to guest memory via userspace mappings of
> guest_memfd, which are reflected back into KVM's memslots via
> userspace_addr. This is needed for things like MMIO emulation on x86_64
> to work.
> 
> Direct map entries are zapped right before guest or userspace mappings
> of gmem folios are set up, e.g. in kvm_gmem_fault_user_mapping() or
> kvm_gmem_get_pfn() [called from the KVM MMU code]. The only place where
> a gmem folio can be allocated without being mapped anywhere is
> kvm_gmem_populate(), where handling potential failures of direct map
> removal is not possible (by the time direct map removal is attempted,
> the folio is already marked as prepared, meaning attempting to re-try
> kvm_gmem_populate() would just result in -EEXIST without fixing up the
> direct map state). These folios are then removed form the direct map
> upon kvm_gmem_get_pfn(), e.g. when they are mapped into the guest later.
> 
> Signed-off-by: Patrick Roy <patrick.roy@linux.dev>

I you changed this patch significantly, you should likely add a

Co-developed-by: Nikita Kalyazin <kalyazin@amazon.com>

above your sob.

(applies to other patches as well, please double check)

> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---
>  Documentation/virt/kvm/api.rst | 21 ++++++-----
>  include/linux/kvm_host.h       |  3 ++
>  include/uapi/linux/kvm.h       |  1 +
>  virt/kvm/guest_memfd.c         | 67 ++++++++++++++++++++++++++++++++--
>  4 files changed, 79 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 032516783e96..8feec77b03fe 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6439,15 +6439,18 @@ a single guest_memfd file, but the bound ranges must not overlap).
>  The capability KVM_CAP_GUEST_MEMFD_FLAGS enumerates the `flags` that can be
>  specified via KVM_CREATE_GUEST_MEMFD.  Currently defined flags:
>  
> -  ============================ ================================================
> -  GUEST_MEMFD_FLAG_MMAP        Enable using mmap() on the guest_memfd file
> -                               descriptor.
> -  GUEST_MEMFD_FLAG_INIT_SHARED Make all memory in the file shared during
> -                               KVM_CREATE_GUEST_MEMFD (memory files created
> -                               without INIT_SHARED will be marked private).
> -                               Shared memory can be faulted into host userspace
> -                               page tables. Private memory cannot.
> -  ============================ ================================================
> +  ============================== ================================================
> +  GUEST_MEMFD_FLAG_MMAP          Enable using mmap() on the guest_memfd file
> +                                 descriptor.
> +  GUEST_MEMFD_FLAG_INIT_SHARED   Make all memory in the file shared during
> +                                 KVM_CREATE_GUEST_MEMFD (memory files created
> +                                 without INIT_SHARED will be marked private).
> +                                 Shared memory can be faulted into host userspace
> +                                 page tables. Private memory cannot.
> +  GUEST_MEMFD_FLAG_NO_DIRECT_MAP The guest_memfd instance will unmap the memory
> +                                 backing it from the kernel's address space
> +                                 before passing it off to userspace or the guest.
> +  ============================== ================================================
>  
>  When the KVM MMU performs a PFN lookup to service a guest fault and the backing
>  guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always be
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index ce8c5fdf2752..c95747e2278c 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -738,6 +738,9 @@ static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
>  	if (!kvm || kvm_arch_supports_gmem_init_shared(kvm))
>  		flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
>  
> +	if (!kvm || kvm_arch_gmem_supports_no_direct_map(kvm))
> +		flags |= GUEST_MEMFD_FLAG_NO_DIRECT_MAP;
> +
>  	return flags;
>  }
>  #endif
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 80364d4dbebb..d864f67efdb7 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1642,6 +1642,7 @@ struct kvm_memory_attributes {
>  #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
>  #define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)
>  #define GUEST_MEMFD_FLAG_INIT_SHARED	(1ULL << 1)
> +#define GUEST_MEMFD_FLAG_NO_DIRECT_MAP	(1ULL << 2)
>  
>  struct kvm_create_guest_memfd {
>  	__u64 size;
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 651649623448..c9344647579c 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -7,6 +7,7 @@
>  #include <linux/mempolicy.h>
>  #include <linux/pseudo_fs.h>
>  #include <linux/pagemap.h>
> +#include <linux/set_memory.h>
>  
>  #include "kvm_mm.h"
>  
> @@ -76,6 +77,35 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
>  	return 0;
>  }
>  
> +#define KVM_GMEM_FOLIO_NO_DIRECT_MAP BIT(0)
> +
> +static bool kvm_gmem_folio_no_direct_map(struct folio *folio)
> +{
> +	return ((u64)folio->private) & KVM_GMEM_FOLIO_NO_DIRECT_MAP;
> +}
> +
> +static int kvm_gmem_folio_zap_direct_map(struct folio *folio)
> +{
> +	u64 gmem_flags = GMEM_I(folio_inode(folio))->flags;
> +	int r = 0;
> +
> +	if (kvm_gmem_folio_no_direct_map(folio) || !(gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP))

The function is only called when

	kvm_gmem_no_direct_map(folio_inode(folio))

Does it really make sense to check for GUEST_MEMFD_FLAG_NO_DIRECT_MAP again?

If, at all, it should be a warning if GUEST_MEMFD_FLAG_NO_DIRECT_MAP is
not set?

Further, kvm_gmem_folio_zap_direct_map() uses the folio lock to
synchronize, right? Might be worth pointing that out somehow (e.g.,
lockdep check if possible).

> +		goto out;
> +
> +	r = folio_zap_direct_map(folio);
> +	if (!r)
> +		folio->private = (void *)((u64)folio->private | KVM_GMEM_FOLIO_NO_DIRECT_MAP);
> +
> +out:
> +	return r;
> +}
> +
> +static void kvm_gmem_folio_restore_direct_map(struct folio *folio)
> +{

kvm_gmem_folio_zap_direct_map() is allowed to be called on folios that
already have the directmap remove, kvm_gmem_folio_restore_direct_map()
cannot be called if the directmap was already restored.

Should we make that more consistent?


Hoping Sean can find some time to review

-- 
Cheers,

David

