Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AA8BEE208C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 11:01:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56EFB6B0089; Fri,  6 Feb 2026 06:01:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52FD46B0092; Fri,  6 Feb 2026 06:01:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41BAC6B0093; Fri,  6 Feb 2026 06:01:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 33AD56B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:01:15 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED5C75B67F
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 11:01:14 +0000 (UTC)
X-FDA: 84413740068.09.30C8039
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1398B12001B
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 11:01:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JqYRZLZo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770375673; a=rsa-sha256;
	cv=none;
	b=YF5+SzSSTJYZ47UBStU3Zo6BCOJa3ELjHIaRn+hNSc3WkjfHz8VdF8uCXFnSIOPtHT/G1Q
	E4SakipWo0JiBJkr8pw/VjT5Gk9rqJ0TZ8vjP0vNFfQoscIjCt1tmcuUHfRALz3DSVyGHk
	dFTgp7fBG2Cae6KruqyGgScwWhqyq4o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JqYRZLZo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770375673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6yvRHIYdCDY4or2kHuURSTiaBLb5Y1XNIikEDozr7uI=;
	b=W69KBF19cloePeGsl8YFW2bRnyvGn1ZnO7TXVY+SGOLokYIOyLYbrvwp3Gt+bZI8+OGeVk
	2ZfNkFuDsif4SeXE2OHgn/tpQ9yaMgIUz47p0QFTPJQAM0wbh1Xw3VedTsU4eAWDwujisR
	WUQ7Jw4QhIgRwbnoIaKpxzGfbvPsF6U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CA5F440DF0;
	Fri,  6 Feb 2026 11:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C160AC116C6;
	Fri,  6 Feb 2026 11:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770375671;
	bh=OfuemE8NvbpkvzumGm/QBmZRuLBhKVNLRdNOqH8+xw8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JqYRZLZo2NU/xYu+jVFba4I8F8wjgB2QbQ6NFqY0InIReMZq6P7/iW5j2DGhbDvuH
	 Bl62/oPvl6dTHhbcwtXCYfTNKTMY4ONgcEhGwculNZ/YnqMN2Qm+KCVzidmmhfszPQ
	 cc0+VP4/wJpJYdZ0dUNs9rhA1LO11ZeFCl6b/CmD0IJlcDj/Ia7Q6FIKc+9niic8K5
	 pKFVCnn5oeYnEs0qX/t8GypgfhImI//1SySOv4MpR/pDYMy5D1GdbAfO0TmVcXiBgy
	 mn+BxdSngydqDTzj8V+GEHUeTe3LPcLD00TIqHoIw6+4IahFAOWOoOzY/7LIIWhcsx
	 J4uDDyzcwt1GQ==
Message-ID: <9f75b988-9729-452b-beb5-deab0718faa8@kernel.org>
Date: Fri, 6 Feb 2026 12:01:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] ksm: Optimize rmap_walk_ksm by passing a suitable
 address range
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org
Cc: chengming.zhou@linux.dev, hughd@google.com, wang.yaxin@zte.com.cn,
 yang.yang29@zte.com.cn, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260206180132364R_lYZujwOYfhazgKmxArZ@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260206180132364R_lYZujwOYfhazgKmxArZ@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1398B12001B
X-Stat-Signature: iatncrt3n4nd3mtyhry7spp4qd14ufo8
X-HE-Tag: 1770375672-900595
X-HE-Meta: U2FsdGVkX193HsNGnRARyJnE4/x4tTB4nDhFhBKhTClRWBDh2bqyzfKkowIhsjKW+8whXxWXYBYSyTGMlI/E1w9PJ7+P3M1xk4WnBY9K5wRdhC+KWgbiy5ce6HdpbRLsVQV+qCBcKEakOb4Xurdrcj8lqpdaon79wzbvU4vvWSbcXV7ejs9xScE8wXwVCYSlliA2RaOJ+6r+e7uAu8dJzv88u2ASuhBKpdKfrnsA83o+JuyIXKckyuI6Fwk17q08tU8xQFEJxywvYmYpFVuRrFys59jSRz0qPZ0FhiH3LTSn1EgHm5IpZWTQV586fdpoed+4QQATm7SOehYDYMNcWIEpKJp0v0Tv7cx6hnZzeRyjeQjjshT1BdZ4GtOODk8dcg5UhMY/lxtIfgZgJl+2+Q9JHu5HPFz2lPiQU3o9D6dSIbK01UTHDtSS+Dj6sW2AjR+r8n7EEIuNo6ULCd3O7A+ruS0wUjrbm/JSF3UAIttC5wZynm7egBHQ9bVcAfQVUsB5QkpbjL0kOf13bq5jtFQcfYNYcWNGY5JL5nEo+jVv0rn3su5DcNAIsdN0jwzMcUUckwfWzuYyLhMUQnFWQq3uYeb8Qlh4aPLJjRRrai0daoJ5W/My7yRQo6AG/rnVJrx4pPDPKyaTNbBKSelmODViPoylAEjKDshoKeQqgrc9REZfMS0j6RKo6718BZs/DGa+Vs3/8GkwW3YiGeQMLWPDdKiVC763+xmXIp6t3DFReCvTjLmDSOYDMu8adeISTGu1cPOWi6BH3vMY8k7t2Nn6hct5whuNAcmEtT3T/iJAPXBfuAIFHKWzDuBeV30KIGqOSeMW9spIvg/2WC5Ghf3/AHfVzaWr1I0ytOz/RQjBd4FNq01aJinBPHWDkMPWCTuEfD1tokG+E8ZYmwEgtfRzZQj8lLDihLK/ysKJ5mk0rrmXhBwO0FRmxHWWtjjLXFMUh3yRJwFaUuoFzUw
 m8GuNWVq
 aEVs7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/6/26 11:01, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> Problem
> =======
> When available memory is extremely tight, causing KSM pages to be swapped
> out, or when there is significant memory fragmentation and THP triggers
> memory compaction, the system will invoke the rmap_walk_ksm function to
> perform reverse mapping. However, we observed that this function becomes
> particularly time-consuming when a large number of VMAs (e.g., 20,000)
> share the same anon_vma. Through debug trace analysis, we found that most
> of the latency occurs within anon_vma_interval_tree_foreach, leading to an
> excessively long hold time on the anon_vma lock (even reaching 500ms or
> more), which in turn causes upper-layer applications (waiting for the
> anon_vma lock) to be blocked for extended periods.
> 
> Root Reaon

s/Reaon/Reason/ or better "Cause"

> ==========
> Further investigation revealed that 99.9% of iterations inside the
> anon_vma_interval_tree_foreach loop are skipped due to the first check
> "if (addr < vma->vm_start || addr >= vma->vm_end)), indicating that a large
> number of loop iterations are ineffective. This inefficiency arises because
> the pgoff_start and pgoff_end parameters passed to
> anon_vma_interval_tree_foreach span the entire address space from 0 to
> ULONG_MAX, resulting in very poor loop efficiency.
> 
> Solution
> ========
> In fact, we can significantly improve performance by passing a more precise
> range based on the given addr. Since the original pages merged by KSM
> correspond to anonymous VMAs, the page offset can be calculated as
> pgoff = address >> PAGE_SHIFT. Therefore, we can optimize the call by
> defining:
> 
> 	pgoff_start = rmap_item->address >> PAGE_SHIFT;
> 
> since KSM folios are always order-0, so folio_nr_pages(KSM folio) is always 1,
> so the line:
> 
> 	"pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;"
> 
> becomes directly:
> 
> 	"pgoff_end = pgoff_start;"
> 
> Performance
> ===========
> In our real embedded Linux environment, the measured metrcis were as follows:
> 
> 1) Time_ms: Max time for holding anon_vma lock in a single rmap_walk_ksm.
> 2) Nr_iteration_total: The max times of iterations in a loop of anon_vma_interval_tree_foreach
> 3) Skip_addr_out_of_range: The max times of skipping due to the first check (vma->vm_start
>              and vma->vm_end) in a loop of anon_vma_interval_tree_foreach.
> 4) Skip_mm_mismatch: The max times of skipping due to the second check (rmap_item->mm == vma->vm_mm)
>              in a loop of anon_vma_interval_tree_foreach.
> 
> The result is as follows:
> 
>                   Time_ms      Nr_iteration_total    Skip_addr_out_of_range   Skip_mm_mismatch
> Before patched:  228.65       22169                 22168                    0
> After pacthed:   0.396        3                     0                        2

s/pacthed/patched/

But I would just call it "Before" and "After".

> 
> The referenced reproducer of rmap_walk_ksm can be found at:
> https://lore.kernel.org/all/20260206151424734QIyWL_pA-1QeJPbJlUxsO@zte.com.cn/
> 
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>

Did you accidentally drop a

	Co-developed-by: Wang Yaxin <wang.yaxin@zte.com.cn>

?

> ---
>   mm/ksm.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 950e122bcbf4..54f72e92b7f3 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -3170,6 +3170,9 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
>   	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
>   		/* Ignore the stable/unstable/sqnr flags */
>   		const unsigned long addr = rmap_item->address & PAGE_MASK;
> +		const pgoff_t pgoff_start = rmap_item->address >> PAGE_SHIFT;
> +		/* KSM folios are always order-0 normal pages */
> +		const pgoff_t pgoff_end = pgoff_start;


Maybe simply

const pgoff_t pgoff = rmap_item->address >> PAGE_SHIFT;

and drop pgoff_end? Then you simply pass pgoff as start and end below. 
You could add the KSM folio comment above the 
anon_vma_interval_tree_foreach.


If the tools/testing/selftests/mm/rmap.c selftests keeps passing 
rmap_walk_ksm() should be working as expected. Did you run it to make sure?

-- 
Cheers,

David

