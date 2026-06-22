Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEC5CCDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 15:47:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4D916B0096; Mon, 22 Jun 2026 11:47:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D8BA6B0098; Mon, 22 Jun 2026 11:47:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 853546B0099; Mon, 22 Jun 2026 11:47:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 59F906B0096
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:47:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2EAB488BB2
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:47:07 +0000 (UTC)
X-FDA: 84907977294.21.B104AEF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6455B40009
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:47:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UOaTZUid;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782143225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yoWdqaO8IqnJhMic0naLfg9Wn06LbUJ/uEvj5S1j1zc=;
	b=LWAcu69bRQwnfuVgl2VmkEmnAm5AJJ1nivQVhvi02okcgDS/GKuluzXhT5cO3Zlh8hvSJA
	wso/eL4WfJf1BWBFnEgI6EqhbWoXoh9zudalrqRifJBFBIJCb2ozZdH7MujqciCuTywQ0R
	w7Hsom5asQW7IgbPH+hHjTHt97giJHo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782143225;
	b=vi8GU3gMddEpQlzByy5/ysU+NqhOfG98dTuOPcpEQhjwb0Fr/B2mJqzMIawq2axLNBrF/z
	YhfC9R5ENKRKNAHhFC7YnwlVq54+gFRRVN82aMU5PSMfxInbdm3oGOk6BPYQzkaDpKUjR+
	26yY8A3ne9s9LLXjIsWXBkSBsD6B9FU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UOaTZUid;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A69F843B0B;
	Mon, 22 Jun 2026 15:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3AD1F000E9;
	Mon, 22 Jun 2026 15:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782143224;
	bh=yoWdqaO8IqnJhMic0naLfg9Wn06LbUJ/uEvj5S1j1zc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UOaTZUidvSSHad4akjDsUxFvvXJTkNlMnJWzr8mhmjDu93CmYPG5szEye5UWCoKVH
	 q+jWJ25h/c0Yru7Lhi/OPOhsPzzZiuCjHuEqMo6nbU24ij++eyg0Vw7berLgMAmGf6
	 Ut0HYWoZZP3ajm1TCRkqYZLyO82bv9hto2Kv4XmcD0v9d95bZU6B041fbJfjymxTZz
	 0fM3PYOMj1VGqJB38MFDWxGEnO3f1MKYZxYapUlyLmT/Thq3G5DP4SOyBZu3fA4nQR
	 9wicAQNAX2kOTKgZQXJSclNUajrYc9X3HzJ6E0EhjfQkvUdDFMDa5ZffvDz4BxVX1d
	 21RNcqU9SIgmA==
Message-ID: <b8962738-98a4-41c2-a85a-f668fe8c211b@kernel.org>
Date: Mon, 22 Jun 2026 17:47:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH hotfix] mm/compaction: handle free_pages_prepare()
 properly in compaction_free()
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260622-handle_free_pages_prepare_in_compaction_free-v1-1-fcf3b14abcf7@nvidia.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260622-handle_free_pages_prepare_in_compaction_free-v1-1-fcf3b14abcf7@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7js8tmkbnsjhgsp9r3aq9hkq575kggpk
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6455B40009
X-HE-Tag: 1782143225-395196
X-HE-Meta: U2FsdGVkX1+S9pcMQw+x7vMucuG/U1r83h7VqZRRElHU/8j9LUA8q/EeHMJWtJeFfYF+uq9Z65+vKG6oUH8B/zvFa4SfaKFPIFDr6swpxv1yx6lcis34PLCC4Fk4Q3yOgDuEV0L2jEkuEIQC/9qgjse6gusWufiTxRvRcX59VimjZoJQQBV/koVQsiXdhg45en21GksjQKCRwJ7AJANkMJC5MO94S/9vFBNHeHfe6eOcsz8c/rLo8bidNRZmk9GyfNigTbOauCgAX7ugc7JdPfKH8La3MywuKLO63v+dY/YGDfkp6rdrWtRwAc1EmcYyQ9ZiV9un/el4QIGXhQA8kWhOnmNkr3392RrY7D5W9dgIMZfWLNqWCf9nNGuIAPe8GKKgTTUrUqcoeL8x+GsCiBwRClZdYIxUBrhpNCmgWiWT2bM8CFebaIH81IU54ZMsxx1aIHZepH9le1PQM69xtnwMX9rzpzZPbiGj7nAKgwL1i6CzOdNr4OwDWniS53GOLtdplYcAMTm0HXucLdx11q13IPfiflcByzxEWoyA8DmXdewxBpdbNzxyJHAs2o1EJxDePRUOE0Z9b4T43a+50jjIhpSo9MFis11IaEQ8vdbePN7HkZ+eAds/EZWQnUky4Q+CiDf+z+2MzPloCZ+V7E1m6bRtNCt3zQKXw/Ie98MJxZHYYWLaSGiWR/3B/OY9e8peCW4A62YQ53MM3S2iN1UVp1IYbum0NT4igLIVKWXkR/ChrR7tzefpvEKQLknl5vb+qrAjHmAc59XwE1olt1d+SYeo32F5GYf3dfXo4osi5y3ioHfgw51ny97L7w062CpQBcua/qDTpU0RT9jqcKb3lUWvUlqz9tWf90UbDxSvor7yQzsBxyyk9Y5uOkc60qZY7ImdF+GRHw90Q3UjzFCe+pJeAgCs6WK5Xm5m9Jar4yBAxDUEiNE6zvMH/yY3NGd/MhpKmOyu60fbRuz
 yHTqz+Zn
 PLpZ2cdlIsCSFUmMK4Y3OB/dRa7P735ANoaZv5U2uje9etiyFpyad1++kDVHo4yenombjuDIB19lUlS//ZW9ecWg0fJE3MAqyXyoTeo/IH8cmcrqhsRAsRv/jO51zNp9rXldjc187HELkhwlpe0qjEhhPlIJeCeByON6BuSsbOTjGagGa3cmmacv2x/qHiahjIcaOHFUvt5fHpWFhHJ3QKtV75cF8jXWBVHtRZ4tkQgkeUtf5X6YRh8/gU2FQTrpy5Au95ZKEu2yRrw0oZ4NA7cf/ZladOTRdud+fw264qaJSymnFaviBKlRI5ML3OBsH631RuPb3Q7YTuzBPiA0A9O06c6TCgG6yCBPb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/22/26 17:30, Zi Yan wrote:
> free_pages_prepare() can fail but compaction_free() does not handle the
> failure case. Failed pages should not be added back to cc->freepages for
> future use, since they can be either PageHWPoison or free_page_is_bad()
> and might cause data corruption.
> 
> Fixes: 733aea0b3a7bb ("mm/compaction: add support for >0 order folio memory compaction.")
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
> free_pages_prepare() can fail if a page is PageHWPoison or
> free_page_is_bad(). compaction_free() needs to handle these cases to
> prevent failed pages being reused in cc->freepages.
> ---
>  mm/compaction.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index b776f35ad0200..f08765ade014c 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -1875,15 +1875,14 @@ static void compaction_free(struct folio *dst, unsigned long data)
>  	int order = folio_order(dst);
>  	struct page *page = &dst->page;
>  
> -	if (folio_put_testzero(dst)) {
> -		free_pages_prepare(page, order);
> +	if (folio_put_testzero(dst) && free_pages_prepare(page, order)) {
>  		list_add(&dst->lru, &cc->freepages[order]);
>  		cc->nr_freepages += 1 << order;
>  	}
>  	cc->nr_migratepages += 1 << order;
>  	/*
> -	 * someone else has referenced the page, we cannot take it back to our
> -	 * free list.
> +	 * someone else has referenced the page or free_pages_prepare() fails,
> +	 * we cannot take it back to our free list.
>  	 */
>  }
>  
> 
> ---
> base-commit: 13a1e1a618858407fa12c391f664ea750651f6b2
> change-id: 20260621-handle_free_pages_prepare_in_compaction_free-7cca3ff08367
> 
> Best regards,


