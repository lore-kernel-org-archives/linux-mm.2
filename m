Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC4BC606A326
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nNTMQvVV
Received: by kanga.kvack.org (Postfix)
	id EA8316B05B2; Tue, 10 Nov 2026 07:26:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E80326B05B3; Tue, 10 Nov 2026 07:26:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D961D6B05B4; Tue, 10 Nov 2026 07:26:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A19F86B05B2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:26:55 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A3231A85B9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:26:54 +0000 (UTC)
X-FDA: 85419133548.23.9E78A37
Received: from mta1.migadu.com (out-38.mta1.migadu.com [95.215.58.38])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4C813C0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:26:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nNTMQvVV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.38 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794313612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=28sGp94tB7+IhB+9l8EsVNP6ycTUbA9Myz4BYRq9KRQ=;
	b=WFzbxhNO6r8n17UuX3zyiAw+tMm6wK0iTbZurlJpN8VvcqKw/vV4Z+6rkaxpS4kPvITuIE
	qwKgx6I4JnE0avQSEOFLvnU5U3+ni2n6cAqtPWj13o9QgP4xybVQ33q1oDzwHNmpEnFKvS
	qFhbrp0vtJqJ2XVwRUAnIrSJZKJRUNc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nNTMQvVV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.38 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794313612;
	b=Obb7sRqniHShVNQYCLdUH+HQzdo8grR+e7kZj3XwEKuVOijf8YsU5OHQZuv2dxq0LqQkjl
	9xxxF1fyjZO4D7Myz/eUctEb/CxKc64QDlIdmSq4t+bAkpkSP3YFSubrADpW/IBEdG+tO7
	1r0zGy8mYBLlIbEEr0tAydgWIh4MVnk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NCdTdpmEhDXCpYswlDrvsbAlShAGzLjABHUDQP5sSb0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794313610; v=1; x=1794918410;
 b=nNTMQvVVeAC1i8sMsLB+5AuP2lG1OvGYeMqJVvCmO6SPtecc/lBQtR5V4LIlzFQVnTNM0Gqg
 FesuNJUQAdp5Ox6Dg874N2rEpRQNUywOXcTw4giN1HEdkqGjSRrzBq5W7SEnPPzDf71iUAqB+Gq
 cjR6XazRuoFObP9EEclN38as=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 554be337fc97911a;
	Tue, 10 Nov 2026 12:26:50 +0000
X-Mizu-Trace-ID: 554be337fc97911a
X-Migadu-Flow: FLOW_OUT
Message-ID: <f416f84a-03de-49fd-ab67-d86ed4dec633@linux.dev>
Date: Tue, 10 Nov 2026 20:28:10 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/9] mm/vmalloc: BUG_ON() on an unaligned range in
 vmap_range_noflush()
To: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Dmitry Vyukov <dvyukov@google.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Tejun Heo <tj@kernel.org>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@gentwo.org>
References: <20261110112546.261415-1-hao.ge@linux.dev>
 <20261110112546.261415-4-hao.ge@linux.dev>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <20261110112546.261415-4-hao.ge@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4C813C0005
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: th6qi3ywy6k8dwbk9hk13dxy9c4wkm9k
X-HE-Tag: 1794313612-970990
X-HE-Meta: U2FsdGVkX1+QO9GR/2RDazcQJikjsey3h/o3LHM12bwP30w6yIt8tXQN6BqzT+9VgFMlkpweNZIFRn3QhfMCjmqKKurv00DTUkTr6TsUAXNvDNm9B3sKjLrabJDr7lCpuupSKoj5BwykxPvlFumiSRZV67ZSenuNw1RrQsfg/jl88rjNeI2VW63IXnotI0ii3jIUpRTljhLcTL5itJ2Xot+42X4f0cvVJoxUFf1y+k8GzHRPqelAen+5UuxcRAPmLq961jddD1VlCJvEXvDHRbytO0uMittUHjMi/vKlDhMMjCJ5WSXlWDFXgaRBW6kbbV5CQaGNf4/6uVz9iWBSles7SdCADC2kmUjE/w9p/jn2pfqz/xYE+2qfx/waaCIbQtnmNo7CiTVFFavW4O2snpMiJ6JE9riI/97ZVCTPZxDwzlSvtl3MotprKUaiX54Uk8c+3oo+R8iayu1TeLtAjQ4TtAqnKe9Y9JxbZFzwzczJSAhe2rZJaf+ySRvNdSROF7carrAOc40YEFrfXNrv9oAHwiXsUazYSp9rx/jL8V92v7nV0sH6IpYRZIjqgtPXJyjCUMscgBnyqBxWnOrp2o/FAIZD6HfgY4W3WDUEoDC54agdLgdJSvyLo2lTUee5NYRcky6t0S5h7ub/+xGIDxIBY4FRjaLzG7r9waP1NrREZuSg4qar9grCU69ne7tDUpRAitdwJkgpNKKjQtg95Qk7KD/sGdY6eOio6lmelSE8k1qFYTDhJi85H+w7521oJbTGqmh/GxXaMA7I+bRBurOYgC0q3Gfilg7siXF0qEbdj76B2WK+bNMjk121O/0UniioMfEwFlFlFLB5d79sRX8jXNr7pLwc0DTdvQn/oprDwsMWOqdH+wB7E611KeE2GeTDwqtflT0KmSu/EiLhZrgAoZKUwD1ktCPwBBPNu+idcITj20VxSoLIXu4gX+KlreQHBJSE4zAG6DYD1dO
 TPQ3Q8Bf
 l8+ikY/Sc5DBHR5rjM3puIktEC/b1tl2HR6R4VgzZrYvBcbW+e+zMTnz3akSuEJSLGRXxsRgq6D8NUpjX4iV2OGzR39JmovoEmP3nQKKz/93zrKzROimHL9MbmHHg4H9rfBkhgsCZ8pNbtnPQyom/4ga2z/RWgz2kVYZiFx/X+T7moQK4BDXK9JUu/VJU1+zx+dLhjOj1LaM9H+Hx1Fx47Co80CYDvDbVaYSrg3Y19GE1jHLo3bRLUA9MkFI/yv20/zcZmDKpjpwvU9R0UkcwFTe5ETGARjk0YCMFB7VGUDiwazx6xZbaT+FqbijP231EwgbCl71SHsqbQDEgaky4E4UCKgl+2gT0Tl5gf3Cw/EarJlJvuTQXLQVwFwIluYBnT4v6gsZ6PCkYMVANX1PFZ0mWcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/11/10 19:25, Hao Ge wrote:
> commit a739e6b557af ("mm: vmalloc: WARN_ON if mapping size is not
> PAGE_SIZE aligned") put the check in vmap_pte_range(), which is too
> late, because the upper levels may already have installed page
> tables for a range that is rejected anyway.
> 
> The pte loop maps whole pages and stops only when addr lands
> exactly on end.  An unaligned end lets addr jump over it and the
> loop keeps mapping past the range.  An unaligned start maps the
> page below the range and usually misses end too.  Such a range is
> never a legitimate request, and the corruption it leaves behind is
> hard to attribute to the caller afterwards, so bug out on addr and
> end at the entry of vmap_range_noflush() and drop the check from
> vmap_pte_range().
> 
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  mm/vmalloc.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 093b8d5f7b0e..27f2674a5556 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -125,9 +125,6 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  	unsigned long size;
>  	unsigned int nr_pages;
>  
> -	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
> -		return -EINVAL;
> -
>  	pfn = phys_addr >> PAGE_SHIFT;
>  	pte = pte_alloc_kernel_track(pmd, addr, mask);
>  	if (!pte)
> @@ -347,6 +344,7 @@ static int vmap_range_noflush(unsigned long addr, unsigned long end,
>  	 */
>  	might_sleep();
>  	BUG_ON(addr >= end);
> +	BUG_ON(!PAGE_ALIGNED(addr) || !PAGE_ALIGNED(end));

I know BUG_ON() is ugly and it was not my first choice either, but I
have not figured out a better way to handle __vunmap_range_noflush().

If an unaligned range is passed to it, the pte loop may clear PTEs
adjacent to the range. Say a caller passes [3, 12) while [0, 3)
belongs to somebody else. The loop operates on whole pages, so it
starts at the page containing 3 and clears [0, 3) with it. That
silently corrupts a live mapping, and the corruption is not detected
until the owner touches the page. Bugs like that are nearly
impossible to debug afterwards.

It is not feasible for __vunmap_range_noflush() to just return an
invalid-argument error upfront. Its job is to clear PTEs, and an
early return leaves the residual PTEs behind.

I also thought about warning and returning -EINVAL on the map side
and keeping BUG_ON() only in __vunmap_range_noflush(), but the
rollback kills that idea.

int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
                pgprot_t prot, struct page **pages, unsigned int page_shift,
                gfp_t gfp_mask)
{
        int err;

        if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
                return -EINVAL;

        if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC))
                page_shift = PAGE_SHIFT;

        err = vmap_pages_range_noflush_walk(addr, end, prot, pages, page_shift);

        /* Undo the PTEs installed before the failure. */
        if (err)
                __vunmap_range_noflush(addr, end,
                                       gfpflags_allow_blocking(gfp_mask));

        return err;
}

If the walk WARNs and returns -EINVAL for a bad range, the undo
above passes that same range to __vunmap_range_noflush(), and we
BUG right after the WARN. vmap_page_range() runs into the same
thing on its error path.

So the map side cannot warn while the unmap side BUGs, the rollback
drags the rejected range into the unmap anyway. And the unmap side
cannot warn and skip either, that leaves the stale PTEs.

Also, these checks are the last line of defense. All in-tree callers
pass page aligned, non-empty ranges, and I am not aware of anyone ever
hitting this line. So for correct code the BUG_ON never fires at all,
no user will ever see it. The only one who can trip it is the developer
who just passed the bad range, and for him a stack trace right at the
spot is much better than chasing a silent corruption afterwards.

I settled on BUG_ON here. It may not be an ideal solution, but if anyone
has a better idea or alternative approach, please let me know.
I would greatly appreciate it.

Thanks
Best Regards
Hao

>  
>  	start = addr;
>  	pgd = pgd_offset_k(addr);

