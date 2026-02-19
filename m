Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D747DE9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 16:00:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 197B06B0005; Thu, 19 Feb 2026 11:00:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11B866B0089; Thu, 19 Feb 2026 11:00:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F35BB6B008A; Thu, 19 Feb 2026 11:00:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DCD666B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 11:00:28 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 85CE01B586E
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 16:00:28 +0000 (UTC)
X-FDA: 84461668536.30.6AD0EC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id A0DEE40008
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 16:00:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VDS6Ww5p;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771516826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s6K1Y2hYAQR9A928JdXRY41r2eMvsWf1aqdX9/1ul4A=;
	b=2TDsxG7sK1ppaNiVUmWsVKwo5Cvq66/u8BRC0hlGqiZzEw1Rf1MhdPluS/CDdF1FHD5D70
	qpnWbKjx6tSh3kXCYBK2Es5RmeG9YlDG5ftVLLGPWjsNKP7vkOiACKTKBvEX4fQtpn8ooO
	RNh4tK8tMkHSAqx1/FxvSGK2hUk2JKI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VDS6Ww5p;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771516826; a=rsa-sha256;
	cv=none;
	b=JORt4vLZcfS02Iq3qKWyaFwl13jtmMsBC0niI5G0Kpl7PzTjxUdQ8O5UGvFtb6ObbsJqD9
	H7OfDsm8NG4rEl2yOFyRJKHG+jlSBKuLBUC9xqD4YVNdnaL3tcxKEdaTLLRwatidUiZFLG
	fyUdOkjf96lCvp4vwd2nKSXXuzPxxJI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B05243F40;
	Thu, 19 Feb 2026 16:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC00C19421;
	Thu, 19 Feb 2026 16:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771516825;
	bh=6jRlSyeeOj3lGQGeEjhRS4KebTzltCXVjpVFvPwNnB4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VDS6Ww5pRdeHoyx+dQBaH2T/gzDqZVoehxCCahiiC8L83aNazja+EkirM9s5yBvmL
	 BIJcd3JRXxbi/C7/7msEVHe2vd5lNcvW0rvV9RGtlXmBbCFYIc1tAEnH77JWsfS3WY
	 H4+xB7CloEPt8v/10pLOdCskg8aTCn6ltD4D2MVjBLzeWp2XXfKkfqqH5ZaNwh7yP6
	 kLIXs3KIAce1MraGX8VjE9kNIvHVseax27kkRgBiJlQa6keoVcpgjwx8u8/cPkCgIk
	 uRDazFO25e/WwUyOe8ARZosjS19Nl66Y0MX9zxu7zP5+4zuD05ggHczIVGRi9qq+gQ
	 cVyv07782rGCw==
Message-ID: <3485c8c8-9bfc-4725-885a-626e79d0aebb@kernel.org>
Date: Thu, 19 Feb 2026 17:00:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Beyond 2MB: Why Terabyte-Scale Machines Need
 1GB Transparent Huge Pages
To: Usama Arif <usama.arif@linux.dev>,
 "willy@infradead.org" <willy@infradead.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 lsf-pc@lists.linux-foundation.org, "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, "riel@surriel.com"
 <riel@surriel.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Lance Yang <lance.yang@linux.dev>,
 Frank van der Linden <fvdl@google.com>
References: <540c5c13-9cfb-44ea-b18f-8e4abff30a01@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <540c5c13-9cfb-44ea-b18f-8e4abff30a01@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: A0DEE40008
X-Stat-Signature: jpuu441owmyokqeic5oy5zzuuryf4u7a
X-HE-Tag: 1771516826-504353
X-HE-Meta: U2FsdGVkX18Bnht/ZVVYNwn4fUtpqNS9XO9T/n3GpLL+nqa998vF9U9LJWF4GrJJnuXMkZgLxlAfIf9PoVugLxLoTUiDk7loNK9jbjeVK0MA2dDiIF3BvhsZ6JgtiaEEpvktujanBgARd8UBwN/GldJKkzaR1i04iDs7IsVlAGipDG6YsvioyrSGwPzKwYGr0cu2sMux+AxAp0DHZYCs5XagokS4xltq+8CvkwzeB2srx0zG04W257Wc4sFoNRy5QcRGonL/FAyHYZ+Z2byHIdsrXFUmIa5BRErZHXY1EBGK+xyQuX3aicLGIHnBuD9eRJ1g+SJbr5FVb/oXhrKsUdfrsHSr/FsNIvmW/WEvxrWxcqXTgxnRATTmho1/7ENG5ZY6BYxeBxbGsm5Sf3ZNqA9P6Iw4AcPjIYzoVr++lmxJ1nPOpQFaENxFbCl2phDc+5F0BGXscJO2mvxx4ickMMqha1mMRg8cvXmJa9ne7RC/E10zZowndaBLSt7ho9jMrX0nL/uTk0g3BrTp9GO1gDNkMV7jP+WZTv1mXNF/zWaYxS7SQW+I4pAlE8UoENsDL0dKB4nyGQ2g/WBn5dls7qpwYEStukxFLruJb5QWdhMDxj9TvY/Cftbo8ZlIadqEaDXEonU8RE1gXa5AWEsVdi2DG85pfDbSvdPy4NYDk/OtWybzvx7QkwQKZNdIqP5eEx4mRNCq8d8J3LTr8q96TN6n3Zl2vHgO+Tco3wmTG9DnwmKP4fpMPA2Wk7p4MhPfv/Er/XTVgg9+dyOYrHf3CBw0zqKk+JjEHw5umc1MSTGEVqssG590+iRxxuapUT9i4ismmgbuSChwAGRPGON1a9pwjCrLR7NzeqMapxjZiJAtThnHtY3QK3HrNMxSOAXjpazWn12XkRi8+eZ7kGFyGajIb1i8vk4QoKQ0osyEvK00whgjfk2JM1dthfyqnmdASTR3/6HQK7gf5P0qoix
 MUBXuTQc
 8n2Gk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> 
> I see 1G THPs being opportunistically used ideally at the start of the application
> or by the allocator (jemalloc/tcmalloc) when there is plenty of free memory
> available and a greater chance of getting 1G THPs.
> 
> Splitting strategy
> ==================
> 
> When PUD THP must be break -- for COW after fork, partial munmap, mprotect on
> a subregion, or reclaim -- it splits directly from PUD to PTE level, converting
> 1 PUD entry into 262,144 PTE entries. The ideal solution would be to split to
> PMDs and only the necessary PMDs to PTEs. This is something that would hopefully
> be possible with Davids proposal [3].

There once was this proposal where we would, instead of splitting a THP, 
migrate all memory away instead. That means, instead of splitting the 1 
GiB THP, you would instead return it to the page allocator where 
somebody else could use it.

However, we cannot easily do the same when remapping a 1 GiB THP to be 
mapped by PMDs etc. I think there are examples where that just doesn't 
work or is not desired.

But I considered that in general (avoid folio_split()) an interesting 
approach. The remapping part is a bit different though.

-- 
Cheers,

David

