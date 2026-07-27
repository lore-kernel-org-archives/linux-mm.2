Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 224C4C53219
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 10:33:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DC826B0088; Mon, 27 Jul 2026 06:33:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18F2E6B00AE; Mon, 27 Jul 2026 06:33:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 080646B00AF; Mon, 27 Jul 2026 06:33:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C89316B0088
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 06:33:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3799AA158D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:33:27 +0000 (UTC)
X-FDA: 85034194854.23.4B21BCB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id A2114120007
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:33:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NEL+gJot;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785148405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oLJKZY7z9oL/tDHGyMnLb4jets030xYxa9/DOs/wndk=;
	b=wnLRmuqlCjxVwxYjnXzonBuGRteUQearRUVERQJFeiSAnKRyJcA4ZhHZBw5SUaATcH5mAJ
	+NhlLFv2ZGDKZwNWF+iqjIopo7rB/Gs4OO1crSpUtlfIx1WCCAcVVtXoarCAExF/RYJcDP
	6O1WNiNY+TIAe77VqLNWA6VN6coZd/Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NEL+gJot;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785148405;
	b=DLeVhaotBVvtV4ySVJseRTnHUa9KDI044twZEHtKAb8xUyG/FKHe7WS6MSYTnUItxAe6ly
	HltitX0x/SWAWH1BdyjinX8QnPMpleOQTqa4WPZoC1bs/P5/oAt2Kwpyg5FYx1JxxPJkVD
	z8jbrA87bhk8PPeg6NlLqGIJjkAzjL0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D6EC7601DE;
	Mon, 27 Jul 2026 10:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB8F1F000E9;
	Mon, 27 Jul 2026 10:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785148404;
	bh=oLJKZY7z9oL/tDHGyMnLb4jets030xYxa9/DOs/wndk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NEL+gJotI4dzLjO9dpkIY9A6naUXytugt48e7S6cNGGLhqDAlEf4EEf+PRSGPnkGD
	 uVB/Hxp4blbinusmWXl1UO4H6pmuENcYVdbU6eWFwD+QDEtlwlVeEM4vq1XG5dSrUT
	 963kDoDbmzeJ/hfJwChw0GQYl/QfyV+yV49ZM5GKzd17YuSO3rCZM7fFmosSlupDIp
	 zqwiLIu76mzvm3nZfM4Jlfnmodbk9RoGTw50I7NH43ZZ9B2r19tlKl0PsvaZHBfOqF
	 f+H/KKPy1hZ+nW2dEtqLp0kHP4cVxcMY4lK9JTXzAE4svZGx3vNzy2xoi/wf92Kfo4
	 LkOtZPt/FqDSw==
Date: Mon, 27 Jul 2026 13:33:12 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>, rientjes@google.com,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev,
	"Itazuri, Takahiro" <itazur@amazon.co.uk>,
	Andy Lutomirski <luto@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>,
	Patrick Bellasi <derkling@google.com>,
	Reiji Watanabe <reijiw@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Nikita Kalyazin <nikita.kalyazin@linux.dev>
Subject: Re: [PATCH v3 01/26] set_memory: add folio_{zap,restore}_direct_map
 helpers
Message-ID: <amcz6OxsJPjr5hIr@kernel.org>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-1-6f5729aa9832@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726-page_alloc-unmapped-v3-1-6f5729aa9832@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A2114120007
X-Stat-Signature: e587wuga4xmxiihs1h1dzwu4jpjyk8sx
X-HE-Tag: 1785148405-444504
X-HE-Meta: U2FsdGVkX1/u1uuZLI2Dah3HxDp+9QSehfgcgCb0sucMJnwrTFFBC2kuHzW99y9UAKMUOwOCrJvhRdnQ/kt0IkvoHk4gsGXS15U8eO7EqTVgFTLUhTkAp4rp26ANKQNeQMeILRSnALK8nAE7i4j916iVN3siEQpIeIqXA/3oKIxPQ73uUC0KnQkZKIggFhcWoGVsUeZoG79L/atMmJXdM8mw28IFORXAQ1t+jLrsQyPWbzGtdHsxLsyeZ1rOK6Tz10BfV3V4mAeD8Gx5ve1e0ck2DZRkK3gK0EsOTT+sPw2OCBUA38168EtjDoxMQnd3DUaKmjNSuWw++gtYGn++YOJOhafuJm9lObta9zjD9oHBN0pzhe4c/T+JeUfO996O0IXNAfTANMV/QqAfhbN2Smb0IMAxYzAeeexVl77dqNZje6ARvFgQv8CimuwCNLGGJpEAMET9aIDHWLGbm4wH9TOL7RNzaswPNue0n3K28hrCQl5Tqfyj3/cEt0Dawiiv98OoQvuLbGMkE+sfwrQlW3WK9gaIp4KgTosNZqtxAFzRHNS/b43CpQYr9n5hwPdMQY4WuK4w1EI5hSYub7RrDheezql9ib0osPDnXFbWNb/IWMmDpqghrDl/X0agUeib3roTB+6b1/EgK4g0v4GzalinZgKCgL+L1F7n5M1BjxDy/ss1zSKEAoFSQnaXyVKBuABDYtMaVc8xObGDWvi/wRKQYAXuLWGwmcrCpHHuZyId4nh61IqsZs2oFve1Spn0upzS2XGS/oEo6N9LbrGJGmyb8TzxL2OMCacTmjB+R2s/rfTrwQqytTmfVfXVOznjUXYsl+mSYzDXWt3T9VJo7qTwzuzzGheHKorhes6WVyXMXKt7DIt3Sq7T9dnqD1LneRkWhOXOkBKexM8662PaMPH0IJiNjjA9IpUPkuBlCgFKfJjb41lBCSuwl7YMHdaTskrvloS3/u9bbK3YARH
 OA8f/PIR
 Qxh6APW5pNfk1wagQLoLIajY2dqlVAdkvgE7chQZzcaKx9mZtNlSbbaoVO3au3eYEy1yRxC1R3ufLzBM8K5dJdVvT6ginA5v+875I8OfGqEKNfjUYjvcczETccS9rIWERH6Xiu7iNceQz8M1xSjaIQBXBJZ/nry3Mcml7cwOBvYU/oC/t0muQIARcghng5iGL0FggaxVikYdozVOrCKY4cn3wR4qNtHEgYsjBE1n3sELleEbLwg0d5lHNuZIIc1giAz5d83o3thSgWMu17nsO0aTIMoPoOKGIgANdEEecFlaZfbiG9Gsuhvgl7j4Lv/kNzonYkuCXGr33/2MghfPiMG1VkcTOSmwqlP2ymxFDcPkYh39GrcfjuxM/IA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Brendan,

On Sun, Jul 26, 2026 at 10:22:34PM +0000, Brendan Jackman wrote:
> From: Nikita Kalyazin <nikita.kalyazin@linux.dev>
> 
> Let's provide folio_{zap,restore}_direct_map helpers as preparation for
> supporting removal of the direct map for guest_memfd folios.
> In folio_zap_direct_map(), flush TLB to make sure the data is not
> accessible.  On some architectures, there may be a double TLB flush
> issued because set_direct_map_valid_noflush already performs a flush
> internally.
> 
> The new helpers need to be accessible to KVM on architectures that
> support guest_memfd (x86 and arm64).
> 
> Direct map removal gives guest_memfd the same protection that
> memfd_secret does, such as hardening against Spectre-like attacks
> through in-kernel gadgets.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>
> [Added comment, dropped modified set_direct_map API, added highmem check]
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  include/linux/set_memory.h | 13 +++++++++++++
>  mm/memory.c                | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 59 insertions(+)
> 
> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> index 3030d9245f5ac..1bf2a15bca118 100644
> --- a/include/linux/set_memory.h
> +++ b/include/linux/set_memory.h
> @@ -40,6 +40,15 @@ static inline int set_direct_map_valid_noflush(struct page *page,
>  	return 0;
>  }
>  
> +static inline int folio_zap_direct_map(struct folio *folio)
> +{
> +	return 0;
> +}
> +
> +static inline void folio_restore_direct_map(struct folio *folio)
> +{
> +}
> +
>  static inline bool kernel_page_present(struct page *page)
>  {
>  	return true;
> @@ -56,6 +65,10 @@ static inline bool can_set_direct_map(void)
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
> index a73af1fccb3d0..789c65a6d6a0e 100644
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
> @@ -7758,3 +7759,48 @@ void vma_pgtable_walk_end(struct vm_area_struct *vma)
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
> + * allocation.  So far, only order-0 folios are supported; this guarantees
> + * the unmap is either a complete success or a total failure.
> + *
> + * Return: 0 on success, or a negative error code on failure.
> + */
> +int folio_zap_direct_map(struct folio *folio)
> +{
> +	struct page *page = folio_page(folio, 0);
> +	unsigned long addr = (unsigned long)page_address(page);
> +	int ret;
> +
> +	if (folio_test_large(folio) || folio_test_highmem(folio))
> +		return -EINVAL;
> +
> +	ret = set_direct_map_valid_noflush(page, 1, false);

There was a discussion about  slight differences in the semantics of
set_direct_map_valid() on x86 and on arm64 and that execmem should
apparently switch to set_direct_map_{invalid,default}.

Maybe for this series it would be better to add a patch that adds numpages
to set_direct_map_{invalid,default}_noflush and use
set_direct_map_default_noflush() here?

And maybe also pick another Nikita's patch [2] that makes set_direct_map_*
to take address?

[1] https://lore.kernel.org/all/DJ69RCVRBO0Y.3JCYSW50IC4RC@linux.dev/
[2] https://lore.kernel.org/all/20260410151746.61150-2-kalyazin@amazon.com/

> +	flush_tlb_kernel_range(addr, addr + folio_size(folio));
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_FOR_MODULES(folio_zap_direct_map, "kvm");
> +
> +/**
> + * folio_restore_direct_map - restore the kernel direct map entry for a folio
> + * @folio: folio whose direct map entry is to be restored
> + *
> + * This may only be called after a prior successful folio_zap_direct_map() on
> + * the same folio.  Because the zap will have already split any huge pages in
> + * the direct map, restoration here only updates protection bits and cannot
> + * fail.
> + */
> +void folio_restore_direct_map(struct folio *folio)
> +{
> +	WARN_ON_ONCE(set_direct_map_valid_noflush(folio_page(folio, 0),
> +						  folio_nr_pages(folio), true));
> +}
> +EXPORT_SYMBOL_FOR_MODULES(folio_restore_direct_map, "kvm");
> +#endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
> 
> -- 
> 2.54.0
> 

-- 
Sincerely yours,
Mike.

