Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E6BD606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 05:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=soXSklK+
Received: by kanga.kvack.org (Postfix)
	id 5C4EE6B00EF; Tue, 17 Nov 2026 00:53:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 575006B05B0; Tue, 17 Nov 2026 00:53:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48E256B05B1; Tue, 17 Nov 2026 00:53:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B51A6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:53:15 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BDC45160358
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:53:14 +0000 (UTC)
X-FDA: 85443543108.07.BDF1EC5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id A3AC840003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:53:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=soXSklK+;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794894792;
	b=ab4gCjTS/2PYBI9lJU4RrSLZWJls/admzPOwe+YY08pi9ZFn8cFesjYFwCSrLxEK8/j+UV
	tUstE/LDxkYmzuIXHK7IF6kJKPQaSPRnpT7lxd21mZB5zMGT9ooXtvwdUiQ//K6A0BBr6o
	zTSZwT4EHE5G5Z7flNlOpituo84khGM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=soXSklK+;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794894792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=preYSvRhvln7+HpvLwGVKBTF6qwxYYu7pQfN5NTytYU=;
	b=gVxtsFW0ta+bacrTwgBA7CGmlIqHg/z0Day7LhQiKqXFj3+mPKRO3FC7xsCYS2wz0NLTZJ
	hzAyOtr9zXSFpQLAkdJe/EoEZGkeR2T977IdoSQ2g9T2oIgoLfGuU6zBAq+1eDOZbuoPyt
	wP37uViOA3rvqq6x/mMU1cc69SWA44s=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 69C311682;
	Mon, 16 Nov 2026 21:53:07 -0800 (PST)
Received: from [10.163.156.60] (unknown [10.163.156.60])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 282C33F673;
	Mon, 16 Nov 2026 21:53:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794894790; bh=LeNEd6XybC/0oQxf6tPEXuNsH/uhyc0vnuxHYF7fhAE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=soXSklK+FJaMyX7c81avmAyAcqpvFzRiWZU4JCZehiQO8CLy91r+p5aueoYQaI4om
	 t7tyYU15TqiYoQGlI/BoCP1DY9vNUu0BY9gThGDlvh0HvfLGNprRWeRo7J1dRd7YoH
	 HsnX9MS+DU6Ph5GxQpqgRIVBJ9LuTa9/Rq3k3uFg=
Message-ID: <7191bd56-ba20-4b60-9969-7005e64c086a@arm.com>
Date: Tue, 17 Nov 2026 11:23:00 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/11] mm/vmalloc: reject an unaligned range in
 vmap_page_range()
To: Hao Ge <hao.ge@linux.dev>, Suren Baghdasaryan <surenb@google.com>,
 Uladzislau Rezki <urezki@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org
References: <20261116071325.263682-1-hao.ge@linux.dev>
 <20261116071325.263682-4-hao.ge@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261116071325.263682-4-hao.ge@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A3AC840003
X-Stat-Signature: o46aqu839u617as1xrenoc8gh6pydkxi
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794894791-493762
X-HE-Meta: U2FsdGVkX1/nvXY8NKfbKTPtajZnS40Z00DNz/ZrOv2aPCeq2CAavafAhd1HldXiNEmE9KbX6ad3AXodZaNNEp/LQYalweT9L1xhUsYfONmuCS671DxT434S4BSXPRB2NFm45uESPBhd+xUZ/TSL+scg7H31aOlfzlLEbZoS16ySwDF163theTV6MYV0nyk4wdT893Xdj/N9vwcU0iygMK+biCsraSMb3EWNwC/EypOl8FgyXHPdTDoTweXmFA+xXH2u8ZyU+U3GGmsB0O5S0t/JzrExdMrW2wu+S04nXmXjdPrAWC0/JuaLDagbOtq7RiSYZ/40IuR7IHmourcIo8emC+g/1fmippA4lWPUzDy8ZV36Q4BNiRkdYFi8Ihwf7FU2QqPyhN4ziXETz93zFFHnaeAsLtHZvGLHVO+B9/tRjZJRhlZ0TGkHVuMVGH0sNQKAVfTcmmIRPVqk29BdqCk2iZUvPK6qXik2786W/mAfkfeQocMAlreLhMZNAWtZs6P+d5Om7hC6jHQcN8o8pPXnLPQLxYhk/FV13jGUtHB8vBzq67vvD754RXmABe/FYqexFUpCOuZHnmrbFGBFKvRf58k4yvGxyGSD8ApREHWuDegxOg8EBbx+mTFpnG1mhrua35BRWUi5pGDxKsbgVDeEELjk1k+GM9X8F5uCqGq00uS52IQkxisGCB3ry5xzrN8lfEoedIf7CjWHl4426TKUJr7nv6VPaDWGdH3uZMiHWbDT6B2YwqnKNnf8mhDc6cwCGmLX8FxRYrWJJ3lYs2tlPCqD8w6Nr90OJThPt6CIFkCr4WPLCXNdSpN2y1ABw95o7N1G+b9CQk9p1Jfo5ED8x63u/vUUS54/9Qh7f/WN/0FIrgja4E2byi+TpkUifhm162qPhgVnALFM8OOfzRfcJk+GuDA/+vroHSQXX+N03qFqwoJiMSIgckkW72xb4L9mYo1OEO4vONERhQc
 N+VPZ+at
 2gaqvBDAP7zBv8Tbb5ontwWqRweie+fkC61Ktvdjxqd95jNMG4hHkfEsfCLzwcmjrKDij+SDLfg4wr1JzYwrqrFuIw19e/vSLt+FucdMZ8aaFQ53UQE9dVFHUewF+ACnlBhgc6aVqYc7pVqQzu7Brr7iWhi+8iXZZacX9x4+mVgV1M2rMjlFMjoxLTeItY2TwI9UqTTp8HRU9xstzG4ECFvcWryTy0NC9zIlHcHuo2FxgmqYMjFexAJd6IpIqal8jRd1L1/RGVtbkY52Z4eZigkVCTbdPC/sfpK/ByyNIfN31uk1CgafNCpMPK42TDIIu/Ajtqyqbtmg5JiLCSwzOXfouGqZY9k+nMfgWuR7xpHkh/TLNjunlMks41ig0tZfGKfBKkW0TnpLEiOT+H4C8V6A9p2yXI7QZ1JDmtItY7neJFknPHLV5uOm3zoNn83SvLeyc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 16/11/26 12:43 pm, Hao Ge wrote:
> commit a739e6b557af ("mm: vmalloc: WARN_ON if mapping size is not
> PAGE_SIZE aligned") put the check in vmap_pte_range(), which is too
> late, because the upper levels may already have installed page tables
> for a range that is rejected anyway.
> 
> The pte loop maps whole pages and stops only when addr lands exactly
> on end. An unaligned end lets addr jump over it and the loop keeps
> mapping past the range. An unaligned start maps the page below the
> range and usually misses end too. Such a range is never a legitimate
> request.
> 
> vmap_range_noflush() has a single caller, vmap_page_range(). Warn on
> addr and end there and bail out with -EINVAL before any page table is
> installed, and drop the check from vmap_pte_range().
> 
> Suggested-by: Suren Baghdasaryan <surenb@google.com>
> Suggested-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  mm/vmalloc.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 3c0d9e69b886..a168f6f20f4f 100644
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
> @@ -369,6 +366,9 @@ int vmap_page_range(unsigned long addr, unsigned long end,
>  {
>  	int err;
>  
> +	if (WARN_ON_ONCE(!PAGE_ALIGNED(addr) || !PAGE_ALIGNED(end)))
> +		return -EINVAL;
> +
>  	err = vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
>  				 ioremap_max_page_shift);
>  	flush_cache_vmap(addr, end);


