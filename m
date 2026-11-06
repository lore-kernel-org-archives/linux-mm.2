Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C71A606A33F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 12:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FStjyAY0
Received: by kanga.kvack.org (Postfix)
	id 9F1A66B05B3; Fri,  6 Nov 2026 07:38:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A31D6B05B4; Fri,  6 Nov 2026 07:38:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86A866B05B7; Fri,  6 Nov 2026 07:38:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C2B36B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:38:54 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F1B9D40DC8
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:38:53 +0000 (UTC)
X-FDA: 85404648546.04.F13C556
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id E46C1180002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:38:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FStjyAY0;
	spf=pass (imf16.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793968732;
	b=iY15Y3gfsuTjEg2Ko/+gcXTfTXhEcp1EJzUHWQSeR3kFFOFJk1JtJJG3Z2StMXpvzwUbRA
	oC6ic1CtkwL3VEJIGBc8u1Wx1GjLjVtFi3afa3XbSdRBk4dB0uWYMQY3N0lztRbRuQ/FHu
	5aePeh3ccr7WHIJzixobpk7Ol2QLWhE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FStjyAY0;
	spf=pass (imf16.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793968732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2pfmacECcqVcYywkgZMGS6LkZuCwqHkVAmJzamD2whI=;
	b=JMBjdz5ksRQBXF8qjsy81t3JPE0XWM/275LguW5JbfVaPSJ2cCg/rlNQWsEFrMIQ1B0zou
	UF2wBJLM/vT5MtCTgjAP1Q1nFPHv3XX2CC/i9k54LygJ6P+e2nKLTu7BmiuZaMfZzs81eg
	2ZMRzakympWF1LDZgoAohihb0wS50gU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2716841A7A;
	Fri,  6 Nov 2026 12:38:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12EFB1F008A2;
	Fri,  6 Nov 2026 12:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793968731;
	bh=2pfmacECcqVcYywkgZMGS6LkZuCwqHkVAmJzamD2whI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FStjyAY0FW6kbw3uXf62FFRYlWxG2nSgA93yBnFn9ugwM4dGwj+PVQ5pap3K6oUCi
	 6dxcxRVZr9JyPyaOU6SYFRRi58za2FXqmecILZDvxCPf7QF6Mlhi6kF01dciRML/Z4
	 eRn5sl5YOxCMJYaQvK+u+uPEdGNKFbQPlgkNW0i/k60D1vI70pS5ye7rqRu75Zndy3
	 ZQ8pUPUv1CNkmt7bvel927xSaAxSegYQoftq/nm4tU+F5STRijVbDSs55DLUR47sJZ
	 QiK2yN/hspvh0Iklt1e9SeTadZzrE5GuO3l2AnEfFwMYTy26psvQbGlQ/5oBg3tJnq
	 Ml0ZmtOtJlCtA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id 7526D198004A;
	Fri,  6 Nov 2026 07:38:40 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Fri, 06 Nov 2026 07:38:47 -0500
X-ME-Sender: <xms:T8rtasefdrDg50RCfXVYapWRPd7hJhOH7MR_vMfF_RkFPcpgn0iabg>
    <xme:T8rtaq11Zf6R1Zc0aftUnIsFDaY0LWo5YyxJjLiJyorI0EjMIMb_FQ2H1PSDt_qJk
    eenHVeoya81NzJfPZ9LLMg62Zf4K4Yl6CtsrypytKDJ7q2XXT-7fkAQ>
X-ME-Received: <xmr:T8rtauiyuNtFX1s9r67EC8H9v-rJ9qUshbNAZWxxA-i546XDDMOnOCzcYEY>
X-ME-Proxy-Cause: dmFkZTGzAjGnz4qczRWBwFDzqEedcIN2RDs77+IhaKJdOHI/wRF4GJ+/XYgTh6qUDCaXtK
    q3BGgpdQwiz8g3jZv+XNiZ3PHhWZePA+KkMXnh5DVEYxm4xAwVX0MEjom76ZmfzWC+JTPH
    KiS19Dcunkmjpxr4Uil2sC19R8pXj7ovLT0PA2yAVZWcLty5pA48PAv7fst0p77EiM3n+1
    SmGSQ5XOtXFCV1+dbb7vBvMxrwGRHPa+XdLj9z9pUYo6DwpdcyJmkiF0P6rFAo/V/JZdTc
    JB24ZdeHtaiEyrrTwoEjAufvE1haKfVDIo+IxU19WrQxgP8cc4psM9iHQFHP4vpOpa7VoH
    wzQ1pi5Xm1k+/vd5fWuuLnXYA4NDa3sM6PbhRSGJ29vaEqlrEoBKvduJJT2QLau5zON77X
    LVS4No3GqNmQ7P5K5ZGNyDCsQUAFFMjELc5QUn1AxYZC+wWsbenSBZU/lmEyveJGaJ2+jX
    5fuGn8bxlHcwcJNuyglZcxdfbk0Sa0PEcwNUH2TBBBLTHU0CoNDi/SD5/1309grZ9OgwS7
    L3pcQ1dDN1WJl/+zOkyXMbph0dlAPT58n+aswI4a5WzW2PE7JzKbmxjsgGo+8fBfzklnrj
    EBr+0lhdOkv1TdfFi5YziSH1mehaQtbycU8WlCmDbaBUbLQfGwo3GJ9qXvIg
X-ME-Proxy: <xmx:T8rtat7js2s-eKQZcHK3_aXiUqi4PQT3ApNyxSy7PplOfAyVt45tMw>
    <xmx:T8rtagW_pOIDqaJwR8OxdqY5JxVHrJv54OXWTAdpWfg2Vex1AvmGtg>
    <xmx:T8rtatlscF93bVi-jaQNcHjAI-NjY-w5CIlVvBjJDaO8_4AtvZP4lQ>
    <xmx:T8rtahSHJTPBlU6GOzNLC9za7s75hOd8IlP5D3JPnl2Uwi1M9NeaSA>
    <xmx:UMrtaiNVGrkcAtiFcecPVVpaYRDrYD4OeE5iPf8Os-chIedx19aW39g_>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Nov 2026 07:38:39 -0500 (EST)
Date: Fri, 6 Nov 2026 12:38:38 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>, Hugh Dickins <hughd@google.com>, 
	Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, 
	"Joerg Roedel (AMD)" <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>, 
	Steve Sistare <steven.sistare@oracle.com>, John Hubbard <jhubbard@nvidia.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
	iommu@lists.linux.dev, Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] mm: limit pagecache folio refcount when mapping pages
Message-ID: <au3JT5QXbcOFXCp0@thinkstation>
References: <20261105-refcount_overflow_stable-v1-0-70b9c655da3e@kernel.org>
 <20261105-refcount_overflow_stable-v1-1-70b9c655da3e@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105-refcount_overflow_stable-v1-1-70b9c655da3e@kernel.org>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E46C1180002
X-Stat-Signature: 6ftph36d14bz5ikkfxs4617gs63ibdru
X-Rspam-User: 
X-HE-Tag: 1793968731-219650
X-HE-Meta: U2FsdGVkX18+aftqlEheUvIZW0PqHyiNsDwRTsHIwRjdAW3TmMA6mEYj9EzbDTp/GDKECnjV6q3AOyvKuP8ler0G/j3JX7dMjjgqJqUl/m8h3ftiCno7nEKAZ54pDrEE6vvjpwMKckdrLj0lK8Crt0kLaBhvzQef4fEDdlBBxAHtYYUvAZStyWPr9nU0wGj8cvU4AWCUe3YuINedbQ9lm68IGSWv86LPckwekJ4UMdZqJQHimcpoQiAUjg5j4WwCBodqcqt3zPhrvkQGIpRqgtkkPA5iY6yVwnmudBzkvvhV6i4Kx/Jd9YpnTHhgdJ1xWue1KjvY+hVFsZB4/BQIYSvDSqbD2qfNCYDBAm15GK7WIMVd3eqq2WtAMSHnVuTL6r076wAZDw6PeZFRgy+7cSwo+ZRXd667KYSlGO/zc37Gp2QooyllwfRUKme+a4w2VHdsYtyu8I+RFCHeOoey3ikaWCihuFhLTpYsALqiyM3hej5+aIIcSWHVFWrGPquIAGmGWX+VdQ3lBEseJZA97hL97nUl8oN4GmsSSeMyHPOUfNQDwUp3xV8Vi4/VuzHO2UAKANZdwX6Wtq40DTeDsTNGasBilBZhafoEMRpeugS3NNTfKljDfeRJYI3i3sFZU15NBswEMerSTQ1Qxwlb8qpb2VEw693+C5E7LPr9kRXsUbWbAF95M/u/wOsbYTtwjkfuwkk4jEhwzy1wYHs7v2VKo7yfUSnumLYY6sy2Ros8Y2WJlBbZgN6AfIMo82hv+5hFP25pPrQsgfU1W/NuWr3l+kH3jg527CF4USXfvcdeGpF4Ox5tH90voRSw6OIHOdTwuRNLo+BKn2IottYelM8mZyRlrAAWSQqAo2VExJKfgnqTSjUZy20MSJMf8ijCjUX5fY7P0w7WyVK6Slq4WetNBzRqXrupw0zuLZn/Ra8oltyb29wGorZ4Ef03nTsoF9ifJepAcTxZiE1+SRw
 iD6VwdWt
 qLv5BMuHO+ZPZ6mIyPoNz5qGt6ZR7x2Z0293n3Xrit34AePNSegOGQNuOTr6/EudDKBh0Z7tbJZwwtpetE795ftA5jKMk5QcgKSL3IFip6wwjWJNaJpaf+nd+zmwRJplTrfEoTV5pCC356XI057gKbDizOFszpUmoQNd9JWzS9y9lfkC1GlKzy95XrE//rWfxgczCimNo6p5T/rBnexDYjMioLTkUJfx5D6w0NtKBxhj1kRhf+cukeK4f9T/JhJqfuA70GeKpiY7aMmdNPovmkGBQxQtclIHvZQPC2yA6unMqlx6Ke/rzJh06w6ReQ0ftrvhfpLHOQRKkxDKy+ZmzenYoNkJ0qKC0bc03HwLR+WYwi3LjBG5UKGeozBqZ/ZBspXuw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 02:10:10PM +0100, David Hildenbrand (Arm) wrote:
> With large file folios, overflowing the folio mapcount and refcount
> became possible. For anon folios it is currently not really an issue:
> each large anon folio can only be mapped once into a process.
> 
> That's not really big news, but it's about time that we do something
> about it because some modern technology might find ways to abuse it :)
> 
> One of the enablers for that was commit ddc58f27f9ee ("mm: drop tail page
> refcounting"), however, file thp support was added later.
> 
> File folios can be mapped multiple times into the same process, allowing
> for processes to hold many references to the same folio.
> 
> As a short-term solution, let's introduce two folio refcount limits:
> one for ordinary consumers and one for admins. Leave some headroom
> before the refcount goes negative, which we really don't want (having
> the mapcount go negative is also not expected).
> 
> Start reporting SIGBUS if we run into limits. When restoring mappings
> from migration entries, instead zap the pte/pmd entry. We allow for
> slightly exceeding the limit to keep things simpler.
> 
> This is far from ideal, but better than all easy alternatives we can
> backport comfortably. For now it fixes the big problem: letting
> the refcount (+mapcount) go negative and cause trouble.
> 
> This is only a temporary fix, we'll follow up with something better.
> 
> While the refcount checks are not required for order 0 folios, let's
> just add them for consistency: each folio_add_file_rmap*() and
> folio_dup_file_rmap*() needs a prior check.
> 
> Also, just document -EHWPOISON for copy_present_ptes() while at it.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  include/linux/mm.h | 33 +++++++++++++++++++++++++++++++++
>  mm/filemap.c       |  6 ++++++
>  mm/huge_memory.c   | 24 ++++++++++++++++++++++--
>  mm/memory.c        | 23 ++++++++++++++++++++---
>  mm/migrate.c       | 11 +++++++++++
>  mm/userfaultfd.c   |  4 ++++
>  6 files changed, 96 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index a2dd76cc5bbfe..79ae8fc0d6bb4 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -8,6 +8,7 @@
>  #include <linux/gfp.h>
>  #include <linux/pgalloc_tag.h>
>  #include <linux/bug.h>
> +#include <linux/capability.h>
>  #include <linux/list.h>
>  #include <linux/mmzone.h>
>  #include <linux/rbtree.h>
> @@ -2228,6 +2229,38 @@ vm_fault_t finish_fault(struct vm_fault *vmf);
>  #define folio_ref_zero_or_close_to_overflow(folio) \
>  	((unsigned int) folio_ref_count(folio) + 127u <= 127u)
>  
> +/* Leave separate reserves for administrators and concurrent reference gains. */
> +#define FOLIO_REF_COUNT_LIMIT		(INT_MAX - (1U << 26))
> +#define FOLIO_REF_COUNT_ADMIN_LIMIT	(INT_MAX - (1U << 25))
> +
> +/**
> + * folio_ref_count_over_limit - Check whether to refuse more folio references.
> + * @folio: The folio.
> + *
> + * Relevant for large pagecache folios (!hugetlb). For these, we have to check
> + * before adding page table mappings or other significant refcount users whether
> + * we are close to our folio ref count limit, to avoid overflows.
> + *
> + * Checking this for other folios does no harm but is mostly unnecessary.
> + *
> + * This check is an approximation; we leave some headroom such that concurrent
> + * increments, batches and temporary references are not a problem.
> + *
> + * Return: True if the caller should refuse additional references, false
> + * otherwise.
> + */
> +static inline bool folio_ref_count_over_limit(const struct folio *folio)
> +{
> +	const unsigned int ref_count = folio_ref_count(folio);
> +
> +	if (likely(ref_count < FOLIO_REF_COUNT_LIMIT))
> +		return false;
> +	if (ref_count >= FOLIO_REF_COUNT_ADMIN_LIMIT)
> +		return true;
> +	/* Background threads must not consume admin reserves. */
> +	return (current->flags & PF_KTHREAD) || !capable(CAP_SYS_RESOURCE);
> +}
> +
>  /**
>   * folio_get - Increment the reference count on a folio.
>   * @folio: The folio.

Does the slow path need to be inline at all 15 call sites, GUP-fast
among them?

Maybe only leave the likely() check in inline and move the rest into a
function call?

Something like:

static inline bool folio_ref_count_over_limit(const struct folio *folio)
{
        const unsigned int ref_count = folio_ref_count(folio);

        if (likely(ref_count < FOLIO_REF_COUNT_LIMIT))
                return false;
        return __folio_ref_count_over_limit(ref_count);
}

bool __folio_ref_count_over_limit(unsigned int ref_count)
{
        if (ref_count >= FOLIO_REF_COUNT_ADMIN_LIMIT)
                return true;
        /* Background threads must not consume admin reserves */
        if (current->flags & PF_KTHREAD)
                return true;
        return !capable(CAP_SYS_RESOURCE);
}

Also, should this be capable_noaudit()? I am not sure a refused
reference should leave an audit record. cap_vm_enough_memory() checks
the admin reserve with CAP_OPT_NOAUDIT.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

