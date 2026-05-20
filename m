Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81FBDCD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 05:24:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C41F36B0005; Wed, 20 May 2026 01:24:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF18C6B008A; Wed, 20 May 2026 01:24:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE1896B008C; Wed, 20 May 2026 01:24:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9DC0C6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 01:24:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5536916036E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:24:47 +0000 (UTC)
X-FDA: 84786658614.16.2EDAF30
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 91A0C40005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:24:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CeXhaErD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779254685; a=rsa-sha256;
	cv=none;
	b=yfoUM3vDzEbAGWtRydqiMr4z9kzHNHwEuLrL1a7MHAzMk+QW9R+INtY/lYo2YrLhxQZObB
	HuXCK4uj61EBk/kR2Oy5+JkFvxaE7t6TtezF7QJqwbbIa7JYzWONkg1ef7Fj22vJZwD0+5
	hoPNBUrr9Q/XvyjWcCpt0jR8Vjj4NAU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CeXhaErD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779254685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wR7fOlF0LlueJQhUFw+Vok2GUwf2oNEmjv9G0fGQyXM=;
	b=qNxyuPwODnFussP9F8fMSKBxyZ1qO/1GxPi7FBR/TjiCcLUCQ1gHQrZHFjiGmELLGzqfpD
	81WO5QMmGnzURlYWg4/dmwu4XsP1mipaE43Ch13NY+Rgc4y7QQgYgsNGe4Z6vx6ZeCoKDm
	+9uo2eVHLTspp1otYpRk6YLQ5Zm21Zg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DBF9A60120;
	Wed, 20 May 2026 05:24:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B2D1F00893;
	Wed, 20 May 2026 05:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779254684;
	bh=wR7fOlF0LlueJQhUFw+Vok2GUwf2oNEmjv9G0fGQyXM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CeXhaErDxGhpp5vtO2zAUNlzvSOK+rvobBv4yrq+My2/c6N7ZmhIhP7mWNJYuKhTQ
	 zGAf2AFh+6x/Xq2zT3jAoi3TO6bj5YDfN9UXDhWrGKVY4YFKQkM7+K7n6O4gG7/bqn
	 lJUD5RGZJFNPZ/u2iQzScjHZGCIM67LMUWtXJLWaL7aPHASVd5nL771UbKK1NiZeky
	 jurmxJReNsKW8qdxX1U/JI1wVZNvSU3Ptf/jt+ODPmNkeLE5dj6BxKY8h9m5eSVBBr
	 17hwT9qWV3IuEB/BtOF0lBMP/uPFe1FA+IjtQA3HvFTqLjV/pc31XP164/AyzB1DTT
	 CSd8OEOK2iMsA==
Message-ID: <e9a08bed-3d5f-4606-8d17-80a16a4c82f1@kernel.org>
Date: Wed, 20 May 2026 07:24:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/mm: fix vmemmap leak on memory hot-remove
To: Juhyung Park <qkrwngud825@gmail.com>, linux-mm@kvack.org
Cc: stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
 Jason Gunthorpe <jgg@nvidia.com>, "Mike Rapoport (Microsoft)"
 <rppt@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dan Williams <djbw@kernel.org>,
 Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
References: <20260519151008.1399226-1-qkrwngud825@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260519151008.1399226-1-qkrwngud825@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: n5hjjmb18c75yi647urmuuqx6zfu36tp
X-Rspam-User: 
X-Rspamd-Queue-Id: 91A0C40005
X-Rspamd-Server: rspam07
X-HE-Tag: 1779254685-741447
X-HE-Meta: U2FsdGVkX182ah2m8I4hXG7YM4GXBHguNFYOGHmTLz8N2ywt/7KvEqWTAnyFdbOT1Lj95vCUfaL0PsZ0ls2tn+iI0eQ/G3Y7a6f7b2jleYZ6LX8zbfFXzGGDHPhQdbStdlNY6Nyjf+piTKBF0nPNAVvTXpPvky19Rs5L8uJs6shZH5l2jlOv5K+l33xtiR7dkSBEsfN2TikdgvrJNumeHahjvwPL7Ol2Nlrb5oyTKTgszPT4BzKo1AHAragOZa1e0xcUpOJ/7qJ9Sx9/lHdQjMLRfVoqYgmbpFJo++sHca5wiM7FX967IslEnUEYuAEiq1NkkF9AHEuc+nN67wAZR+Vci4GEf8CPjNY4mcCGOJO/d6wLxbjIiSkn/nx93lJbrNnwpgeEKUKWxTL2qpJOQPs9f1quPJwqcz9taDCBaIaBWJN/keQdgX4SzcgaNI4CQCZf811r3LBp/Lte6JidoK/yjVo/ARLR6VLDNM2tTUrsVS3dKRcQbg1pchdnXpxQoJo9TilydeZpWLewj31AT2TJ7xpsyw/QKGVsXZhlOGGg1LOrWRCxiwgec1W2ZSczvR68EZNBTaa5B4typ58xKx+J3iu/ywUaw+dAWsC5x5v2978P1uVjm7N2DQX0W2bQtGgZrkoUDqnq6MqBVPuOZYvPPVQbzZMWXUNLRtVRAG5HLlLeB+nGZHVsy5poephThaMqWBsklo/Jkr0Xl89V1kzw/7G1/LoH6o+WtD+XtVdkvd61SwfL09aXxkIoGdD56ccks82wVp0HIucdX+oP5gEDfM4xQtX7IP8KzmLz+ih/LFBElaIL2Y8zsXGVh0Ib5sZEfg+vc7JtRti8ZzuDTL4kq6+F/tZggoH8/8QHCmvRa7aL/n9m7oh33elDoDdRKbbwA1MF8XhmAq29h1FcxBOm/xMwD2wyfSlMFHqlUdtpXuMARoZKc3ZnIx/KadRHf9MDBi2BpA4D0ryY7E/
 RqLPZyOy
 XFk9X+lm1yCLXcph2H2qxDh8CcEY93T64YhxmbV3mzNLxlnncF6+s3NtmUtzBuAIbf89dqmTw1riaefZ4Wo3UnBiQydQWspKJrqcDlgsO4UZ7ZSF0r5PS9gTeZlKI0PRHhCFPTCk/8G40VoBIh9/T80A22DnucbQ38Ru01gbm9pugEAeSYJYa95fpAb1ugSgW+geMHlBgzUJR5RJTZBOGMJzNpPzLF5No4BIylfKKeM6Vm03uF64xOV3lBnfGWLQVeD6KQbRqqg+tMlyESqJEZKrBV9BHk4m/Pqwr3aiWOdMH5Wh4M6WBnOSHtWdY3b0eiSadbK15Ao+q6xE9zi9IWbNw8x44e6ptd7k1bjliMDBebxScBjHh3Z6JAVWe8Hgrzv76Ftr9ckQMgnTmY/lC114yLvPV9QPxgHb89qDhKRBZujdQr5nXG6J1efaKEBpL7SnJFNQxuu7+VNQ2VbKYlCsc8jVlg/GOK1i8m5E53XCWJIg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/19/26 17:10, Juhyung Park wrote:
> free_pagetable() is called via free_hugepage_table() with
> get_order(PMD_SIZE) = 9 to free the 2 MB vmemmap PMD leaves that back
> struct page arrays on x86_64. After commit bf9e4e30f353 ("x86/mm: use
> pagetable_free()"), it goes through pagetable_free() instead of
> __free_pages(), and pagetable_free() ultimately calls
> __free_pages(page, compound_order()) which ignores the explicit order
> argument and infers it from the page's compound metadata.
> 
> The vmemmap PMD chunks are allocated by vmemmap_alloc_block() using
> alloc_pages_node() without __GFP_COMP, so PG_head is not set and
> compound_order() returns 0. Only the first of 512 pages of each PMD
> chunk is returned to the buddy allocator on hot-remove; the remaining
> 511 pages stay allocated and become unreachable. Generalized: roughly
> 16 MB leaked per GB of hot-removed memory per cycle.
> 
> The leak affects every memory hot-remove path on x86_64 when
> memmap_on_memory=N (the default), including dax_kmem, virtio-mem,
> balloon drivers, ACPI memory hotplug, and direct sysfs offline+remove.
> memmap_on_memory=Y avoids it because free_hugepage_table() then takes
> the altmap branch and does not call free_pagetable().
> 
> Reproduced with CXL memory toggled through DAX in a loop:
> 
>   daxctl reconfigure-device --mode=system-ram dax0.0 --force
>   daxctl reconfigure-device --mode=devdax    dax0.0 --force
> 
> Fixes: bf9e4e30f353 ("x86/mm: use pagetable_free()")
> Cc: stable@vger.kernel.org
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@kernel.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dan Williams <djbw@kernel.org>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: linux-cxl@vger.kernel.org
> Cc: nvdimm@lists.linux.dev
> Assisted-by: Claude:claude-opus-4-7
> Signed-off-by: Juhyung Park <qkrwngud825@gmail.com>
> ---
>  arch/x86/mm/init_64.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index df2261fa4f98..a2301bddb647 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -1024,7 +1024,12 @@ static void __meminit free_pagetable(struct page *page, int order)
>  		free_reserved_pages(page, nr_pages);
>  #endif
>  	} else {
> -		pagetable_free(page_ptdesc(page));
> +		/*
> +		 * Use __free_pages() to honor @order: vmemmap PMD leaves
> +		 * freed here are not compound pages, so pagetable_free()
> +		 * would lose leak 511 of 512 pages per 2 MB chunk.
> +		 */
> +		__free_pages(page, order);
>  	}
>  }
>  

I sent a proper fix for this already:

https://lore.kernel.org/all/20260429-vmemmap-v2-1-8dfcacffd877@kernel.org/

-- 
Cheers,

David

