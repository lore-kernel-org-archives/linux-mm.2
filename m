Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC432EC1EB3
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 13:10:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECAE66B0089; Thu,  5 Feb 2026 08:10:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4DF46B0092; Thu,  5 Feb 2026 08:10:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D22E86B0093; Thu,  5 Feb 2026 08:10:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD33E6B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 08:10:51 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70575B9EAF
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:10:51 +0000 (UTC)
X-FDA: 84410437902.14.B42A702
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 628BC14000D
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:10:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pNYfAeQa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770297049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kqcpq1/LMRNsAtpRSbNB60qL1vcRdGvx5RXelBDv3v0=;
	b=E85t/C+I4HNjMx+dhrtooYkj8qF4iMpOQNJlzjyo9gLZpx2TcS1FnIBVyjcNJPOpEw9BSe
	rNXiMNXRIFnPwQW7Ihv6n8GD+2KrvEc8QXYENT2s6LAAYoaXDf4UtzlB8q1MxyAO8rAEVq
	lAYzy97Io+9Vltkqz6VqplW1UwF9jGo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770297049; a=rsa-sha256;
	cv=none;
	b=crq1bVzYnlYH+EfFcQp47PMjRwBuqy9jP75hced3WDfjhg9MdxPZ50zROurTQ6fnCn8EGO
	VIwPt2dpxt9sEz/KqSdNPR2wkouX9TLOUrTrvffeUdEp8xA7K+eFA1xAYdv8qfHX7EcdRO
	zVqjWqsXy/YhB0qkZcSllvq2G6OHcp4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pNYfAeQa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 21812433B5;
	Thu,  5 Feb 2026 13:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFC0C4CEF7;
	Thu,  5 Feb 2026 13:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770297048;
	bh=YNe9Nz9GlYTd64O1KTiTpwt9/xT1kD1kmstkqnvmOSI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pNYfAeQaHzQS4JAIIf5RMJS4M1jrbWEl3KdV5wQ1CVfmAFYOtRX+59SIn8fmPO8Ex
	 tkfXAh3SXYC3mzPHaYTYbNsTm8rtvbpWyuIcuhhDdcNdq377k6vzTZdarqvtilL3D4
	 Xf7+yiULCpU1+aEzuPb0FLB9CQSTB8MvWMkcFMDB5mJWXPUZ0ommmMGYPHmT6kL3rY
	 qyMG/T2JtOKIm/hWkO7u/asLSIi4rUjArZSx8eVYVe3SeX/U9MUJb01oH/jG6auYNX
	 sdh+Fq9oU+SuPthWrlrJpd2rDQNhsEp6q9NPXTzVBkBmuBLwpHUR29VvLiXSZaTSkg
	 51OS4qEEhW6Pg==
Message-ID: <e5831f0b-88c5-4a20-82b3-6e5952388132@kernel.org>
Date: Thu, 5 Feb 2026 14:10:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 08/17] mm: Make page_zonenum() use head page
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-9-kas@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260202155634.650837-9-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 628BC14000D
X-Stat-Signature: h3rxx3akzofo8sk1rjtydtkezdwf69jq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770297049-156731
X-HE-Meta: U2FsdGVkX18tLSAO2PRP/RV9CJ+x8v4ht/1RwC+leM3aKDrmgqvecPbXpij/vU/gc1Pb7xO+1AG2svEuyf2GwTMwKH/KMw2eHLz9LYK26HZW1UvYePUhLyx3UXpCjG7moqlVdv28/blL5VSJ25/cxPhj70D1DrcFfCbH1b8PBrXQ7SzfvmJF1BnOVxQVu8exoMYBAf5p/Y8tslrR2ZZDsHtXnfIT7Sx6ILGPIev0E+1J78hUN3Bh9noEw3hS2RhYa+YsiUhFDTwJsytgipfXsf7zAGyoqwksXpLJiQvzBev9VQtYxEkVDb6CNOPavLsBRUlwKexwaNYtAT+fBrul9ctT1bHVXC6GjDnNj/QI32A3e0g+D4Y1KUByD+UerBlDSQpqe/4oXkd9YCQmk2ErrqYXolDLsdmq9qi/r3scYp/oYnhGv2xSNcHmIkbJWzIV8jzcObIEDN3KHJVKoS/Jde9FCx+qWnuulGDmuA9lDtB90+PH/CPA2CxcP8ad2lhJ2fri3ZRfeEFNElrEjAk36ueO7KLnj7RGPzm4Tkx8G2OHdIwceETOHHXCgsfWe7U0PWcEC4W97V5/Lxb5Fg8t7trCNwBzcAypO3HlT8TT118P+4dZzDjrUe/YmCr1O1/TIXMu1ERhVSOj/xFtTiDbo+8J5996BCugezaSHHpmIXr9y0VswBYakzGhAHU0gsq6fLA2Mb/dmOSMgkHi0+GRuKZejPj05bK0FE5sMCMMTrXks728wioi4y4ZfGGtNH+KUuPaBezpd15Qo5agoyqU7RWH8KwW69SoO/wqi3POQF3rNKf8GH0fHocWsqFSm93XoV30S6YnWumjbLEfBI9GyRpRUO1czFF61ZMcZVFAJItj78EXYFtYqe6Ivi5u1B+E3aAYBoSOms7OxeYwe7V0no5VoNnOJ07AOk9HFgfITF8CiOeAGGAJ9ZFu4lVorcLrVM1aMRtAriwn2+Phmvq
 slehrSZF
 eFdgUgn8CrKDTmwvl0/sQz6h1nWgcT1gg5nh5GcN+cwSGgPuaZPAdPCHccodRV5IE+CDvHpX+lqfdO3Tvx6c+yv1NzTnq/EoYHnGr78+RhOuFadkJTYHVZWmkEFbxxWL+L1kdvYZ5izSvm8Ogpqiwsa1N2pEi2S6GZibgANeQ9QP0gS1NFQa6pibgUS98DdtksBf8Dh+lXclDIalY0ipZKTSrtYRLiw4wPU41EDB00PTXk2QOb2elCfVjyX0WD+cv6s8DsKpblV047Iyp5PzFYLReAPQbfDhKvQD1KOAC5bOuNrgLnOlRZuGocHt8RvNgpxmqxsR4KHB+aVpkQW4PAXwhxk+c4gzpfSGq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 16:56, Kiryl Shutsemau wrote:
> With the upcoming changes to HVO, a single page of tail struct pages
> will be shared across all huge pages of the same order on a node. Since
> huge pages on the same node may belong to different zones, the zone
> information stored in shared tail page flags would be incorrect.
> 
> Always fetch zone information from the head page, which has unique and
> correct zone flags for each compound page.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Acked-by: Zi Yan <ziy@nvidia.com>
> ---
>   include/linux/mmzone.h | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index be8ce40b5638..192143b5cdc0 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1219,6 +1219,7 @@ static inline enum zone_type memdesc_zonenum(memdesc_flags_t flags)
>   
>   static inline enum zone_type page_zonenum(const struct page *page)
>   {
> +	page = compound_head(page);
>   	return memdesc_zonenum(page->flags);

We end up calling page_zonenum() without holding a reference.

Given that _compound_head() does a READ_ONCE(), this should work even if 
we see concurrent page freeing etc.

However, this change implies that we now perform a compound page lookup 
for every PageHighMem() [meh], page_zone() [quite some users in the 
buddy, including for pageblock access and page freeing].

That's a nasty compromise for making HVO better? :)

We should likely limit that special casing to kernels that really rquire 
it (HVO).

-- 
Cheers,

David

