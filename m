Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B632D35166
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 09:59:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CA516B0005; Wed,  1 Apr 2026 05:59:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47AF96B0088; Wed,  1 Apr 2026 05:59:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36A276B0089; Wed,  1 Apr 2026 05:59:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 244B06B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 05:59:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CA235C21BD
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:59:34 +0000 (UTC)
X-FDA: 84609539868.09.2AE822D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id E3381160003
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:59:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZvURe5r5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775037573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wCTDjSG3NrB9avrpGmqCkSTa7TNWQs30m9m5VSeE/Gs=;
	b=PJ7hy39boXXKqMbGb67ds6p2xdai1TRjZ6BAjnMQeU2e9teZDUImkk10eFOZJF2Z2K6LLK
	g2wCDdfusJz/o8NSYv02zsS1rIICxi5/waBTwkpgqBiNyxUdcO5pvP91bFhRwRmPv/SRWi
	l2VPkVm4PajI09pa/QZ+knUpRHAGgho=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775037573; a=rsa-sha256;
	cv=none;
	b=s4CyrxKog13SpadZEfGlkYZITzOIYnXURmugiB4IT07DIobMyDTamqSkULIROk2b7kUo7V
	hbBpYcdx5r09GYe6Apgnh6bx/QYVAOaVq+0xIm36Z82gqtef/uaPfu7618Pylf3DQXwV+9
	jNZbVqk6v0urExot1EsVY7gO9dPs8hg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZvURe5r5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C3B3E4071F;
	Wed,  1 Apr 2026 09:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3783C2BCB0;
	Wed,  1 Apr 2026 09:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775037571;
	bh=sE2NJz5Ms6JXDjZrrUZlQ/gxohVll2s38Xf85dSR7bE=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=ZvURe5r5yOCo9ztBIJBW4TMfK36VYFZwKZWDyc9KrUmbIP005k2bj5lm3V5tydioi
	 yOoTyM8nsjW+Lu6kWlK2ZGWtUMu1D6iSTTTvBXyfh6i5Q/fACnVaOoXtHf2NaCCAT/
	 o73G8A5NZQ1Haj2dDByhKlzu0VX3vlNCbS8PSo5r3J22kqM8udbxcK/+FosU390bsv
	 +f+90yIcWXKOdmYIyUoHcc9Zn37TsfC63QkTA9ZKomKIzzMd1GrOJmqP+vyUQtADYE
	 JMmr1eADUcc5cLC9MFmmQfOM3aF2HFizpgysDH8rl/N9oNGFU+IjPHxlnOZQ7HKpNY
	 B4z1WzBjjHJhQ==
Message-ID: <6494c9d9-9598-437a-bc50-54a4b6401a3d@kernel.org>
Date: Wed, 1 Apr 2026 11:59:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/3] mm/page_alloc: Optimize free_contig_range()
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <f61e0fa6-a716-405f-bce9-a2bf4ef0c045@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E3381160003
X-Stat-Signature: 3hnh4tmseqnpcp5ioqb9d7k5qk3iozn1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775037572-754096
X-HE-Meta: U2FsdGVkX19oYTXTMXBctXXK5IESK+kSCEX7dOjkH260RJDfd9Jvo4uYnzoQ6Yt/m7ZpNrEGF0tXhFTbl2KBgpoB9+aiPrn32YAdPe+mNtqm6RS6/dIjyslSM+lELm6uXcyjFEQp2PqWRkvsbfMDyBc1stdt8u5vJBpgygQUeco8rr15TNACsOknn/deNcjMq7sh+2vcyKbsRKyu+IRYLSE+t+OgRrkMEGrop3YZKyaQ4piYqqQNM6wZUy36h7tS7rQ8iRvggy8Ej/G3V7TAw5M25rAqBMt5LMy4hwDue4GSg9BPWoXoITvMDzFWTODJyk7uAMqIMNcQcOhnNYHTDVov9G68BO6l0tmyG/VyzFqpl1esbh+CgQ66K5Vr3XQICCFXbln5+KkD+T8cn7Qf/rm0st7FVpplZF7J4HSPVPyZ7SnssufiTv+QopSnPNU0Ru7fqDeNgn/2OYfSN0AB/V74AzZHAHUdblqrXhrK0j732veusiwrLJxGqSDgM7qCUqH6ZtFRtJsB5nP+EljEe50mQBF5Cg7sZyHPZciYrAl/37SXZnLD/mwP/AWoGxJP9hAIzDpWxSk7Ub1Gfzymuhb3++GAp173zfBzpPVKki9Aqt2o6pGuRjrrHMLWwtkDrxiJfoVch6+x3pFsrfJeuGV7Wyc6lzMKhcMGnkatEPpzX8ZGhyhUKT+ZZusqj7g/6QksB/hwkgexBZ9jnM3ET6c2QD2+dOBkkdzaY+U3DRZ40wy0K1Mf+W6kJNXx80c1e+97It/pEUofXIdVvVLQDkbY5H3BTzIVffEbem6/yQ0HL3fKv5Yqp1wcV/etlAfnZH9HenOk0Rg6zEpb0zAaIY26OFpyGgPO9g5Ocaq7EqiBlzTzNG+++Ccd8Fg6OZTSK8WgISsXpL4UiycRedlNd6MNybIWJ8az63M6k6Bh/eYbX/kX9+H3A2SbUfIUOq7nSwoN7KuSqZSPNb/Khzt
 rVh3chM1
 BML07IghhsB/NuzNK8OPjTNJKqhBIhCN2t4rr2Xr5bRZTfPu3An0YbnFPtuFPWwQoTtUSjSKUtNKu5FtJvahpnWpgWX5mLR4kWzY0ultux8ifMNwWroDE7D+YMoSWHJy4AujrCZevmljUG22XKY9thsHVOF2K7UlUZStxjcCfJ3jEm22WAr7byQU7MMs00R4UY2oaLw/Cic375CWZdpy+Yy6TAeQ0rc+2isN0rSLyQEgYcIhtJzPeX5VnAZAmqGqWnYuH0Oo0Lz5COjoGG9dZTZ/Q+fgj5woEUK5X+k7TcRR++0pPIYer/rRMPdJRtfJAm7EvHZhhMKi3p9CWitgT3IUCpb7hDtZqRCTya9KCvljNmdXI2FTjINNmfZ143p44L1N4k6JzFeBwdY6V1VJDI/5fcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> +static void free_prepared_contig_range(struct page *page,
>> +		unsigned long nr_pages)
>> +{
>> +	while (nr_pages) {
>> +		unsigned long pfn = page_to_pfn(page);
> 
> Sorry for not noticing earlier. I now realized that because here we are
> guaranteed to be restricted to the same section, we can do page_to_pfn()
> just once outside the loop and then "pfn += 1UL << order;" below?

+1

> 
>> +		unsigned int order;
>> +
>> +		/* We are limited by the largest buddy order. */
>> +		order = pfn ? __ffs(pfn) : MAX_PAGE_ORDER;
>> +		/* Don't exceed the number of pages to free. */
>> +		order = min_t(unsigned int, order, ilog2(nr_pages));
>> +		order = min_t(unsigned int, order, MAX_PAGE_ORDER);
>> +
>> +		/*
>> +		 * Free the chunk as a single block. Our caller has already
>> +		 * called free_pages_prepare() for each order-0 page.
>> +		 */
>> +		__free_frozen_pages(page, order, FPI_PREPARED);
>> +
>> +		page += 1UL << order;
>> +		nr_pages -= 1UL << order;
>> +	}
>> +}
>> +
>> +static void __free_contig_range_common(unsigned long pfn, unsigned long nr_pages,
>> +		bool is_frozen)
>> +{
>> +	struct page *page, *start = NULL;
>> +	unsigned long nr_start = 0;
>> +	unsigned long start_sec;
>> +	unsigned long i;
>> +
>> +	for (i = 0; i < nr_pages; i++) {
>> +		bool can_free = true;
>> +
>> +		/*
>> +		 * Contiguous PFNs might not have contiguous "struct pages"
>> +		 * in some kernel configs: page++ across a section boundary
>> +		 * is undefined. Use pfn_to_page() for each PFN.
>> +		 */
>> +		page = pfn_to_page(pfn + i);
> 
> Hm ideally we'd have some pfn+page iterator thingy that would just do a
> page++ on configs where it's contiguous and this more expensive operation
> otherwise. Wonder why we don't have it yet. But that's for a possible
> followup, not required now.

pfn_to_page() is on relevant configs close to just a "page + i". Not
entirely, but I am not sure if the micro-gain would really be worth it.

E.g., on CONFIG_SPARSEMEM_VMEMMAP

#define __pfn_to_page(pfn)	vmemmap + (pfn)


Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

