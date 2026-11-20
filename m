Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5326D606A330
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 15:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hQnJPqvn
Received: by kanga.kvack.org (Postfix)
	id 6C9136B00EF; Fri, 20 Nov 2026 10:22:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 652D86B05B1; Fri, 20 Nov 2026 10:22:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51A4E6B05B3; Fri, 20 Nov 2026 10:22:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 228766B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:22:49 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9D350140F11
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:22:48 +0000 (UTC)
X-FDA: 85455864816.23.F0B995F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 03F10A000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:22:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hQnJPqvn;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795188167;
	b=RIzqw7scR7tDnLJCthU9r6T6VrWA8U5QX03TUQplff01NjqWaexx0r6iTm3Zh/lkLMtKUT
	KpMyISoU+EcFDRIWzUSneT/yQS8wEUZ8emcVG9SHys7SU0Ty0nXbIpV8AvYaefNDpcYR93
	7oFHzrIPnPQW9oX7z68BI8oEzjoy6iY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795188167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QqS+qF73GHZJLanntYt4ZL3GQPK5ntqIkF074E0sSaY=;
	b=sFDgNPL3zcnSz5Nt/8Wh5//UwXSh6u5lpvEE6Wkpt5WpjyhWclVmmJDUw5Q1UEAmEKlEu9
	odnZONxw6zhGjeyMdJwPtkNk6D+Oh86ZoeY0tFwHQOPNHbfdfhQ7HcsecTudKOciwFfg//
	ZmMJvdLrvR7yczLdD36gu3WXG1kDGJ0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hQnJPqvn;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3314B614A5;
	Fri, 20 Nov 2026 15:22:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E821F000C0;
	Fri, 20 Nov 2026 15:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795188165;
	bh=QqS+qF73GHZJLanntYt4ZL3GQPK5ntqIkF074E0sSaY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hQnJPqvnbFD2+tssbhPSfU9zKKdvccfJjl3gMjqqY8y9TylHWQvBmcTr97isBZWkN
	 o94x1OUsgPKGsC9gQ0xjyhnl+Z4p7/D6bXqeatVMD2y0bF1ONXdsIh7/ATaboGlHeO
	 b9B91VqeHFICoNB/4bkABWQROT+KQVz+b3elB8+0NYEPB4uTFeD7rjIMxDzd6LvmDa
	 nXB5ma87Z7/e0g3b8+/PI/g7g0MMgukv+Z5LJXtRD/MCV+cV9IA4RnLv7h01QbMBDf
	 Yt9poiMxcXAJhDTswDdg+GmSnhXJ0WeKpMeng1lgq7OldvEHE+VuGR2wgcMe9hbwcI
	 UuVz1P3QLNujw==
Date: Fri, 20 Nov 2026 15:22:40 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Wandun Chen <chenwandun1@gmail.com>
Cc: david@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com
Subject: Re: [PATCH 2/3] mm/migrate: batch PTE restoration in
 remove_migration_pte()
Message-ID: <awBjoC-YFf6KPYT1@gremlin>
References: <20261120032949.2036731-1-chenwandun1@gmail.com>
 <20261120032949.2036731-3-chenwandun1@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120032949.2036731-3-chenwandun1@gmail.com>
X-Stat-Signature: s8t7jsomx7siyxoaw6bjw9g8j8mhoxd4
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 03F10A000A
X-HE-Tag: 1795188166-129990
X-HE-Meta: U2FsdGVkX1+kOR1talV/jIEqT7MH2tCmKD3fzXtil58go4i453Lcx2Q/3ujNwh8ReT43Q5QKcqlFX+QPdrZait9ymrv5uqzZEorzcGJrPg6EIfeAzzPzCp52Of5K/g1k/s8wwNjYsFkX6nG5EFkIrMANBAMupeXNyqgnwx05OCaxFJftdH4jd4JcxEJsRwGTKGUQHVsLbYV6s0hWEffafWpGAW7lLYsihhwYHXiB28HDkK4vZk7PhmsJL6ChvZVEjKFZpaou1/sdEJLh0lukE7EMwrc1x5D2GeucVpypXtSe7E44H5Hu1jygHo+MioeoY5nGZXqb7U0YoziMYswSnDVg6M7epTkHESeQQl+88CLe2qP0PP/9PkGaT5w65OVNlxDpktQE7u7T2mdQTKcQGdXmAiSRXoL5cWpEoFSmV2YncC8aJAbeDy2qgk7nEt/PQ2qwDR8low7/u2k1TvHGvMQ1uVzqA/F73vD7yMkz4Qi1ZVfXco8KuVcqNZN+NqbCTKFjCxkyw9Ck76mHRc/MUlpRKUcuPgn8m3pL8C1L7/e9eH5SWGBBbqGLWmsABzcFOFS/sy7u46H/SyKvaebqke/aOY85l2o6lLI81MWussAmOWAFZx9G2X5YEg/5Jwd3WWYVgSS/fKH91PqoIwwcJg9bIZXoCMdrMPb+Qf4zjxdS2MIHQV6k7FV3hQVYiEKAfiH8Q43auv7TnYqEUQHvcme4rEpQBCbRWjen8RVwbhz8rCYrLzVi62EgXDXDO7vb8OktWs2VLVxpPLFZCt5owDI+z08KF2IohQvHtWbAPxNfZyVycnKy3FDUpT6UDstnIxN5z/gHZDm0OELXZ1HyKEJGdacrrKwuzwVfXydKPrVYBBeR3fMK+l0XyhV/zsOfyyqHyY9xr55RXaWZJtKOuoEdXj9FDD4MNIiePHm5ufRovFsD7vpxNexXwhJO5ODwMWEDTfzHaK1bnVRGKJR
 8Ud/iOHw
 Qkwi+0EAWemldM6nJ2xBszUfuSfev0fU+i7W0Hb7WvoDG1sqWYyQ4efdXI51r0WoMXFcC8AYlo0lNwlr09ujLhwK2JVOfDfAehmjaGln2UuKzIjmrXPAhWcjWhURlHLwXEqkmQ5podvVLKrv9cDe1sMvVd3+L7rCA7ne6u0H8Fz7kgnil9TXugNQ9xyC6hfsCFu1R2TA3uUtDlesvVims6CELy4t2KKpma11kocJ6O6wKYqBxjyY3Yc12o+1wgg6j7JCC1nBHSMprGGBBM57wT8RFlFB79d6IsvPWjuMD3p+lsvejvccLk4lbHmJ3xQu1dadZEjmXiiM/Uehj1y+BMm+dA7VFgs4peQmWBZbMPhWY8NN1eOwUO/bXVu3SlstNvJMlGCUzIXu1EN2K/5XDam78cE6HkF5aiIcpANwK5WjUOjqTBIqOZ4yY7nrzl0Ki+ZbKRSxHgllue5NBeDypXHYsygK8FW5xbtzbFNCgpLYqqh4jzB1NhbO+K9MoEcnqqbX74rTGciUzQ7SFw18a5z0Dy2WQzoQb1N9gy2ttqIk1XdPsZUYc1TWlINPx9Lv19ikQBLdQiiJg19CtwOiS3glhWpAdTzax7PqoykL7sDIKfuxryC8aZ7LE5Uhn5WnQt2gHxUBhDf7CsITYImiXZv1C+GQwrWI+IbDNtM1w5LqHwlOxa3qTNpnn1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 11:29:48AM +0800, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
>
> remove_migration_pte() restores PTE-mapped large folios one PTE at a
> time, constructing each new PTE and updating the folio references and
> rmap separately.
>
> Add migration_pte_batch() to find adjacent migration entries with
> consecutive PFNs and matching type and flags.
>
> When a batch covers the whole folio, the rmap helpers already call
> mlock_vma_folio(). Skip the explicit call to avoid double mlock
> accounting.
>
> Device-private PTEs encode PFNs as swap offsets. set_ptes() does not
> handle this encoding when constructing subsequent PTEs, such as on
> arm64 with a 16KB page granule, leaving device-private destinations
> unbatched. The next patch enables batching for these entries by
> advancing their softleaf offsets.
>
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Link: https://lore.kernel.org/lkml/5f9c449e-43b3-4732-9c14-8199418cace0@kernel.org/
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> ---
>  mm/internal.h |  6 ++++++
>  mm/migrate.c  | 35 +++++++++++++++++++++++++++++------
>  2 files changed, 35 insertions(+), 6 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index 9f78c12882cb..e6ecf307d532 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -552,6 +552,12 @@ static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
>  	return __softleaf_pte_batch(start_ptep, max_nr, pte);
>  }
>
> +static inline int migration_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
> +{
> +	VM_WARN_ON(!softleaf_is_migration(softleaf_from_pte(pte)));
> +
> +	return __softleaf_pte_batch(start_ptep, max_nr, pte);
> +}
>  #endif /* CONFIG_MMU */
>
>  void __acct_reclaim_writeback(pg_data_t *pgdat, struct folio *folio,
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 3c39d309e6bd..e000ef77ea87 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -358,6 +358,7 @@ static bool remove_migration_pte(struct folio *folio,
>  	while (page_vma_mapped_walk(&pvmw)) {
>  		rmap_t rmap_flags = RMAP_NONE;
>  		unsigned long idx = 0;
> +		int nr = 1;
>  		softleaf_t entry;
>  		struct page *new;
>  		pte_t old_pte;
> @@ -441,17 +442,34 @@ static bool remove_migration_pte(struct folio *folio,
>  		} else
>  #endif
>  		{
> +			if (folio_test_large(rmap_walk_arg->folio) &&
> +			    !is_device_private_page(new)) {
> +				unsigned long end_addr = pmd_addr_end(pvmw.address, vma->vm_end);
> +				unsigned long max_nr = (end_addr - pvmw.address) >> PAGE_SHIFT;

const please

> +
> +				max_nr = min_t(unsigned long, max_nr,
> +					       PTRS_PER_PTE - pte_index(pvmw.address));
> +
> +				max_nr = min_t(unsigned long, max_nr,
> +					       folio_nr_pages(rmap_walk_arg->folio) - idx);
> +
> +				nr = migration_pte_batch(pvmw.pte, max_nr, old_pte);
> +			}
> +			if (nr > 1)
> +				folio_ref_add(folio, nr - 1);
> +

Please let's not insert a bunch more open-coded bits in an already way-too-big
function :)

If you need to add functionality to a function like this, please take the time
to pay down technical debt and refactor it first.

>  			if (folio_test_anon(folio))
> -				folio_add_anon_rmap_pte(folio, new, vma,
> -							pvmw.address, rmap_flags);
> +				folio_add_anon_rmap_ptes(folio, new, nr, vma,
> +							 pvmw.address, rmap_flags);
>  			else
> -				folio_add_file_rmap_pte(folio, new, vma);
> -			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
> +				folio_add_file_rmap_ptes(folio, new, nr, vma);
> +			set_ptes(vma->vm_mm, pvmw.address, pvmw.pte, pte, nr);
>
> -			ptes++;
> +			ptes += nr;
>  		}
>  		if (READ_ONCE(vma->vm_flags) & VM_LOCKED) {
>  			if (folio_test_large(folio) &&
> +			    nr < folio_nr_pages(folio) &&
>  			    ptes == folio_nr_pages(folio) &&
>  			    !(pvmw.flags & PVMW_PGTABLE_CROSSED))
>  				mlock_vma_folio(folio, vma);
> @@ -462,7 +480,12 @@ static bool remove_migration_pte(struct folio *folio,
>  					   compound_order(new));
>
>  		/* No need to invalidate - it was non-present before */
> -		update_mmu_cache(vma, pvmw.address, pvmw.pte);
> +		update_mmu_cache_range(NULL, vma, pvmw.address, pvmw.pte, nr);
> +
> +		if (nr == folio_nr_pages(folio)) {
> +			page_vma_mapped_walk_done(&pvmw);
> +			break;
> +		}
>  	}
>
>  	return true;
> --
> 2.43.0
>

--
Cheers, Lorenzo

