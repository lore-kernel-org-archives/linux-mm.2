Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB352D6ACF5
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 13:13:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B6946B0088; Thu, 18 Dec 2025 08:13:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46EAB6B0089; Thu, 18 Dec 2025 08:13:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B8386B008A; Thu, 18 Dec 2025 08:13:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2CD776B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:13:22 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BFD7F8634C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:13:21 +0000 (UTC)
X-FDA: 84232633002.12.CA23C78
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 230F24000E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:13:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SVLARpdJ;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766063600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=84Us82O4a/8lSYgzgrFvXl97iLRIcQus/7IRw2BUJbE=;
	b=Xmrh3Q8Ikc4Zq3l87OtYr5Pq+11/1RCuutNmgAqAtfvMsdijerwmt3A8pBLKApL+9RRZe9
	Dh/BFCrkHMwE1a17y5NqNbDKlMz+OFHaODOM/MIJnpugqRmtNTLjFJO4LvyNkcYY589DFE
	fBsY9m9gA5HfS+yI9A3tWc5/BSxB6D8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766063600; a=rsa-sha256;
	cv=none;
	b=CuxhikiTRtmZDTfvyaG3h9egTmDL4vf1IepiqWlYKWZKoCnt2cQB4K8diq7j/qc4s9INI4
	DoCadDQjjUsJ7+HM2RZNK8Z6XkZc+WeZh26scdJTVeiJ/r3H4UjZXMnPDccfGLESTxuj3V
	yOB0bzr19a5GmpmV+zB/GAL2fTCk0v0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SVLARpdJ;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 906DC60126;
	Thu, 18 Dec 2025 13:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8235DC4CEFB;
	Thu, 18 Dec 2025 13:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766063599;
	bh=noBOehaCn0eQHCOL9jK85iPGFgqWhhnZhi8sq4KK4ew=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SVLARpdJNApORh52uUZZ+oZ2JyLYhhz/WBH+2tA6rmYtnnIiFrQjatV7VC1q2EFci
	 DLtX5VHygbekmzw7MRbwk4qwON5Z/DHQt2yOFU0VXySkdOZgIF2V3xCx9QhBqqBXog
	 E4aQ8c3mqujNi+13wpTULk5t4b9vYwgsMEX5JFo1SLECtdzkXnxw22cGdIMGs7yFUl
	 ++iIalpZiuEX7o05n5TAxa6x25cDbmzLhrPlljziBlORCAe0W7oTKYJPcMZlOTsSy2
	 5ObM33ZOIqIET4C++6F0wqqZDHEaDnFEDMUPNwUDg/gmj3/hBXcPM4fI9fgiinKafD
	 S+RMp1+180Y0g==
Message-ID: <948d425a-2d6e-4439-a280-0ca9e7521b13@kernel.org>
Date: Thu, 18 Dec 2025 14:13:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 3/3] mm/khugepaged: skip redundant IPI in
 collapse_huge_page()
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, ioworker0@gmail.com,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251213080038.10917-1-lance.yang@linux.dev>
 <20251213080038.10917-4-lance.yang@linux.dev>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251213080038.10917-4-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 14ue7i1tkswqo986wir3asm5u75ggk8k
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 230F24000E
X-Rspam-User: 
X-HE-Tag: 1766063600-185564
X-HE-Meta: U2FsdGVkX19f0bNj4he9qGfU0TuEIHRayLeBYiyntEkFP9eEGCgmJ8sfThqAZxZHH0Oo8SUCPESSoqBfGxHHGDu3EjsuGGc6+vfJ9VHlwbTwUoB/9I1AL7aPPzXQB0iDfn5UyA4ZcI/lv2Cf+0yT+Si24XVS0ZmpWZvorSbbatpYHNQ973OGGNS3OGjbb1pUP0EKLTBmMTSfY1wXXZJu11dQCX9/bbPvHUuTcoeOsBalRmoptZiCUG96yLTrDl/ST5WBy4SOZulZEbv/Meh1+HTB4bU1oUjxfCFqdwu0fNYJk7xwnuTlw8AznVWrGNTGi6DbIpY0IO4ZWQ/YMlH7T/BJ2BGlDS050nw0hfzAgRS8yUgdEKWk3Y4lPyIobQTrXrzYYyeFUOTZ2QWqLRuU586IE9a7UWluhbCfH3pKuzosT+npUuxIKrcX3Dlq/u8LZMw5GProesQ9WD2tKjYX/jSwRu/9RvVRpRFUjGb+7XHlb2fOn4czqQjDykibbEL/tcmbTwvRmtV3MflPi8mg9NdbEojTqbQ1b4mifTomu1X7UQDf9OpdzDU7uxYoCuHu09w5DZpctPJcqs0q3EcYZi1K7gkqwwgLAsgPEerqACqe+ex4jllaRmMp+wkn2tRsAAfiO5kAZs2+wf2fVOlHxrKj9J5YS0CCUQKZMSN8IvBaB+/MLs/EOELs8BlafOFp/gPGghyRl7y6qt7UNzdVnWEDBAq4w9C+1fJYnIWHp+It6LfhSqkbPn6UCz0hNChlRL9l9frp+rShcHBXkmMniIcIVOifsU5vZ3pCyGV1KjCaWPUoEG4dXYED9AaLpgR5othd71ns7PYYSypOc/wHO5KrHZjPT7Ercvb0x5q8Xi3KWtqRDRq+ZNYVwtx8FGN2KudhUmFi6gC/5LEkpOCuqA+A3l/cB0MDSs2KLpTwOkV9Y5Bhm/Uo+begvyfQttbSvpaWaOyv90xA0PHmMR6
 mkdQbnly
 ptvpmznZIxXPkXWOJWDcGR/Z0HSNj3AhBKG+0WCzrqDUd7jBiBNNR/+UMPlEphP8ggxvjiPjZAplUjrffcBq2bUgJgYAlTQLSpG/pq7EEVY+8dQAeoqRC7Gimq8aRP+0JmwHGAptMU6fEu9as+GhxWmO3NU5pcFZ4fD0Gv6SJVBRRL2/GusX15hDG+M/Sx4A5rMr7wWem6FQpxUrzHUOgDKkUiqwmTlUaf9QmohzHozFPtXRrk76AuDHfs3L3Qn8auOkqnwN68lOI4Nrqgzw1RzvSURg3LOggC0gcGwK5bxuneNJPXFeIsyXSQ4qslpkk9GJn9BM6ZJ9VVGc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/13/25 09:00, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> Similar to the hugetlb PMD unsharing optimization, skip the second IPI
> in collapse_huge_page() when the TLB flush already provides necessary
> synchronization.
> 
> Before commit a37259732a7d ("x86/mm: Make MMU_GATHER_RCU_TABLE_FREE
> unconditional"), bare metal x86 didn't enable MMU_GATHER_RCU_TABLE_FREE.
> In that configuration, tlb_remove_table_sync_one() was a NOP. GUP-fast
> synchronization relied on IRQ disabling, which blocks TLB flush IPIs.
> 
> When Rik made MMU_GATHER_RCU_TABLE_FREE unconditional to support AMD's
> INVLPGB, all x86 systems started sending the second IPI. However, on
> native x86 this is redundant:
> 
>    - pmdp_collapse_flush() calls flush_tlb_range(), sending IPIs to all
>      CPUs to invalidate TLB entries
> 
>    - GUP-fast runs with IRQs disabled, so when the flush IPI completes,
>      any concurrent GUP-fast must have finished
> 
>    - tlb_remove_table_sync_one() provides no additional synchronization
> 
> On x86, skip the second IPI when running native (without paravirt) and
> without INVLPGB. For paravirt with non-native flush_tlb_multi and for
> INVLPGB, conservatively keep both IPIs.
> 
> Use tlb_table_flush_implies_ipi_broadcast(), consistent with the hugetlb
> optimization.
> 
> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>   mm/khugepaged.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 97d1b2824386..06ea793a8190 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1178,7 +1178,12 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>   	_pmd = pmdp_collapse_flush(vma, address, pmd);
>   	spin_unlock(pmd_ptl);
>   	mmu_notifier_invalidate_range_end(&range);
> -	tlb_remove_table_sync_one();
> +	/*
> +	 * Skip the second IPI if the TLB flush above already synchronized
> +	 * with concurrent GUP-fast via broadcast IPIs.
> +	 */
> +	if (!tlb_table_flush_implies_ipi_broadcast())
> +		tlb_remove_table_sync_one();

We end up calling

	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);

	-> flush_tlb_mm_range(freed_tables = true)

	-> flush_tlb_multi(mm_cpumask(mm), info);

So freed_tables=true and we should be doing the right thing.

BTW, I was wondering whether we should embed that 
tlb_table_flush_implies_ipi_broadcast() check in 
tlb_remove_table_sync_one() instead.

It then relies on the caller to do the right thing (flush with 
freed_tables=true or unshared_tables = true).

Thoughts?

-- 
Cheers

David

