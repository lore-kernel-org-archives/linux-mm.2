Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64F14FEFB51
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:42:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D01D06B00E9; Fri, 27 Feb 2026 15:42:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD6146B00EB; Fri, 27 Feb 2026 15:42:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC2136B00EC; Fri, 27 Feb 2026 15:42:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AADC06B00E9
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:42:32 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 533718C5A3
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:42:32 +0000 (UTC)
X-FDA: 84491409744.11.93FD452
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4052F40008
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:42:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UhCktEIb;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772224950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SsfMWNXjgJqQSqlAr8CeRmyug8KPYhUAxdXhYK5qcVk=;
	b=UgEXmbOFtoZ7btE3+3d4iYxcJHZKf/3lWqHOQBFEkNOuCLCyaUeWgOs+eKMbptuljS9Apr
	h4fIc3u8//5h/8p0YEAx90vpuO08qgUY+kU+i7utaq8MJzKpwNpgdTG6qQqsinmqv98ZoU
	6R8y2YANr2IU8UksknYHaUDCHECWano=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UhCktEIb;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772224950; a=rsa-sha256;
	cv=none;
	b=2AXbUgAdBG2UrHHyv9WbdDJn87zBK4zuShtdP2EO5W0CZG+XJyd64pSMjxrKcwz9es4qo3
	OrL2j5uA8IIdyWhMAgXgQP6GOglIbV+1zzJj9j3Q88yRLl0+bqZlH4CQ/XUZFebcPfMupz
	6HG2iaokJouLKMUwBoofHdSWibKEnJQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A47742B7F;
	Fri, 27 Feb 2026 20:42:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C769C19423;
	Fri, 27 Feb 2026 20:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772224949;
	bh=HoDEtvg3GBOF96zWJnOOBK0G0fY86adGkY74DzxijNk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UhCktEIbAUDL9Zi2WQd3Bw9EURAPYLxkgEpK+CsepI+fOXULQE8JgHg1vl8KSTp23
	 BLuUmlh415T01I4XECWLf4lkEYQfVTIHjBO1HWl+Gf1rcinKdsgi9q7UwyEy2uBgBc
	 hdRSm4apydFPE08ex7f+FZgXbuXgU9FwuiYun8IavC+GtzddnGybOqXkl5ls345ewn
	 1ojFHG8uNnNykR7DiXj331XVtk2Yj3w9NkeK9R7V6ZwqzrjhjI6ABcik8pxPGllw2/
	 E+sRfHHAd4s2IFqMfo3SutLJVK9Zai0c+7IyApDHYdVKmZtnH7qYlA0rvLp2XdKx+m
	 JSQkELTwQxkyQ==
Message-ID: <8393137b-7eb8-4cfe-8963-ddd5ff75ef4b@kernel.org>
Date: Fri, 27 Feb 2026 21:42:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/9] mm: cma: Export cma_alloc and cma_release
To: Maxime Ripard <mripard@kernel.org>, Sumit Semwal
 <sumit.semwal@linaro.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 "T.J. Mercier" <tjmercier@google.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
 iommu@lists.linux.dev, linux-mm@kvack.org
References: <20260227-dma-buf-heaps-as-modules-v2-0-454aee7e06cc@kernel.org>
 <20260227-dma-buf-heaps-as-modules-v2-5-454aee7e06cc@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260227-dma-buf-heaps-as-modules-v2-5-454aee7e06cc@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4052F40008
X-Rspamd-Server: rspam08
X-Stat-Signature: k9bwmete7qbc56om37qfw1ddj7m6w8ig
X-HE-Tag: 1772224949-555170
X-HE-Meta: U2FsdGVkX19819OIwIe5bpTmrtXjrLy/uE00dug/jbdb4Lgq5h+KOfhEr8/YH6h7E558i8uXP1BOByUPIvJXCvYhnDoB+PBtp5VQj7cCfowMl9+EWWoV1ULt2ejzztkejNrze4IlOzgbcjacnWlzCvZxhq5rRaq9kdlPZh6UUSBy0h/DAs7/VE4P7OVdslGcfWu9TZYqNR1zv+HOW//CyRVTqbbC5D/0UY0z/u0j44W9PH4xkYtwFkQrLj1bPEvGxVAzSruvhBhn/SeG8IzXYCSm3wiuTSP32eF2E1MABvyPFJxbCz+cfj9K5ofVCOpUk7EmrDEj9a4hLkLav8YMIUOTxLKttpP5gPqbxxcN2+jDCQafXDSbPl+FsuE2TgQzgo7Dk0A4iNnhW7etnrhDdcKFaKHUL62/rNJZRO0cLsAvu8LEhsvTt8pRDN/8tAQYhhvmR18JbGJw2/DYT9aeguNthrE1b56nh0zfGXL5qmjdEZahwyVuPYNsMtebI0QTC35ukwW0BQ2Rpdqk4Jp+D2wqTjSYhIwNquN/OuTwuvzYaB6T/OR4EoTKRgy52J3AHQ1t4fEIn8viQVYTxO6fsFjhsaTUps6h1xfnXlHhNuIqhBiTmTz6QdsF8sfAf1MUm5EQcDdWbXZxsayoia5DQPIAx6wQkCn08wKkJ84JeQWQc6rkE0T80JnjfnlHLB7CUdC6oBv5d9WWAt5iCotj49HmbXX4TwYTzGuP1fjP9i0ER/qY1IWOTkeRmGLXb7B2tQCPoftSssyRIvFddONahP4Gyin6J7SxzMTr53NP1WQmt+4gCWPHEY4mouG56BSAog5S973YLTYP9u0jikKQOk1Ewp57L4Xh+YvZdtX4RPZUbQdcv7+0pesrYWLXsaGRHuhZqAZtwLvAgtDdM51mqsJPlLuuBdNrRdwXETVqaIYpMzdWGcYhJMTWU9edzCVmhcOzXy5DM/S0cg2CS4I
 irIBr+Oj
 v22FgpuDFbrWcCpWonGFLcSpmBTBwODURQhGcTM6Hi99E+LUEEygekkmQlEUmNdFM6cmzgr0VBkrjapnnT+OgTWOiIHmwt48M8JXz5h+o6R69EhKRyMM/qf6Zofbr43ByxGJz5HORXTkDkS4MjvqCPp/LCHoeFJhARv4sfJbefB1y8zVA2zEhXsoPtNQDbFB64wK53+etVjCA5mQ9N0LfuZsPgMFtMbghCQj1K1AyBeX7icKWeB2/4qHxioA3BmxmpF9ksaBW7kuRM0205EK3EgzpmH3J023PfnsgokRQuLOLOqUynDeRrVelkAPKwAlNkl6rDNlDTp+vYwaNVBaq4Wq+Qzh0fe4UQlrz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 14:15, Maxime Ripard wrote:
> The CMA dma-buf heap uses cma_alloc() and cma_release() to allocate and
> free, respectively, its CMA buffers.
> 
> However, these functions are not exported. Since we want to turn the CMA
> heap into a module, let's export them both.
> 
> Reviewed-by: T.J. Mercier <tjmercier@google.com>
> Signed-off-by: Maxime Ripard <mripard@kernel.org>
> ---
>  mm/cma.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/cma.c b/mm/cma.c
> index 94b5da468a7d719e5144d33b06bcc7619c0fbcc9..be142b473f3bd41b9c7d8ba4397f018f6993d962 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -949,10 +949,11 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
>  	if (page)
>  		set_pages_refcounted(page, count);
>  
>  	return page;
>  }
> +EXPORT_SYMBOL_GPL(cma_alloc);
>  
>  static struct cma_memrange *find_cma_memrange(struct cma *cma,
>  		const struct page *pages, unsigned long count)
>  {
>  	struct cma_memrange *cmr = NULL;
> @@ -1025,10 +1026,11 @@ bool cma_release(struct cma *cma, const struct page *pages,
>  
>  	__cma_release_frozen(cma, cmr, pages, count);
>  
>  	return true;
>  }
> +EXPORT_SYMBOL_GPL(cma_release);
>  
>  bool cma_release_frozen(struct cma *cma, const struct page *pages,
>  		unsigned long count)
>  {
>  	struct cma_memrange *cmr;
> 

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

