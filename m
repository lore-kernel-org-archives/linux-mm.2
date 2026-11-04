Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9EC3606A329
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 14:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=frHKW37W
Received: by kanga.kvack.org (Postfix)
	id D55136B05B3; Wed,  4 Nov 2026 09:59:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2CE36B05B4; Wed,  4 Nov 2026 09:59:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C43186B05BA; Wed,  4 Nov 2026 09:59:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A92E26B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:59:30 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 442C81203D2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:59:30 +0000 (UTC)
X-FDA: 85397745300.08.31C1E77
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id A1EFE10000E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:59:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=frHKW37W;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793804368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T5ANptYopnl5748/p2sHm7qxklUriu1qCPoMwTQ9pxA=;
	b=ZaPTRGwLlmwntCs034aoQDdNxNIvWxAQw3Yg7ISApNeT1MZyyo9X8eVkMDwP4xWhAIvXIR
	d+PLxCM3K4EclVxCZMV48xrfNBYNlZULKaMhDsWY4lzsopmyNx8QIngkZeSl0rCnWeTN6f
	tbr9Fa/wCsjxgTrUwm0TOt0sR9UVWo0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793804368;
	b=oMZzB+YhfoWRSScIhIuI8qkU4hwJjEQGYviRvHYTG83Hf6jomkxa996EnhdB91hFLz9PVp
	ahDDSLe75tRyRRhLUDwcEOFAeIMr2C4ZwjNqEVYh6tFF0CNRpJMfyQ70i0ddkG2x44RLhX
	y249WpSMI9VZuiHx0HIPlejderr3vNY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=frHKW37W;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E28B1419CD;
	Wed,  4 Nov 2026 14:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224F81F000C1;
	Wed,  4 Nov 2026 14:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804367;
	bh=T5ANptYopnl5748/p2sHm7qxklUriu1qCPoMwTQ9pxA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=frHKW37WQrrbFlLhJok5407YPn09wzEYmhPuqaufJ7K9HzQ4BMN26qtMcMsBDoQNO
	 fZw4tBoJFy+J8NJaMWS1hP63l3CFB7Hai9WMz3Y8wVkvSem/QN+dbCmJaex8Rf5HHZ
	 G7p3p1z3nySVihNl3LQgcll+PCtED6bEZm9Uki1+vyseI4sxdwHKnj4MMv9CFR9Zlp
	 JynBqV4HbA6DibQSRx5lrvt6Sl1PLGa6tgkUhliNwgD887EUxGhwUSNMI1d0O4NKBa
	 v4jzyhFWgW3kM1FsNImRW3lM6C4+bPTav/gDr4MrSf/fC8LTj/w6KQgHj7E6XjWUil
	 4dDTd2Fvr9XqA==
Date: Wed, 4 Nov 2026 16:59:20 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Umang Pokhriyal <umangpokhriyall@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] userfaultfd: validate the whole range before changing
 write protection
Message-ID: <autISNbq0kLikxlF@kernel.org>
References: <20261104093457.152245-1-umangpokhriyall@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104093457.152245-1-umangpokhriyall@gmail.com>
X-Stat-Signature: cdjhhgddra7s9kdrt9y6hqoomdi1d7hu
X-Rspamd-Queue-Id: A1EFE10000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793804368-667173
X-HE-Meta: U2FsdGVkX1+mcgeLFWupbBL6pJ0lZ0WpsLW6po52zJ7u7NNgy6LPUXaGPMNsZDW+mayfo8QDz+zqdGS55VN6snHbVA8gAM/97l6cOzUs3/mnZDndBXECtR8JizXZfFcJqAbQXBoHbNrBCeBWIOxU8P5oytR5Ic53EgmYC8UENw6WpjCkMNb3H1+z6t1hhiy5f/G+J8HmyUxnEIwMnp8OkNQrE8CcpS1CHLH+Kp3j/sfigHwnW3O3wIN02kjYNrLk271YBYj32RQrhq6Y/eFn/id4jg6eRjNZRzu6h24xm7t5y0qTtFjOxXCHLxqHAnL0c0SpI+iX9qt+/hgM62C13FNbAqGJAw//OIsjBwrvfRuaLGOHcy8j+MSLfFMe3AQXdw7okTjQkKlAo4fDVF8U4YL4+dTnEbv4tq1PsjoGjPShjhoAtq/lQQeqJ0a2d1BD00FntBBrWdGRyOGnlpXBVX/AgKr5VWO4hbLmphLpT3uDF6AL1ihCuNYpNwf0ewRN7lg7PxVt/JigBRkCNWqOJncEG0YrFbBzpTl/1eVavxguvksUCmo/7W1pGccW48WECxKF0of9e6/Tk4d6pX4LyNpnam1WjtBGwMADLubwHHsy/D0tFaMWso5JiKF45wP8qAnamKZU3Yy2pUMwTFhuziIhNhnaxyekOhH7xi20O0OzpzpG6AHP0ILTFqZUYgVLu7qW49D++puJ+M6xDrf4Np2hbEvQRfv8VoFjJY97NjHoD9R5sg3wH+iVRx0NwSa0HOiJ+Z6LHqzgk7SsLNDd0PYiIITD8Am498E/IaJz+8wnnpiO81fcJrh4apEQB3Ty5JQ3uPEJ8dOhVDkqRPIy8LayoZsWY2b8jU5Bo4wV+krluiJrI6FWiRNSWgkJ9zXLA0XNvWQRCdqzPh98xBExEbAFEuo/5diG6sKk5UfSZvM3ibVW4LvMDU8L0CKHaY+cDQSA5Kc7tsdt/HFKq+m
 i+ZEwvAu
 hU7j+Smqp2BmXMnSoKtoLHgEI7l06swGIdtUWOEMNvjOVO65z4jLLDtjVEa5Y4B+ClSnYLuMe+GCGGxJVlXFQ2o5DbB3+ijxx7GDvTaauLyKZ0DhypSEA3OXdLsZL2dvReYXBjYtOH5YyoMXQ7Id9D+lvIX5MxFWLCRtK9v0IueWWKw29D3xEDeeL3FKQZcC8MiDW6GTFc9VjCzcjQq1Lz2XhzgnnJJfAl+d705uMttTpNlYIJiBDuPEaeQq0W7wJf1WR0yBsnTXPwxxNuV9VReFX/kC+PtNuaVL7JsiaBAnEe84=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 03:04:57PM +0530, Umang Pokhriyal wrote:
> mwriteprotect_range() checks each VMA as it walks the range.  When a later
> VMA is not registered for write protection, or is a hugetlb VMA the range
> is not aligned to, the call fails after the earlier VMAs were already
> changed.  When unprotecting, userfaultfd_writeprotect() then skips
> wake_userfault(), so threads blocked on those pages are not woken although
> the pages are writable again.
> 
> An unprivileged process can trigger this with a range that spans an
> unregistered VMA.  It hasn't been seen in practice; it was found while
> reviewing the userfaultfd range ioctls with an LLM.
> 
> Validate the whole range first, as mrwprotect_range() already does.
> 
> Fixes: a1b92a3f1498 ("mm/userfaultfd: support WP on multiple VMAs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Umang Pokhriyal <umangpokhriyall@gmail.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> v2:
> - drop the redundant error assignments in the validation loop (Mike)
> - drop the selftest (Mike)
> 
> v1: https://lore.kernel.org/all/20261102103621.156928-1-umangpokhriyall@gmail.com/
> 
>  mm/userfaultfd.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)

-- 
Sincerely yours,
Mike.

