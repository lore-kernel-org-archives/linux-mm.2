Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A268FC5910
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 10:05:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8869C6B0089; Thu, 26 Feb 2026 05:05:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 830946B008A; Thu, 26 Feb 2026 05:05:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72D286B008C; Thu, 26 Feb 2026 05:05:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60E9D6B0089
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:05:16 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 154B21CB0F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:05:16 +0000 (UTC)
X-FDA: 84486175032.09.C0B03F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5823E180009
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:05:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VMluFYl2;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772100314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i3F5RIFEQ/UwgW3/S4L7YItQqiVTx9i+3R9Z42licvw=;
	b=51CUXaAt+sKKZ3uk9fhnZw4vngR8gx5Ze733TKK5RVLqdtskij0or17+AE+smvepH7FCZk
	iu09HPRLleA0J+WXaodaOSylaz1mJ6Na5jwkc7FZ2zfZNTWO1TcIL4ctThaxN1zz7LEynu
	hjT+vMSqlfDqNMFR0n1eZw8qlP7jMq8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VMluFYl2;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772100314; a=rsa-sha256;
	cv=none;
	b=ezLZHRVxxBvyp+qLaR7cBVSiQ9jKvY/4hlV1A9ZfSsI5Bb+LvE5fDhFZnpfQuT1R2YKkWF
	UKq7WHJ3dxfKPc1hwMhRsVTYP8WUOhvVrQpCnfNMgLywfPSwRuZHT4bnukyoyqrv4PRkHt
	NSv3GYOFIC/SVwGF7c6WQnp39OQc/Y8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A7FE060054;
	Thu, 26 Feb 2026 10:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8037CC19423;
	Thu, 26 Feb 2026 10:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772100313;
	bh=UVl73YTi3WAb0rSLgkjhLjnRTNlC2VQmZE7K1ed7oJM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VMluFYl2qzzCDbgzKI7uHWI1CmImLaX/Med8w2aauu+pKGlxtRo25jCkxNQrOIoaD
	 M247DXq3nXdcAkpXIdKnpNS6XzytyVFC5hQIy/eZIslhE809LU/a2uITqkCcsL0qEg
	 ih35xq+TKmmoPbXkfRxy7dtYUG9kWcuAtyNgVIigFOrEdwLm/gg4jN8mzUk0IWt4Zj
	 fJmE97MlG1NpZz2uOV//4olRp+r6CaVKYKaaWd0G43b1Km51hZX2VEaz6VbLmOWLbQ
	 LIqqEeB0VAUkVd0hVqRs4O0r/LpnybKYnUhafLv4O0Zd+I+2+qJB5j8T26HmGBn49Z
	 5tKtnB7z++GzQ==
Message-ID: <99ea2e25-a2fb-469f-9a4e-1ca2cceab77c@kernel.org>
Date: Thu, 26 Feb 2026 11:05:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Beyond 2MB: Why Terabyte-Scale Machines Need
 1GB Transparent Huge Pages
To: Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Usama Arif <usama.arif@linux.dev>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, riel@surriel.com,
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@suse.cz>,
 Lance Yang <lance.yang@linux.dev>, Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>
References: <540c5c13-9cfb-44ea-b18f-8e4abff30a01@linux.dev>
 <aZ318PoxdAZjqnLX@cmpxchg.org>
 <42CCC4AB-EE32-4279-BB50-EE72756B5137@nvidia.com>
 <aZ4Lg51BVmGE5MLn@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aZ4Lg51BVmGE5MLn@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5823E180009
X-Stat-Signature: j48oxzjfhwnyptd9w39gifisye9bmfns
X-Rspam-User: 
X-HE-Tag: 1772100314-497471
X-HE-Meta: U2FsdGVkX195FckCwkS2HSdgihuC9AmN5bRBoYsRD7PN8cnxrdIcoX4MfgM5YY172Dd8dmG3S39ajK5Q66jZGmJZru+4JBdGTgwZ/UOPjxM3qX9n4IU0vPwbtwe6pZZElkKdAkFrICt1d+NZnhRJ6xhBekbYpyS/ekUUCHLj7X4x/w7cM5H0yGfuV4QDGDtT1PKThbc8V39U0gIO8cjxY5ujQou8wPNUkN4m98wutw0udzhNbjtFhQJnSL26JYcu9Gg3GtEq1VzJSIdhP9O7uwCgva/pNsxlD838iE5XptqoAUgNDhKFBUsAHgxgqi5QjAm5ti8HrvOFkVZQ+3KyCXV+O/pc9MSFYvXzzaCrWfvSqpe+LyymYv2Vd4NUT08fv+kmb+UZL43iuZDlfkmT70lv+KE5jVSwiRQlN40y0ut0M8MH5BwFm/au/cQ4oZds8tVvLI8y8pQS2b0LtLgKLmgQoVCSzyx8UJO+K/Eb/vW/KxmfmF6/xz1KpOUvyAfKJo4cKc969HLxnh+3xr6z3fJdo5aJKA12f5b2fwOefgew0rh+y5yEeR2c/HV+bpDp7IC+G3FVskSsHTafLAgrDWyqprKpx5A+iA54iuicYEXu8moPCQxhuLuypUSyf9SRzOYJwXFkO/3FYgsda+GchaMZQd22dNPGecVYI0JZwg8aVc4q2nxYOJ6Aimsk70/78kTep9Z4MJA9vPV8AoY3DYyGN/cQck0ppmODOvnhbxtR+5NgzopmEmFbJ46botd+gV6h62oL5cJ6IgCt9SOZobyk7cQ9vlkt4Jmbhvtxnlhk5/a6CovZPzxqP4c8YtEfrTsNLRKEJ3vStQh3FvJ70ZxPPRUiH2ri5CA23HDjqCU8f/fPBbXiYXDFN7hQjSDGyKrRGRIKHYRuPK1OFQAbVb1IPPZs6AtBVYC0kgVt/OZYfLsxEmA5uQhUpLn35uUX7NBC44ybrfb2o0nktFM
 FsVWMTI1
 Fe5OzNAMDBCRqsAPVFgYkLpa0iSZRV5+TOLqwg50+EXE8wVwyhi0iPWTRDpgK6m+geUz9N7ZyZMHeeomh6TzNPzAwK3cBw79CC7QafqoDrdR+NveNrtqVOT72zO8OcWiyJ6KFAKztpWmUN7n9cYA+thTsCvXF24ghuEhgNbs+xvVRJKVyzujbQ1loPh6YEel37e5l2zn/RCXjkU1iqjKsRYPWovl8/zpmu31PCO+B7aHNSGzRAJKWh+tkt/Hd3iv7Ar6GtIjRMj6ZkRjKT1lhjipcZ+QQnFVvYJYROjqcL88B2BbnoX5Dgc/XFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 21:35, Matthew Wilcox wrote:
> On Tue, Feb 24, 2026 at 02:08:26PM -0500, Zi Yan wrote:
>> On 24 Feb 2026, at 14:03, Johannes Weiner wrote:
>>>
>>> I know this isn't your intention, but one interesting aspect of
>>> supporting PUD mapped folios natively is that it could open the door
>>> to simplifying hugetlb as well.
>>>
>>> We currently have all kinds of huge_vma checks scattered over the page
>>> table code, and entirely parallel paths for unmapping etc. With native
>>> PUD mappings, this could allow pushing the special casing out of the
>>> virtual memory layer and into where we deal with the page objects.
>>>
>>> You might be able to take it as far as the only thing left of hugetlb
>>> is the reservation pool. Such that a naive application does mmap() as
>>> per usual, and it comes down to a separate allocation policy how the
>>> backing pages are served (buddy, CMA, boot-time reservations, ...)
>>>
>>> Approaching it this way could help separate out the discussion on code
>>> impact and tech debt of PUD mappings, from the allocation technique
>>> question, which in itself is a fairly large topic.
>>
>> I agree with this 100%. Adding 1GB folio support first, we then can think
>> about what other THP features, e.g., split, migration, PMD/PTE mapping, are
>> really needed and add them one by one. It is also going to be a good way
>> of retiring hugetlb special code.
> 
> But this hasn't happened yet for PMD-sized hugetlb, and there's no need
> to wait for PUD-sized THP to start this process.  I don't think that
> introducing PUD-sized THP will actually motivate anyone to do this work.
> 
> I think we have four main things that hugetlb still offers:
> 
>  - Reserved pool (mentioned above) which we don't yet have a THP
>    replacement for
>  - shared page tables.  mshare() is the replacement here, and that
>    project is moving along nicely.
>  - Being able to allocate gigantic folios.  This is also progressing.
>  - Guaranteeing that you don't get a fallback; you either get memory in
>    the size you asked for, or you fail.
> 
> Every time this comes up, I offer the pagewalk code as an egregious
> example of where we force every user to know "oh, hugetlb is special".
> Getting rid of mm_walk_ops->hugetlb_entry() would be a great improvement.

I'm all for having a better way to walk folios, and Oscar did some work
on that in the past that got stalled (also partially my fault for being
overloaded to provide feedback).

But that would be rather replacing mm_walk_ops, not changing it.

The real challenge are not PMD-mapped or PUD-mapped hugetlb folios.
These are the easy case.

It's all about the hugetlb corner cases. PTE-batching to handle
cont-pte, we already can support. Cont-PMD-mapped hugetlb folios would
require similar support (rather easy).

But the real struggle is "fun" hugetlb things like
* PMD table sharing. I don't want ordinary page table walking code to
  mess with that monstrosity. It can mostly stay in mm/hugetlb.c where
  it can die a slow death.
* Powerpc stuff like a hugetlb folio that spwans two full page tables.
  There is no way we are going to add batching support (reading+writing)
  to generic page table walking code just for that purpose.

Instead, I think we should
* Leave all the mm_walk_ops->hugetlb_entry() stuff alone.
* Enlighten shmem to provide 2M + 1G folios from an alternative
  allocator (pool) (like guest_memfd is planning)
* Allow hugetlb to server as such a pool. Preparations happening in [1].
* Maybe enlighten shmem to be able to reserve folios in hugetlb.

Essentially: rebuild something like hugetlb for shared memory using
shmem, and reuse the existing hugetlb pool. Avoid all the nastiness
(weird architecture tweaks, odd folio sizes we don't want to support,
huge pmd sharing, etc).


[1] https://lore.kernel.org/r/cover.1770854662.git.ackerleytng@google.com

-- 
Cheers,

David

