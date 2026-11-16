Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64FA8606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 22:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m1/yIuj7
Received: by kanga.kvack.org (Postfix)
	id 0C6DE6B05B5; Mon, 16 Nov 2026 17:22:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 077326B05B6; Mon, 16 Nov 2026 17:22:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECEF96B05B7; Mon, 16 Nov 2026 17:22:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC4B46B05B5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:22:01 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C5195A0269
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:22:00 +0000 (UTC)
X-FDA: 85442406000.06.21D900E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id F10E240003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:21:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="m1/yIuj7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794867719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NKn+EYu8JI7OipXz+FXwJVhOQ2Y/d3+kqCA90whrW1U=;
	b=eQSoTHLcsjr2hoCv+ZV/nTWbWcfDderL49JuqnryQl3t3VYSHiCo/F+JBrjjpFPupOqqfa
	ez2SCNx0KKUqzdzfmpaGfJCzONMIzxm4CkneR9uTxCfLHH2LESffq3LAZMKQ6fdvsxYgRU
	OmxEwUJEUrzDJ0e7uRaNM+Ar2E69P8o=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="m1/yIuj7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794867719;
	b=M4WYw0ZdCPySUmULFtVUZc3ZrjmFPg+7OwP+C4YVT+UHM8ga399O1NXuSW78zKdb+VlpKS
	Gr3j7v1v566N2ZNHtx/671tEN7bfgHF0icIk1VBwpuyP6O4d8x58mfTxKc8aEKYcX/DG2X
	X7o66QFV8eDKJf9R/9Ex1IZ3Tcnj0qc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 37CFC4394A;
	Mon, 16 Nov 2026 22:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995011F000C4;
	Mon, 16 Nov 2026 22:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794867718;
	bh=NKn+EYu8JI7OipXz+FXwJVhOQ2Y/d3+kqCA90whrW1U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=m1/yIuj7i2EI3Cz8LhOhp9kCyYuEjJstPPWCqhhwBuhLOVO7cBDk/J7GeZYr417DW
	 SdfzXNY6okUzvHD7qbIFsZCjKh/WupZQ5NmcAcJbpY0HrPyPqWBp+mgA1tDQVntpD1
	 O8PBUenFw5ZgKjIXL6TYyN8qvBVU76PxD4xnnl9oV9FywRWfGhV4y1LJNZLlZKnrG3
	 RggADVYfhepv9nrmWxUYzsKLIIcbJHAIqy2XYGtvLKZOH8m3RhTYcsR29F7zRow64H
	 +D3RvN70avgrANCKD0MFW8Qa0heX8rdJheE905JP0mZGDbo7iwEKAezltZer3UkXye
	 dtVT6CSW9KatQ==
Message-ID: <b4a82805-5b13-46d7-bdb6-0ad2eb70f148@kernel.org>
Date: Mon, 16 Nov 2026 23:21:48 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/ksm: prevent zero-page remapping during
 ksmd-triggered THP splits
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Yu Zhao <yuzhao@google.com>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Usama Arif <usamaarif642@gmail.com>, aarcange@redhat.com
References: <20261025-b4-ksm_fixv2-v2-0-8b61ad0491f1@linux.dev>
 <20261025-b4-ksm_fixv2-v2-2-8b61ad0491f1@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261025-b4-ksm_fixv2-v2-2-8b61ad0491f1@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yxjcq5wup8qtwwb9kgaucfhs6cgfkq6f
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F10E240003
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794867718-889835
X-HE-Meta: U2FsdGVkX1+tf41Ds5jgi8BUkcriK3MndZEgMcxSxMSGGBuSEhf18X1IDAjz4KKtgfX5MmeodyHHUmsmREUejUR3ROBPtWAj/Ilh8cU2Db4J6lRloRkMHOwv9e873dA9YTnj+mw4v3ceeOZdL0UNyqXq+JtUU7zYVMJHdXAkNs1FkAtYi/pF/I2CyNeNbS5EgjB1MoNNWzv7fhZHHSrEUNOuPeuQIYyOh3WmJKHPK8zedb++66It6FjB3tEzzucrU3Z2N7gv0WQ2lsPacVtQvCxf1Sefsffq8NWYTKRunolRVaDHcrAZs84bwRHuHJZgcgKTkGUuUqHRpu4ofV9QnC4cX3RrHb8nFRPfClPBtGyLA8OepHcWwXe/C0kOVWckNfPlwXOOkmliLobu3g08OwG4V3yjs3UqVvfQWGsMe42D6A/ZnlY4R6V/v0WWL8IycSQutT05XI8SpeNSKMcmSXWi4iIbp3m6sZ45cjRj6Hnt160urW/vD1AYaIVPwxHTpQ1M+brZVnS6ZiioFdpAAUL302f4+GnXQRpgFvPy5LiGW5u0lAgcTyOO9+5J5gA5V5KQ20sXGbobV3BMMkOz9cWmAKv16w7UPXCR6ggo4UZVzE1a0IflhTnz4EYqkgogcmmvj7L4AqFUBl23Z78QMjkgvN2Cn1IIQ8NrVZNvbpO2iwWXYnpj8SQALHeq4xOpLkcLjXNsvjXRo5lkg+CJCSM4nk0TbQc7j1r8QX7+2RhAMQYEcl1usglJcqQeaVsPPYG5TXuGCKYsZiwTPUxivY7YJtAy8fPdYXFnnY3MMuhryJYo86wOFVjQyFXTvGlfSoEydVJQX4uDFi8lkwFKHpmogdqS073eBOY0sixXYg+hd1qmD29Wl5PNYLd5ydtN6wqJSnb0+ZV7xAf1g2EvgRDbqxaLwKPOig/NWooDGXJCs0mdXeCJiYI9GJa+IBgluMe5ZjFhB8EeSfxiA/k
 xCnRqao+
 THol2aEFsVVHrKAlKJWpkYwztLqxr3/5BvYFVDN5dl7UeRcZXYZ5hgnShmyxqxj+7VyAadwedchxIVbpOqZpghm8fBWq9wYTa1DRB4LG3U5rSjR26VDrDc7zl8Dlk+DmYJ3S6bAIaVoEt0ToW+owFlygsN7LXHqcNfldWZmlIiuQz9BEMiMaasilsPD/Fbl49/eUGqjG8Q/+btMj4/E+eNeao1MovLF9C18bXHmNVfv1gljGyBPVqM0+eDD/3T8LeeO5nQktzSMKzcT8hbozcmaWYRENl0NLo56Nfxdo3zTwB9qu4+FG9jCveKUlorrL69xB3p6QYZXV8ZOpsKkoEfzKMvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/25/26 18:39, Nico Pache (Red Hat) wrote:
> Since commit b1f202060afe ("mm: remap unused subpages to shared zeropage
> when splitting isolated thp"), splitting an anonymous THP remaps all
> zero-filled subpages to the shared zeropage via TTU_USE_SHARED_ZEROPAGE.
> This flag is set unconditionally for every anonymous folio split,
> including splits triggered by KSM.
> 
> When KSM is enabled with THP=always, this causes two regressions:
> 
> 1. use_zero_pages=1: KSM calls try_to_merge_one_page() which triggers
>    split_huge_page(). The split remaps all 512 zero-filled subpages to
>    the shared zeropage at once, freeing the entire 2MB THP when KSM only
>    intended to process a single 4KB page. This bypasses KSM's
>    pages_to_scan rate limiting, causing ~1GB to be freed almost
>    instantly.
> 
> 2. use_zero_pages=0: The same split side-effect occurs through the
>    stable/unstable tree merge paths. Each pages_to_scan iteration
>    triggers an expensive split_huge_page() that silently frees 2MB,
>    while the scanner wastes cycles on tree searches for zero-filled
>    pages that were already freed as a side-effect.
> 
> Introduce current_is_ksmd(), which uses kthread_func() to check whether
> the current task is the KSM scanning thread, and use it in
> try_to_map_unused_to_zeropage() to skip zero-page remapping when the
> split is triggered by ksmd.
> 
> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
> ---

[...]

>  static bool __ksm_should_add_vma(const struct file *file, vma_flags_t vma_flags)
>  {
>  	if (vma_flags_test(&vma_flags, VMA_MERGEABLE_BIT))
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 7bdcdb57652f..c33ae3fa1043 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -305,6 +305,9 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
>  	if (PageCompound(page) || PageHWPoison(page))
>  		return false;
>  

This really needs a comment like:

/*
 * When the split is triggered by KSM, let it take care of scanning-for and
 * de-duplicating the shared zeropage.
 */

> +	if (current_is_ksmd())
> +		return false;
> +
>  	VM_BUG_ON_PAGE(!PageAnon(page), page);
>  	VM_BUG_ON_PAGE(!PageLocked(page), page);
>  	VM_BUG_ON_PAGE(pte_present(old_pte), page);
> 

I'm still a bit unclear of what happens when the split is triggered by something
else in the system just before we walk into this THP.

Like, imagine the deferred shrinker scans for 0-filled pages and splits under
memory pressure. Then KSM scans and essentially skips the (now-split) THP?

-- 
Cheers,

David

