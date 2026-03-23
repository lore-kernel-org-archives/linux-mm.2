Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B519EC01CD
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 12:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B74F86B0088; Mon, 23 Mar 2026 08:20:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4CCF6B0089; Mon, 23 Mar 2026 08:20:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A89E86B008A; Mon, 23 Mar 2026 08:20:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C4BA6B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:20:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4FF311ECBB
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:20:58 +0000 (UTC)
X-FDA: 84577236996.04.ED4F2E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9E3BCC000F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:20:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T8IV90L8;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774268456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IykMiuIGiUdrVYe11M9T/CmSOM5FZCBrKdBDC5c/FXI=;
	b=Vm41UpmZ0W4/x96IDbWWjrqz3Ca467qiQK5XdZFCfAhqMNq8l/eZ7wWj2RZIoglDl15u4o
	WSFGSRb6CKu9ewRFyOgQFBMicF/5oM/4BFUHzitaTV5R4m5fIMVRzaApEct9VRWljSGIwe
	T2ozPFCL0cNHEtvjkKwNIsI7dul6300=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T8IV90L8;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774268456; a=rsa-sha256;
	cv=none;
	b=VGkQfsmwy77H79eSEztG4vmsf+EBJvRnBM6gYTrExtGlfLvpcXSyiYPj5qbFLShJX2PgCA
	AwOuquEmLBkfo0WkH5NWjCJxzsZbXP08A4op05PrNdgZJDaW/deKHvxHqTz2TeeFZIjM/e
	A42oepWQS245Q121PIhy7EgUO/fD+mo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D199841735;
	Mon, 23 Mar 2026 12:20:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D4DC4CEF7;
	Mon, 23 Mar 2026 12:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774268455;
	bh=6f8GRyqWf1PPAy+kPm5cnF4lf8sdaWj3CMsWHt2BHW8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T8IV90L8rAdSvoLlyZDnZG1jw89kF8h6/O3939tCpBeQhfOFrE2uDSvHkgm1Jmqed
	 1NmZu8yGYA1nAq1rkbRDT3RdEJB9+RMjVWWWWwOFWWGLouQjZamVAhveZ9wFUevGok
	 HKjiYhT6TW5HkXmpmgXSupkiQ2LzNm8uDFMUtxAEa6y9ts94e2d/2sNCsjNdiO+1lC
	 Kq7O6b25obd6l3vV6kR0D2yszWxbG7mYUMDG4W3wfrdmqo4mjACvHA1MKEzBTpUU03
	 9hEqks3t3aH5oLX6jBcuhTaEtk/QoFjlTldtBJ0c3a/WrxRdNDF7r8ZV7Fz6DuUIiL
	 8uHVJTnjjZQ5A==
Date: Mon, 23 Mar 2026 12:20:54 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Ye Liu <liuye@kylinos.cn>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Wei Xu <weixugc@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Remove unused page_is_file_lru() function
Message-ID: <a08c1b34-78ea-40c8-bab0-a7b0d494630a@lucifer.local>
References: <20260323090305.798057-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323090305.798057-1-ye.liu@linux.dev>
X-Stat-Signature: ht6gwbmbmneqkjkrjg9baghjnu9y4pmk
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E3BCC000F
X-HE-Tag: 1774268456-447701
X-HE-Meta: U2FsdGVkX1+1e413sXZ0bCCRQ/GvOwbcmU2baTBeTX1L77BFnEikztLAvsU1qKBqzk+NCq7MbKHAGuvvhXRmcxcYXMLFIJBvDMX/xR73aTju5QdYXpcNVjx+hqWlTXmal8Uv17ASKKk+iRW6KgvcLZnwn2IaDg+uKZbRG7STgC8IENZoVdkxdUEVJosHWcU9quHD0cuwFdaszHnVzNgh0Pxu6xeMKWhZuZfhHZBh7kJOm9/tW0NWq0i0ZIG5w1KFSwgDaAHqU29vCmEKQioGwsdYYxCSUC/G3mlqw0Ut3GHvDFhiOSuoda6hBYFkf4GkKDi22UoH+Mn3jrdHODU731AAvcxZjzF6v9QPOqomMO4xha8Q6m7jAAybVHBLXg1TNEaXk27D0ZHyxixWYhqakBrZkdyuw/XKBrANR3wUWsRwVZBvpyrKknUGXPzifMJlxdciDHyNPjRwbdy0U0ttveph5C0hXMq3ZMzSGTa3unXl4zFHTGBNX5oSHqZKs5E8+MOPqE5Ro2MiFK9epKbUDVqOE17QBZTSbOfmShtZ8UcPUQJdTGbyqsrR0xknMAkcu+g/VKAbeTjTLx4Xk48qAuOyw7E89nZkXy6gzejcRyqh5Lh6Im2zIiN8WjpclYtoyDeUMBMKnthaTR9WxcLUWQhUpzVfYYPDhohTLTa6sItgLyqDity7owc15JNYRzrz1IrUVkV7KiD8HS106EpxveF20MDxSm2K8LIxgtmzXrGkk46HIhSwvrVn+a9AoKaLfcGo/bogkYAIU4p/7VpFKr+LC67U4c6iw4fxq4Rxo6C/zjirUXAD8r7Fl5T756nS/7kgF3nVn+EVUvTeGSwL7S9CCL0g3mvmyA3xO4xut4Bt98c5x9UmIpnstAeFPPrL+eAV+asBry2bLv2AM+/xkozHkDLORGHM722vfzevnQb91G7boCCBhzVL/Gd4I5Nye/fNSm2aDe3VcYpZufd
 eqfmKkK3
 7h+Ql0FEH5ramVz0GjBMyL7535q4i3OGmazan3+88hyFXbT1NbeklikFhLhsYjm7a5SG9HO7xvfg+2Fr2gG6s9I3XeNZ/djIaW6AHHdqICUOOuB5IWGN3buBQBU9MbwenvSoDNk00UAXy/QvcTxaFxENELNYhMYRkidMb1OloavREuR0+kGnmyQiK2XHzcR/c5899eOASuDQzGKJiGO68+7jlGvxKwpJBmMCkiIOt4LYtnIFodPxJR6igVgpUfjZ2XA03BP90s1V2ec1vJzZKGHy5/Hlda8WD506q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 05:03:04PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
>
> The page_is_file_lru() wrapper function is no longer used. The kernel
> has moved to folio-based APIs, and all callers should use
> folio_is_file_lru() instead.
>
> Remove the obsolete page-based wrapper function.
>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  include/linux/mm_inline.h | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index ad50688d89db..4fa480bf1dd2 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -30,11 +30,6 @@ static inline int folio_is_file_lru(const struct folio *folio)
>  	return !folio_test_swapbacked(folio);
>  }
>
> -static inline int page_is_file_lru(struct page *page)
> -{
> -	return folio_is_file_lru(page_folio(page));
> -}
> -
>  static __always_inline void __update_lru_size(struct lruvec *lruvec,
>  				enum lru_list lru, enum zone_type zid,
>  				long nr_pages)
> --
> 2.43.0
>

Thanks, Lorenzo

