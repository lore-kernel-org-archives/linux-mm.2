Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E75C96083625
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ACnU884M
Received: by kanga.kvack.org (Postfix)
	id 180A16B05B1; Tue,  3 Nov 2026 03:32:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 158CE6B05B3; Tue,  3 Nov 2026 03:32:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0956E6B05B4; Tue,  3 Nov 2026 03:32:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DCE706B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:32:56 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3B88E12033E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:32:56 +0000 (UTC)
X-FDA: 85393142352.30.3F34938
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 93CD6180006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:32:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ACnU884M;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793694774;
	b=pq8vjLRzEWAIVXkJWZ0J21SIQ/etHfAjPWarKT7wKOaT1S9ptU12uPyD3wBvjcIPc7jUbl
	VECLJ8meRu8rYouEmXx2YSCYpP/vDew2VNJttJY8bwFqOSt4X8C2jgTr28OAuaXCGVqI7s
	TXO5fE4POZPA3G4a2Lq+RUZ6u2zHBX8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ACnU884M;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793694774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qO2aC5uaUEhaDSdNYo+SgI2KvSgkhfT6uqbSumdTfBE=;
	b=XvwsVHO9b2SIJgvn5b22bSgy6jVYsGshc0HXNxEK/vzoQ0AVYFdA50qNBT30OkLAaGd30a
	8DrnEpAYTqz93/7/sqhWAnPGqb/NzZyWjLM2KaLIOUGiMfBifGQemzWqUCFqK855MPfZ7b
	JGABQI5f4q0UYSnR6B9EKPWpn90hHo0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C8EAA41A98;
	Tue,  3 Nov 2026 08:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05ECD1F000C1;
	Tue,  3 Nov 2026 08:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694773;
	bh=qO2aC5uaUEhaDSdNYo+SgI2KvSgkhfT6uqbSumdTfBE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ACnU884MWPyAYiASrPu94YVhKiQ1UYyZUVARfbXDk3uxO4Pldu86DcqY8Yx8mrCeO
	 x0YabdzJSQWl3l/YJ5yG8W55zJss5Zp6PapKnbrPdTGj6QcExMvJOfAICOv9XzLogV
	 BoPmAQuYIjOA9hFbuJff9iRGlHOxvMQ3ueCKoybS2qwlXL3VGHVgaCtI69M1brCGDm
	 6A37K8rTYWSVLtRQ6ZZsB/2qNtzS5VGpb2XwXfJO2aYCqTyFkMijOfspNUbBmbVMRD
	 Min9MSJNPg70zQBrcXu8RUILTGz6nD7YAP0m4x4/e7/bzPbErBCrMZB7afZrUNYTpw
	 mWpgdkcKGFE9A==
Date: Tue, 3 Nov 2026 08:32:45 +0000
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
Subject: Re: [PATCH 1/8] mm: remove wait_on_page_writeback()
Message-ID: <aumcI8m56_MXLb08@gremlin>
References: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
 <20261102-page-wrappers-v1-1-e7280bdb31f6@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-page-wrappers-v1-1-e7280bdb31f6@columbia.edu>
X-Stat-Signature: 34p4iu5hre9xkfnjdwqcjpdra4c6rw16
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 93CD6180006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793694774-254442
X-HE-Meta: U2FsdGVkX1+abpMnW02U1RJ3m6BKgwnT8/aOxFU9/l8Zkn7sRnV4jseQvZyTztgnKWraAGCD90yTAfzNOigRXTIEzfJSRucFqqiNwkfI57O13FqplGht0VTsF4BdoZb2zC0yGVfKkUcgUm2x/7+tsTOANNlFvhBw4dtsMLpthbiEUBoD8d+eskDhZDstXa9r4BBuC6PIyT/CoAgtdnn5cbuTIFhO2cES4jilzO1U1yAqCk9/Ylx0kjzEXqdA3S7nOsWU2sGp4ATVBd3dfzC3ZhAdmgYzINiLHnBG0kELLXE4zsWpu7fGv2M3LUo56dIoKmWjd6fmW5EOpymAnvq++PAqu758xolMN/xQhGKuvtpoBNHnh9+4fub/inrwfRLRSzmFkzEfQ38B2EYSDYiRnly9TAcLEoY9M44hs4tskhPV+mBepVre3YluZ2dxNWOyGBz6KbavSXkyKOD9nU/FHO9N8diM2I5gC32rrbTF3nwYh4mAkpmuEwNXJ7VP8naBRwglw8hj0YGDfnmpAk03igwmodB0+zdDOytO8uuHzJ3Ep5xGujUfdOHuzcTWZ0riKkLGWYn873O50rjn8DBsLr5WGXxvUlzMCbbwouf3CFGCQcG3FFvRgm1s2Vxh6xnilsXQjY2CsEWcatVclb0aNmTFwEpoYFBMqSrnLz4y3iRWT8a+yiSSqbbP1mDQbC1Hhn2o71V8KbVRHH1YZTcBN7gURp9tV1fUABydfONPx6NpBoVZSpUyGcBWXwz74QAMGfnGHsQI2f7C4f4gUl6T1solDgLRtD9dXUFAvDVfH76Av4ND8YSt5IZKnImeeSgnHmkV37skqCnzBz0cYY5eyvh6A59hG+zs42Xy5TmCY0hEuzlzIUY2KjSKK0RX37eB+CF7Dwk2+gGL7qh4rBJpDzWRglonc2v50T2w+L6loLsGipKc89jRV9zL6fxTkBbBiWD/D5jiOdN09aF/Sxi
 A2IJU0QQ
 S7coonL3gFQ3GGTe/+uPaIsIPTWyNvL7R7mX7i0EnyusF3JQgXholhpZxo5sJLhfTslB/TbE1HhRFNpe+sswhCNzGfI2eFrbeASFYRHZQoTx0shr5wYtYrkr5JfVTdoLo3dAWlyxsJFjejCUFwzQ7uUSuAUUxHdP/uzZ1VDYowsEhShCa6nsVKVwpc1ot5EOiwZusET3xqAl+7WmSvawgcwlxTuATJA9AKV0wZFrlP4dSihd5T90gqkW/llpdCBXtyaKMM9pK4p95TlqYvBMsBD3RsvDLinluYSlAmWnKR3QxJXTxmIYvpQwSF2VkFbQj5ptTUShfVHUChDrMb+nCRa4YNXjo7CQIVxVmsw1edU91zBDx4fOx7FZWNHZ7WN/Saq8b7alTEpJoB6Ui4EEFu6xpn6B4fV6qsBSqk3gOD+OFrKqvTsGl9MHPraOllXxl8Zo74YJgrKwU0EU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 05:54:06PM -0500, Tal Zussman wrote:
> The last caller was converted to folio_wait_writeback(), so drop the
> wait_on_page_writeback() compatibility wrapper and its declaration.
>
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

LGTM!

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/pagemap.h | 1 -
>  mm/folio-compat.c       | 6 ------
>  2 files changed, 7 deletions(-)
>
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 73af18a37367..c0f7c06dc6fd 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -1299,7 +1299,6 @@ static inline int folio_wait_locked_killable(struct folio *folio)
>  }
>
>  void folio_end_read(struct folio *folio, bool success);
> -void wait_on_page_writeback(struct page *page);
>  void folio_wait_writeback(struct folio *folio);
>  int folio_wait_writeback_killable(struct folio *folio);
>  void end_page_writeback(struct page *page);
> diff --git a/mm/folio-compat.c b/mm/folio-compat.c
> index 6212fdd6761a..f880110ac980 100644
> --- a/mm/folio-compat.c
> +++ b/mm/folio-compat.c
> @@ -23,12 +23,6 @@ void end_page_writeback(struct page *page)
>  }
>  EXPORT_SYMBOL(end_page_writeback);
>
> -void wait_on_page_writeback(struct page *page)
> -{
> -	return folio_wait_writeback(page_folio(page));
> -}
> -EXPORT_SYMBOL_GPL(wait_on_page_writeback);
> -
>  void mark_page_accessed(struct page *page)
>  {
>  	folio_mark_accessed(page_folio(page));
>
> --
> 2.39.5
>

--
Cheers, Lorenzo

