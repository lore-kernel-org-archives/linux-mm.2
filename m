Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF2C8606A94F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WBOLm89A
Received: by kanga.kvack.org (Postfix)
	id 04AA26B05B5; Tue,  3 Nov 2026 03:34:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3DD86B05BC; Tue,  3 Nov 2026 03:34:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E53DE6B05BD; Tue,  3 Nov 2026 03:34:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C354A6B05B5
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:34:26 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5266B140315
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:34:26 +0000 (UTC)
X-FDA: 85393146132.25.40AB045
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id B798B1C0006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:34:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WBOLm89A;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793694864;
	b=c0UlTv6UMiE4nAkZKvylHAG7P/wneGsLwycXUSBlwTrxM9BvRY0hn4CAN5kBAq0ZHmT63+
	9BdD7Srwui1EWua4tD8pJZyKdl9TswtOZLQJPgmtTfmfUwhQKOCLBDewi2ugxgyJaWzN2G
	XgKFPyo6x7P1CcG54cz2eeY7f0rLBhU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WBOLm89A;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793694864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aN23VJMnhewW35EFlasRUP/lg6fg3jZoPm2+MgYcpys=;
	b=Al0tvq14AbNFkQSV6v6G9EwDtjxS4OJIi4BEVp+qHTNDJhgZekt647pO+IzN7D+uqYvDZg
	MLLvtCN52H0MqE5Cr0rnTuV+abXhD8IkF+AiFdIVVl6HVI3yNm14X8Om5tuHpdrKbV0Hqn
	5KRBR5ajKnduc5QPxL+Nr69g1/hNuj0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5653D60628;
	Tue,  3 Nov 2026 08:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF291F00A02;
	Tue,  3 Nov 2026 08:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694864;
	bh=aN23VJMnhewW35EFlasRUP/lg6fg3jZoPm2+MgYcpys=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WBOLm89AFwFi8IKVAeRS7jeysXzyogNfn+p+fbL1rf1QBt3Zxg3/CWf/4PwF8AjJ5
	 YwD6VCr9pSdjp3MvVSrREbeBsfgPF3a1RD97c3PzrlJiIzmPvPZL0WjaW3r9AdNHaa
	 qMsQl5xEa5W1LsZfQxkqjaLzYNT8k+fX/Qskx8KMjt4KokItdq9433mvMAK3oo1IMG
	 VfS6LfCspss/z3XnogPK2QMaRXW52/5QJXrxI7J83/zHlASPGusI2dtAjkyktWZjOV
	 IujbpWEanzXE27yWs+vhB3zULLkKkMcVZo4XR6lnjjGAjh4BT1q7Ykt7AF3Gb9NRA2
	 2BABiVeJtVtzw==
Date: Tue, 3 Nov 2026 08:34:15 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] mm: remove clear_page_dirty_for_io()
Message-ID: <aumcgdzoPhuB6zQc@gremlin>
References: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
 <20261102-page-wrappers-v1-3-e7280bdb31f6@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-page-wrappers-v1-3-e7280bdb31f6@columbia.edu>
X-Stat-Signature: f6wtxsmnqmwt9nu3d9orgx1sjb3s83o5
X-Rspamd-Queue-Id: B798B1C0006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793694864-485089
X-HE-Meta: U2FsdGVkX19YRBnndBYS0Ccq4K4OnnzF9ajtPmZTNRG8cibchkdaPY6Fd/lfoLIWy2PF0XB2eQcQeGD9k0oQvpwuoW31HbSJZ9zDxehTayTdEimUY7c/rfD3/Uu0ylfmy8tPqNPD9LbWwi8coajufhQbJ3o82CURk/44cvT53MqvVz7/LYNNCcewNJ1gGYGemel/P7ug/ZiyLBBRzEIKd6st7LESR6eoCN4yMlSTINNuX/2YM+/EpdDaiGDAYBEpbMNYTzGFsuRxCigyfaeUVUmHOv8goiTZEWpbRBgvL11YJujxQfX4SWmWCzxaQpqE3iBZUs2zt/g0Pb5bgsXK7ow0i1FNlPOf0sFYFMtblXjOyLLKEHM6vGFf5Fp/NTPVVKsICxdGiPfFdAJA4XVzKT7rZsSHWPSidIVjmySL940fmWl45zaWN4uYFnAnQmT7TSv/VRVEnvdnpKYd19lMWtXt9vsQUojEGWQoe3itRJO8rYWH03WBrwT8ePepvxJO95CKvo3xTnA1GPDE0+INNEHLi1XJkENydrGZsQNyoqmzq47y8zdGww+9YENSUVIGZBhLRuaSm9Ip3UGK131LUuS1D/l6FTlG6SOsODtE6bTsxgL8yIxAYtcsRw2VcKRNElRQU8VhktFFvBeA5DhHiA8UqJ1TxqJ8GCbZZmzUfaDzmEBURrwakHRiBQpZGRCyq6N/Hk1atnc1hw7TzUZidi+4KjAhBTowC7+uEx+Ukwwf9szyzlk3rxGgTvVtN9m5LkTt/eO2k18CWJ2swQGsbP0sTyJmNE/imANNzshF6zawYc5af7rqgNyNDSC82yh+E4gjN9ezYixndu41hWfI0KxbdFoIVXITOjVCZBchm+rX6MwmwUqGbD3nnHcTL2KBBTodrSvX6UHFu1tNdkfJgKKnqvMKLOxD0eCGLsJVGXDK9nG4qRs65StPjVlosyu2WtgtgI43LzwkcTnvGUb
 7k7/x62S
 mJggqnX9DKAtSjED+rAThuKGQV4vfz1j5UcYaWrFcPc3lqWoHDRHRtoAaWDdt69cAbFdswYSFIc7L07dh9sJwXKV2LVVwpM2ldziX+w2yi6XROmqJ1TV2I1jSS+llnIPm0oGCH/JVwG3D85W83gXr6lC0e4vE31WVRLo9T0x/VZqW/kg0AmPaLJQ73dXNt/J9V78XXvKQSnlMGYYGpWc91GTzjJ0iS7A0LQiORVnHfxFs4wSXD+0xOyeXJTkOqnYk0PprU5R6prrpH5zraF7eSkqZ+sKBsq2sJ86nA29M5Abe2y2xix/4JntAwzxRyMING97AqdOlfC1vpeYQRFVdrmUJt+fX7I5xcfnSy+Rp0BGWr7USbXw+7rEGtpS/aUQMZqdUFHjfDLHAigiETjVMeCzr0MHoRJQLoruQivs7yXjeX2x2zoSsE26/cw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 05:54:08PM -0500, Tal Zussman wrote:
> There are no callers left. Point the comments that named it at
> folio_clear_dirty_for_io() instead.
>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

LGTM!

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/pagemap.h | 1 -
>  mm/folio-compat.c       | 6 ------
>  mm/gup.c                | 6 +++---
>  mm/page-writeback.c     | 2 +-
>  4 files changed, 4 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 692ce3867a1d..9adfeae2153c 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -1315,7 +1315,6 @@ static inline void folio_cancel_dirty(struct folio *folio)
>  		__folio_cancel_dirty(folio);
>  }
>  bool folio_clear_dirty_for_io(struct folio *folio);
> -bool clear_page_dirty_for_io(struct page *page);
>  void folio_invalidate(struct folio *folio, size_t offset, size_t length);
>  bool noop_dirty_folio(struct address_space *mapping, struct folio *folio);
>
> diff --git a/mm/folio-compat.c b/mm/folio-compat.c
> index 9f2cd0ebfbbd..13d4d39e1896 100644
> --- a/mm/folio-compat.c
> +++ b/mm/folio-compat.c
> @@ -42,12 +42,6 @@ int set_page_dirty_lock(struct page *page)
>  }
>  EXPORT_SYMBOL(set_page_dirty_lock);
>
> -bool clear_page_dirty_for_io(struct page *page)
> -{
> -	return folio_clear_dirty_for_io(page_folio(page));
> -}
> -EXPORT_SYMBOL(clear_page_dirty_for_io);
> -
>  bool redirty_page_for_writepage(struct writeback_control *wbc,
>  		struct page *page)
>  {
> diff --git a/mm/gup.c b/mm/gup.c
> index 7d43ce717b24..335dcb3a5c17 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -298,16 +298,16 @@ void unpin_user_pages_dirty_lock(struct page **pages, unsigned long npages,
>  		folio = gup_folio_next(pages, npages, i, &nr);
>  		/*
>  		 * Checking PageDirty at this point may race with
> -		 * clear_page_dirty_for_io(), but that's OK. Two key
> +		 * folio_clear_dirty_for_io(), but that's OK. Two key
>  		 * cases:
>  		 *
>  		 * 1) This code sees the page as already dirty, so it
>  		 * skips the call to set_page_dirty(). That could happen
> -		 * because clear_page_dirty_for_io() called
> +		 * because folio_clear_dirty_for_io() called
>  		 * folio_mkclean(), followed by set_page_dirty().
>  		 * However, now the page is going to get written back,
>  		 * which meets the original intention of setting it
> -		 * dirty, so all is well: clear_page_dirty_for_io() goes
> +		 * dirty, so all is well: folio_clear_dirty_for_io() goes
>  		 * on to call TestClearPageDirty(), and write the page
>  		 * back.
>  		 *
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 0694ec4098f6..b56f2c91b0f2 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2821,7 +2821,7 @@ EXPORT_SYMBOL(folio_mark_dirty_lock);
>   * This cancels just the dirty bit on the kernel page itself, it does NOT
>   * actually remove dirty bits on any mmap's that may be around. It also
>   * leaves the page tagged dirty, so any sync activity will still find it on
> - * the dirty lists, and in particular, clear_page_dirty_for_io() will still
> + * the dirty lists, and in particular, folio_clear_dirty_for_io() will still
>   * look at the dirty bits in the VM.
>   *
>   * Doing this should *normally* only ever be done when a page is truncated,
>
> --
> 2.39.5
>

--
Cheers, Lorenzo

