Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 222FACD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 06:26:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DD216B0092; Thu, 21 May 2026 02:26:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48E0C6B0093; Thu, 21 May 2026 02:26:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A2D96B0095; Thu, 21 May 2026 02:26:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 234E46B0092
	for <linux-mm@kvack.org>; Thu, 21 May 2026 02:26:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CC9A01C0201
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:26:49 +0000 (UTC)
X-FDA: 84790443738.11.1EBC6E2
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id 63903C0008
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:26:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s8NtqF0P;
	spf=pass (imf28.hostedemail.com: domain of william.kucharski@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=william.kucharski@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779344808; a=rsa-sha256;
	cv=none;
	b=gN5C/8V7+h2hCgkQ0/1B5rx+iVR+oex/9/Qee9wNwusnFe6VX1CAxT6cCJbHGbyKNs72Qz
	eOnlys8ICaWKa+CeYCXT1QjNkxkDsHcPJyXi5hETwZf/Z+EJDbf7ihSpy3mvoPyVOv58s2
	Be1HdGsmgwbd5bcr/z0JqMrIK9YWN0A=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s8NtqF0P;
	spf=pass (imf28.hostedemail.com: domain of william.kucharski@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=william.kucharski@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779344808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oS6qoV4jANTDW9AOUtNU1MNWiMdTldRllFEpVOk7i9s=;
	b=NFOf5y2GwttavfBRQV8FTH+Y5R2DoTwjJpJtyVEhNKg5uzd/jhp3ESSwjFnDh2HID9KRsa
	QQCZ9lu0zAvZZmlcKdbUWeCpeKvRQ4nL0sGv2lpPf/psWQfDIQXWctUucioYoW62cUt7bM
	J0jp/TQxK8ZjsYKOVlwj7BOJsrLrcUo=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779344802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oS6qoV4jANTDW9AOUtNU1MNWiMdTldRllFEpVOk7i9s=;
	b=s8NtqF0PBL7b51MNkeA1wcD4sJCODzQ9ri+YnQwMb3IUepcKApYFxi+kXigmDQNhmkunsB
	UpcKoRu9PiOW80veNLIy+L2F0A1VAofpPpvcnHkk804eReywvx71aHZQ9udbmUWgT6g49p
	rEYa+pLddcRpL9sZnhRjGu1wAGD5WE8=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v3] mm: do not install PMD mappings when handling a COW
 fault
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: William Kucharski <william.kucharski@linux.dev>
In-Reply-To: <20260520151624.78370-1-yizhang089@gmail.com>
Date: Thu, 21 May 2026 00:26:27 -0600
Cc: linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 david@redhat.com,
 karol.wachowski@linux.intel.com,
 yi.zhang@huawei.com,
 yi.zhang@huaweicloud.com,
 liuyongqiang13@huawei.com,
 wangkefeng.wang@huawei.com,
 yangerkun@huawei.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <17356DF5-A72E-46B8-BD54-4CCFB6775BB1@linux.dev>
References: <20260520151624.78370-1-yizhang089@gmail.com>
To: yizhang089@gmail.com
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 63903C0008
X-Rspamd-Server: rspam03
X-Stat-Signature: im63wrm376x78iawpg4zjmxoeqxbwj3q
X-HE-Tag: 1779344806-255275
X-HE-Meta: U2FsdGVkX18z6QlkOyF0+foeeKiKSHvI22qKUPgzU/wEqeuL8sIiiBAz6vG/a/C5GfzppHXnboQpJWNcEgW21TzzWPZbAHAJp37dN6oz2ZV8c/gIidMgE+4ctQpJOPJxp95bu3pcb3huRM3kz0LNO9JpVZSKhrv3H/35Ce4vekHpuQ2XnZPPxD/yZtoBM4e1ZGmofIbDzQ1wXRG41RzFoeMth0LTQmqZeae5bmGicTUM2IjGrmahzwPKfjwKhGyKvGus8C3Y6AsyYWme4qmdKsRTqF3inbqSXPG6yX2sGROeFIukJilbI7pWj47g+qaFEKLY+w5xLVCx49Ros8HMwWLbfiNh7MpesXD98OJOEHTYXfpeJ2tShpyLg5sGwiV4tlA3Z4+KdfdjeT1TxjL8XNJF0e/Aj3qz4FMeSZSgLaA7hlaF67yXTmy8JNPfoLrQlr4sMvqORWuqb4KBCPJBDpriqnO7Q9GFlOOQ2wOItM/XMV856ZY/75zfB/zukm22BBMOds6tjiUwbVotkL3LoIYL6jR9W5yzsN7UTr2Cs1+fwSKJsDIjFMz3P+hg581vfS5Cq14CR9gmJtQcOlOfwpJZhDeZookM91rWrAIo2MMa05QxjqZg1iDuQW89YzTrB9zeTUOYX+IoOMo5M+Dx+9HAxfumiyH4g7kbmsF8hTsctYWez6BOxGv0V9kl0yuvz+sqv+0cgzRG5UKZllGVRzHkXmAyrQLfsagIgEQEPMIeJRmSeYN5e3nOG4BNpv2T1RBWQqcLjjUAZ4xfYDLhL+tZT002tjU6T91LCYuollb70+YY03oR9C+8nAyvNzbmoKrBXDo9S3vFKJSSqcbaLJNxQFe8e3LudzKvdzfgLEB+NlQcCxZSaD0lRG/zqxv1Rqm6keC/HvI6DiTsMJW2uTaPDFYiXuwMwRyoE9bHqUwUAqLVrg7PEcxj2/rjvutSUqEape0VmOXjDOTiNYn
 Bj7yKPTI
 0MlGd8RTusw4SNi1cIUf2MmhNA01t4qFnR2q9DuqbIvMS8ZfcyyUI4DUQ0e5I1qmav44FvAx6ZURegK+xoS/XK0uwk++gAJk9yoDzBXXfjulF8DgdD5G0d35aiRegBMR6ftSm/NdyroYAKTC+UcSa4j+QNeIzz2wuHw/1mfupZbNcsjbpg8Oj3XSH/OIW3+yaNtWvrRMm/X2DKFWsBxMiZj1cDLzrE/HkL/R8PHZin1AW6pvkjQ9l5txAuADOR2ykO58X8008RBYRcXLDIZsKrDU9qsB8ptFa4yugjtHZPT4+E1SHsLrNgVH4CnEHGg08mMdh9aoyKHKEpBXzWT4SdyHxCVCnE5n8gQQC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you, that's what I was hoping to see.

Reviewed-by: William Kucharski <william.kucharski@linux.dev>


> On May 20, 2026, at 09:16, yizhang089@gmail.com wrote:
>=20
> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> When pinning a page with FOLL_LONGTERM in a CoW VMA and a PMD-aligned
> (2MB on x86) large folio follow_page_mask() failed to obtain a valid
> anonymous page, resulting in an infinite loop issue. The specific
> triggering process is as follows:
>=20
> 1. User call mmap with a 2MB size in MAP_PRIVATE mode for a file that
>   has a 2MB large folio installed in the page cache.
>=20
>   addr =3D mmap(NULL, 2*1024*1024, PROT_READ, MAP_PRIVATE, file_fd, =
0);
>=20
> 2. The kernel driver pass this mapped address to pin_user_pages_fast()
>   in FOLL_LONGTERM mode.
>=20
>   pin_user_pages_fast(addr, 512, FOLL_LONGTERM, pages);
>=20
>  ->  pin_user_pages_fast()
>  |   gup_fast_fallback()
>  |    __gup_longterm_locked()
>  |     __get_user_pages_locked()
>  |      __get_user_pages()
>  |       follow_page_mask()
>  |        follow_p4d_mask()
>  |         follow_pud_mask()
>  |          follow_pmd_mask() //pmd_leaf(pmdval) is true because the
>  |                            //huge PMD is installed. This is normal
>  |                            //in the first round, but it shouldn't
>  |                            //happen in the second round.
>  |           follow_huge_pmd() //require an anonymous page
>  |            return -EMLINK;
>  |   faultin_page()
>  |    handle_mm_fault()
>  |     wp_huge_pmd() //remove PMD and fall back to PTE
>  |     handle_pte_fault()
>  |      do_pte_missing()
>  |       do_fault()
>  |        do_read_fault() //FAULT_FLAG_WRITE is not set
>  |         finish_fault()
>  |          do_set_pmd() //install a huge PMD again, this is wrong!!!
>  |      do_wp_page() //create private anonymous pages
>  <-    goto retry;
>=20
> Due to an incorrectly large PMD set in do_read_fault(),
> follow_pmd_mask() always returns -EMLINK, causing an infinite loop.
>=20
> David pointed out that we can preallocate a page table and remap the =
PMD
> to be mapped by a PTE table in wp_huge_pmd() in the future. But now we
> can avoid this issue by not installing PMD mappings when handling a =
COW
> and unshare fault in do_set_pmd().
>=20
> Fixes: a7f226604170 ("mm/gup: trigger FAULT_FLAG_UNSHARE when =
R/O-pinning a possibly shared anonymous page")
> Reported-by: Karol Wachowski <karol.wachowski@linux.intel.com>
> Closes: =
https://lore.kernel.org/linux-ext4/844e5cd4-462e-4b88-b3b5-816465a3b7e3@li=
nux.intel.com/
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> ---
> v2->v3:
> - Update comments to clarify why we shouldn't install PMD mappings
>   while doing CoW.
>=20
> mm/memory.c | 11 +++++++++++
> 1 file changed, 11 insertions(+)
>=20
> diff --git a/mm/memory.c b/mm/memory.c
> index ea6568571131..b1aed4f08224 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5520,6 +5520,17 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, =
struct folio *folio, struct page *pa
> if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
> return ret;
>=20
> + /*
> + * We're about to trigger a write or unshare fault on a CoW
> + * mapping, breaking the shared folio into private anonymous
> + * copies at PTE granularity.  A PMD mapping would bind an
> + * entire PMD-sized range to the shared folio, defeating CoW.
> + * Fall back to direct PTE mapping.
> + */
> + if (is_cow_mapping(vma->vm_flags) &&
> +    (vmf->flags & (FAULT_FLAG_WRITE | FAULT_FLAG_UNSHARE)))
> + return ret;
> +
> if (!is_pmd_order(folio_order(folio)))
> return ret;
> page =3D &folio->page;
> --=20
> 2.52.0
>=20


