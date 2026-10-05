Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FAF0CA5FF1
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 02:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8C3E6B0088; Sun,  4 Oct 2026 22:37:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3CDE6B008C; Sun,  4 Oct 2026 22:37:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A52C76B0092; Sun,  4 Oct 2026 22:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 76C756B0088
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 22:37:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D581F1A0C4C
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 02:37:04 +0000 (UTC)
X-FDA: 85287010368.07.71ADB7A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id A306F100005
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 02:37:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rnGKV3nE;
	spf=pass (imf14.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791167823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TfIimseJqSA5uPJd5LFM1PZWNBa4p+aGlT3kqNAV9WQ=;
	b=mW78/WhaTW2xojIm7I5u2jo2Om4P5V4waNoXurNxQh6wK54VX9hsxzev09qouVPjgTu5Yf
	9chYC5rVmqHHPfoUsFB3ezEmSjAPJ3fIO0A808ok+SmgdSShR6w3buyHoctsPlGUaOQoMs
	xq1ZULK+ekmxEldPwKg/vl6AXZb3t3o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rnGKV3nE;
	spf=pass (imf14.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791167823;
	b=5eot8xbrDPjvLlFClSiLZK6aBSLHsP9ybda/kDMeIea7xw2RME574N6ogzJ/JebXMGmXX+
	ggiU8vQosiz9Jz72vfuMuuKKoGEUYdL03ADsC+YQnR9mWX/O/YqRXOQjcWiABPkjATLzj3
	ZdXs5WEv/4vNIskkMbkI4IgUgZHU+s8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F37D81595;
	Sun,  4 Oct 2026 19:36:57 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9D30B3F763;
	Sun,  4 Oct 2026 19:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791167821; bh=vl5s19mW9JNXxaeLZH+yT4sg+eJntMKRYJiYiz2MomI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rnGKV3nEwlK1X7k2zdzTLzFY3mWapTTQwNrztTtOi3ummT0/lyYsdvlaUhu45qvFY
	 xpwyQmnpwBWKkCvOdt+6ByczUIMmQ23umDaPucYD6k+OSjQ5ZsFEXF3+XcahbKsM9i
	 XYobLAf2SI5KCsWqouvorXCBMdU284WPfwjFxhIc=
Date: Mon, 5 Oct 2026 08:06:57 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Jose A . Perez de Azpillaga" <azpijr@gmail.com>, 
	"Liam R. Howlett" <liam@infradead.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v2 1/3] mm/memory: remove unused
 vmf_insert_mixed_mkwrite()
Message-ID: <d7bksa3fzrynovdlajlvlnlwzgkyw433dyp7zkvme562hrxap6@xfifh46fce5n>
References: <20261002160535.661399-1-ekffu200098@gmail.com>
 <20261002160535.661399-2-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002160535.661399-2-ekffu200098@gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A306F100005
X-Rspam-User: 
X-Stat-Signature: qjny4naajktagnbpb7esnwiyigoua4op
X-HE-Tag: 1791167822-3525
X-HE-Meta: U2FsdGVkX1/CJku2zmGSMYJ8yBtGIldh5VMcgAAhrPos0xgjDFmbh/7qGv9EJEQbYLqNWvvlOcS48byiZTHKdIM6bvCZaWAW9tFrCzdBmD7fFTKdEq9O2ghxqWvWTV6ZU7Rn/JTcl2CbPFqOiDrC1lQvpiBLawT0W+MkSXOqI8phd63LInKpQsYWCNzyDRbtXssbJWN+UYyqbJqm7ECrcaEiGry4g6PaWDDFhIVfmCl+BwC9oNo509/7DAw5XlE4TDHwxEbYPYW4kmxnkbd1bqgWM/0+pO3GMaBK+n6PUVFYb6ZOflEl7ulyfcQjjHfntCZxHSNtrUXEJFrrjdEkfjWSiK46skLtcsERMcoUv5llIIiBAFDT3JV3vYR+OK9rGnQwCutA0fsXPt/BW5G4frQAiSIy0NEjazhNocAJx2PtQPEuf5sA8dvLoDwAbsFWwSOF2fkY/Zbpz0wiS/qmxYkf6hQuOXgnBrj++aSSUFHK6udOSMXjY1UhHstj2tk/CXvYuGi5oz7RhoUiwXxSlZGafS5QSZBb2hFpXEah4OsXOAJ+1Q3UvdhUuTrHxVFS5+TAbjxqIe4fnijKwflDN1PtaD2mNeVqsHqlqrur6LnCh6+VaOPAsIuujJCGMC6fYiSfpTGu6y3bCOZkAli1BQufvBJn/ZOrvrXVYE5v+9/HgEIE0K4B6q7Y9wJXxouXDAg/wZoAVNRnKrQiPLTMfphUIAFUk0VVlK69nVL2gTr4tfssqDJjp2BB0Bgfy3OJVO0CdLt3wqYrVhVu77lt1E9a8niYSWvE6VjPX5CJ8/p9jKPoyW0SydBa9JBIf+UnZSD/lYNpDTLj1vIsIfCL5n/bcGhhrk2O3eEe1a5GYB2MSEtLWF8PXxWf7+hsaGfznD3+m8YrF+5WqkAPqXPTv69Kh2g+xcWgMTnvrgoYM4kh+pTWQvvwKaOA9r/KBhdL2EBII/vtEN2VmY1SYDZ
 QbLrNo9I
 H+QTppiuDMNGUrNtGLzx9vlJiFee9ltfWrzlkHo/IgLliM/S9GZAirKxS+kS+KtJyHtBlitNUK4AaQt9d82AGfO3ceDxinRCWdordLCJXFjrb1jGc+sts4RqiM17/GGx1WIEAKqACwIBVJB8Bzeq2R7eADlKHJ9Stdej5IqCsUStkDYXUawjxihGA1lIhbqKXv5ZgDZZLonA0x4g3P8q0WzNImCzJ02JX7DQYrMuODXuZ9scoD/noZqagGuYoN75F5wcB09pwx1hTiZRS+FaOquuTi0ldcsNxoELgtHLiirUxUs4X/rIR4YIelW7sOBKGXLwXj4+Q5L6MWIpE/n2FwCkkaJblQa320mS4sITNDBL5w8LP+3ZX6J5ohk/xXH1BtjnQtUTsYOPSHwPtcNQQGxhULA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 03, 2026 at 01:05:32AM +0900, Sang-Heon Jeon wrote:
> Since commit 38607c62b34b ("fs/dax: properly refcount fs dax pages"),
> vmf_insert_mixed_mkwrite() has no callers.
> 
> So remove the function and its declaration.
> 
> The comment above the function describes the -EBUSY handling in
> __vm_insert_mixed(). Move it above that check.
> 
> No functional change.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  include/linux/mm.h |  2 --
>  mm/memory.c        | 16 +++++-----------
>  2 files changed, 5 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index c038d06825c3..2ac734efd4ec 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -5008,8 +5008,6 @@ vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
>  			unsigned long pfn, pgprot_t pgprot);
>  vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
>  			unsigned long pfn);
> -vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
> -		unsigned long addr, unsigned long pfn);
>  int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len);
>  
>  static inline vm_fault_t vmf_insert_page(struct vm_area_struct *vma,
> diff --git a/mm/memory.c b/mm/memory.c
> index 330cde31bf8b..4b2e4be28031 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3052,6 +3052,11 @@ static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
>  
>  	if (err == -ENOMEM)
>  		return VM_FAULT_OOM;
> +	/*
> +	 *  If the insertion of PTE failed because someone else already added a
> +	 *  different entry in the mean time, we treat that as success as we assume
> +	 *  the same entry was actually inserted.
> +	 */
>  	if (err < 0 && err != -EBUSY)
>  		return VM_FAULT_SIGBUS;
>  
> @@ -3085,17 +3090,6 @@ vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
>  }
>  EXPORT_SYMBOL(vmf_insert_mixed);
>  
> -/*
> - *  If the insertion of PTE failed because someone else already added a
> - *  different entry in the mean time, we treat that as success as we assume
> - *  the same entry was actually inserted.
> - */
> -vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
> -		unsigned long addr, unsigned long pfn)
> -{
> -	return __vm_insert_mixed(vma, addr, pfn, true);
> -}
> -
>  /*
>   * maps a range of physical memory into the requested pages. the old
>   * mappings are removed. any references to nonexistent pages results
> -- 
> 2.43.0
> 

