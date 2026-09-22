Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7702DC982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:03:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B98A6B00A2; Tue, 22 Sep 2026 04:03:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06C076B00A4; Tue, 22 Sep 2026 04:03:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA2AD6B00A5; Tue, 22 Sep 2026 04:03:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAC906B00A2
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:03:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6BEA61403F2
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:03:01 +0000 (UTC)
X-FDA: 85240657362.27.A8F87FF
Received: from mta0.migadu.com (out-97.mta0.migadu.com [91.218.175.97])
	by imf08.hostedemail.com (Postfix) with ESMTP id 58F8C160004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:02:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZvTATnpc;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.97 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790064179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k1M+H772M5pOa/gqHrDwzSK63jkXcdyYdqay93OmEAw=;
	b=D7WtP81eqNTBDOHsqS842flMa+YQ9gbs6F5cw3IJg79Cot1UKYCJWj/984U0/zLf8/lLIZ
	hB2PZ5wF+L3pk8dULHXtwg1q0X2KXROmaIkdtxVc5DtUeUeaPhXh1HJjFURdKnFcsfWWf+
	51XfU/9JuN2kJVosr2vtG9sH8z1u0go=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790064179;
	b=ugicuOWYxoyT1by0lX0eCjSdJmwNWG5Uw2GE1GB7sR94n3ZOY8LhxrrXrZDe8R/4TZFK8o
	799Oav2pNPc3zfyKYb0TQa+R3pbR/M9e9TtzTr9Fz8/aZUKmHZjDaKWb9VPUgl9EtjPKF0
	UEpDI3YP4Dol88l/7MFQblb/Kvfs1sU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZvTATnpc;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.97 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=EOuJmH4XWkfRTntzYM5OUcyHR52bdbnBGOL16e7ckho=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790064174; v=1; x=1790668974;
 b=ZvTATnpcs/aV2Gp6tFIYAKaMInDABpGmadf6B4ywmoM/dKY81t6WWonTc/xQIiiGzxDpISRp
 dWyIi2RfJ38BfXFUjGjShW2JP+fE1aLsyWEiC1zqhs5ysNLcLIJCzASqGJxIsNKhCMmc/UgBPQ8
 rYdiNHOj6E6NXUavHx+h5MoA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 432c8cc7e60c9375;
	Tue, 22 Sep 2026 08:02:54 +0000
X-Mizu-Trace-ID: 432c8cc7e60c9375
X-Migadu-Flow: FLOW_OUT
Message-ID: <dad55fc6-56ff-4375-893b-938404238ca8@linux.dev>
Date: Tue, 22 Sep 2026 16:02:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] mm/sparse-vmemmap: support device DAX in common
 vmemmap path
To: Muchun Song <songmuchun@bytedance.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin
 <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev
References: <20260913083734.86802-1-songmuchun@bytedance.com>
 <20260913083734.86802-3-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260913083734.86802-3-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: s8uy83oscdacm1qx5bc5on3e64wsk6z7
X-Rspam-User: 
X-Rspamd-Queue-Id: 58F8C160004
X-Rspamd-Server: rspam03
X-HE-Tag: 1790064176-205414
X-HE-Meta: U2FsdGVkX185SA3R553zC4eOE8OmqwwNWgIDG84/hZipdg2AX0MHm8Q80LVSFOUKBJmHaWOhjKYJOl2vT4xw0jl5TRxnmMjm6KR4khKu0TGmts6SiuCa8JET39Nooic5vOtlt7w8fMxxuElGAp6yt4UhN93WVFBvZpEXEo+RzSXaurDDOUjBemnMHSZaz/2vt6n5nSuymQ+2DDANPN7qew7H7elXf4yjVSTOl0wY49RP4fJitwhK83IwT9izzEPDkXjUlz5Q/aQq+d69PdkEl3WCFEum/eFcZCL23PE4BXaLy6F9Lpd5TmjF7MKX5bXPZpxXTlfAom7sKxovsZHA2dszpBgZDgwqAhJAa0tRBhUiEBZhNVasyCatjRwx9Tx2JPR5gkbMv4gXlCJDR83F+liuOrulSz3wrnyDZ3HXbImX6t+1m/mqREGaHSwYEElNaAov1OJ0tTwRZ1WzcYKat3lVVgcEcQ8mzOVAfW+69WSECgurIdA1OgNiJMLesireXSb9uMnqDs5nX/9G0ZJsMPC9VzEp+qOiV676mGt7zeouhIhABx0UFcnEsE43EaOddYnQLtrwsMJbIHIzy0F0VzCmYvxJ+Bha+fBX4RJdpT2OZDYijauO9e5cxOASojkC5B4Xa02/Ja6XxPFCKKqMZclhxOp71orYoB8J9DqSm6rgaHZYJH0vcK2lbYbnfW/f+etkTin9Hv6mRICtUVoIrjZxgkTZk7fVJTBWw6i3r+aVncddv9lrSRoOPwAdxm2ZXiYcuG/B44m2822MUYFMVSTDNZpGtQlIbcEy7HSJVcTN3AcPk9l7WsAtZM3J4SA8w6X0phW2RDNzNSruU5X/7BvcxgzrglnKN/uYTHg//G1otQ96TQJSz7yS7ASKx7IYaWMkjkMDLrwFbXW7R6eq4dGYqIHbBwgM+QzGpRCG9RRvKP1GdtfI7vsVI1sHL+of7m9eAvb+K7+Ip2M1E8R
 nIx44799
 VaKdSoAmGu43xc3ujBa4Z7Vc+j7q3j82XRf3NhIFGJWTOYD3ub7tZYnM0V/vE2z3XWGjM/9tZ0NTCBlZeOu3/VH61z71wGft9zZO2+Cc077cIO+tyVhaYFVGV5Y+lo66PjxZsfZ7gGE2GRlVqrnAUPsTvpocK0KBdTzyVHETfxpjNYrcSQsstBR56emmfRGt3MQXN2HapnV8EjA4GgC9qCffz5bD5Xwpv+h8B8dD8pQF2CWhY7tctFJjQ/593rytXy6044hi8v+CxLwRgXDxYGWq68UtS3i8vEVTA3yIUU06hXTs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/13/26 4:37 PM, Muchun Song wrote:
> The common vmemmap population path cannot yet handle optimized Device DAX
> mappings on its own. It uses pfn_to_zone() to find the shared tail page,
> but Device DAX populates its vmemmap at runtime before the ZONE_DEVICE span
> is initialized.
> 
> Teach the common path to use device_zone() for runtime optimized vmemmap
> population while retaining pfn_to_zone() for early boot. This allows the
> same path to support both early boot mappings and Device DAX.
> 
> The backing PFN supplied by the Device DAX-specific population path is no
> longer used, allowing the redundant lookup and population code to be
> removed later.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   mm/sparse-vmemmap.c | 44 +++++++++++++++++++-------------------------
>   1 file changed, 19 insertions(+), 25 deletions(-)
> 
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 878d29a4e862..e83821768c12 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -208,18 +208,27 @@ static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
>   	struct page *page;
>   	const unsigned int order = pfn_to_section_compound_order(pfn);
>   
> -	/*
> -	 * Device DAX still relies on vmemmap_populate_compound_pages() for
> -	 * head/first-tail allocation and tail-page reuse.
> -	 */
>   	if (!vmemmap_optimizable_pfn(pfn))
>   		return vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
>   
> -	zone = pfn_to_zone(pfn, node);
> +	/*
> +	 * At runtime (slab available), only ZONE_DEVICE pages trigger vmemmap
> +	 * optimization, so device_zone() suffices. Note that pfn_to_zone()
> +	 * cannot be used at runtime because the zone span is not set up now.
> +	 */
> +	zone = slab_is_available() ? device_zone(node) : pfn_to_zone(pfn, node);
>   	page = vmemmap_shared_tail_page(order, zone);
>   	if (!page)
>   		return NULL;
>   
> +	/*
> +	 * When a PTE entry is freed, a free_pages() call occurs. This get_page()
> +	 * pairs with put_page_testzero() on the freeing path. This can only occur
> +	 * when slab is available.
> +	 */
> +	if (slab_is_available())

Would it make sense to introduce a helper function that wraps
slab_is_available() for better readability? Also, it might be worth
adding a comment to the helper function as well.

At least for me, encountering this always causes a moment of confusion.

> +		get_page(page);
> +
>   	return page_address(page);
>   }
>   
> @@ -231,27 +240,12 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
>   
>   	if (pte_none(ptep_get(pte))) {
>   		pte_t entry;
> +		void *p = vmemmap_alloc_pte(pfn, node, altmap);
>   
> -		if (ptpfn == (unsigned long)-1) {
> -			void *p = vmemmap_alloc_pte(pfn, node, altmap);
> -
> -			if (!p)
> -				return NULL;
> -			ptpfn = PHYS_PFN(__pa(p));
> -		} else {
> -			/*
> -			 * When a PTE/PMD entry is freed from the init_mm
> -			 * there's a free_pages() call to this page allocated
> -			 * above. Thus this get_page() is paired with the
> -			 * put_page_testzero() on the freeing path.
> -			 * This can only called by certain ZONE_DEVICE path,
> -			 * and through vmemmap_populate_compound_pages() when
> -			 * slab is available.
> -			 */
> -			if (slab_is_available())
> -				get_page(pfn_to_page(ptpfn));
> -		}
> -		entry = pfn_pte(ptpfn, PAGE_KERNEL);
> +		if (!p)
> +			return NULL;
> +
> +		entry = pfn_pte(PHYS_PFN(__pa(p)), PAGE_KERNEL);
>   		set_pte_at(&init_mm, addr, pte, entry);
>   	} else if (WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn)))
>   		return NULL;


