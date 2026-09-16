Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 161D8C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 07:26:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBE576B0096; Wed, 16 Sep 2026 03:26:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C57216B0098; Wed, 16 Sep 2026 03:26:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF79D6B0099; Wed, 16 Sep 2026 03:26:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7DED76B0096
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 03:26:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0C772A5C44
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:26:14 +0000 (UTC)
X-FDA: 85218791868.10.068038E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3FC43A0007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:26:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oJMnzF5C;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789543572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uiduZlpOSzqWe+j41tpJG7GtdSaFaqUdX9h65p2QPhU=;
	b=13bZ87BV2dnSfqjitFPA6XLTBqDqS48qyL25KRYdxf7vckTQNrxrbIQ3Fi5M4zj2shZ1d+
	YQWTrn6RDQw4SR6ZJZm9fqcT6jTAvU0KC+kbja5nj3ZUKZAiCJlb0xCcNCpVKEIeDCsK9L
	AD5/U1+O/HoWf5njI4oVKy7O5HSBex4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oJMnzF5C;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789543572;
	b=qfQWLoHBlHmKQeTHUt2gajC57Sj7rsyuMhJVwSMnRqe0KkWHAcjtCVGwTKMLcP9/w3voHx
	J5DF9s+R7vxMAH4gigWW8lzwy4gMe2NCGdRyz9EtzvYvohgfkiNG/dUahc2S6uEHdRZSjm
	rkiknOEDfcciHjKhgyy6c5XD+os9dNk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F99943A22;
	Wed, 16 Sep 2026 07:26:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF07B1F00893;
	Wed, 16 Sep 2026 07:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789543571;
	bh=uiduZlpOSzqWe+j41tpJG7GtdSaFaqUdX9h65p2QPhU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oJMnzF5C7Ev3Dp3N/bV4RJunca3jlNa4TqP6Tj6wD/sqhaf1CRL+n1udXp+dqT4WV
	 eFwQbg8CoIfWO2+GGOfrhngEwutzN69U/TRLUtq6rcLi3SUIlNtU8ZF5YdjTw7ZOob
	 vs7u+mjt807w0erMTUVqxlTY1i1HBswBBh+r0uYT85FpfeFcw3ZdYCFC3vOptMKJaM
	 jlW6tBfOeNLhMb7tU38QVTUhvk4NTCc10iK13orqu2ElcuJ5XW2RGAaMfiG7Ln0yHG
	 ocTNsYde7HHddUhAp2JRBNVWCLB+xGV1aMmukXbGwcBogIQzk/XLcwYOP3uvMGHkhC
	 mreQEkfBjRSkA==
Message-ID: <4efdbc78-308f-46cd-ba3d-ae59b53c7ee2@kernel.org>
Date: Wed, 16 Sep 2026 09:26:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/madvise: use vm_normal_folio_pmd() in
 cold/pageout PMD range
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org,
 vbabka@kernel.org, jannh@google.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 peterx@redhat.com, jgg@ziepe.ca, sashiko-bot <sashiko-bot@kernel.org>,
 stable@vger.kernel.org
References: <20260912034833.2952750-1-gourry@gourry.net>
 <20260912034833.2952750-3-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260912034833.2952750-3-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: o9fqz6w953nney9ejruo65w39kxxpgw5
X-Rspamd-Queue-Id: 3FC43A0007
X-Rspamd-Server: rspam07
X-HE-Tag: 1789543572-230734
X-HE-Meta: U2FsdGVkX19OSDUbvvL+UJ5ezWXA+s+sg/LY2nijYvd1bJLxQHuMUb5YRIQQEZ22K333Y2wB0ynsfvJdhBkk38R7+AWEFrtduLb2yTNgUB1HLdUNC7kJDeVNBW+x6vh9esjRUwPWB2ddTlAqodqMBCaaz3ccGItgYE+PKLBJda9ouIXBSvB3mIAsaebPAxEF/IgBQlT6+tgxZzQXMFiOVH+GRvu/bglFzO2j7BgT4SglA3Rjdq5K3sxy0YF8PauIIFgQBXPLwtvjQROQuyOTigMsy7q18uOtWlUoXZWUhmaFzWsNDlZ5vazO4xilTHVV8oM9LI1a6l1MPk85D1zdqOZ83S/u/t4aX8xOWIqJX2YLGSuuDxWX5v81JSTA09NtklAtyzTbpVWpn+z33h1ssQPUZQOZ1ilYbQTdh2fe8H23CIN3UXhRH1ps/tT5pZ6H4yDNql5oxOEUamEBkMwRqGruxX6sIJYPqZ2JoJUioE0G8kiUwqx30jxlv6BoAABWW6sgrDYAEiApjZMiLC1h0dEhDKDk2dZbAPJiLAwmWbTSEppdyfsoXf3mqBsGmNs3uZojKkNSbqLR90j/js7veqOdli7Ekg7++Y+ZgTrRrVEsP2TSnhuCXKNpx4Y7yQWceaPnDOG/6j+ON3Bvlhvzo+ytVrDitOTD5RJ3TZIBir+tYA6ek2we8OBConvtV/6iLhehYnZZG8ga/aMZqinkveA2HyCR46wZ8vJ+Qbyo7r+EFV/ukQJKxP5N+NvsaTHNqlH0Y7iPDPH4MLnyXUjgKSCzjwaytZRrsd8kWplTZ4v+9bN8/SI+FDClM+e9c3j3nCOfe2kzdwfaxwg2BZmb+bVk67RT9QyoQoZyQS68Z96Lai+0prY4ioT1FleKXCLA+0rqDXEYnt8qhXovvoJre1tAEcEwEvgI15LWjrNE8BNpcu53fkQnPgd7E0OgwG7uCLb+EKD6VXrkVklNA+1
 +HFQmsBO
 lhsTH0maoFimHQwgF2DUonT8hnY+H7cI4AwzOCGddwFonIXatBQaCcmCpzKAxiRULTrMoqaljR+qpmJaFOoUr1qJV4J+yjAPTLcDJ2DkZg/jx6x6DNJRcNfH10gdVxLwWMSFiDt/HQXGwgPHWt4nnI2kSufWKos8KTO2acHDQ2x8CfacPOo5RSH+LKqfGtNPuRjuJVfFfjrWOxv2FgMY3tSk1z9Ba2DG0sRGh5tv0vnbJ7uGpgVBdONl2qpHwpRHav3S82C+f8F55sE9eXowCPkbi+iclnKk72+4SKZWmKvTKbt05zcpAUFW5dIgz8t1q29DF53bJz6bNdqoOV7LYyUq2wIdhaLppDaksXEWnjQp0ZhX1ASEc98PEPDETmZxiZPoTuQPn7+dTYEJcUDFwQ8EK9CCkEVCjOyfkSjY2sKii0POFNMnZMV8GIz5XTJnC38ESXvUeh/52avwSEHLf335M0q0RxXjIeEXJrw3KV8mttTnnF+hIH6e9z90pt3B6x1NRPYHJdBoviDA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/12/26 05:48, Gregory Price wrote:
> mmap a VM_MIXEDMAP region whose ->huge_fault installs a PMD through
> vmf_insert_pfn_pmd() - mshv_vtl_low does this, and needs CAP_SYS_ADMIN
> to open - then:
> 
>   madvise(p, PMD_SIZE, MADV_PAGEOUT);
> 
> With a stand-in module for the driver:
> 
>   BUG: unable to handle page fault for address: fffff587c0000008
>   RIP: 0010:madvise_cold_or_pageout_pte_range+0x410/0x9b0
>    walk_pgd_range+0x52b/0xaf0
>    __walk_page_range+0x6a/0x1d0
>    walk_page_range_vma_unsafe+0x8e/0x120
>    madvise_pageout+0xb2/0x180
>    madvise_vma_behavior+0x46b/0xa90
>    do_madvise+0x108/0x190
>    __x64_sys_madvise+0x26/0x30
> 
> Nothing validates the pfn on the way in:
> 
>   can_madv_lru_vma()     rejects VM_PFNMAP, but not VM_MIXEDMAP
>   can_fault()            *pfn = vmf->pgoff & ~(mask >> PAGE_SHIFT);
>   vmf_insert_pfn_pmd()   no pfn_valid() check
>   pmd_folio()            pfn_to_page() -> unpopulated vmemmap
> 
> Even with a valid pfn the path is wrong.  The mapping carries no rmap, so
> folio_maybe_mapped_shared() sees mapcount 0, and the walker goes on to
> folio_deactivate(), or folio_isolate_lru() plus reclaim_pages(), against a
> folio this mapping does not own.
> 
> Use vm_normal_folio_pmd() and skip on NULL, as the PTE half of this same
> walker already does with vm_normal_folio().  This also filters the huge
> zero PMD, so its separate check is no longer needed.
> 
> Fixes: 3c8e44c9b369 ("mm: mark special bits for huge pfn mappings when inject")
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260817220810.1175596-1-gourry%40gourry.net
> Cc: stable@vger.kernel.org # v6.19+
> Assisted-by: LLM
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

