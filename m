Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACE701091926
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 21:28:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D972A6B04F7; Thu, 19 Mar 2026 17:28:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D405E6B04FA; Thu, 19 Mar 2026 17:28:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2EFC6B04FB; Thu, 19 Mar 2026 17:28:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B29E06B04F7
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:28:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 55FB51A06FC
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:28:55 +0000 (UTC)
X-FDA: 84564102630.14.2299460
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6CECF180006
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:28:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iIWABuTI;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773955733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AZ5RxDUXhhZ/2qNWVpaP7v5sMY8n+sT+/zd9PC8R1aE=;
	b=ghifYld0WJFxkKqDQptEso+QXgm3R0sQzrNoYKG1aX/EsqIu+PR1mxdvDWtS15EIk6EdfX
	YEa7kFULoQhR3uExUgKg6iT1/hQ76ShEDSGFFxqjBU7hNn/KIrCZ4uxLApqDeQzduXM4FR
	vxHS8D86Nal90QO9HlJv7RKYawpyUNI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773955733; a=rsa-sha256;
	cv=none;
	b=5+cKoFCyJToYuNVZ+NYutdZfuIwpowDAVndSqe7fqqEDckO0G6lJfwRWyRiceN7Fh0s389
	rv6+fbEzdFHIeBhhce+WO9R4iF1AIn/aTVwovtFJEvLQaEuB8d5UCd/0lr0f5KB9x83kOy
	d/qYmsFdc67gdDRolF1XehSI8oOvIFU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iIWABuTI;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6809E438D7;
	Thu, 19 Mar 2026 21:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58338C19424;
	Thu, 19 Mar 2026 21:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773955732;
	bh=/A2pi1IEpX2B/0J45JYoubtua2rh5RakAG442Dsy7Pc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iIWABuTI3Iy9u45wopTGhujY252zv9MxOCTJde9C4J1yO7CwLK4U1uTJh+pS3eNFl
	 9cC0sVwQoSggVrLNV+IbLVxdgRJf1phdj+Y/DQr46eUAGP4Y9+7BglECOz0PIR6T9e
	 VGqY4kJZoUQVws+gVPcdm7Z8IFy7P/g7VcGZ4KGYEARAYj9UBmSJTLPvOWcAsIiFpm
	 JcOZ0BrBfEa2WzKPRu12MxJe+0T7p+tJdlSbia9Rx2HbfdyIHDouLNaXjSAEFjZCdB
	 y6n/upUwFG1Y8fJ7Z9n/cgiwx3qKnaeNuy3EK9NFmAwZdxg68XtiJY3U8S3l9FAWzX
	 zSYaAtF8RGNIg==
Message-ID: <9943a6ad-9c85-439c-ad9e-39a694a29147@kernel.org>
Date: Thu, 19 Mar 2026 22:28:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm/mprotect: encourage inlining with __always_inline
To: Pedro Falcato <pfalcato@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>,
 jhladky@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260319183108.1105090-1-pfalcato@suse.de>
 <20260319183108.1105090-2-pfalcato@suse.de>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260319183108.1105090-2-pfalcato@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6CECF180006
X-Stat-Signature: a6uo9cabrp56m9m33d869ayh95eziez6
X-HE-Tag: 1773955733-943728
X-HE-Meta: U2FsdGVkX1+VmpiPvMnG9NGloZ+/RhLasGjvrrYLWOywOBBPKFULppNd0p4AySEqwi5cqRvVFbTjdOcaqPUqwXh0+cOX+8imEdTnf01BPnCM+Y6hyrRlvXxjrjVS1OVquLjjZ8ACEWoQIJAHpMmNrmf/5tjqa7vef2Qlr0c7YZz9mm18V/svfo7iEfFKvc3hR2i6qYJfuydoOTUZTp/01wXjx1YuA7C7sZBz3khQd2xbejSYECBTeeShn7UZgdUdg0PZ4srpJ5WumSX7kpDYEP1nSDwL3MvP3MM+rIo2O28x+0IBfdrAGLXfzgFYrtoFQ9KmQmon+mun+6fWYTgM8x1SiS8gE2Gqy9LjTmc8QdCLl0/mvm6dXZPay1wnd3dvv67s5uBSShBaEkwToXvMNvLt8l1/3bJZk4+TQYbZLjTNJ8yS6YZK5dC8PH3bYbSXDb+bvubNc+6hQ7Vc0Mvbly+GQSxv1VZi3ZgdzYTjymCJrfR4AJEriCXtf+3YgemmusaGrlpLrnkWf3tNqBxnP+B+t6JXk9Th2Z53g0GlTZBCThWrLV35/citVgOlW3PN1vCqCajwetPpUyVzgMqBVvB16W247MASK9lXwD7UXaUEbECYzytG09HhZMVQP3yKWlw/9Xqlf0nImflgOVQweQzHqat1AFeVix8+eSca4ZbuYot69VS1xuphb9PHElK9B915PGb+jhu8qTUh0X19HRtkFlMxjlLo8nAdq+xQaiU9tdC/YqJj02o5VN7Z3zQySXswXfzfSyc6P8Z/H4DBThIQZX70pq8bDenEf9Swylf3RtN3dwbUgyUKRIinJ+Du6jX2yQPsnZeitzvDp9a1XF22Bv9gVw5mv7SVN2IqFuIxbkmPcPOix+A0Yzu+tMB4vQYvpzKK3Ox3ylSdugkGHC7E6wq/CLxNC9XmQgXbjpfJh2Z0bGXJbjMu2v8OTUSPe8xErmA410WkcXVbBZE
 9xk/8pmk
 SK9tvZe/is2vmwHL1KUmMajcFzO3J4noOEBZ0dJkJduGr/FyEBZkA14QTBkrZYS1n2zyoD3lup3ZkK7G8D6aSK5jAtSbKWs+/Df/fjtRHeCeNzg/pdVWQ2robFQlUzSGdwCHKE5gvc9xl1CIz+ou+Y+1ffqkXf9ePm1xk2PL73GXPdkoP5YT7bouLjuYrt3QUZmjUVLgBMCpupfJcApF8J3xJ0GSWj8q5TeIrrE+Y6O4cPyL3CQH/QIiwmVvQrqCpUC/jm1H80Iqt7CW2edxxprCipoYLNtDDmeny8UBtAUDVh5xB3QdNtbDJBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/19/26 19:31, Pedro Falcato wrote:
> Encourage the compiler to inline batch PTE logic and resolve constant
> branches by adding __always_inline strategically.
> 
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> ---
>  mm/mprotect.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 9681f055b9fc..1bd0d4aa07c2 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -103,7 +103,7 @@ bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
>  	return can_change_shared_pte_writable(vma, pte);
>  }
>  
> -static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
> +static __always_inline int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
>  				    pte_t pte, int max_nr_ptes, fpb_t flags)
>  {
>  	/* No underlying folio, so cannot batch */
> @@ -117,9 +117,9 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
>  }
>  
>  /* Set nr_ptes number of ptes, starting from idx */
> -static void prot_commit_flush_ptes(struct vm_area_struct *vma, unsigned long addr,
> -		pte_t *ptep, pte_t oldpte, pte_t ptent, int nr_ptes,
> -		int idx, bool set_write, struct mmu_gather *tlb)
> +static __always_inline void prot_commit_flush_ptes(struct vm_area_struct *vma,
> +		unsigned long addr, pte_t *ptep, pte_t oldpte, pte_t ptent,
> +		int nr_ptes, int idx, bool set_write, struct mmu_gather *tlb)
>  {
>  	/*
>  	 * Advance the position in the batch by idx; note that if idx > 0,
> @@ -169,7 +169,7 @@ static int page_anon_exclusive_sub_batch(int start_idx, int max_len,
>   * pte of the batch. Therefore, we must individually check all pages and
>   * retrieve sub-batches.
>   */
> -static void commit_anon_folio_batch(struct vm_area_struct *vma,
> +static __always_inline void commit_anon_folio_batch(struct vm_area_struct *vma,
>  		struct folio *folio, struct page *first_page, unsigned long addr, pte_t *ptep,
>  		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
>  {

From my micro-optimization work on zapping and fork, I learned that
these batching functions are best optimized for order-0 page by
explicitly calling them from the code with "nr_ptes == 1" and then
force-inlining them. nr_ptes and all loops will essentially be optimized
out.

With no such explicit constants, is there really a real benefit to be
had here?

-- 
Cheers,

David

