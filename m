Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A261C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 09:46:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6321A6B0098; Mon, 14 Sep 2026 05:46:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E22D6B0099; Mon, 14 Sep 2026 05:46:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AA476B009B; Mon, 14 Sep 2026 05:46:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 179036B0098
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 05:46:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 788BBA3FF0
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:46:02 +0000 (UTC)
X-FDA: 85211886564.04.F98693F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id C907640004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:46:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IeeTb+Rp;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789379160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EVDkiB/u4ANeDZ9eCMi1XniQjxMrh+Q0HF16352Y+vY=;
	b=B5xQ4jsVAtKrRLeyi1fQwcLSLFJmvOVCAaDDIlHraI1uYomK0tDfCdaM7ZYvDNJQeLzz3x
	kbCdSl9YYO8jqf+pSV8jbfwyvbQQg1GPnaB/57GCkH045yratBfhwj3et7HPXHhN75iVZ4
	BfjBdGSBgqlBlHEF5MFM/dR5fyq8UMM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789379160;
	b=XMGBgkrdZOuHGyT1gWngXOWf5yO5N9QrASNyyIjeTr5/PBGmDPp4cQwjl8r1gwKsdgsRCm
	wAeHzemy9ZvnHYBv2Y+e1MlF12mEEeOQAsBasbSuP14d5PsXwN7flIxGlyI7VKpo3AaAGP
	72qxoKf05dk+S8nHKaxkLHkWfTsNgyU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IeeTb+Rp;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EED6F433AB;
	Mon, 14 Sep 2026 09:45:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F441F000FF;
	Mon, 14 Sep 2026 09:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789379159;
	bh=EVDkiB/u4ANeDZ9eCMi1XniQjxMrh+Q0HF16352Y+vY=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=IeeTb+RpcbpF5esAjySgSwSY1qum2m+Nl37yAGe+xj2Q80HbvcdFIPGVCMNU3KVoP
	 uQZEQ4Zuotcba9TqQozTwh2LrGjGKJPKhXFJ6iNaGTuzV09TqvnoWOCiovZ4quMCqn
	 RUou07J5p1hWTRWC4xbxvqHxY1nHDWgzQVwFrYR2aYq6kSC1T7feIrJ3mBjAP89ABx
	 zULlCo7YhYc4TVfLt5wyBclswaBvD5+BMRkoSl+9VqLLT9fj2peM+RfWrITkyzkIgl
	 6JeugRRhmyAowxIl/JDFveZvlajXG0c7bBMoDhp4khpIOijYILwBxauL6BktzhgUAv
	 LAz122LENS5WA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 02/12] mm/sparse: refactor sparse_sections_init()
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org, 
 driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-2-008fc8d579fe@kernel.org>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-2-008fc8d579fe@kernel.org>
Date: Mon, 14 Sep 2026 12:45:42 +0300
Message-Id: <178937914266.4188640.15458944773619773879.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: 6tuo9yko9hc5a1a1okwdb8zsqng36nq9
X-Rspam-User: 
X-Rspamd-Queue-Id: C907640004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789379160-516995
X-HE-Meta: U2FsdGVkX1+cBQly0gz88Z/yOSLNiHtIpXJ9iqOt16sMzl++8NsBoNRcqM5TJqm1BZtXVW4Jdr5XUGdTwov7/QSOEDniJrtm6rTK9nx+oQXScC/OToWk67JzuOJtdB8l/3mp7nAN7RvrolD16bbzBkgOTCrBemR19ZibGTXh16p17IAGD2UMWO6fzkklXndlj1X8rNR80kOVeD0byEHkmpjL0vFPwNch/RlbjWDNy2WJh52z5Gg+temrPpxzbSUlfPw8mnvS7+Oz8RJ2lGiIs2v+pH8CkD8LZzUnm2DsbPi26PADfsEZb0HF0/0PG6CnkfXMPU1p20xVKeQtgsWnEAMqQKthgAcgBGbV9lcxnMpOJG3WK8qb4CbLikFPWStwtg9ThPL7tsUGl/QTjVLCk610zaLvJU28nx/bZnxLd8Ygc95isn2sBFt2l5MDiP01xxPzz47NlUiZwR1xrhQvG6Txf9rTT3jkfulHuORfmpyQwNaI+Aatigs1LUoYP8KFd+ZMSNvceuTzN6ThXbKeLM7IDVumJes0FHQtGMn/uEq2JZ/YbhKPXZhFfUJnjKJcU6B5C6A50xSaFWZhsusktDBbDXxu2ZPZMN8scz6eLhbfa86IcPzuJftz8/sb4p8CdCzlWTWqX+EzMGbGft5B4fixbG3XIIoLpzYDx5kV6+6HCZoyAqmwQAqS+tew8HszQ9DvQxOHHASrOsBgSrO36a64bn87lVj5/CzCdUMjenUnVN1HsXu1nigbL4nEdx1/mYDBh49DVdkyClbMK6ZoxYdUmu/k2UFPp3UsBKoPuUjRav/VBMgZtOrfLClqS5BNB9tTmiIz/1sM7iH+iW+CRfWG6MbFw8/9EaWsK9L7bt8gzfGHvPORnFZRMAN6JxaGxDZrRmPgku0Tz86rifuddJnpKU62GNYRAJcBYs6LAoFwA4d4ml21KLRL7iYUu8dakGzMesL4ikGHqzltArz
 Fuh77uE7
 A3P11k9ltYkwy39F64Xd2GfHab5Hr/BY2AQWiDJqwKFqJGgHJoqoB3LUsmbfhOLJ29LMauqjnYFuwPq8vRVrjX2D3lQVT+gbYrasdZJuZztQRENR88wYLj63/y/ldE272jrIfJy/rzSujnsif7PYS28VZsR7gyn5MLVdB+Nl64ureZREFb6SH/mxKqEG5aWpVUlAEGeb6hyoFKcEXIjGuTT6iu+ybt5BkdocEzq4Wf2DhoEz0csPzidjXQWdMJ8EeKqvOoVsw09z+7Ma30BfNv1EOb2ZiulfbLRwI6OND9+HvVpSz0W3PUaQhwtoGidj2jnfw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> memory_present() really identifies+prepares all early sections so the
> initialization in sparse_init() can properly iterating them to

Nit:                                           ^ iterate

> initialize metadata.
> 
> Let's just inline memory_present() into sparse_sections_init() and
> cleaning up the code a bit while at it: make it clear that we are operating

 ^ clean

> on pfns.
> 
> Note that we call set_section_nid() now only if the section
> was not already created earlier. Now, there is no more inconsistency
> between what we (temporarily) store in ms->section_mem_map and what
> we store in our section->nid array.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 6a6d258862904..36e3d854febc5 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -179,22 +179,27 @@ static inline unsigned long first_present_section_nr(void)
>  	return next_present_section_nr(-1);
>  }
>  
> -/* Record a memory area against a node. */
> -static void __init memory_present(int nid, unsigned long start, unsigned long end)
> +void __init sparse_sections_init(void)
>  {
> -	unsigned long pfn;
> +	unsigned long pfn, start_pfn, end_pfn;
> +	int i, nid;
> +
> +	sparse_extreme_init();
>  
> -	start &= PAGE_SECTION_MASK;
> -	mminit_validate_memmodel_limits(&start, &end);
> -	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
> -		unsigned long section_nr = pfn_to_section_nr(pfn);
> -		struct mem_section *ms;
> +	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
> +		start_pfn &= PAGE_SECTION_MASK;
> +		mminit_validate_memmodel_limits(&start_pfn, &end_pfn);
>  
> -		sparse_index_init(section_nr, nid);
> -		set_section_nid(section_nr, nid);
> +		for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
> +			unsigned long section_nr = pfn_to_section_nr(pfn);
> +			struct mem_section *ms;
>  
> -		ms = __nr_to_section(section_nr);
> -		if (!ms->section_mem_map) {
> +			sparse_index_init(section_nr, nid);
> +			ms = __nr_to_section(section_nr);
> +			if (ms->section_mem_map)
> +				continue;
> +
> +			set_section_nid(section_nr, nid);
>  			ms->section_mem_map = sparse_encode_early_nid(nid) |
>  							SECTION_IS_ONLINE;
>  			__section_mark_present(ms, section_nr);
> @@ -202,18 +207,6 @@ static void __init memory_present(int nid, unsigned long start, unsigned long en
>  	}
>  }
>  
> -/* Initialize memory section metadata for all system memory. */
> -void __init sparse_sections_init(void)
> -{
> -	unsigned long start, end;
> -	int i, nid;
> -
> -	sparse_extreme_init();
> -
> -	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid)
> -		memory_present(nid, start, end);
> -}
> -
>  #ifndef CONFIG_SPARSEMEM_VMEMMAP
>  struct page __init *__populate_section_memmap(unsigned long pfn,
>  		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


