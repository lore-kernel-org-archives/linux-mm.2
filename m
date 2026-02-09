Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5830BE7E0B2
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 09:38:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B56D46B0005; Mon,  9 Feb 2026 04:38:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD7166B0088; Mon,  9 Feb 2026 04:38:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DAAD6B0089; Mon,  9 Feb 2026 04:38:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8E96B6B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 04:38:15 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 331D38C3CE
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:38:15 +0000 (UTC)
X-FDA: 84424417350.01.A006E6C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 75B0580004
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:38:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rvD2kJma;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770629893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YKvwJvBXtLVQGPrmklEbw6SP6/SMJNsk0MFQ+sb5+Wk=;
	b=SbtHJALd8/HTAhjDFOcZsutQCOyVKvoyAB7PPGWSJozNi4dW9efn5cXCLjh4ILE58R/IFB
	+PKuN/u502mOp0Gc0QYyAvMnao+f3LUFfT33vehwOgAiZDDsyGhTqZlNdL4VENbjbfOBQf
	UrjGJeLFYbKTVAjbK7vRbqEG5T1wtFQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rvD2kJma;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770629893; a=rsa-sha256;
	cv=none;
	b=d1kIpDutPZAMLi0HVgrj5WoZlc/I5yIzccjDU39L1wfXIldzrviaq0Pt0rIkEQi0+/aHf1
	l9T5ADkJkPa6vhW7eRtTtbEpJg/5uPaB+h2iw3THrLo79K3zLmAlpdtoCt+CwZNa4efJiS
	ky/YqA8tGAZ11DYFwNVdXbazPCiQaws=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A9A64600C4;
	Mon,  9 Feb 2026 09:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B294C116C6;
	Mon,  9 Feb 2026 09:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770629892;
	bh=v+A4ucgLu6hDabFShguMd9iJICkSkIkwur7q7jqK3yU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rvD2kJmaNNEMUzuZ+jTcSMADRKAHroxxgx97c/Z4J8dIGeTQmFZ7B0XsQxzw6+IKf
	 +RjyvkuOkCfT4uvDZgqcrXDNVndMSij3rBuNoQpc2s/DN2Qs37lzYSAJ9RGqIBaGDf
	 5O0BbFoD33p6HVNMnKwX3UYHAIYSzhbrFpEQyhYGiY1V6b+TQ4s46kOJ3qQw42CRxO
	 yXQPXzlWgguPL8i4uB2aSQsU2Ie9NpJi4iKq/rTbwgC40IYbjjkoVn73GTv5DNrI4Y
	 HTX/oYm3h/hfy+74OS5nDIPNqCmiVOjZHF7iKKAuey2sJ0SFmboyAJ9GsKOtpILUOL
	 jCqqAniNZISrw==
Message-ID: <46d0b6bf-db7e-418f-a497-983db4d4d786@kernel.org>
Date: Mon, 9 Feb 2026 10:38:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/5] mm: rmap: support batched unmapping for file large
 folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, dev.jain@arm.com,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ri99yiyi19113z6n4gu8f7d37c6663jq
X-Rspamd-Queue-Id: 75B0580004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770629893-189358
X-HE-Meta: U2FsdGVkX18Z+2RTrBDv3JvstU9//xVT9B5H7eFgCPB672gFHa42XsuGUjSAIkd1BMo/5q5DC5VPRRDKyJEDQ2Z4U1KPnbr+oX6FKzNKwlDEh8N3GoPYmNtygCc/hsgXi7el/rGrsfSYv4UVj+lMCYP8J33aGdt/4wK1Fr1tfVioLligsVZuF4bn8pvW813zPw5W5rD9osbN9QnnhcUs8D+TObHwHFbIlTfmB5bmnXMun/Xql6SUZjTGRLboOcuKlpao8dVMa/JLhm/C6O5U89pheYZrA4+kGNbqHI1Jwiq/tTts+Ix6imD/8kla2cfMAmBu49GrEqazDGOvlWKtd+rlkm2BJoK4KNA4pMJE9Xs7v+RxI4Kpv/pZC08ghMuZZE3ciLfhh6o+o/mLBUxpoumBTLXoZ4E6gT+sG1IF5EKxLvBbegFu8/M/+fIuULOEpTAzkaY2/cRelPjCv5DuWfmafv5KK891ehH1/LQi1OaQn1J5MPDSLK2PX/zblzzSZVlcckg+2VcZJL0v5v9U6gt+073CccgrEqvu7QtSBCZkzsGqBnRNoYJCfPBCMKQ5B0TOeZiBkWMWUXi/Ny204Jg/nDSrs2CLdBDzs1qbsB9hdLcSSCuTpsmVboHQCQtRf0lzlFpmRx+IDoenLjt8PuMBl+THyg5qyRO/kMHpBZ8RxxNgLGdwQOPQUTMB+eJFI59XnKQ45Gbr5uAlep5igo0llKknPfTFOSMudgWr+tft7Ix2vHH5QP7W8rblXiqvOFsTEhS/0i7+3RPvxv6Jf1h1CQZmTs/5LRkej3H+K1Py8cjUvScXDVD/0eYdJD9pBe/UW2vYUSWRC28LprIk6olKzNrJhSgqn4RECdPL+hnv05p/bC5S3JUhANHi8A6gZqdEyspsuJMJWdfSj+xj7qJ/h9+2hCDkxtJRcbfiTq9mw0aw+S3puhk0Na3ZFpxVJmiR/lrcHSCrQHtRk6k
 j5i/FJSv
 hTPN4fVryi8Z+DQDpfVmEa8zK+hjie7WrzkCnryUUS2KwUA2cP51+273yUlQ1oCsdQu0zYd8HVmF31MbNRUhRDbUpXdeBagSa3pyzhNtEZAYV4bhyZoAdaAgSfchuHJB7fXMutvwOg5ERsbWjx+UB0/Jv9Kj+B1KGYvacwcro1dflDbyVOmFl5HAtrjBe/eeX1srzpC855KT/9VYRmqN7qOWlsur6+183uwhhDPJsyIisXalzgq3/Vhmhe4DEvQRYfzkgzHBUiAE6xl/wUklSY5tQIJzcWGxB2kCMEk4THrr12NN7gb0cWJpGwOE0KjCJ/W+e30Bmg/QUi2jnB/OdbJnvhTfHPwKcT2gLx0p12TIlUi32IX1OYA40xKIORppouQXA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/26/25 07:07, Baolin Wang wrote:
> Similar to folio_referenced_one(), we can apply batched unmapping for file
> large folios to optimize the performance of file folios reclamation.
> 
> Barry previously implemented batched unmapping for lazyfree anonymous large
> folios[1] and did not further optimize anonymous large folios or file-backed
> large folios at that stage. As for file-backed large folios, the batched
> unmapping support is relatively straightforward, as we only need to clear
> the consecutive (present) PTE entries for file-backed large folios.
> 
> Performance testing:
> Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
> reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
> 75% performance improvement on my Arm64 32-core server (and 50%+ improvement
> on my X86 machine) with this patch.
> 
> W/o patch:
> real    0m1.018s
> user    0m0.000s
> sys     0m1.018s
> 
> W/ patch:
> real	0m0.249s
> user	0m0.000s
> sys	0m0.249s
> 
> [1] https://lore.kernel.org/all/20250214093015.51024-4-21cnbao@gmail.com/T/#u
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> Acked-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>   mm/rmap.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 985ab0b085ba..e1d16003c514 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1863,9 +1863,10 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>   	end_addr = pmd_addr_end(addr, vma->vm_end);
>   	max_nr = (end_addr - addr) >> PAGE_SHIFT;
>   
> -	/* We only support lazyfree batching for now ... */
> -	if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
> +	/* We only support lazyfree or file folios batching for now ... */
> +	if (folio_test_anon(folio) && folio_test_swapbacked(folio))
>   		return 1;

Right, the anon folio handling would require a bit more work in the


	} else if (folio_test_anon(folio)) {

branch.

Do you intend to tackle that one as well?


I'll reply to the fixup.

-- 
Cheers,

David

