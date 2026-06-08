Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EECC1CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 11:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37ED16B00A1; Mon,  8 Jun 2026 07:30:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32FF56B00A2; Mon,  8 Jun 2026 07:30:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 245B76B00A7; Mon,  8 Jun 2026 07:30:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 177E06B00A1
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:30:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 976D940A51
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:29:59 +0000 (UTC)
X-FDA: 84856526118.30.8BF615A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 03E7C4000A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:29:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ASH3KSrE;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780918198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/bLoWkKU6zRSNbiRPvCYb7WguBa+jCqnG9JHGzaDK+M=;
	b=zn2T8SbE9jo/VnTWqmjzVKA5G8Il03WU544iXrJ69ouVvMj+u63ZE5Ii4Le3cLFnWd6lKF
	8001r+j0OQ+jQJyzhR2fP5MpWksTIG5BYSkKbYCdWJriybB46krKCkVXU+u5v4pALHB+X3
	RXHHs6D2KN1Y0x7OFXgBfjJN4bv49zw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780918198;
	b=c0oxWx8SZzJ5WNp2yhR+V2Z/lQqgRIFug5vJGqLXGWvqUd7MQMpiVUygi+y0ltdvajvm3u
	0BBS5s946HpvjzmabCf22uQ71KC4iPQx/Ias5Xn/yofQMReBAqiLXKxKSMiYGHF1dFOFpO
	n/r9gWcWLkocMEQhYejk0rUJTAzv7i0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ASH3KSrE;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 86A06600AE;
	Mon,  8 Jun 2026 11:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDB71F00893;
	Mon,  8 Jun 2026 11:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780918197;
	bh=/bLoWkKU6zRSNbiRPvCYb7WguBa+jCqnG9JHGzaDK+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ASH3KSrEWKEkMmPU3BX0LMCJuqKW/4pxjDUHNyuaL6SM94st1yY+UBI4goLs68V93
	 xnd7OdESoFQZOMFMdAjzPXWHkxJ8InnA7wG5c78nx6a3uy2I2SZH64W7OLKu1kPhJ3
	 1ghkiAapTMo1jBhiJ0AWK/++JoneEiCgcdMOxQhCr3u0pB4c6BroFlHuit7e75AntZ
	 W/smfPyMqLKIhjogXF4QMwI2r8oBBrTtbOy7b+Ewmtn2N4eq/9WGPSqVsb2d+5kov3
	 vfCEbdxDWwAstJlPPtcCTjrt5Qvli59q9GXn7RtGjvw6c32sHniQ2CeD+5je3KMGe0
	 jKEcDvloXPSUA==
Date: Mon, 8 Jun 2026 12:29:43 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, virtualization@lists.linux.dev, 
	linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>, 
	Magnus Lindholm <linmag7@gmail.com>, Greg Ungerer <gerg@linux-m68k.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v10 14/37] mm: remove arch vma_alloc_zeroed_movable_folio
 overrides
Message-ID: <aiam0zdR6BJ1HKwP@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <c374d7a35a35eb4bd5ed85f87ff6885fae605fa9.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c374d7a35a35eb4bd5ed85f87ff6885fae605fa9.1780906288.git.mst@redhat.com>
X-Rspamd-Queue-Id: 03E7C4000A
X-Rspam-User: 
X-Stat-Signature: 3zsb7zeh4xpengkp6itmwwu6wmh6qtko
X-Rspamd-Server: rspam08
X-HE-Tag: 1780918197-5430
X-HE-Meta: U2FsdGVkX18vTu5vAGfFr2+t/CMsXgIXBB03DorDdBVCyQmWro08wI6YtIMWhDd8vbaIR+cl6HuHp4DpwCSdqBuYn2Gs17OFHiQ6t06YNT7YE9uwDMKTQnknEmacbcwYkXJEy2YM9YlxH2eXjZr3NmGzezRnqNRRh0/DvwhpX41fKJRbtkdpJb1POaKJdk1o2iXCt/406Hu4NWVAbdjLIdS7tSBBpF5tonuQudxCLUpiA8+5T2Tl+oVlKLOVft9d5nJ1secxyUAoO6K+vg6FxqVUotyt7wRrNybyw6Sv2LFGzsoT6QyYJ8j4zAvcQYwHUtXK15+5YUVzeBmev5lPiMBaGMGYHOqCWnKoFxw7LVCyxTyAzVJKmfs+bI3WUgC359PhiV9JI1nRGpbMm9K++hEcYoplQBrrkkRUKPKKe6wUD2tANccEBF6LbnRFroQ4BQnGdXsbKF6weRTx0qRDuDYqgmvQhLEZJ40Pc95lBa/6WCQDWVWwOkCGuSKQSDA1XK25Dn8N6oecyAAXowcTvYjS7aaq/EFO7jEkLNhm70088VCZn2+rXGnS8/W0seh9/cpQDBMmSWfDCpZNLlglN3VobopFxlR4gtPvtSERBbKc1R418ITn8DlgT0/l1V/3dFpLuqs2jA5+SwvPYbkEvigFyc9J14AlZY17Vnuckr2vS/9xHG/YdYXCBaeZ5ky4RGQfqbJ07p79EtiObL1JvbiDqxCn9/bhzO6qOLNMgrST/uc9mNI3392iKMtECwvZNAvZuKSchmDhORPT340H5slVUTm5PookdCIAF4mc3LrO6Udi9/NDp4nQtoegXBBYv5F7zBgGi+QQhb67+KwKkxiJSJE/Gzx2y2362VbKDYH7b5ixDOe+XCNLntFom6Ok7QJ/RSQ/dWd454TwQ4R6tfHulgd9lz+dCTkdwv/vejkNN7r+GaQBChGAEcW2EAeXiZ1cx06j9A3VcAGmOTV
 Xez/+tNh
 b2eiRpQEp60RsG8GPfXxuDJSg4WFT04bN3YmuRtHkbpcRc+QbcpKSYjj2HSQ8gyrKl/K6xBWdn8R7DEEwhp+BuNsUIuj+cUFTb7MSyliVUCmCha/G4V0sfNUVTImXTHRYcQrSSGdXYvX9d5lKFeDBYNZe39VJ7uz8nMZxDUZjd0ve1j5x0n6oL1fu+OPQc+E/VmGk4RWRTsKPyLYCyAwgHL4wsS7VPPC4l9y1/ZrBFCIuGrWwa851Av4jpN2gMEyDubZIR8/FeEcT759/CK8XwZ2XcC7hiUy8YmG/IfnnreZuXgqqRWdYR3a3Gd9PpGIAE9kKtjszRC+TLzdxXCflJHmNfKQDhdYjZVMjiGjbBxuP5zw/xXn6MWPGF1IhnJxwrrp7bON8RGqgESTBe4n8iCwq9Om+0kEghq0r+sTZEwdwZkJswXhUP5hL3fzfjnsp1Hpm4KL5FhfnwAjMQpmrJbb1zO49Nn7tJHpN0AxuXCMT+5/OtTLVf30V1GQydmEKL6RdjYJd22on4Rfqy75Lw0auPVpcZ63uxdgyc12ezie3iZyoG78aQ5JLpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:37:08AM -0400, Michael S. Tsirkin wrote:
> Now that the generic vma_alloc_zeroed_movable_folio() uses
> __GFP_ZERO, the arch-specific macros on alpha, m68k, s390, and
> x86 that did the same thing are redundant.  Remove them.
>
> arm64 is not affected: it has a real function override that
> handles MTE tag zeroing, not just __GFP_ZERO.
>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Acked-by: Magnus Lindholm <linmag7@gmail.com>
> Acked-by: Greg Ungerer <gerg@linux-m68k.org>
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
> Reviewed-by: Gregory Price <gourry@gourry.net>
> ---
>  arch/alpha/include/asm/page.h   | 3 ---
>  arch/m68k/include/asm/page_no.h | 3 ---
>  arch/s390/include/asm/page.h    | 3 ---
>  arch/x86/include/asm/page.h     | 3 ---
>  include/linux/highmem.h         | 8 +++++---
>  5 files changed, 5 insertions(+), 15 deletions(-)
>
> diff --git a/arch/alpha/include/asm/page.h b/arch/alpha/include/asm/page.h
> index 59d01f9b77f6..4327029cd660 100644
> --- a/arch/alpha/include/asm/page.h
> +++ b/arch/alpha/include/asm/page.h
> @@ -12,9 +12,6 @@
>
>  extern void clear_page(void *page);
>
> -#define vma_alloc_zeroed_movable_folio(vma, vaddr) \
> -	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
> -
>  extern void copy_page(void * _to, void * _from);
>  #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
>
> diff --git a/arch/m68k/include/asm/page_no.h b/arch/m68k/include/asm/page_no.h
> index d2532bc407ef..f511b763a235 100644
> --- a/arch/m68k/include/asm/page_no.h
> +++ b/arch/m68k/include/asm/page_no.h
> @@ -12,9 +12,6 @@ extern unsigned long memory_end;
>
>  #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
>
> -#define vma_alloc_zeroed_movable_folio(vma, vaddr) \
> -	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
> -
>  #define __pa(vaddr)		((unsigned long)(vaddr))
>  #define __va(paddr)		((void *)((unsigned long)(paddr)))
>
> diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
> index 56da819a79e6..e995d2a413f9 100644
> --- a/arch/s390/include/asm/page.h
> +++ b/arch/s390/include/asm/page.h
> @@ -67,9 +67,6 @@ static inline void copy_page(void *to, void *from)
>
>  #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
>
> -#define vma_alloc_zeroed_movable_folio(vma, vaddr) \
> -	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
> -
>  #ifdef CONFIG_STRICT_MM_TYPECHECKS
>  #define STRICT_MM_TYPECHECKS
>  #endif
> diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
> index 416dc88e35c1..92fa975b46f3 100644
> --- a/arch/x86/include/asm/page.h
> +++ b/arch/x86/include/asm/page.h
> @@ -28,9 +28,6 @@ static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
>  	copy_page(to, from);
>  }
>
> -#define vma_alloc_zeroed_movable_folio(vma, vaddr) \
> -	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
> -
>  #ifndef __pa
>  #define __pa(x)		__phys_addr((unsigned long)(x))
>  #endif
> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index 8b0afaabbc6e..642718a50c27 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -303,7 +303,6 @@ static inline void clear_user_highpages(struct page *page, unsigned long vaddr,
>  #endif
>  }
>
> -#ifndef vma_alloc_zeroed_movable_folio

We're specifying this function unconditionally even though arm64 overrides?

>  /**
>   * vma_alloc_zeroed_movable_folio - Allocate a zeroed page for a VMA.
>   * @vma: The VMA the page is to be allocated for.
> @@ -317,12 +316,15 @@ static inline void clear_user_highpages(struct page *page, unsigned long vaddr,
>   * we are out of memory.
>   */
>  static inline
> -struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
> +struct folio *vma_alloc_zeroed_movable_folio_noprof(struct vm_area_struct *vma,
>  				   unsigned long vaddr)
>  {
> -	return vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO,
> +	return vma_alloc_folio_noprof(GFP_HIGHUSER_MOVABLE | __GFP_ZERO,
>  			      0, vma, vaddr);

This whole change seems unnecessary?

>  }
> +#ifndef vma_alloc_zeroed_movable_folio
> +#define vma_alloc_zeroed_movable_folio(...) \
> +	alloc_hooks(vma_alloc_zeroed_movable_folio_noprof(__VA_ARGS__))
>  #endif

I don't know why we need to add more of this alloc_hooks() dance when we could
just do:

#define vma_alloc_zeroed_movable_folio(vma, vaddr) \
	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)

Like the existing arch stuff?

>
>  static inline void clear_highpage(struct page *page)
> --
> MST
>

Thanks, Lorenzo

