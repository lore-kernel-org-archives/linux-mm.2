Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8108107526D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 07:35:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CC076B041A; Thu, 19 Mar 2026 03:35:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 076366B041C; Thu, 19 Mar 2026 03:35:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECD746B041D; Thu, 19 Mar 2026 03:35:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D76C36B041A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:35:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 96EB7B95D3
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:35:41 +0000 (UTC)
X-FDA: 84562002882.21.DC18514
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id B14FAA0002
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:35:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M8Zx0AuJ;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773905739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KkwqRp+r1pO9GjEC7DF+o4HAN8OxnNgGfkuyUapb/F4=;
	b=t/L/imRTV/3N/p3ZltaRcC0pnPgYlXrggUqD7M0PRWWIqApmxlMpvsbaPoA/J7pUvx0MPy
	4ehp1uc9X/DaIOCOfca+wtuwgSmRDWAAJZqy6XgHV8xfTSui+RNpCRwEicjK1qL/nx1l1w
	0IvRvlS/xFSffaMK7++ihe6HZphzCFQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M8Zx0AuJ;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773905739; a=rsa-sha256;
	cv=none;
	b=GAwsOtz32mzlZTylTs1BRb3DTmrTk4mEMZ6U5/hEWfkEmVhqFV0hUa1Ksoo6vAo+tCS0UY
	YGaPnmhDRUBPQcjFXxciJJT1JR7CkG7JKnIu0nCmrSVtFvu1vTjmlrAqB98Mm8tF5JR4q4
	g1yfJvnHfDqn/5lKWW5p+QtpPW2bC7w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A753740719;
	Thu, 19 Mar 2026 07:35:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2405EC19424;
	Thu, 19 Mar 2026 07:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773905738;
	bh=uOcmZzh8d0O0DH5CbztsLp28CPyWd3JOtYbCAi4uwVo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=M8Zx0AuJEuSPkF07I/Ib4o3GDx/OLKcdDOkXqcU3T5+YDru7awKHBAqruc4v19NBh
	 StSU8ZRucJPgwNH8201LF0ej6+1EMiJCIXBoEXMJf8a6TfGzE/bP8WQp1JHd8ZUAla
	 qwYYfHpAfH/3vdfi0eIJt+O942Vv75P+thTYrqRSZ6L91LYZz6mHODG1A2ccSWgEYY
	 bqL1Iui6q718lMcZmN7DmkKE7LQ1DYM4IiCXQm24u4Fy+HNwLFoseaAULcYVaiq8dq
	 AViedRoS1YAVrRPNKDoQWeYzJ7ckZJNJwTjnWAX1cpdGwr/cgWENs/A/ENjyYgFEWo
	 SD20UDN3q8nZw==
Message-ID: <ed0067ce-7cb1-4d73-98f4-c5ad663577b4@kernel.org>
Date: Thu, 19 Mar 2026 08:35:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] arm64: request contpte-sized folios for exec memory
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, ryan.roberts@arm.com
Cc: ajd@linux.ibm.com, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org,
 catalin.marinas@arm.com, dev.jain@arm.com, jack@suse.cz, kees@kernel.org,
 kevin.brodsky@arm.com, lance.yang@linux.dev, Liam.Howlett@oracle.com,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, npache@redhat.com, rmclure@linux.ibm.com,
 Al Viro <viro@zeniv.linux.org.uk>, will@kernel.org, willy@infradead.org,
 ziy@nvidia.com, hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
 kernel-team@meta.com
References: <20260310145406.3073394-1-usama.arif@linux.dev>
 <20260310145406.3073394-2-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260310145406.3073394-2-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B14FAA0002
X-Rspamd-Server: rspam08
X-Stat-Signature: ciwt84apiz96bfxertr9ugrro4fww9c6
X-HE-Tag: 1773905739-605011
X-HE-Meta: U2FsdGVkX1/ynWdoeZEXISWIkYyxE37QhVaQGd1QkzBkpCwmhTF3iYWWn8VIHjdp+5gOvc7/+3lpONW5PO5bvkRtCnZJ3+LPXlIbnfvmvJok4xj7i+lFRMglQgUNbSpj1zJVUxHh+Rhf43yd/FR/2HVljvOHRj3Nz7FPDZ7FD9txPc4R7EgXpIfdFWPjemBQkAG2gWbrrSI2gpFn0GjCvjnextXxrQy8rRyGRhuj70AIDoGjVLtscBY0+hBe3I8ukj1b2Z2z23/swz90VGcE2KLfl0XTwGtNAZhlcmIg0nTBvlSkaLsCIJsemgyV8+O3QVrOSVeRPIRzPgNAZ42nvSpk9c88DJdJu4IbYp3OcX/stVll7dKCkh6S/kYMsQPZBeFojmrPzwDqiC3QbeMe5y7Vo8NsrRN/DstGRlGgPJT3mxPDVt3i1VMwncoP5MN7uD/s1COrofyKOApvnKBaHOFWWzraKkDZh/bJyt2+aVr7D+oaFUxyQB14wbeB3VuI8harjcJfbY4zNgL+C5Ze4BsD8WQZRvu7nDLsrhz0FJeuJxSgeKH9M2D8BFvk+CJFTFIUuBNTrhnZ6hkt0grxpQsOivQekxVzmIH8+vGjtwsqA3O+GIHNuP3F/7f44E38hzBHnTV/vvrayjoaFwdU+/odZYLdRbfBN6B/sxhJt83hNl59J8O51QHJK2Q6FEgohfT0Vytm5zskCusIDFT35nLlXB7f5lhcSRC2uhJ4RjJTPZAIM4wc4zzUP/+sEeZttSER00dfpSft70GDa9v7TDGf3BIWxxClBtAGMQu/Upg/FOc14WU1vESrri5mbcqVrGvI81RKgL2tWGGAWaOL4DSxDnHFyzqnk6pPiUGYk8Q5Cca7c6Nke620E9DaVJMxQOEkD7NF/4kGUMQgR2DKteqRNzyLFx/TYrcDHk84mNtY7l/PYeq+OKjXYG9n59NJRHn3STxYx4LU14lKk6g
 Z1TxMksP
 PlTNsw6mplKAXk4L63hthkzgEb7Ur+yw041C/db6pAzH2EKBKoYeS4wbuKixMRrCD6vJU/HsLFuDtP0Op0ksAy21hJ8I7XFqFJGj6LSpisxkhrHk61Qj5cG6BdVKav2smAXOBhV6+0eivD7zC+4xsCkjcQQ03nqqpvTr53gjCxyiCjIS23nlptB05xPAxKjYwt2jyaBQc2IU1Rwvuu9sOk6rwx3D9yGqNm9DgOREcoFQT9alP0DsK5yqLwAk89Ck5G7A6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/10/26 15:51, Usama Arif wrote:
> exec_folio_order() was introduced [1] to request readahead of executable
> file-backed pages at an arch-preferred folio order, so that the hardware
> can coalesce contiguous PTEs into fewer iTLB entries (contpte).
> 
> The current implementation uses ilog2(SZ_64K >> PAGE_SHIFT), which
> requests 64K folios. This is optimal for 4K base pages (where CONT_PTES
> = 16, contpte size = 64K), but suboptimal for 16K and 64K base pages:
> 
> Page size | Before (order) | After (order) | contpte
> ----------|----------------|---------------|--------
> 4K        | 4 (64K)        | 4 (64K)       | Yes (unchanged)
> 16K       | 2 (64K)        | 7 (2M)        | Yes (new)
> 64K       | 0 (64K)        | 5 (2M)        | Yes (new)
> 
> For 16K pages, CONT_PTES = 128 and the contpte size is 2M (order 7).
> For 64K pages, CONT_PTES = 32 and the contpte size is 2M (order 5).
> 
> Use ilog2(CONT_PTES) instead, which directly evaluates to contpte-aligned
> order for all page sizes.
> 
> The worst-case waste is bounded to one folio (up to 2MB - 64KB)
> at the end of the file, since page_cache_ra_order() reduces the folio
> order near EOF to avoid allocating past i_size.

So, if you have a smallish text segment in a larger file, we'd always
try to allocate 2M on 16k/64k?

That feels wrong.

Asking the other way around: why not also use 2M on a 4k system and end
up with a PMD?

And no, I don't think we should default to that, just emphasizing my
point that *maybe* we really want to consider mapping (vma) size as well.

-- 
Cheers,

David

