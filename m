Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94C14CCA468
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 09:56:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1BB48E000C; Tue, 30 Sep 2025 05:56:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCEA58E0002; Tue, 30 Sep 2025 05:56:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B93568E000C; Tue, 30 Sep 2025 05:56:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9EAF38E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:56:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4E52F44560
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 09:56:22 +0000 (UTC)
X-FDA: 83945461404.24.7027149
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id D716C180007
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 09:56:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hwvT9uI8;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759226180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+QgHcqspKT2GXj7ZlkmHs/LfEpnq5kh/ITrLwNGLIHs=;
	b=eQNnGP6Cg8nBE2dzhdSnjwje8dR35BkBxWuy4EqkDCl7CyDrXTXodE3/vRH2rFv6CIlJEO
	weArtP53sYIRgwJphNR1raBQiD/8FX7kaHiHCSYU0MHmwopg68xmaRtPHAG96nb7htp8lm
	CyDuv/87CVo9Le6v87nVz3s/TVBCRGU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hwvT9uI8;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759226180; a=rsa-sha256;
	cv=none;
	b=XUmmqlDbRAKoOaR7sZ/U5YUaGidc8PUyLapYxNQqeF/ZQUQ7RWxxKf5b/RDR+zYGQciz2O
	7bc37Wk78PhA7TvgG0QQ3038yToqnI3XRlcXym2BKdzuLf31x94LBHlceCLlN0kEtU1JA5
	OYl3/Ee0HdCjm3VOsm+1kK7iHuXrlws=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759226179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+QgHcqspKT2GXj7ZlkmHs/LfEpnq5kh/ITrLwNGLIHs=;
	b=hwvT9uI8dUGe3ll4ysFDs1X/70dASj+zIfBETbn1THjhsIw408/Fxgd97rJguc0EQCh066
	yBPSuHeXB3f3QpLm1v4fspwF2cEPJcTFDSe8FPQ5mfF8vdNu5XT5UibLQ27RTOCZGwzDLA
	qfqEkFlgSL3Uw7T2U9X5edkx43+6gBw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-601-nLeeatV7N4O5S_EVdGIe9Q-1; Tue, 30 Sep 2025 05:56:17 -0400
X-MC-Unique: nLeeatV7N4O5S_EVdGIe9Q-1
X-Mimecast-MFC-AGG-ID: nLeeatV7N4O5S_EVdGIe9Q_1759226176
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42421b15185so487653f8f.1
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:56:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759226176; x=1759830976;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+QgHcqspKT2GXj7ZlkmHs/LfEpnq5kh/ITrLwNGLIHs=;
        b=tHcM63NGUz21F87GqS9WwlC/c0claTJglrmNLMqVGhJ8jEpIV4FJwJyIndCAGHY16L
         ABOh+LgX7UC2R7ipCsALTBnBhl03Q6YSThl26BROsFv7lRq/gaC+MtIj8bFTjAOyTDzq
         W9ZkkYw3q6u7jVSkfffFcPzhc7UYDnScWFhUCtQdcExfmhywsVeRREu4K0WWveNz/6hT
         fTCqXsEwoGwYrI0zR9I65kkJMZi28Q/4pUaRYrLbqfqOQbs2F5qIYEXXW5IA8+nztVPS
         5m2ERqofQGcO3Mp8My1v0RWM/JKbvLCzVb5XJ45yYJ2JJIN6aMxRPFLlN1TOv3/9D7BW
         o48w==
X-Forwarded-Encrypted: i=1; AJvYcCWcgiKKFmLHkPjv7hJpBsNr+/Ete68hxjE05f8UDxBeTeHJ6DbZLyVeNDWv2J7wxrFBgZIWr9dEvQ==@kvack.org
X-Gm-Message-State: AOJu0YxAp0Kf0jqy2sGZ1gj1dcGcDFsPzd2gMVFWDOfxJdzcqKEbNyyA
	ijYmoJ1Wiiu/QLZRscCGnaRhOAlEtbEtPT75t1pKMqSskQC8gSrH8UBuQMwF0iN/n8H7PU+HnyK
	GWjZ0ZWkCtpBgu1qZGcsIYI1shruAzCd3BOV7bEBY6FWtAefc33vA
X-Gm-Gg: ASbGncvVxooxwA0U8F+SKjjt94kUi3hGUnCviy37f50gB7VlIZk7OWdZncyAYgPFJMp
	yngy97jl4eUAadzCGBWj8YjobaAQBLR6xcpUU91azA+Gm4bg2UOP8P/LwxcCNR5BdJPU3y1beVD
	wZKxl+1F5UM1Sjtj060OvSke/JVHyLrupFtdPlrDVwJhEGsLy8mZ+aROxQSwUjxQpB/sal6qwkV
	9Miu/ax64wEytHsoebZY4stSSATjnEYNE6dTXG6Dv42G/+FYDvjdPo/SsV6QnHvWinR5PdicM+j
	LH7ZRKMUMtomOvAAyBCpET7S/Y1BY2ez7V/aWS0JEpZw9u7+NupU8kMwaz/LLmqvt3Y729oujn7
	BGzgGwtfx
X-Received: by 2002:a05:6000:2c10:b0:3e0:a5a2:ec9b with SMTP id ffacd0b85a97d-40e49c89722mr17691851f8f.52.1759226176438;
        Tue, 30 Sep 2025 02:56:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGAJd5Q03/88CZrHbmDTWg1uT8oWRRpD9Ejp0DqzpbIyHq3RbBg4NkuFhKRg97MEa3FPxowqA==
X-Received: by 2002:a05:6000:2c10:b0:3e0:a5a2:ec9b with SMTP id ffacd0b85a97d-40e49c89722mr17691834f8f.52.1759226176046;
        Tue, 30 Sep 2025 02:56:16 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc88b0779sm21689405f8f.58.2025.09.30.02.56.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 02:56:15 -0700 (PDT)
Message-ID: <17bd2977-6a04-402f-ae84-306167cd16d6@redhat.com>
Date: Tue, 30 Sep 2025 11:56:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/8] mm: page_alloc: optimize pfn_range_valid_contig()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Muchun Song <muchun.song@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Matthew Wilcox <willy@infradead.org>
Cc: sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
References: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
 <20250918132000.1951232-2-wangkefeng.wang@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250918132000.1951232-2-wangkefeng.wang@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Te2PdwNt8kb4RmzPlQWmqF3e77uYv_pe8CDXFf5eHnQ_1759226176
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D716C180007
X-Stat-Signature: zraffkaq85q38fix5ze93n9ubfp9qkbm
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759226179-744473
X-HE-Meta: U2FsdGVkX191NFMdY7bXUMGTVV9J1XF1apAxWgc5FfUo/1XUjbVPRRfaa11IPYretY6argkkaO7WklQ086qX7/ZoxVaDKfrlwI4K+ZSTPEzFzT5xsLPGcnc98NXuKEM3QmehMZZ1V10sLt5ob/T78QuH8kUklzp3+t8JOEkDW4M564V6/7b3ZUZnNIeFtil9rp8KIqCeTi9wGSvJX4sG7AZbVqGre2FGpqOhGl05o3vqFHYGr324hKey5+7wCwJhzS0jMeVnbC5lTOQ7yQoOPTLC1jkFlLFmliRopRyVxB2SHRCd7/Icf8obHcxUr042tY6IkPzRI6rFCpGZ/VVT8RNSHgiNLGNQkTnDHIqPcuqkRvR+7vMWExQ2NimP++Jy7XnnPwjrszCJdoEa8zfWWyTemHY28gna3985v5Z+yOmfI9yrtJxv49Xq0CQVEKWWOTK9c3gJhtiyW1SblN/Dv8gx6kRj6BjlZFOuXgpRsMPhIX2s0+Pp9DLH3VgWTuT8LoEqvfnkXkXkx56DCUcx41oc4bdsNrSEx8WQHfc8ZFfD/O3j2RrzbraE8RGHQ4Z+VB2k3fpLuf3dPIN2/S4+/qWlL1mhMNrb/MGpG74nWb10u6h3Gq0IiIxuaq1DPWPpfmvjfFC8M9L/Y0A5OnMGQccq1cMSBaS7EJvAdnn9YHJt5/2GUjkF48KHyGQeC1XD1TLFELdBkWqa/S4neWA2Tt6RyhuAK9LM7c7EKnosulaI76IIfsK163gkceht3lxWec3dxn7T9ZOCHTPnde+cgrY1ya1xND4cRDobLfnboCdJNq6z2hJUrzsi+Kd5lNvIC38KL3IXXzUVHx+TnNYo0ViQE1ESeXEiUp/axL6aqLZ6ib5U46cb8ah+0B8vXfaHfMVc5ahAldtDp9Rw2L7ZXaBOCeiW3iIfT9SPvhNbZ0VFvjiUjpWkSKRtj4z94sCgIt0ZSeQjYgoiIdOuj+8
 4cmcY9Fj
 n59x0NkM/dl47uGtNR8AAXt43waftbZ1Xnq3bJ4ALbmNV32ztk+hjnnywWd8a83H3ZuWxWmaaGdkZpC33oP9Xd6ftmVEf8q6J9Zhgxue0bhBhe7zat3UtH1zBBbzURt5MATyL+RuZLXnZptpFScaGYsUeIdP/CwwFxr112tZzwF0YP8z/m+42W8kS6SefcQrq0RRgZPe4tHJBs450o7tJdZ3IQAvVPK2bo/FgUkvkItdB82oXLsgnUd5JZw3sH2TSmVehXcqTz6NdwNx48fPfZDyiSnM9UO9qMQIff37f58g2LviFNQuoL2GFOPmmkecL0Mu+6Ltq0whcFOWO/uh+lXUGogdjvlJLpNDIgTiED7Xb3Y5MFZLGbVHtBzu8CT7lzqv47B8RmF0As6d8VP/+vpSUGtvlmIqV+sqGHgLKuqWZkUmHtfx6MseZnQyA18ZZYhyXCKQ7fntyn94=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.09.25 15:19, Kefeng Wang wrote:
> The alloc_contig_pages() spends a lot of time in pfn_range_valid_contig(),
> we could check whether the page in this pfn range could be allocated
> before alloc_contig_range(), if the page can't be migrated, no further
> action is required, and also skip some unnecessary iterations for
> compound pages such as THP and non-compound high order buddy, which
> save times a lot too. The check is racy, but the only danger is skipping
> too much.
> 
> A simple test on machine with 116G free memory, allocate 120 * 1G
> HugeTLB folios(107 successfully returned),
> 
>    time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
> 
> Before: 0m2.124s
> After:  0m0.602s
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>   mm/page_alloc.c | 20 ++++++++++++++++++--
>   1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 478beaf95f84..5b7d705e9710 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7012,6 +7012,7 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>   {
>   	unsigned long i, end_pfn = start_pfn + nr_pages;
>   	struct page *page;
> +	struct folio *folio;
>   
>   	for (i = start_pfn; i < end_pfn; i++) {
>   		page = pfn_to_online_page(i);
> @@ -7021,11 +7022,26 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>   		if (page_zone(page) != z)
>   			return false;
>   
> -		if (PageReserved(page))
> +		folio = page_folio(page);
> +		if (folio_test_reserved(folio))
>   			return false;
>   
> -		if (PageHuge(page))
> +		if (folio_test_hugetlb(folio))
>   			return false;
> +
> +		/* The following type of folios aren't migrated */
> +		if (folio_test_pgtable(folio) | folio_test_stack(folio))
> +			return false;
> +

I don't enjoy us open coding this here. has_unmovable_pages() has a much 
better heuristics.

I suggest you drop this patch for now from this series, as it seems to 
be independent from the rest, and instead see if you could reuse some of 
the has_unmovable_pages() logic instead.

-- 
Cheers

David / dhildenb


