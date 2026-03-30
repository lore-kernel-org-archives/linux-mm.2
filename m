Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA9511061B06
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 14:43:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C4EA6B009F; Mon, 30 Mar 2026 10:43:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19CB16B00A2; Mon, 30 Mar 2026 10:43:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B38E6B00AA; Mon, 30 Mar 2026 10:43:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EEF406B009F
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:43:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B4B5613B18F
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:43:36 +0000 (UTC)
X-FDA: 84602998032.16.17CEEF2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id CE112A0019
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:43:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bKEN7Mnm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774881815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YPnKNQT8qZcMwnTg+uX2K6I09A0DPexIrPzjSUBrYlU=;
	b=xpIIsXl1vymJBCvBAKTPPoNBQsGNTJQSvjWjL8XPKmVwxXRWwan27ybnFiYXmjZtBcjv1D
	wGNwVcmF50Wid+8hzxneWFfsPVjvYXmzi/CT9M2QM5cXqtr3xShv4UYf87G+sGEl2JFTBH
	8eH9srfGHgXlTefBpZJ1WjigZkn3hFw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774881815; a=rsa-sha256;
	cv=none;
	b=PXscizXBsCyd76w6hJ7FA9bUEBjzoTOb1PjkLDBrClXQpcCpVs/wO9Gy2VtDGrXzXxsCQ0
	JcXnuoXNwtolr8ZFpJvmTpLKi0wUZKUPs1SCQMjTbGvGyi91AmDM9srRPcNL1WnnEGPgyN
	Tl0FQYCvoii2snclbTvACwlThl77Nkw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bKEN7Mnm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D66DF441F3;
	Mon, 30 Mar 2026 14:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0035EC4CEF7;
	Mon, 30 Mar 2026 14:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774881813;
	bh=TFDol533KxC1VeE5RR8wCQD8E1UShDJiXvOYReHds8Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bKEN7MnmA1NGA3X9xq722YzEDA48S4PaPqehA4Ae3TohxxAeA7x8PvvYJDCPVzKvl
	 kp2PE/lfxoniYrgI6HaJsFM0nkMeQ7iNT7mYcheNHMOJAG92JF1jSetErfjbGt7Aj2
	 PvhOdcNSXXsXYJ8HXh8pqhvKzEx7FDkzYcIbLS25Mon8+6C1v7tXY5ac0gdTLXzHXC
	 i/DJZSxCQ2NKsgpA6YkDnNH0VdBO48gKZ8fZciFWuqwmJJm0IeN/ntyHuul4v1Kasf
	 1LpTdF3GYiKnGExzu2BJqvuFmxIm96+cnr2hrvM02ks0hr4Zn6XXwCdoXuIHmXCj/M
	 6uz+R02KRGg0w==
Message-ID: <12d3b7dc-c0db-4964-99e2-6be6744b6a8f@kernel.org>
Date: Mon, 30 Mar 2026 16:43:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] mm: Free contiguous order-0 pages efficiently
To: Andrew Morton <akpm@linux-foundation.org>,
 Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Uladzislau Rezki <urezki@gmail.com>,
 Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>,
 Vishal Moola <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, Ryan.Roberts@arm.com,
 david.hildenbrand@arm.com
References: <20260327125720.2270651-1-usama.anjum@arm.com>
 <20260327124249.a8de2259cf3438c5f4216894@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260327124249.a8de2259cf3438c5f4216894@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CE112A0019
X-Stat-Signature: jqqtn9ae4gomqym1adnjm98h3joegp9p
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774881814-967541
X-HE-Meta: U2FsdGVkX1/vqj+BulJm08P+4ac61gFL262YbDALvXkw8fnqh6DnBvnbwtw5JGFAeCjkDiCcuLZ7PCzF806XwPJmimmbxQ0RHgaBNizH1HyVGAuuTNNAJn7G+G4IoWFEWlx1uQfdJ+2fsRfw0wukTldPIK175ittua8M+qdJHrrx3eYpWhWI8+9jDCM+Ar6cZ/+xiKHxC1U332EwRex9GMjgkCVyzn2m1BSdZ6fkyhEwoCmMmKVz4YxCG/hp1U4vhJCC5Oc71cqVeBubm9n5IZmU3mWOSrcV7M/NBYXjncgjZR5lQ2/UveZoVL1nHm8DM+kZHt5jmbsHBbi57WmVsbIBjMwZs6m+U14UT9F3smKCNXoLX6p8LNFjHpBE+93PrmbkCLWmYCp+MpqqBAwQUE1HZzktN+41i99WUpDcPmS6LoC0tQb72wMMEoaj0NCjBqz/zaMqhSLkqZpsNbfFkHqmefmJoDJ/ShPJLDjyApmIscAj/wI68Fv8MJyb7uK8qG2YK0Gsmj8TfY7eD06mslI33wePpCoR/aDXZbivPtwVldJr6oj8mmLiolhxBh6wLN3f/HhAzi7/w/ZK0TNzFOnWqwJwH+FfTm8stC8JV8oS/4w4CcATvquaKxlmQNgLvoc0Bka3Y07TfNyTzWKj7J8QRg4ABtHoDSjA+sVl1TS9vRDn07OOBJdaBIeciqiRHOLMwANGJvSDFB7w1Ure65lUzsepzyqHTlU00BeD2pBsHdkYXgLtY6u+XupSZp8HHumF8NflnpYTAWpH/F7j4RnYIjWr/yCgMhSLY4KY6mGvXMh92tTIIzJHy4CAqn4znfMBjq0oWmrupctqNAf7AHl4fzh6H3kciUMAyZLe0sIw6yMjweajcWFwuGBGFouUlviwwogWKuedDlBgJ+lXiZrEKGO0qiyXlBI+x13EnAo9gJmLo0K8eigh+1IeFo8BbnGCryJCIohU69XBSrF
 o3SL6suq
 tbsPcQkbIV3rGB6BPU3mlL+lbcEHr6Dfugv8j+yif5SJxFBCxZgVlKiWjAZpRnM2Pgo5GlDgbocin+EoO4kr/DYdK+cYOdD3KLiVOpphivbIUIZkB263DuhexkGYcZCLRgrKU6ffqeYVFWJH8bWE+2LDBgKhzjjmsQnUjVc7T+FARg1zhNShi4VY4ihaZMpiYD3LNbzp1Nb2c84NZJ05HVdO5NgASjcYYjEyN1RPSBgD4BVTJ2dFg5IXXnOXdBiAsQdZN3XcKs9iNSuXgAaFOq5ksNGowYY8TPO6+H+Q9Jq5bwwoy+MpFAMHIPYZczMjDXcvqfrSjmu1D5sRVDR6mTK+mDsk7QpzuyiG+P1KQX/oDwmEImJUaMRX5IOXwfbd3KuoD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 20:42, Andrew Morton wrote:
> On Fri, 27 Mar 2026 12:57:12 +0000 Muhammad Usama Anjum <usama.anjum@arm.com> wrote:
> 
>> A recent change to vmalloc caused some performance benchmark regressions (see
>> [1]). I'm attempting to fix that (and at the same time significantly improve
>> beyond the baseline) by freeing a contiguous set of order-0 pages as a batch.
>>
>> At the same time I observed that free_contig_range() was essentially doing the
>> same thing as vfree() so I've fixed it there too. While at it, optimize the
>> __free_contig_frozen_range() as well.
>>
>> Check that the contiguous range falls in the same section. If they aren't enabled,
>> the if conditions get optimized out by the compiler as memdesc_section() returns 0.
>> See num_pages_contiguous() for more details about it.
> 
> Thanks.  I'm seeing impressive speedups for microbenchmarks.  The
> speedup in [3/3] may be a bit more real-worldy.

This should speedup virtio-mem memory hotplug in cases where we end up
calling free_contig_range() on MAX_PAGE_ORDER ranges to release
hotplugged memory to the buddy!

-- 
Cheers,

David

