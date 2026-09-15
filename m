Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27B90C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:09:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 130496B0088; Tue, 15 Sep 2026 07:09:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E3106B008C; Tue, 15 Sep 2026 07:09:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3A856B0092; Tue, 15 Sep 2026 07:09:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C99506B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:09:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5EBD0403B0
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:09:18 +0000 (UTC)
X-FDA: 85215725196.16.2BCA262
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf18.hostedemail.com (Postfix) with ESMTP id 70AE81C000C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:09:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=m+8f4mOO;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789470554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vxNn5ZYVwKKzqCEAyb+0n26iLMvhwicQTy1pDi/GIeI=;
	b=fh+/2kudaMfvf0DsGkGRAel8glVdJvCuKqtxuT9NteOpg4JAyysNR6Z7H5o9yPe/HSET1b
	YAh0Tmwk1pox0HrSTM5E2dMkspL3qyKEMmdG1lrgcmFxF8einlLkpxzbQE5KNPnNVvQ6/L
	xVR/7PnYveGYhha4IU1569biJAMUomI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789470554;
	b=eJiNFNKJIYReLanxASGgSr/DbLQOgEvJfX1CDuyIMyhqAc9jaqO7mVhJS+53GSLRJgII7B
	xPu/zlBXhIQQsP/Vg4MPOQEBlk2S201SGQHkNyd2nSlogTcy54jFtVNCXHsuHgSzJ5xm0u
	nQM9rOLaehXa4zpg+HMczRrnqRMNcnY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=m+8f4mOO;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789470549; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=vxNn5ZYVwKKzqCEAyb+0n26iLMvhwicQTy1pDi/GIeI=;
	b=m+8f4mOO/CvcB5AwAjFFsDOZDO0gpsJB8E0RWWVX8V8L5eUZyt/L7iJSVfxqcJAI24zTLVSQFDaHWs+K+0Uc30r4BvqewS4agFAEepCGTvnEF+lXGfpB0UmIIpOpjJ9HvTBD2s9Nw1RyXQGwTVL4VRu7tBQMA4lmFgZWj6UIIX8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0XB1OONN_1789470547;
Received: from 30.74.144.126(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XB1OONN_1789470547 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 15 Sep 2026 19:09:08 +0800
Message-ID: <1e91c48c-cfdf-4a40-bf1c-88d8e0295c5a@linux.alibaba.com>
Date: Tue, 15 Sep 2026 19:09:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/12] mm/collapse: separate scanning a PTE table from
 collapsing it
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
References: <20260910120238.2529819-1-kirill@shutemov.name>
 <20260910120238.2529819-9-kirill@shutemov.name>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260910120238.2529819-9-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 70AE81C000C
X-Stat-Signature: c1m31hysceqdbx7ex1q43ibmgokwmakh
X-Rspam-User: 
X-HE-Tag: 1789470553-905167
X-HE-Meta: U2FsdGVkX18PX6aZLOYoJavOA1y6Ralii5SdVncvl4SmRPSIeqK98V4PAp+WR0boEQwgYsLxjzKa2dL83h8RfTN2bio64+AuET6tiOGs5UbAJ4ce92sTjlz/UUJ67cj/jQn7LHDrPpib2rTLF6l1puELC0EnsSdRcPxLSWKuGgJkHgHfQMREvBVKOHDGyATyllUQO8bN2aFYdMm4hJ6aYXCmqPSTaCTBVSvzsd1H9mpLjcvmWRnxxOVj30cfKYhBdYT5al1fF/KB6BNiwfMRidNN+WQOvh49F5N6RzjU2JbqNEdsWf/JagIWvHp5FEXRYXGtcD2qa9u4V3s9KbbQCzMiPo6gct9SHYjjzgAVw+tPpvI+DPiqLkhsiZws/INqew4I+6yn1aRsoTq2+j7NX2w11D+U78dsO/XApJWxiawyduZ0ysQU0al0lfHBLwdH4M5De9PFKCy+vrYoQuSfv7GIYh5vkk6sg2LLJDYyv5z33YzcglgcjhAMsUzB5O4v42GdCcsvg5cB8lUWE5dcG9kPlhevFrdMVRRXWOsk22Wg6i9o1dE9Fo4nD9KtoVx4pXTefeiOUCYZGGfyh+ejNUNHGH7yDMhR2asGs4VG++9eQVdmXkQ4RiYIxwQvrysieFrx25TxIc0t1OcoLprTPGFkS8t4RJ8VmzZUv42JfDtvZQEAulyCSzeoUOtgljMN5NwdGN6qlrw91HEKwXXkyQaVIW2mMWsJ6hukxPPJ9MPn8yyZ4IL59TksizuWHravx3+scCaP1TD/ZsoRFMDSGYxmHDHwgnoa98EKYJP4Atkq/Aj7/pfnNFiC2K/yYnfeKJLYYwLLJ2kaA2+Pr1VjRwOoqemssqIHcCixFQaPLaHOtYXjOJcnibN1Uh9KSVtts6TAxnIZLVuxQxYgvLVRf37GRWk5q1dxZzno+IFF8I5wxumQ9LRaqwKKPS/7o3xrhgJTQK57DuY4rSe+NL+
 MXWpre8j
 fC+FSW1L2FwFDArmbFAlES2gAP3/hFVhUTMtupHeg6YTRkTaXS6exUlO/OjZujDgfiCNGK6HyRjRn82LwM4hrjEW+VYLyqvumU4e9yx+CnzRDZumRRQd4DxmnTSYvfKMaF2hXHRhzMVpPEqcQQcweJTbsHeeg6C5oo3bvOlpL2S2PIWhXjySTJ2mA8Ap5CzGv7IrNsBK+5VneI24awSFw7/MrYtteY1VI/QSKXpzZPeSSvasnShyyulUun0q60XTumWsp0MYKKXaSbwuCLYdMQgJryUh3zFLTAhFZdtNO2mbV/EYFyq0sQLEtqdsU5pO19s13ECRqH85hwfbnqvzOChAcPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/10/26 8:02 PM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> A collapse is two jobs.  One reads a PTE table under mmap_lock and decides
> whether the range is worth collapsing.  The other allocates, isolates,
> copies and flushes, and wants the lock given up first.
> 
> collapse_single_pmd() did both, so the boundary between them was somewhere
> in the middle of a function.
> 
> Give each half its own function:
> 
>    - collapse_scan_pmd() scans one table and only reads.  The anonymous
>      scan that used to carry that name keeps its body as
>      collapse_scan_anon_pmd(), and collapse_scan_pmd() is now the entry
>      that picks the anonymous or the file side.
> 
>    - collapse_run_pmd() does the collapse the scan asked for.
>      SCAN_SUCCEED from the scan means there is something to run; anything
>      else is why there is not.
> 
> collapse_single_pmd() is now the two of them with the mmap_lock drop in
> between, so its callers see what they saw before.
> 
> What the scan found and the run needs travels in collapse_control.  For
> an anonymous table that is the orders and the referenced and swapped-out
> counts.  For a file it is the file itself, the offset in it, and whether
> the PMD folio is already in the page cache.
> 
> The file side moves with the anonymous one.  collapse_scan_file() used to
> run with mmap_lock already given up, and called collapse_file() itself
> when the page cache looked worth it.  It now runs under the lock like the
> anonymous scan and only judges; the run does the collapse.  A file
> collapse works on the page cache and never sees a VMA, so the scan takes
> the file reference while it still has one and the run gives it back.
> 
> That changes what a refused file table costs khugepaged.  Every file
> table it scanned used to end its pass over that mm, because the lock had
> been dropped to scan it; now only a table it goes on to collapse does.
> 
> Two things on the file side stop being rescanned.  When the page cache
> already holds the PMD folio, the scan says so and the run goes straight
> to retracting the PTE table.  A run that refuses dirty pages and may
> write them back retries collapse_file() alone.  The checks the scan makes
> ahead of it are ones collapse_file() repeats under the page cache lock.
> 
> Tracing changes with it.  mm_khugepaged_scan_pmd and
> mm_khugepaged_scan_file used to fire after the collapse, so for an
> accepted table their status field carried what the collapse made of it.
> They now fire before it and read SCAN_SUCCEED for an accepted table.  What
> the collapse then made of it is for mm_collapse_huge_page and
> mm_khugepaged_collapse_file to report.
> 
> Assisted-by: LLM
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>   mm/collapse.h   |  16 ++++++
>   mm/khugepaged.c | 147 ++++++++++++++++++++++++++++++++++++------------
>   2 files changed, 128 insertions(+), 35 deletions(-)
> 
> diff --git a/mm/collapse.h b/mm/collapse.h
> index 7044dc71c7c2..346859a2184f 100644
> --- a/mm/collapse.h
> +++ b/mm/collapse.h
> @@ -88,6 +88,22 @@ struct collapse_control {
>   
>   	/* Each bit marks a PTE the scan accepted as a collapse source */
>   	DECLARE_BITMAP(eligible_ptes, MAX_PTRS_PER_PTE);
> +
> +	/*
> +	 * What a scan found and the run after it needs.  Live only between the
> +	 * two, and read by nobody else.
> +	 *
> +	 * The file side takes a reference while it still has the VMA, since a
> +	 * file collapse works on the page cache and never sees one; the run is
> +	 * what gives it back.  A scan that found the PMD folio already in the
> +	 * cache leaves only the PTE table to retract.
> +	 */
> +	unsigned long scan_orders;
> +	int scan_referenced;
> +	int scan_unmapped;
> +	struct file *scan_file;
> +	pgoff_t scan_pgoff;
> +	bool scan_retract_only;
>   };

[snip]

> +
> +static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
> +		unsigned long addr, struct collapse_control *cc)
>   {
> -	struct mm_struct *mm = vma->vm_mm;
> -	bool triggered_wb = false;
>   	enum scan_result result;
> -	struct file *file;
>   	pgoff_t pgoff;
>   
> -	mmap_assert_locked(mm);
> +	mmap_assert_locked(vma->vm_mm);
> +	/* Whatever the last scan found has to have been run by now */
> +	if (WARN_ON_ONCE(cc->scan_file)) {
> +		fput(cc->scan_file);
> +		cc->scan_file = NULL;
> +	}
>   
>   	if (vma_is_anonymous(vma))
> -		return collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
> +		return collapse_scan_anon_pmd(vma, addr, cc);
>   
> -	file = get_file(vma->vm_file);
>   	pgoff = linear_page_index(vma, addr);
> +	result = collapse_scan_file(vma->vm_mm, addr, vma->vm_file, pgoff, cc);
> +	switch (result) {
> +	case SCAN_SUCCEED:
> +		cc->scan_retract_only = false;
> +		break;
> +	case SCAN_PTE_MAPPED_HUGEPAGE:
> +		/*
> +		 * The page cache already holds the PMD folio; what is left is
> +		 * to retract the PTE table, which is the run's job.
> +		 */
> +		cc->scan_retract_only = true;
> +		result = SCAN_SUCCEED;
> +		break;
> +	default:
> +		return result;
> +	}
>   
> -	mmap_read_unlock(mm);
> -	*lock_dropped = true;
> +	/*
> +	 * A file collapse works on the page cache and never sees a VMA, so take
> +	 * what it needs from this one while it is still here.
> +	 */
> +	cc->scan_file = get_file(vma->vm_file);
> +	cc->scan_pgoff = pgoff;
> +	return result;
> +}
> +
> +static enum scan_result collapse_run_pmd(struct mm_struct *mm,
> +		unsigned long addr, struct collapse_control *cc)
> +{
> +	struct file *file = cc->scan_file;
> +	bool triggered_wb = false;
> +	enum scan_result result;
> +	pgoff_t pgoff;
> +
> +	if (!file)
> +		return mthp_collapse(mm, addr, cc->scan_referenced,
> +				     cc->scan_unmapped, cc, cc->scan_orders);

You already record scan_referenced, scan_unmapped, and scan_orders in 
'cc'. It looks like simply passing 'cc' as a parameter should be enough.

