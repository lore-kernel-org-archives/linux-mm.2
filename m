Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B178E6F06C
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 09:13:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 419166B0005; Tue, 23 Dec 2025 04:13:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C74F6B0089; Tue, 23 Dec 2025 04:13:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D2686B008A; Tue, 23 Dec 2025 04:13:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1AB356B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 04:13:12 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BF7EF60490
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:13:11 +0000 (UTC)
X-FDA: 84250171782.25.0A0C14E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id F1CDA4000D
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:13:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BFqHRM+3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766481190; a=rsa-sha256;
	cv=none;
	b=pEnF1V6IJtQ8bCUr01gzsyEPX9daXkSzaFaPaRBxzySe/Gf6WGNNCez5CASWUlljtZLyhk
	g/1J71bOaEvWpFyBFMO2EzgBTZFxLhCGycVrQE7fimv00YnEtuPbLILfSL4ykex4F/ueVG
	3em6mH9BnM8Rt4lM9GAZJbEoZHi4Zkk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BFqHRM+3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766481190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HCWPuKeNzrHX1giKMjTKtEMh+xtmKpvckx2WdGrHub0=;
	b=bDJ+sUnhbWctxBpsZcndBJcaN48edCT2ly7ELmB+n+roTu+KrZnDsLktSdyOMNE7wa0iix
	ltYxjW3D+mvyr+w7db05eBLxDWhmdflRZvz6NErSL9IIxU4kYOtytfs0wv/LCka/CZozjc
	zW3ILDAOIsEXSBx6QHTxt/VRQjrMUp0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EA88F43EEC;
	Tue, 23 Dec 2025 09:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B4AC116B1;
	Tue, 23 Dec 2025 09:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766481188;
	bh=L+jctpl8CY/Z02R3KgkzKjrbQKw1ezIptg6y1ooTjxk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BFqHRM+3GiKOoc+GhwMOq7LMBM8VqNTuJ4N/Bdlz8FfL8fyfvXJsEnjqxbbIse5wR
	 kenOtswGDIm6gAuikCico9w59FwPIejyy6tj6/ragC/1zcNH5T707l/TPcFkDW1XpB
	 jn6IncOKwQh5t1D7J7CfuX6F5ntk4RYRfFimak0yNkzCAt7BoPCxnNLEa0CNPrxxZ7
	 GP2Q6mLSKqJ5uIeZBwy7Zqas4Y+FKATL1gWJWlOBGvajsXsBcWwMuPWN61i+r8P1hj
	 kRNDZhSiMcy1gJFfwZ24MvMwLmjPTO+RG96lc6nYx3Wn+pvWujSRcZaiDKr9MA571i
	 hs5cM9IwTLxeQ==
Message-ID: <12032402-b541-4776-a716-c93f16ec7eca@kernel.org>
Date: Tue, 23 Dec 2025 10:13:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] mm/memory-failure: teach kill_accessing_process to
 accept hugetlb tail page pfn
To: Jane Chu <jane.chu@oracle.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, stable@vger.kernel.org, muchun.song@linux.dev,
 osalvador@suse.de, linmiaohe@huawei.com, jiaqiyan@google.com,
 william.roche@oracle.com, rientjes@google.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@Oracle.com, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, willy@infradead.org
References: <20251223012113.370674-1-jane.chu@oracle.com>
 <20251223012113.370674-2-jane.chu@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251223012113.370674-2-jane.chu@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F1CDA4000D
X-Stat-Signature: 3gogewkkboue4kmwex86yqdrzjoor5hx
X-Rspam-User: 
X-HE-Tag: 1766481189-192241
X-HE-Meta: U2FsdGVkX19tjfZM5IrrW4k2vwF4oCeLD0Kqm58cts21X6tbW9PZ6mzO67T7n8SHdw4uOo6ivq9MzCwdOWH/KeoYls81HL9D7vpxtFZOFt616lBIfKoyiBsWmW/9+tkU95Xn5obMbVCKPqlP0Vw13vaUn+FM5SqYt0/oP28XxmY/AdosNYpES2SPo0bWka97aQDcd1TtgIKwxdIN3akGKEQAYRupcdPoBDv//XfAFJTcUARMug3oynga7hPxkS+6vMEWil1snEqtda9DB+rpZxxtRn6SI5RPHTSrAlYdOmcmL7FNEhHYmEOYWOuW6yt/eG7hxLjSUntRgqjbKWg7E0VTvezCftdCscff2GLKqLzqjFcR26TzDC9bjAkPniJ/deMaLxyYp/Wh4bu2KeztIK2eHAMF5qnVIt8Mbib+rGhn8rb8nKi5YJ/ZGiwkXp2AfkcKKihI/veKXWzYiboTGWq2k45wlvbsZvaSjwAiAqInGFwGDP8r1t4RV9YIupqoP1+kmLdVTkEgd+HCrQOMl60XeA9Qb7ARLjxYxqpWoklRFA64pArG1vgyCuSb8ewXejkHOsKCDfr97INRR9HGPucEygBhFLHTnhzJWyZl011hO3m0LaOGD6/is/Lwba6XvPQ1RlVuDaODUibk32KiWQ0Jkx5hkg+ZmeJ1w9EIGF10kDO10dLj5m/teOZLsZ0ET9o54OfRLhLK5zseFgQ/MgF9kSCruSjdWLu670D4INk2SBiWlTu56bB/Saqe3rOvSLKFOzui74+o8ENppOjnTIkRegRXaFBMSVdhzG9tBlgSJv6bpUAn20dGXolWEojY5g47U7ZLLP+9QEFGbOuN/3pCOZJk81STN6O4+o6qdsOz0ubOWp529yLvwjtXPyByEC56UmlTIbTFi++CB3j/NPRWTo4hyj2abg+m93mCkZkLcwwIAtrfQJAlT/yB/OaOqKlheWbR+dtQE994VET
 vOReksw3
 7KkxU+3YypZIY6YoI7ezUzphLGkeIZdihfw9i45X8aP7nNb7RkPIvo2c14wAssw8Vozhk1eZNPm8LkKQbzSqmYY3xk/JL6f+MzL1OCqkylzfY7n7xcGdwm5wYJrbPSuiQ54Dvx5fzKXXIc5c7ZIgZ4e8bLVrRyb/CqsO9xzhNV+Zfl5x9IAbSOwYfoWuyHw7yiQe15EKIRaxXphWvzCG494qt0kApc7dy1Ntq6ZUNtmx0Ix7e3LJ3zpz4hdndpxU7MOg25s4Dy86k7eQat/fnEp6sBnW/Hbl6671O1CFyF2mNpJMv03KzZz9KHegK33cSSKfQWGUa9X5pRNIr0/EX6xa7ZfOAQIYQycpm06xAa5H9GoLchWUpcrAQ3c6U7BF74GZybJJ4ZznzXX9xuvZsHqSqynpsQKPFhvp4EV1H95KjPdPlSv3Km+nxnA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/23/25 02:21, Jane Chu wrote:
> When a hugetlb folio is being poisoned again, try_memory_failure_hugetlb()
> passed head pfn to kill_accessing_process(), that is not right.
> The precise pfn of the poisoned page should be used in order to
> determine the precise vaddr as the SIGBUS payload.
> 
> This issue has already been taken care of in the normal path, that is,
> hwpoison_user_mappings(), see [1][2].  Further more, for [3] to work
> correctly in the hugetlb repoisoning case, it's essential to inform
> VM the precise poisoned page, not the head page.
> 
> [1] https://lkml.kernel.org/r/20231218135837.3310403-1-willy@infradead.org
> [2] https://lkml.kernel.org/r/20250224211445.2663312-1-jane.chu@oracle.com
> [3] https://lore.kernel.org/lkml/20251116013223.1557158-1-jiaqiyan@google.com/
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> ---
> v2 -> v3:
>    incorporated suggestions from Miaohe and Matthew.
> v1 -> v2:
>    pickup R-B, add stable to cc list.

Please don't send new versions when the discussions on your old 
submissions are still going on. Makes the whole discussion hard to follow.

You asked in the old version:

"
What happens if non-head PFN of hugetlb is indicated in a SIGBUG to
QEMU?  Because, the regular path, the path via hwpoison_user_mappings()
already behave this way.

I'm not familiar with QEMU. AFAIK, the need for this patch came from our
VM/QEMU team.
"

I just took a look and I think it's ok. I remembered a discussion around 
[1] where we concluded that the kernel would always give us the first 
PFN, but essentially the whole hugetlb folio will vanish.

But in QEMU we work completely on the given vaddr, and are able to 
identify that it's a hugetlb folio through our information on memory 
mappings.

QEMU stores a list of positioned vaddrs, to remap them (e.g., 
fallocate(PUNCH_HOLE)) when restarting the VM. If we get various vaddrs 
for the same hugetlb folio we will simply try to remap a hugetlb folio 
several times, which is not a real problem. I think we discussed that 
that could get optimized as part of [1] (or follow-up versions) if ever 
required.

[1] 
https://lore.kernel.org/qemu-devel/20240910090747.2741475-1-william.roche@oracle.com/


-- 
Cheers

David

