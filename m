Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F50A1061B04
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 14:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED9C16B008A; Mon, 30 Mar 2026 10:35:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8A936B00A1; Mon, 30 Mar 2026 10:35:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D789A6B00A3; Mon, 30 Mar 2026 10:35:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C07526B008A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:35:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5FCD2140802
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:35:52 +0000 (UTC)
X-FDA: 84602978544.28.733485F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id AA57A180013
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:35:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UwtrSMPL;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774881350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5JUMrPRAqm44rPhskR4cOgH1OWnF8mpPsiHrk90k8IY=;
	b=ZXkLT05C0GTtJc0V0/9z4DgtjoMmFtR9izwc29FkHW8YAgQO493G8PoFsU+Z8Bs69eAO8q
	8ZzEqhnmk0sbZ3wzzP1kVVmWCg219fG/fgn+sdmn+6q1OE5gLsuSm+lAoZUAZlh08LEfQV
	hhsAW1GIvSAkU9QWSe2HjfCEuOayRYg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UwtrSMPL;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774881350; a=rsa-sha256;
	cv=none;
	b=mGz8whJXxoba3lfheoHg7vkKSr6/4rQ7r23prmnM43fkQOm6EPWigWCIvn/bnsWpqIGywE
	Q9b8HVYs/io1LbZOEkVKjpRVhnHkIj2dfI1Npoe9UftTNi17h6Z8abb7Tr/tAlUgJg/UIS
	04kMHkMXboXdjMKhwUHW4UzzP0fjb/4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 194FC600AE;
	Mon, 30 Mar 2026 14:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C51C4CEF7;
	Mon, 30 Mar 2026 14:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774881349;
	bh=HHfxw1FEuQsMoLKCj7A+GvFmIFDI80BjaPMvstStO5I=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=UwtrSMPLZX3sohAGKTRw7Rso3hDmHASdR/K06e9EScHVjSlNJbQRK3zAxVH5T6fbc
	 u4y0GylbOG7ifiUhJ5gp1pSTCaMIaObdgpx6uPaYWs94+YBnmSCQGKi0FZe+ktCDnz
	 yzD4QPupNGMywdcJZs+SXCS37xW0OhNXwu1Oz6FhJGwo49hqY4L8MDgSy2V3DXZ7+V
	 yFkRjEucGrmteUIMKO70hW3kCrAFhSs0mHSUKt7DmhMtrAJctkXDwnKLE4cMDTXR4m
	 Iy+J2xvnVjLYWe53LyWI+YiwY2sYNiZb/s7Hfl4mi8tphOzmijb9M01CtzHJ6Qflwx
	 9IHlTpT8wjjEg==
Message-ID: <0039fdb2-b23d-4ada-8d83-595e7816521a@kernel.org>
Date: Mon, 30 Mar 2026 16:35:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] vmalloc: Optimize vfree
Content-Language: en-US
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>, Vishal Moola <vishal.moola@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 Ryan.Roberts@arm.com, david.hildenbrand@arm.com
References: <20260327125720.2270651-1-usama.anjum@arm.com>
 <20260327125720.2270651-3-usama.anjum@arm.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260327125720.2270651-3-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AA57A180013
X-Stat-Signature: a6redb61fx1t38ucasbj7s94he6dtj8w
X-Rspam-User: 
X-HE-Tag: 1774881350-643716
X-HE-Meta: U2FsdGVkX1+nxCp1A43yH2Wu0FrCIXXBnjA/PkN5YqFlIRLaU9NZv0cnTGWOOmBuj1D2X54IP/GgAiXQX1ayaEJwL7pKnIA4BnwlYL/Tc0X2XZUAZUbvHyvsJltkGFgsut636HOQ/oB5OiO2Zefxl5rR73VfrnxslQwrIRxXIe4WPVsjCBqH2au+UNrEWDMdeq9rFmsgp//07f2zckB2+Xn0vWoVpMExAwQ9/yYrL6poqZ7jeoGh1DsGv2Yt431nvmuY1cW98oMJ/PEOuoAug9R6Lrgj25N8ostQ/YxVZdqvBKQkpmZLrXu4vybV6qwCZgE28W6jXQoctJ1Z0x7M8LRbkXpVwh14hC/CCWF7gcSs11xC7qmO15yUdP1wB47vU7B9+6F1ifA8xCaAUk1gDQrVlnYep5zCNSBCL4noOrWDtbS0b3XvSobT7hcFWEGu5j0AWzGLL4XEVDGhaUih7k/T6oYMlu1KA9eGX/p5yL8nFO5a5LsOKGNO9qtAird8B08ziPFGd9IXUZZ6bf6bIt48MtOhTlSIo6NByO//lkRkU028xVbGTijGOkjiSbnCFKmP7Xm4+xNuYaYntNWeJhalWsJSVPYlKAVmQYF0iMOrlNimHXmXvft9hztzgNn8Fj3tlHNTt8+zAufbZc2Cqxm7ArVhQfxZqVyTi2qrPsKHWUh2mLg31nfELUbMlHoI5ucnemkxgdrK4nlPz0+NHBxcD1LQlB9fpDQrh0ij+3bWroEo2/3GEjInnolPJGqpB0CgHh0LoJ9JUmKyq4ykiJozrevt4r5P5PHBGr/wexmFIDq39kqB9G2NV+eBkWxxnxzKTjKAYHo4GTKtikauI4pTxjinncJviWXefCCy7EuRIgUN9beSZpCUBpv7gUGgkoaR/fGbb6PjywNyoZxJcP5gNXfJDHwV1ZH7Gt1sUM19hiyF/BVjzi7kwhZFs3cEYF2XXtR513MATh+iPOm
 ruTqPFwk
 QZ2wcuYquJ3QEkqfTYsEmd44YlS+yL8JCtCc7aJsSCurQWSeYAHAjDf+bIlZtHmNsyhPR/Vx6a/w+AZLyP3VBqvPEMbuaCGStDTh45r+T/VwNaiNmfuQFIZtV1ArxfdahN6U6rqFsjNjQydtJ7Lsu66LALkED9KVWL5sAWfD93T8mJhvKAFOjWXcll7CvWBfEFKaihEbxCbVA+6dyLhpmwhZHHXO+hqYohOaCW5imT3GxEBVv92XKMWZWh18HqZ2fS14iXZSBCQ8/VDYN3yDQCRCSWOl/RM+Q2tLW5TLdopkpLgrYBnYQxYc3QG9/tdXQyNSkgzFwojqVM3JRpKHz8/vKekmEafZvveFTId2AEOx20QuQVB0t7SovsC42Tb7a8/S2cmEIpjr/h6g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 13:57, Muhammad Usama Anjum wrote:
> From: Ryan Roberts <ryan.roberts@arm.com>
> 
> Whenever vmalloc allocates high order pages (e.g. for a huge mapping) it
> must immediately split_page() to order-0 so that it remains compatible
> with users that want to access the underlying struct page.
> Commit a06157804399 ("mm/vmalloc: request large order pages from buddy
> allocator") recently made it much more likely for vmalloc to allocate
> high order pages which are subsequently split to order-0.
> 
> Unfortunately this had the side effect of causing performance
> regressions for tight vmalloc/vfree loops (e.g. test_vmalloc.ko
> benchmarks). See Closes: tag. This happens because the high order pages
> must be gotten from the buddy but then because they are split to
> order-0, when they are freed they are freed to the order-0 pcp.
> Previously allocation was for order-0 pages so they were recycled from
> the pcp.
> 
> It would be preferable if when vmalloc allocates an (e.g.) order-3 page
> that it also frees that order-3 page to the order-3 pcp, then the
> regression could be removed.
> 
> So let's do exactly that; update stats separately first as coalescing is
> hard to do correctly without complexity. Use free_pages_bulk() which uses
> the new __free_contig_range() API to batch-free contiguous ranges of pfns.
> This not only removes the regression, but significantly improves
> performance of vfree beyond the baseline.
> 
> A selection of test_vmalloc benchmarks running on arm64 server class
> system. mm-new is the baseline. Commit a06157804399 ("mm/vmalloc: request
> large order pages from buddy allocator") was added in v6.19-rc1 where we
> see regressions. Then with this change performance is much better. (>0
> is faster, <0 is slower, (R)/(I) = statistically significant
> Regression/Improvement):
> 
> +-----------------+----------------------------------------------------------+-------------------+--------------------+
> | Benchmark       | Result Class                                             |   mm-new          |  this series       |
> +=================+==========================================================+===================+====================+
> | micromm/vmalloc | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |        1331843.33 |         (I) 67.17% |
> |                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |         415907.33 |             -5.14% |
> |                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |         755448.00 |         (I) 53.55% |
> |                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |        1591331.33 |         (I) 57.26% |
> |                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |        1594345.67 |         (I) 68.46% |
> |                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |        1071826.00 |         (I) 79.27% |
> |                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |        1018385.00 |         (I) 84.17% |
> |                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         |        3970899.67 |         (I) 77.01% |
> |                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |        3821788.67 |         (I) 89.44% |
> |                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         |        7795968.00 |         (I) 82.67% |
> |                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         |        6530169.67 |        (I) 118.09% |
> |                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |         626808.33 |             -0.98% |
> |                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         532145.67 |             -1.68% |
> |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         537032.67 |             -0.96% |
> |                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     |        8805069.00 |         (I) 74.58% |
> |                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |         500824.67 |              4.35% |
> |                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |        1637554.67 |         (I) 76.99% |
> |                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        |        4556288.67 |         (I) 72.23% |
> |                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |         107371.00 |             -0.70% |
> +-----------------+----------------------------------------------------------+-------------------+--------------------+
> 
> Fixes: a06157804399 ("mm/vmalloc: request large order pages from buddy allocator")
> Closes: https://lore.kernel.org/all/66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com/
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>



