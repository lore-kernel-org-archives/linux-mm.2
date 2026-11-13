Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70E88606A321
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 06:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=IOULsNqo
Received: by kanga.kvack.org (Postfix)
	id 883D56B05F4; Fri, 13 Nov 2026 01:38:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85BD46B05FA; Fri, 13 Nov 2026 01:38:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 771F86B05FB; Fri, 13 Nov 2026 01:38:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 571FA6B05F4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 01:38:56 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B0E7380556
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:38:55 +0000 (UTC)
X-FDA: 85429143030.30.5919AD1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id F41141C0005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:38:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IOULsNqo;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794551934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IOpli/zwiHeET+6XH4pxKBuHV5LdRJeylp6mDdnz8r0=;
	b=Upy7td7HeHhr7C3DzxuyL3zGVqB9EMGC7m2NW8bh/4j/djlMHz7JVPBYnO9hul+1yrl/B+
	MXqHmEkq475/3bCi3rz/U4dMKLwXMkntEIYesA3hKK2VNk5558YkzEL0idpzIuRNKLBios
	SZMbpGOU7rD/SJp3WN2RiKXaLkffv10=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794551934;
	b=iU7awd60mqdzr7kcGJKRv2tpqpTXJ8vkmSHISSH4pO7YO6YzA+Qiuzp20a0VAJLqA8fkZx
	DEmnZfNQrByFPhWm494Gjb9DPSCxB1CXOYp+sUBIDdk7xmV5KkdPRlygECzGedZE5bYZtg
	6N/NnoR0Hgjk+sLuDEJA3sr/ojCzxfk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IOULsNqo;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A3F34600B4;
	Fri, 13 Nov 2026 06:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA31E1F000C4;
	Fri, 13 Nov 2026 06:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794551932;
	bh=IOpli/zwiHeET+6XH4pxKBuHV5LdRJeylp6mDdnz8r0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=IOULsNqovaL4UJWj0vpuNawCSJT6AzwCMeQMg0Dbkh6QypN0MRs0Z3SBAjTtblofz
	 /LeaLEH7e9xmBb5zb1UkRLKxrQqATSmKvCVlgh4mSW1aAvxhioaS8mliywNU7qV/hM
	 ujERaDT35RQ9gn1e5jcVMb2voCR/RCs4Mw5YET9Y=
Date: Thu, 12 Nov 2026 22:38:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Frank van der Linden
 <fvdl@google.com>, Ivy Lopez <skunkolee@gmail.com>, Lorenzo Stoakes
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Oscar Salvador <osalvador@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/cma: simplify cma_declare_contiguous_multi()
Message-Id: <20261112223851.d441a97711d43f91a25ffa87@linux-foundation.org>
In-Reply-To: <20261112-cma-multi-v3-1-663407328e0a@kernel.org>
References: <20261112-cma-multi-v3-1-663407328e0a@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ibm7sip68w73jr3bz59xcfnxy8nzfrz4
X-Rspamd-Queue-Id: F41141C0005
X-Rspam-User: 
X-HE-Tag: 1794551933-419697
X-HE-Meta: U2FsdGVkX185eVknfv2DiuXICO1ENdMsAUHA5+djzyWNQGQdZTz3zS9BQXP96zf6AEsoa9yqlnTbkJ2UYs2Zg6nPIGQSku9ejLqcarGQUxbxujayN2jiXbw0lr8rMJpWn7rMSFJN3NXlpnA3xuaw8kIZ9eyGlLQYvvn5qRfw8bYWkO478tqnouyBIqZ4WRLwcedzstm4VsfYxxSmGoNntugOVcw90FRjT7PvDJFVcuTpS+QXUz49Vr5CNADFymLI9zxCYTyfn2SFuiiI35l9rdR3/Wi1Yx8X/wWPJ/1rrCuXJajLSvENYEVVKrdCfUzYVrfHONrExYpuZE+Hd4vvosEKmfuzV/5E7/Q1fE9WHcI+P7/c7DGO6sEOmLPdnPj0s9L1zf/3bf7BDesQ9FP7x07NF8M2vkRZDGgWdP0Fjn9zajEXNVla3DtxMknkzDaGT8XrerlKemzQl5S/0wlMZ5/A8fJNfMBZ6JR7y8E82Tc75WnDnFbNozvuOFC9F6mUnNwaK0LZPE+YB1eXZrtfyXxIEQX+vahKn9zKkTGv06kF9+dpI42Rvj1ftrT23Y+MLbzwlvlkIy8RwtANCQwdztglWwuQ5C5ULEURgCgIsWKqVridiqG7bEMLi6J9CS3DoA9wHzUTKD8kl2XbgCzViTIJck1BpRjmgIvBCzvHV+/HqALYcAj1qyh+msII6rlUK9OGhTRVguTWVWDGbVWEIvsqsccMX5PhK6E42eOfS55Qn6vcJzD13j+l6nX7wqluWPpFd3KJejVkE0PpK7TABOj0msdDfmx3pfQeDKHNYdWyQAi7lwdnr5cZsWxtLnEwBJDtDRoA1HJqOOE52QpRN15RvINBwAyuTNspqeR4qWArQ0rA3KPHSQcfqpoQehJx/a/7n2f9R2uZM6567qVOgTcU7tERu994Ab+miysZus33gA8js45pPJ/n3G1i+ttnF04Fo++Tjcw9fJBEGz8
 RzLbdgrm
 KgvglhDYqr899nQ7Gh6cZcvOyoLlbOL3yLO0NBio2zDELz/18b2QWAROWy23HZefiUgLOCM2XWHa52dpH2TRJChsGtXg6Wa7uZDpnCg/JRjHxnRdIArXkgKkvRMfcKOicRg1ezzh5bzxBDWMJ+mJj1/iubu4h+3IaN0P3xr1uygRvpIapHByl1denvyV0wjU+vU+gfcXowD4k1Bm5hEHAcX95fYN467MLrdw2f7aXI0g98imkg5TZIzWh4QrxqLCa5KXF2ydgCigC4sgX51r0hv5OD0Sx6BG+4V0RvltYB94jhYH1tZN9RGdmIazJwGY/u30iKnYNm4xsasu/1qoA+52L+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 12 Nov 2026 10:16:57 +0200 "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:

> When cma_declare_contiguous_multi() cannot allocate a CMA area as a
> single range, it falls back to collecting a list of up to CMA_MAX_RANGES
> largest free ranges above 4G, reserves them in memblock and adds them to
> cma->ranges.
> 
> The list and subsequently cma->ranges are supposed to be sorted in the
> order of base addresses of the "allocated" ranges.
> 
> This implementation has two bugs:
> 
> * The allocation may fail even when there is enough free memory because
>   list_insert_sorted() sorts the list in the wrong order.
> 
>   When the list is full, the largest range is evicted rather than the
>   smallest, the final list is not sorted by address, and the smallest
>   ranges are used first.
> 
> * the function may report success while it reserved less memory than
>   requested because sizesum accounts for ranges that were skipped.
> 
> And overall it is a lot of list management and open coded range
> selection for no real gain.
> 
> Replace the current code with a loop that finds the largest free range
> above 4G, reserves as much of it as needed and repeats until the entire
> area is reserved or CMA_MAX_RANGES ranges are used.
> 
> After successful alocation sort the cma->ranges by their base address.
> 
> The new code scans free memory once for every range rather than once
> for all ranges, so it is slightly slower, but it is way simpler and more
> robust.

Thanks.

>  mm/cma.c | 269 +++++++++++++++++++--------------------------------------------
>  1 file changed, 81 insertions(+), 188 deletions(-)

Win.


Ivy's 2-patch series
https://lore.kernel.org/cover.1792032699.git.skunkolee@gmail.com
carried cc:stable but "No kernel-level reproducer was produced and
nothing was tested beyond compiling; the examples in the commit
messages come from a userspace copy of the helper and the selection
loop, written from the source.".  And my LLM's web trawl couldn't find
reports of anyone hitting this.

So I'm thinking next-merge-window, no cc:stable.



