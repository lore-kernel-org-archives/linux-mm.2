Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0DAEC55160
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 11:06:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9A886B0093; Thu, 30 Jul 2026 07:06:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D71A46B0098; Thu, 30 Jul 2026 07:06:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C88AF6B0099; Thu, 30 Jul 2026 07:06:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A1CF86B0093
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:06:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 366CC160988
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:06:13 +0000 (UTC)
X-FDA: 85045163826.16.D2C1A91
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf09.hostedemail.com (Postfix) with ESMTP id 54F69140008
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:06:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EW03fYGa;
	spf=pass (imf09.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785409571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4LE6yfMNyrRT4ReXlLOfvEGPMk9eH5dZ1LaQglGIzqs=;
	b=TcGEArSKi5IaNu/kLVeih14hVAbTG7UPhNFAxU3rkuIR88+TtufKHDJBwACzb4vrnjD5r9
	+Ao8LewvgWGacbnYyIx18Jb/zs9Uy1jF2ufTokubtgAi8PI+KdHWd8kKpu7S2gz6rhQYMo
	1D0MhQ6NbXM8ougQ3lva0I3DjABMnfI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785409571;
	b=wOUg9JnuBA87AhInis780l0RYgBOy9Pcs/s4k0LFNc0CahdAgNbztUtiCK5IC3nbpOpcR7
	RcRAPbabhKBEbjTGHIV2/9kEeSs/X1/9sTZJHutN7cL6ehVIJo1k10s9BDuyzlk47seS2H
	p3Gb1sBJ6fXdT0wDSX2Hv0WJamC+1Ss=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EW03fYGa;
	spf=pass (imf09.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785409571; x=1816945571;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PUZhSC1gi6rvfO8jI6WcwmVBTHNrh7lYeL/4qOTqxMM=;
  b=EW03fYGa6O3xjLEgJAELBi3yPMJLR3ggCT2tCIVdE1mfeHfrnHfRQMvU
   u5kSEeQNl9DXu/vFDDGAi8/4XgAvxvjIsUKmFpdv8l2xtg3F5URsDa6ly
   Gvte6JRfl1+eggx5Ion2H1ITeHinDCC6HVJu3psXWb7W2Gv7rt9Sop4iQ
   uz1KgayFkUJF2Im+t3+aZetFDJmiTLLG3VuqXAS7o6Pw57bKm4LhC/zvw
   /D9dX2Br0HMhIOeSH7FhYeGSR7g9mYVN0lgIi5DvQKlPWqedNVUU/lJk7
   m+9gMGD0OCb2t8bBQcEYph6LSbTSHq8+m4RhC9qVVolJZoUOWa131478+
   g==;
X-CSE-ConnectionGUID: xDcpPXN9RYi8uaEiReTB4Q==
X-CSE-MsgGUID: AJlKxDmXRR6uEAWH2Pe2Ig==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="103563715"
X-IronPort-AV: E=Sophos;i="6.25,194,1779174000"; 
   d="scan'208";a="103563715"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 04:06:09 -0700
X-CSE-ConnectionGUID: Tjl+ELBLRduZwfpbEckF6A==
X-CSE-MsgGUID: D6pCye+pTPu2j12lE2XsAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,194,1779174000"; 
   d="scan'208";a="260875994"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.238.208.132]) ([10.238.208.132])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 04:05:55 -0700
Message-ID: <60d19013-d6d7-4eec-827a-2622e22cec98@intel.com>
Date: Thu, 30 Jul 2026 19:05:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 07/41] KVM: guest_memfd: Wire up core private/shared
 attribute interfaces
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 david@kernel.org, jmattson@google.com, jthoughton@google.com,
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com,
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com,
 shivankg@amd.com, steven.price@arm.com, tabba@google.com,
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com,
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com,
 aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
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
 Peter Xu <peterx@redhat.com>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-7-35f9aec2aed2@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-7-35f9aec2aed2@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 54F69140008
X-Stat-Signature: x634499p143muped5oyw6h39cdx13d5u
X-Rspam-User: 
X-HE-Tag: 1785409570-470518
X-HE-Meta: U2FsdGVkX1+I9YT3cGbGOiKnPaIyUbhGsDhCcUiUG7+OA7EX0H8eLty3SmsY3icoXIm7vqF6u1rMNVZguzEekAPG3ZkO3o2N1Qu7RawmoGf/pdokoSiwH3b4ThSD7xm1/zkPkn2GthXt98f8qzcAOGQsZTJ8EnXsmpMSnDWRk709XA2Pc9MGVY5rSuhRyMTOa/+q2MyTdkOWdxqc6G0aMP3IxvtFCGTPRDdv6rhHJ41MRguFCoVpusjWVOw6DkOXvy2j0Nz7I0s9q+St75xLN+eCiFLQZBt5knelWWjMpSNV6QC1R6UhN+Gx4rpkO9J/I8LtEPN17iQ4dc1NAPm3eFB3rWkIkFeVlca/GPIsIjiUodfsJvde+SD31JttmxebAWB9tbDxkzIpADUuImLqo1Q+CGs9L5iXGnz/egYedgWTs66c5sxb4jaMTuQpbjuM4Zm1xowvLS8OWzCrQhwYWW/h+llPeagGlaP2rnCG1eaGPgUvDyhzy6U87DtJt2fg4JLQK3wwUpVU5E7Mb8VwyRKaguCPj7ICRRb87YqvItjReDtfy+EBEO+v4ZxZN5JPO5O06XYwjY5egNXdN1JqDdfzl/ofLHI75Q/s7dODtvHUAZmZgLWvA5dBihuG9ciUtM0lRa+TlLEYhPfg3wjFnJwuVnMdxMdtxIjmgYrrm2735AzKgXjPWgrL8y1TfScOd8ao3WDf8zFpC9dEruPBszmni0Y4nwyFAkH/YN+eBaGo3tjKDjKJG9LXVXFTSn7/4kL1CdPvV+meNcvqGrniiloWrJmxwlIWDmGm5DEjx4Syhkm45CDNii9Fy9cP7lAxyzHYVBHizVHyyStFtMAvxMCT4+FJ25BwM3nFmniT+UsJI3J0oVjm7tASIOUJptyOTMq6Ibv872yy2IMhxE3zfBdSKKRnrHK+7/s2YQV8AkgePidsyT8+ddUzc/vlMzsm9zSG8XVly8sc5GNtAoP
 kN6YP7CH
 MfVdZ+DPeH4gD+vP5NhxePo687HpywvTU4tPJGRg2B83dJjyAyCwNBmXcpxpVXCcy6ZoPwEyk4L0z06Aovr0auhDIXnIfUEcqUuGLCm08sHcGPCcQl+iHTT/qQLRNsWQ/l29Wakyt+sM5sgqb+N7qyLcknQm6Vsn8na0wkH1Ge2Xt8kzwzj4H37PwQIimPLmyLDwhN5JRP1C7uZcb2OXu8sb43XoDipmsc6gSOBR6XhLpFC8YQdHn7tg76xB0Pf6SKPHS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/2026 8:35 AM, Ackerley Tng via B4 Relay wrote:
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 33c9830190e2e..89cf922232920 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -893,6 +893,27 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>   EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
>   
>   #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
> +static bool kvm_range_is_private(struct file *file, pgoff_t index,
> +				 size_t nr_pages, struct kvm *kvm, gfn_t gfn)
> +{
> +	struct inode *inode = file_inode(file);
> +	pgoff_t last = index + nr_pages - 1;
> +	struct maple_tree *mt;
> +	void *entry;
> +
> +	if (!gmem_in_place_conversion)
> +		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
> +							  KVM_MEMORY_ATTRIBUTE_PRIVATE,
> +							  KVM_MEMORY_ATTRIBUTE_PRIVATE);
> +
> +	mt = &GMEM_I(inode)->attributes;
> +	mt_for_each(mt, entry, index, last) {
> +		if (kvm_gmem_interpret_entry(inode, entry) !=
> +		    KVM_MEMORY_ATTRIBUTE_PRIVATE)
> +			return false;
> +	}
> +	return true;
> +}
>   
>   static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
>   				struct file *file, gfn_t gfn, struct page *src_page,
> @@ -913,9 +934,7 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
>   
>   	folio_unlock(folio);
>   
> -	if (!kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + 1,
> -						KVM_MEMORY_ATTRIBUTE_PRIVATE,
> -						KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
> +	if (!kvm_range_is_private(file, index, 1, kvm, gfn)) {

It's checking if a single gfn is private.

We can just use kvm_mem_is_private()? And it seems can be a separate patch.

>   		ret = -EINVAL;
>   		goto out_put_folio;
>   	}


