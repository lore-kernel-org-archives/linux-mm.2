Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3917CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:30:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B9076B00B5; Tue, 26 May 2026 07:30:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 490646B00C8; Tue, 26 May 2026 07:30:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CDCC6B00C9; Tue, 26 May 2026 07:30:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2EFAD6B00B5
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:30:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D71301C16B7
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:30:18 +0000 (UTC)
X-FDA: 84809352516.02.9CE2A32
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id BF4FB40017
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:30:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qsH856Jo;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779795017; a=rsa-sha256;
	cv=none;
	b=z6xvt8nVTKd/JPhZ134P7F/V6Ku+qh6ubfvboyqPB/MlwOb0D8TrchI2/JJ1Zahe7rO17q
	k34vE1HTQNUCsM0d7oI5c279Hp9Bu43VP/9J5Z48n5zkf3T/jComTANo7ZolCMl2jJO2I9
	GQ98n3QywWDB5kFC/qTLd+Syh9GEyjs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qsH856Jo;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779795017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p4V098L7V8l//JQho7wEgMgtyJ6Bly+yLWxZarD+Fak=;
	b=RYT+xkzBynrcSYEn3p5oD9yI2BibvztwbPMdGMj+GYmCcmZYTNQ+MM7mcksoQENSKkkB7p
	Dl5dFhyQZmv/GSi2rtZTIezmD+zjMpkzqw+zBnmSnKCD5HlBYyq5+EFlIFGdSqL8laPZD6
	BLsxy1noG1O2ycljnuYdzPsvtGd6RVI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779795012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p4V098L7V8l//JQho7wEgMgtyJ6Bly+yLWxZarD+Fak=;
	b=qsH856JoTqeGJbSH7PdfNWnqmQ0TuOwGLO8AVLU0qojv3tSxUWXuRjDTA/yruYxiNUK5aQ
	RIQk/lj2CJbDbhdQ139djiMXWxklKgAqxux8fBK0bYLvkqNIgWU381ymTlk4LfPG5rt4l1
	m8jgrNxASeSUNLpoqcSQqU83PJbbee4=
From: Usama Arif <usama.arif@linux.dev>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Frank van der Linden <fvdl@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	muchun.song@linux.dev
Subject: Re: [PATCH] mm/cma: fix reserved page leak on activation failure
Date: Tue, 26 May 2026 04:30:03 -0700
Message-ID: <20260526113005.3610737-1-usama.arif@linux.dev>
In-Reply-To: <20260522062658.4095405-1-songmuchun@bytedance.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: BF4FB40017
X-Rspamd-Server: rspam03
X-Stat-Signature: 4ujw8urn15d7468zd13n5hs8f4nun44u
X-HE-Tag: 1779795014-454942
X-HE-Meta: U2FsdGVkX19KvirmevaR8CppEwZzZgNGI+uoCprkmv6z1+uwyOoZV38KoTDjzhr9x8/KJ2A45Lvd3lAEa0XGCD+nlcs1dE5IZ5wxZh83qhb9C8wC4PGuaZuAh4UZV/3PE1jCzojG476v646BE5iduDKcsGSpTMEJULeS4hA6lh0sdgxzSVsyU5+Ht7rWhj1Ow/AMfzn+D43IdY0tYmxj3Y0499a2W/jvHWx3Do1tIgqwP8EEfv7uxagulolIz9vVomTbN3VJv4nnF+8/DJ3M41vN0bn1TQ0NRBUkPu4gRqZU+HIyFQm7YEKk45hb1ipNuMvlbwscVrzCbnEQDdbGnwZciyX445xGf71eKjeFxt5AQdhJSCiox1Z8XL0IgDDrnJjrm7vjHpz2lDRMXPsvjRkhxvW6yLfbjTzpPwfnLdRdyuWI+tAmVJFqo1FSMa5OXkPFd2vZKKaLto3pQ3bGqz9g/iZImBDGVWVBvLVNGFHzchYovRqmivHWY1ziC976VmrluWu20wKtsAdEzHKQx/6TwnrMKSuatvxwwR3qjXcfhMBu1rr2rBtEHc+aiXbhgYSpUUA1hB5xqEtIdXAcIdQMUf7Ivbigau6CwDLh+8s0IErdaprufL8kBzkiPp6DfmFUYiHTprXNHV/WCPB2oQ8TccDUMNH8ltbw02eKQXPDstu1bEBNuEtZgnpSRhsP5LsZQqSjgTzlTA2wgPl0r35VCjweB7ei+aYnvKnD/qmw46vTzmLTg616SmSeVjlDu7dH/tY1QHbWlf71VITqxM/FthOyZ0GcDB1B2vHaO5raM+bfgnsT9bpjSB+bRtnCzJgaBqclb8oAU3cCDgZ5rnmoPYTm0UDmEJ3kLaGgYBJ+lrQLLTn+ir3XMQ9Xvp5Ia58mu7tfIZ95eGTcYgI2O5nFQWv6Wb3ZKLJlbc28RP/VhEEb6mN/KGZgB9b/cIn27YnN5LMHUUKh92ptcX5
 85/DDvyl
 95nllBIl97R9XbZ/y+mgwdNpZhzB6Z97yCDPfUtuPvxD5Wzf08IRsYPOdjI8vaEutjVLBmHeJ6s+U8n4Dqfbb0wMBrg2Tj2coQxgezTiPbOeGF2KIKYHdsVWeJkrNLUXMuBf8J3rI8NwceeXaZ5n4FWlJviF3hfJblP2KQxnREFkoA8g36MbpheN5sa4m3vp/CfKXLCg19HjRIv17RtEgdi4elovPMnAzq7MuwCkduPXJuNjeFBLKEJ/ZdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 May 2026 14:26:58 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> If cma_activate_area() fails after allocating only part of the range
> bitmaps, its cleanup path frees the bitmaps for the ranges below
> allocrange and then releases reserved pages using the same bound.
> 
> That bound is only correct for bitmap freeing. Pages in ranges that did
> not reach bitmap allocation are still reserved and should also be
> returned to the buddy when CMA_RESERVE_PAGES_ON_ERROR is clear. As a
> result, a partial bitmap allocation failure can permanently leak the
> reserved pages from the failed range and all later ranges.
> 
> Fix this by releasing reserved pages for all ranges. For ranges whose
> bitmap allocation succeeded, use the early_pfn[] snapshot saved before
> the bitmap pointer overwrote the union field. For later ranges, continue
> to use cmr->early_pfn directly.
> 
> Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  mm/cma.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/cma.c b/mm/cma.c
> index c7ca567f4c5c..a30075507d41 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -188,10 +188,13 @@ static void __init cma_activate_area(struct cma *cma)
>  
>  	/* Expose all pages to the buddy, they are useless for CMA. */
>  	if (!test_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags)) {
> -		for (r = 0; r < allocrange; r++) {
> +		for (r = 0; r < cma->nranges; r++) {
> +			unsigned long start_pfn;
> +
>  			cmr = &cma->ranges[r];
> +			start_pfn = r < allocrange ? early_pfn[r] : cmr->early_pfn;

Should this be r <= allocrange?


For the failing range, the loop above did:

		early_pfn[allocrange] = cmr->early_pfn;
		cmr->bitmap = bitmap_zalloc(cma_bitmap_maxno(cma, cmr),
					    GFP_KERNEL);
		if (!cmr->bitmap)
			goto cleanup;


Since cmr->bitmap and cmr->early_pfn share a union, that NULL store
clobbers cmr->early_pfn to 0 for index allocrange.  With r < allocrange
the failing range reads cmr->early_pfn (now 0) and free_reserved_page()
gets called starting from pfn 0

>  			end_pfn = cmr->base_pfn + cmr->count;
> -			for (pfn = early_pfn[r]; pfn < end_pfn; pfn++)
> +			for (pfn = start_pfn; pfn < end_pfn; pfn++)
>  				free_reserved_page(pfn_to_page(pfn));
>  		}
>  	}
> 
> base-commit: e98d21c170b01ddef366f023bbfcf6b31509fa83
> -- 
> 2.54.0
> 
> 

