Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AE75C61DD6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 15:33:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAA986B008C; Sat, 29 Aug 2026 11:33:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5B1B6B0092; Sat, 29 Aug 2026 11:33:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6FFB6B0095; Sat, 29 Aug 2026 11:33:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 814406B008C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 11:33:18 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E3CF2A0191
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:33:17 +0000 (UTC)
X-FDA: 85154700834.04.00678FA
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2BA6614000B
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:33:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=odVvcDw8;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788017596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PTXM/L1YMzcWkx0TvEWF9ybpX+LDr+TbOCu+xxZ8gOk=;
	b=19+WsFM/Ugku2Fc/tGWPE7MYjDtIKRUobOd+swvrWuMXa2v8GPG6KcMG+Iae7HPSEEU7X0
	LMfl/rNYio+sT/PYnpkjRtlTriOYC+MMpLoQyQHatX6IQHjMjf7JE/od5QLIPRbXu4hFfl
	ojK8YINsjIrEkAcitfb5gFr8ZWw6loY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=odVvcDw8;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788017596;
	b=STzB2V72jQXdRxh2lfu1TNW4OfPTmpW0m0kxU+ypsXhLWrZJKwkEePZi9IdxFyBJ/tw8wl
	lt0X+k4R0T/TnOacqRs62uapdLHA3hUwxK6FLsfXk6kRNssi6WE4nLG/vssmW3PR6Ww317
	zPMotiXLIu1gTaDBdPsI3GmGoxZ/4Yc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PTXM/L1YMzcWkx0TvEWF9ybpX+LDr+TbOCu+xxZ8gOk=; b=odVvcDw8QIZEc6bpPL/oo1dlAk
	xunFD+gKNfROXB0FaNBVTfXT0mnxucvbWzVOibBNwcLw/6uMmuwczc+ZDUtuvW3bOvMf5lj0f2ZbJ
	s1dk3uUY7yK6qUIsOmbdIifIiAzi/tYESsQjDzEfdmD1bFX5ebk8/X8anuUdjjFwBM1z+MyKBrTaQ
	8C4VUmq1wRJp0cbEcEWxGdOl0glLPCJHoO8W8bRNRAVl1N+ILC6sJgoP3E8Txkt0P11OYyyjvT3Sy
	htxPSApwtUr4hmoYxUe0or4/z37I8KYnsISdwdqz+rxJQ+o/jfun6q7tTf4Rj5GBaGsiHQAfcaeML
	K2z/PjDA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0L3P-0000000GhL8-0SOt;
	Sat, 29 Aug 2026 15:33:11 +0000
Date: Sat, 29 Aug 2026 16:33:10 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, riel@surriel.com,
	harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	syzbot+395b7abe9696862fc188@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm: fix the race on huge alloc failed
Message-ID: <apL7tqn5Jw28S9p_@casper.infradead.org>
References: <20260829100034.423064-1-trintaeoitogc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260829100034.423064-1-trintaeoitogc@gmail.com>
X-Stat-Signature: bifkn8pkmfn3udcun9rs4hkyxrgiyd3z
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2BA6614000B
X-Rspam-User: 
X-HE-Tag: 1788017596-775262
X-HE-Meta: U2FsdGVkX1//GKIFLYtYivZpMYe9gv6U9Z/Ft5LiT/V/RodoHsB7ji/9KFlUxMjeB90OZD+E1DN66aFnAriitP/9mwziLzAoAOqZylnN8uuL3cCj5x3RZ6EpHmjj9jMX0L506PUsyJXDwUwFg/4oK9i7jXE+GUZd0dvr1P13Ag51cLDLDf98MFx9vaa/19AXGktwb2GkyuvIkOELvsz6RSoK1LE5uH5pFRsTAc1ivvxprvaKydkxKHaGA6sJH1pUTmbdsj9GKgFVAJJPnxboKn4Fz4tLms2vY/UFpodlNrQeOUul8e2ADni+gEqfHfia2ZHCEws71GTaEMQv0eNAgRXifz2AquUzKs0UQwldyzciP4AqjaUz833GEpOg/wAgQUGW7X8AyWrXXMXFqD/JzRoSAhtCVNCvrvLopjGu1J4eDAXqAjNJ43lXTdgxel6J+xQgTNcl9nHai0cGmpKZcIiObdc8b27hWhU+RrwCJ9oCk+VtN2E81BqxM/SkUT1yKKsPidhVDY06KxRYOADzSdIj5Yc6fk7C2kjIKFPZD/pOX57h+u4AwKbmjFxuLMloNZMzrDSNsWynI5sTfTsLui4MBRc/kixEKRxCSsjiBLGUZlU9JUsxMG+IxTLg9UAwGchl85h2ZR/aJggkYkul6gPW7JtJXc1SyCx+BHsLHqq2bybW0eyb2XcmW3XWLzbDKULihci4ia2DwxsC1moU0+odEavJvGlNWCCp55pMdPLH7EShM9bicff3znUeF8dJGv66mKSlX6OBle0BZkHGFH2nnqrA72Wu/Qf72Pg6xGIZLJyCqNKmkVihOFTZBJtq3yCwf/kRPDjbRxVPq2I63St3IK8YrnDZ/6QLaeYnk062/aemF4d9Bby/Vfdd+KBb7epdfkP9frFPX71no9NQyBCoDuBEszjXd695/2P2oFrcYGNAfcMZy1qTyy4ITOsayU1lck8JGQokqa5K6wK
 CtVEdsWF
 ukPO4Ie0d47j3lB5G5oEW7anG6c8/Mfc+UehkaH2+gCrHbmiUtK4znUaZs6FbX1pJkDK3o2HPR2wU282MEwmfKFlgYZv1A+7pKaNyX9WDSoGNmGscSnU+znjpHqzW+6U7qtimUHPtoATejPGOUWQrK6Oi4Yl8HwgRIdLovn4asM1M9OyXUBKH4GWB+68eHIl8wmjG4JLTLt8R2DhIVDJ8Nxo50ImTrHGez0COwkfXehVHZXGtMAO1tiXobBhcIODLdGFvSHN+E5Tz2pVN9hcMb/TNVWuICZl7jrhoByxOiw75pSOUisCCuOQJBu1KluEx3UCWNE42RXrvIH4vKpOfQrD7Ig4bEogr+qjoRiu53yn26Fkc+qinex77DnzPCe9ZjlQjETUJEi8R3TBkHU7an0BGBHZazaYKJ0LhWU7at0fAIo0H/4qYX6A0kpU9fAw50tmrXEVt9/917c5aAw3THZo44weuRO9NLQZ2uoFR52sEzd0YiyXrRzwcwwdZsbDsafXvcjTgFAoge7aFXKFUisEespejv6v7D/7Xx8RB7JqFvic=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 29, 2026 at 07:00:34AM -0300, Guilherme Giacomo Simoes wrote:
> The race occurs because the reader (__vmf_anon_prepare()) checks
> `vma->anon->vma` without holding the mmap_lock and withou the
> READ_ONCE() macro. Since the writer (__anon_vma_prepare()) is holding the
> mmap_lock and updating the pointer, it creates a data race as the two
> access are not properly synchronized.
> 
> Use READ_ONCE() on the reader side and WRITE_ONCE() on the writer side
> to tell to compiler treat these memory access carefully and not to
> optimize them leading to inconsistent read.
> 
> Reported-by: syzbot+395b7abe9696862fc188@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=395b7abe9696862fc188
> Fixes: 164b06f238b9 ("mm: call wp_page_copy() under the VMA lock")

what makes you think this is the right commit for fixes?

> Signed-off-by: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
> ---
>  mm/memory.c | 2 +-
>  mm/rmap.c   | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 6b8280cfc1db..33c1fbd30cdd 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3820,7 +3820,7 @@ vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
>  	struct vm_area_struct *vma = vmf->vma;
>  	vm_fault_t ret = 0;
>  
> -	if (likely(vma->anon_vma))
> +	if (likely(READ_ONCE(vma->anon_vma)))
>  		return 0;
>  	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
>  		if (!mmap_read_trylock(vma->vm_mm))
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 1c77d5dc06e9..9d64d776b8c5 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -209,7 +209,7 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
>  	/* page_table_lock to protect against threads */
>  	spin_lock(&mm->page_table_lock);
>  	if (likely(!vma->anon_vma)) {
> -		vma->anon_vma = anon_vma;
> +		WRITE_ONCE(vma->anon_vma, anon_vma);
>  		anon_vma_chain_assign(vma, avc, anon_vma);
>  		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
>  		anon_vma->num_active_vmas++;
> -- 
> 2.52.0
> 
> 

