Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72DD4EC01A5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 08:49:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F6736B0005; Mon, 23 Mar 2026 04:49:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CD7C6B0088; Mon, 23 Mar 2026 04:49:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E3CA6B0089; Mon, 23 Mar 2026 04:49:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E7F46B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 04:49:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E9DC1B8F20
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:49:18 +0000 (UTC)
X-FDA: 84576703596.22.DC9E0D2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id E4E8EA0006
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:49:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QAcTk4zT;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774255756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gzHVV/snRVT3xSp7+iZyrt5RenaPsY5kBShH+YWbrEM=;
	b=5G4r9f0J6znH7YLmkSklRLaO98V9FLXFBpDrcaNDxZ2UHF0JCABZU1hmdC7mNKdQR7NHDG
	Rl00au/kLsj55/Ano3P/s5G+N7wBmvYRR6Gnqwrnl+iX0APOER+a4lR2mcQGLk73v8x197
	sb7p+cKYAS8uUeGLumswfe5RGA+ar0A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QAcTk4zT;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774255756; a=rsa-sha256;
	cv=none;
	b=zIa2uOAhlkcxij86N41TTQk01TFbWTR7NJJuwYXqf3oJKp36dYpW8nmaAZDEvDCbnih/Eb
	j23+g/TsrpCtI9WQBJQMwUhfztbtlspPl0cmK2kn3pG/+yAxtK9Suxjm9DUDQCaMIS0gxS
	WCCNRIteuD7rdZ189m0bUb4kHJbkK8Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 426CC60051;
	Mon, 23 Mar 2026 08:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61046C4CEF7;
	Mon, 23 Mar 2026 08:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774255756;
	bh=DZF/jGQWrlgdVsuqiaHeoRfMY53sc41gnfhL+qN9Jjo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QAcTk4zTb8b194gajG4acCAncrYK7ufNrmC8eZSvuFkEWYUKm/lkN/1L3B68vW+nX
	 6vMCwhVFH6BvDWe9HEZWJrXLiOB7V0mUNJRQz6w84Eq/IEUD1RiBLfIM8C6x8z46i/
	 wUGu1cGmH7Vq8Itfo92SF393/jsvzOMqx+cfLlq/9zDQfuydMjc1XGiCbal7NBOaKg
	 bv8YSpBs9h+Yf3WNyJaE/61CcybP+Mc8xw8g4/9ojFi3unijlmqWvrf2gY7b6uKvfe
	 PC9xrL6LmY3h2g/+O3uZwkSGSEcLDercf9YzDUhngS13/8iMVOPUl6o66YW9+z3oP3
	 tdr+FccQyc6+A==
Message-ID: <6b04c1a1-74e7-42e8-8523-a40802e5dacc@kernel.org>
Date: Mon, 23 Mar 2026 09:49:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/15] mm/sparse: move sparse_init_one_section() to
 internal.h
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org, linux-riscv@lists.infradead.org
References: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
 <20260320-sparsemem_cleanups-v2-13-096addc8800d@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260320-sparsemem_cleanups-v2-13-096addc8800d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E4E8EA0006
X-Rspamd-Server: rspam08
X-Stat-Signature: uy6d4ooxs6o8a8d6xpwtf15pu1zi691k
X-HE-Tag: 1774255756-398935
X-HE-Meta: U2FsdGVkX1+eDg/wL4VvUty4vZteVq6M+Yc1J8OhfvEpuBX5eosjGcSdPHtC8RtA9FQz1vr7E3kNi3SQJR6p3X6T1BmTOLp7FCLpo82EBQwbLwD07QaA49StxF4baDL4mWB389S0Bg++hR5kZWHANrWGILjiF5oOWzFPOXN7X7d1abFxffvFL204nXX8P4yMDFYzKstTK2yw4lH8ti1OjT6sLD2WKZcmlKP3mOB6wuyOXFx1M1qFI7+Et9EHK+hzQs3wlpO5n9BqXrg9Dom4muY2+cdh1JxxwrKfWSD/n2pzDimTyAUaka+N8N1Ha89FrhyWLy1jfzBiNYCob9Ata+TXuoQjktSwL1uy7lKdojr+1bYssodXlQFcrrtpJ8z8TBHfLXXMAsF68tMiUx64tU6zg8BOZ5glELEgZBR/iQ1p0abpQgapCRuBqqSsNY+mXDgAwtXFvOVZObysNN/pN+Iwqy+EtP3bcyEhV9LA8jIeNVJYNDuUmo7Z2rE5of+wJ2f13NbkesAEhSA15YfLOV14UIwO5RtKTEbKsILza0ywJuhACVkmSLsP8ln6XLaoyOJ1+5dqrj4crjvrmo80+arLZIZqvIe63GR3Tbcl3W3CejpnEpRvV2LhYRcaceZbRigUl2wZ5l8ZttdVR1PUXVXZTBNYhQjvv9hKj2vYnLnDjqRTHnSipkBKSRO/XxeHyXVPXKlZnD74B2Hqd6orY0Oby0XTmcwDjFHGEUgffvBJ8X+3D8rim00Q7yToANycgOrGdlH/I0QizupcaBZPsFgSJjlf5KvF96sYetPOi+ZSYOJnB5R4LrMndKAWlP54H6MzVtpILsUURyq/M91QwnW741KFjQGQEd+EAaWa4i1B7kEZpAXDfP11+zPm2CrR+etJO6iaN0IpztJIRcZizdnhloQuKiUvmFvsuPuQOLUNf0AlKVd0ng9kD9Q6/nPv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 23:13, David Hildenbrand (Arm) wrote:
> While at it, convert the BUG_ON to a VM_WARN_ON_ONCE, avoid long lines, and
> merge sparse_encode_mem_map() into its only caller
> sparse_init_one_section().
> 
> Clarify the comment a bit, pointing at page_to_pfn().
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  include/linux/mmzone.h |  2 +-
>  mm/internal.h          | 22 ++++++++++++++++++++++
>  mm/sparse.c            | 24 ------------------------
>  3 files changed, 23 insertions(+), 25 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index b694c69dee04..dcbbf36ed88c 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -2008,7 +2008,7 @@ struct mem_section {
>  	/*
>  	 * This is, logically, a pointer to an array of struct
>  	 * pages.  However, it is stored with some other magic.
> -	 * (see sparse.c::sparse_init_one_section())
> +	 * (see sparse_init_one_section())
>  	 *
>  	 * Additionally during early boot we encode node id of
>  	 * the location of the section here to guide allocation.
> diff --git a/mm/internal.h b/mm/internal.h
> index 5f5c45d80aca..2f188f7702f7 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -965,6 +965,28 @@ void memmap_init_range(unsigned long, int, unsigned long, unsigned long,
>   */
>  #ifdef CONFIG_SPARSEMEM
>  void sparse_init(void);
> +
> +static inline void sparse_init_one_section(struct mem_section *ms,
> +		unsigned long pnum, struct page *mem_map,
> +		struct mem_section_usage *usage, unsigned long flags)
> +{
> +	unsigned long coded_mem_map;
> +
> +	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
> +
> +	/*
> +	 * We encode the start PFN of the section into the mem_map such that
> +	 * page_to_pfn() on !CONFIG_SPARSEMEM_VMEMMAP can simply subtract it
> +	 * from the page pointer to obtain the PFN.
> +	 */
> +	coded_mem_map = (unsigned long)(mem_map - section_nr_to_pfn(pnum));
> +	VM_WARN_ON(coded_mem_map & ~SECTION_MAP_MASK);
> +
> +	ms->section_mem_map &= ~SECTION_MAP_MASK;
> +	ms->section_mem_map |= coded_mem_map;
> +	ms->section_mem_map |= flags | SECTION_HAS_MEM_MAP;
> +	ms->usage = usage;

The following fixup on top:

From 66ec42c610feb3b84c405222f3f39ba0776549c6 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 23 Mar 2026 09:48:21 +0100
Subject: [PATCH] fixup: mm/sparse: move sparse_init_one_section() to
 internal.h

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/internal.h b/mm/internal.h
index 2f188f7702f7..969e58e5b3db 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -980,7 +980,7 @@ static inline void sparse_init_one_section(struct mem_section *ms,
 	 * from the page pointer to obtain the PFN.
 	 */
 	coded_mem_map = (unsigned long)(mem_map - section_nr_to_pfn(pnum));
-	VM_WARN_ON(coded_mem_map & ~SECTION_MAP_MASK);
+	VM_WARN_ON_ONCE(coded_mem_map & ~SECTION_MAP_MASK);
 
 	ms->section_mem_map &= ~SECTION_MAP_MASK;
 	ms->section_mem_map |= coded_mem_map;
-- 
2.43.0


-- 
Cheers,

David

