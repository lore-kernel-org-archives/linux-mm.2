Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78DB9FED9EF
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 18:02:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C449D6B00A4; Tue, 17 Mar 2026 14:02:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF5166B00A5; Tue, 17 Mar 2026 14:02:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B320A6B00A6; Tue, 17 Mar 2026 14:02:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A31186B00A4
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:02:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 513301B7751
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 18:02:08 +0000 (UTC)
X-FDA: 84556323936.17.7009C01
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9CE954000C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 18:02:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i7FEkuF1;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773770526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5izhRkibXet1pPWeSPaHLG5kIWKTInA1wLq1MnarCh0=;
	b=i0AGMnoX9Ki36t+stach3bjMTMOqgWGyyp2i5emruXnBb16NVprxK6Xsf5vcESCWOEM/h7
	yVkYMSsKuIIQ6MBjetbIJsDc0kbSJewZXa9MgEB3tcwvlHzrUkuSwLQsK8zLf41BpF5k9H
	z4R9SRY0zohwxinD31wYebw5Jtzl5xQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773770526; a=rsa-sha256;
	cv=none;
	b=YSK4Alsrc9PxEng90lp+Bi7+c73l9M1E4u7y6uhFjjWYZ6EzXl/MteSZYfseS5z/kWbbUT
	Imak1O0px98yU9CTi1JWg+UsfLg0/FBnD4XPyLCbL2lZWjCGUYSjdyQJb0T/EEWomx/hWy
	27FR5iwHXZvWaFNCGgxglmmnhRnyExU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i7FEkuF1;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DF5EC600AD;
	Tue, 17 Mar 2026 18:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608ACC4CEF7;
	Tue, 17 Mar 2026 18:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773770525;
	bh=heRUqLM6WOMvSWX3bQEpAKMgcGGvYDSbOPDUMCKJNCI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i7FEkuF1UZcijSe2FoHeEAXDGEOv5m79j1JHPT7si45zPq5pFrcvqXF3ZpR/Y2+6R
	 YEmQf/TlZmXt92wb+c1wcXSW3fvnwmGlIUtXi8WmX+DevEQDM7sQcG/hJ+q2E18GJ9
	 EOFoKf1+LWoY/IBb5dLVwiC3lRkHCNxmsBVmzO6Em30pC0cvPS1IcbkFORoIaULmHi
	 y8FwOlfaP26Pxl3nkJ7mpqhv+NCL1WGCUVDYTTd2G6roRJXEC9FjECJiHe5c3BEC/N
	 tv+zBc9Py6+aMTGgTVQvXdRDmdjA5VXLZEov4q7grJU3BN1JGdv6K3OggQCz1osDXO
	 LfCD5xuNMRSPw==
Date: Tue, 17 Mar 2026 18:02:00 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Oscar Salvador <osalvador@suse.de>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 07/14] mm/bootmem_info: avoid using
 sparse_decode_mem_map()
Message-ID: <22fbfd1f-21aa-43ab-9eb5-28c57972540f@lucifer.local>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-8-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317165652.99114-8-david@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9CE954000C
X-Stat-Signature: hse1e84uqhjka1nrckfm8sfs17cjwiy4
X-Rspam-User: 
X-HE-Tag: 1773770526-347235
X-HE-Meta: U2FsdGVkX1+/YO6Bfo8wYkl6eXHHkt9Lm+smLWxhO7ZfLV4coG9A8eQhhp65c+GxP65wV86OEHY6r6U5SBBHLYt6rpBcQxdJV3VST7b1cgXkCxlGH+JIpGb2OMiRzP29mdQXOE7qD53S/a25B6P2DzNcUcZw1xhYyr8eicyOSyU2cIN9Hr3nyDiW0j2LcmJRxK5kQTDjhn5Lqk7CkktNyP0yKHo1qkqHmMqPjGpEn+R6rSP+bGM2V0CWnWZznJ+KZbzgAuRsFiN4RBJA5LyYmI+mlUqh6kmK4J88UgyTh3Th1Ky/FrzQNzZ571iHLzZtuxE3n/B4KZFWv6qipaVYcNZD4yAF/a0S7+zafjrpFaYrtdL0yya0TtL9V/U1ct8UuDn4VVKnReuZeCbd4xbuSk89G1sLv9v2+hr8DgP+BB2T9cbv5niX/gBcIFWRlpJHZ/aytkXFU/1NFdX+3XzsXAG1r+tdPVKGKIBnhubsze15iI74yyviX2pNmQ/g2VAbsNCfrxz/RZ6gF1274E7+rYVlLLIXxJhFlGxN9bhOIdfWQ+AkN6/GYgq2B4g/rbtgaJN+vunsJNpClptjohyNJQeFsSRkEqcWPta1vt/dQKxosztohgxsbQOX54ErruWAR9yjggodUnZr9ewbTMbIvah2gY5V5xOD6YdjRNH6MQaApi8ABriUPnajVTgWgLEDBevgb0AnVtjFLP99Byk7kuPgh049TVUMToi3Ztg97TcCZYP9k+qq9vARv+6fBFPD07ViCBoIUjC+hZtMXUJgFn3l6anSkiWX20MlkADYV6dE+49iepDld2xwTooBaylChIhxW1r7hvRxz+68x6/c2bm7X9eD4ODRqnT2Suf6eZGMHhtbSuVLfJEh69t+KWH+AmRBvVnrW2wVaA3rM0mVEMcdZBHwSjH1HDXFmY1jNSJcliSQXV7486PYNoIhO5FThOgI/IzI9jAmcS4c9LC
 I1O1RcSD
 bUJzBN5Aa4J6VCDtylHxZVdOWxc8BxuNWnNilMcbIBLmobf2HuGTi/dGtN7lawGO9gn2+xlNb40xwNMrrefAY0SmxafraCISpVuVXjhQGJswA5z6dFMMNQQgLsQBOmiI8LnnIuXWyDt2lKpjmB/UWCPXxVAOBokyrn27XrohVTTr3MJVQV9QaU2/xKP+5tLR+WQyS9gabfz8x9ulXy09ULZhpZq2LnAxWlBXgCEVJ3twmPIDZvhV7RwaKji9SqEPbuNMTzKVr+w8k1AxbS5Q1BAQrz1ZC/NELJu8d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 05:56:45PM +0100, David Hildenbrand (Arm) wrote:
> With SPARSEMEM_VMEMMAP, we can just do a pfn_to_page(). It is not super
> clear whether the start_pfn is properly aligned ... so let's just make

Maybe worth saying aligned to the start of the section?

> sure it is.
>
> We will soon might try to remove the bootmem info completely, for now,
> just keep it working as is.

*gasp*

>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

If it boots ship it, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/bootmem_info.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/mm/bootmem_info.c b/mm/bootmem_info.c
> index e61e08e24924..3d7675a3ae04 100644
> --- a/mm/bootmem_info.c
> +++ b/mm/bootmem_info.c
> @@ -44,17 +44,16 @@ static void __init register_page_bootmem_info_section(unsigned long start_pfn)
>  {
>  	unsigned long mapsize, section_nr, i;
>  	struct mem_section *ms;
> -	struct page *page, *memmap;
>  	struct mem_section_usage *usage;
> +	struct page *page;
>
> +	start_pfn = SECTION_ALIGN_DOWN(start_pfn);

Yeah SPARSE_VMEMMAP should make it this trivial.

>  	section_nr = pfn_to_section_nr(start_pfn);
>  	ms = __nr_to_section(section_nr);
>
> -	memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
> -

So this is nice...

>  	if (!preinited_vmemmap_section(ms))
> -		register_page_bootmem_memmap(section_nr, memmap,
> -				PAGES_PER_SECTION);
> +		register_page_bootmem_memmap(section_nr, pfn_to_page(start_pfn),
> +					     PAGES_PER_SECTION);
>
>  	usage = ms->usage;
>  	page = virt_to_page(usage);
> --
> 2.43.0
>

Cheers, Lorenzo

