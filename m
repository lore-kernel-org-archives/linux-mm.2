Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A889CCC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:41:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD60B6B009F; Wed, 14 Oct 2026 05:41:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CACF86B00C1; Wed, 14 Oct 2026 05:41:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC3AF6B00C2; Wed, 14 Oct 2026 05:41:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9712D6B009F
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:41:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1B6D9120472
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:41:42 +0000 (UTC)
X-FDA: 85320739644.28.B61DDED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 59163160005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:41:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T5d8KMHd;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791970900;
	b=UUIymRj1uYWWaHqLjgm/cpNW2CCsIoa2W2pR3FgJgeFfYkPY7q7o68kAGmV3xWtcAzqv3y
	6UCauccVSdVdmu995LpLV5Nq9hlYMjzPD78uK2Istny9fLdAEII9dseHmB5IF+639hx55p
	L9tJCuyDHJShOKceOSn27Wy2/AiH+tY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T5d8KMHd;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791970900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eknjK7272CVNf6tS/VepL4H992+z6bNQqkyA1iFz+tQ=;
	b=IePyCIeqtLjTW1w8SS+xgDfjj4XsH5Ptlr3Qwewut7OgpjuUqWgHCCD41gEapnEombHs4w
	YjPpA0Pnvw1QsRCh+8mpQMMFbXno36w6nURt+x3d0u0eNKYsfbHBAc4sB4rdFPjg0KzLfS
	F9pTqaye++ABfFlDUywiiDHsX7UT83k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ACF26601F9;
	Wed, 14 Oct 2026 09:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F731F0089F;
	Wed, 14 Oct 2026 09:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791970899;
	bh=eknjK7272CVNf6tS/VepL4H992+z6bNQqkyA1iFz+tQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=T5d8KMHdYrwyQOI2inOJa8WADx/WcYcVUhf6HVnoAs+XC9nXjkZm2J+GXmVN4C+jc
	 MgD2TefOp8QXb1QXs11PcxQ7lerPEtPipacMohaLtsKHaicZ816//O0j1J2BqrJ7u0
	 sxvKsEnURNR0O3v1wZBuIrFfB+QxxR5C10+SqUwVEIsjX9etaC53NgnlBkohUuSFhF
	 hAjUjxgM0DPiESCpMHF/2ONQp5IEVQfNDcFpnLi6DrnnttnyW0blAnb/eLM2H5EXed
	 YGCBBmRzuqZcs7uFBQLBFsEQkUTNGcAHsgGQEGqTpK5Td6GAtZ7CxI6orrb7JvXAoU
	 3apxqry9108sA==
Message-ID: <daab2f45-56c2-48ad-a24f-aa4f889e4da2@kernel.org>
Date: Wed, 14 Oct 2026 11:41:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64/mm: restrict transparent contpte mappings to valid
 PTEs
To: Zhao Gongyi <zhaogongyi@bytedance.com>, catalin.marinas@arm.com,
 will@kernel.org, Ryan Roberts <Ryan.Roberts@arm.com>
Cc: ryan.roberts@arm.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 lance.yang@linux.dev, mark.rutland@arm.com, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261013093600.54995-1-zhaogongyi@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261013093600.54995-1-zhaogongyi@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 31wh1r4yxcdc5fwrkbwnuabrsnfuwd9r
X-Rspamd-Queue-Id: 59163160005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791970900-207733
X-HE-Meta: U2FsdGVkX1/2YmubPSvU97ffkks7pd4x02ZGE1MIwQ1S9hQHV5Bm3qMUsIG/Qe/PgMNMK3fDXA5NKXt3FLzKC+Kge4ixP8vK678RbQLJBWRO/DTeotM7ceqZVQ1t1FVqJPhnHy2zoElhR509zjTHF3tVqq1Uz95nPTFWjjm7khnSR2nyx+pqb2hodl680L1FwNcTw2B2mdHPevZ5R44h1pWnAP5yvCcsnX8sAuxae+ZzU5v2hx8oMsEWn2OVO751m96kIJIdVm7v5Eg+e9mLVDi7F0r5PAXfeBFaEzs4g/RkoHHI+fO9EgdgfNi8OB+0Zed4l1ZFXsSTUR01fizDA9Wx7ZIUWUbqfQUf/TCqxo74Qv6CAa+v2bvK3itIWUZ5l2myTCBliTpdnZFC/S0PKsAZ+zFljhbLgo8d7T4FQgE+V4fRrSVkvZL//F7nZnlLecN+zQoG2ZYZEYvWgnstAZV03Zh7qc99n6iQVDHIVo4mh6tbGssOOnxb3BNx6k9uQ+BpgCgu2l47tt/BscqvGzddc4iZOS7d/jpV25u6VWDXYTDja9kANKx6+hWvw/brAA6A9VCafqNwc4SPiyksP8B/oQ4tTNa9Y/3A0IRcZRmnNKPC5RF7Az4F1aP4mDJCEEFosqJQifdHOg3K4tIrkDbG259Qp6wTBZUI/ePQMiN9R9ob+nRCcOCK5RFjriDofHUO6TWjXphaAuv8+6TPXkdDP365GY+z0MsmkkAXKfzMP4JQaG3pEHrYwe+QxsQVyj9rQEZslt78VXgumh8XJf4eTpY03kva1bhePoy5Kf6ApSLvEkQxUx9zgcoZBR13KGKTeYh9CvKYgwICUqeYRJIP+Gl6CZ91kmjkhD5p0clnFH9Zdy76Opd63dkbn8tyoHdBFBqIxOxTCZSfwt4v3vBEfy4Ii2W79C2VH3L3RMKIexu+tkYQs7uuFZCSK0m4SUH4nQPwi2wEYmFbmvb
 qsiM3Fe5
 KCatdVzgn6L8ong7X1U++7UH05LiDuYSdL5hY/Sdv2M9cucxJ/yxmUYp8FYb/jfeJ7d7hLd40rEqP1XJGfLI1BIZCi8I7WgWM85bZ9wSw0hzV1SFwZNZgqyR2a9eI57/LDy6hK2LEeQEfhB4GIzZzDPh4y+SfvyPNxnhurSlv0vfloHbsUfDbj3snP5qjqvbjjUGhj7Vp3jTOABUM7t+a4GzJ1XJaXVMVdvlM3x+yfLpPMj6WlEOA3gIVitDMMSXFGrYRxRgV798HbuWDf6XiezP366xs5lcEyjYsYtOUaDYXMDFBU1wt0mhuxUM3/2KIbgH6+ls38RsT+MAwpcxqEJQe/nWWuHWoFj3QEZblFV4hYYRgScPZi0v9kUWdq51zmQyh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CCing Ryan:

https://lore.kernel.org/r/20261013093600.54995-1-zhaogongyi@bytedance.com

On 10/13/26 11:36, Zhao Gongyi wrote:
> The transparent contpte layer treats PTE_CONT as software state: when a
> PTE has PTE_CONT set, the contpte helpers may align the operation to a
> CONT_PTE_SIZE block and operate on the whole block. That invariant only
> makes sense for valid mappings. Explicit users such as hugetlb manage
> their contiguous encodings separately.
> 
> contpte_set_ptes() currently sets PTE_CONT from alignment alone. Batched
> set_ptes() users can therefore install present-invalid PTEs with
> PTE_CONT set, for example mprotect(PROT_NONE), NUMA hinting through
> modify_prot_commit_ptes(), fork() copying a PROT_NONE large folio, or a
> PMD split installing PAGE_NONE PTEs.
> 
> This is not a hardware programming problem: invalid descriptors are not
> translated, so the hardware ignores descriptor bits such as PTE_CONT. It
> is a software-state problem. Some arm64 fast paths intentionally test
> pte_cont() directly instead of pte_valid_cont(), for example commit
> 9970a9a27ffc ("arm64: mm: implement the architecture-specific
> test_and_clear_young_ptes()"). Fixing the producer side preserves these
> fast paths and covers all consumers.
> 
> In the observed failure, mprotect(PROT_NONE) installed a full
> CONT_PTE_SIZE range of present-invalid PTEs with PTE_CONT set.
> MADV_GUARD_INSTALL then zapped one PTE. The nr == 1 clear_full_ptes()
> path only unfolds pte_valid_cont() entries, so the neighbouring
> present-invalid entries kept PTE_CONT while the target entry became a
> guard marker.

Hm, is there a good reason why we cannot just use the cont-pte bit for all
*present* PTEs, even if HW would not be prepared to benefit (!pte_valid())?

I guess we really only have to make sure to shatter properly, right?

-- 
Cheers,

David

