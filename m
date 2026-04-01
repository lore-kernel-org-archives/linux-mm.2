Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5981ED3516F
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 10:12:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD3786B0089; Wed,  1 Apr 2026 06:12:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A82D86B008A; Wed,  1 Apr 2026 06:12:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 998896B0092; Wed,  1 Apr 2026 06:12:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 880886B0089
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 06:12:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 41370C732D
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:12:50 +0000 (UTC)
X-FDA: 84609573300.01.418E890
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9F538120008
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:12:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OCXYVFld;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775038368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OD0k9AJ3UpzyF9Yn3cB/ZfRwK+vx10BjMfdC3hZwL/4=;
	b=dgndjmNNR7t6+3ww3B/UHpJj04DKHRa+Zwvq2+YnclWhSNcHwar3zFGgHFtvMBJsZOUWJN
	656rEgo5n3O2HN7g8b3zwQetOQ6uesfScEyj3scLQiA4DMT3lO/1nGwRIHhW9GNu6JOWpI
	k4hoFkHec/t2lhJf812OSCGEmnM3AG4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OCXYVFld;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775038368; a=rsa-sha256;
	cv=none;
	b=pmH7dxX+C3EbvUZH0C8IkvbVprT1yMCz9aAZ+GhAYrSkniwF4aSKLbc2AZVHq55JQVRh+w
	RSfGObvUlcF0btqb3FGM03CQSTCl9tUikaNrsLHUirqYqA7mzY/7MvF3JZlakjvCeNMBtM
	aJYvj47/3HvvxtteHaVpx8/Z4V/CTRw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 18E7C60120;
	Wed,  1 Apr 2026 10:12:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F0EC4CEF7;
	Wed,  1 Apr 2026 10:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775038367;
	bh=3kIhoicvnvPNpK62DGxhaQUxpRFDPvITbIvEfhgwgNs=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=OCXYVFldXEYiEAxJXFmtpXA0NEPxJzrGmpN0jD5zvFU6Rmn9UA8J11scE1RMDpvZw
	 QNSbZA4/ml5LU+x3ITrz2d905VM8/2fC6jyFvrOG8AUaOysxOwJG/xeAL9eBP+MJYV
	 iDDWBdXBRv1naQF0C3ukUtZrfKNitgbvQ43iFgk8MZNueVT3ehZHRrej4U2LBnuD61
	 mtNMiClIn74kFJiDpZ5ZiULEPttAybC/iqog8YM9Rnp2MzDK/kYaPqOnaMYhRJPOVj
	 +Ox2NsvoK9jLyW8yNF0W2/jCzQyfdOeo2Pg3MAKbOFyEWCP4SsqUHNpl3yaKTY/oeL
	 dQHKcU4jfF6qw==
Message-ID: <9fa011dd-156d-4e92-bc27-340ee85ed904@kernel.org>
Date: Wed, 1 Apr 2026 12:12:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/3] mm/page_alloc: Optimize free_contig_range()
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>, Vishal Moola <vishal.moola@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 Ryan.Roberts@arm.com, david.hildenbrand@arm.com
References: <20260331152208.975266-1-usama.anjum@arm.com>
 <20260331152208.975266-2-usama.anjum@arm.com>
 <f61e0fa6-a716-405f-bce9-a2bf4ef0c045@kernel.org>
 <6494c9d9-9598-437a-bc50-54a4b6401a3d@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <6494c9d9-9598-437a-bc50-54a4b6401a3d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9F538120008
X-Stat-Signature: anh4xw69ucjfmrd5kmktrjcmiy8cgzas
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775038368-678528
X-HE-Meta: U2FsdGVkX1/Z/OXFaYBoexhqvkJSKgUf18vTwo8ElI+lTbHKK2VY5oEZYMpZ8GrO/OhG0QmKIJVHQhsx0HFY/n4UFwIz5XPw1yCtfgKXd2nh6N2wT60U3l0YS7cX/GvgdsCmbLtHo/tPL/HqiquaEeZWlI0SlaUF3kJUTE/Db8A0dU90Cq2mJi8wtmcOci60rVNyCeemMjOG7zoj5F7xDS5eCRzwhKZ3Mk+X01dj1tTlNCGpAlGIcSJH8latj46BpGEBvHvE/K95oYbSHUkPK5FKaI5mHkbJzlTgG4DFnx/3kmjx01u/FiOO424Y1RusZfnSx34/3LuYonuxFum52el6FdeoXlWNJxhHEbk4hJUA1JuHmvMMl3IKIsm8mzggTHuOEvHsxN8ybC9IEmth/+0lc324qMTLyaFSfVAK2QBi2QS/7ofXEjouX1+4zvuhMR8bd5xUzIkhXjKnu4lier/ynvb4ruTkwOGVgEkFQGWQHYS9ntZbKJ2JIBslOBjb2lfb7f7j6gNu1kxYqDOObfWaLnFvqVgOC1hI90boCU/hhE+Ry/8SycygkSiaI81ph4llyIrHMRc+fXPY51uQF4eHlrlZOWkLLBmYWWnodZ0QPS0f/W0jc3APSxfMMJUJD0Q7rWwr12Edo+v4sWR6PmPjjqyFOUbsMo/CKmillODOCs083zoGJvK24pSJRBNaEQQO0CWTZYmR9LILbf0h1qC5tW1+4h1463thGWcx1lAvLiucEPM9Y5L8lgZTnC87DsNCzEgkLOfhEzoDdtcRO9KBZ2zyFrJujVVhjCz4GGfECqtT1EK61y5qvGx3w2MSCbTtc6ex/mG3BzRnIF5vXk0cHsLqMRw/B/bNa/cBKyCL6i2AqaPN7oZ+GbHXOa9ZdCrM5ntgN/O1SYIeRJJ1yJOrbJLDyISicei3nrgt5bPlrXQfVDSL6jwpJWTPBO22y+64wV0Vs/OSAFiTz1m
 S7+ui5V4
 Qa65UOgTFcJZ4AkHKEbQxuDLauv5haypxWVJlcB30/Akb725fbedE4BObNnYnIFfdHyT+RYfPrL85+K66vvATVXH9D5pQrYTumCXiqkSZssZyhUKYesptiwVdS0E+zBlj7N6cO0TgRCZI7WO3jMuoWHUaHj+qi28Toi9a1g/khIGJC3mM+MU16r5g4sLXw3KEvhfn4fDlApTVWCUrfrbbh6N1gis3boS3uo+oHe9O5PrDrM8ltmkQLDeCZDD6cWH63l2aumnZa4d9QbM0mlpnmYk8nNb/Bvj3uOh76l/v/g4Ro+6VP6zB4QXlL4/Q6Db8Hv7O3bHsx+XQPU3FpzvEZcCHiZ3Yh1ChwHGg/TwaZu7tMRF9r1Ms5KR0iTa+a7q7a4si/6Y+7l57s7zYvRs2MA9kUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/1/26 11:59, David Hildenbrand (Arm) wrote:
>>> +
>>> +	for (i = 0; i < nr_pages; i++) {
>>> +		bool can_free = true;
>>> +
>>> +		/*
>>> +		 * Contiguous PFNs might not have contiguous "struct pages"
>>> +		 * in some kernel configs: page++ across a section boundary
>>> +		 * is undefined. Use pfn_to_page() for each PFN.
>>> +		 */
>>> +		page = pfn_to_page(pfn + i);
>> 
>> Hm ideally we'd have some pfn+page iterator thingy that would just do a
>> page++ on configs where it's contiguous and this more expensive operation
>> otherwise. Wonder why we don't have it yet. But that's for a possible
>> followup, not required now.
> 
> pfn_to_page() is on relevant configs close to just a "page + i". Not
> entirely, but I am not sure if the micro-gain would really be worth it.
> 
> E.g., on CONFIG_SPARSEMEM_VMEMMAP
> 
> #define __pfn_to_page(pfn)	vmemmap + (pfn)

Oh I see. Yeah agree not worth it. The compiler can probably turn it to
page++ already then.

> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 


