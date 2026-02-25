Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA779FD375E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 13:40:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1598E6B0088; Wed, 25 Feb 2026 08:40:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1084F6B00A6; Wed, 25 Feb 2026 08:40:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2BB86B00A7; Wed, 25 Feb 2026 08:40:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DF4E46B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:40:55 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88D7CBA3F5
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:40:55 +0000 (UTC)
X-FDA: 84483089670.23.E0FAE89
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id A4CB740003
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:40:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dbt7B8Ja;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772026853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kYsLLY4B5pGSiHw4jEG3ms/zRRtkDxFqdip/WYZFK/I=;
	b=lHzWk0cRqGcwcg8nvZL41VS5BEf3ib6uJjdaaQ58N0swYqcjzpfMcsoFxvDBzaTZq3gVoV
	HfWj3nJPhvqIfcmCv/qU8eUXS+85nEqUpTEeg1sQc0FsbpFtlKsw7n9cDZsT2/G2aUhVEg
	f7c4Yyqhg6DWGDN5A23rcgfqv5hb+kY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dbt7B8Ja;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772026853; a=rsa-sha256;
	cv=none;
	b=HBZ3RFHPP4HKbg65n68JPjgf74R56hfQwUg5elfSTZMq4UKDsAFLQjn6eixCzydbk708Aj
	ptjCu5OELlf8fzB6j0VcqW71nBUTnMOUORvgAxRn6OpcLkMxDmQuQYnqvwlHzMIIqVhyQb
	zTdkfvOuTMdh3MvBmoIo6CMadZ0rP9I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8DB7043DB3;
	Wed, 25 Feb 2026 13:40:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B842EC19421;
	Wed, 25 Feb 2026 13:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772026852;
	bh=rrMpGqEeFB0d/dInF1INAwjXcTLK5Z1RFzio2aHu3aw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dbt7B8JaWvul8aSZkLa32oQQtVMKNtV7dFqwAsSkisijHEbNw23kdpos/6fBtt4xj
	 vGicHEdKPCFzRhYQi7oCzW+I0qMOICLuJqiWPe9w2o4vMr0hvRSszdZhZo5zQNXSTt
	 PF+0MAeTZHCFGaXF05UJgQYIQ6Elbu/1ztzUpDIVK9kng0XA+Fm5b0Bfm9oviSOno3
	 PBXhYYPXUD0ZLj6mICapcfwcwz+AGvuIhCUEY0COForJFKsENhBONrba3JUhAgogLY
	 aZ/sW7uDiKiGOrPLerKuj232coIHuieYfGosVdqQTlgDudfijQbtP4OQBf27SPhd6g
	 t4wCJv/rsmKvQ==
Message-ID: <81065dd1-c131-48db-9ef6-01c0ec0001da@kernel.org>
Date: Wed, 25 Feb 2026 14:40:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Avoid calling folio_page() with an out-of-bounds
 index
To: Li Zhe <lizhe.67@bytedance.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ankur.a.arora@oracle.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260225092628.11687-1-lizhe.67@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260225092628.11687-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A4CB740003
X-Stat-Signature: a3izjp7jmtzjdcancg31u5ytecs9nprd
X-Rspam-User: 
X-HE-Tag: 1772026853-558770
X-HE-Meta: U2FsdGVkX19j/54G438+TrfsEIh5CX3UJKsCNl/YDGMcQooEkPkcB6NjNyh1clD7yLwTuWHquynStwdyK8xseejReBtTY7cvAWkai/b6CCTsXAV2GrO8ZyVgMlDHwjAX6a4+l5WGqGPYaBkWSB8giRYtLQ2Eym5OOniFtABDx2dv2wE30dKrcaZhdSW8FmyBER2rstdN98+dZ3PSaVewnsj9Xs6YA4v9l9GCD6Ew2++eHZtAS035atArHy+a8AF2BnmU1cYJV+JyVtjtY4KlN+EJS6BdRkrDHaXoPpSGPiAb8zaSBYUah///Git9NWu/VR+A9KThr2r4n/sLxzEgh2L48bWG1b4qqz3pRqqR4vmDZMygGsA/r7N3sZznjtyCALtjskf8o5hXduD3yy0nA/V/cUV8Gt1pGuzkzbd165wdjz1bjh4eIHNhJGRspTlF3fV6uV6GtcYLRd99Yn1K39tY8v1fvD+KwzvJ6/gfcKjl6u9/2g9Ld0SvCCzO0Qkro0ycycVXCsKy4QnWS5vIPXMzQg0TP4tHgI5PyrE0VrNmXLg4QuY94edXuCCEJhJfgvFkZ81cah+caHLLd/PIZXJj3x9ONfWo7tS0Osb2h85InZH5mMGXMjOGGU8nlrQ9GUh4y7msVquVGl5QcJGwoiLIBpzxznTB64Ybp9czWCpo6qWyHt79S/dseELBOJJ5bejP+5LcrlLQNMx2Ib70euL1ZZ/mvUcl8epzP4UcSHvlKZ1e770+21GGOmOH4YV/Tp33Jikkan71VAU3l+FTIH+VMnOK4J9Z5gD9rzdiIEmOrewQSZct3eCS5nlLvTBxowNYS7xcurYTBxgsp0UTI1Z+odR8ETo6xA6gxb2HDtxIKfWkf2y/yFzs+oDpojqkpKby58epgp7MnM+osXAqFL1+6gENvhiWgKxVa85OVfRlQDgXG0biibGCq/7ku4WTGb+j+aaqxiOLLj5vMvj
 9lGtg68u
 sO2VeMMVhEyNY/XtKiu4Vq4hOMewUSOsOllKNpLf3z50Oz+KXXWs/DRNJiI/UQ4GF5Ey+x0qZquw7FGOWQGSM8GZiBuJdEaim3t8jF7ITliCLbKtT89DJLAs7zVUcQd7gaIsZyy3YrJsGWPm+oppqgEjg8ZUkk2MTYP/uq4nGGv/7Iy33h29Q4t5SvfGdA0KFviy59/VwClZoaR3miBeg5TDnWe+ErbzFDgGV3ULFFxA1DZHiS7C+2u4TfzFL7Ba0WRUv4CtJOTRLR3rdv+zMGNT3CKqF6gn6kRti
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/25/26 10:26, Li Zhe wrote:
> In folio_zero_user(), the page pointer is calculated via folio_page()
> before checking if the number of pages to be cleared is greater than zero.
> Furthermore, folio_page() does not verify that the page number lies
> within folio.
> 
> When 'addr_hint' is near the end of a large folio, the range 'r[0]'
> represents an empty interval. In this scenario, 'nr_pages' will be
> calculated as 0 and 'r[0].start' can be an index that is out-of-bounds
> for folio_page(). The code unconditionally calls folio_page() on a wrong
> index, even though the subsequent clearing logic is correctly skipped.
> 
> While this does not cause a functional bug today, calculating a page
> pointer for an out-of-bounds index is logically unsound and fragile. It
> could pose a risk for future refactoring or trigger warnings from static
> analysis tools.
> 
> To fix this, move the call to folio_page() inside the 'if (nr_pages > 0)'
> block. This ensures that the page pointer is only calculated when it is
> actually needed for a valid, non-empty range of pages, thus making the code
> more robust and logically correct.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  mm/memory.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 07778814b4a8..6f8c55d604b5 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7343,12 +7343,14 @@ void folio_zero_user(struct folio *folio, unsigned long addr_hint)
>  	r[0] = DEFINE_RANGE(r[2].end + 1, pg.end);
>  
>  	for (i = 0; i < ARRAY_SIZE(r); i++) {
> -		const unsigned long addr = base_addr + r[i].start * PAGE_SIZE;
>  		const long nr_pages = (long)range_len(&r[i]);
> -		struct page *page = folio_page(folio, r[i].start);
>  
> -		if (nr_pages > 0)
> +		if (nr_pages > 0) {
> +			const unsigned long addr = base_addr + r[i].start * PAGE_SIZE;
> +			struct page *page = folio_page(folio, r[i].start);
> +
>  			clear_contig_highpages(page, addr, nr_pages);
> +		}
>  	}
>  }
>  

It's all just arithmetic operations. Just like Willy says, I'd assume
that the compiler can just move them around as it pleases. No dependencies.

So I don't see any real benefit with this patch.

-- 
Cheers,

David

