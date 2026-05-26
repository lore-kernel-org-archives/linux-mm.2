Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C014CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:05:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83DFE6B0088; Tue, 26 May 2026 07:05:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 815DE6B008A; Tue, 26 May 2026 07:05:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72BAB6B008C; Tue, 26 May 2026 07:05:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 617D66B0088
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:05:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F2A8F1203CA
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:05:24 +0000 (UTC)
X-FDA: 84809289768.11.95625F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 66D8340018
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:05:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i+2Dh7MF;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779793523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qk40xgulls2bsEySJ0d4/5IyTPrAc0LfClUBUzlGCjE=;
	b=7Qs5I5oXrSWPYLew8l6iT6pRVESpHy+bRPiowfHLVjFp0GSnWwW7UV7Di6hAO1fSlJYDWP
	gHHCdmQA09KKtaGkBu1Beb5m6EOeE7YAuFoDg33QSMM4PRzpZuJE+wpk6wSBZdLYouzyJt
	6Z0DWRFFNMVzEYWCbXd9/hxJ0gpVVYs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i+2Dh7MF;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779793523; a=rsa-sha256;
	cv=none;
	b=YjzyLdqcG0aunZfynDZC5S2mbUd7dTlvzTzFovRFXuveYMRT6My+zGBCMyQmYMQ3oMbzWW
	sl5ibjz6tRLWHBQW2h9yrC72qivcmBdiVLUQsMzF7yj16gBr/6CbOlRY0WfYOsxzr35RQK
	tY9hDLfjAPaj9sZoxQ6h6X4GN36b85Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CBD32600AB;
	Tue, 26 May 2026 11:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E4B1F000E9;
	Tue, 26 May 2026 11:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779793522;
	bh=qk40xgulls2bsEySJ0d4/5IyTPrAc0LfClUBUzlGCjE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i+2Dh7MFEtK74+pZLmmNLDVqGWGe2BE+kd3pDCqQXGbpTjL7Logl9E6fmQ0ubku+1
	 nyOjwqL+o0m5Ts5cROkskSsx8BBovl9L8IyPmf5m4cF5bkx26ThEevbfbn5KNW9ygl
	 yXWTAuQX9CmIwRFZUksstdZwplvejzDeV1LunwDhE+WlkkWABJoU4quxu4Aa6r1l9s
	 EKOxiCJ0cQvS3yULxl9RIkuNSKc0fB5rcyvNUYLxymB/EWdGPLZ09F6aUnfWem9QML
	 xeIJ6Kzi3M/GWTMKKHZ0SypcJlgX7NGSp7a2OopiPU5ihCB+0KREcp481g6H5y5p9w
	 2mUtT7NpMbH4A==
Date: Tue, 26 May 2026 12:05:15 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Yin Tirui <yintirui@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Yang Shi <yang.shi@linux.alibaba.com>, 
	wangkefeng.wang@huawei.com, chenjun102@huawei.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: update file PMD counter before
 folio_put()
Message-ID: <ahV8PuP2sg7fV_DR@lucifer>
References: <20260526101337.1984081-1-yintirui@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526101337.1984081-1-yintirui@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 66D8340018
X-Stat-Signature: hzhem89ai3a6jw4je4snqfits1d4uh3z
X-HE-Tag: 1779793523-246964
X-HE-Meta: U2FsdGVkX1+r3NyfRUQx79wOJqO2CfGUJ6uIYei0+ND/cgdcmk7aca3d/FMvrnvQga3uZaCrT+y4kCs629xoDCITuVhL7w08uzNfVftpZ9LTI9kbX+UxO9kZCmQHZR0Iv6aZrdeS1oXmFhf2IOIJOJYYMYrGFx7ZkPHzdrLfT1HyomyNMDHyLX6MvaJfvhbybK/M8U+93qz4xC5SEm+fr1+TbwAxw26vyp4x9o0SSfmuFT1rdaEAIozNkYf1tb1CMI5A52bcU8x6Nkf1NH3L+J+CaQoyap7REQXikzAo7VtfpurJ/fbP7cK1V6crybF97yF/oc7i07FHPQI+rnyGRCnSEQBcagahdleBi/D/jTgwiIHkStUJf9mI3eMN/xHpsgSa2uOi346MF6UvXItjVSaJ80DGmvV1duM+lpo7j5LQfLXHbXY42N4DVTddY+c3cyunb0FRXbRJmU/+7XQDiemIl/Axz6V8fNjo27E6acttROOhhQGDNqrwWPf1B2X+k2xvM4Qwb+d1UcHPm5VRxbZo+Lv0OuPdaTOjV1ZqOC4PGvtgCuaCd1jtTkHJdzygtsRjpk/oY4C7lHsPdBqqIg8wEVdfnwVC3qrfHD5zCmNm8msuxGWnmLf7GGKZw3BZnF3tI0VdPjtBGo3SNExUmrhkfEqZUZyTBgpJTouAQFJTPDXBXlMIASsdhR+PyX/piJPU4NAutCk66eiiZ1NxsgwzsQ0CS66bhqTOxIPjtqieGpq1qzOEB4GhbfBayxJ7GQyv+Puko0M0oGEHy48DeS7bWQHe0nMAUA4fTgNTVksoOwpe4v+tipQXdcrKvDIQp/ZROrML27DphL4Y97JU6s9HeOTGUpJjW/YEUtCZrGT+Sdjg16AVnVwNb/t2T3rpwe5N2mBM4JslNxswqLj+LQeTFd3hZkX2JhbWnN44xberUBweA1f7Vqpg/KQ6lSz8tpkPoX+NQDnNr7IL5EA
 fExQIeMZ
 xmwrD1MeILy+bQNvZdPwbTuSspN3Q0V1BRMpC5hjs+auYovjfygf495b2MuXXUyhV0z1228yihbZuud7RO/SPiCQWD4z04TGPsxgDs5/RmNdKrg4VMkMKGyJb0NAT2/cmvpyjJX5idDbm+k/2hpxsM6vfIMc8XNz0Cm/k7ASLBJlEnuvNbnq0sn6mrnCGxvf74ZQ6ctD7VRH0OzGR7zX3B/3Km95MnyiPXup301MGOGeeP2DSJeQQc5fftlXXXedjS/0YQRn1AL4WJGQIiealaIqyRFm+VaEbawnDTLlWTx5swzghfF9KMDULy7jQQ7iwWNdnPQaA+Ao/RJUe0vreDROtOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 06:13:37PM +0800, Yin Tirui wrote:
> __split_huge_pmd_locked() updates the file/shmem RSS counter after
> dropping the PMD mapping's folio reference. If folio_put() drops the
> last reference, mm_counter_file() can later read freed folio state via
> folio_test_swapbacked().
>
> Move the counter update before folio_put().
>
> Fixes: fadae2953072 ("thp: use mm_file_counter to determine update which rss counter")

That's an old commit :) I mean I suspect we're probably not actually ever
dropping the folio ref to 0 here since we never had a report since ~2018.

The page cache keeping a reference I guess?

But doesn't mean we shouldn't fix this on principal/there being some way
this could happen.

> Cc: <stable@vger.kernel.org>
> Signed-off-by: Yin Tirui <yintirui@huawei.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  mm/huge_memory.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 0135c29a4372..a5f4a48b7b77 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3145,7 +3145,9 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  			if (!folio_test_referenced(folio) && pmd_young(old_pmd))
>  				folio_set_referenced(folio);
>  			folio_remove_rmap_pmd(folio, page, vma);
> +			add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
>  			folio_put(folio);
> +			return;

Hmm, sucks to duplicate like this, but for purposes of backport and getting
this resolved fine, we can clean it up later.

>  		}
>  		add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
>  		return;
> --
> 2.43.0
>

Cheers, Lorenzo

