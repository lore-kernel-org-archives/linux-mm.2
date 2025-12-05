Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 408B5D37497
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 20:16:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 925B66B02DD; Fri,  5 Dec 2025 15:16:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D5F16B02DF; Fri,  5 Dec 2025 15:16:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EC5A6B02E0; Fri,  5 Dec 2025 15:16:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6EA6B6B02DD
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 15:16:19 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 09623C0322
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 20:16:19 +0000 (UTC)
X-FDA: 84186524478.29.0C340FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3D90A180013
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 20:16:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l0rdE2Lv;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764965777; a=rsa-sha256;
	cv=none;
	b=KlbH4M7uQxrNhMM/miyapBaC3H1Yadmx9AHWQUw01CSaipdTTGN8DwybhtC7aIcKIhHrmq
	YGSpP9HeW/uvqAJ6Jbo1uJIbwl18hKLsTxIK5GydDU91i3D6CVXm+7P6dvfjvBpsJvBLpL
	pIlOZCCejr9geJBAXTN+s8dl/vmozzE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764965777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UdjaS9SAJo22oNpa7rBj+4wOCa7Vryg+PDKFSGy5xws=;
	b=TPqx9ubIa27dYn1W20g/HeQ+50fNm+65KiEeF6FDe7gfqrue3Or4mMPHvT4G3xsXorCsW7
	DThwhs7SC+2kAVoYQSrYVjP+lhizIAkVIP+GQWhoPk88/PErt2xZHAU5pgYwSfFQUud36T
	A3RCFMpdv9VzgWDf0zN/Du2AfhdPdU4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l0rdE2Lv;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 351D0439FB;
	Fri,  5 Dec 2025 20:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687B3C4CEF1;
	Fri,  5 Dec 2025 20:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764965776;
	bh=E4s57Tz9tzxIMU0MBRYjGC3Nt6sR6FLq2/tAjqCyDJQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=l0rdE2Lvq0UaVW47Slc6FIFIGZOx418XTGKhAETZ5dqpJSeXbmfhyRsV5WPiOZ15j
	 OAzaxT8UeP8NTDe46ldPvIizY6p35Ei5ROnAvPvC1qfQf0m7uyRQurgM67Nm4nuN+Y
	 IHViwqbWJBdJwhBqcKR2ohAp/o3Rgl7JR3o9RHM8DWfkYO2FrcHGW3q2qkG4dod6pd
	 3AQ9bi87HrVN2LhxtPoghHZqZ00CawFFtPmurtCpot3gwBsh/L80OPzHvfYCbYFgix
	 +6F8VBEmS2gYPjp+LuST+E3bgrOV4xI+canQctQZ4vebIj81x1m27qd/5bu0R8qLJQ
	 zyYZyvs1aEVrA==
Message-ID: <e1c50f7e-cec4-4676-b5d6-f6446cd64ba5@kernel.org>
Date: Fri, 5 Dec 2025 21:16:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/11] mm/hugetlb: Eliminate fake head pages from vmemmap
 optimization
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Usama Arif <usamaarif642@gmail.com>, kernel-team@meta.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20251205194351.1646318-1-kas@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251205194351.1646318-1-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3D90A180013
X-Stat-Signature: b7rybh3wyp4fpsq3mqb8z9q877swntp6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1764965777-485219
X-HE-Meta: U2FsdGVkX1++9jkTNjgp3ucFb5b1Z6SSYwBjETT66ILnBxyUQs+8ctVp5xGNqYrowsecs/CUO8dWA7nQmQ+NRgBZaTKvG2B/D81uz5XyTgfRInwafoPEgyLKa0XgvgyknU8UGDxVJ0Zmi3nTaCCdieY44ubItKPURUxqC5MF3vDbN0QVxQNSlY7r1Cpi8GdHAuEPUyg7lCj1izNOOMOMhwq68HLyKoVezIJukhnPk1A5+GXHxGWaJDRgK7FrSwfeQUxdNcqMrIQABSzScXcggJfE4Dmh4oQJlQ0+WC9XaOcdqCeUROMOKhkBpOSsIGCg8rky0gGL+C+MdUsessC/VAuyz7weQY6Ux0p0gWhXca9kJXz1K71T8tfshTIOlhb3uB4mFkhu6KrhgsV/LNofV/Pk5bnFIrIdJFocpHcNlL/Cs9BadRN+9krOJnCdASWi+utETEFuviHslUXV+L/S/rX/4BML3yJOPz7/jUPumngP8iwZn2yxhW8XrleO7N+fzi60MSAMs8lGp49PUBNFVZTQQglul255jF/u2tpF7KIuIlMZNg909haYA3BUkqFTuDr9+qvgd6+MZfaC0A4DY7NZkL1owVv8Dr2CRZG4pFz2XFDrnR21hSbMeaoQofNgz2CvuamGtJIFRNSWACCI9tIw6fy+T4uAxIiH6+uqFy/KxlvphqisSDkSz4Xjf7G6HEeQXHsOfytlxXO7l+WG3m2vGckXzdiUBs9A8Q0ta5XoXM19rmA9OaeoPvokfW3I7OzZYDhu2qvv4lRzayJKiVA1LHdiEr1W8kEpayXl7AMosTB5U5UjfFetQI+6bOe31EtYy3aJZnpMI5I2S3R3Wiv+vjozsCQEC8e9yVLxYI8G+ikOypgw8LapvQ+rOfzynKubvEcmbDlcmSUr5oe7ZQ7LcYWBHICs88b3QzGeACXcvi5D5DQAGhyC7VHuPk1l/nF7eYKMZBKJFaezQvE
 HBvtjrOS
 lUCVx3Ztb3rF+c8AK11D1PSVCA/uzssffOA3koSx/1MIHeUWcUoKKlgCzSoFgc67IlI06FDCS/ZSzOLxh6R7CO/QOk28wc5ME2h1/dTo7EacE3pPGxx4IwGxXqGd7/IkViW8xItT4uqXkFRtSI91oB3Au1FmIs5GiXkTSfsVDbr5FzfBH5P4bb+9lPyNDlUHAj5jOdQWo5L454RP4r32yWqVEfXep1+ePGLi/H6Z8+w95K7XozkoP4AooL6X34tCeBwcz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/5/25 20:43, Kiryl Shutsemau wrote:
> This series removes "fake head pages" from the HugeTLB vmemmap
> optimization (HVO) by changing how tail pages encode their relationship
> to the head page.
> 
> It simplifies compound_head() and page_ref_add_unless(). Both are in the
> hot path.
> 
> Background
> ==========
> 
> HVO reduces memory overhead by freeing vmemmap pages for HugeTLB pages
> and remapping the freed virtual addresses to a single physical page.
> Previously, all tail page vmemmap entries were remapped to the first
> vmemmap page (containing the head struct page), creating "fake heads" -
> tail pages that appear to have PG_head set when accessed through the
> deduplicated vmemmap.
> 
> This required special handling in compound_head() to detect and work
> around fake heads, adding complexity and overhead to a very hot path.
> 
> New Approach
> ============
> 
> For architectures/configs where sizeof(struct page) is a power of 2 (the
> common case), this series changes how position of the head page is encoded
> in the tail pages.
> 
> Instead of storing a pointer to the head page, the ->compound_info
> (renamed from ->compound_head) now stores a mask.

(we're in the merge window)

That doesn't seem to be suitable for the memdesc plans, where we want 
all tail pages do directly point at the allocated memdesc (e.g., struct 
folio), no?

@Willy what's your take?

-- 
Cheers

David

