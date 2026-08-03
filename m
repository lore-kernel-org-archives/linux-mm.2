Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 863A2C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:54:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93C166B00D7; Mon,  3 Aug 2026 09:54:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 913F16B00DB; Mon,  3 Aug 2026 09:54:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82B1A6B00DC; Mon,  3 Aug 2026 09:54:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5CE8A6B00D7
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:54:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 52531C06CB
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:27:24 +0000 (UTC)
X-FDA: 85059732408.30.6A08D01
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7F2F0C000B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:27:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BrOWJ/T3";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785756442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YSw9uK8dJUH+TEOnxzh6YVpEYxvD00f6y/AeO3+B2bY=;
	b=Ec9zAJaZgW993Wgud1qDkCubFsdyoaKp3kMQcBBZ0GUH9w5PV98VoLRDd2BBbg6JaEX1+b
	1hNd7db6Xk2gGg4Y2lR65LXOmzXr1OKr83Iujpy2hUjiaUGiMSLcaRqPashXR6YxGStn7p
	fVkjh0I1G717hmHZ5ZUtHe5R85VUMK0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BrOWJ/T3";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785756442;
	b=RUYXpyRX5lVov+aCvEt6hzfX84Eh/YD8fTZ8JG1lTUGbYm9QkKaXaPPpa+ijQmSjFTLlEj
	yKvWdur9YeAPXD5x5IB4XGEE2g6ak11/s1ept25aGxc7PK2t/gmUPXurEzyDI2okp5eijc
	3T4Rk7rxRjQzcly7ayEobfDn9jkWEt0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 754D044F61;
	Mon,  3 Aug 2026 11:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2CB1F000E9;
	Mon,  3 Aug 2026 11:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785756441;
	bh=YSw9uK8dJUH+TEOnxzh6YVpEYxvD00f6y/AeO3+B2bY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BrOWJ/T3RZiSPYgsiuttXsyJmDns/XBJdG5Ezs0djh/inyu3iPhd4Q1b3mTHBBMc5
	 NIXKwWXd4Tin/w6AJcPCoy5wDc7/ncbMzVCTe4HjbCjTM1ZneLr387ymLfCAcv8zaZ
	 ehA6Jm8+NEtL1lUSbPVd5Vi9Klfj4D2x4uKSdia0JWCsH2TwBsIti7Mt45ifq2Yf8K
	 FG5lkt6UaziiuuM3kkese1CWMncs+AbUJ4gWEXuNTp4K0Rl2BbxZnyVqd6H6IImH02
	 hQzgQw4qdzvWIFstsJHmLRQhGrMfbD7u4TofoGgR1ldLJrrrZ4f8FFAwHijJDZyoad
	 ujEyyYQvqbhwg==
Message-ID: <0d9f3040-825d-49af-9d07-1e7945dd3e9d@kernel.org>
Date: Mon, 3 Aug 2026 13:27:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/15] mm: introduce and use linear_folio_page_index()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-8-e8ecfefea812@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260729-b4-scalable-cow-virt-pgoff-v3-8-e8ecfefea812@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F2F0C000B
X-Rspamd-Server: rspam01
X-Stat-Signature: 545a39dchiyfx5h3wmsomyeweququiwa
X-HE-Tag: 1785756442-909077
X-HE-Meta: U2FsdGVkX1+afHrGQBlq02rS8WMMZVaUufc6bwwWL8Yov4/R0DY4mGCqMgR92VrRzKFCfTZgYMUe84wDOpotSa62BI6E9cuNQ3gOiRMsVhD8mNvDYZVDKc9SKrNKGRpOXagckeeNGwVAiiQc6a7XBcrCxSh5qpacAfJbZmwwtmlvo9g77ze6MQWRhk6vwgfu0c3+OYaedctkhQnFhdU55H88a+k4/tqQODtIdyEwSis7u2mnpHemw7KXFGNZb4NCAMLZcZLPtYTLZkm4IpTRc2IH3PKQRlhgYxmkuzxqrs4wkSvETzZyqwZWyDpXTzn8P3R7AMom91TVo/z9SWLeecq2R+tQwf7YLw+1v72lxf+60LN3Irh78ooxTFoiuBeAmrWMvw0+zwlayPEASGLMQcSufNIL52mOYuPBeRqE7jTWTSNmbKwrT5818+k5H14pc6qkdCJeadXyv90liYxBooAkTG3VvCm2aekDPH2nJg5+t2TurBsoZSo3BinE1lTFjjMq5JEeEtiMfW2ruF1w/r5HlpCDFhQ3kZoH0YHdYK8Sl7Mkgny8KIYkpjBusTMtfsZdBGVOb9eLbebihVqryqMJkGbYsZeCH0d+Vv8RmQ6i7jrpjf49by8gE0AJKK1lQp1uP8Bf3WdmLnI2Gu5t30kCTyNvEglATxUaEL/3X66t9CS+FK95wtdJoPPIv6yIvGudmnqeMhGgcA3i4Y6ZL3vWuV5esaRrXO4nmb2p09y7qcJx3e6hg4+CHKyU03bcZ7oMce+GkyASTimno+7hCBTu1ktzTLdeFbQMmDo+afTbF0YaOd2ImTaRWS8mE85q3LBoXmpFK2szGl2ud9u2J018kQ53KxnVxx6nzhnmPlFb7jyhJhFcCSa5QELBTfmP22fnN6jACwug4a3AGa0LhDQ4dCpj5j5yD6D1DTht/wbeL3TgMYxF3OOpMrJo73tCvjnfxm32VLtWG6L6tuN
 4Ctz8tg8
 PSJYECA+8KVSXrqpovp+udDieEGkkJ/rtqZ8e7o5+gi3yPLsYYi9mVYuamTdhuyhv5aJnZK+ZYwkFKOvfNMFSGm4huyVPVwNQxm8RXLoCtEC1j8GrFuvNuBea8So7Y1gz0Io1P/4Jitob9ChtCLQLRRtnbTgi1AdLmZOpsse+iQsW/+BVNdx0Xftxw26cIszGqhQus0+vKsbE5MkyEg2ls6x508SrGcmN7fxV1IVUZjQnLd41n/QmhNZuZmp56qiPN8Gq2rO5axiIRvjTP7Evbov9jUsZH31x1bh5PY1jiFFfvchASxU/9Rm2wnfkT3mxfUJIbCptHhM+HTS+DnSZjSh2EaG3y06zoWm3gQCp8AbbHCyb2i95A4zMxayw83USAf9t277olVEhsCSLnRRudO1ZQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 18:48, Lorenzo Stoakes (ARM) wrote:
> This function is, for now, a placeholder; it will be used in future to
> determine whether to use the anonymous page index or not, based on whether
> the folio is anonymous or not.
> 
> Currently it simply wraps linear_page_index(), so this does not change
> behaviour.
> 
> We update callers that will, once the change is introduced to track
> anonymous folios by anonymous page offset if MAP_PRIVATE file-backed, need
> to determine which index to use based on folio type.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  include/linux/pagemap.h | 18 ++++++++++++++++++
>  mm/huge_memory.c        |  3 ++-
>  mm/migrate.c            |  6 ++++--
>  mm/userfaultfd.c        |  6 ++++--
>  4 files changed, 28 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 259177544b03..6eb8d811ba4c 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -1143,6 +1143,24 @@ static inline pgoff_t linear_anon_page_index(const struct vm_area_struct *vma,
>  	return pgoff;
>  }
>  
> +/**
> + * linear_folio_page_index() - Determine the absolute page offset of
> + * @address within @vma from @folio.
> + * @folio: The folio whose linear page index is sought.
> + * @vma: The VMA in which @address resides.
> + * @address: The address whose absolute page offset is required.
> + *
> + * For compatibility, currently identical to linear_page_index().
> + *
> + * Returns: The absolute page offset of @address within @vma.
> + */
> +static inline pgoff_t linear_folio_page_index(const struct folio *folio,
> +					      const struct vm_area_struct *vma,
> +					      const unsigned long address)
> +{
> +	return linear_page_index(vma, address);
> +}


I found this to be rather confusing, given that we now have a "folio" helper that
receives a folio and a "page" helper that doesn't receive a page ...

I guess the problem is the "page" in "linear_page_index", as it
reminds of legacy page->index.


I wonder if it would be better to have a linear_folio_index() and
force that address points at the start of the folio.

Looking below, this is exactly what we want for all except one case:


>  		/* pgoff is invalid for ksm pages, but they are never large */
> -		if (folio_test_large(folio) && !folio_test_hugetlb(folio))
> -			idx = linear_page_index(vma, pvmw.address) - pvmw.pgoff;
> +		if (folio_test_large(folio) && !folio_test_hugetlb(folio)) {
> +			idx += linear_folio_page_index(folio, vma, pvmw.address);
> +			idx -= pvmw.pgoff;
> +		}
>  		new = folio_page(folio, idx);

I think we could avoid this index work entirely by using the pfn, which is much
clearer to me, and similar to how we handle it during other rmap operations.

diff --git a/mm/migrate.c b/mm/migrate.c
index 222c8c15f782f..686351d353203 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -362,17 +362,12 @@ static bool remove_migration_pte(struct folio *folio,
                struct page *new;
                unsigned long idx = 0;

-               /* pgoff is invalid for ksm pages, but they are never large */
-               if (folio_test_large(folio) && !folio_test_hugetlb(folio))
-                       idx = linear_page_index(vma, pvmw.address) - pvmw.pgoff;
-               new = folio_page(folio, idx);
-
 #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
                /* PMD-mapped THP migration entry */
                if (!pvmw.pte) {
                        VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
                                        !folio_test_pmd_mappable(folio), folio);
-                       remove_migration_pmd(&pvmw, new);
+                       remove_migration_pmd(&pvmw, folio_page(folio, idx));
                        continue;
                }
 #endif
@@ -385,10 +380,14 @@ static bool remove_migration_pte(struct folio *folio,
                    try_to_map_unused_to_zeropage(&pvmw, folio, old_pte, idx))
                        continue;

+               entry = softleaf_from_pte(old_pte);
+               if (folio_test_large(folio) && !folio_test_hugetlb(folio))
+                       idx = softleaf_to_pfn(entry) - folio_pfn(rmap_walk_arg->folio);
+               new = folio_page(folio, idx);
+
                folio_get(folio);
                pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));

-               entry = softleaf_from_pte(old_pte);
                if (!softleaf_is_migration_young(entry))
                        pte = pte_mkold(pte);
                if (folio_test_dirty(folio) && softleaf_is_migration_dirty(entr


remove_migration_pmd() will work for now. Later it should just receive the folio
and do the same thing through softleaf_from_pmd() -> softleaf_to_pfn().

-- 
Cheers,

David

