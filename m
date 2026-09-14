Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC74AC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 17:28:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A813A6B0092; Mon, 14 Sep 2026 13:28:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A31CC6B0093; Mon, 14 Sep 2026 13:28:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 920D76B0095; Mon, 14 Sep 2026 13:28:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66F046B0092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:28:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D2E631401FE
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:28:24 +0000 (UTC)
X-FDA: 85213051728.27.4114D9D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 08886100003
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:28:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iqVO95GG;
	spf=pass (imf05.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789406903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TPz2NgQD4wYwpoMlETyAHGpiKwnwmssFQ3zvMqGt37o=;
	b=bxRHP5w3UcDDXkSRiK/xC66jRmv2WWPr3CLMlSeUB92reQsSUNU6l/9MisHPAiHbEZePiF
	yjJ8qUo2ZwiL1deFGiDLleYTERpvM5hvNknEpq++OGMH/X/SO1XLGKRHUOWfvH8grq/dfR
	pfABpo31p660oiQlJLYwkzgi4kvUxSE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iqVO95GG;
	spf=pass (imf05.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789406903;
	b=UfuT/L1qTZCZtuER/lVTVqURO7ZHWH67m3PlGdiaCLDNENP5r5z5enKIQSx6c1zrhlw4Ry
	ipUGqSDWKE6LoDqac3JUBjq8mRhEqr8x1DlMVcKVVTgyuAgRc/7uTFykf+JiODCrdJ7wAG
	BfRPBUTmuBVCu0zETafTGY0LB+SVpTA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F2CB1570;
	Mon, 14 Sep 2026 10:28:18 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 104EA3F882;
	Mon, 14 Sep 2026 10:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789406901; bh=iWelEh5WTFtiuhjvHXqEJk6UgYv+6dS3Y9MFxXTD4gw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iqVO95GG/lAzGR+I07S9/5tlA29acYiZ/DZ5aBXzX2+E7SEpYUgg7Vv4VlcTWkfGH
	 Gl3JT9xnFYPbTnJ+hGrmwfzrrCGuR+NhASmSfHwBa84Z+UrTtvm6msFhiSGiAhB8yX
	 DmomfBtMw/bRPNL9c7SCisQUO9WKy6Nsc5ZIHJnM=
Date: Mon, 14 Sep 2026 18:28:15 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Shivam Kalra <shivamkalra98@zohomail.in>,
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v5 09/17] mm/huge_memory: rename remap_page() to
 remap_anon_folio()
Message-ID: <aqgur6-4y2tpEGh6@e129823.arm.com>
References: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
 <20260915-swap-thp-cleanup-v5-9-39878b37dfb0@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915-swap-thp-cleanup-v5-9-39878b37dfb0@tencent.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 08886100003
X-Stat-Signature: br95ehugmq7edeyzqpi7whcxes9hxif1
X-Rspam-User: 
X-HE-Tag: 1789406902-793405
X-HE-Meta: U2FsdGVkX194dY+h9GnaEp1gIQCKwBqgorRxFtNQRC/H+zKY6HsBKr+oq7rEkM3nZgsWtSIiq3h2BwgLQaplFt6VkWxxx7zWghN0AT/d2HKafjFvoFUyamaC5NLIYa+KHuax0M5pJcm9S8FJLCfxMuqV0orBpT/6nech+Q2scKekWepuPb3QBEccCUtIZIMP0ATPizZ7jjIzBt1fYPpyMul8tPKFv+ewytTY5Ipf5VtO4tsFDKYdNJqBR5BKJ5ztZpDvUZ8B6jmByBA3mbjJS847pnNFVDjd+vDI6Am6wos2iwdwB5p33aklmDpVlMbPyXC2vWDuxn7phyHpMvTCAsWDID3QPKu1/4M0OpAdZaNiRBxagofoIx/ZXBlgrpe3mywHyCDrh/x7Wd8FPV8f8N8OPyotEMSKqrOk6OYDUD9L9jOI7Dh0XSfLgjdRB9O62h7r3UKhOGeMSmxRJXEg6Qda7z+dN+Q8h6XRpRFEFoQsAUvX7988cxymQXv5wuxXe9Ige1vYMvtuu2hoDLrFdjzj1CcPjDdKbvjGwvfHRM+L8qcGPnS/KO1v/y3sQAF36jIizAhGDCabT5MLETZarYf7gK3+aHziovBEXRCNC6CH9xqdmbh2KwRTA5DZhudzwqrP9mOVLP9u04R8qNDwoWY+xspuzpjUZ3g35WEPgPUgZjK9J8y29g5M0jgBISh7M70LOeFaymXpvTGXbizmYAN3hDlTVexn7ymTHhe72A7yFdNC04OGE4TsIoPqawzhMgXaSOhZ8GzVXxEyadtjkXcxW66jtWXJZ2usw9CPIDst5KQGZehOn5TFGYB8qRCBRcG5j86u6h0N26j4XWEJQRZGI1sztM93Q1NtahfKVEPQJ2RDgXwV9xR01uLLgzTINrljB9a0KYaLoLOtRfhoiToMkgY6iMSrXp0Q3DZ7SsQG31v+5aknCSyvQpe+mrhnb4F8ukkYh8IjLfWPQSC
 +WiD09x0
 PeNWnbqdoTve+uIt+YCahqvaqdQEr1uty1XnDcn//aXZWHEUxBGFdZNYUQSFYWiDyuIWfzpBgVDt1jYgmtqIHQq+yScYQjSW3c7u9M+DIk+rV0dSmzNMAS4J9F+aUsn2b1kUW8BR+XvkHC/Jn45+Fu6k7+HuWK4VIuRqM9xXhPybzTuZFBc5p99cmtwaL6owCiz3ePgHeJQT+XsP7PuKFYXcOG/O1J2Rx703FsV31/ZmpA2CGW17tt+5f7+d6KAMs68tr8ZZKQuiIn48DIsRKmg210YNlZ1XDgyyVtWiFn9eF0DDhBukYKPwXS438+bznWdYyYXpY9xa3Ax5g988XFP/x4Zw2DwRC0dIOoiQoMh72C6jjfe5wrqfhhcdOj28bZMROWESFR6Z3JGOW+8Ho7CpHpZMB4q80fXg1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

LGTM.

Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>

> From: Kairui Song <kasong@tencent.com>
> 
> remap_page() now only has one caller, __folio_freeze_split_anon(),
> and is only ever called for anon folios: unmap_folio() currently
> leaves file folios unmapped after the split, so they need no
> remapping.
> 
> Rename it to remap_anon_folio() to make that explicit, and add a
> VM_WARN_ON_FOLIO() documenting it.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1749905ade6a..77bf68c9b9af 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3552,7 +3552,7 @@ static void unmap_folio(struct folio *folio)
>  	/*
>  	 * Anon pages need migration entries to preserve them, but file
>  	 * pages can simply be left unmapped, then faulted back on demand.
> -	 * If that is ever changed (perhaps for mlock), update remap_page().
> +	 * If that is ever changed (perhaps for mlock), update remap_anon_folio().
>  	 */
>  	if (folio_test_anon(folio))
>  		try_to_migrate(folio, ttu_flags);
> @@ -3637,10 +3637,17 @@ bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
>  	return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
>  }
>  
> -static void remap_page(struct folio *folio, unsigned long nr, int flags)
> +static void remap_anon_folio(struct folio *folio, unsigned long nr, int flags)
>  {
>  	int i = 0;
>  
> +	/*
> +	 * unmap_folio() installs migration entries only for anon folios,
> +	 * so currently only anon folios need to be remapped. File folios
> +	 * stay unmapped after the split and are faulted back on demand.
> +	 */
> +	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
> +
>  	for (;;) {
>  		remove_migration_ptes(folio, folio, TTU_RMAP_LOCKED | flags);
>  		i += folio_nr_pages(folio);
> @@ -3724,7 +3731,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>  		 *
>  		 * Note that for mapped sub-pages of an anonymous THP,
>  		 * PG_anon_exclusive has been cleared in unmap_folio() and is stored in
> -		 * the migration entry instead from where remap_page() will restore it.
> +		 * the migration entry instead from where remap_anon_folio() will restore it.
>  		 * We can still have PG_anon_exclusive set on effectively unmapped and
>  		 * unreferenced sub-pages of an anonymous THP: we can simply drop
>  		 * PG_anon_exclusive (-> PG_mappedtodisk) for these here.
> @@ -4084,7 +4091,7 @@ static int __folio_freeze_split_anon(struct folio *folio,
>  	if (need_remap) {
>  		if (!ret && !folio_is_device_private(folio))
>  			ttu_flags = TTU_USE_SHARED_ZEROPAGE;
> -		remap_page(folio, 1 << old_order, ttu_flags);
> +		remap_anon_folio(folio, 1 << old_order, ttu_flags);
>  	}
>  
>  	return ret;
> @@ -4206,7 +4213,7 @@ static int __folio_freeze_split_file(struct folio *folio,
>  fail:
>  	/*
>  	 * If we want to use try_to_migrate() on file in unmap_folio,
> -	 * remember to add remap_page() and adapt it.
> +	 * remember to add remap_anon_folio() and adapt it.
>  	 */
>  	xas_unlock_irq(xas);
>  	if (nr_shmem_dropped)
> 
> -- 
> 2.55.0
> 
> 

-- 
Sincerely,
Yeoreum Yun

