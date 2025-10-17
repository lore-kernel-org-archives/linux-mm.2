Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96B4FCCD19A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 11:14:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1FC78E005D; Fri, 17 Oct 2025 07:14:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF7CA8E0016; Fri, 17 Oct 2025 07:14:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D35168E005D; Fri, 17 Oct 2025 07:14:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C1A9F8E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 07:14:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7EFB983E32
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 11:14:47 +0000 (UTC)
X-FDA: 84007348614.29.8BD1B2D
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf25.hostedemail.com (Postfix) with ESMTP id 99A8CA000D
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 11:14:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rVS25rQ8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760699685; a=rsa-sha256;
	cv=none;
	b=VQokGW1LyqScj0DHKHDfGO3uVmKkFBZfJwk+kj6Op5X+JSm39GRk7F0FPBnbwF96nF+N5+
	uxbNkMi6bnsJFOH7En01dPe5liH3JbnVs4+dHjivByLVXf+nQbj5m8st6fGQ4aiTGRXZMj
	bi3Pd5sHcysaGvIBFbkYmqD7afoLf9E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rVS25rQ8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760699685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3YA/xLAG8p45THXYYw7JCFQ9A+nLtvOhAjcG32D7eHo=;
	b=MaYbCjjUDJa7Sa/mnupIVyHp5GO97OcKnSOhEHlm6tKJ3VR8ZzqHOfnF3lRNkkl4H5jF3Y
	tYjQ5G6VFHJ1ddOwNoXYGTHs+UAjU4hx0KYFKd47LHoPw854WZlONoHDnbPqfcd/Yv/Tk7
	buRAv+On1+RaDetbxBeIu/sCS0gdyCw=
Message-ID: <384aa808-1893-4f44-9c76-96a21c1989d2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760699683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3YA/xLAG8p45THXYYw7JCFQ9A+nLtvOhAjcG32D7eHo=;
	b=rVS25rQ865xS2yGt3O/yQdSrncZauX78g1/G02hwqFi+vY+Kp8bbebzjrHfnBPsBlcHOSi
	MZU7eFIaVjCdjwWXgV10d1oD6IZmCf/q1+6CrAI8qaqEeiambsRra6jrOmeKlL3E5OWmJR
	tJsIReAZdoG59daw1s1T6JGuSc8jBOA=
Date: Fri, 17 Oct 2025 19:14:32 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 6.12.y 1/1] mm/rmap: fix soft-dirty and uffd-wp bit loss
 when remapping zero-filled mTHP subpage to shared zeropage
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: stable@vger.kernel.org, linux-mm@kvack.org, ioworker0@gmail.com,
 David Hildenbrand <david@redhat.com>, Dev Jain <dev.jain@arm.com>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, Alistair Popple <apopple@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 "Huang, Ying" <ying.huang@linux.alibaba.com>, Jann Horn <jannh@google.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Mariano Pache <npache@redhat.com>,
 Mathew Brost <matthew.brost@intel.com>, Peter Xu <peterx@redhat.com>,
 Rakie Kim <rakie.kim@sk.com>, Rik van Riel <riel@surriel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Usama Arif <usamaarif642@gmail.com>,
 Vlastimil Babka <vbabka@suse.cz>, Yu Zhao <yuzhao@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
References: <2025101627-shortage-author-7f5b@gregkh>
 <20251017085106.16330-1-lance.yang@linux.dev>
 <121d5933-16d9-4eb5-b2b5-2edff9b36c16@lucifer.local>
 <3390d129-e540-42f0-aada-0c8b6fe96f26@linux.dev>
In-Reply-To: <3390d129-e540-42f0-aada-0c8b6fe96f26@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 99A8CA000D
X-Stat-Signature: tcpf7zpfwqeobme4ptippjwgpcn445y4
X-HE-Tag: 1760699685-649251
X-HE-Meta: U2FsdGVkX1/vhxmE8PZ2l+g+++pRieeQGEr9kxUR8SzgMGvdH2Md3FZ7SR53lFF8dVxSoRV3Ve+Td0ry9us8DRiF3qgGXUYBn0S72TvzviEPtkL710sovM779LzRgoOoFE/nT0BAQWJJz0z6i5xootluGrscdPbbs3Qcfugkni0wsFPOzElWWVIxZH7hVu4GfIzC72WhVjEJYrDm8FzKA2AJ1Uv11RCzFjmP22r78xF2PAQuRps1BHJuSdaYpyIngy73doNw8HLnzQWCJvvSMMx5AdV7pBdY5taJVToHBRWHvxc0/6NSUu34k3eOOxQ1OOHg+Oh4AMVfyYTJpFJUn86izimxhnESkV1msrDxbarPAHDY+Am7Mr/7JGojM3S5z12IvlTgWYhhX4utv4nbLJ7Ec7N2bTSiUB/fdD550q5iI92/SD/tjCRfMa+5t+Zyz4oeDuGHUJzZwnViapBUZSfuXvzfGSiL3wVCrhgZ+344HuGjeob2QU3hQmmJgUjcwFBBp8kaA8U/T9ubYb8KpZzCO7n5fNmKg06QjiHdtZdzTrC/q0KnnaadECshr3GtW4oHc7gnNuG5aGvV1zXROb1iT6gVdg4gGWmZE+78W67tZXZ48uWdXjW/EuOuicEu1S3C7HWhZgKpsuM5Oxr59DpfFu+Ai3ZRcL9MDqpqB/NDnb4ZPoLN9R7DDmvsbOP6K10RmbWBGAwZRFDUYkxMlqTjmXUOejJocKFXeqOXPyV5ZgHyMTtJK6q351Sv72huMT947JOIVAqrLBICWKd0P5zCOGIi+XpL8/8jeOYVV02t9OlqGjl1TBqqHgEueRcBBl1SiTSOPFfP7C/SdqZIbaI60uLI30YRkhPWbswaMTjNIvf8ZwSeYEhaWxLQaaiR7ZiUtxRoXW/j+42SdTEKsJuKDBvyVGC0bsZWGz0v1o8kEdmb0G/3XC5OZHe5J1cfQ7NeYO9Is2yE+hyMYNz
 MOW1TYqy
 J2gveI5Z4o1dxryZAtZd2shn2e4spuy8kj5HVEg3C35x01jKkrJcN6X57bXHtYIX5/m2so43yARiM0oCMkRNKdf5loTEL9oqqPlalXWOcZ7gI3+x3LV7Z+VE/X0G9d88gfy7hAnFPeC93kK8Mqg5WL0EFtCvHtdqFjg3aPmAp1JD1+sHhH1bLPIDBI53fXFTlZa3IahN5oz4qhepVnzM+I3dTWngs+N3FnWsgMrz4mpdmizxoJnxRNLHevEIm4Cgv3ZtyA5BqZ3ue4JLbyv7nd3ib2MJgbU2Wgfd9ICNn/46P5cyvqwRXQaxh0vpcENG0Fc1QoUcNoXX4wYSRsOitpsUU3qMR3kuV5DKfi7LKEOYAKjeDlhhsfWkUfSGh2DQBiG9d4rJJGak0NzGuKWG2WzvmdUIjDtCrP3tvW+g5lCo/+8wYmtVFdbJgMg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/17 18:25, Lance Yang wrote:
> 
> 
> On 2025/10/17 17:52, Lorenzo Stoakes wrote:
>> On Fri, Oct 17, 2025 at 04:51:06PM +0800, Lance Yang wrote:
>>> From: Lance Yang <lance.yang@linux.dev>
>>>
>>> When splitting an mTHP and replacing a zero-filled subpage with the 
>>> shared
>>> zeropage, try_to_map_unused_to_zeropage() currently drops several
>>> important PTE bits.
>>>
>>> For userspace tools like CRIU, which rely on the soft-dirty mechanism 
>>> for
>>> incremental snapshots, losing the soft-dirty bit means modified pages 
>>> are
>>> missed, leading to inconsistent memory state after restore.
>>>
>>> As pointed out by David, the more critical uffd-wp bit is also dropped.
>>> This breaks the userfaultfd write-protection mechanism, causing 
>>> writes to
>>> be silently missed by monitoring applications, which can lead to data
>>> corruption.
>>>
>>> Preserve both the soft-dirty and uffd-wp bits from the old PTE when
>>> creating the new zeropage mapping to ensure they are correctly tracked.
>>>
>>> Link: https://lkml.kernel.org/r/20250930081040.80926-1- 
>>> lance.yang@linux.dev
>>> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage 
>>> when splitting isolated thp")
>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>> Suggested-by: Dev Jain <dev.jain@arm.com>
>>> Acked-by: David Hildenbrand <david@redhat.com>
>>> Reviewed-by: Dev Jain <dev.jain@arm.com>
>>> Acked-by: Zi Yan <ziy@nvidia.com>
>>> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
>>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>>
>> You're missing my R-b...
> 
> Sorry, I missed it! I just cherry-picked the commit from
> upstream and didn't notice ...
> 
> Hopefully Greg can add your Reviewed-by when applying.

Looking at the timeline again, the fix was actually merged
upstream before your review arrived, so the commit I
cherry-picked never had your tag to begin with :(

Still hoping Greg can add it!

