Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EDE4F0182E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 12:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14D546B009B; Fri,  6 Mar 2026 07:40:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E5346B009D; Fri,  6 Mar 2026 07:40:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 006CF6B009E; Fri,  6 Mar 2026 07:40:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E54CB6B009B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:40:14 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B22B61A0593
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:40:14 +0000 (UTC)
X-FDA: 84515595948.09.27B14A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id EAF46180007
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:40:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=teU+WZvc;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772800812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TpDZjWzos6QZl9FjPk//2imOO7vtv9Ovb5TykMgmnq4=;
	b=toe3OMzO1bD4nS+12+xlWlCjyhk/jn5QK48PPD/kpIDHo+Hr7H++3icrOIrKvR9ORjNErY
	casWVCeYLIwM6OnU0F54JzmlJww/63lZZ/efrnUlMHphnWwjiBmqkDXA1LDM0CpDgZ9pI+
	JrDhbd7oZUY5HRGJv3yYPqEa0Z+2MBY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=teU+WZvc;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772800812; a=rsa-sha256;
	cv=none;
	b=SC+m/3KGgjsCylNE0vRx5lVHWNw61JrsvwBxRYf/jbS2WINDY22m53u3gYZmlFx97jMmNF
	vWFQNR70fire/eXxgTCd+U2zsj79gXKBpMVgWCyltXiEO8AtXg8r92WHsIzOP+Ae3nJHp1
	HuiAw+CH0xwtXbAo/jExkbR3kT2sBW8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 466E2444A2;
	Fri,  6 Mar 2026 12:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E997C4CEF7;
	Fri,  6 Mar 2026 12:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772800810;
	bh=momqQiCPeBiESmsNjbCQuXjIElnPD5t8ixlqkLdaUNY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=teU+WZvcr3Vfjfj4PS79KVLwqpyqTY1ONa1PtwIvjXtMon6hdWoFyi7tYSgQVQlA7
	 7WqNZXjH072FsKlQxHwMb1xYD4ogJ/HhRqFMhvz7mUpomd6qDRF1LsEb2Nx0xCA20F
	 Q306mWNpenrHSDponyi32Ye/+ALDPg+T87ZCaJf9rHbmPLs7TEcXwfiNFZJ08Qk58i
	 YudRyMnPxWInwwAAt3CqHvwKRQrMAo7VQbC5DvtngGuMvZuxZUii1u78G4eRDQ1D/r
	 cgHhuLioq6MaNE+pd+1wCN6iTybUQcrEBmRwhDJWiYLDD7kyNQioEEvs3ECG9KmNxt
	 q/+pMMPgggcHw==
Date: Fri, 6 Mar 2026 12:40:07 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, 
	"linux-mm @ kvack . org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Alice Ryhl <aliceryhl@google.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>, 
	Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
	Carlos Llamas <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Dimitri Sivanich <dimitri.sivanich@hpe.com>, 
	Arnd Bergmann <arnd@arndb.de>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Andy Lutomirski <luto@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Eric Dumazet <edumazet@google.com>, 
	Neal Cardwell <ncardwell@google.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Miguel Ojeda <ojeda@kernel.org>, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
	bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v1 08/16] mm/memory: move adjusting of address range to
 unmap_vmas()
Message-ID: <6858ccdd-5065-4396-81c9-489bf2d43c9e@lucifer.local>
References: <20260227200848.114019-1-david@kernel.org>
 <20260227200848.114019-9-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227200848.114019-9-david@kernel.org>
X-Rspamd-Queue-Id: EAF46180007
X-Stat-Signature: dkzy1fdty744nk3goe64suzz8rk9ppwc
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772800811-86436
X-HE-Meta: U2FsdGVkX1+I22rwRsbRWOaiDmhzS8OfNx4SXJnRp8nqnbX3Xp7kQRzv/cfqi+hy/aNiuCja3aqOcLWAmCmS3M1m8cZbqoaLv/WWutGPDj0KrvmiI3+sUaa1w37Af0DyCEyJyazcm1VkBh59HE2VF62EPy0+LvA0s8X+BWeXddCKQN/1dnW8YLXb9ZY//VqZ1uYnLMRdsPO//mfIuqFgBTgztT3J6zAdEpJS4GfjKVY96Z6JXgQ5G1WTa7dkWsfEzFD6OidhnSkFYcD5mXlReL9N/Ts1JnSDIdcsuSobxZHQtrqCKt3L+/9/NHEYYT3ukzXArdXlWsn8zJJc1hEwKyIVgroePegGtc35x6DCP8R/W+TzsMM4nTloxwXOsBpR4zrCdKb0qRndoptGfIsC5KPRauM0XYVIWwDGMEpqbR4TXfxYtg6JpChuYyBut/bu1qHPyjA71jejCDGLAHPeqx477V9XoD3HeeLAR+Tkc/w1hniLqGZVqETfyvOySVKnP+3+4WA/WzxLNztfakJHgcokqcPeKGkDQitxzsM8iV6N4CvizwMtS0HS30iWkJRQE+rg5zbdUqGzsIhuiRTOa9r/C1Xj2E2Ccw+L/aju/CGJSYAhj2noLp7BqRJFneBEYarZ7XQMy1qQVyzSw1DGrdgaddW+fNArJNYiKIfqvGRlZYZbH8G77ryKSAcdaKwi32kT7lMPzkX92coKHhuzM16Ewd+xiFNJ5+du2PA7QFJaUft4vdQwb4Hmcf3zRRufHoMWa5dQtqbRyS7QpK5dna8WS4GAgZQQt7xGS/AzVI/viucNjwyF1rgBH5Nb80hD5oDyw1JnC/bVA5kxJlBDcWykWMe3mteQ0KYdtCV7QB16Q9aL2eUh17lxBpGYly82PRDJSV6IAKXl4RMGxCOeQ9lXZUce+AxGaPAgpH3ZOwUfg/9SpPbr5EXxMH73YfpZFElw7RMvTSJIQeZD9xk
 77f8EJZi
 P6naY9sKhD3+FhrCdCM9c2sbOt4EnEp8PSNLhNp3AHI/vNdS5ftybdBnfH07uLuDBPxknYoDeqZrZtaY58X+7r/BZ3YFNB3Dq/JZfwHp2eUuomiDumLj+b7ZMojNtF9qgpqiAdYY1Js7A6DvNnYanFoA9df4tIqsnBP9fgPJKUzjbPjttFfhmFW86Yue2XFjfbv40K5nlMwh3q4J5Q9b9emqXK+BPUZPS0fFs6JuD7dfNsmpphF9b9FQqRGVc1WQS6O76okgOG/EeNrGI5JTOrBjiQ5ZY9IDXZbaq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 09:08:39PM +0100, David Hildenbrand (Arm) wrote:
> __zap_vma_range() has two callers, whereby
> zap_page_range_single_batched() documents that the range must fit into
> the VMA range.
>
> So move adjusting the range to unmap_vmas() where it is actually
> required and add a safety check in __zap_vma_range() instead. In
> unmap_vmas(), we'd never expect to have empty ranges (otherwise, why
> have the vma in there in the first place).
>
> __zap_vma_range() will no longer be called with start == end, so
> cleanup the function a bit. While at it, simplify the overly long
> comment to its core message.
>
> We will no longer call uprobe_munmap() for start == end, which actually
> seems to be the right thing to do.
>
> Note that hugetlb_zap_begin()->...->adjust_range_if_pmd_sharing_possible()
> cannot result in the range exceeding the vma range.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM, So:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/memory.c | 58 +++++++++++++++++++++--------------------------------
>  1 file changed, 23 insertions(+), 35 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index f0aaec57a66b..fdcd2abf29c2 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2073,44 +2073,28 @@ static void unmap_page_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  	tlb_end_vma(tlb, vma);
>  }
>
> -
> -static void __zap_vma_range(struct mmu_gather *tlb,
> -		struct vm_area_struct *vma, unsigned long start_addr,
> -		unsigned long end_addr, struct zap_details *details)
> +static void __zap_vma_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
> +		unsigned long start, unsigned long end,
> +		struct zap_details *details)
>  {
> -	unsigned long start = max(vma->vm_start, start_addr);
> -	unsigned long end;
> -
> -	if (start >= vma->vm_end)
> -		return;
> -	end = min(vma->vm_end, end_addr);
> -	if (end <= vma->vm_start)
> -		return;
> +	VM_WARN_ON_ONCE(start >= end || !range_in_vma(vma, start, end));
>
>  	if (vma->vm_file)
>  		uprobe_munmap(vma, start, end);
>
> -	if (start != end) {
> -		if (unlikely(is_vm_hugetlb_page(vma))) {
> -			/*
> -			 * It is undesirable to test vma->vm_file as it
> -			 * should be non-null for valid hugetlb area.
> -			 * However, vm_file will be NULL in the error
> -			 * cleanup path of mmap_region. When
> -			 * hugetlbfs ->mmap method fails,
> -			 * mmap_region() nullifies vma->vm_file
> -			 * before calling this function to clean up.
> -			 * Since no pte has actually been setup, it is
> -			 * safe to do nothing in this case.
> -			 */
> -			if (vma->vm_file) {
> -				zap_flags_t zap_flags = details ?
> -				    details->zap_flags : 0;
> -				__unmap_hugepage_range(tlb, vma, start, end,
> -							     NULL, zap_flags);
> -			}
> -		} else
> -			unmap_page_range(tlb, vma, start, end, details);
> +	if (unlikely(is_vm_hugetlb_page(vma))) {
> +		zap_flags_t zap_flags = details ? details->zap_flags : 0;
> +
> +		/*
> +		 * vm_file will be NULL when we fail early while instantiating
> +		 * a new mapping. In this case, no pages were mapped yet and
> +		 * there is nothing to do.
> +		 */
> +		if (!vma->vm_file)
> +			return;
> +		__unmap_hugepage_range(tlb, vma, start, end, NULL, zap_flags);
> +	} else {
> +		unmap_page_range(tlb, vma, start, end, details);
>  	}
>  }
>
> @@ -2174,8 +2158,9 @@ void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap)
>  				unmap->vma_start, unmap->vma_end);
>  	mmu_notifier_invalidate_range_start(&range);
>  	do {
> -		unsigned long start = unmap->vma_start;
> -		unsigned long end = unmap->vma_end;
> +		unsigned long start = max(vma->vm_start, unmap->vma_start);
> +		unsigned long end = min(vma->vm_end, unmap->vma_end);
> +
>  		hugetlb_zap_begin(vma, &start, &end);
>  		__zap_vma_range(tlb, vma, start, end, &details);
>  		hugetlb_zap_end(vma, &details);
> @@ -2204,6 +2189,9 @@ void zap_page_range_single_batched(struct mmu_gather *tlb,
>
>  	VM_WARN_ON_ONCE(!tlb || tlb->mm != vma->vm_mm);
>
> +	if (unlikely(!size))
> +		return;
> +
>  	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
>  				address, end);
>  	hugetlb_zap_begin(vma, &range.start, &range.end);
> --
> 2.43.0
>

