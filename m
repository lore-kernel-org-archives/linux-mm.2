Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 443B0FEDA1A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 20:01:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AACBC6B0088; Tue, 17 Mar 2026 16:01:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A848B6B008A; Tue, 17 Mar 2026 16:01:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C1486B008C; Tue, 17 Mar 2026 16:01:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 894A66B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:01:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 23458586C8
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 20:01:58 +0000 (UTC)
X-FDA: 84556625916.24.3822E3C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6911114000B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 20:01:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V5UHlDDd;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773777716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=omOn50hFQVgGuDUOT+sQS6pXDMZI7KxJvFigK9pOa34=;
	b=cgkl0g8djWkBARXwpYwjOoEOn1Utowf8H8atTI1hUBLRK3RZnqtFPdSGkCtEdDxwXL/KSx
	sMVD2f6IyGRhq3QBeUKpCG0tzUbJpG2bzJ1McqyJPUTJv++VmAqQ9C9ULRKGhwMS1dMC1n
	sw61LKE9Aq9KpfMrAsefEbzXCZPYydc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773777716; a=rsa-sha256;
	cv=none;
	b=p/UBUXl7yQV6QRZbcdLmtuyjaDSmm8qyUQxvFUkPyXgi/koFtyCZ2wigAkkHYntP1RURwj
	UVusRHuvVzaq1Mjn1dS1w5FSidGy1Q0hA3+VuaI5IvhgBaXYWIYHQa5Pr/5aw5uB7h9u4M
	Elyor2Ck4ud+IQxciBWMVmrWkuG1V6g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V5UHlDDd;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BC5E417D2;
	Tue, 17 Mar 2026 20:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF764C4CEF7;
	Tue, 17 Mar 2026 20:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773777715;
	bh=NKnAXN7C8VudbOPbvnyk9jdQz3ADlfDA1m5Ubw1DyQk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V5UHlDDdZvItrfJBx8rarotr20Slalpfj+PAz+/HmNH+lo3ayJGu+6GPWXGSb9Fci
	 VyDGV+HIQX0znchJZnHBZI7aeMp1srzVtffP5/g52HIOczTQGY117+Oxs/3ocduRe/
	 huFmXW/0BWz+CwfE6AesM46XoPgg/chA39BP3d8ZM7FpHEH80g4BNG1/Yq98+jbHZu
	 3R3bf5IFqX6PXo7mKSff+aQZ97TaFJEkPZupwv+Dla+qgEx9/d/aZjGSOymU0EluoX
	 dXZuKCujkUwDOMGq8XpK+m9u+sYs9dzVquLQUi1Yj77qHBlhK3ahdDKBuU9YE8gXy5
	 mpDiP+NWEDPhw==
Date: Tue, 17 Mar 2026 20:01:53 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Oscar Salvador <osalvador@suse.de>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 13/14] mm/sparse: move __section_mark_present() to
 internal.h
Message-ID: <4839f771-1b54-4858-85f3-096aa1888189@lucifer.local>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-14-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317165652.99114-14-david@kernel.org>
X-Rspam-User: 
X-Stat-Signature: s8ogrwqa71a8nck9oafh5msfgjauzghh
X-Rspamd-Queue-Id: 6911114000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1773777716-553895
X-HE-Meta: U2FsdGVkX1/NGK//EgVuOC/Pavg0O1+NrraK8D1GPxemz+7NZZDvbc+u8GMYpwiG4V5saaxgM0NZpc4lOircz5Qj1Za8pe7mho+QiF3O7Ofk8DpwyqYaBzev1NRVT9aGT1gbeiDzRPuT1q5eEJstDZF06qEs2kgk2pGC6nhGsnj2uzi4thSZBh8nm75krU8DfeLmN6Jy8604Js1WXZQwPjbz7SRUuTO9XlJZwStjuj8sj7nj00HoJacygDQz7CJkTPIuiH2vdw3GU0SIXwONxr0fM03h+E+V9Eih5XII67HohQwKcg4Rpl+KOWZKKEaB+KZ5F0CJQoCG9pwvunPPCuWKVw37fSdo4LN/uBeZXfWpG7t/kL7wuuF9kGBf0eS6Pmb0It7AHsFGVtVHKcft/wMKB9bOaw1jhaTXUxkJ49Zaf890/1zTXLTubYoTremHG4kXUz2nAEk/cDMHP+MhwW4aHQuiNyP/ewlNVIob77JltLvQ8kszJeUYkej/DXqb5K8h0ceJfwwd2RH9LFY2NEw2xzrdhmMhAyQkyzRaCphM2igOwglj2bOx94aX69rFnweyvdBzgqUk5imyw9VadY4IiZTRPCB4aRI3QFshYyUKY+Wk75/DJlgaUMpXGA5O8nwORouho5Lj/WJeC0t26vY73vnSwcLd0J8MqHhjowPPYk8ESPFdR2JLozOxbKr0CMCmKHPXQGhdAgJEhyRGtGiKXV6rlb2/fs3JKB/XHw/hRPHDq9BX3NgktuO4ngQW115N1c+ZG1lFi6jgMNW9dQCsmXnRRsj7z3BZccahtpNT9rgzrXb85ypHsiyU6ia9UFm9RlkZrunQ7faxhZwbx4tMtiPUQ1U5+Q3JW/KKCogQ+6IrfWhDp6octi6Y++aaVNEQyWKd+/Bnm6McqiY4+UyRekyitlxM/7XL9yCQXFjrBqbjxEnqk5snSqNEkjHcDQaRMDRjL1S9XzpJ8Ev
 6TEn9HYo
 yya/ThCPAhPQi0o/nMN2wNyNYgd3IZFUtwFSDt//AAd1z5ROsr5uhR1xqQWdU0xwlKC/cT2m0XwdN8qRnVpENRs/S6TkroRL6QAfu0OyFI+IAwzhzZ4sW/sNlR9C7Bjal44esQ8dfoTK/eqBTPndtc6cMxDcKpegQTk8hNu3OUtb0oK59yJmzUlNcG4rfyDEwg83hIDTHxPhVipWuT/nC7BlkZvytI2BClWkYkmwz4A5HDhep94CICUK7m3fCUYogJxIE7xpHpaymg8VxkXZV16q1MBHuB8iP24NQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 05:56:51PM +0100, David Hildenbrand (Arm) wrote:
> Let's prepare for moving memory hotplug handling from sparse.c to
> sparse-vmemmap.c by moving __section_mark_present() to internal.h.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Let's prepare for me finishing reviewing the series with:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/internal.h | 9 +++++++++
>  mm/sparse.c   | 8 --------
>  2 files changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index bcf4df97b185..835a6f00134e 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -987,6 +987,15 @@ static inline void sparse_init_one_section(struct mem_section *ms,
>  	ms->section_mem_map |= SECTION_HAS_MEM_MAP | flags;
>  	ms->usage = usage;
>  }
> +
> +static inline void __section_mark_present(struct mem_section *ms,
> +		unsigned long section_nr)
> +{
> +	if (section_nr > __highest_present_section_nr)
> +		__highest_present_section_nr = section_nr;
> +
> +	ms->section_mem_map |= SECTION_MARKED_PRESENT;
> +}
>  #else
>  static inline void sparse_init(void) {}
>  #endif /* CONFIG_SPARSEMEM */
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 6f5f340301a3..bf620f3fe05d 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -161,14 +161,6 @@ static void __meminit mminit_validate_memmodel_limits(unsigned long *start_pfn,
>   * those loops early.
>   */
>  unsigned long __highest_present_section_nr;
> -static void __section_mark_present(struct mem_section *ms,
> -		unsigned long section_nr)
> -{
> -	if (section_nr > __highest_present_section_nr)
> -		__highest_present_section_nr = section_nr;
> -
> -	ms->section_mem_map |= SECTION_MARKED_PRESENT;
> -}
>
>  static inline unsigned long first_present_section_nr(void)
>  {
> --
> 2.43.0
>

