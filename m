Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E48CF8FA84
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 14:43:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E83FF6B0088; Tue, 21 Apr 2026 10:43:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E34556B0089; Tue, 21 Apr 2026 10:43:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFD426B008C; Tue, 21 Apr 2026 10:43:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BE4A16B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:43:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 628A5BE4F2
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:43:56 +0000 (UTC)
X-FDA: 84682832472.26.230A32E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 82DF51A0006
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:43:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hcASPyE6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776782634; a=rsa-sha256;
	cv=none;
	b=6zUh2xgO4OESfORenwkef+NG/dR93sVKRnCNlZM5x/o5DHPufomvQxKVsyQ8h9DC/6z2ir
	p59RBn9j5Shd91J76Tcp5dsAE+HEOz4Oa4QrjImSehhfhP4SHvq/c3TUQwfmVeTKNXoN6Q
	aig1ngNzQ7RoVqdpKMeb3QqlMcFTamk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hcASPyE6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776782634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nVAlvvy1rTGOHz5vRRAsLb5KCycJtgkdeq8bKjgWlg0=;
	b=NKoNIleYNyNNo4VqchwRZHuSWgLSBTj3lvLrvMoNUlKhnvBHcU8BIsITbszZ6fZ6I3GkBt
	UATIlGD24b8iSEXqYKbFeWLeTg1d4IJ+kr8qukQFP65mIV9ekyXSpAyGs/osv6UMePTacs
	Pi31W9HXj0z1z49H/Lxqw3F6UkCOFmA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A80B434AF;
	Tue, 21 Apr 2026 14:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7693C2BCB6;
	Tue, 21 Apr 2026 14:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776782633;
	bh=4Rw2IbYIfXxvzKccqEd2MRNWsDd9e9nzdyik9zOptpY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hcASPyE6bO95pRJdB7EsU0JLG7xzku6FQgDL2e0OnQ/euUZGiZbhDjCH3KMV6SoNu
	 IsnlftL9uah1ITee1nMFBOQvcIUEQkgCqUdjLDvF6rl9qtSwlF1RooyYXyshtXoRAN
	 fEHMUceQWcnxq0eSkM0nkd5QHQ6S9nZ032O1hKoSeNbmTJyG5hLdEC3b7WB9t6+qRz
	 bMlCWwNHMKg+q6BRHw9SA9ORCHh40m7GpHHv77P73AqB3z4IhZVHog14PFtK9rJbL3
	 uA4NhmkMCTs3yxNddeZQkdgMSu7nFeGtfe89MObkKbcRuhukTukpt4V6vpPolH+Swg
	 BzEvBal94QNFQ==
Date: Tue, 21 Apr 2026 15:43:50 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "kernel@xen0n.name" <kernel@xen0n.name>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, 
	"luto@kernel.org" <luto@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, 
	"willy@infradead.org" <willy@infradead.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"david@kernel.org" <david@kernel.org>, "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, "john.fastabend@gmail.com" <john.fastabend@gmail.com>, 
	"kpsingh@kernel.org" <kpsingh@kernel.org>, "sdf@fomichev.me" <sdf@fomichev.me>, 
	"haoluo@google.com" <haoluo@google.com>, "jolsa@kernel.org" <jolsa@kernel.org>, 
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"peterx@redhat.com" <peterx@redhat.com>, "jannh@google.com" <jannh@google.com>, 
	"pfalcato@suse.de" <pfalcato@suse.de>, "skhan@linuxfoundation.org" <skhan@linuxfoundation.org>, 
	"riel@surriel.com" <riel@surriel.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"jgross@suse.com" <jgross@suse.com>, "yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, 
	"kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "yosry@kernel.org" <yosry@kernel.org>, 
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>, "maobibo@loongson.cn" <maobibo@loongson.cn>, 
	"tabba@google.com" <tabba@google.com>, "prsampat@amd.com" <prsampat@amd.com>, 
	"wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>, 
	"jmattson@google.com" <jmattson@google.com>, "jthoughton@google.com" <jthoughton@google.com>, 
	"agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, "alex@ghiti.fr" <alex@ghiti.fr>, 
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, 
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>, 
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"pjw@kernel.org" <pjw@kernel.org>, "shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, 
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "thuth@redhat.com" <thuth@redhat.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, 
	"urezki@gmail.com" <urezki@gmail.com>, "zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, 
	"gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>, "jiayuan.chen@shopee.com" <jiayuan.chen@shopee.com>, 
	"lenb@kernel.org" <lenb@kernel.org>, "pavel@kernel.org" <pavel@kernel.org>, 
	"rafael@kernel.org" <rafael@kernel.org>, "yangyicong@hisilicon.com" <yangyicong@hisilicon.com>, 
	"vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com" <jackmanb@google.com>, 
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>, "Thomson, Jack" <jackabt@amazon.co.uk>, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>
Subject: Re: [PATCH v12 01/16] set_memory: set_direct_map_* to take address
Message-ID: <aeeDvpDnGnY5n69n@lucifer>
References: <20260410151746.61150-1-kalyazin@amazon.com>
 <20260410151746.61150-2-kalyazin@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410151746.61150-2-kalyazin@amazon.com>
X-Rspamd-Server: rspam10
X-Stat-Signature: tncu5pjammju3ytz8yef6e9m4djhuw8n
X-Rspam-User: 
X-Rspamd-Queue-Id: 82DF51A0006
X-HE-Tag: 1776782634-277424
X-HE-Meta: U2FsdGVkX1/zGgZ0LWlH20BA0O2yhAtU1A0dNyK9dj7ZUW/UJaHVwTlXNMosnXIqgkhvYnZoE27aExx58jYM+GIf8QDvt6vmf4Mu6F35CGFZ/irI599TRbj6wvIgFmI2N0aosPQXpPt3AMc8/mj+4VEugeyVoiFtSbSJnsQs4JjIoaQ3fz8MBQz4X7iSxHfAwulDNlEulvUFoDR57VynxvAuqG/lj2xT4H+nuxVTo8UWkEuUbhgoyzFK0+EURuxWTdIvJIU1NF3u2kAD5+KdbwQVmppBooksvpbp/fxMYCfvocy2X252ED/PWOar/h9Jn4PV7LkhZXj6Mds1v/yjvpPQqKSo8Ct1s15Fx6wuUpppnXiZpwZB8IGafPPoEUZmllR5ZQbBAy14chB1y4Uli0TEw8ddE1p065Tv+kt+wkek9W5tMTEx14m+oSUsMXQoldVz824EYqBF8dI8mttbrCGq20j4Q4nQbqv9MOgjHD2NuA3tE1NkR6pve/iSJuFIL9dX+o+Bxi9htsbxRKsR9Kjor58K2vJacF6aCDwRo6/gISlI4z8VIfR3vGtqSXyXSoVV4c5uLCTlvkbJ2pMgj3HQ/M5FYDBtcwD3w9vjm/6c1+KoFBzMpOyISSLLaQVkkpZqRMqEAxImvh+KNi23G/LGhFf3x2F1oG13Lc89YQZLAaOXrmcByZicOJ+VqDWhh5EeFFsgloroAMb4F5B93x+8E3CtW8rIydOCNbsuQjUbUD2x5oxVHM+cRL5b9fPv5yL5YHN+qYFv3l+J9g9vZ/8LG6Ey9ugPr4XizOLl0oYDcwzlaHphUbfqsc7LojRVG4W/nwf5ytnj2dahU6ktNe6fQQQqjcrS9Yu5CUxkjm3WhrPPB1FXNoKA9S3EFg64WBPZblysPYr9HaCtP0WbueFwTMnP/z18tIUq7Jkqh0+pX9CpXvaui6qJ20k1nVu2kdtvBcWDKHlp007wajY
 YmDaRNVr
 uMNNuxjOYavX5FvYqY2shygbMr1rClfmttiMYJXMwMz9+Nc+KfU23spyDEyVp4t8vu0a3MOPIqxR0IQ0EtaalrsSrh1IGlK5IUDevs8CasZCbUWL8ujyrIegTxueXxS0K6C3J3AgFH1d2j7sd+9gUsD1IhnUD3cKL+BuGtHH3OWAXILbegrsyuXjjZxQ+9ojHyujQkIyXZD7AqBYhfWzh+xszuS6Mlnb1F5ZsEhw9KCOvgfOXftuzneeF28piD8Ldj9RvaA3dbR6yknSnI7Img+1D3MsNC2WgW2+sOj94qcyZFE5VlMunI9MDHsaOduESIjp2/9Jw7oaGBgZ7KT8fFNXCZrqyxYAdA3gLAeNA1bruu0yfyacMI4aBOphXc4SelCXounj7zbL3O/D6cgR+F/tB+U70a8OosgeybkALm9r5uK+ja+hgpwBkcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 03:17:58PM +0000, Kalyazin, Nikita wrote:
> From: Nikita Kalyazin <nikita.kalyazin@linux.dev>
>
> Let's convert set_direct_map_*() to take an address instead of a page to
> prepare for adding helpers that operate on folios; it will be more
> efficient to convert from a folio directly to an address without going
> through a page first.

Hmm presumably these addresses have to be page-aligned? But now they might not
be _in theory_?

Is it clear to callers that they should pass page-aligned pointers? Might we
have an issue in future with somebody passing something unaligned?

>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>

The logic looks good to me, just various stylistic issues and concerns about
alignment for future callers.

> ---
>  arch/arm64/include/asm/set_memory.h     |  7 ++++---
>  arch/arm64/mm/pageattr.c                | 19 +++++++++--------
>  arch/loongarch/include/asm/set_memory.h |  7 ++++---
>  arch/loongarch/mm/pageattr.c            | 25 ++++++++++-------------
>  arch/riscv/include/asm/set_memory.h     |  7 ++++---
>  arch/riscv/mm/pageattr.c                | 17 ++++++++--------
>  arch/s390/include/asm/set_memory.h      |  7 ++++---
>  arch/s390/mm/pageattr.c                 | 13 ++++++------
>  arch/x86/include/asm/set_memory.h       |  7 ++++---
>  arch/x86/mm/pat/set_memory.c            | 27 +++++++++++++------------
>  include/linux/set_memory.h              |  9 +++++----
>  kernel/power/snapshot.c                 |  4 ++--
>  mm/execmem.c                            |  6 ++++--
>  mm/secretmem.c                          |  6 +++---
>  mm/vmalloc.c                            | 11 ++++++----
>  15 files changed, 91 insertions(+), 81 deletions(-)
>
> diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
> index 90f61b17275e..c71a2a6812c4 100644
> --- a/arch/arm64/include/asm/set_memory.h
> +++ b/arch/arm64/include/asm/set_memory.h
> @@ -11,9 +11,10 @@ bool can_set_direct_map(void);
>
>  int set_memory_valid(unsigned long addr, int numpages, int enable);
>
> -int set_direct_map_invalid_noflush(struct page *page);
> -int set_direct_map_default_noflush(struct page *page);
> -int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
> +int set_direct_map_invalid_noflush(const void *addr);
> +int set_direct_map_default_noflush(const void *addr);
> +int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,
> +				 bool valid);

I mean it's nitty, but it's weird having these being called 'addr' when they're
not giving you an address, they're giving you pointers to something.

E.g. if I have a 'struct vm_area_struct *vma' and I do *vma I get a VMA. If I do
a *addr here I get a... hmm :)

This looks to be a long-standing issue with page_address() (and probably,
necessarily, folio_address()). But still...

It causes you issues later, somewhat trivial ones but still, where you have
something like:

unsigned long addr = (unsigned long)page_address(page);

And now have a void *addr...

Maybe 'page_start' or something like that makes it clear that these need to be
page-aligned. Or plain 'ptr' works too? 'page_ptr'? Naming's hard :)

Would it be overly difficult to simply pass the addr as an unsigned long?

Also a const void * is iffy from a type safety point of view, because somebody
might not have got the memo, adds some code to that hands a struct page * and
there'd be no compiler issues. Obv. the same with unaligned stuff.

Using an unsigned long would avoid that (not the alignment issue though
obviously, but could imply that with param name maybe).

>  bool kernel_page_present(struct page *page);
>
>  int set_memory_encrypted(unsigned long addr, int numpages);
> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> index 358d1dc9a576..5aff94e1f8b2 100644
> --- a/arch/arm64/mm/pageattr.c
> +++ b/arch/arm64/mm/pageattr.c
> @@ -245,7 +245,7 @@ int set_memory_valid(unsigned long addr, int numpages, int enable)
>  					__pgprot(PTE_VALID));
>  }
>
> -int set_direct_map_invalid_noflush(struct page *page)
> +int set_direct_map_invalid_noflush(const void *addr)
>  {
>  	pgprot_t clear_mask = __pgprot(PTE_VALID);
>  	pgprot_t set_mask = __pgprot(0);
> @@ -253,11 +253,11 @@ int set_direct_map_invalid_noflush(struct page *page)
>  	if (!can_set_direct_map())
>  		return 0;
>
> -	return update_range_prot((unsigned long)page_address(page),
> -				 PAGE_SIZE, set_mask, clear_mask);
> +	return update_range_prot((unsigned long)addr, PAGE_SIZE, set_mask,
> +				 clear_mask);
>  }
>
> -int set_direct_map_default_noflush(struct page *page)
> +int set_direct_map_default_noflush(const void *addr)
>  {
>  	pgprot_t set_mask = __pgprot(PTE_VALID | PTE_WRITE);
>  	pgprot_t clear_mask = __pgprot(PTE_RDONLY);
> @@ -265,8 +265,8 @@ int set_direct_map_default_noflush(struct page *page)
>  	if (!can_set_direct_map())
>  		return 0;
>
> -	return update_range_prot((unsigned long)page_address(page),
> -				 PAGE_SIZE, set_mask, clear_mask);
> +	return update_range_prot((unsigned long)addr, PAGE_SIZE, set_mask,
> +				 clear_mask);
>  }
>
>  static int __set_memory_enc_dec(unsigned long addr,
> @@ -349,14 +349,13 @@ int realm_register_memory_enc_ops(void)
>  	return arm64_mem_crypt_ops_register(&realm_crypt_ops);
>  }
>
> -int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
> +int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,
> +				 bool valid)
>  {
> -	unsigned long addr = (unsigned long)page_address(page);

NIT, but maybe less churny to keep this and make it (unsigned long)addr?

OTOH is more consistent with other stuff to do the way you have, so optional.

I kinda like spelling things out like this though.

> -
>  	if (!can_set_direct_map())
>  		return 0;
>
> -	return set_memory_valid(addr, nr, valid);
> +	return set_memory_valid((unsigned long)addr, numpages, valid);

Yeah I mean (unsigned long)addr looks really weird to me, nearly always 'addr'
references an address value like unsigned long in mm so :)

>  }
>
>  #ifdef CONFIG_DEBUG_PAGEALLOC
> diff --git a/arch/loongarch/include/asm/set_memory.h b/arch/loongarch/include/asm/set_memory.h
> index 55dfaefd02c8..5e9b67b2fea1 100644
> --- a/arch/loongarch/include/asm/set_memory.h
> +++ b/arch/loongarch/include/asm/set_memory.h
> @@ -15,8 +15,9 @@ int set_memory_ro(unsigned long addr, int numpages);
>  int set_memory_rw(unsigned long addr, int numpages);
>
>  bool kernel_page_present(struct page *page);
> -int set_direct_map_default_noflush(struct page *page);
> -int set_direct_map_invalid_noflush(struct page *page);
> -int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
> +int set_direct_map_invalid_noflush(const void *addr);
> +int set_direct_map_default_noflush(const void *addr);
> +int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,
> +				 bool valid);
>
>  #endif /* _ASM_LOONGARCH_SET_MEMORY_H */
> diff --git a/arch/loongarch/mm/pageattr.c b/arch/loongarch/mm/pageattr.c
> index f5e910b68229..9e08905d3624 100644
> --- a/arch/loongarch/mm/pageattr.c
> +++ b/arch/loongarch/mm/pageattr.c
> @@ -198,32 +198,29 @@ bool kernel_page_present(struct page *page)
>  	return pte_present(ptep_get(pte));
>  }
>
> -int set_direct_map_default_noflush(struct page *page)
> +int set_direct_map_default_noflush(const void *addr)
>  {
> -	unsigned long addr = (unsigned long)page_address(page);

OK we definitely need to de-duplicate here, repeatedly doing (unsigned long)addr
is a bit silly.

Also if you do, please const-ify the value.

> -
> -	if (addr < vm_map_base)
> +	if ((unsigned long)addr < vm_map_base)
>  		return 0;
>
> -	return __set_memory(addr, 1, PAGE_KERNEL, __pgprot(0));
> +	return __set_memory((unsigned long)addr, 1, PAGE_KERNEL, __pgprot(0));
>  }
>
> -int set_direct_map_invalid_noflush(struct page *page)
> +int set_direct_map_invalid_noflush(const void *addr)
>  {
> -	unsigned long addr = (unsigned long)page_address(page);
> -
> -	if (addr < vm_map_base)
> +	if ((unsigned long)addr < vm_map_base)
>  		return 0;
>
> -	return __set_memory(addr, 1, __pgprot(0), __pgprot(_PAGE_PRESENT | _PAGE_VALID));
> +	return __set_memory((unsigned long)addr, 1, __pgprot(0),
> +			    __pgprot(_PAGE_PRESENT | _PAGE_VALID));

Same here... We could avoid most of the churn here altogether by saying ptr
instead of addr and just changing the addr = bit :)

>  }
>
> -int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
> +int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,
> +				 bool valid)
>  {
> -	unsigned long addr = (unsigned long)page_address(page);
>  	pgprot_t set, clear;
>
> -	if (addr < vm_map_base)
> +	if ((unsigned long)addr < vm_map_base)
>  		return 0;
>
>  	if (valid) {
> @@ -234,5 +231,5 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
>  		clear = __pgprot(_PAGE_PRESENT | _PAGE_VALID);
>  	}
>
> -	return __set_memory(addr, 1, set, clear);
> +	return __set_memory((unsigned long)addr, 1, set, clear);

Obv. same comments here and below, I will stop duplicating them, just assume
they apply to the whole thing :)

>  }
> diff --git a/arch/riscv/include/asm/set_memory.h b/arch/riscv/include/asm/set_memory.h
> index 87389e93325a..a87eabd7fc78 100644
> --- a/arch/riscv/include/asm/set_memory.h
> +++ b/arch/riscv/include/asm/set_memory.h
> @@ -40,9 +40,10 @@ static inline int set_kernel_memory(char *startp, char *endp,
>  }
>  #endif
>
> -int set_direct_map_invalid_noflush(struct page *page);
> -int set_direct_map_default_noflush(struct page *page);
> -int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
> +int set_direct_map_invalid_noflush(const void *addr);
> +int set_direct_map_default_noflush(const void *addr);
> +int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,
> +				 bool valid);
>  bool kernel_page_present(struct page *page);
>
>  #endif /* __ASSEMBLER__ */
> diff --git a/arch/riscv/mm/pageattr.c b/arch/riscv/mm/pageattr.c
> index 3f76db3d2769..0a457177a88c 100644
> --- a/arch/riscv/mm/pageattr.c
> +++ b/arch/riscv/mm/pageattr.c
> @@ -374,19 +374,20 @@ int set_memory_nx(unsigned long addr, int numpages)
>  	return __set_memory(addr, numpages, __pgprot(0), __pgprot(_PAGE_EXEC));
>  }
>
> -int set_direct_map_invalid_noflush(struct page *page)
> +int set_direct_map_invalid_noflush(const void *addr)
>  {
> -	return __set_memory((unsigned long)page_address(page), 1,
> -			    __pgprot(0), __pgprot(_PAGE_PRESENT));
> +	return __set_memory((unsigned long)addr, 1, __pgprot(0),
> +			    __pgprot(_PAGE_PRESENT));
>  }
>
> -int set_direct_map_default_noflush(struct page *page)
> +int set_direct_map_default_noflush(const void *addr)
>  {
> -	return __set_memory((unsigned long)page_address(page), 1,
> -			    PAGE_KERNEL, __pgprot(_PAGE_EXEC));
> +	return __set_memory((unsigned long)addr, 1, PAGE_KERNEL,
> +			    __pgprot(_PAGE_EXEC));
>  }
>
> -int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
> +int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,
> +				 bool valid)
>  {
>  	pgprot_t set, clear;
>
> @@ -398,7 +399,7 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
>  		clear = __pgprot(_PAGE_PRESENT);
>  	}
>
> -	return __set_memory((unsigned long)page_address(page), nr, set, clear);
> +	return __set_memory((unsigned long)addr, numpages, set, clear);
>  }
>
>  #ifdef CONFIG_DEBUG_PAGEALLOC
> diff --git a/arch/s390/include/asm/set_memory.h b/arch/s390/include/asm/set_memory.h
> index 94092f4ae764..3e43c3c96e67 100644
> --- a/arch/s390/include/asm/set_memory.h
> +++ b/arch/s390/include/asm/set_memory.h
> @@ -60,9 +60,10 @@ __SET_MEMORY_FUNC(set_memory_rox, SET_MEMORY_RO | SET_MEMORY_X)
>  __SET_MEMORY_FUNC(set_memory_rwnx, SET_MEMORY_RW | SET_MEMORY_NX)
>  __SET_MEMORY_FUNC(set_memory_4k, SET_MEMORY_4K)
>
> -int set_direct_map_invalid_noflush(struct page *page);
> -int set_direct_map_default_noflush(struct page *page);
> -int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
> +int set_direct_map_invalid_noflush(const void *addr);
> +int set_direct_map_default_noflush(const void *addr);
> +int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,
> +				 bool valid);
>  bool kernel_page_present(struct page *page);
>
>  #endif
> diff --git a/arch/s390/mm/pageattr.c b/arch/s390/mm/pageattr.c
> index bb29c38ae624..8e90ff5cf50d 100644
> --- a/arch/s390/mm/pageattr.c
> +++ b/arch/s390/mm/pageattr.c
> @@ -383,17 +383,18 @@ int __set_memory(unsigned long addr, unsigned long numpages, unsigned long flags
>  	return rc;
>  }
>
> -int set_direct_map_invalid_noflush(struct page *page)
> +int set_direct_map_invalid_noflush(const void *addr)
>  {
> -	return __set_memory((unsigned long)page_to_virt(page), 1, SET_MEMORY_INV);
> +	return __set_memory((unsigned long)addr, 1, SET_MEMORY_INV);
>  }
>
> -int set_direct_map_default_noflush(struct page *page)
> +int set_direct_map_default_noflush(const void *addr)
>  {
> -	return __set_memory((unsigned long)page_to_virt(page), 1, SET_MEMORY_DEF);
> +	return __set_memory((unsigned long)addr, 1, SET_MEMORY_DEF);
>  }
>
> -int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
> +int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,

Why changing to numpages? I guess because it's not obvious what it's a count
of...

This really makes me think we're kinda making this interface a bit worse,
because before it had to be 'nr' pages, but now it's 'numpages of err something
starting at addr which isn't an address but a pointer and might not be aligned'.

If you called this 'page_ptr' then nr would be implicit and could be kept the
same I guess?

> +				 bool valid)
>  {
>  	unsigned long flags;
>
> @@ -402,7 +403,7 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
>  	else
>  		flags = SET_MEMORY_INV;
>
> -	return __set_memory((unsigned long)page_to_virt(page), nr, flags);
> +	return __set_memory((unsigned long)addr, numpages, flags);
>  }
>
>  bool kernel_page_present(struct page *page)
> diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
> index 4362c26aa992..b6a4173ff249 100644
> --- a/arch/x86/include/asm/set_memory.h
> +++ b/arch/x86/include/asm/set_memory.h
> @@ -86,9 +86,10 @@ int set_pages_wb(struct page *page, int numpages);
>  int set_pages_ro(struct page *page, int numpages);
>  int set_pages_rw(struct page *page, int numpages);
>
> -int set_direct_map_invalid_noflush(struct page *page);
> -int set_direct_map_default_noflush(struct page *page);
> -int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
> +int set_direct_map_invalid_noflush(const void *addr);
> +int set_direct_map_default_noflush(const void *addr);
> +int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,
> +				 bool valid);
>  bool kernel_page_present(struct page *page);
>
>  extern int kernel_set_to_readonly;
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index 40581a720fe8..7517195b75b9 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -2587,9 +2587,9 @@ int set_pages_rw(struct page *page, int numpages)
>  	return set_memory_rw(addr, numpages);
>  }
>
> -static int __set_pages_p(struct page *page, int numpages)
> +static int __set_pages_p(const void *addr, int numpages)
>  {
> -	unsigned long tempaddr = (unsigned long) page_address(page);
> +	unsigned long tempaddr = (unsigned long)addr;
>  	struct cpa_data cpa = { .vaddr = &tempaddr,
>  				.pgd = NULL,
>  				.numpages = numpages,
> @@ -2606,9 +2606,9 @@ static int __set_pages_p(struct page *page, int numpages)
>  	return __change_page_attr_set_clr(&cpa, 1);
>  }
>
> -static int __set_pages_np(struct page *page, int numpages)
> +static int __set_pages_np(const void *addr, int numpages)
>  {
> -	unsigned long tempaddr = (unsigned long) page_address(page);
> +	unsigned long tempaddr = (unsigned long)addr;

This is even more horrid, tempaddr and addr, but different types...

Also let's please const-ify these kinds of local vars.

>  	struct cpa_data cpa = { .vaddr = &tempaddr,
>  				.pgd = NULL,
>  				.numpages = numpages,
> @@ -2625,22 +2625,23 @@ static int __set_pages_np(struct page *page, int numpages)
>  	return __change_page_attr_set_clr(&cpa, 1);
>  }
>
> -int set_direct_map_invalid_noflush(struct page *page)
> +int set_direct_map_invalid_noflush(const void *addr)
>  {
> -	return __set_pages_np(page, 1);
> +	return __set_pages_np(addr, 1);
>  }
>
> -int set_direct_map_default_noflush(struct page *page)
> +int set_direct_map_default_noflush(const void *addr)
>  {
> -	return __set_pages_p(page, 1);
> +	return __set_pages_p(addr, 1);
>  }
>
> -int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
> +int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,
> +				 bool valid)
>  {
>  	if (valid)
> -		return __set_pages_p(page, nr);
> +		return __set_pages_p(addr, numpages);
>
> -	return __set_pages_np(page, nr);
> +	return __set_pages_np(addr, numpages);
>  }
>
>  #ifdef CONFIG_DEBUG_PAGEALLOC
> @@ -2659,9 +2660,9 @@ void __kernel_map_pages(struct page *page, int numpages, int enable)
>  	 * and hence no memory allocations during large page split.
>  	 */
>  	if (enable)
> -		__set_pages_p(page, numpages);
> +		__set_pages_p(page_address(page), numpages);
>  	else
> -		__set_pages_np(page, numpages);
> +		__set_pages_np(page_address(page), numpages);
>
>  	/*
>  	 * We should perform an IPI and flush all tlbs,
> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> index 3030d9245f5a..1a2563f525fc 100644
> --- a/include/linux/set_memory.h
> +++ b/include/linux/set_memory.h
> @@ -25,17 +25,18 @@ static inline int set_memory_rox(unsigned long addr, int numpages)
>  #endif
>
>  #ifndef CONFIG_ARCH_HAS_SET_DIRECT_MAP
> -static inline int set_direct_map_invalid_noflush(struct page *page)
> +static inline int set_direct_map_invalid_noflush(const void *addr)
>  {
>  	return 0;
>  }
> -static inline int set_direct_map_default_noflush(struct page *page)
> +static inline int set_direct_map_default_noflush(const void *addr)
>  {
>  	return 0;
>  }
>
> -static inline int set_direct_map_valid_noflush(struct page *page,
> -					       unsigned nr, bool valid)
> +static inline int set_direct_map_valid_noflush(const void *addr,
> +					       unsigned long numpages,
> +					       bool valid)
>  {
>  	return 0;
>  }
> diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
> index 6e1321837c66..6eddfb22c0ff 100644
> --- a/kernel/power/snapshot.c
> +++ b/kernel/power/snapshot.c
> @@ -88,7 +88,7 @@ static inline int hibernate_restore_unprotect_page(void *page_address) {return 0
>  static inline void hibernate_map_page(struct page *page)
>  {
>  	if (IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
> -		int ret = set_direct_map_default_noflush(page);
> +		int ret = set_direct_map_default_noflush(page_address(page));
>
>  		if (ret)
>  			pr_warn_once("Failed to remap page\n");
> @@ -101,7 +101,7 @@ static inline void hibernate_unmap_page(struct page *page)
>  {
>  	if (IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
>  		unsigned long addr = (unsigned long)page_address(page);
> -		int ret  = set_direct_map_invalid_noflush(page);
> +		int ret  = set_direct_map_invalid_noflush(page_address(page));
>
>  		if (ret)
>  			pr_warn_once("Failed to remap page\n");
> diff --git a/mm/execmem.c b/mm/execmem.c
> index 810a4ba9c924..220298ec87c8 100644
> --- a/mm/execmem.c
> +++ b/mm/execmem.c
> @@ -119,7 +119,8 @@ static int execmem_set_direct_map_valid(struct vm_struct *vm, bool valid)
>  	int err = 0;
>
>  	for (int i = 0; i < vm->nr_pages; i += nr) {
> -		err = set_direct_map_valid_noflush(vm->pages[i], nr, valid);
> +		err = set_direct_map_valid_noflush(page_address(vm->pages[i]),
> +						   nr, valid);
>  		if (err)
>  			goto err_restore;
>  		updated += nr;
> @@ -129,7 +130,8 @@ static int execmem_set_direct_map_valid(struct vm_struct *vm, bool valid)
>
>  err_restore:
>  	for (int i = 0; i < updated; i += nr)
> -		set_direct_map_valid_noflush(vm->pages[i], nr, !valid);
> +		set_direct_map_valid_noflush(page_address(vm->pages[i]), nr,
> +					     !valid);
>
>  	return err;
>  }
> diff --git a/mm/secretmem.c b/mm/secretmem.c
> index 11a779c812a7..fd29b33c6764 100644
> --- a/mm/secretmem.c
> +++ b/mm/secretmem.c
> @@ -72,7 +72,7 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
>  			goto out;
>  		}
>
> -		err = set_direct_map_invalid_noflush(folio_page(folio, 0));
> +		err = set_direct_map_invalid_noflush(folio_address(folio));
>  		if (err) {
>  			folio_put(folio);
>  			ret = vmf_error(err);
> @@ -87,7 +87,7 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
>  			 * already happened when we marked the page invalid
>  			 * which guarantees that this call won't fail
>  			 */
> -			set_direct_map_default_noflush(folio_page(folio, 0));
> +			set_direct_map_default_noflush(folio_address(folio));
>  			folio_put(folio);
>  			if (err == -EEXIST)
>  				goto retry;
> @@ -151,7 +151,7 @@ static int secretmem_migrate_folio(struct address_space *mapping,
>
>  static void secretmem_free_folio(struct folio *folio)
>  {
> -	set_direct_map_default_noflush(folio_page(folio, 0));
> +	set_direct_map_default_noflush(folio_address(folio));
>  	folio_zero_segment(folio, 0, folio_size(folio));
>  }
>
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 61caa55a4402..8822f73957d9 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3342,14 +3342,17 @@ struct vm_struct *remove_vm_area(const void *addr)
>  }
>
>  static inline void set_area_direct_map(const struct vm_struct *area,
> -				       int (*set_direct_map)(struct page *page))
> +				       int (*set_direct_map)(const void *addr))
>  {
>  	int i;
>
>  	/* HUGE_VMALLOC passes small pages to set_direct_map */
> -	for (i = 0; i < area->nr_pages; i++)
> -		if (page_address(area->pages[i]))
> -			set_direct_map(area->pages[i]);
> +	for (i = 0; i < area->nr_pages; i++) {
> +		const void *addr = page_address(area->pages[i]);
> +
> +		if (addr)
> +			set_direct_map(addr);
> +	}
>  }
>
>  /*
> --
> 2.50.1
>

Cheers, Lorenzo

