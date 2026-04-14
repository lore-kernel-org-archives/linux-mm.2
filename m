Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A098BED7B82
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 08:20:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E419C6B0088; Tue, 14 Apr 2026 04:20:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF2546B008A; Tue, 14 Apr 2026 04:20:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0F656B0092; Tue, 14 Apr 2026 04:20:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C2F276B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:20:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 63E1D13ADC1
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:20:43 +0000 (UTC)
X-FDA: 84656465166.09.9A0FF5A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9CDD84000D
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:20:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pRhn62mD;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776154841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YP2NGMeiSL2mVAdiyYvvVVplG1ScFjk/LUVMthDLt8U=;
	b=cwMurWegAiCSZiX+jt/qTf2qCzk9Wb1Zsgz9o9JjFd+tWBlXpSxtQfgaVgEArb+uwIgRsd
	XLtwNmkLJALMb7/KD2G+3bOfJrDdfkWSC85vy/cxE7r+AKw7hG4XV5DWlcQ0Us90gr/WyP
	d5yEzEa1JwjbR9tSRQjWDE0r+ylsxRY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776154841; a=rsa-sha256;
	cv=none;
	b=JDEtsPlSJJ0RbyzBrwMql9muUZkxB0JxB4FId0E3JTjFXwYNY68+aAK+nDJ2kPdvd4MjC9
	QBoRxLd+O4+uOp0b0h/L9j/eSdWNZn8k3fVpJwai3mcKhcYmRi+7fFvpFiJR72jGC2Hp+Q
	2Zsrit43aQipYMoFfVHg4GnE/kuYRgM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pRhn62mD;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C74E41898;
	Tue, 14 Apr 2026 08:20:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFBAC19425;
	Tue, 14 Apr 2026 08:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776154840;
	bh=fLjEK3GCFgdbhYC4hZp3eSF1KR3f2/V4kfEYVvBIGxo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pRhn62mDhtXc7y/ERQN9IpwZ9V1HTKslji8c9v7OvNSsBr0suHtrysIKIZNT2bl3l
	 hewNu66Pd5EBweXT+Ic7t4yeMjs1qHJco480VgCIed0tRy6J2y1487RvDtUpS+0iOS
	 vPo3W7iR1egvJd+hvpr3JPMhajpATpOIy2IiAq6qyU9rBEAQyL1oxZlIgsDZIroFAH
	 S6BF0dDYnQ2ZJVGoJ34hEkoVT9NV3o7ZmG4yGhseObdFMOq9tjBlONd5r8HOrVNOcW
	 2A2RTvMcqOz2LB8qvJd/pZU/jKz2LZ9aberV5k3YcQVDizLNaX5+HPbNzCbSEcdOBD
	 RgkqlK4XcCfEQ==
Message-ID: <ae365455-5e1e-41ef-97b4-12983eefebbf@kernel.org>
Date: Tue, 14 Apr 2026 10:20:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_owner: fix %pGp format specifier argument type
Content-Language: en-US
To: Zhen Ni <zhen.ni@easystack.cn>, akpm@linux-foundation.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com
Cc: linux-mm@kvack.org
References: <20260414075813.3425968-1-zhen.ni@easystack.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260414075813.3425968-1-zhen.ni@easystack.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: fzdkxd9fwmqu5gdrw338w99ut4u8ewi5
X-Rspamd-Queue-Id: 9CDD84000D
X-Rspam-User: 
X-HE-Tag: 1776154841-486873
X-HE-Meta: U2FsdGVkX19PA13wcHfhq0abEULyvYm/2BuLnGYOz8VKGZfy1svrQeeorV4Fqm9kYd/5W1iF6rs2NAiKsV5I/kJoa/eAGwV3zUtMRRDg0nuFTsN/mho1mTO87vzrpqH7S9rX13xEsQBCKiqcSv7vOPFNcHjFgQjFuvdYW2od5fW6IeMushUlNE2ypVxb6kcmuusH88MNc7QN22M5me12RN8KW0FVAhOgJcvX0qCIyoCT4JKHCb3FhYJK02wEhxlUY1iFS14+C8Umg9zXsuZmh75fPL5534QxnCSxri+HQ69bLlCIiOPwGpjhh+mCL7PFhWEZIiW3+/OHV+/Hmz39nQEHCV089CI7LQAfZybIRbAIpIzYxWiY+01LYKGWPUNqIWuxgqiR93ZYwre2+yCJrPz1s0LYObjEM07iUjiBURHd6RhiV2dxBzrqvdkiXssmWbBBLm+MxZQ8XAEWG2MHt8XW7xLSMxGEyl7pUApF6TklI/kNs/zsWR7GBD75XddeW7E50RsPbYg4vUFFrMG/6LvxBM1gJoL9AYjPYQ/l7Mv5CRmAuNFZmXtwPg/XYUYpkw2dAaM9YEt0/RiUFIAOHjZUaJTiiFv260mX1qRy5i170vTWJEKxv3yrFgFyWKszuYBuFAI+r3nPtPcYcspcgUN8zVqWNIvU69PXflm0xedK+x7ZtphekL41QBo6QbW0/be6P89faLbDp3PRJXfcOumQ/waSi4RNWjigrCIFBWcJ0m10HVEbTTgsOZN2b0Isw/vl/hiniVzbe9TLmCGk18mC9G5h1LLFy6ZRB5EvzdEKUeUTyB+AaeCBZ5vRIVKutSZWfrRJAtzFk8YhmdlIYFFz6DKJzcPIttBaCw3/FIWhBWGg446dvGNzPOm0sKa4ku1WYv/LRqr0nNnNWIfbi4EKgM22jA6gRUP8EGuNvYqKNIZ/KxZXnNM/FdF+8ej/R8zMJHS5MhQBhSLq1LK
 YksFH6Jj
 Ol5/fh8+gh0IUBXdgiKWV8mgB/wCUkqo8tRqimglltTFrez5LAWGVVZ94tY9fvETYSiEEmZ606OamvwTTPoTMCMa7t0fLcvzrEyj+uRhIEdldUVYmY29071+fMKA8vVjb3BaqqX4HsSyCQH9MSRm8eyKRobhDxewt631GjtoErjSfswds6MybfHHWunUJVwLEebD6inlAe0hhL/GViXXnj/tALEBlXeEg9NTnIy3hHqivdtPjQFl2ziCI1qnUrbG0aueqvpHmXyfd/rUvxBgTfMX2Nmld/wtIjiY4wF/pPvf0/jgGoz6t22VDfCKFmbN+5Wf8LsFmTMMxRac=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/14/26 09:58, Zhen Ni wrote:
> The %pGp format specifier expects an argument of type 'unsigned long *',
> but page->flags is now of type 'memdesc_flags_t' (a struct containing
> an unsigned long member 'f') after the introduction of memdesc_flags_t.
> 
> Fix the type mismatch by passing &page->flags.f instead of &page->flags,
> which matches the expected type.

I think this has no visible effects as memdesc_flags_t just wraps unsigned
long, so it's not an urgent fix. Things could break if we modified
memdesc_flags_t further, or compiler/some tool got smart enough to flag the
mismath.

> Fixes: 53fbef56e07d ("mm: introduce memdesc_flags_t")
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/page_owner.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 8178e0be557f..2dddcb6510aa 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -573,7 +573,7 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
>  			migratetype_names[page_mt],
>  			pfn >> pageblock_order,
>  			migratetype_names[pageblock_mt],
> -			&page->flags);
> +			&page->flags.f);
>  
>  	ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
>  	if (ret >= count)


