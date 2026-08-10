Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0168C5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 09:36:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A31446B0098; Mon, 10 Aug 2026 05:36:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A08EB6B0099; Mon, 10 Aug 2026 05:36:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8506B009B; Mon, 10 Aug 2026 05:36:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 600E96B0098
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 05:36:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DC564406DC
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:36:47 +0000 (UTC)
X-FDA: 85084855254.02.86BCC55
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0AB4140009
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:36:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=naiOe+eg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786354606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+k/eeTx9qjkejJzGngTPDoZRvZJW0OrywFXyx2wWmks=;
	b=P/q5RvxfQ5RBBnq15EbCIkHa0k7mnGuZH8dITvnA8Vm6+yUNqmdoQ6ATGPTY4lHcwMKbqy
	mtBCtb0KFElrguViYVr8NUbA0O5OGcDMZdZxDTguIisYm6Vr3H7FuApe889lEDpBvJiiBw
	rtNrojxnRD3fMIaoBGf+lRWTngKnTT4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=naiOe+eg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786354606;
	b=QtOHifT0FZcQkeeEhRfpcGKPxeTMB7WZXADIo807RJryQI3hZZhMrHzYf/j/JIXb7FiWIg
	1/EfL1BhzphM7tkTSq+2dmyr6BkkNY1uCPUgOoS1+X5am9Olw8nAbrJskMO+oNTaxQnAXY
	JWKTwa1/dIuu426AYKpRqM5GCwxdadA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 441804145D;
	Mon, 10 Aug 2026 09:36:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6194F1F000E9;
	Mon, 10 Aug 2026 09:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786354605;
	bh=+k/eeTx9qjkejJzGngTPDoZRvZJW0OrywFXyx2wWmks=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=naiOe+egLnCkmhBy384Tr900GjqhrGJqk1C7AcedbDBvoX9KRByDtjUx4JHpXljWs
	 T+x+GF/wBLrmCAdWQr5DNEFy8+c3mJwhqlG+8nSbFbqfGOH8EO1jeBO7LT2O74f+s/
	 /FWBeqhvacxTsfe83QPHQPwTK/DabFSLKr8ro7BpI9SsZWpv3iWG9OxuqF55Ew7sx0
	 XkeYiQ7cylnP+WJsrurG/uDPOzsxQ53VD+MsluKnYFeKoZkz1OThcXBSSd4EvG2vtB
	 EuxGhzLPq5OvqTSJ+X4toQAWbBJ9FiiZi23Sj1G+LGb5zjQpnzhLpKBKIp0GiS/M52
	 eKdltieFInJGQ==
Message-ID: <82ded1ea-e0f6-48d9-8bcb-38a6bc5e9176@kernel.org>
Date: Mon, 10 Aug 2026 11:36:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 20/41] KVM: Let userspace disable per-VM mem
 attributes, enable per-gmem attributes
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com,
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com,
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com,
 steven.price@arm.com, tabba@google.com, willy@infradead.org,
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com,
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org,
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com,
 Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-20-2fc18ee6d3ba@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20260807-gmem-inplace-conversion-v10-20-2fc18ee6d3ba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: xcwxs3axt1xasgtjag3nt6n6dyet3syk
X-Rspamd-Queue-Id: 0AB4140009
X-HE-Tag: 1786354605-475008
X-HE-Meta: U2FsdGVkX1+/+PHPsvViTqbfG/Cginbowu702iHa9tXTw52K96dj82pDROvoFsC8gKhlDXu8YW83YHT9npZCKZpilw/Bo5Lqy9WMApkIzMNe/xOir0KQpdiT6fDkTYLgB6zWUBV7AzbYfq+I+dppISo+Sxe0HB+CcDvsKRSNGz4Wf6z+JUsml9EFjRiF4vyPu2c+iDPF3l15f8zP7mJGPZo/+X/ioc0oVtgO29NDD+encJXyDvYntRYyuSqQo+3L48HVsZfQWwlrAWFBJqKdtfO7FAPTa+OUXI7QYH60LIzLEcFQ9ym3BgT7qeI0qjgk6Af7SC592bMGvUvk9yvWK291ur2WTo+kLd2F3K7tEqhNY4xUFL8qqIejKxHg/ZoWuk7KUYcka10ITaZzotavFT4D/xSeomo1LkOt7OTxruSevXL5PbEGIqZZ0Ei+YNid9onmIGWpXeKdOMZyUv+ZczgFR+EEyh/d9usU6n3wrO/rUhzwp9pLSEIW8rJ/tvNcm5Eb+Sx+QFGx+U81eXc7BXX9N09ugrn0dINlIieLS+B9zUPbBog9i2bT3mLO2qtKcztHaW7x803N9LY1B9umADRGNdLJfXb4kQpzgoz3g/BVmpLJuM7lVaCw0pQuVGrgSb+fkpS1Gm/A3WV4nlYRAIxfwsvAAxAcwyOxxw9eOb0ACsO7WuW6eRynp1ZS1g66vxmGute4u2iEmPQ771iwoTBa/CUBF9NRNldV9Vwfr7F+PfMef2ltp7ahubAWYYqf2jAc4N7ogvGJBbicCUqR5Odrkup4OK4C+mc5P82lgyJA8jsf4amC8kKYysCZ82F4CjlWEZjtGdC9wJ1TbuchnRUU+COkKYYQCpt1Y0oqYhQe1ntDz+pGwyk3q3trN4qcc6dTvaCAUK1Xr7YCvPcdu/mkjzpM1wD45w3PmFSu6W6encUvKaEfw3Xwyjhxkc3pQHLsrGvTiWsQ697MBwj
 phG8DwWf
 O2NQ3GXvXuFT5m/tLqJsXtMjE9HWwaeOiCli05JjCaD4kKVfMOAakDPjXUjDSAbBx850IMTkg3ZJPMfKGq48uNRbplSg/ho+fZ2ihKmzVYksB5HtlmLpD0XAwCaelm4mlNsQnynDcF/9SaCjm83v+oTJK/LtVmXonWu+Xi+kcs5RPcPPHsgSwReyGQwR1U2XRySP9DHO+FGuhJfG8A47sEinXTidrxvtHporz5zEcoKHi6TH4j0CRvof4ED2ldyu1lvOjnvAhDgyAEXK6Z5zVudpeVzrZoJ51GcDY2bKcXG714M3DAVm4NgfN9fQou6kh5n00xTdfeYoeauQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/7/26 23:52, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Make gmem_in_place_conversion a module parameter so that userspace can
> configure enable or disable the use of VM-level memory attributes. The
> module parameter is only available if CONFIG_KVM_VM_MEMORY_ATTRIBUTES is
> enabled.
> 
> To avoid inconsistencies in the way memory attributes are tracked in KVM
> and guest_memfd, the vm_memory_attributes module_param is made
> read-only (0444).
> 
> Since selecting CONFIG_KVM_VM_MEMORY_ATTRIBUTES disables in-place
> conversion, actually make CONFIG_KVM_VM_MEMORY_ATTRIBUTES selectable. Make
> the config only selectable for (CoCo) VM types that might use
> vm_memory_attributes.
> 
> Since memory attributes are trackable in guest_memfd, the concept of having
> private memory is no longer dependent on
> CONFIG_KVM_VM_MEMORY_ATTRIBUTES. Define kvm_arch_has_private_mem() based on
> platform config, so that having private memory is dependent on (CoCo) VM
> type.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> [Define module_param only if CONFIG_KVM_VM_MEMORY_ATTRIBUTES is enabled]
> Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  4 +++-
>  arch/x86/kvm/Kconfig            | 14 ++++++++++----
>  virt/kvm/kvm_main.c             |  5 ++++-
>  3 files changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 497da6aaf2942..bb2c1ade62cf9 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1851,7 +1851,9 @@ enum kvm_intr_type {
>  	((vcpu) && (vcpu)->arch.handling_intr_from_guest && \
>  	 (!!in_nmi() == ((vcpu)->arch.handling_intr_from_guest == KVM_HANDLING_NMI)))
>  
> -#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> +#if defined(CONFIG_KVM_SW_PROTECTED_VM) ||	\
> +    defined(CONFIG_KVM_INTEL_TDX) ||		\
> +    defined(CONFIG_KVM_AMD_SEV)
>  #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
>  #endif
>  
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index abb108886733a..2c3c22aeafa54 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -81,13 +81,21 @@ config KVM_WERROR
>  	  If in doubt, say "N".
>  
>  config KVM_VM_MEMORY_ATTRIBUTES
> -	bool
> +	bool "Enable per-VM PRIVATE vs. SHARED attributes (for CoCo VMs)"
> +	depends on KVM_SW_PROTECTED_VM || KVM_INTEL_TDX || KVM_AMD_SEV
> +	help
> +	  Enable support for tracking PRIVATE vs. SHARED memory using per-VM
> +	  memory attributes.  Using per-VM attributes is deprecated in favor of
> +	  tracking PRIVATE state in guest_memfd.  Select this if you need to run
> +	  CoCo VMs using a VMM that doesn't support guest_memfd memory
> +	  attributes.
> +
> +	  If unsure, say N.

Hm, does that imply that a distribution that must support both, cannot ship a
single kernel?

-- 
Cheers,

David

