Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66C66CD37B2
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 15:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C100E6B00A8; Mon, 11 May 2026 11:35:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE77B6B00AB; Mon, 11 May 2026 11:35:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A87CA6B00AC; Mon, 11 May 2026 11:35:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 971C36B00A8
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:35:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 543EC1A013B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:35:52 +0000 (UTC)
X-FDA: 84755539344.22.C1237D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 708B540015
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:35:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UrVzk3xF;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778513750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yANLwMdIsdTjVTrNT3iDD4TmmuW1wUuvLRG7I8nNOcs=;
	b=HSDQOdjQLZzbhVP7alSxizs6e0Ot3w+1xqLHtNtfSdm+hnVmIEVYip0wpzWaon++nKtm2/
	GHsHTa2+WQ2leYD2e73Q6Z7oEk+SDVEMNXf128sM5MB6y08vYM9N54RGdVcpOhPeOrL99Q
	dct05wRBDGfAUTPXxn9CqFGkpic/KRw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UrVzk3xF;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778513750; a=rsa-sha256;
	cv=none;
	b=ZWZ2fIe6QgaC7zCbOYCK4SPWOoGyZ74Vrdd+CavgwRE7RNXO96J6jSAzfIS8prT9EQ0usg
	IwSBGRQ4PI0JRnMvEx4m6P66jQqEZW0RB4zfjSRCveMUvotduePQqKhUvjhiI8PxZD6IZZ
	oT81AVL/yaURXm+8OOR9t0A83KuLJEI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 978F7442DF;
	Mon, 11 May 2026 15:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8514EC2BCB0;
	Mon, 11 May 2026 15:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778513749;
	bh=Kkv8LGne/ZB9kLOhAmHhVPrjWXuFNdHyoMZUMle6Dao=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UrVzk3xFELKUlkQ/hhUlbzbhTvDTcAfpEhLVJM9Jd+DaO2z71QCog6q2Q7Ul2vX3A
	 m7LILd1ByNtzzGSiBStB2CRi6UJC8wRau9+S0DBGlcJWDxE1s2bpO/wnSEpoyXUQnm
	 6Fd48gW9YlQ5kYhmYXGoJOkd4YT6mtEAQJ6JqBxktVCz+2X32yLM9R9LEiHb4w0N27
	 S8awfLRdjfpOJG4xUctMF8MoU4n9oZ9C9HlO16m7/s6xiasT3xvu/Nr4HBWJWa/h8q
	 i8q0Qhx1w3XWxPBlhAjCLXI5OSOmFX+QXtyoS9QMdLrg/57Mzmp+sTeb6C6db34s/e
	 0FMWo1scqtbKw==
Message-ID: <810e9a58-9c08-4f5e-af5f-866685ca09b2@kernel.org>
Date: Mon, 11 May 2026 17:35:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] mm/migrate: skip data copy for already-copied folios
To: Shivank Garg <shivankg@amd.com>, akpm@linux-foundation.org
Cc: kinseyho@google.com, weixugc@google.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, dave@stgolabs.net, Jonathan.Cameron@huawei.com,
 rkodsara@amd.com, vkoul@kernel.org, bharata@amd.com, sj@kernel.org,
 rientjes@google.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
 dave.hansen@intel.com, hannes@cmpxchg.org, jhubbard@nvidia.com,
 peterx@redhat.com, riel@surriel.com, shakeel.butt@linux.dev,
 stalexan@redhat.com, tj@kernel.org, nifan.cxl@gmail.com, jic23@kernel.org,
 aneesh.kumar@kernel.org, nathan.lynch@amd.com, Frank.li@nxp.com,
 djbw@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-8-shivankg@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260428155043.39251-8-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 708B540015
X-Stat-Signature: wfs7cac33knsfamyj5hps9jjg8x57ksw
X-HE-Tag: 1778513750-761892
X-HE-Meta: U2FsdGVkX18eAYwag3h0jmPDSsxNnejSaMQBzkD3/JFFNgQqjmnJSx+hBb29Uou+OAZg9JSKDiqMl/ipFPbnhwEMF/m6/qfiEvWkpi5ytO0eStyofTiFP3bD6dI+BxYmLMVDGVIyNWMW783+QotWa5QIfkZFc1AgQvBLunCmDjqYMtb0W+S5qiPfeM3jj/tY5r+4WnzW8vgVVzMiOOr7t8/KBGyVLt9KZHOuO2w7rfjWyAEWRE4wofPIoaFfVOmedY1sTKvktSIQhDSMZX9rgDgmyRimU5wRwTV3R13qkA7l+kI52ShS5lNzJoVfcyXdw4XBehtRQpbKmS13sAsQ6+aVvOoQ5FOF8uk0FUQ/tIdfNigrz0Hs7lQaiymwS5ZnkgDxAsfVjKZqAOrk0Cgax5dUR3mIVge9DQwJELqsRDmPsYR1E+2G6RytAEK5DLjqfM2DDxJ94vkyotTGqkn4N3tiThO8jFrt3kFrEmrrGcIAyvlDnXhj5yEX7RCvudUDvY/DxNZV0HP8votHzkBZ4DM+aZMyAEIoV0aaUjulYqiRlo0Ec881gQEX1h80wejt1xNp/6J2TjF4NcNBRn/ITfx4p/n4iBD6G79gFMAXUP4Vf/918FvzwrWIox6laX301HjXVcTyNuU8Se7xG1hcvWuFlKzBj7bFG2v58smzHE5mYNo2NFFKYN7C8oiwFfS89zjrppp1GqDGuVmTM5SoVWXSoUtql/CKJzsz4iBRGkKjS3Od5MMoXEv4s1WlW12HvhoVHkk750J33jJM2UCo/iQP8/BgGKErlDCx5BJvJTgoGCF2L4gqJSEcqYTYQzUtGhXQgklSgE11V1Mk0WpUjky2KLALpYHeisUnv3MRfxN/recHgDhM+5o44Q98i9JbDwBnYkPyxeRR6HDCEa0rVK5DgGdk/WC2krw0/eoWznhf0IwtCM5pHDqpGRjnRV1AKFTuv9J0mh0eJIvw0Pz
 hxivaTGY
 vPYARZnM8smWHO0OBiCB71ZGpJPjwRB9J0Bz5JK+DCYwpJhorGP/zIFq1u5E6SNWQoul2+9U2kfGeXHi4sfURB5FywXSspEiW+ZHvREZVZgrRj+teUlCWRHo7quca9slkx1+iUlS4n7k3TbLcxCcuZ2+IEvHZv/paDoNwrFfSw8Igb9g5njKQi6qDIxoRUySNCW2xP2j7Jy5o1iT5JIp9mWK9DWtT5Uc2/3m+/2tmKBLc0Ru80+CvOMGceNcusXEReRSGYYu08ozrmVKcPlI7gjf8N7cIGzmVVy1Dx302oWVSBv/7nJG6qyvhFLCtX5KqqIrJFstYejFN9k0g2w8mgI+4E43+hFP5Vn+h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/26 17:50, Shivank Garg wrote:
> Add a FOLIO_ALREADY_COPIED flag to the dst->migrate_info migration
> state. When set, __migrate_folio() skips folio_mc_copy() and
> performs metadata-only migration. All callers currently pass
> already_copied=false. The batch-copy path enables it later in a
> subsequent patch.
> 
> Move the dst->migrate_info state enum earlier in the file so
> __migrate_folio() and move_to_new_folio() can see FOLIO_ALREADY_COPIED.
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  mm/migrate.c | 53 +++++++++++++++++++++++++++++++---------------------
>  1 file changed, 32 insertions(+), 21 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 03c2a6f7e5e4..c493e67e359d 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -850,6 +850,19 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
>  }
>  EXPORT_SYMBOL(folio_migrate_flags);
>  
> +/*
> + * To record some information during migration, we use the migrate_info
> + * field of struct folio of the newly allocated destination folio.
> + * This is safe because nobody is using it except us.
> + */
> +enum {
> +	FOLIO_WAS_MAPPED = BIT(0),
> +	FOLIO_WAS_MLOCKED = BIT(1),
> +	FOLIO_ALREADY_COPIED = BIT(2),

I wonder whether we want to talk about "folio content copied", to not confuse it
with folio flags copied etc.

FOLIO_CONTENT_COPIED.

Thoughts?

> +	FOLIO_OLD_STATES = FOLIO_WAS_MAPPED | FOLIO_WAS_MLOCKED |
> +			   FOLIO_ALREADY_COPIED,
> +};
> +
>  /************************************************************
>   *                    Migration functions
>   ***********************************************************/
> @@ -859,14 +872,20 @@ static int __migrate_folio(struct address_space *mapping, struct folio *dst,
>  			   enum migrate_mode mode)
>  {
>  	int rc, expected_count = folio_expected_ref_count(src) + 1;
> +	bool already_copied = (dst->migrate_info & FOLIO_ALREADY_COPIED);

const, and no need for ().

> +
> +	if (already_copied)
> +		dst->migrate_info = 0;

Hm, why is that required? Might deserve a comment.

Likely you want to clear the "already copied" marker?

	dst->migrate_info &= ~FOLIO_ALREADY_COPIED;

?

But I wonder if this really belongs exactly here.

>  
>  	/* Check whether src does not have extra refs before we do more work */
>  	if (folio_ref_count(src) != expected_count)
>  		return -EAGAIN;
>  
> -	rc = folio_mc_copy(dst, src);
> -	if (unlikely(rc))
> -		return rc;
> +	if (!already_copied) {
> +		rc = folio_mc_copy(dst, src);
> +		if (unlikely(rc))
> +			return rc;
> +	}
>  
>  	rc = __folio_migrate_mapping(mapping, dst, src, expected_count);
>  	if (rc)
> @@ -1090,7 +1109,7 @@ static int fallback_migrate_folio(struct address_space *mapping,
>   *     0 - success
>   */
>  static int move_to_new_folio(struct folio *dst, struct folio *src,
> -				enum migrate_mode mode)
> +		enum migrate_mode mode, bool already_copied)
>  {
>  	struct address_space *mapping = folio_mapping(src);
>  	int rc = -EAGAIN;
> @@ -1098,6 +1117,9 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
>  	VM_BUG_ON_FOLIO(!folio_test_locked(src), src);
>  	VM_BUG_ON_FOLIO(!folio_test_locked(dst), dst);
>  
> +	if (already_copied)
> +		dst->migrate_info = FOLIO_ALREADY_COPIED;

|= ?

> +
>  	if (!mapping)
>  		rc = migrate_folio(mapping, dst, src, mode);
>  	else if (mapping_inaccessible(mapping))
> @@ -1129,17 +1151,6 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
>  	return rc;
>  }
>  
> -/*
> - * To record some information during migration, we use the migrate_info
> - * field of struct folio of the newly allocated destination folio.
> - * This is safe because nobody is using it except us.
> - */
> -enum {
> -	FOLIO_WAS_MAPPED = BIT(0),
> -	FOLIO_WAS_MLOCKED = BIT(1),
> -	FOLIO_OLD_STATES = FOLIO_WAS_MAPPED | FOLIO_WAS_MLOCKED,
> -};
> -
>  static void __migrate_folio_record(struct folio *dst,
>  		int old_folio_state, struct anon_vma *anon_vma)
>  {
> @@ -1353,7 +1364,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
>  static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>  			      struct folio *src, struct folio *dst,
>  			      enum migrate_mode mode, enum migrate_reason reason,
> -			      struct list_head *ret)
> +			      struct list_head *ret, bool already_copied)
>  {
>  	int rc;
>  	int old_folio_state = 0;
> @@ -1379,7 +1390,7 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>  		src_partially_mapped = folio_test_partially_mapped(src);
>  	}
>  
> -	rc = move_to_new_folio(dst, src, mode);
> +	rc = move_to_new_folio(dst, src, mode, already_copied);
>  	if (rc)
>  		goto out;
>  
> @@ -1536,7 +1547,7 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
>  	}
>  
>  	if (!folio_mapped(src))
> -		rc = move_to_new_folio(dst, src, mode);
> +		rc = move_to_new_folio(dst, src, mode, false);

... mode, /* already_copied = */ false

>  
>  	if (page_was_mapped)
>  		remove_migration_ptes(src, !rc ? dst : src, ttu);
> @@ -1720,7 +1731,7 @@ static void migrate_folios_move(struct list_head *src_folios,
>  		struct list_head *ret_folios,
>  		struct migrate_pages_stats *stats,
>  		int *retry, int *thp_retry, int *nr_failed,
> -		int *nr_retry_pages)
> +		int *nr_retry_pages, bool already_copied)
>  {
>  	struct folio *folio, *folio2, *dst, *dst2;
>  	bool is_thp;
> @@ -1737,7 +1748,7 @@ static void migrate_folios_move(struct list_head *src_folios,
>  
>  		rc = migrate_folio_move(put_new_folio, private,
>  				folio, dst, mode,
> -				reason, ret_folios);
> +				reason, ret_folios, already_copied);
>  		/*
>  		 * The rules are:
>  		 *	0: folio will be freed
> @@ -1994,7 +2005,7 @@ static int migrate_pages_batch(struct list_head *from,
>  		migrate_folios_move(&unmap_folios, &dst_folios,
>  				put_new_folio, private, mode, reason,
>  				ret_folios, stats, &retry, &thp_retry,
> -				&nr_failed, &nr_retry_pages);
> +				&nr_failed, &nr_retry_pages, false);
>  	}

dito.

-- 
Cheers,

David

