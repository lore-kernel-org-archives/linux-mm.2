Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADF5D606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 07:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=pfyknVj+
Received: by kanga.kvack.org (Postfix)
	id CF2146B05B3; Mon, 23 Nov 2026 02:44:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7C996B05B7; Mon, 23 Nov 2026 02:44:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6A916B05B8; Mon, 23 Nov 2026 02:44:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 965A96B05B3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 02:44:35 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 293E61A035A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:44:35 +0000 (UTC)
X-FDA: 85465596510.19.D4F2C27
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf23.hostedemail.com (Postfix) with ESMTP id 14F3E140003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:44:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=pfyknVj+;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795419872;
	b=LVCWnISyPbdaWzUnXgqeEYLw09PF+5pe77FkrJv0XLqNV68sTF74d0eoe4v/5rh/JCYGn5
	th08ZAY41tNWy8IRIA75e/Ro3ObS8u60pgRo9QJ+dkBUZIRYGZUYCenYXDdOjzag4dypSa
	aejT3YF5vGtgD6sBkLf3Q0U22Ndxkaw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795419872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJkQya4c8RJJzm9nBLBXauSmtfVWdU74c+91+UOjFS4=;
	b=itkSNJTx00B8y1w/3/QRFbz4enfoW7QacGf3kASM8h5pKkBKbrpGvzkx8fDSq15ahUTxi6
	TcSoXRP6NCrIww7O6N4ccY49A0QDkK082xTekxInH+1M0LUtnpgFFKvd+3gO1wNI03YaOL
	lYFB8ooP5oUAyMt7pL5+0+mwbE1gJJA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=pfyknVj+;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795419859; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=JJkQya4c8RJJzm9nBLBXauSmtfVWdU74c+91+UOjFS4=;
	b=pfyknVj+Ntk/fM5Yyv7bVnypgJfvu0NR++lSEmjoKpiPkjJvenwVG7s1q0epJMHvYgPJpG4+b56gGp8VV3a3UZaQQwsp4nS6/Kzw51N4dBZ7HKIJqLp9rrFGpk6bY62XBMcQIcKmVPQFGWgq6ekbRGLd6jZOEctt9uIlVE5k74o=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XFFWEwR_1795419856;
Received: from 30.74.144.153(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XFFWEwR_1795419856 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 23 Nov 2026 15:44:18 +0800
Message-ID: <d6c70716-86a7-46f1-abac-57e3c909d214@linux.alibaba.com>
Date: Mon, 23 Nov 2026 15:44:15 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/madvise: fix MADV_FREE handling for PMD-mapped THPs
To: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Ying Huang <huang.ying.caritas@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Chris Mason <mason@kernel.org>, Sashiko <sashiko-bot@kernel.org>
References: <20261119-madv_free_thp-v1-1-a312919e1ee5@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261119-madv_free_thp-v1-1-a312919e1ee5@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Queue-Id: 14F3E140003
X-Stat-Signature: cf5cm3t46zdzd7hpoay4axepozszbcnn
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795419866-918906
X-HE-Meta: U2FsdGVkX1/dtLrT4YFK8OxI6aJ/qEZJ6KL1m3NfZ+M+VkkF5LNU2QZAh6BJOn7+XBopxAYnw8LQ8oO+z96cOKo0pa2rR5zwgXAdT9OuHhUhIDu3nSqQG5fHForPcVXQeZS0rovYKI9QE5jp/Lf7BlZ0fBgde5fVqK2EsUWxYnz5MH9vQhUuvc1ALqdg+sIesjFFaQcb7nGiM3YVvgBjVw6RJDAwyztFVx3U1qi8QPDemAbTHy9MAgeiD+rzCNIyNqR3rRKRbE/kPrO1X329jjJ0MxrErbXSN0p+M8aBvHmWif//sG35H34Wrcl71q+l7r1sYwNFlhACe8w2VW5WJnJeI9YqLIehV2V+4CTRGztdgy+zZSgNdya+U33e1+DieSQo6gS8Ya4gxu1sTAW0Mi6iFvujhtann5OG/Uxgp3pdoz8PyqNWZaPEYUbEPZJYLFywpV1xqFclHCBewB88in2I21ITHEilC9R5LwZCLy2jGc4sETinL2TJtEjqHaqAfDJoZsjhYeWIJQyseuCBNKQMaRrNSRoZD4GHQ9nMpKV1Tv2CgD/XwJgjDpLdDeRvydMTZEfh20gIPlO4JAg50mW0CEgNGEbZ2mJWUlj6UdOK0Mn47sjT+8n5iU+03ZkM4moNdBYNaCC8GfTiM3hOIeZ3WoDg4SfVBA4njumvxlLX8R5gOIKQ8ylzMYADFaIkKw+vA/VqnX6zgXsB77FFBRYGw1AyTB7Kn3lzKXYk42daw1SzhjNDqZayOwiY++UT6GqQ6/kh5L3MOsYg//HDkpGSPmh711R6xFDtmwUXZVuuVGAMng654H2VTt80iYPzmuwKW6TjSRpi0HbNFm0CbTjCd+dKlnJuvT6gsZtq0IbsXgamtYGu6FPwCAW6alGvbEN7BCZehf6mrsyXJ4M19oB3dFhvk51RexysVNwLiDQbWtFUV3cpniLMxH4se0Ffl9oGqT1NplmsiemSJbC
 AM3qWB5L
 cI6bGm7bVTwY8fX44oCRtjxO2LIgh1NLLERUCRrjuxO4up38LziO8nWjb5qh1tQC6wANdJ72jTJzbIxj+B2ThbpOTfH0uqMfwJ5dVz/G4zr9OQyT+XDSEBKE4QNlgEfyvrszyo1t7H+ZT7F/aq+uV7die75ibmJ8prvsK0bpr/p1Lzm6hQsQSYwmkBbACvl4R/GpyiKi2n7GG/3kUvHdVubOfWB2PO18mhPFkOd93PKDWAII/AjYjizbfsf5bulGDNiScaYsBpT52gwHi3pw8ituEtDzU/wnwA41URJEDYjMj+LRnsw7IZPLzbJ6wg6STyRrwcDptormF8JgxSNJzb8NnnFgyS0f9KFOBCeKUAr53sFOcbI2cfkcbbb4xOtW0eeiJFGiQzlc9n2OMLYjBJUVNWGBEBt2h4CRxURC9IGKOiUN28xn7zh23dGa+YtRxBGG0VLLoiPlsVhLircZlNb1lYa0ggvHkQe1qmC0o2gmwnLzCqmqwZ1t7Bpp635pg4dFsQEOBBDX8AaNFd0hpt56+n9WWOtX6cpjf1kA8k+yQ5fOVI4wDh9zKohtjppjqC4sxgwNKi4C5oOLdYlfNZV09RQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/20/26 12:04 AM, David Hildenbrand (Arm) wrote:
> After MADV_FREE cleared the dirty flag of an anonymous folio, reclaim will
> later free the folio without writing it back if no mappings are dirty.
> 
> If our folio is still in the swap cache, the swap entries then point at
> swap slots that were never written, exposing stale content of the swap
> device. Bad.
> 
> madvise_free_pte_range() therefore frees the swap slots first, and skips
> the folio if that is impossible. madvise_free_huge_pmd() does not, and a
> PMD-mapped THP can be in the swap cache if try_to_unmap() failed during
> reclaim, for example due to a racing mlock().
> 
> Further, madvise_free_huge_pmd() checks whether the THP is mapped by
> other processes before taking the folio lock. Another process that still
> has swap entries for the THP can concurrently map it from the swap cache,
> and we might end up clearing the dirty flag of a shared folio.
> 
> Fix it by factoring out the folio handling of madvise_free_pte_range()
> into madvise_free_try_prepare_folio(), and using it for PMD-mapped THPs
> as well. Hopefully this prevents further bugs.
> 
> For PMD-mapped THPs, this change implies:
> 
> 1. We free the swap slots of a THP in the swap cache, and skip the THP if
>     that is impossible.
> 2. We check the mapcount under the folio lock.
> 3. We no longer lock and check THPs that are neither dirty nor in the
>     swap cache, just like for PTE-mapped folios.
> 
> For PTE-mapped folios, this means:
> 
> 4. We check the mapcount once before taking the folio lock, to not lock
>     folios that are mapped by other processes.
> 
> Only compile madvise_free_huge_pmd() with CONFIG_ADVISE_SYSCALLS to keep
> !CONFIG_ADVISE_SYSCALLS builds working.
> 
> Chris and Sashiko reported the missing swap cache handling for PMD-mapped
> THPs, the other issue was found by code inspection.
> 
> This has medium urgency.
> 
> Fixes: bd4c82c22c36 ("mm, THP, swap: delay splitting THP after swapped out")
> Cc: stable@vger.kernel.org
> Reported-by: Chris Mason <mason@kernel.org>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/sashiko-outbox-202086@kernel.org/
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Make sense to me.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

