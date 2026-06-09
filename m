Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 403E9CD8CB9
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 784406B0088; Tue,  9 Jun 2026 10:26:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70DD96B008A; Tue,  9 Jun 2026 10:26:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D50B6B0096; Tue,  9 Jun 2026 10:26:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 485706B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:26:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D999E1405BE
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:26:53 +0000 (UTC)
X-FDA: 84860600706.09.5E606D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 50790180009
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:26:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D5AHoeDv;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781015212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UKRI414IfLHNNeYwOL/nAAWOqGtR7JlYa1a+TkI80SU=;
	b=k5mzck/4Ib0gUZrd7QV5K9QFcUPLbPQllQz1pL9Ir6qYyXHWj2nPFvFhMediXwkjt3lHcp
	VBq91nFAapk8bKJUSXeJK29g0M0ply5YdAut/7+ys8XNCCU3E9dyeDsEMZP1ekzbfUUxuU
	ToBQJl2bpF+2j/naK3y5krBLqtlespE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D5AHoeDv;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781015212;
	b=rcTb8hKbjyCH6XjC0peNyy4m+KWoma7bZkFBNIML8RboCQtxsegZ57vugGoc6VB9/W5Heh
	ILH1u73cub0BURYSr8PZYATAY39iJ7sIyV1IG9+JU+BkQZxalTyA6qNCTA/kT6QhMfmSXD
	uGbaziv+1dr+pADueNiA6+A4fdCGVOg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AE43E600AB;
	Tue,  9 Jun 2026 14:26:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C911F00893;
	Tue,  9 Jun 2026 14:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781015211;
	bh=UKRI414IfLHNNeYwOL/nAAWOqGtR7JlYa1a+TkI80SU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D5AHoeDvOTSuS+c9WN66Zv2jy+bHsL1T2USkxRt494TKRa7W9h8il6Gknwx18UBCH
	 3PXZi4ikQQP75Xw1WS26zhyiVdg0j0JR3tTyRg4prn9e9qRoDGsaXesw2Lph3W4Ro6
	 h5y9x+Rd0tJehXvqLtKs6MzWNWsr5uTdNWRKIatNgMr/CjVLgWC/osSO9W9LxkBlTs
	 mzeJ+gGGUO3PIHLLP9jVj5AzwmycmXeCqJY0flLZgiT4gAS3rjQoIfPW1wOQcT6Pul
	 d4hM0kCWNtY3Vb8CvXLzeP//3npyp5k+Nw/ibfFikW+hAvPLjpSraeaUhwD6HkyHAB
	 upA13YlcG1NDw==
Date: Tue, 9 Jun 2026 15:26:43 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Usama Arif <usamaarif642@gmail.com>, Yu Zhao <yuzhao@google.com>, aarcange@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>
Subject: Re: [PATCH mm-unstable v1 2/3] mm/migrate.c: Prevent folio splitting
 from interacting with KSM
Message-ID: <aigigBa4LY3mtSL7@lucifer>
References: <20260609114619.144416-1-npache@redhat.com>
 <20260609114619.144416-3-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609114619.144416-3-npache@redhat.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 50790180009
X-Stat-Signature: dn8nbarx13xjmww4gysjtadb7j5qnmau
X-Rspam-User: 
X-HE-Tag: 1781015212-954139
X-HE-Meta: U2FsdGVkX18hHHksa2KcomVcGxRiuKR290POOmpk2YKwWklj0r2oN6m9WG/hDeS6K5epbX89h+NSr6uEsbF73WmSkEXNsVQuMGu4CY/B7hqT/pBCVUbXHLCzBhtRCHV4VP/YIb57J/ZEKI92jnu0sxmm/CpSvDCUphwF2lY+o3ghnWe9TX/cM/Zg4O2+jo6otT11rHu6g7p1wZaklwoFVsJ/nZxLDgY7PrpnQMD33gJXP+ekEElHEIlFRt0z5lZevYeqma54wwpoKW/Jaj4WL+H/IW7D+ebk0NOLSiAda8OIIeFcXIDciDXGexxSe818SW7y3Mtdh9MfGAJywKOxfUjnmkkTEjh2VEsQ+75qzOJ6n8gJKIRoolV8YoGr1ym8ImD+Yaz2pi8pNmRhuMOQ61wmyTC7KFyWFp5Vf178U/VoCpCLSk9XW95uPTpQ8WmsxLbnFL2o/N8W1FOY6KHYMvDtB+9PE7yYGhuSYs8K31b6qz0LErnHyjPYl6/mQDOS+POGMQ3TPN0iwbyIjZQTytYsjPsQ/VuajpWtCZLvTrQ4RuE8Em8N/uZR/VXnpuhZBbj8oq70ViqD+LCpKEjiowGMld3Ay2RFfj7LDoNOuHJIXUzOklpcja0dXiubhL9zHqkpfQ3gkybpJ3IkL2VWZdUF3FQ653X+jCichxo6EUN10KyH11ybUr6t5UFgOYZ9ukhAg8sL0FUWyWwdefqZCoLSV+q1gRljr++tEubjGIcWqPdiz0dpsVoFSry527Zyf2oUYOx14tMiiIz61adignsseTATo+uqEDmMh7OiCLcvEbqglYvIJw+QTtRIXEQ4xAEUAERDSHGEmGu4UUXhRrjc9yECbul9q4qsEOvdHas2UV9o/YYE54Cwn4WHAMf3w7NV3tgdO6Px0GL+76KA0GDvXEgG/5nJAwVqRG9JR+Dg2H4qi8fWDxQbuUGuDeH6r7euYIoRAes69AdqSRj
 ubhNNLhs
 5fczuAOHBH5AuNyrt7NAVqWLtfIraNBMuzGI0c+8I7PoMF1Dlfais4yueaLqNUWgLj3DqlD7ZCPYXiJHEdMOpdpVwqz1IPKoEgwqHbis+Cdv/a9fypFnhitmBoFDols56wf7Rgcuh4G/wSkpyZ1LkjMy6c79YIkweCd9lg0wz2FXe+cQW696Dgsb4+ce4SixjOGxKIXwDtDjPkXKvMcBqoP8WhUUyQxn8JK2WCU3pB+vpo29ZFF6fPyWE02GO1asm/vHLpDFlVUuH8poX9UPf5RXxI0w/hM2Mjk6uQHMweSGwPz9cxLlEGjxhNBAAQW3B7L8/RHLrti9Vd+Mo7Z2uHD8xTrijao/nZcMm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 05:46:14AM -0600, Nico Pache wrote:
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
> Fix this by restricting TTU_USE_SHARED_ZEROPAGE being set in the case that
> KSM is running and the VMA has VM_MERGEABLE.
>
> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/migrate.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index d9b23909d716..f410f972fc5e 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -304,6 +304,15 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
>  	if (PageCompound(page) || PageHWPoison(page))
>  		return false;
>
> +	/*
> +	 * Let KSM handle the zero-filled page deduplication according to its
> +	 * own rate limit (pages_to_scan) and policy (use_zero_pages). Without
> +	 * this, a KSM-triggered THP split would remap all zero-filled subpages
> +	 * to the shared zeropage as a side effect.
> +	 */
> +	if (ksm_is_running() && (pvmw->vma->vm_flags & VM_MERGEABLE))

Please use the new VMA flag API.

This would be vma_test(pvmw->vma, VMA_MERGEABLE_BIT).

> +		return false;
> +
>  	VM_BUG_ON_PAGE(!PageAnon(page), page);
>  	VM_BUG_ON_PAGE(!PageLocked(page), page);
>  	VM_BUG_ON_PAGE(pte_present(old_pte), page);
> --
> 2.54.0
>

Thanks, Lorenzo

