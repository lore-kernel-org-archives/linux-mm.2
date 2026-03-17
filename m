Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCA2DF3381B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 09:20:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 346386B0088; Tue, 17 Mar 2026 05:20:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CFAD6B008A; Tue, 17 Mar 2026 05:20:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 197C86B008C; Tue, 17 Mar 2026 05:20:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 056F86B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:20:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2B9FC1895
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:20:23 +0000 (UTC)
X-FDA: 84555009126.18.5837240
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 01AE11C0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:20:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q3mMbdgS;
	spf=pass (imf18.hostedemail.com: domain of hawk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=hawk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773739222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LfLXtVxxNE8nzAywE0kTiWiOxH/ZCpfr8rqV9cjn4D8=;
	b=1GSMUNQTHl4JW+Gr1Biuodm5D74nZgCuqbaOs8NaTDhWLUSZvvEkADNJx2QX9osl4x+u9r
	Z9pr/1RN7j4NhDCSaLyY4UR5BCleKN5hUTSwovh3Z3mmdfIcfK+irBYaiot/5vE0PAa6s+
	7nGKnMxVkshCrudxQFz1YTA0w8+c0+E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q3mMbdgS;
	spf=pass (imf18.hostedemail.com: domain of hawk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=hawk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773739222; a=rsa-sha256;
	cv=none;
	b=KTBfIQeD3sA2k0k45QD62mCqNa04Dk/ap2y7RYmMa7CAWBagcWoK5YkAatYmopCiDdFUJZ
	UcQvpL6+9qoYkYLOZ9VWl1pyBWApywV14Fz0upDAuOyYx5HB69Np+EAsQumpVswoqHtzbl
	HQ7plPzjMgBs5jyCNp7Sj92uU/RlUTg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4196F6132E;
	Tue, 17 Mar 2026 09:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F197EC4CEF7;
	Tue, 17 Mar 2026 09:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773739220;
	bh=xP5eeh+0a9lPEEEUwZteoXw337RUHoxL4t15/sE4OyQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Q3mMbdgSSCoLb+Sp3+NLMDtSmduFKJ1HwBvWTNYqaZZrhOMgjV3NLCz+1Mo80CqlV
	 mA2/HTSJXUeM6c/hGvrXdQO3BlsuYbjvXvPYPFXZB81glWCytcEIHBWi58Dk1yXGux
	 wvBrH3ZVkhAo9fxbiWu7TKPHrUaPHgz5VRNHuNoESIhN5sBk4/itodd6tiWozDEb3f
	 sJBxbSQ3etYNS/ptv4SVDIsmTKRDWs6MfUTieQcQVvLcWI71Fa/BZwrrzOJKTbqXhY
	 XUbs8zOP7T+vpbfLLu/MbQ7V61SISUqGtsTc9IFXJKnoFMX+7YRldqFTvi5ou2J/Zm
	 pON1rcXFZLIhA==
Message-ID: <ebd00055-d4aa-4612-8bf3-ef0a308512f8@kernel.org>
Date: Tue, 17 Mar 2026 10:20:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] mm: introduce a new page type for page pool in page
 type
To: Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org, netdev@vger.kernel.org,
 Jakub Kicinski <kuba@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Toke Hoiland Jorgensen <toke@redhat.com>
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, kuba@kernel.org, john.fastabend@gmail.com,
 sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 mbloch@nvidia.com, andrew+netdev@lunn.ch, edumazet@google.com,
 pabeni@redhat.com, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org,
 brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
 usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
 almasrymina@google.com, toke@redhat.com, asml.silence@gmail.com,
 bpf@vger.kernel.org, linux-rdma@vger.kernel.org, sfr@canb.auug.org.au,
 dw@davidwei.uk, ap420073@gmail.com, dtatulea@nvidia.com
References: <20260316222901.GA59948@system.software.com>
 <20260316223113.20097-1-byungchul@sk.com>
Content-Language: en-US
From: Jesper Dangaard Brouer <hawk@kernel.org>
In-Reply-To: <20260316223113.20097-1-byungchul@sk.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 01AE11C0005
X-Stat-Signature: zmj744t9yq3cmact961emrixoxn8jibh
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773739221-240909
X-HE-Meta: U2FsdGVkX1/4fzrePQVoFIZbTlOGHBot8QWrHy1ZWKsihwzfHDHe9gk9MFK5CBK7/c/S7t1Tqxh0Bo3SkvjkemtDNDZ1TL6r3u5CngKOwmTGkWd0hPwHcjkfcCDrHs5lnJrVRX1GYSx/cAsqIrB/mx2lu7qVsvXdyyW+L62gVZrQG04eQyUstOSslAJAZSIY8lvtoRIDRxCSsYxCTj9hwf9NJRcAW6+jP+QEwIstILSM2E6yEemhS1N6l5350VAO78/OobXgbFxguUe8NmdebDdbX4WT7uJUsoOo9PON0F0210U4kjTpZu3eau5kWkGdxHEMoPvQQoZLC/BiWwd7w1Twlls+kusabD+Xq5R2DSqgibmrcCV+jNJ8BHsGcWig2ZxIuAYmrnaTspMHxMstJRLZo/b1hTWDqiJqW6V9RWQhgkF5e3G7N9mcrLymJ26ugNd2zmfO/iNaoHrA047oFHmHkR1/TZqvhINq5+Crhd+J9B33+DtBmFDjL5XSvuili0BnChdTEP1NlH/192vHHWmR8wqdaKVbNzRWm2mf5/L2w7AiB6bZAJZi9vkzNZ5X9ZCFCgM8EIO64AvxSkuUYQld/d8wdfkdYiuoZl4c3ecTCIILEQg06toiI70Ltfp75AEpTppn38AfJm+2tvBFSMNrBFX1cjK8qT71t4TxxnGTMWmTr3P9S6o+Hx3GNmUKVrnjwSV6sI8LQJsU/lbvejWzouEbEvDRwOiTmTe2656t2u+3xzyPhbY27F9lk4feQEAoowMmmsfjF0HjxcFBGHXli164OrcLe12IG7hwJ6UgFUolSipHqo/5ceIgNCj1hpvRPxXtWmWczYQ4VI7QFP1iAb0m28UloZXN1iXOf1bA2BM9VkHhty+VnxI4HPq4kkB1lQugvNnXs1FVdgofjP3vyrmfHqegObk8x4ZHaVxozGwdgiedvtGfK7l4ycTS+WDWw7mNadZhfE+KHBH
 qsckPNBo
 DKBU20htxXJbZDwGKVnZ2D0EXNQnzssRxD+Db741987p6wWJ3XcQ7H4KY4mSXLlUTFByD+XwQDEjVIExexH41MhXXXjgHuO+CdKd8LHJbV1CdSV2OWIOTRKxTVxwFmBnlBt/ULJrH7gX1fuhLTmZNfKY5NAf9YDQ6h3KYPCLJ9RwMADYMDAq5hLByr3P1eo73PNaAgpi82Frtwm8Ig0MQ+ZNbDHxhjiwrogRmvbelNq6fbBbGbhK5eYzJhsQ+9AyP6DEVvSWSWX7bmH0sMOdWNV6a0DhFeoVHm9FIAEVvkXBBfJHIlvEo0BptM3upK3nJd3o0cUpW/v5Y24SJMJtQ6myJnfph2rXwY7S/7g3U5VQ7OF+PGJu2ZmIg28W6kdmqOioPSp11VlOgxUULs5CeDRE1aujOCZn3Zf/f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>




On 16/03/2026 23.31, Byungchul Park wrote:
> Currently, the condition 'page->pp_magic == PP_SIGNATURE' is used to
> determine if a page belongs to a page pool.  However, with the planned
> removal of @pp_magic, we should instead leverage the page_type in struct
> page, such as PGTY_netpp, for this purpose.
> 
> Introduce and use the page type APIs e.g. PageNetpp(), __SetPageNetpp(),
> and __ClearPageNetpp() instead, and remove the existing APIs accessing
> @pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
> netmem_clear_pp_magic().
> 
> Plus, add @page_type to struct net_iov at the same offset as struct page
> so as to use the page_type APIs for struct net_iov as well.  While at it,
> reorder @type and @owner in struct net_iov to avoid a hole and
> increasing the struct size.
> 
> This work was inspired by the following link:
> 
>    https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@gmail.com/
> 
> While at it, move the sanity check for page pool to on the free path.
> 
[...]
see below

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 9f2fe46ff69a1..ee81f5c67c18f 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1044,7 +1044,6 @@ static inline bool page_expected_state(struct page *page,
>   #ifdef CONFIG_MEMCG
>   			page->memcg_data |
>   #endif
> -			page_pool_page_is_pp(page) |
>   			(page->flags.f & check_flags)))
>   		return false;
>   
> @@ -1071,8 +1070,6 @@ static const char *page_bad_reason(struct page *page, unsigned long flags)
>   	if (unlikely(page->memcg_data))
>   		bad_reason = "page still charged to cgroup";
>   #endif
> -	if (unlikely(page_pool_page_is_pp(page)))
> -		bad_reason = "page_pool leak";
>   	return bad_reason;
>   }
>   
> @@ -1381,9 +1378,17 @@ __always_inline bool __free_pages_prepare(struct page *page,
>   		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
>   		folio->mapping = NULL;
>   	}
> -	if (unlikely(page_has_type(page)))
> +	if (unlikely(page_has_type(page))) {
> +		/* networking expects to clear its page type before releasing */
> +		if (is_check_pages_enabled()) {
> +			if (unlikely(PageNetpp(page))) {
> +				bad_page(page, "page_pool leak");
> +				return false;
> +			}
> +		}
>   		/* Reset the page_type (which overlays _mapcount) */
>   		page->page_type = UINT_MAX;
> +	}

I need some opinions here.  When CONFIG_DEBUG_VM is enabled we get help
finding (hard to find) page_pool leaks and mark the page as bad.

When CONFIG_DEBUG_VM is disabled we silently "allow" leaking.
Should we handle this more gracefully here? (release pp resources)

Allowing the page to be reused at this point, when a page_pool instance
is known to track life-time and (likely) have the page DMA mapped, seems
problematic to me.  Code only clears page->page_type, but IIRC Toke
added DMA tracking in other fields (plus xarray internally).

I was going to suggest to simply re-export page_pool_release_page() that
was hidden by 535b9c61bdef ("net: page_pool: hide
page_pool_release_page()"), but that functionality was lost in
07e0c7d3179d ("net: page_pool: merge page_pool_release_page() with
page_pool_return_page()"). (Cc Jakub/Kuba for that choice).
Simply page_pool_release_page(page->pp, page).

Opinions?

--Jesper

