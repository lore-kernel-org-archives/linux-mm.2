Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30A05CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 18:29:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 966B36B00D7; Mon, 11 May 2026 14:29:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 917D76B00D8; Mon, 11 May 2026 14:29:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82D516B00DA; Mon, 11 May 2026 14:29:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 72A106B00D7
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:29:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3C9F31C05BE
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:29:16 +0000 (UTC)
X-FDA: 84755976312.18.DA935C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6CEFB100004
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:29:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jb3mppHT;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778524154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rXg0rKRMKKeZNFaTnir048IGHWDr0PaGUDmkBBfjE2Q=;
	b=W85wMUnbi+8yEqbjTff82MWAoGj2V7YzvT3P03mZOEma5VJi9encBUqubVwwUwjHzeV/Qu
	IzVxJ8DnSEobceVTmM3CAaiHT7D6iaqW3mIs41dSBBOv1UHuSIjzSf8zXywXlSrEqoRaLu
	57FaYNODvshKaQQiFmX/9XBQZ0m2tUI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jb3mppHT;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778524154; a=rsa-sha256;
	cv=none;
	b=j3oxBP+hhrpX2D7bwI9x4j6Z8ZSYuYA506McknVfS7wh//qNgPEdSJEzqCLfI94rIDZ/v3
	4xHjpHWskPS2mIfGDUe60PtGewOPAivzPp7F/NSWdBB1cLQl9lU9A8Kc7IXozf/JSCOXa1
	gAevN0hbZno9krkU7XZepNhSjWo8bGo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 62608401D5;
	Mon, 11 May 2026 18:29:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFB1C2BCB0;
	Mon, 11 May 2026 18:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778524153;
	bh=dD5KsBVjOKzbuuocy0Of5v+EieSuaBTX5iQxL9kS8G8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jb3mppHT0Pe7eR2WirODoxeKgLV4AZ+3ltjcUtPzexErSUkDw+gyugg33m5BjBhUX
	 a859N2vM5ue9HGJy8w9ho901SEzgYAR1OLTuMZ7H7+pMBtbIt6YGpykir+xd5iv54Y
	 wSw1bQs6rADUKPHUDxYIxK6rQ8777Z3AwH4ZL0pZxhtYDvJ018k3aIf6U7DOmraqs2
	 CyIsqNzWm5CqfRG4Qjpzv7wh5KGEV7IgMChIUPY/fKyCtjV/D1jrgZuO+7h9o7Qcx+
	 S2rihlTGMS/tpNT3K4zUIPRPZIVrWexcd2DBOZvv9J1OVEEW0p57az7KmgGg4phGpU
	 HV4YtVYPl1//w==
Message-ID: <cce2eb02-d664-4bd5-936f-bd2b34d908f2@kernel.org>
Date: Mon, 11 May 2026 20:29:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 14/22] mm: encode freetype flags in pageblock flags
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Wei Xu <weixugc@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
 derkling@google.com, reijiw@google.com, Will Deacon <will@kernel.org>,
 rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-14-28bf1bd54f41@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260320-page_alloc-unmapped-v2-14-28bf1bd54f41@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6CEFB100004
X-Rspamd-Server: rspam06
X-Stat-Signature: pjj4erct5bctamgxeb8y3xtw77a1mxkr
X-HE-Tag: 1778524154-337463
X-HE-Meta: U2FsdGVkX1/VxwkffR8+HdPOsPArwdJ0Akm+AGYihfg90B7l7Sy3tc85RCM629E3J3farN3p7YrV5hjKlmd/ZBEwqVJKu/HisHrufHrUC4gwlEkoo3tJYufA/Sv5pB7SnhuLha1+JLq0FI85NFPk9IDCSVI7JR1x3ASn1dH25tmgnv0rXQjj+godbHQku8YKt/N1ewsZ8bGXTUFMqpCTDu/K4XUDy2Nfmv/BevzTOu1YNfCwyHzyWk6XLK8B8yTXoPJH3gDl6OUGMEmhSsC39CWOSktGzmn6ORONfbdysawLdDEuEVGx+qZ8jfUEuK1PTq04VBUb0O4bZ+UEcFs2XtCReokU+2xoxdSc1Q4tFAZBgJOE30zw3kAHXdSOUKAqtdJKLuVKxaSnMlgXhgOxZkqkiNwYicguUPYFReBhorvpW9R2sjYomxy6TSc68+mR24R6vtbJjsIGBKMIyvZQwGW4dlCv9wARNu4E+j/M8CWNWK7CqhjYZpWoTcE+Q1a+c4vYLdIp0eIsMscfQlB3PWPDLb8bh2IAHXf64qJyBFV8w9ouK84RRClrJdGLZgjFStFVCL8TUH1g+5qwKcfgYW5Kngth/v4YRe9wlO3sw8HRIBmtKJelKQX2V669hZym2o4MdMt5w4/mv8PtW9Z+KO5KsuUoFZFh/HQcXzXOr5DxeO982DIo7LaK3m3u1AUa6wZP9S4kwweBw2IQ2zFSnltZ7Mf3Jb47iPZTHJyyDgPIXiI2SzHHvpBwIcKpH6GWRT54dcNGpm6rvBLJ1v1K4VJRg07ptapSzvDNrv/K1g3+M/1yR3gZbtaOxd7Z3RmlZRU19cwbs/dUJg2g/s0x8qBy4sy83gyTB37V8Aq/oeWccDeBlJCH38+Zm9hrRI+oOAY+QGudhJ856KujILhhWppicA8aIjauZTO18NBlfWdUunuMMYaDkpbD3wNKX3ejsPLH6UNslh6zAQZK/VS
 nUlY0sQa
 H/zX2L3JHyzFCnui4fjtYWOfX+T7dPX1YYCZcLOPV+EnOeLuqU7Tsd35uS0Yr884sXh+vELHXGXKOHj1FrDfU/FviV4o2zE4YTrqGaJP0IXLI93dC7QfyEpIPDhnlOmXagi2bE2vmIy4ZYsfTQ4XPwddxuJvS6cnBPtD2kcOaOYalxF8v6sa7lnu44lpz5vkRbgvP59maJHs3VRT+sX+mUctVhlJJ7xTJeOd+tTh9Tf1iWSFHB0q0gg7+USJQbh//nPlSmQYOyD4oI7D3Yp/SeRZkuDRx3F6otE6wunnMweXZDRHaEL1/+FVSyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 19:23, Brendan Jackman wrote:
> In preparation for implementing allocation from FREETYPE_UNMAPPED lists.
> 
> Since it works nicely with the existing allocator logic, and also offers
> a simple way to amortize TLB flushing costs, __GFP_UNMAPPED will be
> implemented by changing mappings at pageblock granularity. Therefore,
> encode the mapping state in the pageblock flags.
> 
> Also add the necessary logic to record this from a freetype, and
> reconstruct a freetype from the pageblock flags.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

nit:

> @@ -434,9 +431,20 @@ __always_inline freetype_t
>  __get_pfnblock_freetype(const struct page *page, unsigned long pfn,
>  			bool ignore_iso)
>  {
> -	int mt = get_pfnblock_migratetype(page, pfn);
> +	unsigned long mask = PAGEBLOCK_FREETYPE_MASK;
> +	enum migratetype migratetype;
> +	unsigned int ft_flags;
> +	unsigned long flags;
>  
> -	return migrate_to_freetype(mt, 0);
> +	flags = __get_pfnblock_flags_mask(page, pfn, mask);
> +	ft_flags = (flags & PAGEBLOCK_FREETYPE_FLAGS_MASK) >> PB_freetype_flags;
> +
> +	migratetype = flags & PAGEBLOCK_MIGRATETYPE_MASK;
> +#ifdef CONFIG_MEMORY_ISOLATION
> +	if (!ignore_iso && flags & BIT(PB_migrate_isolate))

			  (flags & BIT(PB_migrate_isolate)) ?

> +		migratetype = MIGRATE_ISOLATE;
> +#endif
> +	return migrate_to_freetype(migratetype, ft_flags);
>  }
>  
>  /**
> @@ -570,6 +578,15 @@ static void set_pageblock_migratetype(struct page *page,
>  				  PAGEBLOCK_MIGRATETYPE_MASK | PAGEBLOCK_ISO_MASK);
>  }
>  
> +static inline void set_pageblock_freetype_flags(struct page *page,
> +						unsigned int ft_flags)
> +{
> +	unsigned int flags = ft_flags << PB_freetype_flags;
> +
> +	__set_pfnblock_flags_mask(page, page_to_pfn(page), flags,
> +				  PAGEBLOCK_FREETYPE_FLAGS_MASK);
> +}
> +
>  void __meminit init_pageblock_migratetype(struct page *page,
>  					  enum migratetype migratetype,
>  					  bool isolate)
> @@ -593,7 +610,7 @@ void __meminit init_pageblock_migratetype(struct page *page,
>  		flags |= BIT(PB_migrate_isolate);
>  #endif
>  	__set_pfnblock_flags_mask(page, page_to_pfn(page), flags,
> -				  PAGEBLOCK_MIGRATETYPE_MASK | PAGEBLOCK_ISO_MASK);
> +				  PAGEBLOCK_FREETYPE_MASK);
>  }
>  
>  #ifdef CONFIG_DEBUG_VM
> 


