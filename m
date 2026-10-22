Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88628606A326
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 08:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W8OWakWc
Received: by kanga.kvack.org (Postfix)
	id A970D6B08CB; Thu, 22 Oct 2026 04:07:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A47DD6B08CC; Thu, 22 Oct 2026 04:07:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 935EC6B08CD; Thu, 22 Oct 2026 04:07:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 717296B08CB
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 04:07:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DE9568074A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:07:19 +0000 (UTC)
X-FDA: 85349532198.26.6F938B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 265AA40008
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:07:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W8OWakWc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792656438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IK3vlu7wIXXSLKBylI9CXBQS+y3D6BVh2hkB8AeGdBU=;
	b=gT3CKSyRtlY7YsSgzDRVJ9m4qtfwL4qDMPLXjQeKB3uIBJYet57E3l+QaVcYnBOYhBd/Kv
	iVgOzX98U8MhNaNV/co2/qIch0c7jSOljYcb1pq9yB5gun78UQd3cSyJ3n/sp0VDW0yP4m
	tl+eERJATUUyHdztIEh1agtWoqUaTis=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W8OWakWc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792656438;
	b=2XBnHVlyyQ1uyp1EyYWFzWDgWIE1jMsn+CTN49/YmI5SV4jdFqom2EiFYk9yd6JwX/aXN0
	y6Xe8DYbH6xXo7E4w0r3pm29UgSKlsoQu2gTtiqEk+V5vUDTMK4r5eyIRwb9HNdfLu3HKm
	tVHqCOul+CxHFXRXjxdVcyAVK+M6adc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 01594414E6;
	Thu, 22 Oct 2026 08:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4890C1F000C2;
	Thu, 22 Oct 2026 08:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792656436;
	bh=IK3vlu7wIXXSLKBylI9CXBQS+y3D6BVh2hkB8AeGdBU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W8OWakWcVu6p39n/i/pswI3AEMxPh3lVJFQRbJlRBkHWiGvyfX0zXNVk2SA4fB53g
	 JHz4wNXmab5xisFmoVJgNFDkp+pI303W5So1d0OPUiMMHVQJWz8xuIK2aEajORCG++
	 reNbr9AqxfCgM8sCBsaPNlNAtM/M7qg+ZuOxPYKUvOrJRA2PnNbcCNNvkN2coaJAdq
	 FP7utVEamab8mGO32rjrrQwCCeXrVEPqqsXIZBlr2QOEY3hDSZgnzuU+phWNMEaN5b
	 82XCF3BVPJKHXalMygYHHKD5QJ+Hda5VHcVnDI/8kyvAqN7UYo8dXeht0md63zKLNg
	 Y4d6s9egOW1PA==
Date: Thu, 22 Oct 2026 09:07:09 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Peter Xu <peterx@redhat.com>, 
	Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org, 
	=?utf-8?B?TG/Dr2M=?= Molinari <loic.molinari@collabora.com>, Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v4 1/4] mm/rmap: duplicate a PMD mapping as one in
 folio_dup_file_rmap_pmd()
Message-ID: <atnEFyGRYGGf9shA@gremlin>
References: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-0-66f00b7a564c@virtuozzo.com>
 <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-1-66f00b7a564c@virtuozzo.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-1-66f00b7a564c@virtuozzo.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 265AA40008
X-Stat-Signature: t69ak6m6tm1iugm33srwt163aqfgioxi
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792656437-486122
X-HE-Meta: U2FsdGVkX18nXrCjbZ/YtIQ7rFHTpu8JbpRNj6UsHO0NdCUnM4jh9mlXKAlYoxYK68Jz1UDq/j4mxhFKaY/Vr4sEuJ6bZn0oFj6hrjLOX7+b3iAqzBejaSu6z/CabU64GrYlYv+rH+aX7dyuLT+RAw/jqBQNmSLCz0RAs3sTfuPwG2hLw+oWGdrMTM+2mBCQZ7LAG20DUvo7tAMC5gh3O20N0PHHaYAzk5oZaZ8px9M9cIFvqNyknDGVfzkd9aWQb4YgedK1uKRuh+X2aq1sY22HRF1YVWOWiLDR6j0gi6/x4jDyJjT4KuxaroAtq+15Hy2KsQ0P2hRKCG3Lqs0vypfLLlxXouvn59ZD0/WU6T+1sHIRBD9Z8vvFZpdW8AUCyVx1r2JHM8mBwcrO7EawdNYJw80Z6Qq3sZ3ClNy2vLUfeYtfEVchg0XCMl80JX+u3v2oAXE8/s5o9CcHKkonLLlTTQqWNviiQc4ZA2uiSXqcHvGTJViDp60sYcVs2RpttjtISaLYTBbHf4r/7EQMJnp119LVuKpL8RTUQqgI+FFPZwM43tp+MDpp1B9kxTU+zcIqwXVvQ00SS/90/Wwi+1psIOQsTS4aIynvjvlFYEQ900piTHgv/I9IyvxAs2raUbZGQEayNydS8F2NV37Gv9whysV2gCDEm46GU7bmVt2FZ7vKJISyjwRaa+50XD8xhxjhXWgiGsZ+8C3Q6ppNXy9VkJaW2InHj+Nse9CTObLq6LltDc0K+LzJw+bwf80wAC6ia7zh0eMu3JbRsvS6GcanPYPyU5az26607zm8akD205HhZS3VvuucFdorIjLNxSlrRn9djbKLmpdic/j2d07dsEnBj3g+jJTWvKpH/v98gtm3hMxPW3+VNHB+cLmTwfeh0j2HquEjtY48pEcuHkALAdfN9xtwn8iml4jD8ngVi8WYjlOv4fRsrxR7QaunmRO90ubaCMHRrmb2A/v
 HrugSbmc
 Jm+p6Un8wiWuyjIi2O/+82fxl4kcRXieCQSyk58osDUBGVBQLiOC1QTv138waNO2aMdcgmlqIjvj28PCW9eqjg/6EHipJacslmpL4PQlehqI0H83njjZY4Y7eJeCLGQxKAh/lc/eM/Ok6yvpt6F45FPdLBxsI1taTzqeLFxRYqhBslm8NWfTJtmaalhhcNobcFxX4E2wZ0tRX5DHWvIi6NXCz5Eu6QOGtMDu9YQbmDazH/EuLHdsbxjGOrsgZmhezXi8swqkAPpkT5J8b7t7f9n064VwpiXfsrs2Jptrn/iQAH6xVjrBp9vMXEqLZs/SPkxTM7TqfpT6zHLdW3OHIpzpVYqSLVlL/wTkOH57oC4nafoZNSx0OpLx78IJqYJTNhT3YsqC4mRe/tKfdPMFSLqYRRaMoy399Lwl9hOrNzc4ofCHbGew3gE8Yvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 10:36:00PM +0200, Konstantin Khorenko wrote:
> folio_dup_file_rmap_pmd() passes PGTABLE_LEVEL_PTE to
> __folio_dup_file_rmap() for HPAGE_PMD_NR pages, so it adds HPAGE_PMD_NR
> PTE mappings to the folio instead of one PMD mapping. Each unmap of the
> PMD removes one PMD mapping:
>
> - the folio's mapcount never returns to zero, and removing the folio
>   from the page cache reports "Bad page cache", or hits a VM_BUG_ON
>   with CONFIG_DEBUG_VM;
> - the first unmap already counts as the last one and drops the
>   PMD-mapped statistics while the other mm still maps the folio;
> - the second one drives the entire mapcount below zero and drops them
>   again.
>
> The helper has no caller yet, the next patch adds the first one. Pass
> PGTABLE_LEVEL_PMD, as folio_try_dup_anon_rmap_pmd() does.
>
> Fixes: d8ef5e311d7b ("mm/rmap: convert page_dup_file_rmap() to folio_dup_file_rmap_[pte|ptes|pmd]()")

Was this a mistake in d8ef5e311d7b, or actually intentional for whatever reason?
If the latter this shouldn't be a fixes.

> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
> ---
>  include/linux/rmap.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 0b332770abeed..7562017416094 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -558,7 +558,7 @@ static inline void folio_dup_file_rmap_pmd(struct folio *folio,
>  		struct page *page, struct vm_area_struct *dst_vma)
>  {
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	__folio_dup_file_rmap(folio, page, HPAGE_PMD_NR, dst_vma, PGTABLE_LEVEL_PTE);
> +	__folio_dup_file_rmap(folio, page, HPAGE_PMD_NR, dst_vma, PGTABLE_LEVEL_PMD);
>  #else
>  	WARN_ON_ONCE(true);
>  #endif
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

