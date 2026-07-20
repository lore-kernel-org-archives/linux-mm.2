Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DEA2C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:00:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23FD26B0095; Mon, 20 Jul 2026 08:00:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 217FA6B0098; Mon, 20 Jul 2026 08:00:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 107486B0096; Mon, 20 Jul 2026 08:00:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1D9A6B0093
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:00:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 679E880150
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:00:16 +0000 (UTC)
X-FDA: 85009012032.08.E3AF98B
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id 80C2418000A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:00:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Zz/2JB1+";
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784548814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JfG1ZHcv+rjvAHjyJjxi2sRN0IfFFjf4AjdeqTop9C4=;
	b=yDraBoe9HACWNrwvEdFSx6ibs/1Up9G34qkYCDRL0VsoziXbAmvetFwGkX15DJ8pynloqD
	W13s4Tc51jnp8RzLLmBJYTe6mCPMWqVSDgnuTCubHlqRmti/sZZlpoG+FiVflahZM1xARk
	wZ2amvD3gl5pa72B1j3Hu+9sYzI6u0w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Zz/2JB1+";
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784548814;
	b=j+F+UVwRebKRqEqk4myMq2PVLhqhjC/NFAgWFIRWedoHHwgOg7JDqtDQF7i7ArqR4Bl7fM
	cVg7p12mlnc+SVvvwtq0tdO2VXZIbG8pvLUsZzmX1MiNWuMxfMvx1mhpTlQ4mMUXlEmDzB
	q3ZV8mxDTnJf0sWbOv5Ey4duANbXskI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784548811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JfG1ZHcv+rjvAHjyJjxi2sRN0IfFFjf4AjdeqTop9C4=;
	b=Zz/2JB1+Mjxt6Dns0uYzFOLTpBQzIGJuYWgxQWef6tQ/Sif17tZoTMbnsT31ipbxFQqIC1
	by46BgHzKdI49KEy4T6VOcJ9sDDWluNNus+x4SW729AZrSg7ZqMe59h+dIAuyEei/KIDgi
	jnbZK4lJjvBXGxcY5kNPMkJxf7hndIU=
From: Usama Arif <usama.arif@linux.dev>
To: Rik van Riel <riel@surriel.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	kernel-team@meta.com,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v3 3/6] mm: rename get_user_page_vma_remote() to get_user_page_lookup_vma()
Date: Mon, 20 Jul 2026 05:00:01 -0700
Message-ID: <20260720120002.299101-1-usama.arif@linux.dev>
In-Reply-To: <20260717170036.743149-4-riel@surriel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 80C2418000A
X-Rspam-User: 
X-Stat-Signature: a8g7xgdfbb3435m8n6az1d7c33m84e69
X-Rspamd-Server: rspam04
X-HE-Tag: 1784548814-748510
X-HE-Meta: U2FsdGVkX184sEHzTlV6PchZbqTZS0BGm6Q9WURhHOaBFeGl7Wfk7lP2VZt4uLMNny0a1GdD9nJnnJGoCipqG9XeIIq8DIyukr4UK5qx4VT4AlevF24P1anAeV8FoFbw0zMQOEenBNC2nXE0oWbwjXZuc8NVwaDScpdWNlDMAa/zV9SjYmInZGk+hd+4orrab7HJqYVE2cqrOF+screX0FCSMCCpfH/iLeujV82QD7RL4vKtmJX7Y4DmLeWuSkezOI3vY0SiQsoglEs7FqujTwlg3s8MGqdOc9T3T3TvWcW3MEPVkIpjEB88uhf273PHvYQfrfXgmko2XFWusCguAxI0PTJeokbqH27OOJPkQtulSIr8XLcG7JbON+aSwnCKEtm9kJ7NBN1/dimVyjub1HgSUwYd2/yYI9ZKC6DO5Y9Q9a8uXr26/ZfvkLdu6qc0zgI+q92oF/iu9oqhK1WL8pOzv/Z7bEDwMD6cZcZxhRpDF1uFh9dNFDtEaCzfCiCr+VYXW/WCxoALXJbYWiTkcGPFTDTkCemGj8+5rq97NWZbihSDX58KDLKvh8NJcIdef6vTAv0XOC0eW3hQDBYtCI3EWcuFjOoFNp8EGwm7KkN6L3GAcc+eHuT+d9FyguZm1Ddg9TTaZHGfp1gPUViiBQgz5U7KnR66h1I8JOI3OiHroLw8miyvO1lWKJpM4xG8zJ+7ii3EnyzWUbrXOmZ/I0pejNzbcYQXewYbruPx75roLQvCXA7l/GuQyvfgiSRyX8+9YOWsrsVGGyjeP/YaLI/75GtDSsDUxcsVCXZ2Z2sMxmPWyodtHonS5O75nARESnhMECjKTNL2crXfRg8Njd9mihkPyFL3DjhGJi/S5MXGUl7ohVw6Kgdnu1pr4kPeNm2BPF5EVPI7QqXa4ymaBEUfbxC3TQhEndRcF2HiQ6QcjKk3MmT7WHjniEcLE+cgpWfUJl4ViyWwkpZbXiO
 xiZdHWqS
 QAQA8XHFXLx6Cw5ch2wE0JzMhnS3tYwpTjtg/o3F5wHRw8mkW6zKTumecg0bZFAjibu2ZrWjYB4W97VuJVjq5OHVFJIJv72ULTNEj9aAxSdzrs+iEgk3nJuWthfaNErtNquXrcUi/RSm84oX2Emi477WKHqYwijtR0WnYsTHCOG35I02ViiAh6YWUgpo/xxXuPIGGOJlKQLq9iR4EKuqydzLFuFAXl3+vnW7OGKK7ofszlu9hGkxRFWI6Bw1DFUA8owPT9Uet0EJz4oeXN2iPSqtqNRAGkgc17NpMKVtuDPRAow+4x0Y9/N0WKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Jul 2026 13:00:33 -0400 Rik van Riel <riel@surriel.com> wrote:

> get_user_page_vma_remote() faults in the page at @addr in a remote mm and
> also looks up the VMA that covers it, handing both back to the caller.
> 
> This cleans up the name space for adding a get_user_page_vma() variant

nit: s/name space/namespace/

> where the caller already has the vma.
> 
> Assisted-by: Claude:claude-opus-4.8
> Signed-off-by: Rik van Riel <riel@surriel.com>
> ---
>  arch/arm64/kernel/mte.c   | 2 +-
>  arch/x86/kernel/uprobes.c | 2 +-
>  include/linux/mm.h        | 2 +-
>  mm/memory.c               | 4 ++--
>  mm/rmap.c                 | 2 +-
>  5 files changed, 6 insertions(+), 6 deletions(-)
> 


I think good to add no functional change intended in the patch.

Acked-by: Usama Arif <usama.arif@linux.dev>


> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
> index 1a9aad6ef22a..7a6ecc3d9294 100644
> --- a/arch/arm64/kernel/mte.c
> +++ b/arch/arm64/kernel/mte.c
> @@ -459,7 +459,7 @@ static int __access_remote_tags(struct mm_struct *mm, unsigned long addr,
>  		struct vm_area_struct *vma;
>  		unsigned long tags, offset;
>  		void *maddr;
> -		struct page *page = get_user_page_vma_remote(mm, addr,
> +		struct page *page = get_user_page_lookup_vma(mm, addr,
>  							     gup_flags, &vma);
>  		struct folio *folio;
>  
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index 3af979fb41d3..329efac0cfb3 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -1036,7 +1036,7 @@ static int copy_from_vaddr(struct mm_struct *mm, unsigned long vaddr, void *dst,
>  	struct vm_area_struct *vma;
>  	struct page *page;
>  
> -	page = get_user_page_vma_remote(mm, vaddr, gup_flags, &vma);
> +	page = get_user_page_lookup_vma(mm, vaddr, gup_flags, &vma);
>  	if (IS_ERR(page))
>  		return PTR_ERR(page);
>  	uprobe_copy_from_page(page, vaddr, dst, len);
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 485df9c2dbdd..24ead14b4790 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3238,7 +3238,7 @@ long pin_user_pages_remote(struct mm_struct *mm,
>  /*
>   * Retrieves a single page alongside its VMA. Does not support FOLL_NOWAIT.
>   */
> -static inline struct page *get_user_page_vma_remote(struct mm_struct *mm,
> +static inline struct page *get_user_page_lookup_vma(struct mm_struct *mm,
>  						    unsigned long addr,
>  						    int gup_flags,
>  						    struct vm_area_struct **vmap)
> diff --git a/mm/memory.c b/mm/memory.c
> index ff338c2abe92..3b86eeaf084f 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7039,7 +7039,7 @@ static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
>  		void *maddr;
>  		struct folio *folio;
>  		struct vm_area_struct *vma = NULL;
> -		struct page *page = get_user_page_vma_remote(mm, addr,
> +		struct page *page = get_user_page_lookup_vma(mm, addr,
>  							     gup_flags, &vma);
>  
>  		if (IS_ERR(page)) {
> @@ -7167,7 +7167,7 @@ static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
>  		struct page *page;
>  		struct vm_area_struct *vma = NULL;
>  
> -		page = get_user_page_vma_remote(mm, addr, gup_flags, &vma);
> +		page = get_user_page_lookup_vma(mm, addr, gup_flags, &vma);
>  		if (IS_ERR(page)) {
>  			/*
>  			 * Treat as a total failure for now until we decide how
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 1c77d5dc06e9..b36f2e219b8f 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2838,7 +2838,7 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
>  	 * (non-device-exclusive) PTE and issue a MMU_NOTIFY_EXCLUSIVE.
>  	 */
>  retry:
> -	page = get_user_page_vma_remote(mm, addr,
> +	page = get_user_page_lookup_vma(mm, addr,
>  					FOLL_GET | FOLL_WRITE | FOLL_SPLIT_PMD,
>  					&vma);
>  	if (IS_ERR(page))
> -- 
> 2.53.0-Meta
> 
> 

