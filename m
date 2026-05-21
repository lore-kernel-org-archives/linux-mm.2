Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3493CD5BAB
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 22:31:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81B3C6B0096; Thu, 21 May 2026 18:31:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CBEA6B0098; Thu, 21 May 2026 18:31:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 708DA6B0099; Thu, 21 May 2026 18:31:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CDC36B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 18:31:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 078761C1AB7
	for <linux-mm@kvack.org>; Thu, 21 May 2026 22:31:34 +0000 (UTC)
X-FDA: 84792874908.24.9648BED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 56A58100013
	for <linux-mm@kvack.org>; Thu, 21 May 2026 22:31:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dgyXsqH6;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779402692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bnv8z/U53fPYRQVRdESTD0xQjxqDX0NyGk7FJvl1zug=;
	b=gvFtGItM3NCRWtVnVcMenlaWsCTCo9ePtKPo8CX6mpsjY6LW+4Ngza8kDpGRzOiHc5R0a8
	VaR9R2Vk7JM2WmXo2NWPufbu4RBmPIEUM7M3LZWaU+xFJikEnV6tCC37DoCquP0Q+U/vnd
	fhghFln2ElHqHlYbXChncaXE/uAOcwY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dgyXsqH6;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779402692; a=rsa-sha256;
	cv=none;
	b=53foV/+UkJB67ds33+Mt9eQRD7oz/FaLlVCZciYbTvgBmr5ZO1h8/8CyF5d6bfhgHvhvmx
	aR1qx6znM7gts0pCgLtshBWzrHMwG1/emIOvRKpNJ4VN3aHuL/ryLclgXr9P+UHdENVMfk
	+OBNkYD/hWx+e8xOn7usXuaEXpOFs/k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 553ED41A5C;
	Thu, 21 May 2026 22:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02621F000E9;
	Thu, 21 May 2026 22:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779402691;
	bh=bnv8z/U53fPYRQVRdESTD0xQjxqDX0NyGk7FJvl1zug=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=dgyXsqH67FvyK+9N+RrmIuzBnPicK5E+nVD175qTBrUi/dZfe//hrorWytuL6wRpo
	 g/WQLOOXYW9aoOx0MAwfabDfx6fXjkFvdm7PbfxgdHHnL9fSY4y2XNQ7fJZips1O8Q
	 NBQBE0pdjLnBhjrbbOTs7Jlfa8pXiZwDxcbAiEq0=
Date: Thu, 21 May 2026 15:31:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alistair Popple <apopple@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, catalin.marinas@arm.com, will@kernel.org,
 david@kernel.org
Subject: Re: [PATCH] arm64: mm: call pagetable dtor when freeing hot-removed
 page tables
Message-Id: <20260521153130.d7d5cd060f7522f894252333@linux-foundation.org>
In-Reply-To: <20260521032730.2104017-1-apopple@nvidia.com>
References: <20260521032730.2104017-1-apopple@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yopos5wrn7m9iagu3ydgioksen1rir5g
X-Rspamd-Queue-Id: 56A58100013
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779402692-770131
X-HE-Meta: U2FsdGVkX18d2dztuVQEDhIKHikkaHq/lB2f5Qcc+hUG1yweDe5HgxvQVlAKhNXmeYAGs7gj4/faaD0KOazAcinJn+6lTtzhDI7Bbslt9x8DoQwB6iHxq6p7OKn8sQQ9GMr5P0RNQn0PM+aUYcgYFxSXKOPWAy/nLcHfBZPEaoqQaJwt7w2MgPa9HpwPgMJSs2Ji7OCn3BsIxO4Lifnn9OmwAnx3qKjmR3dYiyyEwHRlFV0z2enlc2x2+9o0g+gJdRS9smW9CUd3CjIZeyc6zHVVWHd45eCB8scNhK0+KxEDGD0aP0stPU6WlCFpIN5S/mn0dG9wmb7p1PDFX7v39CECBZz/65HiQ0J3uJJ+DrIkAPPkJWRuhN+px1Qa1TDqIhn9gZ6vad0wNNi+vkI7EW7uShX7Pa/tC5qOp112HAExQKEgEZXu9c3p+U6gVFJsPXDtQrpoFrHIEukTI7u40RQHhfwVomoyKR6Fu3rxRKMPD8MyLuK2QGNmNQin5UxvLSJwLNRSmF7NF1kPbf3xOLbX+mTyRlfVy87CKcm4RTcsDK9ebSJeyH6rfiZuHoXRs2TEpZsba8g7jv+CGUDUfjfHntT+EqwA5PIMq6q9FLG8C9CoRvCck/QN2t6EvOaWLQZJo+Y6QKw4jtumr9t8jkUaMM4BMNvl4wbHtwrNni7fVHdgWO4DM7+P6O7sKcDkkUtGnhoEbiVPBJe3khgo+g52vq9jDkQa998sQG9mFG1VS+KMnjUZ3aCVjH8DVstpileeMCaLE3Ptre2/kcJY10p5pGgGRj38gWDUojInap3e7PbOBaDV9r5HlSaJk4msFQ8/j7jntxUHekYBqAONcBBR1h9pVWffwBmnqPJuWBLNq7uwlOhhkEwc8EkOY/NSJDecwjnofrd/mXG7Ya01DAxwhulvHljVRtlgpaKBi7r8vGCgaurfXFZDkV8vc00Qj+1ijOnbRf4qKc2KFAU
 93THqt9K
 CVpFbKSs/+RBdpSTcAcnpzkgWCdApaEUfKDM1uLIKBNMF2GOGjCGb0SSvJWrj+gDOg+MDo7vd/+//0b8OptM+be3kAQWF/5NP1EQ2yD8aIrEqQ26tccoKgEdPMtetULGsZ0FduRTRt3TTQO57SpePdunYwbt14Eszc2U4fNvoN3HZeF3dGdq10imlCvwJCPuGitfa0eDPF7lE+YTa7ktsiTqKR8C41uoznqBIZt9Wg8ybUr0vuMXjmwu/B5hGYzYX32f9cnOTw8lnbidJvH3Caj9Q/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 13:27:30 +1000 Alistair Popple <apopple@nvidia.com> wrote:

> Since 5e8eb9aeeda3 ("arm64: mm: always call PTE/PMD ctor in
> __create_pgd_mapping()") page-table allocation on ARM64 always
> calls pagetable_{pte,pmd,pud,p4d}_ctor(). This sets the page_type
> to PGTY_table, increments NR_PAGETABLE and possible allocates a PTL.
> However the matching pagetable_dtor() calls were never added.
> 
> With DEBUG_VM enabled on kernel versions prior to v6.17 without
> 2dfcd1608f3a9 ("mm/page_alloc: let page freeing clear any set page
> type") this leads to the following warning when freeing these pages due
> to page->page_type sharing page->_mapcount:
> 
>   BUG: Bad page state in process ... pfn:284fbb
>   page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x284fbb
>   flags: 0x17fffc000000000(node=0|zone=2|lastcpupid=0x1ffff)
>   page_type: f2(table)
>   page dumped because: nonzero mapcount
>   Call trace:
>    bad_page+0x13c/0x160
>    __free_frozen_pages+0x6cc/0x860
>    ___free_pages+0xf4/0x180
>    free_pages+0x54/0x80
>    free_hotplug_page_range.part.0+0x58/0x90
>    free_empty_tables+0x438/0x500
>    __remove_pgd_mapping.constprop.0+0x60/0xa8
>    arch_remove_memory+0x48/0x80
>    try_remove_memory+0x158/0x1d8
>    offline_and_remove_memory+0x138/0x180
> 
> It can also lead to leaking the ptl allocation if ALLOC_SPLIT_PTLOCKS
> is defined and incorrect NR_PAGETABLE stats. Fix this by calling
> pagetable_dtor() in free_hotplug_pgtable_page() prior to freeing the
> page to undo the effects of calling pagetable_*_ctor().
> 
> Fixes: 5e8eb9aeeda3 ("arm64: mm: always call PTE/PMD ctor in __create_pgd_mapping()")

6.16+, so I assume we want cc:stable here.

>  arch/arm64/mm/mmu.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 8e1d80a7033e..0c24fe650e95 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1422,6 +1422,7 @@ static void free_hotplug_page_range(struct page *page, size_t size,
>  
>  static void free_hotplug_pgtable_page(struct page *page)
>  {
> +	pagetable_dtor(page_ptdesc(page));
>  	free_hotplug_page_range(page, PAGE_SIZE, NULL);
>  }

I'd of course prefer that arm maintainers handle this.  But
5e8eb9aeeda3 came via myself so convention kinda-dictates that I get to
fix it.


