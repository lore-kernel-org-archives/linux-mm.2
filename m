Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B791606A335
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 10:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WFrWTNwp
Received: by kanga.kvack.org (Postfix)
	id 61B4D6B05B2; Wed, 18 Nov 2026 05:05:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F3BC6B05B3; Wed, 18 Nov 2026 05:05:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 509E26B05B4; Wed, 18 Nov 2026 05:05:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A67D6B05B2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:05:20 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BA3B11606C9
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:05:19 +0000 (UTC)
X-FDA: 85447807158.17.AA69A04
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1078280005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:05:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WFrWTNwp;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794996318;
	b=Kt4l59uxqrapcG37GreNd0x7gZDODMQRmJC28fbButWre/z7VfIM7v4ISKlVw/Q7Wg7wvP
	YOiVGSrMvoILcn+E7fu+qXuVytjLxh4KNYey3o/thFnvEqb2xbCOmToxo8qgRXBR1DZeXN
	82skhqo09+aeseh76/6wVSkdJ8wLylc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WFrWTNwp;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794996318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d1hpg454e2jIOnA+4nAG8EtFurLO1JUftQj9aOKMgHE=;
	b=1fZaWqH8r/Lvqxn6astV00fGXqyoYDTxTKctEMgRQaEP0G0vVMaHdVIe3R3Cv89n99jHHO
	pT5y+UanU3VvJJx/7Z/7abgERKvrKVzl0ZV/PSsWDAflZYtm6y+viHpQgXuF+hUEF5iqa1
	a3IpOr0GZ89TdNOqtpo4dLhJsOad31g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 84857620B5;
	Wed, 18 Nov 2026 10:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906781F00931;
	Wed, 18 Nov 2026 10:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794996317;
	bh=d1hpg454e2jIOnA+4nAG8EtFurLO1JUftQj9aOKMgHE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WFrWTNwpAM/lmrOunHYIJMuKBmpUWUG3jcpAcdazHqcrznkEMle3KdulXgiO4Z9Eg
	 vIQqCFQK1eTVOEvR/Jg6tpfIrOV7t1x8dkqFLOVjQW44zEETKGyttUlETMvqh4Ly28
	 hDgsqPitK4LN6guJrHI/2A8hbsqA/bQCknZxMEFIUXkMQAyyimY1WzX3EcXJ1QOD7T
	 matAulLtMRFxtsWpL3GJJrE03yoZghzeFkGavS0nVWG14danipunAzWhl9dbYGyMlu
	 MXEpvv9adC05luzHpHLJ97SqzcZLi8M1/uT4cC7vcq/xNY+NuQfxPsI5TPKbZJsqcX
	 yZrSBS1iM5o/w==
Message-ID: <eeb8f13f-4535-4fc8-92ee-5f36bcd5abbc@kernel.org>
Date: Wed, 18 Nov 2026 11:05:09 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm/memory: don't upgrade non-present PTEs in
 insert_page_into_pte_locked()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Jingyi Sun <1045704958@qq.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>, Peter Xu <peterx@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, nvdimm@lists.linux.dev
References: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
 <20261117-uffd-dax-async-wp-fix-v1-3-c9a30f27f452@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261117-uffd-dax-async-wp-fix-v1-3-c9a30f27f452@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1078280005
X-Stat-Signature: e4yydhkwek4d1c33p45d4ecpdxtzr9ts
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794996317-147370
X-HE-Meta: U2FsdGVkX1+PCw0kUY9ATQZ5LG6e29QpjTbuxN+RN5Bvm4TzVgfvCr6D2CAza28OXui9fQeTWFiMGM7HKM6YrU37gl/AV0Pt0dhWX3ujr+bFNTogCW6aqAdAXCc8JSgv7Zh7Zo+Qgrrqm0H9161zR1LrUg3BcC1raoQEJcdDC3rpfIzs9Qd4bE/WFWKONw5TGdQAgclLFklHN/34liL9/KfrS7ezTyBTUPRSY7yaGgZmbmyYgcLe7hdP0E156rpfti1dHoFOex49yup5vmv2dxPOQHy9euSF5LzWsS0kuZ7G1RwlkkmmoR6qD3q6qeuGD1pl5Qs5FjaWv+gr2jOFSe4oCm+rtlJqFVXGKSTa3OYiKBAshW8PJVDbqsza+v4hVN+YrBwFTg1AXvckIWGtx1ooJboSXb5Ae1QXSi9i5MlFyh8ve6PjtVucM5zJui7/9VxOYAAtSGsBToLIcMe38sGavWCKT5I3ivYKPtDq/nLe8sStspToAThQ0mobkmsS+kZPj4ZyQ2d5GFvXZdRRCSl4Q6r1XZSYORN9KJSBmZ/q9u7yzlV1Ls7fL7+OGajSHxjxBR4w7Y80CBmWQ575u7t5tOh9+D2WelzRrhEElZIvuWyC/iqYX6Uv9BF6/Fa6kDGmJzJSWuuiSjKm7t4927tz/+bx0PiwamFdTOGXjcliiLv5VlAFYUDannJF7p5YVCWPPRlqAR2ANgmlCxH7mt34Q4sHFO3v98oWdFawmUI2ixiCAyVBji8ghdRolhynuXouAzenRH2tUaUwvapOjWq9nmxvCh27ALavEiodc/TGd7HeJdVX6Fk+1i6pEa/d9J7SzU1Xn6pZU57vM1II+CxRt37ONJ3TCnvrXrxEZqUxKysCrqDLWAwNk6A0a7NJsX/nmPiwt0rmGIyGhaf1t1RjrM4TV2WSBVe4MVpvbdAt3ViSYxLqtqnqbkegMTOq4l8q166Q3bcMtgGpJeb
 9pUZA6c2
 rDxOMDw/Yn/TGC3L2jhNRcpSMqKF8Gm1Ua66bMrUIU4N9TSqDwZbFKQ5TDFDPHkpqDznSwvQ/aZbSqMdKWlOXqjG1OHHdo4QxGBbKIgD/h8hM2BkSGSe4YhO/yKTvODSr3QLOO5IFyeNtRMVzENkzn9P44+P3ESnPbHC7GTLEMNEeTJrlyyYQNwzB+hGtspDgbPbtUYBRt7W9ts4X0gwUKk3jTkbLwNwaZXcoBxSV0k8JOHsOhGWv5g30DHFp24FhD5OSN9+NFXalNi3IFTmB0okMLU0tyoXxsPnoeo8FO1ugpzbBu3cHhtcoB1U2ciGRdMazU4a8vJRDC/U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 16:58, Mike Rapoport (Microsoft) wrote:
> On a write fault insert_page_into_pte_locked() assumes that a non-empty PTE
> maps a page, compares its PFN with the page being inserted and upgrades
> the PTE to writable.
> 
> Since guard regions are allowed in file-backed mappings,
> MADV_GUARD_INSTALL can put a guard marker into a PTE of a DAX mapping
> after the DAX fault handler found that PTE empty and before it inserts
> the page.
> 
> vmf_insert_page_mkwrite() then extracts a PFN from the marker, hits the
> WARN_ON_ONCE() and fails the fault with SIGBUS instead of the SIGSEGV
> expected on access to a guard region:
> 
>   WARNING: mm/memory.c:2489 at insert_page_into_pte_locked+0x47e/0x490, CPU#3: guard-race/157
>   RIP: 0010:insert_page_into_pte_locked+0x47e/0x490
>   Call Trace:
>    <TASK>
>    insert_page+0x6f/0xc0
>    vmf_insert_page_mkwrite+0x31/0x60
>    dax_fault_iter+0x3be/0x5f0
>    dax_iomap_pte_fault+0x1b8/0x390
>    ext4_dax_huge_fault+0x1a4/0x2f0
>    __do_fault+0x34/0xc0
>    do_fault+0x179/0x610
>    __handle_mm_fault+0x8ca/0x1250
>    handle_mm_fault+0xb4/0x290
>    do_user_addr_fault+0x15f/0x730
>    exc_page_fault+0x83/0x190
>    asm_exc_page_fault+0x26/0x30
> 
> Return -EBUSY for non-present PTEs on write faults like it's done for read
> faults, so that the fault is retried and handle_pte_marker() deals with
> the marker.
> 
> Fixes: f807123d578d ("mm: allow guard regions in file-backed and read-only mappings")
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  mm/memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 66ad58429967..a80925c61706 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2474,7 +2474,7 @@ static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
>  		return 0;
>  	}
>  
> -	if (!mkwrite)
> +	if (!mkwrite || !pte_present(pteval))
>  		return -EBUSY;
>  
>  	/*
> 

Should we CC stable?

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

I'll pick this up.

-- 
Cheers,

David

