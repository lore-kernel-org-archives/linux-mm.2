Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9FBCFD5310
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 08:45:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F21C46B0005; Fri, 27 Feb 2026 03:45:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED4456B0088; Fri, 27 Feb 2026 03:45:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCD8F6B0089; Fri, 27 Feb 2026 03:45:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C8C4D6B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 03:45:19 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 536711B796C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:45:19 +0000 (UTC)
X-FDA: 84489602358.08.2301195
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 98F0A40002
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:45:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lEGAfAq9;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772181917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bROheX+CGuYoF3pyuyZ7Xe0Ef08TUwZy1bB2PjiNHkY=;
	b=B7fSFQPkNoKE+MTiGdSFp4hm2Kq1FbI4Har2IEg60ZZFjCCrUq0hbqmXYz82XakKntQ7sO
	sxziDhs2eTzxET6qJDM2dy7LjRJfqHTm6e6gYXm8FiwbUzj1teB425WnZ+dDUF0UPF5Kwr
	BcpBczPchPgcb3oPkkkUNQ3x48BfUI8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772181917; a=rsa-sha256;
	cv=none;
	b=hbNwQuekKzn3KS2p1LSxawC/zVL8kzV0zpZaPGc783P7FzMlXnxeILJPfTK3AZ9MR+zH4I
	T0Jn2DNDO8QwyG8qpXEospt8jDy29X58Y5xDLSNs00V2UNLCYL4N4QoTFTJ1+w1m/UzyHI
	0xe6ejWmREoBRTdB+MqMFb8BNLyMpQI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lEGAfAq9;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B483C60008;
	Fri, 27 Feb 2026 08:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE0BC116C6;
	Fri, 27 Feb 2026 08:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772181916;
	bh=M3wiUV92iKKp8CgWC8J6GoLftiC/em8BQZ0MsIGSMhk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lEGAfAq935TU0KRtBBEWHVxzGrMa5zoqShGP8N9yO5S9/gmcV2y+tC+Tz0zPyvBNy
	 3cQyjoyFvIFs1738k5ViVxk6RttUCy2/yS2qC772eQRbRI/fwoYOMQ/ih0J6PgV1o8
	 Isu4cXQ4dh20jgdgFReFILFJ8wkKe+t3uWi4qK/vJMHtSi3vO92utzg2/PMbkSGYPA
	 N1EzOq9Aj44UIr8INxTuHHDN1efAPeB1WW3s7M6Gcg1O6/nOjFGkBFN1DWQacC7By1
	 bvexOIZIsTvoqRsw4U1XrxeeQDyN59dZ51q8Yg5wsEmBvXqLLoJh70EYIt9IP83qS4
	 nwnA108U1fN4g==
Message-ID: <8ca84535-861c-4ab0-a46b-5dfe319ac8ac@kernel.org>
Date: Fri, 27 Feb 2026 09:45:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 0/3] Decoupling large folios dependency on THP
To: Matthew Wilcox <willy@infradead.org>, Pankaj Raghav <p.raghav@samsung.com>
Cc: Suren Baghdasaryan <surenb@google.com>, Mike Rapoport <rppt@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Michal Hocko <mhocko@suse.com>,
 Lance Yang <lance.yang@linux.dev>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 mcgrof@kernel.org, gost.dev@samsung.com, kernel@pankajraghav.com,
 tytso@mit.edu
References: <20251206030858.1418814-1-p.raghav@samsung.com>
 <aaEsOu0hgCUznzl3@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aaEsOu0hgCUznzl3@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 98F0A40002
X-Stat-Signature: 1taykt8jgqh73h4mp16mwr4qpq53csxu
X-Rspam-User: 
X-HE-Tag: 1772181917-144394
X-HE-Meta: U2FsdGVkX18ojZC/zzQaphUiSt5a6MLyb15DvMkP59ki0012Yzt2LWtdfLy4j+cZ/BBXzyVSA791/c+KjRBNP41KgpSv4tBTeCtNvoqHw+GY23aubzUit5O/JdYsKiavbcjd32qBoMpS0roCXIdfXyMQdUKZy8j0dhB79Kl3EfkauF65gH+OkNZrcNbdz900BUCUFyzZ7fGM4MJRlrxl6loWNMNzWTz0YyVVT18t3fNuO4ZcMHJGTGNrEnmD2x2IIbs2nZUlnBD0zdu8HeWp7biJyXYqZMAm5YgZaW1YTOGN57KqlNjUsONcCHbEwh12PoMPjt1K7VIUvTFxkjWpOcxw/kF/vUg3341K/FEIY2QVpi9M6Z8Hs8Ikj5eCnqSlcef/tWZPlaaqjWbYEctUioujN7GhIQFlfHQ+zPVs8YWi3XMhEQPkCJC+nBwGCsWst/2QC99pUB2bHEjPHMSRko/Y6auXliKXaZPIHeBOc020w2sYLoThim3a1XQ98btO2BGudFWygGJn91cE+aNupXpnBXfsB+eWFSGgmc7OcXDVCPQKYdLgSyEcuNwALl//2x+M/Ms1zFa5g/0pMhmpKMJdiGRrcfCNNW4fR8O05j+XxGYG24tzpfJdHjeKRzFT1nAtHto5rp2efyg4myjnGpuDTZ8DZp7I6UL5PgxJDaapqa2Tnp3redLbOnyZZjaXXmHDQ/X8p1sFFsTl37uykf15BnBcZOeEwo6xJBYsz3JYfewWFVauq9dEKuHZQpMVTYz8F+ljISl8w6+YLXJu4cui5AkqRR78z7TiZCiubAXyejSuIMGTQcOBiu8mnZAOKX/DkDQvhL1UQPSea+VIdICE/bPZeyQ2lg2vMw6tZAwPVhDcVr8tuIo2E/ZWSXpM+cL9xxiEpSo3QvSiB5a2JINp7SgO7q8JeKxmXrKODMSuQlVYS3OZDl8TcJOvBR5jB6GcPsyFGl9ijRd1sdt
 1LxBAEws
 QpO5kfAqYZ9Gl4ZJLHaU/huqPmFfaY6qKkQm5hZQmxe11TI3iXlk2iW/ktap+eXOXww0eOAQTFyoFxzWDC5cXmfhnjstzxoLfkcZlluc4QDRZy91RAexTwXvAxKKpjat2vAlFtMohULJTjqe+E/5SOD7RNGeHn3MihnEcTEnmRnXiXM6vo4fhJ3NJ3NWXPewF5wnx3+Ay5Fr5Sui4yjD34D+P01y2xO2tZS4/+faePv7B7kcgC4S6zAKhWxGt7+NPNY76
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 06:31, Matthew Wilcox wrote:
> On Sat, Dec 06, 2025 at 04:08:55AM +0100, Pankaj Raghav wrote:
>> There are multiple solutions to solve this problem and this is one of
>> them with minimal changes. I plan on discussing possible other solutions
>> at the talk.
> 
> Here's an argument.  The one remaining caller of add_to_page_cache_lru()
> is ramfs_nommu_expand_for_mapping().  Attached is a patch which
> eliminates it ... but it doesn't compile because folio_split() is
> undefined on nommu.

I guess it would be rather trivial to just replace
add_to_page_cache_lru() by filemap_add_folio() in below code.

In the current code base that should work just great unless I am missing
something important.

> 
> So either we need to reimplement all the good stuff that folio_split()
> does for us, or we need to make folio_split() available on nommu.

folio splitting usually involves unmapping pages, which is rather
cumbersome on nommu ;) So we'd have to think about that and the
implications.

Could someone stumble over the large folio after already adding it to
the pagecache, but before splitting it? I guess we'd need to hold the
folio lock.

ramfs_nommu_expand_for_mapping() is all about allocating memory, not
splitting something that might already in use somewhere.

So I folio_split() on nommu is a bit weird in that context.

When it comes to allocating memory, I would assume that it would be
better (and faster!) to

a) allocate a frozen high-order page

b) Create the (large) folios directly on chunks of the frozen page, and
add them through filemap_add_folio().

We'd have a function that consumes a suitable page range and turns it
into a folio (later allocates memdesc).

c) Return all unused frozen bits to the page allocator

-- 
Cheers,

David

