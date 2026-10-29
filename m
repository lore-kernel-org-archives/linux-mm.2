Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83A03606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 19:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vuz79kYO
Received: by kanga.kvack.org (Postfix)
	id 8C44D6B05B2; Thu, 29 Oct 2026 15:26:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84DAD6B05B3; Thu, 29 Oct 2026 15:26:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 716746B05B4; Thu, 29 Oct 2026 15:26:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 430E66B05B2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:26:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A299212045E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:26:40 +0000 (UTC)
X-FDA: 85376645760.06.5A8E4E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id D022116000B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:26:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vuz79kYO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793301998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=olq2oLw59YhnpeUJwxDmzWejxUeT+/sp90poHb2MYpE=;
	b=6/nWrMEuSXexE6NQb1RgamdQhvoAsGy9Qr8wdMUEux7KOI65YmPW1hcvEfDv1bVdVhPNRj
	8bdzeISFoUWhoadEicGIZwa/ZEvUaVRY4DOc7H3AZ5LUPmLBkmbKiNFBXpWc0wLbslglFI
	Q+WCaItmSLd4NqZn40EqfTjKMtV8vtE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vuz79kYO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793301998;
	b=hE025AukIuPnN5L0lxBz32SWQdgFl4MUMIbsHEgP+K80BbueXh7TxZqNaODpUknVHA4mm5
	WKhkxMaMzS8YIb9KNROz9hsJQVn5voUDMc5BOKlDa7X7BGmMrKUw899yOCyw/GGC+HOd6o
	jl89hu9iN++FVN3oE6J4VoisPgKrAKk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EFD0743CE8;
	Thu, 29 Oct 2026 19:26:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B31D1F01816;
	Thu, 29 Oct 2026 19:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793301997;
	bh=olq2oLw59YhnpeUJwxDmzWejxUeT+/sp90poHb2MYpE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Vuz79kYOC25Pp9Lahkn6JIoGjLKWZgFMbszt9wdYOSUiNklBr4qPAG+Z4n0nCZ1A0
	 eTnnRFm9Rw4IsBqS8OzDtTl17wf+e48vjls768zrm5h2RnQ9WeHLCsdOSWJIIaeEOb
	 YML9LUIT7+G5zuOu3mOEaeFf/7OJ1Hauz1eLBtTE5Z/wfuS50OqrjJRgjI1JwBkGI+
	 kF1Ii/KT98x8jXIXfkV/UZVqCgi8xq9PU4qG3X67p4XghMEn7hf338VOMdjyjL/U8R
	 ylDOaPrnvYV/ZL/kdu/Wn3yRVQ8rZ1F8Hz7yZiCTmDjZVn9p2Tb1lfA9FPtv+/Sj+Z
	 orROyVbGDU/Kg==
Message-ID: <0a1ad7d2-ff0e-4248-8f03-2a64a9134aae@kernel.org>
Date: Thu, 29 Oct 2026 20:26:33 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/filemap: stop fault-around when the walk steps back
To: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Krystian Kaniewski <krystianmkaniewski@gmail.com>
References: <20261028-jf-mm-filemap-map-pages-lower-bound-v1-1-0bf126e876d4@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261028-jf-mm-filemap-map-pages-lower-bound-v1-1-0bf126e876d4@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D022116000B
X-Rspam-User: 
X-Stat-Signature: oo6fpdr1zrnykirruj7j1b6ket6u1cg9
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793301998-485248
X-HE-Meta: U2FsdGVkX1/GzxGooN7V9VPdgmL+e4huSNBmunx/t4Jzu0gTY1XCZaledTmk6qqI+oKc7fEP8GfE/Ml7GmSFo52gMIGQ6HBR7mQ2OI/yQnKOP8P5LXU/ryI+TE7yqmEzE9t+moLIpIcnKuJ7FisbmIOUFC0uib4i9um9/U3OUTLJnoqwYOvapTGingEyQgnW9v71Ok1hg1Btt6K5Ylw+EsAdCycdYEjxbwpPanD2hnNOCbFIxWK3LNi7y5cXzVFL3WTcSXXK32jLLA8T1smSAM7yyDIfam7w3OqVYjXIiU/NOPUwijKGLIh9O8ciVmTV9zJO8hJ6SzP4zfz9qs4OGvTjFgNy3vb6ygWQwdJsNzF3i0MYjGi+MFnxtNkgckdUX99VcqARS2XpHL94ha9l4hJfqpMank53fVPPHZx0nfxEX8FmxzUcQ1oXUbSQxaN1LvPnUamnYk3ZDKoaQw8xrxN2rlThAIz31EXXOV8intxW3jbJejXowYjydUz47QZAQcS4wlYE9T7RjbIeXfAsgHNEo3kdtL+FeqxMvLMopSpChgf/MCMx4R5XgNL0xlvw4pFyw8lP1M6LMKFqXjVX65+5KxdCyE3sN3tgB1GUTNoXzQ3JxAxheBeNVyerCN+rBmAC/3uEwykHqHD0r1sxsM437wfKQUqC259idXCCWZ7N0bCuX9151x3xtHbrQsSsQXnHeHgKV3nPrE2JqfrbubuV7a6XlUlnJ8okqHlX5iZJEWgCcGKJ6RmgbkZ/KBOPyPzuegd1jW3mcdDXQsDAK1kIuqQ7zFfGEuao7UuuKsognizWGie09LTYIF1XhkXlD+cbgWYEpHmiR/CYl6k5UkBy97HvgkY2BRq1DRsoyoFYzCLa6ad4mtdLRNRjSVqynmD6HHIYMc1aDCUFx7+ycTHhWcIXwxgl3x5N5AAZPT+65jRuZEOHHwcloIx2kps+/jC4iWWwCqXpaJc6lLE
 0gVwwztz
 ys35yB632wBAmre3JXS8+eBzWI78r8fci3jKaGpN0CRWcgxNYeYmzZLMGs9SOp99Hvc7X0PrBsh6J0rhoGHy7aHewTL43e8Eh3Pbo0X1Ri7bu+kzd7T4Kb23fduelnxcUFxMRyIauuBVxNJcnaCitfJoRljPaOTTqsTrdfTarSezWcQMsjRqqJWFF8MsjjIPUlq/FXlQQo+xUdTsPQuYY3c76nzG3GROSKGBI0pckrONoS4GwNQJsnneiqzOebj+pY2Xs8Dcu0oir6cvx5ZV9Dxbv8t9ENqR0DIKqF1jbKr2P4rg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 16:50, Jose Fernandez (Anthropic) wrote:
> filemap_map_pages() can dereference a PTE pointer outside the page table
> it locked. KASAN has reported this as a use-after-free read [1].

Only read or also write? I assume only read.

> 
> Its fault-around loop walks the page cache and moves vmf->pte by the
> change in index. A lower index moves it back. xas_find() can step back
> to a lower index when a multi-index entry is split during the walk.
> 
> [1] fixes xas_find(), but the loop still relies on the walk never
> stepping back. Stop the fault-around when the walk steps back. ->fault()
> maps the faulting page if the loop did not.
> 
> Link: https://lore.kernel.org/20260904121301.200049-1-krystianmkaniewski@gmail.com [1]
> Signed-off-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
> ---
>  mm/filemap.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index b74bc1e5015c..1df776907140 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3968,6 +3968,13 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
>  		unsigned long end;
>  		vm_fault_t map_ret;
>  
> +		/* A lower index could move vmf->pte out of its page table. */
> +		if (unlikely(xas.xa_index < last_pgoff)) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +			break;
> +		}
> +
>  		addr += (xas.xa_index - last_pgoff) << PAGE_SHIFT;
>  		vmf->pte += xas.xa_index - last_pgoff;
>  		last_pgoff = xas.xa_index;

Sounds like we want a Fixes: tag and Cc: stable? :)

-- 
Cheers,

David

