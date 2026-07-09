Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCE5EC44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 08:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B70DD6B008C; Thu,  9 Jul 2026 04:24:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B48516B0092; Thu,  9 Jul 2026 04:24:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5F016B0093; Thu,  9 Jul 2026 04:24:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6CC6A6B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 04:24:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EE3C4C29B0
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:24:11 +0000 (UTC)
X-FDA: 84968550702.11.0D328FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2EE9BC0004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:24:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vj2jr+Ri;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783585450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dfjX/HpXJM9iYsHnQmF5Xud/G0l8dqRVgfzx5MY/UdU=;
	b=PheJVldUbTrzzLavB5Ro210v7z+xjiA1XpA3KzGIEfAeNOe5zPJLP6uZG489ZUv8auISDA
	gg7eYF92wKERWHYTXVCSm6MhdChJ/y7+CD6aNdmNIXyzYJeHfAuFUA4QXc6+Dn8xWqGzCB
	O7KNjcGTCIRTzzUlZZ3ELh7YSTy2JbM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783585450;
	b=kZUUEatkE5HAYSmriqRpLJIb5lOLzaxYkusPLptV7RjnW24QPytxi2UanuVO3yG0dXy2iM
	lgHWajTok9Bc+C5w1fUPWlBGV1FV9gkhfxJC0rXQJ3Q60wM527JP8686e//9MeJzpHrwc8
	RYsACoZ/APLuAtArpjZzK2gHgo56uUA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vj2jr+Ri;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1121B40215;
	Thu,  9 Jul 2026 08:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61FF1F000E9;
	Thu,  9 Jul 2026 08:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783585449;
	bh=dfjX/HpXJM9iYsHnQmF5Xud/G0l8dqRVgfzx5MY/UdU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Vj2jr+RizoHzfnZ5p2FylBywsVmOpAC2plcgd7ldnfHG6OAUX6knGZHbaw+PMAt8e
	 LYSWzFiZVgZktom1pFDjjT4vwZa9Da5lTS+60/iOtp4K2T47YtDDADC0DbDKIIDdH/
	 3pSCAAoKssrVJlFRxWcODnqg1alpP2Faxk8Isx+hmaXP8Z7JraeT7j9tfwUbo+simF
	 DIetRp+Vh0TsWVqh3YXzVQoZswWV25iCKe/slSrGDf96LujHx2F5OdVieWuKb2DoEh
	 fOpQ0izNXig6tRA/HCi6B+wYfS9yielZg91S/BrouO2Ht21xkbphxg2cm52U8Lau0v
	 qIh8Lzku+3+Sg==
Message-ID: <9fc67666-ac70-4d03-8836-5f8a9f5f1ff6@kernel.org>
Date: Thu, 9 Jul 2026 10:24:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] mm/page_alloc: make sure tail_page->private is
 zero at page free time
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6@nvidia.com>
 <20260703-keep-subpage-private-zero-at-free-v2-4-2970fe777dd6@nvidia.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260703-keep-subpage-private-zero-at-free-v2-4-2970fe777dd6@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2EE9BC0004
X-Stat-Signature: rsfq1xcf5etoh1rcpd9hixqtta9b97ag
X-HE-Tag: 1783585449-91829
X-HE-Meta: U2FsdGVkX19Mfu5B5X5t9thBRwJK1e6ju1UdP+hWEiu4xsVdCTooGL5bAGuaKysi4jMMi+VpkZ9eddvd0TcF2yg5x3dNcNS9kJh0hGoJbX+wYlaV3xx4V9Tsg/u4YOKDdIZo0e6jXSbfeln+26ihfMp+iUvJg9Bhd/6Lrcxpo3aD128HfwBiGRo5IAw4QdX+ARiZc+pkRQFLGKd6GxhSInmDMRnX95lBTcOssXg/UoXLJz7Lh2dSjeac35BlleWhRhO9PbRgd3XSzjqMmyF61hAz3sv65n2FqSkcypZggL+TeVY9VtKtcS1odhr8fW2Y1Y17RuaqvVStgW3PCNesf7Qe4U3rDQz5rRiy86agVTHvkWdIkbUK5vt+mUR7CrMianuIfovUbqduFgHAj4cn/VCVYNiBjw9g9L+WYE8HDqaI60vLhUS9/w0vNR1gXFMeyP9Ttl0FCfrrZ0PrfX2xZeDFK6crVulf0TAWHWw8OhlHnR7bbTG1GD09yklBCPCVsrr4sd6AxUOSrJG1eXzfoRa8FVcVmZs5HnMAKicTdtOPefxEKySF914H5MTfKiDuMWVONm/BXxkpOKtx1PtlyOrxjAPa+9UvRgtqhPSRZjIq14Y5DXd9oNo2Xr4zJNkORwPhLpqR64YFsFaivkRLGZ+UpvAZwvntpqDkZ4nzjzMTUmOKpw+FPsufTxSCa/97OkQdNLSUPW3+nDXOSwFzd1ZIPUYM9atOZcW335a4tkPmy299HyAjNxrlgvEhk8p6kT85Xd3Cz1yHuEs469YGjWn1OKVJbNr0CP64uYDYdAF6MrFoim1CIDtIMZVj3a/1JH9fOBxKD3FUqoYb9y9hMSljPbfRWEvkSP5CMSUqQuiQTlzLj4TugD08iHWoOb4QUM85dm5ccXRUXKmzAw2t3DoWdw9auPX7nDN1kxJ5znb/SfcpDuWy/QT7NNEdL62eO0tumLBhUVOTBLDSjSl
 ap66cpnA
 Geve6nD5Cd8OgU0sn3DuT4NUnd5roqDGnpzl//5Ue2uTg5G5YDLGvaaUU0py6rE+FA7pr8J2mjEZGWCBEZ7kR6RQ8RPApmcKDkMfqVRofLK20V1pfw0N32xRqwFEqvtX1CPfkZdb7hTuKzdV5oiZ6g2ipQ0ynAu93+YvOBLl/LM0kFuqHHWgB3xYSGK4v8zLLL/QGcqq51fN/FW8oKeH4PLaYlkpzAMYOobwlKe+o11VEFqraRW3lTxD09aDSE/yCLUXWrL7uhGKAMo6jd4KjDsst8nPV/XvPct5On2x6wFhcoL3OeO6bcUpxbcfdYkffcESohPsxvVWSVSkY15sOFyg+y48MeDLiVkSA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/3/26 15:47, Zi Yan wrote:
> Any code using tail_page->private of a folio, a compound page or a
> high-order page is supposed to reset it after use, otherwise ->private data
> can leak to new page user and cause unexpected issues. Add a bad_page()
> check at page free path for it.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Nit:

> ---
>  mm/page_alloc.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 762d9b6bc792f..723a52dfc80f6 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1376,15 +1376,22 @@ static __always_inline bool __free_pages_prepare(struct page *page,
>  #endif
>  		}
>  		for (i = 1; i < (1 << order); i++) {
> +			struct page *tail_page = page + i;
> +
>  			if (compound)
> -				bad += free_tail_page_prepare(page, page + i);
> +				bad += free_tail_page_prepare(page, tail_page);
>  			if (is_check_pages_enabled()) {
> -				if (free_page_is_bad(page + i)) {
> +				if (free_page_is_bad(tail_page)) {
>  					bad++;
>  					continue;
>  				}
>  			}
> -			(page + i)->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> +			tail_page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> +			if (is_check_pages_enabled() && tail_page->private) {
> +				bad_page(tail_page, "nonzero private");
> +				bad++;
> +				continue;

It could be moved to the already existing is_check_pages_enabled() block
above. The flags reset doesn't need to happen before the check, no?

> +			}
>  		}
>  	}
>  	if (folio_test_anon(folio)) {
> 


