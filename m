Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97202C5B567
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 18:00:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B34DA6B0092; Mon, 10 Aug 2026 14:00:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABE3E6B0093; Mon, 10 Aug 2026 14:00:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986E56B0095; Mon, 10 Aug 2026 14:00:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6AF7A6B0092
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:00:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D5E1380226
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:00:11 +0000 (UTC)
X-FDA: 85086123822.27.F41A929
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4A50C80017
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:00:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kBSXhKSR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786384810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1sdXv4xgfeUVqAkpU1fhBBhdTAgllYojDtNDqgM1IHk=;
	b=r2Hbg3KrVPagriv2ffKC3Q+FjRex+3vJXzsLcWE14HAG4SLZp//chIOQJ2U84ip/noL84C
	kW76ckrRNzTgtQlUN8mb8ZhyM6SYhwlecPN0k/0R/WYjgNTVhFEcghWJh+fyufld254v0w
	WmZcqPmUIq5NOGYs2l22EfOt5iVnxpM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kBSXhKSR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786384810;
	b=XUdGo+0Tsbk79MpnMJxaAM/U1mV0jiB4fNMRi0V0q+3IETX46KYQ8+hkmCoHNAVouNwZw5
	2HIrR/vj9tmmvkO7MxpsThdFerTpXBAxhNsvigh/ub8TPLSRzBYHjHOGWUpK4XjRaD7/9W
	EK5XHgIuj0sQY4WEk4MHLN7sKpYjxgo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4393B60120;
	Mon, 10 Aug 2026 18:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565781F000E9;
	Mon, 10 Aug 2026 17:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786384809;
	bh=1sdXv4xgfeUVqAkpU1fhBBhdTAgllYojDtNDqgM1IHk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kBSXhKSRIsXLC0eByPE+1UnsHGha7VR9YSeS1HE4WddrT+XUgckH4QaSZNBUSvJBz
	 d2DQsNEnkdz0fAI9jVlPigkinUU+sqa2swiZ7OMqNx7lIMK0gMPRWg2UyAbaUiy+Cn
	 aC8gIyLrUtkoYxh5mqTArrnu/6NdS/OZBGb71LeYxpP1/wD/GO+iT18lRLEMm9r7O0
	 fTakaW72WqyHuGbQcmcqhkwnc3yMrTYqPPselQj2nJqDAcyQhNZhevMpKg0vRL9tCd
	 S1En/+odNMPzySWeE2/TMPnoCxK3i6PbK2bhoE8RPTLqhrOElHYd00mTnJ6EXB5qhP
	 6HROY2mE8TluQ==
Date: Mon, 10 Aug 2026 18:59:34 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Alex Deucher <alexander.deucher@amd.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Boris Brezillon <boris.brezillon@collabora.com>, Steven Price <steven.price@arm.com>, 
	Liviu Dudau <liviu.dudau@arm.com>, Huang Rui <ray.huang@amd.com>, 
	Matthew Auld <matthew.auld@intel.com>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	intel-xe@lists.freedesktop.org, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/20] mm: provide vma_[flags_]is_cow_mapping() and
 remove is_cow_mapping()
Message-ID: <ann-vS6MYT9kuXqu@lucifer>
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
 <20260806-b4-scalable-cow-virt-pgoff-v4-2-ab318a350404@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806-b4-scalable-cow-virt-pgoff-v4-2-ab318a350404@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4A50C80017
X-Stat-Signature: rnp8rkt8znydnkm7gs7w9qptf3w4xx4s
X-Rspam-User: 
X-HE-Tag: 1786384810-178045
X-HE-Meta: U2FsdGVkX18Stqtv3oZZ0OEtxjlOw8cngn5A/q4EELbGyPuq7Ho9HrWtHbFIGggf3nixjJDx/PHwUd9pZ3dR0rGPDln0CDxAUEx7lX8EkuRhmv/78UCMGlcyv6P1Xf0d6l92EeF9obfok8X+F85MQqzpQgtci0KDflxJDpav0QrWJxPEmGidgNYrf0m1GJ2wYYGcSg1pIFcJxafVbXfvUwCmINErrmzrqCycGnZYLRNVPTM0WMeAGnnndKsBxFP0WkZG9RAc0rF19R+qWNuFCEbmUjr5cHuGPw25XR8GXzHJDU4yBR0251/1+cYaL+S+ZheSjZ/BdKjo7JPJeM/h0WuJtnz1PJdTB3JbEut2WTe4bDfXaUfZpSB4CrBITHeKZcKPL16wQ8P+sIJBFwtElfMpX8j5WxTWpu3dF0gJ0WAY/JZFRDh99PJ+8Npu++ZXLgE4g59ZcH0L1m2aaG/CQwvbKHsIseRINxS1pU3Lm/4sakmdMuFCOxBG5TZPV9gT0umaj/pHVKpwp9+K/Xe9U6vgxwZDV13gIgpdOBz40tagfccClfatWOaY7ovo4EMt1JMw7d4Y0jCfOsvMS8tDoUzbE9VthORRH/HjE22RKLLpZc2wCCn0UIuQip/zD/O9gVMCuhL3XaeISps2SxN4lIxp/9zoUtrIX15bMxozau2P+xuORRiJ3pyOZrDyFTU6+9jzOSuKVghxqTtjXStEYXRoglGUOOcpKhO6Txsmdm8g7o29iLjjujnAvWGJ4qDoOnctqi1j/C83mctvXSn+J3shF0HsL4tYbKoI9e1wMeJIFbPJqpVkNhCmpYCFIS1mUvplJ1u8gBi5xtzX/jowQfaBZF7QuanQ0EM1kaQKJ3Pu8w0lbzkh+wYUr+3kypUSQRtzDyJUYUt6bm7Y7rNEeVMEDR79fPaUrTXAQ8zA4ieuZbL5pURakyATZQAe3bUdr8Vv2h/L9PbzOedDwfT
 zt7ioVvt
 5UATxnEcRBbOvTWqfiIkM6iyXpE99oP2ldxig8CNRF1H5dS0+JS01LjZIUaQT1b9fGfmJkvwt6P1ssqUx17wlQeBQX4f4zLSxQ/hPV3SwWzOZ7EOXdVSRbgP6sPJhb+dzAVryLsPxOM7bCe/ATyAwbKqdpJ69/TKVXQzv+bqVJD/leT5vHi42owoZLrbdytkSD+Gw/F+pz8X6ru21HM8pwHFUp53AFj9AqZxywZT+SXMSKEFzuK0CaOYMcg/HxAMq6sCMUCaSogVXxfu06chHsKRty7AmE4lL/YD2W9PTOUDNiP3lAN6RwqqHK5xKV34Pg6X2sNJgZhjsYX4ZTQI9LD1HgftN2XlDXh4ZsmjLWZBit39+SAHtW0ar1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew - would it be possible to insert the comments added below? Trying
to avoid a respin if possible :)

On Thu, Aug 06, 2026 at 09:21:27PM +0100, Lorenzo Stoakes (ARM) wrote:
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index df78847f5f07..a3368c542947 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2271,17 +2271,20 @@ void unpin_user_pages(struct page **pages, unsigned long npages);
>  void unpin_user_folio(struct folio *folio, unsigned long npages);
>  void unpin_folios(struct folio **folios, unsigned long nfolios);
>
> -static inline bool is_cow_mapping(vm_flags_t flags)

 +/**
 + * vma_flags_is_cow_mapping() - Do these VMA flags imply a CoW mapping?
 + * @flags: The VMA flags to check.
 + *
 + * Mappings which could be CoW'd (subject to Copy-On-Write faults) are
 + * described as CoW mappings.
 + *
 + * All mappings backed by anonymous folios (all anonymous mappings and most
 + * MAP_PRIVATE-file backed ranges) are CoW mappings.
 + *
 + * All other mappings (including all writable MAP_SHARED mappings) are
 + * non-CoW.
 + *
 + * The criteria are !VMA_SHARED_BIT, VMA_MAYWRITE_BIT.
 + *
 + * VMA_MAYWRITE_BIT is checked instead of VMA_WRITE_BIT to account for both
 + * future mprotect() calls which can render a read-only mapping writable, and
 + * GUP with FOLL_FORCE (e.g. ptrace) which can CoW a read-only mapping.
 + *
 + * - No anonymous mapping can ever clear VMA_MAYWRITE_BIT.
 + *
 + * - Writes to anonymous mappings do not immediately result in CoW faults but
 + *   may do so after the process is forked or if a read is followed by a
 + *   write.
 + *
 + * - Writes to MAP_PRIVATE file-backed mappings result in CoW faults and may
 + *   do so again after fork.
 + *
 + * - MAP_SHARED mappings of a file opened read-only are transformed into
 + *   VMA_MAYSHARE_BIT, !VMA_SHARED_BIT, !VMA_MAYWRITE_BIT mappings, so remain
 + *   non-CoW.
 + *
 + * - Drivers may clear VMA_MAYWRITE_BIT but do so at mmap() time and cannot
 + *   mark themselves anonymous. Having cleared this flag it is not valid for
 + *   them to leave the VMA_WRITE_BIT flag set.
 + *
 + * As a consequence, the anonymous reverse mapping only tracks CoW mappings.
 + *
 + * Returns: true if the flags indicate a CoW mapping, otherwise false.
 + */

> +static inline bool vma_flags_is_cow_mapping(const vma_flags_t *flags)
>  {
> -	return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
> +	return vma_flags_test(flags, VMA_MAYWRITE_BIT) &&
> +		!vma_flags_test(flags, VMA_SHARED_BIT);
>  }
>

 +/**
 + * vma_is_cow_mapping() - Is this VMA a CoW mapping?
 + * @desc: The VMA to check.
 + *
 + * See vma_flags_is_cow_mapping() for details.
 + *
 + * Returns: true if the VMA is a CoW mapping, otherwise false.
 + */

> -static inline bool vma_desc_is_cow_mapping(struct vm_area_desc *desc)
> +static inline bool vma_is_cow_mapping(const struct vm_area_struct *vma)
>  {
> -	const vma_flags_t *flags = &desc->vma_flags;
> +	return vma_flags_is_cow_mapping(&vma->flags);
> +}
>
> -	return vma_flags_test(flags, VMA_MAYWRITE_BIT) &&
> -		!vma_flags_test(flags, VMA_SHARED_BIT);

 +/**
 + * vma_desc_is_cow_mapping() - Is this VMA descriptor a CoW mapping?
 + * @desc: The VMA descriptor to check.
 + *
 + * See vma_flags_is_cow_mapping() for details.
 + *
 + * Returns: true if the VMA descriptor describes a CoW mapping, otherwise
 + * false.
 + */

> +static inline bool vma_desc_is_cow_mapping(struct vm_area_desc *desc)
> +{
> +	return vma_flags_is_cow_mapping(&desc->vma_flags);
>  }
>
>  #ifndef CONFIG_MMU

--
Cheers, Lorenzo

